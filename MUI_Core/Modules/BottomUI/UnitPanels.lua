-- luacheck: ignore self 143 631
local _G, MayronUI = _G, _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local Private = {};

local pairs, string, tonumber, tostring = _G.pairs, _G.string, _G.tonumber, _G.tostring;
local UnitGUID = _G.UnitGUID;

-- Register Modules ----------------------

local C_UnitPanels = MayronUI:RegisterModule("BottomUI_UnitPanels", "Unit Panels", true);

-- Load Database Defaults ----------------

db:AddToDefaults("profile.unitPanels", {
    enabled = true;
    grid = {
        anchorGrid = true; -- anchor Grid Frame to top of Unit Panels
        point = "BOTTOMRIGHT";
        anchorFrame = "Target";
        xOffset = -9;
        yOffset = 0;
        gridProfiles = {
            "MayronUIH"
        };
    };
    controlSUF = true;
    unitWidth = 325;
    unitHeight = 75;
    isSymmetric = false;
    alpha = 0.8;
    unitNames = {
        enabled = true;
        width = 235;
        height = 20;
        fontSize = 11;
        targetClassColored = true;
        xOffset = 24;
    };
    sufGradients = {
        enabled = true;
        height = 24;
        targetClassColored = true;
    };
});

-- UnitPanels Module -----------------

function C_UnitPanels:OnInitialize(data, containerModule)
    data.containerModule = containerModule;

    local r, g, b = tk:GetThemeColor();
    db:AppendOnce(db.profile, "unitPanels.sufGradients", nil, {
        from = {r = r, g = g, b = b, a = 0.5},
        to = {r = 0, g = 0, b = 0, a = 0}
    });

    local options = {
        onExecuteAll = {
            dependencies = {
                ["unitNames[.].*"] = "unitNames.enabled";
            };
            ignore = { "unitHeight" };
        };
    };

    self:RegisterUpdateFunctions(db.profile.unitPanels, {
        grid = {
            anchorGrid = function(value)
                if (not _G.IsAddOnLoaded("Grid")) then return; end

                if (not value) then
                    Private.AnchorGridFrame(data.settings.grid);
                    tk:HookFunc(_G.Grid.db, "SetProfile", Private.AnchorGridFrame, data.settings.grid);
                else
                    tk:UnhookFunc(_G.Grid.db, "SetProfile", Private.AnchorGridFrame);
                end
            end;
        };

        controlSUF = function(value)
            if (not _G.IsAddOnLoaded("ShadowedUnitFrames")) then return; end

            if (not value) then
                local handler = em:FindEventHandlerByKey("DetachSufOnLogout");

                if (handler) then
                    handler:Destroy();
                    Private.DetachShadowedUnitFrames();
                    tk:UnhookFunc(_G.ShadowUF, "ProfilesChanged", Private.AttachShadowedUnitFrames);
                    tk:UnhookFunc("ReloadUI", Private.DetachShadowedUnitFrames);
                end
            else
                Private.AttachShadowedUnitFrames(data.right);
                tk:HookFunc(_G.ShadowUF, "ProfilesChanged", Private.AttachShadowedUnitFrames, data.right);
                tk:HookFunc("ReloadUI", Private.DetachShadowedUnitFrames);
                em:CreateEventHandlerWithKey("PLAYER_LOGOUT", "DetachSufOnLogout", Private.DetachShadowedUnitFrames);
            end
        end;

        unitWidth = function(value)
            data.left:SetSize(value, 180);
            data.right:SetSize(value, 180)
        end;

        unitHeight = function()
            data.containerModule:RepositionContent();
        end;

        isSymmetric = function(value)
            self:SetSymmetrical(value);
        end;

        alpha = function(value)
            if (data.left.noTargetBg) then
                -- if not symmetric then this will not exist
                data.left.noTargetBg:SetAlpha(value);
            end

            data.left.bg:SetAlpha(value);
            data.center.bg:SetAlpha(value);
            data.right.bg:SetAlpha(value);

            if (data.player and data.target) then
                data.player.bg:SetAlpha(value);
                data.target.bg:SetAlpha(value);
            end
        end;

        unitNames = {
            enabled = function(value)
                self:SetUnitNamesEnabled(value);
            end;

            width = function(value)
                data.player:SetSize(value, data.settings.unitNames.height);
                data.target:SetSize(value, data.settings.unitNames.height);
                data.player.text:SetWidth(value - 25);
                data.target.text:SetWidth(value - 25);
            end;

            height = function(value)
                data.player:SetSize(data.settings.unitNames.width, value);
                data.target:SetSize(data.settings.unitNames.width, value);
            end;

            fontSize = function(value)
                local font = tk.Constants.LSM:Fetch("font", db.global.core.font);
                data.player.text:SetFont(font, value);
                data.target.text:SetFont(font, value);
            end;

            targetClassColored = function()
                self:SetSymmetrical(data.settings.isSymmetric);
            end;

            xOffset = function(value)
                data.player:SetPoint("BOTTOMLEFT", data.left, "TOPLEFT", value, 0);
                data.target:SetPoint("BOTTOMRIGHT", data.right, "TOPRIGHT", -(value), 0);
            end;
        };

        sufGradients = {
            enabled = function(value)
                self:SetPortraitGradientsEnabled(value);
            end;

            height = function(value)
                if (data.settings.sufGradients.enabled and data.gradients) then
                    for _, frame in pairs(data.gradients) do
                        frame:SetSize(100, value);
                    end
                end
            end;

            targetClassColored = function()
                if (data.settings.sufGradients.enabled) then
                    local handler = em:FindEventHandlerByKey("TargetGradient", "PLAYER_TARGET_CHANGED");

                    if (handler) then
                        handler:Run();
                    end
                end
            end;
        };
    }, options);

    if (data.settings.enabled) then
        self:SetEnabled(true);
    end
