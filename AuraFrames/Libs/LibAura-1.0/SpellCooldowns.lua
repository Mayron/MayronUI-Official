-----------------------------------------------------------------
--
--  File: SpellCooldowns.lua
--
--  Author: Alex <Nexiuz> Elderson
--
--  Description:
--
--
--  Todo:
--
--    Fix the GetSpellBookItemInfo call (atm fixed with pcall).
--
-----------------------------------------------------------------


local LibAura = LibStub("LibAura-1.0");

local Major, Minor = "SpellCooldowns-1.0", 0;
local Module = LibAura:NewModule(Major, Minor);

if not Module then return; end -- No upgrade needed.

-- Make sure that we dont have old unit/types if we upgrade.
LibAura:UnregisterModuleSource(Module, nil, nil);

-- Register the unit/types.
LibAura:RegisterModuleSource(Module, "player", "SPELLCOOLDOWN");
LibAura:RegisterModuleSource(Module, "pet", "SPELLCOOLDOWN");


-- Import used global references into the local namespace.
local tinsert, tremove, tconcat, sort, tContains, wipe = tinsert, tremove, table.concat, sort, tContains, wipe;
local fmt, tostring = string.format, tostring;
local select, pairs, ipairs, next, type, unpack = select, pairs, ipairs, next, type, unpack;
local loadstring, assert, error = loadstring, assert, error;
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget;
local GetTime, GetSpellBookItemInfo, UnitName, GetSpellInfo, GetSpellCooldown = GetTime, GetSpellBookItemInfo, UnitName, GetSpellInfo, GetSpellCooldown;
local abs, pcall = abs, pcall;

-- Internal db used for storing auras, spellbooks and spell history.
Module.db = Module.db or {};
Module.History = Module.History or {};

-- Number of spells to keep in the history list.
local SpellMaxHistory = 5;

-- The minimum duration of a spell cooldown
local SpellMinimumCooldown = 2;

-- The max difference between cooldowns for grouping.
local GroupDurationRange = 0.1;

-- Mapping type for booktypes.
local BookType = {
  player  = BOOKTYPE_SPELL,
  pet     = BOOKTYPE_PET,
};

-- Update spell book throttle.
local SpellBooksLastScan = nil;
local SpellBooksScanThrottle = 1.0;

local MtAura = {
  player = {
    Type = "SPELLCOOLDOWN",
    Count = 0,
    Classification = "None",
    Unit = "player",
    CasterUnit = "player",
    CasterName = UnitName("player"),
    Duration = 0,
    ExpirationTime = 0,
    IsStealable = false,
    IsCancelable = false,
    IsDispellable = false,
    Active = false,
    ItemId = 0,
  },
  pet = {
    Type = "SPELLCOOLDOWN",
    Count = 0,
    Classification = "None",
    Unit = "pet",
    CasterUnit = "pet",
    CasterName = UnitName("pet"),
    Duration = 0,
    ExpirationTime = 0,
    IsStealable = false,
    IsCancelable = false,
    IsDispellable = false,
    Active = false,
    ItemId = 0,
  },
};

local AdditionalSpellCooldownList = {};
local CooldownsNew = {};
local CooldownsGroup = {};

local LastFullSpellCooldownScan = 0;

local ExternalStore;
local ScanList = {};

local PlayerClass = select(2, UnitClass("player"));

