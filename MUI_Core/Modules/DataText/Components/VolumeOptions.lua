-- luacheck: ignore self GameTooltip 143 631
local MayronUI = _G.MayronUI;
local tk, _, _, _, obj, L = MayronUI:GetCoreComponents();
local CreateFrame, GetCVar, SetCVar, string = _G.CreateFrame, _G.GetCVar, _G.SetCVar, _G.string;
local tonumber = _G.tonumber;
local MASTER_VOLUME = _G.MASTER_VOLUME;
local SOUND_VOLUME = _G.SOUND_VOLUME;
local MUSIC_VOLUME = _G.MUSIC_VOLUME;
local AMBIENCE_VOLUME = _G.AMBIENCE_VOLUME;
local DIALOG_VOLUME = _G.DIALOG_VOLUME;
local MUTED = _G.MUTED;
local VOLUME = _G.VOLUME;
local UNMUTE = _G.UNMUTE;
local MUTE = _G.MUTE;
local SHOW = _G.SHOW;
local OPTIONS = _G.OPTIONS;
local ActionStatus = _G.ActionStatus;
local ActionStatus_DisplayMessage = _G.ActionStatus_DisplayMessage;

-- Register and Import Modules -------
local VolumeOptions = obj:CreateClass("VolumeOptions");

-- Local Functions ----------------
local function GetFormattedValue(text, cvarName, value)
  value = value or tonumber(GetCVar(cvarName));
  value = tk.Numbers:ToPrecision(value, 2);
  local percentage = value * 100;
  return string.format("%s (%d%%)", text, percentage), value;
end

local function Slider_OnValueChanged(self)
  local value = self:GetValue();
  local fullText, newValue = GetFormattedValue(self.text, nil, value);

  SetCVar(self.cvarName, newValue);
  self.name:SetText(fullText);

  if (self.component) then
    self.component:Update();
  end
end

local function CreateLabel(contentFrame, cvarName, text, component)
  local label = tk:PopFrame("Frame", contentFrame);
  label.customHeight = 46;

  local name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  name:SetPoint("TOP", 0, -4);
  name:SetWordWrap(false);
  name:SetJustifyH("CENTER");

  local slider = CreateFrame("Slider", nil, label, "OptionsSliderTemplate");
  slider:SetMinMaxValues(0, 1);
  slider:SetValueStep(0.01);
  slider:SetObeyStepOnDrag(true);
  slider:SetValue(0.5);

  slider:SetPoint("TOP", name, "BOTTOM", 0, -4);
  slider:SetSize(150, 18);
  slider:SetHitRectInsets(0, 0, 0, 0);

  slider.cvarName = cvarName;
  slider.text = text;
  slider.name = name;
  slider.component = component;
  slider:SetScript("OnValueChanged", Slider_OnValueChanged);

  slider.Low:SetText("0");
  slider.Low:ClearAllPoints();
  slider.Low:SetPoint("RIGHT", slider, "LEFT", -5, 0);

  slider.High:SetText("1");
  slider.High:ClearAllPoints();
  slider.High:SetPoint("LEFT", slider, "RIGHT", 5, 0);
  tk:SetBackground(label, 0, 0, 0, 0.2);

  label.name = name;
  label.slider = slider;

  return label;
end

local function button_OnEnter(self)
  local r, g, b = tk:GetThemeColor();
  GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
  GameTooltip:SetText(L["Commands"]..":");

  GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Left Click:"]),
  tk.Strings:JoinWithSpace(SHOW, VOLUME, OPTIONS), r, g, b, 1, 1, 1);

  GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Right Click:"]),
    tk.Strings:Join("", MUTE, "/", UNMUTE, " ", MASTER_VOLUME), r, g, b, 1, 1, 1);

  GameTooltip:Show();
end

local function button_OnLeave()
  GameTooltip:Hide();
end

-- Durability Module --------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
  self:RegisterComponentClass("volumeOptions", VolumeOptions);
