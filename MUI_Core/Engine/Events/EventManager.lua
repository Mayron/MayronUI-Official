-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;

local tk, _, _, _, obj = MayronUI:GetCoreComponents();

---@class MayronUI.EventManager
---@field private __listeners table<string, MayronUI.EventListener>
---@field private __frame Frame
local EventManagerMixin = {};

local select, pairs = _G.select, _G.pairs;
local unpack, CreateAndInitFromMixin = _G.unpack, _G.CreateAndInitFromMixin;

---@param listener MayronUI.EventListener
---@param event string?
---@param ... any
local function RunEvent(listener, event, ...)
  if (not listener:IsEnabled()) then return end
  local args = obj:PopTable();

  local totalArgs = listener:GetTotalArguments();

  if (totalArgs > 0) then
    for i = 1, totalArgs do
      args[i] = listener:GetArgument(i);
    end
  end

  for i = 1, select("#", ...) do
    args[i + totalArgs] = (select(i, ...));
  end

  -- execute callback function here:
  MayronUI:LogInfo("Running Event ", event);

  ---@diagnostic disable-next-line: invisible
  listener.__callback(listener, event, unpack(args, 1, (totalArgs + select("#", ...))));
  obj:PushTable(args);

  ---@diagnostic disable-next-line: invisible
  if (listener.__executeOnce) then
    listener:Destroy();
  end
end

