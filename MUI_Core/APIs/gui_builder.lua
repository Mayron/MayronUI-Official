------------------------
-- Setup namespaces
------------------------
local _, core = ...;
core.GUI_Builder = {};

local db = core.Database;
local gui = core.GUI_Builder;
local tk = core.Toolkit;

------------------------
------------------------
local function ToolTip_OnEnter(frame)
    GameTooltip:SetOwner(frame, "ANCHOR_TOP", 0, 2);
    GameTooltip:AddLine(frame.tooltip);
    GameTooltip:Show();
end

local function ToolTip_OnLeave(frame)
    GameTooltip:Hide();
end

function gui:CreateDialogBox(parent, alphaType, frame, name)
    local f = frame or tk.CreateFrame("Frame", name, parent or tk.UIParent);
    f:EnableMouse(true);
    alphaType = alphaType or "Medium";
    alphaType = alphaType:lower();
    alphaType = alphaType:gsub("^%l", tk.string.upper);

    local texture = tk.Constants.MEDIA.."dialog_box\\Texture-"..alphaType;
    gui:CreateGridTexture(f, texture, 10, 6, 512, 512);

    tk:SetThemeColor(f.tl, f.tr, f.bl, f.br, f.t, f.b, f.l, f.r, f.c);
    f:SetFrameStrata("DIALOG");
    return f;
end

function gui:CreatePopupDialog(name, text, hasEditBox, OnAccept)
    if (not tk.StaticPopupDialogs[name]) then
        tk.StaticPopupDialogs[name] = {
            text = text,
            button1 = "Confirm",
            button2 = "Cancel",
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            hasEditBox = hasEditBox,
            preferredIndex = 3,
            OnAccept = OnAccept, -- dialog param
        };
    end
    if (text) then
        tk.StaticPopupDialogs[name].text = text;
    end
    if (OnAccept) then
        tk.StaticPopupDialogs[name].OnAccept = OnAccept;
    end
end

do
    local function SetGridColor(self, r, g, b)
        for _, key in tk:IterateArgs("tl", "tr", "bl", "br", "t", "b", "l", "r", "c") do
            self[key]:SetVertexColor(r, g, b);
        end
    end

    -- change param 4 to insets
    function gui:CreateGridTexture(frame, texture, cornerSize, inset, originalTextureWidth, originalTextureHeight)
        local smallWidth = cornerSize / originalTextureWidth;
        local largeWidth = 1 - smallWidth;
        local smallHeight = cornerSize / originalTextureHeight;
        local largeHeight = 1 - smallHeight;
        inset = inset or 0;
        for _, key in tk:IterateArgs("tl", "tr", "bl", "br", "t", "b", "l", "r", "c") do
            frame[key] = frame:CreateTexture(nil, "BACKGROUND");
            frame[key]:SetTexture(texture);
            frame[key]:SetSize(cornerSize, cornerSize);
        end
        frame.tl:SetPoint("TOPLEFT", -inset, inset);
        frame.tl:SetTexCoord(0, smallWidth, 0, smallHeight);
        frame.tr:SetPoint("TOPRIGHT", inset, inset);
        frame.tr:SetTexCoord(largeWidth, 1, 0, smallHeight);
        frame.bl:SetPoint("BOTTOMLEFT", -inset, -inset);
        frame.bl:SetTexCoord(0, smallWidth, largeHeight, 1);
        frame.br:SetPoint("BOTTOMRIGHT", inset, -inset);
        frame.br:SetTexCoord(largeWidth, 1, largeHeight, 1);
        frame.t:SetPoint("TOPLEFT", frame.tl, "TOPRIGHT");
        frame.t:SetPoint("BOTTOMRIGHT", frame.tr, "BOTTOMLEFT");
        frame.t:SetTexCoord(smallWidth, largeWidth, 0, smallHeight);
        frame.b:SetPoint("TOPLEFT", frame.bl, "TOPRIGHT");
        frame.b:SetPoint("BOTTOMRIGHT", frame.br, "BOTTOMLEFT");
        frame.b:SetTexCoord(smallWidth, largeWidth, largeHeight, 1);
        frame.l:SetPoint("TOPLEFT", frame.tl, "BOTTOMLEFT");
        frame.l:SetPoint("BOTTOMRIGHT", frame.bl, "TOPRIGHT");
        frame.l:SetTexCoord(0, smallWidth, smallHeight, largeHeight);
        frame.r:SetPoint("TOPLEFT", frame.tr, "BOTTOMLEFT");
        frame.r:SetPoint("BOTTOMRIGHT", frame.br, "TOPRIGHT");
        frame.r:SetTexCoord(largeWidth, 1, smallHeight, largeHeight);
        frame.c:SetPoint("TOPLEFT", frame.tl, "BOTTOMRIGHT");
        frame.c:SetPoint("BOTTOMRIGHT", frame.br, "TOPLEFT");
        frame.c:SetTexCoord(smallWidth, largeWidth, smallHeight, largeHeight);
        frame.SetGridColor = SetGridColor;
    end
end

