-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
namespace.import = {};

local _G = _G;
local MayronUI, table, pairs = _G.MayronUI, _G.table, _G.pairs;
local tk, db, _, gui, obj, L = MayronUI:GetCoreComponents();
local Private = {};
local mediaFolder = "Interface\\AddOns\\MUI_Setup\\media\\";

local tabText = {
  -- This should use the locales!
  L["INSTALL"]; L["CUSTOM INSTALL"]; L["INFORMATION"]; L["CREDITS"];
};

local RELOAD_MESSAGE = tk.Strings:SetTextColorByTheme(L["Warning:"]).." "..L["This will reload the UI!"];

local tabNames = {
  [L["INSTALL"]] = "Install";
  [L["CUSTOM INSTALL"]] = "Custom";
  [L["INFORMATION"]] = "Info";
  [L["CREDITS"]] = "Credits";
};

local PlaySoundFile, SetCVar, SetChatWindowSize, UIFrameFadeIn, C_Timer,
      UIFrameFadeOut, PlaySound, IsAddOnLoaded, unpack, math, GetAddOnMetadata, string =
  _G.PlaySoundFile, _G.SetCVar, _G.SetChatWindowSize, _G.UIFrameFadeIn, _G.C_Timer, _G.UIFrameFadeOut,
  _G.PlaySound, _G.IsAddOnLoaded, _G.unpack, _G.math, _G.GetAddOnMetadata, _G.string;

local ipairs, strsplit, strjoin, strtrim, ReloadUI, DisableAddOn = _G.ipairs,
  _G.strsplit, _G.strjoin, _G.strtrim, _G.ReloadUI, _G.DisableAddOn;

-- Setup Objects -------------------------

local Panel = obj:Import("MayronUI.Panel");

-- Register and Import Modules -----------

local SetUpModule = MayronUI:RegisterModule("SetUpModule", L["Setup"]);
local module = MayronUI:ImportModule("SetUpModule");

-- Local Functions -----------------------

local function ChangeTheme(_, classFileName)
  if (classFileName) then
    tk:UpdateThemeColor(classFileName);
  elseif (db.profile.theme) then
    local value = db.profile.theme.color:GetUntrackedTable();
    tk:UpdateThemeColor(value);
  else
    return
  end

  local window = module:GetWindow();
  local r, g, b = tk:GetThemeColor();
  local frame = window:GetFrame()--[[@as MayronUI.GridTextureMixin|table]];
  tk:ApplyThemeColor(frame.titleBar.bg, frame.closeBtn);
  tk:ApplyThemeColor(0.5, unpack(window.tabs));

  local customTabDialog = window.tabDialogBox["Custom"];

  if (customTabDialog) then
    -- resets color
    customTabDialog.themeDropdown:ApplyThemeColor();
    customTabDialog.chooseProfileDropDown:ApplyThemeColor();
    customTabDialog.profilePerCharacter:ApplyThemeColor();
    customTabDialog.resetChatBtn:ApplyThemeColor();

    for _, cb in ipairs(customTabDialog.addOnCheckBoxes) do
      cb:ApplyThemeColor();
    end

    customTabDialog.applyScaleBtn:ApplyThemeColor();
    customTabDialog.installButton:ApplyThemeColor();
    customTabDialog.deleteProfileButton:ApplyThemeColor();
    customTabDialog.newProfileButton:ApplyThemeColor();
  end

  local instalDialogBox = window.tabDialogBox["Install"];

  if (instalDialogBox) then
    instalDialogBox.installButton:ApplyThemeColor();
    RELOAD_MESSAGE = tk.Strings:SetTextColorByTheme(L["Warning:"]).." "..L["This will reload the UI!"];
    instalDialogBox.message:SetText(RELOAD_MESSAGE);
  end

  for _, tabName in pairs(tabNames) do
    local menu = window.tabDialogBox[tabName];
    if (menu and menu.scrollBar) then
      menu.scrollBar.thumb:SetColorTexture(r, g, b);
    end
  end
end

-- first argument is the dropdown menu self reference
local function ChangeProfile(_, profileName)
  local window = module:GetWindow();

  if (window) then
    db:SetProfile(profileName);
    ChangeTheme();
  end
end

local function ExpandSetupWindow()
  local window = module:GetWindow();
  local width, height = window:GetSize();

  if (width >= 900 and height >= 540) then
    return
  end

  window:SetSize(width + 20, height + 12);
  C_Timer.After(0.02, ExpandSetupWindow);
end

