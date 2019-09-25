-- luacheck: ignore self 143 631
local Lib = _G.LibStub:GetLibrary("LibMayronObjects"); ---@type LibMayronObjects
local Collections = Lib:Import("Framework.System.Collections");
local Map = Collections:CreateClass("Map");
local List = Collections:Get("List");

Collections:DefineParams("?table");
function Map:__Construct(data, tbl)
    data.values = {};

    if (tbl) then
        for key, value in pairs(tbl) do
            self:Add(key, value);
        end
    end
end

function Map:Add(data, key, value)
    Lib:Assert(not data.values[key], "Map.Add - key '%s' already exists.", key);
    data.values[key] = value;
end

function Map:AddAll(_, keyValues)
    for key, value in pairs(keyValues) do
        self:Add(key, value);
    end
end

function Map:Remove(data, key)
    Lib:Assert(data.values[key], "Map.Add: key '%s' not found.", key);
    data.values[key] = nil;
end

function Map:RemoveAll(_, keys)
    for _, key in ipairs(keys) do
        self:Remove(key);
    end
end

function Map:RetainAll(data, keys)
    for key, _ in pairs(data.values) do
        local keyExists = false;

        for _, retainKey in ipairs(keys) do
            if (key == retainKey) then
                keyExists = true;
                break;
            end
        end

        if (not keyExists) then
            self:Remove(key);
        end
    end
end

function Map:RemoveByValue(data, value)
    for key, value2 in pairs(data.values) do
        if (value2 == value) then
            data.values[key] = nil;
        end
    end
end

function Map:Get(data, key)
    return data.values[key];
end

function Map:Contains(data, value)
    for key, _ in pairs(data.values) do
        if (data.values[key] == value) then
            return true;
        end
    end

    return false;
end

function Map:ForEach(data, func)
    for key, value in pairs(data.values) do
        func(key, value);
    end
end

function Map:Filter(data, predicate)
    for key, value in pairs(data.values) do
        if (predicate(key, value)) then
            self:Remove(key);
        end
    end
end

function Map:Select(data, predicate)
    local selected = Lib:PopTable();

    for key, value in pairs(data.values) do
        if (predicate(key, value)) then
            selected[key] = value;
        end
    end

    return selected;
end

function Map:Empty(data)
    for key, _ in pairs(data.values) do
        data.values[key] = nil;
    end
end

function Map:IsEmpty(_)
    return self:Size() == 0;
end

function Map:Size(data)
    local size = 0;
    for _, _ in pairs(data.values) do
        size = size + 1;
    end
    return size;
end

function Map:ToTable(data)
    local copy = {};

    for key, value in pairs(data.values) do
        copy[key] = value;
    end

    return copy;
end

function Map:GetValueList(data)
    local list = List();
    for _, value in pairs(data.values) do
        list:Add(value);
    end
    return list;
end

function Map:GetKeyList(data)
    local list = List();
    for key, _ in pairs(data.values) do
        list:Add(key);
    end
    return list;
end