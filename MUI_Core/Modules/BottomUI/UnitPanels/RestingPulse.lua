-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local C_UnitPanels = _G.MayronUI:ImportModule("BottomUI_UnitPanels");

local FLASH_TIME_ON = 0.65;
local FLASH_TIME_OFF = 0.65;
local pulseTime = 0;
local isPulsing = false;

local function UnitPanels_UpdateAlpha(data, frame, elapsed)
  if (not data:ShouldPulse()) then return end
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

  for _, key in obj:IterateArgs("left", "center", "right", "player", "target") do
    if (key == "player" and not data.settings.unitNames.enabled) then break end

    if (obj:IsWidget(data[key]) and obj:IsWidget(data[key].bg)) then
      data:UpdateVisuals(data[key], alpha);
    end
  end
end

local PulseTimeManager = _G.CreateFrame("Frame");

local function TriggerPulsing(data)
  if (data:ShouldPulse()) then
    PulseTimeManager:SetScript("OnUpdate", function(...) UnitPanels_UpdateAlpha(data, ...) end);
  else
    PulseTimeManager:SetScript("OnUpdate", nil);

    for _, key in obj:IterateArgs("left", "center", "right", "player", "target") do
      if (key == "player" and not data.settings.unitNames.enabled) then break end

      if (obj:IsWidget(data[key]) and obj:IsWidget(data[key].bg)) then
        data:UpdateVisuals(data[key]);
      end
    end
  end
end

local eventTriggers = "PLAYER_REGEN_ENABLED, PLAYER_REGEN_DISABLED, PLAYER_ENTERING_WORLD, PLAYER_UPDATE_RESTING";
function C_UnitPanels:SetRestingPulseEnabled(data, enabled)
  local handler = em:FindEventHandlerByKey("MuiRestingPulse");
  if (not handler and not enabled) then return end

  if (not handler) then
    -- enabled must be true
    em:CreateEventHandlerWithKey(eventTriggers, "MuiRestingPulse", function(_, event)
      if (event == "PLAYER_REGEN_DISABLED") then
        data.stopPulsing = true;
      elseif (event == "PLAYER_REGEN_ENABLED") then
        data.stopPulsing = nil;
      end

      TriggerPulsing(data);
    end);
  else
    handler:SetEnabled(enabled);
  end

  TriggerPulsing(data);
end