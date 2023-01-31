-- luacheck: ignore MayronUI self 143
local addOnName = ...;
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

-- Register and Import ---------

---@class MiniMapModule : BaseModule
local C_MiniMapModule = MayronUI:RegisterModule("MiniMap", L["Mini-Map"]);

local Minimap, math, table, C_Timer, Minimap_ZoomIn, Minimap_ZoomOut,
      GameTooltip, IsAltKeyDown, LoadAddOn, IsAddOnLoaded,
      ToggleDropDownMenu, PlaySound, EasyMenu, select = _G.Minimap,
  _G.math, _G.table, _G.C_Timer, _G.Minimap_ZoomIn, _G.Minimap_ZoomOut,
  _G.GameTooltip, _G.IsAltKeyDown, _G.LoadAddOn,
  _G.IsAddOnLoaded, _G.ToggleDropDownMenu, _G.PlaySound, _G.EasyMenu, _G.select;

local IsInInstance, GetInstanceInfo, GetNumGroupMembers, ipairs =
  _G.IsInInstance, _G.GetInstanceInfo, _G.GetNumGroupMembers, _G.ipairs;

local ShowGarrisonLandingPage, strformat = _G.ShowGarrisonLandingPage, _G.string.format;

local C_Garrison, C_Covenants = _G.C_Garrison, _G.C_Covenants;

do
  local backdrop = _G.MinimapBackdrop;
  backdrop:ClearAllPoints();
  backdrop:SetPoint("TOPLEFT", Minimap);
  backdrop:SetPoint("BOTTOMRIGHT", Minimap);
  backdrop.ClearAllPoints = tk.Constants.DUMMY_FUNC;
  backdrop.SetPoint = tk.Constants.DUMMY_FUNC;
  backdrop.SetAllPoints = tk.Constants.DUMMY_FUNC;
end

local function HideMenu()
  if (obj:IsWidget(_G.DropDownList1)) then
    _G.DropDownList1:Hide();
  end

  if (obj:IsWidget(_G.DropDownList2)) then
    _G.DropDownList2:Hide();
  end
end

local function CanViewMissions()
  local garrisonType = C_Garrison.GetLandingPageGarrisonType();

  if (garrisonType == 111) then
    local covenantData = C_Covenants.GetCovenantData(C_Covenants.GetActiveCovenantID());
    return covenantData ~= nil;
  end

  return false;
end

-- Load Database Defaults --------------

db:AddToDefaults("profile.minimap", {
  enabled = true;
  point = "TOPRIGHT";
  relativePoint = "TOPRIGHT";
  x = -4;
  y = -4;
  size = 200;
  scale = 1;
  hideIcons = true;
  testMode = false; -- for testing

  widgets = {
    clock = {
      hide = false;
      fontSize = 12;
      point = "BOTTOMRIGHT";
      x = 0;
      y = tk:IsRetail() and 4 or 0
    };

    difficulty = {
      show = true;
      fontSize = 12;
      point = "TOPRIGHT";
      x = -8;
      y = -8;
    };

    lfg = { scale = 0.9; point = "BOTTOMLEFT"; x = 22; y = 0 };

    mail = {
      scale = 1;
      point = "BOTTOMRIGHT";
      x = -8;
      y = 22
    };

    missions = { hide = false; scale = 0.6; point = "TOPLEFT"; x = -8; y = 2 };

    tracking = {
      hide = false;
      scale = (tk:IsRetail() and 1.2 or 0.8);
      point = "BOTTOMLEFT";
      x = tk:IsRetail() and 2 or 0;
      y = tk:IsRetail() and 4 or 2;
    };

    zone = { hide = true; point = "TOP"; fontSize = 10; x = 0; y = -4 };
  };
});

local Minimap_OnDragStart;
local Minimap_OnDragStop;

