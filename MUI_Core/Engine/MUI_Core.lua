-- luacheck: ignore MayronUI LibStub self 143 631
local addOnName, namespace = ...;
local LibStub = _G.LibStub;

---@class MayronUI
_G.MayronUI = {};
local MayronUI = _G.MayronUI;
local table, ipairs, select, string, unpack, print = _G.table, _G.ipairs, _G.select, _G.string, _G.unpack, _G.print;
local IsAddOnLoaded, EnableAddOn, LoadAddOn, DisableAddOn, ReloadUI =
  _G.IsAddOnLoaded, _G.EnableAddOn, _G.LoadAddOn, _G.DisableAddOn, _G.ReloadUI;
local strsplit, tostring = _G.strsplit, _G.tostring;
local collectgarbage, CreateFont = _G.collectgarbage, _G.CreateFont;
local hooksecurefunc, InCombatLockdown = _G.hooksecurefunc, _G.InCombatLockdown;
local FillLocalizedClassList, UnitName = _G.FillLocalizedClassList, _G.UnitName;

_G.BINDING_CATEGORY_MUI = "MayronUI";
_G.BINDING_NAME_MUI_SHOW_CONFIG_MENU = "Show Config Menu";
_G.BINDING_NAME_MUI_SHOW_LAYOUT_MENU = "Show Layout Menu";
_G.BINDING_NAME_MUI_SHOW_INSTALLER = "Show Installer";

local obj = namespace.components.Objects; ---@type MayronObjects

namespace.components.Database = obj:Import("MayronDB")
  .Static:CreateDatabase(addOnName, "MayronUIdb", nil, "MayronUI");

namespace.components.EventManager =obj:Import("Pkg-MayronEvents.EventManager")();
namespace.components.GUIBuilder = LibStub:GetLibrary("LibMayronGUI");
namespace.components.Modules = {};

local tk  = namespace.components.Toolkit; ---@type Toolkit
local db  = namespace.components.Database; ---@type Database
local em  = namespace.components.EventManager; ---@type EventManager
local gui = namespace.components.GUIBuilder; ---@type LibMayronGUI
local L   = namespace.components.Locale; ---@type Locale

if (tk:IsClassic()) then
  -- remove the Shaman Pink class color back to retail.
  local shamanColor = _G.RAID_CLASS_COLORS["SHAMAN"];
  shamanColor:SetRGB(0.0, 0.44, 0.87);
  shamanColor.colorStr = shamanColor:GenerateHexColor();
end

---Gets the core components of MayronUI
---@return Toolkit, Database, EventManager, LibMayronGUI, MayronObjects, Locale
function MayronUI:GetCoreComponents()
  return tk, db, em, gui, obj, L;
end

function MayronUI:GetCoreComponent(componentName, silent)
  tk:Assert(silent or obj:IsString(componentName), "Invalid component '%s'", componentName);

  local component = namespace.components[componentName];
  tk:Assert(silent or obj:IsTable(component), "Invalid component '%s'", componentName);

  return component;
end

---Get a single component registered with the MayronUI Engine
function MayronUI:GetModuleComponent(moduleKey, componentName)
  if (obj:IsTable(namespace.components.Modules[moduleKey])) then
    return namespace.components.Modules[moduleKey][componentName];

  elseif (not moduleKey or moduleKey == "CoreModule") then
    return self:GetCoreComponent(componentName);
  end
end

---Add/Register a custom component with the MayronUI Engine
function MayronUI:AddModuleComponent(moduleKey, componentName, component)
  local components = tk.Tables:GetTable(namespace.components.Modules, moduleKey);
  components[componentName] = component;
end

local registeredModules = {};

-- Objects  ---------------------------
---@class BaseModule : Object
local BaseModule = obj:CreateClass("BaseModule");
obj:Export(BaseModule, "MayronUI");

-- Load Database Defaults -------------

db:AddToDefaults("global", {
  layouts = {
    DPS = {
      ["ShadowUF"] = "Default";
      ["MUI_TimerBars"] = "Default";
    };
    Healer = {
      ["ShadowUF"] = "MayronUIH";
      ["MUI_TimerBars"] = "Healer";
    };
  };

  core = {
    uiScale           = 0.7;
    changeGameFont    = true;
    font              = "MUI_Font";
    useLocalization   = true;

    setup = {
      profilePerCharacter = true;
      addOns = {
        {"Bagnon", true, "Bagnon"};
        {"Bartender4", true, "Bartender4"};
        {"Masque", true, "Masque"};
        {"Shadowed Unit Frames", true, "ShadowedUnitFrames"};
        {"Leatrix Plus", true, "Leatrix_Plus"};
      };
    };
  };
});

db:AddToDefaults("profile.layout", "DPS");

