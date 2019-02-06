--luacheck: ignore MayronUI self 143 631
local tk, db, _, _, obj = MayronUI:GetCoreComponents();

local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo;
local select, unpack = _G.select, _G.unpack;

local fieldsList = {};
local OnCombatLogEvent;

local private = {};
private.fields = {};
private.Player = {};
private.Target = {};

-- Objects -----------------------------

local Engine = obj:Import("MayronUI.Engine"); ---@type Engine

---@class TimerBar : FrameWrapper
local C_TimerBar = Engine:CreateClass("TimerBar", "Framework.System.FrameWrapper");

---@class TimerField : FrameWrapper
local C_TimerField = Engine:CreateClass("TimerField", "Framework.System.FrameWrapper");

---@class TimerBarsModule : BaseModule
local C_TimerBarsModule = MayronUI:RegisterModule("TimerBarsModule", "Timer Bars");

-- Load Database Defaults --------------

db:AddToDefaults("profile.timerBars", {
    __templateField = {
        enabled = true;
        direction = "UP"; -- or down
        unit = "player";
        sortByTimeRemaining = true;
        showTooltips = true;

        filters = {
            onlyPlayerBuffs = true;
            onlyPlayerDebuffs = true;
            enableWhitelist = false;
            enableBlacklist = false;

            whitelist = {

            };
            blacklist = {

            };
        };

        appearance = {
            spark = true;
            barHeight = 20;
            barWidth = 213;
            spacing = 2;
            showIcons = true;
            statusBarTexture = "MUI_StatusBar";
            spellName = {
                show = true;
                fontSize = 11;
                font = "MUI_Font";
            };
            time = {
                show = true;
                fontSize = 11;
                font = "MUI_Font";
            };

            colors = {
                background = {
                    r = 0; g = 0; b = 0; a = 0.4;
                };
                basicBuff = {
                    r = 0.1; g = 0.1; b = 0.1; a = 1;
                };
                basicDebuff = {
                    r = 1; g = 0.2; b = 0.2; a = 1;
                };
                canStealOrPurge = {
                    r = 0; g = 0; b = 0; a = 0.4;
                };
                appliedByPlayer = {
                    r = 0; g = 0; b = 0; a = 0.4;
                };
                magicDebuffs = {

                };
                diseaseDebuffs = {

                };
                poisonDebuffs = {

                };
                curseDebuffs = {

                };
            };
        };
    };
});

-- Creates a area where the TimerBars will fit in.
local function CreateTimerField(sv, name)
    local globalName = tk.Strings:Concat("MUI_TimerBar", name, "Field");
	local frame = _G.CreateFrame("Frame", globalName, _G.UIParent);

    frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

	if (sv.unit ~= "Player") then
		if (sv.unit == "Target") then
			frame:RegisterEvent("PLAYER_TARGET_CHANGED");

		elseif (sv.unit == "TargetTarget") then
			frame:RegisterEvent("UNIT_TARGET");

		elseif (sv.unit == "Focus") then
			frame:RegisterEvent("PLAYER_FOCUS_CHANGED");

		elseif (sv.unit == "FocusTarget") then
			frame:RegisterEvent("UNIT_TARGET");
        end

		frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	end

    frame = C_TimerField(sv, name, frame);

    frame:SetSize(sv.barWidth, 200);
    frame.enabled = sv.enabled;

	frame:SetScript("OnUpdate", function(self, _, ...)
		frame:OnUpdate(...);
	end);

	frame:SetScript("OnEvent", function(...)
		frame:OnEvent(...);
	end);

    return frame;
end

local function TimerBar_OnEnter(self)
    if (self.spellID) then
        _G.GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
        _G.GameTooltip:SetSpellByID(self.spellID);
        _G.GameTooltip:Show();
    end
end

local function TimerBar_OnLeave(self)
    _G.GameTooltip:Hide()
end

