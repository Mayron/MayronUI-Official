-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local CreateFrame, InCombatLockdown, PlaySound = _G.CreateFrame, _G.InCombatLockdown, _G.PlaySound;
local UIFrameFadeIn, UIFrameFadeOut = _G.UIFrameFadeIn, _G.UIFrameFadeOut;
local IsAddOnLoaded, string, ipairs = _G.IsAddOnLoaded, _G.string, _G.ipairs;
local C_Timer = _G.C_Timer;

local Private = {};
local FADING_STACKING_DELAY = 0.2;
local TOGGLE_BUTTON_WIDTH = 120;
local TOGGLE_BUTTON_HEIGHT = 28;

-- Register and Import Modules -----------
local Engine = obj:Import("MayronUI.Engine");
local C_ActionBarPanel = MayronUI:RegisterModule("BottomUI_ActionBarPanel", L["Action Bar Panel"], true);
local SlideController = gui.WidgetsPackage:Get("SlideController");

-- Load Database Defaults ----------------
db:AddToDefaults("profile.actionBarPanel", {
  enabled         = true; -- show/hide action bar panel

  -- Appearance properties
  texture         = tk:GetAssetFilePath("Textures\\BottomUI\\ActionBarPanel");
  alpha           = 1;
  cornerSize      = 20;
  rowSpacing      = 5.5;

  -- Default settings for the expand and retract feature:
  expandRetract = true; -- Enable button to toggle between number of visible rows
  modKey = "C"; -- modifier key to toggle expand and retract button
  animateSpeed = 6; -- expand and retract speed to show or hide an action bar row
  defaultHeight = 80; -- the height used when expandRetract feature is disabled
  activeRows = 1; -- only show 1 row

  rowHeights = { -- the action bar panel height for each row
    [1] = 44,
    [2] = 81,
    [3] = 116.5
  };

  bartender = {
    control = true;
    -- Row 1
    [1] = { 1, 7 };
    -- Row 2
    [2] = { 9, 10 };
    -- Row 3:
    [3] = { 5, 6 };
  };
});

-- local functions ------------------

local function ShowKeyBindings()
  _G.LoadAddOn("Blizzard_BindingUI");
  _G.KeyBindingFrame:Show();

  for _, btn in ipairs(_G.KeyBindingFrame.categoryList.buttons) do
    if (btn.element and btn.element.name == "MayronUI") then
      btn:Click();
    end
  end
end

function Private:LoadTutorial()
  local frame = tk:PopFrame("Frame", self.panel);

  frame:SetFrameStrata("TOOLTIP");
  frame:SetSize(300, 150);
  frame:SetPoint("BOTTOM", self.panel, "TOP", 0, 120);

  gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, nil, frame);
  gui:AddCloseButton(tk.Constants.AddOnStyle, frame);
  gui:AddTitleBar(tk.Constants.AddOnStyle, frame, "Tutorial: Step 1");
  gui:AddArrow(tk.Constants.AddOnStyle, frame, "DOWN");

  frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  frame.text:SetWordWrap(true);
  frame.text:SetPoint("TOPLEFT", 20, -20);
  frame.text:SetPoint("BOTTOMRIGHT", -20, 10);
  tk:SetFontSize(frame.text, 13);

  local modKeyLabels = {
    ["C"] = "CTRL",
    ["S"] = "SHIFT",
    ["A"] = "ALT",
  };

  local modKey = db.profile.actionBarPanel.modKey;
  local modKeyLabel;
  for i = 1, #modKey do
    local c = modKey:sub(i,i);

    if (i == 1) then
      modKeyLabel = modKeyLabels[c];
    else
      modKeyLabel = string.format("%s+%s", modKeyLabel, modKeyLabels[c]);
    end
  end

  local tutorialMessage = "Press and hold %s while out of combat to show toggle buttons.\n\n Clicking these will show or hide additional action bar rows.";
  tutorialMessage = tutorialMessage:format(tk.Strings:SetTextColorByKey(modKeyLabel, "GOLD"));
  frame.text:SetText(tutorialMessage);

  em:CreateEventHandler("MODIFIER_STATE_CHANGED", function(self)
    if (not tk:IsModComboActive(modKey)) then return end
    frame.titleBar.text:SetText("Tutorial: Step 2");
    frame.text:SetText("You can change this key combination in the MUI config menu (/mui config).\n\nAlso, there are 3 key bindings to quickly switch between 1 to 3 rows, found in the Blizzard key bindings menu.");
    frame:SetHeight(200);
    frame.text:SetPoint("BOTTOMRIGHT", -20, 50);

    local btn = gui:CreateButton(tk.Constants.AddOnStyle, frame, "Show MUI Key Bindings");
    btn:SetPoint("BOTTOM", 0, 20);
    btn:SetScript("OnClick", function()
      ShowKeyBindings();
      frame.closeBtn:Click();
    end);

    btn:SetWidth(200);

    if (not frame:IsShown()) then
      UIFrameFadeIn(frame, 0.5, 0, 1);
      frame:Show();
    end

    db.profile.actionBarPanel.tutorial = _G.GetAddOnMetadata("MUI_Core", "Version");
    self:Destroy();
  end);
