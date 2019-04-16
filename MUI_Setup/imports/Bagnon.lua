local _, setup = ...;

setup.import["Bagnon"] = function()
	_G.Bagnon_Sets = {
		["reagentColor"] = {
		},
		["gemColor"] = {
		},
		["enchantColor"] = {
		},
		["glowAlpha"] = 0.5,
		["engineerColor"] = {
		},
		["refrigeColor"] = {
		},
		["profiles"] = {
		},
		["mineColor"] = {
		},
		["inscribeColor"] = {
		},
		["global"] = {
			["inventory"] = {
				["rules"] = {
					"all", -- [1]
					"all/all", -- [2]
					"all/normal", -- [3]
					"all/trade", -- [4]
					"all/reagent", -- [5]
					"equip", -- [6]
					"equip/all", -- [7]
					"equip/armor", -- [8]
					"equip/weapon", -- [9]
					"equip/trinket", -- [10]
					"use", -- [11]
					"use/all", -- [12]
					"use/consume", -- [13]
					"use/enhance", -- [14]
					"trade", -- [15]
					"trade/all", -- [16]
					"trade/goods", -- [17]
					"trade/gem", -- [18]
					"trade/glyph", -- [19]
					"trade/recipe", -- [20]
					"quest", -- [21]
					"quest/all", -- [22]
					"contain/all", -- [23]
					"misc", -- [24]
					"misc/all", -- [25]
				},
				["point"] = "BOTTOMRIGHT",
				["hiddenBags"] = {
				},
				["color"] = {
					0.0862745098039216, -- [1]
					0.0862745098039216, -- [2]
					0.0862745098039216, -- [3]
					1, -- [4]
				},
				["actPanel"] = false,
				["bagToggle"] = true,
				["columns"] = 10,
				["money"] = true,
				["hiddenRules"] = {
					["misc"] = false,
					["misc/all"] = false,
				},
				["alpha"] = 1,
				["borderColor"] = {
					0, -- [1]
					0, -- [2]
					0, -- [3]
					1, -- [4]
				},
				["y"] = 151.214965820313,
				["x"] = -358.828125,
				["search"] = true,
				["itemScale"] = 1.01,
				["reverseSlots"] = false,
				["bagBreak"] = false,
				["scale"] = 1,
				["spacing"] = 4,
			},
			["vault"] = {
				["rules"] = {
					"all", -- [1]
					"all/all", -- [2]
					"all/normal", -- [3]
					"all/trade", -- [4]
					"all/reagent", -- [5]
					"equip", -- [6]
					"equip/all", -- [7]
					"equip/armor", -- [8]
					"equip/weapon", -- [9]
					"equip/trinket", -- [10]
					"use", -- [11]
					"use/all", -- [12]
					"use/consume", -- [13]
					"use/enhance", -- [14]
					"trade", -- [15]
					"trade/all", -- [16]
					"trade/goods", -- [17]
					"trade/gem", -- [18]
					"trade/glyph", -- [19]
					"trade/recipe", -- [20]
					"quest", -- [21]
					"misc", -- [22]
				},
				["columns"] = 10,
				["hiddenBags"] = {
				},
				["color"] = {
					0.0862745098039216, -- [1]
					0.0862745098039216, -- [2]
					0.0862745098039216, -- [3]
					1, -- [4]
				},
				["hiddenRules"] = {
				},
				["borderColor"] = {
				},
				["spacing"] = 4,
				["itemScale"] = 1,
				["scale"] = 1,
				["alpha"] = 1,
			},
			["guild"] = {
				["rules"] = {
					"all", -- [1]
					"all/all", -- [2]
					"all/normal", -- [3]
					"all/trade", -- [4]
					"all/reagent", -- [5]
					"equip", -- [6]
					"equip/all", -- [7]
					"equip/armor", -- [8]
					"equip/weapon", -- [9]
					"equip/trinket", -- [10]
					"use", -- [11]
					"use/all", -- [12]
					"use/consume", -- [13]
					"use/enhance", -- [14]
					"trade", -- [15]
					"trade/all", -- [16]
					"trade/goods", -- [17]
					"trade/gem", -- [18]
					"trade/glyph", -- [19]
					"trade/recipe", -- [20]
					"quest", -- [21]
					"misc", -- [22]
					"quest/all", -- [23]
					"contain/all", -- [24]
					"misc/all", -- [25]
				},
				["point"] = "TOPRIGHT",
				["hiddenBags"] = {
				},
				["color"] = {
					0.0862745098039216, -- [1]
					0.0862745098039216, -- [2]
					0.0862745098039216, -- [3]
					1, -- [4]
				},
				["hiddenRules"] = {
				},
				["bagBreak"] = false,
				["y"] = -275.690612792969,
				["x"] = -827.17578125,
				["columns"] = 10,
				["borderColor"] = {
				},
				["spacing"] = 4,
				["itemScale"] = 1,
				["scale"] = 1,
				["alpha"] = 1,
			},
			["bank"] = {
				["exclusiveReagent"] = false,
				["rules"] = {
					"all", -- [1]
					"all/all", -- [2]
					"all/normal", -- [3]
					"all/trade", -- [4]
					"all/reagent", -- [5]
					"equip", -- [6]
					"equip/all", -- [7]
					"equip/armor", -- [8]
					"equip/weapon", -- [9]
					"equip/trinket", -- [10]
					"use", -- [11]
					"use/all", -- [12]
					"use/consume", -- [13]
					"use/enhance", -- [14]
					"trade", -- [15]
					"trade/all", -- [16]
					"trade/goods", -- [17]
					"trade/gem", -- [18]
					"trade/glyph", -- [19]
					"trade/recipe", -- [20]
					"quest", -- [21]
					"misc", -- [22]
					"quest/all", -- [23]
					"contain/all", -- [24]
					"misc/all", -- [25]
				},
				["columns"] = 20,
				["hiddenBags"] = {
				},
				["color"] = {
					0.0862745098039216, -- [1]
					0.0862745098039216, -- [2]
					0.0862745098039216, -- [3]
					1, -- [4]
				},
				["hiddenRules"] = {
				},
				["y"] = -135.809875488281,
				["x"] = -450.23876953125,
				["point"] = "TOPRIGHT",
				["borderColor"] = {
				},
				["spacing"] = 4,
				["itemScale"] = 1,
				["scale"] = 1,
				["alpha"] = 1,
			},
		},
		["normalColor"] = {
		},
		["herbColor"] = {
		},
		["tackleColor"] = {
		},
		["leatherColor"] = {
		},
	}
end