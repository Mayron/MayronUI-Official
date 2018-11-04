-- Setup namespaces ------------------
local addOnName, namespace = ...;
local ChatClass = namespace.ChatClass;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();
local ChatClass = namespace.ChatClass;

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
				local dbObject = tk:GetDBObject(name);

				if (dbObject and dbObject.SetProfile and dbObject.GetProfiles and dbObject.GetCurrentProfile) then
                    tk.table.insert(addons, name);
				end
			end
		end
	end

	return addons;
end

---------------------------------
-- Chat Button OnLoad Functions
---------------------------------
do
	local function LayoutButton_OnEnter(self)
		if (chat.sv.hideTooltip) then return; end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 8, -38);
		GameTooltip:SetText("MUI Layout Button");
		GameTooltip:AddDoubleLine(tk:GetThemeColoredString("Left Click:"), "Switch Layout", 1, 1, 1);
		GameTooltip:AddDoubleLine(tk:GetThemeColoredString("Middle Click:"), "Toggle Blizzard Speech Menu", 1, 1, 1);
		GameTooltip:AddDoubleLine(tk:GetThemeColoredString("Right Click:"), "Show Layout Config Tool", 1, 1, 1);
		GameTooltip:AddDoubleLine(tk:GetThemeColoredString("ALT + Left Click:"), "Toggle Tooltip", 1, 0, 0, 1, 0, 0);
		GameTooltip:Show();
	end

	function ChatClass:SetUpLayoutSwitcher(data)
    	for layoutName, layoutData in db.global.chat.layouts:Iterate() do
			if (not layoutData and layoutName ~= "Healer" and layoutName ~= "DPS") then
				db.global.chat.layouts[layoutName] = nil;
			end
		end

		--TODO
		for _, data in data.sv.              :Iterate() do
			if (chat.sv.enabled[data.name]) then
				local cf = data.chatFrames[data.name];
				cf.layoutButton:RegisterForClicks("LeftButtonDown", "RightButtonDown", "MiddleButtonDown");
				cf.layoutButton:SetText(self.sv.layout:sub(1, 1):upper());

				cf.layoutButton:SetScript("OnEnter", LayoutButton_OnEnter);
				cf.layoutButton:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end);

				cf.layoutButton:SetScript("OnMouseUp", function(self, btn)
					if (not MouseIsOver(self)) then 
						return; 
					end

					if (btn == "LeftButton") then
						if (tk:IsModComboActive("A")) then
							chat.sv.hideTooltip = not chat.sv.hideTooltip;
							if (chat.sv.hideTooltip) then
								GameTooltip:Hide();
							else
								LayoutButton_OnEnter(self);
							end
							return;
						end

						local firstLayout, firstData;
						local nextLayout;
						local switched;

						for key, layoutData in db.global.chat.layouts:Iterate() do
							if (layoutData) then
								if (not firstLayout) then
									firstLayout = key;
									firstData = layoutData;
								end

								if (chat.sv.layout == key) then -- the next layout
									nextLayout = true;
								elseif (nextLayout) then
									chat:SwitchLayouts(key, layoutData, self);
									switched = true;
									break;
								end
							end
						end

						if (not switched) then
							if (firstLayout ~= chat.sv.layout) then
								chat:SwitchLayouts(firstLayout, firstData, self);
							else
								tk:Print(tk:GetRGBColoredString(firstLayout, 0, 1, 0), "Layout enabled!");
							end
						end

					elseif (btn == "RightButton") then
						chat:ShowLayoutTool();
					elseif (ChatMenu:IsShown()) then
						ChatMenu:Hide();
					else
						ChatMenu:ClearAllPoints();
						ChatMenu:SetPoint("TOPLEFT", self, "TOPRIGHT", 8, 0);
						ChatMenu:Show();
						GameTooltip:Hide();
					end
				end);
			end
		end
	end
end

---------------------------------
-- Layout Tool functions
---------------------------------
local function SetViewingLayout(self, layoutName)
	if (not layoutName) then
		for key, layoutData in db.global.chat.layouts:Iterate() do
			if (layoutData) then
				layoutName = key; -- get first layout!
				break;
			end
		end
	end
	chat.viewingLayout = layoutName;
	if (db.global.chat.layouts[layoutName]) then
		chat:UpdateAddOnWindow();
	end
