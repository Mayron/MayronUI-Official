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
        name = icons and L["Icon Options"] or L["Status Bar Options"];
        description = L["These settings relate to the individual aura icons/bars."];
        marginTop = 0;
      },
      {
        type = "check";
        name = L["Show Pulse Effect"];
        height = 50;
        tooltip = L["If true, when the aura is close to expiring the aura frame will fade in and out."];
        dbPath = "pulse";
      },
      {
        type = "slider";
        name = L["Set Non-Player Alpha"];
        min = 0;
        max = 1;
        step = 0.1;
        tooltip = L["The alpha of auras not applied by you."];
        dbPath = "nonPlayerAlpha";
      },

      { type = "divider"; };
      {
        type = "slider";
        name = L["Icon Width"];
        dbPath = "iconWidth";
        min = 20;
        max = 80;
        step = 1;
      };
      {
        type = "slider";
        name = L["Icon Height"];
        dbPath = "iconHeight";
        min = 20;
        max = 80;
        step = 1;
      };
      {
        type = "slider";
        name = L["Icon Spacing"];
        dbPath = "iconSpacing";
        ignore = icons;
        min = 0;
        max = 10;
        step = 1;
      };
      { type = "divider"; ignore = icons; };
      {
        type = "slider";
        name = L["Bar Width"];
        dbPath = "barWidth";
        ignore = icons;
        min = 100;
        max = 300;
        step = 1;
      };
      {
        type = "slider";
        name = L["Bar Height"];
        dbPath = "barHeight";
        ignore = icons;
        min = 10;
        max = 80;
        step = 1;
      };
      {
        type = "dropdown";
        name = L["Bar Texture"];
        media = "statusbar";
        ignore = icons;
        dbPath = "texture";
      };
      {
        type = "dropdown";
        name = L["Border"];
        media = "border";
        ignore = icons;
        dbPath = "border";
      };
      {
        type = "slider";
        name = L["Border Size"];
        min = 0;
        max = 10;
        ignore = icons;
        dbPath = "barBorderSize";
      };
      {
        type = "check";
        name = L["Show Bar Spark"];
        dbPath = "showSpark";
        ignore = icons;
        height = 50;
      };
      {
        type = "title";
        name = L["Container Frame Settings"];
        description = L["These settings relate to the frame containing the individual aura icons/bars."];
      },
      {
        type = "fontstring";
        subtype ="header";
        content = L["Positioning"];
      },
      {
        name = L["Relative Frame"];
        type = "dropdown";
        GetOptions = function()
          local options = {
            [L["Screen"]] = "UIParent";
            [L["Mini-Map"]] = "Minimap";
          };

          if (auraType == "debuffs") then
            options["Buffs"] = "MUI_BuffFrames";
          end

          return options;
        end;
        dbPath = "relFrame";
      };
      {
        name = L["Relative Point"];
        type = "dropdown";
        options = tk.Constants.POINT_OPTIONS;
        dbPath = "relPoint";
      };
      {
        type = "slider";
        name = L["X-Offset"];
        dbPath = "xOffset";
        min = -300;
        max = 300;
      };
      {
        type = "slider";
        name = L["Y-Offset"];
        dbPath = "yOffset";
        min = -300;
        max = 300;
      };
      {
        type = "fontstring";
        subtype = "header";
        content = L["Growth Direction"];
      },
      {
        name = L["Up"];
        type = "radio";
        groupName = groupPrefix.."-vDirection";
        dbPath = "vDirection";
        GetValue = function(_, value)
          return value == "UP";
        end;
        SetValue = function(self)
          db.profile:Store(self.dbPath, "UP");
        end;
      };
      {
        name = L["Down"];
        type = "radio";
        groupName = groupPrefix.."-vDirection";
        dbPath = "vDirection";
        GetValue = function(_, value)
          return value == "DOWN";
        end;
        SetValue = function(self)
          db.profile:Store(self.dbPath, "DOWN");
        end;
      };
      {
        name = L["Left"];
        type = "radio";
        groupName = groupPrefix.."-hDirection";
        dbPath = "hDirection";
        GetValue = function(_, value)
          return value == "LEFT";
        end;
        SetValue = function(self)
          db.profile:Store(self.dbPath, "LEFT");
        end;
      };
      {
        name = L["Right"];
        type = "radio";
        groupName = groupPrefix.."-hDirection";
        dbPath = "hDirection";
        GetValue = function(_, value)
          return value == "RIGHT";
        end;
        SetValue = function(self)
          db.profile:Store(self.dbPath, "RIGHT");
        end;
      };
      {
        type = "fontstring";
        subtype="header";
        content= L["Rows and Columns"];
      },
      {
        type = "slider";
        name = icons and "Icons Per Row" or "Bar Columns";
        tooltip = icons
          and L["The maximum number of aura icons to display per row."]
          or L["The maximum number of horizontal bar columns to display."];
        dbPath = "perRow";
        min = 1;
        max = icons and 20 or 5;
        step = 1;
      };
      {
        name = L["Row Spacing"];
        type = "slider";
        min = 0;
        max = 80;
        step = 1;
        dbPath = "ySpacing";
      };
      {
        name = L["Column Spacing"];
        type = "slider";
        min = 0;
        max = 80;
        step = 1;
        dbPath = "xSpacing";
      };

      { type = "title", name = L["Text Settings"] };

      { type = "fontstring"; content = L["Aura Name"]; subtype = "header"; ignore = icons; };

      {
        type = "slider";
        min = 8;
        max = 20;
        ignore = icons;
        step = 1;
        dbPath = "textSize.auraName";
        name = L["Font Size"];
      },
      {
        type = "dropdown";
        ignore = icons;
        dbPath = "fonts.auraName";
        name = L["Font Type"];
        media = "font";
      },
      { type = "divider" };
      {
        name = L["Point"];
        type = "dropdown";
        ignore = icons;
        options = tk.Constants.POINT_OPTIONS;
        dbPath = "textPosition.auraName[1]";
      };
      {
        name = L["Relative Frame"];
        type = "dropdown";
        ignore = icons;
        options = {
          [L["Icon"]] = "icon";
          [L["Icon Frame"]] = "iconFrame";
          [L["Aura Frame"]] = "aura";
          [L["Bar"]] = "bar";
        };
        dbPath = "textPosition.auraName[2]";
      };
      {
        name = L["Relative Point"];
        type = "dropdown";
        ignore = icons;
        options = tk.Constants.POINT_OPTIONS;
        dbPath = "textPosition.auraName[3]";
      };
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

      { type = "fontstring"; content = L["Time Remaining"]; subtype = "header" };

      {
        name = L["Normal Font Size"];
        type = "slider";
        min = 8;
        max = 20;
        step = 1;
        dbPath = "textSize.timeRemaining";
      },
      {
        name= L["Warning Font Size"];
        type = "slider";
        min = 8;
        max = 20;
        step = 1;
        dbPath = "textSize.timeRemainingLarge";
      },
      {
        type = "dropdown";
        dbPath = "fonts.timeRemaining";
        name = L["Font Type"];
        media = "font";
      },
      { type = "divider" };
      {
        type = "slider";
        name = L["Warning Threshold"];
        tooltip = L["The minimum number of seconds remaining required for the time remaining text to use the warning font size."];
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
        name = L["Relative Frame"];
        type = "dropdown";
        GetOptions = function()
          local options = {
            [L["Icon"]] = "icon";
            [L["Icon Frame"]] = "iconFrame";
            [L["Aura Frame"]] = "aura";
          };

          if (not icons) then
            options[L["Bar"]] = "bar";
          end

          return options;
        end;
        dbPath = "textPosition.timeRemaining[2]";
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

      { type = "fontstring"; content = L["Count"]; subtype = "header" };

      {
        name= L["Font Size"];
        type = "slider";
        min = 8;
        max = 20;
        step = 1;
        dbPath = "textSize.count";
      },
      {
        type = "dropdown";
        dbPath = "fonts.count";
        name = L["Font Type"];
        media = "font";
      },
      { type = "divider" };
      {
        name = L["Point"];
        type = "dropdown";
        options = tk.Constants.POINT_OPTIONS;
        dbPath = "textPosition.count[1]";
      };
      {
        name = L["Relative Frame"];
        type = "dropdown";
        GetOptions = function()
          local options = {
            [L["Icon"]] = "icon";
            [L["Icon Frame"]] = "iconFrame";
            [L["Aura Frame"]] = "aura";
          };

          if (not icons) then
            options[L["Bar"]] = "bar";
          end

          return options;
        end;
        dbPath = "textPosition.count[2]";
      };
      {
        name = L["Relative Point"];
        type = "dropdown";
        options = tk.Constants.POINT_OPTIONS;
        dbPath = "textPosition.count[3]";
      };
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
        name = L["Set Display Mode"];
        type = "dropdown";
        options = { [L["Icons"]] = "icons", [L["Status Bars"]] = "statusbars" };
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
        dbPath = "profile." .. auraType .. ".icons";
        OnLoad = function(_, frame)
          iconOptionsFrame = frame;
        end,
        children = function()
          return GetFrameOptions(auraType, true);
        end
      },
      {
        type = "frame";
        dbPath = "profile." .. auraType .. ".statusbars";
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

  local colorOptions = {
    {
      type = "title";
      name = L["Text Colors"];
    };
    {
      name = L["Time Remaining"];
      type = "color";
      width = 160,
      dbPath = "profile.colors.timeRemaining";
      useIndexes = true;
    };
    {
      name = L["Count"];
      type = "color";
      width = 160,
      dbPath = "profile.colors.count";
      useIndexes = true;
    };
    {
      name = L["Aura Name"];
      type = "color";
      width = 160,
      dbPath = "profile.colors.auraName";
      useIndexes = true;
    };
    {
      type = "title";
      name = L["Aura Type Colors"];
    };
    {
      name = L["Basic Buff"];
      type = "color";
      width = 160,
      dbPath = "profile.colors.helpful";
      useIndexes = true;
    };
    {
      name = L["Player Owned Buff"];
      tooltips = L["Buffs that you applied to yourself."];
      type = "color";
      width = 160,
      dbPath = "profile.colors.owned";
      useIndexes = true;
    };
    {
      name = L["Basic Debuff"];
      type = "color";
      width = 160,
      dbPath = "profile.colors.harmful";
      useIndexes = true;
    };
    {
      name = L["Magic Debuff"];
      type = "color";
      width = 160,
      dbPath = "profile.colors.magic";
      useIndexes = true;
    };
    {
      name = L["Disease Debuff"];
      type = "color";
      width = 160,
      dbPath = "profile.colors.disease";
      useIndexes = true;
    };
    {
      name = L["Poison Debuff"];
      type = "color";
      width = 160,
      dbPath = "profile.colors.poison";
      useIndexes = true;
    };
    {
      name = L["Curse Debuff"];
      type = "color";
      width = 160,
      dbPath = "profile.colors.curse";
      useIndexes = true;
    };
    {
      type = "title";
      name = L["Bar Colors"];
    };
    {
      name = L["Background"];
      type = "color";
      width = 160,
      hasOpacity = true;
      dbPath = "profile.colors.background";
      useIndexes = true;
    };
    {
      name = L["Borders"];
      type = "color";
      width = 160,
      dbPath = "profile.colors.barBorders";
      useIndexes = true;
    };
  };

  return {
    tabs = { L["Buffs"], L["Debuffs"], L["Colors"] };
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