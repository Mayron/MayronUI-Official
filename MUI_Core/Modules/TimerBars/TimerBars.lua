--luacheck: ignore self 143 631
local addOnName = ...;
local MayronUI = _G.MayronUI;

local tk, _, em, _, obj, L = MayronUI:GetCoreComponents();
local LibStub = _G.LibStub;

---@type MayronDB
local MayronDB = obj:Import("Pkg-MayronDB.MayronDB");

---@type Database
local db = MayronDB.Static:CreateDatabase(addOnName, "MUI_TimerBarsDb", nil, "MUI TimerBars");

_G.MUI_TimerBars = {}; -- Create new global

local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo;
local unpack, CreateFrame, UnitIsDeadOrGhost = _G.unpack, _G.CreateFrame, _G.UnitIsDeadOrGhost;
local string, date, pairs, ipairs = _G.string, _G.date, _G.pairs, _G.ipairs;
local UnitExists, UnitGUID, UIParent = _G.UnitExists, _G.UnitGUID, _G.UIParent;
local table, GetTime, UnitAura, tostring = _G.table, _G.GetTime, _G.UnitAura, _G.tostring;

local RepositionBars;

local HELPFUL, HARMFUL, DEBUFF, BUFF, UP = "HELPFUL", "HARMFUL", "DEBUFF", "BUFF", "UP";
local TIMER_FIELD_UPDATE_FREQUENCY = 0.05;
local UNKNOWN_AURA_TYPE = "Unknown aura type '%s'.";
local DEBUFF_MAX_DISPLAY = _G.DEBUFF_MAX_DISPLAY;
local BUFF_MAX_DISPLAY = _G.BUFF_MAX_DISPLAY;
local ICON_GAP = -1;
local OnCombatLogEvent, CheckUnitAuras;

local UnitIDFieldPairs = {}; -- contains FieldName to unitID

if (tk:IsClassic()) then
  local LibClassicDurations = LibStub("LibClassicDurations");
  LibClassicDurations:Register(addOnName);
  UnitAura = LibClassicDurations.UnitAuraWrapper;
end

local function CanHandleAura(fieldUnitID, sourceUnitID)
  if (not obj:IsString(fieldUnitID)) then
    -- TimerField has been removed during profile swap and setting no longer exists
    return
  end

  if (not (UnitGUID(fieldUnitID) == sourceUnitID and UnitExists(fieldUnitID) and not UnitIsDeadOrGhost(fieldUnitID))) then
    return -- field cannot handle this aura
  end

  return true;
end

-- Objects -----------------------------
---@class TimerBarsModule : BaseModule
local C_TimerBarsModule = MayronUI:RegisterModule("TimerBarsModule", L["Timer Bars"], true); -- initialized on demand
MayronUI:AddModuleComponent("TimerBarsModule", "Database", db);

---@type TimerBarsModule
local timerBarsModule = MayronUI:ImportModule("TimerBarsModule");

---@class TimerField
local C_TimerField = obj:CreateClass("TimerField");
C_TimerField.Static:AddFriendClass("TimerBarsModule");

---@class TimerBar : ITimerBar
local C_TimerBar = obj:CreateClass("TimerBar");
C_TimerBar.Static:AddFriendClass("TimerBarsModule");

---@type Stack
local Stack = obj:Import("Pkg-Collections.Stack<T>");

-- Database: ---------------------------
db:AddToDefaults("profile", {
  enabled               = true;
  sortByExpirationTime  = true;
  showTooltips          = true;
  statusBarTexture      = "MUI_StatusBar";

  border = {
    type = "Skinner";
    size = 1;
    show = true;
  };

  colors = {
    background        = { 0, 0, 0, 0.6 };
    basicBuff         = { 0.1, 0.1, 0.1, 1 };
    basicDebuff       = { 0.76, 0.2, 0.2, 1 };
    border            = { 0, 0, 0, 1 };
    canStealOrPurge   = { 1, 0.5, 0.25, 1 };
    magic             = { 0.2, 0.6, 1, 1 };
    disease           = { 0.6, 0.4, 0, 1 };
    poison            = { 0.0, 0.6, 0, 1 };
    curse             = { 0.6, 0.0, 1, 1 };
  };

  fields = {};

  __templateField = {
    enabled   = true;
    direction = "UP"; -- or "DOWN"
    unitID    = "player";
    position = { "CENTER", "UIParent", "CENTER", 0, 0 },

    bar = {
      width   = 213;
      height  = 22;
      spacing = 2;
      maxBars = 10;
    };

    showIcons             = true;
    showSpark             = true;
    colorDebuffsByType    = true;
    colorStealOrPurge     = true;

    auraName = {
      show        = true;
      fontSize    = 11;
      font        = "MUI_Font";
    };

    timeRemaining = {
      show        = true;
      fontSize    = 11;
      font        = "MUI_Font";
    };

    filters = {
      showBuffs = true;
      showDebuffs = true;
      onlyPlayerBuffs   = true;
      onlyPlayerDebuffs = true;
      enableWhiteList   = false;
      enableBlackList   = false;
      whiteList         = {};
      blackList         = {};
    };
  };
});

db:OnStartUp(function(self)
  _G.MUI_TimerBars.db = self;

  MayronUI:Hook("CoreModule", "OnInitialized", function()
    timerBarsModule:Initialize();
  end);
end);

db:OnProfileChange(function(self)
  if (not MayronUI:IsInstalled()) then
    return;
  end

  timerBarsModule:ApplyProfileSettings();
  timerBarsModule:RefreshSettings();
  timerBarsModule:ExecuteAllUpdateFunctions();
  timerBarsModule:TriggerEvent("OnProfileChange");
end);

-- C_TimerBarsModule --------------------

