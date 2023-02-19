-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local GetContainerNumSlots = _G.GetContainerNumSlots;
local GetContainerItemID = _G.GetContainerItemID;

if (_G.C_Container) then
  GetContainerNumSlots = _G.C_Container.GetContainerNumSlots
  GetContainerItemID = _G.C_Container.GetContainerItemID
end

-- Register and Import Modules -----------
local C_Inventory = MayronUI:RegisterModule("Inventory", "Inventory");

-- Add Database Defaults -----------------

-- db:AddToDefaults("profile.alerts", {
--   width = 750;
--   enabled = true;
--   frameStrata = "LOW";
--   frameLevel = 5;
--   xOffset = 0;
--   yOffset = -1;
-- });


-- Local Functions --------------

local function CreateInventoryButton(itemID)
  local button = tk:CreateFrame("Button", nil, nil, "ActionButtonTemplate");
  button:SetAttribute("item", "item:"..itemID);
  return button;
end


-- C_Inventory ------------------

function C_Inventory:OnInitialize(data)
  if (not (tk:IsWrathClassic() and MayronUI.DEBUG_MODE)) then
    return
  end

  local inventoryFrame = tk:CreateFrame("Frame", nil, "MUI_Inventory");
  data.frame = inventoryFrame;

  local buttonIndex = 1;

  for bag = 0, 4 do
    local numSlots = GetContainerNumSlots(bag);

    if (numSlots > 0) then
      for slot = 1, numSlots do
        local itemID = GetContainerItemID(bag, slot);

        if itemID then
          local button = CreateInventoryButton(itemID);
          button:SetPoint("TOPLEFT", inventoryFrame, "TOPLEFT", (buttonIndex - 1) * 40, 0);
          buttonIndex = buttonIndex + 1;
        end
      end
    end
  end

  -- _G.Mixin(alertsFrame, AlertsFrameMixin);
end