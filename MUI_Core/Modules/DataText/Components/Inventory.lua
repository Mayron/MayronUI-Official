local _, namespace = ...;

-- luacheck: ignore MayronUI self 143 631
local tk, db, em, _, _, L = MayronUI:GetCoreComponents();
local ComponentsPackage = namespace.ComponentsPackage;

local _G = _G;
local string, GetContainerNumSlots, GetContainerNumFreeSlots = _G.string, _G.GetContainerNumSlots, _G.GetContainerNumFreeSlots;

-- GLOBALS:
--[[ luacheck: ignore GameTooltip ToggleAllBags SortBags BACKPACK_CONTAINER NUM_BAG_SLOTS ]]

-- Register and Import Modules -------

local Inventory = ComponentsPackage:CreateClass("Inventory", nil, "IDataTextComponent");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.inventory", {
    showTotalSlots = false,
    slotsToShow = "free"
});

-- Local Functions ----------------

local function button_OnEnter(self)
    local r, g, b = tk:GetThemeColor();
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
    GameTooltip:SetText(L["Commands"]..":");
    GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Left Click:"]), L["Toggle Bags"], r, g, b, 1, 1, 1);
    GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Right Click:"]), L["Sort Bags"], r, g, b, 1, 1, 1);
    GameTooltip:Show();
end

local function button_OnLeave()
    GameTooltip:Hide();
end

-- Inventory Module --------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
    self:RegisterComponentClass("inventory", Inventory);
end);

function Inventory:__Construct(data, settings, dataTextModule, slideController)
    data.settings = settings;
    data.slideController = slideController;

    -- set public instance properties
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = false;
    self.HasRightMenu = false;
    self.Button = dataTextModule:CreateDataTextButton();
end

function Inventory:SetEnabled(data, enabled)
    data.enabled = enabled;

    if (enabled) then
        data.handler = em:CreateEventHandler("BAG_UPDATE", function()
            if (not self.Button) then
                return
            end

            self:Update(data);
        end);

        self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
        self.Button:SetScript("OnEnter", button_OnEnter);
        self.Button:SetScript("OnLeave", button_OnLeave);
    else
        if (data.handler) then
            data.handler:Destroy();
            data.handler = nil;
        end

        self.Button:RegisterForClicks("LeftButtonUp");
        self.Button:SetScript("OnEnter", nil);
        self.Button:SetScript("OnLeave", nil);
    end
end

function Inventory:IsEnabled(data)
    return data.enabled;
end

function Inventory:Update(data, refreshSettings)
    if (refreshSettings) then
        data.settings:Refresh();
    end

    local slots = 0;
    local totalSlots = 0;

    for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        totalSlots = totalSlots + (GetContainerNumSlots(i) or 0);
        slots = slots + (GetContainerNumFreeSlots(i) or 0);
    end

    if (data.settings.slotsToShow == "used") then
        slots = totalSlots - slots;
    end

    if (data.settings.showTotalSlots) then
        self.Button:SetText(string.format(L["Bags"]..": |cffffffff%u / %u|r", slots, totalSlots));
    else
        self.Button:SetText(string.format(L["Bags"]..": |cffffffff%u|r", slots));
    end
end

function Inventory:Click(_, button)
	if (button == "LeftButton") then
        ToggleAllBags();
     elseif (button == "RightButton") then
        SortBags();
     end
end