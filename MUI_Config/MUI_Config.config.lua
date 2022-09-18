-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();
local C_ConfigModule = namespace.C_ConfigModule;
local expandRetractDependencies = {};
local expandRetractCheckButton;
local bartenderControlDependencies = {};
local defaultHeightWidget;

local table, ipairs, strformat, tonumber = _G.table, _G.ipairs,
  _G.string.format, _G.tonumber;
local GetCVar, SetCVar = _G.GetCVar, _G.SetCVar;

local function GetModKeyValue(modKey, currentValue)
  if (obj:IsString(currentValue) and currentValue:find(modKey)) then
    return true;
  end

  return false;
end

local function SetModKeyValue(modKey, dbPath, newValue, oldValue)
  if (obj:IsString(oldValue) and oldValue:find(modKey)) then
    -- remove modKey from current value before trying to append new value
    oldValue = oldValue:gsub(modKey, tk.Strings.Empty);
  end

  if (newValue) then
    newValue = modKey;

    if (obj:IsString(oldValue)) then
      newValue = oldValue .. newValue;
    end
  else
    -- if check button is not checked (false) set back to oldValue that does not include modKey
    newValue = oldValue;
  end

  if (tk.Strings:IsNilOrWhiteSpace(newValue)
    and expandRetractCheckButton:GetChecked()) then
    expandRetractCheckButton:Click();
  end

  db:SetPathValue(dbPath, newValue);
end

local BartenderActionBars = {
  [L["Bar"] .. " 1"] = "Bar 1";
  [L["Bar"] .. " 2"] = "Bar 2";
  [L["Bar"] .. " 3"] = "Bar 3";
  [L["Bar"] .. " 4"] = "Bar 4";
  [L["Bar"] .. " 5"] = "Bar 5";
  [L["Bar"] .. " 6"] = "Bar 6";
  [L["Bar"] .. " 7"] = "Bar 7";
  [L["Bar"] .. " 8"] = "Bar 8";
  [L["Bar"] .. " 9"] = "Bar 9";
  [L["Bar"] .. " 10"] = "Bar 10";
};

local BartenderActionBarValues = {
  [L["None"]] = 0;
  [L["Bar"] .. " 1"] = 1;
  [L["Bar"] .. " 2"] = 2;
  [L["Bar"] .. " 3"] = 3;
  [L["Bar"] .. " 4"] = 4;
  [L["Bar"] .. " 5"] = 5;
  [L["Bar"] .. " 6"] = 6;
  [L["Bar"] .. " 7"] = 7;
  [L["Bar"] .. " 8"] = 8;
  [L["Bar"] .. " 9"] = 9;
  [L["Bar"] .. " 10"] = 10;
};

