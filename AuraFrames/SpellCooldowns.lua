local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: LibStub

local PlayerClass = select(2, UnitClass("player"));

-----------------------------------------------------------------
-- Function SetSpellCooldownList
-----------------------------------------------------------------
function AuraFrames:SetSpellCooldownList()

  if not self.db.global.SpellCooldowns then
    self.db.global.SpellCooldowns = {};
  end
  
  if not self.db.global.SpellCooldowns[PlayerClass] then
    self.db.global.SpellCooldowns[PlayerClass] = {};
  end

  LibStub("LibAura-1.0"):GetModule("SpellCooldowns-1.0"):SetAdditionalSpellCooldownList(self.db.global.SpellCooldowns[PlayerClass]);

end
