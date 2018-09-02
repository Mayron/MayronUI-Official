------------------------
-- Setup namespaces
------------------------
local _, TimerBars = ...;
local core = MayronUI:ImportModule("MUI_Core");
local tk = core.Toolkit;
local db = core.Database;

local private = {};
private.fields = {};
private.Player = {};
private.Target = {};

MayronUI:RegisterModule("TimerBars", TimerBars);

----------------
-- defaults:
----------------
db:AddToDefaults("profile.timer_bars", {
    field_names = {},
    field = {
        enabled = true,
        spark = true,
        bar_height = 20,
        bar_width = 213,
        spacing = 2,
        show_icons = true,
        direction = "UP", -- or down
        unit = "Player",
        track_all_buffs = true,
        track_all_debuffs = true,
        only_player_buffs = true,
        only_player_debuffs = true,
        spell_name = {
            show = true,
            font_size = 11,
            font = "MUI_Font",
        },
        buffs = {},
        debuffs = {},
        time = {
            show = true,
            font_size = 11,
            font = "MUI_Font",
        },
        background_color = {
            r = 0, g = 0, b = 0, a = 0.4,
        },
        buff_bar_color = {
            r = 0.1, g = 0.1, b = 0.1, a = 1
        },
        debuff_bar_color = {
            r = 1, g = 0.2, b = 0.2, a = 1
        },
    },
    sort_by_time = true,
    show_tooltips = true,
    status_bar_texture = "MUI_StatusBar",
});

----------------
-- bars:
----------------
local bar_OnEnter = function(self)
    if (self.spellID) then
        GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
        GameTooltip:SetSpellByID(self.spellID);
        GameTooltip:Show();
    end
end

local bar_OnLeave = function(self)
    GameTooltip:Hide()
end

local function GetBuffIndexByName(auraName, unitName)
if not auraName then return; end
if (tk.type(auraName) == "number") then 
	return GetBuffIndexBySpellId(auraName, unitName);
end
    for i = 1, 40 do
        local name = UnitBuff(unitName, i)
        if not name then return 0; end
        
        if auraName:lower() == name:lower() then
            return i;
        end
    end

    return 0;
end

local function GetBuffIndexBySpellId(spellId, unitName)
if not spellId then return; end
	for i = 1, 40 do
        local spId = tk.select(10, UnitBuff(unitName, i));
        if not spId then return 0; end
        if spellId == spId then
            return i;
        end
    end
    return 0;
end

local function GetDebuffIndexByName(auraName, unitName)
if not auraName then return; end
if (tk.type(auraName) == "number") then 
	return GetDebuffIndexBySpellId(auraName, unitName);
end
    for i = 1, 40 do
        local name = UnitDebuff(unitName, i)
        if not name then return 0; end
        
        if auraName:lower() == name:lower() then
            return i;
        end
    end

    return 0;
end

local function GetDebuffIndexBySpellId(spellId, unitName)
if not spellId then return; end
	for i = 1, 40 do
        local spId = tk.select(10, UnitDebuff(unitName, i));
        if not spId then return 0; end
        if spellId == spId then
            return i;
        end
    end
    return 0;
end

--[[
local function GetAuraIndexByName(auraName, unitName)
	local name;
	if (unitName == "Player") then
		for i = 1, 40 do
			name = UnitBuff(unitName, i)
			if not name then return 0; end

			if auraName:lower() == name:lower() then
				return i;
			end
		end
	elseif(unitName == "Target") then
		for i = 1, 40 do
			name = UnitBuff(unitName, i)
			if not name then break; end
			if auraName:lower() == name:lower() then
				return i;
			end
		end
		for i = 1, 40 do
			name = UnitDebuff(unitName, i)
			if not name then return 0; end
			if auraName:lower() == name:lower() then
				return i;
			end
		end
	end
	return 0;
end
]]

