-- luacheck: ignore self 143 631
local _, namespace = ...;
local _G, MayronUI = _G, _G.MayronUI;
local tk, db, _, gui, obj, L = MayronUI:GetCoreComponents();

local MENU_BUTTON_HEIGHT = 40;

-- Registers and Imports -------------

local C_LinkedList = obj:Import("Framework.System.Collections.LinkedList");
local Engine = obj:Import("MayronUI.Engine");

---@class ConfigModule : BaseModule
local C_ConfigModule = MayronUI:RegisterModule("ConfigModule");

namespace.C_ConfigModule = C_ConfigModule;

-- Local functions -------------------

local function MenuButton_OnClick(menuButton)
    if (menuButton:IsObjectType("CheckButton") and not menuButton:GetChecked()) then
        -- should not be allowed to uncheck a menu button by clicking it a second time!
        menuButton:SetChecked(true);
        return;
    end

    local configModule = MayronUI:ImportModule("ConfigModule");
    configModule:OpenMenu(menuButton);
end

local function SetBackButtonEnabled(backBtn, enabled)
    backBtn:SetEnabled(enabled);

    if (enabled) then
        tk:ApplyThemeColor(backBtn.arrow);
    else
        local r, g, b = tk.Constants.COLORS.GRAY:GetRGB();
        backBtn.arrow:SetVertexColor(r, g, b, 1);
    end
end

-- Preserve values before recycling childData table!
local function TransferWidgetAttributes(widget, widgetTable)
    widget.dbPath           = widgetTable.dbPath;
    widget.name             = widgetTable.name;
    widget.SetValue         = widgetTable.SetValue;
    widget.requiresReload   = widgetTable.requiresReload;
    widget.requiresRestart  = widgetTable.requiresRestart;
    widget.module           = widgetTable.module;
    widget.valueType        = widgetTable.valueType;
    widget.min              = widgetTable.min;
    widget.max              = widgetTable.max;
    widget.OnClick          = widgetTable.OnClick;
    widget.data             = widgetTable.data;

    obj:PushTable(widgetTable);
end

namespace.MenuButton_OnClick = MenuButton_OnClick;

-- C_ConfigModule -------------------

function C_ConfigModule:OnInitialize()
    if (not MayronUI:IsInstalled()) then
        tk:Print("Please install the UI and try again.");
        return;
    end
end

function C_ConfigModule:Show(data)
    if (not data.window) then
        local menuListScrollChild = self:SetUpWindow();
        self:SetUpSideMenu(menuListScrollChild);
    end

    data.window:Show();
end

Engine:DefineParams("table");
---@param widgetConfigTable table @A widget config table used to construct part of the config menu.
---@return any @A value from the database located by the dbPath value inside widgetConfigTable.
function C_ConfigModule:GetDatabaseValue(_, widgetConfigTable)
    if (tk.Strings:IsNilOrWhiteSpace(widgetConfigTable.dbPath)) then
        return widgetConfigTable.GetValue and widgetConfigTable.GetValue(widgetConfigTable);
    end

    if (obj:IsFunction(widgetConfigTable.dbPath)) then
        widgetConfigTable.dbPath = widgetConfigTable.dbPath();
    end

    local value = db:ParsePathValue(widgetConfigTable.dbPath);

    if (obj:IsTable(value) and value.GetUntrackedTable) then
        value = value:GetUntrackedTable();
    end

    if (widgetConfigTable.GetValue) then
        value = widgetConfigTable.GetValue(widgetConfigTable, value);
    end

    if (value == nil) then
        if (widgetConfigTable.GetValue) then
            obj:Error("nil config value retrieved from database path '%s' (using GetValue on '%s')",
                widgetConfigTable.dbPath, widgetConfigTable.name);
        else
            obj:Error("nil config value retrieved from database path '%s'", widgetConfigTable.dbPath);
        end
    end

    return value;
end

