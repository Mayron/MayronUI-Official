------------------------
-- Setup namespaces
------------------------
local addon_name, core = ...;
core.Database = LibStub:GetLibrary("LibMayronDB"):CreateDatabase("MUIdb", addon_name);

local db = core.Database;
local em = core.EventManager;
local tk = core.Toolkit;
local gui = core.GUI_Builder;

local private = {};
private.modules = {};

db:AddToDefaults("global.core", {
    uiScale = 0.7,
    change_game_font = true,
    font = "MUI_Font",
	use_localization = true,
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

------------------------
-- Core API
------------------------
MayronUI = {};
function MayronUI:ImportModule(name)
	for _, module in tk.ipairs(private.modules) do
		if (module.name == name) then
			return module.ns;
		end
	end
end

function MayronUI:IterateModules()
	local id = 0;
	local modules = {};
	for _, data in tk.ipairs(private.modules) do
        tk.table.insert(modules, data);
	end
	return function()
		id = id + 1;
		if (id <= #modules) then
			return id, modules[id];
		end
	end
end

function MayronUI:RegisterModule(name, namespace, initOnDemand)
    tk.table.insert(private.modules, {name = name, ns = namespace, initOnDemand = initOnDemand});
end

function MayronUI:InitializeModule(name)
    local module = MayronUI:ImportModule(name);
    module:init(name);
    return module;
end

function MayronUI:IsInstalled()
	return db.global.installed and db.global.installed[tk:GetPlayerKey()];
end

MayronUI:RegisterModule("MUI_Core", core);
local L = LibStub ("AceLocale-3.0"):GetLocale ("MayronUI");

core.commands = {
	["config"] = function()
        if (not tk.IsAddOnLoaded("MUI_Config")) then
            EnableAddOn("MUI_Config");
            if (not tk.LoadAddOn("MUI_Config")) then
                tk:Print(L["Failed to load MUI_Config. Possibly missing?"]);
                return;
            end
            MayronUI:ImportModule("Config"):init();
        end
        MayronUI:ImportModule("Config"):Show();
	end,
	["install"] = function()
        if (not tk.IsAddOnLoaded("MUI_Setup")) then
            local success = tk.LoadAddOn("MUI_Setup");
            if (not success) then return; end
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

function core:init()
	-- slash commands:
	tk._G["SLASH_RELOADUI1"] = "/rl";
	SlashCmdList.RELOADUI = ReloadUI;

    tk._G["SLASH_FRAMESTK1"] = "/fs";
	SlashCmdList.FRAMESTK = function()
        tk.LoadAddOn('Blizzard_DebugTools');
		FrameStackTooltip_Toggle();
    end

    for i = 1, NUM_CHAT_WINDOWS do
        tk._G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false);
    end

    tk._G["SLASH_MUI1"] = "/mui";
	SlashCmdList.MUI = function(str)
		local args = {};
		if (#str == 0) then
			core.commands.help();
			return;
		end
		for _, arg in tk:IterateArgs(tk.string.split(' ', str)) do
			if (#arg > 0) then
                tk.table.insert(args, arg);
			end
		end
		local path = core.commands;
		for id, arg in tk.ipairs(args) do
			arg = tk.string.lower(arg);
			if (path[arg]) then
				if (tk.type(path[arg]) == "function") then
					path[arg](tk.select(id + 1, tk.unpack(args)));
					return;
				elseif (tk.type(path[arg]) == "table") then
					path = path[arg];
				else
					core.commands.help();
					return;
				end
			else
				core.commands.help();
				return;
			end
		end
	end
    tk:Print(L["Welcome back"], UnitName("player").."!");
end

------------------------
-- Initialize Modules
------------------------
em:CreateEventHandler("PLAYER_ENTERING_WORLD", function()
    FillLocalizedClassList(tk.Constants.LOCALIZED_CLASS_NAMES);
	for _, module in tk.ipairs(private.modules) do
		if (module.ns.init and not module.initOnDemand) then
			module.ns:init(module.name);
		end
    end
    if (not MayronUI:IsInstalled()) then
        if ((tk.select(1, tk.LoadAddOn("MUI_Setup")))) then
            MayronUI:ImportModule("MUI_Setup"):Show();
        end
		return;
    else
        if (tk.IsAddOnLoaded("Recount")) then
            if (db.global.reanchor) then
                Recount_MainWindow:ClearAllPoints();
                Recount_MainWindow:SetPoint("BOTTOMRIGHT", -2, 2);
                Recount_MainWindow:SaveMainWindowPosition();
            end
            gui:CreateDialogBox(nil, "LOW", Recount_MainWindow);
            Recount_MainWindow:SetClampedToScreen(true);
            Recount_MainWindow.tl:SetPoint("TOPLEFT", -6, -5);
            Recount_MainWindow.tr:SetPoint("TOPRIGHT", 6, -5);
        end
        db.global.reanchor = nil;
    end
    core:SetupOrderHallBar();
    tk.collectgarbage("collect");
end):SetAutoDestroy(true);

db:OnStart(function(self)
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
    local media = tk.Constants.LSM;

    media:Register(media.MediaType.FONT, "MUI_Font", tk.Constants.MEDIA.."font\\mui_font.ttf");
    media:Register(media.MediaType.FONT, "Imagine", tk.Constants.MEDIA.."font\\imagine.ttf");
    media:Register(media.MediaType.FONT, "Prototype", tk.Constants.MEDIA.."font\\prototype.ttf");
    media:Register(media.MediaType.STATUSBAR, "MUI_StatusBar", tk.Constants.MEDIA.."mui_bar.tga");
    media:Register(media.MediaType.BORDER, "Skinner", tk.Constants.MEDIA.."borders\\skinner.tga");
    media:Register(media.MediaType.BORDER, "Glow", tk.Constants.MEDIA.."borders\\glow.tga");

    if (self.global.core.change_game_font ~= false) then
        tk:SetGameFont(media:Fetch("font", self.global.core.font));
    end
end);