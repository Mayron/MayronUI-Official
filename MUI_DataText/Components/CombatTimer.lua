local _, namespace = ...;

-- luacheck: ignore MayronUI self 143 631
local tk, db, em = MayronUI:GetCoreComponents();
local ComponentsPackage = namespace.ComponentsPackage;

local _G = _G;
local GetTime, string, C_Timer = _G.GetTime, _G.string, _G.C_Timer;
local RED_FONT_COLOR_CODE = _G.RED_FONT_COLOR_CODE;

-- Objects ---------------------------

local CombatTimer = ComponentsPackage:CreateClass("CombatTimer", nil, "IDataTextComponent");

-- CombatTimer Module ----------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
    self:RegisterDataModule("combatTimer", CombatTimer);
end);

function CombatTimer:__Construct(data, settings, dataTextModule)
    data.settings = settings;

    -- set public instance properties
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = false;
    self.HasRightMenu = false;
    self.Button = dataTextModule:CreateDataTextButton();

    local font = tk.Constants.LSM:Fetch("font", db.global.core.font);

    data.seconds = self.Button:CreateFontString(nil, "ARTWORK", "MUI_FontNormal");
    data.seconds:SetFont(font, data.settings.fontSize);

    data.minutes = self.Button:CreateFontString(nil, "ARTWORK", "MUI_FontNormal");
    data.minutes:SetFont(font, data.settings.fontSize);
    data.minutes:SetJustifyH("RIGHT");

    data.milliseconds = self.Button:CreateFontString(nil, "ARTWORK", "MUI_FontNormal");
    data.milliseconds:SetFont(font, data.settings.fontSize);
    data.milliseconds:SetJustifyH("LEFT");
    data.seconds:SetPoint("CENTER");
    data.minutes:SetPoint("RIGHT", data.seconds, "LEFT");
    data.milliseconds:SetPoint("LEFT", data.seconds, "RIGHT");
end

function CombatTimer:Click() end

function CombatTimer:IsEnabled(data)
    return data.enabled;
end

function CombatTimer:SetEnabled(data, enabled)
    data.enabled = enabled;

    if (enabled) then
        em:CreateEventHandlerWithKey("PLAYER_REGEN_DISABLED", "DataText_CombatTimer_RegenDisabled", function()
            data.startTime = GetTime();
            data.inCombat = true;
            data.executed = nil;
            self:Update();
        end);

        em:CreateEventHandlerWithKey("PLAYER_REGEN_ENABLED", "DataText_CombatTimer_RegenEnabled", function()
            data.inCombat = nil;
            data.minutes:SetText(data.minutes.value or "00");
            data.seconds:SetText(data.seconds.value or ":00:");
            data.milliseconds:SetText(data.milliseconds.value or "00");
        end);

        data.minutes:SetText("00");
        data.seconds:SetText(":00:");
        data.milliseconds:SetText("00");
    else
        -- Destroy
        em:DestroyEventHandlerByKey("DataText_CombatTimer_RegenDisabled");
        em:DestroyEventHandlerByKey("DataText_CombatTimer_RegenEnabled");

        data.minutes:SetText("");
        data.seconds:SetText("");
        data.milliseconds:SetText("");
    end
end

function CombatTimer:Update(data, refreshSettings)
    if (refreshSettings) then
        data.settings:Refresh();
    end

    if (data.executed) then
        return;
    end

    data.executed = true;

    local function loop()
        if (not data.inCombat) then
            return
        end

        local s = (GetTime() - data.startTime);

        data.minutes.value = string.format("%02d", (s/60)%60);
        data.seconds.value = string.format(":%02d:", s%60);
        data.milliseconds.value = string.format("%02d", (s*100)%100);

        data.minutes:SetText(string.format("%s%s|r", RED_FONT_COLOR_CODE, data.minutes.value));
        data.seconds:SetText(string.format("%s%s|r", RED_FONT_COLOR_CODE, data.seconds.value));
        data.milliseconds:SetText(string.format("%s%s|r", RED_FONT_COLOR_CODE, data.milliseconds.value));

        C_Timer.After(0.05, loop);
    end

    loop();
end