TimerBars.bars = tk:CreateStack(
    function(self, sv)
        local bar = tk.CreateFrame("Frame", nil, tk.UIParent);
        bar.icon = bar:CreateTexture(nil, "ARTWORK");
        bar.icon:SetPoint("TOPLEFT");
        bar.icon:SetPoint("BOTTOMLEFT");
        bar.slider = tk.CreateFrame("StatusBar", nil, bar);
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

        -- UPDATE:
        bar:SetHeight(sv.bar_height);
        bar.icon:SetWidth(sv.bar_height);
        bar.icon:SetShown(sv.show_icons);
        if (not sv.show_icons) then
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
        local font = tk.Constants.LSM:Fetch("font", sv.spell_name.font);
        bar.name:SetFont(font, sv.spell_name.font_size);
        bar.name:SetWidth(sv.bar_width - sv.bar_height - 50);
        font = tk.Constants.LSM:Fetch("font", sv.time.font);
        bar.duration:SetFont(font, sv.time.font_size);
        bar.name:SetShown(sv.spell_name.show);
        bar.duration:SetShown(sv.time.show);
        bar.slider:SetStatusBarTexture(tk.Constants.LSM:Fetch("statusbar", TimerBars.sv.status_bar_texture));
        bar.slider.bg:SetColorTexture(sv.background_color.r, sv.background_color.g,
            sv.background_color.b, sv.background_color.a);
        if (TimerBars.sv.show_tooltips) then
            bar:SetScript("OnEnter", bar_OnEnter);
            bar:SetScript("OnLeave", bar_OnLeave);
        else
            bar:SetScript("OnEnter", tk.Constants.DUMMY_FUNC);
            bar:SetScript("OnLeave", tk.Constants.DUMMY_FUNC);
        end
        return bar;
    end
);

------------------------
-- Private Functions
------------------------
function private:HandleUnitEvent(event, frame, unit)
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
    local shown = UnitExists(unit);
    frame:SetShown(shown);
    return shown;
end

------------------------
-- Field Prototype
------------------------
local Field = tk:CreateProtectedPrototype("Field", true);

-- static
function Field:Create(name)
    if (not TimerBars.sv[name]) then
        TimerBars.sv[name] = {}; -- cannot do: TimerBars.sv[name] = TimerBars.sv[name] or {}; as it's an observer!
    end

    local sv = TimerBars.sv[name];
    sv:SetParent(TimerBars.sv.field); -- Database inheritance

    if (not Field[name]) then
        local frame = tk.CreateFrame("Frame", "MUI_TimerBar"..name.."Field", tk.UIParent);
        frame:SetSize(sv.bar_width, 200);

        Field[name] = Field({
            name = name,
            sv = sv,
            -- true data:
            track_all_buffs = sv.track_all_buffs,
            track_all_debuffs = sv.track_all_debuffs,
            buffs = sv.buffs:GetTable(),
            debuffs = sv.debuffs:GetTable(),
            only_player_buffs = sv.only_player_buffs,
            only_player_debuffs = sv.only_player_debuffs,
            active_bars = {}, -- store bars by order using id
            active_bar_keys = {}, -- store bars by name using keys
            total_bars = {}, -- stores all bars for appearance updating

            -- settings:
            unit = sv.unit,
            direction = sv.direction,
            spacing = sv.spacing,
            debuff_bar_color = sv.debuff_bar_color:GetTable(),
            buff_bar_color = sv.buff_bar_color:GetTable()
        }, frame);

        Field[name]:SetEnabled(sv.enabled);
        Field[name]:SetScript("OnUpdate", function(self, data, ...)
            Field[name]:OnUpdate(...);
        end);
        Field[name]:SetScript("OnEvent", function(...)
            Field[name]:OnEvent(...);
        end);

        Field[name]:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        if (sv.unit ~= "Player") then
            if (sv.unit == "Target") then
                Field[name]:RegisterEvent("PLAYER_TARGET_CHANGED");

            elseif (sv.unit == "TargetTarget") then
                Field[name]:RegisterEvent("UNIT_TARGET");

            elseif (sv.unit == "Focus") then
                Field[name]:RegisterEvent("PLAYER_FOCUS_CHANGED");

            elseif (sv.unit == "FocusTarget") then
                Field[name]:RegisterEvent("UNIT_TARGET");

            end
            Field[name]:RegisterEvent("PLAYER_ENTERING_WORLD");
        end
    end

    Field[name]:Scan();
    return Field[name];
