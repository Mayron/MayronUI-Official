-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, _, gui, obj, L = MayronUI:GetCoreComponents();
local C_ConfigMenu = MayronUI:GetModuleClass("ConfigMenu"); ---@type ConfigMenuModule

local ipairs, strformat, tonumber = _G.ipairs, _G.string.format, _G.tonumber;
local GetCVar, SetCVar = _G.GetCVar, _G.SetCVar;

local bottomPanelManualHeightOptions;
local bottomPanelPaddingOption;
local sidePanelManualWidthOptions;
local sidePanelPaddingOption;

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

  db:SetPathValue(dbPath, newValue);
end

local function GetBartender4ActionBarOptions()
  local options = { [L["None"]] = 0 };
  local BT4ActionBars = _G.Bartender4:GetModule("ActionBars");

  for _, barId in ipairs(BT4ActionBars.LIST_ACTIONBARS) do
    local barName = BT4ActionBars:GetBarName(barId);
    options[barName] = barId;
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
      SetValue = function(self, newValue)
        db:SetPathValue(self.dbPath, newValue);
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
        { type = "title"; name = "Appearance Settings"; marginTop = 0; };
        {
          name = L["Set Theme Color"];
          type = "color";
          dbPath = "profile.theme.color";
          requiresReload = true;

          SetValue = function(_, value)
            tk:UpdateThemeColor(value);
          end;
        };
        {
          name = "Set MUI Frame Colors";
          type = "color";
          tooltip = "Controls the background color of MUI frames, including the inventory frame, tooltips, config menu, layout tool and more.";
          dbPath = "profile.theme.frameColor";
          SetValue = function(_, value)
            db.profile.theme.frameColor = value;
            gui:UpdateMuiFrameColor(value.r, value.g, value.b);
          end;
        };
        { type = "divider"};
        {
          name = L["Override Master Font"];
          height = 42;
          verticalAlignment = "BOTTOM";
          tooltip = L["Uncheck to prevent MUI from changing the game font."];
          requiresReload = true;
          width = 180;
          dbPath = "global.core.fonts.useMasterFont";
          type = "check";
        };
        {
          name = L["Master Font"];
          type = "dropdown";
          media = "font";
          dbPath = "global.core.fonts.master";
          requiresRestart = true;
        };
        { type = "divider"};
        {
          name = L["Override Combat Font"];
          height = 42;
          width = 180;
          verticalAlignment = "BOTTOM";
          tooltip = L["Uncheck to prevent MUI from changing the game font."];
          requiresRestart = true;
          dbPath = "global.core.fonts.useCombatFont";
          type = "check";
        };
        {
          name = L["Combat Font"];
          tooltip = L["This font is used to display the damage and healing combat numbers."];
          type = "dropdown";
          media = "font";
          dbPath = "global.core.fonts.combat";
          requiresRestart = true;
        };
        { type = "title";
          name = L["Global Settings"];
          description = L["These settings are applied account-wide"];
        };
        { type = "check";
          name = "Enable Inventory Frame";
          tooltip = "Use the MayronUI custom inventory frame instead of the default Blizzard bags UI.";
          dbPath = "global.enabled";
          requiresReload = true;
          dbFramework = "orbitus";
          database = "MUI_InventoryDB";
        };
        {
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

          SetValue = function(self, newValue)
            db:SetPathValue(self.dbPath, newValue);
            MayronUI:ImportModule("AFKDisplay"):SetEnabled(newValue);
          end;
        }; {
          name = L["Enable Max Camera Zoom"];
          type = "check";
          tooltip = L["Enable Max Camera Zoom"];
          dbPath = "global.core.maxCameraZoom";
          SetValue = function(self, newValue)
            db:SetPathValue(self.dbPath, newValue);

            if (newValue) then
              SetCVar("cameraDistanceMaxZoomFactor", 4.0);
            else
              SetCVar("cameraDistanceMaxZoomFactor", 1.9);
            end
          end;
        };
        { type = "title";
          name = L["Main Container"];
          description = L["The main container holds the unit frame panels, action bar panels, data-text bar, and all resource bars at the bottom of the screen."]
        };
        {
          name = L["Set Width"];
          type = "slider";
          min = 500;
          max = 1500;
          step = 50;
          valueType = "number";
          tooltip = L["Adjust the width of the main container."];
          dbPath = "profile.bottomui.width";
        };
        {
          name = L["Frame Strata"];
          type = "dropdown";
          options = tk.Constants.ORDERED_FRAME_STRATAS;
          dbPath = "profile.bottomui.frameStrata";
        };
        {
          name = L["Frame Level"];
          type = "textfield";
          valueType = "number";
          dbPath = "profile.bottomui.frameLevel";
        };
        { type = "divider" };
        {
          name = L["X-Offset"];
          type = "textfield";
          valueType = "number";
          dbPath = "profile.bottomui.xOffset";
        };
        {
          name = L["Y-Offset"];
          type = "textfield";
          valueType = "number";
          dbPath = "profile.bottomui.yOffset";
        };
        { type = "title"; name = L["Blizzard Frames"] };
        {
          name = L["Movable Frames"];
          type = "check";
          tooltip = L["Allows you to move Blizzard Frames outside of combat only."];
          dbPath = "global.movable.enabled";

          SetValue = function(self, newValue)
            db:SetPathValue(self.dbPath, newValue);
            MayronUI:ImportModule("MovableFramesModule"):SetEnabled(newValue);
          end;
        };
        {
          name = L["Clamped to Screen"];
          type = "check";
          tooltip = L["If checked, Blizzard frames cannot be dragged outside of the screen."];
          dbPath = "global.movable.clampToScreen";
          requiresReload = true;
        };
        {
          name = L["Reset Positions"];
          type = "button";
          tooltip = L["Reset Blizzard frames back to their original position."];
          OnClick = function()
            MayronUI:ImportModule("MovableFramesModule"):ResetPositions();
            MayronUI:Print(L["Blizzard frame positions have been reset."]);
          end;
        };
        {
          type = "fontstring";
          subtype="header";
          client = "retail";
          height = 20;
          content = L["Talking Head Frame"];
        };
        {
          type = "fontstring";
          client = "retail";
          padding = 4;
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

          SetValue = function(self)
            db:SetPathValue(self.dbPath, "TOP");
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

          SetValue = function(self)
            db:SetPathValue(self.dbPath, "BOTTOM");
          end;
        }; {
          name = L["Y-Offset"];
          type = "textfield";
          client = "retail";
          valueType = "number";
          dbPath = "global.movable.talkingHead.yOffset";
        };
      };
    };
    {
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
          tooltip = L["Adjust the width of the unit frame background panels."];
          dbPath = "profile.unitPanels.unitWidth";
        }; {
          name = L["Set Height"];
          type = "slider";
          module = "UnitPanels";
          valueType = "number";
          min = 25;
          max = 200;
          step = 5;
          tooltip = L["Adjust the height of the unit frame background panels."];
          dbPath = "profile.unitPanels.unitHeight";
        }; {
          name = L["Set Alpha"];
          type = "slider";
          module = "UnitPanels";
          valueType = "number";
          min = 0;
          max = 1;
          step = 0.1;
          dbPath = "profile.unitPanels.alpha";
        }; {
          name = L["Set Pulse Strength"];
          type = "slider";
          tooltip = L["Set the alpha change while pulsing/flashing."];
          module = "UnitPanels";
          valueType = "number";
          min = 0;
          max = 1;
          step = 0.1;
          dbPath = "profile.unitPanels.pulseStrength";
        };
        { name = L["Name Panels"]; type = "title" }; {
          name = L["Enabled"];
          module = "UnitPanels";
          dbPath = "profile.unitPanels.unitNames.enabled";
          type = "check";
        };
        {
          name = L["Target Class Colored"];
          type = "check";
          dbPath = "profile.unitPanels.unitNames.targetClassColored";
        };
        { type = "divider" };
        {
          name = L["Set Width"];
          type = "slider";
          min = 150;
          max = 300;
          step = 5;
          tooltip = L["Adjust the width of the unit name background panels."];
          dbPath = "profile.unitPanels.unitNames.width";
        }; {
          name = L["Set Height"];
          type = "slider";
          min = 15;
          max = 30;
          step = 1;
          tooltip = L["Adjust the height of the unit name background panels."];
          dbPath = "profile.unitPanels.unitNames.height";
        }; {
          name = L["X-Offset"];
          type = "slider";
          min = -50;
          max = 50;
          step = 1;
          tooltip = L["Move the unit name panels further in or out."];
          dbPath = "profile.unitPanels.unitNames.xOffset";
        }; {
          name = L["Font Size"];
          type = "slider";
          tooltip = L["Set the font size of unit names."];
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
          tooltip = L["The height of the gradient effect."];
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
      name = L["Action Bars"];
      children = {
        {
          type = "title";
          name = L["Background Panel Settings"],
          marginTop = 0;
        },
        {
          type = "fontstring";
          content = L["These settings control the MayronUI artwork behind the Bartender4 action bars."];
        },
        {
            type = "fontstring",
            subtype = "header",
            content = L["Bottom Panel"],
        },
        {
          type = "slider",
          name = L["Set Animation Speed"],
          min = 1; max = 10; step = 1;
          dbPath = "profile.actionbars.bottom.animation.speed";
          tooltip = L["The speed of the Expand and Retract transitions."]
            .. "\n" .. L["The higher the value, the quicker the speed."];
        },
        {
          type = "slider",
          name = L["Set Alpha"],
          dbPath = "profile.actionbars.bottom.alpha";
        },
        { type = "divider" };
        {
          type = "fontstring";
          content = L["Set the modifier key/s that should be pressed to show the arrow buttons."];
        };
        {
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
              dbPath = "profile.actionbars.bottom.animation.modKey";

              GetValue = function(_, currentValue)
                return GetModKeyValue(arg, currentValue);
              end;

              SetValue = function(self, newValue, oldValue)
                SetModKeyValue(arg, self.dbPath, newValue, oldValue);
              end;
            };
          end;
        };
        { type = "divider" };
        {
          name = L["Set Height Mode"];
          type = "dropdown";
          options = { [L["Dynamic"]] = "dynamic", [L["Manual"]] = "manual" };
          dbPath = "profile.actionbars.bottom.sizeMode";
          tooltip = L["If set to dynamic, MayronUI will calculate the optimal height for the selected Bartender4 action bars to fit inside the panel."];
          OnValueChanged = function(value)
            bottomPanelManualHeightOptions:SetShown(value == "manual");
            bottomPanelPaddingOption:SetShown(value == "dynamic");
            self:RefreshMenu();
          end
        };
        {
          type = "slider",
          name = L["Set Panel Padding"],
          dbPath = "profile.actionbars.bottom.panelPadding";
          min = 0; max = 20;
          OnLoad = function(_, slider)
            bottomPanelPaddingOption = slider;
          end;
          shown = function()
            return db.profile.actionbars.bottom.sizeMode == "dynamic";
          end;
        },
        {
          type = "frame";
          OnLoad = function(_, frame)
            bottomPanelManualHeightOptions = frame;
          end;
          shown = function()
            return db.profile.actionbars.bottom.sizeMode == "manual";
          end;
          children = {
            {
                type = "fontstring",
                subtype = "header",
                content = L["Manual Height Mode Settings"],
            },
            {
              type = "slider",
              name = L["Set Row 1 Height"],
              dbPath = "profile.actionbars.bottom.manualSizes[1]";
              min = 40; max = 300; step = 5;
            },
            {
              type = "slider",
              name = L["Set Row 2 Height"],
              dbPath = "profile.actionbars.bottom.manualSizes[2]";
              min = 40; max = 300; step = 5;
            },
            {
              type = "slider",
              name = L["Set Row 3 Height"],
              min = 40; max = 300; step = 5;
              dbPath = "profile.actionbars.bottom.manualSizes[3]";
            },
          },
        },
        {
            type = "fontstring",
            subtype = "header",
            content = L["Side Panel"],
        },
        {
          type = "slider",
          name = "Set Animation Speed",
          min = 1; max = 10; step = 1;
          dbPath = "profile.actionbars.side.animation.speed";
          tooltip = L["The speed of the Expand and Retract transitions."]
            .. "\n" .. L["The higher the value, the quicker the speed."];
        },
        {
          type = "slider",
          name = L["Set Alpha"],
          dbPath = "profile.actionbars.side.alpha";
        },
        {
          type = "slider",
          name = L["Set Y-Offset"],
          valueType = "number";
          dbPath = "profile.actionbars.side.yOffset";
          min = -200; max = 200; step = 10;
        },
        {
          type = "slider",
          name = L["Set Height"],
          dbPath = "profile.actionbars.side.height";
          min = 200; max = 800; step = 10;
        },
        { type = "divider" };
        {
          name = L["Set Arrow Button Visibility"];
          type = "dropdown";
          options = {
            [L["Always"]] = "Always";
            [L["On Mouse-over"]] = "On Mouse-over";
            [L["Never"]] = "Never";
          };
          dbPath = "profile.actionbars.side.animation.showWhen";
        };
        {
          name = L["Hide Arrow Buttons In Combat"];
          type = "check";
          dbPath = "profile.actionbars.side.animation.hideInCombat";
          height = 42;
          verticalAlignment = "BOTTOM";
        };
        { type = "divider" };
       {
          name = L["Set Width Mode"];
          type = "dropdown";
          options = { [L["Dynamic"]] = "dynamic", [L["Manual"]] = "manual" };
          dbPath = "profile.actionbars.side.sizeMode";
          tooltip = L["If set to dynamic, MayronUI will calculate the optimal width for the selected Bartender4 action bars to fit inside the panel."];
          OnValueChanged = function(value)
            sidePanelManualWidthOptions:SetShown(value == "manual");
            sidePanelPaddingOption:SetShown(value == "dynamic");
            self:RefreshMenu();
          end
        };
        {
          type = "slider",
          name = L["Set Panel Padding"],
          dbPath = "profile.actionbars.side.panelPadding";
          min = 0; max = 20;
          OnLoad = function(_, slider)
            sidePanelPaddingOption = slider;
          end;
          shown = function()
            return db.profile.actionbars.side.sizeMode == "dynamic";
          end;
        },
        {
          type = "frame";
          OnLoad = function(_, frame)
            sidePanelManualWidthOptions = frame;
          end;
          shown = function()
            return db.profile.actionbars.side.sizeMode == "manual";
          end;
          children = {
            {
              type = "fontstring",
              subtype = "header",
              content = L["Manual Side Panel Widths"],
            },
            {
              type = "slider",
              name = L["Set Column 1 Width"],
              dbPath = "profile.actionbars.side.manualSizes[1]";
              min = 40; max = 300; step = 5;
            },
            {
              type = "slider",
              name = L["Set Column 2 Width"],
              dbPath = "profile.actionbars.side.manualSizes[2]";
              min = 40; max = 300; step = 5;
            },
          },
        },
        {
          type = "title";
          name = L["Bartender4 Override Settings"],
        },
        {
          type = "fontstring";
          content = L["These settings control what MayronUI is allowed to do with the Bartender4 action bars. By default, MayronUI:"];
        },
        {
          type = "fontstring",
          list = {
            L["Fades action bars in and out when you press the provided arrow buttons."];
            L["Maintains the visibility of action bars between sessions of gameplay."];
            L["Sets the scale and padding of action bar buttons to best fit inside the background panels."];
            L["Sets and updates the position the action bars so they remain in place ontop of the background panels."]
          }
        },
        {
          type = "fontstring",
          subtype = "header",
          content = L["Bottom Bartender4 Action Bars"],
        },
        { type = "check";
          name = L["Control Bar Positioning"];
          dbPath = "profile.actionbars.bottom.bartender.controlPositioning";
          tooltip = L["If enabled, MayronUI will move the selected Bartender4 action bars into the correct position for you."]
        },
        { type = "check";
          name = L["Override Bar Padding"];
          dbPath = "profile.actionbars.bottom.bartender.controlPadding";
          tooltip = L["If enabled, MayronUI will set the padding of the selected Bartender4 action bar to best fit the background panel."]
        },
        { type = "check";
          name = L["Override Bar Scale"];
          dbPath = "profile.actionbars.bottom.bartender.controlScale";
          tooltip = L["If enabled, MayronUI will set the scale of the selected Bartender4 action bar to best fit the background panel."]
        },
        { type = "divider" };
        {
          type = "slider",
          name = L["Set Row Spacing"],
          dbPath = "profile.actionbars.bottom.bartender.spacing";
          min = 0; max = 20;
        },
        { type = "slider";
          name = L["Set Bar Padding"];
          dbPath = "profile.actionbars.bottom.bartender.padding";
          min = 0; max = 10; step = 0.1;
          enabled = "profile.actionbars.bottom.bartender.controlPadding";
        },
        { type = "slider";
          name = L["Set Bar Scale"];
          dbPath = "profile.actionbars.bottom.bartender.scale";
          min = 0.25; max = 2;
          enabled = "profile.actionbars.bottom.bartender.controlScale"
        },
        {
          type = "fontstring",
          content = L["The bottom panel can display and control up to two Bartender4 action bars per row."],
        },
        {
          type = "fontstring";
          content = L["Row"] .. " 1";
          height = 10;
        },
        {
          type = "dropdown";
          dbPath = "profile.actionbars.bottom.bartender[1][1]";
          GetOptions = GetBartender4ActionBarOptions;
        };
        {
          type = "dropdown";
          dbPath = "profile.actionbars.bottom.bartender[1][2]";
          GetOptions = GetBartender4ActionBarOptions;
        };
        {
          type = "fontstring";
          content = L["Row"] .. " 2";
          height = 10;
        },
        {
          type = "dropdown";
          dbPath = "profile.actionbars.bottom.bartender[2][1]";
          GetOptions = GetBartender4ActionBarOptions;
        };
        {
          type = "dropdown";
          dbPath = "profile.actionbars.bottom.bartender[2][2]";
          GetOptions = GetBartender4ActionBarOptions;
        };
        {
          type = "fontstring";
          content = L["Row"] .. " 3";
          height = 10;
        },
        {
          type = "dropdown";
          dbPath = "profile.actionbars.bottom.bartender[3][1]";
          GetOptions = GetBartender4ActionBarOptions;
        };
        {
          type = "dropdown";
          dbPath = "profile.actionbars.bottom.bartender[3][2]";
          GetOptions = GetBartender4ActionBarOptions;
        };
        {
          type = "fontstring",
          subtype = "header",
          content = L["Side Bartender4 Action Bars"],
        },
        { type = "check";
          name = L["Control Bar Positioning"];
          dbPath = "profile.actionbars.side.bartender.controlPositioning";
          tooltip = L["If enabled, MayronUI will move the selected Bartender4 action bars into the correct position for you."]
        },
        { type = "check";
          name = L["Override Bar Padding"];
          dbPath = "profile.actionbars.side.bartender.controlPadding";
          tooltip = L["If enabled, MayronUI will set the padding of the selected Bartender4 action bar to best fit the background panel."]
        },
        { type = "check";
          name = L["Override Bar Scale"];
          dbPath = "profile.actionbars.side.bartender.controlScale";
          tooltip = L["If enabled, MayronUI will set the scale of the selected Bartender4 action bar to best fit the background panel."]
        },
        { type = "divider" };
        {
          type = "slider",
          name = L["Set Column Spacing"],
          dbPath = "profile.actionbars.side.bartender.spacing";
          min = 0; max = 20;
        },
        { type = "slider";
          name = L["Set Bar Padding"];
          dbPath = "profile.actionbars.side.bartender.padding";
          min = 0; max = 10;
          enabled = "profile.actionbars.side.bartender.controlPadding"
        },

        { type = "slider";
          name = L["Set Bar Scale"];
          dbPath = "profile.actionbars.side.bartender.scale";
          min = 0.25; max = 2;
          enabled = "profile.actionbars.side.bartender.controlScale"
        },
        {
          name = L["Column"] .. " 1";
          type = "dropdown";
          dbPath = "profile.actionbars.side.bartender[1][1]";
          GetOptions = GetBartender4ActionBarOptions;
        };
        {
          name = L["Column"] .. " 2";
          type = "dropdown";
          dbPath = "profile.actionbars.side.bartender[2][1]";
          GetOptions = GetBartender4ActionBarOptions;
        };
      };
    }; {
      name = L["Resource Bars"];
      module = "ResourceBars";
      children = {
        {
          type = "loop";
          args = { "Experience"; "Reputation"; "Artifact"; "Azerite" };
          func = function(id, name)
            if (tk:IsRetail() and (name == "Artifact" or name == "Azerite")) then
              return
            end

            if (name == "Azerite" or name == "Artifact") then
              local manager = _G["StatusTrackingBarManager"];
              if (not manager or not obj:IsFunction(manager.CanShowBar)) then return end

              local barIndex;
              if (name == "Azerite") then
                barIndex = tk.Constants.RESOURCE_BAR_IDS.Azerite;
              else
                barIndex = tk.Constants.RESOURCE_BAR_IDS.Artifact;
              end

              if (not manager:CanShowBar(barIndex)) then return end
            end

            local key = name:lower() .. "Bar";
            local children = {
              {
                name = tk.Strings:JoinWithSpace(L[name], L["Bar"]);
                type = "title";
              }; {
                name = L["Enabled"];
                type = "check";
                dbPath = tk.Strings:Concat("profile.resourceBars.", key, ".enabled");
              }; {
                name = L["Show Text"];
                type = "check";
                dbPath = tk.Strings:Concat("profile.resourceBars.", key, ".alwaysShowText");
              }; {
                name = L["Height"];
                type = "slider";
                step = 1;
                min = 4;
                max = 30;
                dbPath = tk.Strings:Concat("profile.resourceBars.", key, ".height");
              }; {
                name = L["Font Size"];
                type = "slider";
                step = 1;
                min = 8;
                max = 18;
                dbPath = tk.Strings:Concat("profile.resourceBars.", key, ".fontSize");
              }; {
                type = "dropdown";
                name = L["Bar Texture"];
                media = "statusbar";
                dbPath = "profile.resourceBars."..key..".texture";
              };
            };

            if (id == 1) then
              children[1].marginTop = 0;
            end

            if (id == 2) then
              -- rep bar, so show color options
              AddRepStandingIDColorOptions(db.profile.resourceBars.reputationBar, children);
            end

            return children;
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
          tooltip = L["Adjust the width of the Objective Tracker."];
          dbPath = "profile.objectiveTracker.width";
          valueType = "number";
        }; {
          name = L["Set Height"];
          type = "slider";
          min = 300;
          max = 1000;
          step = 50;
          tooltip = L["Adjust the height of the Objective Tracker."];
          dbPath = "profile.objectiveTracker.height";
          valueType = "number";
        }; {
          name = L["X-Offset"];
          type = "slider";
          min = -300;
          max = 300;
          step = 1;
          tooltip = L["Adjust the horizontal positioning of the Objective Tracker."];
          dbPath = "profile.objectiveTracker.xOffset";
          valueType = "number";
        }; {
          name = L["Y-Offset"];
          type = "slider";
          min = -300;
          max = 300;
          step = 1;
          tooltip = L["Adjust the vertical positioning of the Objective Tracker."];
          dbPath = "profile.objectiveTracker.yOffset";
          valueType = "number";
        };
      };
    };
  };
end
