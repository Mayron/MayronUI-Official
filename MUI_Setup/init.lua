------------------------
-- Setup namespaces
------------------------
local _, setup = ...;
setup.import = {};

MayronUI:RegisterModule("MUI_Setup", setup);

local core = MayronUI:ImportModule("MUI_Core");
local tk = core.Toolkit;
local gui = core.GUI_Builder;
local db = core.Database;
local private = {};

local L = LibStub ("AceLocale-3.0"):GetLocale ("MayronUI");

------------------------
------------------------
local function ChangeTheme(self, value)
    if (value and db.profile.theme) then
        db.profile.theme.color = tk.Constants.CLASS_RGB_COLORS[value] or value;
        -- reinject theme colors for next time...
        db.profile["profile.castbars.appearance.colors.normal"] = nil;
        db.profile["profile.bottomui.gradients"] = nil;
    end

    local r, g, b = tk:GetThemeColor();
    local f = setup.window:GetFrame();
    
    tk:SetThemeColor(f.tl, f.tr, f.bl, f.br, f.t, f.b, f.l, f.r, f.c);
    tk:SetThemeColor(f.title_bar.bg);
    tk:SetThemeColor(f.close_btn);
    f = setup.window;
    tk:SetThemeColor(0.5, f.install, f.custom, f.info);
    f = f.submenu;
    tk:SetThemeColor(f.tl, f.tr, f.bl, f.br, f.t, f.b, f.l, f.r, f.c);

    f = setup.window.submenu[setup.window.custom.type];
    if (f) then
        f.themeDropdown:SetThemeColor();
        f.profileDropdown:SetThemeColor();
        tk:SetThemeColor(f.install, f.scale_apply);
        f.addon_container:SetGridColor(r, g, b);
    end

    f = setup.window.submenu[setup.window.info.type];
    if (f) then
        f.info.ScrollBar.thumb:SetColorTexture(r, g, b, 0.8);
    end
end

local function UpdateOptions(s)
    if (tk.IsAddOnLoaded("MUI_Chat") and db.profile.chat) then
        s.tl.btn:SetChecked(db.profile.chat.enabled["TOPLEFT"]);
        s.bl.btn:SetChecked(db.profile.chat.enabled["BOTTOMLEFT"]);
        s.br.btn:SetChecked(db.profile.chat.enabled["BOTTOMRIGHT"]);
        s.tr.btn:SetChecked(db.profile.chat.enabled["TOPRIGHT"]);
    end
	if (db.global.core.localization) then
		s.localization.cb.btn:SetChecked(db.global.core.localization);
	end
    s.themeDropdown:SetLabel("Theme");
end

local function ChangeProfile(self, name)
    db:SetProfile(name);
    ChangeTheme();
    UpdateOptions(setup.window.submenu[setup.window.custom.type]);
end

function private:LoadInstallMenu(s)
    s.message = s:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    s.message:SetPoint("CENTER", 0, 20);
    s.message:SetText(tk:GetThemeColoredString("Warning:").." This will reload the UI!");
    s.btn = gui:CreateButton(s, "Install");
    s.btn:SetPoint("CENTER", 0, -20);
    s.btn:SetScript("OnClick", setup.Install);
end

