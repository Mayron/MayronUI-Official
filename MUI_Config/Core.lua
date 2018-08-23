------------------------
-- Setup namespaces
------------------------
local _, config = ...;
local core = MayronUI:ImportModule("MUI_Core");
local gui = core.GUIBuilder;
local tk = core.Toolkit;
local db = core.Database;
local rs = core.Reskinner;
local private = {};

MayronUI:RegisterModule("Config", config);

local L = LibStub ("AceLocale-3.0"):GetLocale ("MayronUI");
local ColorPickerFrame, OpacitySliderFrame, ReloadUI = ColorPickerFrame, OpacitySliderFrame, ReloadUI;

function config:Show()
    if (not MayronUI:IsInstalled()) then 
        tk:Print("Please install the UI and try again.");
        return; 
    end

    self:ScanForData();

    if (not self:IsLoaded()) then
        private:SetupMenu();
    else
        private.menu:Show();
    end
end

function config:IsLoaded()
    return not not private.menu;
end

------------------------
-- private functions
------------------------
function private.ToolTip_OnEnter(frame)
    GameTooltip:SetOwner(frame, "ANCHOR_RIGHT", 0, 2);
    GameTooltip:AddLine(frame.tooltip);
    GameTooltip:Show();
end

function private.ToolTip_OnLeave(frame)
    GameTooltip:Hide();
end

-- @constructor
function private:CreateMenuContainer(widget, child_data)
    local container = tk:PopFrame("Frame", private.parent);

    container:SetSize(child_data.width or widget:GetWidth(), child_data.height or widget:GetHeight());
    widget:SetParent(container);
    container.widget = widget;

    if ((child_data.type == "slider" or child_data.type == "dropdown"
            or child_data.type == "textfield") and child_data.name) then

        container.name = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        container.name:SetPoint("TOPLEFT", 0, -5);
        container.name:SetText(child_data.name);
        container:SetHeight(container:GetHeight() + container.name:GetStringHeight() + 15);
        widget:SetPoint("TOPLEFT", container.name, "BOTTOMLEFT", 0, -5);

        if (child_data.type == "slider") then
            container.name:SetPoint("TOPLEFT", 10, -5);
            container:SetWidth(container:GetWidth() + 20);
        end
    else
        widget:SetPoint("LEFT");
    end
    return container;
end

local function UpdateConfig(widget, child_data, value)
    if (child_data.SetValue) then
        local path = private:GetPath(child_data);
        if (not path) then
            child_data.SetValue(value, widget);
        else
            local old_value = db:ParsePathValue(path);
            child_data.SetValue(path, old_value, value, widget); -- custom way to set the value
        end
    else
        tk.assert(child_data.db_path, child_data.name.." is missing db_path value.");
        db:SetPathValue(child_data.db_path, value);
    end

    if (child_data.requires_reload) then
        config:ShowReloadMessage();
    elseif (child_data.requires_restart) then
        config:ShowRestartMessage();
    end

    -- find the module and call the "OnConfigUpdate" function
    if (child_data.module or config.submenu_data.module and child_data.db_path) then
        local module = MayronUI:ImportModule(child_data.module or config.submenu_data.module);
        if (module.OnConfigUpdate) then
            local list = tk:ConvertPathToKeys(child_data.db_path);
            module:OnConfigUpdate(list, value);
        end
    end
end

function private:GetPath(child_data)
    if (not child_data.db_path) then return; end
    if (tk.type(child_data.db_path) == "function") then
        return child_data.db_path();
    else
        return child_data.db_path;
    end
end

function private:GetValue(child_data)
    local path = private:GetPath(child_data);
    local value;
    if (not path) then
        value = child_data.GetValue and child_data.GetValue();
    elseif (child_data.type == "color") then
        value = {};
        value.r = db:ParsePathValue(path..".r");
        value.g = db:ParsePathValue(path..".g");
        value.b = db:ParsePathValue(path..".b");
        value.a = db:ParsePathValue(path..".a");
    else
        value = db:ParsePathValue(path);
        if (child_data.GetValue) then
            value = child_data.GetValue(path, value);
        else
            return value;
        end
    end
    return value;
