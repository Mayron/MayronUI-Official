local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();
local configModule = MayronUI:ImportModule("Config");

configModule.ConfigData = 
{   
    name = L["General"],
    type = "category",
    children = {
        {   name = L["Enable Master Font"],
            tooltip = L["Uncheck to prevent MUI from changing the game font."],
            requiresRestart = true,
            dbPath = "global.core.changeGameFont",
            type = "check",
        },
        {   name = L["Display Lua Errors"],
            type = "check",
            GetValue = function()
                return tonumber(GetCVar("ScriptErrors")) == 1;
            end,
            SetValue = function(value)
                if (value) then
                    SetCVar("ScriptErrors","1");
                else
                    SetCVar("ScriptErrors","0");
                end
            end
        },
        {   type = "divider" 
        },
        {   name = L["Master Font"],
            type = "dropdown",
            options = tk.Constants.LSM:List("font"),
            dbPath = "global.core.font",
            requiresRestart = true,
            fontPicker = true,
        },
        {   type = "divider"
        },
        {   name = L["Set Theme Color"],
            type = "color",
            tooltip = L["Warning: This will NOT change the color of CastBars!"],
            dbPath = "profile.theme.color",
            requiresReload = true,
            SetValue = function(_, _, value)
                value.hex = tk.string.format('%02x%02x%02x', value.r * 255, value.g * 255, value.b * 255);
                db.profile.theme.color = value;
                db.profile["profile.bottomui.gradients"] = nil;
            end
        },
        {   name = L["Objective (Quest) Tracker"],
            type = "title"
        },
        {   name = "Enable",
            tooltip = L["Disable this to stop MUI from controlling the Objective Tracker."],
            type = "check",
            dbPath = "profile.sidebar.objective_tracker.enabled",
            module = "SideBar",
            requiresReload = true,
        },
        {   name = L["Anchor to Side Bar"],
            tooltip = L["Anchor the Objective Tracker to the action bar container on the right side of the screen."],
            type = "check",
            dbPath = "profile.sidebar.objective_tracker.anchored_to_sidebars",
            module = "SideBar",
        },
        {   type = "divider",
        },
        {   name = L["Set Width"],
            type = "textfield",
            tooltip = L["Adjust the width of the Objective Tracker."].."\n\n"..
                        L["Default value is "].."250",
            dbPath = "profile.sidebar.objective_tracker.width",
            value_type = "number",
            module = "SideBar",
        },
        {   name = L["Set Height"],
            type = "textfield",
            tooltip = L["Adjust the height of the Objective Tracker."].."\n\n"..
                        L["Default value is "].."600",
            dbPath = "profile.sidebar.objective_tracker.height",
            value_type = "number",
            module = "SideBar",
        },
        {   name = L["X-Offset"],
            type = "textfield",
            tooltip = L["Adjust the horizontal positioning of the Objective Tracker."].."\n\n"..
                        L["Default value is "].."-30",
            dbPath = "profile.sidebar.objective_tracker.xOffset",
            value_type = "number",
            module = "SideBar",
        },
        {   name = L["Y-Offset"],
            type = "textfield",
            tooltip = L["Adjust the vertical positioning of the Objective Tracker."].."\n\n"..
                        L["Default value is "].."0",
            dbPath = "profile.sidebar.objective_tracker.yOffset",
            value_type = "number",
            module = "SideBar",
        }
    },
    {   name = L["Bottom UI Panels"],
        module = "BottomUI",
        type = "category",
        children = {
            {   name = L["General Options"],
                type = "title",
                padding_top = 0
            },
            {   name = L["Container Width"],
                type = "slider",
                tooltip = L["Adjust the width of the Bottom UI container."].."\n\n"..
                            L["Minimum value is "].."680".."\n\n"..
                            L["Default value is "].."750",
                step = 5,
                min = 680,
                max = 1200,
                dbPath = "profile.bottomui.width",
            },
            {   name = L["Unit Panels"],
                type = "title",
                padding_top = 0
            },
            {   name = L["Enable Unit Panels"],
                dbPath = "profile.bottomui.unit_panels.enabled",
                requiresReload = true,
                type = "check",
            },
            {   name = L["Symmetric Unit Panels"],
                tooltip = L["Previously called 'Classic Mode'."],
                type = "check",
                requiresReload = true,
                dbPath = "profile.bottomui.unit_panels.classicMode"
            },
            {   name = L["Allow MUI to Control Unit Frames"],
                tooltip = L["TT_MUI_CONTROL_SUF"],
                type = "check",
                requiresReload = true,
                dbPath = "profile.bottomui.unit_panels.control_SUF"
            },
            {   name = L["Allow MUI to Control Grid"],
                tooltip = L["TT_MUI_CONTROL_GRID"],
                type = "check",
                requiresReload = true,
                dbPath = "profile.bottomui.unit_panels.control_Grid"
            },
            {   type = "divider",
            },
            {   name = L["Unit Panel Width"],
                type = "slider",
                step = 5,
                min = 200,
                max = 550,
                tooltip = L["Adjust the width of the unit frame background panels."].."\n\n"..
                            L["Minimum value is "].."200".."\n\n"..
                            L["Default value is "].."325",
                dbPath = "profile.bottomui.unit_panels.unit_width",
            },
            {   name = L["Name Panels"],
                type = "title",
            },
            {   name = L["Width"],
                type = "slider",
                tooltip = L["Adjust the width of the unit name background panels."].."\n\n"..
                            L["Default value is "].."235",
                step = 5,
                min = 150,
                max = 350,
                dbPath = "profile.bottomui.unit_panels.unit_names.width",
            },
            {   name = L["Height"],
                type = "slider",
                tooltip = L["Adjust the height of the unit name background panels."].."\n\n"..
                            L["Default value is "].."20",
                step = 1,
                min = 16,
                max = 30,
                dbPath = "profile.bottomui.unit_panels.unit_names.height",
            },
            {   name = L["X-Offset"],
                type = "slider",
                tooltip = L["Move the unit name panels further in or out."].."\n\n"..
                            L["Default value is "].."24",
                step = 1,
                min = -100,
                max = 100,
                dbPath = "profile.bottomui.unit_panels.unit_names.xOffset",
            },
            {   name = L["Font Size"],
                type = "slider",
                tooltip = L["Set the font size of unit names."].."\n\n"..
                            L["Default value is "].."11",
                step = 1,
                min = 8,
                max = 18,
                dbPath = "profile.bottomui.unit_panels.unit_names.fontSize",
            },
            {   name = L["Target Class Colored"],
                type = "check",
                height = 50,
                dbPath = "profile.bottomui.unit_panels.unit_names.target_class_colored"
            },
            {   name = L["Action Bar Panel"],
                type = "title",
                padding_top = 0
            },
            {   name = L["Enable Action Bar Panel"],
                dbPath = "profile.bottomui.actionbar_panel.enabled",
                requiresReload = true,
                type = "check",
            },
            {   name = L["Animation Speed"],
                type = "slider",
                tooltip = L["The speed of the Expand and Retract transitions."].."\n\n"..
                            L["The higher the value, the quicker the speed."].."\n\n"..
                            L["Default value is "].."6",
                step = 1,
                min = 1,
                max = 10,
                dbPath = "profile.bottomui.actionbar_panel.animate_speed",
            },
            {   name = L["Retract Height"],
                tooltip = L["Set the height of the action bar panel when it\nis 'Retracted' to show 1 action bar row."].."\n\n"..
                            L["Minimum value is "].."40".."\n\n"..
                            L["Default value is "].."44",
                type = "textfield",
                value_type = "number",
                min = 40,
                dbPath = "profile.bottomui.actionbar_panel.retract_height"
            },
            {   name = L["Expand Height"],
                tooltip = L["Set the height of the action bar panel when it\nis 'Expanded' to show 2 action bar rows."].."\n\n"..
                            L["Minimum value is "].."40".."\n\n"..
                            L["Default value is "].."80",
                type = "textfield",
                value_type = "number",
                min = 40,
                dbPath = "profile.bottomui.actionbar_panel.expand_height"
            },
            {   type = "fontstring",
                content = "Modifier keys used to show Expand/Retract buttons:"
            },
            {   name = L["Control"],
                height = 40,
                min_width = true,
                type = "check",
                dbPath = "profile.bottomui.actionbar_panel.mod_key",
                GetValue = function(_, current_value)
                    return current_value:find("C");
                end,
                SetValue = function(dbPath, old_value, value)
                    value = value and "C";
                    if (not value) then
                        if (old_value:find("C")) then
                            value = old_value:gsub("C", "")
                        end
                    else
                        value = old_value..value;
                    end
                    db:SetPathValue(dbPath, value);
                end
            },
            {   name = L["Shift"],
                height = 40,
                min_width = true,
                type = "check",
                dbPath = "profile.bottomui.actionbar_panel.mod_key",
                GetValue = function(_, current_value)
                    return current_value:find("S");
                end,
                SetValue = function(dbPath, old_value, value)
                    value = value and "S";
                    if (not value) then
                        if (old_value:find("S")) then
                            value = old_value:gsub("S", "")
                        end
                    else
                        value = old_value..value;
                    end
                    db:SetPathValue(dbPath, value);
                end
            },
            {   name = L["Alt"],
                height = 40,
                min_width = true,
                type = "check",
                dbPath = "profile.bottomui.actionbar_panel.mod_key",
                GetValue = function(_, current_value)
                    return current_value:find("A");
                end,
                SetValue = function(dbPath, old_value, value) -- the path and the new value
                    value = value and "A";
                    if (not value) then
                        if (old_value:find("A")) then
                            value = old_value:gsub("A", "");
                        end
                    else
                        value = old_value..value;
                    end
                    db:SetPathValue(dbPath, value);
                end
            },
            {   name = L["SUF Portrait Gradient"],
                type = "title",
            },
            {   name = L["Enable Gradient Effect"],
                type = "check",
                tooltip = L["If the SUF Player or Target portrait bars are enabled, a class"].."\n"..
                            L["colored gradient will overlay it."],
                dbPath = "profile.bottomui.gradients.enabled"
            },
            {   name = L["Height"],
                type = "slider",
                tooltip = L["The height of the gradient effect."].."\n\n"..
                            L["Default value is "].."24",
                step = 1,
                min = 1,
                max = 50,
                width = 250,
                dbPath = "profile.bottomui.gradients.height",
            },
            {   type = "fontstring",
                content = L["Gradient Colors"],
                subtype = "header",
            },
            {   name = L["Start Color"],
                type = "color",
                width = 150,
                tooltip = L["What color the gradient should start as."],
                dbPath = "profile.bottomui.gradients.from",
            },
            {   name = L["End Color"],
                width = 150,
                tooltip = L["What color the gradient should change into."],
                type = "color",
                dbPath = "profile.bottomui.gradients.to",
            },
            {   name = L["Target Class Colored"],
                tooltip = L["TT_MUI_USE_TARGET_CLASS_COLOR"],
                type = "check",
                dbPath = "profile.bottomui.gradients.target_class_colored",
            },
            {   name = L["Bartender Action Bars"],
                type = "title",
            },
            {   name = L["Allow MUI to Control Selected Bartender Bars"],
                type = "check",
                tooltip = L["TT_MUI_CONTROL_BARTENDER"],
                dbPath = "profile.bottomui.actionbar_panel.bartender.control"
            },
            {   type = "fontstring",
                content = L["Row 1"],
                subtype = "header",
            },
            {   name = L["First Bartender Bar"],
                type = "dropdown",
                dbPath = "profile.bottomui.actionbar_panel.bartender[1]",
                options = {
                    "Bar 1",
                    "Bar 2",
                    "Bar 3",
                    "Bar 4",
                    "Bar 5",
                    "Bar 6",
                    "Bar 7",
                    "Bar 8",
                    "Bar 9",
                }
            },
            {   name = L["Second Bartender Bar"],
                dbPath = "profile.bottomui.actionbar_panel.bartender[2]",
                type = "dropdown",
                options = {
                    "Bar 1",
                    "Bar 2",
                    "Bar 3",
                    "Bar 4",
                    "Bar 5",
                    "Bar 6",
                    "Bar 7",
                    "Bar 8",
                    "Bar 9",
                }
            },
            {   type = "fontstring",
                content = L["Row 2"],
                subtype = "header",
            },
            {   name = L["First Bartender Bar"],
                dbPath = "profile.bottomui.actionbar_panel.bartender[3]",
                type = "dropdown",
                options = {
                    "Bar 1",
                    "Bar 2",
                    "Bar 3",
                    "Bar 4",
                    "Bar 5",
                    "Bar 6",
                    "Bar 7",
                    "Bar 8",
                    "Bar 9",
                }
            },
            {   name = L["Second Bartender Bar"],
                dbPath = "profile.bottomui.actionbar_panel.bartender[4]",
                type = "dropdown",
                options = {
                    "Bar 1",
                    "Bar 2",
                    "Bar 3",
                    "Bar 4",
                    "Bar 5",
                    "Bar 6",
                    "Bar 7",
                    "Bar 8",
                    "Bar 9",
                }
            },
            {   type = "loop",
                args = {"Artifact", "Reputation", "XP"},
                func = function(_, name)
                    local key = name:lower().."Bar";
                    local child = {
                        {   name = L[name].." "..L["Bar"],
                            type = "title",
                        },
                        {   name = L["Enabled"],
                            type = "check",
                            tooltip = L["Default value is "]..L["true"],
                            dbPath = "profile.bottomui."..key..".enabled",
                        },
                        {   name = L["Show Text"],
                            type = "check",
                            tooltip = L["Default value is "]..L["false"],
                            dbPath = "profile.bottomui."..key..".show_text",
                        },
                        {   name = L["Height"],
                            type = "slider",
                            step = 1,
                            min = 4,
                            max = 30,
                            tooltip = L["Default value is "].."8",
                            dbPath = "profile.bottomui."..key..".height",
                        },
                        {   name = L["Font Size"],
                            type = "slider",
                            step = 1,
                            min = 8,
                            max = 18,
                            tooltip = L["Default value is "].."10",
                            dbPath = "profile.bottomui."..key..".font_size",
                        },
                    };
                    return child;
                end
            },
        }
    },
    {   name = L["Data Text"],
        type = "category",
        module = "DataText",
        children =  {
            {   name = L["General Data Text Options"],
                type = "title",
                padding_top = 0,
            },
            {   name = L["Enabled"],
                tooltip = L["If unchecked, the entire DataText module will be disabled and all"].."\n"..
                            L["DataText buttons, as well as the background bar, will not be displayed."],
                type = "check",
                requiresReload = true,
                dbPath = "profile.datatext.enable_module",
            },
            {   name = L["Block in Combat"],
                tooltip = L["Prevents you from using data text modules while in combat."].."\n\n"..
                            L["This is useful for 'clickers'."],
                type = "check",
                dbPath = "profile.datatext.combat_block",
            },
            {   name = L["Auto Hide Menu in Combat"],
                type = "check",
                dbPath = "profile.datatext.hideMenuInCombat",
            },
            {   type = "divider"
            },
            {   name = L["Spacing"],
                type = "slider",
                tooltip = L["Adjust the spacing between data text buttons."].."\n\n"..
                            L["Default value is "].."1",
                step = 1,
                min = 0,
                max = 5,
                dbPath = "profile.datatext.spacing",
            },
            {   name = L["Font Size"],
                type = "slider",
                tooltip = L["The font size of text that appears on data text buttons."].."\n\n"..
                            L["Default value is "].."11",
                step = 1,
                min = 8,
                max = 18,
                dbPath = "profile.datatext.font_size",
            },
            {   name = L["Menu Width"],
                type = "textfield",
                value_type = "number",
                tooltip = L["Default value is "].."200",
                dbPath = "profile.datatext.menu_width",
            },
            {   name = L["Max Menu Height"],
                type = "textfield",
                value_type = "number",
                tooltip = L["Default value is "].."250",
                dbPath = "profile.datatext.max_menu_height",
            },
            {   type = "divider"
            },
            {   type = "dropdown",
                name = L["Bar Strata"],
                tooltip = L["The frame strata of the entire DataText bar."].."\n\n"..
                            L["Default value is "].."MEDIUM",
                options = tk.Constants.FRAME_STRATA_VALUES,
                dbPath = "profile.datatext.frame_strata"
            },
            {   type = "slider",
                name = L["Bar Level"],
                tooltip = L["The frame level of the entire DataText bar based on it's frame strata value."].."\n\n"..
                            L["Default value is "].."30",
                min = 1,
                max = 50,
                step = 1,
                dbPath = "profile.datatext.frame_level"
            },
            {   name = L["Data Text Modules"],
                type = "title",
            },
            {   type = "loop",
                loops = 10,
                func = function(id)
                    local child = { -- return a group of children rather than 1 child?
                        {   name = L["Data Button"].." "..id,
                            type = "dropdown",
                            dbPath = "profile.datatext.enabled["..id.."]",
                            GetValue = function(_, current_value)
                                return current_value or "disabled";
                            end,
                            options = {
                                L["Combat_timer"],
                                L["Durability"],
                                L["Friends"],
                                L["Guild"],
                                L["Performance"],
                                L["Memory"],
                                L["Money"],
                                L["Bags"],
                                L["Spec"],
                                L["Disabled"],
                                L["Blank"]
                            }
                        }
                    };
                    if (id == 1) then
                        child[1].padding_top = 0;
                    end
                    return child;
                end,
            },
            {   type = "title",
                name = L["Module Options"]
            },
            {   type = "submenu",
                module = "DataText",
                name = L["Performance"],
                children = {
                    {   name = L["Show FPS"],
                        type = "check",
                        dbPath = "profile.datatext.performance.show_fps",
                    },
                    {   type = "divider"
                    },
                    {   name = L["Show Server Latency (ms)"],
                        type = "check",
                        width = 230,
                        dbPath = "profile.datatext.performance.show_server_latency",
                    },
                    {   type = "divider"
                    },
                    {   name = L["Show Home Latency (ms)"],
                        type = "check",
                        width = 230,
                        dbPath = "profile.datatext.performance.show_home_latency",
                    },
                }
            },
            {   type = "submenu",
                name = L["Money"],
                module = "DataText",
                children = {
                    {   name = L["Show Copper"],
                        type = "check",
                        dbPath = "profile.datatext.money.show_copper",
                    },
                    {   type = "divider"
                    },
                    {   name = L["Show Silver"],
                        type = "check",
                        dbPath = "profile.datatext.money.show_silver",
                    },
                    {   type = "divider"
                    },
                    {   name = L["Show Gold"],
                        type = "check",
                        dbPath = "profile.datatext.money.show_gold",
                    },
                    {   type = "divider"
                    },
                    {   name = L["Show Realm Name"],
                        type = "check",
                        dbPath = "profile.datatext.money.show_realm",
                    },
                }
            },
            {   type = "submenu",
                name = L["Bags"],
                module = "DataText",
                children = {
                    {   name = L["Show Total Slots"],
                        type = "check",
                        dbPath = "profile.datatext.bags.show_total_slots",
                    },
                    {   type = "divider"
                    },
                    {   name = L["Show Used Slots"],
                        type = "radio",
                        group = 1,
                        dbPath = "profile.datatext.bags.slots_to_show",
                        GetValue = function(path, value)
                            return value == "used";
                        end,
                        SetValue = function(path, _, new)
                            if (new) then
                                db:SetPathValue(path, "used");
                            end
                        end
                    },
                    {   name = L["Show Free Slots"],
                        type = "radio",
                        group = 1,
                        dbPath = "profile.datatext.bags.slots_to_show",
                        GetValue = function(path, value)
                            return value == "free";
                        end,
                        SetValue = function(path, _, new)
                            if (new) then
                                db:SetPathValue(path, "free");
                            end
                        end
                    },
                },
            },
            {   type = "submenu",
                module = "DataText",
                name = L["Guild"],
                children = {
                    {   type = "check",
                        name = L["Show Self"],
                        tooltip = L["Show your character in the guild list."],
                        dbPath = "profile.datatext.guild.show_self"
                    },
                    {   type = "check",
                        name = L["Show Tooltips"],
                        tooltip = L["Show guild info tooltips when the cursor is over guild members in the guild list."],
                        dbPath = "profile.datatext.guild.show_tooltips"
                    }
                }
            }
        }
    },
    {   name = L["Side Bar"],
        type = "category",
        module = "SideBar",
        children =  {
            {   name = L["Width (With 1 Bar)"],
                type = "textfield",
                tooltip = L["Default value is "].."46",
                value_type = "number",
                dbPath = "profile.sidebar.retract_width"
            },
            {   name = L["Width (With 2 Bars)"],
                tooltip = L["Default value is "].."83",
                type = "textfield",
                value_type = "number",
                dbPath = "profile.sidebar.expand_width"
            },
            {   type = "divider",
            },
            {   name = L["Height"],
                tooltip = L["Default value is "].."486",
                type = "textfield",
                value_type = "number",
                dbPath = "profile.sidebar.height"
            },
            {   name = L["Y-Offset"],
                tooltip = L["Default value is "].."40",
                type = "textfield",
                value_type = "number",
                dbPath = "profile.sidebar.yOffset"
            },
            {   type = "divider",
            },
            {   name = L["Animation Speed"],
                type = "slider",
                tooltip = L["The speed of the Expand and Retract transitions."].."\n\n"..
                            L["The higher the value, the quicker the speed."].."\n\n"..
                            L["Default value is "].."6.",
                step = 1,
                min = 1,
                max = 10,
                width = 250,
                dbPath = "profile.sidebar.animate_speed"
            },
            {   name = L["Bartender Action Bars"],
                type = "title",
            },
            {   name = L["Allow MUI to Control Selected Bartender Bars"],
                type = "check",
                dbPath = "profile.sidebar.bartender.control",
                tooltip = L["TT_MUI_CONTROL_BARTENDER"],
            },
            {   type = "divider",
            },
            {   name = L["First Bartender Bar"],
                dbPath = "profile.sidebar.bartender[1]",
                type = "dropdown",
                options = {
                    "Bar 1",
                    "Bar 2",
                    "Bar 3",
                    "Bar 4",
                    "Bar 5",
                    "Bar 6",
                    "Bar 7",
                    "Bar 8",
                    "Bar 9",
                }
            },
            {   name = L["Second Bartender Bar"],
                dbPath = "profile.sidebar.bartender[2]",
                type = "dropdown",
                options = {
                    "Bar 1",
                    "Bar 2",
                    "Bar 3",
                    "Bar 4",
                    "Bar 5",
                    "Bar 6",
                    "Bar 7",
                    "Bar 8",
                    "Bar 9",
                }
            },
            {   name = L["Expand and Retract Buttons"],
                type = "title"
            },
            {   name = L["Hide in Combat"],
                type = "check",
                height = 60,
                dbPath = "profile.sidebar.buttons.hide_in_combat",
            },
            {   name = L["Show When"],
                type = "dropdown",
                dbPath = "profile.sidebar.buttons.show_when",
                options = {
                    L["Never"],
                    L["Always"],
                    L["On Mouse-over"]
                },
            },
            {   type = "divider",
            },
            {   name = L["Width"],
                type = "textfield",
                tooltip = L["Default value is "].."15",
                dbPath = "profile.sidebar.buttons.width",
                value_type = "number",
            },
            {   name = L["Height"],
                type = "textfield",
                tooltip = L["Default value is "].."100",
                dbPath = "profile.sidebar.buttons.height",
                value_type = "number",
            },
        }
    }
};