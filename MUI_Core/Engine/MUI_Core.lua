-- Setup  -----------------------------

local addOnName, namespace = ...;

namespace.Database = LibStub:GetLibrary("LibMayronDB"):CreateDatabase(addOnName, "MayronUIdb");
namespace.EventManager = LibStub:GetLibrary("LibMayronEvents");
namespace.GUIBuilder = LibStub:GetLibrary("LibMayronGUI");
namespace.Objects = LibStub:GetLibrary("LibMayronObjects");
namespace.Locale = LibStub("AceLocale-3.0"):GetLocale("MayronUI");

MayronUI = {};

local db = namespace.Database;
local em = namespace.EventManager;
local tk = namespace.Toolkit;
local gui = namespace.GUIBuilder;
local obj = namespace.Objects;
local L = namespace.Locale;

local commands = {};
local registeredModules = {};
local modulesInitialized = false;

-- Objects  ---------------------------

local Engine = namespace.Objects:CreatePackage("Engine", "MayronUI");
local BaseModule = Engine:CreateClass("BaseModule");

-- Load Database Defaults -------------

db:AddToDefaults("global.core", {
    uiScale = 0.7,
    changeGameFont = true,
    font = "MUI_Font",
	useLocalization = true,
    addons = {    
        {"Aura Frames", true, "AuraFrames"},
        {"Bartender4", true, "Bartender4"},
        {"Grid", true, "Grid"},
        {"Masque", true, "Masque"},
        {"Mik Scrolling Battle Text", false, "MikScrollingBattleText"},
        {"Recount", true, "Recount"},
        {"Shadowed Unit Frames", true, "ShadowedUnitFrames"},
        {"TipTac", true, "TipTac"},
    }
});

local _, class = UnitClass("player");
db:AddToDefaults("profile.theme", {
    color = {
        r = tk.Constants.CLASS_RGB_COLORS[class].r,
        g = tk.Constants.CLASS_RGB_COLORS[class].g,
        b = tk.Constants.CLASS_RGB_COLORS[class].b,
        hex = tk.Constants.CLASS_RGB_COLORS[class].hex
    },
});

-- Slash Commands ------------------

commands = {
    ["config"] = function()
        if (not IsAddOnLoaded("MUI_Config")) then
            EnableAddOn("MUI_Config");

            if (not LoadAddOn("MUI_Config")) then
                tk:Print(L["Failed to load MUI_Config. Possibly missing?"]);
                return;
            end
        end
            
        local module = MayronUI:ImportModule("Config");  
        
        if (not module:IsInitialized()) then
            module:Initialize();
        end

        module:Show();
	end,
	["install"] = function()
        if (not IsAddOnLoaded("MUI_Setup")) then
            EnableAddOn("MUI_Setup");

            if (not LoadAddOn("MUI_Setup")) then
                tk:Print(L["Failed to load MUI_Setup. Possibly missing?"]);
                return;
            end
        end

        MayronUI:ImportModule("MUI_Setup"):Show();
	end,
	["help"] = function()
		tk.print(" ");
		tk:Print(L["List of slash commands:"])
		tk:Print("|cff00cc66/mui config|r - "..L["shows config menu"]);
		tk:Print("|cff00cc66/mui install|r - "..L["shows setup menu"]);
        tk.print(" ");
	end
};

-- BaseModule Object -------------------

Engine:DefineReturns("string", "?boolean");
function BaseModule:__Construct(data, moduleName, initializeOnDemand)
    local registryInfo = registeredModules[moduleName];
    registeredModules[tostring(self)] = registryInfo;
    
    registryInfo.moduleName = moduleName;
    registryInfo.initializeOnDemand = initializeOnDemand;
    registryInfo.initialized = false;
    registryInfo.enabled = false;
    registryInfo.moduleData = data;
end

function BaseModule:Initialize(data, ...)    
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
end

Engine:DefineReturns("string");
function BaseModule:GetModuleName(data)
    local registryInfo = registeredModules[tostring(self)];
    return registryInfo.moduleName;
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
function BaseModule:IsInitialized(data)
    local registryInfo = registeredModules[tostring(self)];
    return registryInfo.initialized;
end

Engine:DefineReturns("boolean");
function BaseModule:IsInitializedOnDemand(data)
    local registryInfo = registeredModules[tostring(self)];
    return registryInfo.initializeOnDemand == true;
