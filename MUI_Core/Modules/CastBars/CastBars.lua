-- luacheck: ignore self 143
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();

local GetSpellInfo, IsAddOnLoaded, UnitName = _G.GetSpellInfo, _G.IsAddOnLoaded, _G.UnitName;
local UnitChannelInfo, UnitCastingInfo = _G.UnitChannelInfo, _G.UnitCastingInfo;
local UIFrameFadeIn, UIFrameFadeOut, select, date, math, tonumber, string, table, ipairs =
    _G.UIFrameFadeIn, _G.UIFrameFadeOut, _G.select, _G.date, _G.math, _G.tonumber, _G.string, _G.table, _G.ipairs;
local GetNetStats = _G.GetNetStats;
local UnitExists = _G.UnitExists;

local GetMirrorTimerInfo, GetTime, pairs = _G.GetMirrorTimerInfo, _G.GetTime, _G.pairs;
local CastingInfo, ChannelInfo = _G.CastingInfo, _G.ChannelInfo;
local CastingBarFrame = _G.CastingBarFrame or _G.PlayerCastingBarFrame;

local allCastBarData = obj:PopTable();
local LibCC;

if (tk:IsClassic()) then
  LibCC = _G.LibStub("LibClassicCasterino");

  UnitCastingInfo = function(unit)
    if (unit == "player") then
      return CastingInfo();
    else
      return LibCC:UnitCastingInfo(unit)
    end
  end

  UnitChannelInfo = function(unit)
    if (unit == "player") then
      return ChannelInfo();
    else
      return LibCC:UnitChannelInfo(unit);
    end
  end
end

-- Objects -----------------------------
---@class CastBarsModule : BaseModule
local C_CastBarsModule = MayronUI:RegisterModule("CastBarsModule", L["Cast Bars"]);

---@class CastBar : Object
local C_CastBar = obj:CreateClass("CastBar");
C_CastBar.Static:AddFriendClass("CastBarsModule");

-- Load Database Defaults --------------

db:AddToDefaults("global.castBars", {
  showFoodDrink = true;
});

