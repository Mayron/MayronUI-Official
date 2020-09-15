-- luacheck: ignore MayronUI self 143
-- Setup namespaces ------------------
local _, namespace = ...;
local Engine = namespace.Engine;
local tk, db, _, gui, obj, L = MayronUI:GetCoreComponents();
local C_LayoutSwitcher = MayronUI:RegisterModule("LayoutSwitcher");

local ipairs, string = _G.ipairs, _G.string;
local LibStub, IsAddOnLoaded = _G.LibStub, _G.IsAddOnLoaded;

local LAYOUT_MESSAGE = L["Customize which addOn/s should change to which profile/s for each layout, as well as manage your existing layouts or create new ones."];

-- Local Functions -------------------

local function SetAddOnProfilePair(_, viewingLayout, addOnName, profileName)
	db:SetPathValue(db.global, string.format("layouts.%s.%s", viewingLayout, addOnName), profileName);
end

local function GetSupportedAddOns()
  local addOns = obj:PopTable(); -- Add additional Supported AddOns here

  ---@type LibMayronDB
  local LibMayronDB = LibStub:GetLibrary("LibMayronDB");

  for _, database in LibMayronDB:IterateDatabases() do
    addOns[database:GetDatabaseName()] = database;
  end

  -- local dbObject = tk.Tables:GetDBObject(addOnName);
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

Engine:DefineParams("?DropDownMenu", "?string");
function C_LayoutSwitcher:SetViewingLayout(data, dropdown, layoutName)
	if (not layoutName) then
		if (dropdown) then
			layoutName = dropdown:GetLabel();
		else
			for key, layoutData in db.global.layouts:Iterate() do
				if (layoutData) then
					layoutName = key;
					break;
				end
			end
		end
	end

	data.viewingLayout = layoutName;

	if (db.global.layouts[layoutName]) then
		self:UpdateAddOnWindow();
	end
end

Engine:DefineReturns("number");
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
	if (not data.addonWindow) then return; end

  local layoutData = db.global.layouts[data.viewingLayout];

	if (not layoutData) then
		self:SetViewingLayout();
		return;
	end

	local checked, addOnName;

	for i, child in obj:IterateArgs(data.addonWindow.dynamicFrame:GetChildren()) do

		if (i % 2 ~= 0) then
			-- checkbutton
			addOnName = child.btn.text:GetText();
			checked = layoutData[addOnName];
			child.btn:SetChecked(checked);
		else
      -- dropdownmenu
			local object = tk.Tables:GetDBObject(addOnName);
			child:SetEnabled(checked);

			if (checked) then
				child:SetLabel(layoutData[addOnName]);
			else
				child:SetLabel(object:GetCurrentProfile());
			end
		end
	end
end

