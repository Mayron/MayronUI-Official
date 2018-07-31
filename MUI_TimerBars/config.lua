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

----------------
-- ListFrame
----------------
local ListFrame = tk:CreateProtectedPrototype("ListFrame", true);

function ListFrame:Update(data)
    if (not data.items) then return; end

    for _, item in tk.ipairs(data.items) do
        item:ClearAllPoints();
        item:Hide();
    end

    local height = 0;

    for id, item in tk.ipairs(data.items) do

        if (id == 1) then
            item:SetPoint("TOPLEFT");
            item:SetPoint("TOPRIGHT", 0, -30);
            height = height + 30;
        else
            item:SetPoint("TOPLEFT", data.items[id - 1], "BOTTOMLEFT", 0, -2);
            item:SetPoint("TOPRIGHT", data.items[id - 1], "BOTTOMRIGHT", 0, -32);
            height = height + 32;
        end
        if (id % 2 ~= 0) then
            tk:SetThemeColor(0.1, item.normal);
        else
            tk:SetThemeColor(0, item.normal);
        end
        data.frame:SetHeight(height);
        item:Show();
    end
end

do
    local function Item_OnEnter(self)
        if (self.spellID and tk.type(self.spellID) == "number") then
            GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 2);
            GameTooltip:SetSpellByID(self.spellID);
            GameTooltip:Show();
        end
    end

    local function Item_OnLeave(self)
        GameTooltip:Hide()
    end

    function ListFrame:AddItem(data, name, spellID)
        if (data.tracking[name]) then return; end
        data.items = data.items or {};

        data.btn_OnMouseUp = data.btn_OnMouseUp or function(btn)
            local item = btn:GetParent();
            self:RemoveItem(item, item.name:GetText());
        end

        local item = data.unused and data.unused:Pop();
        if (not item) then
            item = tk.CreateFrame("Button", nil, data.frame);
            item:SetScript("OnEnter", Item_OnEnter);
            item:SetScript("OnLeave", Item_OnLeave);
            item:SetSize(30, 30);
            item.normal = tk:SetBackground(item, 0, 0, 0, 0);
            item.highlight = tk:SetBackground(item, 1, 1, 1, 0.1);
            item:SetNormalTexture(item.normal);
            item:SetHighlightTexture(item.highlight);
            item.name = item:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
            item.name:SetJustifyH("LEFT");
            item.name:SetJustifyV("CENTER");
            item.name:SetPoint("TOPLEFT", 6, 0);
            item.name:SetPoint("BOTTOMRIGHT", -34, 0);
            item.btn = tk.CreateFrame("Button", nil, item);
            item.btn:SetSize(28, 24);
            item.btn:SetPoint("RIGHT", -8, 0);
            item.btn:SetNormalTexture(tk.Constants.MEDIA.."dialog_box\\CloseButton", "BLEND");
            item.btn:SetHighlightTexture(tk.Constants.MEDIA.."dialog_box\\CloseButton", "ADD");
            tk:SetThemeColor(item.btn);
        end
        tk.table.insert(data.items, item);
        data.tracking[name] = true;
        item.spellID = spellID;
        item.name:SetText(name);
        item.btn:SetScript("OnMouseUp", data.btn_OnMouseUp);
    end
end

function ListFrame:RemoveItem(data, item, name)
    local index = tk:GetIndex(data.items, item);
    tk.table.remove(data.items, index);
    data.tracking[name] = nil;
    data.unused = data.unused or tk:CreateStack();
    data.unused:Push(item);
    item:Hide();
    item:ClearAllPoints();
    db.profile.timer_bars[data.name][data.type][name] = nil;
    TimerBars:RefreshFields();
    self:Update();
end

