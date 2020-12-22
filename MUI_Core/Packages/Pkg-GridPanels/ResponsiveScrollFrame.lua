-- luacheck: ignore self
local obj = _G.MayronObjects:GetFramework(); ---@type MayronObjects
if (obj:Import("GridPanels.Main.ResponsiveScrollFrame", true)) then return end

local GridPanels = obj:Import("GridPanels.Main"); ---@type Package
local ResponsiveScrollFrame = GridPanels:Get("ResponsiveScrollFrame"); ---@type ResponsiveScrollFrame

local CreateFrame, ipairs, math = _G.CreateFrame, _G.ipairs, _G.math;
local table, unpack, UIParent = _G.table, _G.unpack, _G.UIParent;

---------------------------------
--- Local functions
---------------------------------
local function ScrollFrame_OnMouseWheel(self, step)
  local newValue = self:GetVerticalScroll() - (step * 20);

  if (newValue < 0) then
    newValue = 0;
    -- max scroll range is scrollchild.height - scrollframe.height!
  elseif (newValue > self:GetVerticalScrollRange()) then
    newValue = self:GetVerticalScrollRange();
  end

  self:SetVerticalScroll(newValue);
end

--------------------------------------
--- ResponsiveScrollFrame functions
--------------------------------------
function ResponsiveScrollFrame:__Construct(data, containerFrame, globalName, parent, child)
  data.frame = containerFrame or CreateFrame("Frame", globalName,
    parent or UIParent, _G.BackdropTemplateMixin and "BackdropTemplate");

  data.spacing = 4;
  data.padding = 4;
  data.children = obj:PopTable();

  local UpdateScrollBarShownState = function() data:UpdateScrollBarShownState() end

  data.frame:SetScript("OnShow", UpdateScrollBarShownState);
  data.frame:HookScript("OnSizeChanged", function() data:RepositionChildElements() end);

  if (data.frame:GetMinResize() == 0) then
    data.frame:SetMinResize(200, 200);
  end

  data.scrollFrame = CreateFrame("ScrollFrame", nil, data.frame, "UIPanelScrollFrameTemplate");
  data.scrollFrame:SetAllPoints(true);
  data.scrollFrame:EnableMouseWheel(true);
  data.scrollFrame:SetClipsChildren(true);
  data.scrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);
  data.scrollFrame:HookScript("OnScrollRangeChanged", UpdateScrollBarShownState);

  child = child or CreateFrame("Frame");
  child:SetParent(data.scrollFrame);
  data.scrollFrame:SetScrollChild(child);

  -- built-in by Blizzard
  data.scrollBar = data.scrollFrame.ScrollBar;
  data.scrollBar:ClearAllPoints();
  data.scrollBar:SetPoint("TOPLEFT", data.scrollFrame, "TOPRIGHT", -20, -20);
  data.scrollBar:SetPoint("BOTTOMRIGHT", data.scrollFrame, "BOTTOMRIGHT", 0, 20);

end

