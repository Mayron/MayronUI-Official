--[[----------------------------------
--  MultiSelect widget for AceGUI-3.0
--  Written by Shirokuma
--
--  Edited and changed by Beautiuz
--]]----------------------------------


--[[-----------------
-- AceGUI
--]]-----------------
local AceGUI = LibStub("AceGUI-3.0")

--[[-----------------
-- Lua APIs
--]]-----------------
local format, pairs, tostring = string.format, pairs, tostring

--[[-----------------
-- WoW APIs
--]]-----------------
local CreateFrame, UIParent = CreateFrame, UIParent

--[[-----------------
-- Frame Elements
--]]-----------------
local FrameBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}


--[[-----------------
-- Widget Info
--]]-----------------
local widgetType = "MultiSelect"
local widgetVersion = 1


--[[-----------------
-- Event Code
--]]-----------------
local function Label_OnEnter(label)
	local self = label.obj
	local value = label
	self:Fire("OnLabelEnter", value)
end

local function Label_OnLeave(label)
	local self = label.obj
	local value = label
	self:Fire("OnLabelEnter", value)
end

local function Label_OnClick(label)
	local self = label.obj
	local value = label
	AceGUI:ClearFocus()
	self:Fire("OnLabelClick", value)
end


--[[-----------------
-- MultiSelect Code
--]]-----------------
do
	local function OnAcquire(self)  -- set up the default size
		self:SetWidth(200)
		self:SetHeight(400)
	end
	
	local function OnRelease(self)
		
		while #self.labels ~= 0 do
      local item = table.remove(self.labels);
      item:Hide()
      item:ClearAllPoints()
		end

	end
	
	local function SetWidth(self, w)  -- override the SetWidth function to include the labelframe
		self.frame:SetWidth(w)
		self.labelframe:SetWidth(w-33)
	end	
	
	local function SetLabel(self, text)  -- sets the multiselect label text
		self.label:SetText(text)
	end
	
	local function SetMultiSelect(self, value)  -- set if multiple values can be selected simultaneously
		self.multiselect = value
	end
	
	local function AddItem(self, str)  -- add an item (create a new item label object)
		local label = CreateFrame("Button", nil, self.labelframe)
		label.selected = false
		label.obj = self
		label:SetHeight(18)
		label:SetPoint("TOPLEFT", self.labelframe, "TOPLEFT", 0, -(getn(self.labels) * 18))
		label:SetPoint("TOPRIGHT", self.labelframe, "TOPRIGHT", 0, -(getn(self.labels) * 18))
		label.str = str;
		label.index = getn(self.labels) + 1;
		self.labels[getn(self.labels) + 1] = label
		self.labelframe:SetHeight(getn(self.labels) * 18)
		
		local text = label:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
		text:SetJustifyH("LEFT")
		text:SetPoint("TOPLEFT",label,"TOPLEFT",5,0)
		text:SetPoint("BOTTOMRIGHT",label,"BOTTOMRIGHT",-5,0)
		text:SetText(str)
		label.text = text
		
		local highlight = label:CreateTexture(nil, "OVERLAY")
		highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		highlight:SetBlendMode("ADD")
		highlight:SetHeight(14)
		highlight:ClearAllPoints()
		highlight:SetPoint("RIGHT",label,"RIGHT",0,0)
		highlight:SetPoint("LEFT",label,"LEFT",0,0)
		highlight:Hide()
		label.highlight = highlight
		
		label:SetScript("OnEnter", function(this)
			this.highlight:Show()
			Label_OnEnter(this)
		end)
		label:SetScript("OnLeave", function(this)
			if not this.selected then
				this.highlight:Hide()
			end
		end)
		label:SetScript("OnClick", function(this)
			if not this.selected then
				this.selected = true
				if not self.multiselect then
					for index, items in pairs(self.labels) do
						if self.labels[index] ~= this and self.labels[index].selected then
							self.labels[index].selected = false
							self.labels[index].highlight:Hide()
						end
					end
				end
			else
				this.selected = false
			end
			Label_OnClick(this)
		end)
    return label;
	end
	
	local function GetItem(self, text)  -- find an object based on the text parameter
		for _, value in pairs(self.labels) do
			if value.text:GetText() == text then
				return value
			end
		end
		return nil
	end
	
	local function GetItemByIndex(self, index)  -- find an object based on the text parameter
		return self.labels[index];
	end
	
	local function GetText(self, value)  -- get the text of a label object
		for _,item in pairs(self.labels) do
			if value == item then
				return item.text:GetText()
			end
		end
		return nil
	end
	
	local function SetText(self, value, text)  -- set the text of a label object
		for _, item in pairs(self.labels) do
			if value == item then
				value.text:SetText(text)
			end
		end
	end
	
	local function IsSelected(self, value)  -- return if the label object is currently selected
		for _, item in pairs(self.labels) do
			if value == item then
				return item.selected
			end
		end
		return nil
	end
	
	local function GetSelected(self)  -- return a table of the currently selected label objects
		local selectedList = {}
		for _, item in pairs(self.labels) do
			if item.selected then
				table.insert(selectedList, item)
			end
		end
		return selectedList
	end
		
	local function SetItemList(self, list)  -- create new labels from a list of strings
		for _,item in pairs(self.labels) do
			item:Hide()
			item:ClearAllPoints()
		end
		
		self.labels = {}
		
		if list then
			for _,item in pairs(list) do
				self:AddItem(item)
			end
		end
	end

	local function RemoveItem(self, item)  -- delete an item
		local function RedrawFrame()
			for index,value in pairs(self.labels) do
				value:SetPoint("TOPLEFT", self.labelframe, "TOPLEFT", 0, (-(index-1) * 18))
				value:SetPoint("TOPRIGHT", self.labelframe, "TOPRIGHT", 0,(-(index-1) * 18))
			end
		end
		
		for index, value in pairs(self.labels) do
			if value == item then
				table.remove(self.labels, index)
				item:Hide()
				item:ClearAllPoints()
				RedrawFrame()
			end
		end
	end
	
	local function SetSelected(self, item, value)
		if value then
			if not self.multiselect then  -- test
				for _, value in pairs(self.labels) do
					value.selected = false
					value.highlight:Hide()
				end
			end
			item.selected = true
			item.highlight:Show()
		else
			item.selected = false
			item.highlight:Hide()
		end
	end
	
	local function Constructor()  -- widget constructor
		local frame = CreateFrame("Frame", nil, UIParent)
		local backdrop = CreateFrame("Frame", nil, frame)
		local self = {}
		local labels = {}
		
		self.type = widgetType
		self.frame = frame
		self.backdrop = backdrop
		self.labels = {}
		self.multiselect = true
		frame.obj = self
		
		local label = frame:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
		label:SetJustifyH("LEFT")
		label:SetPoint("TOPLEFT", 5, 0)
		label:SetPoint("TOPRIGHT", -5, 0)
		label:SetHeight(14)
		label:SetText("MultiSelect")
		self.label = label
		
		backdrop:SetBackdrop(FrameBackdrop)
		backdrop:SetBackdropColor(0, 0, 0)
		backdrop:SetBackdropBorderColor(0.4, 0.4, 0.4)
		backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -14)
		backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 0)
		
		local scrollframe = CreateFrame("ScrollFrame", format("%s@%s@%s", widgetType, "ScrollFrame", tostring(self)), frame, "UIPanelScrollFrameTemplate")
		scrollframe:SetPoint("TOPLEFT", backdrop, "TOPLEFT", 5, -6)
		scrollframe:SetPoint("BOTTOMRIGHT", backdrop, "BOTTOMRIGHT", -28, 6)
		scrollframe.obj = self
		self.scrollframe = scrollframe
		
		local labelframe = CreateFrame("Frame", nil, scrollframe)
		labelframe:SetAllPoints()
		labelframe.obj = self
		scrollframe:SetScrollChild(labelframe)
		self.labelframe = labelframe

		-- method listing
		self.OnAcquire = OnAcquire
		self.OnRelease = OnRelease
		self.SetLabel = SetLabel
		self.AddItem = AddItem
		self.SetWidth  = SetWidth
		self.SetMultiSelect = SetMultiSelect
		self.SetItemList = SetItemList
		self.GetItem = GetItem
		self.GetItemByIndex = GetItemByIndex
		self.RemoveItem = RemoveItem
		self.GetText = GetText
		self.SetText = SetText
		self.IsSelected = IsSelected
		self.GetSelected = GetSelected
		self.SetSelected = SetSelected
		
		AceGUI:RegisterAsWidget(self)
		return self
	end
	AceGUI:RegisterWidgetType(widgetType, Constructor, widgetVersion)
end
