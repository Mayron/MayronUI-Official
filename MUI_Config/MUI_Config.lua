-- luacheck: ignore MayronUI self 143
local _, namespace = ...;
local tk, db, _, gui, obj, L = MayronUI:GetCoreComponents();

local MENU_BUTTON_HEIGHT = 40;

-- Registers and Imports -------------

local LinkedListClass = obj:Import("Framework.System.Collections.LinkedList");
local Engine = obj:Import("MayronUI.Engine");
local ConfigModule = MayronUI:RegisterModule("Config");

namespace.ConfigModule = ConfigModule;

-- Local functions -------------------

local function ToolTip_OnEnter(frame)
    _G.GameTooltip:SetOwner(frame, "ANCHOR_RIGHT", 0, 2);
    _G.GameTooltip:AddLine(frame.tooltip);
    _G.GameTooltip:Show();
end

local function ToolTip_OnLeave()
    _G.GameTooltip:Hide();
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

local function SubMenuButton_OnClick(subMenuButton)
    local configModule = MayronUI:ImportModule("Config");
    configModule:OpenMenu(subMenuButton.moduleName, subMenuButton);
end

namespace.SubMenuButton_OnClick = SubMenuButton_OnClick;

-- ConfigModule -------------------

function ConfigModule:OnInitialize(data)
    if (not MayronUI:IsInstalled()) then
        tk:Print("Please install the UI and try again.");
        return;
    end

    data.configData = {};
end

function ConfigModule:Show(data)
    if (not data.window) then
        local menuListScrollChild = self:SetUpWindow();
        self:SetUpMenuButtons(menuListScrollChild);
    end

    data.window:Show();
end


function ConfigModule:OnProfileChange() end

Engine:DefineParams("table");
function ConfigModule:GetDatabaseValue(_, configTable)

    if (tk.Strings:IsNilOrWhiteSpace(configTable.dbPath)) then
        return configTable.GetValue and configTable.GetValue();
    end

    local path = configTable.dbPath;
    local value;

    if (type(path) == "function") then
        path = path();
    end

    if (configTable.type == "color") then
        value = {};
        value.r = db:ParsePathValue(string.format("%s.r", path));
        value.g = db:ParsePathValue(string.format("%s.g", path));
        value.b = db:ParsePathValue(string.format("%s.b", path));
        value.a = db:ParsePathValue(string.format("%s.a", path));
    else
        value = db:ParsePathValue(path);
    end

    if (configTable.GetValue) then
        value = configTable.GetValue(path, value);
    end

    return value;
end

-- Updates the database based on the dbPath config value, or using SetValue,
-- and then calls "OnConfigUpdate" for the module that the config value belongs to.
--@param widget: The created widget frame passed when calling SetValue to add custom
--      graphical changes to represent the new value (such as disabling the widget)
function ConfigModule:SetDatabaseValue(data, widget, widgetConfigTable, value)

    -- SetValue is a custom function to manually set the datbase config value
    if (widgetConfigTable.SetValue) then
        local oldValue;

        if (not tk.Strings:IsNilOrWhiteSpace(widgetConfigTable.dbPath)) then
            oldValue = db:ParsePathValue(widgetConfigTable.dbPath);
        end

        widgetConfigTable.SetValue(widgetConfigTable.dbPath, value, oldValue, widget);
    else
        -- dbPath is required if not using a custom SetValue function!
        tk:Assert(not tk.Strings:IsNilOrWhiteSpace(widgetConfigTable.dbPath),
            "%s is missing database path address element (dbPath) in config data.", widgetConfigTable.name);

        db:SetPathValue(widgetConfigTable.dbPath, value);
    end

    if (widgetConfigTable.requiresReload) then
        self:ShowReloadMessage();
    elseif (widgetConfigTable.requiresRestart) then
        self:ShowRestartMessage();
    end

    local module = data.selectedButton.module;

    if (not module and data.selectedButton.moduleName) then
        -- it's a sub menu!
        module = MayronUI:ImportModule(data.selectedButton.moduleName);
    end

    local list = tk.Tables:ConvertPathToKeys(widgetConfigTable.dbPath);

    -- Trigger Module Update via OnConfigUpdate:
    module:OnConfigUpdate(list, value);
end

