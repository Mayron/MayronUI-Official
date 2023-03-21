-- luacheck: ignore self 143 631
local obj = _G.MayronObjects:GetFramework(); ---@type MayronObjects

if (obj:Import("Pkg-Collections.Stack<T>", true)) then return end

---@class Pkg-Collections.Stack : MayronObjects.Class
local C_Stack = obj:CreateClass("Stack<T>");

obj:Export(C_Stack, "Pkg-Collections");

local unpack, ipairs = _G.unpack, _G.ipairs;

function C_Stack:__Construct(data, ...)
  data.tbl = obj:PopTable();

  for _, item in obj:IterateArgs(...) do
    data.tbl[#data.tbl + 1] = item;
  end
end

function C_Stack:Unpack(data)
  return unpack(data.tbl);
end

obj:DefineParams("?function");
---@param generator function @A function to handle the generation of new items when popping from an empty C_Stack (set to nil to remove generator).
function C_Stack:OnNewItem(data, generator)
  data.onNewItem = generator;
end

obj:DefineParams("?function");
---@param callback function @A function to call after popping an item from the C_Stack (set to nil to remove callback).
function C_Stack:OnPopItem(data, callback)
  data.onPopItem = callback;
end

obj:DefineParams("?function");
---@param callback function @A function to call after pushing an item onto the C_Stack (set to nil to remove callback).
function C_Stack:OnPushItem(data, callback)
  data.onPushItem = callback;
end

obj:DefineParams("T");
---Additional args can be passed as a vararg after the first argument to go to the onPushItem callback function (if available).
---@param item any @The item to push onto the C_Stack.
function C_Stack:Push(data, item, ...)
  data.tbl[#data.tbl + 1] = item;

  if (data.onPushItem) then
    data.onPushItem(item, ...);
  end
end

obj:DefineReturns("?T");
---If additional args are passed to this function (as part of a vararg) then these will be passed to to the onNewItem and onPopItem callback functions (if available).
---@return any @Returns the results of popping an item from the C_Stack (or creating an item if using onNewItem).
function C_Stack:Pop(data, ...)
  local item;

  if (self:IsEmpty()) then
    if (data.onNewItem) then
      item = data.onNewItem(...);
    end
  else
    item = data.tbl[#data.tbl];
    data.tbl[#data.tbl] = nil;
  end

  if (data.onPopItem) then
    data.onPopItem(item, ...);
  end

  return item;
end

obj:DefineReturns("boolean");
---@return boolean @Returns true if there are no items on the C_Stack.
function C_Stack:IsEmpty(data)
  return (#data.tbl == 0);
end

obj:DefineParams("function");
---If additional args are passed to this function (as part of a vararg) then these will be passed to the function (after the item).
---@param func function @A function to be called for each item in the C_Stack (item is passed to func as the field argument).
function C_Stack:ForEach(data, func, ...)
  for _, item in ipairs(data.tbl) do
    func(item, ...);
  end
end