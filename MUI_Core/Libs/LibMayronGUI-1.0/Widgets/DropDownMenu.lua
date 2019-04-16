-- luacheck: ignore MayronUI self 143 631

---@type LibMayronGUI
local Lib = _G.LibStub:GetLibrary("LibMayronGUI");

if (not Lib) then return; end

local WidgetsPackage = Lib.WidgetsPackage;
local Private = Lib.Private;
local obj = Lib.Objects;

local SlideController = WidgetsPackage:Get("SlideController");
local DropDownMenu = WidgetsPackage:CreateClass("DropDownMenu", Private.FrameWrapper);

DropDownMenu.Static.MAX_HEIGHT = 200;

-- Local Functions -------------------------------
local dropdowns = {};

-- @param exclude - for all except the excluded dropdown menu
local function FoldAll(exclude)
    for _, dropdown in ipairs(dropdowns) do
        if ((not exclude) or (exclude and exclude ~= dropdown)) then
            dropdown:Hide();
        end
    end

    if (not exclude and DropDownMenu.Static.Menu) then
        DropDownMenu.Static.Menu:Hide();
    end
end

local function DropDownToggleButton_OnClick(self)
    DropDownMenu.Static.Menu:SetFrameStrata("TOOLTIP");
    self.dropdown:Toggle(not self.dropdown:IsExpanded());
    FoldAll(self.dropdown);
end

-- can't remember why this is needed
local function OnSizeChanged(self, _, height)
    self:SetWidth(height);
end

-- Lib Functions ------------------------

function Lib:FoldAllDropDownMenus(exclude)
    FoldAll(exclude);
end

local function DropDownContainer_OnHide()
    DropDownMenu.Static.Menu:Hide();
end

-- @constructor
function Lib:CreateDropDown(style, parent, direction)

    if (not DropDownMenu.Static.Menu) then
        DropDownMenu.Static.Menu = Lib:CreateScrollFrame(style, _G.UIParent, "MUI_DropDownMenu");
        DropDownMenu.Static.Menu:Hide();
        DropDownMenu.Static.Menu:SetBackdrop(style:GetBackdrop("DropDownMenu"));
        DropDownMenu.Static.Menu:SetBackdropBorderColor(style:GetColor("Widget"));
        DropDownMenu.Static.Menu:SetScript("OnHide", FoldAll);

        Private:SetBackground(DropDownMenu.Static.Menu, 0, 0, 0, 0.9);
        table.insert(_G.UISpecialFrames, "MUI_DropDownMenu");
    end

    local dropDownContainer = _G.CreateFrame("Button", nil, parent);
    dropDownContainer:SetSize(178, 28);
    dropDownContainer:SetScript("OnHide", DropDownContainer_OnHide);

    local header = _G.CreateFrame("Frame", nil, dropDownContainer);
    header:SetPoint("TOPLEFT", dropDownContainer);

    header:SetBackdrop(style:GetBackdrop("DropDownMenu"));
    header.bg = Private:SetBackground(header, style:GetTexture("ButtonTexture"));

    dropDownContainer.toggleButton = self:CreateButton(style, dropDownContainer);
    dropDownContainer.toggleButton:SetSize(28, 28);
    dropDownContainer.toggleButton:SetPoint("TOPRIGHT", dropDownContainer, "TOPRIGHT");
    dropDownContainer.toggleButton:SetPoint("BOTTOMRIGHT", dropDownContainer, "BOTTOMRIGHT");
    dropDownContainer.toggleButton:SetScript("OnSizeChanged", OnSizeChanged);

    dropDownContainer.toggleButton.arrow = dropDownContainer.toggleButton:CreateTexture(nil, "OVERLAY");
    dropDownContainer.toggleButton.arrow:SetTexture(style:GetTexture("SmallArrow"));
    dropDownContainer.toggleButton.arrow:SetPoint("CENTER");
    dropDownContainer.toggleButton.arrow:SetSize(16, 16);

    dropDownContainer.child = Private:PopFrame("Frame", DropDownMenu.Static.Menu);
    Private:SetFullWidth(dropDownContainer.child);

    dropDownContainer.toggleButton.child = dropDownContainer.child; -- needed for OnClick
    dropDownContainer.toggleButton:SetScript("OnClick", DropDownToggleButton_OnClick);

    header:SetPoint("BOTTOMRIGHT", dropDownContainer.toggleButton, "BOTTOMLEFT", -2, 0);

    direction = (direction or "DOWN"):upper();

    if (direction == "DOWN") then
        dropDownContainer.toggleButton.arrow:SetTexCoord(1, 0, 1, 0);
    elseif (direction == "UP") then
        dropDownContainer.toggleButton.arrow:SetTexCoord(0, 1, 0, 1);
    end

    local slideController = SlideController(DropDownMenu.Static.Menu);
    slideController:SetMinHeight(1);

    slideController:OnEndRetract(function(self, frame)
        frame:Hide();
    end);

    dropDownContainer.dropdown = DropDownMenu(style, header, direction, slideController, dropDownContainer);
    dropDownContainer.toggleButton.dropdown = dropDownContainer.dropdown; -- needed for OnClick
    table.insert(dropdowns, dropDownContainer.dropdown);

    return dropDownContainer.dropdown;
