-- luacheck: ignore MayronUI self 143 631
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

-- Register Modules ----------------------

local C_UnitFramePanel = MayronUI:RegisterModule("BottomUI_UnitFramePanel", true);

-- Load Database Defaults ----------------

db:AddToDefaults("profile.unitPanels", {
    enabled = true,
    controlGrid = true,
    unitWidth = 325,
    height = 75,
    isSymmetric = true,
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

local function DetachShadowedUnitFrames()
    local currentProfile = _G.ShadowUF.db:GetCurrentProfile();
    local SUF = _G.ShadowedUFDB["profiles"][currentProfile]["positions"]["targettarget"];

    SUF["point"] = "TOP"; SUF["anchorTo"] = "UIParent";
    SUF["relativePoint"] = "TOP"; SUF["x"] = 0; SUF["y"] = -40;
end

local function AttachShadowedUnitFrames(rightPanel)
    local currentProfile = _G.ShadowUF.db:GetCurrentProfile();
    local anchorTo = "UIParent";

    if (tk._G["MUI_UnitPanelCenter"]) then
        anchorTo = "MUI_UnitPanelCenter";
    end

    local SUF = _G.ShadowedUFDB["profiles"][currentProfile]["positions"]["targettarget"];
    SUF["point"] = "TOP"; SUF["anchorTo"] = anchorTo;
    SUF["relativePoint"] = "TOP"; SUF["x"] = 0; SUF["y"] = -40;

    if (_G.SUFUnitplayer) then
        _G.SUFUnitplayer:SetFrameStrata("MEDIUM");
    end

    if (_G.SUFUnittarget) then
        _G.SUFUnittarget:SetFrameStrata("MEDIUM");
        rightPanel:SetFrameStrata("LOW");
    end

    if (_G.SUFUnittargettarget) then
        _G.SUFUnittargettarget:SetFrameStrata("MEDIUM");
    end

    _G.ShadowUF.Layout:Reload();
end

-- UnitFramePanel Module -----------------

function C_UnitFramePanel:OnInitialize(data, buiContainer, subModules)
    data.settings = db.profile.unitPanels:ToTable();

    data.buiContainer = buiContainer;
    data.ActionBarPanel = subModules.ActionBarPanel;

    if (data.settings.enabled) then
        self:SetEnabled(true);
    end

    self:SetupSUFPortraitGradients();
end

function C_UnitFramePanel:OnEnable(data)
    if (data.left) then
        return;
    end

    data.left = tk.CreateFrame("Frame", "MUI_UnitPanelLeft", data.buiContainer);
    data.right = tk.CreateFrame("Frame", "MUI_UnitPanelRight", _G.SUFUnittarget or data.buiContainer);
    data.center = tk.CreateFrame("Frame", "MUI_UnitPanelCenter", data.right);

    data.left:SetFrameStrata("BACKGROUND");
    data.center:SetFrameStrata("BACKGROUND");
    data.right:SetFrameStrata("BACKGROUND");

    data.left:SetSize(data.settings.unitWidth, 180);
    data.right:SetSize(data.settings.unitWidth, 180);

    data.center:SetPoint("TOPLEFT", data.left, "TOPRIGHT");
    data.center:SetPoint("TOPRIGHT", data.right, "TOPLEFT");
    data.center:SetPoint("BOTTOMLEFT", data.left, "BOTTOMRIGHT");
    data.center:SetPoint("BOTTOMRIGHT", data.right, "BOTTOMLEFT");

    local width = data.settings.unitNames.width;
    local height = data.settings.unitNames.height;
    local xOffset = data.settings.unitNames.xOffset;

    data.player = _G.CreateFrame("Frame", "MUI_PlayerName", data.left);
    data.player:SetPoint("BOTTOMLEFT", data.left, "TOPLEFT", xOffset, 0);
    data.player:SetSize(width, height);

    data.target = _G.CreateFrame("Frame", "MUI_TargetName", data.right);
    data.target:SetPoint("BOTTOMRIGHT", data.right, "TOPRIGHT", -(xOffset), 0);
    data.target:SetSize(width, height);

    -- Set Textures
    local nameTextureFilePath = tk:GetAssetFilePath("Textures\\BottomUI\\NamePanel");
    data.player.bg = tk:SetBackground(data.player, nameTextureFilePath);
    data.target.bg = tk:SetBackground(data.target, nameTextureFilePath);
    data.center.bg = tk:SetBackground(data.center, tk:GetAssetFilePath("Textures\\BottomUI\\Center"));
    tk:FlipTexture(data.target.bg, "HORIZONTAL");

    -- Set FontStrings
    local font = tk.Constants.LSM:Fetch("font", db.global.core.font);

    data.player.text = data.player:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    data.player.text:SetFont(font, data.settings.unitNames.fontSize);
    data.player.text:SetJustifyH("LEFT");
    data.player.text:SetWidth(data.player:GetWidth() - 25);
    data.player.text:SetWordWrap(false);
    data.player.text:SetPoint("LEFT", 15, 0);

    self:UpdateUnitNameText("player");

    data.target.text = data.target:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    data.target.text:SetParent(_G.SUFUnittarget or data.buiContainer);
    data.target.text:SetFont(font, data.settings.unitNames.fontSize);
    data.target.text:SetJustifyH("RIGHT");
    data.target.text:SetWidth(data.target:GetWidth() - 25);
    data.target.text:SetWordWrap(false);
    data.target.text:SetPoint("RIGHT", data.target, "RIGHT", -15, 0);

    -- Position unit frame backgrounds:
    self:RepositionPanels();

    if (not tk:IsPlayerMaxLevel()) then
        em:CreateEventHandler("PLAYER_LEVEL_UP", function(handler)
            self:UpdateUnitNameText("player");

            if (tk:IsPlayerMaxLevel()) then
                handler:Destroy();
            end
        end);
    end

    em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
        self:UpdateUnitNameText("player");
    end);

    em:CreateEventHandler("PLAYER_REGEN_ENABLED", function()
        self:UpdateUnitNameText("player");
    end);

    em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()
        if (_G.UnitExists("target")) then
            self:UpdateUnitNameText("target");
        end
    end);

    self:SetSymmetrical(data.settings.isSymmetric);

    if (_G.IsAddOnLoaded("ShadowedUnitFrames") and data.settings.controlGrid) then
        AttachShadowedUnitFrames(data.right);

        _G.hooksecurefunc(_G.ShadowUF, "ProfilesChanged", function()
            AttachShadowedUnitFrames(data.right);
        end);

        _G.hooksecurefunc("ReloadUI", DetachShadowedUnitFrames);
        em:CreateEventHandler("PLAYER_LOGOUT", DetachShadowedUnitFrames);
    end

    if (_G.IsAddOnLoaded("Grid") and data.settings.controlGrid) then
        if (_G.Grid.db:GetCurrentProfile() == "MayronUIH") then
            _G.GridLayoutFrame:ClearAllPoints();
            _G.GridLayoutFrame:SetPoint("BOTTOMRIGHT", data.target, "TOPRIGHT", -9, 0);
        end

        _G.hooksecurefunc(_G.Grid.db, "SetProfile", function()
            if (_G.Grid.db:GetCurrentProfile() == "MayronUIH") then
                _G.GridLayoutFrame:ClearAllPoints();
                _G.GridLayoutFrame:SetPoint("BOTTOMRIGHT", data.target, "TOPRIGHT", -9, 0);
            end
        end);
    end
