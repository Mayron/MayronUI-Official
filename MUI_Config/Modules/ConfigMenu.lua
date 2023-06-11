-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, gui, obj, L = MayronUI:GetCoreComponents();

local MENU_BUTTON_HEIGHT = 40;
local pairs, ipairs, table, mrandom = _G.pairs, _G.ipairs,  _G.table, _G.math.random;
local DisableAddOn, UIFrameFadeIn, PlaySound, strformat = _G.DisableAddOn, _G.UIFrameFadeIn, _G.PlaySound, _G.string.format;
local strsplit, radians = _G.strsplit, _G.math.rad;

-- Registers and Imports -------------
local C_LinkedList = obj:Import("Pkg-Collections.LinkedList");

---@class MayronUI.ConfigMenu : BaseModule
local C_ConfigMenuModule = MayronUI:RegisterModule("ConfigMenu");

---@class MayronUI.ConfigMenu.MenuButton : CheckButton,Button,table
---@field menu MayronUI.DynamicFrame
---@field type string
---@field module table
---@field tabsContainer table?
---@field GetParent fun(): Frame

-- Local functions -------------------
local CreateTopMenuButton;

do
  local menuButtons = {};

  function CreateTopMenuButton(label, onClick, anchor)
    local btn = gui:CreateButton(nil, label, nil, nil, 30, 100);

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

  if (client == "not retail" and tk:IsRetail()) then
    return true;
  end

  if (client == "not classic" and tk:IsClassic()) then
    return true;
  end

  if (client == "not bcclassic" or client == "not bcc" and tk:IsBCClassic()) then
    return true;
  end

  if (client == "not wrathclassic" or client == "not wrath" and tk:IsWrathClassic()) then
    return true;
  end

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

