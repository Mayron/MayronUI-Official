-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local GameTooltip = _G["GameTooltip"];
local C_Container = _G["C_Container"];

local GetBagName = C_Container.GetBagName;
local GetContainerNumSlots = C_Container.GetContainerNumSlots;
local GetContainerItemCooldown = C_Container.GetContainerItemCooldown;
local GetContainerItemInfo = C_Container.GetContainerItemInfo;
local GetContainerItemQuestInfo = C_Container.GetContainerItemQuestInfo;
local GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots;
local GetInventorySlotInfo = _G.GetInventorySlotInfo;
local UpdateInventorySlotAnchors;
local PlaySound = _G.PlaySound;
local SoundKit = _G.SOUNDKIT;

---@enum MayronUI.Inventory.TabType
local TabTypesEnum = {
  AllItems = 0;
  Equipment = 1;
  Consumables = 2;
  TradeGoods = 3;
  QuestItems = 4;
}

local Mixin, Item, GetMoney, GetItemInfoInstant = _G.Mixin, _G.Item, _G.GetMoney, _G.GetItemInfoInstant;

---@class MayronUI.Inventory.BagButton : CheckButton, ItemMixin, MayronUI.Icon
---@field icon Texture
---@field bagIndex number
---@field count FontString
---@field bagFrame MayronUI.Inventory.BagFrame

---@class MayronUI.Inventory.BagBar : Frame
---@field buttons MayronUI.Inventory.BagButton[]

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

---@class MayronUI.Inventory.BagFrame : Frame
---@field slots MayronUI.Inventory.Slot[]
---@field bagIndex number
---@field highlighted boolean

---@class MayronUI.Inventory.Frame : Frame
---@field bags MayronUI.Inventory.BagFrame[]
---@field bagBar MayronUI.Inventory.BagBar
---@field money FontString
---@field freeSlots FontString
---@field dragger Frame
---@field minWidth number
---@field maxWidth number
---@field closeBtn Button
---@field sortBtn Button
---@field bagsBtn Button
---@field titleBar Button
---@field selectedTabID MayronUI.Inventory.TabType?
---@field tabs (MayronUI.Icon|CheckButton)[]

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

local function UpdateInventoryDimensions(inventoryFrame, resetSlotOrder)
  local width, height = UpdateInventorySlotAnchors(inventoryFrame, resetSlotOrder);

  if (resetSlotOrder) then
    inventoryFrame:SetHeight(height);
  else
    inventoryFrame:SetSize(width, height);
  end
end

---@param slot MayronUI.Inventory.Slot
local function SetBagItemSlotBorderColor(slot, isHighlightedBag)
  if (not slot:IsItemEmpty()) then
    local invType = slot:GetInventoryType();
    local quality = slot:GetItemQuality();

    if (invType > 0 or quality > 1) then
      local color = slot:GetItemQualityColor();
      slot:SetGridColor(color.r, color.g, color.b);
      return
    end
  end

  if (isHighlightedBag == true) then
    slot:SetGridColor(1, 1, 1);
  else
    slot:SetGridColor(0.2, 0.2, 0.2);
  end
end

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

---@param bag MayronUI.Inventory.BagFrame
---@param slot MayronUI.Inventory.Slot
local function UpdateBagSlotCooldown(bag, slot)
  if (slot:IsItemEmpty()) then
    slot.cooldown:Clear();
    return
  end

  local slotIndex = slot:GetID() or 0;
  local start, duration = GetContainerItemCooldown(bag.bagIndex, slotIndex);
  local isCooldownActive = (start or 0) > 0 and (duration or 0) > 0;

  --MayronUI:LogInfo("Update slot %s. isCooldownActive: %s (start: %s, duration: %s).",
   -- slot:GetItemName(), isCooldownActive, start, duration);

  if (isCooldownActive) then
    slot.cooldown:SetCooldown(start, duration);
  else
    slot.cooldown:Clear();
  end
end