function C_TimerBarsModule:OnInitialize(data)
  data.loadedFields = obj:PopTable();

  -- create 2 default (removable from database) TimerFields
  data.options = {
    onExecuteAll = {
      first = {}; -- this is updated in ApplyProfileSettings
      ignore = {
        "filters";
      };
    };

    groups = {
      {
        patterns = { "fields%.[^.]+%.[^.]+" }; -- (i.e. "fields.Player.<setting>")

        onPre = function(value, keysList)
          keysList:PopFront();
          local fieldName = keysList:PopFront();
          local field = data.loadedFields[fieldName];
          local settingName = keysList:GetFront();

          -- this is where we create a TimerField if it is enabled
          if (obj:IsBoolean(field)) then
            if (not (field or (settingName == "enabled" and value))) then
              -- if not trying to enable a field because it is disabled, then do not continue
              return nil;
            end

            -- create field (it is enabled)
            field = C_TimerField(fieldName, data.settings);
            data.loadedFields[fieldName] = field; -- replace "true" with real object

            local unitID = field:GetUnitID();
            UnitIDFieldPairs[unitID] = field;
          end

          return field, fieldName;
        end;

        value = {
          ---@param field TimerField
          enabled = function(value, _, field)
            field:SetEnabled(value);
          end;

          ---@param field TimerField
          position = function(_, _, field)
            field:PositionField();
          end;

          ---@param field TimerField
          unitID = function(value, _, field)
            field:SetUnitID(value);
          end;

          ---@param field TimerField
          bar = function(_, _, field, fieldName)
            local fieldSettings = data.settings.fields[fieldName];
            local maxBars = fieldSettings.bar.maxBars;
            local barHeight = fieldSettings.bar.height;
            local barWidth = fieldSettings.bar.width;
            local spacing = fieldSettings.bar.spacing;

            local fieldHeight = (maxBars * (barHeight + spacing)) - spacing;
            field:SetSize(barWidth, fieldHeight);

            for _, bar in obj:IterateArgs(field:GetAllTimerBars()) do
              bar:SetHeight(barHeight);
              bar:SetAuraNameShown(fieldSettings.auraName.show);
              bar:SetIconShown(fieldSettings.showIcons);
            end

            local fieldData = data:GetFriendData(field);
            RepositionBars(fieldData);
          end;

          ---@param field TimerField
          showIcons = function(value, _, field)
            for _, bar in obj:IterateArgs(field:GetAllTimerBars()) do
              bar:SetIconShown(value);
            end
          end;

          ---@param field TimerField
          showSpark = function(value, _, field)
            for _, bar in obj:IterateArgs(field:GetAllTimerBars()) do
              bar:SetSparkShown(value);
            end
          end;

          ---@param field TimerField
          colorDebuffsByType = function(_, _, field)
            field:RecheckAuras();
          end;

          ---@param field TimerField
          auraName = function(_, _, field, fieldName)
            for _, bar in obj:IterateArgs(field:GetAllTimerBars()) do
              bar:SetAuraNameShown(data.settings.fields[fieldName].auraName.show);
            end
          end;

          ---@param field TimerField
          timeRemaining = function(_, _, field, fieldName)
            for _, bar in obj:IterateArgs(field:GetAllTimerBars()) do
              bar:SetTimeRemainingShown(data.settings.fields[fieldName].timeRemaining.show);
            end
          end;

          ---@param field TimerField
          filters = function(_, _, field)
            if (field) then
              field:RecheckAuras();
            end
          end;
        };
      };
    };
  };

  self:ApplyProfileSettings();

  local function UpdateBorders()
    for _, field in pairs(UnitIDFieldPairs) do
      if (not obj:IsBoolean(field)) then
        for _, bar in obj:IterateArgs(field:GetAllTimerBars()) do
          bar:SetBorderShown(data.settings.border.show);
        end
      end
    end
  end

  self:RegisterUpdateFunctions(db.profile, {
    showTooltips = function(value)
      for _, field in pairs(UnitIDFieldPairs) do
        if (not obj:IsBoolean(field)) then
          for _, bar in obj:IterateArgs(field:GetAllTimerBars()) do
            bar:SetTooltipsEnabled(value);
          end
        end
      end
    end;

    statusBarTexture = function(value)
      for _, field in pairs(UnitIDFieldPairs) do
        if (not obj:IsBoolean(field)) then
          for _, bar in obj:IterateArgs(field:GetAllTimerBars()) do
            local barData = data:GetFriendData(bar);
            barData.slider:SetStatusBarTexture(tk.Constants.LSM:Fetch("statusbar", value));
          end
        end
      end
    end;

    colors = function(_, keysList)
      local colorName = keysList:PopBack();

      if (colorName == "border") then
        UpdateBorders();

      elseif (colorName == "background") then
        for _, field in pairs(UnitIDFieldPairs) do
          if (not obj:IsBoolean(field)) then
            for _, bar in obj:IterateArgs(field:GetAllTimerBars()) do
              local barData = data:GetFriendData(bar);
              barData.slider.bg:SetColorTexture(unpack(data.settings.colors.background));
            end
          end
        end
      else
        for _, field in pairs(UnitIDFieldPairs) do
          if (not obj:IsBoolean(field)) then
            field:RecheckAuras();
          end
        end
      end
    end;

    border = UpdateBorders;
  });
end

function C_TimerBarsModule:OnInitialized(data)
  if (data.settings.enabled) then
    self:SetEnabled(true); -- this executes all update functions
  end
end

function C_TimerBarsModule:OnEnable()
  if (not em:GetEventListenerByID("TimerBarsModule_OnCombatLogEvent")) then
    local listener = em:CreateEventListenerWithID("TimerBarsModule_OnCombatLogEvent", OnCombatLogEvent);
    listener:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

    listener = em:CreateEventListenerWithID("TimerBarsModule_CheckUnitAuras", CheckUnitAuras);
    listener:RegisterEvent("PLAYER_ENTERING_WORLD");
  else
    em:EnableEventHandlers("TimerBarsModule_OnCombatLogEvent", "TimerBarsModule_CheckUnitAuras");
  end
