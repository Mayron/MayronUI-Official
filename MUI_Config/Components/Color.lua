local MayronUI = _G.MayronUI;
local tk = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils");
local configModule = MayronUI:ImportModule("ConfigMenu"); ---@type ConfigMenuModule

local hooksecurefunc = _G.hooksecurefunc;

local function ColorWidget_SaveValue(container, r, g, b, a)
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

  container.r = r;
  container.g = g;
  container.b = b;

  if (container.hasOpacity) then
    container.opacity = 1.0 - a;
  end

  configModule:SetDatabaseValue(container, container.value);
end

local function ColorWidget_OnClick(self)
  self.loaded = nil;
  _G.OpenColorPicker(self);

  if (self.hasOpacity) then
    _G.OpacitySliderFrame:SetValue(self.opacity);
  end
end

local function ColorWidget_OnValueChanged()
  local container = _G.ColorPickerFrame.extraInfo;

  if (_G.ColorPickerFrame:IsShown() or not container.loaded) then
  -- do not update database until OkayButton clicked
    container.loaded = true;
    return;
  end

  -- OkayButton was clicked so update database:
  local r, g, b = _G.ColorPickerFrame:GetColorRGB();
  local a;

  if (container.hasOpacity) then
    a = 1.0 - _G.OpacitySliderFrame:GetValue();
  end

  ColorWidget_SaveValue(container, r, g, b, a);
  container.color:SetColorTexture(r, g, b, a or 1);

  if (container.requiresReload) then
    configModule:ShowReloadMessage();
  end
end

local function Color_OnSetEnabled(self, value)
  if (value) then
    self.text:SetFontObject("GameFontHighlight");
    self.square:SetDrawLayer("BACKGROUND");
    self.square:SetVertexColor(1, 1, 1, 1);
  else
    self.text:SetFontObject("GameFontDisable");
    self.square:SetDrawLayer("OVERLAY");
    self.square:SetVertexColor(0, 0, 0, 0.5);
  end
end

function Components.color(parent, widgetTable, value)
  local container = tk:CreateFrame("Button", parent);
  container:SetScript("OnClick", ColorWidget_OnClick);

  -- create widget elements:
  container.square = tk:SetBackground(container, 1, 1, 1);
  container.square:ClearAllPoints();
  container.square:SetSize(16, 16);
  container.square:SetPoint("LEFT", 0, 1);

  container.text = container:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
  container.text:SetText(widgetTable.name);
  container.text:SetJustifyH("LEFT");
  container.text:SetPoint("LEFT", container.square, "RIGHT", 6, 0);

  container.color = container:CreateTexture(nil, "ARTWORK");
  container.color:SetSize(12, 12);
  container.color:SetPoint("CENTER", container.square, "CENTER");

  container:SetSize(
    widgetTable.width or (container.text:GetStringWidth() + 44),
    widgetTable.height or 30);

  -- info options:
  container.extraInfo = container;
  container.swatchFunc = ColorWidget_OnValueChanged;

  container.value = value;
  container.r = value.r or value[1] or 0;
  container.g = value.g or value[2] or 0;
  container.b = value.b or value[3] or 0;

  if (widgetTable.hasOpacity) then
    container.opacity = 1.0 - (value.a or value[4] or 0);
    container.hasOpacity = true;

    local blackBackground = container:CreateTexture(nil, "BORDER");
    blackBackground:SetSize(16, 16);
    blackBackground:SetPoint("CENTER", container.square, "CENTER");
    blackBackground:SetColorTexture(0, 0, 0);

    container.color:SetColorTexture(container.r, container.g, container.b, 1.0 - container.opacity);
  else
    container.color:SetColorTexture(container.r, container.g, container.b);
  end

  hooksecurefunc(container, "SetEnabled", Color_OnSetEnabled);
  Utils:SetWidgetEnabled(container, widgetTable.enabled);

  return container;
end
