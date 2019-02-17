-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();
local C_ConfigModule = namespace.C_ConfigModule;

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
                    tooltip           = L["Warning: This will NOT change the color of CastBars!"];
                    dbPath            = "profile.theme.color";
                    height            = 54;
                    requiresReload    = true;

                    SetValue = function(_, value)
                        value.hex = tk.string.format('%02x%02x%02x', value.r * 255, value.g * 255, value.b * 255);
                        db.profile.theme.color = value;
                        db.profile.bottomui.gradients = nil;
                    end
                };
                {   type = "divider";
                };
                {   name              = "Movable Blizzard Frames";
                    type              = "check";
                    tooltip           = "Allows you to move Blizzard Frames";
                    dbPath            = "global.movable.enabled";

                    SetValue = function(dbPath, newValue)
                        db:SetPathValue(dbPath, newValue);
                        MayronUI:ImportModule("MovableFramesModule"):SetEnabled(newValue);
                    end
                };
                {   name = "Reset Blizzard Frame Positions";
                    width = 220;
                    type = "button";
                    tooltip = "Reset Blizzard frames back to their original position.";
                    OnClick = function()
                        MayronUI:ImportModule("MovableFramesModule"):ResetPositions();
                    end
                }
            }
        };
        {   name = L["Bottom UI Panels"];
            module = "BottomUI_Container";
            children = {
                {   name        = "Main Container Width:";
                    type        = "textfield";
                    valueType   = "number";
                    tooltip     = tk.Strings:Concat(
                        "Adjust the width of the main container.", "\n\n", L["Default value is "], "750");
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
                {   name    = L["Allow MUI to Control Unit Frames"];
                    tooltip = L["TT_MUI_CONTROL_SUF"];
                    type    = "check";
                    dbPath  = "profile.unitPanels.controlSUF";
                };
                {   name    = L["Allow MUI to Control Grid"];
                    tooltip = L["TT_MUI_CONTROL_GRID"];
                    type    = "check";
                    dbPath  = "profile.unitPanels.grid.anchorGrid";

                    enabled = function()
                        return _G.IsAddOnLoaded("Grid") and _G.GridLayoutFrame;
                    end
                };
                {   type = "divider";
                };
                {   name        = L["Unit Panel Width"];
                    type        = "textfield";
                    module      = "BottomUI_UnitPanels";
                    min         = 200;
                    valueType   = "number";
                    tooltip     = tk.Strings:Concat(L["Adjust the width of the unit frame background panels."], "\n\n",
                        L["Minimum value is "], "200", "\n\n", L["Default value is "], "325");
                    dbPath      = "profile.unitPanels.unitWidth";
                };
                {   name        = "Unit Panel Height";
                    type        = "textfield";
                    module      = "BottomUI_UnitPanels";
                    valueType   = "number";
                    tooltip     = tk.Strings:Concat("Adjust the height of the unit frame background panels.",
                        "\n\n", L["Default value is "], "75");
                    dbPath      = "profile.unitPanels.unitHeight";
                };
                {   name    = L["Name Panels"];
                    type    = "title";
                };
                {   name        = L["Width"];
                    type        = "textfield";
                    valueType   = "number";
                    tooltip     = tk.Strings:Concat(L["Adjust the width of the unit name background panels."], "\n\n",
                        L["Default value is "], "235");
                    dbPath      = "profile.unitPanels.unitNames.width";
                };
                {   name        = L["Height"];
                    type        = "textfield";
                    valueType   = "number";
                    tooltip     = tk.Strings:Concat(L["Adjust the height of the unit name background panels."], "\n\n",
                        L["Default value is "], "20");
                    dbPath      = "profile.unitPanels.unitNames.height";
                };
                {   name        = L["X-Offset"];
                    type        = "textfield";
                    valueType   = "number";
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
                    tooltip = tk.Strings:Concat(L["If the SUF Player or Target portrait bars are enabled, a class"],
                        "\n", L["colored gradient will overlay it."]);
                    dbPath  = "profile.unitPanels.sufGradients.enabled";
                };
                {   name    = L["Height"];
                    type    = "textfield";
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
        {   name = "Action Bars";
            module = "BottomUI_ActionBarPanel";
            children =  {
                {   name = "Bottom Action Bars";
                    type = "submenu";
                    children = {
                        {   name              = L["Enable Action Bar Panel"];
                            dbPath            = "profile.actionBarPanel.enabled";
                            tooltip           = "Enable or disable the background panel";
                            type              = "check";
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
                        };
                        {   name        = L["Retract Height"];
                            tooltip     = tk.Strings:Concat(
                                L["Set the height of the action bar panel when it\nis 'Retracted' to show 1 action bar row."],
                                "\n\n", L["Minimum value is "], "40", "\n\n", L["Default value is "], "44");
                            type        = "textfield";
                            valueType   = "number";
                            min         = 40;
                            dbPath      = "profile.actionBarPanel.retractHeight";
                        };
                        {   name        = L["Expand Height"];
                            tooltip     = tk.Strings:Concat(
                                L["Set the height of the action bar panel when it\nis 'Expanded' to show 2 action bar rows."],
                                "\n\n", L["Minimum value is "], "40", "\n\n", L["Default value is "], "80");
                            type        = "textfield";
                            valueType   = "number";
                            min         = 40;
                            dbPath      = "profile.actionBarPanel.expandHeight";
                        };
                        {   type    = "fontstring";
                            content = "Modifier key/s used to show Expand/Retract button:";
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
                            dbPath  = "profile.actionBarPanel.bartender.control"
                        };
                        {   type    = "fontstring";
                            content = L["Row 1"];
                            subtype = "header";
                        };
                        {   name    = L["First Bartender Bar"];
                            type    = "dropdown";
                            dbPath  = "profile.actionBarPanel.bartender[1]";
                            options = {
                                "Bar 1";
                                "Bar 2";
                                "Bar 3";
                                "Bar 4";
                                "Bar 5";
                                "Bar 6";
                                "Bar 7";
                                "Bar 8";
                                "Bar 9";
                            }
                        };
                        {   name    = L["Second Bartender Bar"];
                            dbPath  = "profile.actionBarPanel.bartender[2]";
                            type    = "dropdown";
                            options = {
                                "Bar 1";
                                "Bar 2";
                                "Bar 3";
                                "Bar 4";
                                "Bar 5";
                                "Bar 6";
                                "Bar 7";
                                "Bar 8";
                                "Bar 9";
                            }
                        };
                        {   type    = "fontstring";
                            content = L["Row 2"];
                            subtype = "header";
                        };
                        {   name    = L["First Bartender Bar"];
                            dbPath  = "profile.actionBarPanel.bartender[3]";
                            type    = "dropdown";
                            options = {
                                "Bar 1";
                                "Bar 2";
                                "Bar 3";
                                "Bar 4";
                                "Bar 5";
                                "Bar 6";
                                "Bar 7";
                                "Bar 8";
                                "Bar 9";
                            }
                        };
                        {   name    = L["Second Bartender Bar"];
                            dbPath  = "profile.actionBarPanel.bartender[4]";
                            type    = "dropdown";
                            options = {
                                "Bar 1";
                                "Bar 2";
                                "Bar 3";
                                "Bar 4";
                                "Bar 5";
                                "Bar 6";
                                "Bar 7";
                                "Bar 8";
                                "Bar 9";
                            }
                        }
                    }
                };
                {   name = "Side Action Bars";
                    type = "submenu";
                    children = {
                        {   name        = L["Width (With 1 Bar)"];
                            type        = "textfield";
                            tooltip     = L["Default value is "].."46";
                            valueType   = "number";
                            dbPath      = "profile.sidebar.retractWidth"
                        };
                        {   name        = L["Width (With 2 Bars)"];
                            tooltip     = L["Default value is "].."83";
                            type        = "textfield";
                            valueType   = "number";
                            dbPath      = "profile.sidebar.expandWidth"
                        };
                        {   type        = "divider";
                        };
                        {   name        = L["Height"];
                            tooltip     = L["Default value is "].."486";
                            type        = "textfield";
                            valueType   = "number";
                            dbPath      = "profile.sidebar.height"
                        };
                        {   name        = L["Y-Offset"];
                            tooltip     = L["Default value is "].."40";
                            type        = "textfield";
                            valueType   = "number";
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
                            options = {
                                "Bar 1";
                                "Bar 2";
                                "Bar 3";
                                "Bar 4";
                                "Bar 5";
                                "Bar 6";
                                "Bar 7";
                                "Bar 8";
                                "Bar 9";
                            }
                        };
                        {   name    = L["Second Bartender Bar"];
                            dbPath  = "profile.sidebar.bartender[2]";
                            type    = "dropdown";
                            options = {
                                "Bar 1";
                                "Bar 2";
                                "Bar 3";
                                "Bar 4";
                                "Bar 5";
                                "Bar 6";
                                "Bar 7";
                                "Bar 8";
                                "Bar 9";
                            }
                        };
                        {   name    = L["Expand and Retract Buttons"];
                            type    = "title"
                        };
                        {   name    = L["Hide in Combat"];
                            type    = "check";
                            height  = 60;
                            dbPath  = "profile.sidebar.buttons.hideInCombat";
                        };
                        {   name    = L["Show When"];
                            type    = "dropdown";
                            dbPath  = "profile.sidebar.buttons.showWhen";
                            options = {
                                L["Never"];
                                L["Always"];
                                L["On Mouse-over"]
                            };
                        };
                        {   type = "divider";
                        };
                        {   name        = L["Width"];
                            type        = "textfield";
                            tooltip     = L["Default value is "].."15";
                            dbPath      = "profile.sidebar.buttons.width";
                            valueType   = "number";
                        };
                        {   name        = L["Height"];
                            type        = "textfield";
                            tooltip     = L["Default value is "].."100";
                            dbPath      = "profile.sidebar.buttons.height";
                            valueType   = "number";
                        }
                    }
                }
            }
        };
        {   name = "Resource Bars";
            module = "BottomUI_ResourceBars";
            children = {
                {   type = "loop";
                    args = {"Artifact", "Reputation", "Experience"};
                    func = function(id, name)
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
                                tooltip = L["Default value is "].."10";
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
            name = "Objectives Tracker";
            module = "SideBarModule";
            children = {
                {   name        = "Objectives Tracker";
                    type        = "title";
                    marginTop   = 0;
                };
                {   name              = "Enable Changes";
                    tooltip           = L["Disable this to stop MUI from controlling the Objective Tracker."];
                    type              = "check";
                    dbPath            = "profile.sidebar.objectiveTracker.enabled";
                    module            = "SideBarModule";
                    requiresReload    = true;
                };
                {   name    = "Anchor to Side Bar";
                    tooltip = "Anchor the Objective Tracker to the action bar container on the right side of the screen.";
                    type    = "check";
                    dbPath  = "profile.sidebar.objectiveTracker.anchoredToSideBars";
                };
                {   type = "divider";
                };
                {   name        = L["Set Width"];
                    type        = "textfield";
                    tooltip     = tk.Strings:Concat(L["Adjust the width of the Objective Tracker."],"\n\n",
                                L["Default value is "], "250");
                    dbPath      = "profile.sidebar.objectiveTracker.width";
                    valueType   = "number";
                };
                {   name        = L["Set Height"];
                    type        = "textfield";
                    tooltip     = tk.Strings:Concat(L["Adjust the height of the Objective Tracker."], "\n\n",
                                L["Default value is "], "600");
                    dbPath      = "profile.sidebar.objectiveTracker.height";
                    valueType   = "number";
                };
                {   name        = L["X-Offset"];
                    type        = "textfield";
                    tooltip     = tk.Strings:Concat(L["Adjust the horizontal positioning of the Objective Tracker."],
                                    "\n\n", L["Default value is "], "-30");
                    dbPath      = "profile.sidebar.objectiveTracker.xOffset";
                    valueType   = "number";
                };
                {   name        = L["Y-Offset"];
                    type        = "textfield";
                    tooltip     = tk.Strings:Concat(L["Adjust the vertical positioning of the Objective Tracker."], "\n\n",
                                    L["Default value is "], "0");
                    dbPath      = "profile.sidebar.objectiveTracker.yOffset";
                    valueType   = "number";
                };
            };
        };
    };
end