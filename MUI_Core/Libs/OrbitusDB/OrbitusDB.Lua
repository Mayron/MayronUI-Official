-- luacheck: ignore self
---@diagnostic enable

local _G = _G;
local OrbitusApi = {};
local DatabaseMixin = {}; ---@class DatabaseMixin
local RepositoryMixin = {}; ---@class RepositoryMixin
local ProfileManagerMixin = {}; ---@class ProfileManagerMixin
local Utilities = {}; ---@class Utilities

local UnitFullName, strsplit = _G.UnitFullName, _G.strsplit;
local GetServerTime = _G.GetServerTime;

---@alias RepositoryHandler fun(sv: table, db: DatabaseMixin): table
---@alias OnInitializedCallback fun(db: DatabaseMixin)
---@alias DatabaseCallbackType "profileChanged"|"profileListChanged"|"binListChanged"
---@alias DatabaseCallback fun(db: DatabaseMixin, ...: any)
---@alias Observer fun(db: DatabaseMixin, value: any, previousValue: any)

---@class DatabaseConfig
---@field GetDefaultProfile fun(): string
---@field repositoryHandlers table<string, RepositoryHandler>
---@field defaults table
---@field schemas table
---@field observers table<string, Observer[]>

local defaultConfig = {
  GetDefaultProfile = function() return "Default"; end;
  repositoryHandlers = {
    ["global"] = function(sv)
      sv.global = sv.global or {};
      return sv.global;
    end,
    ["profile"] = function(sv, db)
      local profileName = db:GetProfileManager():GetActive();
      sv.profiles = sv.profiles or {};
      sv.profiles[profileName] = sv.profiles[profileName] or {};
      return sv.profiles[profileName];
    end,
    ["character"] = function(sv)
      local characterName = UnitFullName("player");
      assert(type(characterName) == "string",
        "Failed to get character repository; character name is invalid.");
      sv.characters = sv.characters or {};
      sv.characters[characterName] = sv.characters[characterName] or {};
      return sv.characters[characterName];
    end,
  }
};

---@class DatabaseMetadata
---@field callbacks table<DatabaseCallbackType, DatabaseCallback[]>
---@field svName string
---@field profileManager ProfileManagerMixin
---@field database DatabaseMixin
---@field config DatabaseConfig
---@field initialized boolean

---@type table<string, DatabaseMetadata>
local metadata = {};

---@type table<string, DatabaseConfig>
local registeredDatabases = {};

---@type table<string, OnInitializedCallback>
local onInitializedCallbacks = {};
local dbLoader = _G.CreateFrame("Frame");
local CreateAndInitFromMixin = _G.CreateAndInitFromMixin;
local CreateFromMixins = _G.CreateFromMixins;

dbLoader:RegisterEvent("ADDON_LOADED");
dbLoader:SetScript("OnEvent", function()
  for savedVariableName, _ in pairs(registeredDatabases) do
    if (not dbLoader[savedVariableName] and type(_G[savedVariableName]) == "table") then
      CreateAndInitFromMixin(DatabaseMixin, savedVariableName);
      dbLoader[savedVariableName] = true;
    end
  end
end);

--------------------------
--> OrbitusApi:
--------------------------

function OrbitusApi:Register(savedVariableName, userConfig)
  assert(registeredDatabases[savedVariableName] == nil, 
    ("Database %s has already been registered"):format(savedVariableName));

  local config = Utilities:Assign(defaultConfig, userConfig);
  registeredDatabases[savedVariableName] = config;

  if (type(_G[savedVariableName]) == "table") then
    CreateAndInitFromMixin(DatabaseMixin, savedVariableName);
  end
end

---@param savedVariableName string
---@param callback OnInitializedCallback
function OrbitusApi:OnInitialized(savedVariableName, callback)
  onInitializedCallbacks[savedVariableName] = callback;
end

function OrbitusApi:GetDatabase(savedVariableName)
  for _, data in pairs(metadata) do
    if (data.svName == savedVariableName) then
      return data.database;
    end
  end
