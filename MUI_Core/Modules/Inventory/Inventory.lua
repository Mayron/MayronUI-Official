-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

---@diagnostic disable-next-line: undefined-field
local GetContainerNumSlots = _G.GetContainerNumSlots;
---@diagnostic disable-next-line: undefined-field
local GetContainerItemCooldown = _G.GetContainerItemCooldown;
---@diagnostic disable-next-line: undefined-field
local GetContainerItemInfo = _G.GetContainerItemInfo;
---@diagnostic disable-next-line: undefined-field
local GetContainerItemQuestInfo = _G.GetContainerItemQuestInfo;

local Item = _G.Item;
local Mixin = _G.Mixin;

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

---@class MayronUI.Inventory.Bag : Frame
---@field slots MayronUI.Inventory.Slot[]

---@class MayronUI.Inventory.Frame : Frame
---@field bags MayronUI.Inventory.Bag[]

if (_G.C_Container) then
  GetContainerNumSlots = _G.C_Container.GetContainerNumSlots;
  GetContainerItemCooldown = _G.C_Container.GetContainerItemCooldown;
  GetContainerItemInfo = _G.C_Container.GetContainerItemInfo;
  GetContainerItemQuestInfo = _G.C_Container.GetContainerItemQuestInfo;
end

-- Register and Import Modules -----------
local C_Inventory = MayronUI:RegisterModule("Inventory", "Inventory");


-- Local Functions --------------
---@param slot MayronUI.Inventory.Slot
local function ClearBagSlot(slot)
  slot.icon:Hide();
  slot.JunkIcon:Hide();
  slot.searchOverlay:Hide();
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

  local color = slot:GetItemQualityColor();
  slot:SetGridColor(color.r, color.g, color.b);

  local info = GetContainerItemInfo(bagID, slotIndex);
  local countText = "";

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
  local iconQuestTexture = _G[slot:GetName().."IconQuestTexture"];
  iconQuestTexture:SetShown(questInfo.isQuestItem);
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

local function CreateBagItemSlot(bagFrame, slotIndex, slotWidth, slotHeight)
  local bagGlobalName = bagFrame:GetName();
  local bagID = bagFrame:GetID();
  local slotGlobalName = bagGlobalName.."Slot"..tostring(slotIndex);

  local slot = tk:CreateFrame("Button", bagFrame, slotGlobalName, "ContainerFrameItemButtonTemplate");
  slot:SetSize(slotWidth, slotHeight);
  slot.cooldown = _G[slotGlobalName.."Cooldown"];

  slot = gui:ReskinIcon(slot, 2);
  Mixin(slot, Item:CreateFromBagAndSlot(bagID, slotIndex));

  ---@cast slot MayronUI.Inventory.Slot

  slot:SetID(slotIndex);
  ClearBagSlot(slot);

  bagFrame.slots[slotIndex] = slot;

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

---@param bag MayronUI.Inventory.Bag
local function UpdateAllBagSlots(bag)
  local bagID = bag:GetID();
  if (not bagID) then return end

  for _, slot in ipairs(bag.slots) do
    UpdateBagSlot(slot);
  end
end

---@param inventoryFrame MayronUI.Inventory.Frame
---@param event string
---@param bagID number
---@param slotIndex number
local function InventoryFrame_OnEvent(inventoryFrame, event, bagID, slotIndex)
  local bag = type(bagID) == "number" and bagID >= 0 and inventoryFrame.bags[bagID + 1];

  MayronUI:LogDebug("Inventory Event: %s with bagID: %s and slotIndex: %s", event, bagID, slotIndex);
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

  -- Bag Extensions:
	-- if (event == "DISPLAY_SIZE_CHANGED" ) then
	-- 	-- UpdateContainerFrameAnchors();
  --   return
  -- end

	-- if ( event == "INVENTORY_SEARCH_UPDATE" ) then
	-- 	-- ContainerFrame_UpdateSearchResults(self);
  --   return
  -- end

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
	-- elseif ( event == "CURRENCY_DISPLAY_UPDATE" ) then
	-- 	-- BackpackTokenFrame_Update();
	-- end