local function AddRepStandingIDColorOptions(repSettings, child)
  local repColors = {};
  local fixedBtn;

  local options = {
    { type = "fontstring"; content = L["Reputation Colors"]; subtype = "header" };
    {
      name = L["Use Fixed Color"];
      tooltip = L["If checked, the reputation bar will use a fixed color instead of dynamically changing based on your reputation with the selected faction."];
      type = "check";
      dbPath = "profile.resourceBars.reputationBar.useDefaultColor";
      SetValue = function(dbPath, newValue)
        db:SetPathValue(dbPath, newValue);
        fixedBtn:SetEnabled(newValue);

        for _, btn in ipairs(repColors) do
          btn:SetEnabled(not newValue);
        end
      end;
    }; {
      name = L["Fixed Color"];
      type = "color";
      width = 120;
      dbPath = "profile.resourceBars.reputationBar.defaultColor";
      enabled = repSettings.useDefaultColor;
      OnLoad = function(_, btn)
        fixedBtn = btn;
      end;
    }; { type = "divider" };
  };

  for i = 1, 8 do
    local name = _G.GetText("FACTION_STANDING_LABEL" .. i, _G.UnitSex("PLAYER"));

    options[#options + 1] = {
      name = name;
      type = "color";
      width = 120;
      enabled = not repSettings.useDefaultColor;
      dbPath = strformat(
        "profile.resourceBars.reputationBar.standingColors[%d]", i);
      OnLoad = function(_, btn)
        repColors[#repColors + 1] = btn;
      end;
    };
  end

  for id, value in ipairs(options) do
    options[id] = nil;
    child[#child + 1] = value;
  end

  obj:PushTable(options);
end

function C_ConfigModule:GetConfigTable()
  return {
    {
      name = L["General"];
      id = 1;
      children = {
        {
          name = L["Enable Master Font"];
          tooltip = L["Uncheck to prevent MUI from changing the game font."];
          requiresRestart = true;
          dbPath = "global.core.changeGameFont";
          type = "check";
        }; {
          name = L["Display Lua Errors"];
          type = "check";

          GetValue = function()
            return tonumber(GetCVar("ScriptErrors")) == 1;
          end;

          SetValue = function(_, value)
            if (value) then
              SetCVar("ScriptErrors", "1");
            else
              SetCVar("ScriptErrors", "0");
            end
          end;
        }; {
          name = L["Show AFK Display"];
          type = "check";
          tooltip = L["Enable/disable the AFK Display"];
          dbPath = "global.AFKDisplay.enabled";

          SetValue = function(dbPath, newValue)
            db:SetPathValue(dbPath, newValue);
            MayronUI:ImportModule("AFKDisplay"):SetEnabled(newValue);
          end;
        }; {
          name = L["Enable Max Camera Zoom"];
          type = "check";
          tooltip = L["Enable Max Camera Zoom"];
          dbPath = "global.core.maxCameraZoom";
          SetValue = function(dbPath, newValue)
            db:SetPathValue(dbPath, newValue);

            if (newValue) then
              SetCVar("cameraDistanceMaxZoomFactor", 4.0);
            else
              SetCVar("cameraDistanceMaxZoomFactor", 1.9);
            end
          end;
        }; { type = "divider" }; {
          name = L["Master Font"];
          type = "dropdown";
          options = tk.Constants.LSM:List("font");
          dbPath = "global.core.font";
          requiresRestart = true;
          fontPicker = true;
        }; {
          name = L["Set Theme Color"];
          type = "color";
          dbPath = "profile.theme.color";
          height = 54;
          requiresReload = true; -- TODO: This might not need to restart.

          SetValue = function(_, value)
            value.hex = strformat(
                          "%02x%02x%02x", value.r * 255, value.g * 255,
                            value.b * 255);
            db.profile.theme.color = value;
            db.profile.bottomui.gradients = nil;
            db:RemoveAppended(db.profile, "unitPanels.sufGradients");
          end;
        }; { type = "divider" }; {
          name = L["Movable Blizzard Frames"];
          type = "check";
          tooltip = L["Allows you to move Blizzard Frames outside of combat only."];
          dbPath = "global.movable.enabled";

          SetValue = function(dbPath, newValue)
            db:SetPathValue(dbPath, newValue);
            MayronUI:ImportModule("MovableFramesModule"):SetEnabled(newValue);
          end;
        }; { type = "divider" }; {
          name = L["Reset Blizzard Frame Positions"];
          type = "button";
          tooltip = L["Reset Blizzard frames back to their original position."];
          OnClick = function()
            MayronUI:ImportModule("MovableFramesModule"):ResetPositions();
            MayronUI:Print("Blizzard frame positions have been reset.")
          end;
        }; { type = "title"; name = L["Main Container"] }; {
          type = "fontstring";
          content = L["The main container holds the unit frame panels, action bar panels, data-text bar, and all resource bars at the bottom of the screen."];
        }; {
          name = L["Set Width"];
          type = "slider";
          min = 500;
          max = 1500;
          step = 50;
          valueType = "number";
          tooltip = tk.Strings:Concat(
            L["Adjust the width of the main container."], "\n\n",
              L["Default value is"], " 750");
          dbPath = "profile.bottomui.width";
        }; {
          name = L["Frame Strata"];
          type = "dropdown";
          options = tk.Constants.ORDERED_FRAME_STRATAS;
          dbPath = "profile.bottomui.frameStrata";
          tooltip = L["Default value is"] .. " LOW";
        }; {
          name = L["Frame Level"];
          type = "textfield";
          valueType = "number";
          dbPath = "profile.bottomui.frameLevel";
          tooltip = L["Default value is"] .. " 5";
        }; { type = "divider" }; {
          name = L["X-Offset"];
          type = "textfield";
          valueType = "number";
          dbPath = "profile.bottomui.xOffset";
          tooltip = L["Default value is"] .. " 0";
        }; {
          name = L["Y-Offset"];
          type = "textfield";
          valueType = "number";
          dbPath = "profile.bottomui.yOffset";
          tooltip = L["Default value is"] .. " -1";
        };
        { type = "title"; client = "retail"; name = L["Talking Head Frame"] };
        {
          type = "fontstring";
          client = "retail";
          content = L["This is the animated character portrait frame that shows when an NPC is talking to you."];
        }; {
          name = L["Top of Screen"];
          type = "radio";
          client = "retail";
          groupName = "talkingHead_position";
          dbPath = "global.movable.talkingHead.position";
          height = 50;
          GetValue = function(_, value)
            return value == "TOP";
          end;

          SetValue = function(path)
            db:SetPathValue(path, "TOP");
          end;
        }; {
          name = L["Bottom of Screen"];
          type = "radio";
          client = "retail";
          groupName = "talkingHead_position";
          dbPath = "global.movable.talkingHead.position";
          height = 50;
          GetValue = function(_, value)
            return value == "BOTTOM";
          end;

          SetValue = function(path)
            db:SetPathValue(path, "BOTTOM");
          end;
        }; {
          name = L["Y-Offset"];
          type = "textfield";
          client = "retail";
          valueType = "number";
          dbPath = "global.movable.talkingHead.yOffset";
        };
      };
    }; {
      module = "BottomUI_Container";
      id = 2;
      children = {
        {
          name = L["Enable Unit Panels"];
          module = "UnitPanels";
          dbPath = "profile.unitPanels.enabled";
          type = "check";
          requiresReload = true;
        }; {
          name = L["Symmetric Unit Panels"];
          tooltip = L["Previously called 'Classic Mode'."];
          type = "check";
          dbPath = "profile.unitPanels.isSymmetric";
        }; {
          name = L["Pulse While Resting"];
          tooltip = L["If enabled, the unit panels will fade in and out while resting."];
          module = "UnitPanels";
          dbPath = "profile.unitPanels.restingPulse";
          type = "check";
        }; {
          name = L["Target Class Color Gradient"];
          tooltip = L["If enabled, the unit panel color will transition to the target's class color using a horizontal gradient effect."];
          module = "UnitPanels";
          dbPath = "profile.unitPanels.targetClassColored";
          type = "check";
        }; {
          name = L["Allow MUI to Control Unit Frames"];
          tooltip = L["TT_MUI_CONTROL_SUF"];
          type = "check";
          dbPath = "profile.unitPanels.controlSUF";
        }; { type = "divider" }; {
          name = L["Set Width"];
          type = "slider";
          module = "UnitPanels";
          min = 200;
          max = 500;
          step = 10;
          valueType = "number";
          tooltip = tk.Strings:Concat(
            L["Adjust the width of the unit frame background panels."], "\n\n",
              L["Minimum value is"], " 200", "\n\n", L["Default value is"],
              " 325");
          dbPath = "profile.unitPanels.unitWidth";
        }; {
          name = L["Set Height"];
          type = "slider";
          module = "UnitPanels";
          valueType = "number";
          min = 25;
          max = 200;
          step = 5;
          tooltip = tk.Strings:Concat(
            L["Adjust the height of the unit frame background panels."], "\n\n",
              L["Default value is"], " 75");
          dbPath = "profile.unitPanels.unitHeight";
        }; {
          name = L["Set Alpha"];
          type = "slider";
          module = "UnitPanels";
          valueType = "number";
          min = 0;
          max = 1;
          step = 0.1;
          tooltip = tk.Strings:Concat(L["Default value is"], " 0.8");
          dbPath = "profile.unitPanels.alpha";
        }; {
          name = L["Set Pulse Strength"];
          type = "slider";
          tooltip = tk.Strings:Concat(
            "Set the alpha change while pulsing/flashing",
              L["Default value is"], " 0.3");
          module = "UnitPanels";
          valueType = "number";
          min = 0;
          max = 1;
          step = 0.1;
          dbPath = "profile.unitPanels.pulseStrength";
        }; { name = L["Name Panels"]; type = "title" }; {
          name = L["Enabled"];
          module = "UnitPanels";
          dbPath = "profile.unitPanels.unitNames.enabled";
          type = "check";
        }; {
          name = L["Target Class Colored"];
          type = "check";
          dbPath = "profile.unitPanels.unitNames.targetClassColored";
        }; { type = "divider" }; {
          name = L["Set Width"];
          type = "slider";
          min = 150;
          max = 300;
          step = 5;
          tooltip = tk.Strings:Concat(
            L["Adjust the width of the unit name background panels."], "\n\n",
              L["Default value is"], " 235");
          dbPath = "profile.unitPanels.unitNames.width";
        }; {
          name = L["Set Height"];
          type = "slider";
          min = 15;
          max = 30;
          step = 1;
          tooltip = tk.Strings:Concat(
            L["Adjust the height of the unit name background panels."], "\n\n",
              L["Default value is"], " 20");
          dbPath = "profile.unitPanels.unitNames.height";
        }; {
          name = L["X-Offset"];
          type = "slider";
          min = -50;
          max = 50;
          step = 1;
          tooltip = tk.Strings:Concat(
            L["Move the unit name panels further in or out."], "\n\n",
              L["Default value is"], " 24");
          dbPath = "profile.unitPanels.unitNames.xOffset";
        }; {
          name = L["Font Size"];
          type = "slider";
          tooltip = tk.Strings:Concat(
            L["Set the font size of unit names."], "\n\n",
              L["Default value is"], " 11");
          step = 1;
          min = 8;
          max = 18;
          dbPath = "profile.unitPanels.unitNames.fontSize";
        }; { name = L["SUF Portrait Gradient"]; type = "title" }; {
          name = L["Enable Gradient Effect"];
          type = "check";
          tooltip = L["If the SUF Player or Target portrait bars are enabled, a class colored gradient will overlay it."];
          dbPath = "profile.unitPanels.sufGradients.enabled";
        }; {
          name = L["Set Height"];
          type = "slider";
          min = 1;
          max = 50;
          step = 1;
          tooltip = tk.Strings:Concat(
            L["The height of the gradient effect."], "\n\n",
              L["Default value is"], " 24");
          dbPath = "profile.unitPanels.sufGradients.height";
        };
        {
          type = "fontstring";
          content = L["Gradient Colors"];
          subtype = "header";
        }; {
          name = L["Start Color"];
          type = "color";
          hasOpacity = true;
          width = 150;
          tooltip = L["What color the gradient should start as."];
          dbPath = "profile.unitPanels.sufGradients.from";
        }; {
          name = L["End Color"];
          width = 150;
          tooltip = L["What color the gradient should change into."];
          type = "color";
          hasOpacity = true;
          dbPath = "profile.unitPanels.sufGradients.to";
        }; {
          name = L["Target Class Colored"];
          tooltip = L["TT_MUI_USE_TARGET_CLASS_COLOR"];
          type = "check";
          dbPath = "profile.unitPanels.sufGradients.targetClassColored";
        };
      };
    }; {
      module = "ActionBarPanel";
      children = {
        {
          name = L["Bottom Action Bars"];
          type = "submenu";
          children = {
            {
              name = L["Enable Panel"];
              dbPath = "profile.actionBarPanel.enabled";
              tooltip = L["Enable or disable the background panel"];
              type = "check";
            }; { type = "divider" }; {
              name = L["Set Alpha"];
              type = "slider";
              step = 0.1;
              min = 0;
              max = 1;
              dbPath = "profile.actionBarPanel.alpha";
            }; {
              name = L["Set Height"];
              dbPath = "profile.actionBarPanel.defaultHeight";
              tooltip = L["This is the fixed default height to use when the expand and retract feature is disabled."];
              type = "slider";
              min = 40;
              max = 400;
              OnLoad = function(_, container)
                defaultHeightWidget = container.widget;
              end;
              enabled = function()
                return not db.profile.actionBarPanel.expandRetract;
              end;
            };
            {
              name = L["Expanding and Retracting Action Bar Rows"];
              type = "title";
            }; {
              name = L["Enable Expand and Retract Feature"];
              dbPath = "profile.actionBarPanel.expandRetract";
              tooltip = L["If disabled, you will not be able to toggle between 1 and 2 rows of action bars."];
              type = "check";

              OnLoad = function(_, container)
                expandRetractCheckButton = container.btn;
              end;

              SetValue = function(dbPath, value)
                for _, widget in ipairs(expandRetractDependencies) do
                  widget:SetEnabled(value);
                end

                if (value) then
                  local modKey = db.profile.actionBarPanel.modKey;

                  if (tk.Strings:IsNilOrWhiteSpace(modKey)) then
                    for _, btn in ipairs(expandRetractDependencies) do
                      if (obj:IsWidget(btn, "CheckButton") and btn.text:GetText()
                        == L["Control"]) then
                        btn:Click();
                        break
                      end
                    end
                  end
                end

                defaultHeightWidget:SetEnabled(not value);
                db:SetPathValue(dbPath, value);
              end;
            }; { type = "divider" }; {
              name = L["Animation Speed"];
              type = "slider";
              tooltip = tk.Strings:Concat(
                L["The speed of the Expand and Retract transitions."], "\n\n",
                  L["The higher the value, the quicker the speed."], "\n\n",
                  L["Default value is"], " 6");
              step = 1;
              min = 1;
              max = 10;
              dbPath = "profile.actionBarPanel.animateSpeed";
              OnLoad = function(_, container)
                table.insert(expandRetractDependencies, container.widget);
              end;
              enabled = function()
                return db.profile.actionBarPanel.expandRetract;
              end;
            }; { type = "divider" }; {
              type = "fontstring";
              content = L["Modifier key/s used to show Expand/Retract button:"];
            }; {
              type = "loop";
              args = { "C"; "S"; "A" };
              func = function(_, arg)
                local name = L["Alt"];

                if (arg == "C") then
                  name = L["Control"];

                elseif (arg == "S") then
                  name = L["Shift"];
                end

                return {
                  name = name;
                  height = 40;
                  type = "check";
                  dbPath = "profile.actionBarPanel.modKey";

                  GetValue = function(_, currentValue)
                    return GetModKeyValue(arg, currentValue);
                  end;

                  SetValue = function(dbPath, newValue, oldValue)
                    SetModKeyValue(arg, dbPath, newValue, oldValue);
                  end;

                  OnLoad = function(_, container)
                    table.insert(expandRetractDependencies, container.btn);
                  end;
                  enabled = function()
                    return db.profile.actionBarPanel.expandRetract;
                  end;
                };
              end;
            }; { name = L["Bartender Action Bars"]; type = "title" }; {
              name = L["Allow MUI to Control Selected Bartender Bars"];
              type = "check";
              tooltip = L["TT_MUI_CONTROL_BARTENDER"];
              dbPath = "profile.actionBarPanel.bartender.control";

              SetValue = function(dbPath, value)
                for _, widget in ipairs(bartenderControlDependencies) do
                  widget:SetEnabled(value);
                end

                db:SetPathValue(dbPath, value);
              end;
            }; { type = "divider" }; {
              name = tk.Strings:JoinWithSpace("Set", L["Row"], L["Spacing"]);
              type = "slider";
              min = 1;
              max = 20;
              step = 0.5;
              dbPath = "profile.actionBarPanel.rowSpacing";
              OnLoad = function(_, container)
                table.insert(bartenderControlDependencies, container.widget);
              end;
              enabled = function()
                return db.profile.actionBarPanel.bartender.control;
              end;
            };
            { type = "fontstring"; content = L["Row"] .. "1";
            subtype = "header" }; {
              name = L["First Bartender Bar"];
              type = "dropdown";
              dbPath = "profile.actionBarPanel.bartender[1][1]";
              options = BartenderActionBarValues;
              OnLoad = function(_, container)
                table.insert(bartenderControlDependencies, container.widget);
              end;

              enabled = function()
                return db.profile.actionBarPanel.bartender.control;
              end;
            }; {
              name = L["Second Bartender Bar"];
              dbPath = "profile.actionBarPanel.bartender[1][2]";
              type = "dropdown";
              options = BartenderActionBarValues;
              OnLoad = function(_, container)
                table.insert(bartenderControlDependencies, container.widget);
              end;
              enabled = function()
                return db.profile.actionBarPanel.bartender.control;
              end;
            }; {
              name = tk.Strings:JoinWithSpace(L["Row"], L["Height"]);
              type = "slider";
              min = 40;
              max = 400;
              dbPath = "profile.actionBarPanel.rowHeights[1]";
              OnLoad = function(_, container)
                table.insert(expandRetractDependencies, container.widget);
              end;
              enabled = function()
                return db.profile.actionBarPanel.expandRetract;
              end;
            };
            { type = "fontstring"; content = L["Row"] .. "2";
            subtype = "header" }; {
              name = L["First Bartender Bar"];
              dbPath = "profile.actionBarPanel.bartender[2][1]";
              type = "dropdown";
              options = BartenderActionBarValues;
              OnLoad = function(_, container)
                table.insert(bartenderControlDependencies, container.widget);
              end;
              enabled = function()
                return db.profile.actionBarPanel.bartender.control;
              end;
            }; {
              name = L["Second Bartender Bar"];
              dbPath = "profile.actionBarPanel.bartender[2][2]";
              type = "dropdown";
              options = BartenderActionBarValues;
              OnLoad = function(_, container)
                table.insert(bartenderControlDependencies, container.widget);
              end;
              enabled = function()
                return db.profile.actionBarPanel.bartender.control;
              end;
            }; {
              name = tk.Strings:JoinWithSpace(L["Row"], L["Height"]);
              type = "slider";
              min = 40;
              max = 400;
              dbPath = "profile.actionBarPanel.rowHeights[2]";
              OnLoad = function(_, container)
                table.insert(expandRetractDependencies, container.widget);
              end;
              enabled = function()
                return db.profile.actionBarPanel.expandRetract;
              end;
            };
            { type = "fontstring"; content = L["Row"] .. "3";
            subtype = "header" }; {
              name = L["First Bartender Bar"];
              dbPath = "profile.actionBarPanel.bartender[3][1]";
              type = "dropdown";
              options = BartenderActionBarValues;
              OnLoad = function(_, container)
                table.insert(bartenderControlDependencies, container.widget);
              end;
              enabled = function()
                return db.profile.actionBarPanel.bartender.control;
              end;
            }; {
              name = L["Second Bartender Bar"];
              dbPath = "profile.actionBarPanel.bartender[3][2]";
              type = "dropdown";
              options = BartenderActionBarValues;
              OnLoad = function(_, container)
                table.insert(bartenderControlDependencies, container.widget);
              end;
              enabled = function()
                return db.profile.actionBarPanel.bartender.control;
              end;
            }; {
              name = tk.Strings:JoinWithSpace(L["Row"], L["Height"]);
              type = "slider";
              min = 40;
              max = 400;
              dbPath = "profile.actionBarPanel.rowHeights[3]";
              OnLoad = function(_, container)
                table.insert(expandRetractDependencies, container.widget);
              end;
              enabled = function()
                return db.profile.actionBarPanel.expandRetract;
              end;
            };
          };
        }; {
          name = L["Side Action Bars"];
          type = "submenu";
          children = {
            {
              name = L["Enabled"];
              tooltip = L["Enable or disable the background panel"];
              type = "check";
              dbPath = "profile.sidebar.enabled";
            }; { type = "divider" }; {
              name = L["Width (With 1 Bar)"];
              type = "slider";
              min = 20;
              max = 100;
              tooltip = L["Default value is"] .. " 46";
              dbPath = "profile.sidebar.retractWidth";
            }; {
              name = L["Width (With 2 Bars)"];
              tooltip = L["Default value is"] .. " 83";
              type = "slider";
              min = 20;
              max = 200;
              dbPath = "profile.sidebar.expandWidth";
            }; { type = "divider" }; {
              name = L["Set Height"];
              tooltip = L["Default value is"] .. " 486";
              type = "slider";
              min = 200;
              max = 800;
              step = 5;
              dbPath = "profile.sidebar.height";
            }; {
              name = L["X-Offset"];
              tooltip = L["Default value is"] .. " 0";
              type = "slider";
              min = -300;
              max = 0;
              step = 5;
              dbPath = "profile.sidebar.xOffset";
            }; {
              name = L["Y-Offset"];
              tooltip = L["Default value is"] .. " 40";
              type = "slider";
              min = -300;
              max = 300;
              step = 5;
              dbPath = "profile.sidebar.yOffset";
            }; { type = "divider" }; {
              name = L["Animation Speed"];
              type = "slider";
              tooltip = L["The speed of the Expand and Retract transitions."]
                .. "\n\n" .. L["The higher the value, the quicker the speed."]
                .. "\n\n" .. L["Default value is"] .. " 6.";
              step = 1;
              min = 1;
              max = 10;
              dbPath = "profile.sidebar.animationSpeed";
            }; {
              name = L["Set Alpha"];
              type = "slider";
              step = 0.1;
              min = 0;
              max = 1;
              dbPath = "profile.sidebar.alpha";
            }; { name = L["Bartender Action Bars"]; type = "title" }; {
              name = L["Allow MUI to Control Selected Bartender Bars"];
              type = "check";
              dbPath = "profile.sidebar.bartender.control";
              tooltip = L["TT_MUI_CONTROL_BARTENDER"];
            }; { type = "divider" }; {
              name = L["First Bartender Bar"];
              dbPath = "profile.sidebar.bartender[1]";
              type = "dropdown";
              options = BartenderActionBars;
            }; {
              name = L["Second Bartender Bar"];
              dbPath = "profile.sidebar.bartender[2]";
              type = "dropdown";
              options = BartenderActionBars;
            }; { name = L["Expand and Retract Buttons"]; type = "title" }; {
              name = L["Hide in Combat"];
              type = "check";
              dbPath = "profile.sidebar.buttons.hideInCombat";
            }; {
              name = L["Show When"];
              type = "dropdown";
              dbPath = "profile.sidebar.buttons.showWhen";
              options = {
                [L["Never"]] = "Never";
                [L["Always"]] = "Always";
                [L["On Mouse-over"]] = "On Mouse-over";
              };
            }; { type = "divider" }; {
              name = L["Set Width"];
              type = "slider";
              tooltip = tk.Strings:Concat(
                L["Default value is"], " 15.", "\n\n", L["Minimum value is"],
                  " 15", "\n\n", L["Maximum value is"], " 30");
              dbPath = "profile.sidebar.buttons.width";
              min = 15;
              max = 30;
              valueType = "number";
            }; {
              name = L["Set Height"];
              type = "slider";
              tooltip = tk.Strings:Concat(
                L["Default value is"], " 100.", "\n\n", L["Minimum value is"],
                  " 50", "\n\n", L["Maximum value is"], " 300");
              dbPath = "profile.sidebar.buttons.height";
              min = 50;
              max = 300;
            };
          };
        };
      };
    }; {
      name = "Resource Bars";
      module = "ResourceBars";
      children = {
        {
          type = "loop";
          args = { "Experience"; "Reputation"; "Artifact"; "Azerite" };
          func = function(id, name)
            if (not tk:IsRetail() and (name == "Artifact" or name == "Azerite")) then
              return
            end

            if (name == "Azerite" and not _G.AzeriteBarMixin:ShouldBeVisible()) then
              return
            end

            if (name == "Artifact" and not _G.ArtifactBarMixin:ShouldBeVisible()) then
              return
            end

            local key = name:lower() .. "Bar";
            local child = {
              {
                name = tk.Strings:JoinWithSpace(L[name], L["Bar"]);
                type = "title";
              }; {
                name = L["Enabled"];
                type = "check";
                tooltip = tk.Strings:JoinWithSpace(
                  L["Default value is"], L["true"]);
                dbPath = tk.Strings:Concat(
                  "profile.resourceBars.", key, ".enabled");
              }; {
                name = L["Show Text"];
                type = "check";
                tooltip = tk.Strings:JoinWithSpace(
                  L["Default value is"], L["false"]);
                dbPath = tk.Strings:Concat(
                  "profile.resourceBars.", key, ".alwaysShowText");
              }; {
                name = L["Height"];
                type = "slider";
                step = 1;
                min = 4;
                max = 30;
                tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "8");
                dbPath = tk.Strings:Concat(
                  "profile.resourceBars.", key, ".height");
              }; {
                name = L["Font Size"];
                type = "slider";
                step = 1;
                min = 8;
                max = 18;
                tooltip = tk.Strings:JoinWithSpace(L["Default value is"], "8");
                dbPath = tk.Strings:Concat(
                  "profile.resourceBars.", key, ".fontSize");
              }; {
                type = "dropdown";
                name = L["Bar Texture"];
                options = tk.Constants.LSM:List("statusbar");
                dbPath = tk.Strings:Concat(
                  "profile.resourceBars.", key, ".texture");
              };
            };

            if (id == 1) then
              child[1].marginTop = 0;
            end

            if (id == 2) then
              -- rep bar, so show color options
              AddRepStandingIDColorOptions(
                db.profile.resourceBars.reputationBar, child);
            end

            return child;
          end;
        };
      };
    }; {
      module = "ObjectiveTrackerModule";
      client = "retail";
      children = {
        { name = L["Objective Tracker"]; type = "title"; marginTop = 0 }; {
          name = L["Enabled"];
          tooltip = L["Disable this to stop MUI from controlling the Objective Tracker."];
          type = "check";
          dbPath = "profile.objectiveTracker.enabled";
          requiresReload = true; -- TODO: Change this to "global" and then I don't need to restart.
        }; {
          name = L["Collapse in Instance"];
          tooltip = L["If true, the objective tracker will collapse when entering an instance."];
          type = "check";
          dbPath = "profile.objectiveTracker.hideInInstance";
        }; {
          name = L["Anchor to Side Bar"];
          tooltip = L["Anchor the Objective Tracker to the action bar container on the right side of the screen."];
          type = "check";
          dbPath = "profile.objectiveTracker.anchoredToSideBars";
        }; { type = "divider" }; {
          name = L["Set Width"];
          type = "slider";
          min = 150;
          max = 400;
          step = 50;
          tooltip = tk.Strings:Concat(
            L["Adjust the width of the Objective Tracker."], "\n\n",
              L["Default value is"], " 250");
          dbPath = "profile.objectiveTracker.width";
          valueType = "number";
        }; {
          name = L["Set Height"];
          type = "slider";
          min = 300;
          max = 1000;
          step = 50;
          tooltip = tk.Strings:Concat(
            L["Adjust the height of the Objective Tracker."], "\n\n",
              L["Default value is"], " 600");
          dbPath = "profile.objectiveTracker.height";
          valueType = "number";
        }; {
          name = L["X-Offset"];
          type = "slider";
          min = -300;
          max = 300;
          step = 1;
          tooltip = tk.Strings:Concat(
            L["Adjust the horizontal positioning of the Objective Tracker."],
              "\n\n", L["Default value is"], " -30");
          dbPath = "profile.objectiveTracker.xOffset";
          valueType = "number";
        }; {
          name = L["Y-Offset"];
          type = "slider";
          min = -300;
          max = 300;
          step = 1;
          tooltip = tk.Strings:Concat(
            L["Adjust the vertical positioning of the Objective Tracker."],
              "\n\n", L["Default value is"], " 0");
          dbPath = "profile.objectiveTracker.yOffset";
          valueType = "number";
        };
      };
    };
  };
end
