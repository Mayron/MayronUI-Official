-- luacheck: ignore MayronUI self 143 631

local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();
local C_ToolTipsModule = MayronUI:GetModuleClass("Tooltips");

local customBackdropSubmenu;
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
                dbPath = "enabled",
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
                dbPath = "targetShown",
            },
            {   name = L["Show Guild Rank"],
                tooltip = L["If checked and the player is in a guild, the guild rank of the player displayed in the tooltip will be shown."],
                type = "check",
                dbPath = "guildRankShown",
            },
            {   name = L["Show Realm Name"],
                type = "check",
                dbPath = "realmShown",
                client = "retail";
            },
            {   name = L["Show Item Level"],
                tooltip = tk.Strings:Join("\n\n",
                  L["If checked and the player is level 10 or higher, the item level of the player displayed in the tooltip will be shown."],
                  L["The player must be close enough to be inspected for this information to load."]),
                type = "check",
                dbPath = "itemLevelShown",
            },
            {   name = L["Show Specialization"],
                tooltip = tk.Strings:Join("\n\n",
                  L["If checked and the player is level 10 or higher and has chosen a class specialization, the specialization of the player displayed in the tooltip will be shown."],
                  L["The player must be close enough to be inspected for this information to load."]),
                type = "check",
                dbPath = "specShown",
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
                    dbPath = "profile.tooltips."..settingsName;
                    children = {
                      { type = "fontstring",
                        subtype = "sub-header",
                        content = L["Choose an Anchor Point:"],
                      };
                      { name = L["Mouse"];
                        type = "radio";
                        groupName = radioGroupName;
                        dbPath = "anchor";

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
                        dbPath = "anchor";

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
                    dbPath = "profile.tooltips."..settingsName;
                    children = {
                      { type = "fontstring",
                        subtype = "sub-header",
                        content = L["Visibility Options:"],
                      },
                      { type = "check";
                        name = L["Set Shown"];
                        tooltip = L["If unchecked, tooltips of this type will never show"];
                        dbPath = "show";
                      };
                      { type = "check";
                        name = L["Hide in Combat"];
                        tooltip = L["If unchecked, tooltips of this type will not show while you are in combat."];
                        dbPath = "hideInCombat";
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
              dbPath = "anchors.mouse.point",
              options = {
                [L["Left"]] = "ANCHOR_CURSOR_LEFT",
                [L["Right"]] = "ANCHOR_CURSOR_RIGHT"
              }
            };
            { type = "slider";
              name = L["X-Offset"];
              dbPath = "anchors.mouse.xOffset";
              min = -20,
              max = 20
            };
            { type = "slider";
              name = L["Y-Offset"];
              dbPath = "anchors.mouse.yOffset";
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
                dbPath = "anchors.screen.point";
                OnLoad = function(_, container)
                  screenPointDropdown = container.component.dropdown;
                end;
            };
            {   type = "textfield";
                name = L["X-Offset"];
                valueType = "number";
                dbPath = "anchors.screen.xOffset";
                OnLoad = function(_, container)
                  screenPointXOffsetTextField = container.component;
                end;
            };
            {   type = "textfield";
                valueType = "number";
                name = L["Y-Offset"];
                dbPath = "anchors.screen.yOffset";
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
                dbPath = "font";
                media = "font";
            };
            {   name = L["Font Flag"],
                type = "dropdown",
                dbPath = "flag",
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
                step = 1;
                min = 8;
                max = 20;
                dbPath = "standardFontSize";
            };
            {   name = L["Header Font Size"];
                type = "slider";
                step = 1;
                min = 8;
                max = 30;
                dbPath = "headerFontSize";
            };
            {   name = L["Scale"];
                type = "slider";
                tooltip = L["Affects the overall size of the tooltips."];
                step = 0.1;
                min = 0.5;
                max = 1.5;
                dbPath = "scale";
            };
            {   type = "fontstring",
                subtype = "header",
                content = L["Reskin using the MUI texture or a custom backdrop"],
            },
            {   name = "MUI "..L["Texture"];
                type = "radio";
                groupName = "tooltip_texture";
                dbPath = "useMuiTexture";
                width = 250;

                SetValue = function(self, value)
                  customBackdropSubmenu:Disable();
                  db:SetPathValue(self.dbPath, value);
                end;
            },
            {   name = L["Custom Backdrop"];
                type = "radio";
                width = 250;
                groupName = "tooltip_texture";
                dbPath = "useMuiTexture";

                GetValue = function(_, value)
                  return not value;
                end;

                SetValue = function(self, value)

                  customBackdropSubmenu:Enable();
                  db:SetPathValue(self.dbPath, not value);
                end;
            },
            {   type = "divider" };
            {   name = L["Use Class Colors"],
                tooltip = L["If checked, tooltips for other players will be colored based on their class."],
                type = "check",
                dbPath = "classColored",
            };
            {   name = L["Custom Backdrop Options"];
                type = "submenu";
                dbPath = "backdrop";
                enabled = not db.profile.tooltips.useMuiTexture;
                OnLoad = function(_, submenu)
                  customBackdropSubmenu = submenu;
                end;
                children = {
                    { type = "divider" };
                    { type = "dropdown",
                      name = L["Background Texture"];
                      media = tk.Constants.LSM.MediaType.BACKGROUND;
                      dbPath = "bgFile";
                    };
                    { type = "dropdown",
                      name = L["Border Type"];
                      media = tk.Constants.LSM.MediaType.BORDER;
                      dbPath = "edgeFile";
                    };
                    { type = "slider",
                      name = L["Border Size"];
                      step = 1;
                      min = 0;
                      max = 5;
                      dbPath = "edgeSize";
                      SetValue = function(self, value)
                        db:SetPathValue(self.dbPath, value + 0.25); -- fixes pixel perfect
                      end;
                    };
                    { type = "fontstring";
                      subtype = "header";
                      content = L["Border Insets"];
                    };
                    { name = L["Left"];
                      dbPath = "insets.left";
                      type = "slider";
                      min = -10;
                      max = 10;
                    };
                    { name = L["Right"];
                      dbPath = "insets.right";
                      type = "slider";
                      min = -10;
                      max = 10;
                    };
                    { name = L["Top"];
                      dbPath = "insets.top";
                      type = "slider";
                      min = -10;
                      max = 10;
                    };
                    { name = L["Bottom"];
                      dbPath = "insets.bottom";
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
                step = 1;
                min = 8;
                max = 20;
                dbPath = "healthBar.fontSize";
            };
            {   name = L["Font Flag"],
                type = "dropdown",
                dbPath = "healthBar.flag",
                options = tk.Constants.FONT_FLAG_DROPDOWN_OPTIONS
            };
            {   name = L["Height"];
                type = "slider";
                min = 4;
                max = 50;
                dbPath = "healthBar.height";
            };
            {   type = "dropdown";
                name = L["Bar Texture"];
                media = tk.Constants.LSM.MediaType.STATUSBAR;
                dbPath = "healthBar.texture";
            };
            {   name = L["Text Format"],
                tooltip = L["Set the text format of the value that appears on the status bar. Set this to 'None' to hide the text."];
                type = "dropdown",
                dbPath = "healthBar.format",
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
                dbPath = "powerBar.enabled",
            },
            {   name = L["Font Size"];
                type = "slider";
                step = 1;
                min = 8;
                max = 20;
                dbPath = "powerBar.fontSize";
            };
            {   name = L["Font Flag"],
                type = "dropdown",
                dbPath = "powerBar.flag",
                options = tk.Constants.FONT_FLAG_DROPDOWN_OPTIONS;
            };
            {   name = L["Height"];
                type = "slider";
                min = 4;
                max = 50;
                dbPath = "powerBar.height";
            };
            {   type = "dropdown";
                name = L["Bar Texture"];
                media = tk.Constants.LSM.MediaType.STATUSBAR;
                dbPath = "powerBar.texture";
            };
            {   name = L["Text Format"],
                tooltip = L["Set the text format of the value that appears on the status bar. Set this to 'None' to hide the text."];
                type = "dropdown",
                dbPath = "powerBar.format",
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
                dbPath = "auras.buffs.enabled",
            },
            {   name = L["Only show buffs applied by me"];
                dbPath =  "auras.buffs.onlyYours";
                type = "check";
            };
            {   name = L["Size"];
                type = "slider";
                step = 1;
                min = 20;
                max = 40;
                dbPath = "auras.buffs.size";
            };
            {   name = L["Position"],
                tooltip = L["Set whether you want the unit's buffs to appear above or below the tooltip."];
                type = "dropdown",
                dbPath = "auras.buffs.position",
                options = {
                  [L["Above"]] = "TOP",
                  [L["Below"]] = "BOTTOM",
                };
            };
            {   name = L["Growth Direction"],
                type = "dropdown",
                dbPath = "auras.buffs.direction",
                options = { [L["Left to Right"]] = "ltr", [L["Right to Left"]] = "rtl" }
            };
            {   type = "fontstring",
                subtype = "header",
                content = L["Debuffs"],
            },
            {   name = L["Enabled"],
                tooltip = L["If checked, unit tooltips will show the unit's debuffs."],
                type = "check",
                dbPath = "auras.debuffs.enabled",
            },
            {   name = L["Only show debuffs applied by me"];
                dbPath = "auras.debuffs.onlyYours";
                type = "check";
            };
            {   name = L["Set border color by debuff type"];
                tooltip = L["If enabled, the border color of debuffs will be based on the type of debuff (e.g., poisons will appear with a green border color)."];
                dbPath = "auras.debuffs.colorByDebuffType";
                type = "check";
            };
            {   name = L["Size"];
                type = "slider";
                step = 1;
                min = 20;
                max = 40;
                dbPath = "auras.debuffs.size";
            };
            {   name = L["Position"],
                tooltip = L["Set whether you want the unit's debuffs to appear above or below the tooltip."];
                type = "dropdown",
                dbPath = "auras.debuffs.position",
                options = {
                  Above = "TOP",
                  Below = "BOTTOM",
                };
            };
            {   name = L["Growth Direction"],
                type = "dropdown",
                dbPath = "auras.debuffs.direction",
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
                dbPath = "auras.debuffs.aboveBuffs";
                type = "radio";
                groupName = "aura_ordering";
            };
            {   name = L["Buffs Above Debuffs"];
                dbPath = "auras.debuffs.aboveBuffs";
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