-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetAllComponents(); -- luacheck: ignore
local Private = {};

local CreateFrame, InCombatLockdown, PlaySound = _G.CreateFrame, _G.InCombatLockdown, _G.PlaySound;
local UIFrameFadeIn, UIFrameFadeOut = _G.UIFrameFadeIn, _G.UIFrameFadeOut;
local IsAddOnLoaded = _G.IsAddOnLoaded;

-- Register and Import Modules -----------

local C_ActionBarPanel = MayronUI:RegisterModule("BottomUI_ActionBarPanel", "Action Bar Panel", true);
local SlideController = gui.WidgetsPackage:Get("SlideController");

-- Load Database Defaults ----------------

db:AddToDefaults("profile.actionBarPanel", {
    enabled         = true;
    expanded        = false;
    modKey          = "C";
    retractHeight   = 44;
    expandHeight    = 80;
    animateSpeed    = 6;
    texture         = tk:GetAssetFilePath("Textures\\BottomUI\\ActionBarPanel");
    cornerSize      = 20;

    -- second row (both bar 9 and 10 are used to make the 2nd row (20 buttons)
    bartender = {
        control   = true,
        [1]       = "Bar 1";
        [2]       = "Bar 7";
        [3]       = "Bar 9";
        [4]       = "Bar 10";
    };
});

-- C_ActionBarPanel -----------------

function C_ActionBarPanel:OnInitialize(data, buiContainer, subModules)
    data.buiContainer = buiContainer;
    data.ResourceBars = subModules.ResourceBars;
    data.DataText = subModules.DataText;
    Private.data = data;

    data.settings = db.profile.actionBarPanel:GetUntrackedTable();
    data.updateFunctions = {
        enabled = function(value)
            data.settings.enabled = value;
            self:SetEnabled(value);
        end;

        expanded = function(value)
            data.settings.expanded = value;
            data.panel:GetScript("OnShow")();
        end;

        modKey = function(value)
            data.settings.modKey = value;
        end;

        retractHeight = function(value)
            data.settings.retractHeight = value;

            if (not data.settings.expanded) then
                data.panel:SetHeight(value);
            end

            data.slideController:SetMinHeight(value);
        end;

        expandHeight = function(value)
            data.settings.expandHeight = value;

            if (data.settings.expanded) then
                data.panel:SetHeight(value);
            end

            data.slideController:SetMaxHeight(value);
        end;

        animateSpeed = function(value)
            data.settings.animateSpeed = value;

            data.slideController:SetStepValue(value);
        end;

        texture = function(value)
            data.settings.texture = value;
            data.pane:SetGridTexture(value);
        end;

        cornerSize = function(value)
            data.settings.cornerSize = value;
            data.pane:SetGridCornerSize(value);
        end;

        bartender = {
            control = function(value)
                data.settings.bartender.control = value;
                self:SetupBartenderBars(value);
            end;

            [1] = function(value)
                data.settings.bartender[1]  = value;
                self:SetupBartenderBars(value);
            end;

            [2] = function(value)
                data.settings.bartender[2]  = value;
                self:SetupBartenderBars(value);
            end;

            [3] = function(value)
                data.settings.bartender[3]  = value;
                self:SetupBartenderBars(value);
            end;

            [4] = function(value)
                data.settings.bartender[4]  = value;
                self:SetupBartenderBars(value);
            end;
        };
    };

    db:RegisterUpdateFunctions("profile.actionBarPanel", data.updateFunctions, function(func, value)
        if (self:IsEnabled() or func == data.updateFunctions.enabled) then
            func(value);
        end
    end);
end

function C_ActionBarPanel:OnEnable(data)
    if (data.panel) then
        return;
    end

    local barsContainer = data.ResourceBars:GetBarContainer();
    data.panel = CreateFrame("Frame", "MUI_ActionBarPanel", data.buiContainer);
    data.panel:SetPoint("BOTTOMLEFT", barsContainer, "TOPLEFT", 0, -1);
    data.panel:SetPoint("BOTTOMRIGHT", barsContainer, "TOPRIGHT", 0, -1);
    data.panel:SetFrameLevel(10);

    -- Must be called each time it is shown to avoid AFK bug
    data.panel:SetScript("OnShow", function()
        if (data.settings.expanded) then
            data.panel:SetHeight(data.settings.expandHeight);
            Private:ToggleBartenderBar(data.BT4Bar3, true);
            Private:ToggleBartenderBar(data.BT4Bar4, true);
        else
            data.panel:SetHeight(data.settings.retractHeight);
            Private:ToggleBartenderBar(data.BT4Bar3, false);
            Private:ToggleBartenderBar(data.BT4Bar4, false);
        end
    end);

    data.panel:GetScript("OnShow")();

    data.slideController = SlideController(data.panel);

    data.slideController:OnStartExpand(function()
        Private:ToggleBartenderBar(data.BT4Bar3, true);
        Private:ToggleBartenderBar(data.BT4Bar4, true);
        UIFrameFadeIn(data.BT4Bar3, 0.3, 0, 1);
        UIFrameFadeIn(data.BT4Bar4, 0.3, 0, 1);
    end, 5);

    data.slideController:OnStartRetract(function()
        UIFrameFadeOut(data.BT4Bar3, 0.1, 1, 0);
        UIFrameFadeOut(data.BT4Bar4, 0.1, 1, 0);
    end);

    data.slideController:OnEndRetract(function()
        Private:ToggleBartenderBar(data.BT4Bar3, false);
        Private:ToggleBartenderBar(data.BT4Bar4, false);
    end);

    gui:CreateGridTexture(data.panel, data.settings.texture,
        data.settings.cornerSize, nil, 749, 45);

    -- expand button:
    local expandBtn = gui:CreateButton(tk.Constants.AddOnStyle, data.panel, " ");
    expandBtn:SetFrameStrata("HIGH");
    expandBtn:SetFrameLevel(20);
    expandBtn:SetSize(140, 20);
    expandBtn:SetBackdrop(tk.Constants.backdrop);
    expandBtn:SetBackdropBorderColor(0, 0, 0);
    expandBtn:SetPoint("BOTTOM", data.panel, "TOP", 0, -1);
    expandBtn:Hide();

    local normalTexture = expandBtn:GetNormalTexture();
    normalTexture:ClearAllPoints();
    normalTexture:SetPoint("TOPLEFT", 1, -1);
    normalTexture:SetPoint("BOTTOMRIGHT", -1, 1);

    local highlightTexture = expandBtn:GetHighlightTexture();
    highlightTexture:ClearAllPoints();
    highlightTexture:SetPoint("TOPLEFT", 1, -1);
    highlightTexture:SetPoint("BOTTOMRIGHT", -1, 1);

    expandBtn.glow = expandBtn:CreateTexture(nil, "BACKGROUND");
    expandBtn.glow:SetTexture(tk:GetAssetFilePath("Textures\\BottomUI\\GlowEffect"));
    expandBtn.glow:SetSize(db.profile.bottomui.width, 60);
    expandBtn.glow:SetBlendMode("ADD");
    expandBtn.glow:SetPoint("BOTTOM", 0, 1);
    tk:ApplyThemeColor(expandBtn.glow);

    local glowScaler = expandBtn.glow:CreateAnimationGroup();

    glowScaler.anim = glowScaler:CreateAnimation("Scale");
    glowScaler.anim:SetOrigin("BOTTOM", 0, 0);
    glowScaler.anim:SetDuration(0.4);
    glowScaler.anim:SetFromScale(0, 0);
    glowScaler.anim:SetToScale(1, 1);

    local expandBtnFader = expandBtn:CreateAnimationGroup();
    expandBtnFader.anim = expandBtnFader:CreateAnimation("Alpha");
    expandBtnFader.anim:SetSmoothing("OUT");
    expandBtnFader.anim:SetDuration(0.2);
    expandBtnFader.anim:SetFromAlpha(0);
    expandBtnFader.anim:SetToAlpha(1);

    expandBtn:SetScript("OnClick", function(self)
        self:Hide();

        if (InCombatLockdown()) then
            return;
        end

        PlaySound(tk.Constants.CLICK);

        local expanded = data.settings.expanded;

        if (expanded) then
            data.slideController:Start(SlideController.Static.FORCE_RETRACT);
        else
            data.slideController:Start(SlideController.Static.FORCE_EXPAND);
        end

        data.settings.expanded = not expanded;
    end);

    expandBtnFader:SetScript("OnFinished", function()
        expandBtn:SetAlpha(1);
    end);

    expandBtnFader:SetScript("OnPlay", function()
        expandBtn:Show();
        expandBtn:SetAlpha(0);
    end);

    em:CreateEventHandler("MODIFIER_STATE_CHANGED", function()
        if (not tk:IsModComboActive(data.settings.modKey) or InCombatLockdown()) then
            expandBtn:Hide();
            return;
        end

        if (data.settings.expanded) then
            expandBtn:SetText("Retract");
        else
            expandBtn:SetText("Expand");
        end

        -- force call OnFinished callback
        expandBtnFader:Stop();

        glowScaler:Play();
        expandBtnFader:Play();
    end);

    em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
        expandBtn:Hide();
    end);

    if (db.global.tutorial) then
        Private:LoadTutorial();
    end