-----------------------------------------------------------------
-- Function ActivateSource
-----------------------------------------------------------------
function Module:ActivateSource(Unit, Type)

  if next(self.db) == nil then
  
    LibAura:RegisterEvent("SPELLS_CHANGED", self, self.TriggerUpdateSpellBooks);
    LibAura:RegisterEvent("PLAYER_ENTERING_WORLD", self, self.TriggerUpdateSpellBooks);
    LibAura:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", self, self.SpellCasted);
    LibAura:RegisterEvent("UNIT_SPELLCAST_FAILED", self, self.SpellCastFailed);
    LibAura:RegisterEvent("LIBAURA_UPDATE", self, self.ScanSpellCooldowns);
    LibAura:RegisterEvent("LIBAURA_UPDATE", self, self.Update);
  
  end
  
  if self.db[Unit] then
    return;
  end
  
  -- Setup the db for the unit.
  self.db[Unit] = {};
  self.History[Unit] = {};
  
  if not ScanList[Unit] then
    ScanList[Unit] = {};
  end
  
  -- Fill unit spellbook.
  self:UpdateSpellBook(Unit);
  
end


-----------------------------------------------------------------
-- Function DeactivateSource
-----------------------------------------------------------------
function Module:DeactivateSource(Unit, Type)
  
  for _, Aura in ipairs(self.db[Unit]) do
    if Aura.Active == true then
      LibAura:FireAuraOld(Aura);
    end
  end
  
  self.db[Unit] = nil;
  self.History[Unit] = nil;
  
  if next(self.db) == nil then
  
    LibAura:UnregisterEvent("SPELLS_CHANGED", self, self.TriggerUpdateSpellBooks);
    LibAura:UnregisterEvent("PLAYER_ENTERING_WORLD", self, self.TriggerUpdateSpellBooks);
    LibAura:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED", self, self.SpellCasted);
    LibAura:UnregisterEvent("UNIT_SPELLCAST_FAILED", self, self.SpellCastFailed);
    LibAura:UnregisterEvent("LIBAURA_UPDATE", self, self.ScanSpellCooldowns);
    LibAura:UnregisterEvent("LIBAURA_UPDATE", self, self.Update);

  end

end


-----------------------------------------------------------------
-- Function GetAuras
-----------------------------------------------------------------
function Module:GetAuras(Unit, Type)
  
  -- This function is rarely called. So we also not try to optimize it.
  
  local Auras = {};
  
  for _, Aura in pairs(self.db[Unit]) do
  
    if Aura.Active == true and Aura.RefSpellId == 0 then
      tinsert(Auras, Aura);
    end
  
  end
  
  return Auras;

end


-----------------------------------------------------------------
-- Function SetAdditionalSpellCooldownList
-----------------------------------------------------------------
function Module:SetAdditionalSpellCooldownList(AdditionalList)

  wipe(AdditionalSpellCooldownList);
  
  for _, SpellId in pairs(AdditionalList) do
    tinsert(AdditionalSpellCooldownList, SpellId);
  end

  for Unit, _ in pairs(self.db) do
    self:UpdateSpellBook(Unit);
  end

end


-----------------------------------------------------------------
-- Function SetSpellCooldownStore
-----------------------------------------------------------------
function Module:SetSpellCooldownStore(Store)

  ExternalStore = Store;
  
  if not ExternalStore[PlayerClass] then
    ExternalStore[PlayerClass] = {};
  end
  
  ScanList = ExternalStore[PlayerClass];

end

-----------------------------------------------------------------
-- Function TriggerUpdateSpellBooks
-----------------------------------------------------------------
function Module:TriggerUpdateSpellBooks()

  -- We reset the throttle here.
  SpellBooksLastScan = 0;

end


-----------------------------------------------------------------
-- Function Update
-----------------------------------------------------------------
function Module:Update(Elapsed)

  if SpellBooksLastScan ~= nil then
  
    SpellBooksLastScan = SpellBooksLastScan + Elapsed;
    
    if SpellBooksLastScan > SpellBooksScanThrottle then
      
      SpellBooksLastScan = nil;

      for Unit, _ in pairs(self.db) do
        self:UpdateSpellBook(Unit);
      end
    
    end
  
  end
  
  if LastFullSpellCooldownScan > 2 then
  
    LastFullSpellCooldownScan = 0;
    self:ScanAllSpellCooldowns();
    
  else
  
    LastFullSpellCooldownScan = LastFullSpellCooldownScan + Elapsed;
    
  end
  
