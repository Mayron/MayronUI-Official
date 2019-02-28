-----------------------------------------------------------------
--
--  File: UnitAuras.lua
--
--  Author: Alex <Nexiuz> Elderson
--
--  Description:
--
--
-----------------------------------------------------------------


--[[ Some notes about this library

Blizzard unit aura order:

  The Blizzard aura order is simple, the last aura a unit gains will be added to the
  end of the list. This order can be changed by a ui reload or a zone transfer. To
  make it as fast as posible, we dont scan the whole list but we compare the Blizzard
  list with the internal list by walking thru both lists at the same time. There is one
  exception, which is that when an aura gets a refresh, it can stay on the same place
  in the order.


Duplicated auras:

  We use the following as the uniq id for an aura: Unit+SpellId+ExpireTime, but that is
  not always uniq (most commen example is the proc from Trauma). We can extend the uniq
  id by using a follow up number or something, but overall we are not interested to see
  2 or more auras that are the same. So we are consolidating those buffs into 1 single
  aura.


Aura object pool:

  We use a pool for unused aura tables. The memory garbage is way bigger from this library
  then you would expect (600 KB in 2 minutes with an warlock at the training dummies with
  only player helpful buffs enabled). Because we are going to reuse aura tables, the
  interested parties should never use an aura table after the AuraOld() event. If an party
  still want to use an old aura after the AuraOld event, then they should make an copy of
  the aura table so we can reuse the aura table without having any references to it outside
  the lib.

  This pool doesnt need to contain all the unused aura tables, its only used for the mass
  to reduce the memory garbage. If there are aura tables that are released without added
  back to the pool then the garbage collector will deal with them in time.


Mouseover unit:

  The mouseover unit is different from all other units in that we do not receive an UNIT_AURA
  event when the mouse leaves a unit. To support mouseover just like all the other units we
  are checking the mouseover unit when we got a UNIT_AURA for mouseover every 0.2 seconds
  until the mouseover unit is nil. When the mouseover unit is nil, we trigger an old event
  for all auras we had for the mouseover.

*Target Units:

  This is similar to Mouseover, UNIT_AURA doesn't fire for *Target units. Instead we scan the
  *Target units ever 0.2 seconds.

]]--


local LibAura = LibStub("LibAura-1.0");

local Major, Minor = "UnitAuras-1.0", 0;
local Module = LibAura:NewModule(Major, Minor);

if not Module then return; end -- No upgrade needed.


-- Import used global references into the local namespace.
local tinsert, tremove, tconcat, sort, tContains = tinsert, tremove, table.concat, sort, tContains;
local fmt, tostring = string.format, tostring;
local select, pairs, ipairs, next, type, unpack = select, pairs, ipairs, next, type, unpack;
local loadstring, assert, error = loadstring, assert, error;
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget;
local GetTime = GetTime;
local UnitAura, UnitName = UnitAura, UnitName;


-----------------------------------------------------------------
-- EventsToMonitor
-----------------------------------------------------------------
Module.EventsToMonitor = {
  focus         = {"UNIT_AURA", "PLAYER_FOCUS_CHANGED"},
  focustarget   = {"UNIT_AURA", "PLAYER_FOCUS_CHANGED", "UNIT_TARGET", "LIBAURA_UPDATE"},
  player        = {"UNIT_AURA"},
  pet           = {"UNIT_AURA", "UNIT_PET"},
  pettarget     = {"UNIT_AURA", "UNIT_PET", "UNIT_TARGET", "LIBAURA_UPDATE"},
  vehicle       = {"UNIT_AURA", "UNIT_ENTERED_VEHICLE", "UNIT_EXITED_VEHICLE"},
  vehicletarget = {"UNIT_AURA", "UNIT_ENTERED_VEHICLE", "UNIT_TARGET", "LIBAURA_UPDATE"},
  target        = {"UNIT_AURA", "PLAYER_TARGET_CHANGED"},
  targettarget  = {"UNIT_AURA", "PLAYER_TARGET_CHANGED", "UNIT_TARGET", "LIBAURA_UPDATE"},
  mouseover     = {"UNIT_AURA", "UPDATE_MOUSEOVER_UNIT", "LIBAURA_UPDATE"}
};