-----------------------------------------------------------
--- EventManager API:
-----------------------------------------------------------
function EventManagerMixin:Init()
  self.__frame = tk:CreateFrame("Frame");
  self.__listeners = obj:PopTable();

  self.__frame:SetScript("OnEvent", function(_, event, unitID, ...)
    local listeners = obj:PopTable()--[[ @as MayronUI.EventListener[] ]];

    -- need a copy incase it is destroyed during execution
    for _, listener in pairs(self.__listeners) do
      listeners[#listeners + 1] = listener;
    end

    for _, listener in pairs(listeners) do
      if (listener:IsEnabled()) then
        local isRegistered, isUnitEvent = listener:HasRegisteredEvent(event);

        if (isUnitEvent) then
          if (listener:HasRegisteredUnitEvent(event, unitID)) then
            RunEvent(listener, event, unitID, ...);
          end
        elseif (isRegistered) then
          RunEvent(listener, event, unitID, ...);
        end
      end
    end

    obj:PushTable(listeners);
  end);
end

---Creates an EventListener that calls the provided callback function when a registered event is fired (while the event listener is enabled).
---@param callback function # A callback function to execute when a registered event is fired (while the event listener is enabled).
---@return MayronUI.EventListener # The event listener object used to register/unregister events, set custom arguments and more.
function EventManagerMixin:CreateEventListener(callback)
  local mixin = self.EventListenerMixin--[[@as MayronUI.EventListener]]
  local listener = CreateAndInitFromMixin(mixin, callback, self);
  return listener;
end

---Creates an EventListener with an ID that calls the provided callback function when a registered event is fired (while the event listener is enabled).
---@param id string @The ID to reference the event listener object using the EventManager API.
---@param callback function @A callback function to execute when a registered event is fired (while the event listener is enabled).
---@return MayronUI.EventListener @The event listener object used to register/unregister events, set custom arguments and more.
function EventManagerMixin:CreateEventListenerWithID(id, callback)
  local listener = self:CreateEventListener(callback);
  listener:SetID(id);
  return listener;
end

---@param id string @The event listener's unique ID.
---@return MayronUI.EventListener @If an event listener with the provided ID is registered with the event manager, it will be returned.
function EventManagerMixin:GetEventListenerByID(id)
  return self.__listeners[id];
end

---Returns all event listeners created from the event manager that are also registered with the provided Blizzard event.
---These event listeners will trigger their associated callback functions when this Blizzard event is fired.
---@param event string @The Blizzard event name to check for.
---@return ... @A variable list of EventListener objects who are registered with the provided Blizzard event.
function EventManagerMixin:GetEventListenersByEvent(event)
  local listeners = obj:PopTable();

  for _, listener in pairs(self.__listeners) do
    if (listener:HasRegisteredEvent(event)) then
      listeners[#listeners + 1] = listener;
    end
  end

  return listeners;
end

---Returns all event listeners created from the event manager that are also registered with the
---provided (non-BLizzard) custom addon event. These event listeners will trigger their associated callback
---functions when the custom event is fired using the event manager's `FireCustomEvent` method.
---@param customEvent string @The (non-BLizzard) custom addon event name to check for.
---@return ... @A variable list of EventListener objects who are registered with the provided custom event.
function EventManagerMixin:GetEventListenersByCustomEvent(customEvent)
  local total = 0;

  for _, listener in pairs(self.__listeners) do
    if (listener:HasRegisteredCustomEvent(customEvent)) then
      total = total + 1;
    end
  end

  return total;
end

---A helper function to return the total number of event listener objects that are also registered
---with the provided Blizzard event, instead of a table containing all event listener objects using `GetEventListenersByEvent`.
---@param event string @The Blizzard event name to check for.
---@return number @The total number of event listeners listing out for the specified event.
function EventManagerMixin:GetNumEventListenersByEvent(event)
  local total = 0;

  for _, listener in pairs(self.__listeners) do
    if (listener:HasRegisteredEvent(event)) then
      total = total + 1;
    end
  end

  return total;
end

---Manually executes the callback function associated with the event listener whose ID matches the provided ID.
---The callback function will receive a `nil` argument value for its event name parameter as no event was naturally fired.
---@param id string @The event listener's ID.
---@vararg any @Accepts a list of arguments to pass to the callback function being executed, in addition to the
---custom args assigned to the event listener object using `SetCallbackArgs`.
function EventManagerMixin:TriggerEventListenerByID(id, ...)
  local listener = self.__listeners[id];

  if (listener == nil) then
    return
  end

  self:TriggerEventListener(listener, ...);
end

---Manually executes the callback function associated with the event listener.
---The callback function will receive a `nil` argument value for its event name parameter as no event was naturally fired.
---@param listener MayronUI.EventListener @The event listener object.
---@vararg any @Accepts a list of arguments to pass to the callback function being executed, in addition to the
---custom args assigned to the event listener object using `SetCallbackArgs`.
function EventManagerMixin:TriggerEventListener(listener, ...)
  if (listener:IsEnabled()) then
    RunEvent(listener, nil, ...);
  end
end

---Fires a custom event to notify all event listeners registered with that custom event.
---This method cannot be used to fire Blizzard in-game events as this could cause unexpected bugs
---for other code using this event manager.
---@param customEvent string @The name of the custom event to fire.
---@vararg any @Accepts a list of arguments to pass to the callback function being executed, in addition to the
---custom args assigned to the event listener object using `SetCallbackArgs`.
function EventManagerMixin:FireCustomEvent(customEvent, ...)
  for _, listener in pairs(self.__listeners) do
    if (listener:IsEnabled() and listener:HasRegisteredCustomEvent(customEvent)) then
      RunEvent(listener, customEvent, ...);
    end
  end
end

---Destroys all event listeners and removes them from the event manager, whose IDs match those found in the list of provided arguments.
---Destroyed event listeners will not trigger their callback functions if the event is fired and can never be enabled.
---@vararg string @A variable argument list of IDs for referencing event listeners to be destroyed.
function EventManagerMixin:DestroyEventListeners(...)
  for i = 1, select("#", ...) do
    local id = (select(i, ...));
    local listener = self.__listeners[id];

    if (listener) then
      listener:Destroy();
    end
  end
end

---Disables all event listeners whose IDs match those found in the list of provided arguments.
---Disabled event listeners will not trigger their callback functions if the event is fired.
---@vararg string @A variable argument list of IDs for referencing event listeners to be disabled.
function EventManagerMixin:DisableEventListeners(...)
  for i = 1, select("#", ...) do
    local id = (select(i, ...));
    local listener = self.__listeners[id];

    if (listener) then
      listener:SetEnabled(false);
    end
  end
end

---Enables all event listeners whose IDs match those found in the list of provided arguments.
---Enables event listeners will trigger their callback functions if the event is fired.
---@vararg string @A variable argument list of IDs for referencing event listeners to be enabled.
function EventManagerMixin:EnableEventListeners(...)
  for i = 1, select("#", ...) do
    local id = (select(i, ...));
    local listener = self.__listeners[id];

    if (listener) then
      listener:SetEnabled(true);
    end
  end
end

---@param listenerID string
function EventManagerMixin:RemoveEventListenerByID(listenerID)
  self.__listeners[listenerID] = nil;
end

---@param listener MayronUI.EventListener
function EventManagerMixin:AddEventListener(listener)
  self.__listeners[listener:GetID()] = listener;
end

---@param listenerID string
---@return boolean
function EventManagerMixin:HasEventListener(listenerID)
  for _, listener in pairs(self.__listeners) do
    if (listener:GetID() == listenerID) then
      return true;
    end
  end

  return false;
end

MayronUI:AddComponent("EventManager", CreateAndInitFromMixin(EventManagerMixin));