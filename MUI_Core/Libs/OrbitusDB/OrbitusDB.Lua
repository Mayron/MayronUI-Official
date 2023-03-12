-- luacheck: ignore self
local _G = _G;
local OrbitusApi = {};
local DatabaseMixin = {};
local RepositoryMixin = {};
local ProfileManagerMixin = {};
local Utilities = {};

local defaultConfig = {
  GetDefaultProfile = function() return "Default"; end;
  autoInit = true;
  repositoryHandlers = {
    ["global"] = function() end,
    ["profile"] = function() end,
    ["character"] = function() end,
    ["spec"] = function() end,
  }
};

local databases = {};
local registeredDatabases = {};
local dbLoader = _G.CreateFrame("Frame");
local CreateAndInitFromMixin = _G.CreateAndInitFromMixin;

dbLoader:RegisterEvent("ADDON_LOADED");
dbLoader:SetScript("OnEvent", function()
  for savedVariableName, config in pairs(registeredDatabases) do
    if (not databases[savedVariableName] and type(_G[savedVariableName]) == "table") then
      CreateAndInitFromMixin(DatabaseMixin, savedVariableName, config);
    end
  end
end);

--------------------------
--> OrbitusApi:
--------------------------

function OrbitusApi:Register(savedVariableName, config)

end

--------------------------
--> DatabaseMixin:
--------------------------

function DatabaseMixin:Init(savedVariableName, config)
  databases[savedVariableName] = self;
end

function DatabaseMixin:GetProfileManager()
end

function DatabaseMixin:AddDefaults()
end

function DatabaseMixin:Subscribe(query, observer)
end

function DatabaseMixin:Notify(query)
end

-- OnProfileChanged
-- OnDatabaseInit
function DatabaseMixin:SetCallback(event, callback)
end

--------------------------
--> ProfileManagerMixin:
--------------------------

function ProfileManagerMixin:GetActive()
end

function ProfileManagerMixin:SetActive()
end

function ProfileManagerMixin:GetAll()
end

function ProfileManagerMixin:Delete()
end

function ProfileManagerMixin:New()
end

function ProfileManagerMixin:Rename()
end

function ProfileManagerMixin:GetDeleted()
end

function ProfileManagerMixin:Restore()
end

function ProfileManagerMixin:Export()
end

function ProfileManagerMixin:Import()
end

--------------------------
--> RepositoryMixin:
--------------------------

function RepositoryMixin:Get(query)
  Utilities:Verify(query, "string");
end

function RepositoryMixin:Set(query)
end

function RepositoryMixin:Exists(query)
end

--------------------------
--> Utilities:
--------------------------

local errorTemplate = "bad argument #%d (%s expected, got %s)";
function Utilities:Verify(arg, expectedArgType, parameterIndex)
  local actualArgType = type(arg);
  if (actualArgType == expectedArgType) then return end

  local errorMessage = errorTemplate:format(parameterIndex, expectedArgType, actualArgType);
  error(errorMessage);
end