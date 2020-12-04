-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local UnitXP, UnitXPMax, GetXPExhaustion = _G.UnitXP, _G.UnitXPMax, _G.GetXPExhaustion;
local CreateFrame = _G.CreateFrame;

-- Setup Objects -------------------------

local ResourceBarsPackage = obj:Import("MayronUI.ResourceBars");
local C_ExperienceBar = ResourceBarsPackage:Get("ExperienceBar");

-- Local Functions -----------------------

local function OnExperienceBarUpdate(handler, eventName, statusbar, rested) -- luacheck: ignore
    local currentValue = UnitXP("player");
    local maxValue = UnitXPMax("player");
    local exhaustValue = GetXPExhaustion();

    statusbar:SetMinMaxValues(0, maxValue);
    statusbar:SetValue(currentValue);
    rested:SetMinMaxValues(0, maxValue);
    rested:SetValue(exhaustValue and (exhaustValue + currentValue) or 0);

    local percent = (currentValue / maxValue) * 100;
    currentValue = tk.Strings:FormatReadableNumber(currentValue);
    maxValue = tk.Strings:FormatReadableNumber(maxValue);

    local text = string.format("%s / %s (%d%%)", currentValue, maxValue, percent);
    statusbar.text:SetText(text);
end

local function OnExperienceBarLevelUp(_, _, bar)
  if (not bar:CanUse()) then
    bar:SetActive(false);
    return;
  end
end

-- C_ExperienceBar -----------------------

ResourceBarsPackage:DefineParams("BottomUI_ResourceBars", "table");
function C_ExperienceBar:__Construct(data, barsModule, moduleData)
  self:Super(barsModule, moduleData, "experience");
  data.blizzardBar = _G.MainMenuExpBar;
end

ResourceBarsPackage:DefineReturns("boolean");
function C_ExperienceBar:CanUse()
  return not tk:IsPlayerMaxLevel();
end

ResourceBarsPackage:DefineParams("boolean");
function C_ExperienceBar:SetActive(data, active)
  self.Parent:SetActive(active);

  if (active and data.notCreated) then
    data.rested = CreateFrame("StatusBar", nil, data.frame);
    data.rested:SetStatusBarTexture(tk.Constants.LSM:Fetch("statusbar", "MUI_StatusBar"));
    data.rested:SetPoint("TOPLEFT", 1, -1);
    data.rested:SetPoint("BOTTOMRIGHT", -1, 1);
    data.rested:SetOrientation("HORIZONTAL");

    data.rested.texture = data.rested:GetStatusBarTexture();
    data.rested.texture:SetVertexColor(0, 0.3, 0.5, 0.3);

    local r, g, b = tk:GetThemeColor();
    data.statusbar.texture:SetVertexColor(r * 0.8, g * 0.8, b  * 0.8);

    -- once max level, can never reactivate
    em:CreateEventHandlerWithKey("PLAYER_LEVEL_UP", "OnExperienceBarLevelUp", OnExperienceBarLevelUp, self);
    em:CreateEventHandlerWithKey("PLAYER_XP_UPDATE", "OnExperienceBarUpdate", OnExperienceBarUpdate, data.statusbar, data.rested);

    data.notCreated = nil;
  end
end

ResourceBarsPackage:DefineParams("boolean");
function C_ExperienceBar:SetEnabled(_, enabled)
  if (enabled) then
    if (self:CanUse()) then
      if (not self:IsActive()) then
        self:SetActive(true);
      end

      -- must be triggered AFTER it has been created!
      em:TriggerEventHandlerByKey("OnExperienceBarUpdate");
    end

  elseif (self:IsActive()) then
    self:SetActive(false);
  end

  local handler = em:FindEventHandlerByKey("OnExperienceBarLevelUp");
  local handler2 = em:FindEventHandlerByKey("OnExperienceBarUpdate");

  if (handler) then
    handler:SetEventTriggerEnabled("PLAYER_LEVEL_UP", enabled);
  end

  if (handler2) then
    handler2:SetEventTriggerEnabled("PLAYER_XP_UPDATE", enabled);
  end
end
