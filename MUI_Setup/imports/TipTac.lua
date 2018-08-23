local _, setup = ...;

setup.import["TipTac"] = function()
    local settings = {
        ["fontFace"] = "Interface\\AddOns\\MUI_Core\\media\\font.ttf",
		["showRealm"] = "none",
		["colReactText4"] = "|cfff0ff00",
		["barHeight"] = 10,
		["tipBackdropEdge"] = "Interface\\Buttons\\WHITE8X8",
		["colReactBack1"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			1, -- [4]
		},
		["backdropEdgeSize"] = 1,
		["hideFactionText"] = true,
		["powerBar"] = false,
		["fontFlags"] = "",
		["showAuraCooldown"] = false,
		["colReactBack7"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			1, -- [4]
		},
		["tipBorderColor"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			1, -- [4]
		},
		["noCooldownCount"] = false,
		["colReactText1"] = "|cffc0c0c0",
		["healthBarClassColor"] = true,
		["barFontFlags"] = "OUTLINE",
		["if_infoColor"] = {
			1, -- [1]
			1, -- [2]
			1, -- [3]
			0.940000001341105, -- [4]
		},
		["classification_rare"] = "Level %s|cffff66ff Rare",
		["enableChatHoverTips"] = false,
		["colorGuildByReaction"] = true,
		["barsCondenseValues"] = true,
		["optionsBottom"] = 439.166687011719,
		["colReactText3"] = "|cffff7f00",
		["updateFreq"] = 0.5,
		["classification_trivial"] = "|rLevel %s",
		["colReactBack2"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			1, -- [4]
		},
		["anchorFrameUnitType"] = "normal",
		["showDebuffs"] = false,
		["manaBar"] = false,
		["gradientColor"] = {
			0.8, -- [1]
			0.8, -- [2]
			0.8, -- [3]
			0.200000047683716, -- [4]
		},
		["powerBarText"] = "percent",
		["top"] = 24,
		["fadeTime"] = 0,
		["targetYouText"] = "YOU",
		["gradientTip"] = false,
		["showGuildRank"] = true,
		["itemQualityBorder"] = true,
		["barFontFace"] = "Fonts\\FRIZQT__.TTF",
		["anchorFrameUnitPoint"] = "BOTTOMRIGHT",
		["colReactText5"] = "|cff0dff00",
		["barFontSize"] = 10,
		["gttScale"] = 0.949999988079071,
		["colReactBack3"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			1, -- [4]
		},
		["colReactBack4"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			1, -- [4]
		},
		["fontSizeDelta"] = 2,
		["selfAurasOnly"] = true,
		["classColoredBorder"] = false,
		["colReactBack5"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			1, -- [4]
		},
		["showHiddenTipsOnShift"] = true,
		["overrideFade"] = true,
		["if_enable"] = true,
		["preFadeTime"] = 0,
		["hideWorldTips"] = true,
		["if_iconSize"] = 42,
		["reactText"] = false,
		["showTarget"] = "last",
		["showTalents"] = true,
		["tipBackdropBG"] = "Interface\\ChatFrame\\ChatFrameBackground",
		["showUnitTip"] = true,
		["tipColor"] = {
			0.0784313725490196, -- [1]
			0.0784313725490196, -- [2]
			0.0784313725490196, -- [3]
			0.910000003874302, -- [4]
		},
		["hideDefaultBar"] = true,
		["healthBar"] = true,
		["colRace"] = "|cffddeeaa",
		["colReactText2"] = "|cffff1900",
		["mouseOffsetX"] = 0,
		["classification_normal"] = "Level %s",
		["colLevel"] = "|cffffcc00",
		["classification_worldboss"] = "Level %s|cffff0000 Boss",
		["reactColoredBorder"] = true,
		["anchorFrameTipType"] = "mouse",
		["colReactText6"] = "|cff00b9ff",
		["classification_minus"] = "-%s ",
		["mouseOffsetY"] = 0,
		["colSameGuild"] = "|cffff32ff",
		["modifyFonts"] = true,
		["optionsLeft"] = 722.008056640625,
		["fontSize"] = 12,
		["anchorWorldTipType"] = "normal",
		["classification_rareelite"] = "Level %s|cffffaaff Rare Elite",
		["colGuild"] = "|cff0869a9",
		["showBuffs"] = false,
		["manaBarText"] = "percent",
		["showTargetedBy"] = false,
		["barTexture"] = "Interface\\Addons\\Recount\\Textures\\statusbar\\Flat",
		["iconRaid"] = false,
		["anchorWorldUnitPoint"] = "BOTTOMRIGHT",
		["healthBarText"] = "percent",
		["backdropInsets"] = 0,
		["auraMaxRows"] = 3,
		["showPlayerGender"] = false,
		["if_borderlessIcons"] = false,
		["anchorWorldTipPoint"] = "BOTTOMRIGHT",
		["colorNameByClass"] = true,
		["talentFormat"] = 2,
		["auraSize"] = 20,
		["anchorWorldUnitType"] = "normal",
		["healthBarColor"] = {
			0.3, -- [1]
			0.9, -- [2]
			0.3, -- [3]
			1, -- [4]
		},
		["iconFaction"] = false,
		["hideUFTipsInCombat"] = true,
		["classification_elite"] = "Level %s|cffffcc00 Elite",
		["nameType"] = "title",
		["aurasAtBottom"] = true,
		["hideAllTipsInCombat"] = true,
		["colReactBack6"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			1, -- [4]
		},
		["left"] = 1836.47619628906,
		["anchorFrameTipPoint"] = "BOTTOM",
		["reactColoredBackdrop"] = false,
	};
    for k, v in pairs(settings) do
        TipTac_Config[k] = v;
    end
end