db:AddToDefaults("profile.castBars", {
  enabled = true;
  __templateCastBar = {
    enabled       = true;
    width         = 250;
    height        = 27;
    showIcon      = false;
    leftToRight   = true;
    unlocked      = false;
    frameStrata   = "MEDIUM";
    frameLevel    = 20;
    position = {"CENTER", "UIParent", "CENTER", 0,  0};
  };
  appearance = {
    texture       = "MUI_StatusBar";
    border        = "Skinner";
    blendMode     = "ADD";
    borderSize    = 1;
    inset         = 1;
    fontSize         = 12;
    colors = {
      finished    = {r = 0.8, g = 0.8, b = 0.8, a = 0.7};
      interrupted = {r = 1, g = 0, b = 0, a = 0.7};
      notInterruptible = {r = 0.93, g = 0.4, b = 0, a = 0.7};
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
  Pet = {
    position = {"BOTTOM", "UIParent", "BOTTOM", 0,  400};
  };
  Mirror = {
    position = {"TOP", "UIParent", "TOP", 0,  -200};
  };
  Power = {
    position = {"TOP", "UIParent", "TOP", 0,  -300};
  }
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

if (tk:IsRetail()) then
  -- CLASSIC OR BC-CLASSIC
  Ticks.data = {
    -- PRIEST
    [(GetSpellInfo(15407)) or dummyTick]  = 6;  -- Mind Flay
    [(GetSpellInfo(205065)) or dummyTick] = 4;  -- Void Torrent

    -- WARLOCK
    [(GetSpellInfo(234153)) or dummyTick] = 5;  -- Drain Life
    [(GetSpellInfo(198590)) or dummyTick] = 5;  -- Drain Soul

    -- MAGE
    [(GetSpellInfo(205021)) or dummyTick] = 10; -- Ray of Frost

    -- MONK
    [(GetSpellInfo(117952)) or dummyTick] = 4;  -- Crackling Jade Lightning
    [(GetSpellInfo(191837)) or dummyTick] = 3;  -- Essence Font
    [(GetSpellInfo(113656)) or dummyTick] = 20;  -- fists of fury, first tick instant, aoe
    [(GetSpellInfo(115175)) or dummyTick] = 8;  -- soothing mist
  };
else
  -- CLASSIC OR BC-CLASSIC
  Ticks.data = {
    -- PRIEST
    [(GetSpellInfo(15407)) or dummyTick]  = 3;  -- Mind Flay

    -- WARLOCK
    [(GetSpellInfo(689)) or dummyTick] = 5;  -- Drain Life
    [(GetSpellInfo(30908)) or dummyTick] = 5;  -- Drain Mana
    [(GetSpellInfo(1120)) or dummyTick] = 4;  -- Drain Soul
    [(GetSpellInfo(4629)) or dummyTick] = 6;  -- Rain of Fire

    -- MAGE
    [(GetSpellInfo(10)) or dummyTick] = 8;  -- Blizzard

    -- DRUID
    [(GetSpellInfo(16914)) or dummyTick] = 10;  -- Hurricane
  };
end

-- SHARED TICKS
------------------------------
-- PRIEST
Ticks.data[(GetSpellInfo(64843)) or dummyTick]  = 4;  -- Divine Hymn
Ticks.data[(GetSpellInfo(47540)) or dummyTick]  = 2;  -- Penance
Ticks.data[(GetSpellInfo(48045)) or dummyTick] = 6;  -- Mind Sear

-- WARLOCK
Ticks.data[(GetSpellInfo(755)) or dummyTick] = 6;  -- Health Funnel

-- MAGE
Ticks.data[(GetSpellInfo(5143)) or dummyTick] = 5;  -- Arcane Missiles
Ticks.data[(GetSpellInfo(12051)) or dummyTick] = 6;  -- Evocation

-- DRUID
Ticks.data[(GetSpellInfo(740)) or dummyTick] = 4;  -- Tranquility

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
function Events:UNIT_SPELLCAST_INTERRUPTED(_, castBarData)
  if (not castBarData.interrupted) then
    castBarData.frame.statusbar:SetValue(select(2, castBarData.frame.statusbar:GetMinMaxValues()));
    castBarData.interrupted = true;
    local c = castBarData.appearance.colors.interrupted;
    castBarData.frame.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);
  end
end

---@param castBar CastBar
---@param castBarData table
function Events:UNIT_SPELLCAST_STOP(castBar, castBarData, unitID)
  if (UnitCastingInfo(castBarData.unitID)) then
    self:UNIT_SPELLCAST_START(castBar, castBarData, unitID);
    return
  end

  if (UnitChannelInfo(castBarData.unitID)) then
    self:UNIT_SPELLCAST_CHANNEL_START(castBar, castBarData, unitID);
    return
  end

  castBar:StopCasting();
end

---@param castBar CastBar
---@param castBarData table
function Events:UNIT_SPELLCAST_SUCCEEDED(_, castBarData)
  castBarData.frame.statusbar:SetValue(select(2, castBarData.frame.statusbar:GetMinMaxValues()));
  local c = castBarData.appearance.colors.finished;
  castBarData.frame.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);
end

---@param castBarData table
function Events:UNIT_SPELLCAST_INTERRUPTIBLE(_, castBarData)
  local c = castBarData.appearance.colors.normal;
  castBarData.frame.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);
end

---@param castBarData table
function Events:UNIT_SPELLCAST_NOT_INTERRUPTIBLE(_, castBarData)
  local c = castBarData.appearance.colors.notInterruptible;
  castBarData.frame.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);
end

---If player changes target, the target cast bar should be updated.
---@param castBar CastBar
---@param castBarData table
function Events:PLAYER_TARGET_CHANGED(castBar, castBarData)
  local active = false;

  if (UnitExists(castBarData.unitID)) then
    castBar:StopCasting();

    if (UnitCastingInfo(castBarData.unitID)) then
      castBar:StartCasting(false); -- for casting only (not channelling)
      active = true;
    elseif (UnitChannelInfo(castBarData.unitID)) then
      castBar:StartCasting(true); -- for casting only (not channelling)
      active = true;
    end
  end

  if (not active and castBarData.frame:GetAlpha() > 0) then
    castBar:StopCasting();
    castBarData.frame:SetAlpha(0);
    castBarData.frame:Hide();
  end