-- s = menu section
function private:LoadCustomMenu(s)
    s.theme_title = s:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    s.theme_title:SetPoint("TOPLEFT", 20, -20);
    s.theme_title:SetText(L["Choose Theme:"]);

    s.themeDropdown = gui:CreateDropDown(s);
    s.themeDropdown:AddOption(tk:GetHexColoredString(UnitClass(6),	"C41F3B"), ChangeTheme, "DEATHKNIGHT");
    s.themeDropdown:AddOption(tk:GetHexColoredString(UnitClass(12),	"A330C9"), ChangeTheme, "DEMONHUNTER");
    s.themeDropdown:AddOption(tk:GetHexColoredString(UnitClass(11),	"FF7D0A"), ChangeTheme, "DRUID");
    s.themeDropdown:AddOption(tk:GetHexColoredString(UnitClass(3),	"ABD473"), ChangeTheme, "HUNTER");
    s.themeDropdown:AddOption(tk:GetHexColoredString(UnitClass(8),	"69CCF0"), ChangeTheme, "MAGE");
    s.themeDropdown:AddOption(tk:GetHexColoredString(UnitClass(10),	"00FF96"), ChangeTheme, "MONK");
    s.themeDropdown:AddOption(tk:GetHexColoredString(UnitClass(2),	"F58CBA"), ChangeTheme, "PALADIN");
    s.themeDropdown:AddOption(tk:GetHexColoredString(UnitClass(5),	"FFFFFF"), ChangeTheme, "PRIEST");
    s.themeDropdown:AddOption(tk:GetHexColoredString(UnitClass(4),	"FFF569"), ChangeTheme, "ROGUE");
    s.themeDropdown:AddOption(tk:GetHexColoredString(UnitClass(7),	"0070DE"), ChangeTheme, "SHAMAN");
    s.themeDropdown:AddOption(tk:GetHexColoredString(UnitClass(9),	"9482C9"), ChangeTheme, "WARLOCK");
    s.themeDropdown:AddOption(tk:GetHexColoredString(UnitClass(1),	"C79C6E"), ChangeTheme, "WARRIOR");
    
    s.themeDropdown:AddOption(L["Custom Colour"], function()
        local colors = {};
        ColorPickerFrame:SetColorRGB(1, 1, 1);        
        ColorPickerFrame.previousValues = {1, 1, 1, 0};
        
        ColorPickerFrame.func = function()
            colors.r, colors.g, colors.b = ColorPickerFrame:GetColorRGB();
            colors.hex = tk.string.format('%02x%02x%02x', colors.r * 255, colors.g * 255, colors.b * 255);
            ChangeTheme(nil, colors);
        end

        ColorPickerFrame.cancelFunc = function(values)
            colors.r, colors.g, colors.b = tk.unpack(values);
            colors.hex = tk.string.format('%02x%02x%02x', colors.r * 255, colors.g * 255, colors.b * 255);
            ChangeTheme(nil, colors);
        end

        ColorPickerFrame:Hide(); -- run OnShow
        ColorPickerFrame:Show();
    end);

    s.themeDropdown:SetLabel(L["Theme"]);
    s.themeDropdown:SetPoint("TOPLEFT", s.theme_title, "BOTTOMLEFT", 0, -10);

    -- profile dropdown menu
    s.profile_title = s:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    s.profile_title:SetPoint("TOPLEFT", s.themeDropdown:GetFrame(), "BOTTOMLEFT", 0, -20);
    s.profile_title:SetText(L["Choose Profile:"]);

    s.profileDropdown = gui:CreateDropDown(s);
    for _, name, _ in db:IterateProfiles() do
        s.profileDropdown:AddOption(name, ChangeProfile);
    end

    s.profileDropdown:SetLabel(db:GetCurrentProfile());
    s.profileDropdown:SetPoint("TOPLEFT", s.profile_title, "BOTTOMLEFT", 0, -10);

    s.profileDropdown:AddOption(L["<new profile>"], function(self)
        if (not tk.StaticPopupDialogs["MUI_NewProfile"]) then

            tk.StaticPopupDialogs["MUI_NewProfile"] = {
                text = L["Create New Profile:"],
                button1 = L["Confirm"],
                button2 = L["Cancel"],
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
                hasEditBox  = true,
                preferredIndex = 3,
                OnAccept = function(dialog)
                    local text = dialog.editBox:GetText()
                    ChangeProfile(nil, text);
                    UpdateOptions(s);
                    s.profileDropdown:AddOption(text, ChangeProfile);
                    s.profileDropdown:SetLabel(text);
                end,
            };

        end

        tk.StaticPopup_Show("MUI_NewProfile");
        self:SetLabel(db:GetCurrentProfile());
    end);

    s.profileDropdown:AddOption(L["<remove profile>"], function(self)
        if (not tk.StaticPopupDialogs["MUI_RemoveProfile"]) then

            tk.StaticPopupDialogs["MUI_RemoveProfile"] = {
                text = L["Remove Profile:"],
                button1 = L["Confirm"],
                button2 = L["Cancel"],
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
                hasEditBox  = true,
                preferredIndex = 3,
                OnAccept = function(dialog)
                    local text = dialog.editBox:GetText();
                    local changed = db:RemoveProfile(text);
                    s.profileDropdown:RemoveOption(text);
                    s.profileDropdown:SetLabel(db:GetCurrentProfile());
                    if (changed) then
                        ChangeTheme();
                        UpdateOptions(s);
                    end
                end,
            };

        end

        tk.StaticPopup_Show("MUI_RemoveProfile");
        self:Toggle(true);
        self:SetLabel(db:GetCurrentProfile());
    end);

    -- Enabled Chat Frames:
    if (tk.IsAddOnLoaded("MUI_Chat") and db.profile.chat) then
        s.chat_title = s:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
        s.chat_title:SetPoint("TOPLEFT", s.profileDropdown:GetFrame(), "BOTTOMLEFT", 0, -40);
        s.chat_title:SetText(L["Enabled Chat Frames:"]);

        s.tl = gui:CreateCheckButton(s, L["Top Left"]);
        s.tl:SetPoint("TOPLEFT", s.chat_title, "BOTTOMLEFT", 0, -10);
        s.tl.btn:SetScript("OnClick", function(self)
            db.profile.chat.enabled["TOPLEFT"] = self:GetChecked();
        end);

        s.bl = gui:CreateCheckButton(s, L["Bottom Left"]);
        s.bl:SetPoint("TOPLEFT", s.tl, "BOTTOMLEFT", 0, -10);
        s.bl.btn:SetScript("OnClick", function(self)
            db.profile.chat.enabled["BOTTOMLEFT"] = self:GetChecked();
        end);

        s.br = gui:CreateCheckButton(s, L["Bottom Right"]);
        s.br:SetPoint("TOPLEFT", s.bl, "BOTTOMLEFT", 0, -10);
        s.br.btn:SetScript("OnClick", function(self)
            db.profile.chat.enabled["BOTTOMRIGHT"] = self:GetChecked();
        end);

        s.tr = gui:CreateCheckButton(s, L["Top Right"]);
        s.tr:SetPoint("TOPLEFT", s.br, "BOTTOMLEFT", 0, -10);
        s.tr.btn:SetScript("OnClick", function(self)
            db.profile.chat.enabled["TOPRIGHT"] = self:GetChecked();
        end);
    end

    -- UI Scale
    s.scale_title = s:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    s.scale_title:SetPoint("TOPLEFT", s.theme_title, "TOPRIGHT", 150, 0);
    s.scale_title:SetText(L["Adjust the UI Scale:"]);

    s.scaler = tk.CreateFrame("Slider", nil, s, "OptionsSliderTemplate");
    s.scaler:SetPoint("TOPLEFT", s.scale_title, "BOTTOMLEFT", 0, -10);
    s.scaler:SetWidth(200);
    s.scaler.tooltipText = L["This will ensure that frames are correctly positioned to match the UI scale during installation.\n\nDefault value is 0.7"];
    s.scaler:SetMinMaxValues(0.6, 1.2);
    s.scaler:SetValueStep(0.05);
    s.scaler:SetObeyStepOnDrag(true);
    s.scaler:SetValue(db.global.core.uiScale);
    s.scaler.Low:SetText(0.6);
    s.scaler.Low:ClearAllPoints();
    s.scaler.Low:SetPoint("BOTTOMLEFT", 5, -8);
    s.scaler.High:SetText(1.2);
    s.scaler.High:ClearAllPoints();
    s.scaler.High:SetPoint("BOTTOMRIGHT", -5, -8);
    s.scaler.Value = s.scaler:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
    s.scaler.Value:SetPoint("BOTTOM", 0, -8);
    s.scaler.Value:SetText(db.global.core.uiScale);

    s.scale_apply = gui:CreateButton(s, "Apply Scaling");
    s.scale_apply:SetPoint("TOPLEFT", s.scaler, "BOTTOMLEFT", 0, -20);
    s.scale_apply:Disable();

    s.scale_apply:SetScript("OnClick", function(self)
        self:Disable();
        SetCVar("useUiScale", "1");
        SetCVar("uiscale", db.global.core.uiScale);
    end);    

    s.scaler:SetScript("OnValueChanged", function(self, value)
        value = tk.math.floor((value * 100) + 0.5) / 100;
        self.Value:SetText(value);
        db.global.core.uiScale = value;
        s.scale_apply:Enable();
    end);
	
	-- Localization (currently in development)
	-- s.localization = s:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    -- s.localization:SetPoint("TOPLEFT", s.chat_title, "TOPRIGHT", 95, 0);
    -- s.localization:SetText(L["Use Localization:"]);
    -- s.localization:Hide();

	-- s.localization.cb = gui:CreateCheckButton(s, L["WoW Client: "]..GetLocale());
	-- s.localization.cb:SetPoint("TOPLEFT", s.chat_title, "TOPRIGHT", 95, -40);
	-- s.localization.cb.btn:SetScript("OnClick", function(self)
	-- 	db.global.core.localization = self:GetChecked();
	-- end);

    -- AddOn Settings to Inject
    s.inject_title = s:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    s.inject_title:SetPoint("TOPLEFT", s.scale_title, "TOPRIGHT", 110, 0);
    s.inject_title:SetText(L["AddOn Settings to Override:"]);

    local child, previous;
    s.addon_container, child = gui:CreateScrollFrame(s);
    s.addon_container:SetPoint("TOPLEFT", s.inject_title, "BOTTOMLEFT", 0, -20);
    s.addon_container:SetPoint("BOTTOMRIGHT", -20, 70);

    gui:CreateDialogBox(nil, "LOW", s.addon_container);

    for id, addonData in db.global.core.addons:Iterate() do
        local alias, value, addonName = tk.unpack(addonData);

        if (tk.IsAddOnLoaded(addonName)) then
            local cb = gui:CreateCheckButton(child, alias);

            cb.btn:SetChecked(value);
            cb.btn:SetScript("OnClick", function(self)
                db.global.core.addons[id] = {alias, self:GetChecked(), addonName}; -- TODO: doesn't self clean!
            end);

            if (not previous) then
                cb:SetPoint("TOPLEFT", child, "TOPLEFT", 10, -10);
            else
                cb:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -10);
            end

            child:SetHeight(child:GetHeight() + cb:GetHeight() + 10);
            previous = cb;
        end
    end

    -- install button
    s.install = gui:CreateButton(s, L["Install"]);
    s.install:SetPoint("TOPRIGHT", s.addon_container, "BOTTOMRIGHT", 0, -20);

    s.install:SetScript("OnClick", setup.Install);
    s.install:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 18, 4)
        GameTooltip:AddLine(tk:GetThemeColoredString(L["Warning:"]).." "..L["This will reload the UI!"]);
        GameTooltip:SetFrameLevel(30)
        GameTooltip:Show()
    end);

    s.install:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end);

    UpdateOptions(s);
