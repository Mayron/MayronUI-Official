------------------------
-- Setup namespaces
------------------------
local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local dataTextModule = MayronUI:ImportModule("DataText");

dataTextModule.ConfigData = 
{   
    name = L["Data Text"],
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
            valueType = "number",
            tooltip = L["Default value is "].."200",
            dbPath = "profile.datatext.menu_width",
        },
        {   name = L["Max Menu Height"],
            type = "textfield",
            valueType = "number",
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
                local child = {   
                    name = L["Data Button"].." "..id,
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
                };                

                if (id == 1) then
                    child.padding_top = 0;
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
};