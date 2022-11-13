-- luacheck: ignore self
local _G = _G;
local MayronUI, strupper = _G.MayronUI, _G.string.upper;
local tk, _, _, _, obj = MayronUI:GetCoreComponents();

---@class ConfigMenuUtils
local Utils = MayronUI:NewComponent("ConfigMenuUtils");

function Utils:SetWidgetEnabled(widget, enabled)
  if (obj:IsFunction(enabled)) then
    widget:SetEnabled(enabled());
  elseif (enabled ~= nil) then
    widget:SetEnabled(enabled);
  else
    widget:SetEnabled(true);
  end
end

function Utils:SetContainerShown(container, shown)
  if (obj:IsFunction(shown)) then
    container:SetShown(shown());
  elseif (shown ~= nil) then
    container:SetShown(shown);
  else
    container:SetShown(true);
  end
end

function Utils:CreateElementContainerFrame(widget, widgetTable, parent)
  local container = tk:CreateFrame("Frame", parent);
  container:SetSize(widgetTable.width or widget:GetWidth(), widgetTable.height or widget:GetHeight());
  widget:SetParent(container);

  -- this is needed to access the widget from the container
  -- which is passed to some config functions (i.e. OnLoad):
  container.widget = widget;

  -- widget must have access to container to use properties,
  -- such as SetValue() for dropdown menus:
  widget.configContainer = container;

  if (widgetTable.name and tk:ValueIsEither(widgetTable.type, "slider", "dropdown", "textfield")) then
    container.name = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    container.name:SetPoint("TOPLEFT", 0, 0);
    container.name:SetText(widgetTable.name);

    container:SetHeight(container:GetHeight() + container.name:GetStringHeight() + 5);
    widget:SetPoint("TOPLEFT", container.name, "BOTTOMLEFT", 0, -5);
  else
    widget:SetPoint("LEFT");
  end

  self:SetWidgetEnabled(widget, widgetTable.enabled);
  self:SetContainerShown(container, widgetTable.shown);

  return container;
end

function Utils:GetAttribute(configTable, attributeName, ...)
  if (configTable[attributeName] ~= nil) then
    return configTable[attributeName];
  end

  local funcName = tk.Strings:Concat("Get", (attributeName:gsub("^%l", strupper)));

  if (obj:IsFunction(configTable[funcName])) then
    return configTable[funcName](configTable, ...);
  end

  obj:Error("Required attribute '%s' missing for %s widget in config table '%s' using database path '%s'",
    attributeName, configTable.type, configTable.name, configTable.dbPath);
end

function Utils:HasAttribute(configTable, attributeName)
  if (configTable[attributeName] ~= nil) then
    return true;
  end

  local funcName = tk.Strings:Concat("Get", (attributeName:gsub("^%l", strupper)));

  if (obj:IsFunction(configTable[funcName])) then
    return true;
  end

  return false;
end

function Utils.OnMenuButtonClick(menuButton)
  if (menuButton:IsObjectType("CheckButton") and not menuButton:GetChecked()) then
    -- should not be allowed to uncheck a menu button by clicking it a second time!
    menuButton:SetChecked(true);
    return
  end

  local configMenu = MayronUI:ImportModule("ConfigMenu"); ---@type ConfigMenuModule
  configMenu:OpenMenu(menuButton);
end