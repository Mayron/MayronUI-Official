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
function Handler:__Construct(data, eventName, callback)
    data.eventName = eventName;
    data.callback = callback;
    data.key = tostring(self);
end

function Handler:__Destruct(data)
    table.remove(Private.eventsList[data.eventName], self:GetPriority());
    Private:CleanEventTable(data.eventName);
end

function Handler:SetPriority(data, priority)
    local handlers = Private.eventsList[data.eventName];
    local old_priority = self:GetPriority();

    table.remove(handlers, old_priority);
    table.insert(handlers, priority, self);
end

function Handler:GetPriority(data)
    for priority, handler in pairs(Private.eventsList[data.eventName]) do
        if (handler:GetKey() == data.key) then
            return priority;
        end
    end
end

function Handler:GetEventName(data)
    return data.eventName;
end

function Handler:SetAutoDestroy(data, autoDestroy)
    data.autoDestroy = autoDestroy;
end

function Handler:SetCallbackArgs(data, ...)
    if (data.args) then
        obj:PushWrapper(data.args);
    end

    data.args = obj:PopWrapper(...);
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

function Handler:Run(data, eventName, ...)
    if (data.callback) then
        if (data.args) then
            -- execute event callback
            data.callback(self, eventName, unpack(data.args), ...);
        else
            -- execute event callback
            data.callback(self, eventName, ...);
        end
    end

    if (data.autoDestroy) then
        self:Destroy();
        return true;
    end

    return false;
end

------------------------
-- Lib API
------------------------
-- @param eventName (string) - the name of the event to register
-- @param callback (function) - function to call when the event triggers
-- @param unit (boolean) - whether the event is a unit event
-- @return (Handler) - handler object created for the registered event
function Lib:CreateEventHandler(eventName, callback, unit, ...)
    Private.eventsList[eventName] = Private.eventsList[eventName] or obj:PopWrapper();

    local handler = Handler(eventName, callback);
    table.insert(Private.eventsList[eventName], handler);
    handler:SetCallbackArgs(...);

    if (unit) then
        Private.eventTracker:RegisterUnitEvent(eventName, unit);
    else
        Private.eventTracker:RegisterEvent(eventName);
    end

    return handler;
end

function Lib:CreateEventHandlerWithKey(eventName, key, callback, unit, ...)
    local handler = self:CreateEventHandler(eventName, callback, unit, ...);
    handler:SetKey(key);
    return handler;
end

-- @param eventNames (string) - comma separated string list of event names
-- @param callback (function) - function to call when any of the events trigger
-- @param unit (boolean) - whether the events are unit events
-- @return (Handler) - handler objects created for each event in eventNames
function Lib:CreateEventHandlers(eventNames, callback, unit, ...)
    local handlers = obj:PopWrapper();

    for id, event in obj:IterateArgs(_G.strsplit(",", eventNames)) do
        event = _G.strtrim(event);

		if (#event > 0) then
			handlers[id] = Lib:CreateEventHandler(event, callback, unit, ...);
		end
    end

    return obj:UnpackWrapper(handlers);
end

function Lib:TriggerEvent(eventName, ...)
    if (Private:EventTableExists(eventName)) then
        for _, handler in pairs(Private.eventsList[eventName]) do
            handler:Run(eventName, ...);
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

function Lib:FindHandlerByEventPriority(eventName, priority)
    if (Private:EventTableExists(eventName)) then
        return Private.eventsList[eventName][priority];
    end
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
            handler:Run(eventName, ...);
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