-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
if (tk:IsClassic()) then return end

---@class ObjectiveTrackerModule : BaseModule
local C_ObjectiveTracker = MayronUI:RegisterModule("ObjectiveTrackerModule", L["Objective Tracker"], true);

MayronUI:Hook("SideBarModule", "OnEnable", function(sideBarModule)
  MayronUI:ImportModule("ObjectiveTrackerModule"):Initialize(sideBarModule);
end);

local ObjectiveTrackerFrame, IsInInstance, ObjectiveTracker_Collapse, ObjectiveTracker_Update,
ObjectiveTracker_Expand, UIParent, hooksecurefunc, ipairs, pairs, C_QuestLog, CreateFrame,
GetInstanceInfo, RegisterStateDriver, UnregisterStateDriver, GetQuestDifficultyColor =
  _G.ObjectiveTrackerFrame, _G.IsInInstance, _G.ObjectiveTracker_Collapse, _G.ObjectiveTracker_Update,
  _G.ObjectiveTracker_Expand, _G.UIParent, _G.hooksecurefunc, _G.ipairs, _G.pairs, _G.C_QuestLog, _G.CreateFrame,
  _G.GetInstanceInfo, _G.RegisterStateDriver, _G.UnregisterStateDriver, _G.GetQuestDifficultyColor;

_G.OBJECTIVE_TRACKER_HEADER_OFFSET_X = 0;

local function SetHeaderColor(headerText, level, isScaling)
  local difficultyColor = GetQuestDifficultyColor(level, isScaling);
  headerText:SetTextColor(difficultyColor.r, difficultyColor.g, difficultyColor.b);
  headerText.colorStyle = difficultyColor;
end