local function OnMenuTabButtonClick(self)
  local window = module:GetWindow();
  local dialogFrame = window.tabDialogBox --[[@as MayronUI.GridTextureMixin]]; -- the tab wrapper frame with the dialog box texture

  if (self:GetChecked()) then
    if (dialogFrame.activeTabChildFrame) then
      dialogFrame.activeTabChildFrame:Hide();
    end

    local tabName = tabNames[self:GetText()];
    if (not dialogFrame[tabName]) then
      local tabContentFrame = tk:CreateFrame("Frame", dialogFrame);
      tabContentFrame:SetAllPoints(true);
      dialogFrame[tabName] = Private["Load" .. tabName .. "Menu"](Private, tabContentFrame);
    end

    dialogFrame[tabName]:Show();
    dialogFrame.activeTabChildFrame = dialogFrame[tabName];

    if (not window.expanded) then
      C_Timer.After(0.02, ExpandSetupWindow);
      dialogFrame:SetGridBlendMode("BLEND");
      UIFrameFadeIn(dialogFrame, 0.4, dialogFrame:GetAlpha(), 1);
      UIFrameFadeOut(window.banner.left, 0.4, window.banner.left:GetAlpha(), 0.3);
      UIFrameFadeOut(window.banner.right, 0.4, window.banner.right:GetAlpha(), 0.3);
      window.expanded = true;
    end
  end

  PlaySound(tk.Constants.CLICK);
end

-- Private Functions ---------------------------

function Private:LoadInstallMenu(tabFrame)
  tabFrame.message = tabFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
  tabFrame.message:SetPoint("CENTER", 0, 20);
  tabFrame.message:SetText(RELOAD_MESSAGE);

  tabFrame.installButton = gui:CreateButton(tabFrame, L["INSTALL"], nil, nil, nil, 200);
  tabFrame.installButton:SetPoint("CENTER", 0, -20);
  tabFrame.installButton:SetScript("OnClick", function() module:Install(); end);
  return tabFrame;
end

function Private:LoadProfileMenu(tabFrame)
  tabFrame.profileTitle = tabFrame:CreateFontString(
    nil, "ARTWORK", "GameFontHighlightLarge");
  tabFrame.profileTitle:SetPoint(
    "TOPLEFT", tabFrame.themeDropdown:GetFrame(), "BOTTOMLEFT", 0, -20);
  tabFrame.profileTitle:SetText(L["Choose Profile:"]);

  tabFrame.chooseProfileDropDown = gui:CreateDropDown(tabFrame);
  tabFrame.chooseProfileDropDown:SetLabel(db:GetCurrentProfile());
  tabFrame.chooseProfileDropDown:SetPoint(
    "TOPLEFT", tabFrame.profileTitle, "BOTTOMLEFT", 0, -10);

  for _, name, _ in db:IterateProfiles() do
    tabFrame.chooseProfileDropDown:AddOption(name, ChangeProfile, name);
  end

  tabFrame.newProfileButton = gui:CreateButton(tabFrame, L["New Profile"]);
  tabFrame.newProfileButton:SetPoint(
    "TOPLEFT", tabFrame.chooseProfileDropDown:GetFrame(), "BOTTOMLEFT", 0, -20);

  tabFrame.newProfileButton:SetScript("OnClick", function()
    MayronUI:TriggerCommand("profile", "new", nil, function()
      local currentProfile = db:GetCurrentProfile();
      tabFrame.chooseProfileDropDown:SetLabel(currentProfile);
      tabFrame.chooseProfileDropDown:AddOption(currentProfile, function()
        ChangeProfile(nil, currentProfile);
        tabFrame.deleteProfileButton:SetEnabled(currentProfile ~= "Default");
      end);
    end);
  end);

  tabFrame.deleteProfileButton = gui:CreateButton(tabFrame, L["Delete Profile"]);
  tabFrame.deleteProfileButton:SetPoint(
    "TOPLEFT", tabFrame.newProfileButton, "BOTTOMLEFT", 0, -20);
  tabFrame.deleteProfileButton:SetEnabled(
    db:GetCurrentProfile() ~= "Default");

  tabFrame.deleteProfileButton:SetScript("OnClick", function()
    local profileName = db:GetCurrentProfile();

    MayronUI:TriggerCommand("profile", "delete", profileName, function()
      local currentProfile = db:GetCurrentProfile();
      tabFrame.chooseProfileDropDown:RemoveOptionByLabel(profileName);
      tabFrame.chooseProfileDropDown:SetLabel(currentProfile);
      tabFrame.deleteProfileButton:SetEnabled(currentProfile ~= "Default");
    end);
  end);

  tabFrame.profilePerCharacter = gui:CreateCheckButton(
    tabFrame, L["Profile Per Character"],
    L["If enabled, new characters will be assigned a unique character profile instead of the Default profile."]);

  tabFrame.profilePerCharacter:SetPoint(
    "TOPLEFT", tabFrame.deleteProfileButton, "BOTTOMLEFT", 0, -20);

  tabFrame.profilePerCharacter.btn:SetChecked(
    db.global.core.setup.profilePerCharacter);

  tabFrame.profilePerCharacter.btn:SetScript("OnClick", function(self)
    local checked = self:GetChecked();
    db:SetPathValue("global.core.setup.profilePerCharacter", checked);

    if (checked) then
      local profileName = tk:GetPlayerKey();
      local foundLabel = tabFrame.chooseProfileDropDown:GetOptionByLabel(profileName);

      if (not foundLabel) then
        tabFrame.chooseProfileDropDown:AddOption(profileName, function()
          tabFrame.deleteProfileButton:SetEnabled(profileName ~= "Default");
          ChangeProfile(nil, profileName);
        end);
      end

      tabFrame.chooseProfileDropDown:SetLabel(profileName);
      tabFrame.deleteProfileButton:SetEnabled(true);
      ChangeProfile(nil, profileName);
    else
      tabFrame.chooseProfileDropDown:SetLabel("Default");
      tabFrame.deleteProfileButton:SetEnabled(false);
      ChangeProfile(nil, "Default");
    end
  end);
