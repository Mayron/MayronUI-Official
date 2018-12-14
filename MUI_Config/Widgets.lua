--luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, _, _, gui, obj = MayronUI:GetCoreComponents();

local C_ConfigModule = namespace.C_ConfigModule;
local configModule = MayronUI:ImportModule("Config");
local Engine = obj:Import("MayronUI.Engine");

local WidgetHandlers = {};
namespace.WidgetHandlers = WidgetHandlers;

-- create container to wrap around a child element
Engine:DefineParams("table", "table");
function C_ConfigModule:CreateElementContainerFrame(_, widget, childData, parent)
    local container = tk:PopFrame("Frame", parent);

    container:SetSize(childData.width or widget:GetWidth(), childData.height or widget:GetHeight());
    container.widget = widget;

    widget:SetParent(container);

    if (childData.name and tk:ValueIsEither(childData.type, "slider", "dropdown", "textfield")) then

        container.name = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        container.name:SetPoint("TOPLEFT", 0, 0);
        container.name:SetText(childData.name);

        container:SetHeight(container:GetHeight() + container.name:GetStringHeight() + 5);

        widget:SetPoint("TOPLEFT", container.name, "BOTTOMLEFT", 0, -5);

        if (childData.type == "slider") then
            container.name:SetPoint("TOPLEFT", 10, -5);
            container:SetWidth(container:GetWidth() + 20);
        end
    else
        widget:SetPoint("LEFT");
    end

    return container;
end

local function GetValue(configTable, attributeName, ...)
    if (configTable[attributeName] ~= nil) then
        return configTable[attributeName];
    end

    local funcName = tk.Strings:Concat(
        "Get", attributeName:gsub("^%l", string.upper)
    );

    if (type(configTable[funcName]) == "function") then
        return configTable[funcName](configTable, ...);
    end
end

--------------
-- Sub Menu
--------------
WidgetHandlers.submenu = {};

function WidgetHandlers.submenu:Run(parent, submenuConfigTable)
    local btn = tk:PopFrame("Button", parent);
    btn:SetSize(250, 60);

    btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    btn.text:SetText(submenuConfigTable.name);
    btn.text:SetJustifyH("LEFT");
    btn.text:SetPoint("TOPLEFT", 10, 0);
    btn.text:SetPoint("BOTTOMRIGHT");

    btn.normal = tk:SetBackground(btn, 1, 1, 1, 0);
    btn.highlight = tk:SetBackground(btn, 1, 1, 1, 0);
    tk:ApplyThemeColor(btn.normal, btn.highlight);

    btn.normal:SetAlpha(0.3);
    btn.highlight:SetAlpha(0.3);

    btn:SetNormalTexture(btn.normal);
    btn:SetHighlightTexture(btn.highlight);

    btn.ConfigTable = submenuConfigTable;
    btn.type = "submenu";
    btn.name = submenuConfigTable.name;

    btn:SetScript("OnClick", namespace.MenuButton_OnClick);

    return btn;
end

---------------------
-- Loop (non-widget)
---------------------
WidgetHandlers.loop = {};

-- should return a table of children created during the loop
function WidgetHandlers.loop:Run(_, loopConfigTable)
    local children = tk.Tables:PopWrapper();

    if (loopConfigTable.loops) then
        -- rather than args, you specify the number of times to loop
        for id = 1, loopConfigTable.loops do
            children[id] = loopConfigTable.func(id);
        end

    elseif (loopConfigTable.args) then
        for id, arg in tk.ipairs(loopConfigTable.args) do
            -- func returns the children data to be loaded

            if (type(arg) == "table") then
                -- for each iteration, there might be many args to be injected into the loop function
                children[id] = loopConfigTable.func(id, tk.unpack(arg));
            else
                children[id] = loopConfigTable.func(id, arg);
            end
        end
    end

    return children;
end

------------------
-- Check Button
------------------
WidgetHandlers.check = {};

