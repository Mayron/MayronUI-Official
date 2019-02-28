-----------------------------------------------------------------
--
--  File: ItemCooldowns.lua
--
--  Author: Alex <Nexiuz> Elderson
--
--  Description:
--
--
-----------------------------------------------------------------


local LibAura = LibStub("LibAura-1.0");

local Major, Minor = "ItemCooldowns-1.0", 0;
local Module = LibAura:NewModule(Major, Minor);

if not Module then return; end -- No upgrade needed.

-- Make sure that we dont have old unit/types if we upgrade.
LibAura:UnregisterModuleSource(Module, nil, nil);

-- Register the unit/types.
LibAura:RegisterModuleSource(Module, "player", "ITEMCOOLDOWN");


-- Import used global references into the local namespace.
local tinsert, tremove, tconcat, sort, wipe = tinsert, tremove, table.concat, sort, wipe;
local fmt, tostring = string.format, tostring;
local select, pairs, ipairs, next, type, unpack = select, pairs, ipairs, next, type, unpack;
local loadstring, assert, error, abs = loadstring, assert, error, abs;
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget;
local GetInventoryItemID, GetContainerNumSlots, GetContainerItemID, GetItemSpell = GetInventoryItemID, GetContainerNumSlots, GetContainerItemID, GetItemSpell;
local UnitName, GetItemInfo, GetTime, GetItemCooldown = UnitName, GetItemInfo, GetTime, GetItemCooldown;


-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: NUM_BAG_SLOTS

-- Internal db used for storing auras, spellbooks and item history.
Module.db = Module.db or {};
Module.History = Module.History or {};
Module.SpellToItemId = Module.SpellToItemId or {};

-- Number of items to keep in the history list.
local ItemMaxHistory = 5;

-- The minimum duration of a item cooldown
local ItemMinimumCooldown = 2;

-- The max difference between cooldowns for grouping.
local GroupDurationRange = 0.1;

-- Update cooldowns throttle.
local UpdateCooldownsLastScan = 0;
local UpdateCooldownsScanThrottle = 0.2;

local MtAura = {
  Type = "ITEMCOOLDOWN",
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
  SpellId = 0,
};

local CooldownsNew = {};
local CooldownsGroup = {};

local DoUpdateDb, DoCooldownUpdate = false, false;

-----------------------------------------------------------------
-- Function ActivateSource
-----------------------------------------------------------------
function Module:ActivateSource(Unit, Type)
  
  self.db = {};
  self.SpellToItemId = {};
  
  -- Fill db.
  self:UpdateDb();
  
  -- First scan.
  self:CooldownUpdate();
  
  LibAura:RegisterEvent("BAG_UPDATE_COOLDOWN", self, self.QueueCooldownUpdate);
  LibAura:RegisterEvent("LIBAURA_UPDATE", self, self.Update);
  
  LibAura:RegisterEvent("BAG_UPDATE", self, self.QueueUpdateDb);
  LibAura:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", self, self.QueueUpdateDb);
  
  LibAura:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", self, self.SpellCasted);
  LibAura:RegisterEvent("UNIT_SPELLCAST_FAILED", self, self.SpellCastFailed);
  
end


-----------------------------------------------------------------
-- Function DeactivateSource
-----------------------------------------------------------------
function Module:DeactivateSource(Unit, Type)

  for _, Aura in pairs(self.db) do
    if Aura.Active == true and Aura.RefItemId == 0 then
      LibAura:FireAuraOld(Aura);
    end
  end
  
  wipe(self.db);
  wipe(self.SpellToItemId);

  LibAura:UnregisterEvent("BAG_UPDATE_COOLDOWN", self, self.QueueCooldownUpdate);
  LibAura:UnregisterEvent("LIBAURA_UPDATE", self, self.Update);

  LibAura:UnregisterEvent("BAG_UPDATE", self, self.QueueUpdateDb);
  LibAura:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED", self, self.QueueUpdateDb);
  
  LibAura:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED", self, self.SpellCasted);
  LibAura:UnregisterEvent("UNIT_SPELLCAST_FAILED", self, self.SpellCastFailed);
  
