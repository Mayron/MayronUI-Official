-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
namespace.import = {};

local tk, db, _, gui, obj, L = MayronUI:GetCoreComponents();
local Private = {};

local _G = _G;

local PlaySoundFile, FCF_SetLocked, FCF_SetWindowAlpha, SetCVar, SetChatWindowSize, UIFrameFadeIn,
C_Timer, UIFrameFadeOut, PlaySound, CreateFrame, IsAddOnLoaded, unpack, math, UIParent, GetAddOnMetadata, string =
_G.PlaySoundFile, _G.FCF_SetLocked, _G.FCF_SetWindowAlpha, _G.SetCVar, _G.SetChatWindowSize, _G.UIFrameFadeIn, _G.C_Timer,
_G.UIFrameFadeOut, _G.PlaySound, _G.CreateFrame, _G.IsAddOnLoaded, _G.unpack, _G.math, _G.UIParent, _G.GetAddOnMetadata, _G.string;

-- Setup Objects -------------------------

local Panel = obj:Import("MayronUI.Widgets.Panel");

-- Register and Import Modules -----------

local C_SetUpModule = MayronUI:RegisterModule("SetUpModule", "Setup");
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
    tk:ApplyThemeColor(0.5, frame.installTab, frame.customTab, frame.infoTab);

    frame = frame.submenu;

    tk:ApplyThemeColor(
        frame.tl, frame.tr, frame.bl, frame.br, frame.t,
        frame.b, frame.l, frame.r, frame.c);

    frame = window.submenu[window.customTab.type];

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

    frame = window.submenu[window.info.type];
    if (frame) then
        window.info.ScrollBar.thumb:SetColorTexture(r, g, b, 0.8);
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

        if (not submenu[self.type]) then
            submenu[self.type] = tk:PopFrame("Frame", submenu);
            submenu[self.type]:SetAllPoints(true);
            Private["Load"..self.type.."Menu"](Private, submenu[self.type]);
        end

        submenu[self.type]:Show();
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
    menuSection.message:SetText(tk.Strings:SetTextColorByTheme("Warning:").." This will reload the UI!");

    menuSection.installButton = gui:CreateButton(tk.Constants.AddOnStyle, menuSection, "Install");
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

    menuSection.newProfileButton = gui:CreateButton(tk.Constants.AddOnStyle, menuSection, "New Profile");
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

    menuSection.deleteProfileButton = gui:CreateButton(tk.Constants.AddOnStyle, menuSection, "Delete Profile");
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

    menuSection.profilePerCharacter = gui:CreateCheckButton(menuSection, "Profile Per Character", nil,
        "If enabled, new characters will be assigned a unique character profile instead of the Default profile.");

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
    menuSection.scaler.tooltipText = L["This will ensure that frames are correctly positioned to match the UI scale during installation.\n\nDefault value is 0.7"];
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

    menuSection.applyScaleBtn = gui:CreateButton(tk.Constants.AddOnStyle, menuSection, "Apply Scaling");
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
        GameTooltip:AddLine(tk.Strings:SetTextColorByTheme(L["Warning:"]).." "..L["This will reload the UI!"]);
        GameTooltip:SetFrameLevel(30);
        GameTooltip:Show();
    end);

    menuSection.installButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide();
    end);
end

function Private:LoadInfoMenu(menuSection)
    local font = tk.Constants.LSM:Fetch("font", db.global.core.font);

    menuSection.info = gui:CreateScrollFrame(tk.Constants.AddOnStyle, menuSection);
    menuSection.child = menuSection.info.ScrollFrame:GetScrollChild();

    tk:SetFullWidth(menuSection.child);
    menuSection.child:SetHeight(1200); -- can't use GetStringHeight

    menuSection.info:SetPoint("TOPLEFT", 40, -40);
    menuSection.info:SetPoint("BOTTOMRIGHT", -40, 40);

    menuSection.info.ScrollBar:SetPoint("TOPLEFT", menuSection.info.ScrollFrame, "TOPRIGHT", -5, 0);
    menuSection.info.ScrollBar:SetPoint("BOTTOMRIGHT", menuSection.info.ScrollFrame, "BOTTOMRIGHT", 0, 0);

    menuSection.info.bg = tk:SetBackground(menuSection.info, 0, 0, 0, 0.5);
    menuSection.info.bg:ClearAllPoints();
    menuSection.info.bg:SetPoint("TOPLEFT", -10, 10);
    menuSection.info.bg:SetPoint("BOTTOMRIGHT", 10, -10);

    local content = menuSection.child:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    content:SetWordWrap(true);
    content:SetAllPoints(true);
    content:SetJustifyH("LEFT");
    content:SetJustifyV("TOP");
    content:SetText(Private.content);
    content:SetFont(font, 13); -- font size should be added to config and profile
    content:SetSpacing(6);
