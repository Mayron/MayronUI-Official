-- luacheck: ignore self 143 631
local obj = _G.LibStub:GetLibrary("LibMayronObjects"); ---@type LibMayronObjects
if (not obj) then return; end

local GridPanels = obj:CreatePackage("Main", "GridPanels"); ---@type Package
local C_LinkedList = obj:Import("Framework.System.Collections.LinkedList"); ---@type LinkedList
local C_FrameWrapper = obj:Import("Framework.System.FrameWrapper");

local Grid = GridPanels:CreateClass("Grid", C_FrameWrapper); ---@class Grid : FrameWrapper
Grid.Static:AddFriendClass("Group");
Grid.Static:AddFriendClass("Region");

local Region = GridPanels:CreateClass("Region", C_FrameWrapper); ---@class Region : Object
Region.Static:AddFriendClass("Grid");

local Group = GridPanels:CreateClass("Group", C_FrameWrapper); ---@class Group : Object
Group.Static:AddFriendClass("Grid");

GridPanels:CreateClass("ResponsiveScrollFrame", C_FrameWrapper); ---@class ResponsiveScrollFrame : Object

local math, select, CreateFrame = _G.math, _G.select, _G.CreateFrame;

local private = obj:PopTable();
private.DUMMY_FRAME = CreateFrame("Frame");

---------------------------------
--- private functions
---------------------------------
function private:GetCoords(position)
  for row = 1, self.height do
    for column = 1, self.width do
      if ((row - 1) * self.width + column == position) then
        return column, row;
      end
    end
  end
end

function private:BuildPattern(startPos, endPos, pattern)
  local startColumn, startRow = self:GetCoords(startPos);
  local endColumn, endRow = self:GetCoords(endPos);

  for id = startPos, endPos do
    local x, y = self:GetCoords(id);

    if (x >= startColumn and x <= endColumn) then
      if (y >= startRow and y <= endRow) then
        pattern[id] = true;
      end
    end
  end
end

function private:AnchorRegions()
  if (not self.regions or not self.cells) then
    return false;
  end

  local cells = obj:PopTable(self.cells:Unpack());
  local takenRegions = obj:PopTable();

  for id, region in self.regions:Iterate() do
    if (not cells[id]) then
      -- Dynamically increase width or height if no room for Region and dimension set to "auto"
      if (self.autoWidth) then
        self.Grid:SetDimensions(self.width + 1, self.height);
        obj:PushTable(cells);
        cells = obj:PopTable(self.cells:Unpack());

      elseif (self.autoHeight) then
        self.Grid:SetDimensions(self.width, self.height + 1);
        obj:PushTable(cells);
        cells = obj:PopTable(self.cells:Unpack());

      else
        break; -- cannot fit and not set to "Scale to fit"
      end
    end

    while (takenRegions[id]) do
      id = id + 1;
    end

    local RegionData = self:GetFriendData(region);
    local RegionWidth = RegionData.width or 1;
    local RegionHeight = RegionData.height or 1;

  -- calculate the end Region to attach to on the row
    local endRegion = (id - 1) + ((RegionHeight - 1) * self.width) + RegionWidth;

    -- range check
    if (endRegion > #cells or endRegion <= 0) then
      endRegion = #cells;
    end

    RegionData.startAnchor = cells[id];
    RegionData.endAnchor = cells[endRegion];

    self:BuildPattern(id, endRegion, takenRegions);

    -- place frame:
    local top = (RegionData.insets and RegionData.insets.top) or 0;
    local right = (RegionData.insets and RegionData.insets.right) or 0;
    local bottom = (RegionData.insets and RegionData.insets.bottom) or 0;
    local left = (RegionData.insets and RegionData.insets.left) or 0;

    RegionData.frame:SetPoint("TOPLEFT", RegionData.startAnchor, "TOPLEFT", left, -top);
    RegionData.frame:SetPoint("BOTTOMRIGHT", RegionData.endAnchor, "BOTTOMRIGHT", -right, bottom);
    RegionData.frame:SetFrameLevel(3);
    RegionData.frame:SetParent(cells[id]);
  end

  obj:PushTable(cells);
  obj:PushTable(takenRegions);
end

-- Helper Functions
function private:SetBackground(frame, ...)
  local texture = frame:CreateTexture(nil, "BACKGROUND");

  -- make room for the border!
  texture:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1);
  texture:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1);

  if (select("#", ...) > 1) then
    texture:SetColorTexture(...);
  else
    texture:SetTexture(...);
  end

  return texture;
end

function private:OnSizeChanged()
  local totalFixedWidth = self.fixedInfo and self.fixedInfo.width.total or 0;
  local totalFixedHeight = self.fixedInfo and self.fixedInfo.height.total or 0;
  local numFixedColumns = self.fixedInfo and self.fixedInfo.width.columns or 0;
  local numFixedRows = self.fixedInfo and self.fixedInfo.height.rows or 0;

  local width = (self.frame:GetWidth() - totalFixedWidth) / (self.width - numFixedColumns);
  local height = (self.frame:GetHeight() - totalFixedHeight) / (self.height - numFixedRows);

  for id, region in self.cells:Iterate() do
    local rowNum = math.ceil(id / self.width);
    local columnNum = id % (self.width);
    columnNum = (columnNum == 0 and self.width) or columnNum;

    local rowscale = self.rowscale[rowNum] or 1;
    local columnscale = self.columnscale[columnNum] or 1;

    region:SetWidth(region.fixedWidth or (width * columnscale));
    region:SetHeight(region.fixedHeight or (height * rowscale));
  end
