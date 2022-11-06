-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local CreateFrame, InCombatLockdown, PlaySound = _G.CreateFrame, _G.InCombatLockdown, _G.PlaySound;
local UIFrameFadeIn, UIFrameFadeOut = _G.UIFrameFadeIn, _G.UIFrameFadeOut;
local IsAddOnLoaded, LoadAddOn, string, ipairs = _G.IsAddOnLoaded, _G.LoadAddOn, _G.string, _G.ipairs;
local C_Timer = _G.C_Timer;
local GetAddOnMetadata = _G.GetAddOnMetadata;

local FADING_STACKING_DELAY = 0.2;
local TOGGLE_BUTTON_WIDTH = 120;
local TOGGLE_BUTTON_HEIGHT = 28;
local BARTENDER4_BAR_BUTTON_BORDER_SIZE = 0.65;
local ACTION_BAR_PANEL_OVERLAP = 1; -- how much the ActionBarPanel texture overlaps into the element below it
local ACTION_BAR_PANEL_PADDING = 2;

-- Register and Import Modules -----------
local C_ActionBarPanel = MayronUI:RegisterModule("ActionBarPanel", L["Action Bar Panel"], true);
local SlideController = obj:Import("MayronUI.SlideController");

-- Load Database Defaults ----------------
db:AddToDefaults("profile.actionBarPanel", {
  enabled         = true; -- show/hide action bar panel

  -- Appearance properties
  texture         = tk:GetAssetFilePath("Textures\\BottomUI\\ActionBarPanel");
  alpha           = 1;
  cornerSize      = 20;
  rowSpacing      = 4;
  modKey = "C"; -- modifier key to toggle expand and retract button
  animateSpeed = 6; -- expand and retract speed to show or hide an action bar row
  fixedHeight = 80; -- the height used when bartender.control is disabled
  activeRows = 1; -- only show 1 row
  bartender = {
    control = true;

    -- These are the bartender IDs, not the Bar Name!
    -- Use Bartender4:GetModule("ActionBars"):GetBarName(id) to find out its name.
    -- Row 1
    [1] = tk:IsRetail() and { 1, 13 } or { 1, 7 };
    -- Row 2
    [2] = tk:IsRetail() and { 6, 14 } or { 9, 10 };
    -- Row 3:
    [3] = tk:IsRetail() and { 5, 15 } or { 5, 6 };
  };
});

-- local functions ------------------

local function GetRowHeight(barIds)
  local maxHeight = 0;

  for _, barId in ipairs(barIds) do
    if (barId > 0) then
      _G.Bartender4:GetModule("ActionBars"):EnableBar(barId);
      local bartenderBar = _G[string.format("BT4Bar%d", barId)];

      local barScale = bartenderBar:GetScale();
      local buttonHeight = bartenderBar.buttons[1]:GetHeight();
      local barHeight = (buttonHeight * barScale);

      if (barHeight > maxHeight) then
        maxHeight = barHeight;
      end
    end
  end

  return maxHeight;
end

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

local function ToggleBartenderBarRow(data, rowId, show, delay)
  if (not (IsAddOnLoaded("Bartender4") and data.settings.bartender.control)) then
    return false;
  end

  local bars = data.settings.bartender[rowId];
  local fadingIn = false;

  for _, bartenderBarId in ipairs(bars) do
    if (obj:IsNumber(bartenderBarId)) then
      local bartenderBarName = string.format("BT4Bar%d", bartenderBarId);
      local bartenderBar = _G[bartenderBarName];

      if (obj:IsTable(bartenderBar)) then
        local newAlwaysHideValue = not show;
        local currentAlwaysHideValue = bartenderBar:GetVisibilityOption("always");

        if (newAlwaysHideValue ~= currentAlwaysHideValue) then
          -- We need to fade this bartender bar in because the values are different:
          fadingIn = true;

          bartenderBar:SetConfigAlpha((show and 1) or 0);
          -- Set Always hide (e.g, if show is true, then disable Always Hide)
          bartenderBar:SetVisibilityOption("always", newAlwaysHideValue);

          if (show) then
            bartenderBar:SetAlpha(0);
            bartenderBar.fadeIn = bartenderBar.fadeIn or function()
              UIFrameFadeIn(bartenderBar, 0.1, 0, 1)
            end;

            C_Timer.After(0.1 + (delay or 0), bartenderBar.fadeIn);
          end
        end
      end
    end
  end

  return fadingIn;
