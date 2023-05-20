-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, _, obj = MayronUI:GetCoreComponents();

---@class GUIBuilder
local gui = MayronUI:GetComponent("GUIBuilder");

local SlideController = obj:Import("MayronUI.SlideController");
local DropDownMenu = obj:CreateClass("DropDownMenu");
obj:Export(DropDownMenu, "MayronUI");

---@class DropDownMenu
---@field Static table

DropDownMenu.Static.MAX_HEIGHT = 200;

local select, unpack, ipairs = _G.select, _G.unpack, _G.ipairs;
local tremove, tsort, tinsert = _G.table.remove, _G.table.sort, _G.table.insert;
local PlaySound = _G.PlaySound;

-- Local Functions -------------------------------
local dropdowns = {};

-- @param exclude - for all except the excluded dropdown menu
local function FoldAll(exclude)
  for _, dropdown in ipairs(dropdowns) do
    if ((not exclude) or (exclude and exclude ~= dropdown)) then
      dropdown:Hide();
    end
  end

  if (not exclude and DropDownMenu.Static.Menu) then
    DropDownMenu.Static.Menu:Hide();
  end
end

local function DropDownToggleButton_OnClick(self)
  if (self.menuParent) then
    DropDownMenu.Static.Menu:SetParent(self.menuParent);
  end
  DropDownMenu.Static.Menu:SetFrameStrata("TOOLTIP");
  self.dropdown:Toggle(not self.dropdown:IsExpanded());
  FoldAll(self.dropdown);
end

-- can't remember why this is needed
local function OnSizeChanged(self, _, height)
  self:SetWidth(height);
end

function gui:FoldAllDropDownMenus(exclude)
  FoldAll(exclude);
end

local function DropDownContainer_OnHide()
  DropDownMenu.Static.Menu:Hide();
end

function gui:CreateDropDown(parent, direction, menuParent)
  if (not DropDownMenu.Static.Menu) then
    DropDownMenu.Static.Menu = self:CreateScrollFrame(_G.UIParent, "MUI_DropDownMenu");

    if (_G.BackdropTemplateMixin) then
      _G.Mixin(DropDownMenu.Static.Menu, _G.BackdropTemplateMixin);
      DropDownMenu.Static.Menu:OnBackdropLoaded();
      DropDownMenu.Static.Menu:SetScript("OnSizeChanged", DropDownMenu.Static.Menu.OnBackdropSizeChanged);
    end

    DropDownMenu.Static.Menu:Hide();
    DropDownMenu.Static.Menu:SetBackdrop(tk.Constants.BACKDROP);

    local r, g, b = tk:GetThemeColor();
    r, g, b = r*0.7, g*0.7, b*0.7;
    DropDownMenu.Static.Menu:SetBackdropBorderColor(r, g, b);
    DropDownMenu.Static.Menu:SetScript("OnHide", FoldAll);

    tk:SetBackground(DropDownMenu.Static.Menu, 0, 0, 0, 0.9);
    tinsert(_G["UISpecialFrames"], "MUI_DropDownMenu");
  end

  local frame = tk:CreateFrame("Button", parent);
  frame:SetSize(178, 28);
  frame:SetScript("OnHide", DropDownContainer_OnHide);

  frame.toggleButton = self:CreateButton(frame);
  frame.toggleButton:SetSize(28, 28);
  frame.toggleButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT");
  frame.toggleButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT");
  frame.toggleButton:SetScript("OnSizeChanged", OnSizeChanged);

  frame.toggleButton.arrow = frame.toggleButton:CreateTexture(nil, "OVERLAY");
  frame.toggleButton.arrow:SetTexture(tk:GetAssetFilePath("Textures\\Widgets\\SmallArrow"));
  frame.toggleButton.arrow:SetPoint("CENTER");
  frame.toggleButton.arrow:SetSize(16, 16);

  frame.child = tk:CreateFrame("Frame", DropDownMenu.Static.Menu);
  tk:SetFullWidth(frame.child);

  frame.toggleButton.child = frame.child; -- needed for OnClick
  frame.toggleButton:SetScript("OnClick", DropDownToggleButton_OnClick);

  if (menuParent) then
    frame.toggleButton.menuParent = menuParent;
  end

  local header = tk:CreateBackdropFrame("Frame", frame, nil);
  header:SetPoint("TOPLEFT", frame);
  header:SetPoint("BOTTOMRIGHT", frame.toggleButton, "BOTTOMLEFT", -2, 0);
  header:SetBackdrop(tk.Constants.BACKDROP);
  header.bg = tk:SetBackground(header, tk:GetAssetFilePath("Textures\\Widgets\\Button"));

  direction = (direction or "DOWN"):upper();

  if (direction == "DOWN") then
    frame.toggleButton.arrow:SetTexCoord(1, 0, 1, 0);
  elseif (direction == "UP") then
    frame.toggleButton.arrow:SetTexCoord(0, 1, 0, 1);
  end

  ---@type MayronUI.SlideController
  local slideController = SlideController(DropDownMenu.Static.Menu, "VERTICAL");
  slideController:SetMinValue(1);

  slideController:OnEndRetract(function(_, f)
    f:Hide();
  end);

  frame.dropdown = DropDownMenu(header, direction, slideController, frame);
  frame.toggleButton.dropdown = frame.dropdown; -- needed for OnClick
  tinsert(dropdowns, frame.dropdown);

  return frame.dropdown;
