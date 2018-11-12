local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local WidgetHandlers = {};
namespace.WidgetHandlers = WidgetHandlers;

--------------
-- Sub Menu
--------------
WidgetHandlers.submenu = {};

function WidgetHandlers.submenu:Run(childData)
    local btn = tk.CreateFrame("Button", nil, private.parent);
    btn:SetSize(250, 60);

    btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    btn.text:SetText(childData.name);
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
        config:SetSubMenu(childData);
        private.menu_name:SetText(childData.name);
        private.menu.back:SetEnabled(true);
        tk.PlaySound(tk.Constants.CLICK);
    end);
    
    return btn;
end

---------------------
-- Loop (non-widget)
---------------------
WidgetHandlers.loop = {};

function WidgetHandlers.loop:Run(childData)
    self.data = self.data or {};
    tk:EmptyTable(self.data);

    if (childData.loops) then
        for id = 1, childData.loops do
            self.data[id] = childData.func(id);
        end

    elseif (childData.args) then
        for id, data in tk.ipairs(childData.args) do
            -- func returns the children data to be loaded
            if (tk.type(data) == "table" and not data.GetObjectType) then
                self.data[id] = childData.func(id, tk.unpack(data));
            else
                self.data[id] = childData.func(id, data);
            end
        end
    end

    return self.data;
end

------------------
-- Check Button
------------------
WidgetHandlers.check = {};

function WidgetHandlers.check:Run(childData)
    local cb = gui:CreateCheckButton(private.parent, childData.name,
        childData.type == "radio", childData.tooltip);

    cb.btn:SetChecked(private:GetValue(childData));
    cb.btn:SetScript("OnClick", function(self)
        UpdateConfig(self, childData, self:GetChecked());
    end);

    if (childData.width) then
        cb:SetWidth(childData.width);
    else
        cb:SetWidth(cb.btn:GetWidth() + 20 + cb.btn.text:GetStringWidth());
    end
    if (childData.height) then
        cb:SetHeight(childData.height);
    end
    return cb;
end

----------------
-- Title Frame
----------------
WidgetHandlers.title = {};

function WidgetHandlers.title:Run(childData)
    local height = 20 + (childData.padding_top or 10) + (childData.padding_bottom or 10);
    local f = tk:PopFrame("Frame", private.parent);

    f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    f.text:SetText(childData.name);
    f:SetHeight(f.text:GetStringHeight() + height);

    local bg = tk:SetBackground(f, 0, 0, 0, 0.2);
    bg:SetPoint("TOPLEFT", 0, -(childData.padding_top or 10));
    bg:SetPoint("BOTTOMRIGHT", 0, (childData.padding_bottom or 10));
    f.text:SetAllPoints(bg);

    return f;
end

--------------
-- Slider
--------------
WidgetHandlers.slider = {};

function WidgetHandlers.slider:Run(childData)
    local slider = tk.CreateFrame("Slider", nil, private.parent, "OptionsSliderTemplate");
    slider.tooltipText = childData.tooltip;
    slider:SetMinMaxValues(childData.min, childData.max);
    slider:SetValueStep(childData.step);
    slider:SetObeyStepOnDrag(true);

    local value = private:GetValue(childData);
    slider:SetValue(value or childData.min);
    slider.Value = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
    slider.Value:SetPoint("BOTTOM", 0, -8);
    slider.Value:SetText(value or childData.min);

    slider.Low:SetText(childData.min);
    slider.Low:ClearAllPoints();
    slider.Low:SetPoint("BOTTOMLEFT", 5, -8);
    slider.High:SetText(childData.max);
    slider.High:ClearAllPoints();
    slider.High:SetPoint("BOTTOMRIGHT", -5, -8);

    slider:SetSize(childData.width or 200, 20);
    slider:SetScript("OnValueChanged", function(self, value)
        value = tk.math.floor(value + 0.5);
        self.Value:SetText(value);
        UpdateConfig(self, childData, value);
    end);

    slider = private:CreateMenuContainer(slider, childData);
    slider:SetHeight(slider:GetHeight() + 5); -- make room for value text
    return slider;
end

--------------
-- Divider
--------------
WidgetHandlers.divider = {};

