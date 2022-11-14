local MayronUI = _G.MayronUI;
local tk, _, _, gui = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");

function Components.frame(parent, config)
  local frame = tk:CreateFrame(nil, parent);
  local dynamicFrame = gui:CreateDynamicFrame(
    parent, config.spacing or 10, config.padding or 10, frame);

  if (config.OnClose) then
    gui:AddCloseButton(frame, config.OnClose);
  end

  if (config.width) then
    frame:SetWidth(config.width);
  else
    tk:SetFullWidth(frame, 20);
  end

  frame.originalHeight = config.height or 60; -- needed for fontstring resizing

  frame:SetHeight(frame.originalHeight);
  tk:SetBackground(frame, 0, 0, 0, 0.2);

  return dynamicFrame;
end