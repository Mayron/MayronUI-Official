--luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local InCombatLockdown, unpack = _G.InCombatLockdown, _G.unpack;
local pairs, ipairs, table, xpcall = _G.pairs, _G.ipairs, _G.table, _G.xpcall;

---@type Engine
local Engine = obj:Import("MayronUI.Engine");

---@class MovableModule : BaseModule
local C_MovableFramesModule = MayronUI:RegisterModule("MovableFramesModule", L["Movable Frames"]);

db:AddToDefaults("global.movable", {
	enabled = true;
  positions = {};
  talkingHead = {
    position = "TOP",
    yOffset = -50,
  }
});

local BlizzardFrames = {
	"QuestLogFrame", "QuestLogPopupDetailFrame", "InterfaceOptionsFrame", "QuestFrame",
  "GossipFrame", "DurabilityFrame", "FriendsFrame", "MailFrame", "SpellBookFrame",
  "PetitionFrame", "BankFrame", "TimeManagerFrame", "LFGDungeonReadyStatus", "RecruitAFriendFrame",
  "VideoOptionsFrame", "LFGDungeonReadyDialog", "AddonList", "WorldStateScoreFrame",
  "LFDRoleCheckPopup", "ChatConfigFrame", "GuildInviteFrame", "LootFrame", "ReadyCheckFrame",
  "BonusRollMoneyWonFrame", "BonusRollFrame", "TradeFrame", "TabardFrame", "GuildRegistrarFrame",
	"ItemTextFrame", "DressUpFrame", "GameMenuFrame", "TaxiFrame", "HelpFrame", "PVEFrame", "MerchantFrame",
	"PetBattleFrame.ActiveAlly", "PetBattleFrame.ActiveEnemy", "ChannelFrame", "WorldMapFrame",
	{
		"CharacterFrame";
		clickedFrames = { "CharacterFrameTab1", "CharacterFrameTab2", "CharacterFrameTab3" };
	};

	dontSavePosition = {
		Blizzard_DebugTools = "ScriptErrorsFrame";
		Blizzard_AuctionUI = "WowTokenGameTimeTutorial";
		Blizzard_QuestChoice = "QuestChoiceFrame";
		TradeSkillDW = "TradeSkillDW_QueueFrame";
	};

	Blizzard_GarrisonUI = {
		"GarrisonCapacitiveDisplayFrame";
		"GarrisonLandingPage";
		"GarrisonMissionFrame";
		"GarrisonBuildingFrame";
		"GarrisonRecruitSelectFrame";
		"GarrisonRecruiterFrame";
	};

	Blizzard_LookingForGuildUI =
	{
		hooked = {
			{
				"LookingForGuildFrame", funcName = "LookingForGuildFrame_CreateUIElements";
			}
		};
	};

	Blizzard_Communities = "CommunitiesFrame";
	Blizzard_VoidStorageUI = "VoidStorageFrame";
	Blizzard_ItemAlterationUI = "TransmogrifyFrame";
	Blizzard_GuildBankUI = "GuildBankFrame";
	Blizzard_TalentUI = tk:IsClassic() and "TalentFrame" or "PlayerTalentFrame";
	Blizzard_MacroUI = "MacroFrame";
	Blizzard_BindingUI = "KeyBindingFrame";
	Blizzard_Calendar = "CalendarFrame";
	Blizzard_GuildUI = "GuildFrame";
  Blizzard_TradeSkillUI = "TradeSkillFrame";
  Blizzard_TalkingHeadUI = "TalkingHeadFrame";
	Blizzard_EncounterJournal = {
		"EncounterJournal",
		onLoad = function()
			local setPoint = _G.EncounterJournalTooltip.SetPoint;
			_G.EncounterJournalTooltip.SetPoint = function(self, p, f, rp, x, y)
				f:ClearAllPoints();
				setPoint(self, p, f, rp, x, y);
			end
		end
	};
	Blizzard_ArchaeologyUI = "ArchaeologyFrame";
	Blizzard_AchievementUI = {
		"AchievementFrame";
		subFrames = {"AchievementFrameHeader"};
  };
  Blizzard_AuctionUI = "AuctionFrame";
	Blizzard_AuctionHouseUI = "AuctionHouseFrame";
	Blizzard_TrainerUI = "ClassTrainerFrame";
	Blizzard_Collections = "CollectionsJournal";
	Blizzard_GuildControlUI = "GuildControlUI";
	Blizzard_InspectUI = "InspectFrame";
	Blizzard_ItemSocketingUI = "ItemSocketingFrame";
	Blizzard_ItemUpgradeUI = "ItemUpgradeFrame";
	Blizzard_AzeriteUI = "AzeriteEmpoweredItemUI";
};

local function CanMove(frame)
  return not (frame:IsProtected() and InCombatLockdown());
end

local function GetFrame(frameName)
	local frame = _G[frameName];

	if (not frame) then
		for _, key in obj:IterateArgs(_G.strsplit(".", frameName)) do
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

	_G.QuestInfo_Display = function(template, parentFrame, acceptButton, material, mapView)
		_G.QuestInfoSealFrame:ClearAllPoints();
		displayFunc(template, parentFrame, acceptButton, material, mapView);
	end

	local setPoint = _G.GameTooltip.SetPoint;
	_G.GameTooltip.SetPoint = function(self, p, f, rp, x, y)
		self:ClearAllPoints();
		setPoint(self, p, f, rp, x, y);
	end
