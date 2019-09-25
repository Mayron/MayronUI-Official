-- luacheck: ignore self 143 631
local Lib = _G.LibStub:GetLibrary("LibMayronObjects"); ---@type LibMayronObjects
local Collections = Lib:CreatePackage("Collections", "Framework.System");

---@class LinkedList : Object
local LinkedList = Collections:CreateClass("LinkedList");

local Node = {};
local LinkedListData = {};

function LinkedList:__Construct(data, ...)
    for _, value in Lib:IterateArgs(...) do
        self:AddToBack(value);
    end

    LinkedListData[tostring(self)] = data;
end

function LinkedList:__Destruct()
    self:Clear();
end

---@return string @A string containing the items of the LinkedList.
function LinkedList:ToString()
    local name = tostring(self):gsub("table", "LinkedList");
    local str = " [";

    for id, value in self:Iterate() do
        str = str..tostring(value);

        if (id < self:GetSize()) then
            str = str..", ";
        end
    end

    return name..str.."]";
end

---A helper function to print the LinkedList (which shows all items in the LinkedList).
function LinkedList:Print()
    local str = self:ToString();
    print(str);
end

---Removes all items in the LinkedList.
function LinkedList:Clear()
    while (self:RemoveFront()) do end
end

---@return number @The total number of items contained inside the LinkedList.
function LinkedList:GetSize(data)
    return data.size;
end

---@return boolean @If true, the LinkedList contains no items.
function LinkedList:IsEmpty(data)
    return data.front == nil;
end

---Add a value to the back of the LinkedList.
---@param value any @The value to be added.
function LinkedList:AddToBack(data, value)
    local node = Node:new(self, value);

    if (not data.front) then
        data.front = node;
        data.back = node;
    else
        data.back.next = node;
        node.prev = data.back;
        data.back = node;
    end

    data.size = (data.size or 0) + 1;
end

---Add a value to the front of the LinkedList.
---@param value any @The value to be added.
function LinkedList:AddToFront(data, value)
    local node = Node:new(self, value);

    if (not data.front) then
        data.front = node;
        data.back = node;
    else
        node.next = data.front;
        data.front.prev = node;
        data.front = node;
    end

    data.size = (data.size or 0) + 1;
end

---Removes the value found at the front of the LinkedList
---@return boolean @Whether a value was found and then removed (will be false if LinkedList is empty).
function LinkedList:RemoveFront(data)
    if (not data.front) then return false; end
    data.front:Destroy();

    return true;
end

---Removes the value found at the back of the LinkedList
---@return boolean @Whether a value was found and then removed (will be false if LinkedList is empty).
function LinkedList:RemoveBack(data)
    if (not data.back) then return false; end
    data.back:Destroy();

    return true;
end

---Iterates through the LinkedList comparing all items with the supplied value and removes the first item found that matches the value.
---@return boolean @Whether a matching value was found and then removed (will be false if the LinkedList contains no matching value).
function LinkedList:Remove(data, value)
    local node = data.front;

    repeat
        if (value == node.value) then
            node:Destroy();
            return true;
        end
        node = node.next
    until (not node);

    return false;
end

---@return any @The first value at the front of the LinkedList.
function LinkedList:GetFront(data, node)
    if (node) then
        return data.front;
    else
        return data.front.value;
    end
end

---@return any @The first value at the back of the LinkedList.
function LinkedList:GetBack(data, node)
    if (node) then
        return data.back;
    else
        return data.back.value;
    end
end

---Removes the value found at the front of the LinkedList and also returns the removed value.
---@return any @The first value at the back of the LinkedList.
function LinkedList:PopFront()
    local value = self:GetFront();
    self:RemoveFront();

    return value;
end

---Removes the value found at the back of the LinkedList and also returns the removed value.
---@return any @The last value at the back of the LinkedList.
function LinkedList:PopBack()
    local value = self:GetBack();
    self:RemoveBack();

    return value;
end

---Returns all values in the LinkedList.
---@param n number @(optional) The maximum number of items to unpack from the front of the LinkedList.
function LinkedList:Unpack(_, n)
    n = n or 1;
    local values = Lib:PopTable();

    for id, value in self:Iterate() do
        if (n <= id) then
            _G.table.insert(values, value);
        end
    end

    return Lib:UnpackTable(values);
end

---Iterate through the values in the LinkedList.
---@param backwards boolean @(optional) If true, values are iterated from the back of the LinkedList to the front.
function LinkedList:Iterate(data, backwards)
    local node, id, step;

    if (backwards) then
        node = data.back;
        id = self:GetSize() + 1; step = -1;
    else
        node = data.front;
        id = 0; step = 1;
    end

    return function()
        if (node) then
            local value = node.value;
            id = id + step;

            if (backwards) then
                node = node.prev;
            else
                node = node.next;
            end

            return id, value;
        end
    end
end

---------------------------------------
-- Node (Not using Object Framework)
---------------------------------------
function Node:Destroy()
    local next = self.next;
    local prev = self.prev;

    if (next) then
        next.prev = prev;
    else
        self.linkedListData.back = prev;
    end

    if (prev) then
        prev.next = next;
    else
        self.linkedListData.front = next;
    end

    self.linkedListData.size = (self.linkedListData.size or 0) - 1;
    Lib:PushTable(self);
end

do
    local mt = { __index = Node };

    function Node:new(linkedList, value)
        local node = Lib:PopTable();
        node.value = value;
        node.linkedListData = LinkedListData[tostring(linkedList)];

        return setmetatable(node, mt);
    end
end

function Node:GetObjectType()
    return "Node";
end

function Node:Next()
    return self.next;
end

function Node:Previous()
    return self.previous;
end