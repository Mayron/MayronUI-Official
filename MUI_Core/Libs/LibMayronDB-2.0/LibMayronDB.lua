local Lib = LibStub:NewLibrary("LibMayronDB", 2.0);
local Objects = LibStub:GetLibrary("LibMayronObjects");

if (not Lib or not Objects) then return; end

local Framework = Objects:CreatePackage("LibMayronDB");
local Database = Framework:CreateClass("Database");
local Observer = Framework:CreateClass("Observer");
local Helper = Framework:CreateClass("Helper");

Observer.Static:AddFriendClass("Helper");

local select, _G = select, _G;
local tonumber, strsplit = tonumber, strsplit;

--local internalTree = {};

-- OnAddOnLoadedListener
local OnAddOnLoadedListener = CreateFrame("Frame");
OnAddOnLoadedListener:RegisterEvent("ADDON_LOADED");
OnAddOnLoadedListener.RegisteredDatabases = {};

OnAddOnLoadedListener:SetScript("OnEvent", function(self, _, addOnName)
    local database = OnAddOnLoadedListener.RegisteredDatabases[addOnName];

    if (database) then
        database:Start();        
    end
end);

local function GetNextPath(path, key)
    if (path ~= nil) then    
        if (tonumber(key)) then
            key = string.format("%s[%s]", path, key);
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

------------------------
-- Database API
------------------------
--[[
Creates the database but does not initialize it until after "ADDON_LOADED" event (unless manualStartUp is set to true).

@param (string) addOnName: The name of the addon to listen out for. If supplied it will start the database
    automatically after the ADDON_LOADED event has fired (when the saved variable becomes accessible).
@param (string) savedVariableName: The name of the saved variable to hold the database (defined in the toc file).
@param (optional | boolean) manualStartUp: Set to true if you do not want the library to automatically start 
    the database when the saved variable becomes accessible. 

@return (Database): The database object.
]]
function Lib:CreateDatabase(addOnName, savedVariableName, manualStartUp)
    local database = Database(addOnName, savedVariableName);

    if (not manualStartUp) then
        if (_G[savedVariableName]) then
            -- already loaded
            database:Start();
        else
            -- register to start when ready
            OnAddOnLoadedListener.RegisteredDatabases[addOnName] = database;
        end        
    end

    return database;
end

--[[
Do NOT call this manually! Should only be called by Lib:CreateDatabase(...)
]]
Framework:DefineParams("string", "string");
function Database:__Construct(data, addOnName, savedVariableName)
    data.addOnName = addOnName;
    data.svName = savedVariableName;
    data.callbacks = {};
    data.helper = Helper(self, data);

    -- holds all database defaults to check first before searching database
    data.defaults = {}; 
    data.defaults.global = {};
    data.defaults.profile = {};
end

--[[
Hooks a callback function onto the "StartUp" event to be called when the database starts up 
(i.e. when the saved variable becomes accessible). By default, this function is called by the library 
with 2 arguments: the database and the addOn name passed to Lib:CreateDatabase(...).

@param (function) callback: The start up callback function
]]
Framework:DefineParams("function");
function Database:OnStartUp(data, callback)
    local startUpCallbacks = data.callbacks["OnStartUp"] or {};
    data.callbacks["OnStartUp"] = startUpCallbacks;

    table.insert(startUpCallbacks, callback);
end

--[[
Hooks a callback function onto the "ProfileChanged" event to be called when the database changes profile
(i.e. only changed by the user using db:SetProfile() or db:RemoveProfile(currentProfile)).

@param (function) callback: The profile changing callback function
]]
Framework:DefineParams("function");
function Database:OnProfileChanged(data, callback)
    local profileChangedCallback = data.callbacks["OnProfileChanged"] or {};
    data.callbacks["OnProfileChanged"] = profileChangedCallback;

    table.insert(profileChangedCallback, callback);
end

