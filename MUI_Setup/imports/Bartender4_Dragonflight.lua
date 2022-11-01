local _, setup = ...;
local _G = _G;
local _, _, _, _, obj = _G.MayronUI:GetCoreComponents();
local pairs = _G.pairs;

setup.import["Bartender4-Dragonflight"] = function()
	local settings = {
    ["namespaces"] = {
      ["StatusTrackingBar"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["position"] = {
              ["y"] = 13,
              ["x"] = -289.5000305175781,
              ["point"] = "TOP",
            },
            ["version"] = 3,
          },
        },
      },
      ["MicroMenu"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["version"] = 3,
            ["position"] = {
              ["y"] = 36,
              ["x"] = -280,
              ["point"] = "BOTTOMRIGHT",
              ["scale"] = 1.3,
            },
            ["fadeoutalpha"] = 0,
            ["visibility"] = {
              ["always"] = false,
            },
            ["padding"] = 0,
          },
        },
      },
      ["QueueStatus"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["position"] = {
              ["y"] = -218,
              ["x"] = -37,
              ["point"] = "TOPRIGHT",
              ["scale"] = 0.8,
            },
            ["version"] = 3,
          },
        },
      },
      ["ActionBars"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["actionbars"] = {
              {
                ["showgrid"] = true,
                ["visibility"] = {
                  ["always"] = false,
                },
                ["fadeoutalpha"] = 1,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 82.25000240802774,
                  ["x"] = -358,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.8500000238418579,
                },
                ["padding"] = -3.6,
                ["hidemacrotext"] = true,
                ["WoW10Layout"] = true,
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
                      ["moonkin"] = 10,
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
                ["showgrid"] = true,
                ["enabled"] = false,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = -1,
                  ["x"] = -223.5499740600586,
                  ["point"] = "TOP",
                  ["scale"] = 0.85,
                },
                ["padding"] = -2,
                ["WoW10Layout"] = true,
              }, -- [2]
              {
                ["showgrid"] = true,
                ["visibility"] = {
                  ["always"] = false,
                  ["vehicleui"] = false,
                },
                ["padding"] = -2.4,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 274,
                  ["x"] = -44,
                  ["point"] = "RIGHT",
                  ["scale"] = 0.9,
                },
                ["rows"] = 12,
                ["hidemacrotext"] = true,
                ["WoW10Layout"] = true,
              }, -- [3]
              {
                ["showgrid"] = true,
                ["visibility"] = {
                  ["always"] = false,
                  ["vehicleui"] = false,
                },
                ["padding"] = -2.4,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 274,
                  ["x"] = -82,
                  ["point"] = "RIGHT",
                  ["scale"] = 0.9,
                },
                ["rows"] = 12,
                ["hidemacrotext"] = true,
                ["WoW10Layout"] = true,
              }, -- [4]
              {
                ["showgrid"] = true,
                ["visibility"] = {
                  ["always"] = false,
                  ["vehicle"] = false,
                },
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 154.7500110387805,
                  ["x"] = -358,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.85,
                },
                ["padding"] = -3.6,
                ["hidemacrotext"] = true,
                ["WoW10Layout"] = true,
              }, -- [5]
              {
                ["showgrid"] = true,
                ["WoW10Layout"] = true,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 118.5000067234041,
                  ["x"] = -358,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.85,
                },
                ["padding"] = -3.6,
                ["visibility"] = {
                  ["always"] = false,
                },
              }, -- [6]
              {
                ["showgrid"] = true,
                ["visibility"] = {
                  ["always"] = false,
                  ["overridebar"] = false,
                  ["vehicleui"] = false,
                },
                ["version"] = 3,
                ["position"] = {
                  ["y"] = -71.58256718722987,
                  ["x"] = 328.2116806538434,
                  ["point"] = "LEFT",
                  ["scale"] = 0.8500000238418579,
                },
                ["hidemacrotext"] = true,
                ["padding"] = -3.6,
                ["WoW10Layout"] = true,
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
                ["version"] = 3,
                ["fadeoutalpha"] = 0,
                ["position"] = {
                  ["y"] = -36.39244168845471,
                  ["x"] = 328.2116806538434,
                  ["point"] = "LEFT",
                  ["scale"] = 0.8500000238418579,
                },
                ["WoW10Layout"] = true,
                ["padding"] = -3.6,
                ["visibility"] = {
                  ["always"] = false,
                },
                ["states"] = {
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
                ["visibility"] = {
                  ["always"] = false,
                  ["vehicle"] = false,
                  ["vehicleui"] = false,
                },
                ["version"] = 3,
                ["position"] = {
                  ["y"] = -1.202368069563818,
                  ["x"] = 328.2116287739591,
                  ["point"] = "LEFT",
                  ["scale"] = 0.8500000238418579,
                },
                ["padding"] = -3.6,
                ["hidemacrotext"] = true,
                ["WoW10Layout"] = true,
              }, -- [9]
              {
                ["showgrid"] = true,
                ["visibility"] = {
                  ["always"] = false,
                  ["vehicle"] = false,
                  ["vehicleui"] = false,
                },
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 33.98765366944281,
                  ["x"] = 328.2116287739591,
                  ["point"] = "LEFT",
                  ["scale"] = 0.8500000238418579,
                },
                ["padding"] = -3.6,
                ["hidemacrotext"] = true,
                ["WoW10Layout"] = true,
              }, -- [10]
              [14] = {
                ["showgrid"] = true,
                ["enabled"] = true,
                ["visibility"] = {
                  ["always"] = false,
                },
                ["buttons"] = 8,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 118.5000067234041,
                  ["x"] = 65,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.85,
                },
                ["padding"] = -3.6,
                ["WoW10Layout"] = true,
              },
              [13] = {
                ["showgrid"] = true,
                ["enabled"] = true,
                ["fadeoutalpha"] = 0,
                ["buttons"] = 8,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 82.25000240802774,
                  ["x"] = 65,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.8500000238418579,
                },
                ["visibility"] = {
                  ["always"] = false,
                },
                ["padding"] = -3.6,
                ["WoW10Layout"] = true,
              },
              [15] = {
                ["showgrid"] = true,
                ["enabled"] = true,
                ["visibility"] = {
                  ["always"] = false,
                },
                ["buttons"] = 8,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 154.7500110387805,
                  ["x"] = 65,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.85,
                },
                ["padding"] = -3.6,
                ["WoW10Layout"] = true,
              },
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
              ["y"] = -164.4622802734375,
              ["x"] = -63.49993896484375,
              ["point"] = "CENTER",
            },
            ["version"] = 3,
          },
        },
      },
      ["XPBar"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["visibility"] = {
              ["always"] = false,
              ["vehicleui"] = false,
            },
            ["version"] = 3,
            ["fadeoutalpha"] = 1,
            ["position"] = {
              ["y"] = -1,
              ["x"] = -363.299957275391,
              ["point"] = "TOP",
              ["scale"] = 0.7,
            },
          },
        },
      },
      ["ZoneAbilityBar"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["version"] = 3,
            ["position"] = {
              ["y"] = 370,
              ["x"] = -32.00001,
              ["point"] = "BOTTOM",
            },
          },
        },
      },
      ["BagBar"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["onebag"] = true,
            ["version"] = 3,
            ["position"] = {
              ["y"] = 73,
              ["x"] = -72,
              ["point"] = "BOTTOMRIGHT",
              ["scale"] = 0.9,
            },
            ["padding"] = -2,
          },
        },
      },
      ["MultiCast"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["enabled"] = true,
            ["version"] = 3,
            ["position"] = {
              ["y"] = 40,
              ["x"] = 365,
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
      ["Vehicle"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["version"] = 3,
            ["position"] = {
              ["y"] = 34,
              ["x"] = -315,
              ["point"] = "BOTTOMRIGHT",
              ["growVertical"] = "UP",
              ["growHorizontal"] = "LEFT",
            },
            ["padding"] = 3,
          },
        },
      },
      ["APBar"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["version"] = 3,
            ["position"] = {
              ["y"] = -1,
              ["x"] = -363.300042724609,
              ["point"] = "TOP",
              ["scale"] = 0.7,
            },
          },
        },
      },
      ["StanceBar"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["version"] = 3,
            ["fadeoutalpha"] = 0.5,
            ["padding"] = -2.5,
            ["visibility"] = {
              ["stance"] = {
                false, -- [1]
              },
            },
            ["position"] = {
              ["y"] = -2,
              ["x"] = -376,
              ["point"] = "BOTTOM",
              ["scale"] = 1.2,
              ["growVertical"] = "UP",
              ["growHorizontal"] = "LEFT",
            },
          },
        },
      },
      ["PetBar"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["showgrid"] = true,
            ["rows"] = 2,
            ["version"] = 3,
            ["position"] = {
              ["y"] = 72,
              ["x"] = 371.2181321166427,
              ["point"] = "BOTTOM",
              ["scale"] = 1.200000047683716,
            },
            ["fadeoutalpha"] = 0,
            ["padding"] = -3.6,
            ["visibility"] = {
              ["always"] = false,
            },
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
        ["buttonlock"] = false,
      },
    },
	};

  -- This fixes the bartender MUI settings to work with the injected settings.
  if (obj:IsTable(_G.MayronUIdb) and obj:IsTable(_G.MayronUIdb.profiles)) then
    for _, profile in pairs(_G.MayronUIdb.profiles) do
      if (obj:IsTable(profile)) then
        if (obj:IsTable(profile.actionBarPanel)) then
          profile.actionBarPanel.bartender = nil;
        end

        if (obj:IsTable(profile.sidebar)) then
          profile.sidebar.bartender = nil;
        end
      end
    end
  end

	for k, v in pairs(settings) do
    _G.Bartender4DB[k] = v;
	end
end