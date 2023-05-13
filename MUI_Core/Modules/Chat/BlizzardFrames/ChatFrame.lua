-- luacheck: ignore MayronUI self 143
-- @Description: Controls the Blizzard Chat Frame changes (not the MUI Chat Frame!)
local _G = _G;
local string, MayronUI = _G.string, _G.MayronUI;
local pairs, ipairs, PlaySound, unpack = _G.pairs, _G.ipairs, _G.PlaySound, _G.unpack;
local select, GetChannelList, hooksecurefunc = _G.select, _G.GetChannelList, _G.hooksecurefunc;

local tk, db, _, gui, obj = MayronUI:GetCoreComponents();
local _, C_ChatModule = MayronUI:ImportModule("ChatModule");
--------------------------------------
local CHANNEL_PATTERNS = {
  "(|Hchannel:.-|h%[.-%]|h |Hplayer:.-|h%[.-%]|h: )(.*)";
  "(|Hplayer:.-|h%[.-%]|h.-: )(.*)"};

local function GetChatLink(url)
	return string.format("|Hurl:%s|h|cffffe29e%s|r|h", url, "["..url.."]");
end

local function HighlightText(text, highlighted)
  local prefix, body, time, playSound, changed;

  for _, pattern in ipairs(CHANNEL_PATTERNS) do
    if (_G.CHAT_TIMESTAMP_FORMAT) then
      time, prefix, body = text:match("(.-)" .. pattern);
    else
      prefix, body = text:match("^" .. pattern);
    end

    if (prefix and body) then
      body = body:trim();

      -- highlight words of interest:
      for _, value in pairs(highlighted) do
        body, changed = tk.Strings:HighlightSubStringsByRGB(body, value, value.upperCase, unpack(value.color));

        if (changed and obj:IsNumber(value.sound) and not playSound) then
          playSound = value.sound; -- first sound only
        end
      end

      if (time) then
        text = time .. prefix .. body;
      else
        text = prefix .. body;
      end

      break
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

      if (tk.Strings:IsNilOrWhiteSpace(default)) then
        default = channelName;
      end

      db:AddToDefaults(path, default);
      loadedChannels[channelName] = true;
      changed = true;
    end
  end

  if (changed) then
    settings:Refresh();
  end

  for channelName, alias in pairs(settings.aliases) do
    local time, channelID, body;

    if (_G.CHAT_TIMESTAMP_FORMAT) then
      time, channelID, body = text:match("(.-)|Hchannel:(.-)|h%[.-" .. channelName .. ".-%]|h (.*)");
    else
      channelID, body = text:match("^|Hchannel:(.-)|h%[.-" .. channelName .. ".-%]|h (.*)");
    end

    if (channelID and body) then
      body = body:trim();
      alias = tk.Strings:SetTextColorByRGB(alias,
        r * settings.brightness,
        g * settings.brightness,
        b * settings.brightness);

      local prefix = "|Hchannel:" .. channelID .. "|h" .. alias .. " |h";

      if (obj:IsString(time)) then
        text = time .. prefix .. body;
      else
        text = prefix .. body;
      end

      break
    end
  end

  return text;
end

-- example: "|Hchannel:channel:4|h[4. LookingForGroup]|h |Hplayer:Numberone:12:CHANNEL:4|h[|cffaad372Numberone|r]|h: LF2M healer and dps UB HC!", 
local function NewAddMessage(self, settings, text, r, g, b, ...)
	if (not text) then return; end

  if (obj:IsTable(settings.highlighted)) then
    text = HighlightText(text, settings.highlighted);
  end

  if (settings.enableAliases) then
    text = RenameAliases(text, settings, r, g, b);
  end

  if (settings.useTimestampColor and _G.CHAT_TIMESTAMP_FORMAT) then
    for _, pattern in ipairs(CHANNEL_PATTERNS) do
      local time, prefix, body = text:match("(.-)" .. pattern);
      if (time and prefix and body) then
        time = tk.Strings:SetTextColorByRGB(time,
          settings.timestampColor.r,
          settings.timestampColor.g,
          settings.timestampColor.b);

        text = time .. prefix .. body;
        break
      end
    end
  end

  local newText = text:gsub("[wWhH][wWtT][wWtT][\46pP]%S+[^%p%s]", GetChatLink);
  MayronUI.text = newText;
	self:oldAddMessage(newText, r, g, b, ...);
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