--[[
Starts the database. Should only be used when the saved variable is accessible (after the ADDON_LOADED event has fired).
This is called automatically by the library when the saved variable becomes accessible unless manualStartUp was 
set to true during the call to Lib:CreateDatabase(...).
]]
function Database:Start(data)
    if (data.loaded) then
        -- previously started and loaded
        return;
    end

    OnAddOnLoadedListener.RegisteredDatabases[data.addOnName] = nil;

    -- create Saved Variable if it has never been created before
    _G[data.svName] = _G[data.svName] or {};
    data.sv = _G[data.svName];
    data.svName = nil; -- no longer needed once it is loaded

    -- create root profiles table if it does not exist
    data.sv.profiles = data.sv.profiles or {};

    -- create root global table if it does not exist
    data.sv.global = data.sv.global or {};

    -- create profileKeys table if it does not exist
    data.sv.profileKeys = data.sv.profileKeys or {};

    -- create appended table if it does not exist
    data.sv.appended = data.sv.appended or {};

    -- create Default profile if it does not exist
    data.sv.profiles.Default = data.sv.profiles.Default or {};

    -- create Profile and Global accessible observers:

    local currentProfile = self:GetCurrentProfile();
    self.profile = Observer(data.helper, false, data.sv.profiles[currentProfile], data.defaults.profile);
    self.global = Observer(data.helper, true, data.sv.global, data.defaults.global);

    data.loaded = true;

    if (data.callbacks["OnStartUp"]) then
        for _, callback in ipairs(data.callbacks["OnStartUp"]) do        
            callback(self, data.addOnName);
        end
    end

    data.callbacks["OnStartUp"] = nil;
end

--[[
Returns true if the database has been successfully started and loaded.

@return (boolean): indicates if the database is loaded.
]]
Framework:DefineReturns("boolean");
function Database:IsLoaded(data)
    return data.loaded == true;
end

--[[
Adds a value to the database defaults table relative to the path: defaults.<path> = <value>

@param (string): a database path string, such as "myTable.mySubTable[2]"
@param (any): a value to assign to the database defaults table using the path
]]
Framework:DefineParams("string", "?any");
function Database:AddToDefaults(data, path, value)
    self:SetPathValue(data.defaults, path, value);
end

--[[
Adds a value to a table relative to a path: rootTable.<path> = <value>

@param (table) rootTable: The initial root table to search from. 
@param (string) path: a table path string (also called a path address), such as "myTable.mySubTable[2]". 
    This is converted to a sequence of tables which are added to the database if they do not already exist (myTable will be created if not found).
@param (any): a value to assign to the table relative to the provided path string.
]]
Framework:DefineParams("table", "string", "?any");
function Database:SetPathValue(data, rootTable, path, value)
    if (rootTable.GetObjectType and rootTable:GetObjectType() == "Observer") then
        rootTable = rootTable:ToSavedVariable();
    end

    local lastTable, lastKey = data.helper:GetLastTableKeyPairs(rootTable, path);
    
    if (lastKey and lastTable) then
        lastTable[lastKey] = value;
    end
end

--[[
Searches a path address (table path string) and returns the located value if found.

@param (table) rootTable: The root table to begin searching through using the path address.
@param (string) path: The path of the value to search for. Example: "myTable.mySubTable[2]"

@return (any): The value found at the location specified by the path address.
Might return nil if the path address is invalid, or no value is located at the address.

Example: value = db:ParsePathValue(db.profile, "mySettings[" .. moduleName .. "][5]");
]]
Framework:DefineParams("table", "string");
function Database:ParsePathValue(data, rootTable, path)    
    local lastTable, lastKey = data.helper:GetLastTableKeyPairs(rootTable, path, true);

    if (lastKey and lastTable) then
        return lastTable[lastKey];
    end

    return nil;
end

--[[
Sets the addon profile for the currently logged in character. 
Creates a new profile if the named profile does not exist.

@param (string) name: The name of the profile to assign to the character.
]]
Framework:DefineParams("string");
function Database:SetProfile(data, profileName)
    local profile = data.sv.profiles[profileName] or {};
    data.sv.profiles[profileName] = profile;

    local profileKey = data.helper:GetCurrentProfileKey();
    local oldProfileName = data.sv.profileKeys[profileKey] or "Default";

    data.sv.profileKeys[profileKey] = profileName; 
    
    if (data.callbacks["OnProfileChanged"]) then
        for _, callback in ipairs(data.callbacks["OnProfileChanged"]) do        
            callback(self, profileName, oldProfileName);
        end
    end
end

--[[
@return (string): The current profile associated with the currently logged in character.
]]
Framework:DefineReturns("string");
function Database:GetCurrentProfile(data)
    local profileKey = data.helper:GetCurrentProfileKey();
    return data.sv.profileKeys[profileKey] or "Default";
