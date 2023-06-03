-- luacheck: ignore self 143 631
local addOnName = ...;
local _G = _G;
local LibStub = _G.LibStub;
local MayronUI = _G.MayronUI;
local tk, _, _, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local OrbitusDB = LibStub:GetLibrary("OrbitusDB");

local GameTooltip = _G["GameTooltip"];
local C_Container = _G["C_Container"];
local C_EquipmentSet = _G["C_EquipmentSet"];

local IsContainerItemAnUpgrade = _G["IsContainerItemAnUpgrade"];

local GetBagName = _G["GetBagName"];
local GetContainerNumSlots = _G["GetContainerNumSlots"];
local GetContainerItemCooldown = _G["GetContainerItemCooldown"];
local GetContainerItemInfo = _G["GetContainerItemInfo"];
local GetContainerItemQuestInfo = _G["GetContainerItemQuestInfo"];
local GetContainerNumFreeSlots = _G["GetContainerNumFreeSlots"];
local SetItemSearch = _G["SetItemSearch"];
local ContainerIDToInventoryID = _G["ContainerIDToInventoryID"];

if (C_Container) then
  GetBagName = C_Container.GetBagName;
  GetContainerNumSlots = C_Container.GetContainerNumSlots;
  GetContainerItemCooldown = C_Container.GetContainerItemCooldown;
  GetContainerItemInfo = C_Container.GetContainerItemInfo;
  GetContainerItemQuestInfo = C_Container.GetContainerItemQuestInfo;
  GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots;
  SetItemSearch = C_Container.SetItemSearch;
  ContainerIDToInventoryID = C_Container.ContainerIDToInventoryID;
end

local GetInventorySlotInfo = _G.GetInventorySlotInfo;
local PlaySound, GetScreenWidth, GetScreenHeight = _G.PlaySound, _G.GetScreenWidth, _G.GetScreenHeight;
local SoundKit, GetItemInfoInstant = _G.SOUNDKIT, _G.GetItemInfoInstant;
local EasyMenu, GetTime, ipairs, IsAddOnLoaded = _G["EasyMenu"], _G.GetTime, _G.ipairs, _G.IsAddOnLoaded;

local ScrollBarWidth = 12;

local BagIndexes = _G["Enum"] and _G["Enum"].BagIndex or {
  Keyring = -2,
  Backpack = 0,
  ReagentBag = 5,
  Bag_1 = 1,
  Bag_2 = 2,
  Bag_3 = 3,
  Bag_4 = 4,
};

---@enum MayronUI.Inventory.TabType
local TabTypesEnum = {
  AllItems = 0;
  Equipment = 1;
  Consumables = 2;
  TradeGoods = 3;
  QuestItems = 4;
};

local TOTAL_BAG_FRAMES = _G.NUM_BAG_SLOTS + 2; -- 2 for backpack and keyring/reagent

local Mixin, Item = _G.Mixin, _G.Item;
local GetMoney = _G.GetMoney;

---@class MayronUI.Inventory.BagButton : CheckButton, ItemMixin, MayronUI.Icon
---@field icon Texture
---@field bagIndex number
---@field Count FontString
---@field bagFrame MayronUI.Inventory.BagFrame

---@class MayronUI.Inventory.ViewSettings
---@field initialColumns number
---@field initialRows number
---@field height number
---@field maxColumns number
---@field maxRows number
---@field minColumns number
---@field minRows number
---@field initialWidth number
---@field minWidth number
---@field maxWidth number
---@field slotSpacing number

---@class MayronUI.Inventory.BagBar : Frame
---@field buttons MayronUI.Inventory.BagButton[]

---@class MayronUI.Inventory.Slot : Button, ItemMixin, MayronUI.Icon
---@field icon Texture
---@field itemName FontString
---@field itemDetails FontString
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
---@field inventoryFrame MayronUI.Inventory.Frame

---@class MayronUI.Inventory.Frame : Frame, MayronUI.GridTextureMixin
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
---@field viewBtn Button
---@field charactersBtn Button
---@field titleBar Button|table
---@field selectedTabID MayronUI.Inventory.TabType?
---@field tabs ((MayronUI.Icon|CheckButton)[])?
---@field detailedView boolean
---@field scrollChild BackdropTemplate|Frame
---@field scrollBar Frame
---@field bagsContainer ScrollFrame
---@field character string?
---@field searchBox EditBox

-- Register and Import Modules -----------
local C_InventoryModule = MayronUI:RegisterModule("InventoryModule", L["Inventory"]);

-- Settings:
local minInventoryFrameWidth = 340;

---@type OrbitusDB.DatabaseConfig
local databaseConfig = {
  svName = "MUI_InventoryDB";
  defaults = {
    character = {
      detailed = {
        columns = { initial = 3, min = 1, max = 4 };
        rows = { initial = 10, min = 5, max = 15 };
      },
      grid = {
        columns = { initial = 10, min = 8, max = 30 };
        rows = { initial = 30, min = 30, max = 30 };
      }
    },
    global = {
      enabled = true;
    },
    profile = {
      detailed = {
        showItemLevels = true;
        showItemName = true;
        showItemType = true;
        itemNameFontSize = 11;
        itemDescriptionFontSize = 10;
        height = 36;
        slotSpacing = 6;
        widths = { initial = 260, min = 220, max = 320 };
      };
      grid = {
        showItemLevels = true;
        showItemName = false;
        showItemType = false;
        itemNameFontSize = 11;
        itemDescriptionFontSize = 10;
        height = 30;
        slotSpacing = 6;
        widths = { initial = 36, min = 36, max = 36 };
      };
      container = {
        colorScheme = "MUI_Frames";
        customColor = { 0.8, 0.8, 0.8 };
        padding = 8;
        tabBar = {
          show = true;
          position = "RIGHT";
          xOffset = 10;
          yOffset = 3;
          spacing = 5;
          scale = 1;
          direction = "DOWN";
          showEquipment = true;
          showConsumables = true;
          showTradeGoods = true;
          showQuestItems = true;
        }
      }
    };
  };
};

local containerVerticalPadding = 30;
local containerPadding = { top = 0, right = 0, bottom = 0, left = 0 };
local originalTopPadding = 0;

-- Local Functions --------------

local function GetActualSlotHeight()
  local inventoryFrame = _G["MUI_Inventory"];---@type MayronUI.Inventory.Frame
  local slot = inventoryFrame.bags[1].slots[1];

  local highest, lowest = 0, 5000;
  for i = 1, slot:GetNumRegions() do
    local region = (select(i, slot:GetRegions())); ---@type Region
    local top, bottom = region:GetTop(), region:GetBottom();
    highest = math.max(highest, top or 0);
    lowest = math.min(lowest, bottom or 5000);
  end

  local slotHeight = math.abs(highest - lowest);

  if (slotHeight < 5000) then
    return slotHeight;
  end
end

local function RepositionInventoryFrame(inventoryFrame)
  local screenBottomDistance = inventoryFrame:GetBottom();
  local screenLeftDistance = inventoryFrame:GetLeft();
  if (not (obj:IsNumber(screenBottomDistance) and obj:IsNumber(screenLeftDistance))) then return end
  inventoryFrame:ClearAllPoints();

  local xOffset = screenLeftDistance;
  local yOffset = screenBottomDistance + inventoryFrame:GetHeight();
  inventoryFrame:SetPoint("TOPLEFT", _G.UIParent, "BOTTOMLEFT", xOffset, yOffset);
  return  xOffset, yOffset;
end

---@param settings MayronUI.Inventory.ViewSettings
---@param totalColumns number|"min"|"max"|"initial"
---@return integer totalRows, number slotWidth
local function UpdateBagSlotAnchors(settings, updateAnchors, totalColumns, orderedSlots, containerWidth)
  local columnIndex = 1;
  local totalRows = 1;
  local slotWidth = settings.initialWidth;

  if (type(totalColumns) == "string") then
    if (totalColumns == "min") then
      slotWidth = settings.minWidth;
      totalColumns = settings.minColumns;
    elseif  (totalColumns == "max") then
      slotWidth = settings.maxWidth;
      totalColumns = settings.maxColumns;
    else
      totalColumns = settings.initialColumns;
    end
  end

  if (settings.minWidth ~= settings.maxWidth and containerWidth > 0) then
    slotWidth = (containerWidth / totalColumns);

    if (totalColumns > 1) then
      local gaps = totalColumns - 1;
      local totalSpace = gaps * settings.slotSpacing;
      local widthReduction = totalSpace / totalColumns;
      slotWidth = slotWidth - widthReduction;
    end

    slotWidth = math.max(math.min(slotWidth, settings.maxWidth), settings.minWidth);
  end

  for _, slot in ipairs(orderedSlots) do
    if (slot:IsShown()) then
      if ((columnIndex % (totalColumns + 1)) == 0) then
          -- next row
        totalRows = totalRows + 1;
        columnIndex = 1;
      end

      if (updateAnchors) then
        local xOffset = (columnIndex - 1) * (slotWidth + settings.slotSpacing);
        local yOffset = (totalRows - 1) * (settings.height + settings.slotSpacing);
        slot:SetPoint("TOPLEFT", xOffset, -yOffset);
      end

      slot:SetWidth(slotWidth);
      columnIndex = columnIndex + 1; -- next column
    end
  end

  return totalRows, slotWidth;
end

local GetOrderedSlots; ---@type fun(inventoryFrame: MayronUI.Inventory.Frame, resetSlotOrder: boolean?): MayronUI.Inventory.Slot[]

