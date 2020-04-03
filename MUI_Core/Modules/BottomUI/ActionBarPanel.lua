-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

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
    bartender = {
        control   = true,
        -- 1 and 2 = bottom bartender action bars
        -- 3 and 4 = expanded, extra bartender action bars
        -- values are the bartender bar IDs
        [1] = "Bar 1";
        [2] = "Bar 7";
        [3] = "Bar 9";
        [4] = "Bar 10";
    };
});

-- local functions ------------------

local function LoadTutorial(panel)
    local frame = tk:PopFrame("Frame", panel);

    frame:SetFrameStrata("TOOLTIP");
    frame:SetSize(250, 130);
    frame:SetPoint("BOTTOM", panel, "TOP", 0, 100);

    gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, nil, frame);
    gui:AddCloseButton(tk.Constants.AddOnStyle, frame);
    gui:AddArrow(tk.Constants.AddOnStyle, frame, "DOWN");

    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    frame.text:SetWordWrap(true);
    frame.text:SetPoint("TOPLEFT", 20, -20);
    frame.text:SetPoint("BOTTOMRIGHT", -20, 10);
    frame.text:SetText(tk.Strings:JoinWithSpace(
        "Press and hold the", tk.Strings:SetTextColorByTheme("Control"),
        "key while out of combat to show an arrow button.\n\n Clicking this will show a second row of action buttons."));

    em:CreateEventHandler("MODIFIER_STATE_CHANGED", function(self)
        if (tk:IsModComboActive("C")) then
            frame.text:SetText("You can repeat this step at any time (while out of combat) to hide it.");
            frame:SetHeight(90);

            if (not frame:IsShown()) then
                UIFrameFadeIn(frame, 0.5, 0, 1);
                frame:Show();
            end

            db.global.tutorial = nil;
            self:Destroy();
        end
    end);
end

local function ToggleBartenderBar(controlBartender, bt4Bar, show)
    if (IsAddOnLoaded("Bartender4") and controlBartender) then
        bt4Bar:SetConfigAlpha((show and 1) or 0);
        bt4Bar:SetVisibilityOption("always", not show);
    end
end

-- C_ActionBarPanel -----------------

function C_ActionBarPanel:OnInitialize(data, containerModule)
    data.containerModule = containerModule;

    self:RegisterUpdateFunctions(db.profile.actionBarPanel, {
        expanded = function()
            data.panel:GetScript("OnShow")();
        end;

        retractHeight = function(value)
            if (not data.settings.expanded) then
                data.panel:SetHeight(value);
            end

            data.slideController:SetMinHeight(value);
        end;

        expandHeight = function(value)
            if (data.settings.expanded) then
                data.panel:SetHeight(value);
            end

            data.slideController:SetMaxHeight(value);
        end;

        animateSpeed = function(value)
            data.slideController:SetStepValue(value);
        end;

        texture = function(value)
            data.panel:SetGridTexture(value);
        end;

        cornerSize = function(value)
            data.panel:SetGridCornerSize(value);
        end;

        bartender = {
            control = function()
                self:SetUpAllBartenderBars();
            end;

            [1] = function(bartenderBarID)
                self:SetUpBartenderBar(1, bartenderBarID);
            end;

            [2] = function(bartenderBarID)
                self:SetUpBartenderBar(2, bartenderBarID);
            end;

            [3] = function(bartenderBarID)
                self:SetUpBartenderBar(3, bartenderBarID);
            end;

            [4] = function(bartenderBarID)
                self:SetUpBartenderBar(4, bartenderBarID);
            end;
        };
    });

    if (data.settings.enabled) then
        self:SetEnabled(true);
    end
end

function C_ActionBarPanel:OnDisable(data)
    if (data.panel) then
        data.panel:Hide();
        data.containerModule:RepositionContent();
        return;
    end
end

