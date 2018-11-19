-- Setup Namespaces ------------------
local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local MENU_BUTTON_HEIGHT = 40;

-- Registers and Imports -------------

local LinkedListClass = obj:Import("Framework.System.Collections.LinkedList");
local Engine = obj:Import("MayronUI.Engine");
local ConfigModule = MayronUI:RegisterModule("Config");

namespace.ConfigModule = ConfigModule;

-- Local functions -------------------

local function ToolTip_OnEnter(frame)
    GameTooltip:SetOwner(frame, "ANCHOR_RIGHT", 0, 2);
    GameTooltip:AddLine(frame.tooltip);
    GameTooltip:Show();
end

local function ToolTip_OnLeave(frame)
    GameTooltip:Hide();
end

local function MenuButton_OnClick(menuButton)
    if (not menuButton:GetChecked()) then
        -- should not be allowed to uncheck a menu button by clicking it a second time!
        menuButton:SetChecked(true);
        return;
    end

    local configModule = MayronUI:ImportModule("Config");
    configModule:OpenMenu(menuButton.module:GetModuleName());    
end

-- ConfigModule -------------------

function ConfigModule:OnInitialize(data)
    if (not MayronUI:IsInstalled()) then 
        tk:Print("Please install the UI and try again.");
        return; 
    end

    data.configData = {}; 
    data.selectedMenuConfigTable = {};

    if (not data.window) then
        local menuListScrollChild = self:SetUpWindow();
        self:SetUpMenuButtons(menuListScrollChild);        
    end

    data.window:Show();
end

function ConfigModule:OnProfileChange(data) end

-- Gets the database path address from the child config data
function ConfigModule:GetDatabasePathInfo(data, dbPath, settingName)
    local rootTable;
    local rootTableType, dbPath = dbPath:match("([^.]+).(.*)");
    rootTableType = rootTableType:gsub("%s", ""):lower();

    if (rootTableType == "global") then
        rootTable = db.global;
    elseif (rootTableType == "profile") then
        rootTable = db.profile;
    else
        tk:Error("Unknown database root-table name for config data '%s' (expected 'global' or 'profile', found '%s')", 
        settingName, rootTableType);
    end

    if (type(dbPath) == "function") then
        -- dbPath can be assigned a function to dynamically generate the real dbPath
        return rootTable, dbPath();
    else
        return rootTable, dbPath;
    end
end

function ConfigModule:OpenMenu(data, moduleName)
    local menuButton = data.window.menuButtons[moduleName];

    -- change window back button state
    data.history:Clear();
    data.windowName:SetText("");
    data.window.back:SetEnabled(false);

    self:SetSelectedMenu(menuButton);

    PlaySound(tk.Constants.CLICK);
end

function ConfigModule:GetDatabaseValue(data, configTable)
    local rootTable, path;
    local value;

    if (not configTable.dbPath) then
        value = configTable.GetValue and configTable.GetValue();
    else
        rootTable, path = self:GetDatabasePathInfo(configTable.dbPath, configTable.name);

        if (configTable.type == "color") then
            value = {};
            value.r = db:ParsePathValue(rootTable, path..".r");
            value.g = db:ParsePathValue(rootTable, path..".g");
            value.b = db:ParsePathValue(rootTable, path..".b");
            value.a = db:ParsePathValue(rootTable, path..".a");
        else
            value = db:ParsePathValue(rootTable, path);
        end

        if (configTable.GetValue) then
            value = configTable.GetValue(rootTable, path, value);
        end
    end

    return value;
end

-- Updates the database based on the dbPath config value, or using SetValue,
-- and then calls "OnConfigUpdate" for the module that the config value belongs to.
function ConfigModule:SetDatabaseValue(data, widget, configTable, value)

    -- SetValue is a custom function to manually set the datbase config value
    if (configTable.SetValue) then
        local oldValue;

        if (configTable.dbPath) then
            rootTable, path = self:GetDatabasePathInfo(configTable.dbPath, configTable.name);
            oldValue = db:ParsePathValue(rootTable, path);
        end

        configTable.SetValue(path, value, widget, oldValue); -- only use of param "widget"
    else
        -- dbPath is required if not using a custom SetValue function!
        obj:Assert(configTable.dbPath, "%s is missing database path address element (dbPath) in config data.", childData.name);

        local rootTable, path = self:GetDatabasePathInfo(configTable.dbPath, configTable.name);
        db:SetPathValue(rootTable, configTable.dbPath, value);      
    end

    if (configTable.requiresReload) then
        self:ShowReloadMessage();
    elseif (configTable.requiresRestart) then
        self:ShowRestartMessage();
    end

    -- Update the module (the module that the config value belongs to):
    local module;

    if (configTable.module) then
        module = MayronUI:ImportModule(configTable.module);

    elseif (data.selectedMenuConfigTable.module) then
        -- use the module specified in the module's config data
        module = MayronUI:ImportModule(data.selectedMenuConfigTable.module);
    end    

    if (module.OnConfigUpdate) then
        local list = tk.Tables:ConvertPathToKeys(configTable.dbPath);       
        
        -- Trigger OnConfigUpdate here!
        module:OnConfigUpdate(list, value);
    end
