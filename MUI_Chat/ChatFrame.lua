-- luacheck: ignore MayronUI self 143
-- @Description: Handles the MUI Chat Frame artwork that wraps around the blizzard Chat Frames

-- Setup namespaces ------------------
local _, namespace = ...;
local Engine = namespace.Engine;
local tk, _, em, gui, obj, L = MayronUI:GetCoreComponents();
local MEDIA = "Interface\\AddOns\\MUI_Chat\\media\\";
local _G = _G;

---@class ChatFrame;
local C_ChatFrame = namespace.C_ChatFrame;

local ChatMenu, CreateFrame, UIMenu_Initialize, UIMenu_AutoSize, string, table, pairs =
	_G.ChatMenu, _G.CreateFrame, _G.UIMenu_Initialize, _G.UIMenu_AutoSize, _G.string, _G.table, _G.pairs;

local UIMenu_AddButton, FriendsFrame_SetOnlineStatus = _G.UIMenu_AddButton, _G.FriendsFrame_SetOnlineStatus;

local FRIENDS_TEXTURE_ONLINE, FRIENDS_TEXTURE_AFK, FRIENDS_TEXTURE_DND =
	_G.FRIENDS_TEXTURE_ONLINE, _G.FRIENDS_TEXTURE_AFK, _G.FRIENDS_TEXTURE_DND;

local FRIENDS_LIST_AVAILABLE, FRIENDS_LIST_AWAY, FRIENDS_LIST_BUSY =
	_G.FRIENDS_LIST_AVAILABLE, _G.FRIENDS_LIST_AWAY, _G.FRIENDS_LIST_BUSY;

-- C_ChatFrame -----------------------

Engine:DefineParams("string", "ChatModule", "table");
---@param anchorName string position of chat frame (i.e. "TOPLEFT")
---@param chatModule ChatModule
---@param chatModuleSettings table
function C_ChatFrame:__Construct(data, anchorName, chatModule, chatModuleSettings)
	data.anchorName = anchorName;
	data.chatModule = chatModule;
	data.chatModuleSettings = chatModuleSettings;
	data.settings = chatModuleSettings.chatFrames[anchorName];
end

Engine:DefineParams("boolean");
---@param enabled boolean enable/disable the chat frame
function C_ChatFrame:SetEnabled(data, enabled)
	if (not data.frame and enabled) then
		data.frame = self:CreateFrame();
		self:SetUpTabBar(data.settings.tabBar);

		if (data.anchorName ~= "TOPLEFT") then
			self:Reposition();
		end

		if (_G.IsAddOnLoaded("Blizzard_CompactRaidFrames")) then
			data.chatModule:SetUpRaidFrameManager();
		else
			-- if it is not loaded, create a callback to trigger when it is loaded
			em:CreateEventHandler("ADDON_LOADED", function(_, name)
				if (name == "Blizzard_CompactRaidFrames") then
					data.chatModule:SetUpRaidFrameManager();
				end
			end):SetAutoDestroy(true);
		end

		-- chat channel button
		data.chatModule:SetUpLayoutButton(data.frame.layoutButton);
	end

	if (data.frame) then
		data.frame:SetShown(enabled);

		if (enabled) then
			self:SetUpButtonHandler(data.settings.buttons);
		end

		local muiChatFrame = _G["MUI_ChatFrame_" .. data.chatModuleSettings.icons.anchor];

		if (not (muiChatFrame and muiChatFrame:IsShown())) then
			muiChatFrame = data.frame;
		end

		if (muiChatFrame and muiChatFrame:IsShown()) then
			C_ChatFrame.Static:SetUpSideBarIcons(data.chatModuleSettings, muiChatFrame);
		else
			for anchorName, _ in pairs(data.chatModule:GetChatFrames()) do
				muiChatFrame = _G["MUI_ChatFrame_" .. anchorName];

				if (muiChatFrame and muiChatFrame:IsShown()) then
					C_ChatFrame.Static:SetUpSideBarIcons(data.chatModuleSettings, muiChatFrame);
					break;
				end
			end
		end
	end
end

