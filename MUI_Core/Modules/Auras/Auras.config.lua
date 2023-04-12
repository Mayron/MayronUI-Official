-- luacheck: ignore MayronUI self 143 631
local MayronUI = _G.MayronUI;
local tk, _, _, _, obj, L = MayronUI:GetCoreComponents();
local db = MayronUI:GetComponent("MUI_AurasDB");
local _, C_AurasModule = MayronUI:ImportModule("AurasModule");

function C_AurasModule:GetConfigTable()

  local configMenu = MayronUI:ImportModule("ConfigMenu");

  local function GetAuraOptions(auraType)
    local iconOptionsFrame;
    local barOptionsFrame;

    return {
      {
        name = "Set Display Mode";
        type = "dropdown";
        options = { ["Icons"] = "icons", ["Bars"] = "statusbars" };
        dbPath = "profile." .. auraType .. ".mode";
        OnValueChanged = function(value)
          iconOptionsFrame:SetShown(value == "icons");
          barOptionsFrame:SetShown(value == "statusbars");
          configMenu:RefreshMenu();
        end,
      };
      {
        type = "title";
        name = "Icon Options";
        appendDbPath = "profile." .. auraType .. ".icons";
        OnLoad = function(_, frame)
          iconOptionsFrame = frame;
        end,
        children = {
          {
            type = "check";
            name = "Pulse Effect";
            tooltip = "If true, when the aura is close to expiring the aura frame will fade in and out.";
            dbPath = "pulse";
          },
          {
            type = "slider";
            name = "Set Non-Player Alpha";
            min = 0;
            max = 1;
            step = 0.1;
            tooltip = "The alpha of auras not applied by you.";
            dbPath = "nonPlayerAlpha";
          },
          {
            type = "fontstring";
            subtype="header";
            content= "Vertical Direction";
          },
          {
            name = "Up";
            type = "radio";
            groupName = auraType .. "-icons-vDirection";
            dbPath = "vDirection";
            height = 50;
            GetValue = function(_, value)
              return value == "UP";
            end;
          };
          {
            name = "Down";
            type = "radio";
            groupName = auraType .. "-icons-vDirection";
            dbPath = "vDirection";
            height = 50;
            GetValue = function(_, value)
              return value == "DOWN";
            end;
          };
          {
            type = "fontstring";
            subtype="header";
            content= "Horizontal Direction";
          },
          {
            name = "Left";
            type = "radio";
            groupName = auraType .. "-icons-hDirection";
            dbPath = "hDirection";
            height = 50;
            GetValue = function(_, value)
              return value == "LEFT";
            end;
          };
          {
            name = "Right";
            type = "radio";
            groupName = auraType .. "-icons-hDirection";
            dbPath = "hDirection";
            height = 50;
            GetValue = function(_, value)
              return value == "RIGHT";
            end;
          };
          {
            type = "slider";
            name = "Width";
            dbPath = "iconWidth";
            min = 20;
            max = 80;
            step = 1;
          };
          {
            type = "slider";
            name = "Height";
            dbPath = "iconHeight";
            min = 20;
            max = 80;
            step = 1;
          };
          {
            type = "slider";
            name = "Border Size";
            dbPath = "iconBorderSize";
            min = 0;
            max = 5;
            step = 1;
          };
          {
            type = "check";
            name = "Show Icon Shadow";
            dbPath = "iconShadow";
          };
          {
            type = "slider";
            name = "Warning Threshold (in Seconds)";
            dbPath = "secondsWarning";
            min = 0;
            max = 30;
            step = 1;
          };
          {
            type = "slider";
            name = "Auras Per Row";
            dbPath = "perRow";
            min = 5;
            max = 20;
            step = 1;
          };
          {
            name = "Row Spacing";
            type = "slider";
            min = 0;
            max = 80;
            step = 1;
            dbPath = "ySpacing";
          };
          {
            name = "Column Spacing";
            type = "slider";
            min = 0;
            max = 80;
            step = 1;
            dbPath = "xSpacing";
          };

          { type = "title", name = "Aura Frame Position Settings" };

          {
            name = L["Point"];
            type = "dropdown";
            options = tk.Constants.POINT_OPTIONS;
            dbPath = "position[1]";
          };
          {
            name = L["Relative Frame"];
            type = "textfield";
            valueType = "string";
            dbPath = "position[2]";
          };
          {
            name = L["Relative Point"];
            type = "dropdown";
            options = tk.Constants.POINT_OPTIONS;
            dbPath = "position[3]";
          };
          { type = "divider" };
          {
            type = "slider";
            name = L["X-Offset"];
            dbPath = "position[4]";
            min = -300;
            max = 300;
          };
          {
            type = "slider";
            name = L["Y-Offset"];
            dbPath = "position[5]";
            min = -300;
            max = 300;
          };

          { type = "title", name = "Text Settings" };

          { type = "fontstring"; content = "Time Remaining"; subtype = "header" };

          {
            type = "slider";
            min = 8;
            max = 20;
            step = 1;
            dbPath = "textSize.timeRemaining";
            name= "Normal Font Size";
          },
          {
            type = "slider";
            min = 8;
            max = 20;
            step = 1;
            dbPath = "textSize.timeRemainingLarge";
            name= "Warning Font Size";
          },
          {
            name = L["Point"];
            type = "dropdown";
            options = tk.Constants.POINT_OPTIONS;
            dbPath = "textPosition.timeRemaining[1]";
          };
          {
            name = L["Relative Point"];
            type = "dropdown";
            options = tk.Constants.POINT_OPTIONS;
            dbPath = "textPosition.timeRemaining[3]";
          };
          { type = "divider" };
          {
            type = "slider";
            name = L["X-Offset"];
            dbPath = "textPosition.timeRemaining[4]";
            min = -30;
            max = 30;
          };
          {
            type = "slider";
            name = L["Y-Offset"];
            dbPath = "textPosition.timeRemaining[5]";
            min = -30;
            max = 30;
          };

          { type = "fontstring"; content = "Count"; subtype = "header" };

          {
            type = "slider";
            min = 8;
            max = 20;
            step = 1;
            dbPath = "textSize.count";
            name= "Font Size";
          },
          {
            name = L["Point"];
            type = "dropdown";
            options = tk.Constants.POINT_OPTIONS;
            dbPath = "textPosition.count[1]";
          };
          {
            name = L["Relative Point"];
            type = "dropdown";
            options = tk.Constants.POINT_OPTIONS;
            dbPath = "textPosition.count[3]";
          };
          { type = "divider" };
          {
            type = "slider";
            name = L["X-Offset"];
            dbPath = "textPosition.count[4]";
            min = -30;
            max = 30;
          };
          {
            type = "slider";
            name = L["Y-Offset"];
            dbPath = "textPosition.count[5]";
            min = -30;
            max = 30;
          };
        }
      },
      {
        type = "title";
        name = "Bar Options";
        appendDbPath = "profile." .. auraType .. ".statusbars";
        OnLoad = function(_, frame)
          barOptionsFrame = frame;
        end,
        children = {
          {
            type = "check";
            name = "Pulse Effect";
            tooltip = "If true, when the aura is close to expiring the aura frame will fade in and out.";
            dbPath = "pulse";
          },
          {
            type = "slider";
            name = "Set Non-Player Alpha";
            min = 0;
            max = 1;
            step = 0.1;
            tooltip = "The alpha of auras not applied by you.";
            dbPath = "nonPlayerAlpha";
          },
          {
            type = "fontstring";
            subtype="header";
            content= "Vertical Direction";
          },
          {
            name = "Up";
            type = "radio";
            groupName = auraType .. "-statusbars-vDirection";
            dbPath = "vDirection";
            height = 50;
            GetValue = function(_, value)
              return value == "UP";
            end;
          };
          {
            name = "Down";
            type = "radio";
            groupName = auraType .. "-statusbars-vDirection";
            dbPath = "vDirection";
            height = 50;
            GetValue = function(_, value)
              return value == "DOWN";
            end;
          };
          {
            type = "fontstring";
            subtype="header";
            content= "Horizontal Direction";
          },
          {
            name = "Left";
            type = "radio";
            groupName = auraType .. "-statusbars-hDirection";
            dbPath = "hDirection";
            height = 50;
            GetValue = function(_, value)
              return value == "LEFT";
            end;
          };
          {
            name = "Right";
            type = "radio";
            groupName = auraType .. "-statusbars-hDirection";
            dbPath = "hDirection";
            height = 50;
            GetValue = function(_, value)
              return value == "RIGHT";
            end;
          };
          {
            type = "slider";
            name = "Icon Width";
            dbPath = "iconWidth";
            min = 20;
            max = 80;
            step = 1;
          };
          {
            type = "slider";
            name = "Icon Height";
            dbPath = "iconHeight";
            min = 20;
            max = 80;
            step = 1;
          };
          {
            type = "slider";
            name = "Border Size";
            dbPath = "iconBorderSize";
            min = 0;
            max = 5;
            step = 1;
          };
          {
            type = "slider";
            name = "Bar Width";
            dbPath = "barWidth";
            min = 100;
            max = 300;
            step = 1;
          };
          {
            type = "slider";
            name = "Bar Height";
            dbPath = "barHeight";
            min = 20;
            max = 80;
            step = 1;
          };
          {
            type = "check";
            name = "Show Icon Shadow";
            dbPath = "iconShadow";
          };
          {
            type = "slider";
            name = "Warning Threshold (in Seconds)";
            dbPath = "secondsWarning";
            min = 0;
            max = 30;
            step = 1;
          };
          {
            type = "slider";
            name = "Auras Per Row";
            dbPath = "perRow";
            min = 5;
            max = 20;
            step = 1;
          };
          {
            name = "Row Spacing";
            type = "slider";
            min = 0;
            max = 80;
            step = 1;
            dbPath = "ySpacing";
          };
          {
            name = "Column Spacing";
            type = "slider";
            min = 0;
            max = 80;
            step = 1;
            dbPath = "xSpacing";
          };

          {
            type = "check";
            name = "Show Bar Spark";
            dbPath = "showSpark";
          };

          {
            type = "dropdown";
            name = L["Bar Texture"];
            options = tk.Constants.LSM:List("statusbar");
            dbPath = "texture";
          };

          { type = "title", name = "Aura Frame Position Settings" };

          {
            name = L["Point"];
            type = "dropdown";
            options = tk.Constants.POINT_OPTIONS;
            dbPath = "position[1]";
          };
          {
            name = L["Relative Frame"];
            type = "textfield";
            valueType = "string";
            dbPath = "position[2]";
          };
          {
            name = L["Relative Point"];
            type = "dropdown";
            options = tk.Constants.POINT_OPTIONS;
            dbPath = "position[3]";
          };
          { type = "divider" };
          {
            type = "slider";
            name = L["X-Offset"];
            dbPath = "position[4]";
            min = -300;
            max = 300;
          };
          {
            type = "slider";
            name = L["Y-Offset"];
            dbPath = "position[5]";
            min = -300;
            max = 300;
          };

          { type = "title", name = "Text Settings" };

          { type = "fontstring"; content = "Time Remaining"; subtype = "header" };

          {
            type = "slider";
            min = 8;
            max = 20;
            step = 1;
            dbPath = "textSize.timeRemaining";
            name= "Normal Font Size";
          },
          {
            type = "slider";
            min = 8;
            max = 20;
            step = 1;
            dbPath = "textSize.timeRemainingLarge";
            name= "Warning Font Size";
          },
          {
            name = L["Point"];
            type = "dropdown";
            options = tk.Constants.POINT_OPTIONS;
            dbPath = "textPosition.timeRemaining[1]";
          };
          {
            name = L["Relative Point"];
            type = "dropdown";
            options = tk.Constants.POINT_OPTIONS;
            dbPath = "textPosition.timeRemaining[3]";
          };
          { type = "divider" };
          {
            type = "slider";
            name = L["X-Offset"];
            dbPath = "textPosition.timeRemaining[4]";
            min = -30;
            max = 30;
          };
          {
            type = "slider";
            name = L["Y-Offset"];
            dbPath = "textPosition.timeRemaining[5]";
            min = -30;
            max = 30;
          };

          { type = "fontstring"; content = "Count"; subtype = "header" };

          {
            type = "slider";
            min = 8;
            max = 20;
            step = 1;
            dbPath = "textSize.count";
            name= "Font Size";
          },
          {
            name = L["Point"];
            type = "dropdown";
            options = tk.Constants.POINT_OPTIONS;
            dbPath = "textPosition.count[1]";
          };
          {
            name = L["Relative Point"];
            type = "dropdown";
            options = tk.Constants.POINT_OPTIONS;
            dbPath = "textPosition.count[3]";
          };
          { type = "divider" };
          {
            type = "slider";
            name = L["X-Offset"];
            dbPath = "textPosition.count[4]";
            min = -30;
            max = 30;
          };
          {
            type = "slider";
            name = L["Y-Offset"];
            dbPath = "textPosition.count[5]";
            min = -30;
            max = 30;
          };

          { type = "fontstring"; content = "Aura Name"; subtype = "header" };

          {
            type = "slider";
            min = 8;
            max = 20;
            step = 1;
            dbPath = "textSize.auraName";
            name= "Font Size";
          },
          {
            name = L["Point"];
            type = "dropdown";
            options = tk.Constants.POINT_OPTIONS;
            dbPath = "textPosition.auraName[1]";
          };
          {
            name = L["Relative Point"];
            type = "dropdown";
            options = tk.Constants.POINT_OPTIONS;
            dbPath = "textPosition.auraName[3]";
          };
          { type = "divider" };
          {
            type = "slider";
            name = L["X-Offset"];
            dbPath = "textPosition.auraName[4]";
            min = -30;
            max = 30;
          };
          {
            type = "slider";
            name = L["Y-Offset"];
            dbPath = "textPosition.auraName[5]";
            min = -30;
            max = 30;
          };
        }
      }
    };
  end

  local colorOptions = {};

  return {
    type = "menu",
    module = "AurasModule",
    database = "MUI_AurasDB";
    children = {
      {
        type = "tabs";
        children = {
          {
            name = "Buffs";
            children = GetAuraOptions("buffs");
          },
          {
            name = "Debuffs";
            children = GetAuraOptions("debuffs");
          },
          {
            name = "Colors";
            children = colorOptions;
          },
        }
      }
    }
  };
end