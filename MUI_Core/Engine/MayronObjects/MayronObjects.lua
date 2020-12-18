-- luacheck: ignore self 143 631
local addOnName = ...;
local type, tonumber, pairs = _G.type, _G.tonumber, _G.pairs;

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
local Framework = _G.MayronObjects:NewFramework("3.1.2");

if (not Framework) then return end

local error, unpack, next, ipairs = _G.error, _G.unpack, _G.next, _G.ipairs;
local setmetatable, table, string = _G.setmetatable, _G.table, _G.string;
local getmetatable, select, pcall, strsplit = _G.getmetatable, _G.select, _G.pcall, _G.strsplit;
local tostring, collectgarbage, print = _G.tostring, _G.collectgarbage, _G.print;

Framework.Types = {};
Framework.Types.Table    = "table";
Framework.Types.Number   = "number";
Framework.Types.Function = "function";
Framework.Types.Boolean  = "boolean";
Framework.Types.String   = "string";
Framework.Types.Nil      = "nil";

-- holds class, instance, and interface controllers
-- used for controlling behaviour of these "entities"
local AllControllers = {};

-- handles validation for strongly-typed parameter and return values when calling a functions
local ProxyStack = {};

--[[
-- contains functions converted to strings to track function locations when inheritance is used
-- for example, if function cannot be found then control is switched to parent and function needs to be
-- temporarily stored during this process.
--]]
ProxyStack.funcStrings = {};

local Core = {}; -- holds all private core functions for internal use
Core.Framework = Framework;
Core.PREFIX = "|cffffcc00MayronObjects: |r"; -- this is used when printing out errors
Core.ExportedPackages = {}; -- contains all exported packages
Core.DebugMode = false;

