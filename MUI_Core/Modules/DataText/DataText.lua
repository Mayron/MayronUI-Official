-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local ipairs, pairs, GameTooltip, PlaySound = _G.ipairs, _G.pairs, _G.GameTooltip, _G.PlaySound;
local UIFrameFadeIn, tinsert = _G.UIFrameFadeIn, _G.table.insert;

-- Objects -----------------------------
local SlideController = obj:Import("MayronUI.SlideController");

-- Register Modules --------------------

---@class DataTextModule : BaseModule
local C_DataTextModule = MayronUI:RegisterModule("DataTextModule", L["Data Text Bar"]);

local labels = {
  combatTimer   = L["Combat Timer"];
  disabled      = L["Disabled"];
  durability    = L["Armor"];
  friends       = L["Friends"];
  guild         = L["Guild"];
  inventory     = L["Bags"];
  memory        = L["Memory"];
  money         = L["Money"];
  none          = L["None"];
  performance   = L["Performance"];
  quest         = L["Quests"];
  volumeOptions = _G.VOLUME;
};

MayronUI:AddComponent("DataTextLabels", labels);

-- Load Database Defaults --------------
local defaults = {
  enabled       = true;
  frameStrata   = "MEDIUM";
  frameLevel    = 20,
  height        = 24; -- height of data bar (width is the size of bottomUI container!)
  spacing       = 1;
  fontSize      = 11;
  blockInCombat = true;
  popup = {
    hideInCombat = true;
    maxHeight    = 300;
    width        = 200;
    itemHeight   = 26; -- the default height of each list item in the popup menu
  };
  labels = labels,
  displayOrders = {
    "durability";
    "friends";
    "guild";
    "volumeOptions";
    "money";
    "performance";
  };
};

if (tk:IsRetail() or tk:IsWrathClassic()) then
  defaults.labels.specialization = L["Specialization"];
  tinsert(defaults.displayOrders, "specialization");
else
  tinsert(defaults.displayOrders, "inventory");
end

db:AddToDefaults("profile.datatext", defaults);

local function DataComponentButton_OnClick(self, ...)
  self.dataModule:ClickModuleButton(self.component, self, ...);
end

local function CreateComponent(dataTextModule, data, componentClass, componentName)
  local sv = db.profile.datatext[componentName];
  local settings;

  if (obj:IsTable(sv)) then
    sv:SetParent(db.profile.datatext);
    settings = sv:GetTrackedTable();
  else
    settings = data.settings;
  end

  local component = componentClass(settings, dataTextModule, data.slideController, data.bar);
  component.SavedVariableName = componentName;

  component.Button.dataModule = dataTextModule;
  component.Button.component = component;
  component.Button:SetScript("OnClick", DataComponentButton_OnClick);

  return component;
end

-- C_DataTextModule Functions -------------------
function C_DataTextModule:OnInitialize(data)
  data.buttons = obj:PopTable();
  data.activeComponents = obj:PopTable(); -- holds all data text modules
  data.inactiveComponents = obj:PopTable();
  data.registeredComponentClasses = obj:PopTable();

  local options = {
    onExecuteAll = {
      ignore = {
        "spacing";
      };
    };
    groups = {
      {
        patterns = {".*"};

        value = function(_, keysList)
          local component = tk.Tables:First(data.activeComponents, function(c)
            for _, componentName in keysList:Iterate() do
              if (c.SavedVariableName == componentName) then
                return true;
              end
            end
          end);

          if (not component) then
            -- filter out missing update functions (such as popup settings)
            return;
          end

          component:Update(true);
        end;
      };
    };
  };

  self:RegisterUpdateFunctions(db.profile.datatext, {
    frameStrata = function(value)
      data.bar:SetFrameStrata(value);
    end;

    frameLevel = function(value)
      data.bar:SetFrameLevel(value);
    end;

    height = function(value)
      data.bar:SetHeight(value);
      local bottomActionBars = MayronUI:ImportModule("BottomActionBars");

      if (bottomActionBars:IsEnabled()) then
        bottomActionBars:SetUpExpandRetract(data);
      end
    end;

    spacing = function()
      self:PositionDataTextButtons();
    end;

    fontSize = function(value)
      for _, btn in ipairs(data.buttons) do
        local masterFont = tk:GetMasterFont();
        btn:GetFontString():SetFont(masterFont, value, "");
      end
    end;

    popup = {
      hideInCombat = function(value)
        local listenerID = "DataText_Popup_HideInCombat";

        if (value) then
          if (not em:GetEventListenerByID(listenerID)) then
            local listener = em:CreateEventListenerWithID(listenerID, function()
              _G["MUI_DataTextPopupMenu"]:Hide();
            end);

            listener:RegisterEvent("PLAYER_REGEN_DISABLED");
          else
            em:EnableEventListeners(listenerID);
          end
        else
          em:DisableEventListeners(listenerID);
        end
      end;

      width = function(value)
        data.popup:SetWidth(value);
      end;
    };

    displayOrders = function()
      self:OrderDataTextButtons();
      self:PositionDataTextButtons();
    end;
  }, options);
