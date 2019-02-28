-----------------------------------------------------------------
--
--  File: Totems.lua
--
--  Author: Alex <Nexiuz> Elderson
--
--  Description:
--
--
--  Todo:
--
--
--
-----------------------------------------------------------------


local LibAura = LibStub("LibAura-1.0");

local Major, Minor = "Totems-1.0", 0;
local Module = LibAura:NewModule(Major, Minor);

if not Module then return; end -- No upgrade needed.

-- Import used global references into the local namespace.
local pairs, ipairs, tinsert = pairs, ipairs, tinsert;
local UnitName, GetSpellInfo, GetTotemInfo, GetSpellBookItemInfo = UnitName, GetSpellInfo, GetTotemInfo, GetSpellBookItemInfo;

-- Make sure that we dont have old unit/types if we upgrade.
LibAura:UnregisterModuleSource(Module, nil, nil);

-- Register the test unit/types.
LibAura:RegisterModuleSource(Module, "player", "TOTEM");


-----------------------------------------------------------------
-- Function Enable
-----------------------------------------------------------------
function Module:Enable()

  -- For the sake of ppl that wining about addon memory... We create the db table when we are getting enabled.

  -- Internal db used for storing auras.
  self.db = {
    [1] = {
      Id = "PlayerTOTEM1",
      Active = false, -- Used internaly to see if its an active totem.
      Type = "TOTEM",
      Index = 1,
      Unit = "player",
      Classification = "None",
      CasterUnit = "player",
      CasterName = UnitName("player"),
      IsStealable = false,
      IsCancelable = true,
      IsDispellable = false,
      Count = 0,
      ItemId = 0,
    },
    [2] = {
      Id = "PlayerTOTEM2",
      Active = false, -- Used internaly to see if its an active totem.
      Type = "TOTEM",
      Index = 2,
      Unit = "player",
      Classification = "None",
      CasterUnit = "player",
      CasterName = UnitName("player"),
      IsStealable = false,
      IsCancelable = true,
      IsDispellable = false,
      Count = 0,
      ItemId = 0,
    },
    [3] = {
      Id = "PlayerTOTEM3",
      Active = false, -- Used internaly to see if its an active totem.
      Type = "TOTEM",
      Index = 3,
      Unit = "player",
      Classification = "None",
      CasterUnit = "player",
      CasterName = UnitName("player"),
      IsStealable = false,
      IsCancelable = true,
      IsDispellable = false,
      Count = 0,
      ItemId = 0,
    },
    [4] = {
      Id = "PlayerTOTEM4",
      Active = false, -- Used internaly to see if its an active totem.
      Type = "TOTEM",
      Index = 4,
      Unit = "player",
      Classification = "None",
      CasterUnit = "player",
      CasterName = UnitName("player"),
      IsStealable = false,
      IsCancelable = true,
      IsDispellable = false,
      Count = 0,
      ItemId = 0,
    },
  };

end



-----------------------------------------------------------------
-- Function Disable
-----------------------------------------------------------------
function Module:Disable()

  self.db = nil;

end


-----------------------------------------------------------------
-- Function ActivateSource
-----------------------------------------------------------------
function Module:ActivateSource(Unit, Type)
  
  LibAura:RegisterEvent("PLAYER_TOTEM_UPDATE", self, self.Update);
  self:Update();
  
end

-----------------------------------------------------------------
-- Function DeactivateSource
-----------------------------------------------------------------
function Module:DeactivateSource(Unit, Type)
  
  for _, Aura in ipairs(self.db) do
  
    if Aura.Active == true then
      LibAura:FireAuraOld(Aura);
      Aura.Active = false;
    end
  
  end
  
  LibAura:UnregisterEvent("PLAYER_TOTEM_UPDATE", self, self.Update);

end

-----------------------------------------------------------------
-- Function GetAuras
-----------------------------------------------------------------
function Module:GetAuras(Unit, Type)
  
  local Auras = {};
  
  for _, Aura in ipairs(self.db) do
  
    if Aura.Active == true then
      tinsert(Auras, Aura);
    end
  
  end

  return Auras;

end


-----------------------------------------------------------------
-- Function Update
-----------------------------------------------------------------
function Module:Update()
  
  for i = 1, 4 do
  
    local Aura = self.db[i];
  
    local _, TotemName, StartTime, Duration, Icon = GetTotemInfo(i);
    
    if TotemName and TotemName ~= "" then
    
      if self.db[i].Active ~= true or Aura.TotemName ~= TotemName or Aura.ExpirationTime ~= (StartTime + Duration) then
      
        if Aura.Active == true then
          -- If we had an active totem, then fire aura old event before updating the aura.
          LibAura:FireAuraOld(Aura);
          Aura.Active = false;
        end
        
        local _, SpellId = GetSpellBookItemInfo(TotemName);
        
        if SpellId then
        
          Aura.TotemName = TotemName;
          Aura.ExpirationTime = StartTime + Duration;
          Aura.Duration = Duration;
          Aura.SpellId = SpellId;
          Aura.Name = TotemName;
          Aura.Icon = Icon;
          Aura.Active = true;
          
          if StartTime then
            Aura.CreationTime = StartTime;
          end
          
          LibAura:FireAuraNew(Aura);
          
        end
        
      end
    
    elseif Aura.Active == true then
    
      Aura.Active = false;
      LibAura:FireAuraOld(Aura);
    
    end
  
  end

end