end

--------------
-- Sub Menu
--------------
private.submenu = {};
function private.submenu:Run(child_data)
    local btn = tk.CreateFrame("Button", nil, private.parent);
    btn:SetSize(250, 60);

    btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    btn.text:SetText(child_data.name);
    btn.text:SetJustifyH("LEFT");
    btn.text:SetPoint("TOPLEFT", 10, 0);
    btn.text:SetPoint("BOTTOMRIGHT");

    btn.normal = tk:SetBackground(btn, 1, 1, 1, 0);
    btn.highlight = tk:SetBackground(btn, 1, 1, 1, 0);
    tk:SetThemeColor(0.3, btn.normal, btn.highlight);

    btn:SetNormalTexture(btn.normal);
    btn:SetHighlightTexture(btn.highlight);

    btn:SetScript("OnClick", function()
        private.history:AddToBack(config.submenu_data);
        config:SetSubMenu(child_data);
        private.menu_name:SetText(child_data.name);
        private.menu.back:SetEnabled(true);
        tk.PlaySound(tk.Constants.CLICK);
    end);
    return btn;
end

---------------------
-- Loop (non-widget)
---------------------
private.loop = {};
function private.loop:Run(child_data)
    self.data = self.data or {};
    tk:EmptyTable(self.data);

    if (child_data.loops) then
        for id = 1, child_data.loops do
            self.data[id] = child_data.func(id);
        end

    elseif (child_data.args) then
        for id, data in tk.ipairs(child_data.args) do
            -- func returns the children data to be loaded
            if (tk.type(data) == "table" and not data.GetObjectType) then
                self.data[id] = child_data.func(id, tk.unpack(data));
            else
                self.data[id] = child_data.func(id, data);
            end
        end
    end

    return self.data;
end

------------------
-- Check Button
------------------
private.check = {};
function private.check:Run(child_data)
    local cb = gui:CreateCheckButton(private.parent, child_data.name,
        child_data.type == "radio", child_data.tooltip);

    cb.btn:SetChecked(private:GetValue(child_data));
    cb.btn:SetScript("OnClick", function(self)
        UpdateConfig(self, child_data, self:GetChecked());
    end);

    if (child_data.width) then
        cb:SetWidth(child_data.width);
    else
        cb:SetWidth(cb.btn:GetWidth() + 20 + cb.btn.text:GetStringWidth());
    end
    if (child_data.height) then
        cb:SetHeight(child_data.height);
    end
    return cb;
end

----------------
-- Title Frame
----------------
private.title = {};
function private.title:Run(child_data)
    local height = 20 + (child_data.padding_top or 10) + (child_data.padding_bottom or 10);
    local f = tk:PopFrame("Frame", private.parent);
    f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    f.text:SetText(child_data.name);
    f:SetHeight(f.text:GetStringHeight() + height);

    local bg = tk:SetBackground(f, 0, 0, 0, 0.2);
    bg:SetPoint("TOPLEFT", 0, -(child_data.padding_top or 10));
    bg:SetPoint("BOTTOMRIGHT", 0, (child_data.padding_bottom or 10));
    f.text:SetAllPoints(bg);
    return f;
end

--------------
-- Slider
--------------
private.slider = {};
function private.slider:Run(child_data)
    local slider = tk.CreateFrame("Slider", nil, private.parent, "OptionsSliderTemplate");
    slider.tooltipText = child_data.tooltip;
    slider:SetMinMaxValues(child_data.min, child_data.max);
    slider:SetValueStep(child_data.step);
    slider:SetObeyStepOnDrag(true);

    local value = private:GetValue(child_data);
    slider:SetValue(value or child_data.min);
    slider.Value = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
    slider.Value:SetPoint("BOTTOM", 0, -8);
    slider.Value:SetText(value or child_data.min);

    slider.Low:SetText(child_data.min);
    slider.Low:ClearAllPoints();
    slider.Low:SetPoint("BOTTOMLEFT", 5, -8);
    slider.High:SetText(child_data.max);
    slider.High:ClearAllPoints();
    slider.High:SetPoint("BOTTOMRIGHT", -5, -8);

    slider:SetSize(child_data.width or 200, 20);
    slider:SetScript("OnValueChanged", function(self, value)
        value = tk.math.floor(value + 0.5);
        self.Value:SetText(value);
        UpdateConfig(self, child_data, value);
    end);

    slider = private:CreateMenuContainer(slider, child_data);
    slider:SetHeight(slider:GetHeight() + 5); -- make room for value text
    return slider;
