-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local Private = {};

local pairs, string, tonumber, tostring = _G.pairs, _G.string, _G.tonumber, _G.tostring;
local UnitGUID, UnitLevel, UnitAffectingCombat = _G.UnitGUID, _G.UnitLevel, _G.UnitAffectingCombat;
local CreateFrame, UnitName, UnitClassification = _G.CreateFrame, _G.UnitName, _G.UnitClassification;
local IsAddOnLoaded, UnitExists, UnitIsPlayer, UnitClass, IsResting, GetRestState =
  _G.IsAddOnLoaded, _G.UnitExists, _G.UnitIsPlayer, _G.UnitClass, _G.IsResting, _G.GetRestState;
local InCombatLockdown = _G.InCombatLockdown;

-- Register Modules ----------------------

local C_UnitPanels = MayronUI:RegisterModule("BottomUI_UnitPanels", L["Unit Panels"], true);

-- Load Database Defaults ----------------

db:AddToDefaults("profile.unitPanels", {
  enabled = true;
  controlSUF = true;
  unitWidth = 325;
  unitHeight = 75;
  isSymmetric = false;
  targetClassColored = true;
  restingPulse = true;
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
  data:Embed(Private);

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

  local attachWrapper = function() data:AttachShadowedUnitFrames() end
  local detachWrapper = function() data:DetachShadowedUnitFrames() end

  self:RegisterUpdateFunctions(db.profile.unitPanels, {
    controlSUF = function(value)
      if (not IsAddOnLoaded("ShadowedUnitFrames")) then return end
      if (not value) then
        local handler = em:FindEventHandlerByKey("DetachSufOnLogout");

        if (handler) then
          handler:Destroy();
          data:DetachShadowedUnitFrames();
          tk:UnhookFunc(_G.ShadowUF, "ProfilesChanged", attachWrapper);
          tk:UnhookFunc("ReloadUI", detachWrapper);
        end
      else
        data:AttachShadowedUnitFrames();
        tk:HookFunc(_G.ShadowUF, "ProfilesChanged", attachWrapper);
        tk:HookFunc("ReloadUI", detachWrapper);
        em:CreateEventHandlerWithKey("PLAYER_LOGOUT", "DetachSufOnLogout", detachWrapper);
      end
    end;

    unitWidth = function(value)
      data.left:SetSize(value, 180);
      data.right:SetSize(value, 180)
    end;

    unitHeight = function()
      data.containerModule:RepositionContent();
    end;

    isSymmetric = function()
      data:RefreshSymmetrical();
    end;

    targetClassColored = function(value)
      em:FindEventHandlerByKey("targetClassColored");

      local handler = em:FindEventHandlerByKey("targetClassColored");

      if (handler) then
        handler:SetEnabled(value);
        handler:Run();
      end
    end;

    restingPulse = function(value)
      local handler = em:FindEventHandlerByKey("restingPulse");

      if (handler) then
        handler:SetEnabled(value);
        handler:Run();
      end
    end;

    alpha = function(value)
      for _, key in obj:IterateArgs("left", "center", "right", "player", "target") do
        if (obj:IsWidget(data[key]) and obj:IsWidget(data[key].bg)) then
          data:SetAlpha(data[key], value);
        end
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
        data:RefreshSymmetrical();
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
  end

  local handler = em:FindEventHandlerByKey("restingPulse");

  if (handler) then
    handler:SetEnabled(false);
  end
end

function C_UnitPanels:OnEnable(data)
  if (data.left) then
    data.left:Show();
    data.right:Show();
    data.center:Show();
    return;
  end

  data.left = CreateFrame("Frame", "MUI_UnitPanelLeft", _G["MUI_BottomContainer"]);
  data.right = CreateFrame("Frame", "MUI_UnitPanelRight", _G.SUFUnittarget or _G["MUI_BottomContainer"]);
  data.center = CreateFrame("Frame", "MUI_UnitPanelCenter", data.right);

  data.left:SetFrameStrata("BACKGROUND");
  data.center:SetFrameStrata("BACKGROUND");
  data.right:SetFrameStrata("BACKGROUND");

  data.center:SetPoint("TOPLEFT", data.left, "TOPRIGHT");
  data.center:SetPoint("TOPRIGHT", data.right, "TOPLEFT");
  data.center:SetPoint("BOTTOMLEFT", data.left, "BOTTOMRIGHT");
  data.center:SetPoint("BOTTOMRIGHT", data.right, "BOTTOMLEFT");

  data.center.bg = tk:SetBackground(data.center, tk:GetAssetFilePath("Textures\\BottomUI\\Center"));
  data.center.hasGradient = true;

  em:CreateEventHandlerWithKey("PLAYER_TARGET_CHANGED", "targetClassColored", function()
    local alpha = data.settings.alpha; -- might be resting and pulsing
    local r, g, b = data.left.bg:GetVertexColor();

    if (not (UnitExists("target") and UnitIsPlayer("target") and data.settings.targetClassColored)) then
      data.right.bg:SetVertexColor(r, g, b, alpha);
      data.center.bg:SetGradientAlpha("HORIZONTAL", r, g, b, alpha, r, g, b, alpha);
      return;
    end

    local target = tk:GetUnitClassColor("target");
    data.right.bg:SetVertexColor(target.r, target.g, target.b, alpha);
    data.center.bg:SetGradientAlpha("HORIZONTAL", r, g, b, alpha, target.r, target.g, target.b, alpha);
  end);
end

function C_UnitPanels:OnEnabled(data)
  local handler = em:FindEventHandlerByKey("restingPulse");

  if (handler) then
    handler:SetEnabled(true);
  else
    handler = em:CreateEventHandlerWithKey("PLAYER_UPDATE_RESTING", "restingPulse", function()
      if (IsResting() and data.settings.restingPulse) then
        for _, key in obj:IterateArgs("left", "center", "right", "player", "target") do
          if (obj:IsWidget(data[key]) and obj:IsWidget(data[key].bg)) then
            data[key]:SetScript("OnUpdate", function(...) data:UnitPanels_UpdateAlpha(...) end);
          end
        end
      else
        for _, key in obj:IterateArgs("left", "center", "right", "player", "target") do
          if (obj:IsWidget(data[key]) and obj:IsWidget(data[key].bg)) then
            data[key]:SetScript("OnUpdate", nil);
            data:SetAlpha(data[key], data.settings.alpha);
          end
        end
      end

      self:UpdateUnitNameText("player");
    end);

    handler:AppendEvent("PLAYER_ENTERING_WORLD");
  end

  handler:Run();
end

function C_UnitPanels:SetUpUnitNames(data)
    local nameTextureFilePath = tk:GetAssetFilePath("Textures\\BottomUI\\NamePanel");

    data.player = CreateFrame("Frame", "MUI_PlayerName", data.left);
    data.player.bg = tk:SetBackground(data.player, nameTextureFilePath);
    data.player.text = data.player:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    data.player.text:SetJustifyH("LEFT");
    data.player.text:SetWordWrap(false);
    data.player.text:SetPoint("LEFT", 15, 0);

    data.target = CreateFrame("Frame", "MUI_TargetName", data.right);
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

        if (data.settings.restingPulse) then
          for _, key in obj:IterateArgs("left", "center", "right", "player", "target") do
            if (obj:IsWidget(data[key]) and obj:IsWidget(data[key].bg)) then
              data[key]:SetScript("OnUpdate", function(...) data:UnitPanels_UpdateAlpha(...) end);
            end
          end
        end
      end);

      handler:SetKey("PlayerUnitName_RegenEnabled");
    end

    handler = em:FindEventHandlerByKey("PlayerUnitName_RegenDisabled", "PLAYER_REGEN_DISABLED");

    if (not handler) then
      handler = em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
        self:UpdateUnitNameText("player");

        for _, key in obj:IterateArgs("left", "center", "right", "player", "target") do
          if (obj:IsWidget(data[key]) and obj:IsWidget(data[key].bg)) then
            data[key]:SetScript("OnUpdate", nil);
            data:SetAlpha(data[key], data.settings.alpha);
          end
        end
      end);

      handler:SetKey("PlayerUnitName_RegenDisabled");
    end

    handler = em:FindEventHandlerByKey("PlayerUnitName_TargetChanged", "PLAYER_TARGET_CHANGED");

    if (not handler) then
      handler = em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()
        if (UnitExists("target")) then
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

function C_UnitPanels:UpdateUnitNameText(data, unitType, unitLevel)
  unitLevel = unitLevel or UnitLevel(unitType);

  local name = UnitName(unitType);
  name = tk.Strings:SetOverflow(name, 22);

  local _, class = UnitClass(unitType); -- not sure if this works..
  local classification = UnitClassification(unitType);

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
      local color = tk:GetDifficultyColor(UnitLevel(unitType));

      unitLevel = tk.Strings:SetTextColorByRGB(unitLevel, color.r, color.g, color.b);
      name = (UnitIsPlayer(unitType) and tk.Strings:SetTextColorByClass(name, class)) or name;
    end
  else
    unitLevel = tk.Strings:SetTextColorByRGB(unitLevel, 1, 0.8, 0);

    if (UnitAffectingCombat("player")) then
      name = tk.Strings:SetTextColorByRGB(name, 1, 0, 0);
      tk:SetBasicTooltip(data[unitType], _G.COMBAT, "ANCHOR_CURSOR");
    elseif (IsResting()) then
      name = tk.Strings:SetTextColorByRGB(name, 0, 1, 1);
      local _, exhaustionStateName = GetRestState();
      tk:SetBasicTooltip(data[unitType], exhaustionStateName, "ANCHOR_CURSOR");
    else
      name = tk.Strings:SetTextColorByClass(name, class);
      tk:SetBasicTooltip(data[unitType], nil, "ANCHOR_CURSOR");
    end
  end

  data[unitType].text:SetText(string.format("%s %s", name, unitLevel));
end

function C_UnitPanels:SetPortraitGradientsEnabled(data, enabled)
  if (not IsAddOnLoaded("ShadowedUnitFrames")) then return end

  if (enabled) then
    data.gradients = data.gradients or obj:PopTable();

    for _, unitID in obj:IterateArgs("player", "target") do
      local parent = _G["SUFUnit"..unitID];

      if (parent and parent.portrait) then
        data.gradients[unitID] = data.gradients[unitID] or
        data:CreateGradientFrame(parent);

        if (unitID == "target") then
          local frame = data.gradients[unitID];
          local handler = em:FindEventHandlerByKey("TargetGradient");

          if (not handler) then
            handler = em:CreateEventHandlerWithKey("PLAYER_TARGET_CHANGED", "TargetGradient", function()
              if (not UnitExists("target")) then return end

              local from = data.settings.sufGradients.from;
              local to = data.settings.sufGradients.to;

              if (UnitIsPlayer("target") and data.settings.sufGradients.targetClassColored) then
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
do
  local FLASH_TIME_ON = 0.65;
  local FLASH_TIME_OFF = 0.65;
  local ALPHA_INCREASE_AMOUNT = 0.2;

  function Private:UnitPanels_UpdateAlpha(frame, elapsed)
    if (InCombatLockdown()) then return end
    frame.pulseTime = (frame.pulseTime or 0) - elapsed;

    if (frame.pulseTime < 0) then
      local overtime = -frame.pulseTime;

      if (frame.isPulsing == 0) then
        frame.isPulsing = 1;
        frame.pulseTime = FLASH_TIME_ON;
      else
        frame.isPulsing = 0;
        frame.pulseTime = FLASH_TIME_OFF;
      end

      if (overtime < frame.pulseTime) then
        frame.pulseTime = frame.pulseTime - overtime;
      end
    end

    local alpha;

    if (frame.isPulsing == 1) then
      alpha = (FLASH_TIME_ON - frame.pulseTime) / FLASH_TIME_ON;
    else
      alpha = frame.pulseTime / FLASH_TIME_ON;
    end

    local maxAlpha = (self.settings.alpha + ALPHA_INCREASE_AMOUNT);
    local minAlpha =  self.settings.alpha;

    if (maxAlpha > 1) then
      maxAlpha = 1;
      minAlpha = 1 - ALPHA_INCREASE_AMOUNT;
    end

    alpha = (alpha * (maxAlpha - minAlpha)) + minAlpha;
    self:SetAlpha(frame, alpha);
  end
end

function Private:CreateGradientFrame(parent)
  local frame = CreateFrame("Frame", nil, parent);
  frame:SetPoint("TOPLEFT", 1, -1);
  frame:SetPoint("TOPRIGHT", -1, -1);
  frame:SetFrameLevel(5);
  frame.texture = frame:CreateTexture(nil, "OVERLAY");
  frame.texture:SetAllPoints(frame);
  frame.texture:SetColorTexture(1, 1, 1, 1);
  frame:SetSize(100, self.settings.sufGradients.height);
  frame:Show();

  local from = self.settings.sufGradients.from;
  local to = self.settings.sufGradients.to;

  frame.texture:SetGradientAlpha("VERTICAL",
    to.r, to.g, to.b, to.a, from.r, from.g, from.b, from.a);

  return frame;
end

function Private:DetachShadowedUnitFrames()
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

function Private:AttachShadowedUnitFrames()
  if (not self.center) then return end

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
    self.right:SetFrameStrata("LOW");
  end

  if (_G.SUFUnittargettarget) then
    _G.SUFUnittargettarget:SetFrameStrata("MEDIUM");
  end

  _G.ShadowUF.Layout:Reload("targettarget");
end

do
  local doubleTextureFilePath = tk:GetAssetFilePath("Textures\\BottomUI\\Double");
  local singleTextureFilePath = tk:GetAssetFilePath("Textures\\BottomUI\\Single");

  local function SwitchToSingle(data)
    if (data.target) then
      data.target.text:SetText(tk.Strings.Empty);
    end

    data.right:SetAlpha(0);
    data.left.bg:SetAlpha(0);
    data.left.noTargetBg:SetAlpha(data.settings.alpha);
  end

  function Private:RefreshSymmetrical()
    if (not self.left.bg) then
      self.left.bg = tk:SetBackground(self.left, doubleTextureFilePath);
      self.right.bg = tk:SetBackground(self.right, doubleTextureFilePath);
      self.right.bg:SetTexCoord(1, 0, 0, 1);
      tk:ApplyThemeColor(self.settings.alpha, self.left.bg);
    end

    if (self.settings.isSymmetric) then
      self:EnableSymmetry();
    else
      self:DisableSymmetry();
    end
  end

  function Private:DisableSymmetry()
    if (not self.left.noTargetBg) then
      -- create single texture
      self.left.noTargetBg = tk:SetBackground(self.left, singleTextureFilePath);
      tk:ApplyThemeColor(self.settings.alpha, self.left.noTargetBg);
    end

    self.right:SetParent(_G["MUI_BottomContainer"]);
    local handler = em:FindEventHandlerByKey("DisableSymmetry_TargetChanges");

    if (not handler) then
      handler = em:CreateEventHandlerWithKey("PLAYER_TARGET_CHANGED", "DisableSymmetry_TargetChanges", function()
        if (not UnitExists("target")) then
          SwitchToSingle(self);
          return;
        end

        -- if data.right is not attached to SUF, show it manually!
        if (self.right:GetParent() ==_G["MUI_BottomContainer"]) then
          self.right:SetAlpha(1);
        end

        self.left.bg:SetAlpha(self.settings.alpha);
        self.left.noTargetBg:SetAlpha(0);

        if (self.settings.unitNames.targetClassColored) then
          if (UnitIsPlayer("target")) then
            local _, class = UnitClass("target");
            tk:SetClassColoredTexture(class, self.target.bg);
          else
            tk:ApplyThemeColor(self.settings.alpha, self.target.bg);
          end
        end
      end);
    end

    handler:Run();

    if (not em:FindEventHandlerByKey("DisableSymmetry_EnteringWorld")) then
      em:CreateEventHandlerWithKey("PLAYER_ENTERING_WORLD", "DisableSymmetry_EnteringWorld", function()
        if (not UnitExists("target")) then
          SwitchToSingle(self);
        end
      end);
    end

    em:DestroyEventHandlersByKey("EnableSymmetry_TargetChanged");
  end

  function Private:EnableSymmetry()
    if (self.left.noTargetBg) then
      -- create single texture
      self.left.noTargetBg:SetAlpha(0);
    end

    self.right:SetParent(_G["MUI_BottomContainer"]);
    self.right:SetAlpha(1);
    self.left.bg:SetAlpha(self.settings.alpha);

    local handler = em:FindEventHandlerByKey("EnableSymmetry_TargetChanged", "PLAYER_TARGET_CHANGED");

    if (not self.settings.unitNames.targetClassColored) then
      if (handler) then
        handler:Destroy();
      end

      return;
    end

    if (not handler) then
      handler = em:CreateEventHandler("PLAYER_TARGET_CHANGED", function()
        if (not self.target) then return; end
        local targetClassColored = self.settings.unitNames.targetClassColored;

        if (targetClassColored and UnitExists("target") and UnitIsPlayer("target")) then
          tk:SetClassColoredTexture(UnitClass("target"), self.target.bg);
        else
          tk:ApplyThemeColor(self.settings.alpha, self.target.bg);
        end
      end);

      handler:SetKey("EnableSymmetry_TargetChanged");
    end

    handler:Run();
    em:DestroyEventHandlersByKey("DisableSymmetry_TargetChanges", "DisableSymmetry_EnteringWorld");
  end
end

function Private:SetAlpha(frame, alpha)
  if (frame.noTargetBg) then
    if (UnitExists("target") or self.settings.isSymmetric) then
      frame.noTargetBg:SetAlpha(0);
      frame.bg:SetAlpha(alpha);
    else
      frame.noTargetBg:SetAlpha(alpha);
      frame.bg:SetAlpha(0);
    end
  else
    frame.bg:SetAlpha(alpha);
  end

  local r, g, b = self.left.bg:GetVertexColor();

  if (frame.hasGradient) then
    if (UnitExists("target") and UnitIsPlayer("target") and self.settings.targetClassColored) then
      local target = tk:GetUnitClassColor("target");

      frame.bg:SetGradientAlpha("HORIZONTAL", r, g, b, alpha, target.r, target.g, target.b, alpha);
    else
      frame.bg:SetGradientAlpha("HORIZONTAL", r, g, b, alpha, r, g, b, alpha);
    end
  end
end