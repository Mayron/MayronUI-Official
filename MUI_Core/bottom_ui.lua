------------------------
-- Setup namespaces
------------------------
local _, core = ...;
local em = core.EventManager;
local tk = core.Toolkit;
local db = core.Database;
local gui = core.GUI_Builder;
local L = LibStub ("AceLocale-3.0"):GetLocale ("MayronUI");

local bui = {};
bui.ActionBar_Panel = {};
bui.Unit_Panels = {};
bui.Resources = {};

bui.Resources.REPUTATION_BAR_ID = "Reputation";
bui.Resources.EXPERIENCE_BAR_ID = "XP";
bui.Resources.ARTIFACT_BAR_ID = "Artifact";

bui.Resources.bar_names = {"Artifact", "Reputation", "XP"};
local private = {};

local ab = bui.ActionBar_Panel;
local unit = bui.Unit_Panels;
local dt = MayronUI:ImportModule("DataText");
MayronUI:RegisterModule("BottomUI", bui);

------------------------
------------------------
db:AddToDefaults("profile.bottomui", {
    width = 750,
    xpBar = {
        enabled = true,
        height = 8,
        show_text = false,
        font_size = 10,
    },
    reputationBar = {
        enabled = true,
        height = 8,
        show_text = false,
        font_size = 10,
    },
    artifactBar = {
        enabled = true,
        height = 8,
        show_text = false,
        font_size = 10,
    },
    unit_panels = {
        enabled = true,
        control_SUF = true,
        control_Grid = true,
        unit_width = 325,
        height = 75,
        classicMode = false,
        alpha = 0.8,
        unit_names = {
            width = 235,
            height = 20,
            fontSize = 11,
            target_class_colored = true,
            xOffset = 24,
        }
    },
    gradients = {
        enabled = true,
        height = 24,
        target_class_colored = true,
    },
    actionbar_panel = {
        enabled = true,
        expanded = false,
        mod_key = "C",
        retract_height = 44,
        expand_height = 80,
        animate_speed = 6,
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
    }
});

---------------------------
-- SUF Functions
---------------------------
local function UnAnchorSUF()
    local currentProfile = ShadowUF.db:GetCurrentProfile();
    local SUF = ShadowedUFDB["profiles"][currentProfile]["positions"]["targettarget"];
    SUF["point"] = "TOP"; SUF["anchorTo"] = "UIParent";
    SUF["relativePoint"] = "TOP"; SUF["x"] = 0; SUF["y"] = -40;
end

local function ReanchorSUF()
    local currentProfile = ShadowUF.db:GetCurrentProfile();
    local anchorTo = "UIParent";
    if (tk._G["MUI_UnitPanelCenter"]) then
        anchorTo = "MUI_UnitPanelCenter";
    end
    local SUF = ShadowedUFDB["profiles"][currentProfile]["positions"]["targettarget"];
    SUF["point"] = "TOP"; SUF["anchorTo"] = anchorTo;
    SUF["relativePoint"] = "TOP"; SUF["x"] = 0; SUF["y"] = -40;
    if (SUFUnitplayer) then
        SUFUnitplayer:SetFrameStrata("MEDIUM");
    end
    if (SUFUnittarget) then
        SUFUnittarget:SetFrameStrata("MEDIUM");
        unit.right:SetFrameStrata("LOW");
    end
    if (SUFUnittargettarget) then
        SUFUnittargettarget:SetFrameStrata("MEDIUM");
    end
    ShadowUF.Layout:Reload();
end

----------------------
-- Unit Panels
----------------------
function unit:UpdateUnitNameText(unit, level)
    local name = UnitName(unit);
    if (#name > 22) then
        name = name:sub(1, 22):trim();
        name = name.."...";
    end
    local level = level or UnitLevel(unit);
    local _, class = UnitClass(unit);
    local classif = UnitClassification(unit);

    if (tk.tonumber(level) < 1) then
        level = "boss";
    elseif (classif == "elite" or classif == "rareelite") then
        level = tk.tostring(level).."+";
    end
    if (classif == "rareelite" or classif == "rare") then
        level = "|cffff66ff"..level.."|r";
    end

    if (unit ~= "player") then
        if (classif == "worldboss") then
            level = tk:GetRGBColoredString(level, 0.25, 0.75, 0.25); -- yellow
        else
            local color = tk:GetDifficultyColor(UnitLevel(unit));
            level = tk:GetRGBColoredString(level, color.r, color.g, color.b);
            name = (UnitIsPlayer(unit) and tk:GetClassColoredString(class, name)) or name;
        end
    else
        level = tk:GetRGBColoredString(level, 1, 0.8, 0);
        if (UnitAffectingCombat("player")) then
            name = tk:GetRGBColoredString(name, 1, 0, 0);
        else
            name = tk:GetClassColoredString(class, name);
        end
    end

    local text = tk.string.format("%s %s", name, level);
    self[unit].text:SetText(text);
end

function unit:SetupSUFPortraitGradients()
    if (not tk.IsAddOnLoaded("ShadowedUnitFrames")) then return; end
    local sv = db.profile.bottomui.gradients;
    if (sv.enabled) then
        self.gradients = self.gradients or {};
        local r, g, b = tk:GetThemeColor();
        for id, unitID in tk:IterateArgs("player", "target") do
            local parent = tk._G["SUFUnit"..unitID];
            if (parent and parent.portrait) then
                local frame = self.gradients[unitID];
                if (not frame) then
                    self.gradients[unitID] = tk.CreateFrame("Frame", nil, parent);
                    frame = self.gradients[unitID];
                    frame:SetPoint("TOPLEFT", 1, -1);
                    frame:SetPoint("TOPRIGHT", -1, -1);
                    frame:SetFrameLevel(5);
                    frame.texture = frame:CreateTexture(nil, "OVERLAY");
                    frame.texture:SetAllPoints(frame);
                    frame.texture:SetColorTexture(1, 1, 1, 1);
                    if (unitID == "target") then
                        em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()
                            if (UnitExists("target")) then
                                local from = sv.from;
                                local to = sv.to;
                                if (UnitIsPlayer("target") and sv.target_class_colored) then
                                    local _, class = UnitClass("target");
                                    class = tk.string.upper(class);
                                    class = class:gsub("%s+", "");
                                    local c = tk.Constants.CLASS_RGB_COLORS[class];
                                    frame.texture:SetGradientAlpha("VERTICAL", to.r, to.g, to.b, to.a,
                                        c.r, c.g, c.b, from.a);
                                else
                                    frame.texture:SetGradientAlpha("VERTICAL", to.r, to.g, to.b, to.a,
                                        from.r, from.g, from.b, from.a);
                                end
                            end
                        end);
                    end
                end
                frame:SetSize(100, sv.height);
                local from = sv.from;
                local to = sv.to;
                if (unitID == "target" and UnitExists("target") and UnitIsPlayer("target")
                        and sv.target_class_colored) then
                    local _, class = UnitClass("target");
                    class = tk.string.upper(class);
                    class = class:gsub("%s+", "");
                    local c = tk.Constants.CLASS_RGB_COLORS[class];
                    frame.texture:SetGradientAlpha("VERTICAL", to.r, to.g, to.b, to.a,
                        c.r, c.g, c.b, from.a);
                else
                    frame.texture:SetGradientAlpha("VERTICAL", to.r, to.g, to.b, to.a,
                        from.r, from.g, from.b, from.a);
                end
                frame:Show();
            elseif (self.gradients[unitID]) then
                self.gradients[unitID]:Hide();
            end
        end
    elseif (self.gradients) then
        for _, frame in tk.pairs(self.gradients) do frame:Hide(); end
    end
