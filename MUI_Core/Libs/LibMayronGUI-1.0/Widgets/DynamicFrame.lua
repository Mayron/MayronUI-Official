-- luacheck: ignore MayronUI self 143 631
local Lib = _G.LibStub:GetLibrary("LibMayronGUI");

if (not Lib) then
    return
end

local WidgetsPackage = Lib.WidgetsPackage;
local Private = Lib.Private;
local DynamicFrame = WidgetsPackage:CreateClass("DynamicFrame", Private.FrameWrapper);
local obj = Lib.Objects;

---------------------------------

local function OnSizeChanged(self, width)
    width = math.ceil(width);

    local scrollChild = self.ScrollFrame:GetScrollChild();
    local anchor = select(1, scrollChild:GetChildren());

    if (not anchor) then
        return;
    end

    local totalRowWidth = 0; -- used to make new rows
    local largestHeightInPreviousRow = 0; -- used to position new rows with correct Y Offset away from previous row
    local totalHeight = 0; -- used to dynamically set the ScrollChild's height so that is can be visible
    local previousChild;

    for id, child in obj:IterateArgs(scrollChild:GetChildren()) do
        child:ClearAllPoints();
        totalRowWidth = totalRowWidth + child:GetWidth();

        if (id ~= 1) then
            totalRowWidth = totalRowWidth + self.spacing;
        end

        if ((totalRowWidth) > (width - self.padding * 2) or id == 1) then
            -- NEW ROW!
            if (id == 1) then
                child:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", self.padding, -self.padding);
                totalHeight = totalHeight + self.padding;
            else
                local yOffset = (largestHeightInPreviousRow - anchor:GetHeight());
                yOffset = ((yOffset > 0 and yOffset) or 0) + self.spacing;

                child:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -(yOffset));
                totalHeight = totalHeight + self.spacing;
                anchor = child;
            end

            totalRowWidth = child:GetWidth();
            totalHeight = totalHeight + largestHeightInPreviousRow;
            largestHeightInPreviousRow = child:GetHeight();
        else
            child:SetPoint("TOPLEFT", previousChild, "TOPRIGHT", self.spacing, 0);

            if (child:GetHeight() > largestHeightInPreviousRow) then
                largestHeightInPreviousRow = child:GetHeight();
            end
        end

        previousChild = child;
    end

    totalHeight = totalHeight + largestHeightInPreviousRow + self.padding;
    totalHeight = (totalHeight > 0 and totalHeight) or 10;
    totalHeight = math.floor(totalHeight + 0.5);

    -- update ScrollChild Height dynamically:
    scrollChild:SetHeight(totalHeight);

    if (self.parentScrollFrame) then
        local parent = self.parentScrollFrame;
        OnSizeChanged(parent, parent:GetWidth(), parent:GetHeight());
    end
end

-- Helper constructor!
function Lib:CreateDynamicFrame(style, parent, spacing, padding)
    local scrollFrameContainer = Lib:CreateScrollFrame(style, parent, nil, padding);

    scrollFrameContainer:HookScript("OnSizeChanged", OnSizeChanged);
    scrollFrameContainer.spacing = spacing or 4; -- the spacing around each inner element
    scrollFrameContainer.padding = padding or 4; -- the padding around the entire container (which holds all the elements)

    return DynamicFrame(scrollFrameContainer);
end

function DynamicFrame:__Construct(data, scrollFrameContainer)
    data.scrollChild = scrollFrameContainer.ScrollFrame:GetScrollChild();
    data.frame = scrollFrameContainer;
end

-- adds children to ScrollChild of the ScrollFrame
function DynamicFrame:AddChildren(data, ...)
    local width, height = data.frame:GetSize();

    if (width == 0 and height == 0) then
        data.frame:SetSize(_G.UIParent:GetWidth(), _G.UIParent:GetHeight());
    end

    for _, child in obj:IterateArgs(...) do
        child:SetParent(data.scrollChild);
    end

    OnSizeChanged(data.frame, data.frame:GetWidth(), data.frame:GetHeight());
end

function DynamicFrame:GetChildren(data)
    return data.scrollChild:GetChildren();
end

-- TODO
-- function DynamicFrame:RemoveChild(data, child) end