local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils
local configModule = MayronUI:ImportModule("ConfigMenu"); ---@type ConfigMenuModule

local min = _G.math.min;
local max = _G.math.max;
local PlaySound = _G.PlaySound;
local tonumber = _G.tonumber;

local function Slider_OnValueChanged(self, value, userset)
  if (userset) then
    local sliderMin, sliderMax = self:GetMinMaxValues();
    value = tk.Numbers:ToPrecision(value, self.precision);

    value = max(min(value, sliderMax), sliderMin);
    self:SetValue(value);
    self.editBox:SetText(value);

    local container = self:GetParent();
    configModule:SetDatabaseValue(container, value);
  end
end

local function Slider_Reset(self, value)
  self:SetValue(value);
  self.editBox:SetText(value);
end

local function Slider_OnEnable(self)
  self:SetAlpha(1);
  self.editBox:SetEnabled(true);
end

local function Slider_OnDisable(self)
    self:SetAlpha(0.7);
    self.editBox:SetEnabled(false);
end

local function SliderEditBox_OnEnterPressed(editBox)
  editBox:ClearFocus();

  local newValue = tonumber(editBox:GetText());
  local slider = editBox:GetParent();

  if (obj:IsNumber(newValue)) then
    local sliderMin, sliderMax = slider:GetMinMaxValues();
    slider:SetValue(max(min(newValue, sliderMax), sliderMin));

    editBox:SetText(newValue);

    local container = slider:GetParent();
    configModule:SetDatabaseValue(container, newValue);
  else
    editBox:SetText(slider:GetValue());
  end

  PlaySound(tk.Constants.CLICK);
end

local function SliderEditBox_OnEscapePressed(editBox)
  editBox:ClearFocus();

  local slider = editBox:GetParent();
  editBox:SetText(slider:GetValue());
end

function Components.slider(parent, config, value)
  local slider = tk:CreateFrame("Slider", parent, nil, "OptionsSliderTemplate");

  tk:KillElement(slider.NineSlice);
  local bg = tk:SetBackground(slider, 0, 0, 0, 0.5);
  bg:ClearAllPoints();
  bg:SetPoint("LEFT");
  bg:SetPoint("RIGHT");
  bg:SetHeight(8);

  slider.precision = config.precision or 1; -- at most 1 decimal place
  Utils:SetBasicTooltip(slider, config);

  -- widgetTable gets cleaned
  local maxValue = config.max or 1;
  local minValue = config.min or 0;

  obj:Assert(maxValue > minValue,
    "Failed to create slider %s - max value %s is less than or equal to min value %s.", 
    config.name, maxValue, minValue);

  local step = config.step or ((maxValue - minValue) / (config.steps or 10));

  slider:DisableDrawLayer("BORDER");
  slider:SetMinMaxValues(minValue, maxValue);
  slider:SetValueStep(step or 1);
  slider:SetObeyStepOnDrag(true);
  slider:SetValue(value or minValue);
  slider:SetThumbTexture(tk:GetAssetFilePath("Textures\\Widgets\\SliderThumb"));
  slider:GetThumbTexture():SetSize(14, 24);

  local template = _G.BackdropTemplateMixin and "BackdropTemplate, InputBoxTemplate" or "InputBoxTemplate";
  slider.editBox = tk:CreateFrame("EditBox", slider, nil, template);
  slider.editBox:SetAutoFocus(false);

  slider.editBox:SetScript("OnEscapePressed", SliderEditBox_OnEscapePressed);
  slider.editBox:SetScript("OnEnterPressed", SliderEditBox_OnEnterPressed);

  slider.editBox:SetPoint("TOP", slider, "BOTTOM", 0, -6);
  slider.editBox:SetSize(40, 20);
  tk:SetFontSize(slider.editBox, 10);
  slider.editBox:SetText(value or minValue);
  slider.editBox:DisableDrawLayer("BACKGROUND");
  slider.editBox:SetJustifyH("CENTER");
  slider.editBox:SetBackdrop(tk.Constants.BACKDROP);
  slider.editBox:SetBackdropBorderColor(tk:GetThemeColor());

  local texture = slider.editBox:CreateTexture(nil, "BORDER");
  texture:SetAllPoints(true);
  texture:SetColorTexture(0, 0, 0, 0.5);

  slider.Low:SetText(minValue);
  slider.Low:ClearAllPoints();
  slider.Low:SetPoint("BOTTOMLEFT", 9, -8);
  slider.High:SetText(maxValue);
  slider.High:ClearAllPoints();
  slider.High:SetPoint("BOTTOMRIGHT", -5, -8);

  slider:SetSize(config.width or 150, 18);
  slider:SetHitRectInsets(0, 0, 0, 0);
  slider:SetScript("OnValueChanged", Slider_OnValueChanged);
  slider:SetScript("OnEnable", Slider_OnEnable);
  slider:SetScript("OnDisable", Slider_OnDisable);

  slider.Reset = Slider_Reset;

  Utils:SetComponentEnabled(slider, config.enabled);

  local container = Utils:WrapInNamedContainer(slider, config);
  container:SetHeight(container:GetHeight() + 28); -- make room for value text

  Utils:SetShown(container, config.shown);
  return container;
end