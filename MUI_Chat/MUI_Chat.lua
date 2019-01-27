-- luacheck: ignore self 143
local MayronUI = _G.MayronUI;
local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local ChatFrame1EditBox = _G.ChatFrame1EditBox;
local NUM_CHAT_WINDOWS = _G.NUM_CHAT_WINDOWS;
local hooksecurefunc, IsCombatLog = _G.hooksecurefunc, _G.IsCombatLog;
local StaticPopupDialogs = _G.StaticPopupDialogs;
local ChatFrame1Tab = _G.ChatFrame1Tab;

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
_G.CHAT_FONT_HEIGHTS = obj:PopTable(8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18);

-- Objects ------------------

local Engine = obj:Import("MayronUI.Engine");
local C_ChatFrame = Engine:CreateClass("ChatFrame", "Framework.System.FrameWrapper");
local C_ChatModule = MayronUI:RegisterModule("Chat");

namespace.Engine = Engine;
namespace.C_ChatModule = C_ChatModule;
namespace.C_ChatFrame = C_ChatFrame;

-- Defaults -----------------

db:AddToDefaults("profile.chat", {
	enabled = true;
	swapInCombat = false;
	layout = "DPS"; -- default layout
	chatFrames = {
		-- these tables will contain the templateMuiChatFrame data (using SetParent)
		TOPLEFT = {
			enabled = true;
		};
		TOPRIGHT = {
			enabled = false;
		};
		BOTTOMLEFT = {
			enabled = false;
		};
		BOTTOMRIGHT = {
			enabled = false;
		};
	};
    editBox = {
        yOffset = -8;
        height = 27;
        border = "Skinner";
        inset = 0;
        borderSize = 1;
        backdropColor = {
			r = 0;
			g = 0;
			b = 0;
			a = 0.6;
		};
	};

	__templateChatFrame = {
		buttons = {
			{   L["Character"];
				L["Spell Book"];
				L["Talents"];
			};
			{   key = "C"; -- CONTROL
				L["Friends"];
				L["Guild"];
				L["Quest Log"];
			};
			{   key = "S"; -- SHIFT
				L["Achievements"];
				L["Collections Journal"];
				L["Encounter Journal"];
			};
		};
	};
});

db:AddToDefaults("global.chat", {
	layouts = {
		["DPS"] = {
			["ShadowUF"] = "Default";
			["Grid"] = "Default";
		},
		["Healer"] = {
			["ShadowUF"] = "MayronUIH";
			["Grid"] = "MayronUIH";
		}
	}
});

-- OnConfigUpdate ----------------------

-- function C_ChatModule:OnConfigUpdate(data, list, value)
--     local key = list:PopFront();

--     if (key == "profile" and list:PopFront() == "chat") then
-- 		key = list:PopFront();

--         else
--             -- could be chatframe name, like "TOPLEFT" etc...
--             local chatFrame = data.chatFrames[self:GetChatNameById(key)];
--             if (not chatFrame) then return end

--             if (list:PopFront() == "buttons") then
--                 local buttonSetId, buttonID = list:PopFront(), list:PopFront();

--                 if (buttonSetId and buttonSetId == 1 and buttonID) then
--                     if (buttonID == 1) then
--                         chatFrame.left:SetText(value);
--                     elseif (buttonID == 2) then
--                         chatFrame.middle:SetText(value);
--                     elseif (buttonID == 3) then
--                         chatFrame.right:SetText(value);
--                     end
--                 end
--             end
--         end
--     end
-- end

-- Chat Module -------------------