end


-----------------------------------------------------------------
-- Function UpdateSpellBook
-----------------------------------------------------------------
function Module:UpdateSpellBook(Unit)

  MtAura[Unit].CasterName = UnitName(MtAura[Unit].CasterUnit);

  for _, Aura in pairs(self.db[Unit]) do
    Aura.Old = true;
  end

  local i, j = 1, 0;
  
  while true do
  
    local Check, SpellId, Result;

    if j == 0 then
      
      Result, Check, SpellId = pcall(GetSpellBookItemInfo, i, BookType[Unit]);

      if Check == "PETACTION" then
        SpellId = nil
      elseif not Result or not SpellId then
        j = 1
      end
      
    end
    
    if j ~= 0 then
    
      SpellId = AdditionalSpellCooldownList[j];
      
      if not SpellId then
        break;
      end
      
      j = j + 1;
      
    end

    if SpellId and not self.db[Unit][SpellId] then
    
      self.db[Unit][SpellId] = {
        Id = Unit.."SPELLCOOLDOWN"..SpellId,
        SpellId = SpellId,
        RefSpellId = 0,
      };
      
      setmetatable(self.db[Unit][SpellId], {__index = MtAura[Unit]});
      
    end

    if SpellId then

      local Aura = self.db[Unit][SpellId];
      local _;

      Aura.Index = i;
      Aura.Name, _, Aura.Icon = GetSpellInfo(SpellId);
      Aura.Old = nil;

    end
    
    i = i + 1
    
  end
  
  for SpellId, Aura in pairs(self.db[Unit]) do
  
    if Aura.Old == true then
    
      if Aura.Active == true and Aura.RefSpellId == 0 then
        LibAura:FireAuraOld(Aura);
      end

      self.db[Unit][SpellId] = nil;
    
    end
    
  end

end

