-- Setup namespaces ------------------
local addOnName, Core = ...;

local em = Core.EventManager;
local tk = Core.Toolkit;
local db = Core.Database;
local gui = Core.GUIBuilder;
local obj = Core.Objects;
local L = Core.Locale;

local MAX_DATA_ITEMS = 10;

local Lib = LibStub:GetLibrary("LibMayronGUI");
local WidgetsPackage = Lib.WidgetsPackage;
local SlideController = WidgetsPackage:Get("SlideController");

-- Register and Import Modules ---------

local MUICorePackage = Core.Objects:Import(addOnName);
local DataTextModule, DataText = MayronUI:RegisterModule("BottomUI_DataText", true);
local Container = MayronUI:ImportModule("BottomUI_Container");

-- Load Database Defaults --------------

db:AddToDefaults("profile.datatext", {
    enabled = true,
    frameStrata = "MEDIUM",
    frameLevel = 20,
    height = 24, -- height of data bar (width is the size of bottomUI container!)
    spacing = 1,
    fontSize = 11,
    combatBlock = true,	
	popup = {
		hideInCombat = true,
		maxHeight = 250,
		width = 200,
		itemHeight = 26 -- the height of each list item in the popup menu
	}
});

-- Local Functions ---------------------

local BlankDataItem = {};

function BlankDataItem:Enable()
    self.btn:SetText("");
    self.showMenu = nil;
end

-- DataText Module -------------------

DataTextModule:OnInitialize(function(self, data, buiContainer, subModules, a)
    data.sv = db.profile.datatext;
    data.buiContainer = buiContainer;
    data.ResourceBars = subModules.ResourceBars;

    if (data.sv.enabled) then 
        self:SetEnabled(true);
    end    
end);

DataTextModule:OnEnable(function(self, data)
    data.bar = tk:PopFrame("Frame", data.buiContainer);
    data.bar:SetHeight(data.sv.height);
    data.bar:SetPoint("BOTTOMLEFT");
    data.bar:SetPoint("BOTTOMRIGHT");
    data.bar:SetFrameStrata(data.sv.frameStrata);
    data.bar:SetFrameLevel(data.sv.frameLevel);

    tk:SetBackground(data.bar, 0, 0, 0);

	local coloredKey = tk:GetClassColoredText(nil, tk:GetPlayerKey());
	
    if (not db:ParsePathValue("global.datatext.money.characters")) then
        db:SetPathValue("global.datatext.money.characters", {});
    end
    
	-- store character's money to be seen by other characters
    db.global.datatext.money.characters[coloredKey] = GetMoney();

    -- create the popup menu (displayed when a data item button is clicked)
    data.popup = gui:CreateScrollFrame(tk.Constants.AddOnStyle, data.buiContainer, "MUI_DataTextPopupMenu");
	data.popup:SetWidth(data.sv.popup.width);
    data.popup:SetFrameStrata("DIALOG");
	
    data.popup.ScrollBar:SetPoint("TOPLEFT", data.popup, "TOPRIGHT", -6, 1);
    data.popup.ScrollBar:SetPoint("BOTTOMRIGHT", data.popup, "BOTTOMRIGHT", -1, 1);
     
    data.popup.bg = gui:CreateDialogBox(tk.Constants.AddOnStyle, data.popup, "High");
    data.popup.bg:SetPoint("TOPLEFT", 0, 2);
    data.popup.bg:SetPoint("BOTTOMRIGHT", 0, -2);
    
    data.popup.bg:SetGridColor(0.4, 0.4, 0.4, 1);
    data.popup.bg:SetFrameLevel(1);

    data.popup:EnableMouse(true);
    data.popup.anchor = "";
    data.popup.lastButton = "";
    data.popup:Hide();

    data.popup:SetScript("OnHide", function()
		-- when popup is closed by user
        if (data.dropdowns) then
		-- popup menu content has dropdown menu's
            for _, dropdown in tk.ipairs(data.dropdowns) do
			
				--TODO: fold them all
                dropdown:GetFrame().menu:Hide(); 
            end
        end
    end);

	-- provides more intelligent 
    data.slideController = SlideController(data.popup);
	
	-- controls the Esc key behaviour to close the popup (must use global name)
    tk.table.insert(UISpecialFrames, "MUI_DataTextPopupMenu");

    if (data.sv.popup.hideInCombat) then	
		-- TODO
        em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
			tk._G["MUI_DataTextPopupMenu"]:Hide();
        end);		
    end
end);

