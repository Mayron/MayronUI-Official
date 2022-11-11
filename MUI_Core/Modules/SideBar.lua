-- luacheck: ignore self 143 631
local _G = _G
local MayronUI = _G.MayronUI
local tk, db, em, gui, _, L = MayronUI:GetCoreComponents()

local InCombatLockdown, IsAddOnLoaded, CreateFrame, UIParent =
   _G.InCombatLockdown,_G.IsAddOnLoaded, _G.CreateFrame, _G.UIParent;
local radians = _G.math.rad;

local EXPAND_BUTTON_ID = 1;
local RETRACT_BUTTON_ID = 2;

-- Register and Import Modules -----------

local C_SideBarModule = MayronUI:RegisterModule("SideBarModule", L["Side Action Bar"])

-- Add Database Defaults -----------------

db:AddToDefaults("profile.sidebar", {
    enabled = true;
    height = 460;
    fixedWidth = 46;
    xOffset = 0;
    yOffset = 53;
    alpha = 1;

    buttons = {
      showWhen = "Always"; -- can be mouseover or never
      hideInCombat = false;
      width = 15;
      height = 100;
    };

    bartender = {
      animationSpeed = 6;
      panelPadding = 6;

      spacing = tk:IsRetail() and 2 or 3;
      control = true;
      controlPositioning = true;

      controlScale = true;
      scale = 0.85 * (tk:IsRetail() and 0.8 or 1);

      controlPadding = true;
      padding = tk:IsRetail() and 6.8 or 5.5;

      activeSets = 2;

      -- These are the bartender IDs, not the Bar Name!
      -- Use Bartender4:GetModule("ActionBars"):GetBarName(id) to find out its name.
      -- Set 1:
      [1] = { 3 };
      -- Set 2:
      [2] = { 4 };
    };
  })

-- Local Functions ---------------------

local function UpdateArrowButtonVisibility(data, activeSets)
  activeSets = activeSets or data.settings.bartender.activeSets;

  local showOnMouseOver = data.settings.buttons.showWhen == "On Mouse-over";
  data.expand.showOnMouseOver = showOnMouseOver;
  data.retract.showOnMouseOver = showOnMouseOver;

  if (data.settings.buttons.hideInCombat) then
    if (not em:GetEventListenerByID("SideBar_HideInCombat")) then
      em:CreateEventListenerWithID("SideBar_HideInCombat", UpdateArrowButtonVisibility)
        :SetCallbackArgs(data)
        :RegisterEvent("PLAYER_REGEN_ENABLED")
        :RegisterEvent("PLAYER_REGEN_DISABLED");
    else
      em:EnableEventListeners("SideBar_HideInCombat");
    end
  else
    em:DisableEventListeners("SideBar_HideInCombat");
  end

  if (data.settings.buttons.showWhen == "Never" or
    data.settings.buttons.hideInCombat and InCombatLockdown()) then

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
  activeSets = activeSets or data.settings.bartender.activeSets;

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

-- C_SideBarModule -----------------------
function C_SideBarModule:OnInitialize(data)
  local options = {
    onExecuteAll = {
      ignore = { "xOffset"; "yOffset", "buttons.*" };
    };
  }

  self:RegisterUpdateFunctions(
    db.profile.sidebar, {
      enabled = function(value)
        self:SetEnabled(value);
      end;
      height = function(value)
        data.panel:SetHeight(value);
      end;
      fixedHeight = function(value)
        if (not data.settings.bartender.control) then
          data.panel:SetWidth(value);
        end
      end;
      alpha = function(value)
        data.panel:SetAlpha(value);
      end;
      xOffset = function(value)
        local p, rf, rp, _, y = data.panel:GetPoint();
        data.panel:SetPoint(p, rf, rp, value, y);
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
      buttons = {
        showWhen = function()
          UpdateArrowButtonVisibility(data);
        end;
        hideInCombat = function()
          UpdateArrowButtonVisibility(data);
        end;
        width = function(value)
          data.expand:SetSize(value, data.settings.buttons.height)
          data.retract:SetSize(value, data.settings.buttons.height)
        end;
        height = function(value)
          data.expand:SetSize(data.settings.buttons.width, value)
          data.retract:SetSize(data.settings.buttons.width, value)
        end;
      };
    }, options);
end

function C_SideBarModule:OnInitialized(data)
  if (data.settings.enabled) then
    self:SetEnabled(true)
  end
end

function C_SideBarModule:OnEnable(data)
  if (not data.panel) then
    local sideBarTexturePath = tk:GetAssetFilePath("Textures\\SideBar\\SideBarPanel");
    data.panel = CreateFrame("Frame", "MUI_SideBar", UIParent);
    data.panel:SetPoint("RIGHT", data.settings.xOffset, data.settings.yOffset);
    gui:CreateGridTexture(data.panel, sideBarTexturePath, 20, nil, 45, 749);
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
end

function C_SideBarModule:OnDisable(data)
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

function C_SideBarModule:SetUpExpandRetract(data)
  if (not (IsAddOnLoaded("Bartender4") and data.settings.bartender.control)) then
    return
  end

  local sideButtonTexture = tk:GetAssetFilePath("Textures\\SideBar\\SideButton");

  for btnId = 1, 2 do
    local btn = CreateFrame("Button", nil, UIParent);
    btn:SetID(btnId);
    btn:SetNormalTexture(sideButtonTexture);
    btn:SetSize(data.settings.buttons.width, data.settings.buttons.height);
    btn:SetScript("OnEnter", OnArrowButtonEnter);
    btn:SetScript("OnLeave", OnArrowButtonLeave);
    btn:SetScript("OnClick", function()
      OnArrowButtonClick(btnId, data.settings.bartender.activeSets);
    end);

    btn.icon = btn:CreateTexture(nil, "OVERLAY");
    btn.icon:SetSize(12, 8);
    btn.icon:SetPoint("CENTER");
    btn.icon:SetTexture(tk:GetAssetFilePath("Textures\\BottomUI\\Arrow"));
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

  local mixin = MayronUI:GetComponent("BartenderController");

  ---@type BartenderControllerMixin
  local controller = _G.CreateAndInitFromMixin(mixin, data.panel, data.settings.bartender, 0, "HORIZONTAL", 40, 2, 0);

  local function PlayTransition(nextActiveSetId)
    controller:PlayTransition(nextActiveSetId);
    UpdateArrowButtonPositions(data, nextActiveSetId);
    UpdateArrowButtonVisibility(data, nextActiveSetId);
    db.profile.sidebar.bartender.activeSets = nextActiveSetId;
  end

  -- Setup action bar toggling commands:
  _G.BINDING_NAME_MUI_HIDE_ALL_SIDE_ACTION_BARS = "Hide All Side Action Bars";
  MayronUI:RegisterCommand("HideAllSideActionBars", PlayTransition, 0);

  _G.BINDING_NAME_MUI_SHOW_1_SIDE_ACTION_BAR = "Show 1 Side Action Bar";
  MayronUI:RegisterCommand("Show1SideActionBar", PlayTransition, 1);

  _G.BINDING_NAME_MUI_SHOW_2_SIDE_ACTION_BARS = "Show 2 Side Action Bars";
  MayronUI:RegisterCommand("Show2SideActionBars", PlayTransition, 2);
end

function C_SideBarModule:GetPanel(data)
  return data.panel
end