end

function C_TimerBarsModule:OnDisable()
  em:DestroyEventListeners("TimerBarsModule_OnCombatLogEvent", "TimerBarsModule_CheckUnitAuras");
end

-- Local Functions -------------------
do
  local SUB_EVENT_NAMES = {
    SPELL_AURA_REFRESH        = "SPELL_AURA_REFRESH";
    SPELL_AURA_APPLIED        = "SPELL_AURA_APPLIED";
    SPELL_AURA_APPLIED_DOSE   = "SPELL_AURA_APPLIED_DOSE";
    SPELL_AURA_REMOVED_DOSE   = "SPELL_AURA_REMOVED_DOSE";
    UNIT_DESTROYED            = "UNIT_DESTROYED";
    UNIT_DIED                 = "UNIT_DIED";
    UNIT_DISSIPATES           = "UNIT_DISSIPATES";
  };

  function OnCombatLogEvent()
    local payload = obj:PopTable(CombatLogGetCurrentEventInfo());
    local subEvent = payload[2];

    if (SUB_EVENT_NAMES[subEvent]) then
      local sourceGuid = payload[4];
      local destGuid = payload[8];

      if (subEvent:find("UNIT")) then
        for unitID, field in pairs(UnitIDFieldPairs) do
          if (not obj:IsBoolean(field)) then
            if (UnitGUID(destGuid) == unitID) then
              field:Hide();
            end
          end
        end
      else
        -- guaranteed to always be the same for all registered events:
        local auraId = payload[12];
        local auraName = payload[13];
        local auraType = payload[15];

        obj:Assert(auraType == BUFF or auraType == DEBUFF, UNKNOWN_AURA_TYPE, auraType);

        ---@param field TimerField
        for unitID, field in pairs(UnitIDFieldPairs) do
          if (not obj:IsBoolean(field) and CanHandleAura(unitID, destGuid)) then
            field:UpdateBarsByAura(sourceGuid, auraId, auraName, auraType);
          end
        end
      end
    end

    obj:PushTable(payload)
  end
end

function CheckUnitAuras()
  for _, field in pairs(UnitIDFieldPairs) do
    if (not obj:IsBoolean(field)) then
      field:RecheckAuras();
    end
  end
end

local GetAuraInfoByAuraID, GetAuraInfoByAuraName;

do
  local function GetAuraInfo(unitID, auraType, index, key)
    local auraInfo, maxAuras, filterName;

    if (auraType == DEBUFF) then
      maxAuras, filterName = DEBUFF_MAX_DISPLAY, HARMFUL;
    elseif (auraType == BUFF) then
      maxAuras, filterName = BUFF_MAX_DISPLAY, HELPFUL;
    end

    for i = 1, maxAuras do
      auraInfo = obj:PopTable(UnitAura(unitID, i, filterName));

      if (#auraInfo > 0 and auraInfo[index] == key) then
        break;
      end

      obj:PushTable(auraInfo);
      auraInfo = nil;
    end

    return auraInfo;
  end

  function GetAuraInfoByAuraID(unitID, auraId, auraType)
    return GetAuraInfo(unitID, auraType, 10, auraId);
  end

  function GetAuraInfoByAuraName(unitID, auraName, auraType)
    return GetAuraInfo(unitID, auraType, 1, auraName);
  end
end

local function CanTrackAura(auraInfo)
  if (not obj:IsTable(auraInfo)) then
    -- some aura's do not return aura info from UnitAura (such as Windfury)
    return false;
  elseif (not (auraInfo[6] and auraInfo[6] > 0)) then
    -- some aura's do not have an expiration time so cannot be added to a timer bar (aura's that are fixed).
    obj:PushTable(auraInfo);
    return false;

  elseif (tk.Constants.FOOD_DRINK_AURAS[tostring(auraInfo[10])]) then
    -- let castbar track food and drink
    obj:PushTable(auraInfo);
    return false;
  end

  return true;
end

local TimerBar_OnClick;

