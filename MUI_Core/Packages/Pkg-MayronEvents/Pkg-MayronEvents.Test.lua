if (true) then return end -- remove this to run tests

-- luacheck: ignore self 143 631
local obj = _G.MayronObjects:GetFramework(); ---@type MayronObjects
local C_EventManager = obj:Import("Pkg-MayronEvents.EventManager");

local eventManager = C_EventManager(); ---@type EventManager

local listener = eventManager:CreateEventListener(function(self, event, ...)
  if (event == "PLAYER_ENTERING_WORLD") then
    print("END OF TESTS");
  else
    print(event, ...)
  end
end);

listener:RegisterEvent("PLAYER_ENTERING_WORLD");
listener:RegisterCustomEvent("SOME_CUSTOM_EVENT");

local executed = 0;
local triggerUsedNilEvent = false;
local firedCustomEventCount = 0;
local argsRemoved = false;
local listener2 = eventManager:CreateEventListenerWithID("MyEventListener", function(self, event, ...)
  executed = executed + 1;
  firedCustomEventCount = firedCustomEventCount + 1;

  if (executed == 1) then
    assert(event == "MY_CUSTOM_EVENT", string.format("MY_CUSTOM_EVENT expected, got %s", tostring(event)))
  end

  if (not argsRemoved) then
    assert((select(1, ...)) == "arg1");
    assert((select(2, ...)) == "arg2");
    assert((select(3, ...)) == nil);
    assert((select(4, ...)) == "arg3");

    -- explicit nil values should be passed to callback:
    assert((select(5, ...)) == nil);
    assert((select(6, ...)) == nil);
  end

  if (executed == 2) then
    assert(event == nil, "Should be nil if using TriggerEventListenerByID")
    assert((select(7, ...)) == "TriggerEventListenerByID");
    triggerUsedNilEvent = true;
  end
end);

---TEST 1: Test custom callback arguments
listener2:RegisterEvent("PLAYER_ENTERING_WORLD");
listener2:RegisterCustomEvent("MY_CUSTOM_EVENT");
listener2:SetCallbackArgs("arg1", "arg2", nil, "arg3", nil, nil);

eventManager:FireCustomEvent("MY_CUSTOM_EVENT", "FireCustomEvent");
eventManager:TriggerEventListenerByID("MyEventListener", "TriggerEventListenerByID");
assert(triggerUsedNilEvent, "Trigger did not pass `nil` to event parameter")

---TEST 2: When disabled, should not execute:
firedCustomEventCount = 0;
eventManager:DisableEventListeners("MyEventListener");
eventManager:FireCustomEvent("MY_CUSTOM_EVENT");
eventManager:TriggerEventListenerByID("MyEventListener");

assert(firedCustomEventCount == 0, "Should not have incremented when listener is disabled");

-- TEST 3: When disabled, should still return listener and IsEnabled should be false
local returnedListener = eventManager:GetEventListenerByID("MyEventListener")
assert(returnedListener == listener2, "Event listener returned, even if disabled, should be as expected");
assert(listener2:IsEnabled() == false, "listener2 should be disabled");

---TEST 4: When enabled, should execute event
eventManager:EnableEventListeners("MyEventListener");
assert(listener2:IsEnabled() == true, "listener2 should be enabled");

-- should execute:
listener2:SetCallbackArgs(); -- lets also remove args
argsRemoved = true;

eventManager:FireCustomEvent("MY_CUSTOM_EVENT");
eventManager:TriggerEventListenerByID("MyEventListener");
assert(firedCustomEventCount == 2, "Should have incremented when listener is enabled");

---TEST 5: Get total even listeners, blizzard events, and custom events
listener2:RegisterCustomEvents("ANOTHER_CUSTOM_EVENT_1", "ANOTHER_CUSTOM_EVENT_2", "SOME_CUSTOM_EVENT");

