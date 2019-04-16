-- luacheck: ignore self 143
local _, namespace = ...;

local _G, MayronUI = _G, _G.MayronUI;
local tk, db, _, _, obj = MayronUI:GetCoreComponents();

local GetSpellInfo, IsAddOnLoaded, UnitName = _G.GetSpellInfo, _G.IsAddOnLoaded, _G.UnitName;
local UnitChannelInfo, UnitCastingInfo, CreateFrame = _G.UnitChannelInfo, _G.UnitCastingInfo, _G.CreateFrame;
local UIFrameFadeIn, UIFrameFadeOut, select, date, math, tonumber, string, table, ipairs =
    _G.UIFrameFadeIn, _G.UIFrameFadeOut, _G.select, _G.date, _G.math, _G.tonumber, _G.string, _G.table, _G.ipairs;
local GetNetStats = _G.GetNetStats;

namespace.castBarData = obj:PopTable();

-- Objects -----------------------------

---@type Engine
local Engine = obj:Import("MayronUI.Engine");

---@class CastBarsModule : BaseModule
local C_CastBarsModule = MayronUI:RegisterModule("CastBarsModule", "Cast Bars");
namespace.C_CastBarsModule = C_CastBarsModule;

---@class CastBar : Object
local C_CastBar = Engine:CreateClass("CastBar", "Framework.System.FrameWrapper");
C_CastBar.Static:AddFriendClass("CastBarsModule");

namespace.bars = obj:PopTable();


-- Load Database Defaults --------------

db:AddToDefaults("profile.castBars", {
    __templateCastBar = {
        enabled       = true;
        width         = 250;
        height        = 27;
        showIcon      = false;
        unlocked      = false;
        frameStrata   = "MEDIUM";
        frameLevel    = 20;
        position = {"CENTER", "UIParent", "CENTER", 0,  0};
    };
    appearance = {
        texture       = "MUI_StatusBar";
        border        = "Skinner";
        borderSize    = 1;
        inset         = 1;
        colors = {
            finished    = {r = 0.8, g = 0.8, b = 0.8, a = 0.7};
            interrupted = {r = 1, g = 0, b = 0, a = 0.7};
            border      = {r = 0, g = 0, b = 0, a = 1};
            background  = {r = 0, g = 0, b = 0, a = 0.6};
            latency     = {r = 1, g = 1, b = 1, a = 0.6};
        };
    };
    Player = {
        anchorToSUF   = true;
        showLatency   = true;
    },
    Target = {
        anchorToSUF = true;
    },
    Focus = {};
    Mirror = {
        position = {"TOP", "UIParent", "TOP", 0,  -200};
    };
});

-------------------
-- Channel Ticks
-------------------
local Ticks = obj:PopTable();

function Ticks:Create(data)
    local tick = data.frame.statusbar:CreateTexture(nil, "OVERLAY");
    tick:SetSize(26, data.frame.statusbar:GetHeight() + 20);
    data.ticks = data.ticks or {};
    table.insert(data.ticks, tick);
    tick:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark");
    tick:SetVertexColor(1, 1, 1);
    tick:SetBlendMode("ADD");
    return tick;
end

local dummyTick = "_";

Ticks.data = {
    -- DRUID
    [(GetSpellInfo(740)) or dummyTick]    = 4;  -- Tranquility

    -- MAGE
    [(GetSpellInfo(5143)) or dummyTick]   = 5;  -- Arcane Missiles
    [(GetSpellInfo(12051)) or dummyTick]  = 3;  -- Evocation
    [(GetSpellInfo(205021)) or dummyTick] = 10; -- Ray of Frost

    -- MONK
    [(GetSpellInfo(117952)) or dummyTick] = 4;  -- Crackling Jade Lightning
    [(GetSpellInfo(191837)) or dummyTick] = 3;  -- Essence Font

    -- PRIEST
    [(GetSpellInfo(64843)) or dummyTick]  = 4;  -- Divine Hymn
    [(GetSpellInfo(15407)) or dummyTick]  = 4;  -- Mind Flay
    [(GetSpellInfo(47540)) or dummyTick]  = 2;  -- Penance
    [(GetSpellInfo(205065)) or dummyTick] = 4;  -- Void Torrent

    -- WARLOCK
    [(GetSpellInfo(193440)) or dummyTick] = 3;  -- Demonwrath
    [(GetSpellInfo(198590)) or dummyTick] = 6;  -- Drain Soul
	[(GetSpellInfo(234153)) or dummyTick] = 4;  -- Health Funnel
};

