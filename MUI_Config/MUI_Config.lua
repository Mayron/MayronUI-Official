-- Setup Namespaces ------------------

local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

-- Register and Import Modules -------

local LinkedListClass = obj:Import("Framework.System.Collections.LinkedList");

local ConfigModuleClass = MayronUI:RegisterModule("Config");
local ConfigPackage = obj:CreatePackage("Config", "MayronUI.Engine");

local ContainerClass = ConfigPackage:CreateClass("Container"); -- used to be called the Menu (It's the main config menu)
local MenuClass = ConfigPackage:CreateClass("Menu");  -- used to be called SubMenu
local ElementClass = ConfigPackage:CreateClass("Element");  -- used to be child_data

-- Local functions -------------------

local function ToolTip_OnEnter(frame)
    GameTooltip:SetOwner(frame, "ANCHOR_RIGHT", 0, 2);
    GameTooltip:AddLine(frame.tooltip);
    GameTooltip:Show();
end

local function ToolTip_OnLeave(frame)
    GameTooltip:Hide();
end

-- DataText Module -------------------

function ConfigModuleClass:OnInitialize(data)

end
    
function ConfigModuleClass:OnEnable(data)
    if (not MayronUI:IsInstalled()) then 
        tk:Print("Please install the UI and try again.");
        return; 
    end

    self:ScanForData();

    if (not private.menu) then
        private:SetupMenu();
    else
        private.menu:Show();
    end
end

function ConfigModuleClass:OnProfileChange(data)
    
end

-- DataTextClass -------------------

-- get the database path address value
function ConfigClass:GetDatabasePathInfo(data, childData)
    if (not childData.dbPath) then return end

    local rootTable;

    if (childData.isGlobal) then
        rootTable = db.global;
    else
        rootTable = db.profile;
    end

    if (type(childData.dbPath) == "function") then
        return rootTable, childData.dbPath();
    else
        return rootTable, childData.dbPath;
    end
end

-- updates the config of all modules
function ConfigClass:UpdateConfig(data, widget, childData, value)
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

function ConfigClass:SetMenu(data, menuData)
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

function ConfigClass:SwitchMenu(data, newMenu)
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
function ConfigClass:UpdateCategories() end

function ConfigClass:ShowReloadMessage(data)
    data.warningLabel:SetText(data.warningLabel.reloadText);
end

function ConfigClass:ShowRestartMessage()
    data.warningLabel:SetText(data.warningLabel.restartText);
end

-- create container to wrap around a child element
function ConfigClass:CreateElementContainerFrame(data, widget, childData)
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

function ConfigClass:GetValue(data, childData)
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
function ConfigClass:SetUpWidget(data, childData, menuFrame, menuData)
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

function ConfigClass:SetupMenu(data)
    if (data.container) then 
        return; 
    end

    data.history = LinkedListClass();

    data.container = gui:CreateDialogBox(nil, nil, nil, "MUI_Config");
    data.container:SetFrameStrata("DIALOG");
    data.container:Hide();
    data.container:SetMinResize(600, 400);
    data.container:SetMaxResize(1200, 800);
    data.container:SetSize(800, 500);
    data.container:SetPoint("CENTER");

    gui:AddTitleBar(data.container, "MUI Config");
    gui:AddResizer(data.container);
    gui:AddCloseButton(data.container);

    -- convert container to a panel
    data.container = gui:CreatePanel(data.container);
    data.container:SetDevMode(false); -- shows or hides the red frame info overlays
    data.container:SetDimensions(2, 3);
    data.container:GetColumn(1):SetFixed(200);
    data.container:GetRow(1):SetFixed(80);
    data.container:GetRow(3):SetFixed(50);
    data.container:SetScript("OnShow", function(self)
        -- fade in when shown
        UIFrameFadeIn(self, 0.3, 0, 1);
    end)

    local topbar = data.container:CreateCell();
    topbar:SetInsets(25, 14, 2, 10);
    topbar:SetDimensions(2, 1);

    local categories, scrollchild = gui:CreateScrollFrame(data.container:GetFrame());
    categories.ScrollBar:SetPoint("TOPLEFT", categories.ScrollFrame, "TOPRIGHT", -5, 0);
    categories.ScrollBar:SetPoint("BOTTOMRIGHT", categories.ScrollFrame, "BOTTOMRIGHT", 0, 0);
    categories = data.container:CreateCell(categories);
    categories:SetInsets(2, 10, 10, 10);
    categories:SetDimensions(1, 2);

    local options = data.container:CreateCell();
    options:SetInsets(2, 14, 2, 2);
    config.options = options;

    local bottombar = data.container:CreateCell();
    bottombar:SetInsets(2, 30, 10, 2);
    data.container:AddCells(topbar, categories, options, bottombar);

    data.warningLabel = bottombar:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    data.warningLabel:SetPoint("LEFT");
    data.warningLabel:SetText("");
    data.warningLabel.reloadText = L["The UI requires reloading to apply changes."];
    data.warningLabel.restartText = L["Some changes require a client restart to take effect."];

    -- forward and back buttons
    data.container.back = gui:CreateButton(topbar:GetFrame());
    data.container.back:SetPoint("LEFT");
    data.container.back:SetWidth(50);
    data.container.back.arrow = data.container.back:CreateTexture(nil, "OVERLAY");
    data.container.back.arrow:SetTexture(tk.Constants.MEDIA.."other\\arrow_side");
    data.container.back.arrow:SetSize(16, 14);
    data.container.back.arrow:SetPoint("CENTER", -1, 0);

    data.container.back:SetScript("OnClick", function(self)
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

    data.containerName = topbar:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    data.containerName:SetPoint("LEFT", data.container.back, "RIGHT", 10, 0);

    tk:SetThemeColor(data.container.back.arrow);
    data.container.back:SetEnabled(false);

    data.container.profiles = gui:CreateButton(topbar:GetFrame(), L["Reload UI"]); -- will change to profiles another time
    data.container.profiles:SetPoint("RIGHT", topbar:GetFrame(), "RIGHT");
    data.container.profiles:SetScript("OnClick", function()
        ReloadUI();
        tk.PlaySound(tk.Constants.CLICK);
    end);

    data.container.installer = gui:CreateButton(topbar:GetFrame(), L["MUI Installer"]);
    data.container.installer:SetPoint("RIGHT", data.container.profiles, "LEFT", -10, 0);

    data.container.installer:SetScript("OnClick", function()
        MayronUI:TriggerCommand("install");
        data.container:Hide();
        tk.PlaySound(tk.Constants.CLICK);
    end);

    data.container.menus = {};
    tk:SetFullWidth(scrollchild)

    -- a category is a menu, but a menu is not a category
    self:SetUpCategories();
   
    tk:GroupCheckButtons(tk.unpack(data.container.menus));
    data.container:Show();
end

function ConfigClass:SetUpCategories()
    -- TODO!
    -- for id, categoryData in ipairs(config.db) do
    --     data.container.menus[id] = tk.CreateFrame("CheckButton", nil, scrollchild);
    --     scrollchild:SetHeight((scrollchild:GetHeight() or 0) + 60);

    --     local f = data.container.menus[id];
    --     f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    --     f.text:SetText(categoryData.name);
    --     f.text:SetJustifyH("LEFT");
    --     f.text:SetPoint("TOPLEFT", 10, 0);
    --     f.text:SetPoint("BOTTOMRIGHT");

    --     local normal = tk:SetBackground(f, 1, 1, 1, 0);
    --     local highlight = tk:SetBackground(f, 1, 1, 1, 0);
    --     local checked = tk:SetBackground(f, 1, 1, 1, 0);
    --     tk:SetThemeColor(0.3, normal, highlight);
    --     tk:SetThemeColor(0.6, checked);

    --     f:SetSize(250, 60);
    --     f:SetNormalTexture(normal);
    --     f:SetHighlightTexture(highlight);
    --     f:SetCheckedTexture(checked);

    --     if (id == 1) then
    --         f:SetPoint("TOPLEFT", scrollchild, "TOPLEFT");
    --         f:SetPoint("TOPRIGHT", scrollchild, "TOPRIGHT", -10, 0);
    --     else
    --         f:SetPoint("TOPLEFT", data.container.menus[id - 1], "BOTTOMLEFT", 0, -5);
    --         f:SetPoint("TOPRIGHT", data.container.menus[id - 1], "BOTTOMRIGHT", 0, -5);
    --         scrollchild:SetHeight(scrollchild:GetHeight() + 5);
    --     end
    --     f:SetScript("OnClick", function(self)
    --         if (not self:GetChecked()) then
    --             self:SetChecked(true);
    --             return;
    --         end
    --         private.history:Clear();
    --         private.menuName:SetText("");
    --         private.menu.back:SetEnabled(false);
    --         config:SetSubMenu(categoryData);
    --         tk.PlaySound(tk.Constants.CLICK);
    --     end);

    --     if (id == 1) then
    --         config:SetSubMenu(categoryData);
    --         f:SetChecked(true);
    --     end
    -- end
end