------------------------
-- Setup namespaces
------------------------
local _, TimerBars = ...;
local core = MayronUI:ImportModule("MUI_Core");
local tk = core.Toolkit;
local db = core.Database;
local gui = core.GUI_Builder;

local Map = {};
Map.position_textfields = {};

local L = LibStub("AceLocale-3.0"):GetLocale("MayronUI");

----------------
-- ListFrame
----------------
-- local ListFrame = tk:CreateProtectedPrototype("ListFrame", true);

-- function ListFrame:Update(data)
--     if (not data.items) then return; end

--     for _, item in tk.ipairs(data.items) do
--         item:ClearAllPoints();
--         item:Hide();
--     end

--     local height = 0;

--     for id, item in tk.ipairs(data.items) do

--         if (id == 1) then
--             item:SetPoint("TOPLEFT");
--             item:SetPoint("TOPRIGHT", 0, -30);
--             height = height + 30;
--         else
--             item:SetPoint("TOPLEFT", data.items[id - 1], "BOTTOMLEFT", 0, -2);
--             item:SetPoint("TOPRIGHT", data.items[id - 1], "BOTTOMRIGHT", 0, -32);
--             height = height + 32;
--         end
--         if (id % 2 ~= 0) then
--             tk:SetThemeColor(0.1, item.normal);
--         else
--             tk:SetThemeColor(0, item.normal);
--         end
--         data.frame:SetHeight(height);
--         item:Show();
--     end
-- end

-- do
--     local function Item_OnEnter(self)
--         if (self.spellID and tk.type(self.spellID) == "number") then
--             GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 2);
--             GameTooltip:SetSpellByID(self.spellID);
--             GameTooltip:Show();
--         end
--     end

--     local function Item_OnLeave(self)
--         GameTooltip:Hide()
--     end

--     function ListFrame:AddItem(data, name, spellID)
--         if (data.tracking[name]) then return; end
--         data.items = data.items or {};

--         data.btn_OnMouseUp = data.btn_OnMouseUp or function(btn)
--             local item = btn:GetParent();
--             self:RemoveItem(item, item.name:GetText());
--         end

--         local item = data.unused and data.unused:Pop();
--         if (not item) then
--             item = tk.CreateFrame("Button", nil, data.frame);
--             item:SetScript("OnEnter", Item_OnEnter);
--             item:SetScript("OnLeave", Item_OnLeave);
--             item:SetSize(30, 30);
--             item.normal = tk:SetBackground(item, 0, 0, 0, 0);
--             item.highlight = tk:SetBackground(item, 1, 1, 1, 0.1);
--             item:SetNormalTexture(item.normal);
--             item:SetHighlightTexture(item.highlight);
--             item.name = item:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
--             item.name:SetJustifyH("LEFT");
--             item.name:SetJustifyV("CENTER");
--             item.name:SetPoint("TOPLEFT", 6, 0);
--             item.name:SetPoint("BOTTOMRIGHT", -34, 0);
--             item.btn = tk.CreateFrame("Button", nil, item);
--             item.btn:SetSize(28, 24);
--             item.btn:SetPoint("RIGHT", -8, 0);
--             item.btn:SetNormalTexture(tk.Constants.MEDIA.."dialog_box\\CloseButton", "BLEND");
--             item.btn:SetHighlightTexture(tk.Constants.MEDIA.."dialog_box\\CloseButton", "ADD");
--             tk:SetThemeColor(item.btn);
--         end
--         table.insert(data.items, item);
--         data.tracking[name] = true;
--         item.spellID = spellID;
--         item.name:SetText(name);
--         item.btn:SetScript("OnMouseUp", data.btn_OnMouseUp);
--     end
-- end

-- function ListFrame:RemoveItem(data, item, name)
--     local index = tk:GetIndex(data.items, item);
--     table.remove(data.items, index);
--     data.tracking[name] = nil;
--     data.unused = data.unused or tk:CreateStack();
--     data.unused:Push(item);
--     item:Hide();
--     item:ClearAllPoints();
--     db.profile.timer_bars[data.name][data.type][name] = nil;
--     TimerBars:RefreshFields();
--     self:Update();
-- end

