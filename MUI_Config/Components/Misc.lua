local MayronUI = _G.MayronUI;
local tk = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");

function Components.divider(parent, config)
  local divider = tk:CreateFrame("Frame", parent);
  divider:SetHeight(config.height or 1);
  divider.fullWidth = true;
  divider.divider = true;
  return divider;
end

function Components.condition(_, widgetTable)
  local result = widgetTable.func();
  return result and widgetTable.onTrue or widgetTable.onFalse;
end