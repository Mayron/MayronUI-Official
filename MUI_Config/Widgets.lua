local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local WidgetHandlers = {};
namespace.WidgetHandlers = WidgetHandlers;

--------------
-- Sub Menu
--------------
WidgetHandlers.submenu = {};

function WidgetHandlers.submenu:Run(child_data)
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
WidgetHandlers.loop = {};

function WidgetHandlers.loop:Run(child_data)
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
WidgetHandlers.check = {};

function WidgetHandlers.check:Run(child_data)
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
WidgetHandlers.title = {};

function WidgetHandlers.title:Run(child_data)
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
WidgetHandlers.slider = {};

function WidgetHandlers.slider:Run(child_data)
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
WidgetHandlers.divider = {};

function WidgetHandlers.divider:Run(child_data)
    local divider = tk:PopFrame("Frame");
    divider:SetHeight(child_data.height or 1);
    return divider;
end

-------------------
-- Drop Down Menu
-------------------
WidgetHandlers.dropdown = {};

function WidgetHandlers.dropdown:Run(child_data)
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
WidgetHandlers.button = {};

function WidgetHandlers.button:Run(child_data)
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
WidgetHandlers.frame = {};

function WidgetHandlers.frame:Run(child_data)
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

function WidgetHandlers.color:Run(child_data)
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
WidgetHandlers.textfield = {};

function WidgetHandlers.textfield:Run(child_data)
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
WidgetHandlers.fontstring = {};

function WidgetHandlers.fontstring:Run(child_data)
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