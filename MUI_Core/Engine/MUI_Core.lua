-- luacheck: ignore MayronUI LibStub self 143 631
local addOnName, namespace = ...;

MayronUI = {};

namespace.components = {
    Database = LibStub:GetLibrary("LibMayronDB"):CreateDatabase(addOnName, "MayronUIdb");
    EventManager = LibStub:GetLibrary("LibMayronEvents");
    GUIBuilder = LibStub:GetLibrary("LibMayronGUI");
    Locale = LibStub("AceLocale-3.0"):GetLocale("MayronUI");
};

local tk  = namespace.components.Toolkit;
local db  = namespace.components.Database;
local em  = namespace.components.EventManager;
local gui = namespace.components.GUIBuilder;
local obj = namespace.components.Objects;
local L   = namespace.components.Locale;

function MayronUI:GetCoreComponents()
    return tk, db, em, gui, obj, L;
end

function MayronUI:GetComponent(componentName)
    return namespace.components[componentName];
end

function MayronUI:AddComponent(componentName, component)
    namespace.components[componentName] = component;
end

local registeredModules = {};

-- Objects  ---------------------------

local Engine = namespace.Objects:CreatePackage("Engine", "MayronUI");
local BaseModule = Engine:CreateClass("BaseModule");

-- Load Database Defaults -------------

db:AddToDefaults("global.core", {
    uiScale = 0.7,
    changeGameFont = true,
    font = "MUI_Font",
    useLocalization = true,
    setup = {
        profilePerCharacter = true,
        addOns = {
            {"Aura Frames", true, "AuraFrames"},
            {"Bartender4", true, "Bartender4"},
            {"Grid", true, "Grid"},
            {"Masque", true, "Masque"},
            {"Mik Scrolling Battle Text", false, "MikScrollingBattleText"},
            {"Recount", true, "Recount"},
            {"Shadowed Unit Frames", true, "ShadowedUnitFrames"},
            {"TipTac", true, "TipTac"},
        }
    }
});

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

local function GetMuiConfigModule()
    if (not _G.IsAddOnLoaded("MUI_Config")) then
        _G.EnableAddOn("MUI_Config");

        if (not _G.LoadAddOn("MUI_Config")) then
            tk:Print(L["Failed to load MUI_Config. Possibly missing?"]);
            return;
        end
    end

    local configModule = MayronUI:ImportModule("Config");

    if (not configModule:IsInitialized()) then
        configModule:Initialize();
    end

    return configModule;
end

local commands = {};

commands.config = function()
    GetMuiConfigModule():Show();
end

commands.install = function()
    if (not _G.IsAddOnLoaded("MUI_Setup")) then
        _G.EnableAddOn("MUI_Setup");

        if (not _G.LoadAddOn("MUI_Setup")) then
            tk:Print(L["Failed to load MUI_Setup. Possibly missing?"]);
            return;
        end
    end

    MayronUI:ImportModule("MUI_Setup"):Show();
end

commands.profile = function(subCommand, profileName)
    if (not tk.Strings:IsNilOrWhiteSpace(subCommand)) then
        subCommand = subCommand:lower();

        if (subCommand:lower() == "set" and not tk.Strings:IsNilOrWhiteSpace(profileName)) then
            db:SetProfile(profileName);

        elseif (subCommand:lower() == "current") then
            local currentProfile = db:GetCurrentProfile();
            currentProfile = tk.Strings:SetTextColor(currentProfile, "gold");
            tk:Print("Current Profile:", currentProfile);
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
    tk:Print("|cff00cc66/mui profile|r - shows profile manager");
    tk:Print("|cff00cc66/mui profile set <profile_name>|r - set profile");
    tk:Print("|cff00cc66/mui profile current|r - show current profile in chat");
    print(" ");
end

-- BaseModule Object -------------------

Engine:DefineReturns("string", "?boolean");
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

