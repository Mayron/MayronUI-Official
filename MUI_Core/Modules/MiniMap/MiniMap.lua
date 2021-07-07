-- luacheck: ignore MayronUI self 143
local _, namespace = ...;
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

-- Register and Import ---------

---@class MiniMapModule : BaseModule
local C_MiniMapModule = MayronUI:RegisterModule("MiniMap", L["Mini-Map"]);
namespace.C_MiniMapModule = C_MiniMapModule;

local Minimap, math, table, C_Timer, Minimap_ZoomIn, Minimap_ZoomOut, GameTooltip, IsAltKeyDown,
CreateFrame, LoadAddOn, IsAddOnLoaded, ToggleDropDownMenu, PlaySound, EasyMenu, UIParent, select =
  _G.Minimap, _G.math, _G.table, _G.C_Timer, _G.Minimap_ZoomIn, _G.Minimap_ZoomOut, _G.GameTooltip,
  _G.IsAltKeyDown, _G.CreateFrame, _G.LoadAddOn, _G.IsAddOnLoaded, _G.ToggleDropDownMenu,
  _G.PlaySound, _G.EasyMenu, _G.UIParent, _G.select;

local IsInInstance, GetInstanceInfo, GetNumGroupMembers, ipairs =
_G.IsInInstance, _G.GetInstanceInfo, _G.GetNumGroupMembers, _G.ipairs;

local ShowGarrisonLandingPage, strformat = _G.ShowGarrisonLandingPage, _G.string.format;

-- Load Database Defaults --------------

