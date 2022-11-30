local _G = _G;
local MayronUI = _G.MayronUI;
local _, _, _, gui, obj = MayronUI:GetCoreComponents();
local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils
local configModule = MayronUI:ImportModule("ConfigMenu"); ---@type ConfigMenuModule
local max = _G.math.max;

local function OnCheckButtonClick(self)
  if (not self:IsEnabled()) then return end
  local checked = self:GetChecked();
  configModule:SetDatabaseValue(self:GetParent(), checked);

  if (obj:IsFunction(self.OnClick)) then
    self:OnClick(checked);
  end

  self.previousValue = checked;
end

local function OnCheckButtonContainerClick(self)
  if (self.btn:IsEnabled()) then
    self.btn:Click();
  end
end

function Components.check(parent, config, value)
  Utils:AppendDefaultValueToTooltip(config);
  local cbContainer = gui:CreateCheckButton(
    parent, config.name, config.tooltip, nil,
  config.verticalAlignment, config.type == "radio");

  cbContainer.btn:SetChecked(value);

  cbContainer.btn:SetScript("OnClick", OnCheckButtonClick);
  cbContainer:SetScript("OnClick", OnCheckButtonContainerClick);
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
  Utils:SetShown(cbContainer.btn, config.shown);

  return cbContainer;
end
