-- luacheck: ignore MayronUI self 143 631
---@type LibMayronGUI
local Lib = _G.LibStub:GetLibrary("LibMayronGUI");

if (not Lib) then
  return;
end

local CreateFrame, string, hooksecurefunc, PlaySound, unpack, max =
  _G.CreateFrame, _G.string, _G.hooksecurefunc, _G.PlaySound, _G.unpack,
  _G.math.max;

local Private = Lib.Private;
local obj = _G.MayronObjects:GetFramework();

local function OnEnter(self)
  if (not obj:IsString(self.tooltip)) then
    local parent = self:GetParent();

    if (obj:IsTable(parent) and obj:IsString(parent.tooltip)) then
      local script = parent:GetScript("OnEnter");

      if (obj:IsFunction(script)) then
        script(parent); -- it's the container
      end
    end

    return
  end

  _G.GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 4);
  _G.GameTooltip:AddLine(self.tooltip, nil, nil, nil, true);
  _G.GameTooltip:Show();
end

local function OnLeave()
  _G.GameTooltip:Hide();
end

Lib.FONT_TYPES = {
  GameFontNormal = "GameFontNormal";
  GameFontNormalSmall = "GameFontNormalSmall";
  GameFontNormalLarge = "GameFontNormalLarge";
  GameFontHighlight = "GameFontHighlight";
  GameFontHighlightSmall = "GameFontHighlightSmall";
  GameFontHighlightSmallOutline = "GameFontHighlightSmallOutline";
  GameFontHighlightLarge = "GameFontHighlightLarge";
  GameFontDisable = "GameFontDisable";
  GameFontDisableSmall = "GameFontDisableSmall";
  GameFontDisableLarge = "GameFontDisableLarge";
  GameFontGreen = "GameFontGreen";
  GameFontGreenSmall = "GameFontGreenSmall";
  GameFontGreenLarge = "GameFontGreenLarge";
  GameFontRed = "GameFontRed";
  GameFontRedSmall = "GameFontRedSmall";
  GameFontRedLarge = "GameFontRedLarge";
  GameFontWhite = "GameFontWhite";
  GameFontDarkGraySmall = "GameFontDarkGraySmall";
  NumberFontNormalYellow = "NumberFontNormalYellow";
  NumberFontNormalSmallGray = "NumberFontNormalSmallGray";
  QuestFontNormalSmall = "QuestFontNormalSmall";
  DialogButtonHighlightText = "DialogButtonHighlightText";
  ErrorFont = "ErrorFont";
  TextStatusBarText = "TextStatusBarText";
  CombatLogFont = "CombatLogFont";
};

---@param style Style @The style Object to used to get the "DialogBoxBackground" texture for the dialog box background.
---@param parent Frame @(optional) The parent frame to give the new frame if frame param is nil
---@param alphaType string @(optional) the dialog box background type ("high", "medium", "low")
---@param frame Frame @(optional) A frame to apply the dialog box background texture to (a new one is created if nil)
---@param globalName string @(optional) A global name to give the new frame if frame param is nil
---@return Frame @The new frame (or existing frame if the frame param was supplied).
function Lib:CreateDialogBox(style, parent, alphaType, frame, globalName)
  frame = frame or CreateFrame("Frame", globalName, parent or _G.UIParent);
  frame:EnableMouse(true);

  alphaType = alphaType or "Medium";
  alphaType = alphaType:lower();
  alphaType = alphaType:gsub("^%l", string.upper);

  local texture = style:GetTexture("DialogBoxBackground");
  texture = string.format("%s%s", texture, alphaType);

  Lib:CreateGridTexture(frame, texture, 10, 6, 512, 512);

  -- apply the theme color for each Grid Cell
  style:ApplyColor(
    nil, nil, frame.tl, frame.tr, frame.bl, frame.br, frame.t, frame.b, frame.l,
    frame.r, frame.c);
  frame:SetFrameStrata("DIALOG");

  return frame;
end

