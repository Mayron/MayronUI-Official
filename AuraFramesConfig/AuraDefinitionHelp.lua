local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");

local AuraDefinitionHelp = {
  Type = [=[Contains the type of an aura.

|cffe0b800Harmful|r: Debuffs on any unit.
|cffe0b800Helpful|r: Buffs on any unit.
|cffe0b800Weapon enchantment|r: Your own weapon enchantment.
|cffe0b800Spell Cooldown|r: Any spell cooldown (does not include internal cooldowns or talent cooldowns).
|cffe0b800Item Cooldown|r: Any item cooldown (does not include internal item cooldowns).
|cffe0b800Internal Item Cooldown|r: Any recognized internal item cooldown (does not include item cooldowns).
|cffe0b800Totem|r: Any totem that the Shaman have up.
|cffe0b800Boss Mod Alert|r: Any detected alert that can be used for an aura.]=],
  Name = "Contains the Name of an aura. For a spell it is equel to the spell name, for an item it is equel to the item name. In some cases spell name and item name can be used on the aura, if that happens then the name will be used for displaying the aura.",
  SpellName = "Contains the Spell Name that the aura is based on.",
  ItemName = "Contains the Item Name that the aura is based on",
  Icon = "Contains the link to the Icon of the aura.",
  Count = "Contains the stack count of a buff/debuff/weapon enchantment.",
  Classification = "Contains the debuff type of an aura.",
  Duration = "Contains the original duration of of an aura. If the original duration can not be retrieved during detection of a new aura, then the time left will be used and not be updated after detection.",
  Remaining = "Contains the time left on a aura.",
  ExpirationTime = "Absolute time when the aura expires. To aura's without an duration, have an expiration time of 0 (zero)",
  IsAura = "Any aura without an expiration time (expiration time = 0).",
  CasterUnit = "The unit name of the caster of an aura.",
  CasterName = "The name of the caster of an aura.",
  CasterClass = "The class of the caster of an aura",
  SpellId = "Contains the spell id of an aura. The spell id can be used to quickly filter on spells.",
  ItemId = "Contains the item id of an aura. The item id can be used to quickly filter on items.",
  CastByMe = "Any aura that is cast by you.",
  IsStealable = "Can the aura be stolen by anyone.",
  CastByParty = "Any aura that is cast by you or your party",
  CastByRaid = "Any aura that is cast by you or your raid.",
  CastByPlayer = "Any aura that is cast by player (person).",
  CastByMyPet = "Any aura that is cast by your pet.",
  CastByUnknown = "Any aura that can not be detected who have cast it.",
  TargetIsHostile = "Any aura on a unit that is hostile towards you.",
  CastByHostile = "Any aura that is cast by a unit that is hostile towards you.",
  TargetIsFriendly = "Any aura on a unit that is friendly towards you.",
  CastByFriendly = "Any aura that is cast by a unit that is friendly towards you.",
  CreationTime = "The absolute time the aura is created on the server (ExpirationTime - Duration). If not able to calculate, then the value will be equel to detection time.",
  ChangingTime = "The absolute time the aura data is changed in the addon.",
  DetectionTime = "The absolute time the aura is detected in the addon.",
  Unit = "The unit the aura is cast on. The units with Party, Boss, Arenateam or Raid in the name are groups of units. If you want to specify a single unit of a group, use then \"Real Unit\"",
  RealUnit = "The units with Party, Boss, Arenateam or Raid in the name are groups of units. \"Real Unit\" will for those units contain the real unit and not the group unit.",
  CastByGroupPet = "Any aura that is cast by your pet or an pet from your group/raid/arena group.",
};


local HelpWindow;

-----------------------------------------------------------------
-- Function CreateHelpWindow
-----------------------------------------------------------------
local function CreateHelpWindow()

  if HelpWindow then
    return;
  end

  HelpWindow = AceGUI:Create("Window");
  HelpWindow:Hide();
  HelpWindow:SetTitle("Aura Frames - Help");
  HelpWindow:SetWidth(350);
  HelpWindow:SetHeight(500);
  HelpWindow:EnableResize(true);
  HelpWindow:SetLayout("Fill");

  HelpWindow.frame:ClearAllPoints();
  HelpWindow.frame:SetPoint("TOPLEFT", AuraFramesConfig.Window.frame, "TOPRIGHT");

  local Content = AceGUI:Create("ScrollFrame");
  Content:SetLayout("List");
  AuraFramesConfig:EnhanceContainer(Content);
  HelpWindow:AddChild(Content);

  Content:AddText("Filter and Order Help\n", GameFontNormalLarge);
  Content:AddSpace();
  Content:AddText("You will find here a description of all properties of an aura, even not usable ones for filter or order.");
  Content:AddSpace();


  for Key, Settings in pairs(AuraFrames.AuraDefinition) do

    Content:AddHeader(Settings.Name);
    Content:AddText("Filter: "..(Settings.Filter and "|cff6af36aUsable|r" or "|cfff36a6aNot Usable|r"));
    Content:AddText("Order: "..(Settings.Order and "|cff6af36aUsable|r" or "|cfff36a6aNot Usable|r"));
    Content:AddSpace();
    Content:AddText(AuraDefinitionHelp[Key] or "No help found for "..Settings.Name);
    Content:AddSpace(2);

  end

  Content:AddSpace();

  local ButtonClose = AceGUI:Create("Button");
  ButtonClose:SetText("Close");
  ButtonClose:SetCallback("OnClick", function()
    AuraFramesConfig:AuraDefinitionHelpHide();
  end);
  Content:AddChild(ButtonClose);

end


-----------------------------------------------------------------
-- Function AuraDefinitionHelpShow
-----------------------------------------------------------------
function AuraFramesConfig:AuraDefinitionHelpShow()

  CreateHelpWindow();
  HelpWindow:Show();

end

-----------------------------------------------------------------
-- Function AuraDefinitionHelpHide
-----------------------------------------------------------------
function AuraFramesConfig:AuraDefinitionHelpHide()

  if HelpWindow then
    HelpWindow:Hide();
  end

end
