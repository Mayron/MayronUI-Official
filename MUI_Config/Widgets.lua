local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local configModule = MayronUI:ImportModule("Config");

local WidgetHandlers = {};
namespace.WidgetHandlers = WidgetHandlers;

--------------
-- Sub Menu
--------------
WidgetHandlers.submenu = {};

function WidgetHandlers.submenu:Run(data, configTable, value)
    local btn = tk.CreateFrame("Button", nil, data.parent);
    btn:SetSize(250, 60);

    btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    btn.text:SetText(configTable.name);
    btn.text:SetJustifyH("LEFT");
    btn.text:SetPoint("TOPLEFT", 10, 0);
    btn.text:SetPoint("BOTTOMRIGHT");

    btn.normal = tk:SetBackground(btn, 1, 1, 1, 0);
    btn.highlight = tk:SetBackground(btn, 1, 1, 1, 0);
    tk:SetThemeColor(0.3, btn.normal, btn.highlight);

    btn:SetNormalTexture(btn.normal);
    btn:SetHighlightTexture(btn.highlight);

    btn:SetScript("OnClick", function()
        data.history:AddToBack(config.submenu_data);
        config:SetSubMenu(configTable);
        data.menu_name:SetText(configTable.name);
        data.menu.back:SetEnabled(true);
        tk.PlaySound(tk.Constants.CLICK);
    end);
    
    return btn;
end

---------------------
-- Loop (non-widget)
---------------------
WidgetHandlers.loop = {};

function WidgetHandlers.loop:Run(data, configTable, value)
    self.data = self.data or {};
    tk:EmptyTable(self.data);

    if (configTable.loops) then
        for id = 1, configTable.loops do
            self.data[id] = configTable.func(id);
        end

    elseif (configTable.args) then
        for id, data in tk.ipairs(configTable.args) do
            -- func returns the children data to be loaded
            if (tk.type(data) == "table" and not data.GetObjectType) then
                self.data[id] = configTable.func(id, tk.unpack(data));
            else
                self.data[id] = configTable.func(id, data);
            end
        end
    end

    return self.data;
end

------------------
-- Check Button
------------------
WidgetHandlers.check = {};

function WidgetHandlers.check:Run(data, configTable, value)
    local cb = gui:CreateCheckButton(data.parent, configTable.name,
        configTable.type == "radio", configTable.tooltip);

    cb.btn:SetChecked(value);
    cb.btn:SetScript("OnClick", function(self)
        UpdateConfig(self, configTable, self:GetChecked());
    end);

    if (configTable.width) then
        cb:SetWidth(configTable.width);
    else
        cb:SetWidth(cb.btn:GetWidth() + 20 + cb.btn.text:GetStringWidth());
    end
    if (configTable.height) then
        cb:SetHeight(configTable.height);
    end
    return cb;
end

----------------
-- Title Frame
----------------
WidgetHandlers.title = {};

function WidgetHandlers.title:Run(data, configTable, value)
    local height = 20 + (configTable.padding_top or 10) + (configTable.padding_bottom or 10);
    local f = tk:PopFrame("Frame", data.parent);

    f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    f.text:SetText(configTable.name);
    f:SetHeight(f.text:GetStringHeight() + height);

    local bg = tk:SetBackground(f, 0, 0, 0, 0.2);
    bg:SetPoint("TOPLEFT", 0, -(configTable.padding_top or 10));
    bg:SetPoint("BOTTOMRIGHT", 0, (configTable.padding_bottom or 10));
    f.text:SetAllPoints(bg);

    return f;
end

--------------
-- Slider
--------------
WidgetHandlers.slider = {};

function WidgetHandlers.slider:Run(data, configTable, value)
    local slider = tk.CreateFrame("Slider", nil, data.parent, "OptionsSliderTemplate");
    slider.tooltipText = configTable.tooltip;
    slider:SetMinMaxValues(configTable.min, configTable.max);
    slider:SetValueStep(configTable.step);
    slider:SetObeyStepOnDrag(true);

    slider:SetValue(value or configTable.min);
    slider.Value = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
    slider.Value:SetPoint("BOTTOM", 0, -8);
    slider.Value:SetText(value or configTable.min);

    slider.Low:SetText(configTable.min);
    slider.Low:ClearAllPoints();
    slider.Low:SetPoint("BOTTOMLEFT", 5, -8);
    slider.High:SetText(configTable.max);
    slider.High:ClearAllPoints();
    slider.High:SetPoint("BOTTOMRIGHT", -5, -8);

    slider:SetSize(configTable.width or 200, 20);
    slider:SetScript("OnValueChanged", function(self, value)
        value = tk.math.floor(value + 0.5);
        self.Value:SetText(value);
        UpdateConfig(self, configTable, value);
    end);

    slider = configModule:CreateElementContainerFrame(slider, configTable);
    slider:SetHeight(slider:GetHeight() + 5); -- make room for value text
    return slider;
