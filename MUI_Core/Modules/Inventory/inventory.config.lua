-- luacheck: ignore MayronUI self 143 631
local MayronUI = _G.MayronUI;
local tk, _, _, _, _, L = MayronUI:GetCoreComponents();
local C_InventoryModule = MayronUI:GetModuleClass("InventoryModule");

function C_InventoryModule:GetConfigTable()
  -- local configMenu = MayronUI:ImportModule("ConfigMenu");
  local db = MayronUI:GetComponent("MUI_InventoryDB")--[[@as OrbitusDB.DatabaseMixin]];

  self:RegisterObservers(db);

  local radioButtonDirectionOption1;
  local radioButtonDirectionOption2;
  local setDirectionDynamicFrame;
  local setCustomColorButton;

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
        OnValueChanged = function(value)
          setCustomColorButton:SetEnabled(value == "Custom");
        end;
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
        useIndexes = true;
        enabled = function()
          local scheme = db.profile:QueryType("string", "container.colorScheme");
          return scheme == "Custom";
        end;
        OnLoad = function(_, component)
          setCustomColorButton = component.btn;
        end;
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
        name = L["X-Offset"];
        dbPath = "profile.container.tabBar.xOffset";
        min = -20;
        max = 20;
      };
      {
        type = "slider";
        name = L["Y-Offset"];
        dbPath = "profile.container.tabBar.yOffset";
        min = -20;
        max = 20;
      };
      {
        type = "slider";
        name = "Spacing";
        dbPath = "profile.container.tabBar.spacing";
        min = 0;
        max = 20;
      };
      {
        type = "slider";
        name = "Scale";
        dbPath = "profile.container.tabBar.scale";
        step = 0.2;
        min = 0.6;
        max = 5;
      };
      {
        type = "dropdown";
        name = "Set Position";
        dbPath = "profile.container.tabBar.position";
        disableSorting = true;
        options = {
          { L["Top"], "TOP" };
          { L["Right"], "RIGHT" };
          { L["Bottom"], "BOTTOM" };
          { L["Left"], "LEFT" };
        },
        SetValue = function(self, newValue)
          db.profile:Store(self.dbPath, newValue);
          local direction = db.profile:QueryType("string", "container.tabBar.direction");
          local label1, label2;

          if (newValue == "TOP" or newValue == "BOTTOM") then
            if (direction ~= "LEFT" and direction ~= "RIGHT") then
              label1 = L["Left"];
              label2 = L["Right"];
              direction = "RIGHT";
            end
          elseif (direction ~= "UP" and direction ~= "DOWN") then
            label1 = L["Up"];
            label2 = L["Down"];
            direction = "DOWN";
          end

          if (label1) then
            db.profile:Store("container.tabBar.direction", direction);
            radioButtonDirectionOption1:SetCheckButtonLabel(label1);
            radioButtonDirectionOption1:SetChecked(false);
            radioButtonDirectionOption2:SetCheckButtonLabel(label2);
            radioButtonDirectionOption2:SetChecked(true);
            setDirectionDynamicFrame:Refresh();
          end
        end;
      };
      {
        type = "frame";
        name = "SetDirection";
        OnLoad = function(_, dynamicFrame)
          setDirectionDynamicFrame = dynamicFrame;
        end;
        width = "fill";
        noWrap = true;
        children = {
          {
            type = "fontstring";
            content = L["Growth Direction"]..": ";
            inline = true;
          };
          {
            name = L["Up"];
            type = "radio";
            defaultText = L["Down"];
            groupName = "inventory_tab_bar_direction";
            dbPath = "profile.container.tabBar.direction";
            OnLoad = function(_, component, isChecked)
              radioButtonDirectionOption1 = component;
              local position = db.profile:QueryType("string", "container.tabBar.position");

              if (position == "TOP" or position == "BOTTOM") then
                component:SetCheckButtonLabel(L["Left"]);
                component:SetChecked(isChecked);
              end
            end;
            GetValue = function(_, dbValue)
              return dbValue == "UP" or dbValue == "LEFT";
            end;
            SetValue = function(self)
              local position = db.profile:QueryType("string", "container.tabBar.position");

              if (position == "TOP" or position == "BOTTOM") then
                db.profile:Store(self.dbPath, "LEFT");
              else
                db.profile:Store(self.dbPath, "UP");
              end
            end;
          };
          {
            name = L["Down"];
            type = "radio";
            defaultText = L["Down"];
            groupName = "inventory_tab_bar_direction";
            dbPath = "profile.container.tabBar.direction";
            OnLoad = function(_, component, isChecked)
              radioButtonDirectionOption2 = component;
              local position = db.profile:QueryType("string", "container.tabBar.position");

              if (position == "TOP" or position == "BOTTOM") then
                component:SetCheckButtonLabel(L["Right"]);
                component:SetChecked(isChecked);
              end
            end;
            GetValue = function(_, dbValue)
              return dbValue == "DOWN" or dbValue == "RIGHT";
            end;
            SetValue = function(self)
              local position = db.profile:QueryType("string", "container.tabBar.position");

              if (position == "TOP" or position == "BOTTOM") then
                db.profile:Store(self.dbPath, "RIGHT");
              else
                db.profile:Store(self.dbPath, "DOWN");
              end
            end;
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
        step = 1;
        min = 30;
        max = 50;
      };
      {
        type = "slider";
        name = L["Icon Height"];
        dbPath = "profile.grid.height";
        step = 1;
        min = 30;
        max = 50;
      };
      {
        type = "slider";
        name = L["Icon Spacing"];
        dbPath = "profile.grid.slotSpacing";
        step = 1;
        min = 4;
        max = 16;
      };
      {
        type = "slider";
        name = "Max Icons Per Row";
        dbPath = "profile.grid.columns.max";
        tooltip = "The maximum number of icons that can appear per row when resizing the inventory frame using the grid view.";
        step = 1;
        min = 8;
        max = 50;
      };
      { type = "divider"; };
      {
        type = "check";
        name = "Show Item Levels";
        dbPath = "profile.grid.showItemLevels";
        tooltip = "If checked, item levels will show on top of the icons of equipment and weapon items.";
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
        step = 1;
        max = 15;
      };
      { type = "divider"; };
      {
        type = "slider";
        name = "Min Columns";
        dbPath = "profile.detailed.columns.min";
        tooltip = "The minimum number of columns that can appear per row when resizing the inventory frame using the detailed view.";
        min = 1;
        step = 1;
        max = 8;
      };
      {
        type = "slider";
        name = "Max Columns";
        dbPath = "profile.detailed.columns.max";
        tooltip = "The maximum number of columns that can appear per row when resizing the inventory frame using the detailed view.";
        min = 1;
        step = 1;
        max = 8;
      };
      { type = "divider"; };
      {
        type = "slider";
        name = "Min Rows";
        dbPath = "profile.detailed.rows.min";
        tooltip = "The minimum number of rows that can appear when resizing the inventory frame using the detailed view.";
        min = 1;
        step = 1;
        max = 20;
      };
      {
        type = "slider";
        name = "Max Rows";
        dbPath = "profile.detailed.rows.max";
        tooltip = "The maximum number of rows that can appear when resizing the inventory frame using the detailed view.";
        min = 1;
        step = 1;
        max = 50;
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
        step = 1;
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
        step = 1;
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