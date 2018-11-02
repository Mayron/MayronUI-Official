-- Setup Namespaces ------------------

local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

-- Register and Import Modules -------

local configModule, ConfigClass = MayronUI:RegisterModule("Config");
local ConfigPackage = obj:CreatePackage("Config", "MayronUI.Engine");

local Container = ConfigPackage:CreateClass("Container"); -- used to be called the Menu (It's the main config menu)
local Menu = ConfigPackage:CreateClass("Menu");  -- used to be called SubMenu
local Element = ConfigPackage:CreateClass("Element");  -- used to be child_data

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

configModule:OnInitialize(function(self, data)
end);
    
configModule:OnEnable(function(self, data)
    --show?
end);

-- configModule:OnConfigUpdate(function(self, data, list, value)
-- end);

-- DataTextClass -------------------

Engine:DefineParams("??");
function ConfigClass:Show(data)
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

-- updates the config of all modules
function ConfigClass:UpdateConfig(data, widget, child_data, value)
    if (child_data.SetValue) then
        local path = private:GetPath(child_data);

        if (not path) then
            child_data.SetValue(value, widget);
        else
            local old_value = db:ParsePathValue(path);
            child_data.SetValue(path, old_value, value, widget); -- custom way to set the value
        end
    else
        tk.assert(child_data.db_path, child_data.name.." is missing db_path value.");
        db:SetPathValue(child_data.db_path, value);
    end

    if (child_data.requires_reload) then
        config:ShowReloadMessage();
    elseif (child_data.requires_restart) then
        config:ShowRestartMessage();
    end

    -- find the module and call the "OnConfigUpdate" function
    if (child_data.module or config.submenu_data.module and child_data.db_path) then
        local module = MayronUI:ImportModule(child_data.module or config.submenu_data.module);

        if (module.OnConfigUpdate) then
            local list = tk:ConvertPathToKeys(child_data.db_path);
            module:OnConfigUpdate(list, value);
        end
    end
end

function ConfigClass:SetSubMenu(data, submenu_data)
    self.submenu_data = submenu_data;
    if (submenu_data.dynamicFrame) then
        private:SwitchContent(submenu_data.dynamicFrame);
        return;
    end
    -- load the content:
    submenu_data.dynamicFrame = gui:CreateDynamicFrame(self.options:GetFrame(), nil, 10);
    gui:CreateDialogBox(nil, "Low", submenu_data.dynamicFrame:GetFrame());
    submenu_data.dynamicFrame:SetAllPoints(true);

    private:SwitchContent(submenu_data.dynamicFrame);
    private:LoadContent(submenu_data, submenu_data.dynamicFrame);
end

-- TODO: show Categories that were not previously registered
function ConfigClass:UpdateCategories() end

function ConfigClass:ShowReloadMessage()
    private.reload_warning:SetText(private.reload_warning.reload_message);
end

function ConfigClass:ShowRestartMessage()
    private.reload_warning:SetText(private.reload_warning.restart_message);
end

function ConfigClass:CreateMenuContainer(data, widget, child_data)
    local container = tk:PopFrame("Frame", private.parent);

    container:SetSize(child_data.width or widget:GetWidth(), child_data.height or widget:GetHeight());
    widget:SetParent(container);
    container.widget = widget;

    if ((child_data.type == "slider" or child_data.type == "dropdown"
            or child_data.type == "textfield") and child_data.name) then

        container.name = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        container.name:SetPoint("TOPLEFT", 0, -5);
        container.name:SetText(child_data.name);
        container:SetHeight(container:GetHeight() + container.name:GetStringHeight() + 15);
        widget:SetPoint("TOPLEFT", container.name, "BOTTOMLEFT", 0, -5);

        if (child_data.type == "slider") then
            container.name:SetPoint("TOPLEFT", 10, -5);
            container:SetWidth(container:GetWidth() + 20);
        end
    else
        widget:SetPoint("LEFT");
    end
    return container;
end

-- get the database path
function ConfigClass:GetPath(data, child_data)
    if (not child_data.db_path) then return; end
    if (tk.type(child_data.db_path) == "function") then
        return child_data.db_path();
    else
        return child_data.db_path;
    end
end

function ConfigClass:GetValue(data, child_data)
    local path = private:GetPath(child_data);
    local value;
    if (not path) then
        value = child_data.GetValue and child_data.GetValue();
    elseif (child_data.type == "color") then
        value = {};
        value.r = db:ParsePathValue(path..".r");
        value.g = db:ParsePathValue(path..".g");
        value.b = db:ParsePathValue(path..".b");
        value.a = db:ParsePathValue(path..".a");
    else
        value = db:ParsePathValue(path);
        if (child_data.GetValue) then
            value = child_data.GetValue(path, value);
        else
            return value;
        end
    end
    return value;
end

function ConfigClass:LoadChild(data, child_data, parent_dynamicFrame, submenu_data)
    if (submenu_data.inherit) then
        for key, value in tk.pairs(submenu_data.inherit) do
            if (not child_data[key]) then
                child_data[key] = value;
            end
        end
    end

    -- create the item, return it, add it to children
    if (child_data.type ~= "loop") then
        local type = (child_data.type == "radio" and "check") or child_data.type;
        if (not private[type]) then
            tk:Print(tk.string.format(L["Config type '%s' unsupported!"], type));
            return;
        end
        if (child_data.OnInitialize) then
            child_data.OnInitialize(child_data);
            child_data.OnInitialize = nil;
        end
        if (child_data.enabled == nil or child_data.enabled) then
            local widget = private[type]:Run(child_data);
            if (widget) then
                parent_dynamicFrame:AddChildren(widget);
                if (child_data.dev_mode) then
                    tk:SetBackground(widget, tk.math.random(), tk.math.random(), tk.math.random());
                end
            end
            if (child_data.type == "title" or child_data.type == "divider" or child_data.type == "fontstring") then
                tk:SetFullWidth(widget, 10);
            end
            if (child_data.type == "radio" and child_data.group) then
                submenu_data.groups = submenu_data.groups or {};
                submenu_data.groups[child_data.group] = submenu_data.groups[child_data.group] or {};
                tk.table.insert(submenu_data.groups[child_data.group], widget.btn);
            end
            if (child_data.OnLoad) then
                child_data.OnLoad(child_data, widget);
                child_data.OnLoad = nil;
            end
        end
    else
        -- need to append children_data efficiently
        for _, data in tk.ipairs(private.loop:Run(child_data)) do
            for _, child_data in tk.ipairs(data) do
                private:LoadChild(child_data, parent_dynamicFrame, submenu_data);
            end
        end
    end
end

function ConfigClass:LoadContent(data, submenu_data, parent_dynamicFrame)
    self.parent = parent_dynamicFrame:GetFrame();
    if (submenu_data.children) then
        for _, child_data in tk.pairs(submenu_data.children) do
            private:LoadChild(child_data, parent_dynamicFrame, submenu_data);
        end
        if (submenu_data.groups) then
            for _, group in tk.ipairs(submenu_data.groups) do
                tk:GroupCheckButtons(tk.unpack(group));
            end
        end
        submenu_data.groups = nil;
    end
end

function ConfigClass:SwitchContent(data, dynamicFrame)
    if (private.dynamicFrame) then
        private.dynamicFrame:Hide();
    end
    private.dynamicFrame = dynamicFrame; -- always a DynamicFrame
    tk.UIFrameFadeIn(private.dynamicFrame:GetFrame(), 0.3, 0, 1);
end

function ConfigClass:SetupMenu()
    if (self.menu) then 
        return; 
    end

    self.history = tk:CreateLinkedList();
    self.menu = gui:CreateDialogBox(nil, nil, nil, "MUI_Config");
    self.menu:SetFrameStrata("DIALOG");

    self.menu:Hide();
    gui:AddTitleBar(self.menu, "MUI Config");
    gui:AddResizer(self.menu);
    gui:AddCloseButton(self.menu);
    self.menu:SetMinResize(600, 400);
    self.menu:SetMaxResize(1200, 800);
    self.menu:SetSize(800, 500);
    self.menu:SetPoint("CENTER");
    self.menu = gui:CreatePanel(self.menu);
    self.menu:SetDevMode(false); -- shows or hides the red frame info overlays
    self.menu:SetDimensions(2, 3);
    self.menu:GetColumn(1):SetFixed(200);
    self.menu:GetRow(1):SetFixed(80);
    self.menu:GetRow(3):SetFixed(50);
    self.menu:SetScript("OnShow", function(self)
        tk.UIFrameFadeIn(self, 0.3, 0, 1);
    end)

    local topbar = self.menu:CreateCell();
    topbar:SetInsets(25, 14, 2, 10);
    topbar:SetDimensions(2, 1);

    local categories, scrollchild = gui:CreateScrollFrame(self.menu:GetFrame());
    categories.ScrollBar:SetPoint("TOPLEFT", categories.ScrollFrame, "TOPRIGHT", -5, 0);
    categories.ScrollBar:SetPoint("BOTTOMRIGHT", categories.ScrollFrame, "BOTTOMRIGHT", 0, 0);
    categories = self.menu:CreateCell(categories);
    categories:SetInsets(2, 10, 10, 10);
    categories:SetDimensions(1, 2);

    local options = self.menu:CreateCell();
    options:SetInsets(2, 14, 2, 2);
    config.options = options;

    local bottombar = self.menu:CreateCell();
    bottombar:SetInsets(2, 30, 10, 2);
    self.menu:AddCells(topbar, categories, options, bottombar);
    self.reload_warning = bottombar:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    self.reload_warning:SetPoint("LEFT");
    self.reload_warning:SetText("");
    self.reload_warning.reload_message = L["The UI requires reloading to apply changes."];
    self.reload_warning.restart_message = L["Some changes require a client restart to take effect."];

    -- forward and back buttons
    self.menu.back = gui:CreateButton(topbar:GetFrame());
    self.menu.back:SetPoint("LEFT");
    self.menu.back:SetWidth(50);
    self.menu.back.arrow = self.menu.back:CreateTexture(nil, "OVERLAY");
    self.menu.back.arrow:SetTexture(tk.Constants.MEDIA.."other\\arrow_side");
    self.menu.back.arrow:SetSize(16, 14);
    self.menu.back.arrow:SetPoint("CENTER", -1, 0);

    self.menu.back:SetScript("OnClick", function(self)
        local submenu_data = private.history:GetBack();
        private.history:RemoveBack();
        config:SetSubMenu(submenu_data);

        if (private.history:GetSize() == 0) then
            private.menu_name:SetText("");
            self:SetEnabled(false);
        else
            private.menu_name:SetText(submenu_data.name);
        end

        tk.PlaySound(tk.Constants.CLICK);
    end);

    self.menu_name = topbar:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge");
    self.menu_name:SetPoint("LEFT", self.menu.back, "RIGHT", 10, 0);

    tk:SetThemeColor(self.menu.back.arrow);
    self.menu.back:SetEnabled(false);

    self.menu.profiles = gui:CreateButton(topbar:GetFrame(), L["Reload UI"]); -- will change to profiles another time
    self.menu.profiles:SetPoint("RIGHT", topbar:GetFrame(), "RIGHT");
    self.menu.profiles:SetScript("OnClick", function()
        ReloadUI();
        tk.PlaySound(tk.Constants.CLICK);
    end);

    self.menu.installer = gui:CreateButton(topbar:GetFrame(), L["MUI Installer"]);
    self.menu.installer:SetPoint("RIGHT", self.menu.profiles, "LEFT", -10, 0);
    self.menu.installer:SetScript("OnClick", function()
        core.commands["install"]();
        private.menu:Hide();
        tk.PlaySound(tk.Constants.CLICK);
    end);

    self.menu.submenus = {};
    tk:SetFullWidth(scrollchild)

    -- a category is a submenu, but a submenu is not a category
    for id, categoryData in tk.ipairs(config.db) do
        self.menu.submenus[id] = tk.CreateFrame("CheckButton", nil, scrollchild);
        scrollchild:SetHeight((scrollchild:GetHeight() or 0) + 60);

        local f = self.menu.submenus[id];
        f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        f.text:SetText(categoryData.name);
        f.text:SetJustifyH("LEFT");
        f.text:SetPoint("TOPLEFT", 10, 0);
        f.text:SetPoint("BOTTOMRIGHT");

        local normal = tk:SetBackground(f, 1, 1, 1, 0);
        local highlight = tk:SetBackground(f, 1, 1, 1, 0);
        local checked = tk:SetBackground(f, 1, 1, 1, 0);
        tk:SetThemeColor(0.3, normal, highlight);
        tk:SetThemeColor(0.6, checked);

        f:SetSize(250, 60);
        f:SetNormalTexture(normal);
        f:SetHighlightTexture(highlight);
        f:SetCheckedTexture(checked);

        if (id == 1) then
            f:SetPoint("TOPLEFT", scrollchild, "TOPLEFT");
            f:SetPoint("TOPRIGHT", scrollchild, "TOPRIGHT", -10, 0);
        else
            f:SetPoint("TOPLEFT", self.menu.submenus[id - 1], "BOTTOMLEFT", 0, -5);
            f:SetPoint("TOPRIGHT", self.menu.submenus[id - 1], "BOTTOMRIGHT", 0, -5);
            scrollchild:SetHeight(scrollchild:GetHeight() + 5);
        end
        f:SetScript("OnClick", function(self)
            if (not self:GetChecked()) then
                self:SetChecked(true);
                return;
            end
            private.history:Clear();
            private.menu_name:SetText("");
            private.menu.back:SetEnabled(false);
            config:SetSubMenu(categoryData);
            tk.PlaySound(tk.Constants.CLICK);
        end);
        if (id == 1) then
            config:SetSubMenu(categoryData);
            f:SetChecked(true);
        end
    end
    tk:GroupCheckButtons(tk.unpack(self.menu.submenus));
    self.menu:Show();
end