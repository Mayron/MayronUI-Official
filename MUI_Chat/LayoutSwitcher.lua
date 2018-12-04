-- Setup namespaces ------------------
local addOnName, namespace = ...;
local C_ChatModule = namespace.C_ChatModule;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local LAYOUT_MESSAGE = 
[[Customize which addOn/s should change to which profile/s for each layout, 
as well as manage your existing layouts or create new ones.]];

-- Local Functions -------------------

local function SetAddOnProfilePair(self, viewingLayout, addOnName, profileName)
	db.global.chat.layouts[viewingLayout][addOnName] = profileName;
end

local function GetSupportedAddOns()
	local addOns = {"MayronUI"}; -- Add additional Supported AddOns here

	if (tk.IsAddOnLoaded("ShadowedUnitFrames")) then 
		table.insert(addOns, "ShadowUF"); 
	end

	if (LibStub) then
		for name, status in LibStub("AceAddon-3.0"):IterateAddonStatus() do
			local mod = string.find(name, "_");

			if ((not mod) and status) then
				local dbObject = tk.Tables:GetDBObject(name);

				if (dbObject and dbObject.SetProfile and dbObject.GetProfiles and dbObject.GetCurrentProfile) then
                    table.insert(addOns, name);
				end
			end
		end
	end

	return addOns;
end

local function GetNextLayout()
	local firstLayout, firstData;
	local foundCurrentLayout;
	local currentLayout = db.profile.chat.layout;

	for layoutName, layoutData in db.global.chat.layouts:Iterate() do
		if (not firstLayout) then
			firstLayout = layoutName;
			firstData = layoutData;
		end

		if (currentLayout == layoutName) then -- the next layout
			foundCurrentLayout = true;

		elseif (foundCurrentLayout) then
			-- Found the next layout!
			return layoutName, layoutData;
		end
	end

	-- The next layout must be back to the first layout
	return firstLayout, firstData;
end

local function LayoutButton_OnEnter(self)
	if (self.hideTooltip) then 
		return; 
	end

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 8, -38);
	GameTooltip:SetText("MUI Layout Button");
	GameTooltip:AddDoubleLine(tk.Strings:GetThemeColoredText("Left Click:"), "Switch Layout", 1, 1, 1);
	GameTooltip:AddDoubleLine(tk.Strings:GetThemeColoredText("Middle Click:"), "Toggle Blizzard Speech Menu", 1, 1, 1);
	GameTooltip:AddDoubleLine(tk.Strings:GetThemeColoredText("Right Click:"), "Show Layout Config Tool", 1, 1, 1);
	GameTooltip:AddDoubleLine(tk.Strings:GetThemeColoredText("ALT + Left Click:"), "Toggle Tooltip", 1, 0, 0, 1, 0, 0);
	GameTooltip:Show();
end

local function LayoutButton_OnLeave()
	GameTooltip:Hide();
end

local function LayoutButton_OnMouseUp(self, chat, btnPressed)
	if (not MouseIsOver(self)) then 
		return; 
	end

	if (btnPressed == "LeftButton") then
		if (tk:IsModComboActive("A")) then
			self.hideTooltip = not self.hideTooltip;

			-- assign inverted boolean to database
			data.sv.hideTooltip = self.hideTooltip;
			LayoutButton_OnEnter(self);

		else
			local layoutName, layoutData = GetNextLayout();
			chat:SwitchLayouts(layoutName, layoutData);

			tk.PlaySound(tk.Constants.CLICK);
			tk:Print(tk.Strings:GetRGBColoredText(layoutName, 0, 1, 0), "Layout enabled!");
		end

	elseif (btnPressed == "RightButton") then
		chat:ShowLayoutTool();

	elseif (data.menu:IsShown()) then
		data.menu:Hide();

	else
		data.menu:ClearAllPoints();
		data.menu:SetPoint("TOPLEFT", self, "TOPRIGHT", 8, 0);
		data.menu:Show();
		GameTooltip:Hide();
	end