Engine:DefineParams("table");
---Updates the database based on the dbPath config value, or using SetValue,
---@param widget table @The created widger frame.
---@param value any @The value to add to the database using the dbPath value attached to the widget table.
function C_ConfigModule:SetDatabaseValue(_, widget, newValue)

    -- SetValue is a custom function to manually set the datbase config value
    if (widget.SetValue) then
        local oldValue;

        if (not tk.Strings:IsNilOrWhiteSpace(widget.dbPath)) then
            oldValue = db:ParsePathValue(widget.dbPath);
        end

        widget.SetValue(widget.dbPath, newValue, oldValue, widget);
    else
        -- dbPath is required if not using a custom SetValue function!
        if (widget.name and widget.name.IsObjectType and widget.name:IsObjectType("FontString")) then
            tk:Assert(not tk.Strings:IsNilOrWhiteSpace(widget.dbPath),
                "%s is missing database path address element (dbPath) in config data.", widget.name:GetText());
        else
            tk:Assert(not tk.Strings:IsNilOrWhiteSpace(widget.dbPath),
                "Unknown config data is missing database path address element (dbPath).");
        end

        db:SetPathValue(widget.dbPath, newValue);
    end

    if (widget.requiresReload) then
        self:ShowReloadMessage();
    elseif (widget.requiresRestart) then
        self:ShowRestartMessage();
    end
end

Engine:DefineParams("CheckButton|Button");
---@param menuButton CheckButton|Button @The menu button clicked on associated with a menu.
function C_ConfigModule:OpenMenu(data, menuButton)

    if (menuButton.type == "menu") then
        data.history:Clear();
        SetBackButtonEnabled(data.window.back, false);

    elseif (menuButton.type == "submenu") then
        data.history:AddToBack(data.selectedButton);
        SetBackButtonEnabled(data.window.back, true);
    else
        tk:Error("Menu or Sub-Menu expected, got '%s'.", menuButton.type);
    end

    self:SetSelectedButton(menuButton);
end

do
    local function CleanTablesIfNotSubmenu(tbl)
        return (tbl.type ~= "submenu");
    end

    Engine:DefineParams("CheckButton|Button");
    ---@param menuButton CheckButton|Button @The menu button clicked on associated with a menu.
    function C_ConfigModule:SetSelectedButton(data, menuButton)
        if (data.selectedButton) then
            -- hide old menu
            data.selectedButton.menu:Hide();
        end

        menuButton.menu = menuButton.menu or self:CreateMenu();
        data.selectedButton = menuButton;

        if (menuButton:IsObjectType("CheckButton")) then
            menuButton:SetChecked(true);
        end

        if (menuButton.configTable) then
            self:RenderSelectedMenu(menuButton.configTable);

            obj:PushTable(menuButton.configTable, CleanTablesIfNotSubmenu);
            menuButton.configTable = nil;

            if (menuButton.module) then
                menuButton.module.configTable = nil;
            end
        end

        collectgarbage("collect");

        -- fade menu in...
        data.selectedButton.menu:Show();
        data.windowName:SetText(menuButton.name);

        _G.UIFrameFadeIn(data.selectedButton.menu, 0.3, 0, 1);
        _G.PlaySound(tk.Constants.CLICK);
    end
end

