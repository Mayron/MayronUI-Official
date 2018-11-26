------------------------
-- Setup namespaces
------------------------
local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local dataTextModule = MayronUI:ImportModule("DataText");

dataTextModule.ConfigData = 
{   
    name = L["Data Text"],
    type = "menu",
    module = "DataText",
    dbPath = "profile.datatext",
    children =  {
        {   name = L["General Data Text Options"],
            type = "title",
            padding_top = 0,
        },
        {   name = L["Enabled"],
            tooltip = tk.Strings:Concat(
                L["If unchecked, the entire DataText module will be disabled and all"], "\n", 
                L["DataText buttons, as well as the background bar, will not be displayed."]),
            type = "check",
            requiresReload = true,
            dbPath = "enabled",
        },
        {   name = L["Block in Combat"],
            tooltip = L["Prevents you from using data text modules while in combat."],
            type = "check",
            dbPath = "blockInCombat",
        },
        {   name = L["Auto Hide Menu in Combat"],
            type = "check",
            dbPath = "popup.hideInCombat",
        },
        {   type = "divider"
        },
        {   name = L["Spacing"],
            type = "slider",
            tooltip = L["Adjust the spacing between data text buttons."],
            step = 1,
            min = 0,
            max = 5,
            default = 1,
            dbPath = "spacing",
        },
        {   name = L["Font Size"],
            type = "slider",
            tooltip = L["The font size of text that appears on data text buttons."],
            step = 1,
            min = 8,
            max = 18,
            default = 11,
            dbPath = "fontSize",
        },
        {   name = L["Menu Width"],
            type = "textfield",
            valueType = "number",
            tooltip = L["Default value is "].."200",
            dbPath = "popup.width",
        },
        {   name = L["Max Menu Height"],
            type = "textfield",
            valueType = "number",
            tooltip = L["Default value is "].."250",
            dbPath = "popup.maxHeight",
        },
        {   type = "divider"
        },
        {   type = "dropdown",
            name = L["Bar Strata"],
            tooltip = L["The frame strata of the entire DataText bar."],
            options = tk.Constants.FRAME_STRATA_VALUES,
            default = "MEDIUM",
            dbPath = "frameStrata"
        },
        {   type = "slider",
            name = L["Bar Level"],
            tooltip = L["The frame level of the entire DataText bar based on it's frame strata value."],
            min = 1,
            max = 50,
            step = 1,
            default = 30,
            dbPath = "frameLevel"
        },
        {   name = L["Data Text Modules"],
            type = "title",
        },
        {   type = "loop",
            args = namespace.dataTextLabels,
            func = function(id, label, dbDataTextName)
                local child = {   
                    name = tk.Strings:JoinWithSpace("Button", id),
                    type = "dropdown",
                    dbPath = "profile.datatext.displayOrder",
                    GetValue = function(_, currentValue)
                        -- TODO: Rethink this?
                        local currentValue = db.profile.datatext.displayOrder[id];

                        for _, dbDataTextName in ipairs(namespace.dataTextLabels) do
                            if (dbDataTextName[2] == currentValue) then
                                return label;
                            end
                        end
                    end,
                    SetValue = function(path, _, value)
                        -- TODO: Passes in nil!
                        tk:Print(value);
                       -- db:SetPathValue(db.profile, string.format("datatext.displayOrder.%s", dbDataTextName), id);
                    end,
                    options = namespace.dataTextLabels
                };                

                if (id == 1) then
                    child.paddingTop = 0;
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
            dbPath = "profile.datatext.performance",
            children = {
                {   name = L["Show FPS"],
                    type = "check",
                    dbPath = "showFps",
                },
                {   type = "divider"
                },
                {   name = L["Show Server Latency (ms)"],
                    type = "check",
                    width = 230,
                    dbPath = "showServerLatency",
                },
                {   type = "divider"
                },
                {   name = L["Show Home Latency (ms)"],
                    type = "check",
                    width = 230,
                    dbPath = "showHomeLatency",
                },
            }
        },
        {   type = "submenu",
            name = L["Money"],
            module = "DataText",
            dbPath = "profile.datatext.currency",
            children = {
                {   name = L["Show Copper"],
                    type = "check",
                    dbPath = "showCopper",
                },
                {   type = "divider"
                },
                {   name = L["Show Silver"],
                    type = "check",
                    dbPath = "showSilver",
                },
                {   type = "divider"
                },
                {   name = L["Show Gold"],
                    type = "check",
                    dbPath = "showGold",
                },
                {   type = "divider"
                },
                {   name = L["Show Realm Name"],
                    type = "check",
                    dbPath = "showRealm",
                },
            }
        },
        {   type = "submenu",
            name = "Inventory",
            module = "DataText",
            dbPath = "profile.datatext.inventory",
            children = {
                {   name = L["Show Total Slots"],
                    type = "check",
                    dbPath = "showTotalSlots",
                },
                {   type = "divider"
                },
                {   name = L["Show Used Slots"],
                    type = "radio",
                    group = 1,
                    dbPath = "slotsToShow",
                    GetValue = function(path, value)
                        return value == "used";
                    end,
                    SetValue = function(path, oldValue, newValue)
                        db:SetPathValue(db.Profile, path, "used");
                    end
                },
                {   name = L["Show Free Slots"],
                    type = "radio",
                    group = 1,
                    dbPath = "slotsToShow",
                    GetValue = function(path, value)
                        return value == "free";
                    end,
                    SetValue = function(path, oldValue, newValue)
                        if (newValue) then
                            -- TODO: ELSE?!?
                            db:SetPathValue(path, "free");
                        end
                    end
                },
            },
        },
        {   type = "submenu",
            module = "DataText",
            name = L["Guild"],
            dbPath = "profile.datatext.guild",
            children = {
                {   type = "check",
                    name = L["Show Self"],
                    tooltip = L["Show your character in the guild list."],
                    dbPath = "showSelf"
                },
                {   type = "check",
                    name = L["Show Tooltips"],
                    tooltip = L["Show guild info tooltips when the cursor is over guild members in the guild list."],
                    dbPath = "showTooltips"
                }
            }
        }
    }
};