end

--------------
-- Divider
--------------
private.divider = {};
function private.divider:Run(child_data)
    local divider = tk:PopFrame("Frame");
    divider:SetHeight(child_data.height or 1);
    return divider;
end

-------------------
-- Drop Down Menu
-------------------
private.dropdown = {};
function private.dropdown:Run(child_data)
    local dropdown = gui:CreateDropDown(private.parent);
    local value = private:GetValue(child_data);
    dropdown:SetLabel(value, child_data.tooltip);
    local options = child_data.options or child_data:GetOptions();
    for _, name in tk.ipairs(options) do
        local option = dropdown:AddOption(name, UpdateConfig, child_data, name);
        if (child_data.font_chooser) then
            option:GetFontString():SetFont(tk.Constants.LSM:Fetch("font", name), 11);
        end
    end
    return private:CreateMenuContainer(dropdown, child_data);
end

--------------
-- Button
--------------
private.button = {};
function private.button:Run(child_data)
    local button = gui:CreateButton(nil, child_data.name);
    if (child_data.width) then
        button:SetWidth(child_data.width);
    end
    if (child_data.height) then
        button:SetHeight(child_data.height);
    end
    button:SetScript("OnClick", function(self)
        child_data.OnClick(self, child_data);
    end);
    return button;
end

-----------------
-- Frame
-----------------
private.frame = {};
function private.frame:Run(child_data)
    local frame = child_data.frame or child_data:GetFrame();
    if (child_data.width) then
        frame:SetWidth(child_data.width);
    else
        tk:SetFullWidth(frame, 10);
    end
    if (child_data.height) then
        frame:SetHeight(child_data.height);
    end
    tk:SetBackground(frame, 0, 0, 0, 0.2);
    return frame;
end

-----------------
-- Color Picker
-----------------
private.color = {};

local function ShowColorPicker(r, g, b, a, changedCallback)
    ColorPickerFrame:SetColorRGB(r, g, b);
    ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
    ColorPickerFrame.previousValues = {r, g, b, a};
    ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc =
    changedCallback, changedCallback, changedCallback;
    ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
    ColorPickerFrame:Show();
end

function private.color:Run(child_data)
    local container = tk.CreateFrame("Button");
    container.name = container:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    container.name:SetText(child_data.name);
    container:SetSize(child_data.width or (container.name:GetStringWidth() + 44), child_data.height or 30);
    container.name:SetJustifyH("LEFT");

    container.square = container:CreateTexture(nil, "BACKGROUND");
    container.square:SetSize(30, 30);
    container.square:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch");

    container.color = container:CreateTexture(nil, "OVERLAY");
    container.color:SetSize(16, 16);

    local value = private:GetValue(child_data);
    container.color:SetColorTexture(
        value and value.r or 0,
        value and value.g or 0,
        value and value.b or 0
    );

    local c = value;
    container.func = function(restore)
        if (restore) then
            c.r, c.g, c.b, c.a = tk.unpack(restore);
        else
            c.r, c.g, c.b = ColorPickerFrame:GetColorRGB();
            if (ColorPickerFrame.hasOpacity) then
                c.a = OpacitySliderFrame:GetValue();
                c.a = 1 - c.a;
            end
        end
        UpdateConfig(container, child_data, c);
        container.color:SetColorTexture(c.r, c.g, c.b);
    end

    container:SetScript("OnClick", function()
        local value = private:GetValue(child_data);
        local a = value.a and (1 - value.a);
        ShowColorPicker(value.r, value.g, value.b, a, container.func);
    end);

    if (child_data.tooltip) then
        container.tooltip = child_data.tooltip;
        container:SetScript("OnEnter", private.ToolTip_OnEnter);
        container:SetScript("OnLeave", private.ToolTip_OnLeave);
    end

    container.square:SetPoint("LEFT");
    container.color:SetPoint("CENTER", container.square, "CENTER");
    container.name:SetPoint("LEFT", container.square, "RIGHT", 4, 0);
    return container;