for i = 1, 4 do
  Module.EventsToMonitor["party"..i]           = {"UNIT_AURA", "PARTY_MEMBERS_CHANGED"};
  Module.EventsToMonitor["party"..i.."target"] = {"UNIT_AURA", "UNIT_TARGET", "PARTY_MEMBERS_CHANGED", "LIBAURA_UPDATE"};
  Module.EventsToMonitor["partypet"..i]        = {"UNIT_AURA", "UNIT_PET", "PARTY_MEMBERS_CHANGED"};
  Module.EventsToMonitor["boss"..i]            = {"UNIT_AURA", "INSTANCE_ENCOUNTER_ENGAGE_UNIT"};
  Module.EventsToMonitor["boss"..i.."target"]  = {"UNIT_AURA", "INSTANCE_ENCOUNTER_ENGAGE_UNIT", "LIBAURA_UPDATE"};
end

for i = 1, 5 do
  Module.EventsToMonitor["arena"..i]           = {"UNIT_AURA", "ARENA_OPPONENT_UPDATE"};
  Module.EventsToMonitor["arena"..i.."target"] = {"UNIT_AURA", "ARENA_OPPONENT_UPDATE", "UNIT_TARGET", "LIBAURA_UPDATE"};
end

for i = 1, 40 do
  Module.EventsToMonitor["raid"..i]            = {"UNIT_AURA", "RAID_ROSTER_UPDATE"};
  Module.EventsToMonitor["raid"..i.."target"]  = {"UNIT_AURA", "RAID_ROSTER_UPDATE", "LIBAURA_UPDATE"};
  Module.EventsToMonitor["raidpet"..i]         = {"UNIT_AURA", "UNIT_PET", "RAID_ROSTER_UPDATE"};
end

local ScanOnLibUpdate = {};

local AuraPool =  {};

-----------------------------------------------------------------
-- UnitTranslations
-----------------------------------------------------------------
Module.UnitTranslations = {
  focus         = "focus",
  focustarget   = "focustarget",
  player        = "player",
  pet           = "pet",
  pettarget     = "pettarget",
  vehicle       = "vehicle",
  vehicletarget = "vehicletarget",
  target        = "target",
  targettarget  = "targettarget",
  mouseover     = "mouseover",
};

for i = 1, 4 do
  Module.UnitTranslations["party"..i]           = "party";
  Module.UnitTranslations["party"..i.."target"] = "partytarget";
  Module.UnitTranslations["partypet"..i]        = "partypet";
  Module.UnitTranslations["boss"..i]            = "boss";
  Module.UnitTranslations["boss"..i.."target"]  = "bosstarget";
end

for i = 0, 5 do
  Module.UnitTranslations["arena"..i]           = "arena";
  Module.UnitTranslations["arena"..i.."target"] = "arenatarget";
end

for i = 1, 40 do
  Module.UnitTranslations["raid"..i]            = "raid";
  Module.UnitTranslations["raid"..i.."target"]  = "raidtarget";
  Module.UnitTranslations["raidpet"..i]         = "raidpet";
end


-----------------------------------------------------------------
-- UnitSourceTranslations
-----------------------------------------------------------------
Module.UnitSourceTranslations = {}

Module.UnitSourceTranslations["party"]       = {};
Module.UnitSourceTranslations["partytarget"] = {};
Module.UnitSourceTranslations["partypet"]    = {};
Module.UnitSourceTranslations["boss"]        = {};
Module.UnitSourceTranslations["bosstarget"]  = {};

