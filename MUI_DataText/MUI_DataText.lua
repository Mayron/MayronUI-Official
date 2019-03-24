-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local _G, MayronUI = _G, _G.MayronUI;
local tk, db, em, gui, obj = MayronUI:GetCoreComponents();

local pairs, ipairs, table, GameTooltip, PlaySound = _G.pairs, _G.ipairs, _G.table, _G.GameTooltip, _G.PlaySound;
local CreateFrame, UIFrameFadeIn = _G.CreateFrame, _G.UIFrameFadeIn;

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
    ["none"]              = "None";
    ["disabled"]          = "Disabled"
};

-- Objects -----------------------------

local Engine = obj:Import("MayronUI.Engine");
local ComponentsPackage = obj:CreatePackage("DataTextComponents", "MayronUI");
local SlideController = obj:Import("MayronUI.Widgets.SlideController");

-- Register Modules --------------------

---@class DataTextModule : BaseModule
local C_DataTextModule = MayronUI:RegisterModule("DataTextModule", "Data Text Bar");

namespace.C_DataTextModule = C_DataTextModule;
namespace.ComponentsPackage = ComponentsPackage;

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
        "currency";
        "performance";
        "specialization";
    };
});

-- IDataTextComponent ------------------------------

---@class IDataTextComponent : Object
---@field MenuContent Frame The frame containing all popup menu content
---@field MenuLabels table A table containing all menu labels to show
---@field TotalLabelsShown number The total menu labels to show on the popup menu
---@field HasLeftMenu boolean True if the data-text button has a left click action
---@field HasRightMenu boolean True if the data-text button has a right click action
---@field Button Button The data-text button widget
---@field SavedVariableName string The database key associated with the data text module

ComponentsPackage:CreateInterface("IDataTextComponent", {
    -- fields:
    MenuContent = "?Frame";
    MenuLabels = "?table";
    SavedVariableName = "?string";
    TotalLabelsShown = "number";
    HasLeftMenu = "boolean";
    HasRightMenu = "boolean";
    Button = "Button";

    -- functions:
    Update = "function";
    Click = "function";
    IsEnabled = {type = "function"; returns = "boolean"};
    SetEnabled = "function";
    __Construct = {type = "function", params = {"table", "DataTextModule", "SlideController", "Frame"}}
});

local function IsComponentEnabled(displayOrders, moduleName)
    for _, enabledModuleName in ipairs(displayOrders) do
        if (enabledModuleName == moduleName) then
            return true;
        end
    end

    return false;
end

local function DataComponentButton_OnClick(self, ...)
    self.dataModule:ClickModuleButton(self.component, self, ...);
end

local function CreateComponent(dataTextModule, data, componentClass, componentName)
    local sv = db.profile.datatext[componentName];
    local settings;

    if (obj:IsTable(sv)) then
        sv:SetParent(db.profile.datatext);
        settings = sv:GetTrackedTable();
    else
        settings = data.settings;
    end

    local component = componentClass(settings, dataTextModule, data.slideController, data.bar);
    component.SavedVariableName = componentName;

    component.Button.dataModule = dataTextModule;
    component.Button.component = component;
    component.Button:SetScript("OnClick", DataComponentButton_OnClick);

    data.components[componentName] = component;
    data.unloadedComponents[componentName] = nil;

    return component;
end

local function LoadEnabledComponents(dataTextModule, data)
    for componentName, componentClass in pairs(data.unloadedComponents) do
        local isEnabled = IsComponentEnabled(data.settings.displayOrders, componentName);

        if (isEnabled) then
            local component = CreateComponent(dataTextModule, data, componentClass, componentName);
            component:SetEnabled(true);
        end
    end

    if (tk.Tables:IsEmpty(data.unloadedComponents)) then
        obj:PushTable(data.unloadedComponents);
        data.unloadedComponents = nil;
    end
end

-- C_DataTextModule Functions -------------------

function C_DataTextModule:OnInitialize(data)
    data.buttons = obj:PopTable();
    data.components = obj:PopTable(); -- holds all data text modules
    data.unloadedComponents = obj:PopTable();

    local options = {
        onExecuteAll = {
            ignore = {
                "spacing";
            };
        };
        groups = {
            {
                patterns = {".*"};

                value = function(_, keysList)
                    local componentName = keysList:PopFront();
                    local component = data.components[componentName];

                    if (not component) then
                        -- filter out missing update functions (such as popup settings)
                        return;
                    end

                    component:Update(true);
                end;
            };
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
                actionBarPanelModule:SetUpAllBartenderBars(data);
            end
        end;

        spacing = function()
            self:PositionDataTextButtons();
        end;

        fontSize = function(value)
            for _, btn in ipairs(data.buttons) do
                local font = tk.Constants.LSM:Fetch("font", db.global.core.font);
                btn:GetFontString():SetFont(font, value);
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

        displayOrders = function()
            self:OrderDataTextButtons();
            self:PositionDataTextButtons();
        end;
    }, options);