end

---------------
-- Text Field
---------------
private.textfield = {};
function private.textfield:Run(child_data)
    local container = gui:CreateTextField(child_data.tooltip);
    local value = private:GetValue(child_data);
    container.field:SetText(value or "");
    container.field.previous = value;
    container:SetSize(child_data.width or 150, child_data.height or 26);

    container.field:SetScript("OnEnterPressed", function(self)
        self:ClearFocus();
        local value = tk.tonumber(self:GetText()) or self:GetText();
        if (child_data.value_type and tk.type(value) ~= child_data.value_type) then
            self:SetText(self.previous);
        elseif (child_data.min and child_data.value_type == "number" and value < child_data.min) then
            self:SetText(self.previous);
        else
            self.previous = value;
            UpdateConfig(self, child_data, value);
        end
    end);

    container.field:SetScript("OnEscapePressed", function(self)
        self:ClearFocus();
        self:SetText(self.previous);
    end);

    return private:CreateMenuContainer(container, child_data);
end

----------------
-- Font String
----------------
private.fontstring = {};
function private.fontstring:Run(child_data)
    local divider = tk:PopFrame("Frame");

    divider.content = divider:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    divider.content:SetAllPoints(true);
    divider.content:SetJustifyH("LEFT");
    divider.content:SetWordWrap(true);
    if (child_data.subtype) then
        if (child_data.subtype == "header") then
            divider.content:SetFontObject("MUI_FontLarge");
        end
    end
    divider.content:SetText(child_data.content);
    divider:SetHeight(child_data.height or divider.content:GetStringHeight() + 16);

    return divider;
end

-------------------------------
-------------------------------
function private:LoadChild(child_data, parent_dynamicFrame, submenu_data)
    if (submenu_data.inherit) then
        for key, value in tk.pairs(submenu_data.inherit) do
            if (not child_data[key]) then
                child_data[key] = value;
            end
        end
    end

    -- create the item, return it, add it to children
    if (child_data.type ~= "loop") then
        local type = (child_data.type == "radio" and "check") or child_data.type;
        if (not private[type]) then
            tk:Print(tk.string.format(L["Config type '%s' unsupported!"], type));
            return;
        end
        if (child_data.OnInitialize) then
            child_data.OnInitialize(child_data);
            child_data.OnInitialize = nil;
        end
        if (child_data.enabled == nil or child_data.enabled) then
            local widget = private[type]:Run(child_data);
            if (widget) then
                parent_dynamicFrame:AddChildren(widget);
                if (child_data.dev_mode) then
                    tk:SetBackground(widget, tk.math.random(), tk.math.random(), tk.math.random());
                end
            end
            if (child_data.type == "title" or child_data.type == "divider" or child_data.type == "fontstring") then
                tk:SetFullWidth(widget, 10);
            end
            if (child_data.type == "radio" and child_data.group) then
                submenu_data.groups = submenu_data.groups or {};
                submenu_data.groups[child_data.group] = submenu_data.groups[child_data.group] or {};
                tk.table.insert(submenu_data.groups[child_data.group], widget.btn);
            end
            if (child_data.OnLoad) then
                child_data.OnLoad(child_data, widget);
                child_data.OnLoad = nil;
            end
        end
    else
        -- need to append children_data efficiently
        for _, data in tk.ipairs(private.loop:Run(child_data)) do
            for _, child_data in tk.ipairs(data) do
                private:LoadChild(child_data, parent_dynamicFrame, submenu_data);
            end
        end
    end
end

