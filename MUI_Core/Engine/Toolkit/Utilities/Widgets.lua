-- luacheck: ignore self
local _G = _G;
local MayronUI = _G.MayronUI;

local tk, db, _, _, obj = MayronUI:GetCoreComponents();

---@type Toolkit
tk = tk;

local TOOLTIP_ANCHOR_POINT = "ANCHOR_TOP";
local ipairs, hooksecurefunc, CreateFrame, select = _G.ipairs, _G.hooksecurefunc,
  _G.CreateFrame, _G.select;
local CreateColor = _G.CreateColor;

function tk:SetFontSize(fontString, size)
  local fontPath, _, flags = fontString:GetFont();
  fontString:SetFont(fontPath, size, flags);
end

do
  local function SetOwner(widget)
    local anchor = widget.tooltipAnchor;
    local point = TOOLTIP_ANCHOR_POINT
    local xOffset = 0;
    local yOffset = 2;

    if (obj:IsTable(anchor)) then
      point = anchor.point or TOOLTIP_ANCHOR_POINT;
      xOffset = anchor.xOffset or xOffset;
      yOffset = anchor.yOffset or yOffset;

    elseif (obj:IsString(anchor)) then
      point = anchor;
    end

    _G.GameTooltip:SetOwner(widget, point, xOffset, yOffset);
  end

  function tk.GeneralTooltip_OnLeave()
    _G.GameTooltip:Hide();
  end

  function tk.BasicTooltip_OnEnter(self)
    SetOwner(self);
    _G.GameTooltip:AddLine(self.tooltipText);
    _G.GameTooltip:Show();
  end

  function tk.AuraTooltip_OnEnter(self)
    if (self.auraId) then
      _G.GameTooltip:SetOwner(self, TOOLTIP_ANCHOR_POINT, 0, 2);
      _G.GameTooltip:SetSpellByID(self.auraId);
      _G.GameTooltip:Show();
    end
  end

  local function MultipleLinesTooltip_OnEnter(self)
    SetOwner(self);

    for _, line in ipairs(self.lines) do
      if (line.text) then
        _G.GameTooltip:AddLine(line.text);

      elseif (line.leftText and line.rightText) then
        local r, g, b = tk:GetThemeColor();
        _G.GameTooltip:AddDoubleLine(line.leftText, line.rightText, r, g, b, 1, 1, 1);
      end
    end

    _G.GameTooltip:Show();
  end

  -- point, xOffset, yOffset are all optional
  function tk:SetBasicTooltip(widget, text, point, xOffset, yOffset)
    widget.tooltipText = text;

    if (xOffset or yOffset) then
      widget.tooltipAnchor = obj:PopTable();
      widget.tooltipAnchor.point = point;
      widget.tooltipAnchor.xOffset = xOffset;
      widget.tooltipAnchor.yOffset = yOffset;
    else
      widget.tooltipAnchor = point;
    end

    widget:SetScript("OnEnter", tk.BasicTooltip_OnEnter);
    widget:SetScript("OnLeave", tk.GeneralTooltip_OnLeave);
  end

  function tk:SetAuraTooltip(widget, auraId)
    if (auraId) then
      widget.auraId = auraId;
    end

    widget:SetScript("OnEnter", tk.AuraTooltip_OnEnter);
    widget:SetScript("OnLeave", tk.GeneralTooltip_OnLeave);
  end

  function tk:SetMultipleLinesTooltip(widget, cleanUp)
    widget.cleanUp = cleanUp;

    widget:SetScript("OnEnter", MultipleLinesTooltip_OnEnter);
    widget:SetScript("OnLeave", tk.GeneralTooltip_OnLeave);
  end
end

function tk:SetFullWidth(frame, rightPadding)
  rightPadding = rightPadding or 0;
  local parent = frame:GetParent();

  if (not parent) then
    hooksecurefunc(frame, "SetParent", function()
      tk:SetFullWidth(frame, rightPadding);
    end);
  else
    parent:HookScript("OnSizeChanged", function(_, width)
      frame:SetWidth(width - rightPadding);
    end);

    frame:SetWidth(parent:GetWidth() - rightPadding);
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

  if (element:GetObjectType() == "Texture") then
    element:SetTexture(tk.Strings.Empty)
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

---deprecated - Use Other.lua HookFunc and UnhookFunc
function tk:HookOnce(func)
  local execute = true;

  local function wrapper(...)
    if (execute) then
      func(...);
      execute = nil;
    end
  end

  return wrapper;
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

function tk:GetThemeColor(returnTable)
  if (tk.Constants.AddOnStyle) then
    return tk.Constants.AddOnStyle:GetColor(nil, returnTable);
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

function tk:GroupCheckButtons(radioButtonsInGroup)
  for id, btn in ipairs(radioButtonsInGroup) do
    local oldScript = btn:GetScript("OnClick");
    btn.previousValue = btn:GetChecked();

    btn:SetScript("OnClick", function(self, ...)
      self:SetChecked(true); -- Can never uncheck a radio button by reclicking in

      for otherId, otherBtn in ipairs(radioButtonsInGroup) do
        if (id ~= otherId) then
          otherBtn:SetChecked(false);
          otherBtn.previousValue = false;
        end
      end

      if (not self.previousValue) then
        oldScript(self, ...);
        self.previousValue = true;
      end
    end);
  end
end

function tk:SetFontSize(fontstring, size)
  local filename, _, flags = fontstring:GetFont();
  fontstring:SetFont(filename, size, flags);
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

function tk:CreateFrame(frameType, parent, globalName, templates)
  local frame =  CreateFrame(frameType or "Frame", globalName, parent or _G.UIParent, templates);
  frame:ClearAllPoints();
  frame:Show();
  return frame;
end