end

---@param castBar CastBar
---@param castBarData table
---@param unitID string
function Events:UNIT_SPELLCAST_START(castBar, castBarData, unitID)
  if (unitID ~= castBarData.unitID) then return end
  castBar:StartCasting(false);
end

local UnitBuff, tostring, BUFF_MAX_DISPLAY =
  _G.UnitBuff, _G.tostring, _G.BUFF_MAX_DISPLAY;

---@param castBar CastBar
---@param castBarData table
---@param unitID string
function Events:UNIT_AURA(castBar, castBarData, unitID)
  if (unitID ~= castBarData.unitID) then return end

  for auraID = 1, BUFF_MAX_DISPLAY do
    local name, iconTexture, _, _, duration, expirationTime, _, _, _, auraId = UnitBuff(unitID, auraID);

    if (name and ((tk.Constants.FOOD_DRINK_AURAS[tostring(auraId)]) or name == "Food" or name == "Drink")) then
        if (castBarData.auraId ~= auraId) then
          local startTime = expirationTime - (duration);
          startTime = startTime * 1000;
          expirationTime = expirationTime * 1000;

          local auraInfo = obj:PopTable(name, iconTexture, startTime, expirationTime, auraId);
          castBar:StartCasting(false, true, auraInfo);
        end
    end
  end
end

---@param castBar CastBar
---@param castBarData table
---@param unitID string
function Events:UNIT_SPELLCAST_CHANNEL_START(castBar, castBarData, unitID)
  if (unitID ~= castBarData.unitID) then return end
  castBar:StartCasting(true);
end

function Events:UNIT_SPELLCAST_EMPOWER_START(castBar, castBarData, unitID)
  self:UNIT_SPELLCAST_CHANNEL_START(castBar, castBarData, unitID);
end

---@param castBar CastBar
---@param castBarData table
function Events:UNIT_SPELLCAST_CHANNEL_STOP(castBar, castBarData)
  if (castBarData.frame.statusbar:GetValue() >= 0.1) then
    castBarData.interrupted = true;
  end

  castBarData.frame.statusbar:SetValue(select(2, castBarData.frame.statusbar:GetMinMaxValues()));
  castBar:StopCasting();
end

function Events:UNIT_SPELLCAST_EMPOWER_STOP(castBar, castBarData)
  castBarData.frame.statusbar:SetValue(select(2, castBarData.frame.statusbar:GetMinMaxValues()));
  castBar:StopCasting();
end

function Events:UNIT_POWER_BAR_HIDE(_, castBarData)
  UIFrameFadeOut(castBarData.frame, 1, castBarData.frame:GetAlpha(), 0);
end

function Events:UNIT_POWER_UPDATE(_, castBarData)
  local barInfo = _G.GetUnitPowerBarInfo("player");

  if (not barInfo) then
    self:UNIT_POWER_BAR_HIDE(nil, castBarData);
    return
  end

  local min = barInfo.minPower;
  local current = _G.UnitPower("player", _G.ALTERNATE_POWER_INDEX);
  local max = _G.UnitPowerMax("player", _G.ALTERNATE_POWER_INDEX);

  castBarData.frame.statusbar:SetMinMaxValues(min, max);
  castBarData.frame.statusbar:SetValue(current);

  local value = (current / max) * 100;
  local percentage = tk.Numbers:ToPrecision(value, 1);
  castBarData.frame.duration:SetText(("%d%%"):format(percentage));
end

