-- luacheck: ignore MayronUI self 143 631
local tonumber, ipairs, MayronUI, tostring = _G.tonumber, _G.ipairs, _G.MayronUI, _G.tostring;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();
local _, C_AurasModule = MayronUI:ImportModule("AurasModule");
local tconcat, strsplit, strformat = _G.table.concat, _G.string.split, _G.string.format;

-- contains auraarea name / table pairs where each table holds the 5 config textfield widgets
-- this is used to update the config menu view after moving the aura areas (by unlocking them)
local position_TextFields = {};
local savePositionButtons = {};

local function AuraAreaPosition_OnLoad(configTable, container)
  local positionIndex = configTable.dbPath:match("%[(%d)%]$");
  position_TextFields[configTable.auraAreaName][tonumber(positionIndex)] = container.widget;
end

local function AuraArea_OnDragStop(field)
  local positions = tk.Tables:GetFramePosition(field);
  local auraAreaName = field:GetName():match("MUI_(.*)Area");

  if (positions) then
    -- update the config menu view
    for index, positionWidget in ipairs(position_TextFields[auraAreaName]) do
      if (positionWidget:GetObjectType() == "TextField") then
        positionWidget:SetText(tostring(positions[index]));
      elseif (positionWidget:GetObjectType() == "Slider") then
        positionWidget.editBox:SetText(positions[index]);
      end
    end
  end

  savePositionButtons[auraAreaName]:SetEnabled(true);
end

