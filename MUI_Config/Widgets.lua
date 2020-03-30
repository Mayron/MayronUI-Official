--luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local _G, MayronUI = _G, _G.MayronUI;
local tk, _, _, gui, obj = MayronUI:GetCoreComponents();
local configModule = MayronUI:ImportModule("ConfigModule"); ---@type ConfigModule

local unpack, string, pairs, tonumber = _G.unpack, _G.string, _G.pairs, _G.tonumber;
local CreateFrame = _G.CreateFrame;

local WidgetHandlers = {};
namespace.WidgetHandlers = WidgetHandlers;

-- create container to wrap around a child element
local function CreateElementContainerFrame(widget, widgetTable, parent)
    local container = tk:PopFrame("Frame", parent);

    container:SetSize(widgetTable.width or widget:GetWidth(), widgetTable.height or widget:GetHeight());
    container.widget = widget; -- this is needed to access the widget from the container which is passed to some config functions (i.e. OnLoad)
    widget.configContainer = container; -- mwidget must have access to container to use properties, such as SetValue() for dropdown menus

    if (widgetTable.name and tk:ValueIsEither(widgetTable.type, "slider", "dropdown", "textfield")) then
        container.name = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        container.name:SetPoint("TOPLEFT", 0, 0);
        container.name:SetText(widgetTable.name);

        container:SetHeight(container:GetHeight() + container.name:GetStringHeight() + 5);
        widget:SetPoint("TOPLEFT", container.name, "BOTTOMLEFT", 0, -5);
    else
        widget:SetPoint("LEFT");
    end

    return container;
end

local function GetAttribute(configTable, attributeName, ...)
    if (configTable[attributeName] ~= nil) then
        return configTable[attributeName];
    end

    local funcName = tk.Strings:Concat("Get", (attributeName:gsub("^%l", string.upper)));

    if (obj:IsFunction(configTable[funcName])) then
        return configTable[funcName](configTable, ...);
    end

    obj:Error("Required attribute '%s' missing for %s widget in config table '%s' using database path '%s'",
        attributeName, configTable.type, configTable.name, configTable.dbPath);
end

--------------
-- Sub Menu
--------------
function WidgetHandlers.submenu(parent, submenuConfigTable)
    local btn = tk:PopFrame("Button", parent);
    btn:SetSize(250, 60);

    btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    btn.text:SetText(submenuConfigTable.name);
    btn.text:SetJustifyH("LEFT");
    btn.text:SetPoint("TOPLEFT", 10, 0);
    btn.text:SetPoint("BOTTOMRIGHT");

    local filePath = tk:GetAssetFilePath("Textures\\Widgets\\Solid");

    btn.normal = tk:SetBackground(btn, filePath);
    btn.highlight = tk:SetBackground(btn, filePath);

    tk:ApplyThemeColor(btn.normal, btn.highlight);

    btn.normal:SetAlpha(0.3);
    btn.highlight:SetAlpha(0.3);

    btn:SetNormalTexture(btn.normal);
    btn:SetHighlightTexture(btn.highlight);

    btn.configTable = submenuConfigTable;
    btn.type = "submenu";
    btn.name = submenuConfigTable.name;

    btn:SetScript("OnClick", namespace.MenuButton_OnClick);

    return btn;
end

---------------------
-- Loop (non-widget)
---------------------
-- supported textfield config attributes:
-- loops - a number for the total number of loops to call the function
-- args - an index table (no keys) of values to pass
-- func - the function to call with the loop id and arg (if using args)

-- you can only use either the "loops" or "args" attribute, but not both!
-- the function should return 1 widget per execution

-- should return a table of children created during the loop
function WidgetHandlers.loop(_, loopConfigTable)
    local children = obj:PopTable();

    if (loopConfigTable.loops) then
        -- rather than args, you specify the number of times to loop
        for id = 1, loopConfigTable.loops do
            children[id] = loopConfigTable.func(id);
        end

    elseif (loopConfigTable.args) then
        for id, arg in _G.ipairs(loopConfigTable.args) do
            -- func returns the children data to be loaded
            children[id] = loopConfigTable.func(id, arg);
        end
    end

    tk.Tables:CleanIndexes(children);

    return children;
end

----------------
-- Condition
----------------
function WidgetHandlers.condition(_, widgetTable)
    local result = widgetTable.func();

    if (result) then
        return widgetTable.onTrue;
    else
        return widgetTable.onFalse;
    end
end

------------------
-- Check Button
------------------
local function CheckButton_OnClick(self)
    configModule:SetDatabaseValue(self:GetParent(), self:GetChecked());
end

