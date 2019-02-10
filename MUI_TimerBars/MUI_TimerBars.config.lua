-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db, _, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local C_TimerBarsModule = namespace.C_TimerBarsModule;

-- contains field name / table pairs where each table holds the 5 config textfield widgets
-- this is used to update the config menu view after moving the fields (by unlocking them)
local position_TextFields = {};

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
                    dbPath  = "profile.timerBars.sortByTimeRemaining";
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
                    dbPath = "profile.timerBars.colors.background";
                };
                {   name = L["Buff Bar Color"];
                    type = "color";
                    width = 220;
                    dbPath = "profile.timerBars.colors.basicBuff";
                };
                {   name = L["Debuff Bar Color"];
                    type = "color";
                    width = 220;
                    dbPath = "profile.timerBars.colors.basicDebuff";
                };
                {   name = "Border Color";
                    type = "color";
                    width = 220;
                    dbPath = "profile.timerBars.colors.border";
                };
                {   name = "Can Steal or Purge Color";
                    type = "color";
                    width = 220;
                    tooltip = "If an aura can be stolen or purged, show a different color";
                    dbPath = "profile.timerBars.colors.canStealOrPurge";
                };
                {   name = "Magic Debuff Color";
                    type = "color";
                    width = 220;
                    dbPath = "profile.timerBars.colors.magic";
                };
                {   name = "Disease Debuff Color";
                    type = "color";
                    width = 220;
                    dbPath = "profile.timerBars.colors.disease";
                };
                {   name = "Poison Debuff Color";
                    type = "color";
                    width = 220;
                    dbPath = "profile.timerBars.colors.poison";
                };
                {   name = "Curse Debuff Color";
                    type = "color";
                    width = 220;
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
                                {   name = L["Manage Tracking Buffs"];
                                    type = "button";
                                    data = { name, "buffs" };
                                    width = 220;
                                    -- OnClick = CreateListFrame;
                                };
                                {   name = L["Manage Tracking Debuffs"];
                                    type = "button";
                                    data = { name, "debuffs" };
                                    width = 220;
                                    -- OnClick = CreateListFrame;
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
                                    group = 1;
                                };
                                {   name = L["Down"];
                                    dbPath = "profile.timerBars."..name..".direction";
                                    type = "radio";
                                    group = 1;
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
                                {
                                    type = "loop";
                                    loops = 5;
                                    func = function(index)
                                        return {
                                            name = L["Point"];
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
                                {   name = "Show only Player Buffs";
                                    dbPath = "profile.timerBars."..name..".filters.onlyPlayerBuffs";
                                    type = "check";
                                };
                                {   name = "Show only Player Debuffs";
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
                                };
                                {   type = "divider";
                                };
                                {   name = "Enable Black List";
                                    dbPath = "profile.timerBars."..name..".filters.enableBlackList";
                                    type = "check";
                                };
                                {   name = "Configure Black List";
                                    type = "button";
                                };
                            };
                        };
                    end;
                };
            }
        }
    };
end

----------------
-- ListFrame
----------------
-- local ListFrame = tk:CreateProtectedPrototype("ListFrame"; true);

-- function ListFrame:Update(data)
--     if (not data.items) then return; end

--     for _; item in tk.ipairs(data.items) do
--         item:ClearAllPoints();
--         item:Hide();
--     end

--     local height = 0;

--     for id; item in tk.ipairs(data.items) do

--         if (id == 1) then
--             item:SetPoint("TOPLEFT");
--             item:SetPoint("TOPRIGHT"; 0; -30);
--             height = height + 30;
--         else
--             item:SetPoint("TOPLEFT"; data.items[id - 1]; "BOTTOMLEFT"; 0; -2);
--             item:SetPoint("TOPRIGHT"; data.items[id - 1]; "BOTTOMRIGHT"; 0; -32);
--             height = height + 32;
--         end
--         if (id % 2 ~= 0) then
--             tk:SetThemeColor(0.1; item.normal);
--         else
--             tk:SetThemeColor(0; item.normal);
--         end
--         data.frame:SetHeight(height);
--         item:Show();
--     end
-- end