function Events:UNIT_POWER_BAR_SHOW(castBar, castBarData)
  local name, tooltip = _G.GetUnitPowerBarStrings("player");
  castBarData.frame.name:SetText(name);
  castBarData.frame.tooltipText = tooltip;

  local c = castBarData.appearance.colors.normal;
  castBarData.frame.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);

  self:UNIT_POWER_UPDATE(castBar, castBarData);
  UIFrameFadeIn(castBarData.frame, 0.1, castBarData.frame:GetAlpha(), 1);
end

-- C_CastBar ----------------------

obj:DefineParams("table", "table", "string");
function C_CastBar:__Construct(data, settings, appearance, unitID)
  data.settings = settings;
  data.globalName = string.format("MUI_%sCastBar", unitID);
  data.unitID = unitID:lower();
  data.appearance = appearance;
  data.backdrop = obj:PopTable();

  -- Needed for event functions
  allCastBarData[data.unitID] = data;
end

local function IsFinished(data)
  local value = data.frame.statusbar:GetValue();
  local maxValue = select(2, data.frame.statusbar:GetMinMaxValues());

  if (data.channelling) then
    return value <= 0; -- max value for channelling is reversed
  end

  if (data.auraId) then
    for auraID = 1, BUFF_MAX_DISPLAY do
      local auraId = (select(10, UnitBuff(data.unitID, auraID)));

      if (data.auraId == auraId) then
        return false;
      end
    end

    return true;
  end

  return value >= maxValue;
end

local function CastBarFrame_OnUpdate(self, elapsed, data)
  if (self:GetAlpha() <= 0) then return end

  self.totalElapsed = self.totalElapsed + elapsed;

  if (self.enabled and self.totalElapsed > 0.01) then
    if (not data.startTime) then
      if (self:GetAlpha() == 0) then
        data.fadingOut = nil;
      end

      return
    end

    if (data.unitID == "mirror") then
      if (not data.paused or data.paused == 0) then
        for i = 1, _G.MIRRORTIMER_NUMTIMERS do
          local _, _, _, _, _, label = GetMirrorTimerInfo(i);

          if (label == self.name:GetText()) then
            local statusBar = _G.MirrorTimer1 and _G.MirrorTimer1.StatusBar or _G.MirrorTimer1StatusBar;
            local value = statusBar:GetValue();
            local duration = string.format("%.1f", value);

            if (tonumber(duration) > 60) then
              duration = date("%M:%S", duration);
            end

            self.duration:SetText(duration);
            self.statusbar:SetValue(value);
            return
          end
        end
      end
    else
      if (data.startTime and not IsFinished(data)) then
        if (UnitCastingInfo(data.unitID)) then
          local _, _, _, startTime = UnitCastingInfo(data.unitID);
          data.startTime = startTime / 1000;
        elseif (UnitChannelInfo(data.unitID)) then
          local _, _, _, startTime = UnitChannelInfo(data.unitID);
          data.startTime = startTime / 1000;
        end

        local difference = GetTime() - data.startTime;

        if (data.channelling or data.unitID == "mirror") then
          self.statusbar:SetValue(data.totalTime - difference);
        else
          self.statusbar:SetValue(difference);
        end

        local duration = data.totalTime - difference;

        if (duration < 0) then
          duration = 0;
        end

        duration = string.format("%.1f", duration);

        if (tonumber(duration) > 60) then
          duration = date("%M:%S", duration);
        end

        self.duration:SetText(duration);
      else
        self.castBar:StopCasting();
      end
    end

    self.totalElapsed = 0;
  end
end

local function CastBarFrame_OnEvent(bar, eventName, ...)
  if (eventName == "PLAYER_FOCUS_CHANGED") then
    eventName = "PLAYER_TARGET_CHANGED";
  end

  if (Events[eventName]) then
    Events[eventName](Events, bar.castBar, allCastBarData[bar.unitID], ...);
  end
end

