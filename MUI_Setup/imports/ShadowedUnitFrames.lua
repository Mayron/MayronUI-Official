local _, setup = ...;

setup.import["ShadowedUnitFrames"] = function()
	local settings = {
		["global"] = {
			["infoID"] = 3,
		},
		["profiles"] = {
			["Default"] = {
				["powerColors"] = {
					["PAIN"] = {
						["b"] = 0,
						["g"] = 0,
						["r"] = 1,
					},
					["ECLIPSE_FULL"] = {
						["r"] = 0,
						["g"] = 0.32,
						["b"] = 0.43,
					},
					["LIGHTWELL"] = {
						["b"] = 0.8,
						["g"] = 0.8,
						["r"] = 0.8,
					},
					["BANKEDHOLYPOWER"] = {
						["r"] = 0.96,
						["g"] = 0.61,
						["b"] = 0.84,
					},
					["INSANITY"] = {
						["b"] = 0.8,
						["g"] = 0,
						["r"] = 0.4,
					},
					["STAGGER_RED"] = {
						["r"] = 1,
						["g"] = 0.42,
						["b"] = 0.42,
					},
					["COMBOPOINTS"] = {
						["b"] = 0,
						["g"] = 0.8,
						["r"] = 1,
					},
					["RUNES"] = {
						["r"] = 0.5,
						["g"] = 0.5,
						["b"] = 0.5,
					},
					["RUNEOFPOWER"] = {
						["r"] = 0.35,
						["g"] = 0.45,
						["b"] = 0.6,
					},
					["CHI"] = {
						["r"] = 0.71,
						["g"] = 1,
						["b"] = 0.92,
					},
					["MAELSTROM"] = {
						["b"] = 1,
						["g"] = 0.5,
						["r"] = 0,
					},
					["SOULSHARDS"] = {
						["b"] = 0.79,
						["g"] = 0.51,
						["r"] = 0.58,
					},
					["RUNIC_POWER"] = {
						["a"] = 1,
						["b"] = 0.866666666666667,
						["g"] = 0.603921568627451,
						["r"] = 0.431372549019608,
					},
					["STAGGER_YELLOW"] = {
						["r"] = 1,
						["g"] = 0.98,
						["b"] = 0.72,
					},
					["RAGE"] = {
						["a"] = 1,
						["r"] = 0.447058823529412,
						["g"] = 0,
						["b"] = 0.0196078431372549,
					},
					["POWER_TYPE_FEL_ENERGY"] = {
						["b"] = 0,
						["g"] = 0.98,
						["r"] = 0.878,
					},
					["ALTERNATE"] = {
						["a"] = 1,
						["r"] = 0.815,
						["g"] = 0.941,
						["b"] = 1,
					},
					["FOCUS"] = {
						["a"] = 1,
						["r"] = 0.611764705882353,
						["g"] = 0.431372549019608,
						["b"] = 0.235294117647059,
					},
					["DEMONICFURY"] = {
						["r"] = 0.58,
						["g"] = 0.51,
						["b"] = 0.79,
					},
					["FULLBURNINGEMBER"] = {
						["r"] = 0.88,
						["g"] = 0.09,
						["b"] = 0.062,
					},
					["ARCANECHARGES"] = {
						["b"] = 0.98,
						["g"] = 0.1,
						["r"] = 0.1,
					},
					["HAPPINESS"] = {
						["r"] = 0.5,
						["g"] = 0.9,
						["b"] = 0.7,
					},
					["ENERGY"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 0.866666666666667,
						["b"] = 0.219607843137255,
					},
					["MANA"] = {
						["a"] = 1,
						["r"] = 0.0823529411764706,
						["g"] = 0.474509803921569,
						["b"] = 1,
					},
					["AURAPOINTS"] = {
						["r"] = 1,
						["g"] = 0.8,
						["b"] = 0,
					},
					["FURY"] = {
						["b"] = 0.992,
						["g"] = 0.259,
						["r"] = 0.788,
					},
					["FUEL"] = {
						["r"] = 0.85,
						["g"] = 0.47,
						["b"] = 0.36,
					},
					["ECLIPSE_MOON"] = {
						["b"] = 0.9,
						["g"] = 0.52,
						["r"] = 0.3,
					},
					["BURNINGEMBERS"] = {
						["r"] = 0.58,
						["g"] = 0.51,
						["b"] = 0.79,
					},
					["AMMOSLOT"] = {
						["r"] = 0.85,
						["g"] = 0.6,
						["b"] = 0.55,
					},
					["LUNAR_POWER"] = {
						["b"] = 0.9,
						["g"] = 0.52,
						["r"] = 0.3,
					},
					["STAGGER_GREEN"] = {
						["r"] = 0.52,
						["g"] = 1,
						["b"] = 0.52,
					},
					["STATUE"] = {
						["r"] = 0.35,
						["g"] = 0.45,
						["b"] = 0.6,
					},
					["MUSHROOMS"] = {
						["r"] = 0.2,
						["g"] = 0.9,
						["b"] = 0.2,
					},
					["HOLYPOWER"] = {
						["b"] = 0.73,
						["g"] = 0.55,
						["r"] = 0.96,
					},
					["ECLIPSE_SUN"] = {
						["b"] = 0,
						["g"] = 1,
						["r"] = 1,
					},
					["SHADOWORBS"] = {
						["r"] = 0.58,
						["g"] = 0.51,
						["b"] = 0.79,
					},
				},
				["advanced"] = true,
				["healthColors"] = {
					["aggro"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0,
						["r"] = 0.749019607843137,
					},
					["static"] = {
						["a"] = 1,
						["r"] = 0.0901960784313726,
						["g"] = 0.0901960784313726,
						["b"] = 0.0901960784313726,
					},
					["neutral"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 0.843137254901961,
						["b"] = 0.2,
					},
					["enemyUnattack"] = {
						["r"] = 0.6,
						["g"] = 0.2,
						["b"] = 0.2,
					},
					["friendly"] = {
						["a"] = 1,
						["r"] = 0.203921568627451,
						["g"] = 0.63921568627451,
						["b"] = 0.125490196078431,
					},
					["healAbsorb"] = {
						["r"] = 0.68,
						["g"] = 0.47,
						["b"] = 1,
					},
					["yellow"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 0.858823529411765,
						["b"] = 0,
					},
					["tapped"] = {
						["r"] = 0.5,
						["g"] = 0.5,
						["b"] = 0.5,
					},
					["hostile"] = {
						["a"] = 1,
						["r"] = 0.764705882352941,
						["g"] = 0.0392156862745098,
						["b"] = 0.0470588235294118,
					},
					["green"] = {
						["a"] = 1,
						["r"] = 0.356862745098039,
						["g"] = 1,
						["b"] = 0,
					},
					["offline"] = {
						["r"] = 0.5,
						["g"] = 0.5,
						["b"] = 0.5,
					},
					["incAbsorb"] = {
						["r"] = 0.93,
						["g"] = 0.75,
						["b"] = 0.09,
					},
					["inc"] = {
						["r"] = 0,
						["g"] = 0.35,
						["b"] = 0.23,
					},
					["red"] = {
						["a"] = 1,
						["r"] = 0.749019607843137,
						["g"] = 0,
						["b"] = 0,
					},
				},
				["xpColors"] = {
					["normal"] = {
						["r"] = 0.58,
						["g"] = 0,
						["b"] = 0.55,
					},
					["rested"] = {
						["r"] = 0,
						["g"] = 0.39,
						["b"] = 0.88,
					},
				},
				["locked"] = true,
				["auraIndicators"] = {
					["updated"] = true,
					["filters"] = {
						["tl"] = {
							["curable"] = {
								["enabled"] = false,
								["duration"] = false,
							},
							["boss"] = {
								["enabled"] = false,
								["duration"] = false,
							},
						},
					},
					["indicators"] = {
						["tr"] = {
							["height"] = 12,
							["width"] = 12,
						},
						["tl"] = {
							["height"] = 12,
							["y"] = -3,
							["width"] = 12,
						},
						["c"] = {
							["showStack"] = false,
						},
						["br"] = {
							["anchorPoint"] = "CRI",
						},
					},
					["auras"] = {
						["Renew"] = "{indicator = '', group = \"Priest\", priority = 10, r = 1, g = 0.62, b = 0.88}",
						["Focus Magic"] = "{indicator = '', group = \"Mage\", priority = 10, r = 0.67, g = 0.76, b = 1.0}",
						["Shadow Protection"] = "{indicator = '', group = \"Priest\", priority = 10, r = 0.60, g = 0.18, b = 1.0}",
						["Regrowth"] = "{indicator = '', group = \"Druid\", priority = 10, r = 0.50, g = 1.0, b = 0.63}",
						["Hand of Sacrifice"] = "{icon=true;b=0;priority=0;r=0;group=\"Paladin\";indicator=\"tr\";g=0;iconTexture=\"Interface\\Icons\\Spell_Holy_SealOfSacrifice\";}",
						["Arcane Brilliance"] = "{indicator = '', group = \"Mage\", priority = 10, r = 0.10, g = 0.68, b = 0.88}",
						["Earth Shield"] = "{indicator = '', group = \"Shaman\", priority = 10, r = 0.26, g = 1.0, b = 0.26}",
						["Mark of the Wild"] = "{indicator = '', group = \"Druid\", priority = 10, r = 1.0, g = 0.33, b = 0.90}",
						["Riptide"] = "{indicator = '', group = \"Shaman\", priority = 10, r = 0.30, g = 0.24, b = 1.0}",
						["Wild Growth"] = "{indicator = '', group = \"Druid\", priority = 10, r = 0.51, g = 0.72, b = 0.77}",
						["Power Word: Shield"] = "{indicator = '', group = \"Priest\", priority = 10, r = 0.55, g = 0.69, b = 1.0}",
						["Soulstone Resurrection"] = "{indicator = '', group = \"Warlock\", priority = 10, r = 0.42, g = 0.21, b = 0.65}",
						["Power Word: Fortitude"] = "{indicator = '', group = \"Priest\", priority = 10, r = 0.58, g = 1.0, b = 0.50}",
						["Rejuvenation"] = "{indicator = '', group = \"Druid\", priority = 10, r = 0.66, g = 0.66, b = 1.0}",
						["Beacon of Light"] = "{r=0;g=0;indicator=\"tl\";b=0;group=\"Paladin\";priority=0;icon=true;iconTexture=\"InterfaceIconsAbility_Paladin_BeaconofLight\";}",
						["Lifebloom"] = "{indicator = '', group = \"Druid\", priority = 10, r = 0.07, g = 1.0, b = 0.01}",
					},
				},
				["positions"] = {
					["arenatarget"] = {
						["anchorPoint"] = "RT",
						["x"] = 2,
						["anchorTo"] = "$parent",
					},
					["mainassisttarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["targettargettarget"] = {
						["anchorPoint"] = "RC",
						["anchorTo"] = "#SUFUnittargettarget",
					},
					["arenatargettarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["arenapet"] = {
						["anchorPoint"] = "RB",
						["anchorTo"] = "$parent",
					},
					["mainassisttargettarget"] = {
						["anchorPoint"] = "RT",
						["x"] = 150,
						["anchorTo"] = "$parent",
					},
					["party"] = {
						["anchorPoint"] = "C",
						["x"] = -349.999994039536,
						["bottom"] = 125.894446708569,
						["y"] = -69.9999988079071,
						["top"] = 234.394423498521,
					},
					["maintanktarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["focus"] = {
						["y"] = 30,
						["anchorTo"] = "#SUFUnittargettarget",
						["point"] = "BOTTOM",
						["relativePoint"] = "TOP",
					},
					["target"] = {
						["y"] = -28.2,
						["x"] = 21.2,
						["point"] = "BOTTOMLEFT",
						["anchorTo"] = "#SUFUnittargettarget",
						["relativePoint"] = "TOPRIGHT",
					},
					["battlegroundtarget"] = {
						["anchorPoint"] = "RT",
						["x"] = 2,
						["anchorTo"] = "$parent",
					},
					["raid"] = {
						["top"] = 325.588113962103,
						["x"] = -349.999994039536,
						["bottom"] = 144.988277254985,
						["anchorPoint"] = "C",
						["y"] = -69.9999988079071,
					},
					["partytargettarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["arena"] = {
						["anchorPoint"] = "C",
						["x"] = 349.999994039536,
						["bottom"] = 400.924395027767,
						["y"] = -69.9999988079071,
						["top"] = 694.924347296368,
					},
					["battlegroundtargettarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["bosstargettarget"] = {
						["anchorPoint"] = "RB",
						["anchorTo"] = "$parent",
					},
					["maintanktargettarget"] = {
						["anchorPoint"] = "RT",
						["x"] = 150,
						["anchorTo"] = "$parent",
					},
					["bosstarget"] = {
						["anchorPoint"] = "RT",
						["x"] = 2,
						["anchorTo"] = "$parent",
					},
					["battlegroundpet"] = {
						["anchorPoint"] = "RB",
						["anchorTo"] = "$parent",
					},
					["pet"] = {
						["y"] = 10,
						["relativePoint"] = "TOP",
						["point"] = "BOTTOM",
						["anchorTo"] = "#SUFUnittargettarget",
					},
					["focustarget"] = {
						["y"] = 44.3799992442131,
						["point"] = "BOTTOM",
						["relativePoint"] = "BOTTOM",
					},
					["pettarget"] = {
						["anchorPoint"] = "C",
					},
					["player"] = {
						["y"] = -28.2,
						["x"] = -21.5,
						["point"] = "BOTTOMRIGHT",
						["anchorTo"] = "#SUFUnittargettarget",
						["relativePoint"] = "TOPLEFT",
					},
					["mainassist"] = {
						["anchorPoint"] = "C",
					},
					["targettarget"] = {
						["y"] = -100,
						["x"] = 100,
						["point"] = "TOP",
						["relativePoint"] = "TOP",
						["anchorTo"] = "UIParent",
					},
					["boss"] = {
						["anchorPoint"] = "C",
						["x"] = 349.999994039536,
						["bottom"] = 178.037770100359,
						["y"] = -69.9999988079071,
						["top"] = 472.037711687808,
					},
					["maintank"] = {
						["anchorPoint"] = "C",
					},
					["raidpet"] = {
						["anchorPoint"] = "C",
					},
					["battleground"] = {
						["anchorPoint"] = "C",
						["x"] = 349.999994039536,
						["bottom"] = 204.155590395321,
						["y"] = -69.9999988079071,
						["top"] = 435.155650548328,
					},
				},
				["revision"] = 59,
				["castColors"] = {
					["cast"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 0.701960784313726,
						["b"] = 0.301960784313726,
					},
					["finished"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
					["channel"] = {
						["r"] = 0.25,
						["g"] = 0.25,
						["b"] = 1,
					},
					["uninterruptible"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 0.36078431372549,
						["b"] = 0.152941176470588,
					},
					["interrupted"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
				},
				["loadedLayout"] = true,
				["hidden"] = {
					["playerAltPower"] = true,
				},
				["units"] = {
					["arenatarget"] = {
						["enabled"] = true,
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "none",
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["range"] = {
							["height"] = 0.5,
						},
						["width"] = 156,
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["text"] = {
							{
								["width"] = 1.7,
								["text"] = "[classcolor][abbrev:name]",
							}, -- [1]
							{
								["text"] = "[hp:color][perhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.8,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["enabled"] = false,
								["anchorPoint"] = "C",
								["size"] = 20,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["anchorTo"] = "$parent",
							},
							["height"] = 0.5,
						},
						["height"] = 41,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 0.2,
							["background"] = false,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
					},
					["mainassisttarget"] = {
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["anchorTo"] = "$parent",
							},
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["width"] = 150,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
						["height"] = 40,
						["text"] = {
							{
								["text"] = "[(()afk() )][name]",
							}, -- [1]
							nil, -- [2]
							{
								["text"] = "[level( )][classification( )][perpp]",
							}, -- [3]
							nil, -- [4]
							{
								["text"] = "[(()afk() )][name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
						},
						["highlight"] = {
							["size"] = 10,
						},
					},
					["targettargettarget"] = {
						["enabled"] = false,
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["anchorTo"] = "$parent",
							},
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["text"] = {
							{
								["width"] = 1,
							}, -- [1]
							{
								["text"] = "",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							nil, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["range"] = {
							["height"] = 0.5,
						},
						["width"] = 80,
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "RIGHT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["height"] = 30,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
					},
					["partytarget"] = {
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["anchorTo"] = "$parent",
							},
							["height"] = 0.5,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["range"] = {
							["height"] = 0.5,
						},
						["width"] = 90,
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["fader"] = {
							["height"] = 0.5,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["height"] = 25,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
					},
					["arenatargettarget"] = {
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 16,
							},
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
						},
						["highlight"] = {
							["size"] = 10,
						},
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["height"] = 0.6,
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
						},
						["width"] = 90,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
						["height"] = 25,
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
					},
					["battlegroundtarget"] = {
						["offset"] = 4,
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["enabled"] = false,
								["anchorPoint"] = "C",
								["size"] = 20,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["height"] = 0.5,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["text"] = {
							{
								["text"] = "[classcolor][abbrev:name]",
							}, -- [1]
							{
								["text"] = "[hp:color][perhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [8]
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["range"] = {
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["width"] = 156,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["enabled"] = true,
						["height"] = 41,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.2,
							["background"] = false,
							["invert"] = false,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "none",
						},
					},
					["arenapet"] = {
						["highlight"] = {
							["size"] = 10,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
						},
						["height"] = 25,
						["width"] = 90,
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
					},
					["mainassisttargettarget"] = {
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 16,
							},
						},
						["text"] = {
							{
								["text"] = "[(()afk() )][name]",
							}, -- [1]
							[3] = {
								["text"] = "[level( )][classification( )][perpp]",
							},
							[5] = {
								["text"] = "[(()afk() )][name]",
							},
						},
						["highlight"] = {
							["size"] = 10,
						},
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["height"] = 0.6,
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
						},
						["width"] = 150,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
						["height"] = 40,
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
					},
					["party"] = {
						["portrait"] = {
							["type"] = "3D",
							["fullBefore"] = 0,
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["order"] = 15,
							["isBar"] = false,
							["height"] = 0.5,
							["width"] = 0.2,
						},
						["showPlayer"] = false,
						["range"] = {
							["enabled"] = true,
							["oorAlpha"] = 0.5,
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["perRow"] = 3,
								["x"] = 198,
								["anchorPoint"] = "TL",
								["y"] = -31,
								["size"] = 24,
							},
							["debuffs"] = {
								["enabled"] = true,
								["x"] = -2,
								["anchorPoint"] = "LB",
								["y"] = 1,
								["maxRows"] = 5,
								["enlarge"] = {
									["SELF"] = false,
								},
								["perRow"] = 2,
								["size"] = 23,
							},
						},
						["castBar"] = {
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["autoHide"] = true,
							["order"] = 60,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 4,
								["size"] = 23,
							},
							["lfdRole"] = {
								["y"] = 4,
								["x"] = 16,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LT",
								["size"] = 14,
							},
							["resurrect"] = {
								["y"] = 2,
								["x"] = -30,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RC",
								["size"] = 28,
							},
							["masterLoot"] = {
								["y"] = -8,
								["x"] = 30,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["size"] = 12,
							},
							["leader"] = {
								["anchorPoint"] = "LT",
								["x"] = 31,
								["anchorTo"] = "$parent",
								["y"] = 5,
								["size"] = 14,
							},
							["role"] = {
								["y"] = 5,
								["x"] = 30,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 14,
							},
							["ready"] = {
								["anchorPoint"] = "RC",
								["x"] = -28,
								["anchorTo"] = "$parent",
								["y"] = 4,
								["size"] = 24,
							},
							["height"] = 0.5,
							["status"] = {
								["anchorPoint"] = "LB",
								["x"] = 12,
								["anchorTo"] = "$parent",
								["y"] = -2,
								["size"] = 16,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["anchorTo"] = "$parent",
							},
							["phase"] = {
								["anchorPoint"] = "TL",
								["x"] = 44,
								["anchorTo"] = "$parent",
								["y"] = -10,
								["size"] = 14,
							},
							["pvp"] = {
								["y"] = -20,
								["x"] = 58,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["size"] = 24,
							},
						},
						["incAbsorb"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["powerBar"] = {
							["predicted"] = true,
							["colorType"] = "type",
							["order"] = 20,
							["height"] = 0.2,
							["background"] = false,
							["invert"] = false,
							["onlyMana"] = false,
						},
						["height"] = 50,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["hideAnyRaid"] = true,
						["attribAnchorPoint"] = "LEFT",
						["offset"] = 8,
						["disableVehicle"] = false,
						["healthBar"] = {
							["colorType"] = "static",
							["height"] = 1.2,
							["order"] = 10,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "none",
						},
						["hideSemiRaid"] = false,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["enabled"] = false,
							["height"] = 0.4,
						},
						["unitsPerColumn"] = 5,
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["width"] = 200,
						["incHeal"] = {
							["height"] = 0.5,
							["cap"] = 1,
						},
						["text"] = {
							{
								["y"] = 2,
								["text"] = "[classcolor][name]",
								["x"] = 4,
								["width"] = 1,
							}, -- [1]
							{
								["y"] = -6,
								["text"] = "[curhp]",
								["x"] = -2,
								["width"] = 2,
							}, -- [2]
							{
								["y"] = 5,
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[(()afk() )][name]",
							}, -- [5]
							nil, -- [6]
							{
								["y"] = -14,
								["name"] = "NameText",
								["anchorTo"] = "$healthBar",
								["default"] = true,
								["width"] = 1,
							}, -- [7]
							{
								["y"] = 8,
								["x"] = -2,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["anchorPoint"] = "CRI",
								["width"] = 2,
							}, -- [8]
							{
								["anchorPoint"] = "BL",
								["x"] = 4,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
								["size"] = -1,
								["text"] = "[levelcolor][( )afk][( )status]",
								["y"] = 14,
								["width"] = 1,
							}, -- [9]
						},
						["fader"] = {
							["inactiveAlpha"] = 1,
							["height"] = 0.5,
						},
						["combatText"] = {
							["height"] = 0.5,
						},
						["columnSpacing"] = -30,
						["healAbsorb"] = {
							["height"] = 0.5,
						},
						["highlight"] = {
							["aggro"] = true,
							["height"] = 0.5,
							["alpha"] = 1,
							["size"] = 10,
						},
						["attribPoint"] = "TOP",
					},
					["maintanktarget"] = {
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["anchorTo"] = "$parent",
							},
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["width"] = 150,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
						["height"] = 40,
						["text"] = {
							{
								["text"] = "[(()afk() )][name]",
							}, -- [1]
							nil, -- [2]
							{
								["text"] = "[classification( )][perpp]",
							}, -- [3]
							nil, -- [4]
							{
								["text"] = "[(()afk() )][name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
						},
						["highlight"] = {
							["size"] = 10,
						},
					},
					["focus"] = {
						["portrait"] = {
							["type"] = "3D",
							["fullBefore"] = 0,
							["alignment"] = "RIGHT",
							["fullAfter"] = 100,
							["order"] = 0,
							["isBar"] = true,
							["height"] = 2.3,
							["width"] = 0.16,
						},
						["range"] = {
							["height"] = 0.5,
							["oorAlpha"] = 0.6,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["show"] = {
									["player"] = false,
								},
								["x"] = 30,
								["maxRows"] = 2,
								["anchorPoint"] = "RT",
								["y"] = -30,
								["perRow"] = 3,
								["size"] = 24,
							},
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 60,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["incAbsorb"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["powerBar"] = {
							["enabled"] = false,
							["predicted"] = true,
							["colorType"] = "type",
							["order"] = 25,
							["background"] = false,
							["invert"] = false,
							["height"] = 0.6,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["reactionType"] = "none",
							["height"] = 1.9,
							["background"] = true,
							["invert"] = false,
							["order"] = 0,
						},
						["indicators"] = {
							["raidTarget"] = {
								["y"] = -14,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["enabled"] = false,
								["anchorPoint"] = "C",
								["size"] = 30,
							},
							["lfdRole"] = {
								["y"] = -32,
								["x"] = 5,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RT",
								["size"] = 17,
							},
							["resurrect"] = {
								["y"] = -15,
								["x"] = -80,
								["anchorTo"] = "$parent",
								["enabled"] = false,
								["anchorPoint"] = "C",
								["size"] = 30,
							},
							["masterLoot"] = {
								["y"] = -10,
								["x"] = 16,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 12,
							},
							["leader"] = {
								["y"] = 17,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RB",
								["enabled"] = false,
								["size"] = 19,
							},
							["questBoss"] = {
								["y"] = -32,
								["x"] = 3,
								["anchorTo"] = "$parent",
								["enabled"] = false,
								["anchorPoint"] = "RT",
								["size"] = 22,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["anchorTo"] = "$parent",
							},
							["status"] = {
								["y"] = 9,
								["x"] = -21,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RC",
								["size"] = 16,
							},
							["height"] = 0.5,
							["role"] = {
								["y"] = -11,
								["x"] = 30,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 14,
							},
							["petBattle"] = {
								["enabled"] = false,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["y"] = -32,
								["anchorPoint"] = "RT",
								["size"] = 21,
							},
							["pvp"] = {
								["y"] = -21,
								["x"] = 11,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TR",
								["enabled"] = false,
								["size"] = 22,
							},
						},
						["emptyBar"] = {
							["height"] = 0.8,
							["order"] = 70,
							["background"] = true,
							["backgroundColor"] = {
								["r"] = 0.0980392156862745,
								["g"] = 0.0980392156862745,
								["b"] = 0.0980392156862745,
							},
							["reactionType"] = "none",
						},
						["text"] = {
							{
								["y"] = 1,
								["x"] = 0,
								["text"] = "[classcolor][abbrev:name]",
								["anchorPoint"] = "C",
								["width"] = 10,
							}, -- [1]
							{
								["y"] = 14,
								["x"] = 0,
								["text"] = "",
								["anchorPoint"] = "TRI",
								["width"] = 10,
							}, -- [2]
							{
								["width"] = 10,
								["text"] = "",
							}, -- [3]
							{
								["width"] = 2.5,
								["text"] = "",
							}, -- [4]
							{
								["anchorPoint"] = "CRI",
								["text"] = "[perpp][( )hp:color][( )perhp]",
								["x"] = -3,
							}, -- [5]
							nil, -- [6]
							{
								["y"] = 39,
								["x"] = -10,
								["name"] = "NameText",
								["anchorTo"] = "$healthBar",
								["anchorPoint"] = "TR",
								["default"] = true,
								["width"] = 10,
							}, -- [7]
							{
								["y"] = 26,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
								["anchorPoint"] = "TRI",
								["width"] = 10,
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["width"] = 100,
						["fader"] = {
							["inactiveAlpha"] = 1,
							["height"] = 0.5,
						},
						["height"] = 18,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = false,
							["order"] = 100,
						},
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["incHeal"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["healAbsorb"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
					},
					["target"] = {
						["portrait"] = {
							["enabled"] = true,
							["type"] = "3D",
							["fullAfter"] = 100,
							["order"] = 0,
							["isBar"] = true,
							["width"] = 0.21,
							["alignment"] = "RIGHT",
							["height"] = 2.4,
							["fullBefore"] = 0,
						},
						["range"] = {
							["height"] = 0.5,
							["oorAlpha"] = 0.4,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["perRow"] = 3,
								["anchorOn"] = false,
								["enlarge"] = {
									["REMOVABLE"] = false,
								},
								["anchorPoint"] = "RT",
								["x"] = 27,
								["enabled"] = true,
								["y"] = -30,
								["maxRows"] = 3,
								["size"] = 23,
							},
							["debuffs"] = {
								["perRow"] = 2,
								["anchorOn"] = false,
								["enlarge"] = {
									["SELF"] = false,
								},
								["y"] = 31,
								["x"] = -9,
								["anchorPoint"] = "BL",
								["maxRows"] = 2,
								["show"] = {
									["raid"] = false,
									["misc"] = false,
								},
								["size"] = 28,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -2,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["size"] = 2,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = false,
							},
							["autoHide"] = false,
							["order"] = 5,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 3.2,
						},
						["incAbsorb"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["powerBar"] = {
							["predicted"] = true,
							["colorType"] = "type",
							["reverse"] = false,
							["order"] = 25,
							["background"] = false,
							["invert"] = false,
							["height"] = 0.8,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["colorAggro"] = false,
							["height"] = 1.8,
							["order"] = 0,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "none",
						},
						["comboPoints"] = {
							["order"] = 99,
							["height"] = 0.5,
						},
						["text"] = {
							{
								["y"] = -5,
								["x"] = 4,
								["size"] = 3,
								["text"] = "[hp:color][perhp]",
								["anchorPoint"] = "TLI",
								["width"] = 10,
							}, -- [1]
							{
								["y"] = 13,
								["x"] = -2,
								["text"] = "[hp:color][curhp]",
								["anchorPoint"] = "TRI",
								["width"] = 10,
							}, -- [2]
							{
								["y"] = -19,
								["x"] = 0,
								["text"] = "[color:gensit]",
								["anchorPoint"] = "TL",
								["width"] = 10,
							}, -- [3]
							{
								["width"] = 2.5,
								["text"] = "",
							}, -- [4]
							{
								["y"] = 11,
								["x"] = 55,
								["anchorPoint"] = "TR",
								["size"] = 2,
							}, -- [5]
							nil, -- [6]
							{
								["y"] = 37,
								["x"] = -10,
								["name"] = "NameText",
								["anchorTo"] = "$healthBar",
								["anchorPoint"] = "TR",
								["default"] = true,
								["width"] = 10,
							}, -- [7]
							{
								["y"] = 26,
								["x"] = -2,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["anchorPoint"] = "TRI",
								["width"] = 10,
							}, -- [8]
							{
								["width"] = 10,
								["text"] = "[afk:time][status:time]",
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = -14,
								["size"] = 30,
							},
							["lfdRole"] = {
								["y"] = -32,
								["x"] = 4,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "RT",
								["size"] = 17,
							},
							["resurrect"] = {
								["anchorPoint"] = "C",
								["x"] = -80,
								["anchorTo"] = "$parent",
								["y"] = -15,
								["size"] = 30,
							},
							["masterLoot"] = {
								["y"] = 16,
								["x"] = -16,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BR",
								["enabled"] = false,
								["size"] = 12,
							},
							["leader"] = {
								["anchorPoint"] = "RB",
								["x"] = 2,
								["anchorTo"] = "$parent",
								["y"] = 17,
								["enabled"] = false,
								["size"] = 19,
							},
							["questBoss"] = {
								["y"] = 24,
								["x"] = 9,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BR",
								["enabled"] = false,
								["size"] = 22,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["anchorTo"] = "$parent",
							},
							["status"] = {
								["anchorPoint"] = "RC",
								["x"] = -21,
								["anchorTo"] = "$parent",
								["y"] = 9,
								["size"] = 17,
							},
							["height"] = 0.5,
							["role"] = {
								["y"] = -3,
								["x"] = -38,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BR",
								["enabled"] = false,
								["size"] = 14,
							},
							["petBattle"] = {
								["enabled"] = false,
								["x"] = -6,
								["anchorTo"] = "$parent",
								["y"] = 14,
								["anchorPoint"] = "BL",
								["size"] = 18,
							},
							["pvp"] = {
								["y"] = -25,
								["x"] = -43,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TR",
								["enabled"] = false,
								["size"] = 22,
							},
						},
						["width"] = 274,
						["emptyBar"] = {
							["height"] = 1.3,
							["background"] = false,
							["order"] = 0,
							["class"] = false,
							["backgroundColor"] = {
								["r"] = 0.0901960784313726,
								["g"] = 0.0901960784313726,
								["b"] = 0.0901960784313726,
							},
							["reactionType"] = "none",
						},
						["height"] = 60,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["combatText"] = {
							["enabled"] = false,
							["y"] = -9,
							["height"] = 0.5,
						},
						["incHeal"] = {
							["height"] = 0.5,
							["cap"] = 1,
						},
						["healAbsorb"] = {
							["height"] = 0.5,
						},
						["highlight"] = {
							["aggro"] = false,
							["height"] = 0.5,
							["mouseover"] = false,
							["size"] = 5,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
					},
					["raid"] = {
						["portrait"] = {
							["type"] = "3D",
							["fullBefore"] = 0,
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["order"] = 15,
							["isBar"] = false,
							["height"] = 0.5,
							["width"] = 0.22,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["enabled"] = true,
								["timers"] = {
									["SELF"] = false,
								},
								["anchorOn"] = false,
								["anchorPoint"] = "TR",
								["maxRows"] = 1,
								["perRow"] = 5,
								["show"] = {
									["misc"] = false,
									["relevant"] = false,
									["raid"] = false,
								},
								["y"] = -11,
								["x"] = -2,
								["size"] = 10,
							},
							["debuffs"] = {
								["enabled"] = true,
								["anchorOn"] = false,
								["enlarge"] = {
									["SELF"] = false,
								},
								["anchorPoint"] = "BL",
								["maxRows"] = 1,
								["show"] = {
									["misc"] = false,
									["player"] = false,
								},
								["y"] = 18,
								["x"] = 2,
								["perRow"] = 5,
								["size"] = 10,
							},
						},
						["incHeal"] = {
							["height"] = 0.5,
							["cap"] = 1,
						},
						["auraIndicators"] = {
							["enabled"] = true,
							["height"] = 0.5,
						},
						["range"] = {
							["enabled"] = true,
							["oorAlpha"] = 0.6,
							["height"] = 0.5,
						},
						["showParty"] = false,
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["columnSpacing"] = 2,
						["frameSplit"] = true,
						["groupSpacing"] = -34,
						["enabled"] = true,
						["incAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["reverse"] = false,
							["order"] = 20,
							["background"] = false,
							["invert"] = false,
							["height"] = 0.2,
						},
						["fader"] = {
							["height"] = 0.5,
						},
						["offset"] = 2,
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["healthBar"] = {
							["colorType"] = "static",
							["height"] = 2,
							["reactionType"] = "none",
							["background"] = true,
							["invert"] = false,
							["order"] = 10,
						},
						["hideSemiRaid"] = false,
						["text"] = {
							{
								["y"] = 2,
								["x"] = 0,
								["size"] = -1,
								["text"] = "[colorname]",
								["anchorPoint"] = "C",
								["width"] = 1,
							}, -- [1]
							{
								["y"] = -6,
								["text"] = "",
								["x"] = 0,
								["size"] = 1,
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[(()afk() )][name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["y"] = -10,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
								["text"] = "[afk][status]",
								["size"] = -1,
								["width"] = 1,
							}, -- [9]
						},
						["unitsPerColumn"] = 25,
						["highlight"] = {
							["debuff"] = true,
							["aggro"] = true,
							["mouseover"] = false,
							["height"] = 0.5,
							["attention"] = false,
							["alpha"] = 1,
							["size"] = 10,
						},
						["width"] = 70,
						["maxColumns"] = 8,
						["sortOrder"] = "DESC",
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["enabled"] = false,
							["height"] = 0.4,
						},
						["combatText"] = {
							["height"] = 0.5,
						},
						["height"] = 50,
						["healAbsorb"] = {
							["height"] = 0.5,
						},
						["groupsPerRow"] = 8,
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 22,
							},
							["lfdRole"] = {
								["y"] = -9,
								["size"] = 12,
								["anchorPoint"] = "TL",
								["anchorTo"] = "$parent",
							},
							["resurrect"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 26,
							},
							["masterLoot"] = {
								["anchorPoint"] = "TR",
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = -9,
								["size"] = 11,
							},
							["leader"] = {
								["y"] = -9,
								["x"] = 11,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["size"] = 14,
							},
							["role"] = {
								["anchorPoint"] = "TL",
								["x"] = 25,
								["anchorTo"] = "$parent",
								["y"] = -9,
								["size"] = 12,
							},
							["ready"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 22,
							},
							["height"] = 0.5,
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["anchorTo"] = "$parent",
							},
							["status"] = {
								["anchorPoint"] = "LB",
								["x"] = 12,
								["anchorTo"] = "$parent",
								["y"] = -2,
								["size"] = 16,
							},
							["pvp"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 11,
								["enabled"] = false,
								["size"] = 22,
							},
						},
					},
					["maintanktargettarget"] = {
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 16,
							},
						},
						["text"] = {
							{
								["text"] = "[(()afk() )][name]",
							}, -- [1]
							[3] = {
								["text"] = "[classification( )][perpp]",
							},
							[5] = {
								["text"] = "[(()afk() )][name]",
							},
						},
						["highlight"] = {
							["size"] = 10,
						},
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["height"] = 0.6,
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
						},
						["width"] = 150,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
						["height"] = 40,
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
					},
					["arena"] = {
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["range"] = {
							["enabled"] = true,
							["oorAlpha"] = 0.6,
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["perRow"] = 15,
								["x"] = 0,
								["y"] = -2,
								["anchorOn"] = false,
								["anchorPoint"] = "BL",
								["enlarge"] = {
									["REMOVABLE"] = false,
								},
								["enabled"] = true,
								["size"] = 22,
							},
							["debuffs"] = {
								["perRow"] = 9,
								["x"] = 0,
								["anchorOn"] = false,
								["anchorPoint"] = "BL",
								["show"] = {
									["player"] = false,
								},
								["y"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["enabled"] = true,
							["order"] = 60,
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["icon"] = "HIDE",
							["vertical"] = false,
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = false,
							},
							["reverse"] = false,
							["height"] = 0.6,
							["background"] = true,
							["invert"] = false,
							["autoHide"] = true,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["height"] = 0.2,
							["colorType"] = "type",
							["order"] = 20,
							["background"] = false,
						},
						["offset"] = 30,
						["healthBar"] = {
							["colorAggro"] = false,
							["order"] = 10,
							["colorType"] = "static",
							["reactionType"] = "npc",
							["reverse"] = false,
							["height"] = 1.2,
							["background"] = true,
							["invert"] = false,
							["vertical"] = false,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["width"] = 200,
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 12,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 25,
							},
							["lfdRole"] = {
								["y"] = 14,
								["x"] = 3,
								["anchorTo"] = "$parent",
								["enabled"] = false,
								["anchorPoint"] = "BR",
								["size"] = 14,
							},
							["height"] = 0.5,
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["anchorTo"] = "$parent",
							},
							["arenaSpec"] = {
								["y"] = 15,
								["x"] = -4,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LC",
								["size"] = 30,
							},
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["height"] = 60,
						["portrait"] = {
							["type"] = "3D",
							["fullBefore"] = 0,
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["order"] = 15,
							["isBar"] = true,
							["height"] = 0.5,
							["width"] = 0.22,
						},
						["text"] = {
							{
								["text"] = "[classcolor][abbrev:name]",
							}, -- [1]
							{
								["y"] = 6,
								["text"] = "[hp:color][curhp]",
								["width"] = 1,
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["y"] = -8,
								["x"] = -3,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["anchorPoint"] = "CRI",
								["width"] = 1,
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["enabled"] = true,
					},
					["partytargettarget"] = {
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 16,
							},
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
						},
						["highlight"] = {
							["size"] = 10,
						},
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["height"] = 0.6,
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
						},
						["width"] = 90,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
						["height"] = 25,
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
					},
					["battlegroundtargettarget"] = {
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 16,
							},
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
						},
						["highlight"] = {
							["size"] = 10,
						},
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["height"] = 0.6,
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
						},
						["width"] = 90,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
						["height"] = 25,
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
					},
					["bosstargettarget"] = {
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 16,
							},
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
						},
						["highlight"] = {
							["size"] = 10,
						},
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["height"] = 0.6,
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
						},
						["width"] = 90,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
						["height"] = 25,
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
					},
					["focustarget"] = {
						["enabled"] = false,
						["indicators"] = {
							["raidTarget"] = {
								["y"] = -6,
								["x"] = -38,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["enabled"] = false,
								["size"] = 30,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["anchorTo"] = "$parent",
							},
							["height"] = 0.5,
						},
						["portrait"] = {
							["fullBefore"] = 0,
							["type"] = "3D",
							["alignment"] = "RIGHT",
							["fullAfter"] = 100,
							["order"] = 0,
							["isBar"] = false,
							["height"] = 1,
							["width"] = 0.22,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["y"] = 3,
								["x"] = -1,
								["anchorPoint"] = "BL",
								["enlarge"] = {
									["SELF"] = false,
								},
								["maxRows"] = 1,
								["size"] = 15,
							},
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["text"] = {
							{
								["text"] = "[classcolor][abbrev:name]",
								["x"] = 0,
								["width"] = 10,
							}, -- [1]
							{
								["text"] = "",
								["x"] = 3,
								["width"] = 0,
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[(()afk() )][name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["range"] = {
							["height"] = 0.5,
						},
						["width"] = 110,
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["fader"] = {
							["height"] = 0.5,
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["height"] = 30,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["enabled"] = false,
							["colorType"] = "type",
							["height"] = 0.4,
							["background"] = true,
							["invert"] = false,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["height"] = 1.4,
							["reactionType"] = "none",
							["background"] = true,
							["invert"] = true,
							["order"] = 10,
						},
					},
					["bosstarget"] = {
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["range"] = {
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["height"] = 0.2,
							["colorType"] = "type",
							["order"] = 20,
							["background"] = false,
						},
						["offset"] = 20,
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "none",
						},
						["text"] = {
							{
								["text"] = "[classcolor][abbrev:name]",
							}, -- [1]
							{
								["text"] = "[hp:color][perhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["width"] = 156,
						["enabled"] = true,
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["enabled"] = false,
								["anchorPoint"] = "C",
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["anchorTo"] = "$parent",
							},
							["height"] = 0.5,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["height"] = 41,
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["attribAnchorPoint"] = "RIGHT",
						["attribPoint"] = "BOTTOM",
					},
					["battlegroundpet"] = {
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["highlight"] = {
							["size"] = 10,
						},
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [8]
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
						},
						["height"] = 25,
						["width"] = 90,
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
					},
					["targettarget"] = {
						["healthBar"] = {
							["colorType"] = "static",
							["reactionType"] = "none",
							["height"] = 1.4,
							["background"] = true,
							["invert"] = false,
							["order"] = 10,
						},
						["highlight"] = {
							["height"] = 0.5,
							["mouseover"] = false,
							["size"] = 10,
						},
						["text"] = {
							{
								["anchorPoint"] = "C",
								["text"] = "[classcolor][abbrev:name]",
								["x"] = 0,
								["width"] = 10,
							}, -- [1]
							{
								["width"] = 0,
								["text"] = "",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["size"] = -1,
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 0.9,
							["class"] = false,
							["backgroundColor"] = {
								["r"] = 0.0627450980392157,
								["g"] = 0.0627450980392157,
								["b"] = 0.0627450980392157,
							},
							["reactionType"] = "none",
						},
						["range"] = {
							["height"] = 0.5,
						},
						["width"] = 110,
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["x"] = -1,
								["y"] = 3,
								["enlarge"] = {
									["SELF"] = false,
								},
								["maxRows"] = 1,
								["size"] = 15,
							},
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 13,
								["x"] = 41,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["enabled"] = false,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["anchorTo"] = "$parent",
							},
							["height"] = 0.5,
						},
						["height"] = 28,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["enabled"] = false,
							["colorType"] = "type",
							["order"] = 20,
							["background"] = false,
							["height"] = 0.4,
							["predicted"] = true,
						},
						["portrait"] = {
							["fullBefore"] = 0,
							["type"] = "3D",
							["alignment"] = "RIGHT",
							["fullAfter"] = 100,
							["order"] = 15,
							["isBar"] = false,
							["height"] = 0.5,
							["width"] = 0.22,
						},
					},
					["partypet"] = {
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
							},
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["highlight"] = {
							["size"] = 10,
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["width"] = 90,
						["height"] = 25,
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
					},
					["pettarget"] = {
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
							},
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["width"] = 190,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
						["height"] = 30,
						["text"] = {
							nil, -- [1]
							nil, -- [2]
							{
								["text"] = "[perpp]",
							}, -- [3]
							nil, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 0.7,
							["background"] = true,
						},
						["highlight"] = {
							["size"] = 10,
						},
					},
					["player"] = {
						["xpBar"] = {
							["order"] = 60,
							["background"] = true,
							["height"] = 0.5,
						},
						["portrait"] = {
							["enabled"] = true,
							["type"] = "3D",
							["fullAfter"] = 100,
							["order"] = 0,
							["isBar"] = true,
							["width"] = 0.21,
							["alignment"] = "LEFT",
							["height"] = 2.4,
							["fullBefore"] = 0,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = -14,
								["size"] = 30,
							},
							["lfdRole"] = {
								["y"] = -32,
								["x"] = -3,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LT",
								["size"] = 17,
							},
							["resurrect"] = {
								["anchorPoint"] = "C",
								["x"] = -80,
								["anchorTo"] = "$parent",
								["y"] = -15,
								["size"] = 30,
							},
							["masterLoot"] = {
								["y"] = -13,
								["x"] = -24,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TC",
								["enabled"] = false,
								["size"] = 12,
							},
							["leader"] = {
								["anchorPoint"] = "LB",
								["x"] = -2,
								["anchorTo"] = "$parent",
								["y"] = 17,
								["enabled"] = false,
								["size"] = 19,
							},
							["role"] = {
								["y"] = 16,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
								["enabled"] = false,
								["size"] = 14,
							},
							["status"] = {
								["y"] = -32,
								["x"] = -18,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 21,
							},
							["ready"] = {
								["anchorPoint"] = "C",
								["x"] = 80,
								["anchorTo"] = "$parent",
								["y"] = -15,
								["size"] = 30,
							},
							["height"] = 0.5,
							["pvp"] = {
								["y"] = -25,
								["x"] = 50,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 22,
							},
						},
						["incHeal"] = {
							["height"] = 0.5,
							["cap"] = 1,
						},
						["shamanBar"] = {
							["order"] = 70,
							["background"] = true,
							["height"] = 0.3,
						},
						["height"] = 60,
						["totemBar"] = {
							["height"] = 0.5,
							["showAlways"] = true,
							["background"] = true,
							["order"] = 25,
						},
						["runeBar"] = {
							["enabled"] = true,
							["vertical"] = false,
							["reverse"] = false,
							["order"] = 100,
							["background"] = false,
							["invert"] = false,
							["height"] = 0.5,
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -2,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["size"] = 2,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["autoHide"] = false,
							["order"] = 5,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 3.2,
						},
						["priestBar"] = {
							["order"] = 70,
							["background"] = true,
							["height"] = 0.4,
						},
						["fader"] = {
							["combatAlpha"] = 1,
							["height"] = 0.5,
							["inactiveAlpha"] = 1,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["perRow"] = 7,
								["temporary"] = false,
								["anchorOn"] = false,
								["y"] = 26,
								["x"] = 9,
								["anchorPoint"] = "TL",
								["maxRows"] = 2,
								["show"] = {
									["misc"] = false,
									["consolidated"] = false,
									["raid"] = false,
								},
								["size"] = 28,
							},
							["debuffs"] = {
								["perRow"] = 3,
								["anchorOn"] = false,
								["enlarge"] = {
									["SELF"] = false,
								},
								["show"] = {
									["misc"] = false,
									["relevant"] = false,
									["raid"] = false,
								},
								["maxRows"] = 3,
								["enabled"] = true,
								["anchorPoint"] = "LT",
								["y"] = -30,
								["x"] = -27,
								["size"] = 23,
							},
						},
						["incAbsorb"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["comboPoints"] = {
							["anchorTo"] = "$parent",
							["order"] = 15,
							["showAlways"] = false,
							["growth"] = "LEFT",
							["anchorPoint"] = "RC",
							["x"] = -16,
							["isBar"] = false,
							["spacing"] = 4,
							["height"] = 0.4,
							["background"] = false,
							["y"] = -7,
							["size"] = 20,
						},
						["chi"] = {
							["anchorTo"] = "$parent",
							["order"] = 60,
							["showAlways"] = true,
							["growth"] = "LEFT",
							["anchorPoint"] = "RC",
							["x"] = -16,
							["spacing"] = 0,
							["height"] = 0.4,
							["isBar"] = false,
							["y"] = -7,
							["size"] = 20,
						},
						["soulShards"] = {
							["anchorTo"] = "$parent",
							["order"] = 30,
							["growth"] = "LEFT",
							["anchorPoint"] = "RC",
							["x"] = -16,
							["spacing"] = -4,
							["height"] = 0.7,
							["background"] = true,
							["y"] = -10,
							["size"] = 16,
						},
						["disableVehicle"] = false,
						["healthBar"] = {
							["colorType"] = "static",
							["colorAggro"] = false,
							["reactionType"] = "npc",
							["order"] = 15,
							["background"] = true,
							["invert"] = false,
							["height"] = 1.8,
						},
						["emptyBar"] = {
							["height"] = 3.2,
							["class"] = false,
							["reactionType"] = "none",
							["background"] = false,
							["backgroundColor"] = {
								["r"] = 1,
								["g"] = 1,
								["b"] = 1,
							},
							["order"] = 0,
						},
						["holyPower"] = {
							["anchorTo"] = "$parent",
							["order"] = 30,
							["isBar"] = false,
							["growth"] = "LEFT",
							["anchorPoint"] = "RC",
							["x"] = -16,
							["spacing"] = -4,
							["height"] = 0.4,
							["background"] = false,
							["y"] = -7,
							["size"] = 20,
						},
						["text"] = {
							{
								["size"] = 3,
								["text"] = "[hp:color][perhp]",
								["x"] = 4,
								["width"] = 10,
							}, -- [1]
							{
								["y"] = 14,
								["x"] = -2,
								["text"] = "[hp:color][curhp]",
								["anchorPoint"] = "TRI",
								["width"] = 10,
							}, -- [2]
							{
								["y"] = 7,
								["x"] = 2,
								["text"] = "",
								["anchorPoint"] = "TLI",
								["width"] = 10,
							}, -- [3]
							{
								["y"] = -20,
								["x"] = 2,
								["text"] = "",
								["anchorPoint"] = "TR",
								["width"] = 7,
							}, -- [4]
							{
								["y"] = 3,
								["x"] = -1,
							}, -- [5]
							nil, -- [6]
							{
								["y"] = 37,
								["x"] = 10,
								["name"] = "NameText",
								["anchorTo"] = "$healthBar",
								["anchorPoint"] = "TL",
								["width"] = 10,
							}, -- [7]
							{
								["y"] = 25,
								["x"] = -2,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["anchorPoint"] = "TRI",
								["width"] = 10,
							}, -- [8]
							{
								["width"] = 10,
								["text"] = "[afk:time]",
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
							{
								["name"] = "Text",
								["anchorTo"] = "$staggerBar",
								["text"] = "[monk:abs:stagger]",
								["default"] = true,
								["width"] = 1,
							}, -- [10]
							{
								["name"] = "Timer Text",
								["anchorTo"] = "$runeBar",
								["block"] = true,
								["default"] = true,
								["width"] = 1,
							}, -- [11]
							{
								["name"] = "Timer Text",
								["anchorTo"] = "$totemBar",
								["block"] = true,
								["default"] = true,
								["width"] = 1,
							}, -- [12]
							{
								["name"] = "Text",
								["anchorTo"] = "$staggerBar",
								["text"] = "[monk:abs:stagger]",
								["default"] = true,
								["width"] = 1,
							}, -- [13]
							{
								["name"] = "Timer Text",
								["anchorTo"] = "$runeBar",
								["block"] = true,
								["default"] = true,
								["width"] = 1,
							}, -- [14]
							{
								["name"] = "Timer Text",
								["anchorTo"] = "$totemBar",
								["block"] = true,
								["default"] = true,
								["width"] = 1,
							}, -- [15]
						},
						["druidBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 25,
							["enabled"] = true,
						},
						["width"] = 274,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.8,
							["background"] = false,
							["invert"] = false,
							["order"] = 25,
						},
						["highlight"] = {
							["debuff"] = false,
							["height"] = 0.5,
							["alpha"] = 1,
							["aggro"] = false,
							["attention"] = false,
							["mouseover"] = false,
							["size"] = 5,
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["enabled"] = false,
							["order"] = 100,
						},
						["combatText"] = {
							["y"] = -9,
							["enabled"] = false,
							["height"] = 0.5,
						},
						["staggerBar"] = {
							["vertical"] = false,
							["reverse"] = false,
							["height"] = 0.5,
							["background"] = false,
							["invert"] = false,
							["order"] = 100,
						},
						["healAbsorb"] = {
							["height"] = 0.5,
						},
						["arcaneCharges"] = {
							["anchorTo"] = "$parent",
							["order"] = 60,
							["showAlways"] = true,
							["growth"] = "LEFT",
							["anchorPoint"] = "BR",
							["x"] = -8,
							["spacing"] = -2,
							["height"] = 0.4,
							["y"] = 6,
							["size"] = 12,
						},
						["auraPoints"] = {
							["enabled"] = true,
							["anchorTo"] = "$parent",
							["order"] = 60,
							["showAlways"] = true,
							["growth"] = "LEFT",
							["y"] = -7,
							["x"] = -16,
							["spacing"] = -4,
							["height"] = 0.4,
							["isBar"] = false,
							["anchorPoint"] = "RC",
							["size"] = 20,
						},
					},
					["mainassist"] = {
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 60,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["powerBar"] = {
							["height"] = 1,
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
						},
						["offset"] = 5,
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["anchorTo"] = "$parent",
							},
							["resurrect"] = {
								["y"] = -1,
								["x"] = 37,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LC",
								["size"] = 28,
							},
						},
						["text"] = {
							{
								["text"] = "[(()afk() )][name]",
							}, -- [1]
							nil, -- [2]
							{
								["text"] = "[level( )][perpp]",
							}, -- [3]
							nil, -- [4]
							{
								["text"] = "[(()afk() )][name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["unitsPerColumn"] = 5,
						["width"] = 150,
						["maxColumns"] = 1,
						["height"] = 40,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["columnSpacing"] = 5,
						["incHeal"] = {
							["cap"] = 1,
						},
						["attribAnchorPoint"] = "LEFT",
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["highlight"] = {
							["size"] = 10,
						},
					},
					["pet"] = {
						["xpBar"] = {
							["order"] = 55,
							["background"] = true,
							["height"] = 0.25,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["range"] = {
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 60,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["incAbsorb"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["powerBar"] = {
							["enabled"] = false,
							["colorType"] = "type",
							["height"] = 0.4,
							["background"] = false,
							["invert"] = false,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 10,
							["reactionType"] = "none",
							["background"] = true,
							["invert"] = false,
							["height"] = 1.4,
						},
						["indicators"] = {
							["happiness"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "TR",
								["size"] = 14,
							},
							["height"] = 0.5,
							["raidTarget"] = {
								["y"] = -20,
								["x"] = -7,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TR",
								["enabled"] = false,
								["size"] = 20,
							},
						},
						["text"] = {
							{
								["anchorPoint"] = "C",
								["x"] = 0,
								["size"] = -1,
								["width"] = 10,
							}, -- [1]
							{
								["y"] = -50,
								["text"] = "",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 0.8,
							["order"] = 0,
						},
						["width"] = 100,
						["fader"] = {
							["height"] = 0.5,
							["inactiveAlpha"] = 0.4,
							["combatAlpha"] = 0.4,
						},
						["height"] = 18,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["incHeal"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["healAbsorb"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
					},
					["boss"] = {
						["portrait"] = {
							["type"] = "3D",
							["fullBefore"] = 0,
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["order"] = 15,
							["isBar"] = false,
							["height"] = 0.5,
							["width"] = 0.2,
						},
						["range"] = {
							["enabled"] = true,
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["perRow"] = 15,
								["x"] = 0,
								["anchorOn"] = false,
								["y"] = -2,
								["anchorPoint"] = "BL",
								["enabled"] = true,
								["size"] = 22,
							},
							["debuffs"] = {
								["perRow"] = 8,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["y"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["enabled"] = true,
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = -1,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = -1,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["autoHide"] = true,
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["predicted"] = true,
							["colorType"] = "type",
							["order"] = 20,
							["background"] = false,
							["invert"] = false,
							["height"] = 0.2,
						},
						["offset"] = 30,
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 10,
							["height"] = 1.2,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "none",
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["width"] = 200,
						["text"] = {
							{
								["width"] = 1,
								["text"] = "[abbrev:name]",
							}, -- [1]
							{
								["y"] = 6,
								["text"] = "[hp:color][curhp]",
								["width"] = 1,
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 1,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["anchorPoint"] = "CRI",
								["x"] = -3,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["y"] = -8,
								["width"] = 1,
							}, -- [8]
							{
								["width"] = 1,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["height"] = 60,
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 12,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 25,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["anchorTo"] = "$parent",
							},
							["height"] = 0.5,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["enabled"] = true,
					},
					["maintank"] = {
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 60,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
						},
						["offset"] = 5,
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
						["highlight"] = {
							["size"] = 10,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["text"] = {
							{
								["text"] = "[(()afk() )][name]",
							}, -- [1]
							nil, -- [2]
							{
								["text"] = "[perpp]",
							}, -- [3]
							nil, -- [4]
							{
								["text"] = "[(()afk() )][name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["width"] = 150,
						["maxColumns"] = 1,
						["height"] = 40,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["incHeal"] = {
							["cap"] = 1,
						},
						["columnSpacing"] = 5,
						["attribAnchorPoint"] = "LEFT",
						["unitsPerColumn"] = 5,
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["anchorTo"] = "$parent",
							},
							["resurrect"] = {
								["y"] = -1,
								["x"] = 37,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LC",
								["size"] = 28,
							},
						},
					},
					["raidpet"] = {
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["scale"] = 0.85,
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["groupSpacing"] = 0,
						["powerBar"] = {
							["height"] = 0.3,
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
						},
						["groupsPerRow"] = 8,
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "none",
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[missinghp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
								["anchorTo"] = "$healthBar",
							}, -- [7]
							{
								["width"] = 0.5,
								["name"] = "Percentage",
								["anchorTo"] = "$healthBar",
							}, -- [8]
							{
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
							}, -- [9]
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
						},
						["width"] = 90,
						["maxColumns"] = 8,
						["attribAnchorPoint"] = "LEFT",
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["incHeal"] = {
							["cap"] = 1,
						},
						["columnSpacing"] = 5,
						["height"] = 30,
						["unitsPerColumn"] = 8,
						["highlight"] = {
							["size"] = 10,
						},
					},
					["battleground"] = {
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["range"] = {
							["enabled"] = true,
							["oorAlpha"] = 0.6,
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["perRow"] = 9,
								["x"] = 0,
								["y"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["buffs"] = {
								["perRow"] = 15,
								["x"] = 0,
								["y"] = -2,
								["show"] = {
									["misc"] = false,
								},
								["anchorPoint"] = "BL",
								["enabled"] = true,
								["size"] = 22,
							},
						},
						["castBar"] = {
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["autoHide"] = true,
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 60,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["order"] = 20,
							["colorType"] = "type",
							["height"] = 0.2,
							["background"] = false,
						},
						["enabled"] = true,
						["healthBar"] = {
							["order"] = 10,
							["vertical"] = false,
							["colorType"] = "static",
							["colorDispel"] = false,
							["reverse"] = false,
							["reactionType"] = "none",
							["background"] = true,
							["invert"] = false,
							["height"] = 1.2,
						},
						["text"] = {
							{
								["y"] = 6,
								["text"] = "[classcolor][abbrev:name]",
								["x"] = 6,
								["width"] = 1,
							}, -- [1]
							{
								["y"] = 6,
								["text"] = "[hp:color][curhp]",
								["width"] = 1,
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["y"] = -8,
								["x"] = -3,
								["default"] = true,
								["anchorTo"] = "$healthBar",
								["anchorPoint"] = "CRI",
								["text"] = "|cff19a0ff[( )curpp]",
								["name"] = "Percentage",
								["width"] = 1,
							}, -- [7]
							{
								["y"] = -8,
								["x"] = 6,
								["name"] = "AFK",
								["anchorTo"] = "$healthBar",
								["size"] = -1,
								["text"] = "[faction]",
								["anchorPoint"] = "CLI",
								["width"] = 1,
							}, -- [8]
						},
						["width"] = 200,
						["offset"] = 30,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["height"] = 50,
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["portrait"] = {
							["type"] = "class",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 3,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 16,
							},
							["height"] = 0.5,
							["pvp"] = {
								["y"] = -8,
								["x"] = 16,
								["anchorTo"] = "$parent",
								["enabled"] = false,
								["anchorPoint"] = "LC",
								["size"] = 40,
							},
						},
					},
				},
				["auras"] = {
					["borderType"] = "dark",
				},
				["font"] = {
					["extra"] = "",
					["name"] = "MUI_Font",
					["shadowColor"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
					["shadowX"] = 0.8,
					["shadowY"] = -0.8,
					["color"] = {
						["a"] = 1,
						["b"] = 0.92156862745098,
						["g"] = 1,
						["r"] = 0.96078431372549,
					},
					["size"] = 10,
				},
				["wowBuild"] = 80100,
				["classColors"] = {
					["HUNTER"] = {
						["a"] = 1,
						["r"] = 0.67,
						["g"] = 0.83,
						["b"] = 0.45,
					},
					["WARRIOR"] = {
						["a"] = 1,
						["r"] = 0.78,
						["g"] = 0.61,
						["b"] = 0.43,
					},
					["SHAMAN"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0.44,
						["b"] = 0.87,
					},
					["MAGE"] = {
						["a"] = 1,
						["r"] = 0.41,
						["g"] = 0.8,
						["b"] = 0.94,
					},
					["VEHICLE"] = {
						["a"] = 1,
						["r"] = 0.203921568627451,
						["g"] = 0.701960784313726,
						["b"] = 0,
					},
					["PRIEST"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 1,
						["b"] = 1,
					},
					["PALADIN"] = {
						["a"] = 1,
						["r"] = 0.96,
						["g"] = 0.55,
						["b"] = 0.73,
					},
					["ROGUE"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 0.96,
						["b"] = 0.41,
					},
					["WARLOCK"] = {
						["a"] = 1,
						["r"] = 0.58,
						["g"] = 0.51,
						["b"] = 0.79,
					},
					["DEMONHUNTER"] = {
						["b"] = 0.79,
						["g"] = 0.19,
						["r"] = 0.64,
					},
					["PET"] = {
						["a"] = 1,
						["r"] = 0.105882352941177,
						["g"] = 0.470588235294118,
						["b"] = 0.105882352941177,
					},
					["DRUID"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 0.49,
						["b"] = 0.04,
					},
					["MONK"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 1,
						["b"] = 0.59,
					},
					["DEATHKNIGHT"] = {
						["a"] = 1,
						["r"] = 0.77,
						["g"] = 0.12,
						["b"] = 0.23,
					},
				},
				["omnicc"] = true,
				["bars"] = {
					["backgroundAlpha"] = 0.3,
					["spacing"] = -1.15,
					["alpha"] = 1,
					["backgroundColor"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 1,
						["b"] = 1,
					},
					["texture"] = "MUI_StatusBar",
				},
				["backdrop"] = {
					["clip"] = 1,
					["edgeSize"] = 1,
					["tileSize"] = 20,
					["borderTexture"] = "Pixel",
					["inset"] = 0,
					["backgroundTexture"] = "Solid",
					["backgroundColor"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
					["borderColor"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
				},
				["auraColors"] = {
					["removable"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 1,
						["b"] = 1,
					},
				},
			},
			["MayronUIH"] = {
				["powerColors"] = {
					["PAIN"] = {
						["r"] = 1,
						["g"] = 0,
						["b"] = 0,
					},
					["SHADOWORBS"] = {
						["b"] = 0.79,
						["g"] = 0.51,
						["r"] = 0.58,
					},
					["LIGHTWELL"] = {
						["r"] = 0.8,
						["g"] = 0.8,
						["b"] = 0.8,
					},
					["BANKEDHOLYPOWER"] = {
						["b"] = 0.84,
						["g"] = 0.61,
						["r"] = 0.96,
					},
					["INSANITY"] = {
						["r"] = 0.4,
						["g"] = 0,
						["b"] = 0.8,
					},
					["STAGGER_RED"] = {
						["b"] = 0.42,
						["g"] = 0.42,
						["r"] = 1,
					},
					["COMBOPOINTS"] = {
						["r"] = 1,
						["g"] = 0.8,
						["b"] = 0,
					},
					["RUNES"] = {
						["b"] = 0.5,
						["g"] = 0.5,
						["r"] = 0.5,
					},
					["RUNEOFPOWER"] = {
						["b"] = 0.6,
						["g"] = 0.45,
						["r"] = 0.35,
					},
					["CHI"] = {
						["b"] = 0.92,
						["g"] = 1,
						["r"] = 0.71,
					},
					["MAELSTROM"] = {
						["r"] = 0,
						["g"] = 0.5,
						["b"] = 1,
					},
					["SOULSHARDS"] = {
						["r"] = 0.58,
						["g"] = 0.51,
						["b"] = 0.79,
					},
					["RUNIC_POWER"] = {
						["a"] = 1,
						["r"] = 0.431372549019608,
						["g"] = 0.603921568627451,
						["b"] = 0.866666666666667,
					},
					["STAGGER_YELLOW"] = {
						["b"] = 0.72,
						["g"] = 0.98,
						["r"] = 1,
					},
					["RAGE"] = {
						["a"] = 1,
						["b"] = 0.0196078431372549,
						["g"] = 0,
						["r"] = 0.447058823529412,
					},
					["MUSHROOMS"] = {
						["b"] = 0.2,
						["g"] = 0.9,
						["r"] = 0.2,
					},
					["ALTERNATE"] = {
						["a"] = 1,
						["b"] = 1,
						["g"] = 0.941,
						["r"] = 0.815,
					},
					["FOCUS"] = {
						["a"] = 1,
						["b"] = 0.235294117647059,
						["g"] = 0.431372549019608,
						["r"] = 0.611764705882353,
					},
					["DEMONICFURY"] = {
						["b"] = 0.79,
						["g"] = 0.51,
						["r"] = 0.58,
					},
					["FULLBURNINGEMBER"] = {
						["b"] = 0.062,
						["g"] = 0.09,
						["r"] = 0.88,
					},
					["ARCANECHARGES"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.98,
					},
					["HAPPINESS"] = {
						["b"] = 0.7,
						["g"] = 0.9,
						["r"] = 0.5,
					},
					["ENERGY"] = {
						["a"] = 1,
						["b"] = 0.219607843137255,
						["g"] = 0.866666666666667,
						["r"] = 1,
					},
					["MANA"] = {
						["a"] = 1,
						["b"] = 1,
						["g"] = 0.474509803921569,
						["r"] = 0.0823529411764706,
					},
					["AURAPOINTS"] = {
						["b"] = 0,
						["g"] = 0.8,
						["r"] = 1,
					},
					["ECLIPSE_FULL"] = {
						["b"] = 0.43,
						["g"] = 0.32,
						["r"] = 0,
					},
					["ECLIPSE_MOON"] = {
						["r"] = 0.3,
						["g"] = 0.52,
						["b"] = 0.9,
					},
					["BURNINGEMBERS"] = {
						["b"] = 0.79,
						["g"] = 0.51,
						["r"] = 0.58,
					},
					["ECLIPSE_SUN"] = {
						["r"] = 1,
						["g"] = 1,
						["b"] = 0,
					},
					["STAGGER_GREEN"] = {
						["b"] = 0.52,
						["g"] = 1,
						["r"] = 0.52,
					},
					["AMMOSLOT"] = {
						["b"] = 0.55,
						["g"] = 0.6,
						["r"] = 0.85,
					},
					["POWER_TYPE_FEL_ENERGY"] = {
						["r"] = 0.878,
						["g"] = 0.98,
						["b"] = 0,
					},
					["STATUE"] = {
						["b"] = 0.6,
						["g"] = 0.45,
						["r"] = 0.35,
					},
					["LUNAR_POWER"] = {
						["r"] = 0.3,
						["g"] = 0.52,
						["b"] = 0.9,
					},
					["HOLYPOWER"] = {
						["r"] = 0.96,
						["g"] = 0.55,
						["b"] = 0.73,
					},
					["FUEL"] = {
						["b"] = 0.36,
						["g"] = 0.47,
						["r"] = 0.85,
					},
					["FURY"] = {
						["r"] = 0.788,
						["g"] = 0.259,
						["b"] = 0.992,
					},
				},
				["advanced"] = true,
				["healthColors"] = {
					["aggro"] = {
						["a"] = 1,
						["r"] = 0.749019607843137,
						["g"] = 0,
						["b"] = 0,
					},
					["enemyUnattack"] = {
						["b"] = 0.2,
						["g"] = 0.2,
						["r"] = 0.6,
					},
					["neutral"] = {
						["a"] = 1,
						["b"] = 0.2,
						["g"] = 0.843137254901961,
						["r"] = 1,
					},
					["static"] = {
						["a"] = 1,
						["b"] = 0.0901960784313726,
						["g"] = 0.0901960784313726,
						["r"] = 0.0901960784313726,
					},
					["friendly"] = {
						["a"] = 1,
						["b"] = 0.125490196078431,
						["g"] = 0.63921568627451,
						["r"] = 0.203921568627451,
					},
					["incAbsorb"] = {
						["b"] = 0.09,
						["g"] = 0.75,
						["r"] = 0.93,
					},
					["offline"] = {
						["b"] = 0.5,
						["g"] = 0.5,
						["r"] = 0.5,
					},
					["tapped"] = {
						["b"] = 0.5,
						["g"] = 0.5,
						["r"] = 0.5,
					},
					["hostile"] = {
						["a"] = 1,
						["b"] = 0.0470588235294118,
						["g"] = 0.0392156862745098,
						["r"] = 0.764705882352941,
					},
					["green"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 1,
						["r"] = 0.356862745098039,
					},
					["yellow"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0.858823529411765,
						["r"] = 1,
					},
					["healAbsorb"] = {
						["b"] = 1,
						["g"] = 0.47,
						["r"] = 0.68,
					},
					["inc"] = {
						["b"] = 0.23,
						["g"] = 0.35,
						["r"] = 0,
					},
					["red"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0,
						["r"] = 0.749019607843137,
					},
				},
				["xpColors"] = {
					["normal"] = {
						["b"] = 0.55,
						["g"] = 0,
						["r"] = 0.58,
					},
					["rested"] = {
						["b"] = 0.88,
						["g"] = 0.39,
						["r"] = 0,
					},
				},
				["locked"] = true,
				["auraIndicators"] = {
					["updated"] = true,
					["indicators"] = {
						["tr"] = {
							["width"] = 12,
							["height"] = 12,
						},
						["tl"] = {
							["width"] = 12,
							["height"] = 12,
							["y"] = -3,
						},
						["c"] = {
							["showStack"] = false,
						},
						["br"] = {
							["anchorPoint"] = "CRI",
						},
					},
					["auras"] = {
						["Renew"] = "{indicator = '', group = \"Priest\", priority = 10, r = 1, g = 0.62, b = 0.88}",
						["Focus Magic"] = "{indicator = '', group = \"Mage\", priority = 10, r = 0.67, g = 0.76, b = 1.0}",
						["Mark of the Wild"] = "{indicator = '', group = \"Druid\", priority = 10, r = 1.0, g = 0.33, b = 0.90}",
						["Soulstone Resurrection"] = "{indicator = '', group = \"Warlock\", priority = 10, r = 0.42, g = 0.21, b = 0.65}",
						["Beacon of Light"] = "{r=0;g=0;indicator=\"tl\";b=0;group=\"Paladin\";priority=0;icon=true;iconTexture=\"InterfaceIconsAbility_Paladin_BeaconofLight\";}",
						["Power Word: Fortitude"] = "{indicator = '', group = \"Priest\", priority = 10, r = 0.58, g = 1.0, b = 0.50}",
						["Regrowth"] = "{indicator = '', group = \"Druid\", priority = 10, r = 0.50, g = 1.0, b = 0.63}",
						["Earth Shield"] = "{indicator = '', group = \"Shaman\", priority = 10, r = 0.26, g = 1.0, b = 0.26}",
						["Riptide"] = "{indicator = '', group = \"Shaman\", priority = 10, r = 0.30, g = 0.24, b = 1.0}",
						["Rejuvenation"] = "{indicator = '', group = \"Druid\", priority = 10, r = 0.66, g = 0.66, b = 1.0}",
						["Shadow Protection"] = "{indicator = '', group = \"Priest\", priority = 10, r = 0.60, g = 0.18, b = 1.0}",
						["Hand of Sacrifice"] = "{icon=true;b=0;priority=0;r=0;group=\"Paladin\";indicator=\"tr\";g=0;iconTexture=\"Interface\\Icons\\Spell_Holy_SealOfSacrifice\";}",
						["Wild Growth"] = "{indicator = '', group = \"Druid\", priority = 10, r = 0.51, g = 0.72, b = 0.77}",
						["Lifebloom"] = "{indicator = '', group = \"Druid\", priority = 10, r = 0.07, g = 1.0, b = 0.01}",
						["Power Word: Shield"] = "{indicator = '', group = \"Priest\", priority = 10, r = 0.55, g = 0.69, b = 1.0}",
						["Arcane Brilliance"] = "{indicator = '', group = \"Mage\", priority = 10, r = 0.10, g = 0.68, b = 0.88}",
					},
					["filters"] = {
						["tl"] = {
							["curable"] = {
								["enabled"] = false,
								["duration"] = false,
							},
							["boss"] = {
								["enabled"] = false,
								["duration"] = false,
							},
						},
					},
				},
				["positions"] = {
					["arenatarget"] = {
						["anchorPoint"] = "RT",
						["x"] = 2,
						["anchorTo"] = "$parent",
					},
					["mainassisttarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["targettargettarget"] = {
						["anchorPoint"] = "RC",
						["anchorTo"] = "#SUFUnittargettarget",
					},
					["arenatargettarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["pettarget"] = {
						["anchorPoint"] = "C",
					},
					["arenapet"] = {
						["anchorPoint"] = "RB",
						["anchorTo"] = "$parent",
					},
					["mainassisttargettarget"] = {
						["anchorPoint"] = "RT",
						["x"] = 150,
						["anchorTo"] = "$parent",
					},
					["party"] = {
						["anchorPoint"] = "TR",
						["x"] = -9,
						["bottom"] = 125.894446708569,
						["y"] = 30,
						["anchorTo"] = "#SUFUnittarget",
						["top"] = 234.394423498521,
					},
					["maintanktargettarget"] = {
						["anchorPoint"] = "RT",
						["x"] = 150,
						["anchorTo"] = "$parent",
					},
					["focus"] = {
						["y"] = 30,
						["point"] = "BOTTOM",
						["relativePoint"] = "TOP",
						["anchorTo"] = "#SUFUnittargettarget",
					},
					["target"] = {
						["y"] = -28.2,
						["x"] = 21.2,
						["point"] = "BOTTOMLEFT",
						["relativePoint"] = "TOPRIGHT",
						["anchorTo"] = "#SUFUnittargettarget",
					},
					["raid"] = {
						["anchorPoint"] = "TR",
						["x"] = -282,
						["point"] = "TOPLEFT",
						["bottom"] = 144.988277254985,
						["y"] = 70,
						["anchorTo"] = "#SUFUnittarget",
						["top"] = 325.588113962103,
					},
					["battlegroundtarget"] = {
						["anchorPoint"] = "RT",
						["x"] = 2,
						["anchorTo"] = "$parent",
					},
					["partytargettarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["arena"] = {
						["anchorPoint"] = "C",
						["x"] = 419.999992847443,
						["bottom"] = 400.924395027767,
						["top"] = 694.924347296368,
					},
					["battlegroundtargettarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["bosstargettarget"] = {
						["anchorPoint"] = "RB",
						["anchorTo"] = "$parent",
					},
					["battlegroundpet"] = {
						["anchorPoint"] = "RB",
						["anchorTo"] = "$parent",
					},
					["bosstarget"] = {
						["anchorPoint"] = "RT",
						["x"] = 2,
						["anchorTo"] = "$parent",
					},
					["focustarget"] = {
						["point"] = "BOTTOM",
						["relativePoint"] = "BOTTOM",
						["y"] = 44.3799992442131,
					},
					["pet"] = {
						["y"] = 10,
						["point"] = "BOTTOM",
						["relativePoint"] = "TOP",
						["anchorTo"] = "#SUFUnittargettarget",
					},
					["mainassist"] = {
						["anchorPoint"] = "C",
					},
					["player"] = {
						["y"] = -28.2,
						["x"] = -21.5,
						["point"] = "BOTTOMRIGHT",
						["relativePoint"] = "TOPLEFT",
						["anchorTo"] = "#SUFUnittargettarget",
					},
					["maintanktarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["targettarget"] = {
						["y"] = -100,
						["x"] = 100,
						["point"] = "TOP",
						["relativePoint"] = "TOP",
						["anchorTo"] = "UIParent",
					},
					["raidpet"] = {
						["anchorPoint"] = "C",
					},
					["maintank"] = {
						["anchorPoint"] = "C",
					},
					["boss"] = {
						["anchorPoint"] = "C",
						["x"] = 419.999992847443,
						["bottom"] = 178.037770100359,
						["top"] = 472.037711687808,
					},
					["battleground"] = {
						["anchorPoint"] = "C",
						["x"] = 419.999992847443,
						["bottom"] = 204.155590395321,
						["top"] = 435.155650548328,
					},
				},
				["revision"] = 59,
				["wowBuild"] = 80100,
				["castColors"] = {
					["cast"] = {
						["a"] = 1,
						["b"] = 0.301960784313726,
						["g"] = 0.701960784313726,
						["r"] = 1,
					},
					["finished"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0,
						["r"] = 0,
					},
					["channel"] = {
						["b"] = 1,
						["g"] = 0.25,
						["r"] = 0.25,
					},
					["uninterruptible"] = {
						["a"] = 1,
						["b"] = 0.152941176470588,
						["g"] = 0.36078431372549,
						["r"] = 1,
					},
					["interrupted"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0,
						["r"] = 0,
					},
				},
				["loadedLayout"] = true,
				["hidden"] = {
					["playerAltPower"] = true,
				},
				["units"] = {
					["arenatarget"] = {
						["enabled"] = true,
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["range"] = {
							["height"] = 0.5,
						},
						["width"] = 156,
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["text"] = {
							{
								["text"] = "[classcolor][abbrev:name]",
								["width"] = 1.7,
							}, -- [1]
							{
								["text"] = "[hp:color][perhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.8,
								["name"] = "AFK",
							}, -- [9]
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["enabled"] = false,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
							["height"] = 0.5,
						},
						["height"] = 41,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.2,
							["background"] = false,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1.2,
						},
					},
					["mainassisttarget"] = {
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["highlight"] = {
							["size"] = 10,
						},
						["text"] = {
							{
								["text"] = "[(()afk() )][name]",
							}, -- [1]
							nil, -- [2]
							{
								["text"] = "[level( )][classification( )][perpp]",
							}, -- [3]
							nil, -- [4]
							{
								["text"] = "[(()afk() )][name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["auras"] = {
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["width"] = 150,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
						},
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
					},
					["targettargettarget"] = {
						["enabled"] = false,
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "RIGHT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["range"] = {
							["height"] = 0.5,
						},
						["width"] = 80,
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["text"] = {
							{
								["width"] = 1,
							}, -- [1]
							{
								["text"] = "",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							nil, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
							["height"] = 0.5,
						},
						["height"] = 30,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
					},
					["partytarget"] = {
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["range"] = {
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["width"] = 90,
						["fader"] = {
							["height"] = 0.5,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["height"] = 25,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
							["height"] = 0.5,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
					},
					["arenatargettarget"] = {
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["highlight"] = {
							["size"] = 10,
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
						},
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["width"] = 90,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 16,
							},
						},
						["height"] = 25,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
					},
					["battlegroundtarget"] = {
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["range"] = {
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.2,
							["background"] = false,
							["invert"] = false,
							["order"] = 20,
						},
						["offset"] = 4,
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1.2,
						},
						["text"] = {
							{
								["text"] = "[classcolor][abbrev:name]",
							}, -- [1]
							{
								["text"] = "[hp:color][perhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [8]
						},
						["width"] = 156,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["enabled"] = true,
						["height"] = 41,
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["enabled"] = false,
								["size"] = 20,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["height"] = 0.5,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
					},
					["arenapet"] = {
						["highlight"] = {
							["size"] = 10,
						},
						["auras"] = {
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["width"] = 90,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["height"] = 25,
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
					},
					["mainassisttargettarget"] = {
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["highlight"] = {
							["size"] = 10,
						},
						["text"] = {
							{
								["text"] = "[(()afk() )][name]",
							}, -- [1]
							[3] = {
								["text"] = "[level( )][classification( )][perpp]",
							},
							[5] = {
								["text"] = "[(()afk() )][name]",
							},
						},
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["width"] = 150,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 16,
							},
						},
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
					},
					["party"] = {
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 4,
								["size"] = 23,
							},
							["lfdRole"] = {
								["y"] = 4,
								["x"] = 16,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LT",
								["size"] = 14,
							},
							["phase"] = {
								["y"] = -10,
								["x"] = 44,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["size"] = 14,
							},
							["masterLoot"] = {
								["y"] = -8,
								["x"] = 30,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["size"] = 12,
							},
							["leader"] = {
								["anchorPoint"] = "LT",
								["x"] = 31,
								["anchorTo"] = "$parent",
								["y"] = 5,
								["size"] = 14,
							},
							["role"] = {
								["y"] = 5,
								["x"] = 30,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 14,
							},
							["ready"] = {
								["anchorPoint"] = "RC",
								["x"] = -28,
								["anchorTo"] = "$parent",
								["y"] = 4,
								["size"] = 24,
							},
							["resurrect"] = {
								["y"] = 2,
								["x"] = -30,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RC",
								["size"] = 28,
							},
							["status"] = {
								["anchorPoint"] = "LB",
								["x"] = 12,
								["anchorTo"] = "$parent",
								["y"] = -2,
								["size"] = 16,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
							["height"] = 0.5,
							["pvp"] = {
								["y"] = -20,
								["x"] = 58,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["size"] = 24,
							},
						},
						["showPlayer"] = false,
						["range"] = {
							["enabled"] = true,
							["oorAlpha"] = 0.5,
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["perRow"] = 2,
								["enlarge"] = {
									["SELF"] = false,
								},
								["y"] = 1,
								["x"] = -2,
								["enabled"] = true,
								["maxRows"] = 5,
								["anchorPoint"] = "LB",
								["size"] = 23,
							},
							["buffs"] = {
								["enabled"] = true,
								["anchorPoint"] = "RB",
								["maxRows"] = 5,
								["x"] = 2,
								["perRow"] = 2,
								["show"] = {
									["relevant"] = false,
									["misc"] = false,
								},
								["y"] = 1,
								["size"] = 23,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["autoHide"] = true,
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 60,
						},
						["portrait"] = {
							["fullBefore"] = 0,
							["fullAfter"] = 50,
							["order"] = 15,
							["isBar"] = false,
							["width"] = 0.2,
							["alignment"] = "LEFT",
							["height"] = 0.5,
							["type"] = "3D",
						},
						["incAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["hideAnyRaid"] = true,
						["incHeal"] = {
							["height"] = 0.5,
							["cap"] = 1,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["predicted"] = true,
							["height"] = 0.2,
							["order"] = 20,
							["background"] = false,
							["invert"] = false,
							["onlyMana"] = false,
						},
						["unitsPerColumn"] = 5,
						["offset"] = 8,
						["disableVehicle"] = false,
						["healthBar"] = {
							["colorType"] = "static",
							["reactionType"] = "none",
							["height"] = 1.2,
							["background"] = true,
							["invert"] = false,
							["order"] = 10,
						},
						["hideSemiRaid"] = false,
						["fader"] = {
							["height"] = 0.5,
							["inactiveAlpha"] = 1,
						},
						["attribAnchorPoint"] = "LEFT",
						["highlight"] = {
							["height"] = 0.5,
							["aggro"] = true,
							["alpha"] = 1,
							["size"] = 10,
						},
						["width"] = 200,
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["text"] = {
							{
								["text"] = "[classcolor][name]",
								["width"] = 1,
								["x"] = 4,
								["y"] = 2,
							}, -- [1]
							{
								["text"] = "[curhp]",
								["width"] = 2,
								["x"] = -2,
								["y"] = -6,
							}, -- [2]
							{
								["text"] = "",
								["y"] = 5,
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[(()afk() )][name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 1,
								["y"] = -14,
								["default"] = true,
								["name"] = "NameText",
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["width"] = 2,
								["y"] = 8,
								["x"] = -2,
								["name"] = "Percentage",
								["anchorPoint"] = "CRI",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "[levelcolor][( )afk][( )status]",
								["width"] = 1,
								["y"] = 14,
								["x"] = 4,
								["name"] = "AFK",
								["anchorPoint"] = "BL",
								["size"] = -1,
							}, -- [9]
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["enabled"] = false,
							["height"] = 0.4,
						},
						["combatText"] = {
							["height"] = 0.5,
						},
						["height"] = 50,
						["healAbsorb"] = {
							["height"] = 0.5,
						},
						["columnSpacing"] = -30,
						["attribPoint"] = "TOP",
					},
					["maintanktargettarget"] = {
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["highlight"] = {
							["size"] = 10,
						},
						["text"] = {
							{
								["text"] = "[(()afk() )][name]",
							}, -- [1]
							[3] = {
								["text"] = "[classification( )][perpp]",
							},
							[5] = {
								["text"] = "[(()afk() )][name]",
							},
						},
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["width"] = 150,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 16,
							},
						},
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
					},
					["focus"] = {
						["indicators"] = {
							["raidTarget"] = {
								["y"] = -14,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["enabled"] = false,
								["size"] = 30,
							},
							["lfdRole"] = {
								["y"] = -32,
								["x"] = 5,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RT",
								["size"] = 17,
							},
							["resurrect"] = {
								["enabled"] = false,
								["x"] = -80,
								["anchorTo"] = "$parent",
								["y"] = -15,
								["anchorPoint"] = "C",
								["size"] = 30,
							},
							["masterLoot"] = {
								["y"] = -10,
								["x"] = 16,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 12,
							},
							["leader"] = {
								["y"] = 17,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RB",
								["enabled"] = false,
								["size"] = 19,
							},
							["questBoss"] = {
								["y"] = -32,
								["x"] = 3,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RT",
								["enabled"] = false,
								["size"] = 22,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
							["height"] = 0.5,
							["petBattle"] = {
								["y"] = -32,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["enabled"] = false,
								["anchorPoint"] = "RT",
								["size"] = 21,
							},
							["role"] = {
								["y"] = -11,
								["x"] = 30,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 14,
							},
							["status"] = {
								["y"] = 9,
								["x"] = -21,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RC",
								["size"] = 16,
							},
							["pvp"] = {
								["y"] = -21,
								["x"] = 11,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TR",
								["enabled"] = false,
								["size"] = 22,
							},
						},
						["range"] = {
							["height"] = 0.5,
							["oorAlpha"] = 0.6,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "RT",
								["x"] = 30,
								["maxRows"] = 2,
								["perRow"] = 3,
								["show"] = {
									["player"] = false,
								},
								["y"] = -30,
								["size"] = 24,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 60,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["enabled"] = false,
							["predicted"] = true,
							["height"] = 0.6,
							["order"] = 25,
							["background"] = false,
							["invert"] = false,
							["colorType"] = "type",
						},
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 0,
							["reactionType"] = "none",
							["background"] = true,
							["invert"] = false,
							["height"] = 1.9,
						},
						["incAbsorb"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["text"] = {
							{
								["text"] = "[classcolor][abbrev:name]",
								["width"] = 10,
								["y"] = 1,
								["x"] = 0,
								["anchorPoint"] = "C",
							}, -- [1]
							{
								["text"] = "",
								["width"] = 10,
								["y"] = 14,
								["x"] = 0,
								["anchorPoint"] = "TRI",
							}, -- [2]
							{
								["text"] = "",
								["width"] = 10,
							}, -- [3]
							{
								["text"] = "",
								["width"] = 2.5,
							}, -- [4]
							{
								["text"] = "[perpp][( )hp:color][( )perhp]",
								["anchorPoint"] = "CRI",
								["x"] = -3,
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 10,
								["y"] = 39,
								["x"] = -10,
								["default"] = true,
								["name"] = "NameText",
								["anchorPoint"] = "TR",
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 10,
								["y"] = 26,
								["name"] = "Percentage",
								["anchorPoint"] = "TRI",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["portrait"] = {
							["fullBefore"] = 0,
							["fullAfter"] = 100,
							["order"] = 0,
							["isBar"] = true,
							["width"] = 0.16,
							["alignment"] = "RIGHT",
							["height"] = 2.3,
							["type"] = "3D",
						},
						["width"] = 100,
						["fader"] = {
							["height"] = 0.5,
							["inactiveAlpha"] = 1,
						},
						["incHeal"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = false,
							["order"] = 100,
						},
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["height"] = 18,
						["healAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["emptyBar"] = {
							["order"] = 70,
							["height"] = 0.8,
							["background"] = true,
							["backgroundColor"] = {
								["b"] = 0.0980392156862745,
								["g"] = 0.0980392156862745,
								["r"] = 0.0980392156862745,
							},
							["reactionType"] = "none",
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
					},
					["target"] = {
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = -14,
								["size"] = 30,
							},
							["lfdRole"] = {
								["y"] = -32,
								["x"] = 4,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RT",
								["enabled"] = true,
								["size"] = 17,
							},
							["resurrect"] = {
								["anchorPoint"] = "C",
								["x"] = -80,
								["anchorTo"] = "$parent",
								["y"] = -15,
								["size"] = 30,
							},
							["masterLoot"] = {
								["y"] = 16,
								["x"] = -16,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BR",
								["enabled"] = false,
								["size"] = 12,
							},
							["leader"] = {
								["anchorPoint"] = "RB",
								["x"] = 2,
								["anchorTo"] = "$parent",
								["y"] = 17,
								["enabled"] = false,
								["size"] = 19,
							},
							["questBoss"] = {
								["y"] = 24,
								["x"] = 9,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BR",
								["enabled"] = false,
								["size"] = 22,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
							["height"] = 0.5,
							["petBattle"] = {
								["y"] = 14,
								["x"] = -6,
								["anchorTo"] = "$parent",
								["enabled"] = false,
								["anchorPoint"] = "BL",
								["size"] = 18,
							},
							["role"] = {
								["y"] = -3,
								["x"] = -38,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BR",
								["enabled"] = false,
								["size"] = 14,
							},
							["status"] = {
								["anchorPoint"] = "RC",
								["x"] = -21,
								["anchorTo"] = "$parent",
								["y"] = 9,
								["size"] = 17,
							},
							["pvp"] = {
								["y"] = -25,
								["x"] = -43,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TR",
								["enabled"] = false,
								["size"] = 22,
							},
						},
						["range"] = {
							["height"] = 0.5,
							["oorAlpha"] = 0.4,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["perRow"] = 3,
								["anchorOn"] = false,
								["enlarge"] = {
									["SELF"] = false,
								},
								["show"] = {
									["misc"] = false,
									["raid"] = false,
								},
								["maxRows"] = 1,
								["anchorPoint"] = "TR",
								["y"] = 31,
								["x"] = -9,
								["size"] = 28,
							},
							["buffs"] = {
								["enabled"] = true,
								["anchorOn"] = false,
								["enlarge"] = {
									["REMOVABLE"] = false,
								},
								["y"] = -30,
								["maxRows"] = 3,
								["perRow"] = 3,
								["show"] = {
									["misc"] = false,
								},
								["anchorPoint"] = "RT",
								["x"] = 27,
								["size"] = 23,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -2,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["rank"] = false,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 2,
							},
							["autoHide"] = false,
							["height"] = 3.2,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 5,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["predicted"] = true,
							["height"] = 0.8,
							["reverse"] = false,
							["order"] = 25,
							["background"] = false,
							["invert"] = false,
							["colorType"] = "type",
						},
						["healthBar"] = {
							["colorType"] = "static",
							["colorAggro"] = false,
							["reactionType"] = "none",
							["height"] = 1.8,
							["background"] = true,
							["invert"] = false,
							["order"] = 0,
						},
						["comboPoints"] = {
							["order"] = 99,
							["height"] = 0.5,
						},
						["text"] = {
							{
								["text"] = "[hp:color][perhp]",
								["width"] = 10,
								["y"] = -5,
								["x"] = 4,
								["anchorPoint"] = "TLI",
								["size"] = 3,
							}, -- [1]
							{
								["text"] = "[hp:color][curhp]",
								["width"] = 10,
								["y"] = 13,
								["x"] = -2,
								["anchorPoint"] = "TRI",
							}, -- [2]
							{
								["text"] = "[color:gensit]",
								["width"] = 10,
								["y"] = -19,
								["x"] = 0,
								["anchorPoint"] = "TL",
							}, -- [3]
							{
								["text"] = "",
								["width"] = 2.5,
							}, -- [4]
							{
								["anchorPoint"] = "TR",
								["x"] = 55,
								["y"] = 11,
								["size"] = 2,
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 10,
								["y"] = 37,
								["x"] = -10,
								["default"] = true,
								["name"] = "NameText",
								["anchorPoint"] = "TR",
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["width"] = 10,
								["y"] = 26,
								["x"] = -2,
								["name"] = "Percentage",
								["anchorPoint"] = "TRI",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "[afk:time][status:time]",
								["width"] = 10,
								["name"] = "AFK",
							}, -- [9]
						},
						["incAbsorb"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["width"] = 274,
						["portrait"] = {
							["enabled"] = true,
							["type"] = "3D",
							["fullAfter"] = 100,
							["order"] = 0,
							["isBar"] = true,
							["width"] = 0.21,
							["alignment"] = "RIGHT",
							["height"] = 2.4,
							["fullBefore"] = 0,
						},
						["incHeal"] = {
							["height"] = 0.5,
							["cap"] = 1,
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
							["y"] = -9,
						},
						["height"] = 60,
						["healAbsorb"] = {
							["height"] = 0.5,
						},
						["emptyBar"] = {
							["order"] = 0,
							["class"] = false,
							["height"] = 1.3,
							["background"] = false,
							["backgroundColor"] = {
								["b"] = 0.0901960784313726,
								["g"] = 0.0901960784313726,
								["r"] = 0.0901960784313726,
							},
							["reactionType"] = "none",
						},
						["highlight"] = {
							["height"] = 0.5,
							["aggro"] = false,
							["mouseover"] = false,
							["size"] = 5,
						},
					},
					["raid"] = {
						["portrait"] = {
							["fullBefore"] = 0,
							["fullAfter"] = 100,
							["order"] = 15,
							["isBar"] = false,
							["width"] = 0.22,
							["alignment"] = "LEFT",
							["height"] = 0.5,
							["type"] = "3D",
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["enabled"] = true,
								["anchorOn"] = false,
								["enlarge"] = {
									["SELF"] = false,
								},
								["show"] = {
									["misc"] = false,
									["player"] = false,
								},
								["maxRows"] = 1,
								["perRow"] = 5,
								["anchorPoint"] = "BL",
								["x"] = 2,
								["y"] = 18,
								["size"] = 10,
							},
							["buffs"] = {
								["perRow"] = 1,
								["timers"] = {
									["SELF"] = false,
								},
								["anchorOn"] = false,
								["show"] = {
									["misc"] = false,
									["relevant"] = false,
									["raid"] = false,
								},
								["maxRows"] = 1,
								["y"] = -11,
								["anchorPoint"] = "TR",
								["x"] = -2,
								["size"] = 10,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["frameSplit"] = true,
						["groupSpacing"] = -34,
						["powerBar"] = {
							["colorType"] = "type",
							["reverse"] = false,
							["order"] = 20,
							["background"] = false,
							["invert"] = false,
							["height"] = 0.2,
						},
						["groupsPerRow"] = 8,
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 10,
							["height"] = 2,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "none",
						},
						["hideSemiRaid"] = false,
						["text"] = {
							{
								["text"] = "[colorname]",
								["width"] = 1,
								["y"] = 2,
								["x"] = 0,
								["anchorPoint"] = "C",
								["size"] = -1,
							}, -- [1]
							{
								["text"] = "",
								["x"] = 0,
								["y"] = -6,
								["size"] = 1,
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[(()afk() )][name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "[afk][status]",
								["width"] = 1,
								["y"] = -10,
								["name"] = "AFK",
								["size"] = -1,
							}, -- [9]
						},
						["maxColumns"] = 8,
						["sortOrder"] = "DESC",
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["enabled"] = false,
							["height"] = 0.4,
						},
						["height"] = 40,
						["attribPoint"] = "RIGHT",
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 22,
							},
							["lfdRole"] = {
								["anchorPoint"] = "TL",
								["anchorTo"] = "$parent",
								["y"] = -9,
								["size"] = 12,
							},
							["resurrect"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 26,
							},
							["masterLoot"] = {
								["anchorPoint"] = "TR",
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = -9,
								["enabled"] = false,
								["size"] = 11,
							},
							["leader"] = {
								["y"] = -9,
								["x"] = 11,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["size"] = 14,
							},
							["role"] = {
								["anchorPoint"] = "TL",
								["x"] = 25,
								["anchorTo"] = "$parent",
								["y"] = -9,
								["enabled"] = false,
								["size"] = 12,
							},
							["ready"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 22,
							},
							["height"] = 0.5,
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
							["status"] = {
								["anchorPoint"] = "LB",
								["x"] = 12,
								["anchorTo"] = "$parent",
								["y"] = -2,
								["size"] = 16,
							},
							["pvp"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 11,
								["enabled"] = false,
								["size"] = 22,
							},
						},
						["range"] = {
							["enabled"] = true,
							["oorAlpha"] = 0.6,
							["height"] = 0.5,
						},
						["auraIndicators"] = {
							["enabled"] = true,
							["height"] = 0.5,
						},
						["attribAnchorPoint"] = "BOTTOM",
						["highlight"] = {
							["debuff"] = true,
							["aggro"] = true,
							["alpha"] = 1,
							["height"] = 0.5,
							["attention"] = false,
							["mouseover"] = false,
							["size"] = 10,
						},
						["unitsPerColumn"] = 25,
						["incAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["width"] = 53,
						["incHeal"] = {
							["height"] = 0.5,
							["cap"] = 1,
						},
						["showParty"] = false,
						["fader"] = {
							["height"] = 0.5,
						},
						["combatText"] = {
							["height"] = 0.5,
						},
						["columnSpacing"] = 2,
						["healAbsorb"] = {
							["height"] = 0.5,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["offset"] = 2,
					},
					["partytargettarget"] = {
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["highlight"] = {
							["size"] = 10,
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
						},
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["width"] = 90,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 16,
							},
						},
						["height"] = 25,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
					},
					["arena"] = {
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["range"] = {
							["enabled"] = true,
							["oorAlpha"] = 0.6,
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["perRow"] = 9,
								["anchorOn"] = false,
								["y"] = 0,
								["x"] = 0,
								["show"] = {
									["player"] = false,
								},
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["buffs"] = {
								["perRow"] = 15,
								["anchorOn"] = false,
								["enlarge"] = {
									["REMOVABLE"] = false,
								},
								["anchorPoint"] = "BL",
								["x"] = 0,
								["enabled"] = true,
								["y"] = -2,
								["size"] = 22,
							},
						},
						["castBar"] = {
							["enabled"] = true,
							["order"] = 60,
							["reverse"] = false,
							["invert"] = false,
							["vertical"] = false,
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = false,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["autoHide"] = true,
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = false,
							["height"] = 0.2,
						},
						["offset"] = 30,
						["healthBar"] = {
							["colorAggro"] = false,
							["order"] = 10,
							["vertical"] = false,
							["colorType"] = "static",
							["reverse"] = false,
							["reactionType"] = "npc",
							["background"] = true,
							["invert"] = false,
							["height"] = 1.2,
						},
						["text"] = {
							{
								["text"] = "[classcolor][abbrev:name]",
							}, -- [1]
							{
								["text"] = "[hp:color][curhp]",
								["width"] = 1,
								["y"] = 6,
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["width"] = 1,
								["y"] = -8,
								["x"] = -3,
								["name"] = "Percentage",
								["anchorPoint"] = "CRI",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["width"] = 200,
						["portrait"] = {
							["fullBefore"] = 0,
							["fullAfter"] = 50,
							["order"] = 15,
							["isBar"] = true,
							["width"] = 0.22,
							["alignment"] = "LEFT",
							["height"] = 0.5,
							["type"] = "3D",
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["height"] = 60,
						["enabled"] = true,
						["indicators"] = {
							["arenaSpec"] = {
								["y"] = 15,
								["x"] = -4,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LC",
								["size"] = 30,
							},
							["lfdRole"] = {
								["y"] = 14,
								["x"] = 3,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BR",
								["enabled"] = false,
								["size"] = 14,
							},
							["height"] = 0.5,
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
							["raidTarget"] = {
								["y"] = 12,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 25,
							},
						},
					},
					["battlegroundpet"] = {
						["highlight"] = {
							["size"] = 10,
						},
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["order"] = 40,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [8]
						},
						["width"] = 90,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["height"] = 25,
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
					},
					["battlegroundtargettarget"] = {
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["highlight"] = {
							["size"] = 10,
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
						},
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["width"] = 90,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 16,
							},
						},
						["height"] = 25,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
					},
					["bosstargettarget"] = {
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["highlight"] = {
							["size"] = 10,
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
						},
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["width"] = 90,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 16,
							},
						},
						["height"] = 25,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
					},
					["pettarget"] = {
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["highlight"] = {
							["size"] = 10,
						},
						["text"] = {
							nil, -- [1]
							nil, -- [2]
							{
								["text"] = "[perpp]",
							}, -- [3]
							nil, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["auras"] = {
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["width"] = 190,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
							},
						},
						["height"] = 30,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.7,
							["background"] = true,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
					},
					["bosstarget"] = {
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["range"] = {
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = false,
							["height"] = 0.2,
						},
						["enabled"] = true,
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1.2,
						},
						["text"] = {
							{
								["text"] = "[classcolor][abbrev:name]",
							}, -- [1]
							{
								["text"] = "[hp:color][perhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["width"] = 156,
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["enabled"] = false,
								["size"] = 20,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
							["height"] = 0.5,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["height"] = 41,
						["offset"] = 20,
						["attribAnchorPoint"] = "RIGHT",
						["attribPoint"] = "BOTTOM",
					},
					["focustarget"] = {
						["indicators"] = {
							["raidTarget"] = {
								["y"] = -6,
								["x"] = -38,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["enabled"] = false,
								["size"] = 30,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
							["height"] = 0.5,
						},
						["range"] = {
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["enlarge"] = {
									["SELF"] = false,
								},
								["anchorPoint"] = "BL",
								["x"] = -1,
								["y"] = 3,
								["maxRows"] = 1,
								["size"] = 15,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["enabled"] = false,
							["colorType"] = "type",
							["height"] = 0.4,
							["background"] = true,
							["invert"] = false,
							["order"] = 20,
						},
						["enabled"] = false,
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 10,
							["height"] = 1.4,
							["background"] = true,
							["invert"] = true,
							["reactionType"] = "none",
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["width"] = 110,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["fader"] = {
							["height"] = 0.5,
						},
						["height"] = 30,
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["portrait"] = {
							["type"] = "3D",
							["fullAfter"] = 100,
							["order"] = 0,
							["isBar"] = false,
							["width"] = 0.22,
							["alignment"] = "RIGHT",
							["height"] = 1,
							["fullBefore"] = 0,
						},
						["text"] = {
							{
								["text"] = "[classcolor][abbrev:name]",
								["width"] = 10,
								["x"] = 0,
							}, -- [1]
							{
								["text"] = "",
								["width"] = 0,
								["x"] = 3,
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[(()afk() )][name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
					},
					["pet"] = {
						["xpBar"] = {
							["order"] = 55,
							["background"] = true,
							["height"] = 0.25,
						},
						["indicators"] = {
							["happiness"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorPoint"] = "TR",
								["size"] = 14,
							},
							["raidTarget"] = {
								["y"] = -20,
								["x"] = -7,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TR",
								["enabled"] = false,
								["size"] = 20,
							},
							["height"] = 0.5,
						},
						["range"] = {
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 60,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["enabled"] = false,
							["colorType"] = "type",
							["height"] = 0.4,
							["background"] = false,
							["invert"] = false,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["height"] = 1.4,
							["order"] = 10,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "none",
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["text"] = {
							{
								["width"] = 10,
								["anchorPoint"] = "C",
								["x"] = 0,
								["size"] = -1,
							}, -- [1]
							{
								["text"] = "",
								["y"] = -50,
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["incAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["width"] = 100,
						["fader"] = {
							["inactiveAlpha"] = 0.4,
							["combatAlpha"] = 0.4,
							["height"] = 0.5,
						},
						["incHeal"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["height"] = 18,
						["healAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["emptyBar"] = {
							["height"] = 0.8,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
					},
					["partypet"] = {
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["auras"] = {
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["highlight"] = {
							["size"] = 10,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["width"] = 90,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["height"] = 25,
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
							},
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[curhp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
					},
					["mainassist"] = {
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["resurrect"] = {
								["y"] = -1,
								["x"] = 37,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LC",
								["size"] = 28,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
						},
						["highlight"] = {
							["size"] = 10,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["auras"] = {
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 60,
						},
						["unitsPerColumn"] = 5,
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 1,
						},
						["offset"] = 5,
						["attribAnchorPoint"] = "LEFT",
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["incHeal"] = {
							["cap"] = 1,
						},
						["text"] = {
							{
								["text"] = "[(()afk() )][name]",
							}, -- [1]
							nil, -- [2]
							{
								["text"] = "[level( )][perpp]",
							}, -- [3]
							nil, -- [4]
							{
								["text"] = "[(()afk() )][name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["width"] = 150,
						["maxColumns"] = 1,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["columnSpacing"] = 5,
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
					},
					["player"] = {
						["portrait"] = {
							["enabled"] = true,
							["type"] = "3D",
							["fullAfter"] = 100,
							["order"] = 0,
							["isBar"] = true,
							["width"] = 0.21,
							["alignment"] = "LEFT",
							["height"] = 2.4,
							["fullBefore"] = 0,
						},
						["runeBar"] = {
							["enabled"] = true,
							["vertical"] = false,
							["reverse"] = false,
							["order"] = 100,
							["background"] = false,
							["invert"] = false,
							["height"] = 0.5,
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -2,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 2,
							},
							["autoHide"] = false,
							["height"] = 3.2,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 25,
							["background"] = false,
							["invert"] = false,
							["height"] = 1.3,
						},
						["healthBar"] = {
							["colorAggro"] = false,
							["order"] = 15,
							["colorType"] = "static",
							["reactionType"] = "npc",
							["background"] = true,
							["invert"] = false,
							["height"] = 1.3,
						},
						["druidBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["enabled"] = true,
							["order"] = 25,
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = false,
							["height"] = 3.2,
							["class"] = false,
							["backgroundColor"] = {
								["b"] = 1,
								["g"] = 1,
								["r"] = 1,
							},
							["order"] = 0,
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["enabled"] = false,
							["order"] = 100,
						},
						["height"] = 60,
						["auraPoints"] = {
							["enabled"] = true,
							["anchorTo"] = "$parent",
							["order"] = 60,
							["showAlways"] = true,
							["growth"] = "LEFT",
							["y"] = -7,
							["x"] = -16,
							["spacing"] = -4,
							["height"] = 0.4,
							["isBar"] = false,
							["anchorPoint"] = "RC",
							["size"] = 20,
						},
						["xpBar"] = {
							["order"] = 60,
							["background"] = true,
							["height"] = 0.5,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = -14,
								["size"] = 30,
							},
							["lfdRole"] = {
								["y"] = -32,
								["x"] = -3,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LT",
								["size"] = 17,
							},
							["resurrect"] = {
								["anchorPoint"] = "C",
								["x"] = -80,
								["anchorTo"] = "$parent",
								["y"] = -15,
								["size"] = 30,
							},
							["masterLoot"] = {
								["y"] = -13,
								["x"] = -24,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TC",
								["enabled"] = false,
								["size"] = 12,
							},
							["leader"] = {
								["anchorPoint"] = "LB",
								["x"] = -2,
								["anchorTo"] = "$parent",
								["y"] = 17,
								["enabled"] = false,
								["size"] = 19,
							},
							["role"] = {
								["y"] = 16,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
								["enabled"] = false,
								["size"] = 14,
							},
							["status"] = {
								["y"] = -32,
								["x"] = -18,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 21,
							},
							["ready"] = {
								["anchorPoint"] = "C",
								["x"] = 80,
								["anchorTo"] = "$parent",
								["y"] = -15,
								["size"] = 30,
							},
							["height"] = 0.5,
							["pvp"] = {
								["y"] = -25,
								["x"] = 50,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 22,
							},
						},
						["totemBar"] = {
							["height"] = 0.5,
							["background"] = true,
							["order"] = 25,
							["showAlways"] = true,
						},
						["incAbsorb"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["comboPoints"] = {
							["anchorTo"] = "$parent",
							["order"] = 15,
							["showAlways"] = false,
							["growth"] = "LEFT",
							["anchorPoint"] = "RC",
							["x"] = -16,
							["isBar"] = false,
							["spacing"] = 4,
							["height"] = 0.4,
							["background"] = false,
							["y"] = -7,
							["size"] = 20,
						},
						["chi"] = {
							["anchorTo"] = "$parent",
							["order"] = 60,
							["showAlways"] = true,
							["growth"] = "LEFT",
							["anchorPoint"] = "RC",
							["x"] = -16,
							["spacing"] = 0,
							["height"] = 0.4,
							["isBar"] = false,
							["y"] = -7,
							["size"] = 20,
						},
						["highlight"] = {
							["debuff"] = false,
							["height"] = 0.5,
							["mouseover"] = false,
							["aggro"] = false,
							["attention"] = false,
							["alpha"] = 1,
							["size"] = 5,
						},
						["disableVehicle"] = false,
						["shamanBar"] = {
							["order"] = 70,
							["background"] = true,
							["height"] = 0.3,
						},
						["priestBar"] = {
							["order"] = 70,
							["background"] = false,
							["height"] = 0.4,
						},
						["holyPower"] = {
							["anchorTo"] = "$parent",
							["order"] = 30,
							["isBar"] = false,
							["growth"] = "LEFT",
							["anchorPoint"] = "RC",
							["x"] = -16,
							["spacing"] = -4,
							["height"] = 0.4,
							["background"] = false,
							["y"] = -7,
							["size"] = 20,
						},
						["soulShards"] = {
							["anchorTo"] = "$parent",
							["order"] = 30,
							["growth"] = "LEFT",
							["anchorPoint"] = "RC",
							["x"] = -16,
							["spacing"] = -4,
							["height"] = 0.7,
							["background"] = true,
							["y"] = -10,
							["size"] = 16,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["enabled"] = true,
								["anchorOn"] = false,
								["enlarge"] = {
									["SELF"] = false,
								},
								["show"] = {
									["misc"] = false,
									["relevant"] = false,
									["raid"] = false,
								},
								["maxRows"] = 3,
								["perRow"] = 3,
								["x"] = -27,
								["y"] = -30,
								["anchorPoint"] = "LT",
								["size"] = 23,
							},
							["buffs"] = {
								["perRow"] = 7,
								["temporary"] = false,
								["anchorOn"] = false,
								["maxRows"] = 2,
								["show"] = {
									["misc"] = false,
									["raid"] = false,
									["consolidated"] = false,
								},
								["x"] = 9,
								["y"] = 26,
								["anchorPoint"] = "TL",
								["size"] = 28,
							},
						},
						["width"] = 274,
						["text"] = {
							{
								["text"] = "[hp:color][perhp]",
								["width"] = 10,
								["x"] = 4,
							}, -- [1]
							{
								["text"] = "[hp:color][curhp]",
								["width"] = 10,
								["y"] = 14,
								["x"] = -2,
								["anchorPoint"] = "TRI",
							}, -- [2]
							{
								["text"] = "[perpp]",
								["width"] = 10,
								["y"] = -1,
								["x"] = 4,
								["anchorPoint"] = "TLI",
							}, -- [3]
							{
								["text"] = "",
								["width"] = 7,
								["y"] = -20,
								["x"] = 2,
								["anchorPoint"] = "TR",
							}, -- [4]
							{
								["y"] = 3,
								["x"] = -1,
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 10,
								["y"] = 37,
								["x"] = 10,
								["name"] = "NameText",
								["anchorPoint"] = "TL",
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["width"] = 10,
								["y"] = 25,
								["x"] = -2,
								["name"] = "Percentage",
								["anchorPoint"] = "TRI",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "[afk:time]",
								["width"] = 10,
								["name"] = "AFK",
							}, -- [9]
							{
								["anchorTo"] = "$staggerBar",
								["text"] = "[monk:abs:stagger]",
								["width"] = 1,
								["default"] = true,
								["name"] = "Text",
							}, -- [10]
							{
								["anchorTo"] = "$runeBar",
								["width"] = 1,
								["default"] = true,
								["name"] = "Timer Text",
								["block"] = true,
							}, -- [11]
							{
								["anchorTo"] = "$totemBar",
								["width"] = 1,
								["default"] = true,
								["name"] = "Timer Text",
								["block"] = true,
							}, -- [12]
							{
								["anchorTo"] = "$staggerBar",
								["text"] = "[monk:abs:stagger]",
								["width"] = 1,
								["default"] = true,
								["name"] = "Text",
							}, -- [13]
							{
								["anchorTo"] = "$runeBar",
								["width"] = 1,
								["default"] = true,
								["name"] = "Timer Text",
								["block"] = true,
							}, -- [14]
							{
								["anchorTo"] = "$totemBar",
								["width"] = 1,
								["default"] = true,
								["name"] = "Timer Text",
								["block"] = true,
							}, -- [15]
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["fader"] = {
							["combatAlpha"] = 1,
							["inactiveAlpha"] = 1,
							["height"] = 0.5,
						},
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
							["y"] = -9,
						},
						["incHeal"] = {
							["height"] = 0.5,
							["cap"] = 1,
						},
						["healAbsorb"] = {
							["height"] = 0.5,
						},
						["arcaneCharges"] = {
							["anchorTo"] = "$parent",
							["order"] = 60,
							["showAlways"] = true,
							["growth"] = "LEFT",
							["anchorPoint"] = "BR",
							["x"] = -8,
							["spacing"] = -2,
							["height"] = 0.4,
							["y"] = 6,
							["size"] = 12,
						},
						["staggerBar"] = {
							["vertical"] = false,
							["reverse"] = false,
							["height"] = 0.5,
							["background"] = false,
							["invert"] = false,
							["order"] = 100,
						},
					},
					["maintanktarget"] = {
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["highlight"] = {
							["size"] = 10,
						},
						["text"] = {
							{
								["text"] = "[(()afk() )][name]",
							}, -- [1]
							nil, -- [2]
							{
								["text"] = "[classification( )][perpp]",
							}, -- [3]
							nil, -- [4]
							{
								["text"] = "[(()afk() )][name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["auras"] = {
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["width"] = 150,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
						},
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
					},
					["targettarget"] = {
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["enlarge"] = {
									["SELF"] = false,
								},
								["y"] = 3,
								["x"] = -1,
								["anchorPoint"] = "BL",
								["maxRows"] = 1,
								["size"] = 15,
							},
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
						},
						["portrait"] = {
							["type"] = "3D",
							["fullAfter"] = 100,
							["order"] = 15,
							["isBar"] = false,
							["width"] = 0.22,
							["alignment"] = "RIGHT",
							["height"] = 0.5,
							["fullBefore"] = 0,
						},
						["highlight"] = {
							["height"] = 0.5,
							["mouseover"] = false,
							["size"] = 10,
						},
						["emptyBar"] = {
							["height"] = 0.9,
							["class"] = false,
							["order"] = 0,
							["background"] = true,
							["backgroundColor"] = {
								["b"] = 0.0627450980392157,
								["g"] = 0.0627450980392157,
								["r"] = 0.0627450980392157,
							},
							["reactionType"] = "none",
						},
						["range"] = {
							["height"] = 0.5,
						},
						["width"] = 110,
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["text"] = {
							{
								["text"] = "[classcolor][abbrev:name]",
								["width"] = 10,
								["anchorPoint"] = "C",
								["x"] = 0,
							}, -- [1]
							{
								["text"] = "",
								["width"] = 0,
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
								["size"] = -1,
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 13,
								["x"] = 41,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["enabled"] = false,
								["size"] = 20,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
							["height"] = 0.5,
						},
						["height"] = 28,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["enabled"] = false,
							["colorType"] = "type",
							["order"] = 20,
							["background"] = false,
							["predicted"] = true,
							["height"] = 0.4,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 10,
							["reactionType"] = "none",
							["background"] = true,
							["invert"] = false,
							["height"] = 1.4,
						},
					},
					["raidpet"] = {
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["auras"] = {
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["groupSpacing"] = 0,
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 0.3,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1.2,
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "[missinghp]",
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["maxColumns"] = 8,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["height"] = 30,
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
						},
						["scale"] = 0.85,
						["attribAnchorPoint"] = "LEFT",
						["columnSpacing"] = 5,
						["unitsPerColumn"] = 8,
						["width"] = 90,
						["groupsPerRow"] = 8,
						["incHeal"] = {
							["cap"] = 1,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["highlight"] = {
							["size"] = 10,
						},
					},
					["maintank"] = {
						["highlight"] = {
							["size"] = 10,
						},
						["incHeal"] = {
							["cap"] = 1,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
							["resurrect"] = {
								["y"] = -1,
								["x"] = 37,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LC",
								["size"] = 28,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["auras"] = {
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 60,
						},
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
						},
						["offset"] = 5,
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["attribAnchorPoint"] = "LEFT",
						["text"] = {
							{
								["text"] = "[(()afk() )][name]",
							}, -- [1]
							nil, -- [2]
							{
								["text"] = "[perpp]",
							}, -- [3]
							nil, -- [4]
							{
								["text"] = "[(()afk() )][name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "Percentage",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["width"] = 150,
						["maxColumns"] = 1,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["columnSpacing"] = 5,
						["unitsPerColumn"] = 5,
					},
					["boss"] = {
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["range"] = {
							["height"] = 0.5,
							["enabled"] = true,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["perRow"] = 8,
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["perRow"] = 15,
								["anchorOn"] = false,
								["anchorPoint"] = "BL",
								["enabled"] = true,
								["x"] = 0,
								["y"] = -2,
								["size"] = 22,
							},
						},
						["castBar"] = {
							["enabled"] = true,
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = -1,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = -1,
							},
							["autoHide"] = true,
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["predicted"] = true,
							["height"] = 0.2,
							["order"] = 20,
							["background"] = false,
							["invert"] = false,
							["colorType"] = "type",
						},
						["offset"] = 30,
						["healthBar"] = {
							["colorType"] = "static",
							["reactionType"] = "none",
							["order"] = 10,
							["background"] = true,
							["invert"] = false,
							["height"] = 1.2,
						},
						["text"] = {
							{
								["text"] = "[abbrev:name]",
								["width"] = 1,
							}, -- [1]
							{
								["text"] = "[hp:color][curhp]",
								["width"] = 1,
								["y"] = 6,
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 1,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["width"] = 1,
								["y"] = -8,
								["x"] = -3,
								["name"] = "Percentage",
								["anchorPoint"] = "CRI",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 1,
								["name"] = "AFK",
							}, -- [9]
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["width"] = 200,
						["portrait"] = {
							["fullBefore"] = 0,
							["fullAfter"] = 100,
							["order"] = 15,
							["isBar"] = false,
							["width"] = 0.2,
							["alignment"] = "LEFT",
							["height"] = 0.5,
							["type"] = "3D",
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["height"] = 60,
						["enabled"] = true,
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 12,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 25,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
							["height"] = 0.5,
						},
					},
					["battleground"] = {
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["range"] = {
							["enabled"] = true,
							["oorAlpha"] = 0.6,
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["perRow"] = 9,
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["perRow"] = 15,
								["show"] = {
									["misc"] = false,
								},
								["x"] = 0,
								["enabled"] = true,
								["y"] = -2,
								["anchorPoint"] = "BL",
								["size"] = 22,
							},
						},
						["castBar"] = {
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["autoHide"] = true,
							["order"] = 60,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.2,
							["background"] = false,
							["order"] = 20,
						},
						["offset"] = 30,
						["healthBar"] = {
							["order"] = 10,
							["reactionType"] = "none",
							["vertical"] = false,
							["background"] = true,
							["reverse"] = false,
							["height"] = 1.2,
							["colorDispel"] = false,
							["invert"] = false,
							["colorType"] = "static",
						},
						["text"] = {
							{
								["text"] = "[classcolor][abbrev:name]",
								["width"] = 1,
								["x"] = 6,
								["y"] = 6,
							}, -- [1]
							{
								["text"] = "[hp:color][curhp]",
								["width"] = 1,
								["y"] = 6,
							}, -- [2]
							{
								["text"] = "",
							}, -- [3]
							{
								["text"] = "",
							}, -- [4]
							{
								["text"] = "[name]",
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["width"] = 1,
								["y"] = -8,
								["x"] = -3,
								["name"] = "Percentage",
								["default"] = true,
								["anchorPoint"] = "CRI",
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "[faction]",
								["width"] = 1,
								["y"] = -8,
								["x"] = 6,
								["name"] = "AFK",
								["anchorPoint"] = "CLI",
								["size"] = -1,
							}, -- [8]
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["width"] = 200,
						["portrait"] = {
							["type"] = "class",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["height"] = 50,
						["enabled"] = true,
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 3,
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 16,
							},
							["height"] = 0.5,
							["pvp"] = {
								["y"] = -8,
								["x"] = 16,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LC",
								["enabled"] = false,
								["size"] = 40,
							},
						},
					},
				},
				["auras"] = {
					["borderType"] = "dark",
				},
				["font"] = {
					["color"] = {
						["a"] = 1,
						["r"] = 0.96078431372549,
						["g"] = 1,
						["b"] = 0.92156862745098,
					},
					["name"] = "MUI_Font",
					["extra"] = "",
					["shadowColor"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0,
						["r"] = 0,
					},
					["shadowY"] = -0.8,
					["shadowX"] = 0.8,
					["size"] = 10,
				},
				["omnicc"] = true,
				["classColors"] = {
					["DEATHKNIGHT"] = {
						["a"] = 1,
						["b"] = 0.23,
						["g"] = 0.12,
						["r"] = 0.77,
					},
					["WARRIOR"] = {
						["a"] = 1,
						["b"] = 0.43,
						["g"] = 0.61,
						["r"] = 0.78,
					},
					["SHAMAN"] = {
						["a"] = 1,
						["b"] = 0.87,
						["g"] = 0.44,
						["r"] = 0,
					},
					["MAGE"] = {
						["a"] = 1,
						["b"] = 0.94,
						["g"] = 0.8,
						["r"] = 0.41,
					},
					["VEHICLE"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0.701960784313726,
						["r"] = 0.203921568627451,
					},
					["PRIEST"] = {
						["a"] = 1,
						["b"] = 1,
						["g"] = 1,
						["r"] = 1,
					},
					["ROGUE"] = {
						["a"] = 1,
						["b"] = 0.41,
						["g"] = 0.96,
						["r"] = 1,
					},
					["HUNTER"] = {
						["a"] = 1,
						["b"] = 0.45,
						["g"] = 0.83,
						["r"] = 0.67,
					},
					["WARLOCK"] = {
						["a"] = 1,
						["b"] = 0.79,
						["g"] = 0.51,
						["r"] = 0.58,
					},
					["DEMONHUNTER"] = {
						["r"] = 0.64,
						["g"] = 0.19,
						["b"] = 0.79,
					},
					["PET"] = {
						["a"] = 1,
						["b"] = 0.105882352941177,
						["g"] = 0.470588235294118,
						["r"] = 0.105882352941177,
					},
					["DRUID"] = {
						["a"] = 1,
						["b"] = 0.04,
						["g"] = 0.49,
						["r"] = 1,
					},
					["MONK"] = {
						["a"] = 1,
						["b"] = 0.59,
						["g"] = 1,
						["r"] = 0,
					},
					["PALADIN"] = {
						["a"] = 1,
						["b"] = 0.73,
						["g"] = 0.55,
						["r"] = 0.96,
					},
				},
				["backdrop"] = {
					["borderColor"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0,
						["r"] = 0,
					},
					["edgeSize"] = 1,
					["tileSize"] = 20,
					["borderTexture"] = "Pixel",
					["backgroundColor"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0,
						["r"] = 0,
					},
					["backgroundTexture"] = "Solid",
					["clip"] = 1,
					["inset"] = 0,
				},
				["bars"] = {
					["backgroundAlpha"] = 0.3,
					["spacing"] = -1.15,
					["backgroundColor"] = {
						["a"] = 1,
						["b"] = 1,
						["g"] = 1,
						["r"] = 1,
					},
					["alpha"] = 1,
					["texture"] = "MUI_StatusBar",
				},
				["auraColors"] = {
					["removable"] = {
						["a"] = 1,
						["b"] = 1,
						["g"] = 1,
						["r"] = 1,
					},
				},
			},
		},
	};

	for k, v in pairs(settings) do
		_G.ShadowedUFDB[k] = v;
	end
end