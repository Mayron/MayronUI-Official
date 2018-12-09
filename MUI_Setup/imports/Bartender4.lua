local _, setup = ...;

setup.import["Bartender4"] = function()
	local settings = {
		["namespaces"] = {
			["ActionBars"] = {
				["profiles"] = {
					["MayronUI"] = {
						["actionbars"] = {
							{
								["showgrid"] = true,
								["fadeoutalpha"] = 1,
								["version"] = 3,
								["position"] = {
									["y"] = 75,
									["x"] = -354,
									["point"] = "BOTTOM",
									["scale"] = 0.850000023841858,
								},
								["padding"] = 5.5,
								["hidemacrotext"] = true,
								["visibility"] = {
									["always"] = false,
								},
								["states"] = {
									["actionbar"] = true,
									["stance"] = {
										["WARRIOR"] = {
											["berserker"] = 8,
											["battle"] = 1,
											["def"] = 6,
										},
										["WARLOCK"] = {
											["metamorphosis"] = 0,
										},
										["ROGUE"] = {
											["stealth"] = 8,
										},
										["DRUID"] = {
											["treeoflife"] = 0,
											["cat"] = 6,
											["bear"] = 5,
										},
										["MONK"] = {
											["serpent"] = 5,
											["ox"] = 6,
										},
										["PRIEST"] = {
											["shadowform"] = 5,
										},
									},
								},
							}, -- [1]
							{
								["enabled"] = false,
								["version"] = 3,
								["position"] = {
									["y"] = -189.499941973427,
									["x"] = -231.500185021676,
									["point"] = "CENTER",
								},
							}, -- [2]
							{
								["showgrid"] = true,
								["rows"] = 12,
								["hidemacrotext"] = true,
								["version"] = 3,
								["position"] = {
									["y"] = 265,
									["x"] = -41,
									["point"] = "RIGHT",
									["scale"] = 0.9,
								},
								["padding"] = 5.5,
								["visibility"] = {
									["always"] = false,
									["vehicleui"] = false,
								},
							}, -- [3]
							{
								["showgrid"] = true,
								["rows"] = 12,
								["alpha"] = 0,
								["hidemacrotext"] = true,
								["version"] = 3,
								["position"] = {
									["y"] = 265,
									["x"] = -78,
									["point"] = "RIGHT",
									["scale"] = 0.899999976158142,
								},
								["padding"] = 5.5,
								["visibility"] = {
									["always"] = true,
									["vehicleui"] = false,
								},
							}, -- [4]
							{
								["showgrid"] = true,
								["rows"] = 2,
								["enabled"] = false,
								["buttons"] = 8,
								["padding"] = 6,
								["version"] = 3,
								["position"] = {
									["y"] = 249.804935363009,
									["x"] = -77.4000068664551,
									["point"] = "BOTTOM",
									["scale"] = 0.9,
								},
								["hidemacrotext"] = true,
								["visibility"] = {
									["always"] = false,
									["vehicle"] = false,
								},
							}, -- [5]
							{
								["showgrid"] = true,
								["enabled"] = false,
								["version"] = 3,
								["position"] = {
									["y"] = 127.984567461994,
									["x"] = 90.7013938892309,
									["point"] = "LEFT",
								},
								["padding"] = 6,
								["visibility"] = {
									["always"] = false,
								},
							}, -- [6]
							{
								["showgrid"] = true,
								["enabled"] = true,
								["buttons"] = 8,
								["version"] = 3,
								["position"] = {
									["y"] = 75,
									["x"] = 69,
									["point"] = "BOTTOM",
									["scale"] = 0.850000023841858,
								},
								["hidemacrotext"] = true,
								["padding"] = 5.5,
								["visibility"] = {
									["always"] = false,
									["overridebar"] = false,
									["vehicleui"] = false,
								},
								["states"] = {
									["enabled"] = true,
									["stance"] = {
										["MONK"] = {
											["crane"] = 8,
											["tiger"] = 8,
											["serpent"] = 8,
											["ox"] = 8,
										},
										["ROGUE"] = {
											["stealth"] = 0,
										},
									},
								},
							}, -- [7]
							{
								["showgrid"] = true,
								["enabled"] = true,
								["version"] = 3,
								["position"] = {
									["y"] = 127.925109863281,
									["x"] = 154.562774658203,
									["point"] = "LEFT",
								},
								["padding"] = 6,
								["visibility"] = {
									["always"] = true,
								},
								["states"] = {
									["enabled"] = true,
									["stance"] = {
										["MONK"] = {
											["tiger"] = 1,
											["serpent"] = 1,
											["ox"] = 1,
										},
									},
								},
							}, -- [8]
							{
								["showgrid"] = true,
								["enabled"] = true,
								["buttons"] = 8,
								["alpha"] = 0,
								["hidemacrotext"] = true,
								["version"] = 3,
								["position"] = {
									["y"] = 110,
									["x"] = 69,
									["point"] = "BOTTOM",
									["scale"] = 0.85,
								},
								["padding"] = 5.5,
								["visibility"] = {
									["always"] = true,
									["vehicle"] = false,
									["vehicleui"] = false,
								},
							}, -- [9]
							{
								["showgrid"] = true,
								["enabled"] = true,
								["alpha"] = 0,
								["hidemacrotext"] = true,
								["version"] = 3,
								["position"] = {
									["y"] = 110,
									["x"] = -354,
									["point"] = "BOTTOM",
									["scale"] = 0.85,
								},
								["padding"] = 5.5,
								["visibility"] = {
									["always"] = true,
									["vehicle"] = false,
									["vehicleui"] = false,
								},
							}, -- [10]
						},
					},
				},
			},
			["LibDualSpec-1.0"] = {
			},
			["ExtraActionBar"] = {
				["profiles"] = {
					["MayronUI"] = {
						["position"] = {
							["y"] = -156.885192871094,
							["x"] = -31.5000610351563,
							["point"] = "TOP",
						},
						["version"] = 3,
					},
				},
			},
			["APBar"] = {
				["profiles"] = {
					["MayronUI"] = {
						["position"] = {
							["y"] = -1,
							["x"] = -363.300042724609,
							["point"] = "TOP",
							["scale"] = 0.7,
						},
						["version"] = 3,
					},
				},
			},
			["MicroMenu"] = {
				["profiles"] = {
					["MayronUI"] = {
						["enabled"] = false,
						["position"] = {
							["y"] = 32.4000004827976,
							["x"] = 442.479598762358,
							["point"] = "BOTTOM",
							["scale"] = 0.800000011920929,
						},
						["version"] = 3,
					},
				},
			},
			["XPBar"] = {
				["profiles"] = {
					["MayronUI"] = {
						["version"] = 3,
						["position"] = {
							["y"] = -1,
							["x"] = -363.299957275391,
							["point"] = "TOP",
							["scale"] = 0.7,
						},
						["visibility"] = {
							["always"] = false,
							["vehicleui"] = false,
						},
						["fadeoutalpha"] = 1,
					},
				},
			},
			["MultiCast"] = {
				["profiles"] = {
					["MayronUI"] = {
						["enabled"] = false,
						["version"] = 3,
						["position"] = {
							["y"] = 35.0000026671023,
							["x"] = 284.333404478858,
							["point"] = "BOTTOMLEFT",
						},
					},
				},
			},
			["BlizzardArt"] = {
				["profiles"] = {
					["MayronUI"] = {
						["artLayout"] = "TWOBAR",
						["position"] = {
							["y"] = 261.633357818245,
							["x"] = 448.00001313035,
							["point"] = "BOTTOMLEFT",
						},
						["version"] = 3,
					},
				},
			},
			["BagBar"] = {
				["profiles"] = {
					["MayronUI"] = {
						["enabled"] = false,
						["onebag"] = true,
						["position"] = {
							["y"] = 41.75,
							["x"] = 463.5,
							["point"] = "BOTTOM",
						},
						["version"] = 3,
					},
				},
			},
			["Vehicle"] = {
				["profiles"] = {
					["MayronUI"] = {
						["version"] = 3,
						["position"] = {
							["y"] = 41,
							["x"] = -408.685424804688,
							["point"] = "BOTTOMRIGHT",
						},
					},
				},
			},
			["StanceBar"] = {
				["profiles"] = {
					["MayronUI"] = {
						["rows"] = 3,
						["fadeoutalpha"] = 0.5,
						["position"] = {
							["y"] = -2,
							["x"] = -378,
							["point"] = "BOTTOM",
							["scale"] = 0.9,
							["growVertical"] = "UP",
							["growHorizontal"] = "LEFT",
						},
						["padding"] = 3,
						["visibility"] = {
							["stance"] = {
								false, -- [1]
							},
						},
						["version"] = 3,
					},
				},
			},
			["PetBar"] = {
				["profiles"] = {
					["MayronUI"] = {
						["showgrid"] = true,
						["rows"] = 2,
						["fadeoutalpha"] = 0,
						["position"] = {
							["y"] = 68.2467037022675,
							["x"] = 437.264575814101,
							["point"] = "BOTTOM",
							["scale"] = 0.699999988079071,
						},
						["visibility"] = {
							["always"] = false,
						},
						["version"] = 3,
					},
				},
			},
			["RepBar"] = {
				["profiles"] = {
					["MayronUI"] = {
						["enabled"] = true,
						["version"] = 3,
						["position"] = {
							["y"] = 1,
							["x"] = -413.200048828125,
							["point"] = "TOP",
							["scale"] = 0.8,
						},
						["visibility"] = {
							["always"] = true,
						},
						["fadeoutalpha"] = 0,
					},
				},
			},
		},
		["profiles"] = {
			["MayronUI"] = {
				["minimapIcon"] = {
					["hide"] = true,
				},
				["focuscastmodifier"] = false,
			},
		},
	};
	for k, v in pairs(settings) do
		_G.Bartender4DB[k] = v;
	end
end