local TransferConfigAttributes, InheritConfigAttributes;
do
  local inheritableAttributes = {
    "dbFramework";
    "module";
    "database";
  };

  local componentAttributes = {
    "dbPath";
    "name";
    "requiresReload";
    "requiresRestart";
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

  function InheritConfigAttributes(parentConfig, childConfig)
    if (obj:IsFunction(childConfig.dbPath)) then
      childConfig.dbPath = childConfig.dbPath();
    end

    if (obj:IsFunction(parentConfig.dbPath)) then
      parentConfig.dbPath = parentConfig.dbPath();
    end

    if (parentConfig.dbPath and childConfig.dbPath and not childConfig.absoluteDbPath) then
      if (tk.Strings:StartsWith(childConfig.dbPath, "[")) then
        childConfig.dbPath = parentConfig.dbPath..childConfig.dbPath;
      else
        childConfig.dbPath = parentConfig.dbPath.."."..childConfig.dbPath;
      end
    end

    for _, key in ipairs(inheritableAttributes) do
      if (childConfig[key] == nil) then
        childConfig[key] = parentConfig[key];
      end
    end

    if (obj:IsTable(parentConfig.inherit)) then
      for key, value in pairs(parentConfig.inherit) do
        if (childConfig[key] == nil) then
          childConfig[key] = value;
        end
      end
    end
  end

  function TransferConfigAttributes(childConfig, component)
    for _, key in ipairs(inheritableAttributes) do
      if (component[key] == nil) then
        component[key] = childConfig[key];
      end
    end

    for index, key in pairs(componentAttributes) do
      if (component[key] == nil) then
        if (obj:IsNumber(index)) then
          component[key] = childConfig[key];
        else
          component[key] = childConfig[index];
        end
      end
    end

    if (component.type ~= "submenu") then
      -- submenu will have assigned configTable to itself and needs to be preserved
      obj:PushTable(childConfig);
    end
  end
end

---@return table
local function GetDatabase(config)
  local dbObject = MayronUI:GetComponent("Database");

  if (obj:IsTable(config) and config.database) then
    dbObject = MayronUI:GetComponent(config.database);
    obj:Assert(dbObject, "Failed to get database object for module '%s'", config.module);
  end

  return dbObject;
end

local function GetDatabaseValue(config)
  local dbPath = config.dbPath;

  if (tk.Strings:IsNilOrWhiteSpace(dbPath)) then
    return config.GetValue and config.GetValue(config);
  end

  local db = GetDatabase(config);
  local value;

  if (config.dbFramework == "orbitus") then
    ---@cast db OrbitusDB.DatabaseMixin
    local repository = db.utilities:GetRepositoryFromQuery(dbPath);
    value = repository:Query(dbPath);
  else
    ---@cast db MayronDB
    value = db:ParsePathValue(dbPath);

    if (obj:IsTable(value) and value.GetUntrackedTable) then
      value = value:GetUntrackedTable();
    end
  end

  if (config.GetValue) then
    value = config.GetValue(config, value);
  end

  return value;
end

---@param config table @A component config table used to control the rendering and behavior of a component in the config menu.
---@param parent Frame @(optional) A custom parent frame for the component, else the parent will be the menu scroll child.
---@param radioGroups table?
---@return Frame
local function CreateComponent(config, parent, radioGroups)
  local componentType = config.type;

  -- treat the component like a check button (except when grouping the check buttons)
  if (componentType == "radio") then
    componentType = "check";
  end

  local components = MayronUI:GetComponent("ConfigMenuComponents");

  if (not componentType) then
    MayronUI:PrintTable(config);
  end

  tk:Assert(components[componentType],
    "Unsupported component type '%s' found in config data for config table '%s'.",
    componentType or "nil", config.name or "nil");

  if (config.OnInitialize) then
    -- do disabled components need to be initialized?
    config.OnInitialize(config);
    config.OnInitialize = nil;
  end

  local currentValue = GetDatabaseValue(config);
  local component = components[componentType](parent, config, currentValue);

  if (config.devMode) then
    -- highlight the component in dev mode.
    tk:SetBackground(component, mrandom(), mrandom(), mrandom());
  end

  if (radioGroups and config.type == "radio" and config.groupName) then
    if (not radioGroups[config.groupName]) then
      radioGroups[config.groupName] = obj:PopTable();
    end

    table.insert(radioGroups[config.groupName], component.btn);
  end

  -- setup complete, so run the OnLoad callback if one exists
  if (config.OnLoad) then
    config:OnLoad(component, currentValue);
    config.OnLoad = nil;
  end

  if (config.type == "frame") then
    component = component:GetFrame();
  end

  TransferConfigAttributes(config, component);
  return component;
end


-- C_ConfigModule -------------------
function C_ConfigMenuModule:OnInitialize()
  if (not MayronUI:IsInstalled()) then
    tk:Print(L["Please install the UI and try again."]);
    return;
  end

  DisableAddOn("MUI_Config"); -- disable for next time
end

function C_ConfigMenuModule:Show(data, module)
  if (not data.configPanel) then
    self:SetUpWindow();
  end

  data.configPanel:Show();

  if (module) then
    for _, menuBtn in pairs(data.menuButtons) do
      if (obj:IsTable(menuBtn.module) and menuBtn.module.GetModuleKey) then
        local moduleName = menuBtn.module:GetModuleKey();

        if (moduleName == module) then
          self:OpenMenu(menuBtn);
          break
        end
      end
    end
  end

  PlaySound(tk.Constants.MENU_OPENED_CLICK);
end

obj:DefineParams("table");
---Updates the database based on the dbPath config value, or using SetValue,
---@param component table @The created widger frame.
---@param newValue any @The value to add to the database using the dbPath value attached to the component table.
function C_ConfigMenuModule:SetDatabaseValue(_, component, newValue)
  local db = GetDatabase(component);
  local dbPath = component.dbPath;
  local oldValue, repository;

  if (not tk.Strings:IsNilOrWhiteSpace(dbPath)) then
    if (component.dbFramework == "orbitus") then
      ---@cast db OrbitusDB.DatabaseMixin
      repository = db.utilities:GetRepositoryFromQuery(dbPath);
      oldValue = repository:Query(dbPath);
    else
      ---@cast db MayronDB
      oldValue = db:ParsePathValue(dbPath);
    end
  end

  if (component.__SetValue) then
    component.__SetValue(component, newValue, oldValue);
  else
    -- dbPath is required if not using a custom __SetValue function!
    if (component.name and component.name.IsObjectType and component.name:IsObjectType("FontString")) then
      tk:Assert(not tk.Strings:IsNilOrWhiteSpace(dbPath),
        "%s is missing database path address element (dbPath) in config data.",
        component.name:GetText());
    else
      local isMissingRequiredDbPath = tk.Strings:IsNilOrWhiteSpace(dbPath);

      if (isMissingRequiredDbPath) then
        MayronUI:PrintTable(component)
        tk:Error("Unknown config data is missing database path address element (dbPath).");
      end

    end

    if (component.dbFramework == "orbitus") then
      ---@cast repository OrbitusDB.RepositoryMixin
      repository:Store(dbPath, newValue);
    else
      ---@cast db MayronDB
      db:SetPathValue(dbPath, newValue);
    end
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
---@param menuButton MayronUI.ConfigMenu.MenuButton @The clicked menu button is associated with a menu.
---@overload fun(self, menuButton: MayronUI.ConfigMenu.MenuButton)
function C_ConfigMenuModule:OpenMenu(data, menuButton)
  local history = data.history--[[@as Pkg-Collections.LinkedList]];

  if (menuButton.type == "menu" or menuButton.type == "tab") then
    history:Clear();
  else
    tk:Assert(menuButton.type == "submenu", "Menu or Sub-Menu expected, got '%s'.", menuButton.type);
  end

  self:SetSelectedContentButton(menuButton);
end

function C_ConfigMenuModule:RemoveComponent(data, component)
  obj:Assert(data.selectedButton, "Failed to remove component - No selected button.");
  obj:Assert(data.selectedButton.menu, "Failed to remove component - No selected menu.");

  ---@type MayronUI.DynamicFrame
  local menu = data.selectedButton.menu;
  menu:RemoveChild(component);
end

function C_ConfigMenuModule:AddComponent(data, component)
  obj:Assert(data.selectedButton, "Failed to add component - No selected button.");
  obj:Assert(data.selectedButton.menu, "Failed to add component - No selected menu.");

  ---@type MayronUI.DynamicFrame
  local menu = data.selectedButton.menu;
  menu:AddChildren(component);
end

obj:DefineParams("CheckButton|Button");
---@overload fun(self, btn: MayronUI.ConfigMenu.MenuButton)
function C_ConfigMenuModule:SetSelectedContentButton(data, btn)
  ---@cast data table
  ---@cast btn MayronUI.ConfigMenu.MenuButton

  if (btn.type == "menu") then
    for _, menuBtn in ipairs(data.menuButtons) do
      if (menuBtn:IsObjectType("CheckButton") and menuBtn:GetChecked()) then
        menuBtn:SetChecked(false);
      end
    end

    if (btn:IsObjectType("CheckButton") and not btn:GetChecked()) then
      btn:SetChecked(true);
    end
  end

  -- Hide the old one
  if (data.selectedButton) then
    if (data.selectedButton.menu) then
      data.selectedButton.menu:GetScrollFrame():Hide();
    end

    if (data.selectedButton.type == "tab") then
      local tabsContainer = data.selectedButton:GetParent()--[[@as Frame]];
      tabsContainer:Hide();
    end
  end

  local optionsFrame = data.options:GetFrame();

  -- Need to render it if configTable is found
  if (btn.configTable) then
    if (btn.configTable.tabs) then
      self:RenderMenuTabs(btn, optionsFrame);
    else
      data.selectedButton = btn;

      -- else, create a new menu (dynamic frame) to based on the module's config data
      local globalMenuName = nil;
      local btnName = btn.configTable.module--[[@as string]];

      if (type(btnName) == "string") then
        globalMenuName = "MUI_Config"..btnName.."Menu";
      end

      local dynamicFrame = gui:CreateDynamicFrame(optionsFrame, globalMenuName, 15, 10);
      dynamicFrame:SetDevMode(false); -- if true, all components added to all menu frame's will have a random background color
      local menuScrollFrame = dynamicFrame:WrapInScrollFrame();

      btn.menu = dynamicFrame;

      gui:AddDialogTexture(menuScrollFrame);
      menuScrollFrame:SetPoint("BOTTOMRIGHT", -10, 0);

      if (btn.type == "tab") then
        menuScrollFrame:SetPoint("TOPLEFT", btn:GetParent(), "BOTTOMLEFT", 4, -4);
      else
        menuScrollFrame:SetPoint("TOPLEFT");
      end

      self:RenderMenuComponents(btn);
      dynamicFrame:Refresh();
    end

    btn.configTable = nil;

    if (btn.type == "menu" and obj:IsTable(btn.module)) then
      btn.module.configTable = nil;
    end
  end

  if (btn.tabsContainer and #btn.tabsContainer.tabs > 0) then
    local firstTab = btn.tabsContainer.tabs[1];

    for _, tab in ipairs(btn.tabsContainer.tabs) do
      if (tab:GetChecked()) then
        self:SetSelectedContentButton(firstTab);
        break
      end
    end

    return
  end

  data.selectedButton = btn;

  -- fade menu in...
  local menuScrollFrame = btn.menu:GetScrollFrame();
  menuScrollFrame:Show();

  if (btn.type == "tab") then
    btn:GetParent():Show();
  end

  PlaySound(tk.Constants.CLICK);
  UIFrameFadeIn(menuScrollFrame--[[@as Frame]], 0.3, 0, 1);

  local history = data.history; ---@type Pkg-Collections.LinkedList
  history:AddToBack(btn);

  local backBtnEnabled = history:GetSize() > 1;
  data.configPanel.back:SetEnabled(backBtnEnabled);
  data.configPanel.back:SetShown(backBtnEnabled);
  data.configPanelName:ClearAllPoints();

  if (backBtnEnabled) then
    local breadcrumbText;

    for _, previousBtn in data.history:Iterate() do
      if (not breadcrumbText) then
        breadcrumbText = previousBtn.name;
      else
        breadcrumbText = strformat("%s |TInterface/Addons/MUI_Core/Assets/Icons/crumb:16:16|t %s", breadcrumbText, previousBtn.name);
      end
    end

    data.configPanelName:SetText(breadcrumbText);
    data.configPanelName:SetPoint("LEFT", data.configPanel.back, "RIGHT", 15, 0);
  else
    data.configPanelName:SetText(btn.name);
    data.configPanelName:SetPoint("LEFT", data.topbarFrame, 2, 0);
  end
end

function C_ConfigMenuModule:RenderComponent(data, menuConfig, componentConfig, radioGroups)
  if (componentConfig.ignore) then
    obj:PushTable(componentConfig);
    return
  end

  local menuScrollChild = data.selectedButton.menu:GetFrame(); -- the component's parent

  if (menuConfig) then
    -- there are some calls to render components later on demand when the menuConfig no longer exists
    InheritConfigAttributes(menuConfig, componentConfig);
  end

  local componentType = componentConfig.type;

  if (componentType == "loop" or componentType == "condition") then
    -- run the loop to gather component children
    local components = MayronUI:GetComponent("ConfigMenuComponents");
    local results = components[componentType](menuScrollChild, componentConfig);

    if (componentType == "condition" and not obj:IsTable(results)) then
      obj:PushTable(componentConfig);
      return
    end

    -- results could contain a single childConfigs or a table of childConfigs
    for _, result in ipairs(results) do
      if (obj:IsTable(result)) then
        if (result.type) then
          local childConfig = result;
          self:RenderComponent(componentConfig, childConfig, radioGroups);
        else
          for _, childConfig in ipairs(result) do
            self:RenderComponent(componentConfig, childConfig, radioGroups);
          end
        end
      end
    end

    obj:PushTable(results);
    obj:PushTable(componentConfig);

    return
  end

  if (obj:IsFunction(componentConfig.children)) then
    componentConfig.children = componentConfig.children();
  end

  local componentChildrenConfigs = componentConfig.children; -- else it'll be pushed when transfering

  local component = CreateComponent(componentConfig, menuScrollChild, radioGroups);
  componentConfig = nil; --luacheck: ignore (this has been consumed and transferred)

  if (componentType == "frame" and obj:IsTable(componentChildrenConfigs)) then
    local childComponents = obj:PopTable();
    childComponents.hasChildren = true;

    for _, childConfig in ipairs(componentChildrenConfigs) do
      if (childConfig.ignore) then
        obj:PushTable(childConfig);
      else
        InheritConfigAttributes(component, childConfig);
        local childComponent = CreateComponent(childConfig, component, radioGroups);
        childComponents[#childComponents+1] = childComponent;
      end
    end

    component.dynamicFrame:AddChildren(childComponents);
    obj:PushTable(childComponents);
  end

  data.selectedButton.menu:AddChildren(component);
end

obj:DefineParams("table");
---@param menuButton Button|CheckButton|table @A table containing many component config tables used to render a full menu.
---@overload fun(self, menuButton: Button|CheckButton)
function C_ConfigMenuModule:RenderMenuComponents(_, menuButton)
  local menuConfig = menuButton.configTable;

  if (obj:IsFunction(menuConfig.children)) then
    menuConfig.children = menuConfig:children();
  end

  if (not obj:IsTable(menuConfig.children)) then
    return
  end

  local radioGroups = {};

  for _, componentConfig in pairs(menuConfig.children) do
    if (not IsUnsupportedByClient(componentConfig.client)) then
      self:RenderComponent(menuConfig, componentConfig, radioGroups);
    end
  end

  for _, group in pairs(radioGroups) do
    tk:GroupCheckButtons(group);
  end

  obj:PushTable(radioGroups);
  obj:PushTable(menuConfig);
  menuButton.configTable = nil;
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
  ---@type MayronUI.DynamicFrame
  local menu = data.selectedButton.menu;
  menu:Refresh();
end

local function HandleTabButtonOnLeave(self)
  if (self:GetChecked()) then
    local r, g, b = tk:GetThemeColor();
    self.leftTexture:SetVertexColor(r, g, b);
    self.middleTexture:SetVertexColor(r, g, b);
    self.rightTexture:SetVertexColor(r, g, b);
  else
    self.leftTexture:SetVertexColor(0.8, 0.8, 0.8);
    self.middleTexture:SetVertexColor(0.8, 0.8, 0.8);
    self.rightTexture:SetVertexColor(0.8, 0.8, 0.8);
  end
end

function C_ConfigMenuModule:RenderMenuTabs(_, menuButton, menuParent)
  local tabNames = menuButton.configTable.tabs;
  local textureFilePath = tk:GetAssetFilePath("Textures\\tab");
  local utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils

  local tabsContainer = tk:CreateFrame("Frame", menuParent);
  tabsContainer.tabs = {};

  tabsContainer:SetHeight(30);
  tabsContainer:SetPoint("TOPLEFT");
  tabsContainer:SetPoint("TOPRIGHT", -10, 0);

  menuButton.tabsContainer = tabsContainer;

  for i, tabChildren in ipairs(menuButton.configTable.children) do
    local tab = tk:CreateFrame("CheckButton", tabsContainer);
    tabsContainer.tabs[i] = tab;

    tab.configTable = {};

    for key, value in pairs(menuButton.configTable) do
      tab.configTable[key] = value;
    end

    tab.configTable.tabs = nil; -- a tab cannot also have tabs
    tab.configTable.children = tabChildren;

    tab.type = "tab";
    tab.name = menuButton.name .. " " .. tabNames[i];
    tab:SetScript("OnLeave", HandleTabButtonOnLeave);
    tab:SetScript("OnClick", utils.OnMenuButtonClick);

    local fs = tab:CreateFontString(nil, "OVERLAY", "GameFontHighlight", 20);
    fs:SetJustifyH("LEFT");
    fs:SetText(tabNames[i]);

    local tabWidth = fs:GetStringWidth() + 80;
    tab:SetWidth(tabWidth);

    -- as a decimal where 1 == 100%
    local sideTexWidthPercent = 0.051652;
    local leftTexture = tab:CreateTexture(nil, "BACKGROUND");
    leftTexture:SetTexture(textureFilePath);
    leftTexture:SetTexCoord(0, sideTexWidthPercent, 0, 1);
    leftTexture:SetWidth(sideTexWidthPercent * tabWidth);

    local middleTexture = tab:CreateTexture(nil, "BACKGROUND");
    middleTexture:SetTexture(textureFilePath);
    middleTexture:SetTexCoord(sideTexWidthPercent, 1 - sideTexWidthPercent, 0, 1);

    local rightTexture = tab:CreateTexture(nil, "BACKGROUND");
    rightTexture:SetTexture(textureFilePath);
    rightTexture:SetTexCoord(1 - sideTexWidthPercent, 1, 0, 1);
    rightTexture:SetWidth(sideTexWidthPercent * tabWidth);

    tab.leftTexture = leftTexture;
    tab.middleTexture = middleTexture;
    tab.rightTexture = rightTexture;

    fs:SetPoint("LEFT", middleTexture, "LEFT", 6, 0);

    leftTexture:SetPoint("TOPLEFT");
    leftTexture:SetPoint("BOTTOMLEFT");
    rightTexture:SetPoint("TOPRIGHT");
    rightTexture:SetPoint("BOTTOMRIGHT");
    middleTexture:SetPoint("TOPLEFT", leftTexture, "TOPRIGHT");
    middleTexture:SetPoint("BOTTOMRIGHT", rightTexture, "BOTTOMLEFT");

    if (i == 1) then
      tab:SetPoint("TOPLEFT");
      tab:SetPoint("BOTTOMLEFT");
      tab:SetChecked(true);
    else
      tab:SetPoint("TOPLEFT", tabsContainer.tabs[i - 1], "TOPRIGHT", 6, 0);
      tab:SetPoint("BOTTOMLEFT", tabsContainer.tabs[i - 1], "BOTTOMRIGHT", 6, 0);
    end

    HandleTabButtonOnLeave(tab);
  end

  tk:GroupCheckButtons(tabsContainer.tabs, false);
end

function C_ConfigMenuModule:SetUpWindow(data)
  if (data.configPanel) then return end

  data.history = C_LinkedList();

  local configFrame = tk:CreateFrame("Frame", nil, "MUI_Config")
  configFrame = gui:AddDialogTexture(configFrame);
  configFrame:SetFrameStrata("DIALOG");
  configFrame:Hide();
  configFrame:SetSize(1000, 500);
  configFrame:SetPoint("CENTER");
  configFrame:EnableMouse(true);
  tk:SetResizeBounds(configFrame, 600, 400, 1400, 800);

  gui:AddTitleBar(configFrame, "MUI " .. L["Config"]);
  gui:AddResizer(configFrame);
  gui:AddCloseButton(configFrame);

  -- convert container to a panel
  data.configPanel = gui:CreatePanel(configFrame)--[[@as MayronUI.Panel]];
  data.configPanel:SetDevMode(false); -- shows or hides the red frame info overlays
  data.configPanel:SetDimensions(2, 3);
  data.configPanel:GetColumn(1):SetFixed(200);
  data.configPanel:GetRow(1):SetFixed(80);
  data.configPanel:GetRow(3):SetFixed(50);

  data.configPanel:SetScript("OnShow", function()
    -- fade in when shown
    UIFrameFadeIn(configFrame, 0.3, 0, 1);
  end);

  local topbar = data.configPanel:CreateCell();
  topbar:SetInsets(25, 15, 2, 10);
  topbar:SetDimensions(2, 1);

  data.topbarFrame = topbar:GetFrame();

  local menuListFrame = tk:CreateFrame("Frame", configFrame, "MUI_ConfigSideBar");
  local menuListScrollFrame = gui:WrapInScrollFrame(menuListFrame, nil, 4);
  local menuListCell = data.configPanel:CreateCell(menuListScrollFrame);
  menuListCell:SetInsets(0, 10, 0, 10);

  data.options = data.configPanel:CreateCell();
  data.options:SetInsets(2, 10, 2, 2);

  local versionCell = data.configPanel:CreateCell();
  versionCell:SetInsets(10, 10, 10, 10);

  versionCell.text = versionCell:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  versionCell.text:SetText(strformat("Version: %s", tk:GetVersion()));
  versionCell.text:SetPoint("BOTTOMLEFT");

  local bottombar = data.configPanel:CreateCell();
  bottombar:SetDimensions(2, 1);
  bottombar:SetInsets(10, 30, 10, 0);

  data.configPanel:AddCells(topbar, menuListCell, data.options, versionCell, bottombar);

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
  data.configPanel.back = backBtn;

  backBtn:SetPoint("LEFT", 2, 0);
  backBtn:SetSize(22, 24.2);

  local arrowTexturePath = tk:GetAssetFilePath("Icons\\arrow");
  backBtn:SetNormalTexture(arrowTexturePath);
  backBtn:SetHighlightTexture(arrowTexturePath, "ADD");

  backBtn.arrow = backBtn:GetNormalTexture();
  tk:ApplyThemeColor(backBtn.arrow);

  backBtn.arrow:SetRotation(radians(90));
  backBtn:GetHighlightTexture():SetRotation(radians(90));

  data.configPanel.back:SetScript("OnClick", function()
    data.history:RemoveBack(); -- remove current
    local menuButton = data.history:GetBack();
    data.history:RemoveBack(); -- remove previous so that SetSelectedButton re-adds it.
    self:SetSelectedContentButton(menuButton);
  end);

  data.configPanelName = topbar:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");

  -- profiles button
  data.configPanel.profilesBtn = CreateTopMenuButton(L["Profiles"], function()
    self:ShowProfileManager();
  end, data.topbarFrame);

  -- Layouts Button:
  data.configPanel.layoutsBtn = CreateTopMenuButton(L["Layouts"], function()
    MayronUI:TriggerCommand("layouts");
    configFrame:Hide();
  end);

  -- reload button
  local refreshButton = tk:CreateFrame("Button", data.configPanel.layoutsBtn);
  refreshButton:SetSize(20, 20);
  refreshButton:SetPoint("RIGHT", data.configPanel.layoutsBtn, "LEFT", -10, 0);
  refreshButton:SetNormalTexture(tk:GetAssetFilePath("Textures\\refresh"));
  tk:ApplyThemeColor(refreshButton:GetNormalTexture());
  refreshButton:SetHighlightAtlas("chatframe-button-highlight");

  local highlight = refreshButton:GetHighlightTexture()--[[@as Texture]];
  highlight:SetBlendMode("ADD");
  highlight:SetPoint("TOPLEFT", -4, 4);
  highlight:SetPoint("BOTTOMRIGHT", 4, -4);

  tk:SetBasicTooltip(refreshButton, L["Reload UI"]);
  refreshButton:SetScript("OnClick", _G.ReloadUI);

  self:SetUpSideMenu(menuListFrame);
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

  local function AddMenuButton(menuButtons, menuConfigTable, menuListFrame)
    if (IsUnsupportedByClient(menuConfigTable.client)) then
      return
    end

    local module; ---@type BaseModule might be nil for some menus (e.g. General menu has no module)

    if (menuConfigTable.module) then
      module = MayronUI:ImportModule(menuConfigTable.module, true);
    end

    local menuButton = tk:CreateFrame("CheckButton", menuListFrame);
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

    local normal = tk:SetBackground(menuButton);
    local highlight = tk:SetBackground(menuButton);
    local checked = tk:SetBackground(menuButton);

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
  ---@param menuListFrame Frame @The frame that holds all menu buttons in the left scroll frame.
  ---@overload fun(self, menuListFrame: Frame)
  function C_ConfigMenuModule:SetUpSideMenu(data, menuListFrame)
    data.menuButtons = {};

    for _, module in MayronUI:IterateModules() do
      if (module.GetConfigTable) then
        local configTable = module:GetConfigTable(self);

        if (#configTable == 0) then
          AddMenuButton(data.menuButtons, configTable, menuListFrame);
        else
          -- ConfigModule has multiple menu buttons
          for _, menuConfigTable in ipairs(configTable) do
            AddMenuButton(data.menuButtons, menuConfigTable, menuListFrame);
          end
        end
      end
    end

    -- order and position buttons:
    tk.Tables:OrderBy(data.menuButtons, "id", "name");

    for id, menuButton in ipairs(data.menuButtons) do
      if (id == 1) then
        -- first menu button (does not need to be anchored to a previous button)
        menuButton:SetPoint("TOPLEFT", menuListFrame, "TOPLEFT");
        menuButton:SetPoint("TOPRIGHT", menuListFrame, "TOPRIGHT");
        menuButton:SetChecked(true);

        self:SetSelectedContentButton(menuButton);
      else
        local previousMenuButton = data.menuButtons[id - 1];
        menuButton:SetPoint("TOPLEFT", previousMenuButton, "BOTTOMLEFT", 0, -5);
        menuButton:SetPoint("TOPRIGHT", previousMenuButton, "BOTTOMRIGHT", 0, -5);

        -- make room for padding between buttons
        menuListFrame:SetHeight(menuListFrame:GetHeight() + 5);
      end
    end

    -- contains all menu buttons in the left scroll frame of the main config window
    local scrollChildHeight = ((MENU_BUTTON_HEIGHT + 5) * #data.menuButtons) - 5;
    menuListFrame:SetHeight(scrollChildHeight);
  end
end
