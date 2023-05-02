-- luacheck: ignore self
local _G = _G;
local MayronUI = _G.MayronUI; ---@type MayronUI

---@class Toolkit
local tk, db, _, _, obj = MayronUI:GetCoreComponents();

local ipairs, hooksecurefunc, CreateFrame, select = _G.ipairs, _G.hooksecurefunc, _G.CreateFrame, _G.select;
local CreateColor = _G.CreateColor;
local GameTooltip = _G.GameTooltip;

------------------------------------------------
--> Tooltip Functions
------------------------------------------------
function tk.HandleTooltipOnLeave()
  GameTooltip:Hide();
end

do
  ---@param widget Frame|table
  ---@param defaultAnchorPoint TooltipAnchor?
  ---@param defaultXOffset number?
  ---@param defaultYOffset number?
  local function SetTooltipOwner(widget, defaultAnchorPoint, defaultXOffset, defaultYOffset)
    local anchor = defaultAnchorPoint or "ANCHOR_BOTTOMLEFT";
    local xOffset = defaultXOffset or 0;
    local yOffset = defaultYOffset or 2;

    if (obj:IsTable(widget.tooltipAnchor)) then
      anchor = widget.tooltipAnchor.point or anchor;
      xOffset = widget.tooltipAnchor.xOffset or xOffset;
      yOffset = widget.tooltipAnchor.yOffset or yOffset;
    elseif (obj:IsString(widget.tooltipAnchor)) then
      anchor = widget.tooltipAnchor;
    end

    GameTooltip:SetOwner(widget, anchor, xOffset, yOffset);
  end

  ---@param widget Frame|table
  function tk.HandleTooltipOnEnter(widget)
    SetTooltipOwner(widget, "ANCHOR_BOTTOMLEFT");

    if (widget.cooldown) then
      GameTooltip:SetFrameLevel(widget.cooldown:GetFrameLevel() + 10);
    end

    local itemId = widget.itemID or widget:GetID();

    if (widget.iconType == "item") then
      GameTooltip:SetInventoryItem("player", itemId);
    elseif (widget.iconType == "aura") then

      if (widget.auraSubType == "item") then
        GameTooltip:SetInventoryItem("player", itemId);
      else
        GameTooltip:SetUnitAura("player", itemId, widget.filter);
      end

    elseif (widget.iconType == "spell") then
      GameTooltip:SetSpellByID(itemId);

    elseif (widget.tooltipText) then
      GameTooltip:AddLine(widget.tooltipText, 1, 1, 1, true);

    elseif (widget.lines) then
      for _, line in ipairs(widget.lines) do
        if (line.text) then
          GameTooltip:AddLine(line.text);

        elseif (line.leftText and line.rightText) then
          local r, g, b = tk:GetThemeColor();
          GameTooltip:AddDoubleLine(line.leftText, line.rightText, r, g, b, 1, 1, 1);
        end
      end
    end

    GameTooltip:Show();
  end
end

-- Configures a widget to show a basic text tooltip on mouseover.
---@param widget Frame|table
---@param text string # The tooltip text to display
---@param point TooltipAnchor? # Default is "ANCHOR_BOTTOMLEFT"
---@param xOffset number? # Default is 0
---@param yOffset number? # Default is 2
function tk:SetBasicTooltip(widget, text, point, xOffset, yOffset)
  widget.tooltipText = text;

  if (xOffset or yOffset) then
    -- Defaults will be applied in the `SetTooltipOwner` function
    widget.tooltipAnchor = obj:PopTable();
    widget.tooltipAnchor.point = point;
    widget.tooltipAnchor.xOffset = xOffset;
    widget.tooltipAnchor.yOffset = yOffset;
  else
    widget.tooltipAnchor = point;
  end

  widget:HookScript("OnEnter", tk.HandleTooltipOnEnter);
  widget:HookScript("OnLeave", tk.HandleTooltipOnLeave);
