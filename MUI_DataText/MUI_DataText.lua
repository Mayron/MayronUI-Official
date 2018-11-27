-- Setup Locals ------------------------

local addOnName, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();
local MAX_DATA_ITEMS = 10;

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

local DataTextModuleClass = MayronUI:RegisterModule("DataText");
namespace.DataTextModuleClass = DataTextModuleClass;

-- Load Database Defaults --------------

db:AddToDefaults("profile.datatext", {
    enabled = true,
    frameStrata = "MEDIUM",
    frameLevel = 20,
    height = 24, -- height of data bar (width is the size of bottomUI container!)
    spacing = 1,
    fontSize = 11,
    blockInCombat = true,
	popup = {
		hideInCombat = true,
		maxHeight = 250,
		width = 200,
		itemHeight = 26 -- the height of each list item in the popup menu
    },
    displayOrder = {
        "durability",
        "friends",
        "guild",
        "inventory",
        "memory",
        "performance",
        "specialization",
    }
});

-- DataTextModuleClass Functions -------------------

function DataTextModuleClass:OnInitialize(data)
    data.sv = db.profile.datatext; -- database saved variables table
    data.buiContainer = _G["MUI_BottomContainer"]; -- the entire BottomUI container frame
    data.resourceBars = _G["MUI_ResourceBars"]; -- the resource bars container frame
    data.lastButtonClicked = ""; -- last data text button clicked on
    data.DataModules = {}; -- holds all data text modules

    if (data.sv.enabled) then 
        self:SetEnabled(true);
    end    
end

function DataTextModuleClass:OnEnable(data)
    -- the main bar containing all data text buttons
    data.bar = tk:PopFrame("Frame", data.buiContainer);
    data.bar:SetHeight(data.sv.height);
    data.bar:SetPoint("BOTTOMLEFT");
    data.bar:SetPoint("BOTTOMRIGHT");
    data.bar:SetFrameStrata(data.sv.frameStrata);
    data.bar:SetFrameLevel(data.sv.frameLevel);

    data.resourceBars:SetPoint("BOTTOMLEFT", data.bar, "TOPLEFT", 0, -1);
    data.resourceBars:SetPoint("BOTTOMRIGHT", data.bar, "TOPRIGHT", 0, -1);

    local actionBarPanelModule = MayronUI:ImportModule("BottomUI_ActionBarPanel");
    actionBarPanelModule:PositionBartenderBars(data);

    tk:SetBackground(data.bar, 0, 0, 0);

    -- create the popup menu (displayed when a data item button is clicked)
    -- each data text module has its own frame to be used as the scroll child
    data.popup = gui:CreateScrollFrame(tk.Constants.AddOnStyle, data.buiContainer, "MUI_DataTextPopupMenu");
	data.popup:SetWidth(data.sv.popup.width);
    data.popup:SetFrameStrata("DIALOG");
    data.popup:EnableMouse(true);
    data.popup:Hide();

    -- controls the Esc key behaviour to close the popup (must use global name)
    tk.table.insert(UISpecialFrames, "MUI_DataTextPopupMenu");

    if (data.sv.popup.hideInCombat) then	
        em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
            tk._G["MUI_DataTextPopupMenu"]:Hide();
        end);		
    end
	
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
            for _, dropdown in tk.ipairs(data.dropdowns) do			
				gui:FoldAllDropDownMenus();
                dropdown:GetFrame().menu:Hide(); 
            end
        end
    end);

	-- provides more intelligent scrolling (+ controls visibility of scrollbar)
    data.slideController = SlideController(data.popup);
end

Engine:DefineParams("IDataTextModule");
function DataTextModuleClass:RegisterDataModule(data, dataModule)
    local dataModuleName = dataModule:GetObjectType(); -- get's name of object/module
    data.DataModules[dataModuleName] = dataModule;
    
    local dataTextButton = dataModule.Button;
    dataTextButton:SetParent(data.bar);

    dataTextButton:SetScript("OnClick", function(_, ...)
        self:ClickModuleButton(dataModule, dataTextButton, ...);
    end);

    self:PositionDataItems();          
end

Engine:DefineParams("IDataTextModule", "?string");
Engine:DefineReturns("Button");
function DataTextModuleClass:CreateDataTextButton(data, dataModule, btnText)
    local btn = CreateFrame("Button");
    btn:SetNormalTexture(tk.Constants.MEDIA.."mui_bar");
    btn:GetNormalTexture():SetVertexColor(0.08, 0.08, 0.08);

    btn:SetHighlightTexture(tk.Constants.MEDIA.."mui_bar");
    btn:GetHighlightTexture():SetVertexColor(0.08, 0.08, 0.08);

    btn:SetNormalFontObject("MUI_FontNormal");

    local font = tk.Constants.LSM:Fetch("font", db.global.core.font);
    btn:SetText(btnText or " ");
    btn:GetFontString():SetFont(font, data.sv.fontSize);

    return btn;