end

function Private:LoadThemeMenu(tabFrame)
  tabFrame.themeTitle = tabFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
  tabFrame.themeTitle:SetPoint("TOPLEFT", 20, -20);
  tabFrame.themeTitle:SetText(L["Choose Theme:"]);

  tabFrame.themeDropdown = gui:CreateDropDown(tabFrame);
  local classFileNames = tk.Tables:GetKeys(tk.Constants.CLASS_FILE_NAMES);
  table.sort(classFileNames);

  local optionsTable = obj:PopTable();
  for _, classFileName in ipairs(classFileNames) do
    local text = tk:GetLocalizedClassNameByFileName(classFileName, true);
    local option = obj:PopTable(text, classFileName);
    table.insert(optionsTable, option);
  end

  obj:PushTable(classFileNames);

  tabFrame.themeDropdown:AddOptions(ChangeTheme, optionsTable);

  local ColorPickerFrame = _G.ColorPickerFrame;
  tabFrame.themeDropdown:AddOption("Custom Color", function()
    local colors = {};
    ColorPickerFrame:SetColorRGB(1, 1, 1);
    ColorPickerFrame.previousValues = { 1; 1; 1; 0 };

    ColorPickerFrame.func = function()
      colors.r, colors.g, colors.b = ColorPickerFrame:GetColorRGB();
      colors.hex = string.format("%02x%02x%02x", colors.r * 255, colors.g * 255, colors.b * 255);
      ChangeTheme(nil, colors);
    end

    ColorPickerFrame.cancelFunc = function(values)
      colors.r, colors.g, colors.b = unpack(values);
      colors.hex = string.format("%02x%02x%02x", colors.r * 255, colors.g * 255, colors.b * 255);
      ChangeTheme(nil, colors);
    end

    ColorPickerFrame:Hide(); -- run OnShow
    ColorPickerFrame:Show();
  end);

  tabFrame.themeDropdown:SetLabel(L["Theme"]);
  tabFrame.themeDropdown:SetPoint("TOPLEFT", tabFrame.themeTitle, "BOTTOMLEFT", 0, -10);
end

