-- Setup Namespaces ------------------
local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local MENU_BUTTON_HEIGHT = 40;

-- Registers and Imports -------------

local LinkedListClass = obj:Import("Framework.System.Collections.LinkedList");
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

-- ConfigModule -------------------

function ConfigModule:OnInitialize(data)
    if (not MayronUI:IsInstalled()) then 
        tk:Print("Please install the UI and try again.");
        return; 
    end

    -- generates data.configData
    self:ScanForData();

    if (not data.window) then
        self:SetUpWindow();
    else
        data.window:Show();
    end
end

function ConfigModule:OnProfileChange(data)
    
end

-- get the database path address value
function ConfigModule:GetDatabasePathInfo(data, childData)
    if (not childData.dbPath) then return end

    local rootTable;
    local rootTableType, dbPath = dbPath:match("([^.]+).(.*)");
    rootTableType = rootTableType:gsub("%s", ""):lower();

    if (rootTableType == "global") then
        rootTable = db.global;
    elseif (rootTableType == "profile") then
        rootTable = db.profile;
    else
        tk:Error("Unknown database path root table type '%s'", rootTableType);
    end

    if (type(childData.dbPath) == "function") then
        return rootTable, childData.dbPath();
    else
        return rootTable, childData.dbPath;
    end
end

-- updates the config of all modules
function ConfigModule:UpdateConfig(data, widget, childData, value)
    if (childData.SetValue) then
        local rootTable, path = self:GetDatabasePathInfo(childData);

        if (not path) then
            childData.SetValue(value, widget);
        else
            local oldValue = db:ParsePathValue(rootTable, path);
            childData.SetValue(path, oldValue, value, widget); -- custom way to set the value
        end
    else
        obj:Assert(childData.dbPath, "%s is missing database path address element (dbPath) in config data.", childData.name);

        if (childData.isGlobal) then
            db:SetPathValue(db.global, childData.dbPath, value);
        else
            db:SetPathValue(db.profile, childData.dbPath, value);
        end        
    end

    if (childData.requiresReload) then
        config:ShowReloadMessage();
    elseif (childData.requiresRestart) then
        config:ShowRestartMessage();
    end

    -- TODO: Update specific module
    -- -- find the module and call the "OnConfigUpdate" function
    -- if (child_data.module or config.submenu_data.module and child_data.db_path) then
    --     local module = MayronUI:ImportModule(child_data.module or config.submenu_data.module);

    --     if (module.OnConfigUpdate) then
    --         local list = tk:ConvertPathToKeys(child_data.db_path);
    --         module:OnConfigUpdate(list, value);
    --     end
    -- end
end

function ConfigModule:SetMenu(data, menuData)
    data.currentMenu.data = menuData;

    if (menuData.menu) then
        -- already previously created so switch to it...
        private:SwitchContent(menuData.menu);
        return;
    end

    -- load the content:
    local menuParent = data.options:GetFrame();
    menuData.menu = gui:CreateDynamicFrame(tk.Constants.AddOnStyle, menuParent, nil, 10);

    local menuScrollFrame = menuData.menu:GetFrame();

    -- add graphical dialog box to dynamic frame:
    gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, "Low", menuScrollFrame);
    menuScrollFrame:SetAllPoints(true); -- TODO is this needed?

    private:SwitchContent(menuData.menu); -- TODO can I send this the scroller?    
end

function ConfigModule:SwitchMenu(data, newMenu)
    if (data.currentMenu.menu) then
        -- hide old menu
        data.currentMenu.menu:Hide();
    end

    local menuFrame = newMenu:GetFrame(); 
    data.parent = menuFrame;   
    data.currentMenu.menu = newMenu; -- update to new menu

    if (not data.currentMenu.data.isLoaded) then        
        local menuData = data.currentMenu.data;

        if (menuData.children) then
            for _, childData in pairs(menuData.children) do
                -- load menu child element
                self:SetUpWidget(childData, menuFrame, menuData);
            end

            if (menuData.groups) then
                for _, group in ipairs(menuData.groups) do
                    -- check buttons should act like radio buttons (can only select 1 in group)
                    tk:GroupCheckButtons(unpack(group));
                end
            end

            -- clean up data once used
            menuData.groups = nil;
        end
    end

    -- fade menu in...
    UIFrameFadeIn(menuFrame, 0.3, 0, 1);
    collectgarbage("collect"); -- all config data has been loaded and set to nil, so clean it
end

-- TODO: show Categories that were not previously registered (when addon is loaded)
function ConfigModule:UpdateCategories() end

function ConfigModule:ShowReloadMessage(data)
    data.warningLabel:SetText(data.warningLabel.reloadText);
end

