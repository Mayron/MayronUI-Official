-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local CreateFrame, InCombatLockdown = _G.CreateFrame, _G.InCombatLockdown;
local UIFrameFadeIn = _G.UIFrameFadeIn;
local IsAddOnLoaded, LoadAddOn, ipairs = _G.IsAddOnLoaded, _G.LoadAddOn, _G.ipairs;
local GetAddOnMetadata = _G.GetAddOnMetadata;

local TOGGLE_BUTTON_WIDTH = 120;
local TOGGLE_BUTTON_HEIGHT = 28;
local EXPAND_BUTTON_ID = 1;
local RETRACT_BUTTON_ID = 2;

-- Register and Import Modules -----------
local C_ActionBarPanel = MayronUI:RegisterModule("ActionBarPanel", L["Action Bar Panel"], true);

-- Load Database Defaults ----------------
db:AddToDefaults("profile.actionBarPanel", {
  enabled = true; -- show/hide action bar panel
  -- Appearance properties
  texture = tk:GetAssetFilePath("Textures\\BottomUI\\ActionBarPanel");
  alpha = 1;
  cornerSize = 20;
  modKey = "C"; -- modifier key to toggle expand and retract button
  fixedHeight = 80; -- the height used when bartender.control is disabled

  bartender = {
    animationSpeed = 6;
    panelPadding = 6;
    spacing = 3;
    control = true;
    controlPositioning = true;
    controlScale = true;
    scale = tk:IsRetail() and 0.69 or 0.85;
    controlPadding = true;
    padding = tk:IsRetail() and 6 or 5.5;
    activeSets = 1;

    -- These are the bartender IDs, not the Bar Name!
    -- Use Bartender4:GetModule("ActionBars"):GetBarName(id) to find out its name.
    -- Set 1:
    [1] = tk:IsRetail() and { 1, 13 } or { 1, 7 };
    -- Set 2:
    [2] = tk:IsRetail() and { 6, 14 } or { 9, 10 };
    -- Set 3
    [3] = tk:IsRetail() and { 5, 15 } or { 5, 6 };
  };
});

-- local functions ------------------

local modKeyLabels = {
  ["C"] = "CTRL",
  ["S"] = "SHIFT",
  ["A"] = "ALT",
};

local function LoadTutorial(panel)
  local frame = tk:PopFrame("Frame", panel);

  frame:SetFrameStrata("TOOLTIP");
  frame:SetSize(300, 150);
  frame:SetPoint("BOTTOM", panel, "TOP", 0, 120);

  gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, nil, frame);
  gui:AddCloseButton(tk.Constants.AddOnStyle, frame);
  gui:AddTitleBar(tk.Constants.AddOnStyle, frame, L["Tutorial: Step 1"]);
  gui:AddArrow(tk.Constants.AddOnStyle, frame, "DOWN");

  frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  frame.text:SetWordWrap(true);
  frame.text:SetPoint("TOPLEFT", 20, -20);
  frame.text:SetPoint("BOTTOMRIGHT", -20, 10);
  tk:SetFontSize(frame.text, 13);

  local modKey = db.profile.actionBarPanel.modKey;
  tk:Assert(not tk.Strings:IsNilOrWhiteSpace(modKey), "Failed to load tutorial - missing modifier key");

  local modKeyLabel;
  for i = 1, #modKey do
    local c = modKey:sub(i,i);

    if (i == 1) then
      modKeyLabel = modKeyLabels[c];
    else
      modKeyLabel = string.format("%s+%s", modKeyLabel, modKeyLabels[c]);
    end
  end

  local tutorialMessage = L["PRESS_HOLD_TOGGLE_BUTTONS"];
  tutorialMessage = tutorialMessage:format(tk.Strings:SetTextColorByKey(modKeyLabel, "GOLD"));
  frame.text:SetText(tutorialMessage);

  local listener = em:CreateEventListener(function(self)
    if (not tk:IsModComboActive(modKey)) then return end
    frame.titleBar.text:SetText(L["Tutorial: Step 2"]);

    local step2Text = L["CHANGE_KEYBINDINGS"];
    step2Text = string.format(step2Text, tk.Strings:SetTextColorByKey("/mui config", "GOLD"));
    frame.text:SetText(step2Text);
    frame:SetHeight(200);
    frame.text:SetPoint("BOTTOMRIGHT", -20, 50);

    local btn = gui:CreateButton(tk.Constants.AddOnStyle, frame, L["Show MUI Key Bindings"]);
    btn:SetPoint("BOTTOM", 0, 20);
    btn:SetScript("OnClick", function()
      MayronUI:ShowKeyBindings();
      frame.closeBtn:Click();
    end);

    btn:SetWidth(200);

    if (not frame:IsShown()) then
      UIFrameFadeIn(frame, 0.5, 0, 1);
      frame:Show();
    end

    db.profile.actionBarPanel.tutorial = GetAddOnMetadata("MUI_Core", "Version");
    self:Destroy();
  end);

  listener:RegisterEvent("MODIFIER_STATE_CHANGED");
