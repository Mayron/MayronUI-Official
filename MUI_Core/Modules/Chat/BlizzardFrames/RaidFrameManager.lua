-- luacheck: ignore MayronUI self 143
-- Setup namespaces ------------------
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, gui = MayronUI:GetCoreComponents();

local _, C_ChatModule = MayronUI:ImportModule("ChatModule");
local CompactRaidFrameManager, GetNumGroupMembers = _G.CompactRaidFrameManager, _G.GetNumGroupMembers;
local IsAddOnLoaded = _G.IsAddOnLoaded;
local radians = _G.math.rad;
--------------------------------------
local function OnArrowButtonEvent(self)
  if (not IsAddOnLoaded("Blizzard_CompactRaidFrames")) then
    return
  end

  local inGroup = GetNumGroupMembers() > 0;
  self:SetShown(inGroup);
end

local function OnArrowButtonClick(self)
  -- toggle compact raid frame manager
  if (self.displayFrame:IsVisible()) then
    self.displayFrame:Hide();
    self.icon:SetRotation(radians(-90));
  else
    self.displayFrame:Show();
    self.icon:SetRotation(radians(90));
  end

  self.displayFrame:SetWidth(CompactRaidFrameManager:GetWidth());
  self.displayFrame:SetHeight(CompactRaidFrameManager:GetHeight());
end

local function OnArrowButtonEnter(self)
  local r, g, b = self.icon:GetVertexColor();
  self.icon:SetVertexColor(r * 1.2, g * 1.2, b * 1.2);

  if (self.showOnMouseOver) then
    self:SetAlpha(1);
  end
end

local function OnArrowButtonLeave(self)
  tk:ApplyThemeColor(self.icon);
  if (self.showOnMouseOver) then
    self:SetAlpha(0);
  end
end

function C_ChatModule:SetUpRaidFrameManager(data)
  -- Hide Blizzard Compact Manager:
  -- CompactRaidFrameManager:DisableDrawLayer("ARTWORK");
  -- CompactRaidFrameManager:EnableMouse(false);
  -- tk:KillElement(CompactRaidFrameManager.toggleButton);

  tk:KillAllElements(
    _G.CompactRaidFrameManagerDisplayFrameHeaderDelineator,
    _G.CompactRaidFrameManagerDisplayFrameFilterOptionsFooterDelineator,
    _G.CompactRaidFrameManagerDisplayFrameHeaderBackground);

  -- button to toggle compact raid frame manager
  local btn = tk:CreateFrame("Button", nil, "MUI_RaidFrameManagerButton");

  btn:SetSize(15, 100);
  btn:SetPoint("LEFT");
  btn:SetNormalTexture(tk:GetAssetFilePath("Textures\\SideBar\\SideButton"));
  btn:GetNormalTexture():SetTexCoord(1, 0, 0, 1);

  btn.icon = btn:CreateTexture(nil, "OVERLAY");
  btn.icon:SetSize(12, 8);
  btn.icon:SetPoint("CENTER");
  btn.icon:SetTexture(tk:GetAssetFilePath("Icons\\arrow"));
  btn.icon:SetRotation(radians(-90));
  tk:ApplyThemeColor(btn.icon);

  btn:RegisterEvent("ADDON_LOADED");
  btn:RegisterEvent("GROUP_ROSTER_UPDATE");
  btn:RegisterEvent("PLAYER_ENTERING_WORLD");

  btn:SetScript("OnClick", OnArrowButtonClick);
  btn:SetScript("OnEvent", OnArrowButtonEvent);
  btn:SetScript("OnEnter", OnArrowButtonEnter);
  btn:SetScript("OnLeave", OnArrowButtonLeave);

  btn.displayFrame = CompactRaidFrameManager.displayFrame;
  btn.displayFrame:SetParent(btn);
  btn.displayFrame:ClearAllPoints();
  btn.displayFrame:SetPoint("TOPLEFT", btn, "TOPRIGHT", 5, 0);

  gui:CreateDialogBox(nil, nil, btn.displayFrame);
  tk:MakeMovable(btn.displayFrame);

  OnArrowButtonEvent(btn);
  data.raidFrameManager = true;
end