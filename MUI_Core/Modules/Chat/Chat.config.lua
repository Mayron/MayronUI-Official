-- luacheck: ignore MayronUI self 143
local MayronUI = _G.MayronUI;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();
local _, C_ChatModule = MayronUI:ImportModule("ChatModule");
local table, string, unpack = _G.table, _G.string, _G.unpack;

local ChatFrameAnchorDropDownOptions = {
  [L["Top Left"]] = "TOPLEFT";
  [L["Top Right"]] = "TOPRIGHT";
  [L["Bottom Left"]] = "BOTTOMLEFT";
  [L["Bottom Right"]] = "BOTTOMRIGHT";
};

-- Config Data ----------------------

local function CreateButtonConfigTable(dbPath, buttonID, chatFrame, addWidget)
  local configTable = obj:PopTable();

  if (buttonID == 1) then
    table.insert(configTable, {
      name = L["Standard Chat Buttons"],
      type = "title"
    });
  else
    table.insert(configTable, {
      name = string.format(L["Chat Buttons with Modifier Key %d"], buttonID),
      type = "title"
    });
  end

  table.insert(configTable, {
    name = L["Left Button"],
    dbPath = string.format("%s.buttons[%d][1]", dbPath, buttonID),
    enabled = chatFrame ~= nil,
    OnLoad = addWidget
  });

  table.insert(configTable, {
    name = L["Middle Button"],
    dbPath = string.format("%s.buttons[%d][2]", dbPath, buttonID),
    enabled = chatFrame ~= nil,
    OnLoad = addWidget
  });

  table.insert(configTable, {
    name = L["Right Button"],
    dbPath = string.format("%s.buttons[%d][3]", dbPath, buttonID),
    enabled = chatFrame ~= nil,
    OnLoad = addWidget
  });

  table.insert(configTable, { type = "divider" });

  if (buttonID == 1) then
    return unpack(configTable);
  end

  for _, modKey in obj:IterateArgs(L["Control"], L["Shift"], L["Alt"]) do
    local modKeyFirstChar = string.sub(modKey, 1, 1);

    table.insert(configTable, {
      name = modKey,
      height = 40,
      type = "check",
      dbPath = string.format("%s.buttons[%d].key", dbPath, buttonID),
      enabled = chatFrame ~= nil,
      OnLoad = addWidget,

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

  return unpack(configTable);
end

function C_ChatModule:GetConfigTable()
    return {
        module = "ChatModule",
        dbPath = "profile.chat",
        children = {
            {   name = L["Enabled"],
                tooltip = "If checked, this module will be enabled.",
                type = "check",
                requiresReload = true, -- TODO: Maybe modules can be global? - move module enable/disable to general menu?
                appendDbPath = "enabled",
            },
            {
              type = "divider"
            },
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
                type = "slider",
                min = -50;
                max = 50;
                valueType = "number",
                tooltip = tk.Strings:Join(
                    L["Set the vertical positioning of the edit box."],
                    "\n\n", L["Default value is "], "-8."),
                dbPath = "profile.chat.editBox.yOffset"
            },
            {   name = L["Set Height"],
                type = "slider",
                min = 20;
                max = 50;
                tooltip = tk.Strings:Join(
                    L["The height of the edit box."], "\n\n", L["Default value is "], "27."),
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
                type = "slider",
                min = 1;
                max = 10;
                tooltip = L["Set the border size.\n\nDefault is 1."],
                dbPath = "profile.chat.editBox.borderSize"
            },
            {   name = L["Backdrop Inset"],
                type = "slider",
                min = 0;
                max = 10;
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
            {   name = L["Anchor Chat Icons"],
                type = "dropdown",
                tooltip = L["Select which chat frame the chat icons should be anchored to."],
                options = ChatFrameAnchorDropDownOptions;
                dbPath = "profile.chat.icons.anchor",
            },
            {   type = "divider"
            },
            {   name = "Show Voice Chat Icons",
                type = "check",
                tooltip = "Show the chat channels, deafen voice chat and mute icons.",
                dbPath = "profile.chat.icons.voiceChat",
            },
            {   name = L["Show Copy Chat Icon"],
                type = "check",
                dbPath = "profile.chat.icons.copyChat",
            },
            {   name = L["Show Emotes Icon"],
                type = "check",
                dbPath = "profile.chat.icons.emotes",
            },
            {   name = L["Show Player Status Icon"],
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
                    local chatFrame = _G["MUI_ChatFrame_"..chatFrameName];
                    local disabledWidgets = {};

                    local addWidget = function(_, widget)
                      table.insert(disabledWidgets, widget);
                    end

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
                            options = C_ChatModule.Static.ButtonNames;
                        },
                        children = { -- shame I can't loop this
                            {   name = L["Enable Chat Frame"],
                                type = "check",
                                dbPath = string.format("%s.enabled", dbPath),
                                OnClick = function(_, value)
                                  for _, container in ipairs(disabledWidgets) do
                                    local widget = container.widget or container.btn;
                                    widget:SetEnabled(value);
                                  end
                                end
                            },
                            {   name = L["Show Tab Bar"],
                                tooltip = L["This is the background bar that goes behind the tabs."];
                                type = "check",
                                dbPath = string.format("%s.tabBar.show", dbPath),
                                enabled = chatFrame ~= nil,
                                OnLoad = addWidget
                            };
                            {   type = "divider";
                            };
                            {   name = tk.Strings:JoinWithSpace(L["Tab Bar"], L["Y-Offset"]),
                                type = "slider",
                                min = -50;
                                max = 50;
                                dbPath = string.format("%s.tabBar.yOffset", dbPath),
                                enabled = chatFrame ~= nil,
                                OnLoad = addWidget
                            };
                            {   name = tk.Strings:JoinWithSpace(L["Window"], L["Y-Offset"]),
                                type = "slider",
                                min = -50;
                                max = 50;
                                dbPath = string.format("%s.window.yOffset", dbPath),
                                enabled = chatFrame ~= nil,
                                OnLoad = addWidget
                            };
                            {   name = tk.Strings:JoinWithSpace("Chat Frame", L["X-Offset"]),
                                type = "slider",
                                min = -50;
                                max = 50;
                                dbPath = string.format("%s.xOffset", dbPath),
                                enabled = chatFrame ~= nil,
                                OnLoad = addWidget
                            };
                            {   name = tk.Strings:JoinWithSpace("Chat Frame", L["Y-Offset"]),
                                type = "slider",
                                min = -50;
                                max = 50;
                                dbPath = string.format("%s.yOffset", dbPath),
                                enabled = chatFrame ~= nil,
                                OnLoad = addWidget
                            };
                        }
                    };

                    for i = 1, 3 do
                      tk.Tables:AddAll(ConfigTable.children, CreateButtonConfigTable(dbPath, i, chatFrame, addWidget));
                    end

                    return ConfigTable;
                end
            },
        }
    };
end