end

function unit:init()
    if (self.left) then return; end
    local font = tk.Constants.LSM:Fetch("font", db.global.core.font);

    self.left = tk.CreateFrame("Frame", "MUI_UnitPanelLeft", bui.container);
    self.right = tk.CreateFrame("Frame", "MUI_UnitPanelRight", SUFUnittarget or bui.container);
    self.center = tk.CreateFrame("Frame", "MUI_UnitPanelCenter", self.right);
    self.left:SetFrameStrata("BACKGROUND");
    self.center:SetFrameStrata("BACKGROUND");
    self.right:SetFrameStrata("BACKGROUND");

    self.left:SetSize(self.sv.unit_width, 180);
    self.right:SetSize(self.sv.unit_width, 180);

    if (ab.panel) then
        self.left:SetPoint("TOPLEFT", ab.panel, "TOPLEFT", 0, self.sv.height);
        self.right:SetPoint("TOPRIGHT", ab.panel, "TOPRIGHT", 0, self.sv.height);
    else
        local height = self.sv.height;
        if (dt.bar and dt.bar:IsShown() and dt.sv.enable_module) then
            self.left:SetPoint("TOPLEFT", dt.bar, "TOPLEFT", 0, height);
            self.right:SetPoint("TOPRIGHT", dt.bar, "TOPRIGHT", 0, height);
        else
            self.left:SetPoint("TOPLEFT", bui.Resources.container, "TOPLEFT", 0, height);
            self.right:SetPoint("TOPRIGHT", bui.Resources.container, "TOPRIGHT", 0, height);
        end
    end

    self.center:SetPoint("TOPLEFT", self.left, "TOPRIGHT");
    self.center:SetPoint("TOPRIGHT", self.right, "TOPLEFT");
    self.center:SetPoint("BOTTOMLEFT", self.left, "BOTTOMRIGHT");
    self.center:SetPoint("BOTTOMRIGHT", self.right, "BOTTOMLEFT");
    self.center.bg = tk:SetBackground(self.center, tk.Constants.MEDIA.."bottom_ui\\Center");

    self.player = tk.CreateFrame("Frame", "MUI_PlayerName", self.left);
    self.player:SetPoint("BOTTOMLEFT", self.left, "TOPLEFT", self.sv.unit_names.xOffset, 0);
    self.player:SetSize(self.sv.unit_names.width, self.sv.unit_names.height);
    self.player.bg = tk:SetBackground(self.player, tk.Constants.MEDIA.."bottom_ui\\Names");

    self.player.text = self.player:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.player.text:SetFont(font, self.sv.unit_names.fontSize);
    self.player.text:SetJustifyH("LEFT");
    self.player.text:SetWidth(self.player:GetWidth() - 25);
    self.player.text:SetWordWrap(false);
    self.player.text:SetPoint("LEFT", 15, 0);
    self:UpdateUnitNameText("player");

    if (not tk:IsPlayerMaxLevel()) then
        em:CreateEventHandler("PLAYER_LEVEL_UP", function(_, _, level)
            self:UpdateUnitNameText("player", level);
        end);
    end
    em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
        self:UpdateUnitNameText("player");
    end);
    em:CreateEventHandler("PLAYER_REGEN_ENABLED", function()
        self:UpdateUnitNameText("player");
    end);

    self.target = tk.CreateFrame("Frame", "MUI_TargetName", self.right);
    self.target:SetPoint("BOTTOMRIGHT", self.right, "TOPRIGHT", -self.sv.unit_names.xOffset, 0);
    self.target:SetSize(self.sv.unit_names.width, self.sv.unit_names.height);
    self.target.bg = tk:SetBackground(self.target, tk.Constants.MEDIA.."bottom_ui\\Names");
    self.target.bg:SetTexCoord(1, 0, 0, 1); -- flip horizontally

    self.target.text = self.target:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    self.target.text:SetParent(SUFUnittarget or bui.container);
    self.target.text:SetFont(font, self.sv.unit_names.fontSize);
    self.target.text:SetJustifyH("RIGHT");
    self.target.text:SetWidth(self.target:GetWidth() - 25);
    self.target.text:SetWordWrap(false);
    self.target.text:SetPoint("RIGHT", self.target, "RIGHT", -15, 0);

    em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()
        if (UnitExists("target")) then
            self:UpdateUnitNameText("target");
        end
    end);

    if (not self.sv.classicMode) then
        self.left.bg = tk:SetBackground(self.left, tk.Constants.MEDIA.."bottom_ui\\Single");
        self.right.bg = tk:SetBackground(self.right, tk.Constants.MEDIA.."bottom_ui\\Single");
        if (unit.right:GetParent() == bui.container) then
            self.right:Hide();
        end

        em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()
            if (UnitExists("target")) then
                if (unit.right:GetParent() == bui.container) then
                    unit.right:Show();
                end
                unit.left.bg:SetTexture(tk.Constants.MEDIA.."bottom_ui\\Double");
                unit.right.bg:SetTexture(tk.Constants.MEDIA.."bottom_ui\\Double");
                if (unit.sv.unit_names.target_class_colored) then
                    if (UnitIsPlayer("target")) then
                        local _, class = UnitClass("target");
                        tk:SetClassColoredTexture(class, self.target.bg);
                    else
                        tk:SetThemeColor(self.sv.alpha, self.target.bg);
                    end
                end
            else
                unit.target.text:SetText("");
                if (unit.right:GetParent() == bui.container) then
                    unit.right:Hide();
                end
                unit.left.bg:SetTexture(tk.Constants.MEDIA.."bottom_ui\\Single");
                unit.right.bg:SetTexture(tk.Constants.MEDIA.."bottom_ui\\Single");
            end
        end);
        em:CreateEventHandler("PLAYER_ENTERING_WORLD", function()
            if (not UnitExists("target")) then
                unit.target.text:SetText("");
                if (unit.right:GetParent() == bui.container) then
                    unit.right:Hide();
                end
                unit.left.bg:SetTexture(tk.Constants.MEDIA.."bottom_ui\\Single");
                unit.right.bg:SetTexture(tk.Constants.MEDIA.."bottom_ui\\Single");
            end
        end);
    else
        self.left.bg = tk:SetBackground(self.left, tk.Constants.MEDIA.."bottom_ui\\Double");
        self.right.bg = tk:SetBackground(self.right, tk.Constants.MEDIA.."bottom_ui\\Double");
        self.right:SetParent(bui.container);

        if (unit.sv.unit_names.target_class_colored) then
            em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()
                if (UnitExists("target")) then
                    if (unit.sv.unit_names.target_class_colored) then
                        if (UnitIsPlayer("target")) then
                            local _, class = UnitClass("target");
                            tk:SetClassColoredTexture(class, self.target.bg);
                        else
                            tk:SetThemeColor(self.sv.alpha, self.target.bg);
                        end
                    end
                else
                    tk:SetThemeColor(self.sv.alpha, self.target.bg);
                end
            end);
        end
    end

    tk:SetThemeColor(self.sv.alpha, self.left.bg, self.center.bg, self.right.bg, self.player.bg, self.target.bg);
    self.right.bg:SetTexCoord(1, 0, 0, 1);

    if (tk.IsAddOnLoaded("ShadowedUnitFrames") and self.sv.control_SUF) then
        ReanchorSUF();
        tk.hooksecurefunc(ShadowUF, "ProfilesChanged", ReanchorSUF);
        tk.hooksecurefunc("ReloadUI", UnAnchorSUF);
        em:CreateEventHandler("PLAYER_LOGOUT", UnAnchorSUF);
    end

    if (tk.IsAddOnLoaded("Grid") and self.sv.control_Grid) then
        if (Grid.db:GetCurrentProfile() == "MayronUIH") then
            GridLayoutFrame:ClearAllPoints();
            GridLayoutFrame:SetPoint("BOTTOMRIGHT", self.target, "TOPRIGHT", -9, 0);
        end
        tk.hooksecurefunc(Grid.db, "SetProfile", function()
            if (Grid.db:GetCurrentProfile() == "MayronUIH") then
                GridLayoutFrame:ClearAllPoints();
                GridLayoutFrame:SetPoint("BOTTOMRIGHT", self.target, "TOPRIGHT", -9, 0);
            end
        end);
    end