---@param slot MayronUI.Inventory.Slot
local function UpdateBagSlot(slot, highlighted)
  if (slot:IsItemEmpty()) then
    ClearBagSlot(slot);
    return
  end

  local slotIndex = slot:GetID() or 0;
  local bag = slot:GetParent() --[[@as MayronUI.Inventory.BagFrame]];
  local iconFileID = slot:GetItemIcon();

  slot.icon:SetTexture(iconFileID);
  slot.icon:Show();
  slot.gloss:Show();

  local info = GetContainerItemInfo(bag.bagIndex, slotIndex);
  local countText = "";

  SetBagItemSlotBorderColor(slot, highlighted);

  if (info.stackCount > 1) then
    if (info.stackCount > 9999) then
      countText = "*";
    else
      countText = tostring(info.stackCount);
    end
  end

  slot.Count:SetText(countText);
  slot.Count:Show();

  local questInfo = GetContainerItemQuestInfo(bag.bagIndex, slotIndex);-- Could also use `isActive`
  local questTexture;

  if ((questInfo.questId or questInfo.questID) and not questInfo.isActive) then
    questTexture = _G["TEXTURE_ITEM_QUEST_BANG"];
	elseif (questInfo.questId or questInfo.questID or questInfo.isQuestItem) then
    questTexture = _G["TEXTURE_ITEM_QUEST_BORDER"];
	else
		slot.questTexture:Hide();
	end

  if (questTexture) then
    slot.questTexture:SetTexture(questTexture);
    slot.questTexture:Show();
    local r, g, b = tk.Constants.COLORS.GOLD:GetRGB();
    slot:SetGridColor(r, g, b);
  end

  slot.JunkIcon:SetShown(slot:GetItemQuality() == 0);
  slot.searchOverlay:SetShown(info.isFiltered);

  UpdateBagSlotCooldown(bag, slot);
end

---@param bagFrame MayronUI.Inventory.BagFrame
---@param slotIndex number
---@return MayronUI.Inventory.Slot
local function CreateBagItemSlot(bagFrame, slotIndex)
  local bagGlobalName = bagFrame:GetName();
  local slotGlobalName = bagGlobalName.."Slot"..tostring(slotIndex);

  local slot = tk:CreateFrame("Button", bagFrame, slotGlobalName, "ContainerFrameItemButtonTemplate")--[[@as MayronUI.Inventory.Slot]];
  slot:SetID(slotIndex);
  slot:SetSize(slotWidth, slotHeight);
  slot.cooldown = _G[slotGlobalName.."Cooldown"];
  slot.questTexture = _G[slotGlobalName.."IconQuestTexture"];
  slot.questTexture:SetSize(slotWidth, slotHeight);
  slot.questTexture:SetTexCoord(0.05, 0.95, 0.05, 0.95);
  slot:HookScript("OnClick", UpdateBagSlot);

  slot = gui:ReskinIcon(slot, 2);
  Mixin(slot, Item:CreateFromBagAndSlot(bagFrame.bagIndex, slotIndex));

  slot.searchOverlay:SetDrawLayer("OVERLAY", 7);

  ---@cast slot MayronUI.Inventory.Slot
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
      UpdateBagSlot(slot, bagFrame.highlighted);
    end);
  end

  return slot;
end

---@param toggleBtn MayronUI.Inventory.BagButton
local function HighlightBagSlots(toggleBtn)
  if (not toggleBtn.bagFrame:IsShown()) then return end
  local inventoryFrame = _G["MUI_Inventory"]--[[@as MayronUI.Inventory.Frame]];

  for _, otherBagFrame in ipairs(inventoryFrame.bags) do
    otherBagFrame.highlighted = otherBagFrame.bagIndex == toggleBtn.bagIndex;

    for _, slot in ipairs(otherBagFrame.slots) do
      slot.searchOverlay:SetShown(not otherBagFrame.highlighted); -- fade out other bags
      SetBagItemSlotBorderColor(slot, otherBagFrame.highlighted);
    end
  end
end

local function ClearBagSlotHighlights()
  local inventoryFrame = _G["MUI_Inventory"]--[[@as MayronUI.Inventory.Frame]];

  for _, bagFrame in ipairs(inventoryFrame.bags) do
    bagFrame.highlighted = false;

    for _, slot in ipairs(bagFrame.slots) do
      slot.searchOverlay:SetShown(false);
      SetBagItemSlotBorderColor(slot, false);
    end
  end
end

