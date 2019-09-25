-- luacheck: ignore self 143 631
local Lib = _G.LibStub:GetLibrary("LibMayronObjects"); ---@type LibMayronObjects
local Collections = Lib:Import("Framework.System.Collections");

---@class Stack : Object
local Stack = Collections:CreateClass("Stack<T>");

function Stack:__Construct(data, ...)
    data.tbl = Lib:PopTable();

    for _, item in Lib:IterateArgs(...) do
        data.tbl[#data.tbl + 1] = item;
    end
end

function Stack:Unpack(data)
    return _G.unpack(data.tbl);
end

Collections:DefineParams("?function");
---@param generator function @A function to handle the generation of new items when popping from an empty stack (set to nil to remove generator).
function Stack:OnNewItem(data, generator)
    data.onNewItem = generator;
end

Collections:DefineParams("?function");
---@param callback function @A function to call after popping an item from the stack (set to nil to remove callback).
function Stack:OnPopItem(data, callback)
    data.onPopItem = callback;
end

Collections:DefineParams("?function");
---@param callback function @A function to call after pushing an item onto the stack (set to nil to remove callback).
function Stack:OnPushItem(data, callback)
    data.onPushItem = callback;
end

Collections:DefineParams("T");
---Additional args can be passed as a vararg after the first argument to go to the onPushItem callback function (if available).
---@param item any @The item to push onto the Stack.
function Stack:Push(data, item, ...)
    data.tbl[#data.tbl + 1] = item;

    if (data.onPushItem) then
        data.onPushItem(item, ...);
    end
end

Collections:DefineReturns("?T");
---If additional args are passed to this function (as part of a vararg) then these will be passed to to the onNewItem and onPopItem callback functions (if available).
---@return any @Returns the results of popping an item from the stack (or creating an item if using onNewItem).
function Stack:Pop(data, ...)
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

Collections:DefineReturns("boolean");
---@return boolean @Returns true if there are no items on the stack.
function Stack:IsEmpty(data)
    return (#data.tbl == 0);
end

Collections:DefineParams("function");
---If additional args are passed to this function (as part of a vararg) then these will be passed to the function (after the item).
---@param func function @A function to be called for each item in the stack (item is passed to func as the field argument).
function Stack:ForEach(data, func, ...)
    for _, item in ipairs(data.tbl) do
        func(item, ...);
    end
end