local function Tab_OnDragStart(self)
  self:DisableDrawLayer("BACKGROUND");
  self:DisableDrawLayer("BORDER");
  self:DisableDrawLayer("HIGHLIGHT");
end

local function Tab_OnEnter(self)
	-- set tab label white on mouse over
	self:GetFontString():SetTextColor(1, 1, 1, 1);
  Tab_OnDragStart(self);
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

hooksecurefunc("FCFTab_UpdateColors", Tab_OnLeave);

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

local function OnScrollChangedCallback(self, offset)
  if (obj:IsWidget(self.ScrollBar)) then
    if (self.ScrollBar.SetValue) then
      self.ScrollBar:SetValue(self:GetNumMessages() - offset);
    end

    if (offset > 0) then
      self.ScrollBar:SetAlpha(1);
    else
      self.ScrollBar:SetAlpha(0);
    end
  end

  local downBtn = self.ScrollToBottomButton;
  if (offset > 0) then
    downBtn:SetAlpha(1);
  else
    downBtn:SetAlpha(0);
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
  chatFrame:SetClampedToScreen(false);
  chatFrame:SetUserPlaced(true);

  if (obj:IsFunction(chatFrame.SetMaxResize)) then
    -- dragonflight has a resizing layout system and doesn't use this:
    chatFrame:SetMaxResize(1200, 800);
  end

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
		chatFrame:SetScript("OnHyperLinkLeave", tk.HandleTooltipOnLeave);
		chatFrame:SetScript("OnHyperlinkClick", OnHyperLinkClick);
	end

	local tab = _G[string.format("%sTab", chatFrameName)];
	tab.ChatFrame = chatFrame; -- needed for scripts
  tab:SetHeight(16);
  tab:SetFrameStrata(tk.Constants.FRAME_STRATAS.MEDIUM);
  tab:HookScript("OnClick", Tab_OnClick);
  tab:HookScript("OnDragStart", Tab_OnDragStart);
  tab:SetScript("OnEnter", Tab_OnEnter);
  tab:SetScript("OnLeave", Tab_OnLeave);

  Tab_OnLeave(tab); -- run script to set correct label color
  Tab_OnDragStart(tab);

  local tabLabel = tab:GetFontString();
  tabLabel:ClearAllPoints();
  tabLabel:SetPoint("CENTER", tab, "CENTER");

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

    _G[ string.format("%sButtonFrame", chatFrameName) ]
  );

  local scrollBar = chatFrame.ScrollBar;

  -- Only Retail seems to have a scroll bar on the chat frame
  if (obj:IsWidget(scrollBar)) then
    scrollBar:SetPoint("TOPLEFT", chatFrame, "TOPRIGHT", 1, 0);

    local thumb, track = scrollBar.ThumbTexture, scrollBar.Track;
    if (obj:IsFunction(scrollBar.GetThumb)) then
      thumb, track = scrollBar:GetThumb(), scrollBar:GetTrack();
    end

    if (obj:IsWidget(track)) then
      track:DisableDrawLayer("ARTWORK");
    end

    if (obj:IsWidget(thumb)) then
      thumb:SetSize(8, 34);
      local r, g, b = tk:GetThemeColor();

      if (thumb:GetObjectType() == "Button") then
        tk:KillAllElements(scrollBar.Forward, scrollBar.Back, thumb.Begin, thumb.Middle, thumb.End);
        local reskin = thumb:CreateTexture(nil, "BACKGROUND");
        reskin:SetColorTexture(r*0.8, g*0.8, b*0.8);
        reskin:SetAllPoints(true);
      elseif (thumb:GetObjectType() == "Texture") then
        thumb:SetColorTexture(r*0.8, g*0.8, b*0.8);
      end
    end
  end

  local downBtn = chatFrame.ScrollToBottomButton--[[@as Button]];

  if (obj:IsWidget(downBtn)) then
    gui:ReskinIconButton(downBtn, "arrow", -180);
    downBtn:DisableDrawLayer("OVERLAY");
    downBtn:SetPoint("BOTTOMRIGHT", chatFrame.ResizeButton, "TOPRIGHT", 0, -2);
    downBtn:SetSize(24, 21);
  end

  chatFrame:SetOnScrollChangedCallback(OnScrollChangedCallback);

  if (not tk:IsRetail()) then
    downBtn:ClearAllPoints();
    downBtn:SetPoint("BOTTOMLEFT", chatFrame, "BOTTOMRIGHT", 4, 0);
  end

  if (chatFrameName == "ChatFrame1") then
    hooksecurefunc("FCF_StopDragging", RepositionNotificationFrame);
    RepositionNotificationFrame(chatFrame);

    local dock = _G.GENERAL_CHAT_DOCK;
    dock:SetPoint("BOTTOMLEFT", chatFrame, "TOPLEFT", 16, 12);
    dock:SetPoint("BOTTOMRIGHT", chatFrame, "TOPRIGHT", 0, 12);
    dock.SetPoint = tk.Constants.DUMMY_FUNC;
    dock.ClearAllPoints = tk.Constants.DUMMY_FUNC;

    local toasts = _G.BNToastFrame;
    toasts:ClearAllPoints();
    toasts:SetPoint("BOTTOMLEFT", _G.ChatAlertFrame, "BOTTOMLEFT", 0, 0);
    toasts.ClearAllPoints = tk.Constants.DUMMY_FUNC;
    toasts.SetPoint = tk.Constants.DUMMY_FUNC;
  end

  data.ProcessedChatFrames[chatFrameName] = chatFrame;

	return chatFrame;
