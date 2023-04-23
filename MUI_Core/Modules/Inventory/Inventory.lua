-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local GetContainerNumSlots = _G["GetContainerNumSlots"];
local GetContainerItemCooldown = _G["GetContainerItemCooldown"];
local GetContainerItemInfo = _G["GetContainerItemInfo"];
local GetContainerItemQuestInfo = _G["GetContainerItemQuestInfo"];
local GetContainerNumFreeSlots = _G["GetContainerNumFreeSlots"];
local GameTooltip = _G["GameTooltip"];

if (_G.C_Container) then
  local Container = _G.C_Container;
  GetContainerNumSlots = Container.GetContainerNumSlots;
  GetContainerItemCooldown = Container.GetContainerItemCooldown;
  GetContainerItemInfo = Container.GetContainerItemInfo;
  GetContainerItemQuestInfo = Container.GetContainerItemQuestInfo;
  GetContainerNumFreeSlots = Container.GetContainerNumFreeSlots;
end

local Mixin, Item, GetMoney = _G.Mixin, _G.Item, _G.GetMoney;

--- Also has `$parentNormalTexture`, `PushedTexture`, `HighlightTexture`, `$parentStock FontString`,
--- `$parentCooldown`, and `$parentIconQuestTexture`
---@class MayronUI.Inventory.Slot : Button, ItemMixin, MayronUI.Icon
---@field icon Texture
---@field Count FontString
---@field searchOverlay Texture
---@field IconBorder Texture
---@field IconOverlay Texture
---@field JunkIcon Texture
---@field UpgradeIcon Texture
---@field NewItemTexture Texture
---@field BattlepayItemTexture Texture
---@field ExtendedSlot Texture
---@field ExtendedOverlay Texture
---@field ExtendedOverlay2 Texture
---@field flash Texture
---@field BagStaticBottom Texture
---@field BagStaticTop Texture
---@field newitemglowAnim AnimationGroup
---@field flashAnim AnimationGroup
---@field questTexture Texture

---@class MayronUI.Inventory.Bag : Frame
---@field slots MayronUI.Inventory.Slot[]

---@class MayronUI.Inventory.Frame : Frame
---@field bags MayronUI.Inventory.Bag[]
---@field currency FontString
---@field freeSlots FontString
---@field dragger Frame
---@field minWidth number
---@field maxWidth number
---@field closeBtn Button
---@field sortBtn Button
---@field titleBar Button

-- Register and Import Modules -----------
local C_Inventory = MayronUI:RegisterModule("Inventory", "Inventory");

-- Settings:
local slotWidth, slotHeight = 36, 30;
local slotSpacing = 6;
local initialColumns = 10;
local minColumns = 8;
local maxColumns = 30;
local containerPadding = { top = 30, right = 8, bottom = 34, left = 8 };

-- Local Functions --------------
---@param slot MayronUI.Inventory.Slot
local function ClearBagSlot(slot)
  slot.icon:Hide();
  slot.JunkIcon:Hide();
  slot.searchOverlay:Hide();
  slot.questTexture:Hide();
  slot.Count:Hide();
  slot.gloss:Hide();
  slot:SetGridColor(0.2, 0.2, 0.2);
end

