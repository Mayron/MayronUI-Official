-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
namespace.import = {};

local MayronUI = _G.MayronUI;
local tk, db, _, gui, obj, L = MayronUI:GetCoreComponents();
local Private = {};

local tabText = {
  -- This should use the locales!
  L["INSTALL"], L["CUSTOM INSTALL"], L["INFORMATION"], L["CREDITS"]
};

local RELOAD_MESSAGE = tk.Strings:SetTextColorByTheme(L["Warning:"]).." "..L["This will reload the UI!"];

local tabNames = {
  [L["INSTALL"]] = "Install";
  [L["CUSTOM INSTALL"]] = "Custom";
  [L["INFORMATION"]] = "Info";
  [L["CREDITS"]] = "Credits";
};

local PlaySoundFile, FCF_SetLocked, FCF_SetWindowAlpha, SetCVar, SetChatWindowSize, UIFrameFadeIn,
C_Timer, UIFrameFadeOut, PlaySound, CreateFrame, IsAddOnLoaded, unpack, math, UIParent, GetAddOnMetadata, string =
_G.PlaySoundFile, _G.FCF_SetLocked, _G.FCF_SetWindowAlpha, _G.SetCVar, _G.SetChatWindowSize, _G.UIFrameFadeIn, _G.C_Timer,
_G.UIFrameFadeOut, _G.PlaySound, _G.CreateFrame, _G.IsAddOnLoaded, _G.unpack, _G.math, _G.UIParent, _G.GetAddOnMetadata, _G.string;

local ipairs, strsplit, strjoin, strtrim = _G.ipairs, _G.strsplit, _G.strjoin, _G.strtrim;

-- Setup Objects -------------------------

local Panel = obj:Import("MayronUI.Panel");

-- Register and Import Modules -----------

local C_SetUpModule = MayronUI:RegisterModule("SetUpModule", L["Setup"]);
local setUpModule = MayronUI:ImportModule("SetUpModule");

-- Local Functions -----------------------

local function ChangeTheme(self, value)
  if (value) then
    -- reinject theme colors for next time...
    db.profile["profile.castbars.appearance.colors.normal"] = nil;
    db.profile["profile.bottomui.gradients"] = nil;

  elseif (db.profile.theme) then
    value = db.profile.theme.color:GetUntrackedTable();
  else
    return;
  end

  tk:UpdateThemeColor(value);

  local window = setUpModule:GetWindow();
  local r, g, b = tk:GetThemeColor();
  local frame = window:GetFrame();

  tk:ApplyThemeColor(
  frame.tl, frame.tr, frame.bl, frame.br, frame.t,
  frame.b, frame.l, frame.r, frame.c,
  frame.titleBar.bg,
  frame.closeBtn);

  frame = window;
  tk:ApplyThemeColor(0.5, unpack(frame.tabs));

  frame = frame.submenu;

  tk:ApplyThemeColor(
  frame.tl, frame.tr, frame.bl, frame.br, frame.t,
  frame.b, frame.l, frame.r, frame.c);

  frame = window.submenu["Custom"];

  if (frame) then
    -- resets color
    frame.themeDropdown:UpdateColor();
    frame.chooseProfileDropDown:UpdateColor();

    gui:UpdateButtonColor(frame.applyScaleBtn, tk.Constants.AddOnStyle);
    gui:UpdateButtonColor(frame.installButton, tk.Constants.AddOnStyle);
    gui:UpdateButtonColor(frame.deleteProfileButton, tk.Constants.AddOnStyle);
    gui:UpdateButtonColor(frame.newProfileButton, tk.Constants.AddOnStyle);

    frame.addonContainer:SetGridColor(r, g, b);
  end

  for _, tabName in pairs(tabNames) do
    local menu = window.submenu[tabName];
    if (menu and menu.scrollBar) then
      menu.scrollBar.thumb:SetColorTexture(r, g, b);
    end
  end
end

-- first argument is the dropdown menu self reference
local function ChangeProfile(_, profileName)
  local window = setUpModule:GetWindow();

  if (window) then
    db:SetProfile(profileName);
    ChangeTheme();
  end
end