function ConfigModule:ShowRestartMessage()
    data.warningLabel:SetText(data.warningLabel.restartText);
end

-- create container to wrap around a child element
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

function ConfigModule:GetValue(data, childData)
    local path = self:GetDatabasePathInfo(childData);
    local value;

    if (not path) then
        value = childData.GetValue and childData.GetValue();

    elseif (childData.type == "color") then
        value = {
            r = db:ParsePathValue(tk.Strings:Concat(path, ".r"));
            g = db:ParsePathValue(tk.Strings:Concat(path, ".g"));
            b = db:ParsePathValue(tk.Strings:Concat(path, ".b"));
            a = db:ParsePathValue(tk.Strings:Concat(path, ".a"));
        };

    else
        value = db:ParsePathValue(path);

        if (childData.GetValue) then
            value = childData.GetValue(path, value);
        end
    end
    
    return value;
end

--child_data, parent_dynamicFrame, submenu_data)
function ConfigModule:SetUpWidget(data, childData, menuFrame, menuData)
    if (menuData.inherit) then
        for key, value in tk.pairs(menuData.inherit) do
            if (not childData[key]) then
                childData[key] = value;
            end
        end
    end

    local widgetType = childData.type;

    if (widgetType == "loop") then
        for _, data in ipairs(data.loop:Run(childData)) do
            for _, childData in ipairs(data) do
                self:SetUpWidget(childData, menuFrame, menuData);
            end
        end

        return
    end    

    if (widgetType == "radio") then
        widgetType = "check";
    end

    obj:Assert(namespace.WidgetHandlers[widgetType], 
        "Unsupported widget type '%s' found in config data.", widgetType);

    if (childData.OnInitialize) then
        childData.OnInitialize(childData);
        childData.OnInitialize = nil;
    end
    
    if (not childData.disabled) then
        -- create the widget!
        local widget = namespace.WidgetHandlers[widgetType]:Run(childData);

        menuFrame:AddChildren(widget);

        if (childData.devMode) then
            tk:SetBackground(widget, math.random(), math.random(), math.random());
        end

        if (tk:ValueIsEither(widgetType, "title", "divider", "fontstring")) then
            tk:SetFullWidth(widget, 10);
        end

        -- check original type (childData.type) because widgetType might have changed radio to check
        if (childData.type == "radio" and childData.group) then
            menuData.groups = menuData.groups or {};

            -- childData.group should be a string            
            local radioButtonGroup = menuData.groups[childData.group] or {};
            menuData.groups[childData.group] = radioButtonGroup;

            table.insert(radioButtonGroup, widget.btn);
        end

        -- setup complete, so run the OnLoad callback if one exists
        if (childData.OnLoad) then
            childData.OnLoad(childData, widget);
            childData.OnLoad = nil;
        end
    end
end

