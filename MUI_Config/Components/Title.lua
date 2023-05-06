local MayronUI = _G.MayronUI;
local tk = MayronUI:GetCoreComponents();
local Components = MayronUI:GetComponent("ConfigMenuComponents");

local function UpdateContainerHeight(self)
  if (self.runningScript) then return end
  self.runningScript = true;

  local containerHeight = self.title:GetStringHeight();

  if (self.description) then
    containerHeight = containerHeight + self.description:GetStringHeight() + 4;
  end

  containerHeight = containerHeight + self.paddingTop + self.marginTop + self.paddingBottom + self.marginBottom;

  if (containerHeight ~= self:GetHeight()) then
    self:SetHeight(containerHeight);
  end

  self.runningScript = nil;
end

-- supported title config attributes:
-- name - the container name (a visible fontstring that shows in the GUI)
-- description (optional) - a 2nd sub-title for the description
-- paddingTop - space between top of background and top of name
-- paddingBottom - space between bottom of background and bottom of name
-- marginTop
-- marginBottom
function Components.title(parent, config)
  local container = tk:CreateFrame("Frame", parent);
  container:SetSize(300, 50); -- needs to be set

  container.marginTop = config.marginTop or 10;
  container.marginBottom = config.marginBottom or 0;
  container.paddingTop = config.paddingTop or 10;
  container.paddingBottom = config.paddingBottom or 10;

  local background = tk:SetBackground(container, 0, 0, 0, 0.2);
  background:ClearAllPoints();
  background:SetPoint("TOPLEFT", 0, -container.marginTop);
  background:SetPoint("BOTTOMRIGHT", 0, container.marginBottom);

  container.title = container:CreateFontString(nil, "OVERLAY", "MUI_FontLarge");
  tk:SetFontSize(container.title, 14);

  if (config.description) then
    container.description = container:CreateFontString(nil, "OVERLAY", "AchievementPointsFontSmall");
    container.description:SetWordWrap(true);
    container.description:SetPoint("LEFT", 20, 0);
    container.description:SetPoint("RIGHT", -20, 0);

    container.title:SetPoint("TOP", background, "TOP", 0, -container.paddingTop);
    container.description:SetPoint("TOP", container.title, "BOTTOM", 0, -4);
    container.description:SetText(config.description);
  else
    container.title:SetAllPoints(background);
  end

  container.title:SetText(config.name:upper());

  tk:SetFullWidth(container, 10);
  container:HookScript("OnSizeChanged", UpdateContainerHeight);

  return container;
end