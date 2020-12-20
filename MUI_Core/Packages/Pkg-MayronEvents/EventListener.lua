-- luacheck: ignore self 143 631
local obj = _G.MayronObjects:GetFramework(); ---@type MayronObjects

---@class PkgMayronEvents : Package
local PkgMayronEvents = obj:Import("Pkg-MayronEvents");

---@class EventListener : Object
local C_EventListener = PkgMayronEvents:CreateClass("EventListener");
C_EventListener.Static:AddFriendClass("EventManager");

local select, unpack, pairs, ipairs, next, tostring = _G.select, _G.unpack, _G.pairs, _G.ipairs, _G.next, _G.tostring;

-----------------------------------------------------------
--- C_EventListener API:
-----------------------------------------------------------
PkgMayronEvents:DefineParams("function", "EventManager");
---constructor - you create an event listener from the event manager using either
---CreateEventListener, or CreateEventListenerWithID. Do not call `__Construct` directly!
function C_EventListener:__Construct(data, callback, manager)
  data.callback = callback;
  data.manager = manager;
  data.argsLength = 0;

  -- by default, the event listener is enabled.
  data.enabled = true;

  -- by default, the ID is the unique memory address of the handler object.
  self:SetID(tostring(self));
end

-- destructor - you can manually destroy an event listener using `listener:Destroy()`, or by calling `listener:SetExecuteOnce(true)`
-- and letting the event manager destroy it automatically after it's first execution. Do not call `__Destruct` directly!
function C_EventListener:__Destruct(data)
  local managerData = data:GetFriendData(data.manager);
  managerData.listeners[data.id] = nil;
end

PkgMayronEvents:DefineParams("string");
---@param id string @A unique ID used to refer to the event listener when using the C_EventManager API.
function C_EventListener:SetID(data, id)
  if (data.id == id) then return end

  local managerData = data:GetFriendData(data.manager);

  for existingID, _ in pairs(managerData.listeners) do
    if (existingID == id) then
      obj:Error("An event listener with ID '%s' has already been registered with this event manager.", id);
    end
  end

  if (data.id ~= nil) then
    managerData.listeners[data.id] = nil;
  end

  data.id = id;
  managerData.listeners[data.id] = self;
end

PkgMayronEvents:DefineReturns("string");
---If the event listener has not been assigned a custom unique ID, it will return the unique memory address of the handler object.
---@return string @Returns the unique ID used to refer to the event listener when using the C_EventManager API.
function C_EventListener:GetID(data)
  return data.id;
end

PkgMayronEvents:DefineParams("boolean");
---Used to enable or disable the event listener. When disabled, the event listener
---will not trigger its associated callback function even if the event is fired.
---@param enabled boolean @The new enabled state of the event listener.
function C_EventListener:SetEnabled(data, enabled)
  data.enabled = enabled;
end

PkgMayronEvents:DefineReturns("boolean");
---Returns whether the event listener is enabled or disabled. When disabled, the event listener
---will not trigger its associated callback function even if the event is fired.
---@return boolean @The current enabled state of the event listener.
function C_EventListener:IsEnabled(data)
  return data.enabled;
end

PkgMayronEvents:DefineParams("boolean");
---If executeOnce is set to `true`, then the event listener object will be destroyed and
---removed from the event manager after its first execution. Some callback functions only need to be
---executed once. You can also call the `Destroy()` method on the event listener at any time to destroy it manually.
---@param executeOnce boolean @Represents whether the event manager should destroy the event listener after executing it once.
function C_EventListener:SetExecuteOnce(data, executeOnce)
  data.executeOnce = executeOnce;
end

---Sets a custom list of callback arguments to be passed to the callback function each time it is triggered.
---These callback arguments will appear after the first two arguments (self, event),
---and before the event-specific arguments. Each time this method is called, it will replace previously specified custom
---callback arguments. Therefore, calling this method with no arguments will remove all of them. Note: If you call this
---method with only `nil` then `nil` will still be passed as a custom callback argument.
---@param ... any @A list of custom callback arguments to be passed to the callback function each time it is executed.
function C_EventListener:SetCallbackArgs(data, ...)
  if (obj:IsTable(data.args)) then
    obj:EmptyTable(data.args);
  else
    data.args = obj:PopTable();
  end

  data.argsLength = select("#", ...); -- preserve trailing `nil` values
  for i = 1, data.argsLength do
    data.args[i] = (select(i, ...));
  end