do
  local updateSizeText;

  local function OnResizeDragStep()
    local width = Minimap:GetWidth();
    width = (math.floor(width + 100.5) - 100);
    Minimap:SetSize(width, width);

    if (not updateSizeText) then
      Minimap.size:SetText("");
    else
      Minimap.size:SetText(width .. " x " .. width);
    end

    C_Timer.After(0.02, OnResizeDragStep);
  end

  function Minimap_OnDragStart()
    if (tk:IsModComboActive("C")) then
      if (Minimap:IsMovable()) then
        Minimap:StartMoving();
      end
    elseif (tk:IsModComboActive("S")) then
      Minimap:StartSizing();
      updateSizeText = true;
      C_Timer.After(0.1, OnResizeDragStep);
    end
  end

  function Minimap_OnDragStop(data)
    Minimap:StopMovingOrSizing();
    updateSizeText = nil;

    Minimap_ZoomIn();
    Minimap_ZoomOut();

    local width = Minimap:GetWidth();
    width = math.floor(width + 0.5);

    if (width % 2 > 0) then
      width = width + 1;
    end

    Minimap:SetSize(width, width);

    local settings = data.settings:GetTrackedTable();
    local relativeTo;

    settings.size = width;
    settings.point, relativeTo, settings.relativePoint, settings.x, settings.y =
      Minimap:GetPoint();

    local x = math.floor(settings.x + 0.5);
    local y = math.floor(settings.y + 0.5);

    if (x % 2 > 0) then
      x = x + 1;
    end

    if (y % 2 > 0) then
      y = y + 1;
    end

    settings.x = x;
    settings.y = y;

    Minimap:SetPoint(
      settings.point, relativeTo or _G.UIParent, settings.relativePoint,
        settings.x, settings.y);

    settings:SaveChanges();
  end
end