---@param bagBtn MayronUI.Inventory.BagButton
local function HandleBagUpdateDelayedEvent(bagBtn)
  local isBackpack = bagBtn.bagIndex == 0;
  local isOpen = bagBtn.bagFrame:IsShown();
  bagBtn.icon:SetAlpha(isOpen and 1 or 0.25);

  if (isBackpack) then
    if (isOpen) then
      bagBtn:SetGridColor(1, 1, 1);
    else
      bagBtn:SetGridColor(0.2, 0.2, 0.2);
    end

    return
  end

  local isActive = GetBagName(bagBtn.bagIndex) ~= nil;

  if (isActive) then
    local iconFileID = bagBtn:GetItemIcon();
    bagBtn.icon:SetTexture(iconFileID);

    if (isOpen) then
      local quality = bagBtn:GetItemQuality();

      if (quality > 1) then
        local color = bagBtn:GetItemQualityColor();
        bagBtn:SetGridColor(color.r, color.g, color.b);
      else
        bagBtn:SetGridColor(1, 1, 1);
      end
    else
      bagBtn:SetGridColor(0.2, 0.2, 0.2);
    end
  else
    local equipmentSlotName = "Bag"..tostring(bagBtn.bagIndex - 1).."Slot";
    local _, backgroundTexture = GetInventorySlotInfo(equipmentSlotName);
    bagBtn.icon:SetTexture(backgroundTexture);
    bagBtn:SetGridColor(0.2, 0.2, 0.2);
  end
end

local function BagToggleButtonOnShow(self)
  self:RegisterEvent("BAG_UPDATE_DELAYED");
  HandleBagUpdateDelayedEvent(self);
end

local function BagToggleButtonOnHide(self)
  self:UnregisterAllEvents();
end

local function CreateBagBarToggleButton(bagIndex, bagBar, bagFrame, iteration)
  local bagBtnName;
  local isBackpack = bagIndex == 0;

  if (isBackpack) then
    bagBtnName = "MUI_InventoryBackpack";
  else
    bagBtnName = "MUI_InventoryBagSlot"..tostring(bagIndex);
  end

  local bagToggleBtn = tk:CreateFrame("CheckButton", bagBar, bagBtnName, "ItemButtonTemplate")--[[@as MayronUI.Inventory.BagButton]];
  bagToggleBtn.bagFrame = bagFrame;
  bagToggleBtn.bagIndex = bagIndex;
  bagToggleBtn.icon = _G[bagBtnName.."IconTexture"];

  bagToggleBtn:SetSize(slotWidth, slotHeight);
  bagToggleBtn:ClearAllPoints();
  bagToggleBtn = gui:ReskinIcon(bagToggleBtn, 2, "button");
  tk:KillElement(bagToggleBtn:GetNormalTexture());
  bagToggleBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp");
  bagToggleBtn:SetScript("OnLeave", tk.HandleTooltipOnLeave);

  bagToggleBtn.count = _G[bagBtnName.."Count"];
  bagToggleBtn.count:Show();

  bagToggleBtn:SetScript("OnEvent", HandleBagUpdateDelayedEvent);
  bagToggleBtn:SetScript("OnShow", BagToggleButtonOnShow);
  bagToggleBtn:SetScript("OnHide", BagToggleButtonOnHide);

  if (isBackpack) then
    tk:SetBasicTooltip(bagToggleBtn, _G["BACKPACK_TOOLTIP"], "ANCHOR_LEFT");
    bagToggleBtn:SetScript("OnClick", _G["BackpackButton_OnClick"]);
    bagToggleBtn:SetGridColor(1, 1, 1);
    bagToggleBtn.icon:SetTexture("Interface\\Buttons\\Button-Backpack-Up");
  else
    local equipmentSlotIndex = GetInventorySlotInfo("Bag"..tostring(bagIndex - 1).."Slot");
    bagToggleBtn:SetID(equipmentSlotIndex); -- required for dragging
    Mixin(bagToggleBtn, Item:CreateFromEquipmentSlot(equipmentSlotIndex));
    bagToggleBtn:RegisterForDrag("LeftButton");
    bagToggleBtn:SetScript("OnEnter", _G["BagSlotButton_OnEnter"]);
    bagToggleBtn:SetScript("OnClick", _G["BagSlotButton_OnClick"]);
    bagToggleBtn:SetScript("OnDragStart", _G["BagSlotButton_OnDrag"]);
    bagToggleBtn:SetScript("OnReceiveDrag", _G["BagSlotButton_OnClick"]);
  end

  bagToggleBtn:SetPoint("TOPLEFT", (slotWidth + slotSpacing) * iteration, 0);
  bagToggleBtn:HookScript("OnEnter", HighlightBagSlots);
  bagToggleBtn:HookScript("OnLeave", ClearBagSlotHighlights);
  bagToggleBtn:HookScript("OnClick", function()
    local isOpen = not bagFrame:IsShown();
    bagFrame:SetShown(isOpen);
    UpdateInventoryDimensions(bagBar:GetParent(), true);
    ClearBagSlotHighlights();

    if (bagBar:IsShown()) then
      HandleBagUpdateDelayedEvent(bagToggleBtn);
    end
  end);

  return bagToggleBtn;
