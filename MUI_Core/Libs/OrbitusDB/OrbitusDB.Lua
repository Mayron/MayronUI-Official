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

---@class OrbitusDB.UtilitiesMixin
---@field db OrbitusDB.DatabaseMixin
local UtilitiesMixin = {};

---@class OrbitusDB.RepositoryMixin
local RepositoryMixin = {};

---@class OrbitusDB.ProfileRepositoryMixin: OrbitusDB.RepositoryMixin
local ProfileRepositoryMixin = {};

---@class OrbitusDB.CharacterRepositoryMixin: OrbitusDB.RepositoryMixin
local CharacterRepositoryMixin = {};

---@class Utilities
local Internal = {};

---@class OrbitusDB.DatabaseMixin
---@field profile OrbitusDB.ProfileRepositoryMixin
---@field global OrbitusDB.RepositoryMixin
---@field character OrbitusDB.CharacterRepositoryMixin
---@field utilities OrbitusDB.UtilitiesMixin
local DatabaseMixin = {};

---@class OrbitusDB.IndexActionsMixin
---@field GetIndex fun(self: OrbitusDB.IndexActionsMixin): OrbitusDB.Index
---@field RebuildIndex fun(self: OrbitusDB.IndexActionsMixin): OrbitusDB.Index
---@field GetIndexChanges fun(self: OrbitusDB.IndexActionsMixin, fromIndex: OrbitusDB.Index, toIndex: OrbitusDB.Index): OrbitusDB.IndexChanges
---@field NotifyIndexChanges fun(self: OrbitusDB.IndexActionsMixin, changes: OrbitusDB.IndexChanges)
---@field private __repository OrbitusDB.RepositoryMixin
---@field private Init fun(self: OrbitusDB.IndexActionsMixin, repository: OrbitusDB.RepositoryMixin)
local IndexActionsMixin = {};

local UnitFullName, strtrim = _G.UnitFullName, _G.strtrim;
local GetServerTime, unpack = _G.GetServerTime, _G.unpack;
local IsAddOnLoaded, UnitClass, UnitLevel, UnitFactionGroup =
  _G.IsAddOnLoaded, _G.UnitClass, _G.UnitLevel, _G.UnitFactionGroup;

local GetCurrentCharacterName;

do
  local currentCharacter;

  GetCurrentCharacterName = function()
    if (currentCharacter ~= nil) then
      -- when logging out, real is missing so we need to cache it
      return currentCharacter;
    end

    local characterName, realm = UnitFullName("player");
    assert(type(characterName) == "string", "Failed to get the player's character name.");

    if (type(realm) == "string" and #realm > 0) then
      characterName = characterName.."-"..realm;
      currentCharacter = characterName;
    end

    return characterName;
  end
end

---@class OrbitusDB.RepositoryHandler
---@field Mixin table|nil
---@field GetSavedVariableTable fun(sv: table, repository: OrbitusDB.RepositoryMixin): table
---@field ConfigureIndex fun(repository: OrbitusDB.RepositoryMixin, actions: OrbitusDB.IndexActionsMixin)
---@field GetDefaultKey fun(repository: OrbitusDB.RepositoryMixin): string

---@alias OrbitusDB.OnInitializedCallback fun(db: OrbitusDB.DatabaseMixin)
---@alias OrbitusDB.OnProfileChanged fun(repository: OrbitusDB.ProfileRepositoryMixin, newProfileName: string, oldProfileName: string)
---@alias OrbitusDB.OnProfileListChanged fun(repository: OrbitusDB.ProfileRepositoryMixin)
---@alias OrbitusDB.OnBinListChanged fun(repository: OrbitusDB.ProfileRepositoryMixin)
---@alias OrbitusDB.DatabaseCallbackType "profileChanged"|"profileListChanged"|"binListChanged"
---@alias OrbitusDB.DatabaseCallback fun(db: OrbitusDB.DatabaseMixin, ...: any)
---@alias OrbitusDB.Observer fun(value: any, changes: OrbitusDB.IndexChanges)
---@alias OrbitusDB.QueryList (string|number)[]
---@alias OrbitusDB.RepositoryName "global"|"profile"|"character"
---@alias OrbitusDB.QueryResult string|boolean|number|table|nil
---@alias OrbitusDB.IndexChanges { [string]: { from: OrbitusDB.QueryResult, to: OrbitusDB.QueryResult }}
---@alias OrbitusDB.Index { [string]: OrbitusDB.QueryResult }

---@class OrbitusDB.DatabaseConfig
---@field defaults { [OrbitusDB.RepositoryName]: table }
---@field schemas { [OrbitusDB.RepositoryName]: table }
---@field observers { [OrbitusDB.RepositoryName]: table<string, OrbitusDB.Observer[]> }
---@field repositoryHandlers table<OrbitusDB.RepositoryName, OrbitusDB.RepositoryHandler>
---@field svName string

---@type OrbitusDB.DatabaseConfig
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
        ---@cast repository OrbitusDB.ProfileRepositoryMixin
        local profileName = repository:GetActiveProfile();
        sv.profiles = sv.profiles or {};
        sv.profiles[profileName] = sv.profiles[profileName] or {};
        return sv.profiles[profileName];
      end,

      Mixin = ProfileRepositoryMixin,

      GetDefaultKey = function() return "Default" end,

      ConfigureIndex = function(repository, actions)
        ---@cast repository OrbitusDB.ProfileRepositoryMixin
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
        local characterName = GetCurrentCharacterName();

        sv.characters = sv.characters or {};
        sv.characters[characterName] = sv.characters[characterName] or {};

        local characterTbl = sv.characters[characterName];

        local _, classFileName = UnitClass("player");
        characterTbl.__class = classFileName;
        characterTbl.__level = UnitLevel("player");
        characterTbl.__faction = UnitFactionGroup("player");

        return characterTbl;
      end,

      Mixin = CharacterRepositoryMixin,
    },
  }
};

