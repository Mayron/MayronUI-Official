-----------------------------------------------------------------
--
--  File: Prototype.lua
--
--  Author: Alex <Nexiuz> Elderson
--
--  Description:
--
--
--  Todo:
--
--
-----------------------------------------------------------------


local MAJOR, MINOR = "LibAura-1.0", 1;
local LibAura, OldMinor = LibStub(MAJOR);

-- We  bail out if the libary is having a higher minor then we are.
if OldMinor > MINOR then return; end

-- Import used global references into the local namespace.
local type = type;

LibAura.Prototype = LibAura.Prototype or {};


-----------------------------------------------------------------
-- Function RegisterEvent
-----------------------------------------------------------------
function LibAura.Prototype:RegisterEvent(Event, Function)

  if type(Function) == "function" then
    LibAura:RegisterEvent(Event, self, Function);
  else
    LibAura:RegisterEvent(Event, self, self[Function]);
  end

end


-----------------------------------------------------------------
-- Function UnregisterEvent
-----------------------------------------------------------------
function LibAura.Prototype:UnregisterEvent(Event, Function)

  if type(Function) == "function" then
    LibAura:UnregisterEvent(Event, self, Function);
  else
    LibAura:UnregisterEvent(Event, self, self[Function]);
  end

end