local function ExpandSetupWindow()
  if (not setUpModule:IsExpanded()) then
    return
  end

  local window = setUpModule:GetWindow();
  local width, height = window:GetSize();

  if (width >= 900 and height >= 540) then
    return
  end

  window:SetSize(width + 20, height + 12);
  C_Timer.After(0.02, ExpandSetupWindow);
end

local function RetractSetupWindow()
  if (setUpModule:IsExpanded()) then
    return
  end

  local window = setUpModule:GetWindow();
  local width, height = window:GetSize();

  if (width <= 750 and height <= 450) then
    return
  end

  window:SetSize(width - 20, height - 12);
  C_Timer.After(0.02, RetractSetupWindow);
end

local function OnMenuButtonClick(self)
  local window = setUpModule:GetWindow();
  local submenu = window.submenu;

  if (self:GetChecked()) then
    for _, frame in ipairs({submenu:GetChildren()}) do
      frame:Hide();
    end

    local tabName = tabNames[self:GetText()];
    if (not submenu[tabName]) then
      submenu[tabName] = tk:PopFrame("Frame", submenu);
      submenu[tabName]:SetAllPoints(true);
      Private["Load"..tabName.."Menu"](Private, submenu[tabName]);
    end

    submenu[tabName]:Show();
    setUpModule:SetExpanded(true);

    C_Timer.After(0.02, ExpandSetupWindow);
    UIFrameFadeIn(submenu, 0.4, submenu:GetAlpha(), 1);
    UIFrameFadeOut(window.banner.left, 0.4, window.banner.left:GetAlpha(), 0.5);
    UIFrameFadeOut(window.banner.right, 0.4, window.banner.right:GetAlpha(), 0.5);
  else
    setUpModule:SetExpanded(false);

    C_Timer.After(0.02, RetractSetupWindow);
    UIFrameFadeOut(submenu, 0.4, submenu:GetAlpha(), 0);
    UIFrameFadeIn(window.banner.left, 0.4, window.banner.left:GetAlpha(), 1);
    UIFrameFadeIn(window.banner.right, 0.4, window.banner.right:GetAlpha(), 1);
  end

  PlaySound(tk.Constants.CLICK);
end

-- Private Functions ---------------------------

function Private:LoadInstallMenu(menuSection)
  menuSection.message = menuSection:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
  menuSection.message:SetPoint("CENTER", 0, 20);
  menuSection.message:SetText(RELOAD_MESSAGE);

  menuSection.installButton = gui:CreateButton(tk.Constants.AddOnStyle, menuSection, L["INSTALL"]);
  menuSection.installButton:SetPoint("CENTER", 0, -20);
  menuSection.installButton:SetScript("OnClick", function()
    setUpModule:Install();
  end);
end