end

function C_UnitPanels:OnDisable(data)
    if (data.left) then
        data.left:Hide();
        data.right:Hide();
        data.center:Hide();
        return;
    end
end

function C_UnitPanels:OnEnable(data)
    if (data.left) then
        data.left:Show();
        data.right:Show();
        data.center:Show();
        return;
    end

    data.left = _G.CreateFrame("Frame", "MUI_UnitPanelLeft", _G["MUI_BottomContainer"]);
    data.right = _G.CreateFrame("Frame", "MUI_UnitPanelRight", _G.SUFUnittarget or _G["MUI_BottomContainer"]);
    data.center = _G.CreateFrame("Frame", "MUI_UnitPanelCenter", data.right);

    data.left:SetFrameStrata("BACKGROUND");
    data.center:SetFrameStrata("BACKGROUND");
    data.right:SetFrameStrata("BACKGROUND");

    data.center:SetPoint("TOPLEFT", data.left, "TOPRIGHT");
    data.center:SetPoint("TOPRIGHT", data.right, "TOPLEFT");
    data.center:SetPoint("BOTTOMLEFT", data.left, "BOTTOMRIGHT");
    data.center:SetPoint("BOTTOMRIGHT", data.right, "BOTTOMLEFT");
    data.center.bg = tk:SetBackground(data.center, tk:GetAssetFilePath("Textures\\BottomUI\\Center"));
end

function C_UnitPanels:SetUpUnitNames(data)

    local nameTextureFilePath = tk:GetAssetFilePath("Textures\\BottomUI\\NamePanel");

    data.player = _G.CreateFrame("Frame", "MUI_PlayerName", data.left);
    data.player.bg = tk:SetBackground(data.player, nameTextureFilePath);
    data.player.text = data.player:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    data.player.text:SetJustifyH("LEFT");
    data.player.text:SetWordWrap(false);
    data.player.text:SetPoint("LEFT", 15, 0);

    data.target = _G.CreateFrame("Frame", "MUI_TargetName", data.right);
    data.target.bg = tk:SetBackground(data.target, nameTextureFilePath);
    data.target.text = data.target:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    data.target.text:SetParent(_G.SUFUnittarget or _G["MUI_BottomContainer"]);
    data.target.text:SetJustifyH("RIGHT");
    data.target.text:SetWordWrap(false);
    data.target.text:SetPoint("RIGHT", data.target, "RIGHT", -15, 0);

    tk:ApplyThemeColor(data.settings.alpha, data.player.bg, data.target.bg);

    tk:FlipTexture(data.target.bg, "HORIZONTAL");
    self:UpdateUnitNameText("player");
end

