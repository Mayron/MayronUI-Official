-- luacheck: ignore MayronUI self 143 631
local addonName = ...;

local _G = _G;

---@class LibMayronEvents
local Lib = _G.LibStub:NewLibrary("LibMayronEvents", 1.1);

local pairs, ipairs, tostring = _G.pairs, _G.ipairs, _G.tostring;

if (not Lib) then
    return;
end

local unpack = _G.unpack;

local Private = {};
Private.eventsList = {};
Private.eventKeys = {};
Private.eventTracker = _G.CreateFrame("Frame");

-- Objects ----------------------------

---@type Objects
local obj = _G.LibStub:GetLibrary("LibMayronObjects");

local EventsPackage = obj:CreatePackage("Events", addonName);

---@class Handler : Object
local Handler = EventsPackage:CreateClass("Handler");

------------------------
-- Handler Prototype
------------------------
function Handler:__Construct(data, eventName, callback, unitName, ...)
    data.callback = callback;
    data.key = tostring(self);
    data.events = obj:PopTable();
    self:SetCallbackArgs(...);

    self:AppendEvent(eventName, unitName);
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

    Private.eventKeys[data.key] = nil;
end

---@return table @Returns a table containing all event names registered with handler.
function Handler:GetEventNames(data)
    local eventNames = obj:PopTable();

    for eventName, _ in pairs(data.events) do
        table.insert(eventNames, eventName);
    end

    return eventNames;
end

EventsPackage:DefineParams("string", "boolean");
---@param eventName string @The event name to enable or disable.
---@param enabled boolean @Set to false to prevent event from triggering (without destroying it).
function Handler:SetEventCallbackEnabled(data, eventName, enabled)
    data.events[eventName] = enabled;
    return self;
end

EventsPackage:DefineParams("string", "boolean");
EventsPackage:DefineReturns("boolean");
---@param eventName string @The name of the event to check for.
---@return boolean @Returns whether the event is enabled for the handler.
function Handler:IsEventCallbackEnabled(data, eventName)
    return data.events[eventName];
end

EventsPackage:DefineParams("boolean");
---@param autoDestroy boolean @If true, the handler will automatically be destroyed after the first time it is executed.
function Handler:SetAutoDestroy(data, autoDestroy)
    data.autoDestroy = autoDestroy;
    return self;
end

---All variables passed to this function will be passed to the event handler function when the event is triggered.
function Handler:SetCallbackArgs(data, ...)
    if (obj:LengthOfArgs(...) == 0) then
        return;
    end

    if (data.args) then
        obj:PushTable(data.args);
    end

    data.args = obj:PopTable(...);
    return self;
end

EventsPackage:DefineParams("string");
---@param key string @A unique key to easily find an event handler object using the library "find" functions.
function Handler:SetKey(data, key)
    data.key = key;
    Private.eventKeys[key] = self;
    return self;
end

EventsPackage:DefineReturns("?string");
---@return string @If the handler has a key, it is returned.
function Handler:GetKey(data)
    return data.key;
end

EventsPackage:DefineParams("?string");
EventsPackage:DefineReturns("boolean");
---@param eventName string @The name of the event that triggered the handler (if supplied, the callback will only be executed if has not been disabled using SetEventCallbackEnabled).
---@return boolean @Returns true if the handler was destroyed during execution.
function Handler:Run(data, eventName, ...)
    if (obj:IsString(eventName) and not data.events[eventName]) then
        return false; -- event callback has been disabled.
    end

    if (data.callback) then
        if (data.args) then
            -- execute event callback
            local args = obj:PopTable(unpack(data.args));

            for _, value in obj:IterateArgs(...) do
                table.insert(args, value);
            end

            data.callback(self, eventName, unpack(args));
            obj:PushTable(args);
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

EventsPackage:DefineParams("string", "?string");
---@param eventName string @The event name to register with the handler.
---@param unitName string @The name of the unit to register events to (i.e. RegisterUnitEvent).
function Handler:AppendEvent(data, eventName, unitName)
    if (unitName) then
        Private.eventTracker:RegisterUnitEvent(eventName, unitName);
    else
        Private.eventTracker:RegisterEvent(eventName);
    end

    data.events[eventName] = true;

    Private.eventsList[eventName] = Private.eventsList[eventName] or obj:PopTable();
    table.insert(Private.eventsList[eventName], self);
    return self;
end