function Private:LoadProfileMenu(menuSection)
  menuSection.profileTitle = menuSection:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
  menuSection.profileTitle:SetPoint("TOPLEFT", menuSection.themeDropdown:GetFrame(), "BOTTOMLEFT", 0, -20);
  menuSection.profileTitle:SetText(L["Choose Profile:"]);

  menuSection.chooseProfileDropDown = gui:CreateDropDown(tk.Constants.AddOnStyle, menuSection);
  menuSection.chooseProfileDropDown:SetLabel(db:GetCurrentProfile());
  menuSection.chooseProfileDropDown:SetPoint("TOPLEFT", menuSection.profileTitle, "BOTTOMLEFT", 0, -10);

  for _, name, _ in db:IterateProfiles() do
    menuSection.chooseProfileDropDown:AddOption(name, ChangeProfile, name);
  end

  menuSection.newProfileButton = gui:CreateButton(tk.Constants.AddOnStyle, menuSection, L["New Profile"]);
  menuSection.newProfileButton:SetPoint("TOPLEFT", menuSection.chooseProfileDropDown:GetFrame(), "BOTTOMLEFT", 0, -20);

  menuSection.newProfileButton:SetScript("OnClick", function()
    MayronUI:TriggerCommand("profile", "new", nil, function()
      local currentProfile = db:GetCurrentProfile();
      menuSection.chooseProfileDropDown:SetLabel(currentProfile);
      menuSection.chooseProfileDropDown:AddOption(currentProfile, function()
        ChangeProfile(nil, currentProfile);
        menuSection.deleteProfileButton:SetEnabled(currentProfile ~= "Default");
      end);
    end);
  end);

  menuSection.deleteProfileButton = gui:CreateButton(tk.Constants.AddOnStyle, menuSection, L["Delete Profile"]);
  menuSection.deleteProfileButton:SetPoint("TOPLEFT", menuSection.newProfileButton, "BOTTOMLEFT", 0, -20);
  menuSection.deleteProfileButton:SetEnabled(db:GetCurrentProfile() ~= "Default");

  menuSection.deleteProfileButton:SetScript("OnClick", function()
    local profileName = db:GetCurrentProfile();
    MayronUI:TriggerCommand("profile", "delete", profileName, function()
      local currentProfile = db:GetCurrentProfile();
      menuSection.chooseProfileDropDown:RemoveOptionByLabel(profileName);
      menuSection.chooseProfileDropDown:SetLabel(currentProfile);
      menuSection.deleteProfileButton:SetEnabled(currentProfile ~= "Default");
    end);
  end);

  menuSection.profilePerCharacter = gui:CreateCheckButton(menuSection, L["Profile Per Character"], nil,
    L["If enabled, new characters will be assigned a unique character profile instead of the Default profile."]);

  menuSection.profilePerCharacter:SetPoint("TOPLEFT", menuSection.deleteProfileButton, "BOTTOMLEFT", 0, -20);
  menuSection.profilePerCharacter.btn:SetChecked(db.global.core.setup.profilePerCharacter);

  menuSection.profilePerCharacter.btn:SetScript("OnClick", function(self)
    local checked = self:GetChecked();
    db:SetPathValue("global.core.setup.profilePerCharacter", checked);

    if (checked) then
      local profileName = tk:GetPlayerKey();

      if (not menuSection.chooseProfileDropDown:GetOptionByLabel(profileName)) then
        menuSection.chooseProfileDropDown:AddOption(profileName, function()
          menuSection.deleteProfileButton:SetEnabled(profileName ~= "Default");
          ChangeProfile(nil, profileName);
        end);
      end

      menuSection.chooseProfileDropDown:SetLabel(profileName);
      menuSection.deleteProfileButton:SetEnabled(true);
      ChangeProfile(nil, profileName);
    else
      menuSection.chooseProfileDropDown:SetLabel("Default");
      menuSection.deleteProfileButton:SetEnabled(false);
      ChangeProfile(nil, "Default");
    end
  end);
end

function Private:LoadThemeMenu(menuSection)
  menuSection.themeTitle = menuSection:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
  menuSection.themeTitle:SetPoint("TOPLEFT", 20, -20);
  menuSection.themeTitle:SetText(L["Choose Theme:"]);

  menuSection.themeDropdown = gui:CreateDropDown(tk.Constants.AddOnStyle, menuSection);

  menuSection.themeDropdown:AddOptions(ChangeTheme, {
  { tk.Strings:SetTextColorByHex("Death Knight", "C41F3B"), "DEATHKNIGHT" },
  { tk.Strings:SetTextColorByHex("Demon Hunter", "A330C9"), "DEMONHUNTER" },
  { tk.Strings:SetTextColorByHex("Druid", "FF7D0A"), "DRUID" },
  { tk.Strings:SetTextColorByHex("Hunter", "ABD473"), "HUNTER" },
  { tk.Strings:SetTextColorByHex("Mage", "69CCF0"), "MAGE" },
  { tk.Strings:SetTextColorByHex("Monk", "00FF96"), "MONK" },
  { tk.Strings:SetTextColorByHex("Paladin", "F58CBA"), "PALADIN" },
  { tk.Strings:SetTextColorByHex("Priest", "FFFFFF"), "PRIEST" },
  { tk.Strings:SetTextColorByHex("Rogue", "FFF569"), "ROGUE" },
  { tk.Strings:SetTextColorByHex("Shaman", "0070DE"), "SHAMAN" },
  { tk.Strings:SetTextColorByHex("Warlock", "9482C9"), "WARLOCK" },
  { tk.Strings:SetTextColorByHex("Warrior", "C79C6E"), "WARRIOR" }
  });

  local ColorPickerFrame = _G.ColorPickerFrame;
  menuSection.themeDropdown:AddOption("Custom Color", function()
    local colors = {};
    ColorPickerFrame:SetColorRGB(1, 1, 1);
    ColorPickerFrame.previousValues = {1, 1, 1, 0};

    ColorPickerFrame.func = function()
      colors.r, colors.g, colors.b = ColorPickerFrame:GetColorRGB();
      colors.hex = string.format('%02x%02x%02x', colors.r * 255, colors.g * 255, colors.b * 255);
      ChangeTheme(nil, colors);
    end

    ColorPickerFrame.cancelFunc = function(values)
      colors.r, colors.g, colors.b = unpack(values);
      colors.hex = string.format('%02x%02x%02x', colors.r * 255, colors.g * 255, colors.b * 255);
      ChangeTheme(nil, colors);
    end

    ColorPickerFrame:Hide(); -- run OnShow
    ColorPickerFrame:Show();
  end);

  menuSection.themeDropdown:SetLabel(L["Theme"]);
  menuSection.themeDropdown:SetPoint("TOPLEFT", menuSection.themeTitle, "BOTTOMLEFT", 0, -10);
