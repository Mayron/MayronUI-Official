-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db, _, _, _, L = MayronUI:GetCoreComponents();
local C_ToolTipsModule = namespace.C_ToolTipsModule;
local widgets = {};

function C_ToolTipsModule:GetConfigTable()
    return {
        type = "menu",
        module = "ToolTips",
        dbPath = "profile.tooltips",
        children =  {
            {   name = L["Enabled"],
                tooltip = "If checked, this module will be enabled.",
                type = "check",
                requiresReload = true,
                appendDbPath = "enabled",
            },
            {   name = "Unit Options",
                type = "title",
            };
            {   content = "These options only affect tool-tips that appear when you mouse over a unit, such as an NPC or player.",
                type = "fontstring",
            };
            {   name = "Show Target",
                tooltip = "If checked, the target of the unit (NPC or player) displayed in the tooltip will be shown.",
                type = "check",
                appendDbPath = "targetShown",
            },
            {   name = "Show Guild Rank",
                tooltip = "If checked and the player is in a guild, the guild rank of the player displayed in the tooltip will be shown.",
                type = "check",
                appendDbPath = "guildRankShown",
            },
            {   name = "Show Item Level",
                tooltip = "If checked and the player is level 10 or higher, the item level of the player displayed in the tooltip will be shown.\n\nThe player must be in range to be inpected for this information to be loaded.",
                type = "check",
                client = "retail";
                appendDbPath = "itemLevelShown",
            },
            {   name = "Show Specialization",
                tooltip = "If checked and the player is level 10 or higher and has chosen a class specialization, the specialization of the player displayed in the tooltip will be shown.\n\nThe player must be in range to be inpected for this information to be loaded.",
                type = "check",
                client = "retail";
                appendDbPath = "specShown",
            },
            {   name = "Show Guild Rank",
                tooltip = "If checked and the player is in a guild, the guild rank of the player displayed in the tooltip will be shown.",
                type = "check",
                appendDbPath = "guildRankShown",
            },
            {   name = "Appearance Options",
                type = "title",
            };
            {   content = "These options allow you to customize the appearance of the tool-tips.",
                type = "fontstring",
            };
            {   name = L["Font Type"];
                type = "dropdown";
                appendDbPath = "font";
                fontPicker = true;
                options = tk.Constants.LSM:List("font");
            };
            {   name = "Font Flag",
                type = "dropdown",
                appendDbPath = "flag",
                options = {
                  None = "None",
                  Outline = "OUTLINE",
                  ["Thick Outline"] = "THICKOUTLINE",
                  Monochrome = "MONOCHROME"
                } -- TODO: Test if label and value are correct
            };
            {   name = "Standard Font Size";
                type = "slider";
                tooltip = "Default is 14";
                step = 1;
                min = 8;
                max = 20;
                appendDbPath = "standardFontSize";
            };
            {   name = "Header Font Size";
                type = "slider";
                tooltip = "Default is 16";
                step = 1;
                min = 8;
                max = 20;
                appendDbPath = "headerFontSize";
            };
            {   name = "Scale";
                type = "slider";
                tooltip = "Default is 0.8";
                step = 0.1;
                min = 0.5;
                max = 1.5;
                appendDbPath = "scale";
            };
            {   type = "fontstring",
                subtype = "header",
                content = "Reskin using the MUI texture or a custom backdrop",
            },
            {   name = "MUI Texture";
                type = "radio";
                groupName = "tooltip_texture";
                appendDbPath = "muiTexture.enabled";
            },
            {   name = "Custom Backdrop";
                type = "radio";
                groupName = "tooltip_texture";
                appendDbPath = "muiTexture.enabled";
                SetValue = function(path, value, ...)
                    print(path, value, ...)
                    -- db:SetPathValue(path, value); -- TODO: Test this!
                    -- TODO: Need to enable or show other options if checked
                end;
            },
            {   name = "Anchor Options",
                type = "title",
            };
            {   type = "fontstring",
                subtype = "header",
                content = "Unit Tool-Tip Anchor Point",
            },
            {   name = "Mouse Cursor";
                type = "radio";
                groupName = "unit_anchor_type";
                appendDbPath = "anchors.units.type";

                SetValue = function(path, value, ...)
                  print(path, value, ...)
                  -- db:SetPathValue(path, value); -- TODO: Test this!
                  -- TODO: Need to enable or show other options if checked
                end;
            },
            {   name = "Screen Corner";
                type = "radio";
                groupName = "unit_anchor_type";
                appendDbPath = "anchors.units.type";

                SetValue = function(path, value, ...)
                  print(path, value, ...)
                  -- db:SetPathValue(path, value); -- TODO: Test this!
                  -- TODO: Need to enable or show other options if checked
                end;
            },
            {   type = "fontstring",
                subtype = "header",
                content = "Standard Tool-Tip Anchor Point",
            },
            {   name = "Mouse Cursor";
                type = "radio";
                groupName = "standard_anchor_type";
                appendDbPath = "anchors.other.type";

                SetValue = function(path, value, ...)
                  print(path, value, ...)
                  -- db:SetPathValue(path, value); -- TODO: Test this!
                  -- TODO: Need to enable or show other options if checked
                end;
            },
            {   name = "Screen Corner";
                type = "radio";
                groupName = "standard_anchor_type";
                appendDbPath = "anchors.other.type";

                SetValue = function(path, value, ...)
                  print(path, value, ...)
                  -- db:SetPathValue(path, value); -- TODO: Test this!
                  -- TODO: Need to enable or show other options if checked
                end;
            },
            {   name = "Health Bar",
                type = "title",
            };
            {   name = L["Font Size"];
                type = "slider";
                tooltip = "Default is 14";
                step = 1;
                min = 8;
                max = 20;
                appendDbPath = "healthBar.fontSize";
            };
            {   name         = L["Height"];
                type         = "textfield";
                valueType    = "number";
                tooltip      = "Minumum value is 4, maximum value is 30, and default is 18";
                min = 4;
                max = 30;
                appendDbPath = "healthBar.height";
            };
            {   type = "dropdown";
                name = L["Bar Texture"];
                options = tk.Constants.LSM:List("statusbar");
                appendDbPath = "healthBar.texture";
            };
            {   name = "Text Format",
                tooltip = "Set the text format of the value that appears on the status bar.";
                type = "dropdown",
                appendDbPath = "healthBar.format",
                options = {
                  Percentage = "%",
                  Current = "n",
                  ["Current/Maximum"] = "n/n",
                } -- TODO: Test if label and value are correct
            };
            {   name = "Power Bar",
                type = "title",
            };
            {   name = L["Enabled"],
                tooltip = "If checked, unit tool-tips will show the unit's power bar.",
                type = "check",
                appendDbPath = "powerBar.enabled",
            },
            {   name = L["Font Size"];
                type = "slider";
                tooltip = "Default is 14";
                step = 1;
                min = 8;
                max = 20;
                appendDbPath = "powerBar.fontSize";
            };
            {   name         = L["Height"];
                type         = "textfield";
                valueType    = "number";
                tooltip      = "Minumum value is 4, maximum value is 30, and default is 18";
                min = 4;
                max = 30;
                appendDbPath = "powerBar.height";
            };
            {   type = "dropdown";
                name = L["Bar Texture"];
                options = tk.Constants.LSM:List("statusbar");
                appendDbPath = "powerBar.texture";
            };
            {   name = "Text Format",
                tooltip = "Set the text format of the value that appears on the status bar.";
                type = "dropdown",
                appendDbPath = "powerBar.format",
                options = {
                  Percentage = "%",
                  Current = "n",
                  ["Current/Maximum"] = "n/n",
                } -- TODO: Test if label and value are correct
            };
            {   name = "Unit Aura Options",
                type = "title",
            };
            {   type = "fontstring",
                subtype = "header",
                content = "Buffs",
            },
            {   name = L["Enabled"],
                tooltip = "If checked, unit tool-tips will show the unit's buffs.",
                type = "check",
                appendDbPath = "auras.buffs.enabled",
            },
            {   name = L["Only show buffs applied by me"];
                appendDbPath =  "auras.buffs.onlyYours";
                type = "check";
            };
            {   name = L["Size"];
                type = "slider";
                tooltip = "Default is 28";
                step = 1;
                min = 20;
                max = 40;
                appendDbPath = "auras.buffs.size";
            };
            {   name = "Position",
                tooltip = "Set whether you want the unit's buffs to appear above or below the tool-tip.";
                type = "dropdown",
                appendDbPath = "auras.buffs.position",
                options = {
                  Above = "TOP",
                  Below = "BOTTOM",
                } -- TODO: Test if label and value are correct
            };
            {   name = L["Growth Direction"],
                type = "dropdown",
                appendDbPath = "auras.buffs.direction",
                options = { ["Left to Right"] = "ltr", ["Right to Left"] = "rtl" }
            };
            {   type = "fontstring",
                subtype = "header",
                content = "Debuffs",
            },
            {   name = L["Enabled"],
                tooltip = "If checked, unit tool-tips will show the unit's debuffs.",
                type = "check",
                appendDbPath = "auras.debuffs.enabled",
            },
            {   name = L["Only show debuffs applied by me"];
                appendDbPath = "auras.debuffs.onlyYours";
                type = "check";
            };
            {   name = "Show debuffs above the buffs";
                tooltip = "If both the buffs and debuffs are positioned together (either above or below the tool-tip) and are both enabled, then the debuffs will be above the buffs if this option is enabled.";
                appendDbPath = "auras.debuffs.aboveBuffs";
                type = "check";
            };
            {   name = "Set border color by debuff type";
                tooltip = "If enabled, the border color of debuffs will be based on the type of debuff (e.g., poisons will appear with a green border color).";
                appendDbPath = "auras.debuffs.colorByDebuffType";
                type = "check";
            };
            {   name = L["Size"];
                type = "slider";
                tooltip = "Default is 28";
                step = 1;
                min = 20;
                max = 40;
                appendDbPath = "auras.debuffs.size";
            };
            {   name = "Position",
                tooltip = "Set whether you want the unit's debuffs to appear above or below the tool-tip.";
                type = "dropdown",
                appendDbPath = "auras.debuffs.position",
                options = {
                  Above = "TOP",
                  Below = "BOTTOM",
                } -- TODO: Test if label and value are correct
            };
            {   name = L["Growth Direction"],
                type = "dropdown",
                appendDbPath = "auras.debuffs.direction",
                options = { ["Left to Right"] = "ltr", ["Right to Left"] = "rtl" }
            };
        }
    };
end