end

-----------------------------------
-- DropDownMenu Object
-----------------------------------
local function OnDropDownEnter(frame)
  local tooltip = _G.GameTooltip;
  tooltip:SetOwner(frame, "ANCHOR_TOPLEFT", 0, 2);

  if (frame.isEnabled) then
    tooltip:AddLine(frame.tooltip);
  else
    tooltip:AddLine(frame.disabledTooltip);
  end

  tooltip:Show();
end

obj:DefineParams("Frame", "string", "SlideController", "Frame")
function DropDownMenu:__Construct(data, header, direction, slideController, frame)
  data.header = header;
  data.direction = direction;
  data.slideController = slideController;
  data.scrollHeight = 0;
  data.frame = frame;
  data.menu = DropDownMenu.Static.Menu;
  data.options = obj:PopTable();

  data.label = data.header:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  data.label:SetPoint("LEFT", 10, 0);
  data.label:SetPoint("RIGHT", -10, 0);
  data.label:SetWordWrap(false);
  data.label:SetJustifyH("LEFT");

  -- disabled by default (until an option is added)
  self:SetEnabled(false);
end

function DropDownMenu:SetParent(data, parent)
  -- this is needed to fix setting a new parent bug
  data.frame:SetParent(parent);
  data.header:SetParent(parent);
end

function DropDownMenu:GetMenu(data)
  return data.menu;
end

function DropDownMenu:SetSortingEnabled(data, enable)
  if (enable) then
    data.disableSorting = nil;
  else
    data.disableSorting = true;
  end
end

do
  local function ApplyTooltipScripts(f)
    f:SetScript("OnEnter", OnDropDownEnter);
    f:SetScript("OnLeave", tk.HandleTooltipOnLeave);
  end

  function DropDownMenu:SetTooltip(data, tooltip)
    data.frame.tooltip = tooltip;
    ApplyTooltipScripts(data.frame);
  end

  function DropDownMenu:SetDisabledTooltip(data, disabledTooltip)
    data.frame.disabledTooltip = disabledTooltip;
    ApplyTooltipScripts(data.frame);
  end
end

obj:DefineParams("string");
function DropDownMenu:SetLabel(data, text)
  data.label:SetText(text);
end

obj:DefineReturns("?string");
function DropDownMenu:GetLabel(data)
  return data.label and data.label:GetText();
end

obj:DefineReturns("number");
function DropDownMenu:GetNumOptions(data)
  return #data.options;
end

obj:DefineParams("number");
obj:DefineReturns("Button");
function DropDownMenu:GetOptionByID(data, optionID)
  local foundOption = data.options[optionID];
  obj:Assert(foundOption, "DropDownMenu.GetOption failed to find option with id '%s'.", optionID);
  return foundOption;
end

obj:DefineParams("string");
obj:DefineReturns("?Button");
function DropDownMenu:GetOptionByLabel(data, label)
  for _, optionButton in ipairs(data.options) do
    if (optionButton:GetText() == label) then
      return optionButton;
    end
  end
end

