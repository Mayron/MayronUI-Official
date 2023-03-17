-- luacheck: ignore self
local _G = _G;
local LibDeflate = _G.LibStub:GetLibrary("LibDeflate");

local OrbitusApi = {};

---@class DatabaseMixin
---@field profile RepositoryMixin
---@field global RepositoryMixin
---@field character RepositoryMixin
local DatabaseMixin = {};
local RepositoryMixin = {}; ---@class RepositoryMixin
local ProfileManagerMixin = {}; ---@class ProfileManagerMixin
local Utilities = {}; ---@class Utilities

local UnitFullName, strsplit = _G.UnitFullName, _G.strsplit;
local GetServerTime = _G.GetServerTime;

---@class RepositoryHandler
---@field GetSavedVariableTable fun(sv: table, db: DatabaseMixin): table
---@field ConfigureIndexer fun(db: DatabaseMixin, actions: ConfigureIndexerActions)
---@field GetDefaultKey fun(): string

---@alias OnInitializedCallback fun(db: DatabaseMixin)
---@alias OnProfileChanged fun(profileManager: ProfileManagerMixin, newProfileName: string, oldProfileName: string)
---@alias OnProfileListChanged fun(profileManager: ProfileManagerMixin)
---@alias OnBinListChanged fun(profileManager: ProfileManagerMixin)
---@alias DatabaseCallbackType "profileChanged"|"profileListChanged"|"binListChanged"
---@alias DatabaseCallback fun(db: DatabaseMixin, ...: any)
---@alias OrbitusObserver fun(query: string, value: any, previousValue: any)
---@alias QueryableList (string|number)[]
---@alias RepositoryName "global"|"profile"|"character"
---@alias IndexerChanges { [string]: { from: any, to: any }}
---@alias ConfigureIndexerActions { RebuildIndex: fun(): IndexerChanges }

---@class DatabaseConfig
---@field defaults { [RepositoryName]: table }
---@field schemas { [RepositoryName]: table }
---@field observers { [RepositoryName]: table<string, OrbitusObserver[]> }
---@field repositoryHandlers table<RepositoryName, RepositoryHandler>

---@type DatabaseConfig
local defaultConfig = {
  defaults = {};
  schemas = {};
  observers = {};

  repositoryHandlers = {
    ["global"] = {
      GetSavedVariableTable = function(sv)
        sv.global = sv.global or {};
        return sv.global;
      end
    },

    -- Needs to Send "OnProfileChanged" and "OnProfileListChanged" events
    -- If we had "OnSpecializationChanged" then this would send that too
    ["profile"] = {
      GetSavedVariableTable = function(sv, db)
        local profileName = db:GetProfileManager():GetActive();
        sv.profiles = sv.profiles or {};
        sv.profiles[profileName] = sv.profiles[profileName] or {};
        return sv.profiles[profileName];
      end,

      GetDefaultKey = function() return "Default" end,

      ConfigureIndexer = function(db, actions)
        db:GetProfileManager():OnProfileChanged(function()
          local changeLog = actions:RebuildIndex();

          for query, changes in pairs(changeLog) do
            db.profile:NotifyChange(query, changes.from, changes.to);
          end
        end);
      end
    },

    ["character"] = {
      GetSavedVariableTable = function(sv)
        local characterName = UnitFullName("player");
        assert(type(characterName) == "string",
          "Failed to get character repository; character name is invalid.");
        sv.characters = sv.characters or {};
        sv.characters[characterName] = sv.characters[characterName] or {};
        return sv.characters[characterName];
      end,
    },
  }
};

---@class DatabaseMetadata
---@field callbacks table<DatabaseCallbackType, DatabaseCallback[]>
---@field svName string
---@field profileManager ProfileManagerMixin
---@field database DatabaseMixin
---@field config DatabaseConfig
---@field indexers { [RepositoryName]: { [string]: table } } -- TODO: Rebuild when changed

---@type table<string, DatabaseMetadata>
local metadata = {};

---@type table<string, DatabaseConfig>
local registeredDatabaseConfigs = {};

---@type table<string, OnInitializedCallback>
local onInitializedCallbacks = {};
local dbLoader = _G.CreateFrame("Frame");
local CreateAndInitFromMixin = _G.CreateAndInitFromMixin;
local CreateFromMixins = _G.CreateFromMixins;

