local _, setup = ...;
local _G = _G;
local _, _, _, _, obj = _G.MayronUI:GetCoreComponents();
local pairs = _G.pairs;

setup.import["Bartender4"] = function()
	local settings = {
    ["namespaces"] = {
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
      ["ActionBars"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["actionbars"] = {
              {
                ["showgrid"] = true,
                ["version"] = 3,
                ["fadeoutalpha"] = 1,
                ["position"] = {
                  ["y"] = 68.60000038146973,
                  ["x"] = -354,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.850000023841858,
                },
                ["hidemacrotext"] = true,
                ["padding"] = 5.5,
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
                ["padding"] = 5.5,
                ["alpha"] = 0,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 265,
                  ["x"] = -41,
                  ["point"] = "RIGHT",
                  ["scale"] = 0.9,
                },
                ["hidemacrotext"] = true,
                ["visibility"] = {
                  ["always"] = true,
                  ["vehicleui"] = false,
                },
              }, -- [3]
              {
                ["showgrid"] = true,
                ["rows"] = 12,
                ["padding"] = 5.5,
                ["alpha"] = 0,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 265,
                  ["x"] = -78,
                  ["point"] = "RIGHT",
                  ["scale"] = 0.899999976158142,
                },
                ["hidemacrotext"] = true,
                ["visibility"] = {
                  ["always"] = true,
                  ["vehicleui"] = false,
                },
              }, -- [4]
              {
                ["showgrid"] = true,
                ["hidemacrotext"] = true,
                ["alpha"] = 0,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 140.8000020980835,
                  ["x"] = -354,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.85,
                },
                ["padding"] = 5.5,
                ["visibility"] = {
                  ["always"] = true,
                  ["vehicle"] = false,
                },
              }, -- [5]
              {
                ["showgrid"] = true,
                ["buttons"] = 8,
                ["alpha"] = 0,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 140.8000020980835,
                  ["x"] = 69,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.8500000238418579,
                },
                ["padding"] = 5.5,
                ["visibility"] = {
                  ["always"] = true,
                },
              }, -- [6]
              {
                ["showgrid"] = true,
                ["enabled"] = true,
                ["buttons"] = 8,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 68.60000038146973,
                  ["x"] = 69,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.850000023841858,
                },
                ["padding"] = 5.5,
                ["hidemacrotext"] = true,
                ["visibility"] = {
                  ["always"] = false,
                  ["overridebar"] = false,
                  ["vehicleui"] = false,
                },
                ["states"] = {
                  ["enabled"] = true,
                  ["stance"] = {
                    ["MONK"] = {
                      ["ox"] = 8,
                      ["serpent"] = 8,
                      ["tiger"] = 8,
                      ["crane"] = 8,
                    },
                    ["ROGUE"] = {
                      ["stealth"] = 0,
                    },
                  },
                },
              }, -- [7]
              {
                ["showgrid"] = true,
                ["rows"] = 4,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = -190.469005458428,
                  ["x"] = -54.40003520634491,
                  ["point"] = "CENTER",
                  ["scale"] = 0.8500000238418579,
                },
                ["padding"] = 5.5,
                ["visibility"] = {
                  ["always"] = true,
                },
                ["states"] = {
                  ["enabled"] = true,
                  ["stance"] = {
                    ["MONK"] = {
                      ["serpent"] = 1,
                      ["tiger"] = 1,
                      ["ox"] = 1,
                    },
                  },
                },
              }, -- [8]
              {
                ["showgrid"] = true,
                ["enabled"] = true,
                ["buttons"] = 8,
                ["padding"] = 5.5,
                ["alpha"] = 0,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 104.7000012397766,
                  ["x"] = 69,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.85,
                },
                ["hidemacrotext"] = true,
                ["visibility"] = {
                  ["always"] = true,
                  ["vehicle"] = false,
                  ["vehicleui"] = false,
                },
              }, -- [9]
              {
                ["showgrid"] = true,
                ["enabled"] = true,
                ["hidemacrotext"] = true,
                ["alpha"] = 0,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 104.7000012397766,
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
            ["version"] = 3,
            ["position"] = {
              ["y"] = -164.4622802734375,
              ["x"] = -63.49993896484375,
              ["point"] = "CENTER",
            },
          },
        },
      },
      ["MicroMenu"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["version"] = 3,
            ["position"] = {
              ["y"] = 38,
              ["x"] = -292,
              ["point"] = "BOTTOMRIGHT",
              ["scale"] = 1,
            },
            ["fadeoutalpha"] = 0,
            ["padding"] = -2,
            ["visibility"] = {
              ["always"] = false,
            },
            ["fadeout"] = true,
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
      ["StanceBar"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["fadeoutalpha"] = 0.5,
            ["position"] = {
              ["y"] = -1,
              ["x"] = -377.068823285867,
              ["point"] = "BOTTOM",
              ["scale"] = 0.899999976158142,
              ["growHorizontal"] = "LEFT",
              ["growVertical"] = "UP",
            },
            ["version"] = 3,
            ["padding"] = 3,
            ["visibility"] = {
              ["stance"] = {
                false, -- [1]
              },
            },
          },
        },
      },
      ["BagBar"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["enabled"] = false,
            ["onebag"] = true,
            ["version"] = 3,
            ["position"] = {
              ["y"] = 41.75,
              ["x"] = 463.5,
              ["point"] = "BOTTOM",
            },
          },
        },
      },
      ["Vehicle"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["version"] = 3,
            ["position"] = {
              ["y"] = 40,
              ["x"] = -350,
              ["point"] = "BOTTOMRIGHT",
              ["growHorizontal"] = "LEFT",
              ["growVertical"] = "UP",
            },
            ["padding"] = 3,
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
              ["y"] = 60.5,
              ["x"] = 374,
              ["point"] = "BOTTOM",
              ["scale"] = 0.8999999761581421,
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