DataTextModule:OnConfigUpdate(function(self, data, list, value)
    local key = list:PopFront();

    if (key == "profile" and list:PopFront() == "datatext") then
        key = list:PopFront();
        if (key == "enabled") then
            self:PositionDataItems();

        elseif (key == "performance") then
            self:ForceUpdate("performance");

        elseif (key == "money") then
            self:ForceUpdate("money");

        elseif (key == "bags") then
            self:ForceUpdate("bags");

        elseif (key == "guild") then
            if (list:PopFront() == "show_tooltips") then
                items.guild.update_required = true;
            end

        elseif (key == "menu_width") then
            data.popup:SetWidth(value);

        elseif (key == "popup.maxHeight") then
            data.slideController:Start();
            
        elseif (key == "fontSize") then
            local font = tk.Constants.LSM:Fetch("font", db.global.Core.font);

            for id, btn in tk.ipairs(data.DataModules) do
                btn:GetFontString():SetFont(font, value);

                if (btn.seconds) then
                    btn.seconds:SetFont(font, value);
                end

                if (btn.minutes) then
                    btn.minutes:SetFont(font, value);
                end

                if (btn.milliseconds) then
                    btn.milliseconds:SetFont(font, value);
                end
            end

        elseif (key == "spacing") then
            self:PositionDataItems();

        elseif (key == "combat_block") then
            if (data.blocker and not value) then
                data.blocker:Hide();

            elseif (value) then
                data:CreateBlocker();
            end

        elseif (key == "hideMenuInCombat") then
            if (tk.InCombatLockdown() and value and data.popup:IsVisible()) then
                data.slideController:Start();
            end

        elseif (key == "frame_strata") then
            data.bar:SetFrameStrata(value);

        elseif (key == "frame_level") then
            data.bar:SetFrameLevel(value);
        end
    end
end);

-- DataText Object -------------------

-- it's the parent name (might not work)
-- MUICorePackage:DefineParams("Module", "number");
function DataText:RegisterDataItem(data, dataModule, displayOrder)
    local dataModuleName = dataModule:GetModuleName();
    data.DataModules = data.DataModules or {};
    data.DataModules[dataModuleName] = dataModule;    
    
    local btn = tk:PopFrame("Button", data.bar);
    local font = tk.Constants.LSM:Fetch("font", db.global.Core.font);

    btn:SetNormalTexture(tk.Constants.MEDIA.."mui_bar");
    btn:GetNormalTexture():SetVertexColor(0.08, 0.08, 0.08);

    btn:SetHighlightTexture(tk.Constants.MEDIA.."mui_bar");
    btn:GetHighlightTexture():SetVertexColor(0.08, 0.08, 0.08);

    btn:SetNormalFontObject("MUI_FontNormal");
    btn:SetText((dataModuleName == "blank" and " ") or dataModuleName);
    btn:GetFontString():SetFont(font,  data.sv.fontSize);

    btn:SetScript("OnClick", function(_, ...)
        self:ClickButton(dataModule, btnClicked, ...);
    end);

    btn:SetID(displayOrder);
    dataModule:SetEnabled(true, btn);
    self:PositionDataItems();                
end

