-- luacheck: ignore MayronUI self 143
-- @Description: Controls the Blizzard Chat Frame changes (not the MUI Chat Frame!)

-- Setup namespaces ------------------
local _, namespace = ...;
local C_ChatModule = namespace.C_ChatModule;
local tk = MayronUI:GetCoreComponents();
--------------------------------------

local function GetChatLink(text, id, url)
	return tk.string.format("|H%s:%s|h|cffffe29e%s|r|h", id, url, text);
end

local function GetChatLinkWrapper(url)
	return GetChatLink("["..url.."]", "url", url);
end

local function NewAddMessage(self, text, ...)
	if (not text) then return; end
	self:oldAddMessage(text:gsub("[wWhH][wWtT][wWtT][\46pP]%S+[^%p%s]", GetChatLinkWrapper), ...);
end

local function OnHyperLinkLeave()
	_G.GameTooltip:Hide();
end

local function OnHyperlinkEnter(self, linkData)
	local linkType = tk.string.split(":", linkData);

	-- TODO: missing type for new community link?
	if (linkType == "item" or linkType == "spell" or linkType == "enchant" or
			linkType == "quest" or linkType == "talent" or linkType == "glyph" or
			linkType == "unit" or linkType == "achievement") then

		_G.GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
		_G.GameTooltip:SetHyperlink(linkData);
		_G.GameTooltip:Show();
	end
end

local function OnHyperlinkClick(self, linkData, link, button)
	local linkType, value = linkData:match("(%a+):(.+)");

	if (linkType == "url") then
		local popup = _G.StaticPopup_Show("MUI_Link");
		local editbox = _G[ string.format("%sEditBox", popup:GetName()) ];

		editbox:SetText(value);
		editbox:SetFocus();
		editbox:HighlightText();
	else
		_G.SetItemRef(linkData, link, button, self);
	end
end

local function ChatFrame_OnMouseWheel(self, direction)
	if (tk:IsModComboActive("C")) then
		if (direction == 1) then
			self:ScrollToTop();
		else
			self:ScrollToBottom();
		end
	elseif (tk:IsModComboActive("S")) then
		if (direction == 1) then
			self:PageUp() ;
		else
			self:PageDown() ;
		end
	end
end

local function Tab_OnClick(self)
	self.ChatFrame:ScrollToBottom();

	for chatFrameID = 1, _G.NUM_CHAT_WINDOWS do
		local tab = tk._G[ string.format("ChatFrame%dTab", chatFrameID) ];
		local tabLabel = tab:GetFontString();

		if (self == tab) then
			tabLabel:SetTextColor(1, 1, 1, 1);
		else
			tk:ApplyThemeColor(tabLabel);
		end
	end
end

local function Tab_OnEnter(self)
	-- set tab label white on mouse over
	self:GetFontString():SetTextColor(1, 1, 1, 1);
end

local function Tab_OnLeave(self)
	local tabLabel = self:GetFontString();

	if (self.ChatFrame == _G.SELECTED_CHAT_FRAME) then
		-- tab label should be white if selected
		tabLabel:SetTextColor(1, 1, 1, 1);
	else
		-- else, set label to class color
		tk:ApplyThemeColor(tabLabel);
	end
end

function C_ChatModule:SetUpBlizzardChatFrame(_, chatFrameID)
	local chatFrameName = string.format("ChatFrame%d", chatFrameID);

	local chatFrame = _G[chatFrameName];
	chatFrame:SetFrameStrata("LOW");
	chatFrame:HookScript("OnMouseWheel", ChatFrame_OnMouseWheel);

	_G[string.format("%sEditBox", chatFrameName)]:SetAltArrowKeyMode(false);

	if (chatFrameID ~= 2) then
		-- if not combat log...
		chatFrame.oldAddMessage = chatFrame.AddMessage;
		chatFrame.AddMessage = NewAddMessage;
		chatFrame:SetScript("OnHyperLinkEnter", OnHyperlinkEnter);
		chatFrame:SetScript("OnHyperLinkLeave", OnHyperLinkLeave);
		chatFrame:SetScript("OnHyperlinkClick", OnHyperlinkClick);
	end

	local tab = _G[string.format("%sTab", chatFrameName)];
	tab.ChatFrame = chatFrame; -- needed for scripts

	tab:SetHeight(16);
	tab:SetFrameStrata("MEDIUM");
	tab:HookScript("OnClick", Tab_OnClick);
	tab:SetScript("OnEnter", Tab_OnEnter);
	tab:SetScript("OnLeave", Tab_OnLeave);
	Tab_OnLeave(tab); -- run script to set correct label color

	local tabLabel = tab:GetFontString();
	tabLabel:ClearAllPoints();
	tabLabel:SetPoint("CENTER", tab, "CENTER");

	local btn = _G[ string.format("%sButtonFrame", chatFrameName) ];
	btn:ClearAllPoints();
	btn:DisableDrawLayer("BACKGROUND");
	btn:DisableDrawLayer("BORDER");
	btn:EnableMouse(false);
	btn:SetPoint("BOTTOM", tab, "BOTTOM", 0, -2);
	btn:SetSize(tab:GetWidth() - 10, 20);

	btn.EnableMouse = tk.Constants.DUMMY_FUNC;

	tk:KillAllElements(
		_G[ string.format("%sTabSelectedLeft", chatFrameName) ],
		_G[ string.format("%sTabSelectedMiddle", chatFrameName) ],
		_G[ string.format("%sTabSelectedRight", chatFrameName) ],
		_G[ string.format("%sTabLeft", chatFrameName) ],
		_G[ string.format("%sTabMiddle", chatFrameName) ],
		_G[ string.format("%sTabRight", chatFrameName) ],
		_G[ string.format("%sTabHighlightLeft", chatFrameName) ],
		_G[ string.format("%sTabHighlightMiddle", chatFrameName) ],
		_G[ string.format("%sTabHighlightRight", chatFrameName) ]
    );

    return chatFrame;
end