end

Engine:DefineParams("string|table", "boolean");
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
					tk:HookFunc(_G[hookedTbl.tblName], hookedTbl.funcName, function()
						for _, frameName in ipairs(hookedTbl) do
							self:MakeMovable(dontSave, GetFrame(frameName), value);
						end

						return true;
					end);

				else
					tk:HookFunc(hookedTbl.funcName, function()
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

function C_MovableFramesModule:OnInitialize(data)
	data.settings = db.global.movable:GetUntrackedTable();
  data.frames = obj:PopTable();

  _G.UIPARENT_MANAGED_FRAME_POSITIONS.TalkingHeadFrame = nil;
  em:CreateEventHandler("ADDON_LOADED", function(self, _, addOnName)
    if (addOnName ~= "Blizzard_TalkingHeadUI") then return end

    self:Destroy();
    local f = _G.TalkingHeadFrame;

    -- Reposition talking head frame to top of screen
    f:ClearAllPoints();
    f:SetPoint(data.settings.talkingHead.position, 0, data.settings.talkingHead.yOffset);
    f:SetScript("OnShow", nil);
    f:SetScript("OnHide", nil);

    for i, alertSubSystem in pairs(_G.AlertFrame.alertFrameSubSystems) do
      if (alertSubSystem.anchorFrame == f) then
        table.remove(_G.AlertFrame.alertFrameSubSystems, i);
        break;
      end
    end

    if (not _G.BackdropTemplateMixin) then return end
    -- code below is used reskinning of the talking head frame

    -- uncomment this out for development to prevent closing of frame
    -- _G.TalkingHeadFrame_Close = tk.Constants.DUMMY_FUNC;
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

    local bg = gui:CreateDialogBox(tk.Constants.AddOnStyle, f.BackgroundFrame, "LOW", nil, "MUI_TEST");
    bg:SetPoint("TOPLEFT", 14, -10);
    bg:SetPoint("BOTTOMRIGHT", -10, 10);
    bg:SetFrameStrata("HIGH");
    bg:SetFrameLevel(1);

    CreateFadingAnimations(overlay);
    CreateFadingAnimations(bg);

    tk:HookFunc("TalkingHeadFrame_PlayCurrent", function()
      overlay.fadeOut:Stop();
      bg.fadeOut:Stop();
      overlay.fadeIn:Play();
      bg.fadeIn:Play();
    end);

    tk:HookFunc("TalkingHeadFrame_Close", function()
      overlay.fadeIn:Stop();
      bg.fadeIn:Stop();
      overlay.fadeOut:Play();
      bg.fadeOut:Play();
    end);
  end);

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
		tk:HookFunc("UpdateUIPanelPositions", UIParent_OnShownChanged, self, data.settings, data.frames);
		tk:HookFunc("ShowUIPanel", UIParent_OnShownChanged, self, data.settings, data.frames);
		tk:HookFunc("HideUIPanel", UIParent_OnShownChanged, self, data.settings, data.frames);

		-- Fix for the "Action[SetPoint] failed because[SetPoint would result in anchor family connection]" bugs:
		FixAnchorFamilyConnections();

		if (not data.handler) then
      data.handler = em:CreateEventHandler("ADDON_LOADED", function(_, _, addOnName)
        if (BlizzardFrames[addOnName]) then
					self:ExecuteMakeMovable(BlizzardFrames[addOnName], false);
					BlizzardFrames[addOnName] = nil;
				end

				if (BlizzardFrames.dontSavePosition[addOnName]) then
					self:ExecuteMakeMovable(BlizzardFrames.dontSavePosition[addOnName], true);
					BlizzardFrames.dontSavePosition[addOnName] = nil;
				end
			end);

			for id, frameName in ipairs(BlizzardFrames) do
				self:ExecuteMakeMovable(frameName, false);
				BlizzardFrames[id] = nil;
			end

			for id, frameName in ipairs(BlizzardFrames.dontSavePosition) do
				self:ExecuteMakeMovable(frameName, true);
				BlizzardFrames.dontSavePosition[id] = nil;
			end

			for key, value in pairs(BlizzardFrames) do
				if (value ~= BlizzardFrames.dontSavePosition and _G.IsAddOnLoaded(key)) then
					data.handler:Run("ADDON_LOADED", key);
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

Engine:DefineParams("Frame");
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
        end,
        function() obj:Error("Failed to SetPoint for frame %s using relative Frame: %s", name, relFrameName) end);
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

	Engine:DefineParams("boolean", "?Frame", "?table");
  function C_MovableFramesModule:MakeMovable(data, dontSave, frame, tbl)
    if (not frame or not CanMove(frame)) then return end

		frame:SetMovable(true);
		frame:EnableMouse(true);
		frame:SetUserPlaced(true);
		frame:RegisterForDrag("LeftButton");
		frame:SetClampedToScreen(true);
		frame:SetClampRectInsets(-10, 10, 10, -10);
		frame.dontSave = dontSave;
		settings = data.settings;

		table.insert(data.frames, frame);

		frame.oldOnDragStart = frame:GetScript("OnDragStart");
		frame.oldOnDragStop = frame:GetScript("OnDragStop");
		frame:SetScript("OnDragStart", Frame_OnDragStart);
		frame:SetScript("OnDragStop", Frame_OnDragStop);

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