end

-------------------------------
-- ActionBar Panel
-------------------------------
function ab:PositionBartenderBars()
    if (not (ab.BTBar1 or ab.BTBar2 or ab.BTBar3 or ab.BTBar4)) then return; end
    if (tk.IsAddOnLoaded("Bartender4") and ab.sv.bartender.control) then
        local height = bui.Resources.container:GetHeight() +
                ((dt.bar and dt.bar:IsShown() and dt.bar:GetHeight()) or 0) - 3;
        ab.BTBar1.config.position.y = 39 + height;
        ab.BTBar2.config.position.y = 39 + height;
        ab.BTBar3.config.position.y = 74 + height;
        ab.BTBar4.config.position.y = 74 + height;
        ab.BTBar1:LoadPosition();
        ab.BTBar2:LoadPosition();
        ab.BTBar3:LoadPosition();
        ab.BTBar4:LoadPosition();
    end
end

do
    local function ToggleBartenderBar(bar, show)
        if (tk.IsAddOnLoaded("Bartender4") and ab.sv.bartender.control) then
            bar:SetConfigAlpha((show and 1) or 0);
            bar:SetVisibilityOption("always", not show);
        end
    end

    local function OnRetractEnd()
        ToggleBartenderBar(ab.BTBar3, false);
        ToggleBartenderBar(ab.BTBar4, false);
    end

    local counter = 0;
    local function FadeBarsIn()
        if (not (tk.IsAddOnLoaded("Bartender4") and ab.sv.bartender.control)) then return; end
        counter = counter + 1;
        if (counter > 6) then
            ToggleBartenderBar(ab.BTBar3, true);
            ToggleBartenderBar(ab.BTBar4, true);
            tk.UIFrameFadeIn(ab.BTBar3, 0.3, 0, 1);
            tk.UIFrameFadeIn(ab.BTBar4, 0.3, 0, 1);
        else
            tk.C_Timer.After(0.02, FadeBarsIn);
        end
    end

    function ab:SetBartenderBars()
        if (tk.IsAddOnLoaded("Bartender4") and ab.sv.bartender.control) then
            local bar1 = self.sv.bartender[1]:match("%d+");
            local bar2 = self.sv.bartender[2]:match("%d+");
            local bar3 = self.sv.bartender[3]:match("%d+");
            local bar4 = self.sv.bartender[4]:match("%d+");
            Bartender4:GetModule("ActionBars"):EnableBar(bar1);
            Bartender4:GetModule("ActionBars"):EnableBar(bar2);
            Bartender4:GetModule("ActionBars"):EnableBar(bar3);
            Bartender4:GetModule("ActionBars"):EnableBar(bar4);
            self.BTBar1 = tk._G["BT4Bar"..tk.tostring(bar1)];
            self.BTBar2 = tk._G["BT4Bar"..tk.tostring(bar2)];
            self.BTBar3 = tk._G["BT4Bar"..tk.tostring(bar3)];
            self.BTBar4 = tk._G["BT4Bar"..tk.tostring(bar4)];
            ToggleBartenderBar(self.BTBar1, true);
            ToggleBartenderBar(self.BTBar2, true);
            ab:PositionBartenderBars();
        end
    end

    function ab:init()
        if (self.panel) then return; end

        self.panel = tk.CreateFrame("Frame", "MUI_ActionBarPanel", bui.container);
        self.panel:SetFrameLevel(10);

        self.panel:SetPoint("BOTTOMLEFT", bui.Resources.container, "TOPLEFT", 0, -1);
        self.panel:SetPoint("BOTTOMRIGHT", bui.Resources.container, "TOPRIGHT", 0, -1);

        self:SetBartenderBars();

        if (self.sv.expanded) then
            self.panel:SetHeight(self.sv.expand_height);
            ToggleBartenderBar(self.BTBar3, true);
            ToggleBartenderBar(self.BTBar4, true);
        else
            self.panel:SetHeight(self.sv.retract_height);
            ToggleBartenderBar(self.BTBar3, false);
            ToggleBartenderBar(self.BTBar4, false);
        end

        self.slideController = tk:CreateSlideController(self.panel);
        self.slideController:SetMinHeight(self.sv.retract_height);
        self.slideController:SetMaxHeight(self.sv.expand_height);
        self.slideController:SetStepValue(ab.sv.animate_speed);
        self.slideController:OnEndRetract(OnRetractEnd);

        gui:CreateGridTexture(self.panel, self.sv.texture, 20, nil, 749, 45);

        -- expand button:
        local btn = gui:CreateButton(self.panel, " ", 0.08, 0.08, 0.08, 1);
        btn:SetFrameStrata("HIGH");
        btn:SetFrameLevel(20);
        btn:SetSize(140, 20);
        btn:SetBackdrop(tk.Constants.backdrop);
        btn:SetBackdropBorderColor(0, 0, 0);
        btn.normal:ClearAllPoints();
        btn.normal:SetPoint("TOPLEFT", 1, -1);
        btn.normal:SetPoint("BOTTOMRIGHT", -1, 1);
        btn.highlight:ClearAllPoints();
        btn.highlight:SetPoint("TOPLEFT", 1, -1);
        btn.highlight:SetPoint("BOTTOMRIGHT", -1, 1);
        btn:SetPoint("BOTTOM", self.panel, "TOP", 0, -1);
        btn:Hide();

        btn.glow = btn:CreateTexture(nil, "BACKGROUND");
        tk:SetThemeColor(btn.glow);
        btn.glow:SetTexture(tk.Constants.MEDIA.."bottom_ui\\glow");
        btn.glow:SetSize(db.profile.bottomui.width, 60);
        btn.glow:SetBlendMode("ADD");
        btn.glow:SetPoint("BOTTOM", 0, 1);

        local group = btn.glow:CreateAnimationGroup();
        group.a = group:CreateAnimation("Alpha");
        group.a:SetSmoothing("OUT");
        group.a:SetDuration(0.4);
        group.a:SetFromAlpha(0);
        group.a:SetToAlpha(1);
        group.a:SetStartDelay(0.1);
        group.a2 = group:CreateAnimation("Scale");
        group.a2:SetOrigin("BOTTOM", 0, 0);
        group.a2:SetDuration(0.4);
        group.a2:SetFromScale(0, 0);
        group.a2:SetToScale(1, 1);

        local group2 = btn:CreateAnimationGroup();
        group2.a = group2:CreateAnimation("Alpha");
        group2.a:SetSmoothing("OUT");
        group2.a:SetDuration(0.4);
        group2.a:SetFromAlpha(0);
        group2.a:SetToAlpha(1);

        group:SetScript("OnFinished", function()
            btn.glow:SetAlpha(1);
        end);

        btn:SetScript("OnClick", function(self)
            self:Hide();
            if (tk.InCombatLockdown()) then return; end
            tk.PlaySound(tk.Constants.CLICK);
            if (ab.sv.expanded) then
                ab.slideController:Start(ab.slideController.FORCE_RETRACT);
                if (tk.IsAddOnLoaded("Bartender4") and ab.sv.bartender.control) then
                    ToggleBartenderBar(ab.BTBar3, true);
                    ToggleBartenderBar(ab.BTBar4, true);
                    tk.UIFrameFadeOut(ab.BTBar3, 0.1, 1, 0);
                    tk.UIFrameFadeOut(ab.BTBar4, 0.1, 1, 0);
                end
            else
                counter = 0;
                FadeBarsIn();
                ab.slideController:Start(ab.slideController.FORCE_EXPAND);
            end
            ab.sv.expanded = not ab.sv.expanded;
        end);

        group:SetScript("OnPlay", function()
            btn.glow:SetAlpha(0);
            group2:Play();
        end);

        group2:SetScript("OnFinished", function()
            btn:SetAlpha(1);
        end);

        group2:SetScript("OnPlay", function()
            btn:Show();
            btn:SetAlpha(0);
        end);

        em:CreateEventHandler("MODIFIER_STATE_CHANGED", function()
            if (tk:IsModComboActive(ab.sv.mod_key) and not tk.InCombatLockdown()) then
                if (ab.sv.expanded) then
                    btn:SetText("Retract");
                else
                    btn:SetText("Expand");
                end
                group:Stop();
                group2:Stop();
                group:Play();
            else
                btn:Hide();
            end
        end);

        em:CreateEventHandler("PLAYER_REGEN_DISABLED", function() btn:Hide(); end);

        if (db.global.tutorial) then
            local frame = tk:PopFrame("Frame", ab.panel);
            frame:SetFrameStrata("TOOLTIP");
            frame:SetSize(250, 130);
            gui:CreateDialogBox(nil, nil, frame);
            gui:AddCloseButton(frame);
            gui:AddArrow(frame, "DOWN");
            frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            frame.text:SetWordWrap(true);
            frame.text:SetPoint("TOPLEFT", 10, -20);
            frame.text:SetPoint("BOTTOMRIGHT", -10, 10);
            frame.text:SetText(
                "Press and hold the "..tk:GetThemeColoredString("Control").." key while out of "..
                        "combat to show the "..tk:GetThemeColoredString("Expand").." button.\n\n"..
                        "Click the Expand button to show a second row of action buttons!"
            );
            frame:SetPoint("BOTTOM", ab.panel, "TOP", 0, 100);
            em:CreateEventHandler("MODIFIER_STATE_CHANGED", function(self)
                if (tk:IsModComboActive("C")) then
                    frame.text:SetText(
                        "Once expanded, you can press and hold the same key while out of "..
                                "combat to show the "..tk:GetThemeColoredString("Retract").." button.\n\n"..
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
    end
end

--------------------------------
-- Private Resource Functions
--------------------------------
function private.XPBar_OnSetup(resourceBar, data)
    if (tk:IsPlayerMaxLevel()) then
        bui.Resources:DisableBar(bui.Resources.EXPERIENCE_BAR_ID);
        return;
    end
    data.blizzard_bar = MainMenuExpBar;
    local statusbar = tk.Constants.LSM:Fetch("statusbar", "MUI_StatusBar");
    data.rested = tk.CreateFrame("StatusBar", nil, data.frame);
    data.rested:SetStatusBarTexture(statusbar);
    data.rested:SetPoint("TOPLEFT", 1, -1);
    data.rested:SetPoint("BOTTOMRIGHT", -1, 1);
    data.rested.texture = data.rested:GetStatusBarTexture();
    data.rested.texture:SetVertexColor(0, 0.3, 0.5, 0.3);
    data.rested:SetOrientation("HORIZONTAL");

    local r, g, b = tk:GetThemeColor();
    data.statusbar.texture:SetVertexColor(r * 0.8, g * 0.8, b  * 0.8);

    em:CreateEventHandler("PLAYER_LEVEL_UP", function(handler, _, level)
        if (GetMaxPlayerLevel() == level) then
            bui.Resources:DisableBar(bui.Resources.EXPERIENCE_BAR_ID);
            em:FindHandlerByKey("PLAYER_XP_UPDATE", "xp_bar_update"):Destroy();
            handler:Destroy();
        end
    end);

    local handler = em:CreateEventHandler("PLAYER_XP_UPDATE", function()
        local currentValue = UnitXP("player");
        local maxValue = UnitXPMax("player");
        data.statusbar:SetMinMaxValues(0, maxValue);
        data.statusbar:SetValue(currentValue);
        data.rested:SetMinMaxValues(0, maxValue);

        local exhaustValue = GetXPExhaustion();
        data.rested:SetValue(exhaustValue and (exhaustValue + currentValue) or 0);
        if (data.statusbar.text) then
            local percent = (currentValue / maxValue) * 100;
            currentValue = tk:FormatNumberString(currentValue);
            maxValue = tk:FormatNumberString(maxValue);
            local text = tk.string.format("%s / %s (%d%%)", currentValue, maxValue, percent);
            data.statusbar.text:SetText(text);
        end
    end);
    handler:SetKey("xp_bar_update");
    handler:Run();
end

function private.XPBar_ShowText()
    local handler = em:FindHandlerByKey("PLAYER_XP_UPDATE", "xp_bar_update");
    if (handler) then handler:Run(); end
end

function private.ArtifactBar_OnSetup(resourceBar, data)
    data.blizzard_bar = ArtifactWatchBar;
    data.statusbar.texture = data.statusbar:GetStatusBarTexture();
    data.statusbar.texture:SetVertexColor(0.9, 0.8, 0.6, 1);

    local handler = em:CreateEventHandler("ARTIFACT_XP_UPDATE", function()
        local totalXP, pointsSpent, _, _, _, _, _, _, tier = tk.select(5, C_ArtifactUI.GetEquippedArtifactInfo());
        local _, currentValue, maxValue = ArtifactBarGetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, tier);
        
        data.statusbar:SetMinMaxValues(0, maxValue);
        data.statusbar:SetValue(currentValue);
        if (data.statusbar.text) then
			if currentValue > 0 and maxValue == 0 then maxValue = currentValue end
            local percent = (currentValue / maxValue) * 100;
            currentValue = tk:FormatNumberString(currentValue);
            maxValue = tk:FormatNumberString(maxValue);
            local text = tk.string.format("%s / %s (%d%%)", currentValue, maxValue, percent);
            data.statusbar.text:SetText(text);
        end
    end);
    handler:SetKey("artifact_bar_update");

    em:CreateEventHandler("UNIT_INVENTORY_CHANGED", function()
        local equipped = HasArtifactEquipped();
        if (not equipped and data.enabled) then
            bui.Resources:DisableBar(data.id);
            return;
        elseif (equipped and not data.enabled) then
            bui.Resources:EnableBar(data.id);
        end
        if (equipped) then handler:Run(); end
    end):Run();
end

function private.ArtifactBar_ShowText()
    local handler = em:FindHandlerByKey("ARTIFACT_XP_UPDATE", "artifact_bar_update");
    if (handler) then handler:Run(); end
end

function private.ReputationBar_OnSetup(resourceBar, data)

    data.statusbar:HookScript("OnEnter", function(self)
        local factionName, standingID, minValue, maxValue, currentValue = GetWatchedFactionInfo();
		
        if (standingID < 8) then 
			maxValue = maxValue - minValue;
			
			if (maxValue > 0) then			
				currentValue = currentValue - minValue;
				local percent = (currentValue / maxValue) * 100;
				
				currentValue = tk:FormatNumberString(currentValue);
				maxValue = tk:FormatNumberString(maxValue);
				
				local text = tk.string.format("%s: %s / %s (%d%%)", factionName, currentValue, maxValue, percent);
				
				GameTooltip:SetOwner(self, "ANCHOR_TOP");
				GameTooltip:AddLine(text, 1, 1, 1);
				GameTooltip:Show();
			end
		end
    end);
	
    data.statusbar:HookScript("OnLeave", function(self)
        GameTooltip:Hide();
    end);

    data.statusbar.texture = data.statusbar:GetStatusBarTexture();
    data.statusbar.texture:SetVertexColor(0.16, 0.6, 0.16, 1);

    local handler = em:CreateEventHandlers("UPDATE_FACTION, PLAYER_REGEN_ENABLED", function()
        local factionName, standingID, minValue, maxValue, currentValue = GetWatchedFactionInfo();
		
		if (not InCombatLockdown()) then
			if (not factionName or standingID == 8) then		
				bui.Resources:DisableBar(data.id);
				return;			
			elseif (not data.enabled) then		
				bui.Resources:EnableBar(data.id);			
			end
		end
		
        maxValue = maxValue - minValue;
        currentValue = currentValue - minValue;
		
        data.statusbar:SetMinMaxValues(0, maxValue);
        data.statusbar:SetValue(currentValue);
		
        if (data.statusbar.text) then		
            local percent = (currentValue / maxValue) * 100;
            currentValue = tk:FormatNumberString(currentValue);
            maxValue = tk:FormatNumberString(maxValue);
			
            local text = tk.string.format("%s: %s / %s (%d%%)", factionName, currentValue, maxValue, percent);
            data.statusbar.text:SetText(text);			
        end		
    end);
	
    handler:SetKey("reputation_bar_update");
    handler:Run();
end

function private.ReputationBar_ShowText()
    local handler = em:FindHandlerByKey("UPDATE_FACTION", "reputation_bar_update");
    if (handler) then handler:Run(); end
end

--------------------------
-- ResourceBar Prototype
--------------------------
local ResourceBar = tk:CreateProtectedPrototype("ResourceBar", true);

function ResourceBar:GetHeight(data)
    return (data.enabled and data.frame:GetHeight()) or 0;
end

function ResourceBar:IsEnabled(data)return data.enabled; end

function ResourceBar:SetShown(data, value)
    local valid = true;
    if (data.id == bui.Resources.ARTIFACT_BAR_ID) then
        valid = HasArtifactEquipped();
    elseif (data.id == bui.Resources.REPUTATION_BAR_ID) then
        valid = GetWatchedFactionInfo();
    elseif (data.id == bui.Resources.EXPERIENCE_BAR_ID) then
        valid = not tk:IsPlayerMaxLevel();
    end
    data.frame:SetShown(valid and value);
    if (not valid) then
        data.enabled = false;
    end
end

function ResourceBar:SetTextShown(data, shown)
    if (not data.statusbar.text and shown) then
        data.statusbar.text = data.statusbar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
        tk:SetFontSize(data.statusbar.text, bui.sv[data.id:lower().."Bar"].font_size);
        data.statusbar.text:SetPoint("CENTER");
    end
    if (data.statusbar.text) then
        data.statusbar.text:SetShown(shown);
    end
    if (data.enabled) then
        data.ShowText(self, data);
    end
end

function ResourceBar:Setup(data, func)
    local texture = tk.Constants.LSM:Fetch("statusbar", "MUI_StatusBar");
    local frame = tk.CreateFrame("Frame", "MUI_"..data.id.."Bar", bui.Resources.container);
    frame:SetBackdrop(tk.Constants.backdrop);
    frame:SetBackdropBorderColor(0, 0, 0);
    frame.bg = tk:SetBackground(frame, texture);
    frame.bg:SetVertexColor(0.08, 0.08, 0.08);
    frame:SetHeight(bui.sv[data.id:lower().."Bar"].height);

    local statusbar = tk.CreateFrame("StatusBar", nil, frame);
    statusbar:SetStatusBarTexture(texture);
    statusbar:SetOrientation("HORIZONTAL");
    statusbar:SetPoint("TOPLEFT", 1, -1);
    statusbar:SetPoint("BOTTOMRIGHT", -1, 1);

    statusbar.texture = statusbar:GetStatusBarTexture();
    statusbar:SetScript("OnEnter", function(self)
        self.texture:SetBlendMode("ADD");
        if (data.blizzard_bar) then
            data.blizzard_bar:GetScript("OnEnter")(data.blizzard_bar);
        end
    end);
    statusbar:SetScript("OnLeave", function(self)
        self.texture:SetBlendMode("BLEND");
        if (data.blizzard_bar) then
            data.blizzard_bar:GetScript("OnLeave")(data.blizzard_bar);
        end
    end);

    data.frame = frame;
    data.statusbar = statusbar;
    self:SetTextShown(bui.sv[data.id:lower().."Bar"].show_text);

    if (func and tk.type(func) == "function") then
        func(self, data);
    end
end

-------------------------------
-- BottomUI Resources
-------------------------------
function bui.Resources:UpdateContainer()
    local height = 0;
    local previousBar;
    for id, barID in tk.ipairs(self.bar_names) do
        if (self.bars[barID]) then
            local bar = self.bars[barID];
            if (bar:IsEnabled()) then
                bar:ClearAllPoints();
                if (not previousBar) then
                    bar:SetPoint("BOTTOMLEFT");
                    bar:SetPoint("BOTTOMRIGHT");
                else
                    local frame = previousBar:GetFrame();
                    bar:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, -1);
                    bar:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, -1);
                    height = height - 1;
                end
                height = height + bar:GetHeight();
                previousBar = bar;
            end
        end
    end
    if (height == 0) then height = 1; end
    self.container:SetHeight(height);
    ab:PositionBartenderBars();