Engine:DefineParams("string", "?Button");
function ConfigModule:OpenMenu(data, moduleName, subMenuButton)
    local menuButton;

    if (not subMenuButton) then
        menuButton = data.menuButtons[moduleName];

        data.history:Clear();
        data.windowName:SetText(tk.Strings.Empty);
        data.window.back:SetEnabled(false);
    else
        menuButton = subMenuButton;

        data.history:AddToBack(data.selectedButton);
        data.windowName:SetText(subMenuButton.text:GetText());
        data.window.back:SetEnabled(true);
    end

    self:SetSelectedButton(menuButton);
    _G.PlaySound(tk.Constants.CLICK);
end

Engine:DefineParams("CheckButton|Button");
function ConfigModule:SetSelectedButton(data, menuButton)
    if (data.selectedButton) then
        -- hide old menu
        data.selectedButton.menu:Hide();
    end

    menuButton.menu = menuButton.menu or self:CreateMenu();
    data.selectedButton = menuButton;

    if (menuButton.module and menuButton.module.ConfigData) then
        -- use config data to render widgets and then remove config data
        self:RenderSelectedMenu(menuButton.module.ConfigData);
        menuButton.module.ConfigData = nil;

    elseif (menuButton.configTable) then
        -- it is a sub-menu!
        self:RenderSelectedMenu(menuButton.configTable);
        menuButton.configTable = nil;
    end

    collectgarbage("collect");

    -- fade menu in...
    data.selectedButton.menu:Show();
    _G.UIFrameFadeIn(data.selectedButton.menu, 0.3, 0, 1);
end

Engine:DefineParams("table");
function ConfigModule:RenderSelectedMenu(data, menuConfigTable)
    if (not (menuConfigTable and type(menuConfigTable.children) == "table")) then
        return;
    end

    data.tempMenuConfigTable = menuConfigTable;

    for _, widgetConfigTable in pairs(menuConfigTable.children) do

        if (widgetConfigTable.type == "loop") then
            -- run the loop to gather widget children
            local widgetChildren = namespace.WidgetHandlers.loop:Run(
                data.selectedButton.menu:GetFrame(), widgetConfigTable);

            for _, subWidgetConfigTable in ipairs(widgetChildren) do
                data.selectedButton.menu:AddChildren(self:SetUpWidget(subWidgetConfigTable));
            end

            -- the table was previously popped
            tk.Tables:PushWrapper(widgetChildren);
        else
            data.selectedButton.menu:AddChildren(self:SetUpWidget(widgetConfigTable));
        end
    end

    if (data.tempMenuConfigTable.groups) then
        for _, group in ipairs(data.tempMenuConfigTable.groups) do
            tk:GroupCheckButtons(_G.unpack(group));
        end
    end

    data.tempMenuConfigTable = nil;
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

function ConfigModule:ShowReloadMessage(data)
    data.warningLabel:SetText(data.warningLabel.reloadText);
end

function ConfigModule:ShowRestartMessage(data)
    data.warningLabel:SetText(data.warningLabel.restartText);
end