end

Engine:DefineReturns("boolean");
function BaseModule:IsEnabled(data)
    local registryInfo = registeredModules[tostring(self)];
    return registryInfo.enabled;
end

-- Hook more functions to a module event. Useful if module is spread across multiple files
function BaseModule:Hook(data, eventName, func)
    local registryInfo = registeredModules[tostring(self)];
    MayronUI:Hook(registryInfo.moduleName, eventName, func);
end

-- Engine:DefineParams("LinkedList", "any");
-- function BaseModule:ConfigUpdate(data, linkedList, newValue)
--     registeredModules[tostring(self)].configUpdateCallback(self, data, linkedList, newValue);

--     -- Call any other functions attached to this modules OnConfigUpdate event
--     local hooks = registeredModules[tostring(self)].hooks["OnConfigUpdate"];
--     if (hooks) then
--         for _, func in ipairs(hooks) do
--             func(self, data);
--         end
--     end
-- end

-- MayronUI Functions ---------------------

function MayronUI:PrintTable(tbl, depth)
    tk.Tables:Print(tbl, depth);
end

function MayronUI:IsInstalled()
	return db.global.installed and db.global.installed[tk:GetPlayerKey()];
end

function MayronUI:GetCoreComponents()
    return tk, db, em, gui, obj, L;
end

function MayronUI:TriggerCommand(commandName)
    commands[commandName:lower()]();
end

-- Hook more functions to a module event. Useful if module is spread across multiple files
function MayronUI:Hook(moduleName, eventName, func)
    local registryInfo = registeredModules[moduleName];

    obj:Assert(registryInfo, "Cannot hook unregistered module '%s'.", moduleName);
    
    registryInfo.hooks = registryInfo.hooks or {};
    registryInfo.hooks[eventName] = registryInfo.hooks[eventName] or {};

    table.insert(registryInfo.hooks[eventName], func);
end

function MayronUI:ImportModule(moduleName)
    local registryInfo = registeredModules[moduleName];
    obj:Assert(registryInfo, "Failed to import unknown module '%s'.", moduleName);
    return registryInfo and registryInfo.instance;
end

-- @param (optional) initializeOnDemand - if true, must be initialized manually instead of 
--   MayronUI automatically initializing module during PLAYER_ENTERING_WORLD event
function MayronUI:RegisterModule(moduleName, initializeOnDemand)
    local ModuleClass = Engine:CreateClass(moduleName, BaseModule);
    local moduleInstance = ModuleClass();

    -- must add it to the registeredModules table before calling parent constructor!
    registeredModules[moduleName] = {};
    registeredModules[moduleName].instance = moduleInstance;

    moduleInstance:Super(moduleName, initializeOnDemand); -- call parent constructor

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

-- Register MUICore Module ---------------------

local CoreModule = MayronUI:RegisterModule("Core");