do
  local optionsMenu, insertedFrame;
  local params = obj:PopTable();

  local function OptionSelected_Inner(enableListFieldName, message, listName, printMessage, value)
    local enablePath = ("profile.fields.%s.filters.%s"):format(params.fieldName, enableListFieldName);
    local enabled = db:ParsePathValue(enablePath);
    local subMessage = L["Are you sure you want to do this?"];

    local function onConfirm(self)
      if (self.insertedFrame and self.insertedFrame.btn:GetChecked()) then
        db:SetPathValue(enablePath, true);
      end

      db:SetPathValue(("profile.fields.%s.filters.%s.%s"):format(params.fieldName, listName, params.auraName), value);
      tk:Print(printMessage:format(params.auraName));
      params.timerBar.Remove = true;
      timerBarsModule:RefreshSettings();
    end

    if (not enabled) then
      if (not insertedFrame) then
        insertedFrame = tk:PopFrame("Frame", self);
        insertedFrame:SetSize(200, 30);

        insertedFrame.btn = _G.CreateFrame("CheckButton", nil, insertedFrame, "UICheckButtonTemplate");
        insertedFrame.btn:SetSize(30, 30);
        insertedFrame.btn:SetPoint("LEFT");
        insertedFrame.btn.text:SetFontObject("GameFontHighlight");
        insertedFrame.btn.text:ClearAllPoints();
        insertedFrame.btn.text:SetPoint("LEFT", insertedFrame.btn, "RIGHT", 5, 0);
      end

      insertedFrame.btn.text:SetText(L["Also enable the %s"]:format(listName:lower()));
      insertedFrame.btn:SetChecked(true);
    end

    tk:ShowConfirmPopupWithInsertedFrame(insertedFrame, message, subMessage, onConfirm);
  end

  local function CreateOptionsMenu()
    local options = CreateFrame("Frame", "MUI_TimerBarOptionsMenu", nil, "UIMenuTemplate");
    _G.UIMenu_Initialize(options);

    local function OptionSelected(whitelist)
      local auraNameWithHexColor = tk.Strings:SetTextColorByKey(params.auraName, "GOLD");
      options:Hide();

      if (whitelist) then
        local message = L["Removing %s from the whitelist will hide this timer bar if the whitelist is enabled."]:format(auraNameWithHexColor);
        local printMessage = L["%s has been removed from the whitelist."]:format(auraNameWithHexColor);
        OptionSelected_Inner("enableWhiteList", message, "whiteList", printMessage, nil);
      else
        local message = L["Adding %s to the blacklist will hide this timer bar if the blacklist is enabled."]:format(auraNameWithHexColor);
        local printMessage = L["%s has been added to the blacklist."]:format(auraNameWithHexColor);
        OptionSelected_Inner("enableBlackList", message, "blackList", printMessage, true);
      end
    end

    local optionText = "\124T%s.tga:16:16:0:0\124t %s";
    local blacklistText = string.format(optionText, "Interface\\COMMON\\Indicator-Green", L["Add to Blacklist"]);
    local whitelistText = string.format(optionText, "Interface\\COMMON\\Indicator-Red", L["Remove from Whitelist"]);

        --self, text, shortcut, func, nested, value
    _G.UIMenu_AddButton(options, blacklistText, nil, function() OptionSelected(false) end);
    _G.UIMenu_AddButton(options, whitelistText, nil, function() OptionSelected(true) end);
    _G.UIMenu_AutoSize(options);
    options:Hide();

    return options;
  end

  function TimerBar_OnClick(self, button, timerBar)
    if (button ~= "RightButton") then return; end
    self:GetScript("OnLeave")(self);
    optionsMenu = optionsMenu or CreateOptionsMenu();
    optionsMenu:SetParent(self);
    optionsMenu:SetShown(not optionsMenu:IsShown());

    obj:EmptyTable(params);

    if (optionsMenu:IsShown()) then
      params.auraId = self.auraId;
      params.auraName = self.auraName
      params.fieldName = timerBar.FieldName;
      params.timerBar = timerBar;

      optionsMenu:ClearAllPoints();
      optionsMenu:SetPoint("BOTTOM", self, "TOP");
    end
  end
end

-- C_TimerField ------------------------------

obj:DefineParams("string", "table");
---@param name string @The unit of the field (to be used in the global variable name).
function C_TimerField:__Construct(data, name, sharedSettings)
  data.name = name;
  data.sharedSettings = sharedSettings;
  data.settings = sharedSettings.fields[name];
  data.timeSinceLastUpdate = 0;
  data.activeBars = obj:PopTable();

  ---@type Stack
  data.expiredBarsStack = Stack:Of(C_TimerBar)(); -- this returns a class...

  data.expiredBarsStack:OnNewItem(function()
    return C_TimerBar(sharedSettings, data.settings);
  end);

  data.expiredBarsStack:OnPushItem(function(bar)
    bar.ExpirationTime = -1;
    bar.FieldName = nil;
    bar:SetShown(false);
    bar:SetParent(tk.Constants.DUMMY_FRAME);
  end);

  data.expiredBarsStack:OnPopItem(function(bar, auraId)
    data.barAdded = true; -- needed for controlling OnUpdate
    bar.AuraId = auraId;
    bar.FieldName = name; -- Needed for right click options menu (used in dbPath)
    table.insert(data.activeBars, bar);
  end);
end

obj:DefineReturns("string");
---@return string @The unit name to track that is registered with the TimerField.
function C_TimerField:GetUnitID(data)
  local unitID = data.settings.unitID;

  if (obj:IsString(unitID)) then
    unitID = unitID:lower();
  end

  return unitID;
end

obj:DefineParams("string");
---@param unitID string @Set which unit ID to track.
function C_TimerField:SetUnitID(data, unitID)
  unitID = unitID:lower();
  data.settings.unitID = unitID;

  self:UnregisterAllEvents();
  self:RegisterAllEvents();
  self:RecheckAuras();

  return unitID;
end

obj:DefineParams("boolean");
---@param enabled boolean @Set to true to enable TimerField tracking.
function C_TimerField:SetEnabled(data, enabled)
  if (data.enabled == enabled) then
    return;
  end

  data.enabled = enabled;

  if (not enabled and not data.frame) then
    return;
  end

  if (enabled and not data.frame) then
    data.frame = self:CreateField(data.name);
  end

  data.frame:SetShown(enabled);

  if (not enabled) then
    -- disable:
    data.frame:SetAllPoints(tk.Constants.DUMMY_FRAME);
    data.frame:SetParent(tk.Constants.DUMMY_FRAME);
    data.frame:UnregisterAllEvents();
  else
    -- enable:
    self:PositionField();
    self:SetParent(UIParent);
    self:RegisterAllEvents();
    self:RecheckAuras();
  end
end

do
  local function TimerField_OnEvent(self)
    local unitID = self.field:GetUnitID();

    if (UnitExists(unitID) and not UnitIsDeadOrGhost(unitID)) then
      self.field:Show();
      self.field:RecheckAuras();
    else
      self.field:Hide();
    end
  end

  function C_TimerField:RegisterAllEvents(data)
    local unitID = data.settings.unitID;

    if (unitID == "target") then
      data.frame:RegisterEvent("PLAYER_TARGET_CHANGED");

    elseif (unitID == "targettarget" or unitID == "focustarget") then
      data.frame:RegisterEvent("UNIT_TARGET");

    elseif (unitID == "focus") then
      data.frame:RegisterEvent("PLAYER_FOCUS_CHANGED");
    end

    data.frame.field = self;
    data.frame:SetScript("OnEvent", TimerField_OnEvent);
  end
