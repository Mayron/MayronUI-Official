-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local _, _, em, _, obj = MayronUI:GetCoreComponents();

---@class MayronUI.EventListener
---@field private __callback function
---@field private __manager MayronUI.EventManager
---@field private __argsLength number
---@field private __args any[]?
---@field private __enabled boolean
---@field private __id string
---@field private __executeOnce boolean?
---@field private __events table<string, boolean|string[]>? # string list of unitIDs or true/false for non-unit events
---@field private __customEvents table<string, boolean>?
local EventListenerMixin = {};
em.EventListenerMixin = EventListenerMixin;

local select, pairs, ipairs, next, tostring = _G.select, _G.pairs, _G.ipairs, _G.next, _G.tostring;
local pcall = _G.pcall;
-----------------------------------------------------------
--- EventListener API:
-----------------------------------------------------------
---constructor - you create an event listener from the event manager using either
---CreateEventListener, or CreateEventListenerWithID. Do not call `__Construct` directly!
function EventListenerMixin:Init(callback, manager)
  self.__callback = callback;
  self.__manager = manager;
  self.__argsLength = 0;
  -- by default, the event listener is enabled.
  self.__enabled = true;

  -- by default, the ID is the unique memory address of the handler object.
  self:SetID(tostring(self));
end

-- destructor - you can manually destroy an event listener using `listener:Destroy()`, or by calling `listener:SetExecuteOnce(true)`
-- and letting the event manager destroy it automatically after it's first execution. Do not call `__Destruct` directly!
function EventListenerMixin:Destroy()
  if (obj:IsTable(self.__customEvents)) then
    local customEvents = obj:PopTable();
    for customEvent, _ in pairs(self.__customEvents) do
      customEvents[#customEvents + 1] = customEvent;
    end

    for _, customEvent in ipairs(customEvents) do
      self:UnregisterCustomEvent(customEvent);
    end

    obj:PushTable(customEvents);
  end

  if (obj:IsTable(self.__events)) then
    local events = obj:PopTable();
    for event, _ in pairs(self.__events) do
      events[#events + 1] = event;
    end

    for _, event in ipairs(events) do
      self:UnregisterEvent(event);
    end

    obj:PushTable(events);
  end

  self.__manager:RemoveEventListenerByID(self:GetID());
end

---@param id string @A unique ID used to refer to the event listener when using the C_EventManager API.
---Can also be set when using the event manager's `CreateEventListenerWithID` method.
function EventListenerMixin:SetID(id)
  if (self.__id == id) then return end

  local exists = self.__manager:HasEventListener(id);

  if (exists) then
    obj:Error("An event listener with ID '%s' has already been registered with this event manager.", id);
  end

  self.__id = id;
  self.__manager:AddEventListener(self);
end

---If the event listener has not been assigned a custom unique ID, it will return the unique memory address of the handler object.
---@return string @Returns the unique ID used to refer to the event listener when using the EventManager API.
function EventListenerMixin:GetID()
  return self.__id;
end

---Used to enable or disable the event listener. When disabled, the event listener
---will not trigger its associated callback function even if the event is fired.
---@param enabled boolean @The new enabled state of the event listener.
function EventListenerMixin:SetEnabled(enabled)
  self.__enabled = enabled;
end

---Returns whether the event listener is enabled or disabled. When disabled, the event listener
---will not trigger its associated callback function even if the event is fired.
---@return boolean @The current enabled state of the event listener.
function EventListenerMixin:IsEnabled()
  return self.__enabled;
end

---If executeOnce is set to `true`, then the event listener object will be destroyed and
---removed from the event manager after its first execution. Some callback functions only need to be
---executed once. You can also call the `Destroy()` method on the event listener at any time to destroy it manually.
---@param executeOnce boolean @Represents whether the event manager should destroy the event listener after executing it once.
function EventListenerMixin:SetExecuteOnce(executeOnce)
  self.__executeOnce = executeOnce;
end

---Sets a custom list of callback arguments to be passed to the callback function each time it is triggered.
---These callback arguments will appear after the first two arguments (self, event),
---and before the event-specific arguments. Each time this method is called, it will replace previously specified custom
---callback arguments. Therefore, calling this method with no arguments will remove all of them. Note: If you call this
---method with only `nil` then `nil` will still be passed as a custom callback argument.
---@vararg any @A list of custom callback arguments to be passed to the callback function each time it is executed.
---@return MayronUI.EventListener
function EventListenerMixin:SetCallbackArgs(...)
  if (obj:IsTable(self.__args)) then
    obj:EmptyTable(self.__args);
  else
    self.__args = obj:PopTable();
  end

  self.__argsLength = select("#", ...); -- preserve trailing `nil` values
  for i = 1, self.__argsLength do
    self.__args[i] = (select(i, ...));
  end

  return self;
end

---@return number
function EventListenerMixin:GetTotalArguments()
  return self.__argsLength;
end

---@return boolean
function EventListenerMixin:HasArguments()
  return self.__argsLength > 0;
end

---@param index integer
---@return any
function EventListenerMixin:GetArgument(index)
  if (not self.__args) then
    return nil;
  end

  return self.__args[index];
end

---Register a Blizzard event for the event listener to listen out for. If enabled, the event listener
---will execute its callback function when the event fires.
---@param event string @The Blizzard event to register.
---@return MayronUI.EventListener
function EventListenerMixin:RegisterEvent(event)
  local success = pcall(function()
    ---@diagnostic disable-next-line: invisible
    self.__manager.__frame:RegisterEvent(event);
  end);

  if (success) then
    self.__events = self.__events or obj:PopTable();
    self.__events[event] = true;

  elseif (_G.MayronUI) then
    _G.MayronUI:LogDebug("Failed to register event ", event);
  end

  return self;
end

---A helper method that takes a variable argument list of Blizzard event names and calls `RegisterEvent` for each one.
---@vararg string @A variable argument list of Blizzard event names register.
---@return MayronUI.EventListener
function EventListenerMixin:RegisterEvents(...)
  for i = 1, select("#", ...) do
    self:RegisterEvent((select(i, ...)));
  end

  return self;
end

---Register a Blizzard unit event for the event listener to listen out for. If enabled, the event listener
---will execute its callback function when the event fires for one of the specified units.
---@param event string @The Blizzard unit event to register.
---@param unit1 string @A unitID to register with the unit event (e.g., "player").
---@param unit2 string @An optional 2nd unitID to register with the unit event (e.g., "target").
---@param unit3 string @An optional 3rd unitID to register with the unit event (e.g., "focus").
---@return MayronUI.EventListener
function EventListenerMixin:RegisterUnitEvent(event, unit1, unit2, unit3)
  local success = pcall(function()
    ---@diagnostic disable-next-line: invisible
    self.__manager.__frame:RegisterEvent(event);
  end);

  if (success) then
    self.__events = self.__events or obj:PopTable();
    self.__events[event] = obj:PopTable(unit1, unit2, unit3);
  elseif (_G.MayronUI) then
    _G.MayronUI:LogDebug("Failed to register event ", event);
  end

  return self;
end

---A helper method that takes a table of Blizzard event names and calls RegisterUnitEvent for each one with the provided unitIDs.
---@param events table @A table containing the Blizzard unit events to register.
---@param unit1 string @A unitID to register with the unit event (e.g., "player").
---@param unit2 string @An optional 2nd unitID to register with the unit event (e.g., "target").
---@param unit3 string @An optional 3rd unitID to register with the unit event (e.g., "focus").
---@param pushTable boolean @Optional boolean value to override the default "true" to avoid recycling the
---table passed to the events parameter. If not set to false, the table will be emptied and added to an
---internal stack for later use by the MayronObjects framework.
---@return MayronUI.EventListener
function EventListenerMixin:RegisterUnitEvents(events, unit1, unit2, unit3, pushTable)
  for _, event in ipairs(events) do
    self:RegisterUnitEvent(event, unit1, unit2, unit3);
  end

  if (pushTable) then
    obj:PushTable(events);
  end

  return self;
end

---Register a non-Blizzard, custom addon event for the event listener to listen out for. If enabled, the event listener
---will execute its callback function when the event manager fires the custom event using its `FireCustomEvent` method.
---@param customEvent string @The non-Blizzard, custom addon event to register.
---@return MayronUI.EventListener
function EventListenerMixin:RegisterCustomEvent(customEvent)
  self.__customEvents = self.__customEvents or obj:PopTable();
  self.__customEvents[customEvent] = true;
  return self;
end

---A helper method that takes a variable argument list of custom event names and calls RegisterCustomEvent for each one.
---@vararg string @A variable argument list of (non-Blizzard) custom addon events to register.
---@return MayronUI.EventListener
function EventListenerMixin:RegisterCustomEvents(...)
  for i = 1, select("#", ...) do
    self:RegisterCustomEvent((select(i, ...)));
  end

  return self;
end

---Unregister a Blizzard event to stop the event listener from triggering its callback function when the event is fired.
---@param event string @The Blizzard event to unregister.
function EventListenerMixin:UnregisterEvent(event)
  if (not obj:IsTable(self.__events) or not self.__events[event]) then return end
  self.__events[event] = nil;

  if (not next(self.__events)) then
    obj:PushTable(self.__events);
    self.__events = nil;
  end

  local total = self.__manager:GetNumEventListenersByEvent(event);
  if (total == 0) then
    ---@diagnostic disable-next-line: invisible
    self.__manager.__frame:UnregisterEvent(event);
  end
end

---@param customEvent string
function EventListenerMixin:HasRegisteredCustomEvent(customEvent)
  if (obj:IsTable(self.__customEvents)) then
    if (self.__customEvents[customEvent]) then
      return true;
    end
  end

  return false;
end

---@param event string
---@return boolean isRegistered, boolean? isUnitEvent
function EventListenerMixin:HasRegisteredEvent(event)
  if (obj:IsTable(self.__events)) then
    if (self.__events[event]) then

      local isUnitEvent = obj:IsTable(self.__events[event]);
      return true, isUnitEvent;
    end
  end

  return false, nil;
end

---@param event string
---@param unitID UnitId
---@return boolean
function EventListenerMixin:HasRegisteredUnitEvent(event, unitID)
  if (obj:IsTable(self.__events) and obj:IsTable(self.__events[event])) then
    local eventUnits = self.__events[event]--[[@as table]];
    for _, registeredUnitID in ipairs(eventUnits) do
      if (registeredUnitID == unitID) then
        return true;
      end
    end
  end

  return false;
end

---A helper method that takes a variable argument list of Blizzard event names and calls `UnregisterEvent` for each one.
---@vararg string @A variable argument list of Blizzard events to unregister.
function EventListenerMixin:UnregisterEvents(...)
  for i = 1, select("#", ...) do
    self:UnregisterEvent((select(i, ...)));
  end
end

---Unregister a (non-Blizzard) custom addon event to stop the event listener from triggering its callback function when
---the event manager fires the custom event using its `FireCustomEvent` method.
---@param customEvent string @The non-Blizzard, custom addon event to unregister.
function EventListenerMixin:UnregisterCustomEvent(customEvent)
  if (not obj:IsTable(self.__customEvents) or not self.__customEvents[customEvent]) then return end
  self.__customEvents[customEvent] = nil;

  if (not next(self.__customEvents)) then
    obj:PushTable(self.__customEvents);
    self.__customEvents = nil;
  end
end

---A helper method that takes a variable argument list of custom event names and calls `UnregisterCustomEvent` for each one.
---@vararg string @A variable argument list of (non-Blizzard) custom addon events to unregister.
function EventListenerMixin:UnregisterCustomEvents(...)
  for i = 1, select("#", ...) do
    self:UnregisterCustomEvent((select(i, ...)));
  end
end