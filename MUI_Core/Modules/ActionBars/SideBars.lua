-- luacheck: ignore self 143 631
local _G = _G
local MayronUI = _G.MayronUI
local tk, db, em, gui, _, L = MayronUI:GetCoreComponents()

local InCombatLockdown, IsAddOnLoaded = _G.InCombatLockdown, _G.IsAddOnLoaded;
local radians = _G.math.rad;

local EXPAND_BUTTON_ID = 1;
local RETRACT_BUTTON_ID = 2;

-- Register and Import Modules -----------

local C_SideActionBars = MayronUI:RegisterModule("SideActionBars", L["Side Action Bars"])

-- Add Database Defaults -----------------

db:AddToDefaults("profile.actionbars.side", {
    enabled = true; -- show/hide action bar panel
    -- Appearance properties
    texture = tk:GetAssetFilePath("Textures\\SideBar\\SideBarPanel");
    alpha = 1;
    manualSizes = {46, 80}; -- the manual widths for each of the 3 columns
    sizeMode = "dynamic";
    panelPadding = 6;

    height = 460;
    yOffset = 53;

    animation = {
      speed = 6;
      activeSets = 2;
      showWhen = "Always"; -- can be mouseover or never
      hideInCombat = false;
    };

    bartender = {
      spacing = tk:IsRetail() and 2 or 3;

      controlVisibility = true;
      controlPositioning = true;
      controlScale = true;
      controlPadding = true;

      scale = 0.85 * (tk:IsRetail() and 0.8 or 1);
      padding = tk:IsRetail() and 6.8 or 5.5;

      -- These are the bartender IDs, not the Bar Name!
      -- Use Bartender4:GetModule("ActionBars"):GetBarName(id) to find out its name.
      -- Set 1:
      [1] = { 3 };
      -- Set 2:
      [2] = { 4 };
    };
  })

-- Local Functions ---------------------

local function UpdateArrowButtonVisibility(data, activeSets, inCombat)
  activeSets = activeSets or data.settings.animation.activeSets;

  local showOnMouseOver = data.settings.animation.showWhen == "On Mouse-over";
  local hideInCombat = data.settings.animation.hideInCombat;
  local neverShow = data.settings.animation.showWhen == "Never";

  data.expand.showOnMouseOver = showOnMouseOver;
  data.retract.showOnMouseOver = showOnMouseOver;

  if (hideInCombat) then
    if (not em:GetEventListenerByID("SideBar_HideInCombat")) then
      em:CreateEventListenerWithID("SideBar_HideInCombat",
        function(_, event)
          UpdateArrowButtonVisibility(data, _, event == "PLAYER_REGEN_DISABLED");
        end)
        :RegisterEvent("PLAYER_REGEN_ENABLED")
        :RegisterEvent("PLAYER_REGEN_DISABLED");
    else
      em:EnableEventListeners("SideBar_HideInCombat");
    end
  else
    em:DisableEventListeners("SideBar_HideInCombat");
  end

  if (neverShow or (hideInCombat and inCombat)) then
    data.expand:Hide();
    data.retract:Hide();
    return
  end

  if (showOnMouseOver) then
    data.expand:Show();
    data.retract:Show();
    data.expand:SetAlpha(0);
    data.retract:SetAlpha(0);
    return
  end

  data.expand:SetAlpha(1);
  data.retract:SetAlpha(1);
  data.expand:SetShown(activeSets ~= 2);
  data.retract:SetShown(activeSets ~= 0);
end

local function UpdateArrowButtonPositions(data, activeSets)
  activeSets = activeSets or data.settings.animation.activeSets;

  data.expand:ClearAllPoints();
  data.retract:ClearAllPoints();

  if (activeSets == 0) then
    data.expand:SetPoint("RIGHT", data.panel, "LEFT");

  elseif (activeSets == 1) then
    data.expand:SetPoint("RIGHT", data.panel, "LEFT", 0, 90);
    data.retract:SetPoint("RIGHT", data.panel, "LEFT", 0, -90);

  elseif (activeSets == 2) then
    data.retract:SetPoint("RIGHT", data.panel, "LEFT");
  end