do
  local function CreateBarFrame(unitID, settings, globalName)
    local bar = tk:CreateFrame("Frame", nil, globalName, _G.BackdropTemplateMixin and "BackdropTemplate");
    bar:SetAlpha(0);

    bar.statusbar = tk:CreateFrame("StatusBar", bar);
    bar.statusbar:SetValue(0);

    if (unitID == "player" and settings.showLatency) then
      bar.latencyBar = bar.statusbar:CreateTexture(nil, "ARTWORK");
      bar.latencyBar:SetPoint("TOPRIGHT");
      bar.latencyBar:SetPoint("BOTTOMRIGHT");
    end

    if (unitID == "mirror") then
      _G.MirrorTimer1:SetAlpha(0);
      _G.MirrorTimer1.SetAlpha = tk.Constants.DUMMY_FUNC;
    elseif (unitID == "power") then
      tk:KillElement(_G.PlayerPowerBarAlt);
    elseif (unitID == "player") then
      CastingBarFrame:UnregisterAllEvents();
      CastingBarFrame:Hide();
    elseif (unitID == "pet") then
      _G.PetCastingBarFrame:UnregisterAllEvents();
      _G.PetCastingBarFrame:Hide();
    end

    bar.name = bar.statusbar:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    bar.name:SetPoint("LEFT", 4, 0);
    bar.name:SetPoint("RIGHT", -40, 0);
    bar.name:SetWordWrap(false);
    bar.name:SetJustifyH("LEFT");

    bar.duration = bar.statusbar:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    bar.duration:SetPoint("RIGHT", -4, 0);
    bar.duration:SetJustifyH("RIGHT");

    bar.bg = tk:CreateFrame("Frame", bar);
    bar.bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -1, 1);
    bar.bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1);
    bar.bg:SetFrameLevel(5);

    return bar;
  end

  obj:DefineParams("boolean")
  function C_CastBar:SetEnabled(data, enabled)
    local bar = data.frame;

    if (not bar and not enabled) then return end

    if (enabled) then
      if (not bar) then
        bar = CreateBarFrame(data.unitID, data.settings, data.globalName);
        self:SetFrame(bar);
      end

      self:PositionCastBar();

      if (data.unitID == "mirror") then
        bar:RegisterEvent("MIRROR_TIMER_PAUSE");
        bar:RegisterEvent("MIRROR_TIMER_START");
        bar:RegisterEvent("MIRROR_TIMER_STOP");
      elseif (data.unitID == "power" and tk:IsRetail()) then
        bar:RegisterUnitEvent("UNIT_POWER_BAR_HIDE", "player");
        bar:RegisterUnitEvent("UNIT_POWER_UPDATE", "player");
        bar:RegisterUnitEvent("UNIT_POWER_BAR_SHOW", "player");
        tk:SetBasicTooltip(bar, nil, "ANCHOR_BOTTOM", 0, -6);
      else
        if (not tk:IsClassic() or data.unitID == "player") then
          bar:RegisterUnitEvent("UNIT_SPELLCAST_START", data.unitID);
          bar:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", data.unitID);
          bar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", data.unitID);
          bar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", data.unitID);

          if (tk:IsRetail()) then
            bar:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", data.unitID);
            bar:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_STOP", data.unitID);
          end

          if (db.global.castBars.showFoodDrink) then
            bar:RegisterUnitEvent("UNIT_AURA", data.unitID);
          end

          if (tk:IsClassic()) then
              -- These 2 are unnecessary in retail for some reason, and cause problems if enabled
              bar:RegisterUnitEvent("UNIT_SPELLCAST_STOP", data.unitID);
              bar:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", data.unitID);
          end
        else
          local wrapper = function(event, unitID, ...)
            if (unitID == data.unitID) then
              CastBarFrame_OnEvent(bar, event, unitID, ...);
            end
          end
          LibCC.RegisterCallback(bar, "UNIT_SPELLCAST_START", wrapper);
          LibCC.RegisterCallback(bar, "UNIT_SPELLCAST_STOP", wrapper);
          LibCC.RegisterCallback(bar, "UNIT_SPELLCAST_SUCCEEDED", wrapper);
          LibCC.RegisterCallback(bar, "UNIT_SPELLCAST_INTERRUPTED", wrapper);
          LibCC.RegisterCallback(bar, "UNIT_SPELLCAST_CHANNEL_START", wrapper);
          LibCC.RegisterCallback(bar, "UNIT_SPELLCAST_CHANNEL_STOP", wrapper);
        end

        if (data.unitID == "target") then
          bar:RegisterEvent("PLAYER_TARGET_CHANGED");
        elseif (not tk:IsClassic() and data.unitID == "focus") then
          bar:RegisterEvent("PLAYER_FOCUS_CHANGED");
        end

        if (tk:IsRetail()) then
          bar:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE", data.unitID);
          bar:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", data.unitID);
        end
      end

      bar.totalElapsed = 0;
      bar.castBar = self;
      bar.unitID = data.unitID;

      if (data.unitID ~= "power") then
        bar:SetScript("OnUpdate", function(self, elapsed)
          CastBarFrame_OnUpdate(self, elapsed, data);
        end);
      end

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

