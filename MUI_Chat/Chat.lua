------------------------
-- Setup namespaces
------------------------
local _, chat = ...;
local core = MayronUI:ImportModule("MUI_Core");
local tk = core.Toolkit;
local em = core.EventManager;
local db = core.Database;
local L = LibStub ("AceLocale-3.0"):GetLocale ("MayronUI");

MayronUI:RegisterModule("Chat", chat);

function chat:OnConfigUpdate(list, value)
    local key = list:PopFront();
    if (key == "profile" and list:PopFront() == "chat") then
        key = list:PopFront();
        if (key == "data") then
            local chatID = list:PopFront();
            if (chatID) then
                local cf = chat.chat_frames[self:GetChatNameById(chatID)];
                if (not cf) then return; end
                if (list:PopFront() == "buttons") then
                    local buttonSetId, buttonID = list:PopFront(), list:PopFront();
                    if (buttonSetId and buttonSetId == 1 and buttonID) then
                        if (buttonID == 1) then
                            cf.left:SetText(value);
                        elseif (buttonID == 2) then
                            cf.middle:SetText(value);
                        elseif (buttonID == 3) then
                            cf.right:SetText(value);
                        end
                    end
                end
            end
        elseif (key == "edit_box") then
            key = list:PopFront();
            if (key == "yOffset") then
                ChatFrame1EditBox:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", -3, value);
                ChatFrame1EditBox:SetPoint("TOPRIGHT", ChatFrame1, "BOTTOMRIGHT", 3, value);
            elseif (key == "height") then
                ChatFrame1EditBox:SetHeight(value);
            elseif (key == "border" or key == "inset" or key == "border_size") then
                local r, g, b, a = ChatFrame1EditBox:GetBackdropColor();
                local inset = (key == "inset" and value) or self.sv.edit_box.inset;
                local backdrop = {
                    bgFile = "Interface\\Buttons\\WHITE8X8",
                    insets = {left = inset, right = inset, top = inset, bottom = inset};
                };
                backdrop.edgeFile = tk.Constants.LSM:Fetch("border", (key == "border" and value) or self.sv.edit_box.border);
                backdrop.edgeSize = (key == "border_size" and value) or self.sv.edit_box.border_size;
                ChatFrame1EditBox:SetBackdrop(backdrop);
                ChatFrame1EditBox:SetBackdropColor(r, g, b, a);
            elseif (key == "backdrop_color") then
                ChatFrame1EditBox:SetBackdropColor(value.r, value.g, value.b, value.a);
            end
        end
    end
end

