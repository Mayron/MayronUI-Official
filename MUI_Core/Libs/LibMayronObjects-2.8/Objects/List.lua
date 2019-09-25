-- luacheck: ignore self 143 631
local Lib = _G.LibStub:GetLibrary("LibMayronObjects"); ---@type LibMayronObjects
local Collections = Lib:Import("Framework.System.Collections");
local List = Collections:CreateClass("List");

function List:__Construct(data, ...)
    data.values = Lib:PopTable();
    self:AddAll(...);
end

function List:Add(data, value, index)
    if (index) then
        table.insert(data.values, index, value);
    else
        table.insert(data.values, value);
    end
end

function List:Remove(data, index)
    table.remove(data.values, index);
end

function List:RemoveByValue(data, value, allValues)
    local index = 1;
    local value2 = data.values[index];

    while (value2) do
        if (value2 == value) then
            self:Remove(index);

            if (not allValues) then
                break;
            end
        else
            index = index + 1;
        end

        value2 = data.values[index];
    end
end

function List:ForEach(data, func)
    for index, value in ipairs(data.values) do
        func(index, value);
    end
end

function List:Filter(data, predicate)
    local index = 1;
    local value = data.values[index];

    while (value) do
        if (predicate(index, value)) then
            self:Remove(index);
        else
            index = index + 1;
        end

        value = data.values[index];
    end
end

function List:Select(data, predicate)
    local selected = {};

    for index, value in ipairs(data.values) do
        if (predicate(index, value)) then
            selected[#selected] = value;
        end
    end

    return selected;
end

do
    local function iter(values, index)
        index = index + 1;
        if (values[index]) then
            return index, values[index];
        end
    end

    function List:Iterate(data)
        return iter, data.values, 0;
    end
end

function List:Get(data, index)
    return data.values[index];
end

function List:Contains(data, value)
    for _, value2 in ipairs(data.values) do
        if (value2 == value) then
            return true;
        end
    end
    return false;
end

function List:Empty(data)
    for index, _ in ipairs(data.values) do
        data.values[index] = nil;
    end
end

function List:IsEmpty(data)
    return #data.values == 0;
end

function List:Size(data)
    return #data.values;
end

do
    local function AddTable(fromTable, toTable)
        for index, value in ipairs(fromTable) do
            if (type(value) == "table") then
                toTable[index] = Lib:PopTable();
                AddTable(value, toTable[index]);
            else
                toTable[index] = value;
            end
        end
    end

    function List:ToTable(data)
        local copy = Lib:PopTable();
        AddTable(data.values, copy);
        return copy;
    end
end

function List:AddAll(data, ...)
    for _, value in Lib:IterateArgs(...) do
        table.insert(data.values, value);
    end
end

function List:RemoveAll(_, ...)
    for _, value in Lib:IterateArgs(...) do
        self:RemoveByValue(value);
    end
end

function List:RetainAll(_, ...)
    for _, value in Lib:IterateArgs(...) do
        if (not self:Contains(value)) then
            self:RemoveByValue(value);
        end
    end
end