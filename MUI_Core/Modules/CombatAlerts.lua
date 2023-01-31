-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local UnitInVehicle, IsInInstance, UnitIsDeadOrGhost = _G.UnitInVehicle, _G.IsInInstance, _G.UnitIsDeadOrGhost;
local ALERTS_ON_UPDATE_DELAY = 0.1;
local ALERT_TEXT_SPACING = 15;
local HELPFUL, HARMFUL, DEBUFF, BUFF = "HELPFUL", "HARMFUL", "DEBUFF", "BUFF";
local COOLDOWN = "COOLDOWN";
local GCD_SPELL_ID = 61304;

local AlertsFrameMixin = {};
local ICONS = {};

-- Register and Import Modules -----------
local C_CombatAlerts = MayronUI:RegisterModule("CombatAlerts", "Combat Alerts");

-- Add Database Defaults -----------------

-- db:AddToDefaults("profile.alerts", {
--   width = 750;
--   enabled = true;
--   frameStrata = "LOW";
--   frameLevel = 5;
--   xOffset = 0;
--   yOffset = -1;
-- });

local function GetAlertHeight(alert)
  local height = alert:GetHeight();
  if (not alert.icon:IsVisible()) then
    return math.max(height, 15);
  end

  local iconHeight = alert.icon:GetHeight();
  return math.max(height, iconHeight, 15);
end

function AlertsFrameMixin:ApplyAppearance(alert, trigger)
  local text = trigger.appearance.text or "";
  local r, g, b, a = unpack(trigger.appearance.color);
  local size = trigger.appearance.size;
  local outline = trigger.appearance.outline and "OUTLINE";
  local shadow = trigger.appearance.shadow;

  local font = tk.Constants.LSM:Fetch("font", trigger.appearance.font);
  alert:SetFont(font, size, outline);
  alert:SetTextColor(r, g, b, a);

  if (shadow) then
    alert:SetShadowColor(0, 0, 0, 1);
    alert:SetShadowOffset(0, -2);
  else
    alert:SetShadowColor(0, 0, 0, 0);
    alert:SetShadowOffset(0, 0);
  end

  if (trigger.appearance.remaining) then
    local startTime, durationInSeconds = _G.GetSpellCooldown(trigger.query);

    if (obj:IsNumber(startTime) and obj:IsNumber(durationInSeconds)) then
      if (startTime > 0 and durationInSeconds > 0) then
        local timeFormat, time = _G.SecondsToTimeAbbrev(startTime + durationInSeconds - _G.GetTime());
        local timeRemainingText = tk.Strings:RemoveWhiteSpace(timeFormat:format(time));

        if (tk.Strings:IsNilOrWhiteSpace(text)) then
          text = timeRemainingText;
        else
          text = tk.Strings:JoinWithSpace(text, timeRemainingText);
        end
      end
    end
  end

  alert:SetText(text);

  local iconSettings = trigger.appearance.icon;
  local showIcon = obj:IsTable(iconSettings) and iconSettings.show;
  local iconTexture = ICONS[trigger.query];

  if (showIcon and iconTexture) then
    local iconSize = size * (iconSettings.scale or 1.25);
    local spacing = iconSettings.spacing or 4;
    local side = iconSettings.side or "LEFT";
    alert.icon.tex:SetTexture(iconTexture);
    alert.icon:ClearAllPoints();

    if (side == "TOP") then
      alert.icon:SetPoint("BOTTOM", alert, "TOP", 0, spacing);
    elseif (side == "BOTTOM") then
      alert.icon:SetPoint("BOTTOM", alert, "TOP", 0, -spacing);
    elseif (side == "RIGHT") then
      alert.icon:SetPoint("LEFT", alert, "RIGHT", spacing, 0);
    elseif (side == "LEFT") then
      alert.icon:SetPoint("RIGHT", alert, "LEFT", -spacing, 0);

    else -- "CENTER" (overlay)
      alert.icon:SetPoint("CENTER", alert, "CENTER");
    end


    alert.icon:SetSize(iconSize, iconSize);
    alert.icon:SetBackdropBorderColor(0, 0, 0);
    alert.icon.tex:SetPoint("TOPLEFT", 1, -1);
    alert.icon.tex:SetPoint("BOTTOMRIGHT", -1, 1);
    alert.icon:SetAlpha(a or 1);
    alert.icon:Show();
  else
    alert.icon:Hide();
  end

  alert.fixedPosition = trigger.appearance.position;
end

local function IsAlertActiveAndNotFixed(alert)
  return not alert.inactive and not obj:IsTable(alert.fixedPosition);
end