do
  local function Button_OnEnable(self)
    local r, g, b = unpack(self.enabledBackdrop);
    self:SetBackdropBorderColor(r, g, b, 0.7);
  end

  local function Button_OnDisable(self)
    local r, g, b = _G.DISABLED_FONT_COLOR:GetRGB();
    self:SetBackdropBorderColor(r, g, b, 0.6);
  end

  local function SetWidth(self)
    local fontString = self:GetFontString();

    local width = fontString:GetUnboundedStringWidth() + (self.padding);
    width = max(max(self.minWidth or 0, width), self:GetWidth());

    self:SetWidth(width);
    fontString:SetPoint("CENTER", self);
  end

  function Lib:CreateButton(
    style, parent, text, button, tooltip, padding, minWidth)
    local backgroundTexture = style:GetTexture("ButtonTexture");

    button = button or CreateFrame(
               "Button", nil, parent,
               _G.BackdropTemplateMixin and "BackdropTemplate");

    button.padding = padding or 30;
    button.minWidth = minWidth;
    button:SetHeight(30);
    button:SetBackdrop(style:GetBackdrop("ButtonBackdrop"));

    local fs = button:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    button:SetFontString(fs);
    hooksecurefunc(button, "SetText", SetWidth);

    if (text) then
      button:SetText(text);
    else
      button:SetWidth(minWidth or 150);
    end

    if (tooltip) then
      button.tooltip = tooltip;
      button:SetScript("OnEnter", OnEnter);
      button:SetScript("OnLeave", OnLeave);
    end

    local normal = Private:SetBackground(button, backgroundTexture);
    local highlight = Private:SetBackground(button, backgroundTexture);
    local disabled = Private:SetBackground(button, backgroundTexture);

    button:SetNormalTexture(normal);
    button:SetHighlightTexture(highlight);
    button:SetDisabledTexture(disabled);

    button:SetNormalFontObject("GameFontHighlight");
    button:SetDisabledFontObject("GameFontDisable");

    button:SetScript("OnEnable", Button_OnEnable);
    button:SetScript("OnDisable", Button_OnDisable);

    self:UpdateButtonColor(button, style);

    return button;
  end

  -- TODO: Should be deprecated and replacedby Style.lua > function Style:ApplyColor(_, colorName, alpha, ...)
  function Lib:UpdateButtonColor(button, style)
    local r, g, b = style:GetColor();
    local normal = button:GetNormalTexture();
    local highlight = button:GetHighlightTexture();
    local disabled = button:GetDisabledTexture();

    button:SetBackdropBorderColor(r, g, b, 0.7);
    button.enabledBackdrop = obj:PopTable(r, g, b);

    normal:SetVertexColor(r * 0.6, g * 0.6, b * 0.6, 1);
    highlight:SetVertexColor(r, g, b, 0.2);

    local dr, dg, db = _G.DISABLED_FONT_COLOR:GetRGB();
    disabled:SetVertexColor(dr, dg, db, 0.6);

    if (button:IsEnabled()) then
      button:SetBackdropBorderColor(r, g, b, 0.7);
    else
      button:SetBackdropBorderColor(dr, dg, db, 0.6);
    end
  end
end

do
  local function CheckButton_OnSetEnabled(self, value)
    if (value) then
      self.text:SetFontObject("GameFontHighlight");
    else
      self.text:SetFontObject("GameFontDisable");
    end
  end

  local function CheckButton_OnEnter(self)
    self:GetNormalTexture():SetVertexColor(0.7, 0.7, 0.7);
    self:GetCheckedTexture():SetBlendMode("ADD");
  end

  local function CheckButton_OnLeave(self)
    self:GetNormalTexture():SetVertexColor(1, 1, 1);
    self:GetCheckedTexture():SetBlendMode("BLEND");
  end

  local function UpdateColor(self)
    local tk = _G.MayronUI:GetCoreComponent("Toolkit"); ---@type Toolkit
    local checkedTexture = self.btn:GetCheckedTexture();
    tk:ApplyThemeColor(checkedTexture);
  end

  function Lib:CreateCheckButton(parent, text, tooltip)
    local container = Private:PopFrame("Button", parent);
    container:SetSize(150, 30);
    container.btn = CreateFrame("CheckButton", nil, container, "UICheckButtonTemplate");
    container.btn:SetSize(20, 20);

    if (tooltip) then
      container.tooltip = tooltip;
      container:SetScript("OnEnter", OnEnter);
      container:SetScript("OnLeave", OnLeave);
      container.btn:SetScript("OnEnter", OnEnter);
      container.btn:SetScript("OnLeave", OnLeave);
    end

    container.btn:SetPushedTexture(nil);

    local tk = _G.MayronUI:GetCoreComponent("Toolkit"); ---@type Toolkit

    -- Normal Texture:
    container.btn:SetNormalTexture(
      tk:GetAssetFilePath(
        "Textures\\Widgets\\Unchecked"));
    local normalTexture = container.btn:GetNormalTexture();
    normalTexture:SetAllPoints(true);

    -- Checked Texture:
    container.btn:SetCheckedTexture(
      tk:GetAssetFilePath(
        "Textures\\Widgets\\Checked"));
    local checkedTexture = container.btn:GetCheckedTexture();
    checkedTexture:SetAllPoints(true);

    container.UpdateColor = UpdateColor;
    container:UpdateColor();

    -- Highlight Texture:
    container.btn:SetHighlightTexture(nil);

    container.btn:HookScript("OnEnter", CheckButton_OnEnter);
    container.btn:HookScript("OnLeave", CheckButton_OnLeave);

    container.btn:SetPoint("LEFT");
    container.btn.text:SetFontObject("GameFontHighlight");
    container.btn.text:ClearAllPoints();
    container.btn.text:SetPoint("LEFT", container.btn, "RIGHT", 6, 1);

    hooksecurefunc(container.btn, "SetEnabled", CheckButton_OnSetEnabled);

    if (text) then
      container.btn.text:SetText(text);
      local width = container.btn.text:GetStringWidth();
      width = (width > 100) and width or 100;
      container:SetWidth(width + container.btn:GetWidth() + 20);
    end

    return container;
  end
