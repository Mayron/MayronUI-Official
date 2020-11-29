-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local MayronUI = _G.MayronUI;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();
local C_ConfigModule = namespace.C_ConfigModule;
local expandRetractDependencies = {};
local bartenderControlDependencies = {};
local defaultHeightWidget;

local table, ipairs = _G.table, _G.ipairs;

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

local BartenderActionBars = {
  "Bar 1";
  "Bar 2";
  "Bar 3";
  "Bar 4";
  "Bar 5";
  "Bar 6";
  "Bar 7";
  "Bar 8";
  "Bar 9";
  "Bar 10";
};

local BartenderActionBarValues = {
  ["None"]  = 0,
  ["Bar 1"] = 1;
  ["Bar 2"] = 2;
  ["Bar 3"] = 3;
  ["Bar 4"] = 4;
  ["Bar 5"] = 5;
  ["Bar 6"] = 6;
  ["Bar 7"] = 7;
  ["Bar 8"] = 8;
  ["Bar 9"] = 9;
  ["Bar 10"] = 10;
};

function C_ConfigModule:GetConfigTable()
    return {
        {   name = L["General"];
            id = 1;
            children = {
                {   name              = L["Enable Master Font"];
                    tooltip           = L["Uncheck to prevent MUI from changing the game font."];
                    requiresRestart   = true;
                    dbPath            = "global.core.changeGameFont";
                    type              = "check";
                };
                {   name = L["Display Lua Errors"];
                    type = "check";

                    GetValue = function()
                      return tonumber(_G.GetCVar("ScriptErrors")) == 1;
                    end;

                    SetValue = function(_, value)
                      if (value) then
                        _G.SetCVar("ScriptErrors", "1");
                      else
                        _G.SetCVar("ScriptErrors", "0");
                      end
                    end
                };
                {   type = "divider"
                };
                {   name              = L["Master Font"];
                    type              = "dropdown";
                    options           = tk.Constants.LSM:List("font");
                    dbPath            = "global.core.font";
                    requiresRestart   = true;
                    fontPicker        = true;
                };
                {   name              = L["Set Theme Color"];
                    type              = "color";
                    dbPath            = "profile.theme.color";
                    height            = 54;
                    requiresReload    = true; -- TODO: This might not need to restart.

                    SetValue = function(_, value)
                        value.hex = string.format('%02x%02x%02x', value.r * 255, value.g * 255, value.b * 255);
                        db.profile.theme.color = value;
                        db.profile.bottomui.gradients = nil;
                    end
                };
                {   type = "divider";
                };
                {   name              = L["Movable Blizzard Frames"];
                    type              = "check";
                    tooltip           = L["Allows you to move Blizzard Frames outside of combat only."];
                    dbPath            = "global.movable.enabled";

                    SetValue = function(dbPath, newValue)
                        db:SetPathValue(dbPath, newValue);
                        MayronUI:ImportModule("MovableFramesModule"):SetEnabled(newValue);
                    end
                };
                {   name = L["Reset Blizzard Frame Positions"];
                    width = 220;
                    type = "button";
                    tooltip = L["Reset Blizzard frames back to their original position."];
                    OnClick = function()
                        MayronUI:ImportModule("MovableFramesModule"):ResetPositions();
                    end
                };
                {   type = "divider";
                };
                {   name              = L["Show AFK Display"];
                    type              = "check";
                    tooltip           = L["Enable/disable the AFK Display"];
                    dbPath            = "global.AFKDisplay.enabled";

                    SetValue = function(dbPath, newValue)
                        db:SetPathValue(dbPath, newValue);
                        MayronUI:ImportModule("AFKDisplay"):SetEnabled(newValue);
                    end
                };
                {   type = "title";
                    client = "retail";
                    name = "Talking Head Frame"
                };
                {   type = "fontstring";
                    client = "retail";
                    content = "This is the animated character portrait frame that shows when an NPC is talking to you."
                };
                {   name = "Top of Screen";
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
                },
                {   name = "Bottom of Screen";
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
                },
                {
                  name        = L["Y-Offset"];
                  type        = "textfield";
                  client = "retail";
                  valueType   = "number";
                  dbPath      = "global.movable.talkingHead.yOffset";
                }
            }
        };
        {   module = "BottomUI_Container";
            children = {
                {   name        = L["Set Width"];
                    type        = "slider";
                    min = 500;
                    max = 1500;
                    step = 50;
                    valueType   = "number";
                    tooltip     = tk.Strings:Concat(
                        L["Adjust the width of the main container."], "\n\n", L["Default value is "], "750");
                    dbPath      = "profile.bottomui.width";
                };
                {   name    = L["Unit Panels"];
                    type    = "title";
                };
                {   name    = L["Enable Unit Panels"];
                    module  = "BottomUI_UnitPanels";
                    dbPath  = "profile.unitPanels.enabled";
                    type    = "check";
                };
                {   name    = L["Symmetric Unit Panels"];
                    tooltip = L["Previously called 'Classic Mode'."];
                    type    = "check";
                    dbPath  = "profile.unitPanels.isSymmetric";
                };
                {   name    = "Pulse While Rested",
                    tooltip = "If enabled, the unit panels will fade in and out while resting.",
                    module  = "BottomUI_UnitPanels";
                    dbPath  = "profile.unitPanels.restingPulse";
                    type    = "check";
                };
                {   name    = "Target Class Color Gradient",
                    tooltip = "If enabled, the unit panel color will transition to the target's class color using a horizontal gradient effect.",
                    module  = "BottomUI_UnitPanels";
                    dbPath  = "profile.unitPanels.targetClassColored";
                    type    = "check";
                };
                {   name    = L["Allow MUI to Control Unit Frames"];
                    tooltip = L["TT_MUI_CONTROL_SUF"];
                    type    = "check";
                    dbPath  = "profile.unitPanels.controlSUF";
                };
                {   type = "divider";
                };
                {   name = L["Set Width"];
                    type = "slider";
                    module = "BottomUI_UnitPanels";
                    min = 200;
                    max = 500;
                    step = 10;
                    valueType   = "number";
                    tooltip     = tk.Strings:Concat(L["Adjust the width of the unit frame background panels."], "\n\n",
                        L["Minimum value is "], "200", "\n\n", L["Default value is "], "325");
                    dbPath      = "profile.unitPanels.unitWidth";
                };
                {   name        = L["Set Height"];
                    type        = "slider";
                    module      = "BottomUI_UnitPanels";
                    valueType   = "number";
                    min = 25;
                    max = 200;
                    step = 5;
                    tooltip     = tk.Strings:Concat(L["Adjust the height of the unit frame background panels."],
                        "\n\n", L["Default value is "], "75");
                    dbPath      = "profile.unitPanels.unitHeight";
                };
                {   name        = "Set Alpha";
                    type        = "slider";
                    module      = "BottomUI_UnitPanels";
                    valueType   = "number";
                    min = 0;
                    max = 1;
                    step = 0.1;
                    tooltip     = tk.Strings:Concat(L["Default value is "], "0.8");
                    dbPath      = "profile.unitPanels.alpha";
                };
                {   name    = L["Name Panels"];
                    type    = "title";
                };
                {   name        = L["Set Width"];
                    type        = "slider";
                    min = 150;
                    max = 300;
                    step = 5;
                    tooltip     = tk.Strings:Concat(L["Adjust the width of the unit name background panels."], "\n\n",
                        L["Default value is "], "235");
                    dbPath      = "profile.unitPanels.unitNames.width";
                };
                {   name        = L["Set Height"];
                    type        = "slider";
                    min = 15;
                    max = 30;
                    step = 1;
                    tooltip     = tk.Strings:Concat(L["Adjust the height of the unit name background panels."], "\n\n",
                        L["Default value is "], "20");
                    dbPath      = "profile.unitPanels.unitNames.height";
                };
                {   name        = L["X-Offset"];
                    type        = "slider";
                    min = -50;
                    max = 50;
                    step = 1;
                    tooltip     = tk.Strings:Concat(L["Move the unit name panels further in or out."],
                        "\n\n", L["Default value is "], "24");
                    dbPath      = "profile.unitPanels.unitNames.xOffset";
                };
                {   name    = L["Font Size"];
                    type    = "slider";
                    tooltip = tk.Strings:Concat(L["Set the font size of unit names."],
                        "\n\n", L["Default value is "], "11");
                    step    = 1;
                    min     = 8;
                    max     = 18;
                    dbPath  = "profile.unitPanels.unitNames.fontSize";
                };
                {   name    = L["Target Class Colored"];
                    type    = "check";
                    height  = 50;
                    dbPath  = "profile.unitPanels.unitNames.targetClassColored";
                };
                {   name    = L["SUF Portrait Gradient"];
                    type    = "title";
                };
                {   name    = L["Enable Gradient Effect"];
                    type    = "check";
                    tooltip = L["If the SUF Player or Target portrait bars are enabled, a class colored gradient will overlay it."];
                    dbPath  = "profile.unitPanels.sufGradients.enabled";
                };
                {   name    = L["Set Height"];
                    type        = "slider";
                    min = 1;
                    max = 50;
                    step = 1;
                    tooltip = tk.Strings:Concat(L["The height of the gradient effect."], "\n\n", L["Default value is "], "24");
                    dbPath  = "profile.unitPanels.sufGradients.height";
                };
                {   type    = "fontstring";
                    content = L["Gradient Colors"];
                    subtype = "header";
                };
                {   name          = L["Start Color"];
                    type          = "color";
                    hasOpacity    = true;
                    width         = 150;
                    tooltip       = L["What color the gradient should start as."];
                    dbPath        = "profile.unitPanels.sufGradients.from";
                };
                {   name          = L["End Color"];
                    width         = 150;
                    tooltip       = L["What color the gradient should change into."];
                    type          = "color";
                    hasOpacity    = true;
                    dbPath        = "profile.unitPanels.sufGradients.to";
                };
                {   name    = L["Target Class Colored"];
                    tooltip = L["TT_MUI_USE_TARGET_CLASS_COLOR"];
                    type    = "check";
                    dbPath  = "profile.unitPanels.sufGradients.targetClassColored";
                };
            }
        };
        {   module = "BottomUI_ActionBarPanel";
            children =  {
                {   name = L["Bottom Action Bars"];
                    type = "submenu";
                    children = {
                        {   name              = L["Enable Panel"];
                            dbPath            = "profile.actionBarPanel.enabled";
                            tooltip           = L["Enable or disable the background panel"];
                            type              = "check";
                        };
                        {   type              = "divider";
                        };
                        {   name    = "Set Alpha";
                            type    = "slider";
                            step    = 0.1;
                            min     = 0;
                            max     = 1;
                            dbPath  = "profile.actionBarPanel.alpha"
                        };
                        {   name              = L["Set Height"];
                            dbPath            = "profile.actionBarPanel.defaultHeight";
                            tooltip           = "This is the fixed default height to use when the expand and retract feature is disabled.";
                            type              = "slider";
                            min         = 40;
                            max         = 400;
                            OnLoad = function(_, container)
                              defaultHeightWidget = container.widget;
                            end;
                            enabled = function()
                              return not db.profile.actionBarPanel.expandRetract;
                            end
                        };
                        {   name    = "Expanding and Retracting Action Bar Rows";
                            type    = "title";
                        };
                        {   name              = "Enable Expand and Retract Feature";
                            dbPath            = "profile.actionBarPanel.expandRetract";
                            tooltip           = "If disabled, you will not be able to toggle between 1 and 2 rows of action bars.";
                            type              = "check";
                            SetValue = function(dbPath, value)
                              for _, widget in ipairs(expandRetractDependencies) do
                                widget:SetEnabled(value);
                              end

                              defaultHeightWidget:SetEnabled(not value);
                              db:SetPathValue(dbPath, value);
                            end;
                        };
                        {   type              = "divider";
                        };
                        {   name    = L["Animation Speed"];
                            type    = "slider";
                            tooltip = tk.Strings:Concat(L["The speed of the Expand and Retract transitions."], "\n\n",
                                L["The higher the value, the quicker the speed."], "\n\n", L["Default value is "], "6");
                            step    = 1;
                            min     = 1;
                            max     = 10;
                            dbPath  = "profile.actionBarPanel.animateSpeed";
                            OnLoad = function(_, container)
                              table.insert(expandRetractDependencies, container.widget);
                            end;
                            enabled = function()
                              return db.profile.actionBarPanel.expandRetract;
                            end
                        };
                        {   name        = L["Retract Height"];
                            tooltip     = tk.Strings:Concat(
                                L["Set the height of the action bar panel when it\nis 'Retracted' to show 1 action bar row."],
                                "\n\n", L["Minimum value is "], "40", "\n\n", "Maximum value is ", "200", "\n\n", L["Default value is "], "44");
                            type        = "slider";
                            min         = 40;
                            max         = 400;
                            dbPath      = "profile.actionBarPanel.retractHeight";
                            OnLoad = function(_, container)
                              table.insert(expandRetractDependencies, container.widget);
                            end;
                            enabled = function()
                              return db.profile.actionBarPanel.expandRetract;
                            end
                        };
                        {   name        = L["Expand Height"];
                            tooltip     = tk.Strings:Concat(
                                L["Set the height of the action bar panel when it\nis 'Expanded' to show 2 action bar rows."],
                                "\n\n", L["Minimum value is "], "40", "\n\n", "Maximum value is ", "200", "\n\n", L["Default value is "], "80");
                            type        = "slider";
                            min         = 40;
                            max         = 400;
                            dbPath      = "profile.actionBarPanel.expandHeight";
                            OnLoad = function(_, container)
                              table.insert(expandRetractDependencies, container.widget);
                            end;
                            enabled = function()
                              return db.profile.actionBarPanel.expandRetract;
                            end
                        };
                        { type = "divider" };
                        {   type    = "fontstring";
                            content = L["Modifier key/s used to show Expand/Retract button:"];
                        };
                        {
                            type = "loop";
                            args = { "C", "S", "A" };
                            func = function(_, arg)
                                local name = L["Alt"];

                                if (arg == "C") then
                                    name = L["Control"];

                                elseif (arg == "S") then
                                    name = L["Shift"];
                                end

                                return {
                                    name    = name;
                                    height  = 40;
                                    type    = "check";
                                    dbPath  = "profile.actionBarPanel.modKey";

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
                                    end
                                };
                            end
                        };
                        {   name    = L["Bartender Action Bars"];
                            type    = "title";
                        };
                        {   name    = L["Allow MUI to Control Selected Bartender Bars"];
                            type    = "check";
                            tooltip = L["TT_MUI_CONTROL_BARTENDER"];
                            dbPath  = "profile.actionBarPanel.bartender.control";

                            SetValue = function(dbPath, value)
                              for _, widget in ipairs(bartenderControlDependencies) do
                                widget:SetEnabled(value);
                              end

                              db:SetPathValue(dbPath, value);
                            end;
                        };
                        {   type    = "fontstring";
                            content = L["Row"] .. "1";
                            subtype = "header";
                        };
                        {   name    = L["First Bartender Bar"];
                            type    = "dropdown";
                            dbPath  = "profile.actionBarPanel.bartender[1][1]";
                            options = BartenderActionBarValues;
                            OnLoad = function(_, container)
                              table.insert(bartenderControlDependencies, container.widget);
                            end;

                            enabled = function()
                              return db.profile.actionBarPanel.bartender.control;
                            end;
                        };
                        {   name    = L["Second Bartender Bar"];
                            dbPath  = "profile.actionBarPanel.bartender[1][2]";
                            type    = "dropdown";
                            options = BartenderActionBarValues;
                            OnLoad = function(_, container)
                              table.insert(bartenderControlDependencies, container.widget);
                            end;
                            enabled = function()
                              return db.profile.actionBarPanel.bartender.control;
                            end
                        };
                        {   type    = "fontstring";
                            content = L["Row"] .. "2";
                            subtype = "header";
                        };
                        {   name    = L["First Bartender Bar"];
                            dbPath  = "profile.actionBarPanel.bartender[2][1]";
                            type    = "dropdown";
                            options = BartenderActionBarValues;
                            OnLoad = function(_, container)
                              table.insert(bartenderControlDependencies, container.widget);
                            end;
                            enabled = function()
                              return db.profile.actionBarPanel.bartender.control;
                            end
                        };
                        {   name    = L["Second Bartender Bar"];
                            dbPath  = "profile.actionBarPanel.bartender[2][2]";
                            type    = "dropdown";
                            options = BartenderActionBarValues;
                            OnLoad = function(_, container)
                              table.insert(bartenderControlDependencies, container.widget);
                            end;
                            enabled = function()
                              return db.profile.actionBarPanel.bartender.control;
                            end
                        },
                        {   type    = "fontstring";
                            content = L["Row"] .. "3";
                            subtype = "header";
                        };
                        {   name    = L["First Bartender Bar"];
                            dbPath  = "profile.actionBarPanel.bartender[3][1]";
                            type    = "dropdown";
                            options = BartenderActionBarValues;
                            OnLoad = function(_, container)
                              table.insert(bartenderControlDependencies, container.widget);
                            end;
                            enabled = function()
                              return db.profile.actionBarPanel.bartender.control;
                            end
                        };
                        {   name    = L["Second Bartender Bar"];
                            dbPath  = "profile.actionBarPanel.bartender[3][2]";
                            type    = "dropdown";
                            options = BartenderActionBarValues;
                            OnLoad = function(_, container)
                              table.insert(bartenderControlDependencies, container.widget);
                            end;
                            enabled = function()
                              return db.profile.actionBarPanel.bartender.control;
                            end
                        }
                    }
                };
                {   name = L["Side Action Bars"];
                    type = "submenu";
                    children = {
                        {   name = "Enable Panel",
                            tooltip = L["Enable or disable the background panel"];
                            type = "check",
                            dbPath = "profile.sidebar.enabled",
                        },
                        {
                          type = "divider"
                        },
                        {   name        = L["Width (With 1 Bar)"];
                            type        = "slider";
                            min = 20,
                            max = 100,
                            tooltip     = L["Default value is "].."46";
                            dbPath      = "profile.sidebar.retractWidth"
                        };
                        {   name        = L["Width (With 2 Bars)"];
                            tooltip     = L["Default value is "].."83";
                            type        = "slider";
                            min = 20,
                            max = 200,
                            dbPath      = "profile.sidebar.expandWidth"
                        };
                        {   type        = "divider";
                        };
                        {   name        = L["Set Height"];
                            tooltip     = L["Default value is "].."486";
                            type        = "slider";
                            min = 200,
                            max = 800,
                            step = 5,
                            dbPath      = "profile.sidebar.height"
                        };
                        {   name        = L["Y-Offset"];
                            tooltip     = L["Default value is "].."40";
                            type        = "slider";
                            min = -300,
                            max = 300,
                            step = 5,
                            dbPath      = "profile.sidebar.yOffset"
                        };
                        {   type        = "divider";
                        };
                        {   name    = L["Animation Speed"];
                            type    = "slider";
                            tooltip = L["The speed of the Expand and Retract transitions."].."\n\n"..
                                        L["The higher the value, the quicker the speed."].."\n\n"..
                                        L["Default value is "].."6.";
                            step    = 1;
                            min     = 1;
                            max     = 10;
                            dbPath  = "profile.sidebar.animationSpeed"
                        };
                        {   name    = "Set Alpha";
                            type    = "slider";
                            step    = 0.1;
                            min     = 0;
                            max     = 1;
                            dbPath  = "profile.sidebar.alpha"
                        };
                        {   name    = L["Bartender Action Bars"];
                            type    = "title";
                        };
                        {   name    = L["Allow MUI to Control Selected Bartender Bars"];
                            type    = "check";
                            dbPath  = "profile.sidebar.bartender.control";
                            tooltip = L["TT_MUI_CONTROL_BARTENDER"];
                        };
                        {   type = "divider";
                        };
                        {   name    = L["First Bartender Bar"];
                            dbPath  = "profile.sidebar.bartender[1]";
                            type    = "dropdown";
                            options = BartenderActionBars;
                        };
                        {   name    = L["Second Bartender Bar"];
                            dbPath  = "profile.sidebar.bartender[2]";
                            type    = "dropdown";
                            options = BartenderActionBars;
                        };
                        {   name    = L["Expand and Retract Buttons"];
                            type    = "title"
                        };
                        {   name    = L["Hide in Combat"];
                            type    = "check";
                            dbPath  = "profile.sidebar.buttons.hideInCombat";
                        };
                        {   name    = L["Show When"];
                            type    = "dropdown";
                            dbPath  = "profile.sidebar.buttons.showWhen";
                            options = {
                                [L["Never"]] = "Never";
                                [L["Always"]] = "Always";
                                [L["On Mouse-over"]] = "On Mouse-over"
                            };
                        };
                        {   type = "divider";
                        };
                        {   name        = L["Set Width"];
                            type        = "slider";
                            tooltip     = tk.Strings:Concat(L["Default value is "], "15.", "\n\n",
                                            L["Minimum value is"], " ", 15, "\n\n", L["Maximum value is"], " ", 30);
                            dbPath      = "profile.sidebar.buttons.width";
                            min         = 15;
                            max         = 30;
                            valueType   = "number";
                        };
                        {   name        = L["Set Height"];
                            type        = "slider";
                            tooltip     = tk.Strings:Concat(L["Default value is "], "100.", "\n\n",
                                            L["Minimum value is"], " ", 50, "\n\n", L["Maximum value is"], " ", 300);
                            dbPath      = "profile.sidebar.buttons.height";
                            min         = 50;
                            max         = 300;
                        }
                    }
                }
            }
        };
        {   name = "Resource Bars";
            module = "BottomUI_ResourceBars";
            children = {
                {   type = "loop";
                    args = { "Artifact", "Azerite", "Experience", "Reputation" };
                    func = function(id, name)
                        if (tk:IsClassic() and (name == "Artifact" or name == "Azerite")) then
                          return
                        end

                        if (name == "Azerite" and not _G.AzeriteBarMixin:ShouldBeVisible()) then
                          return
                        end

                        if (name == "Artifact" and not _G.ArtifactBarMixin:ShouldBeVisible()) then
                          return
                        end

                        local key = name:lower().."Bar";
                        local child = {
                            {   name    = tk.Strings:JoinWithSpace(L[name], L["Bar"]);
                                type    = "title";
                            };
                            {   name    = L["Enabled"];
                                type    = "check";
                                tooltip = L["Default value is "]..L["true"];
                                dbPath  = tk.Strings:Concat("profile.resourceBars.", key, ".enabled");
                            };
                            {   name    = L["Show Text"];
                                type    = "check";
                                tooltip = L["Default value is "]..L["false"];
                                dbPath  = tk.Strings:Concat("profile.resourceBars.", key, ".alwaysShowText");
                            };
                            {   name    = L["Height"];
                                type    = "slider";
                                step    = 1;
                                min     = 4;
                                max     = 30;
                                tooltip = L["Default value is "].."8";
                                dbPath  = tk.Strings:Concat("profile.resourceBars.", key, ".height");
                            };
                            {   name    = L["Font Size"];
                                type    = "slider";
                                step    = 1;
                                min     = 8;
                                max     = 18;
                                tooltip = L["Default value is "].."8";
                                dbPath  = tk.Strings:Concat("profile.resourceBars.", key, ".fontSize");
                            };
                        };

                        if (id == 1) then
                            child[1].marginTop = 0;
                        end

                        return child;
                    end
                };
            }
        };
        {
            module = "ObjectiveTrackerModule";
            client = "retail";
            children = {
                {   name        = L["Objective Tracker"];
                    type        = "title";
                    marginTop   = 0;
                };
                {   name              = L["Enable Changes"];
                    tooltip           = L["Disable this to stop MUI from controlling the Objective Tracker."];
                    type              = "check";
                    dbPath            = "profile.objectiveTracker.enabled";
                    requiresReload    = true; -- TODO: Change this to "global" and then I don't need to restart.
                };
                {   name              = L["Collapse in Instance"];
                    tooltip           = L["If true, the objective tracker will collapse when entering an instance."];
                    type              = "check";
                    dbPath            = "profile.objectiveTracker.hideInInstance";
                };
                {   name    = L["Anchor to Side Bar"];
                    tooltip = L["Anchor the Objective Tracker to the action bar container on the right side of the screen."];
                    type    = "check";
                    dbPath  = "profile.objectiveTracker.anchoredToSideBars";
                };
                {   type = "divider";
                };
                {   name        = L["Set Width"];
                    type = "slider",
                    min = 150;
                    max = 400;
                    step = 50;
                    tooltip     = tk.Strings:Concat(L["Adjust the width of the Objective Tracker."],"\n\n",
                                L["Default value is "], "250");
                    dbPath      = "profile.objectiveTracker.width";
                    valueType   = "number";
                };
                {   name        = L["Set Height"];
                    type = "slider",
                    min = 300;
                    max = 1000;
                    step = 50;
                    tooltip     = tk.Strings:Concat(L["Adjust the height of the Objective Tracker."], "\n\n",
                                L["Default value is "], "600");
                    dbPath      = "profile.objectiveTracker.height";
                    valueType   = "number";
                };
                {   name        = L["X-Offset"];
                    type = "slider",
                    min = -300;
                    max = 300;
                    step = 1;
                    tooltip     = tk.Strings:Concat(L["Adjust the horizontal positioning of the Objective Tracker."],
                                    "\n\n", L["Default value is "], "-30");
                    dbPath      = "profile.objectiveTracker.xOffset";
                    valueType   = "number";
                };
                {   name        = L["Y-Offset"];
                    type = "slider",
                    min = -300;
                    max = 300;
                    step = 1;
                    tooltip     = tk.Strings:Concat(L["Adjust the vertical positioning of the Objective Tracker."], "\n\n",
                                    L["Default value is "], "0");
                    dbPath      = "profile.objectiveTracker.yOffset";
                    valueType   = "number";
                };
            };
        };
    };
end