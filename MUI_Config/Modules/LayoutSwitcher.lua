-- luacheck: ignore MayronUI self 143
local MayronUI = _G.MayronUI;
local tk, db, _, gui, obj, L = MayronUI:GetCoreComponents();
local C_LayoutSwitcher = MayronUI:RegisterModule("LayoutSwitcher");

local ipairs, string, pairs = _G.ipairs, _G.string, _G.pairs;
local LibStub, IsAddOnLoaded = _G.LibStub, _G.IsAddOnLoaded;
local UIFrameFadeIn, PlaySound = _G.UIFrameFadeIn, _G.PlaySound;

local LAYOUT_MESSAGE =
  L["Customize which addOn/s should change to which profile/s for each layout, "
    .. "as well as manage your existing layouts or create new ones."];

local localizedDbNames = {
  ["MUI_AurasDB"] = "MUI "..(_G["AURAS"] or "Auras");
}

-- Local Functions -------------------

local function SetAddOnProfilePair(_, data, addOnName, profileName)
  local path = string.format("layouts.%s.%s", data.viewingLayout, addOnName);
  db:SetPathValue(db.global, path, profileName);
end

local function GetSupportedAddOns()
  local addOns = obj:PopTable(); -- Add additional Supported AddOns here

  ---@type MayronDB
  local MayronDB = obj:Import("MayronDB");

  for _, database in MayronDB.Static:IterateDatabases() do
    local dbName = database:GetDatabaseName();
    if (dbName ~= "MayronUI") then
      -- don't allow the full MayronUI db to change as it raises bugs
      -- (db.profile.layout is confusing and needs to be addressed in MUI Gen7)
      addOns[dbName] = database;
    end
  end

  local OrbitusDB = LibStub:GetLibrary("OrbitusDB");

  for dbName, database in OrbitusDB:IterateDatabases() do
    local name = localizedDbNames[dbName];

    if (name) then
      addOns[name] = {
        GetCurrentProfile = function()
          local currentProfile = database.profile:GetActiveProfile()
          return currentProfile;
        end,
        GetProfiles = function()
          return database.profile:GetAllProfiles();
        end,
        SetProfile = function(_, profile)
          database.profile:SetActiveProfile(profile);
        end
      };
    end
  end

  for addOnName, status in LibStub("AceAddon-3.0"):IterateAddonStatus() do
    if (status) then
      local dbObject = tk.Tables:GetDBObject(addOnName);

      if (dbObject) then
        addOns[addOnName] = dbObject;
      end
    end
  end

  -- does not use AceAddon and AceDB does not contain AddOn Name
  if (IsAddOnLoaded("ShadowedUnitFrames")) then
    addOns["ShadowUF"] = tk.Tables:GetDBObject("ShadowUF");
  end

  return addOns;
end

-- C_LayoutSwitcher ------------------------

obj:DefineParams("?DropDownMenu", "?string");
function C_LayoutSwitcher:SetViewingLayout(data, dropdown, layoutName)
  if (not layoutName) then
    if (dropdown) then
      layoutName = dropdown:GetLabel();
    else
      for key, layoutData in db.global.layouts:Iterate() do
        if (layoutData) then
          layoutName = key;
          break
        end
      end
    end
  end

  data.viewingLayout = layoutName;

  if (obj:IsTable(db.global.layouts[layoutName])) then
    self:UpdateAddOnWindow();
  end
end

obj:DefineReturns("number");
function C_LayoutSwitcher:GetNumLayouts()
  local n = 0;

  for _, layoutData in db.global.layouts:Iterate() do
    if (layoutData) then
      n = n + 1;
    end
  end

  return n;
end

function C_LayoutSwitcher:UpdateAddOnWindow(data)
  if (not data.addonWindow) then
    return
  end

  local layoutData = db.global.layouts[data.viewingLayout];

  if (not layoutData) then
    self:SetViewingLayout();
    return;
  end

  local checked, addOnName;
  local dynamicFrame = data.addonWindow.dynamicFrame--[[@as MayronUI.DynamicFrame]];

  for i, child in ipairs(dynamicFrame:GetChildren()) do
    if (i % 2 ~= 0) then
      -- checkbutton
      addOnName = child.btn.text:GetText();
      checked = layoutData[addOnName] ~= nil;
      child.btn:SetChecked(checked);
    else
      -- dropdownmenu
      child:SetEnabled(checked);

      if (checked) then
        local profileName = layoutData[addOnName];
        child:SetLabel(profileName);
      else
        local object = data.supportedDatabases[addOnName];
        child:SetLabel(object:GetCurrentProfile());
      end
    end
  end

  dynamicFrame:Refresh();