-- do
--     local function compare(a, b) return a < b; end
--     local names = {};

--     function ListFrame:ScanForItems(data)
--         local items = db.profile.timer_bars[data.name][data.type];

--         if (items) then
--             items = items:GetTable();
--             tk:EmptyTable(names);
--             names = tk:GetKeyTable(items, names);
--             table.sort(names, compare);

--             for _, name in tk.pairs(names) do
--                 self:AddItem(name, items[name]);
--             end

--             self:Update();
--         end
--     end
-- end

-- local function CreateListFrame(_, self)
--     local name = self.data[1]; -- "Player"
--     local type = self.data[2]; -- "buffs" or "debuffs"
--     local manager = tk.string.format("%s%s%s", name, (type):gsub("^%l", tk.string.upper), "Manager");
    
--     if (not TimerBars[manager]) then
--         TimerBars[manager] = gui:CreateDialogBox(nil, "HIGH");
--         local panel = TimerBars[manager];

--         gui:AddTitleBar(panel, self.name);
--         gui:AddCloseButton(panel);
--         panel:SetSize(400, 300);
--         panel:SetPoint("CENTER");
--         panel:SetFrameStrata("DIALOG");
--         panel:SetFrameLevel(20);
--         panel = gui:CreatePanel(panel);
--         --self.listFrame:SetDevMode(true);
--         panel:SetDimensions(1, 4);

--         local row1 = panel:CreateCell();
--         row1.label = row1:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
--         row1.label:SetText(tk.string.format(L["Enter the Name of a %s to Track:"], (type == "buffs" and "Buff" or "Debuff")));
--         row1.label:SetPoint("LEFT");
--         row1:SetInsets(22, 5, 0, 5);

--         local row2 = panel:CreateCell();
--         row2.cb1 = gui:CreateCheckButton(row2:GetFrame(),
--             tk.string.format(L["Only track your %s"], type), nil,
-- 			tk.string.format(L["Only %s casted by you will be tracked."], type));

--         row2.cb1:SetPoint("LEFT");
--         row2.cb1.btn:SetChecked(db.profile.timer_bars[name]["only_player_"..type]);

--         row2.cb1.btn:SetScript("OnClick", function(self)
--             db.profile.timer_bars[name]["only_player_"..type] = self:GetChecked();
--             TimerBars:RefreshFields();
--         end);

--         row2.cb2 = gui:CreateCheckButton(row2:GetFrame(),
--             tk.string.format(L["Track all %s"], type), nil,
--             tk.string.format(L["Ignore the list of %s to track and track everything."], type).."\n\n"..
-- 			tk.string.format(L["Enabling this will dynamically generate the list of %s to track."], type));

--         row2.cb2:SetPoint("LEFT", row2.cb1, "RIGHT", 5, 0);
--         row2.cb2.btn:SetChecked(db.profile.timer_bars[name]["track_all_"..type]);

--         row2.cb2.btn:SetScript("OnClick", function(self)
--             db.profile.timer_bars[name]["track_all_"..type] = self:GetChecked();
--             TimerBars:RefreshFields();
--         end);

