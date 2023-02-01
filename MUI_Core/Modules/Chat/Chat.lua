-- luacheck: ignore self 143
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local ChatFrame1EditBox, NUM_CHAT_WINDOWS = _G.ChatFrame1EditBox, _G.NUM_CHAT_WINDOWS;
local InCombatLockdown, StaticPopupDialogs, hooksecurefunc, pairs, PlaySound =
 _G.InCombatLockdown, _G.StaticPopupDialogs, _G.hooksecurefunc, _G.pairs, _G.PlaySound;
local strformat, ipairs = _G.string.format, _G.ipairs;
--------------------------
-- Blizzard Globals
--------------------------
_G.CHAT_FONT_HEIGHTS = obj:PopTable(8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18);

-- Objects ------------------
---@class ChatFrame
local C_ChatFrame = obj:CreateClass("ChatFrame");
obj:Export(C_ChatFrame, "MayronUI.ChatModule");

---@class ChatModule : BaseModule
local C_ChatModule = MayronUI:RegisterModule("ChatModule", L["Chat Frames"]);

-- Database Defaults -----------------
local defaults = {
	enabled = true;
	swapInCombat = false;
	chatFrames = {
		-- these tables will contain the templateMuiChatFrame data (using SetParent)
		TOPLEFT = {
      enabled = true;
      xOffset = 2;
      yOffset = -2;
    };

		TOPRIGHT = {
      enabled = false;
      xOffset = -2;
      yOffset = -2;
    };

		BOTTOMLEFT = {
      enabled = false;
      xOffset = 2;
      yOffset = 2;
			tabBar = {
				yOffset = -43;
			};
			window = {
				yOffset = 12;
			}
    };

		BOTTOMRIGHT = {
      enabled = false;
      xOffset = -2;
      yOffset = 2;
			tabBar = {
				yOffset = -43;
			};
			window = {
				yOffset = 12;
			}
		};
  };

  iconsAnchor = "TOPLEFT"; -- which chat frame to align them to
	icons = {
    { type = "voiceChat" };
    -- optional:
    -- { type = "deafen" };
    -- { type = "mute" };
    { type = "professions" };
    { type = "shortcuts" };
    { type = "copyChat" };
    { type = "emotes" };
    { type = "playerStatus" };
  };

  brightness = 0.7;
  enableAliases = true;
  aliases = {
    [_G.CHAT_MSG_GUILD] = _G.CHAT_MSG_GUILD:gsub("[a-z%s]", tk.Strings.Empty);
    [_G.CHAT_MSG_OFFICER] = _G.CHAT_MSG_OFFICER:gsub("[a-z%s]", tk.Strings.Empty);

    [_G.CHAT_MSG_PARTY] = _G.CHAT_MSG_PARTY:gsub("[a-z%s]", tk.Strings.Empty);
    [_G.CHAT_MSG_PARTY_LEADER] = _G.CHAT_MSG_PARTY_LEADER:gsub("[a-z%s]", tk.Strings.Empty);

    [_G.CHAT_MSG_RAID] = _G.CHAT_MSG_RAID:gsub("[a-z%s]", tk.Strings.Empty);
    [_G.CHAT_MSG_RAID_LEADER] = _G.CHAT_MSG_RAID_LEADER:gsub("[a-z%s]", tk.Strings.Empty);
    [_G.CHAT_MSG_RAID_WARNING] = _G.CHAT_MSG_RAID_WARNING:gsub("[a-z%s]", tk.Strings.Empty);

    [_G.INSTANCE_CHAT] = _G.INSTANCE_CHAT:gsub("[a-z%s]", tk.Strings.Empty);
    [_G.INSTANCE_CHAT_LEADER] = _G.INSTANCE_CHAT_LEADER:gsub("[a-z%s]", tk.Strings.Empty);
  };

  useTimestampColor = true;
  timestampColor = {
    r = 0.6; g = 0.6; b = 0.6;
  };

  editBox = {
    yOffset = -8;
    height = 27;
    border = "Skinner";
    position = "BOTTOM";
    inset = 0;
    borderSize = tk.Constants.BACKDROP.edgeSize;
    backdropColor = {
      r = 0;
      g = 0;
      b = 0;
      a = 0.6;
    };
  };

	__templateChatFrame = {
    buttons = {
      {
        L["Character"];
        L["Spell Book"];
        L["Talents"];
      };
      {
        key = "C"; -- CONTROL
        L["Reputation"];
        L[(tk:IsRetail() and "LFD") or (tk:IsWrathClassic() and "LFG") or "Skills"];
        L["Quest Log"];
      };
      {
        key = "S"; -- SHIFT
        L[((tk:IsRetail() or tk:IsWrathClassic()) and "Achievements") or "Friends"];
        L[(tk:IsRetail() and "Collections Journal") or (tk:IsWrathClassic() and "Currency") or "Guild"];
        L[(tk:IsRetail() and "Encounter Journal") or "Macros"];
      };
    };

		tabBar = {
			show = true;
			yOffset = -12;
    };

		window = {
			yOffset = -37;
		}
	};
};