end

-------------------------------
-- Extra Widget Enhancements
-------------------------------
do
  local function TitleBar_SetWidth(self)
    local bar = self:GetParent();
    local width = self:GetStringWidth() + 34;

    width = (width > 150 and width) or 150;
    bar:SetWidth(width);
  end

  function Lib:AddTitleBar(style, frame, text)
    local texture = style:GetTexture("TitleBarBackground");

    frame.titleBar = CreateFrame("Button", nil, frame);
    frame.titleBar:SetSize(260, 31);
    frame.titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", -7, 11);
    frame.titleBar.bg = frame.titleBar:CreateTexture("ARTWORK");
    frame.titleBar.bg:SetTexture(texture);

    frame.titleBar.bg:SetAllPoints(true);
    frame.titleBar.text = frame.titleBar:CreateFontString(
                            nil, "ARTWORK", "GameFontHighlight");

    frame.titleBar.text:SetSize(260, 31);
    frame.titleBar.text:SetPoint("LEFT", frame.titleBar.bg, "LEFT", 10, 0.5);
    frame.titleBar.text:SetJustifyH("LEFT");

    Private:MakeMovable(frame, frame.titleBar);
    style:ApplyColor(nil, nil, frame.titleBar.bg);

    hooksecurefunc(frame.titleBar.text, "SetText", TitleBar_SetWidth);
    frame.titleBar.text:SetText(text);
  end
end

function Lib:AddResizer(style, frame)
  local normalTexture = style:GetTexture("DraggerTexture");
  local highlightTexture = style:GetTexture("DraggerTexture");

  frame.dragger = CreateFrame("Button", nil, frame);
  frame.dragger:SetSize(28, 28);
  frame.dragger:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 2);
  frame.dragger:SetNormalTexture(normalTexture, "BLEND");
  frame.dragger:SetHighlightTexture(highlightTexture, "ADD");

  Private:MakeResizable(frame, frame.dragger);
  style:ApplyColor(nil, nil, frame.dragger:GetNormalTexture());
  style:ApplyColor(nil, nil, frame.dragger:GetHighlightTexture());
end

function Lib:AddCloseButton(style, frame, onHideCallback, clickSoundFilePath)
  frame.closeBtn = CreateFrame("Button", nil, frame);
  frame.closeBtn:SetSize(28, 24);
  frame.closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1);

  local texture = style:GetTexture("CloseButtonBackground");
  frame.closeBtn:SetNormalTexture(texture, "BLEND");
  frame.closeBtn:SetHighlightTexture(texture, "ADD");
  style:ApplyColor(nil, nil, frame.closeBtn);

  local group = frame:CreateAnimationGroup();
  group.a1 = group:CreateAnimation("Translation");
  group.a1:SetSmoothing("OUT");
  group.a1:SetDuration(0.3);
  group.a1:SetOffset(0, 10);
  group.a2 = group:CreateAnimation("Alpha");
  group.a2:SetSmoothing("OUT");
  group.a2:SetDuration(0.3);
  group.a2:SetFromAlpha(1);
  group.a2:SetToAlpha(-1);

  group:SetScript(
    "OnFinished", function()
      if (obj:IsFunction(onHideCallback)) then
        onHideCallback(frame);
      end

      frame:Hide();
    end);

  frame.closeBtn:SetScript(
    "OnClick", function(self)
      group:Play();

      if (clickSoundFilePath) then
        PlaySound(clickSoundFilePath);
      end
    end);
end

function Lib:AddArrow(style, frame, direction, center)
  direction = direction or "UP";
  direction = direction:upper();

  frame.arrow = CreateFrame("Frame", nil, frame);
  frame.arrow:SetSize(30, 24);

  local texture = style:GetTexture("ArrowButtonTexture");
  frame.arrow.bg = frame.arrow:CreateTexture(nil, "ARTWORK");
  frame.arrow.bg:SetAllPoints(true);
  frame.arrow.bg:SetTexture(texture);

  style:ApplyColor(nil, nil, frame.arrow.bg);

  if (center) then
    frame.arrow:SetPoint("CENTER");
  end

  if (direction ~= "UP") then
    if (direction == "DOWN") then
      frame.arrow.bg:SetTexCoord(0, 1, 1, 0);

      if (not center) then
        frame.arrow:SetPoint("TOP", frame, "BOTTOM", 0, -2);
      end
    end
  end
end
