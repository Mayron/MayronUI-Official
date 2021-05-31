-- luacheck: ignore self 143 631
local _G = _G;
local tonumber, pairs = _G.tonumber, _G.pairs;

_G.MayronObjects = _G.MayronObjects or {
  versions = {};

  NewFramework = function(self, version)
    version = tonumber((version:gsub("%.+", "")));
    self.last = version;

    if (not self.versions[version]) then
      local framework = {};
      self.versions[version] = framework;
      return framework;
    end
  end;

  GetFramework = function(self, version)
    if (version) then
      version = version:gsub("%s+", ""):lower();

      if (version == "latest") then
        for key, _ in pairs(self.versions) do
          version = key;
        end
      else
        version = tonumber((version:gsub("%.+", "")));
      end

      self.last = version;
    end

    return self.versions[self.last];
  end;
};

---@type MayronObjects
local Framework = _G.MayronObjects:NewFramework("4.0.0");
if (not Framework) then return end

local max, tostring, type, strsplit, strgsub, rawset = _G.math.max, _G.tostring, _G.type, _G.strsplit, _G.string.gsub, _G.rawset;
local select, next, strformat, unpack, print, strrep = _G.select, _G.next, _G.string.format, _G.unpack, _G.print, _G.string.rep;
local CreateFromMixins, collectgarbage, setmetatable = _G.CreateFromMixins, _G.collectgarbage, _G.setmetatable;
local strmatch, error, ipairs = _G.string.match, _G.error, _G.ipairs;

local StaticMixin = {};
local InstanceMixin = {};
local objectMetadata = {};
local exported = {};
local pendingParameterRule, pendingReturnRule, pendingGenericTypes;

local SimpleTypes = {
  [1] = "table";
  [2] = "number";
  [3] = "function";
  [4] = "boolean";
  [5] = "string";
  [6] = "nil";
};

local paramErrorMessage = "bad argument ## to '%s.%s'";
local returnErrorMessage = "bad return value ## to '%s.%s'";
local propertyErrorMessage = "bad property '%s' for instance of class '%s'";

-------------------------------------
--- Local Functions
-------------------------------------
local function GetValueType(value)
  if (value == nil) then
    return SimpleTypes[6];
  end

  local valueType = type(value);

  if (valueType ~= SimpleTypes[1]) then
    return valueType;

  elseif (value.GetObjectType) then
    return value:GetObjectType();
  end

  return SimpleTypes[1];
end

local function CastSimpleDefault(definitionType, defaultValue)
  if (defaultValue == nil) then return end
  definitionType = strgsub(definitionType, "?", "");
  definitionType = strgsub(definitionType, "%s", "");

  if (definitionType:lower() == "number" and Framework:IsString(defaultValue)) then
    defaultValue = strgsub(defaultValue, "%s", ""); -- remove spaces
    defaultValue = tonumber(defaultValue);
  end

  if (definitionType:lower() == "boolean" and Framework:IsString(defaultValue)) then
    defaultValue = strgsub(defaultValue, "%s", ""); -- remove spaces

    if (defaultValue:lower() == "true") then
      defaultValue = true;
    else
      defaultValue = false;
    end
  end

  return defaultValue;
end

local RunValidator;
do
  local function VerifyStrictTypingRule(definitionType, realType, defaultValue)
    local errorFound;

    Framework:Assert(Framework:IsString(definitionType)
      and not Framework:IsStringNilOrWhiteSpace(definitionType),
      "Invalid definition found; expected a string containing the expected type of an argument or return value.");

    if (definitionType:find("^?") or definitionType:find("?$") or defaultValue ~= nil) then
      -- it's optional so allow nil values
      if (definitionType:find("^?") or definitionType:find("?$")) then
        -- remove "?" from front or back of string
        definitionType = definitionType:gsub("?", "");
      end

      errorFound = (realType ~= nil) and (definitionType ~= "any" and not Framework:IsType(realType, definitionType));
    else
      -- it is NOT optional so it cannot be nil
      errorFound = (realType == nil) or (definitionType ~= "any" and not Framework:IsType(realType, definitionType));
    end

    return errorFound;
  end

  function RunValidator(definitionType, defaultValue, errorMessage, objectName, name, value, index)
    local errorFound;

    if (definitionType:find("|")) then
      -- a union type detected!
      local unionDefs = Framework:PopTable(strsplit("|", definitionType));

      -- cannot use IterateArgs as loop might break (and table is not pushed)
      for _, singleDefinitionType in ipairs(unionDefs) do
        singleDefinitionType = strgsub(singleDefinitionType, "%s", "");
        errorFound = VerifyStrictTypingRule(singleDefinitionType, value, defaultValue);

        if (not errorFound) then break end
      end

      Framework:PushTable(unionDefs);

      if (errorFound) then
        definitionType = strgsub(definitionType, "|", " or ");
      end
    else
      if (definitionType:find("=")) then
        -- a default value detected!
        definitionType, defaultValue = strsplit("=", definitionType);
      end

      errorFound = VerifyStrictTypingRule(definitionType, value, defaultValue);
    end

    if (errorFound) then
      if (Framework:IsNumber(index)) then
        errorMessage = strformat(errorMessage, objectName, name);
        errorMessage = errorMessage:gsub("##", "#" .. tostring(index));
      else
        errorMessage = strformat(errorMessage, name, objectName);
      end

      if (Framework:IsFunction(value) or (Framework:IsTable(value) and not Framework:IsFunction(value.IsObjectType))) then
        errorMessage = strformat("%s (%s expected, got %s)", errorMessage, definitionType, GetValueType(value));
      else
        errorMessage = strformat("%s (%s expected, got %s (value: %s))", errorMessage,
          definitionType, GetValueType(value), tostring(value));
      end

      Framework:Error(errorMessage);
      return
    end

    return definitionType, defaultValue;
  end
