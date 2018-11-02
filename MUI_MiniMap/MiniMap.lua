-- Setup namespaces ------------------
local addOnName, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

-- Register and Import ---------

local Engine = obj:Import("MayronUI.Engine");
local miniMapModule, MiniMapClass = MayronUI:RegisterModule("MiniMap");

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
		width = (tk.math.floor(width + 100.5) - 100);
		Minimap:SetSize(width, width);
		
		if (not updateSizeText) then
			Minimap.size:SetText("");
		else
			Minimap.size:SetText(width.." x "..width);
		end

		tk.C_Timer.After(0.02, DragStep);
	end

	function Minimap_OnDragStart()
		if (tk:IsModComboActive("C")) then
			Minimap:StartMoving();
		elseif (tk:IsModComboActive("S")) then
			Minimap:StartSizing();
			updateSizeText = true;
			tk.C_Timer.After(0.1, DragStep);
		end
	end

	function Minimap_OnDragStop(data)
		Minimap:StopMovingOrSizing();
		updateSizeText = nil;
		
		Minimap_ZoomIn();
		Minimap_ZoomOut();

		data.sv.point, data.sv.relativeTo, data.sv.relativePoint, data.sv.x, data.sv.y = Minimap:GetPoint();
		data.sv.x = tk.math.floor(data.sv.x + 0.5);
		data.sv.y = tk.math.floor(data.sv.y + 0.5);

		data.sv.width, data.sv.height = Minimap:GetSize();
		data.sv.width = math.floor(data.sv.width + 0.5);
		data.sv.height = data.sv.width;
	end
end

