-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;

local tk, _, _, gui, obj, L = MayronUI:GetCoreComponents();

local MENU_BUTTON_HEIGHT = 40;
local pairs, ipairs, table, mrandom, setmetatable = _G.pairs, _G.ipairs,
  _G.table, _G.math.random, _G.setmetatable;
local DisableAddOn, collectgarbage, UIFrameFadeIn, PlaySound, strformat =
  _G.DisableAddOn, _G.collectgarbage, _G.UIFrameFadeIn, _G.PlaySound, _G.string.format;
local strsplit, radians = _G.strsplit, _G.math.rad;

-- Registers and Imports -------------
---@type LinkedList
local C_LinkedList = obj:Import("Pkg-Collections.LinkedList");

---@class ConfigMenu : BaseModule
local C_ConfigMenuModule = MayronUI:RegisterModule("ConfigMenu");


-- Local functions -------------------
local CreateTopMenuButton;

do
  local menuButtons = {};

  function CreateTopMenuButton(label, onClick, anchor)
    local btn = gui:CreateButton(nil, label);
    btn.padding = 60;

    if (anchor) then
      btn:SetPoint("RIGHT", anchor, "RIGHT");
      btn:SetParent(anchor);
    else
      btn:SetPoint("RIGHT", menuButtons[#menuButtons], "LEFT", -10, 0);
      btn:SetParent(menuButtons[#menuButtons]);
    end

    btn:SetScript(
      "OnClick", function()
        onClick();
        PlaySound(tk.Constants.CLICK);
      end);

    table.insert(menuButtons, btn);

    return btn;
  end
end

local function IsUnsupportedByClient(client)
  if (not client) then
    return false;
  end

  if (obj:IsString(client) and client:find(",")) then
    client = obj:PopTable(strsplit(",", client));
  end

  if (obj:IsTable(client)) then
    for _, c in ipairs(client) do
      if (not IsUnsupportedByClient(c)) then
        return false;
      end
    end

    return true;
  end

  client = client:trim();

  if (client == "retail" and not tk:IsRetail()) then
    return true;
  end
  if (client == "classic" and not tk:IsClassic()) then
    return true;
  end
  if (client == "bcclassic" or client == "bcc" and not tk:IsBCClassic()) then
    return true;
  end
  if (client == "wrathclassic" or client == "wrath" and not tk:IsWrathClassic()) then
    return true;
  end

  return false;
end

local TransferComponentAttributes;
do
  local map = {
    "dbPath";
    "name";
    "requiresReload";
    "requiresRestart";
    "module";
    "database";
    "valueType";
    "min";
    "max";
    "step";
    "OnClick";
    "data";
    "useIndexes";
    "OnValueChanged";
    ["SetValue"] = "__SetValue";
  };

  function TransferComponentAttributes(component, config)
    for index, key in pairs(map) do
      if (obj:IsNumber(index)) then
        component[key] = config[key];
      else
        component[key] = config[index];
      end
    end

    if (config.type == "frame") then
      component.children = config.children;
    end

    obj:PushTable(config);
  end
end

-- C_ConfigModule -------------------
function C_ConfigMenuModule:OnInitialize()
  if (not MayronUI:IsInstalled()) then
    tk:Print(L["Please install the UI and try again."]);
    return;
  end

  DisableAddOn("MUI_Config"); -- disable for next time
end

function C_ConfigMenuModule:Show(data)
  if (not data.window) then
    local menuListScrollChild = self:SetUpWindow();
    self:SetUpSideMenu(menuListScrollChild);
  end

  data.window:Show();
  PlaySound(tk.Constants.MENU_OPENED_CLICK);
end

obj:DefineReturns("Database");
---@return Database
function C_ConfigMenuModule:GetDatabase(data, tbl)
  local dbObject = MayronUI:GetComponent("Database");

  tbl = data.tempMenuConfigTable or tbl;

  if (tbl and tbl.database) then
    dbObject = MayronUI:GetComponent(tbl.database);
    obj:Assert(dbObject, "Failed to get database object for module '%s'", tbl.module);
  end

  return dbObject;
end

obj:DefineParams("table");
---Updates the database based on the dbPath config value, or using SetValue,
---@param component table @The created widger frame.
---@param value any @The value to add to the database using the dbPath value attached to the component table.
function C_ConfigMenuModule:SetDatabaseValue(_, component, newValue)
  local db = self:GetDatabase(component);
  local oldValue;
  local dbPath = component.dbPath;

  if (obj:IsFunction(dbPath)) then
    dbPath = dbPath();
  end

  if (not tk.Strings:IsNilOrWhiteSpace(dbPath)) then
    oldValue = db:ParsePathValue(dbPath);
  end

  if (component.__SetValue) then
    component.__SetValue(dbPath, newValue, oldValue, component);
  else
    -- dbPath is required if not using a custom __SetValue function!
    if (component.name and component.name.IsObjectType and component.name:IsObjectType("FontString")) then
      tk:Assert(not tk.Strings:IsNilOrWhiteSpace(dbPath),
        "%s is missing database path address element (dbPath) in config data.",
        component.name:GetText());
    else
      tk:Assert(not tk.Strings:IsNilOrWhiteSpace(dbPath),
        "Unknown config data is missing database path address element (dbPath).");
    end

    db:SetPathValue(dbPath, newValue);
  end

  if (component.OnValueChanged) then
    component.OnValueChanged(newValue);
  end

  if (component.requiresReload) then
    self:ShowReloadMessage();
  elseif (component.requiresRestart) then
    self:ShowRestartMessage();
  end
end

obj:DefineParams("CheckButton|Button");
---@param menuButton CheckButton|Button @The clicked menu button is associated with a menu.
---@overload fun(self, menuButton: CheckButton|Button)
function C_ConfigMenuModule:OpenMenu(data, menuButton)
  if (menuButton.type == "menu") then
    data.history:Clear();
  else
    tk:Assert(menuButton.type == "submenu", "Menu or Sub-Menu expected, got '%s'.", menuButton.type);
  end

  self:SetSelectedButton(menuButton);
end

function C_ConfigMenuModule:RemoveComponent(data, component)
  obj:Assert(data.selectedButton, "Failed to remove component - No selected button.");
  obj:Assert(data.selectedButton.menu, "Failed to remove component - No selected menu.");

  ---@type DynamicFrame
  local menu = data.selectedButton.menu;
  menu:RemoveChild(component);
end

function C_ConfigMenuModule:AddComponent(data, component)
  obj:Assert(data.selectedButton, "Failed to add component - No selected button.");
  obj:Assert(data.selectedButton.menu, "Failed to add component - No selected menu.");

  ---@type DynamicFrame
  local menu = data.selectedButton.menu;
  menu:AddChildren(component);
end

do
  local function CleanTablesPredicate(_, tbl, key)
    return (tbl.type ~= "submenu" and key ~= "options");
  end

  obj:DefineParams("CheckButton|Button");
  ---@param menuButton CheckButton|Button @The menu button clicked on associated with a menu.
  function C_ConfigMenuModule:SetSelectedButton(data, menuButton)
    if (data.selectedButton) then
      -- hide old menu
      data.selectedButton.menu:Hide();
    end

    menuButton.menu = menuButton.menu or self:CreateMenu();
    data.selectedButton = menuButton;

    local history = data.history; ---@type LinkedList
    history:AddToBack(menuButton);

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

    local backBtnEnabled = history:GetSize() > 1;
    data.window.back:SetEnabled(backBtnEnabled);
    data.window.back:SetShown(backBtnEnabled);
    data.windowName:ClearAllPoints();

    if (backBtnEnabled) then
      local breadcrumbText;

      for _, btn in data.history:Iterate() do
        if (not breadcrumbText) then
          breadcrumbText = btn.name;
        else
          breadcrumbText = strformat("%s |TInterface/Addons/MUI_Core/Assets/Icons/crumb:16:16|t %s", breadcrumbText, btn.name);
        end
      end
      data.windowName:SetText(breadcrumbText);
      data.windowName:SetPoint("LEFT", data.window.back, "RIGHT", 15, 0);
    else
      data.windowName:SetText(menuButton.name);
      data.windowName:SetPoint("LEFT", data.topbarFrame, 2, 0);
    end

    UIFrameFadeIn(data.selectedButton.menu, 0.3, 0, 1);
    PlaySound(tk.Constants.CLICK);
  end
end

obj:DefineParams("table");
function C_ConfigMenuModule:RenderComponent(data, componentConfig)
  if (componentConfig.type == "loop" or componentConfig.type == "condition") then
    -- run the loop to gather component children
    local components = MayronUI:GetComponent("ConfigMenuComponents");
    local children = components[componentConfig.type](data.selectedButton.menu:GetFrame(), componentConfig);

    if (obj:IsTable(children)) then -- Sometimes a condition may not return anything
      for _, c in ipairs(children) do
        if (obj:IsTable(c) and not c.type) then
          for _, c2 in ipairs(c) do
            self:RenderComponent(c2);
          end

          obj:PushTable(c);
        else
          self:RenderComponent(c);
        end
      end

      obj:PushTable(children);
    end

    -- the table was previously popped
    obj:PushTable(componentConfig);

    return
  end

  local componentType = componentConfig.type; -- config gets deleted after SetUpcomponent and type does not get mapped
  local component = self:SetUpComponent(componentConfig);

  if (componentType == "frame" and obj:IsTable(component.children)) then
    local dynamicFrame = component; ---@type DynamicFrame
    local frame = component:GetFrame();
    data.tempFrameComponent = component;

    for _, subcomponentConfigTable in ipairs(component.children) do
      local childcomponent = self:SetUpComponent(subcomponentConfigTable, frame);
      dynamicFrame:AddChildren(childcomponent);
    end

    data.tempFrameComponent = nil;
    component = frame;
  end

  data.selectedButton.menu:AddChildren(component);
end

obj:DefineParams("table");
---@param menuConfigTable table @A table containing many component config tables used to render a full menu.
function C_ConfigMenuModule:RenderSelectedMenu(data, menuConfigTable)
  if (obj:IsFunction(menuConfigTable.children)) then
    menuConfigTable.children = menuConfigTable:children();
  end

  if (not obj:IsTable(menuConfigTable.children)) then
    return
  end

  data.tempMenuConfigTable = menuConfigTable;

  for _, componentConfigTable in pairs(menuConfigTable.children) do
    if (not IsUnsupportedByClient(componentConfigTable.client)) then
      self:RenderComponent(componentConfigTable);
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
function C_ConfigMenuModule:CreateMenu(data)
  -- else, create a new menu (dynamic frame) to based on the module's config data
  local menuParent = data.options:GetFrame();
  local menu = gui:CreateDynamicFrame(menuParent, 10, 10);
  local menuScrollFrame = menu:GetFrame();

  -- add graphical dialog box to dynamic frame:
  -- TODO: Create Tabs
  gui:CreateDialogBox(nil, "Low", menuScrollFrame);

  menuScrollFrame:SetAllPoints(true);

  return menu;
end

---@param btn Button
local function handleTabOnClick(btn)
  local selectedTabId = btn:GetID();
  local parent = btn:GetParent(); ---@cast parent Frame
  local level = parent:GetFrameLevel();
  local baseFrameLevel = level + 10;
  local tabs= btn.tabs; ---@cast tabs Button[]

  for i, tab in ipairs(tabs) do
    local isSelected = i == selectedTabId;
    tab.selected:SetShown(isSelected);
    tab.unselected:SetShown(not isSelected);

    if (isSelected) then
      tab:SetFrameLevel(baseFrameLevel + 10);
    else
      tab:SetFrameLevel(baseFrameLevel);
    end
  end
end

---@param tabNames string[]
function C_ConfigMenuModule:ShowTabs(data, tabNames)
  local parent = data.options:GetFrame();
  local tabsFrame = tk:CreateFrame("Frame", parent);
  tabsFrame:SetSize(1, 1);

  data.tabs = data.tabs or {};



  for i, tabConfig in ipairs(config.children) do
    local btn = tk:CreateFrame("Button", tabsFrame);
    btn:SetID(i);
    tabs[i] = btn;

    local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight", 20);
    fs:SetText(tabConfig.name);
    btn:SetSize(160, 34);

    local textureName;

    if (i == 1) then
      textureName = "left";
      fs:SetPoint("CENTER", -10, 0);
    elseif (i == #config.children) then
      textureName = "right";
      fs:SetPoint("CENTER", 10, 0);
    else
      textureName = "both";
      fs:SetPoint("CENTER");
    end

    local r, g, b = tk:GetThemeColor();
    local selectedTextureFilePath = tk:GetAssetFilePath("Textures\\Tabs\\tab-"..textureName.."-selected");
    btn.selected = btn:CreateTexture(nil, "ARTWORK");
    btn.selected:SetTexture(selectedTextureFilePath);
    btn.selected:SetAllPoints(true);
    btn.selected:SetVertexColor(r, g, b);

    local unselectedTextureFilePath = tk:GetAssetFilePath("Textures\\Tabs\\tab-"..textureName.."-unselected");
    btn.unselected = btn:CreateTexture(nil, "ARTWORK");
    btn.unselected:SetTexture(unselectedTextureFilePath);
    btn.unselected:SetAllPoints(true);

    if (i == 1) then
      btn:SetPoint("TOPLEFT", tabsFrame, "TOPLEFT");
      handleTabOnClick(btn);
    else
      btn:SetPoint("LEFT", tabs[i - 1], "RIGHT", -46, 0);
    end

    btn.configTable = tabConfig;
    btn.type = "submenu";
    btn.name = tabConfig.name;

    -- btn:SetScript("OnClick", Utils.OnMenuButtonClick);

    btn:SetScript("OnClick", handleTabOnClick);

    if (config.tooltip) then
      tk:SetBasicTooltip(btn, config.tooltip);
    end
  end
end

function C_ConfigMenuModule:ShowReloadMessage(data)
  data.warningIcon:Show();
  data.warningLabel:SetText(data.warningLabel.reloadText);
end

function C_ConfigMenuModule:ShowRestartMessage(data)
  data.warningIcon:Show();
  data.warningLabel:SetText(data.warningLabel.restartText);
end

function C_ConfigMenuModule:RefreshMenu(data)
  ---@type DynamicFrame
  local menu = data.selectedButton.menu;
  menu:Refresh();
end

local function ApplyMenuConfigTable(componentConfig, menuConfig, frameComponent)
  local dbPath = menuConfig.dbPath;

  if (obj:IsTable(frameComponent) and frameComponent.dbPath) then
    dbPath = frameComponent.dbPath;
  end

  if (obj:IsFunction(dbPath)) then
    dbPath = dbPath();
  end

  if (not tk.Strings:IsNilOrWhiteSpace(dbPath) and
      not tk.Strings:IsNilOrWhiteSpace(componentConfig.appendDbPath)) then

    -- append the component config table's dbPath value onto it!
    obj:Assert(componentConfig.dbPath == nil,
      "Cannot use both appendDbPath and dbPath on the same config table.");

    if (tk.Strings:StartsWith(componentConfig.appendDbPath, "[")) then
      componentConfig.dbPath = tk.Strings:Concat(dbPath, componentConfig.appendDbPath);
    else
      componentConfig.dbPath = tk.Strings:Join(".", dbPath, componentConfig.appendDbPath);
    end

    componentConfig.appendDbPath = nil;
  end

  if (not obj:IsTable(menuConfig.inherit)) then
    menuConfig.inherit = obj:PopTable();
    menuConfig.inherit.module = menuConfig.module;
    menuConfig.inherit.database = menuConfig.database;
  end

  if (not menuConfig.inherit.__index) then
    local metaTable = obj:PopTable();
    metaTable.__index = menuConfig.inherit;
    menuConfig.inherit = metaTable;
  end

  -- Inherit all key and value pairs from a menu table
  setmetatable(componentConfig, menuConfig.inherit);
end

do
  local function GetDatabaseValue(module, config)
    if (obj:IsFunction(config.dbPath)) then
      config.dbPath = config.dbPath();
    end

    local dbPath = config.dbPath;

    if (tk.Strings:IsNilOrWhiteSpace(dbPath)) then
      return config.GetValue and config.GetValue(config);
    end

    local db = module:GetDatabase(config);
    local value = db:ParsePathValue(dbPath);

    if (obj:IsTable(value) and value.GetUntrackedTable) then
      value = value:GetUntrackedTable();
    end

    if (config.GetValue) then
      value = config.GetValue(config, value);
    end

    return value;
  end

  obj:DefineParams("table", "?Frame");
  ---@param componentConfig table @A component config table used to control the rendering and behavior of a component in the config menu.
  ---@param parent Frame @(optional) A custom parent frame for the component, else the parent will be the menu scroll child.
  ---@return Frame @(possibly nil if component is disabled) The created component.
  function C_ConfigMenuModule:SetUpComponent(data, componentConfig, parent)
    if (not parent) then
      parent = data.selectedButton.menu:GetFrame();
      parent = parent.ScrollFrame:GetScrollChild();
    end

    if (obj:IsTable(data.tempMenuConfigTable)) then
      ApplyMenuConfigTable(componentConfig, data.tempMenuConfigTable, data.tempFrameComponent);
    end

    local componentType = componentConfig.type;

    -- treat the component like a check button (except when grouping the check buttons)
    if (componentType == "radio") then
      componentType = "check";
    end

    local components = MayronUI:GetComponent("ConfigMenuComponents");

    tk:Assert(components[componentType],
      "Unsupported component type '%s' found in config data for config table '%s'.",
      componentType or "nil", componentConfig.name or "nil");

    if (componentConfig.OnInitialize) then
      -- do disabled components need to be initialized?
      componentConfig.OnInitialize(componentConfig);
      componentConfig.OnInitialize = nil;
    end

    local currentValue = GetDatabaseValue(self, componentConfig);
    local component = components[componentType](parent, componentConfig, currentValue);

    if (componentConfig.devMode) then
      -- highlight the component in dev mode.
      tk:SetBackground(component, mrandom(), mrandom(), mrandom());
    end

    -- If using Rendercomponent manually in config then this won't work
    if (data.tempMenuConfigTable and componentConfig.type == "radio" and componentConfig.groupName) then
      -- get groups[groupName] value from tempRadioButtonGroup
      local tempRadioButtonGroup = tk.Tables:GetTable(data.tempMenuConfigTable, "groups", componentConfig.groupName);
      table.insert(tempRadioButtonGroup, component.btn);
    end

    if (componentConfig.disabled) then
      return
    end

    -- setup complete, so run the OnLoad callback if one exists
    if (componentConfig.OnLoad) then
      componentConfig.OnLoad(componentConfig, component, currentValue);
      componentConfig.OnLoad = nil;
    end

    if (componentType ~= "submenu") then
      TransferComponentAttributes(component, componentConfig);
    end

    return component;
  end
end

function C_ConfigMenuModule:SetUpWindow(data)
  if (data.window) then
    return
  end

  data.history = C_LinkedList();

  data.window = gui:CreateDialogBox(nil, nil, nil, "MUI_Config");
  data.window:SetFrameStrata("DIALOG");
  data.window:Hide();

  tk:SetResizeBounds(data.window, 600, 400, 1400, 800);

  data.window:SetSize(1000, 500);
  data.window:SetPoint("CENTER");

  gui:AddTitleBar(data.window, "MUI " .. L["Config"]);
  gui:AddResizer(data.window);
  gui:AddCloseButton(data.window, nil, tk.Constants.CLICK);

  -- convert container to a panel
  data.window = gui:CreatePanel(data.window);
  data.window:SetDevMode(true); -- shows or hides the red frame info overlays
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

  data.topbarFrame = topbar:GetFrame();

  local menuListContainer = gui:CreateScrollFrame(data.window:GetFrame(), "MUI_ConfigSideBar");
  menuListContainer.ScrollBar:SetPoint(
    "TOPLEFT", menuListContainer.ScrollFrame, "TOPRIGHT", -5, 0);
  menuListContainer.ScrollBar:SetPoint(
    "BOTTOMRIGHT", menuListContainer.ScrollFrame, "BOTTOMRIGHT", 0, 0);

  local menuListCell = data.window:CreateCell(menuListContainer);
  menuListCell:SetInsets(2, 10, 10, 10);

  data.options = data.window:CreateCell();
  data.options:SetInsets(2, 14, 2, 2);

  local versionCell = data.window:CreateCell();
  versionCell:SetInsets(10, 10, 10, 10);

  versionCell.text = versionCell:CreateFontString(
                       nil, "OVERLAY", "GameFontHighlight");
  versionCell.text:SetText(strformat("Version: %s", tk:GetVersion()));

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

  data.warningLabel.reloadText =
    L["The UI requires reloading to apply changes."];
  data.warningLabel.restartText =
    L["Some changes require a client restart to take effect."];

  -- forward and back buttons
  local backBtn = tk:CreateFrame("Button", data.topbarFrame);
  data.window.back = backBtn;

  backBtn:SetPoint("LEFT", 2, 0);
  backBtn:SetSize(22, 24.2);

  local arrowTexturePath = tk:GetAssetFilePath("Icons\\arrow");
  backBtn:SetNormalTexture(arrowTexturePath);
  backBtn:SetHighlightTexture(arrowTexturePath, "ADD");

  backBtn.arrow = backBtn:GetNormalTexture();
  tk:ApplyThemeColor(backBtn.arrow);

  backBtn.arrow:SetRotation(radians(90));
  backBtn:GetHighlightTexture():SetRotation(radians(90));

  data.window.back:SetScript("OnClick", function()
    data.history:RemoveBack(); -- remove current
    local menuButton = data.history:GetBack();
    data.history:RemoveBack(); -- remove previous so that SetSelectedButton re-adds it.
    self:SetSelectedButton(menuButton);
  end);

  data.windowName = topbar:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");

  -- profiles button
  data.window.profilesBtn = CreateTopMenuButton(L["Profiles"], function()
    if (data.selectedButton:IsObjectType("CheckButton")) then
      data.selectedButton:SetChecked(false);
    end

    self:ShowProfileManager();
  end, data.topbarFrame);

  -- Layouts Button:
  data.window.layoutsBtn = CreateTopMenuButton(L["Layouts"], function()
    MayronUI:TriggerCommand("layouts");
    data.window:Hide();
  end);

  -- reload button
  local refreshButton = tk:CreateFrame("Button", data.window.layoutsBtn);
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
    if (IsUnsupportedByClient(menuConfigTable.client)) then
      return
    end

    local module; ---@type BaseModule might be nil for some menus (e.g. General menu has no module)

    if (menuConfigTable.module) then
      module = MayronUI:ImportModule(menuConfigTable.module, true);
    end

    local menuButton = tk:CreateFrame("CheckButton", menuListScrollChild);
    menuButton.configTable = menuConfigTable;
    menuButton.id = menuConfigTable.id;
    menuButton.type = "menu";
    menuButton.module = module;
    menuButton.text = menuButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight");

    local menuText = GetMenuButtonText(module, menuConfigTable.name);

    -- If not menuText then an unknown module's config table tried to load by mistake.
    -- e.g. ObjectiveTrackerModule is not loaded in classic, but its config table is loaded.
    -- should not happen if client == "xxx" is used correctly.
    if (not menuText) then
      return
    end

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

    local utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils
    menuButton:SetScript("OnClick", utils.OnMenuButtonClick);

    menuButtons[menuText] = menuButton;
    table.insert(menuButtons, menuButton);
  end

  ---Loads all config data from individual modules and places them as a graphical menu
  ---@param menuListScrollChild Frame @The frame that holds all menu buttons in the left scroll frame.
  function C_ConfigMenuModule:SetUpSideMenu(data, menuListScrollChild)
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
        menuButton:SetPoint(
          "TOPRIGHT", previousMenuButton, "BOTTOMRIGHT", 0, -5);

        -- make room for padding between buttons
        menuListScrollChild:SetHeight(menuListScrollChild:GetHeight() + 5);
      end
    end

    tk:GroupCheckButtons(data.menuButtons);
  end
end