do
  local orderedSlots = {}; ---@type MayronUI.Inventory.Slot[]
  local emptySlots = {}; ---@type MayronUI.Inventory.Slot[]

  GetOrderedSlots = function(inventoryFrame, resetSlotOrder)
    if (resetSlotOrder) then
      tk.Tables:Empty(orderedSlots);
    end

    local showAllItems = inventoryFrame.selectedTabID == TabTypesEnum.AllItems;

    if (tk.Tables:IsEmpty(orderedSlots)) then
      if (showAllItems) then
        for i = #inventoryFrame.bags, 1, -1 do
          local bag = inventoryFrame.bags[i];

          if (bag:IsShown()) then
            for j = 0, (#bag.slots - 1) do
              local slot = bag.slots[#bag.slots - j];

              if (tk:IsRetail()) then
                slot = bag.slots[j + 1];
              end

              if (slot:IsShown()) then
                orderedSlots[#orderedSlots + 1] = slot;
              end
            end
          end
        end
      else
        tk.Tables:Empty(emptySlots);

        for i = #inventoryFrame.bags, 1, -1 do
          local bag = inventoryFrame.bags[i];
          local isKeyring = bag.bagIndex == BagIndexes.Keyring;
          local isReagentBag = bag.bagIndex == BagIndexes.ReagentBag;

          local shown = not (isKeyring or isReagentBag);
          bag:SetShown(shown);

          if (shown) then
            for j = 0, (#bag.slots - 1) do
              local slot = bag.slots[#bag.slots - j];

              if (tk:IsRetail()) then
                slot = bag.slots[j + 1];
              end

              if (slot:IsShown()) then
                if (resetSlotOrder and slot:IsItemEmpty()) then
                  emptySlots[#emptySlots+1] = slot;
                else
                  orderedSlots[#orderedSlots+1] = slot;
                end
              end
            end
          end
        end

        for _, emptySlot in ipairs(emptySlots) do
          orderedSlots[#orderedSlots+1] = emptySlot;
        end

        tk.Tables:Empty(emptySlots);
      end
    end

    return orderedSlots;
  end
end

---@param inventoryFrame MayronUI.Inventory.Frame
---@param totalColumns number
---@param slotWidth number
---@param totalRows number
---@param maxRows number
local function GetFrameDimensionsByTotalColumns(inventoryFrame, slotSpacing, totalColumns, slotHeight, slotWidth, totalRows, maxRows)
  local slotXOffset = (slotWidth + slotSpacing);
  local slotYOffset = (slotHeight + slotSpacing);
  local scrollChildHeight = (slotYOffset * totalRows) - slotSpacing;
  local bagsContainerWidth = (slotXOffset * totalColumns) - slotSpacing;
  local bagsContainerHeight = (slotYOffset * math.min(totalRows, maxRows)) - slotSpacing;

  if (inventoryFrame.detailedView and inventoryFrame.scrollBar:IsShown()) then
    bagsContainerWidth = bagsContainerWidth + ScrollBarWidth; -- for scroll bar
  end

  local actualHeight = GetActualSlotHeight();

  if (actualHeight and actualHeight > slotHeight) then
    local diff = actualHeight - slotHeight;
    bagsContainerHeight = bagsContainerHeight + diff;
  end

  local newWidth = containerPadding.left + bagsContainerWidth + containerPadding.right;
  local newHeight = containerPadding.top + bagsContainerHeight + containerPadding.bottom;

  if (inventoryFrame.bagBar) then
    local bagBarWidth = inventoryFrame.bagBar:GetWidth();
    newWidth = math.max(math.max(newWidth, bagBarWidth), minInventoryFrameWidth);

    if (inventoryFrame.minWidth) then
      inventoryFrame.minWidth = math.max(math.max(inventoryFrame.minWidth, bagBarWidth), minInventoryFrameWidth);
    end
  end

  local screenHeight = GetScreenHeight() * 0.9;
  newHeight = math.min(newHeight, screenHeight);

  return newWidth, newHeight, scrollChildHeight;
end

---@param inventoryFrame MayronUI.Inventory.Frame
---@param resetSlotOrder boolean
---@return number inventoryWidth, number inventoryHeight, number scrollChildHeight, number? totalRows, number? totalColumns
local function UpdateInventorySlotCoreProperties(inventoryFrame, resetSlotOrder)
  local orderedSlots = GetOrderedSlots(inventoryFrame, resetSlotOrder);
  local containerWidth = inventoryFrame.bagsContainer:GetWidth();

  if (inventoryFrame.detailedView and inventoryFrame.scrollBar:IsShown()) then
    containerWidth = containerWidth - ScrollBarWidth; -- for scroll bar
  end

  local db = OrbitusDB:GetDatabase("MUI_InventoryDB");
  local settingName = inventoryFrame.detailedView and "detailed" or "grid";

  ---@type MayronUI.Inventory.ViewSettings
  local settings = db.utilities:PopTable();

  settings.initialColumns = db.character:QueryType("number", settingName, "columns.initial");
  settings.maxColumns = db.character:QueryType("number", settingName, "columns.max");
  settings.minColumns = db.character:QueryType("number", settingName, "columns.min");

  settings.initialRows = db.character:QueryType("number", settingName, "rows.initial");
  settings.maxRows = db.character:QueryType("number", settingName, "rows.max");
  settings.minRows = db.character:QueryType("number", settingName, "rows.min");

  settings.height = db.profile:QueryType("number", settingName, "height");
  settings.initialWidth = db.profile:QueryType("number", settingName, "widths.initial");
  settings.minWidth = db.profile:QueryType("number", settingName, "widths.min");
  settings.maxWidth = db.profile:QueryType("number", settingName, "widths.max");
  settings.slotSpacing = db.profile:QueryType("number", settingName, "slotSpacing");

  if (settings.minColumns > settings.maxColumns) then
    settings.maxColumns = settings.minColumns;
  end

  if (inventoryFrame.minWidth and inventoryFrame.maxWidth) then
    local totalColumns = 1;
    local slotWidth = inventoryFrame.detailedView and settings.minWidth or settings.initialWidth;

    for columns = 1, settings.maxColumns do
      local width = ((slotWidth + settings.slotSpacing) * columns) - settings.slotSpacing;

      if (width > containerWidth) then
        break
      end

      totalColumns = columns;
    end

    totalColumns = math.max(settings.minColumns, totalColumns);

    -- return the real dimensions for the current number of slots to show
    local totalRows, dynamicSlotWidth = UpdateBagSlotAnchors(settings, true, totalColumns, orderedSlots, containerWidth);

    local newWidth, newHeight, scrollChildHeight = GetFrameDimensionsByTotalColumns(
      inventoryFrame, settings.slotSpacing, totalColumns, settings.height, dynamicSlotWidth, totalRows, settings.maxRows);

    if (not inventoryFrame.detailedView) then
      -- fix the height to the correct constraints
      tk:SetResizeBounds(inventoryFrame, inventoryFrame.minWidth, newHeight, inventoryFrame.maxWidth, newHeight);
    end

    return newWidth, newHeight, scrollChildHeight, totalRows, totalColumns;
  end

  -- calculate min/max dimensions for resizing:
  local maxRows, minSlotWidth = UpdateBagSlotAnchors(settings, false, "min", orderedSlots, 0);

  local minWidth, maxHeight = GetFrameDimensionsByTotalColumns(
    inventoryFrame, settings.slotSpacing, settings.minColumns, settings.height,
    minSlotWidth, maxRows, settings.maxRows);

  local minRows, maxSlotWidth = UpdateBagSlotAnchors(settings, false, "max", orderedSlots, 0);

  local maxWidth, minHeight = GetFrameDimensionsByTotalColumns(
    inventoryFrame, settings.slotSpacing, settings.maxColumns, settings.height,
    maxSlotWidth, minRows, settings.minRows);

  inventoryFrame.minWidth = minWidth;
  inventoryFrame.maxWidth = maxWidth;

  tk:SetResizeBounds(inventoryFrame, minWidth, minHeight, maxWidth, maxHeight);

  local initialRows, initialSlotWidth = UpdateBagSlotAnchors(settings, true, "initial", orderedSlots, 0);

  local initialWidth, initialHeight, scrollChildHeight = GetFrameDimensionsByTotalColumns(
    inventoryFrame, settings.slotSpacing, settings.initialColumns, settings.height,
    initialSlotWidth, initialRows, settings.initialRows);

  db.utilities:PushTable(settings);
  return initialWidth, initialHeight, scrollChildHeight;
end

---@param inventoryFrame MayronUI.Inventory.Frame
---@param resetSlotOrder boolean?
local function UpdateInventoryFrameCoreProperties(inventoryFrame, resetSlotOrder)
  local w, h = inventoryFrame:GetSize();

  if (w == 0 or h == 0) then
    inventoryFrame:SetSize(10, 10);
    local slot = inventoryFrame.bags[1].slots[1];
    slot:SetPoint("TOPLEFT");
  end

  local width, height, scrollChildHeight = UpdateInventorySlotCoreProperties(inventoryFrame, resetSlotOrder == true);
  RepositionInventoryFrame(inventoryFrame);
  inventoryFrame.scrollChild:SetHeight(scrollChildHeight);
  inventoryFrame:SetWidth(math.max(width, minInventoryFrameWidth));

  if (not inventoryFrame.detailedView or h == 0) then
    inventoryFrame:SetHeight(height);
  end

  return width, height;
end

---@param inventoryFrame MayronUI.Inventory.Frame
---@param enabled boolean
local function SetDetailedViewEnabled(inventoryFrame, enabled)
  inventoryFrame.detailedView = enabled;

  -- required to reset inventory frame and slots
  -- back to initial values and recalculate minWidth/maxWidth
  inventoryFrame.minWidth = nil;
  inventoryFrame.maxWidth = nil;

  local db = OrbitusDB:GetDatabase("MUI_InventoryDB");
  local settingName = enabled and "detailed" or "grid";
  local slotWidth = db.profile:QueryType("number", settingName, "widths.initial");
  local slotHeight = db.profile:QueryType("number", settingName, "height");

  inventoryFrame.bagsContainer:SetPoint("BOTTOMRIGHT", -containerPadding.right, containerPadding.bottom);
  inventoryFrame.bagsContainer:SetVerticalScroll(0);

  if (enabled) then
    tk:SetBasicTooltip(inventoryFrame.viewBtn, L["Switch to Grid View"]);
  else
    tk:SetBasicTooltip(inventoryFrame.viewBtn, L["Switch to Detailed View"]);
  end

  if (enabled) then
    for _, bag in ipairs(inventoryFrame.bags) do
      for _, slot in ipairs(bag.slots) do
        slot:SetSize(slotWidth, slotHeight);
        slot.gloss:SetAlpha(0.2);
        slot.Count:SetPoint("BOTTOMRIGHT", slot.icon, "BOTTOMRIGHT", -2, 2);

        slot.icon:ClearAllPoints();
        slot.icon:SetPoint("TOPLEFT", 2, -2);
        slot.icon:SetPoint("BOTTOMLEFT", 2, 2);
        slot.icon:SetWidth(slotHeight);
        slot.questTexture:ClearAllPoints();
        slot.questTexture:SetAllPoints(slot.icon);

        slot.itemDetails:ClearAllPoints();
        slot.itemDetails:SetPoint("TOPLEFT", slot.itemName, "BOTTOMLEFT", 0, -2);
        slot.itemDetails:SetPoint("TOPRIGHT", slot.itemName, "BOTTOMRIGHT", 0, -2);
        slot.itemDetails:SetTextColor(tk.Constants.COLORS.GRAY:GetRGB());
        tk:SetMasterFont(slot.itemDetails, 10, "");
      end
    end
  else
    inventoryFrame.scrollChild:SetHeight(1);

    for _, bag in ipairs(inventoryFrame.bags) do
      for _, slot in ipairs(bag.slots) do
        slot.icon:ClearAllPoints();
        slot.icon:SetPoint("CENTER");
        slot:SetSize(slotWidth, slotHeight);

        slot.gloss:SetAlpha(0.4);
        slot.Count:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", -2, 2);

        slot.questTexture:ClearAllPoints();
        slot.questTexture:SetAllPoints(slot);

        slot.itemDetails:ClearAllPoints();
        slot.itemDetails:SetPoint("TOP", slot, "TOP", 1, -2);
        tk:SetFont(slot.itemDetails, "Prototype", 11, "OUTLINE");
      end
    end
  end
end

---@param slot MayronUI.Inventory.Slot
local function SetBagItemSlotBorderColor(slot, isHighlightedBag)
  if (not slot:IsItemEmpty()) then
    local invType = slot:GetInventoryType();
    local quality = slot:GetItemQuality();

    if ((invType and invType > 0) or (quality and quality > 1)) then
      local equipmentSets = C_EquipmentSet.GetNumEquipmentSets();

      if (equipmentSets > 0) then
        local slotID = slot:GetItemID();

        for i = 0, (equipmentSets - 1) do
          local items = C_EquipmentSet.GetItemIDs(i);

          if (obj:IsTable(items)) then
            for _, itemID in ipairs(items) do

              if (slotID == itemID) then
                local color = tk.Constants.COLORS.BATTLE_NET_BLUE;
                slot:SetGridColor(color.r, color.g, color.b);
                return
              end
            end
          end
        end
      end

      local color = slot:GetItemQualityColor();

      if (obj:IsTable(color)) then
        slot:SetGridColor(color.r, color.g, color.b);
        return
      end
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
  slot.itemName:SetText("");
  slot.itemDetails:SetText("");
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

  if (isCooldownActive) then
    slot.cooldown:SetCooldown(start, duration);
  else
    slot.cooldown:Clear();
  end
end

---@param slot MayronUI.Inventory.Slot
local function GetBagSlotItemCountText(slot)
  local countText = "";

  if (slot:HasItemLocation()) then
    local slotIndex = slot:GetID();
    local bag = slot:GetParent()--[[@as MayronUI.Inventory.BagFrame]]
    local bagIndex = bag:GetID();

    if (slotIndex and bagIndex) then
      local info, stackCount = GetContainerItemInfo(bagIndex, slotIndex);

      if (obj:IsTable(info) and obj:IsNumber(info.stackCount)) then
        stackCount = info.stackCount;
      end

      if (obj:IsNumber(stackCount) and stackCount > 1) then
        if (stackCount > 9999) then
          countText = "*";
        else
          countText = tostring(stackCount);
        end
      end
    end
  end

  return countText;
end

---@param slot MayronUI.Inventory.Slot
local function GetBagSlotQuestItemTexture(slot)
  local slotIndex = slot:GetID() or 0;
  local bag = slot:GetParent() --[[@as MayronUI.Inventory.BagFrame]];

  if (obj:IsFunction(GetContainerItemQuestInfo) and slot.questTexture) then
    local questInfo = GetContainerItemQuestInfo(bag.bagIndex, slotIndex);-- Could also use `isActive`
    local isQuestItem = questInfo.questId or questInfo.questID or questInfo.isQuestItem;

    if (isQuestItem) then
      return _G[questInfo.isActive and "TEXTURE_ITEM_QUEST_BANG" or "TEXTURE_ITEM_QUEST_BORDER"];
    end

  elseif (tk:IsClassic()) then
    local itemClassID = select(6, GetItemInfoInstant(slot:GetItemID()));

    if (itemClassID == Enum.ItemClass.Questitem) then
      return _G["TEXTURE_ITEM_QUEST_BORDER"];
    end
  end
end

---@param slot MayronUI.Inventory.Slot
local function UpdateBagSlot(slot, button)
  if (button == "LeftButton") then return end

  if (slot:IsItemEmpty()) then
    ClearBagSlot(slot);
    return
  end

  local db = OrbitusDB:GetDatabase("MUI_InventoryDB");
  local slotIndex = slot:GetID();
  local bag = slot:GetParent() --[[@as MayronUI.Inventory.BagFrame]];
  local iconFileID = slot:GetItemIcon();

  slot.icon:SetTexture(iconFileID);
  local locked = slot:IsItemLocked();
  slot.icon:SetDesaturated(locked);
  slot.icon:Show();
  slot.gloss:Show();

  SetBagItemSlotBorderColor(slot, bag.highlighted);

  local detailedView = bag.inventoryFrame.detailedView;
  local settingName = bag.inventoryFrame.detailedView and "detailed" or "grid";
  local showItemLevels = db.profile:QueryType("boolean", settingName, "showItemLevels");
  local showItemName = db.profile:QueryType("boolean", settingName, "showItemName");
  local showItemType = db.profile:QueryType("boolean", settingName, "showItemType");

  slot.itemName:SetShown(detailedView and showItemName);

  local quality = slot:GetItemQuality() or 0;
  local itemName = slot:GetItemName();

  local _, itemClass, itemSubClass, equipLocation, _, classID, subClassID = GetItemInfoInstant(slot:GetItemID());
  local invType = slot:GetInventoryType() or 0;

  if (detailedView) then
    slot.itemName:SetText(itemName);

    local subText;

    if (showItemType or showItemLevels) then
      if (classID == Enum.ItemClass.Miscellaneous and quality > 0) then
        local isJunk = subClassID == Enum.ItemMiscellaneousSubclass.Junk;
        local isOther = subClassID == Enum.ItemMiscellaneousSubclass.Other;

        if (isJunk or isOther) then
          -- if the item is classed as Junk but the quality isn't poor,
          -- use the itemClass instead as its more useful
          subText = itemClass;
        else
          subText = itemSubClass or itemClass;
        end
      else
        subText = itemSubClass or itemClass;
      end

      if (invType > 0 and equipLocation) then
        local inventorySlot = _G[equipLocation];

        if (obj:IsString(inventorySlot) and obj:IsString(subText) and subText ~= inventorySlot) then
          local itemLevel = slot:GetCurrentItemLevel();
          local itemTypeText = "";

          if (showItemType) then
            itemTypeText = inventorySlot..", "..subText.." ";
          end

          if (showItemLevels and type(itemLevel) == "number" and itemLevel > 0) then
            subText = itemTypeText.."(iLvl: "..itemLevel..")";
          else
            subText = itemTypeText;
          end
        else
          subText = showItemType and inventorySlot or "";
        end
      end
    end

    slot.itemDetails:SetText(subText or "");

    if (invType > 0 or quality > 1) then
      local color = slot:GetItemQualityColor();
      slot.itemName:SetTextColor(color.r, color.g, color.b);
    else
      slot.itemName:SetTextColor(1, 1, 1);
    end

    local itemNameFontSize = db.profile:QueryType("number", settingName, "itemNameFontSize");
    tk:SetFontSize(slot.itemName, itemNameFontSize);
    local itemDescriptionFontSize = db.profile:QueryType("number", settingName, "itemDescriptionFontSize");
    tk:SetFontSize(slot.itemDetails, itemDescriptionFontSize);
  else
    local itemLevel;

    if (showItemLevels) then
      if (invType > 0 and equipLocation and quality > 1) then
        local inventorySlot = _G[equipLocation];

        if (obj:IsString(inventorySlot)) then
          itemLevel = slot:GetCurrentItemLevel();
        end
      end
    end

    if (type(itemLevel) == "number" and itemLevel > 0) then
      local color = slot:GetItemQualityColor();
      slot.itemDetails:SetTextColor(color.r, color.g, color.b);
      slot.itemDetails:SetText(itemLevel);
    else
      slot.itemDetails:SetText("");
    end
  end

  slot.JunkIcon:SetShown(quality == 0);

  if (not (slot:HasItemLocation() and slotIndex)) then
    return
  end

  if (tk:IsRetail() and obj:IsFunction(IsContainerItemAnUpgrade)) then
    local itemIsUpgrade = IsContainerItemAnUpgrade(bag.bagIndex, slotIndex);
    slot.UpgradeIcon:SetShown(itemIsUpgrade);
  end

  local countText = GetBagSlotItemCountText(slot);
  slot.Count:SetText(countText);
  slot.Count:Show();

  local questTexture = GetBagSlotQuestItemTexture(slot);

  if (questTexture) then
    slot.questTexture:SetTexture(questTexture);
    slot.questTexture:Show();
    local r, g, b = tk.Constants.COLORS.GOLD:GetRGB();
    slot:SetGridColor(r, g, b);
  else
    slot.questTexture:Hide();
  end

  UpdateBagSlotCooldown(bag, slot);
end

local function ApplyColorScheme(scheme)
  local r, g, b = gui:GetMuiFrameColor();

  if (scheme == "Theme") then
    r, g, b = tk:GetThemeColor();
  elseif (scheme == "Class") then
    r, g, b = tk:GetClassColor();
  elseif (scheme == "Custom") then
    local db = OrbitusDB:GetDatabase("MUI_InventoryDB");
    r = db.profile:QueryType("number", "container.customColor[1]");
    g = db.profile:QueryType("number", "container.customColor[2]");
    b = db.profile:QueryType("number", "container.customColor[3]");
  end

  local inventoryFrame = _G["MUI_Inventory"]--[[@as MayronUI.Inventory.Frame]];
  inventoryFrame:SetGridColor(r, g, b);
end

local function HandleBagPreviewSlotOnLeave(preview)
  tk.HandleTooltipOnLeave();
  local slot = preview.slot;
  UpdateBagSlot(slot);
end

local function HandleBagSlotOnEnter(self)
  local slot = self;

  if (self.slot) then
    slot = self.slot;
  end

  slot:SetGridColor(1, 1, 1);

  if (not slot:HasItemLocation()) then
    if (slot:IsItemEmpty()) then
      return
    end

    local itemID = slot:GetItemID();
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    GameTooltip:SetItemByID(itemID);
  end
end

---@param bagFrame MayronUI.Inventory.BagFrame
---@param slotIndex number
---@return MayronUI.Inventory.Slot
local function CreateBagSlot(bagFrame, slotIndex)
  local bagGlobalName = bagFrame:GetName();
  local slotGlobalName = bagGlobalName.."Slot"..tostring(slotIndex);

  local slot;

  if (tk:IsRetail()) then
    slot = tk:CreateFrame("ItemButton", bagFrame, slotGlobalName, "ContainerFrameItemButtonTemplate")--[[@as MayronUI.Inventory.Slot]];
  else
    slot = tk:CreateFrame("Button", bagFrame, slotGlobalName, "ContainerFrameItemButtonTemplate")--[[@as MayronUI.Inventory.Slot]];
  end

  slot:SetID(slotIndex);
  slot.cooldown = _G[slotGlobalName.."Cooldown"];
  slot.questTexture = _G[slotGlobalName.."IconQuestTexture"];
  slot.questTexture:SetTexCoord(0.05, 0.95, 0.05, 0.95);

  -- Required to show cooldown
  slot:HookScript("OnClick", UpdateBagSlot);

  slot = gui:ReskinIcon(slot, 2);

  local db = OrbitusDB:GetDatabase("MUI_InventoryDB");
  local settingName = bagFrame.inventoryFrame.detailedView and "detailed" or "grid";
  local slotWidth = db.profile:QueryType("number", settingName, "widths.initial");
  local slotHeight = db.profile:QueryType("number", settingName, "height");
  slot:SetSize(slotWidth, slotHeight);

  Mixin(slot, Item:CreateFromBagAndSlot(bagFrame.bagIndex, slotIndex));

  slot.itemName = slot:CreateFontString("$parentItemName", "OVERLAY", "GameFontHighlight");
  slot.itemName:SetPoint("TOPLEFT", slot.icon, "TOPRIGHT", 8, -4);
  slot.itemName:SetPoint("TOPRIGHT", -8, -4);
  slot.itemName:Hide();
  slot.itemName:SetJustifyH("LEFT");
  slot.itemName:SetWordWrap(false);
  tk:SetFontSize(slot.itemName, 12);

  slot.flash:ClearAllPoints();
  slot.flash:SetAllPoints(slot);

  slot.NewItemTexture:ClearAllPoints();
  slot.NewItemTexture:SetAllPoints(slot);

  slot.itemDetails = slot:CreateFontString("$parentItemClass", "OVERLAY", "GameFontHighlight");
  slot.itemDetails:SetWordWrap(false);
  slot.itemDetails:SetJustifyH("LEFT");
  tk:SetFontSize(slot.itemDetails, 10);

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

  slot:SetHighlightTexture(tk.Constants.SOLID_TEXTURE);
  slot:SetPushedTexture(tk.Constants.SOLID_TEXTURE);

  tk:ApplyThemeColor(0.2, slot:GetHighlightTexture());
  local pushedTexture = slot:GetPushedTexture()--[[@as Texture]];
  pushedTexture:SetAlpha(0.2);
  pushedTexture:SetDrawLayer("OVERLAY");
  pushedTexture:SetBlendMode("ADD");

  slot:HookScript("OnEnter", HandleBagSlotOnEnter);
  slot:HookScript("OnLeave", UpdateBagSlot);

  if (not slot:IsItemEmpty()) then
    slot:ContinueOnItemLoad(function()
      UpdateBagSlot(slot);
    end);
  end

  return slot;
end

---@param bagFrame MayronUI.Inventory.BagFrame
local function CreateBagSlots(bagFrame)
  local numSlots = GetContainerNumSlots(bagFrame.bagIndex);

  if (numSlots > 0) then
    for slotIndex = 1, numSlots do
      if (not bagFrame.slots[slotIndex]) then
        local slot = CreateBagSlot(bagFrame, slotIndex);
        bagFrame.slots[slotIndex] = slot;
      end

      bagFrame.slots[slotIndex]:Show();
    end
  end
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
  local isBackpack = bagBtn.bagIndex == BagIndexes.Backpack;
  local isKeyring = bagBtn.bagIndex == BagIndexes.Keyring;
  local isOpen = bagBtn.bagFrame:IsShown();
  bagBtn.icon:SetAlpha(isOpen and 1 or 0.25);

  if (isBackpack or isKeyring) then
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

      if (quality and quality > 1) then
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

    if (bagBtn.bagIndex == BagIndexes.ReagentBag) then
      equipmentSlotName = "REAGENTBAG0SLOT";
    end

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

local function BagBarOnShow(self)
  local inventoryFrame = self:GetParent()--[[@as MayronUI.Inventory.Frame]]
  if (not tk:IsClassic()) then
    inventoryFrame:RegisterEvent("BAG_CONTAINER_UPDATE"); -- when a bag is added or removed from the bags bar
  end
end

---@param db OrbitusDB.DatabaseMixin
---@param bagBar MayronUI.Inventory.BagBar
---@param bagFrame MayronUI.Inventory.BagFrame
---@param xOffset number
---@return MayronUI.Icon|MayronUI.Inventory.BagButton
local function CreateBagToggleButton(db, bagBar, bagFrame, xOffset)
  local bagBtnName;
  local isBackpack = bagFrame.bagIndex == BagIndexes.Backpack;
  local isKeyring = bagFrame.bagIndex == BagIndexes.Keyring;
  local isReagentBag = bagFrame.bagIndex == BagIndexes.ReagentBag;

  if (isBackpack) then
    bagBtnName = "MUI_InventoryBackpackToggleButton";
  elseif (isKeyring) then
    bagBtnName = "MUI_InventoryKeyringToggleButton";
  elseif (isReagentBag) then
    bagBtnName = "MUI_InventoryReagentBagToggleButton";
  else
    bagBtnName = "MUI_InventoryBagSlotToggleButton"..tostring(bagFrame.bagIndex);
  end

  local bagToggleBtn;
  if (tk:IsRetail()) then
    bagToggleBtn = tk:CreateFrame("ItemButton", bagBar, bagBtnName)--[[@as MayronUI.Inventory.BagButton]];
  else
    bagToggleBtn = tk:CreateFrame("CheckButton", bagBar, bagBtnName, "ItemButtonTemplate")--[[@as MayronUI.Inventory.BagButton]];
  end

  bagToggleBtn.bagFrame = bagFrame;
  bagToggleBtn.bagIndex = bagFrame.bagIndex;
  bagToggleBtn.icon = _G[bagBtnName.."IconTexture"];

  local slotWidth = db.profile:QueryType("number", "grid.widths.initial");
  local slotHeight = db.profile:QueryType("number", "grid.height");
  local slotSpacing = db.profile:QueryType("number", "grid.slotSpacing");

  bagToggleBtn:SetSize(slotWidth, slotHeight);
  bagToggleBtn:ClearAllPoints();
  bagToggleBtn = gui:ReskinIcon(bagToggleBtn, 2, "button");
  tk:KillElement(bagToggleBtn:GetNormalTexture());
  bagToggleBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp");
  bagToggleBtn:SetScript("OnLeave", tk.HandleTooltipOnLeave);

  bagToggleBtn.Count = _G[bagBtnName.."Count"];
  bagToggleBtn.Count:SetPoint("BOTTOMRIGHT", bagToggleBtn, "BOTTOMRIGHT", -2, 2);
  bagToggleBtn.Count:Show();

  bagToggleBtn:SetScript("OnEvent", HandleBagUpdateDelayedEvent);
  bagToggleBtn:SetScript("OnShow", BagToggleButtonOnShow);
  bagToggleBtn:SetScript("OnHide", BagToggleButtonOnHide);

  if (isBackpack) then
    tk:SetBasicTooltip(bagToggleBtn, _G["BACKPACK_TOOLTIP"], "ANCHOR_LEFT");
    bagToggleBtn:SetScript("OnClick", _G["BackpackButton_OnClick"]);
    bagToggleBtn:SetGridColor(1, 1, 1);
    bagToggleBtn.icon:SetTexture("Interface\\Buttons\\Button-Backpack-Up");

  elseif (isKeyring and _G["KeyRingButton"]) then
    tk:SetBasicTooltip(bagToggleBtn, _G["KEYRING"], "ANCHOR_LEFT");
    local onClickScript = _G["KeyRingButton"]:GetScript("OnClick");
    bagToggleBtn:SetScript("OnClick", onClickScript);
    bagToggleBtn:SetGridColor(1, 1, 1);
    bagToggleBtn.icon:SetTexture("Interface\\ContainerFrame\\KeyRing-Bag-Icon");

  elseif (bagFrame.bagIndex > 0 or bagFrame.bagIndex == Enum.BagIndex.ReagentBag) then
    local equipmentSlotIndex = ContainerIDToInventoryID(bagFrame.bagIndex);
    bagToggleBtn:SetID(equipmentSlotIndex); -- required for dragging
    Mixin(bagToggleBtn, Item:CreateFromEquipmentSlot(equipmentSlotIndex));
    bagToggleBtn:RegisterForDrag("LeftButton");

    local btnMixin = _G["BaseBagSlotButtonMixin"];
    if (btnMixin) then
      Mixin(bagToggleBtn, btnMixin);

      if (isReagentBag) then
        bagToggleBtn.commandName = "TOGGLEREAGENTBAG1";
      else
        bagToggleBtn.commandName = "TOGGLEBAG"..tostring(bagFrame.bagIndex);
      end

      bagToggleBtn:SetScript("OnEnter", btnMixin.BagSlotOnEnter);
      bagToggleBtn:SetScript("OnClick", btnMixin.BagSlotOnClick);
      bagToggleBtn:SetScript("OnDragStart", btnMixin.BagSlotOnDragStart);
      bagToggleBtn:SetScript("OnReceiveDrag", btnMixin.BagSlotOnReceiveDrag);
    else
      bagToggleBtn:SetScript("OnEnter", _G["BagSlotButton_OnEnter"]);
      bagToggleBtn:SetScript("OnClick", _G["BagSlotButton_OnClick"]);
      bagToggleBtn:SetScript("OnDragStart", _G["BagSlotButton_OnDrag"]);
      bagToggleBtn:SetScript("OnReceiveDrag", _G["BagSlotButton_OnClick"]);
    end
  end

  bagToggleBtn:SetPoint("TOPLEFT", (slotWidth + slotSpacing) * xOffset, 0);
  bagToggleBtn:HookScript("OnEnter", HighlightBagSlots);
  bagToggleBtn:HookScript("OnLeave", ClearBagSlotHighlights);
  bagToggleBtn:HookScript("OnClick", function()
    local isOpen = not bagFrame:IsShown();
    bagFrame:SetShown(isOpen);
    ClearBagSlotHighlights();
    UpdateInventoryFrameCoreProperties(bagBar:GetParent(), true);

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
    local numBagSlots, freeBagSlots;

    if (inventoryFrame.character) then
      numBagSlots = #bag.slots;
      freeBagSlots = 0;

      for _, slot in ipairs(bag.slots) do
        if (slot:IsItemEmpty()) then
          freeBagSlots = freeBagSlots + 1;
        end
      end
    else
      numBagSlots = GetContainerNumSlots(bag.bagIndex) or 0;
      freeBagSlots = GetContainerNumFreeSlots(bag.bagIndex) or 0;
    end

    totalFreeSlots = totalFreeSlots + freeBagSlots;
    totalNumSlots = totalNumSlots + numBagSlots;

    if (bagToggleBtn) then
      if (numBagSlots == 0) then
        bagToggleBtn.Count:SetText("");
      else
        local bagPercent = (freeBagSlots / numBagSlots) * 100;
        local r, g, b = tk:GetProgressColor(bagPercent, 100);

        local bagTakenSlotsText = tostring(numBagSlots - freeBagSlots);
        bagTakenSlotsText = tk.Strings:SetTextColorByRGB(bagTakenSlotsText, r, g, b);
        bagToggleBtn.Count:SetText(bagTakenSlotsText);
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
    UpdateBagSlot(slot);
  end

  UpdateFreeSlots(bag.inventoryFrame);
end

local function UpdateAllBags()
  local inventoryFrame = _G["MUI_Inventory"]--[[@as MayronUI.Inventory.Frame]];

  for _, bag in ipairs(inventoryFrame.bags) do
    UpdateAllBagSlots(bag);
  end
end


local function ToggleDetailedView(self)
  local inventoryFrame = self:GetParent()--[[@as MayronUI.Inventory.Frame]];
  SetDetailedViewEnabled(inventoryFrame, not inventoryFrame.detailedView);
  UpdateInventoryFrameCoreProperties(inventoryFrame, false);

  for _, bag in ipairs(inventoryFrame.bags) do
    for _, slot in ipairs(bag.slots) do
      UpdateBagSlot(slot);
    end
  end
end

---@param info table
---@param inventoryFrame MayronUI.Inventory.Frame
local function SetCharacterInventory(info, inventoryFrame)
  local selectedCharacter = info.value--[[@as string]];

  if (inventoryFrame.character == selectedCharacter) then
    return
  end

  local db = OrbitusDB:GetDatabase("MUI_InventoryDB");
  local currentCharacterName = db.character:GetCurrentCharacterInfo();

  if (currentCharacterName == selectedCharacter) then
    inventoryFrame.character = nil;
    inventoryFrame.titleBar.text:SetText("Inventory");
    inventoryFrame.sortBtn:Enable();
  else
    inventoryFrame.character = selectedCharacter;
    inventoryFrame.titleBar.text:SetText(selectedCharacter);
    inventoryFrame.sortBtn:Disable();
  end

  inventoryFrame.detailedView = false; -- this is required to get the item names to hide
  local money;

  if (inventoryFrame.character) then
    local itemsEncoded = db.character:QueryTypeByCharacter("string", selectedCharacter, "items");
    local items = db.utilities:Decode(itemsEncoded);

    for b, bagInfo in ipairs(items) do
      local bag = inventoryFrame.bags[b];
      local bagButton = inventoryFrame.bagBar.buttons[b];
      local isBackpack = bag.bagIndex == BagIndexes.Backpack;
      local isKeyring = bag.bagIndex == BagIndexes.Keyring;
      local isReagentBag = bag.bagIndex == BagIndexes.ReagentBag;

      local shown = not (isKeyring or isReagentBag);
      bag:SetShown(shown);

      if (not (isBackpack or isKeyring)) then
        bagButton:SetItemID(bagInfo.bagItemID);
      end

      for s, slotInfo in ipairs(bagInfo) do
        if (not bag.slots[s]) then
          bag.slots[s] = CreateBagSlot(bag, s);
        end

        local slot = bag.slots[s];
        slot:Clear();
        slot:Show();

        if (type(slotInfo) == "table") then
          local slotItemID, countText = unpack(slotInfo);
          slot:SetItemID(slotItemID);
          slot.Count:SetText(countText);
          slot.Count:Show();
        end
      end

      for s = (#bagInfo + 1), #bag.slots do
        -- Hide slots the other character does not have
        local unavailableSlot = bag.slots[s];
        unavailableSlot:Clear();
        unavailableSlot:Hide();
      end

      HandleBagUpdateDelayedEvent(bagButton);
    end

    for _, bag in ipairs(inventoryFrame.bags) do
      if (not bag.savedEventHandlers) then
        for _, slot in ipairs(bag.slots) do
          if (not slot.preview) then
            local slotName = slot:GetName();
            slot.preview = tk:CreateFrame("Frame", inventoryFrame, slotName.."Preview");
            slot.preview.slot = slot;
            slot.preview:SetFrameStrata(tk.Constants.FRAME_STRATAS.DIALOG);
            slot.preview:EnableMouse(true);
            slot.preview:SetScript("OnEnter", HandleBagSlotOnEnter);
            slot.preview:SetScript("OnLeave", HandleBagPreviewSlotOnLeave);
          end

          slot.preview:SetAllPoints(slot);
          slot.preview:Show();
        end

        bag.savedEventHandlers = true;
      end

      UpdateAllBagSlots(bag);
    end

    money = db.character:QueryTypeByCharacter("number", selectedCharacter, "money");
  else
    for b, bag in ipairs(inventoryFrame.bags) do
      local bagButton = inventoryFrame.bagBar.buttons[b];
      local isBackpack = bag.bagIndex == BagIndexes.Backpack;
      local isKeyring = bag.bagIndex == BagIndexes.Keyring;
      local isReagentBag = bag.bagIndex == BagIndexes.ReagentBag;

      local shown = not (isKeyring or isReagentBag);
      bag:SetShown(shown);

      if (not (isBackpack or isKeyring)) then
        local equipmentSlotIndex = bagButton:GetID();
        local location = ItemLocation:CreateFromEquipmentSlot(equipmentSlotIndex);
        bagButton:SetItemLocation(location);
      end

      for slotIndex, slot in ipairs(bag.slots) do
        slot:SetItemLocation(ItemLocation:CreateFromBagAndSlot(bag.bagIndex, slotIndex));
        slot:Show();

        if (slot.preview) then
          slot.preview:SetAllPoints(tk.Constants.DUMMY_FRAME);
          slot.preview:Hide();
        end
      end

      bag.savedEventHandlers = nil;

      local totalSlots = GetContainerNumSlots(bag.bagIndex);
      for s = totalSlots + 1, #bag.slots do
        -- Hide slots the currently logged in character does not have
        local unavailableSlot = bag.slots[s];
        unavailableSlot:Clear();
        unavailableSlot:Hide();

        if (unavailableSlot.preview) then
          unavailableSlot.preview:SetAllPoints(tk.Constants.DUMMY_FRAME);
          unavailableSlot.preview:Hide();
        end
      end

      UpdateAllBagSlots(bag);
      HandleBagUpdateDelayedEvent(bagButton);
    end

    money = GetMoney();
  end

  local moneyText = tk.Strings:GetFormattedMoney(money);
  inventoryFrame.money:SetText(moneyText);
  SetDetailedViewEnabled(inventoryFrame, false);
  UpdateInventoryFrameCoreProperties(inventoryFrame, true);
end

local function ToggleCharactersMenu(self)
  if (not self.menuList) then
    self.menuFrame = tk:CreateFrame("Frame", self, "$parentMenu", "UIDropDownMenuTemplate");
    self.menuFrame:Hide();
    self.menuList = {};

    local inventoryFrame = self:GetParent();
    local db = OrbitusDB:GetDatabase("MUI_InventoryDB");
    local characterNames = db.character:GetAllCharacters();
    local current, currentClassFileName  = db.character:GetCurrentCharacterInfo();

    table.insert(self.menuList, {
      text = tk.Strings:SetTextColorByClassFileName(current, currentClassFileName);
      value = current;
      arg1 = inventoryFrame;
      notCheckable = true;
      func = SetCharacterInventory;
    });

    for _, characterName in ipairs(characterNames) do
      if (characterName ~= current) then
        local classFileName = db.character:GetCharacterInfo(characterName);
        local text = tk.Strings:SetTextColorByClassFileName(characterName, classFileName);

        table.insert(self.menuList, {
          text = text;
          value = characterName;
          arg1 = inventoryFrame;
          notCheckable = true;
          func = SetCharacterInventory;
        });
      end
    end

    self.menuFrame:SetPoint("BOTTOM");
  end

  for i = 1, 2 do
    local dropdownList = _G["DropDownList"..i];
    if (dropdownList and dropdownList.dropdown == self.menuFrame) then
      if (dropdownList:IsShown()) then
        dropdownList:Hide();
        return
      end
    end
  end

  EasyMenu(self.menuList, self.menuFrame, self.menuFrame, 0, 0, "MENU", 1);
end

---@param bags MayronUI.Inventory.BagFrame[]
local function UpdateSearchOverlays(bags)
  for _, bag in ipairs(bags) do
    for slotIndex, slot in ipairs(bag.slots) do
      if (slot:IsItemEmpty()) then
        ClearBagSlot(slot);
      elseif (slot:HasItemLocation()) then
        local info = GetContainerItemInfo(bag.bagIndex, slotIndex);

        if (obj:IsTable(info)) then
          slot.searchOverlay:SetShown(info.isFiltered);
        else
          local isFiltered = select(8, GetContainerItemInfo(bag.bagIndex, slotIndex));
          slot.searchOverlay:SetShown(isFiltered);
        end
      else
        local itemName = slot:GetItemName();
        local setVisibility;

        if (itemName and #itemName > 0) then
          local searchQuery = bag.inventoryFrame.searchBox:GetText();

          if (searchQuery and #searchQuery > 0) then
            local isFiltered = itemName:lower():find(searchQuery:lower()) == nil;
            slot.searchOverlay:SetShown(isFiltered);
            setVisibility = true;
          end
        end

        if (not setVisibility) then
          slot.searchOverlay:Hide();
        end
      end
    end
  end
end

---@param inventoryFrame MayronUI.Inventory.Frame
---@param event string
---@param bagIndex number?
---@param slotIndex number?
local function InventoryFrameOnEvent(inventoryFrame, event, bagIndex, slotIndex)
	if (event == "INVENTORY_SEARCH_UPDATE") then
    UpdateSearchOverlays(inventoryFrame.bags);
    return
  end

  if (inventoryFrame.character) then return end

  if (event == "BAG_UPDATE" or event == "PLAYER_MONEY") then
    local currentTime = GetTime();
    local shouldStore = not inventoryFrame.lastStored or currentTime - inventoryFrame.lastStored > 10;

    if (shouldStore) then
      inventoryFrame.lastStored = currentTime;

      local items = {};
      for b, bag in ipairs(inventoryFrame.bags) do
        local isBackpack = bag.bagIndex == BagIndexes.Backpack;
        local isKeyring = bag.bagIndex == BagIndexes.Keyring;
        local isReagentBag = bag.bagIndex == BagIndexes.ReagentBag;
        local bagButton = inventoryFrame.bagBar.buttons[b];

        local bagInfo = {};

        if (isBackpack) then
          bagInfo.bagItemID = BagIndexes.Backpack;
        elseif (isKeyring) then
          bagInfo.bagItemID = BagIndexes.Keyring;
        elseif (isReagentBag) then
          bagInfo.bagItemID = BagIndexes.ReagentBag;
        else
          bagInfo.bagItemID = bagButton:GetItemID();
        end

        for s, slot in ipairs(bag.slots) do
          local itemID = slot:GetItemID();

          if (itemID == nil) then
            bagInfo[s] = "_";
          else
            local countText = GetBagSlotItemCountText(slot);
            bagInfo[s] = { itemID, countText };
          end
        end

        items[b] = bagInfo;
      end

      local db = OrbitusDB:GetDatabase("MUI_InventoryDB");
      local itemsData = db.utilities:Encode(items);
      db.character:Store("items", itemsData);
      db.character:Store("money", GetMoney());
    end
  end

  local bagFrame;

  if (type(bagIndex) == "number") then
    for _, bag in ipairs(inventoryFrame.bags) do
      if (bag:GetID() == bagIndex) then
        bagFrame = bag;
        break
      end
    end
  end

  -- MayronUI:LogInfo("Event: %s (has bag?: %s) with bagIndex %s and slotIndex %s.", event, obj:IsTable(bagFrame), bagIndex, slotIndex);

  -- Retail Only
  if (event == "UNIT_INVENTORY_CHANGED" or event == "PLAYER_SPECIALIZATION_CHANGED") then
    if (tk:IsRetail() and obj:IsFunction(IsContainerItemAnUpgrade)) then
      for _, b in ipairs(inventoryFrame.bags) do
        for s, slot in ipairs(b.slots) do
          local itemIsUpgrade = IsContainerItemAnUpgrade(b.bagIndex, s);
          slot.UpgradeIcon:SetShown(itemIsUpgrade);
        end
      end
    end

    return
  end

  if (event == "BAG_UPDATE_COOLDOWN") then
    for _, b in ipairs(inventoryFrame.bags) do
      for _, slot in ipairs(b.slots) do
        UpdateBagSlotCooldown(b, slot);
      end
    end

    return
  end

	if (event == "BAG_UPDATE") then
    if (bagFrame) then
      UpdateAllBagSlots(bagFrame);
    end

    return
  end

	if (event == "ITEM_LOCK_CHANGED") then
    if (bagFrame and type(slotIndex) == "number" and slotIndex > 0) then
      local slot = bagFrame.slots[slotIndex];

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
    if (bagFrame) then
		  UpdateAllBagSlots(bagFrame);
    end
    return
  end

	if (event == "QUEST_ACCEPTED" or event == "UNIT_QUEST_LOG_CHANGED") then
    if (event == "UNIT_QUEST_LOG_CHANGED") then
      local unitID = bagIndex --[[@as UnitId]]
      if (unitID ~= "player") then return end
    end

		if (bagFrame and bagFrame:IsShown()) then
			UpdateAllBagSlots(bagFrame);
		end

    return
  end

  if (event == "PLAYER_MONEY") then
    local money = GetMoney();
    local moneyText = tk.Strings:GetFormattedMoney(money);
    inventoryFrame.money:SetText(moneyText);
    return
	end

  if (event == "BAG_CONTAINER_UPDATE") then
    for _, bagToggleBtn in ipairs(inventoryFrame.bagBar.buttons) do
      local isActive = GetBagName(bagToggleBtn.bagIndex) ~= nil;

      if (isActive) then
        CreateBagSlots(bagToggleBtn.bagFrame);
        bagToggleBtn.bagFrame:Show();
      else
        bagToggleBtn.bagFrame:Hide();
      end
    end

    UpdateInventoryFrameCoreProperties(inventoryFrame, true);
    return
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
        local _, _, _, totalRows, totalColumns = UpdateInventorySlotCoreProperties(self, false);
        local db = OrbitusDB:GetDatabase("MUI_InventoryDB");
        local settingName = self.detailedView and "detailed" or "grid";

        if (totalRows ~= nil) then
          db.character:Store(settingName..".rows.initial", totalRows);
        end

        if (totalColumns ~= nil) then
          db.character:Store(settingName..".columns.initial", totalColumns);
        end
      end
    end
  end
end

---@param inventoryFrame MayronUI.Inventory.Frame
local function CreateSearchBox(inventoryFrame)
  --Searchbox
	local searchBox = tk:CreateFrame("EditBox", inventoryFrame, "MUI_InventorySearch");
	searchBox:SetPoint("LEFT", inventoryFrame.freeSlots, "RIGHT", 12, 0);
	searchBox:SetPoint("RIGHT", inventoryFrame.dragger, "LEFT", -12, 0);
	searchBox:SetPoint("BOTTOM", 0, 4);
  inventoryFrame.searchBox = searchBox;

	searchBox:SetAutoFocus(false);
	searchBox:SetHeight(24);
	searchBox:SetMaxLetters(50);
	searchBox:SetTextInsets(26, 22, 0, 1);
	searchBox:SetFontObject("GameFontHighlight");

	local bg = searchBox:CreateTexture(nil, "BACKGROUND");
	bg:SetTexture(tk:GetAssetFilePath("Textures\\searchbox"));
	bg:SetAllPoints();
  tk:ApplyThemeColor(bg);

	local searchIcon = searchBox:CreateTexture(nil, "OVERLAY");
	searchIcon:SetPoint("LEFT", searchBox, "LEFT", 6, 1);
	searchIcon:SetSize(14, 14);
	searchIcon:SetTexture("Interface\\Common\\UI-Searchbox-Icon");
	searchIcon:SetTexCoord(0, 0.8215, 0, 0.8125); -- for some reason there's a 3px white space to the right and bottom
	searchIcon:SetVertexColor(0.6, 0.6, 0.6);

	local clearBtn = tk:CreateFrame("Button", searchBox);
	clearBtn:SetPoint("RIGHT", searchBox, "RIGHT", -4, 1);
	clearBtn:SetSize(20, 18);
	clearBtn:SetShown(false);
	clearBtn:SetNormalTexture("Interface\\FriendsFrame\\ClearBroadcastIcon");
	clearBtn:SetHighlightTexture("Interface\\FriendsFrame\\ClearBroadcastIcon", "ADD");

	searchBox:SetScript("OnEscapePressed", function()
    searchBox:ClearFocus();
  end);

	searchBox:SetScript("OnEnterPressed", searchBox.ClearFocus);

	searchBox:SetScript("OnEditFocusLost", function(self)
		if (self:GetText() == "") then
			searchIcon:SetVertexColor(0.6, 0.6, 0.6);
			clearBtn:Hide();
		end
	end);

	searchBox:SetScript("OnEditFocusGained", function()
		searchIcon:SetVertexColor(1.0, 1.0, 1.0);
		clearBtn:Show();
	end);

	searchBox:SetScript("OnTextChanged", function(self)
    SetItemSearch(self:GetText());
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

---@param self MayronUI.Icon|Button
local function ToggleBagsBar(self)
  local inventoryFrame = self:GetParent()--[[@as MayronUI.Inventory.Frame]]
  local bagsFrameShown = not inventoryFrame.bagBar:IsShown();
  inventoryFrame.bagBar:SetShown(bagsFrameShown);

  if (bagsFrameShown) then
    local db = OrbitusDB:GetDatabase("MUI_InventoryDB");
    local slotHeight = db.profile:QueryType("number", "grid.height");
    local slotSpacing = db.profile:QueryType("number", "grid.slotSpacing");
    containerPadding.top = originalTopPadding + slotHeight + slotSpacing + containerPadding.left;
  else
    containerPadding.top = originalTopPadding;
  end

  inventoryFrame.bagsContainer:SetPoint("TOPLEFT", containerPadding.left, -containerPadding.top);
  UpdateInventoryFrameCoreProperties(inventoryFrame, false);
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
    local totalSlots = GetContainerNumSlots(bag.bagIndex);

    for s = 1, totalSlots do
      local slot = bag.slots[s];

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

            if (not showSlot) then
              local questTexture = GetBagSlotQuestItemTexture(slot);
              showSlot = questTexture ~= nil;
            end
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

  UpdateInventoryFrameCoreProperties(inventoryFrame, true);
end

local function SetPadding(customPadding)
  containerPadding.top = containerVerticalPadding + customPadding;
  containerPadding.right = customPadding;
  containerPadding.bottom = containerVerticalPadding + customPadding;
  containerPadding.left = customPadding;
  originalTopPadding = containerPadding.top;

  local inventoryFrame = _G["MUI_Inventory"]--[[@as MayronUI.Inventory.Frame]];
  inventoryFrame.bagBar:SetPoint("TOPLEFT", containerPadding.left, -containerPadding.top);
  inventoryFrame.bagsContainer:SetPoint("TOPLEFT", containerPadding.left, -containerPadding.top);
  inventoryFrame.bagsContainer:SetPoint("BOTTOMRIGHT", -containerPadding.right, containerPadding.bottom);
end

---@param settings table?
local function CreateOrUpdateTabBar(settings)
  local inventoryFrame = _G["MUI_Inventory"]--[[@as MayronUI.Inventory.Frame]];
  local db = OrbitusDB:GetDatabase("MUI_InventoryDB");
  local showTabBar;

  if (type(settings) == "table") then
    showTabBar = settings.show;
  else
    showTabBar = db.profile:QueryType("boolean", "container.tabBar.show");
  end

  if (not inventoryFrame.tabs and not showTabBar) then
    return
  end

  if (not showTabBar) then
    for _, tab in ipairs(inventoryFrame.tabs) do
      tab:Hide();
    end

    return
  end

  local position, direction, xOffset, yOffset, spacing, scale, showEquipment, showConsumables, showTradeGoods, showQuestItems;

  if (type(settings) == "table") then
    position = settings.position;
    direction = settings.direction;
    xOffset = settings.xOffset;
    yOffset = settings.yOffset;
    spacing = settings.spacing;
    scale = settings.scale;
    showEquipment = settings.showEquipment;
    showConsumables = settings.showConsumables;
    showTradeGoods = settings.showTradeGoods;
    showQuestItems = settings.showQuestItems;
  else
    position = db.profile:QueryType("string", "container.tabBar.position");
    direction = db.profile:QueryType("string", "container.tabBar.direction");
    xOffset = db.profile:QueryType("number", "container.tabBar.xOffset");
    yOffset = db.profile:QueryType("number", "container.tabBar.yOffset");
    spacing = db.profile:QueryType("number", "container.tabBar.spacing");
    scale = db.profile:QueryType("number", "container.tabBar.scale");
    showEquipment = db.profile:QueryType("boolean", "container.tabBar.showEquipment");
    showConsumables = db.profile:QueryType("boolean", "container.tabBar.showConsumables");
    showTradeGoods =  db.profile:QueryType("boolean", "container.tabBar.showTradeGoods");
    showQuestItems = db.profile:QueryType("boolean", "container.tabBar.showQuestItems");
  end

  local createTabs = inventoryFrame.tabs == nil;

  if (createTabs) then
    inventoryFrame.tabs = {};
  end

  local previousTab;

  for i = 1, 5 do
    local tabEnabled = (i == 1) or
      (i == 2 and showEquipment) or
      (i == 3 and showConsumables) or
      (i == 4 and showTradeGoods) or
      (i == 5 and showQuestItems);

    local tab = inventoryFrame.tabs[i];

    if (tabEnabled or tab) then
      if (not tab) then
        tab = gui:CreateIcon(
          2, 34, 30, inventoryFrame, "check-button", nil, nil,
          "MUI_InventoryTab"..tostring(i))--[[@as CheckButton|MayronUI.Icon]];

        tab:HookScript("OnEnter", HandleTabOnEnter);
        tab:HookScript("OnLeave", HandleTabOnLeave);
        tab:SetScript("OnClick", HandleTabOnClick);
        inventoryFrame.tabs[i] = tab;
      end

      tab:SetShown(tabEnabled);
      tab:ClearAllPoints();

      if (tabEnabled) then
        if (scale <= 0) then
          scale = 0.1;
        end

        tab:SetScale(scale);

        if (not previousTab) then
          if (position == "TOP") then
            if (direction == "RIGHT") then
              tab:SetPoint("BOTTOMLEFT", inventoryFrame, "TOPLEFT", xOffset, yOffset);
            else
              tab:SetPoint("BOTTOMRIGHT", inventoryFrame, "TOPRIGHT", xOffset, yOffset);
            end
          elseif (position == "RIGHT") then
            if (direction == "DOWN") then
              tab:SetPoint("TOPLEFT", inventoryFrame, "TOPRIGHT", xOffset, yOffset);
            else
              tab:SetPoint("BOTTOMLEFT", inventoryFrame, "BOTTOMRIGHT", xOffset, yOffset);
            end
          elseif (position == "BOTTOM") then
            if (direction == "RIGHT") then
              tab:SetPoint("TOPLEFT", inventoryFrame, "BOTTOMLEFT", xOffset, yOffset);
            else
              tab:SetPoint("TOPRIGHT", inventoryFrame, "BOTTOMRIGHT", xOffset, yOffset);
            end
          elseif (position == "LEFT") then
            if (direction == "DOWN") then
              tab:SetPoint("TOPRIGHT", inventoryFrame, "TOPLEFT", xOffset, yOffset);
            else
              tab:SetPoint("BOTTOMRIGHT", inventoryFrame, "BOTTOMLEFT", xOffset, yOffset);
            end
          end

          if (createTabs) then
            tab:SetChecked(true);
            tab.icon:SetTexture("Interface\\Icons\\Inv_misc_bag_07");
            tab.tooltipText = L["All Items"];
            tab:SetID(TabTypesEnum.AllItems);
          end
        else
          if (direction == "DOWN") then
            tab:SetPoint("TOPLEFT", previousTab, "BOTTOMLEFT", 0, -spacing);
          elseif (direction == "UP") then
            tab:SetPoint("BOTTOMLEFT", previousTab, "TOPLEFT", 0, spacing);
          elseif (direction == "RIGHT") then
            tab:SetPoint("TOPLEFT", previousTab, "TOPRIGHT", spacing, 0);
          elseif (direction == "LEFT") then
            tab:SetPoint("TOPRIGHT", previousTab, "TOPLEFT", -spacing, 0);
          end

          if (createTabs) then
            tab:SetChecked(false);

            if (i == 2) then
              tab.icon:SetTexture("Interface\\Icons\\INV_Helmet_20");
              tab.tooltipText = L["Equipment"];
              tab:SetID(TabTypesEnum.Equipment);
            elseif (i == 3) then
              tab.icon:SetTexture("Interface\\Icons\\INV_Potion_51");
              tab.tooltipText = L["Consumables"];
              tab.icon:SetSize(28, 24);
              tab:SetID(TabTypesEnum.Consumables);
            elseif (i == 4) then
              tab.icon:SetTexture("Interface\\Icons\\INV_Fabric_Linen_01");
              tab.tooltipText = L["Trade Goods"];
              tab:SetID(TabTypesEnum.TradeGoods);
            elseif (i == 5) then
              tab.icon:SetTexture("Interface\\QuestFrame\\UI-QuestLog-BookIcon");
              tab.icon:SetSize(28, 24);
              tab.tooltipText = L["Quest Items"];
              tab:SetID(TabTypesEnum.QuestItems);
              tab.background:SetVertexColor(0, 0, 0, 1);
            end
          end
        end

        HandleTabOnLeave(tab);
        previousTab = tab;
      end
    end
  end

  if (createTabs) then
    tk:GroupCheckButtons(inventoryFrame.tabs, false);

    inventoryFrame.sortBtn:HookScript("OnClick", function()
      local tab1 = inventoryFrame.tabs[1];
      local onTabClick = tab1:GetScript("OnClick");
      onTabClick(tab1);
    end);
  elseif (showTabBar) then
    local tab1 = inventoryFrame.tabs[1];
    local onTabClick = tab1:GetScript("OnClick");
    onTabClick(tab1);
  end
end

local function UpdateBagBarSize()
  local inventoryFrame = _G["MUI_Inventory"]--[[@as MayronUI.Inventory.Frame]];
  local db = OrbitusDB:GetDatabase("MUI_InventoryDB");
  local bagBar = inventoryFrame.bagBar;

  local iconSpacing = db.profile:QueryType("number", "grid.slotSpacing");
  local iconWidth = db.profile:QueryType("number", "grid.widths.initial");
  local iconHeight = db.profile:QueryType("number", "grid.height");
  bagBar:SetSize(TOTAL_BAG_FRAMES * (iconWidth + iconSpacing) - iconSpacing, iconHeight);
end

-- C_Inventory ------------------
function C_InventoryModule:OnInitialize()
  OrbitusDB:Register(addOnName, databaseConfig, function (db)
    MayronUI:AddComponent("MUI_InventoryDB", db);
    local isEnabled = db.global:QueryType("boolean", "enabled");

    if (not isEnabled) then
      return
    end

    local inventoryFrame = tk:CreateFrame("Frame", nil, "MUI_Inventory")--[[@as MayronUI.Inventory.Frame]];
    table.insert(_G["UISpecialFrames"], "MUI_Inventory");
    inventoryFrame:EnableMouse(true);
    inventoryFrame:Hide();

    tk:HookFunc("ToggleAllBags", function()
      if (inventoryFrame:IsShown()) then
        PlaySound(SoundKit.IG_BACKPACK_CLOSE);
        inventoryFrame:Hide();
      else
        PlaySound(SoundKit.IG_BACKPACK_OPEN);
        inventoryFrame:Show();
      end
    end);

    gui:AddDialogTexture(inventoryFrame, "High");
    inventoryFrame:SetFrameStrata(tk.Constants.FRAME_STRATAS.HIGH);
    gui:AddTitleBar(inventoryFrame, L["Inventory"]);
    gui:AddCloseButton(inventoryFrame);
    gui:AddResizer(inventoryFrame);
    inventoryFrame.bags = {};

    local colorScheme = db.profile:QueryType("string", "container.colorScheme");
    ApplyColorScheme(colorScheme);

    -- self = inventoryFrame:
    inventoryFrame:RegisterEvent("BAG_UPDATE_COOLDOWN");
    inventoryFrame:RegisterEvent("BAG_UPDATE");
    inventoryFrame:RegisterEvent("ITEM_LOCK_CHANGED");
    inventoryFrame:RegisterEvent("BAG_NEW_ITEMS_UPDATED");
    inventoryFrame:RegisterEvent("PLAYER_MONEY");
    inventoryFrame:RegisterEvent("INVENTORY_SEARCH_UPDATE");

    -- Wrath Only --------------:
    inventoryFrame:RegisterEvent("QUEST_ACCEPTED");
    inventoryFrame:RegisterEvent("UNIT_QUEST_LOG_CHANGED"); -- and arg1 == "player", then also do the same as QUEST_ACCEPTED
    ----------------------------

    -- Retail:
    if (tk:IsRetail()) then
      inventoryFrame:RegisterEvent("UNIT_INVENTORY_CHANGED");
      inventoryFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
      tk:KillElement(_G["ContainerFrameCombinedBags"]);
    end

    local bagBar = tk:CreateFrame("Frame", inventoryFrame, "MUI_InventoryBagsFrame")--[[@as MayronUI.Inventory.BagBar]];
    inventoryFrame.bagBar = bagBar;

    UpdateBagBarSize();
    bagBar:SetScript("OnShow", BagBarOnShow);
    bagBar:Hide();
    bagBar.buttons = {};

    local scrollChild = tk:CreateFrame("Frame", inventoryFrame, "MUI_InventoryBagsContainer");
    local bagsContainer, scrollBar = gui:WrapInScrollFrame(scrollChild);

    inventoryFrame.scrollChild = scrollChild;
    inventoryFrame.scrollBar = scrollBar;
    inventoryFrame.bagsContainer = bagsContainer;

    for i = 1, TOTAL_BAG_FRAMES do
      local blizzBag = _G["ContainerFrame"..i];
      blizzBag:HookScript("OnShow", function() blizzBag:Hide() end);
    end

    -- Create Bags and Slots:
    for i = 0, (TOTAL_BAG_FRAMES - 1) do
      local bagIndex, bagGlobalName;

      if (i == (TOTAL_BAG_FRAMES - 1)) then
        if (tk:IsRetail()) then
          -- reagent:
          bagIndex = BagIndexes.ReagentBag;
          bagGlobalName = "MUI_InventoryReagentBag";
        else
          -- keyring:
          bagIndex = BagIndexes.Keyring;
          bagGlobalName = "MUI_InventoryKeyring";
        end
      elseif (i == 0) then
        -- backpack:
        bagIndex = BagIndexes.Backpack;
        bagGlobalName = "MUI_InventoryBackpack";
      else
        bagIndex =  BagIndexes["Bag_"..i];
        bagGlobalName = "MUI_InventoryBag"..i;
      end

      local bagFrame = tk:CreateFrame("Frame", inventoryFrame.scrollChild--[[@as Frame]], bagGlobalName)--[[@as MayronUI.Inventory.BagFrame]];
      bagFrame.inventoryFrame = inventoryFrame;
      table.insert(inventoryFrame.bags, bagFrame);

      bagFrame:SetPoint("TOPLEFT");
      bagFrame:SetPoint("TOPRIGHT");
      bagFrame:SetHeight(1);

      if (bagIndex == BagIndexes.Keyring or bagIndex == BagIndexes.ReagentBag) then
        bagFrame:Hide();
      end

      bagFrame:SetID(bagIndex); -- Required for dragging
      bagFrame.slots = {};
      bagFrame.bagIndex = bagIndex;

      local bagToggleBtn = CreateBagToggleButton(db, bagBar, bagFrame, i);
      table.insert(bagBar.buttons, bagToggleBtn);
      CreateBagSlots(bagFrame);
    end

    local blocker = tk:CreateFrame("Frame", bagsContainer);
    blocker:SetAllPoints(true);
    blocker:EnableMouse(true);
    blocker:SetFrameStrata("DIALOG");
    blocker:SetFrameLevel(20);
    blocker:Hide();

    inventoryFrame.titleBar.onDragStart = function()
      blocker:Show();
    end

    inventoryFrame.titleBar.onDragStop = function()
      local xOffset, yOffset = RepositionInventoryFrame(inventoryFrame);
      db.global:Store("xOffset", xOffset);
      db.global:Store("yOffset", yOffset);
      blocker:Hide();
    end

    inventoryFrame.dragger:HookScript("OnDragStart", function()
      blocker:Show();
      inventoryFrame.bagsContainer.animating = not inventoryFrame.detailedView;
      inventoryFrame:SetScript("OnUpdate", InventoryFrameOnUpdate);
    end);

    inventoryFrame.dragger:HookScript("OnDragStop", function()
      inventoryFrame:SetScript("OnUpdate", nil);
      inventoryFrame.bagsContainer.animating = nil;
      local _, height = UpdateInventoryFrameCoreProperties(inventoryFrame, false);
      inventoryFrame.titleBar.onDragStop();
      blocker:Hide();

      if (inventoryFrame.detailedView and not inventoryFrame.scrollBar:IsShown()) then
        inventoryFrame:SetHeight(height);
      end
    end);

    inventoryFrame.money = inventoryFrame:CreateFontString("MUI_InventoryMoney", "ARTWORK", "MUI_FontNormal");
    inventoryFrame.money:SetPoint("BOTTOMLEFT", 8, 8);
    inventoryFrame.money:SetJustifyH("LEFT");

    inventoryFrame.freeSlots = inventoryFrame:CreateFontString("MUI_InventorySlots", "ARTWORK", "MUI_FontNormal");
    inventoryFrame.freeSlots:SetPoint("BOTTOMLEFT", inventoryFrame.money, "BOTTOMRIGHT", 12, 0);
    inventoryFrame.freeSlots:SetJustifyH("LEFT");

    inventoryFrame.sortBtn = gui:CreateIconButton("sort", inventoryFrame, "MUI_InventorySort");
    inventoryFrame.sortBtn:SetPoint("RIGHT", inventoryFrame.closeBtn, "LEFT", -4, 0);
    tk:SetBasicTooltip(inventoryFrame.sortBtn, L["Sort Bags"]);
    inventoryFrame.sortBtn:SetScript("OnClick", _G["SortBags"]);

    inventoryFrame.sortBtn:RegisterEvent("PLAYER_REGEN_DISABLED");
    inventoryFrame.sortBtn:RegisterEvent("PLAYER_REGEN_ENABLED");

    inventoryFrame.sortBtn:SetScript("OnEvent", function(_, event)
      inventoryFrame.sortBtn:SetEnabled(event == "PLAYER_REGEN_ENABLED");
    end);

    inventoryFrame.bagsBtn = gui:CreateIconButton("bag", inventoryFrame, "MUI_InventoryBags");
    inventoryFrame.bagsBtn:SetPoint("RIGHT", inventoryFrame.sortBtn, "LEFT", -4, 0);
    tk:SetBasicTooltip(inventoryFrame.bagsBtn, L["Toggle Bags Bar"]);
    inventoryFrame.bagsBtn:SetScript("OnClick", ToggleBagsBar);

    inventoryFrame.viewBtn = gui:CreateIconButton("layout", inventoryFrame, "MUI_InventoryView");
    inventoryFrame.viewBtn:SetPoint("RIGHT", inventoryFrame.bagsBtn, "LEFT", -4, 0);
    tk:SetBasicTooltip(inventoryFrame.viewBtn, L["Switch to Detailed View"]);
    inventoryFrame.viewBtn:SetScript("OnClick", ToggleDetailedView);

    inventoryFrame.charactersBtn = gui:CreateIconButton("user", inventoryFrame, "MUI_InventoryCharacters");
    inventoryFrame.charactersBtn:SetPoint("RIGHT", inventoryFrame.viewBtn, "LEFT", -4, 0);
    tk:SetBasicTooltip(inventoryFrame.charactersBtn, L["View Character Inventory"]);
    inventoryFrame.charactersBtn:SetScript("OnClick", ToggleCharactersMenu);

    inventoryFrame.selectedTabID = TabTypesEnum.AllItems;

    CreateOrUpdateTabBar();
    CreateSearchBox(inventoryFrame);

    InventoryFrameOnEvent(inventoryFrame, "PLAYER_MONEY");
    UpdateFreeSlots(inventoryFrame);
    inventoryFrame:SetScript("OnEvent", InventoryFrameOnEvent);

    SetDetailedViewEnabled(inventoryFrame, false);
    local customPadding = db.profile:QueryType("number", "container.padding");
    SetPadding(customPadding);

    inventoryFrame:SetScript("OnShow", UpdateInventoryFrameCoreProperties);

    local function OnScrollBarVisibilityChange()
      if (inventoryFrame.detailedView) then
        UpdateInventoryFrameCoreProperties(inventoryFrame, false);
      end
    end

    inventoryFrame.scrollBar:HookScript("OnHide", OnScrollBarVisibilityChange);
    inventoryFrame.scrollBar:HookScript("OnShow", OnScrollBarVisibilityChange);

    local bagnonFrames = tk.Tables:GetValueOrNil(_G["Bagnon"], "Frames")--[[@as table]];
    local bagnonInventorySettings = tk.Tables:GetValueOrNil(_G["Bagnon"], "profile", "inventory")--[[@as table]];

    if (IsAddOnLoaded("Bagnon") and
      obj:IsTable(bagnonFrames) and
      bagnonFrames:IsEnabled("inventory") and
      obj:IsTable(bagnonInventorySettings)) then
        bagnonInventorySettings.enabled = false;
    end

    do
      local xOffset = db.global:QueryType("number?", "xOffset");
      local yOffset = db.global:QueryType("number?", "yOffset");

      if (type(xOffset) == "number" and type(yOffset) == "number") then
        inventoryFrame:SetPoint("TOPLEFT", _G.UIParent, "BOTTOMLEFT", xOffset, yOffset);
      else
        local initialXOffset = (GetScreenWidth() / 2) - (inventoryFrame:GetWidth() / 2);
        local initialYOffset = (GetScreenHeight() / 2) + (inventoryFrame:GetHeight() / 2);
        inventoryFrame:SetPoint("TOPLEFT", _G.UIParent, "BOTTOMLEFT", initialXOffset, initialYOffset);
      end
    end
  end);
end

function C_InventoryModule:RegisterObservers(_, db)
  local inventoryFrame = _G["MUI_Inventory"]--[[@as MayronUI.Inventory.Frame]];

  db.profile:Subscribe("container.colorScheme", ApplyColorScheme);

  db.profile:Subscribe("container.customColor", function()
    ApplyColorScheme("Custom");
  end);

  db.profile:Subscribe("container.padding", function(padding)
    SetPadding(padding);
    UpdateInventoryFrameCoreProperties(inventoryFrame, false);
  end);

  db.profile:Subscribe("container.tabBar", CreateOrUpdateTabBar);

  local function UpdateSlotDimensions()
    SetDetailedViewEnabled(inventoryFrame, inventoryFrame.detailedView);
    UpdateInventoryFrameCoreProperties(inventoryFrame, false);
  end

  db.profile:Subscribe("grid.widths.initial", UpdateSlotDimensions);
  db.profile:Subscribe("grid.height", UpdateSlotDimensions);
  db.profile:Subscribe("grid.slotSpacing", UpdateSlotDimensions);
  db.profile:Subscribe("grid.showItemLevels", UpdateAllBags);
  db.profile:Subscribe("detailed.widths.min", UpdateSlotDimensions);
  db.profile:Subscribe("detailed.widths.max", UpdateSlotDimensions);
  db.profile:Subscribe("detailed.height", UpdateSlotDimensions);
  db.profile:Subscribe("detailed.slotSpacing", UpdateSlotDimensions);
  db.profile:Subscribe("detailed.showItemName", UpdateAllBags);
  db.profile:Subscribe("detailed.itemNameFontSize", UpdateAllBags);
  db.profile:Subscribe("detailed.showItemLevels", UpdateAllBags);
  db.profile:Subscribe("detailed.showItemType", UpdateAllBags);
  db.profile:Subscribe("detailed.itemDescriptionFontSize", UpdateAllBags);
end