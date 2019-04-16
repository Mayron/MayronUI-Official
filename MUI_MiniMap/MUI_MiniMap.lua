-- luacheck: ignore MayronUI self 143
local tk, db, _, _, _, L = MayronUI:GetCoreComponents();

-- Register and Import ---------

local C_MiniMapModule = MayronUI:RegisterModule("MiniMap");

local _G = _G;
local Minimap, math, table, C_Timer, Minimap_ZoomIn, Minimap_ZoomOut, GameTooltip, IsAltKeyDown,
CreateFrame, LoadAddOn, InCombatLockdown, IsAddOnLoaded, ToggleHelpFrame, GarrisonLandingPage_Toggle,
ToggleDropDownMenu, PlaySound, EasyMenu, UIParent, select =
_G.Minimap, _G.math, _G.table, _G.C_Timer, _G.Minimap_ZoomIn, _G.Minimap_ZoomOut, _G.GameTooltip,
_G.IsAltKeyDown, _G.CreateFrame, _G.LoadAddOn, _G.InCombatLockdown, _G.IsAddOnLoaded,
_G.ToggleHelpFrame, _G.GarrisonLandingPage_Toggle, _G.ToggleDropDownMenu,
_G.PlaySound, _G.EasyMenu, _G.UIParent, _G.select;

-- Load Database Defaults --------------

db:AddToDefaults("profile.minimap", {
	point = "TOPRIGHT";
	relativePoint = "TOPRIGHT";
	x = -4,
	y = -4,
	width = 200,
	height = 200,
	scale = 1,
});

local Minimap_OnDragStart;
local Minimap_OnDragStop;

do
	local updateSizeText;

	local function DragStep()
		local width = Minimap:GetWidth();
		width = (math.floor(width + 100.5) - 100);
		Minimap:SetSize(width, width);

		if (not updateSizeText) then
			Minimap.size:SetText("");
		else
			Minimap.size:SetText(width.." x "..width);
		end

		C_Timer.After(0.02, DragStep);
	end

	function Minimap_OnDragStart()
		if (tk:IsModComboActive("C")) then
			Minimap:StartMoving();
		elseif (tk:IsModComboActive("S")) then
			Minimap:StartSizing();
			updateSizeText = true;
			C_Timer.After(0.1, DragStep);
		end
	end

	function Minimap_OnDragStop(data)
		Minimap:StopMovingOrSizing();
		updateSizeText = nil;

		Minimap_ZoomIn();
		Minimap_ZoomOut();

		data.settings.point, data.settings.relativeTo, data.settings.relativePoint,
			data.settings.x, data.settings.y = Minimap:GetPoint();

		data.settings.x = math.floor(data.settings.x + 0.5);
		data.settings.y = math.floor(data.settings.y + 0.5);

		data.settings.width, data.settings.height = Minimap:GetSize();
		data.settings.width = math.floor(data.settings.width + 0.5);
		data.settings.height = data.settings.width;

		data.settings:SaveChanges();
	end
end