---@class OrbitusDB.DatabaseMetadata
---@field callbacks table<OrbitusDB.DatabaseCallbackType, OrbitusDB.DatabaseCallback[]>
---@field database OrbitusDB.DatabaseMixin
---@field config OrbitusDB.DatabaseConfig
---@field defaults { [OrbitusDB.RepositoryName]: OrbitusDB.Index }
---@field indices { [OrbitusDB.RepositoryName]: OrbitusDB.Index }

---@type table<string, OrbitusDB.DatabaseMetadata>
local metadata = {};

---@class OrbitusDB.Registration
---@field config OrbitusDB.DatabaseConfig
---@field callback OrbitusDB.OnInitializedCallback

---@type table<string, table<string, OrbitusDB.Registration>>
local registrar = {};

local CreateAndInitFromMixin = _G.CreateAndInitFromMixin;
local CreateFromMixins = _G.CreateFromMixins;

---@param addOnName string
local function LoadDatabase(addOnName, svName)
  local registration = registrar[addOnName][svName];
  local db = CreateAndInitFromMixin(DatabaseMixin, registration.config);

  if (registration.callback) then
    registration.callback(db);
  end
end

if (_G.CreateFrame) then
  local dbLoader = _G.CreateFrame("Frame");
  dbLoader:RegisterEvent("ADDON_LOADED");
  dbLoader:SetScript("OnEvent", function(_, _, loadedAddOn)
    for addOnName, svNames in pairs(registrar) do
      if (addOnName == loadedAddOn) then
        for svName, _ in pairs(svNames) do
          LoadDatabase(addOnName, svName);
        end

        registrar[addOnName] = nil;
        break
      end
    end

    if (not next(registrar)) then
      dbLoader:UnregisterAllEvents();
    end
  end);
end

--------------------------
--> OrbitusDB:
--------------------------

---@param addOnName string
---@param databaseConfig OrbitusDB.DatabaseConfig
---@param onInitialized OrbitusDB.OnInitializedCallback
function OrbitusDB:Register(addOnName, databaseConfig, onInitialized)
  local config = UtilitiesMixin:MergeTables(defaultConfig, databaseConfig); ---@type OrbitusDB.DatabaseConfig

  ---@type OrbitusDB.Registration
  local registration = {
    config = config;
    callback = onInitialized;
  };

  if (not registrar[addOnName]) then
    registrar[addOnName] = {};
  end

  registrar[addOnName][databaseConfig.svName] = registration;

  if (IsAddOnLoaded(addOnName)) then
    LoadDatabase(addOnName, databaseConfig.svName);
  end
end

---@param savedVariableName string
---@param silent boolean?
---@return OrbitusDB.DatabaseMixin
function OrbitusDB:GetDatabase(savedVariableName, silent)
  for _, data in pairs(metadata) do
    if (data.config.svName == savedVariableName) then
      return data.database;
    end
  end

  if (not silent) then
    error("Failed to find database "..savedVariableName);
  end
end

