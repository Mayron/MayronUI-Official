-- luacheck: ignore self 143 631
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

---@class ChatNew : BaseModule
local C_ChatNew = MayronUI:RegisterModule("ChatNew");


function C_ChatNew:OnInitialize(data)
  print("loading")
  local frame = CreateFrame("Frame", nil, UIParent);
  frame:SetSize(60, 60);
  frame:SetPoint("CENTER");

  local orbInner = frame:CreateTexture(nil, "OVERLAY");
  orbInner:SetAllPoints(true);
  orbInner:SetTexture(tk:GetAssetFilePath("Textures\\Chat\\orb-inner"));
  orbInner:SetBlendMode("ADD");
  orbInner:SetAlpha(0.5)

  -- local orbBorder = frame:CreateTexture(nil, "OVERLAY", 1);
  -- orbBorder:SetAllPoints(true);
  -- orbBorder:SetTexture(tk:GetAssetFilePath("Textures\\Chat\\orb-border"));

  local orbBorder = frame:CreateTexture(nil, "ARTWORK");
  orbBorder:SetAllPoints(true);
  orbBorder:SetTexture(tk:GetAssetFilePath("Textures\\Chat\\orb-only-border"));

  local orbLines = frame:CreateTexture(nil, "OVERLAY");
  orbLines:SetAllPoints(true);
  orbLines:SetTexture(tk:GetAssetFilePath("Textures\\Chat\\orb-lines"));

  tk:ApplyThemeColor(orbLines);

  local icon = frame:CreateTexture(nil, "BACKGROUND");

  -- get macro texture:
  -- local macroIcons = GetMacroIcons();
  -- local selectedIcon = macroIcons[1];

  -- if(type(selectedIcon) == "number") then
	-- 	icon:SetTexture(selectedIcon);
	-- else
	-- 	icon:SetTexture("INTERFACE\\ICONS\\"..selectedIcon);
  -- end

  icon:SetTexture(tk:GetAssetFilePath("Textures\\Chat\\orb-healer"));
  icon:SetAllPoints(true);

  -- only needed for custom macro texture:
  -- local mask = frame:CreateMaskTexture(nil, "OVERLAY");
  -- mask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask");
  -- mask:SetPoint("TOPLEFT", 6, -6);
  -- mask:SetPoint("BOTTOMRIGHT", -6, 6);

  -- icon:SetTexCoord(0.1, 0.9, 0.1, 0.9);
  -- icon:SetPoint("TOPLEFT", 6, -6);
  -- icon:SetPoint("BOTTOMRIGHT", -6, 6);
  -- icon:AddMaskTexture(mask);

  print("loaded")
end