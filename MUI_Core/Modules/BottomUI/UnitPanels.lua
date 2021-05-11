-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local CreateFrame, pairs, ipairs = _G.CreateFrame, _G.pairs, _G.ipairs;
local IsAddOnLoaded, UnitExists, UnitIsPlayer = _G.IsAddOnLoaded, _G.UnitExists, _G.UnitIsPlayer;
local C_UnitPanels = MayronUI:RegisterModule("UnitPanels", L["Unit Panels"], true);

-- Load Database Defaults ----------------

db:AddToDefaults("profile.unitPanels", {
  enabled = true;
  controlSUF = true;
  unitWidth = 325;
  unitHeight = 75;
  isSymmetric = false;
  targetClassColored = true;
  restingPulse = true;
  pulseStrength = 0.3;
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
        ["restingPulse"] = "unitNames.enabled";
      };
      ignore = { "unitHeight", "alpha" };
    };
  };

  local attachWrapper = function() data:Call("AttachShadowedUnitFrames") end
  local detachWrapper = function() data:Call("DetachShadowedUnitFrames") end

  self:RegisterUpdateFunctions(db.profile.unitPanels, {
    controlSUF = function(value)
      if (not IsAddOnLoaded("ShadowedUnitFrames")) then return end
      local listener = em:GetEventListenerByID("MuiDetachSuf_Logout");

      if (not value) then

        if (listener) then
          listener:UnregisterEvent("PLAYER_LOGOUT");
          data:Call("DetachShadowedUnitFrames");
          tk:UnhookFunc(_G.ShadowUF, "ProfilesChanged", attachWrapper);
          tk:UnhookFunc("ReloadUI", detachWrapper);
        end
      else
        data:Call("AttachShadowedUnitFrames");
        tk:HookFunc(_G.ShadowUF, "ProfilesChanged", attachWrapper);
        tk:HookFunc("ReloadUI", detachWrapper);
        listener = listener or em:CreateEventListenerWithID("MuiDetachSuf_Logout", detachWrapper);
        listener:RegisterEvent("PLAYER_LOGOUT");
      end
    end;

    unitWidth = function(value)
      data.left:SetSize(value, 180);
      data.right:SetSize(value, 180);
    end;

    unitHeight = function()
      data.containerModule:RepositionContent();
    end;

    isSymmetric = function(value)
      self:SetSymmetricalEnabled(value);
    end;

    targetClassColored = function(value)
      local listener = em:GetEventListenerByID("targetClassColored");

      if (listener) then
        listener:SetEnabled(value);
        em:TriggerEventListener(listener);
      end
    end;

    restingPulse = function(value)
      self:SetRestingPulseEnabled(value);
    end;

    alpha = function()
      data:Call("UpdateAllVisuals");
    end;

    unitNames = {
      enabled = function(value)
        self:SetUnitNamesEnabled(value);
      end;

      width = function(value)
        if (data.player and data.target) then
          data.player:SetSize(value, data.settings.unitNames.height);
          data.target:SetSize(value, data.settings.unitNames.height);
          data.player.text:SetWidth(value - 25);
          data.target.text:SetWidth(value - 25);
        end
      end;

      height = function(value)
        if (data.player and data.target) then
          data.player:SetSize(data.settings.unitNames.width, value);
          data.target:SetSize(data.settings.unitNames.width, value);
        end
      end;

      fontSize = function(value)
        local font = tk.Constants.LSM:Fetch("font", db.global.core.font);

        if (data.player and data.target) then
          data.player.text:SetFont(font, value);
          data.target.text:SetFont(font, value);
        end
      end;

      targetClassColored = function()
        if (data.player and data.target) then
          em:TriggerEventListenerByID("MuiUnitNames_TargetChanged");
        end
      end;

      xOffset = function(value)
        if (data.player and data.target) then
          data.player:SetPoint("BOTTOMLEFT", data.left, "TOPLEFT", value, 0);
          data.target:SetPoint("BOTTOMRIGHT", data.right, "TOPRIGHT", -(value), 0);
        end
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
          local listener = em:GetEventListenerByID("MuiUnitPanels_TargetGradient");

          if (listener) then
            em:TriggerEventListener(listener);
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

    if (data.player and data.target) then
      data.player:Hide();
      data.target:Hide();
    end
  end

  -- disable all events:
  em:DisableEventListeners(
    "MuiRestingPulse",
    "MuiUnitFramePanels_TargetChanged",
    "MuiDetachSuf_Logout",
    "MuiUnitNames_TargetChanged",
    "MuiUnitNames_LevelUp",
    "MuiUnitNames_UpdatePlayerName",
    "MuiUnitPanels_TargetGradient");
end

-- Occurs before update functions execute
-- Can be toggled on and off though without update functions executing
function C_UnitPanels:OnEnable(data)
  if (data.left) then
    data.left:Show();
    data.right:Show();
    data.center:Show();

    if (data.player and data.target) then
      data.player:Show();
      data.target:Show();
    end

    -- enable event handlers
    if (data.settings.restingPulse) then
      em:EnableEventListeners("MuiRestingPulse");
    end

    if (data.settings.controlSUF) then
      em:EnableEventListeners("MuiDetachSuf_Logout");
    end

    if (data.settings.unitNames.enabled) then
      em:EnableEventListeners("MuiUnitNames_TargetChanged", "MuiUnitNames_LevelUp", "MuiUnitNames_UpdatePlayerName");
    end

    if (data.settings.sufGradients.enabled) then
      em:EnableEventListeners("MuiUnitPanels_TargetGradient");
    end

    em:EnableEventListeners("MuiUnitFramePanels_TargetChanged");
    return;
  end

  -- data.left.bg is created when loading Symmetrical.lua
  data.left = CreateFrame("Frame", "MUI_UnitPanelLeft", _G.MUI_BottomContainer);
  data.right = CreateFrame("Frame", "MUI_UnitPanelRight", _G.MUI_BottomContainer);

  data.center = CreateFrame("Frame", "MUI_UnitPanelCenter", data.right);
  data.center:SetPoint("TOPLEFT", data.left, "TOPRIGHT");
  data.center:SetPoint("TOPRIGHT", data.right, "TOPLEFT");
  data.center:SetPoint("BOTTOMLEFT", data.left, "BOTTOMRIGHT");
  data.center:SetPoint("BOTTOMRIGHT", data.right, "BOTTOMLEFT");

  data.center.bg = tk:SetBackground(data.center, tk:GetAssetFilePath("Textures\\BottomUI\\Center"));
  data.center.hasGradient = true; -- should be colored using SetGradientAlpha when target changes.

  data.left:SetFrameStrata("BACKGROUND");
  data.center:SetFrameStrata("BACKGROUND");
  data.right:SetFrameStrata("BACKGROUND");
end

function C_UnitPanels:OnEnabled(data)
  if (em:GetEventListenerByID("MuiUnitFramePanels_TargetChanged")) then return end

  local listener = em:CreateEventListenerWithID("MuiUnitFramePanels_TargetChanged", function()
    data:Call("UpdateAllVisuals");
  end);

  listener:RegisterEvents(
    "PLAYER_REGEN_ENABLED", "PLAYER_REGEN_DISABLED",
    "PLAYER_TARGET_CHANGED", "PLAYER_ENTERING_WORLD");

  data:Call("UpdateAllVisuals");
end

do
  local doubleTextureFilePath = tk:GetAssetFilePath("Textures\\BottomUI\\Double");
  local singleTextureFilePath = tk:GetAssetFilePath("Textures\\BottomUI\\Single");

  function C_UnitPanels:SetSymmetricalEnabled(data, enabled)
    if (not data.left.bg) then
      -- Finish setting up the unit frames here
      data.left.bg = tk:SetBackground(data.left, doubleTextureFilePath);
      data.right.bg = tk:SetBackground(data.right, doubleTextureFilePath);
      data.right.bg:SetTexCoord(1, 0, 0, 1);
      tk:ApplyThemeColor(data.settings.alpha, data.left.bg, data.right.bg);
    end

    if (not enabled) then
      -- create single texture (shown when there is no target and not symmetrical)
      data.left.singleBg = data.left.singleBg or tk:SetBackground(data.left, singleTextureFilePath);
      tk:ApplyThemeColor(data.settings.alpha, data.left.singleBg);
    end

    data:Call("UpdateAllVisuals");
  end
end

-- This is used by the Resting Pulse feature and by the "alpha" update function:
function C_UnitPanels.Private:UpdateVisuals(data, frame, restingPulseAlpha)
  local target = tk:GetUnitClassColor("target");
  local r, g, b = data.left.bg:GetVertexColor();
  local alpha = data.settings.alpha;

  if (data:Call("ShouldPulse")) then
    alpha = restingPulseAlpha or data.currentPulseAlpha;
  elseif (restingPulseAlpha) then
    return
  end

  if (frame ~= data.left and frame ~= data.player) then
    if (not (data.settings.isSymmetric or UnitExists("target"))) then
      alpha = 0;
    end
  end

  if (frame == data.center) then
    if (UnitIsPlayer("target") and data.settings.targetClassColored) then
      frame.bg:SetGradientAlpha("HORIZONTAL", r, g, b, alpha, target.r, target.g, target.b, alpha);
    else
      frame.bg:SetGradientAlpha("HORIZONTAL", r, g, b, alpha, r, g, b, alpha);
    end
  elseif (frame == data.right) then
    if (UnitIsPlayer("target") and data.settings.targetClassColored) then
      frame.bg:SetVertexColor(target.r, target.g, target.b, alpha);
    else
      frame.bg:SetVertexColor(r, g, b, alpha);
    end
  elseif (frame == data.target) then
    if (UnitIsPlayer("target") and data.settings.unitNames.targetClassColored) then
      frame.bg:SetVertexColor(target.r, target.g, target.b, alpha);
    else
      frame.bg:SetVertexColor(r, g, b, alpha);
    end
  elseif (frame == data.player) then
    frame.bg:SetVertexColor(r, g, b, alpha);
  else
    if (UnitExists("target") or data.settings.isSymmetric) then
      if (frame.singleBg) then
        frame.singleBg:SetVertexColor(r, g, b, 0);
      end
      frame.bg:SetVertexColor(r, g, b, alpha);
    else
      if (frame.singleBg) then
        frame.singleBg:SetVertexColor(r, g, b, alpha);
      end

      frame.bg:SetVertexColor(r, g, b, 0);
    end
  end
end

do
  local textures = { "left", "center", "right", "player", "target" };

  function C_UnitPanels.Private:UpdateAllVisuals(data)
    for _, key in ipairs(textures) do
      if (key == "player" and not data.settings.unitNames.enabled) then break end
      if (obj:IsWidget(data[key]) and obj:IsWidget(data[key].bg)) then
        data:Call("UpdateVisuals", data[key]);
      end
    end
  end
end

do
  local IsResting = _G.IsResting;
  local InCombatLockdown = _G.InCombatLockdown;

  function C_UnitPanels.Private:ShouldPulse(data)
    return not (data.stopPulsing or InCombatLockdown()) and IsResting() and data.settings.restingPulse;
  end
end

function C_UnitPanels.Private:DetachShadowedUnitFrames(_)
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

function C_UnitPanels.Private:AttachShadowedUnitFrames(data)
  if (not data.center) then return end

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
    data.right:SetFrameStrata("LOW");
  end

  if (_G.SUFUnittargettarget) then
    _G.SUFUnittargettarget:SetFrameStrata("MEDIUM");
  end

  _G.ShadowUF.Layout:Reload("targettarget");
end