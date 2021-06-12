-- luacheck: ignore MayronUI self 143
local _G = _G;
local MayronUI = _G.MayronUI; ---@type MayronUI
local tk, _, em, gui, obj, L = MayronUI:GetCoreComponents();
local MEDIA = tk:GetAssetFilePath("Textures\\Chat\\");

---@class ChatFrame
local C_ChatFrame = obj:Import("MayronUI.ChatModule.ChatFrame");

local ChatMenu, CreateFrame, UIMenu_Initialize, UIMenu_AutoSize, string, table, pairs =
	_G.ChatMenu, _G.CreateFrame, _G.UIMenu_Initialize, _G.UIMenu_AutoSize, _G.string, _G.table, _G.pairs;

local UIMenu_AddButton, FriendsFrame_SetOnlineStatus = _G.UIMenu_AddButton, _G.FriendsFrame_SetOnlineStatus;

local FRIENDS_TEXTURE_ONLINE, FRIENDS_TEXTURE_AFK, FRIENDS_TEXTURE_DND =
	_G.FRIENDS_TEXTURE_ONLINE, _G.FRIENDS_TEXTURE_AFK, _G.FRIENDS_TEXTURE_DND;

local FRIENDS_LIST_AVAILABLE, FRIENDS_LIST_AWAY, FRIENDS_LIST_BUSY =
  _G.FRIENDS_LIST_AVAILABLE, _G.FRIENDS_LIST_AWAY, _G.FRIENDS_LIST_BUSY;

local IsAddOnLoaded, InCombatLockdown, UIParent, ipairs = _G.IsAddOnLoaded, _G.InCombatLockdown, _G.UIParent, _G.ipairs;
local PlaySound = _G.PlaySound;
-- C_ChatFrame -----------------------

obj:DefineParams("string", "ChatModule", "table");
---@param anchorName string position of chat frame (i.e. "TOPLEFT")
---@param chatModule ChatModule
---@param chatModuleSettings table
function C_ChatFrame:__Construct(data, anchorName, chatModule, chatModuleSettings)
	data.anchorName = anchorName;
	data.chatModule = chatModule;
	data.chatModuleSettings = chatModuleSettings;
	data.settings = chatModuleSettings.chatFrames[anchorName];
end

obj:DefineParams("boolean");
---@param enabled boolean enable/disable the chat frame
function C_ChatFrame:SetEnabled(data, enabled)
	if (not data.frame and enabled) then
		data.frame = self:CreateFrame();
		self:SetUpTabBar(data.settings.tabBar);

		if (data.anchorName ~= "TOPLEFT") then
			self:Reposition();
		end

    if (IsAddOnLoaded("Blizzard_CompactRaidFrames")) then
      data.chatModule:SetUpRaidFrameManager();
    else
      -- if it is not loaded, create a callback to trigger when it is loaded
      local listener = em:CreateEventListener(function(_, name)
        if (name == "Blizzard_CompactRaidFrames") then
          data.chatModule:SetUpRaidFrameManager();
        end
      end)

      listener:SetExecuteOnce(true);
      listener:RegisterEvent("ADDON_LOADED");
    end

		-- chat channel button
		data.chatModule:SetUpLayoutButton(data.frame.layoutButton);
	end

	if (data.frame) then
		data.frame:SetShown(enabled);

		if (enabled) then
			self:SetUpButtonHandler(data.settings.buttons);
    end

    self.Static:SetUpSideBarIcons(data.chatModule, data.chatModuleSettings);
    _G.ChatFrameChannelButton:DisableDrawLayer("ARTWORK");

    if (tk:IsRetail()) then
      _G.ChatFrameToggleVoiceMuteButton:DisableDrawLayer("ARTWORK");
      _G.ChatFrameToggleVoiceDeafenButton:DisableDrawLayer("ARTWORK");
    end
	end
end

function C_ChatFrame.Static:SetUpSideBarIcons(chatModule, settings)
  local muiChatFrame = _G["MUI_ChatFrame_" .. settings.iconsAnchor];
  local selectedChatFrame;

  if (muiChatFrame and muiChatFrame:IsShown()) then
    selectedChatFrame = muiChatFrame;
  else
    for anchorName, _ in pairs(chatModule:GetChatFrames()) do
      muiChatFrame = _G["MUI_ChatFrame_" .. anchorName];

      if (muiChatFrame and muiChatFrame:IsShown()) then
        selectedChatFrame = muiChatFrame;
        break;
      end
    end
  end

  if (selectedChatFrame) then
    self:PositionSideBarIcons(settings.icons, selectedChatFrame);
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

