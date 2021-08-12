local _, setup = ...;

setup.import["ShadowedUnitFrames"] = function()
	local settings = {		
    ["global"] = {
      ["infoID"] = 3,
    },
    ["profiles"] = {
      ["Default"] = {
        ["wowBuild"] = 20501,
        ["auras"] = {
          ["borderType"] = "dark",
        },
        ["healthColors"] = {
          ["aggro"] = {
            ["a"] = 1,
            ["b"] = 0,
            ["g"] = 0,
            ["r"] = 0.749019607843137,
          },
          ["static"] = {
            ["a"] = 1,
            ["r"] = 0.0901960784313726,
            ["g"] = 0.0901960784313726,
            ["b"] = 0.0901960784313726,
          },
          ["neutral"] = {
            ["a"] = 1,
            ["r"] = 1,
            ["g"] = 0.843137254901961,
            ["b"] = 0.2,
          },
          ["enemyUnattack"] = {
            ["r"] = 0.6,
            ["g"] = 0.2,
            ["b"] = 0.2,
          },
          ["friendly"] = {
            ["a"] = 1,
            ["r"] = 0.2274509803921569,
            ["g"] = 0.6392156862745098,
            ["b"] = 0.2078431372549019,
          },
          ["healAbsorb"] = {
            ["r"] = 0.68,
            ["g"] = 0.47,
            ["b"] = 1,
          },
          ["yellow"] = {
            ["a"] = 1,
            ["r"] = 1,
            ["g"] = 0.8901960784313725,
            ["b"] = 0.2274509803921569,
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
            ["r"] = 0.2549019607843137,
            ["g"] = 0.9647058823529412,
            ["b"] = 0.1686274509803922,
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
            ["r"] = 1,
            ["g"] = 0.2,
            ["b"] = 0.2,
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
          ["indicators"] = {
            ["tr"] = {
              ["height"] = 12,
              ["width"] = 12,
            },
            ["tl"] = {
              ["height"] = 12,
              ["y"] = -3,
              ["width"] = 12,
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
            ["Lifebloom"] = "{indicator = '', group = \"Druid\", priority = 10, r = 0.07, g = 1.0, b = 0.01}",
            ["Beacon of Light"] = "{r=0;g=0;indicator=\"tl\";b=0;group=\"Paladin\";priority=0;icon=true;iconTexture=\"InterfaceIconsAbility_Paladin_BeaconofLight\";}",
            ["Regrowth"] = "{indicator = '', group = \"Druid\", priority = 10, r = 0.50, g = 1.0, b = 0.63}",
            ["Rejuvenation"] = "{indicator = '', group = \"Druid\", priority = 10, r = 0.66, g = 0.66, b = 1.0}",
            ["Focus Magic"] = "{indicator = '', group = \"Mage\", priority = 10, r = 0.67, g = 0.76, b = 1.0}",
            ["Earth Shield"] = "{indicator = '', group = \"Shaman\", priority = 10, r = 0.26, g = 1.0, b = 0.26}",
            ["Mark of the Wild"] = "{indicator = '', group = \"Druid\", priority = 10, r = 1.0, g = 0.33, b = 0.90}",
            ["Riptide"] = "{indicator = '', group = \"Shaman\", priority = 10, r = 0.30, g = 0.24, b = 1.0}",
            ["Wild Growth"] = "{indicator = '', group = \"Druid\", priority = 10, r = 0.51, g = 0.72, b = 0.77}",
            ["Power Word: Shield"] = "{indicator = '', group = \"Priest\", priority = 10, r = 0.55, g = 0.69, b = 1.0}",
            ["Soulstone Resurrection"] = "{indicator = '', group = \"Warlock\", priority = 10, r = 0.42, g = 0.21, b = 0.65}",
            ["Power Word: Fortitude"] = "{indicator = '', group = \"Priest\", priority = 10, r = 0.58, g = 1.0, b = 0.50}",
            ["Hand of Sacrifice"] = "{icon=true;b=0;priority=0;r=0;group=\"Paladin\";indicator=\"tr\";g=0;iconTexture=\"Interface\\Icons\\Spell_Holy_SealOfSacrifice\";}",
            ["Shadow Protection"] = "{indicator = '', group = \"Priest\", priority = 10, r = 0.60, g = 0.18, b = 1.0}",
            ["Arcane Brilliance"] = "{indicator = '', group = \"Mage\", priority = 10, r = 0.10, g = 0.68, b = 0.88}",
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
            ["relativePoint"] = "TOPRIGHT",
            ["anchorTo"] = "#SUFUnittarget",
            ["y"] = 54,
          },
          ["maintanktargettarget"] = {
            ["anchorPoint"] = "RT",
            ["x"] = 150,
            ["anchorTo"] = "$parent",
          },
          ["focus"] = {
            ["y"] = 80,
            ["anchorTo"] = "#SUFUnittargettarget",
            ["point"] = "BOTTOM",
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
            ["top"] = 31.97764189621989,
            ["x"] = 1.399999976158142,
            ["point"] = "TOPLEFT",
            ["bottom"] = 1.177643588991785,
            ["relativePoint"] = "BOTTOMLEFT",
            ["y"] = 32.19999945163727,
          },
          ["battlegroundtarget"] = {
            ["anchorPoint"] = "LT",
            ["x"] = -2,
            ["anchorTo"] = "$parent",
          },
          ["boss"] = {
            ["y"] = 54,
            ["x"] = -34,
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
            ["anchorPoint"] = "LT",
            ["x"] = -2,
            ["anchorTo"] = "$parent",
          },
          ["battlegroundpet"] = {
            ["anchorPoint"] = "RB",
            ["anchorTo"] = "$parent",
          },
          ["pettarget"] = {
            ["anchorPoint"] = "C",
          },
          ["pet"] = {
            ["y"] = 12,
            ["anchorTo"] = "#SUFUnittargettarget",
            ["point"] = "BOTTOM",
            ["relativePoint"] = "TOP",
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
          ["targettarget"] = {
            ["y"] = -100,
            ["x"] = 100,
            ["point"] = "TOP",
            ["relativePoint"] = "TOP",
            ["anchorTo"] = "UIParent",
          },
          ["focustarget"] = {
            ["y"] = 44.3799992442131,
            ["point"] = "BOTTOM",
            ["relativePoint"] = "BOTTOM",
          },
          ["arena"] = {
            ["top"] = 429.660069587229,
            ["x"] = -34,
            ["point"] = "BOTTOMRIGHT",
            ["bottom"] = 135.660106637476,
            ["anchorTo"] = "#SUFUnitplayer",
            ["relativePoint"] = "TOPLEFT",
            ["y"] = 54,
          },
          ["partytargettarget"] = {
            ["anchorPoint"] = "RT",
            ["anchorTo"] = "$parent",
          },
          ["battleground"] = {
            ["y"] = 54,
            ["x"] = -35,
            ["point"] = "BOTTOMRIGHT",
            ["relativePoint"] = "TOPLEFT",
            ["bottom"] = 520.911246011747,
            ["anchorTo"] = "#SUFUnitplayer",
            ["top"] = 751.911327527057,
          },
        },
        ["revision"] = 61,
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
        ["powerColors"] = {
          ["PAIN"] = {
            ["b"] = 0,
            ["g"] = 0,
            ["r"] = 1,
          },
          ["ECLIPSE_FULL"] = {
            ["r"] = 0,
            ["g"] = 0.32,
            ["b"] = 0.43,
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
          ["POWER_TYPE_FEL_ENERGY"] = {
            ["b"] = 0,
            ["g"] = 0.98,
            ["r"] = 0.878,
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
            ["r"] = 0.2156862745098039,
            ["g"] = 0.5490196078431373,
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
          ["ECLIPSE_MOON"] = {
            ["b"] = 0.9,
            ["g"] = 0.52,
            ["r"] = 0.3,
          },
          ["ECLIPSE_SUN"] = {
            ["b"] = 0,
            ["g"] = 1,
            ["r"] = 1,
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
          ["MUSHROOMS"] = {
            ["r"] = 0.2,
            ["g"] = 0.9,
            ["b"] = 0.2,
          },
          ["STATUE"] = {
            ["r"] = 0.35,
            ["g"] = 0.45,
            ["b"] = 0.6,
          },
          ["SHADOWORBS"] = {
            ["r"] = 0.58,
            ["g"] = 0.51,
            ["b"] = 0.79,
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
          ["STAGGER_GREEN"] = {
            ["r"] = 0.52,
            ["g"] = 1,
            ["b"] = 0.52,
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
                ["enabled"] = true,
                ["maxRows"] = 1,
                ["anchorPoint"] = "BR",
                ["perRow"] = 7,
                ["x"] = -1,
                ["y"] = -2,
                ["size"] = 16,
              },
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
              ["order"] = 20,
              ["colorType"] = "type",
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
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.8,
              }, -- [8]
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
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
                ["anchorPoint"] = "BL",
                ["anchorTo"] = "$parent",
              },
              ["height"] = 0.5,
            },
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
            ["attribAnchorPoint"] = "RIGHT",
            ["attribPoint"] = "TOP",
          },
          ["mainassisttarget"] = {
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
                ["y"] = 0,
                ["anchorTo"] = "$parent",
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
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
            ["auras"] = {
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
              ["height"] = 1,
              ["order"] = 0,
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["height"] = 1.2,
              ["reactionType"] = "npc",
            },
            ["height"] = 40,
            ["width"] = 150,
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
              ["background"] = true,
              ["height"] = 1,
            },
            ["highlight"] = {
              ["size"] = 10,
            },
          },
          ["targettargettarget"] = {
            ["enabled"] = false,
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
            ["width"] = 80,
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
            },
            ["range"] = {
              ["height"] = 0.5,
            },
            ["auras"] = {
              ["height"] = 0.5,
              ["debuffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
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
                ["y"] = 0,
                ["anchorTo"] = "$parent",
              },
              ["height"] = 0.5,
            },
            ["height"] = 30,
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
              ["background"] = true,
              ["height"] = 0.6,
            },
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
            },
          },
          ["partytarget"] = {
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
                ["y"] = 0,
                ["anchorTo"] = "$parent",
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
              ["height"] = 1,
              ["order"] = 0,
            },
            ["width"] = 90,
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
            },
            ["range"] = {
              ["height"] = 0.5,
            },
            ["auras"] = {
              ["height"] = 0.5,
              ["debuffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
            ["fader"] = {
              ["height"] = 0.5,
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
            ["height"] = 25,
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
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
          },
          ["arenatargettarget"] = {
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
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["anchorPoint"] = "BL",
                ["x"] = 0,
                ["y"] = 0,
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
              ["reactionType"] = "none",
              ["order"] = 0,
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["reactionType"] = "npc",
              ["height"] = 1.2,
            },
            ["height"] = 25,
            ["width"] = 90,
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
              ["background"] = true,
              ["height"] = 0.6,
            },
            ["highlight"] = {
              ["size"] = 10,
            },
          },
          ["raid"] = {
            ["highlight"] = {
              ["debuff"] = true,
              ["aggro"] = true,
              ["mouseover"] = false,
              ["height"] = 0.5,
              ["attention"] = false,
              ["alpha"] = 1,
              ["size"] = 10,
            },
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
                ["y"] = 0,
                ["anchorTo"] = "$parent",
              },
              ["ready"] = {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["size"] = 22,
              },
            },
            ["portrait"] = {
              ["type"] = "3D",
              ["fullBefore"] = 0,
              ["alignment"] = "LEFT",
              ["fullAfter"] = 100,
              ["order"] = 15,
              ["isBar"] = false,
              ["height"] = 0.5,
              ["width"] = 0.22,
            },
            ["groupsPerRow"] = 8,
            ["height"] = 44,
            ["auraIndicators"] = {
              ["enabled"] = true,
              ["height"] = 0.5,
            },
            ["range"] = {
              ["enabled"] = true,
              ["oorAlpha"] = 0.6,
              ["height"] = 0.5,
            },
            ["showParty"] = false,
            ["castBar"] = {
              ["time"] = {
                ["enabled"] = true,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
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
            ["altPowerBar"] = {
              ["order"] = 100,
              ["background"] = true,
              ["height"] = 0.4,
              ["enabled"] = false,
            },
            ["frameSplit"] = true,
            ["groupSpacing"] = -34,
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
                ["show"] = {
                  ["misc"] = false,
                  ["relevant"] = false,
                  ["raid"] = false,
                },
                ["maxRows"] = 1,
                ["anchorPoint"] = "TR",
                ["y"] = -11,
                ["x"] = -2,
                ["size"] = 10,
              },
            },
            ["incAbsorb"] = {
              ["enabled"] = false,
              ["height"] = 0.5,
            },
            ["powerBar"] = {
              ["colorType"] = "type",
              ["reverse"] = false,
              ["order"] = 20,
              ["background"] = false,
              ["invert"] = false,
              ["height"] = 0.2,
            },
            ["enabled"] = true,
            ["offset"] = 2,
            ["text"] = {
              {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["width"] = 1,
                ["text"] = "[colorname]",
                ["y"] = 2,
                ["size"] = -1,
              }, -- [1]
              {
                ["y"] = -6,
                ["text"] = "",
                ["x"] = 0,
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["y"] = -10,
                ["name"] = "AFK",
                ["anchorTo"] = "$healthBar",
                ["text"] = "[afk][status]",
                ["width"] = 1,
                ["size"] = -1,
              }, -- [8]
            },
            ["healthBar"] = {
              ["colorType"] = "static",
              ["height"] = 2,
              ["reactionType"] = "none",
              ["background"] = true,
              ["invert"] = false,
              ["order"] = 10,
            },
            ["hideSemiRaid"] = false,
            ["attribAnchorPoint"] = "BOTTOM",
            ["unitsPerColumn"] = 25,
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
            },
            ["width"] = 65,
            ["maxColumns"] = 8,
            ["sortOrder"] = "DESC",
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
              ["enabled"] = false,
            },
            ["columnSpacing"] = 2,
            ["attribPoint"] = "LEFT",
          },
          ["arenapet"] = {
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
            },
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["height"] = 1.2,
              ["reactionType"] = "npc",
            },
            ["auras"] = {
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
            ["indicators"] = {
              ["raidTarget"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["anchorPoint"] = "C",
                ["size"] = 20,
              },
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["width"] = 90,
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
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
              ["background"] = true,
              ["height"] = 0.6,
            },
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
            },
          },
          ["mainassisttargettarget"] = {
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
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["anchorPoint"] = "BL",
                ["x"] = 0,
                ["y"] = 0,
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
              ["reactionType"] = "none",
              ["order"] = 0,
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["reactionType"] = "npc",
              ["height"] = 1.2,
            },
            ["height"] = 40,
            ["width"] = 150,
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
              ["background"] = true,
              ["height"] = 1,
            },
            ["highlight"] = {
              ["size"] = 10,
            },
          },
          ["party"] = {
            ["highlight"] = {
              ["aggro"] = true,
              ["height"] = 0.5,
              ["alpha"] = 1,
              ["size"] = 10,
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
                ["perRow"] = 2,
                ["enlarge"] = {
                  ["SELF"] = false,
                },
                ["y"] = 1,
                ["x"] = -2,
                ["enabled"] = true,
                ["show"] = {
                  ["misc"] = false,
                },
                ["maxRows"] = 5,
                ["anchorPoint"] = "LB",
                ["size"] = 18,
              },
              ["buffs"] = {
                ["enabled"] = true,
                ["maxRows"] = 5,
                ["show"] = {
                  ["misc"] = false,
                  ["relevant"] = false,
                  ["raid"] = false,
                },
                ["x"] = 2,
                ["perRow"] = 2,
                ["anchorPoint"] = "RB",
                ["y"] = 1,
                ["size"] = 18,
              },
            },
            ["castBar"] = {
              ["order"] = 60,
              ["name"] = {
                ["y"] = 0,
                ["x"] = 1,
                ["anchorTo"] = "$parent",
                ["size"] = 0,
                ["enabled"] = true,
                ["anchorPoint"] = "CLI",
                ["rank"] = true,
              },
              ["autoHide"] = true,
              ["height"] = 0.6,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["time"] = {
                ["enabled"] = true,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["anchorPoint"] = "CRI",
                ["size"] = 0,
              },
            },
            ["indicators"] = {
              ["raidTarget"] = {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 4,
                ["size"] = 23,
              },
              ["lfdRole"] = {
                ["anchorPoint"] = "LT",
                ["x"] = 14,
                ["anchorTo"] = "$parent",
                ["y"] = -1,
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
              ["pvp"] = {
                ["y"] = 6,
                ["x"] = 72,
                ["anchorTo"] = "$parent",
                ["anchorPoint"] = "LT",
                ["enabled"] = false,
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
                ["anchorPoint"] = "BL",
                ["anchorTo"] = "$parent",
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
            ["columnSpacing"] = -30,
            ["hideAnyRaid"] = true,
            ["height"] = 40,
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["powerBar"] = {
              ["predicted"] = true,
              ["colorType"] = "type",
              ["order"] = 20,
              ["height"] = 0.2,
              ["background"] = false,
              ["invert"] = false,
              ["onlyMana"] = false,
            },
            ["attribAnchorPoint"] = "LEFT",
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
            ["altPowerBar"] = {
              ["order"] = 100,
              ["background"] = true,
              ["height"] = 0.4,
              ["enabled"] = false,
            },
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
            },
            ["text"] = {
              {
                ["y"] = -4,
                ["text"] = "[classcolor][name][close( )][levelcolor][close][( )afk][( )status]",
                ["width"] = 1,
              }, -- [1]
              {
                ["text"] = "[hp:color][perhp]",
                ["width"] = 1,
              }, -- [2]
              {
                ["y"] = 5,
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
                ["anchorPoint"] = "CRI",
                ["x"] = -2,
                ["name"] = "Right text 2",
                ["anchorTo"] = "$healthBar",
                ["y"] = 8,
                ["width"] = 2,
              }, -- [7]
              {
                ["anchorPoint"] = "BL",
                ["x"] = 4,
                ["name"] = "AFK",
                ["anchorTo"] = "$healthBar",
                ["width"] = 1,
                ["y"] = 12,
                ["size"] = -1,
              }, -- [8]
            },
            ["width"] = 212,
            ["unitsPerColumn"] = 5,
            ["incAbsorb"] = {
              ["enabled"] = false,
              ["height"] = 0.5,
            },
            ["fader"] = {
              ["height"] = 0.5,
              ["inactiveAlpha"] = 1,
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
            ["portrait"] = {
              ["type"] = "3D",
              ["fullBefore"] = 0,
              ["alignment"] = "LEFT",
              ["fullAfter"] = 50,
              ["order"] = 15,
              ["isBar"] = false,
              ["height"] = 0.5,
              ["width"] = 0.2,
            },
            ["attribPoint"] = "TOP",
          },
          ["maintanktargettarget"] = {
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
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["anchorPoint"] = "BL",
                ["x"] = 0,
                ["y"] = 0,
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
              ["reactionType"] = "none",
              ["order"] = 0,
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["reactionType"] = "npc",
              ["height"] = 1.2,
            },
            ["height"] = 40,
            ["width"] = 150,
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
              ["background"] = true,
              ["height"] = 1,
            },
            ["highlight"] = {
              ["size"] = 10,
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
                ["anchorPoint"] = "BL",
                ["anchorTo"] = "$parent",
              },
              ["status"] = {
                ["anchorPoint"] = "RC",
                ["x"] = -21,
                ["anchorTo"] = "$parent",
                ["y"] = 9,
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
                ["perRow"] = 9,
                ["anchorOn"] = false,
                ["y"] = -2,
                ["x"] = 0,
                ["enabled"] = true,
                ["anchorPoint"] = "BR",
                ["maxRows"] = 2,
                ["show"] = {
                  ["misc"] = false,
                  ["raid"] = false,
                },
                ["size"] = 20,
              },
              ["buffs"] = {
                ["perRow"] = 9,
                ["anchorOn"] = false,
                ["y"] = 2,
                ["maxRows"] = 2,
                ["anchorPoint"] = "TL",
                ["enabled"] = true,
                ["x"] = 0,
                ["show"] = {
                  ["misc"] = false,
                  ["raid"] = false,
                },
                ["size"] = 20,
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
              ["predicted"] = true,
              ["colorType"] = "type",
              ["height"] = 0.3,
              ["background"] = false,
              ["invert"] = false,
              ["order"] = 25,
            },
            ["healthBar"] = {
              ["colorType"] = "static",
              ["reactionType"] = "none",
              ["height"] = 1.9,
              ["background"] = true,
              ["invert"] = false,
              ["order"] = 0,
            },
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
            },
            ["text"] = {
              {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["width"] = 10,
                ["text"] = "[classcolor][abbrev:name]",
                ["y"] = 1,
                ["size"] = 1,
              }, -- [1]
              {
                ["anchorPoint"] = "TRI",
                ["x"] = 0,
                ["text"] = "",
                ["y"] = 14,
                ["width"] = 10,
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
                ["anchorPoint"] = "CRI",
                ["text"] = "[perpp][( )hp:color][( )perhp]",
                ["x"] = -3,
              }, -- [5]
              nil, -- [6]
              {
                ["anchorPoint"] = "TRI",
                ["name"] = "Right text 2",
                ["anchorTo"] = "$healthBar",
                ["y"] = 26,
                ["width"] = 10,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
            },
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["height"] = 0.8,
              ["background"] = true,
              ["backgroundColor"] = {
                ["r"] = 0.0980392156862745,
                ["g"] = 0.0980392156862745,
                ["b"] = 0.0980392156862745,
              },
              ["order"] = 70,
            },
            ["width"] = 153,
            ["altPowerBar"] = {
              ["order"] = 100,
              ["background"] = false,
              ["height"] = 0.4,
            },
            ["height"] = 36,
            ["fader"] = {
              ["inactiveAlpha"] = 1,
              ["height"] = 0.5,
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
              ["type"] = "3D",
              ["fullBefore"] = 0,
              ["alignment"] = "RIGHT",
              ["fullAfter"] = 100,
              ["order"] = 0,
              ["isBar"] = true,
              ["height"] = 2.3,
              ["width"] = 0.16,
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
                ["y"] = 0,
                ["anchorTo"] = "$parent",
              },
              ["status"] = {
                ["y"] = 9,
                ["x"] = -21,
                ["anchorTo"] = "$parent",
                ["anchorPoint"] = "RC",
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
                ["anchorPoint"] = "RT",
                ["maxRows"] = 3,
                ["show"] = {
                  ["misc"] = false,
                  ["raid"] = false,
                },
                ["y"] = -30,
                ["x"] = 27,
                ["size"] = 23,
              },
              ["buffs"] = {
                ["perRow"] = 2,
                ["x"] = 27,
                ["anchorPoint"] = "RT",
                ["anchorOn"] = false,
                ["show"] = {
                  ["relevant"] = false,
                },
                ["enlarge"] = {
                  ["REMOVABLE"] = false,
                },
                ["y"] = -30,
                ["size"] = 26,
              },
            },
            ["castBar"] = {
              ["order"] = 5,
              ["name"] = {
                ["y"] = 0,
                ["x"] = 2,
                ["anchorTo"] = "$parent",
                ["size"] = 2,
                ["enabled"] = true,
                ["anchorPoint"] = "CLI",
                ["rank"] = false,
              },
              ["autoHide"] = false,
              ["height"] = 3.2,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["time"] = {
                ["enabled"] = true,
                ["x"] = -2,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["anchorPoint"] = "CRI",
                ["size"] = 0,
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
              ["height"] = 1.8,
              ["order"] = 0,
              ["background"] = true,
              ["invert"] = false,
              ["reactionType"] = "none",
            },
            ["highlight"] = {
              ["aggro"] = false,
              ["height"] = 0.5,
              ["mouseover"] = false,
              ["size"] = 5,
            },
            ["text"] = {
              {
                ["width"] = 10,
                ["text"] = "[hp:color][curhp]",
                ["x"] = 4,
                ["size"] = 2,
              }, -- [1]
              {
                ["width"] = 10,
                ["text"] = "[hp:color][perhp]",
                ["x"] = -4,
                ["size"] = 4,
              }, -- [2]
              {
                ["anchorPoint"] = "TL",
                ["x"] = 0,
                ["text"] = "",
                ["y"] = -19,
                ["width"] = 10,
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
                ["anchorPoint"] = "TRI",
                ["x"] = -2,
                ["name"] = "Right text 2",
                ["anchorTo"] = "$healthBar",
                ["y"] = 14,
                ["width"] = 10,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 10,
              }, -- [8]
            },
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = false,
              ["height"] = 1.3,
              ["class"] = false,
              ["backgroundColor"] = {
                ["r"] = 0.0901960784313726,
                ["g"] = 0.0901960784313726,
                ["b"] = 0.0901960784313726,
              },
              ["order"] = 0,
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
              ["height"] = 0.5,
              ["order"] = 99,
            },
          },
          ["battlegroundtarget"] = {
            ["enabled"] = true,
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
            ["portrait"] = {
              ["type"] = "3D",
              ["alignment"] = "LEFT",
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
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
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
                ["name"] = "Right text 2",
                ["default"] = true,
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
            },
            ["range"] = {
              ["height"] = 0.5,
            },
            ["auras"] = {
              ["height"] = 0.5,
              ["debuffs"] = {
                ["enabled"] = true,
                ["maxRows"] = 1,
                ["y"] = -2,
                ["perRow"] = 7,
                ["x"] = -1,
                ["anchorPoint"] = "BR",
                ["size"] = 16,
              },
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
            ["width"] = 163,
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["offset"] = 4,
            ["height"] = 41,
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
            ["healthBar"] = {
              ["colorType"] = "static",
              ["order"] = 10,
              ["background"] = true,
              ["height"] = 1.2,
              ["reactionType"] = "none",
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
                ["y"] = 0,
                ["x"] = 0,
                ["perRow"] = 8,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["buffs"] = {
                ["perRow"] = 9,
                ["x"] = 0,
                ["anchorOn"] = false,
                ["y"] = -2,
                ["enabled"] = true,
                ["anchorPoint"] = "BR",
                ["size"] = 22,
              },
            },
            ["castBar"] = {
              ["enabled"] = true,
              ["order"] = 40,
              ["name"] = {
                ["y"] = 0,
                ["x"] = 1,
                ["anchorTo"] = "$parent",
                ["size"] = -1,
                ["enabled"] = true,
                ["anchorPoint"] = "CLI",
                ["rank"] = true,
              },
              ["autoHide"] = false,
              ["height"] = 0.6,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["time"] = {
                ["enabled"] = true,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["anchorPoint"] = "CRI",
                ["size"] = -1,
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
                ["y"] = 6,
                ["text"] = "[hp:color][curhp]",
                ["width"] = 1,
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
                ["anchorPoint"] = "CRI",
                ["x"] = -3,
                ["name"] = "Right text 2",
                ["anchorTo"] = "$healthBar",
                ["text"] = "|cff19a0ff[( )curpp]",
                ["y"] = -8,
                ["width"] = 1,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 1,
              }, -- [8]
            },
            ["width"] = 214,
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
            },
            ["indicators"] = {
              ["raidTarget"] = {
                ["y"] = 12,
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["anchorPoint"] = "C",
                ["size"] = 25,
              },
              ["class"] = {
                ["anchorPoint"] = "BL",
                ["x"] = 0,
                ["y"] = 0,
                ["anchorTo"] = "$parent",
              },
              ["height"] = 0.5,
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
            ["portrait"] = {
              ["type"] = "3D",
              ["fullBefore"] = 0,
              ["alignment"] = "LEFT",
              ["fullAfter"] = 100,
              ["order"] = 15,
              ["isBar"] = false,
              ["height"] = 0.5,
              ["width"] = 0.2,
            },
            ["attribPoint"] = "BOTTOM",
          },
          ["maintank"] = {
            ["highlight"] = {
              ["size"] = 10,
            },
            ["auras"] = {
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
              ["background"] = true,
              ["height"] = 1,
            },
            ["offset"] = 5,
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["height"] = 1.2,
              ["reactionType"] = "npc",
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
                ["y"] = 0,
                ["anchorTo"] = "$parent",
              },
              ["resurrect"] = {
                ["anchorPoint"] = "LC",
                ["x"] = 37,
                ["anchorTo"] = "$parent",
                ["y"] = -1,
                ["size"] = 28,
              },
            },
            ["attribAnchorPoint"] = "LEFT",
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
            },
            ["width"] = 150,
            ["maxColumns"] = 1,
            ["incHeal"] = {
              ["cap"] = 1,
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["columnSpacing"] = 5,
            ["height"] = 40,
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
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
            ["scale"] = 0.85,
            ["range"] = {
              ["height"] = 0.5,
            },
            ["auras"] = {
              ["height"] = 0.5,
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["powerBar"] = {
              ["height"] = 0.3,
              ["colorType"] = "type",
              ["background"] = true,
              ["order"] = 20,
            },
            ["groupsPerRow"] = 8,
            ["indicators"] = {
              ["raidTarget"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["anchorPoint"] = "C",
                ["size"] = 20,
              },
              ["height"] = 0.5,
            },
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["height"] = 1.2,
              ["reactionType"] = "none",
            },
            ["attribAnchorPoint"] = "LEFT",
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
            },
            ["height"] = 30,
            ["width"] = 90,
            ["maxColumns"] = 8,
            ["altPowerBar"] = {
              ["order"] = 100,
              ["background"] = true,
              ["height"] = 0.4,
            },
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
            ["columnSpacing"] = 5,
            ["unitsPerColumn"] = 8,
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
            },
          },
          ["battlegroundtargettarget"] = {
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
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["anchorPoint"] = "BL",
                ["x"] = 0,
                ["y"] = 0,
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
              ["reactionType"] = "none",
              ["order"] = 0,
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["reactionType"] = "npc",
              ["height"] = 1.2,
            },
            ["height"] = 25,
            ["width"] = 90,
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
              ["background"] = true,
              ["height"] = 0.6,
            },
            ["highlight"] = {
              ["size"] = 10,
            },
          },
          ["bosstargettarget"] = {
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
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["anchorPoint"] = "BL",
                ["x"] = 0,
                ["y"] = 0,
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
              ["reactionType"] = "none",
              ["order"] = 0,
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["reactionType"] = "npc",
              ["height"] = 1.2,
            },
            ["height"] = 25,
            ["width"] = 90,
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
              ["background"] = true,
              ["height"] = 0.6,
            },
            ["highlight"] = {
              ["size"] = 10,
            },
          },
          ["targettarget"] = {
            ["portrait"] = {
              ["fullBefore"] = 0,
              ["type"] = "3D",
              ["alignment"] = "RIGHT",
              ["fullAfter"] = 100,
              ["order"] = 15,
              ["isBar"] = false,
              ["height"] = 0.5,
              ["width"] = 0.22,
            },
            ["healthBar"] = {
              ["colorType"] = "static",
              ["reactionType"] = "none",
              ["height"] = 1.4,
              ["background"] = true,
              ["invert"] = false,
              ["order"] = 10,
            },
            ["width"] = 110,
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["order"] = 0,
              ["class"] = false,
              ["backgroundColor"] = {
                ["r"] = 0.0627450980392157,
                ["g"] = 0.0627450980392157,
                ["b"] = 0.0627450980392157,
              },
              ["height"] = 0.9,
            },
            ["range"] = {
              ["height"] = 0.5,
            },
            ["auras"] = {
              ["height"] = 0.5,
              ["debuffs"] = {
                ["anchorPoint"] = "BL",
                ["maxRows"] = 1,
                ["y"] = 3,
                ["enlarge"] = {
                  ["SELF"] = false,
                },
                ["x"] = -1,
                ["size"] = 15,
              },
              ["buffs"] = {
                ["anchorPoint"] = "BL",
                ["x"] = 0,
                ["y"] = 0,
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
                ["anchorPoint"] = "C",
                ["text"] = "[classcolor][abbrev:name]",
                ["x"] = 0,
                ["width"] = 10,
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
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
                ["anchorPoint"] = "BL",
                ["anchorTo"] = "$parent",
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
                ["maxRows"] = 1,
                ["anchorPoint"] = "BR",
                ["perRow"] = 7,
                ["x"] = -1,
                ["y"] = -2,
                ["size"] = 16,
              },
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
              ["height"] = 0.2,
              ["colorType"] = "type",
              ["background"] = false,
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
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
                ["y"] = 0,
                ["anchorTo"] = "$parent",
              },
              ["height"] = 0.5,
            },
            ["attribAnchorPoint"] = "RIGHT",
            ["altPowerBar"] = {
              ["order"] = 100,
              ["background"] = true,
              ["height"] = 0.4,
            },
            ["offset"] = 20,
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
              ["height"] = 1,
              ["order"] = 0,
            },
            ["attribPoint"] = "BOTTOM",
          },
          ["battlegroundpet"] = {
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
                ["name"] = "Right text 2",
                ["default"] = true,
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
            },
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["height"] = 1.2,
              ["reactionType"] = "npc",
            },
            ["auras"] = {
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["anchorPoint"] = "BL",
                ["x"] = 0,
                ["y"] = 0,
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
            ["indicators"] = {
              ["raidTarget"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["anchorPoint"] = "C",
                ["size"] = 20,
              },
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["width"] = 90,
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
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
              ["background"] = true,
              ["height"] = 0.6,
            },
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
            },
          },
          ["pettarget"] = {
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
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
            ["auras"] = {
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
              ["height"] = 1,
              ["order"] = 0,
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["height"] = 1.2,
              ["reactionType"] = "npc",
            },
            ["height"] = 30,
            ["width"] = 190,
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
              ["background"] = true,
              ["height"] = 0.7,
            },
            ["highlight"] = {
              ["size"] = 10,
            },
          },
          ["partypet"] = {
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
            },
            ["range"] = {
              ["height"] = 0.5,
            },
            ["auras"] = {
              ["height"] = 0.5,
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
              ["order"] = 20,
              ["colorType"] = "type",
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
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
            },
            ["width"] = 90,
            ["indicators"] = {
              ["raidTarget"] = {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["size"] = 20,
              },
              ["height"] = 0.5,
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
            },
            ["fader"] = {
              ["height"] = 0.5,
            },
            ["combatText"] = {
              ["height"] = 0.5,
            },
            ["height"] = 25,
            ["incHeal"] = {
              ["height"] = 0.5,
            },
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
          },
          ["maintanktarget"] = {
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
                ["anchorPoint"] = "BL",
                ["anchorTo"] = "$parent",
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
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
            ["auras"] = {
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
              ["height"] = 1,
              ["order"] = 0,
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["height"] = 1.2,
              ["reactionType"] = "npc",
            },
            ["height"] = 40,
            ["width"] = 150,
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
              ["background"] = true,
              ["height"] = 1,
            },
            ["highlight"] = {
              ["size"] = 10,
            },
          },
          ["player"] = {
            ["xpBar"] = {
              ["order"] = 60,
              ["background"] = true,
              ["height"] = 0.5,
            },
            ["highlight"] = {
              ["debuff"] = false,
              ["height"] = 0.5,
              ["alpha"] = 1,
              ["aggro"] = false,
              ["attention"] = false,
              ["mouseover"] = false,
              ["size"] = 5,
            },
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
                ["x"] = -3,
                ["anchorTo"] = "$parent",
                ["anchorPoint"] = "LT",
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
            ["healAbsorb"] = {
              ["height"] = 0.5,
            },
            ["staggerBar"] = {
              ["vertical"] = false,
              ["reverse"] = false,
              ["height"] = 0.5,
              ["background"] = false,
              ["invert"] = false,
              ["order"] = 100,
            },
            ["totemBar"] = {
              ["height"] = 0.5,
              ["showAlways"] = true,
              ["order"] = 25,
              ["background"] = true,
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
                  ["misc"] = false,
                  ["relevant"] = false,
                  ["raid"] = false,
                },
                ["x"] = -27,
                ["anchorPoint"] = "LT",
                ["y"] = -30,
                ["maxRows"] = 3,
                ["size"] = 23,
              },
              ["buffs"] = {
                ["perRow"] = 7,
                ["temporary"] = false,
                ["anchorOn"] = false,
                ["anchorPoint"] = "TL",
                ["x"] = 9,
                ["y"] = 26,
                ["maxRows"] = 2,
                ["show"] = {
                  ["misc"] = false,
                  ["raid"] = false,
                  ["consolidated"] = false,
                },
                ["size"] = 28,
              },
            },
            ["castBar"] = {
              ["order"] = 5,
              ["name"] = {
                ["y"] = 0,
                ["x"] = 2,
                ["anchorTo"] = "$parent",
                ["size"] = 2,
                ["enabled"] = true,
                ["anchorPoint"] = "CLI",
                ["rank"] = true,
              },
              ["autoHide"] = false,
              ["height"] = 3.2,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["time"] = {
                ["enabled"] = true,
                ["x"] = -2,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["anchorPoint"] = "CRI",
                ["size"] = 0,
              },
            },
            ["fader"] = {
              ["inactiveAlpha"] = 1,
              ["combatAlpha"] = 1,
              ["height"] = 0.5,
            },
            ["priestBar"] = {
              ["order"] = 70,
              ["background"] = false,
              ["height"] = 0.4,
            },
            ["height"] = 60,
            ["powerBar"] = {
              ["colorType"] = "type",
              ["height"] = 0.8,
              ["background"] = false,
              ["invert"] = false,
              ["order"] = 25,
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
            ["druidBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 25,
              ["enabled"] = true,
            },
            ["disableVehicle"] = false,
            ["healthBar"] = {
              ["colorType"] = "static",
              ["colorAggro"] = false,
              ["reactionType"] = "npc",
              ["order"] = 15,
              ["background"] = true,
              ["invert"] = false,
              ["height"] = 1.8,
            },
            ["emptyBar"] = {
              ["order"] = 0,
              ["class"] = false,
              ["height"] = 3.2,
              ["background"] = false,
              ["backgroundColor"] = {
                ["r"] = 1,
                ["g"] = 1,
                ["b"] = 1,
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
            ["text"] = {
              {
                ["width"] = 10,
                ["text"] = "[hp:color][curhp]",
                ["x"] = 4,
                ["size"] = 2,
              }, -- [1]
              {
                ["width"] = 10,
                ["text"] = "[hp:color][perhp]",
                ["x"] = -4,
                ["size"] = 4,
              }, -- [2]
              {
                ["anchorPoint"] = "TLI",
                ["x"] = 4,
                ["text"] = "",
                ["y"] = -1,
                ["width"] = 10,
              }, -- [3]
              {
                ["anchorPoint"] = "TR",
                ["x"] = 2,
                ["text"] = "",
                ["y"] = -20,
                ["width"] = 7,
              }, -- [4]
              {
                ["y"] = 3,
                ["x"] = -1,
              }, -- [5]
              nil, -- [6]
              {
                ["anchorPoint"] = "TRI",
                ["x"] = -2,
                ["name"] = "Right text 2",
                ["anchorTo"] = "$healthBar",
                ["y"] = 14,
                ["width"] = 10,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["text"] = "[afk:time]",
                ["name"] = "AFK",
                ["width"] = 10,
              }, -- [8]
              {
                ["anchorTo"] = "$staggerBar",
                ["text"] = "[monk:abs:stagger]",
                ["name"] = "Text",
                ["width"] = 1,
              }, -- [9]
              {
                ["default"] = true,
                ["anchorTo"] = "$runeBar",
                ["block"] = true,
                ["name"] = "Timer Text",
                ["width"] = 1,
              }, -- [10]
              {
                ["default"] = true,
                ["anchorTo"] = "$totemBar",
                ["block"] = true,
                ["name"] = "Timer Text",
                ["width"] = 1,
              }, -- [11]
              {
                ["name"] = "Text",
                ["anchorTo"] = "$staggerBar",
                ["text"] = "[monk:abs:stagger]",
                ["default"] = true,
                ["width"] = 1,
              }, -- [12]
              {
                ["default"] = true,
                ["anchorTo"] = "$runeBar",
                ["block"] = true,
                ["name"] = "Timer Text",
                ["width"] = 1,
              }, -- [13]
              {
                ["default"] = true,
                ["anchorTo"] = "$totemBar",
                ["block"] = true,
                ["name"] = "Timer Text",
                ["width"] = 1,
              }, -- [14]
            },
            ["width"] = 274,
            ["auraIndicators"] = {
              ["height"] = 0.5,
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
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
              ["enabled"] = false,
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
              ["order"] = 70,
              ["background"] = true,
              ["height"] = 0.3,
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
          },
          ["mainassist"] = {
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
                ["y"] = 0,
                ["anchorTo"] = "$parent",
              },
              ["resurrect"] = {
                ["anchorPoint"] = "LC",
                ["x"] = 37,
                ["anchorTo"] = "$parent",
                ["y"] = -1,
                ["size"] = 28,
              },
            },
            ["auras"] = {
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
            ["powerBar"] = {
              ["height"] = 1,
              ["colorType"] = "type",
              ["background"] = true,
              ["order"] = 20,
            },
            ["offset"] = 5,
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
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
            },
            ["width"] = 150,
            ["maxColumns"] = 1,
            ["columnSpacing"] = 5,
            ["altPowerBar"] = {
              ["order"] = 100,
              ["background"] = true,
              ["height"] = 0.4,
            },
            ["incHeal"] = {
              ["cap"] = 1,
            },
            ["height"] = 40,
            ["highlight"] = {
              ["size"] = 10,
            },
            ["attribAnchorPoint"] = "LEFT",
            ["unitsPerColumn"] = 5,
          },
          ["pet"] = {
            ["xpBar"] = {
              ["height"] = 0.25,
              ["background"] = true,
              ["order"] = 55,
            },
            ["indicators"] = {
              ["happiness"] = {
                ["anchorPoint"] = "RC",
                ["anchorTo"] = "$parent",
                ["size"] = 20,
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
                ["anchorPoint"] = "BL",
                ["x"] = 0,
                ["y"] = 0,
                ["size"] = 16,
              },
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
              ["order"] = 10,
              ["reactionType"] = "none",
              ["background"] = true,
              ["invert"] = false,
              ["height"] = 1.4,
            },
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
            },
            ["text"] = {
              {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["text"] = "[classcolor][abbrev:name]",
                ["width"] = 10,
                ["size"] = -1,
              }, -- [1]
              {
                ["y"] = -50,
                ["text"] = "",
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
            },
            ["emptyBar"] = {
              ["order"] = 0,
              ["background"] = true,
              ["reactionType"] = "none",
              ["height"] = 0.8,
            },
            ["width"] = 100,
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["height"] = 18,
            ["fader"] = {
              ["inactiveAlpha"] = 0.4,
              ["height"] = 0.5,
              ["combatAlpha"] = 0.4,
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
            ["enabled"] = false,
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
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
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["anchorTo"] = "$parent",
              },
              ["height"] = 0.5,
            },
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
            },
            ["width"] = 110,
            ["text"] = {
              {
                ["text"] = "[classcolor][abbrev:name]",
                ["x"] = 0,
                ["width"] = 10,
              }, -- [1]
              {
                ["text"] = "",
                ["x"] = 3,
                ["width"] = 0,
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
                ["name"] = "Right text 2",
                ["width"] = 0.5,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
            },
            ["range"] = {
              ["height"] = 0.5,
            },
            ["auras"] = {
              ["height"] = 0.5,
              ["debuffs"] = {
                ["y"] = 3,
                ["maxRows"] = 1,
                ["anchorPoint"] = "BL",
                ["enlarge"] = {
                  ["SELF"] = false,
                },
                ["x"] = -1,
                ["size"] = 15,
              },
              ["buffs"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
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
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["fader"] = {
              ["height"] = 0.5,
            },
            ["portrait"] = {
              ["fullBefore"] = 0,
              ["type"] = "3D",
              ["alignment"] = "RIGHT",
              ["fullAfter"] = 100,
              ["order"] = 0,
              ["isBar"] = false,
              ["height"] = 1,
              ["width"] = 0.22,
            },
            ["height"] = 30,
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
            ["healthBar"] = {
              ["colorType"] = "static",
              ["height"] = 1.4,
              ["reactionType"] = "none",
              ["background"] = true,
              ["invert"] = true,
              ["order"] = 10,
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
                ["y"] = 0,
                ["x"] = 0,
                ["anchorOn"] = false,
                ["perRow"] = 9,
                ["anchorPoint"] = "BL",
                ["show"] = {
                  ["player"] = false,
                },
                ["size"] = 16,
              },
              ["buffs"] = {
                ["perRow"] = 9,
                ["x"] = 0,
                ["anchorPoint"] = "BR",
                ["anchorOn"] = false,
                ["enabled"] = true,
                ["enlarge"] = {
                  ["REMOVABLE"] = false,
                },
                ["y"] = -2,
                ["size"] = 22,
              },
            },
            ["castBar"] = {
              ["enabled"] = true,
              ["order"] = 60,
              ["time"] = {
                ["enabled"] = true,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
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
              ["autoHide"] = false,
              ["height"] = 0.6,
              ["background"] = true,
              ["invert"] = false,
              ["reverse"] = false,
            },
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["powerBar"] = {
              ["height"] = 0.2,
              ["colorType"] = "type",
              ["background"] = false,
              ["order"] = 20,
            },
            ["offset"] = 30,
            ["healthBar"] = {
              ["colorAggro"] = false,
              ["order"] = 10,
              ["colorType"] = "static",
              ["height"] = 1.2,
              ["reverse"] = false,
              ["reactionType"] = "npc",
              ["background"] = true,
              ["invert"] = false,
              ["vertical"] = false,
            },
            ["text"] = {
              {
                ["text"] = "[classcolor][abbrev:name]",
              }, -- [1]
              {
                ["y"] = 6,
                ["text"] = "[hp:color][curhp]",
                ["width"] = 1,
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
                ["anchorPoint"] = "CRI",
                ["x"] = -3,
                ["name"] = "Right text 2",
                ["anchorTo"] = "$healthBar",
                ["text"] = "|cff19a0ff[( )curpp]",
                ["y"] = -8,
                ["width"] = 1,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["name"] = "AFK",
                ["width"] = 0.5,
              }, -- [8]
            },
            ["width"] = 214,
            ["enabled"] = true,
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
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
                ["anchorPoint"] = "RC",
                ["x"] = 4,
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
            ["portrait"] = {
              ["type"] = "3D",
              ["fullBefore"] = 0,
              ["alignment"] = "LEFT",
              ["fullAfter"] = 50,
              ["order"] = 15,
              ["isBar"] = true,
              ["height"] = 0.5,
              ["width"] = 0.22,
            },
            ["attribPoint"] = "BOTTOM",
          },
          ["partytargettarget"] = {
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
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 16,
              },
              ["debuffs"] = {
                ["anchorPoint"] = "BL",
                ["x"] = 0,
                ["y"] = 0,
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
              ["reactionType"] = "none",
              ["order"] = 0,
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["reactionType"] = "npc",
              ["height"] = 1.2,
            },
            ["height"] = 25,
            ["width"] = 90,
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
              ["background"] = true,
              ["height"] = 0.6,
            },
            ["highlight"] = {
              ["size"] = 10,
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
                ["anchorPoint"] = "BL",
                ["x"] = 0,
                ["perRow"] = 9,
                ["y"] = 0,
                ["size"] = 16,
              },
              ["buffs"] = {
                ["perRow"] = 9,
                ["x"] = 0,
                ["anchorPoint"] = "BR",
                ["enabled"] = true,
                ["show"] = {
                  ["misc"] = false,
                },
                ["y"] = -2,
                ["size"] = 22,
              },
            },
            ["castBar"] = {
              ["enabled"] = true,
              ["height"] = 0.6,
              ["name"] = {
                ["y"] = 0,
                ["x"] = 1,
                ["anchorTo"] = "$parent",
                ["size"] = 0,
                ["enabled"] = true,
                ["anchorPoint"] = "CLI",
                ["rank"] = true,
              },
              ["autoHide"] = false,
              ["order"] = 60,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["time"] = {
                ["enabled"] = true,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["anchorPoint"] = "CRI",
                ["size"] = 0,
              },
            },
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["powerBar"] = {
              ["order"] = 20,
              ["colorType"] = "type",
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
              ["height"] = 1.2,
              ["background"] = true,
              ["invert"] = false,
              ["reactionType"] = "none",
            },
            ["text"] = {
              {
                ["y"] = 6,
                ["text"] = "[classcolor][abbrev:name]",
                ["x"] = 6,
                ["width"] = 1,
              }, -- [1]
              {
                ["y"] = 6,
                ["text"] = "[hp:color][curhp]",
                ["width"] = 1,
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
                ["anchorPoint"] = "CRI",
                ["x"] = -3,
                ["default"] = true,
                ["anchorTo"] = "$healthBar",
                ["y"] = -8,
                ["text"] = "|cff19a0ff[( )curpp]",
                ["name"] = "Right text 2",
                ["width"] = 1,
              }, -- [7]
              {
                ["anchorPoint"] = "CLI",
                ["x"] = 6,
                ["name"] = "AFK",
                ["anchorTo"] = "$healthBar",
                ["width"] = 1,
                ["text"] = "[faction]",
                ["y"] = -8,
                ["size"] = -1,
              }, -- [8]
            },
            ["width"] = 214,
            ["enabled"] = true,
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
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
            ["portrait"] = {
              ["type"] = "class",
              ["alignment"] = "LEFT",
              ["fullAfter"] = 50,
              ["height"] = 0.5,
              ["fullBefore"] = 0,
              ["order"] = 15,
              ["width"] = 0.22,
            },
            ["attribPoint"] = "BOTTOM",
          },
        },
        ["revisionClassic"] = 4,
        ["font"] = {
          ["shadowColor"] = {
            ["a"] = 1,
            ["r"] = 0,
            ["g"] = 0,
            ["b"] = 0,
          },
          ["name"] = "MUI_Font",
          ["shadowX"] = 0.8,
          ["extra"] = "",
          ["shadowY"] = -0.8,
          ["color"] = {
            ["a"] = 1,
            ["b"] = 0.92156862745098,
            ["g"] = 1,
            ["r"] = 0.96078431372549,
          },
          ["size"] = 10,
        },
        ["classColors"] = {
          ["HUNTER"] = {
            ["a"] = 1,
            ["r"] = 0.67,
            ["g"] = 0.83,
            ["b"] = 0.45,
          },
          ["WARRIOR"] = {
            ["a"] = 1,
            ["r"] = 0.78,
            ["g"] = 0.61,
            ["b"] = 0.43,
          },
          ["ROGUE"] = {
            ["a"] = 1,
            ["r"] = 1,
            ["g"] = 0.96,
            ["b"] = 0.41,
          },
          ["MAGE"] = {
            ["a"] = 1,
            ["r"] = 0.41,
            ["g"] = 0.8,
            ["b"] = 0.94,
          },
          ["VEHICLE"] = {
            ["a"] = 1,
            ["r"] = 0.1058823529411765,
            ["g"] = 0.1098039215686275,
            ["b"] = 0.09803921568627451,
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
          ["DEATHKNIGHT"] = {
            ["a"] = 1,
            ["r"] = 0.77,
            ["g"] = 0.12,
            ["b"] = 0.23,
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
          ["SHAMAN"] = {
            ["a"] = 1,
            ["r"] = 0,
            ["g"] = 0.44,
            ["b"] = 0.87,
          },
        },
        ["omnicc"] = true,
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
        ["advanced"] = true,
        ["auraColors"] = {
          ["removable"] = {
            ["a"] = 1,
            ["r"] = 1,
            ["g"] = 1,
            ["b"] = 1,
          },
        },
      },
      ["MayronUIH"] = {
        ["wowBuild"] = 20501,
        ["auras"] = {
          ["borderType"] = "dark",
        },
        ["healthColors"] = {
          ["aggro"] = {
            ["a"] = 1,
            ["r"] = 0.749019607843137,
            ["g"] = 0,
            ["b"] = 0,
          },
          ["enemyUnattack"] = {
            ["b"] = 0.2,
            ["g"] = 0.2,
            ["r"] = 0.6,
          },
          ["neutral"] = {
            ["a"] = 1,
            ["b"] = 0.2,
            ["g"] = 0.843137254901961,
            ["r"] = 1,
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
            ["b"] = 0.1686274509803922,
            ["g"] = 0.9647058823529412,
            ["r"] = 0.2549019607843137,
          },
          ["yellow"] = {
            ["a"] = 1,
            ["b"] = 0.2274509803921569,
            ["g"] = 0.8901960784313725,
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
            ["b"] = 0.2,
            ["g"] = 0.2,
            ["r"] = 1,
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
          ["battlegroundtarget"] = {
            ["anchorPoint"] = "RT",
            ["x"] = 2,
            ["anchorTo"] = "$parent",
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
            ["top"] = 247.8933704121901,
            ["x"] = -8,
            ["anchorTo"] = "#SUFUnittarget",
            ["anchorPoint"] = "TR",
            ["bottom"] = 133.7933616741493,
            ["y"] = 85,
          },
          ["maintanktargettarget"] = {
            ["x"] = 154,
            ["point"] = "TOPLEFT",
            ["anchorTo"] = "$parent",
            ["relativePoint"] = "TOPRIGHT",
          },
          ["focus"] = {
            ["y"] = 50,
            ["point"] = "BOTTOM",
            ["relativePoint"] = "TOP",
            ["anchorTo"] = "#SUFUnittargettarget",
          },
          ["target"] = {
            ["y"] = -28.2,
            ["x"] = 21.2,
            ["point"] = "BOTTOMLEFT",
            ["anchorTo"] = "#SUFUnittargettarget",
            ["relativePoint"] = "TOPRIGHT",
          },
          ["raid"] = {
            ["top"] = 175.6821808460409,
            ["x"] = 34,
            ["anchorTo"] = "#SUFUnittarget",
            ["anchorPoint"] = "TR",
            ["bottom"] = 144.8821813705617,
            ["y"] = 85,
          },
          ["partytargettarget"] = {
            ["anchorPoint"] = "RT",
            ["anchorTo"] = "$parent",
          },
          ["arena"] = {
            ["y"] = 54,
            ["x"] = -200,
            ["point"] = "BOTTOMRIGHT",
            ["bottom"] = 247.666438653359,
            ["relativePoint"] = "TOPLEFT",
            ["anchorTo"] = "#SUFUnitplayer",
            ["top"] = 541.666561820395,
          },
          ["battlegroundpet"] = {
            ["anchorPoint"] = "RB",
            ["anchorTo"] = "$parent",
          },
          ["battlegroundtargettarget"] = {
            ["anchorPoint"] = "RT",
            ["anchorTo"] = "$parent",
          },
          ["bosstargettarget"] = {
            ["anchorPoint"] = "RB",
            ["anchorTo"] = "$parent",
          },
          ["targettarget"] = {
            ["y"] = -100,
            ["x"] = 100,
            ["point"] = "TOP",
            ["relativePoint"] = "TOP",
            ["anchorTo"] = "UIParent",
          },
          ["bosstarget"] = {
            ["anchorPoint"] = "RT",
            ["x"] = 2,
            ["anchorTo"] = "$parent",
          },
          ["focustarget"] = {
            ["point"] = "BOTTOM",
            ["relativePoint"] = "BOTTOM",
            ["y"] = 44.3799992442131,
          },
          ["pettarget"] = {
            ["anchorPoint"] = "C",
          },
          ["partypet"] = {
            ["anchorPoint"] = "",
            ["x"] = -2,
            ["point"] = "BOTTOMRIGHT",
            ["relativePoint"] = "BOTTOMLEFT",
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
            ["x"] = 2,
            ["point"] = "TOPLEFT",
            ["anchorTo"] = "$parent",
            ["relativePoint"] = "TOPRIGHT",
          },
          ["pet"] = {
            ["y"] = 12,
            ["point"] = "BOTTOM",
            ["anchorTo"] = "#SUFUnittargettarget",
            ["relativePoint"] = "TOP",
          },
          ["raidpet"] = {
            ["anchorPoint"] = "TL",
            ["x"] = -100,
            ["anchorTo"] = "#SUFUnittarget",
            ["top"] = 439.4600266957277,
            ["bottom"] = 183.2599883341791,
            ["y"] = 85,
          },
          ["maintank"] = {
            ["y"] = 145,
            ["x"] = 330,
            ["point"] = "BOTTOMLEFT",
            ["anchorTo"] = "#SUFUnittarget",
            ["relativePoint"] = "BOTTOMLEFT",
            ["top"] = 520.9822970359273,
            ["bottom"] = 294.1823649852213,
          },
          ["boss"] = {
            ["y"] = 54,
            ["x"] = -200,
            ["point"] = "BOTTOMRIGHT",
            ["bottom"] = 122.511234485912,
            ["relativePoint"] = "TOPLEFT",
            ["anchorTo"] = "#SUFUnitplayer",
            ["top"] = 416.511229479122,
          },
          ["battleground"] = {
            ["y"] = 54,
            ["x"] = -200,
            ["point"] = "BOTTOMRIGHT",
            ["bottom"] = 520.911246011747,
            ["relativePoint"] = "TOPLEFT",
            ["anchorTo"] = "#SUFUnitplayer",
            ["top"] = 751.911327527057,
          },
        },
        ["advanced"] = true,
        ["revision"] = 61,
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
        ["powerColors"] = {
          ["PAIN"] = {
            ["r"] = 1,
            ["g"] = 0,
            ["b"] = 0,
          },
          ["SHADOWORBS"] = {
            ["b"] = 0.79,
            ["g"] = 0.51,
            ["r"] = 0.58,
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
          ["MUSHROOMS"] = {
            ["b"] = 0.2,
            ["g"] = 0.9,
            ["r"] = 0.2,
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
            ["g"] = 0.5490196078431373,
            ["r"] = 0.2156862745098039,
          },
          ["AURAPOINTS"] = {
            ["b"] = 0,
            ["g"] = 0.8,
            ["r"] = 1,
          },
          ["ECLIPSE_FULL"] = {
            ["b"] = 0.43,
            ["g"] = 0.32,
            ["r"] = 0,
          },
          ["ECLIPSE_MOON"] = {
            ["r"] = 0.3,
            ["g"] = 0.52,
            ["b"] = 0.9,
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
          ["STAGGER_GREEN"] = {
            ["b"] = 0.52,
            ["g"] = 1,
            ["r"] = 0.52,
          },
          ["AMMOSLOT"] = {
            ["b"] = 0.55,
            ["g"] = 0.6,
            ["r"] = 0.85,
          },
          ["POWER_TYPE_FEL_ENERGY"] = {
            ["r"] = 0.878,
            ["g"] = 0.98,
            ["b"] = 0,
          },
          ["STATUE"] = {
            ["b"] = 0.6,
            ["g"] = 0.45,
            ["r"] = 0.35,
          },
          ["LUNAR_POWER"] = {
            ["r"] = 0.3,
            ["g"] = 0.52,
            ["b"] = 0.9,
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
                ["name"] = "Right text 2",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.8,
                ["name"] = "AFK",
              }, -- [8]
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
            ["altPowerBar"] = {
              ["order"] = 100,
              ["background"] = true,
              ["height"] = 0.4,
            },
            ["emptyBar"] = {
              ["height"] = 1,
              ["background"] = true,
              ["order"] = 0,
              ["reactionType"] = "none",
            },
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
            ["attribAnchorPoint"] = "RIGHT",
            ["attribPoint"] = "TOP",
          },
          ["mainassisttarget"] = {
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
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["reactionType"] = "npc",
              ["height"] = 1.2,
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
            ["emptyBar"] = {
              ["height"] = 1,
              ["background"] = true,
              ["order"] = 0,
              ["reactionType"] = "none",
            },
            ["width"] = 150,
            ["castBar"] = {
              ["time"] = {
                ["y"] = 0,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
                ["name"] = "Right text 2",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "AFK",
              }, -- [8]
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
                ["y"] = 0,
                ["anchorPoint"] = "BL",
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
            ["highlight"] = {
              ["size"] = 10,
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
                ["y"] = 0,
                ["anchorPoint"] = "BL",
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
              ["order"] = 0,
              ["reactionType"] = "none",
            },
            ["range"] = {
              ["height"] = 0.5,
            },
            ["width"] = 80,
            ["castBar"] = {
              ["time"] = {
                ["y"] = 0,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
                ["name"] = "Right text 2",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "AFK",
              }, -- [8]
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
                ["name"] = "Right text 2",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "AFK",
              }, -- [8]
            },
            ["width"] = 90,
            ["fader"] = {
              ["height"] = 0.5,
            },
            ["emptyBar"] = {
              ["height"] = 1,
              ["background"] = true,
              ["order"] = 0,
              ["reactionType"] = "none",
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
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
            },
            ["altPowerBar"] = {
              ["order"] = 100,
              ["background"] = true,
              ["height"] = 0.4,
            },
          },
          ["arenatargettarget"] = {
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
            ["width"] = 90,
            ["castBar"] = {
              ["time"] = {
                ["y"] = 0,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
              ["height"] = 0.6,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["order"] = 40,
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
                ["y"] = 0,
                ["anchorPoint"] = "BL",
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
            ["highlight"] = {
              ["size"] = 10,
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
                ["name"] = "Right text 2",
                ["default"] = true,
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
            ["enabled"] = true,
            ["height"] = 41,
            ["emptyBar"] = {
              ["height"] = 1,
              ["background"] = true,
              ["order"] = 0,
              ["reactionType"] = "none",
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
                ["size"] = 16,
              },
              ["height"] = 0.5,
            },
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
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
              ["order"] = 0,
              ["reactionType"] = "none",
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
                ["name"] = "Right text 2",
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
          ["mainassisttargettarget"] = {
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
            ["width"] = 150,
            ["castBar"] = {
              ["time"] = {
                ["y"] = 0,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
              ["height"] = 0.6,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["order"] = 40,
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
                ["y"] = 0,
                ["anchorPoint"] = "BL",
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
            ["highlight"] = {
              ["size"] = 10,
            },
          },
          ["party"] = {
            ["highlight"] = {
              ["debuff"] = true,
              ["height"] = 0.5,
              ["aggro"] = true,
              ["alpha"] = 1,
              ["mouseover"] = false,
              ["size"] = 10,
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
                ["perRow"] = 2,
                ["anchorOn"] = false,
                ["enlarge"] = {
                  ["SELF"] = false,
                  ["REMOVABLE"] = false,
                },
                ["y"] = 1,
                ["x"] = -2,
                ["enabled"] = true,
                ["anchorPoint"] = "LB",
                ["maxRows"] = 5,
                ["show"] = {
                  ["misc"] = false,
                },
                ["size"] = 18,
              },
              ["buffs"] = {
                ["perRow"] = 2,
                ["anchorOn"] = false,
                ["y"] = 1,
                ["x"] = 2,
                ["anchorPoint"] = "RB",
                ["show"] = {
                  ["misc"] = false,
                  ["relevant"] = false,
                  ["raid"] = false,
                },
                ["maxRows"] = 5,
                ["enabled"] = true,
                ["size"] = 18,
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
              ["height"] = 0.6,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["order"] = 60,
            },
            ["indicators"] = {
              ["raidTarget"] = {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 4,
                ["size"] = 23,
              },
              ["lfdRole"] = {
                ["anchorPoint"] = "LT",
                ["x"] = 14,
                ["anchorTo"] = "$parent",
                ["y"] = -1,
                ["size"] = 12,
              },
              ["sumPending"] = {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["size"] = 40,
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
              ["status"] = {
                ["anchorPoint"] = "LB",
                ["x"] = 12,
                ["anchorTo"] = "$parent",
                ["y"] = -2,
                ["size"] = 16,
              },
              ["class"] = {
                ["anchorPoint"] = "BL",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
              },
              ["height"] = 0.5,
              ["pvp"] = {
                ["y"] = 6,
                ["x"] = 72,
                ["anchorTo"] = "$parent",
                ["enabled"] = false,
                ["anchorPoint"] = "LT",
                ["size"] = 24,
              },
            },
            ["incAbsorb"] = {
              ["height"] = 0.5,
              ["enabled"] = false,
            },
            ["powerBar"] = {
              ["colorType"] = "type",
              ["predicted"] = true,
              ["height"] = 0.2,
              ["order"] = 20,
              ["background"] = false,
              ["invert"] = false,
              ["onlyMana"] = false,
            },
            ["height"] = 40,
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["hideAnyRaid"] = true,
            ["unitsPerColumn"] = 5,
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
            ["fader"] = {
              ["height"] = 0.5,
              ["inactiveAlpha"] = 1,
            },
            ["attribAnchorPoint"] = "LEFT",
            ["incHeal"] = {
              ["height"] = 0.5,
              ["cap"] = 1,
            },
            ["width"] = 215,
            ["emptyBar"] = {
              ["height"] = 1,
              ["background"] = true,
              ["order"] = 0,
              ["reactionType"] = "none",
            },
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
                ["width"] = 2,
                ["y"] = 8,
                ["x"] = -2,
                ["name"] = "Right text 2",
                ["anchorPoint"] = "CRI",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 1,
                ["y"] = 12,
                ["x"] = 4,
                ["name"] = "AFK",
                ["anchorPoint"] = "BL",
                ["size"] = -1,
              }, -- [8]
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
            ["attribPoint"] = "TOP",
          },
          ["maintanktargettarget"] = {
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["order"] = 0,
              ["height"] = 1,
            },
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
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
            ["text"] = {
              {
                ["text"] = "[classcolor][name][close( )][levelcolor][close][( )afk][( )status]",
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
              {
                ["text"] = "[(()afk() )][name]",
              }, -- [5]
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
              ["name"] = {
                ["y"] = 0,
                ["x"] = 1,
                ["anchorTo"] = "$parent",
                ["size"] = 0,
                ["enabled"] = true,
                ["anchorPoint"] = "CLI",
                ["rank"] = true,
              },
              ["height"] = 0.6,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["order"] = 40,
            },
            ["healthBar"] = {
              ["colorType"] = "static",
              ["order"] = 10,
              ["background"] = true,
              ["height"] = 1.2,
              ["reactionType"] = "none",
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["width"] = 100,
            ["height"] = 44,
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["powerBar"] = {
              ["colorType"] = "type",
              ["height"] = 0.2,
              ["background"] = false,
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
              ["height"] = 0.5,
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
              ["sumPending"] = {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["size"] = 40,
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
                ["enabled"] = true,
                ["y"] = 2,
                ["x"] = 0,
                ["maxRows"] = 2,
                ["perRow"] = 9,
                ["anchorPoint"] = "TL",
                ["show"] = {
                  ["misc"] = false,
                  ["raid"] = false,
                },
                ["size"] = 20,
              },
            },
            ["castBar"] = {
              ["enabled"] = true,
              ["time"] = {
                ["y"] = 0,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
                ["size"] = 2,
              },
              ["autoHide"] = true,
              ["height"] = 1.4,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["order"] = 60,
            },
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["powerBar"] = {
              ["predicted"] = true,
              ["height"] = 0.3,
              ["order"] = 25,
              ["background"] = false,
              ["invert"] = false,
              ["colorType"] = "type",
            },
            ["healthBar"] = {
              ["colorType"] = "static",
              ["height"] = 1.9,
              ["order"] = 0,
              ["background"] = true,
              ["invert"] = false,
              ["reactionType"] = "none",
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
                ["x"] = 2,
                ["size"] = 1,
              }, -- [1]
              {
                ["text"] = "[hp:color][perhp]",
                ["width"] = 3,
                ["x"] = -2,
                ["size"] = 1,
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
                ["anchorPoint"] = "TRI",
                ["name"] = "Right text 2",
                ["y"] = 26,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "AFK",
              }, -- [8]
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
            ["width"] = 153,
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
            ["height"] = 40,
            ["healAbsorb"] = {
              ["enabled"] = false,
              ["height"] = 0.5,
            },
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["order"] = 70,
              ["background"] = true,
              ["backgroundColor"] = {
                ["b"] = 0.0980392156862745,
                ["g"] = 0.0980392156862745,
                ["r"] = 0.0980392156862745,
              },
              ["height"] = 0.8,
            },
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
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
              ["sumPending"] = {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["size"] = 40,
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
                ["enabled"] = true,
                ["anchorOn"] = false,
                ["enlarge"] = {
                  ["SELF"] = false,
                },
                ["anchorPoint"] = "RT",
                ["x"] = 27,
                ["perRow"] = 3,
                ["show"] = {
                  ["misc"] = false,
                  ["raid"] = false,
                },
                ["maxRows"] = 3,
                ["y"] = -30,
                ["size"] = 23,
              },
              ["buffs"] = {
                ["perRow"] = 9,
                ["anchorOn"] = false,
                ["enlarge"] = {
                  ["REMOVABLE"] = false,
                },
                ["anchorPoint"] = "TR",
                ["x"] = -8,
                ["enabled"] = true,
                ["y"] = 30,
                ["maxRows"] = 2,
                ["show"] = {
                  ["misc"] = false,
                },
                ["size"] = 22,
              },
            },
            ["castBar"] = {
              ["time"] = {
                ["y"] = 0,
                ["x"] = -2,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
              ["height"] = 3.2,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["order"] = 5,
            },
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["powerBar"] = {
              ["predicted"] = true,
              ["height"] = 0.8,
              ["reverse"] = false,
              ["order"] = 25,
              ["background"] = false,
              ["invert"] = false,
              ["colorType"] = "type",
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
            ["comboPoints"] = {
              ["order"] = 99,
              ["height"] = 0.5,
            },
            ["text"] = {
              {
                ["text"] = "[hp:color][curhp]",
                ["width"] = 10,
                ["x"] = 4,
                ["size"] = 2,
              }, -- [1]
              {
                ["text"] = "[hp:color][perhp]",
                ["width"] = 10,
                ["x"] = -4,
                ["size"] = 4,
              }, -- [2]
              {
                ["text"] = "",
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
                ["y"] = 14,
                ["x"] = -2,
                ["name"] = "Right text 2",
                ["anchorPoint"] = "TRI",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["text"] = "[afk:time][status:time]",
                ["width"] = 10,
                ["name"] = "AFK",
              }, -- [8]
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
              ["y"] = -9,
              ["height"] = 0.5,
              ["enabled"] = false,
            },
            ["height"] = 60,
            ["healAbsorb"] = {
              ["height"] = 0.5,
            },
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["class"] = false,
              ["order"] = 0,
              ["background"] = false,
              ["backgroundColor"] = {
                ["b"] = 0.0901960784313726,
                ["g"] = 0.0901960784313726,
                ["r"] = 0.0901960784313726,
              },
              ["height"] = 1.3,
            },
            ["highlight"] = {
              ["height"] = 0.5,
              ["aggro"] = false,
              ["mouseover"] = false,
              ["size"] = 5,
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
            ["showParty"] = false,
            ["castBar"] = {
              ["time"] = {
                ["y"] = 0,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
            ["offset"] = 2,
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
                ["name"] = "Right text 2",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["text"] = "[afk][status]",
                ["width"] = 1,
                ["y"] = -10,
                ["name"] = "AFK",
                ["size"] = -1,
              }, -- [8]
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
            ["highlight"] = {
              ["debuff"] = true,
              ["aggro"] = true,
              ["alpha"] = 1,
              ["height"] = 0.5,
              ["attention"] = false,
              ["mouseover"] = false,
              ["size"] = 10,
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
              ["sumPending"] = {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["size"] = 40,
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
            ["groupsPerRow"] = 8,
            ["attribAnchorPoint"] = "BOTTOM",
            ["columnSpacing"] = 2,
            ["width"] = 65,
            ["auraIndicators"] = {
              ["enabled"] = true,
              ["height"] = 0.5,
            },
            ["auras"] = {
              ["height"] = 0.5,
              ["debuffs"] = {
                ["perRow"] = 5,
                ["anchorOn"] = false,
                ["enlarge"] = {
                  ["SELF"] = false,
                },
                ["y"] = 17,
                ["x"] = 2,
                ["enabled"] = true,
                ["show"] = {
                  ["player"] = false,
                  ["raid"] = false,
                },
                ["maxRows"] = 1,
                ["anchorPoint"] = "BL",
                ["size"] = 10,
              },
              ["buffs"] = {
                ["perRow"] = 5,
                ["timers"] = {
                  ["SELF"] = false,
                },
                ["anchorOn"] = false,
                ["enlarge"] = {
                  ["SELF"] = true,
                },
                ["maxRows"] = 1,
                ["show"] = {
                  ["relevant"] = false,
                },
                ["x"] = -1,
                ["anchorPoint"] = "TR",
                ["y"] = -10,
                ["selfScale"] = 2,
                ["enabled"] = true,
                ["size"] = 10,
              },
            },
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
            ["enabled"] = true,
            ["emptyBar"] = {
              ["height"] = 1,
              ["background"] = true,
              ["order"] = 0,
              ["reactionType"] = "none",
            },
          },
          ["partytargettarget"] = {
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
            ["width"] = 90,
            ["castBar"] = {
              ["time"] = {
                ["y"] = 0,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
              ["height"] = 0.6,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["order"] = 40,
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
              ["order"] = 100,
              ["background"] = true,
              ["height"] = 0.4,
            },
            ["auras"] = {
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
            ["height"] = 25,
            ["powerBar"] = {
              ["colorType"] = "type",
              ["height"] = 0.6,
              ["background"] = true,
              ["order"] = 20,
            },
            ["highlight"] = {
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
                ["anchorOn"] = false,
                ["show"] = {
                  ["player"] = false,
                },
                ["x"] = 0,
                ["perRow"] = 9,
                ["anchorPoint"] = "BL",
                ["y"] = 0,
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
              ["name"] = {
                ["y"] = 0,
                ["x"] = 1,
                ["anchorTo"] = "$parent",
                ["rank"] = false,
                ["anchorPoint"] = "CLI",
                ["enabled"] = true,
                ["size"] = 0,
              },
              ["autoHide"] = false,
              ["height"] = 0.6,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["time"] = {
                ["y"] = 0,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
                ["anchorPoint"] = "CRI",
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
              ["vertical"] = false,
              ["colorType"] = "static",
              ["reverse"] = false,
              ["reactionType"] = "npc",
              ["background"] = true,
              ["invert"] = false,
              ["height"] = 1.2,
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
                ["text"] = "|cff19a0ff[( )curpp]",
                ["width"] = 1,
                ["y"] = -8,
                ["x"] = -3,
                ["name"] = "Right text 2",
                ["anchorPoint"] = "CRI",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "AFK",
              }, -- [8]
            },
            ["width"] = 214,
            ["indicators"] = {
              ["arenaSpec"] = {
                ["y"] = 15,
                ["x"] = -4,
                ["anchorTo"] = "$parent",
                ["anchorPoint"] = "LC",
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
            ["enabled"] = true,
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
              ["order"] = 0,
              ["reactionType"] = "none",
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
                ["name"] = "Right text 2",
                ["default"] = true,
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
          ["battlegroundtargettarget"] = {
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
            ["width"] = 90,
            ["castBar"] = {
              ["time"] = {
                ["y"] = 0,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
              ["height"] = 0.6,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["order"] = 40,
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
                ["y"] = 0,
                ["anchorPoint"] = "BL",
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
            ["highlight"] = {
              ["size"] = 10,
            },
          },
          ["bosstargettarget"] = {
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
            ["width"] = 90,
            ["castBar"] = {
              ["time"] = {
                ["y"] = 0,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
              ["height"] = 0.6,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["order"] = 40,
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
                ["y"] = 0,
                ["anchorPoint"] = "BL",
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
            ["highlight"] = {
              ["size"] = 10,
            },
          },
          ["targettarget"] = {
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
            ["highlight"] = {
              ["height"] = 0.5,
              ["mouseover"] = false,
              ["size"] = 10,
            },
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["class"] = false,
              ["height"] = 0.9,
              ["background"] = true,
              ["backgroundColor"] = {
                ["b"] = 0.0627450980392157,
                ["g"] = 0.0627450980392157,
                ["r"] = 0.0627450980392157,
              },
              ["order"] = 0,
            },
            ["range"] = {
              ["height"] = 0.5,
            },
            ["width"] = 110,
            ["castBar"] = {
              ["time"] = {
                ["y"] = 0,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
                ["name"] = "Right text 2",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "AFK",
              }, -- [8]
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
              ["height"] = 1.4,
              ["order"] = 10,
              ["background"] = true,
              ["invert"] = false,
              ["reactionType"] = "none",
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
              ["order"] = 20,
              ["background"] = false,
              ["height"] = 0.2,
            },
            ["offset"] = 20,
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
                ["name"] = "Right text 2",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "AFK",
              }, -- [8]
            },
            ["width"] = 163,
            ["enabled"] = true,
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
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["emptyBar"] = {
              ["height"] = 1,
              ["background"] = true,
              ["order"] = 0,
              ["reactionType"] = "none",
            },
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
            ["attribAnchorPoint"] = "RIGHT",
            ["attribPoint"] = "BOTTOM",
          },
          ["focustarget"] = {
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
                ["name"] = "Right text 2",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "AFK",
              }, -- [8]
            },
            ["width"] = 110,
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
            },
            ["height"] = 30,
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
            ["fader"] = {
              ["height"] = 0.5,
            },
            ["emptyBar"] = {
              ["reactionType"] = "none",
              ["background"] = true,
              ["height"] = 1,
              ["order"] = 0,
            },
          },
          ["pettarget"] = {
            ["indicators"] = {
              ["raidTarget"] = {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["size"] = 20,
              },
            },
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["reactionType"] = "npc",
              ["height"] = 1.2,
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
            ["emptyBar"] = {
              ["height"] = 1,
              ["background"] = true,
              ["order"] = 0,
              ["reactionType"] = "none",
            },
            ["width"] = 190,
            ["castBar"] = {
              ["time"] = {
                ["y"] = 0,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
                ["name"] = "Right text 2",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "AFK",
              }, -- [8]
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
                ["y"] = 0,
                ["anchorPoint"] = "BL",
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
            ["highlight"] = {
              ["size"] = 10,
            },
          },
          ["partypet"] = {
            ["indicators"] = {
              ["raidTarget"] = {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
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
              ["enabled"] = false,
              ["colorType"] = "type",
              ["order"] = 20,
              ["background"] = true,
              ["height"] = 0.6,
            },
            ["enabled"] = true,
            ["healthBar"] = {
              ["colorType"] = "static",
              ["order"] = 10,
              ["background"] = true,
              ["reactionType"] = "npc",
              ["height"] = 1.2,
            },
            ["height"] = 25,
            ["emptyBar"] = {
              ["height"] = 1,
              ["background"] = true,
              ["order"] = 0,
              ["reactionType"] = "none",
            },
            ["width"] = 90,
            ["text"] = {
              {
                ["size"] = -1,
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
              {
                ["text"] = "[name]",
              }, -- [5]
              nil, -- [6]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "Right text 2",
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
            ["fader"] = {
              ["height"] = 0.5,
            },
            ["combatText"] = {
              ["enabled"] = false,
              ["height"] = 0.5,
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
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
            },
          },
          ["mainassist"] = {
            ["unitsPerColumn"] = 5,
            ["portrait"] = {
              ["type"] = "3D",
              ["alignment"] = "LEFT",
              ["fullAfter"] = 50,
              ["height"] = 0.5,
              ["fullBefore"] = 0,
              ["order"] = 15,
              ["width"] = 0.22,
            },
            ["height"] = 40,
            ["emptyBar"] = {
              ["height"] = 1,
              ["background"] = true,
              ["order"] = 0,
              ["reactionType"] = "none",
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
              ["order"] = 60,
            },
            ["altPowerBar"] = {
              ["order"] = 100,
              ["background"] = true,
              ["height"] = 0.4,
            },
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["powerBar"] = {
              ["colorType"] = "type",
              ["order"] = 20,
              ["background"] = true,
              ["height"] = 1,
            },
            ["offset"] = 5,
            ["attribAnchorPoint"] = "LEFT",
            ["healthBar"] = {
              ["colorType"] = "class",
              ["order"] = 10,
              ["background"] = true,
              ["reactionType"] = "npc",
              ["height"] = 1.2,
            },
            ["columnSpacing"] = 5,
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
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
                ["name"] = "Right text 2",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "AFK",
              }, -- [8]
            },
            ["width"] = 150,
            ["maxColumns"] = 1,
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
            ["indicators"] = {
              ["raidTarget"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["anchorPoint"] = "C",
                ["size"] = 20,
              },
              ["sumPending"] = {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["size"] = 40,
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
              ["height"] = 0.5,
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
                ["y"] = 0,
                ["x"] = -2,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
              ["height"] = 3.2,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["order"] = 5,
            },
            ["powerBar"] = {
              ["colorType"] = "type",
              ["order"] = 25,
              ["background"] = false,
              ["invert"] = false,
              ["height"] = 1.3,
            },
            ["healthBar"] = {
              ["colorAggro"] = false,
              ["order"] = 15,
              ["colorType"] = "static",
              ["height"] = 1.3,
              ["background"] = true,
              ["invert"] = false,
              ["reactionType"] = "npc",
            },
            ["druidBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["enabled"] = true,
              ["order"] = 25,
            },
            ["text"] = {
              {
                ["text"] = "[hp:color][curhp]",
                ["width"] = 10,
                ["x"] = 4,
                ["size"] = 1,
              }, -- [1]
              {
                ["text"] = "[hp:color][perhp]",
                ["width"] = 10,
                ["x"] = -4,
                ["size"] = 2,
              }, -- [2]
              {
                ["text"] = "|cff66d9ff[curpp]",
                ["width"] = 10,
                ["x"] = 4,
                ["size"] = 1,
              }, -- [3]
              {
                ["text"] = "|cff66d9ff[perpp]",
                ["width"] = 10,
                ["x"] = -4,
                ["size"] = 2,
              }, -- [4]
              {
                ["y"] = 3,
                ["x"] = -1,
              }, -- [5]
              nil, -- [6]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 10,
                ["y"] = -1,
                ["x"] = -4,
                ["name"] = "Right text 2",
                ["anchorPoint"] = "TRI",
                ["size"] = 2,
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["text"] = "[afk:time]",
                ["width"] = 10,
                ["name"] = "AFK",
              }, -- [8]
              {
                ["anchorTo"] = "$staggerBar",
                ["text"] = "[monk:abs:stagger]",
                ["width"] = 1,
                ["name"] = "Text",
              }, -- [9]
              {
                ["anchorTo"] = "$runeBar",
                ["width"] = 1,
                ["default"] = true,
                ["name"] = "Timer Text",
                ["block"] = true,
              }, -- [10]
              {
                ["anchorTo"] = "$totemBar",
                ["width"] = 1,
                ["default"] = true,
                ["name"] = "Timer Text",
                ["block"] = true,
              }, -- [11]
              {
                ["anchorTo"] = "$staggerBar",
                ["text"] = "[monk:abs:stagger]",
                ["width"] = 1,
                ["default"] = true,
                ["name"] = "Text",
              }, -- [12]
              {
                ["anchorTo"] = "$runeBar",
                ["width"] = 1,
                ["default"] = true,
                ["name"] = "Timer Text",
                ["block"] = true,
              }, -- [13]
              {
                ["anchorTo"] = "$totemBar",
                ["width"] = 1,
                ["default"] = true,
                ["name"] = "Timer Text",
                ["block"] = true,
              }, -- [14]
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
                ["x"] = -3,
                ["anchorTo"] = "$parent",
                ["anchorPoint"] = "LT",
                ["size"] = 17,
              },
              ["sumPending"] = {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["size"] = 40,
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
              ["ready"] = {
                ["y"] = -15,
                ["x"] = 80,
                ["anchorTo"] = "$parent",
                ["anchorPoint"] = "C",
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
              ["height"] = 0.5,
              ["background"] = true,
              ["order"] = 25,
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
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["enabled"] = false,
              ["order"] = 100,
            },
            ["highlight"] = {
              ["debuff"] = false,
              ["height"] = 0.5,
              ["mouseover"] = false,
              ["aggro"] = false,
              ["attention"] = false,
              ["alpha"] = 1,
              ["size"] = 5,
            },
            ["disableVehicle"] = false,
            ["shamanBar"] = {
              ["height"] = 0.3,
              ["background"] = true,
              ["order"] = 70,
            },
            ["emptyBar"] = {
              ["order"] = 0,
              ["background"] = false,
              ["reactionType"] = "none",
              ["class"] = false,
              ["backgroundColor"] = {
                ["b"] = 1,
                ["g"] = 1,
                ["r"] = 1,
              },
              ["height"] = 3.2,
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
                ["perRow"] = 3,
                ["anchorOn"] = false,
                ["enlarge"] = {
                  ["SELF"] = false,
                },
                ["anchorPoint"] = "LT",
                ["x"] = -27,
                ["enabled"] = true,
                ["show"] = {
                  ["misc"] = false,
                  ["relevant"] = false,
                  ["raid"] = false,
                },
                ["maxRows"] = 3,
                ["y"] = -30,
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
            ["staggerBar"] = {
              ["vertical"] = false,
              ["reverse"] = false,
              ["height"] = 0.5,
              ["background"] = false,
              ["invert"] = false,
              ["order"] = 100,
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
            ["fader"] = {
              ["inactiveAlpha"] = 1,
              ["height"] = 0.5,
              ["combatAlpha"] = 1,
            },
            ["combatText"] = {
              ["y"] = -9,
              ["height"] = 0.5,
              ["enabled"] = false,
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
            ["incAbsorb"] = {
              ["enabled"] = false,
              ["cap"] = 1,
              ["height"] = 0.5,
            },
          },
          ["maintanktarget"] = {
            ["emptyBar"] = {
              ["height"] = 1,
              ["background"] = true,
              ["order"] = 0,
              ["reactionType"] = "none",
            },
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
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
            ["text"] = {
              {
                ["text"] = "[classcolor][name][close( )][levelcolor][close][( )afk][( )status]",
                ["width"] = 2.2,
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
                ["text"] = "[(()afk() )][name]",
              }, -- [5]
              nil, -- [6]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "Right text 2",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "AFK",
              }, -- [8]
            },
            ["range"] = {
              ["enabled"] = true,
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
              ["enabled"] = true,
              ["name"] = {
                ["y"] = 0,
                ["x"] = 1,
                ["anchorTo"] = "$parent",
                ["rank"] = true,
                ["anchorPoint"] = "CLI",
                ["enabled"] = true,
                ["size"] = 0,
              },
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
              ["order"] = 40,
            },
            ["healthBar"] = {
              ["colorType"] = "static",
              ["order"] = 10,
              ["background"] = true,
              ["reactionType"] = "none",
              ["height"] = 1.2,
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["width"] = 150,
            ["height"] = 44,
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["powerBar"] = {
              ["colorType"] = "type",
              ["height"] = 0.2,
              ["background"] = false,
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
              ["height"] = 0.5,
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
                ["anchorTo"] = "$parent",
                ["anchorPoint"] = "RC",
                ["size"] = 20,
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
                ["y"] = 36,
                ["anchorPoint"] = "TR",
                ["x"] = 100,
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
              ["order"] = 60,
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
                ["text"] = "[classcolor][abbrev:name]",
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
                ["name"] = "Right text 2",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "AFK",
              }, -- [8]
            },
            ["incAbsorb"] = {
              ["height"] = 0.5,
              ["enabled"] = false,
            },
            ["width"] = 100,
            ["fader"] = {
              ["height"] = 0.5,
              ["inactiveAlpha"] = 0.4,
              ["combatAlpha"] = 0.4,
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
              ["height"] = 0.8,
              ["order"] = 0,
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
              ["height"] = 0.5,
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
            ["groupSpacing"] = 0,
            ["powerBar"] = {
              ["enabled"] = false,
              ["colorType"] = "type",
              ["height"] = 0.3,
              ["background"] = false,
              ["order"] = 20,
            },
            ["groupsPerRow"] = 8,
            ["healthBar"] = {
              ["colorType"] = "static",
              ["order"] = 10,
              ["background"] = true,
              ["reactionType"] = "none",
              ["height"] = 1.2,
            },
            ["text"] = {
              nil, -- [1]
              {
                ["text"] = "",
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
                ["name"] = "Right text 2",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "AFK",
              }, -- [8]
            },
            ["maxColumns"] = 4,
            ["altPowerBar"] = {
              ["order"] = 100,
              ["background"] = true,
              ["height"] = 0.4,
            },
            ["height"] = 34,
            ["attribPoint"] = "BOTTOM",
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
            },
            ["scale"] = 0.85,
            ["range"] = {
              ["enabled"] = true,
              ["height"] = 0.5,
            },
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["emptyBar"] = {
              ["height"] = 1,
              ["background"] = true,
              ["order"] = 0,
              ["reactionType"] = "none",
            },
            ["offset"] = 2,
            ["unitsPerColumn"] = 5,
            ["width"] = 70,
            ["indicators"] = {
              ["raidTarget"] = {
                ["y"] = 0,
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["anchorPoint"] = "C",
                ["size"] = 20,
              },
              ["height"] = 0.5,
            },
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
            ["enabled"] = true,
            ["columnSpacing"] = 2,
          },
          ["maintank"] = {
            ["columnSpacing"] = 2,
            ["emptyBar"] = {
              ["height"] = 1,
              ["background"] = true,
              ["order"] = 0,
              ["reactionType"] = "none",
            },
            ["highlight"] = {
              ["height"] = 0.5,
              ["size"] = 10,
            },
            ["altPowerBar"] = {
              ["height"] = 0.4,
              ["background"] = true,
              ["order"] = 100,
            },
            ["range"] = {
              ["enabled"] = true,
              ["height"] = 0.5,
            },
            ["auras"] = {
              ["height"] = 0.5,
              ["debuffs"] = {
                ["enabled"] = true,
                ["enlarge"] = {
                  ["SELF"] = false,
                },
                ["y"] = 0,
                ["x"] = 0,
                ["anchorPoint"] = "BL",
                ["size"] = 20,
              },
              ["buffs"] = {
                ["perRow"] = 8,
                ["show"] = {
                  ["misc"] = false,
                },
                ["x"] = 0,
                ["enabled"] = true,
                ["anchorPoint"] = "BL",
                ["y"] = -2,
                ["size"] = 20,
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
              ["order"] = 60,
            },
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["powerBar"] = {
              ["colorType"] = "type",
              ["reverse"] = false,
              ["height"] = 0.2,
              ["background"] = false,
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
              ["sumPending"] = {
                ["anchorPoint"] = "C",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
                ["size"] = 40,
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
              ["height"] = 0.5,
            },
            ["offset"] = 26,
            ["unitsPerColumn"] = 5,
            ["healthBar"] = {
              ["colorType"] = "static",
              ["order"] = 10,
              ["background"] = true,
              ["reactionType"] = "npc",
              ["height"] = 1.2,
            },
            ["incHeal"] = {
              ["height"] = 0.5,
              ["cap"] = 1,
            },
            ["attribAnchorPoint"] = "LEFT",
            ["text"] = {
              {
                ["text"] = "[classcolor][name][close( )][levelcolor][close][( )afk][( )status]",
                ["width"] = 2.2,
              }, -- [1]
              {
                ["text"] = "[hp:color][perhp]",
                ["width"] = 1,
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
                ["name"] = "Right text 2",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 0.5,
                ["name"] = "AFK",
              }, -- [8]
            },
            ["width"] = 150,
            ["maxColumns"] = 1,
            ["fader"] = {
              ["height"] = 0.5,
            },
            ["combatText"] = {
              ["enabled"] = false,
              ["height"] = 0.5,
            },
            ["height"] = 44,
            ["portrait"] = {
              ["type"] = "3D",
              ["alignment"] = "LEFT",
              ["fullAfter"] = 50,
              ["height"] = 0.5,
              ["fullBefore"] = 0,
              ["order"] = 15,
              ["width"] = 0.22,
            },
            ["attribPoint"] = "BOTTOM",
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
                ["y"] = 0,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
              ["height"] = 0.6,
              ["background"] = true,
              ["icon"] = "HIDE",
              ["order"] = 40,
            },
            ["auraIndicators"] = {
              ["height"] = 0.5,
            },
            ["powerBar"] = {
              ["predicted"] = true,
              ["height"] = 0.2,
              ["order"] = 20,
              ["background"] = false,
              ["invert"] = false,
              ["colorType"] = "type",
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
                ["text"] = "|cff19a0ff[( )curpp]",
                ["width"] = 1,
                ["y"] = -8,
                ["x"] = -3,
                ["name"] = "Right text 2",
                ["anchorPoint"] = "CRI",
              }, -- [7]
              {
                ["anchorTo"] = "$healthBar",
                ["width"] = 1,
                ["name"] = "AFK",
              }, -- [8]
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
                ["anchorPoint"] = "BL",
                ["x"] = 0,
                ["anchorTo"] = "$parent",
                ["y"] = 0,
              },
              ["height"] = 0.5,
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
            ["enabled"] = true,
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
                ["enabled"] = true,
                ["y"] = -2,
                ["x"] = 0,
                ["perRow"] = 9,
                ["anchorPoint"] = "BR",
                ["show"] = {
                  ["misc"] = false,
                },
                ["size"] = 22,
              },
            },
            ["castBar"] = {
              ["enabled"] = true,
              ["time"] = {
                ["y"] = 0,
                ["x"] = -1,
                ["anchorTo"] = "$parent",
                ["enabled"] = true,
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
              ["order"] = 60,
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
            ["offset"] = 30,
            ["healthBar"] = {
              ["order"] = 10,
              ["reactionType"] = "none",
              ["vertical"] = false,
              ["background"] = true,
              ["reverse"] = false,
              ["height"] = 1.2,
              ["colorDispel"] = false,
              ["invert"] = false,
              ["colorType"] = "static",
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
                ["name"] = "Right text 2",
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
            ["enabled"] = true,
            ["attribPoint"] = "BOTTOM",
          },
        },
        ["revisionClassic"] = 4,
        ["font"] = {
          ["color"] = {
            ["a"] = 1,
            ["r"] = 0.96078431372549,
            ["g"] = 1,
            ["b"] = 0.92156862745098,
          },
          ["name"] = "MUI_Font",
          ["extra"] = "",
          ["shadowColor"] = {
            ["a"] = 1,
            ["b"] = 0,
            ["g"] = 0,
            ["r"] = 0,
          },
          ["shadowY"] = -1,
          ["shadowX"] = 1,
          ["size"] = 10,
        },
        ["backdrop"] = {
          ["borderColor"] = {
            ["a"] = 1,
            ["b"] = 0,
            ["g"] = 0,
            ["r"] = 0,
          },
          ["edgeSize"] = 1,
          ["tileSize"] = 20,
          ["borderTexture"] = "Pixel",
          ["backgroundColor"] = {
            ["a"] = 1,
            ["b"] = 0,
            ["g"] = 0,
            ["r"] = 0,
          },
          ["backgroundTexture"] = "Solid",
          ["clip"] = 1,
          ["inset"] = 0,
        },
        ["classColors"] = {
          ["DEATHKNIGHT"] = {
            ["a"] = 1,
            ["b"] = 0.23,
            ["g"] = 0.12,
            ["r"] = 0.77,
          },
          ["WARRIOR"] = {
            ["a"] = 1,
            ["b"] = 0.43,
            ["g"] = 0.61,
            ["r"] = 0.78,
          },
          ["SHAMAN"] = {
            ["a"] = 1,
            ["b"] = 0.87,
            ["g"] = 0.44,
            ["r"] = 0,
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
          ["ROGUE"] = {
            ["a"] = 1,
            ["b"] = 0.41,
            ["g"] = 0.96,
            ["r"] = 1,
          },
          ["HUNTER"] = {
            ["a"] = 1,
            ["b"] = 0.45,
            ["g"] = 0.83,
            ["r"] = 0.67,
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
        ["omnicc"] = true,
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
    },
  };
  
  for k, v in pairs(settings) do
		_G.ShadowedUFDB[k] = v;
	end
end