function C_AurasModule:GetConfigTable(data)
  return {
    type = "menu",
    module = "AurasModule",
    dbPath = "profile.auras",
    children =  {
      { name = L["Enabled"],
        tooltip = "If checked, this module will be enabled.",
        type = "check",
        requiresReload = true, -- TODO: Maybe modules can be global? - move module enable/disable to general menu?
        appendDbPath = "enabled",
      },
      { type = "divider"
      },
      { type = "loop";
        args = { "Buffs", "Debuffs" },
        func = function(_, name)
          local statusBarsEnabled = data.settings[name].statusBars.enabled;

          local tbl = {
            type = "submenu",
            name = L[name];
            dbPath = "profile.auras."..name,

            OnLoad = function()
              position_TextFields[name] = obj:PopTable();
            end;

            children = {
              { name = L["Enabled"],
                type = "check",
                appendDbPath = "enabled",
                requiresReload = true, -- TODO: If this has changed, THEN show reload message?
              },
              { name = L["Layout Type"];
                requiresReload = true; -- TODO: Can I rework this?
                type = "dropdown";
                appendDbPath = "statusBars.enabled";
                options = {
                  [L["Icons"]] = "Icons",
                  [L["Status Bars"]] = "Status Bars"
                };
                GetValue = function(_, value)
                  return (not value and L["Icons"]) or L["Status Bars"];
                end;
                SetValue = function(_, value)
                  value = value == "Status Bars";
                  db:SetPathValue(db.profile, "auras." .. name .. ".statusBars.enabled", value);
                end;
              };
              { type = "divider";
              };
              { name = L["Unlock"];
                type = "button";
                OnClick = function(button)
                  local auraArea = _G["MUI_"..name.."Area"];

                  if (not (auraArea and auraArea:IsShown())) then return end

                  button.toggle = not button.toggle;
                  tk:MakeMovable(auraArea, nil, button.toggle, nil, AuraArea_OnDragStop);

                  if (button.toggle) then
                    if (not auraArea.moveIndicator) then
                      local r, g, b = tk:GetThemeColor();
                      auraArea.moveIndicator = tk:SetBackground(auraArea, r, g, b);
                      auraArea.moveLabel = auraArea:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
                      auraArea.moveLabel:SetText(strformat("<%s Area>", name));
                      auraArea.moveLabel:SetPoint("CENTER");
                    end

                    auraArea.moveIndicator:SetAlpha(0.4);
                    auraArea.moveLabel:SetAlpha(0.8);
                    button:SetText(L["Lock"]);

                  elseif (auraArea.moveIndicator) then
                    auraArea.moveIndicator:SetAlpha(0);
                    auraArea.moveLabel:SetAlpha(0);
                    button:SetText("Unlock");
                  end
                end
              };
              { name = L["Save Position"];
                type = "button";

                OnLoad = function(_, button)
                  savePositionButtons[name] = button;
                  button:SetEnabled(false);
                end;

                OnClick = function(_)
                  local auraArea = _G["MUI_"..name.."Area"];
                  if (not (auraArea and auraArea:IsShown())) then return end

                  local positions = tk.Tables:GetFramePosition(auraArea);
                  local dbPath;

                  if (statusBarsEnabled) then
                    dbPath = tk.Strings:Concat("auras.", name, ".statusBars.position");
                  else
                    dbPath = tk.Strings:Concat("auras.", name, ".icons.position");
                  end

                  db:SetPathValue(db.profile, dbPath, positions);
                  AuraArea_OnDragStop(auraArea);
                  savePositionButtons[name]:SetEnabled(false);
                end
              };
              { type = "check";
                name = L["Show Pulse Effect"];
                appendDbPath = "showPulseEffect";
              };
              { name = L["Manual Positioning"],
                type = "title",
              },
              { type = "loop";
                args = { L["Point"], L["Relative Frame"], L["Relative Point"], L["X-Offset"], L["Y-Offset"] };
                func = function(index, arg)
                  local dbPath;

                  if (statusBarsEnabled) then
                    dbPath = tk.Strings:Concat("profile.auras.", name, ".statusBars.position[", index, "]");
                  else
                    dbPath = tk.Strings:Concat("profile.auras.", name, ".icons.position[", index, "]");
                  end

                  local config = {
                    name = arg;
                    type = "textfield";
                    valueType = "string";
                    dbPath = dbPath;
                    auraAreaName = name;
                    OnLoad = AuraAreaPosition_OnLoad;
                  };

                  if (index > 3) then
                    config.type = "slider";
                    config.min = -300;
                    config.max = 300;
                  end

                  return config;
                end
              };
              { type = "title";
                name = L["Icon Options"];
              };
              { type = "condition";
                func = function()
                  return not statusBarsEnabled;
                end;
                onFalse = {
                  { type = "fontstring";
                    content = L["Icon options are disabled when using status bars."];
                  };
                };
                onTrue = {
                  { type = "slider";
                    name = L["Icon Size"];
                    appendDbPath = "icons.auraSize";
                    min = 20;
                    max = 100;
                  };
                  { name = L["Column Spacing"],
                    type = "slider",
                    appendDbPath = "icons.colSpacing",
                    min = 1,
                    max = 50;
                  },
                  { name = L["Row Spacing"],
                    type = "slider",
                    appendDbPath = "icons.rowSpacing",
                    min = 1,
                    max = 50;
                  };
                  { name = L["Icons per Row"];
                    type = "slider";
                    appendDbPath = "icons.perRow";
                    min = 1;
                    max = name == "Buffs" and _G.BUFF_MAX_DISPLAY or _G.DEBUFF_MAX_DISPLAY;
                  };
                  { name = L["Growth Direction"],
                    type = "dropdown",
                    appendDbPath = "icons.growDirection",
                    options = { Left = "LEFT", Right = "RIGHT" }
                  };
                };
              };
              { type = "title";
                name = L["Status Bar Options"];
              };
              { type = "condition";
                func = function()
                  return statusBarsEnabled;
                end;
                onFalse = {
                  { type = "fontstring";
                    content = L["Status bar options are disabled when using icons."];
                  }
                };
                onTrue = {
                    { type = "dropdown";
                      name = L["Bar Texture"];
                      options = tk.Constants.LSM:List("statusbar");
                      appendDbPath = "statusBars.barTexture";
                    };
                    { type = "slider";
                      name = L["Bar Width"];
                      appendDbPath = "statusBars.width";
                      min = 100;
                      max = 400;
                    };
                    { type = "slider";
                      name = L["Bar Height"];
                      appendDbPath = "statusBars.height";
                      min = 10;
                      max = 80;
                    };
                    { name = L["Spacing"],
                      type = "slider",
                      appendDbPath = "statusBars.spacing",
                      min = 0,
                      max = 50;
                    },
                    { type = "slider";
                      name = L["Icon Gap"];
                      appendDbPath = "statusBars.iconGap";
                      min = 0;
                      max = 10;
                    };
                    { name = L["Growth Direction"],
                      type = "dropdown",
                      appendDbPath = "statusBars.growDirection",
                      options = { Up = "UP", Down = "DOWN" }
                    };
                    { name = L["Show Spark"],
                      type = "check",
                      appendDbPath = "statusBars.showSpark",
                    };
                };
              };
              { type = "title";
                name = L["Text"];
              };
              { type = "loop";
                args = { "Time Remaining", "Count", "Aura Name" },
                func = function(_, textName)
                  local sections = obj:PopTable(strsplit(" ", textName));
                  sections[1] = sections[1]:lower();

                  local key = tconcat(sections, "");
                  obj:PushTable(sections);

                  local xOffsetDbPath = strformat("textPosition.%s[1]", key);
                  local yOffsetDbPath = strformat("textPosition.%s[2]", key);
                  local textSizeDbPath = strformat("textSize.%s", key);

                  if (statusBarsEnabled) then
                    xOffsetDbPath = strformat("textPosition.statusBars.%s[1]", key);
                    yOffsetDbPath = strformat("textPosition.statusBars.%s[2]", key);
                    textSizeDbPath = strformat("textSize.statusBars.%s", key);
                  elseif (textName == "Aura Name") then
                    return
                  end

                  return {
                    { type = "fontstring";
                      subtype = "header";
                      content = L[textName];
                    };
                    { type = "slider";
                      name = L["X-Offset"];
                      appendDbPath = xOffsetDbPath;
                      min = -20,
                      max = 20
                    };
                    { type = "slider";
                      name = L["Y-Offset"];
                      appendDbPath = yOffsetDbPath;
                      min = -20,
                      max = 20
                    };
                    { type = "slider";
                      name = L["Font Size"];
                      appendDbPath = textSizeDbPath;
                      min = 8;
                      max = 24;
                    };
                  }
                end;
              };
              { type = "title";
                name = L["Border"];
              };                      { type = "dropdown";
                name = L["Border Type"];
                options = tk.Constants.LSM:List("border");
                appendDbPath = "border.type";
              };
              { type = "slider";
                name = L["Border Size"];
                appendDbPath = "border.size";
                min = 1;
                max = 10;
              };
              { type = "title";
                name = L["Colors"];
              };
              { name = L["Basic %s"]:format(L[name]);
                type = "color";
                width = 200;
                useIndexes = true;
                appendDbPath = "colors.aura";
              },
              { type = "condition";
                func = function()
                  return name == "Buffs";
                end;
                onTrue = {
                  { name = L["Weapon Enchants"],
                    type = "color",
                    width = 200;
                    useIndexes = true;
                    appendDbPath = "colors.enchant"
                  }
                };
                onFalse = {
                  { name = L["Magic Debuff"];
                    type = "color";
                    width = 200;
                    useIndexes = true;
                    appendDbPath = "colors.magic";
                  };
                  { name = L["Disease Debuff"];
                    type = "color";
                    width = 200;
                    useIndexes = true;
                    appendDbPath = "colors.disease";
                  };
                  { name = L["Poison Debuff"];
                    type = "color";
                    width = 200;
                    useIndexes = true;
                    appendDbPath = "colors.poison";
                  };
                  { name = L["Curse Debuff"];
                    type = "color";
                    width = 200;
                    useIndexes = true;
                    appendDbPath = "colors.curse";
                  };
                }
              };
              { type = "condition";
                func = function()
                  return statusBarsEnabled;
                end;
                onTrue = {
                  { name = L["Bar Background"];
                    type = "color";
                    width = 200;
                    useIndexes = true;
                    hasOpacity = true;
                    appendDbPath = "colors.statusBarBackground";
                  };
                  { name = L["Bar Border"];
                    type = "color";
                    width = 200;
                    useIndexes = true;
                    appendDbPath = "colors.statusBarBorder";
                  };
                }
              }
            };
          };

          return tbl;
        end;
      };
    }
  };
end