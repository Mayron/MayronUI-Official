local _, namespace = ...;

-- luacheck: ignore MayronUI self 143 631
local tk, _, _, _, obj = MayronUI:GetCoreComponents();
local ComponentsPackage = namespace.ComponentsPackage;
local LABEL_PATTERN = "|cffffffff%s|r mb";

local _G = _G;
local C_Timer, string, table, GetNumAddOns, GetAddOnInfo, GetAddOnMemoryUsage =
_G.C_Timer, _G.string, _G.table, _G.GetNumAddOns, _G.GetAddOnInfo, _G.GetAddOnMemoryUsage;

-- Register and Import Modules -------

local Memory = ComponentsPackage:CreateClass("Memory", nil, "IDataTextComponent");

-- Local Functions ----------------

local function CreateLabel(contentFrame, popupWidth)
    local label = tk:PopFrame("Frame", contentFrame);

    label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.name:SetPoint("LEFT", 6, 0);
    label.name:SetPoint("Right", 6, 0);
    label.name:SetWidth(popupWidth * 0.6);
    label.name:SetWordWrap(false);
    label.name:SetJustifyH("LEFT");

    label.value = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
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

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
    self:RegisterComponentClass("memory", Memory);
end);

function Memory:__Construct(data, settings, dataTextModule)
    data.settings =  settings;

    -- set public instance properties
    self.MenuContent = _G.CreateFrame("Frame");
    self.MenuLabels = obj:PopTable();
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = true;
    self.HasRightMenu = false;
    self.Button = dataTextModule:CreateDataTextButton();
end

function Memory:IsEnabled(data)
    return data.enabled;
end

function Memory:SetEnabled(data, enabled)
    data.enabled = enabled;
end

function Memory:Update(data, refreshSettings)
    if (refreshSettings) then
        data.settings:Refresh();
    end

    if (data.executed) then return end

    data.executed = true;

    local function loop()
        if (data.disabled) then
            return
        end

        -- Must update first!
        _G.UpdateAddOnMemoryUsage();
        local total = 0;

        for i = 1, _G.GetNumAddOns() do
            total = total + _G.GetAddOnMemoryUsage(i);
        end

        total = (total / 1000);
        total = tk.Numbers:ToPrecision(total, 2);

        self.Button:SetText(string.format(LABEL_PATTERN, total));

        C_Timer.After(10, loop);
    end

    loop();
end

function Memory:Click(data)
    local currentIndex = 0;
    local sorted = obj:PopTable();

    for i = 1, GetNumAddOns() do
        local _, addOnName, addOnDescription = GetAddOnInfo(i);
        local usage = GetAddOnMemoryUsage(i);

        if (usage > 1) then
            currentIndex = currentIndex + 1;

            local label = self.MenuLabels[currentIndex] or
                CreateLabel(self.MenuContent, data.settings.popup.width);

            local value;

            if (usage > 1000) then
                value = usage / 1000;
                value = tk.Numbers:ToPrecision(value, 1);
                value = string.format("%smb", value);
            else
                value = tk.Numbers:ToPrecision(usage, 0);
                value = string.format("%skb", value);
            end

            -- Set a max length for addon names so they fit correctly.
            -- Had issue ignoringthe color code so I took this out for now.
            -- addOnName = tk.Strings:RemoveColorCode(addOnName);
            -- addOnName = tk.Strings:SetOverflow(addOnName, 15);

            label.name:SetText(addOnName);
            label.value:SetText(value);
            label.usage = usage;

            tk:SetBasicTooltip(label, addOnDescription);

            table.insert(sorted, label);
        end
    end

    table.sort(sorted, compare);
    tk.Tables:Empty(self.MenuLabels);
    tk.Tables:AddAll(self.MenuLabels, _G.unpack(sorted));
    obj:PushTable(sorted);

    self.TotalLabelsShown = #self.MenuLabels;
end