end

function Field:AddBuff(data, buffIndex)
    if (not (buffIndex) or buffIndex == 0) then return; end
    local buffName, _, count, _, duration, expires, caster, _, _, spellID = UnitBuff(data.unit, buffIndex);

    if ((data.track_all_buffs or data.buffs and data.buffs[spellID]) and caster and (expires > 0)) then
        if (not (data.only_player_buffs and caster ~= "player")) then
            local bar = self:AddBar(buffName, spellID, expires, duration, "BUFF", count);
            local c = data.buff_bar_color;

            bar.slider:SetStatusBarColor(c.r, c.g, c.b, c.a);

            if (data.track_all_buffs) then
                if (tk.type(data.buffs[spellID]) ~= "number") then
                    data.buffs[spellID] = buffName;
                    data.sv.buffs[spellID] = buffName;                    
                end

                local manager = tk.string.format("%s%s", data.name, "BuffsManager");

                if (TimerBars[manager] and TimerBars[manager].list:IsShown()) then
                    TimerBars[manager].list:ScanForItems();
                end

            end

            return;
        end
    end
end

function Field:AddDebuff(data, debuffIndex)
    if (not (debuffIndex) or debuffIndex == 0) then return; end
    --local duration, expires, caster, _, _, spellID = tk.select(5, UnitDebuff(data.unit, debuffIndex));
	local debuffName, _, count, _, duration, expires, caster, _, _, spellID = UnitDebuff(data.unit, debuffIndex);
print("Count:"..count.." DebuffID: ".. spellID.. " duration: "..duration.." expires: "..expires);
    if ((data.track_all_debuffs or data.debuffs and data.debuffs[spellID]) and expires and caster) then
        if (not (data.only_player_debuffs and caster ~= "player")) then
            local bar = self:AddBar(debuffName, spellID, expires, duration, "DEBUFF", count);

            local c = data.debuff_bar_color;
            bar.slider:SetStatusBarColor(c.r, c.g, c.b, c.a);

            if (data.track_all_debuffs) then
                if (tk.type(data.debuffs[spellID]) ~= "number") then
                    data.debuffs[spellID] = debuffName;
                    data.sv.debuffs[spellID] = debuffName;
                end

                local manager = tk.string.format("%s%s", data.name, "DebuffsManager");
                if (TimerBars[manager] and TimerBars[manager].list:IsShown()) then
                    TimerBars[manager].list:ScanForItems();
                end

            end
            return;
        end
    end
end

do
    local function compare(a, b)
        return a.slider:GetValue() > b.slider:GetValue();
    end

    function Field:PositionBars(data)
        if (TimerBars.sv.sort_by_time) then
            tk.table.sort(data.active_bars, compare);
        end
        local direction = data.direction;
        for _, bar in tk.ipairs(data.active_bars) do
            bar:ClearAllPoints(); -- avoid anchoring problems
            bar:SetParent(data.frame);
            bar:Show();
        end
        for id, bar in tk.ipairs(data.active_bars) do
            if (direction == "UP") then
                if (id == 1) then
                    bar:SetPoint("BOTTOMLEFT");
                    bar:SetPoint("BOTTOMRIGHT");
                else
                    local previous = data.active_bars[id - 1];
                    bar:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, data.spacing);
                    bar:SetPoint("BOTTOMRIGHT", previous, "TOPRIGHT", 0, data.spacing);
                end
            elseif (direction == "DOWN") then
                if (id == 1) then
                    bar:SetPoint("TOPLEFT");
                    bar:SetPoint("TOPRIGHT");
                else
                    local previous = data.active_bars[id - 1];
                    bar:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -data.spacing);
                    bar:SetPoint("TOPRIGHT", previous, "BOTTOMRIGHT", 0, -data.spacing);
                end
            end
        end
    end