end

function Private:LoadCustomMenu(menuSection)
  self:LoadThemeMenu(menuSection, tk.Constants.AddOnStyle);
  self:LoadProfileMenu(menuSection, tk.Constants.AddOnStyle);

  -- UI Scale
  menuSection.scaleTitle = menuSection:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
  menuSection.scaleTitle:SetPoint("TOPLEFT", menuSection.themeTitle, "TOPRIGHT", 150, 0);
  menuSection.scaleTitle:SetText(L["Adjust the UI Scale:"]);

  menuSection.scaler = CreateFrame("Slider", nil, menuSection, "OptionsSliderTemplate");
  menuSection.scaler:SetPoint("TOPLEFT", menuSection.scaleTitle, "BOTTOMLEFT", 0, -10);
  menuSection.scaler:SetWidth(200);
  menuSection.scaler.tooltipText = tk.Strings:Join("\n\n",
    L["This will ensure that frames are correctly positioned to match the UI scale during installation."],
    L["Default value is"] .. " 0.7");
  menuSection.scaler:SetMinMaxValues(0.6, 1.2);
  menuSection.scaler:SetValueStep(0.05);
  menuSection.scaler:SetObeyStepOnDrag(true);
  menuSection.scaler:SetValue(db.global.core.uiScale);
  menuSection.scaler.Low:SetText(0.6);
  menuSection.scaler.Low:ClearAllPoints();
  menuSection.scaler.Low:SetPoint("BOTTOMLEFT", 5, -8);
  menuSection.scaler.High:SetText(1.2);
  menuSection.scaler.High:ClearAllPoints();
  menuSection.scaler.High:SetPoint("BOTTOMRIGHT", -5, -8);
  menuSection.scaler.Value = menuSection.scaler:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
  menuSection.scaler.Value:SetPoint("BOTTOM", 0, -8);
  menuSection.scaler.Value:SetText(db.global.core.uiScale);

  menuSection.applyScaleBtn = gui:CreateButton(tk.Constants.AddOnStyle, menuSection, L["Apply Scaling"]);
  menuSection.applyScaleBtn:SetPoint("TOPLEFT", menuSection.scaler, "BOTTOMLEFT", 0, -20);
  menuSection.applyScaleBtn:Disable();

  menuSection.applyScaleBtn:SetScript("OnClick", function(self)
    self:Disable();
    SetCVar("useUiScale", "1");
    SetCVar("uiscale", db.global.core.uiScale);
  end);

  menuSection.scaler:SetScript("OnValueChanged", function(self, value)
    value = math.floor((value * 100) + 0.5) / 100;
    self.Value:SetText(value);
    db.global.core.uiScale = value;
    menuSection.applyScaleBtn:Enable();
  end);

  -- AddOn Settings to Inject
  menuSection.injectTitle = menuSection:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
  menuSection.injectTitle:SetPoint("TOPLEFT", menuSection.scaleTitle, "TOPRIGHT", 110, 0);
  menuSection.injectTitle:SetText(L["AddOn Settings to Override:"]);

  local previous;
  menuSection.addonContainer = gui:CreateScrollFrame(tk.Constants.AddOnStyle, menuSection, nil);
  menuSection.addonContainer:SetPoint("TOPLEFT", menuSection.injectTitle, "BOTTOMLEFT", 0, -20);
  menuSection.addonContainer:SetPoint("BOTTOMRIGHT", -20, 70);

  local scrollChild = menuSection.addonContainer.ScrollFrame:GetScrollChild();

  gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, "LOW", menuSection.addonContainer);

  local totalAddOnsLoaded = 0;

  for id, addOnData in db.global.core.setup.addOns:Iterate() do
    local alias, value, addOnName = unpack(addOnData);

    if (IsAddOnLoaded(addOnName)) then
      local cb = gui:CreateCheckButton(scrollChild, alias);
      totalAddOnsLoaded = totalAddOnsLoaded + 1;

      cb.btn:SetChecked(value);
      cb.btn:SetScript("OnClick", function(self)
        db.global.core.setup.addOns[id] = obj:PopTable(alias, self:GetChecked(), addOnName);
      end);

      if (not previous) then
        cb:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 10, -10);
      else
        cb:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -10);
      end

      scrollChild:SetHeight(scrollChild:GetHeight() + cb:GetHeight() + 10);
      previous = cb;
    end
  end

  if (totalAddOnsLoaded == 0) then
    local fontString = menuSection.addonContainer:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    fontString:SetPoint("CENTER");
    fontString:SetText("No Supported AddOns Loaded");
  end

  -- install button
  menuSection.installButton = gui:CreateButton(tk.Constants.AddOnStyle, menuSection, L["Install"]);
  menuSection.installButton:SetPoint("TOPRIGHT", menuSection.addonContainer, "BOTTOMRIGHT", 0, -20);

  menuSection.installButton:SetScript("OnClick", function()
    setUpModule:Install();
  end);

  local GameTooltip = _G.GameTooltip;
  menuSection.installButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 18, 4);
    GameTooltip:AddLine(RELOAD_MESSAGE);
    GameTooltip:SetFrameLevel(30);
    GameTooltip:Show();
  end);

  menuSection.installButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide();
  end);
