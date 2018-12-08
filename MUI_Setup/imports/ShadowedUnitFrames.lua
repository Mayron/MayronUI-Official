local _, setup = ...;

setup.import["ShadowedUnitFrames"] = function()
	local settings = {
		["namespaces"] = {
			["LibDualSpec-1.0"] = {
			},
		},
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
					["ECLIPSE_SUN"] = {
						["b"] = 0,
						["g"] = 1,
						["r"] = 1,
					},
					["LUNAR_POWER"] = {
						["b"] = 0.9,
						["g"] = 0.52,
						["r"] = 0.3,
					},
					["AMMOSLOT"] = {
						["r"] = 0.85,
						["g"] = 0.6,
						["b"] = 0.55,
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
					["BURNINGEMBERS"] = {
						["r"] = 0.58,
						["g"] = 0.51,
						["b"] = 0.79,
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
						["top"] = 112.426510968867,
						["x"] = 6,
						["point"] = "BOTTOMLEFT",
						["relativePoint"] = "BOTTOMLEFT",
						["y"] = 2,
						["bottom"] = 2.20427658332312,
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
						["anchorTo"] = "$parent",
					},
					["raid"] = {
						["y"] = 228.188266276513,
						["x"] = 343.944728629569,
						["point"] = "BOTTOMLEFT",
						["bottom"] = 228.188266276513,
						["top"] = 401.788278102074,
						["relativePoint"] = "BOTTOMLEFT",
					},
					["partytargettarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["arena"] = {
						["top"] = 459.23547118955,
						["x"] = 1012.05367033959,
						["point"] = "BOTTOMLEFT",
						["bottom"] = 160.568797290853,
						["y"] = 160.568797290853,
						["relativePoint"] = "BOTTOMLEFT",
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
						["x"] = 0,
						["point"] = "TOP",
						["relativePoint"] = "TOP",
						["anchorTo"] = "UIParent",
						["y"] = -40,
					},
					["boss"] = {
						["y"] = 80,
						["x"] = 10,
						["point"] = "BOTTOMLEFT",
						["anchorTo"] = "#SUFUnittarget",
						["top"] = 436.904320533227,
						["relativePoint"] = "TOPRIGHT",
						["bottom"] = 142.904332549526,
					},
					["maintank"] = {
						["anchorPoint"] = "C",
					},
					["raidpet"] = {
						["anchorPoint"] = "C",
					},
					["battleground"] = {
						["anchorPoint"] = "C",
					},
				},
				["revision"] = 59,
				["wowBuild"] = 70200,
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
				["backdrop"] = {
					["inset"] = 0,
					["edgeSize"] = 1,
					["tileSize"] = 20,
					["borderColor"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
					["clip"] = 1,
					["backgroundTexture"] = "Solid",
					["backgroundColor"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
					["borderTexture"] = "Pixel",
				},
				["units"] = {
					["arenatarget"] = {
						["enabled"] = true,
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
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
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
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
						["width"] = 124,
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
						["height"] = 42,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 0.3,
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
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
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
						["width"] = 150,
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
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "RIGHT",
							["fullAfter"] = 100,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
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
						["auras"] = {
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
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
						["width"] = 80,
						["height"] = 30,
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
						["auras"] = {
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
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
					["arenatargettarget"] = {
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
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
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
						["highlight"] = {
							["size"] = 10,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["width"] = 90,
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
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
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
						["auras"] = {
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
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
						["width"] = 90,
						["height"] = 25,
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 0.6,
						},
						["highlight"] = {
							["size"] = 10,
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
								["anchorPoint"] = "BL",
								["y"] = 0,
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
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["width"] = 90,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
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
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
						["highlight"] = {
							["size"] = 10,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["width"] = 150,
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
						["scale"] = 1.05,
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
								["anchorPoint"] = "BL",
								["perRow"] = 4,
								["x"] = 202,
								["y"] = 27,
								["size"] = 20,
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
							["order"] = 60,
						},
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 28,
							},
							["lfdRole"] = {
								["y"] = 4,
								["x"] = 16,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LT",
								["size"] = 14,
							},
							["resurrect"] = {
								["y"] = -1,
								["x"] = -34,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RC",
								["size"] = 31,
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
								["anchorPoint"] = "LT",
								["x"] = 31,
								["anchorTo"] = "$parent",
								["y"] = 5,
								["size"] = 14,
							},
							["role"] = {
								["y"] = -11,
								["x"] = 30,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 14,
							},
							["ready"] = {
								["anchorPoint"] = "C",
								["x"] = 35,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 28,
							},
							["status"] = {
								["anchorPoint"] = "LB",
								["x"] = 12,
								["anchorTo"] = "$parent",
								["y"] = -2,
								["size"] = 16,
							},
							["height"] = 0.5,
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
							["phase"] = {
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RC",
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
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["predicted"] = true,
							["order"] = 20,
							["height"] = 0.7,
							["background"] = false,
							["invert"] = false,
							["colorType"] = "type",
						},
						["height"] = 35,
						["incAbsorb"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["hideAnyRaid"] = true,
						["attribAnchorPoint"] = "LEFT",
						["offset"] = 5,
						["disableVehicle"] = false,
						["healthBar"] = {
							["colorType"] = "static",
							["height"] = 2.6,
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
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["width"] = 200,
						["incHeal"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
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
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["fader"] = {
							["height"] = 0.5,
							["inactiveAlpha"] = 1,
						},
						["combatText"] = {
							["height"] = 0.5,
						},
						["columnSpacing"] = -30,
						["healAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["highlight"] = {
							["aggro"] = true,
							["height"] = 0.5,
							["alpha"] = 1,
							["size"] = 10,
						},
						["attribPoint"] = "BOTTOM",
					},
					["maintanktarget"] = {
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
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
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
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
						["width"] = 150,
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
								["anchorPoint"] = "RT",
								["x"] = 30,
								["maxRows"] = 2,
								["perRow"] = 3,
								["y"] = -30,
								["show"] = {
									["player"] = false,
								},
								["size"] = 24,
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
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 60,
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
							["height"] = 0.6,
							["background"] = true,
							["invert"] = false,
							["order"] = 25,
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
								["anchorTo"] = "$parent",
								["y"] = 0,
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
							["height"] = 0.5,
							["inactiveAlpha"] = 1,
						},
						["height"] = 18,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = false,
							["height"] = 0.4,
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
								["enabled"] = true,
								["anchorOn"] = false,
								["enlarge"] = {
									["REMOVABLE"] = false,
								},
								["y"] = -32,
								["maxRows"] = 3,
								["perRow"] = 3,
								["anchorPoint"] = "RT",
								["x"] = 27,
								["size"] = 28,
							},
							["debuffs"] = {
								["perRow"] = 7,
								["anchorOn"] = false,
								["enlarge"] = {
									["SELF"] = false,
								},
								["y"] = 31,
								["x"] = -9,
								["anchorPoint"] = "TR",
								["maxRows"] = 2,
								["show"] = {
									["misc"] = false,
									["raid"] = false,
								},
								["size"] = 28,
							},
						},
						["castBar"] = {
							["name"] = {
								["y"] = 0,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["size"] = 2,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = false,
							},
							["time"] = {
								["enabled"] = true,
								["x"] = -2,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["autoHide"] = false,
							["height"] = 3.2,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 5,
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
							["height"] = 0.6,
							["background"] = false,
							["invert"] = false,
							["order"] = 25,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["colorAggro"] = false,
							["height"] = 2,
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
							["cap"] = 1,
							["height"] = 0.5,
						},
						["healAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
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
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
						},
						["frameSplit"] = true,
						["groupSpacing"] = -34,
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["invert"] = true,
							["height"] = 0.3,
						},
						["groupsPerRow"] = 5,
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
								["text"] = "[colorname]",
								["width"] = 0,
								["x"] = 0,
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
						["maxColumns"] = 8,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["enabled"] = false,
							["height"] = 0.4,
						},
						["height"] = 48,
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
								["y"] = 14,
								["x"] = 3,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BR",
								["enabled"] = false,
								["size"] = 14,
							},
							["resurrect"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 28,
							},
							["masterLoot"] = {
								["anchorPoint"] = "TR",
								["x"] = -2,
								["anchorTo"] = "$parent",
								["y"] = -10,
								["enabled"] = false,
								["size"] = 12,
							},
							["leader"] = {
								["y"] = -12,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 14,
							},
							["role"] = {
								["anchorPoint"] = "TL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = -14,
								["size"] = 14,
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
						["scale"] = 0.85,
						["range"] = {
							["enabled"] = true,
							["oorAlpha"] = 0.5,
							["height"] = 0.5,
						},
						["incAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["columnSpacing"] = -8,
						["offset"] = 2,
						["attribAnchorPoint"] = "LEFT",
						["auraIndicators"] = {
							["enabled"] = true,
							["height"] = 0.5,
						},
						["width"] = 65,
						["unitsPerColumn"] = 25,
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
								["anchorPoint"] = "RB",
								["maxRows"] = 3,
								["perRow"] = 1,
								["x"] = -2,
								["y"] = 0,
								["size"] = 18,
							},
						},
						["fader"] = {
							["height"] = 0.5,
						},
						["combatText"] = {
							["height"] = 0.5,
						},
						["incHeal"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["healAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["highlight"] = {
							["debuff"] = true,
							["aggro"] = true,
							["mouseover"] = false,
							["height"] = 0.5,
							["attention"] = true,
							["alpha"] = 1,
							["size"] = 10,
						},
					},
					["maintanktargettarget"] = {
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
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
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
						["highlight"] = {
							["size"] = 10,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["width"] = 150,
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
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["enabled"] = true,
								["anchorOn"] = false,
								["anchorPoint"] = "BL",
								["perRow"] = 12,
								["x"] = 0,
								["y"] = -2,
								["size"] = 22,
							},
							["debuffs"] = {
								["perRow"] = 9,
								["anchorOn"] = false,
								["show"] = {
									["player"] = false,
								},
								["x"] = 0,
								["y"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["enabled"] = true,
							["order"] = 60,
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = false,
							},
							["icon"] = "HIDE",
							["vertical"] = false,
							["time"] = {
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["autoHide"] = false,
							["height"] = 0.6,
							["background"] = true,
							["invert"] = false,
							["reverse"] = false,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.3,
							["background"] = false,
							["order"] = 20,
						},
						["offset"] = 30,
						["healthBar"] = {
							["colorAggro"] = false,
							["order"] = 10,
							["colorType"] = "class",
							["height"] = 1.2,
							["reverse"] = false,
							["reactionType"] = "npc",
							["background"] = true,
							["invert"] = false,
							["vertical"] = false,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["width"] = 170,
						["text"] = {
							nil, -- [1]
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
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["combatText"] = {
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
								["y"] = 10,
								["x"] = -2,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LC",
								["size"] = 40,
							},
						},
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
						["attribPoint"] = "BOTTOM",
					},
					["partytargettarget"] = {
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
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
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
						["highlight"] = {
							["size"] = 10,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["width"] = 90,
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
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
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
						["highlight"] = {
							["size"] = 10,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["width"] = 90,
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["height"] = 1,
							["reactionType"] = "none",
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
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
								["enabled"] = true,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
						["highlight"] = {
							["size"] = 10,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["width"] = 90,
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
					["battlegroundpet"] = {
						["highlight"] = {
							["size"] = 10,
						},
						["auras"] = {
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
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
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["width"] = 90,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
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
								["anchorPoint"] = "BL",
								["y"] = 0,
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
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.3,
							["background"] = true,
							["order"] = 20,
						},
						["offset"] = 20,
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
						["width"] = 124,
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
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["height"] = 42,
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
					["focustarget"] = {
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
						["range"] = {
							["height"] = 0.5,
						},
						["auras"] = {
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
								["maxRows"] = 1,
								["y"] = 3,
								["x"] = -1,
								["size"] = 15,
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
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
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
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
					},
					["pet"] = {
						["xpBar"] = {
							["height"] = 0.25,
							["background"] = true,
							["order"] = 55,
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
								["anchorPoint"] = "BL",
								["y"] = 0,
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
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 60,
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
							["height"] = 0.8,
							["background"] = true,
							["order"] = 0,
							["reactionType"] = "none",
						},
						["width"] = 100,
						["fader"] = {
							["height"] = 0.5,
							["inactiveAlpha"] = 0.4,
							["combatAlpha"] = 0.4,
						},
						["height"] = 18,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
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
								["anchorPoint"] = "BL",
								["y"] = 0,
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
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["width"] = 90,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["height"] = 25,
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
					["pettarget"] = {
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
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
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
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
						["width"] = 190,
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
							["name"] = {
								["y"] = 0,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["size"] = 2,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
							["time"] = {
								["enabled"] = true,
								["x"] = -2,
								["anchorTo"] = "$parent",
								["y"] = 0,
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
							["background"] = false,
							["invert"] = false,
							["height"] = 0.8,
						},
						["healthBar"] = {
							["colorAggro"] = false,
							["order"] = 15,
							["colorType"] = "static",
							["height"] = 1.8,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "npc",
						},
						["druidBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 25,
							["enabled"] = true,
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
						["priestBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 70,
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
							["height"] = 0.5,
							["background"] = true,
							["order"] = 60,
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
						["auraIndicators"] = {
							["height"] = 0.5,
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
							["height"] = 0.3,
							["background"] = true,
							["order"] = 70,
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
								["show"] = {
									["misc"] = false,
									["raid"] = false,
									["consolidated"] = false,
								},
								["y"] = 26,
								["x"] = 9,
								["anchorPoint"] = "TL",
								["maxRows"] = 2,
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
								["y"] = -32,
								["x"] = -27,
								["size"] = 28,
							},
						},
						["width"] = 274,
						["staggerBar"] = {
							["vertical"] = false,
							["reverse"] = false,
							["height"] = 0.5,
							["background"] = false,
							["invert"] = false,
							["order"] = 100,
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
						["fader"] = {
							["combatAlpha"] = 1,
							["height"] = 0.5,
							["inactiveAlpha"] = 1,
						},
						["combatText"] = {
							["y"] = -2,
							["height"] = 0.5,
							["enabled"] = false,
						},
						["incHeal"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["healAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
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
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["enabled"] = false,
							["order"] = 100,
						},
					},
					["mainassist"] = {
						["attribAnchorPoint"] = "LEFT",
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["incHeal"] = {
							["cap"] = 1,
						},
						["auras"] = {
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
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
							["order"] = 60,
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
						["unitsPerColumn"] = 5,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["width"] = 150,
						["maxColumns"] = 1,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["columnSpacing"] = 5,
						["height"] = 40,
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
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["order"] = 40,
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
								["enlarge"] = {
									["SELF"] = false,
								},
								["y"] = 3,
								["maxRows"] = 1,
								["anchorPoint"] = "BL",
								["x"] = -1,
								["size"] = 15,
							},
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
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["buffs"] = {
								["enabled"] = true,
								["anchorOn"] = false,
								["anchorPoint"] = "BL",
								["perRow"] = 12,
								["x"] = 0,
								["y"] = -2,
								["size"] = 22,
							},
							["debuffs"] = {
								["y"] = 0,
								["perRow"] = 8,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
						},
						["castBar"] = {
							["enabled"] = true,
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = -1,
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
								["size"] = -1,
							},
							["autoHide"] = false,
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
							["colorType"] = "type",
							["height"] = 0.2,
							["background"] = true,
							["invert"] = false,
							["order"] = 20,
						},
						["offset"] = 30,
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["height"] = 1.1,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "npc",
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["width"] = 170,
						["text"] = {
							nil, -- [1]
							{
								["text"] = "",
								["width"] = 4.4,
								["y"] = 12,
								["x"] = -2,
								["anchorPoint"] = "BR",
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
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["attribPoint"] = "BOTTOM",
					},
					["maintank"] = {
						["unitsPerColumn"] = 5,
						["incHeal"] = {
							["cap"] = 1,
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
						["auras"] = {
							["buffs"] = {
								["anchorPoint"] = "BL",
								["y"] = 0,
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
							["order"] = 60,
						},
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 1,
						},
						["offset"] = 5,
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
						["attribAnchorPoint"] = "LEFT",
						["width"] = 150,
						["maxColumns"] = 1,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["height"] = 40,
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
								["anchorPoint"] = "BL",
								["y"] = 0,
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 1,
						},
						["maxColumns"] = 8,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
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
						["highlight"] = {
							["size"] = 10,
						},
					},
					["battleground"] = {
						["portrait"] = {
							["type"] = "class",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["auras"] = {
							["buffs"] = {
								["perRow"] = 9,
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["anchorPoint"] = "BL",
								["perRow"] = 9,
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
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 0.5,
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
							nil, -- [2]
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
							["pvp"] = {
								["y"] = -8,
								["x"] = 16,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LC",
								["size"] = 40,
							},
						},
						["width"] = 140,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["height"] = 35,
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
				},
				["hidden"] = {
					["playerAltPower"] = true,
					["buffs"] = true,
				},
				["font"] = {
					["color"] = {
						["a"] = 1,
						["b"] = 0.92156862745098,
						["g"] = 1,
						["r"] = 0.96078431372549,
					},
					["name"] = "MUI_Font",
					["shadowX"] = 0.8,
					["shadowColor"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
					["shadowY"] = -0.8,
					["extra"] = "",
					["size"] = 10,
				},
				["auras"] = {
					["borderType"] = "dark",
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
				["wowBuild"] = 70000,
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
					["pet"] = {
						["y"] = 10,
						["point"] = "BOTTOM",
						["anchorTo"] = "#SUFUnittargettarget",
						["relativePoint"] = "TOP",
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
						["y"] = 2,
						["x"] = 6,
						["point"] = "BOTTOMLEFT",
						["bottom"] = 2.20427658332312,
						["top"] = 112.426510968867,
						["relativePoint"] = "BOTTOMLEFT",
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
						["y"] = 228.188266276513,
						["x"] = 343.944728629569,
						["point"] = "BOTTOMLEFT",
						["bottom"] = 228.188266276513,
						["top"] = 401.788278102074,
						["relativePoint"] = "BOTTOMLEFT",
					},
					["battlegroundtarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["boss"] = {
						["y"] = 80,
						["x"] = 10,
						["point"] = "BOTTOMLEFT",
						["bottom"] = 142.904332549526,
						["top"] = 436.904320533227,
						["anchorTo"] = "#SUFUnittarget",
						["relativePoint"] = "TOPRIGHT",
					},
					["maintank"] = {
						["anchorPoint"] = "C",
					},
					["battlegroundtargettarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["bosstargettarget"] = {
						["anchorPoint"] = "RB",
						["anchorTo"] = "$parent",
					},
					["raidpet"] = {
						["anchorPoint"] = "C",
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
					["pettarget"] = {
						["anchorPoint"] = "C",
					},
					["maintanktarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["player"] = {
						["y"] = -28.2,
						["x"] = -21.5,
						["point"] = "BOTTOMRIGHT",
						["relativePoint"] = "TOPLEFT",
						["anchorTo"] = "#SUFUnittargettarget",
					},
					["mainassist"] = {
						["anchorPoint"] = "C",
					},
					["targettarget"] = {
						["y"] = -40,
						["point"] = "TOP",
						["anchorTo"] = "MUI_UnitPanelCenter",
						["relativePoint"] = "TOP",
					},
					["focustarget"] = {
						["point"] = "BOTTOM",
						["relativePoint"] = "BOTTOM",
						["y"] = 44.3799992442131,
					},
					["arena"] = {
						["y"] = 160.568797290853,
						["x"] = 1012.05367033959,
						["point"] = "BOTTOMLEFT",
						["bottom"] = 160.568797290853,
						["top"] = 459.23547118955,
						["relativePoint"] = "BOTTOMLEFT",
					},
					["partytargettarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["battleground"] = {
						["anchorPoint"] = "C",
					},
				},
				["revision"] = 59,
				["auras"] = {
					["borderType"] = "dark",
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
					["buffs"] = true,
				},
				["units"] = {
					["arenatarget"] = {
						["enabled"] = true,
						["width"] = 124,
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 100,
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
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
						["text"] = {
							nil, -- [1]
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
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
							["height"] = 0.5,
						},
						["height"] = 42,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.3,
							["background"] = true,
							["order"] = 20,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
					},
					["mainassisttarget"] = {
						["width"] = 150,
						["highlight"] = {
							["size"] = 10,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
							["height"] = 1,
							["order"] = 0,
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
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
					["targettargettarget"] = {
						["enabled"] = false,
						["width"] = 80,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
							["height"] = 1,
							["order"] = 0,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["height"] = 30,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
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
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
						},
						["highlight"] = {
							["size"] = 10,
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
						},
					},
					["arenatargettarget"] = {
						["width"] = 90,
						["highlight"] = {
							["size"] = 10,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
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
						["height"] = 25,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
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
								["enlarge"] = {
									["SELF"] = false,
								},
								["y"] = 0,
								["maxRows"] = 3,
								["perRow"] = 1,
								["x"] = -2,
								["anchorPoint"] = "RB",
								["size"] = 18,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
						["frameSplit"] = true,
						["groupSpacing"] = -34,
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["invert"] = true,
							["height"] = 0.3,
						},
						["offset"] = 2,
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
								["width"] = 0,
								["x"] = 0,
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
						["maxColumns"] = 8,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
							["enabled"] = false,
						},
						["height"] = 48,
						["attribPoint"] = "BOTTOM",
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 22,
							},
							["lfdRole"] = {
								["y"] = 14,
								["x"] = 3,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BR",
								["enabled"] = false,
								["size"] = 14,
							},
							["resurrect"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 28,
							},
							["masterLoot"] = {
								["anchorPoint"] = "TR",
								["x"] = -2,
								["anchorTo"] = "$parent",
								["y"] = -10,
								["enabled"] = false,
								["size"] = 12,
							},
							["leader"] = {
								["y"] = -12,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 14,
							},
							["role"] = {
								["y"] = -14,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["size"] = 14,
							},
							["pvp"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 11,
								["enabled"] = false,
								["size"] = 22,
							},
							["height"] = 0.5,
							["status"] = {
								["y"] = -2,
								["x"] = 12,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LB",
								["size"] = 16,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
							["ready"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 22,
							},
						},
						["scale"] = 0.85,
						["range"] = {
							["enabled"] = true,
							["oorAlpha"] = 0.5,
							["height"] = 0.5,
						},
						["auraIndicators"] = {
							["enabled"] = true,
							["height"] = 0.5,
						},
						["highlight"] = {
							["debuff"] = true,
							["aggro"] = true,
							["alpha"] = 1,
							["height"] = 0.5,
							["attention"] = true,
							["mouseover"] = false,
							["size"] = 10,
						},
						["incHeal"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["unitsPerColumn"] = 25,
						["incAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["width"] = 65,
						["showParty"] = false,
						["groupsPerRow"] = 5,
						["fader"] = {
							["height"] = 0.5,
						},
						["combatText"] = {
							["height"] = 0.5,
						},
						["columnSpacing"] = -8,
						["healAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
						},
						["attribAnchorPoint"] = "LEFT",
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
							["order"] = 40,
							["height"] = 0.6,
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
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
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
					["mainassisttargettarget"] = {
						["width"] = 150,
						["highlight"] = {
							["size"] = 10,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
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
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
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
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 28,
							},
							["lfdRole"] = {
								["anchorPoint"] = "LT",
								["x"] = 16,
								["anchorTo"] = "$parent",
								["y"] = 4,
								["size"] = 14,
							},
							["phase"] = {
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RC",
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
								["y"] = 5,
								["x"] = 31,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LT",
								["size"] = 14,
							},
							["role"] = {
								["y"] = -11,
								["x"] = 30,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 14,
							},
							["pvp"] = {
								["y"] = -21,
								["x"] = 11,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TR",
								["enabled"] = false,
								["size"] = 22,
							},
							["height"] = 0.5,
							["status"] = {
								["y"] = -2,
								["x"] = 12,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LB",
								["size"] = 16,
							},
							["class"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "BL",
							},
							["resurrect"] = {
								["anchorPoint"] = "RC",
								["x"] = -34,
								["anchorTo"] = "$parent",
								["y"] = -1,
								["size"] = 31,
							},
							["ready"] = {
								["y"] = 0,
								["x"] = 35,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 28,
							},
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
						["scale"] = 1.05,
						["showPlayer"] = false,
						["range"] = {
							["enabled"] = true,
							["oorAlpha"] = 0.5,
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["perRow"] = 4,
								["enlarge"] = {
									["SELF"] = false,
								},
								["y"] = 27,
								["enabled"] = true,
								["x"] = 202,
								["anchorPoint"] = "BL",
								["size"] = 20,
							},
							["buffs"] = {
								["perRow"] = 3,
								["y"] = -31,
								["anchorPoint"] = "TL",
								["x"] = 198,
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
							["order"] = 60,
							["height"] = 0.6,
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
						["highlight"] = {
							["height"] = 0.5,
							["aggro"] = true,
							["alpha"] = 1,
							["size"] = 10,
						},
						["powerBar"] = {
							["predicted"] = true,
							["colorType"] = "type",
							["order"] = 20,
							["background"] = false,
							["invert"] = false,
							["height"] = 0.7,
						},
						["columnSpacing"] = -30,
						["offset"] = 5,
						["incAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["hideAnyRaid"] = true,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
							["enabled"] = false,
						},
						["enabled"] = false,
						["disableVehicle"] = false,
						["healthBar"] = {
							["colorType"] = "static",
							["reactionType"] = "none",
							["height"] = 2.6,
							["background"] = true,
							["invert"] = false,
							["order"] = 10,
						},
						["hideSemiRaid"] = false,
						["attribAnchorPoint"] = "LEFT",
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
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
								["default"] = true,
								["name"] = "NameText",
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
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [9]
						},
						["width"] = 200,
						["height"] = 35,
						["unitsPerColumn"] = 5,
						["fader"] = {
							["inactiveAlpha"] = 1,
							["height"] = 0.5,
						},
						["combatText"] = {
							["height"] = 0.5,
						},
						["incHeal"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["healAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["attribPoint"] = "BOTTOM",
					},
					["maintanktargettarget"] = {
						["width"] = 150,
						["highlight"] = {
							["size"] = 10,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
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
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
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
								["anchorPoint"] = "RT",
								["x"] = 5,
								["anchorTo"] = "$parent",
								["y"] = -32,
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
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["perRow"] = 3,
								["show"] = {
									["player"] = false,
								},
								["maxRows"] = 2,
								["x"] = 30,
								["y"] = -30,
								["anchorPoint"] = "RT",
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
							["order"] = 60,
							["height"] = 0.6,
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
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["enabled"] = false,
							["colorType"] = "type",
							["order"] = 25,
							["height"] = 0.6,
							["background"] = true,
							["invert"] = false,
							["predicted"] = true,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 0,
							["reactionType"] = "none",
							["background"] = true,
							["invert"] = false,
							["height"] = 1.9,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
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
						["width"] = 100,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = false,
							["order"] = 100,
						},
						["height"] = 18,
						["fader"] = {
							["height"] = 0.5,
							["inactiveAlpha"] = 1,
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
							["height"] = 0.5,
							["enabled"] = false,
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
						["incAbsorb"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
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
								["anchorPoint"] = "RT",
								["x"] = 27,
								["enabled"] = true,
								["y"] = -32,
								["maxRows"] = 3,
								["show"] = {
									["raid"] = false,
									["misc"] = false,
								},
								["size"] = 28,
							},
							["buffs"] = {
								["perRow"] = 3,
								["anchorOn"] = false,
								["enlarge"] = {
									["REMOVABLE"] = false,
								},
								["y"] = -32,
								["maxRows"] = 3,
								["x"] = 27,
								["anchorPoint"] = "RT",
								["size"] = 28,
							},
						},
						["castBar"] = {
							["order"] = 5,
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
							["time"] = {
								["y"] = 0,
								["x"] = -2,
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
							["order"] = 25,
							["reverse"] = false,
							["height"] = 0.6,
							["background"] = false,
							["invert"] = false,
							["predicted"] = true,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["colorAggro"] = false,
							["reactionType"] = "none",
							["height"] = 2,
							["background"] = true,
							["invert"] = false,
							["order"] = 0,
						},
						["highlight"] = {
							["height"] = 0.5,
							["aggro"] = false,
							["mouseover"] = false,
							["size"] = 5,
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
								["y"] = 14,
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
						["height"] = 60,
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
							["cap"] = 1,
							["height"] = 0.5,
						},
						["healAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["incAbsorb"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["comboPoints"] = {
							["height"] = 0.5,
							["order"] = 99,
						},
					},
					["battlegroundtarget"] = {
						["width"] = 90,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
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
							["height"] = 1,
							["order"] = 0,
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["height"] = 25,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
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
					["boss"] = {
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
								["perRow"] = 8,
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["perRow"] = 12,
								["anchorOn"] = false,
								["y"] = -2,
								["enabled"] = true,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 22,
							},
						},
						["castBar"] = {
							["enabled"] = true,
							["order"] = 40,
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = -1,
							},
							["autoHide"] = false,
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = -1,
							},
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["height"] = 0.2,
							["background"] = true,
							["invert"] = false,
							["predicted"] = true,
						},
						["offset"] = 30,
						["healthBar"] = {
							["colorType"] = "class",
							["reactionType"] = "npc",
							["order"] = 10,
							["background"] = true,
							["invert"] = false,
							["height"] = 1.1,
						},
						["text"] = {
							nil, -- [1]
							{
								["text"] = "",
								["width"] = 4.4,
								["y"] = 12,
								["x"] = -2,
								["anchorPoint"] = "BR",
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
						["width"] = 170,
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
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
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 12,
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
						["attribPoint"] = "BOTTOM",
					},
					["maintank"] = {
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
						["incHeal"] = {
							["cap"] = 1,
						},
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
							},
							["resurrect"] = {
								["anchorPoint"] = "LC",
								["x"] = 37,
								["anchorTo"] = "$parent",
								["y"] = -1,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 60,
							["height"] = 0.6,
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
						["highlight"] = {
							["size"] = 10,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
						},
						["offset"] = 5,
						["height"] = 40,
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
						},
						["attribAnchorPoint"] = "LEFT",
						["width"] = 150,
						["maxColumns"] = 1,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["columnSpacing"] = 5,
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
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
						["incHeal"] = {
							["cap"] = 1,
						},
						["attribAnchorPoint"] = "LEFT",
						["width"] = 90,
						["groupsPerRow"] = 8,
						["columnSpacing"] = 5,
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
					["battlegroundtargettarget"] = {
						["width"] = 90,
						["highlight"] = {
							["size"] = 10,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
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
						["height"] = 25,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
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
						["width"] = 90,
						["highlight"] = {
							["size"] = 10,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
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
						["height"] = 25,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
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
					["pettarget"] = {
						["width"] = 190,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
							["height"] = 1,
							["order"] = 0,
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["height"] = 30,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.7,
							["background"] = true,
							["order"] = 20,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 0.3,
						},
						["offset"] = 20,
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
						["width"] = 124,
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
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["attribAnchorPoint"] = "RIGHT",
						["height"] = 42,
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
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
						},
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
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
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
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
								["y"] = 0,
								["anchorPoint"] = "BL",
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
							["order"] = 60,
							["height"] = 0.6,
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
							["order"] = 10,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "none",
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
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
							["order"] = 0,
							["background"] = true,
							["reactionType"] = "none",
							["height"] = 0.8,
						},
						["width"] = 100,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["height"] = 18,
						["fader"] = {
							["inactiveAlpha"] = 0.4,
							["height"] = 0.5,
							["combatAlpha"] = 0.4,
						},
						["combatText"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["incHeal"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["healAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["incAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
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
					},
					["partypet"] = {
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
								["size"] = 20,
							},
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
						},
						["highlight"] = {
							["size"] = 10,
						},
					},
					["maintanktarget"] = {
						["width"] = 150,
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
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 40,
							["height"] = 0.6,
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
							["height"] = 1,
							["order"] = 0,
						},
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
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
							["order"] = 5,
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
							["time"] = {
								["y"] = 0,
								["x"] = -2,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
						},
						["powerBar"] = {
							["colorType"] = "type",
							["reverse"] = false,
							["order"] = 15,
							["background"] = true,
							["invert"] = false,
							["height"] = 1.8,
						},
						["healthBar"] = {
							["colorAggro"] = false,
							["order"] = 25,
							["colorType"] = "static",
							["height"] = 0.8,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "npc",
						},
						["druidBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 25,
							["enabled"] = true,
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
							["order"] = 100,
							["enabled"] = false,
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
								["anchorPoint"] = "LT",
								["x"] = -3,
								["anchorTo"] = "$parent",
								["y"] = -32,
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
							["pvp"] = {
								["y"] = -25,
								["x"] = 50,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 22,
							},
							["height"] = 0.5,
							["ready"] = {
								["anchorPoint"] = "C",
								["x"] = 80,
								["anchorTo"] = "$parent",
								["y"] = -15,
								["size"] = 30,
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
						["highlight"] = {
							["debuff"] = false,
							["height"] = 0.5,
							["mouseover"] = false,
							["aggro"] = false,
							["attention"] = false,
							["alpha"] = 1,
							["size"] = 5,
						},
						["healAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["disableVehicle"] = false,
						["height"] = 60,
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["perRow"] = 3,
								["anchorOn"] = false,
								["enlarge"] = {
									["SELF"] = false,
								},
								["y"] = -32,
								["maxRows"] = 3,
								["enabled"] = true,
								["anchorPoint"] = "LT",
								["show"] = {
									["raid"] = false,
									["misc"] = false,
								},
								["x"] = -27,
								["size"] = 28,
							},
							["buffs"] = {
								["perRow"] = 7,
								["temporary"] = false,
								["anchorOn"] = false,
								["anchorPoint"] = "TL",
								["y"] = 26,
								["maxRows"] = 2,
								["show"] = {
									["misc"] = false,
									["raid"] = false,
									["consolidated"] = false,
								},
								["x"] = 9,
								["size"] = 28,
							},
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
						["priestBar"] = {
							["order"] = 70,
							["background"] = true,
							["height"] = 0.4,
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
						["width"] = 274,
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["fader"] = {
							["inactiveAlpha"] = 1,
							["height"] = 0.5,
							["combatAlpha"] = 1,
						},
						["combatText"] = {
							["y"] = -2,
							["height"] = 0.5,
							["enabled"] = false,
						},
						["incHeal"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["shamanBar"] = {
							["vertical"] = false,
							["reverse"] = false,
							["order"] = 100,
							["background"] = true,
							["invert"] = false,
							["height"] = 0.3,
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
								["text"] = "[perpp]",
								["width"] = 10,
								["y"] = 16,
								["x"] = 4,
								["anchorPoint"] = "TLI",
								["size"] = 3,
							}, -- [1]
							{
								["text"] = "",
								["width"] = 10,
								["anchorPoint"] = "TRI",
								["x"] = -2,
							}, -- [2]
							{
								["text"] = "|cff19a0ff[( )curpp]",
								["width"] = 10,
								["y"] = 25,
								["x"] = -2,
								["anchorPoint"] = "TRI",
							}, -- [3]
							{
								["text"] = "[hp:color][curhp]",
								["width"] = 10,
								["y"] = 14,
								["x"] = -2,
								["anchorPoint"] = "TRI",
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
					["mainassist"] = {
						["attribAnchorPoint"] = "LEFT",
						["highlight"] = {
							["size"] = 10,
						},
						["height"] = 40,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["order"] = 60,
							["height"] = 0.6,
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
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
							},
							["resurrect"] = {
								["anchorPoint"] = "LC",
								["x"] = 37,
								["anchorTo"] = "$parent",
								["y"] = -1,
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
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 1,
						},
						["offset"] = 5,
						["incHeal"] = {
							["cap"] = 1,
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
						},
						["width"] = 150,
						["maxColumns"] = 1,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["columnSpacing"] = 5,
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
					},
					["targettarget"] = {
						["width"] = 110,
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
						["healthBar"] = {
							["colorType"] = "static",
							["order"] = 10,
							["reactionType"] = "none",
							["background"] = true,
							["invert"] = false,
							["height"] = 1.4,
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
								["y"] = 0,
								["anchorPoint"] = "BL",
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
							["order"] = 40,
							["height"] = 0.6,
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
						["highlight"] = {
							["height"] = 0.5,
							["mouseover"] = false,
							["size"] = 10,
						},
					},
					["focustarget"] = {
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["range"] = {
							["height"] = 0.5,
						},
						["auras"] = {
							["buffs"] = {
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
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
							["order"] = 40,
							["height"] = 0.6,
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
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
						},
						["width"] = 110,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
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
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
							["height"] = 0.5,
						},
						["height"] = 30,
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
						["fader"] = {
							["height"] = 0.5,
						},
					},
					["arena"] = {
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
								["anchorOn"] = false,
								["show"] = {
									["player"] = false,
								},
								["x"] = 0,
								["perRow"] = 9,
								["anchorPoint"] = "BL",
								["y"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["perRow"] = 12,
								["anchorOn"] = false,
								["y"] = -2,
								["enabled"] = true,
								["x"] = 0,
								["anchorPoint"] = "BL",
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
							["autoHide"] = false,
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
							["height"] = 0.3,
						},
						["offset"] = 30,
						["healthBar"] = {
							["colorAggro"] = false,
							["order"] = 10,
							["colorType"] = "class",
							["vertical"] = false,
							["reverse"] = false,
							["height"] = 1.2,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "npc",
						},
						["text"] = {
							nil, -- [1]
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
						["width"] = 170,
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
						},
						["indicators"] = {
							["arenaSpec"] = {
								["anchorPoint"] = "LC",
								["x"] = -2,
								["anchorTo"] = "$parent",
								["y"] = 10,
								["size"] = 40,
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
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 12,
								["size"] = 25,
							},
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["combatText"] = {
							["height"] = 0.5,
						},
						["height"] = 60,
						["enabled"] = true,
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
						["attribPoint"] = "BOTTOM",
					},
					["partytargettarget"] = {
						["width"] = 90,
						["highlight"] = {
							["size"] = 10,
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
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
						["height"] = 25,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
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
					["battleground"] = {
						["highlight"] = {
							["size"] = 10,
						},
						["auras"] = {
							["buffs"] = {
								["perRow"] = 9,
								["anchorPoint"] = "BL",
								["y"] = 0,
								["x"] = 0,
								["size"] = 16,
							},
							["debuffs"] = {
								["perRow"] = 9,
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
							["height"] = 0.6,
							["order"] = 60,
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
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.5,
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
							nil, -- [2]
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
						["portrait"] = {
							["type"] = "class",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["width"] = 140,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["height"] = 35,
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
								["size"] = 16,
							},
							["pvp"] = {
								["anchorPoint"] = "LC",
								["x"] = 16,
								["anchorTo"] = "$parent",
								["y"] = -8,
								["size"] = 40,
							},
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 1,
							["order"] = 0,
						},
					},
				},
				["powerColors"] = {
					["PAIN"] = {
						["r"] = 1,
						["g"] = 0,
						["b"] = 0,
					},
					["ECLIPSE_FULL"] = {
						["b"] = 0.43,
						["g"] = 0.32,
						["r"] = 0,
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
					["FUEL"] = {
						["b"] = 0.36,
						["g"] = 0.47,
						["r"] = 0.85,
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
					["SHADOWORBS"] = {
						["b"] = 0.79,
						["g"] = 0.51,
						["r"] = 0.58,
					},
					["BURNINGEMBERS"] = {
						["b"] = 0.79,
						["g"] = 0.51,
						["r"] = 0.58,
					},
					["ECLIPSE_MOON"] = {
						["r"] = 0.3,
						["g"] = 0.52,
						["b"] = 0.9,
					},
					["ECLIPSE_SUN"] = {
						["r"] = 1,
						["g"] = 1,
						["b"] = 0,
					},
					["AMMOSLOT"] = {
						["b"] = 0.55,
						["g"] = 0.6,
						["r"] = 0.85,
					},
					["LUNAR_POWER"] = {
						["r"] = 0.3,
						["g"] = 0.52,
						["b"] = 0.9,
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
					["STAGGER_GREEN"] = {
						["b"] = 0.52,
						["g"] = 1,
						["r"] = 0.52,
					},
					["HOLYPOWER"] = {
						["r"] = 0.96,
						["g"] = 0.55,
						["b"] = 0.73,
					},
					["MUSHROOMS"] = {
						["b"] = 0.2,
						["g"] = 0.9,
						["r"] = 0.2,
					},
					["FURY"] = {
						["r"] = 0.788,
						["g"] = 0.259,
						["b"] = 0.992,
					},
				},
				["font"] = {
					["shadowColor"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0,
						["r"] = 0,
					},
					["name"] = "MUI_Font",
					["extra"] = "",
					["shadowX"] = 0.8,
					["shadowY"] = -0.8,
					["color"] = {
						["a"] = 1,
						["r"] = 0.96078431372549,
						["g"] = 1,
						["b"] = 0.92156862745098,
					},
					["size"] = 10,
				},
				["backdrop"] = {
					["borderTexture"] = "Pixel",
					["edgeSize"] = 1,
					["tileSize"] = 20,
					["borderColor"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0,
						["r"] = 0,
					},
					["backgroundColor"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0,
						["r"] = 0,
					},
					["backgroundTexture"] = "Solid",
					["inset"] = 0,
					["clip"] = 1,
				},
				["omnicc"] = true,
				["classColors"] = {
					["HUNTER"] = {
						["a"] = 1,
						["b"] = 0.45,
						["g"] = 0.83,
						["r"] = 0.67,
					},
					["WARRIOR"] = {
						["a"] = 1,
						["b"] = 0.43,
						["g"] = 0.61,
						["r"] = 0.78,
					},
					["PALADIN"] = {
						["a"] = 1,
						["b"] = 0.73,
						["g"] = 0.55,
						["r"] = 0.96,
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
					["DEATHKNIGHT"] = {
						["a"] = 1,
						["b"] = 0.23,
						["g"] = 0.12,
						["r"] = 0.77,
					},
					["ROGUE"] = {
						["a"] = 1,
						["b"] = 0.41,
						["g"] = 0.96,
						["r"] = 1,
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
					["SHAMAN"] = {
						["a"] = 1,
						["b"] = 0.87,
						["g"] = 0.44,
						["r"] = 0,
					},
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