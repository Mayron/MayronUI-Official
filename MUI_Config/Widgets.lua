--luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local _G, MayronUI = _G, _G.MayronUI;
local tk, _, _, gui, obj = MayronUI:GetCoreComponents();
local configModule = MayronUI:ImportModule("ConfigModule"); ---@type ConfigModule

local unpack, string, pairs, tonumber = _G.unpack, _G.string, _G.pairs, _G.tonumber;

local WidgetHandlers = {};
namespace.WidgetHandlers = WidgetHandlers;

-- create container to wrap around a child element
local function CreateElementContainerFrame(widget, childData, parent)
    local container = tk:PopFrame("Frame", parent);

    container:SetSize(childData.width or widget:GetWidth(), childData.height or widget:GetHeight());
    container.widget = widget; -- this is needed to access the widget from the container which is passed to some config functions (i.e. OnLoad)
    widget:SetParent(container);

    if (childData.name and tk:ValueIsEither(childData.type, "slider", "dropdown", "textfield")) then
        container.name = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        container.name:SetPoint("TOPLEFT", 0, 0);
        container.name:SetText(childData.name);

        container:SetHeight(container:GetHeight() + container.name:GetStringHeight() + 5);
        widget:SetPoint("TOPLEFT", container.name, "BOTTOMLEFT", 0, -5);
    else
        widget:SetPoint("LEFT");
    end

    return container;
end

local function GetValue(configTable, attributeName, ...)
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

    btn.normal = tk:SetBackground(btn, 1, 1, 1, 0);
    btn.highlight = tk:SetBackground(btn, 1, 1, 1, 0);
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
-- supported textield config attributes:
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
        for id, arg in tk.ipairs(loopConfigTable.args) do
            -- func returns the children data to be loaded
            children[id] = loopConfigTable.func(id, arg);
        end
    end

    tk.Tables:CleanIndexes(children);

    return children;
end

------------------
-- Check Button
------------------
function WidgetHandlers.check(parent, widgetTable, value)
    local cbContainer = gui:CreateCheckButton(
        parent, widgetTable.name,
        widgetTable.type == "radio",
        widgetTable.tooltip);

    cbContainer.btn:SetChecked(value);
    cbContainer.btn:SetScript("OnClick", function(self)
        configModule:SetDatabaseValue(cbContainer, self:GetChecked());
    end);

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
        tk:SetFullWidth(container, 22);
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
function WidgetHandlers.slider(parent, widgetTable, value)
    local slider = tk.CreateFrame("Slider", nil, parent, "OptionsSliderTemplate");

    slider.tooltipText = widgetTable.tooltip;
    slider:SetMinMaxValues(widgetTable.min, widgetTable.max);
    slider:SetValueStep(widgetTable.step);
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

    slider:SetScript("OnValueChanged", function(self, sliderValue)
        sliderValue = tk.math.floor(sliderValue + 0.5);
        self.Value:SetText(sliderValue);
        configModule:SetDatabaseValue(self, sliderValue);
    end);

    slider = CreateElementContainerFrame(slider, widgetTable, parent);
    slider:SetHeight(slider:GetHeight() + 20); -- make room for value text
    return slider;
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
    configModule:SetDatabaseValue(self:GetParent(), value);
end

function WidgetHandlers.dropdown(parent, widgetTable, value)
    local dropdown = gui:CreateDropDown(tk.Constants.AddOnStyle, parent);
    local options = GetValue(widgetTable, "options");

    for key, dropDownValue in pairs(options) do
        local option;

        if (tonumber(key) or widgetTable.useNumberedKeys) then
            option = dropdown:AddOption(dropDownValue, DropDown_OnSelectedValue, dropDownValue);
        else
            option = dropdown:AddOption(key, DropDown_OnSelectedValue, dropDownValue);
        end

        if (widgetTable.fontPicker) then
            option:GetFontString():SetFont(tk.Constants.LSM:Fetch("font", key), 11);
        end
    end

    dropdown:SetLabel(value);
    dropdown:SetTooltip(widgetTable.tooltip);
    dropdown:SetDisabledTooltip(widgetTable.disabledTooltip);

    return CreateElementContainerFrame(dropdown, widgetTable, parent);
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
local function ShowColorPicker(r, g, b, a, changedCallback)
    _G.ColorPickerFrame.hasOpacity = (a ~= nil);
    _G.ColorPickerFrame.opacity = a;
    _G.ColorPickerFrame.previousValues = obj:PopTable(r, g, b, a);

    _G.ColorPickerFrame.func = changedCallback;
    _G.ColorPickerFrame.opacityFunc = changedCallback;
    _G.ColorPickerFrame.cancelFunc = changedCallback;

    -- Need to run the OnShow handler:
    _G.ColorPickerFrame:Hide();
    _G.ColorPickerFrame:Show();