function Private:LoadCustomMenu(tabFrame)
  self:LoadThemeMenu(tabFrame);
  self:LoadProfileMenu(tabFrame);

  -- UI Scale
  tabFrame.scaleTitle = tabFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
  tabFrame.scaleTitle:SetPoint("TOPLEFT", tabFrame.themeTitle, "TOPRIGHT", 150, 0);
  tabFrame.scaleTitle:SetText(L["Adjust the UI Scale:"]);
  tabFrame.scaleTitle:SetWidth(200);
  tabFrame.scaleTitle:SetJustifyH("LEFT");

  tabFrame.scaler = tk:CreateFrame("Slider", tabFrame, nil, "OptionsSliderTemplate");
  tabFrame.scaler:SetPoint("TOPLEFT", tabFrame.scaleTitle, "BOTTOMLEFT", 0, -10);
  tabFrame.scaler:SetWidth(200);

  tabFrame.scaler.tooltipText = L["This will ensure that frames are correctly positioned to match the UI scale during installation."];

  tabFrame.scaler:SetMinMaxValues(0.6, 1.2);
  tabFrame.scaler:SetValueStep(0.05);
  tabFrame.scaler:SetObeyStepOnDrag(true);
  tabFrame.scaler:SetValue(db.global.core.uiScale);

  tabFrame.scaler.Low:SetText(0.6);
  tabFrame.scaler.Low:ClearAllPoints();
  tabFrame.scaler.Low:SetPoint("BOTTOMLEFT", 5, -8);
  tabFrame.scaler.High:SetText(1.2);
  tabFrame.scaler.High:ClearAllPoints();
  tabFrame.scaler.High:SetPoint("BOTTOMRIGHT", -5, -8);

  tabFrame.scaler.Value = tabFrame.scaler:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
  tabFrame.scaler.Value:SetPoint("BOTTOM", 0, -8);
  tabFrame.scaler.Value:SetText(db.global.core.uiScale);

  tabFrame.applyScaleBtn = gui:CreateButton(tabFrame, L["Apply Scaling"]);

  tabFrame.applyScaleBtn:SetPoint("TOPLEFT", tabFrame.scaler, "BOTTOMLEFT", 0, -20);
  tabFrame.applyScaleBtn:Disable();

  tabFrame.applyScaleBtn:SetScript("OnClick", function(self)
    self:Disable();
    SetCVar("useUiScale", "1");
    SetCVar("uiscale", db.global.core.uiScale);
  end);

  tabFrame.scaler:SetScript("OnValueChanged", function(self, value)
    value = math.floor((value * 100) + 0.5) / 100;
    self.Value:SetText(value);
    db.global.core.uiScale = value;
    tabFrame.applyScaleBtn:Enable();
  end);

  tabFrame.resetChatBtn = gui:CreateCheckButton(
    tabFrame, L["Reset Chat Settings"], L["RESET_CHAT_SETTINGS_TOOLTIP"]);

  tabFrame.resetChatBtn:SetPoint("TOPLEFT", tabFrame.applyScaleBtn, "BOTTOMLEFT", 0, -20);
  tabFrame.resetChatBtn.btn:SetChecked(db.global.core.setup.resetChatSettings);

  tabFrame.resetChatBtn.btn:SetScript("OnClick", function(self)
    db.global.core.setup.resetChatSettings = self:GetChecked();
  end);

  -- AddOn Settings to Inject
  tabFrame.injectTitle = tabFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
  tabFrame.injectTitle:SetPoint("TOPLEFT", tabFrame.scaleTitle, "TOPRIGHT", 50, 0);
  tabFrame.injectTitle:SetText(L["MayronUI AddOn Presets"]);
  tabFrame.injectTitle:SetWidth(320);
  tabFrame.injectTitle:SetJustifyH("LEFT");

  tabFrame.injectDescription = tabFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
  tabFrame.injectDescription:SetPoint("TOPLEFT", tabFrame.injectTitle, "BOTTOMLEFT", 0, -5);
  tabFrame.injectDescription:SetWidth(320);
  tabFrame.injectDescription:SetText(
    L["The following selected addons will have their settings reset to the MayronUI preset settings:"])
  tabFrame.injectDescription:SetJustifyH("LEFT");

  local previous;
  local addonsFrame = tk:CreateFrame("Frame", tabFrame);
  tabFrame.addonContainer = gui:WrapInScrollFrame(addonsFrame);
  tabFrame.addonContainer:SetPoint("TOPLEFT", tabFrame.injectDescription, "BOTTOMLEFT", 0, -20);
  tabFrame.addonContainer:SetPoint("BOTTOMRIGHT", -20, 70);

  gui:AddDialogTexture(tabFrame.addonContainer, "Low");

  local totalAddOnsLoaded = 0;
  tabFrame.addOnCheckBoxes = obj:PopTable();

  local loadedAddOns = {}; -- for some reason, an addon might be shown more than once
  for id, addOnData in db.global.core.setup.addOns:Iterate() do
    local alias, value, addOnName = unpack(addOnData);

    if (IsAddOnLoaded(addOnName) and not loadedAddOns[addOnName]) then
      local cb = gui:CreateCheckButton(addonsFrame, alias);
      totalAddOnsLoaded = totalAddOnsLoaded + 1;

      cb.btn:SetChecked(value);
      cb.btn:SetScript("OnClick", function(self)
        db.global.core.setup.addOns[id] = obj:PopTable(alias, self:GetChecked(), addOnName);
      end);

      if (not previous) then
        cb:SetPoint("TOPLEFT", addonsFrame, "TOPLEFT", 10, -10);
      else
        cb:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -10);
      end

      addonsFrame:SetHeight(addonsFrame:GetHeight() + cb:GetHeight() + 10);
      table.insert(tabFrame.addOnCheckBoxes, cb);
      previous = cb;
      loadedAddOns[addOnName] = true;
    end
  end

  if (totalAddOnsLoaded == 0) then
    local fontString = tabFrame.addonContainer:CreateFontString(
      nil, "ARTWORK", "GameFontHighlightLarge");

    fontString:SetPoint("CENTER");
    fontString:SetText(L["No Supported AddOns Loaded"]);
  end

  -- install button
  tabFrame.installButton = gui:CreateButton(tabFrame, L["INSTALL"], nil, nil, nil, 200);
  tabFrame.installButton:SetPoint("TOPRIGHT", tabFrame.addonContainer, "BOTTOMRIGHT", 0, -20);

  tabFrame.installButton:SetScript("OnClick", function() module:Install() end);

  local GameTooltip = _G.GameTooltip;
  tabFrame.installButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 18, 4);
    GameTooltip:AddLine(RELOAD_MESSAGE);
    GameTooltip:SetFrameLevel(30);
    GameTooltip:Show();
  end);

  tabFrame.installButton:SetScript("OnLeave", tk.HandleTooltipOnLeave);
  return tabFrame;