db:AddToDefaults("profile.chat", defaults);

-- Chat Module -------------------

local function LoadEditBoxBackdrop()
  if (obj:IsFunction(ChatFrame1EditBox.OnBackdropLoaded)) then
    ChatFrame1EditBox:OnBackdropLoaded();
  end
end

function C_ChatModule:OnInitialize(data)
  data.chatFrames = obj:PopTable();

  local currentLayout = db.profile.layout;
  if (currentLayout) then
    if (not db.global.layouts[currentLayout]) then
      db.profile.layout = nil;
    end
  end

	local setupOptions = {
    onExecuteAll = {
      last = {
        "editBox.backdropColor";
      };
      ignore = {
        "icons", "iconsAnchor";
      }
    };
		groups = {
      {
        patterns = {
          "editBox.position";
          "editBox.yOffset";
        };
				value = function()
					local yOffset = data.settings.editBox.yOffset;
					local position = data.settings.editBox.position;
					ChatFrame1EditBox:ClearAllPoints();

					if (position == "TOP") then
						ChatFrame1EditBox:SetPoint("BOTTOMLEFT", _G.ChatFrame1, "TOPLEFT", -3, yOffset);
						ChatFrame1EditBox:SetPoint("BOTTOMRIGHT", _G.ChatFrame1, "TOPRIGHT", 3, yOffset);

					elseif (position == "BOTTOM") then
						ChatFrame1EditBox:SetPoint("TOPLEFT", _G.ChatFrame1, "BOTTOMLEFT", -3, yOffset);
						ChatFrame1EditBox:SetPoint("TOPRIGHT", _G.ChatFrame1, "BOTTOMRIGHT", 3, yOffset);
					end
				end
			},
		}
	};

  if (not db.profile.chat.highlighted) then
    db:RemoveAppended(db.profile, "chat.highlighted");
  end

  db:AppendOnce("profile.chat.highlighted", nil, {
    {
      "healers", "healer", "healz", "heals", "heal", "healing",
      color = { 0.1; 1; 0.1; };
      sound = false;
      upperCase = false;
    },
    {
      "tanks", "tank", "tanking",
      color = { 1; 0.1; 0.1; };
      sound = false;
      upperCase = false;
    },
    {
      "dps";
      color = { 1; 1; 0; };
      sound = false;
      upperCase = false;
    },
    {
      _G.UnitName("player");
      color = { 1, 0.04, 0.78 };
      sound = tk.Constants.SOUND_OPTIONS[L["Whisper Received"]];
      upperCase = false;
    },
  });

  -- must be before data.settings gets initialised from RegisterUpdateFunctions
  for _, anchorName in obj:IterateArgs("TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT") do
    db.profile.chat.chatFrames[anchorName]:SetParent(db.profile.chat.__templateChatFrame);
  end

  self:RegisterUpdateFunctions(db.profile.chat, {
    iconsAnchor = function()
      C_ChatFrame.Static:SetUpSideBarIcons(self, data.settings);
    end;

    icons = function()
      C_ChatFrame.Static:SetUpSideBarIcons(self, data.settings);
    end;

    chatFrames = function(value, keysList)
      if (keysList:GetSize() == 1) then
        for anchorName, settings in pairs(value) do
          local muiChatFrame = data.chatFrames[anchorName];

          if (settings.enabled and not muiChatFrame) then
            muiChatFrame = C_ChatFrame(anchorName, self, data.settings);
            data.chatFrames[anchorName] = muiChatFrame;
          end
        end

        for anchorName, settings in pairs(value) do
          local muiChatFrame = data.chatFrames[anchorName];
          if (muiChatFrame) then
            muiChatFrame:SetEnabled(settings.enabled);
          end
        end
      else
        keysList:PopFront();
        local anchorName = keysList:PopFront();
        local muiChatFrame = data.chatFrames[anchorName];
        local settingName = keysList:PopFront();

        if (settingName == "enabled") then
          if (value and not muiChatFrame) then
            muiChatFrame = C_ChatFrame(anchorName, self, data.settings);

            data.chatFrames[anchorName] = muiChatFrame;
          end

          muiChatFrame:SetEnabled(value);
          return
        end

        if (not muiChatFrame) then return end

        if (settingName == "buttons") then
          keysList:PopFront();
          local buttonID = keysList:PopFront();

          if (buttonID ~= "key") then
            em:TriggerEventListenerByID(anchorName.."_OnModifierStateChanged");
          end

        elseif (settingName == "tabBar") then
          muiChatFrame:SetUpTabBar(data.settings.chatFrames[anchorName].tabBar);

        elseif (settingName == "xOffset" or settingName == "yOffset") then
          local frame = muiChatFrame:GetFrame();

          if (frame) then
            local p, rf, rp, x, y = frame:GetPoint();
            local xOffset = (settingName == "xOffset" and value) or x;
            local yOffset = (settingName == "yOffset" and value) or y;
            frame:SetPoint(p, rf, rp, xOffset, yOffset);
          end

        elseif (settingName == "window") then
          local frame = muiChatFrame:GetFrame();

          if (frame) then
            local p, rf, rp, x = frame.window:GetPoint();
            frame.window:SetPoint(p, rf, rp, x, value);
          end
        end
      end
    end;

    editBox = {
      height = function(value)
        ChatFrame1EditBox:SetHeight(value);
      end;

      border = function(value)
        data.editBoxBackdrop.edgeFile = tk.Constants.LSM:Fetch(tk.Constants.LSM.MediaType.BORDER, value);
        ChatFrame1EditBox:SetBackdrop(data.editBoxBackdrop);
        LoadEditBoxBackdrop();

        local color = data.settings.editBox.backdropColor;
        ChatFrame1EditBox:SetBackdropColor(color.r, color.g, color.b, color.a);
      end;

      inset = function(value)
        data.editBoxBackdrop.insets.left = value;
        data.editBoxBackdrop.insets.right = value;
        data.editBoxBackdrop.insets.top = value;
        data.editBoxBackdrop.insets.bottom = value;
        ChatFrame1EditBox:SetBackdrop(data.editBoxBackdrop);
        LoadEditBoxBackdrop();

        local color = data.settings.editBox.backdropColor;
        ChatFrame1EditBox:SetBackdropColor(color.r, color.g, color.b, color.a);
      end;

      borderSize = function(value)
        data.editBoxBackdrop.edgeSize = value;
        ChatFrame1EditBox:SetBackdrop(data.editBoxBackdrop);
        LoadEditBoxBackdrop();

        local color = data.settings.editBox.backdropColor;
        ChatFrame1EditBox:SetBackdropColor(color.r, color.g, color.b, color.a);
      end;

      backdropColor = function(value)
        ChatFrame1EditBox:SetBackdropColor(value.r, value.g, value.b, value.a);
        LoadEditBoxBackdrop();
      end;
    };
  }, setupOptions);