db:AddToDefaults("profile.minimap", {
  enabled = true;
  point = "TOPRIGHT";
  relativePoint = "TOPRIGHT";
  x = -4;
  y = -4;
  size = 200;
  scale = 1;

  testMode = false; -- for testing

  widgets = {
    clock = {
      hide = false;
      fontSize = 12;
      point = "BOTTOMRIGHT";
      x = 0;
      y = 0;
    };

    difficulty = {
      show = true;
      fontSize = 12;
      point = "TOPRIGHT";
      x = -8;
      y = -8;
    };

    lfg = {
      scale = 0.9;
      point = "BOTTOMLEFT";
      x = 22;
      y = 0;
    };

    mail = {
      scale = 1;
      point = "BOTTOMRIGHT";
      x = -8;
      y = 24;
    };

    missions = {
      hide = false;
      scale = 0.6;
      point = "TOPLEFT";
      x = -8;
      y = 2;
    };

    tracking = {
      hide = false;
      scale = 0.8;
      point = "BOTTOMLEFT";
      x = 0;
      y = 2;
    };

    zone = {
      hide = true;
      point = "TOP";
      fontSize = 10;
      x = 0;
      y = -4;
    };
  };
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

		local tracker = data.settings:GetTrackedTable();
		tracker.point, tracker.relativeTo, tracker.relativePoint, tracker.x, tracker.y = Minimap:GetPoint();

		tracker.x = math.floor(tracker.x + 0.5);
		tracker.y = math.floor(tracker.y + 0.5);

		tracker.size, tracker.size = Minimap:GetSize();
		tracker.size = math.floor(tracker.size + 0.5);

		tracker:SaveChanges();
	end
end

local callback;
callback = tk:HookFunc("BattlefieldMap_LoadUI", function()
  if (IsAddOnLoaded("Blizzard_BattlefieldMap") and _G.BattlefieldMapFrame) then
    local updateSize;
    local originalWidth, originalHeight = 298, 199;
    local mapFrame, mapTab, mapOptions = _G.BattlefieldMapFrame, _G.BattlefieldMapTab, _G.BattlefieldMapOptions;
    local previousWidth;
    local GetMinimapZoneText = _G.GetMinimapZoneText;

    local function DragStep()
      if (not updateSize) then return end
      local width = mapFrame:GetWidth();

      if (previousWidth ~= width) then
        previousWidth = width;
        width = (math.floor(width + 100.5) - 100);

        local difference = width / originalWidth;
        local height = originalHeight * difference;
        mapFrame:SetSize(width, height);
        mapFrame.ScrollContainer:OnCanvasSizeChanged()
      end

      if (updateSize) then
        C_Timer.After(0.02, DragStep);
      end
    end

    local function update(self)
      if (self.reskinned) then
        if (self.titleBar) then
          self.titleBar.text:SetText(GetMinimapZoneText());
        end
        return
      end

      self.BorderFrame:DisableDrawLayer("ARTWORK");
      originalWidth, originalHeight = self.ScrollContainer:GetSize();

      gui:AddResizer(tk.Constants.AddOnStyle, self);
      self.dragger:SetParent(self.BorderFrame);
      self:SetMinResize(originalWidth, originalHeight);
      self:SetMaxResize(1200, 800);

      gui:AddTitleBar(tk.Constants.AddOnStyle, self, GetMinimapZoneText());
      self.titleBar:SetFrameStrata("HIGH");
      self.titleBar:RegisterForClicks("RightButtonUp");
      self.titleBar:SetScript("OnClick", function(self, button)
        if (button == "RightButton") then
          PlaySound(tk.Constants.CLICK);

          -- If Rightclick bring up the options menu
          if (button == "RightButton") then
            local function InitializeOptionsDropDown(self)
              self:GetParent():InitializeOptionsDropDown();
            end
            _G.UIDropDownMenu_Initialize(mapTab.OptionsDropDown, InitializeOptionsDropDown, "MENU");
            ToggleDropDownMenu(1, nil, mapTab.OptionsDropDown, self, 0, 0);
            return;
          end
        end
      end);

      self.dragger:SetFrameStrata("HIGH");
      mapTab:Hide();
      mapTab.Show = tk.Constants.DUMMY_FUNC;

      local container = self.ScrollContainer;
      container:SetAllPoints(self);

      self.dragger:HookScript("OnDragStop", function()
        container:ZoomIn();
        container:ZoomOut();
        updateSize = nil;
      end);

      self.dragger:HookScript("OnDragStart", function()
        updateSize = true;
        C_Timer.After(0.1, DragStep);
      end);

      self.reskinned = true;
    end

    mapFrame:SetFrameStrata("MEDIUM");
    mapFrame:HookScript("OnShow", update);
    mapFrame:HookScript("OnEvent", function(self)
      if (self.titleBar) then
        self.titleBar.text:SetText(GetMinimapZoneText());
      end
    end);

    local bg = gui:CreateDialogBox(tk.Constants.AddOnStyle, mapFrame, "HIGH", nil, "MUI_ZoneMap");
    bg:SetAllPoints(true);
    bg:SetFrameStrata("LOW");
    bg:SetAlpha(1.0 - mapOptions.opacity);

    tk:HookFunc(mapFrame, "RefreshAlpha", function()
      local alpha = 1.0 - mapOptions.opacity;
      bg:SetAlpha(1.0 - mapOptions.opacity);
      mapFrame.titleBar:SetAlpha(math.max(alpha, 0.3));
    end);

    mapFrame.BorderFrame.CloseButtonBorder:SetTexture(nil);
    mapFrame.BorderFrame.CloseButton:SetPoint("TOPRIGHT", mapFrame.BorderFrame, "TOPRIGHT", 5, 5);
    tk:UnhookFunc("BattlefieldMap_LoadUI", callback);
  end
end);

do
  local widgetMethods = {};
  local positioningMethods = { "SetParent", "ClearAllPoints", "SetPoint", "SetScale"};
  local visibilityMethods = { "Show", "Hide", "SetShown"};

  function C_MiniMapModule.Private:SetUpWidget(data, name, widget)
    local methods = widgetMethods[name];
    local settings = data.settings.widgets[name];

    obj:Assert(obj:IsTable(settings), "Mini-Map widget settings not found with key '%s'.", name);

    if (not methods) then
      methods = obj:PopTable();
      widgetMethods[name] = methods;

      for _, m in ipairs(positioningMethods) do
        methods[m] = widget[m];
        widget[m] = tk.Constants.DUMMY_FUNC;
      end
    end

    methods.SetParent(widget, Minimap);
    methods.ClearAllPoints(widget);
    methods.SetPoint(widget, settings.point, settings.x, settings.y);

    if (settings.scale) then
      methods.SetScale(widget, settings.scale);
    end

    if (data.testModeActive) then return end

    if (data.settings.testMode) then
      data.isShown = data.isShown or obj:PopTable();

      if (name == "difficulty") then
        data.previousDifficulty = widget:GetText() or "";
        widget:SetText("25H");
      else
        data.isShown[name] = widget:IsShown();

        if (widget.Show ~= tk.Constants.DUMMY_FUNC) then
          widget:Show();
        else
          methods.Show(widget);
        end
      end
    else
      if (name == "difficulty" and data.previousDifficulty ~= nil) then
        widget:SetText(data.previousDifficulty);
        data.previousDifficulty = nil;
      else
        if (obj:IsTable(data.isShown) and data.isShown[name] ~= nil) then
          if (widget.Show ~= tk.Constants.DUMMY_FUNC) then
            widget:SetShown(data.isShown[name]);
          else
            methods.SetShown(widget, data.isShown[name]);
          end
          data.isShown[name] = nil;
        end
      end

      -- if nil, then let it show/hide naturally
      local shown = nil;
      if (settings.hide or settings.show == false) then
        -- blizzard element or something we want to hide perminently
        shown = false;
      elseif (settings.hide == false or settings.show) then
        if (name == "missions") then
          -- don't show missions icon just yet, wait for the garrison type to be available
          shown = false;
          local missionsListener = em:CreateEventListener(function(self)
            if (_G.C_Garrison.GetLandingPageGarrisonType() ~= 0) then
              -- show when player actually has a "GarrisonType", new players always have 0
              if (not widget:IsShown()) then
                if (widget.SetShown ~= tk.Constants.DUMMY_FUNC) then
                  widget:SetShown(true);
                else
                  methods.SetShown(widget, true);
                end
              end
            end
          end);

          missionsListener:RegisterEvents("GARRISON_UPDATE");
        else
          -- if show, custom MUI widget that should be shown
          shown = true;
        end
      end

      if (shown ~= nil) then
        if (widget.SetShown ~= tk.Constants.DUMMY_FUNC) then
          widget:SetShown(shown);

          for _, m in ipairs(visibilityMethods) do
            methods[m] = widget[m];
            widget[m] = tk.Constants.DUMMY_FUNC;
          end
        else
          methods.SetShown(widget, shown);
        end
      end
    end
  end

  local function SetUpWidgetText(fontstring, settings)
    if (settings.point:find("LEFT")) then
      fontstring:SetJustifyH("LEFT");
    elseif (settings.point:find("RIGHT")) then
      fontstring:SetJustifyH("RIGHT");
    else
      fontstring:SetJustifyH("CENTER");
    end

    fontstring:SetFontObject("MUI_FontNormal");
    tk:SetFontSize(fontstring, settings.fontSize);

    if (fontstring:GetParent() ~= Minimap) then
      fontstring:ClearAllPoints();

      if (settings.point:find("LEFT")) then
        fontstring:SetPoint("LEFT", 7, 0);
      elseif (settings.point:find("RIGHT")) then
        fontstring:SetPoint("RIGHT", -7, 0);
      else
        fontstring:SetPoint("CENTER");
      end
    end
  end

  -- TODO: Does not work in BCC (PLAYER_DIFFICULTY_CHANGED event does not exist)
  -- TODO: But BCC can have heroics?
  local function SetDungeonDifficultyShown(data)
    if (not tk:IsRetail()) then return end
    local widgets = data.settings.widgets;

    if (not data.dungeonDifficulty and not widgets.difficulty.show) then return end

    if (not data.dungeonDifficulty) then
      -- Create
      data.dungeonDifficulty = Minimap:CreateFontString(nil, "OVERLAY");

      local listener = em:CreateEventListenerWithID("DungeonDifficultyText", function()
        if (IsInInstance()) then
          local difficulty = select(4, GetInstanceInfo());

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
          data.dungeonDifficulty:SetText(players .. difficulty); -- localization possible?
        else
          data.dungeonDifficulty:SetText("");
        end
      end);

      listener:RegisterEvents("PLAYER_ENTERING_WORLD", "PLAYER_DIFFICULTY_CHANGED", "GROUP_ROSTER_UPDATE");
    else
      if (widgets.difficulty.show) then
        em:DisableEventListeners("DungeonDifficultyText");
      else
        em:EnableEventListeners("DungeonDifficultyText");
      end
    end

    data:Call("SetUpWidget", "difficulty", data.dungeonDifficulty);
    SetUpWidgetText(data.dungeonDifficulty, widgets.difficulty);
  end

  function C_MiniMapModule.Private:SetUpWidgets(data)
    local widgets = data.settings.widgets;

    -- clock:
    local clock = _G.TimeManagerClockButton;
    clock:DisableDrawLayer("BORDER");
    data:Call("SetUpWidget", "clock", clock);

    _G.TimeManagerClockTicker:SetParent(clock);
    _G.TimeManagerClockTicker:ClearAllPoints();
    _G.TimeManagerClockTicker:SetPoint("CENTER");
    SetUpWidgetText(_G.TimeManagerClockTicker, widgets.clock);

    -- difficulty:
    SetDungeonDifficultyShown(data);

    -- lfg:
    if (tk:IsRetail()) then
      if (not data.reskinnedLFG) then
        tk:KillElement(_G.MiniMapInstanceDifficulty);
        tk:KillElement(_G.GuildInstanceDifficulty);
        _G.QueueStatusMinimapButtonBorder:Hide();
        data.reskinnedLFG = true;
      end

      data:Call("SetUpWidget", "lfg", _G.QueueStatusMinimapButton);
    end

    -- mail:
    data:Call("SetUpWidget", "mail", _G.MiniMapMailFrame);
    _G.MiniMapMailFrame:SetAlpha(0.7);
    _G.MiniMapMailFrame:SetSize(14, 10);
    _G.MiniMapMailIcon:ClearAllPoints();
    _G.MiniMapMailIcon:SetPoint("CENTER");
    _G.MiniMapMailIcon:SetTexture(tk:GetAssetFilePath("Textures\\mail"));
    _G.MiniMapMailBorder:Hide();

    -- missions icon:
    if (tk:IsRetail() and obj:IsWidget(_G.GarrisonLandingPageMinimapButton)) then
      data:Call("SetUpWidget", "missions", _G.GarrisonLandingPageMinimapButton);
      -- prevents popup from showing:
      _G.GarrisonLandingPageMinimapButton:DisableDrawLayer("OVERLAY");
      _G.GarrisonLandingPageMinimapButton:DisableDrawLayer("BORDER");
      _G.GarrisonLandingPageMinimapButton.SideToastGlow:SetTexture("");
    end

    -- tracking:
    if (not tk:IsClassic() and obj:IsWidget(_G.MiniMapTracking)) then
      _G.MiniMapTrackingBackground:Hide();
      if (tk:IsRetail()) then
        _G.MiniMapTrackingButtonBorder:Hide();
        _G.MiniMapTrackingIconOverlay:Hide();
      end

      if (tk:IsBCClassic()) then
        _G.MiniMapTrackingBorder:Hide();
      end

      data:Call("SetUpWidget", "tracking", _G.MiniMapTracking);
      _G.MiniMapTrackingIcon:SetPoint("CENTER", 0, 0);
    end

    -- zone:
    data:Call("SetUpWidget", "zone", _G.MinimapZoneTextButton);
    SetUpWidgetText(_G.MinimapZoneText, widgets.zone);
    _G.MinimapZoneText:ClearAllPoints();
    _G.MinimapZoneText:SetAllPoints(true);
  end
end

function C_MiniMapModule.Private:UpdateTrackingMenuOptionVisibility(data)
  if (not _G.MiniMapTracking) then return end
  local oldIndex = 0;

  for id, option in ipairs(data.menuList) do
    if (option.text == L["Tracking Menu"]) then
      oldIndex = id;
      break
    end
  end

  if (not data.settings.widgets.tracking.hide and oldIndex > 0) then
    table.remove(data.menuList, oldIndex);
  end

  if (data.settings.widgets.tracking.hide and oldIndex == 0) then
    table.insert(data.menuList, 1, {
      text = L["Tracking Menu"],
      notCheckable = true;
      func = function()
        ToggleDropDownMenu(1, nil, _G.MiniMapTrackingDropDown, "MiniMapTracking", 0, -5);
        PlaySound(tk.Constants.CLICK);
      end
    });
  end
end

function C_MiniMapModule:GetRightClickMenuList()
  local menuList = {};

  if (tk:IsRetail()) then
    table.insert(menuList, {
      text = L["Calendar"],
      notCheckable = true;
      func = function()
        if (not _G["CalendarFrame"]) then
          LoadAddOn("Blizzard_Calendar");
        end
        _G.Calendar_Toggle();
      end
    });

    local function ShowMissions(garrTypeId)
      LoadAddOn("Blizzard_GarrisonUI");
      local items = _G.C_Garrison.GetAvailableMissions(_G.GetPrimaryGarrisonFollowerType(garrTypeId));

      if (obj:IsTable(items)) then
        ShowGarrisonLandingPage(garrTypeId);
      else
        MayronUI:Print("No available missions to show.");
      end
    end

    table.insert(menuList, {
      text = L["Garrison Report"],
      notCheckable = true;
      func = function()
        ShowMissions(2);
      end
    });

    table.insert(menuList, {
      text = L["Class Order Hall"],
      notCheckable = true;
      func = function()
        ShowMissions(3);
      end
    });

    table.insert(menuList, {
      text = L["Missions"],
      notCheckable = true;
      func = function()
        ShowMissions(9);
      end
    });

    table.insert(menuList, {
      text = L["Covenant Sanctum"],
      notCheckable = true;
      func = function()
        LoadAddOn("Blizzard_GarrisonUI");
        if (_G.C_Covenants.GetActiveCovenantID() >= 1) then
          ShowGarrisonLandingPage(111);
        else
          MayronUI:Print(L["You must be a member of a covenant to view this."]);
        end
      end
    });
  end

  if (IsAddOnLoaded("Leatrix_Plus")) then
    table.insert(menuList, {
      text = tk.Strings:SetTextColorByHex("Leatrix Plus", "70db70"),
      notCheckable = true;
      func = function()
        _G.SlashCmdList["Leatrix_Plus"]();
      end
    });
	end

  table.insert(menuList, {
    text = tk.Strings:SetTextColorByTheme("MayronUI"),
    notCheckable = true;
    hasArrow = true,
      menuList = {
      { notCheckable = true; text = L["Config Menu"], func = function() MayronUI:TriggerCommand("config") end};
      { notCheckable = true; text = L["Install"], func = function() MayronUI:TriggerCommand("install") end};
      { notCheckable = true; text = L["Layouts"], func = function() MayronUI:TriggerCommand("layouts") end};
      { notCheckable = true; text = L["Profile Manager"], func = function() MayronUI:TriggerCommand("profiles") end};
      { notCheckable = true; text = L["Show Profiles"], func = function() MayronUI:TriggerCommand("profiles", "list") end};
      { notCheckable = true; text = L["Version"], func = function() MayronUI:TriggerCommand("version") end};
      { notCheckable = true; text = L["Report"], func = function() MayronUI:TriggerCommand("report") end};
    }
  });

  return menuList;
end

function C_MiniMapModule:OnInitialize(data)
  if (db.profile.minimap.testMode) then
    db.profile.minimap.testMode = false;
  end

  self:RegisterUpdateFunctions(db.profile.minimap, {
		size = function(value)
			Minimap:SetSize(value, value);
			Minimap_ZoomIn();
			Minimap_ZoomOut();
		end;

		scale = function(value)
			Minimap:SetScale(value);
		end;

    widgets = function()
      data:Call("SetUpWidgets");
    end;

    testMode = function()
      data:Call("SetUpWidgets");
    end
  }, {
    onExecuteAll = {
      ignore = {
        "widgets";
      };
    };
  });
end

function C_MiniMapModule:OnInitialized(data)
  if (data.settings.enabled) then
    self:SetEnabled(true);
  end
end

function C_MiniMapModule:OnEnable(data)
	Minimap:ClearAllPoints();
	Minimap:SetPoint(data.settings.point, _G.UIParent, data.settings.relativePoint, data.settings.x, data.settings.y);
	Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground'); -- make rectangle

  if (tk:IsRetail()) then
    Minimap:SetArchBlobRingScalar(0);
    Minimap:SetQuestBlobRingScalar(0);
  end

  _G.MinimapCluster:ClearAllPoints();
  _G.MinimapCluster:SetPoint("TOPLEFT", Minimap);
  _G.MinimapCluster:SetPoint("BOTTOMRIGHT", Minimap);
	_G.MinimapBorder:Hide();
	_G.MinimapBorderTop:Hide();
	_G.MinimapZoomIn:Hide();
	_G.MinimapZoomOut:Hide();
	_G.GameTimeFrame:Hide();
	_G.MiniMapWorldMapButton:Hide();
  _G.MinimapNorthTag:SetTexture("");

  if (_G.MinimapToggleButton) then
    tk:KillElement(_G.MinimapToggleButton);
  end

  Minimap:EnableMouseWheel(true);
  if (_G.BackdropTemplateMixin) then
    _G.Mixin(Minimap, _G.BackdropTemplateMixin);
    Minimap:OnBackdropLoaded();
    Minimap:SetScript("OnSizeChanged", Minimap.OnBackdropSizeChanged);
  end

	Minimap.size = Minimap:CreateFontString(nil, "ARTWORK");
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
		GameTooltip:AddDoubleLine(L["Right Click:"], L["Show Menu"], 1, 1, 1);
		GameTooltip:AddDoubleLine(L["Mouse Wheel:"], L["Zoom in/out"], 1, 1, 1);
		GameTooltip:AddDoubleLine(L["ALT + Left Click:"], L["Toggle this Tooltip"], 1, 0, 0, 1, 0, 0);
		GameTooltip:Show();
	end);

	Minimap:HookScript("OnMouseDown", function(self, button)
		if ((IsAltKeyDown()) and (button == "LeftButton")) then
			local tracker = data.settings:GetTrackedTable();

			if (tracker.Tooltip) then
				tracker.Tooltip = nil;
				Minimap:GetScript("OnEnter")(Minimap);
			else
				tracker.Tooltip = true;
				GameTooltip:Hide();
			end

			tracker:SaveChanges();
		end
	end);

  if (tk:IsRetail()) then
    local eventBtn = CreateFrame("Button", nil, Minimap);
    eventBtn:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, -18);
    eventBtn:SetSize(100, 20);
    eventBtn:SetNormalFontObject("GameFontNormal");
    eventBtn:SetHighlightFontObject("GameFontHighlight");
    eventBtn:Hide();

    eventBtn:SetScript("OnClick", function()
      if (not _G.CalendarFrame) then
          LoadAddOn("Blizzard_Calendar");
      end
      _G.Calendar_Toggle();
    end);

    eventBtn:RegisterEvent('CALENDAR_UPDATE_PENDING_INVITES');
    eventBtn:RegisterEvent('CALENDAR_ACTION_PENDING');
    eventBtn:RegisterEvent('PLAYER_ENTERING_WORLD');
    eventBtn:SetScript('OnEvent',function(self)
      local numPendingInvites = _G.C_Calendar.GetNumPendingInvites();

      if (numPendingInvites > 0) then
        self:SetText(strformat("%s (%i)", L["New Event!"], numPendingInvites));
        self:Show();
      else
        self:SetText("");
        self:Hide();
      end
    end);
  end

	-- Drop down List:
  data.menuList = self:GetRightClickMenuList();
  data:Call("UpdateTrackingMenuOptionVisibility");

  local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate");
	Minimap.oldMouseUp = Minimap:GetScript("OnMouseUp");

	Minimap:SetScript("OnMouseUp", function(self, btn)
		if (btn == "RightButton") then
			EasyMenu(data.menuList, menuFrame, "cursor", 0, 0, "MENU", 1);
      PlaySound(tk.Constants.CLICK);
		else
			self.oldMouseUp(self);
		end
	end);
end