end

function Private:LoadInfoMenu(scrollChild)
  local font = tk:GetMasterFont();

  local scrollFrame, scrollBar = gui:WrapInScrollFrame(scrollChild);
  scrollChild.scrollBar = scrollBar;

  scrollChild:SetHeight(300);
  scrollFrame:SetPoint("TOPLEFT", 20, -20);
  scrollFrame:SetPoint("BOTTOMRIGHT", -20, 20);

  scrollFrame.bg = tk:SetBackground(scrollFrame, 0, 0, 0, 0.5);
  scrollFrame.bg:ClearAllPoints();
  scrollFrame.bg:SetPoint("TOPLEFT", -10, 10);
  scrollFrame.bg:SetPoint("BOTTOMRIGHT", 10, -10);

  local content = tk:CreateFrame("EditBox", scrollChild);
  content:SetMultiLine(true);
  content:SetMaxLetters(99999);
  content:EnableMouse(true);
  content:SetAutoFocus(false);
  content:SetFontObject("GameFontHighlight");
  content:SetFont(font, 13, "");
  content:SetAllPoints(true);
  content:SetText(Private.info);

  content:SetScript("OnEscapePressed", function(self)
    self:ClearFocus();
  end);

  content:SetScript("OnTextChanged", function(self)
    self:SetText(Private.info);
  end);

  return scrollFrame;
end

function Private:LoadCreditsMenu(scrollChild)
  local font = tk:GetMasterFont();

  local scrollFrame, scrollBar = gui:WrapInScrollFrame(scrollChild);
  scrollChild.scrollBar = scrollBar;

  scrollChild:SetHeight(700); -- can't use GetStringHeight
  scrollFrame:SetPoint("TOPLEFT", 20, -20);
  scrollFrame:SetPoint("BOTTOMRIGHT", -20, 20);

  scrollFrame.bg = tk:SetBackground(scrollFrame, 0, 0, 0, 0.5);
  scrollFrame.bg:ClearAllPoints();
  scrollFrame.bg:SetPoint("TOPLEFT", -10, 10);
  scrollFrame.bg:SetPoint("BOTTOMRIGHT", 10, -10);

  local content = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  content:SetWordWrap(true);
  content:SetAllPoints(true);
  content:SetJustifyH("LEFT");
  content:SetJustifyV("TOP");
  content:SetText(Private.credits);
  content:SetFont(font, 13); -- font size should be added to config and profile
  content:SetSpacing(6);

  return scrollFrame;
end

-- C_SetUpModule -----------------------
local function GetInfoLinks(...)
  local links = obj:PopTable(...);

  for i, name in ipairs(links) do
    links[i] = ("|cffffff9a%s|r"):format(GetAddOnMetadata("MUI_Core", name));
  end

  return obj:UnpackTable(links);
end

local function GetCreditsSections(...)
  local sections = obj:PopTable(...);

  for s, sectionName in ipairs(sections) do
    local names = (GetAddOnMetadata("MUI_Core", sectionName));
    names = obj:PopTable(strsplit(",", names))

    for i, name in ipairs(names) do
      names[i] = string.format(
        "|TInterface\\Challenges\\ChallengeMode_Medal_Gold:18:18:0:-4|t %s",
          strtrim(name));
    end

    sections[s] = strjoin("\n", unpack(names));
    obj:PushTable(names);
  end

  return obj:UnpackTable(sections);
end

function SetUpModule:OnInitialize()
  self:Show();
end

