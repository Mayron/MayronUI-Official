local addOnName, namespace = ...;

-- Setup Namespaces ----------------------

local em = namespace.EventManager;
local tk = namespace.Toolkit;
local db = namespace.Database;
local gui = namespace.GUIBuilder;
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

local DataText = MayronUI:ImportModule("DataText");
local unitFramePanelModule, UnitFramePanelClass = MayronUI:RegisterModule("BottomUI_UnitFramePanel", true);

-- Load Database Defaults ----------------

db:AddToDefaults("profile.unitPanels", {
    enabled = true,
    controlGrid = true,
    controlGrid = true,
    unitWidth = 325,
    height = 75,
    classicMode = false,
    alpha = 0.8,
    unitNames = {
        width = 235,
        height = 20,
        fontSize = 11,
        targetClassColored = true,
        xOffset = 24,
    }
});

-- SUF Functions -------------------------

local function UnAnchorSUF()
    local currentProfile = ShadowUF.db:GetCurrentProfile();
    local SUF = ShadowedUFDB["profiles"][currentProfile]["positions"]["targettarget"];

    SUF["point"] = "TOP"; SUF["anchorTo"] = "UIParent";
    SUF["relativePoint"] = "TOP"; SUF["x"] = 0; SUF["y"] = -40;
end

local function ReanchorSUF(rightPanel)
    local currentProfile = ShadowUF.db:GetCurrentProfile();
    local anchorTo = "UIParent";

    if (tk._G["MUI_UnitPanelCenter"]) then
        anchorTo = "MUI_UnitPanelCenter";
    end

    local SUF = ShadowedUFDB["profiles"][currentProfile]["positions"]["targettarget"];
    SUF["point"] = "TOP"; SUF["anchorTo"] = anchorTo;
    SUF["relativePoint"] = "TOP"; SUF["x"] = 0; SUF["y"] = -40;

    if (SUFUnitplayer) then
        SUFUnitplayer:SetFrameStrata("HIGH");
    end

    if (SUFUnittarget) then
        SUFUnittarget:SetFrameStrata("HIGH");
        rightPanel:SetFrameStrata("LOW");
    end

    if (SUFUnittargettarget) then
        SUFUnittargettarget:SetFrameStrata("HIGH");
    end

    ShadowUF.Layout:Reload();
end

-- UnitFramePanel Module ----------------- 

unitFramePanelModule:OnInitialize(function(self, data, buiContainer, subModules)
    data.sv = db.profile.unitPanels;
    data.buiContainer = buiContainer;    
    data.ActionBarPanel = subModules.ActionBarPanel;

    if (data.sv.enabled) then
        self:SetEnabled(true);
    end

    self:SetupSUFPortraitGradients();
end);