end

function Field:Scan(data)   

    if (not data.track_all_buffs) then        
        if (data.buffs) then
            for spellID, bar in tk.pairs(data.active_bar_keys) do
                if (bar.type == "BUFF" and not data.buffs[spellID]) then
                    local id = tk:GetIndex(data.active_bars, bar);
                    self:RemoveBar(bar, id);
                end
            end

            for spellID, _ in tk.pairs(data.buffs) do
                local auraIndex = GetBuffIndexBySpellId(spellID, data.unit);
                self:AddBuff(auraIndex);
            end
        end        
    else
        for spellID, bar in tk.pairs(data.active_bar_keys) do
            local auraIndex = GetBuffIndexBySpellId(spellID, data.unit);
            if (bar.type == "BUFF" and not (UnitBuff(data.unit, auraIndex))) then
                local id = tk:GetIndex(data.active_bars, bar);
                self:RemoveBar(bar, id);
            end
        end

        for i = 1, 40 do
            local auraName = UnitBuff(data.unit, i);
            if (not auraName) then break; end       
            self:AddBuff(i);
        end
    end

    if (not data.track_all_debuffs) then
        if (data.debuffs) then

            for spellID, bar in tk.pairs(data.active_bar_keys) do
                if (bar.type == "DEBUFF" and not data.debuffs[spellID]) then
                    local id = tk:GetIndex(data.active_bars, bar);
                    self:RemoveBar(bar, id);
                end
            end

            for spellID, _ in tk.pairs(data.debuffs) do
                local auraIndex = GetDebuffIndexBySpellId(spellID, data.unit);
                self:AddDebuff(auraIndex);
            end
        end
    else
        for spellID, bar in tk.pairs(data.active_bar_keys) do
            local auraIndex = GetDebuffIndexBySpellId(spellID, data.unit);

            if (bar.type == "DEBUFF" and not (tk.select(1, UnitDebuff(data.unit, auraIndex)))) then
                local id = tk:GetIndex(data.active_bars, bar);
                self:RemoveBar(bar, id);
            end
        end

        for i = 1, 40 do
            local auraName = UnitDebuff(data.unit, i);
            if (not auraName) then break; end

            self:AddDebuff(i);
        end
    end
end

function TimerBars:RefreshFields()
    for _, field in tk.ipairs(private.fields) do
        -- update true data:
        local data = Field.Static:GetData(field);
        data.buffs = data.sv.buffs:GetTable();
        data.debuffs = data.sv.debuffs:GetTable();
        data.track_all_buffs = data.sv.track_all_buffs;
        data.track_all_debuffs = data.sv.track_all_debuffs;
        data.only_player_buffs = data.sv.only_player_buffs;
        data.only_player_debuffs = data.sv.only_player_debuffs;
        field:Scan();
    end
end

function Field:OnUpdate(data)
    for _, bar in tk.ipairs(data.active_bars) do
        local duration = bar.expires - GetTime();
        duration = (duration > 0) and duration or 0;
        bar.slider:SetValue(duration);
        if (bar.spark) then
            local _, max = bar.slider:GetMinMaxValues();
            local offset = bar.spark:GetWidth() / 2;
            local bar_width = bar.slider:GetWidth();
            local value = (duration / max) * bar_width - offset;
            if (value > bar_width - offset) then
                value = bar_width - offset;
            end
            bar.spark:SetPoint("LEFT", value, 0);
        end
        duration = tk.string.format("%.1f", duration);
        if (tk.tonumber(duration) > 60) then
            duration = tk.date("%M:%S", duration);
        elseif (duration == "0.0") then
            local id = tk:GetIndex(data.active_bars, bar);
            self:RemoveBar(bar, id);
            return;
        end
        bar.duration:SetText(duration);
    end
end