for i = 1, 4 do
  table.insert(Module.UnitSourceTranslations["party"], "party"..i);
  table.insert(Module.UnitSourceTranslations["partytarget"], "party"..i.."target");
  table.insert(Module.UnitSourceTranslations["partypet"], "partypet"..i);
  table.insert(Module.UnitSourceTranslations["boss"], "boss"..i);
  table.insert(Module.UnitSourceTranslations["bosstarget"], "boss"..i.."target");
end

Module.UnitSourceTranslations["arena"]       = {};
Module.UnitSourceTranslations["arenatarget"] = {};

for i = 0, 5 do
  table.insert(Module.UnitSourceTranslations["arena"], "arena"..i);
  table.insert(Module.UnitSourceTranslations["arenatarget"], "arena"..i.."target");
end

Module.UnitSourceTranslations["raid"]       = {};
Module.UnitSourceTranslations["raidtarget"] = {};
Module.UnitSourceTranslations["raidpet"]    = {};

for i = 1, 40 do
  table.insert(Module.UnitSourceTranslations["raid"], "raid"..i);
  table.insert(Module.UnitSourceTranslations["raidtarget"], "raid"..i.."target");
  table.insert(Module.UnitSourceTranslations["raidpet"], "raidpet"..i);
end

-----------------------------------------------------------------
-- Function Registration of Sources
-----------------------------------------------------------------
-- Make sure that we dont have old unit/types if we upgrade.
LibAura:UnregisterModuleSource(Module, nil, nil);

-- Register the unit/types.
for Unit, _ in pairs(Module.EventsToMonitor) do
  LibAura:RegisterModuleSource(Module, Unit, "HELPFUL");
  LibAura:RegisterModuleSource(Module, Unit, "HARMFUL");
end

for Unit, _ in pairs(Module.UnitSourceTranslations) do
  LibAura:RegisterModuleSource(Module, Unit, "HELPFUL");
  LibAura:RegisterModuleSource(Module, Unit, "HARMFUL");
end

-- Internal db used for storing auras.
Module.db = Module.db or {};


-----------------------------------------------------------------
-- Function ActivateSource
-----------------------------------------------------------------
function Module:ActivateSource(Unit, Type)

  if Module.UnitSourceTranslations[Unit] then
  
    for _, RealUnit in ipairs(Module.UnitSourceTranslations[Unit]) do
      Module:ActivateSource(RealUnit, Type)
    end

    return
  
  end
  
  if next(self.db) == nil then
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "ScanAllUnits");
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ScanAllUnits");
  end

  if not self.db[Unit] then
  
    self.db[Unit] = {[Type] = {}};
    
    for _, Event in ipairs(Module.EventsToMonitor[Unit]) do
      self:RegisterEvent(Event, Event);
    end
    
    if tContains(Module.EventsToMonitor[Unit], "LIBAURA_UPDATE") then
      ScanOnLibUpdate[Unit] = true;
    end
    
  elseif not self.db[Unit][Type] then

    self.db[Unit][Type] = {};

  end

  self:ScanUnit(Unit);

end


-----------------------------------------------------------------
-- Function DeactivateSource
-----------------------------------------------------------------
function Module:DeactivateSource(Unit, Type)

  if Module.UnitSourceTranslations[Unit] then
  
    for _, RealUnit in ipairs(Module.UnitSourceTranslations[Unit]) do
      Module:DeactivateSource(RealUnit, Type)
    end

    return
  
  end

  for _, Aura in ipairs(self.db[Unit][Type]) do
    LibAura:FireAuraOld(Aura);
  end
  
  self.db[Unit][Type] = nil;
  
  if next(self.db[Unit]) == nil then
  
    self.db[Unit] = nil;
    
    for _, Event in ipairs(Module.EventsToMonitor[Unit]) do
      self:UnregisterEvent(Event, Event);
    end
    
    ScanOnLibUpdate[Unit] = nil;
    
  end
  
  if next(self.db) == nil then
    self:UnregisterEvent("PLAYER_ENTERING_WORLD", "ScanAllUnits");
    self:UnregisterEvent("ZONE_CHANGED_NEW_AREA", "ScanAllUnits");
  end

end


