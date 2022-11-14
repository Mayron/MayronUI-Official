local MayronUI = _G.MayronUI;
local tk = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils

function Components.submenu(parent, submenuConfigTable)
  local btn = tk:CreateFrame("Button", parent);
  btn:SetSize(250, 60);
  btn:SetNormalFontObject("GameFontHighlight");
  btn:SetDisabledFontObject("GameFontDisable");

  Utils:SetComponentEnabled(btn, submenuConfigTable.enabled);

  btn:SetText(submenuConfigTable.name);
  btn.text = btn:GetFontString();
  btn.text:SetJustifyH("LEFT");
  btn.text:ClearAllPoints();
  btn.text:SetPoint("TOPLEFT", 10, 0);
  btn.text:SetPoint("BOTTOMRIGHT");

  btn.normal = tk:SetBackground(btn, tk.Constants.SOLID_TEXTURE);
  btn.disabled = tk:SetBackground(btn, tk.Constants.SOLID_TEXTURE);
  btn.highlight = tk:SetBackground(btn, tk.Constants.SOLID_TEXTURE);

  tk:ApplyThemeColor(btn.normal, btn.highlight);

  btn.normal:SetAlpha(0.3);
  btn.disabled:SetAlpha(0.3);
  btn.highlight:SetAlpha(0.3);

  btn:SetNormalTexture(btn.normal);
  btn:SetDisabledTexture(btn.disabled);
  btn:SetHighlightTexture(btn.highlight);

  btn.configTable = submenuConfigTable;
  btn.type = "submenu";
  btn.name = submenuConfigTable.name;

  btn:SetScript("OnClick", Utils.OnMenuButtonClick);

  if (submenuConfigTable.tooltip) then
    tk:SetBasicTooltip(btn, submenuConfigTable.tooltip);
  end

  return btn;
end