end

function private:LoadInfoMenu(s)
    local font = tk.Constants.LSM:Fetch("font", db.global.core.font);
    s.info, s.child = gui:CreateScrollFrame(s);
    s.info.ScrollBar:SetPoint("TOPLEFT", s.info.ScrollFrame, "TOPRIGHT", -5, 0);
    s.info.ScrollBar:SetPoint("BOTTOMRIGHT", s.info.ScrollFrame, "BOTTOMRIGHT", 0, 0);
    s.info:SetPoint("TOPLEFT", 40, -40);
    s.info:SetPoint("BOTTOMRIGHT", -40, 40);
    s.info.bg = tk:SetBackground(s.info, 0, 0, 0, 0.5);
    s.info.bg:ClearAllPoints();
    s.info.bg:SetPoint("TOPLEFT", -10, 10);
    s.info.bg:SetPoint("BOTTOMRIGHT", 10, -10);
    tk:SetFullWidth(s.child);

    local content = s.child:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    content:SetWordWrap(true);
    content:SetAllPoints(true);
    content:SetJustifyH("LEFT");
    content:SetJustifyV("TOP");
    content:SetText(private.content);
    content:SetFont(font, 13); -- font size should be added to config and profile. I personally prefer 10 ;-)
    content:SetSpacing(6);
    s.child:SetHeight(900); -- can't use GetStringHeight
