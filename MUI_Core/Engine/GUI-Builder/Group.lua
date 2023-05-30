-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local _, _, _, _, obj = MayronUI:GetCoreComponents();

local Group = obj:CreateClass("Group")---@class MayronUI.PanelGroup;
obj:Export(Group, "MayronUI");

local Panel = obj:Import("MayronUI.Panel"); ---@class MayronUI.Panel
local LinkedList = obj:Import("Pkg-Collections.LinkedList");

local tinsert = _G.table.insert;
---------------------------------

---@return MayronUI.PanelGroup
local function GetGroup(groupID, groupType, panel, panelData)
  if (not panelData.grid) then
    obj:Error("Failed to get panel group with groupID "..groupID);
  end

  local cellsList = obj:PopTable();

  for position, cell in panelData.grid:Iterate() do
    local column, row = panel:GetCellCoords(position);

    if ((groupType == "row" and row == groupID) or (groupType == "column" and column == groupID)) then
      tinsert(cellsList, cell);
    end
  end

  local cellsLinkedList = LinkedList(_G.unpack(cellsList));

  obj:PushTable(cellsList);
  return Group(groupID, groupType, cellsLinkedList, panel);
end

---@return MayronUI.PanelGroup
function Panel:GetRow(data, rowID)
    return GetGroup(rowID, "row", self, data);
end

---@return MayronUI.PanelGroup
function Panel:GetColumn(data, columnID)
    return GetGroup(columnID, "column", self, data);
end

function Group:__Construct(data, groupID, groupType, cellsLinkedList, panel)
    data.CellsLinkedList = cellsLinkedList; -- is this being used?
    data.Type = groupType;
    data.ID = groupID;
    data.Panel = panel;
end

function Group:SetScale(data, scale)
    local panelData = data:GetFriendData(data.Panel);

    if (data.Type == "row") then
        panelData.rowscale[data.ID] = scale;

    elseif (data.Type == "column") then
        panelData.columnscale[data.ID] = scale;
    end

    if (panelData.grid) then
      data.Panel:ReloadGridLayout();
    end
end

function Group:SetFixed(data, value)
  local panelData = data:GetFriendData(data.Panel);

  if (value and not panelData.fixedInfo) then
    panelData.fixedInfo = obj:PopTable();
    panelData.fixedInfo.width = obj:PopTable();
    panelData.fixedInfo.height = obj:PopTable();
  end

  for position, squares in panelData.grid:Iterate() do
    local column, row = data.Panel:GetCellCoords(position);

    if (data.Type == "column" and column == data.ID) then
      squares.fixedWidth = value;

    elseif (data.Type == "row" and row == data.ID) then
      squares.fixedHeight = value;
    end
  end

  if (data.Type == "column") then
    panelData.fixedInfo.width.total = (panelData.fixedInfo.width.total or 0) + value;
    panelData.fixedInfo.width.columns = (panelData.fixedInfo.width.columns or 0) + 1;

  elseif (data.Type == "row") then
    panelData.fixedInfo.height.total = (panelData.fixedInfo.height.total or 0) + value;
    panelData.fixedInfo.height.rows = (panelData.fixedInfo.height.rows or 0) + 1;
  end

  if (panelData.grid) then
    data.Panel:ReloadGridLayout();
  end
end