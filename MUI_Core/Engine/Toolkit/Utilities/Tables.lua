-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;

local obj = namespace.components.Objects; ---@type Objects
local tk = namespace.components.Toolkit; ---@type Toolkit

local pcall, pairs, strsplit, tonumber = _G.pcall, _G.pairs, _G.strsplit, _G.tonumber;
local table = _G.table;

tk.Tables = {};

local LinkedList = obj:Import("Framework.System.Collections.LinkedList"); ---@type LinkedList
-----------------------------

function tk.Tables:GetKeys(tbl, keys)
    keys = keys or {};

    for key, _ in pairs(tbl) do
        table.insert(keys, key);
    end

    return keys;
end

function tk.Tables:GetSize(tbl, includeIndices, includeKeys)
    local size = 0;

    includeIndices = (includeIndices == nil and true) or includeIndices;
    includeKeys = (includeKeys == nil and true) or includeKeys;

    if (includeIndices and includeKeys) then
        for _, _ in pairs(tbl) do
            size = size + 1;
        end

    elseif (includeIndices and not includeKeys) then
        for _, _ in ipairs(tbl) do
            size = size + 1;
        end

    elseif (not includeIndices and includeKeys) then
        for key, _ in pairs(tbl) do
            if (type(key) == "string") then
                size = size + 1;
            end
        end
    end

    return size;
end

-- gets or creates a table:
-- example:
-- tbl = tbl or {};
-- tbl[key] = tbl[key] or {};
-- tbl[key][anotherKey] = tbl[key][anotherKey] or {};
-- local value = tbl[key][anotherKey];

-- can be replaced with: local value = tk.Tables:GetTable(tbl, key, anotherKey);
function tk.Tables:GetTable(rootTable, ...)
    tk:Assert(obj:IsTable(rootTable),
        "tk.Tables.GetTable - invalid rootTable arg (table expected, got %s)", type(rootTable));

    local currentTable = rootTable;

    for _, key in obj:IterateArgs(...) do
        if (not obj:IsTable(currentTable[key])) then
            currentTable[key] = obj:PopTable();
        end

        currentTable = currentTable[key];
    end

    return currentTable;
end

---A helper function to print a table's contents.
---@param tbl table @The table to print.
---@param depth number @The depth of sub-tables to traverse through and print.
function tk.Tables:Print(tbl, depth)
    obj:PrintTable(tbl, depth);
end

function tk.Tables:Contains(tbl, value)
    for _, tblValue in pairs(tbl) do
        if (tk:Equals(value, tblValue)) then
            return true;
        end
    end

    return false;
end

function tk.Tables:GetIndex(tbl, value, position)
    local totalFound = 0;
    position = position or 1;

    for id, tblValue in pairs(tbl) do
        if (tk:Equals(tblValue, value)) then
            totalFound = totalFound + 1;

            if (totalFound == position) then
                return id;
            end
        end
    end

    return nil;
end

function tk.Tables:IndexOf(tbl, value)
    for id, otherValue in ipairs(tbl) do
        if (value == otherValue) then
            return id;
        end
    end
end

function tk.Tables:AddAll(tbl, ...)
    for _, value in obj:IterateArgs(...) do
        table.insert(tbl, value);
    end
end

function tk.Tables:Empty(tbl)
    for key, _ in pairs(tbl) do
        tbl[key] = nil;
    end
end

function tk.Tables:IsEmpty(tbl)
    local size = self:GetSize(tbl);
    return size == 0;
end

function tk.Tables:GetFramePosition(frame, useKeys, override)
    local point, relativeFrame, relativePoint, x, y = frame:GetPoint();

    if (not relativeFrame) then
        relativeFrame = frame:GetParent():GetName();
    else
        relativeFrame = relativeFrame:GetName();
    end

    if (override and (not relativeFrame or (relativeFrame and relativeFrame ~= "UIParent"))) then
        x, y = frame:GetCenter();
        point = "CENTER";
        relativeFrame = "UIParent"; -- Do not want this to be UIParent in some cases
        relativePoint = "BOTTOMLEFT";
    end

    local positions;

    if (useKeys) then
        positions = obj:PopTable();

        positions.point = point;
        positions.relativeFrame = relativeFrame;
        positions.relativePoint = relativePoint;
        positions.x = x;
        positions.y = y;

    else
        positions = obj:PopTable(point, relativeFrame, relativePoint, x, y);
    end

    frame:ClearAllPoints();
    frame:SetPoint(point, relativeFrame, relativePoint, x, y);

    return positions;
end

-- remove all nil values from index portion of table
function tk.Tables:CleanIndexes(tbl)
    local tempIndexTable;

    for index, value in pairs(tbl) do
        if (obj:IsNumber(index)) then
            if (value ~= nil) then
                tempIndexTable = tempIndexTable or obj:PopTable();
                table.insert(tempIndexTable, value);
                tbl[index] = nil;
            end
        end
    end

    if (tempIndexTable) then
        for index = 1, #tempIndexTable do
            tbl[index] = tempIndexTable[index];
        end

        obj:PushTable(tempIndexTable);
    end