Engine:DefineParams("table");
---@param menuConfigTable table @A table containing many widget config tables used to render a full menu.
function C_ConfigModule:RenderSelectedMenu(data, menuConfigTable)
    if (not (menuConfigTable and obj:IsTable(menuConfigTable.children))) then
        return;
    end

    data.tempMenuConfigTable = menuConfigTable;

    for _, widgetConfigTable in pairs(menuConfigTable.children) do

        if (widgetConfigTable.type == "loop") then
            -- run the loop to gather widget children
            local loopResults = namespace.WidgetHandlers.loop(data.selectedButton.menu:GetFrame(), widgetConfigTable);

            for _, result in ipairs(loopResults) do

                if (not result.type and #result > 1) then
                    for _, subWidgetConfigTable in ipairs(result) do
                        data.selectedButton.menu:AddChildren(self:SetUpWidget(subWidgetConfigTable));
                    end
                else
                    data.selectedButton.menu:AddChildren(self:SetUpWidget(result));
                end
            end

            -- the table was previously popped
            obj:PushTable(loopResults);

        elseif (widgetConfigTable.type == "frame") then
            local frame = self:SetUpWidget(widgetConfigTable);

            if (widgetConfigTable.children) then
                -- add children of frame directly onto frame to group them together
                -- allows for more control over the positioning of elements
                local previousFrame = frame;

                for _, subWidgetConfigTable in ipairs(widgetConfigTable.children) do
                    local frameWidget = self:SetUpWidget(subWidgetConfigTable, frame);

                    if (previousFrame == frame) then
                        frameWidget:SetPoint("TOPLEFT", previousFrame, "TOPLEFT", 10, -10);
                    else
                        frameWidget:SetPoint("BOTTOMLEFT", previousFrame, "BOTTOMRIGHT", 10, 0);
                    end

                    previousFrame = frameWidget;
                end
            end

            data.selectedButton.menu:AddChildren(frame);
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
---@return DynamicFrame @The dynamic frame which holds the menu frame and controls responsiveness and the scroll bar.
function C_ConfigModule:CreateMenu(data)
    -- else, create a new menu (dynamic frame) to based on the module's config data
    local menuParent = data.options:GetFrame();
    local menu = gui:CreateDynamicFrame(tk.Constants.AddOnStyle, menuParent, 10, 10);
    local menuScrollFrame = menu:GetFrame();

    -- add graphical dialog box to dynamic frame:
    gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, "Low", menuScrollFrame);
    menuScrollFrame:SetAllPoints(true);

    return menu;
end

function C_ConfigModule:ShowReloadMessage(data)
    data.warningIcon:Show();
    data.warningLabel:SetText(data.warningLabel.reloadText);
end

function C_ConfigModule:ShowRestartMessage(data)
    data.warningIcon:Show();
    data.warningLabel:SetText(data.warningLabel.restartText);
end

Engine:DefineParams("table", "?Frame");
---@param widgetConfigTable table @A widget config table used to control the rendering and behavior of a widget in the config menu.
---@param parent Frame @(optional) A custom parent frame for the widget, else the parent will be the menu.
---@return Frame @(possibly nil if widget is disabled) The created widget.
function C_ConfigModule:SetUpWidget(data, widgetConfigTable, parent)
    parent = parent or data.selectedButton.menu:GetFrame();

    tk:Assert(obj:IsTable(data.tempMenuConfigTable), "Invalid temp data for '%s'", widgetConfigTable.name);

    if (not tk.Strings:IsNilOrWhiteSpace(data.tempMenuConfigTable.dbPath) and
        not tk.Strings:IsNilOrWhiteSpace(widgetConfigTable.appendDbPath)) then

        -- append the widget config table's dbPath value onto it!
        widgetConfigTable.dbPath = tk.Strings:Join(".",
            data.tempMenuConfigTable.dbPath, widgetConfigTable.appendDbPath);

        widgetConfigTable.appendDbPath = nil;
    end

    if (obj:IsTable(data.tempMenuConfigTable.inherit)) then
        -- Inherit all key and value pairs from a parent table by injecting them into childData
        local metaTable = obj:PopTable();
        metaTable.__index = data.tempMenuConfigTable.inherit;
        setmetatable(widgetConfigTable, metaTable);
    end

    local widgetType = widgetConfigTable.type;

    -- treat the widget like a check button (except when grouping the check buttons)
    if (widgetType == "radio") then
        widgetType = "check";
    end

    tk:Assert(namespace.WidgetHandlers[widgetType],
        "Unsupported widget type '%s' found in config data for config table '%s'.",
        widgetType or "nil", widgetConfigTable.name or "nil");

    if (widgetConfigTable.OnInitialize) then
        -- do disabled widgets need to be initialized?
        widgetConfigTable.OnInitialize(widgetConfigTable);
        widgetConfigTable.OnInitialize = nil;
    end

    local currentValue = self:GetDatabaseValue(widgetConfigTable);

    -- create the widget!
    local widget = namespace.WidgetHandlers[widgetType](parent, widgetConfigTable, currentValue);

    if (widgetConfigTable.devMode) then
        -- highlight the widget in dev mode.
        tk:SetBackground(widget, math.random(), math.random(), math.random());
    end

    if (widgetConfigTable.type == "radio" and widgetConfigTable.groupName) then
        -- get groups[groupName] value from tempRadioButtonGroup
        local tempRadioButtonGroup = tk.Tables:GetTable(
            data.tempMenuConfigTable, "groups", widgetConfigTable.groupName);

        table.insert(tempRadioButtonGroup, widget.btn);
    end

    if (widgetConfigTable.disabled) then
        return;
    end

    -- setup complete, so run the OnLoad callback if one exists
    if (widgetConfigTable.OnLoad) then
        widgetConfigTable.OnLoad(widgetConfigTable, widget, currentValue);
        widgetConfigTable.OnLoad = nil;
    end

    if (widgetType ~= "submenu") then
        TransferWidgetAttributes(widget, widgetConfigTable);
    end

    return widget;