end

--------------------------
--> DatabaseMixin:
--------------------------

function DatabaseMixin:Init(savedVariableName)
  assert(type(registeredDatabases[savedVariableName]) == "table",
    ("Database %s cannot be initialized because it has not been registered"):format(savedVariableName));

  local config = registeredDatabases[savedVariableName];

  assert(type(_G[savedVariableName]) == "table",
  ("Database %s failed to initialize because the saved variable table '%s' was not found"):format(savedVariableName));

  local profileManager = CreateFromMixins(ProfileManagerMixin);

  ---@type DatabaseMetadata
  local data = {
    svName = savedVariableName;
    config = config;
    database = self;
    initialized = true,
  };

  metadata[tostring(self)] = data;
  metadata[tostring(profileManager)] = data;

  for repositoryName, _ in pairs(data.config.repositoryHandlers) do
    local repository = CreateFromMixins(RepositoryMixin);
    repository[tostring(repository)] = data;
    self[repositoryName] = repository;
  end

  local callback = onInitializedCallbacks[savedVariableName];
  if (callback) then
    callback(self);
  end
end

---@return ProfileManagerMixin
function DatabaseMixin:GetProfileManager()
  local data = metadata[tostring(self)];
  return data.profileManager;
end

function DatabaseMixin:OnProfileChanged(callback)
  Utilities:AddCallback(self, "profileChanged", callback);
end

function DatabaseMixin:OnProfileListChanged(callback)
  Utilities:AddCallback(self, "profileListChanged", callback);
end

function DatabaseMixin:OnBinListChanged(callback)
  Utilities:AddCallback(self, "binListChanged", callback);
end

function DatabaseMixin:AddDefaults(defaults)
  local data = metadata[tostring(self)];
  assert(not data.initialized,
    "Unable to modify the database defaults after the database has been initialized");
  data.config.defaults = Utilities:Assign(data.config.defaults, defaults);
end

function DatabaseMixin:AddSchema(schema)
  local data = metadata[tostring(self)];
  assert(not data.initialized,
  "Unable to modify the database schema after the database has been initialized");
  data.config.schemas = Utilities:Assign(data.config.schemas, schema);
end

