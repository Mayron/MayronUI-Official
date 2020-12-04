-- luacheck: ignore MayronUI self 143 631
local addonName = ...;

local Lib = _G.LibStub:NewLibrary("LibMayronEvents", 1.6); ---@class LibMayronEvents
local obj = _G.MayronObjects:GetFramework(); ---@type MayronObjects

if (not (Lib and obj)) then return end

local pairs, ipairs, tostring, unpack, next = _G.pairs, _G.ipairs, _G.tostring, _G.unpack, _G.next;
local strtrim, strsplit, table, select = _G.strtrim, _G.strsplit, _G.table, _G.select;

local Private = {};

-- stores a list of handlers handling a given event.
-- These handlers will be executed when the event triggers unless disabled.
Private.handlersByEventName = {};

-- stores all handlers using their key for quick access
Private.handlersByKey = {};

Private.eventManagerFrame = _G.CreateFrame("Frame");

-- Objects ----------------------------

local EventsPackage = obj:CreatePackage("Events", addonName);

---@class Handler : Object
local Handler = EventsPackage:CreateClass("Handler");

------------------------
-- Handler Prototype
------------------------
function Handler:__Construct(data, eventName, callback, unitName, ...)
  data.callback = callback;
  data.key = tostring(self);
  data.eventTriggers = obj:PopTable();
  self:SetCallbackArgs(...);
  self:AddEventTrigger(eventName, unitName);
end

function Handler:__Destruct(data)
  for eventName, _ in pairs(data.eventTriggers) do
    for id, handler in ipairs(Private.handlersByEventName[eventName]) do
      if (handler == self) then
        table.remove(Private.handlersByEventName[eventName], id);
        Private:CleanEventTable(eventName);
        break;
      end
    end
  end

  Private.handlersByKey[data.key] = nil;
end

---@return table @Returns a table containing all event names registered with handler.
function Handler:GetEventNames(data)
  local eventNames = obj:PopTable();

  for eventName, _ in pairs(data.eventTriggers) do
    table.insert(eventNames, eventName);
  end

  return eventNames;
end

EventsPackage:DefineParams("string", "boolean");
---@param eventName string @The event name to trigger the handler function.
---@param enabled boolean @Set to false to prevent event from triggering the handler function (without destroying it).
function Handler:SetEventTriggerEnabled(data, eventName, enabled)
  data.eventTriggers[eventName] = enabled;
  return self;
end

EventsPackage:DefineParams("boolean");
---@param enabled boolean @Set to false to prevent ALL events from triggering (without destroying it).
function Handler:SetEnabled(data, enabled)
  for eventName, _ in pairs(data.eventTriggers) do
    data.eventTriggers[eventName] = enabled;
  end

  return self;
end

EventsPackage:DefineParams("string", "boolean");
EventsPackage:DefineReturns("boolean");
---@param eventName string @The name of the event to check for.
---@return boolean @Returns whether the event is enabled for the handler.
function Handler:IsEventCallbackEnabled(data, eventName)
  return data.eventTriggers[eventName];
end

EventsPackage:DefineParams("boolean");
---@param autoDestroy boolean @If true, the handler will automatically be destroyed after the first time it is executed.
function Handler:SetAutoDestroy(data, autoDestroy)
  data.autoDestroy = autoDestroy;
  return self;
end

---All variables passed to this function will be passed to the event handler function when the event is triggered.
function Handler:SetCallbackArgs(data, ...)
  if (select("#", ...) == 0) then
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
  Private.handlersByKey[key] = self;
  return self;
end

EventsPackage:DefineReturns("?string");
---@return string @If the handler has a key, it is returned.
function Handler:GetKey(data)
  return data.key;
end

EventsPackage:DefineParams("?string");
EventsPackage:DefineReturns("boolean");
---@param eventName string @The name of the event that triggered the handler (if supplied, the callback will only be executed if has not been disabled using SetEventTriggerEnabled).
---@return boolean @Returns true if the handler was destroyed during execution.
function Handler:Run(data, eventName, ...)
  if (obj:IsString(eventName) and not data.eventTriggers[eventName]) then
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
function Handler:AddEventTrigger(data, eventName, unitName)
  if (unitName) then
    Private.eventManagerFrame:RegisterUnitEvent(eventName, unitName);
  else
    Private.eventManagerFrame:RegisterEvent(eventName);
  end

  data.eventTriggers[eventName] = true;

  Private.handlersByEventName[eventName] = Private.handlersByEventName[eventName] or obj:PopTable();
  table.insert(Private.handlersByEventName[eventName], self);
  return self;
end

