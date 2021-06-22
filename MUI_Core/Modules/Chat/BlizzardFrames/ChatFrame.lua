-- luacheck: ignore MayronUI self 143
-- @Description: Controls the Blizzard Chat Frame changes (not the MUI Chat Frame!)
local string, MayronUI = _G.string, _G.MayronUI;
local pairs, ipairs, PlaySound, unpack = _G.pairs, _G.ipairs, _G.PlaySound, _G.unpack;
local select, GetChannelList = _G.select, _G.GetChannelList;

local tk, db, _, _, obj = MayronUI:GetCoreComponents();
local _, C_ChatModule = MayronUI:ImportModule("ChatModule");
--------------------------------------
local CHANNEL_PATTERNS = {
  "^(|Hchannel:.-|h%[.-%]|h |Hplayer:.-|h%[.-%]|h: )(.*)";
  "^(|Hplayer:.-|h%[.-%]|h.-: )(.*)"};

local function GetChatLink(url)
	return string.format("|Hurl:%s|h|cffffe29e%s|r|h", url, "["..url.."]");
end

local function HighlightText(text, highlighted)
  local prefix, body, playSound, changed;

  for _, pattern in ipairs(CHANNEL_PATTERNS) do
    prefix, body = text:match(pattern);

    if (prefix and body) then
      body = body:trim();

      -- highlight words of interest:
      for _, value in pairs(highlighted) do
        body, changed = tk.Strings:HighlightSubStringsByRGB(body, value, value.upperCase, unpack(value.color));

        if (changed and obj:IsNumber(value.sound) and not playSound) then
          playSound = value.sound; -- first sound only
        end
      end

      text = prefix .. body;
    end
  end

  if (playSound) then
    PlaySound(playSound);
  end

  return text;
end

local loadedChannels = {};
local function RenameAliases(text, settings, r, g, b)
  local changed;
  for i = 2, 60, 3 do
    local channelName = (select(i, GetChannelList()));
    if (channelName ==  nil) then break end
    if (obj:IsString(channelName) and not loadedChannels[channelName]) then
      local path = tk.Strings:Concat("profile.chat.aliases[", channelName, "]");
      local default = (channelName:gsub("[a-z%s]", ""));
      db:AddToDefaults(path, default);
      loadedChannels[channelName] = true;
      changed = true;
    end
  end

  if (changed) then
    settings:Refresh();
  end

  for channelName, alias in pairs(settings.aliases) do
    local channelID, body = text:match("^|Hchannel:(.-)|h%[.-" .. channelName .. ".-%]|h (.*)");

    if (channelID and body) then
      body = body:trim();
      alias = tk.Strings:SetTextColorByRGB(alias,
        r * settings.brightness,
        g * settings.brightness,
        b * settings.brightness);

      local prefix = "|Hchannel:" .. channelID .. "|h" .. alias .. " |h";
      text = prefix .. body;
      break;
    end
  end

  return text;
end

-- example: "|Hchannel:channel:4|h[4. LookingForGroup]|h |Hplayer:Numberone:12:CHANNEL:4|h[|cffaad372Numberone|r]|h: LF2M healer and dps UB HC!", 
local function NewAddMessage(self, settings, text, r, g, b, ...)
	if (not text) then return; end

  text = HighlightText(text, settings.highlighted);
  text = RenameAliases(text, settings, r, g, b);

	self:oldAddMessage(text:gsub("[wWhH][wWtT][wWtT][\46pP]%S+[^%p%s]", GetChatLink), r, g, b, ...);
end

local function OnHyperLinkLeave()
	_G.GameTooltip:Hide();
end

local function OnHyperLinkEnter(self, linkData)
	local linkType = string.split(":", linkData);

	if (tk:ValueIsEither(linkType, "item", "spell", "enchant", "quest", "talent", "glyph", "unit", "achievement")) then
		_G.GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
		_G.GameTooltip:SetHyperlink(linkData);
		_G.GameTooltip:Show();
	end
end

local function OnHyperLinkClick(self, linkData, text, button)
	local linkType, value = linkData:match("(%a+):(.+)");

	if (linkType == "url") then
		local popup = _G.StaticPopup_Show("MUI_Link");
		local editbox = _G[ string.format("%sEditBox", popup:GetName()) ];

		editbox:SetText(value);
		editbox:SetFocus();
		editbox:HighlightText();
	elseif (linkData == "weakauras") then
		_G.ChatFrame_OnHyperlinkShow(self, linkData, text, button);
	else
		_G.SetItemRef(linkData, text, button, self);
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
			self:PageUp();
		else
			self:PageDown();
		end
	end
end