end

function Private:ToggleBartenderBar(bt4Bar, show, delay)
  if (not (IsAddOnLoaded("Bartender4") and self.settings.bartender.control))then
    return false;
  end

  local visible = bt4Bar:GetVisibilityOption("always");
  if ((not show) == visible) then return false; end

  bt4Bar:SetConfigAlpha((show and 1) or 0);
  bt4Bar:SetVisibilityOption("always", not show);

  if (show) then
    bt4Bar:SetAlpha(0);
    bt4Bar.fadeIn = bt4Bar.fadeIn or function() UIFrameFadeIn(bt4Bar, 0.1, 0, 1) end;

    C_Timer.After(0.1 + (delay or 0), bt4Bar.fadeIn);
    return true;
  end

  return true;
end

function Private:ToggleBartenderBarRow(rowId, show, delay)
  if (not (IsAddOnLoaded("Bartender4") and self.settings.bartender.control)) then
    return false;
  end

  local bars = self.settings.bartender[rowId];
  local fadingIn = false;

  for _, bartenderBarId in ipairs(bars) do
    if (obj:IsNumber(bartenderBarId)) then
      local bartenderBarName = string.format("BT4Bar%d", bartenderBarId);
      local bartenderBar = _G[bartenderBarName];

      if (obj:IsTable(bartenderBar)) then
        if (self:ToggleBartenderBar(bartenderBar, show, delay)) then
          fadingIn = true;
        end
      end
    end
  end

  return fadingIn;
end

function Private:SetUpPanelHeight()
  if (not self.settings.expandRetract) then
    self.panel:SetHeight(self.settings.defaultHeight);
    return
  end

  local activeRows = self.settings.activeRows;
  self.panel:SetHeight(self.settings.rowHeights[activeRows]);

  for rowId = 1, 3 do
    self:ToggleBartenderBarRow(rowId, rowId <= activeRows);
  end
end