function SetUpModule:Show(data)
  if (_G.InCombatLockdown()) then
    tk:Print(L["Cannot install while in combat."]);

    if (data.window) then
      data.window:Hide();
    end

    return
  end

  if (data.window) then
    data.window:Show();
    UIFrameFadeIn(data.window, 0.3, 0, 1);
    return
  end

  Private.info = L["MUI_Setup_InfoTab"]:format(
    GetInfoLinks("X-Discord", "X-Home-Page", "X-GitHub-Repo", "X-Patreon", "X-YouTube"));

  Private.credits = L["MUI_Setup_CreditsTab"]:format(
    GetCreditsSections(
      "X-Patrons", "X-Development-and-Bug-Fixes",
      "X-Translation-Support", "X-Community-Support-Team"));

  local windowFrame = tk:CreateFrame("Frame", nil, "MUI_Setup");
  local window = gui:AddDialogTexture(windowFrame, "High");
  window:SetSize(750, 485);
  window:SetPoint("CENTER");
  window:SetFrameStrata("DIALOG");
  window:RegisterEvent("PLAYER_REGEN_DISABLED");
  window:SetScript("OnEvent", function(self)
    self:Hide();
    tk:Print(L["Cannot install while in combat."]);
  end);

  if (tk:IsLocale("itIT")) then
    window:SetSize(900, 582);
  end

  gui:AddTitleBar(window, L["Setup Menu"]);
  gui:AddCloseButton(window);

  window.bg = tk:SetBackground(window, 0, 0, 0, 0.8); -- was 0.8 but set to 0.2 for testing
  window.bg:SetDrawLayer("BACKGROUND", -5);
  window.bg:SetAllPoints(_G.UIParent);

  -- turn window frame into a Panel
  window = Panel(window);
  window:SetDevMode(false); -- shows or hides panel cell backgrounds used for arranging content
  window:SetDimensions(1, 3);
  window:GetRow(1):SetFixed(60);
  window:GetRow(3):SetFixed(70);
  window.menu = window:CreateCell();
  window.menu:SetInsets(25, 8, 8, 8);

  window.banner = window:CreateCell();
  window.banner:SetInsets(4, 4);

  local bannerFrame = window.banner:GetFrame();

  window.banner.left = window.banner:CreateTexture(nil, "OVERLAY");
  window.banner.left:SetTexture(mediaFolder.."banner-left");
  window.banner.left:SetPoint("TOPLEFT", -4, 0);
  window.banner.left:SetPoint("BOTTOMLEFT", -4, 0);
  window.banner.left:SetPoint("RIGHT", bannerFrame, "CENTER");

  window.banner.right = window.banner:CreateTexture(nil, "OVERLAY");
  window.banner.right:SetTexture(mediaFolder.."banner-right");
  window.banner.right:SetPoint("TOPRIGHT", 4, 0);
  window.banner.right:SetPoint("BOTTOMRIGHT", 4, 0);
  window.banner.right:SetPoint("LEFT", bannerFrame, "CENTER");

  window.info = window:CreateCell();
  window.info:SetInsets(15, 20);

  local title = window.info:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
  title:SetText("MAYRONUI");
  title:SetPoint("TOPLEFT");
  tk:SetFontSize(title, 22);

  local version = window.info:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
  version:SetText(L["VERSION"].." "..tk:GetVersion("YELLOW"));
  version:SetPoint("TOPLEFT");
  version:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 2, 0);
  tk:SetFontSize(version, 12);

  local frame = tk:CreateFrame("Frame", bannerFrame);
  window.tabDialogBox = gui:AddDialogTexture(frame, nil, 15);
  window.tabDialogBox:SetGridAlphaType("None");
  window.tabDialogBox:SetPoint("TOPLEFT", 0, -5);
  window.tabDialogBox:SetPoint("BOTTOMRIGHT", 0, 5);

  -- menu buttons:
  local tabs = {};

  for i, text in ipairs(tabText) do
    local tab = tk:CreateFrame("CheckButton", window.menu:GetFrame(), ("MUI_SetupTab%d"):format(i));
    tab:SetNormalFontObject("GameFontHighlight");
    tab:SetText(text);
    tab:SetCheckedTexture(1);
    tab:SetHighlightTexture(1);
    tab:GetFontString():SetDrawLayer("OVERLAY")
    tab:SetSize(tab:GetFontString():GetWidth() + 50, 30);
    tab:SetScript("OnClick", OnMenuTabButtonClick);

    if (i == 1) then
      tab:SetPoint("LEFT");
    else
      tab:SetPoint("LEFT", tabs[i - 1], "RIGHT", 30, 0);
    end

    tabs[i] = tab;
  end

  tk:ApplyThemeColor(0.5, unpack(tabs));
  tk:GroupCheckButtons(tabs, false);

  window:AddCells(window.menu, window.banner, window.info);
  data.window = window;
  data.window.tabs = tabs;
  UIFrameFadeIn(data.window, 0.3, 0, 1);
end

local function ApplyMayronUIConsoleVariableDefaults()
  SetCVar("ScriptErrors", "1");
  SetCVar("chatStyle", "classic");
  SetCVar("chatClassColorOverride", "0"); -- chat class colors
  SetCVar("floatingCombatTextCombatDamage", "1");
  SetCVar("floatingCombatTextCombatHealing", "1");
  SetCVar("nameplateMaxDistance", 41);
  SetCVar("useUiScale", "1");
  SetCVar("uiscale", db.global.core.uiScale);
end

