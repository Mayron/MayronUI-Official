local MayronUI = _G.MayronUI;
local tk = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils

function Components.tabs(parent, config)

  local container = tk:CreateFrame("Frame", parent);
  tk:SetFullWidth(container, 20);

  for _, tabConfig in ipairs(config.children) do
    local btn = tk:CreateFrame("CheckButton", parent);
    btn:SetNormalFontObject("GameFontHighlight");
    btn:SetDisabledFontObject("GameFontDisable");

    btn:SetText(tabConfig.name);

    btn.configTable = tabConfig;
    btn.type = "submenu";
    btn.name = tabConfig.name;

    btn:SetScript("OnClick", Utils.OnMenuButtonClick);

    if (config.tooltip) then
      tk:SetBasicTooltip(btn, config.tooltip);
    end
  end

  return container;
end