function Field:OnEvent(data, frame, event)
    if (not data.enabled) then return; end
    if (event == "COMBAT_LOG_EVENT_UNFILTERED") then

        local payload = {CombatLogGetCurrentEventInfo()};
        local _, event, _, srcGUID, srcName, _, _, destGUID, destName = unpack(payload);
		
        if (event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event == "SPELL_CAST_SUCCESS") then
            local spellId, auraName, _, spellType = tk.select(12, unpack(payload));
            
			--local auraIndex = GetAuraIndexByName(auraName, data.unit);
			--[[
			if (srcName == "Gargnash" and data.unit == "Target") then
				print(auraName, spellId, auraIndex);
			end 
			]]

            if (spellType == "BUFF") then
				local buffIndex = GetBuffIndexBySpellId(spellId, data.unit);
                self:AddBuff(buffIndex);
            elseif (spellType == "DEBUFF") then
				local debuffIndex = GetDebuffIndexBySpellId(spellId, data.unit);
                self:AddDebuff(debuffIndex);
            elseif not (spellType) then
				local buffIndex = GetBuffIndexByName(auraName, data.unit);
				local debuffIndex = GetDebuffIndexByName(auraName, data.unit);
				if (buffIndex > 0) then
					self:AddBuff(buffIndex);
				elseif (debuffIndex > 0) then
					self:AddDebuff(debuffIndex);
				end
			end
		elseif (event == "SPELL_AURA_APPLIED_DOSE") then
			-- Like agonie stacks
			local spellId, auraName, _, spellType = tk.select(12, unpack(payload));
			if (spellType == "BUFF") then
				local buffIndex = GetBuffIndexBySpellId(spellId, data.unit);
                self:AddBuff(buffIndex);
            elseif (spellType == "DEBUFF") then
				local debuffIndex = GetDebuffIndexBySpellId(spellId, data.unit);
                self:AddDebuff(debuffIndex);
			end
        elseif (event == "SPELL_AURA_REMOVED") then
            if (not UnitExists(data.unit)) then return; end
            local spellId, auraName, _, spellType = tk.select(12, unpack(payload));
            local bar = data.active_bar_keys[spellId];
			if (spellType == "BUFF") then
				local buffIndex = GetBuffIndexBySpellId(spellId, data.unit);
				local auraInfo = UnitBuff(data.unit, buffIndex);
			elseif (spellType == "DEBUFF") then
				local debuffIndex = GetDebuffIndexBySpellId(spellId, data.unit);
				local auraInfo = UnitDebuff(data.unit, debuffIndex);
			end

            if (bar and not auraInfo) then
                local id = tk:GetIndex(data.active_bars, bar);
                self:RemoveBar(bar, id);
            end
        end
    elseif (event == "PLAYER_ENTERING_WORLD") then
        if (not UnitExists(data.unit)) then
            frame:Hide();
        end
    else
        local scan = private:HandleUnitEvent(event, frame, data.unit);
        if (scan) then
            self:Scan();
        end
    end
end

