local addonName, Core = ...;

local Lib = LibStub:NewLibrary("LibMayronEvents", 1.0);
if (not Lib) then return; end

local error, assert, rawget, rawset = error, assert, rawget, rawset;
local type, setmetatable, table, string = type, setmetatable, table, string;
local getmetatable, unpack, select = getmetatable, unpack, select;

local Private = {};
Private.eventsList = {};
Private.eventTracker = CreateFrame("Frame");

local LibObjectLua = LibStub:GetLibrary("LibMayronObjects");
local EventsPackage = LibObjectLua:CreatePackage("Events", addonName);
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

function Handler:SetKey(data, key)
    if (not key) then
        data.key = tostring(self);
    else
        data.key = key;
    end
end

function Handler:GetKey(data)
    return data.key;
end

function Handler:Run(data, eventName, ...)
    if (data.callback) then
        -- execute event callback
        data.callback(self, eventName, ...);
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
function Lib:CreateEventHandler(eventName, callback, unit)
    Private.eventsList[eventName] = Private.eventsList[eventName] or {};

    local handler = Handler(eventName, callback);  
    table.insert(Private.eventsList[eventName], handler);

    if (unit) then
        Private.eventTracker:RegisterUnitEvent(eventName, unit);
    else
        Private.eventTracker:RegisterEvent(eventName);
    end

    return handler;
end

-- @param eventNames (string) - comma separated string list of event names
-- @param callback (function) - function to call when any of the events trigger
-- @param unit (boolean) - whether the events are unit events
-- @return (Handler) - handler objects created for each event in eventNames
function Lib:CreateEventHandlers(eventNames, callback, unit)
    local handlers = {};
	
    for id, event in ipairs({strsplit(",", eventNames)}) do	
        event = strtrim(event);
		
		if (#event > 0) then
			handlers[id] = Lib:CreateEventHandler(event, callback, unit);
		end		
    end
	
    return unpack(handlers);
end

function Lib:TriggerEvent(eventName, ...)
    if (Private:EventTableExists(eventName)) then        
        for _, handler in pairs(Private.eventsList[eventName]) do
            handler:Run(eventName, ...);        
        end
    end    
end

function Lib:FindHandlerByKey(event, key)
    if (Private:EventTableExists(event)) then
        for _, handler in pairs(Private.eventsList[event]) do
            if (handler:GetKey() == key) then
                return handler;
            end
        end
    end
end

function Lib:FindHandlerByPriority(event, priority)
    if (Private:EventTableExists(event)) then
        return Private.eventsList[event][priority];
    end
end

function Lib:GetNumEventHandlers(event)
    if (Private:EventTableExists(event)) then
        return #Private.eventsList[event];
    end
end

------------------------
-- Private API
------------------------
Private.eventTracker:SetScript("OnEvent", function(_, ...)
    Private:CallHandlers(...)
end);

-- Finds all handlers in eventsList and executes their  
-- callback if registered with the eventName.
function Private:CallHandlers(eventName, ...)
    if (not self:IsEventTableEmpty(eventName)) then
        local handlers = self.eventsList[eventName];

        for id, handler in pairs(handlers) do            
            handler:Run(eventName, ...);
        end
    end
    
    self:CleanEventTable(event);
end

function Private:CleanEventTable(eventName)
    if (self:EventTableExists(eventName)) then
        local activeHandlers = {};
        local handlers = self.eventsList[eventName];
    
        for id, handler in pairs(handlers) do            
            if (not handler:IsDestroyed()) then
                table.insert(activeHandlers, handler);
            end
        end
    
        self.eventsList[eventName] = activeHandlers;

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