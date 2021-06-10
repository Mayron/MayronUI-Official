-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local GetWatchedFactionInfo = _G.GetWatchedFactionInfo;
local C_ReputationBar = obj:Import("MayronUI.ReputationBar");

local strformat, select = _G.string.format, _G.select;

-- Local Functions -----------------------

local function OnReputationBarUpdate(_, _, bar, data)
  if (not bar:CanUse()) then
    bar:SetActive(false);
    return;
  end

  if (not bar:IsActive()) then
    bar:SetActive(true);
  end

  local factionName, standingID, minValue, maxValue, currentValue = GetWatchedFactionInfo();

  maxValue = maxValue - minValue;
  currentValue = currentValue - minValue;

  data.statusbar:SetMinMaxValues(0, maxValue);
  data.statusbar:SetValue(currentValue);

  local color = data.settings.standingColors[standingID] or data.settings.defaultColor;

  if (data.settings.useDefaultColor) then
    color = data.settings.defaultColor;
  end

  data.statusbar.texture:SetVertexColor(color.r or 0, color.g or 0, color.b or 0, color.a or 1);

  if (data.statusbar.text) then
      local percent = 100 - tk.Numbers:ToPrecision((currentValue / maxValue) * 100, 2);
      currentValue = tk.Strings:FormatReadableNumber(currentValue);
      maxValue = tk.Strings:FormatReadableNumber(maxValue);

      local text = strformat("%s: %s / %s (%s%% remaining)", factionName, currentValue, maxValue, percent);
      data.statusbar.text:SetText(text);
  end
end

-- C_ReputationBar -----------------------

obj:DefineParams("ResourceBars", "table");
function C_ReputationBar:__Construct(_, barsModule, moduleData)
  self:CreateResourceBar(barsModule, moduleData, "reputation");
end

obj:DefineReturns("boolean");
function C_ReputationBar:CanUse()
  -- standingID 8 == exalted
  local factionName, standingID = GetWatchedFactionInfo();
  local canUse = (factionName ~= nil and standingID < 8);
  return canUse;
end

obj:DefineParams("boolean");
function C_ReputationBar:SetActive(data, active)
  self:CallParentMethod("SetActive", active);

  if (active and data.notCreated) then
    local standingID = select(2, GetWatchedFactionInfo());
    local color = data.settings.standingColors[standingID] or data.settings.defaultColor;

    if (data.settings.useDefaultColor) then
      color = data.settings.defaultColor;
    end

    data.statusbar.texture = data.statusbar:GetStatusBarTexture();
    data.statusbar.texture:SetVertexColor(color.r or 0, color.g or 0, color.b or 0, color.a or 1);
    data.notCreated = nil;
  end
end

obj:DefineParams("boolean");
function C_ReputationBar:SetEnabled(data, enabled)
  if (enabled) then
    if (not em:GetEventListenerByID("OnReputationBarUpdate")) then
      local listener = em:CreateEventListenerWithID("OnReputationBarUpdate", OnReputationBarUpdate, self, data);
      listener:SetCallbackArgs(self, data);
      listener:RegisterEvents("UPDATE_FACTION", "PLAYER_REGEN_ENABLED");
    end

    if (self:CanUse()) then
      if (not self:IsActive()) then
        self:SetActive(true);
      end

      -- must be triggered AFTER it has been created!
      em:TriggerEventListenerByID("OnReputationBarUpdate");
    end

  elseif (self:IsActive()) then
    self:SetActive(false);
  end

  local listener = em:GetEventListenerByID("OnReputationBarUpdate");

  if (listener) then
    listener:SetEnabled(enabled);
  end
end
