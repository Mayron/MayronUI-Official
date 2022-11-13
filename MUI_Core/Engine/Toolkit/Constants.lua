-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI; ---@type MayronUI
local LibStub = _G.LibStub;
local tk, db, _, _, _, L = MayronUI:GetCoreComponents();

function tk:IsRetail()
  return _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE;
end

function tk:IsClassic()
  return _G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC;
end

function tk:IsBCClassic()
  return _G.WOW_PROJECT_ID == _G.WOW_PROJECT_BURNING_CRUSADE_CLASSIC;
end

function tk:IsWrathClassic()
  return _G.WOW_PROJECT_ID == _G.WOW_PROJECT_WRATH_CLASSIC;
end

tk.Constants = {
  DRAGONFLIGHT_BAR_LAYOUT_PATCH = "DragonflightBarLayout_V2";
  ASSETS_FOLDER = "Interface\\addons\\MUI_Core\\Assets";
  CLICK = 856;
  MENU_OPENED_CLICK = 852;
  DUMMY_FUNC = function() end;
  DUMMY_FRAME = _G.CreateFrame("Frame");
  LOCALIZED_CLASS_NAMES = {};
  LOCALIZED_CLASS_FEMALE_NAMES = {};
  SOLID_TEXTURE = "Interface\\Buttons\\WHITE8X8";

  FONT = function()
    return tk.Constants.LSM:Fetch("font", db.global.core.font);
  end;

  LSM = LibStub("LibSharedMedia-3.0");

  BACKDROP = {
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1.25,
  };

  BACKDROP_WITH_BACKGROUND = {
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "interface\\addons\\MUI_Core\\Assets\\Borders\\Solid",
    edgeSize = 1.25,
  };

  -- Used for drop down options only!
  POINT_OPTIONS = {
    [L["Left"]] = "LEFT";
    [L["Center"]] = "CENTER";
    [L["Right"]] = "RIGHT";
    [L["Top"]] = "TOP";
    [L["Bottom"]] = "BOTTOM";
    [L["Top Left"]] = "TOPLEFT";
    [L["Top Right"]] = "TOPRIGHT";
    [L["Bottom Left"]] = "BOTTOMLEFT";
    [L["Bottom Right"]] = "BOTTOMRIGHT";
  };

  POINTS = {
    ["Left"] = "LEFT";
    ["Center"] = "CENTER";
    ["Right"] = "RIGHT";
    ["Top"] = "TOP";
    ["Bottom"] = "BOTTOM";
    ["Top Left"] = "TOPLEFT";
    ["Top Right"] = "TOPRIGHT";
    ["Bottom Left"] = "BOTTOMLEFT";
    ["Bottom Right"] = "BOTTOMRIGHT";
  };

  FONT_FLAG_DROPDOWN_OPTIONS = {
    [L["None"]] = "None",
    [L["Outline"]] = "OUTLINE",
    [L["Thick Outline"]] = "THICKOUTLINE",
    [L["Monochrome"]] = "MONOCHROME"
  };

  ORDERED_POINTS = {
    -- Index table ordered by strata level
    "LEFT";
    "CENTER";
    "RIGHT";
    "TOP";
    "BOTTOM";
    "TOPLEFT";
    "TOPRIGHT";
    "BOTTOMLEFT";
    "BOTTOMRIGHT";
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

  RESKIN_FLAGS = {
    BACKGROUND = 2;
    BORDER = 4;
    ARTWORK = 8;
    OVERLAY = 16;
    HIGHLIGHT = 32;
    CREATE_BACKGROUND = 64;
  };

  POWER_TYPES = {
    [0] =  "MANA";
    [1] =  "RAGE";
    [2] =  "FOCUS";
    [3] =  "ENERGY";
    [4] =  "CHI";
    [5] =  "RUNES";
    [6] =  "RUNIC_POWER";
    [7] =  "SOUL_SHARDS";
    [8] =  "LUNAR_POWER";
    [9] =  "HOLY_POWER";
    [11] = "MAELSTROM";
    [13] = "INSANITY";
    [17] = "FURY";
    [18] = "PAIN";
  };

  CLASS_IDS = {
    [1] = "WARRIOR",
    [2] = "PALADIN",
    [3] = "HUNTER",
    [4] = "ROGUE",
    [5] = "PRIEST",
    [6] = "DEATHKNIGHT",
    [7] = "SHAMAN",
    [8] = "MAGE",
    [9] = "WARLOCK",
    [10] = "MONK",
    [11] = "DRUID",
    [12] = "DEMONHUNTER",
  };

  CLASS_FILE_NAMES = {
    WARRIOR = "WARRIOR",
    PALADIN = "PALADIN",
    HUNTER = "HUNTER",
    ROGUE = "ROGUE",
    PRIEST = "PRIEST",
    DEATHKNIGHT = "DEATHKNIGHT",
    SHAMAN = "SHAMAN",
    MAGE = "MAGE",
    WARLOCK = "WARLOCK",
    MONK = "MONK",
    DRUID = "DRUID",
    DEMONHUNTER = "DEMONHUNTER",
  };

  FACTION_BAR_COLORS = {
    [1] = {r = 0.8, g = 0.3, b = 0.22}; -- Exceptionally hostile
    [2] = {r = 0.8, g = 0.3, b = 0.22}; -- Very Hostile
    [3] = {r = 0.75, g = 0.27, b = 0}; -- Hostile
    [4] = {r = 0.9, g = 0.7, b = 0}; -- Neutral
    [5] = {r = 0, g = 0.6, b = 0.1}; -- Friendly
    [6] = {r = 0, g = 0.6, b = 0.1}; -- Very Friendly
    [7] = {r = 0, g = 0.6, b = 0.1}; -- Exceptionally friendly
    [8] = {r = 0, g = 0.6, b = 0.1}; -- Exalted
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

  FONT_TYPES = {
    GameFontNormal = "GameFontNormal";
    GameFontNormalSmall = "GameFontNormalSmall";
    GameFontNormalLarge = "GameFontNormalLarge";
    GameFontHighlight = "GameFontHighlight";
    GameFontHighlightSmall = "GameFontHighlightSmall";
    GameFontHighlightSmallOutline = "GameFontHighlightSmallOutline";
    GameFontHighlightLarge = "GameFontHighlightLarge";
    GameFontDisable = "GameFontDisable";
    GameFontDisableSmall = "GameFontDisableSmall";
    GameFontDisableLarge = "GameFontDisableLarge";
    GameFontGreen = "GameFontGreen";
    GameFontGreenSmall = "GameFontGreenSmall";
    GameFontGreenLarge = "GameFontGreenLarge";
    GameFontRed = "GameFontRed";
    GameFontRedSmall = "GameFontRedSmall";
    GameFontRedLarge = "GameFontRedLarge";
    GameFontWhite = "GameFontWhite";
    GameFontDarkGraySmall = "GameFontDarkGraySmall";
    NumberFontNormalYellow = "NumberFontNormalYellow";
    NumberFontNormalSmallGray = "NumberFontNormalSmallGray";
    QuestFontNormalSmall = "QuestFontNormalSmall";
    DialogButtonHighlightText = "DialogButtonHighlightText";
    ErrorFont = "ErrorFont";
    TextStatusBarText = "TextStatusBarText";
    CombatLogFont = "CombatLogFont";
  };

  SOUND_OPTIONS = {
    [L["Auction House Open"]] = 5274;
    [L["Auction House Close"]] = 5275;
    [L["Alarm Clock Warning 1"]] = 18871;
    [L["Alarm Clock Warning 2"]] = 12867;
    [L["Alarm Clock Warning 3"]] = 12889;
    [L["Enter Queue"]] = 8458;
    [L["Jewel Crafting Socket"]] = 10590;
    [L["Loot Money"]] = 120;
    [L["Map Ping"]] = 3175;
    [L["Queue Ready"]] = 8459;
    [L["Raid Warning"]] = 8959;
    [L["Raid Boss Warning"]] = 12197;
    [L["Ready Check"]] = 8960;
    [L["Repair Item"]] = 7994;
    [L["Whisper Received"]] = 3081;
    [L["None"]] = false;
  }
};

if (tk:IsRetail()) then
  tk.Constants.FOOD_DRINK_AURAS = {
    ["43180"] = true, -- food
    ["43182"] = true, -- drink
  };
else
  tk.Constants.FOOD_DRINK_AURAS = {
    -- classic drinks
    ["24355"] = true,
    ["1137"] = true,
    ["1135"] = true,
    ["1133"] = true,
    ["432"] = true,
    ["431"] = true,
    ["430"] = true,

    -- classic foods
    ["1131"] = true,
    ["1127"] = true,
    ["5006"] = true,
    ["24800"] = true,
    ["18233"] = true,
    ["434"] = true,
    ["5004"] = true,
    ["22731"] = true,
    ["435"] = true,
    ["5007"] = true,
    ["10256"] = true,
    ["18230"] = true,
    ["25660"] = true,
    ["10257"] = true,
    ["18234"] = true,
    ["5005"] = true,
    ["7737"] = true,
    ["18229"] = true,
  };
end

if (not tk:IsRetail()) then
  tk.Constants.CLASS_IDS[12] = nil;
  tk.Constants.CLASS_FILE_NAMES.DEMONHUNTER = nil;
  tk.Constants.CLASS_IDS[10] = nil;
  tk.Constants.CLASS_FILE_NAMES.MONK = nil;
end

if (not tk:IsWrathClassic() and not tk:IsRetail()) then
  tk.Constants.CLASS_IDS[6] = nil;
  tk.Constants.CLASS_FILE_NAMES.DEATHKNIGHT = nil;
end

if (tk:IsClassic()) then
  -- remove the Shaman Pink class color back to retail.
  local shamanColor = _G.RAID_CLASS_COLORS["SHAMAN"];
  shamanColor:SetRGB(0.0, 0.44, 0.87);
  shamanColor.colorStr = shamanColor:GenerateHexColor();
end

_G.BINDING_CATEGORY_MUI = "MayronUI";
_G.BINDING_NAME_MUI_SHOW_CONFIG_MENU = "Show Config Menu";
_G.BINDING_NAME_MUI_SHOW_LAYOUT_MENU = "Show Layout Menu";
_G.BINDING_NAME_MUI_SHOW_INSTALLER = "Show Installer";