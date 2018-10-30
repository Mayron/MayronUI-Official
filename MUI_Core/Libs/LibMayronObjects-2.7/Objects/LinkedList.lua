local Lib = LibStub:GetLibrary("LibMayronObjects");
local Collections = Lib:CreatePackage("Collections", "Framework.System");
local LinkedList = Collections:CreateClass("LinkedList");

local Node = {};
local LinkedListData = {};
---------------------------------------

function LinkedList:__Construct(data, ...)  
    for _, value in pairs({...}) do
        self:AddToBack(value);
    end

    LinkedListData[tostring(self)] = data;
end

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

function LinkedList:Clear()
    while (self:RemoveFront()) do end
end

function LinkedList:GetSize(data)
    return data.size;
end

function LinkedList:IsEmpty(data)
    return data.front == nil;
end

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

function LinkedList:RemoveFront(data)
    if (not data.front) then return false; end
    data.front:Destroy();

    return true;
end

function LinkedList:RemoveBack(data)
    if (not data.back) then return false; end
    data.back:Destroy();

    return true;
end

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

function LinkedList:GetFront(data, node)
    if (node) then
        return data.front;
    else
        return data.front.value;
    end
end

function LinkedList:GetBack(data, node)
    if (node) then
        return data.back;
    else
        return data.back.value;
    end
end

function LinkedList:PopFront()
    local value = self:GetFront();
    self:RemoveFront();

    return value;
end

function LinkedList:PopBack()
    local value = self:GetBack();
    self:RemoveBack();

    return value;
end

function LinkedList:Unpack(_, n)
    n = n or 1;
    local values = {};

    for id, value in self:Iterate() do
        if (n <= id) then
            table.insert(values, value);
        end
    end

    return unpack(values);
end

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

    self.linkedListData.size = (self.list.size or 0) - 1;
end

function Node:new(linkedList, value)    
    local node = {};
    node.value = value;
    node.linkedListData = LinkedListData[tostring(linkedList)];

    return setmetatable(node, {__index = Node});
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