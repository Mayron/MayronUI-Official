-- luacheck: ignore MayronUI self 143
local _, namespace = ...;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();
local C_ChatModule = namespace.C_ChatModule;

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
                return currentValue and currentValue:find(modKeyFirstChar);
            end,

            SetValue = function(valueDbPath, oldValue, newValue)
                newValue = newValue and modKeyFirstChar;

                if (not newValue and oldValue and oldValue:find(modKeyFirstChar)) then
                    newValue = oldValue:gsub("S", tk.Strings.Empty); -- remove it
                    db:SetPathValue(valueDbPath, newValue);
                else
                    newValue = (oldValue and tk.Strings:Concat(oldValue, newValue)) or newValue; -- add it
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
            {   type = "divider"
            },
            {   type = "loop",
                args = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"},

                func = function(_, chatFrameName)
                    local dbPath = string.format("profile.chat.chatFrames.%s", chatFrameName);
                    local chatFrameLabel;

                    if (tk.Strings:Contains(chatFrameName, "TOP")) then
                        chatFrameLabel = "Top";
                    else
                        chatFrameLabel = "Bottom";
                    end

                    if (tk.Strings:Contains(chatFrameName, "LEFT")) then
                        chatFrameLabel = tk.Strings:JoinWithSpace(chatFrameLabel, "Left");
                    else
                        chatFrameLabel = tk.Strings:JoinWithSpace(chatFrameLabel, "Right");
                    end

                    local ConfigTable =
                    {
                        name = tk.Strings:JoinWithSpace(chatFrameLabel, L["Options"]),
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
                                dbPath = string.format("%s.enabled", dbPath),
                            },
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