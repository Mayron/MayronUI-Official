-- luacheck: ignore MayronUI self 143 631

---@type LibMayronDB
local Lib = _G.LibStub:NewLibrary("LibMayronDB", 2.3);

---@type LibMayronObjects
local obj = _G.LibStub:GetLibrary("LibMayronObjects");

if (not Lib or not obj) then return; end

---@class Framework : Package
local Framework = obj:CreatePackage("LibMayronDB");

---@class Database : Object
local Database = Framework:CreateClass("Database");

---@class Observer : Object
local Observer = Framework:CreateClass("Observer");

---@class Helper : Object
local Helper = Framework:CreateClass("Helper");

Observer.Static:AddFriendClass("Helper");
Observer.Static:AddFriendClass("Database");

local select, tonumber, strsplit = _G.select, _G.tonumber, _G.strsplit;
local GetLastTableKeyPairs, GetNextPath, IsEqual, GetDatabasePathInfo;

local OnAddOnLoadedListener = _G.CreateFrame("Frame");
OnAddOnLoadedListener:RegisterEvent("ADDON_LOADED");
OnAddOnLoadedListener.RegisteredDatabases = obj:PopTable();

OnAddOnLoadedListener:SetScript("OnEvent", function(self, _, addOnName)
    local database = OnAddOnLoadedListener.RegisteredDatabases[addOnName];

    if (database) then
        database:Start();
    end
end);

------------------------
-- Database API
------------------------

---Creates the database but does not initialize it until after "ADDON_LOADED" event (unless manualStartUp is set to true).
---@param addOnName string @The name of the addon to listen out for. If supplied it will start the database
---    automatically after the ADDON_LOADED event has fired (when the saved variable becomes accessible).
---@param savedVariableName string @The name of the saved variable to hold the database (defined in the toc file).
---@param manualStartUp boolean @(optional) Set to true if you do not want the library to automatically start
---    the database when the saved variable becomes accessible.
---@return Database @The database object.
function Lib:CreateDatabase(addOnName, savedVariableName, manualStartUp)
    local database = Database(addOnName, savedVariableName);

    if (not manualStartUp and _G[savedVariableName]) then
        -- already loaded
        database:Start();
    end

    OnAddOnLoadedListener.RegisteredDatabases[addOnName] = database;

    return database;
end

---@return Database @The database object
function Lib:GetDatabase(addOnName)
    return OnAddOnLoadedListener.RegisteredDatabases[addOnName];
end