function BaseModule:Initialize(_, ...)
    if (self.OnInitialize) then
        self:OnInitialize(...);
    end

    local registryInfo = registeredModules[tostring(self)];
    registryInfo.initialized = true;

    -- execute all update functions
    self:ExecuteAllUpdateFunctions(self);

    -- Call any other functions attached to this modules OnInitialize event
    if (registryInfo.hooks and registryInfo.hooks.OnInitialize) then
        for _, func in ipairs(registryInfo.hooks.OnInitialize) do
            func(self, registryInfo.moduleData);
        end
    end
end

Engine:DefineReturns("string");
function BaseModule:GetModuleName(_)
    local registryInfo = registeredModules[tostring(self)];
    return registryInfo.moduleName;
end

Engine:DefineReturns("string");
function BaseModule:GetModuleKey(_)
    local registryInfo = registeredModules[tostring(self)];
    return registryInfo.moduleKey;
end

Engine:DefineParams("boolean");
function BaseModule:SetEnabled(data, enabled, ...)
    local registryInfo = registeredModules[tostring(self)];
    local hooks;

    registryInfo.enabled = enabled;

    if (enabled) then
        if (self.OnEnable) then
            self:OnEnable(...);
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
function BaseModule:IsInitialized()
    local registryInfo = registeredModules[tostring(self)];
    return registryInfo.initialized;
end

Engine:DefineReturns("boolean");
function BaseModule:IsInitializedOnDemand()
    local registryInfo = registeredModules[tostring(self)];
    return registryInfo.initializeOnDemand == true;
end

Engine:DefineReturns("boolean");
function BaseModule:IsEnabled()
    local registryInfo = registeredModules[tostring(self)];
    return registryInfo.enabled;
end

-- Hook more functions to a module event. Useful if module is spread across multiple files
function BaseModule:Hook(_, eventName, func)
    local registryInfo = registeredModules[tostring(self)];
    MayronUI:Hook(registryInfo.moduleName, eventName, func);
end

Engine:DefineReturns("string", "table|function");
function BaseModule:RegisterUpdateFunctions(data, path, updateFunctions)
    data.updateFunctionPaths = data.updateFunctionPaths or obj:PopWrapper();
    table.insert(data.updateFunctionPaths, path);

    db:RegisterUpdateFunctions(path, updateFunctions, function(func, value)
        if (self:IsEnabled() or func == data.updateFunctions.enabled) then
            func(value);
        end
    end);
end

do
    local function ExecuteAllUpdateFunctions(functionTable, settingsTable)
        -- if an enabled function is found, execute it first!
        if (settingsTable.enabled ~= nil and obj:IsFunction(functionTable.enabled)) then
            functionTable.enabled(settingsTable.enabled);
        end

        for key, functionValue in pairs(functionTable) do
            if (functionValue ~= functionTable.enabled) then
                local settingsValue = settingsTable[key];

                if (obj:IsFunction(functionValue)) then
                    functionValue(settingsValue);

                elseif (obj:IsTable(functionValue) and obj:IsTable(settingsValue)) then
                    ExecuteAllUpdateFunctions(functionValue, settingsValue);
                end
            end
        end
    end

    function BaseModule:ExecuteAllUpdateFunctions(data)
        if (obj:IsTable(data.updateFunctionPaths)) then
            for  _, path in ipairs(data.updateFunctionPaths) do
                local functionsTable = db:GetUpdateFunctions(path);
                local settingsTable = db:ParsePathValue(path):GetuntrackedTable();
                ExecuteAllUpdateFunctions(functionsTable, settingsTable);
            end
        end
    end
end

-- MayronUI Functions ---------------------

function MayronUI:PrintTable(tbl, depth)
    tk.Tables:Print(tbl, depth);
end

function MayronUI:Print(...)
    tk:Print(...);
end

function MayronUI:IsInstalled()
	return db.global.installed and db.global.installed[tk:GetPlayerKey()];
end

function MayronUI:TriggerCommand(commandName, ...)
    commands[commandName:lower()](...);
end

-- Hook more functions to a module event. Useful if module is spread across multiple files
function MayronUI:Hook(moduleName, eventName, func)
    local registryInfo = registeredModules[moduleName];

    if (not registryInfo) then
        -- addon is disabled so cannot hook
        return;
    end

    local eventHooks = tk.Tables:GetTable(registryInfo, "hooks", eventName);

    table.insert(eventHooks, func);
