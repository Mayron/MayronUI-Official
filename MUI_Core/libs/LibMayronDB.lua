--[[
Created by Mayron (author of MayronUI), 2nd of March, 2017.
Originally created for MayronUI, but has been created for general use.

Please read the homepage for information on how to use this library:
http://www.wowinterface.com/downloads/info24356-MayronDB.html
--]]

local db = LibStub:NewLibrary("LibMayronDB", 2.5);
if (not db) then return; end

local private = {};
private.db_info = {};

local DEBUG = false;

local Observer = {};

local ScriptHandler = CreateFrame("Frame");
ScriptHandler:RegisterEvent("ADDON_LOADED");
ScriptHandler.addon_names = {};

local pairs, ipairs, type, tonumber, strsplit = pairs, ipairs, type, tonumber, strsplit;
local print, string, tostring, table, _G, assert = print, string, tostring, table, _G, assert;
local UnitName, GetRealmName, select, next = UnitName, GetRealmName, select, next;
local rawget, rawset, C_Timer, setmetatable = rawget, rawset, C_Timer, setmetatable;

------------------------
-- Database API
------------------------
--[[
Creates the database but does not initialize it. Can add default values but cannot
directly communicate with the saved variable table or profiles until after "ADDON_LOADED" event.

@param (string) svName: The name of the saved variable defined in the toc file.
@param (string) addonName: The name of the addon to listen out for. If supplied it will start the database
automatically after the ADDON_LOADED event has fired and the saved variable becomes accessible.
@return (table): The database object.
--]]
function db:CreateDatabase(sv_name, addon_name)
    local db = {sv_name = sv_name};
    local db_key = tostring(db);
    private.db_info[db_key] = {};
    if (addon_name) then
        ScriptHandler.addon_names[addon_name] = db;
    end
    return setmetatable(db, {__index = self});
end

--[[
@param (function) func: Assign a function handler to the database OnStart event. The function
will receive a reference to the database as its first argument.
--]]
function db:OnStart(func)
    private:GetDatabaseInfo(self).OnStart = func;
end

--[[
Can be used without the database being initialized.

@param (string) path: The path to locate a new value being added into the database defaults table.
@param (any) value: The new value to be added into the database defaults table.
@return (boolean): Whether a key and value pair was added successfully.

Example: db:AddToDefaults("profile.aModule['red theme'][10].object", value)
--]]
function db:AddToDefaults(path, value)
    local info = private:GetDatabaseInfo(self);
    info.defaults = info.defaults or {};
    return db:SetPathValue(path, value, info.defaults);
end

--[[
A helper function to print the defaults table.

@param (optional | int) depth: The depth of tables to print before only printing table references.
@param (optional | string) path: Used to print a table within the defaults table rather
than the whole thing.
--]]
function db:PrintDefaults(depth, path)
    local defaults = private:GetDatabaseInfo(self).defaults;
    if (path) then
        defaults = self:ParsePathValue(path, defaults);
    end
    private:PrintTable(defaults, depth);
end

function db:SetDebug(debug)
    DEBUG = debug;
end

--[[
Sets the addon profile for the currently logged in character.
Creates a new profile if the named profile does not exist.

@param (string) name: The name of the profile to assign to the character.
--]]
function db:SetProfile(name)
    self.sv_table.profiles[name] = self.sv_table.profiles[name] or {};
    local key, realm = UnitName("player"), GetRealmName():gsub("%s+", "");
    key = string.join("-", key, realm);
    if (name ~= key) then
        self.sv_table.profile_keys[key] = name;
    else
        self.sv_table.profile_keys[key] = nil;
    end
    private:GetDatabaseInfo(self).current_profile = name;
end

--[[
@return (table): A table containing string profile names for all profiles associated with the addon.
--]]
function db:GetProfiles()
    local profiles = {};
    for key, _ in pairs(self.sv_table.profiles) do
        table.insert(profiles, key);
    end
    return profiles;
end