end

-- self will be the button
function private:OnMenuButtonClick()
    local submenu = setup.window.submenu;

    if (self:GetChecked()) then
        for _, frame in tk:IterateArgs(submenu:GetChildren()) do
            frame:Hide();
        end
        if (not submenu[self.type]) then
            submenu[self.type] = tk:PopFrame("Frame", submenu);
            submenu[self.type]:SetAllPoints(true);
            private["Load"..self.type.."Menu"](private, submenu[self.type]);
        end

        submenu[self.type]:Show();
        setup.expanded = true;
        tk.C_Timer.After(0.02, setup.Expand);
        tk.UIFrameFadeIn(submenu, 0.4, submenu:GetAlpha(), 1);
        tk.UIFrameFadeOut(setup.window.banner.left, 0.4, setup.window.banner.left:GetAlpha(), 0.5);
        tk.UIFrameFadeOut(setup.window.banner.right, 0.4, setup.window.banner.right:GetAlpha(), 0.5);
    else
        setup.expanded = false;
        tk.C_Timer.After(0.02, setup.Retract);
        tk.UIFrameFadeOut(submenu, 0.4, submenu:GetAlpha(), 0);
        tk.UIFrameFadeIn(setup.window.banner.left, 0.4, setup.window.banner.left:GetAlpha(), 1);
        tk.UIFrameFadeIn(setup.window.banner.right, 0.4, setup.window.banner.right:GetAlpha(), 1);
    end

    tk.PlaySound(tk.Constants.CLICK);
