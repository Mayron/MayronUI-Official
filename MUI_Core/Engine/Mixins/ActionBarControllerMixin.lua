-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, _, obj = MayronUI:GetCoreComponents(); -- luacheck: ignore
local SlideController = obj:Import("MayronUI.SlideController");

local ipairs, pairs, type = _G.ipairs, _G.pairs, _G.type;
local UIFrameFadeIn, UIFrameFadeOut = _G.UIFrameFadeIn, _G.UIFrameFadeOut;
local After = _G.C_Timer.After;
local InCombatLockdown = _G.InCombatLockdown;
local PlaySound = _G.PlaySound;

local FADING_STACKING_DELAY = 0.2;

local function ToggleActionBarSet(bars, show, delay)
  delay = delay or 0;

  for _, bt4Bar in pairs(bars) do
    if (show) then
      bt4Bar:SetAlpha(0);
      bt4Bar.fadeIn = bt4Bar.fadeIn or function()
        UIFrameFadeIn(bt4Bar, 0.1, 0, 1);
      end;

      After(0.1 + (FADING_STACKING_DELAY * delay), bt4Bar.fadeIn);
    else
      bt4Bar:SetAlpha(1);
      bt4Bar.fadeOut = bt4Bar.fadeOut or function()
        UIFrameFadeOut(bt4Bar, 0.1, 1, 0);
      end;

      After(0 + (FADING_STACKING_DELAY * delay), bt4Bar.fadeOut);
    end
  end
end

local function OnStartExpand(_, _, settings, sets, nextActiveSetId)
  obj:Assert(obj:IsTable(settings), "bad argument #1 to 'OnStartExpand' (table expected, got %s with value %s)", type(settings), settings);
  obj:Assert(obj:IsTable(sets), "bad argument #2 to 'OnStartExpand' (table expected, got %s with value %s)", type(sets), sets);
  obj:Assert(obj:IsNumber(nextActiveSetId), "bad argument #3 to 'OnStartExpand' (number expected, got %s with value %s)", type(nextActiveSetId), nextActiveSetId);

  local delay = 0;
  settings.activeSets = nextActiveSetId;

  for setId = 1, settings.activeSets do
    local shouldFade = false;

    for _, bt4Bar in pairs(sets[setId]) do
      if (bt4Bar:GetVisibilityOption("always")) then
        bt4Bar:SetConfigAlpha(1);
        bt4Bar:SetVisibilityOption("always", false);
        shouldFade = true;
      end
    end

    if (shouldFade) then
      ToggleActionBarSet(sets[setId], true, delay)
      delay = delay + 1;
    end
  end
end

local function OnStartRetract(_, _, settings, sets, nextActiveSetId)
  obj:Assert(obj:IsTable(settings), "bad argument #1 to 'OnStartRetract' (table expected, got %s with value %s)", type(settings), settings);
  obj:Assert(obj:IsTable(sets), "bad argument #2 to 'OnStartRetract' (table expected, got %s with value %s)", type(sets), sets);
  obj:Assert(obj:IsNumber(nextActiveSetId), "bad argument #3 to 'OnStartRetract' (number expected, got %s with value %s)", type(nextActiveSetId), nextActiveSetId);

  local delay = 0;
  local previousActiveSets = settings.activeSets;
  settings.activeSets = nextActiveSetId;

  for setId = previousActiveSets, settings.activeSets + 1, -1 do
    ToggleActionBarSet(sets[setId], false, delay);
    delay = delay + 1;
  end
end

local function OnEndRetract(_, _, settings, sets)
  obj:Assert(obj:IsTable(settings), "bad argument #1 to 'OnEndRetract' (table expected, got %s with value %s)", type(settings), settings);
  obj:Assert(obj:IsTable(sets), "bad argument #2 to 'OnEndRetract' (table expected, got %s with value %s)", type(sets), sets);

  for setId = settings.activeSets + 1, #settings do
    for _, bt4Bar in pairs(sets[setId]) do
      bt4Bar:SetConfigAlpha(0);
      bt4Bar:SetVisibilityOption("always", true);
    end
  end
end

---@class BartenderControllerMixin
local BartenderControllerMixin = {};
MayronUI:AddComponent("BartenderController", BartenderControllerMixin);