function private:LoadContent(submenu_data, parent_dynamicFrame)
    self.parent = parent_dynamicFrame:GetFrame();
    if (submenu_data.children) then
        for _, child_data in tk.pairs(submenu_data.children) do
            private:LoadChild(child_data, parent_dynamicFrame, submenu_data);
        end
        if (submenu_data.groups) then
            for _, group in tk.ipairs(submenu_data.groups) do
                tk:GroupCheckButtons(tk.unpack(group));
            end
        end
        submenu_data.groups = nil;
    end
end

function private:SwitchContent(dynamicFrame)
    if (private.dynamicFrame) then
        private.dynamicFrame:Hide();
    end
    private.dynamicFrame = dynamicFrame; -- always a DynamicFrame
    tk.UIFrameFadeIn(private.dynamicFrame:GetFrame(), 0.3, 0, 1);
end

function config:SetSubMenu(submenu_data)
    self.submenu_data = submenu_data;
    if (submenu_data.dynamicFrame) then
        private:SwitchContent(submenu_data.dynamicFrame);
        return;
    end
    -- load the content:
    submenu_data.dynamicFrame = gui:CreateDynamicFrame(self.options:GetFrame(), nil, 10);
    gui:CreateDialogBox(nil, "Low", submenu_data.dynamicFrame:GetFrame());
    submenu_data.dynamicFrame:SetAllPoints(true);

    private:SwitchContent(submenu_data.dynamicFrame);
    private:LoadContent(submenu_data, submenu_data.dynamicFrame);
end

-- show Categories that were not previously registered
function config:UpdateCategories() end

function config:ShowReloadMessage()
    private.reload_warning:SetText(private.reload_warning.reload_message);
end

function config:ShowRestartMessage()
    private.reload_warning:SetText(private.reload_warning.restart_message);
end