function WidgetHandlers.divider:Run(childData)
    local divider = tk:PopFrame("Frame");
    divider:SetHeight(childData.height or 1);
    return divider;
end

-------------------
-- Drop Down Menu
-------------------
WidgetHandlers.dropdown = {};

function WidgetHandlers.dropdown:Run(childData)
    local dropdown = gui:CreateDropDown(private.parent);
    local value = private:GetValue(childData);

    dropdown:SetLabel(value, childData.tooltip);
    local options = childData.options or childData:GetOptions();

    for _, name in tk.ipairs(options) do
        local option = dropdown:AddOption(name, UpdateConfig, childData, name);
        if (childData.fontPicker) then
            option:GetFontString():SetFont(tk.Constants.LSM:Fetch("font", name), 11);
        end
    end

    return private:CreateMenuContainer(dropdown, childData);
end

--------------
-- Button
--------------
WidgetHandlers.button = {};

function WidgetHandlers.button:Run(childData)
    local button = gui:CreateButton(nil, childData.name);

    if (childData.width) then
        button:SetWidth(childData.width);
    end

    if (childData.height) then
        button:SetHeight(childData.height);
    end

    button:SetScript("OnClick", function(self)
        childData.OnClick(self, childData);
    end);

    return button;
end

-----------------
-- Frame
-----------------
WidgetHandlers.frame = {};

function WidgetHandlers.frame:Run(childData)
    local frame = childData.frame or childData:GetFrame();

    if (childData.width) then
        frame:SetWidth(childData.width);
    else
        tk:SetFullWidth(frame, 10);
    end

    if (childData.height) then
        frame:SetHeight(childData.height);
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

function WidgetHandlers.color:Run(childData)
    local container = tk.CreateFrame("Button");
    container.name = container:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    container.name:SetText(childData.name);
    container:SetSize(childData.width or (container.name:GetStringWidth() + 44), childData.height or 30);
    container.name:SetJustifyH("LEFT");

    container.square = container:CreateTexture(nil, "BACKGROUND");
    container.square:SetSize(30, 30);
    container.square:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch");

    container.color = container:CreateTexture(nil, "OVERLAY");
    container.color:SetSize(16, 16);

    local value = private:GetValue(childData);
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
        UpdateConfig(container, childData, c);
        container.color:SetColorTexture(c.r, c.g, c.b);
    end

    container:SetScript("OnClick", function()
        local value = private:GetValue(childData);
        local a = value.a and (1 - value.a);
        ShowColorPicker(value.r, value.g, value.b, a, container.func);
    end);

    if (childData.tooltip) then
        container.tooltip = childData.tooltip;
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
WidgetHandlers.textfield = {};

function WidgetHandlers.textfield:Run(childData)
    local container = gui:CreateTextField(childData.tooltip);
    local value = private:GetValue(childData);
    container.field:SetText(value or "");
    container.field.previous = value;
    container:SetSize(childData.width or 150, childData.height or 26);

    container.field:SetScript("OnEnterPressed", function(self)
        self:ClearFocus();
        local value = tk.tonumber(self:GetText()) or self:GetText();
        if (childData.value_type and tk.type(value) ~= childData.value_type) then
            self:SetText(self.previous);
        elseif (childData.min and childData.value_type == "number" and value < childData.min) then
            self:SetText(self.previous);
        else
            self.previous = value;
            UpdateConfig(self, childData, value);
        end
    end);

    container.field:SetScript("OnEscapePressed", function(self)
        self:ClearFocus();
        self:SetText(self.previous);
    end);

    return private:CreateMenuContainer(container, childData);
end

----------------
-- Font String
----------------
WidgetHandlers.fontstring = {};

function WidgetHandlers.fontstring:Run(childData)
    local divider = tk:PopFrame("Frame");

    divider.content = divider:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    divider.content:SetAllPoints(true);
    divider.content:SetJustifyH("LEFT");
    divider.content:SetWordWrap(true);
    if (childData.subtype) then
        if (childData.subtype == "header") then
            divider.content:SetFontObject("MUI_FontLarge");
        end
    end
    divider.content:SetText(childData.content);
    divider:SetHeight(childData.height or divider.content:GetStringHeight() + 16);

    return divider;
end