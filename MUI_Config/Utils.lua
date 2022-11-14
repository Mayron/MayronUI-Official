-- luacheck: ignore self
local _G = _G;
local MayronUI, strupper = _G.MayronUI, _G.string.upper;
local tk, db, _, _, obj = MayronUI:GetCoreComponents();

---@class ConfigMenuUtils
local Utils = MayronUI:NewComponent("ConfigMenuUtils");

function Utils:SetComponentEnabled(component, enabled)
  if (obj:IsFunction(enabled)) then
    component:SetEnabled(enabled());
  elseif (enabled ~= nil) then
    if (obj:IsString(enabled)) then
      enabled = db:ParsePathValue(enabled);
    end

    component:SetEnabled(enabled);
  else
    component:SetEnabled(true);
  end
end

function Utils:SetShown(frame, shown)
  if (obj:IsFunction(shown)) then
    frame:SetShown(shown());
  elseif (shown ~= nil) then
    frame:SetShown(shown);
  else
    frame:SetShown(true);
  end
end

--- This function wraps the widget inside of a new container with a "name" fontstring label.
function Utils:WrapInNamedContainer(component, name)
  local oldParent = component:GetParent();
  local container = tk:CreateFrame("Frame", oldParent);
  component:SetParent(container);

  container:SetWidth(component:GetWidth());

  -- this is needed to access the component from the container
  -- which is passed to some config functions (i.e. OnLoad):
  container.component = component;

  container.name = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  container.name:SetPoint("TOPLEFT", 0, 0);
  container.name:SetText(name);

  container:SetHeight(component:GetHeight() + container.name:GetStringHeight() + 5);
  component:SetPoint("TOPLEFT", container.name, "BOTTOMLEFT", 0, -5);

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