end

function chat:GetNumLayouts()
	local n = 0;
	for layoutName, layoutData in db.global.chat.layouts:Iterate() do
		if (layoutData) then
			n = n + 1;
		end
	end
	return n;
end

function chat:UpdateAddOnWindow()
	if (not self.addonWindow) then return; end

	local layoutData = db.global.chat.layouts[self.viewingLayout];
	if (not layoutData) then
		SetViewingLayout();
		return;
	end

	local children = {self.addonWindow.dynamicFrame:GetChildren()};

	local unchecked, addonName;
	for i, child in tk.ipairs(children) do
		if (i % 2 ~= 0) then
			-- checkbutton
			addonName = child.btn.text:GetText();
			unchecked = not (not layoutData[addonName]);
			child.btn:SetChecked(unchecked);
		else
			-- dropdownmenu
			local object = tk:GetDBObject(addonName);
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
					local self = private.temp;
					local text = dialog.editBox:GetText()
					UIDropDownMenu_SetText(dialog, text)
					local currentProfile = self.dbObject:GetCurrentProfile();
					local alreadyExists = false;
					for _, profile in tk.ipairs(self.dbObject:GetProfiles()) do
						if (profile == text) then
							alreadyExists = true;
							break;
						end
					end
					if (not alreadyExists) then
						self.dropdown:AddOption(text, SetAddOnProfilePair, self.addonName, text);
					end
					self.dbObject:SetProfile(text);
					self.dbObject:SetProfile(currentProfile);
					SetAddOnProfilePair(nil, self.addonName, text);
					self.dropdown:SetLabel(text);
				end,
			};
		end
		private.temp = private.temp or {};
		private.temp.addonName = addonName;
		private.temp.dbObject = dbObject;
		private.temp.dropdown = dropdown;
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
						chat.layoutTool.deleteButton:SetEnabled(chat:GetNumLayouts() ~= 1);
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
					chat.layoutTool.deleteButton:SetEnabled(chat:GetNumLayouts() ~= 1);
				end,
			}
		end
        tk.StaticPopup_Show("MUI_DeleteLayout");
	end

	function chat:ShowLayoutTool()
		if (self.layoutTool) then
			self.layoutTool:Show();
			self:UpdateAddOnWindow();
			tk.UIFrameFadeIn(self.layoutTool, 0.3, 0, 1);
			return;
		end
		self.viewingLayout = self.sv.layout;
		self.layoutTool = gui:CreateDialogBox();
		self.layoutTool:SetSize(700, 400);
		self.layoutTool:SetPoint("CENTER");
		gui:AddTitleBar(self.layoutTool, "MUI Layout Tool");
		gui:AddCloseButton(self.layoutTool);

		self.layoutTool = gui:CreatePanel(self.layoutTool);
		self.layoutTool:SetDevMode(false); -- shows or hides the red frame info overlays
		self.layoutTool:SetDimensions(2, 2);
		self.layoutTool:GetRow(1):SetFixed(80);
		self.layoutTool:GetColumn(1):SetFixed(400);

		self.description = self.layoutTool:CreateCell();
		self.description:SetDimensions(2, 1);
		self.description:SetInsets(20, 50, 0, 50);
		self.description.text = self.description:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
		self.description.text:SetAllPoints(true);
		self.description.text:SetWordWrap(true);
		self.description.text:SetText("Here you can customise which AddOn/s should change to which Profile/s for each individual Layout, as well as manage your existing Layouts or create new Layouts.");

		self.addonWindow = gui:CreateDynamicFrame(self.layoutTool:GetFrame(), 5, 10);
		gui:CreateDialogBox(nil, "LOW", self.addonWindow);

		self.addonWindow = self.layoutTool:CreateCell(self.addonWindow);
        self.addonWindow.dynamicFrame = self.addonWindow:GetFrame();
		self.addonWindow:SetInsets(10, 0, 10, 10);

		self.menu = gui:CreateDialogBox(self.layoutTool:GetFrame(), "LOW");
		self.menu = self.layoutTool:CreateCell(self.menu);
		self.menu:SetInsets(10, 10, 10, 15);

		self.layoutTool:AddCells(self.description, self.addonWindow, self.menu);

		-- Add ScrollFrame content:
		for _, addonName in ipairs(GetSupportedAddOns()) do
			local dbObject = tk:GetDBObject(addonName);
			local dropdown = gui:CreateDropDown(self.addonWindow.dynamicFrame:GetFrame());
            dropdown:SetLabel(dbObject:GetCurrentProfile());

			local cb = gui:CreateCheckButton(self.addonWindow.dynamicFrame:GetFrame(), addonName);
			cb:SetSize(160, dropdown:GetHeight());
			cb.btn:SetScript("OnClick", function(self)
				dropdown:SetEnabled(self:GetChecked());
				if (not self:GetChecked()) then
					SetAddOnProfilePair(nil, addonName, false);
				else
					SetAddOnProfilePair(nil, addonName, dropdown:GetLabel());
				end
			end);

			if (dbObject) then
				local profiles = dbObject:GetProfiles();
				for _, profileName in tk.ipairs(profiles) do
					dropdown:AddOption(profileName, SetAddOnProfilePair, addonName, profileName);
				end
				dropdown:AddOption("<New Profile>", CreateNewAddOnProfile, addonName, dbObject, dropdown);
            end

            self.addonWindow.dynamicFrame:AddChildren(cb, dropdown);
		end
		self:UpdateAddOnWindow();
        tk.UIFrameFadeIn(self.layoutTool, 0.3, 0, 1);

		-- Add menu content:
        self.menu.layoutsTitle = self.menu:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        self.menu.layoutsTitle:SetText("Layouts:");
        self.menu.layoutsTitle:SetPoint("TOPLEFT", 35, -35);

        self.menu.layoutsDropDown = gui:CreateDropDown(self.menu:GetFrame());
        self.menu.layoutsDropDown:SetLabel(self.viewingLayout);
        self.menu.layoutsDropDown:SetPoint("TOPLEFT", self.menu.layoutsTitle, "BOTTOMLEFT", 0, -5);
		self.layoutTool.dropdown = self.menu.layoutsDropDown

		for key, layoutData in db.global.chat.layouts:Iterate() do
			if (layoutData) then
                self.menu.layoutsDropDown:AddOption(key, SetViewingLayout);
			end
		end

        self.menu.createButton = gui:CreateButton(self.menu:GetFrame(), "Create New Layout");
        self.menu.createButton:SetPoint("TOP", self.menu.layoutsDropDown:GetFrame(), "BOTTOM", 0, -20);
        self.menu.createButton:SetScript("OnClick", CreateLayout);

        self.menu.renameButton = gui:CreateButton(self.menu:GetFrame(), "Rename Layout");
        self.menu.renameButton:SetPoint("TOP", self.menu.createButton, "BOTTOM", 0, -20);
        self.menu.renameButton:SetScript("OnClick", RenameLayout);

        self.menu.deleteButton = gui:CreateButton(self.menu:GetFrame(), "Delete Layout");
        self.menu.deleteButton:SetPoint("TOP", self.menu.renameButton, "BOTTOM", 0, -20);
        self.menu.deleteButton:SetScript("OnClick", DeleteLayout);
		self.layoutTool.deleteButton = self.menu.deleteButton;

        self.menu.deleteButton:SetEnabled(chat:GetNumLayouts() ~= 1);
	end
end

function chat:SwitchLayouts(name, layoutData, btn)
	tk:Print(tk:GetRGBColoredString(name, 0, 1, 0), "Layout enabled!");
	self.sv.layout = name;
	btn:SetText(name:sub(1, 1):upper());
    tk.PlaySound(tk.Constants.CLICK);

	for addonName, profileName in pairs(layoutData) do
		local object = tk:GetDBObject(addonName);
		if (object and profileName) then -- profileName coudl be false
			object:SetProfile(profileName);
		end
	end
end