---@param unitAuraFunc function @Either UnitBuff or UnitDebuff.
local function GetAuraIndexByName(auraName, unitName, unitAuraFunc)
    for i = 1, 40 do
        local debuffName = unitAuraFunc(unitName, i);

        if (not debuffName) then
            return 0;
        end

        if (auraName:lower() == debuffName:lower()) then
            return i;
        end
    end

    return 0; -- TODO: This seems messy (we are creating problems explicitly and then fixing them)
        --TODO: And the pattern is always the same (we always check if it's greater than 0)
end

-- @param unitAuraFunc - either UnitBuff or UnitDebuff
local function GetAuraIndexBySpellId(spellId, unitName, unitAuraFunc)
	for i = 1, 40 do
        local otherSpellId = select(10, unitAuraFunc(unitName, i));

        if (not otherSpellId) then
            -- could not find an active aura with spellId
            return 0;
        end

        if (spellId == otherSpellId) then
            -- found matching spellId, so return aura index
            return i;
        end
    end

    return 0; -- TODO: This seems messy (we are creating problems explicitly and then fixing them)
        --TODO: And the pattern is always the same (we always check if it's greater than 0)
end

------------------------
-- Functions
------------------------
local function HandleUnitEvent(event, frame, unit)
    if (unit ~= "Target" and event == "PLAYER_TARGET_CHANGED") then
        frame:UnregisterEvent(event);
        return;
    end

    if (unit ~= "Focus" and event == "PLAYER_FOCUS_CHANGED") then
        frame:UnregisterEvent(event);
        return;
    end

    if ((unit ~= "TargetTarget" or unit ~= "FocusTarget") and event == "UNIT_TARGET") then
        frame:UnregisterEvent(event);
        return;
    end

    local shown = _G.UnitExists(unit);
    frame:SetShown(shown);

    return shown;
end

----------------
-- C_TimerBar Functions
----------------
function C_TimerBar:__Construct(data, sv)
    data.frame = _G.CreateFrame("Frame", nil, tk.UIParent);

    local bar = data.frame;
    bar.icon = bar:CreateTexture(nil, "ARTWORK");
    bar.icon:SetPoint("TOPLEFT");
    bar.icon:SetPoint("BOTTOMLEFT");

    bar.slider = _G.CreateFrame("StatusBar", nil, bar);
    bar.slider:SetPoint("TOPRIGHT");
    bar.slider:SetPoint("BOTTOMRIGHT");
    bar.slider:SetPoint("TOPLEFT", bar.icon, "TOPRIGHT");
    bar.slider:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMRIGHT");
    bar.slider.bg = tk:SetBackground(bar.slider, 0, 0, 0, 0.5);

    bar.name = bar.slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    bar.name:SetPoint("LEFT", 4, 0);
    bar.name:SetJustifyH("LEFT");
    bar.name:SetWordWrap(false);

    bar.duration = bar.slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    bar.duration:SetPoint("RIGHT", -4, 0);

    bar:SetHeight(sv.barHeight);
    bar.icon:SetWidth(sv.barHeight);
    bar.icon:SetShown(sv.showIcons);

    if (not sv.showIcons) then
        bar.slider:SetPoint("TOPLEFT");
        bar.slider:SetPoint("BOTTOMLEFT");
    else
        bar.slider:SetPoint("TOPLEFT", bar.icon, "TOPRIGHT");
        bar.slider:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMRIGHT");
    end

    if (sv.spark and not bar.spark) then
        bar.spark = bar.slider:CreateTexture(nil, "OVERLAY");
        bar.spark:SetWidth(26);
        bar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark");
        bar.spark:SetVertexColor(1, 1, 1);
        bar.spark:SetBlendMode("ADD");
    end

    local font = tk.Constants.LSM:Fetch("font", sv.spellName.font);

    bar.name:SetFont(font, sv.spellName.fontSize);
    bar.name:SetWidth(sv.barWidth - sv.barHeight - 50);
    bar.name:SetShown(sv.spellName.show);

    font = tk.Constants.LSM:Fetch("font", sv.time.font);

    bar.duration:SetFont(font, sv.time.fontSize);
    bar.duration:SetShown(sv.time.show);

    bar.slider:SetStatusBarTexture(tk.Constants.LSM:Fetch("statusbar", sv.statusBarTexture));

    bar.slider.bg:SetColorTexture(
        sv.background_color.r, sv.background_color.g,
        sv.background_color.b, sv.background_color.a);

    if (db.profile.timerBars.showTooltips) then
        bar:SetScript("OnEnter", TimerBar_OnEnter);
        bar:SetScript("OnLeave", TimerBar_OnLeave);
    else
        bar:SetScript("OnEnter", tk.Constants.DUMMY_FUNC);
        bar:SetScript("OnLeave", tk.Constants.DUMMY_FUNC);
    end
end

-- C_TimerField Functions --------------------

do
    local function compare(a, b)
        return a.slider:GetValue() > b.slider:GetValue();
    end

	---Repositioning of the TimerBars depending on their duration
    function C_TimerField:PositionBars(data)
        if (data.sv.sortByTime) then
            tk.table.sort(data.activeBars, compare);
        end

        local direction = data.direction;

        for _, bar in tk.ipairs(data.activeBars) do
            bar:ClearAllPoints(); -- avoid anchoring problems
            bar:SetParent(data.frame);
            bar:Show();
        end

        for id, bar in tk.ipairs(data.activeBars) do
            if (direction == "UP") then

                if (id == 1) then
                    bar:SetPoint("BOTTOMLEFT");
                    bar:SetPoint("BOTTOMRIGHT");
                else
                    local previous = data.activeBars[id - 1];
                    previous = previous:GetFrame();

                    bar:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, data.spacing);
					bar:SetPoint("BOTTOMRIGHT", previous, "TOPRIGHT", 0, data.spacing);
                end

            elseif (direction == "DOWN") then
                if (id == 1) then
                    bar:SetPoint("TOPLEFT");
                    bar:SetPoint("TOPRIGHT");
                else
                    local previous = data.activeBars[id - 1];
                    previous = previous:GetFrame();

                    bar:SetPoint("TOPLEFT", previous.frame, "BOTTOMLEFT", 0, -data.spacing);
                    bar:SetPoint("TOPRIGHT", previous.frame, "BOTTOMRIGHT", 0, -data.spacing);
                end
            end
        end
    end
end

Engine:DefineParams("Observer", "string", "Frame");
---@param sv Observer @Saved variable pointing to the field.
---@param name string @The name of the timer field.
---@param frame Frame @The underling frame.
function C_TimerField:__Construct(data, sv, name, frame)
    if (not fieldsList[name]) then
        fieldsList[name] = self;

        ----------------------------------
        -- initialise instance variables
        ----------------------------------
        data.name = name;
        data.sv = sv;
		data.frame = frame;

		data.enabled = sv.enabled;

        -- auras to track from database:
		data.buffs = sv.buffs:GetUntrackedTable(); -- a copy of the data as (new references)
        data.debuffs = sv.debuffs:GetUntrackedTable(); -- a copy of the data (new references)

        data.activeBars = obj:PopTable(); -- store bars by order using id
        data.activeBarKeys = obj:PopTable(); -- store bars by name using keys

        data.totalBars = obj:PopTable(); -- stores all bars for appearance updating
        data.settings = obj:PopTable();

        -- settings
        data.trackAllBuffs = sv.trackAllBuffs;
        data.trackAllDebuffs = sv.trackAllDebuffs;

        data.onlyPlayerBuffs = sv.onlyPlayerBuffs;
        data.onlyPlayerDebuffs = sv.onlyPlayerDebuffs;

        data.unit = sv.unit; -- what unit is being tracked?
        data.direction = sv.direction; -- up or down?
        data.spacing = sv.spacing;
        data.debuffBarColor = sv.debuffBarColor:GetUntrackedTable();
        data.buffBarColor = sv.buffBarColor:GetUntrackedTable();
    end

	self:Scan();
end

Engine:DefineParams("number");
---@param buffIndex number @The index of the buff to track.
function C_TimerField:AddBuff(data, buffIndex)
    local buffName, _, count, _, duration, expires, caster, _, _, spellID = _G.UnitBuff(data.unit, buffIndex);

    if ((data.trackAllBuffs or data.buffs and data.buffs[spellID]) and caster and (expires > 0)) then

        if (not (data.onlyPlayerBuffs and caster ~= "player")) then
            local bar = self:AddBar(buffName, spellID, expires, duration, "BUFF", count);
            local c = data.buffBarColor;

            bar.slider:SetStatusBarColor(c.r, c.g, c.b, c.a);

            if (data.trackAllBuffs) then
                if (tk.type(data.buffs[spellID]) ~= "number") then
                    data.buffs[spellID] = buffName;
                    data.sv.buffs[spellID] = buffName;
                end

                local manager = tk.string.format("%s%s", data.name, "BuffsManager");

                if (C_TimerBarsModule[manager] and C_TimerBarsModule[manager].list:IsShown()) then
                    C_TimerBarsModule[manager].list:ScanForItems();
                end

            end

            return
        end
    end
end

function C_TimerField:AddDebuff(data, debuffIndex)
    if (not (debuffIndex) or debuffIndex == 0) then
        return
    end

	local debuffName, _, count, _, duration, expires, caster, _, _, spellID = _G.UnitDebuff(data.unit, debuffIndex);

    if ((data.trackAllDebuffs or data.debuffs and data.debuffs[spellID]) and expires and caster) then

        if (not (data.onlyPlayerDebuffs and caster ~= "player")) then
            local bar = self:AddBar(debuffName, spellID, expires, duration, "DEBUFF", count);

            local c = data.debuffBarColor;
            bar.slider:SetStatusBarColor(c.r, c.g, c.b, c.a);

            if (data.trackAllDebuffs) then
                if (tk.type(data.debuffs[spellID]) ~= "number") then
                    data.debuffs[spellID] = debuffName;
                    data.sv.debuffs[spellID] = debuffName;
                end

                local manager = tk.string.format("%s%s", data.name, "DebuffsManager");
                if (C_TimerBarsModule[manager] and C_TimerBarsModule[manager].list:IsShown()) then
                    C_TimerBarsModule[manager].list:ScanForItems();
                end

            end

            return
        end
    end
end

function C_TimerField:Scan(data)
    if (not data.trackAllBuffs) then
        if (data.buffs) then

            for spellID, bar in tk.pairs(data.activeBarKeys) do
                if (bar.type == "BUFF" and not data.buffs[spellID]) then
                    local id = tk.Tables:GetIndex(data.activeBars, bar);
                    self:RemoveBar(bar, id);
                end
            end

            for spellID, _ in tk.pairs(data.buffs) do
                local auraIndex = GetAuraIndexBySpellId(spellID, data.unit, _G.UnitBuff);

                if (auraIndex > 0) then
                    self:AddBuff(auraIndex);
                end
            end
        end
    else
        for spellID, bar in tk.pairs(data.activeBarKeys) do
            local auraIndex = GetAuraIndexBySpellId(spellID, data.unit, _G.UnitBuff);

            if (bar.type == "BUFF" and not (_G.UnitBuff(data.unit, auraIndex))) then
                local id = tk.Tables:GetIndex(data.activeBars, bar);
                self:RemoveBar(bar, id);
            end
        end

        for i = 1, 40 do
            local auraName = _G.UnitBuff(data.unit, i);

            if (not auraName) then
                break
            end

            self:AddBuff(i);
        end
    end

    if (not data.trackAllDebuffs) then
        if (data.debuffs) then

            for spellID, bar in tk.pairs(data.activeBarKeys) do
                if (bar.type == "DEBUFF" and not data.debuffs[spellID]) then
                    local id = tk.Tables:GetIndex(data.activeBars, bar);
                    self:RemoveBar(bar, id);
                end
            end

            for spellID, _ in tk.pairs(data.debuffs) do
                local auraIndex = GetAuraIndexBySpellId(spellID, data.unit, _G.UnitDebuff);
                self:AddDebuff(auraIndex);
            end
        end
    else
        for spellID, bar in tk.pairs(data.activeBarKeys) do
            local auraIndex = GetAuraIndexBySpellId(spellID, data.unit, _G.UnitDebuff);

            if (bar.type == "DEBUFF" and not (tk.select(1, _G.UnitDebuff(data.unit, auraIndex)))) then
                local id = tk.Tables:GetIndex(data.activeBars, bar);
                self:RemoveBar(bar, id);
            end
        end

        for i = 1, 40 do
            local auraName = _G.UnitDebuff(data.unit, i);
            if (not auraName) then break; end

            self:AddDebuff(i);
        end
    end
end

function C_TimerField:OnUpdate(data)
    local tmp_bars = data.activeBars;

    for id, bar in tk.ipairs(tmp_bars) do
        local duration = bar.expires - _G.GetTime();

        duration = (duration > 0) and duration or 0;
        bar.slider:SetValue(duration);

        if (bar.spark) then
            local _, max = bar.slider:GetMinMaxValues();
            local offset = bar.spark:GetWidth() / 2;
            local barWidth = bar.slider:GetWidth();
            local value = (duration / max) * barWidth - offset;

            if (value > barWidth - offset) then
                value = barWidth - offset;
            end

            bar.spark:SetPoint("LEFT", value, 0);
        end

        duration = tk.string.format("%.1f", duration);

        if (tk.tonumber(duration) > 3600) then
            duration = tk.date("%H:%M:%S", duration);

		elseif (tk.tonumber(duration) > 60) then
            duration = tk.date("%M:%S", duration);

        elseif (duration == "0.0") then
            self:RemoveBar(bar, id);
            return
        end

        bar.duration:SetText(duration);
    end
end

do
    --old:
    -- == "SPELL_AURA_APPLIED" or subEvent == "SPELL_AURA_REFRESH" or subEvent == "SPELL_CAST_SUCCESS"
    local SUB_EVENT_NAMES = {
        SPELL_AURA_APPLIED        = true;
        SPELL_AURA_APPLIED_DOSE   = true;
        SPELL_AURA_BROKEN         = true;
        SPELL_AURA_BROKEN_SPELL   = true;
        SPELL_AURA_REFRESH        = true;
        SPELL_AURA_REMOVED        = true;
        SPELL_AURA_REMOVED_DOSE   = true;
    };

    local COMBAT_LOG_EVENT_UNFILTERED = "COMBAT_LOG_EVENT_UNFILTERED";

    function OnCombatLogEvent(frame, event)
        if (event == COMBAT_LOG_EVENT_UNFILTERED) then
            local payload = obj:PopTable(CombatLogGetCurrentEventInfo());
            local subEvent = (select(2, unpack(payload)));

            if (SUB_EVENT_NAMES[subEvent]) then
                -- local sourceGUID = (select(4, unpack(payload)));
                -- local sourceName = (select(5, unpack(payload)));
                local destGUID = (select(8, unpack(payload)));
                -- local destName = (select(9, unpack(payload)));
                local auraId = (select(12, unpack(payload)));
                local auraName = (select(13, unpack(payload)));
                -- local auraSchool = (select(14, unpack(payload)));
                local auraType = (select(15, unpack(payload)));
                local remainingPoints = (select(16, unpack(payload))); -- test with power shield

                -- check if it should be removed:
                -- local bUnitExists = bar.unit and UnitExists(bar.unit)

                local timerField = FindTimerFieldByGUID(destGUID); -- check the timerField unit type, see if it exists and then compare GUID's

                if (not timerField) then
                    -- no timerField is enabled for the type of destination unit
                    return;
                end

                local info = GetActiveAuraInfoById(auraId, timerField); -- use timerField filters (only buffs or debuffs want showing?)

                if (obj:IsTable(info)) then
                    -- aura found on destination

                    if (info.expirationTime <= 0) then -- TODO: Do I need to compare this with GetTime()?

                    end

                end

                --GetAuraIndexBySpellId
                ---local buffName, iconPath, count, duration, expirationTime, caster, spellID, tt1, tt2, tt3


            -- = UnitAura(bar.unit, auraIndex, filter) -- where filter: HELPFUL (buffs), HARMFUL (debuffs), PLAYER (applied by the player (YOU!)), RAID  (can be applied or dispelled by the player), CANCELABLE, NOT_CANCELABLE  

            -- filters are separated by space
                -- need source vs dest and GUID logic here
                local timerField = GetTimerFieldByDestGUID(destGUID);

                timerField:AddTimerBar(auraId, auraName, auraType);


            --local spellType was not used in his

                -- local spellId, auraName, _, spellType = select(12, _G.unpack(payload));


            -- COMBAT_LOG_EVENT_UNFILTERED events where select(6,...) is the caster, 9 is the spellid, and 10 is the spell name
            -- (used for Target-of-target monitoring)
            -- local c_AURAEVENTS = {

            -- }

            --TODO: Need to handle UNIT_DIED event
    --elseif ( combatEvent == "UNIT_DIED" ) then

        --local tod, event, hideCaster, guidCaster, sourceName, sourceFlags, sourceRaidFlags, guidTarget, nameTarget, _, _, spellid, spell = CombatLogGetCurrentEventInfo()
        -- if ( guidTarget == UnitGUID(self.unit) ) then
    -- if (self.auraName:find(idSpell) or self.auraName:find(nameSpell)) 



                -- self:AddAura(spellType);


                -- if (spellType == "BUFF") then
                --     local buffIndex = GetAuraIndexBySpellId(spellId, data.unit, _G.UnitBuff);
                --     self:AddBuff(buffIndex);

                -- elseif (spellType == "DEBUFF") then
                --     local debuffIndex = GetAuraIndexBySpellId(spellId, data.unit, _G.UnitDebuff);
                --     self:AddDebuff(debuffIndex);

                -- elseif (not spellType) then
                --     --TODO: Weird logic, if not spellType then we try again but with the spellName???
                --     local buffIndex = GetAuraIndexByName(auraName, data.unit, _G.UnitBuff);
                --     local debuffIndex = GetAuraIndexByName(auraName, data.unit, _G.UnitDebuff);

                --     if (buffIndex > 0) then
                --         self:AddBuff(buffIndex);
                --     elseif (debuffIndex > 0) then
                --         self:AddDebuff(debuffIndex);
                --     end
                -- end




            -- elseif (subEvent == "SPELL_AURA_APPLIED_DOSE") then
            --     local spellId, _, _, spellType = tk.select(12, _G.unpack(payload));

            --     if (spellType == "BUFF") then
            --         local buffIndex = GetAuraIndexBySpellId(spellId, data.unit, _G.UnitBuff);
            --         self:AddBuff(buffIndex);

            --     elseif (spellType == "DEBUFF") then
            --         local debuffIndex = GetAuraIndexBySpellId(spellId, data.unit, _G.UnitDebuff);
            --         self:AddDebuff(debuffIndex);
            --     end

            elseif (subEvent == "SPELL_AURA_REMOVED") then
                if (not _G.UnitExists(data.unit)) then
                    return;
                end

                local spellId = select(12, _G.unpack(payload));
                local bar = data.activeBarKeys[spellId];

                self:RemoveBar(bar);
            end

            obj:PushTable(payload);
        elseif (event == "PLAYER_ENTERING_WORLD") then
            if (not _G.UnitExists(data.unit)) then
                frame:Hide();
            end
        else
            local scan = HandleUnitEvent(event, frame, data.unit);
            if (scan) then
                self:Scan();
            end
        end
    end
end

function C_TimerField:AddBar(data, name, spellID, expires, duration, buffType, count)
	local bar = data.activeBarKeys[spellID] or C_TimerBar(data.sv);
    bar.type = buffType;

    if (not data.activeBarKeys[spellID]) then
        data.activeBarKeys[spellID] = bar;
        data.activeBars[#data.activeBars + 1] = bar;

        if (not data.totalBars[spellID..buffType]) then
            data.totalBars[spellID..buffType] = bar;
        end
    end

	if (count and count > 0) then
		bar.name:SetText(count.."x "..name);
	else
		bar.name:SetText(name);
    end

    bar.duration:SetText(duration);
    bar.icon:SetTexture(_G.GetSpellTexture(spellID));
    bar.icon:SetTexCoord(0.1, 0.92, 0.08, 0.92);

    bar.slider:SetMinMaxValues(0, duration);
    bar.slider:SetValue(duration);

    bar.spellID = spellID;
    bar.expires = expires;
    bar.count = count;

    self:PositionBars();

    return bar;
end

function C_TimerField:RemoveBar(data, bar, id)
    if (not (bar)) then
        -- bar is nil so nothing can be done
        return;
    end

    id = id or tk.Tables:GetIndex(data.activeBars, bar) or 0; -- makes id a optional parameter
    tk.table.remove(data.activeBars, id);
    data.activeBarKeys[bar.spellID] = nil;
    bar:ClearAllPoints();
    bar:Hide();

    self:PositionBars();
end

function C_TimerField:SetEnabled(data, enabled)
    data.enabled = enabled;

    if (not enabled) then
        data.frame:Hide();

    elseif (_G.UnitExists(data.unit)) then
        data.frame:Show();
        self:Scan();
    end
end

---------------------
-- TimerBarsModule Functions:
---------------------
function C_TimerBarsModule:OnInitialize(data)
    data.sv = db.profile.timerBars;

	db:AppendOnce(db.profile, "timerBars", {
		fieldNames = {
			"Player", "Target"
		},
		Player = {
			position = {
				point = "BOTTOMLEFT",
				relativeFrame = "MUI_PlayerName",
				relativePoint = "TOPLEFT",
				x = 10, y = 2,
			},
			unit = "Player",
		},
		Target = {
			position = {
				point = "BOTTOMRIGHT",
				relativeFrame = "MUI_TargetName",
				relativePoint = "TOPRIGHT",
				x = -10, y = 2,
			},
			unit = "Target",
		}
	});

    if (data.sv.deleteFields) then
        for name, _ in data.sv.deleteFields:Iterate() do
            data.sv[name] = nil;
            data.sv.deleteFields[name] = nil;
        end
    end

    for _, name in data.sv.fieldNames:Iterate() do
		local sv = data.sv[name];
        sv:SetParent(data.sv.__templateField);

        local field = CreateTimerField(sv, name);
        local position = sv.position;

        private.fields[#private.fields + 1] = field;

        if (position) then
            field:SetPoint(
                position.point, tk._G[position.relativeFrame],
                position.relativePoint, position.x, position.y);
        else
            field:SetPoint("CENTER");
        end
    end
end

function C_TimerBarsModule:RefreshFields()
    for _, field in tk.ipairs(private.fields) do
        -- update true data:
        local data = C_TimerField.Static:GetData(field);

        data.buffs = data.sv.buffs:GetTable();
        data.debuffs = data.sv.debuffs:GetTable();
        data.trackAllBuffs = data.sv.trackAllBuffs;
        data.trackAllDebuffs = data.sv.trackAllDebuffs;
        data.onlyPlayerBuffs = data.sv.onlyPlayerBuffs;
        data.onlyPlayerDebuffs = data.sv.onlyPlayerDebuffs;

        field:Scan();
    end
end