function C_UnitPanels:SetUnitNamesEnabled(data, enabled)
    if (enabled) then
        if (not (data.player and data.target)) then
            self:SetUpUnitNames(data);
        end

        data.player:Show();
        data.target:Show();

        local handler = em:FindEventHandlerByKey("PlayerUnitName_LevelUp", "PLAYER_LEVEL_UP");

        if (not handler and not tk:IsPlayerMaxLevel()) then
            handler = em:CreateEventHandler("PLAYER_LEVEL_UP", function(createdHandler, _, newLevel)
                self:UpdateUnitNameText("player", newLevel);

                if (UnitGUID("player") == UnitGUID("target")) then
                    self:UpdateUnitNameText("target", newLevel);
                end

                if (tk:IsPlayerMaxLevel()) then
                    createdHandler:Destroy();
                end
            end);

            handler:SetKey("PlayerUnitName_LevelUp");
        end

        handler = em:FindEventHandlerByKey("PlayerUnitName_RegenEnabled", "PLAYER_REGEN_ENABLED");

        if (not handler) then
            handler = em:CreateEventHandler("PLAYER_REGEN_ENABLED", function()
                self:UpdateUnitNameText("player");
            end);

            handler:SetKey("PlayerUnitName_RegenEnabled");
        end

        handler = em:FindEventHandlerByKey("PlayerUnitName_RegenDisabled", "PLAYER_REGEN_DISABLED");

        if (not handler) then
            handler = em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
                self:UpdateUnitNameText("player");
            end);

            handler:SetKey("PlayerUnitName_RegenDisabled");
        end

        handler = em:FindEventHandlerByKey("PlayerUnitName_TargetChanged", "PLAYER_TARGET_CHANGED");

        if (not handler) then
            handler = em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()
                if (_G.UnitExists("target")) then
                    self:UpdateUnitNameText("target");
                end
            end);

            handler:SetKey("PlayerUnitName_TargetChanged");
        end
    elseif (data.player and data.target) then
        data.player:Hide();
        data.target:Hide();

        em:DestroyEventHandlersByKey(
            "PlayerUnitName_LevelUp", "PlayerUnitName_RegenEnabled",
            "PlayerUnitName_RegenDisabled", "PlayerUnitName_TargetChanged");
    end
end

do
    local doubleTextureFilePath = tk:GetAssetFilePath("Textures\\BottomUI\\Double");

    function C_UnitPanels:SetSymmetrical(data, isSymmetric)
        if (not data.left.bg) then
            data.left.bg = tk:SetBackground(data.left, doubleTextureFilePath);
            data.right.bg = tk:SetBackground(data.right, doubleTextureFilePath);
            data.right.bg:SetTexCoord(1, 0, 0, 1);

            tk:ApplyThemeColor(data.settings.alpha,
                data.left.bg,
                data.center.bg,
                data.right.bg
            );
        end

        if (isSymmetric) then
            Private.EnableSymmetry(data);
        else
            Private.DisableSymmetry(data);
        end
    end
end

function C_UnitPanels:UpdateUnitNameText(data, unitType, unitLevel)
    unitLevel = unitLevel or _G.UnitLevel(unitType);

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

    data[unitType].text:SetText(string.format("%s %s", name, unitLevel));
end

function Private.CreateGradientFrame(data, parent)
    local frame = _G.CreateFrame("Frame", nil, parent);
    frame:SetPoint("TOPLEFT", 1, -1);
    frame:SetPoint("TOPRIGHT", -1, -1);
    frame:SetFrameLevel(5);
    frame.texture = frame:CreateTexture(nil, "OVERLAY");
    frame.texture:SetAllPoints(frame);
    frame.texture:SetColorTexture(1, 1, 1, 1);
    frame:SetSize(100, data.settings.sufGradients.height);
    frame:Show();

    local from = data.settings.sufGradients.from;
    local to = data.settings.sufGradients.to;

    frame.texture:SetGradientAlpha("VERTICAL",
        to.r, to.g, to.b, to.a,
        from.r, from.g, from.b, from.a);

    return frame;
end

function C_UnitPanels:SetPortraitGradientsEnabled(data, enabled)
    if (not _G.IsAddOnLoaded("ShadowedUnitFrames")) then
        return;
    end

    if (enabled) then
        data.gradients = data.gradients or obj:PopTable();

        for _, unitID in obj:IterateArgs("player", "target") do
            local parent = _G["SUFUnit"..unitID];

            if (parent and parent.portrait) then
                data.gradients[unitID] = data.gradients[unitID] or
                    Private.CreateGradientFrame(data, parent);

                if (unitID == "target") then
                    local frame = data.gradients[unitID];
                    local handler = em:FindEventHandlerByKey("TargetGradient");

                    if (not handler) then
                        handler = em:CreateEventHandlerWithKey("PLAYER_TARGET_CHANGED", "TargetGradient", function()
                            if (not _G.UnitExists("target")) then
                                return;
                            end

                            local from = data.settings.sufGradients.from;
                            local to = data.settings.sufGradients.to;

                            if (_G.UnitIsPlayer("target") and data.settings.sufGradients.targetClassColored) then
                                local classColor = tk:GetUnitClassColor("target");

                                frame.texture:SetGradientAlpha("VERTICAL",
                                    to.r, to.g, to.b, to.a,
                                    classColor.r, classColor.g, classColor.b, from.a);
                            else
                                frame.texture:SetGradientAlpha("VERTICAL",
                                    to.r, to.g, to.b, to.a,
                                    from.r, from.g, from.b, from.a);
                            end
                        end);
                    end

                    handler:Run();
                end

                data.gradients[unitID]:Show();

            elseif (data.gradients[unitID]) then
                data.gradients[unitID]:Hide();
            end
        end
    else
        if (data.gradients) then
            for _, frame in pairs(data.gradients) do
                frame:Hide();
            end
        end

        local handler = em:FindEventHandlerByKey("TargetGradient");

        if (handler) then
            handler:Destroy();
        end
    end