end

-- C_SetUpModule -----------------------

function C_SetUpModule:OnInitialize()
    self:Show();
end

function C_SetUpModule:Show(data)
    if (data.window) then
        data.window:Show();
        UIFrameFadeIn(data.window, 0.3, 0, 1);
        return;
    end

    local window = gui:CreateDialogBox(tk.Constants.AddOnStyle);
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
    window.info:SetInsets(20);

    local title = window.info:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    title:SetText(GetAddOnMetadata("MUI_Core", "X-InterfaceName"):upper());
    title:SetPoint("BOTTOMLEFT");

    local version = window.info:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    version:SetText(tk.Strings:JoinWithSpace(L["VERSION"], GetAddOnMetadata("MUI_Core", "Version")));
    version:SetPoint("BOTTOMLEFT", title, "TOPLEFT", 0, 4);

    window.submenu = gui:CreateDialogBox(tk.Constants.AddOnStyle, window.banner:GetFrame());
    window.submenu:SetAllPoints(window.banner:GetFrame());
    window.submenu:SetAlpha(0);
    window.submenu:Hide();

    -- menu buttons:
    local installTab = CreateFrame("CheckButton", nil, window.menu:GetFrame());
    installTab:SetNormalFontObject("GameFontHighlight");
    installTab:SetText(L["INSTALL"]);
    installTab:SetPoint("LEFT");
    installTab:SetCheckedTexture(1);
    installTab:SetHighlightTexture(1);
    installTab:SetSize(installTab:GetFontString():GetWidth() + 50, 30);
    installTab:SetScript("OnClick", OnMenuButtonClick);
    installTab.type = "Install";

    local customTab = CreateFrame("CheckButton", nil, window.menu:GetFrame());
    customTab:SetNormalFontObject("GameFontHighlight");
    customTab:SetText(L["CUSTOM INSTALL"]);
    customTab:SetPoint("LEFT", installTab, "RIGHT", 40, 0);
    customTab:SetCheckedTexture(1);
    customTab:SetHighlightTexture(1);
    customTab:SetSize(customTab:GetFontString():GetWidth() + 50, 30);
    customTab:SetScript("OnClick", OnMenuButtonClick);
    customTab.type = "Custom";

    local infoTab = CreateFrame("CheckButton", nil, window.menu:GetFrame());
    infoTab:SetNormalFontObject("GameFontHighlight");
    infoTab:SetText(L["INFORMATION"]);
    infoTab:SetPoint("LEFT", customTab, "RIGHT", 40, 0);
    infoTab:SetCheckedTexture(1);
    infoTab:SetHighlightTexture(1);
    infoTab:SetSize(infoTab:GetFontString():GetWidth() + 50, 30);
    infoTab:SetScript("OnClick", OnMenuButtonClick);
    infoTab.type = "Info";

    tk:ApplyThemeColor(0.5, installTab, customTab, infoTab);
    tk:GroupCheckButtons(obj:PopTable(installTab, customTab, infoTab));

    window:AddCells(window.menu, window.banner, window.info);
    data.window = window;
    data.window.installTab = installTab;
    data.window.customTab = customTab;
    data.window.infoTab = infoTab;
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
    SetCVar("floatingCombatTextCombatHealing", "1");
    SetCVar("useUiScale", "1");
    SetCVar("uiscale", db.global.core.uiScale);

    ChatFrame1:SetUserPlaced(true);
    ChatFrame1:ClearAllPoints();

    if (IsAddOnLoaded("MUI_Chat") and db.profile.chat) then
        if (db.profile.chat.chatFrames["TOPLEFT"].enabled) then
            ChatFrame1:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 34, -55);

        elseif (db.profile.chat.chatFrames["BOTTOMLEFT"].enabled) then
            ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 34, 30);
        end

        ChatFrame1:SetHeight(222);
        ChatFrame1:SetWidth(375);
        _G.FCF_SavePositionAndDimensions(ChatFrame1);
    end

    -- Export AddOn values to db:
    for id, addonData in db.global.core.setup.addOns:Iterate() do
        local alias, value, addonName = unpack(addonData);

        if (value and IsAddOnLoaded(addonName)) then
            obj:Assert(obj:IsFunction(namespace.import[addonName]), "No import function for addOn '%s'", addonName);
            namespace.import[addonName]();
            db.global.core.setup.addOns[id] = {alias, false, addonName};
        end
    end

    -- MayronUI profiles:
    for _, name in obj:IterateArgs("AuraFrames", "Bartender4", "Recount") do
        if (_G[name]) then
            local path = tk.Tables:GetDBObject(name);

            if (path) then
                if (path:GetCurrentProfile() ~= "MayronUI") then
                    path:SetProfile("MayronUI");
                end
            end
        end
    end

    -- Default Profiles:
    for _, name in obj:IterateArgs("Grid", "ShadowUF") do
        if (_G[name]) then
            local path = tk.Tables:GetDBObject(name);

            if (path) then
                if (path:GetCurrentProfile() ~= "Default") then
                    path:SetProfile("Default");
                end
            end
        end
    end

    -- Register the UI as installed once everything else is successful!
    if (not db.global.previouslyInstalled) then
        db.global.previouslyInstalled = true;
        db.global.tutorial = true;
        db.profile.tutorial = true;
    end

    if (not db.global.installed) then
        --db.global.installed = db.global.installed or {}; -- won't work (Observer)
        db.global.installed = {};
    end

    db.global.installed[tk:GetPlayerKey()] = true;
    db.global.reanchorRecount = true;

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