end

function C_ConfigModule:SetUpWindow(data)
    if (data.window) then
        return
    end

    data.history = C_LinkedList();

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

    local menuListContainer = gui:CreateScrollFrame(tk.Constants.AddOnStyle, data.window:GetFrame(), "SIDEBAR");
    menuListContainer.ScrollBar:SetPoint("TOPLEFT", menuListContainer.ScrollFrame, "TOPRIGHT", -5, 0);
    menuListContainer.ScrollBar:SetPoint("BOTTOMRIGHT", menuListContainer.ScrollFrame, "BOTTOMRIGHT", 0, 0);

    local menuListCell = data.window:CreateCell(menuListContainer);
    menuListCell:SetInsets(2, 10, 10, 10);

    data.options = data.window:CreateCell();
    data.options:SetInsets(2, 14, 2, 2);

    local versionCell = data.window:CreateCell();
    versionCell:SetInsets(10, 10, 10, 10);

    versionCell.text = versionCell:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    versionCell.text:SetText(tk.Strings:Concat(
        _G.GetAddOnMetadata("MUI_Core", "X-InterfaceName"), " [", _G.GetAddOnMetadata("MUI_Core", "Version"), "]")
    );
    versionCell.text:SetPoint("BOTTOMLEFT");

    local bottombar = data.window:CreateCell();
    bottombar:SetDimensions(2, 1);
    bottombar:SetInsets(10, 30, 10, 0);

    data.window:AddCells(topbar, menuListCell, data.options, versionCell, bottombar);

    data.warningIcon = bottombar:CreateTexture(nil, "ARTWORK");
    data.warningIcon:SetSize(20, 20);
    data.warningIcon:SetPoint("LEFT");
    data.warningIcon:SetTexture(_G.STATICPOPUP_TEXTURE_ALERT);
    data.warningIcon:Hide();

    data.warningLabel = bottombar:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    data.warningLabel:SetPoint("LEFT", data.warningIcon, "RIGHT", 10, 0);
    data.warningLabel:SetText(tk.Strings.Empty);

    data.warningLabel.reloadText = L["The UI requires reloading to apply changes."];
    data.warningLabel.restartText = L["Some changes require a client restart to take effect."];

    -- forward and back buttons
    data.window.back = gui:CreateButton(tk.Constants.AddOnStyle, topbar:GetFrame());
    data.window.back:SetPoint("LEFT");
    data.window.back:SetWidth(50);
    data.window.back.arrow = data.window.back:CreateTexture(nil, "OVERLAY");
    data.window.back.arrow:SetTexture(tk:GetAssetFilePath("Textures\\Widgets\\SideArrow"));
    data.window.back.arrow:SetSize(16, 14);
    data.window.back.arrow:SetPoint("CENTER", -1, 0);

    data.window.back:SetScript("OnClick", function(backButton)
        local menuButton = data.history:GetBack();
        data.history:RemoveBack();

        self:SetSelectedButton(menuButton);

        if (data.history:GetSize() == 0) then
            data.windowName:SetText(menuButton.name);
            SetBackButtonEnabled(backButton, false);
        else
            local previousMenuButton = data.history:GetBack();
            data.windowName:SetText(previousMenuButton.name);
        end
    end);

    data.windowName = topbar:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    data.windowName:SetPoint("LEFT", data.window.back, "RIGHT", 10, 0);
    SetBackButtonEnabled(data.window.back, false);

    -- profiles button
    data.window.profilesBtn = gui:CreateButton(
        tk.Constants.AddOnStyle, topbar:GetFrame(), "Profiles");

    data.window.profilesBtn:SetPoint("RIGHT", topbar:GetFrame(), "RIGHT");
    data.window.profilesBtn:SetWidth(120);

    data.window.profilesBtn:SetScript("OnClick", function()
        if (data.selectedButton:IsObjectType("CheckButton")) then
            data.selectedButton:SetChecked(false);
        end

        self:ShowProfileManager();
    end);

    -- installer buttons
    data.window.installerBtn = gui:CreateButton(
        tk.Constants.AddOnStyle, topbar:GetFrame(), "Installer");

    data.window.installerBtn:SetPoint("RIGHT", data.window.profilesBtn, "LEFT", -10, 0);
    data.window.installerBtn:SetWidth(120);

    data.window.installerBtn:SetScript("OnClick", function()
        MayronUI:TriggerCommand("install");
        data.window:Hide();
        tk.PlaySound(tk.Constants.CLICK);
    end);

    -- reload button
    data.window.reloadBtn = gui:CreateButton(
        tk.Constants.AddOnStyle, topbar:GetFrame(), L["Reload UI"]);

    data.window.reloadBtn:SetPoint("RIGHT", data.window.installerBtn, "LEFT", -10, 0);
    data.window.reloadBtn:SetWidth(120);

    data.window.reloadBtn:SetScript("OnClick", function()
        _G.ReloadUI();
        tk.PlaySound(tk.Constants.CLICK);
    end);

    local menuListScrollChild = menuListContainer.ScrollFrame:GetScrollChild();
    tk:SetFullWidth(menuListScrollChild);

    return menuListScrollChild;