----------------
-- Defaults 
----------------
db:AddToDefaults("profile.chat", {
	enabled = {
		["TOPLEFT"] = true,
		["BOTTOMLEFT"] = false,
		["BOTTOMRIGHT"] = false,
		["TOPRIGHT"] = false,
	},
    edit_box = {
        yOffset = -8,
        height = 27,
        border = "Skinner",
        inset = 0,
        border_size = 1,
        backdrop_color = {r = 0, g = 0, b = 0, a = 0.6},
    },
	data = {
		{	name = "TOPLEFT",
            buttons = {
                {   L["Character"],
                    L["Spell Book"],
                    L["Talents"],
                },
                {   key = "C", -- CONTROL
                    L["Friends"],
                    L["Guild"],
                    L["Map / Quest Log"],
                },
                {   key = "S", -- SHIFT
                    L["Achievements"],
                    L["Collections Journal"],
                    L["Encounter Journal"]
                }
            },
		},
		{	name = "BOTTOMLEFT",
            buttons = {
                {   L["Character"],
                    L["Spell Book"],
                    L["Talents"],
                },
                {   key = "C", -- CONTROL
                    L["Friends"],
                    L["Guild"],
                    L["Map / Quest Log"],
                },
                {   key = "S", -- SHIFT
                    L["Achievements"],
                    L["Collections Journal"],
                    L["Encounter Journal"]
                }
            },
		},
		{	name = "BOTTOMRIGHT",
            buttons = {
                {   L["Character"],
                    L["Spell Book"],
                    L["Talents"],
                },
                {   key = "C", -- CONTROL
                    L["Friends"],
                    L["Guild"],
                    L["Map / Quest Log"],
                },
                {   key = "S", -- SHIFT
                    L["Achievements"],
                    L["Collections Journal"],
                    L["Encounter Journal"]
                }
            },
		},
		{	name = "TOPRIGHT",
			buttons = {
                {   L["Character"],
				    L["Spell Book"],
				    L["Talents"],
                },
                {   key = "C", -- CONTROL
                    L["Friends"],
                    L["Guild"],
                    L["Map / Quest Log"],
                },
                {   key = "S", -- SHIFT
                    L["Achievements"],
                    L["Collections Journal"],
                    L["Encounter Journal"]
                }
			},
		},
	},
	layout = "DPS", -- default layout
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

--------------------------
-- Blizzard Globals
--------------------------
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 1;
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 1;
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1;
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1;
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1;
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1;
CHAT_TAB_SHOW_DELAY = 1;
CHAT_TAB_HIDE_DELAY = 1;
CHAT_FRAME_FADE_TIME = 1;
CHAT_FRAME_FADE_OUT_TIME = 1;
DEFAULT_CHATFRAME_ALPHA = 0;
CHAT_FONT_HEIGHTS = {8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18};

----------------------------------
-- Override Blizzard Functions:
----------------------------------
local function RepositionChatTab()
	ChatFrame1Tab:SetPoint("LEFT", 16, 0);
end

function FCFTab_UpdateColors() end

function FCF_SetTabPosition(chatFrame)
	local cf = chatFrame:GetName();
	if (not chatFrame.isDocked) then
        tk._G[cf.."Tab"]:ClearAllPoints()
		if (IsCombatLog(chatFrame)) then
            tk._G[cf.."Tab"]:SetPoint("BOTTOMLEFT", "CombatLogQuickButtonFrame_Custom", "TOPLEFT", 15, 10)
		else
            tk._G[cf.."Tab"]:SetPoint("BOTTOMLEFT", chatFrame, "TOPLEFT", 15, 10)
		end
	end
	RepositionChatTab();
    tk._G[cf.."ButtonFrameMinimizeButton"]:Hide();
end

tk.hooksecurefunc("FCFTab_OnUpdate", RepositionChatTab);
tk.hooksecurefunc("FCF_DockUpdate", RepositionChatTab);
tk.hooksecurefunc("FCFDockScrollFrame_JumpToTab", RepositionChatTab);

tk.hooksecurefunc("ChatEdit_UpdateHeader", function()
	local chatType = ChatFrame1EditBox:GetAttribute("chatType");
	local r, g, b = GetMessageTypeColor(chatType);
	ChatFrame1EditBox:SetBackdropBorderColor(r, g, b, 1);
end);

-- probably not needed
tk.hooksecurefunc("FCF_OpenTemporaryWindow", function()
	local chat = FCF_GetCurrentChatFrame();
	if (chat) then
		chat:SetClampRectInsets(0, 0, 0, 0);
	end
end)

---------------------
-- Chat Functions
---------------------
function chat:GetChatButtonInfo(anchor, id)
    anchor = anchor:gsub("%s+", ""):upper();
    for id, value in db.profile.chat.data:Iterate() do
        if (value.name == anchor) then
            return value.buttons[id];
        end
    end
    return false;
end

function chat:GetChatNameById(id)
    return self.sv.data[id].name;
end

function chat:GetChatLink(text, id, url)
	return tk.string.format("|H%s:%s|h|cffffe29e%s|r|h", id, url, text);
end

do
	local function func(url)
		return chat:GetChatLink("["..url.."]", "url", url);
	end

	local function NewAddMessage(self, text, ...)
        if (not text) then return; end
		self:oldAddMessage(text:gsub("[wWhH][wWtT][wWtT][\46pP]%S+[^%p%s]", func), ...);
	end

	local function OnHyperLinkLeave()
		GameTooltip:Hide();
	end

	local function OnHyperlinkEnter(self, linkData)
		local linkType = tk.string.split(":", linkData)
		if (linkType == "item" or linkType == "spell" or linkType == "enchant" or
				linkType == "quest" or linkType == "talent" or linkType == "glyph" or
				linkType == "unit" or linkType == "achievement") then -- missing type for new community link ?
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
			GameTooltip:SetHyperlink(linkData);
			GameTooltip:Show();
		end
	end

	local function OnHyperlinkClick(self, linkData, link, button)
		local linkType, value = linkData:match("(%a+):(.+)");
		if (linkType == "url") then
			local popup = tk.StaticPopup_Show("MUI_Link");
			local editbox = tk._G[popup:GetName().."EditBox"]
			editbox:SetText(value);
			editbox:SetFocus();
			editbox:HighlightText();
		else
			SetItemRef(linkData, link, button, self);
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
		for i = 1, NUM_CHAT_WINDOWS do
            local tab = tk._G["ChatFrame"..i.."Tab"];
			if (self == tab) then
                tab:GetFontString():SetTextColor(1,1,1,1);
            else
                tk:SetThemeColor(tab:GetFontString());
            end
		end
	end

	local function Tab_OnEnter(self)
		self:GetFontString():SetTextColor(1, 1, 1, 1);
	end

	local function Tab_OnLeave(self)
        if (self.ChatFrame == SELECTED_CHAT_FRAME) then
            self:GetFontString():SetTextColor(1, 1, 1, 1);
        else
            tk:SetThemeColor(self:GetFontString());
        end
	end

	function chat:EditTab(i)
		local chatFrameStr = "ChatFrame"..i;
		local chatFrame = tk._G[chatFrameStr];
		if (not chatFrame) then return; end

		local btn = tk._G[chatFrameStr.."ButtonFrame"];
		local flash = tk._G[chatFrameStr.."ButtonFrameBottomButtonFlash"];
		local tab = tk._G[chatFrameStr.."Tab"];

		if ( i ~= 2 ) then -- if not combat log
			chatFrame.oldAddMessage = tk._G[chatFrameStr].AddMessage;
			chatFrame.AddMessage = NewAddMessage;
			chatFrame:SetScript("OnHyperLinkEnter", OnHyperlinkEnter);
			chatFrame:SetScript("OnHyperLinkLeave", OnHyperLinkLeave);
			chatFrame:SetScript("OnHyperlinkClick", OnHyperlinkClick);
		end

		btn:ClearAllPoints();
		btn:SetPoint("BOTTOM", tab, "BOTTOM", 0, -2);
		btn:SetSize(tab:GetWidth() - 10, 20)
		--btn:SetNormalTexture("");
		--btn:SetHighlightTexture("");
		--btn:SetPushedTexture("");
        btn:EnableMouse(false);
        btn.EnableMouse = tk.Constants.DUMMY_FUNC;
		--flash:SetAlpha(0.5);
		--flash:SetTexture("Interface/BUTTONS/GRADBLUE.png");
		tab.ChatFrame = tk._G[chatFrameStr];
		tab:GetFontString():ClearAllPoints();
		tab:GetFontString():SetPoint("CENTER", tab, "CENTER");
		tab:SetHeight(16);

		-- Kill old tab texture
		tk:KillElement(tk._G[chatFrameStr.."TabSelectedLeft"]);
		tk:KillElement(tk._G[chatFrameStr.."TabSelectedMiddle"]);
		tk:KillElement(tk._G[chatFrameStr.."TabSelectedRight"]);
		-- tk:KillElement(tk._G[chatFrameStr.."ButtonFrameUpButton"]);
		-- tk:KillElement(tk._G[chatFrameStr.."ButtonFrameDownButton"]);
		tk:KillElement(tk._G[chatFrameStr.."TabLeft"]);
		tk:KillElement(tk._G[chatFrameStr.."TabMiddle"]);
		tk:KillElement(tk._G[chatFrameStr.."TabRight"]);
		tk:KillElement(tk._G[chatFrameStr.."TabHighlightLeft"]);
		tk:KillElement(tk._G[chatFrameStr.."TabHighlightMiddle"]);
		tk:KillElement(tk._G[chatFrameStr.."TabHighlightRight"]);
        tk._G[chatFrameStr.."ButtonFrame"]:DisableDrawLayer("BACKGROUND");
        tk._G[chatFrameStr.."ButtonFrame"]:DisableDrawLayer("BORDER");

		tab:HookScript("OnClick", Tab_OnClick);
        tab:SetScript("OnEnter", Tab_OnEnter);
        tab:SetScript("OnLeave", Tab_OnLeave);
		chatFrame:HookScript("OnMouseWheel", ChatFrame_OnMouseWheel);
	end
end

function chat:LoadCompactChanges()
	-- Hide Blizzard Compact Manager:
	CompactRaidFrameManager:DisableDrawLayer("ARTWORK");
	CompactRaidFrameManager:EnableMouse(false);
	tk:KillElement(CompactRaidFrameManager.toggleButton);
	
	local btn = tk.CreateFrame("Button", nil, tk.UIParent);
    btn:SetSize(14, 120);
    btn:SetNormalTexture(tk.Constants.MEDIA.."other\\SideButton");
    btn:SetNormalFontObject("MUI_FontSmall");
    btn:SetHighlightFontObject("GameFontHighlightSmall");
    btn:SetText(">");

	if (db.profile.chat.enabled["TOPLEFT"]) then
        btn:SetPoint("TOPLEFT", self.chat_frames["TOPLEFT"], "BOTTOMLEFT", -2, -40);
	else
        btn:SetPoint("LEFT", tk.UIParent, "LEFT", -2, 64);
	end
    btn:GetNormalTexture():SetTexCoord(1, 0, 0, 1);
    btn:SetWidth(16);

	local crfm = CompactRaidFrameManager.displayFrame;

	-- Create new frame:
    btn.managerFrame = tk.CreateFrame("Frame", nil, crfm);
    tk:SetBackground(btn.managerFrame, 0, 0, 0);
    btn.managerFrame:SetPoint("TOPLEFT", crfm, "TOPLEFT", 0, 0);
    btn.managerFrame:SetPoint("BOTTOMRIGHT", crfm, "BOTTOMRIGHT", 0, 0);
    btn.managerFrame:SetFrameLevel( ( (crfm:GetFrameLevel() - 1) < 0 and 0) or (crfm:GetFrameLevel() - 1) );

    crfm:SetParent(btn);
    crfm:ClearAllPoints();
    crfm:SetPoint("TOPLEFT", btn, "TOPRIGHT", 5, 0);
    tk:MakeMovable(crfm);

    btn:SetScript("OnClick", function(self)
		if (crfm:IsVisible()) then
            crfm:Hide();
			self:SetText(">");
		else
            crfm:Show();
			self:SetText("<");
		end
        crfm:SetWidth(CompactRaidFrameManager:GetWidth());
        crfm:SetHeight(CompactRaidFrameManager:GetHeight());
	end)

    btn:RegisterEvent("ADDON_LOADED");
    btn:RegisterEvent("GROUP_ROSTER_UPDATE");
    btn:RegisterEvent("PLAYER_ENTERING_WORLD");
    btn:SetScript("OnEvent", function(self, event)
		if (not tk.IsAddOnLoaded("Blizzard_CompactRaidFrames")) then return; end
		if (GetNumGroupMembers() > 0 and IsInGroup()) then
			self:Show();
		else
			self:Hide();
		end
	end);
    btn:Hide();
end

local function CreateChatFrame(anchor)
	local cf = tk:PopFrame("Frame");
	anchor = anchor:gsub("%s+", ""):upper();
    cf:SetFrameStrata("LOW");
    cf:SetFrameLevel(1);
	cf:SetSize(358, 310);
	cf:SetPoint(anchor, 2, -2);
	cf.sidebar = cf:CreateTexture(nil, "ARTWORK");
	cf.sidebar:SetTexture(chat.MEDIA.."sidebar");
	cf.sidebar:SetSize(24, 300);
	cf.sidebar:SetPoint(anchor, 0, -10);

	cf.tabs = cf:CreateTexture(nil, "ARTWORK");
	cf.tabs:SetTexture(chat.MEDIA.."tabs");
	cf.tabs:SetSize(358, 23);
	cf.tabs:SetPoint(anchor, cf.sidebar, "TOPRIGHT", 0, -12);

	cf.window = tk:PopFrame("Frame", cf);
	cf.window:SetSize(367, 248);
	cf.window:SetPoint("TOPLEFT", cf.tabs, "BOTTOMLEFT", 2, -2);
	cf.window.texture = cf.window:CreateTexture(nil, "ARTWORK");
	cf.window.texture:SetTexture(chat.MEDIA.."window");
	cf.window.texture:SetAllPoints(true);

	cf.layoutButton = tk:PopFrame("Button", cf);
	cf.layoutButton:SetNormalFontObject("MUI_FontSmall");
	cf.layoutButton:SetHighlightFontObject("GameFontHighlightSmall");
	cf.layoutButton:SetText(" ");
	cf.layoutButton:GetFontString():SetPoint("CENTER", 1, 0);
	cf.layoutButton:SetSize(21, 120);
	cf.layoutButton:SetPoint("LEFT", cf.sidebar, "LEFT");
	cf.layoutButton:SetNormalTexture(chat.MEDIA.."layoutButton");
	cf.layoutButton:SetHighlightTexture(chat.MEDIA.."layoutButton");
	tk:SetThemeColor(cf.layoutButton:GetNormalTexture(), cf.layoutButton:GetHighlightTexture());

	cf.left = tk:PopFrame("Button", cf);
	cf.left:SetSize(135, 20);
	cf.left:SetNormalFontObject("MUI_FontSmall");
	cf.left:SetHighlightFontObject("GameFontHighlightSmall");
	cf.left:SetText(" ");
	cf.left:SetPoint("TOPLEFT", cf.sidebar, "TOPRIGHT", 0, 10);
	cf.left:SetNormalTexture(chat.MEDIA.."sideButton");
	cf.left:SetHighlightTexture(chat.MEDIA.."sideButton");

	cf.middle = tk:PopFrame("Button", cf);
	cf.middle:SetSize(135, 20);
	cf.middle:SetNormalFontObject("MUI_FontSmall");
	cf.middle:SetHighlightFontObject("GameFontHighlightSmall");
	cf.middle:SetText(" ");
	cf.middle:SetPoint("LEFT", cf.left, "RIGHT");
	cf.middle:SetNormalTexture(chat.MEDIA.."middleButton");
	cf.middle:SetHighlightTexture(chat.MEDIA.."middleButton");

	cf.right = tk:PopFrame("Button", cf);
	cf.right:SetSize(135, 20);
	cf.right:SetNormalFontObject("MUI_FontSmall");
	cf.right:SetHighlightFontObject("GameFontHighlightSmall");
	cf.right:SetText(" ");
	cf.right:SetPoint("LEFT", cf.middle, "RIGHT");
	cf.right:SetNormalTexture(chat.MEDIA.."sideButton");
	cf.right:GetNormalTexture():SetTexCoord(1, 0, 0, 1);
	cf.right:SetHighlightTexture(chat.MEDIA.."sideButton");
	cf.right:GetHighlightTexture():SetTexCoord(1, 0, 0, 1);
	return cf;
end

-- function to enable/disable chat frames per corner OnLoad and used by the GUI:
function chat:Show()
	self.chat_frames = self.chat_frames or {};

	for _, chat_data in self.sv.data:Iterate() do
		if (self.sv.enabled[chat_data.name]) then
			if (self.chat_frames[chat_data.name]) then
				self.chat_frames[chat_data.name]:Show();

			else
				self.chat_frames[chat_data.name] = CreateChatFrame(chat_data.name);
				local cf = self.chat_frames[chat_data.name];

				-- Reflection Changes per corner:
				if (chat_data.name ~= "TOPLEFT") then
					cf:ClearAllPoints();
					cf.window:ClearAllPoints();
					cf.sidebar:ClearAllPoints();
					cf.left:ClearAllPoints();

				else
					--chat channel button--------
					ChatFrameChannelButton:ClearAllPoints();
					ChatFrameChannelButton:SetPoint("TOPLEFT", cf.sidebar, "TOPLEFT", -1, -10);
					ChatFrameChannelButton:DisableDrawLayer("ARTWORK");

					ChatFrameChannelButton.ClearAllPoints = tk.Constants.DUMMY_FUNC;
					ChatFrameChannelButton.SetPoint = tk.Constants.DUMMY_FUNC;
				end

				if (chat_data.name == "TOPRIGHT") then
					cf.tabs:SetTexCoord(1, 0, 0, 1);
					cf.tabs:ClearAllPoints();
					cf.tabs:SetPoint(chat_data.name, cf.sidebar, "TOPLEFT", 0, -12);
					cf:SetPoint(chat_data.name, tk.UIParent, chat_data.name, -2, -2);
					cf.sidebar:SetPoint(chat_data.name, cf, chat_data.name, 0 , -10);
					cf.window:SetPoint(chat_data.name, cf.tabs, "BOTTOMRIGHT", -2, -2);
					cf.window.texture:SetTexCoord(1, 0, 0, 1);
					cf.left:SetPoint("BOTTOMLEFT", cf.tabs, "TOPLEFT", -46, 2);
					cf.sidebar:SetTexCoord(1, 0, 0, 1);
					cf.layoutButton:GetNormalTexture():SetTexCoord(1, 0, 0, 1);
					cf.layoutButton:GetHighlightTexture():SetTexCoord(1, 0, 0, 1);
					cf.layoutButton:SetPoint("LEFT", cf.sidebar, "LEFT", 2, 0);

				elseif (chat_data.name == "BOTTOMLEFT") then
					cf:SetPoint(chat_data.name, tk.UIParent, chat_data.name, 2, 2);
					cf.sidebar:SetPoint(chat_data.name, cf, chat_data.name, 0 , 10);
					cf.window:SetPoint("BOTTOMLEFT", cf.sidebar, "BOTTOMRIGHT", 2, 12);
					cf.window.texture:SetTexCoord(0, 1, 1, 0);
					cf.left:SetPoint("BOTTOMLEFT", cf.sidebar, "BOTTOMRIGHT", 0, -10);
					cf.left:GetNormalTexture():SetTexCoord(0, 1, 1, 0);
					cf.middle:GetNormalTexture():SetTexCoord(0, 1, 1, 0);
					cf.right:GetNormalTexture():SetTexCoord(1, 0, 1, 0);
					cf.left:GetHighlightTexture():SetTexCoord(0, 1, 1, 0);
					cf.middle:GetHighlightTexture():SetTexCoord(0, 1, 1, 0);
					cf.right:GetHighlightTexture():SetTexCoord(1, 0, 1, 0);
					cf.tabs:Hide();

				elseif (chat_data.name == "BOTTOMRIGHT") then
					--cf.tabs:SetTexCoord(1, 0, 0, 1)
					--cf.tabs:ClearAllPoints()
					--cf.tabs:SetPoint("TOPRIGHT", cf.sidebar, "TOPLEFT", 0, -12)
					cf.tabs:Hide();
					cf:SetPoint(chat_data.name, tk.UIParent, chat_data.name, -2, 2)
					cf.sidebar:SetPoint(chat_data.name, cf, chat_data.name, 0 , 10)
					cf.window:SetPoint(chat_data.name, cf.sidebar, "BOTTOMLEFT", -2, 12)
					cf.window.texture:SetTexCoord(1, 0, 1, 0)
					cf.left:SetPoint("BOTTOMLEFT", cf.window, "BOTTOMLEFT", -36, -22)
					cf.left:GetNormalTexture():SetTexCoord(0, 1, 1, 0)
					cf.middle:GetNormalTexture():SetTexCoord(0, 1, 1, 0)
					cf.right:GetNormalTexture():SetTexCoord(1, 0, 1, 0)
					cf.left:GetHighlightTexture():SetTexCoord(0, 1, 1, 0);
					cf.middle:GetHighlightTexture():SetTexCoord(0, 1, 1, 0);
					cf.right:GetHighlightTexture():SetTexCoord(1, 0, 1, 0);
					cf.sidebar:SetTexCoord(1, 0, 0, 1)
					cf.layoutButton:GetNormalTexture():SetTexCoord(1, 0, 0, 1);
					cf.layoutButton:GetHighlightTexture():SetTexCoord(1, 0, 0, 1);
					cf.layoutButton:SetPoint("LEFT", cf.sidebar, "LEFT", 2, 0)
				end
			end
		end
    end
end

---------------------
-- Initialize Chat
---------------------
function chat:init()
	if (not MayronUI:IsInstalled()) then return; end
	self.sv = db.profile.chat;
	self.MEDIA = "Interface\\AddOns\\MUI_Chat\\media\\";

    tk.StaticPopupDialogs["MUI_Link"] = {
		text = tk:GetThemeColoredString("MayronUI").."\n(CTRL+C to Copy, CTRL+V to Paste)",
		button1 = "Close",
		hasEditBox = 1,
		maxLetters = 1024,
		editBoxWidth = 350,
		hideOnEscape = 1,
		timeout = 0,
		whileDead = 1,
		preferredIndex = 3,
	};

	-- not strictly to do with chat box (should be in reskin module)
	for i = 1, 20 do
		if (tk._G["StaticPopup"..i.."EditBox"]) then
			tk:KillElement(tk._G["StaticPopup"..i.."EditBoxLeft"]);
			tk:KillElement(tk._G["StaticPopup"..i.."EditBoxMid"]);
			tk:KillElement(tk._G["StaticPopup"..i.."EditBoxRight"]);
		else break; end
	end

	tk:KillElement(ChatFrame1EditBox.focusLeft);
	tk:KillElement(ChatFrame1EditBox.focusRight);
	tk:KillElement(ChatFrame1EditBox.focusMid);
	tk:KillElement(ChatFrame1EditBoxLeft);
	tk:KillElement(ChatFrame1EditBoxMid);
	tk:KillElement(ChatFrame1EditBoxRight);
	tk:KillElement(ChatFrameMenuButton);
	tk:KillElement(QuickJoinToastButton);

    --edit box-----------------
    ChatFrame1EditBox:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", -3, self.sv.edit_box.yOffset);
    ChatFrame1EditBox:SetPoint("TOPRIGHT", ChatFrame1, "BOTTOMRIGHT", 3, self.sv.edit_box.yOffset);
    local inset = self.sv.edit_box.inset;
    local backdrop = {
        bgFile = "Interface\\Buttons\\WHITE8X8",
        insets = {left = inset, right = inset, top = inset, bottom = inset};
    };
    backdrop.edgeFile = tk.Constants.LSM:Fetch("border", self.sv.edit_box.border);
    backdrop.edgeSize = self.sv.edit_box.border_size;
	ChatFrame1EditBox:SetBackdrop(backdrop);
	
    local c = self.sv.edit_box.backdrop_color;
	ChatFrame1EditBox:SetBackdropColor(c.r, c.g, c.b, c.a);
	ChatFrame1EditBox:SetHeight(self.sv.edit_box.height);

	for i = 1, NUM_CHAT_WINDOWS do
		local tab = tk._G["ChatFrame"..i.."Tab"];
		local cf = tk._G["ChatFrame"..i];
		cf:SetFrameStrata("LOW");
		tab:SetFrameStrata("MEDIUM");
		if (tab and (cf == SELECTED_CHAT_FRAME)) then
			tab:GetFontString():SetTextColor(1, 1, 1, 1);
		elseif (tab) then
			tk:SetThemeColor(tab:GetFontString());
        end
        self:EditTab(i);

        tk._G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false);

        if (db.global.core.change_game_font) then
            local _, fontSize, outline = FCF_GetChatWindowInfo(cf:GetID());
            local font = tk.Constants.LSM:Fetch("font", db.global.core.font);
            cf:SetFont(font, fontSize, outline);
        end
    end
	
	self:Show(); -- initialize self.chat_frames
	self:InitializeChatButtons();
	self:InitializeLayoutButtons();

    if (tk.IsAddOnLoaded("Blizzard_CompactRaidFrames")) then
        chat:LoadCompactChanges();
    else
        em:CreateEventHandler("ADDON_LOADED", function(_, name)
            if (name == "Blizzard_CompactRaidFrames") then
                chat:LoadCompactChanges();
            end
        end):SetAutoDestroy(true);
    end

	-- 2018-07-19 CB: BNToastFrame_Show is not a function anymore
    tk.hooksecurefunc(BNToastFrame, "Show", function()
		BNToastFrame:ClearAllPoints();
		if ((tk.select(1, ChatFrame1:GetPoint())):find("BOTTOM")) then
            BNToastFrame:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", -4, 34);
		else
            BNToastFrame:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", -4, -10);
        end
	end);
end

-- must be before chat is initialized!
for i = 1, NUM_CHAT_WINDOWS do
    tk._G["ChatFrame"..i]:SetClampRectInsets(0, 0, 0, 0);
end