local callback;
callback = tk:HookFunc("BattlefieldMap_LoadUI", function()
    if (IsAddOnLoaded("Blizzard_BattlefieldMap") and _G.BattlefieldMapFrame) then
      local updateSize;
      local originalWidth, originalHeight = 298, 199;
      local mapFrame, mapTab, mapOptions = _G.BattlefieldMapFrame,
        _G.BattlefieldMapTab, _G.BattlefieldMapOptions;
      local previousWidth;
      local GetMinimapZoneText = _G.GetMinimapZoneText;

      local function DragStep()
        if (not updateSize) then
          return
        end
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

        gui:AddResizer(self);
        self.dragger:SetParent(self.BorderFrame);

        if (obj:IsFunction(self.SetMinResize)) then
          self:SetMinResize(originalWidth, originalHeight);
          self:SetMaxResize(1200, 800);
        else
          -- dragonflight:
          self:SetResizeBounds(originalWidth, originalHeight, 1200, 800);
        end

        gui:AddTitleBar(self, GetMinimapZoneText());
        self.titleBar:SetFrameStrata("HIGH");
        self.titleBar:RegisterForClicks("RightButtonUp");
        self.titleBar:SetScript(
          "OnClick", function(self, button)
            if (button == "RightButton") then
              PlaySound(tk.Constants.CLICK);

              -- If Rightclick bring up the options menu
              if (button == "RightButton") then
                local function InitializeOptionsDropDown(self)
                  self:GetParent():InitializeOptionsDropDown();
                end
                _G.UIDropDownMenu_Initialize(
                  mapTab.OptionsDropDown, InitializeOptionsDropDown, "MENU");
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

        self.dragger:HookScript(
          "OnDragStop", function()
            container:ZoomIn();
            container:ZoomOut();
            updateSize = nil;
          end);

        self.dragger:HookScript(
          "OnDragStart", function()
            updateSize = true;
            C_Timer.After(0.1, DragStep);
          end);

        self.reskinned = true;
      end

      mapFrame:SetFrameStrata("MEDIUM");
      mapFrame:HookScript("OnShow", update);
      mapFrame:HookScript(
        "OnEvent", function(self)
          if (self.titleBar) then
            self.titleBar.text:SetText(GetMinimapZoneText());
          end
        end);

      local bg = gui:CreateDialogBox(mapFrame, "HIGH", nil, "MUI_ZoneMap");
      bg:SetAllPoints(true);
      bg:SetFrameStrata("LOW");
      bg:SetAlpha(1.0 - mapOptions.opacity);

      tk:HookFunc(
        mapFrame, "RefreshAlpha", function()
          local alpha = 1.0 - mapOptions.opacity;
          bg:SetAlpha(1.0 - mapOptions.opacity);
          mapFrame.titleBar:SetAlpha(math.max(alpha, 0.3));
        end);

      mapFrame.BorderFrame.CloseButtonBorder:SetTexture("");
      mapFrame.BorderFrame.CloseButton:SetPoint(
        "TOPRIGHT", mapFrame.BorderFrame, "TOPRIGHT", 5, 5);
      tk:UnhookFunc("BattlefieldMap_LoadUI", callback);
    end
  end);

do
  local widgetMethods = {};
  local positioningMethods = {"SetParent"; "ClearAllPoints"; "SetPoint"; "SetScale"};
  local visibilityMethods = {"Show"; "Hide"; "SetShown"};

  function C_MiniMapModule.Private:SetUpWidget(data, name, widget)
    obj:Assert(widget, "Failed to setup minimap widget %s.", name);

    local methods = widgetMethods[name];
    local settings = data.settings.widgets[name];

    obj:Assert(obj:IsTable(settings),
      "Mini-Map widget settings not found with key '%s'.", name);

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

    if (data.testModeActive) then
      return
    end

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
          local missionsListener = em:CreateEventListener(function()
            if (CanViewMissions()) then
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

  local function SetDungeonDifficultyShown(data)
    if (not (tk:IsRetail() or tk:IsWrathClassic())) then
      return
    end

    local widgets = data.settings.widgets;

    if (not data.dungeonDifficulty and not widgets.difficulty.show) then
      return
    end

    if (not data.dungeonDifficulty) then
      data.dungeonDifficulty = Minimap:CreateFontString(nil, "OVERLAY");

      local listener = em:CreateEventListenerWithID("DungeonDifficultyText", function()
        if (not IsInInstance()) then
          data.dungeonDifficulty:SetText("");
          return
        end

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
      end);

      listener:RegisterEvents(
        "PLAYER_DIFFICULTY_CHANGED",
        "UPDATE_INSTANCE_INFO",
        "GROUP_ROSTER_UPDATE");
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
        tk:KillElement(_G.QueueStatusMinimapButtonBorder);

        data.reskinnedLFG = true;
      end

      if (_G.QueueStatusMinimapButton) then
        data:Call("SetUpWidget", "lfg", _G.QueueStatusMinimapButton);
      end
    elseif (_G.MiniMapLFGFrame) then
      if (not data.reskinnedLFG) then
        local border = _G.MiniMapLFGBorder or _G.MiniMapLFGFrameBorder;
        if (obj:IsWidget(border)) then
          tk:KillElement(border);
        end
        data.reskinnedLFG = true;
      end
      data:Call("SetUpWidget", "lfg", _G.MiniMapLFGFrame);
    end

    local mailFrame = _G.MiniMapMailFrame or _G.MinimapCluster.MailFrame;
    if (mailFrame) then
      -- dragonflight removed all this:
      data:Call("SetUpWidget", "mail", mailFrame);
      mailFrame:SetSize(18, 13);
      mailFrame:SetAlpha(0.9);

      if (_G.MiniMapMailBorder) then
        _G.MiniMapMailBorder:Hide();
      end

      local icon = _G.MiniMapMailIcon;

      if (obj:IsWidget(icon) and icon:GetObjectType() == "Texture") then
        icon:ClearAllPoints();
        icon:SetAllPoints(mailFrame);
        icon:SetTexture(tk:GetAssetFilePath("Icons\\mail"));
      end
    end

    local missionBtn = _G.ExpansionLandingPageMinimapButton or _G.GarrisonLandingPageMinimapButton;
    -- missions icon:
    if (tk:IsRetail() and obj:IsWidget(missionBtn)) then
      -- dragonflight removed this:
      data:Call("SetUpWidget", "missions", missionBtn);
      -- prevents popup from showing:
      missionBtn:DisableDrawLayer("OVERLAY");
      missionBtn:DisableDrawLayer("BORDER");
      missionBtn.SideToastGlow:SetTexture("");
    end

    -- tracking:
    local tracking = _G.MiniMapTracking or _G.MinimapCluster.Tracking;

    if (not tk:IsClassic() and obj:IsWidget(tracking)) then
      if (obj:IsWidget(_G.MiniMapTrackingIcon)) then
          tk:KillElement(_G.MiniMapTrackingIconOverlay);
        _G.MiniMapTrackingIcon:SetPoint("CENTER", 0, 0);
      end

      tk:KillElement(_G.MiniMapTrackingBorder or _G.MiniMapTrackingButtonBorder);
      tk:KillElement(_G.MiniMapTrackingBackground or _G.MinimapCluster.Tracking.Background);

      local border = _G.MiniMapTrackingBorder or _G.MiniMapTrackingButtonBorder;
      if (obj:IsWidget(border)) then
        tk:KillElement(border);
      end

      data:Call("SetUpWidget", "tracking", tracking);
    end

    -- zone:
    local zoneBtn = _G.MinimapZoneTextButton or (_G.MinimapCluster and _G.MinimapCluster.ZoneTextButton);

    if (zoneBtn) then
      data:Call("SetUpWidget", "zone", zoneBtn);
    end

    SetUpWidgetText(_G.MinimapZoneText, widgets.zone);
    _G.MinimapZoneText:ClearAllPoints();
    _G.MinimapZoneText:SetAllPoints(true);
  end
end

function C_MiniMapModule.Private:UpdateTrackingMenuOptionVisibility(data)
  if (not _G.MiniMapTracking) then
    return
  end
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
    table.insert(
      data.menuList, 1, {
        text = L["Tracking Menu"];
        notCheckable = true;
        func = function()
          ToggleDropDownMenu(1, nil, _G.MiniMapTrackingDropDown, "MiniMapTracking", 0, -5);
          PlaySound(tk.Constants.CLICK);
        end;
      });
  end
end

function C_MiniMapModule:GetRightClickMenuList()
  local menuList = obj:PopTable();

  if (tk:IsRetail() or tk:IsWrathClassic()) then
    table.insert(menuList, {
      text = L["Calendar"];
      notCheckable = true;
      func = function()
        if (not _G["CalendarFrame"]) then
          LoadAddOn("Blizzard_Calendar");
        end
        _G.Calendar_Toggle();
      end;
    });
  end

  if (tk:IsRetail()) then
    local listItem = {
      notCheckable = true;
      func = function()
        if (CanViewMissions()) then
          ShowGarrisonLandingPage(111);
        else
          MayronUI:Print(L["You must be a member of a covenant to view this."]);
        end
      end;
    };

    table.insert(menuList, listItem);

    local function LoadMissionsListItem()
      if (not CanViewMissions()) then
        return false;
      end

      listItem.text = L["Covenant Sanctum"];

      return true;
    end

    if (not LoadMissionsListItem()) then
      em:CreateEventListener(function(self)
        if (LoadMissionsListItem()) then
          self:Destroy();
        end
      end):RegisterEvent("GARRISON_UPDATE");
    end
  end

  local function TriggerCommand(_, arg1, arg2)
    MayronUI:TriggerCommand(arg1, arg2);
    HideMenu();
  end

  table.insert(menuList, {
    text = tk.Strings:SetTextColorByTheme("MayronUI");
    notCheckable = true;
    keepShownOnClick = true;
    hasArrow = true;
    menuList = {
      {
        notCheckable = true;
        text = L["Config Menu"];
        arg1 = "config";
        func = TriggerCommand;
      }; {
        notCheckable = true;
        text = L["Install"];
        arg1 = "install";
        func = TriggerCommand;
      }; {
        notCheckable = true;
        text = L["Layouts"];
        arg1 = "layouts";
        func = TriggerCommand;
      }; {
        notCheckable = true;
        text = L["Profile Manager"];
        arg1 = "profiles";
        func = TriggerCommand;
      }; {
        notCheckable = true;
        text = L["Show Profiles"];
        arg1 = "profiles";
        arg2 = "list";
        func = TriggerCommand;
      }; {
        notCheckable = true;
        text = L["Version"];
        arg1 = "version";
        func = TriggerCommand;
      }; {
        notCheckable = true;
        text = L["Report"];
        arg1 = "report";
        func = TriggerCommand;
      };
    };
  });

  local libDbIcons = _G.LibStub("LibDBIcon-1.0");

  if (obj:IsTable(libDbIcons) and db.profile.minimap.hideIcons) then
    local knownAddOnsText = {
      ["Leatrix_Plus"] = tk.Strings:SetTextColorByHex("Leatrix Plus", "70db70");
      ["Questie"] = tk.Strings:SetTextColorByHex("Questie", "ffc50f");
      ["Details"] = tk.Strings:SetTextColorByHex("Details", "ffb8b8");
      ["Bartender4"] = tk.Strings:SetTextColorByHex("Bartender4", "ee873a");
      ["DBM"] = tk.Strings:SetTextColorByHex("Deadly Boss Mods", "ff5656");
      ["RareScannerMinimapIcon"] = tk.Strings:SetTextColorByHex(
        "Rare Scanner", "ff0f6f");
      ["Plater"] = tk.Strings:SetTextColorByHex("Plater", "e657ff");
      ["BigWigs"] = tk.Strings:SetTextColorByHex("BigWigs Bossmods", "ff5656");
      ["TradeSkillMaster"] = tk.Strings:SetTextColorByHex(
        "Trade Skill Master", "a05ff4");
      ["WeakAuras"] = tk.Strings:SetTextColorByHex("Weak Auras", "9900ff");
      ["HealBot"] = tk.Strings:SetTextColorByHex("HealBot", "3af500");
      ["AtlasLoot"] = tk.Strings:SetTextColorByHex("Atlas Loot", "f0c092");
    };

    local function MoveAddonIconToMenu(name)
      local iconButton = libDbIcons:GetMinimapButton(name);
      iconButton:Hide();

      local customBtn = tk:CreateFrame(
        "Button", nil, "MUI_MinimapButton_" .. name, "UIDropDownCustomMenuEntryTemplate");
      customBtn:Hide();

      customBtn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");

      local height = _G.UIDROPDOWNMENU_BUTTON_HEIGHT;
      customBtn:SetHeight(height);

      customBtn.icon = customBtn:CreateTexture(nil, "ARTWORK");
      customBtn.icon:SetSize(height, height);
      customBtn.icon:SetTexture(iconButton.icon:GetTexture());
      customBtn.icon:SetPoint("RIGHT", 0, 0);

      local fs = customBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
      fs:SetPoint("LEFT", 4, 0);
      fs:SetText(knownAddOnsText[name] or name);
      fs:SetJustifyH("LEFT");
      customBtn:SetWidth(fs:GetUnboundedStringWidth() + height + 10);

      customBtn:SetScript("OnShow", function()
        customBtn:SetPoint("RIGHT", -14, 0);
      end);

      customBtn:SetScript("OnEnter", function()
        local list = customBtn:GetParent();
        list.showTimer = nil; -- prevents hiding tooltip after 2 seconds

        if (obj:IsWidget(_G.DropDownList2)) then
          _G.DropDownList2:Hide();
        end

        if (obj:IsFunction(iconButton.dataObject.OnTooltipShow)) then
          GameTooltip:SetOwner(list, "ANCHOR_BOTTOM", 0, -2);
          iconButton.dataObject.OnTooltipShow(GameTooltip);
          GameTooltip:Show();

        elseif (obj:IsFunction(iconButton.dataObject.OnEnter)) then
          iconButton.dataObject.OnEnter(iconButton);
        end
      end);

      iconButton.Show = function()
        local entry = tk.Tables:First(menuList, function(value)
          return value.customFrame == customBtn;
        end);

        entry.text = name;
        HideMenu();
      end

      iconButton.Hide = function()
        local entry = tk.Tables:First(menuList, function(value)
          return value.customFrame == customBtn;
        end);

        entry.text = nil;
        HideMenu();
      end

      customBtn:SetScript("OnLeave", function()
        GameTooltip:Hide();

        if (obj:IsFunction(iconButton.dataObject.OnLeave)) then
          iconButton.dataObject.OnLeave(iconButton);
        end
      end);

      customBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp");

      customBtn:SetScript("OnClick", function(_, buttonName)
        if (obj:IsFunction(iconButton.dataObject.OnClick)) then
          iconButton.dataObject.OnClick(iconButton, buttonName);
        end

        HideMenu();
      end);

      table.insert(menuList, { text = name; customFrame = customBtn });
    end

    for _, iconName in ipairs(libDbIcons:GetButtonList()) do
      MoveAddonIconToMenu(iconName);
    end

    libDbIcons.RegisterCallback(addOnName, "LibDBIcon_IconCreated",
      function(_, _, iconName)
        MoveAddonIconToMenu(iconName);
      end);
  end

  return menuList;
end

function C_MiniMapModule:OnInitialize(data)
  if (db.profile.minimap.testMode) then
    db.profile.minimap.testMode = false;
  end

  self:RegisterUpdateFunctions(
    db.profile.minimap, {
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
      end;
    }, { onExecuteAll = { ignore = { "widgets" } } });
end

function C_MiniMapModule:OnInitialized(data)
  if (data.settings.enabled) then
    self:SetEnabled(true);
  end
end

function C_MiniMapModule:OnEnable(data)
  if (obj:IsWidget(_G.MinimapBorder)) then
    tk:KillElement(_G.MinimapBorder);
    tk:KillElement(_G.MinimapBorderTop);
    tk:KillElement(_G.MinimapZoomIn);
    tk:KillElement(_G.MinimapZoomOut);
    tk:KillElement(_G.MinimapNorthTag);
  end

  if (tk:IsRetail() and obj:IsWidget(_G.MinimapCluster) and obj:IsWidget(_G.MinimapCluster.BorderTop)) then
    _G.MinimapCluster.BorderTop:Hide();
    tk:KillElement(_G.MinimapCompassTexture);
    tk:KillElement(_G.Minimap.ZoomIn);
    tk:KillElement(_G.Minimap.ZoomOut);
    tk:KillElement(_G.MinimapCluster.BorderTop);
  end

  _G.GameTimeFrame:Hide();

  tk:KillElement(_G.MiniMapWorldMapButton);

  if (_G.MinimapToggleButton) then
    tk:KillElement(_G.MinimapToggleButton);
  end

  if (_G.BackdropTemplateMixin) then
    _G.Mixin(Minimap, _G.BackdropTemplateMixin);
    Minimap:OnBackdropLoaded();
    Minimap:SetScript("OnSizeChanged", Minimap.OnBackdropSizeChanged);
  end

  Minimap.size = Minimap:CreateFontString(nil, "ARTWORK");
  Minimap.size:SetFontObject("GameFontNormalLarge");
  Minimap.size:SetPoint("TOP", Minimap, "BOTTOM", 0, 40);

  Minimap:ClearAllPoints();
  Minimap:SetPoint(data.settings.point, _G.UIParent, 
    data.settings.relativePoint, data.settings.x, data.settings.y);

  _G.MinimapCluster:EnableMouse(false);

  Minimap:SetMaskTexture("Interface\\ChatFrame\\ChatFrameBackground"); -- make rectangle
  Minimap:EnableMouse(true);
  Minimap:EnableMouseWheel(true);
  Minimap:SetResizable(true);
  Minimap:SetMovable(true);
  Minimap:SetUserPlaced(true);
  Minimap:RegisterForDrag("LeftButton");

  if (obj:IsFunction(Minimap.SetMinResize)) then
    Minimap:SetMinResize(120, 120);
    Minimap:SetMaxResize(400, 400);
  else
    -- dragonflight:
    Minimap:SetResizeBounds(120, 120, 400, 400);
  end

  Minimap:SetClampedToScreen(true);
  Minimap:SetClampRectInsets(-3, 3, 3, -3);

  if (tk:IsRetail()) then
    Minimap:SetArchBlobRingScalar(0);
    Minimap:SetQuestBlobRingScalar(0);
  end

  Minimap:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark";
    edgeFile = tk:GetAssetFilePath("Borders\\Solid.tga");
    edgeSize = 1;
  });

  Minimap:SetBackdropBorderColor(0, 0, 0);

  Minimap:SetScript("OnMouseWheel", function(_, value)
      if (value > 0) then
        (_G.MinimapZoomIn or _G.Minimap.ZoomIn):Click();
      elseif (value < 0) then
        (_G.MinimapZoomOut or _G.Minimap.ZoomOut):Click();
      end
    end);

  Minimap:SetScript("OnDragStart", Minimap_OnDragStart);
  Minimap:SetScript("OnDragStop", function()
    Minimap_OnDragStop(data)
  end);

  Minimap:HookScript("OnEnter", function(self)
    if (data.settings.Tooltip) then
      -- helper tooltip (can be hidden)
      return
    end

    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -2)
    GameTooltip:SetText("MUI MiniMap"); -- This sets the top line of text, in gold.
    GameTooltip:AddDoubleLine(L["CTRL + Drag:"], L["Move Minimap"], 1, 1, 1);
    GameTooltip:AddDoubleLine(
      L["SHIFT + Drag:"], L["Resize Minimap"], 1, 1, 1);
    GameTooltip:AddDoubleLine(L["Left Click:"], L["Ping Minimap"], 1, 1, 1);
    GameTooltip:AddDoubleLine(L["Right Click:"], L["Show Menu"], 1, 1, 1);
    GameTooltip:AddDoubleLine(L["Mouse Wheel:"], L["Zoom in/out"], 1, 1, 1);
    GameTooltip:AddDoubleLine(
      L["ALT + Left Click:"], L["Toggle this Tooltip"], 1, 0, 0, 1, 0, 0);
    GameTooltip:Show();
  end);

  Minimap:HookScript("OnMouseDown", function(_, button)
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

  if (tk:IsRetail() or tk:IsWrathClassic()) then
    local eventBtn = tk:CreateFrame("Button", Minimap);
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

    eventBtn:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES");
    eventBtn:RegisterEvent("CALENDAR_ACTION_PENDING");
    eventBtn:RegisterEvent("PLAYER_ENTERING_WORLD");
    eventBtn:SetScript("OnEvent", function(self)
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

  local menuFrame = tk:CreateFrame("Frame", nil, "MinimapRightClickMenu", "UIDropDownMenuTemplate");
  Minimap.oldMouseUp = Minimap:GetScript("OnMouseUp");

  Minimap:SetScript("OnMouseUp", function(self, btn)
    if (btn == "RightButton") then
      EasyMenu(data.menuList, menuFrame, "cursor", 0, 0, "MENU", 1);
      PlaySound(tk.Constants.CLICK);
    else
      HideMenu();
      self.oldMouseUp(self);
    end
  end);
end
