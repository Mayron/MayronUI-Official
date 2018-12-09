-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db, _, _, _, L = MayronUI:GetCoreComponents();
local C_DataTextModule = namespace.C_DataTextModule;
local dataTextModule = MayronUI:ImportModule("DataText");

function C_DataTextModule:OnConfigUpdate(data, list, value)
    local key = list:PopFront();

    if (key) then
        tk:Print("KEY:", key, " VALUE:", value)
        return;
    end

    if (key == "profile" and list:PopFront() == "datatext") then
        key = list:PopFront();
        if (key == "enabled") then
            self:PositionDataItems();

        elseif (key == "performance") then
            self:ForceUpdate("performance");

        elseif (key == "money") then
            self:ForceUpdate("money");

        elseif (key == "bags") then
            self:ForceUpdate("bags");

        elseif (key == "guild") then
            if (list:PopFront() == "show_tooltips") then
                --TODO: items is not known!
                -- items.guild.update_required = true;
            end

        elseif (key == "menu_width") then
            data.popup:SetWidth(value);

        elseif (key == "popup.maxHeight") then
            data.slideController:Start();

        elseif (key == "fontSize") then
            local font = tk.Constants.LSM:Fetch("font", db.global.core.font);

            for _, btn in tk.ipairs(data.DataModules) do
                btn:GetFontString():SetFont(font, value);

                if (btn.seconds) then
                    btn.seconds:SetFont(font, value);
                end

                if (btn.minutes) then
                    btn.minutes:SetFont(font, value);
                end

                if (btn.milliseconds) then
                    btn.milliseconds:SetFont(font, value);
                end
            end

        elseif (key == "spacing") then
            self:PositionDataItems();

        elseif (key == "blockInCombat") then
            if (data.blocker and not value) then
                data.blocker:Hide();

            elseif (value) then
                data:CreateBlocker();
            end

        elseif (key == "hideMenuInCombat") then
            if (tk.InCombatLockdown() and value and data.popup:IsVisible()) then
                data.slideController:Start();
            end

        elseif (key == "frame_strata") then
            data.bar:SetFrameStrata(value);

        elseif (key == "frame_level") then
            data.bar:SetFrameLevel(value);
        end
    end
end


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
            step = 1,
            min = 0,
            max = 5,
            default = 1,
            appendDbPath = "spacing",
        },
        {   name = L["Font Size"],
            type = "slider",
            tooltip = L["The font size of text that appears on data text buttons."],
            step = 1,
            min = 8,
            max = 18,
            default = 11,
            appendDbPath = "fontSize",
        },
        {   name = L["Menu Width"],
            type = "textfield",
            valueType = "number",
            tooltip = L["Default value is "].."200",
            appendDbPath = "popup.width",
        },
        {   name = L["Max Menu Height"],
            type = "textfield",
            valueType = "number",
            tooltip = L["Default value is "].."250",
            appendDbPath = "popup.maxHeight",
        },
        {   type = "divider"
        },
        {   type = "dropdown",
            name = L["Bar Strata"],
            tooltip = L["The frame strata of the entire DataText bar."],
            options = tk.Constants.FRAME_STRATA_VALUES,
            default = "MEDIUM",
            appendDbPath = "frameStrata"
        },
        {   type = "slider",
            name = L["Bar Level"],
            tooltip = L["The frame level of the entire DataText bar based on it's frame strata value."],
            min = 1,
            max = 50,
            step = 1,
            default = 30,
            appendDbPath = "frameLevel"
        },
        {   name = L["Data Text Modules"],
            type = "title",
        },
        {   type = "loop",
            loops = 10, -- TODO: This can remai nat 10, don't need duplicate label and svName references!
            func = function(id)

                local child = {
                    name = tk.Strings:JoinWithSpace("Button", id),
                    type = "dropdown",
                    dbPath = string.format("profile.datatext.displayOrder[%s]", id),
                    GetOptions = function()
                        local options = {};

                        for svName, label in pairs(namespace.dataTextLabels) do
                            options[label] = svName;
                        end

                        return options;
                    end,
                    GetValue = function(_, svName)
                        -- return label
                        return namespace.dataTextLabels[svName];
                    end,
                    SetValue = function() -- TODO: Maybe switch old value with new value?
                        -- TODO: Passes in nil!
                        -- TODO: dropdown labels must be unique values (if I change durability to guild, then guild must change to blank)
                       -- db:SetPathValue(db.profile, path, svName);
                    end,
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
            appendDbPath = "currency",
            children = {
                {   name = L["Show Copper"],
                    type = "check",
                    appendDbPath = "showCopper",
                },
                {   type = "divider"
                },
                {   name = L["Show Silver"],
                    type = "check",
                    appendDbPath = "showSilver",
                },
                {   type = "divider"
                },
                {   name = L["Show Gold"],
                    type = "check",
                    appendDbPath = "showGold",
                },
                {   type = "divider"
                },
                {   name = L["Show Realm Name"],
                    type = "check",
                    appendDbPath = "showRealm",
                },
            }
        },
        {   type = "submenu",
            name = "Inventory",
            module = "DataText",
            appendDbPath = "inventory",
            children = {
                {   name = L["Show Total Slots"],
                    type = "check",
                    appendDbPath = "showTotalSlots",
                },
                {   type = "divider"
                },
                {   name = L["Show Used Slots"],
                    type = "radio",
                    group = 1,
                    appendDbPath = "slotsToShow",
                    GetValue = function(_, value)
                        return value == "used";
                    end,
                    SetValue = function(path)
                        db:SetPathValue(db.Profile, path, "used");
                    end
                },
                {   name = L["Show Free Slots"],
                    type = "radio",
                    group = 1,
                    appendDbPath = "slotsToShow",
                    GetValue = function(_, value)
                        return value == "free";
                    end,
                    SetValue = function(path, _, newValue)
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