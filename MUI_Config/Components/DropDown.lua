local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, gui, obj = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils
local configModule = MayronUI:ImportModule("ConfigMenu"); ---@type ConfigMenuModule

local tostring, pairs, tonumber = _G.tostring, _G.pairs, _G.tonumber;

local function DropDown_OnSelectedValue(self, value, onClick)
  local container = self:GetParent();
  if (not container.dbPath) then
      container = self:GetFrame();
  end

  configModule:SetDatabaseValue(container, value);

  if (obj:IsFunction(onClick)) then
    onClick(value, self);
  end
end

function Components.dropdown(parent, config, value)
  local dropdown = gui:CreateDropDown(parent);

  if (config.width) then
    dropdown:SetWidth(config.width);
  end

  dropdown:SetLabel(tostring(value));

  if (config.disableSorting) then
    dropdown:SetSortingEnabled(false);
  end

  local options = Utils:GetAttribute(config, "options");

  for key, optionValue in pairs(options) do
    local option;

    if (tonumber(key) or config.labels == "values") then
      option = dropdown:AddOption(optionValue, DropDown_OnSelectedValue, optionValue, config.OnClick);
    else
      if (optionValue == "nil") then
        optionValue = nil; -- cannot assign nil's to key/value pairs
      end

      option = dropdown:AddOption(key, DropDown_OnSelectedValue, optionValue);

      if (optionValue == value) then
        dropdown:SetLabel(key);
      end
    end

    if (config.fontPicker) then
      option:GetFontString():SetFont(tk.Constants.LSM:Fetch("font", key), 11);
    end
  end

  if (config.tooltip) then
    dropdown:SetTooltip(config.tooltip);
  end

  if (config.disabledTooltip) then
    dropdown:SetDisabledTooltip(config.disabledTooltip);

  elseif (config.tooltip) then
    dropdown:SetTooltip(config.tooltip);
  end

  Utils:SetComponentEnabled(dropdown, config.enabled);

  local container;

  if (config.name) then
    container = Utils:WrapInNamedContainer(dropdown, config.name);
  else
    container = dropdown:GetFrame();
  end

  Utils:SetShown(container, config.shown);
  return container;
end