function C_ActionBarPanel:OnEnable(data)
    if (data.panel) then
        data.panel:Show();
        data.containerModule:RepositionContent();
        return;
    end

    data.panel = CreateFrame("Frame", "MUI_ActionBarPanel", _G["MUI_BottomContainer"]);

    em:CreateEventHandler("PLAYER_LOGOUT", function()
        db.profile.actionBarPanel.expanded = data.settings.expanded;
    end);

    data.panel:SetFrameLevel(10);
    data.slideController = SlideController(data.panel);

    data.panel:SetScript("OnShow", function()
        if (not (data.Bar3 and data.Bar4)) then
            return;
        end

        local controlBartender = data.settings.bartender.control;

        if (data.settings.expanded) then
            data.panel:SetHeight(data.settings.expandHeight);
            ToggleBartenderBar(controlBartender, data.Bar3, true);
            ToggleBartenderBar(controlBartender, data.Bar4, true);
        else
            data.panel:SetHeight(data.settings.retractHeight);
            ToggleBartenderBar(controlBartender, data.Bar3, false);
            ToggleBartenderBar(controlBartender, data.Bar4, false);
        end
    end);

    data.slideController:OnStartExpand(function()
        local controlBartender = data.settings.bartender.control;
        ToggleBartenderBar(controlBartender, data.Bar3, true);
        ToggleBartenderBar(controlBartender, data.Bar4, true);

        if (controlBartender) then
            UIFrameFadeIn(data.Bar3, 0.3, 0, 1);
            UIFrameFadeIn(data.Bar4, 0.3, 0, 1);
        end
    end, 5);

    data.slideController:OnStartRetract(function()
        if (data.settings.bartender.control) then
            UIFrameFadeOut(data.Bar3, 0.1, 1, 0);
            UIFrameFadeOut(data.Bar4, 0.1, 1, 0);
        end
    end);

    data.slideController:OnEndRetract(function()
        ToggleBartenderBar(data.settings.bartender.control, data.Bar3, false);
        ToggleBartenderBar(data.settings.bartender.control, data.Bar4, false);
    end);

    gui:CreateGridTexture(data.panel, data.settings.texture,
        data.settings.cornerSize, nil, 749, 45);

    -- expand button:
    local expandBtn = gui:CreateButton(tk.Constants.AddOnStyle, data.panel, _G["MUI_BottomContainer"]);
    expandBtn:SetFrameStrata("HIGH");
    expandBtn:SetFrameLevel(20);
    expandBtn:SetSize(120, 28);
    expandBtn:SetBackdrop(tk.Constants.backdrop);
    expandBtn:SetBackdropBorderColor(0, 0, 0);
    expandBtn:SetPoint("BOTTOM", data.panel, "TOP", 0, -1);
    expandBtn:Hide();

    expandBtn:SetScript("OnEnter", function(self)
        local r, g, b = self.icon:GetVertexColor();
        self.icon:SetVertexColor(r * 1.2, g * 1.2, b * 1.2);
    end);

    expandBtn:SetScript("OnLeave", function(self)
        tk:ApplyThemeColor(self.icon);
    end);

    expandBtn.icon = expandBtn:CreateTexture(nil, "OVERLAY");
    expandBtn.icon:SetSize(16, 10);
    expandBtn.icon:SetPoint("CENTER");
    expandBtn.icon:SetTexture(tk:GetAssetFilePath("Textures\\BottomUI\\Arrow"));
    tk:ApplyThemeColor(expandBtn.icon);

    local normalTexture = expandBtn:GetNormalTexture();
    normalTexture:SetVertexColor(0.15, 0.15, 0.15, 1);

    expandBtn.glow = expandBtn:CreateTexture(nil, "BACKGROUND");
    expandBtn.glow:SetTexture(tk:GetAssetFilePath("Textures\\BottomUI\\GlowEffect"));
    expandBtn.glow:SetSize(db.profile.bottomui.width, 80);
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
            expandBtn.icon:SetTexCoord(0, 1, 1, 0);
        else
            expandBtn.icon:SetTexCoord(1, 0, 0, 1);
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
        LoadTutorial(data.panel);
    end
end

function C_ActionBarPanel:GetPanel(data)
    return data.panel;
end

function C_ActionBarPanel:SetUpBartenderBar(data, barID, bartenderBarID)
    if (not (IsAddOnLoaded("Bartender4") and data.settings.bartender.control)) then
        return;
    end

    local barId = string.match(bartenderBarID, "Bar (%d+)");

    -- get bar
    _G.Bartender4:GetModule("ActionBars"):EnableBar(barId);

    local globalBartenderName = string.format("BT4Bar%d", barId);
    local bar = _G[globalBartenderName];

    -- calculate height:
    local height = 0;
    local resourceBarsModule = MayronUI:ImportModule("BottomUI_ResourceBars");
    local dataTextModule = MayronUI:ImportModule("DataTextModule");

    if (resourceBarsModule and resourceBarsModule:IsEnabled()) then
        height = resourceBarsModule:GetHeight() - 3;
    end

    if (dataTextModule and dataTextModule:IsShown()) then
        local dataTextBar = dataTextModule:GetDataTextBar();
        height = height + ((dataTextBar and dataTextBar:GetHeight()) or 0);
    end

    if (barID <= 2) then
        ToggleBartenderBar(data.settings.bartender.control, bar, true);
        bar.config.position.y = 39 + height;
    else
        bar.config.position.y = 74 + height;

        -- Bar 3 and 4 are needed for expanding/retracting
        local barName = string.format("Bar%d", tostring(barID));
        data[barName] = bar;
    end

    bar:LoadPosition();
end

function C_ActionBarPanel:SetUpAllBartenderBars(data)
    for i = 1, 4 do
        self:SetUpBartenderBar(i, data.settings.bartender[i]);
    end
end