end

------------------------------------------------
--> Frame Moving and Resizing Functions
------------------------------------------------

function tk:SetFullWidth(frame, rightPadding, percent)
  rightPadding = rightPadding or 0;
  percent = (percent or 100) / 100;

  local parent = frame:GetParent();

  if (not parent) then
    hooksecurefunc(frame, "SetParent", function()
      tk:SetFullWidth(frame, rightPadding, percent);
    end);
  else
    parent:HookScript("OnSizeChanged", function(_, width)
      frame:SetWidth((width * percent) - rightPadding);
    end);

    local parentWidth = parent:GetWidth();
    frame:SetWidth((parentWidth * percent) - rightPadding);
  end
end

do
  local function Dragger_OnDragStart(self)
    if (self.frame:IsMovable()) then
      self.frame:StartMoving();

      if (obj:IsFunction(self.onDragStart)) then
        self.onDragStart(self.frame, self.frame:GetPoint());
      end
    end
  end

  local function Dragger_OnDragStop(self)
    if (self.frame:IsMovable()) then
      self.frame:StopMovingOrSizing();

      if (obj:IsFunction(self.onDragStop)) then
        self.onDragStop(self.frame, self.frame:GetPoint());
      end
    end
  end

  function tk:MakeMovable(frame, dragger, movable, onDragStart, onDragStop)
    if (movable == nil) then
      movable = true;
    end

    dragger = dragger or frame;
    dragger.frame = frame;

    dragger:EnableMouse(movable);
    dragger:RegisterForDrag("LeftButton");
    frame:SetMovable(movable);
    frame:SetClampedToScreen(true);

    dragger.onDragStart = onDragStart;
    dragger.onDragStop = onDragStop;

    if (not dragger.hookedDragScripts) then
      dragger:HookScript("OnDragStart", Dragger_OnDragStart);
      dragger:HookScript("OnDragStop", Dragger_OnDragStop);
      dragger.hookedDragScripts = true;
    end
  end
end

function tk:MakeResizable(frame, dragger)
  dragger = dragger or frame;
  frame:SetResizable(true);
  dragger:RegisterForDrag("LeftButton");

  dragger:HookScript("OnDragStart", function()
    frame:StartSizing();
  end);

  dragger:HookScript("OnDragStop", function()
    frame:StopMovingOrSizing();
  end);
end

---@param frame Frame
function tk:SetResizeBounds(frame, minWidth, minHeight, maxWidth, maxHeight)
  if (obj:IsFunction(frame.SetMinResize)) then
    frame:SetMinResize(minWidth, minHeight);
    frame:SetMaxResize(maxWidth, maxHeight);
  else
    -- dragonflight:
    ---@diagnostic disable-next-line: undefined-field
    frame:SetResizeBounds(minWidth, minHeight, maxWidth, maxHeight);
  end
end

function tk:GetResizeBounds(frame)
  if (obj:IsFunction(frame.GetMinResize)) then
    local minWidth, minHeight = frame:GetMinResize();
    local maxWidth, maxHeight = frame:GetMaxResize();
    return minWidth, minHeight, maxWidth, maxHeight;
  else
    -- dragonflight:
    ---@diagnostic disable-next-line: undefined-field
    return frame:GetResizeBounds();
  end
end

------------------------------------------------
--> Frame Texture Functions
------------------------------------------------

function tk:FlipTexture(texture, direction)
  direction = direction:trim():upper();

  if (direction == "VERTICAL") then
    texture:SetTexCoord(0, 1, 1, 0);
  elseif (direction == "HORIZONTAL") then
    texture:SetTexCoord(1, 0, 0, 1);
  end
end