-- Events ---------------------
local Events = obj:PopTable();

---@param castBarData table
---@param pauseDuration number
function Events:MIRROR_TIMER_PAUSE(_, castBarData, pauseDuration)
    castBarData.paused = pauseDuration > 0;

    if (pauseDuration > 0) then
        castBarData.pauseDuration = pauseDuration;
    end
end

---@param castBarData table
function Events:MIRROR_TIMER_START(_, castBarData, ...)
    local _, value, maxValue, _, pause, label = ...;

    castBarData.frame.statusbar:SetMinMaxValues(0, (maxValue / 1000));
    castBarData.frame.statusbar:SetValue((value / 1000));
    castBarData.paused = pause;
    castBarData.startTime = _G.GetTime();
    castBarData.frame.name:SetText(label);

    local c = castBarData.appearance.colors.normal;
    castBarData.frame.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);
    UIFrameFadeIn(castBarData.frame, 0.1, castBarData.frame:GetAlpha(), 1);
end

---@param castBarData table
function Events:MIRROR_TIMER_STOP(_, castBarData)
    castBarData.paused = 0;
    castBarData.pauseDuration = nil;
    castBarData.fadingOut = true;
    castBarData.startTime = nil;

    UIFrameFadeOut(castBarData.frame, 1, castBarData.frame:GetAlpha(), 0);
end

---@param castBar CastBar
---@param castBarData table
function Events:UNIT_SPELLCAST_INTERRUPTED(castBar, castBarData)
    castBarData.frame.statusbar:SetValue(select(2, castBarData.frame.statusbar:GetMinMaxValues()))
    castBar:StopCasting();

	local c = castBarData.appearance.colors.interrupted;
    castBarData.frame.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);
end

---@param castBarData table
function Events:UNIT_SPELLCAST_INTERRUPTIBLE(_, castBarData)
	local c = castBarData.appearance.colors.normal;
    castBarData.frame.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);
end

---@param castBarData table
function Events:UNIT_SPELLCAST_NOT_INTERRUPTIBLE(_, castBarData)
	local c = castBarData.appearance.colors.interrupted;
    castBarData.frame.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);
end

---If player changes target, the target cast bar should be updated.
---@param castBar CastBar
---@param castBarData table
function Events:PLAYER_TARGET_CHANGED(castBar, castBarData)
	if (_G.UnitExists(castBarData.unitID) and select(1, _G.UnitCastingInfo(castBarData.unitID))) then
        if (_G.UnitName(castBarData.unitID) == castBarData.unitName) then return end

		castBar:StopCasting();
        castBar:StartCasting(false); -- for casting only (not channelling)

	elseif (castBarData.frame:GetAlpha() > 0) then
		castBar:StopCasting();
        castBarData.frame:SetAlpha(0);
        castBarData.frame:Hide();
	end
end

---@param castBar CastBar
---@param castBarData table
function Events:UNIT_SPELLCAST_DELAYED(castBar, castBarData)
    local endTime = select(5, _G.UnitCastingInfo(castBarData.unitID));

	if (not endTime or not castBarData.startTime) then
		self:UNIT_SPELLCAST_INTERRUPTED(castBar, castBarData);
		return;
    end

	endTime = endTime / 1000;
    castBarData.frame.statusbar:SetMinMaxValues(0, endTime - castBarData.startTime);
end

---@param castBar CastBar
---@param castBarData table
---@param unitID string
function Events:UNIT_SPELLCAST_START(castBar, castBarData, unitID)
	if (unitID ~= castBarData.unitID) then return end
	castBar:StartCasting(false);
end

---@param castBar CastBar
---@param castBarData table
---@param unitID string
function Events:UNIT_SPELLCAST_CHANNEL_START(castBar, castBarData, unitID)
    if (unitID ~= castBarData.unitID) then return end
    castBar:StartCasting(true);
end

---@param castBar CastBar
---@param castBarData table
function Events:UNIT_SPELLCAST_CHANNEL_STOP(castBar, castBarData)
    castBarData.frame.statusbar:SetValue(select(2, castBarData.frame.statusbar:GetMinMaxValues()));

    if (castBarData.frame.statusbar:GetValue() > 0.1) then
        self:UNIT_SPELLCAST_CHANNEL_UPDATE(castBar, castBarData);
    else
        castBar:StopCasting();
    end
end