GridPanels:DefineParams("number");
-- the spacing around each inner element
function ResponsiveScrollFrame:SetElementSpacing(data, spacing)
  data.spacing = spacing;

  if (#data.children > 0) then
    data:RepositionChildElements();
  end
end

GridPanels:DefineParams("number");
-- the padding around the entire container (which holds all the elements)
function ResponsiveScrollFrame:SetContainerPadding(data, padding)
  data.padding = padding;

  if (#data.children > 0) then
    data:RepositionChildElements();
  end
end

-- adds children to ScrollChild of the ScrollFrame
function ResponsiveScrollFrame:AddChildren(data, ...)
  local scrollChild = data.scrollFrame:GetScrollChild();
  obj:Assert(scrollChild, "Failed to add children to ResponsiveScrollFrame - missing scroll child.");

  local width, height = data.frame:GetSize();

  if (width == 0 and height == 0) then
    data.frame:SetSize(UIParent:GetWidth(), UIParent:GetHeight());
  end

  for _, child in obj:IterateArgs(...) do
    table.insert(data.children, child);
    child:SetParent(scrollChild);
  end

  data:RepositionChildElements();
end

function ResponsiveScrollFrame:GetChildren(data)
  return unpack(data.children);
end

function ResponsiveScrollFrame:GetScrollFrame(data)
  return data.scrollFrame;
end

function ResponsiveScrollFrame:GetScrollBar(data)
  return data.scrollBar; -- built-in by Blizzard
end

function ResponsiveScrollFrame:GetScrollBarButtons(data)
   -- built-in by Blizzard
  return data.scrollBar.ScrollUpButton, data.scrollBar.ScrollDownButton;
end

function ResponsiveScrollFrame:GetScrollBarThumbTexture(data)
  return data.scrollBar:GetThumbTexture(); -- built-in by Blizzard
end

function ResponsiveScrollFrame:MakeResizable(data, dragger)
  dragger = dragger or data.frame;
  data.frame:SetResizable(true);
  dragger:RegisterForDrag("LeftButton");
  dragger:EnableMouse(true);

  dragger:HookScript("OnDragStart", function()
    data.frame:StartSizing();
  end);

  dragger:HookScript("OnDragStop", function()
    data.frame:StopMovingOrSizing();
  end);
end

function ResponsiveScrollFrame.Private:UpdateScrollBarShownState(data)
  local scrollChild = data.scrollFrame:GetScrollChild();

  if (not scrollChild) then
    data.scrollBar:Hide();
    return;
  end

  local scrollChildHeight = math.floor(scrollChild:GetHeight() + 0.5);
  local containerHeight = math.floor(data.frame:GetHeight() + 0.5);

  -- dynamically show and hide scroll bar if needed
  data.scrollBar:SetShown(scrollChildHeight > containerHeight);
end

function ResponsiveScrollFrame.Private:RepositionChildElements(data)
  local scrollChild = data.scrollFrame:GetScrollChild();
  local width = math.ceil(data.frame:GetWidth());
  local anchor = data.children[1];

  if (not anchor) then return end

  local totalRowWidth = 0; -- used to make new rows
  local largestHeightInPreviousRow = 0; -- used to position new rows with correct Y Offset away from previous row
  local totalHeight = 0; -- used to dynamically set the ScrollChild's height so that is can be visible
  local previousChild;

  for id, child in ipairs(data.children) do
    child:ClearAllPoints();
    totalRowWidth = totalRowWidth + child:GetWidth();

    if (id ~= 1) then
      totalRowWidth = totalRowWidth + data.spacing;
    end

    if ((totalRowWidth) > (width - data.padding * 2) or id == 1) then
      -- NEW ROW!
      if (id == 1) then
        child:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", data.padding, -data.padding);
        totalHeight = totalHeight + data.padding;
      else
        local yOffset = (largestHeightInPreviousRow - anchor:GetHeight());
        yOffset = ((yOffset > 0 and yOffset) or 0) + data.spacing;

        child:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -(yOffset));
        totalHeight = totalHeight + data.spacing;

        if (child.GetFrame) then
          anchor = child:GetFrame();
        else
          anchor = child;
        end
      end

      totalRowWidth = child:GetWidth();
      totalHeight = totalHeight + largestHeightInPreviousRow;
      largestHeightInPreviousRow = child:GetHeight();
    else
      child:SetPoint("TOPLEFT", previousChild, "TOPRIGHT", data.spacing, 0);

      if (child:GetHeight() > largestHeightInPreviousRow) then
        largestHeightInPreviousRow = child:GetHeight();
      end
    end

    previousChild = child;
  end

  totalHeight = totalHeight + largestHeightInPreviousRow + data.padding;
  totalHeight = (totalHeight > 0 and totalHeight) or 10;
  totalHeight = math.floor(totalHeight + 0.5);

  scrollChild:SetSize(data.frame:GetWidth(), totalHeight);
  data:Call("UpdateScrollBarShownState");
end