do
    local function compare(a, b) return a < b; end
    local names = {};

    function ListFrame:ScanForItems(data)
        local items = db.profile.timer_bars[data.name][data.type];

        if (items) then
            items = items:GetTable();
            tk:EmptyTable(names);
            names = tk:GetKeyTable(items, names);
            tk.table.sort(names, compare);

            for _, name in tk.pairs(names) do
                self:AddItem(name, items[name]);
            end

            self:Update();
        end
    end
end

local function CreateListFrame(_, self)
    local name = self.data[1]; -- "Player"
    local type = self.data[2]; -- "buffs" or "debuffs"
    local manager = tk.string.format("%s%s%s", name, (type):gsub("^%l", tk.string.upper), "Manager");
    
    if (not TimerBars[manager]) then
        TimerBars[manager] = gui:CreateDialogBox(nil, "HIGH");
        local panel = TimerBars[manager];

        gui:AddTitleBar(panel, self.name);
        gui:AddCloseButton(panel);
        panel:SetSize(400, 300);
        panel:SetPoint("CENTER");
        panel:SetFrameStrata("DIALOG");
        panel:SetFrameLevel(20);
        panel = gui:CreatePanel(panel);
        --self.listFrame:SetDevMode(true);
        panel:SetDimensions(1, 4);

        local row1 = panel:CreateCell();
        row1.label = row1:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
        row1.label:SetText("Enter the Name of a "..(type == "buffs" and "Buff" or "Debuff").." to Track:");
        row1.label:SetPoint("LEFT");
        row1:SetInsets(22, 5, 0, 5);

        local row2 = panel:CreateCell();
        row2.cb1 = gui:CreateCheckButton(row2:GetFrame(),
            "Only track your "..type, nil,
            "Only "..type.." casted by you will be tracked.");

        row2.cb1:SetPoint("LEFT");
        row2.cb1.btn:SetChecked(db.profile.timer_bars[name]["only_player_"..type]);

        row2.cb1.btn:SetScript("OnClick", function(self)
            db.profile.timer_bars[name]["only_player_"..type] = self:GetChecked();
            TimerBars:RefreshFields();
        end);

        row2.cb2 = gui:CreateCheckButton(row2:GetFrame(),
            "Track all "..type, nil,
            "Ignore the list of "..type.." to track and track everything.\n\n"..
            "Enabling this will dynamically generate the list of "..type.." to track.");

        row2.cb2:SetPoint("LEFT", row2.cb1, "RIGHT", 5, 0);
        row2.cb2.btn:SetChecked(db.profile.timer_bars[name]["track_all_"..type]);

        row2.cb2.btn:SetScript("OnClick", function(self)
            db.profile.timer_bars[name]["track_all_"..type] = self:GetChecked();
            TimerBars:RefreshFields();
        end);

        local row3 = gui:CreateTextField();
        row3.field:SetScript("OnEnterPressed", function(field)
            field:ClearFocus();

            local value = field:GetText();
            local spellID = tk.select(7, GetSpellInfo(value));

            TimerBars[manager].list:AddItem(value, spellID);

            local tbl = db.profile.timer_bars[name];

            if (not tbl[type]) then
                tbl[type] = {};
            end

            tbl[type][value] = spellID or true;
            field:SetText("");
            TimerBars:RefreshFields();
            TimerBars[manager].list:Update();
        end);

        row3 = panel:CreateCell(row3);
        row3:SetInsets(5);

        local row4, child = gui:CreateScrollFrame();
        row4.ScrollBar:SetPoint("TOPLEFT", row4.ScrollFrame, "TOPRIGHT", -5, 0);
        row4.ScrollBar:SetPoint("BOTTOMRIGHT", row4.ScrollFrame, "BOTTOMRIGHT", 0, 0);
        row4 = panel:CreateCell(row4);
        row4:SetDimensions(2, 1);
        row4:SetInsets(0, 5, 5, 5);

        TimerBars[manager].list = ListFrame({
            name = name,
            type = type,
            tracking = {},
        }, child);

        TimerBars[manager].list:ScanForItems();

        TimerBars[manager].list:SetScript("OnShow", function()
            TimerBars[manager].list:ScanForItems();
        end);

        panel:GetRow(1):SetFixed(50);
        panel:GetRow(2):SetFixed(36);
        panel:GetRow(3):SetFixed(36);
        panel:AddCells(row1, row2, row3, row4);
    end

    TimerBars[manager]:Show();