end



-- C_Inventory ------------------

function C_Inventory:OnInitialize()
  if (not (tk:IsWrathClassic() and MayronUI.DEBUG_MODE)) then
    return
  end

  local slotWidth, slotHeight = 36, 30;
  local slotSpacing = 6;
  local maxColumns = 10;
  local containerPadding = { top = 28, right = 8, bottom = 8, left = 8};
  local inventoryFrame = tk:CreateFrame("Frame", nil, "MUI_Inventory");
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


  gui:CreateDialogBox(nil, "high", inventoryFrame);
  gui:AddTitleBar(inventoryFrame, "Inventory");
  gui:AddCloseButton(inventoryFrame)
  inventoryFrame.bags = {};

  -- self = inventoryFrame:
	inventoryFrame:RegisterEvent("BAG_UPDATE");
	inventoryFrame:RegisterEvent("ITEM_LOCK_CHANGED");
	inventoryFrame:RegisterEvent("BAG_NEW_ITEMS_UPDATED");

  -- Wrath Only --------------:
	inventoryFrame:RegisterEvent("QUEST_ACCEPTED");
	inventoryFrame:RegisterEvent("UNIT_QUEST_LOG_CHANGED"); -- and arg1 == "player", then also do the same as QUEST_ACCEPTED
  ----------------------------

  -- Retail?:
  -- UNIT_INVENTORY_CHANGED, PLAYER_SPECIALIZATION_CHANGED

  -- Bag Extensions:
	-- inventoryFrame:RegisterEvent("DISPLAY_SIZE_CHANGED"); -- UpdateContainerFrameAnchors();
	-- inventoryFrame:RegisterEvent("INVENTORY_SEARCH_UPDATE"); -- ContainerFrame_UpdateSearchResults(self);
	-- inventoryFrame:RegisterEvent("BAG_SLOT_FLAGS_UPDATED");
	-- inventoryFrame:RegisterEvent("BANK_BAG_SLOT_FLAGS_UPDATED");
	-- inventoryFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE"); -- BackpackTokenFrame_Update()

  print("Loaded Inventory Module");

  -- The current cell in the grid of rows and columns
  local columnIndex = 1;
  local rowIndex = 1;

  for bagID = 0, _G.NUM_BAG_SLOTS do
    tk:KillElement(_G["ContainerFrame"..tostring(bagID + 1)]);

    local numSlots = GetContainerNumSlots(bagID);
    local bagGlobalName = "MUI_InventoryBag"..tostring(bagID + 1);
    local bagFrame = tk:CreateFrame("Frame", inventoryFrame, bagGlobalName);
    inventoryFrame.bags[bagID + 1] = bagFrame;

    bagFrame:SetPoint("TOPLEFT", containerPadding.left, -containerPadding.top);
    bagFrame:SetPoint("BOTTOMRIGHT", -containerPadding.right, containerPadding.bottom);
    bagFrame:SetID(bagID);
    bagFrame.slots = {};

    if (numSlots > 0) then
      for slotIndex = 1, numSlots do
        local slot = CreateBagItemSlot(bagFrame, slotIndex, slotWidth, slotHeight);

        if ((columnIndex % (maxColumns + 1)) == 0) then
           -- next row
          rowIndex = rowIndex + 1;
          columnIndex = 1;
        end

        local xOffset = (columnIndex - 1) * (slotWidth + slotSpacing);
        local yOffset = (rowIndex - 1) * (slotHeight + slotSpacing);

        slot:SetPoint("TOPLEFT", xOffset, -yOffset);
        columnIndex = columnIndex + 1; -- next column
      end
    end
  end

  inventoryFrame:SetPoint("CENTER");

  local width = ((slotWidth + slotSpacing) * maxColumns) - slotSpacing + (containerPadding.left + containerPadding.right);
  local height = ((slotHeight + slotSpacing) * rowIndex) - slotSpacing + (containerPadding.top + containerPadding.bottom);
  inventoryFrame:SetSize(width, height);

  inventoryFrame:SetScript("OnEvent", InventoryFrame_OnEvent);
end