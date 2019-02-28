local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: LibStub

local PlayerClass = select(2, UnitClass("player"));

-----------------------------------------------------------------
-- Function SetInternalCooldownList
-----------------------------------------------------------------
function AuraFrames:SetInternalCooldownList()

  if not self.db.global.InternalCooldowns then
    self.db.global.InternalCooldowns = {};
  end
  
  LibStub("LibAura-1.0"):GetModule("InternalCooldowns-1.0"):SetInternalCooldownList(self.db.global.InternalCooldowns);

end