end

-- Controls the Expand and Retract animation:
local function SetUpSlideController(data)
  ---@type SlideController
  data.slideController = SlideController(data.panel, nil, false);
  data.slideController:SetStepValue(data.settings.animateSpeed);

  data.slideController:OnStartExpand(function()
    local delay = 0;

    for rowId = 1, data.settings.activeRows do
      local fadingIn = ToggleBartenderBarRow(data, rowId, true, FADING_STACKING_DELAY * delay);

      if (fadingIn) then
        delay = delay + 1;
      end
    end
  end, 5);

  data.slideController:OnStartRetract(function()
    if (not data.settings.bartender.control) then return end
    local delay = 0;

    for rowId = data.previousActiveRows, data.settings.activeRows + 1, -1 do
      local bars = data.settings.bartender[rowId];
      local fadingOut = false;

      for _, bartenderBarId in ipairs(bars) do
        if (obj:IsNumber(bartenderBarId)) then
          local btnBar = _G[string.format("BT4Bar%d", bartenderBarId)];

          if (obj:IsTable(btnBar)) then
            btnBar.fadeOut = btnBar.fadeOut or function() UIFrameFadeOut(btnBar, 0.1, 1, 0) end;
            C_Timer.After(0 + (FADING_STACKING_DELAY * delay), btnBar.fadeOut);
            fadingOut = true;
          end
        end
      end

      if (fadingOut) then
        delay = delay + 1;
      end
    end
  end);

  data.slideController:OnEndRetract(function()
    for rowId = data.settings.activeRows + 1, 3 do
      ToggleBartenderBarRow(data, rowId, false);
    end
  end);
end

local function HandleArrowButtonClick(data, btn)
  if (data.up == btn and data.settings.activeRows < 3) then
    MayronUI:TriggerCommand(string.format("Show%dActionBarRows", data.settings.activeRows + 1));
  elseif (data.down == btn and data.settings.activeRows > 1) then
    MayronUI:TriggerCommand(string.format("Show%dActionBarRows", data.settings.activeRows - 1));
  end
end

local function CreateArrowButton(data)
  local btn = gui:CreateButton(tk.Constants.AddOnStyle, data.buttons);
  btn:Hide();
  btn:SetFrameStrata("HIGH");
  btn:SetFrameLevel(30);
  btn:SetBackdrop(tk.Constants.BACKDROP);
  btn:SetBackdropBorderColor(0, 0, 0);
  btn:SetScript("OnClick", function(b)
    HandleArrowButtonClick(data, b);
  end);

  btn.icon = btn:CreateTexture(nil, "OVERLAY");
  btn.icon:SetSize(16, 10);
  btn.icon:SetPoint("CENTER");
  btn.icon:SetTexture(tk:GetAssetFilePath("Textures\\BottomUI\\Arrow"));
  tk:ApplyThemeColor(btn.icon);

  local normalTexture = btn:GetNormalTexture();
  normalTexture:SetVertexColor(0.15, 0.15, 0.15, 1);

  btn:HookScript("OnEnter", function(self)
    local r, g, b = self.icon:GetVertexColor();
    self.icon:SetVertexColor(r * 1.2, g * 1.2, b * 1.2);
  end);

  btn:HookScript("OnLeave", function(self)
    tk:ApplyThemeColor(self.icon);
  end);

  return btn;
end

local function HandleModifierStateChanged(data)
  if (not tk:IsModComboActive(data.settings.modKey) or InCombatLockdown()) then
    data.buttons:Hide();
    return;
  end

  -- force execution of OnFinished callback
  data.fader:Stop();
  data.glowScaler:Play();
  data.fader:Play();
end