--[[
-- need a reference for this to hack around the manual exporting process
-- (exporting the package class but it's already a package...)
--]]

---@class Package
local Package;

--------------------------------------------
-- MayronObjects Functions
--------------------------------------------
function Framework:IsTable(value)
  return type(value) == Framework.Types.Table;
end

function Framework:IsNumber(value)
  return type(value) == Framework.Types.Number;
end

function Framework:IsFunction(value)
  return type(value) == Framework.Types.Function;
end

function Framework:IsBoolean(value)
  return type(value) == Framework.Types.Boolean;
end

function Framework:IsString(value)
  return type(value) == Framework.Types.String;
end

function Framework:IsNil(value)
  return type(value) == Framework.Types.Nil;
end

function Framework:IsObject(value)
  if (not Framework:IsTable(value)) then
    return false;
  end

  return (Core:GetController(value, true) ~= nil);
end

---@param value any @Any value to check whether it is of the expected widget type.
---@param widgetType string @An optional widget type to test if the value is that type of widget.
---@return boolean @true if the value is a Blizzard widgets, such as a Frame or Button.
function Framework:IsWidget(value, widgetType)
  if (not Framework:IsTable(value)) then
    return false;
  end

  local isObject = (Core:GetController(value, true) ~= nil);

  if (isObject) then
    return false;
  end

  local isWidget = (value.GetObjectType ~= nil and value.GetName ~= nil);

  if (isWidget and self:IsString(widgetType)) then
    isWidget = value:GetObjectType() == widgetType;
  end

  return isWidget;
end

function Framework:IsStringNilOrWhiteSpace(value)
  return Core:IsStringNilOrWhiteSpace(value);
end

-- Helper function to check if value is a specified type
-- @param value: The value to check the type of (can be nil)
-- @param expectedTypeName: The exact type to check for (can be ObjectType)
-- @return (boolean): Returns true if the value type matches the specified type
function Framework:IsType(value, expectedTypeName)
  return Core:IsMatchingType(value, expectedTypeName);
end

do
  local wrappers = {};
  local pendingClean;
  local C_Timer = _G.C_Timer;

  local function CleanWrappers()
    Framework:EmptyTable(wrappers);
    pendingClean = nil;
    collectgarbage("collect");
  end

  local function iterator(wrapper, id)
    if (id ~= #wrapper) then
      id = id + 1;
      return id, wrapper[id];
    else
      -- reached end of wrapper so finish looping and clean up
      Framework:PushTable(wrapper);
    end
  end

  local function PushTable(wrapper)
    if (not wrappers[tostring(wrapper)]) then
      wrappers[#wrappers + 1] = wrapper;
      wrappers[tostring(wrapper)] = true;
    end

    if (#wrappers >= 10 and not pendingClean) then
      pendingClean = true;
      C_Timer.After(10, CleanWrappers);
    end
  end

  ---@return table @An empty table
  function Framework:PopTable(...)
    local wrapper;

    -- get wrapper before iterating
    if (#wrappers > 0) then
      wrapper = wrappers[#wrappers];
      wrappers[#wrappers] = nil;
      wrappers[tostring(wrapper)] = nil;

      -- empty table (incase tk.Tables:UnpackTable was used)
      for key, _ in pairs(wrapper) do
        wrapper[key] = nil;
      end
    else
      -- create new wrapper (required if a for-loop call to
      -- IterateArgs is nested inside another IterateArgs call)
      wrapper = {};
    end

    local arg;
    local length = select("#", ...);
    -- fill wrapper
    for index = 1, length do
      arg = (select(index, ...));

      if (arg ~= nil) then
        wrapper[index] = arg;
      end
    end

    return wrapper, length;
  end

  ---@param wrapper table @A table to be added to the stack. The table is emptied and detached from any meta-table
  ---@param pushSubTables boolean|function @Whether sub tables found in the table should also be pushed to the stack
  function Framework:PushTable(wrapper, pushSubTables, path)
    if (not self:IsTable(wrapper) or self:IsWidget(wrapper)) then
      return;
    end

    local push = true;

    for key, _ in pairs(wrapper) do
      if (pushSubTables and self:IsTable(wrapper[key]) and not self:IsWidget(wrapper)) then

        local nextPath;

        if (path) then
          nextPath = string.format("%s.%s", path, tostring(key));
        else
          nextPath = tostring(key);
        end

        if (self:IsFunction(pushSubTables)) then
          push = pushSubTables(wrapper, wrapper[key], key, nextPath);
        end

        if (push) then
          self:PushTable(wrapper[key], pushSubTables, nextPath);
        end
      end

      wrapper[key] = nil;
    end

    if (push) then
      setmetatable(wrapper, nil);
      PushTable(wrapper);
    end
  end

  ---@param wrapper table @A table to be unpacked and pushed to the stack to be emptied later.
  ---@param doNotPushTable boolean @If true, the table will not be pushed
  function Framework:UnpackTable(wrapper, doNotPushTable)
    if (not self:IsTable(wrapper)) then return end

    local length = 1;

    -- cannot trust select("#", wrapper);
    for id, _ in pairs(wrapper) do
      if (id > length) then
        length = id;
      end
    end

    if (not doNotPushTable) then
      PushTable(wrapper);
    end

    return unpack(wrapper, 1, length);
  end

  function Framework:IterateArgs(...)
    local wrapper = self:PopTable(...);
    return iterator, wrapper, 0;
  end
end

---A helper function to empty a table.
---@param tbl table @The table to empty.
function Framework:EmptyTable(tbl)
  for key, _ in pairs(tbl) do
    tbl[key] = nil;
  end
end

---A helper function to add all values from one table to another table.
---Also works with nested tables with matching keys.
---@param tbl table @The table to add all values into from the other table (otherTbl).
---@param otherTbl table @The other table to copy values from and place into the first table (tbl).
---@param preserveOldValue boolean @If true and a key is found in both tables, the value will not be
---overridden by the one in the other table (otherTbl).
function Framework:FillTable(tbl, otherTbl, preserveOldValue)
  for key, value in pairs(otherTbl) do
    if (self:IsTable(tbl[key]) and self:IsTable(value)) then
      self:Fill(tbl[key], value, preserveOldValue);

    elseif (not preserveOldValue or self:IsNil(tbl[key])) then
      if (self:IsTable(value)) then
        tbl[key] = self:PopTable();
        self:Fill(tbl[key], value);
      else
        tbl[key] = value;
      end
    end
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
    return string.format("%s\n%s", result, string.rep(' ', n).."...");
  end

  for key, value in pairs(tbl) do
    if (key and self:IsNumber(key) or self:IsString(key)) then
      key = string.format("[\"%s\"]", key);

      if (self:IsTable(value)) then
        if (#result > 0) then
          result = string.format("%s\n%s", result, string.rep(' ', n));
        else
          result = string.rep(' ', n);
        end

        if (next(value)) then
          if (depth == 1) then
            result = string.format("%s%s = { ... },", result, key);
          else
            result = string.format("%s%s = {", result, key);
            result = self:ToLongString(value, depth - 1, spaces, result, n + spaces);
            result = string.format("%s\n%s},", result, string.rep(' ', n));
          end
        else
          result = string.format("%s%s%s = {},", result, string.rep(' ', n), key);
        end
      else
        if (self:IsString(value)) then
          value = string.format("\"%s\"", value);
        else
          value = tostring(value);
        end

        result = string.format("%s\n%s%s = %s,", result, string.rep(' ', n), key, value);
      end
    end
  end

  return result;
end

---@param packageName string @The name of the package.
---@param namespace string @The parent package namespace. Example: "Framework.System.package".
---@return Package @Returns a package object.
function Framework:CreatePackage(packageName, namespace)
  local newPackage = Package(packageName, namespace);

  Core:Assert(newPackage ~= nil, "Failed to create new Package '%s'", packageName);

  -- export the package only if a namespace is supplied
  if (not Core:IsStringNilOrWhiteSpace(namespace)) then
    self:Export(newPackage, namespace);
  end

  return newPackage;
end

---@param namespace string @The entity namespace (required for locating it). (an entity = a package, class or interface).
---@param silent boolean @If true, no error will be triggered if the entity cannot be found.
---@return Package|Class|Interface @Returns the found entity (or false if silent).
function Framework:Import(namespace, silent)
  local entity;
  local currentNamespace = "";
  local nodes = Framework:PopTable(strsplit(".", namespace));

  for id, key in ipairs(nodes) do
    Core:Assert(not Core:IsStringNilOrWhiteSpace(key), "Import - bad argument #1 (invalid entity name).");

    if (id > 1) then
      currentNamespace = string.format("%s.%s", currentNamespace, key);
      entity = entity:Get(key, silent);
    else
      currentNamespace = key;
      entity = Core.ExportedPackages[key];
    end

    if (not entity and silent) then
      return false;
    end

    if (id < #nodes) then
      Core:Assert(entity, "Import - bad argument #1 ('%s' package not found).", currentNamespace);
    else
      Core:Assert(entity, "Import - bad argument #1 ('%s' entity not found).", currentNamespace);
    end
  end

  Framework:PushTable(nodes);

  if (not silent) then
    local controller = Core:GetController(entity, true);

    Core:Assert(controller or entity.IsObjectType and entity:IsObjectType("Package"),
    "Import - bad argument #1 (invalid namespace '%s').", namespace);

    Core:Assert(entity ~= Core.ExportedPackages, "Import - bad argument #1 ('%s' package not found).", namespace);
  end

  return entity;
end

---@param namespace string @(Optional) The package namespace (required for locating and importing it).
---@param package Package @A package instance object.
function Framework:Export(package, namespace)
  local classController = Core:GetController(package);
  Core:Assert(classController and classController.IsPackage, "Export - bad argument #1 (package expected)");

  if (not namespace) then
    local key = package:GetName();
    Core.ExportedPackages[key] = package;
    return
  end

  local parentPackage;

  for id, key in self:IterateArgs(strsplit(".", namespace)) do
    Core:Assert(not Core:IsStringNilOrWhiteSpace(key), "Export - bad argument #2 (invalid namespace).");
    key = key:gsub("%s+", "");

    if (id > 1) then
      if (not parentPackage:Get(key)) then
        -- auto-create empty packages if not found in namespace
        parentPackage:AddSubPackage(Framework:CreatePackage(key));
      end

      parentPackage = parentPackage:Get(key);
    else
      -- auto-create empty packages if not found in namespace
      Core.ExportedPackages[key] = Core.ExportedPackages[key] or Framework:CreatePackage(key);
      parentPackage = Core.ExportedPackages[key];
    end
  end

  -- add package to the last (parent) package specified in the namespace
  parentPackage:AddSubPackage(package, namespace);
end

---@param silent boolean @True if errors should be cause in the error log instead of triggering.
function Framework:SetSilentErrors(silent)
  Core.silent = silent;
end

---@return table @Contains index/string pairs of errors caught while in silent mode.
function Framework:GetErrorLog()
  Core.errorLog = Core.errorLog or {};
  return Core.errorLog;
end

---Empties the error log table.
function Framework:FlushErrorLog()
  if (Core.errorLog) then
    Framework:EmptyTable(Core.errorLog);
  end
end

---@return number @The total number of errors caught while in silent mode.
function Framework:GetNumErrors()
  return (Core.errorLog and #Core.errorLog) or 0;
end

---Proxy function to allow outside users to use Core:Assert()
---@param condition boolean @A predicate to evaluate.
---@param errorMessage string @(Optional) An error message to throw if condition is evaluated to false.
---@vararg any @A list of arguments to be inserted into the error message using string.format.
function Framework:Assert(condition, errorMessage, ...)
  Core:Assert(condition, errorMessage, ...);
end

---Proxy function to allow outside users to use Core:Error()
---@param errorMessage string @The error message to throw.
---@vararg any @A list of arguments to be inserted into the error message using string.format.
function Framework:Error(errorMessage, ...)
  Core:Error(errorMessage, ...);
end

---Attach an error handling function to call when an error occurs to be handled manually.
---@param errorHandler function @The error handler callback function.
function Framework:SetErrorHandler(errorHandler)
  Core.errorHandler = errorHandler;
end

---Do NOT use this unless you are a MayronObjects developer.
---@param debug boolean @Set the Frameworkrary to debug mode.
function Framework:SetDebugMode(debug)
  Core.DebugMode = debug;
end

-------------------------------------
-- ProxyStack
-------------------------------------

-- Pushes the proxy function back into the stack object once no longer needed.
-- Also, resets the state of the proxy function for future use.
-- @param proxyFunc (function) - a proxy function returned from ProxyStack:Pop();
function ProxyStack:Push(proxyObject)
  self[#self + 1] = proxyObject;

  proxyObject.object        = nil;
  proxyObject.key           = nil;
  proxyObject.self          = nil;
  proxyObject.privateData   = nil;
  proxyObject.controller    = nil;
end

function ProxyStack:Pop()
  if (#self == 0) then
    return Framework:PopTable();
  end

  local proxyObject = self[#self];
  self[#self] = nil;

  return proxyObject;
end

-- intercepts function calls on classes and instance objects and returns a proxy function used for validation.
-- @param object (table) - a table containing all functions assigned to a class or interface.
-- @param key (string) - the function name/key being called.
-- @param self (table) - the instance or class object originally being called with the function name/key.
-- @param controller (table) - the entities meta-data (stores validation rules and more).
-- @return proxyFunc (function) - the proxy function is returned and called instead of the real function.
local function CreateProxyObject(object, key, self, controller, privateData)
  local proxyObject = ProxyStack:Pop();

  proxyObject.object = object;
  proxyObject.key = key;
  proxyObject.self = self;
  proxyObject.controller = controller;
  proxyObject.privateData = privateData;

  -- we need multiple Run functions in case 1 function calls another (Run is never removed after being assigned)
  proxyObject.run = proxyObject.run or function(_, ...)
    -- Validate parameters passed to function
    local definition, errorMessage = Core:GetParamsDefinition(proxyObject);
    local args = Core:ValidateFunctionCall(definition, errorMessage, ...);

    -- Silent errors
    if (not Framework:IsTable(args)) then return end

    if (not Framework:IsTable(proxyObject.privateData) and not proxyObject.key:match("Static.")) then
      if (proxyObject.controller.isInterface) then
        Core:Error("%s.%s is an interface function and must be implemented and invoked by an instance object.",
          proxyObject.controller.objectName, proxyObject.key);
      else
        Core:Error("%s.%s is a non-static function and must be invoked by an instance object.",
          proxyObject.controller.objectName, proxyObject.key);
      end

      return
    end

    definition, errorMessage = Core:GetReturnsDefinition(proxyObject);

    if (not(Framework:IsFunction(proxyObject.object[proxyObject.key]))) then
      Core:Error("Could not find function '%s' for object '%s'",
        proxyObject.key, proxyObject.controller.objectName);

      return
    end

    -- execute attributes:
    local attributes = Core:GetAttributes(proxyObject);

    if (Framework:IsTable(attributes)) then
      for _, attribute in ipairs(attributes) do
        if (not attribute:OnExecute(proxyObject.self, proxyObject.privateData, proxyObject.key, Framework:UnpackTable(args, true))) then
          Framework:PushTable(args);
          return nil; -- if attribute returns false, do no move onto the next attribute and do not call function
        end
      end
    end

    local returnValues;
    if (proxyObject.privateData) then
      -- Validate return values received after calling the function
      returnValues = Core:ValidateFunctionCall(definition, errorMessage,
        -- call function here:
        proxyObject.object[proxyObject.key](proxyObject.self, proxyObject.privateData, Framework:UnpackTable(args)));
    else
      -- Validate return values received after calling the STATIC function
      returnValues = Core:ValidateFunctionCall(definition, errorMessage,
        -- call function here:
        proxyObject.object[proxyObject.key](proxyObject.self, Framework:UnpackTable(args)));
    end

    -- Silent errors
    if (not Framework:IsTable(returnValues)) then return nil; end

    if (proxyObject.key ~= "Destroy") then
      local instanceController = Core:GetController(proxyObject.self, true);

      if (instanceController and Framework:IsTable(instanceController.UsingParentControllers)) then
        -- might have been destroyed during the function call
        Framework:PushTable(instanceController.UsingParentControllers);
        instanceController.UsingParentControllers = nil;
      end
    end

    ProxyStack:Push(proxyObject);

    if (#returnValues == 0) then
      Framework:PushTable(returnValues);
      return nil; -- fixes returning nil instead of nothing
    end

    return Framework:UnpackTable(returnValues);
  end

  ProxyStack.funcStrings[tostring(proxyObject.run)] = proxyObject;
  return proxyObject.run;
end

-- Needed for editing the proxyObject properties because ProxyStack:Pop only returns the runnable function
-- @param func (function) - converts function to string to be used as a key to access the corresponding proxyObject.
-- @return proxyFunc (function) - the proxyObject.
local function GetStoredProxyObject(proxyFunc)
  return ProxyStack.funcStrings[tostring(proxyFunc)];
end

-------------------------------------
-- Core Functions
-------------------------------------

do
  local proxyClassMT = {}; -- acts as a filter to protect invalid keys from being indexed into Class

  -- ProxyClassMT meta-methods ------------------------
  proxyClassMT.__call = function(self, ...)
    local classController = Core:GetController(self);
    return Core:CreateInstance(classController, ...);
  end

  proxyClassMT.__index = function(self, key)
    local classController = Core:GetController(self);
    local class = classController.class;
    local value = class[key]; -- get the real value

    if (Framework:IsFunction(value)) then
      -- get a proxy function object to validate function params and return values
      value = CreateProxyObject(class, key, self, classController);

    elseif (value == nil) then
      -- no real value stored in Class
      if (classController.parentProxyClass) then
        -- search parent class instead
        value = classController.parentProxyClass[key];

        if (Framework:IsFunction(value)) then
          -- need to update the "self" reference to use this class, not the parent!
          local proxyObject = GetStoredProxyObject(value);
          proxyObject.self = self;
        end
      end

      if (value == nil and classController.objectName == "FrameWrapper" and key ~= "GetFrame") then
        -- note: cannot check if frame has key here...
        -- if value is still not found and object has a GetFrame method (usually
        -- from inheriting FrameWrapper) then index the frame
        value = CreateProxyObject(class, "GetFrame", self, classController);
      end
    end

    if (classController.UsingChild and Framework:IsFunction(value)) then
      local isVirtual = classController.virtualFunctions and classController.virtualFunctions[key];

      if (isVirtual) then
        -- if Object:Parent() was used, call parent function with the child as the reference
        local child = classController.UsingChild;
        local childController = Core:GetController(child);
        local proxyObject = GetStoredProxyObject(value);

        proxyObject.privateData = Core:GetPrivateInstanceData(child, childController);
      end
    end

    return value;
  end

  proxyClassMT.__newindex = function(self, key, value)
    local classController = Core:GetController(self);

    if (key == "Static" or key == "Private") then
      -- not allowed to override these Class properties
      Core:Error("%s.%s are reserved class properties.", classController.objectName, key);
      return;
    end

    if (classController.isProtected) then
      Core:Error("%s is protected.", classController.objectName);
    end

    if (Framework:IsFunction(value)) then
      -- Adds temporary definition info to ClassController.definitions table
      Core:AttachFunctionDefinition(classController, key);
      classController.class[key] = value;
    else
      Core:Error("Failed to add non-function value to %s.%s. Use the Static table instead.", classController.objectName, key);
    end
  end

  proxyClassMT.__tostring = function(self)
    setmetatable(self, nil);

    local classController = AllControllers[tostring(self)];
    local str = tostring(self):gsub(Framework.Types.Table, string.format("<Class> %s", classController.objectName));

    setmetatable(self, proxyClassMT);

    return str;
  end

  local proxyPrivateMT = {};

  proxyPrivateMT.__newindex = function(self, key, value)
    local classController = Core:GetController(self);
    key = string.format("Private.%s", key);

    if (classController.isProtected) then
      Core:Error("%s is protected.", classController.objectName);
    end

    if (Framework:IsFunction(value)) then
      -- Adds temporary definition info to ClassController.definitions table
      Core:AttachFunctionDefinition(classController, key);
      classController.privateFunctions[key] = value;
    else
      -- get a proxy function object to validate function params and return values
      Core:Error("Only private functions should be added to this table.");
    end
  end

  proxyPrivateMT.__index = function(self, key)
    local classController = Core:GetController(self);
    key = string.format("Private.%s", key);

    local value = classController.privateFunctions[key]; -- get the real value

    if (Framework:IsFunction(value)) then
      -- get a proxy function object to validate function params and return values
      Core:Error("%s.%s is a non-static function and must be invoked by an instance object.",
        classController.objectName, key);

      return
    end

    return value;
  end

  local proxyStaticMT = {};

  proxyStaticMT.__newindex = function(self, key, value)
    local classController = Core:GetController(self);
    key = string.format("Static.%s", key);

    if (classController.isProtected) then
      Core:Error("%s is protected.", classController.objectName);
    end

    if (Framework:IsFunction(value)) then
      -- Adds temporary definition info to ClassController.definitions table
      Core:AttachFunctionDefinition(classController, key);
      classController.staticData[key] = value;
    end

    classController.staticData[key] = value;
  end

  proxyStaticMT.__index = function(self, key)
    local classController = Core:GetController(self);
    key = string.format("Static.%s", key);

    local value = classController.staticData[key]; -- get the real value

    if (Framework:IsFunction(value)) then
      return CreateProxyObject(classController.staticData, key, self, classController);
    end

    return value;
  end

  function Core:CreateClass(package, packageData, className, parentProxyClass, ...)
    local class            = Framework:PopTable(); -- stores real table indexes (once proxy has completed evaluating data)
    local proxyClass       = Framework:PopTable(); -- enforces __newindex meta-method to always be called (new indexes, if valid, are added to Class instead)
    local definitions      = Framework:PopTable(); -- function definitions for params and return values
    local friends          = Framework:PopTable(); -- friend classes can access instance private data of this class
    local classController  = Framework:PopTable(); -- holds special Framework data to control class
    local privateFunctions = Framework:PopTable(); -- holds all private class functions
    local staticData       = Framework:PopTable(); -- holds all static class functions

    classController.isClass = true;
    classController.objectName = className;
    classController.proxy = proxyClass;
    classController.definitions = definitions;
    classController.class = class;
    classController.privateFunctions = privateFunctions;
    classController.staticData = staticData;

    -- protected table for assigning Static functions
    class.Static = setmetatable(Framework:PopTable(), proxyStaticMT);
    class.Private = setmetatable(Framework:PopTable(), proxyPrivateMT);

    AllControllers[tostring(class.Private)] = classController;
    AllControllers[tostring(class.Static)] = classController;

    if (package and packageData) then
      -- link new class to package
      classController.package = package; -- only used for GetPackage()
      classController.packageData = packageData;
      packageData.entities[className] = proxyClass;

      if (className:match("<") and className:match(">")) then
        classController.isGenericType = true;
        classController.genericTypes = self:GetGenericTypesFromClassName(className);
      end

      self:SetParentClass(classController, parentProxyClass);
      self:SetInterfaces(classController, ...);

      -- ProxyClass functions --------------------------
      class.Static.AddFriendClass = function(_, friendClassName)
        friends[friendClassName] = true;
      end

      class.Static.IsFriendClass = function(_, friendClassName)
        if (friendClassName == className) then
          return true;
        end

        return friends[friendClassName];
      end

      class.Static.OnIndexChanged = function(_, callback)
        classController.indexChangedCallback = callback;
      end

      class.Static.OnIndexChanging = function(_, callback)
        classController.indexChangingCallback = callback;
      end

      class.Static.OnIndexed = function(_, callback)
        classController.indexedCallback = callback;
      end

      class.Static.OnIndexing = function(_, callback)
        classController.indexingCallback = callback;
      end

      proxyClass.Of = function(_, ...)
        Core:Assert(classController.isGenericType, "%s is not a generic class", className);
        classController.tempRealGenericTypes = Framework:PopTable();

        for id, realType in Framework:IterateArgs(...) do
          if (Framework:IsObject(realType)) then
            local controller = Core:GetController(realType);
            realType = controller.objectName;
          end

          classController.tempRealGenericTypes[id] = (realType:gsub("%s+", ""));
        end

        return proxyClass;
      end
    else
      -- creating the Package class (cannot assign it to a package
      -- instance as Package class does not exist!)
      classController.IsPackage = true;
    end

    AllControllers[tostring(proxyClass)] = classController;
    setmetatable(proxyClass, proxyClassMT);

    return proxyClass;
  end
end

do
  local proxyInstanceMT = {}; -- acts as a filter to protect invalid keys from being indexed into Instance
  local GetFrame = "GetFrame";
  local innerValues = {};

  local frameWrapperFunction = function(_, ...)
    -- call the frame (a blizzard widget) here
    return innerValues.frame[innerValues.key](innerValues.frame, ...);
  end

  local function GetFrameWrapperFunction(value, key)
    -- ProxyClass changed key to GetFrame during __index meta-method call
    local frame = value(); -- call the proxyObject.Run function here to get the frame

    if (not (Framework:IsTable(frame) and frame.GetObjectType)) then
      -- might be a property we are searching for, so do not throw an error!
      return nil;
    end

    if (frame[key]) then
      -- if the frame has the key we are trying to get...

      if (Framework:IsFunction(frame[key])) then
        innerValues.frame = frame;
        innerValues.key = key;
        value = frameWrapperFunction;
      else
        value = frame[key];
      end
    else
      value = nil; -- no frame found
    end

    return value;
  end

  local function GetControllerForConcreteFunction(instanceController, key)
    local selectedController;

    if (instanceController.instance[key]) then
      selectedController = instanceController;
    end

    for _, parentController in ipairs(instanceController.UsingParentControllers) do
      if (parentController.class[key]) then
        if (parentController.virtualFunctions and parentController.virtualFunctions[key]) then
          if (not selectedController) then
            return parentController;
          else
            return selectedController;
          end
        else
          selectedController = parentController;
        end
      end
    end

    return selectedController;
  end

  proxyInstanceMT.__index = function(self, key)
    local instanceController = Core:GetController(self);
    local classController = instanceController.classController;
    local privateData = instanceController.privateData;
    local value;

    if (classController.indexingCallback) then
      value = classController.indexingCallback(self, privateData, key);
    end

    if (key == "Parent") then
      if (instanceController.UsingParentControllers) then
        local parentControllers = instanceController.UsingParentControllers;
        local parentController = parentControllers[#parentControllers];
        local nextParentController = Core:GetController(parentController.parentProxyClass);

        table.insert(instanceController.UsingParentControllers, nextParentController);
      else
        local parentController = Core:GetController(instanceController.parentProxyClass);
        instanceController.UsingParentControllers = Framework:PopTable(parentController);
      end

      return instanceController.proxy;
    end

    if (value == nil and instanceController.UsingParentControllers) then
      local selectedParentController = GetControllerForConcreteFunction(instanceController, key);

      if (selectedParentController and selectedParentController.class[key]) then
        value = CreateProxyObject(
          selectedParentController.class, -- object/scope
          key, self, selectedParentController, privateData
        );
      end
    end

    -- check if instance property
    if (value == nil and instanceController.instance[key] ~= nil) then
      value = instanceController.instance[key];

      if (Framework:IsFunction(value)) then
        value = CreateProxyObject(instanceController.instance, key, self, instanceController);

        local proxyObject = GetStoredProxyObject(value);
        proxyObject.privateData = privateData; -- set PrivateData to be injected into function call

        if (proxyObject.key == GetFrame and key ~= GetFrame) then
          value = GetFrameWrapperFunction(value, key);
        end
      end
    end

    -- check if class has key
    if (value == nil and key ~= "Private") then
      value = classController.proxy[key];

      if (Framework:IsFunction(value)) then
        local proxyObject = GetStoredProxyObject(value);
        proxyObject.self = self; -- switch ProxyClass reference to proxyInstance
        proxyObject.privateData = privateData; -- set PrivateData to be injected into function call

        if (proxyObject.key == GetFrame and key ~= GetFrame) then
          value = GetFrameWrapperFunction(value, key);
        end
      end
    end

    if (classController.indexedCallback) then
      value = classController.indexedCallback(self, privateData, key, value);
    end

    return value;
  end

  proxyInstanceMT.__newindex = function(self, key, value)
    local instanceController = Core:GetController(self);

    if (instanceController.protectedProperties and instanceController.protectedProperties[key]) then
      Core:Error("Failed to override protected instance property '%s' for object '%s'.", key, instanceController.objectName);
    end

    local classController = instanceController.classController;
    local instance = instanceController.instance;

    Core:Assert(not classController.class[key],
      "Cannot override class-level property '%s.%s' from an instance.", classController.objectName, key);

    if (instanceController.objectName ~= "Package") then
      Core:Assert(key ~= "Parent", "Cannot override protected 'Parent' instance property.");
    end

    if (classController.indexChangingCallback) then
      local preventIndexing = classController.indexChangingCallback(self, instanceController.privateData, key, value);

      if (preventIndexing) then
        -- do not continue indexing
          return;
        end
      end

      instance[key] = value

      -- if reassigning an instance property, should check that new value is valid
      if (instanceController.isConstructed and Framework:IsTable(classController.propertyDefinitions)) then
        local propertyDefinition = classController.propertyDefinitions[key];

        if (propertyDefinition) then
          Core:ValidateImplementedInterfaceProperty(key, propertyDefinition, value, classController.objectName);
        end
      end

      if (classController.indexChangedCallback) then
        classController.indexChangedCallback(self, instanceController.privateData, key, value);
      end
  end

  proxyInstanceMT.__gc = function(self)
    self:Destroy();
  end

  proxyInstanceMT.__tostring = function(self)
    setmetatable(self, nil);

    local instanceController = AllControllers[tostring(self)];
    local className = instanceController.classController.objectName;
    local str;

    if (instanceController.name) then
      str = tostring(self):gsub(Framework.Types.Table, string.format("<Instance> %s (%s)", className, instanceController.name));
    else
      str = tostring(self):gsub(Framework.Types.Table, string.format("<Instance> %s", className));
    end

    setmetatable(self, proxyInstanceMT);

    return str;
  end

  function Core:CreateInstance(classController, ...)
    local instance              = Framework:PopTable(); -- stores real table indexes (once proxy has completed evaluating data)
    local instanceController    = Framework:PopTable(); -- holds special Framework data to control instance
    local privateData           = Framework:PopTable(); -- private instance data passed to function calls (the 2nd argument)
    local proxyInstance         = Framework:PopTable(); -- enforces __newindex meta-method to always be called (new indexes, if valid, are added to Instance instead)
    local definitions           = Framework:PopTable(); -- used for generic types

    instanceController.privateData = privateData;
    instanceController.instance = instance;
    instanceController.classController = classController;
    instanceController.definitions = definitions;
    instanceController.proxy = proxyInstance;

    self:InheritFunctions(instanceController, classController);

    if (classController.isGenericType) then
      -- renames EntiyName for instance controller, and creates "RealGenericTypes" instance controller property
      instanceController.objectName = self:ApplyGenericTypesToInstance(instanceController.definitions, classController);
    end

    -- interfaceController requires knowledge of many classController settings
    local instanceControllerMT = Framework:PopTable();
    instanceControllerMT.__index = classController;

    setmetatable(instanceController, instanceControllerMT);

    privateData.GetFriendData = function(_, friendInstance)
      local friendClassName = friendInstance:GetObjectType();
      local friendClass = classController.packageData.entities[friendClassName]; -- must be in same package!

      Framework:Assert(friendClass and friendClass.Static:IsFriendClass(classController.objectName),
        "'%s' is not a friend class of '%s'", friendClassName, classController.objectName);

      return self:GetPrivateInstanceData(friendInstance);
    end

    privateData.Call = function(_, privateFunctionName, ...)
      Framework:Assert(Framework:IsString(privateFunctionName),
        "Failed to call private function - bad argument #1 (string expected, got %s)", type(privateFunctionName));

      privateFunctionName = string.format("Private.%s", privateFunctionName);
      local func = classController.privateFunctions[privateFunctionName];

      Framework:Assert(Framework:IsFunction(func),
        "Failed to call private function - Unknown private function '%s'", type(privateFunctionName));

      func = CreateProxyObject(
        classController.privateFunctions,
        privateFunctionName,
        proxyInstance,
        classController);

      local proxyObject = GetStoredProxyObject(func);
      proxyObject.privateData = privateData; -- set PrivateData to be injected into function call

      return func(nil, ...);
    end

    AllControllers[tostring(proxyInstance)] = instanceController;
    setmetatable(proxyInstance, proxyInstanceMT);

    -- Clone or Create Instance here:
    if (classController.cloneFrom) then
      local otherInstance = classController.cloneFrom;
      local otherController = self:GetController(otherInstance);
      local otherInstanceData = self:GetPrivateInstanceData(otherInstance, otherController);

      self:Assert(otherInstanceData, "Invalid Clone Object.");
      self:CopyTableValues(otherInstanceData, privateData);
      classController.cloneFrom = nil;
    else
      if (proxyInstance.__Construct) then
        -- call custom constructor here!
        proxyInstance:__Construct(...);
      end

      if (Framework:IsTable(classController.interfaces)) then
        Core:ValidateImplementedInterfaces(instance, classController);
      end
    end

    instanceController.isConstructed = true;
    return proxyInstance;
  end
end

function Core:CreateInterface(packageData, interfaceName, interfaceDefinition)
  local interface                  = Framework:PopTable();
  local interfaceController        = Framework:PopTable();

  interfaceController.proxy        = interface; -- reference to the interface (might not be needed)
  interfaceController.objectName   = interfaceName; -- class and interface controllers are grouped together so we use "Entity" name
  interfaceController.definition   = interfaceDefinition -- holds interface definitions
  interfaceController.isInterface  = true; -- to distinguish between a class and an interface controller
  interfaceController.packageData  = packageData; -- used for when attaching function definitions

  AllControllers[tostring(interface)] = interfaceController;

  return interface;
end

-- returns comma-separated string list of generic type placeholders (example: "K,V,V2")
function Core:GetGenericTypesFromClassName(className)
  local sections = { strsplit("<", className) };
  self:Assert(#sections > 1, "%s is a non-generic type.", className);

  local genericTypes = sections[2];

  -- remove ">" from comma-separated string list of generic types
  genericTypes = genericTypes:sub(1, (genericTypes:find(">")) - 1);

  -- turn genericTypes into an array
  genericTypes = { strsplit(',', genericTypes) };

  -- string.trim each type
  for id, genericType in ipairs(genericTypes) do
    genericTypes[id] = genericType:gsub("%s+", "");
  end

  return genericTypes;
end

local function FillTable(tbl, otherTbl)
  for key, value in pairs(otherTbl) do

    if (Framework:IsTable(tbl[key]) and Framework:IsTable(value)) then
      FillTable(tbl[key], value);

    elseif (Framework:IsTable(value)) then
      tbl[key] = Framework:PopTable();
      FillTable(tbl[key], value);
    else
      tbl[key] = value;
    end
  end
end

do
  local function TransformDefinitions(definitions, genericTypes, realTypes)
    for funcKey, funcDefinition in pairs(definitions) do
      local transformed = false;

      -- iterate through parameter and return value definitions:
      for i = 1, 2 do
        local paramOrReturnTable;

        if (i == 1) then
          paramOrReturnTable = funcDefinition.paramDefs;
        else
          paramOrReturnTable = funcDefinition.returnDefs;
        end

        if (Framework:IsTable(paramOrReturnTable)) then
          for defId, definition in ipairs(paramOrReturnTable) do
            for id, genericType in ipairs(genericTypes) do

              if (definition:match(genericType)) then

                if (not transformed) then
                  -- make a deep copy of the class controller definition table for the instance to use:
                  local funcDefinitionCopy = Framework:PopTable();
                  FillTable(funcDefinitionCopy, funcDefinition);

                  definitions[funcKey] = funcDefinitionCopy;
                  funcDefinition = funcDefinitionCopy;

                  if (i == 1) then
                    paramOrReturnTable = funcDefinition.paramDefs;
                  else
                    paramOrReturnTable = funcDefinition.returnDefs;
                  end

                  transformed = true;
                end

                -- transform here:
                paramOrReturnTable[defId] = definition:gsub(genericType, realTypes[id]);
              end
            end
          end
        end
      end
    end
  end

  function Core:ApplyGenericTypesToInstance(definitions, classController)
    local realTypes = classController.tempRealGenericTypes;
    local genericTypes = classController.genericTypes;

    if (not realTypes) then
      -- Of() was not used, so treat generic types as "any"
      realTypes = Framework:PopTable();

      for i = 1, #genericTypes do
        realTypes[i] = "any";
      end
    end

    -- change instance name to use real types
    local className = classController.objectName;
    local redefinedInstanceName = (select(1, strsplit("<", className))).."<";

    for id, realType in ipairs(realTypes) do
      if (id < #realTypes) then
        redefinedInstanceName = string.format("%s%s, ", redefinedInstanceName, realType);
      else
        redefinedInstanceName = string.format("%s%s>", redefinedInstanceName, realType);
      end
    end

    TransformDefinitions(definitions, genericTypes, realTypes);

    Framework:PushTable(classController.tempRealGenericTypes);
    classController.tempRealGenericTypes = nil;

    return redefinedInstanceName;
  end
end

-- Attempt to add definitions for new function Index (params and returns)
---@param controller table @An instance or class controller
---@param newFuncKey number|string @The new key being indexed into Class (pointing to a function value)
---@param fromInterface boolean @True if the function definition originates from an interface
function Core:AttachFunctionDefinition(controller, newFuncKey, fromInterface)
  if (not controller.packageData or controller.objectName == "Package") then
    return;
  end

  -- temporary definition info (received from DefineParams and DefineReturns function calls)
  local tempParamDefs = controller.packageData.tempParamDefs;
  local tempReturnDefs = controller.packageData.tempReturnDefs;
  local tempAttributes = controller.packageData.tempAttributes;
  local isVirtual = controller.packageData.isVirtual;

  -- holds definition for the new function
  local funcDefinition;

  if (tempParamDefs and #tempParamDefs > 0) then
    funcDefinition = Framework:PopTable();
    funcDefinition.paramDefs = Core:CopyTableValues(tempParamDefs, nil, true);
    Framework:PushTable(tempParamDefs);
  end

  if (tempReturnDefs and #tempReturnDefs > 0) then
    funcDefinition = funcDefinition or Framework:PopTable();
    funcDefinition.returnDefs = Core:CopyTableValues(tempReturnDefs, nil, true);
    Framework:PushTable(tempReturnDefs);
  end

  if (tempAttributes and #tempAttributes > 0) then
    funcDefinition = funcDefinition or Framework:PopTable();
    funcDefinition.attributes = tempAttributes;
  end

  -- remove temporary definitions once implemented
  controller.packageData.tempParamDefs = nil;
  controller.packageData.tempReturnDefs = nil;
  controller.packageData.isVirtual = nil;
  controller.packageData.tempAttributes = nil;

  if (fromInterface) then
    controller.interfaceDefinitions = controller.interfaceDefinitions or Framework:PopTable();

    self:Assert(not controller.definitions[newFuncKey],
      "%s found multiple definitions for interface function '%s'.", controller.objectName, newFuncKey);

    controller.interfaceDefinitions[newFuncKey] = funcDefinition;
  else
    self:Assert(not controller.definitions[newFuncKey],
      "%s cannot redefine function '%s'.", controller.objectName, newFuncKey);

    if (Framework:IsTable(controller.interfaceDefinitions)) then

      if (controller.interfaceDefinitions[newFuncKey]) then
        self:Assert(not funcDefinition, "%s cannot redefine interface function '%s'.", controller.objectName, newFuncKey);

        -- copy over interface definition
        funcDefinition = controller.interfaceDefinitions[newFuncKey];
        controller.interfaceDefinitions[newFuncKey] = nil;
      end
    end

    if (Framework:IsTable(funcDefinition)) then
      -- might be an interface function with no definition (prevent adding boolean 'true')
      controller.definitions[newFuncKey] = funcDefinition;

      if (isVirtual) then
        controller.virtualFunctions = controller.virtualFunctions or Framework:PopTable();
        controller.virtualFunctions[newFuncKey] = true;
      end
    end
  end
end

function Core:SetInterfaces(classController, ...)
  for id, interface in Framework:IterateArgs(...) do

    if (Framework:IsString(interface)) then
      local interfaceName = interface;
      interface = Framework:Import(interfaceName, true);

      if (not interface) then
        -- append full package name:
        interfaceName = string.format("%s.%s", classController.packageData.fullPackageName, interfaceName);
        interface = Framework:Import(interfaceName);
      end
    end

    local interfaceController = self:GetController(interface);

    self:Assert(interfaceController and interfaceController.isInterface,
    "Core.SetInterfaces: bad argument #%d (invalid interface)", id);

    if (Framework:IsTable(interfaceController.definition)) then
      -- Copy interface definition into class
      for key, definition in pairs(interfaceController.definition) do
        if (Framework:IsString(definition)) then
          if (definition == Framework.Types.Function) then
            -- a function with no defined params nor return types
              classController.interfaceDefinitions = classController.interfaceDefinitions or Framework:PopTable();
              classController.interfaceDefinitions[key] = true;
            else
              classController.propertyDefinitions = classController.propertyDefinitions or Framework:PopTable();
              classController.propertyDefinitions[key] = definition;
            end

          elseif (Framework:IsTable(definition) and definition.type == Framework.Types.Function) then
            if (Framework:IsTable(definition.params)) then
              classController.package:DefineParams(unpack(definition.params));
            end

            if (Framework:IsTable(definition.returns)) then
              classController.package:DefineReturns(unpack(definition.returns));
            end

            self:AttachFunctionDefinition(classController, key, true);
          end
        end
      end

    -- Add interface to class only after definition has been copied to class (else it will think
    -- that we are trying to redefine an interface definition and will error).
    classController.interfaces = classController.interfaces or Framework:PopTable();
    table.insert(classController.interfaces, interface);
  end
end

do
  local invalidClassValueErrorMessage = "Class '%s' does not implement interface function '%s'.";

  function Core:InheritFunctions(instanceController, classController)
    if (classController.parentProxyClass) then
      local parentClassController = self:GetController(classController.parentProxyClass);
      self:InheritFunctions(instanceController, parentClassController);
    end

    -- check that class implements interface functions:
    for funcKey, _ in pairs(classController.definitions) do
      if (not (string.match(funcKey, "Private.") or string.match(funcKey, "Static."))) then
        local implementedFunc = classController.class[funcKey];
        Core:Assert(Framework:IsFunction(implementedFunc), invalidClassValueErrorMessage, classController.objectName, funcKey);
      end
    end

    for funcKey, implementedFunc in pairs(classController.class) do
      if (funcKey ~= "Private" and funcKey ~= "Static") then
        Core:Assert(Framework:IsFunction(implementedFunc), invalidClassValueErrorMessage, classController.objectName, funcKey);

        if (Framework:IsFunction(implementedFunc)) then
          local funcDefinition = classController.definitions[funcKey];

          -- copy function references with definitions
          instanceController.instance[funcKey] = implementedFunc;
          instanceController.definitions[funcKey] = funcDefinition;
        end
      end
    end
  end
end

---Helper function to copy key/value pairs from copiedTable to receiverTable
function Core:CopyTableValues(copiedTable, receiverTable, shallowCopy)
  receiverTable = receiverTable or Framework:PopTable();

  for key, value in pairs(copiedTable) do
    if (Framework:IsTable(value) and not shallowCopy) then
      receiverTable[key] = self:CopyTableValues(value);
    else
      receiverTable[key] = value;
    end
  end

  return receiverTable;
end

function Core:IsStringNilOrWhiteSpace(strValue)
  if (strValue) then
    Core:Assert(Framework:IsString(strValue),
      "Core.IsStringNilOrWhiteSpace - bad argument #1 (string expected, got %s)", type(strValue));
    strValue = strValue:gsub("%s+", "");

    if (#strValue > 0) then
      return false;
    end
  end

  return true;
end

function Core:SetParentClass(classController, parentProxyClass)
  if (parentProxyClass) then

    if (Framework:IsString(parentProxyClass) and not self:IsStringNilOrWhiteSpace(parentProxyClass)) then
      classController.parentProxyClass = Framework:Import(parentProxyClass, true);

      if (not classController.parentProxyClass) then
        -- append full package name:
        parentProxyClass = string.format("%s.%s", classController.packageData.fullPackageName, parentProxyClass);
        classController.parentProxyClass = Framework:Import(parentProxyClass);
      end

    elseif (Framework:IsTable(parentProxyClass) and parentProxyClass.Static) then
      classController.parentProxyClass = parentProxyClass;
    end

    self:Assert(classController.parentProxyClass, "Core.SetParentClass - bad argument #2 (invalid parent class).");
  else
    classController.parentProxyClass = Framework:Import("Framework.System.Object", true);

    if (classController.proxy == classController.parentProxyClass) then
      -- cannot be parented to itself (i.e. Object class has no parent)
      classController.parentProxyClass = nil;
      return;
    end
  end
end

function Core:PathExists(root, path)
  self:Assert(root, "Core.PathExists - bad argument #1 (invalid root).");

  for _, key in Framework:IterateArgs(strsplit(".", path)) do
    if (not root[key]) then
      return false;
    end

    root = root[key];
  end

  return true;
end

---@param proxyEntity table @Proxy instance or proxyClass but can also be an Interface
function Core:GetController(proxyEntity, silent)
  local mt = getmetatable(proxyEntity);

  setmetatable(proxyEntity, nil);
  local controller = AllControllers[tostring(proxyEntity)];
  setmetatable(proxyEntity, mt);

  if (controller) then
    return controller;
  end

  if (not silent) then
    self:Error("Core.GetController - bad argument #1 (invalid entity).");
  end
end

function Core:GetPrivateInstanceData(instance, instanceController)
  instanceController = instanceController or self:GetController(instance);
  local data = instanceController.privateData;

  self:Assert(Framework:IsTable(data) and not data.GetObjectType,
    "Invalid instance private data for entity %s.", instanceController.objectName);

  return data;
end

do
  local MESSAGE_PATTERN = "bad property value '%s.##' (%s expected, got %s)";

  function Core:ValidateImplementedInterfaceProperty(propertyName, propertyDefinition, realValue, className)
    local errorFound;

    if (propertyDefinition:find("^?")) then
      -- it's optional:
      propertyDefinition = propertyDefinition:sub(2, #propertyDefinition);
      errorFound = (realValue ~= nil) and (propertyDefinition ~= "any" and not self:IsMatchingType(realValue, propertyDefinition));
    else
      errorFound = (realValue == nil) or (propertyDefinition ~= "any" and not self:IsMatchingType(realValue, propertyDefinition));
    end

    local valueType = self:GetValueType(realValue);
    local errorMessage = string.format(MESSAGE_PATTERN, className, propertyDefinition, valueType);

    errorMessage = errorMessage:gsub("##", propertyName);
    self:Assert(not errorFound, errorMessage);
  end
end

---Call this after using the constructor to make sure properties have been implemented
function Core:ValidateImplementedInterfaces(instance, classController)
  if (Framework:IsTable(classController.interfaceDefinitions)) then
    for funcName, _ in pairs(classController.interfaceDefinitions) do
      -- iterate over interface definitions just to throw a single error each time
      self:Assert(classController.interfaceDefinitions == nil,
        "%s is missing an implementation for interface function '%s'.", classController.objectName, funcName);
    end

    classController.interfaceDefinitions = nil; -- no longer needed
  end

  if (not Framework:IsTable(classController.propertyDefinitions)) then
    return;
  end

  for propertyName, propertyDefinition in pairs(classController.propertyDefinitions) do
    local realValue = instance[propertyName];
    self:ValidateImplementedInterfaceProperty(propertyName, propertyDefinition, realValue, classController.objectName);
  end
end

function Core:ValidateValue(definitionType, realType, defaultValue)
  local errorFound;

  self:Assert(Framework:IsString(definitionType) and not self:IsStringNilOrWhiteSpace(definitionType),
    "Invalid definition found; expected a string containing the expected type of an argument or return value.");

  if (definitionType:find("^?") or definitionType:find("?$") or defaultValue ~= nil) then
    -- it's optional so allow nil values
    if (definitionType:find("^?") or definitionType:find("?$")) then
      -- remove "?" from front or back of string
      definitionType = definitionType:gsub("?", "");
    end

    errorFound = (realType ~= nil) and (definitionType ~= "any" and not self:IsMatchingType(realType, definitionType));
  else
    -- it is NOT optional so it cannot be nil
    errorFound = (realType == nil) or (definitionType ~= "any" and not self:IsMatchingType(realType, definitionType));
  end

  return errorFound;
end

local function CastSimpleDefault(definitionType, defaultValue)
  if (defaultValue == nil) then return end
  definitionType = string.gsub(definitionType, "?", "");
  definitionType = string.gsub(definitionType, "%s", "");

  if (definitionType:lower() == "number" and Framework:IsString(defaultValue)) then
    defaultValue = string.gsub(defaultValue, "%s", ""); -- remove spaces
    defaultValue = tonumber(defaultValue);
  end

  if (definitionType:lower() == "boolean" and Framework:IsString(defaultValue)) then
    defaultValue = string.gsub(defaultValue, "%s", ""); -- remove spaces

    if (defaultValue:lower() == "true") then
      defaultValue = true;
    else
      defaultValue = false;
    end
  end

  return defaultValue;
end

function Core:ValidateFunctionCall(definition, errorMessage, ...)
  local values = Framework:PopTable(...);

  if (not definition) then
    return values;
  end

  local id = 1;
  local realValue = (select(1, ...));
  local definitionType;
  local errorFound;
  local defaultValue;
  local defaultValues = Framework:PopTable();
  local vararg, varargStartIndex;

  repeat
    definitionType = definition[id] or vararg;

    if (Framework:IsTable(definitionType)) then
      -- ordering matters!:
      defaultValue = definitionType[2];
      definitionType = definitionType[1];
    end

    if (definitionType:find("%.%.%.")) then
      vararg = definitionType:gsub("%.%.%.", "");
      definitionType = vararg;
      varargStartIndex = id;
    end

    if (definitionType:find("|")) then
      for _, singleDefinitionType in Framework:IterateArgs(strsplit("|", definitionType)) do
        singleDefinitionType = string.gsub(singleDefinitionType, "%s", "");
        errorFound = self:ValidateValue(singleDefinitionType, realValue, defaultValue);

        if (not errorFound) then
          break;
        end
      end

      if (errorFound) then
        definitionType = string.gsub(definitionType, "|", " or ");
      end
    else
      if (definitionType:find("=")) then
        definitionType, defaultValue = strsplit("=", definitionType);
      end

      errorFound = self:ValidateValue(definitionType, realValue, defaultValue);
    end

    if (errorFound) then
      if (Framework:IsFunction(realValue) or (Framework:IsTable(realValue) and not Framework:IsObject(realValue))) then
        errorMessage = string.format("%s (%s expected, got %s)",
        errorMessage, definitionType, self:GetValueType(realValue));
      else
        errorMessage = string.format("%s (%s expected, got %s (value: %s))",
        errorMessage, definitionType, self:GetValueType(realValue), tostring(realValue));
      end

      errorMessage = errorMessage:gsub("##", "#" .. tostring(id));
      self:Error(errorMessage);
      return;
    end

    defaultValues[id] = CastSimpleDefault(definitionType, defaultValue);

    id = id + 1;
    realValue = (select(id, ...));

  until ((not vararg and definition[id] == nil) or (vararg and id > select("#", ...)));

  -- we don't care about values with no definitions
  local length = #definition;

  -- calculate real length (cut off trailing nil values from vararg)
  if (vararg) then
    length = varargStartIndex - 1;

    for i = varargStartIndex, (select("#", ...)) do
      if (values[i] ~= nil) then
        length = i;
      end
    end
  end

  -- Swap out nil values with their default values:
  for i = 1, length do
    if (values[i] == nil) then
      values[i] = defaultValues[i];
    end
  end

  Framework:PushTable(defaultValues);

  return values;
end

do
  local paramErrorMessage = "bad argument ## to '%s.%s'";
  local returnErrorMessage = "bad return value ## to '%s.%s'";

  local function GetDefinitions(proxyObject, errorMessagePattern, definitionKey)
    local funcDef = proxyObject.controller.definitions[proxyObject.key];

    if (not funcDef) then
      return;
    end

    local definitions = funcDef and funcDef[definitionKey];

    if (not definitions) then return end

    local errorMessage = errorMessagePattern and string.format(
      errorMessagePattern, proxyObject.controller.objectName, proxyObject.key);
    return definitions, errorMessage;
  end

  function Core:GetParamsDefinition(proxyObject)
    return GetDefinitions(proxyObject, paramErrorMessage, "paramDefs");
  end

  function Core:GetReturnsDefinition(proxyObject)
    return GetDefinitions(proxyObject, returnErrorMessage, "returnDefs");
  end

  function Core:GetAttributes(proxyObject)
    return GetDefinitions(proxyObject, returnErrorMessage, "attributes");
  end
end

function Core:Assert(condition, errorMessage, ...)
  if (not condition) then
    if (errorMessage) then
      local size = select("#", ...);

      if (size > 0) then
        local args = Framework:PopTable(...);

        for i = 1, size do
          if (args[i] == nil) then
            args[i] = Framework.Types.Nil;

          elseif (not Framework:IsString(args[i])) then
            args[i] = tostring(args[i]);
          end
        end

        errorMessage = string.format(errorMessage, Framework:UnpackTable(args));

      elseif (string.match(errorMessage, "%s")) then
        errorMessage = string.format(errorMessage, Framework.Types.Nil);
      end

    else
      errorMessage = "condition failed";
    end

    errorMessage = self.PREFIX .. errorMessage;

    if (self.silent) then
      self.errorLog = self.errorLog or Framework:PopTable();
      self.errorLog[#self.errorLog + 1] = select(2, pcall(function() error(errorMessage) end));

    elseif (Framework:IsFunction(self.errorHandler)) then
      -- local level = _G.DEBUGLOCALS_LEVEL;
      local stack = _G.debugstack(3);
      local locals = _G.debuglocals(3);
      self.errorHandler(errorMessage, stack, locals);
    else
      error(errorMessage);
    end
  end
end

function Core:Print(...)
  if (self.DebugMode) then
    _G.DEFAULT_CHAT_FRAME:AddMessage(string.join("", self.PREFIX, _G.tostringall(...)));
  end
end

function Core:PrintUsage()
  if (self.DebugMode) then
    _G.UpdateAddOnMemoryUsage();
    self:Print("Usage: ", _G.GetAddOnMemoryUsage(addOnName));
  end
end

function Core:Error(errorMessage, ...)
  self:Assert(false, errorMessage, ...);
end

function Core:IsMatchingType(value, expectedTypeName)
  -- check if basic type
  for _, typeName in pairs(Framework.Types) do
    if (expectedTypeName == typeName) then
      return (expectedTypeName == type(value));
    end
  end

  if (not Framework:IsTable(value)) then
    return false;
  end

  local controller = self:GetController(value, true);

  if (not controller) then
    if (value.IsObjectType and value:IsObjectType(expectedTypeName)) then
      return true;
    end

    return false;
  end

  while (value and controller) do

    if (expectedTypeName == controller.objectName) then
      return true; -- Object or Widget matches!
    end

    if (Framework:IsTable(controller.interfaces)) then
      -- check all interface types
      for _, interface in ipairs(controller.interfaces) do
        local interfaceController = self:GetController(interface);

        if (expectedTypeName == interfaceController.objectName) then
          return true; -- interface name matches!
        end
      end
    end

    value = controller.parentProxyClass;

    if (Framework:IsTable(value)) then
      controller = self:GetController(value, true); -- fail silently
    end
  end

  return false;
end

function Core:GetValueType(value)
  if (value == nil) then
    return Framework.Types.Nil;
  end

  local valueType = type(value);

  if (valueType ~= Framework.Types.Table) then
    return valueType;
  elseif (value.GetObjectType) then
    return value:GetObjectType();
  end

  return Framework.Types.Table;
end

---------------------------------
-- Package Class
---------------------------------

Package = Core:CreateClass(nil, nil, "Package");

function Package:__Construct(data, packageName, namespace)
  data.packageName = packageName;

  if (data.namespace) then
    data.fullPackageName = string.format("%s.%s", namespace, packageName);
  else
    data.fullPackageName = packageName;
  end

  data.entities = Framework:PopTable();
end

function Package:GetName(data)
  return data.packageName;
end

---@param subPackage Package
function Package:AddSubPackage(data, subPackage)
  local subPackageName = subPackage:GetName();
  local subPackageData = Core:GetPrivateInstanceData(subPackage);

  Core:Assert(not data.entities[subPackageName],
    "Package.AddSubPackage - bad argument #1 ('%s' package already exists inside this package).", subPackageName);

  data.entities[subPackageName] = subPackage;
  subPackageData.parentPackage = self;
  subPackageData.fullPackageName = string.format("%s.%s", data.fullPackageName, subPackageData.packageName);
end

function Package:GetParentPackage(data)
    return data.parentPackage;
end

---@param entityName string the name of the entity to retrieve from the package
---@param silent boolean if the entity cannot be found, do not throw an error if true
function Package:Get(data, entityName, silent)
  Core:Assert(silent or data.entities[entityName],
    "Entity '%s' does not exist in package '%s'.", entityName, data.fullPackageName);
  return data.entities[entityName];
end

---@param className string the name of the class to create for this package
---@param parentClass Object a parent class to inherit from
---@param ... Object|string a variable argument list of optional interface entities
---(or interface names to be imported as entities) the newly created class should implement
---returns a new class that is a subclass of the Object class
function Package:CreateClass(data, className, parentClass, ...)
  Core:Assert(not data.entities[className],
    "Class '%s' already exists in this package.", className);

  local class = Core:CreateClass(self, data, className, parentClass, ...);
  self[className] = class;

  return class;
end

---@param interfaceName string the name of the interface to create for this package
---@param interfaceDefinition table a table containing property and/or function names
---with type definitions for property values, function parameters and return types.
---returns a new interface
function Package:CreateInterface(data, interfaceName, interfaceDefinition)
  Core:Assert(Framework:IsString(interfaceName), "bad argument #1 to Package.CreateInterface (string expected, got %s)", type(interfaceName));
  Core:Assert(Framework:IsTable(interfaceDefinition), "bad argument #2 to Package.CreateInterface (table expected, got %s)", type(interfaceDefinition));
  Core:Assert(not data.entities[interfaceName], "Entity '%s' already exists in this package.", interfaceName);

  local interface = Core:CreateInterface(data, interfaceName, interfaceDefinition);
  data.entities[interfaceName] = interface;
  self[interfaceName] = interface;

  return interface;
end

local function ValidateDefinition(...)
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
      Core:Error("Invalid definition - bad argument #1 (string expected, got %s).", type(def));
      Framework:PushTable(defs);
      return
    end

    if (def:find("=") and def:find("|")) then
      Core:Error("Invalid definition (cannot use default values for union types).");
      Framework:PushTable(defs);
      return
    end

    if (vararg) then
      Core:Error("Invalid definition (cannot specify another definition after variable list definition: `...`).");
      Framework:PushTable(defs);
      return
    elseif (def:find("%.%.%.")) then
      vararg = true;
    end
  end

  return defs;
end

---temporarily store param definitions to be applied to next new indexed function
function Package:DefineParams(data, ...)
  data.tempParamDefs = ValidateDefinition(...);
end

---temporarily store return definitions to be applied to next new indexed function
function Package:DefineReturns(data, ...)
  data.tempReturnDefs = ValidateDefinition(...);
end

---Define the next class function as virtual
function Package:DefineVirtual(data)
  data.isVirtual = true;
end

function Package:SetAttribute(data, attributeClass, ...)
  if (Framework:IsString(attributeClass)) then
    attributeClass = Framework:Import(attributeClass);
  end

  local attribute = attributeClass(...);

  if (Framework:IsTable(data.tempAttributes)) then
    table.insert(data.tempAttributes, attribute);
  else
    data.tempAttributes = Framework:PopTable(attribute);
  end
end

---prevents other functions being added or modified
function Package:ProtectClass(_, class)
  local classController = Core:GetController(class);

  Core:Assert(classController and classController.isClass, "Package.ProtectClass - bad argument #1 (class not found).");
  classController.isProtected = true;
end

function Package:ProtectProperty(_, instance, propertyName)
  local instanceController = Core:GetController(instance);
  instanceController.protectedProperties = instanceController.protectedProperties or Framework:PopTable();
  instanceController.protectedProperties[propertyName] = true;
end

---@return string the name of the package type
function Package:GetObjectType()
  return "Package";
end

---@param objectName string the name of the Object
---@return boolean returns true if the Object's type is a package
function Package:IsObjectType(_, objectName)
  return "package" == string.lower(objectName);
end

---@return number the number of entities inside the package
function Package:Size(data)
  local size = 0;

  for _, _ in pairs(data.entities) do
    size = size + 1;
  end

  return size;
end

local FrameworkPackage = Package("Framework");
local SystemPackage = Package("System");
FrameworkPackage:AddSubPackage(SystemPackage);

Core.ExportedPackages.Framework = FrameworkPackage;

---------------------------------------------
-- Object Class
---------------------------------------------
---@class Object
local Object = SystemPackage:CreateClass("Object");

---@return boolean gets the name of the object type
function Object:GetObjectType()
	return Core:GetController(self).objectName;
end

---@param objectName string the name of an Object's type
---@return boolean returns true if objectName matches the name of the Object's type
function Object:IsObjectType(_, objectName)
  local controller = Core:GetController(self);

  if (controller.objectName == objectName) then
    return true;
  end

  if (controller.interfaces) then
    -- check if any interfaces being implemented is of type objectName
    for _, interface in ipairs(controller.interfaces) do
      local interfaceController = Core:GetController(interface);

      if (interfaceController.objectName == objectName) then
        return true;
      end
    end
  end

  if (controller.parentProxyClass) then
    -- check if any parent class is of type objectName
    controller = Core:GetController(controller.parentProxyClass);

    while (controller) do
      if (controller.objectName == objectName) then
        return true;
      end

      controller = Core:GetController(controller.parentProxyClass);
    end
  end

  return false;
end

function Object:Equals(data, other)
  if (not Framework:IsTable(other) or not other.GetObjectType) then
    return false;
  end

  if (other:GetObjectType() == self:GetObjectType()) then
    local otherData = Core:GetPrivateInstanceData(other);

    for key, _ in pairs(data) do
      if (data[key] ~= otherData[key]) then
        return false;
      end
    end
  end

  return true;
end

---Call parent constructor
function Object:Super(data, ...)
  local controller = Core:GetController(self);

  if (controller.UsingParentConstructor) then
    controller = Core:GetController(controller.UsingParentConstructor);
  end

  controller.UsingParentConstructor = controller.parentProxyClass;
  local parentController = Core:GetController(controller.parentProxyClass);

  if (parentController.class.__Construct) then
    parentController.class.__Construct(self, data, ...);
    controller.UsingParentConstructor = nil;
  end
end

---@return Object the parent class
function Object:GetParentClass()
	return Core:GetController(self).parentProxyClass;
end

---@return Package the package the object belongs to
function Object:GetPackage()
	return Core:GetController(self).package;
end

---@return Class the class the Object is built from
function Object:GetClass()
	return getmetatable(self).class;
end

---@return Object a clone of the Object instance
function Object:Clone()
  local instanceController = Core:GetController(self);
  instanceController.classController.cloneFrom = self;

  -- Executes Class __call metamethod
  local instance = instanceController.classController.proxy();

  if (not self:Equals(instance)) then
    Core:Error("Clone data corrupted.");
  end

  return instance;
end

---Destroy's the instance, erasing all private data in the process
function Object:Destroy()
  if (self.__Destruct) then
    self:__Destruct();
  end

  local instanceController = Core:GetController(self);
  setmetatable(self, nil);

  -- remove reference to instance controller
  local instanceKey = tostring(self);
  AllControllers[instanceKey] = nil;

  -- destroy real instance
  Framework:PushTable(instanceController.instance);
  instanceController.instance = nil;

  -- destroy instance private data
  Framework:PushTable(instanceController.privateData);
  instanceController.privateData = nil;

  -- destroy instance controller
  Framework:PushTable(instanceController);

  -- destroy proxy instance
  Framework:EmptyTable(self);
  self.IsDestroyed = true;
end

function Object:SetName(_, name)
  local instanceController = Core:GetController(self);
  instanceController.name = name;
end

function Object:GetName()
  local instanceController = Core:GetController(self);
  return instanceController.name;
end