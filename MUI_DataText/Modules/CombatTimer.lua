-- Setup Namespaces ------------------

local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local DataText = MayronUI:ImportModule("DataText");
local CombatTimer = Engine:CreateClass("CombatTimer", nil, "MayronUI.Engine.IDataTextModule");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.combatTimer", {
    enabled = true,
    displayOrder = 3
});

-- CombatTimer Module ----------------

DataText:Hook("OnInitialize", function(self)
    local sv = db.profile.datatext.combatTimer;
    print("ok2")
    print(sv.displayOrder)

    if (sv.enabled) then
        print("Ok")
        local combatTimer = CombatTimer(sv);
        self:RegisterDataModule(combatTimer);
    end
end);

function CombatTimer:__Construct(data, sv)
    data.sv = sv;

    -- set public instance properties
    self.MenuContent = CreateFrame("Frame");
    self.MenuLabels = {};
    self.TotalLabelsShown = 0;
    self.HasMenu = false;
    self.Button = CreateFrame("Button");
    self.ButtonID = sv.diplayOrder;
    self.ModuleName = "Combat Timer"

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
end

function CombatTimer:Click(data) 

end

function CombatTimer:IsEnabled(data) 

end

function CombatTimer:Update(data) 
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

function CombatTimer:Disable(data) 
    em:FindHandlerByKey("PLAYER_REGEN_DISABLED", "combatTimer"):Destroy();
    em:FindHandlerByKey("PLAYER_REGEN_ENABLED", "combatTimer"):Destroy();

    data.btn.minutes:SetText("");
    data.btn.seconds:SetText("");
    data.btn.milliseconds:SetText("");
end