obj:DefineParams("number");
---@param numTicks number @The number of channelling ticks (when damage is applied)
function C_CastBar:SetTicks(data, numTicks)
  if (data.ticks) then
    for _, tick in ipairs(data.ticks) do
      tick:Hide();
    end
  end

  if (numTicks == 0) then
    return
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

obj:DefineParams("boolean");
function C_CastBar:SetIconEnabled(data, enabled)
  if (not enabled and not data.square) then
    return; -- nothing to do
    end

    if (not data.square) then
      data.square = tk:CreateFrame("Frame", data.frame, nil, _G.BackdropTemplateMixin and "BackdropTemplate");
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
  if (data.fadingOut) then return end

  local bar = self:GetFrame();
  data.startTime = nil;
  data.unitName = nil;
  data.auraId = nil;

  local c = data.interrupted and data.appearance.colors.interrupted or data.appearance.colors.finished;
  bar.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);

  data.interrupted = nil;
  data.fadingOut = true;

  if (not data.settings.unlocked) then
    UIFrameFadeOut(bar, 1, 1, 0);
  else
    bar.statusbar:SetValue(0);
    bar.name:SetText("");
    bar.duration:SetText("");
  end
end

obj:DefineParams("boolean", "boolean=true");
---Start casting or channelling a spell/ability.
---@param channelling boolean @If true, the casting type is set to "channelling" to reverse the bar direction.
function C_CastBar:StartCasting(data, channelling, fadeIn, auraInfo)
  local name, text, texture, startTime, endTime, notInterruptible;
  local auraId;
  local numStages = 0;
  local bar = self:GetFrame();

  if (not obj:IsTable(auraInfo)) then
    if (channelling) then
      name, text, texture, startTime, endTime, _, notInterruptible, _, _, numStages = UnitChannelInfo(data.unitID);
    else
      -- Casting has a cast ID for 7th arg, but channelling does not have this.
      name, text, texture, startTime, endTime, _, _, notInterruptible = UnitCastingInfo(data.unitID);
    end

    if (not tk:IsRetail()) then
      notInterruptible = false; -- does not get returned  by func
    end
  else
    -- Used mostly for food and drink:
    name, texture, startTime, endTime, auraId = obj:UnpackTable(auraInfo);
  end

  if (not startTime) then
    if (bar:GetAlpha() > 0 and not data.fadingOut) then
      self:StopCasting();
    end
    return
  end

  if (tk:IsRetail() and numStages) then
		local isChargeSpell = numStages > 0;

		if (isChargeSpell) then
			endTime = endTime + _G.GetUnitEmpowerHoldAtMaxTime(data.unitID);
      channelling = false;
		end
  end

  startTime = startTime / 1000; -- To make the same as GetTime() format
  endTime = endTime / 1000; -- To make the same as GetTime() format

  bar.statusbar:SetMinMaxValues(0, endTime - startTime); -- 0 to n seconds
  bar.name:SetText(text or name);

  if (data.icon) then
    data.icon:SetTexture(texture);
    data.icon:SetTexCoord(0.13, 0.87, 0.13, 0.87);
  end

  if (notInterruptible) then
    local c = data.appearance.colors.notInterruptible;
    bar.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);
  else
    local c = data.appearance.colors.normal;
    bar.statusbar:SetStatusBarColor(c.r, c.g, c.b, c.a);
  end

  if (bar.latencyBar) then
    if (data.settings.showLatency) then
      local width = math.floor(bar.statusbar:GetWidth() + 0.5);
      local percent = (select(4, GetNetStats()) / 1000);
      local latencyWidth = (width * percent);

      if (latencyWidth >= width or latencyWidth == 0) then
        bar.latencyBar:Hide();
      else
        bar.latencyBar:Show();
      end

      bar.latencyBar:SetWidth(latencyWidth);
    else
      bar.latencyBar:Hide();
    end
  end

  local totalTime = endTime - startTime;

  self:SetTicks(Ticks.data[name] or numStages or 0);

  -- ticks:
  if (channelling) then
    bar.statusbar:SetValue(totalTime);
  else
    bar.statusbar:SetValue(0);
  end

  if (fadeIn) then
    UIFrameFadeIn(bar, 0.1, 0, 1);
  end

  data.fadingOut = nil;
  data.interrupted = nil;
  data.channelling = channelling;
  data.unitName = UnitName(data.unitID);
  data.startTime = startTime; -- makes OnUpdate start casting the bar
  data.totalTime = totalTime;
  data.auraId = auraId;
