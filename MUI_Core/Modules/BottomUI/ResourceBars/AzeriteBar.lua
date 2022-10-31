-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
if (not tk:IsRetail()) then return end

local C_AzeriteItem = _G.C_AzeriteItem;
local C_AzeriteBar = obj:Import("MayronUI.AzeriteBar");
local strformat = _G.string.format;

-- Local Functions -----------------------

local function OnAzeriteXPUpdate(_, _, bar, data)
  if (not bar:CanUse()) then
    bar:SetActive(false);
    return;
  end

  if (not bar:IsActive()) then
    bar:SetActive(true);
  end

  local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem();
  local activeXP, totalXP = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation);

  data.statusbar:SetMinMaxValues(0, totalXP);
  data.statusbar:SetValue(activeXP);

  if (data.statusbar.text) then
    if (activeXP > 0 and totalXP == 0) then
      totalXP = activeXP;
    end

    local percent = 100 - tk.Numbers:ToPrecision((activeXP / totalXP) * 100, 2);

    activeXP = tk.Strings:FormatReadableNumber(activeXP);
    totalXP = tk.Strings:FormatReadableNumber(totalXP);

    local text = strformat("%s / %s (%d%% remaining)", activeXP, totalXP, percent);
    data.statusbar.text:SetText(text);
  end
end

-- C_AzeriteBar --------------------------

obj:DefineParams("ResourceBars", "table");
function C_AzeriteBar:__Construct(_, barsModule, moduleData)
  self:CreateResourceBar(barsModule, moduleData, "azerite");
end

obj:DefineReturns("boolean");
function C_AzeriteBar:CanUse()
  return _G.AzeriteBarMixin:ShouldBeVisible() == true; -- this is a static mixin method
end

obj:DefineParams("boolean");
function C_AzeriteBar:SetActive(data, active)
  self:CallParentMethod("SetActive", active);

  if (active and data.notCreated) then
    data.statusbar.texture = data.statusbar:GetStatusBarTexture();
    local r, g, b = _G.ARTIFACT_BAR_COLOR:GetRGB();
    data.statusbar.texture:SetVertexColor(r, g, b, 0.8);
    data.notCreated = nil;
  end
end

obj:DefineParams("boolean");
function C_AzeriteBar:SetEnabled(data, enabled)
  if (enabled) then
    -- need to check when it's active
    local listener = em:GetEventListenerByID("AzeriteXP_Update") or em:CreateEventListenerWithID("AzeriteXP_Update", OnAzeriteXPUpdate);
    listener:SetCallbackArgs(self, data);
    listener:RegisterEvents("AZERITE_ITEM_EXPERIENCE_CHANGED", "UNIT_INVENTORY_CHANGED");

    if (self:CanUse()) then
      if (not self:IsActive()) then
        self:SetActive(true);
      end

      -- must be triggered AFTER it has been created!
      em:TriggerEventListenerByID("AzeriteXP_Update");
    end

  elseif (self:IsActive()) then
    self:SetActive(false);
  end

  local listener = em:GetEventListenerByID("AzeriteXP_Update");

  if (listener) then
    listener:SetEnabled(enabled);
  end
end

