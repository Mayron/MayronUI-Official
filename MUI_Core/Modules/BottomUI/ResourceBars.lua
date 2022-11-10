-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local InCombatLockdown, CreateFrame = _G.InCombatLockdown, _G.CreateFrame;
local ipairs, table = _G.ipairs, _G.table;
local BAR_NAMES = {"reputation", "experience", "azerite", "artifact"};

local C_ExperienceBar, C_ReputationBar, C_AzeriteBar, C_ArtifactBar;
local C_BaseResourceBar = obj:CreateClass("BaseResourceBar");
local C_ResourceBarsModule = MayronUI:RegisterModule("ResourceBars", L["Resource Bars"], true);
C_ResourceBarsModule.Static:AddFriendClass("BottomUI_Container");

-- Load Database Defaults ----------------

db:AddToDefaults("profile.resourceBars", {
  enabled = true;
  __templateBar = {
    enabled = true;
    height = 8;
    alwaysShowText = false;
    showRemaining = true;
    fontSize = 8;
    texture = "MUI_StatusBar";
  };
  experienceBar = {
    height = 18;
    alwaysShowText = true;
    fontSize = 10;
  };
  reputationBar = {
    standingColors = {
      { r = 0.850980392, g = 0.129411765, b = 0.129411765 }, -- Hated
      { r = 0.870588235, g = 0.329411765, b = 0.11372549 }, -- Hostile
      { r = 0.870588235, g = 0.494117647, b = 0.11372549 }, -- Unfriendly
      { r = 0.968627451, g = 0.968627451, b = 0.105882353 }, -- Neutral
      { r = 0.643137255, g = 0.941176471, b = 0.094117647 }, -- Friendly
      { r = 0.207843137, g = 0.941176471, b = 0.094117647 }, -- Honored
      { r = 0.098039216, g = 0.811764706, b = 0.215686275 }, -- Revered
      { r = 0.066666667, g = 0.850980392, b = 0.850980392 }, -- Exalted
    };
    useDefaultColor = false;
    defaultColor = { r = 0.16, g = 0.6, b = 0.16 };
  };
  artifactBar = {};
  azeriteBar = {};
});

-- C_ResourceBarsModule -------------------
function C_ResourceBarsModule:OnInitialize(data, containerModule)
  data.containerModule = containerModule;

  do
    local template = db.profile.resourceBars.__templateBar;
    local bars = db.profile.resourceBars;

    for _, barName in obj:IterateArgs("experienceBar", "reputationBar", "artifactBar", "azeriteBar") do
      bars[barName]:SetParent(template);
    end
  end

  local function UpdateReputationBarColor()
    local listener = em:GetEventListenerByID("OnReputationBarUpdate");

    if (listener and listener:IsEnabled()) then
      em:TriggerEventListenerByID("OnReputationBarUpdate");
    end
  end

  local function UpdateResourceBar(_, keysList)
    local barName = keysList:PopFront();
    barName = barName:gsub("Bar", tk.Strings.Empty);

    local bar = data.bars[barName];
    local settingName = keysList:PopFront();

    if (settingName == "texture") then
      bar:UpdateStatusBarTexture();
    else
      bar:Update();
    end

    if (settingName == "height") then
      self:UpdateContainerHeight();
    end
  end

  local options = {
    onExecuteAll = {
      first = {
        "experienceBar.enabled";
        "reputationBar.enabled";
      };
      ignore = {
        ".*"; -- ignore everything else
      };
    };
  };

  local updateFuncs = {
    experienceBar = {
      enabled = function(value)
        data.bars.experience:SetEnabled(value);
      end;

      height = UpdateResourceBar;
      alwaysShowText = UpdateResourceBar;
      showRemaining = UpdateResourceBar;
      fontSize = UpdateResourceBar;
      texture = UpdateResourceBar;
    };

    reputationBar = {
      enabled = function(value)
        data.bars.reputation:SetEnabled(value);
      end;

      height = UpdateResourceBar;
      alwaysShowText = UpdateResourceBar;
      showRemaining = UpdateResourceBar;
      fontSize = UpdateResourceBar;
      texture = UpdateResourceBar;
      standingColors = UpdateReputationBarColor;
      useDefaultColor = UpdateReputationBarColor;
      defaultColor = UpdateReputationBarColor;
    };
  };

  if (tk:IsRetail()) then
    updateFuncs.artifactBar = {
      enabled = function(value)
        data.bars.artifact:SetEnabled(value);
      end;

      height = UpdateResourceBar;
      alwaysShowText = UpdateResourceBar;
      showRemaining = UpdateResourceBar;
      fontSize = UpdateResourceBar;
      texture = UpdateResourceBar;
    };
    updateFuncs.azeriteBar = {
      enabled = function(value)
        data.bars.azerite:SetEnabled(value);
      end;

      height = UpdateResourceBar;
      alwaysShowText = UpdateResourceBar;
      showRemaining = UpdateResourceBar;
      fontSize = UpdateResourceBar;
      texture = UpdateResourceBar;
    };

    table.insert(options.onExecuteAll.first, "artifactBar.enabled");
    table.insert(options.onExecuteAll.first, "azeriteBar.enabled");
  end

  self:RegisterUpdateFunctions(db.profile.resourceBars, updateFuncs, options);

  if (data.settings.enabled) then
      self:SetEnabled(true);
  end
