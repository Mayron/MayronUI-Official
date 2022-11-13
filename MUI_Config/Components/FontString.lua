local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, _, obj = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils
local tconcat = _G.table.concat;

local function FontString_OnSizeChanged(self)
  if (self.runningScript) then return end

  self.runningScript = true;
  local expectedHeight = self.content:GetStringHeight() + 20;

  if (expectedHeight ~= self:GetHeight()) then
    self:SetHeight(expectedHeight);
  end

  local parent = self:GetParent();

  if (parent.originalHeight and
    parent.originalHeight < expectedHeight and
    expectedHeight ~= parent:GetHeight()) then

    parent:SetHeight(expectedHeight);
  end

  self.runningScript = nil;
end

-- supported fontstring config attributes:
-- content - the fontstring text to display
-- subtype - Can be used to change the font object. Supports "header" only (for now).
-- justify - overrides the default horizontal justification ("LEFT")
-- height - overrides the default height of 30
-- width - overrides the default width (and ignores the fixedWidth attribute) with a specific width
-- fixedWidth - overrides the default container width with the natural width of the fontstring

function Components.fontstring(parent, widgetTable)
  local container = tk:CreateFrame("Frame", parent);

  container.content = container:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
  container.content:SetAllPoints(true);
  container.content:SetWordWrap(true);

  if (widgetTable.justify) then
    container.content:SetJustifyH(widgetTable.justify);
  else
    container.content:SetJustifyH("LEFT");
  end

  if (widgetTable.subtype) then
    if (widgetTable.subtype == "header") then
      container.content:SetFontObject("MUI_FontLarge");
    end
  end

  if (Utils:HasAttribute(widgetTable, "list")) then
    local list = Utils:GetAttribute(widgetTable, "list");

    for i = 1, #list do
      list[i] = "|TInterface/Addons/MUI_Core/Assets/Icons/arrow:12:22|t " .. list[i];
    end

    local content = tconcat(list, "\n");
    container.content:SetText(content);
  else
    local content = Utils:GetAttribute(widgetTable, "content");
    container.content:SetText(content);
  end

  if (widgetTable.height) then
    container:SetHeight(widgetTable.height);
  else
    container:SetHeight(container.content:GetStringHeight());
    container:SetScript("OnSizeChanged", FontString_OnSizeChanged);
  end

  if (obj:IsNumber(widgetTable.width)) then
    container:SetWidth(widgetTable.width);
  elseif (widgetTable.fixedWidth) then
    container:SetWidth(container.content:GetStringWidth());
  else
    tk:SetFullWidth(container, 20);
  end

  return container;
end