-- Setup Namespaces ------------------

local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local LABEL_PATTERN = "|cffffffff%s|r";

local DURABILITY_SLOTS = {
    "HeadSlot", "ShoulderSlot", "ChestSlot", "WaistSlot", "LegsSlot", "FeetSlot",
    "WristSlot", "HandsSlot", "MainHandSlot", "SecondaryHandSlot"
};

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local DataText = MayronUI:ImportModule("DataText");
local Durability = Engine:CreateClass("Durability", nil, "MayronUI.Engine.IDataTextModule");

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

DataText:Hook("OnInitialize", function(self, dataTextData)
    local sv = db.profile.datatext.durability;
    sv:SetParent(dataTextData.sv);

    if (sv.enabled) then
        local durability = Durability(sv);
        self:RegisterDataModule(durability);
    end
end);

function Durability:__Construct(data, sv)
    data.sv = sv;
    data.displayOrder = sv.displayOrder;

    -- set public instance properties
    self.MenuContent = CreateFrame("Frame");
    self.MenuLabels = {};
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = true;
    self.HasRightMenu = false;
    self.Button = DataText:CreateDataTextButton(self);
end

function Durability:IsEnabled(data) 
    return data.sv.enabled;
end

function Durability:Enable(data)
    data.sv.enabled = true;

    data.showMenu = true;
    data.handler = em:CreateEventHandler("UPDATE_INVENTORY_DURABILITY", function()
        if (notself.Button) then 
            return; 
        end

        self:Update();
    end);

    tk:KillElement(DurabilityFrame);
end

function Durability:Disable(data)
    data.sv.enabled = false;

    if (data.handler) then
        data.handler:Destroy();
    end

    data.showMenu = nil;
end;

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
        local realValue = tk.Numbers:ToPrecision(value, 2);
        local colored;

        if (value < 25) then
            colored = tk.string.format("%s%s%%|r", RED_FONT_COLOR_CODE, realValue);

        elseif (value < 40) then
            colored = tk.string.format("%s%s%%|r", ORANGE_FONT_COLOR_CODE, realValue);

        elseif (value < 70) then
            colored = tk.string.format("%s%s%%|r", YELLOW_FONT_COLOR_CODE, realValue);

        else
            colored = tk.string.format("%s%s%%|r", HIGHLIGHT_FONT_COLOR_CODE, realValue);
        end

       self.Button:SetText(tk.string.format(L["Armor"]..": %s", colored));
    else
       self.Button:SetText(L["Armor"]..": |cffffffffnone|r");
    end
end

function Durability:Click(data)
    local totalLabelsShown = 0;
    local index = 0;

    for _, slotName in tk.ipairs(DURABILITY_SLOTS) do
        local id = GetInventorySlotInfo(slotName);
        local durability, max = GetInventoryItemDurability(id);

        if (durability) then
            index = index + 1;
            totalLabelsShown = totalLabelsShown + 1;

            local value = (durability / max) * 100;
            local alert = GetInventoryAlertStatus(id);

            -- get or create new label
            local label = self.MenuLabels[totalLabelsShown] or CreateLabel(self.MenuContent, data.sv.popup.width);
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

            label.value:SetText(tk.string.format("%u%%", value));
        end
    end

    self.TotalLabelsShown = totalLabelsShown;
end

function Durability:GetDisplayOrder(data)
    return data.displayOrder;
end

function Durability:SetDisplayOrder(data, displayOrder)
    if (data.displayOrder ~= displayOrder) then
        data.displayOrder = displayOrder;
        data.sv.displayOrder = displayOrder;
    end
end 