end

do
    local doubleTextureFilePath = tk:GetAssetFilePath("Textures\\BottomUI\\Double");
    local singleTextureFilePath = tk:GetAssetFilePath("Textures\\BottomUI\\Single");

    local function SwitchToSingle(data)
        data.target.text:SetText(tk.Strings.Empty);

        -- If the parent is not SUF it won't hide automatically!
        if (data.right:GetParent() == data.buiContainer) then
            data.right:Hide();
        end

        data.left.bg:SetAlpha(0);
        data.left.noTargetBg:SetAlpha(data.settings.alpha);
    end

    function C_UnitFramePanel:SetSymmetrical(data, isSymmetric)
        data.right.bg = tk:SetBackground(data.right, doubleTextureFilePath);
        data.left.bg = tk:SetBackground(data.left, doubleTextureFilePath);

        tk:ApplyThemeColor(data.settings.alpha,
            data.left.bg,
            data.center.bg,
            data.right.bg,
            data.player.bg,
            data.target.bg
        );

        if (isSymmetric) then
            data.left.noTargetBg = tk:SetBackground(data.left, singleTextureFilePath);
            tk:ApplyThemeColor(data.settings.alpha, data.left.noTargetBg);

            if (not _G.UnitExists("target")) then
                SwitchToSingle(data);
            end

            if (data.right:GetParent() == data.buiContainer) then
                data.right:Hide();
            end

            em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()
                if (_G.UnitExists("target")) then
                    if (data.right:GetParent() == data.buiContainer) then
                        data.right:Show();
                    end

                    data.left.bg:SetAlpha(data.settings.alpha);
                    data.left.noTargetBg:SetAlpha(0);

                    if (data.settings.unitNames.targetClassColored) then
                        if (_G.UnitIsPlayer("target")) then
                            local _, class = _G.UnitClass("target");
                            tk:SetClassColoredTexture(class, data.target.bg);
                        else
                            tk:ApplyThemeColor(data.settings.alpha, data.target.bg);
                        end
                    end
                else
                    SwitchToSingle(data);
                end
            end);

            em:CreateEventHandler("PLAYER_ENTERING_WORLD", function()
                if (not _G.UnitExists("target")) then
                    SwitchToSingle(data);
                end
            end);
        else
            data.right:SetParent(data.buiContainer);

            if (data.settings.unitNames.targetClassColored) then
                em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()

                    if (_G.UnitExists("target")) then
                        if (data.settings.unitNames.targetClassColored) then

                            if (_G.UnitIsPlayer("target")) then
                                local _, class = _G.UnitClass("target");
                                tk:SetClassColoredTexture(class, data.target.bg);
                            else
                                tk:ApplyThemeColor(data.settings.alpha, data.target.bg);
                            end
                        end

                    else
                        tk:ApplyThemeColor(data.settings.alpha, data.target.bg);
                    end
                end);
            end
        end

        data.right.bg:SetTexCoord(1, 0, 0, 1);
    end
