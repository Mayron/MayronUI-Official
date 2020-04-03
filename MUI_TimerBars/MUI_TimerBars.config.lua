-- luacheck: ignore MayronUI self 143 631

local tk, _, _, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local db = MayronUI:GetModuleComponent("TimerBarsModule", "Database");
local C_TimerBarsModule = MayronUI:GetModuleClass("TimerBarsModule");

local _G, MayronUI = _G, _G.MayronUI;
local pairs, tonumber, table, string = _G.pairs, _G.tonumber, _G.table, _G.string;

-- contains field name / table pairs where each table holds the 5 config textfield widgets
-- this is used to update the config menu view after moving the fields (by unlocking them)
local position_TextFields = {};
local savePositionButtons = {};
local ShowListFrame;

local function CreateNewFieldButton_OnClick(editBox)
    local text = editBox:GetText();
    local tbl = db.profile.fieldNames:GetUntrackedTable();

    db:SetPathValue(db.profile, "fieldNames["..(#tbl + 1).."]", text);
    db:SetPathValue(db.profile, "fields."..text, obj:PopTable());

    tk:Print(string.format(L["TimerBar field '%s' created."], text));
    MayronUI:ImportModule("ConfigModule"):ShowReloadMessage();
end

local function RemoveFieldButton_OnClick(editBox)
    local text = editBox:GetText();
    local tbl = db.profile.fieldNames:GetUntrackedTable();
    local id = tk.Tables:GetIndex(tbl, text);

    if (id) then
        db:SetPathValue(db.profile, "fieldNames["..id.."]", nil);
        db:SetPathValue(db.profile, "fields."..text, nil);
        MayronUI:ImportModule("ConfigModule"):ShowReloadMessage();
    else
        tk:Print(string.format(L["TimerBar field '%s' does not exist."], text));
    end
end

local function ListFrame_OnAddItem(_, item, dbPath)
    local fullPath = string.format("%s.%s", dbPath, item.name:GetText());
    db:SetPathValue(fullPath, true);
end

local function ListFrame_OnRemoveItem(_, item, dbPath)
    local fullPath = string.format("%s.%s", dbPath, item.name:GetText());
    db:SetPathValue(fullPath, nil);
end

do
    local function compare(a, b)
        return a < b;
    end

    ---@param self ListFrame
    ---@param dbPath string
    local function ListFrame_OnShow(self, dbPath)
        local auraNames = db:ParsePathValue(dbPath);

        if (not obj:IsTable(auraNames)) then
            return;
        end

        auraNames = auraNames:GetUntrackedTable();
        table.sort(auraNames, compare);

        for auraName, _ in pairs(auraNames) do
            self:AddItem(auraName);
        end
    end

    function ShowListFrame(btn)
        if (btn.listFrame) then
            btn.listFrame:SetShown(true);
            return;
        end

        ---@type ListFrame
        local C_ListFrame = obj:Import("MayronUI.Engine.ConfigTools.ListFrame");

        btn.listFrame = C_ListFrame(btn.name, btn.dbPath);

        if (btn.dbPath:find("white")) then
            btn.listFrame:AddRowText("Enter an aura name to add to the whitelist:");
        else
            btn.listFrame:AddRowText("Enter an aura name to add to the blacklist:");
        end

        btn.listFrame:SetScript("OnAddItem", ListFrame_OnAddItem);
        btn.listFrame:SetScript("OnRemoveItem", ListFrame_OnRemoveItem);
        btn.listFrame:SetScript("OnItemEnter", tk.AuraTooltip_OnEnter);
        btn.listFrame:SetScript("OnShow", ListFrame_OnShow);
        btn.listFrame:SetShown(true);
    end
end

local function TimerFieldPosition_OnLoad(configTable, container)
    local positionIndex = configTable.dbPath:match("%[(%d)%]$");
    position_TextFields[configTable.fieldName][tonumber(positionIndex)] = container.widget;
end

local function Field_OnDragStop(field)
    local positions = tk.Tables:GetFramePosition(field);
    local fieldName = field:GetName():match("MUI_(.*)TimerField");

    if (positions) then
        -- update the config menu view
        for id, textField in ipairs(position_TextFields[fieldName]) do
            textField:SetText(positions[id]);
        end
    end

    savePositionButtons[fieldName]:SetEnabled(true);
end

function C_TimerBarsModule:GetConfigTable()
    return {
        {   name              = "Timer Bars";
            module            = "TimerBarsModule";
            hasOwnDatabase    = true;
            children = {
                {   name        = L["General Options"];
                    type        = "title";
                    marginTop   = 0;
                };
                {   name    = L["Sort By Time Remaining"];
                    type    = "check";
                    width   = 220;
                    dbPath  = "profile.sortByExpirationTime";
                };
                {   name    = L["Show Tooltips On Mouseover"];
                    type    = "check";
                    width   = 230;
                    dbPath  = "profile.showTooltips";
                };
                {   type = "divider";
                };
                {   name    = L["Bar Texture"];
                    type    = "dropdown";
                    dbPath  = "profile.statusBarTexture";
                    options = tk.Constants.LSM:List("statusbar");
                };
                {   type = "divider";
                };
                {   name    = "Show Borders";
                    type    = "check";
                    height = 55;
                    dbPath  = "profile.border.show";
                };
                {   name    = "Border Type";
                    type    = "dropdown";
                    dbPath  = "profile.border.type";
                    options = tk.Constants.LSM:List("border");
                };
                {   name    = "Border Size";
                    type    = "slider";
                    dbPath  = "profile.border.size";
                    min = 1;
                    max = 20;
                    step = 1;
                };
                {   type = "divider";
                };
                {   name = L["Create New Field"];
                    type = "button";
                    OnClick = function()
                        tk:ShowInputPopup("Create New TimerBar Field", "(requires reloading the UI to apply change)",
                            "New Field Name", nil, nil, CreateNewFieldButton_OnClick);
                    end
                };
                {   name = L["Remove Field"];
                    type = "button";
                    OnClick = function()
                        tk:ShowInputPopup("Remove TimerBar Field", "(requires reloading the UI to apply change)",
                            "Field Name", nil, nil, RemoveFieldButton_OnClick);
                    end
                };
                {   name = "Colors";
                    type = "title";
                };
                {   name = L["Background Color"];
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    hasOpacity = true;
                    dbPath = "profile.colors.background";
                };
                {   name = L["Buff Bar Color"];
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    hasOpacity = true;
                    dbPath = "profile.colors.basicBuff";
                };
                {   name = L["Debuff Bar Color"];
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    hasOpacity = true;
                    dbPath = "profile.colors.basicDebuff";
                };
                {   name = "Border Color";
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    hasOpacity = true;
                    dbPath = "profile.colors.border";
                };
                {   name = "Can Steal or Purge Color";
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    hasOpacity = true;
                    tooltip = "If an aura can be stolen or purged, show a different color";
                    dbPath = "profile.colors.canStealOrPurge";
                };
                {   name = "Magic Debuff Color";
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    hasOpacity = true;
                    dbPath = "profile.colors.magic";
                };
                {   name = "Disease Debuff Color";
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    hasOpacity = true;
                    dbPath = "profile.colors.disease";
                };
                {   name = "Poison Debuff Color";
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    hasOpacity = true;
                    dbPath = "profile.colors.poison";
                };
                {   name = "Curse Debuff Color";
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    hasOpacity = true;
                    dbPath = "profile.colors.curse";
                };
                {   name = L["Existing Timer Bar Fields"];
                    type = "title";
                };
                {   type = "loop";
                    args = db.profile.fieldNames:GetUntrackedTable();
                    func = function(_, name)
                        local dbFieldPath = "profile.fields."..name;

                        return {
                            name              = name;
                            type              = "submenu";
                            module            = "TimerBarsModule";
                            hasOwnDatabase    = true;

                            OnLoad = function()
                                position_TextFields[name] = obj:PopTable();
                            end;

                            children = {
                                {   name    = L["Enable Field"];
                                    type    = "check";
                                    dbPath  = dbFieldPath .. ".enabled";
                                };
                                {   name = L["Unlock"];
                                    type = "button";
                                    OnClick = function(button)
                                        local field = _G["MUI_"..name.."TimerField"];

                                        if (not (field and field:IsShown())) then
                                            return;
                                        end

                                        button.toggle = not button.toggle;
                                        tk:MakeMovable(field, nil, button.toggle, nil, Field_OnDragStop);

                                        if (button.toggle) then
                                            if (not field.moveIndicator) then
                                                local r, g, b = tk:GetThemeColor();
                                                field.moveIndicator = tk:SetBackground(field, r, g, b);
                                                field.moveLabel = field:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
                                                field.moveLabel:SetText(string.format(L["<%s Field>"], name));
                                                field.moveLabel:SetPoint("CENTER");
                                            end

                                            field.moveIndicator:SetAlpha(0.4);
                                            field.moveLabel:SetAlpha(0.8);
                                            button:SetText(L["Lock"]);

                                        elseif (field.moveIndicator) then
                                            field.moveIndicator:SetAlpha(0);
                                            field.moveLabel:SetAlpha(0);
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
                                        local field = _G["MUI_"..name.."TimerField"];

                                        if (not (field and field:IsShown())) then
                                            return;
                                        end

                                        local positions = tk.Tables:GetFramePosition(field);
                                        db:SetPathValue(dbFieldPath .. ".position", positions);

                                        Field_OnDragStop(field);
                                        savePositionButtons[name]:SetEnabled(false);
                                    end
                                };
                                {   type = "divider";
                                };
                                {   name = L["Unit to Track"];
                                    type = "dropdown";
                                    tooltip = L["The unit who is affected by the spell."];
                                    dbPath = dbFieldPath .. ".unitID";
                                    options = {
                                        [L["Player"]] = "Player";
                                        [L["Target"]] = "Target";
                                        [L["TargetTarget"]] = "TargetTarget";
                                        [L["Focus"]] = "Focus";
                                        [L["FocusTarget"]] = "FocusTarget"
                                    };
                                };
                                {   type = "divider"
                                };
                                {   name = L["Appearance Options"];
                                    type = "title"
                                };
                                {   content = L["The field's vertical growth direction:"];
                                    type = "fontstring";
                                };
                                {   name = L["Up"];
                                    dbPath = dbFieldPath .. ".direction";
                                    type = "radio";
                                    groupName = "TimerBars_Growth_"..name;

                                    GetValue = function(_, value)
                                        return value == "UP";
                                    end;

                                    SetValue = function(dbPath)
                                        db:SetPathValue(dbPath, "UP");
                                    end;
                                };
                                {   name = L["Down"];
                                    dbPath = dbFieldPath .. ".direction";
                                    type = "radio";
                                    groupName = "TimerBars_Growth_"..name;

                                    GetValue = function(_, value)
                                        return value == "DOWN";
                                    end;

                                    SetValue = function(dbPath)
                                        db:SetPathValue(dbPath, "DOWN");
                                    end;
                                };
                                {   type = "divider"
                                };
                                {   name = L["Bar Width"];
                                    type = "slider";
                                    dbPath = dbFieldPath .. ".bar.width";
                                    tooltip = tk.Strings:Concat(L["Default value is "], "213");
                                    step = 1;
                                    min = 100;
                                    max = 400;
                                };
                                {   name = L["Bar Height"];
                                    type = "slider";
                                    dbPath = dbFieldPath .. ".bar.height";
                                    tooltip = tk.Strings:Concat(L["Default value is "], "22");
                                    step = 1;
                                    min = 5;
                                    max = 50;
                                };
                                {   name = L["Bar Spacing"];
                                    type = "slider";
                                    dbPath = dbFieldPath .. ".bar.spacing";
                                    tooltip = tk.Strings:Concat(L["Default value is "], "2");
                                    step = 1;
                                    min = 0;
                                    max = 10;
                                };
                                {   type = "divider"
                                };
                                {   name = L["Show Icons"];
                                    type = "check";
                                    dbPath = dbFieldPath .. ".showIcons";
                                };
                                {   name = L["Show Spark"];
                                    type = "check";
                                    dbPath = dbFieldPath .. ".showSpark";
                                };
                                {   type = "divider"
                                };
                                {   type = "fontstring";
                                    subtype = "header";
                                    content = L["Manual Positioning"]
                                };
                                {   type = "loop";
                                    args = { L["Point"], L["Relative Frame"], L["Relative Point"], L["X-Offset"], L["Y-Offset"] };
                                    func = function(index, arg)
                                        return {
                                            name = arg;
                                            type = "textfield";
                                            valueType = "string";
                                            dbPath = tk.Strings:Concat(dbFieldPath, ".position[", index, "]");
                                            fieldName = name;
                                            OnLoad = TimerFieldPosition_OnLoad;
                                        };
                                    end
                                };
                                {   name = L["Text Options"];
                                    type = "title";
                                };
                                {   content = L["Time Remaining Text"];
                                    type = "fontstring";
                                    subtype = "header";
                                };
                                {   name = L["Show"];
                                    type = "check";
                                    height = 50;
                                    dbPath = dbFieldPath .. ".timeRemaining.show";
                                };
                                {   name = L["Font Size"];
                                    type = "slider";
                                    tooltip = L["Default is 11"];
                                    step = 1;
                                    min = 8;
                                    max = 22;
                                    dbPath = dbFieldPath .. ".timeRemaining.fontSize";
                                };
                                {   name = L["Font Type"];
                                    type = "dropdown";
                                    dbPath = dbFieldPath .. ".timeRemaining.font";
                                    fontPicker = true;
                                    options = tk.Constants.LSM:List("font");
                                };
                                {   content = L["Spell Name Text"];
                                    type = "fontstring";
                                    subtype = "header";
                                };
                                {   name = L["Show"];
                                    type = "check";
                                    height = 50;
                                    dbPath = dbFieldPath .. ".auraName.show";
                                };
                                {   name = L["Font Size"];
                                    type = "slider";
                                    tooltip = L["Default is 11"];
                                    step = 1;
                                    min = 8;
                                    max = 22;
                                    dbPath = dbFieldPath .. ".auraName.fontSize";
                                };
                                {   name = L["Font Type"];
                                    type = "dropdown";
                                    dbPath = dbFieldPath .. ".auraName.font";
                                    fontPicker = true;
                                    options = tk.Constants.LSM:List("font");
                                };
                                {   name = L["Filters"];
                                    type = "title";
                                };
                                {   name = L["Only show buffs applied by me"];
                                    dbPath = dbFieldPath .. ".filters.onlyPlayerBuffs";
                                    type = "check";
                                };
                                {   name = L["Only show debuffs applied by me"];
                                    dbPath = dbFieldPath .. ".filters.onlyPlayerDebuffs";
                                    type = "check";
                                };
                                {   type = "divider";
                                };
                                {   name = L["Enable Whitelist"];
                                    dbPath = dbFieldPath .. ".filters.enableWhiteList";
                                    type = "check";
                                };
                                {   name = L["Configure Whitelist"];
                                    type = "button";
                                    dbPath = dbFieldPath .. ".filters.whiteList";
                                    OnClick = ShowListFrame;
                                };
                                {   type = "divider";
                                };
                                {   name = L["Enable Blacklist"];
                                    dbPath = dbFieldPath .. ".filters.enableBlackList";
                                    type = "check";
                                };
                                {   name = L["Configure Blacklist"];
                                    type = "button";
                                    dbPath = dbFieldPath .. ".filters.blackList";
                                    OnClick = ShowListFrame;
                                };
                            };
                        };
                    end;
                };
            }
        }
    };
end