-----------------------------------------------------------------
-- Function ScanSpellCooldowns
-----------------------------------------------------------------
function Module:ScanSpellCooldowns()

  local CurrentTime = GetTime();
  
  for Unit, _ in pairs(self.db) do
  
    wipe(CooldownsNew);
  
    for SpellId, _ in pairs(ScanList[Unit]) do
    
      local Aura = self.db[Unit][SpellId];
      
      if Aura then
    
        local Charges, MaxCharges, Start, Duration, Active;

        Charges, MaxCharges, Start, Duration = GetSpellCharges(SpellId);

        if Start and Duration and Start + Duration > CurrentTime and Charges ~= MaxCharges then

          Active = 1;
          Aura.ForceCountShow = true;

        else

          Start, Duration, Active = GetSpellCooldown(SpellId);

        end
        
        if Aura.Active == true then
          
          local UnderMin = Start + Duration < CurrentTime + 1.5;
          
          if (Active ~= 1 or Duration == 0) or (UnderMin == true and Aura.ExpirationTime < CurrentTime) then
          
            -- if the cooldown it not active or when we have lesser then
            -- "UnderMin" left and we are passed the last ExpirationTime
            -- then deactive it.
          
            if Aura.RefSpellId == 0 then
              LibAura:FireAuraOld(Aura);
            end
            
            Aura.RefSpellId = 0;
            Aura.Active = false;
          
          elseif UnderMin == false then
          
            -- We update only the cooldown when a minimum of "UnderMin"
            -- is still left. This to prevent the gcd to bump the spell cd.
          
            local OldExpirationTime = Aura.ExpirationTime;
            Aura.ExpirationTime = Start + Duration;

            local OldCharges = Aura.Count;
            Aura.Count = Charges;
              
            if Aura.RefSpellId == 0 and abs(Aura.ExpirationTime - OldExpirationTime) > 0.1 then
              LibAura:FireAuraChanged(Aura);
            end

            if Aura.RefSpellId == 0 and Aura.Count ~= OldCharges then
              LibAura:FireAuraOld(Aura);
              LibAura:FireAuraNew(Aura);
            end
          
          end
        
        else
        
          if Active == 1 and Start > 0 and Duration > SpellMinimumCooldown then
          
            Aura.Duration = Duration;
            Aura.ExpirationTime = Start + Duration;
            Aura.Active = true;
            Aura.Count = Charges;
            
            if Start then
              Aura.CreationTime = Start;
            end
            
            tinsert(CooldownsNew, SpellId);
            
          end
        
        end
      
      end
    
    end
    
    for _, SpellId in ipairs(CooldownsNew) do
    
      local Aura, HistoryIndex = self.db[Unit][SpellId], nil;
      
      -- Check if the new cooldown is located in the history.
      for Index, HistorySpell in ipairs(self.History[Unit]) do
        
        if SpellId == HistorySpell[1] and CurrentTime < HistorySpell[2] + 1.5 then
          HistoryIndex = Index;
          break;
        end
      
      end
      
      local GroupMatch = false;
      
      for _, Group in ipairs(CooldownsGroup) do
        
        if (HistoryIndex == nil or Group.PrimaryIndex == nil) and abs(Group.Duration - Aura.Duration) < GroupDurationRange then -- Accept a small difference
        
          GroupMatch = true;
        
          tinsert(Group.SpellIds, SpellId);
          
          if HistoryIndex ~= nil and (Group.PrimaryIndex == nil or Group.PrimaryIndex > HistoryIndex) then
            Group.PrimaryIndex = HistoryIndex;
            Group.Primary = SpellId;
          end
          
          break;
          
        end
      
      end
      
      if GroupMatch == false then
      
        tinsert(CooldownsGroup, {
          Duration = Aura.Duration,
          SpellIds = {SpellId},
          Primary = SpellId,
          PrimaryIndex = HistoryIndex,
        });
        
      end

    end
    
    for _, Group in ipairs(CooldownsGroup) do
    
      for _, SpellId in ipairs(Group.SpellIds) do
      
        local Aura = self.db[Unit][SpellId];
        
        if SpellId == Group.Primary then
        
          LibAura:FireAuraNew(Aura);
        
        else
        
          Aura.RefSpellId = Group.Primary;
        
        end
      
      end
    
    end
    
    -- Cleanup CooldownsGroup for next usage.
    wipe(CooldownsGroup);

  end
  
end


