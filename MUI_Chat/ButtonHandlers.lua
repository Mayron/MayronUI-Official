-- luacheck: ignore MayronUI self 143

local _, namespace = ...;
local C_ChatFrame = namespace.C_ChatFrame;
local Engine = namespace.Engine;
local tk, _, em, _, _, L = MayronUI:GetCoreComponents();

local _G = _G;
local LoadAddOn, ToggleCharacter, ToggleBackpack, OpenAllBags, ContainerFrame1, IsTrialAccount, IsInGuild,
ToggleGuildFrame, ToggleFriendsFrame, ToggleHelpFrame, UnitLevel, TogglePVPUI, ToggleFrame, ToggleWorldMap,
ToggleAchievementFrame, ToggleCalendar, ToggleLFDParentFrame, ToggleRaidFrame, ToggleEncounterJournal,
ToggleQuestLog, UnitInBattleground, ToggleWorldStateScoreFrame, ToggleCollectionsJournal =
_G.LoadAddOn, _G.ToggleCharacter, _G.ToggleBackpack, _G.OpenAllBags, _G.ContainerFrame1, _G.IsTrialAccount,
_G.IsInGuild, _G.ToggleGuildFrame, _G.ToggleFriendsFrame, _G.ToggleHelpFrame, _G.UnitLevel, _G.TogglePVPUI,
_G.ToggleFrame, _G.ToggleWorldMap, _G.ToggleAchievementFrame, _G.ToggleCalendar, _G.ToggleLFDParentFrame,
_G.ToggleRaidFrame, _G.ToggleEncounterJournal, _G.ToggleQuestLog, _G.UnitInBattleground, _G.ToggleWorldStateScoreFrame,
_G.ToggleCollectionsJournal;

local SpellBookFrame = _G.SpellBookFrame;
local PlayerTalentFrame, MacroFrame = _G.PlayerTalentFrame, _G.MacroFrame;

namespace.ButtonNames = {
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
    L["Currency"]
}

local clickHandlers = {};

-- Character
clickHandlers[namespace.ButtonNames[1]] = function()
    ToggleCharacter("PaperDollFrame");
end

-- Bags
clickHandlers[namespace.ButtonNames[2]] = function()
    if (ContainerFrame1:IsVisible()) then
        ToggleBackpack();
    else
        OpenAllBags();
    end
end

-- Friends
clickHandlers[namespace.ButtonNames[3]] = ToggleFriendsFrame;

-- Guild
clickHandlers[namespace.ButtonNames[4]] = function()
    if (IsTrialAccount()) then
        tk:Print(L["Starter Edition accounts cannot perform this action."]);

    elseif (IsInGuild()) then
        ToggleGuildFrame();
    end
end

-- Help Menu
clickHandlers[namespace.ButtonNames[5]] = ToggleHelpFrame;

-- PVP
clickHandlers[namespace.ButtonNames[6]] = function()
    if (UnitLevel("player") < 10) then
        tk:Print(L["Requires level 10+ to view the PVP window."]);
    else
        TogglePVPUI();
    end
end

-- Spell Book
clickHandlers[namespace.ButtonNames[7]] = function()
    ToggleFrame(SpellBookFrame);
end

-- Talents
clickHandlers[namespace.ButtonNames[8]] = function()
    if (UnitLevel("player") < 10) then
        tk:Print(L["Must be level 10 or higher to use Talents."]);
    else
        if (not PlayerTalentFrame) then
            LoadAddOn("Blizzard_TalentUI");
            PlayerTalentFrame = _G.PlayerTalentFrame;
        end
        ToggleFrame(PlayerTalentFrame);
    end
end

-- Achievements
clickHandlers[namespace.ButtonNames[9]] = ToggleAchievementFrame;

-- Glyphs -- TODO: I think this is broke
clickHandlers[namespace.ButtonNames[10]] = function()
    if (UnitLevel("player") < 10) then
        tk:Print(L["Requires level 10+ to view the Glyphs window."]);
    else
		ToggleFrame(SpellBookFrame);
    end
end

-- Calendar
clickHandlers[namespace.ButtonNames[11]] = ToggleCalendar;

-- LFD
clickHandlers[namespace.ButtonNames[12]] = ToggleLFDParentFrame;

-- Raid
clickHandlers[namespace.ButtonNames[13]] = ToggleRaidFrame;

-- Encounter Journal
clickHandlers[namespace.ButtonNames[14]] = ToggleEncounterJournal;

-- Collections Journal
clickHandlers[namespace.ButtonNames[15]] = function()
    ToggleCollectionsJournal();
end

-- -- Macros
clickHandlers[namespace.ButtonNames[16]] = function()
    if (not MacroFrame) then
        LoadAddOn("Blizzard_MacroUI");
        MacroFrame = _G.MacroFrame;
    end
    ToggleFrame(MacroFrame);
end

-- World Map
clickHandlers[namespace.ButtonNames[17]] = function()
    ToggleWorldMap();
end

-- Quest Log
clickHandlers[namespace.ButtonNames[18]] = function()
    ToggleQuestLog();
end

-- Repuation
clickHandlers[namespace.ButtonNames[19]] = function()
    ToggleCharacter("ReputationFrame");
end

-- PVP Score
clickHandlers[namespace.ButtonNames[20]] = function()
    if (not UnitInBattleground("player")) then
        tk:Print(L["Requires being inside a Battle Ground."]);
    else
        ToggleWorldStateScoreFrame();
    end
end

-- Currency
clickHandlers[namespace.ButtonNames[21]] = function()
    ToggleCharacter("TokenFrame");
end

local function ChatButton_OnClick(self)
    if (_G.InCombatLockdown()) then
        tk:Print("Cannot toggle menu while in combat.");
        return;
    end

    clickHandlers[self:GetText()]();
end

local function ChatFrame_OnModifierStateChanged(_, _, data)
    if (data.chatModuleSettings.swapInCombat or not _G.InCombatLockdown()) then
        for _, buttonStateData in ipairs(data.settings.buttons) do
            if (not buttonStateData.key or (buttonStateData.key and tk:IsModComboActive(buttonStateData.key))) then
                data.buttons[1]:SetText(buttonStateData[1]);
                data.buttons[2]:SetText(buttonStateData[2]);
                data.buttons[3]:SetText(buttonStateData[3]);
            end
        end
    end
end

Engine:DefineParams("table")
function C_ChatFrame:SetUpButtonHandler(data, buttonSettings)
    data.settings.buttons = buttonSettings;

    em:CreateEventHandlerWithKey("MODIFIER_STATE_CHANGED", data.anchorName.."_OnModifierStateChanged",
        ChatFrame_OnModifierStateChanged, data):Run();

    data.buttons[1]:SetScript("OnClick", ChatButton_OnClick);
    data.buttons[2]:SetScript("OnClick", ChatButton_OnClick);
    data.buttons[3]:SetScript("OnClick", ChatButton_OnClick);
end