function WidgetHandlers.check:Run(parent, widgetConfigTable, value)
    local cb = gui:CreateCheckButton(parent, widgetConfigTable.name,
        widgetConfigTable.type == "radio", widgetConfigTable.tooltip);

    cb.btn:SetChecked(value);
    cb.btn:SetScript("OnClick", function(self)
        configModule:SetDatabaseValue(self, widgetConfigTable, self:GetChecked());
    end);

    if (widgetConfigTable.width) then
        cb:SetWidth(widgetConfigTable.width);
    else
        cb:SetWidth(cb.btn:GetWidth() + 20 + cb.btn.text:GetStringWidth());
    end
    if (widgetConfigTable.height) then
        cb:SetHeight(widgetConfigTable.height);
    end
    return cb;
end

----------------
-- Title Frame
----------------
WidgetHandlers.title = {};

-- supported title config attributes:
-- name - the container name (a visible fontstring that shows in the GUI)
-- paddingTop - space between top of background and top of name
-- paddingBottom - space between bottom of background and bottom of name
-- width - overrides using a full width (100% width of the container) with a fixed width value

function WidgetHandlers.title:Run(parent, widgetConfigTable)
    local container = tk:PopFrame("Frame", parent);
    container.text = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    container.text:SetText(widgetConfigTable.name);

    local topPadding = (widgetConfigTable.paddingTop or 10);
    local bottomPadding = (widgetConfigTable.paddingBottom or 10);
    local textHeight = container.text:GetStringHeight();
    local height = 20 + textHeight + topPadding + bottomPadding;

    container:SetHeight(height);

    if (widgetConfigTable.width) then
        container:SetWidth(widgetConfigTable.width);
    else
        tk:SetFullWidth(container, 10);
    end

    local background = tk:SetBackground(container, 0, 0, 0, 0.2);

    --TODO: Surely, (0, 0) should be including topPadding, if topPadding is
    --TODO: included as part of the height...
    -- background:SetPoint("TOPLEFT", 0, -topPadding);
    -- background:SetPoint("BOTTOMRIGHT", 0, bottomPadding);

    -- TODO: Should I not just use: (?)
    background:SetAllPoints(true);

    container.text:SetAllPoints(background);

    return container;
end

--------------
-- Slider
--------------
WidgetHandlers.slider = {};

function WidgetHandlers.slider:Run(parent, widgetConfigTable, value)
    local slider = tk.CreateFrame("Slider", nil, parent, "OptionsSliderTemplate");
    slider.tooltipText = widgetConfigTable.tooltip;
    slider:SetMinMaxValues(widgetConfigTable.min, widgetConfigTable.max);
    slider:SetValueStep(widgetConfigTable.step);
    slider:SetObeyStepOnDrag(true);

    slider:SetValue(value or widgetConfigTable.min);
    slider.Value = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
    slider.Value:SetPoint("BOTTOM", 0, -8);
    slider.Value:SetText(value or widgetConfigTable.min);

    slider.Low:SetText(widgetConfigTable.min);
    slider.Low:ClearAllPoints();
    slider.Low:SetPoint("BOTTOMLEFT", 5, -8);
    slider.High:SetText(widgetConfigTable.max);
    slider.High:ClearAllPoints();
    slider.High:SetPoint("BOTTOMRIGHT", -5, -8);

    slider:SetSize(widgetConfigTable.width or 200, 20);
    slider:SetScript("OnValueChanged", function(self, sliderValue)
        sliderValue = tk.math.floor(sliderValue + 0.5);
        self.Value:SetText(sliderValue);
        configModule:SetDatabaseValue(self, widgetConfigTable, sliderValue);
    end);

    slider = configModule:CreateElementContainerFrame(slider, widgetConfigTable, parent);
    slider:SetHeight(slider:GetHeight() + 5); -- make room for value text
    return slider;
end

--------------
-- Divider
--------------
WidgetHandlers.divider = {};

