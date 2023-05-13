-- luacheck: ignore MayronUI self 143 631

local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();
local C_ToolTipsModule = MayronUI:GetModuleClass("Tooltips");

local muiTextureSubmenu, customBackdropSubmenu;
local screenPointXOffsetTextField, screenPointYOffsetTextField;
local screenPointDropdown; ---@type DropDownMenu
local tostring = _G.tostring;

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
        module = "Tooltips",
        dbPath = "profile.tooltips",
        children =  {
            {   name = L["Enabled"],
                tooltip = L["If checked, this module will be enabled."],
                type = "check",
                requiresReload = true,
                appendDbPath = "enabled",
            },
            {   name = L["Unit Tooltip Options"],
                type = "title",
            };
            {   content = L["These options only affect tooltips that appear when you mouse over a unit, such as an NPC or player."],
                type = "fontstring",
            };
            {   name = L["Show Target"],
                tooltip = L["If checked, the target of the unit (NPC or player) displayed in the tooltip will be shown."],
                type = "check",
                appendDbPath = "targetShown",
            },
            {   name = L["Show Guild Rank"],
                tooltip = L["If checked and the player is in a guild, the guild rank of the player displayed in the tooltip will be shown."],
                type = "check",
                appendDbPath = "guildRankShown",
            },
            {   name = L["Show Realm Name"],
                type = "check",
                appendDbPath = "realmShown",
                client = "retail";
            },
            {   name = L["Show Item Level"],
                tooltip = tk.Strings:Join("\n\n",
                  L["If checked and the player is level 10 or higher, the item level of the player displayed in the tooltip will be shown."],
                  L["The player must be close enough to be inspected for this information to load."]),
                type = "check",
                appendDbPath = "itemLevelShown",
            },
            {   name = L["Show Specialization"],
                tooltip = tk.Strings:Join("\n\n",
                  L["If checked and the player is level 10 or higher and has chosen a class specialization, the specialization of the player displayed in the tooltip will be shown."],
                  L["The player must be close enough to be inspected for this information to load."]),
                type = "check",
                appendDbPath = "specShown",
            },
            {   name = L["Positioning and Visibility Options"],
                description = L["Configure each type of anchor point and tooltip type"];
                type = "title",
            };
            {   type = "fontstring",
                subtype = "sub-header",
                content = "TIPS:",
            },
            {
              type = "fontstring",
              list = {
                L["Assigning tooltips to the mouse anchor point will fix them to your mouse cursor, causing them to follow your mouse movements."];
                L["Assigning tooltips to the screen anchor point will fix them to that single spot and will not move."];
                L["World units are 3D player models within the world and are not part of the UI."];
                L["Unit frame tooltips are the UI frames that represent NPCs or players."];
                L["Standard tooltips are any other tooltip with no special category (i.e., inventory item and spell tooltips have their own unique category and will not be affected)."];
              }
            },
            { type = "loop";
              args = { L["Unit Frame Tooltips"]; L["World Unit Tooltips"]; L["Standard Tooltips"] };
              func = function(index, header)
                local settingsName = "standard";

                if (index == 1) then
                  settingsName = "unitFrames";
                elseif (index == 2) then
                  settingsName = "worldUnits";
                end

                local radioGroupName = settingsName.."_anchor_type";

                local children = {
                  { type = "fontstring";
                    subtype = "header";
                    content = header;
                  };
                  { type = "frame";
                    width = "50%";
                    appendDbPath = settingsName;
                    children = {
                      { type = "fontstring",
                        subtype = "sub-header",
                        content = L["Choose an Anchor Point:"],
                      };
                      { name = L["Mouse"];
                        type = "radio";
                        groupName = radioGroupName;
                        appendDbPath = "anchor";

                        GetValue = function(_, value)
                            return value == "mouse";
                        end;

                        SetValue = function(self, value)
                          db:SetPathValue(self.dbPath, value and "mouse" or "screen");
                        end;
                      };
                      { name = L["Screen"];
                        type = "radio";
                        groupName = radioGroupName;
                        appendDbPath = "anchor";

                        GetValue = function(_, value)
                          return value == "screen";
                        end;

                        SetValue = function(self, value)
                          db:SetPathValue(self.dbPath, value and "screen" or "mouse");
                        end;
                      },
                    }
                  };
                  {
                    type = "frame";
                    width = "50%";
                    appendDbPath = settingsName;
                    children = {
                      { type = "fontstring",
                        subtype = "sub-header",
                        content = L["Visibility Options:"],
                      },
                      { type = "check";
                        name = L["Set Shown"];
                        tooltip = L["If unchecked, tooltips of this type will never show"];
                        appendDbPath = "show";
                      };
                      { type = "check";
                        name = L["Hide in Combat"];
                        tooltip = L["If unchecked, tooltips of this type will not show while you are in combat."];
                        appendDbPath = "hideInCombat";
                      };
                    }
                  };
                };

                return children;
              end
            };
            { type = "fontstring",
              subtype = "header",
              content = L["Mouse Anchor Point"],
            };
            { name = "Point",
              tooltip = L["The bottom-[point] corner of the tooltip, where [point] is either 'Left' or 'Right', will be anchored to the position of the mouse cursor."];
              type = "dropdown",
              appendDbPath = "anchors.mouse.point",
              options = {
                [L["Left"]] = "ANCHOR_CURSOR_LEFT",
                [L["Right"]] = "ANCHOR_CURSOR_RIGHT"
              }
            };
            { type = "slider";
              name = L["X-Offset"];
              tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "2");
              appendDbPath = "anchors.mouse.xOffset";
              min = -20,
              max = 20
            };
            { type = "slider";
              name = L["Y-Offset"];
              tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "4");
              appendDbPath = "anchors.mouse.yOffset";
              min = -20,
              max = 20
            };
            { type = "fontstring",
              subtype = "header",
              content = L["Screen Anchor Point"],
            },
            {
              name = L["Unlock"],
              type = "button",
              data = { data.screenAnchor };
              OnClick = UnlockScreenAnchor
            },
            { type = "divider"; };
            {   type = "dropdown";
                name = L["Point"];
                options = tk.Constants.POINT_OPTIONS;
                appendDbPath = "anchors.screen.point";
                OnLoad = function(_, container)
                  screenPointDropdown = container.component.dropdown;
                end;
            };
            {   type = "textfield";
                name = L["X-Offset"];
                valueType = "number";
                tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "-4");
                appendDbPath = "anchors.screen.xOffset";
                OnLoad = function(_, container)
                  screenPointXOffsetTextField = container.component;
                end;
            };
            {   type = "textfield";
                valueType = "number";
                name = L["Y-Offset"];
                tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "4");
                appendDbPath = "anchors.screen.yOffset";
                OnLoad = function(_, container)
                  screenPointYOffsetTextField = container.component;
                end;
            };
            {   name = L["Appearance Options"],
                type = "title",
            };
            {   content = L["These options allow you to customize the appearance of the tooltips."],
                type = "fontstring",
            };
            {   name = L["Font Type"];
                type = "dropdown";
                appendDbPath = "font";
                fontPicker = true;
                options = tk.Constants.LSM:List("font");
            };
            {   name = L["Font Flag"],
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
            {   name = L["Standard Font Size"];
                type = "slider";
                tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "14");
                step = 1;
                min = 8;
                max = 20;
                appendDbPath = "standardFontSize";
            };
            {   name = L["Header Font Size"];
                type = "slider";
                tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "16");
                step = 1;
                min = 8;
                max = 30;
                appendDbPath = "headerFontSize";
            };
            {   name = L["Scale"];
                type = "slider";
                tooltip = tk.Strings:JoinWithSpace(L["Affects the overall size of the tooltips."], L["Default value is"], "0.8");
                step = 0.1;
                min = 0.5;
                max = 1.5;
                appendDbPath = "scale";
            };
            {   type = "fontstring",
                subtype = "header",
                content = L["Reskin using the MUI texture or a custom backdrop"],
            },
            {   name = tk.Strings:JoinWithSpace("MUI", L["Texture"]);
                type = "radio";
                groupName = "tooltip_texture";
                appendDbPath = "muiTexture.enabled";
                width = 250;

                SetValue = function(self, value)
                  muiTextureSubmenu:Enable();
                  customBackdropSubmenu:Disable();
                  db:SetPathValue(self.dbPath, value);
                end;
            },
            {   name = L["Custom Backdrop"];
                type = "radio";
                width = 250;
                groupName = "tooltip_texture";
                appendDbPath = "muiTexture.enabled";

                GetValue = function(_, value)
                  return not value;
                end;

                SetValue = function(self, value)
                  muiTextureSubmenu:Disable();
                  customBackdropSubmenu:Enable();
                  db:SetPathValue(self.dbPath, not value);
                end;
            },
            {   type = "divider" };
            {   name = tk.Strings:JoinWithSpace("MUI", L["Texture Options"]);
                type = "submenu";
                enabled = db.profile.tooltips.muiTexture.enabled;
                appendDbPath = "muiTexture";
                OnLoad = function(_, submenu)
                  muiTextureSubmenu = submenu;
                end;
                children = {
                    {   type = "fontstring";
                        content = L["The MUI texture controls both the background and border textures. If you want a more customized style, use the 'Custom Backdrop' style instead (see the previous menu)."];
                    };
                    {   name = L["Use MUI Theme Color"],
                        tooltip = L["If checked, the MUI texture will use your MUI theme color for both the background and border color (by default, this is class-colored)."];
                        type = "check",
                        appendDbPath = "useTheme",
                    },
                    {   name = L["Custom Color"];
                        tooltip = L["If not using the MUI theme color, the tooltip will use this custom color for both the background and border color."];
                        type = "color";
                        width = 200;
                        enabled = db.profile.tooltips.muiTexture.useTheme;
                        useIndexes = true;
                        appendDbPath = "custom";
                    };
                }
            };
            {   name = L["Custom Backdrop Options"];
                type = "submenu";
                appendDbPath = "backdrop";
                enabled = not db.profile.tooltips.muiTexture.enabled;
                OnLoad = function(_, submenu)
                  customBackdropSubmenu = submenu;
                end;
                children = {
                    { name = L["Color border by class or NPC type"],
                      tooltip = L["If checked, the backdrop border color will be based on the class of the player unit or the type of NPC unit."];
                      type = "check",
                      appendDbPath = "borderClassColored",
                    },
                    { name = L["Border Color"];
                      tooltip = L["If color border by class or NPC type is checked, this color will be used for all non-unit tooltips, else it will be used for every tooltip border."];
                      type = "color";
                      hasOpacity = true;
                      width = 200;
                      useIndexes = true;
                      appendDbPath = "borderColor";
                    };
                    { name = L["Background Color"];
                      type = "color";
                      hasOpacity = true;
                      width = 200;
                      useIndexes = true;
                      appendDbPath = "bgColor";
                    };
                    { type = "divider" };
                    { type = "dropdown",
                      name = L["Background Texture"];
                      options = tk.Constants.LSM:List(tk.Constants.LSM.MediaType.BACKGROUND);
                      appendDbPath = "bgFile";
                    };
                    { type = "dropdown",
                      name = L["Border Type"];
                      options = tk.Constants.LSM:List(tk.Constants.LSM.MediaType.BORDER);
                      appendDbPath = "edgeFile";
                    };
                    { type = "slider",
                      name = L["Border Size"];
                      tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "1");
                      step = 1;
                      min = 0;
                      max = 5;
                      appendDbPath = "edgeSize";
                      SetValue = function(self, value)
                        db:SetPathValue(self.dbPath, value + 0.25); -- fixes pixel perfect
                      end;
                    };
                    { type = "fontstring";
                      subtype = "header";
                      content = L["Border Insets"];
                    };
                    { name = L["Left"];
                      appendDbPath = "insets.left";
                      type = "slider";
                      min = -10;
                      max = 10;
                    };
                    { name = L["Right"];
                      appendDbPath = "insets.right";
                      type = "slider";
                      min = -10;
                      max = 10;
                    };
                    { name = L["Top"];
                      appendDbPath = "insets.top";
                      type = "slider";
                      min = -10;
                      max = 10;
                    };
                    { name      = L["Bottom"];
                      appendDbPath = "insets.bottom";
                      type = "slider";
                      min = -10;
                      max = 10;
                    };
                }
            };
            {   name = L["Health Bar"],
                type = "title",
            };
            {   name = L["Font Size"];
                type = "slider";
                tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "14");
                step = 1;
                min = 8;
                max = 20;
                appendDbPath = "healthBar.fontSize";
            };
            {   name = L["Font Flag"],
                type = "dropdown",
                appendDbPath = "healthBar.flag",
                options = tk.Constants.FONT_FLAG_DROPDOWN_OPTIONS
            };
            {   name         = L["Height"];
                type         = "slider";
                tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "18");
                min = 4;
                max = 50;
                appendDbPath = "healthBar.height";
            };
            {   type = "dropdown";
                name = L["Bar Texture"];
                options = tk.Constants.LSM:List("statusbar");
                appendDbPath = "healthBar.texture";
            };
            {   name = L["Text Format"],
                tooltip = L["Set the text format of the value that appears on the status bar. Set this to 'None' to hide the text."];
                type = "dropdown",
                appendDbPath = "healthBar.format",
                options = {
                  [L["None"]] = "",
                  [L["Percentage"]] = "%",
                  [L["Current"]] = "n",
                  [L["Current/Maximum"]] = "n/n",
                }
            };
            {   name = L["Power Bar"],
                type = "title",
            };
            {   name = L["Enabled"],
                tooltip = L["If checked, unit tooltips will show the unit's power bar."],
                type = "check",
                appendDbPath = "powerBar.enabled",
            },
            {   name = L["Font Size"];
                type = "slider";
                tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "14");
                step = 1;
                min = 8;
                max = 20;
                appendDbPath = "powerBar.fontSize";
            };
            {   name = L["Font Flag"],
                type = "dropdown",
                appendDbPath = "powerBar.flag",
                options = tk.Constants.FONT_FLAG_DROPDOWN_OPTIONS;
            };
            {   name         = L["Height"];
                type         = "slider";
                tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "18");
                min = 4;
                max = 50;
                appendDbPath = "powerBar.height";
            };
            {   type = "dropdown";
                name = L["Bar Texture"];
                options = tk.Constants.LSM:List("statusbar");
                appendDbPath = "powerBar.texture";
            };
            {   name = L["Text Format"],
                tooltip = L["Set the text format of the value that appears on the status bar. Set this to 'None' to hide the text."];
                type = "dropdown",
                appendDbPath = "powerBar.format",
                options = {
                  [L["None"]] = "",
                  [L["Percentage"]] = "%",
                  [L["Current"]] = "n",
                  [L["Current/Maximum"]] = "n/n",
                }
            };
            {   name = L["Unit Aura Options"],
                type = "title",
            };
            {   type = "fontstring",
                subtype = "header",
                content = L["Buffs"],
            },
            {   name = L["Enabled"],
                tooltip = L["If checked, unit tooltips will show the unit's buffs."],
                type = "check",
                appendDbPath = "auras.buffs.enabled",
            },
            {   name = L["Only show buffs applied by me"];
                appendDbPath =  "auras.buffs.onlyYours";
                type = "check";
            };
            {   name = L["Size"];
                type = "slider";
                tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "28");
                step = 1;
                min = 20;
                max = 40;
                appendDbPath = "auras.buffs.size";
            };
            {   name = L["Position"],
                tooltip = L["Set whether you want the unit's buffs to appear above or below the tooltip."];
                type = "dropdown",
                appendDbPath = "auras.buffs.position",
                options = {
                  [L["Above"]] = "TOP",
                  [L["Below"]] = "BOTTOM",
                };
            };
            {   name = L["Growth Direction"],
                type = "dropdown",
                appendDbPath = "auras.buffs.direction",
                options = { [L["Left to Right"]] = "ltr", [L["Right to Left"]] = "rtl" }
            };
            {   type = "fontstring",
                subtype = "header",
                content = L["Debuffs"],
            },
            {   name = L["Enabled"],
                tooltip = L["If checked, unit tooltips will show the unit's debuffs."],
                type = "check",
                appendDbPath = "auras.debuffs.enabled",
            },
            {   name = L["Only show debuffs applied by me"];
                appendDbPath = "auras.debuffs.onlyYours";
                type = "check";
            };
            {   name = L["Set border color by debuff type"];
                tooltip = L["If enabled, the border color of debuffs will be based on the type of debuff (e.g., poisons will appear with a green border color)."];
                appendDbPath = "auras.debuffs.colorByDebuffType";
                type = "check";
            };
            {   name = L["Size"];
                type = "slider";
                tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "28");
                step = 1;
                min = 20;
                max = 40;
                appendDbPath = "auras.debuffs.size";
            };
            {   name = L["Position"],
                tooltip = L["Set whether you want the unit's debuffs to appear above or below the tooltip."];
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
                options = { [L["Left to Right"]] = "ltr", [L["Right to Left"]] = "rtl" }
            };
            {   type = "fontstring";
                subtype = "header";
                content = L["Buff and Debuff Ordering"]
            };
            {   type = "fontstring";
                height = 40;
                content = L["AURAS_ORDERING_ON_TOOLTIP"]
            };
            {   name = L["Debuffs Above Buffs"];
                appendDbPath = "auras.debuffs.aboveBuffs";
                type = "radio";
                groupName = "aura_ordering";
            };
            {   name = L["Buffs Above Debuffs"];
                appendDbPath = "auras.debuffs.aboveBuffs";
                type = "radio";
                groupName = "aura_ordering";

                GetValue = function(_, value)
                  return not value;
                end;

                SetValue = function(self, value)
                  db:SetPathValue(self.dbPath, not value);
                end;
            };
        }
    };
end