local ApplyMayronUIChatFrameDefaults;
do
  local FCF_ResetChatWindows = _G.FCF_ResetChatWindows;
  local VoiceTranscriptionFrame_UpdateVisibility = _G.VoiceTranscriptionFrame_UpdateVisibility;
  local VoiceTranscriptionFrame_UpdateVoiceTab = _G.VoiceTranscriptionFrame_UpdateVoiceTab;
  local VoiceTranscriptionFrame_UpdateEditBox = _G.VoiceTranscriptionFrame_UpdateEditBox;
  local FCF_StopDragging = _G.FCF_StopDragging;
  local ToggleChatColorNamesByClassGroup = _G.ToggleChatColorNamesByClassGroup;
  local CHAT_CONFIG_CHAT_LEFT = _G.CHAT_CONFIG_CHAT_LEFT;
  local FCF_SetLocked = _G.FCF_SetLocked;
  local EditModeManagerFrame = _G.EditModeManagerFrame;
  local FCF_SetWindowName = _G.FCF_SetWindowName;
  local FCF_SetWindowColor = _G.FCF_SetWindowColor;
  local FCF_SetWindowAlpha = _G.FCF_SetWindowAlpha;
  local C_EditMode = _G.C_EditMode;

  local function GetPresetLayoutInfo()
    local layouts = EditModeManagerFrame:GetLayouts();

    for _, layoutInfo in ipairs(layouts) do
      if (layoutInfo.layoutType == 0) then
        return layoutInfo;
      end
    end

    return layouts[1];
  end

  local function GetMayronUILayoutIndex()
    local layoutsInfo = EditModeManagerFrame:GetLayouts();

    for index, layoutInfo in ipairs(layoutsInfo) do
      if (layoutInfo.layoutName == "MayronUI") then
        return index;
      end
    end

    return 0;
  end

  local function SetHighestLayoutIndexByType(layoutType)
    local layouts = EditModeManagerFrame:GetLayouts();
    local highest = 0;

    for index, layoutInfo in ipairs(layouts) do
      if (layoutInfo.layoutType == layoutType and highest < index) then
        highest = index;
      end
    end

    EditModeManagerFrame.highestLayoutIndexByType = {};

    if (highest > 0) then
      EditModeManagerFrame.highestLayoutIndexByType[layoutType] = highest;
    end
  end

  local function SetMayronUILayout()
    local activeLayoutName = EditModeManagerFrame:GetActiveLayoutInfo().layoutName;

    if (activeLayoutName ~= "MayronUI") then
      -- check if there is one:
      if (GetMayronUILayoutIndex() == 0) then
        -- create it
        local preset = GetPresetLayoutInfo();
        local newLayoutInfo = tk.Tables:Copy(preset);
        local layoutType = _G.Enum.EditModeLayoutType.Account;
        SetHighestLayoutIndexByType(layoutType);
        EditModeManagerFrame:MakeNewLayout(newLayoutInfo, layoutType, "MayronUI");
      end

      local muiLayoutIndex = GetMayronUILayoutIndex();
      C_EditMode.SetActiveLayout(muiLayoutIndex);
    end
  end

  function ApplyMayronUIChatFrameDefaults()
    local resetChat = db.global.core.setup.resetChatSettings;

    if (resetChat) then
      FCF_ResetChatWindows();

      -- Create social
      local socialTab = _G.FCF_OpenNewWindow(_G.SOCIAL_LABEL or "Social");
      _G.ChatFrame_RemoveAllMessageGroups(socialTab);

      for _, group in ipairs({
        "SAY", "WHISPER", "BN_WHISPER", "PARTY", "PARTY_LEADER", "RAID",
        "RAID_LEADER", "RAID_WARNING", "INSTANCE_CHAT",
        "INSTANCE_CHAT_LEADER", "GUILD", "OFFICER", "ACHIEVEMENT",
        "GUILD_ACHIEVEMENT", "COMMUNITIES_CHANNEL", "SYSTEM", "TARGETICONS"
      }) do
          _G.ChatFrame_AddMessageGroup(socialTab, group);
        end

      -- Create Loot
      local lootTab = _G.FCF_OpenNewWindow(_G.LOOT or "Loot");
      _G.ChatFrame_RemoveAllMessageGroups(lootTab);

      for _, group in ipairs({"LOOT", "CURRENCY", "MONEY", "SYSTEM", "COMBAT_FACTION_CHANGE"}) do
        _G.ChatFrame_AddMessageGroup(lootTab, group);
      end
    end

    local editModeIsAvailable = tk:IsRetail() and
    obj:IsTable(EditModeManagerFrame) and
    obj:IsFunction(EditModeManagerFrame.GetActiveLayoutInfo);

    if (editModeIsAvailable) then
      SetMayronUILayout();
    end

    for _, name in ipairs(_G.CHAT_FRAMES) do
      local chatFrame = _G[name];
      local id = chatFrame:GetID();

      SetChatWindowSize(id, 13);
      FCF_SetWindowAlpha(chatFrame, 0);
      FCF_SetWindowColor(chatFrame, 0, 0, 0);

      if (id == 1) then
        FCF_SetLocked(chatFrame, 1); -- required for the older system

        chatFrame:SetMovable(true);
        chatFrame:SetUserPlaced(true);
        chatFrame:SetClampedToScreen(false);
        chatFrame:ClearAllPoints();

        if (db.profile.chat) then
          if (db.profile.chat.chatFrames["TOPLEFT"].enabled) then
            chatFrame:SetPoint("TOPLEFT", _G.UIParent, "TOPLEFT", 34, -55);

          elseif (db.profile.chat.chatFrames["BOTTOMLEFT"].enabled) then
            chatFrame:SetPoint("BOTTOMLEFT", _G.UIParent, "BOTTOMLEFT", 34, 30);

          elseif (db.profile.chat.chatFrames["TOPRIGHT"].enabled) then
            chatFrame:SetPoint("TOPRIGHT", _G.UIParent, "TOPRIGHT", -34, -55);

          elseif (db.profile.chat.chatFrames["BOTTOMRIGHT"].enabled) then
            chatFrame:SetPoint("BOTTOMRIGHT", _G.UIParent, "BOTTOMRIGHT", 34, -30);
          end
        end

        chatFrame:SetWidth(375);
        chatFrame:SetHeight(240);
        FCF_StopDragging(chatFrame); -- for the older system

        if (editModeIsAvailable) then
          -- dragonflight:
          chatFrame:EditMode_OnResized();
          EditModeManagerFrame:OnSystemPositionChange(chatFrame);
          --EditModeManagerFrame:SaveLayouts(); -- this was causing some bugs for people
          C_EditMode.SaveLayouts(EditModeManagerFrame.layoutInfo);
        end

      elseif (id == 2 and resetChat) then
        FCF_SetWindowName(chatFrame, _G.GUILD_EVENT_LOG or "Log");

      elseif (id == 3) then
        VoiceTranscriptionFrame_UpdateVisibility(chatFrame);
        VoiceTranscriptionFrame_UpdateVoiceTab(chatFrame);
        VoiceTranscriptionFrame_UpdateEditBox(chatFrame);
      end
    end

    if (obj:IsFunction(ToggleChatColorNamesByClassGroup)) then
      for i = 1, _G.MAX_WOW_CHAT_CHANNELS do
        ToggleChatColorNamesByClassGroup(true, "CHANNEL" .. i);
      end

      for _, value in ipairs(CHAT_CONFIG_CHAT_LEFT) do
        if (obj:IsTable(value) and obj:IsString(value.type)) then
          ToggleChatColorNamesByClassGroup(true, value.type);
        end
      end
    end
  end
