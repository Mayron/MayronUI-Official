local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, _, obj = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils
local ipairs = _G.ipairs;

local function UpdateContainerHeight(self)
  if (self.runningScript) then return end
  self.runningScript = true;

  local containerHeight = 0;

  if (self.content) then
    containerHeight = self.content:GetStringHeight() + self.padding;

  elseif (self.rows) then
    for _, row in ipairs(self.rows) do
      local rowHeight = row.content:GetStringHeight() + 8;
      row:SetHeight(rowHeight);

      containerHeight = containerHeight + rowHeight;
    end
  end

  if (containerHeight ~= self:GetHeight()) then
    self:SetHeight(containerHeight);
  end

  local parent = self:GetParent();

  if (parent.originalHeight) then
    -- the parent must be a custom Frame created by Components.frame.
    -- Check if child is too larger and, if so, update parent to fit it.
    if (parent.originalHeight < containerHeight and containerHeight ~= parent:GetHeight()) then
      parent:SetHeight(containerHeight);
    end
  end

  self.runningScript = nil;
end

-- supported fontstring config attributes:
-- content - the fontstring text to display
-- subtype - Can be used to change the font object. Supports "header" and "sub-header".
-- justify - overrides the default horizontal justification ("LEFT")
-- height - overrides the default height of 30
-- width - overrides the default width with a specific width
function Components.fontstring(parent, widgetTable)
  local container = tk:CreateFrame("Frame", parent);
  container.padding = widgetTable.padding or 16;

  local width = obj:IsNumber(widgetTable.width) and widgetTable.width or 300;
  local height = obj:IsNumber(widgetTable.height) and widgetTable.height or 50;
  container:SetSize(width, height);

  if (Utils:HasAttribute(widgetTable, "list")) then
    local list = Utils:GetAttribute(widgetTable, "list");
    container.rows = {};

    for i = 1, #list do
      local row = tk:CreateFrame(nil, container);
      row:SetHeight(1); -- Needed to show it (it'll instantly get resized)

      local bullet = tk:CreateFrame(nil, row);
      bullet:SetSize(20, 14);
      bullet:SetPoint("TOPLEFT", -4, 0);
      tk:SetBackground(bullet, tk:GetAssetFilePath("Icons\\crumb"));

      row.content = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
      row.content:SetWordWrap(true);
      row.content:SetJustifyH("LEFT");
      row.content:SetJustifyV("TOP");
      row.content:SetPoint("TOPLEFT", bullet, "TOPRIGHT", 2, 0);
      row.content:SetPoint("BOTTOMRIGHT");

      if (i == 1) then
        row:SetPoint("TOPLEFT");
        row:SetPoint("TOPRIGHT");
      else
        row:SetPoint("TOPLEFT", container.rows[i - 1], "BOTTOMLEFT");
        row:SetPoint("TOPRIGHT", container.rows[i - 1], "BOTTOMRIGHT");
      end

      local content = list[i];
      row.content:SetText(content);
      container.rows[i] = row;
    end
  else
    container.content = container:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    container.content:SetAllPoints(true);
    container.content:SetWordWrap(true);
    container.content:SetJustifyH(widgetTable.justifyH or "LEFT");
    container.content:SetJustifyV(widgetTable.justifyV or "MIDDLE");

    if (widgetTable.subtype == "header") then
      container.content:SetFontObject("MUI_FontLarge");
    elseif (widgetTable.subtype == "sub-header") then
      container.content:SetFontObject("AchievementPointsFontSmall");
      tk:SetFontSize(container.content, 13);
    end

    local content = Utils:GetAttribute(widgetTable, "content");
    container.content:SetText(content);
  end

  if (not obj:IsNumber(widgetTable.width)) then
    container.rightPadding = 20;
    tk:SetFullWidth(container);
  end

  if (not obj:IsNumber(widgetTable.height)) then
    container:HookScript("OnSizeChanged", UpdateContainerHeight);
  end

  return container;
end