function DataText:PositionDataItems(data)
    local flatOrdering = {};
    local ordering = {};   

    for dataModuleName, dataModule in pairs(data.DataModules) do
        if (dataModule:IsEnabled()) then

            local btn = dataModule:GetButton();       
            local displayOrder = btn:GetID();
            btn.module = dataModule; -- temporarily

            for i = displayOrder, 100 do
                if (not ordering[i]) then
                    ordering[i] = btn;                    
                    break;
                end
            end
        end
    end
    
    -- remove all nils (some gaps in the display order might exist)
    for i, btn in ipairs(ordering) do        
        if (ordering[i]) then
            local selectedDisplayOrder = #flatOrdering + 1;
            flatOrdering[selectedDisplayOrder] = btn;

            btn:SetID(selectedDisplayOrder);                  
            btn.module:Update(data);
            btn.module = nil; -- remove temporary module ref
        end
    end

    data.OrderedButtons = flatOrdering;
    local itemWidth = data.buiContainer:GetWidth() / #data.OrderedButtons;

    for i = 1, MAX_DATA_ITEMS do
        local btn = data.OrderedButtons[i];

        if (i <= #data.OrderedButtons) then
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

        elseif (btn) then
            btn:Hide();
        end
    end

    data.popup:Hide();
end

MUICorePackage:DefineParams("Frame");
MUICorePackage:DefineReturns("Frame");
function DataText:ChangeMenuScrollChild(data, scrollChild)
    local oldScrollChild = data.popup:GetScrollChild();

    if (oldScrollChild) then 
        oldScrollChild:Hide();
    end
    
    if (not scrollChild) then
        scrollChild = tk:PopFrame("Frame", data.popup);
        scrollChild:SetSize(data.popup:GetWidth(), 10);
    end

    -- attach scroll child to menu frame container
    data.popup:SetScrollChild(scrollChild);
    scrollChild:Show();

    return scrollChild;
end

MUICorePackage:DefineParams("table");
function DataText:ClearLabels(data, labels)
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

MUICorePackage:DefineParams("Frame", "number", "table");
MUICorePackage:DefineReturns("number");
-- returned the total height of all labels
-- total height is used to controll the dynamic scrollbar
function DataText:PositionLabels(data, numLabelsShown, labels)
    if (totalLabelsShown == 0) then 
        return 0; 
    end

    labels = labels or data.content.labels;
    local totalHeight = 0;

    for i = 1, #labels do
        local label = labels[i];

        if (label) then
            if (i == 1) then
                label:SetPoint("TOPLEFT", 2, 0);
                label:SetPoint("BOTTOMRIGHT", data.content, "TOPRIGHT", -2, - data.sv.popup.itemHeight);
            else
                label:SetPoint("TOPLEFT", labels[i - 1], "BOTTOMLEFT", 0, -2);
                label:SetPoint("BOTTOMRIGHT", labels[i - 1], "BOTTOMRIGHT", 0, -(data.sv.popup.itemHeight + 2));
            end

            if (numLabelsShown and (i > numLabelsShown)) then
                label:Hide();
            else
                label:Show();
                totalHeight = totalHeight + data.sv.popup.itemHeight;

                if (i > 1) then
                    totalHeight = totalHeight + 2;
                end
            end
        end
    end

    data.content:SetHeight(totalHeight);
    return totalHeight;
end

MUICorePackage:DefineParams("Button", "Button");
function DataText:ClickButton(data, dataModule, btnClicked, ...)
    local btn = dataModule:GetButton();

    GameTooltip:Hide();
    dataModule:Update(data);

    data.content = self:ChangeMenuScrollChild(data.content);
    data.slideController:Stop();

    if (data.popup:IsShown() and data.lastID == btn:GetID() and data.lastButtonClicked == btnClicked) then
        if (dataModule:GetModuleName() == "DataText_Specialization") then
            gui:FoldAllDropDownMenus();
        end

        data.slideController:Start();
        tk.UIFrameFadeOut(data.popup, 0.3, data.popup:GetAlpha(), 0);
		tk.PlaySound(tk.Constants.CLICK);
        return;
    end

    data.popup:Hide();
    data.popup:ClearAllPoints();

    if (not dataModule:HasMenu()) then
        dataModule:Click(data, btnClicked, ...);
        return;
    end

    self:ClearLabels(data.content.labels);

    local numLabelsShown = dataModule:Click(data.content, btnClicked, ...);
    local totalHeight = self:PositionLabels(numLabelsShown) or data.sv.popup.maxHeight;
    totalHeight = (totalHeight < data.sv.popup.maxHeight) and totalHeight or data.sv.popup.maxHeight;  

    local offset = data.ResourceBars:GetHeight();

    if (btn:GetID() == #data.OrderedButtons) then
        data.popup:SetPoint("BOTTOMRIGHT", btn, "TOPRIGHT", -1, offset + 2);

    elseif (btn:GetID() == 1) then
        data.popup:SetPoint("BOTTOMLEFT", btn, "TOPLEFT", 1, offset + 2);

    else
        data.popup:SetPoint("BOTTOM", btn, "TOP", 0, offset + 2);
    end

    data.lastID = btn:GetID();
    data.lastButtonClicked = btnClicked;

    data.slideController:SetMaxHeight(totalHeight);
    data.slideController:Start();

    tk.UIFrameFadeIn(data.menu, 0.3, 0, 1);
    tk.PlaySound(tk.Constants.CLICK);
end

MUICorePackage:DefineParams("string");
function DataText:ForceUpdate(data, dataModuleName)    
    data.DataModules[dataModuleName]:Update();
end

MUICorePackage:DefineReturns("boolean");
function DataText:IsShown(data)    
    return data.bar:IsShown();
end

MUICorePackage:DefineReturns("Frame");
function DataText:GetFrame(data)    
    return data.bar;
end

function DataText:GetMenuWidth(data)
    return data.sv.popup.width;
end