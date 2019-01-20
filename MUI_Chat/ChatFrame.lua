-- luacheck: ignore MayronUI self 143
-- @Description: Handles the MUI Chat Frame artwork that wraps around the blizzard Chat Frames

-- Setup namespaces ------------------
local _, namespace = ...;
local C_ChatModule = namespace.C_ChatModule;
local tk, _, _, _, obj = MayronUI:GetCoreComponents();

local MEDIA = "Interface\\AddOns\\MUI_Chat\\media\\";
--------------------------------------

local function CreateChatFrameButtons(sideBar, anchorName)
	local butonMediaFile;
	local buttons = {};

	for buttonID = 1, 3 do
		local btn = tk:PopFrame("Button", sideBar:GetParent());
		buttons[buttonID] = btn;

		btn:SetSize(135, 20);
		btn:SetNormalFontObject("MUI_FontSmall");
		btn:SetHighlightFontObject("GameFontHighlightSmall");
		btn:SetText(" ");

		-- position button
		if (buttonID == 1) then
			btn:SetPoint("TOPLEFT", sideBar, "TOPRIGHT", 0, 10);
		else
			local previousButton = buttons[#buttons - 1];
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

		if (tk.Strings:Contains(anchorName, "BOTTOM")) then
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

	return buttons;
end

--@param (string) anchorName: The anchor point for the chat frame (i.e. "TOPLEFT")
local function CreateChatFrame(anchorName)
	-- remove all spaces and convert to upper
	anchorName = anchorName:gsub("%s+", ""):upper();

	local muiChatFrame = tk:PopFrame("Frame");

    muiChatFrame:SetFrameStrata("LOW");
    muiChatFrame:SetFrameLevel(1);
	muiChatFrame:SetSize(358, 310);
	muiChatFrame:SetPoint(anchorName, 2, -2);

	muiChatFrame.sidebar = muiChatFrame:CreateTexture(nil, "ARTWORK");
	muiChatFrame.sidebar:SetTexture(string.format("%ssidebar", MEDIA));
	muiChatFrame.sidebar:SetSize(24, 300);
	muiChatFrame.sidebar:SetPoint(anchorName, 0, -10);

	muiChatFrame.tabs = muiChatFrame:CreateTexture(nil, "ARTWORK");
	muiChatFrame.tabs:SetTexture(string.format("%stabs", MEDIA));
	muiChatFrame.tabs:SetSize(358, 23);
	muiChatFrame.tabs:SetPoint(anchorName, muiChatFrame.sidebar, "TOPRIGHT", 0, -12);

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

	tk:ApplyThemeColor(
		muiChatFrame.layoutButton:GetNormalTexture(),
		muiChatFrame.layoutButton:GetHighlightTexture()
	);

	muiChatFrame.buttons = CreateChatFrameButtons(muiChatFrame.sidebar, anchorName);

	return muiChatFrame;
end

local function RepositionChatFrame(muiChatFrame, anchorName)
	muiChatFrame:ClearAllPoints();
	muiChatFrame.window:ClearAllPoints();
	muiChatFrame.sidebar:ClearAllPoints();
	muiChatFrame.buttons[1]:ClearAllPoints();

	if (anchorName == "TOPRIGHT") then
		muiChatFrame:SetPoint(anchorName, tk.UIParent, anchorName, -2, -2);
		muiChatFrame.window:SetPoint(anchorName, muiChatFrame.tabs, "BOTTOMRIGHT", -2, -2);
		muiChatFrame.window.texture:SetTexCoord(1, 0, 0, 1);
		muiChatFrame.sidebar:SetPoint(anchorName, muiChatFrame, anchorName, 0 , -10);
		muiChatFrame.buttons[1]:SetPoint("BOTTOMLEFT", muiChatFrame.tabs, "TOPLEFT", -46, 2);
		muiChatFrame.tabs:ClearAllPoints();
		muiChatFrame.tabs:SetPoint(anchorName, muiChatFrame.sidebar, "TOPLEFT", 0, -12);
		muiChatFrame.tabs:SetTexCoord(1, 0, 0, 1);

	elseif (tk.Strings:Contains(anchorName, "BOTTOM")) then
		muiChatFrame.tabs:Hide(); -- TODO: Should be configurable!
		muiChatFrame.sidebar:SetPoint(anchorName, muiChatFrame, anchorName, 0 , 10);

		if (anchorName == "BOTTOMLEFT") then
			muiChatFrame:SetPoint(anchorName, tk.UIParent, anchorName, 2, 2);
			muiChatFrame.window:SetPoint(anchorName, muiChatFrame.sidebar, "BOTTOMRIGHT", 2, 12);
			muiChatFrame.window.texture:SetTexCoord(0, 1, 1, 0);
			muiChatFrame.buttons[1]:SetPoint("BOTTOMLEFT", muiChatFrame.sidebar, "BOTTOMRIGHT", 0, -10);

		elseif (anchorName == "BOTTOMRIGHT") then
			muiChatFrame:SetPoint(anchorName, tk.UIParent, anchorName, -2, 2);
			muiChatFrame.window:SetPoint(anchorName, muiChatFrame.sidebar, "BOTTOMLEFT", -2, 12);
			muiChatFrame.window.texture:SetTexCoord(1, 0, 1, 0);
			muiChatFrame.buttons[1]:SetPoint("BOTTOMLEFT", muiChatFrame.window, "BOTTOMLEFT", -36, -22);
		end
	end

	if (tk.Strings:Contains(anchorName, "RIGHT")) then
		muiChatFrame.layoutButton:SetPoint("LEFT", muiChatFrame.sidebar, "LEFT", 2, 0);
		muiChatFrame.layoutButton:GetNormalTexture():SetTexCoord(1, 0, 0, 1);
		muiChatFrame.layoutButton:GetHighlightTexture():SetTexCoord(1, 0, 0, 1);
		muiChatFrame.sidebar:SetTexCoord(1, 0, 0, 1);
	end
end

-- C_ChatModule -------------------

function C_ChatModule:ShowMuiChatFrame(data, anchorName) -- lets assume it's enabled!
	-- remove all spaces and convert to upper
	anchorName = anchorName:gsub("%s+", ""):upper();

	data.chatFrames = data.chatFrames or obj:PopWrapper();
	local muiChatFrame = data.chatFrames[anchorName];

	if (not muiChatFrame) then
		muiChatFrame = CreateChatFrame(anchorName);
		data.chatFrames[anchorName] = muiChatFrame;

		obj:Assert(obj:IsType(muiChatFrame, "Frame"),
			"Could not find chat frame at anchor point '%s'", anchorName);

		if (anchorName ~= "TOPLEFT") then
			RepositionChatFrame(muiChatFrame, anchorName);
		end

		-- chat channel button
		_G.ChatFrameChannelButton:ClearAllPoints();
		_G.ChatFrameChannelButton:SetPoint("TOPLEFT", muiChatFrame.sidebar, "TOPLEFT", -1, -10);
		_G.ChatFrameChannelButton:DisableDrawLayer("ARTWORK");

		_G.ChatFrameChannelButton.ClearAllPoints = tk.Constants.DUMMY_FUNC;
		_G.ChatFrameChannelButton.SetPoint = tk.Constants.DUMMY_FUNC;

		self:SetUpLayoutSwitcher(muiChatFrame.layoutButton);
	end

	muiChatFrame:Show();
	return muiChatFrame;
end
