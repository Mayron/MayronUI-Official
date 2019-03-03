-- luacheck: ignore MayronUI self 143 631

---@type LibMayronGUI
local Lib = _G.LibStub:GetLibrary("LibMayronGUI");

if (not Lib) then return; end

local Private = Lib.Private;

-- Local Functions ----------------

local function HideIfAnimating(self)
    if (self:GetParent().animating) then
        self:Hide();
    end
end

local function DynamicScrollBar_OnChange(self)
    if (not self.ScrollFrame) then
        return;
    end

    local scrollChild = self.ScrollFrame:GetScrollChild();
    local scrollChildHeight = math.floor(scrollChild:GetHeight() + 0.5);
    local containerHeight = math.floor(self:GetHeight() + 0.5);

    if (scrollChild and scrollChildHeight > containerHeight) then
        if (self.ScrollFrame.animating) then
            self.ScrollBar:Hide();
            self.showScrollBar = self.ScrollBar;
        else
            self.ScrollBar:Show();
        end
    else
        self.showScrollBar = nil;
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

-- Lib Methods ------------------

-- Creates a scroll frame inside a container frame
function Lib:CreateScrollFrame(style, parent, global, child)
    local container = _G.CreateFrame("Frame", global, parent);
    container.ScrollFrame = _G.CreateFrame("ScrollFrame", nil, container, "UIPanelScrollFrameTemplate");
    container.ScrollFrame:SetAllPoints(true);
    container.ScrollFrame:EnableMouseWheel(true);
    container.ScrollFrame:SetClipsChildren(true);

    child = child or _G.CreateFrame("Frame", nil, container.ScrollFrame);
    container.ScrollFrame:SetScrollChild(child);

    local padding = style:GetPadding(nil, true);
    Private:SetFullWidth(child, padding.right);

    -- ScrollBar ------------------
    container.ScrollBar = container.ScrollFrame.ScrollBar;
    container.ScrollBar:ClearAllPoints();
    container.ScrollBar:SetPoint("TOPLEFT", container.ScrollFrame, "TOPRIGHT", -7, -2);
    container.ScrollBar:SetPoint("BOTTOMRIGHT", container.ScrollFrame, "BOTTOMRIGHT", -2, 2);
    _G.hooksecurefunc(container.ScrollBar, "Show", HideIfAnimating);

    container.ScrollBar.thumb = container.ScrollBar:GetThumbTexture();
    style:ApplyColor(nil, 0.8, container.ScrollBar.thumb);
    container.ScrollBar.thumb:SetSize(5, 50);
    container.ScrollBar:Hide();

    Private:SetBackground(container.ScrollBar, 0, 0, 0, 0.2);
    Private:KillElement(container.ScrollBar.ScrollUpButton);
    Private:KillElement(container.ScrollBar.ScrollDownButton);
    ----------------------------

    container:SetScript("OnShow", DynamicScrollBar_OnChange);
    container:HookScript("OnSizeChanged", DynamicScrollBar_OnChange);

    container.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);
    container.ScrollFrame:HookScript("OnScrollRangeChanged", DynamicScrollBar_OnChange);

    return container;
end

function Lib:UpdateScrollFrameColor(container, style)
    style:ApplyColor(nil, 0.8, container.ScrollBar.thumb);
end