end

Engine:DefineReturns("DynamicFrame");
-- @param menuFrame: the dynamic frame representing the module's config data
function ConfigModule:CreateMenu(data)
    -- else, create a new menu (dynamic frame) to based on the module's config data
    local menuParent = data.options:GetFrame();
    local menu = gui:CreateDynamicFrame(tk.Constants.AddOnStyle, menuParent, nil, 10);
    local menuScrollFrame = menu:GetFrame();

    -- add graphical dialog box to dynamic frame:
    gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, "Low", menuScrollFrame);
    menuScrollFrame:SetAllPoints(true); -- TODO is this needed?

    return menu;
end

function ConfigModule:RenderSelectedMenu(data, module)
    local moduleConfigTable = module.ConfigData;

    if (not (moduleConfigTable and type(moduleConfigTable.children) == "table")) then return end

    for _, widgetConfigTable in pairs(moduleConfigTable.children) do

        if (widgetConfigTable.type == "loop") then
            -- repeat the same configTable setup multiple times but with different parameters
            local value = self:GetDatabaseValue(widgetConfigTable);
            local widgetData = namespace.WidgetHandlers.loop:Run(data.selectedMenu:GetFrame(), configTable, value);

            for _, widgetConfigTable in ipairs(widgetData) do
                data.selectedMenu:AddChildren(self:SetUpWidget(widgetConfigTable));
            end

            tk.Tables:PushWrapper(widgetData);
        else
            data.selectedMenu:AddChildren(self:SetUpWidget(widgetConfigTable));
        end
    end

    -- TODO: Is this using groups correctly?
    -- if (data.selectedMenu.groups) then
    --     for _, group in ipairs(data.selectedMenu.groups) do
    --         -- check buttons should act like radio buttons (can only select 1 in group)
    --         tk:GroupCheckButtons(unpack(group));
    --     end
    -- end

    -- -- clean up data once used
    -- data.selectedMenu.groups = nil;

    module.ConfigData = nil;
    collectgarbage("collect");
end

function ConfigModule:SetSelectedMenu(data, menuButton)   
    if (data.selectedMenu) then
        -- hide old menu
        data.selectedMenu:Hide();
    end

    local menu = menuButton.menu or self:CreateMenu();
    data.selectedMenu = menu;

    if (menuButton.module.ConfigData) then
        -- use config data to render widgets and then remove config data
        self:RenderSelectedMenu(menuButton.module);
    end

    -- fade menu in...
    UIFrameFadeIn(menu:GetFrame(), 0.3, 0, 1);
    collectgarbage("collect"); -- all config data has been loaded and set to nil, so clean it
end

function ConfigModule:ShowReloadMessage(data)
    data.warningLabel:SetText(data.warningLabel.reloadText);
end

function ConfigModule:ShowRestartMessage()
    data.warningLabel:SetText(data.warningLabel.restartText);
end

-- create container to wrap around a child element
Engine:DefineParams("table", "table");
function ConfigModule:CreateElementContainerFrame(data, widget, childData)
    local container = tk:PopFrame("Frame", data.parent);

    container:SetSize(childData.width or widget:GetWidth(), childData.height or widget:GetHeight());
    container.widget = widget;

    widget:SetParent(container);

    if (childData.name and tk:ValueIsEither(childData.type, "slider", "dropdown", "textField")) then

        container.name = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        container.name:SetPoint("TOPLEFT", 0, -5);
        container.name:SetText(childData.name);
        container:SetHeight(container:GetHeight() + container.name:GetStringHeight() + 15);

        widget:SetPoint("TOPLEFT", container.name, "BOTTOMLEFT", 0, -5);

        if (childData.type == "slider") then
            container.name:SetPoint("TOPLEFT", 10, -5);
            container:SetWidth(container:GetWidth() + 20);
        end
    else
        widget:SetPoint("LEFT");
    end

    return container;
end