local function PositionToggleButtons(data)
  data.up:Hide();
  data.down:Hide();

  if (data.settings.activeRows == 1) then
    data.up:SetPoint("BOTTOM", data.buttons, "TOP");
    data.up:SetSize(TOGGLE_BUTTON_WIDTH, TOGGLE_BUTTON_HEIGHT);
    data.up:Show();

  elseif (data.settings.activeRows == 2) then
    local smallWidth = TOGGLE_BUTTON_WIDTH / 2;
    local gap = 1;
    local offset = (smallWidth / 2) + gap;

    data.down:SetPoint("BOTTOM", data.buttons, "TOP", -offset, 0);
    data.down:SetSize(smallWidth, TOGGLE_BUTTON_HEIGHT);
    data.down:Show();
    data.up:SetPoint("BOTTOM", data.buttons, "TOP", offset, 0);
    data.up:SetSize(smallWidth, TOGGLE_BUTTON_HEIGHT);
    data.up:Show();

  elseif (data.settings.activeRows == 3) then
    data.down:SetPoint("BOTTOM", data.buttons, "TOP");
    data.down:SetSize(TOGGLE_BUTTON_WIDTH, TOGGLE_BUTTON_HEIGHT);
    data.down:Show();
  end
end

local function PlayPanelHeightAnimation(data, rows)
  data.buttons:Hide();

  obj:Assert(rows >= 1 and rows <= 3,
    "Invalid number of rows %s. Must be between or equal to 1 and 3.", rows);

  if (InCombatLockdown()) then return end

  PlaySound(tk.Constants.CLICK);

  local previous = data.settings.activeRows;
  local slider = data.slideController; ---@type SlideController
  local rowHeights = data.panelHeightPerRow;

  if (rows == 1) then
    slider:SetMinHeight(rowHeights[1]);
    slider:SetMaxHeight(rowHeights[previous]);

  elseif (rows == 2) then
    if (previous == 1) then
      slider:SetMinHeight(rowHeights[1]);
      slider:SetMaxHeight(rowHeights[2]);
    elseif (previous == 3) then
      slider:SetMinHeight(rowHeights[2]);
      slider:SetMaxHeight(rowHeights[3]);
    end

  elseif (rows == 3) then
    slider:SetMinHeight(rowHeights[previous]);
    slider:SetMaxHeight(rowHeights[3]);
  end

  data.previousActiveRows = data.settings.activeRows;
  data.settings.activeRows = rows;

  if (previous > rows) then
    slider:Start(SlideController.Static.FORCE_RETRACT);
  elseif (previous < rows) then
    slider:Start(SlideController.Static.FORCE_EXPAND);
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
        "animateSpeed",
        "rowSpacing",
        "bartender"
      };
    };
  };

  self:RegisterUpdateFunctions(db.profile.actionBarPanel, {
    fixedHeight = function(value)
      if (not data.settings.bartender.control) then
        data.panel:SetHeight(value);
      end
    end;

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

    rowSpacing = function()
      self:SetUpBartenderBars();
    end;

    bartender = function()
      self:SetUpBartenderBars();
    end;

    animateSpeed = function(value)
      if (data.slideController) then
        data.slideController:SetStepValue(value);
      end
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

function C_ActionBarPanel:SetUpBartenderBars(data)
  if (not (IsAddOnLoaded("Bartender4") and data.settings.bartender.control)) then
    if (data.expandRetractFeatureLoaded) then
      em:DisableEventListeners("ExpandRetractFeature");
      data.panel:SetHeight(data.settings.fixedHeight);
    end

    return
  end

  local bottom = data.panel:GetBottom();
  if (not obj:IsNumber(bottom)) then
    return
  end

  self:LoadExpandRetractFeature();

  -- -- calculate Row Offsets in relation to Resource Bars and Data-text bar:
  local startPoint = bottom;
  local rowSpacing = data.settings.rowSpacing + BARTENDER4_BAR_BUTTON_BORDER_SIZE;
  local row1Height = GetRowHeight(data.settings.bartender[1]);
  local row2Height = GetRowHeight(data.settings.bartender[2]);
  local row3Height = GetRowHeight(data.settings.bartender[3]);

  -- The Y-Offsets of each Bartender Bar per MayronUI row.
  -- Each button is anchored to the TOPLEFT of the bar, so the bar needs to make room for the height of the buttons.
  data.rowOffsets = {};
  data.rowOffsets[1] = startPoint + (ACTION_BAR_PANEL_OVERLAP + ACTION_BAR_PANEL_PADDING + rowSpacing) + row1Height;
  data.rowOffsets[2] = data.rowOffsets[1] + rowSpacing + row2Height;
  data.rowOffsets[3] = data.rowOffsets[2] + rowSpacing + row3Height;

  data.panelHeightPerRow = {};

  for rowId = 1, 3 do
    local endPoint = data.rowOffsets[rowId] +
      (rowSpacing + ACTION_BAR_PANEL_PADDING - ACTION_BAR_PANEL_OVERLAP - BARTENDER4_BAR_BUTTON_BORDER_SIZE);

    data.panelHeightPerRow[rowId] = endPoint - startPoint;

    for _, bartenderBarId in ipairs(data.settings.bartender[rowId]) do
      -- Tell Bartender to enable the bar
      _G.Bartender4:GetModule("ActionBars"):EnableBar(bartenderBarId);

      -- Get Bartender action bar using its ID:
      local bartenderBar = _G[string.format("BT4Bar%d", bartenderBarId)];
      obj:Assert(bartenderBar, "Failed to setup bartender bar %s - bar does not exist", bartenderBarId);

      bartenderBar.config.position.point = "BOTTOM";
      bartenderBar.config.position.y = data.rowOffsets[rowId];

      data.rows[rowId] = data.rows[rowId] or obj:PopTable();
      data.rows[rowId][bartenderBarId] = bartenderBar;

      -- Save changes in Bartender4:
      bartenderBar:LoadPosition();
    end
  end

  -- Set ActionBarPanel height based on active rows:
  data.panel:SetHeight(data.panelHeightPerRow[data.settings.activeRows]);
end

function C_ActionBarPanel:GetPanel(data)
  return data.panel;
end

function C_ActionBarPanel:LoadExpandRetractFeature(data)
  if (data.expandRetractFeatureLoaded) then
    em:EnableEventListeners("ExpandRetractFeature");
    return;
  end

  local listener = em:CreateEventListener(function()
    db.profile.actionBarPanel.activeRows = data.settings.activeRows;
  end);

  listener:RegisterEvent("PLAYER_LOGOUT");
  SetUpSlideController(data);

  -- Create up and down buttons used to expand/retract rows:
  data.buttons = CreateFrame("Frame", nil, data.panel);
  data.buttons:SetFrameStrata("HIGH");
  data.buttons:SetFrameLevel(20);
  data.buttons:SetPoint("BOTTOM", data.panel, "TOP", 0, -2);
  data.buttons:SetSize(1, 1);
  data.buttons:Hide();

  data.up = CreateArrowButton(data);
  data.down = CreateArrowButton(data);
  data.down.icon:SetTexCoord(0, 1, 1, 0);

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

  -- Setup action bar toggling commands:
  _G.BINDING_NAME_MUI_SHOW_1_ACTION_BAR_ROW = "Show 1 Action Bar Row";
  MayronUI:RegisterCommand("Show1ActionBarRows", function()
    PlayPanelHeightAnimation(data, 1);
  end);

  _G.BINDING_NAME_MUI_SHOW_2_ACTION_BAR_ROWS = "Show 2 Action Bar Rows";
  MayronUI:RegisterCommand("Show2ActionBarRows", function()
    PlayPanelHeightAnimation(data, 2);
  end);

  _G.BINDING_NAME_MUI_SHOW_3_ACTION_BAR_ROWS = "Show 3 Action Bar Rows";
  MayronUI:RegisterCommand("Show3ActionBarRows", function()
    PlayPanelHeightAnimation(data, 3);
  end);

  listener = em:CreateEventListenerWithID("ExpandRetractFeature", function()
    HandleModifierStateChanged(data);
  end);

  listener:RegisterEvent("MODIFIER_STATE_CHANGED");

  listener = em:CreateEventListener(function()
    data.up:Hide();
    data.down:Hide();
  end);

  listener:RegisterEvent("PLAYER_REGEN_DISABLED");

  data.expandRetractFeatureLoaded = true;
end
