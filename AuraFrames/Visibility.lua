local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

-- Import used global references into the local namespace.
local pairs, GetTime, select = pairs, GetTime, select;
local UnitAffectingCombat, GetActiveSpecGroup, IsMounted, UnitInVehicle, GetNumSubgroupMembers = UnitAffectingCombat, GetActiveSpecGroup, IsMounted, UnitInVehicle, GetNumSubgroupMembers;
local GetInstanceInfo, GetNumGroupMembers, UnitInRaid, UnitIsUnit, C_PetBattles = GetInstanceInfo, GetNumGroupMembers, UnitInRaid, UnitIsUnit, C_PetBattles;

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: 


local FadeOutDelay = 0.5;

-----------------------------------------------------------------
-- Local status table
-----------------------------------------------------------------
local Status = {
  InCombat = false,
  OutOfCombat = false,
  PrimaryTalents = false,
  SecondaryTalents = false,
  Mounted = false,
  Vehicle = false,
  Solo = false,
  InInstance = false,
  NotInInstance = false,
  InParty = false,
  InRaid = false,
  InBattleground = false,
  InArena = false,
  FocusEqualsTarget = false,
  InPetBattle = false,
  OnMouseOver = false,
};


-----------------------------------------------------------------
-- Local frames for handling events
-----------------------------------------------------------------
local EventFrame = CreateFrame("Frame");


-----------------------------------------------------------------
-- Function CheckVisibility
-----------------------------------------------------------------
function AuraFrames:CheckVisibility(Container, IsMouseOver)

  Status.OnMouseOver = IsMouseOver or false;

  local Visible = false;

  if AuraFrames.db.profile.HideInPetBattle == true and Status["InPetBattle"] == true then

    Visible = false;

  elseif Container.Config.Visibility.AlwaysVisible == false then
  
    for Key, _ in pairs(Container.Config.Visibility.VisibleWhen) do
    
      if Status[Key] == true then
        
        Visible = true;
        break;
      
      end
    
    end
    
    for Key, _ in pairs(Container.Config.Visibility.VisibleWhenNot) do
    
      if Status[Key] == true then
        
        Visible = false;
        break;
      
      end
    
    end
  
  else
  
    Visible = true;
  
  end
  
  if Container.ContainerVisibility ~= Visible then

    Container.ContainerVisibility = Visible;
    
    if Container.UpdateVisibility then
      Container:UpdateVisibility();
    end

  end

end


-----------------------------------------------------------------
-- Function ProcessStatusChanges
-----------------------------------------------------------------
local function ProcessStatusChanges(Event, Force)

  local StatusChanges = {};

  if Event == "PLAYER_ENTERING_WORLD" then
    Event = "ALL";
  end

  if Event == "ALL" or Event == "PLAYER_REGEN_ENABLED" or Event == "PLAYER_REGEN_DISABLED" then

    StatusChanges.InCombat = UnitAffectingCombat("player") == true;
    StatusChanges.OutOfCombat = not StatusChanges.InCombat;
  
  end
  
  if Event == "ALL" or Event == "ACTIVE_TALENT_GROUP_CHANGED" then
  
    local ActiveGroup = GetActiveSpecGroup(false, false);
  
    StatusChanges.PrimaryTalents = ActiveGroup == 1;
    StatusChanges.SecondaryTalents = ActiveGroup == 2;
  
  end
  
  if Event == "ALL" or Event == "COMPANION_UPDATE" then
  
    StatusChanges.Mounted = IsMounted() == true;
  
  end
  
  if Event == "ALL" or Event == "UNIT_ENTERED_VEHICLE" or Event == "UNIT_EXITED_VEHICLE" then
  
    StatusChanges.Vehicle = UnitInVehicle("player") == true;
  
  end
  
  local InstanceType, NumPartyMembers, InRaid;

  if Event == "ALL" or Event == "GROUP_ROSTER_UPDATE" then -- 2018-07-23 CB: changed from PARTY_MEMBERS_CHANGED

    NumPartyMembers = NumPartyMembers ~= nil and NumPartyMembers or GetNumSubgroupMembers();
  
    StatusChanges.Solo = NumPartyMembers == 0;
  
  end
  
  if Event == "ALL" then
  
    StatusChanges.InInstance = IsInInstance();
    StatusChanges.NotInInstance = not StatusChanges.InInstance;
  
  end
  
  if Event == "ALL" or Event == "GROUP_ROSTER_UPDATE" then -- 2018-07-23 CB: changed from PARTY_MEMBERS_CHANGED
  
    NumPartyMembers = NumPartyMembers ~= nil and NumPartyMembers or GetNumGroupMembers();
    InRaid = InRaid or UnitInRaid("player") ~= nil;
  
    StatusChanges.InParty = NumPartyMembers ~= 0 and InRaid == false;
    
  end
  
  if Event == "ALL" or Event == "GROUP_ROSTER_UPDATE" then -- 2018-07-23 CB: changed from PARTY_MEMBERS_CHANGED
  
    InRaid = InRaid or UnitInRaid("player") ~= nil;
  
    StatusChanges.InRaid = InRaid;
  
  end
  
  if Event == "ALL" then
  
    InstanceType = InstanceType or select(2, GetInstanceInfo());
    
    StatusChanges.InBattleground = InstanceType == "pvp";
  
  end
  
  if Event == "ALL" then
  
    InstanceType = InstanceType or select(2, GetInstanceInfo());
    
    StatusChanges.InArena = InstanceType == "arena";
  
  end
  
  if Event == "ALL" or Event == "PLAYER_FOCUS_CHANGED" or Event == "PLAYER_TARGET_CHANGED" then

    StatusChanges.FocusEqualsTarget = UnitIsUnit("focus", "target") == true;
  
  end

  if Event == "ALL" or Event == "PET_BATTLE_OPENING_START" or Event == "PET_BATTLE_OPENING_DONE" or Event == "PET_BATTLE_CLOSE" then
  
    StatusChanges.InPetBattle = C_PetBattles.IsInBattle() == true;
  
  end
  
  local Changed = false;
  
  for Key, Value in pairs(StatusChanges) do
  
    if Status[Key] ~= Value then
    
      --af:Print(Key, "changed value from", Status[Key], "To", Value);
      
      Status[Key] = Value;
      
      Changed = true;
    
    end
  
  end
  
  if not Changed and Force ~= true then
    return;
  end
  
  local CurrentTime = GetTime();
  
  for _, Container in pairs(AuraFrames.Containers) do
    
    AuraFrames:CheckVisibility(Container);
  
  end
  
end


-----------------------------------------------------------------
-- Script OnEvent
-----------------------------------------------------------------
EventFrame:SetScript("OnEvent", function(_, Event)

  ProcessStatusChanges(Event);

end);


-----------------------------------------------------------------
-- Register Events
-----------------------------------------------------------------
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
EventFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
EventFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
EventFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
EventFrame:RegisterEvent("COMPANION_UPDATE");
EventFrame:RegisterEvent("UNIT_ENTERED_VEHICLE");
EventFrame:RegisterEvent("UNIT_EXITED_VEHICLE");
-- EventFrame:RegisterEvent("PARTY_MEMBERS_CHANGED"); -- 2018-07-18 CB: Removed
EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE"); -- 2018-07-23 CB: Added
EventFrame:RegisterEvent("PLAYER_FOCUS_CHANGED");
EventFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
EventFrame:RegisterEvent("PET_BATTLE_OPENING_START");
EventFrame:RegisterEvent("PET_BATTLE_OPENING_DONE");
EventFrame:RegisterEvent("PET_BATTLE_CLOSE");
