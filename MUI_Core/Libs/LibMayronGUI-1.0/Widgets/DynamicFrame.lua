-- luacheck: ignore MayronUI self 143 631

---@type LibMayronGUI
local Lib = _G.LibStub:GetLibrary("LibMayronGUI");
if (not Lib) then return; end

local obj = _G.MayronObjects:GetFramework();
local DynamicFrame = obj:CreateClass("DynamicFrame");
obj:Export(DynamicFrame, "MayronUI");
local mceil, mfloor, unpack, ipairs = _G.math.ceil, _G.math.floor, _G.unpack, _G.ipairs;

local function OnSizeChanged(self, width)
  width = mceil(width);

  local scrollChild = self.ScrollFrame:GetScrollChild();
  local anchor = self.children[1];

  if (not anchor) then return end

  local totalRowWidth = 0; -- used to make new rows
  local largestHeightInPreviousRow = 0; -- used to position new rows with correct Y Offset away from previous row
  local totalHeight = 0; -- used to dynamically set the ScrollChild's height so that is can be visible
  local previousChild;

  for id, child in ipairs(self.children) do
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

  totalHeight = totalHeight + largestHeightInPreviousRow + self.padding;
  totalHeight = (totalHeight > 0 and totalHeight) or 10;
  totalHeight = mfloor(totalHeight + 0.5);

  -- update ScrollChild Height dynamically:
  scrollChild:SetHeight(totalHeight);
end

-- Helper constructor!
function Lib:CreateDynamicFrame(style, parent, spacing, padding)
  local scrollFrameContainer = Lib:CreateScrollFrame(style, parent);

  scrollFrameContainer:HookScript("OnSizeChanged", OnSizeChanged);
  scrollFrameContainer.spacing = spacing or 4; -- the spacing around each inner element
  scrollFrameContainer.padding = padding or 4; -- the padding around the entire container (which holds all the elements)

  return DynamicFrame(scrollFrameContainer);
end

function DynamicFrame:__Construct(data, scrollFrameContainer)
  data.scrollChild = scrollFrameContainer.ScrollFrame:GetScrollChild();
  self:SetFrame(scrollFrameContainer);
  data.frame.children = obj:PopTable();
end

-- adds children to ScrollChild of the ScrollFrame
function DynamicFrame:AddChildren(data, ...)
    local width, height = data.frame:GetSize();

    if (width == 0 and height == 0) then
        data.frame:SetSize(_G.UIParent:GetWidth(), _G.UIParent:GetHeight());
    end

    for _, child in obj:IterateArgs(...) do
        _G.table.insert(data.frame.children, child);
        child:SetParent(data.scrollChild);
    end

    OnSizeChanged(data.frame, data.frame:GetWidth());
end

function DynamicFrame:GetChildren(data)
  return unpack(data.frame.children);
end