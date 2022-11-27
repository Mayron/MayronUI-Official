-- luacheck: ignore MayronUI LibStub self 143 631
local _G = _G;
local MayronUI = _G.MayronUI; ---@type MayronUI
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents();

local table, ipairs, pairs, select, string, unpack, print = _G.table, _G.ipairs,
  _G.pairs, _G.select, _G.string, _G.unpack, _G.print;
local IsAddOnLoaded, EnableAddOn, LoadAddOn, DisableAddOn, ReloadUI =
  _G.IsAddOnLoaded, _G.EnableAddOn, _G.LoadAddOn, _G.DisableAddOn, _G.ReloadUI;
local strsplit, tostring = _G.strsplit, _G.tostring;
local collectgarbage = _G.collectgarbage;
local InCombatLockdown = _G.InCombatLockdown;
local FillLocalizedClassList, UnitName = _G.FillLocalizedClassList, _G.UnitName;

---@class BaseModule : Object
local BaseModule = obj:CreateClass("BaseModule");
obj:Export(BaseModule, "MayronUI");

-- Load Database Defaults -------------

db:AddToDefaults("global", {
  layouts = {
    DPS = { ["ShadowUF"] = "MayronUI"; ["MUI TimerBars"] = "Default" };
    Healer = { ["ShadowUF"] = "MayronUIH"; ["MUI TimerBars"] = "Healer" };
  };

  core = {
    uiScale = 0.7;
    maxCameraZoom = true;
    useLocalization = true;

    fonts = {
      master = "MUI_Font";
      useMasterFont = true;

      combat = "Prototype";
      useCombatFont = true;
    };

    setup = {
      profilePerCharacter = true;
      resetChatSettings = true;
      addOns = {
        { "Bagnon"; true; "Bagnon", 1 };
        { "Bartender4"; true; "Bartender4", 1 };
        { "Masque"; true; "Masque", 1 };
        { "Shadowed Unit Frames"; true; "ShadowedUnitFrames", 1 };
      };
    };
  };
});

db:AddToDefaults("profile.layout", "DPS");

local classColor = tk:GetClassColorByUnitID("player");
db:AddToDefaults("profile.theme", {
  color = {
    r = classColor.r;
    g = classColor.g;
    b = classColor.b;
    hex = classColor:GenerateHexColor();
  };
});

-- Slash Commands ------------------

local function LoadMuiAddOn(name)
  if (not IsAddOnLoaded(name)) then
    EnableAddOn(name);

    if (not LoadAddOn(name)) then
      tk:Print(string.format("Failed to load %s. Possibly missing?", name));
      return false;
    end
  end

  return true;
end

local function GetMuiConfigModule()
  if (not LoadMuiAddOn("MUI_Config")) then
    return;
  end
  local configModule = MayronUI:ImportModule("ConfigMenu");

  if (not configModule:IsInitialized()) then
    configModule:Initialize();
  end

  return configModule;
end

local commands = {};

commands.config = function()
  if (InCombatLockdown()) then
    tk:Print(L["Cannot access config menu while in combat."]);
  else
    local module = GetMuiConfigModule()

    if (module) then
      module:Show();
    end
  end
end

commands.layouts = function()
  if (not LoadMuiAddOn("MUI_Config")) then
    return;
  end
  local layoutSwitcher = MayronUI:ImportModule("LayoutSwitcher");
  layoutSwitcher:ShowLayoutTool();
end

commands.install = function()
  if (not LoadMuiAddOn("MUI_Setup")) then
    return;
  end
  MayronUI:ImportModule("SetUpModule"):Show();
end

commands.report = function(forceShow)
  if (not LoadMuiAddOn("MUI_Setup")) then
    return
  end
  local reportIssue = MayronUI:ImportModule("ReportIssue"); ---@type C_ReportIssue

  if (not reportIssue:IsInitialized()) then
    reportIssue:Initialize();
  elseif (forceShow) then
    reportIssue:Show();
  else
    reportIssue:Toggle();
  end

  local errorHandlerModule = MayronUI:ImportModule("ErrorHandlerModule"); ---@type C_ErrorHandler
  local errors = errorHandlerModule:GetErrors();
  reportIssue:SetErrors(errors);
