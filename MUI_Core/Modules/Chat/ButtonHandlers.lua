-- luacheck: ignore MayronUI self 143
local MayronUI = _G.MayronUI;
local tk, _, em, _, _, L = MayronUI:GetCoreComponents();
local obj = _G.MayronObjects:GetFramework();

---@class ChatFrame
local _, C_ChatModule = MayronUI:ImportModule("ChatModule");
local C_ChatFrame = obj:Import("MayronUI.ChatModule.ChatFrame");

local LoadAddOn, IsTrialAccount, IsInGuild, UnitLevel, UnitInBattleground =
  _G.LoadAddOn, _G.IsTrialAccount, _G.IsInGuild, _G.UnitLevel, _G.UnitInBattleground;
local InCombatLockdown, ipairs = _G.InCombatLockdown, _G.ipairs;

local ToggleGuildFrame;
if (tk:IsRetail()) then
  ToggleGuildFrame = _G.ToggleGuildFrame;
else
  local ToggleFriendsFrame = _G.ToggleFriendsFrame;
  ToggleGuildFrame = function() ToggleFriendsFrame(2) end
end

-- GLOBALS:
--[[ luacheck: ignore
ToggleCharacter ContainerFrame1 ToggleBackpack OpenAllBags ToggleFrame SpellBookFrame PlayerTalentFrame MacroFrame
ToggleFriendsFrame ToggleHelpFrame TogglePVPUI ToggleAchievementFrame ToggleCalendar ToggleQuestLog
ToggleLFDParentFrame ToggleRaidFrame ToggleEncounterJournal ToggleCollectionsJournal ToggleWorldMap
ToggleWorldStateScoreFrame TalentFrame
]]

local buttonKeys = {
  Character   = L["Character"],
  Bags        = L["Bags"],
  Friends     = L["Friends"],
  Guild       = L["Guild"],
  HelpMenu    = L["Help Menu"],
  SpellBook   = L["Spell Book"],
  Talents     = L["Talents"],
  Raid        = L["Raid"],
  Macros      = L["Macros"],
  WorldMap    = L["World Map"],
  QuestLog    = L["Quest Log"],
  Reputation  = L["Reputation"],
  PVPScore    = L["PVP Score"],
  Skills    = "Skills"
};

if (not tk:IsRetail()) then
  C_ChatModule.Static.ButtonNames = {
    L["Character"],
    L["Bags"],
    L["Friends"],
    L["Guild"],
    L["Help Menu"],
    L["Spell Book"],
    L["Talents"],
    L["Raid"],
    L["Macros"],
    L["World Map"],
    L["Quest Log"],
    L["Reputation"],
    L["PVP Score"],
    L["Skills"]
  };

  if (tk:IsWrathClassic()) then
    table.insert(C_ChatModule.Static.ButtonNames, 8, L["Achievements"]);
    table.insert(C_ChatModule.Static.ButtonNames, 9, L["Glyphs"]);
    table.insert(C_ChatModule.Static.ButtonNames, 10, L["Calendar"]);
    buttonKeys.Achievements = L["Achievements"];
    buttonKeys.Glyphs = L["Glyphs"];
    buttonKeys.Calendar = L["Calendar"];
  end
else
  C_ChatModule.Static.ButtonNames = {
    L["Character"],
    L["Bags"],
    L["Friends"],
    L["Guild"],
    L["Help Menu"],
    L["PVP"],
    L["Spell Book"],
    L["Talents"],
    L["Achievements"],
    L["Glyphs"],
    L["Calendar"],
    L["LFD"],
    L["Raid"],
    L["Encounter Journal"],
    L["Collections Journal"],
    L["Macros"],
    L["World Map"],
    L["Quest Log"],
    L["Reputation"],
    L["PVP Score"],
    L["Currency"],
    L["Skills"]
  };

  buttonKeys.PVP = L["PVP"];
  buttonKeys.Achievements = L["Achievements"];
  buttonKeys.Calendar = L["Calendar"];
  buttonKeys.LFD = L["LFD"];
  buttonKeys.Currency = L["Currency"];
  buttonKeys.EncounterJournal = L["Encounter Journal"];
  buttonKeys.CollectionsJournal = L["Collections Journal"];
end

local clickHandlers = {};

-- Character
clickHandlers[buttonKeys.Character] = function()
  ToggleCharacter("PaperDollFrame");
end

-- Bags
clickHandlers[buttonKeys.Bags] = function()
  if (ContainerFrame1:IsVisible()) then
    ToggleBackpack();
  else
    OpenAllBags();
  end
end

-- Friends
clickHandlers[buttonKeys.Friends] = function()
  ToggleFriendsFrame(_G.FRIEND_TAB_FRIENDS);
end