end

function C_ResourceBarsModule:OnDisable(data)
  if (data.barsContainer) then
    data.barsContainer:Hide();
    data.containerModule:RepositionContent();
    return;
  end
end

function C_ResourceBarsModule:OnEnable(data)
  if (data.barsContainer) then
    data.barsContainer:Show();
    data.containerModule:RepositionContent();
    return;
  end

  data.barsContainer = CreateFrame("Frame", "MUI_ResourceBars", _G["MUI_BottomContainer"]);
  data.barsContainer:SetFrameStrata("MEDIUM");
  data.barsContainer:SetHeight(1);

  data.bars = obj:PopTable();
  data.bars.experience = C_ExperienceBar(self, data);
  data.bars.reputation = C_ReputationBar(self, data);

  if (tk:IsRetail()) then
    data.bars.artifact = C_ArtifactBar(self, data);
    data.bars.azerite = C_AzeriteBar(self, data);
  end

  MayronUI:Hook("DataTextModule", "OnInitialize", function(dataTextModule, dataTextModuleData)
    dataTextModule:RegisterUpdateFunctions(db.profile.datatext, {
    blockInCombat = function(value)
      self:SetBlockerEnabled(value, dataTextModuleData.bar);
    end;
    });
  end);

  local listener = em:CreateEventListenerWithID("ResourceBars_HeightUpdate", function()
    if (data.pendingHeightUpdate) then
      data.barsContainer:SetHeight(data.pendingHeightUpdate);
      data.pendingHeightUpdate = nil;

      local actionBarPanelModule = MayronUI:ImportModule("ActionBarPanel");

      if (actionBarPanelModule and actionBarPanelModule:IsEnabled()) then
        actionBarPanelModule:SetUpExpandRetract();
      end
    end
  end);

  listener:RegisterEvent("PLAYER_REGEN_ENABLED");
end

function C_ResourceBarsModule:UpdateContainerHeight(data)
  local height = 0;
  local previousFrame;

  for _, barName in ipairs(BAR_NAMES) do
    -- check if bar was ever enabled
    if (data.bars[barName]) then
      local bar = data.bars[barName];
      local frame = bar:GetFrame();

      -- check if frame has been frame (bar has been built)
      if (frame and bar:IsEnabled() and bar:CanUse()) then
        frame:ClearAllPoints();
        frame:SetParent(data.barsContainer);

        if (not previousFrame) then
          frame:SetPoint("BOTTOMLEFT");
          frame:SetPoint("BOTTOMRIGHT");
        else
          frame:SetPoint("BOTTOMLEFT", previousFrame, "TOPLEFT", 0, -1);
          frame:SetPoint("BOTTOMRIGHT", previousFrame, "TOPRIGHT", 0, -1);
          height = height - 1;
        end

        height = height + frame:GetHeight();
        previousFrame = frame;
        frame:Show();

      elseif (frame) then
        tk:AttachToDummy(frame);
      end
    end
  end

  if (height == 0) then
    height = 1;
  end

  data.pendingHeightUpdate = height;

  if (not InCombatLockdown()) then
    em:TriggerEventListenerByID("ResourceBars_HeightUpdate");
  end
end

obj:DefineReturns("number");
function C_ResourceBarsModule:GetHeight(data)
  if (data.barsContainer) then
    return data.barsContainer:GetHeight();
  end

  return 0;
end

obj:DefineParams("string");
obj:DefineReturns("Frame");
function C_ResourceBarsModule:GetBar(data, barName)
  return data.bars[barName];
end

function C_ResourceBarsModule:SetBlockerEnabled(data, enabled, dataTextBar)
  if (not data.blocker and enabled) then
    data.blocker = tk:PopFrame("Frame", data.barsContainer);
    data.blocker:SetPoint("TOPLEFT");
    data.blocker:SetPoint("BOTTOMRIGHT", dataTextBar, "BOTTOMRIGHT");
    data.blocker:EnableMouse(true);
    data.blocker:SetFrameStrata("DIALOG");
    data.blocker:SetFrameLevel(20);
    data.blocker:Hide();
  end

  if (enabled) then
    if (not em:GetEventListenerByID("Blocker_RegenChanged")) then
      local onChangedListener = em:CreateEventListenerWithID("Blocker_RegenChanged", function(_, event)
        data.blocker:SetShown(event == "PLAYER_REGEN_DISABLED");
      end);

      onChangedListener:RegisterEvents("PLAYER_REGEN_ENABLED", "PLAYER_REGEN_DISABLED");
    else
      em:EnableEventListeners("Blocker_RegenChanged");
    end

    if (InCombatLockdown()) then
      data.blocker:Show();
    end
  else
    em:DisableEventListeners("Blocker_RegenChanged");

    if (data.blocker) then
      data.blocker:Hide();
    end
  end