EventsPackage:DefineParams("string", "?string");
---@param eventName string @The event name to register with the handler.
---@param unitName string @The name of the unit to register events to (i.e. RegisterUnitEvent).
function Handler:RemoveEventTrigger(data, eventName, unitName)
  data.eventTriggers[eventName] = nil;
  local eventHandlers = Private.handlersByEventName[eventName];

  if (obj:IsTable(eventHandlers)) then
    for id, value in ipairs(eventHandlers) do
      if (value == self) then
        eventHandlers[id] = nil;
      end
    end

    if (not next(eventHandlers)) then
      if (unitName) then
        Private.eventManagerFrame:UnregisterUnitEvent(eventName, unitName);
      else
        Private.eventManagerFrame:UnregisterEvent(eventName);
      end

      Private.handlersByEventName[eventName] = nil;
      obj:PushTable(eventHandlers);
    end
  end

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
  if (obj:IsString(key)) then
    obj:Assert(self:FindEventHandlerByKey(key) == nil, "Event handler already exists with key \"%s\"", key);
  else
    obj:Assert(self:FindEventHandlerByKey(callback) == nil, "Event handler already exists for that callback function. Use a command-separated list of event names, or AddEventTrigger, instead.");
  end

  key = key or tostring(callback);

  local handler;
  if (eventName:find(",")) then

    for _, event in obj:IterateArgs(strsplit(",", eventName)) do
      event = strtrim(event);

      if (not handler) then
        handler = Handler(event, callback, unitName, ...);
      else
        handler:AddEventTrigger(event, unitName);
      end
    end
  else
    handler = Handler(eventName, callback, unitName, ...);
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
  return (Private.handlersByKey[key] ~= nil);
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
    local handler = Private.handlersByKey[key];
    Private.handlersByKey[key] = nil;
    handler:Destroy();
  end
end

---Find and return a handler with the specified key.
---@param key string @The key name.
---@return Handler @The found handler (possible nil if not found).
function Lib:FindEventHandlerByKey(key)
  return Private.handlersByKey[key];
end

---Find and return all handlers registered with the event name.
---@param eventName string @The event name.
---@return table @A table containing all found handlers registered with the specified event name.
function Lib:FindEventHandlersByEvent(eventName)
  return Private.handlersByEventName[eventName];
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

---@param eventName string @The event name.
---@return number @The total number of event handlers registered with the specified event name.
function Lib:GetNumEventHandlersByEvent(eventName)
  if (obj:IsTable(Private.handlersByEventName[eventName])) then
    return #Private.handlersByEventName[eventName];
  end

  return 0;
end

function Lib:DisableEventHandlers(...)
  for _, key in obj:IterateArgs(...) do
    if (self:HandlerExists(key)) then
      local handler = Private.handlersByKey[key]; ---@type Handler
      handler:SetEnabled(false);
    end
  end
end

function Lib:EnableEventHandlers(...)
  for _, key in obj:IterateArgs(...) do
    if (self:HandlerExists(key)) then
      local handler = Private.handlersByKey[key]; ---@type Handler
      handler:SetEnabled(true);
    end
  end
end

------------------------
-- Private API
------------------------
Private.eventManagerFrame:SetScript("OnEvent", function(_, ...)
  Private:CallHandlersByEvent(...);
end);

-- Finds all handlers in handlersByEventName and executes their
-- callback if registered with the eventName.
function Private:CallHandlersByEvent(eventName, ...)
  if (self:IsTableEmpty(self.handlersByEventName[eventName])) then return end
  local handlers = obj:PopTable();

  -- Make a copy to avoid updating the handlers table while iterating it.
  -- This ensures all handlers run successfully.
  for _, handler in ipairs(self.handlersByEventName[eventName]) do
    table.insert(handlers, handler);
  end

  for _, handler in pairs(handlers) do
    handler:Run(eventName, ...);
  end

  obj:PushTable(handlers);
end

function Private:CleanEventTable(eventName)
  if (obj:IsTable(self.handlersByEventName[eventName])) then
    local activeHandlers = obj:PopTable();
    local handlers = self.handlersByEventName[eventName];

    for _, handler in pairs(handlers) do
      if (not handler.IsDestroyed) then
        table.insert(activeHandlers, handler);
      end
    end

    self.handlersByEventName[eventName] = activeHandlers;
    obj:PushTable(handlers);

    if self:IsTableEmpty(self.handlersByEventName[eventName]) then
      self.handlersByEventName[eventName] = nil;
      self.eventManagerFrame:UnregisterEvent(eventName);
    end
  end
end

function Private:IsTableEmpty(tbl)
  return obj:IsTable(tbl) and #tbl == 0;
end