-- Setup Namespaces ------------------

local _, Core = ...;

local em = Core.EventManager;
local tk = Core.Toolkit;
local db = Core.Database;
local gui = Core.GUIBuilder;
local L = Core.Locale;

local LABEL_PATTERN = "|cffffffff%s|r mb";

-- Register and Import Modules -------

local DataText = MayronUI:ImportModule("BottomUI_DataText");
local MemoryModule, Memory = MayronUI:RegisterModule("DataText_Memory");
local Engine = Core.Objects:Import("MayronUI.Engine");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.memory", {
    enabled = true,
    displayOrder = 5
});

-- Local Functions ----------------

local function CreateLabel(c)
    local label = tk:PopFrame("Frame", c);
    local popupWidth = DataText:GetMenuWidth();

    label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.value = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.name:SetPoint("LEFT", 6, 0);
    label.name:SetPoint("Right", 6, 0);

    label.name:SetWidth(popupWidth * 0.6);
    label.name:SetWordWrap(false);
    label.name:SetJustifyH("LEFT");
    label.value:SetPoint("RIGHT", -10, 0);
    label.value:SetWidth(popupWidth * 0.4);
    label.value:SetWordWrap(false);
    label.value:SetJustifyH("RIGHT");
    tk:SetBackground(label, 0, 0, 0, 0.2);

    return label;
end

local function compare(a, b)
    return a.usage > b.usage;
end

-- Memory Module --------------

MemoryModule:OnInitialize(function(self, data) 
    data.sv = db.profile.datatext.memory;

    if (data.sv.enabled) then
        DataText:RegisterDataItem(self, data.sv.displayOrder);
    end
end);

MemoryModule:OnEnable(function(self, data, btn, content)    
    data.btn = btn;
    data.content = content; -- content?
    data.showMenu = true;
end);

MemoryModule:OnDisable(function(self, data)
    data.showMenu = nil;
    data.disabled = true;
end);

-- Memory Object --------------

function Memory:Update(data)
    if (not override and data.executed) then 
        return; 
    end

    data.executed = true;

    local function loop()
        if (data.disabled) then 
            return; 
        end

        -- Must update first!
        UpdateAddOnMemoryUsage();
        local total = 0;

        for i = 1, GetNumAddOns() do
            total = total + GetAddOnMemoryUsage(i);
        end

        total = (total / 1000);
        total = tk:FormatFloat(1, total);

        data.btn:SetText(tk.string.format(LABEL_PATTERN, total));
        if (not override) then
            tk.C_Timer.After(10, loop);
        end
    end

    loop();
end

function Memory:Click(data, content)
    tk.collectgarbage("collect");
    content.labels = content.labels or {};
    local sorted = {};

    for i = 1, GetNumAddOns() do
        local _, name = GetAddOnInfo(i);
        local usage = GetAddOnMemoryUsage(i);
        local value;

        if (usage > 1000) then
            value = usage / 1000;
            value = tk:FormatFloat(1, value).." mb";
        else
            value = tk:FormatFloat(0, usage).." kb";
        end

        content.labels[i] = content.labels[i] or CreateLabel(content);

        local label = content.labels[i];
        label.name:SetText(name);
        label.value:SetText(value);
        label.usage = usage;

        if (usage > 1) then
            tk.table.insert(sorted, label);
        end
    end

    tk.table.sort(sorted, compare);
    content.labels = sorted;

    return #sorted;
end

function Memory:HasMenu()
    return true;
end

Engine:DefineReturns("Button");
function Memory:GetButton(data)
    return data.btn;
end