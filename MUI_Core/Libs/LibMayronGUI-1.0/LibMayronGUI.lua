local addonName = ...;

local Lib = LibStub:NewLibrary("LibMayronGUI", 1.0);
if (not Lib) then return; end

local obj = LibStub:GetLibrary("LibMayronObjects");
local Private = {};

Lib.WidgetsPackage = obj:CreatePackage("Widgets", "MayronUI");
Lib.Objects = obj;
Lib.Private = Private;

Private.DUMMY_FRAME = CreateFrame("Frame");
Private.DUMMY_FUNC = function() end;
Private.FrameWrapper = obj:Import("Framework.System.FrameWrapper");
Private.LinkedList = obj:Import("Framework.System.Collections.LinkedList");
-----------------------------
-----------------------------

function Private:ToolTip_OnEnter(frame)
    GameTooltip:SetOwner(frame, "ANCHOR_TOP", 0, 2);
    GameTooltip:AddLine(frame.tooltip);
    GameTooltip:Show();
end

function Private:ToolTip_OnLeave(frame)
    GameTooltip:Hide();
end

-- adjusts the size of all cellsList
function Private:OnSizeChanged(data)
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

function Private:SetupGrid(data)
    local cellsList = {data.grid:Unpack()};

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

    self:OnSizeChanged(data);
end

function Private:GetCoords(position, width, height)
    for row = 1, height do
        for column = 1, width do
            if ((row - 1) * width + column == position) then
                return column, row;
            end
        end
    end
end

function Private:KillElement(element)
    element:Hide();
    element:SetAllPoints(self.DUMMY_FRAME);
    element.Show = self.DUMMY_FUNC;
end

-- Builds a table of indexes representing each grid square on the panel and
-- marks indexes as true if a cell is positioned over that square
function Private:BuildPattern(start_pos, end_pos, width, height, pattern)
    local startColumn, startRow = self:GetCoords(start_pos, width, height);
    local endColumn, endRow = self:GetCoords(end_pos, width, height);

    for id = start_pos, end_pos do
        local x, y = self:GetCoords(id, width, height);

        if (x >= startColumn and x <= endColumn) then
            if (y >= startRow and y <= endRow) then
                pattern[id] = true;
            end
        end
    end
end