function C_ChatModule:OnInitialize(data)
	data.chatFrames = obj:PopTable();

	local setupOptions = {
		last = {
			"editBox.backdropColor";
		};
	};

	-- must be before data.settings gets initialised from RegisterUpdateFunctions
	for _, anchorName in obj:IterateArgs("TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT") do
		db.profile.chat.chatFrames[anchorName]:SetParent(db.profile.chat.__templateChatFrame);
	end

	self:RegisterUpdateFunctions(db.profile.chat, {
		chatFrames = function(value)
			for anchorName, settings in pairs(value) do
				local muiChatFrame = data.chatFrames[anchorName];

				if (settings.enabled and not muiChatFrame) then
					muiChatFrame = C_ChatFrame(anchorName, self, data.settings);
				end

				if (muiChatFrame) then
					muiChatFrame:SetEnabled(settings.enabled);
				end
			end
		end;

		editBox = {
			yOffset = function(value)
				ChatFrame1EditBox:SetPoint("TOPLEFT", _G.ChatFrame1, "BOTTOMLEFT", -3, value);
				ChatFrame1EditBox:SetPoint("TOPRIGHT", _G.ChatFrame1, "BOTTOMRIGHT", 3, value);
			end;

			height = function(value)
				ChatFrame1EditBox:SetHeight(value);
			end;

			border = function(value)
				data.editBoxBackdrop.edgeFile = tk.Constants.LSM:Fetch("border", value);
				ChatFrame1EditBox:SetBackdrop(data.editBoxBackdrop);
			end;

			inset = function(value)
				data.editBoxBackdrop.insets.left = value;
				data.editBoxBackdrop.insets.right = value;
				data.editBoxBackdrop.insets.top = value;
				data.editBoxBackdrop.insets.bottom = value;
				ChatFrame1EditBox:SetBackdrop(data.editBoxBackdrop);
			end;

			borderSize = function(value)
				data.editBoxBackdrop.edgeSize = value;
				ChatFrame1EditBox:SetBackdrop(data.editBoxBackdrop);
			end;

			backdropColor = function(value)
				ChatFrame1EditBox:SetBackdropColor(value.r, value.g, value.b, value.a);
			end;
		};
	}, setupOptions);

	MayronUI:PrintTable(data.settings);

	self:SetEnabled(true);
end

----------------------------------
-- Override Blizzard Functions:
----------------------------------

function C_ChatModule:OnEnable(data)
	StaticPopupDialogs["MUI_Link"] = {
		text = tk.Strings:Join(
			"\n", tk.Strings:SetTextColorByTheme("MayronUI"), "(CTRL+C to Copy, CTRL+V to Paste)"
		);
		button1 = "Close";
		hasEditBox = true;
		maxLetters = 1024;
		editBoxWidth = 350;
		hideOnEscape = 1;
		timeout = 0;
		whileDead = 1;
		preferredIndex = 3;
	};

	data.editBoxBackdrop = obj:PopTable();
	data.editBoxBackdrop.bgFile = "Interface\\Buttons\\WHITE8X8";
	data.editBoxBackdrop.insets = obj:PopTable();

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
		ChatFrame1EditBox.focusLeft, ChatFrame1EditBox.focusRight, ChatFrame1EditBox.focusMid,
		_G.ChatFrame1EditBoxLeft, _G.ChatFrame1EditBoxMid, _G.ChatFrame1EditBoxRight,
		_G.ChatFrameMenuButton,	_G.QuickJoinToastButton
	);

	local changeGameFont = db.global.core.changeGameFont;
	local muiFont = tk.Constants.LSM:Fetch("font", db.global.core.font);

	for chatFrameID = 1, NUM_CHAT_WINDOWS do
		local chatFrame = self:SetUpBlizzardChatFrame(chatFrameID);

        if (changeGameFont) then
            local _, fontSize, outline = _G.FCF_GetChatWindowInfo(chatFrame:GetID());
            chatFrame:SetFont(muiFont, fontSize, outline);
        end
	end
end

-- Override Blizzard Stuff -----------------------

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
hooksecurefunc("FCF_OpenTemporaryWindow", function()
	local chat =_G.FCF_GetCurrentChatFrame();

	if (chat) then
		chat:SetClampRectInsets(0, 0, 0, 0);
	end
end);

-- must be before chat is initialized!
for i = 1, NUM_CHAT_WINDOWS do
    _G["ChatFrame"..i]:SetClampRectInsets(0, 0, 0, 0);
end