end

function Private:LoadInfoMenu(menuSection)
  local font = tk.Constants.LSM:Fetch("font", db.global.core.font);

  local container = gui:CreateScrollFrame(tk.Constants.AddOnStyle, menuSection);
  menuSection.child = container.ScrollFrame:GetScrollChild();
  menuSection.scrollBar = container.ScrollBar;

  tk:SetFullWidth(menuSection.child);
  menuSection.child:SetHeight(300);

  container:SetPoint("TOPLEFT", 40, -40);
  container:SetPoint("BOTTOMRIGHT", -40, 40);

  menuSection.scrollBar:SetPoint("TOPLEFT", container.ScrollFrame, "TOPRIGHT", -5, 0);
  menuSection.scrollBar:SetPoint("BOTTOMRIGHT", container.ScrollFrame, "BOTTOMRIGHT", 0, 0);

  container.bg = tk:SetBackground(container, 0, 0, 0, 0.5);
  container.bg:ClearAllPoints();
  container.bg:SetPoint("TOPLEFT", -10, 10);
  container.bg:SetPoint("BOTTOMRIGHT", 10, -10);

  local content = CreateFrame("EditBox", nil, menuSection.child);
  content:SetMultiLine(true);
  content:SetMaxLetters(99999);
  content:EnableMouse(true);
  content:SetAutoFocus(false);
  content:SetFontObject("GameFontHighlight");
  content:SetFont(font, 13);
  content:SetAllPoints(true);
  content:SetText(Private.info);
  content:SetScript("OnEscapePressed", function(self) self:ClearFocus(); end);
  content:SetScript("OnTextChanged", function(self) self:SetText(Private.info); end);
end


