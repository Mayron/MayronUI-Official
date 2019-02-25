-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local _G, MayronUI = _G, _G.MayronUI;
local tk, db, _, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local C_TimerBarsModule = namespace.C_TimerBarsModule;
local pairs, tonumber, table = _G.pairs, _G.tonumber, _G.table;

---@type ListFrame
local C_ListFrame = obj:Import("MayronUI.Engine.ConfigTools.ListFrame");

-- contains field name / table pairs where each table holds the 5 config textfield widgets
-- this is used to update the config menu view after moving the fields (by unlocking them)
local position_TextFields = {};
local ShowListFrame;

local function CreateNewFieldButton_OnClick(editBox)
    local text = editBox:GetText();
    local tbl = db.profile.timerBars.fieldNames:GetUntrackedTable();

    db:SetPathValue(db.profile, "timerBars.fieldNames["..(#tbl + 1).."]", text);
    db:SetPathValue(db.profile, "timerBars."..text, obj:PopTable());

    tk:Print(tk.string.format(L["TimerBar field '%s' created."], text));
    MayronUI:ImportModule("ConfigModule"):ShowReloadMessage();
end

local function RemoveFieldButton_OnClick(editBox)
    local text = editBox:GetText();
    local tbl = db.profile.timerBars.fieldNames:GetUntrackedTable();
    local id = tk.Tables:GetIndex(tbl, text);

    if (id) then
        db:SetPathValue(db.profile, "timerBars.fieldNames["..id.."]", nil);
        db:SetPathValue(db.profile, "timerBars."..text, nil);
        MayronUI:ImportModule("ConfigModule"):ShowReloadMessage();
    else
        tk:Print(tk.string.format(L["TimerBar field '%s' does not exist."], text));
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

function C_TimerBarsModule:GetConfigTable()
    return {
        {   name    = "Timer Bars";
            module  = "TimerBarsModule";
            children = {
                {   name        = L["General Options"];
                    type        = "title";
                    marginTop   = 0;
                };
                {   name    = L["Sort By Time Remaining"];
                    type    = "check";
                    width   = 220;
                    dbPath  = "profile.timerBars.sortByExpirationTime";
                };
                {   name    = L["Show Tooltips On Mouseover"];
                    type    = "check";
                    width   = 230;
                    dbPath  = "profile.timerBars.showTooltips";
                };
                {   type = "divider";
                };
                {   name    = L["Bar Texture"];
                    type    = "dropdown";
                    dbPath  = "profile.timerBars.statusBarTexture";
                    options = tk.Constants.LSM:List("statusbar");
                };
                {   type = "divider";
                };
                {   name    = "Show Borders";
                    type    = "check";
                    height = 55;
                    dbPath  = "profile.timerBars.border.show";
                };
                {   name    = "Border Type";
                    type    = "dropdown";
                    dbPath  = "profile.timerBars.border.type";
                    options = tk.Constants.LSM:List("border");
                };
                {   name    = "Border Size";
                    type    = "slider";
                    dbPath  = "profile.timerBars.border.size";
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
                    dbPath = "profile.timerBars.colors.background";
                };
                {   name = L["Buff Bar Color"];
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    dbPath = "profile.timerBars.colors.basicBuff";
                };
                {   name = L["Debuff Bar Color"];
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    dbPath = "profile.timerBars.colors.basicDebuff";
                };
                {   name = "Border Color";
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    dbPath = "profile.timerBars.colors.border";
                };
                {   name = "Can Steal or Purge Color";
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    tooltip = "If an aura can be stolen or purged, show a different color";
                    dbPath = "profile.timerBars.colors.canStealOrPurge";
                };
                {   name = "Magic Debuff Color";
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    dbPath = "profile.timerBars.colors.magic";
                };
                {   name = "Disease Debuff Color";
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    dbPath = "profile.timerBars.colors.disease";
                };
                {   name = "Poison Debuff Color";
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    dbPath = "profile.timerBars.colors.poison";
                };
                {   name = "Curse Debuff Color";
                    type = "color";
                    width = 220;
                    useIndexes = true;
                    dbPath = "profile.timerBars.colors.curse";
                };
                {   name = L["Existing Timer Bar Fields"];
                    type = "title";
                };
                {   type = "loop";
                    args = db.profile.timerBars.fieldNames:GetUntrackedTable();
                    func = function(_, name)
                        return {
                            name = name;
                            type = "submenu";
                            OnLoad = function()
                                position_TextFields[name] = obj:PopTable();
                            end;
                            module = "TimerBarsModule";
                            children = {
                                {   name = L["Enable Field"];
                                    type = "check";
                                    dbPath = "profile.timerBars."..name..".enabled";
                                };
                                {   name = L["Unlock"];
                                    type = "button";
                                    OnClick = function(button)
                                        button.toggle = not button.toggle;
                                        local field = _G["MUI_"..name.."TimerField"];

                                        tk:MakeMovable(field, nil, button.toggle);

                                        if (button.toggle) then
                                            if (not field.moveIndicator) then
                                                local r, g, b = tk:GetThemeColor();
                                                field.moveIndicator = tk:SetBackground(field, r, g, b);
                                                field.moveLabel = field:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
                                                field.moveLabel:SetText(tk.string.format(L["<%s Field>"], name));
                                                field.moveLabel:SetPoint("CENTER");
                                            end

                                            field.moveIndicator:SetAlpha(0.4);
                                            field.moveLabel:SetAlpha(0.8);
                                            button:SetText(L["Lock"]);

                                        elseif (field.moveIndicator) then
                                            field.moveIndicator:SetAlpha(0);
                                            field.moveLabel:SetAlpha(0);
                                            button:SetText("Unlock");

                                            local positions = tk:SavePosition(field, "profile.timerBars."..name..".position");

                                            if (positions) then
                                                -- update the config menu view
                                                for id, textField in ipairs(position_TextFields[name]) do
                                                    textField:SetText(positions[id]);
                                                end
                                            end
                                        end
                                    end
                                };
                                {   type = "divider";
                                };
                                {   name = L["Unit to Track"];
                                    type = "dropdown";
                                    tooltip = L["The unit who is affected by the spell."];
                                    dbPath = "profile.timerBars."..name..".unitID";
                                    options = {
                                        L["Player"];
                                        L["Target"];
                                        L["TargetTarget"];
                                        L["Focus"];
                                        L["FocusTarget"]
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
                                    dbPath = "profile.timerBars."..name..".direction";
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
                                    dbPath = "profile.timerBars."..name..".direction";
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
                                    dbPath = "profile.timerBars."..name..".bar.width";
                                    step = 1;
                                    min = 100;
                                    max = 400;
                                };
                                {   name = L["Bar Height"];
                                    type = "slider";
                                    dbPath = "profile.timerBars."..name..".bar.height";
                                    step = 1;
                                    min = 5;
                                    max = 50;
                                };
                                {   name = L["Bar Spacing"];
                                    type = "slider";
                                    dbPath = "profile.timerBars."..name..".bar.spacing";
                                    step = 1;
                                    min = 0;
                                    max = 10;
                                };
                                {   type = "divider"
                                };
                                {   name = L["Show Icons"];
                                    type = "check";
                                    dbPath = "profile.timerBars."..name..".showIcons";
                                };
                                {   name = L["Show Spark"];
                                    type = "check";
                                    dbPath = "profile.timerBars."..name..".showSpark";
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
                                            dbPath = string.format("profile.timerBars.%s.position[%d]", name, index);
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
                                    dbPath = "profile.timerBars."..name..".timeRemaining.show";
                                };
                                {   name = L["Font Size"];
                                    type = "slider";
                                    tooltip = L["Default is 11"];
                                    step = 1;
                                    min = 8;
                                    max = 22;
                                    dbPath = "profile.timerBars."..name..".timeRemaining.fontSize";
                                };
                                {   name = L["Font Type"];
                                    type = "dropdown";
                                    dbPath = "profile.timerBars."..name..".timeRemaining.font";
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
                                    dbPath = "profile.timerBars."..name..".auraName.show";
                                };
                                {   name = L["Font Size"];
                                    type = "slider";
                                    tooltip = L["Default is 11"];
                                    step = 1;
                                    min = 8;
                                    max = 22;
                                    dbPath = "profile.timerBars."..name..".auraName.fontSize";
                                };
                                {   name = L["Font Type"];
                                    type = "dropdown";
                                    dbPath = "profile.timerBars."..name..".auraName.font";
                                    fontPicker = true;
                                    options = tk.Constants.LSM:List("font");
                                };
                                {   name = "Filters";
                                    type = "title";
                                };
                                {   name = "Only show buffs applied by me";
                                    dbPath = "profile.timerBars."..name..".filters.onlyPlayerBuffs";
                                    type = "check";
                                };
                                {   name = "Only show debuffs applied by me";
                                    dbPath = "profile.timerBars."..name..".filters.onlyPlayerDebuffs";
                                    type = "check";
                                };
                                {   type = "divider";
                                };
                                {   name = "Enable White List";
                                    dbPath = "profile.timerBars."..name..".filters.enableWhiteList";
                                    type = "check";
                                };
                                {   name = "Configure White List";
                                    type = "button";
                                    dbPath = "profile.timerBars."..name..".filters.whiteList";
                                    OnClick = ShowListFrame;
                                };
                                {   type = "divider";
                                };
                                {   name = "Enable Black List";
                                    dbPath = "profile.timerBars."..name..".filters.enableBlackList";
                                    type = "check";
                                };
                                {   name = "Configure Black List";
                                    type = "button";
                                    dbPath = "profile.timerBars."..name..".filters.blackList";
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