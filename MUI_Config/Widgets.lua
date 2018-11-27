local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local configModule = MayronUI:ImportModule("Config");

local WidgetHandlers = {};
namespace.WidgetHandlers = WidgetHandlers;

--------------
-- Sub Menu
--------------
WidgetHandlers.submenu = {};

function WidgetHandlers.submenu:Run(parent, submenuConfigTable, value)
    local btn = tk.CreateFrame("Button", nil, parent);
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
    btn.moduleName = submenuConfigTable.module;

    btn:SetScript("OnClick", namespace.SubMenuButton_OnClick);

    return btn;
end

---------------------
-- Loop (non-widget)
---------------------
WidgetHandlers.loop = {};

-- should return a table of children created during the loop
function WidgetHandlers.loop:Run(parent, loopConfigTable)
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

function WidgetHandlers.check:Run(data, widgetConfigTable, value)
    local cb = gui:CreateCheckButton(data.parent, widgetConfigTable.name,
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

function WidgetHandlers.title:Run(parent, widgetConfigTable, value)
    local height = 20 + (widgetConfigTable.paddingTop or 10) + (widgetConfigTable.paddingBottom or 10);
    local f = tk:PopFrame("Frame", parent);

    f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    f.text:SetText(widgetConfigTable.name);
    f:SetHeight(f.text:GetStringHeight() + height);

    local bg = tk:SetBackground(f, 0, 0, 0, 0.2);
    bg:SetPoint("TOPLEFT", 0, -(widgetConfigTable.paddingTop or 10));
    bg:SetPoint("BOTTOMRIGHT", 0, (widgetConfigTable.paddingBottom or 10));
    f.text:SetAllPoints(bg);

    return f;
end

--------------
-- Slider
--------------
WidgetHandlers.slider = {};

function WidgetHandlers.slider:Run(data, widgetConfigTable, value)
    local slider = tk.CreateFrame("Slider", nil, data.parent, "OptionsSliderTemplate");
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
    slider:SetScript("OnValueChanged", function(self, value)
        value = tk.math.floor(value + 0.5);
        self.Value:SetText(value);
        configModule:SetDatabaseValue(self, widgetConfigTable, value);
    end);

    slider = configModule:CreateElementContainerFrame(slider, widgetConfigTable);
    slider:SetHeight(slider:GetHeight() + 5); -- make room for value text
    return slider;
end

--------------
-- Divider
--------------
WidgetHandlers.divider = {};

function WidgetHandlers.divider:Run(data, widgetConfigTable, value)
    local divider = tk:PopFrame("Frame");
    divider:SetHeight(widgetConfigTable.height or 1);
    return divider;
end

-------------------
-- Drop Down Menu
-------------------
local function DropDown_OnSelectedValue(widget, widgetConfigTable, value)
    configModule:SetDatabaseValue(widget, widgetConfigTable, value);
end

WidgetHandlers.dropdown = {};

function WidgetHandlers.dropdown:Run(data, widgetConfigTable, value)
    local dropdown = gui:CreateDropDown(tk.Constants.AddOnStyle, data.parent);
    local options = widgetConfigTable.options or widgetConfigTable:GetOptions();
    
    for key, dropDownValue in pairs(options) do
        local option = dropdown:AddOption(key, DropDown_OnSelectedValue, widgetConfigTable, dropDownValue);
        
        if (widgetConfigTable.fontPicker) then
            option:GetFontString():SetFont(tk.Constants.LSM:Fetch("font", name), 11);
        end
    end
    
    dropdown:SetLabel(value, widgetConfigTable.tooltip);

    return configModule:CreateElementContainerFrame(dropdown, widgetConfigTable);
end

--------------
-- Button
--------------
WidgetHandlers.button = {};

function WidgetHandlers.button:Run(data, widgetConfigTable, value)
    local button = gui:CreateButton(tk.Constants.AddOnStyle, nil, widgetConfigTable.name);

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

function WidgetHandlers.frame:Run(data, widgetConfigTable, value)
    local frame = widgetConfigTable.frame or widgetConfigTable:GetFrame();

    if (widgetConfigTable.width) then
        frame:SetWidth(widgetConfigTable.width);
    else
        tk:SetFullWidth(frame, 10);
    end

    if (widgetConfigTable.height) then
        frame:SetHeight(widgetConfigTable.height);
    end

    tk:SetBackground(frame, 0, 0, 0, 0.2);

    return frame;
end

-----------------
-- Color Picker
-----------------
WidgetHandlers.color = {};

local function ShowColorPicker(r, g, b, a, changedCallback)
    ColorPickerFrame:SetColorRGB(r, g, b);
    ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
    ColorPickerFrame.previousValues = {r, g, b, a};

    ColorPickerFrame.func = changedCallback;
    ColorPickerFrame.opacityFunc = changedCallback;
    ColorPickerFrame.cancelFunc = changedCallback;

    ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
    ColorPickerFrame:Show();
end

function WidgetHandlers.color:Run(data, widgetConfigTable, value)
    local container = tk.CreateFrame("Button");
    container.name = container:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    container.name:SetText(widgetConfigTable.name);
    container:SetSize(widgetConfigTable.width or (container.name:GetStringWidth() + 44), widgetConfigTable.height or 30);
    container.name:SetJustifyH("LEFT");

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
            c.r, c.g, c.b = ColorPickerFrame:GetColorRGB();
            if (ColorPickerFrame.hasOpacity) then
                c.a = OpacitySliderFrame:GetValue();
                c.a = 1 - c.a;
            end
        end
        
        configModule:SetDatabaseValue(container, widgetConfigTable, c);
        container.color:SetColorTexture(c.r, c.g, c.b);
    end

    container:SetScript("OnClick", function()
        local value = configModule:GetValue(widgetConfigTable);
        local a = value.a and (1 - value.a);
        ShowColorPicker(value.r, value.g, value.b, a, container.func);
    end);

    if (widgetConfigTable.tooltip) then
        container.tooltip = widgetConfigTable.tooltip;
        container:SetScript("OnEnter", data.ToolTip_OnEnter);
        container:SetScript("OnLeave", data.ToolTip_OnLeave);
    end

    container.square:SetPoint("LEFT");
    container.color:SetPoint("CENTER", container.square, "CENTER");
    container.name:SetPoint("LEFT", container.square, "RIGHT", 4, 0);
    return container;
end

---------------
-- Text Field
---------------
WidgetHandlers.textfield = {};

function WidgetHandlers.textfield:Run(data, widgetConfigTable, value)
    local textField = gui:CreateTextField(tk.Constants.AddOnStyle, widgetConfigTable.tooltip);
    textField:SetText(value or "");
    textField:SetSize(widgetConfigTable.width or 150, widgetConfigTable.height or 26);

    local editBox = textField:GetEditBox();

    textField:OnTextChanged(function(self, newText)
        local value = tonumber(newText) or newText;

        if (widgetConfigTable.valueType and type(value) ~= widgetConfigTable.valueType) then
            self:ApplyPreviousText();
        elseif (widgetConfigTable.min and widgetConfigTable.valueType == "number" and value < widgetConfigTable.min) then
            self:ApplyPreviousText();
        else
            self:SetPreviousText(value);
            configModule:SetDatabaseValue(self, widgetConfigTable, value);
        end
    end);

    return configModule:CreateElementContainerFrame(textField, widgetConfigTable);
end

----------------
-- Font String
----------------
WidgetHandlers.fontstring = {};

function WidgetHandlers.fontstring:Run(data, widgetConfigTable, value)
    local divider = tk:PopFrame("Frame");

    divider.content = divider:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    divider.content:SetAllPoints(true);
    divider.content:SetJustifyH("LEFT");
    divider.content:SetWordWrap(true);
    if (widgetConfigTable.subtype) then
        if (widgetConfigTable.subtype == "header") then
            divider.content:SetFontObject("MUI_FontLarge");
        end
    end
    divider.content:SetText(widgetConfigTable.content);
    divider:SetHeight(widgetConfigTable.height or divider.content:GetStringHeight() + 16);

    return divider;
end