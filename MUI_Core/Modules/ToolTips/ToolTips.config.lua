-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();
local C_ToolTipsModule = namespace.C_ToolTipsModule;
local muiTextureSubmenu, customBackdropSubmenu;
local screenPointXOffsetTextField, screenPointYOffsetTextField, screenPointDropdown;

local function UnlockScreenAnchor(button, screenAnchor)
  screenAnchor.unlocked = not screenAnchor.unlocked;

  if (screenAnchor.unlocked) then
    screenAnchor:Unlock();
    button:SetText(L["Lock"]);
  else
    local positions = screenAnchor:Lock();

    if (obj:IsTable(positions)) then
      local selectedOption = screenPointDropdown:FindOption(function(o)
        return o.args[1] == tostring(positions[1]);
      end);

      screenPointDropdown:SetLabel(selectedOption:GetText());
      screenPointXOffsetTextField:SetText(tostring(positions[4]));
      screenPointYOffsetTextField:SetText(tostring(positions[5]));
    end

    button:SetText(L["Unlock"]);
  end
end

function C_ToolTipsModule:GetConfigTable(data)
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
            {   name = "In Combat Options",
                type = "title",
            };
            {   name = "Show Unit Tool-Tips In Combat",
                type = "check",
                appendDbPath = "combat.showUnit",
                tooltip = "Unit tool-tips display player and NPC information while\nyour mouse cursor is over a unit in the game world.";
            },
            {   name = "Show Standard Tool-Tips In Combat",
                tooltip = "Standard tool-tips display non-unit related information,\nsuch as action-bar abilities, buffs and debuffs, etc...";
                type = "check",
                appendDbPath = "combat.showStandard",
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
                }
            };
            { type = "divider" };
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
                max = 30;
                appendDbPath = "headerFontSize";
            };
            {   name = "Scale";
                type = "slider";
                tooltip = "Affects the overall size of the tool-tips. Default is 0.8";
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
                width = 250;

                SetValue = function(path, value)
                  muiTextureSubmenu:Enable();
                  customBackdropSubmenu:Disable();
                  db:SetPathValue(path, value);
                end;
            },
            {   name = "Custom Backdrop";
                type = "radio";
                width = 250;
                groupName = "tooltip_texture";
                appendDbPath = "muiTexture.enabled";

                GetValue = function(_, value)
                  return not value;
                end;

                SetValue = function(path, value)
                  muiTextureSubmenu:Disable();
                  customBackdropSubmenu:Enable();
                  db:SetPathValue(path, not value);
                end;
            },
            { type = "divider" };
            {   name = "MUI Texture Options";
                type = "submenu";
                enabled = db.profile.tooltips.muiTexture.enabled;
                appendDbPath = "muiTexture";
                OnLoad = function(_, submenu)
                  muiTextureSubmenu = submenu;
                end;
                children = {
                    {   type = "fontstring";
                        content = "The MUI texture controls both the background and border textures. If you want a more customized style, use the \"Custom Backdrop\" style instead (see previous menu).";
                    };
                    {   name = "Use MUI Theme Color",
                        tooltip = "If checked, the MUI texture will use your MUI theme color for both the background and border color (by default, this is class colored).";
                        type = "check",
                        appendDbPath = "useTheme",
                    },
                    {   name = "Custom Color";
                        tooltip = "If not using the MUI theme color, the tool-tip will use this custom color for both the background and bolor color.";
                        type = "color";
                        width = 200;
                        enabled = db.profile.tooltips.muiTexture.useTheme;
                        useIndexes = true;
                        appendDbPath = "custom";
                    };
                }
            };
            {   name = "Custom Backdrop Options";
                type = "submenu";
                appendDbPath = "backdrop";
                enabled = not db.profile.tooltips.muiTexture.enabled;
                OnLoad = function(_, submenu)
                  customBackdropSubmenu = submenu;
                end;
                children = {
                    {   name = "Color border by class or NPC type",
                        tooltip = "If checked, the backdrop border color will be based on the class of the player unit or the type of NPC unit.";
                        type = "check",
                        appendDbPath = "borderClassColored",
                    },
                    {   name = "Border Color";
                        tooltip = "If color border by class or NPC type is checked, this color will be used for all non-unit tool-tips, else it will be used for every tool-tip border.";
                        type = "color";
                        hasOpacity = true;
                        width = 200;
                        useIndexes = true;
                        appendDbPath = "borderColor";
                    };
                    {   name = "Background Color";
                        type = "color";
                        hasOpacity = true;
                        width = 200;
                        useIndexes = true;
                        appendDbPath = "bgColor";
                    };
                    {   type = "divider"
                    };
                    {   type = "dropdown",
                        name = "Background Texture";
                        options = tk.Constants.LSM:List(tk.Constants.LSM.MediaType.BACKGROUND);
                        appendDbPath = "bgFile";
                    };
                    {   type = "dropdown",
                        name = "Border Type";
                        options = tk.Constants.LSM:List(tk.Constants.LSM.MediaType.BORDER);
                        appendDbPath = "edgeFile";
                    };
                    {   type = "slider",
                        name = "Border Size";
                        tooltip = "Default is 1";
                        step = 1;
                        min = 0;
                        max = 5;
                        appendDbPath = "edgeSize";
                        SetValue = function(path, value)
                          db:SetPathValue(path, value + 0.25); -- fixes pixel perfect
                        end;
                    };
                    {    type = "fontstring";
                        subtype = "header";
                        content = "Border Insets";
                    };
                    {   name         = "Left";
                        type         = "textfield";
                        valueType    = "number";
                        tooltip      = "Minumum value is -10, maximum value is 10, and default is 1";
                        min = -10;
                        max = 10;
                        appendDbPath = "insets.left";
                    };
                    {   name         = "Right";
                        type         = "textfield";
                        valueType    = "number";
                        tooltip      = "Minumum value is -10, maximum value is 10, and default is 1";
                        min = -10;
                        max = 10;
                        appendDbPath = "insets.right";
                    };
                    {   name         = "Top";
                        type         = "textfield";
                        valueType    = "number";
                        tooltip      = "Minumum value is -10, maximum value is 10, and default is 1";
                        min = -10;
                        max = 10;
                        appendDbPath = "insets.top";
                    };
                    {   name         = "Bottom";
                        type         = "textfield";
                        valueType    = "number";
                        tooltip      = "Minumum value is -10, maximum value is 10, and default is 1";
                        min = -10;
                        max = 10;
                        appendDbPath = "insets.bottom";
                    };
                }
            };
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
                appendDbPath = "anchors.units";

                GetValue = function(_, value)
                  return value == "mouse";
                end;

                SetValue = function(path, value)
                  db:SetPathValue(path, value and "mouse" or "screen");
                end;
            },
            {   name = "Screen Corner";
                type = "radio";
                groupName = "unit_anchor_type";
                appendDbPath = "anchors.units";

                GetValue = function(_, value)
                  return value == "screen";
                end;

                SetValue = function(path, value)
                  db:SetPathValue(path, value and "screen" or "mouse");
                end;
            },
            {   type = "fontstring",
                subtype = "header",
                content = "Standard Tool-Tip Anchor Point",
            },
            {   name = "Mouse Cursor";
                type = "radio";
                groupName = "standard_anchor_type";
                appendDbPath = "anchors.standard";

                GetValue = function(_, value)
                  return value == "mouse";
                end;

                SetValue = function(path, value)
                  db:SetPathValue(path, value and "mouse" or "screen");
                end;
            },
            {   name = "Screen Corner";
                type = "radio";
                groupName = "standard_anchor_type";
                appendDbPath = "anchors.standard";

                GetValue = function(_, value)
                  return value == "screen";
                end;

                SetValue = function(path, value)
                  db:SetPathValue(path, value and "screen" or "mouse");
                end;
            },
            {   type = "fontstring",
                subtype = "header",
                content = "Mouse Cursor Positioning",
            },
            --ANCHOR_CURSOR_RIGHT
            {   name = "Point",
                tooltip = "The bottom-[point] corner of the tool-tip, where [point] is either\n\"Left\" or \"Right\", will be anchored to the position of the mouse cursor.";
                type = "dropdown",
                appendDbPath = "anchors.mouseAnchor.point",
                options = {
                  ["Left"] = "ANCHOR_CURSOR_Left",
                  ["Right"] = "ANCHOR_CURSOR_RIGHT"
                }
            };
            {   type = "slider";
                name = L["X-Offset"];
                tooltip = "Default is 2";
                appendDbPath = "anchors.mouseAnchor.xOffset";
                min = -20,
                max = 20
            };
            {   type = "slider";
                name = L["Y-Offset"];
                tooltip = "Default is 4";
                appendDbPath = "anchors.mouseAnchor.yOffset";
                min = -20,
                max = 20
            };
            {   type = "fontstring",
                subtype = "header",
                content = "Screen Corner Positioning",
            },
            {
              name = L["Unlock"],
              type = "button",
              data = { data.screenAnchor };
              OnClick = UnlockScreenAnchor
            },
            {   type = "divider"
            };
            {   type = "dropdown";
                name = "Point";
                options = tk.Constants.POINTS;
                appendDbPath = "anchors.screenAnchor.point";
                OnLoad = function(_, container)
                  screenPointDropdown = container.widget;
                end;
            };
            {   type = "textfield";
                name = L["X-Offset"];
                valueType    = "number";
                tooltip = "Default is -4";
                appendDbPath = "anchors.screenAnchor.xOffset";
                OnLoad = function(_, container)
                  screenPointXOffsetTextField = container.widget;
                end;
            };
            {   type = "textfield";
                valueType    = "number";
                name = L["Y-Offset"];
                tooltip = "Default is 4";
                appendDbPath = "anchors.screenAnchor.yOffset";
                OnLoad = function(_, container)
                  screenPointYOffsetTextField = container.widget;
                end;
            };
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
            {   name = "Font Flag",
                type = "dropdown",
                appendDbPath = "healthBar.flag",
                options = {
                  None = "None",
                  Outline = "OUTLINE",
                  ["Thick Outline"] = "THICKOUTLINE",
                  Monochrome = "MONOCHROME"
                }
            };
            {   name         = L["Height"];
                type         = "slider";
                tooltip      = "Default is 18";
                min = 4;
                max = 50;
                appendDbPath = "healthBar.height";
            };
            {   type = "dropdown";
                name = L["Bar Texture"];
                options = tk.Constants.LSM:List("statusbar");
                appendDbPath = "healthBar.texture";
            };
            {   name = "Text Format",
                tooltip = "Set the text format of the value that appears on the status bar.\nSet this to \"None\" to hide the text.";
                type = "dropdown",
                appendDbPath = "healthBar.format",
                options = {
                  None = "",
                  Percentage = "%",
                  Current = "n",
                  ["Current/Maximum"] = "n/n",
                }
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
            {   name = "Font Flag",
                type = "dropdown",
                appendDbPath = "powerBar.flag",
                options = {
                  None = "None",
                  Outline = "OUTLINE",
                  ["Thick Outline"] = "THICKOUTLINE",
                  Monochrome = "MONOCHROME"
                }
            };
            {   name         = L["Height"];
                type         = "slider";
                tooltip      = "Default is 18";
                min = 4;
                max = 50;
                appendDbPath = "powerBar.height";
            };
            {   type = "dropdown";
                name = L["Bar Texture"];
                options = tk.Constants.LSM:List("statusbar");
                appendDbPath = "powerBar.texture";
            };
            {   name = "Text Format",
                tooltip = "Set the text format of the value that appears on the status bar.\nSet this to \"None\" to hide the text.";
                type = "dropdown",
                appendDbPath = "powerBar.format",
                options = {
                  None = "",
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
                };
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
                };
            };
            {   name = L["Growth Direction"],
                type = "dropdown",
                appendDbPath = "auras.debuffs.direction",
                options = { ["Left to Right"] = "ltr", ["Right to Left"] = "rtl" }
            };
            {   type = "fontstring";
                subtype = "header";
                content = "Buff and Debuff Ordering"
            };
            {   type = "fontstring";
                height = 40;
                content = "The below setting controls the ordering of auras on the tool-tip when both the buffs and debuffs are positioned together (either above or below the tool-tip) and are both enabled."
            };
            {   name = "Debuffs Above Buffs";
                appendDbPath = "auras.debuffs.aboveBuffs";
                type = "radio";
                groupName = "aura_ordering";
            };
            {   name = "Buffs Above Debuffs";
                appendDbPath = "auras.debuffs.aboveBuffs";
                type = "radio";
                groupName = "aura_ordering";

                GetValue = function(_, value)
                  return not value;
                end;

                SetValue = function(path, value)
                  db:SetPathValue(path, not value);
                end;
            };
        }
    };
end