do
    local OnEscapePressed = function(self)
        self:ClearFocus();
    end

    local function OnEnable(self)
        local container = self:GetParent();
        local r, g, b = tk:GetThemeColor()
        container:SetBackdropBorderColor(r, g, b, 0.8);
        self:SetAlpha(1);
    end

    local function OnDisable(self)
        local container = self:GetParent();
        container:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.8);
        self:SetAlpha(0.4);
    end

    function gui:CreateTextField(tooltip)
        local r, g, b = tk:GetThemeColor();
        local container = tk.CreateFrame("Frame");
        container:SetBackdrop(tk.Constants.backdrop);
        container:SetBackdropBorderColor(r, g, b, 0.8);
        tk:SetBackground(container, 0, 0, 0, 0.2);

        container.field = tk.CreateFrame("EditBox", nil, container, "InputBoxTemplate");
        container.field:SetPoint("TOPLEFT", container, "TOPLEFT", 5, 0);
        container.field:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -5, 0);
        container.field:SetAutoFocus(false);
        core.Reskinner:Reskin(container.field, 2);
        container.field:SetScript("OnEscapePressed", OnEscapePressed);
        container.field:SetScript("OnEnable", OnEnable);
        container.field:SetScript("OnDisable", OnDisable);

        if (tooltip) then
            container.field.tooltip = tooltip;
            container.field:SetScript("OnEnter", ToolTip_OnEnter);
            container.field:SetScript("OnLeave", ToolTip_OnLeave);
        end
        return container;
    end
end

function gui:CreateButton(parent, text, r, g, b, alpha, button)
    alpha = alpha or 0.6;
    if (not (r and g and b)) then
        r, g, b = tk:GetThemeColor();
        r = r * 0.7; g = g * 0.7; b = b * 0.7;
    end
    local btn = button;
    if (not button) then
        btn = tk.CreateFrame("Button", nil, parent);
        btn:SetSize(150, 30);
    end
    btn:SetBackdrop(tk.Constants.backdrop);
    btn:SetBackdropBorderColor(r, g, b, 1);
    btn.normal = tk:SetBackground(btn, tk.Constants.MEDIA.."mui_bar");
    btn.highlight = tk:SetBackground(btn, tk.Constants.MEDIA.."mui_bar");
    btn.disabled = tk:SetBackground(btn, tk.Constants.MEDIA.."mui_bar");
    btn.normal:SetVertexColor(r, g, b, alpha);
    btn.highlight:SetVertexColor(r, g, b, alpha);
    btn.disabled:SetVertexColor(r * 0.5, g * 0.5, b * 0.5, 0.8);
    btn:SetNormalTexture(btn.normal);
    btn:SetHighlightTexture(btn.highlight);
    btn:SetDisabledTexture(btn.disabled);
    btn:SetNormalFontObject("GameFontHighlight");
    btn:SetDisabledFontObject("GameFontDisable");

    if (text) then
        btn:SetText(text);
    end
    return btn;
end

do
    local function OnEnter(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
        GameTooltip:AddLine(self.tooltip);
        GameTooltip:Show();
    end

    local function OnLeave(self)
        GameTooltip:Hide();
    end

    function gui:CreateCheckButton(parent, text, radio, tooltip)
        local cb = tk:PopFrame("Frame", parent);
        cb:SetSize(150, 30);
        if (radio) then
            cb.btn = tk.CreateFrame("CheckButton", nil, cb, "UIRadioButtonTemplate");
            cb.btn:SetSize(20, 20);
        else
            cb.btn = tk.CreateFrame("CheckButton", nil, cb, "UICheckButtonTemplate");
            cb.btn:SetSize(30, 30);
        end
        if (tooltip) then
            cb.btn.tooltip = tooltip;
            cb.btn:SetScript("OnEnter", OnEnter);
            cb.btn:SetScript("OnLeave", OnLeave);
        end

        cb.btn.text:SetFontObject("GameFontHighlight");
        cb.btn.text:ClearAllPoints();
        cb.btn.text:SetPoint("LEFT", cb.btn, "RIGHT", 5, 0);
        cb.btn:SetPoint("LEFT");
        if (text) then
            cb.btn.text:SetText(text);
            local width = cb.btn.text:GetStringWidth();
            width = (width > 100) and width or 100;
            cb:SetWidth(width + cb.btn:GetWidth() + 20);
        end
        return cb;
    end
end

do
    local function DynamicScrollBar(self)
        local scrollChild = self:GetScrollChild();
        local scrollChildHeight = tk.math.floor(scrollChild:GetHeight() + 0.5);
        local scrollFrameHeight = tk.math.floor(self:GetHeight() + 0.5);

        if (scrollChild and scrollChildHeight > scrollFrameHeight) then
            if (self.animating) then
                self.ScrollBar:Hide();
                self.showScrollBar = self.ScrollBar;
            else
                self.ScrollBar:Show();
            end
        else
            self.showScrollBar = false;
            self.ScrollBar:Hide();
        end
    end

    local function ScrollFrame_OnMouseWheel(self, step)
        local newvalue = self:GetVerticalScroll() - (step * 20);

        if (newvalue < 0) then
            newvalue = 0;
            -- max scroll range is scrollchild.height - scrollframe.height!
        elseif (newvalue > self:GetVerticalScrollRange()) then
            newvalue = self:GetVerticalScrollRange();
        end

        self:SetVerticalScroll(newvalue);
    end

    local function GetScrollChild(self)
        return self.ScrollFrame:GetScrollChild();
    end

    local function SetScrollChild(self, ...)
        self.ScrollFrame:SetScrollChild(...);
    end

    function gui:CreateScrollFrame(parent, global, child_right_padding)
        local r, g, b = tk:GetThemeColor();
        local container = tk.CreateFrame("Frame", global, parent);

        container.ScrollFrame = tk.CreateFrame("ScrollFrame", nil, container, "UIPanelScrollFrameTemplate");        
        container.ScrollFrame:SetAllPoints(true);
        container.ScrollFrame:EnableMouseWheel(true);
        container.ScrollFrame:SetClipsChildren(true);
        container.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);

        local child = tk.CreateFrame("Frame", nil, container.ScrollFrame);
        container.ScrollFrame:SetScrollChild(child);
        tk:SetFullWidth(child, child_right_padding);

        --ScrollBar------------------
        container.ScrollBar = container.ScrollFrame.ScrollBar;
        container.ScrollBar:ClearAllPoints();
        container.ScrollBar:SetPoint("TOPLEFT", container.ScrollFrame, "TOPRIGHT", -7, -2);
        container.ScrollBar:SetPoint("BOTTOMRIGHT", container.ScrollFrame, "BOTTOMRIGHT", -2, 2);

        container.ScrollBar.thumb = container.ScrollBar:GetThumbTexture();
        container.ScrollBar.thumb:SetColorTexture(r, g, b, 0.8);
        container.ScrollBar.thumb:SetSize(5, 50);

        container.ScrollBar:Hide();

        tk:SetBackground(container.ScrollBar, 0, 0, 0, 0.2);
        tk:KillElement(container.ScrollBar.ScrollUpButton);
        tk:KillElement(container.ScrollBar.ScrollDownButton);
        ----------------------------  

        container.ScrollFrame:SetScript("OnShow", DynamicScrollBar);
        container.ScrollFrame:HookScript("OnScrollRangeChanged", DynamicScrollBar);
        
        container.GetScrollChild = GetScrollChild;
        container.SetScrollChild = SetScrollChild;

        return container, child;
    end