obj:DefineReturns("Frame");
---@return Frame returns an MUI chat frame
function C_ChatFrame:CreateFrame(data)
	local muiChatFrame = CreateFrame("Frame", "MUI_ChatFrame_" .. data.anchorName, UIParent);

  muiChatFrame:SetFrameStrata("LOW");
  muiChatFrame:SetFrameLevel(1);
	muiChatFrame:SetSize(358, 310);
	muiChatFrame:SetPoint(data.anchorName, data.settings.xOffset, data.settings.yOffset);

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

  data.frame:SetPoint(data.anchorName, UIParent, data.anchorName,
    data.settings.xOffset, data.settings.yOffset);

	if (data.anchorName == "TOPRIGHT") then
		data.frame.sidebar:SetPoint(data.anchorName, data.frame, data.anchorName, 0 , -10);
		data.frame.window:SetPoint("TOPRIGHT", data.frame.sidebar, "TOPLEFT", -2, data.settings.window.yOffset);
		data.frame.window.texture:SetTexCoord(1, 0, 0, 1);

	elseif (tk.Strings:Contains(data.anchorName, "BOTTOM")) then
		data.frame.sidebar:SetPoint(data.anchorName, data.frame, data.anchorName, 0 , 10);

		if (data.anchorName == "BOTTOMLEFT") then
			data.frame.window:SetPoint(
        "BOTTOMLEFT", data.frame.sidebar, "BOTTOMRIGHT",
        2, data.settings.window.yOffset);
			data.frame.window.texture:SetTexCoord(0, 1, 1, 0);

		elseif (data.anchorName == "BOTTOMRIGHT") then
      data.frame.window:SetPoint(
        "BOTTOMRIGHT", data.frame.sidebar, "BOTTOMLEFT",
        -2, data.settings.window.yOffset);
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