end

-----------------------------------
-- DropDownMenu Object
-----------------------------------
local function ToolTip_OnEnter(frame)
    _G.GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT", 0, 2);

    if (frame.isEnabled) then
        _G.GameTooltip:AddLine(frame.tooltip);
    else
        _G.GameTooltip:AddLine(frame.disabledTooltip);
    end

    _G.GameTooltip:Show();
end

 local function ToolTip_OnLeave()
    _G.GameTooltip:Hide();
end

WidgetsPackage:DefineParams("Style", "Frame", "string", "SlideController", "Frame")
function DropDownMenu:__Construct(data, style, header, direction, slideController, frame)
    data.header = header;
    data.direction = direction;
    data.slideController = slideController;
    data.scrollHeight = 0;
    data.frame = frame;
    data.menu = DropDownMenu.Static.Menu;
    data.style = style;
    data.options = obj:PopTable();

    data.label = data.header:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    data.label:SetPoint("LEFT", 10, 0);
    data.label:SetPoint("RIGHT", -10, 0);
    data.label:SetWordWrap(false);
    data.label:SetJustifyH("LEFT");

    -- disabled by default (until an option is added)
    self:SetEnabled(false);
end

function DropDownMenu:SetParent(data, parent)
    -- this is needed to fix setting a new parent bug
    data.frame:SetParent(parent);
    data.header:SetParent(parent);
end

function DropDownMenu:GetMenu(data)
    return data.menu;
end

function DropDownMenu:SetSortingEnabled(data, enable)
    if (enable) then
        data.disableSorting = nil;
    else
        data.disableSorting = true;
    end
end

do
    local function ApplyTooltipScripts(header)
        header:SetScript("OnEnter", ToolTip_OnEnter);
        header:SetScript("OnLeave", ToolTip_OnLeave);
    end

    function DropDownMenu:SetTooltip(data, tooltip)
        data.header.tooltip = tooltip;
        ApplyTooltipScripts(data.header);
    end

    function DropDownMenu:SetDisabledTooltip(data, disabledTooltip)
        data.header.disabledTooltip = disabledTooltip;
        ApplyTooltipScripts(data.header);
    end
end

WidgetsPackage:DefineParams("string");
function DropDownMenu:SetLabel(data, text)
    data.label:SetText(text);
end

WidgetsPackage:DefineReturns("?string");
function DropDownMenu:GetLabel(data)
    return data.label and data.label:GetText();
end

WidgetsPackage:DefineReturns("number");
function DropDownMenu:GetNumOptions(data)
    return #data.options;
end

WidgetsPackage:DefineParams("number");
WidgetsPackage:DefineReturns("Button");
function DropDownMenu:GetOptionByID(data, optionID)
    local foundOption = data.options[optionID];
    obj:Assert(foundOption, "DropDownMenu.GetOption failed to find option with id '%s'.", optionID);
    return foundOption;
end

WidgetsPackage:DefineParams("string");
WidgetsPackage:DefineReturns("Button");
function DropDownMenu:GetOptionByLabel(data, label)
    for _, optionButton in ipairs(data.options) do
        if (optionButton:GetText() == label) then
            return optionButton;
        end
    end
end