end

function private:SetupGrid()
  local cells = obj:PopTable(self.cells:Unpack());

  for id, region in self.cells:Iterate() do
    if (id == 1) then
      region:SetPoint("TOPLEFT", self.frame, "TOPLEFT");

    elseif (id % self.width == 1 or self.width == 1) then
      local anchor = cells[id - self.width];
      region:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT");

    else
      local anchor = cells[id - 1];
      region:SetPoint("TOPLEFT", anchor, "TOPRIGHT");
    end
  end

  obj:PushTable(cells);
  self:OnSizeChanged();
end

do
  local frames = obj:PopTable();

  function private:PopFrame(objectType, parent)
    parent = parent or _G.UIParent;
    objectType = objectType or "Frame";

    local frame = frames[objectType] and frames[objectType][#frames];

    if (not frame) then
      frame = CreateFrame(objectType);
    else
      frames[objectType][#frames] = nil;
    end

    frame:ClearAllPoints(true);
    frame:SetParent(parent);
    frame:Show();

    return frame;
  end

  function private:PushFrame(frame)
    if (not frame.GetObjectType) then return end

    local objectType = frame:GetObjectType();

    frames[objectType] = frames[objectType] or obj:PopTable();
    frame:SetParent(self.DUMMY_FRAME);
    frame:SetAllPoints(true);
    frame:Hide();

    for _, child in obj:IterateArgs(frame:GetChildren()) do
      self:PushFrame(child);
    end

    for _, region in obj:IterateArgs(frame:GetRegions()) do
      region:SetParent(self.DUMMY_FRAME);
      region:SetAllPoints(true);
      region:Hide();
    end

    frames[objectType][#frames + 1] = frame;
  end
end

---------------------------------
--- Grid
---------------------------------
function Grid:__Construct(data, frame, globalName, parent)
  data.frame = frame or CreateFrame("Frame", globalName,
    parent or _G.UIParent, _G.BackdropTemplateMixin and "BackdropTemplate");

  data.cells = C_LinkedList();
  data.rowscale = obj:PopTable();
  data.columnscale = obj:PopTable();
  data.width = 1;
  data.height = 1;
  data:Embed(private);
  data.Grid = self;

  data.frame:HookScript("OnSizeChanged", function()
    data:OnSizeChanged();
  end);
end

-- helper function so you don't need to manually import the Region object
function Grid:CreateRegion(_, frame, globalName, parent)
  return Region(frame, globalName, parent);
end

GridPanels:DefineReturns("number|string", "number|string");
function Grid:GetDimensions(data)
  return data.width, data.height;
end

GridPanels:DefineParams("number|string", "number|string");
function Grid:SetDimensions(data, width, height)
  local cells = obj:PopTable(data.cells:Unpack());

  data.width = width;
  data.height = height;

  if (width == "auto") then
    data.width = 1;
    data.autoWidth = true;
  end

  if (height == "auto") then
    data.height = 1;
    data.autoHeight = true;
  end

  local i = 1;
  while (true) do
    if (i <= data.height * data.width) then
      if (not cells[i]) then
        local f = data:PopFrame("Frame", data.frame);

        if (data.devMode) then
          data:SetBackground(f, math.random(), math.random(), math.random(), 0.2);
          f.t = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
          f.t:SetPoint("CENTER");
          f.t:SetText(i);
        end

        data.cells:AddToBack(f);
      end

    elseif (cells[i]) then
      data.cells:Remove(cells[i]);
      data:PushFrame(cells[i]);
    else
      break;
    end

    i = i + 1;
  end

  obj:PushTable(cells);
  data:SetupGrid();
end

GridPanels:DefineParams("boolean");
function Grid:SetDevMode(data, devMode)  -- shows or hides the red frame info overlays
  data.devMode = devMode;
end

---@vararg Region
GridPanels:DefineParams("Region");
function Grid:AddRegions(data, ...)
  data.regions = data.regions or C_LinkedList();

  for _, region in obj:IterateArgs(...) do
    data.regions:AddToBack(region);
    region:SetGrid(self);
  end

  data:AnchorRegions();
end

GridPanels:DefineParams("?number");
GridPanels:DefineReturns("?Region");
function Grid:GetRegions(data, n)
  if (not data.regions) then return end
  return data.regions:Unpack(n);
end

GridPanels:DefineParams("number");
GridPanels:DefineReturns("?Group");
---@return Group
function Grid:GetRow(data, rowID)
  if (not data.cells) then return end
  return Group(rowID, "row", self);
end

GridPanels:DefineParams("number");
GridPanels:DefineReturns("?Group");
---@return Group
function Grid:GetColumn(data, columnID)
  if (not data.cells) then return end
  return Group(columnID, "column", self);
end

function Grid:MakeResizable(data, dragger)
  dragger = dragger or data.frame;
  data.frame:SetResizable(true);
  dragger:RegisterForDrag("LeftButton");

  dragger:HookScript("OnDragStart", function()
    data.frame:StartSizing();
  end);

  dragger:HookScript("OnDragStop", function()
    data.frame:StopMovingOrSizing();
  end);
end