Engine:DefineParams("DropDownMenu", "string", "table");
function C_LayoutSwitcher:CreateNewAddOnProfile(data, dropdown, addOnName, dbObject)
	local newProfileLabel = string.format("Create New %s Profile:", addOnName);
	dropdown:SetLabel(db.global.layouts[data.viewingLayout][addOnName]);

	if (_G.StaticPopupDialogs["MUI_NewProfileLayout"]) then
		_G.StaticPopupDialogs["MUI_NewProfileLayout"].text = newProfileLabel;
		_G.StaticPopup_Show("MUI_NewProfileLayout");
	end

	_G.StaticPopupDialogs["MUI_NewProfileLayout"] = {
		text = newProfileLabel,
		button1 = L["Confirm"],
		button2 = L["Cancel"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		hasEditBox  = true,
		preferredIndex = 3,
		OnAccept = function(dialog)
			local text = dialog.editBox:GetText();

			_G.UIDropDownMenu_SetText(dialog, text);

			local currentProfile = dbObject:GetCurrentProfile();
			local alreadyExists = false;

			for _, profile in ipairs(dbObject:GetProfiles()) do
				if (profile == text) then
					alreadyExists = true;
					break;
				end
			end

			if (not alreadyExists) then
				dropdown:AddOption(text, SetAddOnProfilePair, data.viewingLayout, addOnName, text);
			end

			dbObject:SetProfile(text);
			dbObject:SetProfile(currentProfile);
			SetAddOnProfilePair(nil, data.viewingLayout, addOnName, text);

			dropdown:SetLabel(text);
		end,
	};

	_G.StaticPopupDialogs["MUI_NewProfileLayout"].text = newProfileLabel;
	_G.StaticPopup_Show("MUI_NewProfileLayout");
end

function C_LayoutSwitcher:CreateLayout(data)
	if (_G.StaticPopupDialogs["MUI_CreateLayout"]) then
		_G.StaticPopup_Show("MUI_CreateLayout");
		return;
	end

	local dropdown = data.layoutTool.dropdown;
	local length = dropdown:GetNumOptions();
	local totalLayouts = self:GetNumLayouts();

	_G.StaticPopupDialogs["MUI_CreateLayout"] = {
		text = L["Name of New Layout"]..": ",
		button1 = L["Confirm"],
		button2 = L["Cancel"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		hasEditBox  = true,
		preferredIndex = 3,
		OnShow = function (dialog)
			dialog.editBox:SetText(L["Layout"].." "..(length + 1));
		end,
		OnAccept = function(dialog)
			local layout = dialog.editBox:GetText();

			if (not db.global.layouts[layout]) then
				db.global.layouts[layout] = obj:PopTable();

				dropdown:AddOption(layout, {self, "SetViewingLayout"});
				self:SetViewingLayout(nil, layout);
				dropdown:SetLabel(layout);

				-- cannot delete a layout if only 1 exists
				data.layoutTool.deleteButton:SetEnabled(totalLayouts ~= 1);
			end
		end,
	};

	_G.StaticPopup_Show("MUI_CreateLayout");
end

function C_LayoutSwitcher:RenameLayout(data)
	if (_G.StaticPopupDialogs["MUI_RenameLayout"]) then
		_G.StaticPopup_Show("MUI_RenameLayout");
		return;
	end

	_G.StaticPopupDialogs["MUI_RenameLayout"] = {
		text = L["Rename Layout"]..":",
		button1 = L["Confirm"],
		button2 = L["Cancel"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		hasEditBox  = true,
		preferredIndex = 3,
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

			local dropdown = data.layoutTool.dropdown;
			local btn = dropdown:GetOptionByLabel(oldViewingLayout);

			btn.value = layout;
			btn:SetText(layout);
			dropdown:SetLabel(layout);
		end,
	};

	_G.StaticPopup_Show("MUI_RenameLayout");
end

function C_LayoutSwitcher:DeleteLayout(data)
	if (_G.StaticPopupDialogs["MUI_DeleteLayout"]) then
		_G.StaticPopup_Show("MUI_DeleteLayout");
		return;
	end

	_G.StaticPopupDialogs["MUI_DeleteLayout"] = {
		button1 = L["Confirm"],
		button2 = L["Cancel"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		text = string.format(L["Are you sure you want to delete Layout '%s'?"], data.viewingLayout),
		OnAccept = function()
			local dropdown = data.layoutTool.dropdown;
			dropdown:RemoveOptionByLabel(data.viewingLayout);
			db.global.layouts[data.viewingLayout] = false;

			self:SetViewingLayout();

			local btn = dropdown:GetOptionByLabel(data.viewingLayout);
			dropdown:SetLabel(btn:GetText());
			data.layoutTool.deleteButton:SetEnabled(self:GetNumLayouts() ~= 1);
		end,
	};

	_G.StaticPopup_Show("MUI_DeleteLayout");
end

Engine:DefineParams("table", "string");
Engine:DefineReturns("Frame", "DropDownMenu");
function C_LayoutSwitcher:CreateScrollFrameRowContent(data, dbObject, addOnName)
	local scrollFrame = data.addonWindow.dynamicFrame:GetFrame();
	local addOnProfiles = dbObject:GetProfiles();
	local dropdown = gui:CreateDropDown(tk.Constants.AddOnStyle, scrollFrame);
  local checkButton = gui:CreateCheckButton(scrollFrame, addOnName);

	checkButton:SetSize(186, dropdown:GetHeight());

	-- setup addOn dropdown menus with options
	dropdown:SetLabel(dbObject:GetCurrentProfile());
	dropdown:AddOption("<"..L["New Profile"]..">", {self, "CreateNewAddOnProfile"}, addOnName, dbObject);

	for _, profileName in ipairs(addOnProfiles) do
		dropdown:AddOption(profileName, SetAddOnProfilePair, data.viewingLayout, addOnName, profileName);
	end

	checkButton.btn:SetScript("OnClick", function(self)
		local checked = checkButton.btn:GetChecked();
		dropdown:SetEnabled(checked);

		if (not checked) then
			SetAddOnProfilePair(nil, data.viewingLayout, addOnName, false);
		else
			local profileName = dropdown:GetLabel();
			SetAddOnProfilePair(nil, data.viewingLayout, addOnName, profileName);
		end
	end);

	return checkButton, dropdown;
end

function C_LayoutSwitcher:ShowLayoutTool(data)
	if (data.layoutTool) then
		data.layoutTool:Show();
		self:UpdateAddOnWindow();
		_G.UIFrameFadeIn(data.layoutTool, 0.3, 0, 1);
		return;
	end

	data.viewingLayout = db.profile.layout;

	data.layoutTool = gui:CreateDialogBox(tk.Constants.AddOnStyle);
	data.layoutTool:SetSize(700, 400);
	data.layoutTool:SetPoint("CENTER");

	gui:AddTitleBar(tk.Constants.AddOnStyle, data.layoutTool, L["MUI Layout Tool"]);
	gui:AddCloseButton(tk.Constants.AddOnStyle, data.layoutTool);

	-- convert to panel
	data.layoutTool = gui:CreatePanel(data.layoutTool);
	data.layoutTool:SetDevMode(false); -- show or hide the red frame info overlays (default is hidden)
	data.layoutTool:SetDimensions(2, 2);
	data.layoutTool:GetRow(1):SetFixed(80);
	data.layoutTool:GetColumn(1):SetFixed(400);

	data.description = data.layoutTool:CreateCell();
	data.description:SetDimensions(2, 1);
	data.description:SetInsets(20, 50, 0, 50);

	data.description.text = data.description:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
	data.description.text:SetAllPoints(true);
	data.description.text:SetWordWrap(true);
	data.description.text:SetText(LAYOUT_MESSAGE);

	data.addonWindow = gui:CreateDynamicFrame(tk.Constants.AddOnStyle, data.layoutTool:GetFrame(), 5, 10);
	gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, "LOW", data.addonWindow:GetFrame());

	data.addonWindow = data.layoutTool:CreateCell(data.addonWindow);
	data.addonWindow.dynamicFrame = data.addonWindow:GetFrame();
	data.addonWindow:SetInsets(10, 0, 10, 10);

	local parent = data.layoutTool:GetFrame();
	data.menu = gui:CreateDialogBox(tk.Constants.AddOnStyle, parent, "LOW");
	data.menu = data.layoutTool:CreateCell(data.menu);
	data.menu:SetInsets(10, 10, 10, 15);

	data.layoutTool:AddCells(data.description, data.addonWindow, data.menu);

  local supportedAddOns = GetSupportedAddOns();

	-- Add ScrollFrame content:
	for addOnName, dbObject in pairs(supportedAddOns) do
    local checkButton, dropdown = self:CreateScrollFrameRowContent(dbObject, addOnName);
    data.addonWindow.dynamicFrame:AddChildren(checkButton, dropdown);
	end

  obj:PushTable(supportedAddOns);
	self:UpdateAddOnWindow();

	-- Add menu content:
	data.menu.layoutsTitle = data.menu:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
	data.menu.layoutsTitle:SetText(L["Layouts"]..":");
	data.menu.layoutsTitle:SetPoint("TOPLEFT", 35, -35);

	data.menu.layoutsDropDown = gui:CreateDropDown(tk.Constants.AddOnStyle, data.menu:GetFrame());
	data.menu.layoutsDropDown:SetLabel(data.viewingLayout);
	data.menu.layoutsDropDown:SetPoint("TOPLEFT", data.menu.layoutsTitle, "BOTTOMLEFT", 0, -5);
	data.layoutTool.dropdown = data.menu.layoutsDropDown

	for key, layoutData in db.global.layouts:Iterate() do
		if (layoutData) then
			data.menu.layoutsDropDown:AddOption(key, {self, "SetViewingLayout"});
		end
	end

	data.menu.createButton = gui:CreateButton(tk.Constants.AddOnStyle, data.menu:GetFrame(), L["Create New Layout"]);
	data.menu.createButton:SetPoint("TOP", data.menu.layoutsDropDown:GetFrame(), "BOTTOM", 0, -20);
	data.menu.createButton:SetScript("OnClick", function() self:CreateLayout() end);

	data.menu.renameButton = gui:CreateButton(tk.Constants.AddOnStyle, data.menu:GetFrame(), L["Rename Layout"]);
	data.menu.renameButton:SetPoint("TOP", data.menu.createButton, "BOTTOM", 0, -20);
	data.menu.renameButton:SetScript("OnClick", function() self:RenameLayout() end);

	data.menu.deleteButton = gui:CreateButton(tk.Constants.AddOnStyle, data.menu:GetFrame(), L["Delete Layout"]);
	data.menu.deleteButton:SetPoint("TOP", data.menu.renameButton, "BOTTOM", 0, -20);
	data.menu.deleteButton:SetScript("OnClick", function() self:DeleteLayout() end);
	data.layoutTool.deleteButton = data.menu.deleteButton;

	data.menu.deleteButton:SetEnabled(self:GetNumLayouts() ~= 1);

	data.layoutTool:Show();
	_G.UIFrameFadeIn(data.layoutTool, 0.3, 0, 1);
end