function Field:AddBar(data, name, spellID, expires, duration, buffType, count)
    -- duration = tk.math.floor(duration + 0.5);
    local bar = data.active_bar_keys[spellID] or TimerBars.bars:Pop(data.sv);
    bar.type = buffType;

    if (not data.active_bar_keys[spellID]) then
        data.active_bar_keys[spellID] = bar;
        data.active_bars[#data.active_bars + 1] = bar;

        if (not data.total_bars[spellID..buffType]) then
            data.total_bars[spellID..buffType] = bar;
        end
    end
	
	if (count and count > 0) then
		bar.name:SetText(count.."x "..name);
	else
		bar.name:SetText(name);
	end
    bar.duration:SetText(duration);
    bar.icon:SetTexture(GetSpellTexture(spellID));
    bar.icon:SetTexCoord(0.1, 0.92, 0.08, 0.92);
    bar.slider:SetMinMaxValues(0, duration);
    bar.slider:SetValue(duration);
    bar.spellID = spellID;
    bar.expires = expires;
	bar.count = count;
    self:PositionBars();

    return bar;
end

function Field:RemoveBar(data, bar, id)
    id = id or tk:GetIndex(data.active_bars, bar); -- ???
    tk.table.remove(data.active_bars, id);
    data.active_bar_keys[bar.spellID] = nil;
    bar:ClearAllPoints();
    bar:Hide();
    TimerBars.bars:Push(bar);
    self:PositionBars();
end

function Field:SetEnabled(data, enabled)
    data.enabled = enabled;
    if (not enabled) then
        data.frame:Hide();
    elseif (UnitExists(data.unit)) then
        data.frame:Show();
        self:Scan();
    end
end

---------------------
-- Module Functions:
---------------------
function TimerBars:init()
    if (not MayronUI:IsInstalled()) then return; end
    self.sv = db.profile.timer_bars;

    db:AppendOnce("profile.timer_bars", {
        field_names = {
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

    if (self.sv.delete_fields) then
        for name, _ in self.sv.delete_fields:Iterate() do
            self.sv[name] = nil;
            self.sv.delete_fields[name] = nil;
        end
    end

    for _, name in self.sv.field_names:Iterate() do
        local field = Field:Create(name);
        local position = self.sv[name].position;

        private.fields[#private.fields + 1] = field;
        
        if (position) then
            field:SetPoint(position.point, tk._G[position.relativeFrame],
                position.relativePoint, position.x, position.y);
        else
            field:SetPoint("CENTER");
        end
    end
end

function TimerBars:OnConfigUpdate(list, value)
    local key = list:PopFront();

    if (key == "profile" and list:PopFront() == "timer_bars") then
        key = list:PopFront();
        local field = tk._G["MUI_TimerBar"..key.."Field"];

        if (field) then
            local name = key;
            local data = Field.Static:GetData(Field[name]);

            key = list:PopFront();
            if (key == "position") then
                key = list:PopFront();
                local point, relativeFrame, relativePoint, x, y = field:GetPoint();
                field:ClearAllPoints();
                if (key == "point") then
                    field:SetPoint(value, relativeFrame, relativePoint, x, y);

                elseif (key == "relativeFrame") then
                    field:SetPoint(point, tk._G[value], relativePoint, x, y);

                elseif (key == "relativePoint") then
                    field:SetPoint(point, relativeFrame, value, x, y);

                elseif (key == "x") then
                    field:SetPoint(point, relativeFrame, relativePoint, value, y);

                elseif (key == "y") then
                    field:SetPoint(point, relativeFrame, relativePoint, x, value);

                end
            elseif (key == "bar_width") then
                field:SetWidth(value);
                for _, bar in tk.pairs(data.total_bars) do
                    bar.name:SetWidth(value - data.sv.bar_height - 50);
                end

            elseif (key == "bar_height") then
                for _, bar in tk.pairs(data.total_bars) do
                    bar:SetHeight(value);
                    bar.icon:SetWidth(value);
                end

            elseif (key == "spacing") then
                data.spacing = value;
                Field[name]:PositionBars();

            elseif (key == "buff_bar_color") then
                data.buff_bar_color = value;

                for _, bar in tk.pairs(data.total_bars) do
                    if (bar.type == "BUFF") then
                        bar.slider:SetStatusBarColor(value.r, value.g, value.b, value.a);
                    end
                end

            elseif (key == "debuff_bar_color") then
                data.debuff_bar_color = value;

                for _, bar in tk.pairs(data.total_bars) do
                    if (bar.type == "DEBUFF") then
                        bar.slider:SetStatusBarColor(value.r, value.g, value.b, value.a);
                    end
                end

            elseif (key == "background_color") then
                for _, bar in tk.pairs(data.total_bars) do
                    bar.slider.bg:SetColorTexture(value.r, value.g, value.b, value.a);
                end

            elseif (key == "show_icons") then
                for _, bar in tk.pairs(data.total_bars) do
                    bar.icon:SetShown(value);

                    if (not value) then
                        bar.slider:SetPoint("TOPLEFT");
                        bar.slider:SetPoint("BOTTOMLEFT");

                    else
                        bar.slider:SetPoint("TOPLEFT", bar.icon, "TOPRIGHT");
                        bar.slider:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMRIGHT");
                    end
                end

            elseif (key == "spark") then
                for _, bar in tk.pairs(data.total_bars) do
                    if (bar.spark) then
                        bar.spark:SetShown(value);

                    elseif (value) then
                        bar.spark = bar.slider:CreateTexture(nil, "OVERLAY");
                        bar.spark:SetWidth(28);
                        bar.spark:SetPoint("TOP", 0, 12);
                        bar.spark:SetPoint("BOTTOM", 0, -12);
                        bar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark");
                        bar.spark:SetVertexColor(1, 1, 1);
                        bar.spark:SetBlendMode("ADD");

                    end
                end

            elseif (key == "direction") then
                data.direction = value;
                Field[name]:PositionBars();

            elseif (key == "time") then
                key = list:PopFront();
                if (key == "show") then
                    for _, bar in tk.pairs(data.total_bars) do
                        bar.duration:SetShown(value);
                    end

                elseif (key == "font_size") then
                    local font = tk.Constants.LSM:Fetch("font", data.sv.time.font);
                    for _, bar in tk.pairs(data.total_bars) do
                        bar.duration:SetFont(font, value);
                    end

                elseif (key == "font") then
                    local font = tk.Constants.LSM:Fetch("font", value);
                    for _, bar in tk.pairs(data.total_bars) do
                        bar.duration:SetFont(font, data.sv.time.font_size);
                    end

                end
            elseif (key == "spell_name") then
                key = list:PopFront();
                if (key == "show") then
                    for _, bar in tk.pairs(data.total_bars) do
                        bar.name:SetShown(value);
                    end

                elseif (key == "font_size") then
                    local font = tk.Constants.LSM:Fetch("font", data.sv.spell_name.font);
                    for _, bar in tk.pairs(data.total_bars) do
                        bar.name:SetFont(font, value);
                    end

                elseif (key == "font") then
                    local font = tk.Constants.LSM:Fetch("font", value);
                    for _, bar in tk.pairs(data.total_bars) do
                        bar.name:SetFont(font, data.sv.spell_name.font_size);
                    end

                end
            elseif (key == "unit") then
                data.unit = value;
                if (value ~= "Player") then
                    if (value == "Target") then
                        Field[name]:RegisterEvent("PLAYER_TARGET_CHANGED");

                    elseif (value == "TargetTarget") then
                        Field[name]:RegisterEvent("UNIT_TARGET");

                    elseif (value == "Focus") then
                        Field[name]:RegisterEvent("PLAYER_FOCUS_CHANGED");

                    elseif (value == "FocusTarget") then
                        Field[name]:RegisterEvent("UNIT_TARGET");

                    end
                end

            elseif (key == "enabled") then
                Field[name]:SetEnabled(value);
            end

        elseif (key == "status_bar_texture") then
            value = tk.Constants.LSM:Fetch("statusbar", value);
            for _, field in tk.ipairs(private.fields) do
                local data = Field.Static:GetData(field);
                for _, bar in tk.pairs(data.total_bars) do
                    bar.slider:SetStatusBarTexture(value);
                end
            end

        elseif (key == "sort_by_time") then
            for _, field in tk.ipairs(private.fields) do
                field:PositionBars();
            end

        elseif (key == "show_tooltips") then
            for _, field in tk.ipairs(private.fields) do
                local data = Field.Static:GetData(field);

                for _, bar in tk.pairs(data.total_bars) do
                    if (value) then
                        bar:SetScript("OnEnter", bar_OnEnter);
                        bar:SetScript("OnLeave", bar_OnLeave);
                    else
                        bar:SetScript("OnEnter", tk.Constants.DUMMY_FUNC);
                        bar:SetScript("OnLeave", tk.Constants.DUMMY_FUNC);
                    end
                end
            end

        end
    end
end