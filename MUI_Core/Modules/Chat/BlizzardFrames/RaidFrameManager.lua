-- luacheck: ignore MayronUI self 143
-- Setup namespaces ------------------
local MayronUI = _G.MayronUI;
local tk, _, _, gui = MayronUI:GetCoreComponents();

local _, C_ChatModule = MayronUI:ImportModule("ChatModule");
local CompactRaidFrameManager, GetNumGroupMembers = _G.CompactRaidFrameManager, _G.GetNumGroupMembers;
local IsAddOnLoaded, CreateFrame = _G.IsAddOnLoaded, _G.CreateFrame;
--------------------------------------
local function ToggleButton_OnEvent(self)
  if (not IsAddOnLoaded("Blizzard_CompactRaidFrames")) then
    return;
  end

  if (GetNumGroupMembers() > 0) then
    self:Show();
  else
    self:Hide();
  end
end

local function ToggleButton_OnClick(self)
  local compactFrame = CompactRaidFrameManager.displayFrame;

  -- toggle compact raid frame manager
  if (compactFrame:IsVisible()) then
    compactFrame:Hide();
    self:SetText(">");
  else
    compactFrame:Show();
    self:SetText("<");
  end

  compactFrame:SetWidth(CompactRaidFrameManager:GetWidth());
  compactFrame:SetHeight(CompactRaidFrameManager:GetHeight());
end

local function CreateToggleButton()
  local btn = CreateFrame("Button", nil, _G.UIParent);
  btn:SetSize(14, 120);
  btn:SetPoint("LEFT", _G.UIParent, "LEFT");
  btn:SetNormalTexture(tk:GetAssetFilePath("Textures\\SideBar\\SideButton"));
  btn:SetNormalFontObject("MUI_FontSmall");
  btn:SetHighlightFontObject("GameFontHighlightSmall");
  btn:SetText(">");
  btn:GetNormalTexture():SetTexCoord(1, 0, 0, 1);
  btn:SetWidth(16);

  btn:RegisterEvent("ADDON_LOADED");
  btn:RegisterEvent("GROUP_ROSTER_UPDATE");
  btn:RegisterEvent("PLAYER_ENTERING_WORLD");

  btn:SetScript("OnClick", ToggleButton_OnClick);
  btn:SetScript("OnEvent", ToggleButton_OnEvent);

  return btn;
end

function C_ChatModule:SetUpRaidFrameManager(data)
  -- Hide Blizzard Compact Manager:
  CompactRaidFrameManager:DisableDrawLayer("ARTWORK");
  CompactRaidFrameManager:EnableMouse(false);
  tk:KillElement(CompactRaidFrameManager.toggleButton);
  _G.CompactRaidFrameManagerDisplayFrameHeaderDelineator:SetTexture("");
  _G.CompactRaidFrameManagerDisplayFrameFilterOptionsFooterDelineator:SetTexture("");
  _G.CompactRaidFrameManagerDisplayFrameHeaderBackground:Hide();

  _G.CompactRaidFrameManagerDisplayFrameHeaderDelineator.SetTexture = tk.Constants.DUMMY_FUNC;
  _G.CompactRaidFrameManagerDisplayFrameFilterOptionsFooterDelineator.SetTexture = tk.Constants.DUMMY_FUNC;
  _G.CompactRaidFrameManagerDisplayFrameHeaderBackground.Show = tk.Constants.DUMMY_FUNC;

  -- button to toggle compact raid frame manager
  local btn = CreateToggleButton();

  local compactFrame = CompactRaidFrameManager.displayFrame;
  compactFrame:SetParent(btn);
  compactFrame:ClearAllPoints();
  compactFrame:SetPoint("TOPLEFT", btn, "TOPRIGHT", 5, 0);

  gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, nil, compactFrame);
  tk:MakeMovable(compactFrame);

  ToggleButton_OnEvent(btn);
  data.raidFrameManager = true;
end