obj:DefineParams("function");
obj:DefineReturns("?Button");
function DropDownMenu:FindOption(data, func)
  for id, optionButton in ipairs(data.options) do
    if (func(optionButton, id)) then return optionButton; end
  end
end

obj:DefineParams("string");
function DropDownMenu:RemoveOptionByLabel(data, label)
  for optionID, optionButton in ipairs(data.options) do
    if (optionButton:GetText() == label) then
      tremove(data.options, optionID);
      tk:KillElement(optionButton);
      self:RepositionOptions();

      if (#data.options == 0) then
        self:SetEnabled(false);
      end
    end
  end
end

function DropDownMenu:AddOptions(_, func, optionsTable)
  for _, optionValues in ipairs(optionsTable) do
    local label = optionValues[1];
    self:AddOption(label, func, select(2, unpack(optionValues)));
  end
end

do
  local function SortByLabel(a, b)
    return a:GetText() < b:GetText();
  end

  function DropDownMenu:RepositionOptions(data)
    local child = data.frame.child;
    local height = 30;

    if (not data.disableSorting) then
      tsort(data.options, SortByLabel);
    end

    for _, option in ipairs(data.options) do
      option:ClearAllPoints();
    end

    for id, option in ipairs(data.options) do
      if (id == 1) then
        if (data.direction == "DOWN") then
          option:SetPoint("TOPLEFT", 2, -2);
          option:SetPoint("TOPRIGHT", -2, -2);
        elseif (data.direction == "UP") then
          option:SetPoint("BOTTOMLEFT", 2, 2);
          option:SetPoint("BOTTOMRIGHT", -2, 2);
        end
      else
        local previousOption = data.options[id - 1];

        if (data.direction == "DOWN") then
          option:SetPoint("TOPLEFT", previousOption, "BOTTOMLEFT", 0, -1);
          option:SetPoint("TOPRIGHT", previousOption, "BOTTOMRIGHT", 0, -1);
        elseif (data.direction == "UP") then
          option:SetPoint("BOTTOMLEFT", previousOption, "TOPLEFT", 0, 1);
          option:SetPoint("BOTTOMRIGHT", previousOption, "TOPRIGHT", 0, 1);
        end

        height = height + 27;
      end
    end

    data.scrollHeight = height;
    child:SetHeight(height);

    if (DropDownMenu.Static.Menu:IsShown()) then
      DropDownMenu.Static.Menu:SetHeight(height);
    end
  end
end

function DropDownMenu:AddOption(data, label, func, ...)
  local child = data.frame.child;
  local option = tk:CreateFrame("Button", child);

  option:SetHeight(26);
  option:SetNormalFontObject("GameFontHighlight");
  option:SetText(label or " ");

  local optionFontString = option:GetFontString()--[[@as FontString]];
  optionFontString:ClearAllPoints();
  optionFontString:SetPoint("LEFT", 10, 0);
  optionFontString:SetPoint("RIGHT", -10, 0);
  optionFontString:SetWordWrap(false);
  optionFontString:SetJustifyH("LEFT");

  option:SetNormalTexture(1);
  option:SetHighlightTexture(1);

  tk:ApplyThemeColor(0.4, option:GetNormalTexture(), option:GetHighlightTexture());

  local args = obj:PopTable(...);
  option.args = args;
  option:SetScript("OnClick", function()
    self:SetLabel(option:GetText());
    self:Toggle(false);

    if (not func) then return end

    if (obj:IsTable(func)) then
      local tbl = func[1];
      local methodName = func[2];

      tbl[methodName](tbl, self, unpack(args));
    else
      func(self, unpack(args));
    end
  end);

  tinsert(data.options, option);
  self:RepositionOptions();
  self:SetEnabled(true);

  return option;
end

function DropDownMenu:ApplyThemeColor(data)
  local r, g, b = tk:GetThemeColor();
  r, g, b = r*0.7, g*0.7, b*0.7;

  if (data.frame.isEnabled) then
    data.header:SetBackdropBorderColor(r, g, b);
    data.header.bg:SetVertexColor(r, g, b, 0.6);

    data.frame.toggleButton:GetNormalTexture():SetVertexColor(r, g, b, 0.6);
    data.frame.toggleButton:GetHighlightTexture():SetVertexColor(r, g, b, 0.3);
    data.frame.toggleButton:SetBackdropBorderColor(r, g, b);

    data.frame.toggleButton.arrow:SetAlpha(1);
    data.label:SetTextColor(1, 1, 1);
  else
    local disabledR, disabledG, disabledB = _G.DISABLED_FONT_COLOR:GetRGB();

    data.header:SetBackdropBorderColor(disabledR, disabledG, disabledB);
    data.header.bg:SetVertexColor(disabledR, disabledG, disabledB, 0.6);
    data.frame.toggleButton:SetBackdropBorderColor(disabledR, disabledG, disabledB);

    data.frame.toggleButton.arrow:SetAlpha(0.5);
    data.label:SetTextColor(disabledR, disabledG, disabledB);
  end

  DropDownMenu.Static.Menu:SetBackdropBorderColor(r, g, b);
  DropDownMenu.Static.Menu.ScrollBar.thumb:SetVertexColor(r, g, b, 0.8);

  for _, option in ipairs(data.options) do
    option:GetNormalTexture():SetColorTexture(r, g, b, 0.4);
    option:GetHighlightTexture():SetColorTexture(r, g, b, 0.4);
  end
end

function DropDownMenu:SetEnabled(data, enabled)
  if (data.frame.isEnabled == enabled) then
    return;
  end

  data.frame.toggleButton:SetEnabled(enabled);
  data.frame.isEnabled = enabled; -- required for using the correct tooltip
  self:ApplyThemeColor();
end

function DropDownMenu:SetHeaderShown(data, shown)
  data.header:SetShown(shown);
end

-- Unlike Toggle(), this function hides the menu instantly (does not fold)
function DropDownMenu:Hide(data)
  data.expanded = false;
  data.frame.child:Hide();

  if (data.direction == "DOWN") then
    data.frame.toggleButton.arrow:SetTexCoord(1, 0, 1, 0);
  elseif (data.direction == "UP") then
    data.frame.toggleButton.arrow:SetTexCoord(0, 1, 0, 1);
  end
end

function DropDownMenu:IsExpanded(data)
  return data.expanded;
end

function DropDownMenu:Toggle(data, show, clickSoundFilePath)
  if (not data.options) then
    -- no list of options so nothing to toggle...
    return
  end

  local step = #data.options * 4;
  step = (step > 20) and step or 20;
  step = (step < 30) and step or 30;

  DropDownMenu.Static.Menu:ClearAllPoints();

  if (data.direction == "DOWN") then
    DropDownMenu.Static.Menu:SetPoint("TOPLEFT", data.frame, "BOTTOMLEFT", 0, -2);
    DropDownMenu.Static.Menu:SetPoint("TOPRIGHT", data.frame, "BOTTOMRIGHT", 0, -2);
  elseif (data.direction == "UP") then
    DropDownMenu.Static.Menu:SetPoint("BOTTOMLEFT", data.frame, "TOPLEFT", 0, 2);
    DropDownMenu.Static.Menu:SetPoint("BOTTOMRIGHT", data.frame, "TOPRIGHT", 0, 2);
  end

  if (show) then
    local maxHeight = (data.scrollHeight < DropDownMenu.Static.MAX_HEIGHT)
    and data.scrollHeight or DropDownMenu.Static.MAX_HEIGHT;

    DropDownMenu.Static.Menu.ScrollFrame:SetScrollChild(data.frame.child);
    DropDownMenu.Static.Menu:SetHeight(1);

    data.frame.child:Show();
    data.slideController:SetMaxValue(maxHeight);

    if (data.direction == "DOWN") then
      data.frame.toggleButton.arrow:SetTexCoord(0, 1, 0, 1);
    elseif (data.direction == "UP") then
      data.frame.toggleButton.arrow:SetTexCoord(1, 0, 1, 0);
    end
  else
    if (data.direction == "DOWN") then
      data.frame.toggleButton.arrow:SetTexCoord(1, 0, 1, 0);
    elseif (data.direction == "UP") then
      data.frame.toggleButton.arrow:SetTexCoord(0, 1, 0, 1);
    end
  end

  data.slideController:SetStepValue(step);
  data.slideController:Start();

  if (clickSoundFilePath) then
    PlaySound(clickSoundFilePath);
  end

  data.expanded = show;
end