end

do
    local function TitleBar_SetWidth(self)
        local bar = self:GetParent();
        local width = self:GetStringWidth() + 34;
        width = (width > 150 and width) or 150;
        bar:SetWidth(width);
    end

    function gui:AddTitleBar(frame, text)
        frame.title_bar = tk.CreateFrame("Frame", nil, frame);
        frame.title_bar:SetSize(260, 31);
        frame.title_bar:SetFrameLevel(50);
        frame.title_bar:SetPoint("TOPLEFT", frame, "TOPLEFT", -7, 11);
        frame.title_bar.bg = frame.title_bar:CreateTexture("ARTWORK");
        frame.title_bar.bg:SetTexture(tk.Constants.MEDIA.."dialog_box\\TitleBar");
        frame.title_bar.bg:SetAllPoints(true);
        frame.title_bar.text = frame.title_bar:CreateFontString(nil, "ARTWORK", "GameFontHighlight");

        frame.title_bar.text:SetSize(260, 31);
        frame.title_bar.text:SetPoint("LEFT", frame.title_bar.bg, "LEFT", 10, 0.5);
        frame.title_bar.text:SetJustifyH("LEFT");
        tk:MakeMovable(frame, frame.title_bar);
        tk:SetThemeColor(frame.title_bar.bg);

        tk.hooksecurefunc(frame.title_bar.text, "SetText", TitleBar_SetWidth);
        frame.title_bar.text:SetText(text);
    end
end

function gui:AddResizer(frame)
    frame.dragger = tk.CreateFrame("Button", nil, frame);
    frame.dragger:SetSize(28, 28);
    frame.dragger:SetFrameLevel(50);
    frame.dragger:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 2);
    frame.dragger:SetNormalTexture(tk.Constants.MEDIA.."dialog_box\\DragRegion", "BLEND");
    frame.dragger:SetHighlightTexture(tk.Constants.MEDIA.."dialog_box\\DragRegion", "ADD");
    tk:MakeResizable(frame, frame.dragger);
    tk:SetThemeColor(frame.dragger:GetNormalTexture());
    tk:SetThemeColor(frame.dragger:GetHighlightTexture());
end

function gui:AddCloseButton(frame, OnHide)
    frame.close_btn = tk.CreateFrame("Button", nil, frame);
    frame.close_btn:SetSize(28, 24);
    frame.close_btn:SetFrameLevel(50);
    frame.close_btn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1);
    frame.close_btn:SetNormalTexture(tk.Constants.MEDIA.."dialog_box\\CloseButton", "BLEND");
    frame.close_btn:SetHighlightTexture(tk.Constants.MEDIA.."dialog_box\\CloseButton", "ADD");
    tk:SetThemeColor(frame.close_btn);
    local group = frame:CreateAnimationGroup();
    group.a1 = group:CreateAnimation("Translation");
    group.a1:SetSmoothing("OUT");
    group.a1:SetDuration(0.3);
    group.a1:SetOffset(0, 10);
    group.a2 = group:CreateAnimation("Alpha");
    group.a2:SetSmoothing("OUT");
    group.a2:SetDuration(0.3);
    group.a2:SetFromAlpha(1);
    group.a2:SetToAlpha(-1);
    group:SetScript("OnFinished", function()
        if (OnHide) then OnHide(); else frame:Hide(); end
    end);
    frame.close_btn:SetScript("OnClick", function(self)
        group:Play();
        tk.PlaySound(tk.Constants.CLICK);
    end);
end

function gui:AddArrow(frame, direction, center)
    direction = direction or "UP";
    direction = direction:upper();

    frame.arrow = tk.CreateFrame("Frame", nil, frame);
    frame.arrow:SetSize(30, 24);
    frame.arrow.bg = frame.arrow:CreateTexture(nil, "ARTWORK");
    frame.arrow.bg:SetTexture(tk.Constants.MEDIA.."other\\arrow");
    frame.arrow.bg:SetAllPoints(true);
    tk:SetThemeColor(frame.arrow.bg);

    if (center) then
        frame.arrow:SetPoint("CENTER");
    end
    if (direction ~= "UP") then
        if (direction == "DOWN") then
            frame.arrow.bg:SetTexCoord(0, 1, 1, 0);
            if (not center) then frame.arrow:SetPoint("TOP", frame, "BOTTOM", 0, -2); end
        end
    end