-- do
--     local function Item_OnEnter(self)
--         if (self.spellID and tk.type(self.spellID) == "number") then
--             GameTooltip:SetOwner(self; "ANCHOR_TOPRIGHT"; 0; 2);
--             GameTooltip:SetSpellByID(self.spellID);
--             GameTooltip:Show();
--         end
--     end

--     local function Item_OnLeave(self)
--         GameTooltip:Hide()
--     end

--     function ListFrame:AddItem(data; name; spellID)
--         if (data.tracking[name]) then return; end
--         data.items = data.items or {};

--         data.btn_OnMouseUp = data.btn_OnMouseUp or function(btn)
--             local item = btn:GetParent();
--             self:RemoveItem(item; item.name:GetText());
--         end

--         local item = data.unused and data.unused:Pop();
--         if (not item) then
--             item = tk.CreateFrame("Button"; nil; data.frame);
--             item:SetScript("OnEnter"; Item_OnEnter);
--             item:SetScript("OnLeave"; Item_OnLeave);
--             item:SetSize(30; 30);
--             item.normal = tk:SetBackground(item; 0; 0; 0; 0);
--             item.highlight = tk:SetBackground(item; 1; 1; 1; 0.1);
--             item:SetNormalTexture(item.normal);
--             item:SetHighlightTexture(item.highlight);
--             item.name = item:CreateFontString(nil; "BACKGROUND"; "GameFontHighlight");
--             item.name:SetJustifyH("LEFT");
--             item.name:SetJustifyV("CENTER");
--             item.name:SetPoint("TOPLEFT"; 6; 0);
--             item.name:SetPoint("BOTTOMRIGHT"; -34; 0);
--             item.btn = tk.CreateFrame("Button"; nil; item);
--             item.btn:SetSize(28; 24);
--             item.btn:SetPoint("RIGHT"; -8; 0);
--             item.btn:SetNormalTexture(tk.Constants.MEDIA.."dialog_box\\CloseButton"; "BLEND");
--             item.btn:SetHighlightTexture(tk.Constants.MEDIA.."dialog_box\\CloseButton"; "ADD");
--             tk:SetThemeColor(item.btn);
--         end
--         table.insert(data.items; item);
--         data.tracking[name] = true;
--         item.spellID = spellID;
--         item.name:SetText(name);
--         item.btn:SetScript("OnMouseUp"; data.btn_OnMouseUp);
--     end
-- end

-- function ListFrame:RemoveItem(data; item; name)
--     local index = tk:GetIndex(data.items; item);
--     table.remove(data.items; index);
--     data.tracking[name] = nil;
--     data.unused = data.unused or tk:CreateStack();
--     data.unused:Push(item);
--     item:Hide();
--     item:ClearAllPoints();
--     db.profile.timerBars[data.name][data.type][name] = nil;
--     TimerBars:RefreshFields();
--     self:Update();
-- end

-- do
--     local function compare(a; b) return a < b; end
--     local names = {};

--     function ListFrame:ScanForItems(data)
--         local items = db.profile.timerBars[data.name][data.type];

--         if (items) then
--             items = items:GetTable();
--             tk:EmptyTable(names);
--             names = tk:GetKeyTable(items; names);
--             table.sort(names; compare);

--             for _; name in tk.pairs(names) do
--                 self:AddItem(name; items[name]);
--             end

--             self:Update();
--         end
--     end
-- end

-- local function CreateListFrame(_; self)
--     local name = self.data[1]; -- "Player"
--     local type = self.data[2]; -- "buffs" or "debuffs"
--     local manager = tk.string.format("%s%s%s"; name; (type):gsub("^%l"; tk.string.upper); "Manager");

--     if (not TimerBars[manager]) then
--         TimerBars[manager] = gui:CreateDialogBox(nil; "HIGH");
--         local panel = TimerBars[manager];

