local _, core = ...;
core.Toolkit = core.Toolkit or {};

local tk = core.Toolkit;
-----------------------------

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
    local counter = 0;
    local unpacker = {};

    local function startCleaningTimer()
        counter = counter + 1;

        if (counter >= 10) then
            counter = 0;
            tk:EmptyTable(wrappers);   
        else
            C_Timer.After(1, startCleaningTimer);
        end        
    end

    function parent:Close()
        for _, wrapper in tk.pairs(self) do
            if (tk.type(wrapper) == "table" and wrapper.Close) then
                wrapper:Close();
            end
        end

        tk:EmptyTable(self);
        tk.setmetatable(self, nil);

        if (#wrappers < 20) then
            wrappers[#wrappers + 1] = self;

            if (counter == 0) then
                startCleaningTimer();
            end            
        end        
    end

    local mt = {__index = parent};

    function tk:GetWrapper(...)
        local wrapper;

        if (#wrappers > 0) then
            wrapper = wrappers[#wrappers];
            wrappers[#wrappers] = nil;
            self:FillTable(wrapper, ...);
        else
            wrapper = {...};
        end

        wrapper = tk.setmetatable(wrapper, mt);
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
    if (tk.type(tbl) ~= "table") then 
        return; 
    end

    n = n or 0;
    depth = depth or 4;

    if (depth == 0) then 
        return; 
    end

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
        if (value == v) then 
            return id; 
        end
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

function tk:FillTable(tbl, ...)
    for id, value in self:IterateArgs(...) do
        tbl[id] = value;
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

    if (not okay) then 
        return; 
    end

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
        if (not frame.GetObjectType) then 
            return; 
        end

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