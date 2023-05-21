local MayronUI = _G.MayronUI;
local tk = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils

function Components.submenu(parent, config)
  local btn = tk:CreateFrame("Button", parent);
  btn:SetSize(250, 60);
  btn:SetNormalFontObject("GameFontHighlight");
  btn:SetDisabledFontObject("GameFontDisable");

  Utils:SetComponentEnabled(btn, config.enabled);

  btn:SetText(config.name);
  btn.text = btn:GetFontString();
  btn.text:SetJustifyH("LEFT");
  btn.text:ClearAllPoints();
  btn.text:SetPoint("TOPLEFT", 10, 0);
  btn.text:SetPoint("BOTTOMRIGHT");

  btn.normal = tk:SetBackground(btn);
  btn.disabled = tk:SetBackground(btn);
  btn.highlight = tk:SetBackground(btn);

  tk:ApplyThemeColor(btn.normal, btn.highlight);

  btn.normal:SetAlpha(0.3);
  btn.disabled:SetAlpha(0.3);
  btn.highlight:SetAlpha(0.3);

  btn:SetNormalTexture(btn.normal);
  btn:SetDisabledTexture(btn.disabled);
  btn:SetHighlightTexture(btn.highlight);

  btn.configTable = config;
  btn.type = "submenu";
  btn.name = config.name;

  btn:SetScript("OnClick", Utils.OnMenuButtonClick);

  if (config.tooltip) then
    tk:SetBasicTooltip(btn, config.tooltip);
  end

  return btn;
end