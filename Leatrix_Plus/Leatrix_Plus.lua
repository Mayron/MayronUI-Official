----------------------------------------------------------------------
-- 	Leatrix Plus 8.1.00 (12th December 2018, www.leatrix.com)
----------------------------------------------------------------------

--	01:Functions	20:Live			50:RunOnce		70:Logout			
--	02:Locks		30:Isolated 	60:Events		80:Commands
--	03:Restarts		40:Player		62:Profile		90:Panel	

----------------------------------------------------------------------
-- 	Leatrix Plus
----------------------------------------------------------------------

--  Create global table
	_G.LeaPlusDB = _G.LeaPlusDB or {}

-- 	Create locals
	local LeaPlusLC, LeaPlusCB, LeaDropList, LeaConfigList = {}, {}, {}, {}
	local ClientVersion = GetBuildInfo()
	local GameLocale = GetLocale()
	local void

--	Version
	LeaPlusLC["AddonVer"] = "8.1.00"
	LeaPlusLC["RestartReq"] = nil

--	If client restart is required and has not been done, show warning and quit
	if LeaPlusLC["RestartReq"] then
		local metaVer = GetAddOnMetadata("Leatrix_Plus", "Version")
		if metaVer and metaVer ~= LeaPlusLC["AddonVer"] then
			C_Timer.After(1, function()
				print("NOTICE!|nYou must fully restart your game client before you can use this version of Leatrix Plus.")
			end)
			return
		end
	end

----------------------------------------------------------------------
--	L00: Leatrix Plus
----------------------------------------------------------------------

-- 	Get locale table
	local void, Leatrix_Plus = ...
	local L = Leatrix_Plus.L

--	Initialise variables
	LeaPlusLC["ShowErrorsFlag"] = 1
	LeaPlusLC["NumberOfPages"] = 9
	LeaPlusLC["RaidColors"] = RAID_CLASS_COLORS

--	Create event frame
	local LpEvt = CreateFrame("FRAME")
	LpEvt:RegisterEvent("ADDON_LOADED")
	LpEvt:RegisterEvent("PLAYER_LOGIN")

----------------------------------------------------------------------
--	L01: Functions
----------------------------------------------------------------------

	-- Print text
	function LeaPlusLC:Print(text)
		DEFAULT_CHAT_FRAME:AddMessage(L[text], 1.0, 0.85, 0.0)
	end

	-- Lock and unlock an item
	function LeaPlusLC:LockItem(item, lock)
		if lock then
			item:Disable()
			item:SetAlpha(0.3)
		else
			item:Enable()
			item:SetAlpha(1.0)
		end
	end

	-- Hide configuration panels
	function LeaPlusLC:HideConfigPanels()
		for k, v in pairs(LeaConfigList) do
			v:Hide()
		end
	end

	-- Load a string variable or set it to default if it's not set to "On" or "Off"
	function LeaPlusLC:LoadVarChk(var, def)
		if LeaPlusDB[var] and type(LeaPlusDB[var]) == "string" and LeaPlusDB[var] == "On" or LeaPlusDB[var] == "Off" then
			LeaPlusLC[var] = LeaPlusDB[var]
		else
			LeaPlusLC[var] = def
			LeaPlusDB[var] = def
		end
	end

	-- Load a numeric variable and set it to default if it's not within a given range
	function LeaPlusLC:LoadVarNum(var, def, valmin, valmax)
		if LeaPlusDB[var] and type(LeaPlusDB[var]) == "number" and LeaPlusDB[var] >= valmin and LeaPlusDB[var] <= valmax then
			LeaPlusLC[var] = LeaPlusDB[var]
		else
			LeaPlusLC[var] = def
			LeaPlusDB[var] = def
		end
	end

	-- Load an anchor point variable and set it to default if the anchor point is invalid
	function LeaPlusLC:LoadVarAnc(var, def)
		if LeaPlusDB[var] and type(LeaPlusDB[var]) == "string" and LeaPlusDB[var] == "CENTER" or LeaPlusDB[var] == "TOP" or LeaPlusDB[var] == "BOTTOM" or LeaPlusDB[var] == "LEFT" or LeaPlusDB[var] == "RIGHT" or LeaPlusDB[var] == "TOPLEFT" or LeaPlusDB[var] == "TOPRIGHT" or LeaPlusDB[var] == "BOTTOMLEFT" or LeaPlusDB[var] == "BOTTOMRIGHT" then
			LeaPlusLC[var] = LeaPlusDB[var]
		else
			LeaPlusLC[var] = def
			LeaPlusDB[var] = def
		end
	end

	-- Show tooltips for checkboxes
	function LeaPlusLC:TipSee()
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		local parent = self:GetParent()
		local pscale = parent:GetEffectiveScale()
		local gscale = UIParent:GetEffectiveScale()
		local tscale = GameTooltip:GetEffectiveScale()
		local gap = ((UIParent:GetRight() * gscale) - (parent:GetRight() * pscale))
		if gap < (250 * tscale) then
			GameTooltip:SetPoint("TOPRIGHT", parent, "TOPLEFT", 0, 0)
		else
			GameTooltip:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, 0)
		end
		GameTooltip:SetText(self.tiptext, nil, nil, nil, nil, true)
	end

	-- Show tooltips for configuration buttons and dropdown menus
	function LeaPlusLC:ShowTooltip()
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		local parent = LeaPlusLC["PageF"]
		local pscale = parent:GetEffectiveScale()
		local gscale = UIParent:GetEffectiveScale()
		local tscale = GameTooltip:GetEffectiveScale()
		local gap = ((UIParent:GetRight() * gscale) - (LeaPlusLC["PageF"]:GetRight() * pscale))
		if gap < (250 * tscale) then
			GameTooltip:SetPoint("TOPRIGHT", parent, "TOPLEFT", 0, 0)
		else
			GameTooltip:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, 0)
		end
		GameTooltip:SetText(self.tiptext, nil, nil, nil, nil, true)
	end

	-- Show tooltips for interface settings (not currently used)
	function LeaPlusLC:ShowFacetip()
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText(self.tiptext, nil, nil, nil, nil, true)
	end

	-- Create configuration button
	function LeaPlusLC:CfgBtn(name, parent)
		local CfgBtn = CreateFrame("BUTTON", nil, parent)
		LeaPlusCB[name] = CfgBtn
		CfgBtn:SetWidth(20)
		CfgBtn:SetHeight(20)
		CfgBtn:SetPoint("LEFT", parent.f, "RIGHT", 0, 0)

		CfgBtn.t = CfgBtn:CreateTexture(nil, "BORDER")
		CfgBtn.t:SetAllPoints()
		CfgBtn.t:SetTexture("Interface\\WorldMap\\Gear_64.png")
		CfgBtn.t:SetTexCoord(0, 0.50, 0, 0.50);
		CfgBtn.t:SetVertexColor(1.0, 0.82, 0, 1.0)

		CfgBtn:SetHighlightTexture("Interface\\WorldMap\\Gear_64.png")
		CfgBtn:GetHighlightTexture():SetTexCoord(0, 0.50, 0, 0.50);

		CfgBtn.tiptext = L["Click to configure the settings for this option."]
		CfgBtn:SetScript("OnEnter", LeaPlusLC.ShowTooltip)
		CfgBtn:SetScript("OnLeave", GameTooltip_Hide)
	end

	-- Capitalise first character in a string
	function LeaPlusLC:CapFirst(str)
		return gsub(string.lower(str), "^%l", strupper)
	end

	-- Toggle Zygor addon
	function LeaPlusLC:ZygorToggle()
		if select(2, GetAddOnInfo("ZygorGuidesViewer")) then
			if not IsAddOnLoaded("ZygorGuidesViewer") then
				if LeaPlusLC:PlayerInCombat() then
					return
				else
					EnableAddOn("ZygorGuidesViewer")
					ReloadUI();
				end
			else
				DisableAddOn("ZygorGuidesViewer")
				ReloadUI();
			end
		else
			-- Zygor cannot be found
			LeaPlusLC:Print("Zygor addon not found.");
		end
		return
	end

	-- Show memory usage stat
	function LeaPlusLC:ShowMemoryUsage(frame, anchor, x, y)

		-- Create frame
		local memframe = CreateFrame("FRAME", nil, frame)
		memframe:ClearAllPoints()
		memframe:SetPoint(anchor, x, y)
		memframe:SetWidth(100)
		memframe:SetHeight(20)

		-- Create labels
		local pretext = memframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		pretext:SetPoint("TOPLEFT", 0, 0)
		pretext:SetText(L["Memory Usage"])

		local memtext = memframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		memtext:SetPoint("TOPLEFT", 0, 0 - 30)

		-- Create stat
		local memstat = memframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		memstat:SetPoint("BOTTOMLEFT", memtext, "BOTTOMRIGHT")
		memstat:SetText("(calculating...)")

		-- Create update script
		local memtime = -1
		memframe:SetScript("OnUpdate", function(self, elapsed)
			if memtime > 2 or memtime == -1 then
				UpdateAddOnMemoryUsage();
				memtext = GetAddOnMemoryUsage("Leatrix_Plus")
				memtext = math.floor(memtext + .5) .. " KB"
				memstat:SetText(memtext);
				memtime = 0;
			end
			memtime = memtime + elapsed;
		end)

		-- Release memory
		LeaPlusLC.ShowMemoryUsage = nil

	end

	-- Check if player is in LFG queue
	function LeaPlusLC:IsInLFGQueue()
 		if 	GetLFGMode(LE_LFG_CATEGORY_LFD) or
			GetLFGMode(LE_LFG_CATEGORY_LFR) or
			GetLFGMode(LE_LFG_CATEGORY_RF) or
			GetLFGMode(LE_LFG_CATEGORY_SCENARIO) or
			GetLFGMode(LE_LFG_CATEGORY_FLEXRAID) then
			return true
		end
	end

	-- Check if player is in combat
	function LeaPlusLC:PlayerInCombat()
		if (UnitAffectingCombat("player")) then
			LeaPlusLC:Print("You cannot do that in combat.")
			return true
		end
	end

	--  Hide panel and pages
	function LeaPlusLC:HideFrames()

		-- Hide option pages
		for i = 0, LeaPlusLC["NumberOfPages"] do
			if LeaPlusLC["Page"..i] then
				LeaPlusLC["Page"..i]:Hide();
			end;
		end

		-- Hide options panel
		LeaPlusLC["PageF"]:Hide();

	end

	-- Find out if Leatrix Plus is showing (main panel or config panel)
	function LeaPlusLC:IsPlusShowing()
		if LeaPlusLC["PageF"]:IsShown() then return true end
		for k, v in pairs(LeaConfigList) do
			if v:IsShown() then
				return true
			end
		end
	end

	-- Check if a name is in your friends list or guild
	function LeaPlusLC:FriendCheck(name)

		-- Update friends list
		ShowFriends()

		-- Check character friends
		for i = 1, GetNumFriends() do
			-- Return true if name matches with or without realm
			if name == GetFriendInfo(i) or name == strsplit("-", GetFriendInfo(i), 2) then
				return true
			end
		end

		-- Get realm name or set to player's own realm (same realm does not return realm)
		local void, myRealm = UnitFullName(name)
		if not myRealm or myRealm == "" then void, myRealm = UnitFullName("player") end

		-- Add realm name to character name
		if not string.find(name, "-") then
			name = name .. "-" .. myRealm
		end

		-- Check Battle.net friends
		local numfriends = BNGetNumFriends()
		for i = 1, numfriends do
			local numtoons = BNGetNumFriendGameAccounts(i)
			for j = 1, numtoons do
				local void, toon, client, realm = BNGetFriendGameAccountInfo(i, j)
				local toonname = toon .. "-" ..realm
				if client == "WoW" and toonname == name then
					return true
				end
			end
		end

		-- Check guild roster (new members may need to press J to refresh roster)
		local gCount = GetNumGuildMembers()
		for i = 1, gCount do
			local gName, void, void, void, void, void, void, void, gOnline, void, void, void, void, gMobile = GetGuildRosterInfo(i)
			if gOnline and not gMobile then
				local gCompare = gName
				if not string.find(gName, "-") then
					gCompare = gName .. "-" .. myRealm
				end
				if gCompare == name then
					return true
				end
			end
		end

	end

	-- Convert color code (from RGB or RGB Percent to Hex or Hex Percent and vice versa)
	function LeaPlusLC:ConvertColor(r, g, b)
		if r and g and b then
			LeaPlusLC:Print("Source: |cffffffff" .. r .. " " .. g .. " " .. b .. " ")
			-- Source is RGB or RGB Percent
			local r = r <= 255 and r >= 0 and r or 0
			local g = g <= 255 and g >= 0 and g or 0
			local b = b <= 255 and b >= 0 and b or 0
			-- RGB Percent to Hex
			LeaPlusLC:Print("RGB Percent to Hex: |cffffffff" .. strupper(string.format("%02x%02x%02x", r * 255, g * 255, b * 255)))
			-- RGB to Hex
			LeaPlusLC:Print("RGB to Hex: |cffffffff" .. strupper(string.format("%02x%02x%02x", r, g, b)))
		else
			LeaPlusLC:Print("Source: |cffffffff" .. r)
			-- Source is Hex
			local rhex, ghex, bhex = string.sub(r, 1, 2), string.sub(r, 3, 4), string.sub(r, 5, 6)
			-- Hex to RGB Percent
			LeaPlusLC:Print("Hex to RGB Percent: |cffffffff" .. string.format("%.2f", tonumber(rhex, 16) / 255) ..  "  " .. string.format("%.2f", tonumber(ghex, 16) / 255) .. "  " .. string.format("%.2f", tonumber(bhex, 16) / 255))
			-- Hex to RGB
			LeaPlusLC:Print("Hex to RGB: |cffffffff" .. tonumber(rhex, 16) .. "  " .. tonumber(ghex, 16) .. "  " .. tonumber(bhex, 16))
		end
	end

----------------------------------------------------------------------
--	L02: Locks
----------------------------------------------------------------------

	-- Function to set lock state for configuration buttons
	function LeaPlusLC:LockOption(option, item, reloadreq)
		if reloadreq then
			-- Option change requires UI reload
			if LeaPlusLC[option] ~= LeaPlusDB[option] or LeaPlusLC[option] == "Off" then
				LeaPlusLC:LockItem(LeaPlusCB[item], true)
			else
				LeaPlusLC:LockItem(LeaPlusCB[item], false)
			end
		else
			-- Option change does not require UI reload
			if LeaPlusLC[option] == "Off" then
				LeaPlusLC:LockItem(LeaPlusCB[item], true)
			else
				LeaPlusLC:LockItem(LeaPlusCB[item], false)
			end
		end
	end

--	Set lock state for configuration buttons
	function LeaPlusLC:SetDim()
		LeaPlusLC:LockOption("AutoRepairGear", "AutoRepairBtn", false)			-- Repair automatically
		LeaPlusLC:LockOption("MailFontChange", "MailTextBtn", true)				-- Resize mail text
		LeaPlusLC:LockOption("QuestFontChange", "QuestTextBtn", true)			-- Resize quest text
		LeaPlusLC:LockOption("MinimapMod", "ModMinimapBtn", true)				-- Customise minimap
		LeaPlusLC:LockOption("TipModEnable", "MoveTooltipButton", true)			-- Manage tooltip
		LeaPlusLC:LockOption("ShowCooldowns", "CooldownsButton", true)			-- Show cooldowns
		LeaPlusLC:LockOption("FrmEnabled", "MoveFramesButton", true)			-- Manage frames
		LeaPlusLC:LockOption("ShowPlayerChain", "ModPlayerChain", true)			-- Show player chain
		LeaPlusLC:LockOption("ViewPortEnable", "ModViewportBtn", true)			-- Enable viewport
	end

----------------------------------------------------------------------
--	L03: Restarts
----------------------------------------------------------------------

	-- Set the reload button state
	function LeaPlusLC:ReloadCheck()

		-- Chat
		if	(LeaPlusLC["UseEasyChatResizing"]	~= LeaPlusDB["UseEasyChatResizing"])	-- Use easy resizing
		or	(LeaPlusLC["NoCombatLogTab"]		~= LeaPlusDB["NoCombatLogTab"])			-- Hide the combat log
		or	(LeaPlusLC["NoChatButtons"]			~= LeaPlusDB["NoChatButtons"])			-- Hide chat buttons
		or	(LeaPlusLC["NoSocialButton"]		~= LeaPlusDB["NoSocialButton"])			-- Hide social button
		or	(LeaPlusLC["UnclampChat"]			~= LeaPlusDB["UnclampChat"])			-- Unclamp chat frame
		or	(LeaPlusLC["MoveChatEditBoxToTop"]	~= LeaPlusDB["MoveChatEditBoxToTop"])	-- Move editbox to top
		or	(LeaPlusLC["NoStickyChat"]			~= LeaPlusDB["NoStickyChat"])			-- Disable sticky chat
		or	(LeaPlusLC["UseArrowKeysInChat"]	~= LeaPlusDB["UseArrowKeysInChat"])		-- Use arrow keys in chat
		or	(LeaPlusLC["NoChatFade"]			~= LeaPlusDB["NoChatFade"])				-- Disable chat fade
		or	(LeaPlusLC["RecentChatWindow"]		~= LeaPlusDB["RecentChatWindow"])		-- Recent chat window
		or	(LeaPlusLC["MaxChatHstory"]			~= LeaPlusDB["MaxChatHstory"])			-- Increase chat history

		-- Text
		or	(LeaPlusLC["HideErrorMessages"]		~= LeaPlusDB["HideErrorMessages"])		-- Hide error messages
		or	(LeaPlusLC["NoHitIndicators"]		~= LeaPlusDB["NoHitIndicators"])		-- Hide portrait text
		or	(LeaPlusLC["HideCraftedNames"]		~= LeaPlusDB["HideCraftedNames"])		-- Hide crafted names
		or	(LeaPlusLC["HideZoneText"]			~= LeaPlusDB["HideZoneText"])			-- Hide zone text
		or	(LeaPlusLC["MailFontChange"]		~= LeaPlusDB["MailFontChange"])			-- Resize mail text
		or	(LeaPlusLC["QuestFontChange"]		~= LeaPlusDB["QuestFontChange"])		-- Resize quest text

		-- Interface
		or	(LeaPlusLC["MinimapMod"]			~= LeaPlusDB["MinimapMod"])				-- Customise minimap
		or	(LeaPlusLC["TipModEnable"]			~= LeaPlusDB["TipModEnable"])			-- Manage tooltip
		or	(LeaPlusLC["EnhanceDressup"]		~= LeaPlusDB["EnhanceDressup"])			-- Enhance dressup
		or	(LeaPlusLC["ShowVolume"]			~= LeaPlusDB["ShowVolume"])				-- Show volume slider
		or	(LeaPlusLC["AhExtras"]				~= LeaPlusDB["AhExtras"])				-- Show auction controls
		or	(LeaPlusLC["ShowCooldowns"]			~= LeaPlusDB["ShowCooldowns"])			-- Show cooldowns
		or	(LeaPlusLC["DurabilityStatus"]		~= LeaPlusDB["DurabilityStatus"])		-- Show durability status
		or	(LeaPlusLC["ShowPetSaveBtn"]		~= LeaPlusDB["ShowPetSaveBtn"])			-- Show pet save button
		or	(LeaPlusLC["ShowWowheadLinks"]		~= LeaPlusDB["ShowWowheadLinks"])		-- Show Wowhead links

		-- Frames
		or	(LeaPlusLC["FrmEnabled"]			~= LeaPlusDB["FrmEnabled"])				-- Manage frames
		or	(LeaPlusLC["ClassColFrames"]		~= LeaPlusDB["ClassColFrames"])			-- Class colored frames
		or	(LeaPlusLC["ShowPlayerChain"]		~= LeaPlusDB["ShowPlayerChain"])		-- Show player chain
		or	(LeaPlusLC["ShowRaidToggle"]		~= LeaPlusDB["ShowRaidToggle"])			-- Show raid toggle button
		or	(LeaPlusLC["CombatPlates"]			~= LeaPlusDB["CombatPlates"])			-- Combat plates
		or	(LeaPlusLC["NoAlerts"]				~= LeaPlusDB["NoAlerts"])				-- Hide alerts
		or	(LeaPlusLC["HideBodyguard"]			~= LeaPlusDB["HideBodyguard"])			-- Hide bodyguard gossip
		or	(LeaPlusLC["HideTalkingFrame"]		~= LeaPlusDB["HideTalkingFrame"])		-- Hide talking frame
		or	(LeaPlusLC["HideCleanupBtns"]		~= LeaPlusDB["HideCleanupBtns"])		-- Hide clean-up buttons
		or	(LeaPlusLC["HideBossBanner"]		~= LeaPlusDB["HideBossBanner"])			-- Hide boss banner
		or	(LeaPlusLC["HideLevelUpDisplay"]	~= LeaPlusDB["HideLevelUpDisplay"])		-- Hide level-up display
		or	(LeaPlusLC["NoGryphons"]			~= LeaPlusDB["NoGryphons"])				-- Hide gryphons
		or	(LeaPlusLC["NoClassBar"]			~= LeaPlusDB["NoClassBar"])				-- Hide stance bar
		or	(LeaPlusLC["NoCommandBar"]			~= LeaPlusDB["NoCommandBar"])			-- Hide order hall bar

		-- System
		or	(LeaPlusLC["ViewPortEnable"]		~= LeaPlusDB["ViewPortEnable"])			-- Enable viewport
		or	(LeaPlusLC["NoRestedEmotes"]		~= LeaPlusDB["NoRestedEmotes"])			-- Silence rested emotes
		or	(LeaPlusLC["NoBagAutomation"]		~= LeaPlusDB["NoBagAutomation"])		-- Disable bag automation
		or	(LeaPlusLC["NoPetAutomation"]		~= LeaPlusDB["NoPetAutomation"])		-- Disable pet automation
		or	(LeaPlusLC["CharAddonList"]			~= LeaPlusDB["CharAddonList"])			-- Show character addons
		or	(LeaPlusLC["FasterLooting"]			~= LeaPlusDB["FasterLooting"])			-- Faster auto loot
		or	(LeaPlusLC["FasterMovieSkip"]		~= LeaPlusDB["FasterMovieSkip"])		-- Faster movie skip
		or	(LeaPlusLC["LockoutSharing"]		~= LeaPlusDB["LockoutSharing"])			-- Lockout sharing

		-- Settings
		or	(LeaPlusLC["EnableHotkey"]			~= LeaPlusDB["EnableHotkey"])			-- Enable hotkey

		then
			-- Enable the reload button
			LeaPlusLC:LockItem(LeaPlusCB["ReloadUIButton"], false)
			LeaPlusCB["ReloadUIButton"].f:Show()
		else
			-- Disable the reload button
			LeaPlusLC:LockItem(LeaPlusCB["ReloadUIButton"], true)
			LeaPlusCB["ReloadUIButton"].f:Hide()
		end

	end

----------------------------------------------------------------------
--	L20: Live
----------------------------------------------------------------------

	function LeaPlusLC:Live()

		----------------------------------------------------------------------
		--	Automatically accept Dungeon Finder queue requests
		----------------------------------------------------------------------

		if LeaPlusLC["AutoConfirmRole"] == "On" then
			LFDRoleCheckPopupAcceptButton:SetScript("OnShow", function()
				local leader = ""
				for i=1, GetNumSubgroupMembers() do 
					if (UnitIsGroupLeader("party"..i)) then 
						leader = UnitName("party"..i);
						break;
					end
				end
				if (LeaPlusLC:FriendCheck(leader)) then
					LFDRoleCheckPopupAcceptButton:Click();
				end
			end)
		else
			LFDRoleCheckPopupAcceptButton:SetScript("OnShow", nil)
		end

		----------------------------------------------------------------------
		--	Invite from whispers
		----------------------------------------------------------------------

		if LeaPlusLC["InviteFromWhisper"] == "On" then
			LpEvt:RegisterEvent("CHAT_MSG_WHISPER");
			LpEvt:RegisterEvent("CHAT_MSG_BN_WHISPER");
		else
			LpEvt:UnregisterEvent("CHAT_MSG_WHISPER");
			LpEvt:UnregisterEvent("CHAT_MSG_BN_WHISPER");
		end

		----------------------------------------------------------------------
		--	Block duels
		----------------------------------------------------------------------

		if LeaPlusLC["NoDuelRequests"] == "On" then
			LpEvt:RegisterEvent("DUEL_REQUESTED");
		else
			LpEvt:UnregisterEvent("DUEL_REQUESTED");
		end

		----------------------------------------------------------------------
		--	Block pet battle duels
		----------------------------------------------------------------------

		if LeaPlusLC["NoPetDuels"] == "On" then
			LpEvt:RegisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED");
		else
			LpEvt:UnregisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED");
		end

		----------------------------------------------------------------------
		--	Block party invites and Party from friends
		----------------------------------------------------------------------

		if LeaPlusLC["NoPartyInvites"] == "On" or LeaPlusLC["AcceptPartyFriends"] == "On" then
			LpEvt:RegisterEvent("PARTY_INVITE_REQUEST");
		else
			LpEvt:UnregisterEvent("PARTY_INVITE_REQUEST");
		end

		----------------------------------------------------------------------
		--	Release in PvP
		----------------------------------------------------------------------

		if LeaPlusLC["AutoReleasePvP"] == "On" then
			LpEvt:RegisterEvent("PLAYER_DEAD");
		else
			LpEvt:UnregisterEvent("PLAYER_DEAD");
		end

		----------------------------------------------------------------------
		--	Accept resurrection
		----------------------------------------------------------------------

		if LeaPlusLC["AutoAcceptRes"] == "On" then
			LpEvt:RegisterEvent("RESURRECT_REQUEST");
		else
			LpEvt:UnregisterEvent("RESURRECT_REQUEST");
		end

		----------------------------------------------------------------------
		--	Automatic summon
		----------------------------------------------------------------------

		if LeaPlusLC["AutoAcceptSummon"] == "On" then
			LpEvt:RegisterEvent("CONFIRM_SUMMON");
		else
			LpEvt:UnregisterEvent("CONFIRM_SUMMON");
		end

		----------------------------------------------------------------------
		--	Disable loot warnings
		----------------------------------------------------------------------

		if LeaPlusLC["NoConfirmLoot"] == "On" then
			LpEvt:RegisterEvent("CONFIRM_LOOT_ROLL")
			LpEvt:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
			LpEvt:RegisterEvent("LOOT_BIND_CONFIRM")
			LpEvt:RegisterEvent("MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL")
			LpEvt:RegisterEvent("MAIL_LOCK_SEND_ITEMS")
		else
			LpEvt:UnregisterEvent("CONFIRM_LOOT_ROLL")
			LpEvt:UnregisterEvent("CONFIRM_DISENCHANT_ROLL")
			LpEvt:UnregisterEvent("LOOT_BIND_CONFIRM")
			LpEvt:UnregisterEvent("MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL")
			LpEvt:UnregisterEvent("MAIL_LOCK_SEND_ITEMS")
		end

	end

----------------------------------------------------------------------
--	L30: Isolated
----------------------------------------------------------------------

	function LeaPlusLC:Isolated()

		----------------------------------------------------------------------
		-- Faster movie skip
		----------------------------------------------------------------------

		if LeaPlusLC["FasterMovieSkip"] == "On" then

			-- Allow space bar, escape key and enter key to cancel cinematic without confirmation
			CinematicFrame:HookScript("OnKeyDown", function(self, key)
				if key == "ESCAPE" then
					if CinematicFrame:IsShown() and CinematicFrame.closeDialog and CinematicFrameCloseDialogConfirmButton then
						CinematicFrameCloseDialog:Hide()
					end
				end
			end)
			CinematicFrame:HookScript("OnKeyUp", function(self, key)
				if key == "SPACE" or key == "ESCAPE" or key == "ENTER" then
					if CinematicFrame:IsShown() and CinematicFrame.closeDialog and CinematicFrameCloseDialogConfirmButton then
						CinematicFrameCloseDialogConfirmButton:Click()
					end
				end
			end)
			MovieFrame:HookScript("OnKeyUp", function(self, key)
				if key == "SPACE" or key == "ESCAPE" or key == "ENTER" then
					if MovieFrame:IsShown() and MovieFrame.CloseDialog and MovieFrame.CloseDialog.ConfirmButton then
						MovieFrame.CloseDialog.ConfirmButton:Click()
					end
				end
			end)

		end

		----------------------------------------------------------------------
		-- Unclamp chat frame
		----------------------------------------------------------------------

		if LeaPlusLC["UnclampChat"] == "On" then

			-- Process normal and existing chat frames on startup
			for i = 1, 50 do
				if _G["ChatFrame" .. i] then 
					_G["ChatFrame" .. i]:SetClampRectInsets(0, 0, 0, 0);
				end
			end

			-- Process new chat frames and combat log
			hooksecurefunc("FloatingChatFrame_UpdateBackgroundAnchors", function(self)
				self:SetClampRectInsets(0, 0, 0, 0);
			end)

			-- Process temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function()
				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then
					_G[cf]:SetClampRectInsets(0, 0, 0, 0);
				end
			end)

		end

		----------------------------------------------------------------------
		-- Wowhead Links
		----------------------------------------------------------------------

		if LeaPlusLC["ShowWowheadLinks"] == "On" then

			-- Get localised Wowhead URL
			local wowheadLoc
			if GameLocale == "deDE" then wowheadLoc = "de.wowhead.com"
			elseif GameLocale == "esMX" then wowheadLoc = "es.wowhead.com"
			elseif GameLocale == "esES" then wowheadLoc = "es.wowhead.com"
			elseif GameLocale == "frFR" then wowheadLoc = "fr.wowhead.com"
			elseif GameLocale == "itIT" then wowheadLoc = "it.wowhead.com"
			elseif GameLocale == "ptBR" then wowheadLoc = "pt.wowhead.com"
			elseif GameLocale == "ruRU" then wowheadLoc = "ru.wowhead.com"
			elseif GameLocale == "koKR" then wowheadLoc = "ko.wowhead.com"
			elseif GameLocale == "zhCN" then wowheadLoc = "cn.wowhead.com"
			elseif GameLocale == "zhTW" then wowheadLoc = "cn.wowhead.com"
			else							 wowheadLoc = "wowhead.com"
			end

			----------------------------------------------------------------------
			-- Achievements frame
			----------------------------------------------------------------------

			-- Achievement link function
			local function DoWowheadAchievementFunc()

				-- Create editbox
				local aEB = CreateFrame("EditBox", nil, AchievementFrame)
				aEB:ClearAllPoints()
				aEB:SetPoint("BOTTOMRIGHT", -50, 1)
				aEB:SetHeight(16)
				aEB:SetFontObject("GameFontNormalSmall")
				aEB:SetBlinkSpeed(0)
				aEB:SetJustifyH("RIGHT")
				aEB:SetAutoFocus(false)
				aEB:EnableKeyboard(false)
				aEB:SetHitRectInsets(90, 0, 0, 0)
				aEB:SetScript("OnKeyDown", function() end)
				aEB:SetScript("OnMouseUp", function()
					if aEB:IsMouseOver() then 
						aEB:HighlightText()
					else
						aEB:HighlightText(0, 0)
					end
				end)

				-- Create hidden font string (used for setting width of editbox)
				aEB.z = aEB:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
				aEB.z:Hide()

				-- Store last link in case editbox is cleared
				local lastAchievementLink

				-- Function to set editbox value
				hooksecurefunc("AchievementFrameAchievements_SelectButton", function(self)
					local achievementID = self.id or nil
					if achievementID then
						-- Set editbox text
						aEB:SetText("https://" .. wowheadLoc .. "/achievement=" .. achievementID)
						lastAchievementLink = aEB:GetText()
						-- Set hidden fontstring then resize editbox to match
						aEB.z:SetText(aEB:GetText())
						aEB:SetWidth(aEB.z:GetStringWidth() + 90)
						-- Get achievement title for tooltip
						local achievementLink = GetAchievementLink(self.id)
						if achievementLink then
							aEB.tiptext = achievementLink:match("%[(.-)%]") .. "|n" .. L["Press CTRL/C to copy."]
						end
						-- Show the editbox
						aEB:Show()
					end
				end)

				-- Create tooltip
				aEB:HookScript("OnEnter", function()
					aEB:HighlightText()
					aEB:SetFocus()
					GameTooltip:SetOwner(aEB, "ANCHOR_TOP", 0, 10)
					GameTooltip:SetText(aEB.tiptext, nil, nil, nil, nil, true)
					GameTooltip:Show()
				end)

				aEB:HookScript("OnLeave", function()
					-- Set link text again if it's changed since it was set
					if aEB:GetText() ~= lastAchievementLink then aEB:SetText(lastAchievementLink) end
					aEB:HighlightText(0, 0)
					aEB:ClearFocus()
					GameTooltip:Hide()
				end)

				-- Hide editbox when achievement is deselected
				hooksecurefunc("AchievementFrameAchievements_ClearSelection", function(self) aEB:Hide()	end)
				hooksecurefunc("AchievementCategoryButton_OnClick", function(self) aEB:Hide() end)

			end

			-- Run function when achievement UI is loaded
			if IsAddOnLoaded("Blizzard_AchievementUI") then
				DoWowheadAchievementFunc()
			else
				local waitAchievementsFrame = CreateFrame("FRAME")
				waitAchievementsFrame:RegisterEvent("ADDON_LOADED")
				waitAchievementsFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_AchievementUI" then
						DoWowheadAchievementFunc()
						waitAchievementsFrame:UnregisterAllEvents()
					end
				end)
			end

			----------------------------------------------------------------------
			-- World map frame
			----------------------------------------------------------------------

			-- Hide the title text
			WorldMapFrameTitleText:Hide()

			-- Create editbox
			local mEB = CreateFrame("EditBox", nil, WorldMapFrame.BorderFrame)
			mEB:ClearAllPoints()
			mEB:SetPoint("TOPLEFT", 100, -4)
			mEB:SetHeight(16)
			mEB:SetFontObject("GameFontNormal")
			mEB:SetBlinkSpeed(0)
			mEB:SetAutoFocus(false)
			mEB:EnableKeyboard(false)
			mEB:SetHitRectInsets(0, 90, 0, 0)
			mEB:SetScript("OnKeyDown", function() end)
			mEB:SetScript("OnMouseUp", function()
				if mEB:IsMouseOver() then 
					mEB:HighlightText()
				else
					mEB:HighlightText(0, 0)
				end
			end)

			-- Create hidden font string (used for setting width of editbox)
			mEB.z = mEB:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
			mEB.z:Hide()

			-- Function to set editbox value
			local function SetQuestInBox()
				local questID
				if QuestMapFrame.DetailsFrame:IsShown() then
					-- Get quest ID from currently showing quest in details panel
					questID = QuestMapFrame_GetDetailQuestID()
				else
					-- Get quest ID from currently selected quest on world map
					questID = GetSuperTrackedQuestID()
				end
				if questID then
					-- Hide editbox if quest ID is invalid
					if questID == 0 then mEB:Hide() else mEB:Show() end
					-- Set editbox text
					mEB:SetText("https://" .. wowheadLoc .. "/quest=" .. questID)
					-- Set hidden fontstring then resize editbox to match
					mEB.z:SetText(mEB:GetText())
					mEB:SetWidth(mEB.z:GetStringWidth() + 90)
					-- Get quest title for tooltip
					local questLink = GetQuestLink(questID) or nil
					if questLink then
						mEB.tiptext = questLink:match("%[(.-)%]") .. "|n" .. L["Press CTRL/C to copy."]
					else
						mEB.tiptext = ""
						if mEB:IsMouseOver() and WorldMapTooltip:IsShown() then WorldMapTooltip:Hide() end
					end
				end
			end

			-- Set URL when super tracked quest changes and on startup
			mEB:RegisterEvent("SUPER_TRACKED_QUEST_CHANGED")
			mEB:SetScript("OnEvent", SetQuestInBox)
			SetQuestInBox()

			-- Set URL when quest details frame is shown or hidden
			hooksecurefunc("QuestMapFrame_ShowQuestDetails", SetQuestInBox)
			hooksecurefunc("QuestMapFrame_CloseQuestDetails", SetQuestInBox)

			-- Create tooltip
			mEB:HookScript("OnEnter", function()
				mEB:HighlightText()
				mEB:SetFocus()
				WorldMapTooltip:SetOwner(mEB, "ANCHOR_BOTTOM", 0, -10)
				WorldMapTooltip:SetText(mEB.tiptext, nil, nil, nil, nil, true)
				WorldMapTooltip:Show()
			end)

			mEB:HookScript("OnLeave", function()
				mEB:HighlightText(0, 0)
				mEB:ClearFocus()
				WorldMapTooltip:Hide()
				SetQuestInBox()
			end)

		end

		----------------------------------------------------------------------
		-- Enhance dressup
		----------------------------------------------------------------------

		if LeaPlusLC["EnhanceDressup"] == "On" then

			----------------------------------------------------------------------
			-- Nude and tabard buttons
			----------------------------------------------------------------------

			-- Add buttons to main dressup frames
			LeaPlusLC:CreateButton("DressUpNudeBtn", DressUpFrame, "Nude", "BOTTOMLEFT", 106, 79, 80, 22, false, "")
			LeaPlusCB["DressUpNudeBtn"]:ClearAllPoints()
			LeaPlusCB["DressUpNudeBtn"]:SetPoint("RIGHT", DressUpFrameResetButton, "LEFT", 0, 0)
			LeaPlusCB["DressUpNudeBtn"]:SetScript("OnClick", function()
				DressUpFrameResetButton:Click() -- Done first in case any slots refuse to clear
				for i = 1, 19 do
					DressUpModel:UndressSlot(i) -- Done this way to prevent issues with Undress
				end
			end)

			LeaPlusLC:CreateButton("DressUpTabBtn", DressUpFrame, "Tabard", "BOTTOMLEFT", 26, 79, 80, 22, false, "")
			LeaPlusCB["DressUpTabBtn"]:ClearAllPoints()
			LeaPlusCB["DressUpTabBtn"]:SetPoint("RIGHT", LeaPlusCB["DressUpNudeBtn"], "LEFT", 0, 0)
			LeaPlusCB["DressUpTabBtn"]:SetScript("OnClick", function()
				DressUpModel:UndressSlot(19)
			end)

			-- Only show dressup buttons if its a player (reset button will show too)
			hooksecurefunc(DressUpFrameResetButton, "Show", function()
				LeaPlusCB["DressUpNudeBtn"]:Show()
				LeaPlusCB["DressUpTabBtn"]:Show()
			end)

			hooksecurefunc(DressUpFrameResetButton, "Hide", function()
				LeaPlusCB["DressUpNudeBtn"]:Hide()
				LeaPlusCB["DressUpTabBtn"]:Hide()
			end)

			local BtnStrata, BtnLevel = SideDressUpModelResetButton:GetFrameStrata(), SideDressUpModelResetButton:GetFrameLevel()

			-- Add buttons to auction house dressup frame
			LeaPlusLC:CreateButton("DressUpSideBtn", SideDressUpFrame, "Tabard", "BOTTOMLEFT", 14, 20, 60, 22, false, "")
			LeaPlusCB["DressUpSideBtn"]:SetFrameStrata(BtnStrata);
			LeaPlusCB["DressUpSideBtn"]:SetFrameLevel(BtnLevel);
			LeaPlusCB["DressUpSideBtn"]:SetScript("OnClick", function()
				SideDressUpModel:UndressSlot(19)
			end)

			LeaPlusLC:CreateButton("DressUpSideNudeBtn", SideDressUpFrame, "Nude", "BOTTOMRIGHT", -18, 20, 60, 22, false, "")
			LeaPlusCB["DressUpSideNudeBtn"]:SetFrameStrata(BtnStrata);
			LeaPlusCB["DressUpSideNudeBtn"]:SetFrameLevel(BtnLevel);
			LeaPlusCB["DressUpSideNudeBtn"]:SetScript("OnClick", function()
				SideDressUpModelResetButton:Click() -- Done first in case any slots refuse to clear
				for i = 1, 19 do
					SideDressUpModel:UndressSlot(i) -- Done this way to prevent issues with Undress
				end
			end)

			-- Only show side dressup buttons if its a player (reset button will show too)
			hooksecurefunc(SideDressUpModelResetButton, "Show", function()
				LeaPlusCB["DressUpSideBtn"]:Show()
				LeaPlusCB["DressUpSideNudeBtn"]:Show()
			end)

			hooksecurefunc(SideDressUpModelResetButton, "Hide", function()
				LeaPlusCB["DressUpSideBtn"]:Hide()
				LeaPlusCB["DressUpSideNudeBtn"]:Hide()
			end)

			----------------------------------------------------------------------
			-- Disable special animations
			----------------------------------------------------------------------

			-- Function to set animations
			local function SetupAnimations()
				DressUpModel:SetAnimation(255)
				SideDressUpModel:SetAnimation(255)
			end

			-- Dressing room
			hooksecurefunc("DressUpFrame_Show", SetupAnimations)
			DressUpFrame.ResetButton:HookScript("OnClick", SetupAnimations)
			-- Auction house dressing room
			hooksecurefunc(SideDressUpModel, "SetUnit", SetupAnimations)
			SideDressUpModelResetButton:HookScript("OnClick", SetupAnimations)

			----------------------------------------------------------------------
			-- Controls
			----------------------------------------------------------------------

			-- Function to hide controls
			local function SetupControls()
				CharacterModelFrameControlFrame:Hide()
				DressUpModelControlFrame:Hide()
				SideDressUpModelControlFrame:Hide()
			end

			-- Hide controls for character sheet, dressing room and auction house dressing room
			CharacterModelFrameControlFrame:HookScript("OnShow", SetupControls)
			DressUpModelControlFrame:HookScript("OnShow", SetupControls)
			SideDressUpModelControlFrame:HookScript("OnShow", SetupControls)

			----------------------------------------------------------------------
			-- Wardrobe and inspect system
			----------------------------------------------------------------------

			-- Wardrobe (used by transmogrifier NPC)
			local function DoBlizzardCollectionsFunc()
				-- Hide positioning controls
				WardrobeTransmogFrameControlFrame:HookScript("OnShow", WardrobeTransmogFrameControlFrame.Hide)
				-- Disable special animations
				hooksecurefunc(WardrobeTransmogFrame.Model, "SetUnit", function()
					WardrobeTransmogFrame.Model:SetAnimation(255)
				end)
			end

			if IsAddOnLoaded("Blizzard_Collections") then
				DoBlizzardCollectionsFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_Collections" then
						DoBlizzardCollectionsFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			-- Inspect System
			local function DoInspectSystemFunc()
				-- Hide positioning controls
				InspectModelFrameControlFrame:HookScript("OnShow", InspectModelFrameControlFrame.Hide)
			end

			if IsAddOnLoaded("Blizzard_InspectUI") then
				DoInspectSystemFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_InspectUI" then
						DoInspectSystemFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

		end

		----------------------------------------------------------------------
		-- Automate gossip (no reload required)
		----------------------------------------------------------------------

		do

			-- Function to skip gossip
			local function SkipGossip()
				if not IsAltKeyDown() then return end
				local void, gossipType = GetGossipOptions()
				if gossipType and gossipType == "gossip" then
					SelectGossipOption(1)
				end
			end

			-- Create gossip event frame
			local gossipFrame = CreateFrame("FRAME")

			-- Function to setup events
			local function SetupEvents()
				if LeaPlusLC["AutomateGossip"] == "On" then
					gossipFrame:RegisterEvent("GOSSIP_SHOW")
				else
					gossipFrame:UnregisterEvent("GOSSIP_SHOW")
				end
			end

			-- Setup events when option is clicked and on startup (if option is enabled)
			LeaPlusCB["AutomateGossip"]:HookScript("OnClick", SetupEvents)
			if LeaPlusLC["AutomateGossip"] == "On" then SetupEvents() end

			-- Event handler
			gossipFrame:SetScript("OnEvent", function()
				-- Special treatment for specific NPCs
				local npcGuid = UnitGUID("target") or nil
				if npcGuid then
					local void, void, void, void, void, npcID = strsplit("-", npcGuid)
					if npcID then
						-- Open rogue doors in Dalaran (Broken Isles) automatically
						if npcID == "96782"	-- Lucian Trias
						or npcID == "93188"	-- Mongar
						or npcID == "97004"	-- "Red" Jack Findle
						then
							SkipGossip()
							return
						end
					end
				end
				-- Process gossip
				if GetNumGossipOptions() == 1 and GetNumGossipAvailableQuests() == 0 and GetNumGossipActiveQuests() == 0 then
					SkipGossip()
				end
			end)

		end

		----------------------------------------------------------------------
		--	Hide order hall bar
		----------------------------------------------------------------------

		if LeaPlusLC["NoCommandBar"] == "On" then

			-- Function to hide the order hall bar
			local function HideCommandBar()
				OrderHallCommandBar:HookScript("OnShow", function()
					OrderHallCommandBar:Hide()
				end)
			end

			-- Run function when Blizzard addon has loaded
			if IsAddOnLoaded("Blizzard_OrderHallUI") then
				HideCommandBar()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_OrderHallUI" then
						HideCommandBar()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

		end

		----------------------------------------------------------------------
		--	Disable pet automation
		----------------------------------------------------------------------

		if LeaPlusLC["NoPetAutomation"] == "On" then

			-- Create frame to watch for combat
			local petCombat = CreateFrame("FRAME")
			local petTicker

			-- Function to dismiss pet
			local function DismissPetTimerFunc()
				if UnitAffectingCombat("player") then
					-- Player is in combat so cancel ticker and schedule it for when combat ends
					if petTicker then petTicker:Cancel() end
					petCombat:RegisterEvent("PLAYER_REGEN_ENABLED")
				else
					-- Player is not in combat so attempt to dismiss pet
					local summonedPet = C_PetJournal.GetSummonedPetGUID()
					if summonedPet then
						C_PetJournal.SummonPetByGUID(summonedPet)
					end
				end
			end

			hooksecurefunc(C_PetJournal, "SetPetLoadOutInfo", function()
				-- Cancel existing ticker if one already exists
				if petTicker then petTicker:Cancel() end
				-- Check for combat
				if UnitAffectingCombat("player") then
					-- Player is in combat so schedule ticker for when combat ends
					petCombat:RegisterEvent("PLAYER_REGEN_ENABLED")
				else
					-- Player is not in combat so run ticker now
					petTicker = C_Timer.NewTicker(0.5, DismissPetTimerFunc, 15)
				end
			end)

			-- Script for when combat ends
			petCombat:SetScript("OnEvent", function()
				-- Combat has ended so run ticker now
				petTicker = C_Timer.NewTicker(0.5, DismissPetTimerFunc, 15)
				petCombat:UnregisterEvent("PLAYER_REGEN_ENABLED")
			end)

		end

		----------------------------------------------------------------------
		--	Show pet save button
		----------------------------------------------------------------------

		if LeaPlusLC["ShowPetSaveBtn"] == "On" then

			local function MakePetSystem()

				-- Create panel
				local pFrame = CreateFrame("Frame", nil, PetJournal)
				pFrame:ClearAllPoints()
				pFrame:SetPoint("TOPLEFT", PetJournalLoadoutBorder, "TOPLEFT", 4, 40)
				pFrame:SetSize(PetJournalLoadoutBorder:GetWidth() -10, 16)
				pFrame:Hide()
				pFrame:SetFrameLevel(5000)

				-- Add background color
				pFrame.t = pFrame:CreateTexture(nil, "BACKGROUND")
				pFrame.t:SetAllPoints()
				pFrame.t:SetColorTexture(0.05, 0.05, 0.05, 0.7)

				-- Create editbox
				local petEB = CreateFrame("EditBox", nil, pFrame)
				petEB:SetAllPoints()
				petEB:SetTextInsets(2, 2, 2, 2)
				petEB:SetFontObject("GameFontNormal")
				petEB:SetTextColor(1.0, 1.0, 1.0, 1)
				petEB:SetBlinkSpeed(0)
				petEB:SetAltArrowKeyMode(true)

				-- Prevent changes
				petEB:SetScript("OnEscapePressed", function() pFrame:Hide() end)
				petEB:SetScript("OnEnterPressed", petEB.HighlightText)
				petEB:SetScript("OnMouseDown", petEB.ClearFocus)
				petEB:SetScript("OnMouseUp", petEB.HighlightText)

				-- Create tooltip
				petEB.tiptext = L["This command will assign your current pet team and selected abilities.|n|nPress CTRL/C to copy the command then paste it into a macro or chat window with CTRL/V."]
				petEB:HookScript("OnEnter", function()
					GameTooltip:SetOwner(petEB, "ANCHOR_TOP")
					GameTooltip:SetText(petEB.tiptext, nil, nil, nil, nil, true)
				end)
				petEB:HookScript("OnLeave", GameTooltip_Hide)

				-- Function to get pet data and build macro
				local function RefreshPets()
					-- Get pet data
					local p1, p1a, p1b, p1c = C_PetJournal.GetPetLoadOutInfo(1)
					local p2, p2a, p2b, p2c = C_PetJournal.GetPetLoadOutInfo(2)
					local p3, p3a, p3b, p3c = C_PetJournal.GetPetLoadOutInfo(3)
					if p1 and p1a and p1b and p1c and p2 and p2a and p2b and p2c and p3 and p3a and p3b and p3c then
						-- Build macro string and show it in editbox
						local comTeam = "/ltp team "
						comTeam = comTeam .. p1 .. ',' .. p1a .. ',' .. p1b .. ',' .. p1c .. ","
						comTeam = comTeam .. p2 .. ',' .. p2a .. ',' .. p2b .. ',' .. p2c .. ","
						comTeam = comTeam .. p3 .. ',' .. p3a .. ',' .. p3b .. ',' .. p3c
						petEB:SetText(comTeam)
						petEB:HighlightText()
						petEB:SetFocus()
					end
				end

				-- Prevent changes to editbox value
				petEB:SetScript("OnChar", RefreshPets)
				petEB:SetScript("OnKeyUp", RefreshPets)

				-- Refresh pet data when slots are changed
				hooksecurefunc(C_PetJournal, "SetPetLoadOutInfo", RefreshPets)

				-- Add macro button
				local macroBtn = LeaPlusLC:CreateButton("PetMacroBtn", _G["PetJournalLoadoutPet1"], "", "TOPRIGHT", 0, 0, 32, 32, false, "")
				macroBtn:SetFrameLevel(5000)
				macroBtn:SetNormalTexture("Interface\\BUTTONS\\AdventureGuideMicrobuttonAlert")
				macroBtn:SetScript("OnClick", function()
					if C_PetJournal.GetPetLoadOutInfo(1) and C_PetJournal.GetPetLoadOutInfo(2) and C_PetJournal.GetPetLoadOutInfo(3) then
						if pFrame:IsShown() then
							-- Frame is already showing so hide it
							pFrame:Hide() 
						else
							-- Show macro panel
							pFrame:Show()
							RefreshPets()
						end
					else
						LeaPlusLC:Print("You need a battle pet team.")
					end
				end)
				macroBtn:HookScript("OnHide", function() pFrame:Hide() end)

			end

			-- Run system function when pet journal loads
			if IsAddOnLoaded("Blizzard_Collections") then
				MakePetSystem()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_Collections" then
						MakePetSystem()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

		end

		----------------------------------------------------------------------
		--	Hide crafted names
		----------------------------------------------------------------------

		if LeaPlusLC["HideCraftedNames"] == "On" then
			_G.ITEM_CREATED_BY = ""
		end

		----------------------------------------------------------------------
		--	Enable hotkey
		----------------------------------------------------------------------

		if LeaPlusLC["EnableHotkey"] == "On" then

			-- Create global binding function
			local BindBtn = CreateFrame("Button", "LeaPlusGlobalBinding", LeaPlusGlobalPanel)
			BindBtn:SetScript("OnClick", function() LeaPlusLC:SlashFunc() end)

			-- Clear all bindings bound to panel and set hotkey
			ClearOverrideBindings(LeaPlusGlobalPanel)
			SetOverrideBindingClick(LeaPlusGlobalPanel, true, "CTRL-Z", "LeaPlusGlobalBinding")

		end

		----------------------------------------------------------------------
		--	Faster looting
		----------------------------------------------------------------------

		if LeaPlusLC["FasterLooting"] == "On" then

			-- Time delay
			local tDelay = 0

			-- Fast loot function
			local function FastLoot()
				if GetTime() - tDelay >= 0.3 then
					tDelay = GetTime()
 					if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
						for i = GetNumLootItems(), 1, -1 do
							LootSlot(i)
						end
						tDelay = GetTime()
					end
				end
			end

			-- Event frame
			local faster = CreateFrame("Frame")
			faster:RegisterEvent("LOOT_READY")
			faster:SetScript("OnEvent", FastLoot)

		end

		----------------------------------------------------------------------
		--	Disable bag automation
		----------------------------------------------------------------------

		if LeaPlusLC["NoBagAutomation"] == "On" then
			RunScript("hooksecurefunc('OpenAllBags', CloseAllBags)")
		end

		----------------------------------------------------------------------
		--	Hide level-up display
		----------------------------------------------------------------------

		if LeaPlusLC["HideLevelUpDisplay"] == "On" then
			hooksecurefunc(LevelUpDisplay, "Show", LevelUpDisplay.Hide)
		end

		----------------------------------------------------------------------
		--	Hide boss banner
		----------------------------------------------------------------------

		if LeaPlusLC["HideBossBanner"] == "On" then
			BossBanner:UnregisterEvent("ENCOUNTER_LOOT_RECEIVED")
			BossBanner:UnregisterEvent("BOSS_KILL")
		end

		----------------------------------------------------------------------
		--	Hide clean-up buttons
		----------------------------------------------------------------------

		if LeaPlusLC["HideCleanupBtns"] == "On" then
			-- Hide backpack clean-up button and make item search box longer
			BagItemAutoSortButton:HookScript("OnShow", BagItemAutoSortButton.Hide)
			BagItemSearchBox:SetWidth(120)

			-- Hide bank frame clean-up button and make item search box longer
			BankItemAutoSortButton:HookScript("OnShow", BankItemAutoSortButton.Hide)
			BankItemSearchBox:ClearAllPoints()
			BankItemSearchBox:SetPoint("TOPRIGHT", BankFrame, "TOPRIGHT", -27, -33)
			BankItemSearchBox:SetWidth(120)
		end

		----------------------------------------------------------------------
		--	Hide talking frame
		----------------------------------------------------------------------

		if LeaPlusLC["HideTalkingFrame"] == "On" then

			-- Function to hide the talking frame
			local function NoTalkingHeads()
				hooksecurefunc(TalkingHeadFrame, "Show", function(self)
					self:Hide()
				end)
			end

			-- Run function when Blizzard addon is loaded
			if IsAddOnLoaded("Blizzard_TalkingHeadUI") then
				NoTalkingHeads()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_TalkingHeadUI" then
						NoTalkingHeads()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

		end

		----------------------------------------------------------------------
		--	Automate quests (no reload required)
		----------------------------------------------------------------------

		do

			-- Function to show quest dialog for popup quests in the objective tracker
			local function PopupQuestComplete()
				if GetNumAutoQuestPopUps() > 0 then
					local questId, questType = GetAutoQuestPopUp(1)
					if questType == "COMPLETE" then
						local index = GetQuestLogIndexByID(questId)
						ShowQuestComplete(index)
					end
					LeaPlusLC.PopupQuestTicker:Cancel()
				end
			end

			-- Funcion to ignore specific NPCs
			local function isNpcBlocked(actionType)
				local npcGuid = UnitGUID("target") or nil
				if npcGuid then
					local void, void, void, void, void, npcID = strsplit("-", npcGuid)
					if npcID then
						-- Ignore specific NPCs for selecting, accepting and turning-in quests (required if automation has consequences)
						if npcID == "15192" 	-- Anachronos (Caverns of Time)
						or npcID == "119388" 	-- Chieftain Hatuun (Krokul Hovel, Krokuun)
						or npcID == "6566" 		-- Estelle Gendry (Heirloom Curator, Undercity)
						or npcID == "45400" 	-- Fiona's Caravan (Eastern Plaguelands)
						or npcID == "18166" 	-- Khadgar (Allegiance to Aldor/Scryer, Shattrath)
						or npcID == "55402" 	-- Korgol Crushskull (Darkmoon Faire, Pit Master)
						or npcID == "6294" 		-- Krom Stoutarm (Heirloom Curator, Ironforge)
						or npcID == "109227" 	-- Meliah Grayfeather (Tradewind Roost, Highmountain)
						or npcID == "99183" 	-- Renegade Ironworker (Tanaan Jungle, repeatable quest)
						or npcID == "114719" 	-- Trader Caelen (Obliterum Forge, Dalaran, Broken Isles)
						-- Seals of Fate
						or npcID == "111243" 	-- Archmage Lan'dalock (Seal quest, Dalaran)
						or npcID == "87391" 	-- Fate-Twister Seress (Seal quest, Stormshield)
						or npcID == "88570"		-- Fate-Twister Tiklal (Seal quest, Horde)
						or npcID == "142063" 	-- Tezran (Seal quest, Boralus Harbor)
						-- Wartime Donations (Alliance)
						or npcID == "142994" 	-- Brandal Darkbeard (Boralus)
						or npcID == "142995" 	-- Charlane (Boralus)
						or npcID == "142993" 	-- Chelsea Strand (Boralus)
						or npcID == "142998" 	-- Faella (Boralus)
						or npcID == "143004" 	-- Larold Kyne (Boralus)
						or npcID == "143005" 	-- Liao (Boralus)
						or npcID == "143007" 	-- Mae Wagglewand (Boralus)
						or npcID == "143008" 	-- Norber Togglesprocket (Boralus)
						or npcID == "142685" 	-- Paymaster Vauldren (Boralus)
						or npcID == "142700" 	-- Quartermaster Peregrin (Boralus)
						or npcID == "142997" 	-- Senedras (Boralus)
						-- Wartime Donations (Horde)
						or npcID == "142970" 	-- Kuma Longhoof (Dazar'alor)
						or npcID == "142969" 	-- Logarr (Dazar'alor)
						or npcID == "142973" 	-- Mai-Lu (Dazar'alor)
						or npcID == "142977" 	-- Meredith Swane (Dazar'alor)
						or npcID == "142981" 	-- Merill Redgrave (Dazar'alor)
						or npcID == "142157" 	-- Paymaster Grintooth (Dazar'alor)
						or npcID == "142158" 	-- Quartermaster Rauka (Dazar'alor)
						or npcID == "142975" 	-- Seamstress Vessa (Dazar'alor)
						or npcID == "142983" 	-- Swizzle Fizzcrank (Dazar'alor)
						or npcID == "142992" 	-- Uma'wi (Dazar'alor)
						or npcID == "142159" 	-- Zen'kin (Dazar'alor)
						then
							return true
						end
						-- Ignore specific NPCs for selecting quests only (only used for items that have no other purpose)
						if actionType == "Select" then
							if npcID == "87706" 	-- Gazmolf Futzwangler (Reputation quests, Nagrand, Draenor)
							or npcID == "70022" 	-- Ku'ma (Isle of Giants, Pandaria)
							or npcID == "12944" 	-- Lokhtos Darkbargainer (Thorium Brotherhood, Blackrock Depths)
							or npcID == "87393" 	-- Sallee Silverclamp (Reputation quests, Nagrand, Draenor)
							then
								return true
							end
						end
					end
				end
			end

			-- Function to check if quest requires currency or a crafting reagent
			local function QuestRequiresCurrency()
				for i = 1, 6 do
					local progItem = _G["QuestProgressItem" ..i] or nil
					if progItem and progItem:IsShown() and progItem.type == "required" then
						if progItem.objectType == "currency" then
							-- Quest requires currency so do nothing
							return true
						elseif progItem.objectType == "item" then
							-- Quest requires an item
							local name, texture, numItems = GetQuestItemInfo("required", i)
							if name then
								local itemID = GetItemInfoInstant(name)
								if itemID then
									local void, void, void, void, void, void, void, void, void, void, void, void, void, void, void, void, isCraftingReagent = GetItemInfo(itemID)
									if isCraftingReagent then
										-- Item is a crafting reagent so do nothing
										return true
									end
								end
							end
						end
					end
				end
			end

			-- Function to check if quest requires gold
			local function QuestRequiresGold()
				local goldRequiredAmount = GetQuestMoneyToGet()
				if goldRequiredAmount and goldRequiredAmount > 0 then
					return true
				end
			end

			-- Create event frame
			local qFrame = CreateFrame("FRAME")

			-- Function to setup events
			local function SetupEvents()
				if LeaPlusLC["AutomateQuests"] == "On" then
					qFrame:RegisterEvent("QUEST_DETAIL")
					qFrame:RegisterEvent("QUEST_ACCEPT_CONFIRM")
					qFrame:RegisterEvent("QUEST_PROGRESS")
					qFrame:RegisterEvent("QUEST_COMPLETE")
					qFrame:RegisterEvent("QUEST_GREETING")
					qFrame:RegisterEvent("QUEST_AUTOCOMPLETE")
					qFrame:RegisterEvent("GOSSIP_SHOW")
					qFrame:RegisterEvent("QUEST_FINISHED")
				else
					qFrame:UnregisterAllEvents()
				end
			end

			-- Setup events when option is clicked and on startup (if option is enabled)
			LeaPlusCB["AutomateQuests"]:HookScript("OnClick", SetupEvents)
			if LeaPlusLC["AutomateQuests"] == "On" then SetupEvents() end

			-- Event handler
			qFrame:SetScript("OnEvent", function(self, event)

				-- Clear progress items when quest interaction has ceased
				if event == "QUEST_FINISHED" then
					for i = 1, 6 do
						local progItem = _G["QuestProgressItem" ..i] or nil
						if progItem and progItem:IsShown() then
							progItem:Hide()
						end
					end
					return
				end

				-- Do nothing if SHIFT key is being held
				if IsShiftKeyDown() then return end

				----------------------------------------------------------------------
				-- Accept quests automatically
				----------------------------------------------------------------------

				-- Accept quests with a quest detail window
				if event == "QUEST_DETAIL" then
					-- Don't accept blocked quests
					if isNpcBlocked("Accept") then return end
					-- Accept quest
					if QuestGetAutoAccept() then
						-- Quest has already been accepted by Wow so close the quest detail window
						CloseQuest()
					else
						-- Quest has not been accepted by Wow so accept it
						AcceptQuest()
						HideUIPanel(QuestFrame)
					end
				end

				-- Accept quests which require confirmation (such as sharing escort quests)
				if event == "QUEST_ACCEPT_CONFIRM" then
					ConfirmAcceptQuest() 
					StaticPopup_Hide("QUEST_ACCEPT")
				end

				----------------------------------------------------------------------
				-- Turn-in quests automatically
				----------------------------------------------------------------------

				-- Turn-in progression quests
				if event == "QUEST_PROGRESS" and IsQuestCompletable() then
					-- Don't continue quests for blocked NPCs
					if isNpcBlocked("Complete") then return end
					-- Don't continue if quest requires currency
					if QuestRequiresCurrency() then return end
					-- Don't continue if quest requires gold
					if QuestRequiresGold() then return end
					-- Continue quest
					CompleteQuest()
				end

				-- Turn in completed quests if only one reward item is being offered
				if event == "QUEST_COMPLETE" then
					-- Don't complete quests for blocked NPCs
					if isNpcBlocked("Complete") then return end
					-- Don't complete if quest requires currency
					if QuestRequiresCurrency() then return end
					-- Don't complete if quest requires gold
					if QuestRequiresGold() then return end
					-- Complete quest
					if GetNumQuestChoices() <= 1 then
						GetQuestReward(GetNumQuestChoices())
					end
				end

				-- Show quest dialog for quests that use the objective tracker (it will be completed automatically)
				if event == "QUEST_AUTOCOMPLETE" then
					LeaPlusLC.PopupQuestTicker = C_Timer.NewTicker(0.25, PopupQuestComplete, 20)
				end

				----------------------------------------------------------------------
				-- Select quests automatically
				----------------------------------------------------------------------

				if event == "GOSSIP_SHOW" or event == "QUEST_GREETING" then

					-- Select quests
					if UnitExists("npc") or QuestFrameGreetingPanel:IsShown() or GossipFrameGreetingPanel:IsShown() then

						-- Don't select quests for blocked NPCs
						if isNpcBlocked("Select") then return end

						-- Select quests
						if event == "QUEST_GREETING" then
							-- Quest greeting
							local availableCount = GetNumAvailableQuests() + GetNumActiveQuests()
							if availableCount >= 1 then
								for i = 1, availableCount do
									if _G["QuestTitleButton" .. i].isActive == 0 then
										-- Select available quests
										SelectAvailableQuest(_G["QuestTitleButton" .. i]:GetID())
										break
									else
										-- Select completed quests
										local void, isComplete = GetActiveTitle(i)
										if isComplete then
											SelectActiveQuest(_G["QuestTitleButton" .. i]:GetID())
											break
										end
									end
								end
							end
						else
							-- Gossip frame
							local availableCount = GetNumGossipAvailableQuests() + GetNumGossipActiveQuests()
							if availableCount >= 1 then
								for i = 1, availableCount do
									if _G["GossipTitleButton" .. i].type == "Available" then
										-- Select available quests
										SelectGossipAvailableQuest(i)
										break
									else
										-- Select completed quests
										local isComplete = select(i * 6 - 5 + 3, GetGossipActiveQuests()) -- 4th argument of 6 argument line
										if isComplete then
											if _G["GossipTitleButton" .. i].type == "Active" then
												SelectGossipActiveQuest(_G["GossipTitleButton" .. i]:GetID())
												break
											end
										end
									end
								end
							end
						end
					end
				end

			end)

		end

		----------------------------------------------------------------------
		-- Hide bogyguard gossip
		----------------------------------------------------------------------

		if LeaPlusLC["HideBodyguard"] == "On" then
			local gFrame = CreateFrame("FRAME")
			gFrame:RegisterEvent("GOSSIP_SHOW")
			gFrame:SetScript("OnEvent", function()
				-- Do nothing if shift is being held
				if IsShiftKeyDown() then return end
				-- Traverse faction IDs for known bodyguards (http://www.wowhead.com/factions/warlords-of-draenor/barracks-bodyguards)
				local id = GetFriendshipReputation();
				if id then
					if id == 1733 -- Delvar Ironfist
					or id == 1736 -- Tormmok
					or id == 1737 -- Talonpriest Ishaal
					or id == 1738 -- Defender Illona
					or id == 1739 -- Vivianne
					or id == 1740 -- Aeda Brightdawn
					or id == 1741 -- Leorajh
					then
						-- Close gossip window if it's for a cooperating (active) bodyguard
						if UnitCanCooperate("target", "player") then
							CloseGossip()
						end
					end
				end
			end)
		end

		----------------------------------------------------------------------
		--	Sort game options addon list
		----------------------------------------------------------------------

		if LeaPlusLC["CharAddonList"] == "On" then
			-- Set the addon list to character by default
			if AddonCharacterDropDown and AddonCharacterDropDown.selectedValue then
				AddonCharacterDropDown.selectedValue = UnitName("player");
				AddonCharacterDropDownText:SetText(UnitName("player"))
			end
		end

		----------------------------------------------------------------------
		--	Sell junk automatically (no reload required)
		----------------------------------------------------------------------

		do

			-- Create sell junk banner
			local StartMsg = CreateFrame("FRAME", nil, MerchantFrame)
			StartMsg:ClearAllPoints()
			StartMsg:SetPoint("BOTTOMLEFT", 4, 4)
			StartMsg:SetSize(160, 22)
			StartMsg:SetToplevel(true)
			StartMsg:Hide()

			StartMsg.s = StartMsg:CreateTexture(nil, "BACKGROUND")
			StartMsg.s:SetAllPoints()
			StartMsg.s:SetColorTexture(0.1, 0.1, 0.1, 1.0)

			StartMsg.f = StartMsg:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge") 
			StartMsg.f:SetAllPoints();
			StartMsg.f:SetText(L["SELLING JUNK"])

			-- Declarations
			local IterationCount, totalPrice = 500, 0
			local SellJunkFrame = CreateFrame("FRAME")
			local SellJunkTicker, mBagID, mBagSlot

			-- Function to stop selling
			local function StopSelling()
				if SellJunkTicker then SellJunkTicker:Cancel() end
				StartMsg:Hide()
				SellJunkFrame:UnregisterEvent("ITEM_LOCKED")
				SellJunkFrame:UnregisterEvent("ITEM_UNLOCKED")
			end

			-- Vendor function
			local function SellJunkFunc()

				-- Variables
				local SoldCount, Rarity, ItemPrice = 0, 0, 0
				local CurrentItemLink, void

				-- Traverse bags and sell grey items
				for BagID = 0, 4 do
					for BagSlot = 1, GetContainerNumSlots(BagID) do
						CurrentItemLink = GetContainerItemLink(BagID, BagSlot)
						if CurrentItemLink then
							void, void, Rarity, void, void, void, void, void, void, void, ItemPrice = GetItemInfo(CurrentItemLink)
							local void, itemCount = GetContainerItemInfo(BagID, BagSlot)
							if Rarity == 0 and ItemPrice ~= 0 then
								SoldCount = SoldCount + 1
								if MerchantFrame:IsShown() then
									-- If merchant frame is open, vendor the item
									UseContainerItem(BagID, BagSlot)
									-- Perform actions on first iteration
									if SellJunkTicker._remainingIterations == IterationCount then
										-- Calculate total price
										totalPrice = totalPrice + (ItemPrice * itemCount)
										-- Store first sold bag slot for analysis
										if SoldCount == 1 then
											mBagID, mBagSlot = BagID, BagSlot
										end
									end
								else
									-- If merchant frame is not open, stop selling
									StopSelling()
									return
								end
							end
						end
					end
				end

				-- Stop selling if no items were sold for this iteration or iteration limit was reached
				if SoldCount == 0 or SellJunkTicker and SellJunkTicker._remainingIterations == 1 then 
					StopSelling() 
					if totalPrice > 0 then 
						LeaPlusLC:Print(L["Sold junk for"] .. " " .. GetCoinText(totalPrice) .. ".")
					end
				end

			end

			-- Function to setup events
			local function SetupEvents()
				if LeaPlusLC["AutoSellJunk"] == "On" then
					SellJunkFrame:RegisterEvent("MERCHANT_SHOW");
					SellJunkFrame:RegisterEvent("MERCHANT_CLOSED");
				else
					SellJunkFrame:UnregisterEvent("MERCHANT_SHOW")
					SellJunkFrame:UnregisterEvent("MERCHANT_CLOSED")
				end
			end

			-- Setup events when option is clicked and on startup (if option is enabled)
			LeaPlusCB["AutoSellJunk"]:HookScript("OnClick", SetupEvents)
			if LeaPlusLC["AutoSellJunk"] == "On" then SetupEvents() end

			-- Event handler
			SellJunkFrame:SetScript("OnEvent", function(self, event)
				if event == "MERCHANT_SHOW" then
					-- Reset variables
					totalPrice, mBagID, mBagSlot = 0, -1, -1
					-- Do nothing if shift key is held down
					if IsShiftKeyDown() then return end
					-- Cancel existing ticker if present
					if SellJunkTicker then SellJunkTicker:Cancel() end
					-- Sell grey items using ticker (ends when all grey items are sold or iteration count reached)
					SellJunkTicker = C_Timer.NewTicker(0.2, SellJunkFunc, IterationCount)
					SellJunkFrame:RegisterEvent("ITEM_LOCKED")
					SellJunkFrame:RegisterEvent("ITEM_UNLOCKED")
				elseif event == "ITEM_LOCKED" then
					StartMsg:Show()
					SellJunkFrame:UnregisterEvent("ITEM_LOCKED")
				elseif event == "ITEM_UNLOCKED" then
					SellJunkFrame:UnregisterEvent("ITEM_UNLOCKED")
					-- Check whether vendor refuses to buy items
					if mBagID and mBagSlot and mBagID ~= -1 and mBagSlot ~= -1 then
						local texture, count, locked = GetContainerItemInfo(mBagID, mBagSlot)
						if count and not locked then
							-- Item has been unlocked but still not sold so stop selling
							StopSelling()
						end
					end
				elseif event == "MERCHANT_CLOSED" then
					-- If merchant frame is closed, stop selling
					StopSelling()
				end
			end)

		end

		----------------------------------------------------------------------
		--	Repair automatically (no reload required)
		----------------------------------------------------------------------

		do

			-- Repair when suitable merchant frame is shown
			local function RepairFunc()
				if IsShiftKeyDown() then return end
				if CanMerchantRepair() then -- If merchant is capable of repair
					-- Process repair
					local RepairCost, CanRepair = GetRepairAllCost()
					if CanRepair then -- If merchant is offering repair
						if LeaPlusLC["AutoRepairGuildFunds"] == "On" and IsInGuild() then
							-- Guilded character and guild repair option is enabled
							if CanGuildBankRepair() then
								-- Character has permission to repair so try guild funds but fallback on character funds (if daily gold limit is reached)
								RepairAllItems(1)
								RepairAllItems()
							else
								-- Character does not have permission to repair so use character funds
								RepairAllItems()
							end
						else
							-- Unguilded character or guild repair option is disabled
							RepairAllItems()
						end
						-- Show cost summary
						LeaPlusLC:Print(L["Repaired for"] .. " " .. GetCoinText(RepairCost) .. ".")
					end
				end
			end

			-- Create event frame
			local RepairFrame = CreateFrame("FRAME")

			-- Function to setup event
			local function SetupEvent()
				if LeaPlusLC["AutoRepairGear"] == "On" then
					RepairFrame:RegisterEvent("MERCHANT_SHOW")
				else
					RepairFrame:UnregisterEvent("MERCHANT_SHOW")
				end
			end

			-- Setup event when option is clicked and on startup (if option is enabled)
			LeaPlusCB["AutoRepairGear"]:HookScript("OnClick", SetupEvent)
			if LeaPlusLC["AutoRepairGear"] == "On" then SetupEvent() end

			-- Event handler
			RepairFrame:SetScript("OnEvent", RepairFunc)

			-- Create configuration panel
			local RepairPanel = LeaPlusLC:CreatePanel("Repair Automatically", "RepairPanel")

			LeaPlusLC:MakeTx(RepairPanel, "Settings", 16, -72)
			LeaPlusLC:MakeCB(RepairPanel, "AutoRepairGuildFunds", "Repair using guild funds if available", 16, -92, false, "If checked, repair costs will be taken from guild funds for characters that are guilded and have permission to repair.")

			-- Help button hidden
			RepairPanel.h:Hide()

			-- Back button handler
			RepairPanel.b:SetScript("OnClick", function() 
				RepairPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page1"]:Show();
				return
			end)

			-- Reset button handler
			RepairPanel.r:SetScript("OnClick", function()

				-- Reset checkboxes
				LeaPlusLC["AutoRepairGuildFunds"] = "On"

				-- Refresh panel
				RepairPanel:Hide(); RepairPanel:Show()

			end)

			-- Show panal when options panel button is clicked
			LeaPlusCB["AutoRepairBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["AutoRepairGuildFunds"] = "On"
				else
					RepairPanel:Show()
					LeaPlusLC:HideFrames()
				end
			end)

		end

		----------------------------------------------------------------------
		-- Hide the combat log
		----------------------------------------------------------------------

		if LeaPlusLC["NoCombatLogTab"] == "On" then
			-- Ensure combat log is docked
			if ChatFrame2.isDocked then
				-- Set combat log attributes when chat windows are updated
				LpEvt:RegisterEvent("UPDATE_CHAT_WINDOWS")
				-- Set combat log tab placement when tabs are assigned by the client
				hooksecurefunc("FCF_SetTabPosition", function()
					ChatFrame2Tab:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "BOTTOMRIGHT", 0, 0)
				end)
			else
				-- If combat log is undocked, do nothing but show warning
				LeaPlusLC:Print("Combat log cannot be hidden while undocked.")
			end
		end

		----------------------------------------------------------------------
		--	Show player chain
		----------------------------------------------------------------------

		if LeaPlusLC["ShowPlayerChain"] == "On" then

			-- Create configuration panel
			local ChainPanel = LeaPlusLC:CreatePanel("Player Chain", "ChainPanel")

			-- Add dropdown menu
			LeaPlusLC:CreateDropDown("PlayerChainMenu", "Chain style", ChainPanel, 146, "TOPLEFT", 16, -112, {L["RARE"], L["ELITE"], L["RARE ELITE"]}, "")

			-- Set chain style
			local function SetChainStyle()
				-- Get dropdown menu value
				local chain = LeaPlusLC["PlayerChainMenu"] -- Numeric value
				-- Set chain style according to value
				if chain == 1 then -- Rare
					PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare.blp");
				elseif chain == 2 then -- Elite
					PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite.blp");
				elseif chain == 3 then -- Rare Elite
					PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite.blp");
				end
			end

			-- Set style on startup
			SetChainStyle()

			-- Set style when a drop menu is selected (procs when the list is hidden)
			LeaPlusCB["ListFramePlayerChainMenu"]:HookScript("OnHide", SetChainStyle)

			-- Help button hidden
			ChainPanel.h:Hide()

			-- Back button handler
			ChainPanel.b:SetScript("OnClick", function() 
				LeaPlusCB["ListFramePlayerChainMenu"]:Hide(); -- Hide the dropdown list
				ChainPanel:Hide();
				LeaPlusLC["PageF"]:Show();
				LeaPlusLC["Page6"]:Show();
				return
			end) 

			-- Reset button handler
			ChainPanel.r:SetScript("OnClick", function()
				LeaPlusCB["ListFramePlayerChainMenu"]:Hide(); -- Hide the dropdown list
				LeaPlusLC["PlayerChainMenu"] = 2
				ChainPanel:Hide(); ChainPanel:Show();
				SetChainStyle()
			end)

			-- Show the panel when the configuration button is clicked
			LeaPlusCB["ModPlayerChain"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					LeaPlusLC["PlayerChainMenu"] = 3;
					SetChainStyle();
				else
					LeaPlusLC:HideFrames();
					ChainPanel:Show();
				end
			end)

		end

		----------------------------------------------------------------------
		-- Show raid frame toggle button
		----------------------------------------------------------------------

		if LeaPlusLC["ShowRaidToggle"] == "On" then

			-- Check to make sure raid toggle button exists
			if CompactRaidFrameManagerDisplayFrameHiddenModeToggle then

				-- Create a border for the button
				CompactRaidFrameManagerDisplayFrameHiddenModeToggle:SetBackdrop({ 
					edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
					tile = false, tileSize = 0, edgeSize = 16,
					insets = { left = 0, right = 0, top = 0, bottom = 0 }})

				-- Move the button (function runs after PLAYER_ENTERING_WORLD and PARTY_LEADER_CHANGED)
				hooksecurefunc("CompactRaidFrameManager_UpdateOptionsFlowContainer", function()
					if CompactRaidFrameManager and CompactRaidFrameManagerDisplayFrameHiddenModeToggle then
						local void, void, void, void, y = CompactRaidFrameManager:GetPoint()
						CompactRaidFrameManagerDisplayFrameHiddenModeToggle:SetWidth(40)
						CompactRaidFrameManagerDisplayFrameHiddenModeToggle:ClearAllPoints()
						CompactRaidFrameManagerDisplayFrameHiddenModeToggle:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, y + 22)
						CompactRaidFrameManagerDisplayFrameHiddenModeToggle:SetParent(UIParent)
					end
				end)

			end

		end

		----------------------------------------------------------------------
		-- Hide hit indicators (portrait text)
		----------------------------------------------------------------------

		if LeaPlusLC["NoHitIndicators"] == "On" then
			hooksecurefunc(PlayerHitIndicator, "Show", PlayerHitIndicator.Hide)
			hooksecurefunc(PetHitIndicator, "Show", PetHitIndicator.Hide)
		end

		----------------------------------------------------------------------
		-- Class colored frames
		----------------------------------------------------------------------

		if LeaPlusLC["ClassColFrames"] == "On" then

			-- Create background frame for player frame
			local PlayFN = CreateFrame("FRAME", nil, PlayerFrame)
			PlayFN:SetWidth(TargetFrameNameBackground:GetWidth())
			PlayFN:SetHeight(TargetFrameNameBackground:GetHeight())

			local void, void, void, x, y = TargetFrameNameBackground:GetPoint()
			PlayFN:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", -x, y)

			PlayFN.t = PlayFN:CreateTexture(nil, "BORDER")
			PlayFN.t:SetAllPoints()
			PlayFN.t:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-LevelBackground")

			local c = LeaPlusLC["RaidColors"][select(2, UnitClass("player"))]
			if c then PlayFN.t:SetVertexColor(c.r, c.g, c.b) end

			-- Create color function for target and focus frames
			local function TargetFrameCol()
				if UnitIsPlayer("target") then
					local c = LeaPlusLC["RaidColors"][select(2, UnitClass("target"))]
					if c then TargetFrameNameBackground:SetVertexColor(c.r, c.g, c.b) end
				end
				if UnitIsPlayer("focus") then
					local c = LeaPlusLC["RaidColors"][select(2, UnitClass("focus"))]
					if c then FocusFrameNameBackground:SetVertexColor(c.r, c.g, c.b) end
				end
			end

			-- Set target frame on startup and when events fire
			local ColTar = CreateFrame("FRAME")
			ColTar:RegisterEvent("GROUP_ROSTER_UPDATE")
			ColTar:RegisterEvent("PLAYER_TARGET_CHANGED")
			ColTar:RegisterEvent("PLAYER_FOCUS_CHANGED")
			ColTar:RegisterEvent("UNIT_FACTION")
			ColTar:SetScript("OnEvent", TargetFrameCol)
			TargetFrameCol()

			-- Set focus frame if frame size changes
			hooksecurefunc("FocusFrame_SetSmallSize", TargetFrameCol)

		end

		----------------------------------------------------------------------
		-- Minimap customisation
		----------------------------------------------------------------------

		if LeaPlusLC["MinimapMod"] == "On" then

			----------------------------------------------------------------------
			-- Configuration panel
			----------------------------------------------------------------------

			-- Create configuration panel
			local SideMinimap = LeaPlusLC:CreatePanel("Minimap", "SideMinimap")

			-- Hide panel during combat
			SideMinimap:RegisterEvent("PLAYER_REGEN_DISABLED")
			SideMinimap:SetScript("OnEvent", SideMinimap.Hide)

			-- Add checkboxes
			LeaPlusLC:MakeTx(SideMinimap, "Settings", 16, -72)
			LeaPlusLC:MakeCB(SideMinimap, "HideZoneTextBar", "Hide the zone text bar", 16, -92, false, "If checked, the zone text bar will be hidden.  The tracking button tooltip will show zone information.")
			LeaPlusLC:MakeCB(SideMinimap, "MergeTrackBtn", "Merge the tracking and calendar buttons", 16, -112, false, "If checked, the tracking button will be merged with the calendar button.|n|nLeft-click the tracking button to show the tracking menu or right-click it to show the calendar.")
			LeaPlusLC:MakeCB(SideMinimap, "HideMiniZoomBtns", "Hide the zoom buttons", 16, -132, false, "If checked, the zoom buttons will be hidden.  You can use the mousewheel to zoom regardless of this setting.")
			LeaPlusLC:MakeCB(SideMinimap, "HideMiniClock", "Hide the clock", 16, -152, false, "If checked, the clock will be hidden.")

			-- Add slider control
			LeaPlusLC:MakeTx(SideMinimap, "Scale", 356, -72)
			LeaPlusLC:MakeSL(SideMinimap, "MinimapScale", "", 1, 2, 0.1, 356, -92, "%.2f")

			----------------------------------------------------------------------
			-- Hide the zone text bar
			----------------------------------------------------------------------

			-- Store Blizzard handlers
			local origMiniMapTrackingButtonOnEnter = MiniMapTrackingButton:GetScript("OnEnter")
			local zonta, zontp, zontr, zontx, zonty = MinimapZoneTextButton:GetPoint()

			-- Function to show zone tooltip
			local function ShowZoneTip(doNotShow)
				if LeaPlusLC["HideZoneTextBar"] == "On" then
					-- Show zone information in tooltip
					local zoneName = GetZoneText()
					local subzoneName = GetSubZoneText()
					if subzoneName == zoneName then	subzoneName = "" end
					-- Change the owner and position (needed for Minimap_SetTooltip)
					GameTooltip:SetOwner(MinimapZoneTextButton, "ANCHOR_LEFT")
					MinimapZoneTextButton:SetAllPoints(MiniMapTrackingButton)
					-- Show the tooltip
					local pvpType, isSubZonePvP, factionName = GetZonePVPInfo()
					Minimap_SetTooltip(pvpType, factionName)
					GameTooltip:Show()
					if doNotShow == true then GameTooltip:Hide() end
				else
					MinimapZoneTextButton:ClearAllPoints()
					MinimapZoneTextButton:SetPoint(zonta, zontp, zontr, zontx, zonty)
				end
			end

			-- Function to set the zone text bar position
			local function SetTitleBarPos()
				if OrderHallCommandBar then
					if OrderHallCommandBar:IsShown() then
						if LeaPlusLC["HideZoneTextBar"] == "On" then
							MinimapCluster:ClearAllPoints()
							MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
						else
							MinimapCluster:ClearAllPoints()
							MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, -20)
						end
					else
						if LeaPlusLC["HideZoneTextBar"] == "On" then
							MinimapCluster:ClearAllPoints()
							MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 20)
						else
							MinimapCluster:ClearAllPoints()
							MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
						end
					end
				else
					if LeaPlusLC["HideZoneTextBar"] == "On" then
						MinimapCluster:ClearAllPoints()
						MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 20)

					else
						MinimapCluster:ClearAllPoints()
						MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
					end
				end
			end

			-- Function to toggle the zone text bar
			local function SetMiniZoneText()
				if LeaPlusLC["HideZoneTextBar"] == "On" then
					-- Hide the zone text bar
					MinimapZoneTextButton:Hide()
					MiniMapWorldMapButton:Hide()
					MinimapBorderTop:SetTexture("")
					-- Move the minimap up to the top
					SetTitleBarPos()
					-- Set the tooltip of the tracking button as the zone name
					MiniMapTrackingButton:SetScript("OnEnter", ShowZoneTip)
				else
					-- Show the zone text bar
					MinimapZoneTextButton:Show()
					MiniMapWorldMapButton:Show()
					MinimapBorderTop:SetTexture("Interface\\Minimap\\UI-Minimap-Border")
					-- Move the minimap to its original position
					SetTitleBarPos()
					-- Set the tooltip of the tracking button as the original one
					MiniMapTrackingButton:SetScript("OnEnter", origMiniMapTrackingButtonOnEnter)
				end
			end

			-- Set the zone text bar layout and tooltip position when option is clicked
			LeaPlusCB["HideZoneTextBar"]:HookScript("OnClick", function()
				SetMiniZoneText()
				ShowZoneTip(true)
			end)

			-- Set the zone text bar layout on startup
			SetMiniZoneText()

			-- Function to move the minimap down when order hall bar is shown or option is clicked
			local function ManageCommandBar()

				-- Set zone text bar when order hall bar is shown
				OrderHallCommandBar:HookScript("OnShow", function()
					C_Timer.After(0.1, function()
						if OrderHallCommandBar:IsShown() then
							SetTitleBarPos()
						end
					end)
				end)

				-- Set zone text bar when order hall bar is hidden
				OrderHallCommandBar:HookScript("OnHide", SetTitleBarPos)

			end

			-- Run function when Blizzard addon has loaded
			if IsAddOnLoaded("Blizzard_OrderHallUI") then
				ManageCommandBar()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_OrderHallUI" then
						ManageCommandBar()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			----------------------------------------------------------------------
			-- Merge the tracking and calendar buttons
			----------------------------------------------------------------------

			-- Function to merge buttons
			local function SetMiniMerge()
				if LeaPlusLC["MergeTrackBtn"] == "On" then
					-- Hide calendar button
					GameTimeFrame:Hide()
					-- Move the tracking button to the calendar button space
					MiniMapTracking:ClearAllPoints()
					MiniMapTracking:SetAllPoints(GameTimeFrame)
					-- Right-clicking the tracking button shows the calendar 
					MiniMapTrackingButton:SetScript("OnMouseDown", function(self, btn)
						if btn == "RightButton" then GameTimeFrame:Click();	end
					end)
				else
					-- Show the calendar button
					GameTimeFrame:Show()
					-- Move the tracking button to its origianl position
					MiniMapTracking:ClearAllPoints()
					MiniMapTracking:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", 9, -45)
					-- Remove right-click from the tracking button
					MiniMapTrackingButton:SetScript("OnMouseDown", nil)
				end
			end

			-- When the merge buttons option is checked, update the minimap
			LeaPlusCB["MergeTrackBtn"]:HookScript("OnClick", SetMiniMerge)

			-- Merge buttons on startup
			SetMiniMerge()

			----------------------------------------------------------------------
			-- Hide the zoom buttons
			----------------------------------------------------------------------

			-- Function to toggle the zoom buttons
			local function ToggleZoomButtons()
				if LeaPlusLC["HideMiniZoomBtns"] == "On" then
					MinimapZoomIn:Hide()
					MinimapZoomOut:Hide()
				else
					MinimapZoomIn:Show()
					MinimapZoomOut:Show()
				end
			end

			-- Set the zoom buttons when the option is clicked and on startup
			LeaPlusCB["HideMiniZoomBtns"]:HookScript("OnClick", ToggleZoomButtons)
			ToggleZoomButtons()

			----------------------------------------------------------------------
			-- Hide the clock
			----------------------------------------------------------------------

			-- Function to show or hide the clock
			local function SetMiniClock()
				if IsAddOnLoaded("Blizzard_TimeManager") then
					if LeaPlusLC["HideMiniClock"] == "On" then
						TimeManagerClockButton:Hide()
					else
						TimeManagerClockButton:Show()
					end
				end
			end

			-- Run function when Blizzard addon is loaded
			if IsAddOnLoaded("Blizzard_TimeManager") then
				SetMiniClock()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_TimeManager" then
						SetMiniClock()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			-- Update the clock when the checkbox is clicked
			LeaPlusCB["HideMiniClock"]:HookScript("OnClick", SetMiniClock)

			----------------------------------------------------------------------
			-- Enable mousewheel zoom
			----------------------------------------------------------------------

			-- Function to control mousewheel zoom
			local function MiniZoom(self, arg1)
				if arg1 > 0 and self:GetZoom() < 5 then
					-- Zoom in
					MinimapZoomOut:Enable()
					self:SetZoom(self:GetZoom() + 1)
					if(Minimap:GetZoom() == (Minimap:GetZoomLevels() - 1)) then
						MinimapZoomIn:Disable()
					end
				elseif arg1 < 0 and self:GetZoom() > 0 then
					-- Zoom out
					MinimapZoomIn:Enable()
					self:SetZoom(self:GetZoom() - 1)
					if(Minimap:GetZoom() == 0) then
						MinimapZoomOut:Disable()
					end
				end
			end

			-- Enable mousewheel zoom
			Minimap:EnableMouseWheel(true)
			Minimap:SetScript("OnMouseWheel", MiniZoom)

			----------------------------------------------------------------------
			-- Minimap scale
			----------------------------------------------------------------------

			-- Function to set the minimap scale
			local function SetMiniScale()
				MinimapCluster:SetScale(LeaPlusLC["MinimapScale"])
				-- Set slider formatted text
				LeaPlusCB["MinimapScale"].f:SetFormattedText("%.0f%%", LeaPlusLC["MinimapScale"] * 100)
			end

			-- Set minimap scale when slider is changed and on startup
			LeaPlusCB["MinimapScale"]:HookScript("OnValueChanged", SetMiniScale)
			SetMiniScale()

			----------------------------------------------------------------------
			-- Buttons
			----------------------------------------------------------------------

			-- Help button tooltip
			SideMinimap.h.tiptext = L["This panel will close automatically if you enter combat."]

			-- Back button handler
			SideMinimap.b:SetScript("OnClick", function() 
				SideMinimap:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page5"]:Show()
				return
			end) 

			-- Reset button handler
			SideMinimap.r:SetScript("OnClick", function()
				LeaPlusLC["HideZoneTextBar"] = "Off"; SetMiniZoneText(); ShowZoneTip(true)
				LeaPlusLC["MergeTrackBtn"] = "Off"; SetMiniMerge()
				LeaPlusLC["HideMiniZoomBtns"] = "Off"; ToggleZoomButtons()
				LeaPlusLC["HideMiniClock"] = "Off"; SetMiniClock()
				LeaPlusLC["MinimapScale"] = 1; SetMiniScale()
				SideMinimap:Hide(); SideMinimap:Show()
			end)

			-- Configuration button handler
			LeaPlusCB["ModMinimapBtn"]:SetScript("OnClick", function()
				if LeaPlusLC:PlayerInCombat() then
					return
				else
					if IsShiftKeyDown() and IsControlKeyDown() then
						-- Preset profile
						LeaPlusLC["HideZoneTextBar"] = "On"; SetMiniZoneText(); ShowZoneTip(true)
						LeaPlusLC["MergeTrackBtn"] = "On"; SetMiniMerge()
						LeaPlusLC["HideMiniZoomBtns"] = "Off"; ToggleZoomButtons()
						LeaPlusLC["HideMiniClock"] = "Off"; SetMiniClock()
						LeaPlusLC["MinimapScale"] = 1.30; SetMiniScale()
					else
						-- Show configuration panel
						SideMinimap:Show()
						LeaPlusLC:HideFrames()
					end
				end
			end)

		end

		----------------------------------------------------------------------
		--	Quest text size
		----------------------------------------------------------------------

		if LeaPlusLC["QuestFontChange"] == "On" then

			-- Create configuration panel
			local QuestTextPanel = LeaPlusLC:CreatePanel("Quest Text", "QuestTextPanel")

			LeaPlusLC:MakeTx(QuestTextPanel, "Text size", 16, -72)
			LeaPlusLC:MakeSL(QuestTextPanel, "LeaPlusQuestFontSize", "", 10, 36, 1, 16, -92, "%.0f")

			-- Function to update the font size
			local function QuestSizeUpdate()
				QuestTitleFont:SetFont(QuestFont:GetFont(), LeaPlusLC["LeaPlusQuestFontSize"] + 3, nil)
				QuestFont:SetFont(QuestFont:GetFont(), LeaPlusLC["LeaPlusQuestFontSize"] + 1, nil)
				QuestFontNormalSmall:SetFont(QuestFontNormalSmall:GetFont(), LeaPlusLC["LeaPlusQuestFontSize"], nil)
			end

			-- Set text size when slider changes and on startup
			LeaPlusCB["LeaPlusQuestFontSize"]:HookScript("OnValueChanged", QuestSizeUpdate)
			QuestSizeUpdate()

			-- Help button hidden
			QuestTextPanel.h:Hide()

			-- Back button handler
			QuestTextPanel.b:SetScript("OnClick", function() 
				QuestTextPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page4"]:Show()
				return
			end)

			-- Reset button handler
			QuestTextPanel.r:SetScript("OnClick", function()

				-- Reset slider
				LeaPlusLC["LeaPlusQuestFontSize"] = 12
				QuestSizeUpdate()

				-- Refresh side panel
				QuestTextPanel:Hide(); QuestTextPanel:Show()

			end)

			-- Show configuration panal when options panel button is clicked
			LeaPlusCB["QuestTextBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["LeaPlusQuestFontSize"] = 18
					QuestSizeUpdate()
				else
					QuestTextPanel:Show()
					LeaPlusLC:HideFrames()
				end
			end)

		end

		----------------------------------------------------------------------
		--	Resize mail text
		----------------------------------------------------------------------

		if LeaPlusLC["MailFontChange"] == "On" then

			-- Create configuration panel
			local MailTextPanel = LeaPlusLC:CreatePanel("Mail Text", "MailTextPanel")

			LeaPlusLC:MakeTx(MailTextPanel, "Text size", 16, -72)
			LeaPlusLC:MakeSL(MailTextPanel, "LeaPlusMailFontSize", "", 10, 36, 1, 16, -92, "%.0f")

			-- Function to set the text size
			local function MailSizeUpdate()
				local MailFont = QuestFont:GetFont();
				OpenMailBodyText:SetFont(MailFont, LeaPlusLC["LeaPlusMailFontSize"])
				SendMailBodyEditBox:SetFont(MailFont, LeaPlusLC["LeaPlusMailFontSize"])
			end

			-- Set text size after changing slider and on startup
			LeaPlusCB["LeaPlusMailFontSize"]:HookScript("OnValueChanged", MailSizeUpdate)
			MailSizeUpdate()

			-- Help button hidden
			MailTextPanel.h:Hide()

			-- Back button handler
			MailTextPanel.b:SetScript("OnClick", function() 
				MailTextPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page4"]:Show()
				return
			end)

			-- Reset button handler
			MailTextPanel.r:SetScript("OnClick", function()

				-- Reset slider
				LeaPlusLC["LeaPlusMailFontSize"] = 15

				-- Refresh side panel
				MailTextPanel:Hide(); MailTextPanel:Show()

			end)

			-- Show configuration panal when options panel button is clicked
			LeaPlusCB["MailTextBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["LeaPlusMailFontSize"] = 22
					MailSizeUpdate()
				else
					MailTextPanel:Show()
					LeaPlusLC:HideFrames()
				end
			end)

		end

		----------------------------------------------------------------------
		--	Show durability status
		----------------------------------------------------------------------

		if LeaPlusLC["DurabilityStatus"] == "On" then

			-- Create durability button
			local cButton = CreateFrame("BUTTON", nil, PaperDollFrame)
			cButton:ClearAllPoints()
			cButton:SetPoint("BOTTOMRIGHT", CharacterFrameInset, "BOTTOMRIGHT", -2, -1)
			cButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
			cButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
			cButton:SetSize(32, 32)

			-- Create durability tables
			local Slots = {"HeadSlot", "ShoulderSlot", "ChestSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "MainHandSlot", "SecondaryHandSlot"}
			local SlotsFriendly = {INVTYPE_HEAD, INVTYPE_SHOULDER, INVTYPE_CHEST, INVTYPE_WRIST, INVTYPE_HAND, INVTYPE_WAIST, INVTYPE_LEGS, INVTYPE_FEET, INVTYPE_WEAPONMAINHAND, INVTYPE_WEAPONOFFHAND}

			-- Show durability status in tooltip or status line (tip or status)
			local function ShowDuraStats(where)

				local duravaltotal, duramaxtotal, durapercent = 0, 0, 0
				local valcol, id, duraval, duramax

				if where == "tip" then
					-- Creare layout
					_G["GameTooltipTextLeft1"]:SetText("|cffffffff"); _G["GameTooltipTextRight1"]:SetText("|cffffffff")
					_G["GameTooltipTextLeft2"]:SetText("|cffffffff"); _G["GameTooltipTextRight2"]:SetText("|cffffffff")
					_G["GameTooltipTextLeft3"]:SetText("|cffffffff"); _G["GameTooltipTextRight3"]:SetText("|cffffffff")
					GameTooltip:AddLine("|cffffffff")
					GameTooltip:AddLine("|cffffffff")
					GameTooltip:AddLine("|cffffffff")
				end

				local validItems = false

				-- Traverse equipment slots
				for k, slotName in ipairs(Slots) do
					if GetInventorySlotInfo(slotName) then
						id = GetInventorySlotInfo(slotName)
						duraval, duramax = GetInventoryItemDurability(id)
						if duraval ~= nil then

							-- At least one item has durability stat
							validItems = true

							-- Add to tooltip
							if where == "tip" then
								durapercent = tonumber(format("%.0f", duraval / duramax * 100))
								valcol = (durapercent >= 80 and "|cff00FF00") or (durapercent >= 60 and "|cff99FF00") or (durapercent >= 40 and "|cffFFFF00") or (durapercent >= 20 and "|cffFF9900") or (durapercent >= 0 and "|cffFF2000") or ("|cffFFFFFF")
								_G["GameTooltipTextLeft1"]:SetText(L["Durability"])
								_G["GameTooltipTextLeft2"]:SetText(_G["GameTooltipTextLeft2"]:GetText() .. SlotsFriendly[k] .. "|n")
								_G["GameTooltipTextRight2"]:SetText(_G["GameTooltipTextRight2"]:GetText() ..  valcol .. durapercent .. "%" .. "|n")
							end

							duravaltotal = duravaltotal + duraval
							duramaxtotal = duramaxtotal + duramax
						end
					end
				end
				if duravaltotal > 0 and duramaxtotal > 0 then
					durapercent = duravaltotal / duramaxtotal * 100
				else
					durapercent = 0
				end

				if where == "tip" then

					if validItems == true then
						-- Show overall durability in the tooltip
						if durapercent >= 80 then valcol = "|cff00FF00"	elseif durapercent >= 60 then valcol = "|cff99FF00"	elseif durapercent >= 40 then valcol = "|cffFFFF00"	elseif durapercent >= 20 then valcol = "|cffFF9900"	elseif durapercent >= 0 then valcol = "|cffFF2000" else return end
						_G["GameTooltipTextLeft3"]:SetText(L["Overall"] .. " " .. valcol)
						_G["GameTooltipTextRight3"]:SetText(valcol .. string.format("%.0f", durapercent) .. "%")

						-- Show lines of the tooltip
						GameTooltipTextLeft1:Show(); GameTooltipTextRight1:Show()
						GameTooltipTextLeft2:Show(); GameTooltipTextRight2:Show()
						GameTooltipTextLeft3:Show(); GameTooltipTextRight3:Show()
						GameTooltipTextRight2:SetJustifyH"RIGHT";
						GameTooltipTextRight3:SetJustifyH"RIGHT";
						GameTooltip:Show()
					else
						-- No items have durability stat
						GameTooltip:ClearLines()
						GameTooltip:AddLine("" .. L["Durability"],1.0, 0.85, 0.0)
						GameTooltip:AddLine("" .. L["No items with durability equipped."], 1, 1, 1)
						GameTooltip:Show()
					end

				elseif where == "status" then
					if validItems == true then
						-- Show simple status line instead
						if tonumber(durapercent) >= 0 then -- Ensure character has some durability items equipped
							LeaPlusLC:Print(L["You have"] .. " " .. string.format("%.0f", durapercent) .. "%" .. " " .. L["durability"] .. ".")
						end
					end

				end
			end

			-- Hover over the durability button to show the durability tooltip
			cButton:SetScript("OnEnter", function()
				GameTooltip:SetOwner(cButton, "ANCHOR_RIGHT");
				ShowDuraStats("tip");
			end)
			cButton:SetScript("OnLeave", GameTooltip_Hide)

			-- Create frame to watch events
			local DeathDura = CreateFrame("FRAME")
			DeathDura:RegisterEvent("PLAYER_DEAD")
			DeathDura:SetScript("OnEvent", function(self, event)
				ShowDuraStats("status")
				DeathDura:UnregisterEvent("PLAYER_DEAD")
				C_Timer.After(2, function()
					DeathDura:RegisterEvent("PLAYER_DEAD")
				end)
			end)

			hooksecurefunc("AcceptResurrect", function()
				-- Player has ressed without releasing
				ShowDuraStats("status")
			end)
			
		end

		----------------------------------------------------------------------
		--	Hide zone text
		----------------------------------------------------------------------

		if LeaPlusLC["HideZoneText"] == "On" then
			ZoneTextFrame:SetScript("OnShow", ZoneTextFrame.Hide);
			SubZoneTextFrame:SetScript("OnShow", SubZoneTextFrame.Hide);
		end

		----------------------------------------------------------------------
		--	Disable sticky chat
		----------------------------------------------------------------------

		if LeaPlusLC["NoStickyChat"] == "On" then
			-- These taint if set to anything other than nil
			ChatTypeInfo.WHISPER.sticky = nil
			ChatTypeInfo.BN_WHISPER.sticky = nil
			ChatTypeInfo.CHANNEL.sticky = nil
		end

		----------------------------------------------------------------------
		--	Hide stance bar
		----------------------------------------------------------------------

		if LeaPlusLC["NoClassBar"] == "On" then
			local stancebar = CreateFrame("FRAME")
			stancebar:Hide();
			UIPARENT_MANAGED_FRAME_POSITIONS["StanceBarFrame"] = nil;
			StanceBarFrame:SetParent(stancebar)
		end

		----------------------------------------------------------------------
		--	Hide gryphons
		----------------------------------------------------------------------

		if LeaPlusLC["NoGryphons"] == "On" then
			MainMenuBarArtFrame.LeftEndCap:Hide();
			MainMenuBarArtFrame.RightEndCap:Hide();
		end

		----------------------------------------------------------------------
		--	Disable chat fade
		----------------------------------------------------------------------

		if LeaPlusLC["NoChatFade"] == "On" then
			-- Process normal and existing chat frames
			for i = 1, 50 do
				if _G["ChatFrame" .. i] then
					_G["ChatFrame" .. i]:SetFading(false)
				end
			end
			-- Process temporary frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function()
				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then
					_G[cf]:SetFading(false)
				end
			end)
		end

		----------------------------------------------------------------------
		--	Use easy chat frame resizing
		----------------------------------------------------------------------

		if LeaPlusLC["UseEasyChatResizing"] == "On" then
			ChatFrame1Tab:HookScript("OnMouseDown", function(self,arg1)
				if arg1 == "LeftButton" then
					if select(8, GetChatWindowInfo(1)) then
						ChatFrame1:StartSizing("TOP")
					end
				end
			end)
			ChatFrame1Tab:SetScript("OnMouseUp", function(self,arg1)
				if arg1 == "LeftButton" then
					ChatFrame1:StopMovingOrSizing()
					FCF_SavePositionAndDimensions(ChatFrame1)
				end
			end)
		end

		----------------------------------------------------------------------
		--	Increase chat history
		----------------------------------------------------------------------

		if LeaPlusLC["MaxChatHstory"] == "On" then
			-- Process normal and existing chat frames
			for i = 1, 50 do
				if _G["ChatFrame" .. i] and _G["ChatFrame" .. i]:GetMaxLines() ~= 4096 then
					_G["ChatFrame" .. i]:SetMaxLines(4096);
				end
			end
			-- Process temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function()
				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then
					if (_G[cf]:GetMaxLines() ~= 4096) then
						_G[cf]:SetMaxLines(4096);
					end
				end
			end)
		end

		----------------------------------------------------------------------
		--	Hide error messages
		----------------------------------------------------------------------

		if LeaPlusLC["HideErrorMessages"] == "On" then

			--	Error message events
			local OrigErrHandler = UIErrorsFrame:GetScript('OnEvent')
			UIErrorsFrame:SetScript('OnEvent', function (self, event, id, err, ...)
				if event == "UI_ERROR_MESSAGE" then
					-- Hide error messages
					if LeaPlusLC["ShowErrorsFlag"] == 1 then
						if 	err == ERR_INV_FULL or
							err == ERR_QUEST_LOG_FULL or
							err == ERR_RAID_GROUP_ONLY	or
							err == ERR_PARTY_LFG_BOOT_LIMIT or
							err == ERR_PARTY_LFG_BOOT_DUNGEON_COMPLETE or
							err == ERR_PARTY_LFG_BOOT_IN_COMBAT or
							err == ERR_PARTY_LFG_BOOT_IN_PROGRESS or
							err == ERR_PARTY_LFG_BOOT_LOOT_ROLLS or
							err == ERR_PARTY_LFG_TELEPORT_IN_COMBAT or
							err == ERR_PET_SPELL_DEAD or
							err == ERR_PLAYER_DEAD or
							err:find(format(ERR_PARTY_LFG_BOOT_NOT_ELIGIBLE_S, ".+")) then
								return OrigErrHandler(self, event, id, err, ...)
						end
					else
						return OrigErrHandler(self, event, id, err, ...) 
					end
				elseif event == 'UI_INFO_MESSAGE'  then
					-- Show information messages
					return OrigErrHandler(self, event, id, err, ...)
				end
			end)

		end

		-- Release memory
		LeaPlusLC.Isolated = nil

	end

----------------------------------------------------------------------
--	L40: Player
----------------------------------------------------------------------

	function LeaPlusLC:Player()

		----------------------------------------------------------------------
		--	Remove raid restrictions (no reload required)
		----------------------------------------------------------------------

		do

			-- Function to set raid restrictions
			local function SetRaidFunc()
				if LeaPlusLC["NoRaidRestrictions"] == "On" then
					SetAllowLowLevelRaid(true)
				else
					SetAllowLowLevelRaid(false)
				end
			end

			-- Run function when option is clicked and on startup (if enabled)
			LeaPlusCB["NoRaidRestrictions"]:HookScript("OnClick", SetRaidFunc)
			if LeaPlusLC["NoRaidRestrictions"] == "On" then SetRaidFunc() end

		end

		----------------------------------------------------------------------
		-- Disable screen glow (no reload required)
		----------------------------------------------------------------------

		do

			-- Function to set screen glow
			local function SetGlow()
				if LeaPlusLC["NoScreenGlow"] == "On" then
					SetCVar("ffxGlow", "0")
				else
					SetCVar("ffxGlow", "1")
				end
			end

			-- Set screen glow on startup and when option is clicked (if enabled)
			LeaPlusCB["NoScreenGlow"]:HookScript("OnClick", SetGlow)
			if LeaPlusLC["NoScreenGlow"] == "On" then SetGlow() end

		end

		----------------------------------------------------------------------
		-- Disable screen effects (no reload required)
		----------------------------------------------------------------------

		do

			-- Function to set screen effects
			local function SetEffects()
				if LeaPlusLC["NoScreenEffects"] == "On" then
					SetCVar("ffxDeath", "0")
					SetCVar("ffxNether", "0")
				else
					SetCVar("ffxDeath", "1")
					SetCVar("ffxNether", "1")
				end
			end

			-- Set screen effects when option is clicked and on startup (if enabled)
			LeaPlusCB["NoScreenEffects"]:HookScript("OnClick", SetEffects)
			if LeaPlusLC["NoScreenEffects"] == "On" then SetEffects() end

		end

		----------------------------------------------------------------------
		--	Max camera zoom (no reload required)
		----------------------------------------------------------------------

		do

			-- Function to set camera zoom
			local function SetZoom()
				if LeaPlusLC["MaxCameraZoom"] == "On" then
					SetCVar("cameraDistanceMaxZoomFactor", 2.6)
				else
					SetCVar("cameraDistanceMaxZoomFactor", 1.9)
				end
			end

			-- Set camera zoom when option is clicked and on startup (if enabled)
			LeaPlusCB["MaxCameraZoom"]:HookScript("OnClick", SetZoom)
			if LeaPlusLC["MaxCameraZoom"] == "On" then SetZoom() end

		end

		----------------------------------------------------------------------
		-- Universal group chat color (no reload required)
		----------------------------------------------------------------------

		do

			-- Function to set chat colors
			local function SetCol()
				if LeaPlusLC["UnivGroupColor"] == "On" then
					ChangeChatColor("RAID", 0.67, 0.67, 1)
					ChangeChatColor("RAID_LEADER", 0.46, 0.78, 1)
					ChangeChatColor("INSTANCE_CHAT", 0.67, 0.67, 1)
					ChangeChatColor("INSTANCE_CHAT_LEADER", 0.46, 0.78, 1)
				else
					ChangeChatColor("RAID", 1, 0.50, 0)
					ChangeChatColor("RAID_LEADER", 1, 0.28, 0.04)
					ChangeChatColor("INSTANCE_CHAT", 1, 0.50, 0)
					ChangeChatColor("INSTANCE_CHAT_LEADER", 1, 0.28, 0.04)
				end
			end

			-- Set chat colors when option is clicked and on startup (if enabled)
			LeaPlusCB["UnivGroupColor"]:HookScript("OnClick", SetCol)
			if LeaPlusLC["UnivGroupColor"] == "On" then	SetCol() end

		end

		----------------------------------------------------------------------
		-- Minimap button (no reload required)
		----------------------------------------------------------------------

		do

			-- Minimap button click function
			local function MiniBtnClickFunc(arg1)

				-- Prevent options panel from showing if Blizzard options panel is showing
				if InterfaceOptionsFrame:IsShown() or VideoOptionsFrame:IsShown() or ChatConfigFrame:IsShown() then return end
				-- Prevent options panel from showing if Blizzard Store is showing
				if StoreFrame and StoreFrame:GetAttribute("isshown") then return end
				-- Left button down
				if arg1 == "LeftButton" then

					-- Control key modifier toggles target tracking
					if IsControlKeyDown() and not IsShiftKeyDown() then
						for i = 1, GetNumTrackingTypes() do
							local name, texture, active, category = GetTrackingInfo(i)
							if name == MINIMAP_TRACKING_TARGET then
								if active then
									SetTracking(i, false)
									ActionStatus_DisplayMessage(L["Target Tracking Disabled"], true);
								else
									SetTracking(i, true)
									ActionStatus_DisplayMessage(L["Target Tracking Enabled"], true);
								end
							end
						end
						return
					end

					-- Shift key modifier toggles the music
					if IsShiftKeyDown() and not IsControlKeyDown() then
						Sound_ToggleMusic();
						return
					end

					-- Shift key and control key toggles Zygor addon
					if IsShiftKeyDown() and IsControlKeyDown() then
						LeaPlusLC:ZygorToggle();
						return
					end

					-- No modifier key toggles the options panel
					if LeaPlusLC:IsPlusShowing() then
						LeaPlusLC:HideFrames()
						LeaPlusLC:HideConfigPanels()
					else
						LeaPlusLC:HideFrames()
						LeaPlusLC["PageF"]:Show()
					end
					LeaPlusLC["Page"..LeaPlusLC["LeaStartPage"]]:Show()
				end

				-- Right button down
				if arg1 == "RightButton" then

					-- Control key modifier toggles error messages
					if IsControlKeyDown() and not IsShiftKeyDown() then
						if LeaPlusDB["HideErrorMessages"] == "On" then -- Checks global
							if LeaPlusLC["ShowErrorsFlag"] == 1 then 
								LeaPlusLC["ShowErrorsFlag"] = 0
								ActionStatus_DisplayMessage(L["Error messages will be shown"], true);
							else
								LeaPlusLC["ShowErrorsFlag"] = 1
								ActionStatus_DisplayMessage(L["Error messages will be hidden"], true);
							end
							return
						end
						return
					end

					-- Shift key and control key toggles maximised window mode
					if IsShiftKeyDown() and IsControlKeyDown() then
						if LeaPlusLC:PlayerInCombat() then
							return
						else
							SetCVar("gxMaximize", tostring(1 - GetCVar("gxMaximize")));
							RestartGx();
						end
						return
					end

					-- No modifier key toggles the options panel
					if LeaPlusLC:IsPlusShowing() then
						LeaPlusLC:HideFrames()
						LeaPlusLC:HideConfigPanels()
					else
						LeaPlusLC:HideFrames()
						LeaPlusLC["PageF"]:Show()
					end
					LeaPlusLC["Page" .. LeaPlusLC["LeaStartPage"]]:Show()

				end

			end

			-- Create minimap button
			if LibStub and LibStub("LibDBIcon-1.0", true) and LibStub("CallbackHandler-1.0", true) and LibStub("LibDataBroker-1.1", true) then

				-- LibDBIcon is being used so create LibDBIcon button
				local ldb = LibStub("LibDataBroker-1.1", true)
				local miniButton = ldb:NewDataObject("Leatrix_Plus", {
					type = "launcher",
					icon = "Interface\\HELPFRAME\\ReportLagIcon-Movement",
					OnClick = function(self, btn)
						MiniBtnClickFunc(btn)
					end,
					OnTooltipShow = function(tooltip)
						if not tooltip or not tooltip.AddLine then return end
						tooltip:AddLine("Leatrix Plus")
					end,
				})
				local icon = LibStub("LibDBIcon-1.0", true)
				icon:Register("Leatrix_Plus", miniButton, LeaPlusDB)

				-- Function to toggle LibDBIcon
				local function SetLibDBIconFunc()
					if LeaPlusLC["ShowMinimapIcon"] == "On" then
						icon:Show("Leatrix_Plus")
					else
						icon:Hide("Leatrix_Plus")
					end
				end

				-- Set LibDBIcon when option is clicked and on startup
				LeaPlusCB["ShowMinimapIcon"]:HookScript("OnClick", SetLibDBIconFunc)
				SetLibDBIconFunc()

			end

		end

		----------------------------------------------------------------------
		-- Auction House Extras
		----------------------------------------------------------------------

		if LeaPlusLC["AhExtras"] == "On" then

			local function AuctionFunc()

				-- Set default auction duration and price type values to saved settings or default settings
				AuctionFrameAuctions.duration = LeaPlusDB["AHDuration"] or 3
				AuctionFrameAuctions.priceType = LeaPlusDB["AHPriceType"] or 2

				-- Functions
				local function CreateAuctionCB(name, anchor, x, y, text)
					LeaPlusCB[name] = CreateFrame("CheckButton", nil, AuctionFrameAuctions, "OptionsCheckButtonTemplate")
					LeaPlusCB[name]:SetFrameStrata("HIGH")
					LeaPlusCB[name]:SetSize(20, 20)
					LeaPlusCB[name]:SetPoint(anchor, x, y)
					LeaPlusCB[name].f = LeaPlusCB[name]:CreateFontString(nil, 'OVERLAY', "GameFontNormal")
					LeaPlusCB[name].f:SetPoint("LEFT", 20, 0)
					LeaPlusCB[name].f:SetText(L[text])
					LeaPlusCB[name].f:Show();
					LeaPlusCB[name]:SetScript('OnClick', function()
						if LeaPlusCB[name]:GetChecked() then
							LeaPlusLC[name] = "On"
						else
							LeaPlusLC[name] = "Off"
						end
					end)
					LeaPlusCB[name]:SetScript('OnShow', function(self)
						if LeaPlusLC[name] == "On" then
							self:SetChecked(true)
						else
							self:SetChecked(false)
						end
					end)
				end

				-- Show the correct fields in the AH frame and match prices
				local function SetupAh()
					if LeaPlusLC["AhBuyoutOnly"] == "On" then
						-- Hide the start price
						StartPrice:SetAlpha(0);
						-- Set start price to buyout price 
						StartPriceGold:SetText(BuyoutPriceGold:GetText());
						StartPriceSilver:SetText(BuyoutPriceSilver:GetText());
						StartPriceCopper:SetText(BuyoutPriceCopper:GetText());
					else
						-- Show the start price
						StartPrice:SetAlpha(1);
					end
					-- If gold only is on, set copper and silver to 99
					if LeaPlusLC["AhGoldOnly"] == "On" then
						StartPriceCopper:SetText("99"); StartPriceCopper:Disable();
						StartPriceSilver:SetText("99"); StartPriceSilver:Disable();
						BuyoutPriceCopper:SetText("99"); BuyoutPriceCopper:Disable();
						BuyoutPriceSilver:SetText("99"); BuyoutPriceSilver:Disable();
					else
						StartPriceCopper:Enable();
						StartPriceSilver:Enable();
						BuyoutPriceCopper:Enable();
						BuyoutPriceSilver:Enable();
					end
					-- Validate the auction (mainly for the create auction button status)
					AuctionsFrameAuctions_ValidateAuction();
				end

				-- Create checkboxes
				CreateAuctionCB("AhBuyoutOnly", "BOTTOMLEFT", 200, 16, "Buyout Only")
				CreateAuctionCB("AhGoldOnly", "BOTTOMLEFT", 320, 16, "Gold Only")

				-- Reposition Gold Only checkbox so it does not overlap Buyout Only checkbox label
				LeaPlusCB["AhGoldOnly"]:ClearAllPoints()
				LeaPlusCB["AhGoldOnly"]:SetPoint("LEFT", LeaPlusCB["AhBuyoutOnly"].f, "RIGHT", 20, 0)

				-- Set click boundaries
				LeaPlusCB["AhBuyoutOnly"]:SetHitRectInsets(0, -LeaPlusCB["AhBuyoutOnly"].f:GetStringWidth() + 6, 0, 0);
				LeaPlusCB["AhGoldOnly"]:SetHitRectInsets(0, -LeaPlusCB["AhGoldOnly"].f:GetStringWidth() + 6, 0, 0);

				LeaPlusCB["AhBuyoutOnly"]:HookScript('OnClick', SetupAh);
				LeaPlusCB["AhBuyoutOnly"]:HookScript('OnShow', SetupAh);
	
				AuctionFrameAuctions:HookScript("OnShow", SetupAh)
				BuyoutPriceGold:HookScript("OnTextChanged", SetupAh)
				BuyoutPriceSilver:HookScript("OnTextChanged", SetupAh)
				BuyoutPriceCopper:HookScript("OnTextChanged", SetupAh)
				StartPriceGold:HookScript("OnTextChanged", SetupAh)
				StartPriceSilver:HookScript("OnTextChanged", SetupAh)
				StartPriceCopper:HookScript("OnTextChanged", SetupAh)
	
				-- Lock the create auction button if buyout gold box is empty (when using buyout only and gold only)
				AuctionsCreateAuctionButton:HookScript("OnEnable", function()
					if LeaPlusLC["AhGoldOnly"] == "On" and LeaPlusLC["AhBuyoutOnly"] == "On" then
						if BuyoutPriceGold:GetText() == "" then
							AuctionsCreateAuctionButton:Disable();
						end
					end
				end)
				
				-- Clear copper and silver prices if gold only box is unchecked
				LeaPlusCB["AhGoldOnly"]:HookScript('OnClick', function()
					if LeaPlusCB["AhGoldOnly"]:GetChecked() == false then
						BuyoutPriceCopper:SetText("")
						BuyoutPriceSilver:SetText("")
						StartPriceCopper:SetText("")
						StartPriceSilver:SetText("")
					end
					SetupAh();
				end)

				-- Create find button
				AuctionsItemText:Hide()
				LeaPlusLC:CreateButton("FindAuctionButton", AuctionsStackSizeMaxButton, "Find Item", "CENTER", 0, 74, 0, 21, false, "")
				LeaPlusCB["FindAuctionButton"]:SetParent(AuctionFrameAuctions)

				-- Show find button when the auctions tab is shown
				AuctionFrameAuctions:HookScript("OnShow", function() 
					LeaPlusCB["FindAuctionButton"]:SetEnabled(GetAuctionSellItemInfo() and true or false)
				end)

				-- Show find button when a new item is added
				AuctionsItemButton:HookScript("OnEvent", function(self, event)
					if event == "NEW_AUCTION_UPDATE" then
						LeaPlusCB["FindAuctionButton"]:SetEnabled(GetAuctionSellItemInfo() and true or false)
					end
				end)

				LeaPlusCB["FindAuctionButton"]:SetScript("OnClick", function()
					if GetAuctionSellItemInfo() then
						if BrowseWowTokenResults:IsShown() then
							-- Stop if Game Time filter is currently shown
							AuctionFrameTab1:Click()
							LeaPlusLC:Print("To use the Find button, you need to deselect the Game Time filter.")
						else
							-- Otherwise, search for the required item
							local name = GetAuctionSellItemInfo()
							BrowseName:SetText(name)
							ExactMatchCheckButton:SetChecked(true) -- Necessary for scrolling through results pages with exact match
							QueryAuctionItems(name, 0, 0, 0, 0, 0, false, true, 0)
							AuctionFrameTab1:Click()
						end
					end
				end)

				-- Clear the cursor and reset editboxes when a new item replaces an existing one
				hooksecurefunc("AuctionsFrameAuctions_ValidateAuction", function()
					if GetAuctionSellItemInfo() then
						-- Return anything you might be holding
						ClearCursor();
						-- Set copper and silver prices to 99 if gold mode is on
						if LeaPlusLC["AhGoldOnly"] == "On" then
							StartPriceCopper:SetText("99")
							StartPriceSilver:SetText("99")
							BuyoutPriceCopper:SetText("99")
							BuyoutPriceSilver:SetText("99")
						end
					end
				end)
      
				-- Clear gold editbox after an auction has been created (to force user to enter something)
				AuctionsCreateAuctionButton:HookScript("OnClick", function()
					StartPriceGold:SetText("")
					BuyoutPriceGold:SetText("")
				end)

				-- Set tab key actions (if different from defaults)
				StartPriceGold:HookScript("OnTabPressed", function()
					if not IsShiftKeyDown() then
						if LeaPlusLC["AhBuyoutOnly"] == "Off" and LeaPlusLC["AhGoldOnly"] == "On" then
							BuyoutPriceGold:SetFocus()
						end
					end
				end)

				BuyoutPriceGold:HookScript("OnTabPressed", function()
					if IsShiftKeyDown() then
						if LeaPlusLC["AhBuyoutOnly"] == "Off" and LeaPlusLC["AhGoldOnly"] == "On" then
							StartPriceGold:SetFocus()
						end
					end
				end)
			end

			-- Run function when Blizzard addon is loaded
			if IsAddOnLoaded("Blizzard_AuctionUI") then
				AuctionFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_AuctionUI" then
						AuctionFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

		end

		----------------------------------------------------------------------
		-- Show volume control on character sheet
		----------------------------------------------------------------------

		if LeaPlusLC["ShowVolume"] == "On" then

			-- Function to update master volume
			local function MasterVolUpdate()
				if LeaPlusLC["ShowVolume"] == "On" then
					-- Set the volume
					SetCVar("Sound_MasterVolume", LeaPlusLC["LeaPlusMaxVol"]);
					-- Format the slider text
					LeaPlusCB["LeaPlusMaxVol"].f:SetFormattedText("%.0f", LeaPlusLC["LeaPlusMaxVol"] * 20)
				end
			end

			-- Create slider control
			LeaPlusLC["LeaPlusMaxVol"] = tonumber(GetCVar("Sound_MasterVolume"));
			LeaPlusLC:MakeSL(CharacterModelFrame, "LeaPlusMaxVol", "",	0, 1, 0.05, -34, -328, "%.2f")
			LeaPlusCB["LeaPlusMaxVol"]:SetWidth(64)

			-- Set slider control value when shown
			LeaPlusCB["LeaPlusMaxVol"]:SetScript("OnShow", function()
				LeaPlusCB["LeaPlusMaxVol"]:SetValue(GetCVar("Sound_MasterVolume"))
			end)

			-- Update volume when slider control is changed
			LeaPlusCB["LeaPlusMaxVol"]:HookScript("OnValueChanged", function()
				if IsMouseButtonDown("RightButton") and IsShiftKeyDown() then 
					-- Dual layout is active so don't adjust slider
					LeaPlusCB["LeaPlusMaxVol"].f:SetFormattedText("%.0f", LeaPlusLC["LeaPlusMaxVol"] * 20)
					LeaPlusCB["LeaPlusMaxVol"]:Hide()
					LeaPlusCB["LeaPlusMaxVol"]:Show()
					return
				else
					-- Set sound level and refresh slider
					MasterVolUpdate()
				end
			end)

			-- Dual layout
			local function SetVolumePlacement()
				if LeaPlusLC["ShowVolumeInFrame"] == "On" then
					LeaPlusCB["LeaPlusMaxVol"]:ClearAllPoints();
					LeaPlusCB["LeaPlusMaxVol"]:SetPoint("TOPLEFT", 72, -276)
				else
					LeaPlusCB["LeaPlusMaxVol"]:ClearAllPoints();
					LeaPlusCB["LeaPlusMaxVol"]:SetPoint("TOPLEFT", -34, -328)
				end
			end

			LeaPlusCB["LeaPlusMaxVol"]:SetScript('OnMouseDown', function(self, btn)
				if btn == "RightButton" and IsShiftKeyDown() then
					if LeaPlusLC["ShowVolumeInFrame"] == "On" then LeaPlusLC["ShowVolumeInFrame"] = "Off" else LeaPlusLC["ShowVolumeInFrame"] = "On" end
					SetVolumePlacement();
				end
			end)

			CharacterModelFrame:HookScript("OnShow",function()
				SetVolumePlacement();
			end)

		end

		----------------------------------------------------------------------
		--	Use arrow keys in chat
		----------------------------------------------------------------------

		if LeaPlusLC["UseArrowKeysInChat"] == "On" then
			-- Enable arrow keys for normal and existing chat frames
			for i = 1, 50 do
				if _G["ChatFrame" .. i] then
					_G["ChatFrame" .. i .. "EditBox"]:SetAltArrowKeyMode(false)
				end
			end
			-- Enable arrow keys for temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function()
				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then
					_G[cf .. "EditBox"]:SetAltArrowKeyMode(false)
				end
			end)
		end

		----------------------------------------------------------------------
		-- Hide social button
		----------------------------------------------------------------------

		if LeaPlusLC["NoSocialButton"] == "On" then
			-- Create hidden frame to store social button
			local tframe = CreateFrame("FRAME")
			tframe:Hide()
			QuickJoinToastButton:SetParent(tframe)
		end

		----------------------------------------------------------------------
		-- L42: Manage frames
		----------------------------------------------------------------------

		-- Frame Movement
		if LeaPlusLC["FrmEnabled"] == "On" then

			-- Lock the player and target frames
			PlayerFrame_SetLocked(true)
			TargetFrame_SetLocked(true)

			-- Remove integrated movement functions to avoid conflicts
			_G.PlayerFrame_ResetUserPlacedPosition = function() end
			_G.TargetFrame_ResetUserPlacedPosition = function() end
			_G.PlayerFrame_SetLocked = function() end
			_G.TargetFrame_SetLocked = function() end

			-- Replace specific movement functions
			local buffSetPos = BuffFrame.SetPoint
			local powerBarAltSetPos = PlayerPowerBarAlt.SetPoint

			-- Create frame table (used for local traversal)
			local FrameTable = {DragPlayerFrame = PlayerFrame, DragTargetFrame = TargetFrame, DragGhostFrame = GhostFrame, DragMirrorTimer1 = MirrorTimer1, DragUIWidgetTopCenterContainerFrame = UIWidgetTopCenterContainerFrame, DragBuffFrame = BuffFrame, DragPlayerPowerBarAlt = PlayerPowerBarAlt}

			-- Create main table structure in saved variables if it doesn't exist
			if (LeaPlusDB["Frames"]) == nil then
				LeaPlusDB["Frames"] = {}
			end

			-- Create frame based table structure in saved variables if it doesn't exist and set initial scales
			for k,v in pairs(FrameTable) do
				local vf = v:GetName();
				-- Create frame table structure if it doesn't exist
				if not LeaPlusDB["Frames"][vf] then
					LeaPlusDB["Frames"][vf] = {}
				end
				-- Set saved scale value to default if it doesn't exist
				if not LeaPlusDB["Frames"][vf]["Scale"] then
					LeaPlusDB["Frames"][vf]["Scale"] = 1.00;
				end
				-- Set frame scale to saved value
				_G[vf]:SetScale(LeaPlusDB["Frames"][vf]["Scale"])
			end

			-- Set cached status
			local function LeaPlusFramesSaveCache(frame)
				if frame == "PlayerFrame" or frame == "TargetFrame" then
					_G[frame]:SetUserPlaced(true);
				else
					_G[frame]:SetUserPlaced(false);
				end
			end

			-- Set frames to manual values
			local function LeaFramesSetPos(frame, point, parent, relative, xoff, yoff)
				frame:SetMovable(true);
				frame:ClearAllPoints();
				if frame:GetName() == "BuffFrame" then
					buffSetPos(BuffFrame, point, parent, relative, xoff, yoff)
				elseif frame:GetName() == "PlayerPowerBarAlt" then
					powerBarAltSetPos(PlayerPowerBarAlt, point, parent, relative, xoff, yoff)
				else
					frame:SetPoint(point, parent, relative, xoff, yoff)
				end
			end

			-- Set frames to default values
			local function LeaPlusFramesDefaults()
				LeaFramesSetPos(PlayerFrame						, "TOPLEFT"	, UIParent, "TOPLEFT"	, -19, -4)
				LeaFramesSetPos(TargetFrame						, "TOPLEFT"	, UIParent, "TOPLEFT"	, 250, -4)
				LeaFramesSetPos(GhostFrame						, "TOP"		, UIParent, "TOP"		, -5, -29)
				LeaFramesSetPos(MirrorTimer1					, "TOP"		, UIParent, "TOP"		, -5, -96)
				LeaFramesSetPos(UIWidgetTopCenterContainerFrame	, "TOP"		, UIParent, "TOP"		, 0, -15)
				LeaFramesSetPos(BuffFrame						, "TOPRIGHT", UIParent, "TOPRIGHT"	, -205, -13)
				LeaFramesSetPos(PlayerPowerBarAlt				, "BOTTOM"	, UIParent, "BOTTOM"	, 0, 115)
			end

			-- Create configuration panel
			local SideFrames = LeaPlusLC:CreatePanel("Frames", "SideFrames")

			-- Variable used to store currently selected frame
			local currentframe

			-- Create scale title
			LeaPlusLC:MakeTx(SideFrames, "Scale", 16, -72)
			
			-- Set initial slider value (will be changed when drag frames are selected)
			LeaPlusLC["FrameScale"] = 1.00

			-- Create scale slider
			LeaPlusLC:MakeSL(SideFrames, "FrameScale", "", 0.5, 3.0, 0.05, 16, -92, "%.2f")
			LeaPlusCB["FrameScale"]:HookScript("OnValueChanged", function(self, value)
				if currentframe then -- If a frame is selected
					-- Set real and drag frame scale
					LeaPlusDB["Frames"][currentframe]["Scale"] = value;
					_G[currentframe]:SetScale(LeaPlusDB["Frames"][currentframe]["Scale"]);
					LeaPlusLC["Drag" .. currentframe]:SetScale(LeaPlusDB["Frames"][currentframe]["Scale"]);
					-- If target frame scale is changed, also change combo point frame
					if currentframe == "TargetFrame" then
						ComboFrame:SetScale(LeaPlusDB["Frames"]["TargetFrame"]["Scale"]);
					end
					-- If buff frame scale is changed, also change temporary enchant frame
					if currentframe == "BuffFrame" then
						TemporaryEnchantFrame:SetScale(LeaPlusDB["Frames"]["BuffFrame"]["Scale"]);
					end
					-- Set slider formatted text
					LeaPlusCB["FrameScale"].f:SetFormattedText("%.0f%%", LeaPlusLC["FrameScale"] * 100)
				end
			end)

			-- Set initial scale slider state and value
			LeaPlusCB["FrameScale"]:HookScript("OnShow", function()
				if not currentframe then
					-- No frame selected so select the player frame
					currentframe = PlayerFrame:GetName()
					LeaPlusLC["DragPlayerFrame"].t:SetColorTexture(0.0, 1.0, 0.0,0.5)
				end
				-- Set the scale slider value to the selected frame
				LeaPlusCB["FrameScale"]:SetValue(LeaPlusDB["Frames"][currentframe]["Scale"])
				-- Set slider formatted text
				LeaPlusCB["FrameScale"].f:SetFormattedText("%.0f%%", LeaPlusLC["FrameScale"] * 100)
			end)

			-- Help button tooltip
			SideFrames.h.tiptext = L["Drag the frame overlays to position the frames.|n|nTo change the scale of a frame, click it to select it then adjust the scale slider.|n|nThis panel will close automatically if you enter combat."]

			-- Back button handler
			SideFrames.b:SetScript("OnClick", function()
				-- Hide outer control frame
				SideFrames:Hide();
				-- Hide drag frames
				for k, void in pairs(FrameTable) do
					LeaPlusLC[k]:Hide();
				end
				-- Show options panel at frame section
				LeaPlusLC["PageF"]:Show();
				LeaPlusLC["Page6"]:Show();
			end) 

			-- Reset button handler
			SideFrames.r:SetScript("OnClick", function()
				if LeaPlusLC:PlayerInCombat() then
					-- If player is in combat, print error and stop
					return
				else
					-- Set frames to default positions (presets)
					LeaPlusFramesDefaults();
					for k,v in pairs(FrameTable) do
						local vf = v:GetName()
						-- Store frame locations
						LeaPlusDB["Frames"][vf]["Point"], void, LeaPlusDB["Frames"][vf]["Relative"], LeaPlusDB["Frames"][vf]["XOffset"], LeaPlusDB["Frames"][vf]["YOffset"] = _G[vf]:GetPoint();
						-- Reset real frame scales and save them
						LeaPlusDB["Frames"][vf]["Scale"] = 1.00;
						_G[vf]:SetScale(LeaPlusDB["Frames"][vf]["Scale"]);
						-- Reset drag frame scales
						LeaPlusLC[k]:SetScale(LeaPlusDB["Frames"][vf]["Scale"]);
					end
					-- Set combo frame scale to match target frame scale
					ComboFrame:SetScale(LeaPlusDB["Frames"]["TargetFrame"]["Scale"]);
					-- Set temporary enchant frame scale to match buff frame scale
					TemporaryEnchantFrame:SetScale(LeaPlusDB["Frames"]["BuffFrame"]["Scale"]);
					-- Set the scale slider value to the selected frame scale
					LeaPlusCB["FrameScale"]:SetValue(LeaPlusDB["Frames"][currentframe]["Scale"]);
					-- Refresh the panel
					SideFrames:Hide();SideFrames:Show();
				end
			end)

			-- Show drag frames with configuration panel
			SideFrames:HookScript("OnShow", function()
				for k, void in pairs(FrameTable) do
					LeaPlusLC[k]:Show();
				end
			end)
			SideFrames:HookScript("OnHide", function()
				for k, void in pairs(FrameTable) do
					LeaPlusLC[k]:Hide();
				end
			end)

			-- Save frame positions
			local function SaveAllFrames()
				for k, v in pairs(FrameTable) do
					local vf = v:GetName();
					-- Stop real frames from moving
					v:StopMovingOrSizing();
					-- Save frame positions
					LeaPlusDB["Frames"][vf]["Point"], void, LeaPlusDB["Frames"][vf]["Relative"], LeaPlusDB["Frames"][vf]["XOffset"], LeaPlusDB["Frames"][vf]["YOffset"] = v:GetPoint();
					v:SetPoint(LeaPlusDB["Frames"][vf]["Point"], UIParent, LeaPlusDB["Frames"][vf]["Relative"], LeaPlusDB["Frames"][vf]["XOffset"], LeaPlusDB["Frames"][vf]["YOffset"])
					LeaPlusFramesSaveCache(vf)
				end
			end

			-- Prevent changes during combat
			SideFrames:RegisterEvent("PLAYER_REGEN_DISABLED")
			SideFrames:SetScript("OnEvent", function()
				-- Hide controls frame
				SideFrames:Hide();
				-- Hide drag frames
				for k,void in pairs(FrameTable) do
					LeaPlusLC[k]:Hide();
				end
				-- Save frame positions
				SaveAllFrames();
			end)

			-- Create drag frames
			local function LeaPlusMakeDrag(dragframe,realframe)

				local dragframe = CreateFrame("Frame", nil);
				LeaPlusLC[dragframe] = dragframe
				dragframe:SetSize(realframe:GetSize())
				if realframe:GetName() == "BuffFrame" then
					dragframe:SetPoint("TOPRIGHT", realframe, "TOPRIGHT", 0, 2.5)
				elseif realframe:GetName() == "PlayerPowerBarAlt" then
					dragframe:SetPoint("CENTER", realframe, "CENTER", 0, 1)
				else
					dragframe:SetPoint("TOP", realframe, "TOP", 0, 2.5)
				end
				dragframe:SetBackdropColor(0.0, 0.5, 1.0);
				dragframe:SetBackdrop({ 
					edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
					tile = false, tileSize = 0, edgeSize = 16,
					insets = { left = 0, right = 0, top = 0, bottom = 0 }});
				dragframe:SetToplevel(true)

				-- Set frame clamps
				if realframe:GetName() == "BuffFrame" or realframe:GetName() == "PlayerPowerBarAlt" then
					realframe:SetClampedToScreen(true)
				else
					realframe:SetClampedToScreen(false)
				end

				-- Hide the drag frame and make real frame movable
				dragframe:Hide()
				realframe:SetMovable(true);

				-- Click handler
				dragframe:SetScript("OnMouseDown", function(self, btn)

					-- Start dragging if left clicked
					if btn == "LeftButton" then
						realframe:StartMoving()
					end

					-- Set all drag frames to blue then tint the selected frame to green
					for k,v in pairs(FrameTable) do
						LeaPlusLC[k].t:SetColorTexture(0.0, 0.5, 1.0, 0.5)
					end
					dragframe.t:SetColorTexture(0.0, 1.0, 0.0, 0.5)

					-- Set currentframe variable to selected frame and set the scale slider value
					currentframe = realframe:GetName();
					LeaPlusCB["FrameScale"]:SetValue(LeaPlusDB["Frames"][currentframe]["Scale"]);

				end)

				dragframe:SetScript("OnMouseUp", function()
					-- Save frame positions
					SaveAllFrames();
				end)
	
				dragframe.t = dragframe:CreateTexture()
				dragframe.t:SetAllPoints()
				dragframe.t:SetColorTexture(0.0, 0.5, 1.0, 0.5)
				dragframe.t:SetAlpha(0.5)

				dragframe.f = dragframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
				dragframe.f:SetPoint('CENTER', 0, 0)

				-- Add titles
				if realframe:GetName() == "PlayerFrame" 					then dragframe.f:SetText(L["Player"]) end
				if realframe:GetName() == "TargetFrame" 					then dragframe.f:SetText(L["Target"]) end
				if realframe:GetName() == "MirrorTimer1" 					then dragframe.f:SetText(L["Timer"]) end
				if realframe:GetName() == "GhostFrame" 						then dragframe.f:SetText(L["Ghost"]) end
				if realframe:GetName() == "UIWidgetTopCenterContainerFrame" then dragframe.f:SetText(L["Widget"] .. "|n" .. L["Top Center"]) end
				if realframe:GetName() == "BuffFrame" 						then dragframe.f:SetText(L["Buffs"]) end
				if realframe:GetName() == "PlayerPowerBarAlt" 				then dragframe.f:SetText(L["Power"]) end
				return LeaPlusLC[dragframe]

			end
			
			for k,v in pairs(FrameTable) do
				LeaPlusLC[k] = LeaPlusMakeDrag(k,v)
			end

			-- Set frame scales
			for k,v in pairs(FrameTable) do
				local vf = v:GetName();
				_G[vf]:SetScale(LeaPlusDB["Frames"][vf]["Scale"]);
				LeaPlusLC[k]:SetScale(LeaPlusDB["Frames"][vf]["Scale"]);
			end
			ComboFrame:SetScale(LeaPlusDB["Frames"]["TargetFrame"]["Scale"]);
			TemporaryEnchantFrame:SetScale(LeaPlusDB["Frames"]["BuffFrame"]["Scale"]);

			-- Load defaults first then overwrite with saved values if they exist
			LeaPlusFramesDefaults();
			if LeaPlusDB["Frames"] then
				for k,v in pairs(FrameTable) do
					local vf = v:GetName()
					if LeaPlusDB["Frames"][vf] then
						if LeaPlusDB["Frames"][vf]["Point"] and LeaPlusDB["Frames"][vf]["Relative"] and LeaPlusDB["Frames"][vf]["XOffset"] and LeaPlusDB["Frames"][vf]["YOffset"] then
							LeaPlusFramesSaveCache(vf)
							_G[vf]:ClearAllPoints();
							_G[vf]:SetPoint(LeaPlusDB["Frames"][vf]["Point"], UIParent, LeaPlusDB["Frames"][vf]["Relative"], LeaPlusDB["Frames"][vf]["XOffset"], LeaPlusDB["Frames"][vf]["YOffset"])
						end
					end
				end
			end

			-- Prevent changes to buff frame position
			hooksecurefunc(BuffFrame, "SetPoint", function()
				if LeaPlusDB["Frames"]["BuffFrame"]["Point"] and LeaPlusDB["Frames"]["BuffFrame"]["Relative"] and LeaPlusDB["Frames"]["BuffFrame"]["XOffset"] and LeaPlusDB["Frames"]["BuffFrame"]["YOffset"] then
					BuffFrame:ClearAllPoints()
					buffSetPos(BuffFrame, LeaPlusDB["Frames"]["BuffFrame"]["Point"], UIParent, LeaPlusDB["Frames"]["BuffFrame"]["Relative"], LeaPlusDB["Frames"]["BuffFrame"]["XOffset"], LeaPlusDB["Frames"]["BuffFrame"]["YOffset"])
				end
			end)

			-- Prevent changes to player power bar alt frame position
			hooksecurefunc(PlayerPowerBarAlt, "SetPoint", function()
				if LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["Point"] and LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["Relative"] and LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["XOffset"] and LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["YOffset"] then
					PlayerPowerBarAlt:ClearAllPoints()
					powerBarAltSetPos(PlayerPowerBarAlt, LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["Point"], UIParent, LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["Relative"], LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["XOffset"], LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["YOffset"])
				end
			end)

			-- Add move button
			LeaPlusCB["MoveFramesButton"]:SetScript("OnClick", function()
				if LeaPlusLC:PlayerInCombat() then
					return
				else
					if IsShiftKeyDown() and IsControlKeyDown() then
						-- Preset profile
						LeaFramesSetPos(PlayerFrame						, "TOPLEFT"	, UIParent, "TOPLEFT"	,	"-35"	, "-14")
						LeaFramesSetPos(TargetFrame						, "TOPLEFT"	, UIParent, "TOPLEFT"	,	"190"	, "-14")
						LeaFramesSetPos(GhostFrame						, "CENTER"	, UIParent, "CENTER"	,	"3"		, "-142")
						LeaFramesSetPos(MirrorTimer1					, "TOP"		, UIParent, "TOP"		,	"0"		, "-120")
						LeaFramesSetPos(UIWidgetTopCenterContainerFrame	, "TOP"		, UIParent, "TOP"		,	"0"		, "-542")
						LeaFramesSetPos(BuffFrame						, "TOPRIGHT", UIParent, "TOPRIGHT"	,	"-271"	, "0")
						LeaFramesSetPos(PlayerPowerBarAlt				, "CENTER"	, UIParent, "CENTER"	,	"0"		, "-160")
						LeaPlusDB["Frames"]["PlayerFrame"]["Scale"] = 1.20;
						PlayerFrame:SetScale(LeaPlusDB["Frames"]["PlayerFrame"]["Scale"]);
						LeaPlusLC["DragPlayerFrame"]:SetScale(LeaPlusDB["Frames"]["PlayerFrame"]["Scale"]);
						LeaPlusDB["Frames"]["TargetFrame"]["Scale"] = 1.20;
						TargetFrame:SetScale(LeaPlusDB["Frames"]["TargetFrame"]["Scale"]);
						LeaPlusLC["DragTargetFrame"]:SetScale(LeaPlusDB["Frames"]["TargetFrame"]["Scale"]);
						LeaPlusDB["Frames"]["BuffFrame"]["Scale"] = 0.80
						BuffFrame:SetScale(LeaPlusDB["Frames"]["BuffFrame"]["Scale"])
						LeaPlusLC["DragBuffFrame"]:SetScale(LeaPlusDB["Frames"]["BuffFrame"]["Scale"]);
						LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["Scale"] = 1.25
						PlayerPowerBarAlt:SetScale(LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["Scale"])
						LeaPlusLC["DragPlayerPowerBarAlt"]:SetScale(LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["Scale"]);
						-- Set the slider to the selected frame (if there is one)
						if currentframe then LeaPlusCB["FrameScale"]:SetValue(LeaPlusDB["Frames"][currentframe]["Scale"]); end
						-- Save locations
						for k,v in pairs(FrameTable) do
							local vf = v:GetName();
							LeaPlusDB["Frames"][vf]["Point"], void, LeaPlusDB["Frames"][vf]["Relative"], LeaPlusDB["Frames"][vf]["XOffset"], LeaPlusDB["Frames"][vf]["YOffset"] = _G[vf]:GetPoint();
							LeaPlusFramesSaveCache(vf);
						end
					else
						-- Show mover frame
						SideFrames:Show();
						LeaPlusLC:HideFrames();

						-- Find out if the UI has a non-standard scale
						if GetCVar("useuiscale") == "1" then
							LeaPlusLC["gscale"] = GetCVar("uiscale")
						else
							LeaPlusLC["gscale"] = 1
						end

						-- Set all scaled sizes
						for k,v in pairs(FrameTable) do
							LeaPlusLC[k]:SetWidth(v:GetWidth() * LeaPlusLC["gscale"])
							LeaPlusLC[k]:SetHeight(v:GetHeight() * LeaPlusLC["gscale"])
						end

						-- Set specific scaled sizes for stubborn frames
						LeaPlusLC["DragMirrorTimer1"]:SetSize(206 * LeaPlusLC["gscale"], 50 * LeaPlusLC["gscale"]);
						LeaPlusLC["DragGhostFrame"]:SetSize(130 * LeaPlusLC["gscale"], 46 * LeaPlusLC["gscale"]);
						LeaPlusLC["DragUIWidgetTopCenterContainerFrame"]:SetSize(160 * LeaPlusLC["gscale"], 79 * LeaPlusLC["gscale"]);
						LeaPlusLC["DragBuffFrame"]:SetSize(280 * LeaPlusLC["gscale"], 225 * LeaPlusLC["gscale"]);
						LeaPlusLC["DragPlayerPowerBarAlt"]:SetSize(130 * LeaPlusLC["gscale"], 46 * LeaPlusLC["gscale"]);
					end
				end
			end)

		end

		----------------------------------------------------------------------
		-- Hide chat buttons
		----------------------------------------------------------------------

		if LeaPlusLC["NoChatButtons"] == "On" then

			-- Create hidden frame to store unwanted frames (more efficient than creating functions)
			local tframe = CreateFrame("FRAME")
			tframe:Hide()

			-- Function to enable mouse scrolling with CTRL and SHIFT key modifiers
			local function AddMouseScroll(chtfrm)
				if _G[chtfrm] then
					_G[chtfrm]:SetScript("OnMouseWheel", function(self, direction)
						if direction == 1 then
							if IsControlKeyDown() then
								self:ScrollToTop()
							elseif IsShiftKeyDown() then
								self:PageUp()
							else
								self:ScrollUp()
							end
						else
							if IsControlKeyDown() then
								self:ScrollToBottom()
							elseif IsShiftKeyDown() then
								self:PageDown()
							else
								self:ScrollDown()
							end
						end
					end)
					_G[chtfrm]:EnableMouseWheel(true)
				end
			end

			-- Function to hide chat buttons
			local function HideButtons(chtfrm)
				_G[chtfrm .. "ButtonFrameMinimizeButton"]:SetParent(tframe)
				_G[chtfrm .. "ButtonFrameMinimizeButton"]:Hide();
				_G[chtfrm .. "ButtonFrame"]:SetSize(0.1,0.1)
				_G[chtfrm].ScrollBar:SetParent(tframe)
				_G[chtfrm].ScrollBar:Hide()
			end

			-- Function to highlight chat tabs and click to scroll to bottom
			local function HighlightTabs(chtfrm)
				-- Set position of bottom button
				_G[chtfrm].ScrollToBottomButton.Flash:SetTexture("Interface/BUTTONS/GRADBLUE.png")
				_G[chtfrm].ScrollToBottomButton:ClearAllPoints()
				_G[chtfrm].ScrollToBottomButton:SetPoint("BOTTOM",_G[chtfrm .. "Tab"],0,-4)
				_G[chtfrm].ScrollToBottomButton:Show()
				_G[chtfrm].ScrollToBottomButton:SetWidth(_G[chtfrm .. "Tab"]:GetWidth() - 12)
				_G[chtfrm].ScrollToBottomButton:SetHeight(24)

				-- Resize bottom button according to tab size
				_G[chtfrm .. "Tab"]:SetScript("OnSizeChanged", function()
					for j = 1, 50 do
						-- Resize bottom button to tab width
						if _G["ChatFrame" .. j] and _G["ChatFrame" .. j].ScrollToBottomButton then
							_G["ChatFrame" .. j].ScrollToBottomButton:SetWidth(_G["ChatFrame" .. j .. "Tab"]:GetWidth() - 12)
						end
					end
					-- If combat log is hidden, resize it's bottom button
					if LeaPlusLC["NoCombatLogTab"] == "On" then
						if _G["ChatFrame2"].ScrollToBottomButton then
							-- Resize combat log bottom button
							_G["ChatFrame2"].ScrollToBottomButton:SetWidth(0.1);
						end
					end
				end)

				-- Remove click from the bottom button
				_G[chtfrm].ScrollToBottomButton:SetScript("OnClick", nil)

				-- Remove textures
				_G[chtfrm].ScrollToBottomButton:SetNormalTexture("")
				_G[chtfrm].ScrollToBottomButton:SetHighlightTexture("")
				_G[chtfrm].ScrollToBottomButton:SetPushedTexture("")

				-- Always scroll to bottom when clicking a tab
				_G[chtfrm .. "Tab"]:HookScript("OnClick", function(self,arg1)
					if arg1 == "LeftButton" then
						_G[chtfrm]:ScrollToBottom();
					end
				end)

			end

			-- Hide chat menu buttons
			ChatFrameMenuButton:SetParent(tframe)
			ChatFrameChannelButton:SetParent(tframe)
			ChatFrameToggleVoiceDeafenButton:SetParent(tframe)
			ChatFrameToggleVoiceMuteButton:SetParent(tframe)

			-- Set options for normal and existing chat frames
			for i = 1, 50 do
				if _G["ChatFrame" .. i] then
					AddMouseScroll("ChatFrame" .. i);
					HideButtons("ChatFrame" .. i);
					HighlightTabs("ChatFrame" .. i)
				end
			end

			-- Do the functions above for temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function(chatType)
				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then
					-- Set options for temporary frame
					AddMouseScroll(cf)
					HideButtons(cf)
					HighlightTabs(cf)
					-- Resize flashing alert to match tab width
					_G[cf .. "Tab"]:SetScript("OnSizeChanged", function()
						_G[cf].ScrollToBottomButton:SetWidth(_G[cf .. "Tab"]:GetWidth()-10)
					end)
				end
			end)

		end

		----------------------------------------------------------------------
		-- Recent chat window
		----------------------------------------------------------------------

		if LeaPlusLC["RecentChatWindow"] == "On" then

			-- Create recent chat frame (not parenting to UIParent due to editbox scaling issue)
			local editFrame = CreateFrame("ScrollFrame", nil, nil, "InputScrollFrameTemplate")

			-- Toggle frame with UIParent and pet battles
			local hideUI = false
			local function HideRecentChatFrame() if editFrame:IsShown() then hideUI = true editFrame:Hide() end	end
			local function ShowRecentChatFrame() if hideUI and not PetBattleFrame:IsShown() then editFrame:Show() hideUI = false end end
			hooksecurefunc(UIParent, "Hide", HideRecentChatFrame)
			hooksecurefunc(UIParent, "Show", ShowRecentChatFrame)
			hooksecurefunc("PetBattleFrame_Display", HideRecentChatFrame)
			hooksecurefunc("PetBattleFrame_Remove", ShowRecentChatFrame)

			-- Set frame parameters
			editFrame:ClearAllPoints()
			editFrame:SetPoint("BOTTOM", 0, 130)
			editFrame:SetSize(470, 170)
			editFrame:SetFrameStrata("MEDIUM")
			editFrame:SetToplevel(true)
			editFrame:Hide()
			editFrame.CharCount:Hide()

			-- Add background color
			editFrame.t = editFrame:CreateTexture(nil, "BACKGROUND")
			editFrame.t:SetAllPoints()
			editFrame.t:SetColorTexture(0.00, 0.00, 0.0, 0.6)

			-- Set textures
			editFrame.LeftTex:SetTexture(editFrame.RightTex:GetTexture()); editFrame.LeftTex:SetTexCoord(1, 0, 0, 1)
			editFrame.BottomTex:SetTexture(editFrame.TopTex:GetTexture()); editFrame.BottomTex:SetTexCoord(0, 1, 1, 0)
			editFrame.BottomRightTex:SetTexture(editFrame.TopRightTex:GetTexture()); editFrame.BottomRightTex:SetTexCoord(0, 1, 1, 0)
			editFrame.BottomLeftTex:SetTexture(editFrame.TopRightTex:GetTexture()); editFrame.BottomLeftTex:SetTexCoord(1, 0, 1, 0)
			editFrame.TopLeftTex:SetTexture(editFrame.TopRightTex:GetTexture()); editFrame.TopLeftTex:SetTexCoord(1, 0, 0, 1)

			-- Create editbox
			local editBox = editFrame.EditBox
			editBox:SetFontObject("ChatFontNormal")
			editBox:SetFont(editBox:GetFont(), 18 * UIParent:GetEffectiveScale())
			editBox:SetAltArrowKeyMode(false)
			editBox:SetTextInsets(4, 4, 4, 4)
			editBox:SetWidth(editFrame:GetWidth() - 30)

			-- Set font size when UI scale is changed
			editFrame:RegisterEvent("UI_SCALE_CHANGED")
			editFrame:SetScript("OnEvent", function()
				editBox:SetFont(editBox:GetFont(), 18 * UIParent:GetEffectiveScale())
			end)

			-- Close frame with right-click of editframe or editbox
			local function CloseRecentChatWindow()
				editBox:SetText("")
				editBox:ClearFocus()
				editFrame:Hide()
			end

			editFrame:SetScript("OnMouseDown", function(self, btn)
				if btn == "RightButton" then CloseRecentChatWindow() end
			end)

			editBox:SetScript("OnMouseDown", function(self, btn)
				if btn == "RightButton" then CloseRecentChatWindow() end
			end)

			-- Maintain editbox effective height
			editFrame:HookScript("OnVerticalScroll", function(self, offset)
				editBox:SetHitRectInsets(0, 0, offset, editBox:GetHeight() - offset - editBox:GetHeight())
			end)

			-- Disable text changes while still allowing editing controls to work
			editBox:EnableKeyboard(false)
			editBox:SetScript("OnKeyDown", function() end)

			--- Clear highlighted text if escape key is pressed
			editBox:HookScript("OnEscapePressed", function()
				editBox:HighlightText(0, 0)
				editBox:ClearFocus()
			end)

			-- Clear highlighted text and clear focus if enter key is pressed
			editBox:SetScript("OnEnterPressed", function() 
				editBox:HighlightText(0, 0)
				editBox:ClearFocus()
			end)

			-- Populate recent chat frame with chat messages
			local function ShowChatbox(chtfrm)
				editBox:SetText("")
				local NumMsg = chtfrm:GetNumMessages()
				local StartMsg = 1
				if NumMsg > 128 then StartMsg = NumMsg - 127 end
				local totalMsgCount = 0
				for iMsg = StartMsg, NumMsg do
					local chatMessage = chtfrm:GetMessageInfo(iMsg)
					if chatMessage then
						--chatMessage = gsub(chatMessage, "|T.-|t", "") -- Remove textures
						--chatMessage = gsub(chatMessage, "{.-}", "") -- Remove ellipsis
						editBox:Insert(chatMessage .. "|n")
					end
					totalMsgCount = totalMsgCount + 1
				end
				if totalMsgCount == 1 then
					editBox:Insert("|cff88aabb" .. totalMsgCount .. " " .. L["message shown."] .. "  ")
				else
					editBox:Insert("|cff88aabb" .. totalMsgCount .. " " .. L["messages shown."] .. "  ")
				end
				editBox:Insert(L["Right-click to close."])
				editFrame:SetVerticalScroll(0)
				C_Timer.After(0.1, function() editFrame.ScrollBar.ScrollDownButton:Click() end)
				editFrame:Show()
				editBox:ClearFocus()
			end

			-- Hook normal chat frame tab clicks
			for i = 1, 50 do
				if _G["ChatFrame" .. i] then
					_G["ChatFrame" .. i .. "Tab"]:HookScript("OnClick", function()
						if IsControlKeyDown() then
							ShowChatbox(_G["ChatFrame" .. i])
						end
					end)
				end
			end

			-- Hook temporary chat frame tab clicks
			hooksecurefunc("FCF_OpenTemporaryWindow", function()
				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then
					_G[cf .. "Tab"]:HookScript("OnClick", function()
						if IsControlKeyDown() then
							ShowChatbox(_G[cf])
						end
					end)
				end
			end)

		end

		----------------------------------------------------------------------
		--	Hide alerts
		----------------------------------------------------------------------

		if LeaPlusLC["NoAlerts"] == "On" then
			hooksecurefunc(AlertFrame, "RegisterEvent", function(self, event)
				AlertFrame:UnregisterEvent(event)
			end)
			AlertFrame:UnregisterAllEvents()
		end

		----------------------------------------------------------------------
		-- Show cooldowns
		----------------------------------------------------------------------

		if LeaPlusLC["ShowCooldowns"] == "On" then

			-- Create main table structure in saved variables if it doesn't exist
			if LeaPlusDB["Cooldowns"] == nil then
				LeaPlusDB["Cooldowns"] = {}
			end

			-- Create class tables if they don't exist
			for index = 1, GetNumClasses() do
				local classDisplayName, classTag, classID = GetClassInfo(index)
				if LeaPlusDB["Cooldowns"][classTag] == nil then
					LeaPlusDB["Cooldowns"][classTag] = {}
				end
			end

			-- Get current class and spec
			local PlayerClass = select(2, UnitClass("player"))
			local activeSpec = GetSpecialization() or 1

			-- Create local tables to store cooldown frames and editboxes
			local icon = {} -- Used to store cooldown frames
			local SpellEB = {} -- Used to store editbox values
			local iCount = 5 -- Number of cooldowns

			-- Create cooldown frames
			for i = 1, iCount do

				-- Create cooldown frame
				icon[i] = CreateFrame("Frame", nil, UIParent)
				icon[i]:SetFrameStrata("BACKGROUND")
				icon[i]:SetWidth(20)
				icon[i]:SetHeight(20)

				-- Create cooldown icon
				icon[i].c = CreateFrame("Cooldown", nil, icon[i], "CooldownFrameTemplate")
				icon[i].c:SetAllPoints()
				icon[i].c:SetReverse(true)

				-- Create blank texture (will be assigned a cooldown texture later)
				icon[i].t = icon[i]:CreateTexture(nil,"BACKGROUND")
				icon[i].t:SetAllPoints()

				-- Show icon above target frame and set initial scale
				icon[i]:ClearAllPoints()
				icon[i]:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 6 + (22 * (i - 1)), 5)
				icon[i]:SetScale(TargetFrame:GetScale())

				-- Show tooltip
				icon[i]:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 15, -25)
					GameTooltip:SetText(GetSpellInfo(LeaPlusCB["Spell" .. i]:GetText()))
				end)

				-- Hide tooltip
				icon[i]:SetScript("OnLeave", GameTooltip_Hide)

			end

			-- Change cooldown icon scale when target frame scale changes
			TargetFrame:HookScript("OnSizeChanged", function()
				for i = 1, iCount do
					icon[i]:SetScale(TargetFrame:GetScale())
				end
			end)

			-- Function to show cooldown textures in the cooldown frames (run when icons are loaded or changed)
			local function ShowIcon(i, id, owner)

				local void

				-- Get spell information
				local spell, void, path = GetSpellInfo(id)
				if spell and path then

					-- Set icon texture to the spell texture
					icon[i].t:SetTexture(path)

					-- Set top level and raise frame strata (ensures tooltips show properly)
					icon[i]:SetToplevel(true)
					icon[i]:SetFrameStrata("LOW")

					-- Handle events
					icon[i]:RegisterUnitEvent("UNIT_AURA", owner)
					icon[i]:RegisterUnitEvent("UNIT_PET", "player")
					icon[i]:SetScript("OnEvent", function(self, event, arg1)

						-- If pet was dismissed (or otherwise disappears such as when flying), hide pet cooldowns
						if event == "UNIT_PET" then
							if not UnitExists("pet") then
								if LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Pet"] then
									icon[i]:Hide()
								end
							end

						-- Ensure cooldown belongs to the owner we are watching (player or pet)
						elseif arg1 == owner then

							-- Hide the cooldown frame (required for cooldowns to disappear after the duration)
							icon[i]:Hide()

							-- If buff matches cooldown we want, start the cooldown
							for q = 1, 40 do
								local void, void, void, void, length, expire, void, void, void, spellID = UnitBuff(owner, q)
								if spellID and id == spellID then
									icon[i]:Show()
									local start = expire - length
									CooldownFrame_Set(icon[i].c, start, length, 1)
								end
							end

						end
					end)

				else

					-- Spell does not exist so stop watching it
					icon[i]:SetScript("OnEvent", nil)
					icon[i]:Hide()

				end

			end

			-- Create configuration panel
			local CooldownPanel = LeaPlusLC:CreatePanel("Cooldowns", "CooldownPanel")

			-- Function to refresh the editbox tooltip with the spell name
			local function RefSpellTip(self,elapsed)
				local spellinfo, void, icon = GetSpellInfo(self:GetText())
				if spellinfo and spellinfo ~= "" and icon ~= "" then
					GameTooltip:SetOwner(self, "ANCHOR_NONE")
					GameTooltip:ClearAllPoints()
					GameTooltip:SetPoint("RIGHT", self, "LEFT", -10, 0)
					GameTooltip:SetText("|T" .. icon .. ":0|t " .. spellinfo, nil, nil, nil, nil, true)
				else
					GameTooltip:Hide()
				end
			end

			-- Function to create spell ID editboxes and pet checkboxes
			local function MakeSpellEB(num, x, y, tab, shifttab)

				-- Create editbox for spell ID
                SpellEB[num] = LeaPlusLC:CreateEditBox("Spell" .. num, CooldownPanel, 70, 6, "TOPLEFT", x, y - 20, "Spell" .. tab, "Spell" .. shifttab)
				SpellEB[num]:SetNumeric(true)

				-- Set initial value (for current spec)
				SpellEB[num]:SetText(LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. num .. "Idn"] or "")

				-- Refresh tooltip when mouse is hovering over the editbox
				SpellEB[num]:SetScript("OnEnter", function()
					SpellEB[num]:SetScript("OnUpdate", RefSpellTip)
				end)
				SpellEB[num]:SetScript("OnLeave", function()
					SpellEB[num]:SetScript("OnUpdate", nil)
					GameTooltip:Hide()
				end)

				-- Create checkbox for pet cooldown
				LeaPlusLC:MakeCB(CooldownPanel, "Spell" .. num .."Pet", "", 462, y - 20, false, "")
				LeaPlusCB["Spell" .. num .."Pet"]:SetHitRectInsets(0, 0, 0, 0)

			end

			-- Add titles
			LeaPlusLC:MakeTx(CooldownPanel, "Spell ID", 384, -92)
			LeaPlusLC:MakeTx(CooldownPanel, "Pet", 462, -92)

			-- Add editboxes and checkboxes
			MakeSpellEB(1, 386, -92, "2", "5")
			MakeSpellEB(2, 386, -122, "3", "1")
			MakeSpellEB(3, 386, -152, "4", "2")
			MakeSpellEB(4, 386, -182, "5", "3")
			MakeSpellEB(5, 386, -212, "1", "4")

			-- Add checkboxes
			LeaPlusLC:MakeTx(CooldownPanel, "Settings", 16, -72)
			LeaPlusLC:MakeCB(CooldownPanel, "ShowCooldownID", "Show the spell ID in buff icon tooltips", 16, -92, false, "If checked, spell IDs will be shown in buff icon tooltips located in the buff frame and under the target frame.");
			LeaPlusLC:MakeCB(CooldownPanel, "NoCooldownDuration", "Hide cooldown duration numbers (if enabled)", 16, -112, false, "If checked, cooldown duration numbers will not be shown over the cooldowns.|n|nIf unchecked, cooldown duration numbers will be shown over the cooldowns if they are enabled in the game options panel ('ActionBars' menu).")

			-- Function to save the panel control settings and refresh the cooldown icons
			local function SavePanelControls()
				for i = 1, iCount do

					-- Refresh the cooldown texture
					icon[i].c:SetCooldown(0,0)

					-- Save control states to globals
					LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Idn"] = SpellEB[i]:GetText()
					LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Pet"] = LeaPlusCB["Spell" .. i .."Pet"]:GetChecked()

					-- Set cooldowns
					if LeaPlusCB["Spell" .. i .."Pet"]:GetChecked() then
						ShowIcon(i, tonumber(SpellEB[i]:GetText()), "pet")
					else
						ShowIcon(i, tonumber(SpellEB[i]:GetText()), "player")
					end

					-- Show or hide cooldown duration
					if LeaPlusLC["NoCooldownDuration"] == "On" then
						icon[i].c:SetHideCountdownNumbers(true)
					else
						icon[i].c:SetHideCountdownNumbers(false)
					end

					-- Show or hide cooldown icons depending on current buffs
					local newowner
					local newspell = tonumber(SpellEB[i]:GetText())

					if newspell then
						if LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Pet"] then 
							newowner = "pet" 
						else
							newowner = "player"
						end
						-- Hide cooldown icon
						icon[i]:Hide()

						-- If buff matches spell we want, show cooldown icon
						for q = 1, 40 do
							local void, void, void, void, length, expire, void, void, void, spellID = UnitBuff(newowner, q)
							if spellID and newspell == spellID then
								icon[i]:Show()
								-- Set the cooldown to the buff cooldown
								CooldownFrame_Set(icon[i].c, expire - length, length, 1)
							end
						end
					end

				end

			end

			-- Update cooldown icons when checkboxes are clicked
			LeaPlusCB["NoCooldownDuration"]:HookScript("OnClick", SavePanelControls)

			-- Help button tooltip
			CooldownPanel.h.tiptext = L["Enter the spell IDs for the cooldown icons that you want to see.|n|nIf a cooldown icon normally appears under the pet frame, check the pet checkbox.|n|nCooldown icons are saved to your class and specialisation."]

			-- Back button handler
			CooldownPanel.b:SetScript("OnClick", function()
				CooldownPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page5"]:Show()
				return
			end)

			-- Reset button handler
			CooldownPanel.r:SetScript("OnClick", function()
				-- Reset the checkboxes
				LeaPlusLC["ShowCooldownID"] = "On"
				LeaPlusLC["NoCooldownDuration"] = "On"
				for i = 1, iCount do
					-- Reset the panel controls
					SpellEB[i]:SetText("");
					LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Pet"] = false
					-- Hide cooldowns and clear scripts
					icon[i]:Hide()
					icon[i]:SetScript("OnEvent", nil)
				end
				CooldownPanel:Hide(); CooldownPanel:Show()
			end)

			-- Save settings when changed
			for i = 1, iCount do
				-- Set initial checkbox states
				LeaPlusCB["Spell" .. i .."Pet"]:SetChecked(LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Pet"])
				-- Set checkbox states when shown
				LeaPlusCB["Spell" .. i .."Pet"]:SetScript("OnShow", function()
					LeaPlusCB["Spell" .. i .."Pet"]:SetChecked(LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Pet"])
				end)
				-- Set states when changed
				SpellEB[i]:SetScript("OnTextChanged", SavePanelControls)
				LeaPlusCB["Spell" .. i .."Pet"]:SetScript("OnClick", SavePanelControls)
			end

			-- Show cooldowns on startup
			SavePanelControls()

			-- Show panel when configuration button is clicked
			LeaPlusCB["CooldownsButton"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- No preset profile
				else
					-- Show panel
					CooldownPanel:Show()
					LeaPlusLC:HideFrames()
				end
			end)

			-- Create spec tag banner fontstring
			local specTagSpecID = GetSpecialization()
			local specTagSpecInfoID, specTagName = GetSpecializationInfo(specTagSpecID)
			local specTagBanner = CooldownPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
			specTagBanner:SetPoint("TOPLEFT", 384, -72)
			specTagBanner:SetText(specTagName)

            -- Set controls when spec changes
            local swapFrame = CreateFrame("FRAME")
            swapFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
            swapFrame:SetScript("OnEvent", function()
				-- Store new spec
				activeSpec = GetSpecialization()
				-- Update controls for new spec
				for i = 1, iCount do
					SpellEB[i]:SetText(LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Idn"] or "")
					LeaPlusCB["Spell" .. i .. "Pet"]:SetChecked(LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Pet"] or false)
				end
				-- Update spec tag banner with new spec
				local specTagSpecInfoID, specTagName = GetSpecializationInfo(activeSpec)
				specTagBanner:SetText(specTagName)
				-- Refresh configuration panel
				if CooldownPanel:IsShown() then 
					CooldownPanel:Hide(); CooldownPanel:Show()
				end
				-- Save settings
				SavePanelControls()
            end)

			-- Function to show spell ID in tooltips
			local function CooldownIDFunc(unit, target, index)
				if LeaPlusLC["ShowCooldownID"] == "On" then
					local spellid = select(10, UnitAura(target, index))
					if spellid then
						GameTooltip:AddLine(L["Spell ID"] .. ": " .. spellid)
						GameTooltip:Show()
					end
				end
			end

			-- Add spell ID to tooltip when buff frame buffs are hovered
			hooksecurefunc(GameTooltip, 'SetUnitAura', CooldownIDFunc)   

			-- Add spell ID to tooltip when target frame buffs are hovered
			hooksecurefunc(GameTooltip, 'SetUnitBuff', CooldownIDFunc)

		end

		----------------------------------------------------------------------
		-- Lockout sharing
		----------------------------------------------------------------------

		if LeaPlusLC["LockoutSharing"] == "On" then
			-- Check the display menu option, update the game options panel and lockout changes
			ShowAccountAchievements(true)
			InterfaceOptionsPanel_CheckButton_Update(InterfaceOptionsSocialPanelShowAccountAchievments)
			InterfaceOptionsSocialPanelShowAccountAchievments:Disable()
			InterfaceOptionsSocialPanelShowAccountAchievments:SetAlpha(0.5)
			InterfaceOptionsSocialPanelShowAccountAchievmentsText:SetText(InterfaceOptionsSocialPanelShowAccountAchievmentsText:GetText() .. "|n" .. L["Managed by Leatrix Plus"])
		end

		----------------------------------------------------------------------
		-- Combat plates
		----------------------------------------------------------------------

		if LeaPlusLC["CombatPlates"] == "On" then

			-- Toggle nameplates with combat
			local f = CreateFrame("Frame")
			f:RegisterEvent("PLAYER_REGEN_DISABLED")
			f:RegisterEvent("PLAYER_REGEN_ENABLED")
			f:SetScript("OnEvent", function(self, event)
				SetCVar("nameplateShowEnemies", event == "PLAYER_REGEN_DISABLED" and 1 or 0)
			end)

			-- Run combat check on startup
			SetCVar("nameplateShowEnemies", UnitAffectingCombat("player") and 1 or 0)

		end

		----------------------------------------------------------------------
		-- Manage tooltip
		----------------------------------------------------------------------

		if LeaPlusLC["TipModEnable"] == "On" then

			----------------------------------------------------------------------
			--	Position the tooltip
			----------------------------------------------------------------------

			-- Position general tooltip
			hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
				if LeaPlusLC["TipMoveTip"] == "On" then
					if (not tooltip or not parent) then
						return
					end
					local a,b,c,d,e = tooltip:GetPoint()
					if a ~= "BOTTOMRIGHT" or c ~= "BOTTOMRIGHT" then
						tooltip:ClearAllPoints()
					end
					tooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", LeaPlusLC["TipOffsetX"], LeaPlusLC["TipOffsetY"]);
				end
			end)

			-- Position pet battle ability tooltips
			hooksecurefunc("PetBattleAbilityTooltip_Show", function(void, parent)
				if LeaPlusLC["TipMoveTip"] == "On" then
					if parent == UIParent then
						local a,b,c,d,e = PetBattlePrimaryAbilityTooltip:GetPoint()
						if a ~= "BOTTOMRIGHT" or c ~= "BOTTOMRIGHT" then
							PetBattlePrimaryAbilityTooltip:ClearAllPoints()
						end
						PetBattlePrimaryAbilityTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", LeaPlusLC["TipOffsetX"], LeaPlusLC["TipOffsetY"]);
					end
				end
			end)

			----------------------------------------------------------------------
			--	Tooltip Configuration
			----------------------------------------------------------------------

			local LT = {}

			-- Create locale specific level string
			LT["LevelLocale"] = strtrim(strtrim(string.gsub(TOOLTIP_UNIT_LEVEL, "%%s", "")))

			-- Tooltip
			LT["ColorBlind"] = GetCVar("colorblindMode")

			-- 	Create drag frame
			local TipDrag = CreateFrame("Frame", nil, UIParent)
			TipDrag:SetToplevel(true);
			TipDrag:SetClampedToScreen(false);
			TipDrag:SetSize(130, 64);
			TipDrag:Hide();
			TipDrag:SetFrameStrata("TOOLTIP")
			TipDrag:SetMovable(true)
			TipDrag:SetBackdropColor(0.0, 0.5, 1.0);
			TipDrag:SetBackdrop({ 
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = false, tileSize = 0, edgeSize = 16,
				insets = { left = 0, right = 0, top = 0, bottom = 0 }});

			-- Show text in drag frame
			TipDrag.f = TipDrag:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
			TipDrag.f:SetPoint("CENTER", 0, 0)
			TipDrag.f:SetText(L["Tooltip"])

			-- Create texture
			TipDrag.t = TipDrag:CreateTexture();
			TipDrag.t:SetAllPoints();
			TipDrag.t:SetColorTexture(0.0, 0.5, 1.0, 0.5);
			TipDrag.t:SetAlpha(0.5);

			---------------------------------------------------------------------------------------------------------
			-- Tooltip movement settings
			---------------------------------------------------------------------------------------------------------

			-- Create tooltip customisation side panel
			local SideTip = LeaPlusLC:CreatePanel("Tooltip", "SideTip")

			-- Add controls
			LeaPlusLC:MakeTx(SideTip, "Settings", 16, -72)
			LeaPlusLC:MakeCB(SideTip, "TipMoveTip", "Reposition the tooltip", 16, -92, false, "If checked, you will be able to reposition the tooltip.")
			LeaPlusLC:MakeCB(SideTip, "TipShowRank", "Show guild ranks for your guild", 16, -112, false, "If checked, guild ranks will be shown for players in your guild.")
			LeaPlusLC:MakeCB(SideTip, "TipShowTarget", "Show the unit's target", 16, -132, false, "If checked, unit targets will be shown.")
			LeaPlusLC:MakeCB(SideTip, "TipBackSimple", "Color the backdrops based on faction", 16, -152, false, "If checked, backdrops will be tinted blue (friendly) or red (hostile).")
			LeaPlusLC:MakeCB(SideTip, "TipHideInCombat", "Hide tooltips for world units during combat", 16, -172, false, "If checked, tooltips for world units will be hidden during combat.|n|nYou can hold the shift key down to override this setting.")

			LeaPlusLC:MakeTx(SideTip, "Scale", 356, -72)
			LeaPlusLC:MakeSL(SideTip, "LeaPlusTipSize", "", 0.50, 2.00, 0.05, 356, -92, "%.2f")

			-- Help button hidden
			SideTip.h:Hide()

			-- Back button handler
			SideTip.b:SetScript("OnClick", function() 
				SideTip:Hide();
				if TipDrag:IsShown() then
					TipDrag:Hide();
				end
				LeaPlusLC["PageF"]:Show();
				LeaPlusLC["Page5"]:Show();
				return
			end) 

			-- Reset button handler
			SideTip.r:SetScript("OnClick", function()
				LeaPlusLC["TipMoveTip"] = "On";
				LeaPlusLC["TipShowRank"] = "On";
				LeaPlusLC["TipShowTarget"] = "On";
				LeaPlusLC["TipBackSimple"] = "Off";
				LeaPlusLC["TipHideInCombat"] = "Off";
				LeaPlusLC["LeaPlusTipSize"] = 1.00
				LeaPlusLC["TipOffsetX"] = -13
				LeaPlusLC["TipOffsetY"] = 94
				TipDrag:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", LeaPlusLC["TipOffsetX"], LeaPlusLC["TipOffsetY"]);
				LeaPlusLC:SetTipScale()
				SideTip:Hide(); SideTip:Show();
			end)

			-- Show tooltip overlay only if reposition checkbox is checked
			LeaPlusCB["TipMoveTip"]:HookScript("OnClick", function()
				if LeaPlusLC["TipMoveTip"] == "On" then
					TipDrag:Show()
				else
					TipDrag:Hide()
				end
			end)

			-- Show drag frame with configuration panel
			SideTip:HookScript("OnShow", function()
				if LeaPlusLC["TipMoveTip"] == "On" then
					TipDrag:Show()
				end
			end)
			SideTip:HookScript("OnHide", function() TipDrag:Hide() end)

			-- Control movement functions
			local void, LTax, LTay, LTbx, LTby, LTcx, LTcy
			TipDrag:SetScript("OnMouseDown", function(self, btn)
				if btn == "LeftButton" then
					void, void, void, LTax, LTay = TipDrag:GetPoint()
					TipDrag:StartMoving()
					void, void, void, LTbx, LTby = TipDrag:GetPoint()
				end
			end)
			TipDrag:SetScript("OnMouseUp", function(self, btn)
				if btn == "LeftButton" then
					void, void, void, LTcx, LTcy = TipDrag:GetPoint()
					TipDrag:StopMovingOrSizing();
					LeaPlusLC["TipOffsetX"], LeaPlusLC["TipOffsetY"] = LTcx - LTbx + LTax, LTcy - LTby + LTay
					TipDrag:ClearAllPoints()
					TipDrag:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", LeaPlusLC["TipOffsetX"], LeaPlusLC["TipOffsetY"])
				end
			end)

			--	Move the tooltip
			LeaPlusCB["MoveTooltipButton"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["TipMoveTip"] = "On";
					LeaPlusLC["TipShowRank"] = "On";
					LeaPlusLC["TipShowTarget"] = "On";
					LeaPlusLC["TipBackSimple"] = "On";
					LeaPlusLC["TipHideInCombat"] = "Off";
					LeaPlusLC["LeaPlusTipSize"] = 1.25
					LeaPlusLC["TipOffsetX"] = -13
					LeaPlusLC["TipOffsetY"] = 94
					TipDrag:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", LeaPlusLC["TipOffsetX"], LeaPlusLC["TipOffsetY"]);
					LeaPlusLC:SetTipScale()
					LeaPlusLC:SetDim();
					LeaPlusLC:ReloadCheck();
					SideTip:Show(); SideTip:Hide(); -- Needed to update tooltip scale
					LeaPlusLC["PageF"]:Hide(); LeaPlusLC["PageF"]:Show();
				else
					-- Show tooltip configuration panel
					LeaPlusLC:HideFrames();
					SideTip:Show();

					-- Set scale
					TipDrag:SetScale(LeaPlusLC["LeaPlusTipSize"])

					-- Set position of the drag frame
					TipDrag:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", LeaPlusLC["TipOffsetX"], LeaPlusLC["TipOffsetY"])
				end			

			end)
					
			---------------------------------------------------------------------------------------------------------
			-- Tooltip scale settings
			---------------------------------------------------------------------------------------------------------

			-- Function to set the tooltip scale
			local function SetTipScale()
				if LeaPlusLC["TipModEnable"] == "On" then

					-- General tooltip
					if GameTooltip then GameTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Friends
					if FriendsTooltip then FriendsTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- AutoCompleteBox
					if AutoCompleteBox then AutoCompleteBox:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Reputation
					if ReputationParagonTooltip then ReputationParagonTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Pet battles and battle pets
					if PetBattlePrimaryAbilityTooltip then PetBattlePrimaryAbilityTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if PetBattlePrimaryUnitTooltip then PetBattlePrimaryUnitTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if BattlePetTooltip then BattlePetTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if FloatingBattlePetTooltip then FloatingBattlePetTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Garrison
					if FloatingGarrisonFollowerTooltip then FloatingGarrisonFollowerTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if FloatingGarrisonFollowerAbilityTooltip then FloatingGarrisonFollowerAbilityTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if FloatingGarrisonMissionTooltip then FloatingGarrisonMissionTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if FloatingGarrisonShipyardFollowerTooltip then FloatingGarrisonShipyardFollowerTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Order Hall
					if GarrisonFollowerMissionAbilityWithoutCountersTooltip then GarrisonFollowerMissionAbilityWithoutCountersTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if GarrisonFollowerAbilityWithoutCountersTooltip then GarrisonFollowerAbilityWithoutCountersTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Items (links, comparisons)
					if ItemRefTooltip then ItemRefTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if ItemRefShoppingTooltip1 then ItemRefShoppingTooltip1:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if ItemRefShoppingTooltip2 then ItemRefShoppingTooltip2:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if ShoppingTooltip1 then ShoppingTooltip1:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if ShoppingTooltip2 then ShoppingTooltip2:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- World map (objectives, story, comparisons)
					if WorldMapTooltip then WorldMapTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if WorldMapCompareTooltip1 then WorldMapCompareTooltip1:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if WorldMapCompareTooltip2 then WorldMapCompareTooltip2:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if QuestScrollFrame.WarCampaignTooltip then	QuestScrollFrame.WarCampaignTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if QuestScrollFrame.StoryTooltip then
						QuestScrollFrame.StoryTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
						QuestScrollFrame.StoryTooltip:SetFrameStrata("TOOLTIP")
					end

					-- Minimap (PVP queue status)
					if QueueStatusFrame then QueueStatusFrame:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Embedded item tooltip (as used in PVP UI)
					if EmbeddedItemTooltip then EmbeddedItemTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Nameplate tooltip
					if NamePlateTooltip then NamePlateTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Leatrix Plus
					TipDrag:SetScale(LeaPlusLC["LeaPlusTipSize"])

					-- Set slider formatted text
					LeaPlusCB["LeaPlusTipSize"].f:SetFormattedText("%.0f%%", LeaPlusLC["LeaPlusTipSize"] * 100)

				end
				return
			end

			-- Give function a file level scope
			LeaPlusLC.SetTipScale = SetTipScale

			-- Set tooltip scale when slider or checkbox changes and on startup
			LeaPlusCB["LeaPlusTipSize"]:HookScript("OnValueChanged", SetTipScale)
			SetTipScale()

			----------------------------------------------------------------------
			-- Contribution frame
			----------------------------------------------------------------------

			local function ContributionTipFunc()

				-- Function to set tooltip scale
				local function SetContributionTipScale()
					ContributionBuffTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
				end

				-- Set tooltip scale when slider changes and on startup
				LeaPlusCB["LeaPlusTipSize"]:HookScript("OnValueChanged", SetContributionTipScale)
				SetContributionTipScale()

			end

			-- Run function when Blizzard addon has loaded
			if IsAddOnLoaded("Blizzard_Contribution") then
				ContributionTipFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_Contribution" then
						ContributionTipFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			----------------------------------------------------------------------
			-- Pet Journal tooltips
			----------------------------------------------------------------------

			local function PetJournalTipFunc()

				-- Function to set tooltip scale
				local function SetPetJournalTipScale()
					PetJournalPrimaryAbilityTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
				end

				-- Set tooltip scale when slider changes and on startup
				LeaPlusCB["LeaPlusTipSize"]:HookScript("OnValueChanged", SetPetJournalTipScale)
				SetPetJournalTipScale()

			end

			-- Run function when Blizzard addon has loaded
			if IsAddOnLoaded("Blizzard_Collections") then
				PetJournalTipFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_Collections" then
						PetJournalTipFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			----------------------------------------------------------------------
			-- Encounter Journal tooltips
			----------------------------------------------------------------------

			local function EncounterJournalTipFunc()

				-- Function to set tooltip scale
				local function SetEncounterJournalTipScale()
					EncounterJournalTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
				end

				-- Set tooltip scale when slider changes and on startup
				LeaPlusCB["LeaPlusTipSize"]:HookScript("OnValueChanged", SetEncounterJournalTipScale)
				SetEncounterJournalTipScale()

			end

			-- Run function when Blizzard addon has loaded
			if IsAddOnLoaded("Blizzard_EncounterJournal") then
				EncounterJournalTipFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_EncounterJournal" then
						EncounterJournalTipFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			----------------------------------------------------------------------
			-- Death Recap frame tooltips
			----------------------------------------------------------------------

			local function DeathRecapFrameFunc()

				-- Simple fix to prevent mousing over units behind the frame
				DeathRecapFrame:EnableMouse(true)

			end

			-- Run function when Blizzard addon has loaded
			if IsAddOnLoaded("Blizzard_DeathRecap") then
				DeathRecapFrameFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_DeathRecap" then
						DeathRecapFrameFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			----------------------------------------------------------------------
			-- Garrison tooltips
			----------------------------------------------------------------------

			local function GarrisonFunc()

				-- Function to set tooltip scale
				local function SetGarrisonTipScale()
					GarrisonFollowerTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					GarrisonFollowerAbilityTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					GarrisonMissionMechanicTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					GarrisonMissionMechanicFollowerCounterTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					GarrisonBuildingFrame.BuildingLevelTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					GarrisonBonusAreaTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					GarrisonShipyardMapMissionTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					GarrisonShipyardFollowerTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
				end

				-- Set tooltip scale when slider changes and on startup
				LeaPlusCB["LeaPlusTipSize"]:HookScript("OnValueChanged", SetGarrisonTipScale)
				SetGarrisonTipScale()

			end

			-- Run function when Blizzard addon has loaded
			if IsAddOnLoaded("Blizzard_GarrisonUI") then
				GarrisonFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_GarrisonUI" then
						GarrisonFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			---------------------------------------------------------------------------------------------------------
			-- Other tooltip code
			---------------------------------------------------------------------------------------------------------

			-- Colorblind setting change
			TipDrag:RegisterEvent("CVAR_UPDATE");
			TipDrag:SetScript("OnEvent", function(self, event, arg1, arg2)
				if (arg1 == "USE_COLORBLIND_MODE") then
					LT["ColorBlind"] = arg2;
				end
			end)

			-- Store locals
			local TipMClass = LOCALIZED_CLASS_NAMES_MALE
			local TipFClass = LOCALIZED_CLASS_NAMES_FEMALE

			-- Level string
			local LevelString, LevelString2
			if GameLocale == "ruRU" then
				-- Level string for ruRU
				LevelString = "уровня"
				LevelString2 = "уровень"
			else
				-- Level string for all other locales
				LevelString = string.lower(TOOLTIP_UNIT_LEVEL:gsub("%%s",".+"))
				LevelString2 = ""
			end

			-- Tag locale (code construction from tiplang)
			local ttYou, ttLevel, ttBoss, ttElite, ttRare, ttRareElite, ttRareBoss, ttTarget
			if 		GameLocale == "zhCN" then 	ttYou = "您"		; ttLevel = "等级"		; ttBoss = "首领"	; ttElite = "精英"	; ttRare = "精良"	; ttRareElite = "精良 精英"		; ttRareBoss = "精良 首领"		; ttTarget = "目标"
			elseif 	GameLocale == "zhTW" then 	ttYou = "您"		; ttLevel = "等級"		; ttBoss = "首領"	; ttElite = "精英"	; ttRare = "精良"	; ttRareElite = "精良 精英"		; ttRareBoss = "精良 首領"		; ttTarget = "目標"
			elseif 	GameLocale == "ruRU" then 	ttYou = "ВЫ"	; ttLevel = "Уровень"	; ttBoss = "босс"	; ttElite = "элита"	; ttRare = "Редкое"	; ttRareElite = "Редкое элита"	; ttRareBoss = "Редкое босс"	; ttTarget = "Цель"
			elseif 	GameLocale == "koKR" then 	ttYou = "당신"	; ttLevel = "레벨"		; ttBoss = "우두머리"	; ttElite = "정예"	; ttRare = "희귀"	; ttRareElite = "희귀 정예"		; ttRareBoss = "희귀 우두머리"		; ttTarget = "대상"
			elseif 	GameLocale == "esMX" then 	ttYou = "TÚ"	; ttLevel = "Nivel"		; ttBoss = "Jefe"	; ttElite = "Élite"	; ttRare = "Raro"	; ttRareElite = "Raro Élite"	; ttRareBoss = "Raro Jefe"		; ttTarget = "Objetivo"
			elseif 	GameLocale == "ptBR" then 	ttYou = "VOCÊ"	; ttLevel = "Nível"		; ttBoss = "Chefe"	; ttElite = "Elite"	; ttRare = "Raro"	; ttRareElite = "Raro Elite"	; ttRareBoss = "Raro Chefe"		; ttTarget = "Alvo"
			elseif 	GameLocale == "deDE" then 	ttYou = "SIE"	; ttLevel = "Stufe"		; ttBoss = "Boss"	; ttElite = "Elite"	; ttRare = "Selten"	; ttRareElite = "Selten Elite"	; ttRareBoss = "Selten Boss"	; ttTarget = "Ziel"
			elseif 	GameLocale == "esES" then	ttYou = "TÚ"	; ttLevel = "Nivel"		; ttBoss = "Jefe"	; ttElite = "Élite"	; ttRare = "Raro"	; ttRareElite = "Raro Élite"	; ttRareBoss = "Raro Jefe"		; ttTarget = "Objetivo"
			elseif 	GameLocale == "frFR" then 	ttYou = "TOI"	; ttLevel = "Niveau"	; ttBoss = "Boss"	; ttElite = "Élite"	; ttRare = "Rare"	; ttRareElite = "Rare Élite"	; ttRareBoss = "Rare Boss"		; ttTarget = "Cible"
			elseif 	GameLocale == "itIT" then 	ttYou = "TU"	; ttLevel = "Livello"	; ttBoss = "Boss"	; ttElite = "Élite"	; ttRare = "Raro"	; ttRareElite = "Raro Élite"	; ttRareBoss = "Raro Boss"		; ttTarget = "Bersaglio"
			else 								ttYou = "YOU"	; ttLevel = "Level"		; ttBoss = "Boss"	; ttElite = "Elite"	; ttRare = "Rare"	; ttRareElite = "Rare Elite"	; ttRareBoss = "Rare Boss"		; ttTarget = "Target"
			end

			-- Show tooltip
			local function ShowTip()

				-- Do nothing if CTRL, SHIFT and ALT are being held
				if IsControlKeyDown() and IsAltKeyDown() and IsShiftKeyDown() then 
					return
				end

				-- Get unit information
				if GetMouseFocus() == WorldFrame then
					LT["Unit"] = "mouseover"
					-- Hide and quit if tips should be hidden during combat 
					if LeaPlusLC["TipHideInCombat"] == "On" and UnitAffectingCombat("player") and not IsShiftKeyDown() then
						GameTooltip:Hide()
						return
					end
				else
					LT["Unit"] = select(2, GameTooltip:GetUnit())
					if not (LT["Unit"]) then return end
				end

				-- Quit if unit has no reaction to player
				LT["Reaction"] = UnitReaction(LT["Unit"], "player") or nil
				if not LT["Reaction"] then 
					return
				end

				-- Quit if unit is a wild pet
				if UnitIsWildBattlePet(LT["Unit"]) then return end

				-- Setup variables
				LT["TipUnitName"], LT["TipUnitRealm"] = UnitName(LT["Unit"])
				LT["TipIsPlayer"] = UnitIsPlayer(LT["Unit"])
				LT["UnitLevel"] = UnitEffectiveLevel(LT["Unit"])
				LT["RealLevel"] = UnitLevel(LT["Unit"])
				LT["UnitClass"] = UnitClassBase(LT["Unit"])
				LT["PlayerControl"] = UnitPlayerControlled(LT["Unit"])
				LT["PlayerRace"] = UnitRace(LT["Unit"])

				-- Get guild information
				if LT["TipIsPlayer"] then
					local unitGuild, unitRank = GetGuildInfo(LT["Unit"])
					if unitGuild and unitRank then
						-- Unit is guilded
						if LT["ColorBlind"] == "1" then
							LT["GuildLine"], LT["InfoLine"] = 2, 4
						else
							LT["GuildLine"], LT["InfoLine"] = 2, 3
						end
						LT["GuildName"], LT["GuildRank"] = unitGuild, unitRank
					else
						-- Unit is not guilded
						LT["GuildName"] = nil
						if LT["ColorBlind"] == "1" then
							LT["GuildLine"], LT["InfoLine"] = 0, 3
						else
							LT["GuildLine"], LT["InfoLine"] = 0, 2
						end
					end
					-- Lower information line if unit is charmed
					if UnitIsCharmed(LT["Unit"]) then
						LT["InfoLine"] = LT["InfoLine"] + 1
					end
				end

				-- Determine class color
				if LT["UnitClass"] then
					-- Define male or female (for certain locales)
					LT["Sex"] = UnitSex(LT["Unit"])
					if LT["Sex"] == 2 then
						LT["Class"] = TipMClass[LT["UnitClass"]]
					else
						LT["Class"] = TipFClass[LT["UnitClass"]]
					end
					-- Define class color
					LT["ClassCol"] = LeaPlusLC["RaidColors"][LT["UnitClass"]]
					LT["LpTipClassColor"] = "|cff" .. string.format("%02x%02x%02x", LT["ClassCol"].r * 255, LT["ClassCol"].g * 255, LT["ClassCol"].b * 255)
				end

				----------------------------------------------------------------------
				-- Name line
				----------------------------------------------------------------------

				if ((LT["TipIsPlayer"]) or (LT["PlayerControl"])) or LT["Reaction"] > 4 then

					-- If it's a player show name in class color
					if LT["TipIsPlayer"] then
						LT["NameColor"] = LT["LpTipClassColor"]
					else
						-- If not, set to green or blue depending on PvP status
						if UnitIsPVP(LT["Unit"]) then
							LT["NameColor"] = "|cff00ff00"
						else
							LT["NameColor"] = "|cff00aaff"
						end
					end

					-- Show name
					LT["NameText"] = UnitPVPName(LT["Unit"]) or LT["TipUnitName"]

					-- Show realm
					if LT["TipUnitRealm"] then
						LT["NameText"] = LT["NameText"] .. " - " .. LT["TipUnitRealm"]
					end

					-- Show dead units in grey
					if UnitIsDeadOrGhost(LT["Unit"]) then
						LT["NameColor"] = "|c88888888"
					end

					-- Show name line
					_G["GameTooltipTextLeft1"]:SetText(LT["NameColor"] .. LT["NameText"] .. "|cffffffff|r")
					
				elseif UnitIsDeadOrGhost(LT["Unit"]) then

					-- Show grey name for other dead units
					_G["GameTooltipTextLeft1"]:SetText("|c88888888" .. (_G["GameTooltipTextLeft1"]:GetText() or "") .. "|cffffffff|r")
					return

				end

				----------------------------------------------------------------------
				-- Guild line
				----------------------------------------------------------------------

				if LT["TipIsPlayer"] and LT["GuildName"] then
					
					-- Show guild line
					if LeaPlusLC["TipShowRank"] == "On" then
						if UnitIsInMyGuild(LT["Unit"]) then
							_G["GameTooltipTextLeft" .. LT["GuildLine"]]:SetText("|c00aaaaff" .. LT["GuildName"] .. " - " .. LT["GuildRank"] .. "|r")
						else
							_G["GameTooltipTextLeft" .. LT["GuildLine"]]:SetText("|c00aaaaff" .. LT["GuildName"] .. "|cffffffff|r")
						end
					else
						_G["GameTooltipTextLeft" .. LT["GuildLine"]]:SetText("|c00aaaaff" .. LT["GuildName"] .. "|cffffffff|r")
					end

				end

				----------------------------------------------------------------------
				-- Information line (level, class, race)
				----------------------------------------------------------------------

				if LT["TipIsPlayer"] then

					-- Show level
					if LT["Reaction"] < 5 then
						if LT["UnitLevel"] == -1 then
							LT["InfoText"] = ("|cffff3333" .. ttLevel .. " ??|cffffffff")
						else
							LT["LevelColor"] = GetCreatureDifficultyColor(LT["UnitLevel"])
							LT["LevelColor"] = string.format('%02x%02x%02x', LT["LevelColor"].r * 255, LT["LevelColor"].g * 255, LT["LevelColor"].b * 255)
							LT["InfoText"] = ("|cff" .. LT["LevelColor"] .. LT["LevelLocale"] .. " " .. LT["UnitLevel"] .. "|cffffffff")
						end
					else
						if LT["UnitLevel"] ~= LT["RealLevel"] then 
							LT["InfoText"] = LT["LevelLocale"] .. " " .. LT["UnitLevel"] .. " (" .. LT["RealLevel"] .. ")"
						else
							LT["InfoText"] = LT["LevelLocale"] .. " " .. LT["UnitLevel"]
						end
					end

					-- Show race
					if LT["PlayerRace"] then
						LT["InfoText"] = LT["InfoText"] .. " " .. LT["PlayerRace"]
					end

					-- Show class
					LT["InfoText"] = LT["InfoText"] .. " " .. LT["LpTipClassColor"] .. LT["Class"] or LT["InfoText"]

					-- Show information line
					_G["GameTooltipTextLeft" .. LT["InfoLine"]]:SetText(LT["InfoText"] .. "|cffffffff|r")

				end

				----------------------------------------------------------------------
				-- Mob name in brighter red (alive) and steel blue (tap denied)
				----------------------------------------------------------------------

				if not (LT["TipIsPlayer"]) and LT["Reaction"] < 4 and not (LT["PlayerControl"]) then
					if UnitIsTapDenied(LT["Unit"]) then
						LT["NameText"] = "|c8888bbbb" .. LT["TipUnitName"] .. "|r"
					else
						LT["NameText"] = "|cffff3333" .. LT["TipUnitName"] .. "|r"
					end
					_G["GameTooltipTextLeft1"]:SetText(LT["NameText"])
				end

				----------------------------------------------------------------------
				-- Mob level in color (neutral or lower)
				----------------------------------------------------------------------

				if UnitCanAttack(LT["Unit"], "player") and not (LT["TipIsPlayer"]) and LT["Reaction"] < 5 and not (LT["PlayerControl"]) then

					-- Find the level line
					LT["MobInfoLine"] = 0
					local line2, line3, line4 = _G["GameTooltipTextLeft2"]:GetText(), _G["GameTooltipTextLeft3"]:GetText(), _G["GameTooltipTextLeft4"]:GetText()
					if GameLocale == "ruRU" then -- Additional check for ruRU
						if line2 and string.lower(line2):find(LevelString2) then LT["MobInfoLine"] = 2 end
						if line3 and string.lower(line3):find(LevelString2) then LT["MobInfoLine"] = 3 end
						if line4 and string.lower(line4):find(LevelString2) then LT["MobInfoLine"] = 4 end
					end
					if line2 and string.lower(line2):find(LevelString) then LT["MobInfoLine"] = 2 end
					if line3 and string.lower(line3):find(LevelString) then LT["MobInfoLine"] = 3 end
					if line4 and string.lower(line4):find(LevelString) then LT["MobInfoLine"] = 4 end

					-- Show level line
					if LT["MobInfoLine"] > 1 then

						-- Level ?? mob
						if LT["UnitLevel"] == -1 then
							LT["InfoText"] = "|cffff3333" .. ttLevel .. " ??|cffffffff "

						-- Mobs within level range
						else
							LT["MobColor"] = GetCreatureDifficultyColor(LT["UnitLevel"])
							LT["MobColor"] = string.format('%02x%02x%02x', LT["MobColor"].r * 255, LT["MobColor"].g * 255, LT["MobColor"].b * 255)
							LT["InfoText"] = "|cff" .. LT["MobColor"] .. LT["LevelLocale"] .. " " .. LT["UnitLevel"] .. "|cffffffff "
						end

						-- Show creature type and classification
						LT["CreatureType"] = UnitCreatureType(LT["Unit"])
						if (LT["CreatureType"]) and not (LT["CreatureType"] == "Not specified") then
							LT["InfoText"] = LT["InfoText"] .. "|cffffffff" .. LT["CreatureType"] .. "|cffffffff "
						end

						-- Rare, elite and boss mobs
						LT["Special"] = UnitClassification(LT["Unit"])
						if LT["Special"] then
							if LT["Special"] == "elite" then
								if strfind(_G["GameTooltipTextLeft" .. LT["MobInfoLine"]]:GetText(), "(" .. ttBoss .. ")") then
									LT["Special"] = "(" .. ttBoss .. ")"
								else
									LT["Special"] = "(" .. ttElite .. ")"
								end
							elseif LT["Special"] == "rare" then
								LT["Special"] = "|c00e066ff(" .. ttRare .. ")"
							elseif LT["Special"] == "rareelite" then
								if strfind(_G["GameTooltipTextLeft" .. LT["MobInfoLine"]]:GetText(), "(" .. ttBoss .. ")") then
									LT["Special"] = "|c00e066ff(" .. ttRareBoss .. ")"
								else
									LT["Special"] = "|c00e066ff(" .. ttRareElite .. ")"
								end
							elseif LT["Special"] == "worldboss" then
								LT["Special"] = "(" .. ttBoss .. ")"
							elseif LT["UnitLevel"] == -1 and LT["Special"] == "normal" and strfind(_G["GameTooltipTextLeft" .. LT["MobInfoLine"]]:GetText(), "(" .. ttBoss .. ")") then
								LT["Special"] = "(" .. ttBoss .. ")"
							else
								LT["Special"] = nil 
							end

							if (LT["Special"]) then
								LT["InfoText"] = LT["InfoText"] .. LT["Special"]
							end
						end

						-- Show mob info line
						_G["GameTooltipTextLeft" .. LT["MobInfoLine"]]:SetText(LT["InfoText"])

					end

				end

				----------------------------------------------------------------------
				-- Backdrop color
				----------------------------------------------------------------------

				LT["TipFaction"] = UnitFactionGroup(LT["Unit"])

				if UnitCanAttack("player", LT["Unit"]) and not (UnitIsDeadOrGhost(LT["Unit"])) and not (LT["TipFaction"] == nil) and not (LT["TipFaction"] == UnitFactionGroup("player")) then
					-- Hostile faction
					if LeaPlusLC["TipBackSimple"] == "On" then
						GameTooltip:SetBackdropColor(0.5, 0.0, 0.0);
					else
						GameTooltip:SetBackdropColor(0.0, 0.0, 0.0);
					end
				else
					-- Friendly faction
					if LeaPlusLC["TipBackSimple"] == "On" then
						GameTooltip:SetBackdropColor(0.0, 0.0, 0.5);
					else
						GameTooltip:SetBackdropColor(0.0, 0.0, 0.0);
					end
				end

				----------------------------------------------------------------------
				--	Show target
				----------------------------------------------------------------------

				if LeaPlusLC["TipShowTarget"] == "On" then

					-- Get target
					LT["Target"] = UnitName(LT["Unit"] .. "target");

					-- If target doesn't exist, quit
					if LT["Target"] == nil or LT["Target"] == "" then return end

					-- If target is you, set target to YOU
					if (UnitIsUnit(LT["Target"], "player")) then 
						LT["Target"] = ("|c12ff4400" .. ttYou)

					-- If it's not you, but it's a player, show target in class color
					elseif UnitIsPlayer(LT["Unit"] .. "target") then
						LT["TargetBase"] = UnitClassBase(LT["Unit"] .. "target")
						LT["TargetCol"] = LeaPlusLC["RaidColors"][LT["TargetBase"]]
						LT["TargetCol"] = "|cff" .. string.format('%02x%02x%02x', LT["TargetCol"].r * 255, LT["TargetCol"].g * 255, LT["TargetCol"].b * 255)
						LT["Target"] = (LT["TargetCol"] .. LT["Target"])

					end
					
					-- Add target line
					GameTooltip:AddLine(ttTarget .. ": " .. LT["Target"])

				end

			end

			GameTooltip:HookScript("OnTooltipSetUnit", ShowTip)
			
		end

		----------------------------------------------------------------------
		--	Move chat editbox to top
		----------------------------------------------------------------------

		if LeaPlusLC["MoveChatEditBoxToTop"] == "On" then

			-- Set options for normal chat frames
			for i = 1, 50 do
				if _G["ChatFrame" .. i] then
					-- Position the editbox
					_G["ChatFrame" .. i .. "EditBox"]:ClearAllPoints();
					_G["ChatFrame" .. i .. "EditBox"]:SetPoint("TOPLEFT", _G["ChatFrame" .. i], 0, 0);
					_G["ChatFrame" .. i .. "EditBox"]:SetWidth(_G["ChatFrame" .. i]:GetWidth());
					-- Ensure editbox width matches chatframe width
					_G["ChatFrame" .. i]:HookScript("OnSizeChanged", function()
						_G["ChatFrame" .. i .. "EditBox"]:SetWidth(_G["ChatFrame" .. i]:GetWidth())
					end)
				end
			end

			-- Do the functions above for other chat frames (pet battles, whispers, etc)
			hooksecurefunc("FCF_OpenTemporaryWindow", function()

				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then

					-- Position the editbox
					_G[cf .. "EditBox"]:ClearAllPoints();
					_G[cf .. "EditBox"]:SetPoint("TOPLEFT", cf, "TOPLEFT", 0, 0);
					_G[cf .. "EditBox"]:SetWidth(_G[cf]:GetWidth());

					-- Ensure editbox width matches chatframe width
					_G[cf]:HookScript("OnSizeChanged", function()
						_G[cf .. "EditBox"]:SetWidth(_G[cf]:GetWidth())
					end)

				end
			end)

		end

		----------------------------------------------------------------------
		-- Viewport
		----------------------------------------------------------------------

		if LeaPlusLC["ViewPortEnable"] == "On" then

			-- Create border textures
			local BordTop = WorldFrame:CreateTexture(nil, "ARTWORK"); BordTop:SetColorTexture(0, 0, 0, 1); BordTop:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0); BordTop:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
			local BordBot = WorldFrame:CreateTexture(nil, "ARTWORK"); BordBot:SetColorTexture(0, 0, 0, 1); BordBot:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0); BordBot:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
			local BordLeft = WorldFrame:CreateTexture(nil, "ARTWORK"); BordLeft:SetColorTexture(0, 0, 0, 1); BordLeft:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0); BordLeft:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
			local BordRight = WorldFrame:CreateTexture(nil, "ARTWORK"); BordRight:SetColorTexture(0, 0, 0, 1); BordRight:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0); BordRight:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)

			-- Create viewport configuration panel
			local SideViewport = LeaPlusLC:CreatePanel("Viewport", "SideViewport")

			-- Create resize screen button
			local resizeScreenBtn = LeaPlusLC:CreateButton("resizeScreenBtn", SideViewport, "Resize Screen", "BOTTOMRIGHT", -16, 10, 0, 25, true, "Click to resize the screen to fit between the top and bottom borders.")
			resizeScreenBtn:ClearAllPoints()
			resizeScreenBtn:SetPoint("LEFT", SideViewport.h, "RIGHT", 10, 0)
			resizeScreenBtn:SetScript("OnClick", function()
				LeaPlusLC["ViewPortResizeTop"] = LeaPlusLC["ViewPortTop"]
				LeaPlusLC["ViewPortResizeBottom"] = LeaPlusLC["ViewPortBottom"]
				WorldFrame:SetPoint("TOPLEFT", 0, -LeaPlusLC["ViewPortResizeTop"])
				WorldFrame:SetPoint("BOTTOMRIGHT", 0, LeaPlusLC["ViewPortResizeBottom"])
				-- Disable lock button if borders match viewport size
				if LeaPlusLC["ViewPortTop"] == LeaPlusLC["ViewPortResizeTop"] and LeaPlusLC["ViewPortBottom"] == LeaPlusLC["ViewPortResizeBottom"] then
					LeaPlusLC:LockItem(resizeScreenBtn, true)
				else
					LeaPlusLC:LockItem(resizeScreenBtn, false)
				end
			end)

			-- Function to set viewport parameters
			local function RefreshViewport()

				-- Set border size and transparency
				BordTop:SetHeight(LeaPlusLC["ViewPortTop"]); BordTop:SetAlpha(1 - LeaPlusLC["ViewPortAlpha"])
				BordBot:SetHeight(LeaPlusLC["ViewPortBottom"]); BordBot:SetAlpha(1 - LeaPlusLC["ViewPortAlpha"])
				BordLeft:SetWidth(LeaPlusLC["ViewPortLeft"]); BordLeft:SetAlpha(1 - LeaPlusLC["ViewPortAlpha"])
				BordRight:SetWidth(LeaPlusLC["ViewPortRight"]); BordRight:SetAlpha(1 - LeaPlusLC["ViewPortAlpha"])

				-- Show formatted slider value
				LeaPlusCB["ViewPortAlpha"].f:SetFormattedText("%.0f%%", LeaPlusLC["ViewPortAlpha"] * 100)

				-- Disable lock button if borders match viewport size
				if LeaPlusLC["ViewPortTop"] == LeaPlusLC["ViewPortResizeTop"] and LeaPlusLC["ViewPortBottom"] == LeaPlusLC["ViewPortResizeBottom"] then
					LeaPlusLC:LockItem(resizeScreenBtn, true)
				else
					LeaPlusLC:LockItem(resizeScreenBtn, false)
				end

			end

			-- Create slider controls
			LeaPlusLC:MakeTx(SideViewport, "Top", 16, -72)
			LeaPlusLC:MakeSL(SideViewport, "ViewPortTop", "", 0, 300, 5, 16, -92, "%.0f")
			LeaPlusCB["ViewPortTop"]:HookScript("OnValueChanged", RefreshViewport)

			LeaPlusLC:MakeTx(SideViewport, "Bottom", 16, -132)
			LeaPlusLC:MakeSL(SideViewport, "ViewPortBottom", "", 0, 300, 5, 16, -152, "%.0f")
			LeaPlusCB["ViewPortBottom"]:HookScript("OnValueChanged", RefreshViewport)

			LeaPlusLC:MakeTx(SideViewport, "Left", 186, -72)
			LeaPlusLC:MakeSL(SideViewport, "ViewPortLeft", "", 0, 300, 5, 186, -92, "%.0f")
			LeaPlusCB["ViewPortLeft"]:HookScript("OnValueChanged", RefreshViewport)

			LeaPlusLC:MakeTx(SideViewport, "Right", 186, -132)
			LeaPlusLC:MakeSL(SideViewport, "ViewPortRight", "", 0, 300, 5, 186, -152, "%.0f")
			LeaPlusCB["ViewPortRight"]:HookScript("OnValueChanged", RefreshViewport)

			LeaPlusLC:MakeTx(SideViewport, "Transparency", 356, -132)
			LeaPlusLC:MakeSL(SideViewport, "ViewPortAlpha", "", 0, 0.9, 0.1, 356, -152, "%.1f")
			LeaPlusCB["ViewPortAlpha"]:HookScript("OnValueChanged", RefreshViewport)

			-- Help button tooltip
			SideViewport.h.tiptext = L["This panel will close automatically if you enter combat."]

			-- Back button handler
			SideViewport.b:SetScript("OnClick", function() 
				SideViewport:Hide()
				LeaPlusLC["PageF"]:Show()
				LeaPlusLC["Page7"]:Show()
				return
			end) 

			-- Reset button handler
			SideViewport.r:SetScript("OnClick", function()
				LeaPlusLC["ViewPortTop"] = 0 
				LeaPlusLC["ViewPortBottom"] = 0
				LeaPlusLC["ViewPortLeft"] = 0
				LeaPlusLC["ViewPortRight"] = 0
				LeaPlusLC["ViewPortResizeTop"] = 0
				LeaPlusLC["ViewPortResizeBottom"] = 0
				LeaPlusLC["ViewPortAlpha"] = 0
				SideViewport:Hide(); SideViewport:Show()
				RefreshViewport()
				WorldFrame:SetPoint("TOPLEFT", 0, -LeaPlusLC["ViewPortResizeTop"])
				WorldFrame:SetPoint("BOTTOMRIGHT", 0, LeaPlusLC["ViewPortResizeBottom"])
			end)

			-- Configuration button handler
			LeaPlusCB["ModViewportBtn"]:SetScript("OnClick", function()
				if LeaPlusLC:PlayerInCombat() then
					return
				else
					if IsShiftKeyDown() and IsControlKeyDown() then
						-- Preset profile
						LeaPlusLC["ViewPortTop"] = 0 
						LeaPlusLC["ViewPortBottom"] = 0
						LeaPlusLC["ViewPortLeft"] = 0
						LeaPlusLC["ViewPortRight"] = 0
						LeaPlusLC["ViewPortResizeTop"] = 0
						LeaPlusLC["ViewPortResizeBottom"] = 0
						LeaPlusLC["ViewPortAlpha"] = 0.7
						RefreshViewport()
						WorldFrame:SetPoint("TOPLEFT", 0, -LeaPlusLC["ViewPortResizeTop"])
						WorldFrame:SetPoint("BOTTOMRIGHT", 0, LeaPlusLC["ViewPortResizeBottom"])
					else
						SideViewport:Show()
						LeaPlusLC:HideFrames()
					end
				end
			end)

			-- Set viewport on startup
			RefreshViewport()
			WorldFrame:SetPoint("TOPLEFT", 0, -LeaPlusLC["ViewPortResizeTop"])
			WorldFrame:SetPoint("BOTTOMRIGHT", 0, LeaPlusLC["ViewPortResizeBottom"])

			-- Hide the configuration panel if combat starts
			SideViewport:RegisterEvent("PLAYER_REGEN_DISABLED")
			SideViewport:SetScript("OnEvent", SideViewport.Hide)

			-- Hide borders when cinematic is shown
			hooksecurefunc(CinematicFrame, "Hide", function()
				BordTop:Show(); BordBot:Show(); BordLeft:Show(); BordRight:Show()
			end)
			hooksecurefunc(CinematicFrame, "Show", function()
				BordTop:Hide(); BordBot:Hide(); BordLeft:Hide(); BordRight:Hide()
			end)

		end

		----------------------------------------------------------------------
		-- Silence rested emotes
		----------------------------------------------------------------------

		-- Manage emotes
		if LeaPlusLC["NoRestedEmotes"] == "On" then

			-- Zone table 		English					, French					, German					, Italian						, Russian					, S Chinese	, Spanish					, T Chinese	,
			local zonetable = {	"The Halfhill Market"	, "Marché de Micolline"		, "Der Halbhügelmarkt"		, "Il Mercato di Mezzocolle"	, "Рынок Полугорья"			, "半山市集"	, "El Mercado del Alcor"	, "半丘市集"	,
								"The Grim Guzzler"		, "Le Sinistre écluseur"	, "Zum Grimmigen Säufer"	, "Torvo Beone"					, "Трактир Угрюмый обжора"	, "黑铁酒吧"	, "Tragapenas"				, "黑鐵酒吧"	,
								"The Summer Terrace"	, "La terrasse Estivale"	, "Die Sommerterrasse"		, "Terrazza Estiva"				, "Летняя терраса"			, "夏之台"	, "El Bancal del Verano"	, "夏日露臺"	,
			}

			-- Function to set rested state
			local function UpdateEmoteSound()

				-- Find character's current zone
				local szone = GetSubZoneText() or "None"

				-- Find out if emote sounds are disabled or enabled
				local emoset = GetCVar("Sound_EnableEmoteSounds")

				if IsResting() then
					-- Character is resting so silence emotes
					if emoset ~= "0" then
						SetCVar("Sound_EnableEmoteSounds", "0")
					end
					return
				end

				-- Traverse zone table and silence emotes if character is in a designated zone
				for k, v in next, zonetable do
					if szone == zonetable[k] then
						if emoset ~= "0" then
							SetCVar("Sound_EnableEmoteSounds", "0")
						end
						return
					end
				end

				-- Silence emotes if character is in a pet battle
				if C_PetBattles.IsInBattle() then
					if emoset ~= "0" then
						SetCVar("Sound_EnableEmoteSounds", "0")
					end
					return
				end

				-- If the above didn't return, emote sounds should be enabled
				if emoset ~= "1" then
					SetCVar("Sound_EnableEmoteSounds", "1")
				end
				return
			
			end

			-- Set emote sound when pet battles start and end
			hooksecurefunc("PetBattleFrame_Display", UpdateEmoteSound) 
			hooksecurefunc("PetBattleFrame_Remove",	UpdateEmoteSound)

			-- Set emote sound when rest state or zone changes
			local RestEvent = CreateFrame("FRAME")
			RestEvent:RegisterEvent("PLAYER_UPDATE_RESTING")
            RestEvent:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			RestEvent:RegisterEvent("ZONE_CHANGED")
			RestEvent:RegisterEvent("ZONE_CHANGED_INDOORS")
			RestEvent:SetScript("OnEvent", UpdateEmoteSound)

			-- Set sound setting at startup
			UpdateEmoteSound()

		end

		----------------------------------------------------------------------
		-- Final code for Player
		----------------------------------------------------------------------

		-- Register logout event to save settings
		LpEvt:RegisterEvent("PLAYER_LOGOUT")

		-- Release memory
		LeaPlusLC.Player = nil

	end

----------------------------------------------------------------------
-- 	L50: RunOnce
----------------------------------------------------------------------

	function LeaPlusLC:RunOnce()

		----------------------------------------------------------------------
		-- Media player
		----------------------------------------------------------------------

		function LeaPlusLC:MediaFunc()

			-- Create tables for list data and zone listing
			local ListData, ZoneList, playlist = {}, {}, {}
			local scrollFrame, willPlay, musicHandle, ZonePage, LastPlayed, LastFolder, TempFolder, HeadingOfClickedTrack, LastMusicHandle
			local numButtons = 15
			local uframe = CreateFrame("FRAME")
			local prefol = "|cffffffaa{" .. L["right-click to go back"] .. "}"

			-- Create a table for each heading
			ZoneList = {L["Zones"], L["Dungeons"], L["Various"], L["Random"], L["Search"], L["Movies"]}
			for k, v in ipairs(ZoneList) do
				ZoneList[v] = {}
			end

			-- Function to create a table for each zone
			local function Zn(where, category, zone, tracklist)
				tinsert(ZoneList[where], {category = category, zone = zone, tracks = tracklist})
			end

			-- Debug
			-- Zn(L["Zones"], L["Eastern Kingdoms"], "Debug1", {"|cffffd800" .. L["Zones"] .. ": Debug1", "1020#1020", "1021#1021", "1022#1022", "1023#1023", "1024#1024",})
			-- Zn(L["Zones"], L["Eastern Kingdoms"], "Debug2", {"|cffffd800" .. L["Zones"] .. ": Debug2", "1020#1020",})

			-- Zones: Eastern Kingdoms
			Zn(L["Zones"], L["Eastern Kingdoms"], "|cffffd800" .. L["Eastern Kingdoms"], {""})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Arathi Highlands"]					, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Arathi Highlands"], prefol, "MUS_ArathiHighlands_GD#22292", "MUS_ArathiHighlands_GN#22293", "Zone-Desert Cave#5394", "Zone-Jungle Day#2525", "Zone-Mountain Night#2537", "Zone-Haunted#2990", "Zone-Orgrimmar#2901", "Zone-Volcanic Day#2529" , "Zone - Plaguelands#6066", "Moment - Battle05#6253", "Moment - Gloomy01#6074", "Moment-Stormwind08#5294",}) -- "Zone-Mystery#6065"
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Badlands"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Badlands"], prefol, "MUS_Badlands_GD#22294", "MUS_BadlandsGoblin#22695", "MUS_BadlandsOgre#22691", "MUS_NewKargath#22692", "MUS_ScarOfTheWorldBreaker#22693", "MUS_TombOfTheWatchers#22694",})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Blasted Lands"]					, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Blasted Lands"], prefol, "MUS_BlastedLands_GD#22296", "MUS_BlastedLandsGilnean#22688", "MUS_BlastedLandsHuman#22684", "MUS_BlastedLandsOgre#22682", "MUS_BlastedLandsShadowsworn#22679", "MUS_BlastedLandsTainted#22683", "MUS_BloodwashCavern#22680", "MUS_NethergardeMines#22686", "MUS_SunveilExcursion#22689", "MUS_TheDarkPortalIntro#22690",})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Burning Steppes"]					, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Burning Steppes"], prefol, "MUS_BurningSteppes#22298", "MUS_BurningSteppesBlackrock#22674", "MUS_BlackwingDescent#23171", "MUS_DreadmaulRock#22675", "MUS_FireplumeRidge#22737", "MUS_MorgansVigil#22677", "Zone-Cursed Land Felwood#5455", "Zone-CursedLandFelwoodFurbolg#5456", "Zone-Orgrimmar#2901", "Zone-Volcanic Day#2529", "Zone - Plaguelands#6066",}) -- "Zone-Mystery#6065", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082"
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Cape of Stranglethorn"]			, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Cape of Stranglethorn"], prefol, "MUS_CapeStranglethornA#22656", "MUS_StranglethornGoblin#23781", "MUS_StranglethornTrollB#22653", "MUS_StranglethornTrollA#22654", "Zone-Jungle Day#2525", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082",}) -- "Zone-Mystery#6065"
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Dun Morogh"]						, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Dun Morogh"], prefol, "MUS_DunMorogh_GD#22303", "MUS_DunMoroghTroll#22745", "MUS_ColdMountain_GU#22154", "MUS_DarkIronforge_GU#22160", "MUS_Gnomeregan#22756", "MUS_NewTinkertown#22753", "Zone-Evil Forest Night#2534", "Zone-Mountain Night#2537", "Zone-TavernAlliance#4516", "Zone-TavernDwarf01#11806",}) -- "Zone-Mystery#6065"
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Duskwood"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Duskwood"], prefol, "MUS_DuskwoodHaunted#22757", "MUS_DuskwoodHuman#22759", "MUS_DuskwoodWorgen#22758", "MUS_DuskwoodUndead#22760", "MUS_DustwallowOgre#22765", "MUS_HushedBank#22762", "MUS_TwilightGrove#22764", "Zone-EnchantedForest Night#2540", "Zone-EvilForest Day#2524", "Zone-Cursed Land Felwood#5455", "Zone-Volcanic Day#2529", "Zone - Plaguelands#6066",})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Eastern Plaguelands"]				, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Eastern Plaguelands"], prefol, "MUS_EasternPlaguelands#22307", "MUS_EPlaguelandsArgent#22767", "MUS_EPlaguelandsCursed#22772", "MUS_EPlaguelandsHaunted#22766", "MUS_EPlaguelandsNerubian#22768", "MUS_LightsHopeChapel#22769", "MUS_QuelLithienLodge#22770", "MUS_Stratholme#22773", "Zone-EbonHArcherusWalk#14960", "Zone-EbonHDeathsBreachWalk#14961", "Zone-Haunted#2990", "Zone-OutlandCorruptRetail#10901", "Zone-Undercity#5074",}) -- "Zone-Mystery#6065", "Zone-Soggy Day#7082", "Zone-Soggy Night#6836", "Moment - Corrupt#9871"
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Elwynn Forest"]					, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Elwynn Forest"], prefol, "Zone-Forest Day#2523", "Zone-Stormwind#2532", "Zone-TavernAlliance#4516",}) -- "Zone - Plaguelands#6066", "MUS_HillsbradFoothills_GD#22315", "MUS_HillsbradFoothills_GN#22316"
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Eversong Woods"]					, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Eversong Woods"], prefol, "Zone-EversongDay#9789", "Zone-EversongNight#9790", "Zone-EversongRuinsDay#9797", "Zone-EversongRuinsNight#9798", "Zone-EversongBuildingsDay#9795", "Zone-EversongBuildingsNight#9796", "Zone-GhostlandsScenicWalk#9901", "Zone-SilvermoonDay#9793", "Zone-SilvermoonNight#9794",})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Ghostlands"]						, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Ghostlands"], prefol, "Zone-GhostlandsDay#9803", "Zone-GhostlandsNight#9804", "Zone-GhostlandsEversongDarkWalk#10869", "Zone-GhostlandsShalandisWalk#10867", "Zone-DeatholmeDay#9805", "Zone-DeatholmeNight#9806", "Zone-Desert Cave#5394", "Zone-EversongBuildingsDay#9795", "Zone-EversongBuildingsNight#9796", "Zone-Haunted#2990", "Zone-ZulamanWalkingUni#12133", "Zone - Plaguelands#6066",}) -- "Moment - Corrupt#9871"
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Hillsbrad Foothills"]				, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Hillsbrad Foothills"], prefol, "MUS_HillsbradFoothills_GD#22315", "MUS_HillsbradCursed#22789", "MUS_DurnholdeKeep#22788", "MUS_SludgeFields#22791", "MUS_TarrenMill#22790",})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Hinterlands"]						, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Hinterlands"], prefol, "MUS_TheHinterlands_GD#22335", "MUS_HinterlandsMystical#22588", "MUS_HinterlandsNightElf#22565", "MUS_HinterlandsTrollA#22562", "MUS_HinterlandsTrollB#22564", "MUS_HinterlandsUndead#22563",})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Isle of Quel'Danas"]				, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Isle of Quel'Danas"], prefol, "Zone-GhostlandsDay#9803", "Zone-GhostlandsNight#9804", "Zone-QuelDanasDay#12528", "Zone-QuelDanasNight#12529",})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Loch Modan"]						, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Loch Modan"], prefol, "MUS_LochModan_GD#22319", "MUS_LochModanAlt_GD#22793", "MUS_LochModanOgre#22797", "MUS_LochModanTwilight#22799", "MUS_FarstriderLodgeIntro#22798", "MUS_IronbandsExcavationSite#22795", "MUS_IronwingCavernIntro#22796",})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Northern Stranglethorn"]			, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Northern Stranglethorn"], prefol, "MUS_NorthStranglethornA#22655", "MUS_StranglethornOgre#23780", "MUS_StranglethornTrollA#22654", "MUS_StranglethornVale_GU#22208", "MUS_ZandalariTroll#24681", "Zone-Jungle Day#2525", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone - Plaguelands#6066", "Moment - Zul Gurub#8452",}) -- "Zone-Mystery#6065"
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Redridge Mountains"]				, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Redridge Mountains"], prefol, "MUS_RedridgeMountains_GD#22701", "MUS_RedridgeBlackrock#22703", "MUS_Redridge_GD#22321",})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Ruins of Gilneas"]					, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Ruins of Gilneas"], prefol, "MUS_GilneasForsaken#23086", "MUS_GilneasTown#23085", "MUS_Scarred_UU#22198", "MUS_Shadows_UU#22200",})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Searing Gorge"]					, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Searing Gorge"], prefol, "MUS_SearingGorgeA#22668", "MUS_SearingGorgeTwilight#22669", "MUS_TheCauldron#22671", "MUS_TheSlagPit#22673", "Zone-Volcanic Day#2529",}) -- "Zone-Desert Day#4754", "Zone-Desert Night#4755", "Zone-Jungle Day#2525", "Zone-Mystery#6065"
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Silverpine Forest"]				, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Silverpine Forest"], prefol, "MUS_SilverpineForsaken#22665", "MUS_SilverpineHaunted#22667", "MUS_SilverpineHuman#22664", "MUS_SilverpineWorgen#22666", "MUS_ShadowfangKeep#23610", "Zone-Cursed Land Felwood#5455", "Zone-DarkForest#5376", "Zone-EvilForest Day#2524", "Zone-Haunted#2990", "Zone-TavernUndead#12137",}) -- "Moment - Battle04#6079"
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Swamp of Sorrows"]					, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Swamp of Sorrows"], prefol, "MUS_SwampOfSorrowsDraenei#22541", "MUS_SwampOfSorrowsGoblin#22539", "MUS_SwampOfSorrowsTroll#22542", "Zone-Evil Forest Night#2534", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone - Plaguelands#6066",}) -- "Zone-Mystery#6065", "Moment - Battle05#6253", "Moment - Battle02#6262", "Moment - Battle06#6350"
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Tirisfal Glades"]					, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Tirisfal Glades"], prefol, "MUS_TirisfalHaunted#22651", "MUS_UndercityAlt#22650", "MUS_70_Artif_TombofTyr_Walk#77240", "MUS_50_SM_Dungeon_ScarletEntranceWalk#33719", "MUS_50_SM_Dungeon_VestibuleWalk#33721", "Zone-EvilForest Day#2524", "Zone-Haunted#2990", "Zone-Undercity#5074", "Zone - Plaguelands#6066", "Zone-TavernHorde01#5355", "Zone-TavernUndead#12137", "Moment-Haunted02#5174", "MUS_61_GarrisonMusicBox_15#49540",})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Tol Barad"]						, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Tol Barad"], prefol, "MUS_TolBarad_BG#23627",})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Twilight Highlands"]				, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Twilight Highlands"], prefol, "MUS_TwilightHighlands_GD (1)#23144", "MUS_TwilightHighlands_GN (1)#23145", "MUS_TwilightHighlandsCrystal#23159", "MUS_TwilightHighlandsHuman#23158", "MUS_TwilightHighlandsTwilightDay#23146", "MUS_TwilightOgre#23150", "MUS_BastionOfTwilight#23167", "MUS_Crushblow#23153", "MUS_DarkshoreCoast#23002", "MUS_GrimBatol#22637", "MUS_GrimBatolDungeonAlt#23169", "MUS_Krazzworks#23160", "MUS_TwilightHive#23796", "Zone-Forest Day#2523", "Zone-Volcanic Day#2529",})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Vashj'ir"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Vashj'ir"], prefol, "MUS_AbyssalDepths_GN#22347", "MUS_KelpForest_GN#22349", "MUS_ShimmeringExpanse_GN#22351", "Zone-TavernPirate#11805",})
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Western Plaguelands"]				, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Western Plaguelands"], prefol, "MUS_WPlaguelands_GD#22352", "MUS_WPlaguelands_GN#22353", "MUS_WestPlaguelands_Cursed#22560", "MUS_WestPlaguelands_Haunted#22561", "Zone-Cursed Land Felwood#5455", "Zone-Haunted#2990", "Zone-Volcanic Day#2529", "Moment - Gloomy01#6074",}) -- "Zone-Soggy Night#6836", "Zone-Soggy Day#7082"
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Westfall"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Westfall"], prefol, "MUS_WestfallA#22645", "MUS_WestfallB#22646", "MUS_Deadmines#23609", "Zone-BarrenDry Night#2536", "Zone-EvilForest Day#2524", "Zone-Forest Day#2523", "Zone-Plains Day#2528",}) -- "Zone-Mystery#6065", "Zone-Orgrimmar#2901"
			Zn(L["Zones"], L["Eastern Kingdoms"], L["Wetlands"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Wetlands"], prefol, "MUS_Wetlands_GD#22356", "MUS_Wetlands_GN#22357", "MUS_WetlandsHuman#22639", "MUS_WetlandsOrcs#22632", "MUS_WetlandsNightElf#22635", "Zone-Forest Day#2523", "Zone-Haunted#2990", "Zone-Jungle Day#2525", "Zone-Night Forest#2533", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone - Plaguelands#6066", "Zone-TavernAlliance#4516", "Zone-TavernPirate#11805",}) -- "Zone-Mystery#6065"

			-- Zones: Kalimdor
			Zn(L["Zones"], L["Kalimdor"], "|cffffd800", {""})
			Zn(L["Zones"], L["Kalimdor"], "|cffffd800" .. L["Kalimdor"], {""})
			Zn(L["Zones"], L["Kalimdor"], L["Ashenvale"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Ashenvale"], prefol, "MUS_AshenvaleBarrowDen#22939", "MUS_AshenvaleDemon#22936", "MUS_AshenvaleForsaken#22929", "MUS_AshenvaleFurbolg#22930", "MUS_AshenvaleNaga#22951", "MUS_AshenvaleSatyr#22946", "MUS_AshenvaleTwilight#22942", "MUS_BoughShadow#22932", "MUS_MaestrasPost#22943", "MUS_Thunderpeak#22960", "Zone-Crossroads#7097", "Zone-Cursed Land Felwood#5455", "Zone-CursedLandFelwoodFurbolg#5456", "Zone-Darnassus#3920", "Zone-Desert Day#4754", "Zone-Desert Night#4755", "Zone-EnchantedForest Day#2530", "Zone-EnchantedForest Night#2540", "Zone-Jungle Day#2525", "Zone - Plaguelands#6066", "Zone-OutlandsHordeBase9785", "Zone-TavernHorde#5234", "Zone-TavernOrc#12328",}) -- "Zone-Mystery#6065", "Moment - Battle06#6350"
			Zn(L["Zones"], L["Kalimdor"], L["Azshara"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Azshara"], prefol, "MUS_Azshara_GN (1)#22965", "MUS_AzsharaCoast#22967", "MUS_AzsharaGoblin#22970", "MUS_AzsharaHaunted#22975", "MUS_AzsharaNaga#22981", "MUS_AzsharaTwilight#22983", "MUS_GallywixsVillaIntro#22546", "MUS_SecretLab#22987", "MUS_70_Zone_Highmountain_Azshara_HulnFlashback_Walk#22964", "Zone-Crossroads#7097", "Zone-Darnassus#3920", "Zone-Desert Day#4754", "Zone-Desert Cave#5394", "Zone-Haunted#2990", "Zone-Jungle Day#2525", "Zone-Mountain Night#2537", "Zone - Plaguelands#6066",}) -- "Zone-Mystery#6065", "Moment - Battle05#6253"
			Zn(L["Zones"], L["Kalimdor"], L["Azuremyst Isle"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Azuremyst Isle"], prefol, "Zone-AzureMystWalking#9975", "Zone-AzuremystNagaWalking#9458", "Zone-AzuremystOwlWalking#10605", "Zone-OutlandsAllianceBase#9786",}) -- "Zone-Mystery#6065"
			Zn(L["Zones"], L["Kalimdor"], L["Bloodmyst Isle"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Bloodmyst Isle"], prefol, "MUS_70_Zone_Highmountain_DrogbarEarth_Walk#76613", "Zone-AzuremystNagaWalking#9458", "Zone-BloodmystSatyrWalkingUni#9460",})
			Zn(L["Zones"], L["Kalimdor"], L["Darkshore"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Darkshore"], prefol, "MUS_Darkshore_GD (1)#22992", "MUS_Darkshore_GN (1)#22993", "MUS_DarkshoreCoast#23002", "MUS_DarkshoreForsaken#23009", "MUS_DarkshoreTroll#22996", "MUS_DarkshoreTwilight#23000", "MUS_BlazingStrand#22994", "MUS_EyeOfTheVortex#23007", "MUS_GroveOfTheAncients#22999", "MUS_Nazjvel#23004", "MUS_ShatterSpearPass#22995", "MUS_TheVortex#23008", "Zone - Plaguelands#6066", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082",}) -- "Zone-Mystery#6065"
			Zn(L["Zones"], L["Kalimdor"], L["Desolace"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Desolace"], prefol, "MUS_Desolace_GD#22241", "MUS_Desolace_GD (1)#23013", "MUS_DesolaceBurningBlade#23023", "MUS_DesolaceCoast#23027", "MUS_DesolaceNightElf#23021", "MUS_GelkisVillageIntro#23016", "MUS_GhostwalkerPost#23017", "MUS_KarnumsGlade#23018", "MUS_MannorocCovenIntro#23020", "MUS_RanazjarIsle#23022", "MUS_ShadowpreyVillage#23024", "MUS_SlitherbladeShoreIntro#23026", "MUS_ThunksAbodeIntro#23029", "MUS_ValleyOfBonesIntro#23030",})
			Zn(L["Zones"], L["Kalimdor"], L["Durotar"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Durotar"], prefol, "MUS_Durotar_GD (1)#23032", "MUS_Durotar_GN (1)#23033", "MUS_DurotarCoast#23036", "MUS_DurotarTroll#23034", "MUS_BurningBladeCoven#23039", "MUS_SpitescaleCavern#23044", "Zone-Desert Cave#5394", "Zone-Jungle Day#2525", "Zone-Orgrimmar_Day#36308", "Zone-Orgrimmar_Night#36309", "Zone-Orgrimmar#2901", "Zone-Plains Day#2528", "Zone-TavernOrc#12328",}) -- "Zone-Mystery#6065"
			Zn(L["Zones"], L["Kalimdor"], L["Dustwallow Marsh"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Dustwallow Marsh"], prefol, "MUS_Dustwallow_GD#22247", "MUS_Dustwallow_GN#22248", "MUS_DustwallowGoblin#22595", "MUS_DustwallowGrimtotem#22589", "MUS_DustwallowHaunted#22591", "MUS_DustwallowHuman#22590", "MUS_DustwallowJungle#22592", "MUS_DustwallowTauren#22594", "MUS_StonemaulRuins#22596", "MUS_50_Scenario_AllianceTheramore#34012", "MUS_50_Scenario_HordeTheramore#34013", "Zone-Evil Forest Night#2534", "Zone-Jungle Day#2525", "Zone-Stormwind#2532", "Zone-Volcanic Day#2529", "Zone - Orgrimmar02#6146", "Moment-Orc Barren#7474", "Moment-StormwindSouthSeas#6837",})
			Zn(L["Zones"], L["Kalimdor"], L["Felwood"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Felwood"], prefol, "MUS_Felwood#22250", "MUS_FelwoodNightElf#22629", "MUS_FelwoodDruid#22631", "MUS_FelwoodHorde#22630", "Zone-Cursed Land Felwood#5455", "Zone-CursedLandFelwoodFurbolg#5456", "Zone-EvilForest Day#2524", "Zone-Soggy Day#7082", "Zone-Soggy Night#6836",})
			Zn(L["Zones"], L["Kalimdor"], L["Feralas"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Feralas"], prefol, "MUS_Feralas_GD#22252", "MUS_Feralas_GN#22253", "MUS_FeralasBugs#22627", "MUS_FeralasGrimtotem#22604", "MUS_FeralasHaunted#22600", "MUS_FeralasHorde#22626", "MUS_FeralasNightElf#22603", "MUS_FeralasTauren#22599", "MUS_DreamBough#22601", "Zone-EnchantedForest Day#2530", "Zone-EnchantedForest Night#2540", "Zone-Desert Day#4754", "Zone-Desert Cave#5394", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone-TavernTauren#12329", "Zone-Volcanic Day#2529", "Zone - Plaguelands#6066", "Moment - Gloomy01#6074",}) -- "Zone-Mystery#6065", "Moment-Spooky01#5037"
			Zn(L["Zones"], L["Kalimdor"], L["Moonglade"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Moonglade"], prefol, "MUS_Moonglade#22860", "MUS_StormrageBarrowDens#22864", "Zone-CursedLandFelwoodFurbolg#5456", "Zone-EvilForest Day#2524", "Zone-TavernTempleofTheMoon#12136",})
			Zn(L["Zones"], L["Kalimdor"], L["Mount Hyjal"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Mount Hyjal"], prefol, "MUS_MountHyjal_GD#22906", "MUS_MountHyjal_GN#22907", "MUS_HyjalDruid#22914", "MUS_HyjalFire#22912", "MUS_HyjalLight#22923", "MUS_HyjalLycan#22920", "MUS_HyjalOgre#22913", "MUS_HyjalTwilightDay#22911", "MUS_HyjalTwilightFire#22908", "MUS_LakeEdunel#22915", "MUS_LeyarasSorrow#22918", "MUS_Nordrassil#22922",})
			Zn(L["Zones"], L["Kalimdor"], L["Mulgore"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Mulgore"], prefol, "MUS_Mulgore_GD#22260", "MUS_Mulgore_GN#22262", "MUS_MulgoreGrimtotem#22812", "MUS_MulgoreTauren#22810", "MUS_Bael'dunDigsite#22809", "MUS_VentureCoMine#22808", "Zone-Desert Cave#5394", "Zone-Plains Day#2528", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone-Volcanic Day#2529", "Zone - Plaguelands#6066",})
			Zn(L["Zones"], L["Kalimdor"], L["Northern Barrens"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Northern Barrens"], prefol, "MUS_NorthBarrens_GD#22815", "MUS_NorthBarrens_GN#22816", "MUS_NorthBarrensGreen#22818", "MUS_NorthBarrensOrcs#22824", "MUS_NorthBarrensTauren#22825", "MUS_BoulderLodeMine#22819", "MUS_DreadmistPeak#22820", "MUS_SouthBarrensHuman#22839", "MUS_TheSludgeFen#22828", "MUS_TheWailingCaverns#22829", "Zone-BarrenDry Night#2536", "Zone-Desert Day#4754", "Zone-Desert Night#4755", "Zone-Jungle Day#2525", "Zone-Thunderbluff#7077", "Zone-Undead Dance#7083", "Zone-Undercity#5074", "Zone-Volcanic Day#2529", "Zone - Plaguelands#6066", "Zone-TavernAlliance#4516", "Zone-TavernPirate#11805",}) -- "Moment - Battle06#6350"
			Zn(L["Zones"], L["Kalimdor"], L["Silithus"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Silithus"], prefol, "MUS_Silithus_GD#22268", "MUS_Silithus_GN#22269", "MUS_SilithusDark#22559", "MUS_SilithusTwilight#22558", "AhnQirajInteriorCenterRoom#8579", "AhnQirajKingRoom#8578", "AhnQirajTriangleRoomWalking#8577", "Zone - AhnQirajExterior#8531", "Zone Music - AhnQirajInteriorWa#8563", "Zone-Desert Day#4754", "Zone-Desert Night#4755", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone-TavernNightElf02#80449",}) -- "Zone-Mystery#6065"
			Zn(L["Zones"], L["Kalimdor"], L["Southern Barrens"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Southern Barrens"], prefol, "MUS_SouthBarrens_GD#22270", "MUS_SouthBarrens_GN#22271", "MUS_SouthBarrenDwarf#22833", "MUS_SouthBarrensGreen#22846", "MUS_SouthBarrensHuman#22839", "MUS_SouthBarrensTaurens#22832", "MUS_Battlescar#22835", "MUS_DesolationHold#22837", "MUS_FrazzlecrazMotherlode#22841",}) -- "Moment - Battle04#6079"
			Zn(L["Zones"], L["Kalimdor"], L["Stonetalon Mountains"]						, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Stonetalon Mountains"], prefol, "MUS_StonetalonDruid#22856", "MUS_StonetalonGrimtotem#22848", "MUS_StonetalonNightElf#22855", "MUS_StonetalonOrcs#22854", "MUS_StonetalonTauren#22849", "MUS_StoneTalon_GU#22205", "MUS_KromgarFortress#22853", "MUS_TheSludgeworks#22850", "MUS_TheTalonDen#22857", "MUS_WebwinderHollow#22858", "MUS_WindshearHold#22859", "Zone-BarrenDry Night#2536", "Zone-EvilForest Day#2524", "Zone-Jungle Day#2525", "Zone-Night Forest#2533", "Zone - Plaguelands#6066", "Zone-TavernHorde#5234",})
			Zn(L["Zones"], L["Kalimdor"], L["Tanaris"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Tanaris"], prefol, "MUS_Tanaris_GD#22274", "MUS_Tanaris_GN#22275", "MUS_TanarisBugs#22873", "MUS_TanarisOgre#22868", "MUS_TanarisTrollA#22867", "MUS_TanarisTrollB#22871", "MUS_Gadgetzan#22866", "MUS_Uldum_GD#22284", "MUS_Uldum_GN#22285", "MUS_43_WellOfEternity_AzsharaWalk#26581", "MUS_43_HourOfTwilight_GeneralWalk#26604", "Zone-CavernsofTimeWalk#10764", "Zone-Desert Day#4754", "Zone-Desert Night#4755", "Zone-Jungle Day#2525", "Zone-Volcanic Day#2529", "MUS_715_TavernGoblin#80448",})
			Zn(L["Zones"], L["Kalimdor"], L["Teldrassil"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Teldrassil"], prefol, "MUS_BanethilBarrowDen#22885", "Zone-Darnassus#3920", "Zone-EnchantedForest Day#2530", "Zone-EnchantedForest Night#2540", "Zone-Evil Forest Night#2534", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082",}) -- "Zone-Mystery#6065"
			Zn(L["Zones"], L["Kalimdor"], L["Thousand Needles"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Thousand Needles"], prefol, "MUS_ThousandNeedles_GD#22280", "MUS_ThousandNeedlesGoblin#22729", "MUS_ThousandNeedlesGrimtotem#22730", "MUS_ThousandNeedlesTwilight#22733", "Zone-Desert Day#4754", "Zone-Desert Cave#5394", "Zone-Plains Day#2528", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone-Undead Dance#7083", "Zone-Undercity#5074", "Zone-TavernPirate#11805",}) -- "Zone-Mystery#6065"
			Zn(L["Zones"], L["Kalimdor"], L["Uldum"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Uldum"], prefol, "MUS_Uldum_GD#22284", "MUS_Uldum_GN#22285", "MUS_LostCityOfTheTolvir#23173", "MUS_Skywall#23175", "Zone-UldumAlt#23068",})
			Zn(L["Zones"], L["Kalimdor"], L["Un'Goro Crater"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Un'Goro Crater"], prefol, "MUS_FireplumeRidge#22737", "MUS_GolakkaHotSprings#22738", "MUS_UngoroBugs#22740", "Zone-Desert Day#4754", "Zone-Desert Night#4755", "Zone-Jungle Day#2525", "Zone-Soggy Night#6836", "Zone-UlduarStoneBattleWalk#14939",}) -- "Zone-Mystery#6065"
			Zn(L["Zones"], L["Kalimdor"], L["Winterspring"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Winterspring"], prefol, "MUS_Winterspring_GD#22288", "MUS_Winterspring_GN#22289", "MUS_WinterspringGoblin#22569", "MUS_WinterspringHaunted#22567", "MUS_WinterspringNightElf#22568", "MUS_HyjalTwilightDay#22911", "Zone-EvilForest Day#2524", "Zone - Plaguelands#6066", "Moment - Gloomy01#6074", "MUS_715_TavernGoblin#80448",}) -- "Zone-Mystery#6065", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082"

			-- Zones: Outland
			Zn(L["Zones"], L["Outland"], "|cffffd800", {""})
			Zn(L["Zones"], L["Outland"], "|cffffd800" .. L["Outland"], {""})
			Zn(L["Zones"], L["Outland"], L["Blade's Edge Mountains"]					, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Blade's Edge Mountains"], prefol, "Zone-BladesEdge#9002", "Zone-BladesedgeDryForest#10609", "Zone-BladesEdgeGruulsLairWalk#10730", "Zone-OutlandsHordeBase#9785", "Zone-Shaman#10163", "Zone-ZangarmarshCoilfangWalk#10726",})
			Zn(L["Zones"], L["Outland"], L["Hellfire Peninsula"]						, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Hellfire Peninsula"], prefol, "Zone-HellfirePeninsula#9773", "Zone-ThrallmarWalk#10864", "Zone-OutlandBloodElfBase#10606", "Zone-OutlandDraeneiBase#10607", "Zone-OutlandsAllianceBase#9786",}) -- "Zone - Plaguelands#6066"
			Zn(L["Zones"], L["Outland"], L["Nagrand"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Nagrand"], prefol, "Zone-NagrandDay#9012", "Zone-NagrandNight#9013", "Zone-OutlandsHordeBase#9785", "Zone-OutlandDraeneiBase#10607",}) -- "Zone-Volcanic Day#2529"
			Zn(L["Zones"], L["Outland"], L["Netherstorm"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Netherstorm"], prefol, "Zone-Netherstorm#9284", "Zone-NetherplantWalking#10847", "Zone-NetherstormEco-Domes#10849", "Zone-OutlandBloodElfHostile#10856", "Zone-OutlandDraeneiBase#10607",})
			Zn(L["Zones"], L["Outland"], L["Shadowmoon Valley"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Shadowmoon Valley"], prefol, "Zone-ZangarmarshCoilfangWalk#10726", "Zone-OutlandCorruptWalk#10848", "Zone-OutlandsHordeBase#9785", "Zone-OutlandsAllianceBase#9786", "Zone-OutlandDraeneiBase#10607", "Zone-BlackTempleWalk#11696", "Zone-BlackTempleKaraborWalk#11697", "Zone-BlackTempleSanctuaryWalk#11699", "Zone-BlackTempleAnguishWalk#11700", "Zone-BlackTempleVigilWalk#11701", "Zone-BlackTempleReliquaryWalk#11702", "Zone-BlackTempleDenWalk#11703",})
			Zn(L["Zones"], L["Outland"], L["Terokkar Forest"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Terokkar Forest"], prefol, "Zone-Terokkar#9150", "Zone-TerokkarAchinounWalk#10729", "Zone-BoneWastesUni#9991", "Zone-OutlandBloodElfHostile#10856", "Zone-OutlandDraeneiBase#10607", "Zone-OutlandsHordeBase#9785", "Zone-OutlandsAllianceBase#9786",})
			Zn(L["Zones"], L["Outland"], L["Zangarmarsh"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Zangarmarsh"], prefol, "Zone-ZangarMarsh#9149", "Zone-ZangarmarshCoilfangWalk#10726", "Zone-ExodarWalking#9972", "Zone-OutlandsHordeBase#9785", "Zone-OutlandDraeneiBase#10607", "Zone-TavernNightElf02#80449",}) -- "Moment - Gloomy01#6074"

			-- Zones: Northrend
			Zn(L["Zones"], L["Northrend"], "|cffffd800", {""})
			Zn(L["Zones"], L["Northrend"], "|cffffd800" .. L["Northrend"], {""})
			Zn(L["Zones"], L["Northrend"], L["Borean Tundra"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Borean Tundra"], prefol, "Zone-BoreanTundraDay#12746", "Zone-BoreanTundraNight#12747", "Zone-BoreanTundraTuskarrDay#12562", "Zone-BoreanTundraTuskarrNight#12561", "Zone-BoreanTundraGeyserFields#15101", "Zone-TaunkaDay#12802", "Zone-TaunkaNight#12803", "Zone-ColdarraGeneralWalk#14958", "Zone-ColdarraNexusEXT#14959", "Zone-NorthrenScourge#15049", "Zone-NorthrenOrcGeneralDay#15041", "Zone-NorthrenOrcGeneralNight#15042", "Zone-NorthrenRiplashDay#15044", "Zone-NorthrenRiplashNight#15045", "Zone-NorthrenDarker#15050", "Zone-NexusC#15059", "Zone-NexusD#15060", "Zone - NaxxramsDeathKnight#8687", "Zone-TavernAlliance#4516",})
			Zn(L["Zones"], L["Northrend"], L["Crystalsong Forest"]						, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Crystalsong Forest"], prefol, "Zone-CrystalSongForest#14905", "Zone-DalaranCity#14906", "Zone-DalaranCityCitadelInterior#14995", "Zone-DalaranSewersWalkUni#14908", "Zone-TavernAlliance#4516", "Zone-TavernHorde#5234", "MUS_60_Proudmoore_03#49358",})
			Zn(L["Zones"], L["Northrend"], L["Dragonblight"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Dragonblight"], prefol, "Zone-DragonblightDay#12744", "Zone-DragonblightNight#12745", "Zone-DragonblightTuskarrDay#12563", "Zone-DragonblightTuskarrNight#12564", "Zone-DragonBlightWyrmrestDay#15121", "Zone-DragonBlightWyrmrestNight#15122", "Zone-NaxxramasAbominationBoss#8888", "Zone-NaxxramasAbomination#8883", "Zone-NaxxramasSpider#8884", "Zone-NaxxramasPlagueBoss#8886", "Zone-NaxxramasPlague#8885", "Zone-NaxxramasSpiderBoss#8887", "Zone-NaxxramasKelthuzad#8889", "Zone-NaxxramasFrostWyrm#8890", "Zone - NaxxramsDeathKnight#8687", "Zone-TaunkaDay#12802", "Zone-TaunkaNight#12803", "Zone-SholazarWalkDay#14893", "Zone-SholazarWalkNight#14894", "Zone-NorthrenOrcGeneralDay#15041", "Zone-NorthrenOrcGeneralNight#15042", "Zone-NorthrenRiplashDay#15044", "Zone-NorthrenRiplashNight#15045", "Zone-NorthrenTroll#15048", "Zone-NorthrenScourge#15049", "Zone-NorthrenDarker#15050", "Zone-AzjolNerubA#15096",}) -- "Zone-Haunted#2990", "Moment - Gloomy02#6075", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone-EbonHDeathsBreachWalk#14961", "Zone-EbonHNewAvalonWalk#14964"
			Zn(L["Zones"], L["Northrend"], L["Grizzly Hills"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Grizzly Hills"], prefol, "Zone-GrizzlyHillsDay#12816", "Zone-GrizzlyHillsNight#12817", "Zone-GrizzlyHillsDayB#15036", "Zone-GrizzlyHillsNightB#15037", "Zone-GrizzlyHillsDayC#15038", "Zone-GrizzlyHillsNightC#15039", "Zone-GrizzlyHillsNightC-withTotems#77323", "Zone-TaunkaDay#12802", "Zone-TaunkaNight#12803", "Zone-IronDwarfDay#12824", "Zone-IronDwarfNight#12825", "Zone-VrykulWalk#14997", "Zone-NorthrenOrcGeneralDay#15041", "Zone-NorthrenOrcGeneralNight#15042", "Zone-NorthrenRiplashDay#15044", "Zone-NorthrenRiplashNight#15045", "Zone-NorthrenTroll#15048",}) -- "Zone-Mystery#6065", "Zone-EbonHNewAvalonWalk#14964"
			Zn(L["Zones"], L["Northrend"], L["Howling Fjord"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Howling Fjord"], prefol, "Zone-HowlingFjordDay#12800", "Zone-HowlingFjordNight#12801", "Zone-HowlingFjordTuskarrDay#12565", "Zone-HowlingFjordTuskarrNight#12566", "Zone-TaunkaDay#12802", "Zone-TaunkaNight#12803", "Zone-IronDwarfDay#12824", "Zone-IronDwarfNight#12825", "Zone-VrykulWalk#14997", "Zone-TavernUndead#12137", "Zone-TavernAlliance#4516",}) -- "Zone-Cursed Land Felwood#5455", "Zone-Mystery#6065", "Zone-EbonHNewAvalonWalk#14964"
			Zn(L["Zones"], L["Northrend"], L["Icecrown"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Icecrown"], prefol, "Zone-IcecrownGeneralWalkDay#13801", "Zone-IcecrownGeneralWalkNight#13802", "Zone-ColdarraGeneralWalk#14958", "Zone-UtgardeA#15062", "Zone-VrykulWalk#14997", "Zone-NorthrenScourge#15049", "Zone-NorthrenDarker#15050", "Zone-IcecrownDungeonWalk#17278", "AT_TournamentNightWalk#15850", "AT_TournamentDayWalk#15851",}) -- "Zone - Plaguelands#6066", "Zone-EbonHNewAvalonWalk#14964"
			Zn(L["Zones"], L["Northrend"], L["Sholazar Basin"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Sholazar Basin"], prefol, "Zone-SholazarWalkDay#14893", "Zone-SholazarWalkNight#14894", "Zone-MakersTerrace#14896", "Zone-FireWalk#14897", "Zone-Pillartops#14898", "Zone-PathofLife#14902", "Zone-UlduarStoneGeneralWalk#14937",})
			Zn(L["Zones"], L["Northrend"], L["Storm Peaks"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Storm Peaks"], prefol, "Zone-StormpeaksDay#13799", "Zone-StormpeaksNight#13800", "Zone-IronDwarfDay#12824", "Zone-IronDwarfNight#12825", "Zone-UlduarStoneBattleWalk#14939", "Zone-VrykulWalk#14997", "Zone-NorthrenDarker#15050", "UR_FormationGroundsWalk#15862",}) -- "Zone-Mystery#6065", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Moment-Monestery#7519", "Zone-EbonHNewAvalonWalk#14964"
			Zn(L["Zones"], L["Northrend"], L["Wintergrasp"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Wintergrasp"], prefol, "Zone-WintergraspContested#14912", "Zone-UldarLightningGeneralWalk#14942",})
			Zn(L["Zones"], L["Northrend"], L["Zul'Drak"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Zul'Drak"], prefol, "Zone-ZulDrakGeneralWalkDay#13804", "Zone-ZulDrakGeneralWalkNight#13805", "Zone-ZuldrakMamtoth#15114", "Zone-ZuldrakQuetzlun#15115", "Zone-ZuldrakRhunok#15116", "Zone-ZuldrakSsertus#15117", "Zone-EbonHDeathsBreachWalk#14961", "Zone-DraktharonRaptorPens#15087", "Zone-NorthrenScourge#15049", "Zone - NaxxramsDeathKnight#8687",})

			-- Zones: Maelstrom
			Zn(L["Zones"], L["Maelstrom"], "|cffffd800", {""})
			Zn(L["Zones"], L["Maelstrom"], "|cffffd800" .. L["Maelstrom"], {""})
			Zn(L["Zones"], L["Maelstrom"], L["Deepholm"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Deepholm"], prefol, "MUS_Deepholme#23056", "MUS_DeepholmeTwilight#23057", "MUS_DeepholmeCrystal#23058", "MUS_Bloodtrail#23063",})
			Zn(L["Zones"], L["Maelstrom"], L["Kezan"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Kezan"], prefol, "MUS_Kezan#22254", "MUS_KajaMine#22550", "MUS_KajaroField#22552", "MUS_Drudgetown#22544", "MUS_FirstBankOfKezan#22545", "MUS_GallywixsVilla#22547", "MUS_GallywixsYacht#22549", "MUS_TheSlick#22555", "MUS_ThePipe#22557",})
			Zn(L["Zones"], L["Maelstrom"], L["Lost Isles"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Lost Isles & Kazan"], prefol, "MUS_LostIsles_GD#23101", "MUS_LostIsles_GN#23102", "MUS_LostIslesMining#23107", "MUS_LostIslesPygmy#23122", "MUS_LostIslesNaga#23137", "MUS_KajamiteCavern#23115", "MUS_KTCOilPlatform#23117", "MUS_WarchiefsLookout#23142", "MUS_HordeBaseCamp#23113",})

			-- Zones: Pandaria
			Zn(L["Zones"], L["Pandaria"], "|cffffd800", {""})
			Zn(L["Zones"], L["Pandaria"], "|cffffd800" .. L["Pandaria"], {""})
			Zn(L["Zones"], L["Pandaria"], L["Dread Wastes"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Dread Wastes"], prefol, "MUS_50_DreadWastes_General_Walk#29201", "MUS_50_DW_AmberglowHollow_Walk#33841", "MUS_50_DW_RikkitunVillage_Walk#33822", "MUS_50_DW_TheSunsetBrewgarden_Walk#33829", "MUS_50_DW_TheHorridMarch_TheThunderingRun_Walk#33831", "MUS_50_DW_TerraceofGurthan_Walk#33832", "MUS_50_DW_ForgottenMire_Walk#33834", "MUS_50_DW_TheBrinyMuck_Walk#33843", "MUS_50_DW_LakeOfStars_Walk#33835", "MUS_50_DW_SoggysGamble_Walk#33836", "MUS_50_DW_KypaIk_Walk#33839", "MUS_50_DW_Klaxxivess_Walk#33840", "MUS_50_DW_WhisperingStones_Walk#33844", "MUS_50_MischiefMakers_GeneralWalk#33537", "PVP-Battle Grounds--DeepwindGorge#37659",})
			Zn(L["Zones"], L["Pandaria"], L["Isle of Thunder"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Isle of Thunder"], prefol, "MUS_52_IOTK_IsleOfThunder_General_Walk#36641", "MUS_52_IOTK_Zandalari1_General_Walk#36642", "MUS_52_IOTK_Zandalari2_General_Walk#36644", "MUS_52_IOTK_Zandalari3_General_Walk#36678", "MUS_52_IOTK_Saurok_Walk#36681", "MUS_52_IOTK_MoguGraveyard_Walk#36769", "MUS_52_IOTK_MoguCaves_Walk#36781", "MUS_52_IOTK_Raid_Wing3_AncientMogu_Walk#36782", "MUS_52_IOTK_LootRoom_Intensity1#36909", "MUS_52_IOTK_LootRoom_Intensity2#36910", "MUS_52_IOTK_LootRoom_Intensity3#36911", "MUS_52_IOTK_LootRoom_Intensity0#36916", "MUS_52_IOTK_ShadoPan_Walk#36967", "MUS_52_IOTK_HordeHub_Walk#36770", "MUS_52_IOTK_AllianceHub_Walk#36771", "MUS_52_TKRaid_ThroneOfThunder_Main#36702",})
			Zn(L["Zones"], L["Pandaria"], L["Jade Forest"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Jade Forest"], prefol, "MUS_50_JF_JadeForest_GeneralWalk_Day#29196", "MUS_50_JF_JadeForest_GeneralWalk_Night#31837", "MUS_50_JF_SerpentsHeart_Day#31838", "MUS_50_JF_SerpentsHeart_Night#31839", "MUS_50_JF_TempleoftheJadeSerpent_CourtyardWalk#29202", "MUS_50_JF_Windspire_Walk#30621", "MUS_50_JF_JadeForest_VillageWalk#33641", "MUS_50_JF_LairoftheJadeWitch_Walk#34014", "MUS_50_JF_EmperorsOmen_Walk#34022", "MUS_50_SpiritCave_Walk#29218", "MUS_50_Spirits_B#33112", "MUS_50_Hozen_Walk_Day#30437", "MUS_50_Hozen_Walk_Night#33640", "MUS_50_Mogu_Walk#30527", "MUS_50_Jinyu_Day#31124", "MUS_50_Jinyu_Night#33639", "MUS_50_PandarenTavern_A#33540", "MUS_50_TJS_FountainoftheEverseeing_Walk#30456", "MUS_50_TJS_Dungeon_FountainoftheEverseeing_Walk#31987", "MUS_50_TJS_Dungeon_ShaofDoubt_Battle#31990", "MUS_50_TJS_Dungeon_ScrollkeepersSanctum_Battle#31991", "MUS_50_TJS_Dungeon_TempleoftheJadeSerpent_GeneralWalk#31992",}) -- "Zone-IcecrownGeneralWalkDay#13801", "Zone-IcecrownGeneralWalkNight#13802"
			Zn(L["Zones"], L["Pandaria"], L["Krasarang Wilds"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Krasarang Wilds"], prefol, "MUS_50_KW_TurtleBeach_Day#33376", "MUS_50_KW_TurtleBeach_Night#33379", "MUS_50_KW_KrasarangWilds_Jungle#33894", "MUS_50_KW_KrasarangWilds_Coast#33895", "MUS_50_KW_TempleoftheRedCrane_Walk#33897", "MUS_50_KW_Hozen_Walk#33898", "MUS_51_KW_KrasarangWilds_Goblin_Walk#34884", "MUS_51_KW_KrasarangWilds_MoguCave#34885", "MUS_51_KW_LionsLanding_Day_Walk#34880", "MUS_51_KW_LionsLanding_Night_Walk#34881", "MUS_51_KW_DominationPoint_Walk#34883", "MUS_50_Mogu_Walk#30527", "MUS_50_Jinyu_Day#31124", "MUS_50_Jinyu_Night#33639", "MUS_50_GSS_SerpentSpine_VEB_DW_Walk#34001", "MUS_50_CaveGeneric_A#34021", "MUS_51_Scenario_ALittlePatience#34979",}) -- "MUS_Kezan#22254", "MUS_MulgoreTauren#22810", "MUS_FrazzlecrazMotherlode#22841", "MUS_DesolaceNightElf#23021", "MUS_43_DarkmoonFaire_IslandWalk#26536"
			Zn(L["Zones"], L["Pandaria"], L["Kun-Lai Summit"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Kun-Lai Summit"], prefol, "MUS_50_KLS_ValleyofEmperors_GeneralWalk#33885", "MUS_50_KLS_Mountains_GeneralWalk_Day#33865", "MUS_50_KLS_Mountains_GeneralWalk_Night#33866", "MUS_50_KLS_MountainHozen_Walk#33869", "MUS_50_KLS_YaungolAdvance_Walk#33867", "MUS_50_KLS_GrummleCamp_Walk#33870", "MUS_50_KLS_TempleoftheWhiteTiger_Walk#33872", "MUS_50_KLS_PeakofSerenity_Walk#33874", "MUS_50_KLS_PeakofSerenity_MistweaverWalk#33875", "MUS_50_KLS_PeakofSerenity_BrewmasterWalk#33876", "MUS_50_KLS_PeakofSerenity_WindwalkerWalk#33877", "MUS_50_KLS_PeakofSerenity_CraneWalk#33878", "MUS_50_KLS_ZouchinVillage_Walk#33880", "MUS_50_KLS_IsleofReckoning_Walk#33881", "MUS_50_KLS_ShadopanDefenseForce#33882", "MUS_50_KLS_TheBurlapTrail_Walk#33883", "MUS_50_KLS_YakWash_Walk#33886", "MUS_50_Jinyu_Day#31124", "MUS_50_Jinyu_Night#33639", "MUS_50_Spirits_B#33112", "MUS_50_MischiefMakers_GeneralWalk#33537", "MUS_50_PandarenTavern_A#33540", "MUS_50_SPM_Dungeon_ShadoPan_GeneralWalk#33651", "MUS_50_SPM_ShadoPan_GeneralWalk#33694",}) -- "Zone-Desert Cave#5394", "Zone - Plaguelands#6066" 
			Zn(L["Zones"], L["Pandaria"], L["Timeless Isle"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Timeless Isle"], prefol, "MUS_54_TI_TimelessIsle_Intro#39124", "MUS_54_TI_TimelessIsle_GeneralWalk_Day#39129", "MUS_54_TI_TimelessIsle_GeneralWalk_Night#39128", "MUS_54_TI_Timeless_VillageWalk#39126", "MUS_54_TI_Timeless_CelestialCourt#39687", "MUS_54_TI_Timeless_OrdonSantuary#39688", "MUS_54_TI_Timeless_FirewalkersPath#39689",})
			Zn(L["Zones"], L["Pandaria"], L["Townlong Steppes"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Townlong Steppes"], prefol, "MUS_50_TownlongSteppes_GeneralWalk_Day#30435", "MUS_50_TownlongSteppes_GeneralWalk_Night#31836", "MUS_50_TS_SikvessLair_Walk#33855", "MUS_50_TS_FarwatchOverlook_Walk#33856", "MUS_50_TS_GaoRan_Walk#33859", "MUS_50_TS_Sravess_Walk#33961", "MUS_50_TS_Sumprush_Walk#33858", "MUS_50_TS_HatredsVice_Walk#33861", "MUS_50_TS_FireCampGaiCho_Walk#33934", "MUS_50_TS_GaiChoBattlefield_Walk#33935", "MUS_50_SiegeofNiuzaoTemple_Hero#30624", "MUS_50_Spirits_B#33112",}) -- "Zone-Mystery#6065"
			Zn(L["Zones"], L["Pandaria"], L["Vale of Eternal Blossoms"]					, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Vale of Eternal Blossoms"], prefol, "MUS_50_VEB_ValeofEternalBlossom_GeneralDay_Walk#29205", "MUS_50_VEB_ValeofEternalBlossom_GeneralNight_Walk#30638", "MUS_50_VEB_TheGoldenPagoda_Walk#33780", "MUS_50_VEB_AncestralRise_Walk#33781", "MUS_50_VEB_MSP_Exterior_Walk#33785", "MUS_50_VEB_Shrine_TheStarsBazaar_A_Walk#33786", "MUS_50_VEB_Shrine_TheEmperorsStep_A_Walk#33787", "MUS_50_VEB_Shrine_TheGoldenLantern_Walk#33789", "MUS_50_VEB_Shrine_ChamberofReflection_A_Walk#33791", "MUS_50_VEB_Shrine_PathofSerentiy_A_Walk#33796", "MUS_50_VEB_Shrine_EtherealCorridor_A_Walk#33797", "MUS_50_VEB_Shrine_ChamberofEnlightenment_A_Walk#33798", "MUS_50_VEB_Shrine_TheCelestialVault_A_Walk#33799", "MUS_50_VEB_Shrine_TheKeggary_Walk#33808", "MUS_50_VEB_RuinsRise_Walk#33810", "MUS_50_VEB_RuinsofGuoLai_Walk#33811", "MUS_50_VEB_TheFiveSisters_Walk#33812", "MUS_50_VEB_SettingSunGarrison_Walk#33813", "MUS_50_VEB_SettingSunGarrison_Brewery_Walk#33814", "MUS_50_VEB_TheSilentSanctuary_Walk#33815", "MUS_50_VEB_TheGoldenRose#33816", "MUS_50_VEB_WhitepetalLake_Walk#33817", "MUS_50_VEB_TheSummerFields_Walk#33991", "MUS_54_VEB_Corrupted_Worst_Day#39683", "MUS_54_VEB_Corrupted_Worst_Night#39684", "MUS_54_VEB_Corrupted_Moderate_Day#39685", "MUS_54_VEB_Corrupted_Moderate_Night#39686", "MUS_50_VEB_Shrine_ChamberofEnlightenment_H_Walk#39697", "MUS_50_VEB_Shrine_TheEmperorsStep_H_Walk#39698", "MUS_50_VEB_Shrine_PathofSerentiy_H_Walk#39699", "MUS_50_VEB_Shrine_EtherealCorridor_H_Walk#39700", "MUS_50_VEB_Shrine_TheCelestialVault_H_Walk#39701", "MUS_50_VEB_Shrine_TheStarsBazaar_H_Walk#39702",})
			Zn(L["Zones"], L["Pandaria"], L["Valley of the Four Winds"]					, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Valley of the Four Winds"], prefol, "MUS_50_VFW_TheHeartlandWalk_Day#31830", "MUS_50_VFW_TheHeartlandWalk_Night#30533", "MUS_50_VFW_GeneralWalk_Day#33686", "MUS_50_VFW_GeneralWalk_Night#33687", "MUS_50_VFW_PeacefulWalk#33689", "MUS_50_VFW_WindsEdgeWalk#33690", "MUS_50_VFW_BreweryWalk#33691", "MUS_50_VFW_TheHiddenMaster_Walk#33688", "MUS_50_Hozen_Walk_Day#30437", "MUS_50_Spirits_B#33112", "MUS_50_Jinyu_Day#31124", "MUS_50_MischiefMakers_GeneralWalk#33537", "MUS_50_PandarenTavern_A#33540", "MUS_50_GSS_SerpentSpine_VFW_DW_Walk#34002",})
			Zn(L["Zones"], L["Pandaria"], L["Wandering Isle"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Wandering Isle"], prefol, "MUS_50_WanderingIsle_GeneralWalk#25837", "MUS_50_WanderingIsle_GeneralIndoors#25838", "MUS_50_WanderingIsle_PeiWuWalk#25833", "MUS_50_WanderingIsle_HozenWalk#25834", "MUS_50_WanderingIsle_SpiritsWalk#25835", "MUS_50_WanderingIsle_WoodofStavesWalk#25836", "MUS_50_WanderingIsle_TrainingWalk#25851", "MUS_50_WanderingIsle_TempleWalk#25854", "MUS_50_WanderingIsle_Temple_PreFire#33596", "MUS_50_WanderingIsle_Temple_Water/Earth#33597", "MUS_50_WanderingIsle_Temple_Air#33598",})

			-- Zones: Draenor
			Zn(L["Zones"], L["Draenor"], "|cffffd800", {""})
			Zn(L["Zones"], L["Draenor"], "|cffffd800" .. L["Draenor"], {""})
			Zn(L["Zones"], L["Draenor"], L["Ashran"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Ashran"], prefol, "MUS_60_PVP_Ashran_GeneralWalk#48481", "MUS_60_PVP_Ashran_AmphitheaterofAnnihilation_Walk#48500", "MUS_60_PVP_Ashran_AshmaulBurialGrounds#48482", "MUS_60_PVP_Ashran_MoltenQuarry_Walk#48485", "MUS_60_PVP_Ashran_OgreMine_Walk#48486", "MUS_60_PVP_Ashran_RingOfConquest_Walk#48641", "MUS_60_PVP_Ashran_RoadofGlory_Walk#48480", "MUS_60_PVP_Ashran_Stormshield_Battle#48537", "MUS_60_PVP_Ashran_Stormshield_Messhall_Harp#47068", "MUS_60_PVP_Ashran_Stormshield_Walk#48487", "MUS_60_PVP_Ashran_Warspear_Battle#48538", "MUS_60_PVP_Ashran_Warspear_Walk#48488", "PVP-AshranEventActive#47160",})
			Zn(L["Zones"], L["Draenor"], L["Frostfire Ridge"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Frostfire Ridge"], prefol, "MUS_60_FFR_General_Walk#49001", "MUS_60_FFR_General_Night_Walk#49355", "MUS_60_FFR_DarkRock#49005", "MUS_60_FFR_Fel_Walk#49194", "MUS_60_FFR_Frostwolf_Walk#49189", "MUS_60_FFR_IronHorde_Walk#49191", "MUS_60_FFR_Mushroom_Sea_Walk#49193", "MUS_60_FFR_Ogre_Battle#49195", "MUS_60_FFR_Ogre_Walk#49192", "MUS_60_FFR_Thunderlord_Walk#49190",})
			Zn(L["Zones"], L["Draenor"], L["Gorgrond"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Gorgrond"], prefol, "MUS_60_Gorgrond_Blackrock_Walk#48914", "MUS_60_Gorgrond_CrimsonFen_Walk#48915", "MUS_60_Gorgrond_Jungle_Walk#48912", "MUS_60_Gorgrond_LaughingSkull_Walk#48909", "MUS_60_Gorgrond_Mushroom_Sea_Walk#48911", "MUS_60_Gorgrond_Wasteland_Walk#48913",})
			Zn(L["Zones"], L["Draenor"], L["Nagrand (Draenor)"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Nagrand"], prefol, "MUS_60_NGD_General_Walk#49065", "MUS_60_NGD_General_Night_Walk#49066", "MUS_60_NGD_BurningBlade_Walk#49076", "MUS_60_NGD_IronHorde_Walk#49072", "MUS_60_NGD_Mushroom_Walk#49070", "MUS_60_NGD_Ogre_Walk#49068", "MUS_60_NGD_OrcAncestors_Walk#49078", "MUS_60_NGD_Oshu'gun_Walk#49069", "MUS_60_NGD_RingofTrials_ArenaFloor_Battle#49077", "MUS_60_NGD_Underpale_Walk#49075", "MUS_60_NGD_Warsong_Walk#49067",})
			Zn(L["Zones"], L["Draenor"], L["Shadowmoon Valley (Draenor)"]				, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Shadowmoon Valley"], prefol, "MUS_60_SMV_General_Walk#48553", "MUS_60_SMV_General_Night_Walk#48554", "MUS_60_SMV_Cultist_Walk#48555", "MUS_60_SMV_DarkDraenei_Walk#49030", "MUS_60_SMV_Draenei_Karabor_Walk#48562", "MUS_60_SMV_Draenei_Walk#48559", "MUS_60_SMV_Fel_Walk#48556", "MUS_60_SMV_IronHorde_Walk#49031", "MUS_60_SMV_MoonMagic_Walk#48560", "MUS_60_SMV_Mushroom_Walk#48561", "MUS_60_SMV_NerzhulFinale_CultistBattle_Phase#49254", "MUS_60_SMV_Podling_Walk#48558", "MUS_60_SMV_Primals_Walk#48557", "MUS_60_SMV_YrelsCoronation_Phase_Playlist#49250", "MUS_60_SMV_Vignette_VindicatorTorvath#43487",})
			Zn(L["Zones"], L["Draenor"], L["Spires of Arak"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Spires of Arak"], prefol, "MUS_60_SOA_General_Walk#48883", "MUS_60_SOA_AdmiralTaylorsGarrison_Inn#49032", "MUS_60_SOA_AdmiralTaylorsGarrison_Walk#48896", "MUS_60_SOA_Arakkoa_BombingRun#49174", "MUS_60_SOA_Arakkoa_Exiles_Walk#48894", "MUS_60_SOA_Arakkoa_Exiles_Night_Walk#49034", "MUS_60_SOA_Arakkoa_High_Walk#48885", "MUS_60_SOA_AvatarofTerokk_Phase#49176", "MUS_60_SOA_Axefall_Garrison_Walk#49037", "MUS_60_SOA_Bladefist_Walk#49035", "MUS_60_SOA_Goblin_Walk#48887", "MUS_60_SOA_Mushroom_Walk#48897", "MUS_60_SOA_SethekkHollow_Walk#48895", "MUS_60_SOA_Southport_Garrison_Walk#49036",})
			Zn(L["Zones"], L["Draenor"], L["Talador"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Talador"], prefol, "MUS_60_TD_General_Walk#49079", "MUS_60_TD_Arakkoa_Walk#49085", "MUS_60_TD_Auchindoun_Walk#49082", "MUS_60_TD_CrystalMine_Walk#49088", "MUS_60_TD_DeathwebHollow_Walk#49087", "MUS_60_TD_Draenei_Walk#49081", "MUS_60_TD_DraeneiHoly_Walk#49083", "MUS_60_TD_DraeneiWartorn_Walk#49089", "MUS_60_TD_Fel_Walk#49084", "MUS_60_TD_Ogre_Walk#49086", "MUS_60_TD_Zangarra_Walk#49354",})
			Zn(L["Zones"], L["Draenor"], L["Tanaan Jungle"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Tanaan Jungle"], prefol, "MUS_60_TJ_BlackrockQuarry_Walk#48335", "MUS_60_TJ_Guldan_Walk#48333", "MUS_60_TJ_HeartBlood_Walk#48334", "MUS_60_TJ_KargathProvingGrounds_Walk#48296", "MUS_60_TJ_PathofGlory_Walk#48298", "MUS_60_TJ_UmbralHalls_Walk#48299",})

			-- Zones: Broken Isles
			Zn(L["Zones"], L["Broken Isles"], "|cffffd800", {""})
			Zn(L["Zones"], L["Broken Isles"], "|cffffd800" .. L["Broken Isles"], {""})
			Zn(L["Zones"], L["Broken Isles"], L["Antoran Wastes (Argus)"]				, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Antoran Wastes (Argus)"], prefol, "MUS_73_AntoranWastes_GeneralWalk#90584", "MUS_73_AntoranWastes_FullLegionWalk#90587", "MUS_73_AntoranWastes_HoldoutWalk#90586", "MUS_70_Invasion_Legion_GeneralWalk#75371", "MUS_70_Mardum_TheDoomFortress#56362", "MUS_73_Vindicaar_Walk_OverAntoranWastes_Gold#90700", "MUS_73_RAID_AntorusGeneralWalk#90609",})
			Zn(L["Zones"], L["Broken Isles"], L["Azsuna"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Azsuna"], prefol, "MUS_70_Zone_Azsuna_GeneralWalk_Day#73363", "MUS_70_Zone_Azsuna_GeneralWalk_Night#73362", "MUS_70_Zone_Azsuna_Artif_Walk#77082", "MUS_70_Zone_Azsuna_Legion_WalkE#75106", "MUS_70_Zone_Azsuna_Sombre_Walk#77083", "MUS_70_Zone_Azsuna_WalkB#75104", "MUS_70_Zone_Azsuna_WalkC#75105", "MUS_70_Zone_Azsuna_WalkD#75216",})
			Zn(L["Zones"], L["Broken Isles"], L["Broken Shore"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Broken Shore"], prefol, "MUS_70_BrokenShore_GeneralWalk_A#75355", "MUS_70_BrokenShore_Alliance_Walk#75363", "MUS_70_BrokenShore_Ashbringer_Moment#53990", "MUS_70_BrokenShore_Horde_Walk#75366", "MUS_70_BrokenShore_Legion_Walk_TensionA#75367", "MUS_70_BrokenShore_Legion_Walk_TensionB#75368", "MUS_70_Artif_BrokenShore_BattleWalk#53988", "MUS_70_Artif_BrokenShore_CaveWalk#53989",})
			Zn(L["Zones"], L["Broken Isles"], L["Dalaran"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Dalaran"], prefol, "MUS_70_Zone_Dalaran_Ext_GeneralWalk_DAY#70715", "MUS_70_Zone_Dalaran_Ext_GeneralWalk_NIGHT#70716", "MUS_70_Zone_Dalaran_Ext_KrasusLanding#75072", "MUS_70_Zone_Dalaran_Mage_OH_Bold#75109", "MUS_70_Zone_Dalaran_Mage_OH_Light#75108", "MUS_70_Zone_Dalaran_Mage_Walk_A#75050", "MUS_70_Zone_Dalaran_Mage_Walk_B#75052", "MUS_70_Zone_Dalaran_Rogue_Walk_A#75292", "MUS_70_Zone_Dalaran_Rogue_Walk_B#75293", "MUS_70_Zone_Dalaran_Sewers_Walk_A#75048", "MUS_70_Zone_Dalaran_Sewers_Walk_B#75049",}) -- "MUS_70_Zone_Dalaran_Brewfest_Beergarden#75107", "MUS_70_Zone_Dalaran_Sewer_DwarfBardEmitter#75094"
			Zn(L["Zones"], L["Broken Isles"], L["Highmountain"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Highmountain"], prefol, "MUS_70_Zone_Highmountain_Mountain_General_Walk#73367", "MUS_70_Zone_Highmountain_Azshara_HulnFlashback_Walk#22964", "MUS_70_Zone_Highmountain_Bloodtotem#73366", "MUS_70_Zone_Highmountain_Coast_Walk#76578", "MUS_70_Zone_Highmountain_DrogbarEarth_Walk#76613", "MUS_70_Zone_Highmountain_HunterLodge_Walk#76579", "MUS_70_Zone_Highmountain_River#76575", "MUS_70_Zone_Highmountain_ThunderTotem_Inn#76616", "MUS_70_Zone_Highmountain_ThunderTotem_Walk#76577",})
			Zn(L["Zones"], L["Broken Isles"], L["Krokuun (Argus)"]						, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Krokuun (Argus)"], prefol, "mus_73_krokuun_generalwalk#90541", "mus_73_krokuun_battlefieldwalk#90542", "mus_73_krokuun_courtoftheavenger#90545", "mus_73_krokuun_xenedarlandingwalk#90543", "mus_73_vindicaar_walk_overkrokuun_gold#90698",})
			Zn(L["Zones"], L["Broken Isles"], L["Mac'Aree (Argus)"]						, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Mac'Aree (Argus)"], prefol, "MUS_73_MacAree_GeneralWalk#90485", "MUS_73_MacAree_VoidFullWalk#90509", "MUS_73_MacAree_KiljaedenWalk#90510", "MUS_73_TheSeatoftheTriumvirate_VoidMediumWalk#90573", "MUS_73_Vindicaar_Walk_OverMacAree_Gold#90699",})
			Zn(L["Zones"], L["Broken Isles"], L["Mardum"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Mardum"], prefol, "MUS_70_Mardum_WalkA#56358", "MUS_70_Mardum_WalkB#56361", "MUS_70_Mardum_WalkC#56360", "MUS_70_Mardum_IllidariFoothold#56363", "MUS_70_Mardum_TheDoomFortress#56362",})
			Zn(L["Zones"], L["Broken Isles"], L["Stormheim"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Stormheim"], prefol, "MUS_70_Zone_Stormheim_General_Walk#73360", "MUS_70_Zone_Stormheim_DarkCoast_Walk#76490", "MUS_70_Zone_Stormheim_Mountain_Walk#76489", "MUS_70_Zone_Stormheim_Mystic_Walk#76491", "MUS_70_Zone_Stormheim_Valor_Walk#76492", "MUS_70_Zone_Stormheim_Village_Walk#73361",})
			Zn(L["Zones"], L["Broken Isles"], L["Suramar"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Suramar"], prefol, "MUS_70_Zone_Suramar_Forest_General_Walk#73358", "MUS_70_Zone_Suramar_MoonGuard_Walk#73359", "MUS_70_Zone_Suramar_Sombre_Walk#76667", "MUS_70_Zone_SuramarCity_Corrupted_Walk#76670", "MUS_70_Zone_SuramarCity_Magnificent_Walk#76669", "MUS_70_Zone_SuramarCity_Occupied_Walk#76668", "MUS_70_Zone_Stormheim_General_Walk#73360", "MUS_70_Zone_Stormheim_Village_Walk#73361",})
			Zn(L["Zones"], L["Broken Isles"], L["Val'sharah"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Val'sharah"], prefol, "MUS_70_Zone_ValSharah_GeneralWalk_Day#73365", "MUS_70_Zone_ValSharah_GeneralWalk_Night#73364", "MUS_70_Zone_ValSharah_Dark_Walk#76207", "MUS_70_Zone_ValSharah_Gilnean_Walk#76210", "MUS_70_Zone_ValSharah_NightElf_BarrowDens_Walk#51337", "MUS_70_Zone_ValSharah_NightElf_Druid_Walk#76204", "MUS_70_Zone_ValSharah_NightElf_Ruins_Walk#76206", "MUS_70_Zone_ValSharah_NightElf_TempleWalk#76205",})

			-- Zones: Kul Tiras
			Zn(L["Zones"], L["Kul Tiras"], "|cffffd800", {""})
			Zn(L["Zones"], L["Kul Tiras"], "|cffffd800" .. L["Kul Tiras"], {""})
			Zn(L["Zones"], L["Kul Tiras"], L["Drustvar"]								, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Drustvar"], prefol, "MUS_80_Drustvar_AromsStand#115790", "MUS_80_Drustvar_Chandlery#116862", "MUS_80_Drustvar_Corlain#115798", "MUS_80_Drustvar_CrimsonForest#115793", "MUS_80_Drustvar_Fallhaven_Day#116808", "MUS_80_Drustvar_Fallhaven_Night#116809", "MUS_80_Drustvar_HighroadPass#115787", "MUS_80_Drustvar_Town#93658", "MUS_80_Drustvar_Waycrest#115809", "MUS_80_Vol'dun_Azerite#116567",})
			Zn(L["Zones"], L["Kul Tiras"], L["Stormsong Valley"]						, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Stormsong Valley"], prefol, "MUS_80_StormsongValley_Walk_Day#116050", "MUS_80_StormsongValley_Walk_Night#116068", "MUS_80_StormsongValley_Ashvane#116055", "MUS_80_StormsongValley_Horde#116057", "MUS_80_StormsongValley_Naga#116054", "MUS_80_StormsongValley_OldGods#116056", "MUS_80_StormsongValley_Quilboar#116052", "MUS_80_StormsongValley_ShrineofStorms#116091", "MUS_80_StormsongValley_Tortollan#116070",})
			Zn(L["Zones"], L["Kul Tiras"], L["Tiragarde Sound"]							, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Tiragarde Sound"], prefol, "MUS_80_TiragardeSound_Walk_Day#115888", "MUS_80_TiragardeSound_Walk_Night#115896", "MUS_80_TiragardeSound_Anglepoint_OldGods#116661", "MUS_80_TiragardeSound_Ashvane#115988", "MUS_80_TiragardeSound_Boralus_Day#116005", "MUS_80_TiragardeSound_Boralus_Night#116006", "MUS_80_TiragardeSound_Estate_Day#115967", --[["MUS_80_TiragardeSound_Estate_Night#115968",]] "MUS_80_TirgardeSound_Freehold#116110", "MUS_80_TiragardeSound_SirenSong#115999", "MUS_80_TiragardeSound_SirenSong_Cave#116659", "MUS_80_TiragardeSound_Proudmore_Day#116290", "MUS_80_TiragardeSound_Proudmore_Night#116291", "MUS_80_TiragardeSound_VigilHill_Day#115997", --[["MUS_80_TiragardeSound_VigilHill_Night#115998",]] "MUS_80_TiragardeSound_Witch#116660", --[["MUS_80_TiragardeSound_Taverns_Day#116559", "MUS_80_TiragardeSound_Taverns_Night#116560",]] "MUS_80_Vol'dun_Azerite#116567",})

			-- Zones: Zandalar
			Zn(L["Zones"], L["Zandalar"], "|cffffd800", {""})
			Zn(L["Zones"], L["Zandalar"], "|cffffd800" .. L["Zandalar"], {""})
			Zn(L["Zones"], L["Zandalar"], L["Nazmir"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Nazmir"], prefol, "MUS_80_Nazmir_GeneralWalk_Day#93666", "MUS_80_Nazmir_GeneralWalk_Night#116065", "MUS_80_Nazmir_Jurassic#116224", "MUS_80_Nazmir_Naga#116115", "MUS_80_Nazmir_Necropolis#116108", "MUS_80_Nazmir_Sethrak#116116", "MUS_80_Nazmir_Void#93672",})
			Zn(L["Zones"], L["Zandalar"], L["Vol'dun"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Vol'dun"], prefol, "MUS_80_Vol'dun_GeneralWalk_Day#116281", --[["MUS_80_Vol'dun_GeneralWalk_Night#116284",]] "MUS_80_Vol'dun_Ashvane#116538", "MUS_80_Vol'dun_Azerite#116567", "MUS_80_Vol'dun_Distorted#116561", "MUS_80_Vol'dun_Naga#116486", "MUS_80_Vol'dun_Sethrak#116484", "MUS_80_Vol'dun_Tortollan#116485", "MUS_80_Nazmir_Necropolis#116108",})
			Zn(L["Zones"], L["Zandalar"], L["Zuldazar"]									, {	"|cffffd800" .. L["Zones"] .. ": " .. L["Zuldazar"], prefol, "MUS_80_Zuldazar_GeneralWalk_Day#116611", --[["MUS_80_Zuldazar_GeneralWalk_Night#116629",]] "MUS_80_Zuldazar_Atal'Dazar#117049", "MUS_80_Zuldazar_Azerite#116609", "MUS_80_Zuldazar_BloodMagic#117025", "MUS_80_Zuldazar_Dazar'alor_Day#116674", "MUS_80_Zuldazar_Dazar'alor_Night#116986", --[["MUS_80_Zuldazar_Gral'sGrotto#117011",]] "MUS_80_Zuldazar_Naga#116962", "MUS_80_Zuldazar_Sethrak#116951", "MUS_80_Zuldazar_Tortollan#116964", "MUS_80_DGN_CityofGold_Grand#93663",})

			-- Dungeons: World of Warcraft
			Zn(L["Dungeons"], L["World of Warcraft"], "|cffffd800" .. L["World of Warcraft"], {""})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Blackfathom Deeps"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Blackfathom Deeps"], prefol, "Zone-Desert Day#4754", "Zone-Desert Night#4755",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Blackrock Depths"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Blackrock Depths"], prefol, "Zone-Volcanic Day#2529",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Blackwing Lair"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Blackwing Lair"], prefol, "Zone - Plaguelands#6066",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Deadmines"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Deadmines"], prefol, "MUS_Deadmines#23609", "MUS_ChoGall_E#22151", "Zone-Orgrimmar#2901", "Moment-Spooky01#5037",}) -- "Zone-Mystery#6065"
			Zn(L["Dungeons"], L["World of Warcraft"], L["Dire Maul"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Dire Maul"], prefol, "Zone-EnchantedForest Day#2530", "Zone-EnchantedForest Night#2540", "Zone-Evil Forest Night#2534",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Gnomeregan"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Gnomeregan"], prefol, "Zone-Gnomeragon#7341",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Maraudon"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Maraudon"], prefol, "Zone-BarrenDry Night#2536", "Zone-Soggy Day#7082", "Zone-Soggy Night#6836",}) -- "Moment - Battle02#6262"
			Zn(L["Dungeons"], L["World of Warcraft"], L["Molten Core"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Molten Core"], prefol, "Moment - Battle01#6077", "Moment - Battle02#6262", "Moment - Battle03#6078", "Moment - Battle04#6079", "Moment - Battle05#6253", "Moment - Battle06#6350",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Razorfen Downs"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Razorfen Downs"], prefol, "Zone-Undercity#5074", "Zone-Undead Dance#7083",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Ruins of Ahn'Qiraj"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Ruins of Ahn'Qiraj"], prefol, "Zone - AhnQirajExterior#8531",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Scarlet Halls"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Scarlet Halls"], prefol, "MUS_50_SM_Dungeon_TrainingWalk#33725", "MUS_50_ScarletMonastery_A_Hero#30478",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Scarlet Monastery"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Scarlet Monastery"], prefol, "MUS_50_SM_Dungeon_ChapelGardensWalk#33738", "MUS_50_SM_Dungeon_CrusaderWalk#33740", "MUS_50_SM_Dungeon_TunnelsWalk#33723", "MUS_50_SM_Dungeon_VestibuleWalk#33721", "MUS_50_ScarletMonastery_A_Hero#30478", "MUS_Haunted_UU#22182",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Scholomance"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Scholomance"], prefol, "MUS_50_Scholomance_Walk#33521", "MUS_50_Scholomance_ChamberofSummoning#33511", "MUS_50_Scholomance_HeadmastersStudy#33513", "MUS_50_Scholomance_TheReliquary#33510", "MUS_50_Scholomance_TheUpperStudy#33512",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Shadowfang Keep"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Shadowfang Keep"], prefol, "MUS_ShadowfangKeep#23610", "MUS_Scarred_UU#22198", "MUS_Shadows_UU#22200", "Zone-EvilForest Day#2524",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Stockade"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Stockade"], prefol, "StomWindJail#4223",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Stratholme"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Stratholme"], prefol, "Zone-Undercity#5074",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Sunken Temple"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Sunken Temple"], prefol, "MUS_SwampOfSorrowsTroll#22542", "Zone-Soggy Day#7082", "Zone-Soggy Night#6836", "Moment - Battle02#6262", "Moment - Battle05#6253", "Moment - Battle06#6350",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Temple of Ahn'Qiraj"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Temple of Ahn'Qiraj"], prefol, "AhnQirajInteriorCenterRoom#8579", "AhnQirajKingRoom#8578", "AhnQirajTriangleRoomWalking#8577", "Zone - AhnQirajExterior#8531", "Zone Music - AhnQirajInteriorWa#8563",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Wailing Caverns"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Wailing Caverns"], prefol, "MUS_TheWailingCaverns#22829", "Zone-Jungle Day#2525", "Zone-Jungle Night#2535", "Zone - Plaguelands#6066",})
			Zn(L["Dungeons"], L["World of Warcraft"], L["Zul'Farrak"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Zul'Farrak"], prefol, "MUS_TanarisTrollA#22867",})

			-- Dungeons: The Burning Crusade
			Zn(L["Dungeons"], L["The Burning Crusade"], "|cffffd800", {""})
			Zn(L["Dungeons"], L["The Burning Crusade"], "|cffffd800" .. L["The Burning Crusade"], {""})
			Zn(L["Dungeons"], L["The Burning Crusade"], L["Black Morass"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Black Morass"], prefol, "Zone-CavernsofTimeBlackMorassWa#10731",})
			Zn(L["Dungeons"], L["The Burning Crusade"], L["Black Temple"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Black Temple"], prefol, "Zone-BlackTempleWalk#11696", "Zone-BlackTempleKaraborWalk#11697", "Zone-BlackTempleSanctuaryWalk#11699", "Zone-BlackTempleAnguishWalk#11700", "Zone-BlackTempleVigilWalk#11701", "Zone-BlackTempleReliquaryWalk#11702", "Zone-BlackTempleDenWalk#11703", "Event_BlackTemplePreludeEvent01#11716",})
			Zn(L["Dungeons"], L["The Burning Crusade"], L["Coilfang Reservoir"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Coilfang Reservoir"], prefol, "Zone-ZangarmarshCoilfangWalk#10726",})
			Zn(L["Dungeons"], L["The Burning Crusade"], L["Hellfire Ramparts"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Hellfire Ramparts"], prefol, "Zone-HellfireCitadelRampartsWal#10727",})
			Zn(L["Dungeons"], L["The Burning Crusade"], L["Hyjal Summit"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Hyjal Summit"], prefol, "Zone-HyjalPastNordrassilWalk#11652", "Zone-HyjalPastSummitWalk#11653",})
			Zn(L["Dungeons"], L["The Burning Crusade"], L["Karazhan"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Karazhan"], prefol, "Zone-KarazhanGeneralDefault#12154", "Zone-KarazhanFoyerWalk#12156", "Zone-KarazhanStableWalk#12159", "Zone-KarazhanOperaWalk#12163", "Zone-KarazhanBackstageWalk#12162", "Zone-KarazhanLibraryWalk#12164", "Zone-KarazhanTowerNetherspiteW#12170", "Zone-KarazhanMalchezaarWalk#12168",})
			Zn(L["Dungeons"], L["The Burning Crusade"], L["Old Hillsbrad Foothills"]	, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Old Hillsbrad Foothills"], prefol, "MUS_DurnholdeKeep#22788", "MUS_TarrenMill#22790", "Zone-CavernsoftimeHillsbradExtW#10770",})
			Zn(L["Dungeons"], L["The Burning Crusade"], L["Sunwell Plateau"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Sunwell Plateau"], prefol, "Zone-SunwellPlateauWalking#12536",})
			Zn(L["Dungeons"], L["The Burning Crusade"], L["Tempest Keep"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Tempest Keep"], prefol, "Zone-TempestKeepWalkingUni#12128", "Zone-TempestKeepBosses#12129",})

			-- Dungeons: Wrath of the Lich King
			Zn(L["Dungeons"], L["Wrath of the Lich King"], "|cffffd800", {""})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], "|cffffd800" .. L["Wrath of the Lich King"], {""})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Ahn'kahet (Old Kingdom)"]	, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Ahn'kahet (Old Kingdom)"], prefol, "Zone-AzjolNerubC#15098", "Zone-AzjolNerubD#15099", "Zone-AzjolNerubE#15100",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Azjol-Nerub"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Azjol-Nerub"], prefol, "Zone-AzjolNerubA#15096", "Zone-AzjolNerubE#15100", "Zone-AzjolNerubB#15097", "Zone-AzjolNerubD#15099",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Culling of Stratholme"]	, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Culling of Stratholme"], prefol, "Zone-StratholmePastOutdoorsDay#14920", "Zone-StratholmePastOutdoorsNigh#14921",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Drak'Tharon Keep"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Drak'Tharon Keep"], prefol, "Zone-DraktharonRaptorPens#15087",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Forge of Souls"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Forge of Souls"], prefol, "Zone-ForgeOfSoulsWalk#17277", "MUS_70_Artif_DK_IcecrownWalk#77050", "Event-Bronjahm#17280",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Halls of Reflection"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Halls of Reflection"], prefol, "Zone-IcecrownDungeonWalk#17278", "Event-HallsofReflection1#17282", "Event-HallsofReflection2#17283",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Icecrown Citadel"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Icecrown Citadel"], prefol, "Zone-IcecrownRaidFloor2Intro#17291", "Zone-IcecrownRaidFloor2Plague#17294", "Zone-IcecrownRaidFloor2Spire#17296", "Zone-IcecrownRaidFloor2Valithria#17300", "Zone-IcecrownRaidFloor2Frost#17298", "Zone-IcecrownDungeonWalk#17278", "Zone-CrimsonHallWalk#17287", "Zone-ForgeOfSoulsWalk#17277", "Zone-FrostmourneWalk#17286", "Zone-PitofSaron#17310", "Zone-SindragosaWalk#17288",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Naxxramas"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Naxxramas"], prefol, "NaxxramasAbominationWing#8675", "NaxxramasPlagueWing#8678", "NaxxramasSpiderWing#8679", "Zone-NaxxramasAbominationBoss#8888", "Zone-NaxxramasPlagueBoss#8886", "Zone-NaxxramasSpiderBoss#8887", "Zone-NaxxramasKelthuzad#8889", "Zone-NaxxramasFrostWyrm#8890", "Zone - NaxxramsDeathKnight#8687",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Nexus"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Nexus"], prefol, "ColdarraNightDay#12763",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Obsidian Sanctum"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Obsidian Sanctum"], prefol, "Zone-ChamberAspects01Day#15077", "Zone-ChamberAspects01Night#15078",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Onyxia's Lair"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Onyxia's Lair"], prefol, "Moment-Orc Barren#7474",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Pit of Saron"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Pit of Saron"], prefol, "Zone-PitofSaronEntry#17308", "Zone-PitofSaron#17310", "Zone-PitofSaronTyrannus#17314",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Ruby Sanctum"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Ruby Sanctum"], prefol, "RubySanctumWalk#17672",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Ulduar"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Ulduar"], prefol, "UR_UlduarRaidGeneralWalk#15838", "UR_BaseCampWalk#15854", "UR_CelestialHallWalk#15842", "UR_ConservatoryWalk#15843", "UR_CorridorsOfIngenuityWalk#15841", "UR_DescentWalk#15839", "UR_KingLlaneWalk#15835", "UR_PrisonOfYoggSaronWalk#15840", "UR_RazorscalesAerieWalk#15868", "UR_SparkOfImaginationWalk#15847", "UR_TheColossalForgeWalk#15865", "UR_TheScrapyardWalk#15871", "UR_TramHallWalk#15901", "UR_WyrmrestTempleWalk#15837",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Utgarde Keep"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Utgarde Keep"], prefol, "Zone-UtgardeA#15062", "Zone-UtgardeE#15066", "Music_Temp_95#14871",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Utgarde Pinnacle"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Utgarde Pinnacle"], prefol, "Zone-UtgardeA#15062", "Zone-UtgardeD#15065", "Music_Temp_95#14871", "Music_Temp_98#14874",})
			Zn(L["Dungeons"], L["Wrath of the Lich King"], L["Vault of Archavon"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Vault of Archavon"], prefol, "Zone-UldarLightningGeneralWalk#14942",})

			-- Dungeons: Cataclysm
			Zn(L["Dungeons"], L["Cataclysm"], "|cffffd800", {""})
			Zn(L["Dungeons"], L["Cataclysm"], "|cffffd800" .. L["Cataclysm"], {""})
			Zn(L["Dungeons"], L["Cataclysm"], L["Bastion of Twilight"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Bastion of Twilight"], prefol, "MUS_BastionOfTwilight#23167",})
			Zn(L["Dungeons"], L["Cataclysm"], L["Blackrock Caverns"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Blackrock Caverns"], prefol, "MUS_BlackrockCaverns#23170",})
			Zn(L["Dungeons"], L["Cataclysm"], L["Blackwing Descent"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Blackwing Descent"], prefol, "MUS_BlackwingDescent#23171",})
			Zn(L["Dungeons"], L["Cataclysm"], L["Dragon Soul"]							, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Dragon Soul"], prefol, "MUS_43_DragonSoul_DWBackWalk#26618", "MUS_43_DragonSoul_EyeOfEternityWalk#26616", "MUS_43_DragonSoul_MaelstromWalk#26619", "MUS_43_DragonSoul_OldGodWalk#26614", "MUS_43_DragonSoul_SkyfireWalk#26617", "MUS_43_DragonSoul_WyrmrestSummitWalk#26615", "MUS_43_DragonSoul_WyrmrestWalk#26611",})
			Zn(L["Dungeons"], L["Cataclysm"], L["End Time"]								, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["End Time"], prefol, "MUS_43_EndTime_GeneralWalk#26573", "MUS_43_EndTime_EmeraldWalk#26574", "MUS_43_EndTime_MurozondIntro#26571", "Zone-NorthrenRiplashDay#15044", "Zone-NorthrenRiplashNight#15045",})
			Zn(L["Dungeons"], L["Cataclysm"], L["Firelands"]							, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Firelands"], prefol, "MUS_FL_FirelandsA_01#25396", "MUS_FL_FirelandsA_02#25397", "MUS_FL_FirelandsA_03#25398", "MUS_FL_FirelandsA_04#25399", "MUS_FL_FirelandsB_01#25400", "MUS_FL_FirelandsB_02#25401", "MUS_FL_FirelandsB_03#25402", "MUS_FL_FirelandsB_04#25403", "MUS_FL_FirelandsB_05#25404", "MUS_FL_DruidofFlameA_03#25389", "MUS_FL_DruidofFlameA_02#25390", "MUS_FL_DruidofFlameA_01#25391", "MUS_FL_DruidofFlameB_01#25392", "MUS_FL_DruidofFlameB_02#25393", "MUS_FL_DruidofFlameB_03#25394", "MUS_FL_DruidofFlameB_04#25395",})
			Zn(L["Dungeons"], L["Cataclysm"], L["Grim Batol"]							, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Grim Batol"], prefol, "MUS_GrimBatol#22637", "MUS_GrimBatolDungeonAlt#23169",})
			Zn(L["Dungeons"], L["Cataclysm"], L["Halls of Origination"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Halls of Origination"], prefol, "MUS_HallsOfOriginationInt#23174",})
			Zn(L["Dungeons"], L["Cataclysm"], L["Hour of Twilight"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Hour of Twilight"], prefol, "MUS_43_HourOfTwilight_GeneralWalk#26604", "MUS_43_HourOfTwilight_WyrmrestWalk#26610",})
			Zn(L["Dungeons"], L["Cataclysm"], L["Lost City of the Tol'vir"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Lost City of the Tol'vir"], prefol, "MUS_LostCityOfTheTolvir#23173",})
			Zn(L["Dungeons"], L["Cataclysm"], L["Stonecore"]							, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Stonecore"], prefol, "MUS_Stonecore#23166",})
			Zn(L["Dungeons"], L["Cataclysm"], L["Throne of the Four Winds"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Throne of the Four Winds"], prefol, "MUS_Skywall#23175",})
			Zn(L["Dungeons"], L["Cataclysm"], L["Throne of the Tides"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Throne of the Tides"], prefol, "MUS_ThroneOfTheTides#23172",})
			Zn(L["Dungeons"], L["Cataclysm"], L["Well of Eternity"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Well of Eternity"], prefol, "MUS_43_WellOfEternity_AzsharaWalk#26581", "MUS_43_WellOfEternity_IllidanWalk#26582", "MUS_43_WellOfEternity_MannorothWalk#26583",})
			Zn(L["Dungeons"], L["Cataclysm"], L["Zul'Aman"]								, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Zul'Aman"], prefol, "Zone-ZulamanWalkingUni#12133",})
			Zn(L["Dungeons"], L["Cataclysm"], L["Zul'Gurub"]							, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Zul'Gurub"], prefol, "MUS_ZA_altarofthebloodgod#24656", "MUS_ZA_mandokirsdomain#24652", "MUS_ZA_templeofbethekk#24654", "MUS_ZA_thecacheofmadness#24653", "MUS_ZA_thedevilsterrace#24655", "MUS_ZandalariTroll#24681", "Zone-Jungle Day#2525", "Zone-Jungle Night#2535",})

			-- Dungeons: Mists of Pandaria
			Zn(L["Dungeons"], L["Mists of Pandaria"], "|cffffd800", {""})
			Zn(L["Dungeons"], L["Mists of Pandaria"], "|cffffd800" .. L["Mists of Pandaria"], {""})
			Zn(L["Dungeons"], L["Mists of Pandaria"], L["Gate of the Setting Sun"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Gate of the Setting Sun"], prefol, "MUS_50_GSS_Dungeon_GeneralWalk#33602",})
			Zn(L["Dungeons"], L["Mists of Pandaria"], L["Mogu'shan Palace"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Mogu'shan Palace"], prefol, "MUS_50_MSP_Dungeon_BossWalk#33195", "MUS_50_MSP_Dungeon_ShaWalk#33196", "MUS_50_MSP_Dungeon_ShrineWalk#33215",})
			Zn(L["Dungeons"], L["Mists of Pandaria"], L["Mogu'shan Vaults"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Mogu'shan Vaults"], prefol, "MUS_50_MSV_Raid_MoguShanVaults_GeneralWalk#29209",})
			Zn(L["Dungeons"], L["Mists of Pandaria"], L["Shado-Pan Monastery"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Shado-Pan Monastery"], prefol, "MUS_50_SPM_Dungeon_ShadoPan_GeneralWalk#33651",})
			Zn(L["Dungeons"], L["Mists of Pandaria"], L["Siege of Orgrimmar"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Siege of Orgrimmar"], prefol, "MUS_54_SOR_FULLRAID_GeneralWalk#39709", "MUS_54_SOR_Gates_CleftofShadows_Walk#39707", "MUS_54_SOR_Gates_DarkspearOffensive_Walk#39705", "MUS_54_SOR_Gates_Exterior_GeneralWalk#39703", "MUS_54_SOR_InnerSanctum_Garrosh_Sha_Walk#39680", "MUS_54_SOR_InnerSanctum_Garrosh_SWHarbor_Walk#39681", "MUS_54_SOR_OrgrimmarRaid_Walk_FirstHalf_Internal#39652", "MUS_54_SOR_OrgrimmarRaid_Walk_FirstHalf_External#39648", "MUS_54_SOR_OrgrimmarRaid_Walk_SecondHalf_Internal#39647", "MUS_54_SOR_OrgrimmarRaid_Walk_SecondHalf_External#39649", "MUS_54_SOR_Underhold_General_Walk#39711", "MUS_54_SOR_Underhold_Menagerie_Walk#39712", "MUS_54_SOR_Underhold_Arsenal_Walk#39713", "MUS_54_SOR_Underhold_Siegeworks_Walk#39714", "MUS_54_SOR_Vale_Immerseus_Walk#39691", "MUS_54_SOR_Vale_ScarredVale_Walk#39693", "MUS_54_SOR_Vale_NorushenRoom_Walk#39695",})
			Zn(L["Dungeons"], L["Mists of Pandaria"], L["Siege of Niuzao Temple"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Siege of Niuzao Temple"], prefol, "MUS_50_SoN_Dungeon_HallowedOutTreeWalk#33612", "MUS_50_SoN_Dungeon_NiuzaoExteriorWalk#33614",})
			Zn(L["Dungeons"], L["Mists of Pandaria"], L["Stormstout Brewery"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Stormstout Brewery"], prefol, "MUS_50_SSB_Dungeon_StormstoutBrewhall_INTRO#33756", "MUS_50_SSB_Dungeon_StormstoutBrewhall_Walk#33757",})
			Zn(L["Dungeons"], L["Mists of Pandaria"], L["Temple of the Jade Serpent"]	, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Temple of the Jade Serpent"], prefol, "MUS_50_TJS_Dungeon_FountainoftheEverseeing_Walk#31987", "MUS_50_TJS_Dungeon_ShaofDoubt_Battle#31990", "MUS_50_TJS_Dungeon_ScrollkeepersSanctum_Battle#31991", "MUS_50_TJS_Dungeon_TempleoftheJadeSerpent_GeneralWalk#31992",})
			Zn(L["Dungeons"], L["Mists of Pandaria"], L["Terrace of Endless Spring"]	, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Terrace of Endless Spring"], prefol, "MUS_50_TES_Raid_TerraceofEndlessSpring_GeneralWalk#33625",})
			Zn(L["Dungeons"], L["Mists of Pandaria"], L["Throne of Thunder"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Throne of Thunder"], prefol, "MUS_52_TKRaid_ThroneOfThunder_Main#36702", "MUS_52_TKRaid_Wing3_FleshShaping_Walk#36920", "MUS_52_TKRaid_Wing1_Troll_Walk#36921", "MUS_52_TKRaid_Wing2_Creatures_Walk#36922", "MUS_52_TKRaid_Wing4_Palace_Walk#36923", "MUS_52_TKRaid_Wing1_Troll_Battle#37010",})

			-- Dungeons: Warlords of Draenor
			Zn(L["Dungeons"], L["Warlords of Draenor"], "|cffffd800", {""})
			Zn(L["Dungeons"], L["Warlords of Draenor"], "|cffffd800" .. L["Warlords of Draenor"], {""})
			Zn(L["Dungeons"], L["Warlords of Draenor"], L["Blackrock Foundry"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Blackrock Foundry"], prefol, "MUS_60_Dungeon_BlackRock_Foundry_General#49225",})
			Zn(L["Dungeons"], L["Warlords of Draenor"], L["Bloodmaul Slag Mines"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Bloodmaul Slag Mines"], prefol, "MUS_60_FFR_Ogre_Walk#49192", "MUS_60_FFR_Ogre_Battle#49195",})
			Zn(L["Dungeons"], L["Warlords of Draenor"], L["Everbloom"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Everbloom"], prefol, "MUS_60_Dungeon_Everbloom_Stormwind#49219", "MUS_60_Dungeon_Everbloom_PoolsofLife#49220", "MUS_60_Dungeon_Everbloom_Verdant_Grove#49221", "MUS_60_Dungeon_Everbloom_Xeritacs_Burrow#49222", "MUS_60_Dungeon_Everbloom_VioletBluff#49223",})
			Zn(L["Dungeons"], L["Warlords of Draenor"], L["Hellfire Citadel"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Hellfire Citadel"], prefol, "MUS_62_Tanaan_HFC_IronHorde_Cathedral_Walk#51515", "MUS_62_Tanaan_HFC_IronHorde_Fel_Walk#51519", "MUS_62_Tanaan_HFC_Boss_Battle#51573", "MUS_62_Tanaan_HFC_Kilrogg_Batlle#51574", "MUS_62_Tanaan_HFC_Fel_Walk#51520", "MUS_62_Tanaan_HFC_Archimonde_Battle#51525", "MUS_62_Tanaan_HFC_Eredar_Walk#51521", "MUS_62_Tanaan_HFC_Iskar_Battle#51522", "MUS_62_Tanaan_HFC_Grommash_Battle#51523", "MUS_62_Tanaan_HFC_Archimonde_TwistingNether_Walk#51526",})
			Zn(L["Dungeons"], L["Warlords of Draenor"], L["Highmaul"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Highmaul"], prefol, "MUS_60_Dungeon_Highmaul_General#49276", "MUS_60_Dungeon_Highmaul_ImperatorsRise#49351", "MUS_60_Dungeon_Highmaul_PathOfVictors#49345", "MUS_60_Dungeon_Highmaul_TheUnderbelly#49282",})
			Zn(L["Dungeons"], L["Warlords of Draenor"], L["Iron Docks"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Iron Docks"], prefol, "MUS_60_Dungeon_IronDocks_Walk#49187", "MUS_60_Dungeon_IronDocks_BlackhandsMight#49188",})
			Zn(L["Dungeons"], L["Warlords of Draenor"], L["Shadowmoon Burial Grounds"]	, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Shadowmoon Burial Grounds"], prefol, "MUS_60_Dungeon_SMBurialGrounds_Walk#49206", "MUS_60_Dungeon_SMBurialGrounds_CryptsoftheAncients#49208", "MUS_60_Dungeon_SMBurialGrounds_PoolsofReflection#49209", "MUS_60_Dungeon_SMBurialGrounds_AltarofShadow#49210",})
			Zn(L["Dungeons"], L["Warlords of Draenor"], L["Skyreach"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Skyreach"], prefol, "MUS_60_Dungeon_Skyreach_General_A#49129",})

			-- Dungeons: Legion
			Zn(L["Dungeons"], L["Legion"], "|cffffd800", {""})
			Zn(L["Dungeons"], L["Legion"], "|cffffd800" .. L["Legion"], {""})
			Zn(L["Dungeons"], L["Legion"], L["Antorus, the Burning Throne"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Antorus, the Burning Throne"], prefol, "MUS_73_RAID_AntorusGeneralWalk#90609", "MUS_73_RAID_AntorusBattleWalk#90610", "MUS_73_RAID_AntorusElunariaWalk#90611", "MUS_73_RAID_BurningThroneWalk#90612",})
			Zn(L["Dungeons"], L["Legion"], L["Arcway"]									, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Arcway"], prefol, "MUS_60_FFR_Ogre_Walk#49192",})
			Zn(L["Dungeons"], L["Legion"], L["Black Rook Hold"]							, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Black Rook Hold"], prefol, "MUS_70_BlackRookHold_WalkA#76004", "MUS_70_BlackRookHold_WalkB#76007", "MUS_70_BlackRookHold_WalkC#76009",})
			Zn(L["Dungeons"], L["Legion"], L["Cathedral of Eternal Night"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Cathedral of Eternal Night"], prefol, "MUS_72_ToS_Dungeon_GeneralWalk#85030", "MUS_72_ToS_Dungeon_GardenWalk#85032", "MUS_72_ToS_Dungeon_ChapelWalk#85031", "MUS_72_ToS_Dungeon_LegionWalk#85033", "MUS_72_ToS_Dungeon_LibraryWalk#85169",})
			Zn(L["Dungeons"], L["Legion"], L["Court of Stars"]							, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Court of Stars"], prefol, "MUS_70_DGN_SuramarCityDungeon_Walk01#76837", "MUS_70_DGN_SuramarCityDungeon_Walk02#76838",})
			Zn(L["Dungeons"], L["Legion"], L["Darkheart Thicket"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Darkheart Thicket"], prefol, "MUS_70_Nightmare_Orchestral#73385", "MUS_70_Nightmare_Solo#73392", "MUS_70_Nightmare_Synth#73386",})
			Zn(L["Dungeons"], L["Legion"], L["Emerald Nightmare"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Emerald Nightmare"], prefol, "MUS_70_Nightmare_Orchestral#73385", "MUS_70_Nightmare_Solo#73392", "MUS_70_Nightmare_Synth#73386", "MUS_70_Nightmare_TheEmeraldDream_Walk#76859",})
			Zn(L["Dungeons"], L["Legion"], L["Eye of Azshara"]							, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Eye of Azshara"], prefol, "MUS_70_EyeofAzshara_Walk_A#75040", "MUS_70_EyeofAzshara_Walk_B#74971", "MUS_70_EyeofAzshara_Walk_C#74973", "MUS_70_EyeofAzshara_Walk_D#74983",})
			Zn(L["Dungeons"], L["Legion"], L["Halls of Valor"]							, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Halls of Valor"], prefol, "MUS_70_HallsofValor_WalkA#75676", "MUS_70_HallsofValor_WalkB#75678", "MUS_70_HallsofValor_WalkC#75679",})
			Zn(L["Dungeons"], L["Legion"], L["Maw of Souls"]							, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Maw of Souls"], prefol, "MUS_70_MawofSouls_WalkA#75548", "MUS_70_MawofSouls_WalkB#75549", "MUS_70_MawofSouls_WalkC#75551",})
			Zn(L["Dungeons"], L["Legion"], L["Neltharion's Lair"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Neltharion's Lair"], prefol, "MUS_70_NetharionsLair_WalkA#75947", "MUS_70_NetharionsLair_WalkB#75949", "MUS_70_NetharionsLair_WalkC#75953", "MUS_70_NetharionsLair_WalkD#75954",})
			Zn(L["Dungeons"], L["Legion"], L["Nighthold"]								, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Nighthold"], prefol, "MUS_62_Tanaan_HFC_Archimonde_Battle#51525", "MUS_71_TheNightholdIndoorWalk#79673", "MUS_71_TheNightholdOutdoorWalk#79674", "MUS_71_TheNightholdBattleHeavy#79675", "MUS_71_TheNightholdLegionFel#79676",})
			Zn(L["Dungeons"], L["Legion"], L["Return to Karazhan"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Return to Karazhan"], prefol, "MUS_71_KarazhanGeneralDefault#79499",})
			Zn(L["Dungeons"], L["Legion"], L["Seat of the Triumvirate"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Seat of the Triumvirate"], prefol, "MUS_73_TheSeatoftheTriumvirate_VoidFullWalk#90572", "MUS_73_TheSeatoftheTriumvirate_VoidMediumWalk#90573",})
			Zn(L["Dungeons"], L["Legion"], L["Tomb of Sargeras"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Tomb of Sargeras"], prefol, "MUS_72_ToS_Raid_GeneralWalk#85171", "MUS_72_ToS_Raid_LegionWalk#85887", "MUS_72_ToS_Raid_TitanWalk#85888", "MUS_72_ToS_Raid_NightElfWalk#85889", "MUS_72_ToS_Raid_Naga_GeneralWalk#86406", "MUS_72_ToS_Raid_Naga_BossWalk#86407",})
			Zn(L["Dungeons"], L["Legion"], L["Trial of Valor"]							, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Trial of Valor"], prefol, "MUS_70_HallsofValor_WalkA#75676", "MUS_70_HallsofValor_WalkB#75678", "MUS_70_HallsofValor_WalkC#75679", "MUS_70_Zone_Stormheim_Mystic_Walk#76491", "MUS_71_TrialOfValor-DarkCoast-Walk#79719",})
			Zn(L["Dungeons"], L["Legion"], L["Vault of the Wardens"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Vault of the Wardens"], prefol, "MUS_70_VOTW_Walk_A#74778",})

			-- Dungeons: Battle for Azeroth
			Zn(L["Dungeons"], L["Battle for Azeroth"], "|cffffd800", {""})
			Zn(L["Dungeons"], L["Battle for Azeroth"], "|cffffd800" .. L["Battle for Azeroth"], {""})
			Zn(L["Dungeons"], L["Battle for Azeroth"], L["Atal'Dazar"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Atal'Dazar"], prefol, "MUS_80_DGN_CityofGold#93663",})
			Zn(L["Dungeons"], L["Battle for Azeroth"], L["Battle of Dazar'alor"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Battle of Dazar'alor"], prefol, "MUS_81_RAID_Zuldazar_Alliance_BloodMoon#126421", "MUS_81_RAID_Zuldazar_Alliance_Port#126352", "MUS_81_RAID_Zuldazar_Horde_Walk#125915", "MUS_81_RAID_Zuldazar_Horde_Port#126348", "MUS_81_RAID_Zuldazar_Pyramid#126329", "MUS_81_RAID_Zuldazar_Boss_Jaina02#126356",})
			Zn(L["Dungeons"], L["Battle for Azeroth"], L["Crucible of Storms"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Crucible of Storms"], prefol, "MUS_80_DGN_ShrineOfStorms_Shadows#116123",})
			Zn(L["Dungeons"], L["Battle for Azeroth"], L["Freehold"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Freehold"], prefol, "MUS_70_Nightmare_Solo#73392", "MUS_80_DGN_Freehold_Outskirts#93660",})
			Zn(L["Dungeons"], L["Battle for Azeroth"], L["King's Rest"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["King's Rest"], prefol, "MUS_80_DGN_King'sRest#117218",})
			Zn(L["Dungeons"], L["Battle for Azeroth"], L["Motherlode"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Motherlode"], prefol, "MUS_80_DGN_TheMotherlode_General_Walk#117425", "MUS_80_DGN_TheMotherlode_BombArea_Walk#117427",})
			Zn(L["Dungeons"], L["Battle for Azeroth"], L["Shrine of the Storm"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Shrine of the Storm"], prefol, "MUS_80_DGN_ShrineOfStorms_Walk#116118", "MUS_80_DGN_ShrineOfStorms_Shadows#116123",})
			Zn(L["Dungeons"], L["Battle for Azeroth"], L["Siege of Boralus"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Siege of Boralus"], prefol, "MUS_80_DGN_SiegeOfBoralus_Walk#116219", "MUS_80_DGN_SiegeOfBoralus_Kraken#116225",})
			Zn(L["Dungeons"], L["Battle for Azeroth"], L["Temple of Sethraliss"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Temple of Sethraliss"], prefol, "MUS_80_DGN_TempleofSethraliss#117251",})
			Zn(L["Dungeons"], L["Battle for Azeroth"], L["Tol Dagor"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Tol Dagor"], prefol, "MUS_80_DGN_TolDagor_Outside#116230", "MUS_80_DGN_TolDagor_Armory#117224",})
			Zn(L["Dungeons"], L["Battle for Azeroth"], L["Uldir"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Uldir"], prefol, "MUS_80_RAID_Uldir_Blood#117988", "MUS_80_RAID_Uldir_Corruption#117670", "MUS_80_RAID_Uldir_G'huun_Intro#118031", "MUS_80_RAID_Uldir_Taloc_Intro#118029", "MUS_80_RAID_Uldir_Zul_Intro#118030",})
			Zn(L["Dungeons"], L["Battle for Azeroth"], L["Underrot"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Underrot"], prefol, "MUS_80_DGN_TheUnderrot#117262",})
			Zn(L["Dungeons"], L["Battle for Azeroth"], L["Waycrest Manor"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Waycrest Manor"], prefol, "MUS_80_DGN_WaycrestManor_Outdoors#117086",})

			-- Various
			Zn(L["Various"], L["Various"], "|cffffd800" .. L["Various"], {""})
			Zn(L["Various"], L["Various"], L["Allied Races"], {	"|cffffd800" .. L["Various"] .. ": " .. L["Allied Races"], prefol, 
				"|cffffd800", "|cffffd800" .. L["Dark Iron Dwarves"], "MUS_80_AlliedRace_DarkIronDwarf_Intro#117230", "MUS_80_AlliedRace_DarkIronDwarf_Intro02#117258", "MUS_80_AlliedRace_DarkIronDwarf_Intro03#117261", "MUS_80_AlliedRace_DarkIronDwarf01_Start#117245", "MUS_80_AlliedRace_DarkIronDwarf02_Start#117246", "MUS_80_AlliedRace_DarkIronDwarf_Scenario_SFC#117250", "MUS_80_AlliedRace_DarkIronDwarf_Scenario_Firelands#117260",
				"|cffffd800", "|cffffd800" .. L["Highmountain Tauren"], "MUS_735_AR_RTC_HighmountainTauren_Flythrough#98204",
				"|cffffd800", "|cffffd800" .. L["Lightforged Draenei"], "MUS_735_AR_RTC_LightforgedDraenei_Flythrough#98201", "MUS_735_AlliedRace_LightforgedDraenei_Vindicaar_01#97314", "MUS_735_AlliedRace_LightforgedDraenei_ForgeofAeons#97316", "MUS_735_AR_RTC_LightforgedDraenei_PreScenario_01#98199", "MUS_735_AR_RTC_LightforgedDraenei_PreScenario_02#98200",
				"|cffffd800", "|cffffd800" .. L["Mag'har Orcs"], "MUS_80_AlliedRace_Mag'harOrc_Intro#117279", "MUS_80_AlliedRace_Mag'harOrc02_Intro#117436", "MUS_80_AlliedRace_Mag'harOrc01#117280", "MUS_80_AlliedRace_Mag'harOrc02#117281", "MUS_80_AlliedRace_Mag'harOrc_Light#117286", "MUS_80_AlliedRace_Mag'harOrc_Light_Intro#117441",
				"|cffffd800", "|cffffd800" .. L["Nightborne"], "MUS_735_AR_RTC_Nightborne_Flythrough#98205", "MUS_735_AR_RTC_Nightborne_Silvermoon_01#98214", "MUS_735_AR_RTC_Nightborne_Silvermoon_03#98215", "MUS_735_AR_RTC_Nightborne_ThalyssraEstate_01#98195", "MUS_735_AR_RTC_Nightborne_ThalyssraEstate_02#98196", "MUS_735_AR_RTC_Nightborne_ThalyssraEstate_03#98197",
				"|cffffd800", "|cffffd800" .. L["Void Elves"], "MUS_735_AR_RTC_VoidElf_Flythrough#98206", "MUS_735_AlliedRace_VoidElf_01#97311", "MUS_735_AlliedRace_VoidElf_02#97312", "MUS_735_AlliedRace_VoidElf_Scenario_01#97782", "MUS_735_AlliedRace_VoidElf_Scenario_02#97783", "MUS_735_AlliedRace_VoidElf_Scenario_03#97784", "MUS_735_AR_ThunderBluff_VoidAttack#97785",
				"|cffffd800", "|cffffd800" .. L["Embassies"], "MUS_735_AlliedRace_EmbassyAlliance_01#97594", "MUS_735_AlliedRace_EmbassyHorde_01#97593",
			})
			Zn(L["Various"], L["Various"], L["Arenas"]									, {	"|cffffd800" .. L["Various"] .. ": " .. L["Arenas"], prefol, "Intro-NagrandDimond#10623", "MUS_50_Scenario_ArenaofAnnihilation#34019", "MUS_51_PVP_BrawlersGuild_Horde#34967", --[["MUS_80_PVP_ZandalarArena#117041", "MUS_80_PVP_KulTirasArena#114680",--]] "PVP-Battle Grounds#8233", "Zone-BladesEdge#9002",})
			Zn(L["Various"], L["Various"], L["Battlegrounds"]							, {	"|cffffd800" .. L["Various"] .. ": " .. L["Battlegrounds"], prefol, "Altervac Valley_PVP#8014", "MUS_50_Scenario_TempleofKotmogu#33978", "MUS_BattleForGilneas_BG#23612", "MUS_TwinPeaks_BG#23613", "PVP-Battle Grounds#8233", "PVP-Battle Grounds--DeepwindGorge#37659", "PVP-Battle Grounds-Pandaria#33714", "PVP-Battle Grounds-SilvershardMines#33713", "PVPVictoryAlliance#8455", "PVPVictoryHorde#8454", "Zone-WintergraspContested#14912",})
			Zn(L["Various"], L["Various"], L["Class Trials"]							, {	"|cffffd800" .. L["Various"] .. ": " .. L["Class Trials"], prefol, "MUS_70_ClassTrial_Horde_BattleWalk#71954", "MUS_70_ClassTrial_Alliance_BattleWalk#71959",})
			Zn(L["Various"], L["Various"], L["Credits"]									, {	"|cffffd800" .. L["Various"] .. ": " .. L["Credits"], prefol, "Menu-Credits01#10763", "Menu-Credits02#10804", "Menu-Credits03#13822", "Menu-Credits04#23812", "Menu-Credits05#32015", "Menu-Credits06#34020", "Menu-Credits07#56354", "Menu-Credits08#113560"})
			Zn(L["Various"], L["Various"], L["Events"]									, {	"|cffffd800" .. L["Various"] .. ": " .. L["Events"], prefol, 
				"|cffffd800", "|cffffd800" .. L["Darkmoon Faire"], "MUS_43_DarkmoonFaire_IslandWalk#26536", "MUS_43_DarkmoonFaire_PavillionWalk#26539", "MUS_51_DarkmoonFaire_MerryGoRound_01#34440",
				"|cffffd800", "|cffffd800" .. L["Plants vs Zombies"], "EVENT_PvZ_Babbling#23487", "EVENT_PvZ_Dadadoo#23488", "EVENT_PvZ_Doobeedoo#23489", "EVENT_PvZ_Lalala#23490", "EVENT_PvZ_Sunflower#23491", "EVENT_PvZ_Zombieonyourlawn#23492",
			})
			Zn(L["Various"], L["Various"], L["Island Expeditions"]						, {	"|cffffd800" .. L["Various"] .. ": " .. L["Island Expeditions"], prefol,
				"|cffffd800", "|cffffd800" .. L["Adventure"], "MUS_80_Islands_Adventure_Walk#115050", "MUS_80_Islands_Adventure_Invasion_Walk#115414", "MUS_80_Islands_Adventure_Victory#115053",
				"|cffffd800", "|cffffd800" .. L["Mystical"], "MUS_80_Islands_Mystical_Walk#115689", "MUS_80_Islands_Mystical_Invasion_Walk#117352",
				"|cffffd800", "|cffffd800" .. L["Winter"], "MUS_80_Islands_Winter_Walk#117377", "MUS_80_Islands_Winter_Invasion_Walk#117378",
				"|cffffd800", "|cffffd800" .. L["Havenswood"], "MUS_81_Islands_Havenswood_Walk#125908", 
				"|cffffd800", "|cffffd800" .. L["Jorundall"], "MUS_81_Islands_Jorundall_Walk#126149",
			})
			Zn(L["Various"], L["Various"], L["Main Titles"]								, {	"|cffffd800" .. L["Various"] .. ": " .. L["Main Titles"], prefol, "GS_Retail#10924", "GS_BurningCrusade#10925", "GS_LichKing#12765", "GS_Cataclysm#23640", "MUS_50_HeartofPandaria_MainTitle#28509", "MUS_60_MainTitle#40169", "MUS_70_MainTitle#56353", "MUS_80_MainTitle#113559"}) -- "MUS_1.0_MainTitle_Original#47598"
			Zn(L["Various"], L["Various"], L["Music Rolls"]								, {	"|cffffd800" .. L["Various"] .. ": " .. L["Music Rolls"], prefol, "MUS_61_GarrisonMusicBox_01#49511", "MUS_61_GarrisonMusicBox_02#49512", "MUS_61_GarrisonMusicBox_03#49513", "MUS_61_GarrisonMusicBox_04#49514", "MUS_61_GarrisonMusicBox_05#49515", "MUS_61_GarrisonMusicBox_06#49516", "MUS_61_GarrisonMusicBox_07#49529", "MUS_61_GarrisonMusicBox_08#49530", "MUS_61_GarrisonMusicBox_09#49531", "MUS_61_GarrisonMusicBox_10#49533", "MUS_61_GarrisonMusicBox_11#49535", "MUS_61_GarrisonMusicBox_12#49536", "MUS_61_GarrisonMusicBox_13#49538", "MUS_61_GarrisonMusicBox_14#49539", "MUS_61_GarrisonMusicBox_15#49540", "MUS_61_GarrisonMusicBox_16#49541", "MUS_61_GarrisonMusicBox_17#49543", "MUS_61_GarrisonMusicBox_18#49544", "MUS_61_GarrisonMusicBox_19#49545", "MUS_61_GarrisonMusicBox_20#49546", "MUS_61_GarrisonMusicBox_21#49526", "MUS_61_GarrisonMusicBox_22#49528", "MUS_61_GarrisonMusicBox_23_Alliance#49517", "MUS_61_GarrisonMusicBox_24_Alliance#49518", "MUS_61_GarrisonMusicBox_25_Alliance#49519", "MUS_61_GarrisonMusicBox_26_Alliance#49520", "MUS_61_GarrisonMusicBox_27_Alliance#49521", "MUS_61_GarrisonMusicBox_28_Alliance#49522", "MUS_61_GarrisonMusicBox_29_Alliance#49523", "MUS_61_GarrisonMusicBox_30_Alliance#49524", "MUS_61_GarrisonMusicBox_31_Alliance#49525", "MUS_61_GarrisonMusicBox_23_Horde#49555", "MUS_61_GarrisonMusicBox_24_Horde#49554", "MUS_61_GarrisonMusicBox_25_Horde#49553", "MUS_61_GarrisonMusicBox_26_Horde#49552", "MUS_61_GarrisonMusicBox_27_Horde#49551", "MUS_61_GarrisonMusicBox_28_Horde#49550", "MUS_61_GarrisonMusicBox_29_Horde#49549", "MUS_61_GarrisonMusicBox_30_Horde#49548", "MUS_61_GarrisonMusicBox_31_Horde#49547",})
			Zn(L["Various"], L["Various"], L["Pet Battles"]								, {	"|cffffd800" .. L["Various"] .. ": " .. L["Pet Battles"], prefol, "MUS_50_PetBattles_01#28753", "MUS_50_PetBattles_02#28754",})
			Zn(L["Various"], L["Various"], L["Themes"]									, {	"|cffffd800" .. L["Various"] .. ": " .. L["Themes"], prefol,
				"|cffffd800", "|cffffd800" .. L["Anduin's Theme"], "MUS_70_Zone_Stormwind_PostBrokenShore_Funeral_01#75552", "MUS_70_Zone_Stormwind_LionsRest_Day#73345", "MUS_70_BrokenShore_ShipIntro#73387", "MUS_72_BrokenShore_Wyrnnfall_Intro#85166", 
				"|cffffd800", "|cffffd800" .. L["Jaina's Theme"], "MUS_60_Proudmoore_01#49356", "MUS_60_Proudmoore_02#49357", "MUS_60_Proudmoore_03#49358", 
				"|cffffd800", "|cffffd800" .. L["Tea with Jaina"], "ClientScene_51_TeaWithJaina_Music_01#34891", 
				"|cffffd800", "|cffffd800" .. L["Power of the Horde"], "_MUS_61_GarrisonMusicBox_24_NotUsed#49534",
				"|cffffd800", "|cffffd800" .. L["Diablo Anniversary"], "MUS_71_Event_DiabloAnniversary_TristramGuitar (Everything)#78803",
			})
			Zn(L["Various"], L["Various"], L["Warfronts"]								, {	"|cffffd800" .. L["Various"] .. ": " .. L["Warfronts"], prefol,
				"|cffffd800", "|cffffd800" .. L["Battle for Darkshore"], "MUS_81_Warfronts_Darkshore_Alliance_General_Walk#125670", "MUS_81_Warfronts_Darkshore_Alliance_FinalAssault#125671", "MUS_81_Warfronts_Darkshore_Horde_General_Walk#125883", "MUS_81_Warfronts_Darkshore_Horde_FinalAssault#125884", 
				"|cffffd800", "|cffffd800" .. L["Battle for Stromgarde"], "MUS_80_Warfronts_Arathi_Alliance_General_Walk#116361", "MUS_80_Warfront_Arathi_Horde_General_Walk#85251", "MUS_80_ArathiHighlands_PostWarfronts#120246",
			})

			-- Movies
			Zn(L["Movies"], L["Movies"], "|cffffd800" .. L["Movies"], {""})
			Zn(L["Movies"], L["Movies"], L["World of Warcraft"]							, {	"|cffffd800" .. L["Movies"] .. ": " .. L["World of Warcraft"], prefol, L["Ten Years of Warcraft"] .. " |r(1)", L["World of Warcraft"] .. " |r(2)"})
			Zn(L["Movies"], L["Movies"], L["The Burning Crusade"]						, {	"|cffffd800" .. L["Movies"] .. ": " .. L["The Burning Crusade"], prefol, L["The Burning Crusade"] .. " |r(27)"})
			Zn(L["Movies"], L["Movies"], L["Wrath of the Lich King"]					, {	"|cffffd800" .. L["Movies"] .. ": " .. L["Wrath of the Lich King"], prefol, L["Wrath of the Lich King"] .. " |r(18)", L["Battle of Angrathar the Wrathgate"] .. " |r(14)", L["Fall of the Lich King"] .. " |r(16)"})
			Zn(L["Movies"], L["Movies"], L["Cataclysm"]									, {	"|cffffd800" .. L["Movies"] .. ": " .. L["Cataclysm"], prefol, L["Cataclysm"] .. " |r(23)", L["Last Stand"] .. " |r(21)", L["Leaving Kezan"] .. " |r(22)", L["The Dragon Soul"] .. " |r(73)", L["Spine of Deathwing"] .. " |r(74)", L["Madness of Deathwing"] .. " |r(75)", L["Fall of Deathwing"] .. " |r(76)"})
			Zn(L["Movies"], L["Movies"], L["Mists of Pandaria"]							, {	"|cffffd800" .. L["Movies"] .. ": " .. L["Mists of Pandaria"], prefol, L["Mists of Pandaria"] .. " |r(115)", L["Risking It All"] .. " |r(117)", L["Leaving the Wandering Isle"] .. " |r(116)", L["The King's Command"] .. " |r(119)", L["The Art of War"] .. " |r(120)", L["Battle of Serpent's Heart"] .. " |r(118)", L["The Fleet in Krasarang (Horde)"] .. " |r(128)", L["The Fleet in Krasarang (Alliance)"] .. " |r(127)", L["Hellscream's Downfall (Horde)"] .. " |r(151)", L["Hellscream's Downfall (Alliance)"] .. " |r(152)"})
			Zn(L["Movies"], L["Movies"], L["Warlords of Draenor"]						, {	"|cffffd800" .. L["Movies"] .. ": " .. L["Warlords of Draenor"], prefol, L["Warlords of Draenor"] .. " |r(195)", L["Darkness Falls"] .. " |r(167)", L["The Battle of Thunder Pass"] .. " |r(168)", L["And Justice for Thrall"] .. " |r(177)", L["Into the Portal"] .. " |r(185)", L["A Taste of Iron"] .. " |r(187)", L["The Battle for Shattrath"] .. " |r(188)", L["Establish Your Garrison (Horde)"] .. " |r(189)", L["Establish Your Garrison (Alliance)"] .. " |r(192)", L["Bigger is Better (Horde)"] .. " |r(190)", L["Bigger is Better (Alliance)"] .. " |r(193)", L["My Very Own Castle (Horde)"] .. " |r(191)", L["My Very Own Castle (Alliance)"] .. " |r(194)", L["Gul'dan Ascendant"] .. " |r(270)", L["Shipyard Construction (Horde)"] .. " |r(292)", L["Shipyard Construction (Alliance)"] .. " |r(293)", L["Gul'dan's Plan"] .. "  |r(294)", L["Victory in Draenor!"] .. "  |r(295)"})
			Zn(L["Movies"], L["Movies"], L["Legion"]									, {	"|cffffd800" .. L["Movies"] .. ": " .. L["Legion"], prefol, L["Legion"] .. " |r(470)", L["The Invasion Begins"] .. " |r(469)", L["Return to the Black Temple"] .. " |r(471)", L["The Demon's Trail"] .. " |r(473)", L["The Fate of Val'sharah"] .. " |r(472)", L["Fate of the Horde"] .. " |r(474)", L["A New Life for Undeath"] .. " |r(475)", L["Harbingers Gul'dan"] .. " |r(476)", L["Harbingers Khadgar"] .. " |r(477)", L["Harbingers Illidan"] .. " |r(478)", L["The Nightborne Pact"] .. " |r(485)", L["The Battle for Broken Shore"] .. " |r(487)", L["A Falling Star"] .. " |r(489)", L["Destiny Unfulfilled"] .. " |r(490)", L["Victory at The Nighthold"] .. " |r(635)", L["A Found Memento"] .. " |r(636)", L["Kil'jaeden's Downfall"] .. " |r(656)", L["Arrival on Argus"] .. " |r(677)", L["Rejection of the Gift"] .. " |r(679)", L["Reincarnation of Alleria Windrunner"] .. " |r(682)", L["Rise of Argus"] .. " |r(687)", L["Antorus Ending"] .. " |r(689)", L["Epilogue (Horde)"] .. " |r(717)", L["Epilogue (Alliance)"] .. " |r(716)"})
			Zn(L["Movies"], L["Movies"], L["Battle for Azeroth"]						, {	"|cffffd800" .. L["Movies"] .. ": " .. L["Battle for Azeroth"], prefol, L["Battle for Azeroth"] .. " |r(852)", L["Warbringers Sylvanas"] .. " |r(853)", L["Battle for Lordaeron (Horde)"] .. " |r(855)", L["Battle for Lordaeron (Alliance)"] .. " |r(856)", L["Embers of War"] .. " |r(854)", L["Zandalar Intro"] .. " |r(857)", L["Zandalar Battle"] .. " |r(858)", L["Jaina Returns to Kul Tiras"] .. " |r(859)", L["Jaina's Nightmare"] .. " |r(860)",L["Terror of Darkshore"] .. " |r(874)",})

			-- Give zone table a file level scope so slash command function can access it
			LeaPlusLC["ZoneList"] = ZoneList

			-- Show relevant list items
			local function UpdateList()
				FauxScrollFrame_Update(scrollFrame, #ListData, numButtons, 16)
				for index = 1, numButtons do
					local offset = index + FauxScrollFrame_GetOffset(scrollFrame)
					local button = scrollFrame.buttons[index]
					button.index = offset
					if offset <= #ListData then
						-- Show zone listing or track listing
						button:SetText(ListData[offset].zone or ListData[offset])
						-- Set width of highlight texture
						if button:GetTextWidth() > 290 then
							button.t:SetSize(290, 16)
						else
							button.t:SetSize(button:GetTextWidth(), 16)
						end
						-- Show the button
						button:Show()
						-- Hide highlight bar texture by default
						button.s:Hide()
						-- Hide highlight bar if the button is a heading
						if strfind(button:GetText(), "|c") then button.t:Hide() end
						-- Show last played track highlight bar texture 
						if LastPlayed == button:GetText() then
							local HeadingOfCurrentFolder = ListData[1]
							if HeadingOfCurrentFolder == HeadingOfClickedTrack then
								button.s:Show()
							end
						end
						-- Show last played folder highlight bar texture
						if LastFolder == button:GetText() then
							button.s:Show()
						end
						-- Set width of highlight bar
						if button:GetTextWidth() > 290 then
							button.s:SetSize(290, 16)
						else
							button.s:SetSize(button:GetTextWidth(), 16)
						end
						-- Limit click to label width
						local bWidth = button:GetFontString():GetStringWidth() or 0
						if bWidth > 290 then bWidth = 290 end
						button:SetHitRectInsets(0, 454 - bWidth, 0, 0)
						-- Disable label click movement
						button:SetPushedTextOffset(0, 0)
						-- Disable word wrap and set width
						button:GetFontString():SetWidth(290)
						button:GetFontString():SetWordWrap(false)
					else
						button:Hide()
					end
				end
			end

			-- Give function file level scope (it's used in SetPlusScale to set the highlight bar scale)
			LeaPlusLC.UpdateList = UpdateList

			-- Right-button click to go back
			local function BackClick()
				-- Return to the current zone list (back button)
				if type(ListData[1]) == "string" then
					-- Strip the color code from the list data
					local nocol = string.gsub(ListData[1], "|cffffd800", "")
					-- Strip the zone
					local backzone = strsplit(":", nocol, 2)
					-- Don't go back if random or search category is being shown
					if backzone == L["Random"] or backzone == L["Search"] then return end
					-- Show the tracklist continent 
					if ZoneList[backzone] then ListData = ZoneList[backzone] end
					UpdateList()
					scrollFrame:SetVerticalScroll(ZonePage or 0)
				end
			end

			-- Function to make navigation menu buttons
			local function MakeButton(where, y)
				local mbtn = CreateFrame("Button", nil, LeaPlusLC["Page9"])
				mbtn:Show()
				mbtn:SetAlpha(1.0)
				mbtn:SetPoint("TOPLEFT", 146, y)

				-- Create hover texture
				mbtn.t = mbtn:CreateTexture(nil, "BACKGROUND")
				mbtn.t:SetColorTexture(0.3, 0.3, 0.00, 0.8)
				mbtn.t:SetAlpha(0.7)
				mbtn.t:SetAllPoints()
				mbtn.t:Hide()

				-- Create highlight texture
				mbtn.s = mbtn:CreateTexture(nil, "BACKGROUND")
				mbtn.s:SetColorTexture(0.3, 0.3, 0.00, 0.8)
				mbtn.s:SetAlpha(1.0)
				mbtn.s:SetAllPoints()
				mbtn.s:Hide()

				-- Create fontstring
				mbtn.f = mbtn:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
				mbtn.f:SetPoint('LEFT', 1, 0)
				mbtn.f:SetText(L[where])

				mbtn:SetScript("OnEnter", function()
					mbtn.t:Show()
				end)

				mbtn:SetScript("OnLeave", function()
					mbtn.t:Hide()
				end)

				-- Set button size when shown
				mbtn:SetScript("OnShow", function()
					mbtn:SetSize(mbtn.f:GetStringWidth() + 1, 16)
				end)

				mbtn:SetScript("OnClick", function()
					-- Show zone listing for clicked item
					ListData = ZoneList[where]
					UpdateList()
				end)

				return mbtn, mbtn.s

			end

			-- Create a table for each button
			local conbtn = {}
			for q, w in pairs(ZoneList) do
				conbtn[q] = {}
			end

			-- Create buttons
			local function MakeButtonNow(title, anchor)
				conbtn[title], conbtn[title].s = MakeButton(title, height)
				conbtn[title]:ClearAllPoints()
				if title == L["Zones"] then
					-- Set first button position
					conbtn[title]:SetPoint("TOPLEFT", LeaPlusLC["Page9"], "TOPLEFT", 145, -70)
				elseif anchor then
					-- Set subsequent button positions
					conbtn[title]:SetPoint("TOPLEFT", conbtn[anchor], "BOTTOMLEFT", 0, 0)
					conbtn[title].f:SetText(L[title])
				end
			end

			MakeButtonNow(L["Zones"])
			MakeButtonNow(L["Dungeons"], L["Zones"])
			MakeButtonNow(L["Various"], L["Dungeons"])
			MakeButtonNow(L["Movies"], L["Various"])
			MakeButtonNow(L["Random"], L["Movies"])
			MakeButtonNow(L["Search"]) -- Positioned when search editbox is created

			-- Show button highlight for clicked button
			for q, w in pairs(ZoneList) do
				if type(w) == "string" and conbtn[w] then
					conbtn[w]:HookScript("OnClick", function()
						-- Hide all button highlights
						for k, v in pairs(ZoneList) do
							if type(v) == "string" and conbtn[v] then
								conbtn[v].s:Hide()
							end
						end
						-- Show clicked button highlight
						conbtn[w].s:Show()
						LeaPlusDB["MusicContinent"] = w
						scrollFrame:SetVerticalScroll(0)
						-- Set TempFolder for listings without folders
						if w == L["Random"] then TempFolder = L["Random"] end
						if w == L["Search"] then TempFolder = L["Search"] end
					end)
				end
			end

			-- Create scroll bar
			scrollFrame = CreateFrame("ScrollFrame", "LeaPlusScrollFrame", LeaPlusLC["Page9"], "FauxScrollFrameTemplate")
			scrollFrame:SetPoint("TOPLEFT", 0, -32)
			scrollFrame:SetPoint("BOTTOMRIGHT", -30, 50)
			scrollFrame:SetFrameLevel(10)
			scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
				FauxScrollFrame_OnVerticalScroll(self, offset, 16, UpdateList)
			end)

			-- Add stop button
			local stopBtn = LeaPlusLC:CreateButton("StopMusicBtn", LeaPlusLC["Page9"], "Stop", "TOPLEFT", 146, -292, 0, 25, true, "")
			stopBtn:Hide(); stopBtn:Show()
			LeaPlusLC:LockItem(stopBtn, true)
			stopBtn:SetScript("OnClick", function()
				if musicHandle then
					StopSound(musicHandle)
					musicHandle = nil
					-- Hide highlight bars
					LastPlayed = ""
					LastFolder = ""
					UpdateList()
				end
				-- Lock button and cancel update script
				LeaPlusLC:LockItem(stopBtn, true)
				uframe:UnregisterEvent("SOUNDKIT_FINISHED")
				uframe:UnregisterEvent("LOADING_SCREEN_DISABLED")
			end)

			-- Store currently playing track number
			local tracknumber = 1

			-- Function to play a track and show the static highlight bar
			local function PlayTrack()
				-- Play tracks
				if musicHandle then StopSound(musicHandle) end
				local file, soundID = playlist[tracknumber]:match("([^,]+)%#([^,]+)")
				willPlay, musicHandle = PlaySound(soundID, "Master", false, true)
				-- Store its handle for later use
				LastMusicHandle = musicHandle
				LastPlayed = playlist[tracknumber]
				tracknumber = tracknumber + 1
				-- Show static highlight bar
				for index = 1, numButtons do
					local button = scrollFrame.buttons[index]
					local item = button:GetText()
					if item then
						local item, void = item:match("([^,]+)%#([^,]+)")
						if item then
							if item == file and LastFolder == TempFolder then
								button.s:Show()
							else
								button.s:Hide()
							end
						end
					end
				end
			end

			-- Create editbox for search
			local sBox = LeaPlusLC:CreateEditBox("MusicSearchBox", LeaPlusLC["Page9"], 78, 10, "TOPLEFT", 150, -260, "MusicSearchBox", "MusicSearchBox")
			sBox:SetMaxLetters(50)

			-- Position search button above editbox
			conbtn[L["Search"]]:ClearAllPoints()
			conbtn[L["Search"]]:SetPoint("BOTTOMLEFT", sBox, "TOPLEFT", -4, 0)

			-- Set initial search data
			for q, w in pairs(ZoneList) do
				if conbtn[w] then
					conbtn[w]:HookScript("OnClick", function()
						if w == L["Search"] then
							ListData[1] = "|cffffd800" .. L["Search"]
							if #ListData == 1 then 
								ListData[2] = "|cffffffaa{" .. L["enter zone or track name"] .. "}"
							end
							UpdateList()
						else
							sBox:ClearFocus()
						end
					end)
				end
			end

			-- Function to show search results
			local function ShowSearchResults()
				-- Get unescaped editbox text
				local searchText = gsub(strlower(sBox:GetText()), '(['..("%^$().[]*+-?"):gsub("(.)", "%%%1")..'])', "%%%1")
				-- Wipe the track listing
				wipe(ListData)
				-- Set the track list heading
				ListData[1] = "|cffffd800" .. L["Search"]
				-- Show the subheading only if no search results are being shown
				if searchText == "" then
					ListData[2] = "|cffffffaa{" .. L["enter zone or track name"] .. "}"
				else
					ListData[2] = ""
				end
				-- Traverse music listing and populate ListData
				if searchText ~= "" then
					local word1, word2, word3, word4, word5 = strsplit(" ", (strtrim(searchText):gsub("%s+", " ")))
					RunScript('LeaPlusGlobalHash = {}')
					local hash = LeaPlusGlobalHash
					local trackCount = 0
					for i, e in pairs(LeaPlusLC.ZoneList) do
						if LeaPlusLC.ZoneList[e] then
							for a, b in pairs(LeaPlusLC.ZoneList[e]) do
								if b.tracks then
									for k, v in pairs(b.tracks) do
										if (strfind(v, "#") or strfind(v, "|r")) and (strfind(strlower(v), word1) or strfind(strlower(b.zone), word1) or strfind(strlower(b.category), word1)) then
											if not word2 or word2 ~= "" and (strfind(strlower(v), word2) or strfind(strlower(b.zone), word2) or strfind(strlower(b.category), word2)) then
												if not word3 or word3 ~= "" and (strfind(strlower(v), word3) or strfind(strlower(b.zone), word3) or strfind(strlower(b.category), word3)) then
													if not word4 or word4 ~= "" and (strfind(strlower(v), word4) or strfind(strlower(b.zone), word4) or strfind(strlower(b.category), word4)) then
														if not word5 or word5 ~= "" and (strfind(strlower(v), word5) or strfind(strlower(b.zone), word5) or strfind(strlower(b.category), word5)) then
															-- Show category
															if not hash[b.category] then
																tinsert(ListData, "|cffffffff")
																if b.category == e then
																	-- No category so just show ZoneList entry (such as Various)
																	tinsert(ListData, "|cffffd800" .. e)
																else
																	-- Category exists so show that
																	tinsert(ListData, "|cffffd800" .. e .. ": " .. b.category)
																end
																hash[b.category] = true
															end
															-- Show track
															tinsert(ListData, "|Cffffffaa" .. b.zone .. " |r" .. v)
															trackCount = trackCount + 1
															hash[v] = true
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end

					-- Set results tag
					if trackCount == 1 then
						ListData[2] = "|cffffffaa{" .. trackCount .. " " .. L["result"] .. "}"
					else
						ListData[2] = "|cffffffaa{" .. trackCount .. " " .. L["results"] .. "}"
					end
				end
				-- Refresh the track listing
				UpdateList()
				-- Set track listing to top
				scrollFrame:SetVerticalScroll(0)
			end

			-- Populate ListData when editbox is changed by user
			sBox:HookScript("OnTextChanged", function(self, userInput)
				if userInput then
					-- Show search page
					conbtn[L["Search"]]:Click()
					-- If search results are currently playing, stop playback since search results will be changed
					if LastFolder == L["Search"] then stopBtn:Click() end
					-- Show search results
					ShowSearchResults()
				end
			end)

			-- Populate ListData when editbox enter key is pressed
			sBox:HookScript("OnEnterPressed", function()
				-- Show search page
				conbtn[L["Search"]]:Click()
				-- If search results are currently playing, stop playback since search results will be changed
				if LastFolder == L["Search"] then stopBtn:Click() end
				-- Show search results
				ShowSearchResults()
			end)

			-- Function to show random track listing
			local function ShowRandomList()
				-- If random track is currently playing, stop playback since random track list will be changed
				if LastFolder == L["Random"] then 
					stopBtn:Click()
				end
				-- Wipe the track listing for random
				wipe(ListData)
				-- Set the track list heading
				ListData[1] = "|cffffd800" .. L["Random"]
				ListData[2] = "|Cffffffaa{" .. L["click here for new selection"] .. "}" -- Must be capital |C
				ListData[3] = "|cffffd800"
				ListData[4] = "|cffffd800" .. L["Selection of music tracks"] -- Must be lower case |c
				-- Populate list data until it contains desired number of tracks
				while #ListData < 50 do
					-- Get random category
					local rCategory = GetRandomArgument(L["Zones"], L["Dungeons"], L["Various"])
					-- Get random zone within category
					local rZone = random(1, #ZoneList[rCategory])
					-- Get random track within zone
					local rTrack = ZoneList[rCategory][rZone].tracks[random(1, #ZoneList[rCategory][rZone].tracks)]
					-- Insert track into ListData if it's not a duplicate
					if rTrack and rTrack ~= "" and strfind(rTrack, "#") and not tContains(ListData, "|Cffffffaa" .. ZoneList[rCategory][rZone].zone .. " |r" .. rTrack) then
						tinsert(ListData, "|Cffffffaa" .. ZoneList[rCategory][rZone].zone .. " |r" .. rTrack)
					end
				end
				-- Refresh the track listing
				UpdateList()
				-- Set track listing to top
				scrollFrame:SetVerticalScroll(0)
			end

			-- Show random track listing on startup when random button is clicked
			for q, w in pairs(ZoneList) do
				if conbtn[w] then
					conbtn[w]:HookScript("OnClick", function()
						if w == L["Random"] then
							-- Generate initial playlist for first run
							if #ListData == 0 then
								ShowRandomList()
							end
						end
					end)
				end
			end

			-- Create list items
			scrollFrame.buttons = {}
			for i = 1, numButtons do
				scrollFrame.buttons[i] = CreateFrame("Button", nil, LeaPlusLC["Page9"])
				local button = scrollFrame.buttons[i]

				button:SetSize(470 - 14, 16)
				button:SetNormalFontObject("GameFontHighlightLeft")
				button:SetPoint("TOPLEFT", 246, -62+ -(i - 1) * 16 - 8)

				-- Create highlight bar texture
				button.t = button:CreateTexture(nil, "BACKGROUND")
				button.t:SetPoint("TOPLEFT", button, 0, 0)
				button.t:SetSize(516, 16)

				button.t:SetColorTexture(0.3, 0.3, 0.0, 0.8)
				button.t:SetAlpha(0.7)
				button.t:Hide()

				-- Create last playing highlight bar texture
				button.s = button:CreateTexture(nil, "BACKGROUND")
				button.s:SetPoint("TOPLEFT", button, 0, 0)
				button.s:SetSize(516, 16)

				button.s:SetColorTexture(0.3, 0.4, 0.00, 0.6)
				button.s:Hide()

				button:SetScript("OnEnter", function()
					-- Highlight links only
					if not string.match(button:GetText() or "", "|c") then
						button.t:Show()
					end
				end)

				button:SetScript("OnLeave", function()
					button.t:Hide()
				end)

				button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

				-- Handler for playing next SoundKit track in playlist
				uframe:SetScript("OnEvent", function(self, event, stoppedHandle)
					if event == "SOUNDKIT_FINISHED" then
						-- Do nothing if stopped sound kit handle doesnt match last played track handle
						if LastMusicHandle and LastMusicHandle ~= stoppedHandle then return end
						-- Reset track number if playlist has reached the end
						if tracknumber == #playlist then tracknumber = 1 end
						-- Play next track
						PlayTrack()
					elseif event == "LOADING_SCREEN_DISABLED" then
						-- Restart player if it stopped between tracks during loading screen
						if playlist and tracknumber and playlist[tracknumber] and not willPlay and not musicHandle then
							tracknumber = tracknumber - 1
							C_Timer.After(0.1, PlayTrack)
						end
					end
				end)

				-- Click handler for track, zone and back button
				button:SetScript("OnClick", function(self, btn)
					if btn == "LeftButton" then
						-- Remove focus from search box
						sBox:ClearFocus()
						-- Get clicked track text
						local item = self:GetText()
						-- Do nothing if its a blank line or informational heading
						if not item or strfind(item, "|c") then return end
						if item == "|Cffffffaa{" .. L["click here for new selection"] .. "}" then -- must be capital |C
							-- Create new random track listing
							ShowRandomList()
							return
						elseif strfind(item, "#") then
							-- Enable sound if required
							if GetCVar("Sound_EnableAllSound") == "0" then SetCVar("Sound_EnableAllSound", "1") end
							-- Disable music if it's currently enabled
							if GetCVar("Sound_EnableMusic") == "1" then	SetCVar("Sound_EnableMusic", "0") end
							-- Add all tracks to playlist
							wipe(playlist)
							local StartItem = 0
							-- Get item clicked row number
							for index = 1, #ListData do
								local item = ListData[index]
								if self:GetText() == item then StartItem = index end
							end
							-- Add all items from clicked item onwards to playlist
							for index = StartItem, #ListData do
								local item = ListData[index]
								if item then
									if strfind(item, "#") then 
										tinsert(playlist, item)
									end
								end
							end
							-- Add all items up to clicked item to playlist
							for index = 1, StartItem do
								local item = ListData[index]
								if item then
									if strfind(item, "#") then 
										tinsert(playlist, item)
									end
								end
							end
							-- Enable the stop button
							LeaPlusLC:LockItem(stopBtn, false)
							-- Set Temp Folder to Random if track is in Random
							if ListData[1] == "|cffffd800" .. L["Random"] then TempFolder = L["Random"] end
							-- Set Temp Folder to Search if track is in Search
							if ListData[1] == "|cffffd800" .. L["Search"] then TempFolder = L["Search"] end
							-- Store information about the track we are about to play
							tracknumber = 1
							LastPlayed = item
							LastFolder = TempFolder
							HeadingOfClickedTrack = ListData[1]
							-- Play first track
							PlayTrack()
							-- Play subsequent tracks
							uframe:RegisterEvent("SOUNDKIT_FINISHED")
							uframe:RegisterEvent("LOADING_SCREEN_DISABLED")
							return
						elseif strfind(item, "|r") then
							-- A movie was clicked
							local movieName, movieID = item:match("([^,]+)%|r([^,]+)")
							movieID = strtrim(movieID, "()")
							if IsMoviePlayable(movieID) then
								stopBtn:Click()
								MovieFrame_PlayMovie(MovieFrame, movieID)
							else
								LeaPlusLC:Print("Movie not playable.")
							end
							return
						else
							-- A zone was clicked so show track listing
							ZonePage = scrollFrame:GetVerticalScroll()
							-- Find the track listing for the clicked zone
							for q, w in pairs(ZoneList) do
								for k, v in pairs(ZoneList[w]) do
									if item == v.zone then
										-- Show track listing
										TempFolder = item
										LeaPlusDB["MusicZone"] = item
										ListData = v.tracks
										UpdateList()
										-- Hide hover highlight if track under pointer is a heading
										if strfind(scrollFrame.buttons[i]:GetText(), "|c") then
											scrollFrame.buttons[i].t:Hide()
										end
										-- Show top of track list
										scrollFrame:SetVerticalScroll(0)
										return
									end
								end	
							end
						end
					elseif btn == "RightButton" then
						-- Back button was clicked
						BackClick()
					end
				end)

			end

			-- Right-click to go back (from anywhere on the main content area of the panel)
			LeaPlusLC["PageF"]:HookScript("OnMouseUp", function(self, btn)
				if LeaPlusLC["Page9"]:IsShown() and LeaPlusLC["Page9"]:IsMouseOver(0, 0, 0, -440) == false and LeaPlusLC["Page9"]:IsMouseOver(-330, 0, 0, 0) == false then 
					if btn == "RightButton" then
						BackClick()
					end
				end
			end)

			-- Delete the global scroll frame pointer
			_G.LeaPlusScrollFrame = nil

			-- Set zone listing on startup
			if LeaPlusDB["MusicContinent"] and LeaPlusDB["MusicContinent"] ~= "" then
				-- Saved music continent exists
				if conbtn[LeaPlusDB["MusicContinent"]] then
					-- Saved continent is valid button so click it
					conbtn[LeaPlusDB["MusicContinent"]]:Click()
				else
					-- Saved continent is not valid button so click default button
					conbtn[L["Zones"]]:Click()
				end
			else
				-- Saved music continent does not exist so click default button
				conbtn[L["Zones"]]:Click()
			end
			UpdateList()

			-- Manage events
			LeaPlusLC["Page9"]:RegisterEvent("PLAYER_LOGOUT")
			LeaPlusLC["Page9"]:RegisterEvent("UI_SCALE_CHANGED")
			LeaPlusLC["Page9"]:SetScript("OnEvent", function(self, event)
				if event == "PLAYER_LOGOUT" then
					-- Stop playing at reload or logout
					if musicHandle then
						StopSound(musicHandle)
					end
				elseif event == "UI_SCALE_CHANGED" then
					-- Refresh list
					UpdateList()
				end
			end)

		end

		-- Run on startup
		LeaPlusLC:MediaFunc()

		-- Release memory
		LeaPlusLC.MediaFunc = nil

		----------------------------------------------------------------------
		-- Panel alpha
		----------------------------------------------------------------------

		-- Function to set panel alpha
		local function SetPlusAlpha()
			-- Set panel alpha
			LeaPlusLC["PageF"].t:SetAlpha(1 - LeaPlusLC["PlusPanelAlpha"])
			-- Show formatted value
			LeaPlusCB["PlusPanelAlpha"].f:SetFormattedText("%.0f%%", LeaPlusLC["PlusPanelAlpha"] * 100)
		end

		-- Set alpha on startup
		SetPlusAlpha()

		-- Set alpha after changing slider
		LeaPlusCB["PlusPanelAlpha"]:HookScript("OnValueChanged", SetPlusAlpha)

		----------------------------------------------------------------------
		-- Panel scale
		----------------------------------------------------------------------

		-- Function to set panel scale
		local function SetPlusScale()
			-- Reset panel position
			LeaPlusLC["MainPanelA"], LeaPlusLC["MainPanelR"], LeaPlusLC["MainPanelX"], LeaPlusLC["MainPanelY"] = "CENTER", "CENTER", 0, 0
			if LeaPlusLC["PageF"]:IsShown() then 
				LeaPlusLC["PageF"]:Hide()
				LeaPlusLC["PageF"]:Show()
			end
			-- Set panel scale
			LeaPlusLC["PageF"]:SetScale(LeaPlusLC["PlusPanelScale"])
			-- Update music player highlight bar scale
			LeaPlusLC:UpdateList()
		end

		-- Set scale on startup
		LeaPlusLC["PageF"]:SetScale(LeaPlusLC["PlusPanelScale"])

		-- Set scale and reset panel position after changing slider
		LeaPlusCB["PlusPanelScale"]:HookScript("OnMouseUp", SetPlusScale)
		LeaPlusCB["PlusPanelScale"]:HookScript("OnMouseWheel", SetPlusScale)

		-- Show formatted slider value
		LeaPlusCB["PlusPanelScale"]:HookScript("OnValueChanged", function()
			LeaPlusCB["PlusPanelScale"].f:SetFormattedText("%.0f%%", LeaPlusLC["PlusPanelScale"] * 100)
		end)

		----------------------------------------------------------------------
		-- Options panel
		----------------------------------------------------------------------

		-- Hide Leatrix Plus if game options panel is shown
		InterfaceOptionsFrame:HookScript("OnShow", LeaPlusLC.HideFrames);
		VideoOptionsFrame:HookScript("OnShow", LeaPlusLC.HideFrames);

		----------------------------------------------------------------------
		-- Block friend requests
		----------------------------------------------------------------------

		-- Function to decline friend requests
		local function DeclineReqs()
			if LeaPlusLC["NoFriendRequests"] == "On" then
				for i = BNGetNumFriendInvites(), 1, -1 do
					local id, player = BNGetFriendInviteInfo(i)
					if id and player then
						BNDeclineFriendInvite(id)
						C_Timer.After(0.1, function()
							LeaPlusLC:Print(L["A friend request from"] .. " " .. player .. " " .. L["was automatically declined."])
						end)
					end
				end
			end
		end

		-- Event frame for incoming friend requests
		local DecEvt = CreateFrame("FRAME")
		DecEvt:SetScript("OnEvent", DeclineReqs)

		-- Function to register or unregister the event
		local function ControlEvent()
			if LeaPlusLC["NoFriendRequests"] == "On" then
				DecEvt:RegisterEvent("BN_FRIEND_INVITE_ADDED")
				DeclineReqs()
			else
				DecEvt:UnregisterEvent("BN_FRIEND_INVITE_ADDED")
			end
		end

		-- Set event status when option is enabled
		LeaPlusCB["NoFriendRequests"]:HookScript("OnClick", ControlEvent)

		-- Set event status on startup
		ControlEvent()

		----------------------------------------------------------------------
		-- Final code for RunOnce
		----------------------------------------------------------------------

		-- Update addon memory usage (speeds up initial value)
		UpdateAddOnMemoryUsage();

		-- Release memory
		LeaPlusLC.RunOnce = nil

	end

----------------------------------------------------------------------
-- 	L60: Default events
----------------------------------------------------------------------

	local function eventHandler(self, event, arg1, arg2, ...)

		----------------------------------------------------------------------
		-- Invite from whisper
		----------------------------------------------------------------------

		if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER" then
			if (not UnitExists("party1") or UnitIsGroupLeader("player")) and strlower(arg1) == "inv" then
				if not LeaPlusLC:IsInLFGQueue() then
					if event == "CHAT_MSG_WHISPER" then
						InviteUnit(arg2)
					elseif event == "CHAT_MSG_BN_WHISPER" then
						local presenceID = select(11, ...)
						if presenceID and BNIsFriend(presenceID) then
							local index = BNGetFriendIndex(presenceID);
							if index then
								local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID = BNGetFriendInfo(index);
								if toonID then
									BNInviteFriend(toonID);
								end
							end
						end
					end
				end
			end
			return
		end

		----------------------------------------------------------------------
		-- Block duel requests
		----------------------------------------------------------------------

		if event == "DUEL_REQUESTED" and not LeaPlusLC:FriendCheck(arg1) then
			CancelDuel();
			StaticPopup_Hide("DUEL_REQUESTED");
			return
		end

		----------------------------------------------------------------------
		-- Block pet battle duel requests
		----------------------------------------------------------------------

		if event == "PET_BATTLE_PVP_DUEL_REQUESTED" and not LeaPlusLC:FriendCheck(arg1) then
			C_PetBattles.CancelPVPDuel()
			return
		end

		----------------------------------------------------------------------
		-- Automatically accept resurrection requests
		----------------------------------------------------------------------

		if event == "RESURRECT_REQUEST" then

			-- Exclude pylon and brazier requests
			local pylonLoc

			-- Exclude Failure Detection Pylon
			pylonLoc = "Failure Detection Pylon"
			if 	   GameLocale == "zhCN" then pylonLoc = "故障检测晶塔"
			elseif GameLocale == "zhTW" then pylonLoc = "滅團偵測水晶塔"
			elseif GameLocale == "ruRU" then pylonLoc = "Пилон для обнаружения проблем"
			elseif GameLocale == "koKR" then pylonLoc = "고장 감지 변환기"
			elseif GameLocale == "esMX" then pylonLoc = "Pilón detector de errores"
			elseif GameLocale == "ptBR" then pylonLoc = "Pilar Detector de Falhas"
			elseif GameLocale == "deDE" then pylonLoc = "Fehlschlagdetektorpylon"
			elseif GameLocale == "esES" then pylonLoc = "Pilón detector de errores"
			elseif GameLocale == "frFR" then pylonLoc = "Pylône de détection des échecs"
			elseif GameLocale == "itIT" then pylonLoc = "Pilone d'Individuazione Fallimenti"
			end
			if arg1 == pylonLoc then return	end

			-- Exclude Brazier of Awakening
			pylonLoc = "Brazier of Awakening"
			if 	   GameLocale == "zhCN" then pylonLoc = "觉醒火盆"
			elseif GameLocale == "zhTW" then pylonLoc = "覺醒火盆"
			elseif GameLocale == "ruRU" then pylonLoc = "Жаровня пробуждения"
			elseif GameLocale == "koKR" then pylonLoc = "각성의 화로"
			elseif GameLocale == "esMX" then pylonLoc = "Blandón del Despertar"
			elseif GameLocale == "ptBR" then pylonLoc = "Braseiro do Despertar"
			elseif GameLocale == "deDE" then pylonLoc = "Kohlenbecken des Erwachens"
			elseif GameLocale == "esES" then pylonLoc = "Blandón de Despertar"
			elseif GameLocale == "frFR" then pylonLoc = "Brasero de l'Éveil"
			elseif GameLocale == "itIT" then pylonLoc = "Braciere del Risveglio"
			end
			if arg1 == pylonLoc then return	end

			-- Manage other resurrection requests
			if not UnitAffectingCombat(arg1) then
				AcceptResurrect()
				StaticPopup_Hide("RESURRECT_NO_TIMER")
			end
			return

		end

		----------------------------------------------------------------------
		-- Accept summon
		----------------------------------------------------------------------

		if event == "CONFIRM_SUMMON" then
			if not UnitAffectingCombat("player") then
				ConfirmSummon()
				StaticPopup_Hide("CONFIRM_SUMMON")
			end
			return
		end

		----------------------------------------------------------------------
		-- Block party invites
		----------------------------------------------------------------------

		if event == "PARTY_INVITE_REQUEST" then

			-- If a friend, accept if you're accepting friends and not in Dungeon Finder
			if (LeaPlusLC["AcceptPartyFriends"] == "On" and LeaPlusLC:FriendCheck(arg1)) then
				if not LeaPlusLC:IsInLFGQueue() then
					AcceptGroup();
					for i=1, STATICPOPUP_NUMDIALOGS do
						if _G["StaticPopup"..i].which == "PARTY_INVITE" then
							_G["StaticPopup"..i].inviteAccepted = 1
							StaticPopup_Hide("PARTY_INVITE");
							break
						elseif _G["StaticPopup"..i].which == "PARTY_INVITE_XREALM" then
							_G["StaticPopup"..i].inviteAccepted = 1
							StaticPopup_Hide("PARTY_INVITE_XREALM");
							break
						end
					end
					return
				end
			end

			-- If not a friend and you're blocking invites, decline
			if LeaPlusLC["NoPartyInvites"] == "On" then
				if LeaPlusLC:FriendCheck(arg1) then
					return
				else
					DeclineGroup();
					StaticPopup_Hide("PARTY_INVITE");
					StaticPopup_Hide("PARTY_INVITE_XREALM");
					return
				end
			end

			return
		end

		----------------------------------------------------------------------
		-- Disable loot warnings
		----------------------------------------------------------------------

		-- Disable warnings for attempting to roll Need or Disenchant on loot
		if event == "CONFIRM_LOOT_ROLL" or event == "CONFIRM_DISENCHANT_ROLL" then
			ConfirmLootRoll(arg1, arg2)
			StaticPopup_Hide("CONFIRM_LOOT_ROLL")
			return
		end

		-- Disable warning for attempting to loot a Bind on Pickup item
		if event == "LOOT_BIND_CONFIRM" then
			ConfirmLootSlot(arg1, arg2)
			StaticPopup_Hide("LOOT_BIND",...)
			return
		end

		-- Disable warning for attempting to vendor an item within its refund window
		if event == "MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL" then
			SellCursorItem()
			return
		end

		-- Disable warning for attempting to mail an item within its refund window
		if event == "MAIL_LOCK_SEND_ITEMS" then
			RespondMailLockSendItem(arg1, true)
			return
		end

		----------------------------------------------------------------------
		-- Automatically release in battlegrounds
		----------------------------------------------------------------------

		if event == "PLAYER_DEAD" then

			-- If player has ability to self-resurrect (soulstone, reincarnation, etc), do nothing and quit
			if C_DeathInfo.GetSelfResurrectOptions() and #C_DeathInfo.GetSelfResurrectOptions() > 0 then return end

			-- Resurrect if player is in a battleground
			local InstStat, InstType = IsInInstance()
			if InstStat and InstType == "pvp" then
				RepopMe()
				return
			end

			-- Resurrect if playuer is in a PvP location
			local areaID = C_Map.GetBestMapForUnit("player") or 0
			if areaID == 123 -- Wintergrasp
			or areaID == 244 -- Tol Barad (PvP)
			or areaID == 588 -- Ashran 
			or areaID == 622 -- Stormshield
			or areaID == 624 -- Warspear 
			then 
				RepopMe()
				return
			end
			
			return

		end

		----------------------------------------------------------------------
		-- Hide the combat log
		----------------------------------------------------------------------

		if event == "UPDATE_CHAT_WINDOWS" then
			ChatFrame2Tab:EnableMouse(false)
			ChatFrame2Tab:SetText(" ") -- Needs to be something for chat settings to function
			ChatFrame2Tab:SetScale(0.01)
			ChatFrame2Tab:SetWidth(0.01)
			ChatFrame2Tab:SetHeight(0.01)
		end

		----------------------------------------------------------------------
		-- L62: Profile events
		----------------------------------------------------------------------

		if event == "ADDON_LOADED" then
			if arg1 == "Leatrix_Plus" then

				-- Automation
				LeaPlusLC:LoadVarChk("AutomateQuests", "Off")				-- Automate quests
				LeaPlusLC:LoadVarChk("AutomateGossip", "Off")				-- Automate gossip
				LeaPlusLC:LoadVarChk("AutoAcceptSummon", "Off")				-- Accept summon
				LeaPlusLC:LoadVarChk("AutoAcceptRes", "Off")				-- Accept resurrection
				LeaPlusLC:LoadVarChk("AutoReleasePvP", "Off")				-- Release in PvP

				LeaPlusLC:LoadVarChk("AutoSellJunk", "Off")					-- Sell junk automatically
				LeaPlusLC:LoadVarChk("AutoRepairGear", "Off")				-- Repair automatically
				LeaPlusLC:LoadVarChk("AutoRepairGuildFunds", "On")			-- Repair using guild funds

				-- Social
				LeaPlusLC:LoadVarChk("NoDuelRequests", "Off")				-- Block duels
				LeaPlusLC:LoadVarChk("NoPetDuels", "Off")					-- Block pet battle duels
				LeaPlusLC:LoadVarChk("NoPartyInvites", "Off")				-- Block party invites
				LeaPlusLC:LoadVarChk("NoFriendRequests", "Off")				-- Block friend requests

				LeaPlusLC:LoadVarChk("AcceptPartyFriends", "Off")			-- Party from friends
				LeaPlusLC:LoadVarChk("AutoConfirmRole", "Off")				-- Queue from friends
				LeaPlusLC:LoadVarChk("InviteFromWhisper", "Off")			-- Invite from whispers

				-- Chat
				LeaPlusLC:LoadVarChk("UseEasyChatResizing", "Off")			-- Use easy resizing
				LeaPlusLC:LoadVarChk("NoCombatLogTab", "Off")				-- Hide the combat log
				LeaPlusLC:LoadVarChk("NoChatButtons", "Off")				-- Hide chat buttons
				LeaPlusLC:LoadVarChk("NoSocialButton", "Off")				-- Hide social button
				LeaPlusLC:LoadVarChk("UnclampChat", "Off")					-- Unclamp chat frame
				LeaPlusLC:LoadVarChk("MoveChatEditBoxToTop", "Off")			-- Move editbox to top

				LeaPlusLC:LoadVarChk("NoStickyChat", "Off")					-- Disable sticky chat
				LeaPlusLC:LoadVarChk("UseArrowKeysInChat", "Off")			-- Use arrow keys in chat
				LeaPlusLC:LoadVarChk("NoChatFade", "Off")					-- Disable chat fade
				LeaPlusLC:LoadVarChk("UnivGroupColor", "Off")				-- Universal group color
				LeaPlusLC:LoadVarChk("RecentChatWindow", "Off")				-- Recent chat window
				LeaPlusLC:LoadVarChk("MaxChatHstory", "Off")				-- Increase chat history

				-- Text
				LeaPlusLC:LoadVarChk("HideErrorMessages", "Off")			-- Hide error messages
				LeaPlusLC:LoadVarChk("NoHitIndicators", "Off")				-- Hide portrait text
				LeaPlusLC:LoadVarChk("HideCraftedNames", "Off")				-- Hide crafted names
				LeaPlusLC:LoadVarChk("HideZoneText", "Off")					-- Hide zone text

				LeaPlusLC:LoadVarChk("MailFontChange", "Off")				-- Resize mail text
				LeaPlusLC:LoadVarNum("LeaPlusMailFontSize", 15, 10, 36)		-- Mail text slider

				LeaPlusLC:LoadVarChk("QuestFontChange", "Off")				-- Resize quest text
				LeaPlusLC:LoadVarNum("LeaPlusQuestFontSize", 12, 10, 36)	-- Quest text slider

				-- Interface
				LeaPlusLC:LoadVarChk("MinimapMod", "Off")					-- Customise minimap
				LeaPlusLC:LoadVarChk("HideZoneTextBar", "Off")				-- Hide zone text bar
				LeaPlusLC:LoadVarChk("MergeTrackBtn", "Off")				-- Merge minimap buttons
				LeaPlusLC:LoadVarChk("HideMiniZoomBtns", "Off")				-- Hide zoom buttons
				LeaPlusLC:LoadVarChk("HideMiniClock", "Off")				-- Hide the clock
				LeaPlusLC:LoadVarNum("MinimapScale", 1, 1, 2)				-- Minimap scale slider

				LeaPlusLC:LoadVarChk("TipModEnable", "Off")					-- Manage tooltip
				LeaPlusLC:LoadVarChk("TipMoveTip", "On")					-- Reposition the tooltip
				LeaPlusLC:LoadVarChk("TipShowRank", "On")					-- Show rank
				LeaPlusLC:LoadVarChk("TipShowTarget", "On")					-- Show target
				LeaPlusLC:LoadVarChk("TipBackSimple", "Off")				-- Color backdrops
				LeaPlusLC:LoadVarChk("TipHideInCombat", "Off")				-- Hide tooltips during combat
				LeaPlusLC:LoadVarNum("LeaPlusTipSize", 1.00, 0.50, 2.00)	-- Tooltip scale slider
				LeaPlusLC:LoadVarNum("TipOffsetX", -13, -5000, 5000)		-- Tooltip X offset
				LeaPlusLC:LoadVarNum("TipOffsetY", 94, -5000, 5000)			-- Tooltip Y offset

				LeaPlusLC:LoadVarChk("EnhanceDressup", "Off")				-- Enhance dressup
				LeaPlusLC:LoadVarChk("ShowVolume", "Off")					-- Show volume slider
				LeaPlusLC:LoadVarChk("ShowVolumeInFrame", "Off")			-- Volume slider dual layout
				LeaPlusLC:LoadVarChk("AhExtras", "Off")						-- Show auction controls
				LeaPlusLC:LoadVarChk("AhBuyoutOnly", "Off")					-- Auction buyout only
				LeaPlusLC:LoadVarChk("AhGoldOnly", "Off")					-- Auction gold only

				LeaPlusLC:LoadVarChk("ShowCooldowns", "Off")				-- Show cooldowns
				LeaPlusLC:LoadVarChk("ShowCooldownID", "On")				-- Show cooldown ID in tips
				LeaPlusLC:LoadVarChk("NoCooldownDuration", "On")			-- Hide cooldown duration
				LeaPlusLC:LoadVarChk("DurabilityStatus", "Off")				-- Show durability status
				LeaPlusLC:LoadVarChk("ShowPetSaveBtn", "Off")				-- Show pet save button
				LeaPlusLC:LoadVarChk("ShowWowheadLinks", "Off")				-- Show Wowhead links

				-- Frames
				LeaPlusLC:LoadVarChk("FrmEnabled", "Off")					-- Manage frames
				LeaPlusLC:LoadVarChk("ClassColFrames", "Off")				-- Class colored frames
				LeaPlusLC:LoadVarChk("ShowPlayerChain", "Off")				-- Show player chain
				LeaPlusLC:LoadVarNum("PlayerChainMenu", 2, 1, 3)			-- Player chain dropdown value
				LeaPlusLC:LoadVarChk("ShowRaidToggle", "Off")				-- Show raid toggle button
				LeaPlusLC:LoadVarChk("CombatPlates", "Off")					-- Combat plates

				LeaPlusLC:LoadVarChk("NoAlerts", "Off")						-- Hide alerts
				LeaPlusLC:LoadVarChk("HideBodyguard", "Off")				-- Hide bodyguard window
				LeaPlusLC:LoadVarChk("HideTalkingFrame", "Off")				-- Hide talking frame
				LeaPlusLC:LoadVarChk("HideCleanupBtns", "Off")				-- Hide clean-up buttons
				LeaPlusLC:LoadVarChk("HideBossBanner", "Off")				-- Hide boss banner
				LeaPlusLC:LoadVarChk("HideLevelUpDisplay", "Off")			-- Hide level-up display
				LeaPlusLC:LoadVarChk("NoGryphons", "Off")					-- Hide gryphons
				LeaPlusLC:LoadVarChk("NoClassBar", "Off")					-- Hide stance bar
				LeaPlusLC:LoadVarChk("NoCommandBar", "Off")					-- Hide order hall bar

				-- System
				LeaPlusLC:LoadVarChk("NoScreenGlow", "Off")					-- Disable screen glow
				LeaPlusLC:LoadVarChk("NoScreenEffects", "Off")				-- Disable screen effects
				LeaPlusLC:LoadVarChk("MaxCameraZoom", "Off")				-- Max camera zoom
				LeaPlusLC:LoadVarChk("ViewPortEnable", "Off")				-- Enable viewport
				LeaPlusLC:LoadVarNum("ViewPortTop", 0, 0, 300)				-- Top border
				LeaPlusLC:LoadVarNum("ViewPortBottom", 0, 0, 300)			-- Bottom border
				LeaPlusLC:LoadVarNum("ViewPortLeft", 0, 0, 300)				-- Left border
				LeaPlusLC:LoadVarNum("ViewPortRight", 0, 0, 300)			-- Right border
				LeaPlusLC:LoadVarNum("ViewPortResizeTop", 0, 0, 300)		-- Resize top border
				LeaPlusLC:LoadVarNum("ViewPortResizeBottom", 0, 0, 300)		-- Resize bottom border
				LeaPlusLC:LoadVarNum("ViewPortAlpha", 0, 0, 0.9)			-- Border alpha

				LeaPlusLC:LoadVarChk("NoRestedEmotes", "Off")				-- Silence rested emotes

				LeaPlusLC:LoadVarChk("NoBagAutomation", "Off")				-- Disable bag automation
				LeaPlusLC:LoadVarChk("NoPetAutomation", "Off")				-- Disable pet automation
				LeaPlusLC:LoadVarChk("CharAddonList", "Off")				-- Show character addons
				LeaPlusLC:LoadVarChk("NoRaidRestrictions", "Off")			-- Remove raid restrictions
				LeaPlusLC:LoadVarChk("NoConfirmLoot", "Off")				-- Disable loot warnings
				LeaPlusLC:LoadVarChk("FasterLooting", "Off")				-- Faster auto loot
				LeaPlusLC:LoadVarChk("FasterMovieSkip", "Off")				-- Faster movie skip
				LeaPlusLC:LoadVarChk("LockoutSharing", "Off")				-- Lockout sharing

				-- Settings
				LeaPlusLC:LoadVarChk("ShowMinimapIcon", "On")				-- Show minimap button
				LeaPlusLC:LoadVarChk("EnableHotkey", "Off")					-- Enable hotkey

				LeaPlusLC:LoadVarNum("PlusPanelScale", 1, 1, 2)				-- Panel scale
				LeaPlusLC:LoadVarNum("PlusPanelAlpha", 0, 0, 1)				-- Panel alpha

				-- Panel position
				LeaPlusLC:LoadVarAnc("MainPanelA", "CENTER")				-- Panel anchor
				LeaPlusLC:LoadVarAnc("MainPanelR", "CENTER")				-- Panel relative
				LeaPlusLC:LoadVarNum("MainPanelX", 0, -5000, 5000)			-- Panel X axis
				LeaPlusLC:LoadVarNum("MainPanelY", 0, -5000, 5000)			-- Panel Y axis

				-- Start page
				LeaPlusLC:LoadVarNum("LeaStartPage", 0, 0, LeaPlusLC["NumberOfPages"])

				-- Run other startup items
				LeaPlusLC:Live()
				LeaPlusLC:Isolated()
				LeaPlusLC:RunOnce()
				LeaPlusLC:SetDim()

			end
			return
		end

		if event == "PLAYER_LOGIN" then
			LeaPlusLC:Player()
			collectgarbage()
			return
		end

		-- Save locals back to globals on logout
		if event == "PLAYER_LOGOUT" then

			-- Run the logout function without wipe flag
			LeaPlusLC:PlayerLogout(false)

			-- Automation
			LeaPlusDB["AutomateQuests"]			= LeaPlusLC["AutomateQuests"]
			LeaPlusDB["AutomateGossip"]			= LeaPlusLC["AutomateGossip"]
			LeaPlusDB["AutoAcceptSummon"] 		= LeaPlusLC["AutoAcceptSummon"]
			LeaPlusDB["AutoAcceptRes"] 			= LeaPlusLC["AutoAcceptRes"]
			LeaPlusDB["AutoReleasePvP"] 		= LeaPlusLC["AutoReleasePvP"]

			LeaPlusDB["AutoSellJunk"] 			= LeaPlusLC["AutoSellJunk"]
			LeaPlusDB["AutoRepairGear"] 		= LeaPlusLC["AutoRepairGear"]
			LeaPlusDB["AutoRepairGuildFunds"] 	= LeaPlusLC["AutoRepairGuildFunds"]

			-- Social
			LeaPlusDB["NoDuelRequests"] 		= LeaPlusLC["NoDuelRequests"]
			LeaPlusDB["NoPetDuels"] 			= LeaPlusLC["NoPetDuels"]
			LeaPlusDB["NoPartyInvites"]			= LeaPlusLC["NoPartyInvites"]
			LeaPlusDB["NoFriendRequests"]		= LeaPlusLC["NoFriendRequests"]

			LeaPlusDB["AcceptPartyFriends"]		= LeaPlusLC["AcceptPartyFriends"]
			LeaPlusDB["AutoConfirmRole"]		= LeaPlusLC["AutoConfirmRole"]
			LeaPlusDB["InviteFromWhisper"]		= LeaPlusLC["InviteFromWhisper"]

			-- Chat
			LeaPlusDB["UseEasyChatResizing"]	= LeaPlusLC["UseEasyChatResizing"]
			LeaPlusDB["NoCombatLogTab"]			= LeaPlusLC["NoCombatLogTab"]
			LeaPlusDB["NoChatButtons"]			= LeaPlusLC["NoChatButtons"]
			LeaPlusDB["NoSocialButton"]			= LeaPlusLC["NoSocialButton"]
			LeaPlusDB["UnclampChat"]			= LeaPlusLC["UnclampChat"]
			LeaPlusDB["MoveChatEditBoxToTop"]	= LeaPlusLC["MoveChatEditBoxToTop"]

			LeaPlusDB["NoStickyChat"] 			= LeaPlusLC["NoStickyChat"]
			LeaPlusDB["UseArrowKeysInChat"]		= LeaPlusLC["UseArrowKeysInChat"]
			LeaPlusDB["NoChatFade"]				= LeaPlusLC["NoChatFade"]
			LeaPlusDB["UnivGroupColor"]			= LeaPlusLC["UnivGroupColor"]
			LeaPlusDB["RecentChatWindow"]		= LeaPlusLC["RecentChatWindow"]
			LeaPlusDB["MaxChatHstory"]			= LeaPlusLC["MaxChatHstory"]

			-- Text
			LeaPlusDB["HideErrorMessages"]		= LeaPlusLC["HideErrorMessages"]
			LeaPlusDB["NoHitIndicators"]		= LeaPlusLC["NoHitIndicators"]
			LeaPlusDB["HideCraftedNames"] 		= LeaPlusLC["HideCraftedNames"]
			LeaPlusDB["HideZoneText"] 			= LeaPlusLC["HideZoneText"]

			LeaPlusDB["MailFontChange"] 		= LeaPlusLC["MailFontChange"]
			LeaPlusDB["LeaPlusMailFontSize"] 	= LeaPlusLC["LeaPlusMailFontSize"]

			LeaPlusDB["QuestFontChange"] 		= LeaPlusLC["QuestFontChange"]
			LeaPlusDB["LeaPlusQuestFontSize"]	= LeaPlusLC["LeaPlusQuestFontSize"]

			-- Interface
			LeaPlusDB["MinimapMod"]				= LeaPlusLC["MinimapMod"]
			LeaPlusDB["HideZoneTextBar"]		= LeaPlusLC["HideZoneTextBar"]
			LeaPlusDB["MergeTrackBtn"]			= LeaPlusLC["MergeTrackBtn"]
			LeaPlusDB["HideMiniZoomBtns"]		= LeaPlusLC["HideMiniZoomBtns"]
			LeaPlusDB["HideMiniClock"]			= LeaPlusLC["HideMiniClock"]
			LeaPlusDB["MinimapScale"]			= LeaPlusLC["MinimapScale"]

			LeaPlusDB["TipModEnable"]			= LeaPlusLC["TipModEnable"]
			LeaPlusDB["TipMoveTip"]				= LeaPlusLC["TipMoveTip"]
			LeaPlusDB["TipShowRank"]			= LeaPlusLC["TipShowRank"]
			LeaPlusDB["TipShowTarget"]			= LeaPlusLC["TipShowTarget"]
			LeaPlusDB["TipBackSimple"]			= LeaPlusLC["TipBackSimple"]
			LeaPlusDB["TipHideInCombat"]		= LeaPlusLC["TipHideInCombat"]
			LeaPlusDB["LeaPlusTipSize"]			= LeaPlusLC["LeaPlusTipSize"]
			LeaPlusDB["TipOffsetX"]				= LeaPlusLC["TipOffsetX"]
			LeaPlusDB["TipOffsetY"]				= LeaPlusLC["TipOffsetY"]

			LeaPlusDB["EnhanceDressup"]			= LeaPlusLC["EnhanceDressup"]
			LeaPlusDB["ShowVolume"] 			= LeaPlusLC["ShowVolume"]
			LeaPlusDB["ShowVolumeInFrame"] 		= LeaPlusLC["ShowVolumeInFrame"]
			LeaPlusDB["AhExtras"]				= LeaPlusLC["AhExtras"]
			LeaPlusDB["AhBuyoutOnly"]			= LeaPlusLC["AhBuyoutOnly"]
			LeaPlusDB["AhGoldOnly"]				= LeaPlusLC["AhGoldOnly"]

			LeaPlusDB["ShowCooldowns"]			= LeaPlusLC["ShowCooldowns"]
			LeaPlusDB["ShowCooldownID"]			= LeaPlusLC["ShowCooldownID"]
			LeaPlusDB["NoCooldownDuration"]		= LeaPlusLC["NoCooldownDuration"]
			LeaPlusDB["DurabilityStatus"]		= LeaPlusLC["DurabilityStatus"]
			LeaPlusDB["ShowPetSaveBtn"]			= LeaPlusLC["ShowPetSaveBtn"]
			LeaPlusDB["ShowWowheadLinks"]		= LeaPlusLC["ShowWowheadLinks"]

			-- Frames
			LeaPlusDB["FrmEnabled"]				= LeaPlusLC["FrmEnabled"]
			LeaPlusDB["ClassColFrames"]			= LeaPlusLC["ClassColFrames"]
			LeaPlusDB["ShowPlayerChain"]		= LeaPlusLC["ShowPlayerChain"]
			LeaPlusDB["PlayerChainMenu"]		= LeaPlusLC["PlayerChainMenu"]
			LeaPlusDB["ShowRaidToggle"]			= LeaPlusLC["ShowRaidToggle"]
			LeaPlusDB["CombatPlates"]			= LeaPlusLC["CombatPlates"]

			LeaPlusDB["NoAlerts"]				= LeaPlusLC["NoAlerts"]
			LeaPlusDB["HideBodyguard"]			= LeaPlusLC["HideBodyguard"]
			LeaPlusDB["HideTalkingFrame"]		= LeaPlusLC["HideTalkingFrame"]
			LeaPlusDB["HideCleanupBtns"]		= LeaPlusLC["HideCleanupBtns"]
			LeaPlusDB["HideBossBanner"]			= LeaPlusLC["HideBossBanner"]
			LeaPlusDB["HideLevelUpDisplay"]		= LeaPlusLC["HideLevelUpDisplay"]
			LeaPlusDB["NoGryphons"]				= LeaPlusLC["NoGryphons"]
			LeaPlusDB["NoClassBar"]				= LeaPlusLC["NoClassBar"]
			LeaPlusDB["NoCommandBar"]			= LeaPlusLC["NoCommandBar"]

			-- System
			LeaPlusDB["NoScreenGlow"] 			= LeaPlusLC["NoScreenGlow"]
			LeaPlusDB["NoScreenEffects"] 		= LeaPlusLC["NoScreenEffects"]
			LeaPlusDB["MaxCameraZoom"] 			= LeaPlusLC["MaxCameraZoom"]
			LeaPlusDB["ViewPortEnable"]			= LeaPlusLC["ViewPortEnable"]
			LeaPlusDB["ViewPortTop"]			= LeaPlusLC["ViewPortTop"]
			LeaPlusDB["ViewPortBottom"]			= LeaPlusLC["ViewPortBottom"]
			LeaPlusDB["ViewPortLeft"]			= LeaPlusLC["ViewPortLeft"]
			LeaPlusDB["ViewPortRight"]			= LeaPlusLC["ViewPortRight"]
			LeaPlusDB["ViewPortResizeTop"]		= LeaPlusLC["ViewPortResizeTop"]
			LeaPlusDB["ViewPortResizeBottom"]	= LeaPlusLC["ViewPortResizeBottom"]
			LeaPlusDB["ViewPortAlpha"]			= LeaPlusLC["ViewPortAlpha"]

			LeaPlusDB["NoRestedEmotes"]			= LeaPlusLC["NoRestedEmotes"]

			LeaPlusDB["NoBagAutomation"]		= LeaPlusLC["NoBagAutomation"]
			LeaPlusDB["NoPetAutomation"]		= LeaPlusLC["NoPetAutomation"]
			LeaPlusDB["CharAddonList"]			= LeaPlusLC["CharAddonList"]
			LeaPlusDB["NoRaidRestrictions"]		= LeaPlusLC["NoRaidRestrictions"]
			LeaPlusDB["NoConfirmLoot"] 			= LeaPlusLC["NoConfirmLoot"]
			LeaPlusDB["FasterLooting"] 			= LeaPlusLC["FasterLooting"]
			LeaPlusDB["FasterMovieSkip"] 		= LeaPlusLC["FasterMovieSkip"]
			LeaPlusDB["LockoutSharing"] 		= LeaPlusLC["LockoutSharing"]

			-- Settings
			LeaPlusDB["ShowMinimapIcon"] 		= LeaPlusLC["ShowMinimapIcon"]
			LeaPlusDB["EnableHotkey"] 			= LeaPlusLC["EnableHotkey"]

			LeaPlusDB["PlusPanelScale"] 		= LeaPlusLC["PlusPanelScale"]
			LeaPlusDB["PlusPanelAlpha"] 		= LeaPlusLC["PlusPanelAlpha"]

			-- Panel position
			LeaPlusDB["MainPanelA"]				= LeaPlusLC["MainPanelA"]
			LeaPlusDB["MainPanelR"]				= LeaPlusLC["MainPanelR"]
			LeaPlusDB["MainPanelX"]				= LeaPlusLC["MainPanelX"]
			LeaPlusDB["MainPanelY"]				= LeaPlusLC["MainPanelY"]

			-- Start page
			LeaPlusDB["LeaStartPage"]			= LeaPlusLC["LeaStartPage"]

		end

	end

--	Register event handler
	LpEvt:SetScript("OnEvent", eventHandler);

----------------------------------------------------------------------
--	L70: Player logout
----------------------------------------------------------------------

	-- Player Logout
	function LeaPlusLC:PlayerLogout(wipe)

		----------------------------------------------------------------------
		-- Restore default values for options that do not require reloads
		----------------------------------------------------------------------

		-- Disable screen glow (LeaPlusLC["NoScreenGlow"])
		if wipe then

			-- Disable screen glow (LeaPlusLC["NoScreenGlow"])
			SetCVar("ffxGlow", "1")

			-- Disable screen effects (LeaPlusLC["NoScreenEffects"])
			SetCVar("ffxDeath", "1")
			SetCVar("ffxNether", "1")

			-- Remove raid restrictions (LeaPlusLC["NoRaidRestrictions"])
			SetAllowLowLevelRaid(false)

			-- Max camera zoom (LeaPlusLC["MaxCameraZoom"])
			SetCVar("cameraDistanceMaxZoomFactor", 1.9)

			-- Universal group color (LeaPlusLC["UnivGroupColor"])
			ChangeChatColor("RAID", 1, 0.50, 0)
			ChangeChatColor("RAID_LEADER", 1, 0.28, 0.04)
			ChangeChatColor("INSTANCE_CHAT", 1, 0.50, 0)
			ChangeChatColor("INSTANCE_CHAT_LEADER", 1, 0.28, 0.04)

			-- Enable map fade
			SetCVar("mapFade", "1")

		end

		----------------------------------------------------------------------
		-- Restore default values for options that require reloads
		----------------------------------------------------------------------

		-- Silence rested emotes
		if LeaPlusDB["NoRestedEmotes"] == "On" then
			if wipe or (not wipe and LeaPlusLC["NoRestedEmotes"] == "Off") then
				SetCVar("Sound_EnableEmoteSounds", "1")
			end
		end

		----------------------------------------------------------------------
		-- Do other stuff during logout
		----------------------------------------------------------------------

		-- Prevent frame caching if frame customisation is enabled
		if LeaPlusDB["FrmEnabled"] == "On" then
			PlayerFrame:SetUserPlaced(false)
			TargetFrame:SetUserPlaced(false)
		end

		-- Store the auction house duration and price type values if auction house option is enabled
		if LeaPlusDB["AhExtras"] == "On" then
			if AuctionFrameAuctions then
				if AuctionFrameAuctions.duration then
					LeaPlusDB["AHDuration"] = AuctionFrameAuctions.duration
				end
				if AuctionFrameAuctions.priceType then
					LeaPlusDB["AHPriceType"] = AuctionFrameAuctions.priceType
				end
			end
		end

	end

----------------------------------------------------------------------
-- 	Options panel functions
----------------------------------------------------------------------

	-- Function to add textures to panels
	function LeaPlusLC:CreateBar(name, parent, width, height, anchor, r, g, b, alp, tex)
		local ft = parent:CreateTexture(nil, "BORDER")
		ft:SetTexture(tex)
		ft:SetSize(width, height)  
		ft:SetPoint(anchor)
		ft:SetVertexColor(r ,g, b, alp)
		if name == "MainTexture" then
			ft:SetTexCoord(0.09, 1, 0, 1);
		end
	end

	-- Create a configuration panel
	function LeaPlusLC:CreatePanel(title, globref)

		-- Create the panel
		local Side = CreateFrame("Frame", nil, UIParent)

		-- Make it a system frame
		_G["LeaPlusGlobalPanel_" .. globref] = Side
		table.insert(UISpecialFrames, "LeaPlusGlobalPanel_" .. globref)

		-- Store it in the configuration panel table
		tinsert(LeaConfigList, Side)

		-- Set frame parameters
		Side:Hide();
		Side:SetSize(570, 370); 
		Side:SetClampedToScreen(true)
		Side:SetClampRectInsets(500, -500, -300, 300)
		Side:SetFrameStrata("FULLSCREEN_DIALOG")

		-- Set the background color
		Side.t = Side:CreateTexture(nil, "BACKGROUND")
		Side.t:SetAllPoints()
		Side.t:SetColorTexture(0.05, 0.05, 0.05, 0.9)

		-- Add a close Button
		Side.c = CreateFrame("Button", nil, Side, "UIPanelCloseButton") 
		Side.c:SetSize(30, 30)
		Side.c:SetPoint("TOPRIGHT", 0, 0)
		Side.c:SetScript("OnClick", function() Side:Hide() end)

		-- Add reset, help and back buttons
		Side.r = LeaPlusLC:CreateButton("ResetButton", Side, "Reset", "TOPLEFT", 16, -292, 0, 25, true, "Click to reset the settings on this page.")
		Side.h = LeaPlusLC:CreateButton("HelpButton", Side, "Help", "TOPLEFT", 76, -292, 0, 25, true, "No help is available for this page.")
		Side.b = LeaPlusLC:CreateButton("BackButton", Side, "Back to Main Menu", "TOPRIGHT", -16, -292, 0, 25, true, "Click to return to the main menu.")

		-- Reposition help button so it doesn't overlap reset button
		Side.h:ClearAllPoints()
		Side.h:SetPoint("LEFT", Side.r, "RIGHT", 10, 0)

		-- Remove the click texture from the help button
		Side.h:SetPushedTextOffset(0, 0)

		-- Add a reload button and syncronise it with the main panel reload button
		local reloadb = LeaPlusLC:CreateButton("ConfigReload", Side, "Reload", "BOTTOMRIGHT", -16, 10, 0, 25, true, LeaPlusCB["ReloadUIButton"].tiptext)
		LeaPlusLC:LockItem(reloadb,true)
		reloadb:SetScript("OnClick", ReloadUI)

		reloadb.f = reloadb:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
		reloadb.f:SetHeight(32);
		reloadb.f:SetPoint('RIGHT', reloadb, 'LEFT', -10, 0)
		reloadb.f:SetText(LeaPlusCB["ReloadUIButton"].f:GetText())
		reloadb.f:Hide()

		LeaPlusCB["ReloadUIButton"]:HookScript("OnEnable", function()
			LeaPlusLC:LockItem(reloadb, false)
			reloadb.f:Show()
		end)

		LeaPlusCB["ReloadUIButton"]:HookScript("OnDisable", function()
			LeaPlusLC:LockItem(reloadb, true)
			reloadb.f:Hide()
		end)

		-- Set textures
		LeaPlusLC:CreateBar("FootTexture", Side, 570, 48, "BOTTOM", 0.5, 0.5, 0.5, 1.0, "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
		LeaPlusLC:CreateBar("MainTexture", Side, 570, 323, "TOPRIGHT", 0.7, 0.7, 0.7, 0.7,  "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")

		-- Allow movement
		Side:EnableMouse(true)
		Side:SetMovable(true)
		Side:RegisterForDrag("LeftButton")
		Side:SetScript("OnDragStart", Side.StartMoving)
		Side:SetScript("OnDragStop", function ()
			Side:StopMovingOrSizing();
			Side:SetUserPlaced(false);
			-- Save panel position
			LeaPlusLC["MainPanelA"], void, LeaPlusLC["MainPanelR"], LeaPlusLC["MainPanelX"], LeaPlusLC["MainPanelY"] = Side:GetPoint()
		end)

		-- Set panel attributes when shown
		Side:SetScript("OnShow", function()
			Side:ClearAllPoints()
			Side:SetPoint(LeaPlusLC["MainPanelA"], UIParent, LeaPlusLC["MainPanelR"], LeaPlusLC["MainPanelX"], LeaPlusLC["MainPanelY"])
			Side:SetScale(LeaPlusLC["PlusPanelScale"])
			Side.t:SetAlpha(1 - LeaPlusLC["PlusPanelAlpha"])
		end)

		-- Add title
		Side.f = Side:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		Side.f:SetPoint('TOPLEFT', 16, -16);
		Side.f:SetText(L[title])

		-- Add description
		Side.v = Side:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
		Side.v:SetHeight(32);
		Side.v:SetPoint('TOPLEFT', Side.f, 'BOTTOMLEFT', 0, -8); 
		Side.v:SetPoint('RIGHT', Side, -32, 0)
		Side.v:SetJustifyH('LEFT'); Side.v:SetJustifyV('TOP');
		Side.v:SetText(L["Configuration Panel"])
	
		-- Prevent options panel from showing while side panel is showing
		LeaPlusLC["PageF"]:HookScript("OnShow", function()
			if Side:IsShown() then LeaPlusLC["PageF"]:Hide(); end
		end)

		-- Return the frame
		return Side

	end

	-- Define subheadings
	function LeaPlusLC:MakeTx(frame, title, x, y)
		local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		text:SetPoint("TOPLEFT", x, y)
		text:SetText(L[title])
	end

	-- Define text
	function LeaPlusLC:MakeWD(frame, title, x, y)
		local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
		text:SetPoint("TOPLEFT", x, y)
		text:SetText(L[title])
		text:SetJustifyH"LEFT";
	end

	-- Create a slider control (uses standard template)
	function LeaPlusLC:MakeSL(frame, field, caption, low, high, step, x, y, form)

		-- Create slider control
		local Slider = CreateFrame("Slider", "LeaPlusGlobalSlider" .. field, frame, "OptionssliderTemplate")
		LeaPlusCB[field] = Slider;
		Slider:SetMinMaxValues(low, high)
		Slider:SetValueStep(step)
		Slider:EnableMouseWheel(true)
		Slider:SetPoint('TOPLEFT', x,y)
		Slider:SetWidth(100)
		Slider:SetHeight(20)
		Slider:SetHitRectInsets(0, 0, 0, 0);

		-- Remove slider text
		_G[Slider:GetName().."Low"]:SetText('');
		_G[Slider:GetName().."High"]:SetText('');

		-- Create slider label
		Slider.f = Slider:CreateFontString(nil, 'BACKGROUND')
		Slider.f:SetFontObject('GameFontHighlight')
		Slider.f:SetPoint('LEFT', Slider, 'RIGHT', 12, 0)
		Slider.f:SetFormattedText("%.2f", Slider:GetValue())

		-- Process mousewheel scrolling
		Slider:SetScript("OnMouseWheel", function(self, arg1)
			if Slider:IsEnabled() then
				local step = step * arg1
				local value = self:GetValue()
				if step > 0 then
					self:SetValue(min(value + step, high))
				else
					self:SetValue(max(value + step, low))
				end
			end
		end)

		-- Process value changed
		Slider:SetScript("OnValueChanged", function(self, value)
			local value = floor((value - low) / step + 0.5) * step + low
			Slider.f:SetFormattedText(form, value)
			LeaPlusLC[field] = value
		end)

		-- Set slider value when shown
		Slider:SetScript("OnShow", function(self)
			self:SetValue(LeaPlusLC[field])
		end)

	end

	-- Create a checkbox control (uses standard template)
	function LeaPlusLC:MakeCB(parent, field, caption, x, y, reload, tip, tipstyle)

		-- Create the checkbox
		local Cbox = CreateFrame('CheckButton', nil, parent, "ChatConfigCheckButtonTemplate")
		LeaPlusCB[field] = Cbox
		Cbox:SetPoint("TOPLEFT",x, y)
		Cbox:SetScript("OnEnter", LeaPlusLC.TipSee)
		Cbox:SetScript("OnLeave", GameTooltip_Hide)

		-- Add label and tooltip
		Cbox.f = Cbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
		Cbox.f:SetPoint('LEFT', 20, 0)
		if reload then
			-- Checkbox requires UI reload
			Cbox.f:SetText(L[caption] .. "*")
			Cbox.tiptext = L[tip] .. "|n|n* " .. L["Requires UI reload."]
		else
			-- Checkbox does not require UI reload
			Cbox.f:SetText(L[caption])
			Cbox.tiptext = L[tip]
		end

		-- Set label parameters
		Cbox.f:SetJustifyH("LEFT")
		Cbox.f:SetWordWrap(false)

		-- Set maximum label width
		if parent:GetParent() == LeaPlusLC["PageF"] then
			-- Main panel checkbox labels
			if Cbox.f:GetWidth() > 152 then
				Cbox.f:SetWidth(152)
				LeaPlusLC["TruncatedLabelsList"] = LeaPlusLC["TruncatedLabelsList"] or {}
				LeaPlusLC["TruncatedLabelsList"][Cbox.f] = L[caption]
			end
			-- Set checkbox click width
			if Cbox.f:GetStringWidth() > 152 then
				Cbox:SetHitRectInsets(0, -142, 0, 0)
			else
				Cbox:SetHitRectInsets(0, -Cbox.f:GetStringWidth() + 4, 0, 0)
			end
		else
			-- Configuration panel checkbox labels (other checkboxes either have custom functions or blank labels)
			if Cbox.f:GetWidth() > 302 then
				Cbox.f:SetWidth(302)
				LeaPlusLC["TruncatedLabelsList"] = LeaPlusLC["TruncatedLabelsList"] or {}
				LeaPlusLC["TruncatedLabelsList"][Cbox.f] = L[caption]
			end
			-- Set checkbox click width
			if Cbox.f:GetStringWidth() > 302 then
				Cbox:SetHitRectInsets(0, -292, 0, 0)
			else
				Cbox:SetHitRectInsets(0, -Cbox.f:GetStringWidth() + 4, 0, 0)
			end
		end

		-- Set default checkbox state and click area
		Cbox:SetScript('OnShow', function(self)
			if LeaPlusLC[field] == "On" then
				self:SetChecked(true)
			else
				self:SetChecked(false)
			end
		end)

		-- Process clicks
		Cbox:SetScript('OnClick', function()
			if Cbox:GetChecked() then
				LeaPlusLC[field] = "On"
			else
				LeaPlusLC[field] = "Off"
			end
			LeaPlusLC:SetDim(); -- Lock invalid options
			LeaPlusLC:ReloadCheck(); -- Show reload button if needed
			LeaPlusLC:Live(); -- Run live code
		end)
	end

	-- Create an editbox (uses standard template)
	function LeaPlusLC:CreateEditBox(frame, parent, width, maxchars, anchor, x, y, tab, shifttab)

		-- Create editbox
        local eb = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
		LeaPlusCB[frame] = eb
		eb:SetPoint(anchor, x, y)
		eb:SetWidth(width)
		eb:SetHeight(24)
		eb:SetFontObject("GameFontNormal")
		eb:SetTextColor(1.0, 1.0, 1.0)
		eb:SetAutoFocus(false) 
		eb:SetMaxLetters(maxchars) 
		eb:SetScript("OnEscapePressed", eb.ClearFocus)
		eb:SetScript("OnEnterPressed", eb.ClearFocus)

		-- Add editbox border and backdrop
		eb.f = CreateFrame("FRAME", nil, eb)
		eb.f:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = false, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }})
		eb.f:SetPoint("LEFT", -6, 0)
		eb.f:SetWidth(eb:GetWidth()+6)
		eb.f:SetHeight(eb:GetHeight())
		eb.f:SetBackdropColor(1.0, 1.0, 1.0, 0.3)

		-- Move onto next editbox when tab key is pressed
		eb:SetScript("OnTabPressed", function(self)
			self:ClearFocus()
			if IsShiftKeyDown() then
				LeaPlusCB[shifttab]:SetFocus()
			else
				LeaPlusCB[tab]:SetFocus()
			end
		end)

		return eb

	end

	-- Create a standard button (using standard button template)
	function LeaPlusLC:CreateButton(name, frame, label, anchor, x, y, width, height, reskin, tip)
		local mbtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		LeaPlusCB[name] = mbtn
		mbtn:SetSize(width, height)
		mbtn:SetPoint(anchor, x, y)
		mbtn:SetHitRectInsets(0, 0, 0, 0)
		mbtn:SetText(L[label])

		-- Create fontstring so the button can be sized correctly
		mbtn.f = mbtn:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		mbtn.f:SetText(L[label])
		if width > 0 then
			-- Button should have static width
			mbtn:SetWidth(width)
		else
			-- Button should have variable width
			mbtn:SetWidth(mbtn.f:GetStringWidth() + 20)
		end

		-- Tooltip handler
		mbtn.tiptext = L[tip]
		mbtn:SetScript("OnEnter", LeaPlusLC.TipSee)
		mbtn:SetScript("OnLeave", GameTooltip_Hide)

		-- Texture the button
		if reskin then

			-- Set skinned button textures
			mbtn:SetNormalTexture("Interface\\AddOns\\Leatrix_Plus\\Leatrix_Plus.blp")
			mbtn:GetNormalTexture():SetTexCoord(0.5, 1, 0, 1)
			mbtn:SetHighlightTexture("Interface\\AddOns\\Leatrix_Plus\\Leatrix_Plus.blp")
			mbtn:GetHighlightTexture():SetTexCoord(0, 0.5, 0, 1)

			-- Hide the default textures
			mbtn:HookScript("OnShow", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
			mbtn:HookScript("OnEnable", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
			mbtn:HookScript("OnDisable", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
			mbtn:HookScript("OnMouseDown", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
			mbtn:HookScript("OnMouseUp", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)

		end

		return mbtn
	end

	-- Create a dropdown menu (using custom function to avoid taint)
	function LeaPlusLC:CreateDropDown(ddname, label, parent, width, anchor, x, y, items, tip)

		-- Add the dropdown name to a table
		tinsert(LeaDropList, ddname)

		-- Populate variable with item list
		LeaPlusLC[ddname.."Table"] = items

		-- Create outer frame
		local frame = CreateFrame("FRAME", nil, parent); frame:SetWidth(width); frame:SetHeight(42); frame:SetPoint("BOTTOMLEFT", parent, anchor, x, y);

		-- Create dropdown inside outer frame
		local dd = CreateFrame("Frame", nil, frame); dd:SetPoint("BOTTOMLEFT", -16, -8); dd:SetPoint("BOTTOMRIGHT", 15, -4); dd:SetHeight(32);

		-- Create dropdown textures
		local lt = dd:CreateTexture(nil, "ARTWORK"); lt:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame"); lt:SetTexCoord(0, 0.1953125, 0, 1); lt:SetPoint("TOPLEFT", dd, 0, 17); lt:SetWidth(25); lt:SetHeight(64); 
		local rt = dd:CreateTexture(nil, "BORDER"); rt:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame"); rt:SetTexCoord(0.8046875, 1, 0, 1); rt:SetPoint("TOPRIGHT", dd, 0, 17); rt:SetWidth(25); rt:SetHeight(64); 
		local mt = dd:CreateTexture(nil, "BORDER"); mt:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame"); mt:SetTexCoord(0.1953125, 0.8046875, 0, 1); mt:SetPoint("LEFT", lt, "RIGHT"); mt:SetPoint("RIGHT", rt, "LEFT"); mt:SetHeight(64);

		-- Create dropdown label
		local lf = dd:CreateFontString(nil, "OVERLAY", "GameFontNormal"); lf:SetPoint("TOPLEFT", frame, 0, 0); lf:SetPoint("TOPRIGHT", frame, -5, 0); lf:SetJustifyH("LEFT"); lf:SetText(L[label])
	
		-- Create dropdown placeholder for value (set it using OnShow)
		local value = dd:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		value:SetPoint("LEFT", lt, 26, 2); value:SetPoint("RIGHT", rt, -43, 0); value:SetJustifyH("LEFT")
		dd:SetScript("OnShow", function() value:SetText(LeaPlusLC[ddname.."Table"][LeaPlusLC[ddname]]) end)

		-- Create dropdown button (clicking it opens the dropdown list)
		local dbtn = CreateFrame("Button", nil, dd)
		dbtn:SetPoint("TOPRIGHT", rt, -16, -18); dbtn:SetWidth(24); dbtn:SetHeight(24)
		dbtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up"); dbtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down"); dbtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled"); dbtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight"); dbtn:GetHighlightTexture():SetBlendMode("ADD")
		dbtn.tiptext = tip; dbtn:SetScript("OnEnter", LeaPlusLC.ShowTooltip); 
		dbtn:SetScript("OnLeave", GameTooltip_Hide)

		-- Create dropdown list
		local ddlist =  CreateFrame("Frame",nil,frame);
		LeaPlusCB["ListFrame"..ddname] = ddlist;
		ddlist:SetPoint("TOP",0,-42);
		ddlist:SetWidth(frame:GetWidth());
		ddlist:SetHeight((#items * 17) + 17 + 17);
		ddlist:SetFrameStrata("FULLSCREEN_DIALOG");
		ddlist:SetFrameLevel(12);
		ddlist:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = false, tileSize = 0, edgeSize = 32, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
		ddlist:Hide();

		-- Hide list if parent is closed
		parent:HookScript("OnHide", function() ddlist:Hide() end)

		-- Create checkmark (it marks the currently selected item)
		local ddlistchk = CreateFrame("FRAME", nil, ddlist)
		ddlistchk:SetHeight(16); ddlistchk:SetWidth(16);
		ddlistchk.t = ddlistchk:CreateTexture(nil, "ARTWORK"); ddlistchk.t:SetAllPoints(); ddlistchk.t:SetTexture("Interface\\Common\\UI-DropDownRadioChecks"); ddlistchk.t:SetTexCoord(0, 0.5, 0.5, 1.0);

		-- Create dropdown list items
		for k, v in pairs(items) do

			local dditem = CreateFrame("Button", nil, LeaPlusCB["ListFrame"..ddname])
			LeaPlusCB["Drop"..ddname..k] = dditem;
			dditem:Show();
			dditem:SetWidth(ddlist:GetWidth()-22)
			dditem:SetHeight(20)
			dditem:SetPoint("TOPLEFT", 12, -k*16)

			dditem.f = dditem:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight'); 
			dditem.f:SetPoint('LEFT', 16, 0)
			dditem.f:SetText(items[k])

			dditem.t = dditem:CreateTexture(nil, "BACKGROUND")
			dditem.t:SetAllPoints()
			dditem.t:SetColorTexture(0.3, 0.3, 0.00, 0.8)
			dditem.t:Hide();

			dditem:SetScript("OnEnter", function() dditem.t:Show() end)
			dditem:SetScript("OnLeave", function() dditem.t:Hide() end)
			dditem:SetScript("OnClick", function()
				LeaPlusLC[ddname] = k
				value:SetText(LeaPlusLC[ddname.."Table"][k])
				ddlist:Hide(); -- Must be last in click handler as other functions hook it
			end)

			-- Show list when button is clicked
			dbtn:SetScript("OnClick", function()
				-- Show the dropdown
				if ddlist:IsShown() then ddlist:Hide() else 
					ddlist:Show();
					ddlistchk:SetPoint("TOPLEFT",10,select(5,LeaPlusCB["Drop"..ddname..LeaPlusLC[ddname]]:GetPoint()))
					ddlistchk:Show();
				end;
				-- Hide all other dropdowns except the one we're dealing with
				for void,v in pairs(LeaDropList) do
					if v ~= ddname then
						LeaPlusCB["ListFrame"..v]:Hide();
					end
				end
			end)

			-- Expand the clickable area of the button to include the entire menu width
			dbtn:SetHitRectInsets(-width+28, 0, 0, 0);

		end

		return frame
		
	end
	
----------------------------------------------------------------------
-- 	Create main options panel frame
----------------------------------------------------------------------

	function LeaPlusLC:CreateMainPanel()

		-- Create the panel
		local PageF = CreateFrame("Frame", nil, UIParent);

		-- Make it a system frame
		_G["LeaPlusGlobalPanel"] = PageF
		table.insert(UISpecialFrames, "LeaPlusGlobalPanel")

		-- Set frame parameters
		LeaPlusLC["PageF"] = PageF
		PageF:SetSize(570,370)
		PageF:Hide();
		PageF:SetFrameStrata("FULLSCREEN_DIALOG")
		PageF:SetClampedToScreen(true)
		PageF:SetClampRectInsets(500, -500, -300, 300)
		PageF:EnableMouse(true)
		PageF:SetMovable(true)
		PageF:RegisterForDrag("LeftButton")
		PageF:SetScript("OnDragStart", PageF.StartMoving)
		PageF:SetScript("OnDragStop", function ()
			PageF:StopMovingOrSizing();
			PageF:SetUserPlaced(false);
			-- Save panel position
			LeaPlusLC["MainPanelA"], void, LeaPlusLC["MainPanelR"], LeaPlusLC["MainPanelX"], LeaPlusLC["MainPanelY"] = PageF:GetPoint()
		end)

		-- Add background color
		PageF.t = PageF:CreateTexture(nil, "BACKGROUND")
		PageF.t:SetAllPoints()
		PageF.t:SetColorTexture(0.05, 0.05, 0.05, 0.9)

		-- Add textures
		LeaPlusLC:CreateBar("FootTexture", PageF, 570, 48, "BOTTOM", 0.5, 0.5, 0.5, 1.0, "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
		LeaPlusLC:CreateBar("MainTexture", PageF, 440, 323, "TOPRIGHT", 0.7, 0.7, 0.7, 0.7,  "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
		LeaPlusLC:CreateBar("MenuTexture", PageF, 130, 323, "TOPLEFT", 0.7, 0.7, 0.7, 0.7, "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")

		-- Set panel position when shown
		PageF:SetScript("OnShow", function()
			PageF:ClearAllPoints()
			PageF:SetPoint(LeaPlusLC["MainPanelA"], UIParent, LeaPlusLC["MainPanelR"], LeaPlusLC["MainPanelX"], LeaPlusLC["MainPanelY"])
		end)

		-- Add main title (shown above menu in the corner)
		PageF.mt = PageF:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		PageF.mt:SetPoint('TOPLEFT', 16, -16)
		PageF.mt:SetText("Leatrix Plus")

		-- Add version text (shown underneath main title)
		PageF.v = PageF:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
		PageF.v:SetHeight(32);
		PageF.v:SetPoint('TOPLEFT', PageF.mt, 'BOTTOMLEFT', 0, -8); 
		PageF.v:SetPoint('RIGHT', PageF, -32, 0)
		PageF.v:SetJustifyH('LEFT'); PageF.v:SetJustifyV('TOP');
		PageF.v:SetNonSpaceWrap(true); PageF.v:SetText(L["Version"] .. " " .. LeaPlusLC["AddonVer"])

		-- Add reload UI Button
		local reloadb = LeaPlusLC:CreateButton("ReloadUIButton", PageF, "Reload", "BOTTOMRIGHT", -16, 10, 0, 25, true, "Your UI needs to be reloaded for some of the changes to take effect.|n|nYou don't have to click the reload button immediately but you do need to click it when you are done making changes and you want the changes to take effect.")
		LeaPlusLC:LockItem(reloadb,true)
		reloadb:SetScript("OnClick", ReloadUI)

		reloadb.f = reloadb:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
		reloadb.f:SetHeight(32);
		reloadb.f:SetPoint('RIGHT', reloadb, 'LEFT', -10, 0)
		reloadb.f:SetText(L["Your UI needs to be reloaded."])
		reloadb.f:Hide()

		-- Add close Button
		local CloseB = CreateFrame("Button", nil, PageF, "UIPanelCloseButton") 
		CloseB:SetSize(30, 30)
		CloseB:SetPoint("TOPRIGHT", 0, 0)
		CloseB:SetScript("OnClick", LeaPlusLC.HideFrames) 

		-- Release memory
		LeaPlusLC.CreateMainPanel = nil

	end

	LeaPlusLC:CreateMainPanel();

----------------------------------------------------------------------
-- 	L80: Commands 
----------------------------------------------------------------------

	-- Slash command function
	function LeaPlusLC:SlashFunc(str)
		if str and str ~= "" then
			-- Get parameters in lower case with duplicate spaces removed
			local str, arg1, arg2, arg3 = strsplit(" ", string.lower(str:gsub("%s+", " ")))
			-- Traverse parameters
			if str == "wipe" then
				-- Wipe settings
				LeaPlusLC:PlayerLogout(true) -- Run logout function with wipe parameter
				wipe(LeaPlusDB)
				LpEvt:UnregisterAllEvents(); -- Don't save any settings
				ReloadUI();
			elseif str == "nosave" then
				-- Prevent Leatrix Plus from overwriting LeaPlusDB at next logout
				LpEvt:UnregisterEvent("PLAYER_LOGOUT")
				LeaPlusLC:Print("Leatrix Plus will not overwrite LeaPlusDB at next logout.")
				return
			elseif str == "reset" then
				-- Reset panel positions
				LeaPlusLC["MainPanelA"], LeaPlusLC["MainPanelR"], LeaPlusLC["MainPanelX"], LeaPlusLC["MainPanelY"] = "CENTER", "CENTER", 0, 0
				LeaPlusLC["PlusPanelScale"] = 1
				LeaPlusLC["PlusPanelAlpha"] = 0
				LeaPlusLC["PageF"]:SetScale(1)
				LeaPlusLC["PageF"].t:SetAlpha(1 - LeaPlusLC["PlusPanelAlpha"])
				-- Refresh panels
				LeaPlusLC["PageF"]:ClearAllPoints()
				LeaPlusLC["PageF"]:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
				-- Reset currently showing configuration panel
				for k, v in pairs(LeaConfigList) do 
					if v:IsShown() then
						v:ClearAllPoints()
						v:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
						v:SetScale(1)
						v.t:SetAlpha(1 - LeaPlusLC["PlusPanelAlpha"])
					end
				end
				-- Refresh Leatrix Plus settings menu only
				if LeaPlusLC["Page8"]:IsShown() then
					LeaPlusLC["Page8"]:Hide()
					LeaPlusLC["Page8"]:Show()
				end
			elseif str == "hk" then
				-- Print lifetime honorable kills
				local chagmsg = L["Lifetime honorable kills"]
				local ltphk = GetStatistic(588)
				if ltphk == "--" then ltphk = "0" end
				chagmsg = chagmsg .. ": |cffffffff" .. ltphk
				LeaPlusLC:Print(chagmsg)
				return
			elseif str == "taint" then
				-- Set taint log level
				if arg1 and arg1 ~= "" then
					arg1 = tonumber(arg1)
					if arg1 and arg1 >= 0 and arg1 <= 2 then
						if arg1 == 0 then
							-- Disable taint log
							ConsoleExec("taintLog 0")
							LeaPlusLC:Print("Taint level: Disabled (0).")
						elseif arg1 == 1 then
							-- Basic taint log
							ConsoleExec("taintLog 1")
							LeaPlusLC:Print("Taint level: Basic (1).")
						elseif arg1 == 2 then
							-- Full taint log
							ConsoleExec("taintLog 2")
							LeaPlusLC:Print("Taint level: Full (2).")
						end
					else
 						LeaPlusLC:Print("Invalid taint level.")
					end
				else
					-- Show current taint level
					local taintCurrent = GetCVar("taintLog")
					if taintCurrent == "0" then
						LeaPlusLC:Print("Taint level: Disabled (0).")
					elseif taintCurrent == "1" then
						LeaPlusLC:Print("Taint level: Basic (1).")
					elseif taintCurrent == "2" then
						LeaPlusLC:Print("Taint level: Full (2).")
					end
				end
				return
			elseif str == "quest" then
				-- Show quest completed status
				if arg1 and arg1 ~= "" then
					if tonumber(arg1) then
						local questCompleted = IsQuestFlaggedCompleted(arg1)
						if questCompleted then
							LeaPlusLC:Print(arg1 .. ": " .. L["Quest completed."])
						else
							LeaPlusLC:Print(arg1 .. ": " .. L["Quest not completed."])
						end
					else
						LeaPlusLC:Print("Invalid quest ID.")
					end
				else
					LeaPlusLC:Print("Missing quest ID.")
				end
				return
			elseif str == "gstaff" then
				-- Buy 10 x Rough Wooden Staff from Larana Drome in Scribes' Sacellum, Dalaran, Northrend (used for testing)
				local npcName = UnitName("target")
				local npcGuid = UnitGUID("target") or nil
				local errmsg = "Requires you to be interacting with Larana Drome.  She can be found at Scribes' Sacellum, Dalaran, Northrend."
				if npcName and npcGuid then
					local void, void, void, void, void, npcID = strsplit("-", npcGuid)
					if npcID and npcID == "28723" then
						for k = 1, 10 do
							BuyMerchantItem(5)
						end
					else
						LeaPlusLC:Print(errmsg)
					end
				else
					LeaPlusLC:Print(errmsg)
				end
				return
			elseif str == "rest" then
				-- Show rested bubbles
				LeaPlusLC:Print(L["Rested bubbles"] .. ": |cffffffff" .. (math.floor(20 * (GetXPExhaustion() or 0) / UnitXPMax("player") + 0.5)))
				return
			elseif str == "zygor" then
				-- Toggle Zygor addon
				LeaPlusLC:ZygorToggle()
				return
			elseif str == "id" then
				-- Print NPC ID
				local npcName = UnitName("target")
				local npcGuid = UnitGUID("target") or nil
				if npcName and npcGuid then
					local void, void, void, void, void, npcID = strsplit("-", npcGuid)
					if npcID then
						LeaPlusLC:Print(npcName .. ": |cffffffff" .. npcID)
					end
				end
				return
			elseif str == "mountid" then
				-- Get mount ID by mount name
				if not arg1 or arg1 == "" then LeaPlusLC:Print("Missing mount name.") return end
				local mounts = C_MountJournal.GetMountIDs()
				local mountSuccess = false
				for i = 1, #mounts do
					local creatureName, spellID, icon, active, isUsable, sourceType = C_MountJournal.GetMountInfoByID(mounts[i])
					if strfind(strlower(creatureName), strlower(arg1)) then
						LeaPlusLC:Print(creatureName .. ": |cffffffff" .. mounts[i] .. "|r")
						mountSuccess = true
					end
				end
				if not mountSuccess then LeaPlusLC:Print("Mount not found.") end
				return
			elseif str == "petid" then
				-- Get pet ID by pet name
				if not arg1 or arg1 == "" then LeaPlusLC:Print("Missing pet name.") return end
				local numPets = C_PetJournal.GetNumPets()
				local petSuccess = false
				for i = 1, numPets do
					local petID, speciesID, isOwned, customName, level, favorite, isRevoked, name, icon, petType, creatureID, sourceText, description, isWildPet, canBattle, tradable, unique = C_PetJournal.GetPetInfoByIndex(i, false)
					if strfind(strlower(name), strlower(arg1)) then
						if isOwned then
							LeaPlusLC:Print(name .. ": |cffffffff" .. petID .. " |cff00ff00(" .. level .. ")|r")
							petSuccess = true
						elseif not petSuccess then
							LeaPlusLC:Print("You do not own this pet.  Only owned pets can be searched.")
							return
						end
					end
				end
				if not petSuccess then
					LeaPlusLC:Print("Pet not found.  Only owned pets that are currently showing in the journal can be searched.")
				end
				return
			elseif str == "tooltip" then
				-- Print tooltip frame name
				local enumf = EnumerateFrames()
				while enumf do
					if (enumf:GetObjectType() == "GameTooltip" or strfind((enumf:GetName() or ""):lower(),"tip")) and enumf:IsVisible() and enumf:GetPoint() then
						print(enumf:GetName())
					end 
					enumf = EnumerateFrames(enumf)
				end
				collectgarbage()
				return
			elseif str == "soil" then
				-- Enable dark soil scanning
				if not LeaPlusLC["DarkScriptlEnabled"] then
					GameTooltip:HookScript("OnUpdate", function() 
						local a = _G["GameTooltipTextLeft1"]:GetText() or "" 
						if a == "Dark Soil" then
							PlaySound(8959)
						end
					end)
					LeaPlusLC["DarkScriptlEnabled"] = true
					LeaPlusLC:Print("Dark Soil scanning activated.  Reload UI to exit.")
				else
					LeaPlusLC:Print("Dark Soil scanning is already activated.  You only need to run this once.  Reload UI to exit.")
				end
				return
			elseif str == "rsnd" then
				-- Restart sound system
				if LeaPlusCB["StopMusicBtn"] then LeaPlusCB["StopMusicBtn"]:Click() end 
				Sound_GameSystem_RestartSoundSystem()
				LeaPlusLC:Print("Sound system restarted.")
				return
			elseif str == "event" then
				-- List events (used for debug)
				LeaPlusLC["DbF"] = LeaPlusLC["DbF"] or CreateFrame("FRAME")
				if not LeaPlusLC["DbF"]:GetScript("OnEvent") then
					LeaPlusLC:Print("Tracing started.")
					LeaPlusLC["DbF"]:RegisterAllEvents()
					LeaPlusLC["DbF"]:SetScript("OnEvent", function(self, event)
						if event == "ACTIONBAR_UPDATE_COOLDOWN"
						or event == "BAG_UPDATE_COOLDOWN"
						or event == "CHAT_MSG_TRADESKILLS"
						or event == "COMBAT_LOG_EVENT_UNFILTERED"
						or event == "SPELL_UPDATE_COOLDOWN"
						or event == "SPELL_UPDATE_USABLE"
						or event == "UNIT_POWER_FREQUENT"
						or event == "UPDATE_INVENTORY_DURABILITY"
						then return
						else
							print(event)
						end
					end)
				else
					LeaPlusLC["DbF"]:UnregisterAllEvents()
					LeaPlusLC["DbF"]:SetScript("OnEvent", nil)
					LeaPlusLC:Print("Tracing stopped.")
				end
				return
			elseif str == "config" then
				-- Show maximum camera distance
				LeaPlusLC:Print(L["Camera distance"] .. ": |cffffffff" .. GetCVar("cameraDistanceMaxZoomFactor"))
				-- Show screen effects
				LeaPlusLC:Print(L["Shaders"] .. ": |cffffffff" .. GetCVar("ffxGlow") .. ", " .. GetCVar("ffxDeath") .. ", " .. GetCVar("ffxNether"))
				-- Show particle density
				LeaPlusLC:Print(L["Particle density"] .. ": |cffffffff" .. GetCVar("particleDensity"))
				LeaPlusLC:Print(L["Weather density"] .. ": |cffffffff" .. GetCVar("weatherDensity"))
				-- Show config
				LeaPlusLC:Print("SynchroniseConfig: |cffffffff" .. GetCVar("synchronizeConfig"))
				-- Show raid restrictions
				local unRaid = GetAllowLowLevelRaid()
				if unRaid and unRaid == true then
					LeaPlusLC:Print("GetAllowLowLevelRaid: |cffffffff" .. "True")
				else
					LeaPlusLC:Print("GetAllowLowLevelRaid: |cffffffff" .. "False")
				end
				-- Show achievement sharing
				local achhidden = AreAccountAchievementsHidden()
				if achhidden then
					LeaPlusLC:Print("Account achievements are hidden.")
				else
					LeaPlusLC:Print("Account achievements are being shared.")
				end
				return
			elseif str == "move" then
				-- Move minimap
				MinimapZoneTextButton:Hide()
				MinimapBorderTop:SetTexture("")
				MiniMapWorldMapButton:Hide()
				MinimapBackdrop:ClearAllPoints()
				MinimapBackdrop:SetPoint("CENTER", UIParent, "CENTER", -330, -75)
				Minimap:SetPoint("CENTER", UIParent, "CENTER", -320, -50)
				return
			elseif str == "tipcol" then
				-- Show default tooltip title color
				if GameTooltipTextLeft1:IsShown() then
					local r, g, b, a = GameTooltipTextLeft1:GetTextColor()
					r = r <= 1 and r >= 0 and r or 0
					g = g <= 1 and g >= 0 and g or 0
					b = b <= 1 and b >= 0 and b or 0
					LeaPlusLC:Print(L["Tooltip title color"] .. ": " .. strupper(string.format("%02x%02x%02x", r * 255, g * 255, b * 255) .. "."))
				else
					LeaPlusLC:Print("No tooltip showing.")
				end
				return
			elseif str == "list" then
				-- Enumerate frames
				local frame = EnumerateFrames()
				while frame do 
					if (frame:IsVisible() and MouseIsOver(frame)) then 
						LeaPlusLC:Print(frame:GetName() or string.format("[Unnamed Frame: %s]", tostring(frame)))
					end 
					frame = EnumerateFrames(frame) 
				end
				return
			elseif str == "nohelp" then
				-- Set most help plates to seen
				for i = 1, 100 do
					SetCVarBitfield("closedInfoFrames", i, true)
				end
				TalentMicroButtonAlert:Hide()
				TalentMicroButtonAlert:HookScript("OnShow", TalentMicroButtonAlert.Hide)
				return
			elseif str == "grid" then
				-- Create grid for first use
				if not LeaPlusLC.grid then
					LeaPlusLC.grid = CreateFrame('FRAME') 
					LeaPlusLC.grid:Hide()
					LeaPlusLC.grid:SetAllPoints(UIParent)
					local w, h = GetScreenWidth() * UIParent:GetEffectiveScale(), GetScreenHeight() * UIParent:GetEffectiveScale()
					local ratio = w / h
					local sqsize = w / 20
					local wline = floor(sqsize - (sqsize % 2))
					local hline = floor(sqsize / ratio - ((sqsize / ratio) % 2))
					-- Plot vertical lines
					for i = 0, wline do
						local t = LeaPlusLC.grid:CreateTexture(nil, 'BACKGROUND')
						if i == wline / 2 then t:SetColorTexture(1, 0, 0, 0.5) else t:SetColorTexture(0, 0, 0, 0.5) end
						t:SetPoint('TOPLEFT', LeaPlusLC.grid, 'TOPLEFT', i * w / wline - 1, 0)
						t:SetPoint('BOTTOMRIGHT', LeaPlusLC.grid, 'BOTTOMLEFT', i * w / wline + 1, 0)
					end
					-- Plot horizontal lines
					for i = 0, hline do
						local t = LeaPlusLC.grid:CreateTexture(nil, 'BACKGROUND')
						if i == hline / 2 then	t:SetColorTexture(1, 0, 0, 0.5) else t:SetColorTexture(0, 0, 0, 0.5) end
						t:SetPoint('TOPLEFT', LeaPlusLC.grid, 'TOPLEFT', 0, -i * h / hline + 1)
						t:SetPoint('BOTTOMRIGHT', LeaPlusLC.grid, 'TOPRIGHT', 0, -i * h / hline - 1)
					end	
				end
				-- Show or hide grid
				if LeaPlusLC.grid:IsShown() then
					LeaPlusLC.grid:Hide()
				else
					LeaPlusLC.grid:Show()
				end
				return
			elseif str == "chk" then
				-- List truncated checkbox labels
				if LeaPlusLC["TruncatedLabelsList"] then
					for i, v in pairs(LeaPlusLC["TruncatedLabelsList"]) do
						LeaPlusLC:Print(LeaPlusLC["TruncatedLabelsList"][i])
					end
				else
					LeaPlusLC:Print("Checkbox labels are Ok.")
				end
				return
			elseif str == "cv" then
				-- Print and set console variable setting
				if arg1 and arg1 ~= "" then
					if GetCVar(arg1) then
						if arg2 and arg2 ~= ""  then
							if tonumber(arg2) then
								SetCVar(arg1, arg2)
							else
								LeaPlusLC:Print("Value must be a number.")
								return
							end
						end
						LeaPlusLC:Print(arg1 .. ": |cffffffff" .. GetCVar(arg1))
					else
						LeaPlusLC:Print("Invalid console variable.")
					end
				else
					LeaPlusLC:Print("Missing console variable.")
				end
				return
			elseif str == "play" then
				-- Play sound ID
				if arg1 and arg1 ~= "" then
					if tonumber(arg1) then
						-- Stop last played sound ID
						if LeaPlusLC.SNDcanitHandle then
							StopSound(LeaPlusLC.SNDcanitHandle)
						end
						-- Play sound ID
						LeaPlusLC.SNDcanitPlay, LeaPlusLC.SNDcanitHandle = PlaySound(arg1, "Master", false, false)
						if not LeaPlusLC.SNDcanitPlay then LeaPlusLC:Print(L["Invalid sound ID"] .. ": |cffffffff" .. arg1) end
					else
						LeaPlusLC:Print(L["Invalid sound ID"] .. ": |cffffffff" .. arg1)
					end
				else
					LeaPlusLC:Print("Missing sound ID.")
				end
				return
			elseif str == "stop" then
				-- Stop last played sound ID
				if LeaPlusLC.SNDcanitHandle then
					StopSound(LeaPlusLC.SNDcanitHandle)
				end
				return
			elseif str == "team" then
				-- Assign battle pet team
				local p1, s1p1, s1p2, s1p3, p2, s2p1, s2p2, s2p3, p3, s3p1, s3p2, s3p3 = strsplit(",", arg1 or "", 12)
				if p1 and s1p1 and s1p2 and s1p3 and p2 and s2p1 and s2p2 and s2p3 and p3 and s3p1 and s3p2 and s3p3 then
					if LeaPlusLC:PlayerInCombat() then
						return
					else
						-- Ensure all 3 slots are unlocked
						for i = 1, 3 do
							local void, void, void, void, isLocked = C_PetJournal.GetPetLoadOutInfo(i)
							if isLocked and isLocked == true then
								LeaPlusLC:Print("All 3 battle pet slots need to be unlocked.")
								return
							end
						end
						-- Assign pets
						C_PetJournal.SetPetLoadOutInfo(1, p1)
						C_PetJournal.SetAbility(1, 1, s1p1)
						C_PetJournal.SetAbility(1, 2, s1p2)
						C_PetJournal.SetAbility(1, 3, s1p3)
						C_PetJournal.SetPetLoadOutInfo(2, p2)
						C_PetJournal.SetAbility(2, 1, s2p1)
						C_PetJournal.SetAbility(2, 2, s2p2)
						C_PetJournal.SetAbility(2, 3, s2p3)
						C_PetJournal.SetPetLoadOutInfo(3, p3)
						C_PetJournal.SetAbility(3, 1, s3p1)
						C_PetJournal.SetAbility(3, 2, s3p2)
						C_PetJournal.SetAbility(3, 3, s3p3)
						if PetJournal and PetJournal:IsShown() then
							PetJournal_UpdatePetLoadOut()
						end
					end
				else
					LeaPlusLC:Print("Invalid battle pet team parameter.")
				end
				return
			elseif str == "wipecds" then
				-- Wipe cooldowns
				LeaPlusDB["Cooldowns"] = nil
				ReloadUI()
				return
			elseif str == "tipchat" then
				-- Print tooltip contents in chat
				local numLines = GameTooltip:NumLines()
				if numLines then
					for i = 1, numLines do
						print(_G["GameTooltipTextLeft" .. i]:GetText() or "")
					end
				end
				return
			elseif str == "tiplang" then
				-- Tooltip tag locale code constructor
				local msg = ""
				msg = msg .. 'if GameLocale == "' .. GameLocale .. '" then '
				msg = msg .. 'ttLevel = "' .. LEVEL .. '"; '
				msg = msg .. 'ttBoss = "' .. BOSS .. '"; '
				msg = msg .. 'ttElite = "' .. ELITE .. '"; '
				msg = msg .. 'ttRare = "' .. ITEM_QUALITY3_DESC .. '"; '
				msg = msg .. 'ttRareElite = "' .. ITEM_QUALITY3_DESC .. " " .. ELITE .. '"; '
				msg = msg .. 'ttRareBoss = "' .. ITEM_QUALITY3_DESC .. " " .. BOSS .. '"; '
				msg = msg .. 'ttTarget = "' .. TARGET .. '"; '
				msg = msg .. "end"
				print(msg)
				return
			elseif str == "con" then
				-- Show the developer console
				C_Console.SetFontHeight(28)
				DeveloperConsole:Toggle(true)
				return
			elseif str == "movlist" then
				-- List playable movie IDs
				local count = 0
				for i = 1, 1000 do
					if IsMoviePlayable(i) then
						print(i)
						count = count + 1
					end
				end
				LeaPlusLC:Print("Total movies: |cffffffff" .. count)
				return
			elseif str == "movie" then
				-- Playback movie by ID
				arg1 = tonumber(arg1)
				if arg1 and arg1 ~= "" then
					if IsMoviePlayable(arg1) then
						MovieFrame_PlayMovie(MovieFrame, arg1)
					else
						LeaPlusLC:Print("Movie not playable.")
					end
				else
					LeaPlusLC:Print("Missing movie ID.")
				end
				return
			elseif str == "cin" then
				-- Play opening cinematic (only works if character has never gained XP) (used for testing)
				OpeningCinematic()
				return
			elseif str == "skit" then
				-- Play a test sound kit
				PlaySound("1020", "Master", false, true)
				return
			elseif str == "dup" then
				-- Print music track duplicates 
				local mask, found, badidfound = false, false, false
				for i, e in pairs(LeaPlusLC.ZoneList) do
					if LeaPlusLC.ZoneList[e] then
						for a, b in pairs(LeaPlusLC.ZoneList[e]) do
							local same = {}
							if b.tracks then
								for k, v in pairs(b.tracks) do
									-- Check for bad sound IDs
									if not strfind(v, "|c") then
										local temFile, temSoundID = v:match("([^,]+)%#([^,]+)")
										if temSoundID then
											local temPlay, temHandle = PlaySound(temSoundID, "Master", false, true)
											if temHandle then StopSound(temHandle) end
											temPlay, temHandle = PlaySound(temSoundID, "Master", false, true)
											if not temPlay and not temHandle then
												print("|cffff5400" .. L["Bad ID"] .. ": |r" .. e, v)
												badidfound = true
											else
												if temHandle then StopSound(temHandle) end
											end
										end

										-- Check for duplicate IDs
										if tContains(same, v) and mask == false then 
											mask = true
											found = true
											print("|cffec51ff" .. L["Dup ID"] .. ": |r" .. e, v)
										end
										tinsert(same, v)
										mask = false
									end
								end
							end
						end
					end
				end
				if badidfound == false then 
					LeaPlusLC:Print("No bad sound IDs found.") 
				end
				if found == false then 
					LeaPlusLC:Print("No media duplicates found.") 
				end
				Sound_GameSystem_RestartSoundSystem()
				collectgarbage()
				return
			elseif str == "enigma" then
				-- Enigma
				if not LeaPlusLC.enimgaFrame then
					local selectedBtn
					local bt = {}
					local eData = {
						{[9]=1, [10]=1, [11]=1, [12]=1, [13]=1, [20]=1, [23]=1, [24]=1, [25]=1, [26]=1, [27]=1, [30]=1, [37]=1, [38]=1, [39]=1, [40]=1, [41]=2, "L4, U2, R4, U2, L4",},
						{[9]=1, [11]=1, [12]=1, [13]=1, [16]=1, [18]=1, [20]=1, [23]=1, [24]=1, [25]=1, [27]=1, [34]=1, [41]=2, "U4, L2, D2, L2, U2",},
						{[9]=1, [10]=1, [11]=1, [12]=1, [19]=1, [25]=1, [26]=1, [32]=1, [39]=1, [40]=1, [41]=2, "L2, U2, R1, U2, L3",},
						{[9]=1, [10]=1, [11]=1, [18]=1, [23]=1, [24]=1, [25]=1, [30]=1, [37]=1, [38]=1, [39]=1, [40]=1, [41]=2, "L4, U2, R2, U2, L2",},
						{[9]=1, [10]=1, [11]=1, [12]=1, [13]=1, [16]=1, [23]=1, [25]=1, [26]=1, [27]=1, [30]=1, [32]=1, [34]=1, [37]=1, [38]=1, [39]=1, [41]=2, "U2, L2, D2, L2, U4, R4",},
						{[12]=1,[13]=1, [18]=1, [19]=1, [25]=1, [32]=1, [33]=1, [40]=1, [41]=2, "L1, U1, L1, U2, R1, U1, R1",},
						{[9]=1, [11]=1, [12]=1, [13]=1, [16]=1, [18]=1, [20]=1, [23]=1, [25]=1, [27]=1, [30]=1, [31]=1, [32]=1, [34]=1, [41]=2, "U4, L2, D3, L2, U3",},
						{[9]=1, [10]=1, [17]=1, [24]=1, [25]=1, [32]=1, [33]=1, [40]=1, [41]=2, "L1, U1, L1, U1, L1, U2, L1",},
						{[9]=1, [16]=1, [17]=1, [18]=1, [19]=1, [20]=1, [27]=1, [34]=1, [41]=2, "U3, L4, U1",},
						{[9]=1, [10]=1, [11]=1, [12]=1, [13]=1, [16]=1, [23]=1, [24]=1, [25]=1, [26]=1, [33]=1, [40]=1, [41]=2, "L1, U2, L3, U2, R4",},
						{[9]=1, [10]=1, [11]=1, [12]=1, [13]=1, [16]=1, [23]=1, [30]=1, [37]=1, [38]=1, [39]=1, [40]=1, [41]=2, "L4, U4, R4",},
						{[11]=1,[12]=1, [13]=1, [18]=1, [23]=1, [24]=1, [25]=1, [30]=1, [37]=1, [38]=1, [39]=1, [40]=1, [41]=2, "L4, U2, R2, U2, R2",},
						{[13]=1,[20]=1, [23]=1, [24]=1, [25]=1, [26]=1, [27]=1, [30]=1, [37]=1, [38]=1, [39]=1, [40]=1, [41]=2, "L4, U2, R4, U2",},
					}
					-- Create frame
					local eFrame = CreateFrame("Frame", nil, UIParent)
					eFrame:SetPoint("TOP", 0, 0)
					eFrame:SetSize(1222, 134)
					eFrame.b = eFrame:CreateTexture(nil, "BACKGROUND")
					eFrame.b:SetAllPoints()
					eFrame.b:SetColorTexture(0, 0, 0, 1)
					eFrame:SetFrameStrata("FULLSCREEN_DIALOG")
					eFrame:SetScale(0.9)
					eFrame:SetToplevel(true)
					eFrame:EnableMouse(true)
					LeaPlusLC.enimgaFrame = eFrame

					-- Right-click to exit
					eFrame:SetScript("OnMouseDown", function(self, btn)
						if btn == "RightButton" then
							eFrame:Hide()
						end
					end)

					-- Create title fontstring
					eFrame.f = eFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge") 
					eFrame.f:SetPoint("BOTTOMLEFT", 10, 10)
					eFrame.f:SetText(L["Choose an Enigma pattern"])
					eFrame.f:SetFont(eFrame.f:GetFont(), 24, nil)

					-- Create close fontstring
					eFrame.x = eFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge") 
					eFrame.x:SetPoint("BOTTOMRIGHT", -10, 10)
					eFrame.x:SetText(L["Right-click to close"])
					eFrame.x:SetFont(eFrame.f:GetFont(), 24, nil)

					-- Create buttons
					for eBtn = 1, #eData do
						local b = CreateFrame("Button", nil, eFrame)
						tinsert(bt, b)
						b:SetSize(94, 94)
						b:SetPoint("TOPLEFT", ((eBtn - 1) % 13) * 94, -2)

						-- Button highlight bar
						b.line = b:CreateTexture(nil, "ARTWORK")
						b.line:SetTexture("Interface\\PLAYERFRAME\\DruidLunarBarHorizontal")
						b.line:SetSize(84, 6)
						b.line:SetPoint("BOTTOM", 0, -4)
						b.line:Hide()

						-- Button textures
						for row = 0, 7 - 1 do
							for col = 0, 7 - 1 do
								local t = b:CreateTexture(nil, "ARTWORK")
								t:SetSize(12, 12)
								t:SetPoint("TOPLEFT", 5 + col * 12, - 5 - row * 12)
								local c = eData[eBtn][row * 7 + col + 1]
								-- Do nothing if element is the solution
								if c and strfind(c, ",") then c = nil end
								-- Color textures
								if c == 2 then
									-- Starting block
									t:SetColorTexture(0, 1, 0)
								elseif c then
									-- Path
									t:SetColorTexture(1, 1, 1)
								else
									-- Background
									t:SetColorTexture(.4, .4, .9)
								end
							end
						end

						-- Button scripts
						b:SetScript("OnEnter", function()
							bt[eBtn].line:Show()
						end)

						b:SetScript("OnLeave", function()
							if b ~= selectedBtn then bt[eBtn].line:Hide() end
						end)

						b:SetScript("OnMouseDown", function(self, btn)
							if btn == "RightButton" then
								-- Right-click to exit
								eFrame:Hide()
								return
							else
								-- Deselect all buttons
								for test = 1, #bt do
									bt[test].line:Hide()
								end
								-- Select current button
								bt[eBtn].line:Show()
								selectedBtn = b
								PlaySoundFile("Sound\\Interface\\PlaceHolder.ogg")
								-- Print button data
								eFrame.f:SetText(L["Enigma"] .. " " .. eBtn .. ": |cffffffff" .. eData[eBtn][#eData[eBtn]])
							end
						end)

					end
				else
					-- Toggle frame
					if LeaPlusLC.enimgaFrame:IsShown() then
						LeaPlusLC.enimgaFrame:Hide()
					else
						LeaPlusLC.enimgaFrame:Show()
					end
				end
				return
			elseif str == "showinst" then
				-- List instance IDs for currently selected Encounter Journal expansion filter dropdown
				for i = 1, 5000 do
					local instanceID, name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = EJ_GetInstanceByIndex(i, false)
					if instanceID then print(instanceID, name) end
				end
				for i = 1, 5000 do
					local instanceID, name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = EJ_GetInstanceByIndex(i, true)
					if instanceID then print(instanceID, name) end
				end
				return
			elseif str == "marker" then
				-- Prevent showing raid target markers on self
				if not LeaPlusLC.MarkerFrame then
					LeaPlusLC.MarkerFrame = CreateFrame("FRAME")
					LeaPlusLC.MarkerFrame:RegisterEvent("RAID_TARGET_UPDATE")
				end
				LeaPlusLC.MarkerFrame.Update = true
				if LeaPlusLC.MarkerFrame.Toggle == false then
					-- Show markers
					LeaPlusLC.MarkerFrame:SetScript("OnEvent", nil)
					ActionStatus_DisplayMessage(L["Self Markers Allowed"], true)
					LeaPlusLC.MarkerFrame.Toggle = true
				else
					-- Hide markers
					SetRaidTarget("player", 0)
					LeaPlusLC.MarkerFrame:SetScript("OnEvent", function()
						if LeaPlusLC.MarkerFrame.Update == true then
							LeaPlusLC.MarkerFrame.Update = false
							SetRaidTarget("player", 0)
						end
						LeaPlusLC.MarkerFrame.Update = true
					end)
					ActionStatus_DisplayMessage(L["Self Markers Blocked"], true)
					LeaPlusLC.MarkerFrame.Toggle = false
				end
				return
			elseif str == "af" then
				-- Automatically follow player target using ticker
				if LeaPlusLC.followTick then
					-- Existing ticker is active so cancel it
					LeaPlusLC.followTick:Cancel()
					LeaPlusLC.followTick = nil
					FollowUnit("player")
					LeaPlusLC:Print("AutoFollow disabled.")
				else
					-- No ticker is active so create one
					local targetName, targetRealm = UnitName("target")
					if not targetName or not UnitIsPlayer("target") or UnitIsUnit("player", "target") then
						LeaPlusLC:Print("Invalid target.")
						return
					end
					if targetRealm then targetName = targetName .. "-" .. targetRealm end
					if LeaPlusLC.followTick then
						LeaPlusLC.followTick:Cancel()
					end
					FollowUnit(targetName, true)
					LeaPlusLC.followTick = C_Timer.NewTicker(0.5, function()
						FollowUnit(targetName, true)
					end)
					LeaPlusLC:Print(L["AutoFollow"] .. ": |cffffffff" .. targetName .. "|r.")
				end
				return
			elseif str == "exit" then
				-- Exit a vehicle
				VehicleExit()
				return
			elseif str == "mapid" then
				-- Print map ID
				if WorldMapFrame:IsShown() then
					-- Show world map ID
					local mapID = WorldMapFrame.mapID or nil
					local artID = C_Map.GetMapArtID(mapID) or nil
					local mapName = C_Map.GetMapInfo(mapID).name or nil
					if mapID and artID and mapName then
						LeaPlusLC:Print(mapID .. " (" .. artID .. "): " .. mapName .. " (map)")
					end
				else
					-- Show character map ID
					local mapID = C_Map.GetBestMapForUnit("player") or nil
					local artID = C_Map.GetMapArtID(mapID) or nil
					local mapName = C_Map.GetMapInfo(mapID).name or nil
					if mapID and artID and mapName then
						LeaPlusLC:Print(mapID .. " (" .. artID .. "): " .. mapName .. " (player)")
					end
				end
				return
			elseif str == "pos" then
				-- Map POI code builder
				local mapID = C_Map.GetBestMapForUnit("player") or nil
				local mapName = C_Map.GetMapInfo(mapID).name or nil
				local mapRects = {}
				local tempVec2D = CreateVector2D(0, 0)
				local void
				-- Get player map position
				tempVec2D.x, tempVec2D.y = UnitPosition("player")
				if not tempVec2D.x then return end
				local mapRect = mapRects[mapID]
				if not mapRect then
					mapRect = {}
					void, mapRect[1] = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(0, 0))
					void, mapRect[2] = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(1, 1))
					mapRect[2]:Subtract(mapRect[1])
					mapRects[mapID] = mapRect
				end
				tempVec2D:Subtract(mapRects[mapID][1])
				local pX, pY = tempVec2D.y/mapRects[mapID][2].y, tempVec2D.x/mapRects[mapID][2].x
				pX = string.format("%0.1f", 100 * pX)
				pY = string.format("%0.1f", 100 * pY)
				if mapID and mapName and pX and pY then
					ChatFrame1:Clear()
					local dnType, dnTex = "Dungeon", "dnTex"
					if arg1 == "raid" then dnType, dnTex = "Raid", "rdTex" end
					if arg1 == "portal" then dnType = "Portal" end
					print('[' .. mapID .. '] =  --[[' .. mapName .. ']] {{' .. pX .. ', ' .. pY .. ', L[' .. '"Name"' .. '], L[' .. '"' .. dnType .. '"' .. '], ' .. dnTex .. '},},')
				end
				return
			elseif str == "mapref" then
				-- Print map reveal structure code
				if not WorldMapFrame:IsShown() then
					LeaPlusLC:Print("Open the map first!")
					return
				end
				ChatFrame1:Clear()
				local msg = ""
				local mapID = WorldMapFrame.mapID
				local mapName = C_Map.GetMapInfo(mapID).name
				local mapArt = C_Map.GetMapArtID(mapID)
				msg = msg .. "--[[" .. mapName .. "]] [" .. mapArt .. "] = {"
				local exploredMapTextures = C_MapExplorationInfo.GetExploredMapTextures(mapID);
				if exploredMapTextures then
					for i, exploredTextureInfo in ipairs(exploredMapTextures) do
						local twidth = exploredTextureInfo.textureWidth or 0
						if twidth > 0 then
							local theight = exploredTextureInfo.textureHeight or 0
							local offsetx = exploredTextureInfo.offsetX
							local offsety = exploredTextureInfo.offsetY
							local filedataIDS = exploredTextureInfo.fileDataIDs
							msg = msg .. "[" .. '"' .. twidth .. ":" .. theight .. ":" .. offsetx .. ":" .. offsety .. '"' .. "] = " .. '"'
							for fileData = 1, #filedataIDS do
								msg = msg .. filedataIDS[fileData]
								if fileData < #filedataIDS then
									msg = msg .. ", "
								else
									msg = msg .. '",'
									if i < #exploredMapTextures then
										msg = msg .. " "
									end
								end
							end
						end
					end
					msg = msg .. "},"
					print(msg)
				end
				return
			elseif str == "mk" then
				-- Print a map key
				if not arg1 then LeaPlusLC:Print("Key missing!") return end
				if not tonumber(arg1) then LeaPlusLC:Print("Must be a number!") return end
				local key = arg1
				ChatFrame1:Clear()
				print('"' .. mod(floor(key / 2^36), 2^12) .. ":" .. mod(floor(key / 2^24), 2^12) .. ":" .. mod(floor(key / 2^12), 2^12) .. ":" .. mod(key, 2^12) .. '"')
				return
			elseif str == "map" then
				-- Set map by ID
				if not arg1 or not tonumber(arg1) or not C_Map.GetMapInfo(arg1) then
					LeaPlusLC:Print("Invalid map ID.")
				else
					WorldMapFrame:SetMapID(arg1)
				end
				return
			elseif str == "cls" then
				-- Clear chat frame
				ChatFrame1:Clear()
				return
			elseif str == "al" then
				-- Enable auto loot
				SetCVar("autoLootDefault", "1")
				LeaPlusLC:Print("Auto loot is now enabled.")
				return
			elseif str == "ql" then
				-- Print quest title by ID (for known quests)
				if not arg1 or not tonumber(arg1) then
					LeaPlusLC:Print("Invalid quest ID.")
				else
					local qTicker
					local function GetLinkFunc()
						local qLink = GetQuestLink(arg1)
						if qLink then
							if qTicker then qTicker:Cancel() end
							local newstring = gsub(qLink, "|Hquest:", "")
							local void, newstring = strsplit("[", newstring)
							local newstring, void = strsplit("]", newstring)
							print(newstring)
							return newstring
						elseif qTicker and qTicker._remainingIterations == 1 then
							print("Not found.")
							if qTicker then qTicker:Cancel() end
						end
					end
					local qLink = GetLinkFunc(arg1)
					if not qLink then qTicker = C_Timer.NewTicker(0.5, GetLinkFunc, 3) end
				end
				return
			elseif str == "admin" then
				-- Preset profile (used for testing)
				LpEvt:UnregisterAllEvents()						-- Prevent changes
				wipe(LeaPlusDB)									-- Wipe settings
				LeaPlusLC:PlayerLogout(true)					-- Reset permanent settings
				-- Automation
				LeaPlusDB["AutomateQuests"] = "On"				-- Automate quests
				LeaPlusDB["AutomateGossip"] = "On"				-- Automate gossip
				LeaPlusDB["AutoAcceptSummon"] = "On"			-- Accept summon
				LeaPlusDB["AutoAcceptRes"] = "On"				-- Accept resurrection
				LeaPlusDB["AutoReleasePvP"] = "On"				-- Release in PvP
				LeaPlusDB["AutoSellJunk"] = "On"				-- Sell junk automatically
				LeaPlusDB["AutoRepairGear"] = "On"				-- Repair automatically

				-- Social
				LeaPlusDB["NoDuelRequests"] = "On"				-- Block duels
				LeaPlusDB["NoPetDuels"] = "On"					-- Block pet battle duels
				LeaPlusDB["NoPartyInvites"] = "Off"				-- Block party invites
				LeaPlusDB["NoFriendRequests"] = "Off"			-- Block friend requests			
				LeaPlusDB["AcceptPartyFriends"] = "On"			-- Party from friends
				LeaPlusDB["AutoConfirmRole"] = "On"				-- Queue from friends
				LeaPlusDB["InviteFromWhisper"] = "On"			-- Invite from whispers

				-- Chat
				LeaPlusDB["UseEasyChatResizing"] = "On"			-- Use easy resizing
				LeaPlusDB["NoCombatLogTab"] = "On"				-- Hide the combat log
				LeaPlusDB["NoChatButtons"] = "On"				-- Hide chat buttons
				LeaPlusDB["NoSocialButton"] = "On"				-- Hide social button
				LeaPlusDB["UnclampChat"] = "On"					-- Unclamp chat frame
				LeaPlusDB["MoveChatEditBoxToTop"] = "On"		-- Move editbox to top
				LeaPlusDB["NoStickyChat"] = "On"				-- Disable sticky chat
				LeaPlusDB["UseArrowKeysInChat"] = "On"			-- Use arrow keys in chat
				LeaPlusDB["NoChatFade"] = "On"					-- Disable chat fade
				LeaPlusDB["UnivGroupColor"] = "On"				-- Universal group color
				LeaPlusDB["RecentChatWindow"] = "On"			-- Recent chat window
				LeaPlusDB["MaxChatHstory"] = "Off"				-- Increase chat history

				-- Text
				LeaPlusDB["HideErrorMessages"] = "On"			-- Hide error messages
				LeaPlusDB["NoHitIndicators"] = "On"				-- Hide portrait text
				LeaPlusDB["HideCraftedNames"] = "On"			-- Hide crafted names
				LeaPlusDB["MailFontChange"] = "On"				-- Resize mail text
				LeaPlusDB["LeaPlusMailFontSize"] = 22			-- Mail font size
				LeaPlusDB["QuestFontChange"] = "On"				-- Resize quest text
				LeaPlusDB["LeaPlusQuestFontSize"] = 18			-- Quest font size

				-- Interface
				LeaPlusDB["MinimapMod"] = "On"					-- Customise minimap
				LeaPlusDB["HideZoneTextBar"] = "On"				-- Hide zone text bar
				LeaPlusDB["MergeTrackBtn"] = "On"				-- Merge minimap buttons
				LeaPlusDB["MinimapScale"] = 1.30				-- Minimap scale slider
				LeaPlusDB["TipModEnable"] = "On"				-- Manage tooltip
				LeaPlusDB["TipBackSimple"] = "On"				-- Color backdrops
				LeaPlusDB["LeaPlusTipSize"] = 1.25				-- Tooltip scale slider
				LeaPlusDB["EnhanceDressup"] = "On"				-- Enhance dressup
				LeaPlusDB["ShowVolume"] = "On"					-- Show volume slider
				LeaPlusDB["AhExtras"] = "On"					-- Show auction controls
				LeaPlusDB["ShowCooldowns"] = "On"				-- Show cooldowns
				LeaPlusDB["DurabilityStatus"] = "On"			-- Show durability status
				LeaPlusDB["ShowPetSaveBtn"] = "On"				-- Show pet save button
				LeaPlusDB["ShowWowheadLinks"] = "On"			-- Show Wowhead links

				-- Interface: Manage frames
				LeaPlusDB["FrmEnabled"] = "On"

				LeaPlusDB["Frames"] = {}
				LeaPlusDB["Frames"]["PlayerFrame"] = {}
				LeaPlusDB["Frames"]["PlayerFrame"]["Point"] = "TOPLEFT"
				LeaPlusDB["Frames"]["PlayerFrame"]["Relative"] = "TOPLEFT"
				LeaPlusDB["Frames"]["PlayerFrame"]["XOffset"] = -35
				LeaPlusDB["Frames"]["PlayerFrame"]["YOffset"] = -14
				LeaPlusDB["Frames"]["PlayerFrame"]["Scale"] = 1.20

				LeaPlusDB["Frames"]["TargetFrame"] = {}
				LeaPlusDB["Frames"]["TargetFrame"]["Point"] = "TOPLEFT"
				LeaPlusDB["Frames"]["TargetFrame"]["Relative"] = "TOPLEFT"
				LeaPlusDB["Frames"]["TargetFrame"]["XOffset"] = 190
				LeaPlusDB["Frames"]["TargetFrame"]["YOffset"] = -14
				LeaPlusDB["Frames"]["TargetFrame"]["Scale"] = 1.20

				LeaPlusDB["Frames"]["GhostFrame"] = {}
				LeaPlusDB["Frames"]["GhostFrame"]["Point"] = "CENTER"
				LeaPlusDB["Frames"]["GhostFrame"]["Relative"] = "CENTER"
				LeaPlusDB["Frames"]["GhostFrame"]["XOffset"] = 3
				LeaPlusDB["Frames"]["GhostFrame"]["YOffset"] = -142

				LeaPlusDB["Frames"]["MirrorTimer1"] = {}
				LeaPlusDB["Frames"]["MirrorTimer1"]["Point"] = "TOP"
				LeaPlusDB["Frames"]["MirrorTimer1"]["Relative"] = "TOP"
				LeaPlusDB["Frames"]["MirrorTimer1"]["XOffset"] = 0
				LeaPlusDB["Frames"]["MirrorTimer1"]["YOffset"] = -120

				LeaPlusDB["Frames"]["UIWidgetTopCenterContainerFrame"] = {}
				LeaPlusDB["Frames"]["UIWidgetTopCenterContainerFrame"]["Point"] = "TOP"
				LeaPlusDB["Frames"]["UIWidgetTopCenterContainerFrame"]["Relative"] = "TOP"
				LeaPlusDB["Frames"]["UIWidgetTopCenterContainerFrame"]["XOffset"] = 0
				LeaPlusDB["Frames"]["UIWidgetTopCenterContainerFrame"]["YOffset"] = -542

				LeaPlusDB["Frames"]["BuffFrame"] = {}
				LeaPlusDB["Frames"]["BuffFrame"]["Point"] = "TOPRIGHT"
				LeaPlusDB["Frames"]["BuffFrame"]["Relative"] = "TOPRIGHT"
				LeaPlusDB["Frames"]["BuffFrame"]["XOffset"] = -271
				LeaPlusDB["Frames"]["BuffFrame"]["YOffset"] = 0
				LeaPlusDB["Frames"]["BuffFrame"]["Scale"] = 0.80

				LeaPlusDB["Frames"]["PlayerPowerBarAlt"] = {}
				LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["Point"] = "CENTER"
				LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["Relative"] = "CENTER"
				LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["XOffset"] = 0
				LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["YOffset"] = -160
				LeaPlusDB["Frames"]["PlayerPowerBarAlt"]["Scale"] = 1.25

				LeaPlusDB["ClassColFrames"] = "On"				-- Class colored frames
				LeaPlusDB["ShowPlayerChain"] = "On"				-- Show player chain
				LeaPlusDB["PlayerChainMenu"] = 3				-- Player chain style
				LeaPlusDB["ShowRaidToggle"] = "On"				-- Show raid toggle button
				LeaPlusDB["CombatPlates"] = "On"				-- Combat plates

				LeaPlusDB["NoAlerts"] = "On"					-- Hide alerts
				LeaPlusDB["HideBodyguard"] = "On"				-- Hide bodyguard window
				LeaPlusDB["HideTalkingFrame"] = "On"			-- Hide talking frame
				LeaPlusDB["HideCleanupBtns"] = "On"				-- Hide cleanup buttons
				LeaPlusDB["HideBossBanner"] = "On"				-- Hide boss banner
				LeaPlusDB["HideLevelUpDisplay"] = "On"			-- Hide level-up display
				LeaPlusDB["NoGryphons"] = "On"					-- Hide gryphons
				LeaPlusDB["NoClassBar"] = "On"					-- Hide stance bar
				LeaPlusDB["NoCommandBar"] = "On"				-- Hide order hall bar

				-- System
				LeaPlusDB["NoScreenGlow"] = "On"				-- Disable screen glow
				LeaPlusDB["NoScreenEffects"] = "On"				-- Disable screen effects
				LeaPlusDB["MaxCameraZoom"] = "On"				-- Max camera zoom
				LeaPlusDB["ViewPortEnable"] = "On"				-- Enable viewport
				LeaPlusDB["NoRestedEmotes"] = "On"				-- Silence rested emotes

				LeaPlusDB["NoBagAutomation"] = "On"				-- Disable bag automation
				LeaPlusDB["NoPetAutomation"] = "On"				-- Disable pet automation
				LeaPlusDB["CharAddonList"] = "On"				-- Show character addons
				LeaPlusDB["NoRaidRestrictions"] = "On"			-- Remove raid restrictions
				LeaPlusDB["NoConfirmLoot"] = "On"				-- Disable loot warnings
				LeaPlusDB["FasterLooting"] = "On"				-- Faster auto loot
				LeaPlusDB["FasterMovieSkip"] = "On"				-- Faster movie skip
				LeaPlusDB["LockoutSharing"] = "On"				-- Lockout sharing

				-- Settings
				LeaPlusDB["EnableHotkey"] = "On"				-- Enable hotkey

				-- Function to assign cooldowns
				local function setIcon(pclass, pspec, sp1, pt1, sp2, pt2, sp3, pt3, sp4, pt4, sp5, pt5)
					-- Set spell ID
					if sp1 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R1Idn"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R1Idn"] = sp1 end
					if sp2 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R2Idn"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R2Idn"] = sp2 end
					if sp3 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R3Idn"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R3Idn"] = sp3 end
					if sp4 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R4Idn"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R4Idn"] = sp4 end
					if sp5 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R5Idn"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R5Idn"] = sp5 end
					-- Set pet checkbox
					if pt1 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R1Pet"] = false else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R1Pet"] = true end
					if pt2 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R2Pet"] = false else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R2Pet"] = true end
					if pt3 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R3Pet"] = false else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R3Pet"] = true end
					if pt4 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R4Pet"] = false else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R4Pet"] = true end
					if pt5 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R5Pet"] = false else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R5Pet"] = true end
				end

				-- Create main table
				LeaPlusDB["Cooldowns"] = {}

				-- Create class tables
				for index = 1, GetNumClasses() do
					local classDisplayName, classTag, classID = GetClassInfo(index)
					LeaPlusDB["Cooldowns"][classTag] = {}
				end

				-- Assign cooldowns
				setIcon("WARRIOR", 		1, --[[Arms]] 		 	--[[1]] 32216, 0, 	--[[2]] 209574, 0, 	--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0) -- Victory Rush, Shattered Defences
				setIcon("WARRIOR", 		2, --[[Fury]]  			--[[1]] 32216, 0, 	--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0) -- Victory Rush
				setIcon("WARRIOR", 		3, --[[Protection]]  	--[[1]] 32216, 0, 	--[[2]] 190456, 0, 	--[[3]] 132404, 0, 	--[[4]] 0, 0, 		--[[5]] 0, 0) -- Victory Rush, Ignore Pain, Shield Block

				setIcon("PALADIN", 		1, --[[Holy]]  			--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 203539, 0, 	--[[5]] 203538, 0) -- nil, nil, nil, Wisdom, Kings
				setIcon("PALADIN", 		2, --[[Protection]]  	--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 203539, 0, 	--[[5]] 203538, 0) -- nil, nil, nil, Wisdom, Kings
				setIcon("PALADIN", 		3, --[[Retribution]]  	--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 203539, 0, 	--[[5]] 203538, 0) -- nil, nil, nil, Wisdom, Kings

				setIcon("SHAMAN", 		1, --[[Elemental]]  	--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 215864, 0, 	--[[5]] 546, 0) -- nil, nil, nil, Rainfall, Water Walking
				setIcon("SHAMAN", 		2, --[[Enhancement]]  	--[[1]] 194084, 0, 	--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 215864, 0, 	--[[5]] 546, 0) -- Flametongue, nil, nil, Rainfall, Water Walking
				setIcon("SHAMAN", 		3, --[[Resto]]  		--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 215864, 0, 	--[[5]] 546, 0) -- nil, nil, nil, Rainfall, Water Walking

				setIcon("ROGUE", 		1, --[[Assassination]]  --[[1]] 1784, 0, 	--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 2823, 0, 	--[[5]] 3408, 0) -- Stealth, nil, nil, Deadly Poison, Crippling Poison
				setIcon("ROGUE", 		2, --[[Outlaw]]  		--[[1]] 1784, 0, 	--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 2823, 0, 	--[[5]] 3408, 0) -- Stealth, nil, nil, Deadly Poison, Crippling Poison
				setIcon("ROGUE", 		3, --[[Subtetly]]  		--[[1]] 1784, 0, 	--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 2823, 0, 	--[[5]] 3408, 0) -- Stealth, nil, nil, Deadly Poison, Crippling Poison

				setIcon("DRUID", 		1, --[[Balance]]  		--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0)
				setIcon("DRUID", 		2, --[[Feral]]  		--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0)
				setIcon("DRUID", 		3, --[[Guardian]]  		--[[1]] 192081, 0, 	--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0) -- Ironfur
				setIcon("DRUID", 		4, --[[Resto]]			--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0)

				setIcon("MONK", 		1, --[[Brewmaster]]  	--[[1]] 125359, 0,	--[[2]] 115307, 0, 	--[[3]] 124274, 0, 	--[[4]] 124273, 0, 	--[[5]] 116781, 0) -- Tiger Power, Shuffle, Moderate Stagger, Heavy Stagger, Legacy of the White Tiger
				setIcon("MONK", 		2, --[[Mistweaver]]  	--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0)
				setIcon("MONK", 		3, --[[Windwalker]]  	--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0)

				setIcon("MAGE", 		1, --[[Arcane]]  		--[[1]] 235450, 0, 	--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0) -- Prismatic Barrier
				setIcon("MAGE", 		2, --[[Fire]]  			--[[1]] 235313, 0, 	--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0) -- Blazing Barrier
				setIcon("MAGE", 		3, --[[Frost]]  		--[[1]] 11426, 0, 	--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0) -- Ice Barrier

				setIcon("WARLOCK", 		1, --[[Affliction]]  	--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0)
				setIcon("WARLOCK", 		2, --[[Demonology]]  	--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0)
				setIcon("WARLOCK", 		3, --[[Destruction]]  	--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0)

				setIcon("PRIEST", 		1, --[[Discipline]]  	--[[1]] 17, 0, 		--[[2]] 194384, 0, 	--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0) -- Power Word: Shield
				setIcon("PRIEST", 		2, --[[Holy]]  			--[[1]] 17, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0) -- Power Word: Shield
				setIcon("PRIEST", 		3, --[[Shadow]]  		--[[1]] 17, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0) -- Power Word: Shield

				setIcon("HUNTER", 		1, --[[Beast Mastery]]  --[[1]] 136, 1, 	--[[2]] 118455, 1, 	--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 5384, 0) -- Mend Pet, nil, nil, nil, Feign Death
				setIcon("HUNTER", 		2, --[[Marksmanship]]  	--[[1]] 136, 1, 	--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 5384, 0) -- Mend Pet, nil, nil, nil, Feign Death
				setIcon("HUNTER", 		3, --[[Survival]]  		--[[1]] 136, 1, 	--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 5384, 0) -- Mend Pet, nil, nil, nil, Feign Death

				setIcon("DEATHKNIGHT", 	1, --[[Blood]]  		--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0)
				setIcon("DEATHKNIGHT", 	2, --[[Frost]]  		--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0)
				setIcon("DEATHKNIGHT", 	3, --[[Unholy]]  		--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0)

				setIcon("DEMONHUNTER", 	1, --[[Havoc]]  		--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0)
				setIcon("DEMONHUNTER", 	2, --[[Vengeance]]  	--[[1]] 0, 0, 		--[[2]] 0, 0, 		--[[3]] 0, 0, 		--[[4]] 0, 0, 		--[[5]] 0, 0)

				-- Reload
				ReloadUI()
			else
				LeaPlusLC:Print("Invalid parameter.")
			end
			return
		else
			-- Prevent options panel from showing if a game options panel is showing
			if InterfaceOptionsFrame:IsShown() or VideoOptionsFrame:IsShown() or ChatConfigFrame:IsShown() then return end
			-- Prevent options panel from showing if Blizzard Store is showing
			if StoreFrame and StoreFrame:GetAttribute("isshown") then return end
			-- Toggle the options panel if game options panel is not showing
			if LeaPlusLC:IsPlusShowing() then
				LeaPlusLC:HideFrames()
				LeaPlusLC:HideConfigPanels()
			else
				LeaPlusLC:HideFrames()
				LeaPlusLC["PageF"]:Show()
			end
			LeaPlusLC["Page"..LeaPlusLC["LeaStartPage"]]:Show()
		end
	end

	-- Slash command for global function
	_G.SLASH_Leatrix_Plus1 = "/ltp"
	_G.SLASH_Leatrix_Plus2 = "/leaplus" 
	SlashCmdList["Leatrix_Plus"] = function(self)
		-- Run slash command function
		LeaPlusLC:SlashFunc(self)
		-- Redirect tainted variables
		RunScript('ACTIVE_CHAT_EDIT_BOX = ACTIVE_CHAT_EDIT_BOX')
		RunScript('LAST_ACTIVE_CHAT_EDIT_BOX = LAST_ACTIVE_CHAT_EDIT_BOX')
	end

	-- Slash command for UI reload
	_G.SLASH_LEATRIX_PLUS_RL1 = "/rl"
	SlashCmdList["LEATRIX_PLUS_RL"] = function()
		ReloadUI()
	end

----------------------------------------------------------------------
-- 	L90: Create options panel pages (no content yet)
----------------------------------------------------------------------

	-- Function to add menu button
	function LeaPlusLC:MakeMN(name, text, parent, anchor, x, y, width, height)

		local mbtn = CreateFrame("Button", nil, parent)
		LeaPlusLC[name] = mbtn
		mbtn:Show();
		mbtn:SetSize(width, height)
		mbtn:SetAlpha(1.0)
		mbtn:SetPoint(anchor, x, y)

		mbtn.t = mbtn:CreateTexture(nil, "BACKGROUND")
		mbtn.t:SetAllPoints()
		mbtn.t:SetColorTexture(0.3, 0.3, 0.00, 0.8)
		mbtn.t:SetAlpha(0.7)
		mbtn.t:Hide()

		mbtn.s = mbtn:CreateTexture(nil, "BACKGROUND")
		mbtn.s:SetAllPoints()
		mbtn.s:SetColorTexture(0.3, 0.3, 0.00, 0.8)
		mbtn.s:Hide()

		mbtn.f = mbtn:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		mbtn.f:SetPoint('LEFT', 16, 0)
		mbtn.f:SetText(L[text])
	
		mbtn:SetScript("OnEnter", function()
			mbtn.t:Show()
		end)

		mbtn:SetScript("OnLeave", function()
			mbtn.t:Hide()
		end)

		return mbtn, mbtn.s

	end

	-- Function to create individual options panel pages
	function LeaPlusLC:MakePage(name, title, menu, menuname, menuparent, menuanchor, menux, menuy, menuwidth, menuheight)

		-- Create frame
		local oPage = CreateFrame("Frame", nil, LeaPlusLC["PageF"]); 
		LeaPlusLC[name] = oPage
		oPage:SetAllPoints(LeaPlusLC["PageF"])
		oPage:Hide();

		-- Add page title
		oPage.s = oPage:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		oPage.s:SetPoint('TOPLEFT', 146, -16)
		oPage.s:SetText(L[title])

		-- Add menu item if needed
		if menu then
			LeaPlusLC[menu], LeaPlusLC[menu .. ".s"] = LeaPlusLC:MakeMN(menu, menuname, menuparent, menuanchor, menux, menuy, menuwidth, menuheight)
			LeaPlusLC[name]:SetScript("OnShow", function() LeaPlusLC[menu .. ".s"]:Show(); end)
			LeaPlusLC[name]:SetScript("OnHide", function() LeaPlusLC[menu .. ".s"]:Hide(); end)
		end

		return oPage;
	
	end

	-- Create options pages
	LeaPlusLC["Page0"] = LeaPlusLC:MakePage("Page0", "Home"			, "LeaPlusNav0", "Home"			, LeaPlusLC["PageF"], "TOPLEFT", 16, -72, 112, 20)
	LeaPlusLC["Page1"] = LeaPlusLC:MakePage("Page1", "Automation"	, "LeaPlusNav1", "Automation"	, LeaPlusLC["PageF"], "TOPLEFT", 16, -112, 112, 20)
	LeaPlusLC["Page2"] = LeaPlusLC:MakePage("Page2", "Social"		, "LeaPlusNav2", "Social"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -132, 112, 20)
	LeaPlusLC["Page3"] = LeaPlusLC:MakePage("Page3", "Chat"			, "LeaPlusNav3", "Chat"			, LeaPlusLC["PageF"], "TOPLEFT", 16, -152, 112, 20)
	LeaPlusLC["Page4"] = LeaPlusLC:MakePage("Page4", "Text"			, "LeaPlusNav4", "Text"			, LeaPlusLC["PageF"], "TOPLEFT", 16, -172, 112, 20)
	LeaPlusLC["Page5"] = LeaPlusLC:MakePage("Page5", "Interface"	, "LeaPlusNav5", "Interface"	, LeaPlusLC["PageF"], "TOPLEFT", 16, -192, 112, 20)
	LeaPlusLC["Page6"] = LeaPlusLC:MakePage("Page6", "Frames"		, "LeaPlusNav6", "Frames"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -212, 112, 20)
	LeaPlusLC["Page7"] = LeaPlusLC:MakePage("Page7", "System"		, "LeaPlusNav7", "System"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -232, 112, 20)
	LeaPlusLC["Page8"] = LeaPlusLC:MakePage("Page8", "Settings"		, "LeaPlusNav8", "Settings"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -272, 112, 20)
	LeaPlusLC["Page9"] = LeaPlusLC:MakePage("Page9", "Media"		, "LeaPlusNav9", "Media"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -292, 112, 20)

	-- Page navigation mechanism
	for i = 0, LeaPlusLC["NumberOfPages"] do
		LeaPlusLC["LeaPlusNav"..i]:SetScript("OnClick", function()
			LeaPlusLC:HideFrames()
			LeaPlusLC["PageF"]:Show();
			LeaPlusLC["Page"..i]:Show();
			LeaPlusLC["LeaStartPage"] = i
		end)
	end

	-- Use a variable to contain the page number (makes it easier to move options around)
	local pg;

----------------------------------------------------------------------
-- 	LC0: Welcome
----------------------------------------------------------------------

	pg = "Page0";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Welcome to Leatrix Plus.", 146, -72);
	LeaPlusLC:MakeWD(LeaPlusLC[pg], "To begin, choose an options page.", 146, -92);

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Support", 146, -132);
	LeaPlusLC:MakeWD(LeaPlusLC[pg], "www.leatrix.com", 146, -152);

----------------------------------------------------------------------
-- 	LC1: Automation
----------------------------------------------------------------------

	pg = "Page1";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Character"					, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutomateQuests"			,	"Automate quests"				,	146, -92, 	false,	"If checked, quests will be selected, accepted and turned-in automatically.|n|nQuests which have a gold, currency or crafting reagent requirement will not be turned-in automatically.|n|nYou can hold the shift key down when you talk to a quest giver to override this setting.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutomateGossip"			,	"Automate gossip"				,	146, -112, 	false,	"If checked, you can hold down the alt key while opening a gossip window to automatically select a single gossip option.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutoAcceptSummon"			,	"Accept summon"					, 	146, -132, 	false,	"If checked, summon requests will be accepted automatically unless you are in combat.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutoAcceptRes"				,	"Accept resurrection"			, 	146, -152, 	false,	"If checked, resurrection requests will be accepted automatically as long as the player resurrecting you is not in combat.|n|nResurrection requests from a Brazier of Awakening or a Failure Detection Pylon will not be accepted automatically.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutoReleasePvP"			,	"Release in PvP"				, 	146, -172, 	false,	"If checked, you will release automatically after you die in Ashran, Tol Barad (PvP), Wintergrasp or any battleground.|n|nYou will not release automatically if you have the ability to self-resurrect (soulstone, reincarnation, etc).")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Vendors"					, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutoSellJunk"				,	"Sell junk automatically"		,	340, -92, 	false,	"If checked, all grey items in your bags will be sold automatically when you visit a merchant.|n|nYou can hold the shift key down when you talk to a merchant to override this setting.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutoRepairGear"			, 	"Repair automatically"			,	340, -112, 	false,	"If checked, your gear will be repaired automatically when you visit a suitable merchant.|n|nYou can hold the shift key down when you talk to a merchant to override this setting.")

 	LeaPlusLC:CfgBtn("AutoRepairBtn", LeaPlusCB["AutoRepairGear"])

----------------------------------------------------------------------
-- 	LC2: Social
----------------------------------------------------------------------

	pg = "Page2";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Blocks"					, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoDuelRequests"			, 	"Block duels"					,	146, -92, 	false,	"If checked, duel requests will be blocked unless the player requesting the duel is in your friends list or guild.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoPetDuels"				, 	"Block pet battle duels"		,	146, -112, 	false,	"If checked, pet battle duel requests will be blocked unless the player requesting the duel is in your friends list or guild.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoPartyInvites"			, 	"Block party invites"			, 	146, -132, 	false,	"If checked, party invitations will be blocked unless the player inviting you is in your friends list or guild.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoFriendRequests"			, 	"Block friend requests"			, 	146, -152, 	false,	"If checked, BattleTag and Real ID friend requests will be automatically declined.|n|nEnabling this option will automatically decline any pending requests.")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Groups"					, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AcceptPartyFriends"		, 	"Party from friends"			, 	340, -92, 	false,	"If checked, party invitations from friends or guild members will be automatically accepted unless you are queued in Dungeon Finder.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutoConfirmRole"			, 	"Queue from friends"			,	340, -112, 	false,	"If checked, requests initiated by your party leader to join the Dungeon Finder queue will be automatically accepted if the party leader is in your friends list or guild.|n|nThis option requires that you have selected a role for your character in the Dungeon Finder window.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "InviteFromWhisper"			,   "Invite from whispers"			,	340, -132,	false,	"If checked, a group invite will be sent to anyone who whispers you with the keyword INV.|n|nYou need to be either ungrouped or party leader in your own group for this to work.")

----------------------------------------------------------------------
-- 	LC3: Chat
----------------------------------------------------------------------

	pg = "Page3";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Chat Frame"				, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "UseEasyChatResizing"		,	"Use easy resizing"				,	146, -92,	true,	"If checked, dragging the General chat tab while the chat frame is locked will expand the chat frame upwards.|n|n\If the chat frame is unlocked, dragging the General chat tab will move the chat frame.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoCombatLogTab" 			, 	"Hide the combat log"			, 	146, -112, 	true,	"If checked, the combat log will be hidden.|n|nThe combat log must be docked in order for this option to work.|n|nIf the combat log is undocked, you can dock it by dragging the tab (and reloading your UI) or by resetting the chat windows (from the chat menu).")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoChatButtons"				,	"Hide chat buttons"				,	146, -132,	true,	"If checked, chat frame buttons will be hidden.|n|nClicking chat tabs will automatically show the latest messages.|n|nUse the mouse wheel to scroll through the chat history.  Hold down SHIFT for page jump or CTRL to jump to the top or bottom of the chat history.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoSocialButton"			,	"Hide social button"			,	146, -152,	true,	"If checked, the social button and quick-join notification will be hidden.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "UnclampChat"				,	"Unclamp chat frame"			,	146, -172,	true,	"If checked, you will be able to drag the chat frame to the edge of the screen.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "MoveChatEditBoxToTop" 		, 	"Move editbox to top"			,	146, -192, 	true,	"If checked, the editbox will be moved to the top of the chat frame.")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Mechanics"					, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoStickyChat"				, 	"Disable sticky chat"			,	340, -92,	true,	"If checked, sticky chat will be disabled.|n|nNote that this does not apply to temporary chat windows.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "UseArrowKeysInChat"		, 	"Use arrow keys in chat"		, 	340, -112, 	true,	"If checked, you can press the arrow keys to move the insertion point left and right in the chat frame.|n|nIf unchecked, the arrow keys will use the default keybind setting.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoChatFade"				, 	"Disable chat fade"				, 	340, -132, 	true,	"If checked, chat text will not fade out after a time period.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "UnivGroupColor"			,	"Universal group color"			,	340, -152,	false,	"If checked, raid chat and instance chat will both be colored blue (to match the default party chat color).")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "RecentChatWindow"			,	"Recent chat window"			, 	340, -172, 	true,	"If checked, you can hold down the control key and click a chat tab to view recent chat in a copy-friendly window.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "MaxChatHstory"				,	"Increase chat history"			, 	340, -192, 	true,	"If checked, your chat history will increase to 4096 lines.  If unchecked, the default will be used (128 lines).|n|nEnabling this option may prevent some chat text from showing during login.")

----------------------------------------------------------------------
-- 	LC4: Text
----------------------------------------------------------------------

	pg = "Page4";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Visibility"				, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideErrorMessages"			, 	"Hide error messages"			,	146, -92, 	true,	"If checked, most error messages (such as 'Not enough rage') will not be shown.  Some important errors are excluded.|n|nIf you have the minimap button enabled, you can hold down the control key and right-click it to toggle error messages without affecting this setting.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoHitIndicators"			, 	"Hide portrait numbers"			,	146, -112, 	true,	"If checked, damage and healing numbers in the player and pet portrait frames will be hidden.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideCraftedNames"			, 	"Hide crafted names"			,	146, -132, 	true,	"If checked, crafted items will no longer show the name of the crafter.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideZoneText"				,	"Hide zone text"				,	146, -152, 	true,	"If checked, zone text will not be shown (eg. 'Ironforge').")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Text Size"					, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "MailFontChange"			,	"Resize mail text"				, 	340, -92, 	true,	"If checked, you will be able to change the font size of standard mail text.|n|nThis does not affect mail created using templates (such as auction house invoices).")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "QuestFontChange"			,	"Resize quest text"				, 	340, -112, 	true,	"If checked, you will be able to change the font size of quest text.|n|nEnabling this option will also change the text size of other frames which inherit the same font (such as the Dungeon Finder frame).")

	LeaPlusLC:CfgBtn("MailTextBtn", LeaPlusCB["MailFontChange"])
	LeaPlusLC:CfgBtn("QuestTextBtn", LeaPlusCB["QuestFontChange"])

----------------------------------------------------------------------
-- 	LC5: Interface
----------------------------------------------------------------------

	pg = "Page5";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Enhancements"				, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "MinimapMod"				,	"Customise minimap"				, 	146, -92, 	true,	"If checked, you will be able to customise the minimap.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "TipModEnable"				,	"Manage tooltip"				,	146, -112, 	true,	"If checked, the tooltip will be color coded and you will be able to modify the tooltip layout and scale.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "EnhanceDressup"			, 	"Enhance dressup"				,	146, -132, 	true,	"If checked, additional functionality will be added to the dressup frame.|n|nNude and tabard toggle buttons will be added, model positioning controls will be removed and special model animations will be disabled.")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Extras"					, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowVolume"				, 	"Show volume slider"			, 	340, -92, 	true,	"If checked, a master volume slider will be shown on the character sheet.|n|nThe volume slider can be placed in either of two locations on the character sheet.  To toggle between them, hold the shift key down and right-click the slider.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AhExtras"					, 	"Show auction controls"			, 	340, -112, 	true,	"If checked, additional functionality will be added to the auction house.|n|nBuyout only - create buyout auctions without filling in the starting price.|n|nGold only - set the copper and silver prices at 99 to speed up new auctions.|n|nFind item - search the auction house for the item you are selling.|n|nIn addition, the auction price type and duration settings will be saved account-wide.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowCooldowns"				, 	"Show cooldowns"				, 	340, -132, 	true,	"If checked, you will be able to place up to five beneficial cooldown icons above the target frame.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "DurabilityStatus"			, 	"Show durability status"		, 	340, -152, 	true,	"If checked, a button will be added to the character sheet which will show your equipped item durability when you hover the pointer over it.|n|nIn addition, an overall percentage will be shown in the chat frame when you die.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowPetSaveBtn"			, 	"Show pet save button"			, 	340, -172, 	true,	"If checked, you will be able to save your current battle pet team (including abilities) to a single command.|n|nA button will be added to the Pet Journal.  Clicking the button will toggle showing the assignment command for your current team.  Pressing CTRL/C will copy the command to memory.|n|nYou can then paste the command (with CTRL/V) into the chat window or a macro to instantly assign your team.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowWowheadLinks"			, 	"Show Wowhead links"			, 	340, -192, 	true,	"If checked, Wowhead links will be shown in the world map frame and the achievements frame.")

	LeaPlusLC:CfgBtn("ModMinimapBtn", LeaPlusCB["MinimapMod"])
	LeaPlusLC:CfgBtn("MoveTooltipButton", LeaPlusCB["TipModEnable"])
	LeaPlusLC:CfgBtn("CooldownsButton", LeaPlusCB["ShowCooldowns"])

----------------------------------------------------------------------
-- 	LC6: Frames
----------------------------------------------------------------------

	pg = "Page6";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Features"					, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "FrmEnabled"				,	"Manage frames"					, 	146, -92, 	true,	"If checked, you will be able to change the position and scale of the following frames:|n|n- Player frame|n- Target frame|n- Buffs frame|n- Widget top center frame|n- Ghost frame|n- Timer bar|n- Player power bar")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ClassColFrames"			, 	"Class colored frames"			,	146, -112, 	true,	"If checked, class coloring will be used in the player frame, target frame and focus frame.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowPlayerChain"			, 	"Show player chain"				,	146, -132, 	true,	"If checked, you will be able to show a rare, elite or rare elite chain around the player frame.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowRaidToggle"			, 	"Raid frame toggle"				,	146, -152, 	true,	"If checked, the button to toggle the raid container frame will be shown just above the raid management frame (left side of the screen) instead of in the raid management frame itself.|n|nThis allows you to toggle the raid container frame without needing to open the raid management frame.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "CombatPlates"				, 	"Combat plates"					,	146, -172, 	true,	"If checked, enemy nameplates will be shown during combat and hidden when combat ends.")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Visibility"				, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoAlerts"					,	"Hide alerts"					, 	340, -92, 	true,	"If checked, alert frames will not be shown.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideBodyguard"				, 	"Hide bodyguard gossip"			, 	340, -112, 	true,	"If checked, the gossip window will not be shown when you talk to an active garrison bodyguard.|n|nYou can hold the shift key down when you talk to a bodyguard to override this setting.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideTalkingFrame"			, 	"Hide talking frame"			, 	340, -132, 	true,	"If checked, the talking frame will not be shown.|n|nThe talking frame normally appears in the lower portion of the screen when certain NPCs communicate with you.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideCleanupBtns"			, 	"Hide clean-up buttons"			, 	340, -152, 	true,	"If checked, the backpack clean-up button and the bank frame clean-up button will not be shown.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideBossBanner"			, 	"Hide boss banner"				, 	340, -172, 	true,	"If checked, the boss banner will not be shown.|n|nThe boss banner appears when a boss is defeated.  It shows the name of the boss and the loot that was distributed.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideLevelUpDisplay"		, 	"Hide level-up display"			, 	340, -192, 	true,	"If checked, the level-up display will not be shown.|n|nThe level-up display shows encounter objectives, level-ups, pet battle rewards, etc.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoGryphons"				,	"Hide gryphons"					, 	340, -212, 	true,	"If checked, the main bar gryphons will not be shown.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoClassBar"				,	"Hide stance bar"				, 	340, -232, 	true,	"If checked, the stance bar will not be shown.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoCommandBar"				,	"Hide order hall bar"			, 	340, -252, 	true,	"If checked, the order hall command bar will not be shown.")

	LeaPlusLC:CfgBtn("MoveFramesButton", LeaPlusCB["FrmEnabled"])
	LeaPlusLC:CfgBtn("ModPlayerChain", LeaPlusCB["ShowPlayerChain"])

----------------------------------------------------------------------
-- 	LC7: System
----------------------------------------------------------------------

	pg = "Page7";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Graphics and Sound"		, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoScreenGlow"				, 	"Disable screen glow"			, 	146, -92, 	false,	"If checked, the screen glow will be disabled.|n|nEnabling this option will also disable the drunken haze effect.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoScreenEffects"			, 	"Disable screen effects"		, 	146, -112, 	false,	"If checked, the grey screen of death and the netherworld effect will be disabled.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "MaxCameraZoom"				, 	"Max camera zoom"				, 	146, -132, 	false,	"If checked, you will be able to zoom out to a greater distance.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ViewPortEnable"			,	"Enable viewport"				,	146, -152, 	true,	"If checked, you will be able to create a viewport.  A viewport adds adjustable black borders around the game world.|n|nThe borders are placed on top of the game world but under the UI so you can place UI elements over them.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoRestedEmotes"			, 	"Silence rested emotes"			,	146, -172, 	true,	"If checked, emote sounds will be silenced while your character is:|n|n- resting|n- in a pet battle|n- at the Halfhill Market|n- at the Grim Guzzler|n|nEmote sounds will be enabled when none of the above apply.")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Game Options"				, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoBagAutomation"			, 	"Disable bag automation"		, 	340, -92, 	true,	"If checked, your bags will not be opened or closed automatically when you interact with a merchant, bank or mailbox.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoPetAutomation"			, 	"Disable pet automation"		, 	340, -112, 	true, 	"If checked, battle pets which are automatically summoned will be dismissed within a few seconds.|n|nThis includes dragging a pet onto the first team slot in the pet journal and entering a battle pet team save command.|n|nNote that pets which are automatically summoned during combat will be dismissed when combat ends.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "CharAddonList"				, 	"Show character addons"			, 	340, -132, 	true,	"If checked, the addon list (accessible from the game menu) will show character based addons by default.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoRaidRestrictions"		, 	"Remove raid restrictions"		,	340, -152, 	false,	"If checked, converting a party group to a raid group will succeed even if there are low level characters in the group.|n|nEveryone in the group needs to have Leatrix Plus installed with this option enabled.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoConfirmLoot"				, 	"Disable loot warnings"			,	340, -172, 	false,	"If checked, confirmations will no longer appear when you choose a loot roll option or attempt to sell or mail a tradable item.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "FasterLooting"				, 	"Faster auto loot"				,	340, -192, 	true,	"If checked, the amount of time it takes to auto loot creatures will be significantly reduced.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "FasterMovieSkip"			, 	"Faster movie skip"				,	340, -212, 	true,	"If checked, you will be able to cancel cinematics without being prompted for confirmation.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "LockoutSharing"			, 	"Lockout sharing"				, 	340, -232, 	true, 	"If checked, the 'Display only character achievements to others' setting in the game options panel ('Social' menu) will be permanently checked and locked.")

	LeaPlusLC:CfgBtn("ModViewportBtn", LeaPlusCB["ViewPortEnable"])

----------------------------------------------------------------------
-- 	LC8: Settings
----------------------------------------------------------------------

	pg = "Page8";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Addon"						, 146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowMinimapIcon"			, "Show minimap button"				, 146, -92,		false,	"If checked, a minimap button will be available.|n|nClick - Toggle options panel.|n|nSHIFT/Left-click - Toggle music.|n|nCTRL/Left-click - Toggle minimap target tracking.|n|nCTRL/Right-click - Toggle errors (if enabled).|n|nCTRL/SHIFT/Left-click - Toggle Zygor (if installed).|n|nCTRL/SHIFT/Right-click - Toggle windowed mode.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "EnableHotkey"				, "Enable hotkey"					, 146, -112,	true,	"If checked, you can open Leatrix Plus by pressing CTRL/Z.")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Scale", 340, -72);
	LeaPlusLC:MakeSL(LeaPlusLC[pg], "PlusPanelScale", "", 1, 2, 0.1, 340, -92, "%.1f")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Transparency", 340, -132);
	LeaPlusLC:MakeSL(LeaPlusLC[pg], "PlusPanelAlpha", "", 0, 1, 0.1, 340, -152, "%.1f")

	LeaPlusLC:ShowMemoryUsage(LeaPlusLC[pg], "TOPLEFT", 146, -262)
