-- luacheck: ignore self
local _G = _G;
local OrbitusDB; ---@class OrbitusDB
local LibDeflate; ---@type LibDeflate

if (_G.LibStub) then
  OrbitusDB = _G.LibStub:NewLibrary("OrbitusDB", 1);
  if (not OrbitusDB) then return end -- no update required

  LibDeflate = _G.LibStub:GetLibrary("LibDeflate");
else
  OrbitusDB = {};
end

---@class RepositoryMixin
local RepositoryMixin = {};

---@class ProfileRepositoryMixin: RepositoryMixin
local ProfileRepositoryMixin = {};

---@class Utilities
local Utilities = {};

---@class DatabaseMixin
---@field profile ProfileRepositoryMixin
---@field global RepositoryMixin
---@field character RepositoryMixin
local DatabaseMixin = {};

---@class IndexActionsMixin
---@field GetIndex fun(self: IndexActionsMixin): Index
---@field RebuildIndex fun(self: IndexActionsMixin)
---@field GetIndexChanges fun(self: IndexActionsMixin, fromIndex: Index, toIndex: Index): IndexChanges
---@field NotifyIndexChanges fun(self: IndexActionsMixin, changes: IndexChanges)
---@field private __repository RepositoryMixin
---@field private Init fun(self: IndexActionsMixin, repository: RepositoryMixin)
local IndexActionsMixin = {};

local UnitFullName, strsplit = _G.UnitFullName, _G.strsplit;
local GetServerTime = _G.GetServerTime;

---@class RepositoryHandler
---@field Mixin table|nil
---@field GetSavedVariableTable fun(sv: table, repository: RepositoryMixin): table
---@field ConfigureIndex fun(repository: RepositoryMixin, actions: IndexActionsMixin)
---@field GetDefaultKey fun(repository: RepositoryMixin): string

