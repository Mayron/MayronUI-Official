-- luacheck: ignore MayronUI self 143 631
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents();

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local Inventory = Engine:CreateClass("Inventory", nil, "MayronUI.Engine.IDataTextModule");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.inventory", {
    showTotalSlots = false,
    slotsToShow = "free"
});

-- Local Functions ----------------

local function button_OnEnter(self)
    local r, g, b = tk:GetThemeColor();
    _G.GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
    _G.GameTooltip:SetText(L["Commands"]..":");
    _G.GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Left Click:"]), L["Toggle Bags"], r, g, b, 1, 1, 1);
    _G.GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Right Click:"]), L["Sort Bags"], r, g, b, 1, 1, 1);
    _G.GameTooltip:Show();
end

local function button_OnLeave()
    _G.GameTooltip:Hide();
end

-- Inventory Module --------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
    self:RegisterDataModule("inventory", Inventory);
end);

function Inventory:__Construct(data, settings, dataTextModule, slideController)
    data.settings = settings;
    data.slideController = slideController;

    -- set public instance properties
    self.MenuContent = _G.CreateFrame("Frame");
    self.MenuLabels = obj:PopTable();
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = false;
    self.HasRightMenu = false;
    self.SavedVariableName = "inventory";
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

function Inventory:Update(data)
    local slots = 0;
    local totalSlots = 0;

    for i = _G.BACKPACK_CONTAINER, _G.NUM_BAG_SLOTS do
        totalSlots = totalSlots + (_G.GetContainerNumSlots(i) or 0);
        slots = slots + (_G.GetContainerNumFreeSlots(i) or 0);
    end

    if (data.settings.slotsToShow == "used") then
        slots = totalSlots - slots;
    end

    if (data.settings.showTotalSlots) then
        self.Button:SetText(tk.string.format(L["Bags"]..": |cffffffff%u / %u|r", slots, totalSlots));
    else
        self.Button:SetText(tk.string.format(L["Bags"]..": |cffffffff%u|r", slots));
    end
end

function Inventory:Click(_, button)
	if (button == "LeftButton") then
        _G.ToggleAllBags();
     elseif (button == "RightButton") then
        _G.SortBags();
     end
end