dbLoader:RegisterEvent("ADDON_LOADED");
dbLoader:SetScript("OnEvent", function()
  for savedVariableName, _ in pairs(registeredDatabaseConfigs) do
    if (type(_G[savedVariableName]) == "table") then
      CreateAndInitFromMixin(DatabaseMixin, savedVariableName);
    end
  end
end);

--------------------------
--> OrbitusApi:
--------------------------

---@param savedVariableName string
---@param userConfig DatabaseConfig?
---@param onInitialized OnInitializedCallback
---@overload fun(self, savedVariableName: string, onInitialized: OnInitializedCallback)
function OrbitusApi:Register(savedVariableName, userConfig, onInitialized)
  if (type(userConfig) == "function" and onInitialized == nil) then
    onInitialized = userConfig;
    userConfig = nil;
  end

  assert(registeredDatabaseConfigs[savedVariableName] == nil,
    ("Database %s has already been registered"):format(savedVariableName));

  local config = Utilities:Assign(defaultConfig, userConfig);
  registeredDatabaseConfigs[savedVariableName] = config;
  onInitializedCallbacks[savedVariableName] = onInitialized;

  if (type(_G[savedVariableName]) == "table") then
    CreateAndInitFromMixin(DatabaseMixin, savedVariableName);
  end
end

---@param savedVariableName string
---@return DatabaseMixin?
function OrbitusApi:GetDatabase(savedVariableName)
  for _, data in pairs(metadata) do
    if (data.svName == savedVariableName) then
      return data.database;
    end
  end
end

-- May not end up using this:
-- ---@param savedVariableName string
-- ---@param repositoryName RepositoryName
-- ---@param defaults table
-- function OrbitusApi:AddDefaults(savedVariableName, repositoryName, defaults)
--   local config = registeredDatabaseConfigs[savedVariableName];
--   local data = metadata[tostring(self)];
--   assert(not data and type(config) == "table",
--     "Unable to modify the database defaults after the database has been initialized");
--   config.defaults = Utilities:Assign(config.defaults, { [repositoryName] = defaults });
-- end

-- ---@param savedVariableName string
-- ---@param repositoryName RepositoryName
-- ---@param schema table
-- function OrbitusApi:AddSchema(savedVariableName, repositoryName, schema)
--   local config = registeredDatabaseConfigs[savedVariableName];
--   local data = metadata[tostring(self)];
--   assert(not data and type(config) == "table",
--     "Unable to modify the database schema after the database has been initialized");
--   config.schemas = Utilities:Assign(config.schemas, { [repositoryName] = schema });
-- end

--------------------------
--> DatabaseMixin:
--------------------------

---@param savedVariableName string
function DatabaseMixin:Init(savedVariableName)
  assert(type(registeredDatabaseConfigs[savedVariableName]) == "table",
    ("Database %s cannot be initialized because it has not been registered"):format(savedVariableName));

  local svTable = _G[savedVariableName];
  assert(type(svTable) == "table",
    ("Database %s failed to initialize because the saved variable table '%s' was not found"):format(savedVariableName));

  assert(type(metadata[tostring(self)]) == nil,
    ("Database %s failed to initialize because it has already been initialized"):format(savedVariableName));

  local profileManager = CreateFromMixins(ProfileManagerMixin);

  ---@type DatabaseMetadata
  local data = {
    svName = savedVariableName;
    config = registeredDatabaseConfigs[savedVariableName];
    database = self;
    indexers = {}
  };

  registeredDatabaseConfigs[savedVariableName] = nil;
  metadata[tostring(self)] = data;
  metadata[tostring(profileManager)] = data;

  for repositoryName, _ in pairs(data.config.repositoryHandlers) do
    CreateAndInitFromMixin(RepositoryMixin, self, repositoryName);
  end

  for repositoryName, handler in pairs(data.config.repositoryHandlers) do
    if (handler.ConfigureIndexer) then
      handler.ConfigureIndexer(self, {
        RebuildIndex = function()
          local repository = self[repositoryName]; ---@type RepositoryMixin
          local repoDefaults = data.config.defaults[repositoryName];
          local repoSv = handler.GetSavedVariableTable(svTable, self);

          local currentIndexer = data.indexers[repository];
          local newIndexer = Utilities:BuildIndex(repoDefaults, repoSv);
          return Utilities:GetIndexerChanges(currentIndexer, newIndexer);
        end
      });
    end
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