---@param slot MayronUI.Inventory.Slot
local function UpdateBagSlot(slot)
  if (slot:IsItemEmpty()) then
    ClearBagSlot(slot);
    return
  end

  local slotIndex = slot:GetID() or 0;
  local bag = slot:GetParent() --[[@as Frame]];
  local bagID = bag:GetID() or 0;
  local iconFileID = slot:GetItemIcon();

  slot.icon:SetTexture(iconFileID);
  slot.icon:Show();
  slot.gloss:Show();

  local info = GetContainerItemInfo(bagID, slotIndex);
  local countText = "";

  local invType = slot:GetInventoryType();
  local quality = slot:GetItemQuality();
  if (invType > 0 or quality > 1) then
    local color = slot:GetItemQualityColor();
    slot:SetGridColor(color.r, color.g, color.b);
  else
    slot:SetGridColor(0.2, 0.2, 0.2);
  end

  if (info.stackCount > 1) then
    if (info.stackCount > 9999) then
      countText = "*";
    else
      countText = tostring(info.stackCount);
    end
  end

  slot.Count:SetText(countText);
  slot.Count:Show();

  local questInfo = GetContainerItemQuestInfo(bagID, slotIndex);-- Could also use `isActive`

  if ((questInfo.questId or questInfo.questID) and not questInfo.isActive) then
		slot.questTexture:SetTexture(_G["TEXTURE_ITEM_QUEST_BANG"]);
		slot.questTexture:Show();
	elseif ((questInfo.questId or questInfo.questID) or questInfo.isQuestItem) then
		slot.questTexture:SetTexture(_G["TEXTURE_ITEM_QUEST_BORDER"]);
		slot.questTexture:Show();
	else
		slot.questTexture:Hide();
	end

  slot.JunkIcon:SetShown(slot:GetItemQuality() == 0);
  slot.searchOverlay:SetShown(info.isFiltered);

  local start, duration, enable = GetContainerItemCooldown(bagID, slotIndex);
  local isCooldownActive = enable and enable ~= 0 and start > 0 and duration > 0;

  if (isCooldownActive) then
    slot.cooldown:SetCooldown(start, duration);
  else
    slot.cooldown:Clear();
  end
end

local function CreateBagItemSlot(bagFrame, slotIndex)
  local bagGlobalName = bagFrame:GetName();
  local bagID = bagFrame:GetID();
  local slotGlobalName = bagGlobalName.."Slot"..tostring(slotIndex);

  local slot = tk:CreateFrame("Button", bagFrame, slotGlobalName, "ContainerFrameItemButtonTemplate");
  slot:SetSize(slotWidth, slotHeight);
  slot.cooldown = _G[slotGlobalName.."Cooldown"];

  slot.questTexture = _G[slotGlobalName.."IconQuestTexture"];
  slot.questTexture:SetSize(slotWidth, slotHeight);

  slot = gui:ReskinIcon(slot, 2);
  Mixin(slot, Item:CreateFromBagAndSlot(bagID, slotIndex));

  ---@cast slot MayronUI.Inventory.Slot

  slot:SetID(slotIndex);
  ClearBagSlot(slot);

  tk:KillAllElements(
    slot.ExtendedOverlay,
    slot.ExtendedOverlay2,
    slot.ExtendedSlot,
    slot.BagStaticBottom,
    slot.BagStaticTop,
    slot.IconBorder,
    slot.BattlepayItemTexture,
    slot:GetNormalTexture()
  );

  if (not slot:IsItemEmpty()) then
    slot:ContinueOnItemLoad(function()
      UpdateBagSlot(slot);
    end);
  end

  return slot;
end

---@param inventoryFrame MayronUI.Inventory.Frame
local function UpdateFreeSlots(inventoryFrame)
  local totalFreeSlots = 0;
  local totalSlots = 0;

  for _, bag in ipairs(inventoryFrame.bags) do
    local bagID = bag:GetID();

    if (bagID) then
      local freeBagSlots = GetContainerNumFreeSlots(bagID) or 0;
      local totalBagSlots = GetContainerNumSlots(bagID) or 0;
      totalFreeSlots = totalFreeSlots + freeBagSlots;
      totalSlots = totalSlots + totalBagSlots;
    end
  end

  local text = totalFreeSlots .. "/" .. totalSlots;
  local percent = (totalFreeSlots / totalSlots) * 100;
  local r, g, b = tk:GetProgressColor(percent, 100);
  text = tk.Strings:SetTextColorByRGB(text, r, g, b);
  inventoryFrame.freeSlots:SetText(text);
end

---@param bag MayronUI.Inventory.Bag
local function UpdateAllBagSlots(bag)
  for _, slot in ipairs(bag.slots) do
    UpdateBagSlot(slot);
  end

  local inventoryFrame = bag:GetParent()--[[@as MayronUI.Inventory.Frame]];
  UpdateFreeSlots(inventoryFrame);
end