miniMapModule:OnInitialize(function(self, data)
	data.sv = db.profile.minimap;

	Minimap:ClearAllPoints();
	Minimap:SetPoint(data.sv.point, tk.UIParent, data.sv.relativePoint, data.sv.x, data.sv.y);
	Minimap:SetWidth(data.sv.width);
	Minimap:SetHeight(data.sv.height);
	Minimap:SetScale(data.sv.scale);
	Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground'); -- make rectangle

	tk:KillElement(MiniMapInstanceDifficulty);
	tk:KillElement(GuildInstanceDifficulty);
	MinimapBorder:Hide();
	MinimapBorderTop:Hide();
	MinimapZoomIn:Hide();
	MinimapZoomOut:Hide();
	MinimapZoneTextButton:Hide();
	GameTimeFrame:Hide();
	MiniMapWorldMapButton:Hide();
	MinimapNorthTag:SetTexture("");
	
	-- LFG Icon:
	QueueStatusMinimapButton:SetParent(Minimap);
	QueueStatusMinimapButton:ClearAllPoints();
	QueueStatusMinimapButton:SetPoint("BOTTOMLEFT", -4, -4);
	QueueStatusMinimapButtonBorder:Hide();

	-- Clock:
	TimeManagerClockButton:DisableDrawLayer("BORDER");
	TimeManagerClockButton:ClearAllPoints();
	TimeManagerClockButton:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 0);

	TimeManagerClockTicker:SetFontObject("GameFontNormal");
	TimeManagerClockTicker:ClearAllPoints();
	TimeManagerClockTicker:SetPoint("BOTTOMRIGHT", TimeManagerClockButton, "BOTTOMRIGHT", -5, 5);
	TimeManagerClockTicker:SetJustifyH("RIGHT");

	tk:ApplyThemeColor(TimeManagerClockTicker);
	TimeManagerClockTicker.SetTextColor = tk.Constants.DUMMY_FUNC;

	-- Mail:
	MiniMapMailFrame:ClearAllPoints();
	MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 4, 4);
	MiniMapMailFrame:SetAlpha(0.7);
	MiniMapMailIcon:SetTexture("Interface\\AddOns\\MUI_MiniMap\\mail");
	MiniMapMailBorder:Hide();

	MinimapCluster:ClearAllPoints();
	MinimapCluster:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0);
	MinimapCluster:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 0);

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
	
	Minimap:SetBackdrop( { 
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark", 
		edgeFile = tk.Constants.MEDIA.."borders\\skinner.tga",
		edgeSize = 1,
	});
	Minimap:SetBackdropBorderColor(0, 0, 0);
	Minimap:RegisterForDrag("LeftButton");

	---------------------
	-- MiniMap Scripts:
	---------------------

	Minimap:SetScript("OnMouseWheel", function(_, value)
		if (value > 0) then
			MinimapZoomIn:Click();
		elseif (value < 0) then
			MinimapZoomOut:Click();
		end
	end);

	Minimap:SetScript("OnDragStart", Minimap_OnDragStart);
	Minimap:SetScript("OnDragStop", function()
		Minimap_OnDragStop(data);
	end);

	Minimap:SetScript("OnEnter", function(self)
		if (data.sv.Tooltip) then 
			-- helper tooltip (can be hidden)
			return; 
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
			if (data.sv.Tooltip) then
				data.sv.Tooltip = nil;
				Minimap:GetScript("OnEnter")(Minimap);
			else
				data.sv.Tooltip = true;
				GameTooltip:Hide();
			end
		end
	end);
	
	-- Calendar Button:
	local eventBtn = tk.CreateFrame("Button", nil, Minimap);
    eventBtn:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, -18);
    eventBtn:SetSize(100, 20);
    eventBtn:SetNormalFontObject("GameFontNormal");
    eventBtn:SetHighlightFontObject("GameFontHighlight");
    eventBtn:Hide();

    eventBtn:SetScript("OnClick", function()
        if (not tk._G["CalendarFrame"]) then
            tk.LoadAddOn("Blizzard_Calendar");
        end
        Calendar_Toggle();
	end)

    eventBtn:RegisterEvent('CALENDAR_UPDATE_PENDING_INVITES');
    eventBtn:RegisterEvent('CALENDAR_ACTION_PENDING');
    eventBtn:RegisterEvent('PLAYER_ENTERING_WORLD');
	eventBtn:SetScript('OnEvent',function(self)
		local numPendingInvites = C_Calendar.GetNumPendingInvites();

		if (numPendingInvites > 0) then
			self:SetText(tk.string.format("%s (%i)", L["New Event!"], numPendingInvites));
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
				if (not tk._G["CalendarFrame"]) then
                    tk.LoadAddOn("Blizzard_Calendar");
                end
                Calendar_Toggle();
			end
		},
		{	text = L["Customer Support"],
			func = function() ToggleHelpFrame(); end
		},
		{ 	text = L["Class Order Hall"].." / "..L["Garrison Report"],
			func = function() GarrisonLandingPage_Toggle(); end
		},
		{ 	text = L["Tracking Menu"],
			func = function()  
				ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "MiniMapTracking", 0, -5);
				tk.PlaySound(tk.Constants.CLICK);
			end 
		},
		{ 	text = tk.Strings:GetThemeColoredText(L["MUI Config Menu"]),
			func = function()  
				if (tk.InCombatLockdown()) then
					tk:Print(L["Cannot access config menu while in combat."]);
				else
					MayronUI:TriggerCommand("config");
				end				
			end 
		},
		{ 	text = tk.Strings:GetThemeColoredText(L["MUI Installer"]),
			func = function()
				MayronUI:TriggerCommand("install");
			end 
		},				
	};

	if (tk.IsAddOnLoaded("Leatrix_Plus")) then
        tk.table.insert(menuList, {
            text = tk:GetHexColoredString("Leatrix Plus", "70db70"),
            func = function()
                SlashCmdList["Leatrix_Plus"]()
            end
        });
		tk.table.insert(menuList, {
            text = tk:GetHexColoredString(L["Music Player"], "70db70"),
            func = function()
                SlashCmdList["Leatrix_Plus"]("play")
            end
        });
	end
	
    if (tk.IsAddOnLoaded("Recount")) then
        tk.table.insert(menuList,{
            text = "Toggle Recount",
            func = function()
                if (Recount.MainWindow:IsShown()) then
                    Recount.MainWindow:Hide();
                else
                    Recount.MainWindow:Show();
                    Recount:RefreshMainWindow();
                end
            end
        });
    end

    local menuFrame = tk.CreateFrame("Frame", "MinimapRightClickMenu", tk.UIParent, "UIDropDownMenuTemplate")
	Minimap.oldMouseUp = Minimap:GetScript("OnMouseUp");

	Minimap:SetScript("OnMouseUp", function(self, btn)
		if (btn == "RightButton") then
			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 1);

		elseif (btn == "MiddleButton") then
			ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "Minimap", 0, 0);			
			tk.PlaySound(tk.Constants.CLICK);
			
		else
			self.oldMouseUp(self);
		end
	end);
	
	-- Difficulty Text:
	local mode = tk.CreateFrame("Frame", nil, Minimap);
	mode:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 0);
	mode:SetSize(26, 18);

	mode:RegisterEvent("PLAYER_ENTERING_WORLD");
	mode:RegisterEvent("PLAYER_DIFFICULTY_CHANGED");
	mode:RegisterEvent("GROUP_ROSTER_UPDATE");	

	mode.txt = mode:CreateFontString(nil, "OVERLAY", "MUI_FontNormal");
	mode.txt:SetPoint("TOPRIGHT", mode, "TOPRIGHT", -5, -5);

	mode:SetScript("OnEvent", function()
		if ((IsInInstance())) then
			local difficulty = tk.select(4, GetInstanceInfo());

			if (difficulty == "Heroic") then
				difficulty = "H";
			elseif (difficulty == "Mythic") then
				difficulty = "M";
			elseif (difficulty == "Looking For Raid") then
				difficulty = "RF";
			else
				difficulty = "";
			end

			local players = GetNumGroupMembers();
			players = (players > 0 and players) or 1;
			mode.txt:SetText(players .. difficulty); -- localization possible?
		else
			mode.txt:SetText("");
		end
	end);

	MiniMapTrackingBackground:Hide();
	MiniMapTracking:Hide();

	GarrisonLandingPageMinimapButton:SetSize(1, 1)
	GarrisonLandingPageMinimapButton:SetAlpha(0);
	GarrisonLandingPageMinimapButton:ClearAllPoints();
	GarrisonLandingPageMinimapButton:SetPoint("BOTTOMLEFT", tk.UIParent, "TOPRIGHT", 5, 5);
	GarrisonLandingPageTutorialBox:Hide()
	GarrisonLandingPageTutorialBox.Show = tk.Constants.DUMMY_FUNC;
end);