-- luacheck: ignore MayronUI self 143 631
local tk, db, _, _, obj = MayronUI:GetCoreComponents();

local LABEL_PATTERN = "|cffffffff%s|r mb";

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local Memory = Engine:CreateClass("Memory", nil, "MayronUI.Engine.IDataTextModule");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.memory", {
    enabled = true
});

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

MayronUI:Hook("DataText", "OnInitialize", function(self)
    local sv = db.profile.datatext.memory;
    sv:SetParent(db.profile.datatext);

    local settings = sv:GetTrackedTable();

    if (settings.enabled) then
        local memory = Memory(settings, self);
        self:RegisterDataModule(memory);
    end
end);

function Memory:__Construct(data, settings, dataTextModule)
    data.settings = settings;

    -- set public instance properties
    self.MenuContent = _G.CreateFrame("Frame");
    self.MenuLabels = {};
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = true;
    self.HasRightMenu = false;
    self.SavedVariableName = "memory";
    self.Button = dataTextModule:CreateDataTextButton();
end

function Memory:IsEnabled(data)
    return data.settings.enabled;
end

function Memory:Enable(data)
    data.settings.enabled = true;
    data.settings:SaveChanges();
end

function Memory:Disable(data)
    data.settings.enabled = false;
    data.settings:SaveChanges();

    if (data.handler) then
        data.handler:Destroy();
    end

    self.Button:RegisterForClicks("LeftButtonUp");
end

function Memory:Update(data)
    if (data.executed) then
        return
    end

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

        self.Button:SetText(tk.string.format(LABEL_PATTERN, total));

        tk.C_Timer.After(10, loop);
    end

    loop();
end

function Memory:Click(data)
    local currentIndex = 0;
    local sorted = obj:PopWrapper();

    for i = 1, _G.GetNumAddOns() do
        local _, addOnName, addOnDescription = _G.GetAddOnInfo(i);
        local usage = _G.GetAddOnMemoryUsage(i);

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

            tk.table.insert(sorted, label);
        end
    end

    table.sort(sorted, compare);
    tk.Tables:Empty(self.MenuLabels);
    tk.Tables:AddAll(self.MenuLabels, _G.unpack(sorted));
    obj:PushWrapper(sorted);

    self.TotalLabelsShown = #self.MenuLabels;
end