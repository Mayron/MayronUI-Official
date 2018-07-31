local _, core = ...;
core.Toolkit = {};

local tk = core.Toolkit;

-- local db = core.Database; shortcut won't work!
-- /run print(LibStub("LibSharedMedia-3.0"):Fetch("font", "MUI_Font"))
tk.Constants = {
    MEDIA = "Interface\\AddOns\\MUI_Core\\media\\",
    CLICK = 856,
    DUMMY_FUNC = function() end,
    DUMMY_FRAME = CreateFrame("Frame"),
    FONT = function()
        return tk.Constants.LSM:Fetch("font", core.Database.global.core.font);
    end,
    LSM = LibStub("LibSharedMedia-3.0");
    backdrop = {
        edgeFile = "Interface\\AddOns\\MUI_Core\\media\\borders\\skinner",
        edgeSize = 1,
    },
    FRAME_STRATA_VALUES = {
        "BACKGROUND",
        "LOW",
        "MEDIUM",
        "HIGH",
        "DIALOG",
        "FULLSCREEN",
        "FULLSCREEN_DIALOG",
        "TOOLTIP",
    },
    LOCALIZED_CLASS_NAMES = {},
    CLASS_RGB_COLORS = {
        ["DEATHKNIGHT"] = {r = 196/255, g = 31/255, b = 59/255, hex = "C41F3B"},
        ["DEMONHUNTER"] = {r = 163/255, g = 48/255, b = 201/255, hex = "A330C9"},
        ["DRUID"] = {r = 1, g = 125/255, b = 10/255, hex = "FF7D0A"},
        ["HUNTER"] = {r = 171/255, g = 212/255, b = 115/255, hex = "ABD473"},
        ["MAGE"] = {r = 105/255, g = 204/255, b = 240/255, hex = "69CCF0"},
        ["MONK"] = {r = 0, g = 1, b = 150/255, hex = "00FF96"},
        ["PALADIN"] = {r = 245/255, g = 140/255, b = 186/255, hex = "F58CBA"},
        ["PRIEST"] = {r = 1, g = 1, b = 1, hex = "FFFFFF"},
        ["ROGUE"] = {r = 1, g = 245/255, b = 105/255, hex = "FFF569"},
        ["SHAMAN"] = {r = 0, g = 112/255, b = 222/255, hex = "0070DE"},
        ["WARLOCK"] = {r = 148/255, g = 130/255, b = 201/255, hex = "9482C9"},
        ["WARRIOR"] = {r = 199/255, g = 156/255, b = 110/255, hex = "C79C6E"},
    },
    colors = {
        white = HIGHLIGHT_FONT_COLOR,
        red = RED_FONT_COLOR,
        yellow = YELLOW_FONT_COLOR,
        orange = ORANGE_FONT_COLOR,
        green = GREEN_FONT_COLOR,
        dim_red = DIM_RED_FONT_COLOR,
        grey = GRAY_FONT_COLOR,
        black = {0, 0, 0},
        unpack = function(self, color)
            local tbl = ((tk.type(color) == "string") and tk.Constants.colors[color]) or color;
            return tbl.r, tbl.g, tbl.b;
        end
    }
};

-- color can be a table of form: {r = 1, b = 1, g = 1} or string "white", "black", etc..
function tk:SetColor(element, color, block, alpha)
    local r, g, b = tk.Constants.colors:unpack(color);
    local t = element:GetObjectType();
    if (t == "Texture") then
        local id = element:GetTexture();
        if (id and id:match("Color-%a+")) then
            element:SetColorTexture(r, g, b, alpha);
            if (block) then
                element.SetColorTexture = tk.Constants.DUMMY_FUNC;
            end
        else
            element:SetVertexColor(r, g, b, alpha);
            if (block) then
                element.SetVertexColor = tk.Constants.DUMMY_FUNC;
            end
        end
    elseif (t == "CheckButton") then
        element:GetCheckedTexture():SetColorTexture(r, g, b, alpha);
        element:GetHighlightTexture():SetColorTexture(r, g, b, alpha);
        if (block) then
            element:GetCheckedTexture().SetColorTexture = tk.Constants.DUMMY_FUNC;
            element:GetHighlightTexture().SetColorTexture = tk.Constants.DUMMY_FUNC;
        end
    elseif (t == "Button") then
        element:GetNormalTexture():SetVertexColor(r, g, b, alpha);
        element:GetHighlightTexture():SetVertexColor(r, g, b, alpha);
        if (block) then
            element:GetNormalTexture().SetVertexColor = tk.Constants.DUMMY_FUNC;
            element:GetHighlightTexture().SetVertexColor = tk.Constants.DUMMY_FUNC;
        end
    elseif (t == "FontString") then
        element:SetTextColor(r, g, b, alpha);
        if (block) then
            element.SetTextColor = tk.Constants.DUMMY_FUNC;
        end
    end

