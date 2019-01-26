-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db, em, gui, obj = MayronUI:GetCoreComponents();

namespace.dataTextLabels = {
    -- svName = Label
    ["combatTimer"]       = "Combat Timer",
    ["currency"]          = "Currency",
    ["durability"]        = "Durability",
    ["friends"]           = "Friends",
    ["guild"]             = "Guild",
    ["inventory"]         = "Inventory",
    ["memory"]            = "Memory",
    ["performance"]       = "Performance",
    ["specialization"]    = "Specialization",
    ["none"]              = "None"
};

-- Objects -----------------------------

local Engine = obj:Import("MayronUI.Engine");
local SlideController = obj:Import("MayronUI.Widgets.SlideController");

-- Register Modules --------------------

local C_DataTextModule = MayronUI:RegisterModule("DataText", "Data Text Bar");
namespace.C_DataTextModule = C_DataTextModule;

-- Load Database Defaults --------------

db:AddToDefaults("profile.datatext", {
    enabled       = true;
    frameStrata   = "MEDIUM";
    frameLevel    = 20,
    height        = 24; -- height of data bar (width is the size of bottomUI container!)
    spacing       = 1;
    fontSize      = 11;
    blockInCombat = true;
	popup = {
		hideInCombat = true;
		maxHeight    = 250;
		width        = 200;
		itemHeight   = 26; -- the height of each list item in the popup menu
    };
    displayOrders = {
        "durability";
        "friends";
        "guild";
        "inventory";
        "memory";
        "performance";
        "specialization";
    };
});

-- IDataTextModule ------------------------------

Engine:CreateInterface("IDataTextModule", {
    -- properties:
    MenuContent = "Frame";
    MenuLabels = "table";
    TotalLabelsShown = "number";
    HasLeftMenu = "boolean";
    HasRightMenu = "boolean";
    Button = "Button";
    SavedVariableName = "string";

    -- functions:
    Update = "function";
    Click = "function";
    IsEnabled = {type = "function"; returns = "boolean"};
    Disable = "function";
    Enable = "function";
});

-- C_DataTextModule Functions -------------------

function C_DataTextModule:OnInitialize(data)
    data.buiContainer = _G["MUI_BottomContainer"]; -- the entire BottomUI container frame
    data.resourceBars = _G["MUI_ResourceBars"]; -- the resource bars container frame
    data.lastButtonClicked = ""; -- last data text button clicked on
    data.buttons = obj:PopWrapper();
    data.DataModules = obj:PopWrapper(); -- holds all data text modules

    local setupOptions = {
        dependencies = {
            ["spacing"] = "displayOrders";
        };
    };

    self:RegisterUpdateFunctions(db.profile.datatext, {
        frameStrata = function(value)
            data.bar:SetFrameStrata(value);
        end;

        frameLevel = function(value)
            data.bar:SetFrameLevel(value);
        end;

        height = function(value)
            data.bar:SetHeight(value);
            local actionBarPanelModule = MayronUI:ImportModule("BottomUI_ActionBarPanel");

            if (actionBarPanelModule:IsEnabled()) then
                actionBarPanelModule:SetupAllBartenderBars(data);
            end
        end;

        spacing = function()
            self:PositionDataTextButtons();
        end;

        fontSize = function(value)
            for _, btn in ipairs(data.buttons) do
                local font = tk.Constants.LSM:Fetch("font", db.global.core.font);
                btn:GetNormalFontObject():SetFont(font, value);
            end
        end;

        popup = {
            hideInCombat = function(value)
                if (value) then
                    em:CreateEventHandlerWithKey("PLAYER_REGEN_DISABLED", "hideInCombat_RegenDisabled", function()
                        _G["MUI_DataTextPopupMenu"]:Hide();
                    end);
                else
                    em:DestroyEventHandlerByKey("hideInCombat_RegenDisabled");
                end
            end;

            width = function(value)
                data.popup:SetWidth(value);
            end;
        };

        -- TODO: Not sure what to do about this... (maybe displayOrders = function(path/key, value) ?)
        displayOrders = function()
            self:OrderDataTextButtons();
        end;
    }, setupOptions);