end

------------------------
-- Panel Prototype
------------------------
local Panel = tk:CreateProtectedPrototype("Panel", true);
local Cell = tk:CreateProtectedPrototype("Cell", true);
local DynamicFrame = tk:CreateProtectedPrototype("DynamicFrame", true);
local Group = tk:CreateProtectedPrototype("Group");

local private = {};

-- adjusts the size of all squares
function private:OnSizeChanged(data)
    local total_fixed_width = data.fixed_info and data.fixed_info.width.total or 0;
    local total_fixed_height = data.fixed_info and data.fixed_info.height.total or 0;
    local num_fixed_columns = data.fixed_info and data.fixed_info.width.columns or 0;
    local num_fixed_rows = data.fixed_info and data.fixed_info.height.rows or 0;

    local width = (data.frame:GetWidth() - total_fixed_width) / (data.width - num_fixed_columns);
    local height = (data.frame:GetHeight() - total_fixed_height) / (data.height - num_fixed_rows);

    for id, square in data.grid:Iterate() do
        local rowNum = tk.math.ceil(id / data.width);
        local columnNum = id % (data.width);
        columnNum = (columnNum == 0 and data.width) or columnNum;

        local rowscale = data.rowscale[rowNum] or 1;
        local columnscale = data.columnscale[columnNum] or 1;

        square:SetWidth(square.fixed_width or (width * columnscale));
        square:SetHeight(square.fixed_height or (height * rowscale));
    end
end

function private:SetupGrid(data)
    local squares = {data.grid:Unpack()};
    for id, square in data.grid:Iterate() do
        if (id == 1) then
            square:SetPoint("TOPLEFT", data.frame, "TOPLEFT");
        elseif (id % data.width == 1 or data.width == 1) then
            local anchor = squares[id - data.width];
            square:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT");
        else
            local anchor = squares[id - 1];
            square:SetPoint("TOPLEFT", anchor, "TOPRIGHT");
        end
    end
    self:OnSizeChanged(data);
end

function private:GetCoords(position, width, height)
    for row = 1, height do
        for column = 1, width do
            if ((row - 1) * width + column == position) then
                return column, row;
            end
        end
    end
end

-- Builds a table of indexes representing each grid square on the panel and
-- marks indexes as true if a cell is positioned over that square
function private:BuildPattern(start_pos, end_pos, width, height, pattern)
    local start_column, start_row = self:GetCoords(start_pos, width, height);
    local end_column, end_row = self:GetCoords(end_pos, width, height);
    for id = start_pos, end_pos do
        local x, y = self:GetCoords(id, width, height);
        if (x >= start_column and x <= end_column) then
            if (y >= start_row and y <= end_row) then
                pattern[id] = true;
            end
        end
    end
end