end

tk.UIParent, tk._G, tk.hooksecurefunc, tk.tostringall = UIParent, _G, hooksecurefunc, tostringall;
tk.table, tk.string, tk.math, tk.tostring, tk.tonumber, tk.date = table, string, math, tostring, tonumber, date;
tk.rawset, tk.rawget, tk.setmetatable, tk.getmetatable = rawset, rawget, setmetatable, getmetatable;
tk.pairs, tk.ipairs, tk.next, tk.type, tk.select, tk.unpack = pairs, ipairs, next, type, select, unpack;
tk.collectgarbage, tk.print, tk.pcall, tk.C_Timer, tk.bit = collectgarbage, print, pcall, C_Timer, bit;
tk.CreateFrame, tk.CreateFont, tk.strsplit, tk.PlaySound = CreateFrame, CreateFont, strsplit, PlaySound;
tk.InCombatLockdown, tk.PlaySoundFile, tk.IsAddOnLoaded = InCombatLockdown, PlaySoundFile, IsAddOnLoaded;
tk.LoadAddOn, tk.UIFrameFadeOut, tk.UIFrameFadeIn, tk.assert = LoadAddOn, UIFrameFadeOut, UIFrameFadeIn, assert;
tk.StaticPopupDialogs, tk.StaticPopup_Show, tk.GetTime = StaticPopupDialogs, StaticPopup_Show, GetTime;
tk.SetCVar, tk.GetCVar = SetCVar, GetCVar;

do
    local fake_object = tk.setmetatable({}, {
        __index = function (self, key)
            return tk.Constants.DUMMY_FUNC;
        end
    });

    -- proxy is used to handle multiple inheritance
    -- it chooses which object to call a function from: a frame or panel.
    -- panel already has it's own metatable so cannot use a chained inheritance technique
    local Proxy = {};

    local function Unwrap(self)
        local proxy_data = tk.rawget(self, "_data");
        return proxy_data.instance;
    end

    Proxy.run = function(self, ...)
        -- self is the Proxy object. Should be changed to the actual chosen object
        if (tk.type(Proxy.object[Proxy.key]) ~= "function") then return nil; end
        return Proxy.object[Proxy.key](Proxy.object, ...);
    end

    local DataProxy = {};
    DataProxy.run = function(...)
        local func = DataProxy.object._functions[DataProxy.key];
        if (tk.type(func) ~= "function") then return nil; end
        return func(DataProxy.instance, ...);
    end

    Proxy.metatable = {
        __index = function(self, key)
            if (key == "_data") then return true; end
            local proxy_data = tk.rawget(self, "_data");
            local instance = proxy_data.instance;
            local instance_data = proxy_data.instance_data;
            if (not instance[key]) then
                -- use frame
                if (not instance_data.frame) then return nil; end
                if (not instance_data.frame[key]) then return nil; end
                Proxy.object = instance_data.frame;
            else
                Proxy.object = instance;
            end
            Proxy.key = key;
            return Proxy.run;
        end,
    };

    local data_metatable = {
        __index = function(self, key)
            local _functions = self._functions;
            if (_functions[key] and tk.type(_functions[key]) == "function") then
                DataProxy.object = self;
                DataProxy.instance = _functions.instance;
                DataProxy.key = key;
                return DataProxy.run;
            end
            return nil;
        end,
        __newindex = function(self, key, value)
            local _functions = tk.rawget(self, "_functions");
            if (_functions[key] or tk.type(value) == "function") then
                if (tk.type(value) ~= "function") then
                    _functions[key] = nil;
                else
                    _functions[key] = value;
                end
            else
                tk.rawset(self, key, value);
            end
        end
    };

    function Proxy:Create(instance, instance_data)
        local proxy = {};
        proxy._data = {};
        proxy._data.instance = instance;
        proxy._data.instance_data = instance_data;
        proxy = tk.setmetatable(proxy, self.metatable);
        local instance_type = (instance.GetObjectType and instance:GetObjectType()) or "";
        proxy.GetObjectType = function() return "(Proxy) "..instance_type; end
        instance.GetFrame =  function(self)
            return instance_data.frame;
        end;
        proxy.Unwrap = Unwrap;
        return proxy;
    end

    -- instances of the prototype cannot override the prototype functions
    -- instances cannot gain access to prototype_data or override it
    -- function simplifies the process of creating new instances of the prototype
    -- using prototype:new()
    -- CreateProtectedPrototype is only useful if you want to hide data and only show protected functions
    function tk:CreateProtectedPrototype(name, proxy)
        local prototype = {Static = {}};
        local prototype_data = {instance = {}};

        local function GetObjectType() return name; end

        local prototype_metatable = {
            __index = function(instance, key)
                if (prototype[key] and tk.type(prototype[key]) == "function") then
                    if (key == "GetData") then return nil; end
                    local data = prototype_data.instance[tk.tostring(instance)];
                    if (not data) then return fake_object; end
                    prototype_data.data = data;
                    prototype_data.key = key;
                    return prototype_data.run;
                end
                if (key ~= "Static") then return prototype[key]; end
            end,
            __newindex = function(instance, key, value)
                if (prototype[key]) then
                    tk:Print(name.."."..key.." is protected.");
                else
                    tk.rawset(instance, key, value);
                end
            end,
        };
        prototype = tk.setmetatable(prototype, {
            __call = function(_, properties, frame)
                local data = {};
                local _functions = {};
                local instance = {};
                data.frame = frame;

                if (properties) then
                    for key, value in tk.pairs(properties) do
                        if (tk.type(value) == "function") then
                            _functions[key] = value;
                        else
                            data[key] = value;
                        end
                    end
                end

                data._functions = _functions;
                data = tk.setmetatable(data, data_metatable);

                prototype_data.instance[tk.tostring(instance)] = data;
                instance = tk.setmetatable(instance, prototype_metatable);
                instance.GetObjectType = GetObjectType;
                instance = (proxy and Proxy:Create(instance, data)) or instance;

                _functions.instance = instance;

                return instance;
            end
        });
        prototype_data.run = function(self, ...)
            return prototype[prototype_data.key](self, prototype_data.data, ...);
        end
        prototype.Static.GetData = function(self, instance)
            if (instance.GetObjectType and instance:GetObjectType():find("Proxy")) then
                return tk.rawget(instance, "_data").instance_data;
            end
            return prototype_data.instance[tk.tostring(instance)];
        end
        prototype.Destroy = function(instance)
            if (prototype.__Hook__Destroy) then
                instance:__Hook__Destroy();
            end
            if (instance.GetObjectType and instance:GetObjectType():find("Proxy")) then
                tk.rawget(instance, "_data").instance_data = nil;
            else
                prototype_data.instance[tk.tostring(instance)] = nil;
            end
            tk.collectgarbage("collect");
        end
        return prototype;
    end