unitFramePanelModule:OnEnable(function(self, data)
    if (data.left) then 
        return;         
    end

    local font = tk.Constants.LSM:Fetch("font", db.global.Core.font);
    local actionBarPanel = data.ActionBarPanel:GetPanel();

    obj:Assert(actionBarPanel, "ActionBarPanel cannot be loaded.");

    data.left = tk.CreateFrame("Frame", "MUI_UnitPanelLeft", data.buiContainer);
    data.right = tk.CreateFrame("Frame", "MUI_UnitPanelRight", SUFUnittarget or data.buiContainer);
    data.center = tk.CreateFrame("Frame", "MUI_UnitPanelCenter", data.right);

    data.left:SetFrameStrata("BACKGROUND");
    data.center:SetFrameStrata("BACKGROUND");
    data.right:SetFrameStrata("BACKGROUND");

    data.left:SetSize(data.sv.unitWidth, 180);
    data.right:SetSize(data.sv.unitWidth, 180);

    if (actionBarPanel) then
        data.left:SetPoint("TOPLEFT", actionBarPanel, "TOPLEFT", 0, data.sv.height);
        data.right:SetPoint("TOPRIGHT", actionBarPanel, "TOPRIGHT", 0, data.sv.height);

    else
        local height = data.sv.height;

        if (DataText.bar and DataText.bar:IsShown()) then
            data.left:SetPoint("TOPLEFT", DataText.bar, "TOPLEFT", 0, height);
            data.right:SetPoint("TOPRIGHT", DataText.bar, "TOPRIGHT", 0, height);

        else
            data.left:SetPoint("TOPLEFT", data.buiContainer, "TOPLEFT", 0, height);
            data.right:SetPoint("TOPRIGHT", data.buiContainer, "TOPRIGHT", 0, height);
        end
    end

    data.center:SetPoint("TOPLEFT", data.left, "TOPRIGHT");
    data.center:SetPoint("TOPRIGHT", data.right, "TOPLEFT");
    data.center:SetPoint("BOTTOMLEFT", data.left, "BOTTOMRIGHT");
    data.center:SetPoint("BOTTOMRIGHT", data.right, "BOTTOMLEFT");
    data.center.bg = tk:SetBackground(data.center, tk.Constants.MEDIA.."bottom_ui\\Center");

    data.player = tk.CreateFrame("Frame", "MUI_PlayerName", data.left);
    data.player:SetPoint("BOTTOMLEFT", data.left, "TOPLEFT", data.sv.unitNames.xOffset, 0);
    data.player:SetSize(data.sv.unitNames.width, data.sv.unitNames.height);
    data.player.bg = tk:SetBackground(data.player, tk.Constants.MEDIA.."bottom_ui\\Names");

    data.player.text = data.player:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    data.player.text:SetFont(font, data.sv.unitNames.fontSize);
    data.player.text:SetJustifyH("LEFT");
    data.player.text:SetWidth(data.player:GetWidth() - 25);
    data.player.text:SetWordWrap(false);
    data.player.text:SetPoint("LEFT", 15, 0);
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

    data.target = tk.CreateFrame("Frame", "MUI_TargetName", data.right);
    data.target:SetPoint("BOTTOMRIGHT", data.right, "TOPRIGHT", -data.sv.unitNames.xOffset, 0);
    data.target:SetSize(data.sv.unitNames.width, data.sv.unitNames.height);
    data.target.bg = tk:SetBackground(data.target, tk.Constants.MEDIA.."bottom_ui\\Names");
    data.target.bg:SetTexCoord(1, 0, 0, 1); -- flip horizontally

    data.target.text = data.target:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    data.target.text:SetParent(SUFUnittarget or data.buiContainer);
    data.target.text:SetFont(font, data.sv.unitNames.fontSize);
    data.target.text:SetJustifyH("RIGHT");
    data.target.text:SetWidth(data.target:GetWidth() - 25);
    data.target.text:SetWordWrap(false);
    data.target.text:SetPoint("RIGHT", data.target, "RIGHT", -15, 0);

    em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()
        if (UnitExists("target")) then
            self:UpdateUnitNameText("target");
        end
    end);

    if (not data.sv.classicMode) then
        data.left.bg = tk:SetBackground(data.left, tk.Constants.MEDIA.."bottom_ui\\Single");
        data.right.bg = tk:SetBackground(data.right, tk.Constants.MEDIA.."bottom_ui\\Single");

        if (data.right:GetParent() == data.buiContainer) then
            data.right:Hide();
        end

        em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()
            if (UnitExists("target")) then
                if (data.right:GetParent() == data.buiContainer) then
                    data.right:Show();
                end

                data.left.bg:SetTexture(tk.Constants.MEDIA.."bottom_ui\\Double");
                data.right.bg:SetTexture(tk.Constants.MEDIA.."bottom_ui\\Double");

                if (data.sv.unitNames.targetClassColored) then
                    if (UnitIsPlayer("target")) then
                        local _, class = UnitClass("target");
                        tk:SetClassColoredTexture(class, data.target.bg);
                    else
                        tk:SetThemeColor(data.sv.alpha, data.target.bg);
                    end
                end
            else
                data.target.text:SetText("");

                if (data.right:GetParent() == data.buiContainer) then
                    data.right:Hide();
                end

                data.left.bg:SetTexture(tk.Constants.MEDIA.."bottom_ui\\Single");
                data.right.bg:SetTexture(tk.Constants.MEDIA.."bottom_ui\\Single");
            end
        end);

        em:CreateEventHandler("PLAYER_ENTERING_WORLD", function()
            if (not UnitExists("target")) then
                data.target.text:SetText("");
                if (data.right:GetParent() == data.buiContainer) then
                    data.right:Hide();
                end
                data.left.bg:SetTexture(tk.Constants.MEDIA.."bottom_ui\\Single");
                data.right.bg:SetTexture(tk.Constants.MEDIA.."bottom_ui\\Single");
            end
        end);
    else
        data.left.bg = tk:SetBackground(data.left, tk.Constants.MEDIA.."bottom_ui\\Double");
        data.right.bg = tk:SetBackground(data.right, tk.Constants.MEDIA.."bottom_ui\\Double");
        data.right:SetParent(data.buiContainer);

        if (data.sv.unitNames.targetClassColored) then
            em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()

                if (UnitExists("target")) then
                    if (data.sv.unitNames.targetClassColored) then

                        if (UnitIsPlayer("target")) then
                            local _, class = UnitClass("target");
                            tk:SetClassColoredTexture(class, data.target.bg);
                        else
                            tk:SetThemeColor(data.sv.alpha, data.target.bg);
                        end
                    end

                else
                    tk:SetThemeColor(data.sv.alpha, data.target.bg);
                end
            end);
        end
    end

    tk:SetThemeColor(data.sv.alpha, data.left.bg, data.center.bg, data.right.bg, data.player.bg, data.target.bg);
    data.right.bg:SetTexCoord(1, 0, 0, 1);

    if (tk.IsAddOnLoaded("ShadowedUnitFrames") and data.sv.controlGrid) then
        ReanchorSUF(data.right);
        tk.hooksecurefunc(ShadowUF, "ProfilesChanged", ReanchorSUF);
        tk.hooksecurefunc("ReloadUI", UnAnchorSUF);
        em:CreateEventHandler("PLAYER_LOGOUT", UnAnchorSUF);
    end

    if (tk.IsAddOnLoaded("Grid") and data.sv.controlGrid) then
        if (Grid.db:GetCurrentProfile() == "MayronUIH") then
            GridLayoutFrame:ClearAllPoints();
            GridLayoutFrame:SetPoint("BOTTOMRIGHT", data.target, "TOPRIGHT", -9, 0);
        end

        tk.hooksecurefunc(Grid.db, "SetProfile", function()
            if (Grid.db:GetCurrentProfile() == "MayronUIH") then
                GridLayoutFrame:ClearAllPoints();
                GridLayoutFrame:SetPoint("BOTTOMRIGHT", data.target, "TOPRIGHT", -9, 0);
            end
        end);
    end