Engine:DefineParams("table");
function ConfigModule:SetUpWidget(data, widgetConfigTable)

    -- Inherit all key and value pairs from a parent table by injecting them into childData
    if (type(data.selectedMenuConfigTable.inherit) == "table") then
        setmetatable(widgetConfigTable, { __index = data.selectedMenuConfigTable.inherit });
    end  

    local widgetType = widgetConfigTable.type;
    
    -- treat the widget like a check button (except when grouping the check buttons)
    if (widgetType == "radio") then
        widgetType = "check";
    end

    obj:Assert(namespace.WidgetHandlers[widgetType], 
        "Unsupported widget type '%s' found in config data.", widgetType or "nil");

    if (widgetConfigTable.OnInitialize) then
        -- do disabled widgets need to be initialized?
        widgetConfigTable.OnInitialize(widgetConfigTable);
        widgetConfigTable.OnInitialize = nil;
    end
    
    if (widgetConfigTable.disabled) then
        -- why? does this not still need to be added?
        return;
    end

    -- create the widget!
    local value = self:GetDatabaseValue(widgetConfigTable);
    local widget = namespace.WidgetHandlers[widgetType]:Run(data.selectedMenu:GetFrame(), widgetConfigTable, value);

    if (widgetConfigTable.devMode) then
        -- highlight the widget in dev mode.
        tk:SetBackground(widget, math.random(), math.random(), math.random());
    end

    if (tk:ValueIsEither(widgetType, "title", "divider", "fontstring")) then
        -- takes up the full width of the config window!
        tk:SetFullWidth(widget, 10);
    end

    if (widgetConfigTable.tooltip) then
        widget:SetScript("OnEnter", ToolTip_OnEnter);
        widget:SetScript("OnLeave", ToolTip_OnLeave);
    end

    -- check original type (configTable.type) because widgetType might have changed radio to check
    if (widgetConfigTable.type == "radio" and widgetConfigTable.group) then
        data.selectedMenuConfigTable.groups = data.selectedMenuConfigTable.groups or {};

        -- configTable.group should be a string            
        local radioButtonGroup = data.selectedMenuConfigTable.groups[widgetConfigTable.group] or {};
        data.selectedMenuConfigTable.groups[widgetConfigTable.group] = radioButtonGroup;

        table.insert(radioButtonGroup, widget.btn);
    end

    -- setup complete, so run the OnLoad callback if one exists
    if (widgetConfigTable.OnLoad) then
        widgetConfigTable.OnLoad(widgetConfigTable, widget);
        widgetConfigTable.OnLoad = nil;
    end

    return widget;
end

function ConfigModule:SetUpWindow(data)
    if (data.window) then 
        return; 
    end

    data.history = LinkedListClass();

    data.window = gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, nil, nil, "MUI_Config");
    data.window:SetFrameStrata("DIALOG");
    data.window:Hide();
    data.window:SetMinResize(600, 400);
    data.window:SetMaxResize(1200, 800);
    data.window:SetSize(800, 500);
    data.window:SetPoint("CENTER");

    gui:AddTitleBar(tk.Constants.AddOnStyle, data.window, "MUI Config");
    gui:AddResizer(tk.Constants.AddOnStyle, data.window);
    gui:AddCloseButton(tk.Constants.AddOnStyle, data.window);

    -- convert container to a panel
    data.window = gui:CreatePanel(data.window);
    data.window:SetDevMode(false); -- shows or hides the red frame info overlays
    data.window:SetDimensions(2, 3);
    data.window:GetColumn(1):SetFixed(200);
    data.window:GetRow(1):SetFixed(80);
    data.window:GetRow(3):SetFixed(50);
    data.window:SetScript("OnShow", function(self)
        -- fade in when shown
        UIFrameFadeIn(self, 0.3, 0, 1);
    end);

    local topbar = data.window:CreateCell();
    topbar:SetInsets(25, 14, 2, 10);
    topbar:SetDimensions(2, 1);

    local menuList, scrollChild = gui:CreateScrollFrame(tk.Constants.AddOnStyle, data.window:GetFrame());
    menuList.ScrollBar:SetPoint("TOPLEFT", menuList.ScrollFrame, "TOPRIGHT", -5, 0);
    menuList.ScrollBar:SetPoint("BOTTOMRIGHT", menuList.ScrollFrame, "BOTTOMRIGHT", 0, 0);
    menuList = data.window:CreateCell(menuList);
    menuList:SetInsets(2, 10, 10, 10);
    menuList:SetDimensions(1, 2);

    data.options = data.window:CreateCell();
    data.options:SetInsets(2, 14, 2, 2);

    local bottombar = data.window:CreateCell();
    bottombar:SetInsets(2, 30, 10, 2);
    data.window:AddCells(topbar, menuList, data.options, bottombar);

    data.warningLabel = bottombar:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    data.warningLabel:SetPoint("LEFT");
    data.warningLabel:SetText("");
    data.warningLabel.reloadText = L["The UI requires reloading to apply changes."];
    data.warningLabel.restartText = L["Some changes require a client restart to take effect."];

    -- forward and back buttons
    data.window.back = gui:CreateButton(tk.Constants.AddOnStyle, topbar:GetFrame());
    data.window.back:SetPoint("LEFT");
    data.window.back:SetWidth(50);
    data.window.back.arrow = data.window.back:CreateTexture(nil, "OVERLAY");
    data.window.back.arrow:SetTexture(tk.Constants.MEDIA.."other\\arrow_side");
    data.window.back.arrow:SetSize(16, 14);
    data.window.back.arrow:SetPoint("CENTER", -1, 0);

    data.window.back:SetScript("OnClick", function(backButton)
        --local configTable = data.history:GetBack();
        --data.history:RemoveBack();

        -- TODO: This is no longer how it works (uses menuButton but might need a path "name")
        --self:SetSelectedMenu(configTable);

        if (data.history:GetSize() == 0) then
            data.windowName:SetText("");
            backButton:SetEnabled(false);
        else
            data.windowName:SetText(menuData.name);
        end

        PlaySound(tk.Constants.CLICK);
    end);

    data.windowName = topbar:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    data.windowName:SetPoint("LEFT", data.window.back, "RIGHT", 10, 0);

    tk:ApplyThemeColor(data.window.back.arrow);
    data.window.back:SetEnabled(false);

    data.window.profiles = gui:CreateButton(tk.Constants.AddOnStyle, topbar:GetFrame(), L["Reload UI"]); -- will change to profiles another time
    data.window.profiles:SetPoint("RIGHT", topbar:GetFrame(), "RIGHT");
    data.window.profiles:SetScript("OnClick", function()
        ReloadUI();
        tk.PlaySound(tk.Constants.CLICK);
    end);

    data.window.installer = gui:CreateButton(tk.Constants.AddOnStyle, topbar:GetFrame(), L["MUI Installer"]);
    data.window.installer:SetPoint("RIGHT", data.window.profiles, "LEFT", -10, 0);

    data.window.installer:SetScript("OnClick", function()
        MayronUI:TriggerCommand("install");
        data.window:Hide();
        tk.PlaySound(tk.Constants.CLICK);
    end);

    tk:SetFullWidth(scrollChild);     

    return scrollChild;
