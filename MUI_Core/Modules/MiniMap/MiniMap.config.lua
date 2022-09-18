-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db, _, _, obj, L = _G.MayronUI:GetCoreComponents();
local C_MiniMapModule = namespace.C_MiniMapModule;
local widgets = {};

local function UpdateTestModeButton(button)
  local r, g, b = tk:GetThemeColor();

  if (db.profile.minimap.testMode) then
    button:SetText(L["Disable Test Mode"]);
    button:GetNormalTexture():SetVertexColor(r * 1.2, g * 1.2, b * 1.2);
  else
    button:SetText(L["Enable Test Mode"]);
    button:GetNormalTexture():SetVertexColor(r * 0.5, g * 0.5, b * 0.5);
  end
end

local function AddShowOption(children, name, text)
  children[#children + 1] = {
    name = tk.Strings:JoinWithSpace(L["Show"], text);
    type = "check";
    appendDbPath = "show";
    height = 50;

    SetValue = function(dbPath, value)
      widgets[name].point:SetEnabled(value);
      widgets[name].x:SetEnabled(value);
      widgets[name].y:SetEnabled(value);

      if (widgets[name].fontSize) then
        widgets[name].fontSize:SetEnabled(value);
      end

      if (widgets[name].scale) then
        widgets[name].scale:SetEnabled(value);
      end

      if (db.profile.minimap.testMode) then
        widgets.testModeButton:GetScript("OnClick")(widgets.testModeButton);
      end

      db:SetPathValue(dbPath, value);
    end;
  };
end

local function AddHideOption(children, name, text, func)
  children[#children + 1] = {
    name = tk.Strings:JoinWithSpace(L["Hide"], text);
    type = "check";
    appendDbPath = "hide";
    height = 50;

    SetValue = function(dbPath, value)
      widgets[name].point:SetEnabled(not value);
      widgets[name].x:SetEnabled(not value);
      widgets[name].y:SetEnabled(not value);

      if (widgets[name].fontSize) then
        widgets[name].fontSize:SetEnabled(not value);
      end

      if (widgets[name].scale) then
        widgets[name].scale:SetEnabled(not value);
      end

      if (db.profile.minimap.testMode) then
        widgets.testModeButton:GetScript("OnClick")(widgets.testModeButton);
      end

      db:SetPathValue(dbPath, value);
      if (func) then func(); end
    end;
  };
end

local function AddFontSizeOption(children, name, settings)
  children[#children + 1] = {
    name = L["Font Size"];
    type = "slider";
    valueType = "number";
    min = 8;
    step = 1;
    max = 24;
    appendDbPath = "fontSize";
    tooltip = L["Default value is"] .. " 12";
    enabled = settings.show;
    OnLoad = function(_, container)
      widgets[name].fontSize = container.widget;
    end;
  };
end

local function AddScaleOption(children, name)
  children[#children + 1] = {
    name = L["Scale"];
    type = "slider";
    valueType = "number";
    min = 0.2;
    step = 0.1;
    max = 2;
    tooltip = L["Default value is"].." 1";
    appendDbPath = "scale";
    OnLoad = function(_, container)
      widgets[name].scale = container.widget;
    end;
  }
end

local function AddPositioningOptions(children, name, settings)
  widgets[name] = obj:PopTable();

  children[#children + 1] = {
    type = "fontstring";
    subtype = "header";
    content = L["Icon Position"];
  };

  children[#children + 1] = {
    name = L["Point"];
    type = "dropdown";
    options = tk.Constants.POINT_OPTIONS;
    appendDbPath = "point";
    enabled = settings.show;
    OnLoad = function(_, container)
      widgets[name].point = container.widget;
    end;
  };

  children[#children + 1] = {
    name        = L["X-Offset"];
    type        = "textfield";
    valueType   = "number";
    appendDbPath      = "x";
    enabled = settings.show;
    OnLoad = function(_, container)
      widgets[name].x = container.widget;
    end;
  };

  children[#children + 1] = {
    name        = L["Y-Offset"];
    type        = "textfield";
    valueType   = "number";
    appendDbPath      = "y";
    enabled = settings.show;
    OnLoad = function(_, container)
      widgets[name].y = container.widget;
    end;
  }
end