local function Tab_OnClick(self)
	self.ChatFrame:ScrollToBottom();

	for chatFrameID = 1, _G.NUM_CHAT_WINDOWS do
		local tab = _G[ string.format("ChatFrame%dTab", chatFrameID) ];
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

local function RepositionNotificationFrame(chatFrame)
	if (not chatFrame:GetName() == "ChatFrame1") then
		return;
	end

	local tab = _G.ChatFrame1Tab;
	local relativePoint = chatFrame:GetPoint();
	_G.ChatAlertFrame:ClearAllPoints(); -- parent of BNToastFrame

	if (relativePoint:find("TOP")) then
		_G.ChatAlertFrame:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", 0, -60);

	elseif (relativePoint:find("BOTTOM")) then
		_G.ChatAlertFrame:SetPoint("BOTTOMLEFT", tab, "TOPLEFT", 0, 10);
	end
end

function C_ChatModule:SetUpBlizzardChatFrame(data, chatFrameName)
  if (not data.ProcessedChatFrames) then
    data.ProcessedChatFrames = {};
  end

  if (data.ProcessedChatFrames[chatFrameName]) then
    return; -- return because frame has already being processed before
  end

  local chatFrame = _G[chatFrameName];
  chatFrame:SetMovable(true);
  chatFrame:SetClampedToScreen(true);
  chatFrame:SetUserPlaced(true);
  chatFrame:SetMaxResize(1200, 800);
	chatFrame:SetFrameStrata("LOW");
  chatFrame:HookScript("OnMouseWheel", ChatFrame_OnMouseWheel);
	_G[string.format("%sEditBox", chatFrameName)]:SetAltArrowKeyMode(false);

	if (chatFrame:GetID() ~= 2) then
		-- if not combat log...
		chatFrame.oldAddMessage = chatFrame.AddMessage;
		chatFrame.AddMessage = function(self, text, r, g, b)
      NewAddMessage(self, data.settings, text, r, g, b);
    end;

		chatFrame:SetScript("OnHyperLinkEnter", OnHyperLinkEnter);
		chatFrame:SetScript("OnHyperLinkLeave", OnHyperLinkLeave);
		chatFrame:SetScript("OnHyperlinkClick", OnHyperLinkClick);
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
    _G[ string.format("%sEditBoxLeft", chatFrameName) ],
		_G[ string.format("%sEditBoxMid", chatFrameName) ],
		_G[ string.format("%sEditBoxRight", chatFrameName) ],
		_G[ string.format("%sTabSelectedLeft", chatFrameName) ],
		_G[ string.format("%sTabSelectedMiddle", chatFrameName) ],
		_G[ string.format("%sTabSelectedRight", chatFrameName) ],
		_G[ string.format("%sTabLeft", chatFrameName) ],
		_G[ string.format("%sTabMiddle", chatFrameName) ],
		_G[ string.format("%sTabRight", chatFrameName) ],
		_G[ string.format("%sTabHighlightLeft", chatFrameName) ],
		_G[ string.format("%sTabHighlightMiddle", chatFrameName) ],
    _G[ string.format("%sTabHighlightRight", chatFrameName) ],
    _G[ string.format("%sButtonFrameUpButton", chatFrameName) ],
    _G[ string.format("%sButtonFrameDownButton", chatFrameName) ],
    _G[ string.format("%sButtonFrameMinimizeButton", chatFrameName) ],
    _G[ string.format("%sButtonFrame", chatFrameName) ]
  );

	if (chatFrameName == "ChatFrame1") then
		_G.hooksecurefunc("FCF_StopDragging", RepositionNotificationFrame);
		RepositionNotificationFrame(chatFrame);

		_G.BNToastFrame:ClearAllPoints();
		_G.BNToastFrame:SetPoint("BOTTOMLEFT", _G.ChatAlertFrame, "BOTTOMLEFT", 0, 0);
		_G.BNToastFrame.ClearAllPoints = tk.Constants.DUMMY_FUNC;
		_G.BNToastFrame.SetPoint = tk.Constants.DUMMY_FUNC;
	end

  data.ProcessedChatFrames[chatFrameName] = chatFrame;

	return chatFrame;
end

function C_ChatModule:SetUpAllBlizzardFrames()
  local changeGameFont = db.global.core.changeGameFont;
  local muiFont = tk.Constants.LSM:Fetch("font", db.global.core.font);

  for _, chatFrameName in ipairs(_G.CHAT_FRAMES) do
    local chatFrame = self:SetUpBlizzardChatFrame(chatFrameName);
    if (changeGameFont and chatFrame) then
      local _, fontSize, outline = _G.FCF_GetChatWindowInfo(chatFrame:GetID());
      chatFrame:SetFont(muiFont, fontSize, outline);
    end
  end
end