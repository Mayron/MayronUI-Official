-- luacheck: ignore MayronUI self 143
local _, namespace = ...;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();
local C_ChatModule = namespace.C_ChatModule;

local ChatFrameAnchorDropDownOptions = {
    ["Top Left"] = "TOPLEFT";
    ["Top Right"] = "TOPRIGHT";
    ["Bottom Left"] = "BOTTOMLEFT";
    ["Bottom Right"] = "BOTTOMRIGHT";
};

-- Config Data ----------------------

local function CreateButtonConfigTable(dbPath, buttonID)
    local configTable = {};

    if (buttonID == 1) then
        table.insert(configTable, {
            name = L["Standard Chat Buttons"],
            type = "title"
        });
    else
        table.insert(configTable, {
            name = string.format("Chat Buttons with Modifier Key %d", buttonID),
            type = "title"
        });
    end

    table.insert(configTable, {
        name = L["Left Button"],
        dbPath = string.format("%s.buttons[%d][1]", dbPath, buttonID)
    });

    table.insert(configTable, {
        name = L["Middle Button"],
        dbPath = string.format("%s.buttons[%d][2]", dbPath, buttonID)
    });

    table.insert(configTable, {
        name = L["Right Button"],
        dbPath = string.format("%s.buttons[%d][3]", dbPath, buttonID)
    });


    table.insert(configTable, { type = "divider" });

    if (buttonID == 1) then
        return _G.unpack(configTable);
    end

    for _, modKey in obj:IterateArgs(L["Control"], L["Shift"], L["Alt"]) do
        local modKeyFirstChar = string.sub(modKey, 1, 1);

        table.insert(configTable, {
            name = modKey,
            height = 40,
            type = "check",
            dbPath = string.format("%s.buttons[%d].key", dbPath, buttonID),

            GetValue = function(_, currentValue)
                if (currentValue:find(modKeyFirstChar)) then
                    return true;
                end

                return false;
            end,

            SetValue = function(valueDbPath, checked, oldValue)
                if (checked) then
                    -- add it
                    local newValue = (oldValue and tk.Strings:Concat(oldValue, modKeyFirstChar)) or modKeyFirstChar;
                    db:SetPathValue(valueDbPath, newValue);

                elseif (oldValue and oldValue:find(modKeyFirstChar)) then
                    -- remove it
                    local newValue = oldValue:gsub(modKeyFirstChar, tk.Strings.Empty);
                    db:SetPathValue(valueDbPath, newValue);
                end
            end
        });
    end

    return _G.unpack(configTable);
end

function C_ChatModule:GetConfigTable()
    return {
        name = "Chat Frames",
        module = "Chat",
        children = {
            {   name = L["Edit Box (Message Input Box)"],
                type = "title",
                marginTop = 0;
            },
            {   name = "Top";
                type = "radio";
                groupName = "editBox_tabPositions";
                dbPath = "profile.chat.editBox.position";
                GetValue = function(_, value)
                    return value == "TOP";
                end;

                SetValue = function(path)
                    db:SetPathValue(path, "TOP");
                end;
            },
            {   name = "Bottom";
                type = "radio";
                groupName = "editBox_tabPositions";
                dbPath = "profile.chat.editBox.position";
                GetValue = function(_, value)
                    return value == "BOTTOM";
                end;

                SetValue = function(path)
                    db:SetPathValue(path, "BOTTOM");
                end;
            },
            {   type = "divider";
            };
            {   name = L["Y-Offset"],
                type = "textfield",
                valueType = "number",
                tooltip = "Set the vertical positioning of the edit box.\n\nDefault is -8.",
                dbPath = "profile.chat.editBox.yOffset"
            },
            {   name = L["Height"],
                type = "textfield",
                valueType = "number",
                tooltip = "The height of the edit box.\n\nDefault is 27.",
                dbPath = "profile.chat.editBox.height"
            },
            { type = "divider",
            },
            {   name = L["Border"],
                type = "dropdown",
                options = tk.Constants.LSM:List("border"),
                dbPath = "profile.chat.editBox.border",
            },
            {   name = L["Background Color"],
                type = "color",
                height = 64,
                hasOpacity = true;
                dbPath = "profile.chat.editBox.backdropColor"
            },
            { type = "divider",
            },
            {   name = L["Border Size"],
                type = "textfield",
                valueType = "number",
                tooltip = L["Set the border size.\n\nDefault is 1."],
                dbPath = "profile.chat.editBox.borderSize"
            },
            {   name = L["Backdrop Inset"],
                type = "textfield",
                valueType = "number",
                tooltip = L["Set the spacing between the background and the border.\n\nDefault is 0."],
                dbPath = "profile.chat.editBox.inset"
            },
            {   name = L["Chat Frame Options"],
                type = "title",
            },
            {   name = L["Button Swapping in Combat"],
                type = "check",
                tooltip = L["Allow the use of modifier keys to swap chat buttons while in combat."],
                dbPath = "profile.chat.swapInCombat",
            },
            {   name = "Anchor Chat Icons",
                type = "dropdown",
                tooltip = "Select which chat frame the chat icons should be anchored to.",
                options = ChatFrameAnchorDropDownOptions;
                dbPath = "profile.chat.icons.anchor",
            },
            {   type = "divider"
            },
            {   name = "Show Copy Chat Icon",
                type = "check",
                dbPath = "profile.chat.icons.copyChat",
            },
            {   name = "Show Emotes Icon",
                type = "check",
                dbPath = "profile.chat.icons.emotes",
            },
            {   name = "Show Player Status Icon",
                type = "check",
                dbPath = "profile.chat.icons.playerStatus",
            },
            {   type = "divider"
            },
            {   type = "loop",
                args = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"},

                func = function(_, chatFrameName)
                    local dbPath = string.format("profile.chat.chatFrames.%s", chatFrameName);
                    local chatFrameLabel;

                    for key, value in pairs(ChatFrameAnchorDropDownOptions) do
                        if (chatFrameName == value) then
                            chatFrameLabel = key;
                            break;
                        end
                    end

                    local ConfigTable =
                    {
                        name = tk.Strings:JoinWithSpace(chatFrameLabel, L["Options"]),
                        type = "submenu",
                        module = "Chat",
                        inherit = {
                            type = "dropdown",
                            options = namespace.ButtonNames;
                        },
                        children = { -- shame I can't loop this
                            {   name = L["Enable Chat Frame"],
                                type = "check",
                                dbPath = string.format("%s.enabled", dbPath),
                            },
                            {   type = "divider";
                            };
                            {   name = "Show Tab Bar",
                                tooltip = "This is the background bar that goes behind the tabs";
                                type = "check",
                                dbPath = string.format("%s.tabBar.show", dbPath),
                            };
                            {   name = "Tab Bar Y-Offset",
                                type = "textfield",
                                valueType = "number";
                                dbPath = string.format("%s.tabBar.yOffset", dbPath),
                            };
                            {   name = "Window Y-Offset",
                                type = "textfield",
                                valueType = "number";
                                dbPath = string.format("%s.window.yOffset", dbPath),
                            };
                        }
                    };

                    for i = 1, 3 do
                        tk.Tables:AddAll(ConfigTable.children, CreateButtonConfigTable(dbPath, i));
                    end

                    return ConfigTable;
                end
            },
        }
    };
end