local function UpdateQuestDifficultyColors(block)
  if (C_QuestLog and C_QuestLog.GetNumQuestLogEntries) then
    for questLogIndex = 1, C_QuestLog:GetNumQuestLogEntries() do
      local questInfo = C_QuestLog.GetInfo(questLogIndex);

      if (questInfo and questInfo.questID == block.id) then
        -- bonus quests do not have HeaderText
          if (block.HeaderText) then
            SetHeaderColor(block.HeaderText, questInfo.level, questInfo.isScaling);
          end
          break;
        end
      end

    elseif (_G.GetNumQuestLogEntries) then
      -- Classic:
      for questLogIndex = 1, _G.GetNumQuestLogEntries() do
        local _, level, _, _, _, _, _, questID, _, _, _, _, _, _, _, _, isScaling = _G.GetQuestLogTitle(questLogIndex);

        if (questID == block.id) then
          -- bonus quests do not have HeaderText
            if (block.HeaderText) then
              SetHeaderColor(block.HeaderText, level, isScaling);
            end
            break;
          end
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
        UnregisterStateDriver(data.autoHideHandler, "autoHideHandler");
        em:DestroyEventHandlerByKey("ObjectiveTracker_InInstance");
        return;
      end

      RegisterStateDriver(data.autoHideHandler, "autoHideHandler",
        "[@boss1,exists][@boss2,exists][@boss3,exists][@boss4,exists] 1;0");

      em:CreateEventHandlerWithKey("PLAYER_ENTERING_WORLD", "ObjectiveTracker_InInstance", function()
        local inInstance = IsInInstance();

        if (inInstance) then
          if (not ObjectiveTrackerFrame.collapsed) then
            local _, _, difficultyID = GetInstanceInfo();

            -- ignore keystone dungeons
            if (difficultyID and difficultyID ~= 8) then
              ObjectiveTracker_Collapse();
              data.previouslyCollapsed = true;
            end
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

local upButtonTexture = tk:GetAssetFilePath("Textures\\DialogBox\\UpButton");
local downButtonTexture = tk:GetAssetFilePath("Textures\\DialogBox\\DownButton");

local function ReskinMinifyButton(btn, module)
  tk:ApplyThemeColor(btn);

  btn:SetSize(20, 20);
  btn:GetNormalTexture():SetTexCoord(0, 1, 0, 1);
  btn:GetPushedTexture():SetTexCoord(0, 1, 0, 1);
  btn:GetHighlightTexture():SetTexCoord(0, 1, 0, 1);

  btn:GetNormalTexture().SetTexCoord = tk.Constants.DUMMY_FUNC;
  btn:GetPushedTexture().SetTexCoord = tk.Constants.DUMMY_FUNC;
  btn:GetHighlightTexture().SetTexCoord = tk.Constants.DUMMY_FUNC;

  btn:GetNormalTexture().SetRotation = tk.Constants.DUMMY_FUNC;
  btn:GetPushedTexture().SetRotation = tk.Constants.DUMMY_FUNC;
  btn:GetHighlightTexture().SetRotation = tk.Constants.DUMMY_FUNC;

  hooksecurefunc("ObjectiveTracker_Update", function()
    if (module.collapsed) then
      btn:SetNormalTexture(downButtonTexture, "BLEND");
      btn:SetPushedTexture(downButtonTexture, "BLEND");
      btn:SetHighlightTexture(downButtonTexture, "ADD");
    else
      btn:SetNormalTexture(upButtonTexture, "BLEND");
      btn:SetPushedTexture(upButtonTexture, "BLEND");
      btn:SetHighlightTexture(upButtonTexture, "ADD");
    end
  end);
end

local function OnObjectiveTrackerInitialized()
  for _, module in ipairs(ObjectiveTrackerFrame.MODULES_UI_ORDER) do
    module.Header:SetWidth(ObjectiveTrackerFrame:GetWidth());
    module.BlocksFrame:SetWidth(ObjectiveTrackerFrame:GetWidth());

    for _, value in pairs(module.blockOffset) do
      value[1] = 0;
      value[2] = 0;
    end

    tk:KillElement(module.Header.Background);
    tk:ApplyThemeColor(module.Header.Text);
    module.Header.Text:SetPoint("LEFT", 0, 0);

    if (module.Header.MinimizeButton) then
      ReskinMinifyButton(module.Header.MinimizeButton, module);
    end
  end
end

function C_ObjectiveTracker:OnEnable(data)
  if (data.objectiveContainer) then return end

  -- holds and controls blizzard objectives tracker frame
  data.objectiveContainer = CreateFrame("Frame", nil, UIParent);

  -- blizzard objective tracker frame global variable
  ObjectiveTrackerFrame:SetClampedToScreen(false);
  ObjectiveTrackerFrame:SetParent(data.objectiveContainer);
  ObjectiveTrackerFrame:SetAllPoints(true);
  ObjectiveTrackerFrame:SetMovable(true); -- required to make user placed
  ObjectiveTrackerFrame:SetUserPlaced(true);

  data.autoHideHandler = CreateFrame("Frame", nil, data.objectiveContainer, "SecureHandlerStateTemplate");
  data.autoHideHandler:SetAttribute("_onstate-autoHideHandler", "if (newstate == 1) then self:Hide() else self:Show() end");

  local triggerInInstanceHandler = function() em:TriggerEventHandlerByKey("ObjectiveTracker_InInstance"); end
  data.autoHideHandler:SetScript("OnShow", triggerInInstanceHandler);
  data.autoHideHandler:SetScript("OnHide", triggerInInstanceHandler);

  -- Reskinning (kept very minimal):
  tk:ApplyThemeColor(ObjectiveTrackerFrame.HeaderMenu.Title);

  _G.ScenarioStageBlock.NormalBG:Hide();
  _G.ScenarioStageBlock:SetHeight(70);

  local box = gui:CreateDialogBox(tk.Constants.AddOnStyle, _G.ScenarioStageBlock, "LOW");
  box:SetPoint("TOPLEFT", 5, -5);
  box:SetPoint("BOTTOMRIGHT", -5, 5);
  box:SetFrameStrata("BACKGROUND");

  if (obj:IsTable(ObjectiveTrackerFrame.MODULES_UI_ORDER)) then
    -- already been initialized:
    OnObjectiveTrackerInitialized();
  else
    hooksecurefunc("ObjectiveTracker_Initialize", OnObjectiveTrackerInitialized);
  end

  -- reskin the "main" minimize button (not per module):
  local minButton = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton;
  ReskinMinifyButton(minButton, ObjectiveTrackerFrame);

  -- Update difficulty colors:
  hooksecurefunc(_G.QUEST_TRACKER_MODULE, "Update", function()
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