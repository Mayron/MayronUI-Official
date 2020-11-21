-- luacheck: ignore self

---@type LibMayronObjects
local obj = _G.LibStub:GetLibrary("LibMayronObjects");

if (not obj) then return; end

---@type Package
local GridPanels = obj:Import("GridPanels.Main");

---@type Group
local Group = GridPanels:Get("Group");
---------------------------------

function Group:__Construct(data, groupID, groupType, grid)
  data.type = groupType;
  data.id = groupID;
  data.grid = grid;
end

GridPanels:DefineParams("number");
function Group:SetScale(data, scale)
  local gridData = data:GetFriendData(data.grid);

  if (data.type == "row") then
    gridData.rowscale[data.id] = scale;

  elseif (data.type == "column") then
    gridData.columnscale[data.id] = scale;
  end

  if (gridData.cells) then
    gridData:OnSizeChanged();
  end
end

GridPanels:DefineParams("number");
function Group:SetFixed(data, value)
  local gridData = data:GetFriendData(data.grid);

  if (value and not gridData.fixedInfo) then
    gridData.fixedInfo = obj:PopTable();
    gridData.fixedInfo.width = obj:PopTable();
    gridData.fixedInfo.height = obj:PopTable();
  end

  for position, cell in gridData.cells:Iterate() do
    local column, row = gridData:GetCoords(position);

    if (data.type == "column" and column == data.id) then
      cell.fixedWidth = value;

    elseif (data.type == "row" and row == data.id) then
      cell.fixedHeight = value;
    end
  end

  if (data.type == "column") then
    gridData.fixedInfo.width.total = (gridData.fixedInfo.width.total or 0) + value;
    gridData.fixedInfo.width.columns = (gridData.fixedInfo.width.columns or 0) + 1;

  elseif (data.type == "row") then
    gridData.fixedInfo.height.total = (gridData.fixedInfo.height.total or 0) + value;
    gridData.fixedInfo.height.rows = (gridData.fixedInfo.height.rows or 0) + 1;
  end

  if (gridData.cells) then
    gridData:OnSizeChanged();
  end
end