end

function C_DataTextModule:OnInitialized(data)
  if (data.settings.enabled) then
    self:SetEnabled(true);
  end
end

function C_DataTextModule:OnDisable(data)
  if (data.bar) then
    data.bar:Hide();
    data.popup:Hide();

    local containerModule = MayronUI:ImportModule("MainContainer");
    containerModule:RepositionContent();
  end
end

function C_DataTextModule:OnEnable(data)
  if (data.bar) then
    data.bar:Show();
    local containerModule = MayronUI:ImportModule("MainContainer");
    containerModule:RepositionContent();
    return;
  end

  -- the main bar containing all data text buttons
  data.bar = tk:CreateFrame("Frame", _G.MUI_BottomContainer, "MUI_DataTextBar");

  if (_G.MUI_BottomContainer) then
    data.bar:SetPoint("BOTTOMLEFT");
    data.bar:SetPoint("BOTTOMRIGHT");
  else
    data.bar:SetPoint("BOTTOM");
    data.bar:SetWidth(db.profile.bottomui.width);
  end

  tk:SetBackground(data.bar, 0, 0, 0);

  -- create the popup menu (displayed when a data item button is clicked)
  -- each data text module has its own frame to be used as the scroll child
  data.popup = gui:CreateScrollFrame(_G.MUI_BottomContainer or _G.UIParent, "MUI_DataTextPopupMenu");
  data.popup:SetFrameStrata("DIALOG");
  data.popup:Hide();
  data.popup:SetFrameLevel(2);

  -- controls the Esc key behaviour to close the popup (must use global name)
  tinsert(_G.UISpecialFrames, "MUI_DataTextPopupMenu");

  data.popup.ScrollBar:SetPoint("TOPLEFT", data.popup, "TOPRIGHT", -6, 1);
  data.popup.ScrollBar:SetPoint("BOTTOMRIGHT", data.popup, "BOTTOMRIGHT", -1, 1);

  data.popup.bg = gui:AddDialogTexture(data.popup);
  data.popup.bg:SetGridAlphaType("High");
  data.popup.bg:SetPoint("TOPLEFT", 0, 2);
  data.popup.bg:SetPoint("BOTTOMRIGHT", 0, -2);

  data.popup.bg:SetGridColor(0.4, 0.4, 0.4, 1);
  data.popup.bg:SetFrameLevel(1);

  data.popup:SetScript("OnHide", function()
    -- when popup is closed by user
    if (data.dropdowns) then
      -- popup menu content has dropdown menu's
      for _, dropdown in ipairs(data.dropdowns) do
        gui:FoldAllDropDownMenus();
        dropdown:GetFrame().menu:Hide();
      end
    end
  end);

  -- provides more intelligent scrolling (+ controls visibility of scrollbar)
  data.slideController = SlideController(data.popup, "VERTICAL");

  local containerModule = MayronUI:ImportModule("MainContainer");

  if (containerModule:IsEnabled()) then
    containerModule:RepositionContent();
  end
end

obj:DefineParams("string", "table");
function C_DataTextModule:RegisterComponentClass(data, componentName, componentClass)
  data.registeredComponentClasses[componentName] = componentClass;
end

obj:DefineReturns("Button");
function C_DataTextModule:CreateDataTextButton(data)
  local btn = tk:CreateFrame("Button");
  local btnTextureFilePath = tk.Constants.AddOnStyle:GetTexture("ButtonTexture");
  btn:SetNormalTexture(btnTextureFilePath);
  btn:GetNormalTexture():SetVertexColor(0.08, 0.08, 0.08);

  btn:SetHighlightTexture(btnTextureFilePath);
  btn:GetHighlightTexture():SetVertexColor(0.08, 0.08, 0.08);
  btn:SetNormalFontObject("MUI_FontNormal");
  btn:SetText(" ");

  local masterFont = tk:GetMasterFont();
  btn:GetFontString():SetFont(masterFont, data.settings.fontSize, "");

  tinsert(data.buttons, btn);
  return btn;
end

        -- this is called each time a datatext module is registered