end);

-- UnitFramePanelClass -----------------------

function UnitFramePanelClass:UpdateUnitNameText(data, unitType, unitLevel)
    local name = UnitName(unitType);

    if (#name > 22) then
        name = name:sub(1, 22):trim();
        name = name.."...";
    end

    local unitLevel = unitLevel or UnitLevel(unitType);
    local _, class = UnitClass(unitType); -- not sure if this works..
    local classif = UnitClassification(unitType);

    if (tk.tonumber(unitLevel) < 1) then
        unitLevel = "boss";

    elseif (classif == "elite" or classif == "rareelite") then 
        unitLevel = tk.tostring(unitLevel).."+";
    end

    if (classif == "rareelite" or classif == "rare") then
        unitLevel = "|cffff66ff"..unitLevel.."|r";
    end

    if (unitType ~= "player") then
        if (classif == "worldboss") then
            unitLevel = tk:GetRGBColoredText(unitLevel, 0.25, 0.75, 0.25); -- yellow
        else
            local color = tk:GetDifficultyColor(UnitLevel(unitType));
            unitLevel = tk:GetRGBColoredText(unitLevel, color.r, color.g, color.b);
            name = (UnitIsPlayer(unitType) and tk:GetClassColoredText(class, name)) or name;
        end

    else        
        unitLevel = tk:GetRGBColoredText(unitLevel, 1, 0.8, 0);

        if (UnitAffectingCombat("player")) then
            name = tk:GetRGBColoredText(name, 1, 0, 0);
        else
            name = tk:GetClassColoredText(class, name);
        end
    end

    data[unitType].text:SetText(tk.string.format("%s %s", name, unitLevel));
end

function UnitFramePanelClass:SetupSUFPortraitGradients(data)
    if (not tk.IsAddOnLoaded("ShadowedUnitFrames")) then 
        return; 
    end

    local sv = db.profile.bottomui.gradients;

    if (sv.enabled) then
        data.gradients = data.gradients or {};
        local r, g, b = tk:GetThemeColor();

        for id, unitID in tk:IterateArgs("player", "target") do
            local parent = tk._G["SUFUnit"..unitID];

            if (parent and parent.portrait) then
                local frame = data.gradients[unitID];

                if (not frame) then
                    data.gradients[unitID] = tk.CreateFrame("Frame", nil, parent);

                    frame = data.gradients[unitID];
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

                                if (UnitIsPlayer("target") and sv.targetClassColored) then
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

                if (unitID == "target" and UnitExists("target") 
                        and UnitIsPlayer("target") and sv.targetClassColored) then

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

            elseif (data.gradients[unitID]) then
                data.gradients[unitID]:Hide();
            end
        end

    elseif (data.gradients) then
        for _, frame in tk.pairs(data.gradients) do 
            frame:Hide(); 
        end
    end    
end