end

do
    local function AddMenuButton(menuButtons, menuConfigTable, menuListScrollChild)
        local module;

        if (menuConfigTable.module) then
            module = MayronUI:ImportModule(menuConfigTable.module);
        end

        local menuButton = _G.CreateFrame("CheckButton", nil, menuListScrollChild);
        menuButton.configTable = menuConfigTable;
        menuButton.id = menuConfigTable.id;
        menuButton.name = menuConfigTable.name;
        menuButton.type = "menu";
        menuButton.module = module;

        menuButton.text = menuButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        menuButton.text:SetText(menuConfigTable.name); -- the model name as a readable button label
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

        menuButtons[menuConfigTable.name] = menuButton;
        table.insert(menuButtons, menuButton);
    end

    ---Loads all config data from individual modules and places them as a graphical menu
    ---@param menuListScrollChild Frame @The frame that holds all menu buttons in the left scroll frame.
    function C_ConfigModule:SetUpSideMenu(data, menuListScrollChild)
        data.menuButtons = {};

        -- contains all menu buttons in the left scroll frame of the main config window
        local scrollChildHeight = menuListScrollChild:GetHeight() + MENU_BUTTON_HEIGHT;
        menuListScrollChild:SetHeight(scrollChildHeight);

        for _, module in MayronUI:IterateModules() do

            if (module.GetConfigTable) then
                local configTable = module:GetConfigTable();

                if (#configTable == 0) then
                    AddMenuButton(data.menuButtons, configTable, menuListScrollChild);
                else
                    for _, menuConfigTable in ipairs(configTable) do
                        AddMenuButton(data.menuButtons, menuConfigTable, menuListScrollChild);
                    end
                end
            end
        end

        -- order and position buttons:
        tk.Tables:OrderBy(data.menuButtons, "id", "name");

        for id, menuButton in ipairs(data.menuButtons) do
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

        tk:GroupCheckButtons(tk.unpack(data.menuButtons));
    end
end