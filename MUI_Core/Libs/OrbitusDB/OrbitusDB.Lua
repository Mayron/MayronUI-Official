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

---@class UtilitiesMixin
local UtilitiesMixin = {};

---@class RepositoryMixin
local RepositoryMixin = {};

---@class ProfileRepositoryMixin: RepositoryMixin
local ProfileRepositoryMixin = {};

---@class Utilities
local Internal = {};

---@class DatabaseMixin
---@field profile ProfileRepositoryMixin
---@field global RepositoryMixin
---@field character RepositoryMixin
---@field utilities UtilitiesMixin
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
local GetServerTime, unpack = _G.GetServerTime, _G.unpack;

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
---@alias OrbitusObserver fun(value: any, changes: IndexChanges)
---@alias QueryList (string|number)[]
---@alias RepositoryName "global"|"profile"|"character"
---@alias QueryResult string|boolean|number|table|nil
---@alias IndexChanges { [string]: { from: QueryResult, to: QueryResult }}
---@alias Index { [string]: QueryResult }

---@class DatabaseConfig
---@field defaults { [RepositoryName]: table }
---@field schemas { [RepositoryName]: table }
---@field observers { [RepositoryName]: table<string, OrbitusObserver[]> }
---@field repositoryHandlers table<RepositoryName, RepositoryHandler>
---@field svName string

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
  dbLoader:SetScript("OnEvent", function(_, _, loadedAddOn)
    for addOnName, config in pairs(registeredDatabaseConfigs) do
      if (addOnName == loadedAddOn) then
        local db = CreateAndInitFromMixin(DatabaseMixin, config);

        local callback = onInitializedCallbacks[addOnName];
        if (callback) then
          callback(db);
          onInitializedCallbacks[addOnName] = nil;
        end

        registeredDatabaseConfigs[addOnName] = nil;
        break
      end
    end

    if (not next(registeredDatabaseConfigs)) then
      dbLoader:UnregisterAllEvents();
    end
  end);
end

--------------------------
--> OrbitusDB:
--------------------------

---@param addOnName string
---@param savedVariableName string
---@param databaseConfig DatabaseConfig?
---@param onInitialized OnInitializedCallback
---@overload fun(self, savedVariableName: string, onInitialized: OnInitializedCallback)
function OrbitusDB:Register(addOnName, savedVariableName, databaseConfig, onInitialized)
  if (type(databaseConfig) == "function" and onInitialized == nil) then
    onInitialized = databaseConfig;
    databaseConfig = nil;
  end

  assert(registeredDatabaseConfigs[addOnName] == nil,
    ("Database for addOn %s has already been registered"):format(addOnName));

  local config = UtilitiesMixin:MergeTables(defaultConfig, databaseConfig); ---@type DatabaseConfig
  config.svName = savedVariableName;

  registeredDatabaseConfigs[addOnName] = config;
  onInitializedCallbacks[addOnName] = onInitialized;
end

---@param savedVariableName string
---@return DatabaseMixin?
function OrbitusDB:GetDatabase(savedVariableName)
  for _, data in pairs(metadata) do
    if (data.config.svName == savedVariableName) then
      return data.database;
    end
  end
end

--------------------------
--> DatabaseMixin:
--------------------------

---@private
---@param config DatabaseConfig
function DatabaseMixin:Init(config)
  assert(metadata[tostring(self)] == nil,
    ("Database %s failed to initialize because it has already been initialized"):format(config.svName));

  if (type(_G[config.svName]) ~= "table") then
    _G[config.svName] = {};
  end

  ---@type DatabaseMetadata
  local data = {
    config = config;
    database = self;
    indices = {};
  };

  metadata[tostring(self)] = data;
  self.utilities = CreateFromMixins(UtilitiesMixin);

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
end

--------------------------
--> ProfileRepositoryMixin:
--------------------------
---@param callback OnProfileChanged
function ProfileRepositoryMixin:OnProfileChanged(callback)
  Internal:AddCallback(self, "profileChanged", callback);
end

---@param callback OnProfileListChanged
function ProfileRepositoryMixin:OnProfileListChanged(callback)
  Internal:AddCallback(self, "profileListChanged", callback);
end

---@param callback OnBinListChanged
function ProfileRepositoryMixin:OnBinListChanged(callback)
  Internal:AddCallback(self, "binListChanged", callback);
end