end

function C_DataTextModule:OnInitialized(data)
    if (data.settings.enabled) then
        self:SetEnabled(true);
    end
end

function C_DataTextModule:OnEnable(data)
    -- the main bar containing all data text buttons
    data.bar = tk:PopFrame("Frame", data.buiContainer);
    data.bar:SetPoint("BOTTOMLEFT");
    data.bar:SetPoint("BOTTOMRIGHT");
    tk:SetBackground(data.bar, 0, 0, 0);

    data.resourceBars:SetPoint("BOTTOMLEFT", data.bar, "TOPLEFT", 0, -1);
    data.resourceBars:SetPoint("BOTTOMRIGHT", data.bar, "TOPRIGHT", 0, -1);

    -- create the popup menu (displayed when a data item button is clicked)
    -- each data text module has its own frame to be used as the scroll child
    data.popup = gui:CreateScrollFrame(tk.Constants.AddOnStyle, data.buiContainer, "MUI_DataTextPopupMenu");
    data.popup:SetFrameStrata("DIALOG");
    data.popup:EnableMouse(true);
    data.popup:Hide();

    -- controls the Esc key behaviour to close the popup (must use global name)
    table.insert(_G.UISpecialFrames, "MUI_DataTextPopupMenu");

    data.popup.ScrollBar:SetPoint("TOPLEFT", data.popup, "TOPRIGHT", -6, 1);
    data.popup.ScrollBar:SetPoint("BOTTOMRIGHT", data.popup, "BOTTOMRIGHT", -1, 1);

    data.popup.bg = gui:CreateDialogBox(tk.Constants.AddOnStyle, data.popup, "High");
    data.popup.bg:SetPoint("TOPLEFT", 0, 2);
    data.popup.bg:SetPoint("BOTTOMRIGHT", 0, -2);

    data.popup.bg:SetGridColor(0.4, 0.4, 0.4, 1);
    data.popup.bg:SetFrameLevel(1);

    data.popup:SetScript("OnHide", function()
		-- when popup is closed by user
        if (data.dropdowns) then
		-- popup menu content has dropdown menu's
            for _, dropdown in ipairs(data.dropdowns) do
				gui:FoldAllDropDownMenus();
                dropdown:GetFrame().menu:Hide();
            end
        end
    end);

	-- provides more intelligent scrolling (+ controls visibility of scrollbar)
    data.slideController = SlideController(data.popup);
end

--TODO: Problem - this gets called each time a module is loaded - loops over all models when ordering buttons  many times!
Engine:DefineParams("IDataTextModule");
function C_DataTextModule:RegisterDataModule(data, dataModule)
    local dataModuleName = dataModule:GetObjectType(); -- get's name of object/module
    data.DataModules[dataModuleName] = dataModule;

    local dataTextButton = dataModule.Button;

    dataTextButton:SetScript("OnClick", function(_, ...)
        self:ClickModuleButton(dataModule, dataTextButton, ...);
    end);
end

Engine:DefineReturns("Button");
function C_DataTextModule:CreateDataTextButton(data)
    local btn = _G.CreateFrame("Button");
    local btnTextureFilePath = tk.Constants.AddOnStyle:GetTexture("ButtonTexture");
    btn:SetNormalTexture(btnTextureFilePath);
    btn:GetNormalTexture():SetVertexColor(0.08, 0.08, 0.08);

    btn:SetHighlightTexture(btnTextureFilePath);
    btn:GetHighlightTexture():SetVertexColor(0.08, 0.08, 0.08);
    btn:SetNormalFontObject("MUI_FontNormal");

    table.insert(data.buttons, btn);
    return btn;
end

