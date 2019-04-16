local _, setup = ...;

setup.import["ShadowedUnitFrames"] = function()
	local settings = {
		["global"] = {
			["infoID"] = 3,
		},
		["profiles"] = {
			["Default"] = {
				["wowBuild"] = 80100,
				["auras"] = {
					["borderType"] = "dark",
				},
				["healthColors"] = {
					["neutral"] = {
						["a"] = 1,
						["b"] = 0.2,
						["g"] = 0.843137254901961,
						["r"] = 1,
					},
					["enemyUnattack"] = {
						["b"] = 0.2,
						["g"] = 0.2,
						["r"] = 0.6,
					},
					["aggro"] = {
						["a"] = 1,
						["r"] = 0.749019607843137,
						["g"] = 0,
						["b"] = 0,
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
						["anchorPoint"] = "LT",
						["x"] = -2,
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
						["top"] = 288.19333615655,
						["x"] = 110,
						["point"] = "BOTTOMLEFT",
						["bottom"] = 159.393338350001,
						["anchorTo"] = "#SUFUnittarget",
						["relativePoint"] = "TOPRIGHT",
						["y"] = 54,
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
						["anchorTo"] = "#SUFUnittargettarget",
						["relativePoint"] = "TOPRIGHT",
					},
					["raid"] = {
						["y"] = 54,
						["x"] = 50,
						["point"] = "BOTTOMLEFT",
						["anchorTo"] = "#SUFUnittarget",
						["relativePoint"] = "TOPRIGHT",
						["bottom"] = 325.082211871109,
						["top"] = 355.882189984284,
					},
					["battlegroundtarget"] = {
						["anchorPoint"] = "LT",
						["x"] = -2,
						["anchorTo"] = "$parent",
					},
					["partytargettarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["arena"] = {
						["y"] = 54,
						["x"] = -46,
						["point"] = "BOTTOMRIGHT",
						["relativePoint"] = "TOPLEFT",
						["anchorTo"] = "#SUFUnitplayer",
						["bottom"] = 247.666438653359,
						["top"] = 541.666561820395,
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
						["anchorPoint"] = "LT",
						["x"] = -2,
						["anchorTo"] = "$parent",
					},
					["battlegroundpet"] = {
						["anchorPoint"] = "RB",
						["anchorTo"] = "$parent",
					},
					["targettarget"] = {
						["y"] = -100,
						["x"] = 100,
						["point"] = "TOP",
						["anchorTo"] = "UIParent",
						["relativePoint"] = "TOP",
					},
					["mainassist"] = {
						["anchorPoint"] = "C",
					},
					["player"] = {
						["y"] = -28.2,
						["x"] = -21.5,
						["point"] = "BOTTOMRIGHT",
						["anchorTo"] = "#SUFUnittargettarget",
						["relativePoint"] = "TOPLEFT",
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
						["y"] = 54,
						["x"] = -34,
						["point"] = "BOTTOMRIGHT",
						["relativePoint"] = "TOPLEFT",
						["anchorTo"] = "#SUFUnitplayer",
						["bottom"] = 122.511234485912,
						["top"] = 416.511229479122,
					},
					["battleground"] = {
						["y"] = 54,
						["x"] = -35,
						["point"] = "BOTTOMRIGHT",
						["relativePoint"] = "TOPLEFT",
						["anchorTo"] = "#SUFUnitplayer",
						["bottom"] = 520.911246011747,
						["top"] = 751.911327527057,
					},
				},
				["revision"] = 59,
				["advanced"] = true,
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
								["perRow"] = 7,
								["y"] = -2,
								["x"] = -1,
								["enabled"] = true,
								["maxRows"] = 1,
								["anchorPoint"] = "BR",
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
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
						["width"] = 163,
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
								["default"] = true,
								["name"] = "NameText",
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
						["attribAnchorPoint"] = "RIGHT",
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
						["attribPoint"] = "TOP",
					},
					["mainassisttarget"] = {
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
						["highlight"] = {
							["size"] = 10,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
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
								["default"] = true,
								["name"] = "NameText",
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
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
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
					},
					["targettargettarget"] = {
						["enabled"] = false,
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
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
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
								["default"] = true,
								["name"] = "NameText",
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
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
						["width"] = 90,
						["fader"] = {
							["height"] = 0.5,
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
						["height"] = 25,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["highlight"] = {
							["height"] = 0.5,
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
								["default"] = true,
								["name"] = "NameText",
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
							["height"] = 1.2,
							["reactionType"] = "npc",
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
						["height"] = 25,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
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
					},
					["battlegroundtarget"] = {
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
								["perRow"] = 7,
								["anchorPoint"] = "BR",
								["x"] = -1,
								["enabled"] = true,
								["maxRows"] = 1,
								["y"] = -2,
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
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
						["width"] = 163,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["enabled"] = true,
						["height"] = 41,
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
								["default"] = true,
								["name"] = "Percentage",
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [8]
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
					},
					["arenapet"] = {
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
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
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
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
								["default"] = true,
								["name"] = "NameText",
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
					["mainassisttargettarget"] = {
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
							["height"] = 1.2,
							["reactionType"] = "npc",
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
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
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
								["y"] = -1,
								["x"] = 14,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LT",
								["size"] = 12,
							},
							["phase"] = {
								["anchorPoint"] = "LT",
								["x"] = 44,
								["anchorTo"] = "$parent",
								["size"] = 13,
							},
							["masterLoot"] = {
								["y"] = -8,
								["x"] = 30,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["enabled"] = false,
								["size"] = 12,
							},
							["leader"] = {
								["anchorPoint"] = "LT",
								["x"] = 30,
								["anchorTo"] = "$parent",
								["y"] = 2,
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
								["y"] = 6,
								["x"] = 72,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LT",
								["enabled"] = false,
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
								["show"] = {
									["misc"] = false,
								},
								["maxRows"] = 5,
								["anchorPoint"] = "LB",
								["y"] = 1,
								["x"] = -2,
								["perRow"] = 2,
								["size"] = 18,
							},
							["buffs"] = {
								["perRow"] = 2,
								["anchorPoint"] = "RB",
								["x"] = 2,
								["maxRows"] = 5,
								["enabled"] = true,
								["show"] = {
									["misc"] = false,
									["relevant"] = false,
									["raid"] = false,
								},
								["y"] = 1,
								["size"] = 18,
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
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["hideAnyRaid"] = true,
						["incHeal"] = {
							["height"] = 0.5,
							["cap"] = 1,
						},
						["incAbsorb"] = {
							["height"] = 0.5,
							["enabled"] = false,
						},
						["powerBar"] = {
							["predicted"] = true,
							["colorType"] = "type",
							["height"] = 0.2,
							["order"] = 20,
							["background"] = false,
							["invert"] = false,
							["onlyMana"] = false,
						},
						["unitsPerColumn"] = 5,
						["offset"] = 1,
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
						["height"] = 40,
						["width"] = 212,
						["text"] = {
							{
								["text"] = "[classcolor][name][close( )][levelcolor][close][( )afk][( )status]",
								["width"] = 1,
								["y"] = -4,
							}, -- [1]
							{
								["text"] = "[hp:color][perhp]",
								["width"] = 1,
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
								["width"] = 2,
								["y"] = 8,
								["x"] = -2,
								["name"] = "Percentage",
								["anchorPoint"] = "CRI",
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 1,
								["y"] = 12,
								["x"] = 4,
								["name"] = "AFK",
								["anchorPoint"] = "BL",
								["size"] = -1,
							}, -- [9]
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
							["aggro"] = true,
							["height"] = 0.5,
							["alpha"] = 1,
							["size"] = 10,
						},
						["attribPoint"] = "TOP",
					},
					["maintanktargettarget"] = {
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
							["height"] = 1.2,
							["reactionType"] = "npc",
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
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
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
							["height"] = 0.5,
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
								["y"] = -30,
								["x"] = 30,
								["maxRows"] = 2,
								["perRow"] = 3,
								["anchorPoint"] = "RT",
								["show"] = {
									["player"] = false,
								},
								["size"] = 24,
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
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["order"] = 60,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["enabled"] = false,
							["predicted"] = true,
							["order"] = 25,
							["height"] = 0.6,
							["background"] = false,
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
							["type"] = "3D",
							["fullAfter"] = 100,
							["order"] = 0,
							["isBar"] = true,
							["width"] = 0.16,
							["alignment"] = "RIGHT",
							["height"] = 2.3,
							["fullBefore"] = 0,
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
							["reactionType"] = "none",
							["height"] = 0.8,
							["background"] = true,
							["backgroundColor"] = {
								["b"] = 0.0980392156862745,
								["g"] = 0.0980392156862745,
								["r"] = 0.0980392156862745,
							},
							["order"] = 70,
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
							["height"] = 0.5,
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
									["raid"] = false,
									["misc"] = false,
								},
								["maxRows"] = 3,
								["y"] = -30,
								["x"] = 27,
								["anchorPoint"] = "RT",
								["size"] = 23,
							},
							["buffs"] = {
								["perRow"] = 3,
								["anchorOn"] = false,
								["enlarge"] = {
									["REMOVABLE"] = false,
								},
								["show"] = {
									["misc"] = false,
								},
								["maxRows"] = 3,
								["anchorPoint"] = "RT",
								["enabled"] = true,
								["y"] = -30,
								["x"] = 27,
								["size"] = 23,
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
								["rank"] = false,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 2,
							},
							["autoHide"] = false,
							["order"] = 5,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 3.2,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["predicted"] = true,
							["order"] = 25,
							["reverse"] = false,
							["height"] = 0.8,
							["background"] = false,
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
								["y"] = -5,
								["x"] = 4,
								["anchorPoint"] = "TLI",
								["size"] = 3,
							}, -- [1]
							{
								["text"] = "[hp:color][curhp]",
								["width"] = 10,
								["y"] = 25,
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
								["y"] = 14,
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
							["reactionType"] = "none",
							["class"] = false,
							["height"] = 1.3,
							["background"] = false,
							["backgroundColor"] = {
								["b"] = 0.0901960784313726,
								["g"] = 0.0901960784313726,
								["r"] = 0.0901960784313726,
							},
							["order"] = 0,
						},
						["highlight"] = {
							["aggro"] = false,
							["height"] = 0.5,
							["mouseover"] = false,
							["size"] = 5,
						},
					},
					["raid"] = {
						["portrait"] = {
							["type"] = "3D",
							["fullAfter"] = 100,
							["order"] = 15,
							["isBar"] = false,
							["width"] = 0.22,
							["alignment"] = "LEFT",
							["height"] = 0.5,
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
								["perRow"] = 1,
								["timers"] = {
									["SELF"] = false,
								},
								["anchorOn"] = false,
								["y"] = -11,
								["x"] = -2,
								["show"] = {
									["misc"] = false,
									["relevant"] = false,
									["raid"] = false,
								},
								["anchorPoint"] = "TR",
								["maxRows"] = 1,
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
								["default"] = true,
								["name"] = "NameText",
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
						["height"] = 44,
						["attribPoint"] = "RIGHT",
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 22,
							},
							["lfdRole"] = {
								["y"] = -9,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "TL",
								["size"] = 12,
							},
							["resurrect"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
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
								["anchorPoint"] = "TL",
								["x"] = 11,
								["anchorTo"] = "$parent",
								["y"] = -9,
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
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
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
								["y"] = -2,
								["x"] = 12,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LB",
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
							["height"] = 0.5,
							["enabled"] = false,
						},
						["unitsPerColumn"] = 25,
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
						["attribAnchorPoint"] = "BOTTOM",
						["auraIndicators"] = {
							["enabled"] = true,
							["height"] = 0.5,
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
						["highlight"] = {
							["debuff"] = true,
							["height"] = 0.5,
							["alpha"] = 1,
							["aggro"] = true,
							["attention"] = false,
							["mouseover"] = false,
							["size"] = 10,
						},
						["offset"] = 2,
					},
					["partytargettarget"] = {
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
							["height"] = 1.2,
							["reactionType"] = "npc",
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
						["height"] = 25,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
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
								["anchorPoint"] = "BL",
								["x"] = 0,
								["y"] = 0,
								["show"] = {
									["player"] = false,
								},
								["size"] = 16,
							},
							["buffs"] = {
								["enabled"] = true,
								["anchorOn"] = false,
								["enlarge"] = {
									["REMOVABLE"] = false,
								},
								["y"] = -2,
								["x"] = 0,
								["perRow"] = 9,
								["anchorPoint"] = "BR",
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
							["background"] = false,
							["height"] = 0.2,
						},
						["offset"] = 30,
						["healthBar"] = {
							["colorAggro"] = false,
							["order"] = 10,
							["colorType"] = "static",
							["vertical"] = false,
							["reverse"] = false,
							["height"] = 1.2,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "npc",
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
								["default"] = true,
								["name"] = "NameText",
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
						["width"] = 214,
						["enabled"] = true,
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
						["indicators"] = {
							["arenaSpec"] = {
								["y"] = 15,
								["x"] = 4,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RC",
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
								["enabled"] = true,
							},
							["raidTarget"] = {
								["y"] = 12,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 25,
							},
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
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
								["default"] = true,
								["name"] = "NameText",
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
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["fader"] = {
							["height"] = 0.5,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
					},
					["battlegroundtargettarget"] = {
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
							["height"] = 1.2,
							["reactionType"] = "npc",
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
						["height"] = 25,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
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
					},
					["bosstargettarget"] = {
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
							["height"] = 1.2,
							["reactionType"] = "npc",
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
						["height"] = 25,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = true,
							["order"] = 20,
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
					},
					["targettarget"] = {
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
								["y"] = 0,
								["anchorPoint"] = "BL",
								["x"] = 0,
								["size"] = 16,
							},
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
						["highlight"] = {
							["height"] = 0.5,
							["mouseover"] = false,
							["size"] = 10,
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["class"] = false,
							["order"] = 0,
							["background"] = true,
							["backgroundColor"] = {
								["b"] = 0.0627450980392157,
								["g"] = 0.0627450980392157,
								["r"] = 0.0627450980392157,
							},
							["height"] = 0.9,
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
								["default"] = true,
								["name"] = "NameText",
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
								["perRow"] = 7,
								["y"] = -2,
								["x"] = -1,
								["enabled"] = true,
								["maxRows"] = 1,
								["anchorPoint"] = "BR",
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
								["default"] = true,
								["name"] = "NameText",
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
						["width"] = 163,
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
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
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
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
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
								["default"] = true,
								["name"] = "Percentage",
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [8]
						},
						["highlight"] = {
							["size"] = 10,
						},
					},
					["pettarget"] = {
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
						["highlight"] = {
							["size"] = 10,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
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
								["default"] = true,
								["name"] = "NameText",
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
						["height"] = 30,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 0.7,
							["background"] = true,
							["order"] = 20,
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
								["default"] = true,
								["name"] = "NameText",
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
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
					},
					["mainassist"] = {
						["unitsPerColumn"] = 5,
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
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["order"] = 60,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
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
								["default"] = true,
								["name"] = "NameText",
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
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 1,
						},
						["offset"] = 5,
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
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["attribAnchorPoint"] = "LEFT",
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
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
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 2,
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
							["background"] = false,
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
							["enabled"] = true,
							["order"] = 25,
						},
						["text"] = {
							{
								["text"] = "[hp:color][perhp]",
								["width"] = 10,
								["x"] = 4,
								["size"] = 2,
							}, -- [1]
							{
								["text"] = "[hp:color][curhp]",
								["width"] = 10,
								["y"] = 25,
								["x"] = -2,
								["anchorPoint"] = "TRI",
							}, -- [2]
							{
								["text"] = "",
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
								["y"] = 14,
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
							["order"] = 25,
							["background"] = true,
							["height"] = 0.5,
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
							["aggro"] = false,
							["mouseover"] = false,
							["height"] = 0.5,
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
						["emptyBar"] = {
							["order"] = 0,
							["background"] = false,
							["height"] = 3.2,
							["class"] = false,
							["backgroundColor"] = {
								["b"] = 1,
								["g"] = 1,
								["r"] = 1,
							},
							["reactionType"] = "none",
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
								["anchorPoint"] = "TL",
								["show"] = {
									["misc"] = false,
									["raid"] = false,
									["consolidated"] = false,
								},
								["x"] = 9,
								["maxRows"] = 2,
								["y"] = 26,
								["size"] = 28,
							},
						},
						["width"] = 274,
						["height"] = 60,
						["incAbsorb"] = {
							["enabled"] = false,
							["cap"] = 1,
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
						["priestBar"] = {
							["order"] = 70,
							["background"] = false,
							["height"] = 0.4,
						},
					},
					["maintanktarget"] = {
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
						["highlight"] = {
							["size"] = 10,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
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
								["default"] = true,
								["name"] = "NameText",
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
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
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
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["order"] = 60,
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
								["default"] = true,
								["name"] = "NameText",
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
							["combatAlpha"] = 0.4,
							["height"] = 0.5,
							["inactiveAlpha"] = 0.4,
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
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 0.8,
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
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
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
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
							},
						},
						["scale"] = 0.85,
						["columnSpacing"] = 5,
						["groupsPerRow"] = 8,
						["unitsPerColumn"] = 8,
						["width"] = 90,
						["attribAnchorPoint"] = "LEFT",
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
								["default"] = true,
								["name"] = "NameText",
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
					["maintank"] = {
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
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "LEFT",
							["fullAfter"] = 50,
							["height"] = 0.5,
							["fullBefore"] = 0,
							["order"] = 15,
							["width"] = 0.22,
						},
						["unitsPerColumn"] = 5,
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
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["order"] = 60,
							["background"] = true,
							["icon"] = "HIDE",
							["height"] = 0.6,
						},
						["incHeal"] = {
							["cap"] = 1,
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
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
								["default"] = true,
								["name"] = "NameText",
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
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
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
						["height"] = 40,
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
								["enabled"] = true,
								["anchorOn"] = false,
								["y"] = -2,
								["perRow"] = 9,
								["x"] = 0,
								["anchorPoint"] = "BR",
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
							["autoHide"] = false,
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
							["order"] = 20,
							["height"] = 0.2,
							["background"] = false,
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
								["default"] = true,
								["name"] = "NameText",
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
						["width"] = 214,
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
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
						["attribPoint"] = "BOTTOM",
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
								["perRow"] = 9,
								["y"] = -2,
								["x"] = 0,
								["enabled"] = true,
								["show"] = {
									["misc"] = false,
								},
								["anchorPoint"] = "BR",
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
								["rank"] = true,
								["anchorPoint"] = "CLI",
								["enabled"] = true,
								["size"] = 0,
							},
							["autoHide"] = false,
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
							["height"] = 0.2,
							["background"] = false,
							["order"] = 20,
						},
						["offset"] = 30,
						["healthBar"] = {
							["order"] = 10,
							["reactionType"] = "none",
							["colorType"] = "static",
							["background"] = true,
							["reverse"] = false,
							["height"] = 1.2,
							["colorDispel"] = false,
							["invert"] = false,
							["vertical"] = false,
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
						["width"] = 214,
						["enabled"] = true,
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
						["height"] = 60,
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
								["enabled"] = true,
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
						["emptyBar"] = {
							["height"] = 1,
							["background"] = true,
							["reactionType"] = "none",
							["order"] = 0,
						},
						["attribPoint"] = "BOTTOM",
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
					["POWER_TYPE_FEL_ENERGY"] = {
						["r"] = 0.878,
						["g"] = 0.98,
						["b"] = 0,
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
					["STAGGER_GREEN"] = {
						["b"] = 0.52,
						["g"] = 1,
						["r"] = 0.52,
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
					["ECLIPSE_MOON"] = {
						["r"] = 0.3,
						["g"] = 0.52,
						["b"] = 0.9,
					},
					["SHADOWORBS"] = {
						["b"] = 0.79,
						["g"] = 0.51,
						["r"] = 0.58,
					},
					["LUNAR_POWER"] = {
						["r"] = 0.3,
						["g"] = 0.52,
						["b"] = 0.9,
					},
					["MUSHROOMS"] = {
						["b"] = 0.2,
						["g"] = 0.9,
						["r"] = 0.2,
					},
					["STATUE"] = {
						["b"] = 0.6,
						["g"] = 0.45,
						["r"] = 0.35,
					},
					["AMMOSLOT"] = {
						["b"] = 0.55,
						["g"] = 0.6,
						["r"] = 0.85,
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
				["font"] = {
					["shadowX"] = 0.8,
					["name"] = "MUI_Font",
					["color"] = {
						["a"] = 1,
						["r"] = 0.96078431372549,
						["g"] = 1,
						["b"] = 0.92156862745098,
					},
					["shadowColor"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0,
						["r"] = 0,
					},
					["shadowY"] = -0.8,
					["extra"] = "",
					["size"] = 10,
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
					["ROGUE"] = {
						["a"] = 1,
						["b"] = 0.41,
						["g"] = 0.96,
						["r"] = 1,
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
					["SHAMAN"] = {
						["a"] = 1,
						["b"] = 0.87,
						["g"] = 0.44,
						["r"] = 0,
					},
					["DEATHKNIGHT"] = {
						["a"] = 1,
						["b"] = 0.23,
						["g"] = 0.12,
						["r"] = 0.77,
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
			["MayronUIH"] = {
				["wowBuild"] = 80100,
				["auras"] = {
					["borderType"] = "dark",
				},
				["healthColors"] = {
					["neutral"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 0.843137254901961,
						["b"] = 0.2,
					},
					["static"] = {
						["a"] = 1,
						["r"] = 0.0901960784313726,
						["g"] = 0.0901960784313726,
						["b"] = 0.0901960784313726,
					},
					["aggro"] = {
						["a"] = 1,
						["b"] = 0,
						["g"] = 0,
						["r"] = 0.749019607843137,
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
						["y"] = 30,
						["x"] = -9,
						["bottom"] = 125.894446708569,
						["anchorPoint"] = "TR",
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
					["raid"] = {
						["y"] = 74,
						["x"] = -282,
						["point"] = "TOPLEFT",
						["bottom"] = 144.988277254985,
						["anchorPoint"] = "TR",
						["anchorTo"] = "#SUFUnittarget",
						["top"] = 325.588113962103,
					},
					["battlegroundtarget"] = {
						["anchorPoint"] = "RT",
						["x"] = 2,
						["anchorTo"] = "$parent",
					},
					["boss"] = {
						["y"] = 54,
						["x"] = -200,
						["point"] = "BOTTOMRIGHT",
						["relativePoint"] = "TOPLEFT",
						["bottom"] = 122.511234485912,
						["anchorTo"] = "#SUFUnitplayer",
						["top"] = 416.511229479122,
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
						["anchorTo"] = "#SUFUnittargettarget",
						["relativePoint"] = "TOPLEFT",
					},
					["mainassist"] = {
						["anchorPoint"] = "C",
					},
					["pet"] = {
						["y"] = 10,
						["point"] = "BOTTOM",
						["anchorTo"] = "#SUFUnittargettarget",
						["relativePoint"] = "TOP",
					},
					["focustarget"] = {
						["point"] = "BOTTOM",
						["relativePoint"] = "BOTTOM",
						["y"] = 44.3799992442131,
					},
					["arena"] = {
						["y"] = 54,
						["x"] = -200,
						["point"] = "BOTTOMRIGHT",
						["relativePoint"] = "TOPLEFT",
						["bottom"] = 247.666438653359,
						["anchorTo"] = "#SUFUnitplayer",
						["top"] = 541.666561820395,
					},
					["partytargettarget"] = {
						["anchorPoint"] = "RT",
						["anchorTo"] = "$parent",
					},
					["battleground"] = {
						["y"] = 54,
						["x"] = -200,
						["point"] = "BOTTOMRIGHT",
						["relativePoint"] = "TOPLEFT",
						["bottom"] = 520.911246011747,
						["anchorTo"] = "#SUFUnitplayer",
						["top"] = 751.911327527057,
					},
				},
				["revision"] = 59,
				["advanced"] = true,
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
								["enabled"] = true,
								["y"] = -2,
								["maxRows"] = 1,
								["perRow"] = 7,
								["x"] = -1,
								["anchorPoint"] = "BR",
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
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
						["enabled"] = true,
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
								["default"] = true,
								["name"] = "NameText",
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
						["width"] = 163,
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
						["attribPoint"] = "TOP",
					},
					["mainassisttarget"] = {
						["width"] = 150,
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
								["default"] = true,
								["name"] = "NameText",
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
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
						["highlight"] = {
							["size"] = 10,
						},
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 1,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
					},
					["targettargettarget"] = {
						["enabled"] = false,
						["width"] = 80,
						["portrait"] = {
							["type"] = "3D",
							["alignment"] = "RIGHT",
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
							["height"] = 1.2,
							["reactionType"] = "npc",
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
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
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["default"] = true,
								["name"] = "NameText",
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
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
								["default"] = true,
								["name"] = "NameText",
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
							["height"] = 0.5,
						},
						["height"] = 25,
						["fader"] = {
							["height"] = 0.5,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
					},
					["arenatargettarget"] = {
						["width"] = 90,
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
						["highlight"] = {
							["size"] = 10,
						},
						["height"] = 25,
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
							["reactionType"] = "npc",
							["height"] = 1.2,
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
									["player"] = false,
									["misc"] = false,
								},
								["maxRows"] = 1,
								["perRow"] = 5,
								["y"] = 18,
								["x"] = 2,
								["anchorPoint"] = "BL",
								["size"] = 10,
							},
							["buffs"] = {
								["perRow"] = 1,
								["timers"] = {
									["SELF"] = false,
								},
								["anchorOn"] = false,
								["anchorPoint"] = "TR",
								["x"] = -2,
								["show"] = {
									["misc"] = false,
									["relevant"] = false,
									["raid"] = false,
								},
								["y"] = -11,
								["maxRows"] = 1,
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
							["order"] = 40,
							["height"] = 0.6,
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
						["enabled"] = true,
						["healthBar"] = {
							["colorType"] = "static",
							["reactionType"] = "none",
							["order"] = 10,
							["background"] = true,
							["invert"] = false,
							["height"] = 2,
						},
						["hideSemiRaid"] = false,
						["text"] = {
							{
								["text"] = "[colorname]",
								["width"] = 1,
								["anchorPoint"] = "C",
								["x"] = 0,
								["y"] = 2,
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
								["default"] = true,
								["name"] = "NameText",
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
							["height"] = 0.4,
							["enabled"] = false,
						},
						["height"] = 44,
						["attribPoint"] = "RIGHT",
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 22,
							},
							["lfdRole"] = {
								["anchorPoint"] = "TL",
								["anchorTo"] = "$parent",
								["y"] = -9,
								["size"] = 12,
							},
							["resurrect"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
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
								["anchorPoint"] = "TL",
								["x"] = 11,
								["anchorTo"] = "$parent",
								["y"] = -9,
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
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
							["ready"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
						["auraIndicators"] = {
							["enabled"] = true,
							["height"] = 0.5,
						},
						["highlight"] = {
							["debuff"] = true,
							["height"] = 0.5,
							["mouseover"] = false,
							["aggro"] = true,
							["attention"] = false,
							["alpha"] = 1,
							["size"] = 10,
						},
						["unitsPerColumn"] = 25,
						["columnSpacing"] = 2,
						["width"] = 53,
						["groupsPerRow"] = 8,
						["showParty"] = false,
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
						["offset"] = 2,
						["attribAnchorPoint"] = "BOTTOM",
					},
					["arenapet"] = {
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
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
								["default"] = true,
								["name"] = "NameText",
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
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
							},
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
					},
					["mainassisttargettarget"] = {
						["width"] = 150,
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
						["highlight"] = {
							["size"] = 10,
						},
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 1,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
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
								["y"] = -1,
								["x"] = 14,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "LT",
								["size"] = 12,
							},
							["phase"] = {
								["anchorPoint"] = "LT",
								["x"] = 44,
								["anchorTo"] = "$parent",
								["size"] = 13,
							},
							["masterLoot"] = {
								["y"] = -8,
								["x"] = 30,
								["anchorTo"] = "$parent",
								["enabled"] = false,
								["anchorPoint"] = "TL",
								["size"] = 12,
							},
							["leader"] = {
								["anchorPoint"] = "LT",
								["x"] = 30,
								["anchorTo"] = "$parent",
								["y"] = 2,
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
							["pvp"] = {
								["y"] = 6,
								["x"] = 72,
								["anchorTo"] = "$parent",
								["enabled"] = false,
								["anchorPoint"] = "LT",
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
							["resurrect"] = {
								["y"] = 2,
								["x"] = -30,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RC",
								["size"] = 28,
							},
							["ready"] = {
								["anchorPoint"] = "RC",
								["x"] = -28,
								["anchorTo"] = "$parent",
								["y"] = 4,
								["size"] = 24,
							},
						},
						["showPlayer"] = true,
						["range"] = {
							["enabled"] = true,
							["oorAlpha"] = 0.5,
							["height"] = 0.5,
						},
						["auras"] = {
							["height"] = 0.5,
							["debuffs"] = {
								["enabled"] = true,
								["anchorOn"] = false,
								["enlarge"] = {
									["SELF"] = false,
									["REMOVABLE"] = false,
								},
								["anchorPoint"] = "LB",
								["maxRows"] = 5,
								["show"] = {
									["misc"] = false,
								},
								["perRow"] = 2,
								["x"] = -2,
								["y"] = 1,
								["size"] = 18,
							},
							["buffs"] = {
								["enabled"] = true,
								["anchorOn"] = false,
								["anchorPoint"] = "RB",
								["maxRows"] = 5,
								["x"] = 2,
								["perRow"] = 2,
								["show"] = {
									["misc"] = false,
									["relevant"] = false,
									["raid"] = false,
								},
								["y"] = 1,
								["size"] = 18,
							},
						},
						["castBar"] = {
							["order"] = 60,
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
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
						["columnSpacing"] = -30,
						["powerBar"] = {
							["colorType"] = "type",
							["predicted"] = true,
							["order"] = 20,
							["height"] = 0.2,
							["background"] = false,
							["invert"] = false,
							["onlyMana"] = false,
						},
						["height"] = 40,
						["incAbsorb"] = {
							["enabled"] = false,
							["height"] = 0.5,
						},
						["hideAnyRaid"] = true,
						["text"] = {
							{
								["text"] = "[classcolor][name][close( )][levelcolor][close][( )afk][( )status]",
								["width"] = 1,
								["y"] = -4,
							}, -- [1]
							{
								["text"] = "[hp:color][perhp]",
								["width"] = 1,
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
								["name"] = "NameText",
								["default"] = true,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 2,
								["anchorPoint"] = "CRI",
								["x"] = -2,
								["name"] = "Percentage",
								["y"] = 8,
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 1,
								["anchorPoint"] = "BL",
								["x"] = 4,
								["name"] = "AFK",
								["y"] = 12,
								["size"] = -1,
							}, -- [9]
						},
						["offset"] = 1,
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
							["height"] = 0.4,
							["enabled"] = false,
						},
						["unitsPerColumn"] = 5,
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
						["width"] = 212,
						["highlight"] = {
							["debuff"] = true,
							["aggro"] = true,
							["height"] = 0.5,
							["mouseover"] = false,
							["alpha"] = 1,
							["size"] = 10,
						},
						["attribAnchorPoint"] = "LEFT",
						["fader"] = {
							["inactiveAlpha"] = 1,
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
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["attribPoint"] = "TOP",
					},
					["maintanktargettarget"] = {
						["width"] = 150,
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
						["highlight"] = {
							["size"] = 10,
						},
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 1,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["reactionType"] = "npc",
							["height"] = 1.2,
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
							["status"] = {
								["anchorPoint"] = "RC",
								["x"] = -21,
								["anchorTo"] = "$parent",
								["y"] = 9,
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
								["anchorPoint"] = "RT",
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
							["order"] = 60,
							["height"] = 0.6,
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
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["enabled"] = false,
							["predicted"] = true,
							["colorType"] = "type",
							["height"] = 0.6,
							["background"] = false,
							["invert"] = false,
							["order"] = 25,
						},
						["healthBar"] = {
							["colorType"] = "static",
							["height"] = 1.9,
							["order"] = 0,
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
								["name"] = "NameText",
								["default"] = true,
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["order"] = 70,
							["background"] = true,
							["backgroundColor"] = {
								["r"] = 0.0980392156862745,
								["g"] = 0.0980392156862745,
								["b"] = 0.0980392156862745,
							},
							["height"] = 0.8,
						},
						["width"] = 100,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = false,
							["height"] = 0.4,
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
							["enabled"] = false,
							["height"] = 0.5,
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
								["y"] = -14,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
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
								["y"] = -15,
								["x"] = -80,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
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
								["y"] = 9,
								["x"] = -21,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "RC",
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
								["perRow"] = 3,
								["anchorOn"] = false,
								["enlarge"] = {
									["SELF"] = false,
								},
								["show"] = {
									["raid"] = false,
									["misc"] = false,
								},
								["maxRows"] = 3,
								["enabled"] = true,
								["anchorPoint"] = "RT",
								["x"] = 27,
								["y"] = -30,
								["size"] = 23,
							},
							["buffs"] = {
								["perRow"] = 3,
								["anchorOn"] = false,
								["enlarge"] = {
									["REMOVABLE"] = false,
								},
								["show"] = {
									["misc"] = false,
								},
								["x"] = 27,
								["y"] = -30,
								["anchorPoint"] = "RT",
								["maxRows"] = 3,
								["size"] = 23,
							},
						},
						["castBar"] = {
							["order"] = 5,
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
							["name"] = {
								["y"] = 0,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["size"] = 2,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = false,
							},
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["predicted"] = true,
							["colorType"] = "type",
							["reverse"] = false,
							["height"] = 0.8,
							["background"] = false,
							["invert"] = false,
							["order"] = 25,
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
								["y"] = 25,
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
								["name"] = "NameText",
								["default"] = true,
								["y"] = 37,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "|cff19a0ff[( )curpp]",
								["width"] = 10,
								["anchorPoint"] = "TRI",
								["x"] = -2,
								["name"] = "Percentage",
								["y"] = 14,
							}, -- [8]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "[afk:time][status:time]",
								["width"] = 10,
								["name"] = "AFK",
							}, -- [9]
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = false,
							["order"] = 0,
							["class"] = false,
							["backgroundColor"] = {
								["r"] = 0.0901960784313726,
								["g"] = 0.0901960784313726,
								["b"] = 0.0901960784313726,
							},
							["height"] = 1.3,
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
							["y"] = -9,
						},
						["incHeal"] = {
							["height"] = 0.5,
							["cap"] = 1,
						},
						["healAbsorb"] = {
							["height"] = 0.5,
						},
						["incAbsorb"] = {
							["enabled"] = false,
							["cap"] = 1,
							["height"] = 0.5,
						},
						["comboPoints"] = {
							["order"] = 99,
							["height"] = 0.5,
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
								["enabled"] = true,
								["anchorPoint"] = "BR",
								["maxRows"] = 1,
								["perRow"] = 7,
								["x"] = -1,
								["y"] = -2,
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
						["enabled"] = true,
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
								["default"] = true,
								["name"] = "Percentage",
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["width"] = 0.5,
								["name"] = "AFK",
							}, -- [8]
						},
						["width"] = 163,
						["altPowerBar"] = {
							["order"] = 100,
							["background"] = true,
							["height"] = 0.4,
						},
						["offset"] = 4,
						["height"] = 41,
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
								["size"] = 16,
							},
							["height"] = 0.5,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
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
								["anchorPoint"] = "BL",
								["perRow"] = 8,
								["x"] = 0,
								["y"] = 0,
								["size"] = 16,
							},
							["buffs"] = {
								["enabled"] = true,
								["anchorOn"] = false,
								["anchorPoint"] = "BR",
								["perRow"] = 9,
								["x"] = 0,
								["y"] = -2,
								["size"] = 22,
							},
						},
						["castBar"] = {
							["enabled"] = true,
							["order"] = 40,
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = -1,
							},
							["autoHide"] = false,
							["height"] = 0.6,
							["background"] = true,
							["icon"] = "HIDE",
							["name"] = {
								["y"] = 0,
								["x"] = 1,
								["anchorTo"] = "$parent",
								["size"] = -1,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["powerBar"] = {
							["predicted"] = true,
							["colorType"] = "type",
							["height"] = 0.2,
							["background"] = false,
							["invert"] = false,
							["order"] = 20,
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
								["width"] = 1,
								["name"] = "AFK",
							}, -- [9]
						},
						["width"] = 214,
						["indicators"] = {
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 12,
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
						["enabled"] = true,
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
						["attribPoint"] = "BOTTOM",
					},
					["maintank"] = {
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
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
						},
						["attribAnchorPoint"] = "LEFT",
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
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
						["columnSpacing"] = 5,
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
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
								["default"] = true,
								["name"] = "NameText",
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
						["width"] = 150,
						["maxColumns"] = 1,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["height"] = 40,
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
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
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
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
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
							},
						},
						["scale"] = 0.85,
						["attribAnchorPoint"] = "LEFT",
						["incHeal"] = {
							["cap"] = 1,
						},
						["unitsPerColumn"] = 8,
						["width"] = 90,
						["groupsPerRow"] = 8,
						["columnSpacing"] = 5,
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
								["default"] = true,
								["name"] = "NameText",
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
					["battlegroundtargettarget"] = {
						["width"] = 90,
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
						["highlight"] = {
							["size"] = 10,
						},
						["height"] = 25,
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
							["reactionType"] = "npc",
							["height"] = 1.2,
						},
					},
					["bosstargettarget"] = {
						["width"] = 90,
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
						["highlight"] = {
							["size"] = 10,
						},
						["height"] = 25,
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
							["reactionType"] = "npc",
							["height"] = 1.2,
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
							["height"] = 1.4,
							["order"] = 10,
							["background"] = true,
							["invert"] = false,
							["reactionType"] = "none",
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["height"] = 0.9,
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
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
								["default"] = true,
								["name"] = "NameText",
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
							["background"] = false,
							["height"] = 0.4,
							["predicted"] = true,
						},
						["highlight"] = {
							["height"] = 0.5,
							["mouseover"] = false,
							["size"] = 10,
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
								["enabled"] = true,
								["y"] = -2,
								["maxRows"] = 1,
								["perRow"] = 7,
								["x"] = -1,
								["anchorPoint"] = "BR",
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
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
								["default"] = true,
								["name"] = "NameText",
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
						["width"] = 163,
						["enabled"] = true,
						["attribAnchorPoint"] = "RIGHT",
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
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
								["default"] = true,
								["name"] = "Percentage",
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
								["y"] = 0,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
							},
						},
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
					},
					["pettarget"] = {
						["width"] = 190,
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
								["default"] = true,
								["name"] = "NameText",
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
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
						["highlight"] = {
							["size"] = 10,
						},
						["height"] = 30,
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 0.7,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
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
								["default"] = true,
								["name"] = "NameText",
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
					["maintanktarget"] = {
						["width"] = 150,
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
								["default"] = true,
								["name"] = "NameText",
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
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
						["highlight"] = {
							["size"] = 10,
						},
						["height"] = 40,
						["powerBar"] = {
							["colorType"] = "type",
							["order"] = 20,
							["background"] = true,
							["height"] = 1,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
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
								["anchorPoint"] = "LT",
								["y"] = -30,
								["x"] = -27,
								["size"] = 23,
							},
							["buffs"] = {
								["perRow"] = 7,
								["temporary"] = false,
								["anchorOn"] = false,
								["show"] = {
									["misc"] = false,
									["consolidated"] = false,
									["raid"] = false,
								},
								["anchorPoint"] = "TL",
								["x"] = 9,
								["y"] = 26,
								["maxRows"] = 2,
								["size"] = 28,
							},
						},
						["castBar"] = {
							["order"] = 5,
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
							["name"] = {
								["y"] = 0,
								["x"] = 2,
								["anchorTo"] = "$parent",
								["size"] = 2,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
						},
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1.3,
							["background"] = false,
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
							["height"] = 1.3,
						},
						["druidBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 25,
							["enabled"] = true,
						},
						["emptyBar"] = {
							["order"] = 0,
							["class"] = false,
							["reactionType"] = "none",
							["background"] = false,
							["backgroundColor"] = {
								["r"] = 1,
								["g"] = 1,
								["b"] = 1,
							},
							["height"] = 3.2,
						},
						["priestBar"] = {
							["height"] = 0.4,
							["background"] = false,
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
						["highlight"] = {
							["debuff"] = false,
							["aggro"] = false,
							["alpha"] = 1,
							["height"] = 0.5,
							["attention"] = false,
							["mouseover"] = false,
							["size"] = 5,
						},
						["totemBar"] = {
							["order"] = 25,
							["showAlways"] = true,
							["height"] = 0.5,
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
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
							["enabled"] = false,
						},
						["indicators"] = {
							["raidTarget"] = {
								["y"] = -14,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
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
								["y"] = -15,
								["x"] = -80,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
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
								["y"] = -15,
								["x"] = 80,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 30,
							},
						},
						["disableVehicle"] = false,
						["healAbsorb"] = {
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
						["width"] = 274,
						["staggerBar"] = {
							["vertical"] = false,
							["reverse"] = false,
							["height"] = 0.5,
							["background"] = false,
							["invert"] = false,
							["order"] = 100,
						},
						["auraIndicators"] = {
							["height"] = 0.5,
						},
						["fader"] = {
							["height"] = 0.5,
							["inactiveAlpha"] = 1,
							["combatAlpha"] = 1,
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
						["shamanBar"] = {
							["height"] = 0.3,
							["background"] = true,
							["order"] = 70,
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
								["y"] = 25,
							}, -- [2]
							{
								["text"] = "[perpp]",
								["width"] = 10,
								["anchorPoint"] = "TLI",
								["x"] = 4,
								["y"] = -1,
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
								["y"] = 14,
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
					},
					["mainassist"] = {
						["attribAnchorPoint"] = "LEFT",
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
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 0,
							},
						},
						["incHeal"] = {
							["cap"] = 1,
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
							["order"] = 60,
							["height"] = 0.6,
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
						["unitsPerColumn"] = 5,
						["columnSpacing"] = 5,
						["powerBar"] = {
							["colorType"] = "type",
							["height"] = 1,
							["background"] = true,
							["order"] = 20,
						},
						["offset"] = 5,
						["highlight"] = {
							["size"] = 10,
						},
						["healthBar"] = {
							["colorType"] = "class",
							["order"] = 10,
							["background"] = true,
							["height"] = 1.2,
							["reactionType"] = "npc",
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
								["default"] = true,
								["name"] = "NameText",
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
						["height"] = 40,
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
							},
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
							["reactionType"] = "none",
							["height"] = 1.4,
							["background"] = true,
							["invert"] = false,
							["order"] = 10,
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
								["default"] = true,
								["name"] = "NameText",
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
							["height"] = 0.8,
							["reactionType"] = "none",
						},
						["width"] = 100,
						["altPowerBar"] = {
							["height"] = 0.4,
							["background"] = true,
							["order"] = 100,
						},
						["height"] = 18,
						["fader"] = {
							["height"] = 0.5,
							["combatAlpha"] = 0.4,
							["inactiveAlpha"] = 0.4,
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
						["incAbsorb"] = {
							["enabled"] = false,
							["height"] = 0.5,
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
								["size"] = 0,
								["enabled"] = true,
								["anchorPoint"] = "CLI",
								["rank"] = true,
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
								["default"] = true,
								["name"] = "NameText",
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
						["height"] = 30,
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
						["fader"] = {
							["height"] = 0.5,
						},
						["highlight"] = {
							["height"] = 0.5,
							["size"] = 10,
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
								["anchorPoint"] = "BL",
								["show"] = {
									["player"] = false,
								},
								["size"] = 16,
							},
							["buffs"] = {
								["enabled"] = true,
								["anchorOn"] = false,
								["enlarge"] = {
									["REMOVABLE"] = false,
								},
								["y"] = -2,
								["x"] = 0,
								["perRow"] = 9,
								["anchorPoint"] = "BR",
								["size"] = 22,
							},
						},
						["castBar"] = {
							["enabled"] = true,
							["order"] = 60,
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
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
							["autoHide"] = false,
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
							["colorAggro"] = false,
							["order"] = 10,
							["vertical"] = false,
							["height"] = 1.2,
							["reverse"] = false,
							["reactionType"] = "npc",
							["background"] = true,
							["invert"] = false,
							["colorType"] = "static",
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
						["width"] = 214,
						["indicators"] = {
							["arenaSpec"] = {
								["anchorPoint"] = "LC",
								["x"] = -4,
								["anchorTo"] = "$parent",
								["y"] = 15,
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
								["enabled"] = true,
								["anchorPoint"] = "BL",
							},
							["raidTarget"] = {
								["anchorPoint"] = "C",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["y"] = 12,
								["size"] = 25,
							},
						},
						["enabled"] = true,
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
						["attribPoint"] = "BOTTOM",
					},
					["partytargettarget"] = {
						["width"] = 90,
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
						["highlight"] = {
							["size"] = 10,
						},
						["height"] = 25,
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
							["reactionType"] = "npc",
							["height"] = 1.2,
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
								["y"] = 0,
								["perRow"] = 9,
								["x"] = 0,
								["anchorPoint"] = "BL",
								["size"] = 16,
							},
							["buffs"] = {
								["enabled"] = true,
								["y"] = -2,
								["x"] = 0,
								["perRow"] = 9,
								["show"] = {
									["misc"] = false,
								},
								["anchorPoint"] = "BR",
								["size"] = 22,
							},
						},
						["castBar"] = {
							["enabled"] = true,
							["height"] = 0.6,
							["time"] = {
								["y"] = 0,
								["x"] = -1,
								["anchorTo"] = "$parent",
								["enabled"] = true,
								["anchorPoint"] = "CRI",
								["size"] = 0,
							},
							["autoHide"] = false,
							["order"] = 60,
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
							["order"] = 10,
							["colorType"] = "static",
							["vertical"] = false,
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
								["anchorPoint"] = "CRI",
								["x"] = -3,
								["default"] = true,
								["name"] = "Percentage",
								["y"] = -8,
							}, -- [7]
							{
								["anchorTo"] = "$healthBar",
								["text"] = "[faction]",
								["width"] = 1,
								["anchorPoint"] = "CLI",
								["x"] = 6,
								["name"] = "AFK",
								["y"] = -8,
								["size"] = -1,
							}, -- [8]
						},
						["width"] = 214,
						["indicators"] = {
							["raidTarget"] = {
								["y"] = 3,
								["x"] = 0,
								["anchorTo"] = "$parent",
								["anchorPoint"] = "C",
								["size"] = 20,
							},
							["class"] = {
								["anchorPoint"] = "BL",
								["x"] = 0,
								["anchorTo"] = "$parent",
								["enabled"] = true,
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
						["enabled"] = true,
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
						["emptyBar"] = {
							["reactionType"] = "none",
							["background"] = true,
							["order"] = 0,
							["height"] = 1,
						},
						["attribPoint"] = "BOTTOM",
					},
				},
				["powerColors"] = {
					["PAIN"] = {
						["b"] = 0,
						["g"] = 0,
						["r"] = 1,
					},
					["SHADOWORBS"] = {
						["r"] = 0.58,
						["g"] = 0.51,
						["b"] = 0.79,
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
					["MUSHROOMS"] = {
						["r"] = 0.2,
						["g"] = 0.9,
						["b"] = 0.2,
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
					["ECLIPSE_SUN"] = {
						["b"] = 0,
						["g"] = 1,
						["r"] = 1,
					},
					["ECLIPSE_MOON"] = {
						["b"] = 0.9,
						["g"] = 0.52,
						["r"] = 0.3,
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
					["POWER_TYPE_FEL_ENERGY"] = {
						["b"] = 0,
						["g"] = 0.98,
						["r"] = 0.878,
					},
					["STATUE"] = {
						["r"] = 0.35,
						["g"] = 0.45,
						["b"] = 0.6,
					},
					["STAGGER_GREEN"] = {
						["r"] = 0.52,
						["g"] = 1,
						["b"] = 0.52,
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
					["ECLIPSE_FULL"] = {
						["r"] = 0,
						["g"] = 0.32,
						["b"] = 0.43,
					},
				},
				["font"] = {
					["extra"] = "",
					["name"] = "MUI_Font",
					["shadowX"] = 0.8,
					["color"] = {
						["a"] = 1,
						["b"] = 0.92156862745098,
						["g"] = 1,
						["r"] = 0.96078431372549,
					},
					["shadowY"] = -0.8,
					["shadowColor"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
					["size"] = 10,
				},
				["omnicc"] = true,
				["classColors"] = {
					["DEATHKNIGHT"] = {
						["a"] = 1,
						["r"] = 0.77,
						["g"] = 0.12,
						["b"] = 0.23,
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
					["HUNTER"] = {
						["a"] = 1,
						["r"] = 0.67,
						["g"] = 0.83,
						["b"] = 0.45,
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
					["ROGUE"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 0.96,
						["b"] = 0.41,
					},
				},
				["hidden"] = {
					["playerAltPower"] = true,
				},
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
		},
	};

	for k, v in pairs(settings) do
		_G.ShadowedUFDB[k] = v;
	end
end