end

-- C_SideActionBars -----------------------
function C_SideActionBars:OnInitialize(data)
  local options = {
    onExecuteAll = {
      ignore = { ".*" };
    };
  }

  self:RegisterUpdateFunctions(db.profile.actionbars.side, {
    height = function(value)
      data.panel:SetHeight(value);
    end;
    alpha = function(value)
      data.panel:SetAlpha(value);
    end;
    yOffset = function(value)
      local p, rf, rp, x = data.panel:GetPoint();
      data.panel:SetPoint(p, rf, rp, x, value);
    end;
    ---@param keys LinkedList
    bartender = function(_, path)
      local key = path:GetBack();
      if (key ~= "activeSets") then
        self:SetUpExpandRetract();
      end
    end;

    manualSizes = function()
      if (data.settings.sizeMode == "manual") then
        data.controller.panelSizes = tk.Tables:Copy(data.settings.manualSizes);
        local activeSets = data.settings.animation.activeSets;

        local panelSize = activeSets > 0 and data.controller.panelSizes[activeSets] or 0;
        data.controller.slider:SetValue(panelSize);
      end
    end;

    sizeMode = function(value)
      local activeSets = data.settings.animation.activeSets;
      data.controller.sizeMode = value;

      if (value == "dynamic") then
        data.controller:LoadPositions(0);
        data.controller.slider:SetValue(activeSets > 0 and data.controller.panelSizes[activeSets] or 0);
      else
        data.controller.panelSizes = tk.Tables:Copy(data.settings.manualSizes);
        data.controller.slider:SetValue(activeSets > 0 and data.settings.manualSizes[activeSets] or 0);
      end
    end;

    panelPadding = function(value)
      if (data.settings.sizeMode == "dynamic") then
        data.controller.panelPadding = value;
        data.controller:LoadPositions(0);

        local activeSets = data.settings.animation.activeSets;
        local panelSize = activeSets > 0 and data.controller.panelSizes[activeSets] or 0;
        data.controller.slider:SetValue(panelSize);
      end
    end;

    animation = {
      showWhen = function()
        UpdateArrowButtonVisibility(data);
      end;
      hideInCombat = function()
        UpdateArrowButtonVisibility(data);
      end;
      speed = function(value)
        data.controller:SetAnimationSpeed(value);
      end
    };
  }, options);

  if (data.settings.enabled) then
    self:SetEnabled(true);
  end
end

function C_SideActionBars:OnEnable(data)
  if (not data.panel) then
    data.panel = tk:CreateFrame("Frame", nil, "MUI_SideBar");
    data.panel:SetPoint("RIGHT", 0, data.settings.yOffset);
    data.panel:SetAlpha(data.settings.alpha);
    data.panel:SetHeight(data.settings.height);
    gui:CreateGridTexture(data.panel, data.settings.texture, 20, nil, 45, 749);
  end

  data.panel:Show();

  if (tk:IsRetail()) then
    if (em:GetEventListenerByID("SideBarPetBattleStart")) then
      em:EnableEventListeners("SideBarPetBattleStart");
      em:EnableEventListeners("SideBarPetBattleStop");
      return
    end

    em:CreateEventListenerWithID("SideBarPetBattleStart", function() data.panel:Hide() end)
      :RegisterEvent("PET_BATTLE_OPENING_START");

    em:CreateEventListenerWithID("SideBarPetBattleStop", function() data.panel:Show() end)
      :RegisterEvent("PET_BATTLE_CLOSE");
  end

  self:SetUpExpandRetract();
end

function C_SideActionBars:OnDisable(data)
  if (not data.panel) then
    return
  end

  data.panel:Hide();

  if (data.expand and data.retract) then
    data.expand:Hide();
    data.retract:Hide();
  end

  if (tk:IsRetail()) then
    em:DisableEventListeners("SideBarPetBattleStart");
    em:DisableEventListeners("SideBarPetBattleStop");
  end
end

