local _, setup = ...;

setup.import["TipTac"] = function()
  local settings = {
    ["fontFace"] = "Interface\\addons\\MUI_Core\\Assets\\Fonts\\MayronUI.ttf",
    ["showRealm"] = "none",
    ["colReactText4"] = "|cfff0ff00",
    ["barHeight"] = 15,
    ["tipBackdropEdge"] = "Interface\\Buttons\\WHITE8X8",
    ["colReactBack1"] = {
      0, -- [1]
      0, -- [2]
      0, -- [3]
      0.730000019073486, -- [4]
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
      0.730000019073486, -- [4]
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
    ["left"] = 1832.412841796875,
    ["updateFreq"] = 0.5,
    ["reactColoredBackdrop"] = false,
    ["hideAllTipsInCombat"] = false,
    ["classification_trivial"] = "|rLevel %s",
    ["anchorFrameTipPoint"] = "BOTTOMRIGHT",
    ["anchorFrameUnitPoint"] = "BOTTOMLEFT",
    ["optionsBottom"] = 448.309631347656,
    ["powerBarText"] = "percent",
    ["nameType"] = "title",
    ["manaBar"] = false,
    ["gradientColor"] = {
      0.8, -- [1]
      0.8, -- [2]
      0.8, -- [3]
      0.200000047683716, -- [4]
    },
    ["aurasAtBottom"] = false,
    ["showGuildRank"] = true,
    ["fadeTime"] = 0,
    ["targetYouText"] = "YOU",
    ["fontSizeDelta"] = 2,
    ["top"] = 28.06356620788574,
    ["itemQualityBorder"] = true,
    ["gradientTip"] = false,
    ["hideWorldTips"] = true,
    ["healthBarColor"] = {
      0.3, -- [1]
      0.9, -- [2]
      0.3, -- [3]
      1, -- [4]
    },
    ["barFontSize"] = 12,
    ["selfAurasOnly"] = true,
    ["iconAnchor"] = "TOPLEFT",
    ["talentFormat"] = 2,
    ["gttScale"] = 0.949999988079071,
    ["colorNameByClass"] = true,
    ["anchorWorldTipPoint"] = "BOTTOMLEFT",
    ["colReactBack5"] = {
      0, -- [1]
      0, -- [2]
      0, -- [3]
      0.730000019073486, -- [4]
    },
    ["iconFaction"] = false,
    ["overrideFade"] = true,
    ["colReactBack3"] = {
      0, -- [1]
      0, -- [2]
      0, -- [3]
      0.730000019073486, -- [4]
    },
    ["preFadeTime"] = 0,
    ["optionsLeft"] = 723.023986816406,
    ["if_enable"] = true,
    ["reactText"] = false,
    ["showTarget"] = "last",
    ["colReactText3"] = "|cffff7f00",
    ["tipBackdropBG"] = "Interface\\ChatFrame\\ChatFrameBackground",
    ["backdropInsets"] = 0,
    ["tipColor"] = {
      0, -- [1]
      0, -- [2]
      0, -- [3]
      0.730000019073486, -- [4]
    },
    ["hideDefaultBar"] = true,
    ["healthBar"] = true,
    ["healthBarText"] = "percent",
    ["colRace"] = "|cffddeeaa",
    ["anchorWorldUnitPoint"] = "BOTTOMLEFT",
    ["classification_normal"] = "Level %s",
    ["colLevel"] = "|cffffcc00",
    ["auraMaxRows"] = 3,
    ["iconRaid"] = false,
    ["colReactText6"] = "|cff00b9ff",
    ["reactColoredBorder"] = true,
    ["classification_minus"] = "-%s ",
    ["mouseOffsetY"] = 0,
    ["colSameGuild"] = "|cffff32ff",
    ["classification_rareelite"] = "Level %s|cffffaaff Rare Elite",
    ["iconCombat"] = false,
    ["fontSize"] = 12,
    ["anchorWorldTipType"] = "mouse",
    ["modifyFonts"] = true,
    ["colGuild"] = "|cff0869a9",
    ["showBuffs"] = false,
    ["manaBarText"] = "percent",
    ["showTargetedBy"] = false,
    ["barTexture"] = "Interface\\addons\\MUI_Core\\Assets\\Textures\\Widgets\\Button.tga",
    ["mouseOffsetX"] = 0,
    ["anchorFrameTipType"] = "normal",
    ["showUnitTip"] = true,
    ["classification_worldboss"] = "Level %s|cffff0000 Boss",
    ["colReactText2"] = "|cffff1900",
    ["showPlayerGender"] = false,
    ["if_borderlessIcons"] = false,
    ["showTalents"] = true,
    ["if_iconSize"] = 42,
    ["iconClass"] = false,
    ["classColoredBorder"] = false,
    ["anchorWorldUnitType"] = "mouse",
    ["colReactBack4"] = {
      0, -- [1]
      0, -- [2]
      0, -- [3]
      0.730000019073486, -- [4]
    },
    ["showHiddenTipsOnShift"] = true,
    ["hideUFTipsInCombat"] = false,
    ["auraSize"] = 20,
    ["barFontFace"] = "Interface\\addons\\MUI_Core\\Assets\\Fonts\\MayronUI.ttf",
    ["classification_elite"] = "Level %s|cffffcc00 Elite",
    ["colReactText5"] = "|cff0dff00",
    ["colReactBack6"] = {
      0, -- [1]
      0, -- [2]
      0, -- [3]
      0.730000019073486, -- [4]
    },
    ["showDebuffs"] = false,
    ["anchorFrameUnitType"] = "mouse",
    ["colReactBack2"] = {
      0, -- [1]
      0, -- [2]
      0, -- [3]
      0.730000019073486, -- [4]
    },
  };

  for k, v in pairs(settings) do
    _G.TipTac_Config[k] = v;
  end
end