---Returns addOnName, db (the database object) for each registered database per iteration.
function Lib:IterateDatabases()
    local id = 0;
    local databases = obj:PopTable();

    for name, database in pairs(OnAddOnLoadedListener.RegisteredDatabases) do
        local value = obj:PopTable(name, database);
        table.insert(databases, value);
    end

    return function()
        id = id + 1;

        if (id <= #databases) then
            local name, database = _G.unpack(databases[id]);
            obj:PushTable(databases[id]);

            if (id == #databases) then
                obj:PushTable(databases);
            end

            return name, database;
        end
    end
end

function Lib:SetPathValue(rootTable, path, value)
    obj:Assert(obj:IsTable(rootTable), "Failed to find root-table for path '%s'.", path);
    obj:Assert(obj:IsString(path), "Invalid path address.");
    obj:Assert(not obj:IsObject(rootTable, "Observer"), "Table required, found Observer");

    local lastTable, lastKey = GetLastTableKeyPairs(rootTable, path);

    assert(obj:IsTable(lastTable) and
        (obj:IsString(lastKey) or obj:IsNumber(lastKey)), "Lib:SetPathValue failed to set value");

    -- set value here!
    lastTable[lastKey] = value;
end

function Lib:ParsePathValue(rootTable, path)
    local values = obj:PopTable(_G.strsplit(".", path));
    local length = #values;
    local iterations = 0;

    for _, key in ipairs(values) do
        if (rootTable == nil or not obj:IsTable(rootTable)) then
            break;
        end

        if (tonumber(key)) then
            key = tonumber(key);
            rootTable = rootTable[key];
            iterations = iterations + 1;
        else
            local indexes;

            if (key:find("%b[]")) then
                indexes = {};

                for index in key:gmatch("(%b[])") do
                    index = index:match("%[(.+)%]");
                    table.insert(indexes, index);
                end

                length = length + #indexes;
            end

            key = _G.strsplit("[", key);

            if (#key > 0) then
                rootTable = rootTable[key];
                iterations = iterations + 1;
            end

            if (indexes and obj:IsTable(rootTable)) then
                for _, indexKey in ipairs(indexes) do
                    indexKey = tonumber(indexKey) or indexKey;
                    rootTable = rootTable[indexKey];
                    iterations = iterations + 1;

                    if (rootTable == nil or not obj:IsTable(rootTable)) then
                        break;
                    end
                end
            end
        end
    end

    if (iterations == length) then
        return rootTable;
    end

    return nil;
end

-- Database Object: ------------------

Framework:DefineParams("string", "string");
---Do NOT call this manually! Should only be called by Lib:CreateDatabase(...)
function Database:__Construct(data, addOnName, savedVariableName)
    data.addOnName = addOnName;
    data.svName = savedVariableName;
    data.callbacks = obj:PopTable();
    data.helper = Helper(self, data);
    -- holds all database defaults to check first before searching database
    data.defaults = obj:PopTable();
    data.updateFunctions = obj:PopTable();
    data.manualUpdateFunctions = obj:PopTable();
    data.defaults.global = obj:PopTable();
    data.defaults.profile = obj:PopTable();
end

function Database:__Destruct()
    obj:Error("Database cannot be destroyed");
end

Framework:DefineReturns("string");
---@return string @The name of the database (the addon name + saved variable name)
function Database:GetDatabaseName(data)
    return string.format("%s:%s", data.addOnName, data.svName);
end

Framework:DefineParams("function");
---Hooks a callback function onto the "StartUp" event to be called when the database starts up
---(i.e. when the saved variable becomes accessible). By default, this function is called by the library
---with 2 arguments: the database and the addOn name passed to Lib:CreateDatabase(...).
---@param callback function @The start up callback function
function Database:OnStartUp(data, callback)
    local startUpCallbacks = data.callbacks["OnStartUp"] or obj:PopTable();
    data.callbacks.OnStartUp = startUpCallbacks;

    table.insert(startUpCallbacks, callback);
end

Framework:DefineParams("function");
---Hooks a callback function onto the "ProfileChanged" event to be called when the database changes profile
---(i.e. only changed by the user using db:SetProfile() or db:RemoveProfile(currentProfile)).
---@param callback function @The profile changing callback function
function Database:OnProfileChange(data, callback)
    local profileChangedCallback = data.callbacks["OnProfileChange"] or obj:PopTable();
    data.callbacks["OnProfileChange"] = profileChangedCallback;

    table.insert(profileChangedCallback, callback);
end

---Starts the database. Should only be used when the saved variable is accessible (after the ADDON_LOADED event has fired).
---This is called automatically by the library when the saved variable becomes accessible unless manualStartUp was
---set to true during the call to Lib:CreateDatabase(...).
function Database:Start(data)
    if (data.loaded) then
        -- previously started and loaded
        return;
    end

    -- create Saved Variable if it has never been created before
    _G[data.svName] = _G[data.svName] or obj:PopTable();
    data.sv = _G[data.svName];

    -- create root profiles table if it does not exist
    data.sv.profiles = data.sv.profiles or obj:PopTable();

    -- create root global table if it does not exist
    data.sv.global = data.sv.global or obj:PopTable();

    -- create profileKeys table if it does not exist
    data.sv.profileKeys = data.sv.profileKeys or obj:PopTable();

    -- create appended table if it does not exist
    data.sv.appended = data.sv.appended or obj:PopTable();

    -- create Default profile if it does not exist
    data.sv.profiles.Default = data.sv.profiles.Default or obj:PopTable();

    -- create Profile and Global accessible observers:
    self.profile = Observer(false, data);
    self.global = Observer(true, data);

    Framework:ProtectProperty(self, "profile");
    Framework:ProtectProperty(self, "global");

    data.loaded = true;

    if (data.callbacks.OnStartUp) then
        for _, callback in ipairs(data.callbacks.OnStartUp) do
            callback(self, data.addOnName);
        end
    end

    data.callbacks.OnStartUp = nil;
end

Framework:DefineReturns("boolean");
---Returns true if the database has been successfully started and loaded.
---@return boolean @indicates if the database is loaded.
function Database:IsLoaded(data)
    return data.loaded == true;
end

Framework:DefineParams("string", "any");
---Adds a value to the database defaults table relative to the path: defaults.<path> = <value>
---@param path string @A database path string, such as "myTable.mySubTable[2]"
---@param value any @A value to assign to the database defaults table using the path
function Database:AddToDefaults(data, path, value)
    self:SetPathValue(data.defaults, path, value);
end

Framework:DefineParams("string", "table|function", "?function");
---Add a table of update callback functions to trigger when a database value changes
---@param path string @A database path string, such as "myTable.mySubTable[2]".
---@param updateFunctions table|function @A table containing functions, or a function, to attach to a database path.
---@param manualFunc function @When TriggerUpdateFunction is called, the manualFunc will be called and is passed the update function to allow the user to decide how it should be called.
function Database:RegisterUpdateFunctions(data, path, updateFunctions, manualFunc)
    self:SetPathValue(data.updateFunctions, path, updateFunctions);
    data.manualUpdateFunctions[path] = manualFunc;
end

Framework:DefineParams("string");
Framework:DefineReturns("table|function");
---Add a table of update callback functions to trigger when a database value changes
---@param path string @A database path string, such as "myTable.mySubTable[2]".
---@return table|function @A table containing update functions, or a single update function, associated with the database path.
function Database:GetUpdateFunctions(data, path)
    return self:ParsePathValue(data.updateFunctions, path);
end

Framework:DefineParams("string");
---Triggers an update function located by the path argument and pass any arguments to the function
---@param fullPath string @A database path string, such as "profile.myTable.mySubTable[2]" (includes root path).
    --- This is needed to locate the updateFunction
---@param newValue any @(optional) The new value assigned to the database.
function Database:TriggerUpdateFunction(data, fullPath, newValue)
    local updateFunction = self:ParsePathValue(data.updateFunctions, fullPath);
    local manualFunction;

    -- used in while-loops for iteration only:
    local updateFunctionPath = fullPath;
    local pathOfValue = fullPath; -- used only in the while-loop
    local manualFunctionPath = fullPath;

    while (not obj:IsFunction(updateFunction) and pathOfValue:find("[.[]")) do
        -- cut off the last key (traverse table backwards to find update function)
        updateFunctionPath = updateFunctionPath:match('(.+)[.[]');
        pathOfValue = pathOfValue:match('(.+)[.[]');

        updateFunction = self:ParsePathValue(data.updateFunctions, updateFunctionPath);
    end

    while (not obj:IsFunction(manualFunction)) do
        manualFunction = data.manualUpdateFunctions[manualFunctionPath];

        if (manualFunctionPath:find("[.[]")) then
            manualFunctionPath = manualFunctionPath:match('(.+)[.[]');
        else
            break;
        end
    end

    if (obj:IsFunction(manualFunction)) then
        if (obj:IsFunction(updateFunction)) then
            -- could not find an update function
            manualFunction(updateFunction, fullPath, newValue);
        else
            manualFunction(nil, fullPath, newValue);
        end

    elseif (obj:IsFunction(updateFunction)) then
        updateFunction(newValue, fullPath);
    end
end

Framework:DefineParams("table|string");
---Adds a value to a table relative to a path: rootTable.<path> = <value>
---@param rootTableOrPath table|string @The initial root table to search from OR a string that starts with "global" or "profile" so that the rootTable can be calculated.
---@param pathOrValue any @(optional) A table path string (also called a path address), such as "myTable.mySubTable[2]", or if rootTable is a string representing the path then this is the value argument. If it is the path then this is converted to a sequence of tables which are added to the database if they do not already exist (myTable will be created if not found).
---@param value any @(optional) A value to assign to the table relative to the provided path string (is nil if the path argument is the value)
function Database:SetPathValue(data, rootTableOrPath, pathOrValue, value)
    local rootTable, path, realValue = GetDatabasePathInfo(self, rootTableOrPath, pathOrValue, value);

    obj:Assert(obj:IsTable(rootTable), "Failed to find root-table for path '%s'.", path);
    obj:Assert(path and not (obj:IsObject(rootTable, "Observer") and path:find("__template")), "Invalid path address '%s'.", path);

    local lastTable, lastKey = GetLastTableKeyPairs(rootTable, path);

    assert(obj:IsTable(lastTable) and (obj:IsString(lastKey) or obj:IsNumber(lastKey)),
        "Database:SetPathValue failed to set value");

    -- set value here!
    if (lastTable.IsObjectType and lastTable:IsObjectType("Observer")) then
        local observerData = data:GetFriendData(lastTable);
        data.helper:HandlePathValueChange(observerData, lastKey, realValue);
    else
        lastTable[lastKey] = realValue;
    end
end

Framework:DefineParams("table|string", "?string");
---Searches a path address (table path string) and returns the located value if found. Example: value = db:ParsePathValue(db.profile, "mySettings[" .. moduleName .. "][5]");
---@param rootTableOrPath table|string @The root table to begin searching through using the path address. OR a string that starts with "global" or "profile" so that the rootTable can be calculated.
---@param pathOrNil string|nil @(optional) The path of the value to search for(example: "myTable.mySubTable[2]"), or if rootTableOrPath is a string representing the path then this is nil.
---@return any @The value found at the location specified by the path address. Might return nil if the path address is invalid, or no value is located at the address.
function Database:ParsePathValue(_, rootTableOrPath, pathOrNil)
    local rootTable, path = GetDatabasePathInfo(self, rootTableOrPath, pathOrNil);
    return Lib:ParsePathValue(rootTable, path);
end

Framework:DefineParams("string");
---Sets the addon profile for the currently logged in character. Creates a new profile if the named profile does not exist.
---@param profileName string @The name of the profile to assign to the character.
function Database:SetProfile(data, profileName)
    if (self:GetCurrentProfile() == profileName) then
        return;
    end

    local profile = data.sv.profiles[profileName] or obj:PopTable();
    data.sv.profiles[profileName] = profile;

    local profileKey = data.helper:GetCurrentProfileKey();
    local oldProfileName = data.sv.profileKeys[profileKey] or "Default";

    data.sv.profileKeys[profileKey] = profileName;

    if (data.callbacks.OnProfileChange) then
        for _, callback in ipairs(data.callbacks.OnProfileChange) do
            callback(self, profileName, oldProfileName);
        end
    end
end

Framework:DefineReturns("string");
---@return string @The current profile associated with the currently logged in character.
function Database:GetCurrentProfile(data)
    local profileKey = data.helper:GetCurrentProfileKey();
    return data.sv.profileKeys[profileKey] or "Default";
end

Framework:DefineReturns("table");
---@return table @A table containing string profile names for all profiles associated with the addon.
function Database:GetProfiles(data)
    local profiles = obj:PopTable();

    for profileName, _ in pairs(data.sv.profiles) do
        table.insert(profiles, profileName);
    end

    return profiles;
end

Framework:DefineParams("string");
Framework:DefineReturns("boolean");
---@param profileName string @The name of the profile to check.
---@return boolean @Returns true if the profile exists
function Database:ProfileExists(data, profileName)
    return data.sv.profiles[profileName] ~= nil;
end

---Usable in a for loop to loop through all profiles associated with the AddOn.
---@return function @An iterable function that returns a number (the current loop id), a profile name, and a table containing the profile data
function Database:IterateProfiles(data)
    local id = 0;
    local profileNames = obj:PopTable();

    for name, _ in pairs(data.sv.profiles) do
        table.insert(profileNames, name);
    end

    return function()
        id = id + 1;

        if (id <= #profileNames) then
            local profileName = profileNames[id];
            local profileObject = data.sv.profiles[profileName];

            if (id == #profileNames) then
                obj:PushTable(profileNames);
            end

            return id, profileName, profileObject;
        end
    end
end

---@return int @The number of profiles associated with the database.
Framework:DefineReturns("number");
function Database:GetNumProfiles(data)
    local n = 0;

    for _ in pairs(data.sv.profiles) do
        n = n + 1;
    end

    return n;
end

Framework:DefineParams("string");
---Helper function to reset a profile.
---@param profileName string @The name of the profile to reset.
function Database:ResetProfile(_, profileName)
    self:RemoveProfile(profileName);
    self:SetProfile(profileName);
end

Framework:DefineParams("string");
---Helper function to reset a profile.
---@param profileName string @The name of the profile to reset.
function Database:CopyProfile(data, profileName, copiedProfileName)
    if (profileName == copiedProfileName) then
        return;
    end

    if (data.sv.profiles[profileName] and data.sv.profiles[copiedProfileName]) then
        data.bin = data.bin or {};
        data.bin[profileName] = data.sv.profiles[profileName];
        data.sv.profiles[profileName] = data.sv.profiles[copiedProfileName];
        self:SetProfile(profileName);
    end
end

Framework:DefineParams("string");
Framework:DefineReturns("boolean");
---Moves the profile to the bin. The profile cannot be accessed from the bin. Use db:RestoreProfile(profileName) to restore the profile.
---@param profileName string @The name of the profile to move to the bin.
---@return boolean @Returns true if the profile was changed due to removing the current profile.
function Database:RemoveProfile(data, profileName)
     if (data.sv.profiles[profileName]) then

        data.bin = data.bin or {};
        data.bin[profileName] = data.sv.profiles[profileName];
        data.sv.profiles[profileName] = nil;

        if (self:GetCurrentProfile() == profileName) then
            self:SetProfile("Default");
            return true;
        end
    end

    return false;
end

Framework:DefineParams("string");
Framework:DefineReturns("boolean");
---Profiles will remain in the bin until a reload of the UI occurs. If the bin contains a profile, this function can restore it.
---@param profileName string @The name of the profile located inside the bin.
function Database:RestoreProfile(data, profileName)
    if (data.bin) then
        local profile = data.bin[profileName];

        if (profile) then
            profileName = data.helper:GetNewProfileName(profileName, data.sv.profiles);
            data.sv.profiles[profileName] = profile;
            data.bin[profileName] = nil;

            return true;
        end
    end

    return false;
end

Framework:DefineReturns("table");
---Gets all profiles that can be restored from the bin.
---@return table @An index table containing the names of all profiles in the bin.
function Database:GetProfilesInBin(data)
    local profilesInBin = {};

    if (data.bin) then
        for profileName, _ in pairs(data.bin) do
            table.insert(profilesInBin, profileName);
        end
    end

    return profilesInBin;
end

Framework:DefineParams("string", "string");
---Renames an existing profile to a new profile name. If the new name already exists, it appends a number
---to avoid clashing: 'example (2)'.
---@param oldProfileName string @The old profile name.
---@param newProfileName string @The new profile name.
function Database:RenameProfile(data, oldProfileName, newProfileName)
    newProfileName = data.helper:GetNewProfileName(newProfileName, data.sv.profiles);
    local profile = data.sv.profiles[oldProfileName];

    data.sv.profiles[oldProfileName] = nil;
    data.sv.profiles[newProfileName] = profile;

    local currentProfileKey = data.helper:GetCurrentProfileKey();

    for profileKey, profileName in pairs(data.sv.profileKeys) do
        if (profileName == oldProfileName) then
            data.sv.profileKeys[profileKey] = newProfileName;

            if (profileKey == currentProfileKey) then
                if (data.callbacks["OnProfileChange"]) then
                    for _, value in ipairs(data.callbacks["OnProfileChange"]) do
                        local callback = value[1];
                        callback(newProfileName, select(2, _G.unpack(value)));
                    end
                end
            end
        end
    end
end

Framework:DefineParams("Observer", "?string", "?string", "table");
Framework:DefineReturns("boolean");
---Adds a new value to the saved variable table only once. Adds to a special appended history table.
---@param rootTable Observer @The root database table (observer) to append the value to relative to the path address provided.
---@param path string @(Optional) The path address to specify where the value should be appended to.
---@param appendKey string @(Optional) An optional key that can be used instead of the path for registering an appended value.
---@param value table @The table of values to be appended to the database.
---@return boolean @Returns whether the value was successfully added.
function Database:AppendOnce(data, rootObserver, path, appendKey, value)
    local tableType = data.helper:GetDatabaseRootTableName(rootObserver);

    local appendTable = data.sv.appended[tableType] or obj:PopTable();
    data.sv.appended[tableType] = appendTable;

    appendKey = appendKey or path;
    obj:Assert(appendKey, "Both path and appendKey args cannot be missing (at least one is required)");

    if (appendTable[appendKey]) then
        -- already previously appended, cannot append again
        if (obj:IsTable(value)) then
            obj:PushTable(value, true);
        end

        return false;
    end

    local sv = rootObserver:GetSavedVariable();

    if (path) then
        self:SetPathValue(sv, path, value);

    elseif (obj:IsTable(value)) then
        for k, v in pairs(value) do
            self:SetPathValue(sv, k, v);
        end
    else
        obj:Error("Injecting a non-table value requires the path argument");
    end

    appendTable[appendKey] = true;
    return true;
end

Framework:DefineParams("Observer", "string");
Framework:DefineReturns("boolean");
---Removes the appended history.
---@param rootTable Observer @The root database table (observer) to append the value to relative to the path address provided.
---@param path string @The path address to specify where the value should be appended to.
---@return boolean @Returns whether the value was successfully added.
function Database:RemoveAppended(data, rootTable, path)
    local tableType = data.helper:GetDatabaseRootTableName(rootTable);

    local appendTable = data.sv.appended[tableType] or obj:PopTable();
    data.sv.appended[tableType] = appendTable;

    if (not appendTable[path]) then
        return false;
    end

    self:SetPathValue(rootTable, path, nil);
    appendTable[path] = nil;

    return true;
end

-------------------------
-- Observer Class:
-------------------------

Framework:DefineParams("boolean", "table");
---Do NOT call this manually! Should only be called by the library to create a new observer that controls a database table.
---@param isGlobal boolean @If true, the observer is associated with a global database path address.
---@param previousData table @the previous observer data.
function Observer:__Construct(data, isGlobal, previousData)
    data.isGlobal = isGlobal;
    data.helper = previousData.helper;
    data.sv = previousData.sv;
    data.defaults = previousData.defaults;
    data.internalTree = obj:PopTable();
    data.database = data.helper:GetDatabase();
end

---When a new value is being added to the database, use the child observer's table if switched to using a parent observer. Also, add to the saved variable table if not a function.
Observer.Static:OnIndexChanging(function(_, data, key, value)
    data.helper:HandlePathValueChange(data, key, value);
    return true; -- prevent indexing
end);

---Pick from Observer's saved variable table, else parent table if not found, else defaults table.
Observer.Static:OnIndexed(function(self, data, key, realValue)
    if (realValue ~= nil) then
        return realValue; -- it is an observer object value
    end

    local foundValue;
    local svTable = self:GetSavedVariable();

    if (svTable) then
        -- convert saved variable table into an Observer
        foundValue = data.helper:GetNextValue(data, svTable, key);
    end

    -- check parent if still not found
    if (foundValue == nil) then
        if (data.parent) then
            local parentSvTable = data.parent:GetSavedVariable();

            if (parentSvTable ~= nil) then
                local parentData = data:GetFriendData(data.parent);

                data.helper:SetUsingChild(data.isGlobal, data.path, data.parent);
                -- it is possible to not have a svTable (might be dependent on defaults table)
                foundValue = data.helper:GetNextValue(parentData, parentSvTable, key);
            end
        end
    end

    -- check own defaults table if still not found
    if (foundValue == nil) then
        local defaults = self:GetDefaults();

        if (defaults) then
            foundValue = data.helper:GetNextValue(data, defaults, key);
        end
    end

    if (foundValue == nil and data.parent) then
        -- check parent's defaults table before own defaults table
        local defaults = data.parent:GetDefaults();

        if (defaults ~= nil) then
            local parentData = data:GetFriendData(data.parent);
            data.helper:SetUsingChild(data.isGlobal, data.path, data.parent);
            foundValue = data.helper:GetNextValue(parentData, defaults, key);
        end
    end

    return foundValue;
end);

Framework:DefineParams("?Observer");
---Used to achieve database inheritance. If an observer cannot find a value, it uses the value
---found in the parent table. Useful if many separate tables in the saved variables table should
---use the same set of changable values when the defaults table is not a suitable solution.
---@param parentObserver Observer @(optional) Which observer should be used as the parent. If this is nil, the parent is removed (example: db.profile.aFrame:SetParent(db.global.frameTemplate)).
function Observer:SetParent(data, parentObserver)
    data.parent = parentObserver;
end

Framework:DefineReturns("?Observer");
---@return Observer @Returns the current Observer's parent.
function Observer:GetParent(data)
    return data.parent;
end

Framework:DefineReturns("boolean");
---@return boolean @Returns true if the current Observer has a parent.
function Observer:HasParent(data)
    return data.parent ~= nil;
end

Framework:DefineReturns("Database");
---@return boolean @Helper method to get database reference in case it is hard to access.
function Observer:GetDatabase(data)
    return data.database;
end

Framework:DefineReturns("?table");
---Gets the underlining saved variables table. Default and parent values will not be included in this!
---@return table @(possible nil) The underlining saved variables table.
function Observer:GetSavedVariable(data)
    local rootTable;

    if (data.isGlobal) then
        rootTable = data.sv.global;
    else
        local currentProfile = data.database:GetCurrentProfile();
        rootTable = data.sv.profiles[currentProfile];
    end

    if (data.path) then
        rootTable = data.database:ParsePathValue(rootTable, data.path);
    end

    return rootTable;
end

Framework:DefineReturns("?table");
---Gets the default database table associated with the observer. Real saved variable and parent values will not be included in this!
---@return table|nil @(possible nil) The default table attached to the database observer if one exists.
function Observer:GetDefaults(data)
    local rootTable;

    if (data.isGlobal) then
        rootTable = data.defaults.global;
    else
        rootTable = data.defaults.profile;
    end

    if (data.path) then
        return data.database:ParsePathValue(rootTable, data.path);
    end

    return rootTable;
end

---Usable in a for loop. Uses the merged table to iterate through key and value pairs of the default and
--- saved variable table paired together using the Observer path address.
function Observer:Iterate()
    local merged = self:GetUntrackedTable();
    return next, merged, nil;
end

Framework:DefineReturns("boolean");
---@return boolean @Whether the merged table is empty.
function Observer:IsEmpty()
    return self:GetLength() == 0;
end

Framework:DefineParams("?number");
---A helper function to print all contents of a table pointed to by the selected Observer (example: db.profile.aModule:Print()).
---@param depth number|nil @(optional) The depth of tables to print before only printing table references.
function Observer:Print(data, depth)
    local merged = self:GetUntrackedTable();
    local tablePath = data.helper:GetDatabaseRootTableName(self);
    local path = (data.usingChild and data.usingChild.path) or data.path;

    if (path ~= nil) then
        tablePath = string.format("%s.%s", tablePath, path);
    end

    print(" ");
    print(string.format("db.%s = {", tablePath));
    data.helper:PrintTable(merged, depth);
    print("};");
    print(" ");
end

Framework:DefineReturns("number");
---@return number @The length of the merged table (Observer:GetUntrackedTable()).
function Observer:GetLength()
    local length = 0;

    for _, _ in self:Iterate() do
        length = length + 1;
    end

    return length;
end

Framework:DefineParams("?boolean");
Framework:DefineReturns("?string");
---Helper function to return the path address of the observer.
---@param excludeTableType boolean @(optional) Excludes "global" or "profile" at the start of path address if true.
---@return string @The path address.
function Observer:GetPathAddress(data, excludeTableType)
    local path = data.path;

    if (not excludeTableType) then
        if (data.isGlobal) then
            if (path) then
                path = string.format("%s.%s", "global", path);
            else
                path = "global";
            end
        elseif (path) then
            path = string.format("%s.%s", "profile", path);
        else
            path = "profile";
        end
    end

    return path;
end

do
    -- local functions, ToTable
    local ConvertObserverToUntrackedTable, CreateTrackerFromTable;
    -- tracker methods
    local SaveChanges, Refresh, GetObserver, GetTotalPendingChanges, ResetChanges, GetUntrackedTable, Iterate;

    local _metaData = {};
    local tracker_MT = {};
    local BasicTableParent = {};
    local basicTable_MT = {__index = BasicTableParent};

    -- Local Functions:
    do
        -- Adds all key and value pairs from fromTable onto toTable (replaces other non-table values)
        local function AddTable(fromTable, toTable, doNotReplace)
            for key, value in pairs(fromTable) do
                if (obj:IsTable(value)) then
                    if (not (obj:IsString(key) and key:match("^__template"))) then

                        -- ignore template default values
                        if (not obj:IsTable(toTable[key])) then
                            toTable[key] = obj:PopTable();
                        end

                        AddTable(value, toTable[key], doNotReplace);
                    end
                elseif (not doNotReplace or (doNotReplace and toTable[key] == nil)) then
                    toTable[key] = value;
                end
            end
        end

        local function AddParentTables(observer, merged, isParent)
            if (not isParent) then
                for key, _ in pairs(merged) do
                    -- own child parents only...
                    local child = observer[key];

                    if (obj:IsType(child, "Observer") and obj:IsTable(merged[key])) then
                        -- avoid unnecessary table/tree scanning:
                        AddParentTables(child, merged[key]);
                    end
                end
            end

            local parent = observer:GetParent();
            -- parent might have been added before but it needs to be applied to different unrelated nodes.
            -- if the parent is also the parent of a child element contained inside itself
            -- then we need to check for this.
            if (parent) then
                local parentTable = ConvertObserverToUntrackedTable(parent, nil, true);

                if (parentTable) then
                    AddTable(parentTable, merged, true);
                end
            end
        end

        function ConvertObserverToUntrackedTable(observer, reusableTable, isParent)
            local merged = reusableTable or obj:PopTable();
            local svTable = observer:GetSavedVariable();
            local defaults = observer:GetDefaults();

            if (obj:IsTable(reusableTable)) then
                obj:EmptyTable(reusableTable);
                setmetatable(reusableTable, nil);
            end

            if (defaults) then
                AddTable(defaults, merged);
            end

            if (svTable) then
                AddTable(svTable, merged);
            end

            AddParentTables(observer, merged, isParent);

            return merged;
        end
    end

    function CreateTrackerFromTable(observer, tbl, previousTracker, nextPath)
        local tracker = obj:PopTable();

        -- available functions:
        tracker.SaveChanges = SaveChanges;
        tracker.ResetChanges = ResetChanges;
        tracker.Refresh = Refresh;
        tracker.GetTotalPendingChanges = GetTotalPendingChanges;
        tracker.Iterate = Iterate;
        tracker.GetUntrackedTable = GetUntrackedTable;
        tracker.GetObserver = GetObserver;

        -- set tracker data:
        local data = _metaData[tostring(tbl)] or obj:PopTable();
        _metaData[tostring(tracker)] = data;

        if (previousTracker) then
            local previousData = _metaData[tostring(previousTracker)];
            data.changes = previousData.changes;
            data.path = nextPath;
        else
            data.changes = obj:PopTable();
            data.path = nil;
        end

        data.tracker = setmetatable(tracker, tracker_MT);
        data.basicTable = tbl;
        data.observer = observer;

        return data.tracker;
    end

    -- Tracker Methods:

    -- apply all table changes and saves changes to the database
    function SaveChanges(tracker)
        local data = _metaData[tostring(tracker)];
        local observerPath = data.observer:GetPathAddress();
        local database = data.observer:GetDatabase();
        local totalChanges = 0;
        local fullPath;

        for path, value in pairs(data.changes) do
            if (value == "nil") then
                value = nil;
            end

            fullPath = string.format("%s.%s", observerPath, path);

            -- save change to real saved variable database
            database:SetPathValue(fullPath, value);

            -- save change to basic table
            database:SetPathValue(data.basicTable, path, value);

            totalChanges = totalChanges + 1;
        end

        obj:EmptyTable(data.changes);

        return totalChanges;
    end

    function Refresh(tracker)
        local data = _metaData[tostring(tracker)];
        local basicTable = ConvertObserverToUntrackedTable(data.observer, data.basicTable);
        setmetatable(basicTable, basicTable_MT);
    end

    -- returns the total number of changes waiting to be saved to the database using SaveChanges()
    function GetTotalPendingChanges(tracker)
        local data = _metaData[tostring(tracker)];
        local pendingChanges = 0;

        for _, _ in pairs(data.changes) do
            pendingChanges = pendingChanges + 1;
        end

        return pendingChanges;
    end

    function ResetChanges(tracker)
        local data = _metaData[tostring(tracker)];
        obj:EmptyTable(data.changes);
    end

    function GetUntrackedTable(tracker)
        local data = _metaData[tostring(tracker)];
        return data.basicTable;
    end

    function GetObserver(tracker)
        local data = _metaData[tostring(tracker)];
        return data.observer;
    end

    function Iterate(tracker)
        local data = _metaData[tostring(tracker)];
        return next, data.basicTable, nil;
    end

    -- Basic Table Methods:

    function BasicTableParent:GetTrackedTable()
        local data = _metaData[tostring(self)];
        local tracker = data.tracker;

        if (not tracker) then
            tracker = CreateTrackerFromTable(data.observer, self);
        end

        return tracker;
    end

    function BasicTableParent:GetObserver()
        local data = _metaData[tostring(self)];
        return data.observer;
    end

    do
        local function RemoveNilTableValues(currentTable, updatedTable)
            for currentKey, currentValue in pairs(currentTable) do
                if (updatedTable[currentKey] == nil) then
                    currentTable[currentKey] = nil;
                elseif (obj:IsTable(updatedTable[currentKey]) and obj:IsTable(currentValue)) then
                    RemoveNilTableValues(currentValue, updatedTable[currentKey]);
                end
            end
        end

        -- need to keep table references unchanged to prevent breaking modules
        local function UpdateUntrackedTable(currentTable, updatedTable)
            for updatedKey, updatedValue in pairs(updatedTable) do
                if (obj:IsTable(currentTable[updatedKey]) and obj:IsTable(updatedValue)) then
                    UpdateUntrackedTable(currentTable[updatedKey], updatedValue);
                else
                    currentTable[updatedKey] = updatedValue;
                end
            end

            RemoveNilTableValues(currentTable, updatedTable);
        end

        function BasicTableParent:Refresh()
            local data = _metaData[tostring(self)];
            local updatedTable = data.observer:GetUntrackedTable();
            UpdateUntrackedTable(self, updatedTable);
            obj:PushTable(updatedTable);
        end
    end

    -- Meta-methods:

    tracker_MT.__index = function(tracker, key)
        local data = _metaData[tostring(tracker)];
        local nextValue = data.basicTable[key];
        local nextPath = GetNextPath(data.path, key);

        -- if it has not yet been saved but has been updated, use this value instead!
        if (data.changes[nextPath] ~= nil) then
            nextValue = data.changes[nextPath];

            if (nextValue == "nil") then
                nextValue = nil;
            end
        end

        if (obj:IsTable(nextValue)) then
            -- create new tracker if one does not already exist!
            local basicTable = nextValue; -- easier readability
            local nextTracker = _metaData[tostring(basicTable)];

            if (not nextTracker) then
                nextValue = CreateTrackerFromTable(data.observer, basicTable, tracker, nextPath);
            end
        end

        return nextValue;
    end

    tracker_MT.__newindex = function(tracker, key, value)
        local data = _metaData[tostring(tracker)];
        local newIndexPath = GetNextPath(data.path, key);
        local currentValue = data.basicTable[key];

        if (currentValue ~= nil and value == nil) then
            -- so that SaveChanges() knows to set this to nil
            -- (else the key would be removed from changes table)
            data.changes[newIndexPath] = "nil";

        elseif (IsEqual(currentValue, value)) then
            -- value reverted back to original value before SaveChanges() was called
            -- so remove the pending change.
            data.changes[newIndexPath] = nil;
        else
            -- record the pending change
            data.changes[newIndexPath] = value;
        end
    end

    tracker_MT.__gc = function(self)
        local data = _metaData[tostring(self)];
        _metaData[tostring(self)] = nil;
        setmetatable(self, nil);
        obj:PushTable(data);
        obj:PushTable(self);
    end

    Framework:DefineReturns("table", "?table");
    ---Creates an immutable table containing all values from the underlining saved variables table,
    ---parent table, and defaults table. Changing this table will not affect the saved variables table!
    ---@param reusableTable table @Can use an already existing table instead of creating a new one. This table will be emptied before being used.
    ---@return table @A table containing all merged values.
    function Observer:GetUntrackedTable(_, reusableTable)
        local basicTable = ConvertObserverToUntrackedTable(self, reusableTable);
        setmetatable(basicTable, basicTable_MT);

        -- create basic table data:
        _metaData[tostring(basicTable)] = obj:PopTable();

        local data = _metaData[tostring(basicTable)];
        data.observer = self; -- needed for GetObserver()

        return basicTable;
    end

    Framework:DefineReturns("table", "?table");
    ---Creates a table containing all values from the underlining saved variables table,
    ---parent table, and defaults table and tracks all changes but does not apply them
    ---until SaveChanges() is called.
    ---@param reusableTable table @Can use an already existing table instead of creating a new one. This table will be emptied before being used.
    ---@return table @A tracking table containing all merged values and some helper methods
    function Observer:GetTrackedTable(_, reusableTable)
        local tbl = ConvertObserverToUntrackedTable(self, reusableTable);
        return CreateTrackerFromTable(self, tbl);
    end
end
-------------------------------------------------
-- Helper Class (only for Library developers)
-------------------------------------------------
Framework:DefineParams("Database", "table");
function Helper:__Construct(data, database, databaseData)
    data.database = database;
    data.dbData = databaseData;
end

Framework:DefineReturns("Database");
function Helper:GetDatabase(data)
    return data.database;
end

Framework:DefineParams("table", "string", "?boolean", "?boolean");
function Helper:GetLastTableKeyPairs(_, rootTable, path, cleaning) -- eventually replace this when static methods get strict typing
    GetLastTableKeyPairs(rootTable, path, cleaning);
end

Framework:DefineParams("string", "table");
Framework:DefineReturns("string");
function Helper:GetNewProfileName(_, oldProfileName, profilesTable)
    local newProfileName = oldProfileName;
    local n = 2;

    while (profilesTable[newProfileName]) do
        -- if it exists in table, we need a new name to avoid name clashes
        newProfileName = string.format("%s (%i)", oldProfileName, n);
        n = n + 1;
    end

    return newProfileName;
end

Framework:DefineReturns("string");
function Helper:GetCurrentProfileKey()
    local playerName = _G.UnitName("player");
    local realm = _G.GetRealmName():gsub("%s+", "");

    return string.join("-", playerName, realm);
end

Framework:DefineParams("table", "table", "any") -- should be string or number
function Helper:GetNextValue(data, previousObserverData, tbl, key)
    --tbl could be sv or defaults table
    local nextValue = tbl[key];

    if (not obj:IsTable(nextValue)) then
        return nextValue;
    end

    local nextObserver = nextValue;

    if (not obj:IsType(nextObserver, "Observer")) then
        nextObserver = previousObserverData.internalTree[key];

        if (not nextObserver) then
            nextObserver = Observer(previousObserverData.isGlobal, previousObserverData);
        end

        previousObserverData.internalTree[key] = nextObserver;
    end

    -- get next observer data and set next path (needs to be updated if from internalTree)
    local nextPath = GetNextPath(previousObserverData.path, key);
    local nextObserverData = data:GetFriendData(nextObserver);
    nextObserverData.path = nextPath;

    if (previousObserverData.parent) then
        nextObserverData.parent = previousObserverData.parent[key];
    end

    -- get next child path in use
    if (previousObserverData.usingChild) then
        local nextChildPath = GetNextPath(previousObserverData.usingChild.path, key);
        self:SetUsingChild(previousObserverData.usingChild.isGlobal, nextChildPath, nextObserver);
    else
        obj:PushTable(nextObserverData.usingChild);
        nextObserverData.usingChild = nil;
    end

    return nextObserver;
end

Framework:DefineParams("table", "?number");
function Helper:PrintTable(_, tbl, depth)
    obj:PrintTable(tbl, depth, 4);
end

Framework:DefineParams("Observer");
Framework:DefineReturns("string");
function Helper:GetDatabaseRootTableName(data, observer)
    local observerData = data:GetFriendData(observer);

    if (observerData.isGlobal) then
        return "global";
    end

    local currentProfile = data.database:GetCurrentProfile();

    if (currentProfile:find("%s+")) then
        -- has spaces
        return string.format("profile['%s']", currentProfile);
    else
        return string.format("profile.%s", currentProfile);
    end
end

Framework:DefineParams("table", "string|number", "?any");
function Helper:HandlePathValueChange(data, observerData, key, newValue)
    local path, defaultRootTable, svRootTable, isGlobal, dbTableRootName;

    if (observerData.usingChild) then
        path = observerData.usingChild.path;
        isGlobal = observerData.usingChild.isGlobal;
    else
        path = observerData.path;
        isGlobal = observerData.isGlobal;
    end

    if (isGlobal) then
        defaultRootTable = data.dbData.defaults.global;
        svRootTable = data.dbData.sv.global;
        dbTableRootName = "global";
    else
        defaultRootTable = data.dbData.defaults.profile;
        svRootTable = data.database.profile:GetSavedVariable();
        dbTableRootName = "profile";
    end

    local valuePath = GetNextPath(path, key);
    local defaultValue = data.database:ParsePathValue(defaultRootTable, valuePath); -- get "fields" from defaultRootTable

    if (not IsEqual(defaultValue, newValue)) then
        -- different from default value so add it
        data.database:SetPathValue(svRootTable, valuePath, newValue);
    else
        data.database:SetPathValue(svRootTable, valuePath, nil);
        self:GetLastTableKeyPairs(svRootTable, valuePath, true); -- clean
    end

    if (dbTableRootName) then
        -- only run update function if the database saved variable table changes!
        local fullPath = string.format("%s.%s", dbTableRootName, valuePath);
        data.database:TriggerUpdateFunction(fullPath, newValue);
    end
end

Framework:DefineParams("boolean", "string", "Observer");
function Helper:SetUsingChild(data, isGlobal, path, parentObserver)
    local parentObserverData = data:GetFriendData(parentObserver);
    local usingChild = parentObserverData.usingChild or obj:PopTable();

    usingChild.isGlobal = isGlobal;
    usingChild.path = path;

    parentObserverData.usingChild = usingChild;
end

Framework:ProtectClass(Database);
Framework:ProtectClass(Observer);

--- Local Functions ------------------

function GetNextPath(path, key)
    if (path ~= nil) then
        if (tonumber(key)) then
            return string.format("%s[%s]", path, key);
        else
            return string.format("%s.%s", path, key);
        end
    else
        if (tonumber(key)) then
            key = string.format("[%s]", key);
        end

        return key;
    end
end

function IsEqual(leftValue, rightValue, shallow)
    local leftType = type(leftValue);

    if (leftType == type(rightValue)) then
        if (leftType == "table") then

            if (shallow and tostring(leftValue) == tostring(rightValue)) then
                return true;
            else
                for key, value in pairs(leftValue) do
                    if (not (obj:IsString(key) and key:match("^__template"))) then
                        if (not IsEqual(value, rightValue[key])) then
                            return false;
                        end
                    end
                end

                for key, value in pairs(rightValue) do
                    if (not (obj:IsString(key) and key:match("^__template"))) then
                        if (not IsEqual(value, leftValue[key])) then
                            return false;
                        end
                    end
                end
            end

            return true;
        elseif (leftType == "function") then
            return tostring(leftValue) == tostring(rightValue);
        else
            return leftValue == rightValue;
        end
    end

    return false;
end

function GetDatabasePathInfo(db, rootTableOrPath, pathOrValue, value)
    local rootTable, path;

    if (obj:IsTable(rootTableOrPath)) then
        rootTable = rootTableOrPath;
        path = pathOrValue;
    else
        local rootTableType, realPath = rootTableOrPath:match("([^.]+).(.*)");
        rootTableType = rootTableType:gsub("%s", ""):lower();

        path = realPath;
        value = pathOrValue;

        if (rootTableType == "global") then
            rootTable = db.global;
        elseif (rootTableType == "profile") then
            rootTable = db.profile;
        end
    end

    return rootTable, path, value;
end

do
    local function GetNextTable(tbl, key, parsing)
        if (tbl[key] == nil and not parsing) then
            tbl[key] = obj:PopTable();
        end

        return tbl, tbl[key];
    end

    local function IsEmpty(tbl)
        if (tbl == nil) then
            return true;
        end

        for _, value in pairs(tbl) do
            if (not obj:IsTable(value) or not IsEmpty(value)) then
                return false;
            end
        end

        return true;
    end

    local function IsCleaning(cleaning, nextTable, lastTable, lastKey)
        if (cleaning and IsEmpty(nextTable)) then
            if (obj:IsTable(lastTable)) then
                obj:PushTable(lastTable[lastKey]);
                lastTable[lastKey] = nil;
            end

            return true;
        end

        return false;
    end

    function GetLastTableKeyPairs(rootTable, path, cleaning)
        local nextTable = rootTable;
        local lastTable, lastKey;
        local isLastPart, isLastIndex;
        local pathParts = obj:PopTable(strsplit(".", path));

        for i, key in ipairs(pathParts) do
            isLastPart = i == #pathParts;

            if (tonumber(key)) then
                key = tonumber(key);
                lastKey = key;
                lastTable, nextTable = GetNextTable(nextTable, key, isLastPart);

                if (IsCleaning(cleaning, nextTable, lastTable, lastKey)) then
                    obj:PushTable(pathParts);
                    return nil;
                end

            elseif (key ~= "db") then
                local indexes;

                if (key:find("%b[]")) then
                    indexes = obj:PopTable();

                    for index in key:gmatch("(%b[])") do
                        index = index:match("%[(.+)%]");
                        table.insert(indexes, index);
                    end
                end

                key = strsplit("[", key);

                if (#key > 0) then
                    lastKey = key;
                    lastTable, nextTable = GetNextTable(nextTable, key, isLastPart and (indexes and #indexes == 0));

                    if (IsCleaning(cleaning, nextTable, lastTable, lastKey)) then
                        if (obj:IsTable(indexes)) then
                            obj:PushTable(indexes);
                        end

                        obj:PushTable(pathParts);
                        return nil;
                    end
                end

                if (indexes) then
                    for i2, indexKey in ipairs(indexes) do
                        isLastIndex = i2 == #indexes;
                        indexKey = tonumber(indexKey) or indexKey;
                        lastKey = indexKey;
                        lastTable, nextTable = GetNextTable(nextTable, indexKey, isLastPart and isLastIndex);

                        if (IsCleaning(cleaning, nextTable, lastTable, lastKey)) then
                            obj:PushTable(indexes);
                            obj:PushTable(pathParts);
                            return nil;
                        end
                    end

                    obj:PushTable(indexes);
                end
            end
        end

        obj:PushTable(pathParts);

        return lastTable, lastKey;
    end
end