end

function C_DataTextModule:OnInitialized(data)
    if (data.settings.enabled) then
        self:SetEnabled(true);
    end
end

function C_DataTextModule:OnDisable(data)
    if (data.bar) then
        data.bar:Hide();
        data.popup:Hide();

        local containerModule = MayronUI:ImportModule("BottomUI_Container");
        containerModule:RepositionContent();
    end
end

function C_DataTextModule:OnEnable(data)
    if (data.bar) then
        data.bar:Show();
        local containerModule = MayronUI:ImportModule("BottomUI_Container");
        containerModule:RepositionContent();
        return;
    end

    -- the main bar containing all data text buttons
    data.bar = CreateFrame("Frame", "MUI_DataTextBar", _G["MUI_BottomContainer"]);
    data.bar:SetPoint("BOTTOMLEFT");
    data.bar:SetPoint("BOTTOMRIGHT");
    tk:SetBackground(data.bar, 0, 0, 0);

    -- create the popup menu (displayed when a data item button is clicked)
    -- each data text module has its own frame to be used as the scroll child
    data.popup = gui:CreateScrollFrame(tk.Constants.AddOnStyle, _G["MUI_BottomContainer"], "MUI_DataTextPopupMenu");
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

    local containerModule = MayronUI:ImportModule("BottomUI_Container");
    containerModule:RepositionContent();
end

Engine:DefineParams("string", "IDataTextComponent");
function C_DataTextModule:RegisterDataModule(data, moduleName, moduleClass)
    data.unloadedComponents[moduleName] = moduleClass;
end

Engine:DefineReturns("Button");
function C_DataTextModule:CreateDataTextButton(data)
    local btn = CreateFrame("Button");
    local btnTextureFilePath = tk.Constants.AddOnStyle:GetTexture("ButtonTexture");
    btn:SetNormalTexture(btnTextureFilePath);
    btn:GetNormalTexture():SetVertexColor(0.08, 0.08, 0.08);

    btn:SetHighlightTexture(btnTextureFilePath);
    btn:GetHighlightTexture():SetVertexColor(0.08, 0.08, 0.08);
    btn:SetNormalFontObject("MUI_FontNormal");
    btn:SetText(" ");

    local font = tk.Constants.LSM:Fetch("font", db.global.core.font);
    btn:GetFontString():SetFont(font, data.settings.fontSize);

    table.insert(data.buttons, btn);
    return btn;
end

-- this is called each time a datatext module is registered
function C_DataTextModule:OrderDataTextButtons(data)

    if (obj:IsTable(data.orderedButtons)) then
        tk.Tables:Empty(data.orderedButtons);
    else
        data.orderedButtons = obj:PopTable();
    end

    if (obj:IsTable(data.positionedButtons)) then
        tk.Tables:Empty(data.positionedButtons);
    else
        data.positionedButtons = obj:PopTable();
    end

    data.totalActiveButtons = 0;

    if (obj:IsTable(data.unloadedComponents)) then
        LoadEnabledComponents(self, data);
    end

    for componentName, component in pairs(data.components) do
        local isEnabled = IsComponentEnabled(data.settings.displayOrders, componentName);

        if (isEnabled) then
            local btn = component.Button;
            local dbName = component.SavedVariableName;
            local displayOrder = tk.Tables:GetIndex(data.settings.displayOrders, dbName);

            if (displayOrder and not data.positionedButtons[dbName]) then
                -- ensure that buttons are only ordered once!
                data.orderedButtons[displayOrder] = btn;
                data.positionedButtons[dbName] = true;
                data.totalActiveButtons = data.totalActiveButtons + 1;
                component:Update();
            end

        elseif (component:IsEnabled()) then
            component:SetEnabled(false);
            tk:AttachToDummy(component.Button);
        end
    end

    -- remove gaps between display orders (some might be disabled)
    tk.Tables:CleanIndexes(data.orderedButtons);
end

