local MayronUI = _G.MayronUI;
local tk = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils

function Components.tabs(parent, config)

  local container = tk:CreateFrame("Frame", parent);
  tk:SetFullWidth(container, 20);
  container:SetHeight(30);

  local tabs = {};
  local level = parent:GetFrameLevel();

  ---@param btn Button
  local function handleTabOnClick(btn)
    local selectedTabId = btn:GetID();
    local baseFrameLevel = level + 10;

    for i, tab in ipairs(tabs) do
      local isSelected = i == selectedTabId;
      tab.selected:SetShown(isSelected);
      tab.unselected:SetShown(not isSelected);

      if (isSelected) then
        tab:SetFrameLevel(baseFrameLevel + 10);
      else
        tab:SetFrameLevel(baseFrameLevel);
      end
    end
  end

  for i, tabConfig in ipairs(config.children) do
    local btn = tk:CreateFrame("Button", container);
    btn:SetID(i);
    tabs[i] = btn;

    local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight", 20);
    fs:SetText(tabConfig.name);
    btn:SetSize(160, 34);

    local textureName;

    if (i == 1) then
      textureName = "left";
      fs:SetPoint("CENTER", -10, 0);
    elseif (i == #config.children) then
      textureName = "right";
      fs:SetPoint("CENTER", 10, 0);
    else
      textureName = "both";
      fs:SetPoint("CENTER");
    end

    local r, g, b = tk:GetThemeColor();
    local selectedTextureFilePath = tk:GetAssetFilePath("Textures\\Tabs\\tab-"..textureName.."-selected");
    btn.selected = btn:CreateTexture(nil, "ARTWORK");
    btn.selected:SetTexture(selectedTextureFilePath);
    btn.selected:SetAllPoints(true);
    btn.selected:SetVertexColor(r, g, b);

    local unselectedTextureFilePath = tk:GetAssetFilePath("Textures\\Tabs\\tab-"..textureName.."-unselected");
    btn.unselected = btn:CreateTexture(nil, "ARTWORK");
    btn.unselected:SetTexture(unselectedTextureFilePath);
    btn.unselected:SetAllPoints(true);

    if (i == 1) then
      btn:SetPoint("TOPLEFT", container, "TOPLEFT");
      handleTabOnClick(btn);
    else
      btn:SetPoint("LEFT", tabs[i - 1], "RIGHT", -46, 0);
    end

    btn.configTable = tabConfig;
    btn.type = "submenu";
    btn.name = tabConfig.name;

    -- btn:SetScript("OnClick", Utils.OnMenuButtonClick);

    btn:SetScript("OnClick", handleTabOnClick);

    if (config.tooltip) then
      tk:SetBasicTooltip(btn, config.tooltip);
    end
  end

  return container;
end