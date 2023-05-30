local MayronUI = _G.MayronUI;
local tk, _, _, gui, obj = MayronUI:GetCoreComponents();
local Utils = MayronUI:GetComponent("ConfigMenuUtils");
local Components = MayronUI:GetComponent("ConfigMenuComponents");
local tonumber = _G.tonumber;

local function UpdateContainerHeight(self)
  self.dynamicFrame:Refresh();
end

function Components.frame(parent, config)
  local dynamicFrame = gui:CreateDynamicFrame(parent, nil, config.spacing or 10, config.padding or 10);
  local frame = dynamicFrame:GetFrame();

  if (config.OnClose) then
    gui:AddCloseButton(frame, config.OnClose);
  end

  local percent = nil;

  if (obj:IsString(config.width) and tk.Strings:Contains(config.width, "%%")) then
    percent = tk.Strings:Replace(config.width, "%%", "");
    percent = tonumber(percent);
  end

  if (config.width == "full" or config.width == nil) then
    frame.fullWidth = true;
  elseif (config.width == "fill") then
    frame.fillWidth = true;
  elseif (percent) then
    frame.percentWidth = percent;
  else
    if (obj:IsNumber(config.width)) then
      frame.minWidth = config.width;
    else
      frame.fullWidth = true;
    end
  end

  frame.originalHeight = config.height or 60; -- needed for fontstring resizing

  frame:SetHeight(frame.originalHeight);
  tk:SetBackground(frame, 0, 0, 0, 0.2);
  Utils:SetShown(frame, config.shown);

  frame.dynamicFrame = dynamicFrame; -- required for transferring config values into the real component
  frame.OnDynamicFrameRefresh = UpdateContainerHeight;

  return dynamicFrame;
end