---@param bags MayronUI.Inventory.Bag[]
local function UpdateSearchOverlays(bags)
  for _, bag in ipairs(bags) do
    local bagID = bag:GetID() or 0;

    for slotIndex, slot in ipairs(bag.slots) do
      if (slot:IsItemEmpty()) then
        ClearBagSlot(slot);
      else
        local info = GetContainerItemInfo(bagID, slotIndex);
        slot.searchOverlay:SetShown(info.isFiltered);
      end
    end
  end
end

---@param inventoryFrame MayronUI.Inventory.Frame
---@param event string
---@param bagID number?
---@param slotIndex number?
local function InventoryFrameOnEvent(inventoryFrame, event, bagID, slotIndex)
  local bag = type(bagID) == "number" and bagID >= 0 and inventoryFrame.bags[bagID + 1];

--[[
	if ( event == "UNIT_INVENTORY_CHANGED" or event == "PLAYER_SPECIALIZATION_CHANGED" ) then
		ContainerFrame_UpdateItemUpgradeIcons(self);
--]]

	if (event == "BAG_UPDATE") then
    if (bag) then
      UpdateAllBagSlots(bag);
    end

    return
  end

	if (event == "ITEM_LOCK_CHANGED") then
    if (bag and type(slotIndex) == "number" and slotIndex > 0) then
      local slot = bag.slots[slotIndex];

      if (slot) then
        local locked = slot:IsItemLocked();
        slot.icon:SetDesaturated(locked);

        if (GameTooltip:IsShown()) then
          local _, itemLink = _G.GameTooltip:GetItem();
          local slotLink = slot:GetItemLink();

          if (itemLink == slotLink) then
            GameTooltip:Hide();
          end
        end
      end
    end

    return
  end

	if (event == "BAG_NEW_ITEMS_UPDATED") then
    if (bag) then
		  UpdateAllBagSlots(bag);
    end
    return
  end

	if (event == "QUEST_ACCEPTED" or event == "UNIT_QUEST_LOG_CHANGED") then
    if (event == "UNIT_QUEST_LOG_CHANGED") then
      local unitID = bagID --[[@as UnitId]]
      if (unitID ~= "player") then return end
    end

		if (bag and bag:IsShown()) then
			UpdateAllBagSlots(bag);
		end

    return
  end

  if (event == "PLAYER_MONEY") then
    local money = GetMoney();
    local currencyText = tk.Strings:GetFormattedCurrency(money);
    inventoryFrame.currency:SetText(currencyText);
    return
	end

  -- Bag Extensions:
	-- if (event == "DISPLAY_SIZE_CHANGED" ) then
	-- 	-- UpdateContainerFrameAnchors();
  --   return
  -- end

	if (event == "INVENTORY_SEARCH_UPDATE") then
    UpdateSearchOverlays(inventoryFrame.bags);
    return
  end

	-- if ( event == "BAG_SLOT_FLAGS_UPDATED" ) then
	-- 	-- if (self:GetID() == bagID) then
	-- 	-- 	self.localFlag = nil;
	-- 	-- 	if (self:IsShown()) then
	-- 	-- 		UpdateDisplay(self);
	-- 	-- 	end
	-- 	-- end
	-- elseif ( event == "BANK_BAG_SLOT_FLAGS_UPDATED" ) then
	-- 	-- if (self:GetID() == (bagID + NUM_BAG_SLOTS)) then
	-- 	-- 	self.localFlag = nil;
	-- 	-- 	if (self:IsShown()) then
	-- 	-- 		UpdateDisplay(self);
	-- 	-- 	end
	-- 	-- end

end

local UpdateInventorySlotAnchors;

