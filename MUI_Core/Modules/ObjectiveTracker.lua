

-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

---@class ObjectiveTrackerModule : BaseModule
local C_ObjectiveTracker = MayronUI:RegisterModule("ObjectiveTrackerModule", "Objective Tracker", true);


MayronUI:Hook("SideBarModule", "OnInitialize", function(sideBarModule)
    MayronUI:ImportModule("ObjectiveTrackerModule"):Initialize(sideBarModule);
end);

local ObjectiveTrackerFrame, IsInInstance, ObjectiveTracker_Collapse, ObjectiveTracker_Update,
ObjectiveTracker_Expand, UIParent, hooksecurefunc, ipairs =
    _G.ObjectiveTrackerFrame, _G.IsInInstance, _G.ObjectiveTracker_Collapse, _G.ObjectiveTracker_Update,
    _G.ObjectiveTracker_Expand, _G.UIParent, _G.hooksecurefunc, _G.ipairs;

local function UpdateQuestDifficultyColors(block)
    for questLogIndex = 1, _G.GetNumQuestLogEntries() do
        local _, level, _, _, _, _, _, questID, _, _, _, _, _, _, _, _, isScaling = _G.GetQuestLogTitle(questLogIndex);

        if (questID == block.id) then
            -- bonus quests do not have HeaderText
            if (block.HeaderText) then
                local difficultyColor = _G.GetQuestDifficultyColor(level, isScaling);
                block.HeaderText:SetTextColor(difficultyColor.r, difficultyColor.g, difficultyColor.b);
                block.HeaderText.colorStyle = difficultyColor;
            end

            break;
        end
    end
end

db:AddToDefaults("profile.objectiveTracker", {
    enabled = true;
    hideInInstance = true;
    anchoredToSideBars = true;
    width = 250;
    height = 600;
    yOffset = 0;
    xOffset = -30;
});

function C_ObjectiveTracker:OnInitialize(data, sideBarModule)
    data.panel = sideBarModule:GetPanel();

    local function SetUpAnchor()
        data.objectiveContainer:ClearAllPoints();

        if (data.settings.anchoredToSideBars) then
            data.objectiveContainer:SetPoint("TOPRIGHT", data.panel, "TOPLEFT", data.settings.xOffset, data.settings.yOffset);
        else
            data.objectiveContainer:SetPoint("CENTER", data.settings.xOffset, data.settings.yOffset);
        end
    end

    self:RegisterUpdateFunctions(db.profile.objectiveTracker, {
        hideInInstance = function(value)
            if (not value) then
                em:DestroyEventHandlerByKey("ObjectiveTracker_InInstance");
                return;
            end

            em:CreateEventHandlerWithKey("PLAYER_ENTERING_WORLD", "ObjectiveTracker_InInstance", function()
                local inInstance = IsInInstance();

                if (inInstance) then
                    if (not ObjectiveTrackerFrame.collapsed) then
                        ObjectiveTracker_Collapse();
                        data.previouslyCollapsed = true;
                    end
                else
                    if (ObjectiveTrackerFrame.collapsed and data.previouslyCollapsed) then
                        ObjectiveTracker_Expand();
                        ObjectiveTracker_Update();
                    end

                    data.previouslyCollapsed = nil;
                end
            end);

            if (IsInInstance()) then
                em:TriggerEventHandlerByKey("ObjectiveTracker_InInstance");
            end
        end;

        width = function(value)
            data.objectiveContainer:SetSize(value, data.settings.height);
        end;

        height = function(value)
            data.objectiveContainer:SetSize(data.settings.width, value);
        end;

        anchoredToSideBars = SetUpAnchor;
        yOffset = SetUpAnchor;
        xOffset = SetUpAnchor;
    });

    if (data.settings.enabled) then
        self:SetEnabled(true);
    end
end

