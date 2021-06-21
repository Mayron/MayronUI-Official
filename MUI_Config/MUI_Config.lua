-- luacheck: ignore self 143 631
local _, namespace = ...;
local MayronUI = _G.MayronUI;
local tk, _, _, gui, obj, L = MayronUI:GetCoreComponents();

local MENU_BUTTON_HEIGHT = 40;
local pairs, ipairs, table, mrandom, setmetatable = _G.pairs, _G.ipairs, _G.table, _G.math.random, _G.setmetatable;
local DisableAddOn, collectgarbage, UIFrameFadeIn, CreateFrame, PlaySound, strformat
 = _G.DisableAddOn, _G.collectgarbage, _G.UIFrameFadeIn, _G.CreateFrame, _G.PlaySound, _G.string.format;

-- Registers and Imports -------------
---@type LinkedList
local C_LinkedList = obj:Import("Pkg-Collections.LinkedList");

---@class ConfigModule : BaseModule
local C_ConfigModule = MayronUI:RegisterModule("ConfigModule");
namespace.C_ConfigModule = C_ConfigModule;

-- Local functions -------------------
local CreateTopMenuButton;

do
  local menuButtons = {};

  function CreateTopMenuButton(label, onClick, anchor)
    local btn = gui:CreateButton(tk.Constants.AddOnStyle, nil, label);
    btn.padding = 60;

    if (anchor) then
      btn:SetPoint("RIGHT", anchor, "RIGHT");
      btn:SetParent(anchor);
    else
      btn:SetPoint("RIGHT", menuButtons[#menuButtons], "LEFT", -10, 0);
      btn:SetParent(menuButtons[#menuButtons]);
    end

    btn:SetScript("OnClick", function()
      onClick();
      PlaySound(tk.Constants.CLICK);
    end);

    table.insert(menuButtons, btn);

    return btn;
  end
end

local function MenuButton_OnClick(menuButton)
  if (menuButton:IsObjectType("CheckButton") and not menuButton:GetChecked()) then
    -- should not be allowed to uncheck a menu button by clicking it a second time!
    menuButton:SetChecked(true);
    return;
  end

  local configModule = MayronUI:ImportModule("ConfigModule");
  configModule:OpenMenu(menuButton);
end

local function SetBackButtonEnabled(backBtn, enabled)
  backBtn:SetEnabled(enabled);

  if (enabled) then
    tk:ApplyThemeColor(backBtn.arrow);
  else
    local r, g, b = tk.Constants.COLORS.GRAY:GetRGB();
    backBtn.arrow:SetVertexColor(r, g, b, 1);
  end
end

local function IsUnsupportedByClient(client)
  if (not client) then return false; end

  if (obj:IsTable(client)) then
    for _, c in ipairs(client) do
      if (not IsUnsupportedByClient(c)) then
        return false;
      end
    end

    return true;
  end

  if (client == "retail" and not tk:IsRetail()) then return true; end
  if (client == "classic" and not tk:IsClassic()) then return true; end
  if (client == "bcclassic" or client == "bcc" and not tk:IsBCClassic()) then return true; end

  return false;
end

local TransferWidgetAttributes;
do
  local map = {
    "dbPath", "name", "requiresReload", "requiresRestart", "module", "hasOwnDatabase",
    "valueType", "min", "max", "step", "OnClick", "data", "useIndexes", "OnPostSetValue",
    ["SetValue"] = "__SetValue";
  };

  function TransferWidgetAttributes(widget, widgetTable)
    for index, key in pairs(map) do
      if (obj:IsNumber(index)) then
        widget[key] = widgetTable[key];
      else
        widget[index] = widgetTable[key];
      end
    end

    if (widgetTable.type == "frame") then
      widget.children = widgetTable.children;
    end

    obj:PushTable(widgetTable);
  end
end

namespace.MenuButton_OnClick = MenuButton_OnClick;

-- C_ConfigModule -------------------
function C_ConfigModule:OnInitialize()
  if (not MayronUI:IsInstalled()) then
    tk:Print(L["Please install the UI and try again."]);
    return;
  end

  DisableAddOn("MUI_Config"); -- disable for next time
end

function C_ConfigModule:Show(data)
  if (not data.window) then
    local menuListScrollChild = self:SetUpWindow();
    self:SetUpSideMenu(menuListScrollChild);
  end

  data.window:Show();
  PlaySound(tk.Constants.MENU_OPENED_CLICK);
end

obj:DefineReturns("Database");
---@return Database
function C_ConfigModule:GetDatabase(data, tbl)
  local dbObject;
  local dbName = "CoreModule";

  tbl = data.tempMenuConfigTable or tbl;

  if (tbl) then
    if (tbl.hasOwnDatabase) then
      dbName = tbl.module;
    end

    dbObject = MayronUI:GetModuleComponent(dbName, "Database");
  end

  obj:Assert(dbObject, "Failed to get database object for module '%s'", dbName);

  return dbObject;
end


obj:DefineParams("table");
---@param widgetConfigTable table @A widget config table used to construct part of the config menu.
---@return any @A value from the database located by the dbPath value inside widgetConfigTable.
function C_ConfigModule:GetDatabaseValue(_, widgetConfigTable)
  local dbPath = widgetConfigTable.dbPath;

  if (obj:IsFunction(dbPath)) then
    dbPath = dbPath();
  end

  if (tk.Strings:IsNilOrWhiteSpace(dbPath)) then
    return widgetConfigTable.GetValue and widgetConfigTable.GetValue(widgetConfigTable);
  end

  local db = self:GetDatabase(widgetConfigTable);
  local value = db:ParsePathValue(dbPath);

  if (obj:IsTable(value) and value.GetUntrackedTable) then
    value = value:GetUntrackedTable();
  end

  if (widgetConfigTable.GetValue) then
    value = widgetConfigTable.GetValue(widgetConfigTable, value);
  end

  return value;
end

obj:DefineParams("table");
---Updates the database based on the dbPath config value, or using SetValue,
---@param widget table @The created widger frame.
---@param value any @The value to add to the database using the dbPath value attached to the widget table.
function C_ConfigModule:SetDatabaseValue(_, widget, newValue)
  local db = self:GetDatabase(widget);
  local oldValue;
  local dbPath = widget.dbPath;

  if (obj:IsFunction(dbPath)) then
    dbPath = dbPath();
  end

  if (not tk.Strings:IsNilOrWhiteSpace(dbPath)) then
    oldValue = db:ParsePathValue(dbPath);
  end

  if (widget.__SetValue) then
    widget.__SetValue(dbPath, newValue, oldValue, widget);
  else
    -- dbPath is required if not using a custom __SetValue function!
    if (widget.name and widget.name.IsObjectType and widget.name:IsObjectType("FontString")) then
      tk:Assert(not tk.Strings:IsNilOrWhiteSpace(dbPath),
        "%s is missing database path address element (dbPath) in config data.", widget.name:GetText());
    else
      tk:Assert(not tk.Strings:IsNilOrWhiteSpace(dbPath),
        "Unknown config data is missing database path address element (dbPath).");
    end

    db:SetPathValue(dbPath, newValue);
  end

  if (widget.OnPostSetValue) then
    widget.OnPostSetValue(dbPath, newValue, oldValue, widget);
  end

  if (widget.requiresReload) then
    self:ShowReloadMessage();
  elseif (widget.requiresRestart) then
    self:ShowRestartMessage();
  end
end

obj:DefineParams("CheckButton|Button");
---@param menuButton CheckButton|Button @The menu button clicked on associated with a menu.
function C_ConfigModule:OpenMenu(data, menuButton)
  if (menuButton.type == "menu") then
    data.history:Clear();
    SetBackButtonEnabled(data.window.back, false);

  elseif (menuButton.type == "submenu") then
    data.history:AddToBack(data.selectedButton);
    SetBackButtonEnabled(data.window.back, true);
  else
    tk:Error("Menu or Sub-Menu expected, got '%s'.", menuButton.type);
  end

  self:SetSelectedButton(menuButton);
end

function C_ConfigModule:RemoveWidget(data, widget)
  obj:Assert(data.selectedButton, "Failed to remove widget - No selected button.");
  obj:Assert(data.selectedButton.menu, "Failed to remove widget - No selected menu.");

  ---@type DynamicFrame
  local menu = data.selectedButton.menu;
  menu:RemoveChild(widget);
end

function C_ConfigModule:AddWidget(data, widget)
  obj:Assert(data.selectedButton, "Failed to add widget - No selected button.");
  obj:Assert(data.selectedButton.menu, "Failed to add widget - No selected menu.");

  ---@type DynamicFrame
  local menu = data.selectedButton.menu;
  menu:AddChildren(widget);
end

do
    local function CleanTablesPredicate(_, tbl, key)
        return (tbl.type ~= "submenu" and key ~= "options");
    end

    obj:DefineParams("CheckButton|Button");
    ---@param menuButton CheckButton|Button @The menu button clicked on associated with a menu.
    function C_ConfigModule:SetSelectedButton(data, menuButton)
      if (data.selectedButton) then
        -- hide old menu
        data.selectedButton.menu:Hide();
      end

      menuButton.menu = menuButton.menu or self:CreateMenu();
      data.selectedButton = menuButton;

      if (menuButton:IsObjectType("CheckButton")) then
        menuButton:SetChecked(true);
      end

      if (menuButton.configTable) then
        self:RenderSelectedMenu(menuButton.configTable);
        obj:PushTable(menuButton.configTable, CleanTablesPredicate);

        menuButton.configTable = nil;

        if (menuButton.module) then
          menuButton.module.configTable = nil;
        end
      end

      collectgarbage("collect");

      -- fade menu in...
      data.selectedButton.menu:Show();
      data.windowName:SetText(menuButton.name);

      UIFrameFadeIn(data.selectedButton.menu, 0.3, 0, 1);
      PlaySound(tk.Constants.CLICK);
    end
end

obj:DefineParams("table");
function C_ConfigModule:RenderWidget(data, config)
  if (config.type == "loop" or config.type == "condition") then
    -- run the loop to gather widget children
    local children = namespace.WidgetHandlers[config.type](
      data.selectedButton.menu:GetFrame(), config);

    for _, c in ipairs(children) do
      if (obj:IsTable(c) and not c.type) then
        for _, c2 in ipairs(c) do
          self:RenderWidget(c2);
        end

        obj:PushTable(c);
      else
        self:RenderWidget(c);
      end
    end

    -- the table was previously popped
    obj:PushTable(children);
    obj:PushTable(config);
    return
  end

  local widgetType = config.type; -- config gets deleted after SetUpWidget and type does not get mapped
  local widget = self:SetUpWidget(config);

  if (widgetType == "frame" and obj:IsTable(widget.children)) then
    local dynamicFrame = widget; ---@type DynamicFrame
    local frame = widget:GetFrame();

    for _, subWidgetConfigTable in ipairs(widget.children) do
      local childWidget = self:SetUpWidget(subWidgetConfigTable, frame);
      dynamicFrame:AddChildren(childWidget);
    end

    widget = frame;
  end

  data.selectedButton.menu:AddChildren(widget);
end

obj:DefineParams("table");
---@param menuConfigTable table @A table containing many widget config tables used to render a full menu.
function C_ConfigModule:RenderSelectedMenu(data, menuConfigTable)
  if (obj:IsFunction(menuConfigTable.children)) then
    menuConfigTable.children = menuConfigTable:children();
  end

  if (not obj:IsTable(menuConfigTable.children)) then return end

  data.tempMenuConfigTable = menuConfigTable;

  for _, widgetConfigTable in pairs(menuConfigTable.children) do
    if (not IsUnsupportedByClient(widgetConfigTable.client)) then
      self:RenderWidget(widgetConfigTable);
    end
  end

  if (data.tempMenuConfigTable.groups) then
    for _, group in pairs(data.tempMenuConfigTable.groups) do
      tk:GroupCheckButtons(group);
    end

    obj:PushTable(data.tempMenuConfigTable.groups);
  end

  data.tempMenuConfigTable = nil;
end

obj:DefineReturns("DynamicFrame");
---@return DynamicFrame @The dynamic frame which holds the menu frame and controls responsiveness and the scroll bar.
function C_ConfigModule:CreateMenu(data)
-- else, create a new menu (dynamic frame) to based on the module's config data
  local menuParent = data.options:GetFrame();
  local menu = gui:CreateDynamicFrame(tk.Constants.AddOnStyle, menuParent, 10, 10);
  local menuScrollFrame = menu:GetFrame();

  -- add graphical dialog box to dynamic frame:
  gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, "Low", menuScrollFrame);
  menuScrollFrame:SetAllPoints(true);

  return menu;
end

function C_ConfigModule:ShowReloadMessage(data)
    data.warningIcon:Show();
    data.warningLabel:SetText(data.warningLabel.reloadText);
end

function C_ConfigModule:ShowRestartMessage(data)
    data.warningIcon:Show();
    data.warningLabel:SetText(data.warningLabel.restartText);
end

local function ApplyMenuConfigTable(widgetConfig, menuConfig)
  local dbPath = menuConfig.dbPath;

  if (obj:IsFunction(dbPath)) then
    dbPath = dbPath();
  end

  if (not tk.Strings:IsNilOrWhiteSpace(dbPath) and
      not tk.Strings:IsNilOrWhiteSpace(widgetConfig.appendDbPath)) then

    -- append the widget config table's dbPath value onto it!
    obj:Assert(widgetConfig.dbPath == nil, "Cannot use both appendDbPath and dbPath on the same config table.");
    widgetConfig.dbPath = tk.Strings:Join(".", menuConfig.dbPath, widgetConfig.appendDbPath);
    widgetConfig.appendDbPath = nil;
  end

  if (not obj:IsTable(menuConfig.inherit)) then
    menuConfig.inherit = obj:PopTable();
    menuConfig.inherit.module = menuConfig.module;
    menuConfig.inherit.hasOwnDatabase = menuConfig.hasOwnDatabase;
  end

  if (not menuConfig.inherit.__index) then
    local metaTable = obj:PopTable();
    metaTable.__index = menuConfig.inherit;
    menuConfig.inherit = metaTable;
  end

  -- Inherit all key and value pairs from a menu table
  setmetatable(widgetConfig, menuConfig.inherit);
end

obj:DefineParams("table", "?Frame");
---@param widgetConfigTable table @A widget config table used to control the rendering and behavior of a widget in the config menu.
---@param parent Frame @(optional) A custom parent frame for the widget, else the parent will be the menu scroll child.
---@return Frame @(possibly nil if widget is disabled) The created widget.
function C_ConfigModule:SetUpWidget(data, widgetConfigTable, parent)
  if (not parent) then
    parent = data.selectedButton.menu:GetFrame();
    parent = parent.ScrollFrame:GetScrollChild();
  end

  if (obj:IsTable(data.tempMenuConfigTable)) then
    ApplyMenuConfigTable(widgetConfigTable, data.tempMenuConfigTable);
  end

  local widgetType = widgetConfigTable.type;

  -- treat the widget like a check button (except when grouping the check buttons)
  if (widgetType == "radio") then
    widgetType = "check";
  end

  tk:Assert(namespace.WidgetHandlers[widgetType],
    "Unsupported widget type '%s' found in config data for config table '%s'.",
  widgetType or "nil", widgetConfigTable.name or "nil");

  if (widgetConfigTable.OnInitialize) then
    -- do disabled widgets need to be initialized?
    widgetConfigTable.OnInitialize(widgetConfigTable);
    widgetConfigTable.OnInitialize = nil;
  end

  local currentValue = self:GetDatabaseValue(widgetConfigTable);

  -- create the widget (run the widget function)!
  local widget = namespace.WidgetHandlers[widgetType](parent, widgetConfigTable, currentValue);

  if (widgetConfigTable.devMode) then
    -- highlight the widget in dev mode.
    tk:SetBackground(widget, mrandom(), mrandom(), mrandom());
  end

  -- TODO: If using RenderWidget manually in config then this won't work
  if (data.tempMenuConfigTable and widgetConfigTable.type == "radio" and widgetConfigTable.groupName) then
    -- get groups[groupName] value from tempRadioButtonGroup
    local tempRadioButtonGroup = tk.Tables:GetTable(
    data.tempMenuConfigTable, "groups", widgetConfigTable.groupName);

    table.insert(tempRadioButtonGroup, widget.btn);
  end

  if (widgetConfigTable.disabled) then return end

  -- setup complete, so run the OnLoad callback if one exists
  if (widgetConfigTable.OnLoad) then
    widgetConfigTable.OnLoad(widgetConfigTable, widget, currentValue);
    widgetConfigTable.OnLoad = nil;
  end

  if (widgetType ~= "submenu") then
    TransferWidgetAttributes(widget, widgetConfigTable);
  end

  return widget;
end

function C_ConfigModule:SetUpWindow(data)
  if (data.window) then return end

  data.history = C_LinkedList();

  data.window = gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, nil, nil, "MUI_Config");
  data.window:SetFrameStrata("DIALOG");
  data.window:Hide();
  data.window:SetMinResize(600, 400);
  data.window:SetMaxResize(1200, 800);
  data.window:SetSize(800, 500);
  data.window:SetPoint("CENTER");

  gui:AddTitleBar(tk.Constants.AddOnStyle, data.window, "MUI " .. L["Config"]);
  gui:AddResizer(tk.Constants.AddOnStyle, data.window);
  gui:AddCloseButton(tk.Constants.AddOnStyle, data.window, nil, tk.Constants.CLICK);

  -- convert container to a panel
  data.window = gui:CreatePanel(data.window);
  data.window:SetDevMode(false); -- shows or hides the red frame info overlays
  data.window:SetDimensions(2, 3);
  data.window:GetColumn(1):SetFixed(200);
  data.window:GetRow(1):SetFixed(80);
  data.window:GetRow(3):SetFixed(50);

  data.window:SetScript("OnShow", function()
    -- fade in when shown
    UIFrameFadeIn(data.window, 0.3, 0, 1);
  end);

  local topbar = data.window:CreateCell();
  topbar:SetInsets(25, 14, 2, 10);
  topbar:SetDimensions(2, 1);

  local menuListContainer = gui:CreateScrollFrame(tk.Constants.AddOnStyle, data.window:GetFrame(), "MUI_ConfigSideBar");
  menuListContainer.ScrollBar:SetPoint("TOPLEFT", menuListContainer.ScrollFrame, "TOPRIGHT", -5, 0);
  menuListContainer.ScrollBar:SetPoint("BOTTOMRIGHT", menuListContainer.ScrollFrame, "BOTTOMRIGHT", 0, 0);

  local menuListCell = data.window:CreateCell(menuListContainer);
  menuListCell:SetInsets(2, 10, 10, 10);

  data.options = data.window:CreateCell();
  data.options:SetInsets(2, 14, 2, 2);

  local versionCell = data.window:CreateCell();
  versionCell:SetInsets(10, 10, 10, 10);

  versionCell.text = versionCell:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  versionCell.text:SetText(strformat("MUI_Core: %s   MUI_Config: %s   MUI_Setup: %s",
    tk:GetVersion("MUI_Core"), tk:GetVersion("MUI_Config"), tk:GetVersion("MUI_Setup")));
  versionCell.text:SetPoint("BOTTOMLEFT");

  local bottombar = data.window:CreateCell();
  bottombar:SetDimensions(2, 1);
  bottombar:SetInsets(10, 30, 10, 0);

  data.window:AddCells(topbar, menuListCell, data.options, versionCell, bottombar);

  data.warningIcon = bottombar:CreateTexture(nil, "ARTWORK");
  data.warningIcon:SetSize(20, 20);
  data.warningIcon:SetPoint("LEFT");
  data.warningIcon:SetTexture(_G.STATICPOPUP_TEXTURE_ALERT);
  data.warningIcon:Hide();

  data.warningLabel = bottombar:CreateFontString(nil, "OVERLAY", "GameFontNormal");
  data.warningLabel:SetPoint("LEFT", data.warningIcon, "RIGHT", 10, 0);
  data.warningLabel:SetText(tk.Strings.Empty);

  data.warningLabel.reloadText = L["The UI requires reloading to apply changes."];
  data.warningLabel.restartText = L["Some changes require a client restart to take effect."];

  -- forward and back buttons
  data.window.back = gui:CreateButton(tk.Constants.AddOnStyle, topbar:GetFrame());
  data.window.back:SetPoint("LEFT");
  data.window.back:SetWidth(50);
  data.window.back.arrow = data.window.back:CreateTexture(nil, "OVERLAY");
  data.window.back.arrow:SetTexture(tk:GetAssetFilePath("Textures\\Widgets\\SideArrow"));
  data.window.back.arrow:SetSize(16, 14);
  data.window.back.arrow:SetPoint("CENTER", -1, 0);

  data.window.back:SetScript("OnClick", function(backButton)
    local menuButton = data.history:GetBack();
    data.history:RemoveBack();

    self:SetSelectedButton(menuButton);

    if (data.history:GetSize() == 0) then
      data.windowName:SetText(menuButton.name);
      SetBackButtonEnabled(backButton, false);
    else
      local previousMenuButton = data.history:GetBack();
      data.windowName:SetText(previousMenuButton.name);
    end
  end);

  data.windowName = topbar:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
  data.windowName:SetPoint("LEFT", data.window.back, "RIGHT", 10, 0);
  SetBackButtonEnabled(data.window.back, false);

  -- profiles button
  data.window.profilesBtn = CreateTopMenuButton(L["Profiles"], function()
    if (data.selectedButton:IsObjectType("CheckButton")) then
        data.selectedButton:SetChecked(false);
    end

    self:ShowProfileManager();
  end, topbar:GetFrame());

  -- Layouts Button:
  data.window.layoutsBtn = CreateTopMenuButton(L["Layouts"], function()
    MayronUI:TriggerCommand("layouts");
    data.window:Hide();
  end);

  -- reload button
  local refreshButton = CreateFrame("Button", nil, data.window.layoutsBtn);
  refreshButton:SetSize(20, 20);
  refreshButton:SetPoint("RIGHT", data.window.layoutsBtn, "LEFT", -10, 0);
  refreshButton:SetNormalTexture(tk:GetAssetFilePath("Textures\\refresh"));
  refreshButton:GetNormalTexture():SetVertexColor(tk:GetThemeColor());
  refreshButton:SetHighlightAtlas("chatframe-button-highlight");

  local highlight = refreshButton:GetHighlightTexture();
  highlight:SetBlendMode("ADD");
  highlight:SetPoint("TOPLEFT", -4, 4);
  highlight:SetPoint("BOTTOMRIGHT", 4, -4);

  tk:SetBasicTooltip(refreshButton, L["Reload UI"]);
  refreshButton:SetScript("OnClick", _G.ReloadUI);

  local menuListScrollChild = menuListContainer.ScrollFrame:GetScrollChild();
  tk:SetFullWidth(menuListScrollChild);

  return menuListScrollChild;
end

do
  ---@param module BaseModule
  ---@param name string
  local function GetMenuButtonText(module, name)
    if (module) then
      return module:GetModuleName();
    else
      return name;
    end
  end

  local function AddMenuButton(menuButtons, menuConfigTable, menuListScrollChild)
    if (IsUnsupportedByClient(menuConfigTable.client)) then return end

    local module; ---@type BaseModule might be nil for some menus (e.g. General menu has no module)

    if (menuConfigTable.module) then
      module = MayronUI:ImportModule(menuConfigTable.module, true);
    end

    local menuButton = CreateFrame("CheckButton", nil, menuListScrollChild);
    menuButton.configTable = menuConfigTable;
    menuButton.id = menuConfigTable.id;
    menuButton.type = "menu";
    menuButton.module = module;
    menuButton.text = menuButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight");

    local menuText = GetMenuButtonText(module, menuConfigTable.name);

    -- If not menuText then an unknown module's config table tried to load by mistake.
    -- e.g. ObjectiveTrackerModule is not loaded in classic, but its config table is loaded.
    -- should not happen if client == "xxx" is used correctly.
    if (not menuText) then return end

    menuButton.name = menuText; -- this is needed for ordering the buttons

    menuButton.text:SetText(menuText);
    menuButton.text:SetJustifyH("LEFT");
    menuButton.text:SetPoint("TOPLEFT", 10, 0);
    menuButton.text:SetPoint("BOTTOMRIGHT");

    local normal = tk:SetBackground(menuButton, tk.Constants.SOLID_TEXTURE);
    local highlight = tk:SetBackground(menuButton, tk.Constants.SOLID_TEXTURE);
    local checked = tk:SetBackground(menuButton, tk.Constants.SOLID_TEXTURE);

    -- first argument is the alpha
    tk:ApplyThemeColor(0.3, normal, highlight);
    tk:ApplyThemeColor(0.6, checked);

    menuButton:SetSize(250, MENU_BUTTON_HEIGHT);
    menuButton:SetNormalTexture(normal);
    menuButton:SetHighlightTexture(highlight);
    menuButton:SetCheckedTexture(checked);
    menuButton:SetScript("OnClick", MenuButton_OnClick);

    menuButtons[menuText] = menuButton;
    table.insert(menuButtons, menuButton);
  end

  ---Loads all config data from individual modules and places them as a graphical menu
  ---@param menuListScrollChild Frame @The frame that holds all menu buttons in the left scroll frame.
  function C_ConfigModule:SetUpSideMenu(data, menuListScrollChild)
    data.menuButtons = {};

    -- contains all menu buttons in the left scroll frame of the main config window
    local scrollChildHeight = menuListScrollChild:GetHeight() + MENU_BUTTON_HEIGHT;
    menuListScrollChild:SetHeight(scrollChildHeight);

    for _, module in MayronUI:IterateModules() do

      if (module.GetConfigTable) then
        local configTable = module:GetConfigTable(self);

        if (#configTable == 0) then
          AddMenuButton(data.menuButtons, configTable, menuListScrollChild);
        else
          -- ConfigModule has multiple menu buttons
          for _, menuConfigTable in ipairs(configTable) do
            AddMenuButton(data.menuButtons, menuConfigTable, menuListScrollChild);
          end
        end
      end
    end

    -- order and position buttons:
    tk.Tables:OrderBy(data.menuButtons, "id", "name");

    for id, menuButton in ipairs(data.menuButtons) do
      if (id == 1) then
        -- first menu button (does not need to be anchored to a previous button)
        menuButton:SetPoint("TOPLEFT", menuListScrollChild, "TOPLEFT");
        menuButton:SetPoint("TOPRIGHT", menuListScrollChild, "TOPRIGHT", -10, 0);
        menuButton:SetChecked(true);

        self:SetSelectedButton(menuButton);
      else
        local previousMenuButton = data.menuButtons[id - 1];
        menuButton:SetPoint("TOPLEFT", previousMenuButton, "BOTTOMLEFT", 0, -5);
        menuButton:SetPoint("TOPRIGHT", previousMenuButton, "BOTTOMRIGHT", 0, -5);

        -- make room for padding between buttons
        menuListScrollChild:SetHeight(menuListScrollChild:GetHeight() + 5);
      end
    end

    tk:GroupCheckButtons(data.menuButtons);
  end
end