function WidgetHandlers.check(parent, widgetTable, value)
    local cbContainer = gui:CreateCheckButton(
        parent, widgetTable.name,
        widgetTable.type == "radio",
        widgetTable.tooltip);

    cbContainer.btn:SetChecked(value);
    cbContainer.btn:SetScript("OnClick", CheckButton_OnClick);

    if (widgetTable.width) then
        cbContainer:SetWidth(widgetTable.width);
    else
        cbContainer:SetWidth(cbContainer.btn:GetWidth() + 20 + cbContainer.btn.text:GetStringWidth());
    end

    if (widgetTable.height) then
        cbContainer:SetHeight(widgetTable.height);
    end

    if (obj:IsFunction(widgetTable.enabled)) then
        local enabled = widgetTable:enabled();
        cbContainer.btn:SetEnabled(enabled);

    elseif (widgetTable.enabled ~= nil) then
        cbContainer.btn:SetEnabled(widgetTable.enabled);

    else
        cbContainer.btn:SetEnabled(true);
    end

    return cbContainer;
end

----------------
-- Title Frame
----------------
-- supported title config attributes:
-- name - the container name (a visible fontstring that shows in the GUI)
-- paddingTop - space between top of background and top of name
-- paddingBottom - space between bottom of background and bottom of name
-- width - overrides using a full width (100% width of the container) with a fixed width value

function WidgetHandlers.title(parent, widgetTable)
    local container = tk:PopFrame("Frame", parent);
    container.text = container:CreateFontString(nil, "OVERLAY", "MUI_FontLarge");
    tk:SetFontSize(container.text, 14);
    container.text:SetText(widgetTable.name);

    local marginTop = widgetTable.marginTop or 10;
    local marginBottom = widgetTable.marginBottom or 10;
    local topPadding = (widgetTable.paddingTop or (marginTop + 10));
    local bottomPadding = (widgetTable.paddingBottom or (marginBottom + 10));
    local textHeight = container.text:GetStringHeight();
    local height = textHeight + topPadding + bottomPadding;

    container:SetHeight(height);

    if (widgetTable.width) then
        container:SetWidth(widgetTable.width);
    else
        tk:SetFullWidth(container, 14);
    end

    local background = tk:SetBackground(container, 0, 0, 0, 0.2);
    background:ClearAllPoints();
    background:SetPoint("TOPLEFT", 0, -marginTop);
    background:SetPoint("BOTTOMRIGHT", 0, marginBottom);
    container.text:SetAllPoints(background);

    return container;
end

--------------
-- Slider
--------------
local function Slider_OnValueChanged(self, value)
    value = tk.Numbers:ToPrecision(value, self.precision);
    self.Value:SetText(value);
    configModule:SetDatabaseValue(self.configContainer, value);
end

local function Slider_OnEnable(self)
    self:SetAlpha(1);
end

local function Slider_OnDisable(self)
    self:SetAlpha(0.7);
end

function WidgetHandlers.slider(parent, widgetTable, value)
    local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate");

    slider.tooltipText = widgetTable.tooltip;
    slider.precision = widgetTable.precision or 1;
    slider:SetMinMaxValues(widgetTable.min, widgetTable.max);
    slider:SetValueStep(widgetTable.step or 1);
    slider:SetObeyStepOnDrag(true);

    slider:SetValue(value or widgetTable.min);
    slider.Value = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
    slider.Value:SetPoint("BOTTOM", 0, -8);
    slider.Value:SetText(value or widgetTable.min);

    slider.Low:SetText(widgetTable.min);
    slider.Low:ClearAllPoints();
    slider.Low:SetPoint("BOTTOMLEFT", 9, -8);
    slider.High:SetText(widgetTable.max);
    slider.High:ClearAllPoints();
    slider.High:SetPoint("BOTTOMRIGHT", -5, -8);

    slider:SetSize(widgetTable.width or 150, 20);

    slider:SetScript("OnValueChanged", Slider_OnValueChanged);
    slider:SetScript("OnEnable", Slider_OnEnable);
    slider:SetScript("OnDisable", Slider_OnDisable);

    local container = CreateElementContainerFrame(slider, widgetTable, parent);
    container:SetHeight(container:GetHeight() + 20); -- make room for value text
    return container;
end

--------------
-- Divider
--------------
function WidgetHandlers.divider(parent, widgetTable)
    local divider = tk:PopFrame("Frame", parent);
    divider:SetHeight(widgetTable.height or 1);

    tk:SetFullWidth(divider, 10);

    return divider;
end

-------------------
-- Drop Down Menu
-------------------
local function DropDown_OnSelectedValue(self, value)
    configModule:SetDatabaseValue(self.configContainer, value);
end

