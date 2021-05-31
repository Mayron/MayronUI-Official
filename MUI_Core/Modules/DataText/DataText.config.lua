-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db, _, _, _, L = _G.MayronUI:GetCoreComponents();
local C_DataTextModule = namespace.C_DataTextModule;

function C_DataTextModule:GetConfigTable()
    return {
        type = "menu",
        module = "DataTextModule",
        dbPath = "profile.datatext",
        children =  {
            {   name = L["General Data Text Options"],
                type = "title",
                marginTop = 0;
            },
            {   name = L["Enabled"],
                tooltip = tk.Strings:Concat(
                    L["If unchecked, the entire DataText module will be disabled and all"], "\n",
                    L["DataText buttons, as well as the background bar, will not be displayed."]),
                type = "check",
                requiresReload = true, -- TODO: Maybe modules can be global? - move module enable/disable to general menu?
                appendDbPath = "enabled",
            },
            {   name = L["Block in Combat"],
                tooltip = L["Prevents you from using data text modules while in combat."],
                type = "check",
                appendDbPath = "blockInCombat",
            },
            {   name = L["Auto Hide Menu in Combat"],
                type = "check",
                appendDbPath = "popup.hideInCombat",
            },
            {   type = "divider"
            },
            {   name = L["Spacing"],
                type = "slider",
                tooltip = L["Adjust the spacing between data text buttons."],
                min = 0,
                max = 5,
                default = 1,
                appendDbPath = "spacing",
            },
            {   name = L["Font Size"],
                type = "slider",
                tooltip = L["The font size of text that appears on data text buttons."],
                min = 8,
                max = 18,
                default = 11,
                appendDbPath = "fontSize",
            },
            {   name = "Height",
                type = "slider",
                valueType = "number",
                min = 10;
                max = 50;
                tooltip = tk.Strings:Join("\n", L["Adjust the height of the datatext bar."], L["Default value is"].." 24"),
                appendDbPath = "height",
            },
            {   name = L["Menu Width"],
                type = "slider",
                min = 150;
                max = 400;
                step = 10;
                tooltip = L["Default value is"].." 200",
                appendDbPath = "popup.width",
            },
            {   name = L["Max Menu Height"],
                type = "slider",
                min = 150;
                max = 400;
                step = 10;
                tooltip = L["Default value is"].." 250",
                appendDbPath = "popup.maxHeight",
            },
            {   type = "divider"
            },
            {   type = "dropdown",
                name = L["Bar Strata"],
                tooltip = L["The frame strata of the entire DataText bar."],
                options = tk.Constants.ORDERED_FRAME_STRATAS,
                disableSorting = true;
                appendDbPath = "frameStrata";
            },
            {   type = "slider",
                name = L["Bar Level"],
                tooltip = L["The frame level of the entire DataText bar based on it's frame strata value."],
                min = 1,
                max = 50,
                default = 30,
                appendDbPath = "frameLevel"
            },
            {   name = L["Data Text Modules"],
                type = "title",
            },
          {   type = "loop",
              loops = 10,
              func = function(id)
                local child = {
                  name = tk.Strings:JoinWithSpace("Button", id);
                  type = "dropdown";
                  dbPath = string.format("profile.datatext.displayOrders[%s]", id);
                  options = namespace.dataTextLabels;
                  labels = "values";

                  GetValue = function(_, value)
                    if (value == nil) then
                      value = "disabled";
                    end

                    return namespace.dataTextLabels[value];
                  end;

                  SetValue = function(dbPath, newLabel)
                    local newValue;

                    for value, label in pairs(namespace.dataTextLabels) do
                      if (newLabel == label) then
                        newValue = value;
                        break;
                      end
                    end

                    db:SetPathValue(dbPath, newValue);
                  end;
                };

                if (id == 1) then
                  child.paddingTop = 0;
                end

                return child;
              end
            },
            {   type = "title",
                name = L["Module Options"]
            },
            {   type = "submenu",
                module = "DataText",
                name = L["Performance"],
                appendDbPath = "performance",
                children = {
                    {   type = "fontstring",
                        content = L["Changes to these settings will take effect after 0-3 seconds."];
                    },
                    {   name = L["Show FPS"],
                        type = "check",
                        appendDbPath = "showFps",
                    },
                    {   type = "divider"
                    },
                    {   name = L["Show Server Latency (ms)"],
                        type = "check",
                        width = 230,
                        appendDbPath = "showServerLatency",
                    },
                    {   type = "divider"
                    },
                    {   name = L["Show Home Latency (ms)"],
                        type = "check",
                        width = 230,
                        appendDbPath = "showHomeLatency",
                    },
                }
            },
            {   type = "submenu",
                name = L["Money"];
                module = "DataText",
                appendDbPath = "money",
                children = {
                  { name = L["Show Realm Name"],
                    type = "check",
                    appendDbPath = "showRealm",
                  },
                }
            },
            {   type = "submenu",
                name = L["Inventory"],
                module = "DataText",
                appendDbPath = "inventory",
                children = {
                    {   name = L["Show Total Slots"];
                        type = "check";
                        appendDbPath = "showTotalSlots";
                    },
                    {   type = "divider"
                    },
                    {   name = L["Show Used Slots"];
                        type = "radio";
                        groupName = "inventory";
                        appendDbPath = "slotsToShow";

                        GetValue = function(_, value)
                            return value == "used";
                        end;

                        SetValue = function(path)
                            db:SetPathValue(path, "used");
                        end;
                    },
                    {   name = L["Show Free Slots"];
                        type = "radio";
                        groupName = "inventory";
                        appendDbPath = "slotsToShow";

                        GetValue = function(_, value)
                            return value == "free";
                        end;

                        SetValue = function(path)
                            db:SetPathValue(path, "free");
                        end;
                    },
                },
            },
            {   type = "submenu",
                module = "DataText",
                name = L["Guild"],
                appendDbPath = "guild",
                children = {
                    {   type = "check",
                        name = L["Show Self"],
                        tooltip = L["Show your character in the guild list."],
                        appendDbPath = "showSelf"
                    },
                    {   type = "check",
                        name = L["Show Tooltips"],
                        tooltip = L["Show guild info tooltips when the cursor is over guild members in the guild list."],
                        appendDbPath = "showTooltips"
                    }
                }
            }
        }
    };
end