--------------------------
--> ProfileManagerMixin:
--------------------------
---@param callback OnProfileChanged
function ProfileManagerMixin:OnProfileChanged(callback)
  Utilities:AddCallback(self, "profileChanged", callback);
end

---@param callback OnProfileListChanged
function ProfileManagerMixin:OnProfileListChanged(callback)
  Utilities:AddCallback(self, "profileListChanged", callback);
end

---@param callback OnBinListChanged
function ProfileManagerMixin:OnBinListChanged(callback)
  Utilities:AddCallback(self, "binListChanged", callback);
end

---@return string
function ProfileManagerMixin:GetActive()
  local data = metadata[tostring(self)];
  local profileKeys = Utilities:GetSavedVariableSubTable(self, "profileKeys");

  local characterName = UnitFullName("player");
  assert(type(characterName) == "string", "Failed to get active profile; invalid character name");
  return profileKeys[characterName] or data.config.repositoryHandlers.profile.GetDefaultKey();
end

---@param profileName string
---@return boolean
function ProfileManagerMixin:Exists(profileName)
  local profiles = Utilities:GetSavedVariableSubTable(self, "profiles");
  return type(profiles[profileName]) == "table";
end

---@param profileName string
---@return boolean
function ProfileManagerMixin:IsInBin(profileName)
  local bin = Utilities:GetSavedVariableSubTable(self, "bin");
  return type(bin[profileName]) == "table";
end

---@param profileName string
function ProfileManagerMixin:SetActive(profileName)
  local characterName = UnitFullName("player");
  assert(type(characterName) == "string", "Failed to set active profile; invalid character name");

  local oldProfileName = self:GetActive();

  if (oldProfileName == profileName) then return end

  local profileKeys = Utilities:GetSavedVariableSubTable(self, "profileKeys");
  local profiles = Utilities:GetSavedVariableSubTable(self, "profiles");
  profileKeys[characterName] = profileName;

  if (type(profiles[profileName]) ~= "table") then
    profiles[profileName] = {};
    Utilities:TriggerCallback(self, "profileListChanged");
  end

  Utilities:TriggerCallback(self, "profileChanged", profileName, oldProfileName);
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

  Utilities:TriggerCallback(self, "profileListChanged");

  local bin = Utilities:GetSavedVariableSubTable(self, "bin");
  bin[profileName] = {
    expiry = GetServerTime() + 604800, -- add 7 days (in seconds)
    data = profileData
  };

  Utilities:TriggerCallback(self, "binListChanged");

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
  bin[profileName] = nil;

  return true;
end

function ProfileManagerMixin:Export(profileName)
  local profiles = Utilities:GetSavedVariableSubTable(self, "profiles");
  local profileData = profiles[profileName];

  assert(type(profileData) == "table", ("Failed to export unknown profile '%s'"):format(profileName));

  local rawStr = Utilities:Serialize(profileData);
  local compressed = LibDeflate:CompressDeflate(rawStr);
  local profileDataString = LibDeflate:EncodeForPrint(compressed);
  return profileDataString;
end

local fetcherPattern = "return function() return { %s }; end";
local loadstring = _G.loadstring;

function ProfileManagerMixin:Import(profileName, profileDataString, force)
  local profiles = Utilities:GetSavedVariableSubTable(self, "profiles");

  assert(type(profiles[profileName]) ~= "table" or force,
    ("Failed to import profile '%s'; a profile with that name already exists"):format(profileName));

  local compressed = LibDeflate:DecodeForPrint(profileDataString);
  local decompressed = LibDeflate:DecompressDeflate(compressed);

  local fetcher = loadstring(fetcherPattern:format(decompressed)); ---@cast fetcher function
  local profileData = fetcher()(); ---@cast profileData table

  profiles[profileName] = profileData;
end

--------------------------
--> RepositoryMixin:
--------------------------

---comment
---@param database DatabaseMetadata
---@param repositoryName RepositoryName
function RepositoryMixin:Init(database, repositoryName)
  local data = metadata[tostring(database)];
  metadata[tostring(self)] = data;
  database[repositoryName] = self;

  local repoSv = Utilities:GetRepositoryTable(self);

  -- Apply Schema
  local schema = data.config.schemas[repositoryName];
  if (type(schema) == "table") then
    Utilities:ApplySchema(schema, repoSv);
  end

  local repoDefaults = data.config.defaults[repositoryName];
  if (type(repoDefaults) == "table") then
    Utilities:ApplyDefaults(repoDefaults, repoSv);
  end

  -- Create Indexer
  data.indexers[repositoryName] = Utilities:BuildIndex(repoDefaults, repoSv);
