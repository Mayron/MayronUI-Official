-- luacheck: ignore MayronUI LibStub self 143 631
local addOnName, namespace = ...;
local _G, LibStub = _G, _G.LibStub;

MayronUI = {};

local MigrateToGen6;
local table, ipairs, pairs, select, string, unpack, print = _G.table, _G.ipairs, _G.pairs, _G.select, _G.string, _G.unpack, _G.print;
local IsAddOnLoaded, EnableAddOn, LoadAddOn, DisableAddOn, ReloadUI = _G.IsAddOnLoaded, _G.EnableAddOn, _G.LoadAddOn, _G.DisableAddOn, _G.ReloadUI;

namespace.components.Database = LibStub:GetLibrary("LibMayronDB"):CreateDatabase(addOnName, "MayronUIdb");
namespace.components.EventManager = LibStub:GetLibrary("LibMayronEvents");
namespace.components.GUIBuilder = LibStub:GetLibrary("LibMayronGUI");
namespace.components.Locale = LibStub("AceLocale-3.0"):GetLocale("MayronUI");

local tk  = namespace.components.Toolkit; ---@type Toolkit
local db  = namespace.components.Database; ---@type LibMayronDB
local em  = namespace.components.EventManager; ---@type LibMayronEvents
local gui = namespace.components.GUIBuilder; ---@type LibMayronGUI
local obj = namespace.components.Objects; ---@type LibMayronObjects
local L   = namespace.components.Locale; ---@type Locale

---Gets the core components of MayronUI
---@return Toolkit, LibMayronDB, LibMayronEvents, LibMayronGUI, LibMayronObjects, Locale
function MayronUI:GetCoreComponents()
    return tk, db, em, gui, obj, L;
end

---Get a single component registered with the MayronUI Engine
function MayronUI:GetComponent(componentName)
    return namespace.components[componentName];
end

---Add/Register a custom component with the MayronUI Engine
function MayronUI:AddComponent(componentName, component)
    namespace.components[componentName] = component;
end

local registeredModules = {};

-- Objects  ---------------------------

---@class Engine : Package
local Engine = obj:CreatePackage("Engine", "MayronUI");

---@class BaseModule : Object
local BaseModule = Engine:CreateClass("BaseModule");

-- Load Database Defaults -------------

db:AddToDefaults("global", {
    layouts = {
        DPS = {
            ["ShadowUF"] = "Default";
            ["Grid"] = "Default";
        };
        Healer = {
            ["ShadowUF"] = "MayronUIH";
            ["Grid"] = "MayronUIH";
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
                {"Aura Frames", true, "AuraFrames"};
                {"Bagnon", true, "Bagnon"};
                {"Bartender4", true, "Bartender4"};
                {"Grid", true, "Grid"};
                {"Masque", true, "Masque"};
                {"Mik Scrolling Battle Text", true, "MikScrollingBattleText"};
                {"Recount", true, "Recount"};
                {"Shadowed Unit Frames", true, "ShadowedUnitFrames"};
                {"TipTac", true, "TipTac"};
            };
        };
    };
});

db:AddToDefaults("profile.layout", "DPS");

local _, class = _G.UnitClass("player");
local classColor = tk.Constants.CLASS_COLORS[class];

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
    local module = GetMuiConfigModule()

    if (module) then
        module:Show();
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
    print(" ");
end

-- BaseModule Object -------------------

Engine:DefineReturns("string", "?boolean");
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
end

---Initialize the module manually (on demand) or is called by MayronUI on startup.
function BaseModule:Initialize(_, ...)
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

Engine:DefineReturns("string");
---@return string @Returns the human-friendly name of the module to be used in-game (such as on the config window).
function BaseModule:GetModuleName(_)
    local registryInfo = registeredModules[tostring(self)];
    return registryInfo.moduleName;
end

Engine:DefineReturns("string");
---@return string @Returns the key used to register the module to MayronUI.
function BaseModule:GetModuleKey(_)
    local registryInfo = registeredModules[tostring(self)];
    return registryInfo.moduleKey;
end

Engine:DefineParams("boolean");
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

Engine:DefineReturns("boolean");
---@return boolean @Returns true if the module has already been initialized.
function BaseModule:IsInitialized()
    local registryInfo = registeredModules[tostring(self)];
    return registryInfo.initialized;
end