end

function DataTextModuleClass:PositionDataItems(data)
    local displayOrders = db.profile.datatext.displayOrder:ToTable();
    data.OrderedButtons = {};

    for _, dataModule in pairs(data.DataModules) do
        if (dataModule:IsEnabled()) then
            local btn = dataModule.Button;                 
            local dbName = dataModule.SavedVariableName;
            local displayOrder = tk.Tables:GetIndex(displayOrders, dbName);

            btn._module = dataModule; -- temporary

            if (not displayOrder) then
                displayOrder = #displayOrders;
                db.profile.datatext.displayOrder[displayOrder] = dbName;
            end

            data.OrderedButtons[displayOrder] = btn;
        end
    end
    
    local itemWidth = data.buiContainer:GetWidth() / #data.OrderedButtons;

    for i, btn in ipairs(data.OrderedButtons) do
        btn:ClearAllPoints();
        btn:Show();

        if (i == 1) then                
            btn:SetPoint("BOTTOMLEFT", data.sv.spacing, 0);
            btn:SetPoint("TOPRIGHT", data.bar, "TOPLEFT", itemWidth - data.sv.spacing, - data.sv.spacing);
        else
            local previousBtn = data.OrderedButtons[i - 1];
            btn:SetPoint("TOPLEFT", previousBtn, "TOPRIGHT", data.sv.spacing, 0);
            btn:SetPoint("BOTTOMRIGHT", previousBtn, "BOTTOMRIGHT", itemWidth, 0);
        end

        btn._module:Update();
        btn._module = nil; -- remove temporary _module ref
    end

    data.popup:Hide();
end

Engine:DefineParams("Frame");
-- Attach current dataTextModule scroll child onto shared popup and hide previous scroll child
function DataTextModuleClass:ChangeMenuContent(data, content)
    local oldContent = data.popup:GetScrollChild();

    if (oldContent) then 
        oldContent:Hide();
    end

    content:SetParent(data.popup);
    content:SetSize(data.popup:GetWidth(), 10);

    -- attach scroll child to menu frame container
    data.popup:SetScrollChild(content);
    content:Show();
end

Engine:DefineParams("table");
function DataTextModuleClass:ClearLabels(data, labels)
    if (not labels) then 
        return; 
    end

    for id, label in ipairs(labels) do
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
function DataTextModuleClass:PositionLabels(data, dataModule)    
    local totalLabelsShown = dataModule.TotalLabelsShown;
    local labelHeight = data.sv.popup.itemHeight;

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
function DataTextModuleClass:ClickModuleButton(data, dataModule, dataTextButton, button, ...)
    GameTooltip:Hide();
    dataModule:Update(data);
    data.slideController:Stop();

    local buttonDisplayOrder = dataModule:GetDisplayOrder();

    if (data.lastButtonID == buttonDisplayOrder and data.lastButton == button and data.popup:IsShown()) then       
        -- clicked on same dataTextModule button so close the popup!

        -- if button was rapidly clicked on, reset alpha
        data.popup:SetAlpha(1);
        gui:FoldAllDropDownMenus(); -- fold any dropdown menus (slideController is not a dropdown menu)
        data.slideController:Start(SlideController.Static.FORCE_RETRACT);

        --tk.UIFrameFadeOut(data.popup, 0.3, data.popup:GetAlpha(), 0);
        tk.PlaySound(tk.Constants.CLICK);
        return;
    end

    -- update last button ID that was clicked (use display order for this)
    data.lastButtonID = buttonDisplayOrder;
    data.lastButton = button;

    -- a different dataTextModule button was clicked on!
    -- reset popup...
    -- data.popup:Hide();
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
    dataModule:Click(button, ...);

    -- calculate new height based on number of labels to show
    local totalHeight = self:PositionLabels(dataModule) or data.sv.popup.maxHeight;
    totalHeight = (totalHeight < data.sv.popup.maxHeight) and totalHeight or data.sv.popup.maxHeight;  

    -- move popup menu higher if there are resource bars displayed
    local offset = data.resourceBars:GetHeight();

    -- update positioning of popup menu based on dataTextModule button's location
    if (buttonDisplayOrder == #data.OrderedButtons) then
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

    tk.UIFrameFadeIn(data.popup, 0.3, 0, 1);
    tk.PlaySound(tk.Constants.CLICK);
end

Engine:DefineParams("string");
function DataTextModuleClass:ForceUpdate(data, dataModuleName)    
    data.DataModules[dataModuleName]:Update();
end

Engine:DefineReturns("boolean");
function DataTextModuleClass:IsShown(data)    
    return (data.bar and data.bar:IsShown()) or false;
end

Engine:DefineReturns("Frame");
function DataTextModuleClass:GetDataTextBar(data)    
    return data.bar;
end