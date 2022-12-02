-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local InCombatLockdown, unpack = _G.InCombatLockdown, _G.unpack;
local pairs, ipairs, table, xpcall = _G.pairs, _G.ipairs, _G.table, _G.xpcall;
local IsAddOnLoaded, strsplit = _G.IsAddOnLoaded, _G.strsplit;
local DEBUG_MODE = false;

---@class MovableModule : BaseModule
local C_MovableFramesModule = MayronUI:RegisterModule("MovableFramesModule", L["Movable Frames"]);

db:AddToDefaults("global.movable", {
  enabled = true;
  clampToScreen = true;
  positions = {};
  talkingHead = { position = "TOP"; yOffset = -50 };
});

local characterSubFrames = { "ReputationFrame" };

local BlizzardFrames = {
  "InterfaceOptionsFrame";
  "QuestFrame";
  "GossipFrame";
  "DurabilityFrame";
  "FriendsFrame";
  "MailFrame";
  "PetStableFrame";
  "SpellBookFrame";
  "PetitionFrame";
  "BankFrame";
  "TimeManagerFrame";
  "VideoOptionsFrame";
  "AddonList";
  "ChatConfigFrame";
  "LootFrame";
  "ReadyCheckFrame";
  "TradeFrame";
  "TabardFrame";
  "GuildRegistrarFrame";
  "ItemTextFrame";
  "DressUpFrame";
  "GameMenuFrame";
  "TaxiFrame";
  "HelpFrame";
  "MerchantFrame";
  "ChannelFrame";
  "WorldMapFrame";
  "ProfessionsFrame"; -- dragonflight
  {
    "CharacterFrame";
    subFrames = characterSubFrames;
    clickedFrames = {
      "CharacterFrameTab1"; "CharacterFrameTab2"; "CharacterFrameTab3";
      "CharacterFrameTab4"; "CharacterFrameTab5";
    };
  };

  dontSavePosition = {
    Blizzard_DebugTools = "ScriptErrorsFrame";
    Blizzard_AuctionUI = "WowTokenGameTimeTutorial";
    Blizzard_QuestChoice = "QuestChoiceFrame";
    TradeSkillDW = "TradeSkillDW_QueueFrame";
  };

  Blizzard_GarrisonUI = {
    "GarrisonCapacitiveDisplayFrame"; "GarrisonLandingPage";
    "GarrisonMissionFrame"; "GarrisonBuildingFrame";
    "GarrisonRecruitSelectFrame"; "GarrisonRecruiterFrame";
  };

  Blizzard_CovenantRenown = { "CovenantRenownFrame" };

  Blizzard_Soulbinds = { "SoulbindViewer" };
  Blizzard_MajorFactions = { "MajorFactionRenownFrame", subFrames = { "MajorFactionRenownFrame.HeaderFrame" } };

  Blizzard_LookingForGuildUI = {
    hooked = {
      {
        "LookingForGuildFrame";
        funcName = "LookingForGuildFrame_CreateUIElements";
      };
    };
  };

  Blizzard_VoidStorageUI = {
    "VoidStorageFrame",
    subFrames = { "VoidStorageBorderFrame" },
    onLoad = function()
      _G.VoidStorageBorderFrameHeader:SetTexture("");
    end
  };
  Blizzard_ItemAlterationUI = "TransmogrifyFrame";
  Blizzard_GuildBankUI = { "GuildBankFrame", subFrames = { "GuildBankFrame.Emblem" }};
  Blizzard_TalentUI = {
    (tk:IsClassic() and "TalentFrame" or "PlayerTalentFrame");
    subFrames = tk:IsWrathClassic() and { "GlyphFrame" };
  };
  Blizzard_ClassTalentUI = {
    "ClassTalentFrame";
  };
  Blizzard_GlyphUI = {
    (tk:IsClassic() and "TalentFrame" or "PlayerTalentFrame");
    subFrames = tk:IsWrathClassic() and { "GlyphFrame" };
  };
  Blizzard_MacroUI = "MacroFrame";
  Blizzard_BindingUI = "KeyBindingFrame";
  Blizzard_Calendar = "CalendarFrame";
  Blizzard_GuildUI = "GuildFrame";
  Blizzard_TradeSkillUI = "TradeSkillFrame";
  Blizzard_TalkingHeadUI = "TalkingHeadFrame";
  Blizzard_EncounterJournal = {
    "EncounterJournal";
    onLoad = function()
      local setPoint = _G.EncounterJournalTooltip.SetPoint;
      _G.EncounterJournalTooltip.SetPoint =
        function(self, p, f, rp, x, y)
          f:ClearAllPoints();
          setPoint(self, p, f, rp, x, y);
        end
    end;
  };
  Blizzard_ArchaeologyUI = "ArchaeologyFrame";
  Blizzard_AchievementUI = {
    "AchievementFrame";
    subFrames = { "AchievementFrameHeader", "AchievementFrame.Header" };
  };
  Blizzard_AuctionUI = "AuctionFrame";
  Blizzard_AuctionHouseUI = "AuctionHouseFrame";
  Blizzard_TrainerUI = "ClassTrainerFrame";
  Blizzard_GuildControlUI = "GuildControlUI";
  Blizzard_InspectUI = "InspectFrame";
  Blizzard_ItemSocketingUI = "ItemSocketingFrame";
  Blizzard_ItemUpgradeUI = "ItemUpgradeFrame";
  Blizzard_AzeriteUI = "AzeriteEmpoweredItemUI";
  Blizzard_CraftUI = "CraftFrame";

  -- TODO: These are currently bugged in Dragonflight:
  --Blizzard_Collections = "CollectionsJournal";
  --Blizzard_Communities = "CommunitiesFrame";
};