end

-- C_ChatModule ------------------------

-- First function to be called!
function C_ChatModule:SetUpLayoutSwitcher(data, layoutButton)
	local layoutName = data.sv.layout;
	local firstCharacter = layoutName:sub(1, 1):upper();
	data.layoutButton = layoutButton;

	layoutButton:SetText(firstCharacter);		
	layoutButton:RegisterForClicks("LeftButtonDown", "RightButtonDown", "MiddleButtonDown");
	layoutButton:SetScript("OnEnter", LayoutButton_OnEnter);
	layoutButton:SetScript("OnLeave", LayoutButton_OnLeave);
	layoutButton:SetScript("OnMouseUp", function(_, btnPressed)
		LayoutButton_OnMouseUp(layoutButton, self, btnPressed);
	end);	
end


function C_ChatModule:SetViewingLayout(data, layoutName)
	if (not layoutName) then
		for key, layoutData in db.global.chat.layouts:Iterate() do
			if (layoutData) then
				layoutName = key;
				break;
			end
		end
	end

	data.viewingLayout = layoutName;

	if (db.global.chat.layouts[layoutName]) then
		self:UpdateAddOnWindow();
	end
end

function C_ChatModule:GetNumLayouts(data)
	local n = 0;

	for layoutName, layoutData in db.global.chat.layouts:Iterate() do
		if (layoutData) then
			n = n + 1;
		end
	end

	return n;
end

function C_ChatModule:UpdateAddOnWindow(data)
	if (not data.addonWindow) then return; end

	local layoutData = db.global.chat.layouts[data.viewingLayout];

	if (not layoutData) then
		self:SetViewingLayout();
		return;
	end

	local unchecked, addOnName;

	-- for i, child in tk.ipairs({ data.addonWindow.dynamicFrame:GetChildren() }) do
	-- 	if (i % 2 ~= 0) then
	-- 		-- checkbutton
	-- 		addOnName = child.btn.text:GetText();
	-- 		unchecked = not (not layoutData[addOnName]);
	-- 		child.btn:SetChecked(unchecked);
	-- 	else
	-- 		-- dropdownmenu
	-- 		local object = tk.Tables:GetDBObject(addOnName);
	-- 		child.btn.dropdown:SetEnabled(unchecked);

	-- 		if (unchecked) then
	-- 			child.btn.dropdown:SetLabel(layoutData[addOnName]);
	-- 		else
	-- 			child.btn.dropdown:SetLabel(object:GetCurrentProfile());
	-- 		end
	-- 	end
	-- end
end

