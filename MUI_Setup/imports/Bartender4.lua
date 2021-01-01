local _, setup = ...;

setup.import["Bartender4"] = function()
	local settings = {
    ["namespaces"] = {
      ["StatusTrackingBar"] = {
      },
      ["ActionBars"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["actionbars"] = {
              {
                ["showgrid"] = true,
                ["fadeoutalpha"] = 1,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 68.60000038146973,
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
                  ["always"] = false,
                  ["vehicleui"] = false,
                },
              }, -- [4]
              {
                ["showgrid"] = true,
                ["hidemacrotext"] = true,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 140.8000020980835,
                  ["x"] = -354,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.85,
                },
                ["padding"] = 5.5,
                ["visibility"] = {
                  ["always"] = false,
                  ["vehicle"] = false,
                },
              }, -- [5]
              {
                ["showgrid"] = true,
                ["buttons"] = 8,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 140.8000020980835,
                  ["x"] = 69,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.8500000238418579,
                },
                ["padding"] = 5.5,
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
                  ["y"] = 68.60000038146973,
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
                ["hidemacrotext"] = true,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 104.7000012397766,
                  ["x"] = 69,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.85,
                },
                ["padding"] = 5.5,
                ["visibility"] = {
                  ["always"] = false,
                  ["vehicle"] = false,
                  ["vehicleui"] = false,
                },
              }, -- [9]
              {
                ["showgrid"] = true,
                ["enabled"] = true,
                ["hidemacrotext"] = true,
                ["version"] = 3,
                ["position"] = {
                  ["y"] = 104.7000012397766,
                  ["x"] = -354,
                  ["point"] = "BOTTOM",
                  ["scale"] = 0.85,
                },
                ["padding"] = 5.5,
                ["visibility"] = {
                  ["always"] = false,
                  ["vehicle"] = false,
                  ["vehicleui"] = false,
                },
              }, -- [10]
            },
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
            ["fadeout"] = true,
            ["padding"] = -2,
            ["visibility"] = {
              ["always"] = false,
            },
            ["fadeoutalpha"] = 0,
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
      ["Vehicle"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["version"] = 3,
            ["position"] = {
              ["y"] = 40,
              ["x"] = -350,
              ["point"] = "BOTTOMRIGHT",
              ["growVertical"] = "UP",
              ["growHorizontal"] = "LEFT",
            },
            ["padding"] = 3,
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
      ["StanceBar"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["fadeoutalpha"] = 0.5,
            ["position"] = {
              ["y"] = -1,
              ["x"] = -377.068823285867,
              ["point"] = "BOTTOM",
              ["scale"] = 0.899999976158142,
              ["growVertical"] = "UP",
              ["growHorizontal"] = "LEFT",
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
      ["PetBar"] = {
        ["profiles"] = {
          ["MayronUI"] = {
            ["showgrid"] = true,
            ["rows"] = 2,
            ["fadeoutalpha"] = 0,
            ["position"] = {
              ["y"] = 67.99999237060547,
              ["x"] = 372.4763793945313,
              ["point"] = "BOTTOM",
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