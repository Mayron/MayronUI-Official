-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;

local obj = MayronUI:GetComponent("Objects")--[[@as MayronObjects]];

---@class MayronUI.SlideController
local SlideController = obj:CreateClass("SlideController");
obj:Export(SlideController, "MayronUI");

local math, C_Timer, InCombatLockdown = _G.math, _G.C_Timer, _G.InCombatLockdown;
local select, type = _G.select, _G.type;
local VERTICAL = "VERTICAL";
local HORIZONTAL = "HORIZONTAL";
---------------------------------

local function SetValue(data, value)
  obj:Assert(obj:IsNumber(value), "bad argument #1 to 'SetValue' (number expected, got %s with value %s)", type(value), value);

  data.value = value;
  local minSize = data.frame.minSize or 1;

  obj:Assert(obj:IsNumber(minSize), "bad value 'minSize' found in call to 'SetValue' (number expected, got %s with value %s)", type(minSize), minSize);

  if (data.direction == VERTICAL) then
    data.frame:SetHeight(math.max(value, minSize));
  elseif (data.direction == HORIZONTAL) then
    data.frame:SetWidth(math.max(value, minSize));
  end

  local p, rf, rp, x, y = data.frame:GetPoint();

  if (data.direction == VERTICAL) then
    data.originalOffset = data.originalOffset or y;
  elseif (data.direction == HORIZONTAL) then
    data.originalOffset = data.originalOffset or x;
  end

  local nextOffset = data.originalOffset;

  if (value < minSize) then
    local amount = minSize - value;
    nextOffset = data.originalOffset + amount;
  end

  if (data.direction == VERTICAL) then
    data.frame:SetPoint(p, rf, rp, x, nextOffset);
  elseif (data.direction == HORIZONTAL) then
    data.frame:SetPoint(p, rf, rp, nextOffset, y);
  end
end

---@param slider MayronUI.SlideController
local function StartTransition(slider, data, isExpanding, ...)
  obj:Assert(obj:IsTable(data) and not data.GetObjectType);
  local step = math.abs(data.step);

  if (isExpanding ~= nil) then
    step = (isExpanding and step) or -step;
  else
    step = ((slider:IsMaxExpanded()) and -step) or step;
  end

  local function loop()
    if (InCombatLockdown()) then
      C_Timer.After(0.1, loop);
      return;
    end

    if (data.step == 0 or data.stop) then
      return
    end

    local newValue = data.value + step;
    local endValue = (step > 0 and data.maxValue) or data.minValue;
    local shouldContinue = (step > 0 and newValue < data.maxValue) or (step < 0 and newValue > data.minValue);

    if (shouldContinue) then
      SetValue(data, newValue);
      C_Timer.After(0.02, loop);
    else
      SetValue(data, endValue);
      slider:Stop();
    end
  end

  if (data.frame.ScrollFrame) then
    data.frame.ScrollFrame.animating = true;
  end

  data.frame:Show();

  local onStart;

  if (slider:IsMaxExpanded()) then
    onStart = data.onStartRetract;
  elseif (slider:IsMaxRetracted()) then
    onStart = data.onStartExpand;
  end

  if (obj:IsFunction(onStart)) then
    onStart(slider, data.frame, ...);
  end

  C_Timer.After(0.04, function()
    data.stop = nil;
    loop();
  end);
end


obj:DefineParams("Frame", "string", "?number", "boolean=true");
function SlideController:__Construct(data, frame, direction, step, retractOnHide)
  obj:Assert(direction == VERTICAL or direction == HORIZONTAL, "Unknown direction %s", direction);
  data.frame = frame;
  data.step = step or 30;
  data.minValue = 1;
  data.maxValue = 200;
  data.direction = direction;

  if (not obj:IsNumber(data.value)) then
    if (data.direction == VERTICAL) then
      data.value = data.frame:GetHeight();
    elseif (data.direction == HORIZONTAL) then
      data.value = data.frame:GetWidth();
    end
  end

  if (retractOnHide) then
    frame:HookScript("OnHide", function()
      SetValue(data, 1);
    end);
  end
end

function SlideController:StartExpanding(data, ...)
  StartTransition(self, data, true, ...);
end

function SlideController:StartRetracting(data, ...)
  StartTransition(self, data, false, ...);
end

function SlideController:Start(data)
  StartTransition(self, data, nil);
end

-- TODO: Add back in!
-- obj:SetAttribute(inCombatAttribute, true);
function SlideController:Stop(data)
  data.stop = true;

  if (data.frame.ScrollFrame and data.frame.showScrollBar) then
    data.frame.showScrollBar:Show();
  end

  if (data.frame.ScrollFrame) then
    data.frame.ScrollFrame.animating = false;
  end

  if (self:IsMaxExpanded() and data.onEndExpand) then
    data.onEndExpand(self, data.frame);

  elseif (self:IsMaxRetracted()) then
    if (data.onEndRetract) then
      data.onEndRetract(self, data.frame);
    else
      data.frame:Hide();
    end
  end
end

function SlideController:SetStepValue(data, step)
  data.step = step;
  data.backedUpStep = step;
end

function SlideController:IsRunning(data)
  return data.stop;
end

function SlideController:IsMaxExpanded(data)
  return data.value >= data.maxValue;
end

function SlideController:IsMaxRetracted(data)
  return data.value <= data.minValue;
end

function SlideController:SetMaxValue(data, maxValue)
  data.maxValue = maxValue;
end

function SlideController:SetMinValue(data, minValue)
  data.minValue = minValue;
end

function SlideController:SetValue(data, value)
  SetValue(data, value);
end

function SlideController:Hide(data)
  data.frame:Hide();
end

do
  local function AddDelay(func, delay, ...)
    local staticArgs = obj:PopTable(...);
    local staticArgLength = select("#", ...);

    -- Can't use varargs
    return function(self, frame, ...)
      local values = obj:PopTable();
      local index = 0;

      for i = 1, staticArgLength do
        index = index + 1;
        values[index] = staticArgs[i];
      end

      for i = 1, select("#", ...) do
        index = index + 1;
        values[index] = (select(i, ...));
      end

      if (obj:IsNumber(delay) and delay > 0) then
        C_Timer.After(0.02 * delay, function()
          func(self, frame, obj:UnpackTable(values));
        end);
      else
        func(self, frame, obj:UnpackTable(values));
      end
    end
  end

  function SlideController:OnStartExpand(data, func, delay, ...)
    data.onStartExpand = AddDelay(func, delay, ...);
  end

  function SlideController:OnEndExpand(data, func, delay, ...)
    data.onEndExpand = AddDelay(func, delay, ...);
  end

  function SlideController:OnStartRetract(data, func, delay, ...)
    data.onStartRetract = AddDelay(func, delay, ...);
  end

  function SlideController:OnEndRetract(data, func, delay, ...)
    data.onEndRetract = AddDelay(func, delay, ...);
  end
end