end

obj:DefineParams("DropDownMenu", "string", "table");
function C_LayoutSwitcher:CreateNewAddOnProfile(data, dropdown, addOnName, dbObject)
  local newProfileLabel = string.format("Create New %s Profile:", addOnName);
  dropdown:SetLabel(db.global.layouts[data.viewingLayout][addOnName]);

  if (_G.StaticPopupDialogs["MUI_NewProfileLayout"]) then
    _G.StaticPopupDialogs["MUI_NewProfileLayout"].text = newProfileLabel;
    _G.StaticPopup_Show("MUI_NewProfileLayout");
  end

  _G.StaticPopupDialogs["MUI_NewProfileLayout"] = {
    text = newProfileLabel;
    button1 = L["Confirm"];
    button2 = L["Cancel"];
    timeout = 0;
    whileDead = true;
    hideOnEscape = true;
    hasEditBox = true;
    preferredIndex = 3;
    OnAccept = function(dialog)
      local text = dialog.editBox:GetText();

      _G.UIDropDownMenu_SetText(dialog, text);

      local currentProfile = dbObject:GetCurrentProfile();
      local alreadyExists = false;

      for _, profile in ipairs(dbObject:GetProfiles()) do
        if (profile == text) then
          alreadyExists = true;
          break
        end
      end

      if (not alreadyExists) then
        dropdown:AddOption(text, SetAddOnProfilePair, data, addOnName, text);
      end

      dbObject:SetProfile(text);
      dbObject:SetProfile(currentProfile);
      SetAddOnProfilePair(nil, data, addOnName, text);

      dropdown:SetLabel(text);
    end;
  };

  _G.StaticPopupDialogs["MUI_NewProfileLayout"].text = newProfileLabel;
  _G.StaticPopup_Show("MUI_NewProfileLayout");
end

function C_LayoutSwitcher:CreateLayout(data)
  if (_G.StaticPopupDialogs["MUI_CreateLayout"]) then
    _G.StaticPopup_Show("MUI_CreateLayout");
    return;
  end

  local dropdown = data.layoutsDropDown;
  local length = dropdown:GetNumOptions();
  local totalLayouts = self:GetNumLayouts();

  _G.StaticPopupDialogs["MUI_CreateLayout"] = {
    text = L["Name of New Layout"] .. ": ";
    button1 = L["Confirm"];
    button2 = L["Cancel"];
    timeout = 0;
    whileDead = true;
    hideOnEscape = true;
    hasEditBox = true;
    preferredIndex = 3;
    OnShow = function(dialog)
      dialog.editBox:SetText(L["Layout"] .. " " .. (length + 1));
    end;
    OnAccept = function(dialog)
      local layout = dialog.editBox:GetText();

      if (not db.global.layouts[layout]) then
        db.global.layouts[layout] = obj:PopTable();

        dropdown:AddOption(layout, { self; "SetViewingLayout" });
        self:SetViewingLayout(nil, layout);
        dropdown:SetLabel(layout);

        -- cannot delete a layout if only 1 exists
        data.deleteButton:SetEnabled(totalLayouts ~= 1);
      end
    end;
  };

  _G.StaticPopup_Show("MUI_CreateLayout");
end