end

function C_UnitFramePanel:RepositionPanels(data)
    local actionBarPanel = data.ActionBarPanel:GetPanel();

    if (actionBarPanel) then
        data.left:SetPoint("TOPLEFT", actionBarPanel, "TOPLEFT", 0, data.settings.height);
        data.right:SetPoint("TOPRIGHT", actionBarPanel, "TOPRIGHT", 0, data.settings.height);
    else
        -- Action Bar Panel is disabled...
        local height = data.settings.height;
        local dataTextModule = MayronUI:ImportModule("DataText");

        if (dataTextModule and dataTextModule:IsShown()) then
            local dataTextBar = dataTextModule:GetDataTextBar();
            data.left:SetPoint("TOPLEFT", dataTextBar, "TOPLEFT", 0, height);
            data.right:SetPoint("TOPRIGHT", dataTextBar, "TOPRIGHT", 0, height);

        else
            data.left:SetPoint("TOPLEFT", data.buiContainer, "TOPLEFT", 0, height);
            data.right:SetPoint("TOPRIGHT", data.buiContainer, "TOPRIGHT", 0, height);
        end
    end
end

function C_UnitFramePanel:UpdateUnitNameText(data, unitType)
    local unitLevel = _G.UnitLevel(unitType);

    local name = _G.UnitName(unitType);
    name = tk.Strings:SetOverflow(name, 22);

    local _, class = _G.UnitClass(unitType); -- not sure if this works..
    local classification = _G.UnitClassification(unitType);

    if (tonumber(unitLevel) < 1) then
        unitLevel = "boss";
    elseif (classification == "elite" or classification == "rareelite") then
        unitLevel = tostring(unitLevel).."+";
    end

    if (classification == "rareelite" or classification == "rare") then
        unitLevel = tk.Strings:Concat("|cffff66ff", unitLevel, "|r");
    end

    if (unitType ~= "player") then
        if (classification == "worldboss") then
            unitLevel = tk.Strings:SetTextColorByRGB(unitLevel, 0.25, 0.75, 0.25); -- yellow
        else
            local color = tk:GetDifficultyColor(_G.UnitLevel(unitType));

            unitLevel = tk.Strings:SetTextColorByRGB(unitLevel, color.r, color.g, color.b);
            name = (_G.UnitIsPlayer(unitType) and tk.Strings:SetTextColorByClass(name, class)) or name;
        end
    else
        unitLevel = tk.Strings:SetTextColorByRGB(unitLevel, 1, 0.8, 0);

        if (_G.UnitAffectingCombat("player")) then
            name = tk.Strings:SetTextColorByRGB(name, 1, 0, 0);
        else
            name = tk.Strings:SetTextColorByClass(name, class);
        end
    end

    data[unitType].text:SetText(tk.string.format("%s %s", name, unitLevel));
end

function C_UnitFramePanel:SetupSUFPortraitGradients(data)
    if (not _G.IsAddOnLoaded("ShadowedUnitFrames")) then
        return;
    end

    local settings = db.profile.bottomui.gradients:ToTable();

    if (settings.enabled) then
        data.gradients = data.gradients or {};

        for _, unitID in obj:IterateArgs("player", "target") do
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
                            if (_G.UnitExists("target")) then
                                local from = settings.from;
                                local to = settings.to;

                                if (_G.UnitIsPlayer("target") and settings.targetClassColored) then
                                    local _, class = _G.UnitClass("target");
                                    class = tk.string.upper(class);
                                    class = class:gsub("%s+", "");

                                    local c = tk.Constants.CLASS_COLORS[class];

                                    frame.texture:SetGradientAlpha("VERTICAL",
                                        to.r, to.g, to.b, to.a,
                                        c.r, c.g, c.b, from.a);
                                else
                                    frame.texture:SetGradientAlpha("VERTICAL",
                                        to.r, to.g, to.b, to.a,
                                        from.r, from.g, from.b, from.a);
                                end
                            end
                        end);
                    end
                end

                frame:SetSize(100, settings.height);

                local from = settings.from;
                local to = settings.to;

                if (unitID == "target" and _G.UnitExists("target")
                        and _G.UnitIsPlayer("target") and settings.targetClassColored) then

                    local _, class = _G.UnitClass("target");
                    class = tk.string.upper(class);
                    class = class:gsub("%s+", "");

                    local color = tk.Constants.CLASS_COLORS[class];

                    frame.texture:SetGradientAlpha("VERTICAL", to.r, to.g, to.b, to.a,
                    color.r, color.g, color.b, from.a);
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