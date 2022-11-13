local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, gui, obj = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");
local Utils = MayronUI:GetComponent("ConfigMenuUtils");
local configModule = MayronUI:ImportModule("ConfigMenu"); ---@type ConfigMenuModule

local tostring, pairs, tonumber = _G.tostring, _G.pairs, _G.tonumber;

local function DropDown_OnSelectedValue(self, value, onClick)
  configModule:SetDatabaseValue(self.configContainer, value);

  if (obj:IsFunction(onClick)) then
    onClick(value, self);
  end
end

function Components.dropdown(parent, widgetTable, value)
  local widget = gui:CreateDropDown(parent);

  if (widgetTable.width) then
    widget:SetWidth(widgetTable.width);
  end

  widget:SetLabel(tostring(value));

  if (widgetTable.disableSorting) then
    widget:SetSortingEnabled(false);
  end

  local options = Utils:GetAttribute(widgetTable, "options");

  for key, dropDownValue in pairs(options) do
    local option;

    if (tonumber(key) or widgetTable.labels == "values") then
      option = widget:AddOption(dropDownValue, DropDown_OnSelectedValue, dropDownValue, widgetTable.OnClick);
    else
      if (dropDownValue == "nil") then
        dropDownValue = nil; -- cannot assign nil's to key/value pairs
      end

      option = widget:AddOption(key, DropDown_OnSelectedValue, dropDownValue);

      if (dropDownValue == value) then
        widget:SetLabel(key);
      end
    end

    if (widgetTable.fontPicker) then
      option:GetFontString():SetFont(tk.Constants.LSM:Fetch("font", key), 11);
    end
  end

  if (widgetTable.tooltip) then
    widget:SetTooltip(widgetTable.tooltip);
  end

  if (widgetTable.disabledTooltip) then
    widget:SetDisabledTooltip(widgetTable.disabledTooltip);

  elseif (widgetTable.tooltip) then
    widget:SetTooltip(widgetTable.tooltip);
  end

  return Utils:CreateElementContainerFrame(widget, widgetTable, parent);
end