local function OnArrowButtonEnter(self)
  local r, g, b = self.icon:GetVertexColor();
  self.icon:SetVertexColor(r * 1.2, g * 1.2, b * 1.2);

  if (self.showOnMouseOver) then
    self:SetAlpha(1);
  end
end

local function OnArrowButtonLeave(self)
  tk:ApplyThemeColor(self.icon);
  if (self.showOnMouseOver) then
    self:SetAlpha(0);
  end
end

local function OnArrowButtonClick(btnId, currentActiveSets)
  if (btnId == EXPAND_BUTTON_ID) then
    if (currentActiveSets == 0) then
      MayronUI:TriggerCommand("Show1SideActionBar");
    elseif (currentActiveSets == 1) then
      MayronUI:TriggerCommand("Show2SideActionBars");
    end

  elseif (btnId == RETRACT_BUTTON_ID ) then
    if (currentActiveSets == 1) then
      MayronUI:TriggerCommand("HideAllSideActionBars");
    elseif (currentActiveSets == 2) then
      MayronUI:TriggerCommand("Show1SideActionBar");
    end
  end
end

function C_SideActionBars:SetUpExpandRetract(data)
  if (not IsAddOnLoaded("Bartender4")) then
    return
  end

  if (data.controller) then
    data.controller:ApplyOverrides();
    data.controller:LoadPositions(0);
    return;
  end

  local sideButtonTexture = tk:GetAssetFilePath("Textures\\SideBar\\SideButton");

  for btnId = 1, 2 do
    local btn = tk:CreateFrame("Button");
    btn:SetID(btnId);
    btn:SetNormalTexture(sideButtonTexture);
    btn:SetSize(15, 100);
    btn:SetScript("OnEnter", OnArrowButtonEnter);
    btn:SetScript("OnLeave", OnArrowButtonLeave);
    btn:SetScript("OnClick", function()
      OnArrowButtonClick(btnId, data.settings.animation.activeSets);
    end);

    btn.icon = btn:CreateTexture(nil, "OVERLAY");
    btn.icon:SetSize(12, 8);
    btn.icon:SetPoint("CENTER");
    btn.icon:SetTexture(tk:GetAssetFilePath("Icons\\arrow"));
    tk:ApplyThemeColor(btn.icon);

    if (btnId == EXPAND_BUTTON_ID) then
      btn.icon:SetRotation(radians(90));
    else
      btn.icon:SetRotation(radians(-90));
    end

    local btnKey = btnId == EXPAND_BUTTON_ID and "expand" or "retract";
    data[btnKey] = btn;
  end

  UpdateArrowButtonPositions(data);
  UpdateArrowButtonVisibility(data);

  local mixin = MayronUI:GetComponent("ActionBarController");

  ---@type ActionBarControllerMixin
  data.controller = _G.CreateAndInitFromMixin(mixin, data.panel, data.settings, 0, "HORIZONTAL", 40, 2, 0);

  local function PlayTransition(nextActiveSetId)
    data.controller:PlayTransition(nextActiveSetId);
    UpdateArrowButtonPositions(data, nextActiveSetId);
    UpdateArrowButtonVisibility(data, nextActiveSetId);
    db.profile.actionbars.side.animation.activeSets = nextActiveSetId;
  end

  -- Setup action bar toggling commands:
  _G.BINDING_NAME_MUI_HIDE_ALL_SIDE_ACTION_BARS = "Hide All Side Action Bars";
  MayronUI:RegisterCommand("HideAllSideActionBars", PlayTransition, 0);

  _G.BINDING_NAME_MUI_SHOW_1_SIDE_ACTION_BAR = "Show 1 Side Action Bar";
  MayronUI:RegisterCommand("Show1SideActionBar", PlayTransition, 1);

  _G.BINDING_NAME_MUI_SHOW_2_SIDE_ACTION_BARS = "Show 2 Side Action Bars";
  MayronUI:RegisterCommand("Show2SideActionBars", PlayTransition, 2);
end

function C_SideActionBars:GetPanel(data)
  return data.panel
end