end

local function ValidateInstanceProperties(instance, interfaces, objectName, keyToCheck)
  for _, interfaceMetadata in pairs(interfaces) do
    for key, definitionType in pairs(interfaceMetadata.rules) do
      if (keyToCheck == nil or key == keyToCheck) then
        local defaultValue;
        local value = instance[key];

        -- is property
        if (Framework:IsTable(definitionType)) then
          -- a default value detected! ordering of these 2 lines is important:
          defaultValue = definitionType.default;
          definitionType = definitionType.type;
        end

        definitionType, defaultValue = RunValidator(definitionType, defaultValue, propertyErrorMessage, objectName, key, value);

        if (value == nil and defaultValue ~= nil) then
          instance[key] = CastSimpleDefault(definitionType, defaultValue);
        end
      end
    end
  end
end

local function ValidateArguments(definition, errorMessage, objectName, methodName, ...)
  local values = Framework:PopTable(...)
  local length = select("#", ...);
  local index = 1;
  local realValue = (select(1, ...));
  local definitionType;
  local defaultValue;
  local vararg;

  repeat
    definitionType = definition[index] or vararg;

    if (Framework:IsTable(definitionType)) then
      -- a default value detected! ordering of these 2 lines is important:
      defaultValue = definitionType.default;
      definitionType = definitionType.type;
    end

    if (definitionType:find("%.%.%.")) then
      vararg = definitionType:gsub("%.%.%.", "");
      definitionType = vararg;

      -- varargs are optional, if no explicit `nil` is provided then this is acceptible.
      if (index > length) then break end
    end

    definitionType, defaultValue = RunValidator(definitionType, defaultValue, errorMessage, objectName, methodName, realValue, index);

    -- swap out default values
    if (values[index] == nil and defaultValue ~= nil) then
      values[index] = CastSimpleDefault(definitionType, defaultValue);
    end

    index = index + 1;
    realValue = (select(index, ...));
    defaultValue = nil;

  until ((not vararg and definition[index] == nil) or (vararg and index > length));

  -- calculate real length (real values might be implicit `nils` but we have defaults to fill in):
  length = 0;
  for id, _ in pairs(values) do
    length = id;
  end

  -- if there are no defaults, we should fallback to vararg length:
  length = max((select("#", ...)), length);

  return values, length;
end

--- where ... are the parameter values
local function ExecuteMethod(self, methodName, method, ...)
  local metadata = objectMetadata[tostring(self)];
  local isStatic = methodName:match("^Static%.") ~= nil;
  local rules = metadata.rules;

  if (metadata.usingParent) then
    local parentMetadata = objectMetadata[tostring(metadata.usingParent)];
    metadata.usingParent = nil;

    if (parentMetadata) then
      rules = parentMetadata.rules;
    end
  end

  if (not (rules and rules[methodName])) then
    if (isStatic) then
      return method(self, ...);
    end

    return method(self, metadata.privateData, ...);
  end

  local methodRule = rules[methodName];
  local args;
  local argsLength = select("#", ...);

  if (methodRule.params) then
    args, argsLength = ValidateArguments(methodRule.params, paramErrorMessage, metadata.name, methodName, ...);
  else
    args = Framework:PopTable(...);
  end

  if (methodRule.returns) then
    local returnValues, returnValuesLength;

    if (isStatic) then
      returnValues, returnValuesLength = ValidateArguments(
        methodRule.returns, returnErrorMessage, metadata.name, methodName,
        -- call method here:
        method(self, Framework:UnpackTable(args, 1, argsLength)));
    else
      returnValues, returnValuesLength = ValidateArguments(
        methodRule.returns, returnErrorMessage, metadata.name, methodName,
        -- call method here:
        method(self, metadata.privateData, Framework:UnpackTable(args, 1, argsLength)));
    end

    return Framework:UnpackTable(returnValues, 1, returnValuesLength);
  end

  if (isStatic) then
    return method(self, Framework:UnpackTable(args, 1, argsLength));
  end

  -- it's an instance
  return method(self, metadata.privateData, Framework:UnpackTable(args, 1, argsLength));
