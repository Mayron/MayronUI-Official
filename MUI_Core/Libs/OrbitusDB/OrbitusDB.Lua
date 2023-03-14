-- luacheck: ignore self
---@diagnostic enable

local _G = _G;
local OrbitusApi = {};
local DatabaseMixin = {}; ---@class DatabaseMixin
local RepositoryMixin = {}; ---@class RepositoryMixin
local ProfileManagerMixin = {}; ---@class ProfileManagerMixin
local Utilities = {}; ---@class Utilities
local UnitFullName, strsplit = _G.UnitFullName, _G.strsplit;

---@alias RepositoryHandler fun(sv: table, db: DatabaseMixin): table
---@alias OnInitializedCallback fun(db: DatabaseMixin)

---@class DatabaseMetadata
---@field svName string
---@field profileManager ProfileManagerMixin
---@field database DatabaseMixin
---@field config DatabaseConfig
---@field initialized boolean
---@field activeProfile string|nil

---@class DatabaseConfig
---@field repositoryHandlers table<string, RepositoryHandler>
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
      assert(characterName, "Failed to get character repository. Character name cannot be nil");
      sv.characters = sv.characters or {};
      sv.characters[characterName] = sv.characters[characterName] or {};
      return sv.characters[characterName];
    end,
  }
};

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
  local data = metadata[tostring(self)];

  if (not data.callbacks) then
    data.callbacks = { profileChanged = {} };
  end

  table.insert(data.callbacks.profileChanged, callback);
end

--------------------------
--> ProfileManagerMixin:
--------------------------

---@return string
function ProfileManagerMixin:GetActive()
  local data = metadata[tostring(self)];

  return data.activeProfile:lower();
  --return data.activeProfile or data.config.GetDefaultProfile();
end

---@param profileName string
function ProfileManagerMixin:SetActive(profileName)
  local data = metadata[tostring(self)];
  data.activeProfile = profileName;
end

function ProfileManagerMixin:GetAll()
  local data = metadata[tostring(self)];
end

function ProfileManagerMixin:Delete()
  local data = metadata[tostring(self)];
end

function ProfileManagerMixin:New()
  local data = metadata[tostring(self)];
end

function ProfileManagerMixin:Rename()
  local data = metadata[tostring(self)];
end

function ProfileManagerMixin:GetDeleted()
  local data = metadata[tostring(self)];
end

function ProfileManagerMixin:Restore()
  local data = metadata[tostring(self)];
end

function ProfileManagerMixin:Export()
  local data = metadata[tostring(self)];
end

function ProfileManagerMixin:Import()
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
end

function RepositoryMixin:Exists(query)
end

function RepositoryMixin:AddDefaults(defaults)
  local data = metadata[tostring(self)];
  assert(not data.initialized, "Unable to add defaults to already initialized database");
  local name = Utilities:GetRepositoryName(self);

  if (name) then
    data.defaults = data.defaults or {};
    data.defaults[name] = Utilities:Assign(data.defaults[name] or {}, defaults);
  end
end


function RepositoryMixin:Subscribe(query, observer)
end

function RepositoryMixin:Notify(query)
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

---@return DatabaseConfig
function Utilities:Assign(...)
  local merged = {};

  for i = 1, select("#", ...) do
    local tbl = (select(i, ...));
    for key, value in pairs(tbl) do
      merged[key] = value;
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

---@param root table
---@param query string
function Utilities:ParseQuery(root, query)
  local normalized = query:gsub("%[%s+?['\"](.*)['\"]%s+?%]", "$1");
  local keys = strsplit(".", normalized); ---@type string[]

  local result = root;
  for _, key in ipairs(keys) do
    if (type(result) ~= "table") then
      return nil;
    end

    local sanitizedKey = key:gsub("%[%s+?%d+%%s+?%]", "");
    result = result[sanitizedKey];

    for i in key:gmatch("%[%s+?(%d+)%%s+?%]") do
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

function Utilities:Store(root, query, value)
  local normalized = query:gsub("%[%s+?['\"](.*)['\"]%s+?%]", "$1");
  local keys = strsplit(".", normalized); ---@type string[]

  local sanitizedKeys = {};

  for _, key in ipairs(keys) do
    local sanitizedKey = key:gsub("%[%s+?%d+%%s+?%]", "");
    sanitizedKeys[#sanitizedKeys+1] = sanitizedKey;

    for i in key:gmatch("%[%s+?(%d+)%%s+?%]") do
      local index = tonumber(i);
      assert(type(index) == "number" and index > 0,
        ("Failed to parse query %s at key %s; index is invalid"):format(query, i));

      sanitizedKeys[#sanitizedKeys+1] = tonumber(index);
    end
  end

  local storageTbl = root;
  for i, key in ipairs(sanitizedKeys) do
    if (i < #sanitizedKeys and type(storageTbl[key]) ~= "table") then
      storageTbl[key] = {};
    end

    assert(type(storageTbl) == "table",
      ("Failed to parse query %s at key %s; storage location is not a table"):format(query, key));

    if (i == #storageTbl) then
      storageTbl[key] = value;
    end
  end
end