function Private:LoadCreditsMenu(menuSection)
  local font = tk.Constants.LSM:Fetch("font", db.global.core.font);

  local container = gui:CreateScrollFrame(tk.Constants.AddOnStyle, menuSection);
  menuSection.child = container.ScrollFrame:GetScrollChild();
  menuSection.scrollBar = container.ScrollBar;

  tk:SetFullWidth(menuSection.child);
  menuSection.child:SetHeight(700); -- can't use GetStringHeight

  container:SetPoint("TOPLEFT", 40, -40);
  container:SetPoint("BOTTOMRIGHT", -40, 40);

  menuSection.scrollBar:SetPoint("TOPLEFT", menuSection.scrollBar, "TOPRIGHT", -5, 0);
  menuSection.scrollBar:SetPoint("BOTTOMRIGHT", menuSection.scrollBar, "BOTTOMRIGHT", 0, 0);

  container.bg = tk:SetBackground(container, 0, 0, 0, 0.5);
  container.bg:ClearAllPoints();
  container.bg:SetPoint("TOPLEFT", -10, 10);
  container.bg:SetPoint("BOTTOMRIGHT", 10, -10);

  local content = menuSection.child:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  content:SetWordWrap(true);
  content:SetAllPoints(true);
  content:SetJustifyH("LEFT");
  content:SetJustifyV("TOP");
  content:SetText(Private.credits);
  content:SetFont(font, 13); -- font size should be added to config and profile
  content:SetSpacing(6);
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
      names[i] = string.format("|TInterface\\Challenges\\ChallengeMode_Medal_Gold:18:18:0:-4|t %s", strtrim(name));
    end

    sections[s] = strjoin("\n", unpack(names));
    obj:PushTable(names);
  end

  return obj:UnpackTable(sections);
end

function C_SetUpModule:OnInitialize()
  self:Show();
end

function C_SetUpModule:Show(data)
  if (data.window) then
    data.window:Show();
    UIFrameFadeIn(data.window, 0.3, 0, 1);
    return;
  end

  Private.info = L["MUI_Setup_InfoTab"]:format(GetInfoLinks(
  "X-Discord", "X-Home-Page", "X-GitHub-Repo", "X-Patreon", "X-YouTube"));

  Private.credits = L["MUI_Setup_CreditsTab"]:format(GetCreditsSections(
  "X-Patrons", "X-Development-and-Bug-Fixes", "X-Translation-Support", "X-Community-Support-Team"))

  local window = gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, nil, nil, "MUI_Setup");
  window:SetSize(750, 485); -- change this!
  window:SetPoint("CENTER");
  window:SetFrameStrata("DIALOG");

  gui:AddTitleBar(tk.Constants.AddOnStyle, window, L["Setup Menu"]);
  gui:AddCloseButton(tk.Constants.AddOnStyle, window, nil, tk.Constants.CLICK);

  window.bg = tk:SetBackground(window, 0, 0, 0, 0.8); -- was 0.8 but set to 0.2 for testing
  window.bg:SetDrawLayer("BACKGROUND", -5);
  window.bg:SetAllPoints(UIParent);

  -- turn window frame into a Panel
  window = Panel(window);
  window:SetDevMode(false);  -- shows or hides panel cell backgrounds used for arranging content
  window:SetDimensions(1, 3);
  window:GetRow(1):SetFixed(60);
  window:GetRow(3):SetFixed(70);
  window.menu = window:CreateCell();
  window.menu:SetInsets(25, 8, 8, 8);

  window.banner = window:CreateCell();
  window.banner:SetInsets(0, 2);

  window.banner.left = window.banner:CreateTexture(nil, "BACKGROUND");
  window.banner.left:SetTexture("Interface\\AddOns\\MUI_Setup\\media\\banner-left");
  window.banner.left:SetPoint("TOPLEFT");
  window.banner.left:SetPoint("BOTTOMLEFT");
  window.banner.left:SetPoint("RIGHT", window.banner:GetFrame(), "CENTER");

  window.banner.right = window.banner:CreateTexture(nil, "BACKGROUND");
  window.banner.right:SetTexture("Interface\\AddOns\\MUI_Setup\\media\\banner-right");
  window.banner.right:SetPoint("TOPRIGHT");
  window.banner.right:SetPoint("BOTTOMRIGHT");
  window.banner.right:SetPoint("LEFT", window.banner:GetFrame(), "CENTER");

  window.info = window:CreateCell();
  window.info:SetInsets(15, 20);

  local title = window.info:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
  title:SetText("MAYRONUI");
  title:SetPoint("TOPLEFT");
  tk:SetFontSize(title, 22);

  local version = window.info:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
  version:SetText(tk.Strings:JoinWithSpace(L["VERSION"], tk:GetVersion("MUI_Core", "YELLOW")));
  version:SetPoint("TOPLEFT");
  version:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 2, 0);
  tk:SetFontSize(version, 12);

  window.submenu = gui:CreateDialogBox(tk.Constants.AddOnStyle, window.banner:GetFrame());
  window.submenu:SetAllPoints(window.banner:GetFrame());
  window.submenu:SetAlpha(0);
  window.submenu:Hide();

  -- menu buttons:
  local tabs = {};

  for i, text in ipairs(tabText) do
    local tab = CreateFrame("CheckButton", nil, window.menu:GetFrame());
    tab:SetNormalFontObject("GameFontHighlight");
    tab:SetText(text);
    tab:SetCheckedTexture(1);
    tab:SetHighlightTexture(1);
    tab:SetSize(tab:GetFontString():GetWidth() + 50, 30);
    tab:SetScript("OnClick", OnMenuButtonClick);

    if (i == 1) then
      tab:SetPoint("LEFT");
    else
      tab:SetPoint("LEFT", tabs[i - 1], "RIGHT", 30, 0);
    end

    tabs[i] = tab;
  end

  tk:ApplyThemeColor(0.5, unpack(tabs));
  tk:GroupCheckButtons(tabs);

  window:AddCells(window.menu, window.banner, window.info);
  data.window = window;
  data.window.tabs = tabs;
  UIFrameFadeIn(data.window, 0.3, 0, 1);