end

local function DeepCopy(copiedTable, newTable)
  newTable = newTable or Framework:PopTable();

  for key, value in pairs(copiedTable) do
    if (Framework:IsTable(newTable[key]) and Framework:IsTable(value)) then
      DeepCopy(value, newTable[key]);

    elseif (Framework:IsTable(value)) then
      newTable[key] = DeepCopy(value);
    else
      newTable[key] = value;
    end
  end

  return newTable;
end

local function ApplyGenericTypes(rules, genericParams)
  if (not Framework:IsTable(rules)) then return end

  for index, _ in ipairs(rules) do
    for paramIndex, genericParam in ipairs(genericParams) do
      rules[index] = rules[index]:gsub(genericParam, pendingGenericTypes[paramIndex]);
    end
  end
end

local function ValidateDefinitionTypes(...)
  local defs = Framework:PopTable(...);
  local vararg;

  for index = 1, select("#", ...) do
    local def = defs[index];

    if (Framework:IsTable(def)) then
      if (def[1] == nil) then
        def[1] = "?any";
      end

      def = def[1];
    end

    if (def == nil) then
      def = "?any";
      defs[index] = def;
    end

    if (not Framework:IsString(def)) then
      Framework:Error("Invalid definition - bad argument #1 (string expected, got %s).", type(def));
      Framework:PushTable(defs);
      return
    end

    if (vararg) then
      Framework:Error("Invalid definition (cannot specify another definition after variable list definition: `...`).");
      Framework:PushTable(defs);
      return
    elseif (def:find("%.%.%.")) then
      vararg = true;
    end
  end

  return defs;
end

local function ApplyMethodStrictTypingRule(object, keyDefName)
  if (not (pendingParameterRule or pendingReturnRule)) then return end

  local metadata = objectMetadata[tostring(object)];
  local methodRule = Framework:PopTable();

  if (pendingParameterRule) then
    methodRule.params = pendingParameterRule;
    pendingParameterRule = nil;
  end

  if (pendingReturnRule) then
    methodRule.returns = pendingReturnRule;
    pendingReturnRule = nil;
  end

  metadata.rules[keyDefName] = methodRule;
end

-------------------------------------
--- Class Metatable
-------------------------------------
local classMetatable = {};

classMetatable.__newindex = function(self, key, value)
  local metadata = objectMetadata[tostring(self)];

  if (not Framework:IsFunction(value)) then
    metadata.classProperties[key] = value;
    return
  end

  -- add functions
  if (pendingParameterRule or pendingReturnRule) then
    for _, interfaceMetadata in pairs(metadata.interfaces) do
      for keyDefName, _ in pairs(interfaceMetadata.rules) do
        if (key == keyDefName) then
          pendingParameterRule = nil;
          pendingReturnRule = nil;
          Framework:Error("Cannot redefine method '%s' as it has already been defined by interface '%s'.",
            key, interfaceMetadata.name);
        end
      end
    end

    ApplyMethodStrictTypingRule(self, key);
  end

  -- add wrapper function that will use strict typing rules to validate:
  metadata.classProperties[key] = function(obj, ...)
    return ExecuteMethod(obj, key, value, ...);
  end;
end

classMetatable.__index = function(self, key)
  local metadata = objectMetadata[tostring(self)];

  if (metadata.classProperties[key]) then
    return metadata.classProperties[key];
  end

  for _, parentClass in ipairs(metadata.parentClasses) do
    if (Framework:IsFunction(parentClass[key])) then
      metadata.classProperties[key] = parentClass[key];
      return parentClass[key];
    end
  end

end

local instanceMetatable = {};