-- this is called each time a datatext module is registered
function C_DataTextModule:OrderDataTextButtons(data)
    data.orderedButtons = data.orderedButtons or obj:PopWrapper();
    data.positionedButtons = data.positionedButtons or obj:PopWrapper();

    for _, dataModule in pairs(data.DataModules) do
        if (dataModule:IsEnabled()) then
            local btn = dataModule.Button;
            local dbName = dataModule.SavedVariableName;
            local displayOrder = tk.Tables:GetIndex(data.settings.displayOrders, dbName);

            if (displayOrder and not data.positionedButtons[dbName]) then
                -- ensure that buttons are only ordered once!
                table.insert(data.orderedButtons, displayOrder, btn);
                data.positionedButtons[dbName] = true;

                dataModule:Update();
            end
        end
    end
end

function C_DataTextModule:PositionDataTextButtons(data)
    local itemWidth = data.buiContainer:GetWidth() / #data.orderedButtons;
    local previousButton;

    for _, btn in ipairs(data.orderedButtons) do
        btn:SetParent(data.bar);
        btn:ClearAllPoints();
        btn:Show();

        if (not previousButton) then
            btn:SetPoint("BOTTOMLEFT", data.settings.spacing, 0);
            btn:SetPoint("TOPRIGHT", data.bar, "TOPLEFT", itemWidth - data.settings.spacing, - data.settings.spacing);
        else
            btn:SetPoint("TOPLEFT", previousButton, "TOPRIGHT", data.settings.spacing, 0);
            btn:SetPoint("BOTTOMRIGHT", previousButton, "BOTTOMRIGHT", itemWidth, 0);
        end

        previousButton = btn;
    end
end

Engine:DefineParams("Frame");
-- Attach current dataTextModule scroll child onto shared popup and hide previous scroll child
function C_DataTextModule:ChangeMenuContent(data, content)
    local oldContent = data.popup.ScrollFrame:GetScrollChild();

    if (oldContent) then
        oldContent:Hide();
    end

    content:SetParent(data.popup);
    content:SetSize(data.popup:GetWidth(), 10);

    -- attach scroll child to menu frame container
    data.popup.ScrollFrame:SetScrollChild(content);
    content:Show();
end

Engine:DefineParams("table");
function C_DataTextModule:ClearLabels(_, labels)
    if (not labels) then
        return
    end

    for _, label in ipairs(labels) do
        if (label.name) then label.name:SetText(""); end
        if (label.value) then label.value:SetText(""); end

        if (label.dropdown) then
            label.dropdown:Hide();
        end
    end
end

Engine:DefineParams("IDataTextModule");
Engine:DefineReturns("number");
-- returned the total height of all labels
-- total height is used to controll the dynamic scrollbar
function C_DataTextModule:PositionLabels(data, dataModule)
    local totalLabelsShown = dataModule.TotalLabelsShown;
    local labelHeight = data.settings.popup.itemHeight;

    if (totalLabelsShown == 0) then
        return 0;
    end

    local totalHeight = 0;

    for i = 1, totalLabelsShown do
        local label = dataModule.MenuLabels[i];
        local labelType = type(label);

        obj:Assert(labelType ~= "nil", "Invalid total labels to show.");

        if (labelType == "table" and label.GetObjectType) then
            labelType = label:GetObjectType();
        end

        if (labelType == "DropDownMenu") then
            label = label:GetFrame();
            labelType = label:GetObjectType();
        end

        obj:Assert(labelType == "Frame" or labelType == "Button",
            "Invalid data-text label of type '%s' at index %s.", labelType, i);

        if (i == 1) then
            label:SetPoint("TOPLEFT", 2, 0);
            label:SetPoint("BOTTOMRIGHT", dataModule.MenuContent, "TOPRIGHT", -2, - labelHeight);
        else
            local previousLabel = dataModule.MenuLabels[i - 1];

            if (previousLabel:IsObjectType("DropDownMenu")) then
                previousLabel = previousLabel:GetFrame();
            end

            label:SetPoint("TOPLEFT", previousLabel, "BOTTOMLEFT", 0, -2);
            label:SetPoint("BOTTOMRIGHT", previousLabel, "BOTTOMRIGHT", 0, -(labelHeight + 2));
        end

        if (totalLabelsShown and (i > totalLabelsShown)) then
            label:Hide();
        else
            label:Show();
            totalHeight = totalHeight + labelHeight;

            if (i > 1) then
                totalHeight = totalHeight + 2;
            end
        end
    end

    dataModule.MenuContent:SetHeight(totalHeight);
    return totalHeight;