function OrbitusDB:IterateDatabases()
  local id = 0;
  local databases = UtilitiesMixin:PopTable();

  for _, data in pairs(metadata) do
    if (data.database) then
      local value = UtilitiesMixin:PopTable();
      value[1] = data.config.svName;
      value[2] = data.database;
      table.insert(databases, value);
    end
  end

  return function()
    id = id + 1;

    if (id <= #databases) then
      local name, database = unpack(databases[id]);
      ---@cast name string
      ---@cast database OrbitusDB.DatabaseMixin
      UtilitiesMixin:PushTable(databases[id]);

      if (id == #databases) then
        UtilitiesMixin:PushTable(databases);
      end

      return name, database;
    end
  end
end

--------------------------
--> DatabaseMixin:
--------------------------

---@private
---@param config OrbitusDB.DatabaseConfig
function DatabaseMixin:Init(config)
  assert(metadata[tostring(self)] == nil,
    ("Database %s failed to initialize because it has already been initialized"):format(config.svName));

  if (type(_G[config.svName]) ~= "table") then
    _G[config.svName] = {};
  end

  ---@type OrbitusDB.DatabaseMetadata
  local data = {
    config = config;
    database = self;
    indices = {};
    defaults = {};
  };

  metadata[tostring(self)] = data;
  self.utilities = CreateFromMixins(UtilitiesMixin);
  self.utilities.db = self;

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
      local actions = CreateAndInitFromMixin(IndexActionsMixin, self[repositoryName]);
      handler.ConfigureIndex(self[repositoryName], actions);
    end
  end
end

--------------------------
--> CharacterRepositoryMixin:
--------------------------
---@nodiscard
---@return string[]
function CharacterRepositoryMixin:GetAllCharacters()
  local characters = Internal:GetSavedVariableSubTable(self, "characters");

  local characterNames = UtilitiesMixin:PopTable();
  for characterName, _ in pairs(characters) do
    characterNames[#characterNames+1] = characterName;
  end

  return characterNames;
end

---@nodiscard
---@return string characterName, string classFileName, number level, string faction
function CharacterRepositoryMixin:GetCurrentCharacterInfo()
  local characterName = GetCurrentCharacterName();
  return characterName, self:GetCharacterInfo(characterName);
end

---@param characterName string
---@nodiscard
---@return string classFileName, number level, string faction
function CharacterRepositoryMixin:GetCharacterInfo(characterName)
  local characters = Internal:GetSavedVariableSubTable(self, "characters");
  local characterTbl = characters[characterName];

  if (type(characterTbl) ~= "table") then
    return "", -1, "";
  end

  return characterTbl.__class, characterTbl.__level, characterTbl.__faction;
end

---@param characterName string
---@param ... (string|number)
---@return OrbitusDB.QueryResult
---@nodiscard
function CharacterRepositoryMixin:QueryByCharacter(characterName, ...)
  local characters = Internal:GetSavedVariableSubTable(self, "characters");
  local characterTbl = characters[characterName];

  if (type(characterTbl) ~= "table") then
    return nil;
  end

  local query = UtilitiesMixin:ToQueryString(...);
  return UtilitiesMixin:GetTableValue(characterTbl, query);
end

---@generic T
---@param resultType `T`
---@param ... (string|number)
---@return T
---@nodiscard
function CharacterRepositoryMixin:QueryTypeByCharacter(resultType, characterName, ...)
  local result = self:QueryByCharacter(characterName, ...);

  if (resultType) then
    local r = resultType--[[@as string]];
    if (r:find("?") == #r) then
      if (result == nil) then
        return result;
      end

      resultType = r:sub(1, #r - 1);
    end

    UtilitiesMixin:VerifyVar("result", result, resultType);
  end

  return result;
end

--------------------------
--> ProfileRepositoryMixin:
--------------------------
---@param callback OrbitusDB.OnProfileChanged
function ProfileRepositoryMixin:OnProfileChanged(callback)
  UtilitiesMixin:VerifyArgsByName("callback", callback, "function");
  Internal:AddCallback(self, "profileChanged", callback);
end

---@param callback OrbitusDB.OnProfileListChanged
function ProfileRepositoryMixin:OnProfileListChanged(callback)
  UtilitiesMixin:VerifyArgsByName("callback", callback, "function");
  Internal:AddCallback(self, "profileListChanged", callback);
end

---@param callback OrbitusDB.OnBinListChanged
function ProfileRepositoryMixin:OnBinListChanged(callback)
  UtilitiesMixin:VerifyArgsByName("callback", callback, "function");
  Internal:AddCallback(self, "binListChanged", callback);
end

---@return string
function ProfileRepositoryMixin:GetActiveProfile()
  local data = metadata[tostring(self)];
  local profileKeys = Internal:GetSavedVariableSubTable(self, "profileKeys");

  local characterName = GetCurrentCharacterName();
  local repository = data.database.profile;
  local handler = data.config.repositoryHandlers.profile;
  local activeProfile = profileKeys[characterName] or handler.GetDefaultKey(repository);

  if (type(activeProfile) ~= "string") then
    activeProfile = handler.GetDefaultKey(repository);
    profileKeys[characterName] = activeProfile;
  end

  return activeProfile;
end

---@param profileName string
---@return boolean
function ProfileRepositoryMixin:ProfileExists(profileName)
  UtilitiesMixin:VerifyArgsByName("profileName", profileName, "string");
  local profiles = Internal:GetSavedVariableSubTable(self, "profiles");
  return type(profiles[profileName]) == "table";
end

---@param profileName string
---@return boolean
function ProfileRepositoryMixin:IsProfileInBin(profileName)
  UtilitiesMixin:VerifyArgsByName("profileName", profileName, "string");
  local bin = Internal:GetSavedVariableSubTable(self, "bin");
  return type(bin[profileName]) == "table";
end

---@param profileName string
function ProfileRepositoryMixin:SetActiveProfile(profileName)
  UtilitiesMixin:VerifyArgsByName("profileName", profileName, "string");
  local characterName = GetCurrentCharacterName();
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

  local profileNames = UtilitiesMixin:PopTable();
  for profileName, _ in pairs(profiles) do
    profileNames[#profileNames+1] = profileName;
  end

  return profileNames;
end

function ProfileRepositoryMixin:DeleteProfile(profileName)
  UtilitiesMixin:VerifyArgsByName("profileName", profileName, "string");
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
  UtilitiesMixin:VerifyArgsByName("profileName", profileName, "string");
  UtilitiesMixin:VerifyArgsByName("newProfileName", newProfileName, "string");
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

  local deletedProfiles = UtilitiesMixin:PopTable();
  for profileName, _ in pairs(bin) do
    deletedProfiles[#deletedProfiles+1] = profileName;
  end

  return deletedProfiles;
end

function ProfileRepositoryMixin:RestoreProfile(profileName, force)
  UtilitiesMixin:VerifyArgsByName("profileName", profileName, "string");
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
  UtilitiesMixin:VerifyArgsByName("profileName", profileName, "string");
  local profiles = Internal:GetSavedVariableSubTable(self, "profiles");
  local profileTable = profiles[profileName];

  assert(type(profileTable) == "table", ("Failed to export unknown profile '%s'"):format(profileName));

  local profileDataString = UtilitiesMixin:Encode(profileTable);
  return profileDataString;
end

function ProfileRepositoryMixin:ImportProfile(profileName, profileDataString, force)
  UtilitiesMixin:VerifyArgsByName("profileName", profileName, "string");
  UtilitiesMixin:VerifyArgsByName("profileDataString", profileDataString, "string");
  local profiles = Internal:GetSavedVariableSubTable(self, "profiles");

  assert(type(profiles[profileName]) ~= "table" or force,
    ("Failed to import profile '%s'; a profile with that name already exists"):format(profileName));

  local profileData = UtilitiesMixin:Decode(profileDataString);
  profiles[profileName] = profileData;
end

--------------------------
--> RepositoryMixin:
--------------------------

---@private
---@param database OrbitusDB.DatabaseMetadata
---@param repositoryName OrbitusDB.RepositoryName
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
---@param observer OrbitusDB.Observer
function RepositoryMixin:Subscribe(query, observer)
  local data = metadata[tostring(self)];
  local dbObservers = data.config.observers;

  local repositoryName = self:GetRepositoryName();
  dbObservers[repositoryName] = dbObservers[repositoryName] or UtilitiesMixin:PopTable();

  local observers = dbObservers[repositoryName];
  local normalizedQuery = UtilitiesMixin:NormalizeQuery(query);

  observers[normalizedQuery] = observers[normalizedQuery] or UtilitiesMixin:PopTable();
  local list = observers[normalizedQuery];
  list[#list+1] = observer;
end

---@generic T
---@param resultType `T`
---@param ... (string|number)
---@return T
---@nodiscard
function RepositoryMixin:QueryType(resultType, ...)
  local query = UtilitiesMixin:ToQueryString(...);
  local result = self:Query(query);

  if (resultType) then
    local r = resultType--[[@as string]];
    if (r:find("?") == #r) then
      if (result == nil) then
        return result;
      end

      resultType = r:sub(1, #r - 1);
    end

    UtilitiesMixin:VerifyVar("result", result, resultType, "Failed to query "..query);
  end

  return result;
end

---@param ... (string|number)
---@return OrbitusDB.QueryResult
---@nodiscard
function RepositoryMixin:Query(...)
  local query = UtilitiesMixin:ToQueryString(...);
  local repositoryName = self:GetRepositoryName();
  query = Internal:RemoveRepositoryNamePrefixFromQuery(query, repositoryName);

  local data = metadata[tostring(self)];
  local index = data.indices[repositoryName];
  local defaults = data.defaults[repositoryName];

  if (index[query] ~= nil) then
    return index[query];
  end

  if (defaults[query] ~= nil) then
    return defaults[query];
  end

  local indexResults;
  for fullKey, value in pairs(index) do
    if (fullKey:sub(1, #query) == query) then
      local subKey = fullKey:sub(#query + 1, #fullKey);
      indexResults = indexResults or UtilitiesMixin:PopTable();
      UtilitiesMixin:SetTableValue(indexResults, subKey, value);
    end
  end

  local defaultResults;
  for fullKey, value in pairs(defaults) do
    if (fullKey:sub(1, #query) == query) then
      local subKey = fullKey:sub(#query + 1, #fullKey);
      defaultResults = defaultResults or UtilitiesMixin:PopTable();
      UtilitiesMixin:SetTableValue(defaultResults, subKey, value);
    end
  end

  if (indexResults and defaultResults) then
    return UtilitiesMixin:MergeTables(defaultResults, indexResults);
  end

  if (indexResults) then
    return indexResults;
  end

  return defaultResults;
end

do
  ---@param index OrbitusDB.Index
  ---@param defaults OrbitusDB.Index
  ---@param query string|number
  ---@param value any
  ---@param changes OrbitusDB.IndexChanges?
  ---@return OrbitusDB.IndexChanges?
  local function AddToIndex(index, defaults, query, value, changes)
    local previousValue = index[query];

    if (value == nil) then
      value = defaults[query];
    end

    -- We can infer that all subkeys are now allocated to a table value, so they can be deleted
    for subKey, _ in pairs(index) do
      if (query:sub(1, #subKey) == subKey) then
        index[subKey] = nil;
      end
    end

    if (type(value) ~= "table") then
      index[query] = value;
    else
      local flattenedValue = UtilitiesMixin:Flatten(value);

      for subKey, newValue in pairs(flattenedValue) do
        local fullKey;

        if (subKey:sub(1, 1) == "[") then
          fullKey = ("%s%s"):format(query, subKey);
        else
          fullKey = ("%s.%s"):format(query, subKey);
        end

        changes = AddToIndex(index, defaults, fullKey, newValue, changes);
      end

      UtilitiesMixin:PushTable(flattenedValue);
    end

    if (previousValue ~= value) then
      local change = UtilitiesMixin:PopTable();
      change.from = previousValue;
      change.to = value;

      changes = changes or UtilitiesMixin:PopTable();
      changes[query] = change;
      return changes;
    end
  end

  ---@param query string
  ---@param value OrbitusDB.QueryResult
  function RepositoryMixin:Store(query, value)
    UtilitiesMixin:VerifyArgs(query, "string", value, "string|number|boolean|table|nil");
    local normalizedQuery = UtilitiesMixin:NormalizeQuery(query);
    local repositoryName = self:GetRepositoryName();
    normalizedQuery = Internal:RemoveRepositoryNamePrefixFromQuery(normalizedQuery, repositoryName);

    local data = metadata[tostring(self)];
    local index = data.indices[repositoryName];
    local defaults = data.defaults[repositoryName];

    local changes = AddToIndex(index, defaults, normalizedQuery, value);

    if (changes) then
      local svTable = Internal:GetRepositoryTable(self);

      -- Actually store the changes:
      for path, change in pairs(changes) do
        UtilitiesMixin:VerifyVar("change", change, "table",
          "Failed to store change for path '"..path.."' using query '"..normalizedQuery.."'.");

        UtilitiesMixin:SetTableValue(svTable, path, change.to);
      end

      local observers = data.config.observers[repositoryName];
      if (type(observers) == "table") then
        Internal:NotifyChanges(svTable, observers, changes);
      end
    end
  end
end

----------------------
--> UtilitiesMixin
----------------------
---@param tbl table
---@param query string
---@return any
function UtilitiesMixin:GetTableValue(tbl, query)
  if (tbl[query] ~= nil) then
    return tbl[query];
  end

  local normalizedQuery = self:NormalizeQuery(query);

  if (tbl[normalizedQuery] ~= nil) then
    return tbl[normalizedQuery];
  end

  local queryableList = self:ToQueryList(normalizedQuery);
  local result = tbl; ---@type table?

  for _, key in ipairs(queryableList) do
    if (type(result) ~= "table") then
      result = nil;
      break
    end

    result = result[key];
  end

  self:PushTable(queryableList);
  return result;
end

---@param tbl table
---@param query string
---@param value any
function UtilitiesMixin:SetTableValue(tbl, query, value)
  local normalizedQuery = self:NormalizeQuery(query);
  local queryableList = self:ToQueryList(normalizedQuery);

  local storageTbl = tbl;
  for i, key in ipairs(queryableList) do
    if (i < #queryableList) then
      if (type(storageTbl[key]) ~= "table") then
        storageTbl[key] = self:PopTable();
      end

      storageTbl = storageTbl[key];
    else
      -- the last key
      storageTbl[key] = value;
    end
  end

  self:PushTable(queryableList);
end

---@param rawQuery string
---@return OrbitusDB.RepositoryMixin
---@nodiscard
function UtilitiesMixin:GetRepositoryFromQuery(rawQuery)
  local data = metadata[tostring(self.db)];

  for repositoryName, _ in pairs(data.config.repositoryHandlers) do
    if (rawQuery:sub(1, #repositoryName) == repositoryName) then
      return self.db[repositoryName];
    end
  end

  error("Failed to get repository from query "..tostring(rawQuery));
end

---@param rawQuery string
---@nodiscard
function UtilitiesMixin:QueryDefaults(rawQuery)
  local data = metadata[tostring(self.db)];
  local normalizedQuery = self:NormalizeQuery(rawQuery);
  local repository = self:GetRepositoryFromQuery(normalizedQuery);
  local repositoryName = repository:GetRepositoryName();
  local query = Internal:RemoveRepositoryNamePrefixFromQuery(normalizedQuery, repositoryName);
  local defaults = data.defaults[repositoryName];

  if (defaults[query] ~= nil) then
    return defaults[query];
  end

  local defaultResults;
  for fullKey, value in pairs(defaults) do
    if (fullKey:sub(1, #query) == query) then
      local subKey = fullKey:sub(#query + 1, #fullKey);
      defaultResults = defaultResults or UtilitiesMixin:PopTable();
      UtilitiesMixin:SetTableValue(defaultResults, subKey, value);
    end
  end

  return defaultResults;
end

---@return table
function UtilitiesMixin:MergeTables(...)
  local merged = UtilitiesMixin:PopTable();

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
  local outputTable = UtilitiesMixin:PopTable();

  local function TraverseTable(currentTable, prefix)
    for key, value in pairs(currentTable) do
      local currentKey;

      if (tonumber(key) ~= nil) then
        currentKey = ("%s[%d]"):format(prefix or "", key);
      elseif (prefix) then
        currentKey = ("%s.%s"):format(prefix, key);
      else
        currentKey = key;
      end

      if (type(value) == "table") then
        TraverseTable(value, currentKey);
      else
        outputTable[currentKey] = value;
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
  local fetcherPattern = "return function() return %s; end";
  local loadstring = _G.loadstring;

  ---@param encodedString string
  ---@return table
  function UtilitiesMixin:Decode(encodedString)
    local compressed = LibDeflate:DecodeForPrint(encodedString);
    local decompressed = LibDeflate:DecompressDeflate(compressed);
    local fetcher = loadstring(fetcherPattern:format(decompressed)); ---@cast fetcher function
    return fetcher()();
  end
end

---@param tbl table
---@return string
function UtilitiesMixin:Encode(tbl)
  local rawStr = self:Serialize(tbl);
  local compressed = LibDeflate:CompressDeflate(rawStr);
  local encoded = LibDeflate:EncodeForPrint(compressed);
  return encoded;
end

do
  local normalizePattern = "%[%s*['\"](.-)['\"]%s*%]";
  local stringKeyPattern = "^%s*[\"'](.-)[\"']%s*$";

  ---@param query string
  function UtilitiesMixin:NormalizeQuery(query)
    self:VerifyArgsByName("query", query, "string");
    local normalizedQuery = strtrim(query):gsub(normalizePattern, ".%1");

    if (normalizedQuery:sub(1, 1) == ".") then
      normalizedQuery = normalizedQuery:sub(2);
    end

    return normalizedQuery;
  end

  local RecycleBin = {};
  RecycleBin.front = 1;
  RecycleBin.back = 1;
  RecycleBin.capacity = 30;

  function RecycleBin:GetSize()
    if (self.front == self.back) then
      if (self[self.front] ~= nil) then
        return 1;
      end

      return 0;
    end

    local size = self.front - self.back + 1;

    if (size <= 0) then
      size = size + self.capacity;
    end

    return size;
  end

  function RecycleBin:Push(item)
    local size = self:GetSize();
    local full = size == self.capacity;

    if (full) then return end

    if (self[self.front] == nil) then
      self[self.front] = item;
      return
    end

    self.front = self.front + 1;

    if (self.front > self.capacity) then
      self.front = 1;
    end

    self[self.front] = item;
  end

  function RecycleBin:Pop()
    local size = self:GetSize();
    local empty = size == 0;

    if (empty) then return {} end

    local item = self[self.back];
    self[self.back] = nil;

    if (self.front == self.back) then
      return item;
    end

    self.back = self.back + 1;

    if (self.back > self.capacity) then
      self.back = 1;
    end

    return item;
  end

  local function ClearTable(tbl)
    setmetatable(tbl, nil);
    for key in pairs(tbl) do
      tbl[key] = nil;
    end
  end

  local recycledTable_Metatable = {
    __index = function(_, key)
      error("Attempt to index key "..tostring(key).." of a recycled table.");
    end;
    __newindex = function(_, key, value)
      error("Attempt to assign key '"..tostring(key).."' the value of "..tostring(value).." onto a recycled table.");
    end
  };

  ---@param tbl table
  function UtilitiesMixin:PushTable(tbl)
    if (type(tbl) == "table") then
      if (type(tbl.GetObjectType) == "function") then
        local name = tbl.GetName and tbl:GetName();

        if (type(name) == "string" and #name > 0) then
          error("Cannot recycle widget with name: "..name);
        else
          error("Cannot recycle widgets!");
        end
      end

      ClearTable(tbl);
      setmetatable(tbl, recycledTable_Metatable);
      RecycleBin:Push(tbl);
    end
  end

  ---@return table
  function UtilitiesMixin:PopTable()
    local tbl = RecycleBin:Pop();
    ClearTable(tbl);
    return tbl;
  end

  ---@param ... (string|number)
  ---@return string
  ---@overload fun(self, list: OrbitusDB.QueryList)
  function UtilitiesMixin:ToQueryString(...)
    local totalArgs = select("#", ...);

    if (totalArgs == 1) then
      local arg = ...;

      if (type(arg) == "string") then
        return UtilitiesMixin:NormalizeQuery(arg);
      elseif (type(arg) == "number") then
        return ("[%d]"):format(arg);
      end
    end

    local query = "";
    for i = 1, totalArgs do
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
  ---@return OrbitusDB.QueryList
  function UtilitiesMixin:ToQueryList(query)
    self:VerifyArgsByName("query", query, "string");

    local list = self:PopTable(); ---@type OrbitusDB.QueryList
    local cur = 1;
    local hasStartBracket;

    for i = 1, #query do
      local char = query:sub(i, i);

      if (char == "." or char == "[" or (i == #query and char == "]")) then
        -- new string
        if (#list > 0 and hasStartBracket) then
          local previous = list[#list];
          local number = tonumber(previous);

          if (number ~= nil) then
            list[#list] = number;
          else
            local sanitized = previous:match(stringKeyPattern);
            if (sanitized ~= nil) then
              list[#list] = sanitized;
            end
          end
        end

        if (#list > 0) then
          cur = cur + 1;
        end

        hasStartBracket = char == "[";
      elseif (char ~= "]") then
        -- continue
        list[cur] = (list[cur] or "")..char;
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
  local index = Internal:BuildIndex(self.__repository);
  return index;
end

function IndexActionsMixin:NotifyIndexChanges(changes)
  local repository = self.__repository;
  local data = metadata[tostring(repository)];
  local repositoryName = repository:GetRepositoryName();
  local svTable = Internal:GetRepositoryTable(repository);

  local observers = data.config.observers[repositoryName];
  if (type(observers) == "table") then
    Internal:NotifyChanges(svTable, observers, changes);
  end
end

function IndexActionsMixin:GetIndexChanges(fromIndex, toIndex)
  local changes = UtilitiesMixin:PopTable();

  for key, value in pairs(fromIndex) do
    if (value ~= toIndex[key]) then
      local change = UtilitiesMixin:PopTable();
      change.from = value;
      change.to = toIndex[key];
      changes[key] = change;
    end
  end

  for key, value in pairs(toIndex) do
    if (fromIndex[key] == nil) then
      local change = UtilitiesMixin:PopTable();
      change.to = value;
      changes[key] = change;
    end
  end

  return changes;
end

do
  local errorArgIndexTemplate = "bad argument #%d (%s expected, got %s)";
  local errorArgNameTemplate = "bad argument '%s' (%s expected, got %s)";
  local errorValTemplate = "bad value '%s' (%s expected, got %s)";
  local emptySpace = " ";
  local expectedTypesSeparator = "|";
  local orString = " or ";
  local emptyString = "";

  local function IsValidType(value, expectedTypeDefinition)
    local actualType = type(value);
    local expectedType = emptyString;

    for i = 1, #expectedTypeDefinition do
      local char = expectedTypeDefinition:sub(i, i);

      if (char ~= emptySpace) then
        if (char == expectedTypesSeparator) then
          if (expectedType == actualType) then
            return true;
          end

          -- new string
          expectedType = emptyString;
        else
          expectedType = expectedType .. char;
        end
      end
    end

    return expectedType == actualType;
  end

  ---@generic T
  ---@param variableName string
  ---@param value any
  ---@param expectedType `T`
  ---@param message string?
  ---@return T value
  function UtilitiesMixin:VerifyVar(variableName, value, expectedType, message)
    local isValid = IsValidType(value, expectedType);

    if (not isValid) then
      expectedType = string.gsub(expectedType, expectedTypesSeparator, orString);
      local errorMessage = errorValTemplate:format(variableName, expectedType, type(value));

      if (message) then
        errorMessage = errorMessage .. " - " .. message;
      end

      error(errorMessage);
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
      expectedArgType = string.gsub(expectedArgType, expectedTypesSeparator, orString);

      local template = (type(parameter) == "number") and errorArgIndexTemplate or errorArgNameTemplate
      error(template:format(parameter, expectedArgType, type(arg)));
    end

    return arg;
  end
end

do
  local lengthOperator = "#";

  function UtilitiesMixin:VerifyArgs(...)
    local parameterIndex = 0;

    for i = 1, select(lengthOperator, ...), 2 do
      parameterIndex = parameterIndex + 1;
      local arg, expectedArgType = select(i, ...);
      self:VerifyArg(parameterIndex, arg, expectedArgType);
    end
  end

  function UtilitiesMixin:VerifyArgsByName(...)
    for i = 1, select(lengthOperator, ...), 3 do
      local name, arg, expectedArgType = select(i, ...);
      self:VerifyArg(name, arg, expectedArgType);
    end
  end
end
--------------------------
--> Internal:
--------------------------
---@param root table
---@param observers { [string]: OrbitusDB.Observer[] }
---@param changes OrbitusDB.IndexChanges
function Internal:NotifyChanges(root, observers, changes)
  UtilitiesMixin:VerifyArgsByName(
    "root", root, "table",
    "observers", observers, "table",
    "changes", changes, "table");

  if (not next(observers)) then return end

  for query, observer in pairs(observers) do
    local relevantChanges = nil;

    if (type(observer) == "table" and #observer > 0) then
      for changeQuery, change in pairs(changes) do
        if (#changeQuery >= #query) then
          local isRelevantChange = changeQuery:sub(1, #query) == query;

          if (isRelevantChange) then
            relevantChanges = relevantChanges or UtilitiesMixin:PopTable();
            relevantChanges[changeQuery] = change;
          end
        end
      end

      if (relevantChanges) then
        for _, notifier in ipairs(observer) do
          local value = UtilitiesMixin:GetTableValue(root, query);
          notifier(value, relevantChanges);
        end

        UtilitiesMixin:PushTable(relevantChanges);
      end
    end
  end

  for _, value in pairs(changes) do
    UtilitiesMixin:PushTable(value);
  end

  UtilitiesMixin:PushTable(changes);
end

---@param repository OrbitusDB.RepositoryMixin
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

---@param query string
---@param repositoryName string
---@return string
function Internal:RemoveRepositoryNamePrefixFromQuery(query, repositoryName)
  if (query:sub(1, #repositoryName) == repositoryName) then
    query = query:sub(#repositoryName + 1);
  end

  if (query:sub(1, 1) == ".") then
    query = query:sub(2, #query);
  end

  return query;
end

---@param callbackName OrbitusDB.DatabaseCallbackType
function Internal:AddCallback(obj, callbackName, callback)
  local data = metadata[tostring(obj)];
  data.callbacks = data.callbacks or UtilitiesMixin:PopTable();
  data.callbacks[callbackName] = data.callbacks[callbackName] or UtilitiesMixin:PopTable();
  local list = data.callbacks[callbackName];
  list[#list+1] = callback;
end

---@param callbackName OrbitusDB.DatabaseCallbackType
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

---@param repository OrbitusDB.RepositoryMixin
---@return OrbitusDB.Index
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

  data.defaults[repositoryName] = indexDefaults;
  local index = UtilitiesMixin:MergeTables(
    indexDefaults, indexSavedVariables)--[[@as OrbitusDB.Index]];

  data.indices[repositoryName] = index;
  return index;
end

return OrbitusDB;