---@alias OnInitializedCallback fun(db: DatabaseMixin)
---@alias OnProfileChanged fun(repository: ProfileRepositoryMixin, newProfileName: string, oldProfileName: string)
---@alias OnProfileListChanged fun(repository: ProfileRepositoryMixin)
---@alias OnBinListChanged fun(repository: ProfileRepositoryMixin)
---@alias DatabaseCallbackType "profileChanged"|"profileListChanged"|"binListChanged"
---@alias DatabaseCallback fun(db: DatabaseMixin, ...: any)
---@alias OrbitusObserver fun(query: string, value: any, previousValue: any)
---@alias QueryableList (string|number)[]
---@alias RepositoryName "global"|"profile"|"character"
---@alias IndexChanges { [string]: { from: string|boolean|number|nil, to: string|boolean|number|nil }}
---@alias Index { [string]: string|boolean|number }

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
      GetSavedVariableTable = function(sv, repository)
        ---@cast repository ProfileRepositoryMixin
        local profileName = repository:GetActiveProfile();
        sv.profiles = sv.profiles or {};
        sv.profiles[profileName] = sv.profiles[profileName] or {};
        return sv.profiles[profileName];
      end,

      Mixin = ProfileRepositoryMixin,

      GetDefaultKey = function() return "Default" end,

      ConfigureIndex = function(repository, actions)
        ---@cast repository ProfileRepositoryMixin
        repository:OnProfileChanged(function()
          local index = actions:GetIndex();
          local newIndex = actions:RebuildIndex();
          local changes = actions:GetIndexChanges(index, newIndex);
          actions:NotifyIndexChanges(changes);
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
---@field database DatabaseMixin
---@field config DatabaseConfig
---@field indices { [RepositoryName]: Index }

---@type table<string, DatabaseMetadata>
local metadata = {};

---@type table<string, DatabaseConfig>
local registeredDatabaseConfigs = {};

---@type table<string, OnInitializedCallback>
local onInitializedCallbacks = {};

local CreateAndInitFromMixin = _G.CreateAndInitFromMixin;
local CreateFromMixins = _G.CreateFromMixins;

if (_G.CreateFrame) then
  local dbLoader = _G.CreateFrame("Frame");
  dbLoader:RegisterEvent("ADDON_LOADED");
  dbLoader:SetScript("OnEvent", function()
    for savedVariableName, _ in pairs(registeredDatabaseConfigs) do
      if (type(_G[savedVariableName]) == "table") then
        CreateAndInitFromMixin(DatabaseMixin, savedVariableName);
      end
    end
  end);
end

--------------------------
--> OrbitusDB:
--------------------------

---@param savedVariableName string
---@param databaseConfig DatabaseConfig?
---@param onInitialized OnInitializedCallback
---@overload fun(self, savedVariableName: string, onInitialized: OnInitializedCallback)
function OrbitusDB:Register(savedVariableName, databaseConfig, onInitialized)
  if (type(databaseConfig) == "function" and onInitialized == nil) then
    onInitialized = databaseConfig;
    databaseConfig = nil;
  end

  assert(registeredDatabaseConfigs[savedVariableName] == nil,
    ("Database %s has already been registered"):format(savedVariableName));

  local config = Utilities:Assign(defaultConfig, databaseConfig);
  registeredDatabaseConfigs[savedVariableName] = config;
  onInitializedCallbacks[savedVariableName] = onInitialized;

  if (type(_G[savedVariableName]) == "table") then
    CreateAndInitFromMixin(DatabaseMixin, savedVariableName);
  end
end

---@param savedVariableName string
---@return DatabaseMixin?
function OrbitusDB:GetDatabase(savedVariableName)
  for _, data in pairs(metadata) do
    if (data.svName == savedVariableName) then
      return data.database;
    end
  end
end

--------------------------
--> DatabaseMixin:
--------------------------

---@private
---@param savedVariableName string
function DatabaseMixin:Init(savedVariableName)
  assert(type(registeredDatabaseConfigs[savedVariableName]) == "table",
    ("Database %s cannot be initialized because it has not been registered"):format(savedVariableName));

  local svTable = _G[savedVariableName];
  assert(type(svTable) == "table",
    ("Database %s failed to initialize because the saved variable table was not found"):format(savedVariableName));

  assert(metadata[tostring(self)] == nil,
    ("Database %s failed to initialize because it has already been initialized"):format(savedVariableName));

  ---@type DatabaseMetadata
  local data = {
    svName = savedVariableName;
    config = registeredDatabaseConfigs[savedVariableName];
    database = self;
    indices = {}
  };

  registeredDatabaseConfigs[savedVariableName] = nil;
  metadata[tostring(self)] = data;

  for repositoryName, handler in pairs(data.config.repositoryHandlers) do
    local mixin = RepositoryMixin;

    local handlerMixin = handler.Mixin;
    if (type(handlerMixin) == "table") then
      mixin = CreateFromMixins(handlerMixin, RepositoryMixin);
    end

    CreateAndInitFromMixin(mixin, self, repositoryName);
  end

  for repositoryName, handler in pairs(data.config.repositoryHandlers) do
    if (handler.ConfigureIndex) then
      local actions = CreateAndInitFromMixin(IndexActionsMixin, data, repositoryName, handler);
      handler.ConfigureIndex(self[repositoryName], actions);
    end
  end

  local callback = onInitializedCallbacks[savedVariableName];
  if (callback) then
    callback(self);
  end
end

--------------------------
--> ProfileRepositoryMixin:
--------------------------
---@param callback OnProfileChanged
function ProfileRepositoryMixin:OnProfileChanged(callback)
  Utilities:AddCallback(self, "profileChanged", callback);
end

---@param callback OnProfileListChanged
function ProfileRepositoryMixin:OnProfileListChanged(callback)
  Utilities:AddCallback(self, "profileListChanged", callback);
end

---@param callback OnBinListChanged
function ProfileRepositoryMixin:OnBinListChanged(callback)
  Utilities:AddCallback(self, "binListChanged", callback);
end

---@return string
function ProfileRepositoryMixin:GetActiveProfile()
  local data = metadata[tostring(self)];
  local profileKeys = Utilities:GetSavedVariableSubTable(self, "profileKeys");

  local characterName = UnitFullName("player");
  assert(type(characterName) == "string", "Failed to get active profile; invalid character name");

  local repository = data.database.profile;
  local handler = data.config.repositoryHandlers.profile;
  return profileKeys[characterName] or handler.GetDefaultKey(repository);
end

---@param profileName string
---@return boolean
function ProfileRepositoryMixin:ProfileExists(profileName)
  local profiles = Utilities:GetSavedVariableSubTable(self, "profiles");
  return type(profiles[profileName]) == "table";
end

---@param profileName string
---@return boolean
function ProfileRepositoryMixin:IsProfileInBin(profileName)
  local bin = Utilities:GetSavedVariableSubTable(self, "bin");
  return type(bin[profileName]) == "table";
end

---@param profileName string
function ProfileRepositoryMixin:SetActiveProfile(profileName)
  local characterName = UnitFullName("player");
  assert(type(characterName) == "string", "Failed to set active profile; invalid character name");

  local oldProfileName = self:GetActiveProfile();

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
function ProfileRepositoryMixin:GetAllProfiles()
  local profiles = Utilities:GetSavedVariableSubTable(self, "profiles");

  local profileNames = {};
  for profileName, _ in pairs(profiles) do
    profileNames[#profileNames+1] = profileName;
  end

  return profileNames;
end

function ProfileRepositoryMixin:DeleteProfile(profileName)
  local profiles = Utilities:GetSavedVariableSubTable(self, "profiles");

  if (type(profiles[profileName]) ~= "table") then
    return false;
  end

  local profileData = self:ExportProfile(profileName);
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

function ProfileRepositoryMixin:RenameProfile(profileName, newProfileName, force)
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
function ProfileRepositoryMixin:GetDeletedProfiles()
  local bin = Utilities:GetSavedVariableSubTable(self, "bin");

  local deletedProfiles = {};
  for profileName, _ in pairs(bin) do
    deletedProfiles[#deletedProfiles+1] = profileName;
  end

  return deletedProfiles;
end

function ProfileRepositoryMixin:RestoreProfile(profileName, force)
  local profiles = Utilities:GetSavedVariableSubTable(self, "profiles");

  assert(type(profiles[profileName]) ~= "table" or force,
    ("Failed to restore profile '%s'; a profile with that name already exists"):format(profileName));

  local bin = Utilities:GetSavedVariableSubTable(self, "bin");

  if (type(bin[profileName]) ~= "table") then
    return false;
  end

  local profileDataString = bin[profileName].data;
  self:ImportProfile(profileName, profileDataString);
  bin[profileName] = nil;

  return true;
end

function ProfileRepositoryMixin:ExportProfile(profileName)
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

function ProfileRepositoryMixin:ImportProfile(profileName, profileDataString, force)
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

---@private
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

  -- Create Index
  data.indices[repositoryName] = Utilities:BuildIndex(repoDefaults, repoSv);
end

---@return string
function RepositoryMixin:GetRepositoryName()
  local database = self:GetDatabase();

  for key, value in pairs(database) do
    if (value == self) then
      return key;
    end
  end

  return "";
end

function RepositoryMixin:GetDatabase()
  local data = metadata[tostring(self)];
  return data.database;
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
  local index = data.indices[repositoryName];
  local normalizedQuery = Utilities:NormalizeQuery(query);
  return index[normalizedQuery];
end

function RepositoryMixin:Store(query, value)
  Utilities:VerifyArgs(query, "string");

  local normalizedQuery = Utilities:NormalizeQuery(query);
  local data = metadata[tostring(self)];
  local repositoryName = self:GetRepositoryName();
  local index = data.indices[repositoryName];
  local observers = data.config.observers[repositoryName];
  local changes; ---@type IndexChanges?

  if (type(value) == "table") then
    local flattenedValue = Utilities:Flatten(value);
    local newValues = {};

    for key, newValue in pairs(flattenedValue) do
      local fullKey;

      if (string.sub(key, 1, 1) == "[") then
        fullKey = ("%s%s"):format(normalizedQuery, key);
      else
        fullKey = ("%s.%s"):format(normalizedQuery, key);
      end

      newValues[fullKey] = newValue;
    end

    for subQuery, subValue in pairs(newValues) do
      local previousValue = index[subQuery];
      index[subQuery] = subValue;

      if (previousValue ~= subValue) then
        changes = changes or {};
        changes[subQuery] = { from = subValue, to = previousValue };
      end
    end
  else
    local previousValue = index[normalizedQuery];
    index[normalizedQuery] = value;

    if (previousValue ~= value) then
      changes = {};
      changes[normalizedQuery] = { from = previousValue, to = value }
    end
  end

  if (changes) then
    Utilities:NotifyChanges(self, observers, changes);
  end
end

--------------------------
--> Utilities:
--------------------------

---@param repository RepositoryMixin
---@param observers { [string]: OrbitusObserver[] }
---@param changes IndexChanges
function Utilities:NotifyChanges(repository, observers, changes)
  if (not next(observers)) then return end

  local svTable = self:GetRepositoryTable(repository);

  for query, observer in pairs(observers) do
    local relevantChanges = {};

    if (type(observer) == "table" and #observer > 0) then
      for changeQuery, change in pairs(changes) do
        if (#changeQuery >= #query) then
          local isRelevantChange = changeQuery:sub(1, #query) == query;
          if (isRelevantChange) then
            relevantChanges[changeQuery] = change;
          end
        end
      end

      for _, notifier in ipairs(observer) do
        -- TODO: This returns nil as we haven't stored it
        local value = self:Fetch(svTable, query);
        notifier(value, relevantChanges);
      end
    end
  end
end


local errorTemplate = "bad argument #%d (%s expected, got %s)";

function Utilities:VerifyArgs(...)
  local parameterIndex = 0;

  for i = 1, select("#", ...), 2 do
    parameterIndex = parameterIndex + 1;
    local arg, expectedArgType = select(i, ...);
    ---@cast expectedArgType string
    local actualArgType = type(arg);

    local success = actualArgType == expectedArgType;

    if (expectedArgType:find("|")) then
      local expectedTypes = strsplit("|", expectedArgType);
      expectedArgType = table.concat(expectedTypes, " or ");

      for _, expectedType in ipairs(expectedTypes) do
        success = actualArgType == expectedType;
        if (success) then break end
      end
    end

    assert(success, errorTemplate:format(parameterIndex, expectedArgType, actualArgType));
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
  return handler.GetSavedVariableTable(_G[data.svName], repository);
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
        storageTbl[key] = value;
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

---@param repoDefaults table?
---@param repoSv table
---@return table
function Utilities:BuildIndex(repoDefaults, repoSv)
  self:VerifyArgs(repoDefaults, "table|nil", repoSv, "table");
  local index = {};

  if (type(repoDefaults) == "table") then
    local flattenedDefaults = self:Flatten(repoDefaults);

    for key, value in pairs(flattenedDefaults) do
      index[key] = value;
    end
  end

  local flattenedSv = self:Flatten(repoSv);

  for key, value in pairs(flattenedSv) do
    index[key] = value;
  end

  return index;
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

----------------------
--> IndexActionsMixin
----------------------
function IndexActionsMixin:Init(repository)
  self.__repository = repository;
end

function IndexActionsMixin:GetIndex()
  local repository = self.__repository;
  local data = metadata[tostring(repository)];
  local repositoryName = repository:GetRepositoryName();
  return data.indices[repositoryName];
end

function IndexActionsMixin:RebuildIndex()
  local repository = self.__repository;
  local data = metadata[tostring(repository)];
  local repositoryName = repository:GetRepositoryName();

  local handler = data.config.repositoryHandlers[repositoryName];
  local repoDefaults = data.config.defaults[repositoryName];
  local repoSv = handler.GetSavedVariableTable(_G[data.svName], repository);

  data.indices[repositoryName] = Utilities:BuildIndex(repoDefaults, repoSv);
end

function IndexActionsMixin:NotifyIndexChanges(changes)
  local repository = self.__repository;
  local data = metadata[tostring(repository)];
  local repositoryName = repository:GetRepositoryName();
  local observers = data.config.observers[repositoryName];
  Utilities:NotifyChanges(repository, observers, changes);
end

function IndexActionsMixin:GetIndexChanges(fromIndex, toIndex)
  local changes = {};

  for key, value in pairs(fromIndex) do
    if (value ~= toIndex[key]) then
      changes[key] = { from = value, to = toIndex[key] };
    end
  end

  for key, value in pairs(toIndex) do
    if (fromIndex[key] == nil) then
      changes[key] = { from = nil, to = value };
    end
  end

  return changes;
end


return OrbitusDB;