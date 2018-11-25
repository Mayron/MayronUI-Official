------------------------
-- Setup namespaces
------------------------
local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local chatModule = MayronUI:ImportModule("Chat");

chatModule.ConfigData = 
{
    name = "Chat",
    type = "category",
    module = "Chat",
    children = {
        {   name = L["Edit Box (Message Input Box)"],
            type = "title",
            padding_top = 0
        },
        {   name = L["Y-Offset"],
            type = "textfield",
            valueType = "number",
            tooltip = "Set the vertical positioning of the edit box.\n\nDefault is -8.",
            dbPath = "profile.chat.edit_box.yOffset"
        },
        {   name = L["Height"],
            type = "textfield",
            valueType = "number",
            tooltip = "The height of the edit box.\n\nDefault is 27.",
            dbPath = "profile.chat.edit_box.height"
        },
        { type = "divider",
        },
        {   name = L["Border"],
            type = "dropdown",
            options = tk.Constants.LSM:List("border"),
            dbPath = "profile.chat.edit_box.border",
        },
        {   name = L["Background Color"],
            type = "color",
            height = 64,
            dbPath = "profile.chat.edit_box.backdrop_color"
        },
        { type = "divider",
        },
        {   name = L["Border Size"],
            type = "textfield",
            valueType = "number",
            tooltip = L["Set the border size.\n\nDefault is 1."],
            dbPath = "profile.chat.edit_box.border_size"
        },
        {   name = L["Backdrop Inset"],
            type = "textfield",
            valueType = "number",
            tooltip = L["Set the spacing between the background and the border.\n\nDefault is 0."],
            dbPath = "profile.chat.edit_box.inset"
        },
        {   name = L["Chat Frame Options"],
            type = "title",
        },
        {   type = "loop",
            args = {
                {"Top Left"}, {"Bottom Left"}, {"Top Right"}, {"Bottom Right"}
            },
            func = function(id, name)
                return 
                {
                    name = name.." "..L["Options"],
                    type = "submenu",
                    module = "Chat",
                    inherit = {
                        type = "dropdown",
                        options = namespace.ButtonNames,
                    },
                    children = { -- shame I can't loop this
                        {   name = L["Enable Chat Frame"],
                            type = "check",
                            requires_reload = true,
                            dbPath = "profile.chat.enabled["..name:upper():gsub("%s+", "").."]"
                        },
                        {   name = L["Button Swapping in Combat"],
                            type = "check",
                            tooltip = L["Allow the use of modifier keys to swap chat buttons while in combat."],
                            dbPath = "profile.chat.data["..id.."].combat_swap",
                        },
                        {   name = L["Standard Chat Buttons"],
                            type = "title",
                            padding_top = 0
                        },
                        {   name = L["Left Button"],
                            dbPath = "profile.chat.data["..id.."].buttons[1][1]"
                        },
                        {   name = L["Middle Button"],
                            dbPath = "profile.chat.data["..id.."].buttons[1][2]"
                        },
                        {   name = L["Right Button"],
                            dbPath = "profile.chat.data["..id.."].buttons[1][3]"
                        },
                        {   name = L["Chat Buttons with Modifier Key 1"],
                            type = "title",
                        },
                        {   name = "Control",
                            height = 40,
                            min_width = true,
                            type = "check",
                            dbPath = "profile.chat.data["..id.."].buttons[2].key",
                            GetValue = function(_, current_value)
                                return current_value:find("C");
                            end,
                            SetValue = function(dbPath, old_value, value)
                                value = value and "C";
                                if (not value and old_value:find("C")) then
                                    value = old_value:gsub("C", "")
                                    db:SetPathValue(dbPath, value);
                                else
                                    old_value = old_value..value;
                                    db:SetPathValue(dbPath, old_value);
                                end
                            end
                        },
                        {   name = L["Shift"],
                            height = 40,
                            min_width = true,
                            type = "check",
                            dbPath = "profile.chat.data["..id.."].buttons[2].key",
                            GetValue = function(_, current_value)
                                return current_value:find("S");
                            end,
                            SetValue = function(dbPath, old_value, value)
                                value = value and "S";
                                if (not value and old_value:find("S")) then
                                    value = old_value:gsub("S", "")
                                    db:SetPathValue(dbPath, value);
                                else
                                    old_value = old_value..value;
                                    db:SetPathValue(dbPath, old_value);
                                end
                            end
                        },
                        {   name = L["Alt"],
                            height = 40,
                            min_width = true,
                            type = "check",
                            dbPath = "profile.chat.data["..id.."].buttons[2].key",
                            GetValue = function(_, current_value)
                                return current_value:find("A");
                            end,
                            SetValue = function(dbPath, old_value, value) -- the path and the new value
                                value = value and "A";
                                if (not value and old_value:find("A")) then
                                    value = old_value:gsub("A", "");
                                else
                                    value = old_value..value;
                                end
                                db:SetPathValue(dbPath, value);
                            end
                        },
                        {   type = "divider",
                        },
                        {   name = L["Left Button"],
                            dbPath = "profile.chat.data["..id.."].buttons[2][1]"
                        },
                        {   name = L["Middle Button"],
                            dbPath = "profile.chat.data["..id.."].buttons[2][2]"
                        },
                        {   name = L["Right Button"],
                            dbPath = "profile.chat.data["..id.."].buttons[2][3]"
                        },
                        {   name = L["Chat Buttons with Modifier Key 2"],
                            type = "title",
                        },
                        {   name = "Control",
                            height = 40,
                            min_width = true,
                            type = "check",
                            dbPath = "profile.chat.data["..id.."].buttons[3].key",
                            GetValue = function(_, current_value)
                                return current_value:find("C");
                            end,
                            SetValue = function(dbPath, old_value, value)
                                value = value and "C";
                                if (not value and old_value:find("C")) then
                                    value = old_value:gsub("C", "")
                                    db:SetPathValue(dbPath, value);
                                else
                                    old_value = old_value..value;
                                    db:SetPathValue(dbPath, old_value);
                                end
                            end
                        },
                        {   name = L["Shift"],
                            height = 40,
                            min_width = true,
                            type = "check",
                            dbPath = "profile.chat.data["..id.."].buttons[3].key",
                            GetValue = function(_, current_value)
                                return current_value:find("S");
                            end,
                            SetValue = function(dbPath, old_value, value)
                                value = value and "S";
                                if (not value and old_value:find("S")) then
                                    value = old_value:gsub("S", "")
                                    db:SetPathValue(dbPath, value);
                                else
                                    old_value = old_value..value;
                                    db:SetPathValue(dbPath, old_value);
                                end
                            end
                        },
                        {   name = L["Alt"],
                            height = 40,
                            min_width = true,
                            type = "check",
                            dbPath = "profile.chat.data["..id.."].buttons[3].key",
                            GetValue = function(_, current_value)
                                return current_value:find("A");
                            end,
                            SetValue = function(dbPath, old_value, value) -- the path and the new value
                            value = value and "A";
                            if (not value and old_value:find("A")) then
                                value = old_value:gsub("A", "")
                                db:SetPathValue(dbPath, value);
                            else
                                old_value = old_value..value;
                                db:SetPathValue(dbPath, old_value);
                            end
                            end
                        },
                        {   type = "divider",
                        },
                        {   name = L["Left Button"],
                            dbPath = "profile.chat.data["..id.."].buttons[3][1]"
                        },
                        {   name = L["Middle Button"],
                            dbPath = "profile.chat.data["..id.."].buttons[3][2]"
                        },
                        {   name = L["Right Button"],
                            dbPath = "profile.chat.data["..id.."].buttons[3][3]"
                        },
                    }
                }
            end
        },
    }
};