function AlertsFrameMixin:SetAlertShown(trigger, shown)
  local alert = nil;

  for _, existingAlert in ipairs(self.alerts) do
    if (existingAlert.id == trigger.query or (not alert and existingAlert.inactive)) then
      alert = existingAlert;
    end
  end

  if (not alert) then
    if (not shown) then return end
    alert = self:CreateFontString(nil, "OVERLAY");
    alert.icon = tk:CreateFrame("Frame", self, nil, _G.BackdropTemplateMixin and "BackdropTemplate");

    alert.icon:SetBackdrop({
      edgeFile = tk.Constants.LSM:Fetch("border", "Skinner");
      edgeSize = 1;
    });

    alert.icon.tex = alert.icon:CreateTexture(nil, "OVERLAY");
    alert.icon.tex:SetTexCoord(0.1, 0.9, 0.1, 0.9);
    table.insert(self.alerts, alert);
  end

  alert.inactive = not shown;
  alert.id = trigger.query;

  if (shown) then
    self:ApplyAppearance(alert, trigger);
  end

  local totalActiveAndNotFixed = tk.Tables:Count(self.alerts, IsAlertActiveAndNotFixed);
  local previousAlert = nil;

  for _, existingAlert in ipairs(self.alerts) do
    existingAlert:ClearAllPoints();

    if (existingAlert.inactive) then
      existingAlert:Hide();
      existingAlert.icon:Hide();
    else
      if (obj:IsTable(existingAlert.fixedPosition)) then
        local xOffset, yOffset = unpack(existingAlert.fixedPosition);
        existingAlert:SetPoint("CENTER", _G.UIParent, "CENTER", xOffset, yOffset);
      else
        local xOffset = 0;

        if (existingAlert.icon:IsVisible()) then
          local _, _, _, iconXOffset = existingAlert.icon:GetPoint();
          local iconWidth = existingAlert.icon:GetWidth();
          xOffset = (math.abs(iconXOffset) + iconWidth) / 2;
        end

        local yOffset = 0;

        if (previousAlert == nil) then
          if (totalActiveAndNotFixed > 0) then
            local alertHeight = GetAlertHeight(existingAlert);
            yOffset = ((totalActiveAndNotFixed * (alertHeight + ALERT_TEXT_SPACING)) - ALERT_TEXT_SPACING) / 2;
          end
        else
          local _, _, _, _, previousAlertYOffset = previousAlert:GetPoint();
          local previousAlertHeight = GetAlertHeight(previousAlert);
          yOffset = previousAlertYOffset - previousAlertHeight - ALERT_TEXT_SPACING;
        end

        existingAlert:SetPoint("TOP", xOffset, yOffset);
        previousAlert = existingAlert;
      end

      existingAlert:Show();
    end
  end
end

local function IsGlobalCooldown(start, duration)
  local gcdStart, gcdDuration = _G.GetSpellCooldown(GCD_SPELL_ID)
  return start == gcdStart and duration == gcdDuration;
end

function AlertsFrameMixin:IsAlertTriggered(trigger)
  local inVehicle = UnitInVehicle("player");
  local playerDead = UnitIsDeadOrGhost("player");

  if (inVehicle or playerDead) then return false; end

  if (trigger.inInstance) then
    local inInstance = IsInInstance(); -- https://wowpedia.fandom.com/wiki/API_IsInInstance

    if (not inInstance) then
      return false;
    end
  end

  local triggerType = trigger.type; ---@type string
  triggerType = tk.Strings:Trim(triggerType:upper());

  if (trigger.combat and not _G.InCombatLockdown()) then
    return false;
  end

  if (not ICONS[trigger.query]) then
    local _, _, icon = _G.GetSpellInfo(trigger.query);
    ICONS[trigger.query] = icon;
  end

  if (triggerType == BUFF or triggerType == DEBUFF) then
    local maxAuras, filterName;

    if (triggerType == BUFF) then
      maxAuras, filterName = _G.BUFF_MAX_DISPLAY, HELPFUL;
    else
      maxAuras, filterName = _G.DEBUFF_MAX_DISPLAY, HARMFUL;
    end

    local unitHasAura = false;
    local conditionsMet = true;

    for i = 1, maxAuras do

      if (trigger.unit == "raid") then
        if (not IsInRaid()) then
          return false;
        end

        for userIndex = 1, 40 do
          local raidId = ("raid%d"):format(userIndex);

          if (_G.UnitExists(raidId)) then
            local auraInfo = obj:PopTable(_G.UnitAura(raidId, i, filterName));
            local auraName = auraInfo[1];
            local stacks = auraInfo[3];
            local auraId = auraInfo[10];
            local source = auraInfo[7];

            if (source == "player" and (trigger.query == auraName) or (trigger.query == tostring(auraId))) then
              unitHasAura = true;

              if (obj:IsNumber(trigger.stacks)) then
                conditionsMet = trigger.stacks == stacks;
              end
            end

            obj:PushTable(auraInfo);
            if (unitHasAura) then
              break
            end
          end
        end
      else
        local auraInfo = obj:PopTable(_G.UnitAura(trigger.unit, i, filterName));
        local auraName = auraInfo[1];
        local stacks = auraInfo[3];
        local auraId = auraInfo[10];

        if ((trigger.query == auraName) or (trigger.query == tostring(auraId))) then
          unitHasAura = true;

          if (obj:IsNumber(trigger.stacks)) then
            conditionsMet = trigger.stacks == stacks;
          end
        end

        obj:PushTable(auraInfo);

        if (unitHasAura) then
          break
        end
      end
    end

    local shouldShowAlert = (trigger.exists == unitHasAura) and conditionsMet;
    return shouldShowAlert;
  end

  if (triggerType == COOLDOWN) then
    local start, duration =  _G.GetSpellCooldown(trigger.query);
    local isGCD = IsGlobalCooldown(start, duration);
    local onCooldown = not isGCD and start > 0 and duration > 0;

    if (trigger.available) then
      return not onCooldown;
    end

    return onCooldown;
  end

  return false;
