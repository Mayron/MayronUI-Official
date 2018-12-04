-- Setup namespaces ------------------
local addOnName, namespace = ...;
local C_ChatModule = namespace.C_ChatModule;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();
--------------------------------------

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
        if (not tk._G["PlayerTalentFrame"]) then
            tk.LoadAddOn("Blizzard_TalentUI");
        end
        ToggleFrame(PlayerTalentFrame);
    end
end

-- Achievements
clickHandlers[namespace.ButtonNames[9]] = ToggleAchievementFrame;

-- Glyphs
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
    if (not _G["CollectionsJournal"]) then
        LoadAddOn("Blizzard_Collections");
    end
    ToggleFrame(CollectionsJournal);
end

-- Macros
clickHandlers[namespace.ButtonNames[16]] = function()
    if (not MacroFrame) then
        LoadAddOn("Blizzard_MacroUI");
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
    local text = self:GetText();
    clickHandlers[text]();
end

function C_ChatModule:SetUpButtonHandler(data, muiChatFrame, buttonSettings)
    em:CreateEventHandler("MODIFIER_STATE_CHANGED", function()
        if (data.sv.swapInCombat or not InCombatLockdown()) then
            local updated = false;

            for _, info in buttonSettings:Iterate() do
                if (info.key and tk:IsModComboActive(info.key)) then
                    muiChatFrame.buttons[1]:SetText(info[1]);
                    muiChatFrame.buttons[2]:SetText(info[2]);
                    muiChatFrame.buttons[3]:SetText(info[3]);
                    updated = true;
                    break;
                end
            end

            if (not updated) then
                local info = buttonSettings[1];
                muiChatFrame.buttons[1]:SetText(info[1]);
                muiChatFrame.buttons[2]:SetText(info[2]);
                muiChatFrame.buttons[3]:SetText(info[3]);
            end
        end
    end):Run();

    muiChatFrame.buttons[1]:SetScript("OnClick", ChatButton_OnClick);
    muiChatFrame.buttons[2]:SetScript("OnClick", ChatButton_OnClick);
    muiChatFrame.buttons[3]:SetScript("OnClick", ChatButton_OnClick);
end