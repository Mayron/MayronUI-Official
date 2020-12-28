-- luacheck: ignore self 143 631
local obj = _G.MayronObjects:GetFramework(); ---@type MayronObjects

if (obj:Import("Pkg-Collections.List<T>", true)) then return end

---@class List
local C_List = obj:CreateClass("List<T>");
obj:Export(C_List, "Pkg-Collections");

local table, ipairs = _G.table, _G.ipairs;

function C_List:__Construct(data, ...)
  data.values = obj:PopTable();
  self:AddAll(...);
end

obj:DefineParams("T", "?number");
function C_List:Add(data, value, index)
  if (index) then
    table.insert(data.values, index, value);
  else
    table.insert(data.values, value);
  end
end

obj:DefineParams("number");
function C_List:Remove(data, index)
  table.remove(data.values, index);
end

obj:DefineParams("T", "?boolean");
function C_List:RemoveByValue(data, value, allValues)
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

obj:DefineParams("function");
function C_List:ForEach(data, func)
  for index, value in ipairs(data.values) do
    func(index, value);
  end
end

obj:DefineParams("function");
function C_List:Filter(data, predicate)
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

obj:DefineParams("function");
obj:DefineReturns("boolean");
function C_List:Select(data, predicate)
  local selected = obj:PopTable();

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

  function C_List:Iterate(data)
    return iter, data.values, 0;
  end
end

obj:DefineParams("number");
obj:DefineReturns("?T");
function C_List:Get(data, index)
  return data.values[index];
end

obj:DefineParams("T");
obj:DefineReturns("boolean");
function C_List:Contains(data, value)
  for _, value2 in ipairs(data.values) do
    if (value2 == value) then
      return true;
    end
  end
  return false;
end

function C_List:Empty(data)
  for index, _ in ipairs(data.values) do
    data.values[index] = nil;
  end
end

obj:DefineReturns("boolean");
function C_List:IsEmpty(data)
  return #data.values == 0;
end

obj:DefineReturns("number");
function C_List:Size(data)
  return #data.values;
end

do
  local function AddTable(fromTable, toTable)
    for index, value in ipairs(fromTable) do
      if (obj:IsTable(value)) then
        toTable[index] = obj:PopTable();
        AddTable(value, toTable[index]);
      else
        toTable[index] = value;
      end
    end
  end

  obj:DefineReturns("table");
  function C_List:ToTable(data)
    local copy = obj:PopTable();
    AddTable(data.values, copy);
    return copy;
  end
end

function C_List:AddAll(data, ...)
  for _, value in obj:IterateArgs(...) do
    table.insert(data.values, value);
  end
end

function C_List:RemoveAll(_, ...)
  for _, value in obj:IterateArgs(...) do
    self:RemoveByValue(value);
  end
end

function C_List:RetainAll(_, ...)
  for _, value in obj:IterateArgs(...) do
    if (not self:Contains(value)) then
      self:RemoveByValue(value);
    end
  end
end