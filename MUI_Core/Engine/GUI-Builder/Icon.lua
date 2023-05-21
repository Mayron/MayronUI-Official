-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk = MayronUI:GetCoreComponents();

---@class GUIBuilder
local gui = MayronUI:GetComponent("GUIBuilder");

---@alias MayronUI.IconType "item"|"spell"|"aura"|"button"|"check-button"

---@class MayronUI.Icon : MayronUI.GridTextureMixin, Frame
---@field mask Texture
---@field gloss Texture
---@field cooldown Cooldown
---@field background Texture
---@field icon Texture
---@field itemID number?
---@field iconType MayronUI.IconType?


local function HandleAuraRightClick(_, button)
  if (button == "RightButton") then
    tk.HandleTooltipOnLeave();
  end
end

---Creates an icon in the style of MayronUI without applying user config settings
---@generic T
---@param iconFrame T # If provided, no new iconFrame is created
---@param borderSize number
---@param iconType MayronUI.IconType?
---@param disableOmniCC boolean?
---@return T|MayronUI.Icon # The icon frame
local function CreateIcon(iconFrame, borderSize, iconType, disableOmniCC)
  iconFrame = iconFrame--[[@as MayronUI.Icon|Frame]];
  iconFrame.iconType = iconType;
  iconFrame.background = tk:SetBackground(iconFrame, 0, 0, 0, 0.4);

  local borderTexturePath = tk:GetAssetFilePath("Textures\\Widgets\\IconBorder");
  iconFrame = gui:CreateGridTexture(iconFrame, borderTexturePath, 4, 2, 64, 64, "OVERLAY");

  local maskTexturePath = tk:GetAssetFilePath("Textures\\black");
  iconFrame.mask = iconFrame:CreateMaskTexture() --[[@as Texture]];
  iconFrame.mask:SetTexture(maskTexturePath, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE");
  iconFrame.mask:SetPoint("TOPLEFT");
  iconFrame.mask:SetPoint("BOTTOMRIGHT", 0, 2);

  local glossTexturePath = tk:GetAssetFilePath("Textures\\Widgets\\Gloss");
  iconFrame.gloss = iconFrame:CreateTexture(nil, "OVERLAY");
  iconFrame.gloss:SetAlpha(0.4);
  iconFrame.gloss:SetTexture(glossTexturePath);
  iconFrame.gloss:SetPoint("TOPLEFT", borderSize, -borderSize);
  iconFrame.gloss:SetPoint("BOTTOMRIGHT", -borderSize, borderSize);

  if (iconFrame.cooldown) then
    iconFrame.cooldown:SetReverse(1);
    iconFrame.cooldown:SetHideCountdownNumbers(true);
    iconFrame.cooldown:SetPoint("TOPLEFT", borderSize, -borderSize);
    iconFrame.cooldown:SetPoint("BOTTOMRIGHT", -borderSize, borderSize);

    iconFrame.cooldown:SetFrameStrata(tk.Constants.FRAME_STRATAS.HIGH);
    iconFrame.cooldown.noCooldownCount = disableOmniCC; -- disable OmniCC
  end

  iconFrame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9);

  local iconWidth, iconHeight = iconFrame:GetSize();
  local diff = math.abs(iconWidth - iconHeight);

  if (diff > 5) then
    diff = diff * 0.25; -- squish the texture by only 25%

    if (iconWidth > iconHeight) then
      iconHeight = math.max(iconWidth - diff, iconHeight);
    else
      iconWidth = math.max(iconHeight - diff, iconWidth);
    end
  end

  iconFrame.icon:SetPoint("CENTER");
  iconFrame.icon:SetSize(iconWidth, iconHeight);
  iconFrame.icon:AddMaskTexture(iconFrame.mask);

  -- Scripts:
  if (iconType) then
    local container = iconFrame;

    if (iconType == "aura") then
      -- aura's have a secure frame that handles things such as right-click to dismiss
      container = iconFrame:GetParent();
      container.iconType = iconType;
      container:HookScript("OnClick", HandleAuraRightClick);
    end

    container:HookScript("OnEnter", tk.HandleTooltipOnEnter);
    container:HookScript("OnLeave", tk.HandleTooltipOnLeave);
  end

  return iconFrame;
end

---@generic T
---@param iconFrame T
---@param borderSize number
---@param iconType MayronUI.IconType?
---@param iconTexture Texture?
---@param disableOmniCC boolean?
---@return T|MayronUI.Icon # The icon frame
function gui:ReskinIcon(iconFrame, borderSize, iconType, iconTexture, disableOmniCC)
  iconFrame = iconFrame--[[@as Frame]];
  local width, height = iconFrame:GetSize();

  if (width == 0) then
    iconFrame:SetWidth(30);
  end

  if (height == 0) then
    iconFrame:SetHeight(30);
  end

  iconFrame.icon = iconFrame.Icon or iconFrame.icon or iconTexture;
  iconFrame.icon:SetDrawLayer("ARTWORK");

  if (iconFrame.cooldown) then
    iconFrame.cooldown:SetParent(iconFrame);
    iconFrame.cooldown:ClearAllPoints();
  elseif (not iconType or not iconType:find("button")) then
    iconFrame.cooldown = tk:CreateFrame("Cooldown", iconFrame, nil, "CooldownFrameTemplate");
  end

  return CreateIcon(iconFrame, borderSize, iconType, disableOmniCC);
end

---Creates an icon in the style of MayronUI without applying user config settings
---@param borderSize number
---@param iconWidth number
---@param iconHeight number
---@param parent Frame
---@param iconType MayronUI.IconType
---@param texture string? # Will not use `icon:SetTexture(texture)` if nil
---@param disableOmniCC boolean?
---@param globalName string?
---@return MayronUI.Icon # The icon frame
function gui:CreateIcon(borderSize, iconWidth, iconHeight, parent, iconType, texture, disableOmniCC, globalName)
  local widgetType;

  if (iconType == "button") then
    widgetType = "Button";
  elseif (iconType == "check-button") then
    widgetType = "CheckButton";
  end

  local iconFrame = tk:CreateBackdropFrame(widgetType, parent, globalName) --[[@as MayronUI.Icon]];
  iconFrame:SetSize(iconWidth, iconHeight);
  iconFrame:SetPoint("TOPLEFT");

  iconFrame.icon = iconFrame:CreateTexture(nil, "ARTWORK");

  if (texture) then
    iconFrame.icon:SetTexture(texture);
  end

  if (not iconType:find("button")) then
    iconFrame.cooldown = tk:CreateFrame("Cooldown", iconFrame, nil, "CooldownFrameTemplate");
  end

  return CreateIcon(iconFrame, borderSize, iconType, disableOmniCC);
end