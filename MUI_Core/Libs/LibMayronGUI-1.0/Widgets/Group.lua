-- luacheck: ignore MayronUI self 143 631

---@type LibMayronGUI
local Lib = _G.LibStub:GetLibrary("LibMayronGUI");

if (not Lib) then return; end

local WidgetsPackage = Lib.WidgetsPackage;
local Private = Lib.Private;
local obj = Lib.Objects;

local Group = WidgetsPackage:CreateClass("Group", Private.FrameWrapper);
local Panel = Private.Panel; ---@type Panel
---------------------------------

local function GetGroup(groupID, groupType, panel, panelData)
    if (not panelData.grid) then
        return false;
    end

    local cellsList = obj:PopTable();

    for position, cell in panelData.grid:Iterate() do
        local column, row = Private:GetCoords(position, panelData.width, panelData.height);

        if ((groupType == "row" and row == groupID) or (groupType == "column" and column == groupID)) then
            table.insert(cellsList, cell);
        end
    end

    local cellsLinkedList = Private.LinkedList(_G.unpack(cellsList));

    obj:PushTable(cellsList);
    return Group(groupID, groupType, cellsLinkedList, panel);
end

function Panel:GetRow(data, rowID)
    return GetGroup(rowID, "row", self, data);
end

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
        Private:OnSizeChanged(panelData);
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
        local column, row = Private:GetCoords(position, panelData.width, panelData.height);

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
        Private:OnSizeChanged(panelData);
    end
end