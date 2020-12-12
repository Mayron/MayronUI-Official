-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local InCombatLockdown, CreateFrame = _G.InCombatLockdown, _G.CreateFrame;
local ipairs, table = _G.ipairs, _G.table;

-- Constants -----------------------------

local BAR_NAMES = {"reputation", "experience", "azerite", "artifact"};

-- Setup Objects -------------------------

local Engine = obj:Import("MayronUI.Engine");

local ResourceBarsPackage = obj:CreatePackage("ResourceBars", "MayronUI");
local C_BaseResourceBar = ResourceBarsPackage:CreateClass("BaseResourceBar", "Framework.System.FrameWrapper");
local C_ExperienceBar = ResourceBarsPackage:CreateClass("ExperienceBar", C_BaseResourceBar);
local C_ReputationBar = ResourceBarsPackage:CreateClass("ReputationBar", C_BaseResourceBar);
local C_AzeriteBar, C_ArtifactBar;

if (tk:IsRetail()) then
  C_AzeriteBar = ResourceBarsPackage:CreateClass("AzeriteBar", C_BaseResourceBar);
  C_ArtifactBar = ResourceBarsPackage:CreateClass("ArtifactBar", C_BaseResourceBar);
end
-- Register and Import Modules -----------

local C_ResourceBarsModule = MayronUI:RegisterModule("BottomUI_ResourceBars", L["Resource Bars"], true);

C_ResourceBarsModule.Static:AddFriendClass("BottomUI_Container");

-- Load Database Defaults ----------------

db:AddToDefaults("profile.resourceBars", {
  enabled = true;
  __templateBar = {
    enabled = true;
    height = 8;
    alwaysShowText = false;
    fontSize = 8;
    texture = "MUI_StatusBar";
  };
  experienceBar = {};
  reputationBar = {};
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
      fontSize = UpdateResourceBar;
      texture = UpdateResourceBar;
    };

    reputationBar = {
      enabled = function(value)
        data.bars.reputation:SetEnabled(value);
      end;

      height = UpdateResourceBar;
      alwaysShowText = UpdateResourceBar;
      fontSize = UpdateResourceBar;
      texture = UpdateResourceBar;
    };
  };

  if (tk:IsRetail()) then
    updateFuncs.artifactBar = {
      enabled = function(value)
        data.bars.artifact:SetEnabled(value);
      end;

      height = UpdateResourceBar;
      alwaysShowText = UpdateResourceBar;
      fontSize = UpdateResourceBar;
      texture = UpdateResourceBar;
    };
    updateFuncs.azeriteBar = {
      enabled = function(value)
        data.bars.azerite:SetEnabled(value);
      end;

      height = UpdateResourceBar;
      alwaysShowText = UpdateResourceBar;
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

  em:CreateEventHandlerWithKey("PLAYER_REGEN_ENABLED", "ResourceBars_HeightUpdate", function()
    if (data.pendingHeightUpdate) then
      data.barsContainer:SetHeight(data.pendingHeightUpdate);
      data.pendingHeightUpdate = nil;

      local actionBarPanelModule = MayronUI:ImportModule("BottomUI_ActionBarPanel");

      if (actionBarPanelModule and actionBarPanelModule:IsEnabled()) then
        actionBarPanelModule:SetUpAllBartenderBars();
      end
    end
  end);
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
    em:TriggerEventHandlerByKey("ResourceBars_HeightUpdate");
  end
end

Engine:DefineReturns("number");
function C_ResourceBarsModule:GetHeight(data)
  if (data.barsContainer) then
    return data.barsContainer:GetHeight();
  end

  return 0;
end

Engine:DefineParams("string");
Engine:DefineReturns("Frame");
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
    em:CreateEventHandlerWithKey("PLAYER_REGEN_ENABLED", "Blocker_RegenEnabled", function()
      data.blocker:Hide();
    end);

    em:CreateEventHandlerWithKey("PLAYER_REGEN_DISABLED", "Blocker_RegenDisabled", function()
      data.blocker:Show();
    end);

    if (InCombatLockdown()) then
      data.blocker:Show();
    end
  else
    em:DestroyEventHandlerByKey("Blocker_RegenEnabled");
    em:DestroyEventHandlerByKey("Blocker_RegenDisabled");

    if (data.blocker) then
      data.blocker:Hide();
    end
  end
end

Engine:DefineReturns("Frame");
function C_ResourceBarsModule:GetBarContainer(data)
  return data.barsContainer;
end

-- C_ResourceBar ---------------------------

ResourceBarsPackage:DefineParams("BottomUI_ResourceBars", "table", "string");
function C_BaseResourceBar:__Construct(data, barsModule, moduleData, barName)
  data.module = barsModule;
  data.barName = barName;
  data.settings = moduleData.settings[barName.."Bar"];
  data.barsContainer = moduleData.barsContainer;
  data.notCreated = true;
end

function C_BaseResourceBar:UpdateStatusBarTexture(data)
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
      return; -- not active
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

ResourceBarsPackage:DefineReturns("number");
function C_BaseResourceBar:GetHeight(data)
  return data.frame:GetHeight();
end

ResourceBarsPackage:DefineReturns("boolean");
function C_BaseResourceBar:IsActive(data)
  return (data.frame ~= nil and data.frame:IsShown());
end

ResourceBarsPackage:DefineReturns("boolean");
function C_BaseResourceBar:IsEnabled(data)
  return data.settings.enabled;
end

ResourceBarsPackage:DefineParams("boolean");
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