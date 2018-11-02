local _, Core = ...;
local tk = Core.Toolkit;
tk.Constants = {};

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

tk.Constants.MEDIA = "Interface\\AddOns\\MUI_Core\\media\\";
tk.Constants.CLICK = 856;
tk.Constants.DUMMY_FUNC = function() end;
tk.Constants.DUMMY_FRAME = CreateFrame("Frame");
tk.Constants.LOCALIZED_CLASS_NAMES = {};

tk.Constants.FONT = function()
    return tk.Constants.LSM:Fetch("font", core.Database.global.core.font);
end;

tk.Constants.LSM = LibStub("LibSharedMedia-3.0");

tk.Constants.backdrop = {
    edgeFile = "interface\\addons\\MUI_Core\\Media\\borders\\skinner",
    edgeSize = 1,
};

tk.Constants.FRAME_STRATA_VALUES = {
    "BACKGROUND",
    "LOW",
    "MEDIUM",
    "HIGH",
    "DIALOG",
    "FULLSCREEN",
    "FULLSCREEN_DIALOG",
    "TOOLTIP",
};

tk.Constants.CLASS_RGB_COLORS = {
    ["DEATHKNIGHT"] = {r = 196/255, g = 31/255, b = 59/255, hex = "C41F3B"},
    ["DEMONHUNTER"] = {r = 163/255, g = 48/255, b = 201/255, hex = "A330C9"},
    ["DRUID"] = {r = 1, g = 125/255, b = 10/255, hex = "FF7D0A"},
    ["HUNTER"] = {r = 171/255, g = 212/255, b = 115/255, hex = "ABD473"},
    ["MAGE"] = {r = 105/255, g = 204/255, b = 240/255, hex = "69CCF0"},
    ["MONK"] = {r = 0, g = 1, b = 150/255, hex = "00FF96"},
    ["PALADIN"] = {r = 245/255, g = 140/255, b = 186/255, hex = "F58CBA"},
    ["PRIEST"] = {r = 1, g = 1, b = 1, hex = "FFFFFF"},
    ["ROGUE"] = {r = 1, g = 245/255, b = 105/255, hex = "FFF569"},
    ["SHAMAN"] = {r = 0, g = 112/255, b = 222/255, hex = "0070DE"},
    ["WARLOCK"] = {r = 148/255, g = 130/255, b = 201/255, hex = "9482C9"},
    ["WARRIOR"] = {r = 199/255, g = 156/255, b = 110/255, hex = "C79C6E"},
};

tk.Constants.colors = {
    white = HIGHLIGHT_FONT_COLOR,
    red = RED_FONT_COLOR,
    yellow = YELLOW_FONT_COLOR,
    orange = ORANGE_FONT_COLOR,
    green = GREEN_FONT_COLOR,
    dim_red = DIM_RED_FONT_COLOR,
    grey = GRAY_FONT_COLOR,
    black = {0, 0, 0},

    unpack = function(self, color)
        local tbl = ((tk.type(color) == "string") and tk.Constants.colors[color]) or color;
        return tbl.r, tbl.g, tbl.b;
    end
};