end


-----------------------------------------------------------------
-- Function GetAuras
-----------------------------------------------------------------
function Module:GetAuras(Unit, Type)
  
  -- This function is rarely called. So we also not try to optimize it.
  
  local Auras = {};
  
  for _, Aura in pairs(self.db) do
  
    if Aura.Active == true and Aura.RefItemId == 0 then
      tinsert(Auras, Aura);
    end
  
  end
  
  return Auras;

end


-----------------------------------------------------------------
-- Function QueueUpdateDb
-----------------------------------------------------------------
function Module:QueueUpdateDb()

  DoUpdateDb = true;

end


-----------------------------------------------------------------
-- Function QueueCooldownUpdate
-----------------------------------------------------------------
function Module:QueueCooldownUpdate()

  DoCooldownUpdate = true;

end


-----------------------------------------------------------------
-- Function UpdateDb
-----------------------------------------------------------------
function Module:UpdateDb()

  -- Scan equiped items.
  for i = 1, 17 do
    
    local ItemId = GetInventoryItemID("player", i);
    
    if ItemId then
      
      -- ItemId is nil for non equiped slots.
      self:UpdateDbItem(ItemId);
      
    end
    
  end
  
  -- Scan bag.
  for ContainerId = 0, NUM_BAG_SLOTS do
  
    for i = 1, GetContainerNumSlots(ContainerId) do
    
      local ItemId = GetContainerItemID(ContainerId, i)
    
      if ItemId then
        
        -- ItemId is nil for empty slots.
        self:UpdateDbItem(ItemId);
        
      end
    
    end
  
  end

end


-----------------------------------------------------------------
-- Function UpdateDbItem
-----------------------------------------------------------------
function Module:UpdateDbItem(ItemId)

  if not self.db[ItemId] then
  
    self.db[ItemId] = {
      Index = ItemId,
      Id = "playerITEMCOOLDOWN"..ItemId,
      ItemId = ItemId,
      RefItemId = 0,
    };
    
    setmetatable(self.db[ItemId], {__index = MtAura});
  
  end
  
  local _; -- Keep _ in the local namespace.
  
  self.db[ItemId].Name, _, _, _, _, _, _, _, _, self.db[ItemId].Icon = GetItemInfo(ItemId);
  
  local Spell, Rank = GetItemSpell(ItemId);
  
  if Spell then
    self.SpellToItemId[Spell..(Rank or "")] = ItemId;
  end
  
end