-----------------------------------------------------------------
-- Function ScanAllSpellCooldowns
-----------------------------------------------------------------
function Module:ScanAllSpellCooldowns()
  
  local CurrentTime = GetTime();
  
  for Unit, _ in pairs(self.db) do
  
    wipe(CooldownsNew);
  
    for SpellId, Aura in pairs(self.db[Unit]) do

      local Charges, MaxCharges, Start, Duration, Active;

      Charges, MaxCharges, Start, Duration = GetSpellCharges(SpellId);

      if Start and Duration and Start + Duration > CurrentTime and Charges ~= MaxCharges then

        Active = 1;
        Aura.ForceCountShow = true;

      else

        Start, Duration, Active = GetSpellCooldown(SpellId);

      end
      
      if Aura.Active == true then
        
        local UnderMin = Start + Duration < CurrentTime + 1.5;
        
        if (Active ~= 1 or Duration == 0) or (UnderMin == true and Aura.ExpirationTime < CurrentTime) then
        
          -- if the cooldown it not active or when we have lesser then
          -- "UnderMin" left and we are passed the last ExpirationTime
          -- then deactive it.
          if Aura.RefSpellId == 0 then
            LibAura:FireAuraOld(Aura);
          end
          
          Aura.RefSpellId = 0;
          Aura.Active = false;
        
        elseif UnderMin == false then
          -- We update only the cooldown when a minimum of "UnderMin"
          -- is still left. This to prevent the gcd to bump the spell cd.
        
          local OldExpirationTime = Aura.ExpirationTime;
          Aura.ExpirationTime = Start + Duration;

          local OldCharges = Aura.Count;
          Aura.Count = Charges;
          
          if Aura.RefSpellId == 0 and abs(Aura.ExpirationTime - OldExpirationTime) > 0.1 then
            LibAura:FireAuraChanged(Aura);
          end

          if Aura.RefSpellId == 0 and Aura.Count ~= OldCharges then
            LibAura:FireAuraOld(Aura);
            LibAura:FireAuraNew(Aura);
          end
        
        end
      
      else

        if Active == 1 and Start > 0 and Duration > SpellMinimumCooldown then

          ScanList[Unit][SpellId] = true;
        
          Aura.Duration = Duration;
          Aura.ExpirationTime = Start + Duration;
          Aura.Active = true;
          Aura.Count = Charges;
          
          if Start then
            Aura.CreationTime = Start;
          end
          
          tinsert(CooldownsNew, SpellId);
          
        end
      
      end
    
    end
    
    for _, SpellId in ipairs(CooldownsNew) do
    
      local Aura, HistoryIndex = self.db[Unit][SpellId], nil;
      
      -- Check if the new cooldown is located in the history.
      for Index, HistorySpell in ipairs(self.History[Unit]) do
        
        if SpellId == HistorySpell[1] and CurrentTime < HistorySpell[2] + 1.5 then
          HistoryIndex = Index;
          break;
        end
      
      end
      
      local GroupMatch = false;
      
      for _, Group in ipairs(CooldownsGroup) do
        
        if (HistoryIndex == nil or Group.PrimaryIndex == nil) and abs(Group.Duration - Aura.Duration) < GroupDurationRange then -- Accept a small difference
        
          GroupMatch = true;
        
          tinsert(Group.SpellIds, SpellId);
          
          if HistoryIndex ~= nil and (Group.PrimaryIndex == nil or Group.PrimaryIndex > HistoryIndex) then
            Group.PrimaryIndex = HistoryIndex;
            Group.Primary = SpellId;
          end
          
          break;
          
        end
      
      end
      
      if GroupMatch == false then
      
        tinsert(CooldownsGroup, {
          Duration = Aura.Duration,
          SpellIds = {SpellId},
          Primary = SpellId,
          PrimaryIndex = HistoryIndex,
        });
        
      end

    end
    
    for _, Group in ipairs(CooldownsGroup) do
    
      for _, SpellId in ipairs(Group.SpellIds) do
      
        local Aura = self.db[Unit][SpellId];
        
        if SpellId == Group.Primary then
        
          LibAura:FireAuraNew(Aura);
        
        else
        
          Aura.RefSpellId = Group.Primary;
        
        end
      
      end
    
    end
    
    -- Cleanup CooldownsGroup for next usage.
    wipe(CooldownsGroup);

  end
  
end


-----------------------------------------------------------------
-- Function SpellCasted
-----------------------------------------------------------------
function Module:SpellCasted(Unit, _, _, _, SpellId)

  if not self.History[Unit] then
    return;
  end
  
  tinsert(self.History[Unit], 1, {SpellId, GetTime()});
  
  if #self.History[Unit] > SpellMaxHistory then
    tremove(self.History[Unit]);
  end

end


-----------------------------------------------------------------
-- Function SpellCastFailed
-----------------------------------------------------------------
function Module:SpellCastFailed(Unit, _, _, _, SpellId)

  if not self.db[Unit] or not self.db[Unit][SpellId] then
    return;
  end
  
  if self.db[Unit][SpellId].Active == true then
  
    if self.db[Unit][SpellId].RefSpellId ~= 0 then
    
      LibAura:FireAuraChanged(self.db[Unit][self.db[Unit][SpellId].RefSpellId]);
    
    else
  
      LibAura:FireAuraChanged(self.db[Unit][SpellId]);
    
    end
  
  end
  
end