end

PkgMayronEvents:DefineParams("string");
---Register a Blizzard event for the event listener to listen out for. If enabled, the event listener
---will execute its callback function when the event fires.
---@param event string @The Blizzard event to register.
function C_EventListener:RegisterEvent(data, event)
  data.events = data.events or obj:PopTable();
  data.events[event] = true;

  local managerData = data:GetFriendData(data.manager);
  managerData.frame:RegisterEvent(event);
end

PkgMayronEvents:DefineParams("string", "...string");
---Helper function that takes a variable argument list of Blizzard event names and calls `RegisterEvent` for each one.
---@vararg string @A variable argument list of Blizzard event names register.
function C_EventListener:RegisterEvents(_, ...)
  for i = 1, select("#", ...) do
    self:RegisterEvent((select(i, ...)));
  end
end

PkgMayronEvents:DefineParams("string", "string", "?string", "?string");
---Register a Blizzard unit event for the event listener to listen out for. If enabled, the event listener
---will execute its callback function when the event fires for one of the specified units.
---@param event string @The Blizzard unit event to register.
---@param unit1 string @A unitID to register with the unit event (e.g., "player").
---@param unit2 string @An optional 2nd unitID to register with the unit event (e.g., "target").
---@param unit3 string @An optional 3rd unitID to register with the unit event (e.g., "focus").
function C_EventListener:RegisterUnitEvent(data, event, unit1, unit2, unit3)
  data.events = data.events or obj:PopTable();
  data.events[event] = obj:PopTable(unit1, unit2, unit3);

  local managerData = data:GetFriendData(data.manager);
  managerData.frame:RegisterEvent(event);
end

PkgMayronEvents:DefineParams("table", "string", "?string", "?string", "boolean=true");
---Helper function that takes a table of Blizzard event names and calls RegisterUnitEvent for each one with the provided unitIDs.
---@param events table @A table containing the Blizzard unit events to register.
---@param unit1 string @A unitID to register with the unit event (e.g., "player").
---@param unit2 string @An optional 2nd unitID to register with the unit event (e.g., "target").
---@param unit3 string @An optional 3rd unitID to register with the unit event (e.g., "focus").
---@param pushTable boolean @Optional boolean value to override the default "true" to avoid recycling the table.
function C_EventListener:RegisterUnitEvents(_, events, unit1, unit2, unit3, pushTable)
  for _, event in ipairs(events) do
    self:RegisterUnitEvent(event, unit1, unit2, unit3);
  end

  if (pushTable) then
    obj:PushTable(events);
  end
end

PkgMayronEvents:DefineParams("string");
---Register a non-Blizzard, custom addon event for the event listener to listen out for. If enabled, the event listener
---will execute its callback function when the event manager fires the custom event using its `FireCustomEvent` method.
---@param customEvent string @The non-Blizzard, custom addon event to register.
function C_EventListener:RegisterCustomEvent(data, customEvent)
  data.customEvents = data.customEvents or obj:PopTable();
  data.customEvents[customEvent] = true;
end

PkgMayronEvents:DefineParams("string", "...string");
---Helper function that takes a variable argument list of custom event names and calls RegisterCustomEvent for each one.
---@vararg string @A variable argument list of (non-Blizzard) custom addon events to register.
function C_EventListener:RegisterCustomEvents(_, ...)
  for i = 1, select("#", ...) do
    self:RegisterCustomEvent((select(i, ...)));
  end
end

PkgMayronEvents:DefineParams("string");
---Unregister a Blizzard event to stop the event listener from triggering its callback function when the event is fired.
---@param event string @The Blizzard event to unregister.
function C_EventListener:UnregisterEvent(data, event)
  if (not obj:IsTable(data.events) or not data.events[event]) then return end
  data.events[event] = nil;

  if (not next(data.events)) then
    obj:PushTable(data.events);
    data.events = nil;
  end

  local total = data.manager:GetNumEventListenersByEvent(event);
  if (total == 0) then
    local managerData = data:GetFriendData(data.manager);
    managerData.frame:UnregisterEvent(event);
  end
end