end

obj:DefineReturns("boolean");
---@return boolean @The enabled state of the TimerField.
function C_TimerField:IsEnabled(data)
  if (obj:IsNil(data.enabled)) then
    return false;
  end

  return data.enabled;
end

---Uses the position config settings to set the field's position on the UIParent.
function C_TimerField:PositionField(data)
  data.frame:ClearAllPoints();

  if (obj:IsTable(data.settings.position)) then
    local point, relativeFrame, relativePoint, xOffset, yOffset = unpack(data.settings.position);

    if (_G[relativeFrame]) then
      data.frame:SetPoint(point, _G[relativeFrame], relativePoint, xOffset, yOffset);
    else
      data.frame:SetPoint("CENTER");
    end
  else
    data.frame:SetPoint("CENTER");
  end
end

do
  ---Rearranges the TimerField active TimerBars after first being sorted by time remaining + bars being removed or added.
  function RepositionBars(data)
    local p = tk.Constants.POINTS;
    local activeBar, previousBarFrame;

    for id = 1, data.settings.bar.maxBars do
      activeBar = data.activeBars[id];

      if (activeBar) then
        activeBar:ClearAllPoints();

        if (data.settings.direction == UP) then
          if (id > 1) then
            previousBarFrame = data.activeBars[id - 1]:GetFrame();
            activeBar:SetPoint(p.BOTTOMLEFT, previousBarFrame, p.TOPLEFT, 0, data.settings.bar.spacing);
            activeBar:SetPoint(p.BOTTOMRIGHT, previousBarFrame, p.TOPRIGHT, 0, data.settings.bar.spacing);
          else
            activeBar:SetPoint(p.BOTTOMRIGHT, data.frame, p.BOTTOMRIGHT, 0, 0);
          end
        elseif (id > 1) then
          previousBarFrame = data.activeBars[id - 1]:GetFrame();
          activeBar:SetPoint(p.TOPLEFT, previousBarFrame, p.BOTTOMLEFT, 0, -data.settings.bar.spacing);
          activeBar:SetPoint(p.TOPRIGHT, previousBarFrame, p.BOTTOMRIGHT, 0, -data.settings.bar.spacing);
        else
          activeBar:SetPoint(p.TOPLEFT, data.frame, p.BOTTOMLEFT, 0, 0);
          activeBar:SetPoint(p.TOPRIGHT, data.frame, p.BOTTOMRIGHT, 0, 0);
        end
      end
    end
  end

  local function SortByExpirationTime(a, b)
    return a.ExpirationTime > b.ExpirationTime;
  end

  obj:DefineParams("string");
  obj:DefineReturns("Frame");
  ---@param name string @The name of the field to create (used as a substring in global frame name)
  ---@return Frame @Returns the created field (a Frame widget)
  function C_TimerField:CreateField(data, name)
    local globalName = tk.Strings:Concat("MUI_", name, "TimerField");
    local frame = CreateFrame("Frame", globalName, nil, _G.BackdropTemplateMixin and "BackdropTemplate");

    local fieldHeight = (data.settings.bar.maxBars * (data.settings.bar.height + data.settings.bar.spacing)) - data.settings.bar.spacing;
    frame:SetSize(data.settings.bar.width, fieldHeight);

    frame:SetScript("OnUpdate", function(_, elapsed)
      data.timeSinceLastUpdate = data.timeSinceLastUpdate + elapsed;

      if (data.timeSinceLastUpdate > TIMER_FIELD_UPDATE_FREQUENCY) then
        local currentTime = GetTime();
        local barRemoved;
        local changed = data.barAdded;

        repeat
          -- Remove expired bars:
          barRemoved = false;
          -- cannot use a new activeBars table (by inserting non-expired bars into it and replacing old table)
          -- because this would reverse the bar order which causes graphical issues if the time remaining of 2 bars is equal.
          for id, activeBar in ipairs(data.activeBars) do
            if (activeBar:UpdateExpirationTime()) then
              changed = true;
            end

            if (activeBar.ExpirationTime < currentTime or activeBar.Remove) then
              data.expiredBarsStack:Push(activeBar); -- remove bar here!
              table.remove(data.activeBars, id);
              barRemoved = true;
              changed = true;
              break;
            end
          end

        until (not barRemoved);

        for _, bar in ipairs(data.activeBars) do
          bar:UpdateTimeRemaining(currentTime);
        end

        if (not changed) then
          return;
        end

        if (#data.activeBars > 0) then
          if (data.sharedSettings.sortByExpirationTime) then
            table.sort(data.activeBars, SortByExpirationTime);
          end

          ---@param bar TimerBar
          for i, bar in ipairs(data.activeBars) do
            if (i <= data.settings.bar.maxBars) then
              -- make visible
              bar:Show();
              bar:SetParent(data.frame);
            else
              -- make invisible
              bar:Hide();
              bar:SetParent(tk.Constants.DUMMY_FRAME);
            end
          end

          RepositionBars(data);
        end

        data.barAdded = nil;
        data.timeSinceLastUpdate = 0;
      end
    end);

    return frame;
  end
end

obj:DefineParams("number");
---@param auraId number @The aura's unique id used to find and remove the aura.
function C_TimerField:RemoveAuraByID(data, auraId)
  for _, activeBar in ipairs(data.activeBars) do
    if (auraId == activeBar.AuraId) then
      activeBar.Remove = true;
    end
  end
end

function C_TimerField:RemoveAllAuras(data)
  for _, activeBar in ipairs(data.activeBars) do
    activeBar.Remove = true;
  end
end

local function IsFilteredOut(filters, sourceGuid, auraName, auraType)
  if (auraType == BUFF and not filters.showBuffs) then
    return true;
  end

  if (auraType == DEBUFF and not filters.showDebuffs) then
    return true;
  end

  if (auraType == BUFF and filters.onlyPlayerBuffs and UnitGUID("player") ~= sourceGuid) then
    return true;
  end

  if (auraType == DEBUFF and filters.onlyPlayerDebuffs and UnitGUID("player") ~= sourceGuid) then
    return true;
  end

  if (filters.enableWhiteList and not filters.whiteList[auraName]) then
    return true;
  end

  if (filters.enableBlackList and filters.blackList[auraName]) then
    return true;
  end

  return false;
end

obj:DefineParams("string", "number", "string", "string");
---@param sourceGuid string @The globally unique identify (GUID) representing the source of the aura (the creature or player who casted the aura).
---@param auraId number @The unique id of the aura used to find and update the aura.
---@param auraName number @The name of the aura used for filtering and updating the TimerBar name.
---@param auraType string @The type of aura (must be either "BUFF" or "DEBUFF").
function C_TimerField:UpdateBarsByAura(data, sourceGuid, auraId, auraName, auraType)
  if (IsFilteredOut(data.settings.filters, sourceGuid, auraName, auraType)) then return end

  ---@type TimerBar
  local foundBar;
  local auraInfo;

  if (auraId > 0) then
    auraInfo = GetAuraInfoByAuraID(data.settings.unitID, auraId, auraType);
  else
    auraInfo = GetAuraInfoByAuraName(data.settings.unitID, auraName, auraType);

    if (obj:IsTable(auraInfo)) then
      auraId = auraInfo[10];
    end
  end

  if (not CanTrackAura(auraInfo)) then return end

  -- first try to search for an existing one:
  for _, activeBar in ipairs(data.activeBars) do
    if (auraId == activeBar.AuraId) then
      foundBar = activeBar;
      break;
    end
  end

  if (not foundBar) then
    -- create a new timer bar
    foundBar = data.expiredBarsStack:Pop(auraId);
  end

  -- update expiration time outside of UpdateAura!
  foundBar.AuraType = auraType;
  foundBar.Remove = nil;

  foundBar:UpdateAura(auraInfo);
end

---Rechecks whether auras are still in use by the unit
function C_TimerField:RecheckAuras(data)
  local maxAuras, filterName, auraType;

  self:RemoveAllAuras();

  for a = 1, 2 do
    if (a == 1) then
      maxAuras, filterName, auraType = BUFF_MAX_DISPLAY, HELPFUL, BUFF;
    elseif (a == 2) then
      maxAuras, filterName, auraType = DEBUFF_MAX_DISPLAY, HARMFUL, DEBUFF;
    end

    for i = 1, maxAuras do
      --local auraInfo = GetAuraInfoByAuraID(data.settings.unitID, i, auraType);
      local auraInfo = obj:PopTable(UnitAura(data.settings.unitID, i, filterName));

      if (CanTrackAura(auraInfo)) then
        local auraName = auraInfo[1];
        local auraId = auraInfo[10];
        local sourceUnit = auraInfo[7]; -- classic returns nil

        if (obj:IsNumber(auraId)) then
          local sourceGuid = sourceUnit and UnitGUID(sourceUnit) or "Unknown";

          if (CanHandleAura(data.settings.unitID, sourceGuid)) then
            self:UpdateBarsByAura(sourceGuid, auraId, auraName, auraType);
          end
        end

        obj:PushTable(auraInfo);
      end
    end
  end
end

obj:DefineReturns("?TimerBar");
---@return table @A table containing all active, and non-active, timer bars.
function C_TimerField:GetAllTimerBars(data)
  local allBars = obj:PopTable();

  if (not tk.Tables:IsEmpty(data.activeBars)) then
    tk.Tables:AddAll(allBars, unpack(data.activeBars));
  end

  local stack = data.expiredBarsStack; ---@type Stack

  if (not stack:IsEmpty()) then
    tk.Tables:AddAll(allBars, stack:Unpack());
  end

  if (tk.Tables:IsEmpty(allBars)) then
    obj:PushTable(allBars);
    return
  end

  return obj:UnpackTable(allBars);
end

-- C_TimerBar ---------------------------

obj:DefineParams("table", "table");
---@param settings table @The config settings table.
---@param auraId number @The unique id of the aura used to find and update the aura.
function C_TimerBar:__Construct(data, sharedSettings, settings)

  -- fields
  self.AuraId = -1;
  self.ExpirationTime = -1;

  data.settings = settings;
  data.sharedSettings = sharedSettings;

  data.frame = CreateFrame("Button", nil, nil, _G.BackdropTemplateMixin and "BackdropTemplate");
  data.frame:SetSize(settings.bar.width, settings.bar.height);
  data.frame:RegisterForClicks("RightButtonUp");

  data.slider = CreateFrame("StatusBar", nil, data.frame);
  data.slider:SetStatusBarTexture(tk.Constants.LSM:Fetch("statusbar", sharedSettings.statusBarTexture));
  data.slider.bg = tk:SetBackground(data.slider, unpack(sharedSettings.colors.background));
  data.frame.slider = data.slider;

  self:SetIconShown(settings.showIcons);
  self:SetBorderShown(sharedSettings.border.show);
  self:SetSparkShown(settings.showSpark);
  self:SetAuraNameShown(settings.auraName.show);
  self:SetTimeRemainingShown(settings.timeRemaining.show);
  self:SetTooltipsEnabled(sharedSettings.showTooltips);

  data.frame:SetScript("OnClick", function(frame, button)
    TimerBar_OnClick(frame, button, self, data);
  end);
end

obj:DefineParams("boolean");
---@param shown boolean @Set to true to show the timer bar icon.
function C_TimerBar:SetIconShown(data, shown)
  if (not data.iconFrame and not shown) then
    return;
  end

  if (shown) then
    if (not data.iconFrame) then
      data.iconFrame = CreateFrame("Frame", nil, data.frame, _G.BackdropTemplateMixin and "BackdropTemplate");

      data.icon = data.iconFrame:CreateTexture(nil, "ARTWORK");
      data.icon:SetTexCoord(0.1, 0.92, 0.08, 0.92);
    end

    local barWidthWithIcon = data.settings.bar.width - data.settings.bar.height - ICON_GAP;
    data.frame:SetWidth(barWidthWithIcon);
    data.iconFrame:SetWidth(data.settings.bar.height);
  else
    data.frame:SetWidth(data.settings.bar.width);
  end

  data.iconFrame:SetShown(shown);
end

do
  local function SetWidgetBorderSize(widget, borderSize)
    widget:ClearAllPoints();
    widget:SetPoint("TOPLEFT", borderSize, -borderSize);
    widget:SetPoint("TOPRIGHT", -borderSize, -borderSize);
    widget:SetPoint("BOTTOMLEFT", borderSize, borderSize);
    widget:SetPoint("BOTTOMRIGHT", -borderSize, borderSize);
  end

  obj:DefineParams("boolean");
  ---@param shown boolean @Set to true to show borders.
  function C_TimerBar:SetBorderShown(data, shown)
    if (not data.backdrop and not shown) then
      return;
    end

    local borderSize = 0; -- must be 0 in case it needs to be disabled

    if (shown) then
      if (not data.backdrop) then
        data.backdrop = obj:PopTable();
      end

      local borderType = data.sharedSettings.border.type;
      local borderColor = data.sharedSettings.colors.border;
      borderSize = data.sharedSettings.border.size;

      data.backdrop.edgeFile = tk.Constants.LSM:Fetch("border", borderType);
      data.backdrop.edgeSize = borderSize;

      data.frame:SetBackdrop(data.backdrop);
      data.frame:SetBackdropBorderColor(unpack(borderColor));

      if (data.iconFrame) then
        data.iconFrame:SetBackdrop(data.backdrop);
        data.iconFrame:SetBackdropBorderColor(unpack(borderColor));
      end
    else
      data.frame:SetBackdrop(nil);
      data.iconFrame:SetBackdrop(nil);
    end

    SetWidgetBorderSize(data.slider, borderSize);

    if (data.iconFrame and data.settings.showIcons) then
      data.iconFrame:SetPoint("TOPRIGHT", data.frame, "TOPLEFT", -(borderSize * 2) - ICON_GAP, 0);
      data.iconFrame:SetPoint("BOTTOMRIGHT", data.frame, "BOTTOMLEFT", -(borderSize * 2) - ICON_GAP, 0);
      SetWidgetBorderSize(data.icon, borderSize);

      local barWidthWithIconAndBorder = data.frame:GetWidth() - (borderSize * 2);
      data.frame:SetWidth(barWidthWithIconAndBorder);
    end
  end
end

obj:DefineParams("boolean");
---@param shown boolean @Set to true to show the timer bar spark effect.
function C_TimerBar:SetSparkShown(data, shown)
  if (not data.spark and not shown) then
    return;
  end

  if (not data.spark) then
    data.spark = data.slider:CreateTexture(nil, "OVERLAY");
    data.spark:SetSize(26, 50);
    data.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark");

    local r, g, b = tk:GetThemeColor();
    data.spark:SetVertexColor(r, g, b);
    data.spark:SetBlendMode("ADD");
  end

  data.spark:SetShown(shown);
  data.showSpark = shown;
end

obj:DefineParams("boolean");
---@param shown boolean @Set to true to show the timer bar aura name.
function C_TimerBar:SetAuraNameShown(data, shown)
  if (not data.auraName and not shown) then
    return;
  end

  if (not data.auraName) then
    data.auraName = data.slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    data.auraName:SetPoint("LEFT", 4, 0);
    data.auraName:SetJustifyH("LEFT");
    data.auraName:SetWordWrap(false);
  end

  local font = tk.Constants.LSM:Fetch("font", data.settings.auraName.font);
  data.auraName:SetFont(font, data.settings.auraName.fontSize);

  data.auraName:SetWidth(data.settings.bar.width - data.settings.bar.height - 50);
  data.auraName:SetShown(shown);
end

obj:DefineParams("boolean");
---@param shown boolean @Set to true to show the timer bar's time remaining text.
function C_TimerBar:SetTimeRemainingShown(data, shown)
  if (not data.timeRemaining and not shown) then
    return;
  end

  if (not data.timeRemaining) then
    data.timeRemaining = data.slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    data.timeRemaining:SetPoint("RIGHT", -4, 0);
  end

  local font = tk.Constants.LSM:Fetch("font", data.settings.timeRemaining.font);
  data.timeRemaining:SetFont(font, data.settings.timeRemaining.fontSize);
  data.timeRemaining:SetShown(shown);
end

obj:DefineParams("boolean");
---@param shown boolean @Set to true to show the aura tooltip on mouse over.
function C_TimerBar:SetTooltipsEnabled(data, enabled)
  if (enabled) then
    tk:SetAuraTooltip(data.frame);
  else
    data.frame:SetScript("OnEnter", tk.Constants.DUMMY_FUNC);
    data.frame:SetScript("OnLeave", tk.Constants.DUMMY_FUNC);
  end
end

obj:DefineParams("number", "?number");
---@param currentTime number @The current time using GetTime.
function C_TimerBar:UpdateTimeRemaining(data, currentTime)
  local timeRemaining = self.ExpirationTime - currentTime;

  -- duration should have been checked in the frame OnUpdate script
  -- Update: During a big 40 vs 40 PVP battleground, this condition failed!
  -- obj:Assert(timeRemaining >= 0);

  if (timeRemaining < 0) then
    return; -- Let OnUpdate Script remove it!
  end

  if (self.TotalDuration) then
    -- Called from UpdateAura
    data.slider:SetMinMaxValues(0, self.TotalDuration);
  end

  data.slider:SetValue(timeRemaining);

  if (data.showSpark) then
    local _, max = data.slider:GetMinMaxValues();
    local offset = data.spark:GetWidth() / 2;
    local barWidth = data.slider:GetWidth();
    local value = (timeRemaining / max) * barWidth - offset;

    if (value > barWidth - offset) then
      value = barWidth - offset;
    end

    data.spark:SetPoint("LEFT", value, 0);
  end

  if (not data.timeRemaining) then
    return;
  end

  local timeRemainingText = tk.Numbers:ToPrecision(timeRemaining, 1);

  if (data.timeRemainingText ~= timeRemainingText) then
    data.timeRemainingText = timeRemainingText;

    if (timeRemainingText > 3600) then
      timeRemainingText = date("%H:%M:%S", timeRemainingText);

    elseif (timeRemainingText > 60) then
      timeRemainingText = date("%M:%S", timeRemainingText);
    end

    -- this hogs memory so need to reduce the calls to it:
    data.timeRemaining:SetText(timeRemainingText);
  end
end

obj:DefineParams("table");
---@param auraInfo table @A table containing a subset of the results from UnitAura.
function C_TimerBar:UpdateAura(data, auraInfo)
  local auraName        = auraInfo[1];
  local iconPath        = auraInfo[2];
  local amount          = auraInfo[3];
  local debuffType      = auraInfo[4];
  local canStealOrPurge = auraInfo[8];

  obj:PushTable(auraInfo);

  -- this is needed for the tooltip mouse over + right click menu
  data.frame.auraId = self.AuraId;
  data.frame.auraName = auraName;

  if (data.icon) then
    data.icon:SetTexture(iconPath);
  end

  if (amount > 1) then
    data.auraName:SetText(auraName .. " (" .. amount  .. ")");
  else
    data.auraName:SetText(auraName);
  end

  if (data.settings.colorStealOrPurge and canStealOrPurge) then
    data.slider:SetStatusBarColor(unpack(data.sharedSettings.colors.canStealOrPurge));
  else
    if (self.AuraType == BUFF) then
      data.slider:SetStatusBarColor(unpack(data.sharedSettings.colors.basicBuff));

    elseif (self.AuraType == DEBUFF) then
      if (data.settings.colorDebuffsByType and obj:IsString(debuffType)) then
        data.slider:SetStatusBarColor(unpack(data.sharedSettings.colors[string.lower(debuffType)]));
      else
        data.slider:SetStatusBarColor(unpack(data.sharedSettings.colors.basicDebuff));
      end
    end
  end
end

obj:DefineReturns("boolean");
function C_TimerBar:UpdateExpirationTime(data)
  local auraInfo = GetAuraInfoByAuraID(data.settings.unitID, self.AuraId, self.AuraType);
  local old = self.ExpirationTime;

  if (obj:IsTable(auraInfo)) then
    self.TotalDuration = auraInfo[5];
    self.ExpirationTime = auraInfo[6];
  else
    self.ExpirationTime = -1;
  end

  obj:PushTable(auraInfo);

  return (old ~= self.ExpirationTime);
end

function C_TimerBarsModule:ApplyProfileSettings(data)

  if (db:GetCurrentProfile() == "Healer") then
    -- Healer Layout/Profile
    db:AppendOnce(db.profile, nil, "defaultFields", {
      fieldNames = {
        "Player";
      };
      fields = {
        Player = {
          position = { "BOTTOMLEFT", "MUI_PlayerName", "TOPLEFT", 10, 2 },
          unitID = "player";
        };
      };
    });
  else
    -- DPS Layout/Default Profile
    db:AppendOnce(db.profile, nil, "defaultFields", {
      fieldNames = {
        "Player";
        "Target";
      };
      fields = {
        Player = {
          position = { "BOTTOMLEFT", "MUI_PlayerName", "TOPLEFT", 10, 2 },
          unitID = "player";
        };
        Target = {
          position = { "BOTTOMRIGHT", "MUI_TargetName", "TOPRIGHT", -10, 2 },
          unitID = "target";
        };
      };
    });
  end

  if (obj:IsObject(db.profile.fieldNames)) then
    for _, fieldName in db.profile.fieldNames:Iterate() do
      local sv = db.profile.fields[fieldName];
      sv:SetParent(nil); -- remove before comparison
    end
  end

  tk.Tables:Empty(data.options.onExecuteAll.first);

  if (obj:IsObject(db.profile.fieldNames)) then
    for _, fieldName in db.profile.fieldNames:Iterate() do
      local sv = db.profile.fields[fieldName];
      sv:SetParent(db.profile.__templateField);

      if (not obj:IsObject(data.loadedFields[fieldName])) then
        data.loadedFields[fieldName] = sv.enabled;
      end

      if (sv.enabled) then
        table.insert(data.options.onExecuteAll.first, tk.Strings:Concat("fields.", fieldName, ".", "enabled"));
      end
    end

    -- disable fields that are removed in the current profile but are active (previous profile uses them):
    for fieldName, field in pairs(data.loadedFields) do
      if (not db.profile.fields[fieldName] and obj:IsObject(field)) then
        field:SetEnabled(false);
      end
    end
  end
end