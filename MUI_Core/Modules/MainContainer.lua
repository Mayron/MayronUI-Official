-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local C_PetBattles = _G.C_PetBattles;

-- Register and Import Modules -----------
local C_Container = MayronUI:RegisterModule("MainContainer", L["Unit Frame Panels"]);

-- Add Database Defaults -----------------

db:AddToDefaults("profile.bottomui", {
  width = 750;
  enabled = true;
  frameStrata = "LOW";
  frameLevel = 5;
  xOffset = 0;
  yOffset = -1;
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
    end;
    frameLevel = function(value)
      data.container:SetFrameLevel(value);
    end;
    frameStrata = function(value)
      data.container:SetFrameStrata(value);
    end;
    yOffset = function(value)
      data.container:SetPoint("BOTTOM", data.settings.xOffset, value);
    end;
    xOffset = function(value)
      data.container:SetPoint("BOTTOM", value, data.settings.yOffset);
    end;
  });
end

function C_Container:OnInitialized(data)
  if (data.settings.enabled) then
    self:SetEnabled(true);
  end
end

function C_Container:OnEnable(data)
  if (not data.container) then
    data.container = tk:CreateFrame("Frame", nil, "MUI_BottomContainer");
    data.container:SetPoint("BOTTOM", data.settings.xOffset, data.settings.yOffset);
    data.container:SetFrameStrata(data.settings.frameStrata);
    data.container:SetFrameLevel(data.settings.frameLevel);
    tk:HideInPetBattles(data.container);
  end

  if (not data.subModules) then
    data.subModules = obj:PopTable();

    data.subModules.ResourceBars = MayronUI:ImportModule("ResourceBars");
    data.subModules.ActionBarPanel = MayronUI:ImportModule("BottomActionBars");
    data.subModules.UnitPanels = MayronUI:ImportModule("UnitPanels");

    data.subModules.ResourceBars:Initialize(self, data.subModules);
    data.subModules.ActionBarPanel:Initialize(self, data.subModules);
    data.subModules.UnitPanels:Initialize(self, data.subModules);
  end

  self:RepositionContent();
end

function C_Container:RepositionContent(data)
  local dataTextModule = MayronUI:ImportModule("DataTextModule");
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

  local actionBarsModule = data.subModules.ActionBarPanel; ---@type BottomActionBarsModule

  if (actionBarsModule and actionBarsModule:IsEnabled()) then
    local actionBarPanel = actionBarsModule:GetPanel();

    actionBarPanel:ClearAllPoints();
    actionBarPanel:SetPoint("BOTTOMLEFT", anchorFrame, "TOPLEFT", 0, -1);
    actionBarPanel:SetPoint("BOTTOMRIGHT", anchorFrame, "TOPRIGHT", 0, -1);

    local startPoint = actionBarPanel:GetBottom();
    data.subModules.ActionBarPanel:SetUpExpandRetract(startPoint);
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
end