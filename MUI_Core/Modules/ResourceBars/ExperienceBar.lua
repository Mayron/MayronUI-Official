-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, em, _, obj = MayronUI:GetCoreComponents(); -- luacheck: ignore
local UnitXP, UnitXPMax, GetXPExhaustion = _G.UnitXP, _G.UnitXPMax, _G.GetXPExhaustion;
local C_ExperienceBar = obj:Import("MayronUI.ExperienceBar");
local strformat = _G.string.format;
local GetMaxPlayerLevel, StatusTrackingBarManager = _G.GetMaxPlayerLevel, _G.StatusTrackingBarManager;
local HitMaxLevel = false;

-- Local Functions -----------------------

local function OnExperienceBarUpdate(_, _, statusbar, rested) -- luacheck: ignore
    local currentValue = UnitXP("player");
    local maxValue = UnitXPMax("player");
    local exhaustValue = GetXPExhaustion();

    statusbar:SetMinMaxValues(0, maxValue);
    statusbar:SetValue(currentValue);
    rested:SetMinMaxValues(0, maxValue);
    rested:SetValue(exhaustValue and (exhaustValue + currentValue) or 0);

    local percent = 100 - tk.Numbers:ToPrecision((currentValue / maxValue) * 100, 2);
    currentValue = tk.Strings:FormatReadableNumber(currentValue);
    maxValue = tk.Strings:FormatReadableNumber(maxValue);

    local text = strformat("%s / %s (%d%% remaining)", currentValue, maxValue, percent);
    statusbar.text:SetText(text);
end

local function OnExperienceBarLevelUp(_, _, bar, newLevel)
  if (newLevel == GetMaxPlayerLevel()) then
    HitMaxLevel = true;
    bar:SetActive(false);
  end
end

-- C_ExperienceBar -----------------------

obj:DefineParams("ResourceBars", "table");
function C_ExperienceBar:__Construct(data, barsModule, moduleData)
  self:CreateResourceBar(barsModule, moduleData, "experience");
  data.blizzardBar = _G.MainMenuExpBar;
end

obj:DefineReturns("boolean");
function C_ExperienceBar:CanUse()
  return not (tk:IsPlayerMaxLevel() or HitMaxLevel);
end

obj:DefineParams("boolean");
function C_ExperienceBar:SetActive(data, active)
  self:CallParentMethod("SetActive", active);

  if (active and data.notCreated) then
    data.rested = tk:CreateFrame("StatusBar", data.frame);
    data.rested:SetStatusBarTexture(tk.Constants.LSM:Fetch("statusbar", "MUI_StatusBar"));
    data.rested:SetPoint("TOPLEFT", 1, -1);
    data.rested:SetPoint("BOTTOMRIGHT", -1, 1);
    data.rested:SetOrientation("HORIZONTAL");

    data.rested.texture = data.rested:GetStatusBarTexture();
    data.rested.texture:SetVertexColor(0, 0.3, 0.5, 0.3);

    local r, g, b = tk:GetThemeColor();
    data.statusbar.texture:SetVertexColor(r * 0.8, g * 0.8, b  * 0.8);

    -- once max level, can never reactivate
    local listener = em:CreateEventListenerWithID("OnExperienceBarLevelUp", OnExperienceBarLevelUp);
    listener:SetCallbackArgs(self);
    listener:RegisterEvent("PLAYER_LEVEL_UP");

    listener = em:CreateEventListenerWithID("OnExperienceBarUpdate", OnExperienceBarUpdate);
    listener:SetCallbackArgs(data.statusbar, data.rested);
    listener:RegisterEvent("PLAYER_XP_UPDATE");

    data.notCreated = nil;
  end
end

obj:DefineParams("boolean");
function C_ExperienceBar:SetEnabled(_, enabled)
  if (enabled) then
    if (self:CanUse()) then
      if (not self:IsActive()) then
        self:SetActive(true);
      end

      -- must be triggered AFTER it has been created!
      em:TriggerEventListenerByID("OnExperienceBarUpdate");
    end

  elseif (self:IsActive()) then
    self:SetActive(false);
  end

  local levelUpListener = em:GetEventListenerByID("OnExperienceBarLevelUp");
  local onUpdateListener = em:GetEventListenerByID("OnExperienceBarUpdate");

  if (levelUpListener) then
    levelUpListener:SetEnabled(enabled);
  end

  if (onUpdateListener) then
    onUpdateListener:SetEnabled(enabled);
  end
end
