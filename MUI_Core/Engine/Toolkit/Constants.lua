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
    MEDIA = "Interface\\addons\\MUI_Core\\Media\\";
    CLICK = 856;
    DUMMY_FUNC = function() end;
    DUMMY_FRAME = _G.CreateFrame("Frame");
    LOCALIZED_CLASS_NAMES = {};

    FONT = function()
        return tk.Constants.LSM:Fetch("font", Core.Database.global.core.font);
    end;

    LSM = _G.LibStub("LibSharedMedia-3.0");

    BACKDROP = {
        edgeFile = "interface\\addons\\MUI_Core\\Media\\borders\\skinner",
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

    CLASS_RGB_COLORS = {
        DEATHKNIGHT   = {r = 196/255, g = 31/255, b = 59/255, hex = "C41F3B"};
        DEMONHUNTER   = {r = 163/255, g = 48/255, b = 201/255, hex = "A330C9"};
        DRUID         = {r = 1, g = 125/255, b = 10/255, hex = "FF7D0A"};
        HUNTER        = {r = 171/255, g = 212/255, b = 115/255, hex = "ABD473"};
        MAGE          = {r = 105/255, g = 204/255, b = 240/255, hex = "69CCF0"};
        MONK          = {r = 0, g = 1, b = 150/255, hex = "00FF96"},
        PALADIN       = {r = 245/255, g = 140/255, b = 186/255, hex = "F58CBA"};
        PRIEST        = {r = 1, g = 1, b = 1, hex = "FFFFFF"},
        ROGUE         = {r = 1, g = 245/255, b = 105/255, hex = "FFF569"};
        SHAMAN        = {r = 0, g = 112/255, b = 222/255, hex = "0070DE"};
        WARLOCK       = {r = 148/255, g = 130/255, b = 201/255, hex = "9482C9"};
        WARRIOR       = {r = 199/255, g = 156/255, b = 110/255, hex = "C79C6E"};
    };

    -- Blizzard global colors are tables containing r, g, b, keys and functions such as:
    -- GetRGB(), GetRGBA(), WrapTextInColorCode(), GenerateHexColor(), and more...
    BLIZZARD_COLORS = {
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