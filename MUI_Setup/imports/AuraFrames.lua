local _, setup = ...;

setup.import["AuraFrames"] = function()
	local settings = {
		["MayronUI"] = {
			["DbVersion"] = 234,
			["Containers"] = {
				["PlayerBuffs"] = {
					["Type"] = "ButtonContainer",
					["Id"] = "PlayerBuffs",
					["Layout"] = {
						["DurationOutline"] = "OUTLINE",
						["SpaceY"] = 14,
						["Scale"] = 1,
						["DurationMonochrome"] = false,
						["Clickable"] = true,
						["ShowTooltip"] = true,
						["HorizontalSize"] = 16,
						["MiniBarDirection"] = "HIGHSHRINK",
						["CountAlignment"] = "CENTER",
						["TooltipShowUnitName"] = false,
						["MiniBarTexture"] = "Blizzard",
						["CountColor"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							1, -- [4]
						},
						["MiniBarLength"] = 36,
						["DurationPosY"] = -19.5,
						["ButtonSizeX"] = 27,
						["CountOutline"] = "OUTLINE",
						["CountFont"] = "Friz Quadrata TT",
						["VerticalSize"] = 2,
						["Direction"] = "LEFTDOWN",
						["DurationSize"] = 9,
						["CooldownDrawEdge"] = true,
						["DynamicSize"] = false,
						["MiniBarOffsetY"] = -25,
						["MiniBarWidth"] = 8,
						["MiniBarOffsetX"] = 0,
						["MiniBarColor"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							1, -- [4]
						},
						["CountSize"] = 12,
						["DurationPosX"] = 0,
						["DurationFont"] = "Friz Quadrata TT",
						["TooltipShowClassification"] = false,
						["DurationAlignment"] = "CENTER",
						["MiniBarStyle"] = "HORIZONTAL",
						["ButtonSizeY"] = 27,
						["TooltipShowPrefix"] = false,
						["ShowCooldown"] = false,
						["TooltipShowAuraId"] = false,
						["DurationLayout"] = "ABBREVSPACE",
						["CooldownReverse"] = false,
						["CountPosY"] = 7,
						["ShowBorder"] = "ALWAYS",
						["ShowCount"] = true,
						["CountMonochrome"] = false,
						["CooldownDisableOmniCC"] = true,
						["DurationColor"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							1, -- [4]
						},
						["TooltipShowCaster"] = false,
						["MiniBarEnabled"] = false,
						["ShowDuration"] = true,
						["CountPosX"] = 10,
						["SpaceX"] = 5,
					},
					["Order"] = {
						["Expert"] = false,
						["Predefined"] = "NoTimeTimeLeftDesc",
						["Rules"] = {
							{
								["Args"] = {
									["Float"] = 0,
								},
								["Subject"] = "ExpirationTime",
								["Operator"] = "First",
							}, -- [1]
							{
								["Args"] = {
								},
								["Subject"] = "ExpirationTime",
								["Operator"] = "NumberDesc",
							}, -- [2]
						},
					},
					["Sources"] = {
						["player"] = {
							["WEAPON"] = true,
							["HELPFUL"] = true,
						},
					},
					["Colors"] = {
						["Expert"] = false,
						["DefaultColor"] = {
							1, -- [1]
							0.03137254901960784, -- [2]
							0, -- [3]
							1, -- [4]
						},
						["Rules"] = {
							{
								["Color"] = {
									0.8, -- [1]
									0, -- [2]
									0, -- [3]
									1, -- [4]
								},
								["Name"] = "Unknown Debuff Type",
								["Groups"] = {
									{
										{
											["Operator"] = "Equal",
											["Subject"] = "Type",
											["Args"] = {
												["String"] = "HARMFUL",
											},
										}, -- [1]
										{
											["Operator"] = "Equal",
											["Subject"] = "Classification",
											["Args"] = {
												["String"] = "None",
											},
										}, -- [2]
									}, -- [1]
								},
							}, -- [1]
							{
								["Color"] = {
									0.2, -- [1]
									0.6, -- [2]
									1, -- [3]
									1, -- [4]
								},
								["Name"] = "Debuff Type Magic",
								["Groups"] = {
									{
										{
											["Operator"] = "Equal",
											["Subject"] = "Type",
											["Args"] = {
												["String"] = "HARMFUL",
											},
										}, -- [1]
										{
											["Operator"] = "Equal",
											["Subject"] = "Classification",
											["Args"] = {
												["String"] = "Magic",
											},
										}, -- [2]
									}, -- [1]
								},
							}, -- [2]
							{
								["Color"] = {
									0.6, -- [1]
									0, -- [2]
									1, -- [3]
									1, -- [4]
								},
								["Name"] = "Debuff Type Curse",
								["Groups"] = {
									{
										{
											["Operator"] = "Equal",
											["Subject"] = "Type",
											["Args"] = {
												["String"] = "HARMFUL",
											},
										}, -- [1]
										{
											["Operator"] = "Equal",
											["Subject"] = "Classification",
											["Args"] = {
												["String"] = "Curse",
											},
										}, -- [2]
									}, -- [1]
								},
							}, -- [3]
							{
								["Color"] = {
									0.6, -- [1]
									0.4, -- [2]
									0, -- [3]
									1, -- [4]
								},
								["Name"] = "Debuff Type Disease",
								["Groups"] = {
									{
										{
											["Operator"] = "Equal",
											["Subject"] = "Type",
											["Args"] = {
												["String"] = "HARMFUL",
											},
										}, -- [1]
										{
											["Operator"] = "Equal",
											["Subject"] = "Classification",
											["Args"] = {
												["String"] = "Disease",
											},
										}, -- [2]
									}, -- [1]
								},
							}, -- [4]
							{
								["Color"] = {
									0, -- [1]
									0.6, -- [2]
									0, -- [3]
									1, -- [4]
								},
								["Name"] = "Debuff Type Poison",
								["Groups"] = {
									{
										{
											["Operator"] = "Equal",
											["Subject"] = "Type",
											["Args"] = {
												["String"] = "HARMFUL",
											},
										}, -- [1]
										{
											["Operator"] = "Equal",
											["Subject"] = "Classification",
											["Args"] = {
												["String"] = "Poison",
											},
										}, -- [2]
									}, -- [1]
								},
							}, -- [5]
							{
								["Color"] = {
									0, -- [1]
									0, -- [2]
									0, -- [3]
									1, -- [4]
								},
								["Name"] = "Buff",
								["Groups"] = {
									{
										{
											["Operator"] = "Equal",
											["Subject"] = "Type",
											["Args"] = {
												["String"] = "HELPFUL",
											},
										}, -- [1]
									}, -- [1]
								},
							}, -- [6]
							{
								["Color"] = {
									1, -- [1]
									0, -- [2]
									0.9137254901960784, -- [3]
									1, -- [4]
								},
								["Name"] = "Weapon",
								["Groups"] = {
									{
										{
											["Operator"] = "Equal",
											["Subject"] = "Type",
											["Args"] = {
												["String"] = "WEAPON",
											},
										}, -- [1]
									}, -- [1]
								},
							}, -- [7]
						},
					},
					["Filter"] = {
						["Groups"] = {
						},
						["Expert"] = false,
					},
					["Location"] = {
						["OffsetX"] = -209.3571319580078,
						["RelativePoint"] = "TOPRIGHT",
						["OffsetY"] = -4.452567100524902,
						["FramePoint"] = "TOPRIGHT",
					},
					["Name"] = "Player Buffs",
					["Visibility"] = {
						["AlwaysVisible"] = true,
						["VisibleWhen"] = {
						},
						["VisibleWhenNot"] = {
						},
					},
					["Animations"] = {
						["ContainerVisibility"] = {
							["Enabled"] = true,
							["Duration"] = 0.5,
							["InvisibleAlpha"] = 0.6,
							["Animation"] = "Fade",
						},
						["AuraExpiring"] = {
							["Enabled"] = true,
							["Duration"] = 0.5,
							["Animation"] = "FadeOut",
						},
						["AuraChanging"] = {
							["Enabled"] = true,
							["Duration"] = 1,
							["Times"] = 3,
							["Animation"] = "Flash",
						},
						["AuraNew"] = {
							["Enabled"] = false,
							["Duration"] = 1,
							["Times"] = 3,
							["Animation"] = "Flash",
						},
					},
				},
				["PlayerDebuffs"] = {
					["Type"] = "ButtonContainer",
					["Id"] = "PlayerDebuffs",
					["Layout"] = {
						["DurationOutline"] = "OUTLINE",
						["SpaceY"] = 14,
						["Scale"] = 1,
						["DurationMonochrome"] = false,
						["Clickable"] = true,
						["ShowTooltip"] = true,
						["HorizontalSize"] = 16,
						["MiniBarDirection"] = "HIGHSHRINK",
						["CountAlignment"] = "CENTER",
						["TooltipShowUnitName"] = false,
						["MiniBarTexture"] = "Blizzard",
						["CountColor"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							1, -- [4]
						},
						["MiniBarLength"] = 36,
						["DurationPosY"] = -19.5,
						["ButtonSizeX"] = 27,
						["CountOutline"] = "OUTLINE",
						["CountFont"] = "Friz Quadrata TT",
						["VerticalSize"] = 2,
						["Direction"] = "LEFTDOWN",
						["DurationSize"] = 9,
						["CooldownDrawEdge"] = true,
						["DynamicSize"] = false,
						["MiniBarOffsetY"] = -25,
						["MiniBarWidth"] = 8,
						["MiniBarOffsetX"] = 0,
						["MiniBarColor"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							1, -- [4]
						},
						["CountSize"] = 11,
						["DurationPosX"] = 0,
						["DurationFont"] = "Friz Quadrata TT",
						["TooltipShowClassification"] = false,
						["DurationAlignment"] = "CENTER",
						["MiniBarStyle"] = "HORIZONTAL",
						["ButtonSizeY"] = 27,
						["TooltipShowPrefix"] = false,
						["ShowCooldown"] = false,
						["TooltipShowAuraId"] = false,
						["DurationLayout"] = "ABBREVSPACE",
						["CooldownReverse"] = false,
						["CountPosY"] = 7,
						["ShowBorder"] = "ALWAYS",
						["ShowCount"] = true,
						["CountMonochrome"] = false,
						["CooldownDisableOmniCC"] = true,
						["DurationColor"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
							1, -- [4]
						},
						["TooltipShowCaster"] = true,
						["MiniBarEnabled"] = false,
						["ShowDuration"] = true,
						["CountPosX"] = 9,
						["SpaceX"] = 5,
					},
					["Order"] = {
						["Expert"] = false,
						["Predefined"] = "NoTimeTimeLeftDesc",
						["Rules"] = {
							{
								["Args"] = {
									["Float"] = 0,
								},
								["Subject"] = "ExpirationTime",
								["Operator"] = "First",
							}, -- [1]
							{
								["Args"] = {
								},
								["Subject"] = "ExpirationTime",
								["Operator"] = "NumberDesc",
							}, -- [2]
						},
					},
					["Sources"] = {
						["player"] = {
							["HARMFUL"] = true,
						},
					},
					["Colors"] = {
						["Expert"] = false,
						["DefaultColor"] = {
							1, -- [1]
							0, -- [2]
							0.01568627450980392, -- [3]
							1, -- [4]
						},
						["Rules"] = {
							{
								["Color"] = {
									0.8, -- [1]
									0, -- [2]
									0, -- [3]
									1, -- [4]
								},
								["Name"] = "Unknown Debuff Type",
								["Groups"] = {
									{
										{
											["Operator"] = "Equal",
											["Subject"] = "Type",
											["Args"] = {
												["String"] = "HARMFUL",
											},
										}, -- [1]
										{
											["Operator"] = "Equal",
											["Subject"] = "Classification",
											["Args"] = {
												["String"] = "None",
											},
										}, -- [2]
									}, -- [1]
								},
							}, -- [1]
							{
								["Color"] = {
									0.2, -- [1]
									0.6, -- [2]
									1, -- [3]
									1, -- [4]
								},
								["Name"] = "Debuff Type Magic",
								["Groups"] = {
									{
										{
											["Operator"] = "Equal",
											["Subject"] = "Type",
											["Args"] = {
												["String"] = "HARMFUL",
											},
										}, -- [1]
										{
											["Operator"] = "Equal",
											["Subject"] = "Classification",
											["Args"] = {
												["String"] = "Magic",
											},
										}, -- [2]
									}, -- [1]
								},
							}, -- [2]
							{
								["Color"] = {
									0.6, -- [1]
									0, -- [2]
									1, -- [3]
									1, -- [4]
								},
								["Name"] = "Debuff Type Curse",
								["Groups"] = {
									{
										{
											["Operator"] = "Equal",
											["Subject"] = "Type",
											["Args"] = {
												["String"] = "HARMFUL",
											},
										}, -- [1]
										{
											["Operator"] = "Equal",
											["Subject"] = "Classification",
											["Args"] = {
												["String"] = "Curse",
											},
										}, -- [2]
									}, -- [1]
								},
							}, -- [3]
							{
								["Color"] = {
									0.6, -- [1]
									0.4, -- [2]
									0, -- [3]
									1, -- [4]
								},
								["Name"] = "Debuff Type Disease",
								["Groups"] = {
									{
										{
											["Operator"] = "Equal",
											["Subject"] = "Type",
											["Args"] = {
												["String"] = "HARMFUL",
											},
										}, -- [1]
										{
											["Operator"] = "Equal",
											["Subject"] = "Classification",
											["Args"] = {
												["String"] = "Disease",
											},
										}, -- [2]
									}, -- [1]
								},
							}, -- [4]
							{
								["Color"] = {
									0, -- [1]
									0.6, -- [2]
									0, -- [3]
									1, -- [4]
								},
								["Name"] = "Debuff Type Poison",
								["Groups"] = {
									{
										{
											["Operator"] = "Equal",
											["Subject"] = "Type",
											["Args"] = {
												["String"] = "HARMFUL",
											},
										}, -- [1]
										{
											["Operator"] = "Equal",
											["Subject"] = "Classification",
											["Args"] = {
												["String"] = "Poison",
											},
										}, -- [2]
									}, -- [1]
								},
							}, -- [5]
							{
								["Color"] = {
									0, -- [1]
									0, -- [2]
									0, -- [3]
									1, -- [4]
								},
								["Name"] = "Buff",
								["Groups"] = {
									{
										{
											["Operator"] = "Equal",
											["Subject"] = "Type",
											["Args"] = {
												["String"] = "HELPFUL",
											},
										}, -- [1]
									}, -- [1]
								},
							}, -- [6]
							{
								["Color"] = {
									0.6392156862745098, -- [1]
									0, -- [2]
									0.5843137254901961, -- [3]
									1, -- [4]
								},
								["Name"] = "Weapon",
								["Groups"] = {
									{
										{
											["Operator"] = "Equal",
											["Subject"] = "Type",
											["Args"] = {
												["String"] = "WEAPON",
											},
										}, -- [1]
									}, -- [1]
								},
							}, -- [7]
						},
					},
					["Filter"] = {
						["Groups"] = {
						},
						["Expert"] = false,
					},
					["Location"] = {
						["OffsetX"] = -209.9758453369141,
						["RelativePoint"] = "TOPRIGHT",
						["OffsetY"] = -109.3413543701172,
						["FramePoint"] = "TOPRIGHT",
					},
					["Name"] = "Player Debuffs",
					["Visibility"] = {
						["AlwaysVisible"] = true,
						["VisibleWhen"] = {
						},
						["VisibleWhenNot"] = {
						},
					},
					["Animations"] = {
						["ContainerVisibility"] = {
							["Enabled"] = true,
							["Duration"] = 0.5,
							["InvisibleAlpha"] = 0.6,
							["Animation"] = "Fade",
						},
						["AuraExpiring"] = {
							["Enabled"] = true,
							["Duration"] = 0.5,
							["Animation"] = "FadeOut",
						},
						["AuraChanging"] = {
							["Enabled"] = true,
							["Duration"] = 1,
							["Times"] = 3,
							["Animation"] = "Flash",
						},
						["AuraNew"] = {
							["Enabled"] = false,
							["Duration"] = 1,
							["Times"] = 3,
							["Animation"] = "Flash",
						},
					},
				},
			},
		},
	};
	for k, v in pairs(settings) do
		_G.AuraFramesDB.profiles[k] = v;
	end
end