local classColor = tk:GetClassColorByUnitID("player");
db:AddToDefaults("profile.theme", {
  color = {
    r     = classColor.r;
    g     = classColor.g;
    b     = classColor.b;
    hex   = classColor:GenerateHexColor();
  },
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
  if (not LoadMuiAddOn("MUI_Config")) then return; end
  local configModule = MayronUI:ImportModule("ConfigModule");

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
  if (not LoadMuiAddOn("MUI_Config")) then return; end
  local layoutSwitcher = MayronUI:ImportModule("LayoutSwitcher");
  layoutSwitcher:ShowLayoutTool();
end

commands.install = function()
  if (not LoadMuiAddOn("MUI_Setup")) then return; end
  MayronUI:ImportModule("SetUpModule"):Show();
end

commands.report = function(forceShow)
  if (not LoadMuiAddOn("MUI_Setup")) then return end
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

local function ValidateNewProfileName(self, profileName)
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

  return text == "DELETE";
end

local function RemoveProfile(_, _, profileName, callback)
  db:RemoveProfile(profileName);
  tk:Print("Profile", tk.Strings:SetTextColorByKey(profileName, "gold"), "has been deleted.");

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

    elseif (subCommand == "delete" and not tk.Strings:IsNilOrWhiteSpace(profileName)) then
      if (profileName == "Default") then
        tk:Print("Cannot delete the Default profile.");
        return;
      end

      local popupMessage = string.format("Are you sure you want to delete profile '%s'?", profileName);
      local subMessage = "Please type 'DELETE' to confirm:";

      tk:ShowInputPopup(popupMessage, subMessage, nil, ValidateRemoveProfile, nil, RemoveProfile, nil, nil, true, profileName, callback);

    elseif (subCommand == "new") then
      local popupMessage = "Enter a new unique profile name:";
      tk:ShowInputPopup(popupMessage, nil, nil, ValidateNewProfileName, nil, CreateNewProfile, nil, nil, nil, callback);

    elseif (subCommand == "current") then
      local currentProfile = db:GetCurrentProfile();
      currentProfile = tk.Strings:SetTextColorByKey(currentProfile, "gold");
      tk:Print("Current Profile:", currentProfile);
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
          allProfiles = tk.Strings:Join(", ", allProfiles, tk.Strings:SetTextColorByKey(profile, "gold"));
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
  tk:Print("MUI_Core:", tk:GetVersion("MUI_Core", "YELLOW"));
  tk:Print("MUI_Config:", tk:GetVersion("MUI_Config", "YELLOW"));
  tk:Print("MUI_Setup:", tk:GetVersion("MUI_Setup", "YELLOW"));
end

commands.help = function()
  print(" ");
  tk:Print(L["List of slash commands:"])
  tk:Print("|cff00cc66/mui config|r - "..L["shows config menu"]);
  tk:Print("|cff00cc66/mui install|r - "..L["shows setup menu"]);
  tk:Print("|cff00cc66/mui layouts|r - show layout tool");
  tk:Print("|cff00cc66/mui profiles list|r - list all MayronUI profiles");
  tk:Print("|cff00cc66/mui profiles|r - shows profile manager");
  tk:Print("|cff00cc66/mui profile set <profile_name>|r - set profile");
  tk:Print("|cff00cc66/mui profile delete <profile_name>|r - delete profile");
  tk:Print("|cff00cc66/mui profile new|r - create new profile");
  tk:Print("|cff00cc66/mui profile current|r - show current profile in chat");
  tk:Print("|cff00cc66/mui version|r - show the version of MayronUI");
  tk:Print("|cff00cc66/mui report|r - Report an issue to GitHub");
  print(" ");
end

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
  if (self:IsInitialized()) then return end

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

    if (data.updateFunctions and not data.firstTime) then
      -- execute all update functions if enabled setting changed
      self:ExecuteAllUpdateFunctions(self);
      data.firstTime = true;
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
---@param depth number @The depth of sub-tables to traverse through and print.
---@param spaces number @The number of spaces used for nested values inside a table (defaults to 2).
function MayronUI:PrintTable(tbl, depth, spaces)
  tk.Tables:Print(tbl, depth, spaces);
end

function MayronUI:ShowReloadUIPopUp()
  tk:ShowConfirmPopup("Some settings will not be changed until the UI has been reloaded.",
    "Would you like to reload the UI now?", ReloadUI, "Reload UI", nil, "No", true);
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
  commands[commandName](...);
end

---@param commandName string @The name of the command to register.
---@param func function @The command handler function to register.
function MayronUI:RegisterCommand(commandName, func)
  commandName = commandName:lower();
  obj:Assert(not commands[commandName], "Command already exists: '%s'", commandName);
  commands[commandName] = func;
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
  local ModuleClass = obj:CreateClass(moduleKey, BaseModule);

  -- must add it to the registeredModules table before calling parent constructor!
  registeredModules[moduleKey] = registeredModules[moduleKey] or obj:PopTable();
  registeredModules[moduleKey].class = ModuleClass;

  ModuleClass(moduleKey, moduleName, initializeOnDemand);

  return ModuleClass;
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

  for _, arg in obj:IterateArgs(strsplit(' ', str)) do
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

  tk:Print(L["Welcome back"], UnitName("player").."!");
  collectgarbage("collect");
  DisableAddOn("MUI_Setup"); -- disable for next time
end

-- Initialize Modules after player enters world (not when DB starts!).
-- Some dependencies, like Bartender, only load after this event.
local onLogin = em:CreateEventListener(function()
  for i = 1, _G.NUM_CHAT_WINDOWS do
    _G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false);
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

db:OnProfileChange(function(self, newProfileName, oldProfileName)
  if (not MayronUI:IsInstalled() or (_G.MUI_Setup and _G.MUI_Setup:IsShown())) then
    return;
  end

  for _, module in MayronUI:IterateModules() do
    local registryInfo = registeredModules[tostring(module)];

    if (not MayronUI:GetModuleComponent(registryInfo.moduleKey, "Database")) then
      module:RefreshSettings();
      module:ExecuteAllUpdateFunctions();
      module:TriggerEvent("OnProfileChange", newProfileName);
    end
  end

  if (oldProfileName == newProfileName) then
    tk:Print("Profile", tk.Strings:SetTextColorByKey(newProfileName, "gold"), "has been reset.");
  else
    tk:Print("Profile changed to:", tk.Strings:SetTextColorByKey(newProfileName, "GOLD"));
  end

  MayronUI:ShowReloadUIPopUp();
end);

db:OnStartUp(function(self)
  -- setup globals:
  MayronUI.db = self;

  namespace:SetUpBagnon();

  local r, g, b = tk:GetThemeColor();

  local myFont = CreateFont("MUI_FontNormal");
  myFont:SetFontObject("GameFontNormal");
  myFont:SetTextColor(r, g, b);

  myFont = CreateFont("MUI_FontSmall");
  myFont:SetFontObject("GameFontNormalSmall");
  myFont:SetTextColor(r, g, b);

  myFont = CreateFont("MUI_FontLarge");
  myFont:SetFontObject("GameFontNormalLarge");
  myFont:SetTextColor(r, g, b);

  -- To keep UI widget styles consistent ----------
  -- Can only use once Database is loaded...
  ---@type Style
  local Style = obj:Import("MayronUI.Style");

  ---@type Style
  tk.Constants.AddOnStyle = Style();
  tk.Constants.AddOnStyle:SetPadding(10, 10, 10, 10);
  tk.Constants.AddOnStyle:SetBackdrop(tk.Constants.BACKDROP, "DropDownMenu");
  tk.Constants.AddOnStyle:SetBackdrop(tk.Constants.BACKDROP, "ButtonBackdrop");
  tk.Constants.AddOnStyle:SetTexture(tk:GetAssetFilePath("Textures\\Widgets\\Button"), "ButtonTexture");
  tk.Constants.AddOnStyle:SetTexture(tk:GetAssetFilePath("Textures\\Widgets\\GraphicalArrow"), "ArrowButtonTexture");
  tk.Constants.AddOnStyle:SetTexture(tk:GetAssetFilePath("Textures\\Widgets\\SmallArrow"), "SmallArrow");
  tk.Constants.AddOnStyle:SetTexture(tk:GetAssetFilePath("Textures\\DialogBox\\Texture-"), "DialogBoxBackground");
  tk.Constants.AddOnStyle:SetTexture(tk:GetAssetFilePath("Textures\\DialogBox\\TitleBar"), "TitleBarBackground");
  tk.Constants.AddOnStyle:SetTexture(tk:GetAssetFilePath("Textures\\DialogBox\\CloseButton"), "CloseButtonBackground");
  tk.Constants.AddOnStyle:SetTexture(tk:GetAssetFilePath("Textures\\DialogBox\\DragRegion"), "DraggerTexture");
  tk.Constants.AddOnStyle:SetTexture(tk:GetAssetFilePath("Textures\\Widgets\\TextField"), "TextField");
  tk.Constants.AddOnStyle:SetColor(r, g, b);
  tk.Constants.AddOnStyle:SetColor(r * 0.7, g * 0.7, b * 0.7, "Widget");

  -- Load Media using LibSharedMedia --------------
  local media = tk.Constants.LSM;

  media:Register(media.MediaType.FONT, "MUI_Font", tk:GetAssetFilePath("Fonts\\MayronUI.ttf"));
  media:Register(media.MediaType.FONT, "Imagine", tk:GetAssetFilePath("Fonts\\Imagine.ttf"));
  media:Register(media.MediaType.FONT, "Prototype", tk:GetAssetFilePath("Fonts\\Prototype.ttf"));
  media:Register(media.MediaType.STATUSBAR, "MUI_StatusBar", tk:GetAssetFilePath("Textures\\Widgets\\Button.tga"));
  media:Register(media.MediaType.BORDER, "Skinner", tk.Constants.BACKDROP.edgeFile);
  media:Register(media.MediaType.BORDER, "Glow", tk:GetAssetFilePath("Borders\\Glow.tga"));
  media:Register(media.MediaType.BACKGROUND, "MUI_Solid", tk.Constants.BACKDROP_WITH_BACKGROUND.bgFile);

  hooksecurefunc('MovieFrame_PlayMovie', function(s)
    s:SetFrameStrata("DIALOG");
  end);

  -- Set Master Game Font Here! -------------------
  if (self.global.core.changeGameFont ~= false) then
    tk:SetGameFont(media:Fetch("font", self.global.core.font));
  end

  tk:KillElement(_G.WorldMapFrame.BlackoutFrame);
end);