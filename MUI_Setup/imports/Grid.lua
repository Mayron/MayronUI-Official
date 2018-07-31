local _, setup = ...;

setup.import["Grid"] = function()
	local settings = {
		["namespaces"] = {
			["GridStatusStagger"] = {
			},
			["LibDualSpec-1.0"] = {
			},
			["GridStatusResurrect"] = {
			},
			["GridStatusAbsorbs"] = {
			},
			["GridMBFrame"] = {
				["profiles"] = {
					["Default"] = {
						["side"] = "Bottom",
						["size"] = 0.1,
					},
					["MayronUIH"] = {
						["side"] = "Bottom",
						["size"] = 0.1,
					},
				},
			},
			["GridStatusRange"] = {
			},
			["GridStatus"] = {
				["profiles"] = {
					["Default"] = {
						["colors"] = {
							["HUNTER"] = {
								["b"] = 0.45,
								["g"] = 0.83,
								["r"] = 0.67,
							},
							["ROGUE"] = {
								["b"] = 0.41,
								["g"] = 0.96,
								["r"] = 1,
							},
							["MAGE"] = {
								["b"] = 0.94,
								["g"] = 0.8,
								["r"] = 0.41,
							},
							["DRUID"] = {
								["b"] = 0.04,
								["g"] = 0.49,
								["r"] = 1,
							},
							["MONK"] = {
								["b"] = 0.59,
								["g"] = 1,
								["r"] = 0,
							},
							["DEATHKNIGHT"] = {
								["b"] = 0.23,
								["g"] = 0.12,
								["r"] = 0.77,
							},
							["PRIEST"] = {
								["b"] = 1,
								["g"] = 1,
								["r"] = 1,
							},
							["WARLOCK"] = {
								["b"] = 0.79,
								["g"] = 0.51,
								["r"] = 0.58,
							},
							["DEMONHUNTER"] = {
								["r"] = 0.64,
								["g"] = 0.19,
								["b"] = 0.79,
							},
							["WARRIOR"] = {
								["b"] = 0.43,
								["g"] = 0.61,
								["r"] = 0.78,
							},
							["SHAMAN"] = {
								["b"] = 0.87,
								["g"] = 0.44,
								["r"] = 0,
							},
							["PALADIN"] = {
								["b"] = 0.73,
								["g"] = 0.55,
								["r"] = 0.96,
							},
						},
					},
					["MayronUIH"] = {
						["colors"] = {
							["DEATHKNIGHT"] = {
								["r"] = 0.77,
								["g"] = 0.12,
								["b"] = 0.23,
							},
							["WARRIOR"] = {
								["r"] = 0.78,
								["g"] = 0.61,
								["b"] = 0.43,
							},
							["SHAMAN"] = {
								["r"] = 0,
								["g"] = 0.44,
								["b"] = 0.87,
							},
							["MAGE"] = {
								["r"] = 0.41,
								["g"] = 0.8,
								["b"] = 0.94,
							},
							["PRIEST"] = {
								["r"] = 1,
								["g"] = 1,
								["b"] = 1,
							},
							["ROGUE"] = {
								["r"] = 1,
								["g"] = 0.96,
								["b"] = 0.41,
							},
							["WARLOCK"] = {
								["r"] = 0.58,
								["g"] = 0.51,
								["b"] = 0.79,
							},
							["DEMONHUNTER"] = {
								["r"] = 0.64,
								["g"] = 0.19,
								["b"] = 0.79,
							},
							["HUNTER"] = {
								["r"] = 0.67,
								["g"] = 0.83,
								["b"] = 0.45,
							},
							["DRUID"] = {
								["r"] = 1,
								["g"] = 0.49,
								["b"] = 0.04,
							},
							["MONK"] = {
								["r"] = 0,
								["g"] = 1,
								["b"] = 0.59,
							},
							["PALADIN"] = {
								["r"] = 0.96,
								["g"] = 0.55,
								["b"] = 0.73,
							},
						},
					},
				},
			},
			["GridStatusAggro"] = {
			},
			["GridStatusHeals"] = {
			},
			["GridLayout"] = {
				["profiles"] = {
					["Default"] = {
						["backgroundTexture"] = "None",
						["layouts"] = {
							["party"] = "None",
							["solo"] = "None",
							["raid"] = "ByGroup",
							["raid_10"] = "By Group 25",
						},
						["FrameLock"] = true,
						["borderSize"] = 1,
						["Spacing"] = 0,
						["anchor"] = "BOTTOMLEFT",
						["backgroundColor"] = {
							["a"] = 1,
							["b"] = 0,
							["g"] = 0,
							["r"] = 0,
						},
						["groupAnchor"] = "BOTTOMLEFT",
						["PosY"] = -7,
						["layout"] = "None",
						["lock"] = true,
						["PosX"] = -7,
						["borderInset"] = 5,
						["Padding"] = 0,
						["layoutPadding"] = 0,
						["borderTexture"] = "None",
						["horizontal"] = true,
						["borderColor"] = {
							["a"] = 0,
							["b"] = 0.501960784313726,
							["g"] = 0.501960784313726,
							["r"] = 0.501960784313726,
						},
						["anchorRel"] = "BOTTOMLEFT",
					},
					["MayronUIH"] = {
						["anchorRel"] = "BOTTOMRIGHT",
						["layouts"] = {
							["raid"] = "ByGroup",
							["solo"] = "None",
							["raid_10"] = "By Group 25",
						},
						["FrameLock"] = true,
						["borderSize"] = 1,
						["borderColor"] = {
							["a"] = 0,
							["r"] = 0.501960784313726,
							["g"] = 0.501960784313726,
							["b"] = 0.501960784313726,
						},
						["anchor"] = "BOTTOMRIGHT",
						["backgroundColor"] = {
							["a"] = 1,
							["r"] = 0,
							["g"] = 0,
							["b"] = 0,
						},
						["groupAnchor"] = "BOTTOMRIGHT",
						["PosY"] = 444,
						["layout"] = "None",
						["lock"] = true,
						["borderInset"] = 5,
						["PosX"] = -649,
						["Padding"] = 0,
						["Spacing"] = 0,
						["horizontal"] = true,
						["layoutPadding"] = 0,
						["backgroundTexture"] = "Solid",
					},
				},
			},
			["GridStatusUnitPower"] = {
			},
			["GridStatusAncientBarrier"] = {
				["profiles"] = {
					["MayronUIH"] = {
						["unit_ancient_barrier"] = {
							["priority"] = 99,
						},
					},
				},
			},
			["GridStatusRaidIcons"] = {
				["profiles"] = {
					["Default"] = {
						["alert_raidicons_playertarget"] = {
							["priority"] = 80,
						},
					},
					["MayronUIH"] = {
						["alert_raidicons_playertarget"] = {
							["priority"] = 80,
						},
					},
				},
			},
			["GridStatusVehicle"] = {
			},
			["GridRoster"] = {
			},
			["GridStatusAuras"] = {
				["profiles"] = {
					["MayronUIH"] = {
						["buff_PowerWord:Shield"] = {
							["icon"] = "Interface\\Icons\\Spell_Holy_PowerWordShield",
						},
						["buff_Lifebloom"] = {
							["icon"] = "Interface\\Icons\\INV_Misc_Herb_Felblossom",
						},
						["buff_Regrowth"] = {
							["icon"] = "Interface\\Icons\\Spell_Nature_ResistNature",
						},
						["buff_Riptide"] = {
							["icon"] = "Interface\\Icons\\spell_nature_riptide",
						},
						["buff_BeaconofLight"] = {
							["icon"] = "Interface\\Icons\\Ability_Paladin_BeaconofLight",
						},
						["buff_Rejuvenation"] = {
							["icon"] = "Interface\\Icons\\Spell_Nature_Rejuvenation",
						},
						["advancedOptions"] = true,
						["buff_Renew"] = {
							["icon"] = "Interface\\Icons\\Spell_Holy_Renew",
						},
					},
					["Default"] = {
						["buff_Riptide"] = {
							["icon"] = "Interface\\Icons\\spell_nature_riptide",
						},
						["buff_PowerWord:Shield"] = {
							["icon"] = "Interface\\Icons\\Spell_Holy_PowerWordShield",
						},
						["advancedOptions"] = true,
						["buff_Rejuvenation"] = {
							["icon"] = "Interface\\Icons\\Spell_Nature_Rejuvenation",
						},
						["buff_Renew"] = {
							["icon"] = "Interface\\Icons\\Spell_Holy_Renew",
						},
					},
				},
			},
			["GridMBStatus"] = {
				["profiles"] = {
					["Default"] = {
						["hiderage"] = true,
						["color"] = {
							["g"] = 0.501960784313726,
						},
					},
					["MayronUIH"] = {
						["hiderage"] = true,
						["color"] = {
							["g"] = 0.501960784313726,
						},
					},
				},
			},
			["GridStatusRaidDebuff"] = {
				["profiles"] = {
					["Default"] = {
						["detected_debuff"] = {
							["Throne of Thunder"] = {
								["Arterial Cut"] = 133768,
								["Bright Light"] = 133737,
								["Scorched"] = 134647,
								["Sanctuary of the Ox"] = 126119,
								["Jade Spirit"] = 104993,
								["Electrical Shock"] = 136914,
								["Foul Venom"] = 139310,
								["Soothing Mist"] = 125950,
								["Freeze"] = 135145,
								["Touch of the Animus"] = 138659,
								["Infrared Light"] = 133732,
								["Blue Rays"] = 133675,
								["Serious Wound"] = 133767,
								["Overloaded Circuits"] = 137176,
								["Fusion Slash"] = 136478,
								["Harsh Light"] = 137152,
								["Decapitate"] = 134912,
								["Arcing Lightning"] = 136193,
								["Flames of Passion"] = 137417,
								["Static Shock"] = 135695,
								["Impale"] = 134691,
								["Burning Winds"] = 136261,
								["Rushing Winds"] = 137654,
								["Slumber Spores"] = 136722,
								["Windburn"] = 140208,
								["Stone Bulwark"] = 114893,
								["Anima Font"] = 138691,
								["Frozen Blood"] = 137664,
								["Fortitude"] = 137593,
								["Matter Swap"] = 138609,
								["Anima Ring"] = 136962,
								["Gnawed Upon"] = 134668,
								["Infected Bite"] = 139314,
								["Life Drain"] = 137727,
								["Violent Gale Winds"] = 136889,
								["Efflorescence"] = 142423,
								["Dancing Steel"] = 120032,
								["Wind Storm"] = 136577,
								["Dead Zone"] = 135147,
								["Volatile Pathogen"] = 136228,
								["Lingering Gaze"] = 134626,
								["Burning Cinders"] = 137668,
								["Malformed Blood"] = 136050,
								["Fan of Flames"] = 137408,
								["Storm Cloud"] = 137669,
								["Explosive Slam"] = 138569,
								["Shockwave"] = 139215,
								["Fully Mutated"] = 140546,
								["Electrified"] = 136615,
								["Discharged Energy"] = 134821,
								["Overcharge"] = 136326,
								["Stormlash Totem"] = 120676,
								["Lightning Burst"] = 138196,
								["Overcharged"] = 136295,
								["Soul Link"] = 108446,
								["Lightning Bolt"] = 136853,
								["Lightning Storm"] = 136192,
								["Invoke Tiger Spirit"] = 138264,
								["Frozen Solid"] = 136892,
								["Crashing Thunder"] = 135153,
								["Corrupted Healing"] = 137360,
								["Putrify"] = 139317,
								["Beast of Nightmares"] = 137375,
								["Healing Stream Totem"] = 119523,
								["Spirit Beast Blessing"] = 127830,
								["Carnivorous Bite"] = 122962,
							},
							["Siege of Orgrimmar"] = {
								["Shredding Blast"] = 148576,
								["Efflorescence"] = 81262,
								["Jade Spirit"] = 104993,
								["Colossus"] = 116631,
							},
						},
						["isFirst"] = false,
					},
					["MayronUIH"] = {
						["detected_debuff"] = {
							["Throne of Thunder"] = {
								["Discharged Energy"] = 134821,
								["Bright Light"] = 133737,
								["Scorched"] = 134647,
								["Sanctuary of the Ox"] = 126119,
								["Jade Spirit"] = 104993,
								["Electrical Shock"] = 136914,
								["Foul Venom"] = 139310,
								["Soothing Mist"] = 125950,
								["Freeze"] = 135145,
								["Touch of the Animus"] = 138659,
								["Infrared Light"] = 133732,
								["Blue Rays"] = 133675,
								["Serious Wound"] = 133767,
								["Overloaded Circuits"] = 137176,
								["Fusion Slash"] = 136478,
								["Harsh Light"] = 137152,
								["Decapitate"] = 134912,
								["Arcing Lightning"] = 136193,
								["Flames of Passion"] = 137417,
								["Static Shock"] = 135695,
								["Impale"] = 134691,
								["Burning Winds"] = 136261,
								["Rushing Winds"] = 137654,
								["Slumber Spores"] = 136722,
								["Explosive Slam"] = 138569,
								["Stone Bulwark"] = 114893,
								["Anima Font"] = 138691,
								["Frozen Blood"] = 137664,
								["Fortitude"] = 137593,
								["Matter Swap"] = 138609,
								["Anima Ring"] = 136962,
								["Gnawed Upon"] = 134668,
								["Infected Bite"] = 139314,
								["Life Drain"] = 137727,
								["Violent Gale Winds"] = 136889,
								["Efflorescence"] = 142423,
								["Dancing Steel"] = 120032,
								["Wind Storm"] = 136577,
								["Soul Link"] = 108446,
								["Frozen Solid"] = 136892,
								["Lingering Gaze"] = 134626,
								["Burning Cinders"] = 137668,
								["Malformed Blood"] = 136050,
								["Fan of Flames"] = 137408,
								["Storm Cloud"] = 137669,
								["Windburn"] = 140208,
								["Arterial Cut"] = 133768,
								["Fully Mutated"] = 140546,
								["Electrified"] = 136615,
								["Beast of Nightmares"] = 137375,
								["Putrify"] = 139317,
								["Corrupted Healing"] = 137360,
								["Crashing Thunder"] = 135153,
								["Volatile Pathogen"] = 136228,
								["Dead Zone"] = 135147,
								["Lightning Storm"] = 136192,
								["Lightning Bolt"] = 136853,
								["Invoke Tiger Spirit"] = 138264,
								["Overcharged"] = 136295,
								["Lightning Burst"] = 138196,
								["Stormlash Totem"] = 120676,
								["Overcharge"] = 136326,
								["Spirit Beast Blessing"] = 127830,
								["Healing Stream Totem"] = 119523,
								["Shockwave"] = 139215,
								["Carnivorous Bite"] = 122962,
							},
							["Siege of Orgrimmar"] = {
								["Magistrike"] = 145563,
								["Colossus"] = 116631,
								["Shadowflame"] = 145551,
								["Sundering Blow"] = 143494,
								["Assassin's Mark"] = 145561,
								["Displaced Energy"] = 142913,
								["Shredding Blast"] = 148576,
								["Stormlash Totem"] = 120676,
								["Jade Spirit"] = 104993,
								["Hunter's Mark"] = 143882,
								["Efflorescence"] = 81262,
								["Dancing Steel"] = 120032,
								["River's Song"] = 116660,
								["Ancient Miasma"] = 142861,
								["Scorched Earth"] = 146228,
								["Soul Link"] = 108446,
								["Bonecracker"] = 145568,
								["Fortitude"] = 137593,
								["Power Word: Barrier"] = 81782,
								["Rend"] = 146927,
								["Healing Stream Totem"] = 119523,
								["Fatal Strike"] = 142990,
								["Languish"] = 143919,
							},
						},
						["isFirst"] = false,
					},
				},
			},
			["GridStatusMana"] = {
			},
			["GridIndicatorCornerIcons"] = {
				["profiles"] = {
					["Default"] = {
						["iconSizeBottomLeftCorner"] = 12,
						["enableIconStackText"] = true,
						["IconStackTextXaxis"] = 2,
						["IconStackTextSize"] = 12,
						["iconSizeBottomRightCorner"] = 12,
						["IconStackTextYaxis"] = 0,
						["iconSizeTopRightCorner"] = 12,
						["xoffset"] = 2,
						["enableIconCooldown"] = true,
						["iconSizeTopLeftCorner"] = 12,
						["yoffset"] = -2,
					},
					["MayronUIH"] = {
						["iconSizeBottomLeftCorner"] = 12,
						["enableIconStackText"] = true,
						["IconStackTextXaxis"] = 2,
						["IconStackTextSize"] = 12,
						["iconSizeBottomRightCorner"] = 12,
						["IconStackTextYaxis"] = 0,
						["iconSizeTopRightCorner"] = 12,
						["xoffset"] = 2,
						["enableIconCooldown"] = true,
						["iconSizeTopLeftCorner"] = 12,
						["yoffset"] = -2,
					},
				},
			},
			["GridStatusAFK"] = {
			},
			["GridStatusHealth"] = {
				["profiles"] = {
					["MayronUIH"] = {
						["unit_health"] = {
							["color"] = {
								["r"] = 0.290196078431373,
								["g"] = 0.290196078431373,
								["b"] = 0.290196078431373,
							},
							["useClassColors"] = false,
							["priority"] = 99,
						},
					},
					["Default"] = {
						["unit_health"] = {
							["useClassColors"] = false,
							["color"] = {
								["b"] = 0.290196078431373,
								["g"] = 0.290196078431373,
								["r"] = 0.290196078431373,
							},
							["priority"] = 99,
						},
					},
				},
			},
			["GridStatusName"] = {
			},
			["GridStatusMouseover"] = {
			},
			["GridStatusTarget"] = {
			},
			["GridIndicatorExtra"] = {
			},
			["GridStatusVoiceComm"] = {
			},
			["GridStatusReadyCheck"] = {
			},
			["DungeonRole"] = {
			},
			["GridStatusGroup"] = {
			},
			["GridStatusRaidIcon"] = {
			},
			["GridFrame"] = {
				["profiles"] = {
					["MayronUIH"] = {
						["fontSize"] = 11,
						["cornerSize"] = 5,
						["enableText2"] = true,
						["frameWidth"] = 61,
						["font"] = "MUI_Font",
						["statusmap"] = {
							["gie_icon_right"] = {
							},
							["gie_icon_bottom"] = {
							},
							["border"] = {
								["player_target"] = false,
							},
							["gie_icon_topright"] = {
							},
							["gie_text_topleft"] = {
							},
							["gie_text_botleft"] = {
							},
							["gie_text_topright"] = {
							},
							["gie_icon_left2"] = {
							},
							["gie_text_bottom"] = {
							},
							["gie_icon_topleft2"] = {
							},
							["text2"] = {
								["alert_afk"] = true,
							},
							["gie_text_right"] = {
							},
							["gie_icon_top"] = {
							},
							["gie_icon_topright2"] = {
							},
							["text"] = {
								["alert_offline"] = false,
								["alert_feignDeath"] = false,
								["unit_healthDeficit"] = false,
								["debuff_Ghost"] = false,
								["alert_heals"] = false,
								["alert_death"] = false,
								["alert_afk"] = false,
							},
							["gie_icon_right2"] = {
							},
							["gie_icon_botleft"] = {
							},
							["gie_icon_left"] = {
							},
							["gie_text_left"] = {
							},
							["gie_icon_botleft2"] = {
							},
							["gie_text_botright"] = {
							},
							["gie_icon_topleft"] = {
								["buff_EarthShield"] = true,
							},
							["gie_text_top"] = {
							},
							["gie_icon_botright2"] = {
							},
							["gie_icon_botright"] = {
							},
						},
						["orientation"] = "HORIZONTAL",
						["iconSize"] = 25,
						["frameHeight"] = 50,
						["textlength"] = 5,
						["texture"] = "MUI_StatusBar",
					},
					["Default"] = {
						["fontSize"] = 11,
						["cornerSize"] = 5,
						["iconSize"] = 25,
						["textlength"] = 5,
						["texture"] = "MUI_StatusBar",
						["frameHeight"] = 50,
						["enableText2"] = true,
						["font"] = "MUI_Font",
						["orientation"] = "HORIZONTAL",
						["frameWidth"] = 61,
						["statusmap"] = {
							["gie_text_topleft"] = {
							},
							["gie_icon_botleft"] = {
							},
							["gie_icon_topright2"] = {
							},
							["gie_text_right"] = {
							},
							["text"] = {
								["alert_offline"] = false,
								["alert_feignDeath"] = false,
								["unit_healthDeficit"] = false,
								["debuff_Ghost"] = false,
								["alert_heals"] = false,
								["alert_death"] = false,
								["alert_afk"] = false,
							},
							["gie_icon_right2"] = {
							},
							["gie_icon_left"] = {
							},
							["gie_icon_botleft2"] = {
							},
							["gie_icon_botright2"] = {
							},
							["gie_icon_bottom"] = {
							},
							["border"] = {
								["player_target"] = false,
							},
							["gie_text_left"] = {
							},
							["gie_icon_botright"] = {
							},
							["gie_text_botleft"] = {
							},
							["gie_icon_left2"] = {
							},
							["gie_text_top"] = {
							},
							["text2"] = {
								["alert_afk"] = true,
							},
							["gie_icon_top"] = {
							},
							["gie_text_bottom"] = {
							},
							["gie_text_botright"] = {
							},
							["gie_icon_right"] = {
							},
							["gie_icon_topright"] = {
							},
							["gie_text_topright"] = {
							},
							["gie_icon_topleft2"] = {
							},
							["gie_icon_topleft"] = {
								["buff_EarthShield"] = true,
							},
						},
					},
				},
			},
			["GridStatusRole"] = {
				["profiles"] = {
					["MayronUIH"] = {
						["role"] = {
							["assignedOpacity"] = 0.2,
							["filter"] = {
								["ranged"] = false,
								["melee"] = false,
							},
						},
					},
					["Default"] = {
						["role"] = {
							["assignedOpacity"] = 0.2,
							["filter"] = {
								["ranged"] = false,
								["melee"] = false,
							},
						},
					},
				},
			},
			["GridLayoutManager"] = {
			},
		},
		["global"] = {
			["debug"] = {
				["GridFrame"] = false,
			},
		},
		["profiles"] = {
			["Default"] = {
				["standaloneOptions"] = true,
				["minimap"] = {
					["hide"] = true,
				},
			},
			["MayronUIH"] = {
				["standaloneOptions"] = true,
				["minimap"] = {
					["hide"] = true,
				},
			},
		},
	};
	for k, v in pairs(settings) do
		GridDB[k] = v;
	end
end