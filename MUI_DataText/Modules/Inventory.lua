-- Setup Namespaces ------------------

local _, Core = ...;

local em = Core.EventManager;
local tk = Core.Toolkit;
local db = Core.Database;
local gui = Core.GUIBuilder;
local L = Core.Locale;

local LABEL_PATTERN = "|cffffffff%s|r";

-- Register and Import Modules -------

local DataText = MayronUI:ImportModule("BottomUI_DataText");
local InventoryModule, Inventory = MayronUI:RegisterModule("DataText_Inventory");
local Engine = Core.Objects:Import("MayronUI.Engine");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.inventory", {
    enabled = true,
    showTotalSlots = false,
    slotsToShow = "free",
    displayOrder = 6
});

-- Local Functions ----------------

local function Button_OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
    GameTooltip:SetText(L["Commands"]..":");
    GameTooltip:AddDoubleLine(tk:GetThemeColoredString(L["Left Click:"]), L["Toggle Bags"], r, g, b, 1, 1, 1);
    GameTooltip:AddDoubleLine(tk:GetThemeColoredString(L["Right Click:"]), L["Sort Bags"], r, g, b, 1, 1, 1);
    GameTooltip:Show();
end

local function Button_OnLeave()
    GameTooltip:Hide();
end

-- Inventory Module --------------

InventoryModule:OnInitialize(function(self, data) 
    data.sv = db.profile.datatext.inventory;

    if (data.sv.enabled) then
        --DataText:RegisterDataItem(self);
    end
end);

InventoryModule:OnEnable(function(self, data, btn)
    data.btn = btn;
    data.btn:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    data.btn:SetScript("OnEnter", OnEnter);
    data.btn:SetScript("OnLeave", OnLeave);

    data.handler = em:CreateEventHandler("BAG_UPDATE", function()
        if (not data.btn) then 
            return; 
        end

        self:Update(data);
    end);
end);

InventoryModule:OnDisable(function(self, data)
    if (data.handler) then
        data.handler:Destroy();
    end
end);

-- Inventory Object --------------

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
        data.btn:SetText(tk.string.format(L["Bags"]..": |cffffffff%u / %u|r", slots, totalSlots));
    else
        data.btn:SetText(tk.string.format(L["Bags"]..": |cffffffff%u|r", slots));
    end
end

function Inventory:Click(data)
	if (button == "LeftButton") then
        ToggleAllBags();
     elseif (button == "RightButton") then
         SortBags();		
     end
end

function Inventory:HasMenu()
    return false;
end
 
Engine:DefineReturns("Button");
function Inventory:GetButton(data)
    return data.btn;
end