end

function C_CastBar:PositionCastBar(data)
  self:ClearAllPoints();

  local anchorToSUF = IsAddOnLoaded("ShadowedUnitFrames") and data.settings.anchorToSUF;
  local unitframe = _G[ string.format("SUFUnit%s", data.unitID:lower()) ];
  local sufAnchor = unitframe and unitframe.portrait;

  if (not (anchorToSUF and sufAnchor)) then
    -- manual position...
    local point = data.settings.position[1];
    local relativeFrame = data.settings.position[2];
    local relativePoint = data.settings.position[3];
    local x, y = data.settings.position[4], data.settings.position[5];

    self:SetParent(_G.UIParent);

    if (point and relativeFrame and relativePoint and x and y) then
      self:SetPoint(point, _G[relativeFrame], relativePoint, x, y);
    else
      self:SetPoint("CENTER");
    end

    if (data.sqaure) then
      data.square:SetWidth(data.settings.height);
    end
  elseif (sufAnchor) then
    -- anchor to ShadowedUnitFrames
    self:SetParent(sufAnchor);
    self:SetPoint("TOPLEFT", sufAnchor, "TOPLEFT", -1, 1);
    self:SetPoint("BOTTOMRIGHT", sufAnchor, "BOTTOMRIGHT", 1, -1);

    if (data.square) then
      data.square:SetWidth(sufAnchor:GetHeight() + 2);
    end
  end

  -- Should be in Update functions but no support for executing dependencies if in a group.
  -- Needed for MUI config to work correctly when enabling/disabling a cast bar:
  self:SetFrameStrata(data.settings.frameStrata);
  self:SetFrameLevel(data.settings.frameLevel);
end

function C_CastBar:CheckStatus(data)
  if (UnitCastingInfo(data.unitID)) then
    self:StartCasting(false, false);
  elseif (UnitChannelInfo(data.unitID)) then
    self:StartCasting(true, false);
  else
    Events:UNIT_AURA(self, data, data.unitID)
  end
end