end

Engine:DefineParams("IDataTextModule", "Button");
function C_DataTextModule:ClickModuleButton(data, dataModule, dataTextButton, button, ...)
    _G.GameTooltip:Hide();
    dataModule:Update(data);
    data.slideController:Stop();

    local buttonDisplayOrder = tk.Tables:GetIndex(data.settings.displayOrders, dataModule.SavedVariableName);

    if (data.lastButtonID == buttonDisplayOrder and data.lastButton == button and data.popup:IsShown()) then
        -- clicked on same dataTextModule button so close the popup!

        -- if button was rapidly clicked on, reset alpha
        data.popup:SetAlpha(1);
        gui:FoldAllDropDownMenus(); -- fold any dropdown menus (slideController is not a dropdown menu)
        data.slideController:Start(SlideController.Static.FORCE_RETRACT);

        --tk.UIFrameFadeOut(data.popup, 0.3, data.popup:GetAlpha(), 0);
        _G.PlaySound(tk.Constants.CLICK);
        return;
    end

    -- update last button ID that was clicked (use display order for this)
    data.lastButtonID = buttonDisplayOrder;
    data.lastButton = button;

    -- a different dataTextModule button was clicked on!
    -- reset popup...
    data.popup:Hide();
    data.popup:ClearAllPoints();

    -- handle type of button click
    if ((button == "RightButton" and not dataModule.HasRightMenu) or
        (button == "LeftButton" and not dataModule.HasLeftMenu)) then
        -- execute dataTextModule specific click logic
        dataModule:Click(button, ...);
        return;
    end

    -- update content of popup based on which dataTextModule button was clicked
    self:ChangeMenuContent(dataModule.MenuContent);
    self:ClearLabels(dataModule.MenuLabels);

    -- execute dataTextModule specific click logic
    local cannotExpand = dataModule:Click(button, ...);

    if (cannotExpand) then
        return;
    end

    -- calculate new height based on number of labels to show
    local totalHeight = self:PositionLabels(dataModule) or data.settings.popup.maxHeight;
    totalHeight = (totalHeight < data.settings.popup.maxHeight) and totalHeight or data.settings.popup.maxHeight;

    -- move popup menu higher if there are resource bars displayed
    local offset = data.resourceBars:GetHeight();

    -- update positioning of popup menu based on dataTextModule button's location
    if (buttonDisplayOrder == #data.orderedButtons) then
        -- if button was the last button displayed on the data-text bar
        data.popup:SetPoint("BOTTOMRIGHT", dataTextButton, "TOPRIGHT", -1, offset + 2);
    elseif (buttonDisplayOrder == 1) then
        -- if button was the first button displayed on the data-text bar
        data.popup:SetPoint("BOTTOMLEFT", dataTextButton, "TOPLEFT", 1, offset + 2);
    else
        -- if button was not the first or last button displayed on the data-text bar
        data.popup:SetPoint("BOTTOM", dataTextButton, "TOP", 0, offset + 2);
    end

    -- begin expanding the popup menu
    data.slideController:Hide();
    data.slideController:SetMaxHeight(totalHeight);
    data.slideController:Start(SlideController.Static.FORCE_EXPAND);

    _G.UIFrameFadeIn(data.popup, 0.3, 0, 1);
    _G.PlaySound(tk.Constants.CLICK);
end

Engine:DefineParams("string");
function C_DataTextModule:ForceUpdate(data, dataModuleName)
    data.DataModules[dataModuleName]:Update();
end

Engine:DefineReturns("boolean");
function C_DataTextModule:IsShown(data)
    return (data.bar and data.bar:IsShown()) or false;
end

Engine:DefineReturns("Frame");
function C_DataTextModule:GetDataTextBar(data)
    return data.bar;
end