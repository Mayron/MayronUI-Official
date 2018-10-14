local Lib = LibStub:GetLibrary("LibMayronGUI");
if (not Lib) then return; end

local WidgetsPackage = Lib.WidgetsPackage;
local Private = Lib.Private;

local SlideController = WidgetsPackage:Get("SlideController");
local Style = WidgetsPackage:Get("Style");
local DropDownMenu = WidgetsPackage:CreateClass("DropDownMenu", Private.FrameWrapper);

DropDownMenu.Static.MAX_HEIGHT = 354;

-- Local Functions -------------------------------
local dropdowns = {};

-- @param exclude - for all except the excluded dropdown menu
local function FoldAll(exclude)        
    for i, dropdown in ipairs(dropdowns) do
        print(i)
        if ((not exclude) or (exclude and exclude ~= dropdown)) then
            dropdown:Hide();
        end
    end

    if (not exclude and DropDownMenu.Static.Menu) then
        DropDownMenu.Static.Menu:Hide();
    end
end

local function OnClick(self)
    DropDownMenu.Static.Menu:SetFrameStrata("TOOLTIP");
    self.dropdown:Toggle(not self.dropdown:IsExpanded());
    FoldAll(self.dropdown);
end

local function OnSizeChanged(self, _, height)
    self:SetWidth(height);
end

-- Lib Functions ------------------------

function Lib:FoldAllDropDownMenus(exclude) 
    FoldAll(exclude); 
end

-- @constructor    
function Lib:CreateDropDown(style, parent, direction)
    local r, g, b = style:GetColor();    
    local frame = Private:PopFrame("Frame", parent);
    local header = Private:PopFrame("Frame", frame);

    if (not DropDownMenu.Static.Menu) then
        DropDownMenu.Static.Menu = Lib:CreateScrollFrame(style, UIParent, "MUI_DropDownMenu");
        DropDownMenu.Static.Menu:Hide(); 
        DropDownMenu.Static.Menu:SetBackdrop(style:GetBackdrop("DropDownMenu"));
        DropDownMenu.Static.Menu:SetBackdropBorderColor(r * 0.7, g * 0.7, b * 0.7);
        DropDownMenu.Static.Menu:SetScript("OnHide", FoldAll);

        Private:SetBackground(DropDownMenu.Static.Menu, 0, 0, 0, 0.9);
        table.insert(UISpecialFrames, "MUI_DropDownMenu");
    end

    direction = direction or "DOWN";
    direction = direction:upper();
    parent = parent or UIParent;
    
    header:SetPoint("TOPLEFT");
    header:SetBackdrop(style:GetBackdrop("DropDownMenu"));
    header:SetBackdropBorderColor(r * 0.7, g * 0.7, b * 0.6);     

    header.bg = Private:SetBackground(header, background);
    header.bg:SetVertexColor(r * 0.7, g * 0.7, b * 0.7, 0.6);

    frame:SetSize(200, 30);

    frame.btn = self:CreateButton(style, frame);
    frame.btn:SetSize(30, 30);
    frame.btn:SetPoint("TOPRIGHT", frame, "TOPRIGHT");
    frame.btn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT");
    frame.btn:SetScript("OnSizeChanged", OnSizeChanged);
    
    frame.btn.arrow = frame.btn:CreateTexture(nil, "OVERLAY");
    frame.btn.arrow:SetTexture(style:GetTexture("ArrowButtonTexture"));
    frame.btn.arrow:SetAllPoints(true);

    frame.child = Private:PopFrame("Frame", DropDownMenu.Static.Menu);
    Private:SetFullWidth(frame.child);

    frame.btn.child = frame.child; -- needed for OnClick
    frame.btn:SetScript("OnClick", OnClick);
    header:SetPoint("BOTTOMRIGHT", frame.btn, "BOTTOMLEFT", -2, 0);

    if (direction == "DOWN") then
        frame.btn.arrow:SetTexCoord(0, 1, 0.2, 1);
    elseif (direction == "UP") then
        frame.btn.arrow:SetTexCoord(1, 0, 1, 0.2);
    end

    local slideController = SlideController(DropDownMenu.Static.Menu);
    slideController:SetMinHeight(1);
    slideController:OnEndRetract(function(self, frame)
        frame:Hide();
    end);

    frame.btn.dropdown = DropDownMenu(header, direction, slideController, frame, menu, style);    
    table.insert(dropdowns, frame.btn.dropdown);
    frame.btn.dropdown:SetEnabled(true); -- enabled by default

    return frame.btn.dropdown;
end

function DropDownMenu:__Construct(data, header, direction, slideController, frame, menu, style)
    data.header = header;
    data.direction = direction;
    data.slideController = slideController;
    data.frame = frame;
    data.menu = menu;
    data.style = style;