function WidgetHandlers.divider:Run(parent, widgetConfigTable)
    local divider = tk:PopFrame("Frame", parent);
    divider:SetHeight(widgetConfigTable.height or 1);

    tk:SetFullWidth(divider, 10);

    return divider;
end

-------------------
-- Drop Down Menu
-------------------
local function DropDown_OnSelectedValue(widget, widgetConfigTable, value)
    configModule:SetDatabaseValue(widget, widgetConfigTable, value);
end

WidgetHandlers.dropdown = {};

function WidgetHandlers.dropdown:Run(parent, widgetConfigTable, value)
    local dropdown = gui:CreateDropDown(tk.Constants.AddOnStyle, parent);
    local options = widgetConfigTable.options or widgetConfigTable:GetOptions();

    for key, dropDownValue in pairs(options) do
        local option = dropdown:AddOption(key, DropDown_OnSelectedValue, widgetConfigTable, dropDownValue);

        if (widgetConfigTable.fontPicker) then
            option:GetFontString():SetFont(tk.Constants.LSM:Fetch("font", key), 11);
        end
    end

    dropdown:SetLabel(value, widgetConfigTable.tooltip);

    return configModule:CreateElementContainerFrame(dropdown, widgetConfigTable, parent);
end

--------------
-- Button
--------------
WidgetHandlers.button = {};

function WidgetHandlers.button:Run(parent, widgetConfigTable)
    local button = gui:CreateButton(tk.Constants.AddOnStyle, parent,
        widgetConfigTable.name, nil, widgetConfigTable.tooltip);

    if (widgetConfigTable.width) then
        button:SetWidth(widgetConfigTable.width);
    end

    if (widgetConfigTable.height) then
        button:SetHeight(widgetConfigTable.height);
    end

    button:SetScript("OnClick", function(self)
        widgetConfigTable.OnClick(self, widgetConfigTable);
    end);

    return button;
end

-----------------
-- Frame
-----------------
WidgetHandlers.frame = {};

function WidgetHandlers.frame:Run(parent, widgetConfigTable)
    local frame;

    if (widgetConfigTable.GetFrame) then
        frame = widgetConfigTable:GetFrame();
    else
        frame = widgetConfigTable.frame or tk:PopFrame("Frame", parent);
    end

    if (widgetConfigTable.width) then
        frame:SetWidth(widgetConfigTable.width);
    else
        tk:SetFullWidth(frame, 20);
    end

    frame:SetHeight(widgetConfigTable.height or 60);
    tk:SetBackground(frame, 0, 0, 0, 0.2);

    return frame;
end

-----------------
-- Color Picker
-----------------
WidgetHandlers.color = {};

local function ShowColorPicker(r, g, b, a, changedCallback)
    _G.ColorPickerFrame:SetColorRGB(r, g, b);
    _G.ColorPickerFrame.hasOpacity = (a ~= nil);
    _G.ColorPickerFrame.opacity = a;
    _G.ColorPickerFrame.previousValues = {r, g, b, a};

    _G.ColorPickerFrame.func = changedCallback;
    _G.ColorPickerFrame.opacityFunc = changedCallback;
    _G.ColorPickerFrame.cancelFunc = changedCallback;

    -- Need to run the OnShow handler:
    _G.ColorPickerFrame:Hide();
    _G.ColorPickerFrame:Show();
end

