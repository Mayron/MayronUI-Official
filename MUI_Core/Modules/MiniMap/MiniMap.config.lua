-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db, _, _, _, L = MayronUI:GetCoreComponents();
local C_MiniMapModule = namespace.C_MiniMapModule;
local widgets = {};

function C_MiniMapModule:GetConfigTable()
    return {
        type = "menu",
        module = "MiniMap",
        dbPath = "profile.minimap",
        children =  {
            {   name = L["Enabled"],
                tooltip = "If checked, this module will be enabled.",
                type = "check",
                requiresReload = true, -- TODO: Maybe modules can be global? - move module enable/disable to general menu?
                appendDbPath = "enabled",
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
                tooltip = tk.Strings:Join("\n", L["Adjust the size of the minimap."], L["Default value is "].."200"),
                appendDbPath = "size",
            };
            {   name = L["Scale"],
                type = "slider",
                valueType = "number",
                min = 0.5;
                step = 0.1;
                max = 3;
                tooltip = tk.Strings:Join("\n", L["Adjust the scale of the minimap."], L["Default value is "].."1"),
                appendDbPath = "scale",
            };
            {   name = L["Zone Text"],
                type = "title",
            },
            {   name = L["Show"],
                type = "check",
                appendDbPath = "zoneText.show";

                SetValue = function(dbPath, value)
                    widgets.fontStringSlider:SetEnabled(value);
                    widgets.yOffsetTextField:SetEnabled(value);
                    widgets.justifyTextDropDownMenu:SetEnabled(value);
                    db:SetPathValue(dbPath, value);
                end;

                OnLoad = function(_, widget)
                    widgets.showCheckButton = widget.btn;
                end;
            },
            {   type = "divider"
            },
            {   name = L["Font Size"],
                type = "slider",
                tooltip = tk.Strings:Join("\n", L["Adjust the font size of the zone text."], L["Default value is "].."12"),
                min = 8,
                max = 18,
                appendDbPath = "zoneText.fontSize",

                OnLoad = function(_, container)
                    widgets.fontStringSlider = container.widget;
                    container.widget:SetEnabled(widgets.showCheckButton:GetChecked());
                end;
            },
            {   name = L["Y-Offset"],
                type = "slider",
                min = -20;
                max = 20;
                step = 1;
                tooltip = L["Default value is "].."-4";
                appendDbPath = "zoneText.yOffset";

                OnLoad = function(_, container)
                    widgets.yOffsetTextField = container.widget;
                    container.widget:SetEnabled(widgets.showCheckButton:GetChecked());
                end;
            };
            {   type = "dropdown",
                name = L["Justify Text"],
                options = { Left = "LEFT", Right = "RIGHT", Center = "CENTER" },
                appendDbPath = "zoneText.justify";
                tooltip = L["Default value is "].."Center";

                OnLoad = function(_, container)
                    widgets.justifyTextDropDownMenu = container.widget.dropdown;
                    container.widget.dropdown:SetEnabled(widgets.showCheckButton:GetChecked());
                end;
            },
        }
    };
end