function C_ObjectiveTracker:OnEnable(data)
    if (not data.objectiveContainer) then
        -- holds and controls blizzard objectives tracker frame
        data.objectiveContainer = _G.CreateFrame("Frame", nil, UIParent);

        -- blizzard objective tracker frame global variable
        ObjectiveTrackerFrame:SetClampedToScreen(false);
        ObjectiveTrackerFrame:SetParent(data.objectiveContainer);
        ObjectiveTrackerFrame:SetAllPoints(true);

        ObjectiveTrackerFrame.ClearAllPoints = tk.Constants.DUMMY_FUNC;
        ObjectiveTrackerFrame.SetParent = tk.Constants.DUMMY_FUNC;
        ObjectiveTrackerFrame.SetPoint = tk.Constants.DUMMY_FUNC;
        ObjectiveTrackerFrame.SetAllPoints = tk.Constants.DUMMY_FUNC;
    end

    tk:ApplyThemeColor(ObjectiveTrackerFrame.HeaderMenu.Title);

    _G.ScenarioStageBlock.NormalBG:Hide();
    _G.ScenarioStageBlock:SetHeight(70);

    local box = gui:CreateDialogBox(tk.Constants.AddOnStyle, _G.ScenarioStageBlock, "LOW");
    box:SetPoint("TOPLEFT", 5, -5);
    box:SetPoint("BOTTOMRIGHT", -5, 5);
    box:SetFrameStrata("BACKGROUND");

    if (obj:IsTable(ObjectiveTrackerFrame.MODULES_UI_ORDER)) then
        for _, module in ipairs(ObjectiveTrackerFrame.MODULES_UI_ORDER) do
            tk:KillElement(module.Header.Background);
            tk:ApplyThemeColor(module.Header.Text);
        end
    else
        hooksecurefunc("ObjectiveTracker_Initialize", function()
            for _, module in ipairs(ObjectiveTrackerFrame.MODULES_UI_ORDER) do
                tk:KillElement(module.Header.Background);
                tk:ApplyThemeColor(module.Header.Text);
            end
        end);
    end

    local minButton = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton;
    local upButtonTexture = tk:GetAssetFilePath("Textures\\DialogBox\\UpButton");
    local downButtonTexture = tk:GetAssetFilePath("Textures\\DialogBox\\DownButton");

    tk:ApplyThemeColor(minButton);

    minButton:SetSize(24, 20);
    minButton:GetNormalTexture():SetTexCoord(0, 1, 0, 1);
    minButton:GetPushedTexture():SetTexCoord(0, 1, 0, 1);
    minButton:GetHighlightTexture():SetTexCoord(0, 1, 0, 1);

    minButton:GetNormalTexture().SetTexCoord = tk.Constants.DUMMY_FUNC;
    minButton:GetPushedTexture().SetTexCoord = tk.Constants.DUMMY_FUNC;
    minButton:GetHighlightTexture().SetTexCoord = tk.Constants.DUMMY_FUNC;

    minButton:GetNormalTexture().SetRotation = tk.Constants.DUMMY_FUNC;
    minButton:GetPushedTexture().SetRotation = tk.Constants.DUMMY_FUNC;
    minButton:GetHighlightTexture().SetRotation = tk.Constants.DUMMY_FUNC;

    -- because "ObjectiveTracker_MinimizeButton_OnClick" did not work (weird)
    hooksecurefunc("ObjectiveTracker_Update", function()
        if (ObjectiveTrackerFrame.collapsed) then
            minButton:SetNormalTexture(downButtonTexture, "BLEND");
            minButton:SetPushedTexture(downButtonTexture, "BLEND");
            minButton:SetHighlightTexture(downButtonTexture, "ADD");
        else
            minButton:SetNormalTexture(upButtonTexture, "BLEND");
            minButton:SetPushedTexture(upButtonTexture, "BLEND");
            minButton:SetHighlightTexture(upButtonTexture, "ADD");
        end
    end);

    _G.hooksecurefunc(_G.QUEST_TRACKER_MODULE, "Update", function()
        local block = _G.ObjectiveTrackerBlocksFrame.QuestHeader.module.firstBlock;
        while (block) do
            UpdateQuestDifficultyColors(block);
            block = block.nextBlock;
        end
    end);

    hooksecurefunc(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE, "OnBlockHeaderLeave", function(self, block)
        UpdateQuestDifficultyColors(block);
    end);
end