end

local function OnArrowButtonClick(btnId, currentActiveSets)
  if (btnId == EXPAND_BUTTON_ID) then
    if (currentActiveSets == 1) then
      MayronUI:TriggerCommand("Show2BottomActionBars");
    elseif (currentActiveSets == 2) then
      MayronUI:TriggerCommand("Show3BottomActionBars");
    end

  elseif (btnId == RETRACT_BUTTON_ID) then
    if (currentActiveSets == 2) then
      MayronUI:TriggerCommand("Show1BottomActionBar");
    elseif (currentActiveSets == 3) then
      MayronUI:TriggerCommand("Show2BottomActionBars");
    end
  end
end

local function OnArrowButtonEnter(self)
  local r, g, b = self.icon:GetVertexColor();
  self.icon:SetVertexColor(r * 1.2, g * 1.2, b * 1.2);
end

local function OnArrowButtonLeave(self)
  tk:ApplyThemeColor(self.icon);
end

local function PositionToggleButtons(data)
  data.expand:Hide();
  data.retract:Hide();

  if (data.settings.bartender.activeSets == 1) then
    data.expand:SetPoint("BOTTOM", data.buttons, "TOP");
    data.expand:SetSize(TOGGLE_BUTTON_WIDTH, TOGGLE_BUTTON_HEIGHT);
    data.expand:Show();

  elseif (data.settings.bartender.activeSets == 2) then
    local smallWidth = TOGGLE_BUTTON_WIDTH / 2;
    local gap = 1;
    local offset = (smallWidth / 2) + gap;

    data.retract:SetPoint("BOTTOM", data.buttons, "TOP", -offset, 0);
    data.retract:SetSize(smallWidth, TOGGLE_BUTTON_HEIGHT);
    data.retract:Show();
    data.expand:SetPoint("BOTTOM", data.buttons, "TOP", offset, 0);
    data.expand:SetSize(smallWidth, TOGGLE_BUTTON_HEIGHT);
    data.expand:Show();

  elseif (data.settings.bartender.activeSets == 3) then
    data.retract:SetPoint("BOTTOM", data.buttons, "TOP");
    data.retract:SetSize(TOGGLE_BUTTON_WIDTH, TOGGLE_BUTTON_HEIGHT);
    data.retract:Show();
  end
end

-- MayronUI functions ------------------

function MayronUI:ShowKeyBindings()
  LoadAddOn("Blizzard_BindingUI");
  local keybindingsFrame = _G.KeyBindingFrame;

  if (IsAddOnLoaded("Blizzard_BindingUI") and obj:IsWidget(keybindingsFrame)) then
    keybindingsFrame:Show();

    for _, btn in ipairs(keybindingsFrame.categoryList.buttons) do
      if (btn.element and btn.element.name == "MayronUI") then
        btn:Click();
      end
    end
  elseif (IsAddOnLoaded("Blizzard_Settings")) then
    _G.Settings.OpenToCategory(); -- can't use 12 (the Keybindings category) due to taint
  end
end

-- C_ActionBarPanel -----------------
function C_ActionBarPanel:OnInitialize(data, containerModule)
  data.containerModule = containerModule;
  data.rows = obj:PopTable();

  if (obj:IsString(db.profile.actionBarPanel.bartender[1])) then
    db.profile.actionBarPanel.bartender = nil;
  end

  local options = {
    onExecuteAll = {
      ignore = {
        "fixedHeight",
        "bartender"
      };
    };
  };

  self:RegisterUpdateFunctions(db.profile.actionBarPanel, {
    texture = function(value)
      data.panel:SetGridTexture(value);
    end;

    alpha = function(value)
      data.panel:SetAlpha(value);
    end;

    cornerSize = function(value)
      data.panel:SetGridCornerSize(value);
    end;

    -- Ignored OnLoad functions -----------
    fixedHeight = function(value)
      if (not data.settings.bartender.control) then
        data.panel:SetHeight(value);
      end
    end;

    bartender = function()
      self:SetUpExpandRetract();
    end;
  }, options);

  if (data.settings.enabled) then
    self:SetEnabled(true);
  end
