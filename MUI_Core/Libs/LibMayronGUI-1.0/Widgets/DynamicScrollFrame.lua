local Lib = LibStub:GetLibrary("LibMayronGUI");
if (not Lib) then return; end

local WidgetsPackage = Lib.WidgetsPackage;
local Private = Lib.Private;

-- Local Functions ----------------

local function DynamicScrollBar_OnChange(self)
    local scrollChild = self:GetScrollChild();
    local scrollChildHeight = math.floor(scrollChild:GetHeight() + 0.5);
    local scrollFrameHeight = math.floor(self:GetHeight() + 0.5);

    if (scrollChild and scrollChildHeight > scrollFrameHeight) then
        if (self.animating) then
            self.ScrollBar:Hide();
            self.showScrollBar = self.ScrollBar;
        else
            self.ScrollBar:Show();
        end
    else
        self.showScrollBar = false;
        self.ScrollBar:Hide();
    end
end

local function ScrollFrame_OnMouseWheel(self, step)
    local newvalue = self:GetVerticalScroll() - (step * 20);

    if (newvalue < 0) then
        newvalue = 0;
        -- max scroll range is scrollchild.height - scrollframe.height!
    elseif (newvalue > self:GetVerticalScrollRange()) then
        newvalue = self:GetVerticalScrollRange();
    end

    self:SetVerticalScroll(newvalue);
end

local function GetScrollChild(self)
    return self.ScrollFrame:GetScrollChild();
end

local function SetScrollChild(self, ...)
    self.ScrollFrame:SetScrollChild(...);
end

-- Lib Methods ------------------  

function Lib:CreateScrollFrame(style, parent, global)
    local r, g, b = style:GetColor();
    local container = CreateFrame("Frame", global, parent);
    local padding = style:GetPadding(nil, true);

    container.ScrollFrame = CreateFrame("ScrollFrame", nil, container, "UIPanelScrollFrameTemplate");        
    container.ScrollFrame:SetAllPoints(true);
    container.ScrollFrame:EnableMouseWheel(true);
    container.ScrollFrame:SetClipsChildren(true);
    container.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);

    local child = CreateFrame("Frame", nil, container.ScrollFrame);
    container.ScrollFrame:SetScrollChild(child);

    Private:SetFullWidth(child, padding.right);

    -- ScrollBar ------------------    
    container.ScrollBar = container.ScrollFrame.ScrollBar;
    container.ScrollBar:ClearAllPoints();
    container.ScrollBar:SetPoint("TOPLEFT", container.ScrollFrame, "TOPRIGHT", -7, -2);
    container.ScrollBar:SetPoint("BOTTOMRIGHT", container.ScrollFrame, "BOTTOMRIGHT", -2, 2);

    container.ScrollBar.thumb = container.ScrollBar:GetThumbTexture();
    style:ApplyColor(nil, 0.8, container.ScrollBar.thumb);
    container.ScrollBar.thumb:SetSize(5, 50);

    container.ScrollBar:Hide();

    Private:SetBackground(container.ScrollBar, 0, 0, 0, 0.2);
    Private:KillElement(container.ScrollBar.ScrollUpButton);
    Private:KillElement(container.ScrollBar.ScrollDownButton);
    ----------------------------  

    container.ScrollFrame:SetScript("OnShow", DynamicScrollBar_OnChange);
    container.ScrollFrame:HookScript("OnScrollRangeChanged", DynamicScrollBar_OnChange);
    
    container.GetScrollChild = GetScrollChild;
    container.SetScrollChild = SetScrollChild;

    return container, child;
end