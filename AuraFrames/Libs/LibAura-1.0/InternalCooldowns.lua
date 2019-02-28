-----------------------------------------------------------------
--
--  File: InternalCooldowns.lua
--
--  Author: Alex <Nexiuz> Elderson
--
--  Description:
--
--
-----------------------------------------------------------------
local LibAura = LibStub("LibAura-1.0");

local Major, Minor = "InternalCooldowns-1.0", 0;
local Module = LibAura:NewModule(Major, Minor);

if not Module then return; end -- No upgrade needed.

-- Make sure that we dont have old unit/types if we upgrade.
LibAura:UnregisterModuleSource(Module, nil, nil);

-- Register the test unit/types.
LibAura:RegisterModuleSource(Module, "player", "INTERNALCOOLDOWNITEM");
--LibAura:RegisterModuleSource(Module, "player", "INTERNALCOOLDOWNTALENT");

-- Import used global references into the local namespace.
local wipe, pairs, tremove, tinsert = wipe, pairs, tremove, tinsert;
local UnitName, GetItemInfo, GetInventoryItemID, GetContainerNumSlots, GetContainerItemID, NUM_BAG_SLOTS = UnitName, GetItemInfo, GetInventoryItemID, GetContainerNumSlots, GetContainerItemID, NUM_BAG_SLOTS;
local floor, GetTime = floor, GetTime;

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: LibStub

-- We asume that 1 item can only have 1 internal cooldown.


-- Internal db used for storing auras, spellbooks and spell history.
Module.db = Module.db or {Auras = {}, ProcItems = {}, Equipped = {}};

-- Pool used for storing unused auras.
local AuraPool = {};

local InternalCooldownList = {};

local ScanEquippedItems = false;

local ItemProcs;


-----------------------------------------------------------------
-- Function ActivateSource
-----------------------------------------------------------------
function Module:ActivateSource(Unit, Type)

  if not ItemProcs then
    ItemProcs = LibAura:GetItemProcs();
  end

  LibAura:RegisterEvent("BAG_UPDATE", self, self.ScanEquippedItems);
  LibAura:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", self, self.ScanEquippedItems);

  self:ScanEquippedItems();

  LibAura:RegisterObjectSource(self, "player", "HELPFUL");
  LibAura:RegisterObjectSource(self, "player", "HARMFUL");

  LibAura:RegisterEvent("LIBAURA_UPDATE", self, self.Update);

end


-----------------------------------------------------------------
-- Function DeactivateSource
-----------------------------------------------------------------
function Module:DeactivateSource(Unit, Type)

  LibAura:UnregisterEvent("BAG_UPDATE", self, self.ScanEquippedItems);
  LibAura:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED", self, self.ScanEquippedItems);

  LibAura:UnregisterEvent("LIBAURA_UPDATE", self, self.Update);

  LibAura:UnregisterObjectSource(self, "player", "HELPFUL");
  LibAura:UnregisterObjectSource(self, "player", "HARMFUL");

  wipe(self.db.Equipped);

  for _, Aura in pairs(self.db.Auras) do
    LibAura:FireAuraOld(Aura);
  end

  wipe(self.db.Auras);

end


-----------------------------------------------------------------
-- Function GetAuras
-----------------------------------------------------------------
function Module:GetAuras(Unit, Type)

  return self.db.Auras;

end


-----------------------------------------------------------------
-- Function SetInternalCooldownList
-----------------------------------------------------------------
function Module:SetInternalCooldownList(List)

  InternalCooldownList = List;

end