end

-- Private Functions -------------------------

function Private.DetachShadowedUnitFrames()
    for _, profileTable in pairs(_G.ShadowedUFDB.profiles) do

        if (obj:IsTable(profileTable) and obj:IsTable(profileTable.positions)) then
            local p = profileTable.positions.targettarget;

            if (obj:IsTable(p) and p.anchorTo == "MUI_UnitPanelCenter") then
                p.point = "TOP";
                p.anchorTo = "UIParent";
                p.relativePoint = "TOP";
                p.x = 100;
                p.y = -100;
            end
        end
    end
end

function Private.AttachShadowedUnitFrames(rightPanel)
    if (not _G.MUI_UnitPanelCenter) then
        return;
    end

    local SUFTargetTarget = _G.ShadowUF.db.profile.positions.targettarget;

    SUFTargetTarget.point = "TOP";
    SUFTargetTarget.anchorTo = "MUI_UnitPanelCenter";
    SUFTargetTarget.relativePoint = "TOP";
    SUFTargetTarget.x = 0;
    SUFTargetTarget.y = -40;

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

    _G.ShadowUF.Layout:Reload("targettarget");
end

function Private.AnchorGridFrame(settings)
    if (tk.Tables:Contains(settings.gridProfiles, _G.Grid.db:GetCurrentProfile())) then
        _G.GridLayoutFrame:ClearAllPoints();
        _G.GridLayoutFrame:SetPoint(settings.point, settings.target,
            "TOPRIGHT", settings.xOffset, settings.yOffset);
    end
end

do
    local singleTextureFilePath = tk:GetAssetFilePath("Textures\\BottomUI\\Single");

    local function SwitchToSingle(data)
        if (data.target) then
            data.target.text:SetText(tk.Strings.Empty);
        end

        data.right:SetAlpha(0);
        data.left.bg:SetAlpha(0);
        data.left.noTargetBg:SetAlpha(data.settings.alpha);
    end

    function Private.DisableSymmetry(data)
        if (not data.left.noTargetBg) then
            -- create single texture
            data.left.noTargetBg = tk:SetBackground(data.left, singleTextureFilePath);
            tk:ApplyThemeColor(data.settings.alpha, data.left.noTargetBg);
        end

        data.right:SetParent(_G["MUI_BottomContainer"]);
        local handler = em:FindEventHandlerByKey("DisableSymmetry_TargetChanges");

        if (not handler) then
            handler = em:CreateEventHandlerWithKey("PLAYER_TARGET_CHANGED", "DisableSymmetry_TargetChanges", function()
                if (not _G.UnitExists("target")) then
                    SwitchToSingle(data);
                    return;
                end

                -- if data.right is not attached to SUF, show it manually!
                if (data.right:GetParent() ==_G["MUI_BottomContainer"]) then
                    data.right:SetAlpha(1);
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
            end);
        end

        handler:Run();

        if (not em:FindEventHandlerByKey("DisableSymmetry_EnteringWorld")) then
            em:CreateEventHandlerWithKey("PLAYER_ENTERING_WORLD", "DisableSymmetry_EnteringWorld", function()
                if (not _G.UnitExists("target")) then
                    SwitchToSingle(data);
                end
            end);
        end

        em:DestroyEventHandlersByKey("EnableSymmetry_TargetChanged");
    end

    function Private.EnableSymmetry(data)
        if (data.left.noTargetBg) then
            -- create single texture
            data.left.noTargetBg:SetAlpha(0);
        end

        data.right:SetParent(_G["MUI_BottomContainer"]);
        data.right:SetAlpha(1);
        data.left.bg:SetAlpha(data.settings.alpha);

        local handler = em:FindEventHandlerByKey("EnableSymmetry_TargetChanged", "PLAYER_TARGET_CHANGED");

        if (not data.settings.unitNames.targetClassColored) then
            if (handler) then
                handler:Destroy();
            end

            return;
        end

        if (not handler) then
            handler = em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()
                if (not data.target) then return; end
                local targetClassColored = data.settings.unitNames.targetClassColored;

                if (targetClassColored and _G.UnitExists("target") and _G.UnitIsPlayer("target")) then
                    tk:SetClassColoredTexture(_G.UnitClass("target"), data.target.bg);
                else
                    tk:ApplyThemeColor(data.settings.alpha, data.target.bg);
                end
            end);

            handler:SetKey("EnableSymmetry_TargetChanged");
        end

        handler:Run();
        em:DestroyEventHandlersByKey("DisableSymmetry_TargetChanges", "DisableSymmetry_EnteringWorld");
    end
end