end);

function VolumeOptions:__Construct(data, settings, dataTextModule)
  data.settings = settings;

  -- set public instance properties
  self.MenuContent = CreateFrame("Frame");
  self.MenuLabels = {};
  self.TotalLabelsShown = 5;
  self.HasLeftMenu = true;
  self.HasRightMenu = false;
  self.Button = dataTextModule:CreateDataTextButton();
end

function VolumeOptions:IsEnabled(data)
  return data.enabled;
end

function VolumeOptions:SetEnabled(data, enabled)
  data.enabled = enabled;

  if (enabled) then
    self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    self.Button:SetScript("OnEnter", button_OnEnter);
    self.Button:SetScript("OnLeave", button_OnLeave);
  else
    self.Button:RegisterForClicks("LeftButtonUp");
    self.Button:SetScript("OnEnter", nil);
    self.Button:SetScript("OnLeave", nil);
  end
end

local function UpdateLabel(label, cvarName, text)
  local fullText, value = GetFormattedValue(text, cvarName);
  label.name:SetText(fullText);
  label.slider:SetValue(value);
end

-- update total labels shown and create them
function VolumeOptions:Click(data, button)
  if (button == "LeftButton") then
    local label = self.MenuLabels[1] or CreateLabel(self.MenuContent, "Sound_MasterVolume", MASTER_VOLUME, self);
    UpdateLabel(label, "Sound_MasterVolume", MASTER_VOLUME);
    self.MenuLabels[1] = label;

    label = self.MenuLabels[2] or CreateLabel(self.MenuContent, "Sound_SFXVolume", SOUND_VOLUME);
    UpdateLabel(label, "Sound_SFXVolume", SOUND_VOLUME);
    self.MenuLabels[2] = label;

    label = self.MenuLabels[3] or CreateLabel(self.MenuContent, "Sound_MusicVolume", MUSIC_VOLUME);
    UpdateLabel(label, "Sound_MusicVolume", MUSIC_VOLUME);
    self.MenuLabels[3] = label;

    label = self.MenuLabels[4] or CreateLabel(self.MenuContent, "Sound_AmbienceVolume", AMBIENCE_VOLUME);
    UpdateLabel(label, "Sound_AmbienceVolume", AMBIENCE_VOLUME);
    self.MenuLabels[4] = label;

    label = self.MenuLabels[5] or CreateLabel(self.MenuContent, "Sound_DialogVolume", DIALOG_VOLUME);
    UpdateLabel(label, "Sound_DialogVolume", DIALOG_VOLUME);
    self.MenuLabels[5] = label;

  elseif (button == "RightButton") then
    local currentValue = tonumber(GetCVar("Sound_MasterVolume"));

    if (currentValue == 0) then
      if (tk:IsClassic()) then
        ActionStatus_DisplayMessage(tk.Strings:JoinWithSpace(MASTER_VOLUME, L["Unmuted"]));
      else
        ActionStatus:DisplayMessage(tk.Strings:JoinWithSpace(MASTER_VOLUME, L["Unmuted"]));
      end

      SetCVar("Sound_MasterVolume", data.oldValue or 1);
      data.oldValue = data.oldValue or 1;
    else
      if (tk:IsClassic()) then
        ActionStatus_DisplayMessage(tk.Strings:JoinWithSpace(MASTER_VOLUME, MUTED));
      else
        ActionStatus:DisplayMessage(tk.Strings:JoinWithSpace(MASTER_VOLUME, MUTED));
      end

      SetCVar("Sound_MasterVolume", 0);
      data.oldValue = currentValue;
    end

    self:Update();
  end
end

function VolumeOptions:Update(data, refreshSettings)
  if (refreshSettings) then
    data.settings:Refresh();
  end

  local text = GetFormattedValue(VOLUME, "Sound_MasterVolume")
  self.Button:SetText(text);
end