end

---@param inventoryFrame MayronUI.Inventory.Frame
local function UpdateFreeSlots(inventoryFrame)
  local totalFreeSlots = 0;
  local totalNumSlots = 0;

  for i, bag in ipairs(inventoryFrame.bags) do
    local bagToggleBtn = inventoryFrame.bagBar.buttons[i];
    local numBagSlots = GetContainerNumSlots(bag.bagIndex) or 0;
    local freeBagSlots = GetContainerNumFreeSlots(bag.bagIndex) or 0;

    totalFreeSlots = totalFreeSlots + freeBagSlots;
    totalNumSlots = totalNumSlots + numBagSlots;

    if (bagToggleBtn) then
      if (numBagSlots == 0) then
        bagToggleBtn.count:SetText("");
      else
        local bagPercent = (freeBagSlots / numBagSlots) * 100;
        local r, g, b = tk:GetProgressColor(bagPercent, 100);

        local bagTakenSlotsText = tostring(numBagSlots - freeBagSlots);
        bagTakenSlotsText = tk.Strings:SetTextColorByRGB(bagTakenSlotsText, r, g, b);
        bagToggleBtn.count:SetText(bagTakenSlotsText);
      end
    end
  end

  local text = totalFreeSlots .. "/" .. totalNumSlots;
  local percent = (totalFreeSlots / totalNumSlots) * 100;
  local r, g, b = tk:GetProgressColor(percent, 100);
  text = tk.Strings:SetTextColorByRGB(text, r, g, b);
  inventoryFrame.freeSlots:SetText(text);
end

---@param bag MayronUI.Inventory.BagFrame
local function UpdateAllBagSlots(bag)
  for _, slot in ipairs(bag.slots) do
    UpdateBagSlot(slot, bag.highlighted);
  end

  local inventoryFrame = bag:GetParent()--[[@as MayronUI.Inventory.Frame]];
  UpdateFreeSlots(inventoryFrame);
end

---@param bags MayronUI.Inventory.BagFrame[]
local function UpdateSearchOverlays(bags)
  for _, bag in ipairs(bags) do
    for slotIndex, slot in ipairs(bag.slots) do
      if (slot:IsItemEmpty()) then
        ClearBagSlot(slot);
      else
        local info = GetContainerItemInfo(bag.bagIndex, slotIndex);
        slot.searchOverlay:SetShown(info.isFiltered);
      end
    end
  end
end

---@param inventoryFrame MayronUI.Inventory.Frame
---@param event string
---@param bagIndex number?
---@param slotIndex number?
local function InventoryFrameOnEvent(inventoryFrame, event, bagIndex, slotIndex)
  local bag = type(bagIndex) == "number" and bagIndex >= 0 and inventoryFrame.bags[bagIndex + 1];

 -- MayronUI:LogInfo("Event: %s (has bag?: %s) with bagIndex %s and slotIndex %s.",event, obj:IsTable(bag), bagIndex, slotIndex);

--[[
	if ( event == "UNIT_INVENTORY_CHANGED" or event == "PLAYER_SPECIALIZATION_CHANGED" ) then
		ContainerFrame_UpdateItemUpgradeIcons(self);
--]]

  if (event == "BAG_UPDATE_COOLDOWN") then
    for _, b in ipairs(inventoryFrame.bags) do
      for _, slot in ipairs(b.slots) do
        UpdateBagSlotCooldown(b, slot);
      end
    end
    return
  end

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
    elseif (type(bagIndex) == "number") then
      -- It could be the ID of the bag button (the containerID).
      local bagID = bagIndex;

      for _, bagBtn in ipairs(inventoryFrame.bagBar.buttons) do
        if (bagBtn:GetID() == bagID) then
          local locked = bagBtn:IsItemLocked();
          bagBtn.icon:SetDesaturated(locked);
          break
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
      local unitID = bagIndex --[[@as UnitId]]
      if (unitID ~= "player") then return end
    end

		if (bag and bag:IsShown()) then
			UpdateAllBagSlots(bag);
		end

    return
  end

  if (event == "PLAYER_MONEY") then
    local money = GetMoney();
    local moneyText = tk.Strings:GetFormattedMoney(money);
    inventoryFrame.money:SetText(moneyText);
    return
	end

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

