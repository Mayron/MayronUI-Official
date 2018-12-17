local _, Core = ...;
local tk = Core.Toolkit;

tk.UIParent, tk._G, tk.hooksecurefunc, tk.tostringall = UIParent, _G, hooksecurefunc, tostringall;
tk.table, tk.string, tk.math, tk.tostring, tk.tonumber, tk.date = table, string, math, tostring, tonumber, date;
tk.rawset, tk.rawget, tk.setmetatable, tk.getmetatable = rawset, rawget, setmetatable, getmetatable;
tk.pairs, tk.ipairs, tk.next, tk.type, tk.select, tk.unpack = pairs, ipairs, next, type, select, unpack;
tk.collectgarbage, tk.print, tk.pcall, tk.C_Timer, tk.bit = collectgarbage, print, pcall, C_Timer, bit;
tk.CreateFrame, tk.CreateFont, tk.strsplit, tk.PlaySound = CreateFrame, CreateFont, strsplit, PlaySound;
tk.InCombatLockdown, tk.PlaySoundFile, tk.IsAddOnLoaded = InCombatLockdown, PlaySoundFile, IsAddOnLoaded;
tk.LoadAddOn, tk.UIFrameFadeOut, tk.UIFrameFadeIn, tk.assert = LoadAddOn, UIFrameFadeOut, UIFrameFadeIn, assert;
tk.StaticPopupDialogs, tk.StaticPopup_Show, tk.GetTime = StaticPopupDialogs, StaticPopup_Show, GetTime;
tk.SetCVar, tk.GetCVar = SetCVar, GetCVar;

tk.Constants = {
    ASSETS_FOLDER = "Interface\\addons\\MUI_Core\\Assets";
    CLICK = 856;
    DUMMY_FUNC = function() end;
    DUMMY_FRAME = _G.CreateFrame("Frame");
    LOCALIZED_CLASS_NAMES = {};

    FONT = function()
        return tk.Constants.LSM:Fetch("font", Core.Database.global.core.font);
    end;

    LSM = _G.LibStub("LibSharedMedia-3.0");

    BACKDROP = {
        edgeFile = "interface\\addons\\MUI_Core\\Assets\\Borders\\Solid",
        edgeSize = 1,
    };

    ORDERED_FRAME_STRATAS = {
        -- Index table ordered by strata level
        "BACKGROUND";
        "LOW";
        "MEDIUM";
        "HIGH";
        "DIALOG";
        "FULLSCREEN";
        "FULLSCREEN_DIALOG";
        "TOOLTIP";
    };

    FRAME_STRATAS = {
        -- hash-table (key/value pair) version:
        BACKGROUND          = "BACKGROUND";
        LOW                 = "LOW";
        MEDIUM              = "MEDIUM";
        HIGH                = "HIGH";
        DIALOG              = "DIALOG";
        FULLSCREEN          = "FULLSCREEN";
        FULLSCREEN_DIALOG   = "FULLSCREEN_DIALOG";
        TOOLTIP             = "TOOLTIP";
    };

    CLASS_COLORS = {
        DEATHKNIGHT   = _G.CreateColor(196/255, 31/255,59/255);
        DEMONHUNTER   = _G.CreateColor(163/255, 48/255, 201/255);
        DRUID         = _G.CreateColor(1, 125/255, 10/255);
        HUNTER        = _G.CreateColor(171/255, 212/255, 115/255);
        MAGE          = _G.CreateColor(105/255, 204/255, 240/255);
        MONK          = _G.CreateColor(0, 1, 150/255),
        PALADIN       = _G.CreateColor(245/255, 140/255, 186/255);
        PRIEST        = _G.CreateColor(1, 1, 1);
        ROGUE         = _G.CreateColor(1, 245/255, 105/255);
        SHAMAN        = _G.CreateColor(0, 112/255, 222/255);
        WARLOCK       = _G.CreateColor(148/255, 130/255, 201/255);
        WARRIOR       = _G.CreateColor(199/255, 156/255, 110/255);
    };

    -- Blizzard global colors are tables containing r, g, b, keys and functions such as:
    -- GetRGB(), GetRGBA(), WrapTextInColorCode(), GenerateHexColor(), and more...
    COLORS = {
        ARTIFACT_GOLD   = _G.ARTIFACT_BAR_COLOR;
        BATTLE_NET_BLUE = _G.BATTLENET_FONT_COLOR;
        BLACK           = _G.BLACK_FONT_COLOR;
        DIM_GREEN       = _G.DIM_GREEN_FONT_COLOR;
        DIM_RED         = _G.DIM_RED_FONT_COLOR;
        DULL_RED        = _G.DIM_RED_FONT_COLOR;
        GOLD            = _G.NORMAL_FONT_COLOR;
        GRAY            = _G.DISABLED_FONT_COLOR;
        GREEN           = _G.GREEN_FONT_COLOR;
        LIGHT_YELLOW    = _G.LIGHTYELLOW_FONT_COLOR;
        ORANGE          = _G.ORANGE_FONT_COLOR;
        PARTY_CHAT_BLUE = _G.LIGHTBLUE_FONT_COLOR;
        RED             = _G.RED_FONT_COLOR;
        TRANSMOG_VIOLET = _G.TRANSMOGRIFY_FONT_COLOR;
        WHITE           = _G.HIGHLIGHT_FONT_COLOR;
        YELLOW          = _G.YELLOW_FONT_COLOR;
    };
};