---@param query string
---@param observer Observer
function DatabaseMixin:Subscribe(query, observer)
  local data = metadata[tostring(self)];
  data.config.observers = data.config.observers or {};
  data.config.observers[query] = data.config.observers[query] or {};

  local list = data.config.observers[query];
  list[#list+1] = observer;
end

--------------------------
--> ProfileManagerMixin:
--------------------------

---@return string
function ProfileManagerMixin:GetActive()
  local data = metadata[tostring(self)];
  local profileKeys = Utilities:GetSavedVariableSubTable(self, "profileKeys");

  local characterName = UnitFullName("player");
  assert(type(characterName) == "string",
  "Failed to get active profile; invalid character name");
  return profileKeys[characterName] or data.config.GetDefaultProfile();
end

---@param profileName string
function ProfileManagerMixin:SetActive(profileName)
  local profileKeys = Utilities:GetSavedVariableSubTable(self, "profileKeys");

  local characterName = UnitFullName("player");
  assert(type(characterName) == "string",
  "Failed to set active profile; invalid character name");
  profileKeys[characterName] = profileName;

  Utilities:TriggerCallback(self)
end

---@return string[]
function ProfileManagerMixin:GetAll()
  local profiles = Utilities:GetSavedVariableSubTable(self, "profiles");

  local profileNames = {};
  for profileName, _ in pairs(profiles) do
    profileNames[#profileNames+1] = profileName;
  end

  return profileNames;
end

function ProfileManagerMixin:Delete(profileName)
  local profiles = Utilities:GetSavedVariableSubTable(self, "profiles");

  if (type(profiles[profileName]) ~= "table") then
    return false;
  end

  local profileData = self:Export(profileName);
  profiles[profileName] = nil;

  local bin = Utilities:GetSavedVariableSubTable(self, "bin");
  bin[profileName] = {
    expiry = GetServerTime() + 604800, -- add 7 days (in seconds)
    data = profileData
  };

  return true;
end

function ProfileManagerMixin:Rename(profileName, newProfileName, force)
  local profiles = Utilities:GetSavedVariableSubTable(self, "profiles");
  local profileKeys = Utilities:GetSavedVariableSubTable(self, "profileKeys");

  assert(type(profiles[newProfileName]) ~= "table" or force,
  ("Failed to rename profile '%s' to '%s'; a profile with the new name already exists")
    :format(profileName, newProfileName));

  profiles[newProfileName] = profiles[profileName];

  for characterName, characterProfile in pairs(profileKeys) do
    if (characterProfile == profileName) then
      profileKeys[characterName] = newProfileName;
    end
  end

  profiles[profileName] = nil;
end

---@return string[]
function ProfileManagerMixin:GetDeleted()
  local bin = Utilities:GetSavedVariableSubTable(self, "bin");

  local deletedProfiles = {};
  for profileName, _ in pairs(bin) do
    deletedProfiles[#deletedProfiles+1] = profileName;
  end

  return deletedProfiles;
end

function ProfileManagerMixin:Restore(profileName, force)
  local profiles = Utilities:GetSavedVariableSubTable(self, "profiles");

  assert(type(profiles[profileName]) ~= "table" or force,
    ("Failed to restore profile '%s'; a profile with that name already exists"):format(profileName));

  local bin = Utilities:GetSavedVariableSubTable(self, "bin");

  if (type(bin[profileName]) ~= "table") then
    return false;
  end

  local profileDataString = bin[profileName].data;
  self:Import(profileName, profileDataString);

  return true;
end

function ProfileManagerMixin:Export(profileName)
  local data = metadata[tostring(self)];
end

function ProfileManagerMixin:Import(profileName, profileDataString)
  local data = metadata[tostring(self)];
end

--------------------------
--> RepositoryMixin:
--------------------------
---@param query string
function RepositoryMixin:Query(query)
  Utilities:VerifyArgs(query, "string");
  local repository = Utilities:GetRepositoryTable(self);
  local results = Utilities:ParseQuery(repository, query);
  return results;
end

function RepositoryMixin:Store(query, value)
  Utilities:VerifyArgs(query, "string");
  local repository = Utilities:GetRepositoryTable(self);
  local previousValue = Utilities:Store(repository, query, value);

  if (previousValue ~= value) then
    local data = metadata[tostring(self)];
    Utilities:NotifyChange(data, query, value, previousValue);
  end
end

function RepositoryMixin:Exists(query)
  return self:Query(query) ~= nil;
end

--------------------------
--> Utilities:
--------------------------

local errorTemplate = "bad argument #%d (%s expected, got %s)";

function Utilities:VerifyArgs(...)
  local parameterIndex = 0;

  for i = 1, select("#", ...), 2 do
    parameterIndex = parameterIndex + 1;
    local arg, expectedArgType = select(i, ...);
    local actualArgType = type(arg);

    assert(actualArgType == expectedArgType,
      errorTemplate:format(parameterIndex, expectedArgType, actualArgType));
  end
end

---@return table
function Utilities:Assign(...)
  local merged = {};

  for i = 1, select("#", ...) do
    local tbl = (select(i, ...));

    if (type(tbl) == "table") then
      for key, value in pairs(tbl) do
        if (type(value) == "table") then
          merged[key] = self:Assign(value); -- if merged[key] is a table, replace it as well
        else
          merged[key] = value;
        end
      end
    end
  end

  return merged;
end

---@param repository RepositoryMixin
function Utilities:GetRepositoryTable(repository)
  local data = metadata[tostring(repository)];
  local database = data.database;

  for repositoryName, handler in pairs(data.config.repositoryHandlers) do
    if (repository == database[repositoryName]) then
      return handler(_G[data.svName], data.database);
    end
  end
end

---@return string | nil
function Utilities:GetRepositoryName(repository)
  local data = metadata[tostring(repository)];
  local database = data.database;

  for repositoryName, _ in pairs(data.config.repositoryHandlers) do
    if (repository == database[repositoryName]) then
      return repositoryName;
    end
  end
end

function Utilities:GetSavedVariableSubTable(obj, tblName)
  local data = metadata[tostring(obj)];
  local sv = _G[data.svName];
  sv[tblName] = sv[tblName] or {};
  return sv[tblName];
end

---@param callbackName DatabaseCallbackType
function Utilities:AddCallback(obj, callbackName, callback)
  local data = metadata[tostring(obj)];
  data.callbacks = data.callbacks or {};
  data.callbacks[callbackName] = data.callbacks[callbackName] or {};
  local list = data.callbacks[callbackName];
  list[#list+1] = callback;
end

---@param callbackName DatabaseCallbackType
function Utilities:TriggerCallback(obj, callbackName, ...)
  local data = metadata[tostring(obj)];

  if (type(data.callbacks) ~= "table") then
    return
  end

  if (type(data.callbacks[callbackName]) ~= "table") then
    return
  end

  for _, callback in ipairs(data.callbacks[callbackName]) do
    callback(data.database, ...)
  end
end

---@param data DatabaseMetadata
---@param query string
---@param newValue any
---@param oldValue any
function Utilities:NotifyChange(data, query, newValue, oldValue)
  local observers = data.config.observers;
  if (type(observers) ~= "table") then return end

  observers = observers[query];
  if (type(observers) ~= "table") then return end

  for _, observer in ipairs(observers) do
    observer(data.database, newValue, oldValue);
  end
end

do
  local normalizePattern = "%[%s-['\"]([^%[\"']*)['\"]%s-%]";
  local removeIndexesPattern = "%[%s-%d+%s-%]";
  local matchIndexesPattern = "%[%s-(%d+)%s-%]";

  ---@param root table
  ---@param query string
  ---@return any
  function Utilities:ParseQuery(root, query)
    local normalized = query:gsub(normalizePattern, ".%1");
    local keys = strsplit(".", normalized); ---@type string[]

    local result = root;
    for _, key in ipairs(keys) do
      if (type(result) ~= "table") then
        return nil;
      end

      local sanitizedKey = key:gsub(removeIndexesPattern, "");
      result = result[sanitizedKey];

      for i in key:gmatch(matchIndexesPattern) do
        local index = tonumber(i);

        if (type(result) ~= "table") then
          return nil;
        end

        assert(type(index) == "number" and index > 0,
          ("Failed to parse query %s at key %s"):format(query, i));

        result = result[index];
      end
    end

    if (result == root) then
      return nil;
    end

    return result;
  end

  ---@param root table
  ---@param query string
  ---@param value any
  function Utilities:Store(root, query, value)
    local normalized = query:gsub(normalizePattern, ".%1");
    local keys = strsplit(".", normalized); ---@type string[]

    local sanitizedKeys = {};

    for _, key in ipairs(keys) do
      local sanitizedKey = key:gsub(removeIndexesPattern, "");
      sanitizedKeys[#sanitizedKeys+1] = sanitizedKey;

      for i in key:gmatch(matchIndexesPattern) do
        local index = tonumber(i);
        assert(type(index) == "number" and index > 0,
          ("Failed to parse query %s at key %s; index is invalid"):format(query, i));

        sanitizedKeys[#sanitizedKeys+1] = tonumber(index);
      end
    end

    local storageTbl = root;
    for i, key in ipairs(sanitizedKeys) do
      if (i < #sanitizedKeys) then
        if (type(storageTbl[key]) ~= "table") then
          storageTbl[key] = {};
        end

        storageTbl = storageTbl[key];
      else
        local previousValue = storageTbl[key];
        storageTbl[key] = value;
        return previousValue;
      end
    end
  end
end