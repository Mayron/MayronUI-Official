-- luacheck: ignore MayronUI self 143 631
local MayronUI = _G.MayronUI;
local tk, _, _, _, _, L = MayronUI:GetCoreComponents();
local C_InventoryModule = MayronUI:GetModuleClass("InventoryModule");

function C_InventoryModule:GetConfigTable()
  -- local configMenu = MayronUI:ImportModule("ConfigMenu");
  local db = MayronUI:GetComponent("MUI_InventoryDB");

  self:RegisterObservers(db);

  local function GetGeneralOptions()
    local options = {
      {
        type = "check";
        name = L["Enable Inventory Frame"];
        tooltip = L["Use the MayronUI custom inventory frame instead of the default Blizzard bags UI."];
        dbPath = "global.enabled";
        requiresReload = true;
      };
      { type = "title"; name = L["Container Frame Settings"]};
      {
        type = "dropdown";
        name = "Set Color Scheme";
        dbPath = "profile.container.colorScheme";
        options = {
          ["MUI Frames Color"] = "MUI_Frames";
          ["Theme Color"] = "Theme";
          ["Class Color"] = "Class";
          ["Custom Color"] = "Custom";
        }
      };
      {
        type = "color";
        name = "Set Custom Color";
        height = 50;
        dbPath = "profile.container.customColor";
      };
      {
        type = "slider";
        name = L["Padding"];
        dbPath = "profile.container.padding";
        min = 0;
        max = 20;
      };

      { type = "title"; name = "Tab Bar Options" };
      {
        type = "check";
        name = "Show Tab Bar";
        height = 50;
        dbPath = "profile.container.tabBar.show";
      };

      {
        type = "slider";
        name = "Set X-Offset";
        dbPath = "profile.container.tabBar.xOffset";
        min = 0;
        max = 20;
      };
      {
        type = "slider";
        name = "Set Y-Offset";
        dbPath = "profile.container.tabBar.yOffset";
        min = 0;
        max = 20;
      };
      {
        type = "slider";
        name = "Set Spacing";
        dbPath = "profile.container.tabBar.spacing";
        min = 0;
        max = 20;
      };
      {
        type = "dropdown";
        name = "Set Position";
        dbPath = "profile.container.tabBar.position";
        options = {
          [L["Top"]] = "TOP";
          [L["Right"]] = "RIGHT";
          [L["Bottom"]] = "BOTTOM";
          [L["Left"]] = "LEFT";
        }
      };

      {
        type = "frame";
        name = "SetDirection";
        width = "fill";
        noWrap = true;
        children = {
          { type = "fontstring"; content = "Set Direction: "; inline = true; };
          {
            name = L["Up"];
            type = "radio";
            groupName = "inventory_tab_bar_direction";
            dbPath = "profile.container.tabBar.direction";
            -- GetValue = function(_, value)
            --   return value == "BOTTOM";
            -- end;

            -- SetValue = function(self)
            --   db:SetPathValue(self.dbPath, "BOTTOM");
            -- end;
          };
          {
            name = L["Down"];
            type = "radio";
            groupName = "inventory_tab_bar_direction";
            dbPath = "profile.container.tabBar.direction";
            -- GetValue = function(_, value)
            --   return value == "BOTTOM";
            -- end;
    
            -- SetValue = function(self)
            --   db:SetPathValue(self.dbPath, "BOTTOM");
            -- end;
          };
        }
      };

      { type = "divider"};
      {
        type = "check";
        name = "Show Equipment Tab";
        dbPath = "profile.container.tabBar.showEquipment";
      };
      {
        type = "check";
        name = "Show Consumables Tab";
        dbPath = "profile.container.tabBar.showConsumables";
      };
      {
        type = "check";
        name = "Show Trade Goods Tab";
        dbPath = "profile.container.tabBar.showTradeGoods";
      };
      {
        type = "check";
        name = "Show Quest Items Tab";
        dbPath = "profile.container.tabBar.showQuestItems";
      };
    }

    return options;
  end

  local function GetGridViewOptions()
    local options = {
      {
        type = "slider";
        name = L["Icon Width"];
        dbPath = "profile.grid.widths.initial";
        min = 25;
        max = 50;
      };
      {
        type = "slider";
        name = L["Icon Height"];
        dbPath = "profile.grid.height";
        min = 25;
        max = 50;
      };
      {
        type = "slider";
        name = L["Icon Spacing"];
        dbPath = "profile.grid.slotSpacing";
        min = 0;
        max = 15;
      };
      { type = "divider"; };
      {
        type = "slider";
        name = "Min Icons Per Row";
        dbPath = "profile.grid.columns.min";
        tooltip = "The minimum number of icons that can appear per row when resizing the inventory frame using the grid view.";
        min = 1;
        max = 8;
      };
      {
        type = "slider";
        name = "Max Icons Per Row";
        dbPath = "profile.grid.columns.max";
        tooltip = "The maximum number of icons that can appear per row when resizing the inventory frame using the grid view.";
        min = 1;
        max = 50;
      };
      { type = "divider"; };
      {
        type = "check";
        name = "Show Item Levels";
        dbPath = "profile.grid.showItemLevels";
        tooltip = "If checked, item levels will show on top of the icons of equipment and weapon items.";
        min = 0;
        max = 15;
      };
    }

    return options;
  end

  local function GetDetailedViewOptions()
    local options = {
      {
        type = "slider";
        name = "Min Slot Width";
        dbPath = "profile.detailed.widths.min";
        min = 200;
        max = 400;
        step = 10;
      };
      {
        type = "slider";
        name = "Max Slot Width";
        dbPath = "profile.detailed.widths.max";
        min = 200;
        max = 400;
        step = 10;
      };
      {
        type = "slider";
        name = "Slot Height";
        dbPath = "profile.detailed.height";
        min = 25;
        max = 50;
      };
      {
        type = "slider";
        name = "Slot Spacing";
        dbPath = "profile.detailed.slotSpacing";
        min = 0;
        max = 15;
      };
      { type = "divider"; };
      {
        type = "slider";
        name = "Min Columns";
        dbPath = "profile.detailed.columns.min";
        tooltip = "The minimum number of columns that can appear per row when resizing the inventory frame using the detailed view.";
        min = 1;
        max = 8;
      };
      {
        type = "slider";
        name = "Max Columns";
        dbPath = "profile.detailed.columns.max";
        tooltip = "The maximum number of columns that can appear per row when resizing the inventory frame using the detailed view.";
        min = 1;
        max = 8;
      };
      { type = "divider"; };
      {
        type = "slider";
        name = "Min Rows";
        dbPath = "profile.detailed.rows.min";
        tooltip = "The minimum number of rows that can appear when resizing the inventory frame using the detailed view.";
        min = 1;
        max = 30;
      };
      {
        type = "slider";
        name = "Max Rows";
        dbPath = "profile.detailed.rows.max";
        tooltip = "The maximum number of rows that can appear when resizing the inventory frame using the detailed view.";
        min = 1;
        max = 30;
      };
      { type = "divider"; };
      { type = "title"; name = "Font Options"; };
      {
        type = "check";
        name = "Show Item Name";
        dbPath = "profile.detailed.showItemName";
      };
      {
        type = "slider";
        name = "Item Name Font Size";
        dbPath = "profile.detailed.itemNameFontSize";
        min = 8;
        max = 16;
      };
      { type = "divider"};
      {
        type = "check";
        name = "Show Item Levels";
        dbPath = "profile.detailed.showItemLevels";
        tooltip = "If checked, item levels will be shown in description of equipment and weapon items.";
      };
      {
        type = "check";
        name = "Show Item Type";
        dbPath = "profile.detailed.showItemType";
      };
      {
        type = "slider";
        name = "Item Description Font Size";
        dbPath = "profile.detailed.itemDescriptionFontSize";
        min = 8;
        max = 16;
      };
    }

    return options;
  end

  return {
    tabs = { "General", "Grid View", "Detailed View" };
    module = "InventoryModule",
    database = "MUI_InventoryDB";
    dbFramework = "orbitus";
    children = {
      GetGeneralOptions();
      GetGridViewOptions();
      GetDetailedViewOptions();
    }
  };
end