end

function DropDownMenu:GetMenu(data)
    return data.menu;
end

function DropDownMenu:SetToolTip(data, tooltip)
    if (not data.header.tooltip) then
        data.header:SetScript("OnEnter", ToolTip_OnEnter);
        data.header:SetScript("OnLeave", ToolTip_OnLeave);
    end
    data.header.tooltip = tooltip;
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

    for id, o in ipairs(data.list) do
        if (o.value == value) then
            option = o;
            table.remove(data.list, id);
            break;
        end
    end

    if (not option) then 
        return false; 
    end

    Private:PushFrame(option);

    local height = 30;
    local child = data.frame.child;

    for id, o in ipairs(data.list) do
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

    data.scrollHeight = height;
    child:SetHeight(height);

    if (DropDownMenu.Static.Menu:IsShown()) then
        DropDownMenu.Static.Menu:SetHeight(height);
    end

    return true;
end

function DropDownMenu:GetOption(data, value)
    for id, o in ipairs(data.list) do
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
    data.list = data.list or {};

    local r, g, b = data.style:GetColor();  
    local child = data.frame.child;    
    local o = Private:PopFrame("Button", child);
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

    data.scrollHeight = height;
    child:SetHeight(height);

    o.value = value;
    table.insert(data.list, o);

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
        func(self, value, unpack(args));
    end);

    return o;
end

function DropDownMenu:SetEnabled(data, enabled)    
    data.frame.btn:SetEnabled(enabled);

    if (enabled) then
        local r, g, b = data.style:GetColor();

        --TODO: Use style:ApplyColor(...)?
        DropDownMenu.Static.Menu:SetBackdropBorderColor(r, g, b);
        data.header.bg:SetVertexColor(r, g, b, 0.6);    
        data.header:SetBackdropBorderColor(r, g, b);
        data.frame.btn:GetNormalTexture():SetVertexColor(r * 0.8, g * 0.8, b * 0.8, 0.6);
        data.frame.btn:GetHighlightTexture():SetVertexColor(r, g, b, 0.3);
        data.frame.btn:SetBackdropBorderColor(r, g, b);
        data.frame.btn.arrow:SetAlpha(1);

        if (data.list) then
            for id, o in ipairs(data.list) do
                o:GetNormalTexture():SetColorTexture(r, g, b, 0.4);
                o:GetHighlightTexture():SetColorTexture(r, g, b, 0.4);
            end
        end

        if (data.label) then
            data.label:SetTextColor(1, 1, 1);
        end
    else
        DropDownMenu.Static.Menu:Hide();       
        DropDownMenu.Static.Menu:SetBackdropBorderColor(0.2, 0.2, 0.2); 
        data.header.bg:SetVertexColor(0.2, 0.2, 0.2, 0.6);               
        data.header:SetBackdropBorderColor(0.2, 0.2, 0.2);
        data.frame.btn:GetNormalTexture():SetVertexColor(0.2, 0.2, 0.2, 0.6);
        data.frame.btn:GetHighlightTexture():SetVertexColor(0.2, 0.2, 0.2, 0.7);
        data.frame.btn:SetBackdropBorderColor(0.2, 0.2, 0.2);
        data.frame.btn.arrow:SetAlpha(0.5);

        style:ApplyColor(nil, 0.8, container.ScrollBar.thumb);

        self:Toggle(false);

        if (data.label) then
            data.label:SetTextColor(0.5, 0.5, 0.5);
        end
    end
end

-- Unlike Toggle(), this function hides the menu instantly (does not fold)
function DropDownMenu:Hide(data)
    data.expanded = false;
    data.frame.child:Hide();

    if (data.direction == "DOWN") then
        data.frame.btn.arrow:SetTexCoord(0, 1, 0.2, 1);

    elseif (data.direction == "UP") then
        data.frame.btn.arrow:SetTexCoord(1, 0, 1, 0.2);
    end
end

function DropDownMenu:IsExpanded(data)
    return data.expanded;
end

function DropDownMenu:Toggle(data, show, clickSoundFilePath)
    if (not data.list) then 
        return; 
    end

    local step = #data.list * 4;
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
        local max_height = (data.scrollHeight < DropDownMenu.Static.MAX_HEIGHT) and
                data.scrollHeight or DropDownMenu.Static.MAX_HEIGHT;

        DropDownMenu.Static.Menu:SetScrollChild(data.frame.child);
        DropDownMenu.Static.Menu:SetHeight(1);

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

    if (clickSoundFilePath) then
        PlaySound(clickSoundFilePath);
    end   

    data.expanded = show;
end