-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local _, C_UnitPanels = _G.MayronUI:ImportModule("UnitPanels");

local FLASH_TIME_ON = 0.65;
local FLASH_TIME_OFF = 0.65;
local pulseTime = 0;
local isPulsing = false;

local IsResting, ipairs, InCombatLockdown = _G.IsResting, _G.ipairs, _G.InCombatLockdown;
local subTextures = { "left", "center", "right", "player", "target" };

local function ShouldPulse(data)
  return not (data.stopPulsing or InCombatLockdown()) and IsResting() and data.settings.restingPulse;
end

local function UnitPanels_UpdateAlpha(data, _, elapsed)
  if (not ShouldPulse(data)) then return end
  pulseTime = (pulseTime or 0) - elapsed;

  if (pulseTime < 0) then
    local overtime = -pulseTime;

    if (not isPulsing) then
      isPulsing = true;
      pulseTime = FLASH_TIME_ON;
    else
      isPulsing = false;
      pulseTime = FLASH_TIME_OFF;
    end

    if (overtime < pulseTime) then
      pulseTime = pulseTime - overtime;
    end
  end

  local alpha;

  if (isPulsing) then
    alpha = (FLASH_TIME_ON - pulseTime) / FLASH_TIME_ON;
  else
    alpha = pulseTime / FLASH_TIME_ON;
  end

  local maxAlpha = (data.settings.alpha + data.settings.pulseStrength);
  local minAlpha =  data.settings.alpha;

  if (maxAlpha > 1) then
    maxAlpha = 1;
    minAlpha = 1 - data.settings.pulseStrength;
  end

  alpha = (alpha * (maxAlpha - minAlpha)) + minAlpha;
  data.currentPulseAlpha = alpha;

  for _, key in ipairs(subTextures) do
    if (key == "player" and not data.settings.unitNames.enabled) then break end

    if (obj:IsWidget(data[key]) and obj:IsWidget(data[key].bg)) then
      data:Call("UpdateVisuals", data[key], alpha);
    end
  end
end

local PulseTimeManager = _G.CreateFrame("Frame");

local function TriggerPulsing(data)
  if (ShouldPulse(data)) then
    PulseTimeManager:SetScript("OnUpdate", function(...) UnitPanels_UpdateAlpha(data, ...) end);
  else
    PulseTimeManager:SetScript("OnUpdate", nil);

    for _, key in ipairs(subTextures) do
      if (key == "player" and not data.settings.unitNames.enabled) then break end

      if (obj:IsWidget(data[key]) and obj:IsWidget(data[key].bg)) then
        data:Call("UpdateVisuals", data[key]);
      end
    end
  end
end

function C_UnitPanels:SetRestingPulseEnabled(data, enabled)
  local listener = em:GetEventListenerByID("MuiRestingPulse");
  if (not listener and not enabled) then return end

  if (not listener) then
    -- enabled must be true
    listener = em:CreateEventListenerWithID("MuiRestingPulse", function(_, event)
      if (event == "PLAYER_REGEN_DISABLED") then
        data.stopPulsing = true;
      elseif (event == "PLAYER_REGEN_ENABLED") then
        data.stopPulsing = nil;
      end

      TriggerPulsing(data);
    end);

    listener:RegisterEvents(
      "PLAYER_REGEN_ENABLED", "PLAYER_REGEN_DISABLED",
      "PLAYER_ENTERING_WORLD", "PLAYER_UPDATE_RESTING");
  else
    listener:SetEnabled(enabled);
  end

  TriggerPulsing(data);
end