end

function tk.Tables:RemoveAll(mainTable, subTable, preserveIndex)
    local totalRemoved = 0;

    for subIndex = 1, #subTable do
        local subValue = subTable[subIndex];

        for mainIndex = 1, #mainTable do
            local mainValue = mainTable[mainIndex];

            if (tk:Equals(mainValue, subValue, true)) then
                -- remove it!
                mainTable[mainIndex] = nil;
                totalRemoved = totalRemoved + 1;
                break;
            end
        end
    end

    if (not preserveIndex) then
        self:CleanIndexes(mainTable);
    end

    for _, subValue in pairs(subTable) do
        for key, mainValue in pairs(mainTable) do
            if (tk:Equals(mainValue, subValue)) then
                -- remove it!
                mainTable[key] = nil;
                totalRemoved = totalRemoved + 1;
                break;
            end
        end
    end

    return totalRemoved;
end

-- copy all values from multiple tables into a new table
function tk.Tables:Merge(...)
    local merged = obj:PopTable();

    for _, tbl in obj:IterateArgs(...) do
        for key, value in pairs(tbl) do
            if (obj:IsTable(merged[key]) and obj:IsTable(value)) then
                merged[key] = self:Merge(merged[key], value);
            else
                merged[key] = value;
            end
        end
    end

    return merged;
end

-- move values from one table to another table
function tk.Tables:Fill(tbl, otherTbl, preserveOldValue)
    for key, value in pairs(otherTbl) do

        if (obj:IsTable(tbl[key]) and obj:IsTable(value)) then
            self:Fill(tbl[key], value);

        elseif (not preserveOldValue or obj:IsNil(tbl[key])) then
            if (obj:IsTable(value)) then
                tbl[key] = obj:PopTable();
                self:Fill(tbl[key], value);
            else
                tbl[key] = value;
            end
        end
    end
end

do
    local argsList;

    ---Breaks apart a table path string to a LinkedList containing all keys.
    ---@param path string @A table path such as "db.profiles['value'][1]".
    ---@return LinkedList @A LinkedList of keys.
    function tk.Tables:ConvertPathToKeysList(path)
        argsList = argsList or LinkedList();
        argsList:Clear();

        for _, key in obj:IterateArgs(strsplit(".", path)) do
            local firstKey = strsplit("[", key);

            argsList:AddToBack(tonumber(firstKey) or firstKey);

            if (key:find("%b[]")) then
                for index in key:gmatch("(%b[])") do
                    local nextKey = index:match("%[(.+)%]");
                    argsList:AddToBack(tonumber(nextKey) or nextKey);
                end
            end
        end

        return argsList;
    end
end

-- gets the DB associated with the AddOn based on convention
function tk.Tables:GetDBObject(addOnName)
    local addon, okay, dbObject;

    dbObject = _G.LibStub:GetLibrary("LibMayronDB"):GetDatabase(addOnName);

    if (dbObject) then
        return dbObject;
    end

    if (_G[addOnName]) then
        addon = _G[addOnName];
        okay = true;
    else
        if (not dbObject) then
            okay, addon = pcall(function()
                _G.LibStub("AceAddon-3.0"):GetAddon(addOnName);
            end);
        end
    end

    if (not (addon and okay)) then
        return nil;
    end

    dbObject = addon.db;

    if (not dbObject) then
        for dbName, dbTable in pairs(addon) do
            if (obj:IsTable(dbTable) and dbTable.profile and obj:IsString(dbName) and dbName:lower():find("db")) then
                dbObject = dbTable;
                break;
            end
        end
    end

    if (dbObject and dbObject.profile and dbObject.SetProfile and dbObject.GetProfiles and dbObject.GetCurrentProfile) then
        return dbObject;
    end
end

function tk.Tables:GetLastPathKey(path)
    local list = LinkedList(strsplit(".", path));
    local key = list:GetBack();

    if (key:find("%b[]")) then
        key = key:match(".+(%b[])");
        key = key:match("[(%d+)]");
        key = tonumber(key) or key; -- tonumber returns 0 if not convertible
    end

    list:Destroy();

    return key;
end

do
    local orderByKeys;

    local function compare(previous, current)

        for _, key in ipairs(orderByKeys) do

            if (current[key]) then

                if (previous[key]) then
                    return previous[key] < current[key];
                else
                    return false;
                end

            elseif (previous[key]) then
                return true;
            end
        end

        return false;
    end

    function tk.Tables:OrderBy(tbl, ...)
        orderByKeys = obj:PopTable(...);
        table.sort(tbl, compare);
        obj:PushTable(orderByKeys);
    end
end