end

function bui.Resources:EnableBar(barID, block_update)
    if (not bui.sv[barID:lower().."Bar"].enabled) then
        return;
    end
    local bar = self.bars[barID];
    if (not bar) then
        self.bars[barID] = ResourceBar({
            id = barID,
            enabled = true,
            ShowText = private[barID.."Bar_ShowText"]
        });
        bar = self.bars[barID];
        bar:Setup(private[barID.."Bar_OnSetup"]);
    else
        ResourceBar.Static:GetData(bar).enabled = true;
        bar:SetShown(true);
    end
    if (not block_update) then
        self:UpdateContainer();
    end
end

function bui.Resources:DisableBar(barID)
    local bar = self.bars[barID];
    if (bar) then
        ResourceBar.Static:GetData(bar).enabled = false;
        bar:SetShown(false);
        self:UpdateContainer();
    end
end

function bui.Resources:SetBarEnabled(value, barID)
    if (value) then
        self:EnableBar(barID);
    else
        self:DisableBar(barID);
    end
end

function bui.Resources:Setup()
    self.container = tk.CreateFrame("Frame", nil, bui.container);
    self.container:SetFrameStrata("MEDIUM");
    self.bars = {};
    if (dt.bar and dt.bar:IsShown() and dt.sv.enable_module) then
        self.container:SetPoint("BOTTOMLEFT", dt.bar, "TOPLEFT", 0, -1);
        self.container:SetPoint("BOTTOMRIGHT", dt.bar, "TOPRIGHT", 0, -1);
    else
        self.container:SetPoint("BOTTOMLEFT", bui.container, "TOPLEFT", 0, -1);
        self.container:SetPoint("BOTTOMRIGHT", bui.container, "TOPRIGHT", 0, -1);
    end
    for _, barID in tk.ipairs(self.bar_names) do
        if (bui.sv[barID:lower().."Bar"].enabled) then
            if (barID == self.EXPERIENCE_BAR_ID) then
                if (not tk:IsPlayerMaxLevel()) then
                    self:EnableBar(barID, true);
                end
            else
                self:EnableBar(barID, true);
            end
        end
    end
    self:UpdateContainer();

    if (dt.sv.combat_block) then
        self:CreateBlocker();
    end