function tk:ClipTexture(texture, sideName, amount)
  sideName = sideName:trim():upper();

  local left, right, top, bottom = texture:GetTexCoord();

  if (sideName == "LEFT") then
    texture:SetTexCoord(amount, right, top, bottom);

  elseif (sideName == "RIGHT") then
    texture:SetTexCoord(left, 1 - amount, top, bottom);

  elseif (sideName == "TOP") then
    texture:SetTexCoord(left, right, amount, bottom);

  elseif (sideName == "BOTTOM") then
    texture:SetTexCoord(left, right, top, 1 - amount);
  end
end

function tk:KillElement(element)
  if (not element) then
    return
  end

  element.Show = element.Hide;
  self:AttachToDummy(element);
end

function tk:AttachToDummy(element)
  element:Hide();
  element:SetParent(tk.Constants.DUMMY_FRAME);
  element:SetAllPoints(true);

  if (element.UnregisterAllEvents) then
    element:UnregisterAllEvents();
  end

  if (element:GetObjectType() == "Texture") then
    element:SetTexture(tk.Strings.Empty);
    element.SetTexture = tk.Constants.DUMMY_FUNC;
  end
end

function tk:KillAllElements(...)
  for _, element in obj:IterateArgs(...) do
    self:KillElement(element);
  end
end

function tk:HideFrameElements(frame, kill)
  for _, child in obj:IterateArgs(frame:GetChildren()) do
    if (kill) then
      self:KillElement(child);
    else
      child:Hide();
    end
  end

  for _, region in obj:IterateArgs(frame:GetRegions()) do
    if (kill) then
      self:KillElement(region);
    else
      region:Hide();
    end
  end
end

function tk:SetBackground(frame, texturePath, g, b, a, inset)
  inset = inset or 0;
  local texture = frame:CreateTexture(nil, "BACKGROUND");

  texture:SetPoint("TOPLEFT", frame, "TOPLEFT", inset, -inset);
  texture:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -inset, inset);

  if (obj:IsString(texturePath)) then
    texture:SetTexture(texturePath);
  else
    local r = texturePath;
    texture:SetTexture(tk.Constants.SOLID_TEXTURE);
    texture:SetVertexColor(r, g, b, a);
  end

  return texture;
end


------------------------------------------------
--> Color Functions
------------------------------------------------
do
  local progressColors = {
    low = { r = 1, g = 77/255, b = 77/255 },
    medium = { r = 1, g = 1, b = 128/255 },
    high = { r = 1, g = 1, b = 1 }
  };

  function tk:GetProgressColor(current, max, invert)
    local percent = max > 0 and (current / max) or 0;

    local high = progressColors.high;
    local medium = progressColors.medium;
    local low = progressColors.low;

    if (invert) then
      high = progressColors.low;
      low = progressColors.high;
    end

    if (percent >= 1) then
      return high.r, high.g, high.b;
    end

    if (percent <= 0.125) then
      return low.r, low.g, low.b;
    end

    -- start and end R,B,G values:
    local start, stop;

    if (percent > 0.5) then
      -- greater than half way
      start = high;
      stop = medium;
    else
      -- less than half way
      start = medium;
      stop = low;
    end

    return self:MixColorsByPercentage(start, stop, percent);
  end
end

-- apply theme color to a vararg list of elements
-- first arg can be a number specifying the alpha value
function tk:ApplyThemeColor(...)
  local alpha = (select(1, ...));

  -- first argument is "colorName"
  if (not (obj:IsNumber(alpha) and alpha)) then
    tk.Constants.AddOnStyle:ApplyColor(nil, 1, ...);
  else
    tk.Constants.AddOnStyle:ApplyColor(nil, ...);
  end
end

function tk:GetThemeColorMixin()
  if (tk.Constants.AddOnStyle) then
    return tk.Constants.AddOnStyle:GetColor(nil, true);
  end

  if (not db.profile) then
    return tk.Constants.COLORS.BATTLE_NET_BLUE;
  end

  return db.profile.theme.color;
end