function C_LayoutSwitcher:RenameLayout(data)
  if (_G.StaticPopupDialogs["MUI_RenameLayout"]) then
    _G.StaticPopup_Show("MUI_RenameLayout");
    return;
  end

  _G.StaticPopupDialogs["MUI_RenameLayout"] = {
    text = L["Rename Layout"] .. ":";
    button1 = L["Confirm"];
    button2 = L["Cancel"];
    timeout = 0;
    whileDead = true;
    hideOnEscape = true;
    hasEditBox = true;
    preferredIndex = 3;
    OnAccept = function(dialog)
      local layout = dialog.editBox:GetText();

      if (db.global.layouts[layout]) then
        return;
      end

      local oldViewingLayout = data.viewingLayout;
      local old = db.global.layouts[data.viewingLayout];

      data.viewingLayout = layout;
      db.global.layouts[layout] = old:GetSavedVariable();
      db.global.layouts[oldViewingLayout] = false; -- might be a default layout

      local dropdown = data.layoutsDropDown;
      local btn = dropdown:GetOptionByLabel(oldViewingLayout);

      btn.value = layout;
      btn:SetText(layout);
      dropdown:SetLabel(layout);
    end;
  };

  _G.StaticPopup_Show("MUI_RenameLayout");
end

function C_LayoutSwitcher:DeleteLayout(data)
  if (_G.StaticPopupDialogs["MUI_DeleteLayout"]) then
    _G.StaticPopup_Show("MUI_DeleteLayout");
    return;
  end

  _G.StaticPopupDialogs["MUI_DeleteLayout"] = {
    button1 = L["Confirm"];
    button2 = L["Cancel"];
    timeout = 0;
    whileDead = true;
    hideOnEscape = true;
    preferredIndex = 3;
    text = string.format(
      L["Are you sure you want to delete Layout '%s'?"], data.viewingLayout);
    OnAccept = function()
      local dropdown = data.layoutTool.dropdown;
      dropdown:RemoveOptionByLabel(data.viewingLayout);
      db.global.layouts[data.viewingLayout] = false;

      self:SetViewingLayout();

      local btn = dropdown:GetOptionByLabel(data.viewingLayout);
      dropdown:SetLabel(btn:GetText());
      data.deleteButton:SetEnabled(self:GetNumLayouts() ~= 1);
    end;
  };

  _G.StaticPopup_Show("MUI_DeleteLayout");
end

obj:DefineParams("table", "string");
obj:DefineReturns("Frame", "DropDownMenu");
function C_LayoutSwitcher:CreateScrollFrameRowContent(data, dbObject, addOnName)
  local addonsFrame = data.addonWindow.dynamicFrame:GetFrame();
  local addOnProfiles = dbObject:GetProfiles();

  local globalKey = tk.Strings:RemoveWhiteSpace(addOnName);
  local globalName = "MUI_LayoutToolAddOns_"..globalKey ;
  local cbContainer = gui:CreateCheckButton(addonsFrame, addOnName, nil, globalName);

  -- setup addOn dropdown menus with options
  local currentProfile = dbObject:GetCurrentProfile();

  local dropdown = gui:CreateDropDown(addonsFrame);
  dropdown.fillWidth = true;
  dropdown:SetLabel(currentProfile);
  dropdown:AddOption("<"..L["New Profile"]..">",
    { self; "CreateNewAddOnProfile" }, addOnName, dbObject);

  for _, profileName in ipairs(addOnProfiles) do
    dropdown:AddOption(profileName, SetAddOnProfilePair, data, addOnName, profileName);
  end

  cbContainer.btn:SetScript("OnClick", function()
    local checked = cbContainer.btn:GetChecked();
    dropdown:SetEnabled(checked);

    if (not checked) then
      SetAddOnProfilePair(nil, data, addOnName, false);
    else
      local profileName = dropdown:GetLabel();
      SetAddOnProfilePair(nil, data, addOnName, profileName);
    end
  end);

  return cbContainer, dropdown;
end

