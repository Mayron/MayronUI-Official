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

local function OnStartExpand(_, _, controller, nextActiveSetId)
  obj:Assert(obj:IsTable(controller), "bad argument #1 to 'OnStartExpand' (table expected, got %s with value %s)", type(controller), controller);
  obj:Assert(obj:IsNumber(nextActiveSetId), "bad argument #3 to 'OnStartExpand' (number expected, got %s with value %s)", type(nextActiveSetId), nextActiveSetId);

  local delay = 0;
  controller.animation.activeSets = nextActiveSetId;

  if (controller.bartender.controlVisibility) then
    for setId = 1, controller.animation.activeSets do
      local shouldFade = false;

      for _, bt4Bar in pairs(controller.sets[setId]) do
        if (bt4Bar:GetVisibilityOption("always")) then
          bt4Bar:SetConfigAlpha(1);
          bt4Bar:SetVisibilityOption("always", false);
          shouldFade = true;
        end
      end

      if (shouldFade) then
        ToggleActionBarSet(controller.sets[setId], true, delay)
        delay = delay + 1;
      end
    end
  end
end

local function OnStartRetract(_, _, controller, nextActiveSetId)
  obj:Assert(obj:IsTable(controller), "bad argument #1 to 'OnStartRetract' (table expected, got %s with value %s)", type(controller), controller);
  obj:Assert(obj:IsNumber(nextActiveSetId), "bad argument #3 to 'OnStartRetract' (number expected, got %s with value %s)", type(nextActiveSetId), nextActiveSetId);

  local delay = 0;
  local previousActiveSets = controller.animation.activeSets;
  controller.animation.activeSets = nextActiveSetId;

  if (controller.bartender.controlVisibility) then
    for setId = previousActiveSets, controller.animation.activeSets + 1, -1 do
      ToggleActionBarSet(controller.sets[setId], false, delay);
      delay = delay + 1;
    end
  end
end

local function OnEndRetract(_, _, controller)
  obj:Assert(obj:IsTable(controller), "bad argument #1 to 'OnEndRetract' (table expected, got %s with value %s)", type(controller), controller);

  if (controller.bartender.controlVisibility) then
    for setId = controller.animation.activeSets + 1, #controller.bartender do
      for _, bt4Bar in pairs(controller.sets[setId]) do
        bt4Bar:SetConfigAlpha(0);
        bt4Bar:SetVisibilityOption("always", true);
      end
    end
  end
end

---@class ActionBarControllerMixin
local ActionBarControllerMixin = {};
MayronUI:AddComponent("ActionBarController", ActionBarControllerMixin);

function ActionBarControllerMixin:Init(
  panel, settings, startPoint, direction, minFrameSize, bottomPadding, topPadding)

  direction = (direction or ""):upper();
  obj:Assert(direction == "VERTICAL" or direction == "HORIZONTAL", "Unknown direction %s", direction);

  self.bartender = settings.bartender;
  self.animation = settings.animation;
  self.panel = panel;
  self.panel.minSize = minFrameSize;
  self.sets = obj:PopTable();
  self.direction = direction;
  self.actionBarsModule = _G.Bartender4:GetModule("ActionBars");

  self.sizeMode = settings.sizeMode;
  self.panelSizes = tk.Tables:Copy(settings.manualSizes);

  self.panelPadding = settings.panelPadding;
  self.bottomPadding = bottomPadding or 0;
  self.topPadding = topPadding or 0;

  -- Setup Bartender Visibility and scaling Properties before calculating position
  self:ApplyOverrides();
  self:LoadPositions(startPoint);

  ---@type SlideController
  self.slider = SlideController(panel, direction, nil, false);
  self:SetAnimationSpeed(self.animation.speed);
  self.slider:OnStartExpand(OnStartExpand, 5, self);
  self.slider:OnStartRetract(OnStartRetract, 0, self);
  self.slider:OnEndRetract(OnEndRetract, 0, self);

  -- Set Panel size based on active sets:
  local panelSize = self.animation.activeSets > 0 and self.panelSizes[self.animation.activeSets] or 0;
  self.slider:SetValue(panelSize);
end

function ActionBarControllerMixin:SetAnimationSpeed(speed)
  self.slider:SetStepValue(speed);
end

function ActionBarControllerMixin:LoadPositions(startPoint)
  if (self.sizeMode ~= "dynamic") then return end

  local previousOffset;

  for setId, bars in ipairs(self.sets) do
    local size = self:GetBarSetSize(bars);
    local offset;

    if (not previousOffset) then
      offset = startPoint + self.bottomPadding + self.panelPadding + size;
    else
      offset = previousOffset + self.bartender.spacing + size;
    end

    previousOffset = offset;

    local endPoint = offset + (self.topPadding + self.panelPadding);
    self.panelSizes[setId] = endPoint - startPoint;

    if (self.bartender.controlPositioning) then
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

function ActionBarControllerMixin:ApplyOverrides()
  for setId, barIds in ipairs(self.bartender) do
    for index, bt4BarId in ipairs(barIds) do
      self.sets[setId] = self.sets[setId] or obj:PopTable();

      if (bt4BarId > 0) then
        -- Tell Bartender to enable the bar
        self.actionBarsModule:EnableBar(bt4BarId);
        local bt4Bar = self.actionBarsModule.actionbars[bt4BarId];
        obj:Assert(bt4Bar, "Failed to setup bartender bar %s - bar does not exist", bt4BarId);

        self.sets[setId][index] = bt4Bar;

        if (self.bartender.controlVisibility) then
          local shouldShow = self.animation.activeSets >= setId;
          bt4Bar:SetConfigAlpha((shouldShow and 1) or 0);
          bt4Bar:SetVisibilityOption("always", not shouldShow);
        end

        if (self.bartender.controlScale) then
          bt4Bar:SetConfigScale(self.bartender.scale);
        end

        if (self.bartender.controlPadding) then
          bt4Bar:SetPadding(self.bartender.padding);
        end
      end
    end
  end
end

function ActionBarControllerMixin:GetBarSetSize(bars)
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

function ActionBarControllerMixin:PlayTransition(nextActiveSetId)
  if (InCombatLockdown()) then return end
  local previousActiveSetId = self.animation.activeSets;

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