--         gui:AddTitleBar(panel; self.name);
--         gui:AddCloseButton(panel);
--         panel:SetSize(400; 300);
--         panel:SetPoint("CENTER");
--         panel:SetFrameStrata("DIALOG");
--         panel:SetFrameLevel(20);
--         panel = gui:CreatePanel(panel);
--         --self.listFrame:SetDevMode(true);
--         panel:SetDimensions(1; 4);

--         local row1 = panel:CreateCell();
--         row1.label = row1:CreateFontString(nil; "BACKGROUND"; "GameFontHighlight");
--         row1.label:SetText(tk.string.format(L["Enter the Name of a %s to Track:"]; (type == "buffs" and "Buff" or "Debuff")));
--         row1.label:SetPoint("LEFT");
--         row1:SetInsets(22; 5; 0; 5);

--         local row2 = panel:CreateCell();
--         row2.cb1 = gui:CreateCheckButton(row2:GetFrame();
--             tk.string.format(L["Only track your %s"]; type); nil;
-- 			tk.string.format(L["Only %s casted by you will be tracked."]; type));

--         row2.cb1:SetPoint("LEFT");
--         row2.cb1.btn:SetChecked(db.profile.timerBars[name]["only_player_"..type]);

--         row2.cb1.btn:SetScript("OnClick"; function(self)
--             db.profile.timerBars[name]["only_player_"..type] = self:GetChecked();
--             TimerBars:RefreshFields();
--         end);

--         row2.cb2 = gui:CreateCheckButton(row2:GetFrame();
--             tk.string.format(L["Track all %s"]; type); nil;
--             tk.string.format(L["Ignore the list of %s to track and track everything."]; type).."\n\n"..
-- 			tk.string.format(L["Enabling this will dynamically generate the list of %s to track."]; type));

--         row2.cb2:SetPoint("LEFT"; row2.cb1; "RIGHT"; 5; 0);
--         row2.cb2.btn:SetChecked(db.profile.timerBars[name]["track_all_"..type]);

--         row2.cb2.btn:SetScript("OnClick"; function(self)
--             db.profile.timerBars[name]["track_all_"..type] = self:GetChecked();
--             TimerBars:RefreshFields();
--         end);

--         local row3 = gui:CreateTextField();
--         row3.field:SetScript("OnEnterPressed"; function(field)
--             field:ClearFocus();

--             local value = field:GetText();
--             local spellID = tk.select(7; GetSpellInfo(value));

--             TimerBars[manager].list:AddItem(value; spellID);

--             local tbl = db.profile.timerBars[name];

--             if (not tbl[type]) then
--                 tbl[type] = {};
--             end

--             tbl[type][value] = spellID or true;
--             field:SetText("");
--             TimerBars:RefreshFields();
--             TimerBars[manager].list:Update();
--         end);

--         row3 = panel:CreateCell(row3);
--         row3:SetInsets(5);

--         local row4; child = gui:CreateScrollFrame();
--         row4.ScrollBar:SetPoint("TOPLEFT"; row4.ScrollFrame; "TOPRIGHT"; -5; 0);
--         row4.ScrollBar:SetPoint("BOTTOMRIGHT"; row4.ScrollFrame; "BOTTOMRIGHT"; 0; 0);
--         row4 = panel:CreateCell(row4);
--         row4:SetDimensions(2; 1);
--         row4:SetInsets(0; 5; 5; 5);

--         TimerBars[manager].list = ListFrame({
--             name = name;
--             type = type;
--             tracking = {};
--         }; child);

--         TimerBars[manager].list:ScanForItems();

--         TimerBars[manager].list:SetScript("OnShow"; function()
--             TimerBars[manager].list:ScanForItems();
--         end);

--         panel:GetRow(1):SetFixed(50);
--         panel:GetRow(2):SetFixed(36);
--         panel:GetRow(3):SetFixed(36);
--         panel:AddCells(row1; row2; row3; row4);
--     end

--     TimerBars[manager]:Show();
-- end