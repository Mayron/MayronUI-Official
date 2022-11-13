-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local _, _, _, gui, obj = MayronUI:GetCoreComponents();

local DynamicFrame = obj:CreateClass("DynamicFrame"); ---@class DynamicFrame
obj:Export(DynamicFrame, "MayronUI");

local mceil, mfloor, unpack, ipairs = _G.math.ceil, _G.math.floor, _G.unpack, _G.ipairs;
local tinsert, tremove, select = _G.table.insert, _G.table.remove, _G.select;

local function OnSizeChanged(self, width)
  width = mceil(width);

  -- Set container (relative) frame (either using a scroll frame or regular frame):
  local container = (self.ScrollFrame and self.ScrollFrame:GetScrollChild()) or self;
  local anchor = self.children[1];

  if (not anchor) then return end

  local totalRowWidth = 0; -- used to make new rows
  local largestHeightInPreviousRow = 0; -- used to position new rows with correct Y Offset away from previous row
  local totalHeight = 0; -- used to dynamically set the container frame's height so that is can be visible
  local previousChild;

  for id, child in ipairs(self.children) do
    if (child:IsShown()) then
      child:ClearAllPoints();
      totalRowWidth = totalRowWidth + child:GetWidth();

      if (id ~= 1) then
        totalRowWidth = totalRowWidth + self.spacing;
      end

      if ((totalRowWidth) > (width - self.padding * 2) or id == 1) then
        -- NEW ROW!
        if (id == 1) then
          child:SetPoint("TOPLEFT", container, "TOPLEFT", self.padding, -self.padding);
          totalHeight = totalHeight + self.padding;
        else
          local yOffset = (largestHeightInPreviousRow - anchor:GetHeight());
          yOffset = ((yOffset > 0 and yOffset) or 0) + self.spacing;

          child:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -(yOffset));
          totalHeight = totalHeight + self.spacing;

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
        child:SetPoint("TOPLEFT", previousChild, "TOPRIGHT", self.spacing, 0);

        if (child:GetHeight() > largestHeightInPreviousRow) then
          largestHeightInPreviousRow = child:GetHeight();
        end
      end

      previousChild = child;
    end
  end

  totalHeight = totalHeight + largestHeightInPreviousRow + self.padding;
  totalHeight = (totalHeight > 0 and totalHeight) or 10;
  totalHeight = mfloor(totalHeight + 0.5);

  -- update container frame's height dynamically:
  container:SetHeight(totalHeight);
end

-- Helper constructor!
function gui:CreateDynamicFrame(parent, spacing, padding, frame)
  frame = frame or gui:CreateScrollFrame(parent);
  frame:HookScript("OnSizeChanged", OnSizeChanged);
  frame.spacing = spacing or 4; -- the spacing around each inner element
  frame.padding = padding or 4; -- the padding around the entire container (which holds all the elements)

  return DynamicFrame(frame);
end

function DynamicFrame:__Construct(data, frame)
  data.scrollChild = frame.ScrollFrame and frame.ScrollFrame:GetScrollChild();
  self:SetFrame(frame);
  data.frame.children = obj:PopTable();
end

-- adds children to container of the ScrollFrame
function DynamicFrame:AddChildren(data, ...)
  local width, height = data.frame:GetSize();

  if (width == 0 and height == 0) then
    data.frame:SetSize(_G.UIParent:GetWidth(), _G.UIParent:GetHeight());
  end

  -- add child to children table and set parent
  if (select("#", ...) == 1) then
    local child = (select(1, ...));
    tinsert(data.frame.children, child);
    child:SetParent(data.scrollChild or data.frame);
  else
    for _, child in obj:IterateArgs(...) do
      tinsert(data.frame.children, child);
      child:SetParent(data.scrollChild or data.frame);
    end
  end

  -- position the child
  OnSizeChanged(data.frame, data.frame:GetWidth());
end

function DynamicFrame:RemoveChild(data, child)
  local foundId;
  for id, otherChild in ipairs(data.frame.children) do
    if (otherChild == child) then
      foundId = id;
      break
    end
  end

  if (foundId) then
    child:ClearAllPoints();
    child:Hide();
    tremove(data.frame.children, foundId);
    OnSizeChanged(data.frame, data.frame:GetWidth());
  else
    obj:Error("Failed to remove child from dynamic frame.")
  end
end

function DynamicFrame:GetChildren(data)
  return unpack(data.frame.children);
end

function DynamicFrame:Refresh(data)
  OnSizeChanged(data.frame, data.frame:GetWidth());
end