-- luacheck: ignore self 143 631
local obj = _G.MayronObjects:GetFramework(); ---@type MayronObjects

if (obj:Import("Pkg-Collections.Map", true)) then return end

---@class Map
local C_Map = obj:CreateClass("Map");
obj:Export(C_Map, "Pkg-Collections");

local C_List = obj:Import("Pkg-Collections.List<T>");
local pairs, ipairs = _G.pairs, _G.ipairs;

obj:DefineParams("?table");
function C_Map:__Construct(data, tbl)
  data.values = obj:PopTable();

  if (tbl) then
    for key, value in pairs(tbl) do
      self:Add(key, value);
    end
  end
end

function C_Map:Add(data, key, value)
  obj:Assert(not data.values[key], "C_Map.Add - key '%s' already exists.", key);
  data.values[key] = value;
end

function C_Map:AddAll(_, keyValues)
  for key, value in pairs(keyValues) do
    self:Add(key, value);
  end
end

function C_Map:Remove(data, key)
  obj:Assert(data.values[key], "C_Map.Add: key '%s' not found.", key);
  data.values[key] = nil;
end

function C_Map:RemoveAll(_, keys)
  for _, key in ipairs(keys) do
    self:Remove(key);
  end
end

function C_Map:RetainAll(data, keys)
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

function C_Map:RemoveByValue(data, value)
  for key, value2 in pairs(data.values) do
    if (value2 == value) then
      data.values[key] = nil;
    end
  end
end

function C_Map:Get(data, key)
  return data.values[key];
end

function C_Map:Contains(data, value)
  for key, _ in pairs(data.values) do
    if (data.values[key] == value) then
      return true;
    end
  end

  return false;
end

function C_Map:ForEach(data, func)
  for key, value in pairs(data.values) do
    func(key, value);
  end
end

function C_Map:Filter(data, predicate)
  for key, value in pairs(data.values) do
    if (predicate(key, value)) then
      self:Remove(key);
    end
  end
end

function C_Map:Select(data, predicate)
  local selected = obj:PopTable();

  for key, value in pairs(data.values) do
    if (predicate(key, value)) then
      selected[key] = value;
    end
  end

  return selected;
end

function C_Map:Empty(data)
  for key, _ in pairs(data.values) do
    data.values[key] = nil;
  end
end

function C_Map:IsEmpty(_)
    return self:Size() == 0;
end

function C_Map:Size(data)
  local size = 0;
  for _, _ in pairs(data.values) do
    size = size + 1;
  end
  return size;
end

function C_Map:ToTable(data)
  local copy = obj:PopTable();

  for key, value in pairs(data.values) do
    copy[key] = value;
  end

  return copy;
end

function C_Map:GetValueList(data)
  local list = C_List:UsingTypes("any")();

  for _, value in pairs(data.values) do
    list:Add(value);
  end

  return list;
end

function C_Map:GetKeyList(data)
  local list = C_List:UsingTypes("any")();

  for key, _ in pairs(data.values) do
    list:Add(key);
  end

  return list;
end