local _, core = ...;
core.Toolkit = core.Toolkit or {};

local tk = core.Toolkit;
tk.Tables = {};
-----------------------------

function tk.Tables:GetKeys(tbl, keys)
    keys = keys or {};
    for key, _ in tk.pairs(tbl) do
        tk.table.insert(keys, key);
    end
    return keys;
end

function tk.Tables:Print(tbl, depth, n)
    if (tk.type(tbl) ~= "table") then 
        return; 
    end

    n = n or 0;
    depth = depth or 4;

    if (depth == 0) then 
        return; 
    end

    if (n == 0) then
        tk.print(" ");
    end

    for key, value in tk.pairs(tbl) do
        if (key and tk.type(key) == "number" or tk.type(key) == "string") then
            key = "[\""..key.."\"]";

            if (tk.type(value) == "table") then
                tk.print(tk.string.rep(' ', n)..key.." = {");
                self:PrintTable(value, depth - 1, n + 4);
                tk.print(tk.string.rep(' ', n).."}");

            else
                tk.print(tk.string.rep(' ', n)..key.." = "..tk.tostring(value));
            end
        end
    end

    if (n == 0) then
        tk.print(" ");
    end
end

function tk.Tables:GetIndex(tbl, value)
    for id, v in tk.pairs(tbl) do
        if (value == v) then 
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

function tk.Tables:Empty(tbl)
    for key, _ in tk.pairs(tbl) do
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
            tempIndexTable = tempIndexTable or {};
            tk.table.insert(tempIndexTable, value);  

            tbl[index] = nil;
        end
    end

    if (tempIndexTable) then
        for index = 1, #tempIndexTable do
            tbl[index] = tempIndexTable[index];
        end
    end
end

function tk.Tables:RemoveAll(mainTable, subTable, preserveIndex)
    local totalRemoved = 0;
    
    for subIndex = 1, #subTable do
        local subValue = subTable[subIndex];

        for mainIndex = 1, #mainTable do
            local mainValue = mainTable[mainIndex];

            if (self:Equals(mainValue, subValue, true)) then
                -- remove it!
                tk:Print("remove:", subValue);
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
            if (self:Equals(mainValue, subValue)) then
                -- remove it!
                mainTable[key] = nil;
                totalRemoved = totalRemoved + 1;
                break;
            end
        end
    end

    return totalRemoved;
end

function tk.Tables:Fill(tbl, ...)
    for key, value in pairs({...}) do
        -- also includes indexes, so key could be a number
        tbl[key] = value;
    end
end

function tk.Tables:Merge(...)
    local merged = {};

    for _, tbl in ipairs({...}) do
        for key, value in tk.pairs(tbl) do
            if (merged[key] and (tk.type(merged[key]) == "table") and (tk.type(value) == "table")) then
                merged[key] = self:Merge(merged[key], value);
            else
                merged[key] = value;
            end
        end
    end

    return merged;
end

do
    local args;

    -- breaks apart a database path address (i.e. "db.profiles['value'][1]") 
    -- to a LinkedList containing all sections
    function tk.Tables:ConvertPathToKeys(path)
        args = args or tk:CreateLinkedList();
        args:Clear();

        for _, key in ipairs({tk.strsplit(".", path)}) do
            local firstKey = tk.strsplit("[", key);

            args:AddToBack(tk.tonumber(firstKey) or firstKey);

            if (key:find("%b[]")) then
                for index in key:gmatch("(%b[])") do
                    local nextKey = index:match("%[(.+)%]");
                    args:AddToBack(tk.tonumber(nextKey) or nextKey);
                end
            end
        end

        return args;
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
            LibStub("AceAddon-3.0"):GetAddon(addOnName) 
        end);
    end

    if (not okay) then 
        return; 
    end

    if (addon and not addon.db) then
        for dbname, tbl in tk.pairs(addon) do

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
    local list = tk:CreateLinkedList(tk.strsplit(".", path));
    local key = list:GetBack();

    if (key:find("%b[]")) then
        key = key:match(".+(%b[])");
        key = key:match("[(%d+)]");
        key = tk.tonumber(key) or key; -- tonumber returns 0 if not convertible
    end

    list:Destroy();

    return key;
end