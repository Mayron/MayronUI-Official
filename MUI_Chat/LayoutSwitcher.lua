-- Setup namespaces ------------------
local addOnName, namespace = ...;
local ChatClass = namespace.ChatClass;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

-- Local Functions -------------------

local function GetSupportedAddOns()
	local addons = {"MayronUI"}; -- Add additional Supported AddOns here

	if (tk.IsAddOnLoaded("ShadowedUnitFrames")) then 
		tk.table.insert(addons, "ShadowUF"); 
	end

	if (LibStub) then
		for name, status in LibStub("AceAddon-3.0"):IterateAddonStatus() do
			local mod = tk.string.find(name, "_");

			if ((not mod) and status) then
				local dbObject = tk.Tables:GetDBObject(name);

				if (dbObject and dbObject.SetProfile and dbObject.GetProfiles and dbObject.GetCurrentProfile) then
                    tk.table.insert(addons, name);
				end
			end
		end
	end

	return addons;
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

---------------------------------
-- Chat Button OnLoad Functions
---------------------------------
do
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

	-- First function to be called!
	function ChatClass:SetUpLayoutSwitcher(data, layoutButton)
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
end

function ChatClass:SetViewingLayout(data, layoutName)
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

		--TODO: Change this!
		self:UpdateAddOnWindow();
	end
end

function ChatClass:GetNumLayouts(data)
	local n = 0;

	for layoutName, layoutData in db.global.chat.layouts:Iterate() do
		if (layoutData) then
			n = n + 1;
		end
	end

	return n;
end

function ChatClass:UpdateAddOnWindow(data)
	if (not data.addonWindow) then return; end

	local layoutData = db.global.chat.layouts[data.viewingLayout];
	if (not layoutData) then
		SetViewingLayout();
		return;
	end

	local unchecked, addonName;

	for i, child in tk.ipairs({ data.addonWindow.dynamicFrame:GetChildren() }) do
		if (i % 2 ~= 0) then
			-- checkbutton
			addonName = child.btn.text:GetText();
			unchecked = not (not layoutData[addonName]);
			child.btn:SetChecked(unchecked);
		else
			-- dropdownmenu
			local object = tk.Tables:GetDBObject(addonName);
			child.btn.dropdown:SetEnabled(unchecked);

			if (unchecked) then
				child.btn.dropdown:SetLabel(layoutData[addonName]);
			else
				child.btn.dropdown:SetLabel(object:GetCurrentProfile());
			end
		end
	end
end

