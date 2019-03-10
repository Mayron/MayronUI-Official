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
					["battlegroundpet"] = {
						["anchorPoint"] = "RB",
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
						["point"] = "BOTTOM",
						["anchorTo"] = "#SUFUnittargettarget",
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
				["auras"] = {
					["borderType"] = "dark",
				},
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
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
						},
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
								["enabled"] = false,
								["anchorPoint"] = "C",
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
						["height"] = 41,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 0.2,
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
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
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
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
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
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["width"] = 150,
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
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
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
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 1,
						},
						["highlight"] = {
							["size"] = 10,
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
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
						},
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
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
							["height"] = 0.5,
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
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 0.6,
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
						["range"] = {
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
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
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 0.6,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
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
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["fader"] = {
							["height"] = 0.5,
						},
						["height"] = 25,
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
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
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
							["height"] = 0.5,
						},
					},
					["arenatargettarget"] = {
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
						},
						["highlight"] = {
							["size"] = 10,
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
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
							["order"] = 20,
							["background"] = true,
							["height"] = 0.6,
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
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
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
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.2,
							["background"] = true,
							["invert"] = false,
							["order"] = 20,
						},
						["offset"] = 4,
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
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
					},
					["arenapet"] = {
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
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
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
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 0.6,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["width"] = 90,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["height"] = 25,
						["highlight"] = {
							["size"] = 10,
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
					["mainassisttargettarget"] = {
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
						},
						["highlight"] = {
							["size"] = 10,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
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
						["width"] = 150,
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
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
							["order"] = 20,
							["background"] = true,
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
					},
					["party"] = {
						["portrait"] = {
							["type"] = "3D",
							["fullAfter"] = 50,
							["order"] = 15,
							["isBar"] = false,
							["width"] = 0.2,
							["alignment"] = "LEFT",
							["height"] = 0.5,
							["fullBefore"] = 0,
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
								["anchorPoint"] = "TL",
								["y"] = -31,
								["x"] = 198,
								["size"] = 24,
							},
							["debuffs"] = {
								["enabled"] = true,
								["enlarge"] = {
									["SELF"] = false,
								},
								["anchorPoint"] = "LB",
								["x"] = -2,
								["perRow"] = 1,
								["maxRows"] = 5,
								["y"] = 0,
								["size"] = 30,
							},
						},
						["castBar"] = {
							["enabled"] = true,
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
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
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
						["height"] = 60,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["hideAnyRaid"] = true,
						["attribAnchorPoint"] = "LEFT",
						["offset"] = 2,
						["disableVehicle"] = false,
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 10,
							["reactionType"] = "none",
							["background"] = true,
							["invert"] = false,
							["height"] = 1.2,
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
								["text"] = "[levelcolor][classcolor][( )name]",
								["width"] = 5,
								["y"] = -4,
							}, -- [1]
							{
								["text"] = "[curhp]",
								["width"] = 5,
								["x"] = -2,
								["y"] = -5,
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
								["width"] = 0.5,
								["y"] = -14,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["width"] = 5,
								["y"] = 5,
								["x"] = -2,
								["name"] = "Percentage",
								["anchorPoint"] = "CRI",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "[afk:time]",
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorPoint"] = "TL",
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
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
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
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
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
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["width"] = 150,
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
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
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
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 1,
						},
						["highlight"] = {
							["size"] = 10,
						},
					},
					["focus"] = {
						["portrait"] = {
							["type"] = "3D",
							["fullAfter"] = 100,
							["order"] = 0,
							["isBar"] = true,
							["width"] = 0.16,
							["alignment"] = "RIGHT",
							["height"] = 2.3,
							["fullBefore"] = 0,
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
								["perRow"] = 3,
								["anchorPoint"] = "RT",
								["y"] = -30,
								["size"] = 24,
							},
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
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
							["background"] = true,
							["invert"] = false,
							["height"] = 0.6,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["height"] = 1.9,
							["order"] = 0,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "none",
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
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
							["height"] = 0.5,
							["petBattle"] = {
								["enabled"] = false,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["y"] = -32,
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
						["emptyBar"] = {
							["order"] = 70,
							["reactionType"] = "none",
							["background"] = true,
							["backgroundColor"] = {
								["r"] = 0.0980392156862745,
								["g"] = 0.0980392156862745,
								["b"] = 0.0980392156862745,
							},
							["height"] = 0.8,
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
								["name"] = "NameText",
								["default"] = true,
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
							["background"] = true,
							["invert"] = false,
							["height"] = 0.8,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["colorAggro"] = false,
							["order"] = 0,
							["reactionType"] = "none",
							["background"] = true,
							["invert"] = false,
							["height"] = 1.8,
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
								["y"] = 11,
								["x"] = 55,
								["anchorPoint"] = "TR",
								["size"] = 2,
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 10,
								["y"] = 37,
								["x"] = -10,
								["name"] = "NameText",
								["default"] = true,
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
								["text"] = "[afk:time]",
								["width"] = 10,
								["name"] = "AFK",
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
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
							["height"] = 0.5,
							["petBattle"] = {
								["enabled"] = false,
								["x"] = -6,
								["anchorTo"] = "$parent",
								["y"] = 14,
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
						["width"] = 274,
						["emptyBar"] = {
							["order"] = 0,
							["background"] = false,
							["reactionType"] = "none",
							["class"] = false,
							["backgroundColor"] = {
								["r"] = 0.0901960784313726,
								["g"] = 0.0901960784313726,
								["b"] = 0.0901960784313726,
							},
							["height"] = 1.3,
						},
						["height"] = 60,
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
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
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
								["show"] = {
									["misc"] = false,
									["relevant"] = false,
									["raid"] = false,
								},
								["x"] = -2,
								["y"] = -11,
								["perRow"] = 5,
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
						["frameSplit"] = true,
						["groupSpacing"] = -34,
						["powerBar"] = {
							["colorType"] = "type",
							["reverse"] = false,
							["order"] = 20,
							["background"] = true,
							["invert"] = false,
							["height"] = 0.2,
						},
						["offset"] = 2,
						["healthBar"] = {
							["colorType"] = "static",
							["reactionType"] = "none",
							["order"] = 10,
							["background"] = true,
							["invert"] = false,
							["height"] = 2,
						},
						["hideSemiRaid"] = false,
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["maxColumns"] = 8,
						["sortOrder"] = "DESC",
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["enabled"] = false,
							["height"] = 0.4,
						},
						["height"] = 50,
						["highlight"] = {
							["debuff"] = true,
							["aggro"] = true,
							["mouseover"] = false,
							["height"] = 0.5,
							["attention"] = false,
							["alpha"] = 1,
							["size"] = 10,
						},
						["range"] = {
							["enabled"] = true,
							["oorAlpha"] = 0.6,
							["height"] = 0.5,
						},
						["incAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["auraIndicators"] = {
							["enabled"] = true,
							["height"] = 0.5,
						},
						["groupsPerRow"] = 8,
						["unitsPerColumn"] = 25,
						["text"] = {
							{
								["text"] = "[colorname]",
								["width"] = 1,
								["anchorPoint"] = "C",
								["x"] = 0,
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
								["text"] = "[afk:time]",
								["width"] = 0.5,
								["x"] = -16,
								["name"] = "AFK",
							}, -- [9]
						},
						["width"] = 70,
						["showParty"] = false,
						["columnSpacing"] = 2,
						["fader"] = {
							["height"] = 0.5,
						},
						["combatText"] = {
							["height"] = 0.5,
						},
						["incHeal"] = {
							["height"] = 0.5,
							["cap"] = 1,
						},
						["healAbsorb"] = {
							["height"] = 0.5,
						},
						["enabled"] = true,
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
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
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
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
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
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
						},
						["highlight"] = {
							["size"] = 10,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
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
						["width"] = 150,
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
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
							["order"] = 20,
							["background"] = true,
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
								["anchorOn"] = false,
								["y"] = -2,
								["enabled"] = true,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 22,
							},
							["debuffs"] = {
								["perRow"] = 9,
								["anchorOn"] = false,
								["anchorPoint"] = "BL",
								["x"] = 0,
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
							["colorType"] = "type",
							["height"] = 0.2,
							["background"] = true,
							["order"] = 20,
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
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
							["arenaSpec"] = {
								["y"] = 15,
								["x"] = -4,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LC",
								["size"] = 30,
							},
						},
						["width"] = 200,
						["portrait"] = {
							["type"] = "3D",
							["fullAfter"] = 50,
							["order"] = 15,
							["isBar"] = true,
							["width"] = 0.22,
							["alignment"] = "LEFT",
							["height"] = 0.5,
							["fullBefore"] = 0,
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
						["enabled"] = true,
					},
					["partytargettarget"] = {
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
						},
						["highlight"] = {
							["size"] = 10,
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
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
							["order"] = 20,
							["background"] = true,
							["height"] = 0.6,
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
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
						},
						["highlight"] = {
							["size"] = 10,
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
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
							["order"] = 20,
							["background"] = true,
							["height"] = 0.6,
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
						["auras"] = {
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
						},
						["highlight"] = {
							["size"] = 10,
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
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
							["order"] = 20,
							["background"] = true,
							["height"] = 0.6,
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
								["anchorTo"] = "$parent",
								["y"] = 0,
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
							["reactionType"] = "none",
							["order"] = 10,
							["background"] = true,
							["invert"] = true,
							["height"] = 1.4,
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
						["width"] = 110,
						["fader"] = {
							["height"] = 0.5,
						},
						["portrait"] = {
							["fullBefore"] = 0,
							["fullAfter"] = 100,
							["order"] = 0,
							["isBar"] = false,
							["width"] = 0.22,
							["alignment"] = "RIGHT",
							["height"] = 1,
							["type"] = "3D",
						},
						["height"] = 30,
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
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
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
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
							["colorType"] = "type",
							["height"] = 0.2,
							["background"] = true,
							["order"] = 20,
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
								["anchorTo"] = "$parent",
								["y"] = 0,
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
						["highlight"] = {
							["size"] = 10,
						},
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
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
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 0.6,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["width"] = 90,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
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
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
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
								["name"] = "Percentage",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [8]
						},
					},
					["targettarget"] = {
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
						["healthBar"] = {
							["colorType"] = "static",
							["height"] = 1.4,
							["order"] = 10,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "none",
						},
						["highlight"] = {
							["height"] = 0.5,
							["mouseover"] = false,
							["size"] = 10,
						},
						["emptyBar"] = {
							["height"] = 0.9,
							["background"] = true,
							["reactionType"] = "none",
							["class"] = false,
							["backgroundColor"] = {
								["r"] = 0.0627450980392157,
								["g"] = 0.0627450980392157,
								["b"] = 0.0627450980392157,
							},
							["order"] = 0,
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
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
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
								["anchorTo"] = "$parent",
								["y"] = 0,
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
							["background"] = true,
							["height"] = 0.4,
							["predicted"] = true,
						},
						["portrait"] = {
							["fullBefore"] = 0,
							["fullAfter"] = 100,
							["order"] = 15,
							["isBar"] = false,
							["width"] = 0.22,
							["alignment"] = "RIGHT",
							["height"] = 0.5,
							["type"] = "3D",
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
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
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
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 0.6,
						},
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
					},
					["pettarget"] = {
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
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
						["width"] = 190,
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
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
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
						["height"] = 30,
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 0.7,
						},
						["highlight"] = {
							["size"] = 10,
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
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.8,
							["background"] = true,
							["invert"] = false,
							["order"] = 25,
						},
						["healthBar"] = {
							["colorAggro"] = false,
							["order"] = 15,
							["colorType"] = "static",
							["reactionType"] = "npc",
							["background"] = true,
							["invert"] = false,
							["height"] = 1.8,
						},
						["druidBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 25,
							["enabled"] = true,
						},
						["text"] = {
							{
								["text"] = "[hp:color][perhp]",
								["width"] = 10,
								["x"] = 4,
								["size"] = 3,
							}, -- [1]
							{
								["text"] = "[hp:color][curhp]",
								["width"] = 10,
								["y"] = 14,
								["x"] = -2,
								["anchorPoint"] = "TRI",
							}, -- [2]
							{
								["text"] = "",
								["width"] = 10,
								["y"] = 7,
								["x"] = 2,
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
								["name"] = "Text",
								["default"] = true,
							}, -- [10]
							{
								["anchorTo"] = "$runeBar",
								["width"] = 1,
								["name"] = "Timer Text",
								["default"] = true,
								["block"] = true,
							}, -- [11]
							{
								["anchorTo"] = "$totemBar",
								["width"] = 1,
								["name"] = "Timer Text",
								["default"] = true,
								["block"] = true,
							}, -- [12]
							{
								["anchorTo"] = "$staggerBar",
								["text"] = "[monk:abs:stagger]",
								["width"] = 1,
								["name"] = "Text",
								["default"] = true,
							}, -- [13]
							{
								["anchorTo"] = "$runeBar",
								["width"] = 1,
								["name"] = "Timer Text",
								["default"] = true,
								["block"] = true,
							}, -- [14]
							{
								["anchorTo"] = "$totemBar",
								["width"] = 1,
								["name"] = "Timer Text",
								["default"] = true,
								["block"] = true,
							}, -- [15]
						},
						["priestBar"] = {
							["order"] = 70,
							["background"] = true,
							["height"] = 0.4,
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
							["showAlways"] = true,
							["order"] = 25,
							["background"] = true,
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
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["enabled"] = false,
							["order"] = 100,
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
						["disableVehicle"] = false,
						["shamanBar"] = {
							["order"] = 70,
							["background"] = true,
							["height"] = 0.3,
						},
						["incAbsorb"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
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
							["buffs"] = {
								["perRow"] = 7,
								["temporary"] = false,
								["anchorOn"] = false,
								["y"] = 26,
								["anchorPoint"] = "TL",
								["x"] = 9,
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["class"] = false,
							["order"] = 0,
							["background"] = false,
							["backgroundColor"] = {
								["r"] = 1,
								["g"] = 1,
								["b"] = 1,
							},
							["height"] = 3.2,
						},
						["staggerBar"] = {
							["vertical"] = false,
							["reverse"] = false,
							["height"] = 0.5,
							["background"] = false,
							["invert"] = false,
							["order"] = 100,
						},
						["fader"] = {
							["combatAlpha"] = 1,
							["height"] = 0.5,
							["inactiveAlpha"] = 1,
						},
						["combatText"] = {
							["y"] = -9,
							["height"] = 0.5,
							["enabled"] = false,
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
						["width"] = 274,
					},
					["mainassist"] = {
						["highlight"] = {
							["size"] = 10,
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
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
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
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
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
						["unitsPerColumn"] = 5,
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
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
						["attribAnchorPoint"] = "LEFT",
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["width"] = 150,
						["maxColumns"] = 1,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["columnSpacing"] = 5,
						["incHeal"] = {
							["cap"] = 1,
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
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
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
							["background"] = true,
							["invert"] = false,
							["order"] = 20,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["reactionType"] = "none",
							["height"] = 1.4,
							["background"] = true,
							["invert"] = false,
							["order"] = 10,
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
							["fullAfter"] = 100,
							["order"] = 15,
							["isBar"] = false,
							["width"] = 0.2,
							["alignment"] = "LEFT",
							["height"] = 0.5,
							["fullBefore"] = 0,
						},
						["range"] = {
							["enabled"] = true,
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["perRow"] = 15,
								["anchorOn"] = false,
								["y"] = -2,
								["enabled"] = true,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 22,
							},
							["debuffs"] = {
								["perRow"] = 8,
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
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
							["background"] = true,
							["invert"] = false,
							["height"] = 0.2,
						},
						["offset"] = 30,
						["healthBar"] = {
							["colorType"] = "static",
							["height"] = 1.2,
							["reactionType"] = "none",
							["background"] = true,
							["invert"] = false,
							["order"] = 10,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["text"] = {
							{
								["text"] = "[abbrev:name]",
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
								["text"] = "[faction]",
								["width"] = 0.5,
								["default"] = true,
								["name"] = "NameText",
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["width"] = 1,
								["anchorPoint"] = "CRI",
								["x"] = -3,
								["name"] = "Percentage",
								["y"] = -8,
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
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
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
							["height"] = 0.5,
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
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
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
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
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
							["resurrect"] = {
								["y"] = -1,
								["x"] = 37,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LC",
								["size"] = 28,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
						},
						["unitsPerColumn"] = 5,
						["width"] = 150,
						["maxColumns"] = 1,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["incHeal"] = {
							["cap"] = 1,
						},
						["columnSpacing"] = 5,
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
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
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
							["colorType"] = "type",
							["height"] = 0.3,
							["background"] = true,
							["order"] = 20,
						},
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
						["columnSpacing"] = 5,
						["groupsPerRow"] = 8,
						["attribAnchorPoint"] = "LEFT",
						["width"] = 90,
						["unitsPerColumn"] = 8,
						["incHeal"] = {
							["cap"] = 1,
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
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["perRow"] = 15,
								["y"] = -2,
								["enabled"] = true,
								["show"] = {
									["misc"] = false,
								},
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 22,
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
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 0.2,
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
								["text"] = "[classcolor][abbrev:name]",
								["width"] = 2,
								["y"] = 6,
								["x"] = 6,
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
								["default"] = true,
								["name"] = "Percentage",
								["anchorPoint"] = "CRI",
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "[faction]",
								["width"] = 6,
								["y"] = -8,
								["x"] = 6,
								["name"] = "AFK",
								["anchorPoint"] = "CLI",
								["size"] = -1,
							}, -- [8]
						},
						["offset"] = 30,
						["width"] = 200,
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
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
								["y"] = 12,
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
				["wowBuild"] = 80100,
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
					["ECLIPSE_SUN"] = {
						["r"] = 1,
						["g"] = 1,
						["b"] = 0,
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
					["targettarget"] = {
						["y"] = -100,
						["x"] = 100,
						["point"] = "TOP",
						["relativePoint"] = "TOP",
						["anchorTo"] = "UIParent",
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
						["top"] = 234.394423498521,
						["x"] = -8,
						["anchorTo"] = "#SUFUnittarget",
						["anchorPoint"] = "TR",
						["bottom"] = 125.894446708569,
						["y"] = 30,
					},
					["maintanktargettarget"] = {
						["anchorPoint"] = "RT",
						["x"] = 150,
						["anchorTo"] = "$parent",
					},
					["focus"] = {
						["y"] = 30,
						["point"] = "BOTTOM",
						["anchorTo"] = "#SUFUnittargettarget",
						["relativePoint"] = "TOP",
					},
					["target"] = {
						["y"] = -28.2,
						["x"] = 21.2,
						["point"] = "BOTTOMLEFT",
						["relativePoint"] = "TOPRIGHT",
						["anchorTo"] = "#SUFUnittargettarget",
					},
					["raid"] = {
						["top"] = 325.588113962103,
						["x"] = -78,
						["point"] = "BOTTOMLEFT",
						["anchorTo"] = "#SUFUnittarget",
						["anchorPoint"] = "TR",
						["bottom"] = 144.988277254985,
						["y"] = 30,
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
						["top"] = 694.924347296368,
						["x"] = 349.999994039536,
						["bottom"] = 400.924395027767,
						["anchorPoint"] = "C",
						["y"] = -69.9999988079071,
					},
					["battlegroundtargettarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["bosstargettarget"] = {
						["anchorPoint"] = "RB",
						["anchorTo"] = "$parent",
					},
					["focustarget"] = {
						["point"] = "BOTTOM",
						["relativePoint"] = "BOTTOM",
						["y"] = 44.3799992442131,
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
						["point"] = "BOTTOM",
						["anchorTo"] = "#SUFUnittargettarget",
						["relativePoint"] = "TOP",
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
					["pettarget"] = {
						["anchorPoint"] = "C",
					},
					["raidpet"] = {
						["anchorPoint"] = "C",
					},
					["maintank"] = {
						["anchorPoint"] = "C",
					},
					["boss"] = {
						["top"] = 472.037711687808,
						["x"] = 349.999994039536,
						["bottom"] = 178.037770100359,
						["anchorPoint"] = "C",
						["y"] = -69.9999988079071,
					},
					["battleground"] = {
						["top"] = 435.155650548328,
						["x"] = 349.999994039536,
						["bottom"] = 204.155590395321,
						["anchorPoint"] = "C",
						["y"] = -69.9999988079071,
					},
				},
				["revision"] = 59,
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
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
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
							["background"] = true,
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
							["order"] = 40,
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
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["width"] = 150,
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
						["height"] = 25,
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
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
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["width"] = 90,
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
							["background"] = true,
							["invert"] = false,
							["order"] = 20,
						},
						["enabled"] = true,
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1.2,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["width"] = 156,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["offset"] = 4,
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
					},
					["arenapet"] = {
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
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
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
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["width"] = 150,
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
								["enabled"] = true,
								["enlarge"] = {
									["SELF"] = false,
								},
								["y"] = 0,
								["maxRows"] = 5,
								["perRow"] = 1,
								["x"] = -2,
								["anchorPoint"] = "LB",
								["size"] = 30,
							},
							["buffs"] = {
								["perRow"] = 3,
								["anchorPoint"] = "TL",
								["y"] = -31,
								["x"] = 198,
								["size"] = 24,
							},
						},
						["castBar"] = {
							["enabled"] = true,
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
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
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["hideAnyRaid"] = true,
						["incHeal"] = {
							["height"] = 0.5,
							["cap"] = 1,
						},
						["incAbsorb"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["predicted"] = true,
							["height"] = 0.2,
							["order"] = 20,
							["background"] = true,
							["invert"] = false,
							["onlyMana"] = false,
						},
						["unitsPerColumn"] = 5,
						["offset"] = 2,
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
						["fader"] = {
							["inactiveAlpha"] = 1,
							["height"] = 0.5,
						},
						["attribAnchorPoint"] = "LEFT",
						["height"] = 60,
						["width"] = 200,
						["text"] = {
							{
								["text"] = "[levelcolor][classcolor][( )name]",
								["width"] = 5,
								["y"] = -4,
							}, -- [1]
							{
								["text"] = "[curhp]",
								["width"] = 5,
								["x"] = -2,
								["y"] = -5,
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
								["width"] = 0.5,
								["y"] = -14,
								["default"] = true,
								["name"] = "NameText",
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["width"] = 5,
								["anchorPoint"] = "CRI",
								["x"] = -2,
								["name"] = "Percentage",
								["y"] = 5,
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "[afk:time]",
								["width"] = 0.5,
								["name"] = "AFK",
								["anchorPoint"] = "TL",
							}, -- [9]
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
							["enabled"] = false,
							["height"] = 0.4,
						},
						["combatText"] = {
							["height"] = 0.5,
						},
						["columnSpacing"] = -30,
						["healAbsorb"] = {
							["height"] = 0.5,
						},
						["highlight"] = {
							["height"] = 0.5,
							["aggro"] = true,
							["alpha"] = 1,
							["size"] = 10,
						},
						["attribPoint"] = "TOP",
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
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
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["width"] = 150,
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
								["y"] = -32,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["enabled"] = false,
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
								["perRow"] = 3,
								["anchorPoint"] = "RT",
								["maxRows"] = 2,
								["x"] = 30,
								["y"] = -30,
								["show"] = {
									["player"] = false,
								},
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
							["background"] = true,
							["invert"] = false,
							["colorType"] = "type",
						},
						["healthBar"] = {
							["colorType"] = "static",
							["reactionType"] = "none",
							["height"] = 1.9,
							["background"] = true,
							["invert"] = false,
							["order"] = 0,
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
								["anchorPoint"] = "C",
								["x"] = 0,
								["y"] = 1,
							}, -- [1]
							{
								["text"] = "",
								["width"] = 10,
								["anchorPoint"] = "TRI",
								["x"] = 0,
								["y"] = 14,
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
								["anchorPoint"] = "TR",
								["x"] = -10,
								["default"] = true,
								["name"] = "NameText",
								["y"] = 39,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 10,
								["anchorPoint"] = "TRI",
								["name"] = "Percentage",
								["y"] = 26,
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
							["inactiveAlpha"] = 1,
							["height"] = 0.5,
						},
						["incHeal"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = false,
							["height"] = 0.4,
						},
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["height"] = 18,
						["healAbsorb"] = {
							["enabled"] = false,
							["height"] = 0.5,
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
								["y"] = 14,
								["x"] = -6,
								["anchorTo"] = "$parent",
								["enabled"] = false,
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
						["range"] = {
							["height"] = 0.5,
							["oorAlpha"] = 0.4,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["perRow"] = 2,
								["anchorOn"] = false,
								["enlarge"] = {
									["SELF"] = false,
								},
								["show"] = {
									["raid"] = false,
									["misc"] = false,
								},
								["maxRows"] = 2,
								["anchorPoint"] = "BL",
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
								["anchorPoint"] = "RT",
								["x"] = 27,
								["size"] = 23,
							},
						},
						["castBar"] = {
							["name"] = {
								["y"] = 0,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["rank"] = false,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 2,
							},
							["time"] = {
								["y"] = 0,
								["x"] = -2,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
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
							["background"] = true,
							["invert"] = false,
							["colorType"] = "type",
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
							["height"] = 0.5,
							["order"] = 99,
						},
						["text"] = {
							{
								["text"] = "[hp:color][perhp]",
								["width"] = 10,
								["anchorPoint"] = "TLI",
								["x"] = 4,
								["y"] = -5,
								["size"] = 3,
							}, -- [1]
							{
								["text"] = "[hp:color][curhp]",
								["width"] = 10,
								["anchorPoint"] = "TRI",
								["x"] = -2,
								["y"] = 13,
							}, -- [2]
							{
								["text"] = "[color:gensit]",
								["width"] = 10,
								["anchorPoint"] = "TL",
								["x"] = 0,
								["y"] = -19,
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
								["anchorPoint"] = "TR",
								["x"] = -10,
								["default"] = true,
								["name"] = "NameText",
								["y"] = 37,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["width"] = 10,
								["anchorPoint"] = "TRI",
								["x"] = -2,
								["name"] = "Percentage",
								["y"] = 26,
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "[afk:time]",
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
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["combatText"] = {
							["y"] = -9,
							["height"] = 0.5,
							["enabled"] = false,
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
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
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
									["player"] = false,
									["misc"] = false,
								},
								["maxRows"] = 1,
								["perRow"] = 5,
								["anchorPoint"] = "BL",
								["x"] = 2,
								["y"] = 18,
								["size"] = 10,
							},
							["buffs"] = {
								["enabled"] = true,
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
								["perRow"] = 5,
								["x"] = -2,
								["anchorPoint"] = "TR",
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
							["background"] = true,
							["invert"] = false,
							["height"] = 0.2,
						},
						["groupsPerRow"] = 8,
						["healthBar"] = {
							["colorType"] = "static",
							["height"] = 2,
							["reactionType"] = "none",
							["background"] = true,
							["invert"] = false,
							["order"] = 10,
						},
						["hideSemiRaid"] = false,
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["maxColumns"] = 8,
						["sortOrder"] = "DESC",
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["enabled"] = false,
							["height"] = 0.4,
						},
						["height"] = 50,
						["attribPoint"] = "BOTTOM",
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
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
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
						["incAbsorb"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["highlight"] = {
							["debuff"] = true,
							["aggro"] = true,
							["alpha"] = 1,
							["height"] = 0.5,
							["attention"] = false,
							["mouseover"] = false,
							["size"] = 10,
						},
						["offset"] = 2,
						["unitsPerColumn"] = 25,
						["showParty"] = false,
						["width"] = 70,
						["auraIndicators"] = {
							["enabled"] = true,
							["height"] = 0.5,
						},
						["enabled"] = true,
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
						["text"] = {
							{
								["text"] = "[colorname]",
								["width"] = 1,
								["anchorPoint"] = "C",
								["x"] = 0,
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
								["text"] = "[afk:time]",
								["width"] = 0.5,
								["x"] = -16,
								["name"] = "AFK",
							}, -- [9]
						},
						["incHeal"] = {
							["height"] = 0.5,
							["cap"] = 1,
						},
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
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
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["width"] = 90,
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
								["anchorOn"] = false,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["perRow"] = 9,
								["y"] = 0,
								["show"] = {
									["player"] = false,
								},
								["size"] = 16,
							},
							["buffs"] = {
								["enabled"] = true,
								["anchorOn"] = false,
								["anchorPoint"] = "BL",
								["perRow"] = 15,
								["x"] = 0,
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
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["autoHide"] = true,
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = false,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
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
								["anchorPoint"] = "CRI",
								["x"] = -3,
								["name"] = "Percentage",
								["y"] = -8,
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
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
						["width"] = 200,
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
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["height"] = 60,
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
						["enabled"] = true,
					},
					["focustarget"] = {
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
								["maxRows"] = 1,
								["y"] = 3,
								["x"] = -1,
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
							["height"] = 1.4,
							["reactionType"] = "none",
							["background"] = true,
							["invert"] = true,
							["order"] = 10,
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
						["width"] = 110,
						["fader"] = {
							["height"] = 0.5,
						},
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
						["height"] = 30,
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
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
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
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["width"] = 90,
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
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
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["width"] = 90,
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
					["targettarget"] = {
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["enlarge"] = {
									["SELF"] = false,
								},
								["y"] = 3,
								["maxRows"] = 1,
								["anchorPoint"] = "BL",
								["x"] = -1,
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
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
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
							["background"] = true,
							["predicted"] = true,
							["height"] = 0.4,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["reactionType"] = "none",
							["height"] = 1.4,
							["background"] = true,
							["invert"] = false,
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
							["background"] = true,
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
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
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
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
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
							["order"] = 40,
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
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["width"] = 190,
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
					["partypet"] = {
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
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
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
					},
					["mainassist"] = {
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["incHeal"] = {
							["cap"] = 1,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 1,
						},
						["offset"] = 5,
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["unitsPerColumn"] = 5,
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
						["attribAnchorPoint"] = "LEFT",
						["width"] = 150,
						["maxColumns"] = 1,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["columnSpacing"] = 5,
						["height"] = 40,
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
								["anchorPoint"] = "TL",
								["show"] = {
									["misc"] = false,
									["consolidated"] = false,
									["raid"] = false,
								},
								["maxRows"] = 2,
								["y"] = 26,
								["x"] = 9,
								["size"] = 28,
							},
						},
						["castBar"] = {
							["name"] = {
								["y"] = 0,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 2,
							},
							["time"] = {
								["y"] = 0,
								["x"] = -2,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
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
							["background"] = true,
							["invert"] = false,
							["height"] = 1.3,
						},
						["healthBar"] = {
							["colorAggro"] = false,
							["order"] = 15,
							["colorType"] = "static",
							["height"] = 1.3,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "npc",
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
						["staggerBar"] = {
							["vertical"] = false,
							["reverse"] = false,
							["height"] = 0.5,
							["background"] = false,
							["invert"] = false,
							["order"] = 100,
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
						["xpBar"] = {
							["height"] = 0.5,
							["background"] = true,
							["order"] = 60,
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
						["totemBar"] = {
							["height"] = 0.5,
							["background"] = true,
							["order"] = 25,
							["showAlways"] = true,
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
						["priestBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 70,
						},
						["disableVehicle"] = false,
						["shamanBar"] = {
							["height"] = 0.3,
							["background"] = true,
							["order"] = 70,
						},
						["height"] = 60,
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
						["runeBar"] = {
							["enabled"] = true,
							["vertical"] = false,
							["reverse"] = false,
							["order"] = 100,
							["background"] = false,
							["invert"] = false,
							["height"] = 0.5,
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
						["incAbsorb"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["width"] = 274,
						["fader"] = {
							["inactiveAlpha"] = 1,
							["height"] = 0.5,
							["combatAlpha"] = 1,
						},
						["combatText"] = {
							["y"] = -9,
							["height"] = 0.5,
							["enabled"] = false,
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
						["text"] = {
							{
								["text"] = "[hp:color][perhp]",
								["width"] = 10,
								["x"] = 4,
							}, -- [1]
							{
								["text"] = "[hp:color][curhp]",
								["width"] = 10,
								["anchorPoint"] = "TRI",
								["x"] = -2,
								["y"] = 14,
							}, -- [2]
							{
								["text"] = "[perpp]",
								["width"] = 10,
								["x"] = 4,
							}, -- [3]
							{
								["text"] = "",
								["width"] = 7,
								["anchorPoint"] = "TR",
								["x"] = 2,
								["y"] = -20,
							}, -- [4]
							{
								["y"] = 3,
								["x"] = -1,
							}, -- [5]
							nil, -- [6]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 10,
								["anchorPoint"] = "TL",
								["x"] = 10,
								["name"] = "NameText",
								["y"] = 37,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["width"] = 10,
								["anchorPoint"] = "TRI",
								["x"] = -2,
								["name"] = "Percentage",
								["y"] = 25,
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
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
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
							["size"] = 10,
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
							["order"] = 40,
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
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["width"] = 150,
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
					["pet"] = {
						["xpBar"] = {
							["height"] = 0.25,
							["background"] = true,
							["order"] = 55,
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
							["background"] = true,
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
							["enabled"] = false,
							["height"] = 0.5,
						},
						["width"] = 100,
						["fader"] = {
							["inactiveAlpha"] = 0.4,
							["combatAlpha"] = 0.4,
							["height"] = 0.5,
						},
						["incHeal"] = {
							["enabled"] = false,
							["height"] = 0.5,
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
						["height"] = 18,
						["healAbsorb"] = {
							["enabled"] = false,
							["height"] = 0.5,
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["maxColumns"] = 8,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["height"] = 30,
						["highlight"] = {
							["size"] = 10,
						},
						["scale"] = 0.85,
						["unitsPerColumn"] = 8,
						["columnSpacing"] = 5,
						["attribAnchorPoint"] = "LEFT",
						["width"] = 90,
						["groupsPerRow"] = 8,
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
					},
					["maintank"] = {
						["unitsPerColumn"] = 5,
						["height"] = 40,
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
						["attribAnchorPoint"] = "LEFT",
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
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
						["incHeal"] = {
							["cap"] = 1,
						},
					},
					["boss"] = {
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["range"] = {
							["enabled"] = true,
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["y"] = 0,
								["perRow"] = 8,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["buffs"] = {
								["enabled"] = true,
								["anchorOn"] = false,
								["anchorPoint"] = "BL",
								["perRow"] = 15,
								["x"] = 0,
								["y"] = -2,
								["size"] = 22,
							},
						},
						["castBar"] = {
							["enabled"] = true,
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = -1,
							},
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
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
							["background"] = true,
							["invert"] = false,
							["colorType"] = "type",
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
						["text"] = {
							{
								["text"] = "[abbrev:name]",
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
								["text"] = "[faction]",
								["width"] = 0.5,
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["width"] = 1,
								["anchorPoint"] = "CRI",
								["x"] = -3,
								["name"] = "Percentage",
								["y"] = -8,
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
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
						["width"] = 200,
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
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
							["fullBefore"] = 0,
							["fullAfter"] = 100,
							["order"] = 15,
							["isBar"] = false,
							["width"] = 0.2,
							["alignment"] = "LEFT",
							["height"] = 0.5,
							["type"] = "3D",
						},
						["enabled"] = true,
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
								["anchorPoint"] = "BL",
								["perRow"] = 9,
								["x"] = 0,
								["y"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["enabled"] = true,
								["anchorPoint"] = "BL",
								["perRow"] = 15,
								["x"] = 0,
								["y"] = -2,
								["size"] = 22,
							},
						},
						["castBar"] = {
							["enabled"] = true,
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
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
							["background"] = true,
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
								["anchorPoint"] = "CRI",
								["x"] = -3,
								["name"] = "Percentage",
								["default"] = true,
								["y"] = -8,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "[faction]",
								["width"] = 0.5,
								["anchorPoint"] = "CLI",
								["x"] = 3,
								["name"] = "AFK",
								["y"] = -8,
								["size"] = -1,
							}, -- [8]
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 12,
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
						["width"] = 200,
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
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
							["type"] = "class",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["enabled"] = true,
					},
				},
				["wowBuild"] = 80100,
				["font"] = {
					["shadowColor"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0,
						["r"] = 0,
					},
					["name"] = "MUI_Font",
					["shadowX"] = 0.8,
					["color"] = {
						["a"] = 1,
						["r"] = 0.96078431372549,
						["g"] = 1,
						["b"] = 0.92156862745098,
					},
					["shadowY"] = -0.8,
					["extra"] = "",
					["size"] = 10,
				},
				["auras"] = {
					["borderType"] = "dark",
				},
				["omnicc"] = true,
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