end

function C_ActionBarPanel:OnDisable(data)
  if (data.panel) then
    data.panel:Hide();
    data.containerModule:RepositionContent();
    return;
  end
end

function C_ActionBarPanel:OnEnable(data)
  if (_G.Bartender4DB and tk:IsRetail() and not db.global.bartender4Update == 1) then
    local stanceBarConfig = tk.Tables:GetTable(_G.Bartender4DB, "namespaces", "StanceBar", "profiles", "MayronUI");

    stanceBarConfig.padding = 4;
    stanceBarConfig.position = stanceBarConfig.position or obj:PopTable();
    stanceBarConfig.position.scale = 1;

    local petBarConfig = tk.Tables:GetTable(_G.Bartender4DB, "namespaces", "PetBar", "profiles", "MayronUI");
    petBarConfig.padding = 4;
    petBarConfig.position = petBarConfig.position or obj:PopTable();
    petBarConfig.position.y = 73;
    petBarConfig.position.x = 378;
    petBarConfig.position.scale = 1;

    local bagBarConfig = tk.Tables:GetTable(_G.Bartender4DB, "namespaces", "BagBar", "profiles", "MayronUI");
    bagBarConfig.enabled = false;
    bagBarConfig.onebagreagents = false;
    bagBarConfig.padding = 0;
    bagBarConfig.position = bagBarConfig.position or obj:PopTable();
    bagBarConfig.position.y = 84;
    bagBarConfig.position.x = -52;

    local actionBarsConfig = tk.Tables:GetTable(_G.Bartender4DB, "namespaces", "ActionBars", "profiles", "MayronUI", "actionbars");
    tk.Tables:GetTable(actionBarsConfig, 3, "position").y = 265;
    tk.Tables:GetTable(actionBarsConfig, 4, "position").y = 265;

    db.global.bartender4Update = 1;
  end

  if (data.panel) then
    data.panel:Show();
    data.containerModule:RepositionContent();
    return;
  end

  data.panel = CreateFrame("Frame", "MUI_ActionBarPanel", _G.MUI_BottomContainer);
  data.panel:SetFrameLevel(10);
  data.panel:SetHeight(data.settings.fixedHeight);
  gui:CreateGridTexture(data.panel, data.settings.texture, data.settings.cornerSize, nil, 749, 45);

  if (data.settings.bartender.control and not data.settings.tutorial) then
    local show = tk:GetTutorialShowState(data.settings.tutorial);

    if (show) then
      LoadTutorial(data.panel);
    end
  end
end