---@return string
function ProfileRepositoryMixin:GetActiveProfile()
  local data = metadata[tostring(self)];
  local profileKeys = Internal:GetSavedVariableSubTable(self, "profileKeys");

  local characterName = UnitFullName("player");
  assert(type(characterName) == "string", "Failed to get active profile; invalid character name");

  local repository = data.database.profile;
  local handler = data.config.repositoryHandlers.profile;
  return profileKeys[characterName] or handler.GetDefaultKey(repository);
end

---@param profileName string
---@return boolean
function ProfileRepositoryMixin:ProfileExists(profileName)
  local profiles = Internal:GetSavedVariableSubTable(self, "profiles");
  return type(profiles[profileName]) == "table";
end

---@param profileName string
---@return boolean
function ProfileRepositoryMixin:IsProfileInBin(profileName)
  local bin = Internal:GetSavedVariableSubTable(self, "bin");
  return type(bin[profileName]) == "table";
end

---@param profileName string
function ProfileRepositoryMixin:SetActiveProfile(profileName)
  local characterName = UnitFullName("player");
  assert(type(characterName) == "string", "Failed to set active profile; invalid character name");

  local oldProfileName = self:GetActiveProfile();

  if (oldProfileName == profileName) then return end

  local profileKeys = Internal:GetSavedVariableSubTable(self, "profileKeys");
  local profiles = Internal:GetSavedVariableSubTable(self, "profiles");
  profileKeys[characterName] = profileName;

  if (type(profiles[profileName]) ~= "table") then
    profiles[profileName] = {};
    Internal:TriggerCallback(self, "profileListChanged");
  end

  Internal:TriggerCallback(self, "profileChanged", profileName, oldProfileName);
end

