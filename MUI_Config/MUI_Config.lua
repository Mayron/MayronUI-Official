-- luacheck: ignore self 143 631
local _, namespace = ...;
local _G, MayronUI = _G, _G.MayronUI;
local tk, _, _, gui, obj, L = MayronUI:GetCoreComponents();

local MENU_BUTTON_HEIGHT = 40;
local PlaySound = _G.PlaySound;

-- Registers and Imports -------------

local C_LinkedList = obj:Import("Framework.System.Collections.LinkedList");
local Engine = obj:Import("MayronUI.Engine");

---@class ConfigModule : BaseModule
local C_ConfigModule = MayronUI:RegisterModule("ConfigModule");

namespace.C_ConfigModule = C_ConfigModule;
namespace.Engine = Engine;

-- Local functions -------------------
local CreateTopMenuButton;

do
    local menuButtons = {};

    function CreateTopMenuButton(label, onClick, anchor)
        local btn = gui:CreateButton(tk.Constants.AddOnStyle, nil, label);
        btn:SetWidth(100);

        if (anchor) then
            btn:SetPoint("RIGHT", anchor, "RIGHT");
            btn:SetParent(anchor);
        else
            btn:SetPoint("RIGHT", menuButtons[#menuButtons], "LEFT", -10, 0);
            btn:SetParent(menuButtons[#menuButtons]);
        end

        btn:SetScript("OnClick", function()
            onClick();
            PlaySound(tk.Constants.CLICK);
        end);

        table.insert(menuButtons, btn);

        return btn;
    end
end

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
    widget.__SetValue       = widgetTable.SetValue;
    widget.requiresReload   = widgetTable.requiresReload;
    widget.requiresRestart  = widgetTable.requiresRestart;
    widget.module           = widgetTable.module;
    widget.hasOwnDatabase   = widgetTable.hasOwnDatabase;
    widget.valueType        = widgetTable.valueType;
    widget.min              = widgetTable.min;
    widget.max              = widgetTable.max;
    widget.step             = widgetTable.step;
    widget.OnClick          = widgetTable.OnClick;
    widget.data             = widgetTable.data;
    widget.useIndexes       = widgetTable.useIndexes;

    if (widgetTable.type == "frame") then
        widget.children = widgetTable.children;
    end

    -- remove references to avoid clean up (else tables would be emptied)
    tk.Tables:Empty(widgetTable);
end

namespace.MenuButton_OnClick = MenuButton_OnClick;

-- C_ConfigModule -------------------

function C_ConfigModule:OnInitialize()
    if (not MayronUI:IsInstalled()) then
        tk:Print("Please install the UI and try again.");
        return;
    end

    _G.DisableAddOn("MUI_Config"); -- disable for next time
end

function C_ConfigModule:Show(data)
    if (not data.window) then
        local menuListScrollChild = self:SetUpWindow();
        self:SetUpSideMenu(menuListScrollChild);
    end

    data.window:Show();
end
function C_ConfigModule:GetDatabase(data, tbl)
    local dbObject;
    local dbName = "CoreModule";

    tbl = tbl or data.tempMenuConfigTable;

    if (tbl) then
        if (tbl.hasOwnDatabase) then
            dbName = tbl.module;
        end

        dbObject = MayronUI:GetModuleComponent(dbName, "Database");
    end

    obj:Assert(dbObject, "Failed to get database object for module '%s'", dbName);

    return dbObject;
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

    local db = self:GetDatabase();
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
    local db = self:GetDatabase(widget);

    -- __SetValue is a custom function to manually set the datbase config value
    if (widget.__SetValue) then
        local oldValue;

        if (not tk.Strings:IsNilOrWhiteSpace(widget.dbPath)) then
            oldValue = db:ParsePathValue(widget.dbPath);
        end

        widget.__SetValue(widget.dbPath, newValue, oldValue, widget);
    else
        -- dbPath is required if not using a custom __SetValue function!
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
    local function CleanTablesPredicate(_, tbl, key)
        return (tbl.type ~= "submenu" and key ~= "options");
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
            obj:PushTable(menuButton.configTable, CleanTablesPredicate);

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
        if (widgetConfigTable.type == "loop" or widgetConfigTable.type == "condition") then

            -- run the loop to gather widget children
            local results = namespace.WidgetHandlers[widgetConfigTable.type](
                data.selectedButton.menu:GetFrame(), widgetConfigTable);

            if (obj:IsTable(results)) then
                for _, result in ipairs(results) do
                    if (obj:IsTable(result)) then
                        if (not result.type and #result > 1) then
                            for _, subWidgetConfigTable in ipairs(result) do
                                data.selectedButton.menu:AddChildren(self:SetUpWidget(subWidgetConfigTable));
                            end
                        else
                            data.selectedButton.menu:AddChildren(self:SetUpWidget(result));
                        end
                    end
                end
            end

            -- the table was previously popped
            obj:PushTable(results);

        elseif (widgetConfigTable.type == "frame") then
            local frame = self:SetUpWidget(widgetConfigTable);

            if (frame.children) then
                -- add children of frame directly onto frame to group them together
                -- allows for more control over the positioning of elements
                local previousFrame = frame;

                for _, subWidgetConfigTable in ipairs(frame.children) do
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
        for _, group in pairs(data.tempMenuConfigTable.groups) do
            tk:GroupCheckButtons(group);
        end

        obj:PushTable(data.tempMenuConfigTable.groups);
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
---@param parent Frame @(optional) A custom parent frame for the widget, else the parent will be the menu scroll child.
---@return Frame @(possibly nil if widget is disabled) The created widget.
function C_ConfigModule:SetUpWidget(data, widgetConfigTable, parent)
    if (not parent) then
        parent = data.selectedButton.menu:GetFrame();
        parent = parent.ScrollFrame:GetScrollChild();
    end

    tk:Assert(obj:IsTable(data.tempMenuConfigTable), "Invalid temp data for '%s'", widgetConfigTable.name);

    if (not tk.Strings:IsNilOrWhiteSpace(data.tempMenuConfigTable.dbPath) and
        not tk.Strings:IsNilOrWhiteSpace(widgetConfigTable.appendDbPath)) then

        -- append the widget config table's dbPath value onto it!
        widgetConfigTable.dbPath = tk.Strings:Join(".",
            data.tempMenuConfigTable.dbPath, widgetConfigTable.appendDbPath);

        widgetConfigTable.appendDbPath = nil;
    end

    if (not obj:IsTable(data.tempMenuConfigTable.inherit)) then
        data.tempMenuConfigTable.inherit = obj:PopTable();
        data.tempMenuConfigTable.inherit.module = data.tempMenuConfigTable.module;
        data.tempMenuConfigTable.inherit.hasOwnDatabase = data.tempMenuConfigTable.hasOwnDatabase;
    end

    if (not data.tempMenuConfigTable.inherit.__index) then
        local metaTable = obj:PopTable();
        metaTable.__index = data.tempMenuConfigTable.inherit;
        data.tempMenuConfigTable.inherit = metaTable;
    end

    -- Inherit all key and value pairs from a menu table
    setmetatable(widgetConfigTable, data.tempMenuConfigTable.inherit);

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

    -- create the widget (run the widget function)!
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

    local menuListContainer = gui:CreateScrollFrame(tk.Constants.AddOnStyle, data.window:GetFrame(), "MUI_ConfigSideBar");
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
      data.window.profilesBtn = CreateTopMenuButton("Profiles", function()
        if (data.selectedButton:IsObjectType("CheckButton")) then
            data.selectedButton:SetChecked(false);
        end

        self:ShowProfileManager();
    end, topbar:GetFrame());

    -- Layouts Button:
    data.window.layoutsBtn = CreateTopMenuButton("Layouts", function()
        MayronUI:TriggerCommand("layouts");
        data.window:Hide();
    end);

    -- installer buttons
    data.window.installerBtn = CreateTopMenuButton("Installer", function()
        MayronUI:TriggerCommand("install");
        data.window:Hide();
    end);

    -- reload button
    data.window.reloadBtn = CreateTopMenuButton(L["Reload UI"], _G.ReloadUI);

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

        local filePath = tk:GetAssetFilePath("Textures\\Widgets\\Solid");
        local normal = tk:SetBackground(menuButton, filePath);
        local highlight = tk:SetBackground(menuButton, filePath);
        local checked = tk:SetBackground(menuButton, filePath);

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

        tk:GroupCheckButtons(data.menuButtons);
    end
end