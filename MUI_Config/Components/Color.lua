local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, gui, obj = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type MayronUI.ConfigMenuUtils
local configMenu = MayronUI:ImportModule("ConfigMenu"); ---@type MayronUI.ConfigMenu

local hooksecurefunc = _G.hooksecurefunc;

local function SetColorValueToDatabase(container, r, g, b, a)
  if (container.useIndexes) then
    container.value[1] = r;
    container.value[2] = g;
    container.value[3] = b;
    container.value[4] = a;
  else
    container.value.r = r;
    container.value.g = g;
    container.value.b = b;
    container.value.a = a;
  end

  if (container.hasOpacity) then
    container.opacity = 1 - a;
  end

  configMenu:SetDatabaseValue(container, container.value);
end

local function OnColorContainerClick(self)
  self.loaded = nil;
  _G.OpenColorPicker(self);

  if (self.hasOpacity) then
    _G.OpacitySliderFrame:SetValue(self.opacity);
  end
end

local function OnColorSwatchButtonClick(self)
  self:SetChecked(true);
  OnColorContainerClick(self:GetParent());
end

local function OnColorComponentValueChanged()
  local container = _G.ColorPickerFrame.extraInfo;

  if (_G.ColorPickerFrame:IsShown() or not container.loaded) then
    -- do not update database until OkayButton clicked
    container.loaded = true;
    return
  end

  -- OkayButton was clicked so update database:
  local r, g, b = _G.ColorPickerFrame:GetColorRGB();
  local a = 1;

  if (container.hasOpacity) then
    a = 1 - _G.OpacitySliderFrame:GetValue();
  end

  SetColorValueToDatabase(container, r, g, b, a);
  container:ApplyThemeColor(r, g, b, a);

  if (container.requiresReload) then
    configMenu:ShowReloadMessage();
  end
end

local function OnColorComponentEnabled(container, enabled)
  local texturePath;

  local btn = container.btn;

  if (enabled) then
    btn.text:SetFontObject("GameFontHighlight");
    texturePath = tk:GetAssetFilePath("Textures\\Widgets\\Checked");
    container:SetAlpha(1);
  else
    btn.text:SetFontObject("GameFontDisable");
    texturePath = tk:GetAssetFilePath("Textures\\Widgets\\Unchecked");
    container:SetAlpha(0.8);
  end

  btn:SetEnabled(enabled);
  container.color:SetTexture(texturePath);
end

function Components.color(parent, config, value)
  if (not obj:IsTable(value)) then
    -- Might have been appended and removed
    value = { 1, 1, 1, r = 1; g = 1; b = 1; a = 1 };
  end

  local cbContainer = gui:CreateColorSwatchButton(parent, config.name, config.tooltip, nil, config.verticalAlignment);
  cbContainer.btn:SetScript("OnClick", OnColorSwatchButtonClick);
  cbContainer:SetScript("OnClick", OnColorContainerClick);

  -- info options:
  cbContainer.extraInfo = cbContainer;
  cbContainer.swatchFunc = OnColorComponentValueChanged;
  cbContainer.hasOpacity = config.hasOpacity;
  cbContainer.value = value;

  local r = value.r or value[1] or 0;
  local g = value.g or value[2] or 0;
  local b = value.b or value[3] or 0;
  local a = 1;

  if (config.hasOpacity) then
    a = (value.a or value[4] or 0);
    cbContainer.opacity = 1 - a;
  end

  cbContainer:ApplyThemeColor(r, g, b, a);

  hooksecurefunc(cbContainer, "SetEnabled", OnColorComponentEnabled);
  Utils:SetComponentEnabled(cbContainer.btn, config.enabled);

  return cbContainer;
end
