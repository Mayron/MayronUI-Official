local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, gui, obj = MayronUI:GetCoreComponents();
local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils"); ---@type ConfigMenuUtils
local configModule = MayronUI:ImportModule("ConfigMenu"); ---@type ConfigMenuModule

local tonumber, tostring = _G.tonumber, _G.tostring;

local function TextField_OnTextChanged(textfield, value, _, container)
  -- perform validation based on valueType
  local isValue = true;

  -- ensure database stores a number, instead of a string containing a number
  value = tonumber(value) or value;

  if (container.valueType == "number") then
    if (not obj:IsNumber(value)) then
      isValue = false;
    else
      if (container.min and value < container.min) then
        isValue = false;
      end
      if (container.max and value > container.max) then
        isValue = false;
      end
    end
  end

  if (not isValue) then
    textfield:ApplyPreviousText();
  else
    textfield:SetText(value);
    configModule:SetDatabaseValue(container, value);
  end
end

-- supported textield config attributes:
-- tooltip - the fontstring text to display
-- width - Can be used to change the font object. Supports "header" only (for now).
-- height - overrides the default horizontal justification ("LEFT")
-- valueType - overrides the default height of 30
-- min - minimum value allowed
-- max - maximum value allowed
function Components.textfield(parent, config, value)
  local textField = gui:CreateTextField(parent);

  if (config.width) then
    textField:SetWidth(config.width);
  end

  if (config.height) then
    textField:SetHeight(config.height);
  end

  textField:SetText((value and tostring(value)) or tk.Strings.Empty);
  Utils:SetComponentEnabled(textField, config.enabled);

  local container = Utils:WrapInNamedContainer(textField, config);
  Utils:SetBasicTooltip(textField:GetEditBox(), config);

  textField:OnTextChanged(TextField_OnTextChanged, container);
  
  Utils:SetShown(container, config.shown);
  return container;
end