Private.content = [[
Thank you for using MayronUI Gen6!

Please visit the community Discord server if you need additional help or wish to get involved with the project:
|cff00ccffhttps://discord.gg/8Kh3maU|r

The official homepage for MayronUI Gen6 is:
|cff00ccffhttps://www.wowinterface.com/downloads/info21221-MayronUIGen5.html|r

|cff00ccff> SLASH COMMANDS|r
|cff00ccff/mui|r - List all MayronUI slash commands (including "install", "config" and "profile" commands)
|cff00ccff/rl|r - Reloads the UI
|cff00ccff/tiptac|r - Show TipTac (Tooltips) AddOn settings
|cff00ccff/ltp|r - Leatrix Plus settings (I recommend looking through them!)
|cff00ccff/af|r - Aura Frames AddOn (for buffs and debuffs)
|cff00ccff/suf|r - Settings for the Unit Frames (Shadowed Unit Frames)
|cff00ccff/bt|r - Bartender Settings (Action Bars)

|cff00ccff> F.A.Q's|r
|cff00ccffQ: Why do I have 2 raid frames showing?|r

|cff90ee90A:|r One of them is the Blizzard raid frames (which can be hidden by pressing the arrow button the left of the screen) and the other is most likely the Grid raid frames.

|cff00ccffQ: How do I open up the Calendar? / How do I toggle the Tracker?|r

|cff90ee90A:|r Right click the Mini-Map and select the option to do this in the drop down menu.

|cff00ccffQ: How can I see more action bars on the bottom of the UI like in the screen shots?|r

|cff90ee90A:|r You need to press and hold the Control key while out of combat to show the Expand and Retract button.

|cff00ccffQ: How do I enable the Timestamps on the Chat Box?|r

|cff90ee90A:|r I removed this feature when Blizzard added this themselves in the Blizzard Interface Options. Go to the Interface in-game menu and go to "Social" then there is a drop down menu with the title "Chat Timestamps". Change this from "None" to a format that suits you.

|cff00ccffQ: How do I turn off/on Auto Quest? Or how do I turn on auto repair?|r

|cff90ee90A:|r That is controlled by Leatrix Plus (Leatrix Plus also offers many other useful features and is worth checking out!). You can open the Leatrix Plus menu to view these by right clicking the Minimap and selecting Leatrix Plus or by typing "/ltp".

|cff00ccffQ: How do you move the buffs and debuffs in the top right corner of the screen?|r

|cff90ee90A:|r Type "/af" to get into the Aura Frames Configuration window and at the top right of the window's frame that shows up, next to the cross to close down the window there is a button on the left of it. If you click that, you can move the buffs and debuffs.

|cff00ccffQ: The tooltip shows over my spells when I hover my mouse cursor over them, how can I move it to the Bottom Right corner like the other tooltips do?|r

|cff90ee90A:|r Type "/tiptac" and go to the Anchors page from the list on the left. Where it says "Frame Tip Type" you will see a drop down menu on the right. Change it from "Mouse Anchor" to "Normal Anchor".
]]
