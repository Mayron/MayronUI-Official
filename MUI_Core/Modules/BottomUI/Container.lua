-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local C_PetBattles = _G.C_PetBattles;
local CreateFrame, UIParent = _G.CreateFrame, _G.UIParent;

-- Register and Import Modules -----------
local C_Container = MayronUI:RegisterModule("BottomUI_Container", L["Unit Frame Panels"]);
-- Add Database Defaults -----------------

db:AddToDefaults("profile.bottomui", {
  width = 750;
  enabled = true;
  frameStrata = "LOW";
});

-- C_Container ------------------

function C_Container:OnInitialize(data)
  if (not MayronUI:IsInstalled()) then return end

  self:RegisterUpdateFunctions(db.profile.bottomui, {
    width = function(value)
      data.container:SetSize(value, 1);

      local dataTextModule = MayronUI:ImportModule("DataTextModule");

      if (dataTextModule and dataTextModule:IsEnabled()) then
        dataTextModule:PositionDataTextButtons();
      end
    end
  });
end

function C_Container:OnInitialized(data)
  if (data.settings.enabled) then
    self:SetEnabled(true);
  end
end

function C_Container:OnEnable(data)
  if (not data.container) then
    data.container = CreateFrame("Frame", "MUI_BottomContainer", UIParent);
    data.container:SetPoint("BOTTOM", 0, -1);
    data.container:SetFrameStrata(data.settings.frameStrata);

    if (tk:IsRetail()) then
      local listener = em:CreateEventListener(function()
        data.container:Show();
      end);

      listener:RegisterEvent("PET_BATTLE_OVER");

      listener = em:CreateEventListener(function()
        data.container:Hide();
      end);

      listener:RegisterEvent("PET_BATTLE_OPENING_START");

      if (C_PetBattles.IsInBattle()) then
        data.container:Hide();
      end
    end
  end

  if (not data.subModules) then
    data.subModules = obj:PopTable();

    data.subModules.ResourceBars = MayronUI:ImportModule("ResourceBars");
    data.subModules.ActionBarPanel = MayronUI:ImportModule("ActionBarPanel");
    data.subModules.UnitPanels = MayronUI:ImportModule("UnitPanels");

    data.subModules.ResourceBars:Initialize(self, data.subModules);
    data.subModules.ActionBarPanel:Initialize(self, data.subModules);
    data.subModules.UnitPanels:Initialize(self, data.subModules);
  end

  self:RepositionContent();
end

function C_Container:RepositionContent(data)
  local dataTextModule = MayronUI:ImportModule("DataTextModule");
  local actionBarPanel;
  local anchorFrame = data.container;

  if (dataTextModule and dataTextModule:IsEnabled()) then
    anchorFrame = _G.MUI_DataTextBar;
  end

  if (data.subModules.ResourceBars and data.subModules.ResourceBars:IsEnabled()) then
    local resourceContainer = data:GetFriendData(data.subModules.ResourceBars).barsContainer;

    -- position resourceContainer:
    resourceContainer:ClearAllPoints();
    resourceContainer:SetPoint("BOTTOMLEFT", anchorFrame, "TOPLEFT", 0, -1);
    resourceContainer:SetPoint("BOTTOMRIGHT", anchorFrame, "TOPRIGHT", 0, -1);
    anchorFrame = resourceContainer;
  end

  if (data.subModules.ActionBarPanel and data.subModules.ActionBarPanel:IsEnabled()) then
    actionBarPanel = _G["MUI_ActionBarPanel"];

    -- position actionBarPanel:
    actionBarPanel:ClearAllPoints();
    actionBarPanel:SetPoint("BOTTOMLEFT", anchorFrame, "TOPLEFT", 0, -1);
    actionBarPanel:SetPoint("BOTTOMRIGHT", anchorFrame, "TOPRIGHT", 0, -1);
    anchorFrame = actionBarPanel;
  end

  if (data.subModules.UnitPanels and data.subModules.UnitPanels:IsEnabled()) then
    local unitHeight = db.profile.unitPanels.unitHeight;
    local leftUnitPanel = _G["MUI_UnitPanelLeft"];
    local rightUnitPanel = _G["MUI_UnitPanelRight"];

    -- position unit panels:
    leftUnitPanel:ClearAllPoints();
    rightUnitPanel:ClearAllPoints();
    leftUnitPanel:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", 0, unitHeight);
    rightUnitPanel:SetPoint("TOPRIGHT", anchorFrame, "TOPRIGHT", 0, unitHeight);
  end

  -- Update Bartender Bars
  if (actionBarPanel) then
    data.subModules.ActionBarPanel:SetUpAllBartenderBars();
  end
end