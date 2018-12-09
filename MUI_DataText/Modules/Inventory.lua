-- luacheck: ignore MayronUI self 143 631
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents();

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local Inventory = Engine:CreateClass("Inventory", nil, "MayronUI.Engine.IDataTextModule");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.inventory", {
    enabled = true,
    showTotalSlots = false,
    slotsToShow = "free"
});

-- Local Functions ----------------

local function button_OnEnter(self)
    local r, g, b = tk:GetThemeColor();
    _G.GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
    _G.GameTooltip:SetText(L["Commands"]..":");
    _G.GameTooltip:AddDoubleLine(tk.Strings:GetThemeColoredText(L["Left Click:"]), L["Toggle Bags"], r, g, b, 1, 1, 1);
    _G.GameTooltip:AddDoubleLine(tk.Strings:GetThemeColoredText(L["Right Click:"]), L["Sort Bags"], r, g, b, 1, 1, 1);
    _G.GameTooltip:Show();
end

local function button_OnLeave()
    _G.GameTooltip:Hide();
end

-- Inventory Module --------------

MayronUI:Hook("DataText", "OnInitialize", function(self, dataTextData)
    local sv = db.profile.datatext.inventory;
    sv:SetParent(dataTextData.sv);

    if (sv.enabled) then
        local inventory = Inventory(sv, dataTextData.slideController, self);
        self:RegisterDataModule(inventory);
    end
end);

function Inventory:__Construct(data, sv, slideController, dataTextModule)
    data.sv = sv;
    data.slideController = slideController;

    -- set public instance properties
    self.MenuContent = _G.CreateFrame("Frame");
    self.MenuLabels = {};
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = false;
    self.HasRightMenu = false;
    self.SavedVariableName = "inventory";

    self.Button = dataTextModule:CreateDataTextButton();
    self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    self.Button:SetScript("OnEnter", button_OnEnter);
    self.Button:SetScript("OnLeave", button_OnLeave);

    data.handler = em:CreateEventHandler("BAG_UPDATE", function()
        if (not self.Button) then
            return
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

    for i = _G.BACKPACK_CONTAINER, _G.NUM_BAG_SLOTS do
        totalSlots = totalSlots + (_G.GetContainerNumSlots(i) or 0);
        slots = slots + (_G.GetContainerNumFreeSlots(i) or 0);
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

function Inventory:Click(_, button)
	if (button == "LeftButton") then
        _G.ToggleAllBags();
     elseif (button == "RightButton") then
        _G.SortBags();
     end
end