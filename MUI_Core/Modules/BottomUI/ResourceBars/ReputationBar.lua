-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local GetWatchedFactionInfo = _G.GetWatchedFactionInfo;
local C_ReputationBar = obj:Import("MayronUI.ReputationBar");

-- Local Functions -----------------------

local function OnReputationBarUpdate(_, _, bar, data)
  if (not bar:CanUse()) then
    bar:SetActive(false);
    return;
  end

  if (not bar:IsActive()) then
    bar:SetActive(true);
  end

  local factionName, _, minValue, maxValue, currentValue = GetWatchedFactionInfo();

  maxValue = maxValue - minValue;
  currentValue = currentValue - minValue;

  data.statusbar:SetMinMaxValues(0, maxValue);
  data.statusbar:SetValue(currentValue);

  if (data.statusbar.text) then
    local percent = (currentValue / maxValue) * 100;
    currentValue = tk.Strings:FormatReadableNumber(currentValue);
    maxValue = tk.Strings:FormatReadableNumber(maxValue);

    local text = string.format("%s: %s / %s (%s%%)", factionName, currentValue, maxValue, percent);
    data.statusbar.text:SetText(text);
  end
end

-- C_ReputationBar -----------------------

obj:DefineParams("BottomUI_ResourceBars", "table");
function C_ReputationBar:__Construct(_, barsModule, moduleData)
  self:Super(barsModule, moduleData, "reputation");
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
  self.Parent:SetActive(active);

  if (active and data.notCreated) then
    data.statusbar.texture = data.statusbar:GetStatusBarTexture();
    data.statusbar.texture:SetVertexColor(0.16, 0.6, 0.16, 1);
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