Engine:DefineReturns("boolean");
---Returns whether the module should be initialized automatically on start up or manually.
---@return boolean @If true, the module should be initialized on demand (manually) when required.
function BaseModule:IsInitializedOnDemand()
    local registryInfo = registeredModules[tostring(self)];
    return registryInfo.initializeOnDemand == true;
end

Engine:DefineReturns("boolean");
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

local function ExecuteUpdateFunction(path, updateFunction, setting, executed, onPre, onPost)
    if (obj:IsTable(executed) and executed[path]) then
        return;
    end

    local keysList = tk.Tables:ConvertPathToKeysList(path);

    if (obj:IsFunction(onPre)) then
        local onPreResults = obj:PopTable(onPre(setting, keysList));

        if (#onPreResults > 0) then
            if (obj:IsFunction(onPost)) then
                onPost(setting, keysList, updateFunction(setting, keysList, unpack(onPreResults)));
            else
                updateFunction(setting, keysList, unpack(onPreResults));
            end
        end

        obj:PushTable(onPreResults);
    else
        if (obj:IsFunction(onPost)) then
            onPost(setting, keysList, updateFunction(setting, keysList));
        else
            updateFunction(setting, keysList);
        end
    end

    if (obj:IsTable(executed)) then
        -- if executing all settings then this is used
        executed[path] = true;
    end
end

local function HasMatchingPathPattern(path, patterns)
    for _, pattern in ipairs(patterns) do
        if (path:find(pattern)) then
            return true;

        elseif (pattern:find("%(.*|.*%)")) then
            local optionalKeys = pattern:match("(%(.*|.*%)).*");

            for key in string.gmatch(optionalKeys, "([^(|)]+)") do
                local concretePath = pattern:gsub("%(.*|.*%)", key);

                if (not obj:IsStringNilOrWhiteSpace(concretePath) and path:match(concretePath)) then
                    return true;
                end
            end
        end
    end

    return false;
end

local function FindMatchingGroupValue(path, options)
    if (options and options.groups) then
        for _, groupOptions in pairs(options.groups) do
            if (HasMatchingPathPattern(path, groupOptions.patterns)) then
                if (groupOptions.value) then
                    local updateFunction = groupOptions.value;

                    if (obj:IsTable(updateFunction)) then
                        for _, key in obj:IterateArgs(string.split(".", path)) do
                            if (updateFunction[key]) then
                                updateFunction = updateFunction[key];

                                if (obj:IsFunction(updateFunction)) then
                                    break;
                                end
                            end
                        end
                    end

                    return updateFunction, groupOptions.onPre, groupOptions.onPost;
                end
            end
        end
    end
end

do
    local ignoreEnabledOption = { onExecuteAll = {ignore = { "^enabled$" } } };

    Engine:DefineParams("Observer", "table", "?table");
    ---Executed when a profile is loaded and the UI needs to apply changes (this includes loading the initial profile on start up)
    ---@param observer Observer The database observer node to attach the update functions to
    ---@param updateFunctions table A table containing update functions mapped to settings
    ---@param options table|nil An optional table containing options to control how update
    function BaseModule:RegisterUpdateFunctions(data, observer, updateFunctions, options)
        if (not data.settings) then
            data.settings = observer:GetUntrackedTable(); -- disconnected from database
        end

        if (obj:IsTable(options)) then
            if (not data.options) then
                data.options = options;

            elseif (obj:IsTable(data.options)) then
                tk.Tables:Fill(data.options, options);
            end
        end

        if (not data.updateFunctions) then
            data.updateFunctions = updateFunctions;
        else
            -- append new update functions
            tk.Tables:Fill(data.updateFunctions, updateFunctions);
        end

        if (not data.updateFunctions.enabled and data.settings.enabled ~= nil) then
            data.updateFunctions.enabled = function(value)
                self:SetEnabled(value);
            end
        end

        if (data.options) then
            if (data.options.onExecuteAll and data.options.onExecuteAll.ignore) then
                if (not tk.Tables:Contains(data.options.onExecuteAll.ignore, "^enabled$")) then
                    table.insert(data.options.onExecuteAll.ignore, "^enabled$");
                end
            elseif (data.options.onExecuteAll) then
                data.options.onExecuteAll.ignore = ignoreEnabledOption.onExecuteAll.ignore;
            else
                data.options.onExecuteAll = ignoreEnabledOption.onExecuteAll;
            end
        else
            data.options = ignoreEnabledOption;
        end

        local observerPath = observer:GetPathAddress();

        -- updateFunctionPath is the located function (or table if no function found) path
        -- originalPathOfValue is the original path LibMayronDB tried to find
        db:RegisterUpdateFunctions(observerPath, data.updateFunctions, function(updateFunction, fullPath, newValue)
            local onPre, onPost;
            local settingPath = fullPath:gsub(observerPath..".", tk.Strings.Empty);

            if (updateFunction == nil) then
                -- check if a group function can be used
                updateFunction, onPre, onPost = FindMatchingGroupValue(settingPath, data.options);
            end

            if (obj:IsFunction(updateFunction)) then
                -- update settings:
                db:SetPathValue(data.settings, settingPath, newValue);

                if (self:IsEnabled() or updateFunction == data.updateFunctions.enabled) then
                    ExecuteUpdateFunction(settingPath, updateFunction, newValue, nil, onPre, onPost);
                end
            else
                -- update settings:
                db:SetPathValue(data.settings, settingPath, newValue);
            end
        end);
    end
end

do
    local MAX_BLOCKS = 20;

    local function GetBlocked(options, path, executed)
        if (options.onExecuteAll.dependencies) then
            for dependencyValue, dependency in pairs(options.onExecuteAll.dependencies) do
                if (path ~= dependency and path:match(dependencyValue) and not executed[dependency]) then
                    return true;
                end
            end
        end

        return false;
    end

    local function GetIgnored(options, path, executedTable)
        if (executedTable[path]) then
            return true; -- been executed before
        end

        if (not options) then
            return false;
        end

        if (options.onExecuteAll.first and options.onExecuteAll.first[path]) then
            return true;
        end

        if (options.onExecuteAll.last and options.onExecuteAll.last[path]) then
            return true;
        end

        for _, ignoreValue in ipairs(options.onExecuteAll.ignore) do
            if (path:match(ignoreValue)) then
                return true;
            end
        end

        return false;
    end

    --"first", data.options, data.updateFunctions, data.settings, executedTable
    local function ExecuteOrdered(orderKey, options, updateFunction, setting, executed)
        if (not options.onExecuteAll[orderKey]) then
            return false;
        end

        for _, path in ipairs(options.onExecuteAll[orderKey]) do
            -- both param.updateFunction and param.setitng will be tables
            local currentUpdateFunction = db:ParsePathValue(updateFunction, path);
            local currentSetting = db:ParsePathValue(setting, path);
            local onPre, onPost;

            if (currentUpdateFunction == nil) then
                -- check if a group function can be used
                currentUpdateFunction, onPre, onPost = FindMatchingGroupValue(path, options);
            end

            obj:Assert(obj:IsFunction(currentUpdateFunction), "No update function exists for ordered path '%s'", path);
            ExecuteUpdateFunction(path, currentUpdateFunction, currentSetting, executed, onPre, onPost);
        end
    end

    local function ExecuteAllUpdateFunctions(options, updateFunctionsTable, settingsTable, executedTable, blockedTable, previousPath)
        for key, setting in pairs(settingsTable) do
            local path = key;
            local updateFunction = updateFunctionsTable;
            local onPre, onPost;

            if (previousPath) then
                path = string.format("%s.%s", previousPath, key);
            end

            local ignored = GetIgnored(options, path, executedTable);

            if (not ignored) then
                -- find next update function:
                if (not obj:IsFunction(updateFunction)) then

                    if (obj:IsTable(updateFunction)) then
                        -- get next function value
                        updateFunction = updateFunction[key];
                    end

                    if (updateFunction == nil) then
                        -- check if a group function can be used
                        updateFunction, onPre, onPost = FindMatchingGroupValue(path, options);
                    end
                end

                local blocked = GetBlocked(options, path, executedTable);

                if (blocked) then
                    blockedTable[path] = obj:PopTable(path, updateFunction, setting, executedTable, onPre, onPost);

                elseif (obj:IsFunction(updateFunction)) then -- CanCallUpdateFunction(options, path, updateFunction, setting)
                    ExecuteUpdateFunction(path, updateFunction, setting, executedTable, onPre, onPost);

                elseif (obj:IsTable(setting)) then
                    ExecuteAllUpdateFunctions(options, updateFunction, setting, executedTable, blockedTable, path);
                end
            end
        end
    end

    function BaseModule:ExecuteAllUpdateFunctions(data)
        if (not obj:IsTable(data.updateFunctions)) then return; end

        data.executingAllUpdateFunctions = true;

        local executedTable = obj:PopTable();
        local blockedTable = obj:PopTable();

        ExecuteOrdered("first", data.options, data.updateFunctions, data.settings, executedTable);
        ExecuteAllUpdateFunctions(data.options, data.updateFunctions, data.settings, executedTable, blockedTable);

        local blockedValues = false;
        local totalRepeats = 0;

        repeat
            for path, blockedValue in pairs(blockedTable) do
                local blocked = GetBlocked(data.options, path, executedTable);

                if (not blocked) then
                    ExecuteUpdateFunction(unpack(blockedValue));
                else
                    blockedValues = true;
                end
            end

            totalRepeats = totalRepeats + 1;

            obj:Assert(totalRepeats < MAX_BLOCKS, "Cyclic dependency found");
        until (not blockedValues);

        ExecuteOrdered("last", data.options, data.updateFunctions, data.settings, executedTable);

        obj:PushTable(executedTable);
        obj:PushTable(blockedTable);
        data.executingAllUpdateFunctions = nil;
    end
end

-- MayronUI Functions ---------------------

---A helper function to print a table's contents using the MayronUI prefix in the chat frame.
---@param tbl table @The table to print.
---@param depth number @The depth of sub-tables to traverse through and print.
function MayronUI:PrintTable(tbl, depth)
    tk.Tables:Print(tbl, depth);
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
    commands[commandName:lower()](...);
end

---Hook more functions to a module event. Useful if module is spread across multiple files.
---@param moduleKey string @The unique key associated with the registered module.
---@param eventName string @The name of the module event to hook (i.e. "OnInitialize", "OnEnable", etc...).
---@param func function @A callback function to execute when the module's event is triggered.
function MayronUI:Hook(moduleKey, eventName, func)
    local registryInfo = registeredModules[moduleKey];

    if (not registryInfo) then
        -- addon is disabled so cannot hook
        return;
    end

    local eventHooks = tk.Tables:GetTable(registryInfo, "hooks", eventName);

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

    return registryInfo and registryInfo.class;
end

---@param moduleKey string @The unique key associated with the registered module.
function MayronUI:ImportModule(moduleKey)
    local registryInfo = registeredModules[moduleKey];

    if (not registryInfo) then
        -- addon is disabled so cannot import module
        return nil;
    end

    return registryInfo and registryInfo.instance;
end

---MayronUI automatically initializes modules during the "PLAYER_ENTERING_WORLD" event unless initializeOnDemand is true.
---@param moduleKey string @A unique key used to register the module to MayronUI.
---@param moduleName string @A human-friendly name of the module to be used in-game (such as on the config window).
---@param initializeOnDemand boolean @(optional) If true, must be initialized manually instead of
---@return Class @Returns a new module Class so that a module can be given additional methods and definitions where required.
function MayronUI:RegisterModule(moduleKey, moduleName, initializeOnDemand)
    local ModuleClass = Engine:CreateClass(moduleKey, BaseModule);
    local moduleInstance = ModuleClass();

    -- must add it to the registeredModules table before calling parent constructor!
    registeredModules[moduleKey] = obj:PopTable();
    registeredModules[moduleKey].instance = moduleInstance;
    registeredModules[moduleKey].class = ModuleClass;

    moduleInstance:Super(moduleKey, moduleName, initializeOnDemand); -- call parent constructor

    -- Make it easy to iterate through modules
    table.insert(registeredModules, moduleInstance);

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

local C_CoreModule = MayronUI:RegisterModule("Core");

function C_CoreModule:OnInitialize()
    for i = 1, _G.NUM_CHAT_WINDOWS do
        _G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false);
    end

    _G["SLASH_MUI1"] = "/mui";
	_G.SlashCmdList.MUI = function(str)

		if (#str == 0) then
			commands.help();
			return;
        end

        local args = obj:PopTable();

		for _, arg in obj:IterateArgs(tk.string.split(' ', str)) do
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

    tk:Print(L["Welcome back"], _G.UnitName("player").."!");
end

-- Initialize Modules after player enters world (not when DB starts!).
-- Some dependencies, like Bartender, only load after this event.
em:CreateEventHandler("PLAYER_ENTERING_WORLD", function()
    _G.FillLocalizedClassList(tk.Constants.LOCALIZED_CLASS_NAMES);

    if (not MayronUI:IsInstalled()) then

        if (db.global.core.setup.profilePerCharacter) then
            db:SetProfile(tk:GetPlayerKey());
        end

        MayronUI:TriggerCommand("install");
        return;
    end

    for _, module in MayronUI:IterateModules() do
        local initializeOnDemand = module:IsInitializedOnDemand();

        if (not initializeOnDemand) then
            -- initialize a module if not set for manual initialization
            module:Initialize();
        end
    end

    namespace:SetUpOrderHallBar();

    if (_G.IsAddOnLoaded("Recount")) then
        if (db.global.reanchorRecount) then
            _G.Recount_MainWindow:ClearAllPoints();
            _G.Recount_MainWindow:SetPoint("BOTTOMRIGHT", -2, 2);
            _G.Recount_MainWindow:SaveMainWindowPosition();

            db.global.reanchorRecount = nil;
        end

        -- Reskin Recount Window
        gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, "LOW",  _G.Recount_MainWindow);

        _G.Recount_MainWindow:SetClampedToScreen(true);
        _G.Recount_MainWindow.tl:SetPoint("TOPLEFT", -6, -5);
        _G.Recount_MainWindow.tr:SetPoint("TOPRIGHT", 6, -5);
    end

    collectgarbage("collect");
    DisableAddOn("MUI_Setup"); -- disable for next time
end):SetAutoDestroy(true);