---@param castBar CastBar
---@param castBarData table
function Events:UNIT_SPELLCAST_CHANNEL_UPDATE(castBar, castBarData)
    local endTime = select(5, _G.UnitChannelInfo(castBarData.unitID));

    if (not endTime or not castBarData.startTime) then
        castBar:StopCasting();

        local c = castBarData.appearance.colors.interrupted;
        castBarData.frame.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);

        return;
    end

    endTime = endTime / 1000;
    castBarData.frame.statusbar:SetMinMaxValues(0, endTime - castBarData.startTime);
end

-- C_CastBar ----------------------

Engine:DefineParams("table", "table", "string");
function C_CastBar:__Construct(data, settings, appearance, unitID)
    data.settings = settings;
    data.globalName = string.format("MUI_%sCastBar", unitID);
    data.unitID = unitID:lower();
    data.appearance = appearance;
    data.backdrop = obj:PopTable();

    -- Needed for event functions
    namespace.castBarData[data.unitID] = data;
end

local function CastBarFrame_OnUpdate(self, elapsed)
    if (self:GetAlpha() > 0) then
        self.totalElapsed = self.totalElapsed + elapsed;

        if (self.enabled and self.totalElapsed > 0.01) then
            self.castBar:Update(elapsed);
            self.totalElapsed = 0;
        end
    end
end

local function CastBarFrame_OnEvent(self, eventName, ...)
    if (eventName == "PLAYER_FOCUS_CHANGED") then
        eventName = "PLAYER_TARGET_CHANGED";
    end

    Events[eventName](Events, self.castBar, namespace.castBarData[self.unitID] , ...);
end

do
    local function CreateBarFrame(unitID, settings, globalName)
        local bar = _G.CreateFrame("Frame", globalName, _G.UIParent);
        bar:SetAlpha(0);

        bar.statusbar = _G.CreateFrame("StatusBar", nil, bar);
        bar.statusbar:SetValue(0);

        if (unitID == "player" and settings.showLatency) then
            bar.latencyBar = bar.statusbar:CreateTexture(nil, "ARTWORK");
            bar.latencyBar:SetPoint("TOPRIGHT");
            bar.latencyBar:SetPoint("BOTTOMRIGHT");
        end

        if (unitID == "mirror") then
            _G.MirrorTimer1:SetAlpha(0);
            _G.MirrorTimer1.SetAlpha = tk.Constants.DUMMY_FUNC;
        elseif (unitID == "player") then
            _G.CastingBarFrame:UnregisterAllEvents();
            _G.CastingBarFrame:Hide();
        end

        bar.name = bar.statusbar:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        bar.name:SetPoint("LEFT", 4, 0);
        bar.name:SetWidth(150);
        bar.name:SetWordWrap(false);
        bar.name:SetJustifyH("LEFT");

        bar.duration = bar.statusbar:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        bar.duration:SetPoint("RIGHT", -4, 0);
        bar.duration:SetJustifyH("RIGHT");

        bar.bg = _G.CreateFrame("Frame", nil, bar);
        bar.bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -1, 1);
        bar.bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1);
        bar.bg:SetFrameLevel(5);

        return bar;
    end

    Engine:DefineParams("boolean")
    function C_CastBar:SetEnabled(data, enabled)
        local bar = data.frame;

        if (not bar and not enabled) then
            return;
        end

        if (enabled) then
            if (not bar) then
                bar = CreateBarFrame(data.unitID, data.settings, data.globalName);
                data.frame = bar;
            end

            self:PositionCastBar();

            if (data.unitID == "mirror") then
                bar:RegisterEvent("MIRROR_TIMER_PAUSE");
                bar:RegisterEvent("MIRROR_TIMER_START");
                bar:RegisterEvent("MIRROR_TIMER_STOP");
            else
                bar:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", data.unitID);
                bar:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", data.unitID);
                bar:RegisterUnitEvent("UNIT_SPELLCAST_START", data.unitID);
                bar:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE", data.unitID);
                bar:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", data.unitID);
                bar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", data.unitID);
                bar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", data.unitID);
                bar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", data.unitID);

                if (data.unitID == "target") then
                    bar:RegisterEvent("PLAYER_TARGET_CHANGED");
                elseif (data.unitID == "focus") then
                    bar:RegisterEvent("PLAYER_FOCUS_CHANGED");
                end
            end

            bar.totalElapsed = 0;
            bar.castBar = self;
            bar.unitID = data.unitID;
            bar:SetScript("OnUpdate", CastBarFrame_OnUpdate);
            bar:SetScript("OnEvent", CastBarFrame_OnEvent);
        else
            bar:UnregisterAllEvents();
            bar:SetParent(tk.Constants.DUMMY_FRAME);
            bar:SetAllPoints(tk.Constants.DUMMY_FRAME);
            bar:SetScript("OnUpdate", nil);
            bar:SetScript("OnEvent", nil);
        end

        bar:SetShown(enabled);
        bar.enabled = enabled;
    end