function C_ChatModule:CreateNewAddOnProfile(data, self, addOnName, dbObject, dropdown)
	local newProfileLabel = string.format("Create New %s Profile:", addOnName);
	dropdown:SetLabel(db.global.chat.layouts[data.viewingLayout][addOnName]);

	if (StaticPopupDialogs["MUI_NewProfileLayout"]) then
		StaticPopupDialogs["MUI_NewProfileLayout"].text = newProfileLabel;
		StaticPopup_Show("MUI_NewProfileLayout");
	end

	StaticPopupDialogs["MUI_NewProfileLayout"] = {
		text = newProfileLabel,
		button1 = "Confirm",
		button2 = "Cancel",
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		hasEditBox  = true,
		preferredIndex = 3,
		OnAccept = function(dialog)
			local text = dialog.editBox:GetText();

			UIDropDownMenu_SetText(dialog, text);

			local currentProfile = dbObject:GetCurrentProfile();
			local alreadyExists = false;

			for _, profile in tk.ipairs(dbObject:GetProfiles()) do
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
	
	StaticPopupDialogs["MUI_NewProfileLayout"].text = newProfileLabel;
	StaticPopup_Show("MUI_NewProfileLayout");
end

function C_ChatModule:CreateLayout(data)
	if (StaticPopupDialogs["MUI_CreateLayout"]) then
		StaticPopup_Show("MUI_CreateLayout");
		return
	end

	local dropdown = data.layoutTool.dropdown;
	local length = dropdown:GetNumOptions();
	local totalLayouts = self:GetNumLayouts();

	StaticPopupDialogs["MUI_CreateLayout"] = {
		text = "Name of New Layout:",
		button1 = "Confirm",
		button2 = "Cancel",
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		hasEditBox  = true,
		preferredIndex = 3,
		OnShow = function (dialog)				
			dialog.editBox:SetText("Layout "..(length + 1));
		end,
		OnAccept = function(dialog)
			local layout = dialog.editBox:GetText();

			if (not db.global.chat.layouts[layout]) then
				db.global.chat.layouts[layout] = {};

				self:SetViewingLayout(layout);					
				dropdown:AddOption(layout, {self, "SetViewingLayout"});

				-- cannot delete a layout if only 1 exists
				data.layoutTool.deleteButton:SetEnabled(totalLayouts ~= 1);
			end
		end,
	};

	StaticPopup_Show("MUI_CreateLayout");
end

function C_ChatModule:RenameLayout(data)
	if (StaticPopupDialogs["MUI_RenameLayout"]) then
		StaticPopup_Show("MUI_RenameLayout");
		return;
	end

	StaticPopupDialogs["MUI_RenameLayout"] = {
		text = "Rename Layout:",
		button1 = "Confirm",
		button2 = "Cancel",
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		hasEditBox  = true,
		preferredIndex = 3,
		OnAccept = function(dialog)
			local layout = sedialoglf.editBox:GetText();

			if (not db.global.chat.layouts[layout]) then
				local oldViewingLayout = data.viewingLayout;
				local old = db.global.chat.layouts[data.viewingLayout];

				data.viewingLayout = layout;
				db.global.chat.layouts[layout] = old:GetTableValue();
				db.global.chat.layouts[oldViewingLayout] = false;

				local dropdown = data.layoutTool.dropdown;
				local btn = dropdown:GetOptionByLabel(oldViewingLayout);

				btn.value = layout;
				btn:SetText(layout);
				dropdown:SetLabel(layout);
			end
		end,
	};

	StaticPopup_Show("MUI_RenameLayout");
end

function C_ChatModule:DeleteLayout(data)
	if (StaticPopupDialogs["MUI_DeleteLayout"]) then
		StaticPopup_Show("MUI_DeleteLayout");
		return;
	end

	StaticPopupDialogs["MUI_DeleteLayout"] = {
		button1 = "Confirm",
		button2 = "Cancel",
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
		text = string.format("Are you sure you want to delete Layout \"%s\"?", data.viewingLayout),
		OnAccept = function()
			local dropdown = data.layoutTool.dropdown;
			dropdown:RemoveOptionByLabel(data.viewingLayout);
			db.global.chat.layouts[data.viewingLayout] = false;

			self:SetViewingLayout();

			local btn = dropdown:GetOptionByLabel(data.viewingLayout);
			dropdown:SetLabel(btn:GetText());					
			data.layoutTool.deleteButton:SetEnabled(self:GetNumLayouts() ~= 1);
		end,
	};

	StaticPopup_Show("MUI_DeleteLayout");
end

function C_ChatModule:CreateScrollFrameRowContent(data, dbObject, addOnName)
	local scrollFrame = data.addonWindow.dynamicFrame:GetFrame();
	local addOnProfiles = dbObject:GetProfiles();
	local dropdown = gui:CreateDropDown(tk.Constants.AddOnStyle, scrollFrame);
	local checkButton = gui:CreateCheckButton(scrollFrame, addOnName);

	checkButton:SetSize(160, dropdown:GetHeight());

	-- setup addOn dropdown menus with options
	dropdown:SetLabel(dbObject:GetCurrentProfile());	
	dropdown:AddOption("<New Profile>", {self, "CreateNewAddOnProfile"}, addOnName, dbObject, dropdown);
			
	for _, profileName in tk.ipairs(addOnProfiles) do
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

function C_ChatModule:ShowLayoutTool(data)
	if (data.layoutTool) then
		data.layoutTool:Show();
		self:UpdateAddOnWindow();
		UIFrameFadeIn(data.layoutTool, 0.3, 0, 1);
		return;
	end

	data.viewingLayout = data.sv.layout;

	data.layoutTool = gui:CreateDialogBox(tk.Constants.AddOnStyle);
	data.layoutTool:SetSize(700, 400);
	data.layoutTool:SetPoint("CENTER");

	gui:AddTitleBar(tk.Constants.AddOnStyle, data.layoutTool, "MUI Layout Tool");
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

	-- Add ScrollFrame content:
	for _, addonName in ipairs(GetSupportedAddOns()) do
		local dbObject = tk.Tables:GetDBObject(addonName);

		if (dbObject) then
			local checkButton, dropdown = self:CreateScrollFrameRowContent(dbObject, addonName);
			data.addonWindow.dynamicFrame:AddChildren(checkButton, dropdown);
		end
	end

	self:UpdateAddOnWindow();

	-- Add menu content:
	data.menu.layoutsTitle = data.menu:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
	data.menu.layoutsTitle:SetText("Layouts:");
	data.menu.layoutsTitle:SetPoint("TOPLEFT", 35, -35);

	data.menu.layoutsDropDown = gui:CreateDropDown(tk.Constants.AddOnStyle, data.menu:GetFrame());
	data.menu.layoutsDropDown:SetLabel(data.viewingLayout);
	data.menu.layoutsDropDown:SetPoint("TOPLEFT", data.menu.layoutsTitle, "BOTTOMLEFT", 0, -5);
	data.layoutTool.dropdown = data.menu.layoutsDropDown

	for key, layoutData in db.global.chat.layouts:Iterate() do
		if (layoutData) then
			data.menu.layoutsDropDown:AddOption(key, {self, "SetViewingLayout"});
		end
	end

	data.menu.createButton = gui:CreateButton(tk.Constants.AddOnStyle, data.menu:GetFrame(), "Create New Layout");
	data.menu.createButton:SetPoint("TOP", data.menu.layoutsDropDown:GetFrame(), "BOTTOM", 0, -20);
	data.menu.createButton:SetScript("OnClick", function() self:CreateLayout() end);

	data.menu.renameButton = gui:CreateButton(tk.Constants.AddOnStyle, data.menu:GetFrame(), "Rename Layout");
	data.menu.renameButton:SetPoint("TOP", data.menu.createButton, "BOTTOM", 0, -20);
	data.menu.renameButton:SetScript("OnClick", function() self:RenameLayout() end);

	data.menu.deleteButton = gui:CreateButton(tk.Constants.AddOnStyle, data.menu:GetFrame(), "Delete Layout");
	data.menu.deleteButton:SetPoint("TOP", data.menu.renameButton, "BOTTOM", 0, -20);
	data.menu.deleteButton:SetScript("OnClick", function() self:DeleteLayout() end);
	data.layoutTool.deleteButton = data.menu.deleteButton;

	data.menu.deleteButton:SetEnabled(self:GetNumLayouts() ~= 1);

	data.layoutTool:Show();
	UIFrameFadeIn(data.layoutTool, 0.3, 0, 1);
end

function C_ChatModule:SwitchLayouts(data, layoutName, layoutData)	
	data.sv.layout = layoutName;

	local firstCharacter = layoutName:sub(1, 1):upper();
	data.layoutButton:SetText(firstCharacter);    
	
	-- Switch all assigned addons to new profile
	for addOnName, profileName in pairs(layoutData) do
		if (profileName) then
			-- profileName could be false
			local object = tk.Tables:GetDBObject(addOnName);

			if (object) then
				object:SetProfile(profileName);
			end
		end
	end
end