WidgetsPackage:DefineParams("string");
function DropDownMenu:RemoveOptionByLabel(data, label)
    for optionID, optionButton in ipairs(data.options) do
        if (optionButton:GetText() == label) then
            table.remove(data.options, optionID);
            Private:PushFrame(optionButton);
            self:RepositionOptions();

            if (#data.options == 0) then
                self:SetEnabled(false);
            end
        end
    end
end

function DropDownMenu:AddOptions(_, func, optionsTable)
    for _, optionValues in ipairs(optionsTable) do
        local label = optionValues[1];
        self:AddOption(label, func, select(2, _G.unpack(optionValues)));
    end
end

do
    local function SortByLabel(a, b)
        return a:GetText() < b:GetText();
    end

    function DropDownMenu:RepositionOptions(data)
        local child = data.frame.child;
        local height = 30;

        if (not data.disableSorting) then
            table.sort(data.options, SortByLabel);
        end

        for _, option in ipairs(data.options) do
            option:ClearAllPoints();
        end

        for id, option in ipairs(data.options) do
            if (id == 1) then
                if (data.direction == "DOWN") then
                    option:SetPoint("TOPLEFT", 2, -2);
                    option:SetPoint("TOPRIGHT", -2, -2);
                elseif (data.direction == "UP") then
                    option:SetPoint("BOTTOMLEFT", 2, 2);
                    option:SetPoint("BOTTOMRIGHT", -2, 2);
                end
            else
                local previousOption = data.options[id - 1];

                if (data.direction == "DOWN") then
                    option:SetPoint("TOPLEFT", previousOption, "BOTTOMLEFT", 0, -1);
                    option:SetPoint("TOPRIGHT", previousOption, "BOTTOMRIGHT", 0, -1);
                elseif (data.direction == "UP") then
                    option:SetPoint("BOTTOMLEFT", previousOption, "TOPLEFT", 0, 1);
                    option:SetPoint("BOTTOMRIGHT", previousOption, "TOPRIGHT", 0, 1);
                end

                height = height + 27;
            end
        end

        data.scrollHeight = height;
        child:SetHeight(height);

        if (DropDownMenu.Static.Menu:IsShown()) then
            DropDownMenu.Static.Menu:SetHeight(height);
        end
    end
end

function DropDownMenu:AddOption(data, label, func, ...)
    local r, g, b = data.style:GetColor();
    local child = data.frame.child;

    local option = Private:PopFrame("Button", child);

    option:SetHeight(26);
    option:SetNormalFontObject("GameFontHighlight");
    option:SetText(label or " ");

    local optionFontString = option:GetFontString();
    optionFontString:ClearAllPoints();
    optionFontString:SetPoint("LEFT", 10, 0);
    optionFontString:SetPoint("RIGHT", -10, 0);
    optionFontString:SetWordWrap(false);
    optionFontString:SetJustifyH("LEFT");

    option:SetNormalTexture(1);
    option:GetNormalTexture():SetColorTexture(r * 0.7, g * 0.7, b * 0.7, 0.4);
    option:SetHighlightTexture(1);
    option:GetHighlightTexture():SetColorTexture(r * 0.7, g * 0.7, b * 0.7, 0.4);

    local args = obj:PopTable(...);
    option:SetScript("OnClick", function()
        self:SetLabel(option:GetText());
        self:Toggle(false);

        if (not func) then
            return;
        end

        if (obj:IsTable(func)) then
            local tbl = func[1];
            local methodName = func[2];

            tbl[methodName](tbl, self, _G.unpack(args));
        else
            func(self, _G.unpack(args));
        end
    end);

    table.insert(data.options, option);
    self:RepositionOptions();
    self:SetEnabled(true);

    return option;
end

function DropDownMenu:UpdateColor(data)
    if (data.header.isEnabled) then
        local r, g, b = data.style:GetColor("Widget");

        data.header:SetBackdropBorderColor(r, g, b);
        data.header.bg:SetVertexColor(r, g, b, 0.6);

        data.frame.toggleButton:GetNormalTexture():SetVertexColor(r, g, b, 0.6);
        data.frame.toggleButton:GetHighlightTexture():SetVertexColor(r, g, b, 0.3);
        data.frame.toggleButton:SetBackdropBorderColor(r, g, b);

        data.frame.toggleButton.arrow:SetAlpha(1);
        data.label:SetTextColor(1, 1, 1);
    else
        local r, g, b = _G.DISABLED_FONT_COLOR:GetRGB();

        data.header:SetBackdropBorderColor(r, g, b);
        data.header.bg:SetVertexColor(r, g, b, 0.6);

        data.frame.toggleButton:SetBackdropBorderColor(r, g, b);

        data.frame.toggleButton.arrow:SetAlpha(0.5);
        data.label:SetTextColor(r, g, b);
    end

    DropDownMenu.Static.Menu:SetBackdropBorderColor(data.style:GetColor("Widget"));
    Lib:UpdateScrollFrameColor(DropDownMenu.Static.Menu, data.style);

    local r, g, b = data.style:GetColor();

    for _, option in ipairs(data.options) do
        option:GetNormalTexture():SetColorTexture(r * 0.7, g * 0.7, b * 0.7, 0.4);
        option:GetHighlightTexture():SetColorTexture(r * 0.7, g * 0.7, b * 0.7, 0.4);
    end
end

function DropDownMenu:SetEnabled(data, enabled)
    if (data.header.isEnabled == enabled) then
        return;
    end

    data.frame.toggleButton:SetEnabled(enabled);
    data.header.isEnabled = enabled; -- required for using the correct tooltip
    self:UpdateColor();
end

function DropDownMenu:SetHeaderShown(data, shown)
    data.header:SetShown(shown);
end

-- Unlike Toggle(), this function hides the menu instantly (does not fold)
function DropDownMenu:Hide(data)
    data.expanded = false;
    data.frame.child:Hide();

    if (data.direction == "DOWN") then
        data.frame.toggleButton.arrow:SetTexCoord(1, 0, 1, 0);
    elseif (data.direction == "UP") then
        data.frame.toggleButton.arrow:SetTexCoord(0, 1, 0, 1);
    end
end

function DropDownMenu:IsExpanded(data)
    return data.expanded;
end

function DropDownMenu:Toggle(data, show, clickSoundFilePath)
    if (not data.options) then
        -- no list of options so nothing to toggle...
        return
    end

    local step = #data.options * 4;
    step = (step > 20) and step or 20;
    step = (step < 30) and step or 30;

    DropDownMenu.Static.Menu:ClearAllPoints();

    if (data.direction == "DOWN") then
        DropDownMenu.Static.Menu:SetPoint("TOPLEFT", data.frame, "BOTTOMLEFT", 0, -2);
        DropDownMenu.Static.Menu:SetPoint("TOPRIGHT", data.frame, "BOTTOMRIGHT", 0, -2);
    elseif (data.direction == "UP") then
        DropDownMenu.Static.Menu:SetPoint("BOTTOMLEFT", data.frame, "TOPLEFT", 0, 2);
        DropDownMenu.Static.Menu:SetPoint("BOTTOMRIGHT", data.frame, "TOPRIGHT", 0, 2);
    end

    if (show) then
        local maxHeight = (data.scrollHeight < DropDownMenu.Static.MAX_HEIGHT)
            and data.scrollHeight or DropDownMenu.Static.MAX_HEIGHT;

        DropDownMenu.Static.Menu.ScrollFrame:SetScrollChild(data.frame.child);
        DropDownMenu.Static.Menu:SetHeight(1);

        data.frame.child:Show();
        data.slideController:SetMaxHeight(maxHeight);

        if (data.direction == "DOWN") then
            data.frame.toggleButton.arrow:SetTexCoord(0, 1, 0, 1);
        elseif (data.direction == "UP") then
            data.frame.toggleButton.arrow:SetTexCoord(1, 0, 1, 0);
        end
    else
        if (data.direction == "DOWN") then
            data.frame.toggleButton.arrow:SetTexCoord(1, 0, 1, 0);
        elseif (data.direction == "UP") then
            data.frame.toggleButton.arrow:SetTexCoord(0, 1, 0, 1);
        end
    end

    data.slideController:SetStepValue(step);
    data.slideController:Start();

    if (clickSoundFilePath) then
        _G.PlaySound(clickSoundFilePath);
    end

    data.expanded = show;
end