-----------------------------------------------------------------
-- Function AuraNew
-----------------------------------------------------------------
function Module:AuraNew(Aura)

  -- Skip auras without time properties.
  if Aura.ExpirationTime == nil or Aura.Duration == 0 then
    return;
  end

  -- Skip auras that are not know to be used for internal cooldowns.
  if not ItemProcs[Aura.SpellId] then
    return;
  end

  -- Set as default the first item associated with the spell.
  local ItemId = ItemProcs[Aura.SpellId][1];

  -- Try to find the best associated item. self.db.Equipped is a list
  -- of character + bag items. The items on the character have a weight
  -- of 2, items in the bag have a weight 1. So prefer character items
  -- over bag items.
  local ItemWeight = 0;
  for i = 1, #ItemProcs[Aura.SpellId] do
    
    if self.db.Equipped[ItemProcs[Aura.SpellId][i]] and ItemWeight < self.db.Equipped[ItemProcs[Aura.SpellId][i]] then

      ItemWeight = self.db.Equipped[ItemProcs[Aura.SpellId][i]];
      ItemId = ItemProcs[Aura.SpellId][i];
      break;

    end

  end

  local SpellId = Aura.SpellId;
  local SpellTime = Aura.ExpirationTime - Aura.Duration;

  if not InternalCooldownList[ItemId] then

    InternalCooldownList[ItemId] = {
      ShortestCd = 0,
      AverageCd = 0,
      GuessedCd = 45,
      OverruleCd = 0,
      TimesSeen = 0,
      SpellId = SpellId,
    };

  end

  local ProcItem = InternalCooldownList[ItemId];

  if self.db.ProcItems[ItemId] then

    -- Calculate the time between the last proc and this proc.
    local LastCd = SpellTime - self.db.ProcItems[ItemId];

    -- Ignore all proc windows lower then 1 second (this can be server => client sync issues).
    if LastCd < 1 then
      return;
    end

    if LastCd ~= 0 and (ProcItem.ShortestCd == 0 or ProcItem.ShortestCd > LastCd) then
      
      -- Update ProcItem cooldown settings.
      ProcItem.ShortestCd = LastCd;
      ProcItem.GuessedCd = floor(LastCd);


      if ProcItem.TimesSeen < 15 then
        
        -- Better guess if the test number is still quite low.
        ProcItem.GuessedCd = ProcItem.GuessedCd - (ProcItem.GuessedCd % 5);

      end

    end

    -- We only want to count the cooldowns that reasonable.
    if LastCd ~= 0 and ProcItem.ShortestCd ~= 0 and LastCd < ProcItem.ShortestCd * 2 then

      ProcItem.AverageCd = ((ProcItem.AverageCd * ProcItem.TimesSeen) + LastCd) / (ProcItem.TimesSeen + 1);
      ProcItem.TimesSeen = ProcItem.TimesSeen + 1;

    end

  end

  self.db.ProcItems[ItemId] = SpellTime;

  -- Loop from the end to the begining so that tremove doesn't have to do more work then really needed.
  for i = #self.db.Auras, 1, -1 do
  
    -- We only have auras of the player here, so its quite safe to detect same
    -- on SpellId and ItemId.
    if self.db.Auras[i].SpellId == SpellId and self.db.Auras[i].ItemId == ItemId then
    
      LibAura:FireAuraOld(self.db.Auras[i]);
      tinsert(AuraPool, tremove(self.db.Auras, i));
    
    end
    
  end

  if ProcItem.GuessedCd < 5 and ProcItem.OverruleCd == 0 then

    -- Looks like a "on hit" equip effect, skip it.
    return;

  end

  -- Get the correct cooldown to use.
  local ItemCd = ProcItem.OverruleCd ~= 0 and ProcItem.OverruleCd or ProcItem.GuessedCd;

  -- Get an aura table from the pool or create one.
  local NewAura = tremove(AuraPool) or {
    Index = 0,
    Type = "INTERNALCOOLDOWNITEM",
    Unit = "player",
    Classification = "None",
    CasterUnit = "player",
    CasterName = UnitName("player"),
    IsStealable = false,
    IsCancelable = true,
    IsDispellable = false,
    Count = 0,
  };

  -- Set the aura properties.
  NewAura.SpellId = SpellId;
  NewAura.ItemId = ItemId;
  local _;
  NewAura.Name, _, _, _, _, _, _, _, _,  NewAura.Icon, _ = GetItemInfo(ItemId);
  NewAura.ExpirationTime = SpellTime + ItemCd;
  NewAura.Duration = ItemCd;
  NewAura.CreationTime = SpellTime;
  NewAura.Id = "playerINTERNALCOOLDOWNITEM"..ItemId..NewAura.ExpirationTime;
  
  -- Fire the new aura to LibAura.
  LibAura:FireAuraNew(NewAura);
  
  -- Add the new aura in our aura list.
  tinsert(self.db.Auras, NewAura);

end


-----------------------------------------------------------------
-- Function AuraOld
-----------------------------------------------------------------
function Module:AuraOld()

  -- Not used, but required as LibAura Source.

end


-----------------------------------------------------------------
-- Function AuraChanged
-----------------------------------------------------------------
function Module:AuraChanged()

  -- Not used, but required as LibAura Source.

end


-----------------------------------------------------------------
-- Function Event
-----------------------------------------------------------------
function Module:Event()

  -- Not used, but required as LibAura Source.

end


-----------------------------------------------------------------
-- Function Update
-----------------------------------------------------------------
function Module:Update()

  if ScanEquippedItems == true then
    self:ScanEquippedItems();
    ScanEquippedItems = false;
  end

  local CurrentTime = GetTime();

  -- Loop from the end to the begining so that tremove doesn't have to do more work then really needed.
  for i = #self.db.Auras, 1, -1 do
  
    if self.db.Auras[i].ExpirationTime <= CurrentTime then
    
      LibAura:FireAuraOld(self.db.Auras[i]);
      tinsert(AuraPool, tremove(self.db.Auras, i));
    
    end
    
  end

end


-----------------------------------------------------------------
-- Function QueueScanEquippedItems
-----------------------------------------------------------------
function Module:QueueScanEquippedItems()

  ScanEquippedItems = true;

end


-----------------------------------------------------------------
-- Function ScanEquippedItems
-----------------------------------------------------------------
function Module:ScanEquippedItems()

  wipe(self.db.Equipped);

  -- Scan equiped items.
  for i = 1, 17 do
    
    local ItemId = GetInventoryItemID("player", i);
    
    -- ItemId is nil for non equiped slots.
    if ItemId then
      
      self.db.Equipped[ItemId] = 2;
      
    end
    
  end
  
  -- Scan bag.
  for ContainerId = 0, NUM_BAG_SLOTS do
  
    for i = 1, GetContainerNumSlots(ContainerId) do
    
      local ItemId = GetContainerItemID(ContainerId, i)
    
      -- ItemId is nil for empty slots.
      if ItemId then
        
        self.db.Equipped[ItemId] = 1;
        
      end
    
    end
  
  end

end