local totalListenersTbl = eventManager:GetEventListenersByEvent("PLAYER_ENTERING_WORLD");
assert(#totalListenersTbl == 2, "There should be 2 event listeners for PLAYER_ENTERING_WORLD");

local totalListeners = eventManager:GetNumEventListenersByEvent("PLAYER_ENTERING_WORLD");
assert(totalListeners == 2, "There should be 2 event listeners for PLAYER_ENTERING_WORLD");

totalListenersTbl = eventManager:GetEventListenersByCustomEvent("SOME_CUSTOM_EVENT");
assert(#totalListenersTbl == 2, "There should be 2 event listeners for SOME_CUSTOM_EVENT");

totalListeners = eventManager:GetNumEventListenersByCustomEvent("SOME_CUSTOM_EVENT");
assert(totalListeners == 2, "There should be 2 event listeners for SOME_CUSTOM_EVENT");

local blizzardEventsTbl = listener2:GetRegisteredEvents();
assert(#blizzardEventsTbl == 1, "listener2 should be registered with 2 blizzard events");

local blizzardEvents = listener2:GetNumRegisteredEvents();
assert(blizzardEvents == 1, "listener2 should be registered with 2 blizzard events");

local customEventsTbl = listener2:GetRegisteredCustomEvents();
assert(#customEventsTbl == 4, "listener2 should be registered with 4 custom events");

local customEvents = listener2:GetNumRegisteredCustomEvents();
assert(customEvents == 4, "listener2 should be registered with 4 custom events");

---TEST 6: Destroying event listener2 should perminently disable it
listener2:Destroy();

totalListeners = eventManager:GetNumEventListenersByEvent("PLAYER_ENTERING_WORLD");
assert(totalListeners == 1, "There should be 1 event listener for PLAYER_ENTERING_WORLD");

customEvents = eventManager:GetNumEventListenersByCustomEvent("SOME_CUSTOM_EVENT");
assert(customEvents == 1, "There should be 1 event listener for SOME_CUSTOM_EVENT");

---TEST 7: SetExecuteOnce should destroy listener after first execution
---Should be able to reuse ID `MyEventListener` because the previous one was destroyed
local listener3 = eventManager:CreateEventListenerWithID("MyEventListener", function(self)
  firedCustomEventCount = firedCustomEventCount + 1;
  assert(self.IsDestroyed == nil, "Object should not already be marked as destroyed");
end);

listener3:RegisterCustomEvent("MY_CUSTOM_EVENT");
listener3:SetExecuteOnce(true);

totalListeners = eventManager:GetNumEventListenersByCustomEvent("MY_CUSTOM_EVENT");
assert(totalListeners == 1, "Because listener2 was destroyed, this should be 1");

firedCustomEventCount = 0;
eventManager:FireCustomEvent("MY_CUSTOM_EVENT");
assert(firedCustomEventCount == 1, "Because listener2 was destroyed, this should be 1");

assert(listener3.IsDestroyed == true, "listener3 should be destroyed");

totalListeners = eventManager:GetNumEventListenersByCustomEvent("MY_CUSTOM_EVENT");
assert(totalListeners == 0, "Because listener3 was destroyed, this should be 0");

firedCustomEventCount = 0;
eventManager:FireCustomEvent("MY_CUSTOM_EVENT");
assert(firedCustomEventCount == 0, "Because listener3 was destroyed, this should be 0");

---TEST 8: Manual tests for unit events (need to cast something ingame):
listener:RegisterUnitEvent("UNIT_SPELLCAST_START", "target", "focus", "player");
listener:RegisterUnitEvent("UNIT_SPELLCAST_START", "target", "player");
listener:RegisterUnitEvent("UNIT_SPELLCAST_START", "player"); -- this overrides the previous events above (as expected)

local listener4 = eventManager:CreateEventListener(function(self, ...)
  print("From listener4: ", ...);
end);

-- this runs with listener as expected:
listener4:RegisterUnitEvent("UNIT_SPELLCAST_START", "target", "focus", "player");

totalListeners = eventManager:GetNumEventListenersByEvent("UNIT_SPELLCAST_START");
assert(totalListeners == 2);

-- this should not affect listener4 (as expected):
listener:UnregisterEvent("UNIT_SPELLCAST_START");

totalListeners = eventManager:GetNumEventListenersByEvent("UNIT_SPELLCAST_START");
assert(totalListeners == 1);

listener4:UnregisterEvent("UNIT_SPELLCAST_START");

totalListeners = eventManager:GetNumEventListenersByEvent("UNIT_SPELLCAST_START");
assert(totalListeners == 0);
