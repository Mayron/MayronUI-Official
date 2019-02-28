-----------------------------------------------------------------
--
--  File: Stances.lua
--
--  Author: Alex <Nexiuz> Elderson
--
--  Description:
--
--
-----------------------------------------------------------------


local LibAura = LibStub("LibAura-1.0");

local Major, Minor = "Stances-1.0", 0;
local Module = LibAura:NewModule(Major, Minor);

if not Module then return; end -- No upgrade needed.

-- Make sure that we dont have old unit/types if we upgrade.
LibAura:UnregisterModuleSource(Module, nil, nil);

-- Register the unit/types.
LibAura:RegisterModuleSource(Module, "player", "STANCE");


-----------------------------------------------------------------
-- Function Enable
-----------------------------------------------------------------
function Module:Enable()

  -- Internal db used for storing auras.
  self.StanceAura = {
    Id = "PlayerSTANCE",
    StanceId = 0, -- Used internaly to track stance id.
    Active = false, -- Used internaly to see if its an active stance.
    Type = "STANCE",
    Index = 1,
    Unit = "player",
    Classification = "None",
    CasterUnit = "player",
    CasterName = UnitName("player"),
    IsStealable = false,
    IsCancelable = false,
    IsDispellable = false,
    Count = 0,
    ItemId = 0,
    ExpirationTime = 0,
    CreationTime = 0
  };

end


-----------------------------------------------------------------
-- Function Disable
-----------------------------------------------------------------
function Module:Disable()

  self.StanceAura = nil;

end


-----------------------------------------------------------------
-- Function ActivateSource
-----------------------------------------------------------------
function Module:ActivateSource(Unit, Type)
  
  LibAura:RegisterEvent("UPDATE_SHAPESHIFT_FORM", self, self.Update);
  LibAura:RegisterEvent("UPDATE_SHAPESHIFT_FORMS", self, self.Update);
  self:Update();
  
end


-----------------------------------------------------------------
-- Function DeactivateSource
-----------------------------------------------------------------
function Module:DeactivateSource(Unit, Type)
  
  if self.StanceAura.Active == true then
    LibAura:FireAuraOld(self.StanceAura);
    self.StanceAura.Active = false;
  end
  
  self.StanceAura.StanceId = 0;
  
  LibAura:UnregisterEvent("UPDATE_SHAPESHIFT_FORM", self, self.Update);
  LibAura:UnregisterEvent("UPDATE_SHAPESHIFT_FORMS", self, self.Update);

end


-----------------------------------------------------------------
-- Function GetAuras
-----------------------------------------------------------------
function Module:GetAuras(Unit, Type)
  
  if self.StanceAura.Active == true then
    return {self.StanceAura};
  else
    return {};
  end

end


-----------------------------------------------------------------
-- Function Update
-----------------------------------------------------------------
function Module:Update()

  local Index = GetShapeshiftForm();
  
  if Index == 0 then
    
    if self.StanceAura.Active == true then
      LibAura:FireAuraOld(self.StanceAura);
      self.StanceAura.Active = false;
    end
    
    return;
  
  end
  
  local Icon, Name, IsActive, IsCastable, SpellId = GetShapeshiftFormInfo(Index);
  
  if SpellId ~= 0 then
    local _;
    _, _, Icon = GetSpellInfo(SpellId);
  end
  
  if self.StanceAura.Active == true then
    LibAura:FireAuraOld(self.StanceAura);
  end
  
  self.StanceAura.Active = IsActive;
  self.StanceAura.Icon = Icon;
  self.StanceAura.Name = Name;
  self.StanceAura.SpellId = SpellId;
  self.StanceAura.StanceId = Index;
  
  if IsActive == true then
  
    LibAura:FireAuraNew(self.StanceAura);

  end

end
