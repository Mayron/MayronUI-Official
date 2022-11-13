local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, _, obj = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils");
local configModule = MayronUI:ImportModule("ConfigMenu"); ---@type ConfigMenuModule

local min = _G.math.min;
local max = _G.math.max;
local PlaySound = _G.PlaySound;
local tonumber = _G.tonumber;

local function Slider_OnValueChanged(self, value, userset)
  if (userset) then
    value = tk.Numbers:ToPrecision(value, self.precision);
    self.editBox:SetText(value);
    configModule:SetDatabaseValue(self.configContainer, value);
  end
end

local function Slider_OnEnable(self)
  self:SetAlpha(1);
  self.editBox:SetEnabled(true);
end

local function Slider_OnDisable(self)
    self:SetAlpha(0.7);
    self.editBox:SetEnabled(false);
end

function Components.slider(parent, widgetTable, value)
  local slider = tk:CreateFrame("Slider", parent, nil, "OptionsSliderTemplate");

  tk:KillElement(slider.NineSlice);
  local bg = tk:SetBackground(slider, 0, 0, 0, 0.5);
  bg:ClearAllPoints();
  bg:SetPoint("LEFT");
  bg:SetPoint("RIGHT");
  bg:SetHeight(8);

  slider.precision = widgetTable.precision or 1;

  if (widgetTable.tooltip) then
    tk:SetBasicTooltip(slider, widgetTable.tooltip);
  end

  -- widgetTable gets cleaned
  local minValue = widgetTable.min;
  local maxValue = widgetTable.max;
  local step = widgetTable.step;

  slider:DisableDrawLayer("BORDER");
  slider:SetMinMaxValues(minValue, maxValue);
  slider:SetValueStep(step or 1);
  slider:SetObeyStepOnDrag(true);
  slider:SetValue(value or minValue);
  slider:SetThumbTexture(tk:GetAssetFilePath("Textures\\Widgets\\SliderThumb"));
  slider:GetThumbTexture():SetSize(14, 24);

  local backdrop = _G.BackdropTemplateMixin and "BackdropTemplate, InputBoxTemplate" or "InputBoxTemplate";
  slider.editBox = tk:CreateFrame("EditBox", slider, nil, backdrop);
  slider.editBox:SetAutoFocus(false);

  slider.editBox:SetScript("OnEscapePressed", function()
    slider.editBox:ClearFocus();
    slider.editBox:SetText(slider:GetValue());
  end);

  slider.editBox:SetScript("OnEnterPressed", function()
    slider.editBox:ClearFocus();
    local newValue = tonumber(slider.editBox:GetText());

    if (obj:IsNumber(newValue)) then
      local sliderMin, sliderMax = slider:GetMinMaxValues();
      slider:SetValue(max(min(newValue, sliderMax), sliderMin));

      slider.editBox:SetText(newValue);
      configModule:SetDatabaseValue(slider.configContainer, newValue);
    else
      slider.editBox:SetText(slider:GetValue());
    end

    PlaySound(tk.Constants.CLICK);
  end);

  slider.editBox:SetPoint("TOP", slider, "BOTTOM", 0, -6);
  slider.editBox:SetSize(40, 20);
  tk:SetFontSize(slider.editBox, 10);
  slider.editBox:SetText(value or widgetTable.min);
  slider.editBox:DisableDrawLayer("BACKGROUND");
  slider.editBox:SetJustifyH("CENTER");
  slider.editBox:SetBackdrop(tk.Constants.BACKDROP);
  slider.editBox:SetBackdropBorderColor(tk:GetThemeColor());

  local texture = slider.editBox:CreateTexture(nil, "BORDER");
  texture:SetAllPoints(true);

  texture:SetColorTexture(0, 0, 0, 0.5);

  slider.Low:SetText(widgetTable.min);
  slider.Low:ClearAllPoints();
  slider.Low:SetPoint("BOTTOMLEFT", 9, -8);
  slider.High:SetText(widgetTable.max);
  slider.High:ClearAllPoints();
  slider.High:SetPoint("BOTTOMRIGHT", -5, -8);

  slider:SetSize(widgetTable.width or 150, 18);
  slider:SetHitRectInsets(0, 0, 0, 0);
  slider:SetScript("OnValueChanged", Slider_OnValueChanged);
  slider:SetScript("OnEnable", Slider_OnEnable);
  slider:SetScript("OnDisable", Slider_OnDisable);

  local container = Utils:CreateElementContainerFrame(slider, widgetTable, parent);
  container:SetHeight(container:GetHeight() + 28); -- make room for value text
  return container;
end