-- Guild
clickHandlers[buttonKeys.Guild] = function()
  if (IsTrialAccount()) then
    tk:Print(L["Starter Edition accounts cannot perform this action."]);
  elseif (IsInGuild()) then
    ToggleGuildFrame();
  else
    tk:Print("You need to be in a guild to perform this action.");
  end
end

-- Help Menu
clickHandlers[buttonKeys.HelpMenu] = ToggleHelpFrame;

if (tk:IsRetail()) then
  -- PVP
  clickHandlers[buttonKeys.PVP] = function()
    if (UnitLevel("player") < 10) then
      tk:Print(L["Requires level 10+ to view the PVP window."]);
    else
      TogglePVPUI();
    end
  end
end

-- Spell Book
clickHandlers[buttonKeys.SpellBook] = function()
    ToggleFrame(SpellBookFrame);
end

-- Talents
clickHandlers[buttonKeys.Talents] = function()
  if (UnitLevel("player") < SHOW_TALENT_LEVEL) then
    tk:Print(L["Must be level 10 or higher to use Talents."]);
  else
    ToggleTalentFrame();
  end
end

-- Raid
clickHandlers[buttonKeys.Raid] = ToggleRaidFrame;

if (tk:IsRetail() or tk:IsWrathClassic()) then
  -- Achievements
  clickHandlers[buttonKeys.Achievements] = ToggleAchievementFrame;

    -- Calendar
  clickHandlers[buttonKeys.Calendar] = ToggleCalendar;

  if (tk:IsWrathClassic() and 
    obj:IsNumber(SHOW_INSCRIPTION_LEVEL) and 
    obj:IsFunction(ToggleGlyphFrame)) then
    -- Glyphs
    clickHandlers[buttonKeys.Glyphs] = function()
      if (UnitLevel("player") < SHOW_INSCRIPTION_LEVEL) then
        tk:Print(L["Must be level 10 or higher to use Talents."]);
      else
        ToggleGlyphFrame();
      end
    end
  end
end

if (tk:IsRetail()) then
  -- LFD
  clickHandlers[buttonKeys.LFD] = ToggleLFDParentFrame;

  -- Encounter Journal
  clickHandlers[buttonKeys.EncounterJournal] = ToggleEncounterJournal;

  -- Collections Journal
  clickHandlers[buttonKeys.CollectionsJournal] = function()
      ToggleCollectionsJournal();
  end

  -- Currency
  clickHandlers[buttonKeys.Currency] = function()
    ToggleCharacter("TokenFrame");
  end
end

-- -- Macros
clickHandlers[buttonKeys.Macros] = function()
    if (not MacroFrame) then
        LoadAddOn("Blizzard_MacroUI");
    end

    ToggleFrame(MacroFrame);
end

-- World Map
clickHandlers[buttonKeys.WorldMap] = ToggleWorldMap;

-- Quest Log
clickHandlers[buttonKeys.QuestLog] = ToggleQuestLog;

-- Repuation
clickHandlers[buttonKeys.Reputation] = function()
    ToggleCharacter("ReputationFrame");
end

-- PVP Score
clickHandlers[buttonKeys.PVPScore] = function()
    if (not UnitInBattleground("player")) then
        tk:Print(L["Requires being inside a Battle Ground."]);
    else
        ToggleWorldStateScoreFrame();
    end
end

-- Skill
clickHandlers[buttonKeys.Skills] = function()
  ToggleCharacter("SkillFrame");
end

local function ChatButton_OnClick(self)
  if (_G.InCombatLockdown()) then
    tk:Print(L["Cannot toggle menu while in combat."]);
    return;
  end

  clickHandlers[self:GetText()]();
end

local function ChatFrame_OnModifierStateChanged(_, _, data)
  if (data.chatModuleSettings.swapInCombat or not InCombatLockdown()) then
    for _, buttonStateData in ipairs(data.settings.buttons) do
      if (not buttonStateData.key or tk:IsModComboActive(buttonStateData.key)) then
        data.buttons[1]:SetText(buttonStateData[1]);
        data.buttons[2]:SetText(buttonStateData[2]);
        data.buttons[3]:SetText(buttonStateData[3]);
      end
    end
  end
end

obj:DefineParams("table")
function C_ChatFrame:SetUpButtonHandler(data, buttonSettings)
  data.settings.buttons = buttonSettings;

  local listenerID = data.anchorName.."_OnModifierStateChanged";
  local listener = em:GetEventListenerByID(listenerID) or em:CreateEventListenerWithID(listenerID, ChatFrame_OnModifierStateChanged);

  listener:SetCallbackArgs(data);
  listener:RegisterEvent("MODIFIER_STATE_CHANGED");
  em:TriggerEventListenerByID(listenerID);

  data.buttons[1]:SetScript("OnClick", ChatButton_OnClick);
  data.buttons[2]:SetScript("OnClick", ChatButton_OnClick);
  data.buttons[3]:SetScript("OnClick", ChatButton_OnClick);
end