function C_MiniMapModule:OnInitialize(data)
	data.settings = db.profile.minimap:GetTrackedTable();

	Minimap:ClearAllPoints();
	Minimap:SetPoint(data.settings.point, _G.UIParent, data.settings.relativePoint, data.settings.x, data.settings.y);
	Minimap:SetWidth(data.settings.width);
	Minimap:SetHeight(data.settings.height);
	Minimap:SetScale(data.settings.scale);
	Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground'); -- make rectangle

	tk:KillElement(_G.MiniMapInstanceDifficulty);
	tk:KillElement(_G.GuildInstanceDifficulty);

	_G.MinimapBorder:Hide();
	_G.MinimapBorderTop:Hide();
	_G.MinimapZoomIn:Hide();
	_G.MinimapZoomOut:Hide();
	_G.MinimapZoneTextButton:Hide();
	_G.GameTimeFrame:Hide();
	_G.MiniMapWorldMapButton:Hide();
	_G.MinimapNorthTag:SetTexture("");

	-- LFG Icon:
	_G.QueueStatusMinimapButton:SetParent(Minimap);
	_G.QueueStatusMinimapButton:ClearAllPoints();
	_G.QueueStatusMinimapButton:SetPoint("BOTTOMLEFT", -4, -4);
	_G.QueueStatusMinimapButtonBorder:Hide();

	-- Clock:
	_G.TimeManagerClockButton:DisableDrawLayer("BORDER");
	_G.TimeManagerClockButton:ClearAllPoints();
	_G.TimeManagerClockButton:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 0);

	_G.TimeManagerClockTicker:SetFontObject("GameFontNormal");
	_G.TimeManagerClockTicker:ClearAllPoints();
	_G.TimeManagerClockTicker:SetPoint("BOTTOMRIGHT", _G.TimeManagerClockButton, "BOTTOMRIGHT", -5, 5);
	_G.TimeManagerClockTicker:SetJustifyH("RIGHT");

	tk:ApplyThemeColor(_G.TimeManagerClockTicker);
	_G.TimeManagerClockTicker.SetTextColor = tk.Constants.DUMMY_FUNC;

	-- Mail:
	_G.MiniMapMailFrame:ClearAllPoints();
	_G.MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 4, 4);
	_G.MiniMapMailFrame:SetAlpha(0.7);
	_G.MiniMapMailIcon:SetTexture("Interface\\AddOns\\MUI_MiniMap\\mail");
	_G.MiniMapMailBorder:Hide();

	_G.MinimapCluster:ClearAllPoints();
	_G.MinimapCluster:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0);
	_G.MinimapCluster:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 0);

	-- Mouse Wheel and "Blob" ring
	Minimap:EnableMouseWheel(true);
	Minimap:SetArchBlobRingScalar(0);
	Minimap:SetQuestBlobRingScalar(0);

	Minimap.size = Minimap:CreateFontString(nil, "ARTWORK")
	Minimap.size:SetFontObject("GameFontNormalLarge");
	Minimap.size:SetPoint("TOP", Minimap, "BOTTOM", 0, 40);

	Minimap:SetResizable(true);
	Minimap:SetMovable(true);
	Minimap:SetMaxResize(400, 400);
	Minimap:SetMinResize(120, 120);
	Minimap:SetClampedToScreen(true);
	Minimap:SetClampRectInsets(-3, 3, 3, -3);

	Minimap:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
		edgeFile = tk:GetAssetFilePath("Borders\\Solid.tga"),
		edgeSize = 1,
	});

	Minimap:SetBackdropBorderColor(0, 0, 0);
	Minimap:RegisterForDrag("LeftButton");

	---------------------
	-- MiniMap Scripts:
	---------------------

	Minimap:SetScript("OnMouseWheel", function(_, value)
		if (value > 0) then
			_G.MinimapZoomIn:Click();
		elseif (value < 0) then
			_G.MinimapZoomOut:Click();
		end
	end);

	Minimap:SetScript("OnDragStart", Minimap_OnDragStart);
	Minimap:SetScript("OnDragStop", function()
		Minimap_OnDragStop(data);
	end);

	Minimap:SetScript("OnEnter", function(self)
		if (data.settings.Tooltip) then
			-- helper tooltip (can be hidden)
			return
		end

		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -2)
		GameTooltip:SetText("MUI MiniMap");  -- This sets the top line of text, in gold.
		GameTooltip:AddDoubleLine(L["CTRL + Drag:"], L["Move Minimap"], 1, 1, 1);
		GameTooltip:AddDoubleLine(L["SHIFT + Drag:"], L["Resize Minimap"], 1, 1, 1);
		GameTooltip:AddDoubleLine(L["Left Click:"], L["Ping Minimap"], 1, 1, 1);
		GameTooltip:AddDoubleLine(L["Middle Click:"], L["Show Tracking Menu"], 1, 1, 1);
		GameTooltip:AddDoubleLine(L["Right Click:"], L["Show Menu"], 1, 1, 1);
		GameTooltip:AddDoubleLine(L["Mouse Wheel:"], L["Zoom in/out"], 1, 1, 1);
		GameTooltip:AddDoubleLine(L["ALT + Left Click:"], L["Toggle this Tooltip"], 1, 0, 0, 1, 0, 0);
		GameTooltip:Show();
	end);

	Minimap:HookScript("OnMouseDown", function(self, button)
		if ((IsAltKeyDown()) and (button == "LeftButton")) then
			if (data.settings.Tooltip) then
				data.settings.Tooltip = nil;
				Minimap:GetScript("OnEnter")(Minimap);
			else
				data.settings.Tooltip = true;
				GameTooltip:Hide();
			end

			data.settings:SaveChanges();
		end
	end);

	-- Calendar Button:
	local eventBtn = CreateFrame("Button", nil, Minimap);
    eventBtn:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, -18);
    eventBtn:SetSize(100, 20);
    eventBtn:SetNormalFontObject("GameFontNormal");
    eventBtn:SetHighlightFontObject("GameFontHighlight");
    eventBtn:Hide();

    eventBtn:SetScript("OnClick", function()
        if (not _G["CalendarFrame"]) then
            LoadAddOn("Blizzard_Calendar");
        end
        _G.Calendar_Toggle();
	end)

    eventBtn:RegisterEvent('CALENDAR_UPDATE_PENDING_INVITES');
    eventBtn:RegisterEvent('CALENDAR_ACTION_PENDING');
    eventBtn:RegisterEvent('PLAYER_ENTERING_WORLD');
	eventBtn:SetScript('OnEvent',function(self)
		local numPendingInvites = _G.C_Calendar.GetNumPendingInvites();

		if (numPendingInvites > 0) then
			self:SetText(string.format("%s (%i)", L["New Event!"], numPendingInvites));
            self:Show();
		else
			self:SetText("");
            self:Hide();
		end
	end);

	-- Drop down List:
	local menuList = {
		{ 	text = L["Calendar"],
			func = function()
				if (not _G["CalendarFrame"]) then
                    LoadAddOn("Blizzard_Calendar");
                end
                _G.Calendar_Toggle();
			end
		},
		{	text = L["Customer Support"],
			func = ToggleHelpFrame;
		},
		{ 	text = L["Class Order Hall"].." / "..L["Garrison Report"],
			func = GarrisonLandingPage_Toggle
		},
		{ 	text = L["Tracking Menu"],
			func = function()
				ToggleDropDownMenu(1, nil, _G.MiniMapTrackingDropDown, "MiniMapTracking", 0, -5);
				PlaySound(tk.Constants.CLICK);
			end
		},
		{ 	text = tk.Strings:SetTextColorByTheme(L["MUI Config Menu"]),
			func = function()
				if (InCombatLockdown()) then
					tk:Print(L["Cannot access config menu while in combat."]);
				else
					MayronUI:TriggerCommand("config");
				end
			end
		},
		{ 	text = tk.Strings:SetTextColorByTheme(L["MUI Installer"]),
			func = function()
				MayronUI:TriggerCommand("install");
			end
		},
	};

	if (IsAddOnLoaded("Leatrix_Plus")) then
        table.insert(menuList, {
            text = tk.Strings:SetTextColorByHex("Leatrix Plus", "70db70"),
            func = function()
                _G.SlashCmdList["Leatrix_Plus"]();
            end
        });
		table.insert(menuList, {
            text = tk.Strings:SetTextColorByHex(L["Music Player"], "70db70"),
            func = function()
                _G.SlashCmdList["Leatrix_Plus"]("play");
            end
        });
	end

    if (IsAddOnLoaded("Recount")) then
        table.insert(menuList, {
            text = "Toggle Recount",
            func = function()
                if (_G.Recount.MainWindow:IsShown()) then
                    _G.Recount.MainWindow:Hide();
                else
                    _G.Recount.MainWindow:Show();
                    _G.Recount:RefreshMainWindow();
                end
            end
        });
    end

    local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
	Minimap.oldMouseUp = Minimap:GetScript("OnMouseUp");

	Minimap:SetScript("OnMouseUp", function(self, btn)
		if (btn == "RightButton") then
			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 1);

		elseif (btn == "MiddleButton") then
			ToggleDropDownMenu(1, nil, _G.MiniMapTrackingDropDown, "Minimap", 0, 0);
			PlaySound(tk.Constants.CLICK);

		else
			self.oldMouseUp(self);
		end
	end);

	-- Difficulty Text:
	local mode = CreateFrame("Frame", nil, Minimap);
	mode:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 0);
	mode:SetSize(26, 18);

	mode:RegisterEvent("PLAYER_ENTERING_WORLD");
	mode:RegisterEvent("PLAYER_DIFFICULTY_CHANGED");
	mode:RegisterEvent("GROUP_ROSTER_UPDATE");

	mode.txt = mode:CreateFontString(nil, "OVERLAY", "MUI_FontNormal");
	mode.txt:SetPoint("TOPRIGHT", mode, "TOPRIGHT", -5, -5);

	mode:SetScript("OnEvent", function()
		if ((_G.IsInInstance())) then
			local difficulty = select(4, _G.GetInstanceInfo());

			if (difficulty == "Heroic") then
				difficulty = "H";
			elseif (difficulty == "Mythic") then
				difficulty = "M";
			elseif (difficulty == "Looking For Raid") then
				difficulty = "RF";
			else
				difficulty = "";
			end

			local players = _G.GetNumGroupMembers();
			players = (players > 0 and players) or 1;
			mode.txt:SetText(players .. difficulty); -- localization possible?
		else
			mode.txt:SetText("");
		end
	end);

	_G.MiniMapTrackingBackground:Hide();
	_G.MiniMapTracking:Hide();

	_G.GarrisonLandingPageMinimapButton:SetSize(1, 1)
	_G.GarrisonLandingPageMinimapButton:SetAlpha(0);
	_G.GarrisonLandingPageMinimapButton:ClearAllPoints();
	_G.GarrisonLandingPageMinimapButton:SetPoint("BOTTOMLEFT", UIParent, "TOPRIGHT", 5, 5);
	_G.GarrisonLandingPageTutorialBox:Hide()
	_G.GarrisonLandingPageTutorialBox.Show = tk.Constants.DUMMY_FUNC;
end