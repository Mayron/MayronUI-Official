-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

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
---@class MayronUI.Inventory.Slot : ItemMixin, Button
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
local function UpdateBagSlot(slot)
  local active = not slot:IsItemEmpty();
  slot.icon:SetShown(active);
  slot.IconBorder:SetShown(active);
  slot.Count:SetShown(active);
  slot.JunkIcon:Hide();
  slot.searchOverlay:Hide();

  if (not active) then return end

  local slotIndex = slot:GetID();
  local bagID = slot:GetParent():GetID();
  local iconFileID = slot:GetItemIcon();
  slot.icon:SetTexture(iconFileID);

  local color = slot:GetItemQualityColor();
  slot.IconBorder:SetVertexColor(color.r, color.g, color.b);

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

  local questInfo = GetContainerItemQuestInfo(bagID, slotIndex);-- Could also use `isActive`
  local iconQuestTexture = _G[slot:GetName().."IconQuestTexture"];
  iconQuestTexture:SetShown(questInfo.isQuestItem);
  slot.JunkIcon:SetShown(slot:GetItemQuality() == 0);
  slot.searchOverlay:SetShown(info.isFiltered);
end


local function CreateBagItemSlot(bagFrame, slotIndex)
  local bagGlobalName = bagFrame:GetName();
  local bagID = bagFrame:GetID();
  local slotGlobalName = bagGlobalName.."Slot"..tostring(slotIndex);
  local slot = tk:CreateFrame("Button", bagFrame, slotGlobalName, "ContainerFrameItemButtonTemplate"); ---@cast slot MayronUI.Inventory.Slot
  Mixin(slot, Item:CreateFromBagAndSlot(bagID, slotIndex));

  slot:SetID(slotIndex);
  bagFrame.slots[slotIndex] = slot;

  tk:KillAllElements(
    slot.ExtendedOverlay,
    slot.ExtendedOverlay2,
    slot.ExtendedSlot,
    slot.BagStaticBottom,
    slot.BagStaticTop,
    -- IsBattlePayItem (Retail?)
    slot.BattlepayItemTexture
    -- slot:GetNormalTexture(),
    -- slot:GetPushedTexture(),
    -- slot:GetHighlightTexture()
  );

  slot.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9);
  slot.icon:SetAllPoints();

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
	if (event == "BAG_OPEN" or  event == "BAG_CLOSED") then
    if (bag) then
      bag:SetShown(event == "BAG_OPEN");
    end
    return
  end

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

	if (event == "ITEM_LOCK_CHANGED" ) then
    if (bag and type(slotIndex) == "number" and slotIndex > 0) then
      local slot = bag.slots[slotIndex];

      if (slot) then
        local locked = slot:IsItemLocked();
        slot.icon:SetDesaturated(locked);
      end
    end

    return
  end

	if (event == "BAG_UPDATE_COOLDOWN" ) then
		-- ContainerFrame_UpdateCooldowns(self);
    -- for _, slot in ipairs(self.slots) do
    --   local cooldown = _G[slot:GetName().."Cooldown"];
    --   if (slot:IsItemEmpty()) then
    --     cooldown:Clear();
    --   else
    --     -- Might need need any of this:
    --     bagID = self:GetID()--[[@as number]]
    --     slotIndex = slot:GetID()--[[@as number]]
    --     local start, duration, enable = GetContainerItemCooldown(bagID, slotIndex);
    --     local isCooldownActive = enable and enable ~= 0 and start > 0 and duration > 0;

    --     if (isCooldownActive) then
    --       cooldown:SetDrawEdge(true);
    --       cooldown:SetCooldown(start, duration);
    --     else
    --       cooldown:Clear();
    --     end
    --   end
    -- end
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

  local slotSize = 30;
  local slotSpacing = 16;
  local numColumns = 10;
  local padding = 8;

  local offset = slotSpacing + slotSize;
  local inventoryFrame = tk:CreateFrame("Frame", nil, "MUI_Inventory");
  inventoryFrame.bags = {};

  -- self = inventoryFrame:
  inventoryFrame:RegisterEvent("BAG_OPEN");
	inventoryFrame:RegisterEvent("BAG_CLOSED");
	inventoryFrame:RegisterEvent("BAG_UPDATE");
	inventoryFrame:RegisterEvent("ITEM_LOCK_CHANGED");
	inventoryFrame:RegisterEvent("BAG_UPDATE_COOLDOWN");
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
    local numSlots = GetContainerNumSlots(bagID);
    local bagGlobalName = "MUI_InventoryBag"..tostring(bagID + 1);
    local bagFrame = tk:CreateFrame("Frame", inventoryFrame, bagGlobalName);
    inventoryFrame.bags[bagID + 1] = bagFrame;

    bagFrame:SetPoint("TOPLEFT", padding, -padding);
    bagFrame:SetPoint("BOTTOMRIGHT", -padding, padding);
    bagFrame:SetID(bagID);
    bagFrame.slots = {};

    if (numSlots > 0) then
      for slotIndex = 1, numSlots do
        local slot = CreateBagItemSlot(bagFrame, slotIndex);
        slot:SetSize(slotSize, slotSize);

        if (columnIndex % (numColumns + 1) == 0) then
          rowIndex = rowIndex + 1; -- next row
          columnIndex = 1;
        end

        local xOffset = ((columnIndex - 1) * offset) + padding;
        local yOffset = (-(rowIndex - 1) * offset) - padding;

        slot:SetPoint("TOPLEFT", inventoryFrame, "TOPLEFT", xOffset, yOffset);
        columnIndex = columnIndex + 1; -- next column
      end
    end
  end

  inventoryFrame:SetPoint("CENTER");

  local width = offset * numColumns - (slotSpacing) + (padding * 2);
  local height = offset * rowIndex - (slotSpacing) + (padding * 2);
  inventoryFrame:SetSize(width, height);

  inventoryFrame:SetScript("OnEvent", InventoryFrame_OnEvent);
end