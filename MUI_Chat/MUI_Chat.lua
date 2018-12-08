-- luacheck: ignore MayronUI self 143
-- Setup namespaces ------------------
local _, namespace = ...;
local tk, db, em, _, _, L = MayronUI:GetCoreComponents();

-- Register and Import ---------

local C_ChatModule = MayronUI:RegisterModule("Chat");
namespace.C_ChatModule = C_ChatModule;

-- Load Database Defaults --------------

db:AddToDefaults("profile.chat", {
	enabled = true,
	swapInCombat = false,
	layout = "DPS", -- default layout
	chatFrames = {
		-- these tables will contain the templateMuiChatFrame data (using SetParent)
		TOPLEFT = {
			enabled = true,
		},
		TOPRIGHT = {
			enabled = false,
		},
		BOTTOMLEFT = {
			enabled = false,
		},
		BOTTOMRIGHT = {
			enabled = false,
		}
	},
    editBox = {
        yOffset = -8,
        height = 27,
        border = "Skinner",
        inset = 0,
        borderSize = 1,
        backdropColor = {r = 0, g = 0, b = 0, a = 0.6},
	},
	templateMuiChatFrame = {
		buttons = {
			{   L["Character"],
				L["Spell Book"],
				L["Talents"],
			},
			{   key = "C", -- CONTROL
				L["Friends"],
				L["Guild"],
				L["Quest Log"],
			},
			{   key = "S", -- SHIFT
				L["Achievements"],
				L["Collections Journal"],
				L["Encounter Journal"]
			}
		}
	}
});

db:AddToDefaults("global.chat", {
	layouts = {
		["DPS"] = {
			["ShadowUF"] = "Default",
			["Grid"] = "Default",
		},
		["Healer"] = {
			["ShadowUF"] = "MayronUIH",
			["Grid"] = "MayronUIH",
		}
	}
});

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
		_G.ChatFrame1EditBox.focusLeft,
		_G.ChatFrame1EditBox.focusRight,
		_G.ChatFrame1EditBox.focusMid,
		_G.ChatFrame1EditBoxLeft,
		_G.ChatFrame1EditBoxMid,
		_G.ChatFrame1EditBoxRight,
		_G.ChatFrameMenuButton,
		_G.QuickJoinToastButton
	);
end

local function ReskinEditBox(editBoxSettings)
    _G.ChatFrame1EditBox:SetPoint("TOPLEFT", _G.ChatFrame1, "BOTTOMLEFT", -3, editBoxSettings.yOffset);
	_G.ChatFrame1EditBox:SetPoint("TOPRIGHT", _G.ChatFrame1, "BOTTOMRIGHT", 3, editBoxSettings.yOffset);

	-- Set Edit Box Backdrop
    local inset = editBoxSettings.inset;
    local backdrop = {
        bgFile = "Interface\\Buttons\\WHITE8X8",
        insets = {left = inset, right = inset, top = inset, bottom = inset};
	};

    backdrop.edgeFile = tk.Constants.LSM:Fetch("border", editBoxSettings.border);
    backdrop.edgeSize = editBoxSettings.borderSize;
	_G.ChatFrame1EditBox:SetBackdrop(backdrop);

    local c = editBoxSettings.backdropColor;
	_G.ChatFrame1EditBox:SetBackdropColor(c.r, c.g, c.b, c.a);
	_G.ChatFrame1EditBox:SetHeight(editBoxSettings.height);
end

-- Chat Module -------------------

function C_ChatModule:OnInitialize(data)
	data.sv = db.profile.chat;

    tk.StaticPopupDialogs["MUI_Link"] = {
		text = tk.Strings:GetThemeColoredText("MayronUI").."\n(CTRL+C to Copy, CTRL+V to Paste)",
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
	ReskinEditBox(data.sv.editBox:ToTable());

	local changeGameFont = db.global.core.changeGameFont;
	local muiFont = tk.Constants.LSM:Fetch("font", db.global.core.font);

	for chatFrameID = 1, _G.NUM_CHAT_WINDOWS do
		local chatFrame = self:SetUpBlizzardChatFrame(chatFrameID);

        if (changeGameFont) then
            local _, fontSize, outline = _G.FCF_GetChatWindowInfo(chatFrame:GetID());
            chatFrame:SetFont(muiFont, fontSize, outline);
        end
	end

	for anchorName, _ in data.sv.chatFrames:Iterate() do
		local chatFrameData = data.sv.chatFrames[anchorName];

		if (chatFrameData.enabled) then
			chatFrameData:SetParent(data.sv.templateMuiChatFrame);

			local muiChatFrame = self:ShowMuiChatFrame(anchorName);
			self:SetUpButtonHandler(muiChatFrame, chatFrameData.buttons);

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
_G.CHAT_FONT_HEIGHTS = {8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18};

----------------------------------
-- Override Blizzard Functions:
----------------------------------
local function RepositionChatTab()
	_G.ChatFrame1Tab:SetPoint("LEFT", 16, 0);
end

-- override with a dummy function
--luacheck: ignore FCFTab_UpdateColors
function FCFTab_UpdateColors() end

--luacheck: ignore FCF_SetTabPosition
function FCF_SetTabPosition(chatFrame)
	local chatFrameTab = _G[string.format("%sTab", chatFrame:GetName())];

	if (not chatFrame.isDocked) then
		chatFrameTab:ClearAllPoints();

		if (_G.IsCombatLog(chatFrame)) then
            chatFrameTab:SetPoint("BOTTOMLEFT", _G["CombatLogQuickButtonFrame_Custom"], "TOPLEFT", 15, 10);
		else
            chatFrameTab:SetPoint("BOTTOMLEFT", chatFrame, "TOPLEFT", 15, 10);
		end
	end

	RepositionChatTab();

	local minButton = _G[string.format("%sButtonFrameMinimizeButton", chatFrame:GetName())];
    minButton:Hide();
end

_G.hooksecurefunc("FCFTab_OnUpdate", RepositionChatTab);
_G.hooksecurefunc("FCF_DockUpdate", RepositionChatTab);
_G.hooksecurefunc("FCFDockScrollFrame_JumpToTab", RepositionChatTab);
_G.hooksecurefunc("ChatEdit_UpdateHeader", function()
	local chatType = _G.ChatFrame1EditBox:GetAttribute("chatType");
	local r, g, b = _G.GetMessageTypeColor(chatType);
	_G.ChatFrame1EditBox:SetBackdropBorderColor(r, g, b, 1);
end);

-- probably not needed
tk.hooksecurefunc("FCF_OpenTemporaryWindow", function()
	local chat =_G.FCF_GetCurrentChatFrame();

	if (chat) then
		chat:SetClampRectInsets(0, 0, 0, 0);
	end
end);

-- must be before chat is initialized!
for i = 1, _G.NUM_CHAT_WINDOWS do
    tk._G["ChatFrame"..i]:SetClampRectInsets(0, 0, 0, 0);
end