do
  local function GetGridSizeByNumColumns(inventoryFrame, totalColumns, updateAnchors)
    local newWidth = containerPadding.left + containerPadding.right;
    local newHeight = containerPadding.top + containerPadding.bottom;
    local columnIndex = 1;
    local totalRows = 1;

    for _, bag in ipairs(inventoryFrame.bags) do
      for _, slot in ipairs(bag.slots) do
        if ((columnIndex % (totalColumns + 1)) == 0) then
            -- next row
          totalRows = totalRows + 1;
          columnIndex = 1;
        end

        local xOffset = (columnIndex - 1) * (slotWidth + slotSpacing);
        local yOffset = (totalRows - 1) * (slotHeight + slotSpacing);

        if (updateAnchors) then
          slot:SetPoint("TOPLEFT", xOffset, -yOffset);
        end

        columnIndex = columnIndex + 1; -- next column
      end
    end

    local slotXOffset = (slotWidth + slotSpacing);
    local slotYOffset = (slotHeight + slotSpacing);

    newWidth = newWidth + (slotXOffset * totalColumns) - slotSpacing;
    newHeight = newHeight + (slotYOffset * totalRows) - slotSpacing;
    return newWidth, newHeight;
  end

  ---@param inventoryFrame MayronUI.Inventory.Frame
  ---@return number, number
  UpdateInventorySlotAnchors = function(inventoryFrame)
    local currentWidth = inventoryFrame:GetWidth();

    if (currentWidth > 0) then
      local totalColumns = 1;

      for columns = 1, 100 do
        local width = ((slotWidth + slotSpacing) * columns) - slotSpacing + containerPadding.left + containerPadding.right;

        if (width > currentWidth) then break end
        totalColumns = columns;
      end

      local newWidth, newHeight = GetGridSizeByNumColumns(inventoryFrame, totalColumns, true);
      tk:SetResizeBounds(inventoryFrame, inventoryFrame.minWidth, newHeight, inventoryFrame.maxWidth, newHeight);

      return newWidth, newHeight;
    end

    local minWidth, maxHeight = GetGridSizeByNumColumns(inventoryFrame, minColumns);
    local maxWidth, minHeight = GetGridSizeByNumColumns(inventoryFrame, maxColumns);
    inventoryFrame.minWidth = minWidth;
    inventoryFrame.maxWidth = maxWidth;

    tk:SetResizeBounds(inventoryFrame, minWidth, minHeight, maxWidth, maxHeight);

    return GetGridSizeByNumColumns(inventoryFrame, initialColumns, true);
  end
end

local InventoryFrameOnUpdate;

do
  local totalElapsed = 0;

  ---@param self MayronUI.Inventory.Frame
  ---@param elapsed number
  InventoryFrameOnUpdate = function (self, elapsed)
    totalElapsed = totalElapsed + elapsed;

    if (totalElapsed > 0.1) then
      totalElapsed = 0;

      if (self.dragger:IsDragging()) then
        UpdateInventorySlotAnchors(self);
      end
    end
  end
end