function C_LayoutSwitcher:ShowLayoutTool(data)
  if (data.layoutTool) then
    data.layoutTool:Show();
    self:UpdateAddOnWindow();
    UIFrameFadeIn(data.layoutTool, 0.3, 0, 1);
    PlaySound(tk.Constants.MENU_OPENED_CLICK);
    return;
  end

  data.viewingLayout = db.profile.layout;

  local layoutFrame = tk:CreateFrame("Frame", nil, "MUI_LayoutTool");
  gui:AddDialogTexture(layoutFrame);
  layoutFrame:SetSize(700, 400);
  layoutFrame:SetPoint("CENTER");

  gui:AddTitleBar(layoutFrame, L["MUI Layout Tool"]);
  gui:AddCloseButton(layoutFrame);

  -- convert to panel
  data.layoutTool = gui:CreatePanel(layoutFrame);
  data.layoutTool:SetDevMode(false); -- show or hide the red frame info overlays (default is hidden)
  data.layoutTool:SetDimensions(2, 2);
  data.layoutTool:GetRow(1):SetFixed(80);
  data.layoutTool:GetColumn(1):SetFixed(450);

  data.description = data.layoutTool:CreateCell();
  data.description:SetDimensions(2, 1);
  data.description:SetInsets(20, 50, 0, 50);

  data.description.text = data.description:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
  data.description.text:SetAllPoints(true);
  data.description.text:SetWordWrap(true);
  data.description.text:SetText(LAYOUT_MESSAGE);

  local addonsDynamicFrame = gui:CreateDynamicFrame(layoutFrame, "$parentAddOns", 10, 10);
  local addonsScrollFrame = addonsDynamicFrame:WrapInScrollFrame();
  gui:AddDialogTexture(addonsScrollFrame, "Low");

  data.addonWindow = data.layoutTool:CreateCell(addonsScrollFrame);
  data.addonWindow.dynamicFrame = addonsDynamicFrame;
  data.addonWindow:SetInsets(10, 4, 10, 10);

  local actionsDynamicFrame = gui:CreateDynamicFrame(layoutFrame, "$parentActions", 20, 10);
  local actionsScrollFrame = actionsDynamicFrame:WrapInScrollFrame();
  data.actions = gui:AddDialogTexture(actionsScrollFrame, "Low");
  data.actions = data.layoutTool:CreateCell(data.actions);
  data.actions:SetInsets(10);

  data.layoutTool:AddCells(data.description, data.addonWindow, data.actions);

  data.supportedDatabases = GetSupportedAddOns();

  -- Add ScrollFrame content:
  for addOnName, dbObject in pairs(data.supportedDatabases) do
    local cbContainer, dropdown = self:CreateScrollFrameRowContent(dbObject, addOnName);
    addonsDynamicFrame:AddChildren(cbContainer, dropdown);
  end

  self:UpdateAddOnWindow();

  -- Add menu content:
  local actionsFrame = data.actions:GetFrame()--[[@as Frame]];

  local layoutsDropdownContainer = tk:CreateFrame("Frame", actionsFrame);
  layoutsDropdownContainer:SetHeight(46);
  layoutsDropdownContainer.fullWidth = true;

  data.layoutsTitle = layoutsDropdownContainer:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  data.layoutsTitle:SetText(L["Layouts"] .. ":");
  data.layoutsTitle:SetPoint("TOPLEFT");

  data.layoutsDropDown = gui:CreateDropDown(layoutsDropdownContainer);
  data.layoutsDropDown:SetLabel(data.viewingLayout);
  data.layoutsDropDown:SetPoint("TOPLEFT", data.layoutsTitle, "BOTTOMLEFT", 0, -5);
  data.layoutsDropDown:SetPoint("BOTTOMRIGHT");

  for key, layoutData in db.global.layouts:Iterate() do
    if (layoutData) then
      data.layoutsDropDown:AddOption(key, { self; "SetViewingLayout" });
    end
  end

  data.createButton = gui:CreateButton(actionsFrame, L["Create New Layout"]);
  data.createButton:SetScript("OnClick", function() self:CreateLayout() end);
  data.createButton.fullWidth = true;

  data.renameButton = gui:CreateButton(actionsFrame, L["Rename Layout"]);
  data.renameButton:SetScript("OnClick", function() self:RenameLayout() end);
  data.renameButton.fullWidth = true;

  data.deleteButton = gui:CreateButton(actionsFrame, L["Delete Layout"]);
  data.deleteButton:SetScript("OnClick", function() self:DeleteLayout() end);
  data.deleteButton:SetEnabled(self:GetNumLayouts() ~= 1);
  data.deleteButton.fullWidth = true;

  actionsDynamicFrame:AddChildren(layoutsDropdownContainer, data.createButton, data.renameButton, data.deleteButton);
  actionsDynamicFrame:Refresh();

  data.layoutTool:Show();
  UIFrameFadeIn(data.layoutTool, 0.3, 0, 1);
  PlaySound(tk.Constants.MENU_OPENED_CLICK);
end
