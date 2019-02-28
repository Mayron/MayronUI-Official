-- AceGUI-3.0-Spell-EditBox is still using a old Blizzard API :(
-- Lets make it available.

if not GetSpellName then

  function GetSpellName(SpellId, Info)
    
    return GetSpellBookItemName(SpellId, Info);
    
  end

end
