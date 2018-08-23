------------------------
-- Setup namespaces
------------------------
local _, chat = ...;
local core = MayronUI:ImportModule("MUI_Core");
local em = core.EventManager;
local tk = core.Toolkit;
local L = LibStub ("AceLocale-3.0"):GetLocale ("MayronUI");
local private = {};

------------------------
-- toggle functions
------------------------
private.toggle = {};

private.toggle[L["Character"]] = function()
    ToggleCharacter("PaperDollFrame");
end

private.toggle[L["Bags"]] = function()
    if (ContainerFrame1:IsVisible()) then
        ToggleBackpack();
    else
        OpenAllBags();
    end
end

private.toggle[L["Friends"]] = ToggleFriendsFrame;

private.toggle[L["Guild"]] = function()
    if (IsTrialAccount()) then
        tk:Print(L["Starter Edition accounts cannot perform this action."]);
    elseif (IsInGuild()) then
        ToggleGuildFrame();
    end
end

private.toggle[L["Help Menu"]] = ToggleHelpFrame;

private.toggle[L["PVP"]] = function()
    if (UnitLevel("player") < 10) then
        tk:Print(L["Requires level 10+ to view the PVP window."]);
    else
        TogglePVPUI();
    end
end

private.toggle[L["Spell Book"]] = function()
    ToggleFrame(SpellBookFrame);
end

private.toggle[L["Talents"]] = function()
    if (UnitLevel("player") < 10) then
        tk:Print(L["Must be level 10 or higher to use Talents."]);
    else
        if (not tk._G["PlayerTalentFrame"]) then
            tk.LoadAddOn("Blizzard_TalentUI");
        end
        ToggleFrame(PlayerTalentFrame);
    end
end

private.toggle[L["Achievements"]] = ToggleAchievementFrame;

private.toggle[L["Glyphs"]] = function()
    if (UnitLevel("player") < 10) then
        tk:Print(L["Requires level 10+ to view the Glyphs window."]);
    else
		-- ToggleGlyphFrame(); -- Glyph Frame is combined to the spellbook
		ToggleFrame(SpellBookFrame);
    end
end

private.toggle[L["Calendar"]] = ToggleCalendar;

private.toggle[L["LFD"]] = ToggleLFDParentFrame;

private.toggle[L["Raid"]] = ToggleRaidFrame;

private.toggle[L["Encounter Journal"]] = ToggleEncounterJournal;

private.toggle[L["Collections Journal"]] = function()
    if (not tk._G["CollectionsJournal"]) then
        tk.LoadAddOn("Blizzard_Collections");
    end
    ToggleFrame(CollectionsJournal);
end

private.toggle[L["Macros"]] = function()
    if (not MacroFrame) then
        tk.LoadAddOn("Blizzard_MacroUI");
    end
    ToggleFrame(MacroFrame);
end

private.toggle[L["Map / Quest Log"]] = function()
    ToggleFrame(WorldMapFrame);
end
private.toggle[L["Reputation"]] = function()
    ToggleCharacter("ReputationFrame");
end

private.toggle[L["PVP Score"]] = function()
    if (not UnitInBattleground("player")) then
        tk:Print(L["Requires being inside a Battle Ground."]);
    else
        ToggleWorldStateScoreFrame();
    end
end

private.toggle[L["Currency"]] = function()
    ToggleCharacter("TokenFrame");
end

do
    local function ChatButton_OnClick(self)
        local text = self:GetText();
        if (private.toggle[text]) then
            private.toggle[text]();
        end
    end

    function chat:InitializeChatButtons()
        em:CreateEventHandler("MODIFIER_STATE_CHANGED", function()
            for _, data in chat.sv.data:Iterate() do
                if (chat.sv.enabled[data.name]) then
                    if (data.combat_swap or not tk.InCombatLockdown()) then
                        local cf = chat.chat_frames[data.name];
                        local changed;
                        for _, info in tk.pairs(data.buttons) do
                            if (info.key and tk:IsModComboActive(info.key)) then
                                cf.left:SetText(info[1]);
                                cf.middle:SetText(info[2]);
                                cf.right:SetText(info[3]);
                                changed = true;
                            end
                        end
                        if (not changed) then
                            local info = data.buttons[1];
                            cf.left:SetText(info[1]);
                            cf.middle:SetText(info[2]);
                            cf.right:SetText(info[3]);
                        end
                    end
                end
            end
        end):Run();

        for _, data in chat.sv.data:Iterate() do
            if (chat.sv.enabled[data.name]) then
                local cf = chat.chat_frames[data.name];
                cf.left:SetScript("OnClick", ChatButton_OnClick);
                cf.middle:SetScript("OnClick", ChatButton_OnClick);
                cf.right:SetScript("OnClick", ChatButton_OnClick);
            end
        end
    end
end