do
  local CreateOrSetUpIcon = {};

	local function PositionChatIconMenu(icon, menu, protected)
    local chatAnchor = icon:GetParent():GetName():match(".*_(.*)$");
    menu:ClearAllPoints();

    if (protected) then
      local x, y = icon:GetCenter();

      if (chatAnchor:find("TOP")) then
        y = y + 10;
      elseif (chatAnchor:find("BOTTOM")) then
        y = y - 10;
      end

      if (chatAnchor:find("LEFT")) then
        x = x + 15;
      elseif (chatAnchor:find("RIGHT")) then
        x = x - 15;
      end

      menu:SetPoint(chatAnchor, UIParent, "BOTTOMLEFT", x, y);
    else
      local orig, new = "RIGHT", "LEFT";

      if (chatAnchor:find("LEFT")) then
        orig, new = "LEFT", "RIGHT";
      end

      local relPoint = chatAnchor:gsub(orig, new);
      menu:SetPoint(chatAnchor, icon, relPoint);
    end

		icon:GetScript("OnLeave")(icon);
	end

	local function PositionIcon(enabled, iconType, anchorIcon, chatFrame, bottom)
    local currentIcon = _G["MUI_ChatFrameIcon_"..iconType];

    if (iconType == "deafen" or iconType == "mute") then
      if (not currentIcon) then
				currentIcon = CreateOrSetUpIcon[iconType]("MUI_ChatFrameIcon_"..iconType);
      end

      currentIcon:SetVisibilityQueryFunction(function() return enabled; end);
      currentIcon:UpdateVisibleState();
    end

    if (enabled) then
      if (not currentIcon) then
        currentIcon = CreateOrSetUpIcon[iconType]("MUI_ChatFrameIcon_"..iconType);
      end

			currentIcon:ClearAllPoints();
			currentIcon:SetParent(chatFrame);
      currentIcon:SetSize(24, 24); -- fixes inconsistencies with blizz buttons (e.g., voice chat icons)

      if (currentIcon.Menu) then
        currentIcon.Menu:SetParent(chatFrame);
      end

			if (anchorIcon) then
        local point, relPoint, yOffset = "TOPLEFT", "BOTTOMLEFT", -2;

        if (bottom) then
          point, relPoint, yOffset = "BOTTOMLEFT", "TOPLEFT", 2;
        end

				currentIcon:SetPoint(point, anchorIcon, relPoint, 0, yOffset);
			else
        local point, relPoint, yOffset = "TOPLEFT", "TOPLEFT", -14;

        if (bottom) then
          point, relPoint, yOffset = "BOTTOMLEFT", "BOTTOMLEFT", 14;
        end

				currentIcon:SetPoint(point, chatFrame.sidebar, relPoint, 1, yOffset);
			end

			currentIcon:Show();
			return currentIcon;

		elseif (currentIcon) then
      currentIcon:ClearAllPoints();
			currentIcon:Hide();
		end

		return anchorIcon;
	end

  local iconTypes = {
    "voiceChat";
    "professions";
    "shortcuts";
    "copyChat";
    "emotes";
    "playerStatus";
    "none";
  };

  if (tk:IsRetail()) then
    table.insert(iconTypes, 2, "deafen");
    table.insert(iconTypes, 3, "mute");
  end

  function C_ChatFrame.Static:PositionSideBarIcons(iconSettings, muiChatFrame)
		local anchorIcon, total, bottomIndex = nil, 0, 0;

    -- hide all:
    for _, iconType in ipairs(iconTypes) do
      PositionIcon(false, iconType);
    end

    for _, value in ipairs(iconSettings) do
      if (obj:IsTable(value) and obj:IsString(value.type)) then
        if (total >= 3) then
          -- reverse
          local newIndex = #iconSettings - bottomIndex;
          value = iconSettings[newIndex];

          if (total == 3) then
            anchorIcon = nil;
          end

          bottomIndex = bottomIndex + 1;
        end

        local iconSupported = (tk:IsRetail() or (not tk:IsRetail() and
          not (value.type == "deafen" or value.type == "mute")));

        if (value.type ~= "none" and iconSupported) then
          total = total + 1;
          anchorIcon = PositionIcon(true, value.type, anchorIcon, muiChatFrame, total > 3);
        end
      end
    end
	end

  function CreateOrSetUpIcon.mute(name)
    _G[name] = _G.ChatFrameToggleVoiceMuteButton;
    return _G[name];
  end

  function CreateOrSetUpIcon.deafen(name)
    _G[name] = _G.ChatFrameToggleVoiceDeafenButton;
    return _G[name];
  end

  function CreateOrSetUpIcon.voiceChat()
    local btn = _G.ChatFrameChannelButton;
    _G.MUI_ChatFrameIcon_voiceChat = btn;

    if (not tk:IsRetail()) then
      tk:KillElement(_G.ChatFrameMenuButton);
    end

    return btn;
  end

  function CreateOrSetUpIcon.emotes(name)
    local toggleEmotesButton = CreateFrame("Button", name);
    toggleEmotesButton:SetNormalTexture(string.format("%sspeechIcon", MEDIA));
    toggleEmotesButton:GetNormalTexture():SetVertexColor(tk.Constants.COLORS.GOLD:GetRGB());
    toggleEmotesButton:SetHighlightAtlas("chatframe-button-highlight");

    tk:SetBasicTooltip(toggleEmotesButton, L["Show Chat Menu"], "ANCHOR_CURSOR_RIGHT", 16, 8);

    toggleEmotesButton:SetScript("OnClick", function(self)
      PlaySound(tk.Constants.CLICK);
      PositionChatIconMenu(self, ChatMenu);
      _G.ChatFrame_ToggleMenu();
    end);

    return toggleEmotesButton;
  end

  do
    local GetProfessions = _G.GetProfessions;
    local GetProfessionInfo = _G.GetProfessionInfo;
    local select = _G.select;

    if (not tk:IsRetail()) then
      ---@type LibAddonCompat
      local LibAddonCompat = _G.LibStub("LibAddonCompat-1.0");

      GetProfessions = function()
        return LibAddonCompat:GetProfessions();
      end

      GetProfessionInfo = function(spellIndex)
        return LibAddonCompat:GetProfessionInfo(spellIndex);
      end
    end

    local function GetProfessionIDs()
      --self, text, shortcut, func, nested, value
      local prof1, prof2, _, fishing, cooking, firstAid = GetProfessions();

      local professions = obj:PopTable(prof1, prof2, fishing, cooking, firstAid);
      professions = tk.Tables:Filter(professions, function(spellIndex)
        if (spellIndex) then
          local spellbookID = select(6, GetProfessionInfo(spellIndex));
          if (obj:IsNumber(spellbookID)) then
            return true;
          end
        end
      end);

      return professions;
    end

    local menuWidth = 240;
    local buttonHeight = 32;

    local function CreateProfessionButton(profMenu, spellIndex)
      local btnName = "MUI_ProfessionsMenuButton"..spellIndex;
      local btnTemplate = tk:IsRetail() and "ProfessionButtonTemplate" or "SpellButtonTemplate";
      local btn = CreateFrame("CheckButton", btnName, profMenu, btnTemplate);

      local iconFrame = CreateFrame("Frame", nil, btn, _G.BackdropTemplateMixin and "BackdropTemplate");
      iconFrame:SetSize(buttonHeight - 8, buttonHeight - 8);
      iconFrame:ClearAllPoints();
      iconFrame:SetPoint("LEFT", 6, 0);
      iconFrame:SetBackdrop(tk.Constants.BACKDROP);
      iconFrame:SetBackdropBorderColor(0, 0, 0, 1);

      local iconTexture = _G[btnName.."IconTexture"];
      iconTexture:SetSize(buttonHeight - 6, buttonHeight - 6);
      iconTexture:ClearAllPoints();
      iconTexture:SetPoint("TOPLEFT", iconFrame, "TOPLEFT", 1, -1);
      iconTexture:SetPoint("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT", -1, 1);
      iconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9);

      btn:SetSize(menuWidth - 9, buttonHeight);
      btn:SetScript("OnEnter", _G.UIMenuButton_OnEnter);
      btn:SetScript("OnLeave", _G.UIMenuButton_OnLeave);
      btn:SetCheckedTexture(nil);
      btn:DisableDrawLayer("BACKGROUND");
      btn:DisableDrawLayer("ARTWORK");
      btn:SetFrameLevel(20);

      local spellName = _G[btnName.."SpellName"];
      local spellSubName = _G[btnName.."SubSpellName"];
      spellName:SetWidth(300);
      spellName:ClearAllPoints();
      spellName:SetPoint("TOPLEFT", iconTexture, "TOPRIGHT", 8, 0);
      spellSubName:SetFontObject("GameFontHighlightSmall");

      local r, g, b = tk:GetThemeColor();
      btn:SetHighlightTexture(tk.Constants.SOLID_TEXTURE, "ADD");
      btn.SetHighlightTexture = tk.Constants.DUMMY_FUNC;

      local t = btn:GetHighlightTexture();
      t.SetTexture = tk.Constants.DUMMY_FUNC;
      t:SetColorTexture(r * 0.7, g * 0.7, b * 0.7, 0.4);

      btn:HookScript("OnClick", function() profMenu:Hide() end);
      return btn;
    end

    local function ProfessionsMenuOnShow(icon, menu)
      local professionIDs = GetProfessionIDs();

      if (#professionIDs == 0) then
        obj:PushTable(professionIDs);
        MayronUI:Print(L["You have no professions."]);
        menu:Hide();
        return
      end

      PositionChatIconMenu(icon, menu, true);

      for _, btn in pairs(menu.btns) do
        btn:Hide();
      end

      if (tk:IsRetail()) then
        _G.SpellBookFrame.bookType = _G.BOOKTYPE_PROFESSION;
      end

      _G.SpellBookFrame.selectedSkillLine = 1; -- General Tab (needed to ensure offset is 0)!

      local prev;
      for _, spellIndex in ipairs(professionIDs) do
        local profName, _, skillRank, skillMaxRank, _, spellbookID = GetProfessionInfo(spellIndex);

        local btn = menu.btns[spellIndex] or CreateProfessionButton(menu, spellIndex);
        menu.btns[spellIndex] = btn;

        -- Update button:
        btn:SetID(spellbookID + 1);
        _G.SpellButton_UpdateButton(btn);

        -- Update button text:
        local spellName = _G[btn:GetName().."SpellName"];
        local text = tk.Strings:Concat(profName, " (", skillRank, "/", skillMaxRank, ")");
        spellName:SetText(text);

        btn:ClearAllPoints();

        if (not prev) then
          btn:SetPoint("TOPLEFT", 5, -4);
        else
          btn:SetPoint("TOPLEFT", prev, "BOTTOMLEFT");
        end

        btn:Show();

        prev = btn;
      end

      menu:SetHeight((#professionIDs * (buttonHeight)) + 8);
      obj:PushTable(professionIDs);

      menu.timeleft = 2.0;
      menu.counting = 0;
    end

    function CreateOrSetUpIcon.professions(name)
      local professionsIcon = CreateFrame("Button", name);
      professionsIcon:SetNormalTexture(string.format("%sbook", MEDIA));
      professionsIcon:GetNormalTexture():SetVertexColor(tk.Constants.COLORS.GOLD:GetRGB());
      professionsIcon:SetHighlightAtlas("chatframe-button-highlight");

      tk:SetBasicTooltip(professionsIcon, L["Show Professions"], "ANCHOR_CURSOR_RIGHT", 16, 8);

      local template = tk:IsClassic() and "UIMenuTemplate" or "TooltipBackdropTemplate";
      local profMenu = CreateFrame("Frame", "MUI_ProfessionsMenu", UIParent, template);
      profMenu.btns = obj:PopTable();
      profMenu.specializationIndex = 0;
      profMenu.spellOffset = 0;

      profMenu:SetSize(menuWidth, buttonHeight);
      profMenu:SetScript("OnUpdate", _G.UIMenu_OnUpdate);
      profMenu:SetScript("OnEvent", profMenu.Hide);
      profMenu:RegisterEvent("PLAYER_REGEN_DISABLED");

      local missingAnchor = true;

      professionsIcon:SetScript("OnClick", function(self)
        PlaySound(tk.Constants.CLICK);

        if (InCombatLockdown()) then
          MayronUI:Print(L["Cannot toggle menu while in combat."]);
          return
        end

        if (missingAnchor) then
          -- Explicitly run show script:
          profMenu:Show(); -- might have been hidden by entering combat listener
          ProfessionsMenuOnShow(self, profMenu);

          missingAnchor = nil;
          return
        end

        profMenu:SetShown(not profMenu:IsShown());

        if (profMenu:IsShown()) then
          ProfessionsMenuOnShow(self, profMenu);
          missingAnchor = nil;
        end
      end);

      return professionsIcon;
    end
  end

  function CreateOrSetUpIcon.shortcuts(name)
    local btn = CreateFrame("Button", name);
    btn:SetNormalTexture(string.format("%sshortcuts", MEDIA));
    btn:GetNormalTexture():SetVertexColor(tk.Constants.COLORS.GOLD:GetRGB());
    btn:SetHighlightAtlas("chatframe-button-highlight");

    tk:SetBasicTooltip(btn, L["Show AddOn Shortcuts"], "ANCHOR_CURSOR_RIGHT", 16, 8);

    local menu = CreateFrame("Frame", "MUI_ShortcutsMenu", btn, "UIMenuTemplate");
    UIMenu_Initialize(menu);

    local lines = {
      { "MUI "..L["Config Menu"], "/mui config", function() MayronUI:TriggerCommand("config") end};
      { "MUI "..L["Install"], "/mui install", function() MayronUI:TriggerCommand("install") end};
      { "MUI "..L["Layouts"], "/mui layouts", function() MayronUI:TriggerCommand("layouts") end};
      { "MUI "..L["Profile Manager"], "/mui profiles", function() MayronUI:TriggerCommand("profiles") end};
      { "MUI "..L["Show Profiles"], "/mui profiles list", function() MayronUI:TriggerCommand("profiles", "list") end};
      { "MUI "..L["Version"], "/mui version", function() MayronUI:TriggerCommand("version") end};
      { "MUI "..L["Report"], "/mui report", function() MayronUI:TriggerCommand("report") end};
      { "Leatrix Plus", _G.SLASH_Leatrix_Plus1, function() _G.SlashCmdList.Leatrix_Plus("") end};
      { L["Toggle Alignment Grid"], "/ltp grid", function() _G.SlashCmdList.Leatrix_Plus("grid") end};
      { "Bartender", "/bt", _G.Bartender4.ChatCommand};
      { "Shadowed Unit Frames", _G.SLASH_SHADOWEDUF1, function() _G.SlashCmdList.SHADOWEDUF("") end};
      { "Masque", _G.SLASH_MASQUE1, _G.SlashCmdList.MASQUE};
      { "Bagnon "..L["Bank"], "/bgn bank", function() _G.Bagnon.Commands.OnSlashCommand("bank") end };
      { "Bagnon "..L["Guild Bank"], "/bgn guild", function() _G.Bagnon.Commands.OnSlashCommand("guild") end, true };
      { "Bagnon "..L["Void Storage"], "/bgn vault", function() _G.Bagnon.Commands.OnSlashCommand("vault") end, true };
      { "Bagnon "..L["Config Menu"], "/bgn config", function() _G.Bagnon.Commands.OnSlashCommand("config") end };
    };

    for _, line in pairs(lines) do
      if (not line[4] or tk:IsRetail()) then
        UIMenu_AddButton(menu, line[1], line[2], line[3]);
      end
    end

    UIMenu_AutoSize(menu);
    menu:Hide();

    btn:SetScript("OnClick", function(self)
      menu:SetShown(not menu:IsShown());

      if (menu:IsShown()) then
        PositionChatIconMenu(self, menu);
      else
        PlaySound(tk.Constants.CLICK);
      end
    end);

    btn.Menu = menu;

    return btn;
  end

	function CreateOrSetUpIcon.playerStatus(name)
		local playerStatusButton = CreateFrame("Button", name);

		local listener = em:CreateEventListener(function()
			local status = _G.FRIENDS_TEXTURE_ONLINE;
			local _, _, _, _, bnetAFK, bnetDND = _G.BNGetInfo();

			if (bnetAFK) then
				status = _G.FRIENDS_TEXTURE_AFK;
			elseif (bnetDND) then
				status = _G.FRIENDS_TEXTURE_DND;
			end

			playerStatusButton:SetNormalTexture(status);
    end);

    listener:RegisterEvent("BN_INFO_CHANGED");
    em:TriggerEventListener(listener);

		playerStatusButton:SetHighlightAtlas("chatframe-button-highlight");
		tk:SetBasicTooltip(playerStatusButton, L["Change Status"], "ANCHOR_CURSOR_RIGHT", 16, 8);

		local optionText = "\124T%s.tga:16:16:0:0\124t %s";
		local availableText = string.format(optionText, FRIENDS_TEXTURE_ONLINE, FRIENDS_LIST_AVAILABLE);
		local afkText = string.format(optionText, FRIENDS_TEXTURE_AFK, FRIENDS_LIST_AWAY);
		local dndText = string.format(optionText, FRIENDS_TEXTURE_DND, FRIENDS_LIST_BUSY);

		local function SetOnlineStatus(btn)
			FriendsFrame_SetOnlineStatus(btn);
			playerStatusButton:SetNormalTexture(btn.value);
		end

    local statusMenu = CreateFrame("Frame", "MUI_StatusMenu", UIParent, "UIMenuTemplate");
    UIMenu_Initialize(statusMenu);
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
      else
        PlaySound(tk.Constants.CLICK);
      end
    end);

    playerStatusButton.Menu = statusMenu;

		return playerStatusButton;
	end

  do
		-- accountNameCode cannot be used as |K breaks the editBox
		local function RefreshChatText(editBox)
			local chatFrame = _G[string.format("ChatFrame%d", editBox.chatFrameID)];
			local messages = obj:PopTable();
			local totalMessages = chatFrame:GetNumMessages();
      local message, r, g, b;

			for i = 1, totalMessages do
        message, r, g, b = chatFrame:GetMessageInfo(i);

        if (obj:IsString(message) and #message > 0) then
          -- |Km26|k (BSAp) or |Kq%d+|k
          message = message:gsub("|K.*|k", tk.ReplaceAccountNameCodeWithBattleTag);
          message = tk.Strings:SetTextColorByRGB(message, r, g, b);

					table.insert(messages, message);
				end
      end

			local fullText = table.concat(messages, " \n", 1, #messages);
			obj:PushTable(messages);

			editBox:SetText(fullText);
		end

    local function CreateCopyChatFrame()
      local frame = CreateFrame("Frame", nil, _G.UIParent);
      frame:SetSize(600, 300);
      frame:SetPoint("CENTER");
      frame:Hide();

      gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, nil, frame);
      gui:AddCloseButton(tk.Constants.AddOnStyle, frame, nil, tk.Constants.CLICK);
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
      refreshButton:SetNormalTexture(tk:GetAssetFilePath("Textures\\refresh"));
      refreshButton:GetNormalTexture():SetVertexColor(tk:GetThemeColor());
      refreshButton:SetHighlightAtlas("chatframe-button-highlight");
      tk:SetBasicTooltip(refreshButton, L["Refresh Chat Text"]);

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

		function CreateOrSetUpIcon.copyChat(name)
			local copyChatButton = CreateFrame("Button", name);
			copyChatButton:SetNormalTexture(string.format("%scopyIcon", MEDIA));
			copyChatButton:GetNormalTexture():SetVertexColor(tk.Constants.COLORS.GOLD:GetRGB());
			copyChatButton:SetHighlightAtlas("chatframe-button-highlight");

			tk:SetBasicTooltip(copyChatButton, L["Copy Chat Text"], "ANCHOR_CURSOR_RIGHT", 16, 8);

			copyChatButton:SetScript("OnClick", function(self)
        PlaySound(tk.Constants.MENU_OPENED_CLICK);
				if (not self.chatTextFrame) then
					self.chatTextFrame = CreateCopyChatFrame();
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
end