end

function AlertsFrameMixin:Update()
  self.updating = true;

  for _, trigger in ipairs(self.triggers) do
    local alertTriggered = self:IsAlertTriggered(trigger);
    self:SetAlertShown(trigger, alertTriggered);
  end

  self.updating = nil;
end

local function AlertsFrameOnUpdate(frame, elapsed)
  frame.timeSinceLastUpdate = (frame.timeSinceLastUpdate or 0) + elapsed;

  if (frame.timeSinceLastUpdate >= ALERTS_ON_UPDATE_DELAY and not frame.updating) then
    frame.elapsedTime = (frame.elapsedTime or 0) + frame.timeSinceLastUpdate;
    frame:Update();
    frame.timeSinceLastUpdate = 0;
  end
end

-- C_CombatAlerts ------------------

function C_CombatAlerts:OnInitialize(data)
  local alertsFrame = tk:CreateFrame("Frame", nil, "MUI_CombatAlertsFrame");
  _G.Mixin(alertsFrame, AlertsFrameMixin);
  data.frame = alertsFrame;

  alertsFrame.triggers = {};
  alertsFrame.alerts = {};

  alertsFrame:SetPoint("CENTER", 0, 200);
  alertsFrame:SetSize(0.001, 0.001);
  alertsFrame:SetScript("OnUpdate", AlertsFrameOnUpdate);

  -- Test Trigger:
  table.insert(alertsFrame.triggers, {
    type = BUFF;
    class = "SHAMAN";
    spec = "Restoration";
    query = "Water Shield";
    inInstance = true;
    exists = false;
    unit = "player";
    appearance = {
      text = "Water Shield MISSING!";
      color = { tk.Constants.COLORS.BATTLE_NET_BLUE:GetRGBA() };
      size = 24,
      icon = {
        show = true;
      },
      font = "MUI_Font",
      outline = false;
      shadow = true;
    },
  });

  table.insert(alertsFrame.triggers, {
    type = BUFF;
    class = "SHAMAN";
    spec = "Restoration";
    query = "Earth Shield";
    inInstance = true;
    exists = false;
    unit = "raid";
    appearance = {
      text = "Earth Shield MISSING!";
      color = { tk.Constants.COLORS.GOLD:GetRGBA() };
      size = 24,
      icon = {
        show = true;
      },
      font = "MUI_Font",
      outline = false;
      shadow = true;
    },
  });

  -- Test CD!:
  table.insert(alertsFrame.triggers, {
    type = COOLDOWN;
    class = "SHAMAN";
    spec = "Restoration";
    query = "Nature's Swiftness";
    combat = true;
    available = true;
    inInstance = true;
    appearance = {
      text = "Nature's Swiftness!";
      color = { tk.Constants.COLORS.GREEN:GetRGBA() };
      remaining = true;
      size = 24,
      icon = {
        show = true;
      },
      font = "MUI_Font",
      outline = false;
      shadow = true;
    },
  });

  table.insert(alertsFrame.triggers, {
    type = COOLDOWN;
    class = "SHAMAN";
    spec = "Restoration";
    query = "Tidal Force";
    combat = true;
    available = true;
    inInstance = true;
    appearance = {
      text = "Tidal Force!";
      color = { tk.Constants.COLORS.YELLOW:GetRGBA() };
      remaining = true;
      size = 24,
      icon = {
        show = true;
      },
      font = "MUI_Font",
      outline = false;
      shadow = true;
    },
  });

  table.insert(alertsFrame.triggers, {
    type = COOLDOWN;
    class = "SHAMAN";
    spec = "Restoration";
    query = "Mana Tide Totem";
    available = false;
    inInstance = true;
    appearance = {
      color = { tk.Constants.COLORS.YELLOW:GetRGBA() };
      remaining = true;
      size = 16,
      icon = {
        show = true;
        xOffset = 38;
        yOffset = 32;
        scale = 2;
      },
      font = "MUI_Font",
      outline = false;
      shadow = true;
      position = { -50, -200 };
    },
  });

  table.insert(alertsFrame.triggers, {
    type = COOLDOWN;
    class = "SHAMAN";
    spec = "Restoration";
    query = "Riptide";
    inInstance = true;
    available = false;
    appearance = {
      color = { tk.Constants.COLORS.YELLOW:GetRGBA() };
      remaining = true;
      size = 16,
      icon = {
        show = true;
        spacing = 4;
        side = "TOP";
        scale = 2;
      },
      font = "MUI_Font",
      outline = false;
      shadow = true;
      position = { 0, -200 };
    },
  });
end

function C_CombatAlerts:RegisterTrigger(data, trigger)
  table.insert(data.frame.triggers, trigger);
end