function C_ChatFrame:CreateButtons(data)
	local butonMediaFile;
	data.buttons = obj:PopTable();

	for buttonID = 1, 3 do
		local btn = tk:PopFrame("Button", data.buttonsBar);
		data.buttons[buttonID] = btn;

		btn:SetSize(135, 20);
		btn:SetNormalFontObject("MUI_FontSmall");
		btn:SetHighlightFontObject("GameFontHighlightSmall");
		btn:SetText(tk.Strings.Empty);

		-- position button
		if (buttonID == 1) then
			btn:SetPoint("TOPLEFT");
		else
			local previousButton = data.buttons[#data.buttons - 1];
			btn:SetPoint("LEFT", previousButton, "RIGHT");
		end

		-- get button texture (first and last buttons share the same "side" texture)
		if (buttonID == 1 or buttonID == 3) then
			-- use "side" button texture
			butonMediaFile = string.format("%ssideButton", MEDIA);
		else
			-- use "middle" button texture
			butonMediaFile = string.format("%smiddleButton", MEDIA);
		end

		btn:SetNormalTexture(butonMediaFile);
		btn:SetHighlightTexture(butonMediaFile);

		if (buttonID == 3) then
			-- flip last button texture horizontally
			btn:GetNormalTexture():SetTexCoord(1, 0, 0, 1);
			btn:GetHighlightTexture():SetTexCoord(1, 0, 0, 1);
		end

		if (tk.Strings:Contains(data.anchorName, "BOTTOM")) then
			-- flip vertically

			if (buttonID == 3) then
				-- flip last button texture horizontally
				btn:GetNormalTexture():SetTexCoord(1, 0, 1, 0);
				btn:GetHighlightTexture():SetTexCoord(1, 0, 1, 0);
			else
				btn:GetNormalTexture():SetTexCoord(0, 1, 1, 0);
				btn:GetHighlightTexture():SetTexCoord(0, 1, 1, 0);
			end
		end
	end
end

Engine:DefineReturns("Frame");
---@return Frame returns an MUI chat frame
function C_ChatFrame:CreateFrame(data)
	local muiChatFrame = _G.CreateFrame("Frame", "MUI_ChatFrame_" .. data.anchorName, _G.UIParent);

    muiChatFrame:SetFrameStrata("LOW");
    muiChatFrame:SetFrameLevel(1);
	muiChatFrame:SetSize(358, 310);
	muiChatFrame:SetPoint(data.anchorName, 2, -2);

	muiChatFrame.sidebar = muiChatFrame:CreateTexture(nil, "ARTWORK");
	muiChatFrame.sidebar:SetTexture(string.format("%ssidebar", MEDIA));
	muiChatFrame.sidebar:SetSize(24, 300);
	muiChatFrame.sidebar:SetPoint(data.anchorName, 0, -10);

	muiChatFrame.window = tk:PopFrame("Frame", muiChatFrame);
	muiChatFrame.window:SetSize(367, 248);
	muiChatFrame.window:SetPoint("TOPLEFT", muiChatFrame.sidebar, "TOPRIGHT", 2, data.settings.window.yOffset);

	muiChatFrame.window.texture = muiChatFrame.window:CreateTexture(nil, "ARTWORK");
	muiChatFrame.window.texture:SetTexture(string.format("%swindow", MEDIA));
	muiChatFrame.window.texture:SetAllPoints(true);

	muiChatFrame.layoutButton = tk:PopFrame("Button", muiChatFrame);
	muiChatFrame.layoutButton:SetNormalFontObject("MUI_FontSmall");
	muiChatFrame.layoutButton:SetHighlightFontObject("GameFontHighlightSmall");
	muiChatFrame.layoutButton:SetText(" ");
	muiChatFrame.layoutButton:GetFontString():SetPoint("CENTER", 1, 0);
	muiChatFrame.layoutButton:SetSize(21, 120);
	muiChatFrame.layoutButton:SetPoint("LEFT", muiChatFrame.sidebar, "LEFT");
	muiChatFrame.layoutButton:SetNormalTexture(string.format("%slayoutButton", MEDIA));
	muiChatFrame.layoutButton:SetHighlightTexture(string.format("%slayoutButton", MEDIA));

	data.buttonsBar = tk:PopFrame("Frame", muiChatFrame);
	data.buttonsBar:SetSize(135 * 3, 20);
	data.buttonsBar:SetPoint("TOPLEFT", 20, 0);

	tk:ApplyThemeColor(
		muiChatFrame.layoutButton:GetNormalTexture(),
		muiChatFrame.layoutButton:GetHighlightTexture()
	);

	self:CreateButtons();

	return muiChatFrame;
end

function C_ChatFrame:SetUpTabBar(data, settings)
	if (settings.show) then
		if (not data.tabs) then
			data.tabs = data.frame:CreateTexture(nil, "ARTWORK");
			data.tabs:SetSize(358, 23);
			data.tabs:SetTexture(string.format("%stabs", MEDIA));
		end

		data.tabs:ClearAllPoints();

		if (tk.Strings:Contains(data.anchorName, "RIGHT")) then
			data.tabs:SetPoint(data.anchorName, data.frame.sidebar, "TOPLEFT", 0, settings.yOffset);
			data.tabs:SetTexCoord(1, 0, 0, 1);
		else
			data.tabs:SetPoint(data.anchorName, data.frame.sidebar, "TOPRIGHT", 0, settings.yOffset);
		end
	end

	if (data.tabs) then
		data.tabs:SetShown(settings.show);
	end
end

function C_ChatFrame:Reposition(data)
	data.frame:ClearAllPoints();
	data.frame.window:ClearAllPoints();
	data.frame.sidebar:ClearAllPoints();
	data.buttonsBar:ClearAllPoints();

	if (data.anchorName == "TOPRIGHT") then
		data.frame:SetPoint(data.anchorName, _G.UIParent, data.anchorName, -2, -2);
		data.frame.sidebar:SetPoint(data.anchorName, data.frame, data.anchorName, 0 , -10);
		data.frame.window:SetPoint("TOPRIGHT", data.frame.sidebar, "TOPLEFT", -2, data.settings.window.yOffset);
		data.frame.window.texture:SetTexCoord(1, 0, 0, 1);

	elseif (tk.Strings:Contains(data.anchorName, "BOTTOM")) then
		data.frame.sidebar:SetPoint(data.anchorName, data.frame, data.anchorName, 0 , 10);

		if (data.anchorName == "BOTTOMLEFT") then
			data.frame:SetPoint(data.anchorName, tk.UIParent, data.anchorName, 2, 2);
			data.frame.window:SetPoint("BOTTOMLEFT", data.frame.sidebar, "BOTTOMRIGHT", 2, data.settings.window.yOffset);
			data.frame.window.texture:SetTexCoord(0, 1, 1, 0);

		elseif (data.anchorName == "BOTTOMRIGHT") then
			data.frame:SetPoint(data.anchorName, tk.UIParent, data.anchorName, -2, 2);
			data.frame.window:SetPoint("BOTTOMRIGHT", data.frame.sidebar, "BOTTOMLEFT", -2, data.settings.window.yOffset);
			data.frame.window.texture:SetTexCoord(1, 0, 1, 0);
		end
	end

	if (tk.Strings:Contains(data.anchorName, "RIGHT")) then
		data.frame.layoutButton:SetPoint("LEFT", data.frame.sidebar, "LEFT", 2, 0);
		data.frame.layoutButton:GetNormalTexture():SetTexCoord(1, 0, 0, 1);
		data.frame.layoutButton:GetHighlightTexture():SetTexCoord(1, 0, 0, 1);
		data.frame.sidebar:SetTexCoord(1, 0, 0, 1);
		data.buttonsBar:SetPoint(data.anchorName, -20, 0);
	else
		data.buttonsBar:SetPoint(data.anchorName, 20, 0);
	end

	self:SetUpTabBar(data.settings.tabBar);
end

function C_ChatFrame.Static:SetUpSideBarIcons(chatModuleSettings, muiChatFrame)
	_G.ChatFrameChannelButton:DisableDrawLayer("ARTWORK");
	_G.ChatFrameToggleVoiceDeafenButton:DisableDrawLayer("ARTWORK");
	_G.ChatFrameToggleVoiceMuteButton:DisableDrawLayer("ARTWORK");

	local dummyFunc = function() return true; end

	_G.ChatFrameToggleVoiceDeafenButton:SetVisibilityQueryFunction(dummyFunc);
	_G.ChatFrameToggleVoiceDeafenButton:UpdateVisibleState();

	_G.ChatFrameToggleVoiceMuteButton:SetVisibilityQueryFunction(dummyFunc);
	_G.ChatFrameToggleVoiceMuteButton:UpdateVisibleState();

	self:PositionSideBarIcons(chatModuleSettings, muiChatFrame);
end

do
	local CreatePlayerStatusButton, CreateToggleEmoteButton, CreateCopyChatButton;

	local function PositionChatIconMenu(icon, menu)
		local chatFrameName = icon:GetParent():GetName();
		menu:ClearAllPoints();

		if (chatFrameName:find("TOPLEFT")) then
			menu:SetPoint("TOPLEFT", icon, "TOPRIGHT");

		elseif (chatFrameName:find("TOPRIGHT")) then
			menu:SetPoint("TOPRIGHT", icon, "TOPLEFT");

		elseif (chatFrameName:find("BOTTOMLEFT")) then
			menu:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT");

		elseif (chatFrameName:find("BOTTOMRIGHT")) then
			menu:SetPoint("BOTTOMRIGHT", icon, "BOTTOMLEFT");
		end

		icon:GetScript("OnLeave")(icon);
	end

	local function PositionIcon(enabled, currentIcon, anchorIcon, frame, createFunc)
		if (enabled) then
			if (not currentIcon) then
				currentIcon = createFunc(frame);
			end

			currentIcon:ClearAllPoints();
			currentIcon:SetParent(frame);

			if (anchorIcon) then
				currentIcon:SetPoint("BOTTOMLEFT", anchorIcon, "TOPLEFT", 0, 2);
			else
				currentIcon:SetPoint("BOTTOMLEFT", frame.sidebar, "BOTTOMLEFT", 1, 14);
			end

			currentIcon:Show();
			return currentIcon;

		elseif (currentIcon) then
			currentIcon:Hide();
		end

		return anchorIcon;
	end

	function C_ChatFrame.Static:PositionSideBarIcons(chatModuleSettings, muiChatFrame)
		_G.ChatFrameChannelButton:ClearAllPoints();
		_G.ChatFrameChannelButton:SetPoint("TOPLEFT", muiChatFrame.sidebar, "TOPLEFT", -1, -10);
		_G.ChatFrameChannelButton:SetParent(muiChatFrame);
		_G.ChatFrameToggleVoiceDeafenButton:SetParent(muiChatFrame);
		_G.ChatFrameToggleVoiceMuteButton:SetParent(muiChatFrame);

		local anchorIcon;

		anchorIcon = PositionIcon(chatModuleSettings.icons.playerStatus,
			_G.MUI_PlayerStatusButton, nil, muiChatFrame, CreatePlayerStatusButton);

		anchorIcon = PositionIcon(chatModuleSettings.icons.emotes,
			_G.MUI_ToggleEmotesButton, anchorIcon, muiChatFrame, CreateToggleEmoteButton);

		PositionIcon(chatModuleSettings.icons.copyChat,
			_G.MUI_CopyChatButton, anchorIcon, muiChatFrame, CreateCopyChatButton);
	end

	function CreateToggleEmoteButton(muiChatFrame)
		local toggleEmotesButton = _G.CreateFrame("Button", "MUI_ToggleEmotesButton", muiChatFrame);
		toggleEmotesButton:SetSize(24, 24);
		toggleEmotesButton:SetNormalTexture(string.format("%sspeechIcon", MEDIA));
		toggleEmotesButton:GetNormalTexture():SetVertexColor(tk.Constants.COLORS.GOLD:GetRGB());
		toggleEmotesButton:SetHighlightAtlas("chatframe-button-highlight");

		tk:SetBasicTooltip(toggleEmotesButton, L["Show Chat Menu"]);

		toggleEmotesButton:SetScript("OnClick", function(self)
			PositionChatIconMenu(self, ChatMenu);
			_G.ChatFrame_ToggleMenu();
		end);

		return toggleEmotesButton;
	end

	do
		local c = _G.CreateColor(1, 1, 1);

		local function ApplyColorToMessage(message, r, g, b)
			r, g, b = r or 1, g or 1, b or 1;
			c:SetRGB(r, g, b);

			local hex = "|c" .. c:GenerateHexColor();
			message = message:gsub("|r", string.format("|r%s", hex));
			message = string.format("%s%s|r", hex, message);

			return message;
		end

		-- accountName cannot be used as |K breaks the editBox
		local function ReplaceAccountNameCodeWithBattleTag(accountName)
			for i = 1, 200 do
				local friendInfo = C_BattleNet.GetAccountInfoByID(i);

				if(friendInfo ~= nil) then
					if (i > 50 and not friendInfo.accountName) then
						return "";
					end

					if (accountName == friendInfo.accountName) then
						return battleTag;
					end
				end
			end
		end

		local function RefreshChatText(editBox)
			local chatFrame = _G[string.format("ChatFrame%d", editBox.chatFrameID)];
			local messages = obj:PopTable();
			local totalMessages = chatFrame:GetNumMessages();
			local message, r, g, b;

			for i = 1, totalMessages do
				message, r, g, b = chatFrame:GetMessageInfo(i);

				if (obj:IsString(message) and #message > 0) then
					message = message:gsub("|Kq%d+|k", ReplaceAccountNameCodeWithBattleTag);
					message = ApplyColorToMessage(message, r, g, b);
					table.insert(messages, message);
				end
			end

			local fullText = table.concat(messages, " \n", 1, #messages);
			obj:PushTable(messages);

			editBox:SetText(fullText);
		end

		local function CreateChatTextFrame()
			local frame = CreateFrame("Frame", nil, _G.UIParent);
			frame:SetSize(600, 300);
			frame:SetPoint("CENTER");
			frame:Hide();

			gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, nil, frame);
			gui:AddCloseButton(tk.Constants.AddOnStyle, frame);
			gui:AddTitleBar(tk.Constants.AddOnStyle, frame, L["Copy Chat Text"]);

			local editBox = CreateFrame("EditBox", "MUI_CopyChatEditBox", frame);
			editBox:SetMultiLine(true);
			editBox:SetMaxLetters(99999);
			editBox:EnableMouse(true);
			editBox:SetAutoFocus(false);
			editBox:SetFontObject("GameFontHighlight");
			editBox:SetHeight(200);
			editBox.chatFrameID = 1;

			editBox:SetScript("OnEscapePressed", function(self)
				self:ClearFocus();
			end);

			local refreshButton = CreateFrame("Button", nil, frame);
			refreshButton:SetSize(18, 18);
			refreshButton:SetPoint("TOPRIGHT", frame.closeBtn, "TOPLEFT", -10, -3);
			refreshButton:SetNormalTexture("Interface\\Buttons\\UI-RefreshButton");
			refreshButton:SetHighlightAtlas("chatframe-button-highlight");
			tk:SetBasicTooltip(refreshButton, "Refresh Chat Text");

			refreshButton:SetScript("OnClick", function()
				RefreshChatText(editBox);
			end);

			local dropdown = gui:CreateDropDown(tk.Constants.AddOnStyle, frame);
			local dropdownContainer = dropdown:GetFrame();
			dropdownContainer:SetSize(150, 20);
			dropdownContainer:SetPoint("TOPRIGHT", refreshButton, "TOPLEFT", -10, 0);

			local function DropDown_OnOptionSelected(_, chatFrameID)
				editBox.chatFrameID = chatFrameID;
				RefreshChatText(editBox);
			end

			for chatFrameID = 1, _G.NUM_CHAT_WINDOWS do
				local tab = _G[string.format("ChatFrame%dTab", chatFrameID)];
				local tabText = tab.Text:GetText();

				if (obj:IsString(tabText) and #tabText > 0 and tab:IsShown()) then
					dropdown:AddOption(tabText, DropDown_OnOptionSelected, chatFrameID);
				end
			end

			local container = gui:CreateScrollFrame(tk.Constants.AddOnStyle, frame, "MUI_CopyChatFrame", editBox);
			container:SetPoint("TOPLEFT", 10, -30);
			container:SetPoint("BOTTOMRIGHT", -10, 10);

			container.ScrollFrame:ClearAllPoints();
			container.ScrollFrame:SetPoint("TOPLEFT", 5, -5);
			container.ScrollFrame:SetPoint("BOTTOMRIGHT", -5, 5);

			container.ScrollFrame:HookScript("OnScrollRangeChanged", function(self)
				local maxScroll = self:GetVerticalScrollRange();
				self:SetVerticalScroll(maxScroll);
			end);

			tk:SetBackground(container, 0, 0, 0, 0.4);

			frame.editBox = editBox;
			frame.dropdown = dropdown;
			return frame;
		end

		function CreateCopyChatButton(muiChatFrame)
			local copyChatButton = _G.CreateFrame("Button", "MUI_CopyChatButton", muiChatFrame);
			copyChatButton:SetSize(24, 24);
			copyChatButton:SetNormalTexture(string.format("%scopyIcon", MEDIA));
			copyChatButton:GetNormalTexture():SetVertexColor(tk.Constants.COLORS.GOLD:GetRGB());
			copyChatButton:SetHighlightAtlas("chatframe-button-highlight");

			tk:SetBasicTooltip(copyChatButton, L["Copy Chat Text"]);

			copyChatButton:SetScript("OnClick", function(self)
				if (not self.chatTextFrame) then
					self.chatTextFrame = CreateChatTextFrame();
				end

				-- get chat frame text:
				RefreshChatText(self.chatTextFrame.editBox);
				self.chatTextFrame:SetShown(not self.chatTextFrame:IsShown());

				local tab = _G[string.format("ChatFrame%dTab", self.chatTextFrame.editBox.chatFrameID)];
				local tabText = tab.Text:GetText();
				self.chatTextFrame.dropdown:SetLabel(tabText);

				self:GetScript("OnLeave")(self);
			end);

			return copyChatButton;
		end
	end

	function CreatePlayerStatusButton(muiChatFrame)
		local playerStatusButton = _G.CreateFrame("Button", "MUI_PlayerStatusButton", muiChatFrame);
		playerStatusButton:SetSize(24, 24);

		em:CreateEventHandler("BN_INFO_CHANGED", function()
			local status = _G.FRIENDS_TEXTURE_ONLINE;
			local _, _, _, _, bnetAFK, bnetDND = _G.BNGetInfo();

			if (bnetAFK) then
				status = _G.FRIENDS_TEXTURE_AFK;
			elseif (bnetDND) then
				status = _G.FRIENDS_TEXTURE_DND;
			end

			playerStatusButton:SetNormalTexture(status);
		end):Run();

		playerStatusButton:SetHighlightAtlas("chatframe-button-highlight");
		tk:SetBasicTooltip(playerStatusButton, L["Change Status"]);

		local statusMenu = CreateFrame("Frame", "MUI_StatusMenu", muiChatFrame, "UIMenuTemplate");
		UIMenu_Initialize(statusMenu);

		local optionText = "\124T%s.tga:16:16:0:0\124t %s";
		local availableText = string.format(optionText, FRIENDS_TEXTURE_ONLINE, FRIENDS_LIST_AVAILABLE);
		local afkText = string.format(optionText, FRIENDS_TEXTURE_AFK, FRIENDS_LIST_AWAY);
		local dndText = string.format(optionText, FRIENDS_TEXTURE_DND, FRIENDS_LIST_BUSY);

		local function SetOnlineStatus(btn)
			FriendsFrame_SetOnlineStatus(btn);
			playerStatusButton:SetNormalTexture(btn.value);
		end

		--self, text, shortcut, func, nested, value
		UIMenu_AddButton(statusMenu, availableText, nil, SetOnlineStatus, nil, FRIENDS_TEXTURE_ONLINE);
		UIMenu_AddButton(statusMenu, afkText, nil, SetOnlineStatus, nil, FRIENDS_TEXTURE_AFK);
		UIMenu_AddButton(statusMenu, dndText, nil, SetOnlineStatus, nil, FRIENDS_TEXTURE_DND);
		UIMenu_AutoSize(statusMenu);
		statusMenu:Hide();

		playerStatusButton:SetScript("OnClick", function(self)
			statusMenu:SetShown(not statusMenu:IsShown());

			if (statusMenu:IsShown()) then
				PositionChatIconMenu(self, statusMenu);
			end
		end);

		return playerStatusButton;
	end
end