end

----------------------------------
-- Override Blizzard Functions:
----------------------------------
function C_ChatModule:OnInitialized(data)
  if (not data.settings.enabled) then return end

  -- perform migration if old settings are found:
  if (not tk.Tables:All(data.settings.icons, obj.IsTable)) then
    db:SetPathValue("profile.chat.icons", nil, nil, false);
  end

  -- Override Blizzard Stuff -----------------------
  hooksecurefunc("ChatEdit_UpdateHeader", function()
    local chatType = ChatFrame1EditBox:GetAttribute("chatType");
    local r, g, b = _G.GetMessageTypeColor(chatType);
    ChatFrame1EditBox:SetBackdropBorderColor(r, g, b, 1);
  end);

  self:SetEnabled(true);
end

function C_ChatModule:OnEnable(data)
  if (data.editBoxBackdrop) then return end

	StaticPopupDialogs["MUI_Link"] = {
		text = tk.Strings:Join(
			"\n", tk.Strings:SetTextColorByTheme("MayronUI"), L["(CTRL+C to Copy, CTRL+V to Paste)"]
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

  -- default setup
  data.editBoxBackdrop.edgeFile = tk.Constants.BACKDROP.edgeFile;
  data.editBoxBackdrop.edgeSize = tk.Constants.BACKDROP.edgeSize;
	data.editBoxBackdrop.bgFile = tk.Constants.BACKDROP_WITH_BACKGROUND.bgFile;
	data.editBoxBackdrop.insets = obj:PopTable();

	-- Kill all blizzard unwanted elements (textures, fontstrings, frames, etc...)
	for i = 1, 20 do
		local staticPopupEditBox = strformat("StaticPopup%dEditBox", i);

		if (not _G[staticPopupEditBox]) then
			break;
		end

		tk:KillAllElements(
			_G[strformat("%sLeft", staticPopupEditBox)],
			_G[strformat("%sMid", staticPopupEditBox)],
			_G[strformat("%sRight", staticPopupEditBox)]
		);
	end

	tk:KillAllElements(
		ChatFrame1EditBox.focusLeft, ChatFrame1EditBox.focusRight, ChatFrame1EditBox.focusMid,
		_G.ChatFrame1EditBoxLeft, _G.ChatFrame1EditBoxMid, _G.ChatFrame1EditBoxRight,
		_G.ChatFrameMenuButton,	_G.QuickJoinToastButton
	);

  -- rename stuff here:

  self:SetUpAllBlizzardFrames();
end

obj:DefineReturns("table");
function C_ChatModule:GetChatFrames(data)
	return data.chatFrames;
end

do
	local function LayoutButton_OnEnter(self)
		if (self.hideTooltip) then
			return
		end

		_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 8, -38);
    _G.GameTooltip:SetText(L["MUI Layout Button"]);

		_G.GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(
      L["Left Click:"]), L["Switch Layout"], 1, 1, 1);

		_G.GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(
      L["Right Click:"]), L["Show Layout Config Tool"], 1, 1, 1);

		_G.GameTooltip:Show();
	end

	local function LayoutButton_OnLeave()
		_G.GameTooltip:Hide();
	end

	local function GetNextLayout()
		local firstLayout, firstData;
		local foundCurrentLayout;
		local currentLayout = db.profile.layout;

		for layoutName, layoutData in db.global.layouts:Iterate() do
			if (obj:IsTable(layoutData)) then
				if (not firstLayout) then
					firstLayout = layoutName;
					firstData = layoutData;
				end

				if (currentLayout == layoutName) then -- the next layout
					foundCurrentLayout = true;

				elseif (foundCurrentLayout) then
					-- Found the next layout!
					return layoutName, layoutData;
				end
			end
		end

		-- The next layout must be back to the first layout
		return firstLayout, firstData;
	end

	local function LayoutButton_OnMouseUp(self, module, btnPressed)
		if (not _G.MouseIsOver(self)) then
			return;
		end

		if (btnPressed == "LeftButton") then
			if (InCombatLockdown()) then
				tk:Print(L["Cannot switch layouts while in combat."]);
				return;
			end

			local layoutName, layoutData = GetNextLayout();
			module:SwitchLayouts(layoutName, layoutData);
			PlaySound(tk.Constants.CLICK);

		elseif (btnPressed == "RightButton") then
			MayronUI:TriggerCommand("layouts");
		end
	end

	obj:DefineParams("Button");
	function C_ChatModule:SetUpLayoutButton(data, layoutButton)
		local layoutName = db.profile.layout;

		layoutButton:SetText(layoutName:sub(1, 1):upper());

		data.layoutButtons = data.layoutButtons or obj:PopTable();
		table.insert(data.layoutButtons, layoutButton);

		layoutButton:RegisterForClicks("LeftButtonDown", "RightButtonDown", "MiddleButtonDown");
		layoutButton:SetScript("OnEnter", LayoutButton_OnEnter);
		layoutButton:SetScript("OnLeave", LayoutButton_OnLeave);
		layoutButton:SetScript("OnMouseUp", function(_, btnPressed)
			LayoutButton_OnMouseUp(layoutButton, self, btnPressed);
		end);
	end
end

obj:DefineParams("string", "?table");
function C_ChatModule:SwitchLayouts(data, layoutName, layoutData)
  if (InCombatLockdown()) then
    tk:Print(L["Cannot switch layouts while in combat."]);
    return;
  end

  MayronUI:SwitchLayouts(layoutName, layoutData);

  for _, btn in ipairs(data.layoutButtons) do
    btn:SetText(layoutName:sub(1, 1):upper());
  end

  tk:Print(tk.Strings:SetTextColorByRGB(layoutName, 0, 1, 0), L["Layout enabled!"]);
end

-- must be before chat is initialized!
for i = 1, NUM_CHAT_WINDOWS do
  _G["ChatFrame"..i]:SetClampRectInsets(0, 0, 0, 0);
  local editBox = _G["ChatFrame"..i.."EditBox"];

  if (_G.BackdropTemplateMixin) then
    _G.Mixin(editBox, _G.BackdropTemplateMixin);
    editBox:OnBackdropLoaded();
    editBox:SetScript("OnSizeChanged", editBox.OnBackdropSizeChanged);
  end
end