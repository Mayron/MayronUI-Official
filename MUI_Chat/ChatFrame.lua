-- luacheck: ignore MayronUI self 143
-- @Description: Handles the MUI Chat Frame artwork that wraps around the blizzard Chat Frames

-- Setup namespaces ------------------
local _, namespace = ...;
local Engine = namespace.Engine;
local tk, _, em, _, obj = MayronUI:GetCoreComponents();
local MEDIA = "Interface\\AddOns\\MUI_Chat\\media\\";

---@class ChatFrame;
local C_ChatFrame = namespace.C_ChatFrame;

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

	if (anchorName == "TOPLEFT") then
		if (tk.IsAddOnLoaded("Blizzard_CompactRaidFrames")) then
			chatModule:SetUpRaidFrameManager();
		else
			-- if it is not loaded, create a callback to trigger when it is loaded
			em:CreateEventHandler("ADDON_LOADED", function(_, name)
				if (name == "Blizzard_CompactRaidFrames") then
					chatModule:SetUpRaidFrameManager();
				end
			end):SetAutoDestroy(true);
		end
	end
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

		-- chat channel button
		data.chatModule:SetUpLayoutSwitcher(data.frame.layoutButton);
	end

	if (data.frame) then
		data.frame:SetShown(enabled);

		if (enabled) then
		self:SetUpButtonHandler(data.settings.buttons);
		end

		local muiChatFrame = _G["MUI_ChatFrame_" .. data.chatModuleSettings.voiceChatIcons];

		if (not (muiChatFrame and muiChatFrame:IsShown()) and enabled) then
			muiChatFrame = data.frame;
		end

		if (muiChatFrame and muiChatFrame == data.frame and enabled) then
			_G.ChatFrameChannelButton:ClearAllPoints();
			_G.ChatFrameChannelButton:SetPoint("TOPLEFT", muiChatFrame.sidebar, "TOPLEFT", -1, -10);
			_G.ChatFrameChannelButton:DisableDrawLayer("ARTWORK");
			_G.ChatFrameToggleVoiceDeafenButton:DisableDrawLayer("ARTWORK");
			_G.ChatFrameToggleVoiceMuteButton:DisableDrawLayer("ARTWORK");
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
	muiChatFrame.window:SetPoint("TOPLEFT", muiChatFrame.tabs, "BOTTOMLEFT", 2, -2);

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
		data.frame.window:SetPoint(data.anchorName, data.frame.tabs, "BOTTOMRIGHT", -2, -2);
		data.frame.window.texture:SetTexCoord(1, 0, 0, 1);
		data.frame.sidebar:SetPoint(data.anchorName, data.frame, data.anchorName, 0 , -10);

	elseif (tk.Strings:Contains(data.anchorName, "BOTTOM")) then
		data.frame.sidebar:SetPoint(data.anchorName, data.frame, data.anchorName, 0 , 10);

		if (data.anchorName == "BOTTOMLEFT") then
			data.frame:SetPoint(data.anchorName, tk.UIParent, data.anchorName, 2, 2);
			data.frame.window:SetPoint(data.anchorName, data.frame.sidebar, "BOTTOMRIGHT", 2, 12);
			data.frame.window.texture:SetTexCoord(0, 1, 1, 0);

		elseif (data.anchorName == "BOTTOMRIGHT") then
			data.frame:SetPoint(data.anchorName, tk.UIParent, data.anchorName, -2, 2);
			data.frame.window:SetPoint(data.anchorName, data.frame.sidebar, "BOTTOMLEFT", -2, 12);
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