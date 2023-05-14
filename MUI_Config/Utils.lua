-- luacheck: ignore self
local _G = _G;
local MayronUI, strupper = _G.MayronUI, _G.string.upper;
local tk, _, _, _, obj, L = MayronUI:GetCoreComponents();
local tostring = _G.tostring;

---@class ConfigMenuUtils
local Utils = MayronUI:NewComponent("ConfigMenuUtils");

local function GetDefaultValue(config)
  local default;
  if (config.dbFramework == "orbitus") then
    local db = MayronUI:GetComponent(config.database)--[[@as OrbitusDB.DatabaseMixin]];
    default = db.utilities:QueryDefaults(config.dbPath);
  else
    local db = MayronUI:GetComponent(config.database or "Database");
    default = db:GetDefault(config.dbPath);
  end

  return default;
end

function Utils:SetComponentEnabled(component, enabled)
  if (obj:IsFunction(enabled)) then
    component:SetEnabled(enabled());
  elseif (enabled ~= nil) then
    if (obj:IsString(enabled)) then
      if (component.dbFramework == "orbitus") then
        local db = MayronUI:GetComponent(component.database)--[[@as OrbitusDB.DatabaseMixin]];
        local repo = db.utilities:GetRepositoryFromQuery(enabled);
        enabled = repo:Query(enabled);
      else
        local db = MayronUI:GetComponent("Database");
        enabled = db:ParsePathValue(enabled);
      end
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
function Utils:WrapInNamedContainer(component, config)
  local oldParent = component:GetParent();
  local container = tk:CreateFrame("Frame", oldParent);
  component:SetParent(container);

  local currentWidth = component:GetWidth();
  container:SetWidth(currentWidth);

  -- this is needed to access the component from the container
  -- which is passed to some config functions (i.e. OnLoad):
  container.component = component;
  component.wrapper = container;

  container.name = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  container.name:SetPoint("TOPLEFT", 0, -6);
  container.name:SetText(config.name);

  local desiredWidth = container.name:GetStringWidth() or 0;
  local default = GetDefaultValue(config);
  local canReset = obj:IsString(default) or obj:IsNumber(default) or obj:IsBoolean(default);

  if (obj:IsFunction(component.Reset) and canReset) then
    container.reset = _G.CreateFrame("Button", nil, container);
    container.reset:SetPoint("LEFT", container.name, "RIGHT", 6, 0);
    container.reset:SetSize(12, 12);
    desiredWidth = desiredWidth + 18; -- 12 + 6 for spacing between text and reset button
    container.reset:SetNormalTexture(tk:GetAssetFilePath("Textures\\refresh"));
    container.reset:GetNormalTexture():SetVertexColor(tk:GetThemeColor());
    container.reset:SetHighlightAtlas("chatframe-button-highlight");

    local dbPath = config.dbPath;
    tk:SetBasicTooltip(container.reset, L["Reset to default"]);

    container.reset:SetScript("OnClick", function()
      if (component.dbFramework == "orbitus") then
        local db = MayronUI:GetComponent(component.database)--[[@as OrbitusDB.DatabaseMixin]];
        local repo = db.utilities:GetRepositoryFromQuery(dbPath);
        repo:Store(dbPath, nil);
      else
        local db = MayronUI:GetComponent("Database");
        db:SetPathValue(dbPath, default);
      end

      component:Reset(default);
    end);
  end

  if (desiredWidth > currentWidth) then
    container:SetWidth(desiredWidth + 6);
    component:SetWidth(desiredWidth);
  end

  container:SetHeight(component:GetHeight() + container.name:GetStringHeight() + 8 + 6 + 4);
  component:SetPoint("TOPLEFT", container.name, "BOTTOMLEFT", 0, -8);

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

  local configMenu = MayronUI:ImportModule("ConfigMenu");
  configMenu:OpenMenu(menuButton);
end

function Utils:AppendDefaultValueToTooltip(config)
  if (not tk.Strings:Contains(config.tooltip, L["Default value is"]) and config.dbPath) then
    local default = GetDefaultValue(config);

    if (obj:IsNumber(default) or obj:IsString(default) or obj:IsBoolean(default)) then
      local defaultTooltip = tk.Strings:JoinWithSpace(L["Default value is"], tostring(default));

      if (obj:IsString(config.tooltip)) then
        config.tooltip = tk.Strings:Join("\n\n", config.tooltip, defaultTooltip);
      else
        config.tooltip = defaultTooltip;
      end
    end
  end
end

function Utils:SetBasicTooltip(widget, config)
  self:AppendDefaultValueToTooltip(config);

  if (obj:IsString(config.tooltip)) then
    tk:SetBasicTooltip(widget, config.tooltip, "ANCHOR_TOP");
  end
end