end

function C_CastBar:Update(data)
    if (not data.startTime) then
        if (data.frame:GetAlpha() == 0) then
            data.fadingOut = nil;
        end
        return;
    end

    if (data.unitID == "mirror") then
        if (not data.paused or data.paused == 0) then
            for i = 1, _G.MIRRORTIMER_NUMTIMERS do
                local _, _, _, _, _, label = _G.GetMirrorTimerInfo(i);

                if (label == data.frame.name:GetText()) then
                    local value = _G.MirrorTimer1StatusBar:GetValue();
                    local duration = string.format("%.1f", value);

                    if (tonumber(duration) > 60) then
                        duration = date("%M:%S", duration);
                    end

                    data.frame.duration:SetText(duration);
                    data.frame.statusbar:SetValue(value);
                    return;
                end
            end
        end
    else
        if (data.startTime and not self:IsFinished()) then
            local difference = _G.GetTime() - data.startTime;

            if (data.channelling or data.unitID == "mirror") then
                data.frame.statusbar:SetValue(data.totalTime - difference);
            else
                data.frame.statusbar:SetValue(difference);
            end

            local duration = data.totalTime - difference;

            if (duration < 0) then
                duration = 0;
            end

            duration = string.format("%.1f", duration);

            if (tonumber(duration) > 60) then
                duration = date("%M:%S", duration);
            end

            data.frame.duration:SetText(duration);
        else
            self:StopCasting();
        end
    end
end

Engine:DefineParams("number");
---@param numTicks number @The number of channelling ticks (when damage is applied)
function C_CastBar:SetTicks(data, numTicks)
    if (data.ticks) then
        for _, tick in ipairs(data.ticks) do
            tick:Hide();
        end
    end

    if (numTicks == 0) then
        return;
    end

    local width = data.frame.statusbar:GetWidth();

    for i = 1, numTicks do
        if (i < numTicks) then
            local tick = (data.ticks and data.ticks[i]) or Ticks:Create(data);
            tick:ClearAllPoints();
            tick:SetPoint("CENTER", data.frame.statusbar, "LEFT", width * (i / numTicks), 0);
            tick:Show();
        end
    end
end

Engine:DefineReturns("boolean");
---@return boolean @Returns true if the cast bar has finished channeling or casting.
function C_CastBar:IsFinished(data)
    local value = data.frame.statusbar:GetValue();
    local maxValue = select(2, data.frame.statusbar:GetMinMaxValues());

    if (data.channelling) then
        return value <= 0; -- max value for channelling is reversed
    end

	return value >= maxValue;
end

Engine:DefineParams("boolean");
function C_CastBar:SetIconEnabled(data, enabled)
    if (not enabled and not data.square) then
        return; -- nothing to do
    end

    if (not data.square) then
        data.square = CreateFrame("Frame", nil, data.frame);
        data.square:SetPoint("TOPRIGHT", data.frame, "TOPLEFT", -2, 0);
        data.square:SetPoint("BOTTOMRIGHT", data.frame, "BOTTOMLEFT", -2, 0);

        data.icon = data.square:CreateTexture(nil, "ARTWORK");
        data.icon:SetPoint("TOPLEFT", data.square, "TOPLEFT", 1, -1);
        data.icon:SetPoint("BOTTOMRIGHT", data.square, "BOTTOMRIGHT", -1, 1);
    end

    data.square:SetShown(enabled);
end

---Stop casting or channelling a spell/ability.
function C_CastBar:StopCasting(data)
	if (not data.fadingOut) then
		data.startTime = nil;
        data.unitName = nil;

        local c = data.appearance.colors.finished;

		data.frame.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);
        data.fadingOut = true;

        if (not data.settings.unlocked) then
            UIFrameFadeOut(data.frame, 1, 1, 0);
        else
            data.frame.statusbar:SetValue(0);
            data.frame.name:SetText("");
            data.frame.duration:SetText("");
        end
	end
end