function WidgetHandlers.dropdown(parent, widgetTable, value)
    local container = gui:CreateDropDown(tk.Constants.AddOnStyle, parent);

    if (widgetTable.width) then
        container:SetWidth(widgetTable.width);
    end

    container.dropdown:SetLabel(tostring(value));

    if (widgetTable.disableSorting) then
        container.dropdown:SetSortingEnabled(false);
    end

    local options = GetAttribute(widgetTable, "options");

    for key, dropDownValue in pairs(options) do
        local option;

        if (tonumber(key) or widgetTable.labels == "values") then
            option = container.dropdown:AddOption(dropDownValue, DropDown_OnSelectedValue, dropDownValue);
        else
            option = container.dropdown:AddOption(key, DropDown_OnSelectedValue, dropDownValue);

            if (dropDownValue == value) then
                container.dropdown:SetLabel(key);
            end
        end

        if (widgetTable.fontPicker) then
            option:GetFontString():SetFont(tk.Constants.LSM:Fetch("font", key), 11);
        end
    end

    if (widgetTable.tooltip) then
        container.dropdown:SetTooltip(widgetTable.tooltip);
    end

    if (widgetTable.disabledTooltip) then
        container.dropdown:SetDisabledTooltip(widgetTable.disabledTooltip);
    end

    return CreateElementContainerFrame(container, widgetTable, parent);
end

--------------
-- Button
--------------
do
    local function Button_OnClick(self)
        if (obj:IsTable(self.data)) then
            self.OnClick(self, unpack(self.data));
        else
            self.OnClick(self);
        end
    end

    function WidgetHandlers.button(parent, widgetTable)
        local button = gui:CreateButton(tk.Constants.AddOnStyle, parent,
            widgetTable.name, nil, widgetTable.tooltip);

        if (widgetTable.width) then
            button:SetWidth(widgetTable.width);
        end

        if (widgetTable.height) then
            button:SetHeight(widgetTable.height);
        end

        button:SetScript("OnClick", Button_OnClick);

        return button;
    end
end

-----------------
-- Frame
-----------------
function WidgetHandlers.frame(parent, widgetTable)
    local frame;

    if (widgetTable.GetFrame) then
        frame = widgetTable:GetFrame();
    else
        frame = widgetTable.frame or tk:PopFrame("Frame", parent);
    end

    if (widgetTable.width) then
        frame:SetWidth(widgetTable.width);
    else
        tk:SetFullWidth(frame, 20);
    end

    frame.originalHeight = widgetTable.height or 60; -- needed for fontstring resizing
    -- frame:SetScript("OnSizeChanged", Frame_OnSizeChanged);

    frame:SetHeight(frame.originalHeight);
    tk:SetBackground(frame, 0, 0, 0, 0.2);

    return frame;
end

-----------------
-- Color Picker
-----------------
local function ColorWidget_SaveValue(container, r, g, b, a)
    if (container.useIndexes) then
        container.value[1] = r;
        container.value[2] = g;
        container.value[3] = b;
        container.value[4] = a;
    else
        container.value.r = r;
        container.value.g = g;
        container.value.b = b;
        container.value.a = a;
    end

    container.r = r;
    container.g = g;
    container.b = b;

    if (container.hasOpacity) then
        container.opacity = 1.0 - a;
    end

    configModule:SetDatabaseValue(container, container.value);
end

local function ColorWidget_OnClick(self)
    self.loaded = nil;
    _G.OpenColorPicker(self);

    if (self.hasOpacity) then
        _G.OpacitySliderFrame:SetValue(self.opacity);
    end
end

local function ColorWidget_OnValueChanged()
    local container = _G.ColorPickerFrame.extraInfo;

    if (_G.ColorPickerFrame:IsShown() or not container.loaded) then
        -- do not update database until OkayButton clicked
        container.loaded = true;
        return;
    end

    -- OkayButton was clicked so update database:
    local r, g, b = _G.ColorPickerFrame:GetColorRGB();
    local a;

    if (container.hasOpacity) then
        a = 1.0 - _G.OpacitySliderFrame:GetValue();
    end

    ColorWidget_SaveValue(container, r, g, b, a);
    container.color:SetColorTexture(r, g, b, a or 1);

    if (container.requiresReload) then
        configModule:ShowReloadMessage();
    end
end