-- create container to wrap around a child element
Engine:DefineParams("table", "table");
function ConfigModule:CreateElementContainerFrame(data, widget, childData)
    local container = tk:PopFrame("Frame", data.parent);

    container:SetSize(childData.width or widget:GetWidth(), childData.height or widget:GetHeight());
    container.widget = widget;

    widget:SetParent(container);

    if (childData.name and tk:ValueIsEither(childData.type, "slider", "dropdown", "textfield")) then

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

    tk:Assert(type(data.tempMenuConfigTable) == "table",
        "Invalid temp data for '%s'", widgetConfigTable.name);

    if (not tk.Strings:IsNilOrWhiteSpace(data.tempMenuConfigTable.dbPath) and
        not tk.Strings:IsNilOrWhiteSpace(widgetConfigTable.appendDbPath)) then

        -- append the widget config table's dbPath value onto it!
        widgetConfigTable.dbPath = tk.Strings:Join(".",
            data.tempMenuConfigTable.dbPath, widgetConfigTable.appendDbPath);
    end

    if (type(data.tempMenuConfigTable.inherit) == "table") then
        -- Inherit all key and value pairs from a parent table by injecting them into childData
        local metaTable = tk.Tables:PopWrapper();
        metaTable.__index = data.tempMenuConfigTable.inherit;
        setmetatable(widgetConfigTable, metaTable);
    end

    local widgetType = widgetConfigTable.type;

    -- treat the widget like a check button (except when grouping the check buttons)
    if (widgetType == "radio") then
        widgetType = "check";
    end

    obj:Assert(namespace.WidgetHandlers[widgetType],
        "Unsupported widget type '%s' found in config data", widgetType or "nil");

    if (widgetConfigTable.OnInitialize) then
        -- do disabled widgets need to be initialized?
        widgetConfigTable.OnInitialize(widgetConfigTable);
        widgetConfigTable.OnInitialize = nil;
    end

    local currentValue = self:GetDatabaseValue(widgetConfigTable);

    -- create the widget!
    local widget = namespace.WidgetHandlers[widgetType]:Run(
        data.selectedButton.menu:GetFrame(), widgetConfigTable, currentValue);

    if (widgetConfigTable.devMode) then
        -- highlight the widget in dev mode.
        tk:SetBackground(widget, math.random(), math.random(), math.random());
    end

    if (tk:ValueIsEither(widgetType, "title", "divider", "fontstring")) then
        -- takes up the full width of the config window!
        tk:SetFullWidth(widget, 10);
    end

    if (widgetConfigTable.type == "radio" and widgetConfigTable.groupName) then
        local tempRadioButtonGroup = tk.Tables:GetTable(
            data.tempMenuConfigTable, "groups", widgetConfigTable.groupName);

        table.insert(tempRadioButtonGroup, widget.btn);
    end

    if (widgetConfigTable.tooltip) then
        widget:SetScript("OnEnter", ToolTip_OnEnter);
        widget:SetScript("OnLeave", ToolTip_OnLeave);
    end

    -- if (widgetConfigTable.disabled) then
    --     -- why? does this not still need to be added?
    --     return;
    -- end

    -- setup complete, so run the OnLoad callback if one exists
    if (widgetConfigTable.OnLoad) then
        widgetConfigTable.OnLoad(widgetConfigTable, widget);
        widgetConfigTable.OnLoad = nil;
    end

    return widget;
end

function ConfigModule:SetUpWindow(data)
    if (data.window) then
        return
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
    data.window:SetScript("OnShow", function()
        -- fade in when shown
        _G.UIFrameFadeIn(data.window, 0.3, 0, 1);
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
        local menuButton = data.history:GetBack();
        data.history:RemoveBack();

        self:SetSelectedButton(menuButton);

        if (data.history:GetSize() == 0) then
            data.windowName:SetText("");
            backButton:SetEnabled(false);
        else
            local previousMenuButton = data.history:GetBack();
            data.windowName:SetText(previousMenuButton.text:GetText());
        end

        _G.PlaySound(tk.Constants.CLICK);
    end);

    data.windowName = topbar:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    data.windowName:SetPoint("LEFT", data.window.back, "RIGHT", 10, 0);

    tk:ApplyThemeColor(data.window.back.arrow);
    data.window.back:SetEnabled(false);

    data.window.profiles = gui:CreateButton(
        tk.Constants.AddOnStyle, topbar:GetFrame(), L["Reload UI"]);

    data.window.profiles:SetPoint("RIGHT", topbar:GetFrame(), "RIGHT");
    data.window.profiles:SetScript("OnClick", function()
        _G.ReloadUI();
        tk.PlaySound(tk.Constants.CLICK);
    end);

    data.window.installer = gui:CreateButton(
        tk.Constants.AddOnStyle, topbar:GetFrame(), L["MUI Installer"]);

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

    data.menuButtons = {};

    -- contains all menu buttons in the left scroll frame of the main config window
    local scrollChildHeight = menuListScrollChild:GetHeight() + MENU_BUTTON_HEIGHT;
    menuListScrollChild:SetHeight(scrollChildHeight);

    for _, module in MayronUI:IterateModules() do

        if (module.ConfigData) then
            local moduleName = module:GetModuleName();
            id = id + 1;

            local menuButton = _G.CreateFrame("CheckButton", nil, menuListScrollChild);
            data.menuButtons[id] = menuButton
            data.menuButtons[moduleName] = menuButton;
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

                self:SetSelectedButton(menuButton);
            else
                local previousMenuButton = data.menuButtons[id - 1];
                menuButton:SetPoint("TOPLEFT", previousMenuButton, "BOTTOMLEFT", 0, -5);
                menuButton:SetPoint("TOPRIGHT", previousMenuButton, "BOTTOMRIGHT", 0, -5);

                -- make room for padding between buttons
                menuListScrollChild:SetHeight(menuListScrollChild:GetHeight() + 5);
            end
        end
    end

    tk:GroupCheckButtons(tk.unpack(data.menuButtons));
end