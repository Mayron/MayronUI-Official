local _G = _G;
local MayronUI = _G.MayronUI;
local _, _, _, gui, obj = MayronUI:GetCoreComponents();
local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils
local configModule = MayronUI:ImportModule("ConfigMenu"); ---@type MayronUI.ConfigMenu

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

  cbContainer:SetChecked(value);
  cbContainer.btn:SetScript("OnClick", OnCheckButtonClick);
  cbContainer.btn:SetScript("OnClick", OnCheckButtonClick);
  cbContainer:SetScript("OnClick", OnCheckButtonContainerClick);
  cbContainer.btn.OnClick = config.OnClick;

  Utils:SetComponentEnabled(cbContainer.btn, config.enabled);
  Utils:SetShown(cbContainer.btn, config.shown);

  return cbContainer;
end
