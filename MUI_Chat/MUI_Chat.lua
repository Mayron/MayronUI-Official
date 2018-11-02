-- Setup namespaces ------------------
local addOnName, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

-- Register and Import ---------

local Engine = obj:Import("MayronUI.Engine");
local chatModule, ChatClass = MayronUI:RegisterModule("Chat");

namespace.ChatClass = ChatClass;

-- Load Database Defaults --------------

db:AddToDefaults("profile.chat", {
	enabled = true,
	enabledChatFrames = {
		["TOPLEFT"] = true,
		["BOTTOMLEFT"] = false,
		["BOTTOMRIGHT"] = false,
		["TOPRIGHT"] = false,
	},
	layout = "DPS", -- default layout
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
		ChatFrame1EditBox.focusLeft,
		ChatFrame1EditBox.focusRight,
		ChatFrame1EditBox.focusMid,
		ChatFrame1EditBoxLeft,
		ChatFrame1EditBoxMid,
		ChatFrame1EditBoxRight,
		ChatFrameMenuButton,
		QuickJoinToastButton	
	);
end

local function ReskinEditBox(editBoxSettings)
    ChatFrame1EditBox:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", -3, editBoxSettings.yOffset);
	ChatFrame1EditBox:SetPoint("TOPRIGHT", ChatFrame1, "BOTTOMRIGHT", 3, editBoxSettings.yOffset);
	
	-- Set Edit Box Backdrop
    local inset = editBoxSettings.inset;
    local backdrop = {
        bgFile = "Interface\\Buttons\\WHITE8X8",
        insets = {left = inset, right = inset, top = inset, bottom = inset};
	};
	
    backdrop.edgeFile = tk.Constants.LSM:Fetch("border", editBoxSettings.border);
    backdrop.edgeSize = editBoxSettings.borderSize;
	ChatFrame1EditBox:SetBackdrop(backdrop);
	
    local c = editBoxSettings.backdropColor;
	ChatFrame1EditBox:SetBackdropColor(c.r, c.g, c.b, c.a);
	ChatFrame1EditBox:SetHeight(editBoxSettings.height);
end

-- Chat Module -------------------

chatModule:OnInitialize(function(self, data)
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

	for chatFrameID = 1, NUM_CHAT_WINDOWS do
		local chatFrame = self:SetUpBlizzardChatFrame(chatFrameID);	

        if (changeGameFont) then
            local _, fontSize, outline = FCF_GetChatWindowInfo(chatFrame:GetID());            
            chatFrame:SetFont(muiFont, fontSize, outline);
        end
	end
	
	for anchorName, enabled in data.sv.enabledChatFrames:Iterate() do
		if (enabled) then
			local muiChatFrame = self:ShowMuiChatFrame(anchorName);

			for buttonID, button in pairs(muiChatFrame.buttons) do
				self:SetUpButtonHandler(anchorName, buttonID, button);
			end

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

	-- 2018-07-19 CB: BNToastFrame_Show is not a function anymore
    -- tk.hooksecurefunc(BNToastFrame, "Show", function()
	-- 	BNToastFrame:ClearAllPoints();
	-- 	if ((tk.select(1, ChatFrame1:GetPoint())):find("BOTTOM")) then
    --         BNToastFrame:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", -4, 34);
	-- 	else
    --         BNToastFrame:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", -4, -10);
    --     end
	-- end);
end);

--TODO
chatModule:OnConfigUpdate(function(self, data, list, value)
	local key = list:PopFront();
	
    if (key == "profile" and list:PopFront() == "chat") then
		key = list:PopFront();
		
        if (key == "data") then
			local chatID = list:PopFront();
			
            if (chatID) then
				local cf = chat.chatFrames[self:GetChatNameById(chatID)];
				
				if (not cf) then 
					return; 
				end

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
        elseif (key == "editBox") then
            key = list:PopFront();
            if (key == "yOffset") then
                ChatFrame1EditBox:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", -3, value);
				ChatFrame1EditBox:SetPoint("TOPRIGHT", ChatFrame1, "BOTTOMRIGHT", 3, value);
				
            elseif (key == "height") then
				ChatFrame1EditBox:SetHeight(value);
				
            elseif (key == "border" or key == "inset" or key == "borderSize") then
                local r, g, b, a = ChatFrame1EditBox:GetBackdropColor();
				local inset = (key == "inset" and value) or self.sv.editBox.inset;
				
                local backdrop = {
                    bgFile = "Interface\\Buttons\\WHITE8X8",
                    insets = {left = inset, right = inset, top = inset, bottom = inset};
				};
				
                backdrop.edgeFile = tk.Constants.LSM:Fetch("border", (key == "border" and value) or self.sv.editBox.border);
				backdrop.edgeSize = (key == "borderSize" and value) or self.sv.editBox.borderSize;
				
                ChatFrame1EditBox:SetBackdrop(backdrop);
                ChatFrame1EditBox:SetBackdropColor(r, g, b, a);
            elseif (key == "backdropColor") then
                ChatFrame1EditBox:SetBackdropColor(value.r, value.g, value.b, value.a);
            end
        end
    end
end);

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
	local r, g, b = GetMessageTypeColor(chatType);
	ChatFrame1EditBox:SetBackdropBorderColor(r, g, b, 1);
end);

-- probably not needed
tk.hooksecurefunc("FCF_OpenTemporaryWindow", function()
	local chat = FCF_GetCurrentChatFrame();
	if (chat) then
		chat:SetClampRectInsets(0, 0, 0, 0);
	end
end);

-- must be before chat is initialized!
for i = 1, NUM_CHAT_WINDOWS do
    tk._G["ChatFrame"..i]:SetClampRectInsets(0, 0, 0, 0);
end