if (tk:IsClassic()) then
  table.insert(characterSubFrames, "HonorFrame");
else
  table.insert(characterSubFrames, "TokenFrame");
  table.insert(characterSubFrames, "TokenFrameContainer");
end

if (tk:IsRetail()) then
  table.insert(BlizzardFrames, "QuestLogPopupDetailFrame");
  table.insert(BlizzardFrames, "LFGDungeonReadyStatus");
  table.insert(BlizzardFrames, "RecruitAFriendFrame");
  table.insert(BlizzardFrames, "LFGDungeonReadyDialog");
  table.insert(BlizzardFrames, "LFDRoleCheckPopup");
  table.insert(BlizzardFrames, "GuildInviteFrame");
  table.insert(BlizzardFrames, "BonusRollMoneyWonFrame");
  table.insert(BlizzardFrames, "BonusRollFrame");
  table.insert(BlizzardFrames, "PVEFrame");
  table.insert(BlizzardFrames, "PetBattleFrame.ActiveAlly");
  table.insert(BlizzardFrames, "PetBattleFrame.ActiveEnemy");
else
  table.insert(BlizzardFrames, "QuestLogFrame");
  table.insert(BlizzardFrames, "WorldStateScoreFrame");
end

if (tk:IsBCClassic() or tk:IsWrathClassic()) then
  table.insert(characterSubFrames, "PetPaperDollFrameCompanionFrame");
  table.insert(BlizzardFrames, "LFGParentFrame");
end

local function CanMove(frame)
  return obj:IsFunction(frame.RegisterForDrag) and not (frame:IsProtected() and InCombatLockdown());
end

local function GetFrame(frameName)
  local frame = _G[frameName];

  if (not frame) then
    for _, key in obj:IterateArgs(strsplit(".", frameName)) do
      if (not frame) then
        frame = _G[key];
      else
        frame = frame[key];
      end
    end
  end

  -- TODO: Enable these type of errors in DevMode
  -- obj:Assert(obj:IsTable(frame), "Could not find frame '%s'", frameName);

  if (not obj:IsTable(frame)) then
    return nil;
  end

  return frame;
end

-- Function to fix the "Action[SetPoint] failed because[SetPoint would result in anchor family connection]" bugs
local function FixAnchorFamilyConnections()
  local displayFunc = _G.QuestInfo_Display;

  _G.QuestInfo_Display = function(
    template, parentFrame, acceptButton, material, mapView)
    _G.QuestInfoSealFrame:ClearAllPoints();
    displayFunc(template, parentFrame, acceptButton, material, mapView);
  end

  local setPoint = _G.GameTooltip.SetPoint;
  _G.GameTooltip.SetPoint = function(self, p, f, rp, x, y)
    self:ClearAllPoints();
    setPoint(self, p, f, rp, x, y);
  end