end

---@return string
function RepositoryMixin:GetRepositoryName()
  local data = metadata[tostring(self)];
  local database = data.database;

  for key, value in pairs(database) do
    if (value == self) then
      return key;
    end
  end

  return "";
end

---@param query string
---@param observer OrbitusObserver
function RepositoryMixin:Subscribe(query, observer)
  local data = metadata[tostring(self)];
  local dbObservers = data.config.observers;

  local repositoryName = self:GetRepositoryName();
  dbObservers[repositoryName] = dbObservers[repositoryName] or {};

  local observers = dbObservers[repositoryName];
  local normalizedQuery = Utilities:NormalizeQuery(query);

  observers[normalizedQuery] = observers[normalizedQuery] or {};
  local list = observers[normalizedQuery];
  list[#list+1] = observer;
end

---@param query string
function RepositoryMixin:Query(query)
  Utilities:VerifyArgs(query, "string");
  local repositoryName = self:GetRepositoryName();
  local data = metadata[tostring(self)];
  local indexer = data.indexers[repositoryName];
  local normalizedQuery = Utilities:NormalizeQuery(query);
  return indexer[normalizedQuery];
end

function RepositoryMixin:Store(query, value)
  Utilities:VerifyArgs(query, "string");
  local normalizedQuery = Utilities:NormalizeQuery(query);

  if (type(value) == "table") then
    local flattened = Utilities:Flatten(value);

    for key, nestedValue in pairs(flattened) do
      local nestedQuery;

      if (key:sub(1, 1) == "[") then
        nestedQuery = query .. key;
      else
        nestedQuery = query .. "." .. key;
      end

      self:Store(nestedQuery, nestedValue);
    end

    return
  end

  local repositoryName = self:GetRepositoryName();
  local data = metadata[tostring(self)];
  local indexer = data.indexers[repositoryName];

  local previousValue = indexer[normalizedQuery];
  indexer[normalizedQuery] = value;

  if (previousValue ~= value) then
    self:NotifyChange(normalizedQuery, previousValue, value);
  end
end

function RepositoryMixin:NotifyChange(query, previousValue, newValue)
  local normalizedQuery = Utilities:NormalizeQuery(query);
  local repoSv = Utilities:GetRepositoryTable(self);
  Utilities:Persist(repoSv, normalizedQuery, newValue);

  local data = metadata[tostring(self)];
  local repositoryName = self:GetRepositoryName();
  local observers = data.config.observers[repositoryName];

  local queryableList = Utilities:ToQueryableList(normalizedQuery);
  local prefix;

  for _, key in pairs(queryableList) do
    local currentKey;

    if type(key) == "number" then
      currentKey = ("%s[%d]"):format(prefix or "", key);
    elseif (prefix) then
      currentKey = ("%s.%s"):format(prefix, key);
    else
      currentKey = key;
    end

    local notifiers = observers[currentKey];
    if (type(notifiers) == "table") then
      for _, notifier in ipairs(notifiers) do
        notifier(query, newValue, previousValue);
      end
    end

    prefix = currentKey;
  end
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
  local name = repository:GetRepositoryName();
  local handler = data.config.repositoryHandlers[name];
  return handler.GetSavedVariableTable(_G[data.svName], data.database);
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
    callback(obj, ...);
  end
end

do
  local normalizePattern = "%[%s-['\"]([^%[\"']*)['\"]%s-%]";
  local removeIndexesPattern = "%[%s-%d+%s-%]";
  local matchIndexesPattern = "%[%s-(%d+)%s-%]";

  function Utilities:NormalizeQuery(query)
    return query:gsub(normalizePattern, ".%1");
  end

  ---@return QueryableList
  function Utilities:ToQueryableList(query)
    local keys = strsplit(".", query); ---@type string[]
    local list = {}; ---@type QueryableList

    for _, key in ipairs(keys) do
      local sanitizedKey = key:gsub(removeIndexesPattern, "");
      list[#list+1] = sanitizedKey;

      for i in key:gmatch(matchIndexesPattern) do
        local index = tonumber(i);

        assert(type(index) == "number" and index > 0,
          ("Failed to convert query '%s' to queryable list at key %s"):format(query, i));

        list[#list+1] = tonumber(index);
      end
    end

    return list;
  end

  ---@param root table
  ---@param query string
  ---@return any
  function Utilities:Fetch(root, query)
    local normalizedQuery = self:NormalizeQuery(query);
    local queryableList = self:ToQueryableList(normalizedQuery);

    local result = root;
    for _, key in ipairs(queryableList) do
      if (type(result) ~= "table") then return nil; end
      result = result[key];
    end

    return result;
  end

  ---@param root table
  ---@param query string
  ---@param value any
  function Utilities:Persist(root, query, value)
    local normalizedQuery = self:NormalizeQuery(query);
    local queryableList = self:ToQueryableList(normalizedQuery);

    local storageTbl = root;
    for i, key in ipairs(queryableList) do
      if (i < #queryableList) then
        if (type(storageTbl[key]) ~= "table") then
          storageTbl[key] = {};
        end

        storageTbl = storageTbl[key];
      else
        -- the last key
        local previousValue = storageTbl[key];
        storageTbl[key] = value;
        return previousValue;
      end
    end
  end
end

function Utilities:Serialize(tbl)
  local str = "{";

  for key, value in pairs(tbl) do
    local keyType = type(key);

    if (keyType == "number" and key > 0) then
      key = ("[%d]"):format(key);
    elseif (keyType == "string" and #key > 0) then
      key = ("[\"%s\"]"):format(key);
    else
      key = nil;
    end

    if (key) then
      local valueType = type(value);

      if (valueType == "table") then
        value = self:Serialize(value);
        valueType = "string";
      elseif (valueType == "string") then
        value = ("\"%s\""):format(value);
      end

      if (valueType == "number" or valueType == "string" or valueType == "boolean") then
        str = ("%s%s=%s,"):format(str, key, value);
      end
    end
  end

  local length = #str;

  if (length > 0) then
    local lastChar = str:sub(length);

    if (lastChar == ",") then
      str = str:sub(1, length - 1);
    end
  end

  str = str .. "}";
  return str;
end

function Utilities:ApplySchema(schema, sv)
  for key, value in pairs(sv) do
    local schemaType = schema[key];

    if (type(schemaType) == "table") then
      schemaType = "table"; -- should be a string or an actual table with more nested schema rules
    end

    local valueType = type(value);

    if (schemaType ~= valueType) then
      sv[key] = nil;
    elseif (valueType == "table") then
      self:ApplySchema(schema[key], value);
    end
  end
end

function Utilities:ApplyDefaults(defaults, sv)
  for key, value in pairs(sv) do
    local defaultValue = defaults[key];
    local defaultType = type(defaultValue);
    local valueType = type(value);
    local matchingType = (defaultType == valueType) and defaultType or nil;

    if (matchingType) then
      if (matchingType == "table") then
        self:ApplyDefaults(defaultValue, value);
      elseif (value == defaultValue) then
        sv[key] = nil;
      end
    end
  end
end

---@param repoDefaults table
---@param repoSv table
---@return table
function Utilities:BuildIndex(repoDefaults, repoSv)
  local indexer = {};
  local flattenedDefaults = self:Flatten(repoDefaults);

  for key, value in pairs(flattenedDefaults) do
    indexer[key] = value;
  end

  local flattenedSv = self:Flatten(repoSv);

  for key, value in pairs(flattenedSv) do
    indexer[key] = value;
  end

  return indexer;
end

---@return IndexerChanges
function Utilities:GetIndexerChanges(from, to)
  local changes = {};

  for key, value in pairs(from) do
    if (value ~= to[key]) then
      changes[key] = { from = value, to = to[key] };
    end
  end

  for key, value in pairs(to) do
    if (from[key] == nil) then
      changes[key] = { from = nil, to = value };
    end
  end

  return changes
end

---@return { [string]: any }
function Utilities:Flatten(inputTable)
  local outputTable = {}

  local function TraverseTable(currentTable, prefix)
    for key, value in pairs(currentTable) do
      local currentKey;

      if type(key) == "number" then
        currentKey = ("%s[%d]"):format(prefix or "", key);
      elseif (prefix) then
        currentKey = ("%s.%s"):format(prefix, key);
      else
        currentKey = key;
      end

      if type(value) == "table" then
        TraverseTable(value, currentKey);
      else
        outputTable[currentKey] = value;
      end
    end
  end

  TraverseTable(inputTable);
  return outputTable;
end