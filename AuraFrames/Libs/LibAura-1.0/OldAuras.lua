-----------------------------------------------------------------
--
--  File: OldAuras.lua
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

-- Support for old auras is currently disabled
if true then return; end;

local LibAura = LibStub("LibAura-1.0");

local Major, Minor = "OldAuras-1.0", 0;
local Module = LibAura:NewModule(Major, Minor);

if not Module then return; end -- No upgrade needed.

-- Import used global references into the local namespace.
local pairs, ipairs, next, tinsert, tremove, GetTime = pairs, ipairs, next, tinsert, tremove, GetTime;
local sub = string.sub;

local AuraPool =  {};

-- The time an old aura is availible.
local TimeToLive = 30;


-- Contains all the auras.
Module.db = Module.db or {};


-- Make sure that we dont have old unit/types if we upgrade.
LibAura:UnregisterModuleSource(Module, nil, nil);

-- Register the test unit/types.
-- Our source is all the other sources. We are going to hack here a bit.
-- We read out all the current registered sources and we place a hook on
-- the register/deregister source functions to keep track of everything.
for Unit, _ in pairs(LibAura.db) do
  for Type, _ in pairs(LibAura.db[Unit]) do
    if not tContains(LibAura.db[Unit][Type].Modules, Module) then
      LibAura:RegisterModuleSource(Module, Unit, Type.."OLD");
    end
  end
end

-----------------------------------------------------------------
-- Function ModuleSourceCreated
-----------------------------------------------------------------
function Module:ModuleSourceCreated(Unit, Type, Requester)

  if Requester == Module then
    return;
  end
  
  LibAura:RegisterModuleSource(Module, Unit, Type.."OLD");

end


-----------------------------------------------------------------
-- Function ModuleSourceDestroyed
-----------------------------------------------------------------
function Module:ModuleSourceDestroyed(Unit, Type, Requester)
  
  if Requester == Module then
    return;
  end
  
  LibAura:UnregisterModuleSource(Module, Unit, Type.."OLD");

end


-- Register events.
Module:RegisterEvent("LIBAURA_MODULE_SOURCE_CREATED", Module.ModuleSourceCreated);
Module:RegisterEvent("LIBAURA_MODULE_SOURCE_DESTROYED", Module.ModuleSourceDestroyed);


-----------------------------------------------------------------
-- Function Enable
-----------------------------------------------------------------
function Module:Enable()
  
  self:RegisterEvent("LIBAURA_UPDATE", self.Update);

end



-----------------------------------------------------------------
-- Function Disable
-----------------------------------------------------------------
function Module:Disable()

  self.db = {};
  
  self:UnregisterEvent("LIBAURA_UPDATE", self.Update);

end

-----------------------------------------------------------------
-- Function SetMinTimeToLive
-----------------------------------------------------------------
function Module:SetMinTimeToLive(MinTimeToLive)

  if TimeToLive < MinTimeToLive then
    TimeToLive = MinTimeToLive;
  end

end


-----------------------------------------------------------------
-- Function ActivateSource
-----------------------------------------------------------------
function Module:ActivateSource(Unit, Type)

  if not self.db[Unit] then
    self.db[Unit] = {};
  end

  self.db[Unit][Type] = {};
  
  LibAura:RegisterObjectSource(self, Unit, sub(Type, 1, -4));
  
end

-----------------------------------------------------------------
-- Function DeactivateSource
-----------------------------------------------------------------
function Module:DeactivateSource(Unit, Type)

  LibAura:UnregisterObjectSource(self, Unit, sub(Type, 1, -3));
  
  if not self.db[Unit] then
    return;
  end
  
  if not self.db[Unit][Type] then
    return;
  end
  
  for _, Aura in ipairs(self.db[Unit][Type]) do
    LibAura:FireAuraOld(Aura);
  end
  
  self.db[Unit][Type] = nil;

  if next(self.db[Unit]) == nil then
  
    self.db[Unit] = nil;
  
  end

end

-----------------------------------------------------------------
-- Function GetAuras
-----------------------------------------------------------------
function Module:GetAuras(Unit, Type)

  if not self.db[Unit] then
    return {};
  end
  
  if not self.db[Unit][Type] then
    return {};
  end
  
  return self.db[Unit][Type];

end


-----------------------------------------------------------------
-- Function AuraNew
-----------------------------------------------------------------
function Module:AuraNew(Aura)

end


-----------------------------------------------------------------
-- Function AuraOld
-----------------------------------------------------------------
function Module:AuraOld(Aura)

  if not self.db[Aura.Unit] or not self.db[Aura.Unit][Aura.Type] then
    return;
  end

  local NewAura = tremove(AuraPool) or {Index = 0};
  
  for _, Index in pairs({"Unit", "Name", "Icon", "Count", "Classification", "Duration", "CasterUnit", "CasterName", "IsStealable", "IsCancelable", "IsDispellable", "SpellId"}) do
    NewAura[Index] = Aura[Index];
  end
  
  NewAura.Type = Aura.Type.."OLD";
  NewAura.CreationTime = GetTime();
  NewAura.Id = NewAura.Unit..NewAura.Type..NewAura.Name..NewAura.CreationTime;
  NewAura.ExpirationTime = NewAura.CreationTime + TimeToLive;
  
  tinsert(self.db[NewAura.Unit][NewAura.Type], NewAura);

  LibAura:FireAuraNew(NewAura);

end


-----------------------------------------------------------------
-- Function AuraChanged
-----------------------------------------------------------------
function Module:AuraChanged(Aura)

end

-----------------------------------------------------------------
-- Function Update
-----------------------------------------------------------------
function Module:Update(Aura)

  local CurrentTime = GetTime();

  for Unit, _ in pairs(self.db) do
    for Type, _ in pairs(self.db[Unit]) do
    
      local i = #self.db[Unit][Type];
    
      while i ~= 0 do
      
        if self.db[Unit][Type][i].ExpirationTime <= CurrentTime then
        
          LibAura:FireAuraOld(self.db[Unit][Type][i]);
          
          tremove(self.db[Unit][Type], i);
        
        end
      
      
        i = i - 1;
      
      end
    
    end
  end

end
