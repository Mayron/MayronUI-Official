local _G = _G;
local MayronUI = _G.MayronUI;
local _, _, _, gui = MayronUI:GetCoreComponents();
local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils
local configModule = MayronUI:ImportModule("ConfigMenu"); ---@type ConfigMenuModule
local max = _G.math.max;

local function CheckButton_OnClick(self)
  configModule:SetDatabaseValue(self:GetParent(), self:GetChecked());

  if (self.OnClick) then
    self:OnClick(self:GetChecked());
  end
end

local function CheckButtonContainer_OnClick(self)
  self.btn:Click();
end

function Components.check(parent, config, value)
  Utils:AppendDefaultValueToTooltip(config);
  local cbContainer = gui:CreateCheckButton(parent, config.name, config.tooltip, nil, config.verticalAlignment);

  cbContainer.btn:SetChecked(value);
  cbContainer.btn:SetScript("OnClick", CheckButton_OnClick);
  cbContainer:SetScript("OnClick", CheckButtonContainer_OnClick);
  cbContainer.btn.OnClick = config.OnClick;

  local optimalWidth = cbContainer.btn:GetWidth() + 20 + cbContainer.btn.text:GetStringWidth();

  if (config.width) then
    local width = max(optimalWidth, config.width);
    cbContainer:SetWidth(width);
  else
    cbContainer:SetWidth(optimalWidth);
  end

  if (config.height) then
    cbContainer:SetHeight(config.height);
  end

  Utils:SetComponentEnabled(cbContainer.btn, config.enabled);

  return cbContainer;
end
