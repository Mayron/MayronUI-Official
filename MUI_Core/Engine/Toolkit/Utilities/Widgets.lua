-- luacheck: ignore self
local _G = _G;
local MayronUI = _G.MayronUI; ---@type MayronUI

---@class MayronUI.Toolkit
local tk, db, _, _, obj = MayronUI:GetCoreComponents();

local ipairs, CreateFrame, select = _G.ipairs, _G.CreateFrame, _G.select;
local CreateColor = _G.CreateColor;
local GameTooltip = _G.GameTooltip;

------------------------------------------------
--> Tooltip Functions
------------------------------------------------
function tk.HandleTooltipOnLeave()
  if (obj:IsFunction(GameTooltip.__oldSetFrameStrata)) then
    GameTooltip.SetFrameStrata = GameTooltip.__oldSetFrameStrata;
  end
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
    local owner = widget.wrapper or widget;
    SetTooltipOwner(owner, "ANCHOR_BOTTOMLEFT");
    local itemId = widget.itemID or widget:GetID();

    GameTooltip.__oldSetFrameStrata = GameTooltip.SetFrameStrata;
    GameTooltip:SetFrameStrata(tk.Constants.FRAME_STRATAS.TOOLTIP);
    GameTooltip.SetFrameStrata = tk.Constants.DUMMY_FUNC;

    if (widget.cooldown) then
      GameTooltip:SetFrameLevel(widget.cooldown:GetFrameLevel() + 10);
    end

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

    elseif (obj:IsString(widget.tooltipText) or obj:IsString(widget.disabledTooltipText)) then
      local tooltipText = widget.tooltipText;

      if (obj:IsString(widget.disabledTooltipText)) then
        if (obj:IsFunction(widget.GetEnabled)) then
          if (not widget:GetEnabled()) then
            tooltipText = widget.disabledTooltipText;
          end
        end
      end

      if (#tooltipText > 100) then
        local minWidth = math.min(#tooltipText, 400);
        GameTooltip:SetMinimumWidth(minWidth);
      end

      GameTooltip:AddLine(tooltipText, nil, nil, nil, true);

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
---@param disabledText string?
function tk:SetBasicTooltip(widget, text, point, xOffset, yOffset, disabledText)
  widget.tooltipText = text;
  widget.disabledTooltipText = disabledText; -- only applies if widget has `GetEnabled`

  if (xOffset or yOffset) then
    if (not obj:IsTable(widget.tooltipAnchor)) then
      -- Defaults will be applied in the `SetTooltipOwner` function
      widget.tooltipAnchor = obj:PopTable();
    end

    widget.tooltipAnchor.point = point;
    widget.tooltipAnchor.xOffset = xOffset;
    widget.tooltipAnchor.yOffset = yOffset;
  else
    if (obj:IsTable(widget.tooltipAnchor)) then
      obj:PushTable(widget.tooltipAnchor);
    end

    widget.tooltipAnchor = point;
  end

  widget:SetScript("OnEnter", tk.HandleTooltipOnEnter);
  widget:SetScript("OnLeave", tk.HandleTooltipOnLeave);
end

------------------------------------------------
--> Frame Moving and Resizing Functions
------------------------------------------------

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

---@overload fun(self, frame: Frame, r: number, g: number, b: number, a: number?)
---@overload fun(self, frame: Frame, texturePath: string?, a: number?)
function tk:SetBackground(frame, ...)
  local texture = frame:CreateTexture(nil, "BACKGROUND");
  local arg1 = ...;

  if (arg1 == nil or obj:IsString(arg1)) then
    local texturePath, a = ...;
    texture:SetTexture(texturePath or tk.Constants.SOLID_TEXTURE);
    texture:SetVertexColor(1, 1, 1, a or 1);
  else
    local r, g, b, a = ...;
    texture:SetTexture(tk.Constants.SOLID_TEXTURE);
    texture:SetVertexColor(r, g, b, a or 1);
  end

  texture:SetAllPoints(true);

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
    local aboveThreshold = percent >= 1;

    if (invert) then
      high = progressColors.low;
      low = progressColors.high;
    end

    if (aboveThreshold) then
      return high.r, high.g, high.b, aboveThreshold;
    end

    if (percent <= 0.125) then
      return low.r, low.g, low.b, aboveThreshold;
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

    local r, g, b = self:MixColorsByPercentage(start, stop, percent);
    return r, g, b, aboveThreshold;
  end
end

do
  local ITERATIONS = 50;
  local C_Timer = _G.C_Timer;

  ---@param statusBar StatusBar
  ---@param newValue number
  function tk:AnimateSliderChange(statusBar, newValue)
    statusBar.endValue = newValue;
    if (statusBar.timer and not statusBar.timer:IsCancelled()) then return end

    local startValue = statusBar:GetValue();
    local diff = startValue - newValue;

    if (diff >= 0) then
      statusBar:SetValue(newValue);
      return
    end

    diff = math.ceil(math.abs(diff));

    if (diff < 2) then
      statusBar:SetValue(newValue);
      return
    end

    local _, max = statusBar:GetMinMaxValues();
    local percentDiff = (diff / max) * 100;

    if (percentDiff < 5) then
      statusBar:SetValue(newValue);
      return
    end

    local extra = 0;

    if (diff > ITERATIONS) then
      local remaining = diff - ITERATIONS;
      extra = remaining / ITERATIONS;
    elseif (diff < ITERATIONS) then
      local remaining = diff - ITERATIONS;
      extra = remaining / ITERATIONS;
    end

    diff = diff * 100; -- in milliseconds

    local i = 0;
    statusBar.timer = C_Timer.NewTicker(0.01, function()
      i = i + 1;

      if (i >= ITERATIONS) then
        statusBar:SetValue(statusBar.endValue);
        statusBar.timer:Cancel();
      end

      local percent = i/ITERATIONS;
      percent = math.min(1, -(math.cos(math.pi * percent) - 1) / 2);

      local shouldCancel, stepValue;
      local changeAmount = (percent * diff) + extra;
      local changeInSeconds = changeAmount / 100;

      stepValue = math.max(startValue + changeInSeconds, 0);

      if (stepValue >= statusBar.endValue) then
        shouldCancel = true;
        stepValue = statusBar.endValue;
      end

      statusBar:SetValue(stepValue);
      if (shouldCancel) then
        statusBar.timer:Cancel();
      end
    end, ITERATIONS);
  end
end

do
  local SecondsToTimeAbbrev = _G.SecondsToTimeAbbrev;
  local SECOND_ONELETTER_ABBR = _G["SECOND_ONELETTER_ABBR"];

  ---comment
  ---@param fontString FontString
  ---@param timeRemainingInSeconds integer
  ---@param fontSize number
  ---@param secondsWarning integer?
  ---@param largeFontSize number?
  function tk:SetTimeRemaining(fontString, timeRemainingInSeconds, fontSize, secondsWarning, largeFontSize, r, g, b)
    local format, value = SecondsToTimeAbbrev(timeRemainingInSeconds);

    if (format == SECOND_ONELETTER_ABBR) then
      value = math.ceil(value);
      fontString:SetFormattedText("%d", value);
    else
      local text = string.format(format, value);
      text = self.Strings:RemoveWhiteSpace(text);
      fontString:SetText(text);
    end

    local current = math.min(30, timeRemainingInSeconds);
    local progressR, progressG, progressB, aboveThreshold = self:GetProgressColor(current, 30);

    if (aboveThreshold and r ~= nil and g ~= nil and b ~= nil) then
      fontString:SetTextColor(r, g, b);
    else
      fontString:SetTextColor(progressR, progressG, progressB);
    end

    if (largeFontSize and value <= (secondsWarning or 10) and timeRemainingInSeconds < 20) then
      fontSize = largeFontSize;
    end

    self:SetFontSize(fontString, fontSize);
  end
end

local themedElements = {};

-- apply theme color to a vararg list of elements
-- first arg can be a number specifying the alpha value
function tk:ApplyThemeColor(...)
  local alpha = (select(1, ...));
  local start = 1;

  if (obj:IsNumber(alpha) and alpha) then
    start = 2;
  else
    alpha = nil;
  end

  local r, g, b = self:GetThemeColor();

  for i = start, select("#", ...) do
    local element = (select(i, ...));

    obj:Assert(obj:IsTable(element) and element.GetObjectType,
      "ApplyThemeColor: Widget expected but received a %s value of %s", type(element), element);

    if (not element.isSwatch) then
      local key = tostring(element);
      themedElements[key] = element;
    end

    if (obj:IsFunction(element.ApplyThemeColor)) then
      -- a custom way of applying it with more control
      element:ApplyThemeColor();
    else
      local objectType = element:GetObjectType();

      if (objectType == "Texture") then
        ---@cast element Texture|table
        local id = element:GetTexture();

        if (not id or id == "FileData ID 0") then
          alpha = alpha or element.__alpha or 1;
          element:SetColorTexture(r, g, b, alpha);
          element.__alpha = alpha;
        else
          if (alpha == nil) then
            local _, _, _, a = element:GetVertexColor();
            alpha = a or 1;
          end

          element:SetVertexColor(r, g, b, alpha);
        end

      elseif (objectType == "CheckButton") then
        ---@cast element CheckButton
        local checkedTexture = element:GetCheckedTexture()--[[@as Texture|table]];

        if (checkedTexture) then
          local checkedAlpha = alpha or checkedTexture.__alpha or 1;
          checkedTexture:SetColorTexture(r, g, b, checkedAlpha);
          checkedTexture.__alpha = checkedAlpha;
        end

        local highlightTexture = element:GetHighlightTexture()--[[@as Texture]];

        if (highlightTexture) then
          local highlightAlpha = alpha or highlightTexture.__alpha or 1;
          highlightTexture:SetColorTexture(r, g, b, highlightAlpha);
          highlightTexture.__alpha = highlightAlpha;
        end

      elseif (objectType == "Button") then
        local normalTexture = element:GetNormalTexture();
        local highlightTexture = element:GetHighlightTexture();

        local normalAlpha, highlightAlpha = alpha, alpha;

        if (alpha == nil) then
          local _, _, _, a1 = normalTexture:GetVertexColor();
          local _, _, _, a2 = highlightTexture:GetVertexColor();
          normalAlpha, highlightAlpha = a1, a2;
        end

        normalTexture:SetVertexColor(r, g, b, normalAlpha or 1);
        highlightTexture:SetVertexColor(r, g, b, highlightAlpha or 1);

        if (obj:IsFunction(element.SetBackdropBorderColor)) then
          element:SetBackdropBorderColor(r, g, b, 0.7);
        end

        if (element:GetDisabledTexture()) then
          element:GetDisabledTexture():SetVertexColor(r * 0.3, g * 0.3, b * 0.3, 0.6);
        end

      elseif (objectType == "FontString") then
        ---@cast element FontString

        if (alpha == nil) then
          local _, _, _, a = element:GetTextColor();
          alpha = a;
        end

        element:SetTextColor(r, g, b, alpha or 1);
      end
    end
  end
end

function tk:GetThemeColor()
  if (not tk.Constants.ThemeColor and db.profile) then
    local color = db.profile.theme.color;
    tk.Constants.ThemeColor = CreateColor(color.r, color.g, color.b);
  end

  if (tk.Constants.ThemeColor) then
    local r, g, b = tk.Constants.ThemeColor:GetRGB();
    local hex = tk.Constants.ThemeColor:GenerateHexColor();
    return r, g, b, hex;
  end

  local r, g, b = tk.Constants.COLORS.BATTLE_NET_BLUE:GetRGB();
  local hex = tk.Constants.COLORS.BATTLE_NET_BLUE:GenerateHexColor();
  return r, g, b, hex;
end

local GetClassColorObj = _G.GetClassColorObj;

function tk:UpdateThemeColor(value)
  local color;

  if (obj:IsTable(value) and value.r and value.g and value.b) then
    color = value;
  elseif (obj:IsString(value)) then
    -- its a classFileName
    color = GetClassColorObj(value);
  end

  if (not color.GenerateHexColor) then
    color = CreateColor(color.r, color.g, color.b);
  end

  local colorValues = obj:PopTable();
  colorValues.r = color.r;
  colorValues.g = color.g;
  colorValues.b = color.b;

  tk.Constants.ThemeColor = color;
  db.profile.theme.color = colorValues;

  db:SetPathValue(db.profile, "castbars.appearance.colors.normal", nil);
  db:SetPathValue(db.profile, "bottomui.gradients", nil);
  db:RemoveAppended(db.profile, "unitPanels.sufGradients");

  for _, element in pairs(themedElements) do
    self:ApplyThemeColor(element);
  end
end

---@param texture Texture
---@param direction "HORIZONTAL"|"VERTICAL"
---@param r number?
---@param g number?
---@param b number?
---@param a number?
---@param r2 number?
---@param g2 number?
---@param b2 number?
---@param a2 number?
function tk:SetGradient(texture, direction, r, g, b, a, r2, g2, b2, a2)
  r, g, b, a, r2, g2, b2, a2 = r or 0, g or 0, b or 0, a or 0, r2 or 0, g2 or 0, b2 or 0, a2 or 0;

  if (obj:IsFunction(texture.SetGradientAlpha)) then
    texture:SetGradientAlpha(direction, r, g, b, a, r2, g2, b2, a2);
  else
    -- dragonflight only:
    texture.minColor = texture.minColor or CreateColor(r, g, b, a);
    texture.minColor:SetRGBA(r, g, b, a);

    texture.maxColor = texture.maxColor or CreateColor(r2, g2, b2, a2);
    texture.maxColor:SetRGBA(r2, g2, b2, a2);

    texture:SetGradient(direction, texture.minColor, texture.maxColor);
  end
end

------------------------------------------------
--> Font Functions
------------------------------------------------

function tk:SetFontSize(fontString, size)
  local filePath, _, flags = fontString:GetFont();
  fontString:SetFont(filePath, size, flags);
end

---@param fontString FontString
---@param fontName string
---@param newSize number?
---@param newFlags string?
function tk:SetFont(fontString, fontName, newSize, newFlags)
  local filePath = tk.Constants.LSM:Fetch("font", fontName);
  local _, size, flags = fontString:GetFont();
  fontString:SetFont(filePath, newSize or size, newFlags or flags);
end

function tk:GetMasterFont()
  return tk.Constants.LSM:Fetch("font", db.global.core.fonts.master);
end

---@param fontString FontString
---@param newSize number?
---@param newFlags string?
function tk:SetMasterFont(fontString, newSize, newFlags)
  local filePath = tk:GetMasterFont();
  local _, size, flags = fontString:GetFont();
  fontString:SetFont(filePath, newSize or size, newFlags or flags);
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
---@param parent (BackdropTemplate|Frame)?
---@param globalName string?
---@param templates string?
---@return T
function tk:CreateFrame(frameType, parent, globalName, templates)
  local frame =  CreateFrame(frameType or "Frame", globalName, parent or _G.UIParent, templates);
  frame:ClearAllPoints();
  frame:Show();
  return frame;
end

---@generic T : FrameType
---@param frameType `T`
---@param parent Frame?
---@param globalName string?
---@param templates string?
---@return BackdropTemplate|T
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