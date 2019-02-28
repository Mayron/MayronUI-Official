local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

-- Import used global references into the local namespace.
local pairs, ipairs, loadstring, pcall, tostring, tinsert, sort = pairs, ipairs, loadstring, pcall, tostring, tinsert, sort;

--[[

The following types are supported atm:

  String
  Number
  Float (Number with fraction)
  Boolean
  SpellName
  SpellId
  
By default every attribute is defined as static unless
Dynamic = true is defined. If the filter contains one or
more attributes that are not static then the filter will be
checked every x time. (This is implemented in the AuraList
layer).

]]--


-----------------------------------------------------------------
-- AuraDefinition list
-----------------------------------------------------------------
AuraFrames.AuraDefinition = {
  Type = {
    Type = "String",
    Name = "Aura type",
    List = {
      HARMFUL = "Harmful",
      HELPFUL = "Helpful",
      WEAPON = "Weapon enchantment",
      SPELLCOOLDOWN = "Spell Cooldown",
      ITEMCOOLDOWN = "Item Cooldown",
      INTERNALCOOLDOWNITEM = "Internal Item Cooldown",
      TOTEM = "Totem",
      STANCE = "Stance",
      ALERT = "Boss Mod Alert",
    },
    Order = true,
    Filter = true,
    Weight = 2,
  },
  Name = { -- Used for build in filters
    Type = "String",
    Name = "Name",
    Order = false,
    Filter = false,
    Weight = 2,
  },
  SpellName = {
    Type = "SpellName",
    Name = "Spell name",
    Order = true,
    Filter = true,
    Code = "(Object.SpellId ~= 0 and Object.Name or \"\")",
    Weight = 2,
  },
  ItemName = {
    Type = "ItemName",
    Name = "Item name",
    Order = true,
    Filter = true,
    Code = "(Object.ItemId ~= 0 and Object.Name or \"\")",
    Weight = 2,
  },
  Icon = {
    Type = "String",
    Name = "Spell icon",
    Order = false,
    Filter = false,
    Weight = 2,
  },
  Count = {
    Type = "Number",
    Name = "Aura stacks",
    Order = true,
    Filter = true,
    Weight = 1,
  },
  Classification = {
    Type = "String",
    Name = "Aura classification",
    List = {
      Magic = "Magic",
      Disease = "Disease",
      Poison = "Poison",
      Curse = "Curse",
      None = "None",
    },
    Order = true,
    Filter = true,
    Weight = 2,
  },
  Duration = {
    Type = "Float",
    Name = "Original duration",
    Order = true,
    Filter = true,
    Weight = 1,
  },
  Remaining = {
    Type = "Float",
    Name = "Time remaining",
    Code = "((Object.ExpirationTime == 0 and 0) or (Object.ExpirationTime - GetTime()))",
    Order = true,
    Filter = true,
    Dynamic = true,
    Weight = 3,
  },
  ExpirationTime = {
    Type = "Float",
    Name = "Expiration time",
    Order = true,
    Filter = true,
    Weight = 1,
  },
  IsAura = {
    Type = "Boolean",
    Name = "Is Aura",
    Code = "(Object.ExpirationTime == 0)",
    Order = true,
    Filter = true,
    Weight = 1,
  },
  CasterUnit = {
    Type = "String",
    Name = "Caster unit",
    Order = false,
    Filter = false,
    Weight = 2,
  },
  CasterName = {
    Type = "String",
    Name = "Caster name",
    Order = true,
    Filter = true,
    Weight = 2,
  },
  CasterClass = {
    Type = "String",
    Name = "Caster class",
    List = {
      WARRIOR     = "Warrior",
      DEATHKNIGHT = "Death Knight",
      PALADIN     = "Paladin",
      PRIEST      = "Priest",
      SHAMAN      = "Shaman",
      DRUID       = "Druid",
      ROGUE       = "Rogue",
      MAGE        = "Mage",
      WARLOCK     = "Warlock",
      HUNTER      = "Hunter",
      NONE        = "Unknown",
    },
    Code = "(Object.CasterUnit and select(2, UnitClass(Object.CasterUnit)) or \"NONE\")",
    Order = true,
    Filter = true,
    Weight = 2,
  },
  SpellId = {
    Type = "SpellId",
    Name = "Spell Id",
    Order = true,
    Filter = true,
    Weight = 1,
  },
  ItemId = {
    Type = "ItemId",
    Name = "Item Id",
    Order = true,
    Filter = true,
    Weight = 1,
  },
  CastByMe = {
    Type = "Boolean",
    Name = "Cast by me",
    Code = "(Object.CasterUnit == \"player\")",
    Order = true,
    Filter = true,
    Weight = 2,
  },
  IsStealable = {
    Type = "Boolean",
    Name = "Is stealable",
    Order = false,
    Filter = true,
    Weight = 1,
  },
  CastByParty = {
    Type = "Boolean",
    Name = "Cast by party",
    Code = "(Object.CasterUnit and UnitInParty(Object.CasterUnit) == true)",
    Order = true,
    Filter = true,
    Weight = 3,
  },
  CastByRaid = {
    Type = "Boolean",
    Name = "Cast by raid",
    Code = "(Object.CasterUnit and UnitInRaid(Object.CasterUnit) ~= nil)",
    Order = true,
    Filter = true,
    Weight = 3,
  },
  CastByBgRaid = {
    Type = "Boolean",
    Name = "Cast by bg raid",
    Code = "(Object.CasterUnit and UnitInBattleground(Object.CasterUnit) ~= nil)",
    Order = true,
    Filter = true,
    Weight = 3,
  },
  CastByPlayer = {
    Type = "Boolean",
    Name = "Cast by a player",
    Code = "(Object.CasterUnit and UnitIsPlayer(Object.CasterUnit) == true)",
    Order = true,
    Filter = true,
    Weight = 3,
  },
  CastByMyPet = {
    Type = "Boolean",
    Name = "Cast by my pet",
    Code = "(Object.CasterUnit and UnitIsUnit(Object.CasterUnit, \"playerpet\") == true)",
    Order = true,
    Filter = true,
    Weight = 3,
  },
  CastByUnknown = {
    Type = "Boolean",
    Name = "Cast by unknown",
    Code = "(Object.CasterUnit == nil)",
    Order = true,
    Filter = true,
    Weight = 1,
  },
  TargetIsHostile = {
    Type = "Boolean",
    Name = "Unit Is hostile",
    Code = "(Object.Unit and UnitIsEnemy(\"player\", Object.Unit) == true)",
    Order = false,
    Filter = true,
    Weight = 3,
  },
  CastByHostile = {
    Type = "Boolean",
    Name = "Cast by hostile",
    Code = "(Object.CasterUnit and UnitIsEnemy(\"player\", Object.CasterUnit) == true)",
    Order = true,
    Filter = true,
    Weight = 3,
  },
  TargetIsFriendly = {
    Type = "Boolean",
    Name = "Unit Is friendly",
    Code = "(Object.Unit and UnitIsFriend(\"player\", Object.Unit) == true)",
    Order = false,
    Filter = true,
    Weight = 3,
  },
  CastByFriendly = {
    Type = "Boolean",
    Name = "Cast by friendly",
    Code = "(Object.CasterUnit and UnitIsFriend(\"player\", Object.CasterUnit) == true)",
    Order = true,
    Filter = true,
    Weight = 3,
  },
  CreationTime = {
    Type = "Float",
    Name = "Creation time",
    Order = true,
    Filter = true,
    Weight = 1,
  },
  ChangingTime = {
    Type = "Float",
    Name = "Changing time",
    Order = true,
    Filter = true,
    Weight = 1,
  },
  DetectionTime = {
    Type = "Float",
    Name = "Detection time",
    Order = true,
    Filter = true,
    Weight = 1,
  },
  Unit = {
    Type = "String",
    Name = "Unit",
    List = {
      player = "Player",
      target = "Target",
      targettarget = "Target's Target",
      focus = "Focus",
      focustarget = "Focus Target",
      pet = "Pet",
      pettarget = "Pet Target",
      vehicle = "Vehicle",
      vehicletarget = "Vehicle Target",
      mouseover = "Mouseover",
      test = "Test",
      party = "Party Members",
      partytarget = "Party Targets",
      partypet = "Party Pets",
      boss = "Bosses",
      bosstarget = "Boss Targets",
      arena = "Arenateam Members",
      arenatargets = "Arenateam Targets",
      raid = "Raid Members",
      raidtarget = "Raid Targets",
      raidpet = "Raid Pets",
    },
    Order = true,
    Filter = true,
    Weight = 3,
  },
  RealUnit = {
    Type = "String",
    Name = "Real Unit",
    List = {
      party1 = "Party Member 1",
      party1target = "Party Member 1's Target",
      partypet1 = "Party Member 1's Pet",
      party2 = "Party Member 2",
      party2target = "Party Member 2's Target",
      partypet2 = "Party Member 2's Pet",
      party3 = "Party Member 3",
      party3target = "Party Member 3's Target",
      partypet3 = "Party Member 3's Pet",
      party4 = "Party Member 4",
      party4target = "Party Member 4's Target",
      partypet4 = "Party Member 4's Pet",
      boss1 = "Boss 1",
      boss1target = "Boss 1's Target",
      boss2 = "Boss 2",
      boss2target = "Boss 2's Target",
      boss3 = "Boss 3",
      boss3target = "Boss 3's Target",
      boss4 = "Boss 4",
      boss4target = "Boss 4's Target",
      arena1 = "Arena Member 1",
      arena1target = "Arena Member 1's Target",
      arena2 = "Arena Member 2",
      arena2target = "Arena Member 2's Target",
      arena3 = "Arena Member 3",
      arena3target = "Arena Member 3's Target",
      arena4 = "Arena Member 4",
      arena4target = "Arena Member 4's Target",
      arena5 = "Arena Member 5",
      arena5target = "Arena Member 5's Target",
    },
    Order = true,
    Filter = true,
    Weight = 3,
  },
  CastByGroupPet = {
    Type = "Boolean",
    Name = "Cast by group pet",
    Code = "(Object.CasterUnit and (Object.CasterUnit == \"pet\" or string.match(Object.CasterUnit, \"partypet%d\") or string.match(Object.CasterUnit, \"raidpet%d\") or string.match(Object.CasterUnit, \"arenapet%d\")) and true or false)",
    Order = false,
    Filter = true,
    Weight = 4,
  },
  Specialization = {
    Type = "Number",
    Name = "Specialization",
    List = {
      [1] = "Primary",
      [2] = "Secondary",
    },
    Code = "GetActiveSpecGroup()",
    Order = false,
    Filter = true,
    Dynamic = true,
    Weight = 4,
  },
};


