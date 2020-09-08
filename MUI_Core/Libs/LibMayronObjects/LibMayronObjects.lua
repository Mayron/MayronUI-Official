-- luacheck: ignore self 143 631
local addOnName = ...;

---@type LibMayronObjects
local Lib = _G.LibStub:NewLibrary("LibMayronObjects", 3.01);

if (not Lib) then
    return;
end

local _G = _G;
local error, unpack = _G.error, _G.unpack;
local type, setmetatable, table, string = _G.type, _G.setmetatable, _G.table, _G.string;
local getmetatable, select, pcall = _G.getmetatable, _G.select, _G.pcall;

Lib.Types = {};
Lib.Types.Table    = "table";
Lib.Types.Number   = "number";
Lib.Types.Function = "function";
Lib.Types.Boolean  = "boolean";
Lib.Types.String   = "string";
Lib.Types.Nil      = "nil";

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

local Core = {}; -- holds all private Lib core functions for internal use
Core.Lib = Lib;
Core.PREFIX = "|cffffcc00LibMayronObjects: |r"; -- this is used when printing out errors
Core.ExportedPackages = {}; -- contains all exported packages
Core.DebugMode = false;

--[[
-- need a reference for this to hack around the manual exporting process
-- (exporting the package class but it's already a package...)
--]]

---@class Package
local Package;

-------------------------------------
-- Helper functions
-------------------------------------
function Lib:IsTable(value)
    return type(value) == Lib.Types.Table;
end

function Lib:IsNumber(value)
    return type(value) == Lib.Types.Number;
end

function Lib:IsFunction(value)
    return type(value) == Lib.Types.Function;
end

function Lib:IsBoolean(value)
    return type(value) == Lib.Types.Boolean;
end

function Lib:IsString(value)
    return type(value) == Lib.Types.String;
end

function Lib:IsNil(value)
    return type(value) == Lib.Types.Nil;
end

function Lib:IsObject(value)
    if (not Lib:IsTable(value)) then
        return false;
    end

    return (Core:GetController(value, true) ~= nil);
end

function Lib:IsWidget(value)
    if (not Lib:IsTable(value)) then
        return false;
    end

    local isObject = (Core:GetController(value, true) ~= nil);

    if (isObject) then
        return false;
    end

    return (value.GetObjectType ~= nil and value.GetName ~= nil);
end

function Lib:IsStringNilOrWhiteSpace(value)
    return Core:IsStringNilOrWhiteSpace(value);
end

-- Helper function to check if value is a specified type
-- @param value: The value to check the type of (can be nil)
-- @param expectedTypeName: The exact type to check for (can be ObjectType)
-- @return (boolean): Returns true if the value type matches the specified type
function Lib:IsType(value, expectedTypeName)
    return Core:IsMatchingType(value, expectedTypeName);
end

do
    local wrappers = {};
    local pendingClean;

    local function CleanWrappers()
        Lib:EmptyTable(wrappers);
        pendingClean = nil;
        _G.collectgarbage("collect");
    end

    local function iterator(wrapper, id)
        id = id + 1;

        local arg = wrapper[id];

        if (arg ~= nil) then
            return id, arg;
        else
            -- reached end of wrapper so finish looping and clean up
            Lib:PushTable(wrapper);
        end
    end

    local function PushTable(wrapper)
        if (not wrappers[tostring(wrapper)]) then
            wrappers[#wrappers + 1] = wrapper;
            wrappers[tostring(wrapper)] = true;
        end

        if (#wrappers >= 10 and not pendingClean) then
            pendingClean = true;
            _G.C_Timer.After(10, CleanWrappers);
        end
    end

    ---@return table @An empty table
    function Lib:PopTable(...)
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
    function Lib:PushTable(wrapper, pushSubTables, path)
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
    function Lib:UnpackTable(wrapper, doNotPushTable)
        if (not self:IsTable(wrapper)) then
            return;
        end

        local length = 1;

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

    function Lib:IterateArgs(...)
        local wrapper = self:PopTable(...);
        return iterator, wrapper, 0;
    end
end

--------------------------------------------
-- LibMayronObjects Functions
--------------------------------------------
---@param packageName string @The name of the package.
---@param namespace string @The parent package namespace. Example: "Framework.System.package".
---@return Package @Returns a package object.
function Lib:CreatePackage(packageName, namespace)
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
function Lib:Import(namespace, silent)
    local entity;
    local currentNamespace = "";
    local nodes = Lib:PopTable(_G.strsplit(".", namespace));

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

    Lib:PushTable(nodes);

    if (not silent) then
        local controller = Core:GetController(entity, true);

        Core:Assert(controller or entity.IsObjectType and entity:IsObjectType("Package"),
            "Import - bad argument #1 (invalid namespace '%s').", namespace);

        Core:Assert(entity ~= Core.ExportedPackages, "Import - bad argument #1 ('%s' package not found).", namespace);
    end

    return entity;
end

---@param namespace string @The package namespace (required for locating and importing it).
---@param package Package @A package instance object.
function Lib:Export(package, namespace)
    local classController = Core:GetController(package);
    local parentPackage;

    Core:Assert(classController and classController.IsPackage, "Export - bad argument #1 (package expected)");
    Core:Assert(not Core:IsStringNilOrWhiteSpace(namespace), "Export - bad argument #2 (invalid namespace)")

    for id, key in self:IterateArgs(_G.strsplit(".", namespace)) do
        Core:Assert(not Core:IsStringNilOrWhiteSpace(key), "Export - bad argument #2 (invalid namespace).");
        key = key:gsub("%s+", "");

        if (id > 1) then
            if (not parentPackage:Get(key)) then
                -- auto-create empty packages if not found in namespace
                parentPackage:AddSubPackage(Lib:CreatePackage(key));
            end

            parentPackage = parentPackage:Get(key);
        else
            -- auto-create empty packages if not found in namespace
            Core.ExportedPackages[key] = Core.ExportedPackages[key] or Lib:CreatePackage(key);
            parentPackage = Core.ExportedPackages[key];
        end
    end

    -- add package to the last (parent) package specified in the namespace
    parentPackage:AddSubPackage(package, namespace);
end

---@param silent boolean @True if errors should be cause in the error log instead of triggering.
function Lib:SetSilentErrors(silent)
    Core.silent = silent;
end

---@return table @Contains index/string pairs of errors caught while in silent mode.
function Lib:GetErrorLog()
    Core.errorLog = Core.errorLog or {};
    return Core.errorLog;
end

---Empties the error log table.
function Lib:FlushErrorLog()
    if (Core.errorLog) then
        Lib:EmptyTable(Core.errorLog);
    end
end

if (not _G.try) then
    local catchObj = {};

    catchObj.catch = function(func)

        if (not catchObj.ran) then
            func(catchObj.errorMessage);
        end

        catchObj.ran = true;
        catchObj.errorMessage = nil;
    end

    _G.try = function(func)
        Lib:SetSilentErrors(true);
        catchObj.ran = true;
        catchObj.errorMessage = nil;

        local initialNumErrors = Lib:GetNumErrors();
        local ran, errorMessage = pcall(func);

        if (not ran) then
            Core:Error(errorMessage);
        end

        if (initialNumErrors < Lib:GetNumErrors()) then
            catchObj.ran = false;
            local log = Lib:GetErrorLog();
            catchObj.errorMessage = log[#log];
        end

        return catchObj;
    end
end

---@return number @The total number of errors caught while in silent mode.
function Lib:GetNumErrors()
    return (Core.errorLog and #Core.errorLog) or 0;
end

---Proxy function to allow outside users to use Core:Assert()
---@param condition boolean @A predicate to evaluate.
---@param errorMessage string @An error message to throw if condition is evaluated to false.
---@vararg any @A list of arguments to be inserted into the error message using string.format.
function Lib:Assert(condition, errorMessage, ...)
    Core:Assert(condition, errorMessage, ...);
end

---Proxy function to allow outside users to use Core:Error()
---@param errorMessage string @The error message to throw.
---@vararg any @A list of arguments to be inserted into the error message using string.format.
function Lib:Error(errorMessage, ...)
    Core:Error(errorMessage, ...);
end

---Attach an error handling function to call when an error occurs to be handled manually.
---@param errorHandler function @The error handler callback function.
function Lib:SetErrorHandler(errorHandler)
    Core.errorHandler = errorHandler;
end

---A helper function to empty a table.
---@param tbl table @The table to empty.
function Lib:EmptyTable(tbl)
    for key, _ in pairs(tbl) do
        tbl[key] = nil;
    end
end

---A helper function to print a table's contents.
---@param tbl table @The table to print.
---@param depth number @The depth of sub-tables to traverse through and print.
---@param n number @Do NOT manually set this. This controls formatting through recursion.
function Lib:PrintTable(tbl, depth, n)
    n = n or 0;
    depth = depth or 5;

    if (depth == 0) then
        print(string.rep(' ', n).."...");
        return;
    end

    if (n == 0) then
        print(" ");
    end

    for key, value in pairs(tbl) do
        if (key and self:IsNumber(key) or self:IsString(key)) then
            key = string.format("[\"%s\"]", key);

            if (self:IsTable(value)) then
                if (next(value)) then
                    print(string.rep(' ', n)..key.." = {");
                    self:PrintTable(value, depth - 1, n + 4);
                    print(string.rep(' ', n).."},");
                else
                    print(string.rep(' ', n)..key.." = {},");
                end
            else
                if (self:IsString(value)) then
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

---Do NOT use this unless you are a LibMayronObjects developer.
---@param debug boolean @Set the Library to debug mode.
function Lib:SetDebugMode(debug)
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
        return Lib:PopTable();
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

        if (not proxyObject.privateData) then
            if (proxyObject.controller.isInterface) then
                Core:Error("%s.%s is an interface function and must be implemented and invoked by an instance object.",
                    proxyObject.controller.objectName, proxyObject.key);
            else
                Core:Error("%s.%s is a non-static function and must be invoked by an instance object.",
                    proxyObject.controller.objectName, proxyObject.key);
            end
        end

        definition, errorMessage = Core:GetReturnsDefinition(proxyObject);

        Core:Assert(Lib:IsTable(proxyObject.privateData) and not proxyObject.privateData.GetObjectType,
            "Invalid instance private data found when calling %s.%s: %s",
            proxyObject.controller.objectName, proxyObject.key, tostring(proxyObject.privateData));

        Core:Assert(Lib:IsFunction(proxyObject.object[proxyObject.key]),
            "Could not find function '%s' for object '%s'", proxyObject.key, proxyObject.controller.objectName);

        -- execute attributes:
        local attributes = Core:GetAttributes(proxyObject);

        if (Lib:IsTable(attributes)) then
            for _, attribute in ipairs(attributes) do
                if (not attribute:OnExecute(proxyObject.self, proxyObject.privateData, proxyObject.key, Lib:UnpackTable(args, true))) then
                    Lib:PushTable(args);
                    return nil; -- if attribute returns false, do no move onto the next attribute and do not call function
                end
            end
        end

        -- Validate return values received after calling the function
        local returnValues = Core:ValidateFunctionCall(definition, errorMessage,
                -- call function here:
                proxyObject.object[proxyObject.key](proxyObject.self, proxyObject.privateData, Lib:UnpackTable(args)));

        if (proxyObject.key ~= "Destroy") then
            local instanceController = Core:GetController(proxyObject.self, true);

            if (instanceController and Lib:IsTable(instanceController.UsingParentControllers)) then
                -- might have been destroyed during the function call
                Lib:PushTable(instanceController.UsingParentControllers);
                instanceController.UsingParentControllers = nil;
            end
        end

        ProxyStack:Push(proxyObject);

        if (#returnValues == 0) then
            Lib:PushTable(returnValues);
            return nil; -- fixes returning nil instead of nothing
        end

        return Lib:UnpackTable(returnValues);
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

        if (Lib:IsFunction(value)) then
            -- get a proxy function object to validate function params and return values
            value = CreateProxyObject(class, key, self, classController);

        elseif (value == nil) then
            -- no real value stored in Class
            if (classController.parentProxyClass) then
                -- search parent class instead
                value = classController.parentProxyClass[key];

                if (Lib:IsFunction(value)) then
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

        if (classController.UsingChild and Lib:IsFunction(value)) then
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

        if (key == "Static") then
            -- not allowed to override "Static" Class property!
            Core:Error("%s.Static property is protected.", classController.objectName);
            return;
        end

        if (classController.isProtected) then
            Core:Error("%s is protected.", classController.objectName);
        end

        if (Lib:IsFunction(value)) then
            -- Adds temporary definition info to ClassController.definitions table
            Core:AttachFunctionDefinition(classController, key);
        end

        classController.class[key] = value;
    end

    proxyClassMT.__tostring = function(self)
        setmetatable(self, nil);

        local classController = AllControllers[tostring(self)];
        local str = tostring(self):gsub(Lib.Types.Table, string.format("<Class> %s", classController.objectName));

        setmetatable(self, proxyClassMT);

        return str;
    end

    function Core:CreateClass(package, packageData, className, parentProxyClass, ...)
        local class            = Lib:PopTable(); -- stores real table indexes (once proxy has completed evaluating data)
        local proxyClass       = Lib:PopTable(); -- enforces __newindex meta-method to always be called (new indexes, if valid, are added to Class instead)
        local definitions      = Lib:PopTable(); -- function definitions for params and return values
        local friends          = Lib:PopTable(); -- friend classes can access instance private data of this class
        local classController  = Lib:PopTable(); -- holds special Lib data to control class

        classController.isClass = true;
        classController.objectName = className;
        classController.proxy = proxyClass;
        classController.definitions = definitions;
        classController.class = class;

        -- protected table for assigning Static functions
        proxyClass.Static = Lib:PopTable();

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

            proxyClass.Static.AddFriendClass = function(_, friendClassName)
                friends[friendClassName] = true;
            end

            proxyClass.Static.IsFriendClass = function(_, friendClassName)
                if (friendClassName == className) then
                    return true;
                end

                return friends[friendClassName];
            end

            proxyClass.Static.OnIndexChanged = function(_, callback)
                classController.indexChangedCallback = callback;
            end

            proxyClass.Static.OnIndexChanging = function(_, callback)
                classController.indexChangingCallback = callback;
            end

            proxyClass.Static.OnIndexed = function(_, callback)
                classController.indexedCallback = callback;
            end

            proxyClass.Static.OnIndexing = function(_, callback)
                classController.indexingCallback = callback;
            end

            proxyClass.Of = function(_, ...)
                Core:Assert(classController.isGenericType, "%s is not a generic class", className);
                classController.tempRealGenericTypes = Lib:PopTable();

                for id, realType in Lib:IterateArgs(...) do
                    if (Lib:IsObject(realType)) then
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

        if (not (Lib:IsTable(frame) and frame.GetObjectType)) then
            -- might be a property we are searching for, so do not throw an error!
            return nil;
        end

        if (frame[key]) then
            -- if the frame has the key we are trying to get...

            if (Lib:IsFunction(frame[key])) then
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
                instanceController.UsingParentControllers = Lib:PopTable(parentController);
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

            if (Lib:IsFunction(value)) then
                value = CreateProxyObject(instanceController.instance, key, self, instanceController);

                local proxyObject = GetStoredProxyObject(value);
                proxyObject.privateData = privateData; -- set PrivateData to be injected into function call

                if (proxyObject.key == GetFrame and key ~= GetFrame) then
                    value = GetFrameWrapperFunction(value, key);
                end
            end
        end

        -- check if class has key
        if (value == nil) then
            value = classController.proxy[key];

            if (Lib:IsFunction(value)) then
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
        if (instanceController.isConstructed and Lib:IsTable(classController.propertyDefinitions)) then
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
        local str = tostring(self):gsub(Lib.Types.Table, string.format("<Instance> %s", className));

        setmetatable(self, proxyInstanceMT);

        return str;
    end

    function Core:CreateInstance(classController, ...)
        local instance              = Lib:PopTable(); -- stores real table indexes (once proxy has completed evaluating data)
        local instanceController    = Lib:PopTable(); -- holds special Lib data to control instance
        local privateData           = Lib:PopTable(); -- private instance data passed to function calls (the 2nd argument)
        local proxyInstance         = Lib:PopTable(); -- enforces __newindex meta-method to always be called (new indexes, if valid, are added to Instance instead)
        local definitions           = Lib:PopTable();

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
        local instanceControllerMT = Lib:PopTable();
        instanceControllerMT.__index = classController;

        setmetatable(instanceController, instanceControllerMT);

        privateData.GetFriendData = function(_, friendInstance)
            local friendClassName = friendInstance:GetObjectType();
            local friendClass = classController.packageData.entities[friendClassName]; -- must be in same package!

            Lib:Assert(friendClass and friendClass.Static:IsFriendClass(classController.objectName),
                "'%s' is not a friend class of '%s'", friendClassName, classController.objectName);

            return self:GetPrivateInstanceData(friendInstance);
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
            if (classController.class.__Construct) then
                -- call custom constructor here!
                proxyInstance:__Construct(...);
            end

            if (Lib:IsTable(classController.interfaces)) then
                Core:ValidateImplementedInterfaces(instance, classController);
            end
        end

        instanceController.isConstructed = true;
        return proxyInstance;
    end
end

function Core:CreateInterface(packageData, interfaceName, interfaceDefinition)
    local interface                  = Lib:PopTable();
    local interfaceController        = Lib:PopTable();

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
    local sections = { _G.strsplit("<", className) };
    self:Assert(#sections > 1, "%s is a non-generic type.", className);

    local genericTypes = sections[2];

    -- remove ">" from comma-separated string list of generic types
    genericTypes = genericTypes:sub(1, (genericTypes:find(">")) - 1);

    -- turn genericTypes into an array
    genericTypes = { _G.strsplit(',', genericTypes) };

    -- string.trim each type
    for id, genericType in ipairs(genericTypes) do
        genericTypes[id] = genericType:gsub("%s+", "");
    end

    return genericTypes;
end

local function FillTable(tbl, otherTbl)
    for key, value in pairs(otherTbl) do

        if (Lib:IsTable(tbl[key]) and Lib:IsTable(value)) then
            FillTable(tbl[key], value);

        elseif (Lib:IsTable(value)) then
            tbl[key] = Lib:PopTable();
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

                if (Lib:IsTable(paramOrReturnTable)) then
                    for defId, definition in ipairs(paramOrReturnTable) do
                        for id, genericType in ipairs(genericTypes) do

                            if (definition:match(genericType)) then

                                if (not transformed) then
                                    -- make a deep copy of the class controller definition table for the instance to use:
                                    local funcDefinitionCopy = Lib:PopTable();
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
            realTypes = Lib:PopTable();

            for i = 1, #genericTypes do
                realTypes[i] = "any";
            end
        end

        -- change instance name to use real types
        local className = classController.objectName;
        local redefinedInstanceName = (select(1, _G.strsplit("<", className))).."<";

        for id, realType in ipairs(realTypes) do
            if (id < #realTypes) then
                redefinedInstanceName = string.format("%s%s, ", redefinedInstanceName, realType);
            else
                redefinedInstanceName = string.format("%s%s>", redefinedInstanceName, realType);
            end
        end

        TransformDefinitions(definitions, genericTypes, realTypes);

        Lib:PushTable(classController.tempRealGenericTypes);
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
        funcDefinition = Lib:PopTable();
        funcDefinition.paramDefs = Core:CopyTableValues(tempParamDefs, nil, true);
        Lib:PushTable(tempParamDefs);
    end

    if (tempReturnDefs and #tempReturnDefs > 0) then
        funcDefinition = funcDefinition or Lib:PopTable();
        funcDefinition.returnDefs = Core:CopyTableValues(tempReturnDefs, nil, true);
        Lib:PushTable(tempReturnDefs);
    end

    if (tempAttributes and #tempAttributes > 0) then
        funcDefinition = funcDefinition or Lib:PopTable();
        funcDefinition.attributes = tempAttributes;
    end

    -- remove temporary definitions once implemented
    controller.packageData.tempParamDefs = nil;
    controller.packageData.tempReturnDefs = nil;
    controller.packageData.isVirtual = nil;
    controller.packageData.tempAttributes = nil;

    if (fromInterface) then
        controller.interfaceDefinitions = controller.interfaceDefinitions or Lib:PopTable();

        self:Assert(not controller.definitions[newFuncKey],
            "%s found multiple definitions for interface function '%s'.", controller.objectName, newFuncKey);

        controller.interfaceDefinitions[newFuncKey] = funcDefinition;
    else
        self:Assert(not controller.definitions[newFuncKey],
            "%s cannot redefine function '%s'.", controller.objectName, newFuncKey);

        if (Lib:IsTable(controller.interfaceDefinitions)) then

            if (controller.interfaceDefinitions[newFuncKey]) then
                self:Assert(not funcDefinition, "%s cannot redefine interface function '%s'.", controller.objectName, newFuncKey);

                -- copy over interface definition
                funcDefinition = controller.interfaceDefinitions[newFuncKey];
                controller.interfaceDefinitions[newFuncKey] = nil;
            end
        end

        if (Lib:IsTable(funcDefinition)) then
            -- might be an interface function with no definition (prevent adding boolean 'true')
            controller.definitions[newFuncKey] = funcDefinition;

            if (isVirtual) then
                controller.virtualFunctions = controller.virtualFunctions or Lib:PopTable();
                controller.virtualFunctions[newFuncKey] = true;
            end
        end
    end
end

function Core:SetInterfaces(classController, ...)
    for id, interface in Lib:IterateArgs(...) do

        if (Lib:IsString(interface)) then
            local interfaceName = interface;
            interface = Lib:Import(interfaceName, true);

            if (not interface) then
                -- append full package name:
                interfaceName = string.format("%s.%s", classController.packageData.fullPackageName, interfaceName);
                interface = Lib:Import(interfaceName);
            end
        end

        local interfaceController = self:GetController(interface);

        self:Assert(interfaceController and interfaceController.isInterface,
            "Core.SetInterfaces: bad argument #%d (invalid interface)", id);

        if (Lib:IsTable(interfaceController.definition)) then
            -- Copy interface definition into class
            for key, definition in pairs(interfaceController.definition) do
                if (Lib:IsString(definition)) then
                    if (definition == Lib.Types.Function) then
                        -- a function with no defined params nor return types
                        classController.interfaceDefinitions = classController.interfaceDefinitions or Lib:PopTable();
                        classController.interfaceDefinitions[key] = true;
                    else
                        classController.propertyDefinitions = classController.propertyDefinitions or Lib:PopTable();
                        classController.propertyDefinitions[key] = definition;
                    end

                elseif (Lib:IsTable(definition) and definition.type == Lib.Types.Function) then
                    if (Lib:IsTable(definition.params)) then
                        classController.package:DefineParams(unpack(definition.params));
                    end

                    if (Lib:IsTable(definition.returns)) then
                        classController.package:DefineReturns(unpack(definition.returns));
                    end

                    self:AttachFunctionDefinition(classController, key, true);
                end
            end
        end

        -- Add interface to class only after definition has been copied to class (else it will think
        -- that we are trying to redefine an interface definition and will error).
        classController.interfaces = classController.interfaces or Lib:PopTable();
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
            local implementedFunc = classController.class[funcKey];
            Core:Assert(Lib:IsFunction(implementedFunc), invalidClassValueErrorMessage, classController.objectName, funcKey);
        end

        for funcKey, implementedFunc in pairs(classController.class) do
            Core:Assert(Lib:IsFunction(implementedFunc), invalidClassValueErrorMessage, classController.objectName, funcKey);

            if (Lib:IsFunction(implementedFunc)) then
                local funcDefinition = classController.definitions[funcKey];

                -- copy function references with definitions
                instanceController.instance[funcKey] = implementedFunc;
                instanceController.definitions[funcKey] = funcDefinition;
            end
        end
    end
end

---Helper function to copy key/value pairs from copiedTable to receiverTable
function Core:CopyTableValues(copiedTable, receiverTable, shallowCopy)
    receiverTable = receiverTable or Lib:PopTable();

    for key, value in pairs(copiedTable) do
        if (Lib:IsTable(value) and not shallowCopy) then
            receiverTable[key] = self:CopyTableValues(value);
        else
            receiverTable[key] = value;
        end
    end

    return receiverTable;
end

function Core:IsStringNilOrWhiteSpace(strValue)
    if (strValue) then
        Core:Assert(Lib:IsString(strValue), "Core.IsStringNilOrWhiteSpace - bad argument #1 (string expected, got %s)", type(strValue));
        strValue = strValue:gsub("%s+", "");

        if (#strValue > 0) then
            return false;
        end
    end

    return true;
end

function Core:SetParentClass(classController, parentProxyClass)
    if (parentProxyClass) then

		if (Lib:IsString(parentProxyClass) and not self:IsStringNilOrWhiteSpace(parentProxyClass)) then
            classController.parentProxyClass = Lib:Import(parentProxyClass, true);

            if (not classController.parentProxyClass) then
                -- append full package name:
                parentProxyClass = string.format("%s.%s", classController.packageData.fullPackageName, parentProxyClass);
                classController.parentProxyClass = Lib:Import(parentProxyClass);
            end

		elseif (Lib:IsTable(parentProxyClass) and parentProxyClass.Static) then
            classController.parentProxyClass = parentProxyClass;
		end

        self:Assert(classController.parentProxyClass, "Core.SetParentClass - bad argument #2 (invalid parent class).");
	else
        classController.parentProxyClass = Lib:Import("Framework.System.Object", true);

        if (classController.proxy == classController.parentProxyClass) then
            -- cannot be parented to itself (i.e. Object class has no parent)
            classController.parentProxyClass = nil;
            return;
        end
    end
end

function Core:PathExists(root, path)
    self:Assert(root, "Core.PathExists - bad argument #1 (invalid root).");

    for _, key in Lib:IterateArgs(_G.strsplit(".", path)) do
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

    self:Assert(Lib:IsTable(data) and not data.GetObjectType,
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
    if (Lib:IsTable(classController.interfaceDefinitions)) then
        for funcName, _ in pairs(classController.interfaceDefinitions) do
            -- iterate over interface definitions just to throw a single error each time
            self:Assert(classController.interfaceDefinitions == nil,
                "%s is missing an implementation for interface function '%s'.", classController.objectName, funcName);
        end

        classController.interfaceDefinitions = nil; -- no longer needed
    end

    if (not Lib:IsTable(classController.propertyDefinitions)) then
        return;
    end

    for propertyName, propertyDefinition in pairs(classController.propertyDefinitions) do
        local realValue = instance[propertyName];
        self:ValidateImplementedInterfaceProperty(propertyName, propertyDefinition, realValue, classController.objectName);
    end
end

function Core:ValidateValue(definitionType, realType, defaultValue)
    local errorFound;

    self:Assert(Lib:IsString(definitionType) and not self:IsStringNilOrWhiteSpace(definitionType),
        "Invalid definition found; expected a string containing the expected type of an argument or return value.");

    if (definitionType:find("^?") or defaultValue ~= nil) then
        -- it's optional so allow null values
        if (definitionType:find("^?")) then
            -- remove "?" from front of string
            definitionType = definitionType:sub(2, #definitionType);
        end

        errorFound = (realType ~= nil) and (definitionType ~= "any" and not self:IsMatchingType(realType, definitionType));
    else
        -- it is NOT optional so it cannot be nil
        errorFound = (realType == nil) or (definitionType ~= "any" and not self:IsMatchingType(realType, definitionType));
    end

    return errorFound;
end

function Core:ValidateFunctionCall(definition, errorMessage, ...)
    local values = Lib:PopTable(...);

    if (not definition) then
        return values;
    end

    local id = 1;
    local realValue = (select(1, ...));
    local definitionType;
    local errorFound;
    local defaultValue;
    local defaultValues = Lib:PopTable();

    repeat
        definitionType = definition[id];

        if (Lib:IsTable(definitionType)) then
            defaultValue = definitionType[2];
            definitionType = definitionType[1];
        end

        if (definitionType:find("|")) then
            for _, singleDefinitionType in Lib:IterateArgs(_G.strsplit("|", definitionType)) do
                singleDefinitionType = string.gsub(singleDefinitionType, "%s", "");
                errorFound = self:ValidateValue(singleDefinitionType, realValue);

                if (not errorFound) then
                    break;
                end
            end

            if (errorFound) then
                definitionType = string.gsub(definitionType, "|", " or ");
            end
        else
            if (definitionType:find("=")) then
                definitionType, defaultValue = _G.strsplit("=", definitionType);
            end

            errorFound = self:ValidateValue(definitionType, realValue, defaultValue);
        end

        if (errorFound) then
            if (Lib:IsFunction(realValue) or (Lib:IsTable(realValue) and not Lib:IsObject(realValue))) then
                errorMessage = string.format("%s (%s expected, got %s)",
                    errorMessage, definitionType, self:GetValueType(realValue));
            else
                errorMessage = string.format("%s (%s expected, got %s (value: %s))",
                    errorMessage, definitionType, self:GetValueType(realValue), tostring(realValue));
            end

            errorMessage = errorMessage:gsub("##", "#" .. tostring(id));
            self:Error(errorMessage);
        end

        definitionType = string.gsub(definitionType, "%s", "");

        if (definitionType:lower() == "number" and Lib:IsString(defaultValue)) then
            defaultValue = string.gsub(defaultValue, "%s", "");
            defaultValue = tonumber(defaultValue);
        end

        if (definitionType:lower() == "boolean" and Lib:IsString(defaultValue)) then
            defaultValue = string.gsub(defaultValue, "%s", "");

            if (defaultValue:lower() == "true") then
                defaultValue = true;
            else
                defaultValue = false;
            end
        end

        defaultValues[id] = defaultValue;

        id = id + 1;
        realValue = (select(id, ...));

    until (not definition[id]);

    for i = 1, #definition do
        if (values[i] == nil) then
            values[i] = defaultValues[i];
        end
    end

    Lib:PushTable(defaultValues);

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

        if (not definitions) then
            return;
        end

        local errorMessage = errorMessagePattern and string.format(errorMessagePattern, proxyObject.controller.objectName, proxyObject.key);
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
                local args = Lib:PopTable(...);

                for i = 1, size do
                    if (args[i] == nil) then
                        args[i] = Lib.Types.Nil;
                    end
                end

                errorMessage = string.format(errorMessage, Lib:UnpackTable(args));

            elseif (string.match(errorMessage, "%s")) then
                errorMessage = string.format(errorMessage, Lib.Types.Nil);
            end

        else
            errorMessage = "condition failed";
        end

        errorMessage = self.PREFIX .. errorMessage;

        if (self.silent) then
            self.errorLog = self.errorLog or Lib:PopTable();
            self.errorLog[#self.errorLog + 1] = select(2, pcall(function() error(errorMessage) end));

        elseif (Lib:IsFunction(self.errorHandler)) then
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
    for _, typeName in pairs(Lib.Types) do
        if (expectedTypeName == typeName) then
            return (expectedTypeName == type(value));
        end
    end

    if (not Lib:IsTable(value)) then
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

        if (Lib:IsTable(controller.interfaces)) then
            -- check all interface types
            for _, interface in ipairs(controller.interfaces) do
                local interfaceController = self:GetController(interface);

                if (expectedTypeName == interfaceController.objectName) then
                    return true; -- interface name matches!
                end
            end
        end

        value = controller.parentProxyClass;

        if (Lib:IsTable(value)) then
            controller = self:GetController(value, true); -- fail silently
        end
    end

    return false;
end

function Core:GetValueType(value)
    if (value == nil) then
        return Lib.Types.Nil;
    end

    local valueType = type(value);

    if (valueType ~= Lib.Types.Table) then
        return valueType;
    elseif (value.GetObjectType) then
        return value:GetObjectType();
    end

    return Lib.Types.Table;
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

    data.entities = Lib:PopTable();
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
---@return Object the newly created class
function Package:CreateClass(data, className, parentClass, ...)
    --print(className, select("#", ...))
    Core:Assert(not data.entities[className],
        "Class '%s' already exists in this package.", className);

    local class = Core:CreateClass(self, data, className, parentClass, ...);
    self[className] = class;

    return class;
end

---@param interfaceName string the name of the interface to create for this package
---@param interfaceDefinition table a table containing property and/or function names
---with type definitions for property values, function parameters and return types.
---@return Object the newly created interface
function Package:CreateInterface(data, interfaceName, interfaceDefinition)
    Core:Assert(Lib:IsString(interfaceName), "bad argument #1 to Package.CreateInterface (string expected, got %s)", type(interfaceName));
    Core:Assert(Lib:IsTable(interfaceDefinition), "bad argument #2 to Package.CreateInterface (table expected, got %s)", type(interfaceDefinition));
    Core:Assert(not data.entities[interfaceName], "Entity '%s' already exists in this package.", interfaceName);

    local interface = Core:CreateInterface(data, interfaceName, interfaceDefinition);
    data.entities[interfaceName] = interface;
    self[interfaceName] = interface;

    return interface;
end

---temporarily store param definitions to be applied to next new indexed function
function Package:DefineParams(data, ...)
    data.tempParamDefs = Lib:PopTable(...);
end

---temporarily store return definitions to be applied to next new indexed function
function Package:DefineReturns(data, ...)
    data.tempReturnDefs = Lib:PopTable(...);
end

---Define the next class function as virtual
function Package:DefineVirtual(data)
    data.isVirtual = true;
end

function Package:SetAttribute(data, attributeClass, ...)
    if (Lib:IsString(attributeClass)) then
        attributeClass = Lib:Import(attributeClass);
    end

    local attribute = attributeClass(...);

    if (Lib:IsTable(data.tempAttributes)) then
        table.insert(data.tempAttributes, attribute);
    else
        data.tempAttributes = Lib:PopTable(attribute);
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
    instanceController.protectedProperties = instanceController.protectedProperties or Lib:PopTable();
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
	if (not Lib:IsTable(other) or not other.GetObjectType) then
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
    Lib:PushTable(instanceController.instance);
    instanceController.instance = nil;

    -- destroy instance private data
    Lib:PushTable(instanceController.privateData);
    instanceController.privateData = nil;

    -- destroy instance controller
    Lib:PushTable(instanceController);

    -- destroy proxy instance
    Lib:EmptyTable(self);
    self.IsDestroyed = true;
end