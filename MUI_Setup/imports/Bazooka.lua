local _, setup = ...;

setup.import["Bazooka"] = function()
	local settings = {
		["namespaces"] = {
			["LibDualSpec-1.0"] = {
			},
		},
		["profiles"] = {
			["Default"] = {
				["plugins"] = {
					["data source"] = {
						["Details"] = {
							["pos"] = 2,
						},
						["DetailsStreamer"] = {
							["pos"] = 3,
						},
						["WeakAuras"] = {
							["pos"] = 4,
						},
						["BugSack"] = {
							["pos"] = 1,
						},
					},
					["launcher"] = {
						["Grid"] = {
							["pos"] = 3,
						},
						["AskMrRobot"] = {
							["pos"] = 4,
						},
						["Bartender4"] = {
							["pos"] = 2,
						},
						["Masque"] = {
							["pos"] = 6,
						},
						["BagnonLauncher"] = {
							["pos"] = 5,
						},
						["Rematch"] = {
							["pos"] = 7,
						},
					},
				},
				["bars"] = {
					{
						["bgInset"] = 4,
						["pos"] = 1,
					}, -- [1]
				},
			},
			["MayronUI"] = {
				["plugins"] = {
					["launcher"] = {
						["Bazooka"] = {
							["bar"] = 2,
						},
						["Masque"] = {
							["pos"] = 7,
							["bar"] = 2,
						},
						["AskMrRobot"] = {
							["pos"] = 5,
							["bar"] = 6,
						},
						["BagnonLauncher"] = {
							["enabled"] = false,
							["pos"] = 6,
						},
						["Rematch"] = {
							["pos"] = 4,
							["bar"] = 3,
						},
						["Bartender4"] = {
							["pos"] = 2,
							["bar"] = 2,
						},
						["Grid"] = {
							["pos"] = 3,
							["bar"] = 2,
						},
					},
					["data source"] = {
						["Broker_ProfessionsMenu"] = {
							["bar"] = 2,
							["showText"] = false,
							["pos"] = 6,
						},
						["Details"] = {
							["pos"] = 2,
							["bar"] = 2,
						},
						["DetailsStreamer"] = {
							["pos"] = 4,
							["bar"] = 2,
						},
						["WeakAuras"] = {
							["showValue"] = false,
							["showText"] = false,
							["pos"] = 5,
						},
						["BugSack"] = {
							["area"] = "left",
							["stripColors"] = false,
							["showValue"] = false,
							["pos"] = 1,
						},
					},
				},
				["bars"] = {
					{
						["y"] = -4,
						["x"] = -3,
						["point"] = "TOPRIGHT",
						["relPoint"] = "TOPRIGHT",
						["bgEnabled"] = false,
						["frameWidth"] = 200,
						["bgInset"] = 4,
						["pos"] = 0,
						["bgColor"] = {
							["g"] = 1,
						},
						["frameHeight"] = 20.0000171661377,
						["attach"] = "none",
					}, -- [1]
					{
						["point"] = "BOTTOMRIGHT",
						["bgInset"] = 4,
						["y"] = 0.6,
						["x"] = -310,
						["bgColor"] = {
							["a"] = 0.75,
						},
						["relPoint"] = "BOTTOMRIGHT",
						["frameHeight"] = 20.0000171661377,
						["attach"] = "none",
						["frameWidth"] = 290,
						["pos"] = 0,
					}, -- [2]
					{
						["point"] = "TOPLEFT",
						["bgEnabled"] = false,
						["bgInset"] = 4,
						["y"] = -220,
						["x"] = -3,
						["bgColor"] = {
							["g"] = 1,
						},
						["relPoint"] = "TOPLEFT",
						["frameHeight"] = 20.0000171661377,
						["frameWidth"] = 30,
						["pos"] = 0,
					}, -- [3]
					{
						["point"] = "TOPLEFT",
						["bgEnabled"] = false,
						["bgInset"] = 4,
						["y"] = -240,
						["x"] = -3,
						["bgColor"] = {
							["g"] = 1,
						},
						["relPoint"] = "TOPLEFT",
						["frameHeight"] = 20.0000171661377,
						["frameWidth"] = 30,
						["pos"] = 0,
					}, -- [4]
					{
						["point"] = "TOPLEFT",
						["bgEnabled"] = false,
						["bgInset"] = 4,
						["y"] = -260,
						["x"] = -3,
						["bgColor"] = {
							["g"] = 1,
						},
						["relPoint"] = "TOPLEFT",
						["frameHeight"] = 20.0000171661377,
						["frameWidth"] = 30,
						["pos"] = 0,
					}, -- [5]
					{
						["point"] = "TOPLEFT",
						["bgEnabled"] = false,
						["bgInset"] = 4,
						["y"] = -280,
						["x"] = -3,
						["bgColor"] = {
							["g"] = 1,
						},
						["relPoint"] = "TOPLEFT",
						["frameHeight"] = 20.0000171661377,
						["frameWidth"] = 30,
						["pos"] = 0,
					}, -- [6]
				},
				["numBars"] = 6,
			},
		},
	};
	for k, v in pairs(settings) do
		BazookaDB[k] = v;
	end
end