end

--[[
Usable in a for loop to loop through all profiles associated with the AddOn.
Each loop returns values: id, profileName, profile

    - (int) id: current loop iteration
    - (string) profileName: the name of the profile
    - (table) profile: the profile data
]]
function Database:IterateProfiles(data)
    local id = 0;
    local profileNames = {};

    for name, _ in pairs(data.sv.profiles) do
        table.insert(profileNames, name);
    end

    return function()
        id = id + 1;

        if (id <= #profileNames) then
            return id, profileNames[id], data.sv.profiles[profileNames[id]];
        end
    end
end

--[[
@return (int): The number of profiles associated with the database.
]]
Framework:DefineReturns("number");
function Database:GetNumProfiles(data)
    local n = 0;

    for _ in pairs(data.sv.profiles) do
        n = n + 1;
    end

    return n;
end

--[[
Helper function to reset a profile.

@param (string) name: The name of the profile to reset.
]]
Framework:DefineParams("string");
function Database:ResetProfile(data, profileName)
    self:RemoveProfile(profileName);
    self:SetProfile(profileName);
end

--[[
Moves the profile to the bin. The profile cannot be accessed from the bin. 
Use db:RestoreProfile(profileName) to restore the profile.

@param (string) profileName: The name of the profile to move to the bin.
]]
Framework:DefineParams("string");
function Database:RemoveProfile(data, profileName)
     if (data.sv.profiles[profileName]) then

        data.bin = data.bin or {};
        data.bin[profileName] = data.sv.profiles[profileName];
        data.sv.profiles[profileName] = nil;
        
        if (self:GetCurrentProfile() == profileName) then
            self:SetProfile("Default");
        end
    end
end

--[[
Profiles will remain in the bin until a reload of the UI occurs. 
If the bin contains a profile, this function can restore it.

@param (string) name: The name of the profile located inside the bin.
]]
Framework:DefineParams("string");
Framework:DefineReturns("boolean");
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

--[[
Renames an existing profile to a new profile name. If the new name already exists, it appends a number
to avoid clashing: 'example (2)'.

@param (string) oldProfileName: The old profile name.
@param (string) newProfileName: The new profile name.
]]
Framework:DefineParams("string", "string");
function Database:RenameProfile(data, oldProfileName, newProfileName)
    local newProfileName = data.helper:GetNewProfileName(newProfileName, data.sv.profiles);
    local profile = data.sv.profiles[oldProfileName];

    data.sv.profiles[oldProfileName] = nil;
    data.sv.profiles[newProfileName] = profile;

    local currentProfileKey = data.helper:GetCurrentProfileKey();

    for profileKey, profileName in pairs(data.sv.profileKeys) do
        if (profileName == oldProfileName) then
            data.sv.profileKeys[profileKey] = newProfileName;

            if (profileKey == currentProfileKey) then
                if (data.callbacks["OnProfileChanged"]) then
                    for _, value in ipairs(data.callbacks["OnProfileChanged"]) do
                        local callback = value[1];            
                        callback(newProfileName, select(2, unpack(value)));
                    end
                end
            end
        end
    end
end

--[[
Adds a new value to the saved variable table only once. Registers the added value with a registration key.

@param (Observer) rootTable: The root database table (observer) to append the value to relative to the path address provided.
@param (string) path: The path address to specify where the value should be appended to.
@param (any) value: The value to be added.
@return (boolean): Returns whether the value was successfully added.
]]
Framework:DefineParams("Observer", "string", "any");
Framework:DefineReturns("boolean");
function Database:AppendOnce(data, rootTable, path, value)
    local tableType = data.helper:GetDatabaseRootTableName(rootTable);

    local appendTable = data.sv.appended[tableType] or {};
    data.sv.appended[tableType] = appendTable;

    if (appendTable[path]) then 
        -- already previously appended, cannot append again
        return false; 
    end

    self:SetPathValue(rootTable, path, value);
    appended[path] = true;

    return true;
end

-------------------------
-- Observer Class:
-------------------------

--[[
Do NOT call this manually! Should only be called by the library to create a new 
observer that controls a database table.
]]
Framework:DefineParams("Helper", "boolean", "?table", "?table");
function Observer:__Construct(data, helper, isGlobal, svTable, defaults)
    data.helper = helper;       
    data.isGlobal = isGlobal;
    data.svTable = svTable;
    data.defaults = defaults;
    data.internalTree = {};
    data.database = helper:GetDatabase();
end

--[[
When a new value is being added to the database, use the child observer's table if 
switched to using a parent observer. Also, add to the saved variable table if not a function.
]]
Observer.Static:OnIndexChanging(function(self, data, key, value)
    data.helper:HandlePathValueChange(data, key, value);    
    return true; -- prevent indexing
end);

--[[
Pick from Observer's saved variable table, else parent table if not found, else defaults table.
]] 
Observer.Static:OnIndexed(function(self, data, key, realValue)    
    if (realValue ~= nil) then
        return realValue; -- it is an observer object value
    end
    
    if (not data.svTable) then
        if (not data.defaults) then
            return nil;
        end
        -- it is already indexing the defaults table so continue...
        return data.helper:GetNextDefaultValue(data, data.defaults, key);
    end

    local foundValue = data.svTable[key];    

    if (type(foundValue) == "table") then
        -- convert saved variable table into an Observer
        foundValue = data.helper:GetNextObserver(data, foundValue, key);
    end
    
    -- check parent if still not found
    if (foundValue == nil and data.parent) then 
        foundValue = data.helper:GetNextParentValue(data, data.parent, key);
    end
    
    -- check defaults if still not found 
    if (foundValue == nil and data.defaults) then
        foundValue = data.helper:GetNextDefaultValue(data, data.defaults, key);    
    end      

    return foundValue;
end);

--[[
Used to achieve database inheritance. If an observer cannot find a value, it uses the value found in the 
parent table. Useful if many separate tables in the saved variables table should use the same set of 
changable values when the defaults table is not a suitable solution.

@param (optional | Observer) parentObserver: Which observer should be used as the parent. 
    If this is nil, the parent is removed.
Example: db.profile.aFrame:SetParent(db.global.frameTemplate)
]]
Framework:DefineParams("?Observer");
function Observer:SetParent(data, parentObserver)     
    data.parent = parentObserver;
end

--[[
@return (Observer): Returns the current Observer's parent.
]]
Framework:DefineReturns("?Observer");
function Observer:GetParent(data) 
    return data.parent;
end

--[[
@return (boolean): Returns true if the current Observer has a parent.
]]
Framework:DefineReturns("boolean");
function Observer:HasParent(data) 
    return data.parent ~= nil;
end

do
    local function Merge(mergeTable, tbl)
        for key, value in pairs(tbl) do            
            if (mergeTable[key] == nil) then
                -- only add to mergeTable if value does not already exist
                if (type(value) == "table") then
                    mergeTable[key] = {};
                    Merge(mergeTable[key], value);
                else
                    mergeTable[key] = value;
                end
            end
        end
    end

    --[[
    Creates an immutable table containing all values from the underlining saved variables table, 
    parent table, and defaults table. Changing this table will not affect the saved variables table!

    @return (table): a table containing all merged values
    ]]
    Framework:DefineReturns("table");
    function Observer:ToTable(data)
        local merged = {};      

        Merge(merged, data.svTable);

        if (data.defaults) then
            Merge(merged, data.defaults);
        end
    
        if (data.parent) then
            local parentTable = data.parent:ToSavedVariable();

            if (parentTable) then
                Merge(merged, data.parent:ToSavedVariable());
            end
        end
        
        return merged;
    end
end

--[[
Gets the underlining saved variables table. Default or parent values will not be included in this!

@return (table): the underlining saved variables table.
]]
function Observer:ToSavedVariable(data)
    return data.svTable;
end

--[[
Usable in a for loop. Uses the merged table to iterate through key and value pairs of the default and 
saved variable table paired together using the Observer path address.

Example:
    for key, value in db.profile.aModule:Iterate() do
        print(string.format("%s : %s", key, value))
    end
]]
function Observer:Iterate(data)
    local merged = self:ToTable();
    return next, merged, nil;
end

--[[
@return (boolean): Whether the merged table is empty.
]]
Framework:DefineReturns("boolean");
function Observer:IsEmpty(data)
    return self:GetLength(true) == 0;
end

--[[
A helper function to print all contents of a table pointed to by the selected Observer.

@param (optional | int) depth: The depth of tables to print before only printing table references.

Example: db.profile.aModule:Print()
]]
Framework:DefineParams("?number");
function Observer:Print(data, depth)
    local merged = self:ToTable();
    local tablePath = data.helper:GetDatabaseRootTableName(self);
    local path = (data.usingChild and data.usingChild.path) or data.path;

    if (path ~= nil) then
        tablePath = string.format("%s.%s", tablePath, path);
    end    

    print(" ");
    print(string.format("db.%s = {", tablePath));
    data.helper:PrintTable(merged, depth, 4);
    print("};");
    print(" ");
end

--[[
@return (int): The length of the merged table (Observer:ToTable()).
]]
Framework:DefineParams("?boolean");
Framework:DefineReturns("number");
function Observer:GetLength(data, includeKeys)
    local length = 0;

    for _, _ in self:Iterate() do
        length = length + 1;
    end

    return length;
end

--[[
@return (int): Returns whether the current parent observer is using a child observer (useful for debugging)
]]
Framework:DefineReturns("boolean");
function Observer:IsUsingChild(data)    
    return data.usingChild ~= nil;
end

--[[
Helper function to return the path address of the observer.
@return (string): The path address
]]
Framework:DefineReturns("?string");
function Observer:GetPathAddress(data)    
    return data.path;
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

do
    local function getNextTable(tbl, key, parsing)
        local previous = tbl;

        if (tbl[key] == nil) then
            if (parsing) then return nil; end
            tbl[key] = {};
        end

        return previous, tbl[key];
    end

    local isEmpty;

    isEmpty = function(tbl)
        if (tbl == nil) then
            return true;
        end

        for key, value in pairs(tbl) do
            if (type(value) ~= "table" or not isEmpty(value)) then
                return false;
            end
        end

        return true;
    end

    Framework:DefineParams("table", "string", "?boolean", "?boolean");
    function Helper:GetLastTableKeyPairs(_, rootTable, path, parsing, cleaning)
        local nextTable = rootTable;
        local lastTable;
        local lastKey;

        for _, pathSection in ipairs({strsplit(".", path)}) do
            lastKey = strsplit("[", pathSection);
            lastTable, nextTable = getNextTable(nextTable, lastKey, parsing);
            
            if (cleaning and isEmpty(nextTable)) then
                if (type(lastTable) == "table") then
                    lastTable[lastKey] = nil;
                end
                return nil;
            end

            if (pathSection:find("%b[]")) then

                -- extraSection could be `path["key"]`
                for extraSection in pathSection:gmatch("(%b[])") do
                    -- remove square brackets (i.e. "key")
                    local extraKey = extraSection:match("%[(.+)%]");

                    lastKey = tonumber(extraKey) or extraKey;
                    lastTable, nextTable = getNextTable(nextTable, lastKey, parsing);

                    if (parsing and lastTable == nil) then
                        return nil;
                    end

                    if (cleaning and isEmpty(nextTable)) then
                        if (type(lastTable) == "table") then
                            lastTable[lastKey] = nil;
                        end
                        return nil;
                    end
                end
            end

            if (parsing and lastTable == nil) then
                return nil;
            end
        end

        return lastTable, lastKey;
    end    
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
    local playerName = UnitName("player");
    local realm = GetRealmName():gsub("%s+", "");

    return string.join("-", playerName, realm);
end


Framework:DefineParams("table", "table", "any"); -- should be string or integer
Framework:DefineReturns("Observer");
function Helper:GetNextObserver(data, previousObserverData, svTable, key)
    -- create Observer to represent found saved vairable sub-table

    local nextObserver = previousObserverData.internalTree[key] or 
        Observer(self, previousObserverData.isGlobal, svTable);

    previousObserverData.internalTree[key] = nextObserver; -- store for later use
    self:UpdateObserver(previousObserverData, nextObserver, key);

    return nextObserver;
end

Framework:DefineParams("table", "Observer", "any") -- should be string or number
function Helper:GetNextParentValue(data, previousObserverData, parent, key)
    -- does not need to be converted to Observer as it already is one
    local nextValue = parent[key]; 

    if (type(nextValue) ~= "table") then
        return nextValue;
    end
    
    self:UpdateObserver(previousObserverData, nextValue, key);

    return nextValue;
end

Framework:DefineParams("table", "table", "any") -- should be string or number
function Helper:GetNextDefaultValue(data, previousObserverData, defaults, key)
    local nextValue = defaults[key];

    if (type(nextValue) ~= "table") then
        return nextValue;
    end  

    local defaultObserver = previousObserverData.internalTree[key] 
        or Observer(self, previousObserverData.isGlobal, nil, nextValue);

    previousObserverData.internalTree[key] = defaultObserver; -- store for later use
    self:UpdateObserver(previousObserverData, defaultObserver, key);

    return defaultObserver;
end

Framework:DefineParams("table", "?number");
function Helper:PrintTable(_, tbl, depth, n)
    n = n or 0;
    depth = depth or 4;

    if (depth == 0) then 
        return; 
    end

    if (n == 0) then
        print(" ");
    end

    for key, value in pairs(tbl) do
        if (key and type(key) == "number" or type(key) == "string") then
            key = string.format("[\"%s\"]", key);

            if (type(value) == "table") then
                print(string.rep(' ', n)..key.." = {");
                self:PrintTable(value, depth - 1, n + 4);
                print(string.rep(' ', n).."},");
            else                
                if (type(value) == "string") then
                    value = string.format("\"%s\"", value);
                else
                    value = tostring(value);
                end

                print(string.rep(' ', n)..key.." = "..value..",");
            end
        end
    end

    if (n == 0) then 
        print(" "); 
    end
end

Framework:DefineParams("Observer");
Framework:DefineReturns("string");
function Helper:GetDatabaseRootTableName(data, observer) 
    local observerData = data:GetFriendData(observer);

    if (observerData.isGlobal) then 
        return "global";
    end

    local currentProfile = data.database:GetCurrentProfile();
    return string.format("profile[%s]", currentProfile);
end

do
    local equals;

    equals = function(value1, value2, shallowEquals)
        local type1 = type(value1);
    
        if (type(value2) == type1) then
    
            if (type1 == "table") then
                if (shallowEquals) then
                    return tostring(value1) == tostring(value2);
                else
                    for id, value in pairs(value1) do
                        if (not equals(value, value2[id])) then
                            return false;
                        end
                    end
                end
    
                return true;
            elseif (type1 == "function") then
                return tostring(value1) == tostring(value2);
            else
                return value1 == value2;
            end        
        end
    
        return false;
    end

    Framework:DefineParams("table", "any", "?any");
    function Helper:HandlePathValueChange(data, observerData, key, value)
        local path;    
        local defaultRootTable;
        local svRootTable;

        if (observerData.usingChild) then
            svRootTable = observerData.usingChild.svTable;
            path = observerData.usingChild.childPath;
        else
            path = observerData.path;

            if (observerData.isGlobal) then
                svRootTable = data.dbData.sv.global;
            else    
                local currentProfile = data.database:GetCurrentProfile();
                svRootTable = data.dbData.sv.profiles[currentProfile];
            end
        end

        if (observerData.isGlobal) then
            defaultRootTable = data.dbData.defaults.global;
        else
            defaultRootTable = data.dbData.defaults.profile;
        end

        indexingPath = GetNextPath(path, key);

        local defaultValue = data.database:ParsePathValue(defaultRootTable, indexingPath);
        
        if (not equals(defaultValue, value)) then
            -- different from default value so add it
            data.database:SetPathValue(svRootTable, indexingPath, value);
        else
            -- same as default value so remove it from saved variables table
            data.database:SetPathValue(svRootTable, indexingPath, nil);
            self:GetLastTableKeyPairs(svRootTable, indexingPath, true, true); -- clean
        end
    end
end

Framework:DefineParams("table", "Observer", "any");
function Helper:UpdateObserver(data, parentData, observer, key)
    local observerData = data:GetFriendData(observer);

    observerData.isDefault = (not observerData.svTable);

    -- get next path
    observerData.path = GetNextPath(parentData.path, key);

    -- get next defaults table
    if (type(parentData.defaults) == "table") then
        observerData.defaults = parentData.defaults[key];
    end

    -- get next child
    if (parentData.usingChild) then        
        local svTable;
        
        if (observerData.isGlobal) then
            svTable = data.dbData.sv.global;
        else
            local currentProfile = data.database:GetCurrentProfile();
            svTable = data.dbData.sv.profiles[currentProfile];
        end

        observerData.usingChild = {
            svTable = svTable, 
            childPath = GetNextPath(parentData.childPath, key)
        };

    else
        observerData.usingChild = nil;
    end
end