function C_ActionBarPanel:SetUpExpandRetract(data)
  if (not (IsAddOnLoaded("Bartender4") and data.settings.bartender.control)) then
    if (data.expandRetractFeatureLoaded) then
      em:DisableEventListeners("BottomSets_ExpandRetract");
      data.panel:SetHeight(data.settings.fixedHeight);
    end

    return
  end

  local bottom = data.panel:GetBottom();
  if (not obj:IsNumber(bottom)) then
    return
  end

  if (data.expandRetractFeatureLoaded) then
    em:EnableEventListeners("BottomSets_ExpandRetract");
    return;
  end

  em:CreateEventListener(function()
    db.profile.actionBarPanel.bartender.activeSets = data.settings.bartender.activeSets;
  end):RegisterEvent("PLAYER_LOGOUT");

  -- Create up and down buttons used to expand/retract rows:
  data.buttons = CreateFrame("Frame", nil, data.panel);
  data.buttons:SetFrameStrata("HIGH");
  data.buttons:SetFrameLevel(20);
  data.buttons:SetPoint("BOTTOM", data.panel, "TOP", 0, -2);
  data.buttons:SetSize(1, 1);
  data.buttons:Hide();

  for btnId = 1, 2 do
    local btn = gui:CreateButton(tk.Constants.AddOnStyle, data.buttons);
    btn:Hide();
    btn:SetID(btnId);
    btn:SetScript("OnEnter", OnArrowButtonEnter);
    btn:SetScript("OnLeave", OnArrowButtonLeave);
    btn:SetScript("OnClick", function()
      OnArrowButtonClick(btnId, data.settings.bartender.activeSets);
      data.buttons:Hide();
    end);

    btn:SetFrameStrata("HIGH");
    btn:SetFrameLevel(30);
    btn:SetBackdrop(tk.Constants.BACKDROP);
    btn:SetBackdropBorderColor(0, 0, 0);

    btn.icon = btn:CreateTexture(nil, "OVERLAY");
    btn.icon:SetSize(16, 10);
    btn.icon:SetPoint("CENTER");
    btn.icon:SetTexture(tk:GetAssetFilePath("Textures\\BottomUI\\Arrow"));
    tk:ApplyThemeColor(btn.icon);

    local normalTexture = btn:GetNormalTexture();
    normalTexture:SetVertexColor(0.15, 0.15, 0.15, 1);

    if (btnId == RETRACT_BUTTON_ID) then
      btn.icon:SetTexCoord(0, 1, 1, 0);
    end

    local btnKey = btnId == EXPAND_BUTTON_ID and "expand" or "retract";
    data[btnKey] = btn;
  end

  -- Create glow effect that fades in when holding the modifier key/s:
  local glow = data.buttons:CreateTexture("MUI_ActionBarPanelGlow", "BACKGROUND");
  glow:SetTexture(tk:GetAssetFilePath("Textures\\BottomUI\\GlowEffect"));
  glow:SetSize(db.profile.bottomui.width, 80);
  glow:SetBlendMode("ADD");
  glow:SetPoint("BOTTOM", 0, 2);
  tk:ApplyThemeColor(glow);

  -- Create the glow effect's scaling effect:
  local glowScaler = glow:CreateAnimationGroup();
  glowScaler.anim = glowScaler:CreateAnimation("Scale");
  glowScaler.anim:SetOrigin("BOTTOM", 0, 0);
  glowScaler.anim:SetDuration(0.4);

  if (obj:IsFunction(glowScaler.anim.SetFromScale)) then
    glowScaler.anim:SetFromScale(0, 0);
    glowScaler.anim:SetToScale(1, 1);
  else
    -- changed function name in dragonflight
    glowScaler.anim:SetScaleFrom(0, 0);
    glowScaler.anim:SetScaleTo(1, 1);
  end

  -- Create the glow effect's fade in effect:
  local fader = data.buttons:CreateAnimationGroup();
  fader.anim = fader:CreateAnimation("Alpha");
  fader.anim:SetSmoothing("OUT");
  fader.anim:SetDuration(0.2);
  fader.anim:SetFromAlpha(0);
  fader.anim:SetToAlpha(1);

  fader:SetScript("OnFinished", function()
    data.buttons:SetAlpha(1);
  end);

  fader:SetScript("OnPlay", function()
    data.buttons:Show();
    PositionToggleButtons(data);
    data.buttons:SetAlpha(0);
  end);

  -- Needed for private script handler callbacks:
  data.glowScaler = glowScaler;
  data.glow = glow;
  data.fader = fader;

  local mixin = MayronUI:GetComponent("BartenderController");

  ---@type BartenderControllerMixin
  data.controller = _G.CreateAndInitFromMixin(mixin,
    data.panel, data.settings.bartender, bottom, "VERTICAL", nil, 2, 0);

  local function PlayTransition(nextActiveSetId)
    data.controller:PlayTransition(nextActiveSetId);
  end

  -- Setup action bar toggling commands:
  _G.BINDING_NAME_MUI_SHOW_1_BOTTOM_ACTION_BAR = "Show 1 Bottom Action Bar";
  MayronUI:RegisterCommand("Show1BottomActionBar", PlayTransition, 1);

  _G.BINDING_NAME_MUI_SHOW_2_BOTTOM_ACTION_BARS = "Show 2 Bottom Action Bars";
  MayronUI:RegisterCommand("Show2BottomActionBars", PlayTransition, 2);

  _G.BINDING_NAME_MUI_SHOW_3_BOTTOM_ACTION_BARS = "Show 3 Bottom Action Bars";
  MayronUI:RegisterCommand("Show3BottomActionBars", PlayTransition, 3);

  em:CreateEventListenerWithID("BottomSets_ExpandRetract", function()
    if (not tk:IsModComboActive(data.settings.modKey) or InCombatLockdown()) then
      data.buttons:Hide();
      return;
    end

    data.fader:Stop(); -- force execution of OnFinished callback
    data.glowScaler:Play();
    data.fader:Play();
  end):RegisterEvent("MODIFIER_STATE_CHANGED");

  em:CreateEventListener(function()
    data.expand:Hide();
    data.retract:Hide();
  end):RegisterEvent("PLAYER_REGEN_DISABLED");

  data.expandRetractFeatureLoaded = true;
end

function C_ActionBarPanel:GetPanel(data)
  return data.panel;
end

function C_ActionBarPanel:ReloadBartenderPositions(data, startPoint)
  local controller = data.controller; ---@type BartenderControllerMixin

  if (controller and obj:IsNumber(startPoint)) then
    controller:LoadPositions(startPoint);
  end
end