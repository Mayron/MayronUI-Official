-- Setup Namespaces ------------------

local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local LABEL_PATTERN = "|cffffffff%s|r";

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local DataText = MayronUI:ImportModule("DataText");
local Inventory = Engine:CreateClass("Inventory", nil, "MayronUI.Engine.IDataTextModule");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.inventory", {
    enabled = false,
    showTotalSlots = false,
    slotsToShow = "free",
    displayOrder = 6
});

-- Local Functions ----------------

local function button_OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
    GameTooltip:SetText(L["Commands"]..":");
    GameTooltip:AddDoubleLine(tk:GetThemeColoredText(L["Left Click:"]), L["Toggle Bags"], r, g, b, 1, 1, 1);
    GameTooltip:AddDoubleLine(tk:GetThemeColoredText(L["Right Click:"]), L["Sort Bags"], r, g, b, 1, 1, 1);
    GameTooltip:Show();
end

local function button_OnLeave()
    GameTooltip:Hide();
end

-- Inventory Module --------------

DataText:Hook("OnInitialize", function(self, dataTextData)
    local sv = db.profile.datatext.inventory;
    sv:SetParent(dataTextData.sv);

    if (sv.enabled) then
        local inventory = Inventory(sv, dataTextData.slideController);
        self:RegisterDataModule(inventory);
    end
end);

function Inventory:__Construct(data, sv, slideController)
    data.sv = sv;
    data.displayOrder = sv.displayOrder;
    data.slideController = slideController;

    -- set public instance properties
    self.MenuContent = CreateFrame("Frame");
    self.MenuLabels = {};
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = false;
    self.HasRightMenu = false;

    self.Button = DataText:CreateDataTextButton(self);
    self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    self.Button:SetScript("OnEnter", button_OnEnter);
    self.Button:SetScript("OnLeave", button_OnLeave);

    data.handler = em:CreateEventHandler("BAG_UPDATE", function()
        if (not self.Button) then 
            return; 
        end

        self:Update(data);
    end);
end

function Inventory:Enable(data) 
    data.sv.enabled = true;
end

function Inventory:Disable(data)
    data.sv.enabled = false;

    if (data.handler) then
        data.handler:Destroy();
    end
end

function Inventory:IsEnabled(data) 
    return data.sv.enabled;
end

function Inventory:Update(data)
    local slots = 0;
    local totalSlots = 0;

    for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        totalSlots = totalSlots + (GetContainerNumSlots(i) or 0);
        slots = slots + (GetContainerNumFreeSlots(i) or 0);
    end

    if (data.sv.slotsToShow == "used") then
        slots = totalSlots - slots;
    end

    if (data.sv.showTotalSlots) then
        self.Button:SetText(tk.string.format(L["Bags"]..": |cffffffff%u / %u|r", slots, totalSlots));
    else
        self.Button:SetText(tk.string.format(L["Bags"]..": |cffffffff%u|r", slots));
    end
end

function Inventory:Click(data, button)
	if (button == "LeftButton") then
        ToggleAllBags();
     elseif (button == "RightButton") then
         SortBags();		
     end
end

function Inventory:GetDisplayOrder(data)
    return data.displayOrder;
end

function Inventory:SetDisplayOrder(data, displayOrder)
    if (data.displayOrder ~= displayOrder) then
        data.displayOrder = displayOrder;
        data.sv.displayOrder = displayOrder;
    end
end 