-- reanchors all cells to the correct cellsList passed on their positions
function Private:AnchorCells(data)
    if (not data.cells or not data.grid) then 
        return false;
    end

    local cellsList = {data.grid:Unpack()};
    local takenCells = {};

    for id, cell in data.cells:Iterate() do
        if (not cellsList[id]) then 
            break; 
        end

        while (takenCells[id]) do 
            id = id + 1; 
        end

        local cellData = data:GetFriendData(cell);
        local cellWidth = cellData.width or 1;
        local cellHeight = cellData.height or 1;

        local endCell = (id - 1) + ((cellHeight - 1) * data.width) + cellWidth;
        if (endCell > #cellsList or endCell <= 0) then 
            endCell = #cellsList; 
        end

        cellData.startAnchor = cellsList[id];
        cellData.endAnchor = cellsList[endCell];

        Private:BuildPattern(id, endCell, data.width, data.height, takenCells);

        -- place frame:
        local top = (cellData.insets and cellData.insets.top) or 0;
        local right = (cellData.insets and cellData.insets.right) or 0;
        local bottom = (cellData.insets and cellData.insets.bottom) or 0;
        local left = (cellData.insets and cellData.insets.left) or 0;
        
        cellData.frame:SetPoint("TOPLEFT", cellData.startAnchor, "TOPLEFT", left, -top);
        cellData.frame:SetPoint("BOTTOMRIGHT", cellData.endAnchor, "BOTTOMRIGHT", -right, bottom);
        cellData.frame:SetFrameLevel(3);
        cellData.frame:SetParent(cellsList[id]);
    end
end

-- Helper Functions
function Private:SetBackground(frame, ...)
    local texture = frame:CreateTexture(nil, "BACKGROUND");
    texture:SetAllPoints(frame);
    
    if (#{...} > 1) then
       texture:SetColorTexture(...);
    else
        texture:SetTexture(...);
    end

    return texture;
end

do
    local frames = {};

    function Private:PopFrame(objectType, parent)
        parent = parent or self.UIParent;
        objectType = objectType or "Frame";

        local frame = frames[objectType] and frames[objectType][#frames];

        if (not frame) then
            frame = CreateFrame(objectType);
        else
            frames[objectType][#frames] = nil;
        end

        frame:SetParent(parent);
        frame:Show();

        return frame;
    end

    function Private:PushFrame(frame)
        if (not frame.GetObjectType) then
             return; 
        end

        local objectType = frame:GetObjectType();

        frames[objectType] = frames[objectType] or {};
        frame:SetParent(self.DUMMY_FRAME);
        frame:SetAllPoints(true);
        frame:Hide();

        for _, child in pairs({frame:GetChildren()}) do
            self:PushFrame(child);
        end

        for _, region in pairs({frame:GetRegions()}) do
            region:SetParent(self.DUMMY_FRAME);
            region:SetAllPoints(true);
            region:Hide();
        end

        frames[objectType][#frames + 1] = frame;
    end
end

function Private:MakeMovable(frame, dragger, movable)
    if (movable == nil) then -- false is allowed
        movable = true;
    end

    dragger = dragger or frame;
    dragger:EnableMouse(movable);
    dragger:RegisterForDrag("LeftButton");

    frame:SetMovable(movable);
    frame:SetClampedToScreen(true);

    dragger:HookScript("OnDragStart", function()
        if (frame:IsMovable()) then
            local x, y = frame:GetCenter();
            frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y);
            frame:StartMoving();
        end
    end);

    dragger:HookScript("OnDragStop", function()
        if (frame:IsMovable()) then
            frame:StopMovingOrSizing();
        end
    end);
end

function Private:SetFullWidth(frame, rightPadding)
    rightPadding = rightPadding or 0;

    if (not frame:GetParent()) then
        tk.hooksecurefunc(frame, "SetParent", function()
            frame:GetParent():HookScript("OnSizeChanged", function(_, width)
                frame:SetWidth(width - rightPadding);
            end);

            frame:SetWidth(frame:GetParent():GetWidth() - rightPadding);
        end);

    else
        frame:GetParent():HookScript("OnSizeChanged", function(_, width)
            frame:SetWidth(width - rightPadding);
        end);

        frame:SetWidth(frame:GetParent():GetWidth() - rightPadding);
    end
end

---------------------------
-- Reskinning
---------------------------
do
    Private.LayerTypes = {};
    Private.LayerTypes.BACKGROUND = 2;
    Private.LayerTypes.BORDER = 4;
    Private.LayerTypes.ARTWORK = 8;
    Private.LayerTypes.OVERLAY = 16;
    Private.LayerTypes.HIGHLIGHT = 32;
    Private.LayerTypes.CREATE_BACKGROUND = 64;

    function Private:HideLayers(frame, value)
        local layerTypes = {};

        -- Empty Table:
        for key, _ in pairs(self.LayerTypes) do
            tbl[key] = nil;
        end

        if (bit.band(value, self.LayerTypes.BACKGROUND) ~= 0) then
            table.insert(layerTypes, "BACKGROUND");
        end

        if (bit.band(value, self.LayerTypes.BORDER) ~= 0) then
            table.insert(layerTypes, "BORDER");
        end

        if (bit.band(value, self.LayerTypes.ARTWORK) ~= 0) then
            table.insert(layerTypes, "ARTWORK");
        end

        if (bit.band(value, self.LayerTypes.OVERLAY) ~= 0) then
            table.insert(layerTypes, "OVERLAY");
        end

        if (bit.band(value, self.LayerTypes.HIGHLIGHT) ~= 0) then
            table.insert(layerTypes, "HIGHLIGHT");
        end

        Private:HideTextures(frame, layerTypes);
    end

    function Private:HideTextures(frame, layers)
        for layer = 1, (#layers) do

            for regionIndex = 1, frame:GetNumRegions() do                
                local region = tk.select(regionIndex, frame:GetRegions());

                if (not region) then 
                    return; 
                end

                if (region:GetObjectType() == "Texture" and region:GetDrawLayer() == layers[layer]) then
                    region:Hide();
                    region:SetTexture("");
                    region.Show = self.DUMMY_FUNC;
                    region.SetTexture = self.DUMMY_FUNC;
                end

            end
        end
    end
end