end

obj:DefineParams("string|table", "boolean=false");
function C_MovableFramesModule:ExecuteMakeMovable(_, value, dontSave)
  if (obj:IsString(value)) then
    self:MakeMovable(dontSave, GetFrame(value));

  elseif (obj:IsTable(value)) then
    for _, innerValue in ipairs(value) do
      self:MakeMovable(dontSave, GetFrame(innerValue), value);
    end

    if (obj:IsTable(value.hooked)) then
      for _, hookedTbl in ipairs(value.hooked) do

        if (hookedTbl.tblName) then
          tk:HookFunc(
            _G[hookedTbl.tblName], hookedTbl.funcName, function()
              for _, frameName in ipairs(hookedTbl) do
                self:MakeMovable(dontSave, GetFrame(frameName), value);
              end

              return true;
            end);

        else
          tk:HookFunc(
            hookedTbl.funcName, function()
              for _, frameName in ipairs(hookedTbl) do
                self:MakeMovable(dontSave, GetFrame(frameName), value);
              end
              return true;
            end);
        end
      end
    end

    if (obj:IsFunction(value.onLoad)) then
      value.onLoad();
    end
  end
end

function MayronUI:MakeMovable(frame)
  local movableModule = self:ImportModule("MovableFramesModule");
  movableModule:ExecuteMakeMovable(frame);
end

local function CreateFadingAnimations(f)
  f.fadeIn = f:CreateAnimationGroup();
  local alpha = f.fadeIn:CreateAnimation("Alpha");
  alpha:SetSmoothing("IN");
  alpha:SetDuration(0.75);
  alpha:SetFromAlpha(-1);
  alpha:SetToAlpha(1);

  f.fadeIn:SetScript("OnFinished", function()
    f:SetAlpha(1);
  end);

  f.fadeOut = f:CreateAnimationGroup();
  alpha = f.fadeOut:CreateAnimation("Alpha");
  alpha:SetSmoothing("OUT");
  alpha:SetDuration(1);
  alpha:SetFromAlpha(1);
  alpha:SetToAlpha(-1);

  f.fadeOut:SetScript("OnFinished", function()
    f:SetAlpha(0);
  end);
end

local function UpdateTalkingHeadFrame(data)
  local f = _G.TalkingHeadFrame;

  for i, alertSubSystem in pairs(_G.AlertFrame.alertFrameSubSystems) do
    if (alertSubSystem.anchorFrame == f) then
      table.remove(_G.AlertFrame.alertFrameSubSystems, i);
      break
    end
  end

  -- uncomment this out for development to prevent closing of frame
  -- _G.TalkingHeadFrame.Close = tk.Constants.DUMMY_FUNC;

  -- Reskin:
  f.PortraitFrame:DisableDrawLayer("OVERLAY");
  f.MainFrame.Model:DisableDrawLayer("BACKGROUND");
  f.BackgroundFrame:DisableDrawLayer("BACKGROUND");

  local overlay = f.MainFrame.Overlay;
  _G.Mixin(overlay, _G.BackdropTemplateMixin);
  overlay:SetBackdrop(tk.Constants.BACKDROP_WITH_BACKGROUND);
  overlay:SetBackdropColor(0, 0, 0, 0.5);
  overlay:SetBackdropBorderColor(tk.Constants.AddOnStyle:GetColor("Widget"));
  overlay:SetSize(118, 122)
  overlay:SetPoint("TOPLEFT", 20, -16);

  local bg = gui:CreateDialogBox(f.BackgroundFrame, "LOW");
  bg:SetPoint("TOPLEFT", 14, -10);
  bg:SetPoint("BOTTOMRIGHT", -10, 10);
  bg:SetFrameStrata("HIGH");
  bg:SetFrameLevel(1);

  CreateFadingAnimations(overlay);
  CreateFadingAnimations(bg);

  tk:HookFunc(f, "PlayCurrent", function()
    f:ClearAllPoints();
    f:SetParent(_G.UIParent);
    f:SetPoint(data.settings.talkingHead.position, 0, data.settings.talkingHead.yOffset);

    overlay.fadeOut:Stop();
    bg.fadeOut:Stop();
    overlay.fadeIn:Play();
    bg.fadeIn:Play();
  end);

  tk:HookFunc(f, "Close", function()
    overlay.fadeIn:Stop();
    bg.fadeIn:Stop();
    overlay.fadeOut:Play();
    bg.fadeOut:Play();
  end);
