local Lib = LibStub:GetLibrary("LibMayronObjects");
local Collections = Lib:Import("Framework.System.Collections");
local Stack = Collections:CreateClass("Stack");
 ---------------------------------------

function Stack:__Construct(data, OnNew, OnPush, OnPop)
    data.tbl = {};
    data.OnNew = OnNew;
    data.OnPush = OnPush;
    data.OnPop = OnPop;
end

function Stack:Push(data, item, ...)
    data.tbl[#data.tbl + 1] = item;
    if (data.OnPush) then
        data.OnPush(item, ...);
    end
end

function Stack:Pop(data, ...)
    local item;

    if (self:IsEmpty()) then
        if (data.OnNew) then
            item = data.OnNew(...);
        end

    else
        item = data.tbl[#data.tbl];
        data.tbl[#data.tbl] = nil;

    end

    if (data.OnPop) then
        data.OnPop(item, ...);
    end

    return item;
end

function Stack:IsEmpty(data)
    return (#data.tbl == 0);
end

function Stack:ForEach(data, func, ...)
    for _, item in tk.ipairs(data.tbl) do
        func(item, ...);
    end
end