do
  local innerValues = {};
  local frameWrapperFunction = function(_, ...)
    -- call the frame (a blizzard widget) here
    return innerValues.frame[innerValues.key](innerValues.frame, ...);
  end

  instanceMetatable.__index = function(self, key)
    local metadata = objectMetadata[tostring(self)];

    -- if new class functions were added, update instance object to include them
    if (Framework:IsFunction(metadata.class[key])) then
      rawset(self, key, metadata.class[key]);
      return metadata.class[key];
    end

    local value = metadata.instanceProperties[key];

    if (metadata.indexedCallback) then
      value = metadata.indexedCallback(self, metadata.privateData, key, value);
    end

    if (not value) then
      local frame = metadata.privateData.frame;

      if (Framework:IsTable(frame) and Framework:IsFunction(frame[key])) then
        innerValues.frame = frame;
        innerValues.key = key;
        return frameWrapperFunction;
      end
    end

    return value;
  end

  instanceMetatable.__newindex = function(self, key, value)
    local metadata = objectMetadata[tostring(self)];

    if (Framework:IsFunction(value)) then
      metadata.class[key] = value;
      return
    end

    metadata.instanceProperties = metadata.instanceProperties or Framework:PopTable();

    local oldValue = metadata.instanceProperties[key];
    if (oldValue ~= nil and metadata.protectedProperties and metadata.protectedProperties[key]) then
      Framework:Error("Failed to override protected instance property '%s' for object '%s'.", key, metadata.name);
      return
    end

    if (metadata.indexChangingCallback) then
      local preventIndexing = metadata.indexChangingCallback(self, metadata.privateData, key, value, oldValue);

      if (preventIndexing) then
        -- do not continue indexing
        return
      end
    end

    metadata.instanceProperties[key] = value;
    ValidateInstanceProperties(self, metadata.interfaces, metadata.name, key);

    if (metadata.indexChangedCallback) then
      metadata.indexChangedCallback(self, metadata.privateData, key, value, oldValue);
    end
  end

  instanceMetatable.__gc = function(self)
    self:Destroy();
  end
end