end

function C_MovableFramesModule:OnInitialize(data)
  data.settings = db.global.movable:GetUntrackedTable();
  data.frames = obj:PopTable();

  if (obj:IsTable(_G.UIPARENT_MANAGED_FRAME_POSITIONS)) then
    _G.UIPARENT_MANAGED_FRAME_POSITIONS.TalkingHeadFrame = nil;
  end

  if (tk:IsRetail() and _G.TalkingHeadFrame) then
    UpdateTalkingHeadFrame(data);
  end

  if (db.global.movable.enabled) then
    self:SetEnabled(true);
  end
end

do
  local function UIParent_OnShownChanged(self, settings, frames)
    if (not settings.enabled) then
      return;
    end

    for _, frame in ipairs(frames) do
      if (frame:IsVisible()) then
        self:RepositionFrame(frame);
      end
    end
  end

  function C_MovableFramesModule:OnEnable(data)
    tk:HookFunc(
      "UpdateUIPanelPositions", UIParent_OnShownChanged, self, data.settings,
        data.frames);
    tk:HookFunc(
      "ShowUIPanel", UIParent_OnShownChanged, self, data.settings, data.frames);
    tk:HookFunc(
      "HideUIPanel", UIParent_OnShownChanged, self, data.settings, data.frames);

    -- Fix for the "Action[SetPoint] failed because[SetPoint would result in anchor family connection]" bugs:
    FixAnchorFamilyConnections();

    if (not data.eventListener) then
      data.eventListener =
        em:CreateEventListenerWithID("MovableFramesOnAddOnLoaded", function(_, _, addOnName)
          if (DEBUG_MODE) then print("AddOn Loaded: ", addOnName) end
          if (BlizzardFrames[addOnName]) then
            self:ExecuteMakeMovable(BlizzardFrames[addOnName], false);
            BlizzardFrames[addOnName] = nil;
          end

          if (BlizzardFrames.dontSavePosition[addOnName]) then
            self:ExecuteMakeMovable(
              BlizzardFrames.dontSavePosition[addOnName], true);
            BlizzardFrames.dontSavePosition[addOnName] = nil;
          end
        end);

      data.eventListener:RegisterEvent("ADDON_LOADED");

      for id, frameName in ipairs(BlizzardFrames) do
        self:ExecuteMakeMovable(frameName, false);
        BlizzardFrames[id] = nil;
      end

      for id, frameName in ipairs(BlizzardFrames.dontSavePosition) do
        self:ExecuteMakeMovable(frameName, true);
        BlizzardFrames.dontSavePosition[id] = nil;
      end

      for key, value in pairs(BlizzardFrames) do
        if (value ~= BlizzardFrames.dontSavePosition and IsAddOnLoaded(key)) then
          em:TriggerEventListenerByID("MovableFramesOnAddOnLoaded", key);
        end
      end
    end
  end

  function C_MovableFramesModule:OnDisable()
    tk:UnhookFunc("UpdateUIPanelPositions", UIParent_OnShownChanged);
    tk:UnhookFunc("ShowUIPanel", UIParent_OnShownChanged);
    tk:UnhookFunc("HideUIPanel", UIParent_OnShownChanged);
  end
end

obj:DefineParams("Frame");
function C_MovableFramesModule:RepositionFrame(data, frame)
  if (not CanMove(frame)) then
    return; -- otherwise taint issue!
  end

  local name = frame:GetName();

  if (not name) then
    return;
  end

  local position = data.settings.positions[name];

  if (not obj:IsTable(position)) then
    return;
  end

  local point, relFrameName, relPoint, xOffset, yOffset = unpack(position);
  local relFrame;

  if (obj:IsString(relFrameName)) then
    relFrame = _G[relFrameName];

  elseif (not relFrameName) then
    relFrame = _G.UIParent;
  else
    relFrame = relFrameName;
  end

  if (relPoint and obj:IsWidget(relFrame)) then
    if (CanMove(frame)) then
      xpcall(
        function()
          frame:ClearAllPoints();
          frame:SetPoint(point, relFrame, relPoint, xOffset, yOffset)
        end, function()
          obj:Error(
            "Failed to SetPoint for frame %s using relative Frame: %s", name,
              relFrameName)
        end);
    end
  else
    data.settings.positions[name] = nil;
    db.global.movable.positions[name] = nil;
  end