function tk:GetThemeColor()
  if (tk.Constants.AddOnStyle) then
    local r, g, b, hex = tk.Constants.AddOnStyle:GetColor();
    return r, g, b, hex;
  end

  if (not db.profile) then
    local r, g, b = tk.Constants.COLORS.BATTLE_NET_BLUE:GetRGB();
    local hex = tk.Constants.COLORS.BATTLE_NET_BLUE:GenerateHexColor();
    return r, g, b, hex;
  end

  local color = db.profile.theme.color;
  return color.r, color.g, color.b, color.hex;
end

function tk:UpdateThemeColor(value)
  local color;

  if (obj:IsTable(value) and value.r and value.g and value.b) then
    color = value;
  else
    color = _G.GetClassColorObj(value);
  end

  if (not color.GenerateHexColor) then
    color = CreateColor(color.r, color.g, color.b);
  end

  local colorValues = obj:PopTable();
  colorValues.r = color.r;
  colorValues.g = color.g;
  colorValues.b = color.b;
  colorValues.hex = color:GenerateHexColor();

  -- update database
  db.profile.theme.color = colorValues;

  -- update Constant Style Object
  tk.Constants.AddOnStyle:SetColor(color.r, color.g, color.b);
  tk.Constants.AddOnStyle:SetColor(
    color.r * 0.7, color.g * 0.7, color.b * 0.7, "Widget");
end

function tk:SetGradient(texture, direction, r, g, b, a, r2, g2, b2, a2)
  r, g, b, a, r2, g2, b2, a2 = r or 0, g or 0, b or 0, a or 0, r2 or 0, g2 or 0, b2 or 0, a2 or 0;

  if (obj:IsFunction(texture.SetGradientAlpha)) then
    texture:SetGradientAlpha(direction, r, g, b, a, r2, g2, b2, a2);
  else
    -- dragonflight only:
    local minColor = CreateColor(r, g, b, a);
    local maxColor = CreateColor(r2, g2, b2, a2);
    texture:SetGradient(direction, minColor, maxColor);
  end
end

------------------------------------------------
--> Font Functions
------------------------------------------------

function tk:SetFontSize(fontString, size)
  local filePath, _, flags = fontString:GetFont();
  fontString:SetFont(filePath, size, flags);
end

function tk:SetFont(fontString, fontName)
  local filePath = tk.Constants.LSM:Fetch("font", fontName);
  local _, size, flags = fontString:GetFont();
  fontString:SetFont(filePath, size, flags);
end

function tk:GetMasterFont()
  return tk.Constants.LSM:Fetch("font", db.global.core.fonts.master);
end

