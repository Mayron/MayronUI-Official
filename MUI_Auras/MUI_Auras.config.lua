-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;

local _G = _G;
local tonumber, ipairs, MayronUI = _G.tonumber, _G.ipairs, _G.MayronUI;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();
local C_AurasModule = namespace.C_AurasModule;

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
        for id, textField in ipairs(position_TextFields[auraAreaName]) do
            textField:SetText(positions[id]);
        end
    end

    savePositionButtons[auraAreaName]:SetEnabled(true);
end

function C_AurasModule:GetConfigTable(data)
    return {
        name = "Auras (Buffs & Debuffs)",
        type = "menu",
        module = "AurasModule",
        children =  {
            {   type = "loop";
                args = { "Buffs", "Debuffs" },
                func = function(_, name)
                    local statusBarsEnabled = data.settings[name].statusBars.enabled;

                    local tbl = {
                        type = "submenu",
                        name = name;
                        dbPath = "profile.auras."..name,

                        OnLoad = function()
                            position_TextFields[name] = obj:PopTable();
                        end;

                        children = {
                            {   name = "Enabled",
                                type = "check",
                                appendDbPath = "enabled",
                            },
                            {   name = "Layout Type";
                                requiresReload = true;
                                type = "dropdown";
                                appendDbPath = "statusBars.enabled";
                                options = { "Icons", "Status Bars" };
                                GetValue = function(_, value)
                                    return (not value and "Icons") or "Status Bars";
                                end;
                                SetValue = function(_, value)
                                    value = value == "Status Bars";
                                    db:SetPathValue(db.profile, "auras." .. name .. ".statusBars.enabled", value);
                                end;
                            };
                            {   type = "divider";
                            };
                            {   name = L["Unlock"];
                                type = "button";
                                OnClick = function(button)
                                    local auraArea = _G["MUI_"..name.."Area"];

                                    if (not (auraArea and auraArea:IsShown())) then
                                        return;
                                    end

                                    button.toggle = not button.toggle;
                                    tk:MakeMovable(auraArea, nil, button.toggle, nil, AuraArea_OnDragStop);

                                    if (button.toggle) then
                                        if (not auraArea.moveIndicator) then
                                            local r, g, b = tk:GetThemeColor();
                                            auraArea.moveIndicator = tk:SetBackground(auraArea, r, g, b);
                                            auraArea.moveLabel = auraArea:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
                                            auraArea.moveLabel:SetText(string.format("<%s Area>", name));
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
                            {   name = "Save Position";
                                type = "button";

                                OnLoad = function(_, button)
                                    savePositionButtons[name] = button;
                                    button:SetEnabled(false);
                                end;

                                OnClick = function(_)
                                    local auraArea = _G["MUI_"..name.."Area"];

                                    if (not (auraArea and auraArea:IsShown())) then
                                        return;
                                    end

                                    local positions = tk.Tables:GetFramePosition(auraArea);
                                    local dbPath;

                                    if (statusBarsEnabled) then
                                        dbPath =  tk.Strings:Concat("auras.", name, ".statusBars.position");
                                    else
                                        dbPath =  tk.Strings:Concat("auras.", name, ".icons.position");
                                    end

                                    db:SetPathValue(db.profile, dbPath, positions);
                                    AuraArea_OnDragStop(auraArea);
                                    savePositionButtons[name]:SetEnabled(false);
                                end
                            };
                            {   type = "check";
                                name = "Show Pulse Effect";
                                appendDbPath = "showPulseEffect";
                            };
                            {   name = L["Manual Positioning"],
                                type = "title",
                            },
                            {   type = "loop";
                                args = { L["Point"], L["Relative Frame"], L["Relative Point"], L["X-Offset"], L["Y-Offset"] };
                                func = function(index, arg)
                                    local dbPath;

                                    if (statusBarsEnabled) then
                                        dbPath = tk.Strings:Concat("profile.auras.", name, ".statusBars.position[", index, "]");
                                    else
                                        dbPath = tk.Strings:Concat("profile.auras.", name, ".icons.position[", index, "]");
                                    end

                                    return {
                                        name = arg;
                                        type = "textfield";
                                        valueType = "string";
                                        dbPath = dbPath;
                                        auraAreaName = name;
                                        OnLoad = AuraAreaPosition_OnLoad;
                                    };
                                end
                            };
                            {   type = "title";
                                name = "Icon Options";
                            };
                            {   type = "condition";
                                func = function()
                                    return not statusBarsEnabled;
                                end;
                                onFalse = {
                                    {   type = "fontstring";
                                        content = "Icon options are disabled when using status bars.";
                                    }
                                };
                                onTrue = {
                                    {   type = "slider";
                                        name = "Icon Size";
                                        appendDbPath = "icons.auraSize";
                                        min = 30;
                                        max = 100;
                                    };
                                    {   name = "Column Spacing",
                                        type = "slider",
                                        appendDbPath = "icons.colSpacing",
                                        min = 1,
                                        max = 50;
                                    },
                                    {   name = "Row Spacing",
                                        type = "slider",
                                        appendDbPath = "icons.rowSpacing",
                                        min = 1,
                                        max = 50;
                                    };
                                    {   name = "Icons per Row";
                                        type = "slider";
                                        appendDbPath = "icons.perRow";
                                        min = 1;
                                        max = name == "Buffs" and _G.BUFF_MAX_DISPLAY or _G.DEBUFF_MAX_DISPLAY;
                                    };
                                    {   name = "Growth Direction",
                                        type = "dropdown",
                                        appendDbPath = "icons.growDirection",
                                        options = { Left = "LEFT", Right = "RIGHT" }
                                    };
                                };
                            };
                            {   type = "title";
                                name = "Status Bar Options";
                            };
                            {   type = "condition";
                                func = function()
                                    return statusBarsEnabled;
                                end;
                                onFalse = {
                                    {   type = "fontstring";
                                        content = "Status bar options are disabled when using icons.";
                                    }
                                };
                                onTrue = {
                                    {   type = "dropdown";
                                        name = L["Bar Texture"];
                                        options = tk.Constants.LSM:List("statusbar");
                                        appendDbPath = "statusBars.barTexture";
                                    };
                                    {   type = "textfield";
                                        name = "Bar Width";
                                        appendDbPath = "statusBars.width";
                                        valueType = "number";
                                        min = 100;
                                        max = 400;
                                    };
                                    {   type = "textfield";
                                        name = "Bar Height";
                                        appendDbPath = "statusBars.height";
                                        valueType = "number";
                                        min = 10;
                                        max = 80;
                                    };
                                    {   name = "Spacing",
                                        type = "slider",
                                        appendDbPath = "statusBars.spacing",
                                        min = 0,
                                        max = 50;
                                    },
                                    {   type = "slider";
                                        name = "Icon Gap";
                                        appendDbPath = "statusBars.iconGap";
                                        min = 0;
                                        max = 10;
                                    };
                                    {   name = "Growth Direction",
                                        type = "dropdown",
                                        appendDbPath = "statusBars.growDirection",
                                        options = { Up = "UP", Down = "DOWN" }
                                    };
                                    {   name = "Show Spark",
                                        type = "check",
                                        appendDbPath = "statusBars.showSpark",
                                    };
                                };
                            };
                            {   type = "title";
                                name = "Text";
                            };
                            {   type = "loop";
                                args = { "Time Remaining", "Count", "Aura Name" },
                                func = function(_, textName)
                                    local sections = obj:PopTable(string.split(" ", textName));
                                    sections[1] = sections[1]:lower();

                                    local key = table.concat(sections, "");
                                    obj:PushTable(sections);

                                    local xOffsetDbPath = string.format("textPosition.%s[1]", key);
                                    local yOffsetDbPath = string.format("textPosition.%s[2]", key);
                                    local textSizeDbPath = string.format("textSize.%s", key);

                                    if (statusBarsEnabled) then
                                        xOffsetDbPath = string.format("textPosition.statusBars.%s[1]", key);
                                        yOffsetDbPath = string.format("textPosition.statusBars.%s[2]", key);
                                        textSizeDbPath = string.format("textSize.statusBars.%s", key);
                                    elseif (textName == "Aura Name") then
                                        return;
                                    end

                                    return {
                                        {   type = "fontstring";
                                            subtype = "header";
                                            content = textName;
                                        };
                                        {   type = "textfield";
                                            name = "X-Offset";
                                            appendDbPath = xOffsetDbPath;
                                            valueType = "number";
                                        };
                                        {   type = "textfield";
                                            name = "Y-Offset";
                                            appendDbPath = yOffsetDbPath;
                                            valueType = "number";
                                        };
                                        {   type = "slider";
                                            name = "Font Size";
                                            appendDbPath = textSizeDbPath;
                                            min = 8;
                                            max = 24;
                                        };
                                    }
                                end;
                            };
                            {   type = "title";
                                name = "Border";
                            };
                            {   type = "dropdown";
                                name = "Border Type";
                                options = tk.Constants.LSM:List("border");
                                appendDbPath = "border.type";
                            };
                            {   type = "slider";
                                name = "Border Size";
                                appendDbPath = "border.size";
                                min = 1;
                                max = 10;
                            };
                            {   type = "title";
                                name = "Colors";
                            };
                            {   name = "Basic " .. name;
                                type = "color";
                                width = 200;
                                useIndexes = true;
                                appendDbPath = "colors.aura";
                            },
                            {   type = "condition";
                                func = function()
                                    return name == "Buffs";
                                end;
                                onTrue = {
                                    {
                                        name = "Weapon Enchants",
                                        type = "color",
                                        width = 200;
                                        useIndexes = true;
                                        appendDbPath = "colors.enchant"
                                    }
                                };
                                onFalse = {
                                    {   name = "Magic Debuff";
                                        type = "color";
                                        width = 200;
                                        useIndexes = true;
                                        appendDbPath = "colors.magic";
                                    };
                                    {   name = "Disease Debuff";
                                        type = "color";
                                        width = 200;
                                        useIndexes = true;
                                        appendDbPath = "colors.disease";
                                    };
                                    {   name = "Poison Debuff";
                                        type = "color";
                                        width = 200;
                                        useIndexes = true;
                                        appendDbPath = "colors.poison";
                                    };
                                    {   name = "Curse Debuff";
                                        type = "color";
                                        width = 200;
                                        useIndexes = true;
                                        appendDbPath = "colors.curse";
                                    };
                                }
                            };
                            {   type = "condition";
                                func = function()
                                    return statusBarsEnabled;
                                end;
                                onTrue = {
                                    {   name = "Bar Background";
                                        type = "color";
                                        width = 200;
                                        useIndexes = true;
                                        hasOpacity = true;
                                        appendDbPath = "colors.statusBarBackground";
                                    };
                                    {   name = "Bar Border";
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