end

local function ColorPickerOkayButton_OnClick(self)
    local container = self:GetParent().container;

    if (obj:IsTable(container)) then
        container.value:SaveChanges();
    end
end

local function ColorWidget_OnClick(self)
    local r, g, b, a = self.color:GetVertexColor();
    ShowColorPicker(r, g, b, (a and (1 - a)), self.func);
    _G.ColorPickerFrame.container = self;

    if (ColorPickerOkayButton_OnClick) then
        _G.ColorPickerOkayButton:HookScript("OnClick", ColorPickerOkayButton_OnClick);
        _G.ColorPickerOkayButton:HookScript("OnHide", function(self) self.container = nil; end);
        ColorPickerOkayButton_OnClick = nil;
    end
end

local function UpdateValue(useIndexes, value, c)
    if (useIndexes) then
        value[1] = c.r;
        value[2] = c.g;
        value[3] = c.b;
        value[4] = c.a;
    else
        value.r = c.r;
        value.g = c.g;
        value.b = c.b;
        value.a = c.a;
    end

end

function WidgetHandlers.color(parent, widgetTable, value)
    local container = tk:PopFrame("Button", parent);
    value = value:GetTrackedTable();

    container.value = value;

    container.name = container:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    container.name:SetText(widgetTable.name);
    container.name:SetJustifyH("LEFT");

    container:SetSize(
        widgetTable.width or (container.name:GetStringWidth() + 44),
        widgetTable.height or 30);

    container.square = container:CreateTexture(nil, "BACKGROUND");
    container.square:SetSize(30, 30);
    container.square:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch");

    container.color = container:CreateTexture(nil, "OVERLAY");
    container.color:SetSize(16, 16);

    container.color:SetColorTexture(
        value and value.r or value[1] or 0,
        value and value.g or value[2] or 0,
        value and value.b or value[3] or 0
    );

    local loaded = false;
    local c = obj:PopTable();

    tk.Tables:Fill(c, value);

    container.func = function(restore)
        if (restore) then
            -- cancel button was pressed
            c.r, c.g, c.b, c.a = unpack(restore);
            loaded = false;
        else
            -- color picker was opened for the first time or okay button was pressed
            c.r, c.g, c.b = _G.ColorPickerFrame:GetColorRGB();

            if (_G.ColorPickerFrame.hasOpacity) then
                c.a = _G.OpacitySliderFrame:GetValue();
                c.a = 1 - c.a;
            end

            if (not loaded and c.r == 1 and c.g == 1 and c.b == 1) then
                loaded = true;

                if (container.useIndexes) then
                    c.r = value[1];
                    c.g = value[2];
                    c.b = value[3];
                    c.a = value[4];
                else
                    c.r = value.r;
                    c.g = value.g;
                    c.b = value.b;
                    c.a = value.a;
                end

                _G.ColorPickerFrame:SetColorRGB(c.r, c.g, c.b);
            else
                UpdateValue(container.useIndexes, value, c);
                container.color:SetColorTexture(c.r, c.g, c.b);

                if (container.requiresReload) then
                    configModule:ShowReloadMessage();
                end
            end
        end
    end

    container:SetScript("OnClick", ColorWidget_OnClick);

    container.square:SetPoint("LEFT");
    container.color:SetPoint("CENTER", container.square, "CENTER");
    container.name:SetPoint("LEFT", container.square, "RIGHT", 4, 0);
    return container;
end

---------------
-- Text Field
---------------

local function TextField_OnTextChanged(self, value)
    -- perform validation based on valueType
    local isValue = true;

    -- ensure database stores a number, instead of a string containing a number
    value = tonumber(value) or value;

    if (self.valueType == "number") then

        if (not obj:IsNumber(value)) then
            isValue = false;
        else
            if (self.min and value < self.min) then
                isValue = false;
            end
            if (self.max and value > self.max) then
                isValue = false;
            end
        end
    end

    if (not isValue) then
        self:ApplyPreviousText();
    else
        self:SetText(value);
        configModule:SetDatabaseValue(self:GetFrame(), value);
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
    textField:SetText(value or "");

    -- passes in textField (not data.editBox);
    textField:OnTextChanged(TextField_OnTextChanged, widgetTable);

    return CreateElementContainerFrame(textField, widgetTable, parent);
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

    local content = GetValue(widgetTable, "content");
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