end

function setup:Show()
    if (self.window) then
        self.window:Show();
        tk.UIFrameFadeIn(self.window, 0.3, 0, 1);
        return;
    end

    local window = gui:CreateDialogBox();
    window:SetSize(750, 485); -- change this!
    window:SetPoint("CENTER");
    window:SetFrameStrata("DIALOG");

    gui:AddTitleBar(window, L["Setup Menu"]);
    gui:AddCloseButton(window);

    window.bg = tk:SetBackground(window, 0, 0, 0, 0.8); -- was 0.8 but set to 0.2 for testing
    window.bg:SetDrawLayer("BACKGROUND", -5);
    window.bg:SetAllPoints(tk.UIParent);
    window = gui:CreatePanel(window);

    window:SetDevMode(false);  -- shows or hides the red frame info overlays
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
    title:SetText("MAYRONUI GEN5");
    title:SetPoint("BOTTOMLEFT");

    local version = window.info:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    version:SetText(L["VERSION"].." "..GetAddOnMetadata("MUI_Core", "Version"));
    version:SetPoint("BOTTOMLEFT", title, "TOPLEFT", 0, 4);

    window.submenu = gui:CreateDialogBox(window.banner:GetFrame());
    window.submenu:SetAllPoints(window.banner:GetFrame());
    window.submenu:SetAlpha(0);
    window.submenu:Hide();

    -- menu buttons:
    local install = tk.CreateFrame("CheckButton", nil, window.menu:GetFrame());
    install:SetNormalFontObject("GameFontHighlight");
    install:SetText(L["INSTALL"]);
    install:SetPoint("LEFT");
    install:SetCheckedTexture(1);
    install:SetHighlightTexture(1);
    install:SetSize(install:GetFontString():GetWidth() + 50, 30);
    install:SetScript("OnClick", private.OnMenuButtonClick);
    install.type = "Install";

    local custom = tk.CreateFrame("CheckButton", nil, window.menu:GetFrame());
    custom:SetNormalFontObject("GameFontHighlight");
    custom:SetText(L["CUSTOM INSTALL"]);
    custom:SetPoint("LEFT", install, "RIGHT", 40, 0);
    custom:SetCheckedTexture(1);
    custom:SetHighlightTexture(1);
    custom:SetSize(custom:GetFontString():GetWidth() + 50, 30);
    custom:SetScript("OnClick", private.OnMenuButtonClick);
    custom.type = "Custom";

    local info = tk.CreateFrame("CheckButton", nil, window.menu:GetFrame());
    info:SetNormalFontObject("GameFontHighlight");
    info:SetText(L["INFORMATION"]);
    info:SetPoint("LEFT", custom, "RIGHT", 40, 0);
    info:SetCheckedTexture(1);
    info:SetHighlightTexture(1);
    info:SetSize(info:GetFontString():GetWidth() + 50, 30);
    info:SetScript("OnClick", private.OnMenuButtonClick);
    info.type = "Info";

    tk:SetThemeColor(0.5, install, custom, info);

    tk:GroupCheckButtons(install, custom, info);
    window:AddCells(window.menu, window.banner, window.info);
    self.window = window;
    self.window.install = install;
    self.window.custom = custom;
    self.window.info = info;
    tk.UIFrameFadeIn(self.window, 0.3, 0, 1);
end

function setup:Expand()
    if (not setup.window or not setup.expanded) then return; end
    local width, height = setup.window:GetSize();
    if (width >= 900 and height >= 540) then return; end
    setup.window:SetSize(width + 20, height + 12);
    tk.C_Timer.After(0.02, setup.Expand);
end

function setup:Retract()
    if (not setup.window or setup.expanded) then return; end
    local width, height = setup.window:GetSize();
    if (width <= 750 and height <= 450) then return; end
    setup.window:SetSize(width - 20, height - 12);
    tk.C_Timer.After(0.02, setup.Retract);
end

