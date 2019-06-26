local _, setup = ...;

setup.import["TipTac"] = function()
    local settings = {
        ["nameType"] = "title",
		["showRealm"] = "none",
		["classification_elite"] = "Level %s|cffffcc00 Elite",
		["barHeight"] = 15,
		["tipBackdropEdge"] = "Interface\\Buttons\\WHITE8X8",
		["aurasAtBottom"] = false,
		["backdropEdgeSize"] = 1,
		["hideFactionText"] = true,
		["powerBar"] = false,
		["fontFlags"] = "",
		["showAuraCooldown"] = false,
		["colReactBack7"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			0.730000019073486, -- [4]
		},
		["tipBorderColor"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			1, -- [4]
		},
		["powerBarText"] = "percent",
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
		["optionsBottom"] = 448.309631347656,
		["colReactBack2"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			0.730000019073486, -- [4]
		},
		["reactColoredBackdrop"] = false,
		["updateFreq"] = 0.5,
		["classification_trivial"] = "|rLevel %s",
		["anchorFrameUnitType"] = "mouse",
		["showDebuffs"] = false,
		["left"] = 1836.47619628906,
		["anchorFrameUnitPoint"] = "BOTTOMLEFT",
		["colReactText5"] = "|cff0dff00",
		["manaBar"] = false,
		["gradientColor"] = {
			0.8, -- [1]
			0.8, -- [2]
			0.8, -- [3]
			0.200000047683716, -- [4]
		},
		["showGuildRank"] = true,
		["barFontFace"] = "Interface\\addons\\MUI_Core\\Assets\\Fonts\\MayronUI.ttf",
		["fadeTime"] = 0,
		["targetYouText"] = "YOU",
		["auraSize"] = 20,
		["top"] = 24,
		["itemQualityBorder"] = true,
		["gradientTip"] = false,
		["showHiddenTipsOnShift"] = true,
		["colReactBack4"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			0.730000019073486, -- [4]
		},
		["barFontSize"] = 12,
		["selfAurasOnly"] = true,
		["iconAnchor"] = "TOPLEFT",
		["iconClass"] = false,
		["fontSizeDelta"] = 2,
		["if_iconSize"] = 42,
		["showTalents"] = true,
		["optionsLeft"] = 723.023986816406,
		["iconFaction"] = false,
		["overrideFade"] = true,
		["colReactBack3"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			0.730000019073486, -- [4]
		},
		["preFadeTime"] = 0,
		["colReactBack5"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			0.730000019073486, -- [4]
		},
		["hideWorldTips"] = true,
		["reactText"] = false,
		["showTarget"] = "last",
		["if_enable"] = true,
		["tipBackdropBG"] = "Interface\\ChatFrame\\ChatFrameBackground",
		["classification_worldboss"] = "Level %s|cffff0000 Boss",
		["tipColor"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			0.730000019073486, -- [4]
		},
		["hideDefaultBar"] = true,
		["healthBar"] = true,
		["colRace"] = "|cffddeeaa",
		["colReactText2"] = "|cffff1900",
		["anchorFrameTipType"] = "mouse",
		["auraMaxRows"] = 3,
		["colLevel"] = "|cffffcc00",
		["showUnitTip"] = true,
		["mouseOffsetX"] = 0,
		["reactColoredBorder"] = true,
		["colReactText6"] = "|cff00b9ff",
		["classification_minus"] = "-%s ",
		["mouseOffsetY"] = 0,
		["colSameGuild"] = "|cffff32ff",
		["modifyFonts"] = true,
		["iconCombat"] = false,
		["fontSize"] = 12,
		["anchorWorldTipType"] = "mouse",
		["classification_rareelite"] = "Level %s|cffffaaff Rare Elite",
		["colGuild"] = "|cff0869a9",
		["showBuffs"] = false,
		["manaBarText"] = "percent",
		["showTargetedBy"] = false,
		["barTexture"] = "Interface\\addons\\MUI_Core\\Assets\\Textures\\Widgets\\Button.tga",
		["iconRaid"] = false,
		["anchorWorldUnitPoint"] = "BOTTOMLEFT",
		["classification_normal"] = "Level %s",
		["backdropInsets"] = 0,
		["healthBarText"] = "percent",
		["showPlayerGender"] = false,
		["if_borderlessIcons"] = false,
		["anchorWorldTipPoint"] = "BOTTOMLEFT",
		["colorNameByClass"] = true,
		["talentFormat"] = 2,
		["classColoredBorder"] = false,
		["anchorWorldUnitType"] = "mouse",
		["healthBarColor"] = {
			0.3, -- [1]
			0.9, -- [2]
			0.3, -- [3]
			1, -- [4]
		},
		["gttScale"] = 0.949999988079071,
		["hideUFTipsInCombat"] = true,
		["colReactText4"] = "|cfff0ff00",
		["fontFace"] = "Interface\\addons\\MUI_Core\\Assets\\Fonts\\MayronUI.ttf",
		["colReactBack1"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			0.730000019073486, -- [4]
		},
		["noCooldownCount"] = false,
		["colReactBack6"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			0.730000019073486, -- [4]
		},
		["colReactText3"] = "|cffff7f00",
		["anchorFrameTipPoint"] = "BOTTOMLEFT",
		["hideAllTipsInCombat"] = true,
	};
    for k, v in pairs(settings) do
        _G.TipTac_Config[k] = v;
    end
end