end

local function ValidateNewProfileName(_, profileName)
  if (#profileName == 0 or db:ProfileExists(profileName)) then
    return false;
  end

  return true;
end

local function CreateNewProfile(_, profileName, callback)
  db:SetProfile(profileName);

  if (obj:IsFunction(callback)) then
    callback();
  end
end

local function ValidateRemoveProfile(_, text)
  if (db:GetCurrentProfile() == "Default") then
    return false;
  end

  return text == L["DELETE"];
end

local function RemoveProfile(_, _, profileName, callback)
  db:RemoveProfile(profileName);
  tk:Print(
    "Profile", tk.Strings:SetTextColorByKey(profileName, "gold"),
      "has been deleted.");

  local playerKey = tk:GetPlayerKey();
  if (db.global.core.setup.profilePerCharacter and db:ProfileExists(playerKey)) then
    db:SetProfile(playerKey);
  end

  if (obj:IsFunction(callback)) then
    callback();
  end
end

commands.profile = function(subCommand, profileName, callback)
  if (not tk.Strings:IsNilOrWhiteSpace(subCommand)) then
    subCommand = subCommand:lower();

    if (subCommand == "set" and not tk.Strings:IsNilOrWhiteSpace(profileName)) then
      db:SetProfile(profileName);

    elseif (subCommand == "delete"
      and not tk.Strings:IsNilOrWhiteSpace(profileName)) then
      if (profileName == "Default") then
        tk:Print(L["Cannot delete the Default profile."]);
        return;
      end

      local popupMessage = string.format(
                             L["Are you sure you want to delete profile '%s'?"],
                               profileName);

      local subMessage = string.format(
                           L["Please type '%s' to confirm:"], L["DELETE"]);

      tk:ShowInputPopup(
        popupMessage, subMessage, nil, ValidateRemoveProfile, nil,
          RemoveProfile, nil, nil, true, profileName, callback);

    elseif (subCommand == "new") then
      local popupMessage = L["Enter a new unique profile name:"];
      tk:ShowInputPopup(
        popupMessage, nil, nil, ValidateNewProfileName, nil, CreateNewProfile,
          nil, nil, nil, callback);

    elseif (subCommand == "current") then
      local currentProfile = db:GetCurrentProfile();
      currentProfile = tk.Strings:SetTextColorByKey(currentProfile, "gold");
      tk:Print(L["Current Profile:"], currentProfile);
    else
      commands.help();
    end

  else
    commands.help();
  end
end

commands.profiles = function(subCommand)
  if (not tk.Strings:IsNilOrWhiteSpace(subCommand)) then
    subCommand = subCommand:lower();

    if (subCommand == "list") then
      local allProfiles = tk.Strings.Empty;

      for id, profile in db:IterateProfiles() do
        if (id == 1) then
          allProfiles = tk.Strings:SetTextColorByKey(profile, "gold");
        else
          allProfiles = tk.Strings:Join(
            ", ", allProfiles, tk.Strings:SetTextColorByKey(profile, "gold"));
        end
      end

      tk:Print("All Profiles:", allProfiles);
    else
      commands.help();
    end

  else
    GetMuiConfigModule():ShowProfileManager();
  end
end

commands.version = function()
  tk:Print("Version:", tk:GetVersion("YELLOW"));
end

-- aliases
commands.i = commands.install;
commands.c = commands.config;
commands.v = commands.version;
commands.r = commands.report;
commands.l = commands.layouts;

commands.help = function()
  print(" ");
  tk:Print(L["List of slash commands:"])
  tk:Print(
    "|cff00cc66/mui config, /mui c|r - " .. L["Show the MUI Config Menu"]:lower());
  tk:Print(
    "|cff00cc66/mui install, /mui i|r - " .. L["Show the MUI Installer"]:lower());
  tk:Print(
    "|cff00cc66/mui layouts, /mui l|r - "
      .. L["Show the MUI Layout Tool"]:lower());
  tk:Print(
    "|cff00cc66/mui profiles list|r - " .. L["List All Profiles"]:lower());
  tk:Print(
    "|cff00cc66/mui profiles|r - " .. L["Show the MUI Profile Manager"]:lower());
  tk:Print(
    "|cff00cc66/mui profile set <profile_name>|r - " .. L["Set Profile"]:lower());
  tk:Print(
    "|cff00cc66/mui profile delete <profile_name>|r - "
      .. L["Delete Profile"]:lower());
  tk:Print(
    "|cff00cc66/mui profile new|r - " .. L["Create a new profile"]:lower());
  tk:Print(
    "|cff00cc66/mui profile current|r - "
      .. L["Show Currently Active Profile"]:lower());
  tk:Print(
    "|cff00cc66/mui version, /mui v|r - " .. L["Show the Version of MUI"]:lower());
  tk:Print("|cff00cc66/mui report, /mui r|r - " .. L["Report Issue"]:lower());
  print(" ");
end

local registeredModules = {};

-- BaseModule Object -------------------

obj:DefineParams("string", "?string", "?boolean");
---Should only be called by the register module method!
---@param moduleKey string @The key used to register the module to MayronUI.
---@param moduleName string @The human-friendly name of the module to be used in-game (such as on the config window).
---@param initializeOnDemand boolean @(optional) If true, the module will not be initialized on start up automatically and can only be initialized by manually calling "Initialize()" on the module.
function BaseModule:__Construct(data, moduleKey, moduleName, initializeOnDemand)
  local registryInfo = registeredModules[moduleKey];
  registeredModules[tostring(self)] = registryInfo;

  registryInfo.moduleName = moduleName or moduleKey;
  registryInfo.moduleKey = moduleKey;
  registryInfo.initializeOnDemand = initializeOnDemand;
  registryInfo.initialized = false;
  registryInfo.enabled = false;
  registryInfo.moduleData = data;
  registryInfo.instance = self;

  -- Make it easy to iterate through modules
  table.insert(registeredModules, self);
end

---Initialize the module manually (on demand) or is called by MayronUI on startup.
function BaseModule:Initialize(_, ...)
  if (self:IsInitialized()) then
    return
  end

  if (self.OnInitialize) then
    self:OnInitialize(...);
  end

  local registryInfo = registeredModules[tostring(self)];
  registryInfo.initialized = true;

  -- Call any other functions attached to this modules OnInitialize event
  if (registryInfo.hooks and registryInfo.hooks.OnInitialize) then
    for _, func in ipairs(registryInfo.hooks.OnInitialize) do
      func(self, registryInfo.moduleData);
    end
  end

  if (self.OnInitialized) then
    self:OnInitialized();
  end

  -- Call any other functions attached to this modules OnInitialized event
  if (registryInfo.hooks and registryInfo.hooks.OnInitialized) then
    for _, func in ipairs(registryInfo.hooks.OnInitialized) do
      func(self, registryInfo.moduleData);
    end
  end
end

obj:DefineReturns("string");
---@return string @Returns the human-friendly name of the module to be used in-game (such as on the config window).
function BaseModule:GetModuleName(_)
  local registryInfo = registeredModules[tostring(self)];
  return registryInfo.moduleName;
end

obj:DefineReturns("string");
---@return string @Returns the key used to register the module to MayronUI.
function BaseModule:GetModuleKey(_)
  local registryInfo = registeredModules[tostring(self)];
  return registryInfo.moduleKey;
end

obj:DefineParams("boolean");
---@param enabled boolean
function BaseModule:SetEnabled(data, enabled, ...)
  local registryInfo = registeredModules[tostring(self)];
  local hooks;

  registryInfo.enabled = enabled;

  if (data.settings) then
    -- do not need to manually create an enabled update function to change this!
    data.settings.enabled = enabled;
  end

  if (enabled) then
    if (self.OnEnable) then
      self:OnEnable(...);
    end

    if (data.updateFunctions) then
      self:ExecuteAllUpdateFunctions();
    end

    if (self.OnEnabled) then
      self:OnEnabled(...);
    end

    -- Call any other functions attached to this modules OnEnable event
    hooks = registryInfo.hooks and registryInfo.hooks.OnEnable;
  else
    if (self.OnDisable) then
      self:OnDisable(...);
    end

    -- Call any other functions attached to this modules OnDisable event
    hooks = registryInfo.hooks and registryInfo.hooks.OnDisable;
  end

  if (hooks) then
    for _, func in ipairs(hooks) do
      func(self, data);
    end
  end
end

obj:DefineReturns("boolean");
---@return boolean @Returns true if the module has already been initialized.
function BaseModule:IsInitialized()
  local registryInfo = registeredModules[tostring(self)];
  return registryInfo.initialized;
end

obj:DefineReturns("boolean");
---Returns whether the module should be initialized automatically on start up or manually.
---@return boolean @If true, the module should be initialized on demand (manually) when required.
function BaseModule:IsInitializedOnDemand()
  local registryInfo = registeredModules[tostring(self)];
  return registryInfo.initializeOnDemand == true;
end

obj:DefineReturns("boolean");
---@return boolean @Returns true if the module is enabled.
function BaseModule:IsEnabled()
  local registryInfo = registeredModules[tostring(self)];
  return registryInfo.enabled;
end

---Hook more functions to a module event. Useful if module is spread across multiple files
function BaseModule:Hook(_, eventName, func)
  local registryInfo = registeredModules[tostring(self)];
  MayronUI:Hook(registryInfo.moduleName, eventName, func);
end

function BaseModule:TriggerEvent(_, eventName, ...)
  local registryInfo = registeredModules[tostring(self)];
  local hooks = registryInfo.hooks and registryInfo.hooks[eventName];

  if (self[eventName]) then
    self[eventName](self, ...);
  end

  if (hooks) then
    for _, func in ipairs(hooks) do
      func(self, registryInfo.moduleData);
    end
  end
end

function BaseModule:RefreshSettings(data)
  if (data.settings) then
    data.settings:Refresh();
  end
end

-- MayronUI Functions ---------------------

---A helper function to print a table's contents using the MayronUI prefix in the chat frame.
---@param tbl table @The table to print.
---@param depth number @The depth of sub-tables to traverse through and print (defaults to 1).
---@param spaces number @The number of spaces used for nested values inside a table (defaults to 2).
function MayronUI:PrintTable(tbl, depth, spaces)
  tk:Assert(obj:IsTable(tbl), "bad argument #1 (table expected, got %s)", type(tbl));
  tk.Tables:Print(tbl, depth or 1, spaces);
end

function MayronUI:PrintTableKeys(tbl, perRow)
  local keys = {};
  perRow = perRow or 3;

  for key, _ in pairs(tbl) do
    keys[#keys + 1] = key;
  end

  for i = 1, #keys, perRow do
    print(keys[i], ", ", keys[i+1], ", ", keys[i+2])
  end
end

function MayronUI:ShowReloadUIPopUp()
  tk:ShowConfirmPopup(
    L["Some settings will not be changed until the UI has been reloaded."],
    L["Would you like to reload the UI now?"], L["Reload UI"], ReloadUI,
    L["No"], nil, true);
end

---A helper function to print a variable argument list using the MayronUI prefix in the chat frame.
function MayronUI:Print(...)
  tk:Print(...);
end

---@return boolean @Returns true if MayronUI has been previously installing (usually using MUI_Setup).
function MayronUI:IsInstalled()
  return db.global.installed and db.global.installed[tk:GetPlayerKey()];
end

---@param commandName string @Trigger a MayronUI registered slash command (can optionally pass in arguments)
function MayronUI:TriggerCommand(commandName, ...)
  commandName = commandName:lower();
  obj:Assert(commands[commandName], "Unknown command name '%s'", commandName);
  local func = commands[commandName];

  if (obj:IsTable(func)) then
    local args = func[2];
    func = func[1];

    if (select("#", ...) > 0) then
      args = tk.Tables:Copy(args, true);
      tk.Tables:AddAll(args, ...);
      func(obj:UnpackTable(args));
    else
      func(unpack(args));
    end
  else
    func(...);
  end
end

---@param commandName string @The name of the command to register.
---@param func function @The command handler function to register.
function MayronUI:RegisterCommand(commandName, func, ...)
  commandName = commandName:lower();
  obj:Assert(not commands[commandName], "Command already exists: '%s'", commandName);

  if (select("#", ...) > 0) then
    commands[commandName] = { func, { ... } };
  else
    commands[commandName] = func;
  end

  return func;
end

---Hook more functions to a module event. Useful if module is spread across multiple files.
---@param moduleKey string @The unique key associated with the registered module.
---@param eventName string @The name of the module event to hook (i.e. "OnInitialize", "OnEnable", etc...).
---@param func function @A callback function to execute when the module's event is triggered.
function MayronUI:Hook(moduleKey, eventName, func)
  local eventHooks = tk.Tables:GetTable(registeredModules, moduleKey, "hooks", eventName);
  table.insert(eventHooks, func);
end

---@param moduleKey string @The unique key associated with the registered module.
---@return Class @Returns a module Class so that a module can be given additional methods and definitions where required.
function MayronUI:GetModuleClass(moduleKey)
  local registryInfo = registeredModules[moduleKey];

  if (not registryInfo) then
    -- addon is disabled so cannot import module
    return nil;
  end

  return registryInfo.class;
end

---@param moduleKey string @The unique key associated with the registered module.
---@param silent boolean @If silent, this function will return nil if the module cannot be found, else it will throw an error
function MayronUI:ImportModule(moduleKey, silent)
  local registryInfo = registeredModules[moduleKey];

  if (not registryInfo) then
    -- addon is disabled so cannot import module
    obj:Assert(silent, "Failed to import module '%s'. Has it been registered?", moduleKey);
    return nil;
  end

  return registryInfo.instance, registryInfo.class;
end

---MayronUI automatically initializes modules during the "PLAYER_ENTERING_WORLD" event unless initializeOnDemand is true.
---@param moduleKey string @A unique key used to register the module to MayronUI.
---@param moduleName string @A human-friendly name of the module to be used in-game (such as on the config window).
---@param initializeOnDemand boolean @(optional) If true, must be initialized manually instead of
---@return Class @Returns a new module Class so that a module can be given additional methods and definitions where required.
function MayronUI:RegisterModule(moduleKey, moduleName, initializeOnDemand)
  local moduleClass = obj:CreateClass(moduleKey, BaseModule);

  -- must add it to the registeredModules table before calling parent constructor!
  registeredModules[moduleKey] = registeredModules[moduleKey] or obj:PopTable();
  registeredModules[moduleKey].class = moduleClass;

  moduleClass(moduleKey, moduleName, initializeOnDemand);

  return moduleClass;
end

---@return fun(): number, BaseModule @An iterator function to iterate through registered modules.
function MayronUI:IterateModules()
  local id = 0;

  return function()
    id = id + 1;
    if (id <= #registeredModules) then
      return id, registeredModules[id];
    end
  end
end

function MayronUI:GetModules()
  local moduleList = obj:PopTable();

  for _, module in MayronUI:IterateModules() do
    table.insert(moduleList, module);
  end

  return moduleList;
end

function MayronUI:GetModuleNames()
  local moduleNamesList = obj:PopTable();

  for _, module in MayronUI:IterateModules() do
    table.insert(moduleNamesList, module:GetModuleName());
  end

  return moduleNamesList;
end

function MayronUI:GetModuleKeys()
  local moduleKeysList = obj:PopTable();

  for _, module in MayronUI:IterateModules() do
    table.insert(moduleKeysList, module:GetModuleKey());
  end

  return moduleKeysList;
end

function MayronUI:SwitchLayouts(layoutName, layoutData)
  if (InCombatLockdown()) then
    tk:Print(L["Cannot switch layouts while in combat."]);
    return;
  end

  db.profile.layout = layoutName;

  if (not obj:IsTable(layoutData)) then
    local layouts = db.global.layouts:GetUntrackedTable();
    layoutData = layouts[layoutName];
  end

  -- should never happen but someone reported it without a way to replicate
  if (not obj:IsTable(layoutData)) then
    layoutData = obj:PopTable();
    db.global.layouts[layoutName] = layoutData;
  end

  -- Switch all assigned addons to new profile
  for a, profileName in pairs(layoutData) do
    if (profileName) then
      -- profileName could be false
      local dbObject = tk.Tables:GetDBObject(a);

      if (dbObject) then
        dbObject:SetProfile(profileName);
      end
    end
  end
end

local function InstallPresetOnClick(_, addonId)
  db.global.core.setup.addOns[addonId][2] = true; -- set to "needs installing"
  LoadMuiAddOn("MUI_Setup");
  local setupModule = MayronUI:ImportModule("SetUpModule"); ---@type MUI_SetupModule
  setupModule:Install();
end

local function InstallPresetOnCancel(_, addonId, latestPresetVersion)
  local presetInfo = db.global.core.setup.addOns[addonId];
  presetInfo[2] = false; -- does not need installing
  presetInfo[4] = latestPresetVersion; -- skip this version and assign the latest preset version

  local command = tk.Strings:SetTextColorByTheme("/mui install", "LIGHT_YELLOW");
  local message = L["You can always install presets at anytime from the custom install tab located on the MayronUI installer."];
  local subMessage =  L["Hint: Type %s to access the installer."]:format(command);

  _G.C_Timer.After(0.01, function()
    -- Need to add a delay, else the OnCancel will prevent the 2nd popup from showing
    tk:ShowMessagePopup(message, subMessage);
  end);
end

local function CheckForNewMayronUIPreset(addonId, presetInfo)
  if (not obj:IsTable(presetInfo)) then return end
  local displayName = presetInfo[1];
  local needsInstalling = presetInfo[2];
  local registeredName = presetInfo[3];
  local installedPresetVersion = presetInfo[4] or 0;

  if (not IsAddOnLoaded(registeredName)) then return end

  local defaults = db.global.core.setup.addOns[addonId]:GetDefaults();

  if (not obj:IsTable(defaults)) then
    -- _G.MayronUIdb.global.core.setup.addOns[addonId] = nil; -- TODO: SAFELY remove it (this might be risky)
    return
  end

  local latestPresetVersion = defaults[4] or 0;
  local newerPresetAvailable = needsInstalling or (installedPresetVersion < latestPresetVersion);

  if (not newerPresetAvailable) then return end

  local coloredDisplayName = tk.Strings:SetTextColorByKey(displayName, "LIGHT_YELLOW");

  local message = L["There is a newer MayronUI preset available for %s."]:format(coloredDisplayName)
    .. "\n\n" .. L["Would you like to install it?"];

  local warningText = L["Warning! This will wipe all customizations you have made to %s."]:format(displayName);
  local confirmText = L["Install Preset"];
  local cancelText = L["Skip this Version"];

  tk:ShowConfirmPopup(
    message, warningText, confirmText, InstallPresetOnClick,
    cancelText, InstallPresetOnCancel, true, addonId, latestPresetVersion);
end


-- Register Core Module ---------------------
local C_CoreModule = MayronUI:RegisterModule("CoreModule", "MUI Core", true);

function C_CoreModule:OnInitialize()
  _G["SLASH_MUI1"] = "/mui";
  _G.SlashCmdList.MUI = function(str)
    if (#str == 0) then
      commands.help();
      return;
    end

    local args = obj:PopTable();

    for _, arg in obj:IterateArgs(strsplit(" ", str)) do
      if (#arg > 0) then
        table.insert(args, arg);
      end
    end

    local path = commands;

    for id, arg in ipairs(args) do
      arg = string.lower(arg);

      if (path[arg]) then
        if (obj:IsFunction(path[arg])) then
          path[arg](select(id + 1, unpack(args)));
          return;

        elseif (obj:IsTable(path[arg])) then
          path = path[arg];
        else
          commands.help();
          return;
        end

      else
        commands.help();
        return;
      end

    end
    obj:PushTable(args);
  end

  -- Initialize all modules here!
  for _, module in MayronUI:IterateModules() do
    if (not module:IsInitializedOnDemand() and not module:IsInitialized()) then
      -- initialize a module if not set for manual initialization
      module:Initialize();
    end
  end

  for addonId, addonData in db.global.core.setup.addOns:Iterate() do
    CheckForNewMayronUIPreset(addonId, addonData);
  end

  if (db.global.core.maxCameraZoom) then
    _G.SetCVar("cameraDistanceMaxZoomFactor", 4.0);
  end

  tk:Print(L["Welcome back"], UnitName("player") .. "!");
  collectgarbage("collect");
  DisableAddOn("MUI_Setup"); -- disable for next time
end

-- Initialize Modules after player enters world (not when DB starts!).
-- Some dependencies, like Bartender, only load after this event.
local onLogin = em:CreateEventListener(function()
  for i = 1, _G.NUM_CHAT_WINDOWS do
    _G["ChatFrame" .. i .. "EditBox"]:SetAltArrowKeyMode(false);
  end

  FillLocalizedClassList(tk.Constants.LOCALIZED_CLASS_NAMES);
  FillLocalizedClassList(tk.Constants.LOCALIZED_CLASS_FEMALE_NAMES, true);

  if (not MayronUI:IsInstalled()) then
    if (db.global.core.setup.profilePerCharacter) then
      db:SetProfile(tk:GetPlayerKey());
    end

    MayronUI:TriggerCommand("install");
    return;
  end

  local coreModule = MayronUI:ImportModule("CoreModule");
  coreModule:Initialize();
end);

onLogin:RegisterEvent("PLAYER_ENTERING_WORLD")
onLogin:SetExecuteOnce(true); -- destroy after first use

local onLogout = em:CreateEventListener(function()
  db.profile.freshInstall = nil;
end);

onLogout:RegisterEvent("PLAYER_LOGOUT");

-- Database Event callbacks --------------------
db:OnProfileChange(function(_, newProfileName, oldProfileName)
  local coreModule = MayronUI:ImportModule("CoreModule");

  if (not (coreModule:IsInitialized() and MayronUI:IsInstalled())) then
    return
  end

  for _, module in MayronUI:IterateModules() do
    local registryInfo = registeredModules[tostring(module)];

    if (not MayronUI:GetComponent(registryInfo.moduleKey .. "Database", true)) then
      module:TriggerEvent("OnProfileChanging", newProfileName);
      module:RefreshSettings();

      local enabled = module:IsEnabled();
      -- this will call ExecuteAllUpdateFunctions
      module:SetEnabled(enabled);

      module:TriggerEvent("OnProfileChanged", newProfileName);
    end
  end

  local msg;
  if (oldProfileName == newProfileName) then
    msg = string.format(L["Profile %s has been reset."],
      tk.Strings:SetTextColorByKey(newProfileName, "gold"));
  else
    msg = string.format(L["Profile changed to %s."],
      tk.Strings:SetTextColorByKey(newProfileName, "gold"));
  end

  tk:Print(msg);
  MayronUI:ShowReloadUIPopUp();
end);