-- Setup namespaces ------------------
local addOnName, namespace = ...;
local ChatClass = namespace.ChatClass;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();
--------------------------------------

local clickHandlers = {};

clickHandlers[L["Character"]] = function()
    ToggleCharacter("PaperDollFrame");
end

clickHandlers[L["Bags"]] = function()
    if (ContainerFrame1:IsVisible()) then
        ToggleBackpack();
    else
        OpenAllBags();
    end
end

clickHandlers[L["Friends"]] = ToggleFriendsFrame;

clickHandlers[L["Guild"]] = function()
    if (IsTrialAccount()) then
        tk:Print(L["Starter Edition accounts cannot perform this action."]);
    elseif (IsInGuild()) then
        ToggleGuildFrame();
    end
end

clickHandlers[L["Help Menu"]] = ToggleHelpFrame;

clickHandlers[L["PVP"]] = function()
    if (UnitLevel("player") < 10) then
        tk:Print(L["Requires level 10+ to view the PVP window."]);
    else
        TogglePVPUI();
    end
end

clickHandlers[L["Spell Book"]] = function()
    ToggleFrame(SpellBookFrame);
end

clickHandlers[L["Talents"]] = function()
    if (UnitLevel("player") < 10) then
        tk:Print(L["Must be level 10 or higher to use Talents."]);
    else
        if (not tk._G["PlayerTalentFrame"]) then
            tk.LoadAddOn("Blizzard_TalentUI");
        end
        ToggleFrame(PlayerTalentFrame);
    end
end

clickHandlers[L["Achievements"]] = ToggleAchievementFrame;

clickHandlers[L["Glyphs"]] = function()
    if (UnitLevel("player") < 10) then
        tk:Print(L["Requires level 10+ to view the Glyphs window."]);
    else
		ToggleFrame(SpellBookFrame);
    end
end

clickHandlers[L["Calendar"]] = ToggleCalendar;

clickHandlers[L["LFD"]] = ToggleLFDParentFrame;

clickHandlers[L["Raid"]] = ToggleRaidFrame;

clickHandlers[L["Encounter Journal"]] = ToggleEncounterJournal;

clickHandlers[L["Collections Journal"]] = function()
    if (not tk._G["CollectionsJournal"]) then
        tk.LoadAddOn("Blizzard_Collections");
    end
    ToggleFrame(CollectionsJournal);
end

clickHandlers[L["Macros"]] = function()
    if (not MacroFrame) then
        tk.LoadAddOn("Blizzard_MacroUI");
    end
    ToggleFrame(MacroFrame);
end

clickHandlers[L["World Map"]] = function()
    ToggleWorldMap();
end

clickHandlers[L["Quest Log"]] = function()
    ToggleQuestLog();
end

clickHandlers[L["Reputation"]] = function()
    ToggleCharacter("ReputationFrame");
end

clickHandlers[L["PVP Score"]] = function()
    if (not UnitInBattleground("player")) then
        tk:Print(L["Requires being inside a Battle Ground."]);
    else
        ToggleWorldStateScoreFrame();
    end
end

clickHandlers[L["Currency"]] = function()
    ToggleCharacter("TokenFrame");
end

local function ChatButton_OnClick(self)
    local text = self:GetText();
    clickHandlers[text]();
end

function ChatClass:SetUpButtonHandler(data, anchorName, buttonID, button)
    local muiChatFrame = data.chatFrames[anchorName];    

    if (not data.sv[anchorName]) then
        data.sv[anchorName] = {};
    end

    data.sv[anchorName]:SetParent(data.sv.templateMuiChatFrame);
    local buttonSettings = data.sv[anchorName].buttons;

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