-- C_CastBarsModule -----------------------
function C_CastBarsModule:OnInitialize(data)
  data.bars = obj:PopTable();
  local r, g, b = tk:GetThemeColor();

  db:AddToDefaults("profile.castBars.appearance.colors.normal", {
    r = r, g = g, b = b, a = 0.7
  });

  for _, barName in obj:IterateArgs("Player", "Target", "Focus", "Mirror", "Pet", "Power") do
    if (not (tk:IsClassic() and barName == "Focus")) then
      local sv = db.profile.castBars[barName]; ---@type Observer
      sv:SetParent(db.profile.castBars.__templateCastBar);
    end
  end

  local first = {
    "Player.enabled";
    "Target.enabled";
    "Mirror.enabled";
    "Pet.enabled";
    "Power.enabled";
  };

  local ignore;

  if (not tk:IsClassic()) then
    first[4] = "Focus.enabled";
  else
    ignore = { "Focus.enabled" };
  end

  local options = {
    onExecuteAll = {
      first = first;
      ignore = ignore;
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
        patterns = { "(width|height|frameStrata|frameLevel|showIcon|leftToRight)" };
        value = function(value, keysList)
          local barName = keysList:PopFront();
          local attribute = keysList:PopFront();
          local castBar = data.bars[barName]; ---@type CastBar

          if (not castBar) then return end

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
          elseif (attribute == "leftToRight") then
            local bar = castBar:GetFrame();
            bar.statusbar:SetReverseFill(not value);
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

          for _, castBar in pairs(data.bars) do
            castBarData = data:GetFriendData(castBar);
            castBarData.frame.statusbar:SetStatusBarTexture(tk.Constants.LSM:Fetch("statusbar", value));
            castBarData.frame.statusbar:GetStatusBarTexture():SetBlendMode(data.settings.appearance.blendMode);
          end
        end;

        blendMode = function(value)
          local castBarData;
          for _, castBar in pairs(data.bars) do
            castBarData = data:GetFriendData(castBar);
            local texture = castBarData.frame.statusbar:GetStatusBarTexture();

            if (texture) then
              castBarData.frame.statusbar:GetStatusBarTexture():SetBlendMode(value);
            end
          end
        end;

        border = function(value)
          local castBarData;
          local color = data.settings.appearance.colors.border;

          for _, castBar in pairs(data.bars) do
            castBarData = data:GetFriendData(castBar);
            castBarData.backdrop.edgeFile = tk.Constants.LSM:Fetch("border", value);
            castBarData.frame:SetBackdrop(castBarData.backdrop);
            castBarData.frame:SetBackdropBorderColor(color.r, color.g, color.b, color.a);
          end
        end;

        fontSize = function(value)
          local castBarData;
          local fontSize = data.settings.appearance.fontSize;

          for _, castBar in pairs(data.bars) do
            castBarData = data:GetFriendData(castBar);
            castBarData.backdrop.edgeSize = value;
            tk:SetFontSize(castBarData.frame.name, fontSize);
            tk:SetFontSize(castBarData.frame.duration, fontSize);
          end
        end;

        borderSize = function(value)
          local castBarData;
          local color = data.settings.appearance.colors.border;

          for _, castBar in pairs(data.bars) do
            castBarData = data:GetFriendData(castBar);
            castBarData.backdrop.edgeSize = value;
            castBarData.frame:SetBackdrop(castBarData.backdrop);
            castBarData.frame:SetBackdropBorderColor(color.r, color.g, color.b, color.a);
          end
        end;

        inset = function(value)
          local castBarData;

          for _, castBar in pairs(data.bars) do
            castBarData = data:GetFriendData(castBar);
            castBarData.frame.statusbar:ClearAllPoints();
            castBarData.frame.statusbar:SetPoint("TOPLEFT", value, -value);
            castBarData.frame.statusbar:SetPoint("BOTTOMRIGHT", -value, value);
          end
        end;

        colors = {
          background = function(value)
            local castBarData;

            for _, castBar in pairs(data.bars) do
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

            for _, castBar in pairs(data.bars) do
              castBarData = data:GetFriendData(castBar);
              castBarData.frame:SetBackdropBorderColor(value.r, value.g, value.b, value.a);

              if (castBarData.settings.showIcon) then
                castBarData.square:SetBackdropBorderColor(value.r, value.g, value.b, value.a);
              end
            end
          end;

          normal = function(value)
            local castBarData;

            for _, castBar in pairs(data.bars) do
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
end

function C_CastBarsModule:OnInitialized(data)
  if (data.settings.enabled) then
    self:SetEnabled(true);
  end
end

function C_CastBarsModule:OnEnabled(data)
  -- recheck here
  for _, castBar in pairs(data.bars) do
    castBar:CheckStatus();
  end
end