-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, _, obj = MayronUI:GetCoreComponents();

---@class MayronUI.GUIBuilder
local gui = MayronUI:GetComponent("GUIBuilder");

local math = _G.math;
local C_LinkedList = obj:Import("Pkg-Collections.LinkedList");

---@class MayronUI.Panel : Frame
local Panel = obj:CreateClass("Panel");
obj:Export(Panel, "MayronUI");

Panel.Static:AddFriendClass("MayronUI.Group");

---@return MayronUI.Panel
function gui:CreatePanel(frame, globalName, parent)
  return Panel(frame, globalName, parent);
end

function Panel:__Construct(data, frame, globalName, parent)
  self:SetFrame(frame or tk:CreateFrame("Frame", parent, globalName));
  data.grid = C_LinkedList();
  data.rowscale = obj:PopTable();
  data.columnscale = obj:PopTable();
  data.width = 1;
  data.height = 1;

  data.frame:HookScript("OnSizeChanged", function()
    self:ReloadGridLayout();
  end);
end

function Panel:GetDimensions(data)
  return data.width, data.height;
end

function Panel:SetDimensions(data, width, height)
  local squares = obj:PopTable(data.grid:Unpack());
  local i = 1;

  data.width = width;
  data.height = height;

  while (true) do
    if (i <= height * width) then
      if (not squares[i]) then
        local f = tk:CreateFrame("Frame", data.frame);

        if (data.devMode) then
          tk:SetBackground(f, math.random(), math.random(), math.random(), 0.2);
          f.t = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
          f.t:SetPoint("CENTER");
          f.t:SetText(i);
        end

        data.grid:AddToBack(f);
      end

    elseif (squares[i]) then
      data.grid:Remove(squares[i]);
    else
      break;
    end

    i = i + 1;
  end

  obj:PushTable(squares);
  self:ReloadGridLayout();
end

function Panel:SetDevMode(data, devMode)  -- shows or hides the red frame info overlays
  data.devMode = devMode;
end

function Panel:AddCells(data, ...)
  data.cells = data.cells or C_LinkedList(); ---@type Pkg-Collections.LinkedList

  for _, cell in obj:IterateArgs(...) do
    data.cells:AddToBack(cell);
    cell:SetPanel(self);
  end

  self:AnchorCells();
end

function Panel:GetCells(data, n)
  if (not data.cells) then
    return false;
  end
  return data.cells:Unpack(n);
end

obj:DefineParams("number");
function Panel:GetCellCoords(data, position)
  for row = 1, data.height do
    for column = 1, data.width do
      if ((row - 1) * data.width + column == position) then
        return column, row;
      end
    end
  end
end

-- reanchors all cells to the correct cellsList passed on their positions
function Panel:AnchorCells(data)
  if (not data.cells or not data.grid) then
    return false;
  end

  local cellsList = data.grid:ToTable();
  local takenCells = obj:PopTable();

  for currentCellId, cell in data.cells:Iterate() do
    if (not cellsList[currentCellId]) then
      break
    end

    while (takenCells[currentCellId]) do
      currentCellId = currentCellId + 1;
    end

    local cellData = data:GetFriendData(cell);
    local cellWidth = cellData.width or 1;
    local cellHeight = cellData.height or 1;

    local endCell = (currentCellId - 1) + ((cellHeight - 1) * data.width) + cellWidth;
    if (endCell > #cellsList or endCell <= 0) then
      endCell = #cellsList;
    end

    cellData.startAnchor = cellsList[currentCellId];
    cellData.endAnchor = cellsList[endCell];

    -- Builds a table of indexes representing each grid square on the panel and
    -- marks indexes as true if a cell is positioned over that square
    local startColumn, startRow = self:GetCellCoords(currentCellId);
    local endColumn, endRow = self:GetCellCoords(endCell);

    for nextCellId = currentCellId, endCell do
      local x, y = self:GetCellCoords(nextCellId);

      if (x >= startColumn and x <= endColumn) then
        if (y >= startRow and y <= endRow) then
          takenCells[nextCellId] = true;
        end
      end
    end

    -- place frame:
    local top = (cellData.insets and cellData.insets.top) or 0;
    local right = (cellData.insets and cellData.insets.right) or 0;
    local bottom = (cellData.insets and cellData.insets.bottom) or 0;
    local left = (cellData.insets and cellData.insets.left) or 0;

    cellData.frame:SetPoint("TOPLEFT", cellData.startAnchor, "TOPLEFT", left, -top);
    cellData.frame:SetPoint("BOTTOMRIGHT", cellData.endAnchor, "BOTTOMRIGHT", -right, bottom);
    cellData.frame:SetFrameLevel(3);
    cellData.frame:SetParent(cellsList[currentCellId]);
  end

  obj:PushTable(cellsList);
  obj:PushTable(takenCells);
end

function Panel:ReloadGridLayout(data)
  local cellsList = data.grid:ToTable();

  for id, cell in data.grid:Iterate() do
    if (id == 1) then
      cell:SetPoint("TOPLEFT", data.frame, "TOPLEFT");

    elseif (id % data.width == 1 or data.width == 1) then
      local anchor = cellsList[id - data.width];
      cell:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT");

    else
      local anchor = cellsList[id - 1];
      cell:SetPoint("TOPLEFT", anchor, "TOPRIGHT");
    end
  end

  local totalFixedWidth = data.fixedInfo and data.fixedInfo.width.total or 0;
  local totalFixedHeight = data.fixedInfo and data.fixedInfo.height.total or 0;
  local numFixedColumns = data.fixedInfo and data.fixedInfo.width.columns or 0;
  local numFixedRows = data.fixedInfo and data.fixedInfo.height.rows or 0;

  local width = (data.frame:GetWidth() - totalFixedWidth) / (data.width - numFixedColumns);
  local height = (data.frame:GetHeight() - totalFixedHeight) / (data.height - numFixedRows);

  for id, cell in data.grid:Iterate() do
    local rowNum = math.ceil(id / data.width);
    local columnNum = id % (data.width);
    columnNum = (columnNum == 0 and data.width) or columnNum;

    local rowscale = data.rowscale[rowNum] or 1;
    local columnscale = data.columnscale[columnNum] or 1;

    cell:SetWidth(cell.fixedWidth or (width * columnscale));
    cell:SetHeight(cell.fixedHeight or (height * rowscale));
  end
end