end

function SetUpModule:Install(data)
  if (_G.InCombatLockdown()) then
    tk:Print(L["Cannot install while in combat."]);
    data.window:Hide();
    return;
  end

  -- Default MayronUI console variables:
  ApplyMayronUIConsoleVariableDefaults();
  ApplyMayronUIChatFrameDefaults();

  local usedDragonflightLayout = db.global[tk.Constants.DRAGONFLIGHT_BAR_LAYOUT_PATCH];

  -- Export AddOn values to db:
  for id, addonData in db.global.core.setup.addOns:Iterate() do
    local alias, requiresImporting, addonName = unpack(addonData);

    if (requiresImporting and IsAddOnLoaded(addonName)) then
      local importFunc = namespace.import[addonName];

      if (tk:IsRetail() and addonName == "Bartender4") then
        importFunc = namespace.import[addonName.."-Dragonflight"];
      end

      if (obj:IsFunction(importFunc)) then
        local presetVersion = importFunc();
        db.global.core.setup.addOns[id] = { alias; false; addonName; presetVersion };

        if (tk:IsRetail() and not usedDragonflightLayout and addonName == "Bartender4") then
          db.global[tk.Constants.DRAGONFLIGHT_BAR_LAYOUT_PATCH] = true;
        end
      end
    end
  end

  if (_G["Bartender4"]) then
    local bartenderDB = tk.Tables:GetDBObject("Bartender4");

    if (bartenderDB) then
      local bartenderCurrentProfile = bartenderDB:GetCurrentProfile();

      if (obj:IsTable(bartenderDB) and bartenderCurrentProfile ~= "MayronUI") then
        bartenderDB:SetProfile("MayronUI");
      end
    end
  end

  MayronUI:SwitchLayouts(db.profile.layout);

  if (not db.global.installed) then
    -- db.global.installed = db.global.installed or {}; -- won't work (Observer)
    db.global.installed = {};
  end

  db.global.installed[tk:GetPlayerKey()] = true;
  db.profile.freshInstall = true;

  PlaySoundFile("Interface\\AddOns\\MUI_Setup\\install.ogg");
  DisableAddOn("MUI_Setup");
  ReloadUI();
end

function SetUpModule:GetWindow(data)
  return data.window;
end