end

function tk:Print(...)
    local hex = tk.select(4, self:GetThemeColor());
    local prefix = self:GetHexColoredString("MayronUI:", hex);
    DEFAULT_CHAT_FRAME:AddMessage(tk.string.join(" ", prefix, tk.tostringall(...)));
end

-- TABLE FUNCTIONS
do
    local wrappers = {};

    local function iter(wrapper, id)
        id = id + 1;
        local arg = wrapper[id];
        if (arg) then
            return id, arg;
        else
            tk.table.insert(wrappers, wrapper);
        end
    end

    function tk:IterateArgs(...)
        local wrapper;
        if (#wrappers > 0) then
            wrapper = wrappers[#wrappers];
            wrappers[#wrappers] = nil;
        else
            wrapper = {};
        end
        tk:EmptyTable(wrapper);

        local id = 1;
        local arg = (tk.select(id, ...));
        repeat
            wrapper[id] = arg;
            id = id + 1;
            arg = (tk.select(id, ...));
        until (not arg);

        return iter, wrapper, 0;
    end
end

-- TABLE FUNCTIONS
do
    local wrappers = {};
    local parent = {};

    function parent:Close()
        for _, wrapper in tk.pairs(self) do
            if (tk.type(wrapper) == "table" and wrapper.Close) then
                wrapper:Close();
            end
        end
        tk:EmptyTable(self);
        wrappers[#wrappers + 1] = self;
    end

    local mt = {__index = parent};

    function tk:GetWrapper(...)
        local wrapper;
        if (#wrappers > 0) then
            wrapper = wrappers[#wrappers];
            tk:EmptyTable(wrapper);
            wrappers[#wrappers] = nil;
        else
            wrapper = tk.setmetatable({...}, mt);
        end
        return wrapper;
    end
end

function tk:GetKeyTable(tbl, keys)
    keys = keys or {};
    for key, _ in tk.pairs(tbl) do
        tk.table.insert(keys, key);
    end
    return keys;
end

function tk:PrintTable(tbl, depth, n)
    if (tk.type(tbl) ~= "table") then return; end
    n = n or 0;
    depth = depth or 4;
    if (depth == 0) then return; end

    if (n == 0) then
        tk.print(" ");
    end
    for key, value in tk.pairs(tbl) do
        if (key and tk.type(key) == "number" or tk.type(key) == "string") then
            key = "[\""..key.."\"]";
            if (tk.type(value) == "table") then
                tk.print(tk.string.rep(' ', n)..key.." = {");
                self:PrintTable(value, depth - 1, n + 4);
                tk.print(tk.string.rep(' ', n).."}");
            else
                tk.print(tk.string.rep(' ', n)..key.." = "..tk.tostring(value));
            end
        end
    end
    if (n == 0) then
        tk.print(" ");
    end
end

function MUI_PrintTable(tbl, depth)
    tk:PrintTable(tbl, depth);
end

function tk:GetIndex(tbl, value)
    for id, v in tk.pairs(tbl) do
        if (value == v) then return id; end
    end
    return nil;
end

function tk:GetTableSize(tbl)
    local size = 0;
    for _, _ in tk.pairs(tbl) do
        size = size + 1;
    end
    return size;
end

function tk:EmptyTable(tbl)
    for key, _ in tk.pairs(tbl) do
        tbl[key] = nil;
    end
end

function tk:GetMergedTable(...)
    local merged = {};
    for _, tbl in self:IterateArgs(...) do
        for key, value in tk.pairs(tbl) do
            if (merged[key] and (tk.type(merged[key]) == "table") and (tk.type(value) == "table")) then
                merged[key] = tk:GetMergedTable(merged[key], value);
            else
                merged[key] = value;
            end
        end
    end
    return merged;
end

do
    local args;
    function tk:ConvertPathToKeys(path)
        args = args or tk:CreateLinkedList();
        args:Clear();
        for _, key in self:IterateArgs(tk.strsplit(".", path)) do
            local firstKey = tk.strsplit("[", key);
            args:AddToBack(tk.tonumber(firstKey) or firstKey);
            if (key:find("%b[]")) then
                for index in key:gmatch("(%b[])") do
                    local nextKey = index:match("%[(.+)%]");
                    args:AddToBack(tk.tonumber(nextKey) or nextKey);
                end
            end
        end
        return args;
    end
end

function tk:GetDBObject(addOnName)
    local addon, okay;
    if (tk._G[addOnName]) then
        addon = tk._G[addOnName];
        okay = true;
    else
        okay, addon = tk.pcall(function() LibStub("AceAddon-3.0"):GetAddon(addOnName) end);
    end
    if (not okay) then return; end
    if (addon and not addon.db) then
        for dbname, tbl in tk.pairs(addon) do
            if (tk.string.find(dbname, "db")) then
                if (tk.type(addon[dbname]) == "table") then
                    if (addon[dbname].profile) then
                        return addon[dbname];
                    end
                end
            end
        end
        return nil;
    elseif (addon and addon.db) then
        return addon.db;
    end
end

-- End of Table Functions!

local IsShiftKeyDown = IsShiftKeyDown;
local IsControlKeyDown = IsControlKeyDown;
local IsAltKeyDown = IsAltKeyDown;

do
    local modKeys = {
        S = function() return IsShiftKeyDown(); end,
        C = function() return IsControlKeyDown(); end,
        A = function() return IsAltKeyDown(); end,
    };

    function tk:IsModComboActive(strKey) -- "SC" - is shift and control down but not alt? (example)
        local checked = {S = false, C = false, A = false};
        for i = 1, #strKey do
            local c = strKey:sub(i,i)
            c = tk.string.upper(c);
            checked[c] = true;
            if (not modKeys[c]()) then
                return false;
            end
        end
        for key, value in tk.pairs(checked) do
            if (not value and modKeys[key]()) then
                return false;
            end
        end
        return strKey ~= "";
    end
end

local QuestDifficultyColors = QuestDifficultyColors;
local UnitLevel = UnitLevel;
local GetQuestGreenRange = GetQuestGreenRange;

function tk:GetDifficultyColor(level)
    local difference = (level - UnitLevel("player"));
    local color;
    if (difference >= 5) then
        color = QuestDifficultyColors["impossible"];
    elseif (difference >= 3) then
        color = QuestDifficultyColors["verydifficult"];
    elseif (difference >= -2 or level < 0) then
        color = QuestDifficultyColors["difficult"];
    elseif (-difference <= GetQuestGreenRange()) then
        color = QuestDifficultyColors["standard"];
    else
        color = QuestDifficultyColors["trivial"];
    end
    return color;
end

function tk:Equals(value1, value2)
    local type1 = tk.type(value1);
    if (tk.type(value2) == type1) then
        if (type1 == "table") then
            for id, value in pairs(value1) do
                if (not self:Equals(value, value2[id])) then
                    return false;
                end
            end
            return true;
        elseif (type1 == "function") then
            return true; -- ignore functions
        else
            return value1 == value2;
        end
    else
        return false;
    end
end

function tk:SetFullWidth(frame, padding)
    padding = padding or 0;
    if (not frame:GetParent()) then
        tk.hooksecurefunc(frame, "SetParent", function()
            frame:GetParent():HookScript("OnSizeChanged", function(_, width)
                frame:SetWidth(width - padding);
            end)
            frame:SetWidth(frame:GetParent():GetWidth() - padding);
        end)
    else
        frame:GetParent():HookScript("OnSizeChanged", function(_, width)
            frame:SetWidth(width - padding);
        end)
        frame:SetWidth(frame:GetParent():GetWidth() - padding);
    end
end

function tk:MakeMovable(frame, dragger, movable)
    if (movable == nil) then
        movable = true;
    end
    dragger = dragger or frame;
    dragger:EnableMouse(movable);
    dragger:RegisterForDrag("LeftButton");
    frame:SetMovable(movable);
    frame:SetClampedToScreen(true);
    dragger:HookScript("OnDragStart", function()
        if (frame:IsMovable()) then
            local x, y = frame:GetCenter();
            frame:SetPoint("CENTER", tk.UIParent, "BOTTOMLEFT", x, y);
            frame:StartMoving();
        end
    end);
    dragger:HookScript("OnDragStop", function()
        if (frame:IsMovable()) then
            frame:StopMovingOrSizing();
        end
    end);
end

function tk:SavePosition(frame, db_path, override)
    local point, relativeFrame, relativePoint, x, y = frame:GetPoint();
    if (not relativeFrame) then
        relativeFrame = frame:GetParent():GetName();
    else
        relativeFrame = relativeFrame:GetName();
        if (not relativeFrame or relativeFrame and relativeFrame ~= "UIParent") then
            if (not override) then return; end
            x, y = frame:GetCenter();
            point = "CENTER";
            relativeFrame = "UIParent"; -- Do not want this to be UIParent in some cases
            relativePoint = "BOTTOMLEFT";
        end
    end
    local positions = {
        point = point,
        relativeFrame = relativeFrame,
        relativePoint = relativePoint,
        x = x, y = y
    };
    core.Database:SetPathValue(db_path, positions);
    return positions;
end

function tk:MakeResizable(frame, dragger)
    dragger = dragger or frame;
    frame:SetResizable(true);
    dragger:RegisterForDrag("LeftButton");
    dragger:HookScript("OnDragStart", function()
        frame:StartSizing();
    end)
    dragger:HookScript("OnDragStop", function()
        frame:StopMovingOrSizing();
    end)
end

function tk:KillElement(element)
    element:Hide();
    element:SetAllPoints(tk.Constants.DUMMY_FRAME);
    element.Show = tk.Constants.DUMMY_FUNC;
end

function tk:HideFrameElements(frame, kill)
    for _, child in self:IterateArgs(frame:GetChildren()) do
        if (kill) then
            self:KillElement(child);
        else
            child:Hide();
        end
    end
    for _, region in self:IterateArgs(frame:GetRegions()) do
        if (kill) then
            self:KillElement(region);
        else
            region:Hide();
        end
    end
end

function tk:HookOnce(func)
    local execute = true;
    local function wrapper(...)
        if (execute) then
            func(...);
            execute = nil;
        end
    end
    return wrapper;
end

-------------------------------
-- Game Related Functions
-------------------------------
local UnitName, GetRealmName = UnitName, GetRealmName;
local IsTrialAccount = IsTrialAccount;
local GetAccountExpansionLevel = GetAccountExpansionLevel;
local UnitClass = UnitClass;

function tk:GetPlayerKey()
    local key, realm = UnitName("player"), GetRealmName():gsub("%s+", "");
    key = realm and tk.string.join("-", key, realm);
    return key;
end

function tk:IsPlayerMaxLevel()
    local lvl = UnitLevel("player");
    if (IsTrialAccount()) then
        return (lvl == 20);
    else
        local id = GetAccountExpansionLevel();
        if (id == 0) then
            return (lvl == 60);
        elseif (id == 1) then
            return (lvl == 70);
        elseif (id == 2) then
            return (lvl == 80);
        elseif (id == 3) then
            return (lvl == 85);
        elseif (id == 4) then
            return (lvl == 90);
        elseif (id == 5) then
            return (lvl == 100);
        elseif (id == 6) then
            return (lvl == 110);
        end
    end
end

-------------------------------
-- Colour Related Functions
-------------------------------
function tk:GetHexColoredString(str, hex)
    return tk.string.format("|cff%s%s|r", hex:upper(), str);
end

function tk:GetRGBColoredString(str, r, g, b)
    r = r * 255; g = g * 255; b = b * 255;
    local hex = tk.string.format("%02x%02x%02x", r, g, b):upper();
    return self:GetHexColoredString(str, hex);
end

function tk:GetThemeColoredString(str)
    local r, g, b = tk:GetThemeColor();
    return self:GetRGBColoredString(str, r, g, b);
end

function tk:GetClassColoredString(className, str)
    className = className or (tk.select(2, UnitClass("player")));
    str = str or className;
    className = className:gsub("%s+", "");
    className = string.upper(className);
    return self:GetHexColoredString(str, self.Constants.CLASS_RGB_COLORS[className].hex);
end

-- weird
function tk:SetClassColoredTexture(className, texture)
    className = className or (tk.select(2, UnitClass("player")));
    className = tk.string.upper(className);
    className = className:gsub("%s+", "");
    local c = self.Constants.CLASS_RGB_COLORS[className];
    texture:SetVertexColor(c.r, c.g, c.b, texture:GetAlpha());
end

do
    local c;
    function tk:SetThemeColor(...)
        local alpha = (tk.select(1, ...));
        alpha = ((tk.type(alpha) == "number") and alpha) or 1;
        c = c or core.Database.profile.theme.color;
        for id, element in self:IterateArgs(...) do
            if (tk.type(element) ~= "number") then
                tk:SetColor(element, c, nil, alpha);
            end
        end
    end

    function tk:GetThemeColor()
        c = c or core.Database.profile.theme.color;
        return c.r, c.g, c.b, c.hex;
    end
end

function tk:SetBackground(frame, ...)
    local texture = frame:CreateTexture(nil, "BACKGROUND");
    texture:SetAllPoints(frame);
    if (#{...} > 1) then
        texture:SetColorTexture(...);
    else
        texture:SetTexture(...);
    end
    return texture;
end

function tk:GroupCheckButtons(...)
    local btns = {};
    for id, btn in self:IterateArgs(...) do
        btn:SetID(id);
        tk.table.insert(btns, btn);
        btn:HookScript("OnClick", function(self)
            if (self:GetChecked()) then
                local id = self:GetID();
                for i, btn in tk.ipairs(btns) do
                    if (id ~= i) then
                        btn:SetChecked(false);
                    end
                end
            end
        end)
    end
end


do
    local SlideController = tk:CreateProtectedPrototype("SlideController");

    function SlideController:Start(data, forceState)
        data.stop = nil;
        local step = tk.math.abs(data.step);

        if (forceState) then
            step = (forceState == self.FORCE_RETRACT and -data.step) or data.step;
        else
            step = ((self:IsExpanded()) and -data.step) or data.step;
        end

        local function loop()

            if (data.step == 0 or data.stop) then return; end
            local newHeight = tk.math.floor(data.frame:GetHeight() + 0.5) + step;
            local endHeight = (step > 0 and data.maxHeight) or data.minHeight;

            if ((step > 0 and newHeight < data.maxHeight) or
                    (step < 0 and newHeight > data.minHeight)) then
                data.frame:SetHeight(newHeight);
                tk.C_Timer.After(0.02, loop);
            else
                data.frame:SetHeight(endHeight);
                self:Stop();
            end
        end

        data.frame:Show();
        if (data.frame.ScrollFrame) then
            data.frame.ScrollFrame.animating = true;
        end

        loop();
    end

    function SlideController:Stop(data)
        data.stop = true;

        if (data.frame.ScrollFrame and data.frame.ScrollFrame.showScrollBar) then
            data.frame.ScrollFrame.showScrollBar:Show();
        end
        if (data.frame.ScrollFrame) then
            data.frame.ScrollFrame.animating = false;
        end
        if (self:IsExpanded() and data.onEndExpand) then
            data.onEndExpand(data.frame);
        elseif (self:IsRetracted()) then
            if (data.onEndRetract) then
                data.onEndRetract(data.frame);
            else
                data.frame:Hide();
            end
        end
    end

    function SlideController:SetStepValue(data, step)
        data.step = step;
        data.backedUpStep = step;
    end

    function SlideController:IsRunning(data)
        return data.stop;
    end

    function SlideController:IsExpanded(data)
        return ((tk.math.floor(data.frame:GetHeight() + 0.5)) == data.maxHeight);
    end

    function SlideController:IsRetracted(data)
        return ((tk.math.floor(data.frame:GetHeight() + 0.5)) == data.minHeight);
    end

    function SlideController:SetMaxHeight(data, maxHeight)
        data.maxHeight = tk.math.floor(maxHeight + 0.5);
    end

    function SlideController:SetMinHeight(data, minHeight)
        data.minHeight = tk.math.floor(minHeight + 0.5);
    end

    function SlideController:OnEndRetract(data, func)
        data.onEndRetract = func;
    end

    function SlideController:OnEndExpand(data, func)
        data.onEndExpand = func;
    end

    function tk:CreateSlideController(frame)
        local slider = SlideController({
            frame = frame,
            step = 20,
            minHeight = 1,
            maxHeight = 200,
        });
        slider.FORCE_RETRACT = 1;
        slider.FORCE_EXPAND = 2;
        return slider
    end
end

do
    local function split(char)
        return " " .. char
    end

    local function trim1(s)
        return (s:gsub("^%s*(.-)%s*$", "%1"))
    end

function tk:SplitCamelString(str)
        return trim1(str:gsub("[A-Z]", split):gsub("^.", string.upper))
    end
end

function tk:SetFontSize(fontstring, size)
    local filename, fontHeight, flags = fontstring:GetFont();
    fontstring:SetFont(filename, size, flags);
end

function tk:SetGameFont(font)
    tk._G["UNIT_NAME_FONT"] = font;
    tk._G["NAMEPLATE_FONT"] = font;
    tk._G["DAMAGE_TEXT_FONT"] = font;
    tk._G["STANDARD_TEXT_FONT"] = font;

    local fonts = {
        "SystemFont_Tiny", "SystemFont_Shadow_Small", "SystemFont_Small",
        "SystemFont_Small2", "SystemFont_Shadow_Small2", "SystemFont_Shadow_Med1_Outline",
        "SystemFont_Shadow_Med1", "QuestFont_Large", "SystemFont_Large",
        "SystemFont_Shadow_Large_Outline", "SystemFont_Shadow_Med2", "SystemFont_Shadow_Large",
        "SystemFont_Shadow_Large2", "SystemFont_Shadow_Huge1", "SystemFont_Huge2",
        "SystemFont_Shadow_Huge2", "SystemFont_Shadow_Huge3", "SystemFont_World",
        "SystemFont_World_ThickOutline", "SystemFont_Shadow_Outline_Huge2", "SystemFont_Med1",
        "SystemFont_WTF2", "SystemFont_Outline_WTF2", "GameTooltipHeader", "System_IME",

        -- other:
        "NumberFont_OutlineThick_Mono_Small", "NumberFont_Outline_Huge",
        "NumberFont_Outline_Large", "NumberFont_Outline_Med", "NumberFont_Shadow_Med",
        "NumberFont_Shadow_Small", "QuestFont", "QuestTitleFont", "QuestTitleFontBlackShadow",
        "GameFontNormalMed3", "SystemFont_Med3", "SystemFont_OutlineThick_Huge2",
        "SystemFont_Outline_Small", "SystemFont_Shadow_Med3", "Tooltip_Med", "Tooltip_Small",
        "ZoneTextString", "SubZoneTextString", "PVPInfoTextString", "PVPArenaTextString",
        "CombatTextFont", "FriendsFont_Normal", "FriendsFont_Small", "FriendsFont_Large",
        "FriendsFont_UserText",
    };

    SystemFont_NamePlate:SetFont(font, 9); -- weird font size
    for _, f in tk.ipairs(fonts) do
        local _, size, outline = tk._G[f]:GetFont();
        tk._G[f]:SetFont(font, size, outline);
    end
end

-- removes trailing zeros
function tk:FormatFloat(precision, number)
    return (tk.string.format("%."..precision.."f", number):gsub("%.?0+$", ""));
end

function tk:FormatNumberString(number)
    number = tk.tostring(number);
    return tk.string.gsub(number, "^(-?%d+)(%d%d%d)", '%1,%2');
end

function tk:GetLastPathKey(path)
    local list = tk:CreateLinkedList(tk.strsplit(".", path));
    local key = list:GetBack();
    if (key:find("%b[]")) then
        key = key:match(".+(%b[])");
        key = key:match("[(%d+)]");
        key = tk.tonumber(key) or key; -- tonumber returns 0 if not convertible
    end
    list:Destroy();
    return key;
end

do
    local frames = {};
    function tk:PopFrame(objectType, parent)
        parent = parent or self.UIParent;
        objectType = objectType or "Frame";
        local frame = frames[objectType] and frames[objectType][#frames];
        if (not frame) then
            frame = tk.CreateFrame(objectType);
        else
            frames[objectType][#frames] = nil;
        end
        frame:SetParent(parent);
        frame:Show();
        return frame;
    end

    function tk:PushFrame(frame)
        if (not frame.GetObjectType) then return; end
        local objectType = frame:GetObjectType();
        frames[objectType] = frames[objectType] or {};
        frame:SetParent(tk.Constants.DUMMY_FRAME);
        frame:SetAllPoints(true);
        frame:Hide();
        for _, child in self:IterateArgs(frame:GetChildren()) do
            self:PushFrame(child);
        end
        for _, region in self:IterateArgs(frame:GetRegions()) do
            region:SetParent(tk.Constants.DUMMY_FRAME);
            region:SetAllPoints(true);
            region:Hide();
        end
        frames[objectType][#frames + 1] = frame;
    end
end

-------------------------------
-- Stack object
-------------------------------
local Stack = tk:CreateProtectedPrototype("Stack");

-- @constructor
function tk:CreateStack(OnNew, OnPush, OnPop)
    return Stack({
        tbl = {},
        OnNew = OnNew,
        OnPush = OnPush,
        OnPop = OnPop
    });
end

function Stack:Push(data, item, ...)
    data.tbl[#data.tbl + 1] = item;
    if (data.OnPush) then
        data.OnPush(item, ...);
    end
end

function Stack:Pop(data, ...)
    local item;
    if (self:IsEmpty()) then
        if (data.OnNew) then
            item = data.OnNew(...);
        end
    else
        item = data.tbl[#data.tbl];
        data.tbl[#data.tbl] = nil;
    end
    if (data.OnPop) then
        data.OnPop(item, ...);
    end
    return item;
end

function Stack:IsEmpty(data)
    return (#data.tbl == 0);
end

function Stack:ForEach(data, func, ...)
    for _, item in tk.ipairs(data.tbl) do
        func(item, ...);
    end
end

-------------------------------
-- LinkedList and Node objects
-------------------------------
local LinkedList = tk:CreateProtectedPrototype("LinkedList");
local Node = {};

function Node:Destroy()
    local next = self.next;
    local prev = self.prev;

    if (next) then
        next.prev = prev;
    else
        self.list.back = prev;
    end
    if (prev) then
        prev.next = next;
    else
        self.list.front = next;
    end
    self.list.size = (self.list.size or 0) - 1;
end

function Node:new(list, value)
    local node = {};
    node.value = value;
    node.list = LinkedList.Static:GetData(list);
    return tk.setmetatable(node, {__index = Node});
end

function Node:GetObjectType()
    return "Node";
end

function Node:Next()
    return self.next;
end

function Node:Previous()
    return self.previous;
end

-- LinkedList constructor
function tk:CreateLinkedList(...)
    local list = LinkedList();
    for _, value in self:IterateArgs(...) do
        list:AddToBack(value);
    end
    return list;
end

function LinkedList:ToString()
    local name = tk.tostring(self):gsub("table", "LinkedList");
    local str = " [";
    for id, value in self:Iterate() do
        str = str..tk.tostring(value);
        if (id < self:GetSize()) then
            str = str..", ";
        end
    end
    return name..str.."]";
end

function LinkedList:Clear()
    while (self:RemoveFront()) do end
end

function LinkedList:GetSize(data)
    return data.size;
end

function LinkedList:IsEmpty(data)
    return data.front == nil;
end

function LinkedList:AddToBack(data, value)
    local node = Node:new(self, value);
    if (not data.front) then
        data.front = node;
        data.back = node;
    else
        data.back.next = node;
        node.prev = data.back;
        data.back = node;
    end
    data.size = (data.size or 0) + 1;
end

function LinkedList:AddToFront(data, value)
    local node = Node:new(self, value);
    if (not data.front) then
        data.front = node;
        data.back = node;
    else
        node.next = data.front;
        data.front.prev = node;
        data.front = node;
    end
    data.size = (data.size or 0) + 1;
end

function LinkedList:RemoveFront(data)
    if (not data.front) then return false; end
    data.front:Destroy();
    return true;
end

function LinkedList:RemoveBack(data)
    if (not data.back) then return false; end
    data.back:Destroy();
    return true;
end

function LinkedList:Remove(data, value)
    local node = data.front;
    repeat
        if (value == node.value) then
            node:Destroy();
            return true;
        end
        node = node.next
    until(not node);
    return false;
end

function LinkedList:GetFront(data, node)
    if (node) then
        return data.front;
    else
        return data.front.value;
    end
end

function LinkedList:GetBack(data, node)
    if (node) then
        return data.back;
    else
        return data.back.value;
    end
end

function LinkedList:PopFront()
    local value = self:GetFront();
    self:RemoveFront();
    return value;
end

function LinkedList:PopBack()
    local value = self:GetBack();
    self:RemoveBack();
    return value;
end

function LinkedList:Unpack(_, n)
    n = n or 1;
    local values = {};
    for id, value in self:Iterate() do
        if (n <= id) then
            tk.table.insert(values, value);
        end
    end
    return tk.unpack(values);
end

function LinkedList:Iterate(data, backwards)
    local node, id, step;
    if (backwards) then
        node = data.back;
        id = self:GetSize() + 1; step = -1;
    else
        node = data.front;
        id = 0; step = 1;
    end
    return function()
        if (node) then
            local value = node.value;
            id = id + step;
            if (backwards) then node = node.prev;
            else node = node.next; end
            return id, value;
        end
    end
end