Engine:DefineParams("boolean");
---Start casting or channelling a spell/ability.
---@param channelling boolean @If true, the casting type is set to "channelling" to reverse the bar direction.
function C_CastBar:StartCasting(data, channelling)
    local func = channelling and UnitChannelInfo or UnitCastingInfo;
    local name, _, texture, startTime, endTime, _, _, notInterruptible = func(data.unitID);

	if (not startTime) then
		if (data.frame:GetAlpha() > 0 and not data.fadingOut) then
			self:StopCasting();
		end
		return;
    end

	startTime = startTime / 1000; -- To make the same as GetTime() format
	endTime = endTime / 1000; -- To make the same as GetTime() format

	data.frame.statusbar:SetMinMaxValues(0, endTime - startTime); -- 0 to n seconds
	data.frame.name:SetText(name);

	if (data.icon) then
		data.icon:SetTexture(texture);
		data.icon:SetTexCoord(0.13, 0.87, 0.13, 0.87);
	end

	if (notInterruptible) then
		local c = data.appearance.colors.interrupted;
		data.frame.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);
	else
		local c = data.appearance.colors.normal;
		data.frame.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);
    end

    if (data.frame.latencyBar) then
        if (data.settings.showLatency) then
            local width = math.floor(data.frame.statusbar:GetWidth() + 0.5);
            local percent = (select(4, GetNetStats()) / 1000);
            local latencyWidth = (width * percent);

            if (latencyWidth >= width or latencyWidth == 0) then
                data.frame.latencyBar:Hide();
            else
                data.frame.latencyBar:Show();
            end

            data.frame.latencyBar:SetWidth(latencyWidth);
        else
            data.frame.latencyBar:Hide();
        end
    end

    -- ticks:
    if (channelling) then
        self:SetTicks(Ticks.data[name] or 0);
        data.frame.statusbar:SetValue(endTime - startTime);
    else
        self:SetTicks(0);
        data.frame.statusbar:SetValue(0);
    end

    UIFrameFadeIn(data.frame, 0.1, 0, 1);

	data.fadingOut = nil;
    data.channelling = channelling;
	data.unitName = UnitName(data.unitID);
	data.startTime = startTime; -- makes OnUpdate start casting the bar
	data.totalTime = endTime - startTime;
end

function C_CastBar:PositionCastBar(data)
    data.frame:ClearAllPoints();

    local anchorToSUF = IsAddOnLoaded("ShadowedUnitFrames") and data.settings.anchorToSUF;
    local unitframe = _G[ string.format("SUFUnit%s", data.unitID:lower()) ];
    local sufAnchor = unitframe and unitframe.portrait;

    if (not (anchorToSUF and sufAnchor)) then
        -- manual position...

        local point = data.settings.position[1];
        local relativeFrame = data.settings.position[2];
        local relativePoint = data.settings.position[3];
        local x, y = data.settings.position[4], data.settings.position[5];

        if (point and relativeFrame and relativePoint and x and y) then
            data.frame:SetPoint(point, _G[relativeFrame], relativePoint, x, y);
        else
            data.frame:SetPoint("CENTER");
        end

        if (data.sqaure) then
            data.square:SetWidth(data.settings.height);
        end
    elseif (sufAnchor) then
        -- anchor to ShadowedUnitFrames
        data.frame:SetPoint("TOPLEFT", sufAnchor, "TOPLEFT", -1, 1);
        data.frame:SetPoint("BOTTOMRIGHT", sufAnchor, "BOTTOMRIGHT", 1, -1);
        data.frame:SetParent(_G.UIParent);

        if (data.square) then
            data.square:SetWidth(sufAnchor:GetHeight() + 2);
        end
    end
end

-- C_CastBarsModule -----------------------

