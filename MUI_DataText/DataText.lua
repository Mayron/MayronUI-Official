-- Setup namespaces ------------------
local addOnName, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();
local MAX_DATA_ITEMS = 10;

-- Register and Import ---------

local Engine = obj:Import("MayronUI.Engine");
local SlideController = obj:Import("MayronUI.Widgets.SlideController");

local dataTextModule, DataTextClass = MayronUI:RegisterModule("DataText");
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

-- local BlankDataItem = {};

-- function BlankDataItem:Enable()
--     self.btn:SetText("");
--     self.showMenu = nil;
-- end

-- DataText Module -------------------

dataTextModule:OnInitialize(function(self, data)
    data.sv = db.profile.datatext; -- database saved variables table
    data.buiContainer = _G["MUI_BottomContainer"]; -- the entire BottomUI container frame
    data.resourceBars = _G["MUI_ResourceBars"]; -- the resource bars container frame
    data.lastButtonClicked = ""; -- last data text button clicked on
    data.DataModules = {}; -- holds all data text modules

    if (data.sv.enabled) then 
        self:SetEnabled(true);
    end    
end);

dataTextModule:OnEnable(function(self, data)
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
				--TODO: fold them all
                dropdown:GetFrame().menu:Hide(); 
            end
        end
    end);

	-- provides more intelligent scrolling (+ controls visibility of scrollbar)
    data.slideController = SlideController(data.popup);
end);

dataTextModule:OnConfigUpdate(function(self, data, list, value)
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

-- DataTextClass -------------------

Engine:DefineParams("IdataTextModule", "number");
function DataTextClass:RegisterDataModule(data, dataModule)
    local dataModuleName = dataModule:GetObjectType(); -- get's name of object/module
    data.DataModules[dataModuleName] = dataModule;
    
    local btn = dataModule.Button;
    btn:SetParent(data.bar);

    btn:SetNormalTexture(tk.Constants.MEDIA.."mui_bar");
    btn:GetNormalTexture():SetVertexColor(0.08, 0.08, 0.08);

    btn:SetHighlightTexture(tk.Constants.MEDIA.."mui_bar");
    btn:GetHighlightTexture():SetVertexColor(0.08, 0.08, 0.08);

    btn:SetNormalFontObject("MUI_FontNormal");
    btn:SetText(dataModuleName);

    local font = tk.Constants.LSM:Fetch("font", db.global.Core.font);
    btn:GetFontString():SetFont(font,  data.sv.fontSize);

    btn:SetScript("OnClick", function(_, ...)
        self:ClickModuleButton(dataModule, btn, ...);
    end);

    self:PositionDataItems();
    return btn;            
end

function DataTextClass:PositionDataItems(data)
    local flatOrdering = {};
    local ordering = {};   

    for dataModuleName, dataModule in pairs(data.DataModules) do
        if (dataModule:IsEnabled()) then

            local btn = dataModule.Button;       
            local displayOrder = dataModule.ButtonID;
            btn._module = dataModule; -- temporarily

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

            btn.ButtonID = selectedDisplayOrder;                  
            btn._module:Update(data);
            btn._module = nil; -- remove temporary _module ref
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

Engine:DefineParams("Frame");
Engine:DefineReturns("Frame");
-- Attach current dataTextModule scroll child onto shared popup and hide previous scroll child
function DataTextClass:ChangeMenuContent(data, content)
    local oldContent = data.popup:GetScrollChild();

    if (oldContent) then 
        oldContent:Hide();
    end
    
    if (not content) then
        content = tk:PopFrame("Frame", data.popup);
        content:SetSize(data.popup:GetWidth(), 10);
    end

    -- attach scroll child to menu frame container
    data.popup:SetScrollChild(content);
    content:Show();

    return content;
end

Engine:DefineParams("table");
function DataTextClass:ClearLabels(data, labels)
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

Engine:DefineParams("Frame", "number", "table");
Engine:DefineReturns("number");
-- returned the total height of all labels
-- total height is used to controll the dynamic scrollbar
function DataTextClass:PositionLabels(data, numLabelsShown, labels)
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

Engine:DefineParams("Button", "Button");
function DataTextClass:ClickModuleButton(data, dataModule, ...)
    GameTooltip:Hide();

    -- update last button ID that was clicked
    data.lastButtonID = dataModule.ButtonID;

    dataModule:Update(data);
    data.slideController:Stop();

    if (data.lastButtonID == dataModule.ButtonID) then
        if (data.popup:IsShown()) then
            -- clicked on same dataTextModule button so close the popup!
            gui:FoldAllDropDownMenus();
            data.slideController:Start();
            tk.UIFrameFadeOut(data.popup, 0.3, data.popup:GetAlpha(), 0);
            tk.PlaySound(tk.Constants.CLICK);
        end

        return;
    end

    -- a different dataTextModule button was clicked on!
    -- reset popup...
    data.popup:Hide();
    data.popup:ClearAllPoints();

    if (not dataModule.HasMenu) then
        -- execute dataTextModule specific click logic
        dataModule:Click(...);
        return;
    end

    -- update content of popup based on which dataTextModule button was clicked
    local content = dataModule.MenuContent;
    data.content = self:ChangeMenuContent(content);
    self:ClearLabels(datModule.MenuLabels);    
    
    -- execute dataTextModule specific click logic
    dataModule:Click(...);

    -- this might have been updated by dataModule:Click(...)
    local labelsShown = dataModule.TotalLabelsShown;

    -- calculate new height based on number of labels to show
    local totalHeight = self:PositionLabels(numLabelsShown) or data.sv.popup.maxHeight;
    totalHeight = (totalHeight < data.sv.popup.maxHeight) and totalHeight or data.sv.popup.maxHeight;  

    -- move popup menu higher if there are resource bars displayed
    local offset = data.resourceBars:GetHeight();

    -- update positioning of popup menu based on dataTextModule button's location
    if (dataModule.ButtonID == #data.OrderedButtons) then
        -- if button was the last button displayed on the data-text bar
        data.popup:SetPoint("BOTTOMRIGHT", btn, "TOPRIGHT", -1, offset + 2);
    elseif (dataModule.ButtonID == 1) then
        -- if button was the first button displayed on the data-text bar
        data.popup:SetPoint("BOTTOMLEFT", btn, "TOPLEFT", 1, offset + 2);
    else
        -- if button was not the first or last button displayed on the data-text bar
        data.popup:SetPoint("BOTTOM", btn, "TOP", 0, offset + 2);
    end

    -- begin expanding the popup menu
    data.slideController:SetMaxHeight(totalHeight);
    data.slideController:Start();
    tk.UIFrameFadeIn(data.menu, 0.3, 0, 1);
    tk.PlaySound(tk.Constants.CLICK);
end

Engine:DefineParams("string");
function DataTextClass:ForceUpdate(data, dataModuleName)    
    data.DataModules[dataModuleName]:Update();
end

Engine:DefineReturns("boolean");
function DataTextClass:IsShown(data)    
    return (data.bar and data.bar:IsShown()) or false;
end

Engine:DefineReturns("Frame");
function DataTextClass:GetFrame(data)    
    return data.bar;
end

function DataTextClass:GetMenuWidth(data)
    return data.sv.popup.width;
end