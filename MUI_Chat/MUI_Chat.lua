-- luacheck: ignore self 143
local MayronUI = _G.MayronUI;
local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local ChatFrame1EditBox = _G.ChatFrame1EditBox;
local NUM_CHAT_WINDOWS = _G.NUM_CHAT_WINDOWS;
local hooksecurefunc, IsCombatLog = _G.hooksecurefunc, _G.IsCombatLog;

-- TODO: Need to get the updated data.settings table from BaseModule somehow

--------------------------
-- Blizzard Globals
--------------------------
_G.CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 1;
_G.CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 1;
_G.CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1;
_G.CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1;
_G.CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1;
_G.CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1;
_G.CHAT_TAB_SHOW_DELAY = 1;
_G.CHAT_TAB_HIDE_DELAY = 1;
_G.CHAT_FRAME_FADE_TIME = 1;
_G.CHAT_FRAME_FADE_OUT_TIME = 1;
_G.DEFAULT_CHATFRAME_ALPHA = 0;
_G.CHAT_FONT_HEIGHTS = obj:PopWrapper(8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18);

-- Register and Import ---------

local C_ChatModule = MayronUI:RegisterModule("Chat");
namespace.C_ChatModule = C_ChatModule;

-- Local Functions ---------------

local function KillElements()
	-- Kill all blizzard unwanted elements (textures, fontstrings, frames, etc...)
	for i = 1, 20 do
		local staticPopupEditBox = string.format("StaticPopup%dEditBox", i);

		if (not _G[staticPopupEditBox]) then
			break;
		end

		tk:KillAllElements(
			_G[string.format("%sLeft", staticPopupEditBox)],
			_G[string.format("%sMid", staticPopupEditBox)],
			_G[string.format("%sRight", staticPopupEditBox)]
		);
	end

	tk:KillAllElements(
		ChatFrame1EditBox.focusLeft,
		ChatFrame1EditBox.focusRight,
		ChatFrame1EditBox.focusMid,
		_G.ChatFrame1EditBoxLeft,
		_G.ChatFrame1EditBoxMid,
		_G.ChatFrame1EditBoxRight,
		_G.ChatFrameMenuButton,
		_G.QuickJoinToastButton
	);
end

local function ReskinEditBox(editBoxSettings)
    ChatFrame1EditBox:SetPoint("TOPLEFT", _G.ChatFrame1, "BOTTOMLEFT", -3, editBoxSettings.yOffset);
	ChatFrame1EditBox:SetPoint("TOPRIGHT", _G.ChatFrame1, "BOTTOMRIGHT", 3, editBoxSettings.yOffset);

	-- Set Edit Box Backdrop
    local inset = editBoxSettings.inset;
    local backdrop = {
        bgFile = "Interface\\Buttons\\WHITE8X8",
        insets = {left = inset, right = inset, top = inset, bottom = inset};
	};

    backdrop.edgeFile = tk.Constants.LSM:Fetch("border", editBoxSettings.border);
	backdrop.edgeSize = editBoxSettings.borderSize;

    local c = editBoxSettings.backdropColor;
	ChatFrame1EditBox:SetBackdrop(backdrop);
	ChatFrame1EditBox:SetBackdropColor(c.r, c.g, c.b, c.a);
	ChatFrame1EditBox:SetHeight(editBoxSettings.height);
end

-- Chat Module -------------------