---@param inventoryFrame MayronUI.Inventory.Frame
local function CreateSearchBox(inventoryFrame)
  --Searchbox
	local searchEditBox = tk:CreateFrame("EditBox", inventoryFrame, "MUI_InventorySearch");
	searchEditBox:SetPoint("LEFT", inventoryFrame.freeSlots, "RIGHT", 12, 0);
	searchEditBox:SetPoint("RIGHT", inventoryFrame.dragger, "LEFT", -12, 0);
	searchEditBox:SetPoint("BOTTOM", 0, 4);

	searchEditBox:SetAutoFocus(false);
	searchEditBox:SetHeight(24);
	searchEditBox:SetMaxLetters(50);
	searchEditBox:SetTextInsets(26, 22, 0, 1);
	searchEditBox:SetFontObject("GameFontHighlight");

	local bg = searchEditBox:CreateTexture(nil, "BACKGROUND");
	bg:SetTexture(tk:GetAssetFilePath("Textures\\searchbox"));
	bg:SetAllPoints();
	tk.Constants.AddOnStyle:ApplyColor(nil, nil, bg);

	local searchIcon = searchEditBox:CreateTexture(nil, "OVERLAY");
	searchIcon:SetPoint("LEFT", searchEditBox, "LEFT", 6, 1);
	searchIcon:SetSize(14, 14);
	searchIcon:SetTexture("Interface\\Common\\UI-Searchbox-Icon");
	searchIcon:SetTexCoord(0, 0.8215, 0, 0.8125); -- for some reason there's a 3px white space to the right and bottom
	searchIcon:SetVertexColor(0.6, 0.6, 0.6);

	local clearBtn = tk:CreateFrame("Button", searchEditBox);
	clearBtn:SetPoint("RIGHT", searchEditBox, "RIGHT", -4, 1);
	clearBtn:SetSize(20, 18);
	clearBtn:SetShown(false);
	clearBtn:SetNormalTexture("Interface\\FriendsFrame\\ClearBroadcastIcon");
	clearBtn:SetHighlightTexture("Interface\\FriendsFrame\\ClearBroadcastIcon", "ADD");

	searchEditBox:SetScript("OnEscapePressed", function()
    searchEditBox:ClearFocus();
  end);

	searchEditBox:SetScript("OnEnterPressed", searchEditBox.ClearFocus);

	searchEditBox:SetScript("OnEditFocusLost", function(self)
		if (self:GetText() == "") then
			searchIcon:SetVertexColor(0.6, 0.6, 0.6);
			clearBtn:Hide();
		end
	end);

	searchEditBox:SetScript("OnEditFocusGained", function()
		searchIcon:SetVertexColor(1.0, 1.0, 1.0);
		clearBtn:Show();
	end);

	searchEditBox:SetScript("OnTextChanged", function(self)
    C_Container.SetItemSearch(self:GetText());
	end);

	clearBtn:SetScript("OnMouseDown", function(self)
		local normalTexture = self:GetNormalTexture();
		local highlightTexture = self:GetHighlightTexture();
		normalTexture:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1);
		normalTexture:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1);
		highlightTexture:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1);
		highlightTexture:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1);
	end);

	clearBtn:SetScript("OnMouseUp", function(self)
		local normalTexture = self:GetNormalTexture();
		local highlightTexture = self:GetHighlightTexture();
		normalTexture:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0);
		normalTexture:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);
		highlightTexture:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0);
		highlightTexture:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);
	end);

	clearBtn:SetScript("OnClick", function(self)
		_G.PlaySound(_G.SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		local editBox = self:GetParent();
		editBox:SetText("");
		editBox:ClearFocus();
	end);
end

-- C_Inventory ------------------

function C_Inventory:OnInitialize()
  if (not (tk:IsWrathClassic() and MayronUI.DEBUG_MODE)) then
    return
  end

  local inventoryFrame = tk:CreateFrame("Frame", nil, "MUI_Inventory")--[[@as MayronUI.Inventory.Frame]];
  table.insert(_G["UISpecialFrames"], "MUI_Inventory");
  inventoryFrame:SetPoint("CENTER");
  inventoryFrame:Hide();

  -- local OpenInventoryFrame = function() inventoryFrame:Show(); end
  -- local CloseInventoryFrame = function() inventoryFrame:Hide(); end
  local ToggleInventoryFrame = function() inventoryFrame:SetShown(not inventoryFrame:IsShown()) end

  -- tk:HookFunc("OpenBag", function() print("OpenBag") end);
  -- tk:HookFunc("OpenAllBags", function() print("OpenAllBags") end);
  -- tk:HookFunc("OpenBackpack", function() print("OpenBackpack") end);

  -- tk:HookFunc("ToggleBag", function() print("ToggleBag") end);
  tk:HookFunc("ToggleAllBags", ToggleInventoryFrame);
  -- tk:HookFunc("ToggleBackpack", function() print("ToggleBackpack") end);

  -- tk:HookFunc("CloseBag", function() print("CloseBag") end);
  -- tk:HookFunc("CloseAllBags", function() print("CloseAllBags") end);
  -- tk:HookFunc("CloseBackpack", function() print("CloseBackpack") end);

  gui:CreateMediumDialogBox(inventoryFrame);
  inventoryFrame:SetFrameStrata(tk.Constants.FRAME_STRATAS.HIGH);
  gui:AddTitleBar(inventoryFrame, "Inventory");
  gui:AddCloseButton(inventoryFrame)
  gui:AddResizer(inventoryFrame);
  inventoryFrame.bags = {};

  -- self = inventoryFrame:
	inventoryFrame:RegisterEvent("BAG_UPDATE");
	inventoryFrame:RegisterEvent("ITEM_LOCK_CHANGED");
	inventoryFrame:RegisterEvent("BAG_NEW_ITEMS_UPDATED");
	inventoryFrame:RegisterEvent("PLAYER_MONEY");

  -- Wrath Only --------------:
	inventoryFrame:RegisterEvent("QUEST_ACCEPTED");
	inventoryFrame:RegisterEvent("UNIT_QUEST_LOG_CHANGED"); -- and arg1 == "player", then also do the same as QUEST_ACCEPTED
  ----------------------------

  -- Retail?:
  -- UNIT_INVENTORY_CHANGED, PLAYER_SPECIALIZATION_CHANGED

  -- Bag Extensions:
	-- inventoryFrame:RegisterEvent("DISPLAY_SIZE_CHANGED"); -- UpdateContainerFrameAnchors();
	inventoryFrame:RegisterEvent("INVENTORY_SEARCH_UPDATE"); -- ContainerFrame_UpdateSearchResults(self);
	-- inventoryFrame:RegisterEvent("BAG_SLOT_FLAGS_UPDATED");
	-- inventoryFrame:RegisterEvent("BANK_BAG_SLOT_FLAGS_UPDATED");

  -- Create Bags and Slots:
  for bagID = 0, _G.NUM_BAG_SLOTS do
    tk:KillElement(_G["ContainerFrame"..tostring(bagID + 1)]);

    local numSlots = GetContainerNumSlots(bagID);
    local bagGlobalName = "MUI_InventoryBag"..tostring(bagID + 1);
    local bagFrame = tk:CreateFrame("Frame", inventoryFrame, bagGlobalName)--[[@as MayronUI.Inventory.Bag]];
    inventoryFrame.bags[bagID + 1] = bagFrame;

    bagFrame:SetPoint("TOPLEFT", containerPadding.left, -containerPadding.top);
    bagFrame:SetPoint("BOTTOMRIGHT", -containerPadding.right, containerPadding.bottom);
    bagFrame:SetID(bagID);
    bagFrame.slots = {};

    if (numSlots > 0) then
      for slotIndex = 1, numSlots do
        local slot = CreateBagItemSlot(bagFrame, slotIndex);
        bagFrame.slots[slotIndex] = slot;
      end
    end
  end

  local function UpdateInventoryDimensions()
    local width, height = UpdateInventorySlotAnchors(inventoryFrame);
    inventoryFrame:SetSize(width, height);
  end

  UpdateInventoryDimensions();

  inventoryFrame.dragger:HookScript("OnDragStart", function()
    inventoryFrame:SetScript("OnUpdate", InventoryFrameOnUpdate);
  end);

  inventoryFrame.dragger:HookScript("OnDragStop", function()
    inventoryFrame:SetScript("OnUpdate", nil);
    UpdateInventoryDimensions();
  end);

  inventoryFrame.currency = inventoryFrame:CreateFontString("MUI_InventoryCurrency", "ARTWORK", "MUI_FontNormal");
  inventoryFrame.currency:SetPoint("BOTTOMLEFT", 8, 8);
  inventoryFrame.currency:SetJustifyH("LEFT");

  inventoryFrame.freeSlots = inventoryFrame:CreateFontString("MUI_InventorySlots", "ARTWORK", "MUI_FontNormal");
  inventoryFrame.freeSlots:SetPoint("BOTTOMLEFT", inventoryFrame.currency, "BOTTOMRIGHT", 12, 0);
  inventoryFrame.freeSlots:SetJustifyH("LEFT");

  inventoryFrame.sortBtn = gui:CreateIconButton("sort", inventoryFrame, "MUI_InventorySort");
  inventoryFrame.sortBtn:SetPoint("RIGHT", inventoryFrame.closeBtn, "LEFT", -4, 0);
  tk:SetBasicTooltip(inventoryFrame.sortBtn, "Sort Bags");
  inventoryFrame.sortBtn:SetScript("OnClick", _G["SortBags"]);

  CreateSearchBox(inventoryFrame);

  InventoryFrameOnEvent(inventoryFrame, "PLAYER_MONEY");
  UpdateFreeSlots(inventoryFrame);
  inventoryFrame:SetScript("OnEvent", InventoryFrameOnEvent);
end