-- create class instance:
classMetatable.__call = function(self, ...)
  local classMetadata = objectMetadata[tostring(self)];
  local instance = CreateFromMixins(self); -- transfer all class functions to instance object
  -- transfer all InstanceMixin functions to instance object with wrapper
  for methodName, method in pairs(InstanceMixin) do
    instance[methodName] = function(obj, ...)
      return ExecuteMethod(obj, methodName, method, ...);
    end
  end

  setmetatable(instance, instanceMetatable);

  local metadata = CreateFromMixins(classMetadata);
  metadata.privateData = Framework:PopTable();
  metadata.instanceProperties = Framework:PopTable();
  metadata.class = self;

  metadata.privateData.GetFriendData = function(_, friendInstance)
    local friendMetadata = objectMetadata[tostring(friendInstance)];
    -- need to get class friend data because "friends" was not copied with CreateFromMixins as it may not have been created yet.
    local friendClassMetadata = objectMetadata[tostring(friendMetadata.class)];

    if (friendClassMetadata.namespace == metadata.namespace) then
      return friendMetadata.privateData;
    end

    Framework:Assert(friendClassMetadata.friends and friendClassMetadata.friends[metadata.namespace],
      "'%s' is not a friend class of '%s'", metadata.namespace, friendClassMetadata.namespace);

    return friendMetadata.privateData;
  end

  metadata.privateData.Call = function(_, privateMethodName, ...)
    local methods = classMetadata.privateMethods;

    Framework:Assert(Framework:IsTable(methods),
      "Failed to execute unknown private method '%s' - No private methods available for class '%s'",
      privateMethodName, metadata.name);

    Framework:Assert(Framework:IsFunction(methods[privateMethodName]),
      "Failed to execute unknown private method '%s'", privateMethodName);

    return methods[privateMethodName](instance, ...);
  end

  if (pendingGenericTypes) then
    -- apply generic types to parameters in rules
    if (classMetadata.rules and classMetadata.genericParams) then
      metadata.rules = DeepCopy(classMetadata.rules);

      for _, methodRule in pairs(metadata.rules) do
        ApplyGenericTypes(methodRule.params, classMetadata.genericParams);
        ApplyGenericTypes(methodRule.returns, classMetadata.genericParams);
      end
    end

    pendingGenericTypes = nil;
  end

  objectMetadata[tostring(instance)] = metadata;

  if (instance.__Construct) then
    instance:__Construct(...);
    instance.__Construct = nil;
  end

  -- used for creating instances from generic classes
  -- (don't need this on instance object)
  instance.UsingTypes = nil;

  -- verify implementations exist
  ValidateInstanceProperties(instance, classMetadata.interfaces, classMetadata.name);

  return instance;
end

local staticMetatable = {};
staticMetatable.__newindex = function(self, key, value)
  if (not Framework:IsFunction(value)) then
    rawset(self, key, value);
    return
  end

  local keyDefName = strformat("Static.%s", key);
  ApplyMethodStrictTypingRule(self, keyDefName);

  -- add wrapper function that will use definitions to validate:
  rawset(self, key, function(obj, ...)
    return ExecuteMethod(obj, keyDefName, value, ...);
  end);
end

local privateMetatable = {};
privateMetatable.__newindex = function(self, key, value)
  if (not Framework:IsFunction(value)) then
    Framework:Error("Only functions can be added to a class private table. Use the instance's private data table instead.");
    return
  end

  local keyDefName = strformat("Private.%s", key);
  ApplyMethodStrictTypingRule(self, keyDefName);

  local metadata = objectMetadata[tostring(self)];
  metadata.privateMethods = metadata.privateMethods or Framework:PopTable();

  -- add it to the secret private table:
  metadata.privateMethods[key] = function(obj, ...)
    return ExecuteMethod(obj, keyDefName, value, ...);
  end
end

-- special class function (should be static but looks confusing when static)
local function UsingTypes(self, ...)
  local metadata = objectMetadata[tostring(self)];
  Framework:Assert(Framework:IsTable(metadata.genericParams), "Cannot specify generic types for non-generic class");

  pendingGenericTypes = Framework:PopTable(...);
  return self;
end

local function Implements(class, ...)
  for i = 1, select("#", ...) do
    local interface = (select(i, ...));

    if (Framework:IsString(interface)) then
      interface = Framework:Import(interface);
    end

    local classMetadata = objectMetadata[tostring(class)];
    local interfaceMetadata = objectMetadata[tostring(interface)];

    Framework:Assert(Framework:IsTable(interfaceMetadata) and interfaceMetadata.rules,
      "Failed to implement interface for class '%s' - unknown interface", classMetadata.name);

    -- transfer all interface rules to the class
    for keyDefName, rule in pairs(interfaceMetadata.rules) do
      if (Framework:IsTable(rule) and rule.type == "function") then
        classMetadata.rules[keyDefName] = rule;
      end
    end

    -- need interface data to use IsObjectType to check if class is a type of instance
    -- as well as to check that an instance implements a given interface correctly
    classMetadata.interfaces[#classMetadata.interfaces + 1] = interfaceMetadata;
  end

  return class;
end

-------------------------------------
--- Framework Methods
-------------------------------------
--- where ... are mixins
function Framework:CreateClass(className, ...)
  local class = self:PopTable();
  class.Static = self:PopTable();
  class.Private = self:PopTable();

  setmetatable(class, classMetatable);
  setmetatable(class.Static, staticMetatable);
  setmetatable(class.Private, privateMetatable);

  local classMetadata = self:PopTable();

  if (className:match("<") and className:match(">")) then
    local genericParams = className:sub((className:find("<")), #className);
    genericParams = genericParams:gsub("<", ""):gsub(">", ""):gsub("%s", "");

    classMetadata.genericParams = self:PopTable(strsplit(",", genericParams));
  end

  classMetadata.name = className;
  classMetadata.namespace = className;
  classMetadata.parentClasses = self:PopTable();
  classMetadata.classProperties = self:PopTable();
  classMetadata.rules = self:PopTable();
  classMetadata.interfaces = self:PopTable();

  -- add parents in reverse order for class index metamethod to work
  for i = select("#", ...), 1, -1 do
    local parent = (select(i, ...));

    if (Framework:IsString(parent)) then
      parent = Framework:Import(parent);
    end

    local parentMetadata = objectMetadata[tostring(parent)];

    if (parentMetadata) then
      classMetadata.parentClasses[#classMetadata.parentClasses + 1] = parent;
      -- add parent of parent classes
      for _, parentClass in ipairs(parentMetadata.parentClasses) do
        classMetadata.parentClasses[#classMetadata.parentClasses + 1] = parentClass;
      end
    else
      Framework:Error("Failed to create class '%s' - bad argument #%d (unknown parent class).", className, i + 1);
    end
  end

  objectMetadata[tostring(class)] = classMetadata;
  objectMetadata[tostring(class.Static)] = classMetadata;
  objectMetadata[tostring(class.Private)] = classMetadata;

  for methodName, method in pairs(StaticMixin) do
    class.Static[methodName] = method;
  end

  rawset(class, "UsingTypes", UsingTypes);
  rawset(class, "Implements", Implements);

  return class;
end

function Framework:CreateInterface(interfaceName, interfaceRules)
  Framework:Assert(self:IsString(interfaceName),
    "Failed to create interface - bad argument #1 (expected string, got %s)", type(interfaceName));

  Framework:Assert(self:IsTable(interfaceRules),
    "Failed to create interface '%s' - bad argument #2 (expected table, got %s)", type(interfaceRules));

  local interface = self:PopTable();
  local interfaceMetadata = self:PopTable();
  interfaceMetadata.name = interfaceName;
  interfaceMetadata.namespace = interfaceName;
  interfaceMetadata.rules = interfaceRules;

  objectMetadata[tostring(interface)] = interfaceMetadata;

  return interface;
end

-- class = proxyClass namespace is optional
function Framework:Export(tbl, namespace)
  if (objectMetadata[tostring(tbl)] and tbl.Static and tbl.Static.GetClassName) then
    if (namespace) then
      namespace = strformat("%s.%s", namespace, tbl.Static:GetClassName());
    else
      namespace = tbl.Static:GetClassName();
    end
  elseif (not namespace) then
    self:Error("Failed to export entity - namespace required for non-objects");
  end

  local path = self:PopTable(strsplit(".", namespace));

  local current = exported;
  for index, key in ipairs(path) do
    if (index == #path) then
      self:Assert(current[key] == nil, "Export - bad argument #2 (entity already exists at namespace '%s').", namespace);
      current[key] = tbl;
    else
      current[key] = current[key] or self:PopTable();
      current = current[key];
    end
  end

  self:PushTable(path);
  objectMetadata[tostring(tbl)].namespace = namespace;
end

function Framework:Import(namespace, silent)
  local current = exported;
  local sections = self:PopTable(strsplit(".", namespace));

  for _, key in ipairs(sections) do
    if (not current[key]) then
      if (silent) then
        self:PushTable(sections);
        return
      end

      self:Error("Import - bad argument #1 (no entity at namespace '%s').", namespace);
      break
    end

    current = current[key];
  end

  self:PushTable(sections);
  return current;
end

function Framework:DefineParams(...)
  pendingParameterRule = ValidateDefinitionTypes(...);
end

function Framework:DefineReturns(...)
  pendingReturnRule = ValidateDefinitionTypes(...);
end

---A helper function to empty a table.
---@param tbl table @The table to empty.
function Framework:EmptyTable(tbl, deep)
  for key, value in pairs(tbl) do
    if (deep and self:IsTable(value)) then
      self:EmptyTable(value, deep);
    end

    tbl[key] = nil;
  end
end

--------------------------------------
--- Static Mixin
--------------------------------------
function StaticMixin:GetNamespace()
  return objectMetadata[tostring(self)].namespace;
end

function StaticMixin:GetClassName()
  return objectMetadata[tostring(self)].name;
end

function StaticMixin:AddFriendClass(namespaceOrClass)
  local namespace = namespaceOrClass;

  if (Framework:IsTable(namespaceOrClass) and
    Framework:IsTable(namespaceOrClass.Static) and
    Framework:IsFunction(namespaceOrClass.Static.GetNamespace)) then

    namespace = namespaceOrClass.Static:GetNamespace();
  end

  Framework:Assert(Framework:IsString(namespace), "AddFriendClass - bad argument #1 (invalid namespace)");

  local metadata = objectMetadata[tostring(self)];
  metadata.friends = metadata.friends or Framework:PopTable();
  metadata.friends[namespace] = true;
end

function StaticMixin:OnIndexed(callback)
  Framework:Assert(Framework:IsFunction(callback),
    "OnIndexed - bad argument #1 (expected function, got %s)", type(callback));

  local metadata = objectMetadata[tostring(self)];
  metadata.indexedCallback = callback;
end

function StaticMixin:OnIndexChanging(callback)
  Framework:Assert(Framework:IsFunction(callback),
    "OnIndexChanging - bad argument #1 (expected function, got %s)", type(callback));

  local metadata = objectMetadata[tostring(self)];
  metadata.indexChangingCallback = callback;
end

function StaticMixin:OnIndexChanged(callback)
  Framework:Assert(Framework:IsFunction(callback),
    "OnIndexChanged - bad argument #1 (expected function, got %s)", type(callback));

  local metadata = objectMetadata[tostring(self)];
  metadata.indexChangedCallback = callback;
end

function StaticMixin:ProtectProperty(key)
  Framework:Assert(Framework:IsString(key),
    "ProtectProperty - bad argument #1 (expected string, got %s)", type(key));

  local metadata = objectMetadata[tostring(self)];
  metadata.protectedProperties = metadata.protectedProperties or Framework:PopTable();
  metadata.protectedProperties[key] = true;
end

function StaticMixin:GetParentClasses()
  local metadata = objectMetadata[tostring(self)];
  return unpack(metadata.parentClasses);
end

-------------------------------------
--- Instance Mixin
-------------------------------------
function InstanceMixin:Destroy()
  if (self.__Destruct) then
    self:__Destruct();
  end

  local metadata = objectMetadata[tostring(self)];
  Framework:PushTable(metadata.privateData);
  Framework:PushTable(metadata.instanceProperties);
  Framework:PushTable(metadata);

  objectMetadata[tostring(self)] = nil;

  setmetatable(self, nil);
  Framework:EmptyTable(self);
  self.IsDestroyed = true;
end

function InstanceMixin:SetFrame(_, frame)
  local isWidget = Framework:IsTable(frame) and Framework:IsFunction(frame.GetObjectType);

  Framework:Assert(
    isWidget,
    "SetFrame failed - bad argument #1 (Frame expected, got %s)",
    (isWidget and frame:GetObjectType()) or type(frame));

  objectMetadata[tostring(self)].privateData.frame = frame;
end

function InstanceMixin:GetFrame()
  return objectMetadata[tostring(self)].privateData.frame;
end

function InstanceMixin:GetObjectType()
  return objectMetadata[tostring(self)].name;
end

function InstanceMixin:IsObjectType(_, objectType)
  local metadata = objectMetadata[tostring(self)];

  if (metadata.name == objectType) then return true; end

  for _, interfaceMetadata in ipairs(metadata.interfaces) do
    if (interfaceMetadata.name == objectType) then
      return true;
    end
  end

  for _, parent in ipairs(metadata.parentClasses) do
    local parentMetadata = objectMetadata[tostring(parent)];

    if (parentMetadata.name == objectType) then
      return true;
    end
  end

  return false;
end

function InstanceMixin:CallParentMethod(_, methodName, ...)
  local metadata = objectMetadata[tostring(self)];

  for _, parentClass in ipairs(metadata.parentClasses) do
    if (Framework:IsFunction(parentClass[methodName])) then
      metadata.usingParent = parentClass;
      return parentClass[methodName](self, ...); -- should use wrapper to get private data
    end
  end
end

function InstanceMixin:CallParentMethodByClassName(_, parentClassName, methodName, ...)
  local metadata = objectMetadata[tostring(self)];

  for _, parentClass in ipairs(metadata.parentClasses) do
    if (Framework:IsFunction(parentClass[methodName])) then
      if (Framework:IsTable(parentClass.Static) and Framework:IsFunction(parentClass.Static.GetClassName)) then
        local className = parentClass.Static:GetClassName();
        if (parentClassName == className) then
          metadata.usingParent = parentClass;
          return parentClass[methodName](self, ...); -- should use wrapper to get private data
        end
      end
    end
  end
end

-------------------------------------
--- Framework Helper Methods
-------------------------------------
function Framework.IsTable(self, value)
  if (self ~= Framework) then value = self; end
  return type(value) == SimpleTypes[1];
end

function Framework.IsNumber(self, value)
  if (self ~= Framework) then value = self; end
  return type(value) == SimpleTypes[2];
end

function Framework.IsFunction(self, value)
  if (self ~= Framework) then value = self; end
  return type(value) == SimpleTypes[3];
end

function Framework.IsBoolean(self, value)
  if (self ~= Framework) then value = self; end
  return type(value) == SimpleTypes[4];
end

function Framework.IsString(self, value)
  if (self ~= Framework) then value = self; end
  return type(value) == SimpleTypes[5];
end

function Framework.IsNil(self, value)
  if (self ~= Framework) then value = self; end
  return type(value) == SimpleTypes[6];
end

function Framework.IsType(self, value, expectedTypeName)
  if (self ~= Framework) then
    expectedTypeName = value;
    value = self;
  end

  -- check if basic type
  for _, typeName in pairs(SimpleTypes) do
    if (expectedTypeName == typeName) then
      return (expectedTypeName == type(value));
    end
  end

  if (not Framework:IsTable(value)) then
    return false;
  end

  if (Framework:IsFunction(value.IsObjectType) and value:IsObjectType(expectedTypeName)) then
    return true;
  end

  local metadata = objectMetadata[tostring(value)];

  if (metadata) then
    for _, parent in ipairs(metadata.parentClasses) do
      if (parent.Static and parent.Static.GetClassName and parent.Static:GetClassName() == expectedTypeName) then
        return true;
      end
    end
  end

  return false;
end

function Framework.IsObject(self, value)
  if (self ~= Framework) then value = self; end

  if (not Framework.IsTable(value)) then
    return false;
  end

  local isObject = objectMetadata[tostring(value)];

  if (isObject) then
    return true;
  end

  return false;
end

---@param value any @Any value to check whether it is of the expected widget type.
---@param widgetType string @An optional widget type to test if the value is that type of widget.
---@return boolean @true if the value is a Blizzard widgets, such as a Frame or Button.
function Framework.IsWidget(self, value, widgetType)
  if (self ~= Framework) then value = self; end

  if (not Framework:IsTable(value)) then
    return false;
  end

  local isObject = objectMetadata[tostring(value)];

  if (isObject) then
    return false;
  end

  local isWidget = (Framework:IsFunction(value.IsObjectType) and value:IsObjectType("Frame") or value:IsObjectType("Texture"));

  if (isWidget and Framework:IsString(widgetType)) then
    isWidget = value:IsObjectType(widgetType);
  end

  return isWidget;
end

function Framework.IsStringNilOrWhiteSpace(self, value)
  if (self ~= Framework) then value = self; end

  if (value) then
    Framework:Assert(Framework:IsString(value),
      "bad argument #1 (string expected, got %s)", type(value));

      value = value:gsub("%s+", "");

    if (#value > 0) then
      return false;
    end
  end

  return true;
end

do
  local function iterator(wrapper, id)
    if (id ~= wrapper.size) then
      id = id + 1;
      return id, wrapper[id];
    else
      -- reached end of wrapper so finish looping and clean up
      Framework:PushTable(wrapper);
    end
  end

  function Framework:IterateArgs(...)
    local wrapper = self:PopTable(...);
    wrapper.size = select("#", ...);
    return iterator, wrapper, 0;
  end

  -- Only iterates over values found in table and will cut off trailing `nil` values
  function Framework:IterateValues(...)
    local wrapper = self:PopTable(...);
    wrapper.size = #wrapper;
    return iterator, wrapper, 0;
  end
end

do
  local recycledTables = {};
  local pendingClean;
  local C_Timer = _G.C_Timer;
  local seconds = 5;

  local function RunCleaner()
    Framework:EmptyTable(recycledTables);
    pendingClean = nil;
    collectgarbage("collect");
  end

  function Framework:UnpackTable(tbl, startIndex, endIndex)
    if (not self:IsTable(tbl)) then return end

    recycledTables[#recycledTables + 1] = tbl;

    if (#recycledTables > 5 and not pendingClean) then
      pendingClean = true;
      C_Timer.After(seconds, RunCleaner);
    end

    return unpack(tbl, startIndex, endIndex);
  end

  function Framework:PushTable(tbl)
    if (not self:IsTable(tbl)) then return end
    setmetatable(tbl, nil);
    Framework:EmptyTable(tbl);
    self:UnpackTable(tbl); -- call this just to reuse recycling code
  end

  function Framework:PopTable(...)
    local tbl = recycledTables[#recycledTables];

    if (tbl) then
      recycledTables[#recycledTables] = nil;

      -- if table was unpacked, need to clean it here:
      setmetatable(tbl, nil);
      Framework:EmptyTable(tbl);
    else
      tbl = {};
    end

    for index = 1, select("#", ...) do
      tbl[index] = (select(index, ...));
    end

    return tbl;
  end
end

---A helper function to print a table's contents.
---@param tbl table @The table to print.
---@param depth number @An optional number specifying the depth of sub-tables to traverse through and print.
---@param spaces number @An optional number specifying the spaces to print to intent nested values inside a table.
---@param n number @Do NOT manually set this. This controls formatting through recursion.
function Framework:PrintTable(tbl, depth, spaces, n)
  local value = self:ToLongString(tbl, depth, spaces, nil, n);

  -- cannot print the full string because Blizzard's chat frame messes up spacing when it encounters '\n'
  for _, line in self:IterateArgs(strsplit("\n", value)) do
    print(line);
  end
end

---A helper function to return the contents of a table as a long string, similar to
---what the PrintTable utility method prints except it does not print it.
---@param tbl table @The table to convert to a long string.
---@param depth number @An optional number specifying the depth of sub-tables to traverse through and append to the long string.
---@param spaces number @An optional number specifying the spaces to print to intent nested values inside a table.
---@param n number @Do NOT manually set this. This controls formatting through recursion.
---@return string @A long string containing the contents of the table.
function Framework:ToLongString(tbl, depth, spaces, result, n)
  result = result or "";
  n = n or 0;
  spaces = spaces or 2;
  depth = depth or 5;

  if (depth == 0) then
    return strformat("%s\n%s", result, strrep(' ', n).."...");
  end

  for key, value in pairs(tbl) do
    if (key and self:IsNumber(key) or self:IsString(key)) then
      key = strformat("[\"%s\"]", key);

      if (self:IsTable(value)) then
        if (#result > 0) then
          result = strformat("%s\n%s", result, strrep(' ', n));
        else
          result = strrep(' ', n);
        end

        if (next(value)) then
          if (depth == 1) then
            result = strformat("%s%s = { ... },", result, key);
          else
            result = strformat("%s%s = {", result, key);
            result = self:ToLongString(value, depth - 1, spaces, result, n + spaces);
            result = strformat("%s\n%s},", result, strrep(' ', n));
          end
        else
          result = strformat("%s%s%s = {},", result, strrep(' ', n), key);
        end
      else
        if (self:IsString(value)) then
          value = strformat("\"%s\"", value);
        else
          value = tostring(value);
        end

        result = strformat("%s\n%s%s = %s,", result, strrep(' ', n), key, value);
      end
    end
  end

  return result;
end

function Framework:Assert(condition, errorMessage, ...)
  if (not condition) then
    if (errorMessage) then
      local size = select("#", ...);

      if (size > 0) then
        local args = Framework:PopTable(...);

        for i = 1, size do
          if (args[i] == nil) then
            args[i] = SimpleTypes[6];

          elseif (not Framework:IsString(args[i])) then
            args[i] = tostring(args[i]);
          end
        end

        errorMessage = strformat(errorMessage, Framework:UnpackTable(args));

      elseif (strmatch(errorMessage, "%s")) then
        errorMessage = strformat(errorMessage, SimpleTypes[6]);
      end
    else
      errorMessage = "condition failed";
    end

    error(errorMessage);
  end
end

function Framework:Error(errorMessage, ...)
  self:Assert(false, errorMessage, ...);
end