-- reanchors all cells to the correct squares passed on their positions
function private:AnchorCells(data)
    if (not data.cells or not data.grid) then return false end
    local squares = {data.grid:Unpack()};
    local taken_squares = {};
    for id, cell in data.cells:Iterate() do
        if (not squares[id]) then break; end
        while (taken_squares[id]) do id = id + 1; end

        local cell_data = Cell.Static:GetData(cell);
        local cell_width = cell_data.width or 1;
        local cell_height = cell_data.height or 1;

        local end_square = (id - 1) + ((cell_height - 1) * data.width) + cell_width;
        if (end_square > #squares or end_square <= 0) then end_square = #squares; end
        cell_data.start_anchor = squares[id];
        cell_data.end_anchor = squares[end_square];

        private:BuildPattern(id, end_square, data.width, data.height, taken_squares);

        -- place frame:
        local top = (cell_data.insets and cell_data.insets.top) or 0;
        local right = (cell_data.insets and cell_data.insets.right) or 0;
        local bottom = (cell_data.insets and cell_data.insets.bottom) or 0;
        local left = (cell_data.insets and cell_data.insets.left) or 0;
        cell_data.frame:SetPoint("TOPLEFT", cell_data.start_anchor, "TOPLEFT", left, -top);
        cell_data.frame:SetPoint("BOTTOMRIGHT", cell_data.end_anchor, "BOTTOMRIGHT", -right, bottom);
        cell_data.frame:SetFrameLevel(3);
        cell_data.frame:SetParent(squares[id]);
    end
end

-- @constructor
function gui:CreatePanel(frame, name)
    frame = frame or tk.CreateFrame("Frame", name, tk.UIParent);
    local panel = Panel({
        frame = frame,
        grid = tk:CreateLinkedList(),
        rowscale = {},
        columnscale = {}
    });

    local data = Panel.Static:GetData(panel);
    frame:HookScript("OnSizeChanged", function()
        private:OnSizeChanged(data);
    end);

    return panel;
end

function Panel:SetDimensions(data, width, height)
    local squares = {data.grid:Unpack()};
    data.width = width;
    data.height = height;
    local i = 1;
    while (true) do
        if (i <= height * width) then
            if (not squares[i]) then
                local f = tk:PopFrame("Frame", data.frame);
                if (data.devMode) then
                    tk:SetBackground(f, tk.math.random(), tk.math.random(), tk.math.random(), 0.2);
                    f.t = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
                    f.t:SetPoint("CENTER");
                    f.t:SetText(i);
                end
                data.grid:AddToBack(f);
            end
        elseif (squares[i]) then
            data.grid:Remove(squares[i]);
        else break; end
        i = i + 1;
    end
    private:SetupGrid(data);
end

function Panel:SetDevMode(data, devMode)  -- shows or hides the red frame info overlays
    data.devMode = devMode;
end

function Panel:AddCells(data, ...)
    data.cells = data.cells or tk:CreateLinkedList();
    for _, cell in tk:IterateArgs(...) do
        data.cells:AddToBack(cell);
        Cell.Static:GetData(cell).panel = self;
    end

    -- if cell.content is not fixed! then SetScript("OnSizeChanged")
    private:AnchorCells(data);
end

function Panel:GetCells(data, n)
    if (not data.cells) then return false; end
    return data.cells:Unpack(n);
end

------------------------
-- Cell Prototype
------------------------
-- @constructor
function Panel:CreateCell(data, frame)
    frame = frame or tk:PopFrame("Frame");
    frame:SetParent(data.frame);
    if (data.devMode) then
        tk:SetBackground(frame, 1, 0, 0, 0.4);
        frame:SetBackdrop({
            edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
            edgeSize = 16
        });
    end
    return Cell(nil, frame);
end

function Cell:SetDimensions(data, width, height)
    data.width = width;
    data.height = height;
    if (data.panel) then
        private:AnchorCells(Panel.Static:GetData(data.panel));
    end
end

function Cell:SetInsets(data, ...)
    local args = {...};
    if (#args == 1) then
        data.insets = {
            top = args[1],
            right = args[1],
            bottom = args[1],
            left = args[1]
        };
    elseif (#args == 2) then
        data.insets = {
            top = args[1],
            right = args[2],
            bottom = args[1],
            left = args[2]
        };
    elseif (#args >= 4) then
        data.insets = {
            top = args[1],
            right = args[2],
            bottom = args[3],
            left = args[4]
        };
    end
    if (data.start_anchor and data.end_anchor) then
        data.frame:SetPoint("TOPLEFT", data.start_anchor, "TOPLEFT", data.insets.left, -data.insets.top);
        data.frame:SetPoint("TOPLEFT", data.end_anchor, "TOPLEFT", -data.insets.right, data.insets.bottom);
    end
end

-- TODO: This method is experimental. It breaks the order of cells!
-- TODO: Positions should be fixed onces set
function Cell:Destroy(data)
    Panel.Static:GetData(data.panel).cells:Remove(self);
    tk:PushFrame(data.frame);
    data.frame = nil;
    if (data.panel) then
        private:AnchorCells(Panel.Static:GetData(data.panel));
    end
    data.panel = nil;
end

function Cell:GetPanel(data)
    return data.panel;
end


-------------------------------------------
-- Group Prototype (for Rows and Columns)
-------------------------------------------
do
    local function GetGroup(num, group_type, panel)
        local data = Panel.Static:GetData(panel);
        if (not data.grid) then return false; end
        local squares = {};
        for position, square in data.grid:Iterate() do
            local column, row = private:GetCoords(position, data.width, data.height);
            if ((group_type == "row" and row == num) or (group_type == "column" and column == num)) then
                tk.table.insert(squares, square);
            end
        end
        return Group({
            squares = tk:CreateLinkedList(tk.unpack(squares)),
            type = group_type,
            num = num,
            panel = panel
        });
    end

    -- @constructor
    function Panel:GetRow(_, row_num)
        return GetGroup(row_num, "row", self);
    end

    -- @constructor
    function Panel:GetColumn(_, column_num)
        return GetGroup(column_num, "column", self);
    end
end

function Group:SetScale(data, scale)
    local panel_data = Panel.Static:GetData(data.panel);
    if (data.type == "row") then
        panel_data.rowscale[data.num] = scale;
    elseif (data.type == "column") then
        panel_data.columnscale[data.num] = scale;
    end
    if (panel_data.grid) then
        private:OnSizeChanged(panel_data);
    end
end

function Group:SetFixed(data, value)
    local panel_data = Panel.Static:GetData(data.panel);
    if (value and not panel_data.fixed_info) then
        panel_data.fixed_info = {width = {}, height = {}};
    end
    for position, square in panel_data.grid:Iterate() do
        local column, row = private:GetCoords(position, panel_data.width, panel_data.height);
        if (data.type == "column" and column == data.num) then
            square.fixed_width = value;
        elseif (data.type == "row" and row == data.num) then
            square.fixed_height = value;
        end
    end
    if (data.type == "column") then
        panel_data.fixed_info.width.total = (panel_data.fixed_info.width.total or 0) + value;
        panel_data.fixed_info.width.columns = (panel_data.fixed_info.width.columns or 0) + 1;
    elseif (data.type == "row") then
        panel_data.fixed_info.height.total = (panel_data.fixed_info.height.total or 0) + value;
        panel_data.fixed_info.height.rows = (panel_data.fixed_info.height.rows or 0) + 1;
    end
    if (panel_data.grid) then
        private:OnSizeChanged(panel_data);
    end
end

---------------------------
-- DynamicFrame Prototype
---------------------------
do
    -- need to show scroll bar if height is too much!
    --local children = {}; use EmptyTable and some MoveToTable function for better performance

    local function OnSizeChanged(self, width, height)
        width = tk.math.ceil(width);
        local scrollChild = self:GetScrollChild();
        local anchor = tk.select(1, scrollChild:GetChildren());
        if (not anchor) then return; end

        local totalRowWidth = 0; -- used to make new rows
        local largestHeightInPreviousRow = 0; -- used to position new rows with correct Y Offset away from previous row
        local totalHeight = 0; -- used to dynamically set the ScrollChild's height so that is can be visible
        local previousChild;
        --local lastRowChildren = tk.Constants.EmptyTableStack:Pop();

        for id, child in tk:IterateArgs(scrollChild:GetChildren()) do
            child:ClearAllPoints();
            totalRowWidth = totalRowWidth + child:GetWidth();
            if (id ~= 1) then
                totalRowWidth = totalRowWidth + self.spacing;
            end
            if ((totalRowWidth) > (width - self.padding * 2) or id == 1) then
                -- NEW ROW!
                if (id == 1) then
                    child:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", self.padding, -self.padding);
                    totalHeight = totalHeight + self.padding;
                else
                    local yOffset = (largestHeightInPreviousRow - anchor:GetHeight());
                    yOffset = ((yOffset > 0 and yOffset) or 0) + self.spacing;
                    child:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -(yOffset));
                    totalHeight = totalHeight + self.spacing;
                    anchor = child;
                end
                totalRowWidth = child:GetWidth();
                totalHeight = totalHeight + largestHeightInPreviousRow;
                largestHeightInPreviousRow = child:GetHeight();
            else
                child:SetPoint("TOPLEFT", previousChild, "TOPRIGHT", self.spacing, 0);
                if (child:GetHeight() > largestHeightInPreviousRow) then
                    largestHeightInPreviousRow = child:GetHeight();
                end
            end
            previousChild = child;
            --lastRowChildren[#lastRowChildren + 1] = child;
        end
        totalHeight = totalHeight + largestHeightInPreviousRow + self.padding;
        totalHeight = (totalHeight > 0 and totalHeight) or 10;
        totalHeight = tk.math.floor(totalHeight + 0.5);
        --tk.Constants.EmptyTableStack:Push(lastRowChildren);

        -- update ScrollChild Height dynamically:
        scrollChild:SetHeight(totalHeight);
        if (self.parentScrollFrame) then
            local parent = self.parentScrollFrame;
            OnSizeChanged(parent, parent:GetWidth(), parent:GetHeight());
        end
    end

    -- @constructor
    function gui:CreateDynamicFrame(parent, spacing, padding)
        local scroller, scrollChild = gui:CreateScrollFrame(parent, nil, padding); --tk:PopFrame("ScrollFrame", parent);
        scroller:HookScript("OnSizeChanged", OnSizeChanged);
        scroller.spacing = spacing or 4;
        scroller.padding = padding or 4;
        return DynamicFrame({scrollChild = scrollChild}, scroller);
    end

    -- adds children to ScrollChild of the ScrollFrame
    function DynamicFrame:AddChildren(data, ...)
        local width, height = data.frame:GetSize();
        if (width == 0 and height == 0) then
            data.frame:SetSize(tk.UIParent:GetWidth(), tk.UIParent:GetHeight());
        end
        for _, child in tk:IterateArgs(...) do
            child:SetParent(data.scrollChild);
        end
        OnSizeChanged(data.frame, data.frame:GetWidth(), data.frame:GetHeight());
    end
end

function DynamicFrame:GetChildren(data, n, rawget)
    return data.scrollChild:GetChildren();
end

-- TODO
function DynamicFrame:RemoveChild(data, child) end

---------------------------
-- DropDownMenu Prototype
---------------------------
local DropDownMenu = tk:CreateProtectedPrototype("DropDownMenu", true);
DropDownMenu.MAX_HEIGHT = 354;

do
    local dropdowns = {};

    local function FoldAll(exception)
        for i, dropdown in tk.ipairs(dropdowns) do
            if ((not exception) or (exception and exception ~= dropdown)) then
                local data = DropDownMenu.Static:GetData(dropdown);
                data.expanded = false;
                data.frame.child:Hide();
                if (data.direction == "DOWN") then
                    data.frame.btn.arrow:SetTexCoord(0, 1, 0.2, 1);
                elseif (data.direction == "UP") then
                    data.frame.btn.arrow:SetTexCoord(1, 0, 1, 0.2);
                end
            end
        end
        if (not exception and DropDownMenu.menu) then
            DropDownMenu.menu:Hide();
        end
    end

    function gui:FoldAllDropDownMenus() FoldAll(); end

    local function OnClick(self)
        local data = DropDownMenu.Static:GetData(self.dropdown);
        DropDownMenu.menu:SetFrameStrata("TOOLTIP");

        self.dropdown:Toggle(not data.expanded);
        FoldAll(self.dropdown);
    end

    local function OnSizeChanged(self, _, height)
        self:SetWidth(height);
    end

    -- @constructor
    function gui:CreateDropDown(parent, direction)
        local r, g, b = tk:GetThemeColor();

        if (not DropDownMenu.menu) then
            DropDownMenu.menu = gui:CreateScrollFrame(tk.UIParent, "MUI_DropDownMenu");
            DropDownMenu.menu:Hide();
            DropDownMenu.menu:SetBackdrop(tk.Constants.backdrop);
            tk:SetBackground(DropDownMenu.menu, 0, 0, 0, 0.9);
            tk.table.insert(UISpecialFrames, "MUI_DropDownMenu");
            DropDownMenu.menu:SetBackdropBorderColor(r * 0.7, g * 0.7, b * 0.7);
            DropDownMenu.menu:SetScript("OnHide", FoldAll);
        end

        direction = direction or "DOWN";
        direction = direction:upper();
        parent = parent or tk.UIParent;

        local frame = tk:PopFrame("Frame", parent);
        frame:SetSize(200, 30);

        local header = tk:PopFrame("Frame", frame);
        header:SetPoint("TOPLEFT");
        header.bg = tk:SetBackground(header, tk.Constants.MEDIA.."mui_bar");
        header.bg:SetVertexColor(r * 0.7, g * 0.7, b * 0.7, 0.6);
        header:SetBackdrop(tk.Constants.backdrop);
        header:SetBackdropBorderColor(r * 0.7, g * 0.7, b * 0.6);
        frame.btn = self:CreateButton(frame);
        frame.btn:SetSize(30, 30);
        frame.btn:SetPoint("TOPRIGHT", frame, "TOPRIGHT");
        frame.btn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT");
        frame.btn:SetScript("OnSizeChanged", OnSizeChanged);
        frame.btn.arrow = frame.btn:CreateTexture(nil, "OVERLAY");
        frame.btn.arrow:SetTexture(tk.Constants.MEDIA.."reskin\\arrow_down");
        frame.btn.arrow:SetAllPoints(true);
        frame.child = tk:PopFrame("Frame", DropDownMenu.menu);
        tk:SetFullWidth(frame.child);
        frame.btn.child = frame.child; -- needed for OnClick
        frame.btn:SetScript("OnClick", OnClick);
        header:SetPoint("BOTTOMRIGHT", frame.btn, "BOTTOMLEFT", -2, 0);

        if (direction == "DOWN") then
            frame.btn.arrow:SetTexCoord(0, 1, 0.2, 1);
        elseif (direction == "UP") then
            frame.btn.arrow:SetTexCoord(1, 0, 1, 0.2);
        end

        local slideController = tk:CreateSlideController(DropDownMenu.menu);
        slideController:SetMinHeight(1);
        slideController:OnEndRetract(function(self, frame)
            frame:Hide();
        end);

        frame.btn.dropdown = DropDownMenu({
            header = header,
            direction = direction,
            slideController = slideController
        }, frame);

        tk.table.insert(dropdowns, frame.btn.dropdown);
        frame.btn.dropdown.menu = DropDownMenu.menu;

        return frame.btn.dropdown;
    end
end

function DropDownMenu:SetToolTip(data, tooltip)
    if (not data.header.tooltip) then
        data.header:SetScript("OnEnter", ToolTip_OnEnter);
        data.header:SetScript("OnLeave", ToolTip_OnLeave);
    end
    data.header.tooltip = tooltip;
end

function DropDownMenu:SetThemeColor(data)
    local r, g, b = tk:GetThemeColor();

    data.header.bg:SetVertexColor(r, g, b, 0.6);
    DropDownMenu.menu:SetBackdropBorderColor(r, g, b);
    data.header:SetBackdropBorderColor(r, g, b);
    data.frame.btn.normal:SetVertexColor(r, g, b, 0.6);
    data.frame.btn.highlight:SetVertexColor(r, g, b, 0.7);
    data.frame.btn:SetBackdropBorderColor(r, g, b);
    data.frame.btn.arrow:SetAlpha(1);

    for id, o in tk.ipairs(data.list) do
        o:GetNormalTexture():SetColorTexture(r, g, b, 0.4);
        o:GetHighlightTexture():SetColorTexture(r, g, b, 0.4);
    end

    if (data.label) then
        data.label:SetTextColor(1, 1, 1);
    end
end

-- tooltip means that the tooltip should be the same as the label
function DropDownMenu:SetLabel(data, text, tooltip)
    if (not data.label) then
        data.label = data.header:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        data.label:SetPoint("LEFT", 10, 0);
        data.label:SetPoint("RIGHT", -10, 0);
        data.label:SetWordWrap(false);
        data.label:SetJustifyH("LEFT");
    end

    data.label:SetText(text);
    if (not data.header.custom) then
        if (tooltip) then
            self:SetToolTip(tooltip);
            data.header.custom = true;
        else
            self:SetToolTip(text);
        end
    end
end

function DropDownMenu:GetLabel(data)
    return data.label:GetText();
end

function DropDownMenu:RemoveOption(data, value)
    local option;
    for id, o in tk.ipairs(data.list) do
        if (o.value == value) then
            option = o;
            tk.table.remove(data.list, id);
            break;
        end
    end
    if (not option) then return false; end
    tk:PushFrame(option);

    local height = 30;
    local child = data.frame.child;
    for id, o in tk.ipairs(data.list) do
        o:ClearAllPoints();
        if (id == 1) then
            if (data.direction == "DOWN") then
                o:SetPoint("TOPLEFT", 2, -2);
                o:SetPoint("TOPRIGHT", -2, -2);
            elseif (data.direction == "UP") then
                o:SetPoint("BOTTOMLEFT", 2, 2);
                o:SetPoint("BOTTOMRIGHT", -2, 2);
            end
        else
            if (data.direction == "DOWN") then
                o:SetPoint("TOPLEFT", data.list[id - 1], "BOTTOMLEFT", 0, -1);
                o:SetPoint("TOPRIGHT", data.list[id - 1], "BOTTOMRIGHT", 0, -1);
            elseif (data.direction == "UP") then
                o:SetPoint("BOTTOMLEFT", data.list[id - 1], "TOPLEFT", 0, 1);
                o:SetPoint("BOTTOMRIGHT", data.list[id - 1], "TOPRIGHT", 0, 1);
            end
            height = height + 27;
        end
    end
    data.scroll_height = height;
    child:SetHeight(height);

    if (DropDownMenu.menu:IsShown()) then
        DropDownMenu.menu:SetHeight(height);
    end
    return true;
end

function DropDownMenu:GetOption(data, value)
    for id, o in tk.ipairs(data.list) do
        if (o.value == value) then
            return o;
        end
    end
end

function DropDownMenu:GetNumOptions(data)
    return #data.list;
end

function DropDownMenu:AddOption(data, label, func, value, ...)
    value = value or label;
    local r, g, b = tk:GetThemeColor();
    data.list = data.list or {};

    local child = data.frame.child;
    local o = tk:PopFrame("Button", child);
    local height = 30;
    if (#data.list == 0) then
        if (data.direction == "DOWN") then
            o:SetPoint("TOPLEFT", 2, -2);
            o:SetPoint("TOPRIGHT", -2, -2);
        elseif (data.direction == "UP") then
            o:SetPoint("BOTTOMLEFT", 2, 2);
            o:SetPoint("BOTTOMRIGHT", -2, 2);
        end
    else
        if (data.direction == "DOWN") then
            o:SetPoint("TOPLEFT", data.list[#data.list], "BOTTOMLEFT", 0, -1);
            o:SetPoint("TOPRIGHT", data.list[#data.list], "BOTTOMRIGHT", 0, -1);
        elseif (data.direction == "UP") then
            o:SetPoint("BOTTOMLEFT", data.list[#data.list], "TOPLEFT", 0, 1);
            o:SetPoint("BOTTOMRIGHT", data.list[#data.list], "TOPRIGHT", 0, 1);
        end
        height = child:GetHeight() + 27;
    end
    data.scroll_height = height;
    child:SetHeight(height);

    o.value = value;
    tk.table.insert(data.list, o);

    o:SetHeight(26);
    o:SetNormalFontObject("GameFontHighlight");
    o:SetText(label);
    o:GetFontString():ClearAllPoints();
    o:GetFontString():SetPoint("LEFT", 10, 0);
    o:GetFontString():SetPoint("RIGHT", -10, 0);
    o:GetFontString():SetWordWrap(false);
    o:GetFontString():SetJustifyH("LEFT");

    o:SetNormalTexture(1);
    o:GetNormalTexture():SetColorTexture(r * 0.7, g * 0.7, b * 0.7, 0.4);
    o:SetHighlightTexture(1);
    o:GetHighlightTexture():SetColorTexture(r * 0.7, g * 0.7, b * 0.7, 0.4);

    local id = #data.list;
    local args = {...};
    o:SetScript("OnClick", function()
        self:SetLabel(label, true);
        self:Toggle(false);
        func(self, value, tk.unpack(args));
    end);
    return o;
end

function DropDownMenu:SetEnabled(data, enabled)
    data.frame.btn:SetEnabled(enabled);
    if (enabled) then
        self:SetThemeColor();
    else
        DropDownMenu.menu:Hide();
        self:Toggle(false);
        data.header.bg:SetVertexColor(0.2, 0.2, 0.2, 0.6);
        DropDownMenu.menu:SetBackdropBorderColor(0.2, 0.2, 0.2);
        data.header:SetBackdropBorderColor(0.2, 0.2, 0.2);
        data.frame.btn.normal:SetVertexColor(0.2, 0.2, 0.2, 0.6);
        data.frame.btn.highlight:SetVertexColor(0.2, 0.2, 0.2, 0.7);
        data.frame.btn:SetBackdropBorderColor(0.2, 0.2, 0.2);
        data.frame.btn.arrow:SetAlpha(0.5);
        if (data.label) then
            data.label:SetTextColor(0.5, 0.5, 0.5);
        end
    end
end

function DropDownMenu:Toggle(data, show)
    if (not data.list) then return; end
    local step = #data.list * 4;
    step = (step > 20) and step or 20;
    step = (step < 30) and step or 30;

    DropDownMenu.menu:ClearAllPoints();
    if (data.direction == "DOWN") then
        DropDownMenu.menu:SetPoint("TOPLEFT", data.frame, "BOTTOMLEFT", 0, -2);
        DropDownMenu.menu:SetPoint("TOPRIGHT", data.frame, "BOTTOMRIGHT", 0, -2);
    elseif (data.direction == "UP") then
        DropDownMenu.menu:SetPoint("BOTTOMLEFT", data.frame, "TOPLEFT", 0, 2);
        DropDownMenu.menu:SetPoint("BOTTOMRIGHT", data.frame, "TOPRIGHT", 0, 2);
    end

    if (show) then
        local max_height = (data.scroll_height < DropDownMenu.MAX_HEIGHT) and
                data.scroll_height or DropDownMenu.MAX_HEIGHT;

        DropDownMenu.menu:SetScrollChild(data.frame.child);
        DropDownMenu.menu:SetHeight(1);

        data.frame.child:Show();
        data.slideController:SetMaxHeight(max_height);

        if (data.direction == "DOWN") then
            data.frame.btn.arrow:SetTexCoord(1, 0, 1, 0.2);
        elseif (data.direction == "UP") then
            data.frame.btn.arrow:SetTexCoord(0, 1, 0.2, 1);
        end
    else
        if (data.direction == "DOWN") then
            data.frame.btn.arrow:SetTexCoord(0, 1, 0.2, 1);
        elseif (data.direction == "UP") then
            data.frame.btn.arrow:SetTexCoord(1, 0, 1, 0.2);
        end
    end

    data.slideController:SetStepValue(step);
    data.slideController:Start();
    tk.PlaySound(tk.Constants.CLICK);
    data.expanded = show;
end