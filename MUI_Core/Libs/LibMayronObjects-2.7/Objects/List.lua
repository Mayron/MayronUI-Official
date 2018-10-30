local Lib = LibStub:GetLibrary("LibMayronObjects");
local Collections = Lib:Import("Framework.System.Collections");
local List = Collections:CreateClass("List");
---------------------------------------

function List:__Construct(data, ...)
    data.values = {};
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
    for index, value2 in ipairs(data.values) do
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

function List:ToTable(data)
    local copy = {};

    for index, value in ipairs(data.values) do
        copy[index] = value;
    end

    return copy;
end

function List:AddAll(data, ...)
    for _, value in pairs({...}) do
        table.insert(data.values, value);
    end    
end

function List:RemoveAll(data, ...)
    for _, value in pairs({...}) do
        self:RemoveByValue(value);
    end
end

function List:RetainAll(data, ...)
    for _, value in pairs({...}) do
        if (not self:Contains(value)) then
            self:RemoveByValue(value);
        end
    end
end