end

function C_SetUpModule:Install()
  PlaySoundFile("Interface\\AddOns\\MUI_Setup\\install.ogg");
  local ChatFrame1 = _G.ChatFrame1;

  -- Chat Frame settings:
  FCF_SetLocked(ChatFrame1, 1);
  FCF_SetWindowAlpha(ChatFrame1, 0);
  SetCVar("ScriptErrors","1");
  SetChatWindowSize(1, 13);
  SetCVar("chatStyle", "classic");
  SetCVar("floatingCombatTextCombatDamage", "1");

  if (tk:IsRetail()) then
    SetCVar("floatingCombatTextCombatHealing", "1");
  elseif (tk:IsBCClassic()) then
    SetCVar("nameplateMaxDistance", 41);
  end

  SetCVar("useUiScale", "1");
  SetCVar("uiscale", db.global.core.uiScale);

  ChatFrame1:SetUserPlaced(true);
  ChatFrame1:ClearAllPoints();

  if (db.profile.chat) then
    if (db.profile.chat.chatFrames["TOPLEFT"].enabled) then
      ChatFrame1:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 34, -55);

    elseif (db.profile.chat.chatFrames["BOTTOMLEFT"].enabled) then
      ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 34, 30);

    elseif (db.profile.chat.chatFrames["TOPRIGHT"].enabled) then
      ChatFrame1:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -34, -55);

    elseif (db.profile.chat.chatFrames["BOTTOMRIGHT"].enabled) then
      ChatFrame1:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 34, -30);
    end

    ChatFrame1:SetHeight(222);
    ChatFrame1:SetWidth(375);
    _G.FCF_SavePositionAndDimensions(ChatFrame1);
  end

  -- Export AddOn values to db:
  for id, addonData in db.global.core.setup.addOns:Iterate() do
    local alias, value, addonName = unpack(addonData);

    if (value and IsAddOnLoaded(addonName) and obj:IsFunction(namespace.import[addonName])) then
      namespace.import[addonName]();
      db.global.core.setup.addOns[id] = {alias, false, addonName};
    end
  end

  if (_G.Bartender4) then
    local path = tk.Tables:GetDBObject("Bartender4");

    if (path) then
      if (path:GetCurrentProfile() ~= "MayronUI") then
        path:SetProfile("MayronUI");
      end
    end
  end

  if (_G.ShadowUF) then
    local path = tk.Tables:GetDBObject("ShadowUF");

    if (path) then
      if (path:GetCurrentProfile() ~= "Default") then
        path:SetProfile("Default");
      end
    end
  end

  if (not db.global.installed) then
    --db.global.installed = db.global.installed or {}; -- won't work (Observer)
    db.global.installed = {};
  end

  db.global.installed[tk:GetPlayerKey()] = true;
  db.profile.freshInstall = true;

  _G.DisableAddOn("MUI_Setup");
  _G.ReloadUI();
end

function C_SetUpModule:GetWindow(data)
  return data.window;
end

function C_SetUpModule:SetExpanded(data, expanded)
  data.expanded = expanded;
end

function C_SetUpModule:IsExpanded(data)
  return data.window and data.expanded;
end