end

function TimerBars:GetConfig()
    local categories = {
        {   name = "Timer Bars",
            type = "category",
            module = "TimerBars",
            children = {
                {   name = "General Options",
                    type = "title",
                    padding_top = 0
                },
                {   name = "Sort By Time Remaining",
                    type = "check",
                    width = 220,
                    db_path = "profile.timer_bars.sort_by_time"
                },
                {   name = "Show Tooltips On Mouseover",
                    type = "check",
                    width = 230,
                    db_path = "profile.timer_bars.show_tooltips"
                },
                {   type = "divider"
                },
                {   name = "Bar Texture",
                    type = "dropdown",
                    db_path = "profile.timer_bars.status_bar_texture",
                    options = tk.Constants.LSM:List("statusbar"),
                },
                {   type = "divider"
                },
                {   name = "Create New Field",
                    type = "button",
                    OnClick = function()
                        local name = "MUI_CreateTimerBarField";
                        if (not tk.StaticPopupDialogs[name]) then
                            gui:CreatePopupDialog(name, "Name of New TimerBar Field:", true, function(dialog)
                                local text = dialog.editBox:GetText();
                                local tbl = db.profile.timer_bars.field_names:GetTable();
                                db:SetPathValue("profile.timer_bars.field_names["..(#tbl + 1).."]", text);
                                tk:Print("TimerBar field '"..text.."' created.");
                                MayronUI:ImportModule("Config"):ShowReloadMessage();
                            end);
                        end
                        tk.StaticPopup_Show(name);
                    end
                },
                {   name = "Remove Field",
                    type = "button",
                    OnClick = function()
                        local name = "MUI_DeleteTimerBarField";
                        if (not tk.StaticPopupDialogs[name]) then
                            gui:CreatePopupDialog(name, "Name of TimerBar Field to Remove:", true, function(dialog)
                                local text = dialog.editBox:GetText();
                                local tbl = db.profile.timer_bars.field_names:GetTable();
                                local id = tk:GetIndex(tbl, text);
                                if (id) then
                                    db:SetPathValue("profile.timer_bars.field_names["..id.."]", nil);
                                    tk:Print("TimerBar field '"..text.."' remove.");
                                    if (not db.profile.timer_bars.delete_fields) then
                                        db.profile.timer_bars.delete_fields = {};
                                    end
                                    db.profile.timer_bars.delete_fields[text] = true;
                                    MayronUI:ImportModule("Config"):ShowReloadMessage();
                                else
                                    tk:Print("TimerBar field '"..text.."' does not exist.");
                                end
                            end);
                        end
                        tk.StaticPopup_Show(name);
                    end
                },
                {   name = "Existing Timer Bar Fields",
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
                                    {   name = "Enable Field",
                                        type = "check",
                                        db_path = "profile.timer_bars."..name..".enabled",
                                    },
                                    {   name = "Unlock",
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
                                                    field.move_label:SetText("<"..name.." Field>");
                                                    field.move_label:SetPoint("CENTER");
                                                end
                                                field.move_indicator:SetAlpha(0.4);
                                                field.move_label:SetAlpha(0.8);
                                                widget:SetText("Lock");
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
                                    {   name = "Unit to Track",
                                        type = "dropdown",
                                        tooltip = "The unit who is affected by the spell.",
                                        db_path = "profile.timer_bars."..name..".unit",
                                        options = {
                                            "Player",
                                            "Target",
                                            "TargetTarget",
                                            "Focus",
                                            "FocusTarget"
                                        },
                                    },
                                    {   type = "divider"
                                    },
                                    {   name = "Manage Tracking Buffs",
                                        type = "button",
                                        data = {name, "buffs"},
                                        width = 220,
                                        OnClick = CreateListFrame,
                                    },
                                    {   name = "Manage Tracking Debuffs",
                                        type = "button",
                                        data = {name, "debuffs"},
                                        width = 220,
                                        OnClick = CreateListFrame,
                                    },
                                    {   name = "Appearance Options",
                                        type = "title"
                                    },
                                    {   content = "The field's vertical growth direction:",
                                        type = "fontstring",
                                    },
                                    {   name = "Up",
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
                                    {   name = "Down",
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
                                    {   name = "Bar Width",
                                        type = "slider",
                                        db_path = "profile.timer_bars."..name..".bar_width",
                                        step = 1,
                                        min = 100,
                                        max = 400,
                                    },
                                    {   name = "Bar Height",
                                        type = "slider",
                                        db_path = "profile.timer_bars."..name..".bar_height",
                                        step = 1,
                                        min = 5,
                                        max = 50,
                                    },
                                    {   name = "Bar Spacing",
                                        type = "slider",
                                        db_path = "profile.timer_bars."..name..".spacing",
                                        step = 1,
                                        min = 0,
                                        max = 10,
                                    },
                                    {   type = "divider"
                                    },
                                    {   name = "Show Icons",
                                        type = "check",
                                        db_path = "profile.timer_bars."..name..".show_icons",
                                    },
                                    {   name = "Show Spark",
                                        type = "check",
                                        db_path = "profile.timer_bars."..name..".spark",
                                    },
                                    {   type = "divider"
                                    },
                                    {   name = "Background Color",
                                        type = "color",
                                        db_path = "profile.timer_bars."..name..".background_color",
                                    },
                                    {   name = "Buff Bar Color",
                                        type = "color",
                                        db_path = "profile.timer_bars."..name..".buff_bar_color",
                                    },
                                    {   name = "Debuff Bar Color",
                                        type = "color",
                                        db_path = "profile.timer_bars."..name..".debuff_bar_color",
                                    },
                                    {   type = "divider"
                                    },
                                    {   type = "fontstring",
                                        subtype = "header",
                                        content = "Manual Positioning"
                                    },
                                    {   name = "Point",
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
                                    {   name = "Relative Frame",
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
                                    {   name = "Relative Point",
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
                                    {   name = "X-Offset",
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
                                    {   name = "Y-Offset",
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
                                    {   name = "Text Options",
                                        type = "title",
                                    },
                                    {   content = "Time Remaining Text",
                                        type = "fontstring",
                                        subtype = "header",
                                    },
                                    {   name = "Show",
                                        type = "check",
                                        height = 50,
                                        min_width = true,
                                        db_path = "profile.timer_bars."..name..".time.show",
                                    },
                                    {   name = "Font Size",
                                        type = "slider",
                                        tooltip = "Default is 11",
                                        step = 1,
                                        min = 8,
                                        max = 22,
                                        db_path = "profile.timer_bars."..name..".time.font_size",
                                    },
                                    {   name = "Font Type",
                                        type = "dropdown",
                                        db_path = "profile.timer_bars."..name..".time.font",
                                        font_chooser = true,
                                        options = tk.Constants.LSM:List("font"),
                                    },
                                    {   content = "Spell Name Text",
                                        type = "fontstring",
                                        subtype = "header",
                                    },
                                    {   name = "Show",
                                        type = "check",
                                        height = 50,
                                        min_width = true,
                                        db_path = "profile.timer_bars."..name..".spell_name.show",
                                    },
                                    {   name = "Font Size",
                                        type = "slider",
                                        tooltip = "Default is 11",
                                        step = 1,
                                        min = 8,
                                        max = 22,
                                        db_path = "profile.timer_bars."..name..".spell_name.font_size",
                                    },
                                    {   name = "Font Type",
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