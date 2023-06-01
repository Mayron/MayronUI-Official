local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, gui, obj = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type MayronUI.ConfigMenuUtils
local configMenu = MayronUI:ImportModule("ConfigMenu"); ---@type MayronUI.ConfigMenu

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

  configMenu:SetDatabaseValue(container, value);
end

local function HandleDropdownReset(self, value)
  local dropdown = self.dropdown--[[@as MayronUI.DropDownMenu]];

  local option = dropdown:FindOption(function(option)
    for _, arg in ipairs(option.args) do
      if (value == arg) then
        return true;
      end
    end
  end);

  tk:Assert(option, "Failed to reset dropdown; no option for value %s found", value);
  dropdown:SetLabel(option:GetText());
end

function Components.dropdown(parent, config, value)
  local dropdown = gui:CreateDropDown(parent); ---@type MayronUI.DropDownMenu

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
      key = optionValue;

      if (type(optionValue) == "table") then
        -- its an ordered list of keys to values: `{ L["Top"], "TOP" }`
        local pair = optionValue;
        key = pair[1];
        optionValue = pair[2];
      end
    end

    if (optionValue == "nil") then
      optionValue = nil; -- cannot assign nil's to key/value pairs
    end

    option = dropdown:AddOption(key, OnDropDownValueChanged, optionValue);

      if (optionValue == value) then
        dropdown:SetLabel(key);
      end

    if (config.media == tk.Constants.LSM.MediaType.FONT) then
      local fontType = tk.Constants.LSM:Fetch(config.media, key);
      option:GetFontString():SetFont(fontType, 11);
    elseif (
      config.media == tk.Constants.LSM.MediaType.BACKGROUND or
      config.media == tk.Constants.LSM.MediaType.STATUSBAR) then

      local texturePath = tk.Constants.LSM:Fetch(config.media, key);

      if (texturePath) then
        local normalTexture = option:GetNormalTexture()--[[@as Texture]];
        normalTexture:SetTexture(texturePath);

        local highlightTexture = option:GetHighlightTexture()--[[@as Texture]];
        highlightTexture:SetTexture(texturePath);
        tk:ApplyThemeColor(normalTexture, highlightTexture);
      end
    elseif (config.media == tk.Constants.LSM.MediaType.BORDER) then
      local mixin = _G.BackdropTemplateMixin;
      local edgeFile = tk.Constants.LSM:Fetch(config.media, key);

      if (mixin and edgeFile) then
        local normalTexture = option:GetNormalTexture()--[[@as Texture]];
        normalTexture:SetDrawLayer("BACKGROUND");

        _G.Mixin(option, mixin);
        ---@cast option BackdropTemplate;
        option:SetBackdrop({
          edgeFile = edgeFile,
          edgeSize = 6,
        });
      end
    end
  end

  Utils:AppendDefaultValueToTooltip(config, options);

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
    dropdownFrame.Reset = HandleDropdownReset;
    container = Utils:WrapInNamedContainer(dropdownFrame, config);
  end

  Utils:SetShown(container, config.shown);
  return container;
end