end

function bui.Resources:CreateBlocker()
    if (not self.blocker) then
        self.blocker = tk:PopFrame("Frame", self.container);

        self.blocker:SetPoint("TOPLEFT");
        self.blocker:SetPoint("BOTTOMRIGHT", dt.bar, "BOTTOMRIGHT");
        self.blocker:EnableMouse(true);
        self.blocker:SetFrameStrata("DIALOG");
        self.blocker:SetFrameLevel(20);
        self.blocker:Hide();
        em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
            if (not dt.sv.combat_block) then return; end
            self.blocker:Show();
        end);
        em:CreateEventHandler("PLAYER_REGEN_ENABLED", function()
            self.blocker:Hide();
        end);
    end
    if (tk.InCombatLockdown()) then
        self.blocker:Show();
    end
end

-------------------------------------
-- BottomUI
-------------------------------------
function bui:init()
    if (not MayronUI:IsInstalled()) then return; end
    db = core.Database;
    self.sv = db.profile.bottomui;
    self.container = tk.CreateFrame("Frame", "MUI_BottomContainer", tk.UIParent);
    self.container:SetPoint("Bottom", 0, -1);
    self.container:SetSize(self.sv.width, 1);
    self.container:SetFrameStrata("LOW");

    MayronUI:InitializeModule("DataText");
    self.Resources:Setup();

    local r, g, b = tk:GetThemeColor();
    db:AppendOnce("profile.bottomui.gradients", {
        from = {r = r, g = g, b = b, a = 0.5},
        to = {r = 0, g = 0, b = 0, a = 0}
    });

    ---action bar panels-----------------
    ab.sv = db.profile.bottomui.actionbar_panel;
    if (self.sv.actionbar_panel.enabled) then
        ab:init(); -- initialize action bars
    end
    ---unit panels-----------------------
    unit.sv = db.profile.bottomui.unit_panels;
    if (self.sv.unit_panels.enabled) then
        unit:init(); -- initialize unit panels
    end
    unit:SetupSUFPortraitGradients();
    --------------------------

    em:CreateEventHandler("PET_BATTLE_OVER", function()
        bui.container:Show();
    end);
    em:CreateEventHandler("PET_BATTLE_OPENING_START", function()
        bui.container:Hide();
    end);

    if (C_PetBattles.IsInBattle()) then
        bui.container:Hide();
    end