function C_MiniMapModule:GetConfigTable(data)
    return {
        type = "menu",
        module = "MiniMap",
        dbPath = "profile.minimap",
        children =  {
            {   name = L["Enabled"],
                tooltip = L["If checked, this module will be enabled."],
                type = "check",
                requiresReload = true, -- TODO: Maybe modules can be global? - move module enable/disable to general menu?
                appendDbPath = "enabled",
            },
            {   name = L["Move AddOn Buttons"],
                tooltip = L["MOVE_ADDON_BUTTONS_TOOLTIP"],
                type = "check",
                requiresReload = true,
                appendDbPath = "hideIcons",
            },
            {
              type = "divider"
            },
            {   name = L["Mini-Map Options"],
                type = "title",
                marginTop = 0;
            };
            {   name = L["Size"],
                type = "slider",
                valueType = "number",
                min = 120;
                max = 400;
                tooltip = tk.Strings:Join("\n", L["Adjust the size of the minimap."], L["Default value is"].." 200"),
                appendDbPath = "size",
            };
            {   name = L["Scale"],
                type = "slider",
                valueType = "number",
                min = 0.5;
                step = 0.1;
                max = 3;
                tooltip = tk.Strings:Join("\n", L["Adjust the scale of the minimap."], L["Default value is"].." 1"),
                appendDbPath = "scale",
            };
            {   name = L["Enable Test Mode"];
                type = "button";
                width = 200;
                tooltip = L["Test mode allows you to easily customize the looks and positioning of widgets by forcing all widgets to be shown."];
                OnLoad = function(_, button)
                  widgets.testModeButton = button;
                  UpdateTestModeButton(button);
                end;
                OnClick = function(button)
                  local testMode = not db.profile.minimap.testMode;

                  if (not testMode) then
                    -- must be before to update
                    data.testModeActive = false;
                  end

                  db.profile.minimap.testMode = testMode;

                  if (testMode) then
                    -- must be after to update
                    data.testModeActive = true;
                  else
                    obj:PushTable(data.isShown);
                  end

                  UpdateTestModeButton(button);
                end;
            };
            {   name = L["Mini-Map Widgets"],
                type = "title",
            };
            {
              name = L["Clock"];
              type = "submenu";
              appendDbPath = "widgets.clock";
              children = function()
                local children = {};
                AddHideOption(children, "clock", L["Clock"]);
                AddFontSizeOption(children, "clock", data.settings.widgets.clock);
                AddPositioningOptions(children, "clock", data.settings.widgets.clock);
                return children;
              end
            };

            {
              name = L["Dungeon Difficulty"];
              appendDbPath = "widgets.difficulty";
              type = "submenu";
              client = "retail";
              children = function()
                local children = {};
                AddShowOption(children, "difficulty", L["Dungeon Difficulty"]);
                AddFontSizeOption(children, "difficulty", data.settings.widgets.difficulty);
                AddPositioningOptions(children, "difficulty", data.settings.widgets.difficulty);
                return children;
              end
            };

            {
              name = L["Looking For Group Icon"];
              type = "submenu";
              appendDbPath = "widgets.lfg";
              client = "retail,bcc";
              children = function()
                local children = {};
                AddScaleOption(children, "lfg", data.settings.widgets.lfg);
                AddPositioningOptions(children, "lfg", data.settings.widgets.lfg);
                return children;
              end
            };

            {
              name = L["New Mail Icon"];
              type = "submenu";
              appendDbPath = "widgets.mail";
              children = function()
                local children = {};
                AddScaleOption(children, "mail", data.settings.widgets.mail);
                AddPositioningOptions(children, "mail", data.settings.widgets.mail);
                return children;
              end
            };

            {
              name = L["Missions Icon"];
              type = "submenu";
              appendDbPath = "widgets.missions";
              client = "retail";
              children = function()
                local children = {
                  {
                    type = "fontstring";
                    content = L["This button opens the most relevant missions menu for your character. The menu will either show missions for your Covenant Sanctum, Class Order Hall, or your Garrison."]
                  };
                };

                AddHideOption(children, "missions", L["Missions Icon"]);
                AddScaleOption(children, "missions", data.settings.widgets.missions);
                AddPositioningOptions(children, "missions", data.settings.widgets.missions);

                return children;
              end
            };

            {
              name = L["Tracking Icon"];
              type = "submenu";
              appendDbPath = "widgets.tracking";
              client = {"retail", "bcc"};
              children = function()
                local children = {
                  {
                    type = "fontstring";
                    content = L["When hidden, you can still access tracking options from the Minimap right-click menu."];
                  };
                };

                AddHideOption(children, "tracking", L["Tracking Icon"], function()
                  data:Call("UpdateTrackingMenuOptionVisibility");
                end);

                AddScaleOption(children, "tracking", data.settings.widgets.tracking);
                AddPositioningOptions(children, "tracking", data.settings.widgets.tracking);

                return children;
              end
            };

            {
              name = L["Zone Name"];
              type = "submenu";
              appendDbPath = "widgets.zone";
              children = function()
                local children = {};
                AddHideOption(children, "zone", L["Zone Name"]);
                AddFontSizeOption(children, "zone", data.settings.widgets.zone);
                AddPositioningOptions(children, "zone", data.settings.widgets.zone);
                return children;
              end
            };
        }
    };
end