function C_CastBarsModule:OnInitialize(data)
    data.bars = obj:PopTable();
    local r, g, b = tk:GetThemeColor();

    db:AddToDefaults("profile.castBars.appearance.colors.normal", {
        r = r, g = g, b = b, a = 0.7
    });

    for _, barName in obj:IterateArgs("Player", "Target", "Focus", "Mirror") do
        local sv = db.profile.castBars[barName]; ---@type Observer
        sv:SetParent(db.profile.castBars.__templateCastBar);
    end

    local options = {
        onExecuteAll = {
            first = {
                "Player.enabled";
                "Target.enabled";
                "Focus.enabled";
                "Mirror.enabled";
            };
            dependencies = {
                ["colors.border"] = "appearance.border";
            };
        };
        groups = {
            {
                patterns = { "(position|anchorToSUF)%[?%d?%]?$" };
                value = function(_, keysList)
                    local barName = keysList:PopFront();

                    if (data.bars[barName]) then
                        data.bars[barName]:PositionCastBar();
                    end
                end;
            };
            {
                patterns = { "(width|height|frameStrata|frameLevel|showIcon)" };
                value = function(value, keysList)
                    local barName = keysList:PopFront();
                    local attribute = keysList:PopFront();
                    local castBar = data.bars[barName]; ---@type CastBar

                    if (not castBar) then
                        return;
                    end

                    if (attribute == "width") then
                        castBar:SetWidth(value);

                    elseif (attribute == "height") then
                        castBar:SetHeight(value);

                    elseif (attribute == "frameStrata") then
                        castBar:SetFrameStrata(value);

                    elseif (attribute == "frameLevel") then
                        castBar:SetFrameLevel(value);

                    elseif (attribute == "showIcon") then
                        castBar:SetIconEnabled(value);
                    end
                end;
            };
            {
                patterns = { "^%a+%.enabled$" };
                value = function(value, keysList)
                    local barName = keysList:PopFront();
                    local castBar = data.bars[barName];

                    if (value and not castBar) then
                        castBar = C_CastBar(data.settings[barName], data.settings.appearance, barName);
                        data.bars[barName] = castBar;
                    end

                    if (castBar) then
                        castBar:SetEnabled(value);
                    end
                end;
            };
        };
    };

    self:RegisterUpdateFunctions(db.profile.castBars, {
        appearance = {
            texture = function(value)
                local castBarData;

                for _, castBar in _G.pairs(data.bars) do
                    castBarData = data:GetFriendData(castBar);
                    castBarData.frame.statusbar:SetStatusBarTexture(tk.Constants.LSM:Fetch("statusbar", value));
                end
            end;

            border = function(value)
                local castBarData;
                local color = data.settings.appearance.colors.border;

                for _, castBar in _G.pairs(data.bars) do
                    castBarData = data:GetFriendData(castBar);
                    castBarData.backdrop.edgeFile = tk.Constants.LSM:Fetch("border", value);
                    castBarData.frame:SetBackdrop(castBarData.backdrop);
                    castBarData.frame:SetBackdropBorderColor(color.r, color.g, color.b, color.a);
                end
            end;

            borderSize = function(value)
                local castBarData;
                local color = data.settings.appearance.colors.border;

                for _, castBar in _G.pairs(data.bars) do
                    castBarData = data:GetFriendData(castBar);
                    castBarData.backdrop.edgeSize = value;
                    castBarData.frame:SetBackdrop(castBarData.backdrop);
                    castBarData.frame:SetBackdropBorderColor(color.r, color.g, color.b, color.a);
                end
            end;

            inset = function(value)
                local castBarData;

                for _, castBar in _G.pairs(data.bars) do
                    castBarData = data:GetFriendData(castBar);
                    castBarData.frame.statusbar:ClearAllPoints();
                    castBarData.frame.statusbar:SetPoint("TOPLEFT", value, -value);
                    castBarData.frame.statusbar:SetPoint("BOTTOMRIGHT", -value, value);
                end
            end;

            colors = {
                background = function(value)
                    local castBarData;

                    for _, castBar in _G.pairs(data.bars) do
                        castBarData = data:GetFriendData(castBar);

                        if (not castBarData.background) then
                            castBarData.background = tk:SetBackground(
                                castBarData.frame.statusbar, value.r, value.g, value.b, value.a);
                        else
                            castBarData.background:SetColorTexture(value.r, value.g, value.b, value.a);
                        end
                    end
                end;

                border = function(value)
                    local castBarData;

                    for _, castBar in _G.pairs(data.bars) do
                        castBarData = data:GetFriendData(castBar);
                        castBarData.frame:SetBackdropBorderColor(value.r, value.g, value.b, value.a);

                        if (castBarData.settings.showIcon) then
                            castBarData.square:SetBackdropBorderColor(value.r, value.g, value.b, value.a);
                        end
                    end
                end;

                normal = function(value)
                    local castBarData;

                    for _, castBar in _G.pairs(data.bars) do
                        castBarData = data:GetFriendData(castBar);
                        castBarData.frame.statusbar:SetStatusBarColor(value.r, value.g, value.b, value.a);
                    end
                end;

                latency = function(value)
                    local castBar = data.bars.Player;

                    if (castBar and data.settings.Player.showLatency) then
                        local castBarData = data:GetFriendData(castBar);
                        castBarData.frame.latencyBar:SetColorTexture(value.r, value.g, value.b, value.a);
                    end
                end;
            };
        };
    }, options);

    self:SetEnabled(true);
end