end

local function UpdateTabs()
  local dock = _G.GENERAL_CHAT_DOCK;
  local prev;

  -- position docked tabs:
  for _, chatFrame in ipairs(_G.GENERAL_CHAT_DOCK.DOCKED_CHAT_FRAMES) do
    local chatTab = _G[chatFrame:GetName().."Tab"];

    if (prev) then
      chatTab:SetPoint("LEFT", prev, "RIGHT", 1, 0);
    else
      chatTab:SetPoint("BOTTOMLEFT", dock, "BOTTOMLEFT", 0, 0);
    end

    prev = chatTab;
  end

  -- update all chat tabs regardless of whether they're in the dock:
  for _, chatFrameName in ipairs(_G.CHAT_FRAMES) do
    local chatTab = _G[chatFrameName.."Tab"];
    chatTab:SetAlpha(1);
    chatTab:SetWidth(chatTab:GetFontString():GetStringWidth() + 28);
    chatTab:SetFrameStrata(tk.Constants.FRAME_STRATAS.MEDIUM);
  end
end

function C_ChatModule:SetUpAllBlizzardFrames()
  local useMasterFont = db.global.core.fonts.useMasterFont;
  local masterFont = tk:GetMasterFont();

  for _, chatFrameName in ipairs(_G.CHAT_FRAMES) do
    local chatFrame = self:SetUpBlizzardChatFrame(chatFrameName);

    if (useMasterFont and chatFrame) then
      local _, fontSize = _G.FCF_GetChatWindowInfo(chatFrame:GetID());
      chatFrame:SetFont(masterFont, fontSize, "");
    end
  end

  hooksecurefunc("FCFDock_UpdateTabs", UpdateTabs);
  UpdateTabs();

  _G.FCF_FadeInChatFrame = tk.Constants.DUMMY_FUNC;
  _G.FCF_FadeInScrollbar = tk.Constants.DUMMY_FUNC;
  _G.FCF_FadeOutChatFrame = tk.Constants.DUMMY_FUNC;
  _G.FCF_FadeOutScrollbar = tk.Constants.DUMMY_FUNC;

  hooksecurefunc("FCFManager_RegisterDedicatedFrame", function(chatFrame)
    self:SetUpBlizzardChatFrame(chatFrame:GetName());
  end);

  hooksecurefunc("FCF_StartAlertFlash", function(chatFrame)
    local chatFrameName = chatFrame:GetName();
    local chatTab = _G[chatFrameName.."Tab"];

    if (not chatTab.notify) then
      chatTab.notify = chatTab:CreateTexture(nil, "OVERLAY");

      local notifyTexture = tk:GetAssetFilePath("Icons\\notify");
      chatTab.notify:SetTexture(notifyTexture);
      chatTab.notify:SetPoint("LEFT", 0, 0);
      chatTab.notify:SetSize(14, 14);
    end

    _G.UIFrameFlash(chatTab.notify, 1.0, 1.0, -1, false, 0, 0, "mui-chat-tab-notify");
  end);

  hooksecurefunc("FCF_StopAlertFlash", function(chatFrame)
    local chatFrameName = chatFrame:GetName();
    local chatTab = _G[chatFrameName.."Tab"];

    if (chatTab.notify) then
      _G.UIFrameFlashStop(chatTab.notify);
    end
  end);
end