PkgMayronEvents:DefineParams("string", "...string");
---Helper function that takes a variable argument list of Blizzard event names and calls `UnregisterEvent` for each one.
---@vararg string @A variable argument list of Blizzard events to unregister.
function C_EventListener:UnregisterEvents(_, ...)
  for i = 1, select("#", ...) do
    self:UnregisterEvent((select(i, ...)));
  end
end

PkgMayronEvents:DefineParams("string");
---Unregister a (non-Blizzard) custom addon event to stop the event listener from triggering its callback function when
---the event manager fires the custom event using its `FireCustomEvent` method.
---@param customEvent string @The non-Blizzard, custom addon event to unregister.
function C_EventListener:UnregisterCustomEvent(data, customEvent)
  if (not obj:IsTable(data.customEvents) or not data.customEvents[customEvent]) then return end
  data.customEvents[customEvent] = nil;

  if (not next(data.customEvents)) then
    obj:PushTable(data.customEvents);
    data.customEvents = nil;
  end
end

PkgMayronEvents:DefineParams("string", "...string");
---Helper function that takes a variable argument list of custom event names and calls `UnregisterCustomEvent` for each one.
---@vararg string @A variable argument list of (non-Blizzard) custom addon events to unregister.
function C_EventListener:UnregisterCustomEvents(_, ...)
  for i = 1, select("#", ...) do
    self:UnregisterCustomEvent((select(i, ...)));
  end
end

PkgMayronEvents:DefineParams("boolean=true");
---Unregister all Blizzard events and custom addon events from the event listener. This will stop the callback function from
---being executed when any previously registered event fires.
---@param includeCustomEvents string @If set to `false`, only the Blizzard events will be unregistered and the custom addon events
---will remain registered with the event listener. By default, this parameter will be assigned `true`.
function C_EventListener:UnregisterAllEvents(data, includeCustomEvents)
  if (includeCustomEvents and obj:IsTable(data.customEvents)) then
    for customEvent, _ in pairs(data.customEvents) do
      self:UnregisterCustomEvent(customEvent);
    end
  end

  if (obj:IsTable(data.events)) then
    for event, _ in pairs(data.events) do
      self:UnregisterEvent(event);
    end
  end
end

PkgMayronEvents:DefineReturns("table");
---Returns all Blizzard events registered with this event listener. If any of these Blizzard events trigger when the event
---listener is enabled, the callback function will execute.
---@return table @A table containing all registered Blizzard events.
function C_EventListener:GetRegisteredEvents(data)
  local events = obj:PopTable();

  if (obj:IsTable(data.events)) then
    for event, _ in pairs(data.events) do
      events[#events + 1] = event;
    end
  end

  return events;
end

PkgMayronEvents:DefineReturns("number");
---@return number @The total number of Blizzard events registered with this event listener.
function C_EventListener:GetNumRegisteredEvents()
  local events = self:GetRegisteredEvents();
  local total = #events;
  obj:PushTable(events);
  return total;
end

PkgMayronEvents:DefineReturns("table");
---Returns all (non-Blizzard) custom addon events registered with this event listener. Custom events are triggered using
---the C_EventManager API using the event manager's `FireCustomEvent` method, which will execute the callback function if the
---handler is enabled.
---@return table @A table containing all registered (non-Blizzard) custom addon events.
function C_EventListener:GetRegisteredCustomEvents(data)
  local events = obj:PopTable();

  if (obj:IsTable(data.customEvents)) then
    for customEvent, _ in pairs(data.customEvents) do
      events[#events + 1] = customEvent;
    end
  end

  return events;
end

PkgMayronEvents:DefineReturns("number");
---@return number @The total number of (non-Blizzard) custom addon events registered with this event listener.
function C_EventListener:GetNumRegisteredCustomEvents()
  local customEvents = self:GetRegisteredCustomEvents();
  local total = #customEvents;
  obj:PushTable(customEvents);
  return total;
end

function C_EventListener.Private:Run(data, event, ...)
  if (not data.enabled) then return end
  local args = obj:PopTable();

  if (obj:IsNumber(data.argsLength) and data.argsLength > 0) then
    for i = 1, data.argsLength do
      args[i] = data.args[i];
    end
  end

  for i = 1, select("#", ...) do
    args[i + data.argsLength] = (select(i, ...));
  end

  -- execute callback function here:
  data.callback(self, event, unpack(args, 1, (data.argsLength + select("#", ...))));

  if (data.executeOnce) then
    self:Destroy();
  end
end