end

--------------
-- Divider
--------------
WidgetHandlers.divider = {};

function WidgetHandlers.divider:Run(data, configTable, value)
    local divider = tk:PopFrame("Frame");
    divider:SetHeight(configTable.height or 1);
    return divider;
end

-------------------
-- Drop Down Menu
-------------------
WidgetHandlers.dropdown = {};

function WidgetHandlers.dropdown:Run(data, configTable, value)
    local dropdown = gui:CreateDropDown(tk.Constants.AddOnStyle, data.parent);

    dropdown:SetLabel(value, configTable.tooltip);
    local options = configTable.options or configTable:GetOptions();

    for _, name in tk.ipairs(options) do
        local option = dropdown:AddOption(name, UpdateConfig, configTable, name);

        if (configTable.fontPicker) then
            option:GetFontString():SetFont(tk.Constants.LSM:Fetch("font", name), 11);
        end
    end

    return configModule:CreateElementContainerFrame(dropdown, configTable);
end

--------------
-- Button
--------------
WidgetHandlers.button = {};

function WidgetHandlers.button:Run(data, configTable, value)
    local button = gui:CreateButton(tk.Constants.AddOnStyle, nil, configTable.name);

    if (configTable.width) then
        button:SetWidth(configTable.width);
    end

    if (configTable.height) then
        button:SetHeight(configTable.height);
    end

    button:SetScript("OnClick", function(self)
        configTable.OnClick(self, configTable);
    end);

    return button;
end

-----------------
-- Frame
-----------------
WidgetHandlers.frame = {};

function WidgetHandlers.frame:Run(data, configTable, value)
    local frame = configTable.frame or configTable:GetFrame();

    if (configTable.width) then
        frame:SetWidth(configTable.width);
    else
        tk:SetFullWidth(frame, 10);
    end

    if (configTable.height) then
        frame:SetHeight(configTable.height);
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
    ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc =
    changedCallback, changedCallback, changedCallback;
    ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
    ColorPickerFrame:Show();
end

function WidgetHandlers.color:Run(data, configTable, value)
    local container = tk.CreateFrame("Button");
    container.name = container:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    container.name:SetText(configTable.name);
    container:SetSize(configTable.width or (container.name:GetStringWidth() + 44), configTable.height or 30);
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
        UpdateConfig(container, configTable, c);
        container.color:SetColorTexture(c.r, c.g, c.b);
    end

    container:SetScript("OnClick", function()
        local value = configModule:GetValue(configTable);
        local a = value.a and (1 - value.a);
        ShowColorPicker(value.r, value.g, value.b, a, container.func);
    end);

    if (configTable.tooltip) then
        container.tooltip = configTable.tooltip;
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

function WidgetHandlers.textfield:Run(data, configTable, value)
    local textField = gui:CreateTextField(tk.Constants.AddOnStyle, configTable.tooltip);
    textField:SetText(value or "");
    textField:SetSize(configTable.width or 150, configTable.height or 26);

    local editBox = textField:GetEditBox();

    textField:OnTextChanged(function(self, newText)
        local value = tonumber(newText) or newText;

        if (configTable.value_type and type(value) ~= configTable.value_type) then
            self:ApplyPreviousText();
        elseif (configTable.min and configTable.value_type == "number" and value < configTable.min) then
            self:ApplyPreviousText();
        else
            self:SetPreviousText(value);
            configModule:SetDatabaseValue(self, configTable, value);
        end
    end);

    return configModule:CreateElementContainerFrame(textField, configTable);
end

----------------
-- Font String
----------------
WidgetHandlers.fontstring = {};

function WidgetHandlers.fontstring:Run(data, configTable, value)
    local divider = tk:PopFrame("Frame");

    divider.content = divider:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    divider.content:SetAllPoints(true);
    divider.content:SetJustifyH("LEFT");
    divider.content:SetWordWrap(true);
    if (configTable.subtype) then
        if (configTable.subtype == "header") then
            divider.content:SetFontObject("MUI_FontLarge");
        end
    end
    divider.content:SetText(configTable.content);
    divider:SetHeight(configTable.height or divider.content:GetStringHeight() + 16);

    return divider;
end