-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local GetWatchedFactionInfo = _G.GetWatchedFactionInfo;
local C_ReputationBar = obj:Import("MayronUI.ReputationBar");

local strformat = _G.string.format;

-- Local Functions -----------------------

local standingColors = {
  {r=0.850980392, g=0.129411765, b=0.129411765, a=1.0}, -- Hated
  {r=0.870588235, g=0.329411765, b=0.11372549, a=1.0}, -- Hostile
  {r=0.870588235, g=0.494117647, b=0.11372549, a=1.0}, -- Unfriendly
  {r=0.968627451, g=0.968627451, b=0.105882353, a=1.0}, -- Neutral
  {r=0.643137255, g=0.941176471, b=0.094117647, a=1.0}, -- Friendly
  {r=0.207843137, g=0.941176471, b=0.094117647, a=1.0}, -- Honored
  {r=0.098039216, g=0.811764706, b=0.215686275, a=1.0}, -- Revered
  {r=0.066666667, g=0.850980392, b=0.850980392, a=1.0}, -- Exalted
}

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

  local color = standingColors[standingID];
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
    data.statusbar.texture = data.statusbar:GetStatusBarTexture();
    local color = standingColors[_G.select(2, GetWatchedFactionInfo())];
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