end

obj:DefineReturns("Frame");
function C_ResourceBarsModule:GetBarContainer(data)
  return data.barsContainer;
end

-- C_ResourceBar ---------------------------

obj:DefineParams("ResourceBars", "table", "string");
function C_BaseResourceBar:CreateResourceBar(data, barsModule, moduleData, barName)
  data.module = barsModule;
  data.barName = barName;
  data.settings = moduleData.settings[barName.."Bar"];
  data.barsContainer = moduleData.barsContainer;
  data.notCreated = true;
end

function C_BaseResourceBar:UpdateStatusBarTexture(data)
  if (not data.statusbar) then
    return; -- not active
  end

  local texture = tk.Constants.LSM:Fetch("statusbar", data.settings.texture);
  data.frame.bg = tk:SetBackground(data.frame, texture);
  data.frame.bg:SetVertexColor(0.08, 0.08, 0.08);
  data.statusbar:SetStatusBarTexture(texture);
  data.statusbar.texture = data.statusbar:GetStatusBarTexture();
end

function C_BaseResourceBar:CreateBar(data)
  local frame = CreateFrame("Frame", "MUI_"..data.barName.."Bar", data.barsContainer,
    _G.BackdropTemplateMixin and "BackdropTemplate");

  frame:SetBackdrop(tk.Constants.BACKDROP);
  frame:SetBackdropBorderColor(0, 0, 0);
  frame:SetHeight(data.settings.height);

  local statusbar = CreateFrame("StatusBar", nil, frame);
  statusbar:SetOrientation("HORIZONTAL");
  statusbar:SetPoint("TOPLEFT", 1, -1);
  statusbar:SetPoint("BOTTOMRIGHT", -1, 1);

  statusbar.text = statusbar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
  statusbar.text:SetPoint("CENTER");

  data.frame = frame;
  data.statusbar = statusbar;

  self:UpdateStatusBarTexture();
end

do
  local function OnEnter(self)
    self.texture:SetBlendMode("ADD");
    _G.GameTooltip:SetOwner(self, "ANCHOR_TOP");
    _G.GameTooltip:AddLine(self.text:GetText(), 1, 1, 1);
    _G.GameTooltip:Show();
  end

  local function OnLeave(self)
    self.texture:SetBlendMode("BLEND");
    _G.GameTooltip:Hide();
  end

  function C_BaseResourceBar:Update(data)
    if (not data.statusbar) then
      return -- not active
    end

    data.frame:SetHeight(data.settings.height);
    tk:SetFontSize(data.statusbar.text, data.settings.fontSize);

    if (data.settings.alwaysShowText) then
      data.statusbar.text:Show();
      data.statusbar:SetScript("OnEnter", tk.Constants.DUMMY_FUNC);
      data.statusbar:SetScript("OnLeave", tk.Constants.DUMMY_FUNC);
    else
      data.statusbar.text:Hide();
      data.statusbar:SetScript("OnEnter", OnEnter);
      data.statusbar:SetScript("OnLeave", OnLeave);
    end
  end
end

obj:DefineReturns("number");
function C_BaseResourceBar:GetHeight(data)
  return data.frame:GetHeight();
end

obj:DefineReturns("boolean");
function C_BaseResourceBar:IsActive(data)
  return (data.frame ~= nil and data.frame:IsShown());
end

obj:DefineReturns("boolean");
function C_BaseResourceBar:IsEnabled(data)
  return data.settings.enabled;
end

obj:DefineParams("boolean");
function C_BaseResourceBar:SetActive(data, active)
  if (data.activeState == active) then
    return;
  end

  data.activeState = active;

  if (active) then
    if (not data.frame) then
      self:CreateBar();
    end

    self:Update();
  end

  data.module:UpdateContainerHeight();
end

C_ExperienceBar = obj:CreateClass("ExperienceBar", C_BaseResourceBar);
obj:Export(C_ExperienceBar, "MayronUI");

C_ReputationBar = obj:CreateClass("ReputationBar", C_BaseResourceBar);
obj:Export(C_ReputationBar, "MayronUI");

if (tk:IsRetail()) then
  C_AzeriteBar = obj:CreateClass("AzeriteBar", C_BaseResourceBar);
  obj:Export(C_AzeriteBar, "MayronUI");

  C_ArtifactBar = obj:CreateClass("ArtifactBar", C_BaseResourceBar);
  obj:Export(C_ArtifactBar, "MayronUI");
end