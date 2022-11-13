-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();
local C_ConfigMenu = MayronUI:GetModuleClass("ConfigMenu");

local ipairs, strformat, tonumber = _G.ipairs, _G.string.format, _G.tonumber;
local GetCVar, SetCVar = _G.GetCVar, _G.SetCVar;

local function GetBartender4ActionBarOptions()
  local options = { [L["None"]] = 0 };
  local BT4ActionBars = _G.Bartender4:GetModule("ActionBars");

  for i = 1, BT4ActionBars.LIST_ACTIONBARS do
    local barName = BT4ActionBars:GetBarName(i);
    options[barName] = i;
  end

  return options;
end

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

function C_ConfigMenu:GetConfigTable()
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
        }; {
          name = "Clamp Frames to Screen";
          type = "check";
          tooltip = "If checked, Blizzard frames cannot be dragged outside of the screen.";
          dbPath = "global.movable.clampToScreen";
          requiresReload = true;
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
      module = "MainContainer";
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
    };
    {
      name = "Action Bars";
      children = {
        {
          type = "title";
          name = "Background Panel Settings",
        },
        {
          type = "fontstring";
          content = "These settings control the MayronUI artwork behind the Bartender4 action bars.";
        },
        {
            type = "fontstring",
            subtype = "header",
            content = "Bottom Panel",
        },
        {
          type = "check",
          name = "Show Panel",
        },
        {
          type = "slider",
          name = "Set Alpha",
        },
        {
          type = "slider",
          name = "Set Height",
          tooltip = "This option is only available if the expand/retract feature is disabled."
        },
        {
            type = "fontstring",
            subtype = "header",
            content = "Side Panel",
        },
        {
          type = "check",
          name = "Show Panel",
        },
        {
          type = "slider",
          name = "Set Alpha",
        },
        {
          type = "check",
          name = "Calculate Width",
          tooltip = "If true"
        },
        {
          type = "slider",
          name = "Set Width",
          tooltip = "This option is only available if the expand/retract feature is disabled."
        },
        {
          type = "slider",
          name = "Set Height",
        },
        {
          type = "title";
          name = "Bartender4 Action Bar Settings",
        },
        {
          type = "fontstring";
          content = "These settings control what MayronUI is allowed to do with the Bartender4 action bars.\nBy default, MayronUI:";
        },
        { type = "fontstring",
          list = {
            "Fades action bars in and out when you press the provided arrow buttons.";
            "Maintains the visibility of action bars between sessions of gameplay.";
            "Sets the scale and padding of action bar buttons to best fit inside the background panels.";
            "Sets and updates the position the action bars so they remain in place ontop of the background panels."
          }
        },
        {
            type = "fontstring",
            subtype = "header",
            content = "Bottom Action Bars",
        },
        {
          type = "table",
          rows = {"Row 1: ", "Row 2: ", "Row 3"},
          columns = {"BT4 Bar #1", "BT4 Bar #2"},
          dbPath = "profile.actionbars.bottom.bartender[row][column]";
          GetOptions = GetBartender4ActionBarOptions;
          cell = function(row, column)
            local value = db.profile.actionbars.bottom[row][column];

          end;
        },
        {
            type = "fontstring",
            subtype = "header",
            content = "Side Action Bars",
        },
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
        { name = L["Objective Tracker"]; type = "title"; marginTop = 0 };
        {
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
