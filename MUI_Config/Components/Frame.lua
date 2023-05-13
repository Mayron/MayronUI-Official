local MayronUI = _G.MayronUI;
local tk, _, _, gui, obj = MayronUI:GetCoreComponents();
local Utils = MayronUI:GetComponent("ConfigMenuUtils");
local Components = MayronUI:GetComponent("ConfigMenuComponents");
local tonumber = _G.tonumber;

function Components.frame(parent, config)
  local frame = tk:CreateFrame(nil, parent);
  local dynamicFrame = gui:CreateDynamicFrame(
    parent, config.spacing or 10, config.padding or 10, frame);

  if (config.OnClose) then
    gui:AddCloseButton(frame, config.OnClose);
  end

  local percent = nil;

  if (obj:IsString(config.width) and tk.Strings:Contains(config.width, "%%")) then
    percent = tk.Strings:Replace(config.width, "%%", "");
    percent = tonumber(percent);
  end

  if (obj:IsNumber(percent) or not config.width) then
    tk:SetFullWidth(frame, 20, percent);
  else
    frame:SetWidth(config.width or 200);
  end

  frame.originalHeight = config.height or 60; -- needed for fontstring resizing

  frame:SetHeight(frame.originalHeight);
  tk:SetBackground(frame, 0, 0, 0, 0.2);
  Utils:SetShown(frame, config.shown);

  frame.dynamicFrame = dynamicFrame; -- required for transferring config values into the real component

  return dynamicFrame;
end