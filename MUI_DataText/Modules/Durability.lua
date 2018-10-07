-- Setup Namespaces ------------------

local _, Core = ...;

local em = Core.EventManager;
local tk = Core.Toolkit;
local db = Core.Database;
local gui = Core.GUIBuilder;
local L = Core.Locale;

local LABEL_PATTERN = "|cffffffff%s|r";

local DURABILITY_SLOTS = {
    "HeadSlot", "ShoulderSlot", "ChestSlot", "WaistSlot", "LegsSlot", "FeetSlot",
    "WristSlot", "HandsSlot", "MainHandSlot", "SecondaryHandSlot"
};

-- Register and Import Modules -------

local DataText = MayronUI:ImportModule("BottomUI_DataText");
local DurabilityModule, Durability = MayronUI:RegisterModule("DataText_Durability");
local Engine = Core.Objects:Import("MayronUI.Engine");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.durability", {
    enabled = true,
    displayOrder = 1
});

-- Local Functions ----------------

local function OnLabelClick(self)
    ChatFrame_SendSmartTell(self.id);
    DataText.slideController:Start();
end

local function CreateLabel(contentFrame)
    local label = tk:PopFrame("Frame", contentFrame);

    label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.value = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.name:SetPoint("LEFT", 6, 0);
    label.name:SetWidth(DataText.sv.menu_width * 0.7); -- needs to be removed!
    label.name:SetWordWrap(false);
    label.name:SetJustifyH("LEFT");
    label.value:SetPoint("RIGHT", -10, 0);
    label.value:SetWidth(DataText.sv.menu_width * 0.3); -- needs to be removed!
    label.value:SetWordWrap(false);
    label.value:SetJustifyH("RIGHT");
    tk:SetBackground(label, 0, 0, 0, 0.2);

    return label;
end

-- Durability Module --------------

DurabilityModule:OnInitialize(function(self, data) 
    data.sv = db.profile.datatext.durability;

    if (data.sv.enabled) then
        --DataText:RegisterDataItem(self);
    end
end);

DurabilityModule:OnEnable(function(self, data, btn)
    data.btn = btn;
    data.showMenu = true;
    data.handler = em:CreateEventHandler("UPDATE_INVENTORY_DURABILITY", function()
        if (not data.btn) then 
            return; 
        end

        self:Update();
    end);

    tk:KillElement(DurabilityFrame);
end);

DurabilityModule:OnDisable(function(self, data)
    if (data.handler) then
        data.handler:Destroy();
    end

    data.showMenu = nil;
end);

-- Durability Object --------------

function Durability:Update(data)
    local durability_total, max_total = 0, 0;
    local itemsEquipped;

    for i, slotName in tk.ipairs(DURABILITY_SLOTS) do
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
        local format_value = tk:FormatFloat(1, value);
        local colored;

        if (value < 25) then
            colored = tk.string.format("%s%s%%|r", RED_FONT_COLOR_CODE, format_value);

        elseif (value < 40) then
            colored = tk.string.format("%s%s%%|r", ORANGE_FONT_COLOR_CODE, format_value);

        elseif (value < 70) then
            colored = tk.string.format("%s%s%%|r", YELLOW_FONT_COLOR_CODE, format_value);

        else
            colored = tk.string.format("%s%s%%|r", HIGHLIGHT_FONT_COLOR_CODE, format_value);

        end
        data.btn:SetText(tk.string.format(L["Armor"]..": %s", colored));
    else
        data.btn:SetText(L["Armor"]..": |cffffffffnone|r");
    end
end

function Durability:Click(data)
    local numLabelsShown = 0;
    local index = 0;

    data.content.labels = data.content.labels or {};

    for _, slotName in tk.ipairs(DURABILITY_SLOTS) do
        local id = GetInventorySlotInfo(slotName);
        local durability, max = GetInventoryItemDurability(id);

        if (durability) then
            index = index + 1;
            numLabelsShown = numLabelsShown + 1;

            local value = (durability / max) * 100;
            local alert = GetInventoryAlertStatus(id);
            local label = data.content.labels[numLabelsShown] or CreateLabel(data.content);

            data.content.labels[numLabelsShown] = label;
            slotName = slotName:gsub("Slot", "");
            slotName = tk:SplitCamelString(slotName);
            
            label.name:SetText(L[slotName]);

            if (alert == 0) then
                label.value:SetTextColor(1, 1, 1);
            else
                local c = INVENTORY_ALERT_COLORS[alert];
                label.value:SetTextColor(c.r, c.g, c.b);
            end

            label.value:SetText(tk.string.format("%u%%", value));
        end
    end

    return DataText:PositionLabels(data.content, numLabelsShown);
end

function Durability:HasMenu()
    return true;
end

Engine:DefineReturns("Button");
function Durability:GetButton(data)
    return data.btn;
end