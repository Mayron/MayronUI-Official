-- luacheck: ignore MayronUI self 143 631
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

-- Register Modules ----------------------

local UnitFramePanelClass = MayronUI:RegisterModule("BottomUI_UnitFramePanel", true);

-- Load Database Defaults ----------------

db:AddToDefaults("profile.unitPanels", {
    enabled = true,
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

function UnitFramePanelClass:OnInitialize(data, buiContainer, subModules)
    data.sv = db.profile.unitPanels;
    data.buiContainer = buiContainer;
    data.ActionBarPanel = subModules.ActionBarPanel;

    if (data.sv.enabled) then
        self:SetEnabled(true);
    end

    self:SetupSUFPortraitGradients();
end

function UnitFramePanelClass:OnEnable(data)
    if (data.left) then
        return;
    end

    local font = tk.Constants.LSM:Fetch("font", db.global.core.font);
    local actionBarPanel = data.ActionBarPanel:GetPanel();

    obj:Assert(actionBarPanel, "ActionBarPanel cannot be loaded.");

    data.left = tk.CreateFrame("Frame", "MUI_UnitPanelLeft", data.buiContainer);
    data.right = tk.CreateFrame("Frame", "MUI_UnitPanelRight", _G.SUFUnittarget or data.buiContainer);
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
        local DataText = MayronUI:ImportModule("DataText");

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
    data.target.text:SetParent(_G.SUFUnittarget or data.buiContainer);
    data.target.text:SetFont(font, data.sv.unitNames.fontSize);
    data.target.text:SetJustifyH("RIGHT");
    data.target.text:SetWidth(data.target:GetWidth() - 25);
    data.target.text:SetWordWrap(false);
    data.target.text:SetPoint("RIGHT", data.target, "RIGHT", -15, 0);

    em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()
        if (_G.UnitExists("target")) then
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
            if (_G.UnitExists("target")) then
                if (data.right:GetParent() == data.buiContainer) then
                    data.right:Show();
                end

                data.left.bg:SetTexture(tk.Constants.MEDIA.."bottom_ui\\Double");
                data.right.bg:SetTexture(tk.Constants.MEDIA.."bottom_ui\\Double");

                if (data.sv.unitNames.targetClassColored) then
                    if (_G.UnitIsPlayer("target")) then
                        local _, class = _G.UnitClass("target");
                        tk:SetClassColoredTexture(class, data.target.bg);
                    else
                        tk:ApplyThemeColor(data.sv.alpha, data.target.bg);
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
            if (not _G.UnitExists("target")) then
                data.target.text:SetText(tk.Strings.Empty);
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

                if (_G.UnitExists("target")) then
                    if (data.sv.unitNames.targetClassColored) then

                        if (_G.UnitIsPlayer("target")) then
                            local _, class = _G.UnitClass("target");
                            tk:SetClassColoredTexture(class, data.target.bg);
                        else
                            tk:ApplyThemeColor(data.sv.alpha, data.target.bg);
                        end
                    end

                else
                    tk:ApplyThemeColor(data.sv.alpha, data.target.bg);
                end
            end);
        end
    end

    tk:ApplyThemeColor(data.sv.alpha,
        data.left.bg,
        data.center.bg,
        data.right.bg,
        data.player.bg,
        data.target.bg
    );

    data.right.bg:SetTexCoord(1, 0, 0, 1);

    if (tk.IsAddOnLoaded("ShadowedUnitFrames") and data.sv.controlGrid) then
        AttachShadowedUnitFrames(data.right);

        tk.hooksecurefunc(_G.ShadowUF, "ProfilesChanged", function()
            AttachShadowedUnitFrames(data.right);
        end);

        tk.hooksecurefunc("ReloadUI", DetachShadowedUnitFrames);
        em:CreateEventHandler("PLAYER_LOGOUT", DetachShadowedUnitFrames);
    end

    if (tk.IsAddOnLoaded("Grid") and data.sv.controlGrid) then
        if (_G.Grid.db:GetCurrentProfile() == "MayronUIH") then
            _G.GridLayoutFrame:ClearAllPoints();
            _G.GridLayoutFrame:SetPoint("BOTTOMRIGHT", data.target, "TOPRIGHT", -9, 0);
        end

        tk.hooksecurefunc(_G.Grid.db, "SetProfile", function()
            if (_G.Grid.db:GetCurrentProfile() == "MayronUIH") then
                _G.GridLayoutFrame:ClearAllPoints();
                _G.GridLayoutFrame:SetPoint("BOTTOMRIGHT", data.target, "TOPRIGHT", -9, 0);
            end
        end);
    end
end

function UnitFramePanelClass:UpdateUnitNameText(data, unitType, unitLevel)
    unitLevel = unitLevel or _G.UnitLevel(unitType);
    local name = _G.UnitName(unitType);

    if (#name > 22) then
        name = tk.Strings:Concat(name:sub(1, 22):trim(), "...");
    end

    local _, class = _G.UnitClass(unitType); -- not sure if this works..
    local classif = _G.UnitClassification(unitType);

    if (tonumber(unitLevel) < 1) then
        unitLevel = "boss";

    elseif (classif == "elite" or classif == "rareelite") then
        unitLevel = tk.tostring(unitLevel).."+";
    end

    if (classif == "rareelite" or classif == "rare") then
        unitLevel = "|cffff66ff"..unitLevel.."|r";
    end

    if (unitType ~= "player") then
        if (classif == "worldboss") then
            unitLevel = tk.Strings:GetRGBColoredText(unitLevel, 0.25, 0.75, 0.25); -- yellow
        else
            local color = tk:GetDifficultyColor(_G.UnitLevel(unitType));

            unitLevel = tk.Strings:GetRGBColoredText(unitLevel, color.r, color.g, color.b);
            name = (_G.UnitIsPlayer(unitType) and tk.Strings:GetClassColoredText(class, name)) or name;
        end

    else
        unitLevel = tk.Strings:GetRGBColoredText(unitLevel, 1, 0.8, 0);

        if (_G.UnitAffectingCombat("player")) then
            name = tk.Strings:GetRGBColoredText(name, 1, 0, 0);
        else
            name = tk.Strings:GetClassColoredText(class, name);
        end
    end

    data[unitType].text:SetText(tk.string.format("%s %s", name, unitLevel));
end

function UnitFramePanelClass:SetupSUFPortraitGradients(data)
    if (not _G.IsAddOnLoaded("ShadowedUnitFrames")) then
        return;
    end

    local sv = db.profile.bottomui.gradients;

    if (sv.enabled) then
        data.gradients = data.gradients or {};

        for _, unitID in ipairs({"player", "target"}) do
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
                                local from = sv.from;
                                local to = sv.to;

                                if (_G.UnitIsPlayer("target") and sv.targetClassColored) then
                                    local _, class = _G.UnitClass("target");
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

                if (unitID == "target" and _G.UnitExists("target")
                        and _G.UnitIsPlayer("target") and sv.targetClassColored) then

                    local _, class = _G.UnitClass("target");
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