function C_ChatModule:OnInitialize(data)
	data.settings = db.profile.chat:GetUntrackedTable();

    tk.StaticPopupDialogs["MUI_Link"] = {
		text = tk.Strings:Join("\n",
			tk.Strings:SetTextColorByTheme("MayronUI"),
			"(CTRL+C to Copy, CTRL+V to Paste)"),
		button1 = "Close",
		hasEditBox = 1,
		maxLetters = 1024,
		editBoxWidth = 350,
		hideOnEscape = 1,
		timeout = 0,
		whileDead = 1,
		preferredIndex = 3,
	};

	KillElements();
	ReskinEditBox(data.settings.editBox);

	local changeGameFont = db.global.core.changeGameFont;
	local muiFont = tk.Constants.LSM:Fetch("font", db.global.core.font);

	for chatFrameID = 1, NUM_CHAT_WINDOWS do
		local chatFrame = self:SetUpBlizzardChatFrame(chatFrameID);

        if (changeGameFont) then
            local _, fontSize, outline = _G.FCF_GetChatWindowInfo(chatFrame:GetID());
            chatFrame:SetFont(muiFont, fontSize, outline);
        end
	end

	for anchorName, _ in pairs(data.settings.chatFrames) do
		local chatFrameSettings = data.settings.chatFrames[anchorName];

		if (chatFrameSettings.enabled) then
			db.profile.chat.chatFrames[anchorName]:SetParent(db.profile.chat.templateMuiChatFrame);
			chatFrameSettings = db.profile.chat.chatFrames[anchorName]:GetUntrackedTable();

			local muiChatFrame = self:ShowMuiChatFrame(anchorName);
			self:SetUpButtonHandler(muiChatFrame, chatFrameSettings.buttons);

			if (anchorName == "TOPLEFT") then
				if (tk.IsAddOnLoaded("Blizzard_CompactRaidFrames")) then
					self:SetUpRaidFrameManager(muiChatFrame);
				else
					-- if it is not loaded, create a callback to trigger when it is loaded
					em:CreateEventHandler("ADDON_LOADED", function(_, name)
						if (name == "Blizzard_CompactRaidFrames") then
							self:SetUpRaidFrameManager(muiChatFrame);
						end
					end):SetAutoDestroy(true);
				end
			end
		end
	end
end

----------------------------------
-- Override Blizzard Functions:
----------------------------------
local ChatFrame1Tab = _G.ChatFrame1Tab;

local function RepositionChatTab()
	ChatFrame1Tab:SetPoint("LEFT", 16, 0);
end

-- override with a dummy function
--luacheck: ignore FCFTab_UpdateColors
function FCFTab_UpdateColors() end

--luacheck: ignore FCF_SetTabPosition
function FCF_SetTabPosition(chatFrame)
	local chatFrameTab = _G[string.format("%sTab", chatFrame:GetName())];

	if (not chatFrame.isDocked) then
		chatFrameTab:ClearAllPoints();

		if (IsCombatLog(chatFrame)) then
			chatFrameTab:SetPoint("BOTTOMLEFT", _G["CombatLogQuickButtonFrame_Custom"], "TOPLEFT", 15, 10);
		else
			chatFrameTab:SetPoint("BOTTOMLEFT", chatFrame, "TOPLEFT", 15, 10);
		end
	end

	RepositionChatTab();

	local minButton = _G[string.format("%sButtonFrameMinimizeButton", chatFrame:GetName())];
    minButton:Hide();
end

hooksecurefunc("FCFTab_OnUpdate", RepositionChatTab);
hooksecurefunc("FCF_DockUpdate", RepositionChatTab);
hooksecurefunc("FCFDockScrollFrame_JumpToTab", RepositionChatTab);
hooksecurefunc("ChatEdit_UpdateHeader", function()
	local chatType = ChatFrame1EditBox:GetAttribute("chatType");
	local r, g, b = _G.GetMessageTypeColor(chatType);
	ChatFrame1EditBox:SetBackdropBorderColor(r, g, b, 1);
end);

-- probably not needed
tk.hooksecurefunc("FCF_OpenTemporaryWindow", function()
	local chat =_G.FCF_GetCurrentChatFrame();

	if (chat) then
		chat:SetClampRectInsets(0, 0, 0, 0);
	end
end);

-- must be before chat is initialized!
for i = 1, NUM_CHAT_WINDOWS do
    _G["ChatFrame"..i]:SetClampRectInsets(0, 0, 0, 0);
end
