local MayronUI = _G.MayronUI;
local tk, _, _, gui = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");

function Components.frame(parent, widgetTable)
  local frame = tk:CreateFrame();
  local dynamicFrame = gui:CreateDynamicFrame(
    parent, widgetTable.spacing or 10, widgetTable.padding or 10, frame);

  if (widgetTable.OnClose) then
    gui:AddCloseButton(frame, widgetTable.OnClose);
  end

  if (widgetTable.width) then
    frame:SetWidth(widgetTable.width);
  else
    tk:SetFullWidth(frame, 20);
  end

  frame.originalHeight = widgetTable.height or 60; -- needed for fontstring resizing

  frame:SetHeight(frame.originalHeight);
  tk:SetBackground(frame, 0, 0, 0, 0.2);

  return dynamicFrame;
end