-- Setup Namespaces ------------------

local _, Core = ...;

local em = Core.EventManager;
local tk = Core.Toolkit;
local db = Core.Database;
local gui = Core.GUIBuilder;
local L = Core.Locale;

-- Register and Import Modules -------

local DataText = MayronUI:ImportModule("BottomUI_DataText");
local CombatTimerModule, CombatTimer = MayronUI:RegisterModule("DataText_CombatTimer");
local Engine = Core.Objects:Import("MayronUI.Engine");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.combat_timer", {
    enabled = false,
    displayOrder = 3
});

-- CombatTimer Module ----------------

CombatTimerModule:OnInitialize(function(self, data) 
    data.sv = db.profile.datatext.combat_timer;

    if (data.sv.enabled) then
        DataText:RegisterDataItem(self, data.sv.displayOrder);
    end
end);

CombatTimerModule:OnEnable(function(self, data, btn)
    data.btn = btn;

    em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
        data.startTime = GetTime();
        data.inCombat = true;
        data.executed = nil;
        self:Update();

    end):SetKey("combat_timer");

    em:CreateEventHandler("PLAYER_REGEN_ENABLED", function()
        data.inCombat = nil;
        data.btn.minutes:SetText(self.minutes or "00");
        data.btn.seconds:SetText(self.seconds or ":00:");
        data.btn.milliseconds:SetText(self.milliseconds or "00");

    end):SetKey("combat_timer");

    data.showMenu = nil;    
    local font = tk.Constants.LSM:Fetch("font", db.global.Core.font);

    data.btn.seconds = data.btn:CreateFontString(nil, "ARTWORK", "MUI_FontNormal");
    data.btn.seconds:SetFont(font, DataText.sv.font_size);
    data.btn.minutes = data.btn:CreateFontString(nil, "ARTWORK", "MUI_FontNormal");
    data.btn.minutes:SetFont(font, DataText.sv.font_size);
    data.btn.minutes:SetJustifyH("RIGHT");

    data.btn.milliseconds = data.btn:CreateFontString(nil, "ARTWORK", "MUI_FontNormal");
    data.btn.milliseconds:SetFont(font, DataText.sv.font_size);
    data.btn.milliseconds:SetJustifyH("LEFT");
    data.btn.minutes:SetText("00");
    data.btn.seconds:SetText(":00:");
    data.btn.milliseconds:SetText("00");

    data.btn:SetText("");
    data.btn.seconds:SetPoint("CENTER");
    data.btn.minutes:SetPoint("RIGHT", self.btn.seconds, "LEFT");
    data.btn.milliseconds:SetPoint("LEFT", self.btn.seconds, "RIGHT");
end);

CombatTimerModule:OnDisable(function(self, data)
    em:FindHandlerByKey("PLAYER_REGEN_DISABLED", "combat_timer"):Destroy();
    em:FindHandlerByKey("PLAYER_REGEN_ENABLED", "combat_timer"):Destroy();

    data.btn.minutes:SetText("");
    data.btn.seconds:SetText("");
    data.btn.milliseconds:SetText("");
end);

-- CombatTimer Object -----------------------------

function CombatTimer:Update(data, override)
    if (not override and data.executed) then 
        return; 
    end

    data.executed = true;

    local function loop()
        if (not data.inCombat) then 
            return; 
        end

        local s = (GetTime() - data.startTime);

        data.minutes = tk.string.format("%02d", (s/60)%60);
        data.seconds = tk.string.format(":%02d:", s%60);
        data.milliseconds = tk.string.format("%02d", (s*100)%100);

        data.btn.minutes:SetText(RED_FONT_COLOR_CODE .. data.minutes .. "|r");
        data.btn.seconds:SetText(RED_FONT_COLOR_CODE .. data.seconds .. "|r");
        data.btn.milliseconds:SetText(RED_FONT_COLOR_CODE .. data.milliseconds .. "|r");

        if (not override) then
            tk.C_Timer.After(0.05, loop);
        end
    end

    loop();
end

function CombatTimer:HasMenu()
    return false;
end

Engine:DefineReturns("Button");
function CombatTimer:GetButton(data)
    return data.btn;
end