end

em:CreateEventHandler("TALKINGHEAD_REQUESTED", function()
    if (TalkingHeadFrame) then
        TalkingHeadFrame:ClearAllPoints();
        TalkingHeadFrame:SetParent(tk.UIParent);
        TalkingHeadFrame:SetPoint("BOTTOM", 0, 250);
        TalkingHeadFrame.ClearAllPoints = tk.Constants.DUMMY_FUNC;
        TalkingHeadFrame.SetParent = tk.Constants.DUMMY_FUNC;
        TalkingHeadFrame.SetPoint = tk.Constants.DUMMY_FUNC;
    end
end);

function bui:OnConfigUpdate(list, value)
    local key = list:PopFront();
    if (key == "profile" and list:PopFront() == "bottomui") then
        key = list:PopFront();
        if (key == "width") then
            bui.container:SetWidth(value);
            dt:SetupButtons();
        elseif (key == "gradients") then
            if (list:PopFront() == "enabled") then
                if (not unit.gradients and value) then
                    unit:SetupSUFPortraitGradients();
                else
                    for _, frame in tk.pairs(unit.gradients) do
                        frame:SetShown(value);
                    end
                end
            else unit:SetupSUFPortraitGradients(); end
        elseif (key == "unit_panels" and unit.left) then
            key = list:PopFront();
            if (key == "unit_width") then
                unit.left:SetWidth(value);
                unit.right:SetWidth(value);
            elseif (key == "unit_names") then
                key = list:PopFront();
                if (key == "width") then
                    unit.player:SetWidth(value);
                    unit.target:SetWidth(value);
                elseif (key == "height") then
                    unit.player:SetHeight(value);
                    unit.target:SetHeight(value);
                elseif (key == "xOffset") then
                    unit.player:SetPoint("BOTTOMLEFT", unit.left, "TOPLEFT", value, 0);
                    unit.target:SetPoint("BOTTOMRIGHT", unit.right, "TOPRIGHT", -value, 0);
                elseif (key == "fontSize") then
                    local font = tk.Constants.LSM:Fetch("font", db.global.core.font);
                    unit.player.text:SetFont(font, value);
                    unit.target.text:SetFont(font, value);
                elseif (key == "target_class_colored") then
                    if (UnitIsPlayer("target") and value) then
                        local _, class = UnitClass("target");
                        tk:SetClassColoredTexture(class, unit.target.bg);
                    else
                        tk:SetThemeColor(unit.sv.alpha, unit.target.bg);
                    end
                end
            end
        elseif (key == "xpBar") then
            key = list:PopFront();
            local bar = bui.Resources.bars[bui.Resources.EXPERIENCE_BAR_ID];
            if (key == "enabled") then
                bui.Resources:SetBarEnabled(value, bui.Resources.EXPERIENCE_BAR_ID);
            elseif (bar) then
                if (key == "height") then
                    bar:SetHeight(value);
                    self.Resources:UpdateContainer();
                elseif (key == "show_text") then
                    bar:SetTextShown(value);
                elseif (key == "font_size") then
                    local statusbar = ResourceBar.Static:GetData(bar).statusbar;
                    if (statusbar.text) then
                        tk:SetFontSize(statusbar.text, value);
                    end
                end
            end
        elseif (key == "reputationBar") then
            key = list:PopFront();
            local bar = bui.Resources.bars[bui.Resources.REPUTATION_BAR_ID];
            if (key == "enabled") then
                bui.Resources:SetBarEnabled(value, bui.Resources.REPUTATION_BAR_ID);
            elseif (key == "height") then
                bar:SetHeight(value);
                self.Resources:UpdateContainer();
            elseif (key == "show_text") then
                bar:SetTextShown(value);
            elseif (key == "font_size") then
                local statusbar = ResourceBar.Static:GetData(bar).statusbar;
                if (statusbar.text) then
                    tk:SetFontSize(statusbar.text, value);
                end
            end
        elseif (key == "artifactBar") then
            key = list:PopFront();
            local bar = bui.Resources.bars[bui.Resources.ARTIFACT_BAR_ID];
            if (key == "enabled") then
                bui.Resources:SetBarEnabled(value, bui.Resources.ARTIFACT_BAR_ID);
            elseif (key == "height") then
                bar:SetHeight(value);
                self.Resources:UpdateContainer();
            elseif (key == "show_text") then
                bar:SetTextShown(value);
            elseif (key == "font_size") then
                local statusbar = ResourceBar.Static:GetData(bar).statusbar;
                if (statusbar.text) then
                    tk:SetFontSize(statusbar.text, value);
                end
            end
        elseif (key == "actionbar_panel" and ab.panel) then
            key = list:PopFront();
            if (key == "retract_height" and not ab.sv.expanded) then
                ab.panel:SetHeight(value);
            elseif (key == "expand_height" and ab.sv.expanded) then
                ab.panel:SetHeight(value);
            elseif (key == "bartender") then
                ab:SetBartenderBars();
            end
        end
    end
end