-- Database Event callbacks --------------------

db:OnProfileChange(function(self, newProfileName)
    if (not MayronUI:IsInstalled()) then
        return;
    end

    for _, module in MayronUI:IterateModules() do
        local registryInfo = registeredModules[tostring(module)];
        local hooks = registryInfo.hooks and registryInfo.hooks.OnProfileChange;

        module:ExecuteAllUpdateFunctions();

        if (module.OnProfileChange) then
            module:OnProfileChange(newProfileName);
        end

        if (hooks) then
            for _, func in ipairs(hooks) do
                func(module, registryInfo.moduleData);
            end
        end
    end

    tk:Print("Profile changed to:", tk.Strings:SetTextColorByKey(newProfileName, "GOLD"));

    MayronUI:ShowReloadUIPopUp();
end);

db:OnStartUp(function(self)
    MayronUI.db = self;

    MigrateToGen6();
    namespace:SetUpBagnon();

    local r, g, b = tk:GetThemeColor();

    local myFont = _G.CreateFont("MUI_FontNormal");
    myFont:SetFontObject("GameFontNormal");
    myFont:SetTextColor(r, g, b);

    myFont = _G.CreateFont("MUI_FontSmall");
    myFont:SetFontObject("GameFontNormalSmall");
    myFont:SetTextColor(r, g, b);

    myFont = _G.CreateFont("MUI_FontLarge");
    myFont:SetFontObject("GameFontNormalLarge");
    myFont:SetTextColor(r, g, b);

    -- To keep UI widget styles consistent ----------
    -- Can only use once Database is loaded...

    local Style = obj:Import("MayronUI.Widgets.Style");

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
    media:Register(media.MediaType.BORDER, "Skinner", tk:GetAssetFilePath("Borders\\Solid.tga"));
    media:Register(media.MediaType.BORDER, "Glow", tk:GetAssetFilePath("Borders\\Glow.tga"));

    -- Set Master Game Font Here! -------------------

    if (self.global.core.changeGameFont ~= false) then
        tk:SetGameFont(media:Fetch("font", self.global.core.font));
    end

    obj:SetErrorHandler(function(errorMessage, stack, locals)
        local hideErrorFrame = not _G.GetCVarBool("scriptErrors");
        _G.ScriptErrorsFrame:DisplayMessageInternal(errorMessage, nil, hideErrorFrame, locals, stack);
        _G.ScriptErrorsFrame.Title:SetText("MayronUI Error");
        _G.ScriptErrorsFrame.Title:SetFontObject("MUI_FontNormal");
        _G.ScriptErrorsFrame.Title.SetText = function() end;
        _G.ScriptErrorsFrame.DisplayMessage = function() end;
        error();
    end);
end);

-- MUI Gen5 to Gen6 Migration:
function MigrateToGen6()
    local gen5 = _G.MUIdb;

    if (not (obj:IsTable(gen5) and obj:IsTable(db:ParsePathValue(gen5, "global.core.addons")))) then
        return;
    end

    local setup = tk.Tables:GetTable(_G.MayronUIdb.global, "core", "setup");
    setup.addOns = gen5.global.core.addons;

    table.insert(setup.addOns, 2, {"Bagnon", true, "Bagnon"});
end