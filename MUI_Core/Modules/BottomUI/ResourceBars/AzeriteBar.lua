-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
if (tk:IsClassic()) then return end

local C_AzeriteItem = _G.C_AzeriteItem;

-- Setup Objects -------------------------

local ResourceBarsPackage = obj:Import("MayronUI.ResourceBars");
local C_AzeriteBar = ResourceBarsPackage:Get("AzeriteBar");

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

    local percent = (activeXP / totalXP) * 100;

    activeXP = tk.Strings:FormatReadableNumber(activeXP);
    totalXP = tk.Strings:FormatReadableNumber(totalXP);

    local text = string.format("%s / %s (%d%%)", activeXP, totalXP, percent);
    data.statusbar.text:SetText(text);
  end
end

-- C_AzeriteBar --------------------------

ResourceBarsPackage:DefineParams("BottomUI_ResourceBars", "table");
function C_AzeriteBar:__Construct(_, barsModule, moduleData)
    self:Super(barsModule, moduleData, "azerite");
end

ResourceBarsPackage:DefineReturns("boolean");
function C_AzeriteBar:CanUse()
    return _G.AzeriteBarMixin:ShouldBeVisible() == true; -- this is a static mixin method
end

ResourceBarsPackage:DefineParams("boolean");
function C_AzeriteBar:SetActive(data, active)
    self.Parent:SetActive(active);

    if (active and data.notCreated) then
        data.statusbar.texture = data.statusbar:GetStatusBarTexture();
        data.statusbar.texture:SetVertexColor(_G.ARTIFACT_BAR_COLOR:GetRGB(), 0.8);

        data.notCreated = nil;
    end
end

ResourceBarsPackage:DefineParams("boolean");
function C_AzeriteBar:SetEnabled(data, enabled)
  if (enabled) then
    -- need to check when it's active
    local listener = em:CreateEventListenerWithID("AzeriteXP_Update", OnAzeriteXPUpdate);
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