------------------------
-- Lib API
------------------------
---@param eventName string @The name of the event to register (or a comma separated list of event names to attach to 1 handler).
---@param key string @Assign a unique key to the handler to easily find it using the library "find" functions.
---@param callback function @Function to call when the event triggers.
---@param unitName string @The name of the unit to register events to.
---@return Handler @Handler object created for the registered event.
function Lib:CreateUnitEventHandlerWithKey(eventName, key, callback, unitName, ...)
    key = key or tostring(callback);
    local handler = self:FindEventHandlerByKey(key);

    if (eventName:find(",")) then
        for _, event in obj:IterateArgs(_G.strsplit(",", eventName)) do
            event = _G.strtrim(event);

            if (not handler) then
                handler = Handler(event, callback, unitName, ...);
            else
                handler:AppendEvent(event, unitName);
            end
        end
    elseif (not handler) then
        handler = Handler(eventName, callback, unitName, ...);
    else
        handler:AppendEvent(eventName, unitName);
    end

    handler:SetKey(key);
    return handler;
end

---@param eventName string @The name of the event to register (or a comma separated list of event names to attach to 1 handler).
---@param callback function @Function to call when the event triggers.
---@param unitName string @The name of the unit to register events to (i.e. RegisterUnitEvent).
---@return Handler @Handler object created for the registered event.
function Lib:CreateUnitEventHandler(eventName, callback, unitName, ...)
    return self:CreateUnitEventHandlerWithKey(eventName, nil, callback, unitName, ...);
end

---@param eventName string @The name of the event to register (or a comma separated list of event names to attach to 1 handler).
---@param key string @Assign a unique key to the handler to easily find it using the library "find" functions.
---@param callback function @Function to call when the event triggers.
---@return Handler @Handler object created for the registered event.
function Lib:CreateEventHandlerWithKey(eventName, key, callback, ...)
    return self:CreateUnitEventHandlerWithKey(eventName, key, callback, nil, ...);
end

---@param eventName string @The name of the event to register (or a comma separated list of event names to attach to 1 handler).
---@param callback function @Function to call when the event triggers.
---@return Handler @Handler object created for the registered event.
function Lib:CreateEventHandler(eventName, callback, ...)
    return self:CreateUnitEventHandlerWithKey(eventName, nil, callback, nil, ...);
end

---@param key string @Check whether a handler with the specified key exists.
---@return boolean @If a handler is found, true is returned.
function Lib:HandlerExists(key)
    return (Private.eventKeys[key] ~= nil);
end

---Pass a variable argument list of keys to find and destroy all handlers with the specified key/s.
function Lib:DestroyEventHandlersByKey(...)
    for _, key in obj:IterateArgs(...) do
        self:DestroyEventHandlerByKey(key);
    end
end

---Find and destroy a handler with the specified key.
---@param key string @The key name.
function Lib:DestroyEventHandlerByKey(key)
    if (self:HandlerExists(key)) then
        Private.eventKeys[key]:Destroy();
        Private.eventKeys[key] = nil;
    end
end

---Find and return a handler with the specified key.
---@param key string @The key name.
---@return Handler @The found handler (possible nil if not found).
function Lib:FindEventHandlerByKey(key)
    return Private.eventKeys[key];
end

---Find and return all handlers registered with the event name.
---@param eventName string @The event name.
---@return table @A table containing all found handlers registered with the specified event name.
function Lib:FindEventHandlersByEvent(eventName)
    return Private.eventsList[eventName];
end

---Find and trigger a handler with the specified key if found.
---@param key string @The key name.
---@return boolean @Returns true if a handler with the specified key was found and triggered.
function Lib:TriggerEventHandlerByKey(key)
    local handler = self:FindEventHandlerByKey(key);

    if (handler) then
        handler:Run();
        return true;
    end

    return false;
end

---Find and trigger handler callbacks for the specified event name if found.
---@param eventName string @The name of the even to trigger.
---@return boolean @Returns true if a handler callback for the specified event was found and triggered.
function Lib:TriggerEventHandlerByEvent(eventName)
    local handlers = self:FindEventHandlersByEvent(eventName);
    local executed = false;

    if (obj:IsTable(handlers)) then
        for _, handler in pairs(handlers) do
            if (handler:Run(eventName)) then
                executed = true;
            end
        end
    end

    return executed;
end

---@param eventName string @The event name.
---@return number @The total number of event handlers registered with the specified event name.
function Lib:GetNumEventHandlersByEvent(eventName)
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
        local activeHandlers = obj:PopTable();
        local handlers = self.eventsList[eventName];

        for _, handler in pairs(handlers) do
            if (not handler.IsDestroyed) then
                table.insert(activeHandlers, handler);
            end
        end

        self.eventsList[eventName] = activeHandlers;
        obj:PushTable(handlers);

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
            obj:IsTable(self.eventsList[eventName]));
end