function private:SetupMenu()
    print("Setup menu")
    if (self.menu) then return; end
    self.history = tk:CreateLinkedList();
    self.menu = gui:CreateDialogBox(nil, nil, nil, "MUI_Config");
    self.menu:SetFrameStrata("DIALOG");

    self.menu:Hide();
    gui:AddTitleBar(self.menu, "MUI Config");
    gui:AddResizer(self.menu);
    gui:AddCloseButton(self.menu);
    self.menu:SetMinResize(600, 400);
    self.menu:SetMaxResize(1200, 800);
    self.menu:SetSize(800, 500);
    self.menu:SetPoint("CENTER");
    self.menu = gui:CreatePanel(self.menu);
    self.menu:SetDevMode(false); -- shows or hides the red frame info overlays
    self.menu:SetDimensions(2, 3);
    self.menu:GetColumn(1):SetFixed(200);
    self.menu:GetRow(1):SetFixed(80);
    self.menu:GetRow(3):SetFixed(50);
    self.menu:SetScript("OnShow", function(self)
        tk.UIFrameFadeIn(self, 0.3, 0, 1);
    end)

    local topbar = self.menu:CreateCell();
    topbar:SetInsets(25, 14, 2, 10);
    topbar:SetDimensions(2, 1);

    local categories, scrollchild = gui:CreateScrollFrame(self.menu:GetFrame());
    categories.ScrollBar:SetPoint("TOPLEFT", categories.ScrollFrame, "TOPRIGHT", -5, 0);
    categories.ScrollBar:SetPoint("BOTTOMRIGHT", categories.ScrollFrame, "BOTTOMRIGHT", 0, 0);
    categories = self.menu:CreateCell(categories);
    categories:SetInsets(2, 10, 10, 10);
    categories:SetDimensions(1, 2);

    local options = self.menu:CreateCell();
    options:SetInsets(2, 14, 2, 2);
    config.options = options;

    local bottombar = self.menu:CreateCell();
    bottombar:SetInsets(2, 30, 10, 2);
    self.menu:AddCells(topbar, categories, options, bottombar);
    self.reload_warning = bottombar:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    self.reload_warning:SetPoint("LEFT");
    self.reload_warning:SetText("");
    self.reload_warning.reload_message = L["The UI requires reloading to apply changes."];
    self.reload_warning.restart_message = L["Some changes require a client restart to take effect."];

    -- forward and back buttons
    self.menu.back = gui:CreateButton(topbar:GetFrame());
    self.menu.back:SetPoint("LEFT");
    self.menu.back:SetWidth(50);
    self.menu.back.arrow = self.menu.back:CreateTexture(nil, "OVERLAY");
    self.menu.back.arrow:SetTexture(tk.Constants.MEDIA.."other\\arrow_side");
    self.menu.back.arrow:SetSize(16, 14);
    self.menu.back.arrow:SetPoint("CENTER", -1, 0);

    self.menu.back:SetScript("OnClick", function(self)
        local submenu_data = private.history:GetBack();
        private.history:RemoveBack();
        config:SetSubMenu(submenu_data);

        if (private.history:GetSize() == 0) then
            private.menu_name:SetText("");
            self:SetEnabled(false);
        else
            private.menu_name:SetText(submenu_data.name);
        end

        tk.PlaySound(tk.Constants.CLICK);
    end);

    self.menu_name = topbar:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    self.menu_name:SetPoint("LEFT", self.menu.back, "RIGHT", 10, 0);

    tk:SetThemeColor(self.menu.back.arrow);
    self.menu.back:SetEnabled(false);

    self.menu.profiles = gui:CreateButton(topbar:GetFrame(), L["Reload UI"]); -- will change to profiles another time
    self.menu.profiles:SetPoint("RIGHT", topbar:GetFrame(), "RIGHT");
    self.menu.profiles:SetScript("OnClick", function()
        ReloadUI();
        tk.PlaySound(tk.Constants.CLICK);
    end);

    self.menu.installer = gui:CreateButton(topbar:GetFrame(), L["MUI Installer"]);
    self.menu.installer:SetPoint("RIGHT", self.menu.profiles, "LEFT", -10, 0);
    self.menu.installer:SetScript("OnClick", function()
        core.commands["install"]();
        private.menu:Hide();
        tk.PlaySound(tk.Constants.CLICK);
    end);

    self.menu.submenus = {};
    tk:SetFullWidth(scrollchild)

    -- a category is a submenu, but a submenu is not a category
    for id, categoryData in tk.ipairs(config.db) do
        self.menu.submenus[id] = tk.CreateFrame("CheckButton", nil, scrollchild);
        scrollchild:SetHeight((scrollchild:GetHeight() or 0) + 60);

        local f = self.menu.submenus[id];
        f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        f.text:SetText(categoryData.name);
        f.text:SetJustifyH("LEFT");
        f.text:SetPoint("TOPLEFT", 10, 0);
        f.text:SetPoint("BOTTOMRIGHT");

        local normal = tk:SetBackground(f, 1, 1, 1, 0);
        local highlight = tk:SetBackground(f, 1, 1, 1, 0);
        local checked = tk:SetBackground(f, 1, 1, 1, 0);
        tk:SetThemeColor(0.3, normal, highlight);
        tk:SetThemeColor(0.6, checked);

        f:SetSize(250, 60);
        f:SetNormalTexture(normal);
        f:SetHighlightTexture(highlight);
        f:SetCheckedTexture(checked);

        if (id == 1) then
            f:SetPoint("TOPLEFT", scrollchild, "TOPLEFT");
            f:SetPoint("TOPRIGHT", scrollchild, "TOPRIGHT", -10, 0);
        else
            f:SetPoint("TOPLEFT", self.menu.submenus[id - 1], "BOTTOMLEFT", 0, -5);
            f:SetPoint("TOPRIGHT", self.menu.submenus[id - 1], "BOTTOMRIGHT", 0, -5);
            scrollchild:SetHeight(scrollchild:GetHeight() + 5);
        end
        f:SetScript("OnClick", function(self)
            if (not self:GetChecked()) then
                self:SetChecked(true);
                return;
            end
            private.history:Clear();
            private.menu_name:SetText("");
            private.menu.back:SetEnabled(false);
            config:SetSubMenu(categoryData);
            tk.PlaySound(tk.Constants.CLICK);
        end);
        if (id == 1) then
            config:SetSubMenu(categoryData);
            f:SetChecked(true);
        end
    end
    tk:GroupCheckButtons(tk.unpack(self.menu.submenus));
    self.menu:Show();
end