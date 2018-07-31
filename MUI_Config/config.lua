------------------------
-- Setup namespaces
------------------------
local _, config = ...;
local core = MayronUI:ImportModule("MUI_Core");
local tk = core.Toolkit;
local db = core.Database;
config.db = {};

---------------------------
-- Config Functions
---------------------------

function config:AddCategoryData(...)
    for _, categoryData in tk:IterateArgs(...) do
        tk.table.insert(self.db, categoryData);
    end
    if (config:IsLoaded()) then
        config:UpdateCategories(); -- doesn't do anything
    end
end

function config:ScanForData()
    for _, module in MayronUI:IterateModules() do
        if (module.ns.GetConfig) then
            local categories = module.ns:GetConfig();
            for _, data in tk.ipairs(categories) do
                config:AddCategoryData(data);
            end
            module.ns.GetConfig = nil;
        end
    end
end

---------------------------
-- MUI_Core options
---------------------------
function config:init()
    config:AddCategoryData(
        {   name = "General",
            type = "category",
            children = {
                {   name = "Enable Master Font",
                    tooltip = "Uncheck to prevent MUI from changing the game font.",
                    requires_restart = true,
                    db_path = "global.core.change_game_font",
                    type = "check",
                },
                {   name = "Display Lua Errors",
                    type = "check",
                    GetValue = function()
                        return tk.tonumber(tk.GetCVar("ScriptErrors")) == 1;
                    end,
                    SetValue = function(value)
                        if (value) then
                            tk.SetCVar("ScriptErrors","1");
                        else
                            tk.SetCVar("ScriptErrors","0");
                        end
                    end
                },
                { type = "divider",
                },
                {   name = "Master Font",
                    type = "dropdown",
                    options = tk.Constants.LSM:List("font"),
                    db_path = "global.core.font",
                    requires_restart = true,
                    font_chooser = true,
                },
                {   type = "divider"
                },
                {   name = "Set Theme Color",
                    type = "color",
                    tooltip = "Warning: This will NOT change the color of CastBars!",
                    db_path = "profile.theme.color",
                    requires_reload = true,
                    SetValue = function(_, _, value)
                        value.hex = tk.string.format('%02x%02x%02x', value.r * 255, value.g * 255, value.b * 255);
                        db.profile.theme.color = value;
                        db.profile["profile.bottomui.gradients"] = nil;
                    end
                },
                {   name = "Objective (Quest) Tracker",
                    type = "title"
                },
                {   name = "Enable",
                    tooltip = "Disable this to stop MUI from controlling the Objective Tracker.",
                    type = "check",
                    db_path = "profile.sidebar.objective_tracker.enabled",
                    module = "SideBar",
                    requires_reload = true,
                },
                {   name = "Anchor to Side Bar",
                    tooltip = "Anchor the Objective Tracker to the action bar container on the right side of the screen.",
                    type = "check",
                    db_path = "profile.sidebar.objective_tracker.anchored_to_sidebars",
                    module = "SideBar",
                },
                {   type = "divider",
                },
                {   name = "Set Width",
                    type = "textfield",
                    tooltip = "Adjust the width of the Objective Tracker.\n\nDefault is 250",
                    db_path = "profile.sidebar.objective_tracker.width",
                    value_type = "number",
                    module = "SideBar",
                },
                {   name = "Set Height",
                    type = "textfield",
                    tooltip = "Adjust the height of the Objective Tracker.\n\nDefault is 600",
                    db_path = "profile.sidebar.objective_tracker.height",
                    value_type = "number",
                    module = "SideBar",
                },
                {   name = "X-Offset",
                    type = "textfield",
                    tooltip = "Adjust the horizontal positioning of the Objective Tracker.\n\nDefault is -30",
                    db_path = "profile.sidebar.objective_tracker.xOffset",
                    value_type = "number",
                    module = "SideBar",
                },
                {   name = "Y-Offset",
                    type = "textfield",
                    tooltip = "Adjust the vertical positioning of the Objective Tracker.\n\nDefault is 0",
                    db_path = "profile.sidebar.objective_tracker.yOffset",
                    value_type = "number",
                    module = "SideBar",
                },
            }
        },
        {   name = "Bottom UI Panels",
            module = "BottomUI",
            type = "category",
            children = {
                {   name = "General Options",
                    type = "title",
                    padding_top = 0
                },
                {   name = "Container Width",
                    type = "slider",
                    tooltip = "Adjust the width of the Bottom UI container.\n\nMinimum value allowed is 680.\n\nDefault is 750.",
                    step = 5,
                    min = 680,
                    max = 1200,
                    db_path = "profile.bottomui.width",
                },
                {   name = "Unit Panels",
                    type = "title",
                    padding_top = 0
                },
                {   name = "Enable Unit Panels",
                    db_path = "profile.bottomui.unit_panels.enabled",
                    requires_reload = true,
                    type = "check",
                },
                {   name = "Symmetric Unit Panels",
                    tooltip = "Previously called 'Classic Mode'.",
                    type = "check",
                    requires_reload = true,
                    db_path = "profile.bottomui.unit_panels.classicMode"
                },
                {   name = "Allow MUI to Control Unit Frames",
                    tooltip =
[[If enabled, MUI will reposition the Shadowed Unit
Frames to fit over the top of the MUI Unit Panels.

It will also automatically move the Unit Frames when
expanding and retracting the MUI Action Bar Panel.]],
                    type = "check",
                    requires_reload = true,
                    db_path = "profile.bottomui.unit_panels.control_SUF"
                },
                {   name = "Allow MUI to Control Grid",
                    tooltip =
[[|cff00ccffImportant:|r Only for the |cff00ccff'MayronUIH' Grid Profile|r (used in the Healing Layout)!

If enabled, MUI will reposition the Grid Frame to fit on top of the MUI Unit Panels.

It will also automatically move the Grid Frame when expanding and retracting the
MUI Action Bar Panel.]],
                    type = "check",
                    requires_reload = true,
                    db_path = "profile.bottomui.unit_panels.control_Grid"
                },
                {   type = "divider",
                },
                {   name = "Unit Panel Width",
                    type = "slider",
                    step = 5,
                    min = 200,
                    max = 550,
                    tooltip = "Adjust the width of the unit frame background panels.\n\nMinimum value allowed is 200.\n\nDefault is 325.",
                    db_path = "profile.bottomui.unit_panels.unit_width",
                },
                {   name = "Name Panels",
                    type = "title",
                },
                {   name = "Width",
                    type = "slider",
                    tooltip = "Adjust the width of the unit name background panels.\n\nDefault is 235",
                    step = 5,
                    min = 150,
                    max = 350,
                    db_path = "profile.bottomui.unit_panels.unit_names.width",
                },
                {   name = "Height",
                    type = "slider",
                    tooltip = "Adjust the height of the unit name background panels.\n\nDefault is 20",
                    step = 1,
                    min = 16,
                    max = 30,
                    db_path = "profile.bottomui.unit_panels.unit_names.height",
                },
                {   name = "X-Offset",
                    type = "slider",
                    tooltip = "Move the unit name panels further in or out.\n\nDefault is 24",
                    step = 1,
                    min = -100,
                    max = 100,
                    db_path = "profile.bottomui.unit_panels.unit_names.xOffset",
                },
                {   name = "Font Size",
                    type = "slider",
                    tooltip = "Set the font size of unit names.\n\nDefault is 11",
                    step = 1,
                    min = 8,
                    max = 18,
                    db_path = "profile.bottomui.unit_panels.unit_names.fontSize",
                },
                {   name = "Target Class Colored",
                    type = "check",
                    height = 50,
                    db_path = "profile.bottomui.unit_panels.unit_names.target_class_colored"
                },
                {   name = "Action Bar Panel",
                    type = "title",
                    padding_top = 0
                },
                {   name = "Enable Action Bar Panel",
                    db_path = "profile.bottomui.actionbar_panel.enabled",
                    requires_reload = true,
                    type = "check",
                },
                {   name = "Animation Speed",
                    type = "slider",
                    tooltip = "The speed of the Expand and Retract transitions. The higher the value, the quicker the speed.\n\nDefault is 6.",
                    step = 1,
                    min = 1,
                    max = 10,
                    db_path = "profile.bottomui.actionbar_panel.animate_speed",
                },
                {   name = "Retract Height",
                    tooltip = "Set the height of the action bar panel when it\nis 'Retracted' to show 1 action bar row.\n\nMinimum value allowed is 40.\n\nDefault is 44.",
                    type = "textfield",
                    value_type = "number",
                    min = 40,
                    db_path = "profile.bottomui.actionbar_panel.retract_height"
                },
                {   name = "Expand Height",
                    tooltip = "Set the height of the Action Bar Panel when it\nis 'Expanded' to show 2 action bar rows.\n\nMinimum value allowed is 40.\n\nDefault is 80.",
                    type = "textfield",
                    value_type = "number",
                    min = 40,
                    db_path = "profile.bottomui.actionbar_panel.expand_height"
                },
                {   type = "fontstring",
                    content = "Modifier keys used to show Expand/Retract buttons:"
                },
                {   name = "Control",
                    height = 40,
                    min_width = true,
                    type = "check",
                    db_path = "profile.bottomui.actionbar_panel.mod_key",
                    GetValue = function(_, current_value)
                        return current_value:find("C");
                    end,
                    SetValue = function(db_path, old_value, value)
                        value = value and "C";
                        if (not value) then
                            if (old_value:find("C")) then
                                value = old_value:gsub("C", "")
                            end
                        else
                            value = old_value..value;
                        end
                        db:SetPathValue(db_path, value);
                    end
                },
                {   name = "Shift",
                    height = 40,
                    min_width = true,
                    type = "check",
                    db_path = "profile.bottomui.actionbar_panel.mod_key",
                    GetValue = function(_, current_value)
                        return current_value:find("S");
                    end,
                    SetValue = function(db_path, old_value, value)
                        value = value and "S";
                        if (not value) then
                            if (old_value:find("S")) then
                                value = old_value:gsub("S", "")
                            end
                        else
                            value = old_value..value;
                        end
                        db:SetPathValue(db_path, value);
                    end
                },
                {   name = "Alt",
                    height = 40,
                    min_width = true,
                    type = "check",
                    db_path = "profile.bottomui.actionbar_panel.mod_key",
                    GetValue = function(_, current_value)
                        return current_value:find("A");
                    end,
                    SetValue = function(db_path, old_value, value) -- the path and the new value
                        value = value and "A";
                        if (not value) then
                            if (old_value:find("A")) then
                                value = old_value:gsub("A", "");
                            end
                        else
                            value = old_value..value;
                        end
                        db:SetPathValue(db_path, value);
                    end
                },
                {   name = "SUF Portrait Gradient",
                    type = "title",
                },
                {   name = "Enable Gradient Effect",
                    type = "check",
                    tooltip = "If the SUF Player or Target portrait bars are enabled, a class colored gradient will overlay it.",
                    db_path = "profile.bottomui.gradients.enabled"
                },
                {   name = "Height",
                    type = "slider",
                    tooltip = "The height of the gradient effect.\n\nDefault is 24.",
                    step = 1,
                    min = 1,
                    max = 50,
                    width = 250,
                    db_path = "profile.bottomui.gradients.height",
                },
                {   type = "fontstring",
                    content = "Gradient Colors",
                    subtype = "header",
                },
                {   name = "Start Color",
                    type = "color",
                    width = 150,
                    tooltip = "What color the gradient should start as.",
                    db_path = "profile.bottomui.gradients.from",
                },
                {   name = "End Color",
                    width = 150,
                    tooltip = "What color the gradient should change into.",
                    type = "color",
                    db_path = "profile.bottomui.gradients.to",
                },
                {   name = "Target Class Colored",
                    tooltip = "If checked, the target portrait gradient will use the target's class\n"..
                                "color instead of using the 'Start Color' RGB values. It will\n"..
                                "still use the Alpha and 'End Color' RGB values.",
                    type = "check",
                    db_path = "profile.bottomui.gradients.target_class_colored",
                },
                {   name = "Bartender Action Bars",
                    type = "title",
                },
                {   name = "Allow MUI to Control Selected Bartender Bars",
                    type = "check",
                    tooltip =
[[If enabled, MUI will reposition the selected Bartender
bars to fit over the top of the action bar panel.

It will also control the fading in and out transitions
of selected row 2 Bartender bars when expanding and
retracting the MUI Action Bar Panel.]],
                    db_path = "profile.bottomui.actionbar_panel.bartender.control"
                },
                {   type = "fontstring",
                    content = "Row 1",
                    subtype = "header",
                },
                {   name = "First Bartender Bar",
                    type = "dropdown",
                    db_path = "profile.bottomui.actionbar_panel.bartender[1]",
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
                {   name = "Second Bartender Bar",
                    db_path = "profile.bottomui.actionbar_panel.bartender[2]",
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
                    content = "Row 2",
                    subtype = "header",
                },
                {   name = "First Bartender Bar",
                    db_path = "profile.bottomui.actionbar_panel.bartender[3]",
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
                {   name = "Second Bartender Bar",
                    db_path = "profile.bottomui.actionbar_panel.bartender[4]",
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
                            {   name = name.." Bar",
                                type = "title",
                            },
                            {   name = "Enabled",
                                type = "check",
                                tooltip = "Default is true.",
                                db_path = "profile.bottomui."..key..".enabled",
                            },
                            {   name = "Show Text",
                                type = "check",
                                tooltip = "Default is false.",
                                db_path = "profile.bottomui."..key..".show_text",
                            },
                            {   name = "Height",
                                type = "slider",
                                step = 1,
                                min = 4,
                                max = 30,
                                tooltip = "Default is 8.",
                                db_path = "profile.bottomui."..key..".height",
                            },
                            {   name = "Font Size",
                                type = "slider",
                                step = 1,
                                min = 8,
                                max = 18,
                                tooltip = "default is 10.",
                                db_path = "profile.bottomui."..key..".font_size",
                            },
                        };
                        return child;
                    end
                },
            }
        },
        {   name = "Data Text",
            type = "category",
            module = "DataText",
            children =  {
                {   name = "General Data Text Options",
                    type = "title",
                    padding_top = 0,
                },
                {   name = "Enabled",
                    tooltip = "If unchecked, the entire DataText module will be disabled and all \nDataText buttons, as well as the background bar, will not be displayed.",
                    type = "check",
                    requires_reload = true,
                    db_path = "profile.datatext.enable_module",
                },
                {   name = "Block in Combat",
                    tooltip = "Prevents you from using data text modules while in combat.\n\nThis is useful for 'clickers'.",
                    type = "check",
                    db_path = "profile.datatext.combat_block",
                },
                {   name = "Auto Hide Menu in Combat",
                    type = "check",
                    db_path = "profile.datatext.hideMenuInCombat",
                },
                {   type = "divider"
                },
                {   name = "Spacing",
                    type = "slider",
                    tooltip = "Adjust the spacing between data text buttons.\n\nDefault is 1",
                    step = 1,
                    min = 0,
                    max = 5,
                    db_path = "profile.datatext.spacing",
                },
                {   name = "Font Size",
                    type = "slider",
                    tooltip = "The font size of text that appears on data text buttons.\n\nDefault is 11",
                    step = 1,
                    min = 8,
                    max = 18,
                    db_path = "profile.datatext.font_size",
                },
                {   name = "Menu Width",
                    type = "textfield",
                    value_type = "number",
                    tooltip = "Default is 200",
                    db_path = "profile.datatext.menu_width",
                },
                {   name = "Max Menu Height",
                    type = "textfield",
                    value_type = "number",
                    tooltip = "Default is 250",
                    db_path = "profile.datatext.max_menu_height",
                },
                {   type = "divider"
                },
                {   type = "dropdown",
                    name = "Bar Strata",
                    tooltip = "The frame strata of the entire DataText bar.\n\nDefault is MEDIUM.",
                    options = tk.Constants.FRAME_STRATA_VALUES,
                    db_path = "profile.datatext.frame_strata"
                },
                {   type = "slider",
                    name = "Bar Level",
                    tooltip = "The frame level of the entire DataText bar based on it's frame strata value.\n\nDefault is 30.",
                    min = 1,
                    max = 50,
                    step = 1,
                    db_path = "profile.datatext.frame_level"
                },
                {   name = "Data Text Modules",
                    type = "title",
                },
                {   type = "loop",
                    loops = 10,
                    func = function(id)
                        local child = { -- return a group of children rather than 1 child?
                            {   name = "Data Button "..id,
                                type = "dropdown",
                                db_path = "profile.datatext.enabled["..id.."]",
                                GetValue = function(_, current_value)
                                    return current_value or "disabled";
                                end,
                                options = {
                                    "combat_timer",
                                    "durability",
                                    "friends",
                                    "guild",
                                    "performance",
                                    "memory",
                                    "money",
                                    "bags",
                                    "spec",
                                    "disabled",
                                    "blank"
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
                    name = "Module Options"
                },
                {   type = "submenu",
                    module = "DataText",
                    name = "Performance",
                    children = {
                        {   name = "Show FPS",
                            type = "check",
                            db_path = "profile.datatext.performance.show_fps",
                        },
                        {   type = "divider"
                        },
                        {   name = "Show Server Latency (ms)",
                            type = "check",
                            width = 230,
                            db_path = "profile.datatext.performance.show_server_latency",
                        },
                        {   type = "divider"
                        },
                        {   name = "Show Home Latency (ms)",
                            type = "check",
                            width = 230,
                            db_path = "profile.datatext.performance.show_home_latency",
                        },
                    }
                },
                {   type = "submenu",
                    name = "Money",
                    module = "DataText",
                    children = {
                        {   name = "Show Copper",
                            type = "check",
                            db_path = "profile.datatext.money.show_copper",
                        },
                        {   type = "divider"
                        },
                        {   name = "Show Silver",
                            type = "check",
                            db_path = "profile.datatext.money.show_silver",
                        },
                        {   type = "divider"
                        },
                        {   name = "Show Gold",
                            type = "check",
                            db_path = "profile.datatext.money.show_gold",
                        },
                        {   type = "divider"
                        },
                        {   name = "Show Realm Name",
                            type = "check",
                            db_path = "profile.datatext.money.show_realm",
                        },
                    }
                },
                {   type = "submenu",
                    name = "Bags",
                    module = "DataText",
                    children = {
                        {   name = "Show Total Slots",
                            type = "check",
                            db_path = "profile.datatext.bags.show_total_slots",
                        },
                        {   type = "divider"
                        },
                        {   name = "Show Used Slots",
                            type = "radio",
                            group = 1,
                            db_path = "profile.datatext.bags.slots_to_show",
                            GetValue = function(path, value)
                                return value == "used";
                            end,
                            SetValue = function(path, _, new)
                                if (new) then
                                    db:SetPathValue(path, "used");
                                end
                            end
                        },
                        {   name = "Show Free Slots",
                            type = "radio",
                            group = 1,
                            db_path = "profile.datatext.bags.slots_to_show",
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
                    name = "Guild",
                    children = {
                        {   type = "check",
                            name = "Show Self",
                            tooltip = "Show your character in the guild list.",
                            db_path = "profile.datatext.guild.show_self"
                        },
                        {   type = "check",
                            name = "Show Tooltips",
                            tooltip = "Show guild info tooltips when the cursor is over guild members in the guild list.",
                            db_path = "profile.datatext.guild.show_tooltips"
                        }
                    }
                }
            }
        },
        {   name = "Side Bar",
            type = "category",
            module = "SideBar",
            children =  {
                {   name = "Width (With 1 Bar)",
                    type = "textfield",
                    tooltip = "Default value is 46.",
                    value_type = "number",
                    db_path = "profile.sidebar.retract_width"
                },
                {   name = "Width (With 2 Bars)",
                    tooltip = "Default value is 83.",
                    type = "textfield",
                    value_type = "number",
                    db_path = "profile.sidebar.expand_width"
                },
                {   type = "divider",
                },
                {   name = "Height",
                    tooltip = "Default value is 486.",
                    type = "textfield",
                    value_type = "number",
                    db_path = "profile.sidebar.height"
                },
                {   name = "Y-Offset",
                    tooltip = "Default value is 40.",
                    type = "textfield",
                    value_type = "number",
                    db_path = "profile.sidebar.yOffset"
                },
                {   type = "divider",
                },
                {   name = "Animation Speed",
                    type = "slider",
                    tooltip = "The speed of the Expand and Retract transitions. The higher the value, the quicker the speed.\n\nDefault value is 6.",
                    step = 1,
                    min = 1,
                    max = 10,
                    width = 250,
                    db_path = "profile.sidebar.animate_speed"
                },
                {   name = "Bartender Action Bars",
                    type = "title",
                },
                {   name = "Allow MUI to Control Selected Bartender Bars",
                    type = "check",
                    db_path = "profile.sidebar.bartender.control",
                    tooltip =
[[If enabled, MUI will reposition the selected Bartender
bars to fit over the top of the side bar panel.

It will also control the fading in and out transitions
of selected Bartender bars when expanding and
retracting the MUI Side Bar Panel.]],
                },
                {   type = "divider",
                },
                {   name = "First Bartender Bar",
                    db_path = "profile.sidebar.bartender[1]",
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
                {   name = "Second Bartender Bar",
                    db_path = "profile.sidebar.bartender[2]",
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
                {   name = "Expand and Retract Buttons",
                    type = "title"
                },
                {   name = "Hide in Combat",
                    type = "check",
                    height = 60,
                    db_path = "profile.sidebar.buttons.hide_in_combat",
                },
                {   name = "Show When",
                    type = "dropdown",
                    db_path = "profile.sidebar.buttons.show_when",
                    options = {
                        "Never",
                        "Always",
                        "On Mouse-over"
                    },
                },
                {   type = "divider",
                },
                {   name = "Width",
                    type = "textfield",
                    tooltip = "Default value is 15.",
                    db_path = "profile.sidebar.buttons.width",
                    value_type = "number",
                },
                {   name = "Height",
                    type = "textfield",
                    tooltip = "Default value is 100.",
                    db_path = "profile.sidebar.buttons.height",
                    value_type = "number",
                },
            }
        }
    );
end