end

function MayronUI:ImportModule(moduleName)
    local registryInfo = registeredModules[moduleName];

    if (not registryInfo) then
        -- addon is disabled so cannot import module
        return nil;
    end

    return registryInfo and registryInfo.instance;
end

-- @param (optional) initializeOnDemand - if true, must be initialized manually instead of
--   MayronUI automatically initializing module during PLAYER_ENTERING_WORLD event
function MayronUI:RegisterModule(moduleKey, moduleName, initializeOnDemand)
    local ModuleClass = Engine:CreateClass(moduleKey, BaseModule);
    local moduleInstance = ModuleClass();

    -- must add it to the registeredModules table before calling parent constructor!
    registeredModules[moduleKey] = {};
    registeredModules[moduleKey].instance = moduleInstance;
    registeredModules[moduleKey].class = ModuleClass;

    moduleInstance:Super(moduleKey, moduleName, initializeOnDemand); -- call parent constructor

    -- Make it easy to iterate through modules
    table.insert(registeredModules, moduleInstance);

    return ModuleClass;
end

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
    local moduleList = obj:PopWrapper();

    for _, module in MayronUI:IterateModules() do
        table.insert(moduleList, module);
    end

    return moduleList;
end

function MayronUI:GetModuleNames()
    local moduleNamesList = obj:PopWrapper();

    for _, module in MayronUI:IterateModules() do
        table.insert(moduleNamesList, module:GetModuleName());
    end

    return moduleNamesList;
end

function MayronUI:GetModuleKeys()
    local moduleKeysList = obj:PopWrapper();

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
			return
        end

        local args = obj:PopWrapper();

		for _, arg in obj:IterateArgs(tk.string.split(' ', str)) do
			if (#arg > 0) then
                table.insert(args, arg);
			end
        end

        local path = commands;

		for id, arg in ipairs(args) do
            arg = string.lower(arg);

			if (path[arg]) then
				if (type(path[arg]) == "function") then
					path[arg](select(id + 1, tk.unpack(args)));
                    return

				elseif (type(path[arg]) == "table") then
                    path = path[arg];

				else
					commands.help();
                    return

                end
			else
				commands.help();
                return
			end
        end

        obj:PushWrapper(args);
    end

    tk:Print(L["Welcome back"], _G.UnitName("player").."!");
end

-- Initialize Modules after player enters world (not when DB starts!).
-- Some dependencies, like Bartender, only load after this event.
em:CreateEventHandler("PLAYER_ENTERING_WORLD", function()
    _G.FillLocalizedClassList(tk.Constants.LOCALIZED_CLASS_NAMES);

    if (not MayronUI:IsInstalled()) then
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

    -- TODO: This should be it's own Module
    namespace:SetupOrderHallBar();

    tk.collectgarbage("collect");
end):SetAutoDestroy(true);

-- Database Event callbacks --------------------

db:OnProfileChange(function(self, newProfileName)
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

    tk:Print("Profile changed to: ", tk.Strings:SetTextColorByKey(newProfileName, "GOLDS"));
end);

db:OnStartUp(function(self)
    MayronUI.db = self;
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
    -- tk.Constants.AddOnStyle:EnableColorUpdates();
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

    if (tk.IsAddOnLoaded("Recount")) then
        if (db.global.reanchor) then
            _G.Recount_MainWindow:ClearAllPoints();
            _G.Recount_MainWindow:SetPoint("BOTTOMRIGHT", -2, 2);
            _G.Recount_MainWindow:SaveMainWindowPosition();

            db.global.reanchor = nil;
        end

        -- Reskin Recount Window
        gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, "LOW", _G.Recount_MainWindow);

        _G.Recount_MainWindow:SetClampedToScreen(true);
        _G.Recount_MainWindow.tl:SetPoint("TOPLEFT", -6, -5);
        _G.Recount_MainWindow.tr:SetPoint("TOPRIGHT", 6, -5);
    end

    tk.collectgarbage("collect");
end);