end

function C_ActionBarPanel:GetPanel(data)
    return data.panel;
end
function C_ActionBarPanel:SetupBartenderBars(data, bartenderControl)
    if (not (IsAddOnLoaded("Bartender4") and bartenderControl)) then
        return;
    end

    local height = data.ResourceBars:GetHeight() - 3;
    local dataTextModule = MayronUI:ImportModule("DataText");

    if (dataTextModule and dataTextModule:IsShown()) then
        local bar = dataTextModule:GetDataTextBar();
        height = height + ((bar and bar:GetHeight()) or 0);
    end

    for i = 1, 4 do
        local bt4BarNumber = data.settings.bartender[i]:match("%d+");
        _G.Bartender4:GetModule("ActionBars"):EnableBar(bt4BarNumber);

        local barName = string.format("BT4Bar%d", tostring(bt4BarNumber));
        local bar = _G[barName]; -- TODO: is bar and bar the same?
        data[barName] = bar;

        if (i <= 2) then
            Private:ToggleBartenderBar(bar, true);
            bar.config.position.y = 39 + height;
        else
            bar.config.position.y = 74 + height;
        end

        bar:LoadPosition();
    end
end

-- Private Functions ---------------

function Private:LoadTutorial()
    local frame = tk:PopFrame("Frame", self.data.panel);

    frame:SetFrameStrata("TOOLTIP");
    frame:SetSize(250, 130);
    frame:SetPoint("BOTTOM", self.data.panel, "TOP", 0, 100);

    gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, nil, frame);
    gui:AddCloseButton(tk.Constants.AddOnStyle, frame);
    gui:AddArrow(tk.Constants.AddOnStyle, frame, "DOWN");

    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    frame.text:SetWordWrap(true);
    frame.text:SetPoint("TOPLEFT", 10, -20);
    frame.text:SetPoint("BOTTOMRIGHT", -10, 10);
    frame.text:SetText(
        tk.Strings:JoinWithSpace("Press and hold the", tk.Strings:SetTextColorByTheme("Control"),
            "key while out of combat to show the", tk.Strings:SetTextColorByTheme("Expand"),
            "button.\n\n Click the Expand button to show a second row of action buttons!")
    );

    em:CreateEventHandler("MODIFIER_STATE_CHANGED", function(self)
        if (tk:IsModComboActive("C")) then
            frame.text:SetText(
                tk.Strings:JoinWithSpace("Once expanded, you can press and hold the same key while out of",
                    "combat to show the", tk.Strings:SetTextColorByTheme("Retract"),
                    "button.\n\n Pressing this will hide the second row of action buttons.")
            );

            if (not frame:IsShown()) then
                UIFrameFadeIn(frame, 0.5, 0, 1);
                frame:Show();
            end

            db.global.tutorial = nil;
            self:Destroy();
        end
    end);
end

function Private:ToggleBartenderBar(bt4Bar, show)
    if (IsAddOnLoaded("Bartender4") and self.data.settings.bartender.control) then
        bt4Bar:SetConfigAlpha((show and 1) or 0);
        bt4Bar:SetVisibilityOption("always", not show);
    end
end