-----------------------------------------------------------------
-- Function GetAuras
-----------------------------------------------------------------
function Module:GetAuras(Unit, Type)
-- print ( "AF: GetAuras" );
  if Module.UnitSourceTranslations[Unit] then
  
    local Results = {}
  
    for _, RealUnit in ipairs(Module.UnitSourceTranslations[Unit]) do
      local UnitResults = Module:GetAuras(RealUnit, Type)
      for _, Aura in ipairs(UnitResults) do
        table.insert(Results, Aura)
      end
    end

    return Results;
  
  end
  
  return self.db[Unit][Type];

end


-----------------------------------------------------------------
-- Event Handlers
-----------------------------------------------------------------
function Module:UNIT_AURA(Unit)
  Module:ScanUnitChanges(Unit);
end

function Module:PARTY_MEMBERS_CHANGED()
  for i = 1, 4 do
    Module:ScanUnit("party"..i);
    Module:ScanUnit("party"..i.."pet");
    Module:ScanUnit("party"..i.."target");
  end
end

function Module:PLAYER_FOCUS_CHANGED()
  Module:ScanUnit("focus");
  Module:ScanUnit("focustarget");
end

function Module:PLAYER_TARGET_CHANGED()
  Module:ScanUnit("target");
  Module:ScanUnit("targettarget");
end

function Module:RAID_ROSTER_UPDATE()
  for i = 1, 40 do
    Module:ScanUnit("raid"..i);
    Module:ScanUnit("raid"..i.."pet");
    Module:ScanUnit("raid"..i.."target");
  end
end

function Module:UNIT_ENTERED_VEHICLE(Unit)
  if Unit == "player" then
    Module:ScanUnit("vehicle");
  end
end

function Module:UNIT_EXITED_VEHICLE(Unit)
  if Unit == "player" then
    Module:ScanUnit("vehicle");
  end
end

function Module:UNIT_PET(Unit)
  Module:ScanUnit(Unit.."pet");
end

function Module:UNIT_TARGET(Unit)
  Module:ScanUnit(Unit.."target");
end

function Module:UPDATE_MOUSEOVER_UNIT()
  Module:ScanUnit("mouseover");
end

function Module:LIBAURA_UPDATE()
  for Unit, _ in pairs(ScanOnLibUpdate) do
    Module:ScanUnit(Unit);
  end
end

function Module:PLAYER_ENTERING_WORLD()
  Module:ScanAllUnits();
end

function Module:ZONE_CHANGED_NEW_AREA()
  Module:ScanAllUnits();
end


-----------------------------------------------------------------
-- Function ScanUnit
-----------------------------------------------------------------
function Module:ScanUnit(Unit)

  if self.db[Unit] then
    for Type, _ in pairs(self.db[Unit]) do
      self:ScanUnitAuras(Unit, Type);
    end
  end

end


-----------------------------------------------------------------
-- Function ScanUnitChanges
-----------------------------------------------------------------
function Module:ScanUnitChanges(Unit)
  
  if self.db[Unit] then
    for Type, _ in pairs(self.db[Unit]) do
      self:ScanUnitAurasChanges(Unit, Type);
    end
  end

end


-----------------------------------------------------------------
-- Function ScanAllUnits
-----------------------------------------------------------------
function Module:ScanAllUnits()

  for Unit, _ in pairs(self.db) do
    for Type, _ in pairs(self.db[Unit]) do
      self:ScanUnitAuras(Unit, Type);
    end
  end

end