function CoreModule:OnInitialize(data)
    for i = 1, NUM_CHAT_WINDOWS do
        tk._G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false);
    end

    tk._G["SLASH_MUI1"] = "/mui";
	SlashCmdList.MUI = function(str)
        local args = {};
        
		if (#str == 0) then
			commands.help();
			return;
        end
        
		for _, arg in ipairs({tk.string.split(' ', str)}) do
			if (#arg > 0) then
                tk.table.insert(args, arg);
			end
        end
        
        local path = commands;
        
		for id, arg in tk.ipairs(args) do
            arg = tk.string.lower(arg);
            
			if (path[arg]) then
				if (tk.type(path[arg]) == "function") then
					path[arg](tk.select(id + 1, tk.unpack(args)));
                    return;
                    
				elseif (tk.type(path[arg]) == "table") then
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
    end
    
    tk:Print(L["Welcome back"], UnitName("player").."!");
end

local function PositionRecountWindow()
    if (db.global.reanchor) then
        Recount_MainWindow:ClearAllPoints();
        Recount_MainWindow:SetPoint("BOTTOMRIGHT", -2, 2);
        Recount_MainWindow:SaveMainWindowPosition();

        db.global.reanchor = nil;
    end

    -- Reskin Recount Window
    gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, "LOW", Recount_MainWindow);

    Recount_MainWindow:SetClampedToScreen(true);
    Recount_MainWindow.tl:SetPoint("TOPLEFT", -6, -5);
    Recount_MainWindow.tr:SetPoint("TOPRIGHT", 6, -5);    
end

-- Initialize Modules after player enters world (not when DB starts!).
-- Some dependencies, like Bartender, only load after this event.
em:CreateEventHandler("PLAYER_ENTERING_WORLD", function()
    FillLocalizedClassList(tk.Constants.LOCALIZED_CLASS_NAMES);    

    if (not MayronUI:IsInstalled()) then
        if ((tk.select(1, tk.LoadAddOn("MUI_Setup")))) then
            -- Load MUI_Setup if not installled
            MayronUI:ImportModule("MUI_Setup"):Initialize();
        end

		return;
    end

    for id, module in MayronUI:IterateModules() do
        local initializeOnDemand = module:IsInitializedOnDemand();

        if (not initializeOnDemand) then
            -- initialize a module if not set for manual initialization
            module:Initialize();
        end            
    end  

    -- TODO: This should be it's own Module
    namespace:SetupOrderHallBar();

    MayronUI.ModulesInitialized = true;
    tk.collectgarbage("collect");
end):SetAutoDestroy(true);

db:OnStartUp(function(self)
    MayronUI.db = self;
    local r, g, b = tk:GetThemeColor();
    local myFont = tk.CreateFont("MUI_FontNormal");

    myFont:SetFontObject("GameFontNormal");
    myFont:SetTextColor(r, g, b);
    myFont = tk.CreateFont("MUI_FontSmall");
    myFont:SetFontObject("GameFontNormalSmall");
    myFont:SetTextColor(r, g, b);
    myFont = tk.CreateFont("MUI_FontLarge");
    myFont:SetFontObject("GameFontNormalLarge");
    myFont:SetTextColor(r, g, b);

    -- To keep UI widget styles consistent ----------
    -- Can only use once Database is loaded...

    local Style = obj:Import("MayronUI.Widgets.Style");

    tk.Constants.AddOnStyle = Style();
    -- tk.Constants.AddOnStyle:EnableColorUpdates();
    tk.Constants.AddOnStyle:SetBackdrop(tk.Constants.backdrop, "DropDownMenu");
    tk.Constants.AddOnStyle:SetBackdrop(tk.Constants.backdrop, "ButtonBackdrop");
    tk.Constants.AddOnStyle:SetTexture(tk.Constants.MEDIA.."mui_bar", "ButtonTexture");
    tk.Constants.AddOnStyle:SetTexture(tk.Constants.MEDIA.."reskin\\arrow_down", "ArrowButtonTexture")
    tk.Constants.AddOnStyle:SetTexture(tk.Constants.MEDIA.."dialog_box\\Texture-", "DialogBoxBackground");
    tk.Constants.AddOnStyle:SetTexture(tk.Constants.MEDIA.."dialog_box\\TitleBar", "TitleBarBackground");
    tk.Constants.AddOnStyle:SetTexture(tk.Constants.MEDIA.."dialog_box\\CloseButton", "CloseButtonBackground");
    tk.Constants.AddOnStyle:SetTexture(tk.Constants.MEDIA.."dialog_box\\DragRegion", "DraggerTexture");
    tk.Constants.AddOnStyle:SetColor(r, g, b);

    -- Load Media using LibSharedMedia --------------

    local media = tk.Constants.LSM;

    media:Register(media.MediaType.FONT, "MUI_Font", tk.Constants.MEDIA.."font\\mui_font.ttf");
    media:Register(media.MediaType.FONT, "Imagine", tk.Constants.MEDIA.."font\\imagine.ttf");
    media:Register(media.MediaType.FONT, "Prototype", tk.Constants.MEDIA.."font\\prototype.ttf");
    media:Register(media.MediaType.STATUSBAR, "MUI_StatusBar", tk.Constants.MEDIA.."mui_bar.tga");
    media:Register(media.MediaType.BORDER, "Skinner", tk.Constants.MEDIA.."borders\\skinner.tga");
    media:Register(media.MediaType.BORDER, "Glow", tk.Constants.MEDIA.."borders\\glow.tga");

    -- Set Master Game Font Here! -------------------

    if (self.global.core.changeGameFont ~= false) then
        tk:SetGameFont(media:Fetch("font", self.global.core.font));
    end

    if (tk.IsAddOnLoaded("Recount")) then
        PositionRecountWindow();
    end

    tk.collectgarbage("collect");
end);