do
	local function SetAddOnProfilePair(self, addonName, profileName)
		db.global.chat.layouts[chat.viewingLayout][addonName] = profileName;
	end

	local function CreateNewAddOnProfile(self, addonName, dbObject, dropdown)
		dropdown:SetLabel(db.global.chat.layouts[chat.viewingLayout][addonName]);

		if (not tk.StaticPopupDialogs["MUI_NewProfileLayout"]) then
			tk.StaticPopupDialogs["MUI_NewProfileLayout"] = {
				text = "Create New "..addonName.." Profile:",
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
						dropdown:AddOption(text, SetAddOnProfilePair, addonName, text);
					end

					dbObject:SetProfile(text);
					dbObject:SetProfile(currentProfile);
					SetAddOnProfilePair(nil, addonName, text);
					dropdown:SetLabel(text);
				end,
			};
		end

        tk.StaticPopupDialogs["MUI_NewProfileLayout"].text = "Create New "..addonName.." Profile:";
        tk.StaticPopup_Show("MUI_NewProfileLayout");
	end

	local function CreateLayout()
		if (not tk.StaticPopupDialogs["MUI_CreateLayout"]) then

            tk.StaticPopupDialogs["MUI_CreateLayout"] = {
				text = "Name of New Layout:",
				button1 = "Confirm",
				button2 = "Cancel",
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				hasEditBox  = true,
				preferredIndex = 3,
				OnShow = function (self)
					local dropdown = chat.layoutTool.dropdown;
					local length = dropdown:GetNumOptions();

					self.editBox:SetText("Layout "..(length + 1));
				end,
				OnAccept = function(self)
					local layout = self.editBox:GetText();

					if (not db.global.chat.layouts[layout]) then
						db.global.chat.layouts[layout] = {};
						SetViewingLayout(layout);

						local dropdown = chat.layoutTool.dropdown;
						dropdown:AddOption(layout, SetViewingLayout);

						chat.layoutTool.deleteButton:SetEnabled(ChatClass:GetNumLayouts() ~= 1);
					end
				end,
			}
		end

        tk.StaticPopup_Show("MUI_CreateLayout");
	end

	local function RenameLayout()
		if (not tk.StaticPopupDialogs["MUI_RenameLayout"]) then
            tk.StaticPopupDialogs["MUI_RenameLayout"] = {
				text = "Rename Layout:",
				button1 = "Confirm",
				button2 = "Cancel",
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				hasEditBox  = true,
				preferredIndex = 3,
				OnAccept = function(self)
					local layout = self.editBox:GetText();
					if (not db.global.chat.layouts[layout]) then
						local oldViewingLayout = chat.viewingLayout;
						local old = db.global.chat.layouts[chat.viewingLayout];
						chat.viewingLayout = layout;
						db.global.chat.layouts[layout] = old:GetTableValue();
						db.global.chat.layouts[oldViewingLayout] = false;
						local dropdown = chat.layoutTool.dropdown;
						local btn = dropdown:GetOption(oldViewingLayout);
						btn.value = layout;
						btn:SetText(layout);
						dropdown:SetLabel(layout);
					end
				end,
			}
		end
        tk.StaticPopup_Show("MUI_RenameLayout");
	end

	local function DeleteLayout()
		if (not tk.StaticPopupDialogs["MUI_DeleteLayout"]) then

            tk.StaticPopupDialogs["MUI_DeleteLayout"] = {
				button1 = "Confirm",
				button2 = "Cancel",
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,
				text = "Are you sure you want to delete Layout \""..chat.viewingLayout.."\"?",
				OnAccept = function(self)
					local dropdown = chat.layoutTool.dropdown;
					dropdown:RemoveOption(chat.viewingLayout);
					db.global.chat.layouts[chat.viewingLayout] = false;

					SetViewingLayout();

					local btn = dropdown:GetOption(chat.viewingLayout);
					dropdown:SetLabel(btn:GetText());					
					chat.layoutTool.deleteButton:SetEnabled(ChatClass:GetNumLayouts() ~= 1);
				end,
			}
		end

        tk.StaticPopup_Show("MUI_DeleteLayout");
	end

	local function CreateScrollFrameRowContent(scrolLFrame, dbObject, addOnName)
		local addOnProfiles = dbObject:GetProfiles();
		local dropdown = gui:CreateDropDown(tk.Constants.AddOnStyle, scrollFrame);
		local checkButton = gui:CreateCheckButton(scrollFrame, addonName);

		checkButton:SetSize(160, dropdown:GetHeight());

		-- setup addOn dropdown menus with options
		dropdown:SetLabel(dbObject:GetCurrentProfile());	
		dropdown:AddOption("<New Profile>", CreateNewAddOnProfile, addonName, dbObject, dropdown);
				
		for _, profileName in tk.ipairs(addOnProfiles) do
			dropdown:AddOption(profileName, SetAddOnProfilePair, addonName, profileName);
		end

		-- checkButton.btn:SetScript("OnClick", function(self)
		-- 	dropdown:SetEnabled(data:GetChecked()); --TODO: data:GetChecked???

		-- 	if (not data:GetChecked()) then
		-- 		SetAddOnProfilePair(nil, addonName, false);
		-- 	else
		-- 		SetAddOnProfilePair(nil, addonName, dropdown:GetLabel());
		-- 	end
		-- end);

		return checkButton, dropdown;		
	end

	function ChatClass:ShowLayoutTool(data)
		if (data.layoutTool) then
			data.layoutTool:Show();
			data:UpdateAddOnWindow();
			tk.UIFrameFadeIn(data.layoutTool, 0.3, 0, 1);
			return;
		end

		data.viewingLayout = data.sv.layout;

		data.layoutTool = gui:CreateDialogBox(tk.Constants.AddOnStyle);
		data.layoutTool:SetSize(700, 400);

		--data.layoutTool:data("CENTER");

		gui:AddTitleBar(data.layoutTool, "MUI Layout Tool");
		gui:AddCloseButton(data.layoutTool);

		data.layoutTool = gui:CreatePanel(data.layoutTool);
		data.layoutTool:SetDevMode(false); -- shows or hides the red frame info overlays
		data.layoutTool:SetDimensions(2, 2);
		data.layoutTool:GetRow(1):SetFixed(80);
		data.layoutTool:GetColumn(1):SetFixed(400);

		data.description = data.layoutTool:CreateCell();
		data.description:SetDimensions(2, 1);
		data.description:SetInsets(20, 50, 0, 50);

		data.description.text = data.description:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
		data.description.text:SetAllPoints(true);
		data.description.text:SetWordWrap(true);
		data.description.text:SetText("Here you can customise which AddOn/s should change to which Profile/s for each individual Layout, as well as manage your existing Layouts or create new Layouts.");

		data.addonWindow = gui:CreateDynamicFrame(data.layoutTool:GetFrame(), 5, 10);
		gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, "LOW", data.addonWindow);

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
				local scrollFrame = data.addonWindow.dynamicFrame:GetFrame();
				local checkButton, dropdown = CreateScrollFrameRowContent(scrollFrame, dbObject, addonName);
				data.addonWindow.dynamicFrame:AddChildren(checkButton, dropdown);
			end
		end

		data:UpdateAddOnWindow();
        tk.UIFrameFadeIn(data.layoutTool, 0.3, 0, 1);

		-- Add menu content:
        data.menu.layoutsTitle = data.menu:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        data.menu.layoutsTitle:SetText("Layouts:");
        data.menu.layoutsTitle:SetPoint("TOPLEFT", 35, -35);

        data.menu.layoutsDropDown = gui:CreateDropDown(data.menu:GetFrame());
        data.menu.layoutsDropDown:SetLabel(data.viewingLayout);
        data.menu.layoutsDropDown:SetPoint("TOPLEFT", data.menu.layoutsTitle, "BOTTOMLEFT", 0, -5);
		data.layoutTool.dropdown = data.menu.layoutsDropDown

		for key, layoutData in db.global.chat.layouts:Iterate() do
			if (layoutData) then
                data.menu.layoutsDropDown:AddOption(key, SetViewingLayout);
			end
		end

        data.menu.createButton = gui:CreateButton(data.menu:GetFrame(), "Create New Layout");
        data.menu.createButton:SetPoint("TOP", data.menu.layoutsDropDown:GetFrame(), "BOTTOM", 0, -20);
        data.menu.createButton:SetScript("OnClick", CreateLayout);

        data.menu.renameButton = gui:CreateButton(data.menu:GetFrame(), "Rename Layout");
        data.menu.renameButton:SetPoint("TOP", data.menu.createButton, "BOTTOM", 0, -20);
        data.menu.renameButton:SetScript("OnClick", RenameLayout);

        data.menu.deleteButton = gui:CreateButton(data.menu:GetFrame(), "Delete Layout");
        data.menu.deleteButton:SetPoint("TOP", data.menu.renameButton, "BOTTOM", 0, -20);
        data.menu.deleteButton:SetScript("OnClick", DeleteLayout);
		data.layoutTool.deleteButton = data.menu.deleteButton;

        data.menu.deleteButton:SetEnabled(ChatClass:GetNumLayouts() ~= 1);
	end
end

function ChatClass:SwitchLayouts(data, layoutName, layoutData)	
	data.sv.layout = layoutName;

	local firstCharacter = layoutName:sub(1, 1):upper();
	data.layoutButton:SetText(firstCharacter);    
	
	-- Switch all assigned addons to new profile
	for addonName, profileName in pairs(layoutData) do

		if (profileName) then
			-- profileName could be false
			local object = tk.Tables:GetDBObject(addonName);

			if (object) then
				object:SetProfile(profileName);
			end
		end
	end
end