function WidgetHandlers.color(parent, widgetTable, value)
    local container = tk:PopFrame("Button", parent);
    container:SetScript("OnClick", ColorWidget_OnClick);

    -- create widget elements:
    container.square = container:CreateTexture(nil, "BACKGROUND");
    container.square:SetSize(30, 30);
    container.square:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch");
    container.square:SetPoint("LEFT");

    container.name = container:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    container.name:SetText(widgetTable.name);
    container.name:SetJustifyH("LEFT");
    container.name:SetPoint("LEFT", container.square, "RIGHT", 4, 0);

    container.color = container:CreateTexture(nil, "OVERLAY");
    container.color:SetSize(16, 16);
    container.color:SetPoint("CENTER", container.square, "CENTER");

    container:SetSize(
        widgetTable.width or (container.name:GetStringWidth() + 44),
        widgetTable.height or 30);

    -- info options:
    container.extraInfo = container;
    container.swatchFunc = ColorWidget_OnValueChanged;

    container.value = value;
    container.r = value.r or value[1] or 0;
    container.g = value.g or value[2] or 0;
    container.b = value.b or value[3] or 0;

    if (widgetTable.hasOpacity) then
        container.opacity = 1.0 - (value.a or value[4] or 0);
        container.hasOpacity = true;

        local blackBackground = container:CreateTexture(nil, "BORDER");
        blackBackground:SetSize(16, 16);
        blackBackground:SetPoint("CENTER", container.square, "CENTER");
        blackBackground:SetColorTexture(0, 0, 0);

        container.color:SetColorTexture(container.r, container.g, container.b, 1.0 - container.opacity);
    else
        container.color:SetColorTexture(container.r, container.g, container.b);
    end

    return container;
end

---------------
-- Text Field
---------------
local function TextField_OnTextChanged(textfield, value, _, container)
    -- perform validation based on valueType
    local isValue = true;

    -- ensure database stores a number, instead of a string containing a number
    value = tonumber(value) or value;

    if (container.valueType == "number") then

        if (not obj:IsNumber(value)) then
            isValue = false;
        else
            if (container.min and value < container.min) then
                isValue = false;
            end
            if (container.max and value > container.max) then
                isValue = false;
            end
        end
    end

    if (not isValue) then
        textfield:ApplyPreviousText();
    else
        textfield:SetText(value);
        configModule:SetDatabaseValue(container, value);
    end
end

-- supported textield config attributes:
-- tooltip - the fontstring text to display
-- width - Can be used to change the font object. Supports "header" only (for now).
-- height - overrides the default horizontal justification ("LEFT")
-- valueType - overrides the default height of 30
-- min - minimum value allowed
-- max - maximum value allowed

function WidgetHandlers.textfield(parent, widgetTable, value)
    local textField = gui:CreateTextField(tk.Constants.AddOnStyle, widgetTable.tooltip, parent);

    textField:SetText((value and tostring(value)) or "");
    local container = CreateElementContainerFrame(textField, widgetTable, parent);

    -- passes in textField (not data.editBox);
    textField:OnTextChanged(TextField_OnTextChanged, container);

    return container;
end

----------------
-- Font String
----------------
local function FontString_OnSizeChanged(self)
    if (self.runningScript) then
        return;
    end

    self.runningScript = true;
    local expectedHeight = self.content:GetStringHeight() + 20;

    if (expectedHeight ~= self:GetHeight()) then
        self:SetHeight(expectedHeight);
    end

    local parent = self:GetParent();

    if (parent.originalHeight and parent.originalHeight < expectedHeight and expectedHeight ~= parent:GetHeight()) then
        parent:SetHeight(expectedHeight);
    end

    self.runningScript = nil;
end

-- supported fontstring config attributes:
-- content - the fontstring text to display
-- subType - Can be used to change the font object. Supports "header" only (for now).
-- justify - overrides the default horizontal justification ("LEFT")
-- height - overrides the default height of 30
-- width - overrides the default width (and ignores the fixedWidth attribute) with a specific width
-- fixedWidth - overrides the default container width with the natural width of the fontstring

function WidgetHandlers.fontstring(parent, widgetTable)
    local container = tk:PopFrame("Frame", parent);

    container.content = container:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    container.content:SetAllPoints(true);
    container.content:SetWordWrap(true);

    if (widgetTable.justify) then
        container.content:SetJustifyH(widgetTable.justify);
    else
        container.content:SetJustifyH("LEFT");
    end

    if (widgetTable.subtype) then
        if (widgetTable.subtype == "header") then
            container.content:SetFontObject("MUI_FontLarge");
        end
    end

    local content = GetAttribute(widgetTable, "content");
    container.content:SetText(content);

    if (widgetTable.height) then
        container:SetHeight(widgetTable.height);
    else
        container:SetHeight(container.content:GetStringHeight());
        container:SetScript("OnSizeChanged", FontString_OnSizeChanged);
    end

    if (widgetTable.width) then
        container:SetWidth(widgetTable.width);
    elseif (widgetTable.fixedWidth) then
        container:SetWidth(container.content:GetStringWidth());
    else
        tk:SetFullWidth(container, 20);
    end

    return container;
end