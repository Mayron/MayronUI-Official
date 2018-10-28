-- Setup Namespaces ------------------

local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local DataText = MayronUI:ImportModule("DataText");
local CombatTimer = Engine:CreateClass("CombatTimer", nil, "MayronUI.Engine.IDataTextModule");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.combatTimer", {
    enabled = false,
    displayOrder = 4
});

-- CombatTimer Module ----------------

DataText:Hook("OnInitialize", function(self, dataTextData)
    local sv = db.profile.datatext.combatTimer;
    sv:SetParent(dataTextData.sv);

    if (sv.enabled) then
        local combatTimer = CombatTimer(sv);
        self:RegisterDataModule(combatTimer);
    end
end);

function CombatTimer:__Construct(data, sv)
    data.sv = sv;
    data.displayOrder = sv.displayOrder;

    -- set public instance properties
    self.MenuContent = CreateFrame("Frame");
    self.MenuLabels = {};
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = false;
    self.HasRightMenu = false;

    em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
        data.startTime = GetTime();
        data.inCombat = true;
        data.executed = nil;
        self:Update();
    end):SetKey("combat_timer");

    em:CreateEventHandler("PLAYER_REGEN_ENABLED", function()
        data.inCombat = nil;
        data.minutes:SetText(data.minutes.value or "00");
        data.seconds:SetText(data.seconds.value or ":00:");
        data.milliseconds:SetText(data.milliseconds.value or "00");

    end):SetKey("combat_timer");
  
    local font = tk.Constants.LSM:Fetch("font", db.global.Core.font);

    -- create datatext button
    self.Button = DataText:CreateDataTextButton(self);

    data.seconds = self.Button:CreateFontString(nil, "ARTWORK", "MUI_FontNormal");
    data.seconds:SetFont(font, sv.fontSize);
    
    data.minutes = self.Button:CreateFontString(nil, "ARTWORK", "MUI_FontNormal");
    data.minutes:SetFont(font, sv.fontSize);
    data.minutes:SetJustifyH("RIGHT");

    data.milliseconds = self.Button:CreateFontString(nil, "ARTWORK", "MUI_FontNormal");
    data.milliseconds:SetFont(font, sv.fontSize);
    data.milliseconds:SetJustifyH("LEFT");

    data.minutes:SetText("00");
    data.seconds:SetText(":00:");
    data.milliseconds:SetText("00");
    
    data.seconds:SetPoint("CENTER");
    data.minutes:SetPoint("RIGHT", data.seconds, "LEFT");
    data.milliseconds:SetPoint("LEFT", data.seconds, "RIGHT");
end

function CombatTimer:Click(data) end

function CombatTimer:IsEnabled(data) 
    return data.sv.enabled;
end

function CombatTimer:Enable(data) 
    data.sv.enabled = true;
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

        data.minutes.value = tk.string.format("%02d", (s/60)%60);
        data.seconds.value = tk.string.format(":%02d:", s%60);
        data.milliseconds.value = tk.string.format("%02d", (s*100)%100);

        data.minutes:SetText(tk.string.format("%s%s|r", RED_FONT_COLOR_CODE, data.minutes.value));
        data.seconds:SetText(tk.string.format("%s%s|r", RED_FONT_COLOR_CODE, data.seconds.value));
        data.milliseconds:SetText(tk.string.format("%s%s|r", RED_FONT_COLOR_CODE, data.milliseconds.value));

        if (not override) then
            tk.C_Timer.After(0.05, loop);
        end
    end

    loop();
end

function CombatTimer:Disable(data) 
    data.sv.enabled = false;

    em:FindHandlerByKey("PLAYER_REGEN_DISABLED", "combatTimer"):Destroy();
    em:FindHandlerByKey("PLAYER_REGEN_ENABLED", "combatTimer"):Destroy();

    data.minutes:SetText("");
    data.seconds:SetText("");
    data.milliseconds:SetText("");
end

function CombatTimer:GetDisplayOrder(data)
    return data.displayOrder;
end

function CombatTimer:SetDisplayOrder(data, displayOrder)
    if (data.displayOrder ~= displayOrder) then
        data.displayOrder = displayOrder;
        data.sv.displayOrder = displayOrder;
    end
end 