-----------------------------------------------------------------
-- Function DumpAura
-----------------------------------------------------------------
function AuraFrames:DumpAura(Aura)

  local List = {};
  
  for Key, Definition in pairs(AuraFrames.AuraDefinition) do
  
    tinsert(List, {Key = Key, Definition = Definition});
  
  end
  
  sort(List, function(Item1, Item2)
  
    return Item1.Definition.Name < Item2.Definition.Name;
  
  end);

  self:Print("--------------------");
  
  for _, Item in ipairs(List) do
  
    local Key, Definition = Item.Key, Item.Definition;
  
    local Value;
    local Error = false;
  
    if Definition.Code then
    
      local Function, ErrorMessage = loadstring("return function(Object) return "..Definition.Code.."; end;");
    
      if Function then
      
        local Condition = Function();
        local Status;
        Status, Value = pcall(Condition, Aura);
      
        if Status ~= true then
          Value = "Failed to execute the condition code! Error Message: "..Value;
          Error = true;
        end
      
      else
      
        Value = "Failed to load the condition code! Error Message: "..ErrorMessage;
        Error = true;
      
      end
    
    else
    
      Value = Aura[Key];
    
    end
    
    if Error == false and Definition.List then
    
      if not Definition.List[Value] then
        Error = true;
        Value = tostring(Value).." (failed to lookup in the list)";
      else
        Value = Definition.List[Value];
      end
    
    end
    
    if Error == true then
      self:Print("|cff00ffff"..Definition.Name.." |cffffffff- |cffff0000Error |cffffffff= |cffff0000"..tostring(Value).."|r");
    else
    
      if Definition.Type == "SpellId" then
      
        self:Print("|cff00ffff"..Definition.Name.." |cffffffff= |cff00ff00|Hspell:"..tostring(Value).."|h"..tostring(Value).."|h|r");
     
      elseif Definition.Type == "ItemId" then
      
        self:Print("|cff00ffff"..Definition.Name.." |cffffffff= |cff00ff00|Hitem:"..tostring(Value).."|h"..tostring(Value).."|h|r");
      
      else
      
        self:Print("|cff00ffff"..Definition.Name.." |cffffffff= |cff00ff00"..tostring(Value).."|r");
      
      end
      
    end
    
  end

  self:Print("--------------------");

end