function WidgetHandlers.color:Run(parent, widgetConfigTable, value)
    local container = tk:PopFrame("Button", parent);

    container.name = container:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    container.name:SetText(widgetConfigTable.name);
    container.name:SetJustifyH("LEFT");

    container:SetSize(
        widgetConfigTable.width or (container.name:GetStringWidth() + 44),
        widgetConfigTable.height or 30);

    container.square = container:CreateTexture(nil, "BACKGROUND");
    container.square:SetSize(30, 30);
    container.square:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch");

    container.color = container:CreateTexture(nil, "OVERLAY");
    container.color:SetSize(16, 16);

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
            c.r, c.g, c.b = _G.ColorPickerFrame:GetColorRGB();

            if (_G.ColorPickerFrame.hasOpacity) then
                c.a = _G.OpacitySliderFrame:GetValue();
                c.a = 1 - c.a;
            end
        end

        configModule:SetDatabaseValue(container, widgetConfigTable, c);
        container.color:SetColorTexture(c.r, c.g, c.b);
    end

    container:SetScript("OnClick", function()
        local refreshedValue = configModule:GetDatabaseValue(widgetConfigTable);
        local a = refreshedValue.a and (1 - refreshedValue.a);
        ShowColorPicker(refreshedValue.r, refreshedValue.g, refreshedValue.b, a, container.func);
    end);

    container.square:SetPoint("LEFT");
    container.color:SetPoint("CENTER", container.square, "CENTER");
    container.name:SetPoint("LEFT", container.square, "RIGHT", 4, 0);
    return container;
end

---------------
-- Text Field
---------------

local function TextField_OnTextChanged(self, value, _, configTable)
    -- perform validation based on valueType
    local isValue = true;

    -- ensure database stores a number, instead of a string containing a number
    value = tonumber(value) or value;

    if (configTable.valueType == "number" and configTable.min ~= nil) then
        isValue = value >= configTable.min;
    end

    if (not isValue) then
        self:ApplyPreviousText();
    else
        self:SetText(value);
        configModule:SetDatabaseValue(self:GetFrame(), configTable, value);
    end
end

WidgetHandlers.textfield = {};

-- supported textield config attributes:
-- tooltip - the fontstring text to display
-- width - Can be used to change the font object. Supports "header" only (for now).
-- height - overrides the default horizontal justification ("LEFT")
-- valueType - overrides the default height of 30
-- min - overrides the default fixed with value (the width of the fontstring)

function WidgetHandlers.textfield:Run(parent, widgetConfigTable, value)
    local textField = gui:CreateTextField(tk.Constants.AddOnStyle, widgetConfigTable.tooltip, parent);
    textField:SetText(value or "");
    textField:SetSize(widgetConfigTable.width or 150, widgetConfigTable.height or 26);

    -- passes in textField (not data.editBox);
    textField:OnTextChanged(TextField_OnTextChanged, widgetConfigTable);

    return configModule:CreateElementContainerFrame(textField, widgetConfigTable, parent);
end

----------------
-- Font String
----------------
WidgetHandlers.fontstring = {};

-- supported fontstring config attributes:
-- content - the fontstring text to display
-- subType - Can be used to change the font object. Supports "header" only (for now).
-- justify - overrides the default horizontal justification ("LEFT")
-- height - overrides the default height of 30
-- width - overrides the default fixed with value (the width of the fontstring)
-- fullWidth - overrides the default fixed width value (and ignores width attribute if used)

function WidgetHandlers.fontstring:Run(parent, widgetConfigTable)
    local container = tk:PopFrame("Frame", parent);

    container.content = container:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    container.content:SetAllPoints(true);
    container.content:SetWordWrap(true);

    if (widgetConfigTable.justify) then
        container.content:SetJustifyH(widgetConfigTable.justify);
    else
        container.content:SetJustifyH("LEFT");
    end

    if (widgetConfigTable.subtype) then
        if (widgetConfigTable.subtype == "header") then
            --TODO: What about gold or yellow for a warning message?
            container.content:SetFontObject("MUI_FontLarge");
        end
    end

    container:SetHeight(widgetConfigTable.height or 30);

    local content = GetValue(widgetConfigTable, "content");
    container.content:SetText(content);

    if (widgetConfigTable.fullWidth) then
        tk:SetFullWidth(container, 10);

    elseif (widgetConfigTable.width) then
        container:SetWidth(widgetConfigTable.width);

    else
        container:SetWidth(container.content:GetStringWidth());
    end

    return container;
end