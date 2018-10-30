local addOnName, namespace = ...;

-- Setup Namespaces ----------------------
local em = namespace.EventManager;
local tk = namespace.Toolkit;
local db = namespace.Database;
local gui = namespace.GUIBottomUIlder;
local obj = namespace.Objects;
local L = namespace.Locale;

-- Constants -----------------------------

local REPUTATION_BAR_ID = "Reputation";
local EXPERIENCE_BAR_ID = "XP";
local ARTIFACT_BAR_ID = "Artifact";
local RESOURCE_BAR_NAMES = {"Artifact", "Reputation", "XP"};

-- Setup Objects -------------------------

local FrameWrapper = obj:Import("Framework.System.FrameWrapper");
local BottomUIPackage = obj:CreatePackage("BottomUI", addonName);
local ResourceBar = BottomUIPackage:CreateClass("ResourceBar", FrameWrapper);

-- Register and Import Modules -----------
 
local containerModule, ContainerClass = MayronUI:RegisterModule("BottomUI_Container");

-- Add Database Defaults -----------------

db:AddToDefaults("profile.bottomui", {
    width = 750,
    gradients = {
        enabled = true,
        height = 24,
        target_class_colored = true,
    }
});

-- ShadowUF Local Functions ------------------

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

-- Container Module ------------------

containerModule:OnInitialize(function(self, data)
    if (not MayronUI:IsInstalled()) then 
        return; 
    end

    db = namespace.Database;
    data.sv = db.profile.bottomui;
    data.container = tk.CreateFrame("Frame", "MUI_BottomContainer", tk.UIParent);
    data.container:SetPoint("BOTTOM", 0, -1);
    data.container:SetSize(data.sv.width, 1);
    data.container:SetFrameStrata("LOW");

    local r, g, b = tk:GetThemeColor();
    db:AppendOnce(db.profile, "bottomui.gradients", {
        from = {r = r, g = g, b = b, a = 0.5},
        to = {r = 0, g = 0, b = 0, a = 0}
    });

    em:CreateEventHandler("PET_BATTLE_OVER", function()
        data.container:Show();
    end);
    em:CreateEventHandler("PET_BATTLE_OPENING_START", function()
        data.container:Hide();
    end);

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

    if (C_PetBattles.IsInBattle()) then
        data.container:Hide();
    end

    -- Initialize Sub Modules -------------

    data.subModules = {};

    data.subModules.ResourceBars = MayronUI:ImportModule("BottomUI_ResourceBars");
    data.subModules.ActionBarPanel = MayronUI:ImportModule("BottomUI_ActionBarPanel");
    data.subModules.UnitFramePanel = MayronUI:ImportModule("BottomUI_UnitFramePanel");

    data.subModules.ResourceBars:Initialize(data.container, data.subModules);    
    data.subModules.ActionBarPanel:Initialize(data.container, data.subModules);  
    data.subModules.UnitFramePanel:Initialize(data.container, data.subModules);
end);

-- TODO: Split this up where revelant!
containerModule:OnConfigUpdate(function(self, data, list, value)
    local unitFramePanel = data.subModules["UnitFramePanel"];
    local key = list:PopFront();

    if (key == "profile" and list:PopFront() == "bottomui") then
        key = list:PopFront();

        if (key == "width") then
            data.container:SetWidth(value);

            if (IsAddOnLoaded("MUI_DataText")) then
                local dataTextModule = MayronUI:ImportModule("DataText");
                dataTextModule:SetupButtons();
            end

        elseif (key == "gradients") then
            if (list:PopFront() == "enabled") then

                -- TODO: Might be difficult...
                if (not unit.gradients and value) then
                    unitFramePanel:SetupSUFPortraitGradients();

                else
                    for _, frame in tk.pairs(unit.gradients) do
                        frame:SetShown(value);
                    end

                end
            else 
                unit:SetupSUFPortraitGradients(); 
            end

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
                    local font = tk.Constants.LSM:Fetch("font", db.global.Core.font);
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
            local bar = BottomUI.Resources.bars[BottomUI.Resources.EXPERIENCE_BAR_ID];

            if (key == "enabled") then
                BottomUI.Resources:SetBarEnabled(value, BottomUI.Resources.EXPERIENCE_BAR_ID);

            elseif (bar) then
                if (key == "height") then
                    bar:SetHeight(value);
                    data.Resources:UpdateContainer();

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
            local bar = BottomUI.Resources.bars[BottomUI.Resources.REPUTATION_BAR_ID];

            if (key == "enabled") then
                BottomUI.Resources:SetBarEnabled(value, BottomUI.Resources.REPUTATION_BAR_ID);

            elseif (key == "height") then
                bar:SetHeight(value);
                data.Resources:UpdateContainer();

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
            local bar = BottomUI.Resources.bars[BottomUI.Resources.ARTIFACT_BAR_ID];

            if (key == "enabled") then
                BottomUI.Resources:SetBarEnabled(value, BottomUI.Resources.ARTIFACT_BAR_ID);

            elseif (key == "height") then
                bar:SetHeight(value);
                data.Resources:UpdateContainer();

            elseif (key == "show_text") then
                bar:SetTextShown(value);

            elseif (key == "font_size") then
                local statusbar = ResourceBar.Static:GetData(bar).statusbar;
                if (statusbar.text) then
                    tk:SetFontSize(statusbar.text, value);
                end
            end

        elseif (key == "actionbar_panel" and ActionBarpanel) then
            key = list:PopFront();

            if (key == "retract_height" and not ActionBarsv.expanded) then
                ActionBarpanel:SetHeight(value);
            elseif (key == "expand_height" and ActionBarsv.expanded) then
                ActionBarpanel:SetHeight(value);
            elseif (key == "bartender") then
                ActionBar:SetBartenderBars();
            end
        end
    end
end);

-- ContainerClass -----------------

function ContainerClass:UpdateContainer(data)
    data.subModules.ActionBarPanel:PositionBartenderBars();  
end
    
    