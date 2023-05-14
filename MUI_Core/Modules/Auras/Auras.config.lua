-- luacheck: ignore MayronUI self 143 631
local MayronUI = _G.MayronUI;
local tk, _, _, _, _, L = MayronUI:GetCoreComponents();

local _, C_AurasModule = MayronUI:ImportModule("AurasModule");

function C_AurasModule:GetConfigTable()
  local configMenu = MayronUI:ImportModule("ConfigMenu");
  local db = MayronUI:GetComponent("MUI_AurasDB");


  local function GetFrameOptions(auraType, icons)
    local groupPrefix = auraType .. (icons and "-icons" or "-statusbars");

    local children = {
      {
        type = "title";
        name = icons and "Icon Options" or "Bar Options";
        marginTop = 0;
      },
      {
        type = "check";
        name = "Pulse Effect";
        height = 50;
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
        subtype = "header";
        content = "Vertical Direction";
      },
      {
        name = "Up";
        type = "radio";
        groupName = groupPrefix.."-vDirection";
        dbPath = "vDirection";
        height = 50;
        GetValue = function(_, value)
          return value == "UP";
        end;
        SetValue = function(self)
          db.profile:Store(self.dbPath, "UP");
        end;
      };
      {
        name = "Down";
        type = "radio";
        groupName = groupPrefix.."-vDirection";
        dbPath = "vDirection";
        height = 50;
        GetValue = function(_, value)
          return value == "DOWN";
        end;
        SetValue = function(self)
          db.profile:Store(self.dbPath, "DOWN");
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
        groupName = groupPrefix.."-hDirection";
        dbPath = "hDirection";
        height = 50;
        GetValue = function(_, value)
          return value == "LEFT";
        end;
        SetValue = function(self)
          db.profile:Store(self.dbPath, "LEFT");
        end;
      };
      {
        name = "Right";
        type = "radio";
        groupName = groupPrefix.."-hDirection";
        dbPath = "hDirection";
        height = 50;
        GetValue = function(_, value)
          return value == "RIGHT";
        end;
        SetValue = function(self)
          db.profile:Store(self.dbPath, "RIGHT");
        end;
      };
      { type = "divider"; };
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
        name = "Icon Border Size";
        dbPath = "iconBorderSize";
        min = 0;
        max = 5;
        step = 1;
      };
      {
        type = "slider";
        name = "Icon Spacing";
        dbPath = "iconSpacing";
        ignore = icons;
        min = 0;
        max = 10;
        step = 1;
      };
      { type = "divider"; };
      {
        type = "slider";
        name = "Bar Width";
        dbPath = "barWidth";
        ignore = icons;
        min = 100;
        max = 300;
        step = 1;
      };
      {
        type = "slider";
        name = "Bar Height";
        dbPath = "barHeight";
        ignore = icons;
        min = 20;
        max = 80;
        step = 1;
      };
      {
        type = "dropdown";
        name = L["Bar Texture"];
        options = tk.Constants.LSM:List("statusbar");
        ignore = icons;
        dbPath = "texture";
      };
      {
        type = "check";
        name = "Show Bar Spark";
        dbPath = "showSpark";
        ignore = icons;
        height = 50;
      };
      { type = "divider"; ignore = icons; };
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
        type = "dropdown";
        GetOptions = function()
          local options = {
            ["Screen"] = "UIParent";
            ["Minimap"] = "Minimap";
          };

          if (auraType == "debuffs") then
            options["Buffs"] = "MUI_BuffFrames";
          end

          return options;
        end;
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

      { type = "fontstring"; content = "Aura Name"; subtype = "header"; ignore = icons; };

      {
        type = "slider";
        min = 8;
        max = 20;
        ignore = icons;
        step = 1;
        dbPath = "textSize.auraName";
        name = "Font Size";
      },
      {
        name = L["Point"];
        type = "dropdown";
        ignore = icons;
        options = tk.Constants.POINT_OPTIONS;
        dbPath = "textPosition.auraName[1]";
      };
      {
        name = L["Relative Point"];
        type = "dropdown";
        ignore = icons;
        options = tk.Constants.POINT_OPTIONS;
        dbPath = "textPosition.auraName[3]";
      };
      { type = "divider" };
      {
        type = "slider";
        name = L["X-Offset"];
        ignore = icons;
        dbPath = "textPosition.auraName[4]";
        min = -30;
        max = 30;
      };
      {
        type = "slider";
        name = L["Y-Offset"];
        ignore = icons;
        dbPath = "textPosition.auraName[5]";
        min = -30;
        max = 30;
      };

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
        type = "slider";
        name = "Warning Threshold";
        tooltip = "The minimum number of seconds remaining required for the time remaining text to use the warning font size.";
        dbPath = "secondsWarning";
        label = "seconds";
        min = 0;
        max = 30;
        step = 1;
      };
      { type = "divider" };
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

    return children;
  end

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
        type = "frame";
        shown = function()
          local mode = db.profile:QueryType("string", auraType, "mode");
          return mode == "icons";
        end;
        appendDbPath = "profile." .. auraType .. ".icons";
        OnLoad = function(_, frame)
          iconOptionsFrame = frame;
        end,
        children = function()
          return GetFrameOptions(auraType, true);
        end
      },
      {
        type = "frame";
        appendDbPath = "profile." .. auraType .. ".statusbars";
        shown = function()
          local mode = db.profile:QueryType("string", auraType, "mode");
          return mode == "statusbars";
        end;
        OnLoad = function(_, frame)
          barOptionsFrame = frame;
        end,
        children = function()
          return GetFrameOptions(auraType, false);
        end;
      }
    };
  end

  local colorOptions = {};

  return {
    tabs = { "Buffs", "Debuffs", "Colors" };
    module = "AurasModule",
    database = "MUI_AurasDB";
    dbFramework = "orbitus";
    children = {
      GetAuraOptions("buffs");
      GetAuraOptions("debuffs");
      colorOptions;
    }
  };
end