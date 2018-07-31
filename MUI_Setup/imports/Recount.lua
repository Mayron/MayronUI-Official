local _, setup = ...;

setup.import["Recount"] = function()
    local settings = {
		["MayronUI"] = {
			["MainWindow"] = {
				["Buttons"] = {
					["LeftButton"] = false,
					["RightButton"] = false,
				},
				["ShowScrollbar"] = false,
				["Position"] = {
					["y"] = -447.071357727051,
					["h"] = 199,
					["w"] = 293.000183105469,
					["x"] = 826.738098144531,
				},
				["RowHeight"] = 15,
				["BarText"] = {
					["NumFormat"] = 3,
					["Percent"] = false,
				},
			},
			["ReportLines"] = 5.37447643280029,
			["ZoneFilters"] = {
				["pvp"] = false,
			},
			["MainWindowHeight"] = 199.000015258789,
			["Colors"] = {
				["Window"] = {
					["Background"] = {
						["a"] = 0,
					},
					["Title"] = {
						["a"] = 0,
					},
				},
				["Title"] = {
					["r"] = 0,
				},
				["Background"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0,
				},
				["Bar"] = {
					["Bar Text"] = {
						["a"] = 1,
					},
					["Total Bar"] = {
						["a"] = 1,
					},
				},
			},
			["Filters"] = {
				["Data"] = {
					["Ungrouped"] = true,
				},
			},
			["BarTextColorSwap"] = false,
			["BarTexture"] = "MUI_StatusBar",
			["CurDataSet"] = "LastFightData",
			["Font"] = "MUI_Font",
			["LastInstanceName"] = "Scarlet Monastery",
			["MainWindowWidth"] = 293.000213623047,
		},
    };
    for k, v in pairs(settings) do
        RecountDB.profiles[k] = v;
    end
end