function BartenderControllerMixin:Init(panel, settings, startPoint, direction, minFrameSize, bottomPadding, topPadding)
  direction = (direction or ""):upper();
  obj:Assert(direction == "VERTICAL" or direction == "HORIZONTAL", "Unknown direction %s", direction);

  self.settings = settings;
  self.panel = panel;
  self.panel.minSize = minFrameSize;
  self.sets = obj:PopTable();
  self.direction = direction;
  self.actionBarsModule = _G.Bartender4:GetModule("ActionBars");
  self.panelSizes = obj:PopTable();
  self.bottomPadding = bottomPadding or 0;
  self.topPadding = topPadding or 0;

  -- Setup Bartender Visibility and scaling Properties before calculating position
  for setId, barIds in ipairs(settings) do
    for _, bt4BarId in ipairs(barIds) do
      -- Tell Bartender to enable the bar
      self.actionBarsModule:EnableBar(bt4BarId);
      local bt4Bar = self.actionBarsModule.actionbars[bt4BarId];
      obj:Assert(bt4Bar, "Failed to setup bartender bar %s - bar does not exist", bt4BarId);

      self.sets[setId] = self.sets[setId] or obj:PopTable();
      self.sets[setId][bt4BarId] = bt4Bar;

      local shouldShow = settings.activeSets >= setId;
      bt4Bar:SetConfigAlpha((shouldShow and 1) or 0);
      bt4Bar:SetVisibilityOption("always", not shouldShow);

      if (settings.controlScale) then
        bt4Bar:SetConfigScale(settings.scale);
      end

      if (settings.controlPadding) then
        bt4Bar:SetPadding(settings.padding);
      end
    end
  end

  self:LoadPositions(startPoint);

  ---@type SlideController
  self.slider = SlideController(panel, direction, nil, false);
  self.slider:SetStepValue(settings.animationSpeed);
  self.slider:OnStartExpand(OnStartExpand, 5, self.settings, self.sets);
  self.slider:OnStartRetract(OnStartRetract, 0, self.settings, self.sets);
  self.slider:OnEndRetract(OnEndRetract, 0, self.settings, self.sets);

  -- Set Panel size based on active sets:
  local panelSize = settings.activeSets > 0 and self.panelSizes[settings.activeSets] or 0;
  self.slider:SetValue(panelSize);
end

function BartenderControllerMixin:LoadPositions(startPoint)
  local previousOffset;

  for setId, bars in ipairs(self.sets) do
    local size = self:GetBarSetSize(bars);
    local offset;

    if (not previousOffset) then
      offset = startPoint + self.bottomPadding + self.settings.panelPadding + size;
    else
      offset = previousOffset + self.settings.spacing + size;
    end

    previousOffset = offset;

    local endPoint = offset + (self.topPadding + self.settings.panelPadding);
    self.panelSizes[setId] = endPoint - startPoint;

    if (self.settings.controlPositioning) then
      for _, bt4Bar in pairs(bars) do
        if (self.direction == "VERTICAL") then
          bt4Bar.config.position.point = "BOTTOM";
          bt4Bar.config.position.y = offset;
        elseif (self.direction == "HORIZONTAL") then
          bt4Bar.config.position.point = "RIGHT";
          bt4Bar.config.position.x = -(offset);
        end

        bt4Bar:LoadPosition();
      end
    end
  end
end


function BartenderControllerMixin:GetBarSetSize(bars)
  local maxSize = 0;

  for _, bt4Bar in pairs(bars) do
    local btn = bt4Bar.buttons[1];
    local scale = bt4Bar:GetScale();
    local width, height = btn:GetSize();
    local size = (self.direction == "VERTICAL" and height) or width;

    if (scale ~= 1) then
      local unscaledSize = size / scale;
      local scaledBottomGap = (unscaledSize - size) / 2;
      size = size - scaledBottomGap;
    end

    if (size > maxSize) then
      maxSize = size;
    end
  end

  return maxSize;
end

function BartenderControllerMixin:PlayTransition(nextActiveSetId)
  if (InCombatLockdown()) then return end
  local previousActiveSetId = self.settings.activeSets;

  if (previousActiveSetId == nextActiveSetId) then return end

  PlaySound(tk.Constants.CLICK);

  local previousSize = previousActiveSetId > 0 and self.panelSizes[previousActiveSetId] or 0;
  local nextSize = nextActiveSetId > 0 and self.panelSizes[nextActiveSetId] or 0;
  self.slider:SetMinValue(math.min(previousSize, nextSize));
  self.slider:SetMaxValue(math.max(previousSize, nextSize));

  if (previousActiveSetId > nextActiveSetId) then
    self.slider:StartRetracting(nextActiveSetId);
  elseif (previousActiveSetId < nextActiveSetId) then
    self.slider:StartExpanding(nextActiveSetId);
  end
end