function ConfigModule:SetupMenu(data)
    if (data.window) then 
        return; 
    end

    data.history = LinkedListClass();

    data.window = gui:CreateDialogBox(nil, nil, nil, "MUI_Config");
    data.window:SetFrameStrata("DIALOG");
    data.window:Hide();
    data.window:SetMinResize(600, 400);
    data.window:SetMaxResize(1200, 800);
    data.window:SetSize(800, 500);
    data.window:SetPoint("CENTER");

    gui:AddTitleBar(data.window, "MUI Config");
    gui:AddResizer(data.window);
    gui:AddCloseButton(data.window);

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
    end)

    local topbar = data.window:CreateCell();
    topbar:SetInsets(25, 14, 2, 10);
    topbar:SetDimensions(2, 1);

    local categories, scrollchild = gui:CreateScrollFrame(data.window:GetFrame());
    categories.ScrollBar:SetPoint("TOPLEFT", categories.ScrollFrame, "TOPRIGHT", -5, 0);
    categories.ScrollBar:SetPoint("BOTTOMRIGHT", categories.ScrollFrame, "BOTTOMRIGHT", 0, 0);
    categories = data.window:CreateCell(categories);
    categories:SetInsets(2, 10, 10, 10);
    categories:SetDimensions(1, 2);

    local options = data.window:CreateCell();
    options:SetInsets(2, 14, 2, 2);
    config.options = options;

    local bottombar = data.window:CreateCell();
    bottombar:SetInsets(2, 30, 10, 2);
    data.window:AddCells(topbar, categories, options, bottombar);

    data.warningLabel = bottombar:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    data.warningLabel:SetPoint("LEFT");
    data.warningLabel:SetText("");
    data.warningLabel.reloadText = L["The UI requires reloading to apply changes."];
    data.warningLabel.restartText = L["Some changes require a client restart to take effect."];

    -- forward and back buttons
    data.window.back = gui:CreateButton(topbar:GetFrame());
    data.window.back:SetPoint("LEFT");
    data.window.back:SetWidth(50);
    data.window.back.arrow = data.window.back:CreateTexture(nil, "OVERLAY");
    data.window.back.arrow:SetTexture(tk.Constants.MEDIA.."other\\arrow_side");
    data.window.back.arrow:SetSize(16, 14);
    data.window.back.arrow:SetPoint("CENTER", -1, 0);

    data.window.back:SetScript("OnClick", function(self)
        local menuData = data.history:GetBack();
        data.history:RemoveBack();
        config:SetSubMenu(menuData);

        if (data.history:GetSize() == 0) then
            data.menuName:SetText("");
            self:SetEnabled(false);
        else
            data.menuName:SetText(menuData.name);
        end

        PlaySound(tk.Constants.CLICK);
    end);

    data.windowName = topbar:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    data.windowName:SetPoint("LEFT", data.window.back, "RIGHT", 10, 0);

    tk:SetThemeColor(data.window.back.arrow);
    data.window.back:SetEnabled(false);

    data.window.profiles = gui:CreateButton(topbar:GetFrame(), L["Reload UI"]); -- will change to profiles another time
    data.window.profiles:SetPoint("RIGHT", topbar:GetFrame(), "RIGHT");
    data.window.profiles:SetScript("OnClick", function()
        ReloadUI();
        tk.PlaySound(tk.Constants.CLICK);
    end);

    data.window.installer = gui:CreateButton(topbar:GetFrame(), L["MUI Installer"]);
    data.window.installer:SetPoint("RIGHT", data.window.profiles, "LEFT", -10, 0);

    data.window.installer:SetScript("OnClick", function()
        MayronUI:TriggerCommand("install");
        data.window:Hide();
        tk.PlaySound(tk.Constants.CLICK);
    end);

    data.window.menus = {};
    tk:SetFullWidth(scrollchild)

    -- a category is a menu, but a menu is not a category
    self:SetUpCategories(scrollchild);
   
    tk:GroupCheckButtons(tk.unpack(data.window.menus));
    data.window:Show();
end

function ConfigModule:SetUpCategories(data, scrollChild)
    -- TODO! ~ configData is where all the configData from multiple addons is loaded
    for id, categoryData in ipairs(data.configData) do
        data.window.menus[id] = CreateFrame("CheckButton", nil, scrollChild);

        -- contains all menu buttons in the left scroll frame of the main config window
        local scrollChildHeight = scrollChild:GetHeight() + MENU_BUTTON_HEIGHT;
        scrollchild:SetHeight(scrollChildHeight);

        -- the left side button to load the menu (and category data)
        local menuButton = data.window.menus[id];
        menuButton.text = menuButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        menuButton.text:SetText(categoryData.name);
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

        menuButton:SetScript("OnClick", function(self)
            if (not self:GetChecked()) then
                self:SetChecked(true);
                return;
            end

            data.history:Clear();
            data.menuName:SetText("");

            -- TODO: Might need to be currentMenu, or just move the back button to the window level
            data.menu.back:SetEnabled(false);

            self:SetSubMenu(categoryData);
            PlaySound(tk.Constants.CLICK);
        end);

        -- position menu button (and set active if it's the first menu button)
        if (id == 1) then
            -- first menu button (does not need to be anchored to a previous button)
            menuButton:SetPoint("TOPLEFT", scrollChild, "TOPLEFT");
            menuButton:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -10, 0);

            -- first time loaded so set the current menu to the first one in the scrollChild
            self:SetSubMenu(categoryData);
            menuButton:SetChecked(true);
        else
            local previousMenuButton = data.window.menus[id - 1];
            menuButton:SetPoint("TOPLEFT", previousMenuButton, "BOTTOMLEFT", 0, -5);
            menuButton:SetPoint("TOPRIGHT", previousMenuButton, "BOTTOMRIGHT", 0, -5);

            -- make room for padding between buttons
            scrollChild:SetHeight(scrollChild:GetHeight() + 5);
        end
    end
end

function ConfigModule:AddConfigData(data, ...)
    for _, configData in tk.Tables:IterateArgs(...) do
        tk.table.insert(data.configData, configData);
    end

    if (self:IsInitialized()) then
        self:UpdateMenus(); -- TODO: doesn't do anything!
    end
end

function ConfigModule:ScanForData()
    for _, module in MayronUI:IterateModules() do
        if (module.GetConfigData) then
            local configDataTable = module:GetConfigData();

            for _, configData in pairs(configDataTable) do
                if (type(configData) == "table") then
                    self:AddConfigData(configData);
                end
            end
        end
    end
end