-----------------------------------------------------------------
-- Function CooldownUpdate
-----------------------------------------------------------------
function Module:CooldownUpdate()

  local CurrentTime = GetTime();
  wipe(CooldownsNew);

  for ItemId, Aura in pairs(self.db) do
  
    local Start, Duration, Active = GetItemCooldown(ItemId);
    
    if Aura.Active == true then
    
      local UnderMin = Start + Duration < CurrentTime + 1.5;
      
      if (Active ~= 1 or Duration == 0) or (UnderMin == true and Aura.ExpirationTime < CurrentTime) then
      
        -- if the cooldown it not active or when we have lesser then
        -- "UnderMin" left and we are passed the last ExpirationTime
        -- then deactive it.
      
        if Aura.RefItemId == 0 then
          LibAura:FireAuraOld(Aura);
        end
        
        Aura.RefItemId = 0;
        Aura.Active = false;
      
      elseif UnderMin == false then
      
        -- We update only the cooldown when a minimum of "UnderMin"
        -- is still left. This to prevent the gcd to bump the spell cd.
      
        local OldExpirationTime = Aura.ExpirationTime;
        Aura.ExpirationTime = Start + Duration;
        
        if Aura.RefItemId == 0 and abs(Aura.ExpirationTime - OldExpirationTime) > 0.1 then
          LibAura:FireAuraChanged(Aura);
        end
      
      end
    
    else
    
      if Active == 1 and Start > 0 and Duration > ItemMinimumCooldown then
      
        Aura.Duration = Duration;
        Aura.ExpirationTime = Start + Duration;
        Aura.Active = true;
        
        if Start then
          Aura.CreationTime = Start;
        end
        
        tinsert(CooldownsNew, ItemId);
        
      end
    
    end
  
  end

  if #CooldownsNew == 0 then
    return;
  end

  for _, ItemId in ipairs(CooldownsNew) do
  
    local Aura, HistoryIndex = self.db[ItemId], ItemMaxHistory + 1;
    
    -- Check if the new cooldown is located in the history.
    for Index, HistoryItemId in ipairs(self.History) do
      
      if HistoryItemId == ItemId then
        HistoryIndex = Index;
        break;
      end
    
    end
    
    local GroupMatch = false;
    
    for _, Group in ipairs(CooldownsGroup) do
      
      if abs(Group.Duration - Aura.Duration) < GroupDurationRange then -- Accept a small difference
      
        GroupMatch = true;
      
        tinsert(Group.ItemIds, ItemId);
        
        if Group.PrimaryIndex > HistoryIndex then
          Group.PrimaryIndex = HistoryIndex;
          Group.Primary = ItemId;
        end
        
        break;
        
      end
    
    end
    
    if GroupMatch == false then
    
      tinsert(CooldownsGroup, {
        Duration = Aura.Duration,
        ItemIds = {ItemId},
        Primary = ItemId,
        PrimaryIndex = HistoryIndex,
      });
      
    end

  end
  
  for _, Group in ipairs(CooldownsGroup) do
  
    for _, ItemId in ipairs(Group.ItemIds) do
    
      local Aura = self.db[ItemId];
      
      if ItemId == Group.Primary then
      
        LibAura:FireAuraNew(Aura);
      
      else
      
        Aura.RefItemId = Group.Primary;
      
      end
    
    end
  
  end
  
  -- Cleanup CooldownsGroup for next usage.
  wipe(CooldownsGroup);

end


-----------------------------------------------------------------
-- Function Update
-----------------------------------------------------------------
function Module:Update(Elapsed)

  if DoUpdateDb == true then
    self:UpdateDb();
    DoUpdateDb = false;
    DoCooldownUpdate = true;
  end
  
  if DoCooldownUpdate == true then
    self:CooldownUpdate();
    DoCooldownUpdate = false;
  end

  UpdateCooldownsLastScan = UpdateCooldownsLastScan + Elapsed;
  
  if UpdateCooldownsLastScan > UpdateCooldownsScanThrottle then
  
    UpdateCooldownsLastScan = 0;
    
  else
  
    return;
  
  end

  local CurrentTime = GetTime();
  
  for ItemId, Aura in pairs(self.db) do
  
    if Aura.Active == true and Aura.ExpirationTime < CurrentTime then
    
      if Aura.RefItemId == 0 then
        LibAura:FireAuraOld(Aura);
      end
      
      Aura.RefItemId = 0;
      Aura.Active = false;
    
    end
  
  end

end

-----------------------------------------------------------------
-- Function SpellCasted
-----------------------------------------------------------------
function Module:SpellCasted(Unit, Spell, Rank, _, SpellId)

  if Unit ~= "player" or not Spell then
    return;
  end

  local ItemId = self.SpellToItemId[Spell..(Rank or "")];

  if not ItemId then
    return;
  end

  tinsert(self.History, 1, ItemId);
  
  if #self.History > ItemMaxHistory then
    tremove(self.History);
  end

end


-----------------------------------------------------------------
-- Function SpellCastFailed
-----------------------------------------------------------------
function Module:SpellCastFailed(Unit, Spell, Rank, _, SpellId)

  if Unit ~= "player" or not Spell then
    return;
  end

  local ItemId = self.SpellToItemId[Spell..(Rank or "")];

  if not ItemId then
    return;
  end
  
  if self.db[ItemId].Active == true then
  
    if self.db[ItemId].RefItemId ~= 0 then
    
      LibAura:FireAuraChanged(self.db[self.db[ItemId].RefItemId]);
    
    else
  
      LibAura:FireAuraChanged(self.db[ItemId]);
    
    end
  
  end
  
end

