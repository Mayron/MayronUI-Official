local addOnName, namespace = ...;

-- Setup Namespace ----------------------
local em = namespace.EventManager;
local tk = namespace.Toolkit;
local db = namespace.Database;
local gui = namespace.GUIBuilder;
local obj = namespace.Objects;
local L = namespace.Locale;

-- Register and Import Modules -----------

local ActionBarPanelModule, ActionBarPanel = MayronUI:RegisterModule("BottomUI_ActionBarPanel", true);
local SlideController = gui.WidgetsPackage:Get("SlideController");

-- Load Database Defaults ----------------

db:AddToDefaults("profile.actionBarPanel", {
    enabled = true,
    expanded = false,
    modKey = "C",
    retractHeight = 44,
    expandHeight = 80,
    animateSpeed = 6,
    alpha = 1,
    texture = tk.Constants.MEDIA.."bottom_ui\\actionbar_panel",

    -- second row (both bar 9 and 10 are used to make the 2nd row (20 buttons)
    bartender = {
        control = true,
        [1] = "Bar 1",
        [2] = "Bar 7",
        [3] = "Bar 9",
        [4] = "Bar 10",
    }
});

-- Local Functions -----------------------

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
    frame.text:SetPoint("TOPLEFT", 10, -20);
    frame.text:SetPoint("BOTTOMRIGHT", -10, 10);
    frame.text:SetText(
        "Press and hold the "..tk:GetThemeColoredText("Control").." key while out of "..
                "combat to show the "..tk:GetThemeColoredText("Expand").." button.\n\n"..
                "Click the Expand button to show a second row of action buttons!"
    );
   
    em:CreateEventHandler("MODIFIER_STATE_CHANGED", function(self)
        if (tk:IsModComboActive("C")) then
            frame.text:SetText(
                "Once expanded, you can press and hold the same key while out of "..
                        "combat to show the "..tk:GetThemeColoredText("Retract").." button.\n\n"..
                        "Pressing this will hide the second row of action buttons."
            );

            if (not frame:IsShown()) then
                tk.UIFrameFadeIn(frame, 0.5, 0, 1);
                frame:Show();
            end

            db.global.tutorial = nil;
            self:Destroy();
        end
    end);
end

local function ToggleBartenderBar(btBar, show, bartenderControl)
    if (tk.IsAddOnLoaded("Bartender4") and bartenderControl) then
        btBar:SetConfigAlpha((show and 1) or 0);
        btBar:SetVisibilityOption("always", not show);
    end
end

-- ActionBarPanel Module ----------------- 

ActionBarPanelModule:OnInitialize(function(self, data, buiContainer, subModules)
    data.sv = db.profile.actionBarPanel;
    data.bartenderControl = data.sv.bartender.control;
    data.buiContainer = buiContainer;
    data.ResourceBars = subModules.ResourceBars;
    data.DataText = subModules.DataText;

    if (data.sv.enabled) then
        self:SetEnabled(true);
    end    
end);

ActionBarPanelModule:OnEnable(function(self, data)
    if (data.panel) then 
        return; 
    end

    local barsContainer = data.ResourceBars:GetBarContainer();
    data.panel = tk.CreateFrame("Frame", "MUI_ActionBarPanel", data.buiContainer);    
    data.panel:SetPoint("BOTTOMLEFT", barsContainer, "TOPLEFT", 0, -1);
    data.panel:SetPoint("BOTTOMRIGHT", barsContainer, "TOPRIGHT", 0, -1);
    data.panel:SetFrameLevel(10);

    self:SetBartenderBars();

    if (data.sv.expanded) then
        data.panel:SetHeight(data.sv.expandHeight);
        ToggleBartenderBar(data.BTBar3, true, data.bartenderControl);
        ToggleBartenderBar(data.BTBar4, true, data.bartenderControl);
    else
        data.panel:SetHeight(data.sv.retractHeight);
        ToggleBartenderBar(data.BTBar3, false, data.bartenderControl);
        ToggleBartenderBar(data.BTBar4, false, data.bartenderControl);
    end

    data.slideController = SlideController(data.panel);
    data.slideController:SetMinHeight(data.sv.retractHeight);
    data.slideController:SetMaxHeight(data.sv.expandHeight);
    data.slideController:SetStepValue(data.sv.animateSpeed);

    data.slideController:OnStartExpand(function()
        ToggleBartenderBar(data.BTBar3, true, data.bartenderControl);
        ToggleBartenderBar(data.BTBar4, true, data.bartenderControl);
        tk.UIFrameFadeIn(data.BTBar3, 0.3, 0, 1);
        tk.UIFrameFadeIn(data.BTBar4, 0.3, 0, 1);
    end, 5);

    data.slideController:OnStartRetract(function()
        tk.UIFrameFadeOut(data.BTBar3, 0.1, 1, 0);
        tk.UIFrameFadeOut(data.BTBar4, 0.1, 1, 0);
    end);

    data.slideController:OnEndRetract(function()
        ToggleBartenderBar(data.BTBar3, false, data.bartenderControl);
        ToggleBartenderBar(data.BTBar4, false, data.bartenderControl);
    end);

    gui:CreateGridTexture(data.panel, data.sv.texture, 20, nil, 749, 45);

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
    expandBtn.glow:SetTexture(tk.Constants.MEDIA.."bottom_ui\\glow");
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

        if (tk.InCombatLockdown()) then 
            return; 
        end

        tk.PlaySound(tk.Constants.CLICK);

        local expanded = data.sv.expanded;

        if (expanded) then
            data.slideController:Start(SlideController.Static.FORCE_RETRACT);
        else
            data.slideController:Start(SlideController.Static.FORCE_EXPAND);
        end

        data.sv.expanded = not expanded;
    end);

    expandBtnFader:SetScript("OnFinished", function()
        expandBtn:SetAlpha(1);
    end);

    expandBtnFader:SetScript("OnPlay", function()
        expandBtn:Show();
        expandBtn:SetAlpha(0);
    end);

    em:CreateEventHandler("MODIFIER_STATE_CHANGED", function()
        if (not tk:IsModComboActive(data.sv.modKey) or tk.InCombatLockdown()) then
            expandBtn:Hide();
            return;
        end

        if (data.sv.expanded) then
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
        LoadTutorial(data.panel);        
    end
end);

-- ActionBarPanel Object ----------------------

function ActionBarPanel:GetPanel(data)
    return data.panel;
end

function ActionBarPanel:PositionBartenderBars(data)
    if (not (data.BTBar1 or data.BTBar2 or data.BTBar3 or data.BTBar4)) then 
        return; 
    end

    if (tk.IsAddOnLoaded("Bartender4") and data.bartenderControl) then
        local height = data.ResourceBars:GetHeight() - 3;
        local dataTextModule = MayronUI:ImportModule("DataText");        

        if (dataTextModule and dataTextModule:IsShown()) then
            local bar = dataTextModule:GetFrame();
            height = height + ((bar and bar:GetHeight()) or 0);
        end                

        data.BTBar1.config.position.y = 39 + height;
        data.BTBar2.config.position.y = 39 + height;
        data.BTBar3.config.position.y = 74 + height;
        data.BTBar4.config.position.y = 74 + height;
        data.BTBar1:LoadPosition();
        data.BTBar2:LoadPosition();
        data.BTBar3:LoadPosition();
        data.BTBar4:LoadPosition();
    end
end

function ActionBarPanel:SetBartenderBars(data)
    if (tk.IsAddOnLoaded("Bartender4") and data.bartenderControl) then

        local bar1 = data.sv.bartender[1]:match("%d+");
        local bar2 = data.sv.bartender[2]:match("%d+");
        local bar3 = data.sv.bartender[3]:match("%d+");
        local bar4 = data.sv.bartender[4]:match("%d+");

        Bartender4:GetModule("ActionBars"):EnableBar(bar1);
        Bartender4:GetModule("ActionBars"):EnableBar(bar2);
        Bartender4:GetModule("ActionBars"):EnableBar(bar3);
        Bartender4:GetModule("ActionBars"):EnableBar(bar4);

        data.BTBar1 = tk._G["BT4Bar"..tk.tostring(bar1)];
        data.BTBar2 = tk._G["BT4Bar"..tk.tostring(bar2)];
        data.BTBar3 = tk._G["BT4Bar"..tk.tostring(bar3)];
        data.BTBar4 = tk._G["BT4Bar"..tk.tostring(bar4)];

        ToggleBartenderBar(data.BTBar1, true, data.bartenderControl);
        ToggleBartenderBar(data.BTBar2, true, data.bartenderControl);

        self:PositionBartenderBars();
    end
end