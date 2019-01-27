-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;

local obj = namespace.components.Objects;
local tk = namespace.components.Toolkit;

tk.Tables = {};

local LinkedList = obj:Import("Framework.System.Collections.LinkedList");
-----------------------------

function tk.Tables:GetKeys(tbl, keys)
    keys = keys or {};

    for key, _ in tk.pairs(tbl) do
        tk.table.insert(keys, key);
    end

    return keys;
end

-- gets or creates a table:
-- example:
-- tbl = tbl or {};
-- tbl[key] = tbl[key] or {};
-- tbl[key][anotherKey] = tbl[key][anotherKey] or {};
-- local value = tbl[key][anotherKey];

-- can be replaced with: local value = tk.Tables:GetTable(tbl, key, anotherKey);
function tk.Tables:GetTable(rootTable, ...)
    tk:Assert(type(rootTable) == "table",
        "tk.Tables.GetTable - invalid rootTable arg (table expected, got %s)", type(rootTable));

    local currentTable = rootTable;

    for _, key in obj:IterateArgs(...) do
        if (type(currentTable[key]) ~= "table") then
            currentTable[key] = obj:PopTable();
        end

        currentTable = currentTable[key];
    end

    return currentTable;
end

function tk.Tables:Print(tbl, depth, n)
    obj:PrintTable(tbl, depth, n);
end

function tk.Tables:Contains(tbl, value)
    for _, tblValue in pairs(tbl) do
        if (tk:Equals(value, tblValue)) then
            return true;
        end
    end

    return false;
end

function tk.Tables:GetIndex(tbl, value)
    for id, tblValue in pairs(tbl) do
        if (tk:Equals(tblValue, value)) then
            return id;
        end
    end

    return nil;
end

-- includes both the index length and the hash table length
function tk.Tables:GetFullSize(tbl)
    local size = 0;

    for _, _ in tk.pairs(tbl) do
        size = size + 1;
    end

    return size;
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
    local size = self:GetFullSize(tbl);
    return size == 0;
end

-- remove all nil values from index portion of table
function tk.Tables:CleanIndexes(tbl)
    local tempIndexTable;

    for index = 1, #tbl do
        local value = tbl[index];

        if (value ~= nil) then
            tempIndexTable = tempIndexTable or obj:PopTable();
            tk.table.insert(tempIndexTable, value);

            tbl[index] = nil;
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

    for _, subValue in tk.pairs(subTable) do
        for key, mainValue in tk.pairs(mainTable) do
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
            tbl[key] = value;
        end
    end
end

do
    local argsList;

    -- breaks apart a database path address (i.e. "db.profiles['value'][1]")
    -- to a LinkedList containing all sections
    function tk.Tables:ConvertPathToKeys(path)
        argsList = argsList or LinkedList();
        argsList:Clear();

        for _, key in obj:IterateArgs(tk.strsplit(".", path)) do
            local firstKey = tk.strsplit("[", key);

            argsList:AddToBack(tk.tonumber(firstKey) or firstKey);

            if (key:find("%b[]")) then
                for index in key:gmatch("(%b[])") do
                    local nextKey = index:match("%[(.+)%]");
                    argsList:AddToBack(tk.tonumber(nextKey) or nextKey);
                end
            end
        end

        return argsList;
    end
end

-- gets the DB associated with the AddOn based on convention
function tk.Tables:GetDBObject(addOnName)
    local addon, okay;

    if (_G[addOnName]) then
        addon = tk._G[addOnName];
        okay = true;
    else
        okay, addon = tk.pcall(function()
            _G.LibStub("AceAddon-3.0"):GetAddon(addOnName)
        end);
    end

    if (not okay) then
        return
    end

    if (addon and not addon.db) then
        for dbname, _ in tk.pairs(addon) do

            if (tk.string.find(dbname, "db")) then
                if (tk.type(addon[dbname]) == "table") then

                    if (addon[dbname].profile) then
                        return addon[dbname];
                    end
                end
            end
        end

        return nil;
    elseif (addon and addon.db) then
        return addon.db;
    end
end

function tk.Tables:GetLastPathKey(path)
    local list = LinkedList(tk.strsplit(".", path));
    local key = list:GetBack();

    if (key:find("%b[]")) then
        key = key:match(".+(%b[])");
        key = key:match("[(%d+)]");
        key = tk.tonumber(key) or key; -- tonumber returns 0 if not convertible
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