function C_DataTextModule:OrderDataTextButtons(data)
  data.TotalActiveComponents = 0;

  -- disable all:
  for _, component in ipairs(data.activeComponents) do
    if (component ~= "disabled") then
      component:SetEnabled(false);
      tk:AttachToDummy(component.Button);

      local componentName = component.SavedVariableName;
      data.inactiveComponents[componentName] = data.inactiveComponents[componentName] or obj:PopTable();
      tinsert(data.inactiveComponents[componentName], component);
    end
  end

  tk.Tables:Empty(data.activeComponents);

  for _, componentName in pairs(data.settings.displayOrders) do
    if (componentName == "disabled") then
      tinsert(data.activeComponents, "disabled");
    else
      local inactiveTable = data.inactiveComponents[componentName];

      -- 1. Get component:
      local component;

      if (obj:IsTable(inactiveTable)) then
        component = inactiveTable[#inactiveTable];
        inactiveTable[#inactiveTable] = nil;
      end

      if (not component) then
        local componentClass = data.registeredComponentClasses[componentName];

        if (not componentClass) then
          MayronUI:Print(("Warning: Missing Data Text Module '%s'"):format(componentName or "Unknown"));
        else
          component = CreateComponent(self, data, componentClass, componentName);
        end
      end

      -- 2. Activate component:
      component:SetEnabled(true);
      component:Update();

      tinsert(data.activeComponents, component);
      data.TotalActiveComponents = data.TotalActiveComponents + 1;
      component.DisplayOrder = data.TotalActiveComponents;
    end
  end
end

function C_DataTextModule:PositionDataTextButtons(data)
  local bottomContainerWidth = (_G.MUI_BottomContainer and _G.MUI_BottomContainer:GetWidth()) or db.profile.bottomui.width;
  local itemWidth = bottomContainerWidth / data.TotalActiveComponents;
  local previousButton, currentButton;

  -- some indexes might have a nil value as display order is configurable by the user
  for _, component in ipairs(data.activeComponents) do
    if (component ~= "disabled") then
      currentButton = component.Button;

      if (obj:IsType(currentButton, "Button")) then
        currentButton:SetParent(data.bar);
        currentButton:ClearAllPoints();

        if (not previousButton) then
          currentButton:SetPoint("BOTTOMLEFT", data.settings.spacing, 0);
          currentButton:SetPoint("TOPRIGHT", data.bar, "TOPLEFT", itemWidth - data.settings.spacing, - data.settings.spacing);
        else
          currentButton:SetPoint("TOPLEFT", previousButton, "TOPRIGHT", data.settings.spacing, 0);
          currentButton:SetPoint("BOTTOMRIGHT", previousButton, "BOTTOMRIGHT", itemWidth, 0);
        end

        currentButton:Show();
        previousButton = currentButton;
      end
    end
  end
end

obj:DefineParams("Frame");
---Attach current dataTextModule scroll child onto shared popup and hide previous scroll child
---@param content Frame
function C_DataTextModule:ChangeMenuContent(data, content)
  local oldContent = data.popup.ScrollFrame:GetScrollChild();

  if (oldContent) then
    oldContent:Hide();
  end

  content:SetParent(data.popup);
  content:SetFrameLevel(data.popup:GetFrameLevel() + 10);

  local width = data.settings.popup.width;

  if (content.minWidth and content.minWidth > width) then
    width = content.minWidth;
  end

  data.popup:SetSize(width, 10);
  content:SetSize(data.popup:GetWidth(), 10);

  -- attach scroll child to menu frame container
  data.popup.ScrollFrame:SetScrollChild(content);
  content:Show();
end

obj:DefineParams("table");
function C_DataTextModule:ClearLabels(_, currentLabels)
  if (not currentLabels) then return end

  for _, label in ipairs(currentLabels) do
    if (label.name) then label.name:SetText(""); end
    if (label.value) then label.value:SetText(""); end

    if (label.dropdown) then
      label.dropdown:Hide();
    end

    label:ClearAllPoints();
    label:Hide();
  end
end

obj:DefineParams("table");
obj:DefineReturns("number");
---Total height is used to control the dynamic scrollbar
---@param dataModule table
---@return number the total height of all labels
function C_DataTextModule:PositionLabels(data, dataModule)
  local totalLabelsShown = dataModule.TotalLabelsShown;
  local defaultLabelHeight = data.settings.popup.itemHeight;

  if (totalLabelsShown == 0) then
    return 0;
  end

  local totalHeight = 0;

  for i = 1, totalLabelsShown do
    local label = dataModule.MenuLabels[i];
    local labelType = type(label);
    local labelHeight = label.customHeight or defaultLabelHeight;

    obj:Assert(labelType ~= "nil", "Invalid total labels to show.");

    if (labelType == "table" and label.GetObjectType) then
      labelType = label:GetObjectType();
    end

    if (labelType == "DropDownMenu") then
      label = label:GetFrame();
      labelType = label:GetObjectType();
    end

    obj:Assert(labelType == "Frame" or labelType == "Button",
    "Invalid data-text label of type '%s' at index %s.", labelType, i);

    if (i == 1) then
      label:SetPoint("TOPLEFT", 1, -1);
      label:SetPoint("BOTTOMRIGHT", dataModule.MenuContent, "TOPRIGHT", -1, -labelHeight + 1);
    else
      local previousLabel = dataModule.MenuLabels[i - 1];

      if (previousLabel:IsObjectType("DropDownMenu")) then
        previousLabel = previousLabel:GetFrame();
      end

      label:SetPoint("TOPLEFT", previousLabel, "BOTTOMLEFT", 0, -2);
      label:SetPoint("BOTTOMRIGHT", previousLabel, "BOTTOMRIGHT", 0, -(labelHeight + 2));
    end

    label:Show();
    totalHeight = totalHeight + labelHeight;

    if (i > 1) then
      totalHeight = totalHeight + 2;
    end
  end

  dataModule.MenuContent:SetHeight(totalHeight);
  return totalHeight;
end

obj:DefineParams("table", "Button");
---@param dataModule table The data-text module associated with the data-text button clicked on by the user
---@param dataTextButton Button The data-text button clicked on by the user
---@param buttonName string The name of the button clicked on (i.e. "LeftButton" or "RightButton")
function C_DataTextModule:ClickModuleButton(data, component, dataTextButton, buttonName, ...)
  GameTooltip:Hide();
  component:Update();
  data.slideController:Stop();
  local buttonDisplayOrder = component.DisplayOrder;

  if (data.lastButtonID == buttonDisplayOrder and data.lastButton == buttonName and data.popup:IsShown()) then
    -- clicked on same dataTextModule button so close the popup!

    -- if button was rapidly clicked on, reset alpha
    data.popup:SetAlpha(1);
    gui:FoldAllDropDownMenus(); -- fold any dropdown menus (slideController is not a dropdown menu)
    data.slideController:StartRetracting();

    PlaySound(tk.Constants.CLICK);
    return;
  end

  -- update last button ID that was clicked (use display order for this)
  data.lastButtonID = buttonDisplayOrder;
  data.lastButton = buttonName;

  -- a different dataTextModule button was clicked on!
  -- reset popup...
  data.popup:Hide();
  data.popup:ClearAllPoints();

  -- handle type of button click
  if ((buttonName == "RightButton" and not component.HasRightMenu) or
  (buttonName == "LeftButton" and not component.HasLeftMenu)) then
    -- execute dataTextModule specific click logic
    component:Click(buttonName, ...);
    return;
  end

  -- update content of popup based on which dataTextModule button was clicked
  if (component.MenuContent) then
    self:ChangeMenuContent(component.MenuContent);
  end

  if (component.MenuLabels) then
    self:ClearLabels(component.MenuLabels);
  end

  -- execute dataTextModule specific click logic
  local cannotExpand = component:Click(buttonName, ...);

  if (cannotExpand) then return end

  -- calculate new height based on number of labels to show
  local totalHeight = self:PositionLabels(component) or data.settings.popup.maxHeight;
  totalHeight = (totalHeight < data.settings.popup.maxHeight) and totalHeight or data.settings.popup.maxHeight;

  -- move popup menu higher if there are resource bars displayed
  local offset = 0;

  if (_G.MUI_ResourceBars) then
    offset = _G.MUI_ResourceBars:GetHeight();
  end

  -- update positioning of popup menu based on dataTextModule button's location
  if (buttonDisplayOrder == data.TotalActiveComponents) then
    -- if button was the last button displayed on the data-text bar
    data.popup:SetPoint("BOTTOMRIGHT", dataTextButton, "TOPRIGHT", -1, offset + 2);
  elseif (buttonDisplayOrder == 1) then
    -- if button was the first button displayed on the data-text bar
    data.popup:SetPoint("BOTTOMLEFT", dataTextButton, "TOPLEFT", 1, offset + 2);
  else
    -- if button was not the first or last button displayed on the data-text bar
    data.popup:SetPoint("BOTTOM", dataTextButton, "TOP", 0, offset + 2);
  end

  -- begin expanding the popup menu
  data.slideController:Hide();
  data.slideController:SetMaxValue(totalHeight);
  data.slideController:StartExpanding();

  UIFrameFadeIn(data.popup, 0.3, 0, 1);
  PlaySound(tk.Constants.CLICK);
end

obj:DefineParams("string");
function C_DataTextModule:ForceUpdate(data, dataModuleName)
  local dataModule = data.activeComponents[dataModuleName];
  dataModule:Update();
end

obj:DefineReturns("boolean");
function C_DataTextModule:IsShown(data)
  return (data.bar and data.bar:IsShown()) or false;
end

obj:DefineReturns("Frame");
function C_DataTextModule:GetDataTextBar(data)
  return data.bar;
end