function setup:Install()
    tk.PlaySoundFile("Interface\\AddOns\\MUI_Setup\\install.ogg");

    --db.global.installed = db.global.installed or {}; -- won't work (Observer)
    if (not db.global.installed) then
        db.global.installed = {};
    end

    db.global.installed[tk:GetPlayerKey()] = true;
    MUIdb.global.installed._data = nil; -- to remove old (beta) bug

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
    if (db.profile.chat.enabled["TOPLEFT"]) then
        ChatFrame1:SetPoint("TOPLEFT", tk.UIParent, "TOPLEFT", 34, -55);
    elseif (db.profile.chat.enabled["BOTTOMLEFT"]) then
        ChatFrame1:SetPoint("BOTTOMLEFT", tk.UIParent, "BOTTOMLEFT", 34, 30);
    end

    ChatFrame1:SetHeight(222);
    ChatFrame1:SetWidth(375);
    FCF_SavePositionAndDimensions(ChatFrame1);

    if (not db.global.previously_installed) then
        db.global.previously_installed = true;
        db.global.tutorial = true;
    end

    -- Export AddOn values to db:
    for id, addonData in db.global.core.addons:Iterate() do
        local alias, value, addonName = tk.unpack(addonData);
        
        if (value and tk.IsAddOnLoaded(addonName)) then
            setup.import[addonName]();
            db.global.core.addons[id] = {alias, false, addonName};
        end
    end

    -- MayronUI profiles:
    for id, name in tk:IterateArgs("AuraFrames", "Bartender4", "Bazooka", "Omen", "Recount") do	-- Please keep Bazooka until MUI can handle those minimap icons itself :)
        if (tk._G[name]) then
            local path = tk:GetDBObject(name);
            if (path) then
                if (path:GetCurrentProfile() ~= "MayronUI") then
                    path:SetProfile("MayronUI");
                end
            end
        end
    end

    -- Default Profiles:
    for id, name in tk:IterateArgs("Grid", "ShadowUF", "SimplePowerBar") do
        if (tk._G[name]) then
            local path = tk:GetDBObject(name);
            if (path) then
                if (path:GetCurrentProfile() ~= "Default") then
                    path:SetProfile("Default");
                end
            end
        end
    end

    db.global.reanchor = true;
    ReloadUI();
end

private.content = [[
Thank you for using MayronUI Gen5!

|cff00ccff> SLASH COMMANDS|r
|cff00ccff/mui config|r - Opens up the in-game MayronUI options menu which controls most of the core features in the UI
|cff00ccff/mui install|r - Opens up the Mayron Setup Window (older versions use "/install")
|cff00ccff/rl|r - Reloads the UI
|cff00ccff/tiptac|r - Show TipTac (Tooltips) AddOn settings
|cff00ccff/ltp|r - Leatrix Plus settings (I recommend looking through them!)
|cff00ccff/af|r - Aura Frames AddOn (for buffs and debuffs)
|cff00ccff/suf|r - Settings for the Unit Frames (Shadowed Unit Frames)
|cff00ccff/bt|r - Bartender Settings (Action Bars)
|cff00ccff/fs|r - Shows Blizzard's FrameStack window.

|cff00ccff> F.A.Q's|r
|cff00ccffQ: How do I open up the Calendar? / How do I toggle the Tracker?|r

|cff90ee90A:|r You need to right click on the mini-map and select the option to do this in the drop down menu.

|cff00ccffQ: How can I see more action bars on the bottom of the UI like in the screen shots?|r

|cff90ee90A:|r You need to press and hold the Control key while out of combat to show the Expand and Retract button and then press that.

|cff00ccffQ: How do I enable the Timestamps on the Chat Box?|r

|cff90ee90A:|r I removed this feature when Blizzard added this themselves in the Blizzard Interface Options. Go to the Interface in-game menu and go to "Social" then there is a drop down menu with the title "Chat Timestamps". Change this from "None" to a format that suits you.

|cff00ccffQ: How do I turn off/on Auto Quest? Or how do I turn on auto repair?|r

|cff90ee90A:|r That is controlled by Leatrix Plus (Leatrix Plus also offers many other useful features and is worth checking out!). You can open the Leatrix Plus menu to view these by right clicking the Minimap and selecting Leatrix Plus or by typing "/ltp".

|cff00ccffQ: How do you move the buffs and debuffs in the top right corner of the screen?|r

|cff90ee90A:|r Type "/af" to get into the Aura Frames Configuration window and at the top right of the window's frame that shows up, next to the cross to close down the window there is a button on the left of it. If you click that, you can move the buffs and debuffs.

|cff00ccffQ: The tooltip shows over my spells when I hover my mouse cursor over them, how can I move it to the Bottom Right corner like the other tooltips do?|r

|cff90ee90A:|r Type "/tiptac" and go to the Anchors page from the list on the left. Where it says "Frame Tip Type" you will see a drop down menu on the right. Change it from "Mouse Anchor" to "Normal Anchor".
]]