-----------------------------------------------------------------
-- Function ScanUnitAurasChanges
-----------------------------------------------------------------
function Module:ScanUnitAurasChanges(Unit, Type)
-- print( "ScanUnitAurasChanges" );

  --[[
  
    To make sure we scan the auras as quick as posible we will make the following assumptions:
    
    - Blizzard will put new auras always at the end of the list
    - The order of the list will not change
    - On reloads or on zone transfer the order can change

    There seems to be 1 exception of new auras at the end of the list, and that is refreshing buffs.
    
    We will have 2 lists, 1 of the new/current auras and 1 of the last scan. We will loop thro the
    blizz list and the last scan list at the same , while we are not at the end of last scan we
    can say that every buff in blizz that doesnt match last scan is a removed aura and we will find the
    blizz aura futher in the last scan. At the end of the last scan list, all auras in the blizz list are
    new.
  
  ]]--
  
  
  local Auras = self.db[Unit][Type];
  local i, j = 1, 1; -- i is the index of the blizz auras, j is the index of the last scan.

  while true do
	-- print ( UnitAura(Unit, i, Type) );
    -- local Name, _, Icon, Count, Classification, Duration, ExpirationTime, CasterUnit, IsStealable, _, SpellId = UnitAura(Unit, i, Type);
	local Name, Icon, Count, Classification, Duration, ExpirationTime, CasterUnit, IsStealable, _, SpellId = UnitAura(Unit, i, Type); -- 2018-07-22 CB: There is not "Rank" anymore

    -- Break out of the while when we are at the end of the list.
    if not Name then break end;
    
    if i > #Auras then -- new aura
    
      local Id = Unit..Name..ExpirationTime;
      
      for u = j - 1, 1, -1 do
      
        if Auras[u] and Auras[u].Id == Id then
          Id = nil;
          break;
        end

      end

      if Id then

        -- Pop an aura table out the pool or create an new one.
        local Aura = tremove(AuraPool) or {
          ItemId = 0,
        };
        
        Aura.Type = Type;
        Aura.Index = i;
        Aura.Unit = Module.UnitTranslations[Unit] or Unit;
        Aura.RealUnit = Unit;
        Aura.Name = Name;
        Aura.Icon = Icon;
        Aura.Count = Count;
        Aura.Classification = Classification or "None";
        Aura.Duration = Duration or 0;
        Aura.ExpirationTime = ExpirationTime;
        Aura.CasterUnit = CasterUnit;
        Aura.CasterName = CasterUnit and UnitName(CasterUnit) or "";
        Aura.IsStealable = IsStealable == true and true or false;
        Aura.IsCancelable = false;
        Aura.IsDispellable = false;
        Aura.SpellId = SpellId;
        Aura.Id = Id;
        Aura.IsRefired = false;
        
        tinsert(Auras, Aura);
        
        LibAura:FireAuraNew(Aura);
        
        j = i + 1;
        
      end
      
      i = i + 1;
    
    elseif Auras[j].ExpirationTime ~= ExpirationTime or Auras[j].SpellId ~= SpellId or Auras[j].CasterUnit ~= CasterUnit then
    
      if Auras[j].SpellId == SpellId and Auras[j].CasterUnit == CasterUnit then
    
        Auras[j].GoingRefire = true;

        -- Updated aura ExpirationTime, fire old & new.
        LibAura:FireAuraOld(Auras[j]);

        Auras[j].GoingRefire = false;

        -- Update any properties that can be changed.
        Auras[j].Count = Count;
        Auras[j].Duration = Duration or 0;
        Auras[j].ExpirationTime = ExpirationTime;
        Auras[j].IsRefired = true;

        LibAura:FireAuraNew(Auras[j]);

        i = i + 1;
        j = j + 1;
      
      else
    
        -- Old aura, fire old.

        Auras[j].Index = 0;
        
        LibAura:FireAuraOld(Auras[j]);
        
        -- Release the old aura table in the pool for later use.
        tinsert(AuraPool, tremove(Auras, j));

      end
    
    else -- Same aura, but can be changed.
    
      Auras[j].Index = i;
      
      if (Auras[j].Count ~= Count) then

        Auras[j].Count = Count;
        
        LibAura:FireAuraChanged(Auras[j]);
        
      end
      
      i = i + 1;
      j = j + 1;
    
    end
    
  end
  
  -- Everything that is not checked in the last scan are old auras
  
  while true do
  
    -- We remove everytime the last aura in the list so lua dont have to shift the remaining auras in the list.

    if j >= #Auras + 1 then break end;
    
    local Aura = tremove(Auras);

    Aura.Index = 0;
    
    LibAura:FireAuraOld(Aura);
    
    -- Release the old aura table in the pool for later use.
    tinsert(AuraPool, Aura);
    
  end