function C_DataTextModule:PositionDataTextButtons(data)
    local itemWidth = _G["MUI_BottomContainer"]:GetWidth() / data.totalActiveButtons;
    local previousButton, currentButton;

    -- some indexes might have a nil value as display order is configurable by the user
    for displayOrder = 1, #data.orderedButtons do
        currentButton = data.orderedButtons[displayOrder];

        if (obj:IsType(currentButton, "Button")) then
            currentButton:SetParent(data.bar);
            currentButton:ClearAllPoints();

            if (not previousButton) then
                currentButton:SetPoint("BOTTOMLEFT", data.settings.spacing, 0);
                currentButton:SetPoint("TOPRIGHT", data.bar, "TOPLEFT", itemWidth - data.settings.spacing, - data.settings.spacing);
            else
                currentButton:SetPoint("TOPLEFT", previousButton, "TOPRIGHT", data.settings.spacing, 0);
                currentButton:SetPoint("BOTTOMRIGHT", previousButton, "BOTTOMRIGHT", itemWidth, 0);
            end

            currentButton:Show();
            previousButton = currentButton;
        end
    end
end

Engine:DefineParams("Frame");
---Attach current dataTextModule scroll child onto shared popup and hide previous scroll child
---@param content Frame
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

Engine:DefineParams("IDataTextComponent");
Engine:DefineReturns("number");
---Total height is used to control the dynamic scrollbar
---@param dataModule IDataTextComponent
---@return number the total height of all labels
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

Engine:DefineParams("IDataTextComponent", "Button");
---@param dataModule IDataTextComponent The data-text module associated with the data-text button clicked on by the user
---@param dataTextButton Button The data-text button clicked on by the user
---@param buttonName string The name of the button clicked on (i.e. "LeftButton" or "RightButton")
function C_DataTextModule:ClickModuleButton(data, dataModule, dataTextButton, buttonName, ...)
    GameTooltip:Hide();
    dataModule:Update(data);
    data.slideController:Stop();

    local buttonDisplayOrder = tk.Tables:GetIndex(data.settings.displayOrders, dataModule.SavedVariableName);

    if (data.lastButtonID == buttonDisplayOrder and data.lastButton == buttonName and data.popup:IsShown()) then
        -- clicked on same dataTextModule button so close the popup!

        -- if button was rapidly clicked on, reset alpha
        data.popup:SetAlpha(1);
        gui:FoldAllDropDownMenus(); -- fold any dropdown menus (slideController is not a dropdown menu)
        data.slideController:Start(SlideController.Static.FORCE_RETRACT);

        PlaySound(tk.Constants.CLICK);
        return;
    end

    -- update last button ID that was clicked (use display order for this)
    data.lastButtonID = buttonDisplayOrder;
    data.lastButton = buttonName;

    -- a different dataTextModule button was clicked on!
    -- reset popup...
    data.popup:Hide();
    data.popup:ClearAllPoints();

    -- handle type of button click
    if ((buttonName == "RightButton" and not dataModule.HasRightMenu) or
        (buttonName == "LeftButton" and not dataModule.HasLeftMenu)) then
        -- execute dataTextModule specific click logic
        dataModule:Click(buttonName, ...);
        return;
    end

    -- update content of popup based on which dataTextModule button was clicked
    if (dataModule.MenuContent) then
        self:ChangeMenuContent(dataModule.MenuContent);
    end

    if (dataModule.MenuLabels) then
        self:ClearLabels(dataModule.MenuLabels);
    end

    -- execute dataTextModule specific click logic
    local cannotExpand = dataModule:Click(buttonName, ...);

    if (cannotExpand) then
        return;
    end

    -- calculate new height based on number of labels to show
    local totalHeight = self:PositionLabels(dataModule) or data.settings.popup.maxHeight;
    totalHeight = (totalHeight < data.settings.popup.maxHeight) and totalHeight or data.settings.popup.maxHeight;

    -- move popup menu higher if there are resource bars displayed
    local offset = 0;

    if (_G["MUI_ResourceBars"]) then
        offset = _G["MUI_ResourceBars"]:GetHeight();
    end

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

    UIFrameFadeIn(data.popup, 0.3, 0, 1);
    PlaySound(tk.Constants.CLICK);
end

Engine:DefineParams("string");
function C_DataTextModule:ForceUpdate(data, dataModuleName)
    local dataModule = data.components[dataModuleName];
    dataModule:Update();
end

Engine:DefineReturns("boolean");
function C_DataTextModule:IsShown(data)
    return (data.bar and data.bar:IsShown()) or false;
end

Engine:DefineReturns("Frame");
function C_DataTextModule:GetDataTextBar(data)
    return data.bar;
end