--         local row3 = gui:CreateTextField();
--         row3.field:SetScript("OnEnterPressed", function(field)
--             field:ClearFocus();

--             local value = field:GetText();
--             local spellID = tk.select(7, GetSpellInfo(value));

--             TimerBars[manager].list:AddItem(value, spellID);

--             local tbl = db.profile.timer_bars[name];

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

--         local row4, child = gui:CreateScrollFrame();
--         row4.ScrollBar:SetPoint("TOPLEFT", row4.ScrollFrame, "TOPRIGHT", -5, 0);
--         row4.ScrollBar:SetPoint("BOTTOMRIGHT", row4.ScrollFrame, "BOTTOMRIGHT", 0, 0);
--         row4 = panel:CreateCell(row4);
--         row4:SetDimensions(2, 1);
--         row4:SetInsets(0, 5, 5, 5);

--         TimerBars[manager].list = ListFrame({
--             name = name,
--             type = type,
--             tracking = {},
--         }, child);

--         TimerBars[manager].list:ScanForItems();

--         TimerBars[manager].list:SetScript("OnShow", function()
--             TimerBars[manager].list:ScanForItems();
--         end);

--         panel:GetRow(1):SetFixed(50);
--         panel:GetRow(2):SetFixed(36);
--         panel:GetRow(3):SetFixed(36);
--         panel:AddCells(row1, row2, row3, row4);
--     end

--     TimerBars[manager]:Show();
-- end

function TimerBars:GetConfig()
    local categories = {
        {   name = "Timer Bars",
            type = "category",
            module = "TimerBars",
            children = {
                {   name = L["General Options"],
                    type = "title",
                    padding_top = 0
                },
                {   name = L["Sort By Time Remaining"],
                    type = "check",
                    width = 220,
                    db_path = "profile.timer_bars.sort_by_time"
                },
                {   name = L["Show Tooltips On Mouseover"],
                    type = "check",
                    width = 230,
                    db_path = "profile.timer_bars.show_tooltips"
                },
                {   type = "divider"
                },
                {   name = L["Bar Texture"],
                    type = "dropdown",
                    db_path = "profile.timer_bars.status_bar_texture",
                    options = tk.Constants.LSM:List("statusbar"),
                },
                {   type = "divider"
                },
                {   name = L["Create New Field"],
                    type = "button",
                    OnClick = function()
                        local name = "MUI_CreateTimerBarField";
                        if (not tk.StaticPopupDialogs[name]) then
                            gui:CreatePopupDialog(name, L["Name of New TimerBar Field:"], true, function(dialog)
                                local text = dialog.editBox:GetText();
                                local tbl = db.profile.timer_bars.field_names:GetTable();
                                db:SetPathValue("profile.timer_bars.field_names["..(#tbl + 1).."]", text);
                                tk:Print(tk.string.format(L["TimerBar field '%s' created."], text));
                                MayronUI:ImportModule("Config"):ShowReloadMessage();
                            end);
                        end
                        tk.StaticPopup_Show(name);
                    end
                },
                {   name = L["Remove Field"],
                    type = "button",
                    OnClick = function()
                        local name = "MUI_DeleteTimerBarField";
                        if (not tk.StaticPopupDialogs[name]) then
                            gui:CreatePopupDialog(name, L["Name of TimerBar Field to Remove:"], true, function(dialog)
                                local text = dialog.editBox:GetText();
                                local tbl = db.profile.timer_bars.field_names:GetTable();
                                local id = tk:GetIndex(tbl, text);
                                if (id) then
                                    db:SetPathValue("profile.timer_bars.field_names["..id.."]", nil);
                                    tk:Print(tk.string.format(L["TimerBar field '%s' remove."], text));
                                    if (not db.profile.timer_bars.delete_fields) then
                                        db.profile.timer_bars.delete_fields = {};
                                    end
                                    db.profile.timer_bars.delete_fields[text] = true;
                                    MayronUI:ImportModule("Config"):ShowReloadMessage();
                                else
                                    tk:Print(tk.string.format(L["TimerBar field '%s' does not exist."], text));
                                end
                            end);
                        end
                        tk.StaticPopup_Show(name);
                    end
                },
                {   name = L["Existing Timer Bar Fields"],
                    type = "title",
                },
                {   type = "loop",
                    args = db.profile.timer_bars.field_names:GetTable(),
                    func = function(id, name)
                        return {
                            {   name = name,
                                type = "submenu",
                                OnLoad = function()
                                    Map.position_textfields[name] = {};
                                end,
                                module = "TimerBars",
                                children = {
                                    {   name = L["Enable Field"],
                                        type = "check",
                                        db_path = "profile.timer_bars."..name..".enabled",
                                    },
                                    {   name = L["Unlock"],
                                        type = "button",
                                        OnClick = function(widget)
                                            widget.toggle = not widget.toggle;
                                            local field = tk._G["MUI_TimerBar"..name.."Field"];
                                            tk:MakeMovable(field, nil, widget.toggle);
                                            if (widget.toggle) then
                                                if (not field.move_indicator) then
                                                    local r, g, b = tk:GetThemeColor();
                                                    field.move_indicator = tk:SetBackground(field, r, g, b);
                                                    field.move_label = field:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
                                                    field.move_label:SetText(tk.string.format(L["<%s Field>"], name));
                                                    field.move_label:SetPoint("CENTER");
                                                end
                                                field.move_indicator:SetAlpha(0.4);
                                                field.move_label:SetAlpha(0.8);
                                                widget:SetText(L["Lock"]);
                                            elseif (field.move_indicator) then
                                                field.move_indicator:SetAlpha(0);
                                                field.move_label:SetAlpha(0);
                                                widget:SetText("Unlock");
                                                local positions = tk:SavePosition(field, "profile.timer_bars."..name..".position");
                                                if (positions) then
                                                    for key, textfield in tk.pairs(Map.position_textfields[name]) do
                                                        textfield:SetText(positions[key]);
                                                    end
                                                end
                                            end
                                        end
                                    },
                                    {   type = "divider",
                                    },
                                    {   name = L["Unit to Track"],
                                        type = "dropdown",
                                        tooltip = L["The unit who is affected by the spell."],
                                        db_path = "profile.timer_bars."..name..".unit",
                                        options = {
                                            L["Player"],
                                            L["Target"],
                                            L["TargetTarget"],
                                            L["Focus"],
                                            L["FocusTarget"]
                                        },
                                    },
                                    {   type = "divider"
                                    },
                                    {   name = L["Manage Tracking Buffs"],
                                        type = "button",
                                        data = {name, "buffs"},
                                        width = 220,
                                        OnClick = CreateListFrame,
                                    },
                                    {   name = L["Manage Tracking Debuffs"],
                                        type = "button",
                                        data = {name, "debuffs"},
                                        width = 220,
                                        OnClick = CreateListFrame,
                                    },
                                    {   name = L["Appearance Options"],
                                        type = "title"
                                    },
                                    {   content = L["The field's vertical growth direction:"],
                                        type = "fontstring",
                                    },
                                    {   name = L["Up"],
                                        db_path = "profile.timer_bars."..name..".direction",
                                        type = "radio",
                                        min_width = true,
                                        group = 1,
                                        GetValue = function(_, current_value)
                                            return current_value and current_value:find("UP");
                                        end,
                                        SetValue = function(db_path, _, value)
                                            db:SetPathValue(db_path, value and "UP" or "DOWN");
                                        end,
                                    },
                                    {   name = L["Down"],
                                        db_path = "profile.timer_bars."..name..".direction",
                                        type = "radio",
                                        min_width = true,
                                        group = 1,
                                        GetValue = function(_, current_value)
                                            return current_value and current_value:find("DOWN");
                                        end,
                                        SetValue = function(db_path, _, value)
                                            db:SetPathValue(db_path, value and "DOWN" or "UP");
                                        end,
                                    },
                                    {   type = "divider"
                                    },
                                    {   name = L["Bar Width"],
                                        type = "slider",
                                        db_path = "profile.timer_bars."..name..".bar_width",
                                        step = 1,
                                        min = 100,
                                        max = 400,
                                    },
                                    {   name = L["Bar Height"],
                                        type = "slider",
                                        db_path = "profile.timer_bars."..name..".bar_height",
                                        step = 1,
                                        min = 5,
                                        max = 50,
                                    },
                                    {   name = L["Bar Spacing"],
                                        type = "slider",
                                        db_path = "profile.timer_bars."..name..".spacing",
                                        step = 1,
                                        min = 0,
                                        max = 10,
                                    },
                                    {   type = "divider"
                                    },
                                    {   name = L["Show Icons"],
                                        type = "check",
                                        db_path = "profile.timer_bars."..name..".show_icons",
                                    },
                                    {   name = L["Show Spark"],
                                        type = "check",
                                        db_path = "profile.timer_bars."..name..".spark",
                                    },
                                    {   type = "divider"
                                    },
                                    {   name = L["Background Color"],
                                        type = "color",
                                        db_path = "profile.timer_bars."..name..".background_color",
                                    },
                                    {   name = L["Buff Bar Color"],
                                        type = "color",
                                        db_path = "profile.timer_bars."..name..".buff_bar_color",
                                    },
                                    {   name = L["Debuff Bar Color"],
                                        type = "color",
                                        db_path = "profile.timer_bars."..name..".debuff_bar_color",
                                    },
                                    {   type = "divider"
                                    },
                                    {   type = "fontstring",
                                        subtype = "header",
                                        content = L["Manual Positioning"]
                                    },
                                    {   name = L["Point"],
                                        type = "textfield",
                                        value_type = "string",
                                        db_path = "profile.timer_bars."..name..".position.point",
                                        OnLoad = function(_, container)
                                            Map.position_textfields[name].point = container.widget.field;
                                        end,
                                        GetValue = function()
                                            local value = db:ParsePathValue("profile.timer_bars."..name..".position");
                                            if (value) then
                                                return value.point;
                                            else
                                                local field = tk._G["MUI_TimerBar"..name.."Field"];
                                                if (not field) then return "disabled"; end
                                                return (tk.select(1, field:GetPoint()));
                                            end
                                        end
                                    },
                                    {   name = L["Relative Frame"],
                                        type = "textfield",
                                        value_type = "string",
                                        db_path = "profile.timer_bars."..name..".position.relativeFrame",
                                        OnLoad = function(_, container)
                                            Map.position_textfields[name].relativeFrame = container.widget.field;
                                        end,
                                        GetValue = function()
                                            local value = db:ParsePathValue("profile.timer_bars."..name..".position");
                                            if (value) then
                                                return value.relativeFrame;
                                            else
                                                local field = tk._G["MUI_TimerBar"..name.."Field"];
                                                if (not field) then return "disabled"; end
                                                return (tk.select(2, field:GetPoint())):GetName();
                                            end
                                        end
                                    },
                                    {   name = L["Relative Point"],
                                        type = "textfield",
                                        value_type = "string",
                                        db_path = "profile.timer_bars."..name..".position.relativePoint",
                                        OnLoad = function(_, container)
                                            Map.position_textfields[name].relativePoint = container.widget.field;
                                        end,
                                        GetValue = function()
                                            local value = db:ParsePathValue("profile.timer_bars."..name..".position");
                                            if (value) then
                                                return value.relativePoint;
                                            else
                                                local field = tk._G["MUI_TimerBar"..name.."Field"];
                                                if (not field) then return "disabled"; end
                                                return (tk.select(3, field:GetPoint()));
                                            end
                                        end
                                    },
                                    {   type = "divider"
                                    },
                                    {   name = L["X-Offset"],
                                        db_path = "profile.timer_bars."..name..".position.x",
                                        OnLoad = function(_, container)
                                            Map.position_textfields[name].x = container.widget.field;
                                        end,
                                        type = "textfield",
                                        value_type = "number",
                                        GetValue = function()
                                            local value = db:ParsePathValue("profile.timer_bars."..name..".position");
                                            if (value) then
                                                return value.x;
                                            else
                                                local field = tk._G["MUI_TimerBar"..name.."Field"];
                                                if (not field) then return "disabled"; end
                                                return (tk.select(4, field:GetPoint()));
                                            end
                                        end
                                    },
                                    {   name = L["Y-Offset"],
                                        db_path = "profile.timer_bars."..name..".position.y",
                                        OnLoad = function(_, container)
                                            Map.position_textfields[name].y = container.widget.field;
                                        end,
                                        type = "textfield",
                                        value_type = "number",
                                        GetValue = function()
                                            local value = db:ParsePathValue("profile.timer_bars."..name..".position");
                                            if (value) then
                                                return value.y;
                                            else
                                                local field = tk._G["MUI_TimerBar"..name.."Field"];
                                                if (not field) then return "disabled"; end
                                                return (tk.select(5, field:GetPoint()));
                                            end
                                        end
                                    },
                                    {   name = L["Text Options"],
                                        type = "title",
                                    },
                                    {   content = L["Time Remaining Text"],
                                        type = "fontstring",
                                        subtype = "header",
                                    },
                                    {   name = L["Show"],
                                        type = "check",
                                        height = 50,
                                        min_width = true,
                                        db_path = "profile.timer_bars."..name..".time.show",
                                    },
                                    {   name = L["Font Size"],
                                        type = "slider",
                                        tooltip = L["Default is 11"],
                                        step = 1,
                                        min = 8,
                                        max = 22,
                                        db_path = "profile.timer_bars."..name..".time.font_size",
                                    },
                                    {   name = L["Font Type"],
                                        type = "dropdown",
                                        db_path = "profile.timer_bars."..name..".time.font",
                                        font_chooser = true,
                                        options = tk.Constants.LSM:List("font"),
                                    },
                                    {   content = L["Spell Name Text"],
                                        type = "fontstring",
                                        subtype = "header",
                                    },
                                    {   name = L["Show"],
                                        type = "check",
                                        height = 50,
                                        min_width = true,
                                        db_path = "profile.timer_bars."..name..".spell_name.show",
                                    },
                                    {   name = L["Font Size"],
                                        type = "slider",
                                        tooltip = L["Default is 11"],
                                        step = 1,
                                        min = 8,
                                        max = 22,
                                        db_path = "profile.timer_bars."..name..".spell_name.font_size",
                                    },
                                    {   name = L["Font Type"],
                                        type = "dropdown",
                                        db_path = "profile.timer_bars."..name..".spell_name.font",
                                        font_chooser = true,
                                        options = tk.Constants.LSM:List("font"),
                                    },
                                }
                            }
                        };
                    end
                },
            }
        }
    };
    return categories;
end

function TimerBarsModuleClass:OnConfigUpdate(list, value)
    local key = list:PopFront();

    if (key == "profile" and list:PopFront() == "timer_bars") then
        key = list:PopFront();
        local field = tk._G["MUI_TimerBar"..key.."Field"];

        if (field) then
            local name = key;
            local data = TimerFieldClass.Static:GetData(TimerFieldClass[name]);

            key = list:PopFront();
            if (key == "position") then
                key = list:PopFront();
                local point, relativeFrame, relativePoint, x, y = field:GetPoint();
                field:ClearAllPoints();
                if (key == "point") then
                    field:SetPoint(value, relativeFrame, relativePoint, x, y);

                elseif (key == "relativeFrame") then
                    field:SetPoint(point, tk._G[value], relativePoint, x, y);

                elseif (key == "relativePoint") then
                    field:SetPoint(point, relativeFrame, value, x, y);

                elseif (key == "x") then
                    field:SetPoint(point, relativeFrame, relativePoint, value, y);

                elseif (key == "y") then
                    field:SetPoint(point, relativeFrame, relativePoint, x, value);

                end
            elseif (key == "bar_width") then
                field:SetWidth(value);
                for _, bar in tk.pairs(data.total_bars) do
                    bar.name:SetWidth(value - data.sv.bar_height - 50);
                end

            elseif (key == "bar_height") then
                for _, bar in tk.pairs(data.total_bars) do
                    bar:SetHeight(value);
                    bar.icon:SetWidth(value);
                end

            elseif (key == "spacing") then
                data.spacing = value;
                TimerFieldClass[name]:PositionBars();

            elseif (key == "buff_bar_color") then
                data.buff_bar_color = value;

                for _, bar in tk.pairs(data.total_bars) do
                    if (bar.type == "BUFF") then
                        bar.slider:SetStatusBarColor(value.r, value.g, value.b, value.a);
                    end
                end

            elseif (key == "debuff_bar_color") then
                data.debuff_bar_color = value;

                for _, bar in tk.pairs(data.total_bars) do
                    if (bar.type == "DEBUFF") then
                        bar.slider:SetStatusBarColor(value.r, value.g, value.b, value.a);
                    end
                end

            elseif (key == "background_color") then
                for _, bar in tk.pairs(data.total_bars) do
                    bar.slider.bg:SetColorTexture(value.r, value.g, value.b, value.a);
                end

            elseif (key == "show_icons") then
                for _, bar in tk.pairs(data.total_bars) do
                    bar.icon:SetShown(value);

                    if (not value) then
                        bar.slider:SetPoint("TOPLEFT");
                        bar.slider:SetPoint("BOTTOMLEFT");

                    else
                        bar.slider:SetPoint("TOPLEFT", bar.icon, "TOPRIGHT");
                        bar.slider:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMRIGHT");
                    end
                end

            elseif (key == "spark") then
                for _, bar in tk.pairs(data.total_bars) do
                    if (bar.spark) then
                        bar.spark:SetShown(value);

                    elseif (value) then
                        bar.spark = bar.slider:CreateTexture(nil, "OVERLAY");
                        bar.spark:SetWidth(28);
                        bar.spark:SetPoint("TOP", 0, 12);
                        bar.spark:SetPoint("BOTTOM", 0, -12);
                        bar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark");
                        bar.spark:SetVertexColor(1, 1, 1);
                        bar.spark:SetBlendMode("ADD");

                    end
                end

            elseif (key == "direction") then
                data.direction = value;
                TimerFieldClass[name]:PositionBars();

            elseif (key == "time") then
                key = list:PopFront();
                if (key == "show") then
                    for _, bar in tk.pairs(data.total_bars) do
                        bar.duration:SetShown(value);
                    end

                elseif (key == "font_size") then
                    local font = tk.Constants.LSM:Fetch("font", data.sv.time.font);
                    for _, bar in tk.pairs(data.total_bars) do
                        bar.duration:SetFont(font, value);
                    end

                elseif (key == "font") then
                    local font = tk.Constants.LSM:Fetch("font", value);
                    for _, bar in tk.pairs(data.total_bars) do
                        bar.duration:SetFont(font, data.sv.time.font_size);
                    end

                end
            elseif (key == "spell_name") then
                key = list:PopFront();
                if (key == "show") then
                    for _, bar in tk.pairs(data.total_bars) do
                        bar.name:SetShown(value);
                    end

                elseif (key == "font_size") then
                    local font = tk.Constants.LSM:Fetch("font", data.sv.spell_name.font);
                    for _, bar in tk.pairs(data.total_bars) do
                        bar.name:SetFont(font, value);
                    end

                elseif (key == "font") then
                    local font = tk.Constants.LSM:Fetch("font", value);
                    for _, bar in tk.pairs(data.total_bars) do
                        bar.name:SetFont(font, data.sv.spell_name.font_size);
                    end

                end
            elseif (key == "unit") then
                data.unit = value;
                if (value ~= "Player") then
                    if (value == "Target") then
                        TimerFieldClass[name]:RegisterEvent("PLAYER_TARGET_CHANGED");

                    elseif (value == "TargetTarget") then
                        TimerFieldClass[name]:RegisterEvent("UNIT_TARGET");

                    elseif (value == "Focus") then
                        TimerFieldClass[name]:RegisterEvent("PLAYER_FOCUS_CHANGED");

                    elseif (value == "FocusTarget") then
                        TimerFieldClass[name]:RegisterEvent("UNIT_TARGET");

                    end
                end

            elseif (key == "enabled") then
                TimerFieldClass[name]:SetEnabled(value);
            end

        elseif (key == "status_bar_texture") then
            value = tk.Constants.LSM:Fetch("statusbar", value);
            for _, field in tk.ipairs(private.fields) do
                local data = TimerFieldClass.Static:GetData(field);
                for _, bar in tk.pairs(data.total_bars) do
                    bar.slider:SetStatusBarTexture(value);
                end
            end

        elseif (key == "sort_by_time") then
            for _, field in tk.ipairs(private.fields) do
                field:PositionBars();
            end

        elseif (key == "show_tooltips") then
            for _, field in tk.ipairs(private.fields) do
                local data = TimerFieldClass.Static:GetData(field);

                for _, bar in tk.pairs(data.total_bars) do
                    if (value) then
                        bar:SetScript("OnEnter", bar_OnEnter);
                        bar:SetScript("OnLeave", bar_OnLeave);
                    else
                        bar:SetScript("OnEnter", tk.Constants.DUMMY_FUNC);
                        bar:SetScript("OnLeave", tk.Constants.DUMMY_FUNC);
                    end
                end
            end

        end
    end
end