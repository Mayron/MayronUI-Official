local MayronUI = _G.MayronUI;
local _, _, _, gui = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils");
local configModule = MayronUI:ImportModule("ConfigMenu"); ---@type ConfigMenuModule

local function CheckButton_OnClick(self)
  configModule:SetDatabaseValue(self:GetParent(), self:GetChecked());

  if (self.OnClick) then
    self:OnClick(self:GetChecked());
  end
end

local function CheckButtonContainer_OnClick(self)
  self.btn:Click();
end

function Components.check(parent, widgetTable, value)
  local cbContainer = gui:CreateCheckButton(
    parent, widgetTable.name,
    widgetTable.tooltip);

  cbContainer.btn:SetChecked(value);
  cbContainer.btn:SetScript("OnClick", CheckButton_OnClick);
  cbContainer:SetScript("OnClick", CheckButtonContainer_OnClick);
  cbContainer.btn.OnClick = widgetTable.OnClick;

  if (widgetTable.width) then
    cbContainer:SetWidth(widgetTable.width);
  else
    cbContainer:SetWidth(cbContainer.btn:GetWidth() + 20 + cbContainer.btn.text:GetStringWidth());
  end

  if (widgetTable.height) then
    cbContainer:SetHeight(widgetTable.height);
  end

  Utils:SetWidgetEnabled(cbContainer.btn, widgetTable.enabled);

  return cbContainer;
end
