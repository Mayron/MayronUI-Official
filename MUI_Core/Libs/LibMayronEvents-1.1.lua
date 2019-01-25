-- luacheck: ignore MayronUI self 143 631
local addonName = ...;

local Lib = _G.LibStub:NewLibrary("LibMayronEvents", 1.1);

if (not Lib) then
    return;
end

local unpack = _G.unpack;

local Private = {};
Private.eventsList = {};
Private.eventKeys = {};
Private.eventTracker = _G.CreateFrame("Frame");

local obj = _G.LibStub:GetLibrary("LibMayronObjects");
local EventsPackage = obj:CreatePackage("Events", addonName);
local Handler = EventsPackage:CreateClass("Handler");

------------------------
-- Handler Prototype
------------------------
function Handler:__Construct(data, eventName, callback, unit, ...)
    data.callback = callback;
    data.key = tostring(self);
    data.events = obj:PopWrapper();
    self:SetCallbackArgs(...);

    self:AppendEvent(eventName, unit);
end

function Handler:__Destruct(data)
    for eventName, _ in pairs(data.events) do
        for id, handler in ipairs(Private.eventsList[eventName]) do
            if (handler == self) then
                table.remove(Private.eventsList[eventName], id);
                Private:CleanEventTable(data.eventName);
                break;
            end
        end
    end
end

function Handler:GetEventNames(data)
    local eventNames = obj:PopWrapper();

    for eventName, _ in pairs(data.events) do
        table.insert(eventNames, eventName);
    end

    return eventNames;
end

function Handler:SetEventCallbackEnabled(data, eventName, enabled)
    data.events[eventName] = enabled;
end

function Handler:IsEventCallbackEnabled(data, eventName)
    return data.events[eventName];
end

function Handler:SetAutoDestroy(data, autoDestroy)
    data.autoDestroy = autoDestroy;
end

function Handler:SetCallbackArgs(data, ...)
    if (obj:LengthOfArgs(...) == 0) then
        return;
    end

    if (data.args) then
        obj:PushWrapper(data.args);
    end

    data.args = obj:PopWrapper(...);

    if (DALKD) then
        obj:PrintTable(data.args);
    end
end

function Handler:SetKey(data, key)
    if (not key) then
        data.key = tostring(self);
    else
        data.key = key;
    end

    Private.eventKeys[key] = self;
end

function Handler:GetKey(data)
    return data.key;
end

function Handler:Run(data, ...)
    if (data.callback) then
        if (data.args) then
            -- execute event callback
            local args = obj:PopWrapper(unpack(data.args));

            obj:PrintTable(args);

            for _, value in obj:IterateArgs(...) do
                table.insert(args, value);
            end

            data.callback(self, data.eventName, unpack(args));
            obj:PushWrapper(args);
        else
            -- execute event callback
            data.callback(self, data.eventName, ...);
        end
    end

    if (data.autoDestroy) then
        self:Destroy();
        return true;
    end

    return false;
end

function Handler:AppendEvent(data, eventName, unit)
    if (unit) then
        Private.eventTracker:RegisterUnitEvent(eventName, unit);
    else
        Private.eventTracker:RegisterEvent(eventName);
    end

    data.events[eventName] = true;

    Private.eventsList[eventName] = Private.eventsList[eventName] or obj:PopWrapper();
    table.insert(Private.eventsList[eventName], self);
end

------------------------
-- Lib API
------------------------
-- @param eventName (string) - the name of the event to register
--      (or a comma separated list of event names to attach to 1 handler)
-- @param callback (function) - function to call when the event triggers
-- @param unit (boolean) - whether the event is a unit event
-- @return (Handler) - handler object created for the registered event
function Lib:CreateEventHandler(eventName, callback, unit, ...)
    local handler;

    if (eventName:find(",")) then
        for _, event in obj:IterateArgs(_G.strsplit(",", eventName)) do
            event = _G.strtrim(event);

            if (not handler) then
                handler = Handler(event, callback, unit, ...);
            else
                handler:AppendEvent(event, unit);
            end
        end
    else
        handler = Handler(eventName, callback, ...);
    end

    return handler;
end

function Lib:CreateEventHandlerWithKey(eventName, key, callback, unit, ...)
    local handler = self:FindHandlerByKey(key);

    if (not handler) then
        handler = self:CreateEventHandler(eventName, callback, unit, ...);
        handler:SetKey(key);
    end

    return handler;
end

function Lib:TriggerEvent(eventName, ...)
    if (Private:EventTableExists(eventName)) then
        for _, handler in pairs(Private.eventsList[eventName]) do
            handler:Run(...);
        end
    end
end

function Lib:HandlerExists(key)
    return (Private.eventKeys[key] ~= nil);
end

function Lib:DestroyHandlersByKey(...)
    for _, key in obj:IterateArgs(...) do
        self:DestroyHandlerByKey(key);
    end
end

function Lib:DestroyHandlerByKey(key)
    if (self:HandlerExists(key)) then
        Private.eventKeys[key]:Destroy();
    end
end

function Lib:FindHandlerByKey(key)
    return Private.eventKeys[key];
end

function Lib:FindHandlersByEvent(eventName)
    return Private.eventsList[eventName];
end

function Lib:GetNumHandlersByEvent(eventName)
    if (Private:EventTableExists(eventName)) then
        return #Private.eventsList[eventName];
    end
end

------------------------
-- Private API
------------------------
Private.eventTracker:SetScript("OnEvent", function(_, ...)
    Private:CallHandlersByEvent(...);
end);

-- Finds all handlers in eventsList and executes their
-- callback if registered with the eventName.
function Private:CallHandlersByEvent(eventName, ...)
    if (not self:IsEventTableEmpty(eventName)) then
        local handlers = self.eventsList[eventName];

        for _, handler in pairs(handlers) do
            handler:Run(...);
        end
    end

    self:CleanEventTable(eventName);
end

function Private:CleanEventTable(eventName)
    if (self:EventTableExists(eventName)) then
        local activeHandlers = obj:PopWrapper();
        local handlers = self.eventsList[eventName];

        for _, handler in pairs(handlers) do
            if (not handler.IsDestroyed) then
                table.insert(activeHandlers, handler);
            end
        end

        self.eventsList[eventName] = activeHandlers;
        obj:PushWrapper(handlers);

        if self:IsEventTableEmpty(eventName) then
            self.eventsList[eventName] = nil;
            self.eventTracker:UnregisterEvent(eventName);
        end
    end
end

function Private:IsEventTableEmpty(eventName)
    return self.eventsList and #self.eventsList[eventName] == 0;
end

function Private:EventTableExists(eventName)
    return (self.eventsList and self.eventsList[eventName] and
            type(self.eventsList[eventName]) == "table");
end