function tk:SetGameFont(fontSettings)
  local media = tk.Constants.LSM;
  local masterFont = media:Fetch("font", fontSettings.master);

  if (fontSettings.useCombatFont) then
    local combatFont = media:Fetch("font", fontSettings.combat);
    _G["DAMAGE_TEXT_FONT"] = combatFont; -- for damage AND healing font
  end

  if (not fontSettings.useMasterFont) then return end

  _G["UNIT_NAME_FONT"] = masterFont;
  _G["NAMEPLATE_FONT"] = masterFont;
  _G["STANDARD_TEXT_FONT"] = masterFont;

  local additionalBlizzardFontStrings = {
    "SystemFont_Tiny"; "SystemFont_Shadow_Small"; "SystemFont_Small";
    "SystemFont_Small2"; "SystemFont_Shadow_Small2";
    "SystemFont_Shadow_Med1_Outline"; "SystemFont_Shadow_Med1";
    "QuestFont_Large"; "SystemFont_Large"; "SystemFont_Shadow_Large_Outline";
    "SystemFont_Shadow_Med2"; "SystemFont_Shadow_Large";
    "SystemFont_Shadow_Large2"; "SystemFont_Shadow_Huge1"; "SystemFont_Huge2";
    "SystemFont_Shadow_Huge2"; "SystemFont_Shadow_Huge3"; "SystemFont_World";
    "SystemFont_World_ThickOutline"; "SystemFont_Shadow_Outline_Huge2";
    "SystemFont_Med1"; "SystemFont_WTF2"; "SystemFont_Outline_WTF2";
    "GameTooltipHeader"; "System_IME";
    "NumberFont_OutlineThick_Mono_Small"; "NumberFont_Outline_Huge";
    "NumberFont_Outline_Large"; "NumberFont_Outline_Med";
    "NumberFont_Shadow_Med"; "NumberFont_Shadow_Small"; "QuestFont";
    "QuestTitleFont"; "QuestTitleFontBlackShadow"; "GameFontNormalMed3";
    "SystemFont_Med3"; "SystemFont_OutlineThick_Huge2";
    "SystemFont_Outline_Small"; "SystemFont_Shadow_Med3"; "Tooltip_Med";
    "Tooltip_Small"; "ZoneTextString"; "SubZoneTextString"; "PVPInfoTextString";
    "PVPArenaTextString"; "CombatTextFont"; "FriendsFont_Normal";
    "FriendsFont_Small"; "FriendsFont_Large"; "FriendsFont_UserText";
    "Fancy22Font";
  };

  -- prevent weird font size bug
  local _, _, sysFontFlags = _G.SystemFont_NamePlate:GetFont();
  _G.SystemFont_NamePlate:SetFont(masterFont, 9, sysFontFlags);

  for _, f in ipairs(additionalBlizzardFontStrings) do
    local fontString = _G[f];

    if (obj:IsTable(fontString) and obj:IsFunction(fontString.GetFont)) then
      local _, size, fontFlags = fontString:GetFont();
      fontString:SetFont(masterFont, size, fontFlags);
    end
  end
end

------------------------------------------------
--> Widget Creation Functions
------------------------------------------------
function tk:GroupCheckButtons(radioButtonsInGroup, canUncheck)
  for id, btn in ipairs(radioButtonsInGroup) do
    local oldScript = btn:GetScript("OnClick");
    btn.previousValue = btn:GetChecked();

    btn:SetScript("OnClick", function(self, ...)
      if (not canUncheck) then
        self:SetChecked(true); -- Can never uncheck a radio button by reclicking in
      end

      for otherId, otherBtn in ipairs(radioButtonsInGroup) do
        if (id ~= otherId) then
          otherBtn:SetChecked(false);
          otherBtn.previousValue = false;

          local onLeave = otherBtn:GetScript("OnLeave");
          if (obj:IsFunction(onLeave)) then
            onLeave(otherBtn);
          end
        end
      end

      if (not self.previousValue) then
        oldScript(self, ...);
        self.previousValue = true;

        local onLeave = self:GetScript("OnLeave");
        if (obj:IsFunction(onLeave)) then
          onLeave(self);
        end
      elseif (canUncheck) then
        oldScript(self, ...);
      end
    end);
  end
end

---@generic T : FrameType
---@param frameType FrameType|`T`
---@param parent Frame?
---@param globalName string?
---@param templates string?
---@return T
function tk:CreateFrame(frameType, parent, globalName, templates)
  local frame =  CreateFrame(frameType or "Frame", globalName, parent or _G.UIParent, templates);
  frame:ClearAllPoints();
  frame:Show();
  return frame;
end

---@generic T: FrameType
---@param frameType `T`
---@param parent Frame?
---@param globalName string?
---@param templates string?
---@return T|BackdropTemplate
function tk:CreateBackdropFrame(frameType, parent, globalName, templates)
  if (_G.BackdropTemplateMixin) then
    if (templates) then
      templates = templates..", BackdropTemplate";
    else
      templates = "BackdropTemplate";
    end
  end

  local frame =  tk:CreateFrame(frameType, parent, globalName, templates);
  frame:ClearAllPoints();
  frame:Show();
  return frame;
end