---@return string[]
function ProfileRepositoryMixin:GetAllProfiles()
  local profiles = Internal:GetSavedVariableSubTable(self, "profiles");

  local profileNames = {};
  for profileName, _ in pairs(profiles) do
    profileNames[#profileNames+1] = profileName;
  end

  return profileNames;
end

function ProfileRepositoryMixin:DeleteProfile(profileName)
  local profiles = Internal:GetSavedVariableSubTable(self, "profiles");

  if (type(profiles[profileName]) ~= "table") then
    return false;
  end

  local profileData = self:ExportProfile(profileName);
  profiles[profileName] = nil;

  Internal:TriggerCallback(self, "profileListChanged");

  local bin = Internal:GetSavedVariableSubTable(self, "bin");
  bin[profileName] = {
    expiry = GetServerTime() + 604800, -- add 7 days (in seconds)
    data = profileData
  };

  Internal:TriggerCallback(self, "binListChanged");

  return true;
end

function ProfileRepositoryMixin:RenameProfile(profileName, newProfileName, force)
  local profiles = Internal:GetSavedVariableSubTable(self, "profiles");
  local profileKeys = Internal:GetSavedVariableSubTable(self, "profileKeys");

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
  local bin = Internal:GetSavedVariableSubTable(self, "bin");

  local deletedProfiles = {};
  for profileName, _ in pairs(bin) do
    deletedProfiles[#deletedProfiles+1] = profileName;
  end

  return deletedProfiles;
end

function ProfileRepositoryMixin:RestoreProfile(profileName, force)
  local profiles = Internal:GetSavedVariableSubTable(self, "profiles");

  assert(type(profiles[profileName]) ~= "table" or force,
    ("Failed to restore profile '%s'; a profile with that name already exists"):format(profileName));

  local bin = Internal:GetSavedVariableSubTable(self, "bin");

  if (type(bin[profileName]) ~= "table") then
    return false;
  end

  local profileDataString = bin[profileName].data;
  self:ImportProfile(profileName, profileDataString);
  bin[profileName] = nil;

  return true;
end

function ProfileRepositoryMixin:ExportProfile(profileName)
  local profiles = Internal:GetSavedVariableSubTable(self, "profiles");
  local profileData = profiles[profileName];

  assert(type(profileData) == "table", ("Failed to export unknown profile '%s'"):format(profileName));

  local rawStr = UtilitiesMixin:Serialize(profileData);
  local compressed = LibDeflate:CompressDeflate(rawStr);
  local profileDataString = LibDeflate:EncodeForPrint(compressed);
  return profileDataString;
end

do
  local fetcherPattern = "return function() return { %s }; end";
  local loadstring = _G.loadstring;

  function ProfileRepositoryMixin:ImportProfile(profileName, profileDataString, force)
    local profiles = Internal:GetSavedVariableSubTable(self, "profiles");

    assert(type(profiles[profileName]) ~= "table" or force,
      ("Failed to import profile '%s'; a profile with that name already exists"):format(profileName));

    local compressed = LibDeflate:DecodeForPrint(profileDataString);
    local decompressed = LibDeflate:DecompressDeflate(compressed);

    local fetcher = loadstring(fetcherPattern:format(decompressed)); ---@cast fetcher function
    local profileData = fetcher()(); ---@cast profileData table

    profiles[profileName] = profileData;
  end
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
  Internal:BuildIndex(self);
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
  local normalizedQuery = UtilitiesMixin:NormalizeQuery(query);

  observers[normalizedQuery] = observers[normalizedQuery] or {};
  local list = observers[normalizedQuery];
  list[#list+1] = observer;
end

---@generic T
---@param resultType `T`
---@param ... (string|number)
---@return T
---@nodiscard
function RepositoryMixin:QueryType(resultType, ...)
  local result = self:Query(...);

  if (resultType) then
    UtilitiesMixin:VerifyVar("result", result, resultType);
  end

  return result;
end

---@param ... (string|number)
---@return QueryResult
---@nodiscard
function RepositoryMixin:Query(...)
  local query = UtilitiesMixin:ToQueryString(...);
  local repositoryName = self:GetRepositoryName();
  local data = metadata[tostring(self)];

  local index = data.indices[repositoryName];
  local result = index[query];

  if (type(result) == "table") then
    return UtilitiesMixin:MergeTables(result);
  end

  return result;
end

---@param query string
---@param value any
function RepositoryMixin:Store(query, value)
  UtilitiesMixin:VerifyArgs(query, "string");
  local normalizedQuery = UtilitiesMixin:NormalizeQuery(query);
  local data = metadata[tostring(self)];
  local repositoryName = self:GetRepositoryName();
  local index = data.indices[repositoryName];
  local observers = data.config.observers[repositoryName];
  local changes; ---@type IndexChanges?

  if (type(value) == "table") then
    local flattenedValue = UtilitiesMixin:Flatten(value);
    local newValues = {};

    for key, newValue in pairs(flattenedValue) do
      local fullKey;

      if (key:sub(1, 1) == "[") then
        fullKey = ("%s%s"):format(normalizedQuery, key);
      else
        fullKey = ("%s.%s"):format(normalizedQuery, key);
      end

      newValues[fullKey] = newValue;
    end

    for subQuery, subValue in pairs(newValues) do
      local previousValue = index[subQuery];

      for key, _ in pairs(index) do
        if (subQuery:sub(1, #key) == key) then
          index[key] = nil;
        end
      end

      index[subQuery] = subValue;

      if (previousValue ~= subValue) then
        changes = changes or {};
        changes[subQuery] = { from = previousValue, to = subValue };
      end
    end
  else
    local previousValue = index[normalizedQuery];

    for key, _ in pairs(index) do
      if (normalizedQuery:sub(1, #key) == key) then
        index[key] = nil;
      end
    end

    index[normalizedQuery] = value;

    if (previousValue ~= value) then
      changes = {};
      changes[normalizedQuery] = { from = previousValue, to = value }
    end
  end

  if (changes) then
    local svTable = Internal:GetRepositoryTable(self);

    -- Actually store the changes:
    for path, change in pairs(changes) do
      UtilitiesMixin:Store(svTable, path, change.to);
    end

    Internal:NotifyChanges(svTable, observers, changes);
  end
end

----------------------
--> UtilitiesMixin
----------------------
---@param tbl table
---@param query string
---@return any
function UtilitiesMixin:Query(tbl, query)
  local normalizedQuery = self:NormalizeQuery(query);
  local queryableList = self:ToQueryList(normalizedQuery);

  local result = tbl;

  for _, key in ipairs(queryableList) do
    if (type(result) ~= "table") then
      return nil;
    end

    result = result[key];
  end

  return result;
end

---@param tbl table
---@param query string
---@param value any
function UtilitiesMixin:Store(tbl, query, value)
  local normalizedQuery = self:NormalizeQuery(query);
  local queryableList = self:ToQueryList(normalizedQuery);

  local storageTbl = tbl;
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

---@return table
function UtilitiesMixin:MergeTables(...)
  local merged = {};

  for i = 1, select("#", ...) do
    local tbl = (select(i, ...));

    if (type(tbl) == "table") then
      for key, value in pairs(tbl) do
        if (type(value) == "table") then
          merged[key] = self:MergeTables(value);
        else
          merged[key] = value;
        end
      end
    end
  end

  return merged;
end

---@return { [string]: any }
function UtilitiesMixin:Flatten(inputTable)
  local outputTable = {}

  local function TraverseTable(currentTable, prefix)
    for key, value in pairs(currentTable) do
      local currentKey;

      if (type(key) == "number") then
        currentKey = ("%s[%d]"):format(prefix or "", key);
      elseif (prefix) then
        currentKey = ("%s.%s"):format(prefix, key);
      else
        currentKey = key;
      end

      outputTable[currentKey] = value;

      if (type(value) == "table") then
        TraverseTable(value, currentKey);
      end
    end
  end

  TraverseTable(inputTable);
  return outputTable;
end

function UtilitiesMixin:Serialize(tbl)
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

do
  local normalizePattern = "%[%s*['\"](.-)['\"]%s*%]";
  local removeIndexesPattern = "%[%s*%d+%s*%]";
  local matchIndexesPattern = "%[%s*(%d+)%s*%]";

  function UtilitiesMixin:NormalizeQuery(query)
    self:VerifyArgsByName("query", query, "string");
    query = query:trim():gsub(normalizePattern, ".%1");

    if (query:sub(1, 1) == ".") then
      query = query:sub(2, #query);
    end

    return query;
  end

---@param ... (string|number)
---@return string
---@overload fun(self, list: QueryList)
function UtilitiesMixin:ToQueryString(...)
  local query = "";

  for i = 1, select("#", ...) do
    local arg = (select(i, ...));

    if (i == 1 and type(arg) == "table") then
      return self:ToQueryString(unpack(arg));
    end

    arg = UtilitiesMixin:VerifyArg(i, arg, "string|number");

    if (type(arg) == "number") then
      query = ("%s[%d]"):format(query, arg);
    else
      ---@cast arg string
      if (arg:sub(1, 1) == ".") then
        query = ("%s%s"):format(query, arg);
      else
        query = ("%s.%s"):format(query, arg);
      end
    end
  end

  return UtilitiesMixin:NormalizeQuery(query);
end

  ---@param query string
  ---@return QueryList
  function UtilitiesMixin:ToQueryList(query)
    self:VerifyArgsByName("query", query, "string");
    local keys = strsplit(".", query); ---@type string[]
    local list = {}; ---@type QueryList

    for _, key in ipairs(keys) do
      local sanitizedKey = key:gsub(removeIndexesPattern, "");

      if (#sanitizedKey > 0) then
        list[#list+1] = sanitizedKey;
      end

      for i in key:gmatch(matchIndexesPattern) do
        local index = tonumber(i);

        assert(type(index) == "number" and index > 0,
          ("Failed to convert query '%s' to queryable list at key %s"):format(query, i));

        list[#list+1] = tonumber(index);
      end
    end

    return list;
  end
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
  Internal:BuildIndex(self.__repository);
end

function IndexActionsMixin:NotifyIndexChanges(changes)
  local repository = self.__repository;
  local data = metadata[tostring(repository)];
  local repositoryName = repository:GetRepositoryName();
  local observers = data.config.observers[repositoryName];
  local svTable = Internal:GetRepositoryTable(repository);

  Internal:NotifyChanges(svTable, observers, changes);
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

do
  local errorArgIndexTemplate = "bad argument #%d (%s expected, got %s)";
  local errorArgNameTemplate = "bad argument '%s' (%s expected, got %s)";
  local errorValTemplate = "bad value '%s' (%s expected, got %s)";

  local function IsValidType(value, expectedType)
    local actualType = type(value);

    if (expectedType:find("|")) then
      local expectedTypes = strsplit("|", expectedType);

      for _, t in ipairs(expectedTypes) do
        if (actualType == t) then
          return true;
        end
      end
    end

    return actualType == expectedType;
  end

  ---@generic T
  ---@param variableName string
  ---@param value any
  ---@param expectedType `T`
  ---@return T value
  function UtilitiesMixin:VerifyVar(variableName, value, expectedType)
    local isValid = IsValidType(value, expectedType);

    if (not isValid) then
      expectedType = string.gsub(expectedType, "|", " or ");
      error(errorValTemplate:format(variableName, expectedType, type(value)));
    end

    return value;
  end

  ---@generic T
  ---@param parameter number|string
  ---@param arg any
  ---@param expectedArgType `T`
  ---@return T arg
  function UtilitiesMixin:VerifyArg(parameter, arg, expectedArgType)
    local isValid = IsValidType(arg, expectedArgType);

    if (not isValid) then
      expectedArgType = string.gsub(expectedArgType, "|", " or ");

      local template = (type(parameter) == "number") and errorArgIndexTemplate or errorArgNameTemplate
      error(template:format(parameter, expectedArgType, type(arg)));
    end

    return arg;
  end
end

function UtilitiesMixin:VerifyArgs(...)
  local parameterIndex = 0;

  for i = 1, select("#", ...), 2 do
    parameterIndex = parameterIndex + 1;
    local arg, expectedArgType = select(i, ...);
    self:VerifyArg(parameterIndex, arg, expectedArgType);
  end
end

function UtilitiesMixin:VerifyArgsByName(...)
  for i = 1, select("#", ...), 3 do
    local name, arg, expectedArgType = select(i, ...);
    self:VerifyArg(name, arg, expectedArgType);
  end
end

--------------------------
--> Internal:
--------------------------
---@param root table
---@param observers { [string]: OrbitusObserver[] }
---@param changes IndexChanges
function Internal:NotifyChanges(root, observers, changes)
  if (not next(observers)) then return end

  for query, observer in pairs(observers) do
    local relevantChanges = nil;

    if (type(observer) == "table" and #observer > 0) then
      for changeQuery, change in pairs(changes) do
        if (#changeQuery >= #query) then
          local isRelevantChange = changeQuery:sub(1, #query) == query;

          if (isRelevantChange) then
            relevantChanges = relevantChanges or {};
            relevantChanges[changeQuery] = change;
          end
        end
      end

      if (relevantChanges) then
        for _, notifier in ipairs(observer) do
          local value = UtilitiesMixin:Query(root, query);
          notifier(value, relevantChanges);
        end
      end
    end
  end
end

---@param repository RepositoryMixin
function Internal:GetRepositoryTable(repository)
  local data = metadata[tostring(repository)];
  local name = repository:GetRepositoryName();
  local handler = data.config.repositoryHandlers[name];
  return handler.GetSavedVariableTable(_G[data.config.svName], repository);
end

function Internal:GetSavedVariableSubTable(obj, tblName)
  local data = metadata[tostring(obj)];
  local sv = _G[data.config.svName];
  sv[tblName] = sv[tblName] or {};
  return sv[tblName];
end

---@param callbackName DatabaseCallbackType
function Internal:AddCallback(obj, callbackName, callback)
  local data = metadata[tostring(obj)];
  data.callbacks = data.callbacks or {};
  data.callbacks[callbackName] = data.callbacks[callbackName] or {};
  local list = data.callbacks[callbackName];
  list[#list+1] = callback;
end

---@param callbackName DatabaseCallbackType
function Internal:TriggerCallback(obj, callbackName, ...)
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


function Internal:ApplySchema(schema, sv)
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

function Internal:ApplyDefaults(defaults, sv)
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

---@param repository RepositoryMixin
function Internal:BuildIndex(repository)
  local data = metadata[tostring(repository)];
  local repositoryName = repository:GetRepositoryName();
  local repoSv = self:GetRepositoryTable(repository);
  local repoDefaults = data.config.defaults[repositoryName];
  local indexDefaults, indexSavedVariables;

  if (type(repoDefaults) == "table") then
    Internal:ApplyDefaults(repoDefaults, repoSv);
    indexDefaults = UtilitiesMixin:Flatten(repoDefaults);
  end

  -- Apply Schema
  local schema = data.config.schemas[repositoryName];
  if (type(schema) == "table") then
    Internal:ApplySchema(schema, repoSv);
  end

  -- Create Index
  indexSavedVariables = UtilitiesMixin:Flatten(repoSv);

  local index = UtilitiesMixin:MergeTables(indexDefaults, indexSavedVariables);
  data.indices[repositoryName]  = index;
end

return OrbitusDB;