--[[
Usable in a for loop to loop through all profiles associated with the AddOn.
Each loop returns values: id, profileName, profile
    * (int) id: current loop iteration
    * (string) profileName: the name of the profile
    * (table) profile: the profile data
--]]
function db:IterateProfiles()
    local id = 0;
    local profile_names = {};
    for name, _ in pairs(self.sv_table.profiles) do
        table.insert(profile_names, name);
    end
    return function()
        id = id + 1;
        if (id <= #profile_names) then
            return id, profile_names[id], self.sv_table.profiles[profile_names[id]];
        end
    end
end

--[[
@return (int): The number of profiles associated with the addon.
--]]
function db:GetNumProfiles()
    local n = 0;
    for _ in pairs(self.sv_table.profiles) do
        n = n + 1;
    end
    return n;
end

--[[
Helper function to reset a profile.

@param (string) name: The name of the profile to reset.
--]]
function db:ResetProfile(name)
    self:RemoveProfile(name);
    self:SetProfile(name);
end

--[[
Renames an existing profile to a new profile name. If the new name already exists, it appends a number
to avoid clashing: 'example (1)'.

@param (string) oldName: The old profile name.
@param (string) newName: The new profile name.
--]]
function db:RenameProfile(old_name, new_name)
    local new = private:GetNewProfileName(new_name, self.sv_table);
    local profile = self.sv_table.profiles[old_name];
    self:SetProfile(new);
    self.sv_table.profiles[new] = profile;
    self:RemoveProfile(old_name);
end

--[[
Moves the profile to the bin. The profile cannot be accessed from the bin.
Use db:RestoreProfile(name) to restore the profile.

@param (string) name: The name of the profile to move to the bin.
--]]
function db:RemoveProfile(name)
    local info = private:GetDatabaseInfo(self);
    if (self.sv_table.profiles[name]) then
        info.bin = info.bin or {};
        info.bin[name] = self.sv_table.profiles[name];
        self.sv_table.profiles[name] = nil;
        if (self:GetCurrentProfile() == name) then
            self:SetProfile("Default");
            return true;
        end
    end
end

--[[
Profiles will remain in the bin until a reload of the UI occurs.
If the bin contains a profile, this function can restore it.

@param (string) name: The name of the profile located inside the bin.
--]]
function db:RestoreProfile(name)
    local info = private:GetDatabaseInfo(self);
    if (info.bin) then
        local profile = self.bin[name];
        if (profile) then
            info.bin[name] = nil;
            name = private:GetNewProfileName(name, self.sv_table);
            self.sv_table.profiles[name] = profile;
            return true;
        end
    end
    return false;
end

--[[
@return (string): The current profile associated with the currently logged in character.
--]]
function db:GetCurrentProfile()
    local info = private:GetDatabaseInfo(self);
    if (info.current_profile) then
        return info.current_profile;
    end
    local key, realm = UnitName("player"), GetRealmName():gsub("%s+", "");
    key = realm and string.join("-", key, realm);
    local profile = self.sv_table.profile_keys[key] or key;
    info.current_profile = profile;
    return profile;
end

--[[
Turns a path address into the located database value.

@param (string) path: The path of the database value. Example: "db.profile.table.myValue"
@param (optional | table) root: The root table to locate the value the path address is pointing to. Default is db.
@param (optional | boolean) returnObserver: If the located value is a table, should the
raw table be returned, or an observer pointing to the table?
@return (any): The value found at the location specified by the path address.
Might return nil if the path address is invalid, or no value is located at the address.

Example: value = db:ParsePathValue("global.core.settings["..moduleName.."][5]")
--]]
function db:ParsePathValue(path, root, returnObserver)
    if (path) then
        root = root or self;

        for _, key in private:IterateArgs(strsplit(".", path)) do
            if (tonumber(key)) then
                key = tonumber(key);
                root = root[key];
                if (root == nil) then return; end

            else
                local indexes;
                if (key:find("%b[]")) then
                    indexes = {};
                    for index in key:gmatch("(%b[])") do
                        index = index:match("%[(.+)%]");
                        table.insert(indexes, index);
                    end
                end

                key = strsplit("[", key);

                if (#key > 0) then
                    root = root[key];
                    if (root == nil) then return; end
                end

                if (indexes) then
                    for _, key in ipairs(indexes) do
                        key = tonumber(key) or key;
                        root = root[key];
                        if (root == nil) then return; end
                    end
                end
            end
        end
    end

    if (not returnObserver and type(root) == "table" and root.GetTable) then
        return root:GetTable(); -- only if it is an Observer
    end

    return root;
end

--[[
Adds a value to the database at the specified path address.

@param (string) path: The path address (i.e. "db.profile.aModule.aValue") of the database value.
@param (any) value: The value to assign to the database.
@param (optional | table) root: The root table. Default is db.
@return (boolean): Returns if the value was successfully added. If the path address was
invalid, then false will be returned.

Example: db:SetPathValue("profile.aModule.aSubTable["..attributeName.."][5]", value)
--]]
function db:SetPathValue(path, value, root)
    root = root or self;

    local lastTable, lastKey = private:GetLastTableKeyPairs(path, root);
    if (lastKey and lastTable) then
        lastTable[lastKey] = value;
        return true;
    end

    return false;
end

--[[
Adds a new value to the saved variable table only once. Registers the added value with a registration key.

@param (string) path: The path address to specify where the value should be appended to.
@param (any) value: The value to be added.
@param (optional | string) registryKey: Instead of using the path address as a key, use a different
key to register the appended action to the saved variable table. This can be helpful for updating
the addon using version control by changing the key to something else and re-appending.
@return (boolean): Returns whether the value was successfully added.
--]]
function db:AppendOnce(path, value, registryKey)
    registryKey = registryKey or path;
    local tbl_type = strsplit("[.%[]", path, 2);

    if (self[tbl_type][registryKey]) then return false; end

    local existing_value = self:ParsePathValue(path);

    if (existing_value and type(existing_value) == "table") then
        if (type(value) == "table") then
            value = private:GetTable(existing_value, value);
        end
    end

    if (value == nil) then return false; end
    local success = self:SetPathValue(path, value);

    if (success) then
        self[tbl_type][registryKey] = true;
    end

    return success;
end

------------------------
-- Observer Framework
------------------------

--[[
Used to achieve database inheritance. If an observer cannot find a value, it uses the value found in the
parent table. Useful if many separate tables in the saved variables table should use the same set of
default values. Non-static method used on an Observer object.

@param (Observer) parentObserver: Which observer should be used as the parent.

Example: db.profile.aFrame:SetParent(db.global.frameTemplate)
--]]
function Observer:SetParent(parent_observer)
    local data = rawget(self, "_data");
    data.from_parent_path = {};
    data.root_parent = true;
    data.parent = parent_observer;
end

--[[
@return (Observer): Returns the current Observer's parent.
--]]
function Observer:GetParent()
    return rawget(self, "_data").parent;
end

--[[
@return (boolean) hasParent: Returns true if Observer is linked to a parent Observer.
--]]
function Observer:HasParent()
    return type(rawget(self, "_data").parent) == "table";
end

do
    local function merge(merged, tbl)
        for key, value in pairs(tbl) do
            if (type(value) == "table") then
                merged[key] = merged[key] or private:GetWrapper();
                merge(merged[key], value);
            else
                merged[key] = value;
            end
        end
    end

    --[[
    Returns a table containing all values cloned from the default and saved variable table.
    Changing values in the returned table will not affect the original values. For read-only
    use. Clones values starting at the Observers path address.

    @return (table): A table containing cloned values, from the default and saved
    variable table, using the observers location.

    Example: db.profile.aModule:GetTable()
    --]]
    function Observer:GetTable()
        local data = rawget(self, "_data");
        local merged = private:GetWrapper();
        local default_table = db:ParsePathValue(data.path,
            private:GetDatabaseInfo(data.db).defaults[data.tbl_type]);

        local sv_table = db:ParsePathValue(data.path, private:GetSVTable(data.tbl_type, data.db));

        if (default_table) then
            merge(merged, default_table);
        end

        if (sv_table) then
            merge(merged, sv_table);
        end
        
        return merged;
    end
end

--[[
Usable in a for loop. Uses the merged table to iterate through key and value pairs of the default and
saved variable table paired together using the Observer path address.

Example:
for key, value in db.profile.aModule:Iterate() do
    print(string.format("%s : %s", key, value))
end
--]]
function Observer:Iterate()
    local merged = self:GetTable();
    return next, merged, nil;
end

--[[
@return (int): The length of the merged table (Observer:GetTable()).
--]]
function Observer:GetLength()
    local length = 0;
    for _, _ in self:Iterate() do
        length = length + 1;
    end
    return length;
end

--[[
Used to remove a table in the saved variable database and clean the database.
Cannot be used to remove any other value type!

Example: db.global.deleteMe:Remove()
--]]
function Observer:Remove()
    local data = rawget(self, "_data");
    local tbl = private:GetSVTable(data.tbl_type, data.db);
    local parent = tbl;
    local remove_key; -- the key to remove
    local previous; -- previous table visited
    local previous_key; -- previous key
    for id, key in private:IterateArgs(strsplit(".", data.path)) do -- path could be "theme.color.r"
        if (id == 1) then remove_key = key; end
        if (type(tbl) ~= "table") then break; end
        key = tonumber(key) or key;
        previous = tbl; -- starts at global or profile table
        previous_key = key;
        tbl = tbl[key]; -- might not be a table
        if (private:GetTableSize(tbl) == 0) then -- empty table!
            if (not parent) then
                parent = previous;
                remove_key = previous_key;
            end
            break;
        else parent = nil; end
    end
    if (type(parent) == "table") then
        parent[remove_key] = nil;
    end
end

--[[
A helper function to print all contents of a table pointed to by the selected Observer.

@param (optional | int) depth: The depth of tables to print before only printing table references.

Example: db.profile.aModule:Print()
--]]
function Observer:Print(depth)
    local merged = self:GetTable();
    private:PrintTable(merged, depth);
end

-------------------------------------------------------
-- Advanced developer code only (not user friendly!)
-------------------------------------------------------
ScriptHandler:SetScript("OnEvent", function(self, _, addon_name)
    local db = self.addon_names[addon_name];
    if (db) then
        private:StartDatabase(db);
        self.addon_names[addon_name] = nil;
    end
end);

Observer.metatable = {
    __index = function(self, key)
        if (Observer[key]) then
            return Observer[key];
        end

        if (key == "_data") then
            return true;
        end

        local data = rawget(self, "_data");
        local newpath = (data.path and data.path.."." or "")..key;
        local storageKey = data.tbl_type.."."..newpath;

        if (not key) then
            data.secure_call = true; -- was not switched from child to parent
        end

        if (data.child and data.secure_call) then
            data.child = nil;
        end

        local info = private:GetDatabaseInfo(data.db);
        if (info.observers and info.observers[storageKey]) then
            info.observers[storageKey].counter = 5;
            return info.observers[storageKey].item;
        end

        local value;
        local default_table = data.db:ParsePathValue(data.path, info.defaults[data.tbl_type]);
        local sv_table = data.db:ParsePathValue(data.path, private:GetSVTable(data.tbl_type, data.db));

        if (sv_table and sv_table[key] ~= nil) then
            value = sv_table[key]; -- first check saved variable table

        elseif (default_table and default_table[key] ~= nil) then
            value = default_table[key]; -- then check defaults table

        elseif (data.parent) then
            value = private:GetNextParentValue(data, key); -- finally check parent observer

            if (value and type(value) == "table") then
                local parent_data = rawget(value, "_data");
                parent_data.child = self; -- required for __newindex to map correctly
                parent_data.secure_call = nil;

            end

            return value;
        end

        if (type(value) == "table") then
            local newObserver = Observer:new(data, newpath);

            info.observers = info.observers or {};
            info.observers[storageKey] = {item = newObserver, counter = 5, IsObserver = true};
            private:RunCleaner(info);

            return newObserver;
        end

        return value;
    end,

    -- if the value is the same as an existing defaults value then if it exists in sv_table, set it to nil.
    __newindex = function(self, key, value)
        local data = rawget(self, "_data");
        local info = private:GetDatabaseInfo(data.db);

        if (data.child) then -- switched to parent

            local child_data = rawget(data.child, "_data");

            if (child_data.path) then

                local parent = data.child:GetParent();
                local child_keys = private:GetWrapper(strsplit(".", child_data.path));
                local parent_keys = private:GetWrapper(strsplit(".", data.path));
                local path = data.tbl_type..".";

                for i = 1, #parent_keys do
                    if (i <= #child_keys) then
                        path = path..child_keys[i];
                    else
                        path = path..parent_keys[i];
                    end
                    if (i < #parent_keys) then
                        path = path..".";
                    end
                end

                child_keys:Close();
                parent_keys:Close();

                data.child:SetParent(nil);
                db:SetPathValue(path.."."..key, value);
                data.child:SetParent(parent);

                return;
            end
        end

        local default_table = db:ParsePathValue(data.path, info.defaults[data.tbl_type]);
        local sv_table = db:ParsePathValue(data.path, private:GetSVTable(data.tbl_type, data.db));

        if (default_table and default_table[key] ~= nil and default_table[key] == value) then
            if (sv_table) then
                sv_table[key] = nil;  -- remove it if it exists!
                if (private:GetTableSize(sv_table) == 0) then
                    self:Remove();
                end
            end
        else
            local tbl = private:GetSVTable(data.tbl_type, data.db);
            if (data.path) then
                local rebuilt;
                for _, key in private:IterateArgs(strsplit(".", data.path)) do -- path could be "theme.color.r"
                    key = tonumber(key) or key;
                    if (not tbl[key]) then
                        tbl[key] = {};
                        rebuilt = true;
                    end
                    tbl = tbl[key];
                end
                if (rebuilt) then
                    sv_table = db:ParsePathValue(data.path, private:GetSVTable(data.tbl_type, data.db));
                end
            end
            rawset(tbl, key, value); -- set value here
            if (private:GetTableSize(sv_table) == 0) then
                self:Remove();
            end
        end
    end,
    __tostring = function(self)
        local data = rawget(self, "_data");
        return "Observer: "..tostring(data.tbl_type)..(data.path and ("."..data.path) or "");
    end
};

--[[
Create a new Observer to monitor a path address within the database.
An Observer can be thought of as a node within the database tree of tables.

@param (string) tbl_type: Can either be "profile" or "global".
@param (table) db: The database object.
@param (table) data: Previous data from a predecessor Observer.
--]]
function Observer:new(data, path)
    local dataCopy = {};
    if (type(data) == "table") then
        for key, value in pairs(data) do
            dataCopy[key] = value;
        end
    end

    dataCopy.root_parent = nil;
    dataCopy.path = path or (data and data.path);

    if (dataCopy.from_parent_path) then
        local from_parent_path = {};

        for id, value in ipairs(dataCopy.from_parent_path) do
            from_parent_path[id] = value;
        end

        dataCopy.from_parent_path = from_parent_path;
    end

    return setmetatable({
        _data = dataCopy
    }, self.metatable);
end

-----------------------
-- Private functions
-----------------------
--[[
If the profile name already exists, appends a number in parenthesis to create a unique name.

@param (string) name: The old profile name.
@param (table) sv: Saved variable table.
@return (string): The new profile name (or the same name if it is already unique).
--]]
function private:GetNewProfileName(name, sv)
    if (sv.profiles[name]) then
        local new_name = name;
        local n = 2;
        while (sv.profiles[new_name]) do
            new_name = name.." ("..n..")";
            n = n + 1;
        end
        name = new_name;
    end
    return name;
end

--[[
Is activated automatically during the ADDON_LOADED event.

@param (table) db: The database.
--]]
function private:StartDatabase(db)
    local info = self:GetDatabaseInfo(db);
    if (info.loaded) then return; end

    _G[db.sv_name] = _G[db.sv_name] or {};

    db.sv_table = _G[db.sv_name] or {};
    db.sv_name = nil;
    db.sv_table.profile_keys = db.sv_table.profile_keys or {};
    db.sv_table.profiles = db.sv_table.profiles or {};
    db.sv_table.profiles.Default = db.sv_table.profiles.Default or {};
    db.sv_table.global = db.sv_table.global or {};

    info.defaults = info.defaults or {};
    info.defaults.global = info.defaults.global or {};
    info.defaults.profile = info.defaults.profile or {};
    info.observers = {};

    db.global = Observer:new({tbl_type = "global", db = db});
    db.profile = Observer:new({tbl_type = "profile", db = db});
    info.loaded = true;

    if (info.OnStart) then
        info.OnStart(db);
        info.OnStart = nil;
    end
end

--[[
Gets the correct top-level table (global or the currently in use profile table)
from the database stored in the saved variable.

@param (string) table_type: Should either be set to "global" or "profile".
If "profile", then the character's current profile table is returned.
@param (table) db: The database object.
@return (table): The correct database table stored inside the saved variable table. 
--]]
function private:GetSVTable(table_type, db)
    local info = private:GetDatabaseInfo(db);
    local sv_table = db.sv_table[table_type];

    if (table_type == "profile") then
        sv_table = db.sv_table.profiles;
        local profile = db:GetCurrentProfile();

        sv_table[profile] = sv_table[profile] or {};
        sv_table = sv_table[profile];
    end

    return sv_table;
end

--[[
If an Observer cannot find the requested value and is parented to another Observer,
the parent is used instead. The parent Observer is then queried using the same key.

@param (table) data: The data of the child Observer.
@param (string) next_key: The key being used in the query.
@return (any): Either returns the next Oberserver or a value if search is finished.
--]]
function private:GetNextParentValue(data, key)
    local parent_data = rawget(data.parent, "_data");
    local path = string.format("%s.%s", parent_data.tbl_type, parent_data.path);

    for i = 1, #data.from_parent_path do
        path = string.format("%s.%s", path, data.from_parent_path[i]);
    end

    if (DEBUG) then
        print(path);
    end

    local observer = data.db:ParsePathValue(path, nil, true);
    if (not observer) then return nil; end
    return observer[key];
end

--[[
A helper function used to print tables. Used with Observer:Print() and db:PrintDefaults()

@param (table) tbl: The table to print.
@param (optional | int) depth: The depth of the table to print (tables within tables add
to increased depth).
@param (optional | int) n: Do NOT use manually. Used to control tabulation when printing.
--]]
function private:PrintTable(tbl, depth, n)
    if (type(tbl) ~= "table") then return; end

    n = n or 0;
    depth = depth or 4;

    if (depth == 0) then return; end
    if (n == 0) then
        print(" ");
    end

    for key, value in pairs(tbl) do
        if (key and type(key) == "number" or type(key) == "string") then
            key = "[\""..key.."\"]";

            if (type(value) == "table") then
                print(string.rep(' ', n)..key.." = {");
                self:PrintTable(value, depth - 1, n + 4);
                print(string.rep(' ', n).."}");

            else
                print(string.rep(' ', n)..key.." = "..tostring(value));
            end
        end
    end

    if (n == 0) then print(" "); end
end

do
    local wrappers = {};

    local function iter(wrapper, id)
        id = id + 1;
        local arg = wrapper[id];
        if (arg) then
            return id, arg;
        else
            table.insert(wrappers, wrapper);
        end
    end

    --[[
    Used to iterate through a random list of variables using a recyclable wrapper table. 
    Better memory performance when using anonymous tables:
        * old method: for i, v in ipairs({strsplit(' ', str)}) do ... end
        * new method: for i, v in private:IterateArgs(strsplit(' ', str)) do ... end
    --]]
    function private:IterateArgs(...)
        local wrapper;
        if (#wrappers > 0) then
            wrapper = wrappers[#wrappers];
            wrappers[#wrappers] = nil;
        else
            wrapper = {};
        end

        private:EmptyTable(wrapper);

        local id = 1;
        local arg = (select(id, ...));

        repeat
            wrapper[id] = arg;
            id = id + 1;
            arg = (select(id, ...));
        until (not arg);

        return iter, wrapper, 0;
    end
end

do
    local wrappers = {};
    local parent = {};
    local mt = {__index = parent};

    --[[ 
    Destroys all values stored inside the wrapper and recycles the wrapper table.
    --]]
    function parent:Close()
        for _, wrapper in pairs(self) do
            if (type(wrapper) == "table" and wrapper.Close) then
                wrapper:Close();
            end
        end

        private:EmptyTable(self);
        wrappers[#wrappers + 1] = self;
    end

    --[[
    Used to save on addon memory when using Observers.

    @param (vararg): Any values to be stored inside the wrapper (for convenience sake).
    @return: A wrapper used as a recyclable table to store values.
    --]]
    function private:GetWrapper(...)
        local wrapper;

        if (#wrappers > 0) then
            wrapper = wrappers[#wrappers];
            private:EmptyTable(wrapper);
            wrappers[#wrappers] = nil;

        else
            wrapper = setmetatable({...}, mt);
        end
        return wrapper;
    end
end

--[[
Standard merging function used to merge together 2 or more tables. Changing values in the merged 
table will not affect the original values (uses deep-cloning).

@param (vararg): A list of tables to merge.
@return (table): A new table containing cloned values from all tables.
--]]
function private:GetTable(...)
    local merged = {};

    for _, tbl in self:IterateArgs(...) do
        for key, value in pairs(tbl) do
            if (merged[key] and (type(merged[key]) == "table") and (type(value) == "table")) then
                merged[key] = self:GetTable(merged[key], value);
            else
                merged[key] = value;
            end
        end
    end

    return merged;
end

--[[ 
Removes every element found in the supplied table.
--]]
function private:EmptyTable(tbl)
    for key, _ in pairs(tbl) do tbl[key] = nil; end
end

--[[ 
Returns the size of the supplied table.
--]]
function private:GetTableSize(tbl)
    local size = 0;
    for _, _ in pairs(tbl) do
        size = size + 1;
    end
    return size;
end

do
    local function Next(tbl, key)
        local previous = tbl;
        if (tbl[key] == nil) then
            tbl[key] = {};
        end
        return previous, tbl[key];
    end

    --[[
    @param (string) path: The path address used to identify a value inside the database.
    Can include square brackets and numbers: "db.profile.aModule['a value'][5]".
    Unlike ParsePathValue, this will create new tables in the path if they do not exist!
    @param (optional | table) root: The root table to search through. Default is db.
    @return: the last table and key pair from the path address.
    --]]
    function private:GetLastTableKeyPairs(path, root)
        local new_tbl = root;
        local previous_tbl, last_key;

        for _, key in private:IterateArgs(strsplit(".", path)) do
            if (tonumber(key)) then
                key = tonumber(key);
                last_key = key;
                previous_tbl, new_tbl = Next(new_tbl, key);

            elseif (key ~= "db") then
                local indexes;
                if (key:find("%b[]")) then
                    indexes = {};
                    for index in key:gmatch("(%b[])") do
                        index = index:match("%[(.+)%]");
                        table.insert(indexes, index);
                    end
                end

                key = strsplit("[", key);

                if (#key > 0) then
                    last_key = key;
                    previous_tbl, new_tbl = Next(new_tbl, key);
                end

                if (indexes) then
                    for _, key in ipairs(indexes) do
                        key = tonumber(key) or key;
                        last_key = key;
                        previous_tbl, new_tbl = Next(new_tbl, key);
                    end
                end
            end
        end

        return previous_tbl, last_key;
    end
end

--[[
@param (table) db: The database object.
@return (table): The database info (meta data).
--]]
function private:GetDatabaseInfo(db)
    return self.db_info[tostring(db)];
end

--[[
Destroys unused Observers and save memory over time.
Will repeat if it detects active observers in storage.

@param (table) info: The database info (meta data) (use private:GetDatabaseInfo(db)).
--]]
function private:RunCleaner(info)
    if (private:GetTableSize(info.observers) == 0 or info.isCleaning) then return; end

    info.isCleaning = true;

    local function Clean()
        for key, data in pairs(info.observers) do
            local isRootParent = rawget(data.item, "_data").root_parent;
            if (not (data.IsObserver and isRootParent)) then
                if (data.counter == 1) then
                    info.observers[key] = nil;
                else
                    data.counter = data.counter - 1;
                end
            end
        end

        if (private:GetTableSize(info.observers) == 0) then
            info.isCleaning = nil;
            info.observers = nil;
        else
            C_Timer.After(5, Clean);
        end
    end
    C_Timer.After(5, Clean);
end