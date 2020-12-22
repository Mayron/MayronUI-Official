-- luacheck: ignore self 143 631
local obj = _G.MayronObjects:GetFramework(); ---@type MayronObjects
if (obj:Import("Pkg-MayronEvents", true)) then return end

---@class PkgMayronEvents : Package
local PkgMayronEvents = obj:CreatePackage("Pkg-MayronEvents");
obj:Export(PkgMayronEvents);

---@class EventManager
local C_EventManager = PkgMayronEvents:CreateClass("EventManager");
C_EventManager.Static:AddFriendClass("EventListener");

local select, pairs, ipairs, CreateFrame = _G.select, _G.pairs, _G.ipairs, _G.CreateFrame;

-----------------------------------------------------------
--- C_EventManager API:
-----------------------------------------------------------

---constructor - you create an event manager using `local manager = C_EventManager()`.
---Do not call `__Construct` directly!
function C_EventManager:__Construct(data)
  data.frame = CreateFrame("Frame");
  data.listeners = obj:PopTable();

  data.frame:SetScript("OnEvent", function(_, event, unitID, ...)
    local listeners = obj:PopTable();

    -- need a copy incase it is destroyed during execution
    for _, listener in pairs(data.listeners) do
      listeners[#listeners + 1] = listener;
    end

    for _, listener in pairs(listeners) do
      local listenerData = data:GetFriendData(listener);

      if (listenerData.enabled and obj:IsTable(listenerData.events) and listenerData.events[event]) then
        if (obj:IsTable(listenerData.events[event])) then
          -- it's a unit event
          for _, registeredUnitID in ipairs(listenerData.events[event]) do
            if (registeredUnitID == unitID) then
              listenerData:Call("Run", event, unitID, ...);
            end
          end
        else
          listenerData:Call("Run", event, unitID, ...);
        end
      end
    end

    obj:PushTable(listeners);
  end)
end

PkgMayronEvents:DefineParams("function");
PkgMayronEvents:DefineReturns("EventListener");
---Creates an EventListener that calls the provided callback function when a registered event is fired (while the event listener is enabled).
---@param callback function @A callback function to execute when a registered event is fired (while the event listener is enabled).
---@return EventListener @The event listener object used to register/unregister events, set custom arguments and more.
function C_EventManager:CreateEventListener(_, callback)
  local C_EventListener = PkgMayronEvents:Get("EventListener");
  return C_EventListener(callback, self);
end

PkgMayronEvents:DefineParams("string", "function");
PkgMayronEvents:DefineReturns("EventListener");
---Creates an EventListener with an ID that calls the provided callback function when a registered event is fired (while the event listener is enabled).
---@param id string @The ID to reference the event listener object using the C_EventManager API.
---@param callback function @A callback function to execute when a registered event is fired (while the event listener is enabled).
---@return EventListener @The event listener object used to register/unregister events, set custom arguments and more.
function C_EventManager:CreateEventListenerWithID(_, id, callback)
  local C_EventListener = PkgMayronEvents:Get("EventListener");
  local eventListener = C_EventListener(callback, self); ---@type EventListener
  eventListener:SetID(id);
  return eventListener;
end

PkgMayronEvents:DefineParams("string");
PkgMayronEvents:DefineReturns("?EventListener");
---@param id string @The event listener's unique ID.
---@return EventListener @If an event listener with the provided ID is registered with the event manager, it will be returned.
function C_EventManager:GetEventListenerByID(data, id)
  return data.listeners[id];
end

PkgMayronEvents:DefineParams("string");
PkgMayronEvents:DefineReturns("table");
---Returns all event listeners created from the event manager that are also registered with the provided Blizzard event.
---These event listeners will trigger their associated callback functions when this Blizzard event is fired.
---@param event string @The Blizzard event name to check for.
---@return ... @A variable list of EventListener objects who are registered with the provided Blizzard event.
function C_EventManager:GetEventListenersByEvent(data, event)
  local listeners = obj:PopTable();

  for _, listener in pairs(data.listeners) do
    local listenerData = data:GetFriendData(listener);

    if (obj:IsTable(listenerData.events) and listenerData.events[event]) then
      listeners[#listeners + 1] = listener;
    end
  end

  return listeners;
end

PkgMayronEvents:DefineParams("string");
PkgMayronEvents:DefineReturns("table");
---Returns all event listeners created from the event manager that are also registered with the
---provided (non-BLizzard) custom addon event. These event listeners will trigger their associated callback
---functions when the custom event is fired using the event manager's `FireCustomEvent` method.
---@param event string @The (non-BLizzard) custom addon event name to check for.
---@return ... @A variable list of EventListener objects who are registered with the provided custom event.
function C_EventManager:GetEventListenersByCustomEvent(data, customEvent)
  local listeners = obj:PopTable();

  for _, listener in pairs(data.listeners) do
    local listenerData = data:GetFriendData(listener);

    if (obj:IsTable(listenerData.customEvents) and listenerData.customEvents[customEvent]) then
      listeners[#listeners + 1] = listener;
    end
  end

  return listeners;
end

PkgMayronEvents:DefineParams("string");
PkgMayronEvents:DefineReturns("number");
---A helper function to return the total number of event listener objects that are also registered
---with the provided Blizzard event, instead of a table containing all event listener objects using `GetEventListenersByEvent`.
---@param event string @The Blizzard event name to check for.
---@return number @The total number of event listeners listing out for the specified event.
function C_EventManager:GetNumEventListenersByEvent(_, event)
  local listeners = self:GetEventListenersByEvent(event);
  local total = #listeners;
  obj:PushTable(listeners);
  return total;
end

PkgMayronEvents:DefineParams("string");
PkgMayronEvents:DefineReturns("number");
---A helper function to return the total number of event listener objects that are also registered
---with the provided (non-Blizzard) custom addon event, instead of a table containing all event
---listener objects using `GetEventListenersByCustomEvent`.
---@param event string @The (non-BLizzard) custom addon event name to check for.
---@return number @The total number of event listeners listing out for the specified custom event.
function C_EventManager:GetNumEventListenersByCustomEvent(_, customEvent)
  local listeners = self:GetEventListenersByCustomEvent(customEvent);
  local total = #listeners;
  obj:PushTable(listeners);
  return total;
end

PkgMayronEvents:DefineParams("string");
---Manually executes the callback function associated with the event listener whose ID matches the provided ID.
---The callback function will receive a `nil` argument value for its event name parameter as no event was naturally fired.
---@param id string @The event listener's ID.
---@vararg any @Accepts a list of arguments to pass to the callback function being executed, in addition to the
---custom args assigned to the event listener object using `SetCallbackArgs`.
function C_EventManager:TriggerEventListenerByID(data, id, ...)
  local listener = data.listeners[id];

  if (listener == nil) then
    obj:Error("No event listener with ID '%s' has been registered with this event manager", id);
    return
  end

  self:TriggerEventListener(listener, ...);
end

PkgMayronEvents:DefineParams("EventListener");
---Manually executes the callback function associated with the event listener.
---The callback function will receive a `nil` argument value for its event name parameter as no event was naturally fired.
---@param listener EventListener @The event listener object.
---@vararg any @Accepts a list of arguments to pass to the callback function being executed, in addition to the
---custom args assigned to the event listener object using `SetCallbackArgs`.
function C_EventManager:TriggerEventListener(data, listener, ...)
  local listenerData = data:GetFriendData(listener);

  if (listenerData.enabled) then
    listenerData:Call("Run", nil, ...);
  end
end

PkgMayronEvents:DefineParams("string");
---Fires a custom event to notify all event listeners registered with that custom event.
---This method cannot be used to fire Blizzard in-game events as this could cause unexpected bugs
---for other code using this event manager.
---@param customEvent string @The name of the custom event to fire.
---@vararg any @Accepts a list of arguments to pass to the callback function being executed, in addition to the
---custom args assigned to the event listener object using `SetCallbackArgs`.
function C_EventManager:FireCustomEvent(data, customEvent, ...)
  for _, listener in pairs(data.listeners) do
    local listenerData = data:GetFriendData(listener);

    if (listenerData.enabled and obj:IsTable(listenerData.customEvents) and listenerData.customEvents[customEvent]) then
      listenerData:Call("Run", customEvent, ...);
    end
  end
end

PkgMayronEvents:DefineParams("string", "...string");
---Destroys all event listeners and removes them from the event manager, whose IDs match those found in the list of provided arguments.
---Destroyed event listeners will not trigger their callback functions if the event is fired and can never be enabled.
---@vararg string @A variable argument list of IDs for referencing event listeners to be destroyed.
function C_EventManager:DestroyEventListeners(data, ...)
  for i = 1, select("#", ...) do
    local id = (select(i, ...));
    local listener = data.listeners[id];

    if (listener) then
      listener:Destroy();
    end
  end
end

PkgMayronEvents:DefineParams("string", "...string");
---Disables all event listeners whose IDs match those found in the list of provided arguments.
---Disabled event listeners will not trigger their callback functions if the event is fired.
---@vararg string @A variable argument list of IDs for referencing event listeners to be disabled.
function C_EventManager:DisableEventListeners(data, ...)
  for i = 1, select("#", ...) do
    local id = (select(i, ...));
    local listener = data.listeners[id];

    if (listener) then
      listener:SetEnabled(false);
    end
  end
end

PkgMayronEvents:DefineParams("string", "...string");
---Enables all event listeners whose IDs match those found in the list of provided arguments.
---Enables event listeners will trigger their callback functions if the event is fired.
---@vararg string @A variable argument list of IDs for referencing event listeners to be enabled.
function C_EventManager:EnableEventListeners(data, ...)
  for i = 1, select("#", ...) do
    local id = (select(i, ...));
    local listener = data.listeners[id];

    if (listener) then
      listener:SetEnabled(true);
    end
  end
end