end


-----------------------------------------------------------------
-- Function ScanUnitAuras
-----------------------------------------------------------------
function Module:ScanUnitAuras(Unit, Type)
-- print( "ScanUnitAuras" );
  --[[

    Same functionality as Module:ScanUnitAurasChanges but this function will scan it on a slow way.
    This function will be called on zone transfer and other moments where the aura order can
    be changed.

    Also for debug, this function can be called to see if the Module:ScanPlayer found all
    the changes (this function shouldnt report any old/new auras after Module:ScanPlayer)

  ]]--
  
  local Auras = self.db[Unit][Type];
  local j;
  
  for j = 1, #Auras do
    Auras[j].Scanned = false;
  end

  local i = 1;

  while true do
    -- local Name, _, Icon, Count, Classification, Duration, ExpirationTime, CasterUnit, IsStealable, _, SpellId = UnitAura(Unit, i, Type);
	local Name, Icon, Count, Classification, Duration, ExpirationTime, CasterUnit, IsStealable, _, SpellId = UnitAura(Unit, i, Type); -- 2018-07-22 CB: There is no "Rank" anymore
    
    if not Name then break end;
    
    local Found = false;
    
    for j = 1, #Auras do
    
      if Auras[j].Name == Name and Auras[j].CasterUnit == CasterUnit and Auras[j].ExpirationTime == ExpirationTime then
        
        Found = true;
        Auras[j].Scanned = true;
        Auras[j].Index = i;
        
        if (Auras[j].Count ~= Count) then
          
          Auras[j].Count = Count;
          
          LibAura:FireAuraChanged(Auras[j]);
          
        end
        
        break;
        
      end
    
    end
    
    if Found == false then -- New aura

      local Id = Unit..Name..ExpirationTime;
      
      for j = 1, #Auras do
      
        if Auras[j] and Auras[j].Id == Id then
          Id = nil;
          break;
        end
      
      end

      if Id then

        -- Pop an aura table out the pool or create an new one.
        local Aura = tremove(AuraPool) or {
          ItemId = 0,
        };
        
        Aura.Type = Type;
        Aura.Index = i;
        Aura.Unit = Module.UnitTranslations[Unit] or Unit;
        Aura.RealUnit = Unit;
        Aura.Name = Name;
        Aura.Icon = Icon;
        Aura.Count = Count;
        Aura.Classification = Classification or "None";
        Aura.Duration = Duration or 0;
        Aura.ExpirationTime = ExpirationTime;
        Aura.CasterUnit = CasterUnit;
        Aura.CasterName = CasterUnit and UnitName(CasterUnit) or "";
        Aura.IsStealable = IsStealable == true and true or false;
        Aura.IsCancelable = false;
        Aura.IsDispellable = false;
        Aura.SpellId = SpellId;
        Aura.Id = Id;
        Aura.Scanned = true;
        Aura.IsRefired = false;
        
        if Duration and ExpirationTime then
          Aura.CreationTime = ExpirationTime - Duration;
        else
          Aura.CreationTime = 0;
        end
        
        tinsert(Auras, Aura);
        
        LibAura:FireAuraNew(Aura);
        
      end
      
    end
    
    i = i + 1;
    
  end
  
  j = 1;
  
  while true do
  
    if j >= #Auras + 1 then break end;
  
    if Auras[j].Scanned == false then -- Old aura
    
      Auras[j].Index = 0;
      
      LibAura:FireAuraOld(Auras[j]);

      -- Release the old aura table in the pool for later use.
      tinsert(AuraPool, tremove(Auras, j));
      
    else
    
      j = j + 1;
    
    end
    
  end
  
end