-- Controls the Expand and Retract animation:
function Private:SetUpSlideController()
  ---@type SlideController
  self.slideController = SlideController(self.panel, nil, false);
  self.slideController:SetStepValue(self.settings.animateSpeed);

  self.slideController:OnStartExpand(function()
    local delay = 0;

    for rowId = 1, self.settings.activeRows do
      local fadingIn = self:ToggleBartenderBarRow(rowId, true, FADING_STACKING_DELAY * delay);

      if (fadingIn) then
        delay = delay + 1;
      end
    end
  end, 5);

  self.slideController:OnStartRetract(function()
    if (not self.settings.bartender.control) then return end
    local delay = 0;

    for rowId = self.previousActiveRows, self.settings.activeRows + 1, -1 do
      local bars = self.settings.bartender[rowId];
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

  self.slideController:OnEndRetract(function()
    for rowId = self.settings.activeRows + 1, 3 do
      self:ToggleBartenderBarRow(rowId, false);
    end
  end);
end

function Private:CreateButton()
  local btn = gui:CreateButton(tk.Constants.AddOnStyle, self.buttons);
  btn:SetFrameStrata("HIGH");
  btn:SetFrameLevel(30);
  btn:SetBackdrop(tk.Constants.BACKDROP);
  btn:SetBackdropBorderColor(0, 0, 0);
  btn:SetScript("OnClick", function(b) self:HandleButtonClick(b); end);
  btn:Hide();

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

function Private:HandleModifierStateChanged()
  if (not tk:IsModComboActive(self.settings.modKey) or InCombatLockdown()) then
    self.buttons:Hide();
    return;
  end

  -- force execution of OnFinished callback
  self.fader:Stop();
  self.glowScaler:Play();
  self.fader:Play();
end

function Private:HandleButtonClick(btn)
  if (self.up == btn and self.settings.activeRows < 3) then
    MayronUI:TriggerCommand(string.format("Show%dActionBarRows", self.settings.activeRows + 1));
  elseif (self.down == btn and self.settings.activeRows > 1) then
    MayronUI:TriggerCommand(string.format("Show%dActionBarRows", self.settings.activeRows - 1));
  end
end

function Private:PositionToggleButtons()
  self.up:Hide();
  self.down:Hide();

  if (self.settings.activeRows == 1) then
    self.up:SetPoint("BOTTOM", self.buttons, "TOP");
    self.up:SetSize(TOGGLE_BUTTON_WIDTH, TOGGLE_BUTTON_HEIGHT);
    self.up:Show();

  elseif (self.settings.activeRows == 2) then
    local smallWidth = TOGGLE_BUTTON_WIDTH / 2;
    local gap = 1;
    local offset = (smallWidth / 2) + gap;

    self.down:SetPoint("BOTTOM", self.buttons, "TOP", -offset, 0);
    self.down:SetSize(smallWidth, TOGGLE_BUTTON_HEIGHT);
    self.down:Show();
    self.up:SetPoint("BOTTOM", self.buttons, "TOP", offset, 0);
    self.up:SetSize(smallWidth, TOGGLE_BUTTON_HEIGHT);
    self.up:Show();

  elseif (self.settings.activeRows == 3) then
    self.down:SetPoint("BOTTOM", self.buttons, "TOP");
    self.down:SetSize(TOGGLE_BUTTON_WIDTH, TOGGLE_BUTTON_HEIGHT);
    self.down:Show();
  end
end

-- C_ActionBarPanel -----------------
function C_ActionBarPanel:OnInitialize(data, containerModule)
  data.containerModule = containerModule;
  data.rows = obj:PopTable();
  data:Embed(Private);

  local options = {
    onExecuteAll = {
      ignore = {
        "rowHeights",
        "animateSpeed",
        "activeRows",
        "defaultHeight",
        "rowSpacing"
      };
    };
    groups = {
      {
        patterns = { "bartender" };
        value = function(value, keysList)
          local _, rowId = keysList:PopFront(), keysList:PopFront();

          if (obj:IsNumber(value)) then
            self:SetUpBartenderBar(rowId, value);
          end
        end;
      };
    };
  };

  self:RegisterUpdateFunctions(db.profile.actionBarPanel, {
    expandRetract = function(value)
      if (value) then
        self:LoadExpandRetractFeature();
      elseif (data.expandRetractFeatureLoaded) then
        local handler = em:FindEventHandlerByKey("ExpandRetractFeature");
        handler:SetEventTriggerEnabled("MODIFIER_STATE_CHANGED", false);

        data.panel:SetHeight(data.settings.defaultHeight);
      end
    end;

    ---@param keyValues LinkedList
    rowHeights = function(value, keyValues)
      local rowId = keyValues:GetBack();

      if (data.settings.activeRows == rowId) then
        data.panel:SetHeight(value);
      end
    end;

    ---@param keyValues LinkedList
    rowSpacing = function()
      self:SetUpAllBartenderBars();
    end;

    defaultHeight = function(value)
      if (not data.settings.expandRetract) then
        data.panel:SetHeight(value);
      end
    end;

    animateSpeed = function(value)
      if (data.slideController) then
        data.slideController:SetStepValue(value);
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

    bartender = {
      control = function()
        self:SetUpAllBartenderBars();
      end
    };
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
  data.panel:SetHeight(data.settings.defaultHeight);

  gui:CreateGridTexture(data.panel, data.settings.texture, data.settings.cornerSize, nil, 749, 45);

  if (data.settings.expandRetract and not data.settings.tutorial) then
    local show = tk:GetTutorialShowState(data.settings.tutorial);

    if (show) then
      data:LoadTutorial();
    end
  end
end

function Private:GetRowHeight(rowId)
  local barIds = self.settings.bartender[rowId];
  local maxHeight = 0;

  for _, barId in ipairs(barIds) do
    if (barId > 0) then
      _G.Bartender4:GetModule("ActionBars"):EnableBar(barId);
      local bartenderBar = _G[string.format("BT4Bar%d", barId)];

      local barHeight = bartenderBar.buttons[1]:GetHeight(); -- always 36
      barHeight = barHeight * bartenderBar:GetScale();

      if (barHeight > maxHeight) then
        maxHeight = barHeight;
      end
    end
  end

  return maxHeight;
end

---@param rowId number The MUI row number (between 1 and 3)
---@param bartenderBarID number The BT4Bar<n> ID where n is the ID number
---This function controls the selected bartender action bars by setting them up
Engine:DefineParams("number", "number");
function C_ActionBarPanel:SetUpBartenderBar(data, rowId, bartenderBarId)
  if (bartenderBarId == 0) then return end -- disabled
  if (not (IsAddOnLoaded("Bartender4") and data.settings.bartender.control)) then
    return;
  end

  -- Tell Bartender to enable the bar
  _G.Bartender4:GetModule("ActionBars"):EnableBar(bartenderBarId);

  -- Get Bartender action bar using its ID:
  local bartenderBar = _G[string.format("BT4Bar%d", bartenderBarId)];
  obj:Assert(bartenderBar, "Failed to setup bartender bar %s - bar does not exist", bartenderBarId);

  -- calculate height in relation to Resource Bars and Data-text bar:
  local height = 0;
  local resourceBarsModule = MayronUI:ImportModule("BottomUI_ResourceBars", true);
  local dataTextModule = MayronUI:ImportModule("DataTextModule", true);

  if (resourceBarsModule and resourceBarsModule:IsEnabled()) then
    -- Get the combined height of all enabled resource bars
    height = resourceBarsModule:GetHeight() - 3;
  end

  if (dataTextModule and dataTextModule:IsShown()) then
    -- Get the height of the data-text bar
    local dataTextBar = dataTextModule:GetDataTextBar();
    height = height + ((dataTextBar and dataTextBar:GetHeight()) or 0);
  end

  height = height + 9; -- distance from bottom edge of action bar panel (to allow for some space)

  for r = 1, rowId do
    -- add all row heights
    height = height + data:GetRowHeight(r);
  end

  height = height + ((rowId - 1) * data.settings.rowSpacing);

  bartenderBar.config.position.y = height;

  data.rows[rowId] = data.rows[rowId] or obj:PopTable();
  data.rows[rowId][bartenderBarId] = bartenderBar;

  -- Save changes in Bartender4:
  bartenderBar:LoadPosition();
end

function C_ActionBarPanel:SetUpAllBartenderBars(data)
  for rowId = 1, 3 do
    for _, bartenderBarID in ipairs(data.settings.bartender[rowId]) do
      self:SetUpBartenderBar(rowId, bartenderBarID);
    end
  end
end

function C_ActionBarPanel:GetPanel(data)
  return data.panel;
end

Engine:DefineParams("number")
---@param rows number The number of rows to show
-- Expands or Retracts the action bar panel to show a given number of rows
function C_ActionBarPanel:SetNumActiveRows(data, rows)
  data.buttons:Hide();

  obj:Assert(rows >= 1 and rows <= 3, "Invalid number of rows %s. Must be between or equal to 1 and 3.", rows);

  if (InCombatLockdown()) then return end

  PlaySound(tk.Constants.CLICK);
  local previous = data.settings.activeRows;
  local slider = data.slideController; ---@type SlideController

  if (rows == 1) then
    slider:SetMinHeight(data.settings.rowHeights[1]);
    slider:SetMaxHeight(data.settings.rowHeights[previous]);

  elseif (rows == 2) then
    if (previous == 1) then
      slider:SetMinHeight(data.settings.rowHeights[1]);
      slider:SetMaxHeight(data.settings.rowHeights[2]);
    elseif (previous == 3) then
      slider:SetMinHeight(data.settings.rowHeights[2]);
      slider:SetMaxHeight(data.settings.rowHeights[3]);
    end

  elseif (rows == 3) then
    slider:SetMinHeight(data.settings.rowHeights[previous]);
    slider:SetMaxHeight(data.settings.rowHeights[3]);
  end

  data.previousActiveRows = data.settings.activeRows;
  data.settings.activeRows = rows;

  if (previous > rows) then
    slider:Start(SlideController.Static.FORCE_RETRACT);
  elseif (previous < rows) then
    slider:Start(SlideController.Static.FORCE_EXPAND);
  end
end

function C_ActionBarPanel:LoadExpandRetractFeature(data)
  if (data.expandRetractFeatureLoaded) then
    local handler = em:FindEventHandlerByKey("ExpandRetractFeature");
    handler:SetEventTriggerEnabled("MODIFIER_STATE_CHANGED", true);

    -- Set up the height of data.panel
    data:SetUpPanelHeight();
    return;
  end

  em:CreateEventHandler("PLAYER_LOGOUT", function()
    db.profile.actionBarPanel.activeRows = data.settings.activeRows;
  end);

  -- Set up the height of data.panel
  data:SetUpPanelHeight();
  data:SetUpSlideController();

  -- Create up and down buttons used to expand/retract rows:
  data.buttons = CreateFrame("Frame", nil, data.panel);
  data.buttons:SetFrameStrata("HIGH");
  data.buttons:SetFrameLevel(20);
  data.buttons:SetPoint("BOTTOM", data.panel, "TOP", 0, -2);
  data.buttons:SetSize(1, 1);
  data.buttons:Hide();

  data.up = data:CreateButton();
  data.down = data:CreateButton();
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
  glowScaler.anim:SetFromScale(0, 0);
  glowScaler.anim:SetToScale(1, 1);

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
    data:PositionToggleButtons();
    data.buttons:SetAlpha(0);
  end);

  -- Needed for private script handler callbacks:
  data.glowScaler = glowScaler;
  data.glow = glow;
  data.fader = fader;

  -- Setup action bar toggling commands:
  _G.BINDING_NAME_MUI_SHOW_1_ACTION_BAR_ROW = "Show 1 Action Bar Row";
  MayronUI:RegisterCommand("Show1ActionBarRows", function()
    self:SetNumActiveRows(1);
  end);

  _G.BINDING_NAME_MUI_SHOW_2_ACTION_BAR_ROWS = "Show 2 Action Bar Rows";
  MayronUI:RegisterCommand("Show2ActionBarRows", function()
    self:SetNumActiveRows(2);
  end);

  _G.BINDING_NAME_MUI_SHOW_3_ACTION_BAR_ROWS = "Show 3 Action Bar Rows";
  MayronUI:RegisterCommand("Show3ActionBarRows", function()
    self:SetNumActiveRows(3);
  end);

  em:CreateEventHandlerWithKey("MODIFIER_STATE_CHANGED", "ExpandRetractFeature", function()
    data:HandleModifierStateChanged();
  end);

  em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
    data.up:Hide();
    data.down:Hide();
  end);

  data.expandRetractFeatureLoaded = true;
end