do
  local orderedSlots = {}; ---@type MayronUI.Inventory.Slot[]
  local emptySlots = {}; ---@type MayronUI.Inventory.Slot[]

  local function PositionBagSlots(updateAnchors, totalColumns)
    local columnIndex = 1;
    local totalRows = 1;

    for _, slot in ipairs(orderedSlots) do
      if (slot:IsShown()) then
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

    return totalRows;
  end

  ---@param inventoryFrame MayronUI.Inventory.Frame
  local function GetGridSizeByNumColumns(inventoryFrame, totalColumns, updateAnchors, resetSlotOrder)
    local newWidth = containerPadding.left + containerPadding.right;
    local newHeight = containerPadding.top + containerPadding.bottom;

    if (resetSlotOrder) then
      tk.Tables:Empty(orderedSlots);
    end

    local showAllItems = inventoryFrame.selectedTabID == TabTypesEnum.AllItems;

    if (tk.Tables:IsEmpty(orderedSlots)) then
      if (showAllItems) then
        for i = _G.NUM_BAG_SLOTS + 1, 1, -1 do
          local bag = inventoryFrame.bags[i];

          if (bag:IsShown()) then
            for j = 0, (#bag.slots - 1) do
              local slot = bag.slots[#bag.slots - j];
              orderedSlots[#orderedSlots+1] = slot;
            end
          end
        end
      else
        tk.Tables:Empty(emptySlots);

        for i = _G.NUM_BAG_SLOTS + 1, 1, -1 do
          local bag = inventoryFrame.bags[i];
          bag:Show();

          for j = 0, (#bag.slots - 1) do
            local slot = bag.slots[#bag.slots - j];

            if (resetSlotOrder and slot:IsItemEmpty()) then
              emptySlots[#emptySlots+1] = slot;
            else
              orderedSlots[#orderedSlots+1] = slot;
            end
          end
        end

        for _, emptySlot in ipairs(emptySlots) do
          orderedSlots[#orderedSlots+1] = emptySlot;
        end

        tk.Tables:Empty(emptySlots);
      end
    end

    local totalRows = PositionBagSlots(updateAnchors, totalColumns);

    local slotXOffset = (slotWidth + slotSpacing);
    local slotYOffset = (slotHeight + slotSpacing);

    newWidth = newWidth + (slotXOffset * totalColumns) - slotSpacing;
    newHeight = newHeight + (slotYOffset * totalRows) - slotSpacing;
    return newWidth, newHeight;
  end

  ---@param inventoryFrame MayronUI.Inventory.Frame
  ---@return number, number
  UpdateInventorySlotAnchors = function(inventoryFrame, resetSlotOrder)
    local currentWidth = inventoryFrame:GetWidth();

    if (currentWidth > 0) then
      local totalColumns = 1;

      for columns = 1, 100 do
        local width = ((slotWidth + slotSpacing) * columns) - slotSpacing + containerPadding.left + containerPadding.right;

        if (width > currentWidth) then break end
        totalColumns = columns;
      end

      local newWidth, newHeight = GetGridSizeByNumColumns(inventoryFrame, totalColumns, true, resetSlotOrder);
      tk:SetResizeBounds(inventoryFrame, inventoryFrame.minWidth, newHeight, inventoryFrame.maxWidth, newHeight);

      return newWidth, newHeight;
    end

    local minWidth, maxHeight = GetGridSizeByNumColumns(inventoryFrame, minColumns);
    local maxWidth, minHeight = GetGridSizeByNumColumns(inventoryFrame, maxColumns);
    inventoryFrame.minWidth = minWidth;
    inventoryFrame.maxWidth = maxWidth;

    tk:SetResizeBounds(inventoryFrame, minWidth, minHeight, maxWidth, maxHeight);
    return GetGridSizeByNumColumns(inventoryFrame, initialColumns, true, resetSlotOrder);
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
		PlaySound(SoundKit.IG_MAINMENU_OPTION_CHECKBOX_ON);
		local editBox = self:GetParent();
		editBox:SetText("");
		editBox:ClearFocus();
	end);
end

local originalTopPadding = containerPadding.top;

---@param self MayronUI.Icon|Button
local function ToggleBagsBar(self)
  local inventoryFrame = self:GetParent()--[[@as MayronUI.Inventory.Frame]]
  local bagsFrameShown = not inventoryFrame.bagBar:IsShown();
  inventoryFrame.bagBar:SetShown(bagsFrameShown);

  if (bagsFrameShown) then
    containerPadding.top = originalTopPadding + slotHeight + containerPadding.left;
  else
    containerPadding.top = originalTopPadding;
  end

  for _, bag in ipairs(inventoryFrame.bags) do
    bag:SetPoint("TOPLEFT", containerPadding.left, -containerPadding.top);
  end

  UpdateInventoryDimensions(inventoryFrame);
end

---@param self CheckButton|MayronUI.Icon
local function HandleTabOnLeave(self)
  if (self:GetChecked()) then
    self.icon:SetDesaturated(false);
    local r, g, b = tk:GetThemeColor();
    self:SetGridColor(r, g, b);
  else
    self.icon:SetDesaturated(true);
    self:SetGridColor(0.2, 0.2, 0.2);
  end
end

---@param self CheckButton|MayronUI.Icon
local function HandleTabOnEnter(self)
  if (not self:GetChecked()) then
    self.icon:SetDesaturated(false);
    self:SetGridColor(1, 1, 1);
  end
end

---@param self CheckButton|MayronUI.Icon
local function HandleTabOnClick(self)
  local inventoryFrame = self:GetParent()--[[@as MayronUI.Inventory.Frame]];
  local tabID = self:GetID()--[[@as MayronUI.Inventory.TabType]];

  if (inventoryFrame.selectedTabID == tabID) then
    return
  end

  HandleTabOnLeave(self);
  inventoryFrame.selectedTabID = tabID;

  local showAllItems = inventoryFrame.selectedTabID == TabTypesEnum.AllItems;
  inventoryFrame.bagsBtn:SetEnabled(showAllItems);

  if (not showAllItems and inventoryFrame.bagBar:IsShown()) then
    ToggleBagsBar(inventoryFrame.bagsBtn);
  end

  for _, bag in ipairs(inventoryFrame.bags) do
    for _, slot in ipairs(bag.slots) do
      if (showAllItems) then
        slot:Show();
      else
        local itemID = slot:GetItemID();

        if (itemID) then
          local _, _, _, _, _, itemTypeClassID = GetItemInfoInstant(itemID);
          local showSlot = false;

          if (tabID == TabTypesEnum.Consumables) then
            showSlot = itemTypeClassID == 0;
          elseif (tabID == TabTypesEnum.Equipment) then
            showSlot = itemTypeClassID == 4 or itemTypeClassID == 2; -- armor or weapons
          elseif (tabID == TabTypesEnum.QuestItems) then
            showSlot = itemTypeClassID == 12;
          elseif (tabID == TabTypesEnum.TradeGoods) then
            showSlot = itemTypeClassID == 7 or itemTypeClassID == 19; -- tradegoods or profession
          end

          slot:SetShown(showSlot);
        else
          slot:Show(); -- Show empty slots
        end
      end
    end
  end

  UpdateInventoryDimensions(inventoryFrame, true);
end

-- C_Inventory ------------------

function C_Inventory:OnInitialize()
  if (not (tk:IsWrathClassic() and MayronUI.DEBUG_MODE)) then
    return
  end

  local inventoryFrame = tk:CreateFrame("Frame", nil, "MUI_Inventory")--[[@as MayronUI.Inventory.Frame]];
  table.insert(_G["UISpecialFrames"], "MUI_Inventory");
  inventoryFrame:SetPoint("TOPLEFT", 800, -500);
  inventoryFrame:Hide();

  tk:HookFunc("ToggleAllBags", function()
    local show = not inventoryFrame:IsShown();
    inventoryFrame:SetShown(show);

    if (show) then
      PlaySound(SoundKit.IG_BACKPACK_OPEN);
    else
      PlaySound(SoundKit.IG_BACKPACK_CLOSE);
    end
  end);

  gui:CreateMediumDialogBox(inventoryFrame);
  inventoryFrame:SetFrameStrata(tk.Constants.FRAME_STRATAS.HIGH);
  gui:AddTitleBar(inventoryFrame, "Inventory");
  gui:AddCloseButton(inventoryFrame)
  gui:AddResizer(inventoryFrame);
  inventoryFrame.bags = {};

  inventoryFrame.titleBar.onDragStop = function()
    local screenBottomDistance = inventoryFrame:GetBottom();
    local screenLeftDistance = inventoryFrame:GetLeft();
    inventoryFrame:ClearAllPoints();

    local xOffset = screenLeftDistance;
    local yOffset = screenBottomDistance + inventoryFrame:GetHeight();

    inventoryFrame:SetPoint("TOPLEFT", _G.UIParent, "BOTTOMLEFT", xOffset, yOffset);
  end

  -- self = inventoryFrame:
	inventoryFrame:RegisterEvent("BAG_UPDATE_COOLDOWN");
	inventoryFrame:RegisterEvent("BAG_UPDATE");
	inventoryFrame:RegisterEvent("ITEM_LOCK_CHANGED");
	inventoryFrame:RegisterEvent("BAG_NEW_ITEMS_UPDATED");
	inventoryFrame:RegisterEvent("PLAYER_MONEY");

  -- Wrath Only --------------:
	inventoryFrame:RegisterEvent("QUEST_ACCEPTED");
	inventoryFrame:RegisterEvent("UNIT_QUEST_LOG_CHANGED"); -- and arg1 == "player", then also do the same as QUEST_ACCEPTED
  ----------------------------

	inventoryFrame:RegisterEvent("INVENTORY_SEARCH_UPDATE");

  -- Retail?:
  -- UNIT_INVENTORY_CHANGED, PLAYER_SPECIALIZATION_CHANGED

  -- Bag Extensions:
	-- inventoryFrame:RegisterEvent("BAG_SLOT_FLAGS_UPDATED");
	-- inventoryFrame:RegisterEvent("BANK_BAG_SLOT_FLAGS_UPDATED");
  --CURRENCY_DISPLAY_UPDATE

  local bagBar = tk:CreateFrame("Frame", inventoryFrame, "MUI_InventoryBagsFrame")--[[@as MayronUI.Inventory.BagBar]];
  inventoryFrame.bagBar = bagBar;
  bagBar:SetSize(_G.NUM_BAG_SLOTS * (slotWidth + slotSpacing) - slotSpacing, slotHeight);
  bagBar:SetPoint("TOPLEFT", containerPadding.left, -containerPadding.top);
  bagBar:Hide();
  bagBar.buttons = {};

  -- Create Bags and Slots:
  for i = 0, _G.NUM_BAG_SLOTS do
    local bagIndex = _G.NUM_BAG_SLOTS - i;

    tk:KillElement(_G["ContainerFrame"..tostring(bagIndex + 1)]);
    local numSlots = GetContainerNumSlots(bagIndex);

    local bagGlobalName = "MUI_InventoryBag"..tostring(bagIndex + 1);
    local bagFrame = tk:CreateFrame("Frame", inventoryFrame, bagGlobalName)--[[@as MayronUI.Inventory.BagFrame]];
    inventoryFrame.bags[bagIndex + 1] = bagFrame;

    bagFrame:SetPoint("TOPLEFT", containerPadding.left, -containerPadding.top);
    bagFrame:SetPoint("BOTTOMRIGHT", -containerPadding.right, containerPadding.bottom);
    bagFrame:SetID(bagIndex); -- Required for dragging
    bagFrame.slots = {};
    bagFrame.bagIndex = bagIndex;

    if (numSlots > 0) then
      for slotIndex = 1, numSlots do
        local slot = CreateBagItemSlot(bagFrame, slotIndex);
        bagFrame.slots[slotIndex] = slot;
      end
    end

    bagBar.buttons[bagIndex + 1] = CreateBagBarToggleButton(bagIndex, bagBar, bagFrame, i);
  end

  UpdateInventoryDimensions(inventoryFrame);

  inventoryFrame.dragger:HookScript("OnDragStart", function()
    inventoryFrame:SetScript("OnUpdate", InventoryFrameOnUpdate);
  end);

  inventoryFrame.dragger:HookScript("OnDragStop", function()
    inventoryFrame:SetScript("OnUpdate", nil);
    UpdateInventoryDimensions(inventoryFrame);
    inventoryFrame.titleBar.onDragStop();
  end);

  inventoryFrame.money = inventoryFrame:CreateFontString("MUI_InventoryMoney", "ARTWORK", "MUI_FontNormal");
  inventoryFrame.money:SetPoint("BOTTOMLEFT", 8, 8);
  inventoryFrame.money:SetJustifyH("LEFT");

  inventoryFrame.freeSlots = inventoryFrame:CreateFontString("MUI_InventorySlots", "ARTWORK", "MUI_FontNormal");
  inventoryFrame.freeSlots:SetPoint("BOTTOMLEFT", inventoryFrame.money, "BOTTOMRIGHT", 12, 0);
  inventoryFrame.freeSlots:SetJustifyH("LEFT");

  inventoryFrame.sortBtn = gui:CreateIconButton("sort", inventoryFrame, "MUI_InventorySort");
  inventoryFrame.sortBtn:SetPoint("RIGHT", inventoryFrame.closeBtn, "LEFT", -4, 0);
  tk:SetBasicTooltip(inventoryFrame.sortBtn, "Sort Bags");
  inventoryFrame.sortBtn:SetScript("OnClick", _G["SortBags"]);

  inventoryFrame.sortBtn:RegisterEvent("PLAYER_REGEN_DISABLED");
  inventoryFrame.sortBtn:RegisterEvent("PLAYER_REGEN_ENABLED");

  inventoryFrame.sortBtn:SetScript("OnEvent", function(_, event)
    inventoryFrame.sortBtn:SetEnabled(event == "PLAYER_REGEN_ENABLED");
  end);

  inventoryFrame.bagsBtn = gui:CreateIconButton("bags", inventoryFrame, "MUI_InventoryBags");
  inventoryFrame.bagsBtn:SetPoint("RIGHT", inventoryFrame.sortBtn, "LEFT", -4, 0);
  tk:SetBasicTooltip(inventoryFrame.bagsBtn, "Toggle Bags");
  inventoryFrame.bagsBtn:SetScript("OnClick", ToggleBagsBar);

  inventoryFrame.tabs = {};
  inventoryFrame.selectedTabID = TabTypesEnum.AllItems;

  for i = 1, 5 do
    local tab = gui:CreateIcon(2, 34, 30, inventoryFrame, "check-button", nil, nil, "MUI_InventoryTab"..tostring(i))--[[@as CheckButton|MayronUI.Icon]];
    inventoryFrame.tabs[i] = tab;

    tab:HookScript("OnEnter", HandleTabOnEnter);
    tab:HookScript("OnLeave", HandleTabOnLeave);
    tab:SetScript("OnClick", HandleTabOnClick);

    if (i == 1) then
      tab:SetChecked(true);
      tab:SetPoint("TOPLEFT", inventoryFrame, "TOPRIGHT", 10, 5);
      tab.icon:SetTexture("Interface\\Icons\\Inv_misc_bag_07");
      tab.tooltipText = "All Items";
      tab:SetID(TabTypesEnum.AllItems);
    else
      tab:SetPoint("TOPLEFT", inventoryFrame.tabs[i - 1], "BOTTOMLEFT", 0, -5);
      tab:SetChecked(false);

      if (i == 2) then
        tab.icon:SetTexture("Interface\\Icons\\INV_Helmet_20");
        tab.tooltipText = "Equipment";
        tab:SetID(TabTypesEnum.Equipment);
      elseif (i == 3) then
        tab.icon:SetTexture("Interface\\Icons\\INV_Potion_51");
        tab.tooltipText = "Consumables";
        tab.icon:SetSize(28, 24);
        tab:SetID(TabTypesEnum.Consumables);
      elseif (i == 4) then
        tab.icon:SetTexture("Interface\\Icons\\INV_Fabric_Linen_01");
        tab.tooltipText = "Trade Goods";
        tab:SetID(TabTypesEnum.TradeGoods);
      elseif (i == 5) then
        tab.icon:SetTexture("Interface\\GossipFrame\\AvailableQuestIcon");
        tab.icon:SetSize(20, 20);
        tab.tooltipText = "Quest Items";
        tab:SetID(TabTypesEnum.QuestItems);
        tab.background:SetVertexColor(0, 0, 0, 1);
      end
    end

    HandleTabOnLeave(tab);
  end

  tk:GroupCheckButtons(inventoryFrame.tabs, false);

  inventoryFrame.sortBtn:HookScript("OnClick", function()
    local tab1 = inventoryFrame.tabs[1];
    local onTabClick = tab1:GetScript("OnClick");
    onTabClick(tab1);
  end);

  CreateSearchBox(inventoryFrame);

  InventoryFrameOnEvent(inventoryFrame, "PLAYER_MONEY");
  UpdateFreeSlots(inventoryFrame);
  inventoryFrame:SetScript("OnEvent", InventoryFrameOnEvent);
end