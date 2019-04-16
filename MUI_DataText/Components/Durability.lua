local _, namespace = ...;

-- luacheck: ignore MayronUI self 143 631
local tk, _, em, _, _, L = MayronUI:GetCoreComponents();
local ComponentsPackage = namespace.ComponentsPackage;

local DURABILITY_SLOTS = {
    "HeadSlot", "ShoulderSlot", "ChestSlot", "WaistSlot", "LegsSlot", "FeetSlot",
    "WristSlot", "HandsSlot", "MainHandSlot", "SecondaryHandSlot"
};

local _G = _G;
local ipairs, GetInventorySlotInfo, GetInventoryItemDurability, GetInventoryAlertStatus, CreateFrame, DurabilityFrame, string =
_G.ipairs, _G.GetInventorySlotInfo, _G.GetInventoryItemDurability, _G.GetInventoryAlertStatus, _G.CreateFrame, _G.DurabilityFrame, _G.string;

local RED_FONT_COLOR_CODE = _G.RED_FONT_COLOR_CODE;
local ORANGE_FONT_COLOR_CODE = _G.ORANGE_FONT_COLOR_CODE;
local YELLOW_FONT_COLOR_CODE = _G.YELLOW_FONT_COLOR_CODE;
local HIGHLIGHT_FONT_COLOR_CODE = _G.HIGHLIGHT_FONT_COLOR_CODE;
local INVENTORY_ALERT_COLORS = _G.INVENTORY_ALERT_COLORS;

-- Register and Import Modules -------

local Durability = ComponentsPackage:CreateClass("Durability", nil, "IDataTextComponent");

-- Local Functions ----------------

local function CreateLabel(contentFrame, popupWidth)
    local label = tk:PopFrame("Frame", contentFrame);

    label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.value = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");

    label.name:SetPoint("LEFT", 6, 0);
    label.name:SetWidth(popupWidth * 0.7); -- needs to be removed!
    label.name:SetWordWrap(false);
    label.name:SetJustifyH("LEFT");

    label.value:SetPoint("RIGHT", -10, 0);
    label.value:SetWidth(popupWidth * 0.3); -- needs to be removed!
    label.value:SetWordWrap(false);
    label.value:SetJustifyH("RIGHT");

    tk:SetBackground(label, 0, 0, 0, 0.2);

    return label;
end

-- Durability Module --------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
    self:RegisterComponentClass("durability", Durability);
end);

function Durability:__Construct(data, settings, dataTextModule)
    data.settings = settings;

    -- set public instance properties
    self.MenuContent = CreateFrame("Frame");
    self.MenuLabels = {};
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = true;
    self.HasRightMenu = false;
    self.Button = dataTextModule:CreateDataTextButton();
end

function Durability:IsEnabled(data)
    return data.enabled;
end

function Durability:SetEnabled(data, enabled)
    data.enabled = enabled;

    if (enabled) then
        data.handler = em:CreateEventHandler("UPDATE_INVENTORY_DURABILITY", function()
            if (not self.Button) then
                return
            end

            self:Update();
        end);

        tk:KillElement(DurabilityFrame);

    elseif (data.handler) then
        data.handler:Destroy();
        data.handler = nil;
    end
end

function Durability:Update(data, refreshSettings)
    if (refreshSettings) then
        data.settings:Refresh();
    end

    local durability_total, max_total = 0, 0;
    local itemsEquipped;

    for _, slotName in ipairs(DURABILITY_SLOTS) do
        local id = GetInventorySlotInfo(slotName);
        local durability, max = GetInventoryItemDurability(id);

        if (durability) then
            durability_total = durability_total + durability;
            max_total = max_total + max;
            itemsEquipped = true;
        end
    end

    local value = (durability_total / max_total) * 100;

    if (itemsEquipped) then
        local realValue = tk.Numbers:ToPrecision(value, 1);
        local colored;

        if (value < 25) then
            colored = string.format("%s%s%%|r", RED_FONT_COLOR_CODE, realValue);

        elseif (value < 40) then
            colored = string.format("%s%s%%|r", ORANGE_FONT_COLOR_CODE, realValue);

        elseif (value < 70) then
            colored = string.format("%s%s%%|r", YELLOW_FONT_COLOR_CODE, realValue);

        else
            colored = string.format("%s%s%%|r", HIGHLIGHT_FONT_COLOR_CODE, realValue);
        end

       self.Button:SetText(string.format(L["Armor"]..": %s", colored));
    else
       self.Button:SetText(L["Armor"]..": |cffffffffnone|r");
    end
end

function Durability:Click(data)
    local totalLabelsShown = 0;
    local index = 0;

    for _, slotName in ipairs(DURABILITY_SLOTS) do
        local id = GetInventorySlotInfo(slotName);
        local durability, max = GetInventoryItemDurability(id);

        if (durability) then
            index = index + 1;
            totalLabelsShown = totalLabelsShown + 1;

            local value = (durability / max) * 100;
            local alert = GetInventoryAlertStatus(id);

            -- get or create new label
            local label = self.MenuLabels[totalLabelsShown] or
                CreateLabel(self.MenuContent, data.settings.popup.width);

            self.MenuLabels[totalLabelsShown] = label;

            slotName = slotName:gsub("Slot", "");
            slotName = tk.Strings:SplitByCamelCase(slotName);

            label.name:SetText(L[slotName]);

            if (alert == 0) then
                label.value:SetTextColor(1, 1, 1);
            else
                local c = INVENTORY_ALERT_COLORS[alert];
                label.value:SetTextColor(c.r, c.g, c.b);
            end

            label.value:SetText(string.format("%u%%", value));
        end
    end

    self.TotalLabelsShown = totalLabelsShown;
end