end

do
  local settings;

  local function Frame_OnDragStop(self, ...)
    if (settings.enabled) then
      self:StopMovingOrSizing();

      if (not self.dontSave) then
        local name = self:GetName();

        if (obj:IsString(name)) then
          if (obj:IsTable(settings.positions[name])) then
            obj:PushTable(settings.positions[name]);
          end

          settings.positions[name] = obj:PopTable(self:GetPoint());
          db.global.movable.positions[name] = settings.positions[name];
        end
      end
    end

    if (obj:IsFunction(self.oldOnDragStop) and CanMove(self)) then
      self.oldOnDragStop(self, ...);
    end
  end

  local function Frame_OnDragStart(self, ...)
    if (settings.enabled) then
      if (not self:IsMovable()) then
        self:SetMovable(true);
        self:EnableMouse(true);
      end

      self:StartMoving();
    end

    if (obj:IsFunction(self.oldOnDragStop) and CanMove(self)) then
      self.oldOnDragStop(self, ...);
    end
  end

  local function SubFrame_OnDragStart(self)
    if (settings.enabled) then
      self.anchoredFrame:GetScript("OnDragStart")(self.anchoredFrame);
    end
  end

  local function SubFrame_OnDragStop(self)
    if (settings.enabled) then
      self.anchoredFrame:GetScript("OnDragStop")(self.anchoredFrame);
    end
  end

  local function ClickedFrame_OnClick(self)
    if (settings.enabled) then
      self.module:RepositionFrame(self.anchoredFrame);
    end
  end

  obj:DefineParams("boolean", "?Frame", "?table");
  function C_MovableFramesModule:MakeMovable(data, dontSave, frame, tbl)
    if (not obj:IsWidget(frame) or not CanMove(frame)) then
      return
    end

    if (not tk.Tables:Contains(data.frames, frame)) then
      frame:SetMovable(true);
      frame:EnableMouse(true);
      frame:SetUserPlaced(true);
      frame:RegisterForDrag("LeftButton");

      if (data.settings.clampToScreen) then
        frame:SetClampedToScreen(true);
        frame:SetClampRectInsets(-10, 10, 10, -10);
      else
        frame:SetClampedToScreen(false);
      end

      frame.dontSave = dontSave;
      settings = data.settings;

      table.insert(data.frames, frame);

      frame.oldOnDragStart = frame:GetScript("OnDragStart");
      frame.oldOnDragStop = frame:GetScript("OnDragStop");
      frame:SetScript("OnDragStart", Frame_OnDragStart);
      frame:SetScript("OnDragStop", Frame_OnDragStop);
    end

    if (not tbl) then
      return;
    end

    if (tbl.subFrames) then
      for _, subFrame in ipairs(tbl.subFrames) do
        subFrame = GetFrame(subFrame);

        if (subFrame) then
          subFrame:EnableMouse(true);
          subFrame:RegisterForDrag("LeftButton");
          subFrame.anchoredFrame = frame;
          subFrame:SetScript("OnDragStart", SubFrame_OnDragStart);
          subFrame:SetScript("OnDragStop", SubFrame_OnDragStop);
        end
      end
    end

    if (tbl.clickedFrames) then
      for _, clickedFrame in ipairs(tbl.clickedFrames) do
        clickedFrame = GetFrame(clickedFrame);

        if (clickedFrame) then
          clickedFrame.module = self;
          clickedFrame.anchoredFrame = frame;
          clickedFrame:HookScript("OnClick", ClickedFrame_OnClick);
        end
      end
    end
  end
end

function C_MovableFramesModule:ResetPositions(data)
  db.global.movable.positions = nil;
  data.settings.positions = db.global.movable.positions:GetUntrackedTable();
end