end

-- Loads all config data from individual modules and places them as a graphical menu
function ConfigModule:SetUpMenuButtons(data, menuListScrollChild)   
    local id = 0; 

    data.window.menuButtons = {};

    -- contains all menu buttons in the left scroll frame of the main config window
    local scrollChildHeight = menuListScrollChild:GetHeight() + MENU_BUTTON_HEIGHT;
    menuListScrollChild:SetHeight(scrollChildHeight);    
    
    for moduleName, module in MayronUI:IterateModules() do
        if (module.ConfigData) then
            id = id + 1;         

            local menuButton = CreateFrame("CheckButton", nil, menuListScrollChild);
            data.window.menuButtons[id] = menuButton
            data.window.menuButtons[moduleName] =menuButton;
            menuButton.module = module;

            menuButton.text = menuButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            menuButton.text:SetText(module.ConfigData.name);
            menuButton.text:SetJustifyH("LEFT");
            menuButton.text:SetPoint("TOPLEFT", 10, 0);
            menuButton.text:SetPoint("BOTTOMRIGHT");

            local normal = tk:SetBackground(menuButton, 1, 1, 1, 0);
            local highlight = tk:SetBackground(menuButton, 1, 1, 1, 0);
            local checked = tk:SetBackground(menuButton, 1, 1, 1, 0);

            -- first argument is the alpha
            tk:ApplyThemeColor(0.3, normal, highlight);
            tk:ApplyThemeColor(0.6, checked);

            menuButton:SetSize(250, MENU_BUTTON_HEIGHT);
            menuButton:SetNormalTexture(normal);
            menuButton:SetHighlightTexture(highlight);
            menuButton:SetCheckedTexture(checked);
            menuButton:SetScript("OnClick", MenuButton_OnClick);

            -- position menu button (and set active if it's the first menu button)
            if (id == 1) then
                -- first menu button (does not need to be anchored to a previous button)
                menuButton:SetPoint("TOPLEFT", menuListScrollChild, "TOPLEFT");
                menuButton:SetPoint("TOPRIGHT", menuListScrollChild, "TOPRIGHT", -10, 0);
                menuButton:SetChecked(true);

                self:SetSelectedMenu(menuButton);
            else
                local previousMenuButton = data.window.menuButtons[id - 1];
                menuButton:SetPoint("TOPLEFT", previousMenuButton, "BOTTOMLEFT", 0, -5);
                menuButton:SetPoint("TOPRIGHT", previousMenuButton, "BOTTOMRIGHT", 0, -5);

                -- make room for padding between buttons
                menuListScrollChild:SetHeight(menuListScrollChild:GetHeight() + 5);
            end
        end
    end

    tk:GroupCheckButtons(tk.unpack(data.window.menuButtons));
end