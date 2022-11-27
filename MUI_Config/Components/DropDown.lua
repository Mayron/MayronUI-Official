local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, gui = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils
local configModule = MayronUI:ImportModule("ConfigMenu"); ---@type ConfigMenuModule

local tostring, pairs, tonumber = _G.tostring, _G.pairs, _G.tonumber;

-- We use "OnValueChanged" in SetDatabaseValue (even if no dbPath!)
-- to use a globally supported callback that is usable for each component type.
-- Therefore, we don't need to do anything special for this callback except to
-- get the correct container frame (the one with all the config key/value mappings).
local function OnDropDownValueChanged(dropdown, value)
  local container = dropdown:GetFrame();

  if (container.wrapper) then
    container = container.wrapper; -- using a named container wrapper
  end

  configModule:SetDatabaseValue(container, value);
end

function Components.dropdown(parent, config, value)
  local dropdown = gui:CreateDropDown(parent); ---@type DropDownMenu

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
      option = dropdown:AddOption(optionValue, OnDropDownValueChanged, optionValue);
    else
      if (optionValue == "nil") then
        optionValue = nil; -- cannot assign nil's to key/value pairs
      end

      option = dropdown:AddOption(key, OnDropDownValueChanged, optionValue);

      if (optionValue == value) then
        dropdown:SetLabel(key);
      end
    end

    if (config.fontPicker) then
      option:GetFontString():SetFont(tk.Constants.LSM:Fetch("font", key), 11);
    end
  end

  Utils:AppendDefaultValueToTooltip(config);

  if (config.tooltip) then
    dropdown:SetTooltip(config.tooltip);
  end

  if (config.disabledTooltip) then
    dropdown:SetDisabledTooltip(config.disabledTooltip);

  elseif (config.tooltip) then
    dropdown:SetDisabledTooltip(config.tooltip);
  end

  Utils:SetComponentEnabled(dropdown, config.enabled);

  local dropdownFrame = dropdown:GetFrame();
  local container = dropdownFrame; -- has .dropdown to refer back to dropdown

  if (config.name) then
    container = Utils:WrapInNamedContainer(dropdownFrame, config);
  end

  Utils:SetShown(container, config.shown);
  return container;
end