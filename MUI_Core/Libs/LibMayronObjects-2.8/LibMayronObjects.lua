-- luacheck: ignore self 143 631
local addOnName = ...;
local Lib = _G.LibStub:NewLibrary("LibMayronObjects", 2.8);

if (not Lib) then
    return;
end

local error, unpack = error, _G.unpack;
local type, setmetatable, table, string = type, setmetatable, table, string;
local getmetatable, select = getmetatable, select;

local tableType = "table";
local numberType = "number";
local functionType = "function";
local booleanType = "boolean";
local stringType = "string";
local nilType = "nil";

function Lib:IsTable(value)
    return type(value) == tableType;
end

function Lib:IsNumber(value)
    return type(value) == numberType;
end

function Lib:IsFunction(value)
    return type(value) == functionType;
end

function Lib:IsBoolean(value)
    return type(value) == booleanType;
end

function Lib:IsString(value)
    return type(value) == stringType;
end

function Lib:IsNil(value)
    return type(value) == nilType;
end

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
local Package;

-------------------------------------
-- Helper functions
-------------------------------------
do
    local wrappers = {};
    local cleanTimerActive = false;
    local delay = false;

    local function CleanWrappers()
        if (delay) then
            delay = false;
            _G.C_Timer.After(10, CleanWrappers);
            return;
        end

        Lib:EmptyTable(wrappers);
        _G.collectgarbage("collect");
    end

    local function iterator(wrapper, id)
        id = id + 1;

        local arg = wrapper[id];

        if (arg ~= nil) then
            return id, arg;
        else
            -- reached end of wrapper so finish looping and clean up
            Lib:PushWrapper(wrapper);
        end
    end

    local function PushWrapper(wrapper)
        if (not wrappers[tostring(wrapper)]) then
            wrappers[#wrappers + 1] = wrapper;
            wrappers[tostring(wrapper)] = true;
        end

        if (not cleanTimerActive) then
            cleanTimerActive = true;
            _G.C_Timer.After(30, CleanWrappers);
        end
    end

    function Lib:PopWrapper(...)
        local wrapper;
        delay = true;

        -- get wrapper before iterating
        if (#wrappers > 0) then
            wrapper = wrappers[#wrappers];
            wrappers[#wrappers] = nil;
            wrappers[tostring(wrapper)] = nil;

            -- empty table (incase tk.Tables:UnpackWrapper was used)
            for key, _ in pairs(wrapper) do
                wrapper[key] = nil;
            end
        else
            -- create new wrapper (required if a for-loop call to
            -- IterateArgs is nested inside another IterateArgs call)
            wrapper = {};
        end

        local arg;
        local id = 0;
        local totalConsecutiveNils = 0;

        -- fill wrapper
        repeat
            id = id + 1;
            arg = (select(id, ...));

            if (arg == nil) then
                totalConsecutiveNils = totalConsecutiveNils + 1;
            else
                wrapper[id] = arg; -- add only non-nil values
                totalConsecutiveNils = 0;
            end

        -- repeat until we are comfortable that all arguments have been captured.
        -- should not have a function call containing more than 10 consecutive nil args!
        until (totalConsecutiveNils > 10);

        return wrapper;
    end

    function Lib:PushWrapper(wrapper, pushSubTables)
        if (not self:IsTable(wrapper)) then
            return;
        end

        local push = true;

        for key, _ in pairs(wrapper) do
            if (pushSubTables and self:IsTable(wrapper[key])) then

                if (self:IsFunction(pushSubTables)) then
                    push = pushSubTables(wrapper[key]);
                end

                if (push) then
                    self:PushWrapper(wrapper[key], pushSubTables);
                end
            end

            wrapper[key] = nil;
        end

        if (push) then
            setmetatable(wrapper, nil);
            PushWrapper(wrapper);
        end
    end

    function Lib:UnpackWrapper(wrapper)
        if (not self:IsTable(wrapper)) then return end
        PushWrapper(wrapper);
        return _G.unpack(wrapper);
    end

    function Lib:IterateArgs(...)
        local wrapper = self:PopWrapper(...);
        return iterator, wrapper, 0;
    end

    function Lib:LengthOfArgs(...)
        local length = 0;

        for _, _ in self:IterateArgs(...) do
            length = length + 1;
        end

        return length;
    end
end

--------------------------------------------
-- LibMayronObjects Functions
--------------------------------------------
-- @param packageName (string) - the name of the package.
-- @param namespace (string) - the parent package namespace. Example: "Framework.System.package".
-- @return package (Package) - returns a package object.
function Lib:CreatePackage(packageName, namespace)
    local newPackage = Package(packageName);

    Core:Assert(newPackage ~= nil, "Failed to create new Package '%s'", packageName);

    -- export the package only if a namespace is supplied
    if (not Core:IsStringNilOrWhiteSpace(namespace)) then
        self:Export(newPackage, namespace);
    end

    return newPackage;
end

-- @param namespace (string) - the entity namespace (required for locating it).
--      (an entity = a package, class or interface).
-- @param silent (boolean) - if true, no error will be triggered if the entity cannot be found.
-- @return entity (Package, or class/interface) - returns the found entity (or false if silent).
function Lib:Import(namespace, silent)
    local entity;
    local currentNamespace = "";
    local nodes = Lib:PopWrapper(_G.strsplit(".", namespace));

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

    Lib:PushWrapper(nodes);

    if (not silent) then
        local controller = Core:GetController(entity, true);

        Core:Assert(controller or entity.IsObjectType and entity:IsObjectType("Package"),
            "Import - bad argument #1 (invalid namespace '%s').", namespace);

        Core:Assert(entity ~= Core.ExportedPackages, "Import - bad argument #1 ('%s' package not found).", namespace);
    end

    return entity;
end

-- @param package (Package) - a package instance object.
-- @param namespace (string) - the package namespace (required for locating and importing it).
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
    parentPackage:AddSubPackage(package);
end

-- @param silent (boolean) - true if errors should be cause in the error log instead of triggering.
function Lib:SetSilentErrors(silent)
    Core.silent = silent;
end

-- @return errorLog (table) - contains index/string pairs of errors caught while in silent mode.
function Lib:GetErrorLog()
    Core.errorLog = Core.errorLog or {};
    return Core.errorLog;
end

-- empties the error log table.
function Lib:FlushErrorLog()
    if (Core.errorLog) then
        Lib:EmptyTable(Core.errorLog);
    end
end

-- @return numErrors (number) - the total number of errors caught while in silent mode.
function Lib:GetNumErrors()
    return (Core.errorLog and #Core.errorLog) or 0;
end

-- Proxy function to allow outside users to use Core:Assert()
function Lib:Assert(condition, errorMessage, ...)
    Core:Assert(condition, errorMessage, ...);
end

-- Proxy function to allow outside users to use Core:Error()
function Lib:Error(errorMessage, ...)
    Core:Error(errorMessage, ...);
end

function Lib:SetErrorHandler(errorHandler)
    Core.errorHandler = errorHandler;
end

-- Helper function to check if value is a specified type
-- @param value: The value to check the type of (can be nil)
-- @param expectedTypeName: The exact type to check for (can be ObjectType)
-- @return (boolean): Returns true if the value type matches the specified type
function Lib:IsType(value, expectedTypeName)
    return Core:IsMatchingType(value, expectedTypeName);
end

function Lib:EmptyTable(tbl)
    for key, _ in pairs(tbl) do
        tbl[key] = nil;
    end
end

function Lib:PrintTable(tbl, depth, n)
    n = n or 0;
    depth = depth or 4;

    if (depth == 0) then
        return
    end

    if (n == 0) then
        print(" ");
    end

    for key, value in pairs(tbl) do
        if (key and self:IsNumber(key) or self:IsString(key)) then
            key = string.format("[\"%s\"]", key);

            if (self:IsTable(value)) then
                print(string.rep(' ', n)..key.." = {");
                self:PrintTable(value, depth - 1, n + 4);
                print(string.rep(' ', n).."},");
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
        return Lib:PopWrapper();
    end

    local proxyObject = self[#self];
    self[#self] = nil;

    return proxyObject;
end

-- intercepts function calls on classes and instance objects and returns a proxy function used for validation.
-- @param object (table) - a table containing all functions assigned to a class or interface.
-- @param key (string) - the function name/key being called.
-- @param entity (table) - the instance or class object originally being called with the function name/key.
-- @param controller (table) - the entities meta-data (stores validation rules and more).
-- @return proxyFunc (function) - the proxy function is returned and called instead of the real function.
local function CreateProxyObject(object, key, entity, controller)
    local proxyObject = ProxyStack:Pop();

    proxyObject.object = object;
    proxyObject.key = key;
    proxyObject.controller = controller;
    proxyObject.self = entity;

    -- we need multiple Run functions in case 1 function calls another (Run is never removed after being assigned)
    proxyObject.run = proxyObject.run or function(_, ...)
        -- Validate parameters passed to function
        local definition, errorMessage = Core:GetParamsDefinition(proxyObject);
        Core:ValidateFunctionCall(definition, errorMessage, ...);

        if (not proxyObject.privateData) then
            if (proxyObject.controller.isInterface) then
                Core:Error("%s.%s is an interface function and must be implemented and invoked by an instance object.",
                    proxyObject.controller.objectName, proxyObject.key);
            else
                Core:Error("%s.%s is a non static function and must be invoked by an instance object.",
                    proxyObject.controller.objectName, proxyObject.key);
            end
        end

        definition, errorMessage = Core:GetReturnsDefinition(proxyObject);

        Core:Assert(Lib:IsTable(proxyObject.privateData) and not proxyObject.privateData.GetObjectType,
            "Invalid instance private data found when calling %s.%s: %s",
            proxyObject.controller.objectName, proxyObject.key, tostring(proxyObject.privateData));

        -- Validate return values received after calling the function
        local returnValues = Lib:PopWrapper(
            Core:ValidateFunctionCall(definition, errorMessage,
                proxyObject.object[proxyObject.key](proxyObject.self, proxyObject.privateData, ...)
            )
        );

        if (proxyObject.key ~= "Destroy") then
            local classController = Core:GetController(proxyObject.self, true);

            if (classController) then
                -- might have been destroyed during the function call
                classController.UsingChild = nil;
            end
        end

        ProxyStack:Push(proxyObject);

        if (#returnValues == 0) then
            Lib:PushWrapper(returnValues);
            return nil; -- fixes returning nil instead of nothing
        end

        return Lib:UnpackWrapper(returnValues);
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
        local className = classController.objectName;
        local class = classController.class;

        Core:Assert(not classController.indexing,
            "'%s' attempted to re-index itself during the same index request with key '%s'.", className, key);

        -- start indexing process (used to detect if an index loop has occured in error)
        classController.indexing = true;

        local value = class[key]; -- get the real value

        if (Lib:IsFunction(value)) then
            -- get a proxy function object to validate function params and return values
            value = CreateProxyObject(class, key, self, classController);

        elseif (value == nil) then
            -- no real value stored in Class
            if (classController.parentClass) then
                -- search parent class instead
                value = classController.parentClass[key];

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
            -- if Object:Parent() was used, call parent function with the child as the reference
            local child = classController.UsingChild;
            local childController = Core:GetController(child);
            local proxyObject = GetStoredProxyObject(value);

            proxyObject.privateData = Core:GetPrivateInstanceData(child, childController);
        end

        -- end indexing process (used to detect if an index loop has occured in error)
        classController.indexing = nil;

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
        local str = tostring(self):gsub(tableType, string.format("<Class> %s", classController.objectName));

        setmetatable(self, proxyClassMT);

        return str;
    end

    function Core:CreateClass(package, packageData, className, parentClass, ...)
        local class            = Lib:PopWrapper(); -- stores real table indexes (once proxy has completed evaluating data)
        local proxyClass       = Lib:PopWrapper(); -- enforces __newindex meta-method to always be called (new indexes, if valid, are added to Class instead)
        local definitions      = Lib:PopWrapper(); -- function definitions for params and return values
        local friends          = Lib:PopWrapper(); -- friend classes can access instance private data of this class
        local classController  = Lib:PopWrapper(); -- holds special Lib data to control class

        classController.isClass = true;
        classController.objectName = className;
        classController.proxy = proxyClass;
        classController.definitions = definitions;
        classController.class = class;

        -- protected table for assigning Static functions
        proxyClass.Static = Lib:PopWrapper();

        if (package and packageData) then
            -- link new class to package
            classController.package = package; -- only used for GetPackage()
            classController.packageData = packageData;
            packageData.entities[className] = proxyClass;

            if (className:match("<") and className:match(">")) then
                classController.isGenericType = true;
                classController.genericTypes = self:GetGenericTypesFromClassName(className);
            end

            self:SetParentClass(classController, parentClass);
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
                classController.tempRealGenericTypes = Lib:PopWrapper(...); -- holds real type names

                for id, realType in ipairs(classController.tempRealGenericTypes) do
                    -- remove spaces
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
    local missingFrameErrorMessage = "attempt to index %s.%s (a nil value) and no data.frame property was found.";
    local GetFrame = "GetFrame";

    local function GetFrameWrapperFunction(classController, value, key)
        -- ProxyClass changed key to GetFrame during __index meta-method call
        local frame = value(); -- call the proxyObject.Run function here to get the frame

        Core:Assert(Lib:IsTable(frame) and frame.GetObjectType, missingFrameErrorMessage, classController.objectName, key);

        if (frame[key]) then
            -- if the frame has the key we are trying to get...

            if (Lib:IsFunction(frame[key])) then
                value = function(_, ...)
                    -- call the frame (a blizzard widget) here
                    return frame[key](frame, ...);
                end
            else
                value = frame[key];
            end
        else
            value = nil; -- no frame found
        end

        return value;
    end

    proxyInstanceMT.__index = function(self, key)
        local instanceController = Core:GetController(self);
        local classController = instanceController.classController;
        local privateData = instanceController.privateData;
        local value;

        if (classController.indexingCallback) then
            value = classController.indexingCallback(self, privateData, key);
        end

        -- check if instance property
        if (value == nil and instanceController.instance[key] ~= nil) then
            value = instanceController.instance[key];

            if (Lib:IsFunction(value)) then
                value = CreateProxyObject(instanceController.instance, key, self, instanceController);
                local proxyObject = GetStoredProxyObject(value);
                proxyObject.privateData = privateData; -- set PrivateData to be injected into function call

                if (proxyObject.key == GetFrame and key ~= GetFrame) then
                    value = GetFrameWrapperFunction(classController, value, key)
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
                    value = GetFrameWrapperFunction(classController, value, key)
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
        local classController = instanceController.classController;
        local instance = instanceController.instance;

        Core:Assert(not classController.class[key],
            "Cannot override class-level property '%s.%s' from an instance.", classController.objectName, key);

        if (classController.indexChangingCallback) then
            local preventIndexing = classController.indexChangingCallback(self, instanceController.privateData, key, value);

            if (preventIndexing) then
                -- do not continue indexing
                return;
            end
        end

        instance[key] = value;

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
        local str = tostring(self):gsub(tableType, string.format("<Instance> %s", className));

        setmetatable(self, proxyInstanceMT);

        return str;
    end

    function Core:CreateInstance(classController, ...)
        local instance              = Lib:PopWrapper(); -- stores real table indexes (once proxy has completed evaluating data)
        local instanceController    = Lib:PopWrapper(); -- holds special Lib data to control instance
        local privateData           = Lib:PopWrapper(); -- private instance data passed to function calls (the 2nd argument)
        local proxyInstance         = Lib:PopWrapper(); -- enforces __newindex meta-method to always be called (new indexes, if valid, are added to Instance instead)
        local definitions           = Lib:PopWrapper();

        instanceController.privateData = privateData;
        instanceController.instance = instance;
        instanceController.classController = classController;
        instanceController.definitions = definitions;

        self:InheritFunctions(instanceController, classController);

        if (classController.isGenericType) then
            -- renames EntiyName for instance controller, and creates "RealGenericTypes" instance controller property
            instanceController.objectName = self:ApplyGenericTypesToInstance(instanceController.definitions, classController);
        end

        -- interfaceController requires knowledge of many classController settings
        local instanceControllerMT = Lib:PopWrapper();
        instanceControllerMT.__index = classController;

        setmetatable(instanceController, instanceControllerMT);

        privateData.GetFriendData = function(_, friendInstance)
            local friendClassName = friendInstance:GetObjectType();
            local friendClass = classController.packageData.entities[friendClassName]; -- must be in same package!

            if (friendClass and friendClass.Static:IsFriendClass(classController.objectName)) then
                return self:GetPrivateInstanceData(friendInstance);
            end
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
    local interface                  = Lib:PopWrapper();
    local interfaceController        = Lib:PopWrapper();

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

function Core:ApplyGenericTypesToInstance(definitions, classController)
    local realTypes = classController.tempRealGenericTypes;
    local genericTypes = classController.genericTypes;

    if (not realTypes) then
        -- Of() was not used, so treat generic types as "any"
        realTypes = Lib:PopWrapper();

        for i = 1, #genericTypes do
            realTypes[i] = "any";
        end
    end

    for _, funcDefinition in pairs(definitions) do

        if (Lib:IsTable(funcDefinition.paramDefs)) then
            for defId, paramDef in ipairs(funcDefinition.paramDefs) do
                for id, genericType in ipairs(genericTypes) do
                    if (paramDef:match(genericType)) then
                        funcDefinition.paramDefs[defId] = paramDef:gsub(genericType, realTypes[id]);
                    end
                end
            end
        end

        if (Lib:IsTable(funcDefinition.returnDefs)) then
            for defId, returnDef in ipairs(funcDefinition.returnDefs) do
                for id, genericType in ipairs(genericTypes) do
                    if (returnDef:match(genericType)) then
                        funcDefinition.returnDefs[defId] = returnDef:gsub(genericType, realTypes[id]);
                    end
                end
            end
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

    Lib:PushWrapper(classController.tempRealGenericTypes);
    classController.tempRealGenericTypes = nil;

    return redefinedInstanceName;
end

-- Attempt to add definitions for new function Index (params and returns)
--@param controller - an instance or class controller
--@param newFuncKey - the new key being indexed into Class (pointing to a function value)
function Core:AttachFunctionDefinition(controller, newFuncKey, fromInterface)
    if (not controller.packageData or controller.objectName == "Package") then
        return;
    end

    -- temporary definition info (received from DefineParams and DefineReturns function calls)
    local tempParamDefs = controller.packageData.tempParamDefs;
    local tempReturnDefs = controller.packageData.tempReturnDefs;

    -- holds definition for the new function
    local funcDefinition;

    if (tempParamDefs and #tempParamDefs > 0) then
        funcDefinition = Lib:PopWrapper();
        funcDefinition.paramDefs = Core:CopyTableValues(tempParamDefs);
        Lib:PushWrapper(tempParamDefs);
    end

    if (tempReturnDefs and #tempReturnDefs > 0) then
        funcDefinition = funcDefinition or Lib:PopWrapper();
        funcDefinition.returnDefs = Core:CopyTableValues(tempReturnDefs);
        Lib:PushWrapper(tempReturnDefs);
    end

    -- remove temporary definitions once implemented
    controller.packageData.tempParamDefs = nil;
    controller.packageData.tempReturnDefs = nil;

    if (fromInterface) then
        controller.interfaceDefinitions = controller.interfaceDefinitions or Lib:PopWrapper();

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
        end
    end
end

function Core:SetInterfaces(classController, ...)
    for id, interface in Lib:IterateArgs(...) do
        if (Lib:IsString(interface)) then
            interface = Lib:Import(interface);
        end

        local interfaceController = self:GetController(interface);

        self:Assert(interfaceController and interfaceController.isInterface,
            "Core.SetInterfaces: bad argument #%d (invalid interface)", id);

        if (Lib:IsTable(interfaceController.definition)) then
            -- Copy interface definition into class
            for key, definition in pairs(interfaceController.definition) do
                if (Lib:IsString(definition)) then
                    if (definition == functionType) then
                        -- a function with no defined params nor return types
                        classController.interfaceDefinitions = classController.interfaceDefinitions or Lib:PopWrapper();
                        classController.interfaceDefinitions[key] = true;
                    else
                        classController.propertyDefinitions = classController.propertyDefinitions or Lib:PopWrapper();
                        classController.propertyDefinitions[key] = definition;
                    end

                elseif (Lib:IsTable(definition) and definition.type == functionType) then
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
        classController.interfaces = classController.interfaces or Lib:PopWrapper();
        table.insert(classController.interfaces, interface);
    end
end

do
    local invalidClassValueErrorMessage = "Class '%s' does not implement interface function '%s'.";

    function Core:InheritFunctions(instanceController, classController)
        if (classController.parentClass) then
            local parentClassController = self:GetController(classController.parentClass);
            self:InheritFunctions(instanceController, parentClassController);
        end

        for funcKey, funcDefinition in pairs(classController.definitions) do
            local implementedFunc = classController.class[funcKey];
            Core:Assert(Lib:IsFunction(implementedFunc), invalidClassValueErrorMessage, classController.objectName, funcKey);

            -- copy function references with definitions
            instanceController.instance[funcKey] = implementedFunc;
            instanceController.definitions[funcKey] = funcDefinition;
        end
    end
end

-- Helper function to copy key/value pairs from copiedTable to receiverTable
function Core:CopyTableValues(copiedTable, receiverTable)
    receiverTable = receiverTable or Lib:PopWrapper();

    for key, value in pairs(copiedTable) do
        if (Lib:IsTable(value)) then
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

function Core:SetParentClass(classController, parentClass)
    if (parentClass) then

		if (Lib:IsString(parentClass) and not self:IsStringNilOrWhiteSpace(parentClass)) then
            classController.parentClass = Lib:Import(parentClass);

		elseif (Lib:IsTable(parentClass) and parentClass.Static) then
            classController.parentClass = parentClass;
		end

        self:Assert(classController.parentClass, "Core.SetParentClass - bad argument #2 (invalid parent class).");
	else
        classController.parentClass = Lib:Import("Framework.System.Object", true);

        if (classController.proxy == classController.parentClass) then
            -- cannot be parented to itself (i.e. Object class has no parent)
            classController.parentClass = nil;
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

-- @param proxyEntity = proxyInstance or proxyClass but can also be an Interface
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

function Core:ValidateImplementedInterfaceProperty(propertyName, propertyDefinition, realValue, className)
    local errorFound;
    local message = string.format("bad property value '%s.##'", className);

    if (propertyDefinition:find("^?")) then
        -- it's optional:
        propertyDefinition = propertyDefinition:sub(2, #propertyDefinition);
        errorFound = (realValue ~= nil) and (propertyDefinition ~= "any" and not self:IsMatchingType(realValue, propertyDefinition));
    else
        errorFound = (realValue == nil) or (propertyDefinition ~= "any" and not self:IsMatchingType(realValue, propertyDefinition));
    end

    local errorMessage = string.format(message .. " (%s expected, got %s)", propertyDefinition, self:GetValueType(realValue));
    errorMessage = errorMessage:gsub("##", propertyName);

    self:Assert(not errorFound, errorMessage);
end

-- Call this after using the constructor to make sure properties have been implemented
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

function Core:ValidateValue(defValue, realValue)
    local errorFound;

    self:Assert(Lib:IsString(defValue) and not self:IsStringNilOrWhiteSpace(defValue),
        "Invalid definition found; expected a string containing the expected type of an argument or return value.");

    if (defValue:find("^?")) then
        -- it's optional so allow null values
        -- remove "?" from front of string
        defValue = defValue:sub(2, #defValue);
        errorFound = (realValue ~= nil) and (defValue ~= "any" and not self:IsMatchingType(realValue, defValue));
    else
        -- it is NOT optional so it cannot be null
        errorFound = (realValue == nil) or (defValue ~= "any" and not self:IsMatchingType(realValue, defValue));
    end

    return errorFound;
end

function Core:ValidateFunctionCall(definition, errorMessage, ...)
    if (not definition) then
        return ...;
    end

    local id = 1;
    local realValue = (select(1, ...));
    local defValue;
    local errorFound;

    repeat
        defValue = definition[id];

        if (defValue:find("|")) then

            for _, singleDefValue in Lib:IterateArgs(_G.strsplit("|", defValue)) do
                singleDefValue = string.gsub(singleDefValue, "%s", "");
                errorFound = self:ValidateValue(singleDefValue, realValue);

                if (not errorFound) then
                    break;
                end
            end

            if (errorFound) then
                defValue = string.gsub(defValue, "%s", "");
                defValue = string.gsub(defValue, "|", " or ");
            end
        else
            errorFound = self:ValidateValue(defValue, realValue);
        end

        if (errorFound) then
            errorMessage = string.format("%s (%s expected, got %s)", errorMessage, defValue, self:GetValueType(realValue));
            errorMessage = errorMessage:gsub("##", "#" .. tostring(id));
            self:Error(errorMessage);
        end

        id = id + 1;
        realValue = (select(id, ...));

    until (not definition[id]);

    return ...;
end

do
    local returnErrorMessage = "bad return value ## to '%s.%s'";
    local paramErrorMessage = "bad argument ## to '%s.%s'";

    function Core:GetParamsDefinition(proxyObject)
        local funcDef = proxyObject.controller.definitions[proxyObject.key];

        if (not funcDef) then
            return;
        end

        local paramDefs = funcDef and funcDef.paramDefs;

        if (not paramDefs) then
            return;
        end

        local errorMessage = string.format(paramErrorMessage, proxyObject.controller.objectName, proxyObject.key);
        return paramDefs, errorMessage;
    end

    function Core:GetReturnsDefinition(proxyObject)
        local funcDef = proxyObject.controller.definitions[proxyObject.key];

        if (not funcDef) then
            return;
        end

        local returnDefs = funcDef and funcDef.returnDefs;

        if (not returnDefs) then
            return;
        end

        local errorMessage = string.format(returnErrorMessage, proxyObject.controller.objectName, proxyObject.key);

        return returnDefs, errorMessage;
    end
end

function Core:Assert(condition, errorMessage, ...)
    if (not condition) then
        if ((select(1, ...)) ~= nil) then
            errorMessage = string.format(errorMessage, ...);

        elseif (string.match(errorMessage, "%s")) then
            errorMessage = string.format(errorMessage, nilType);
        end

        if (self.silent) then
            self.errorLog = self.errorLog or Lib:PopWrapper();
            self.errorLog[#self.errorLog + 1] = pcall(function() error(self.PREFIX .. errorMessage) end);

        elseif (Lib:IsFunction(self.errorHandler)) then
            local level = _G.DEBUGLOCALS_LEVEL;
            local stack = _G.debugstack(level);
            local locals = _G.debuglocals(level);
            self.errorHandler(errorMessage, stack, locals);
        else
            error(self.PREFIX .. errorMessage);
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
    if (value == nil) then
        return expectedTypeName == nilType;
    end

    -- check if basic type
    if (expectedTypeName == tableType or expectedTypeName == numberType
        or expectedTypeName == functionType or expectedTypeName == booleanType
        or expectedTypeName == stringType) then

        return (expectedTypeName == type(value));
    end

    if (not Lib:IsTable(value)) then
        return false;
    end

    local controller = self:GetController(value, true);

    if (not controller) then
        if (value.GetObjectType and expectedTypeName == value:GetObjectType()) then
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

        value = controller.parentClass;

        if (Lib:IsTable(value)) then
            controller = self:GetController(value, true); -- fail silently
        end
    end

    return false;
end

function Core:GetValueType(value)
    if (value == nil) then
        return nilType;
    end

    local valueType = type(value);

    if (not Lib:IsTable(valueType)) then
        return valueType;
    elseif (value.GetObjectType) then
        return value:GetObjectType();
    end

    return tableType;
end

---------------------------------
-- Package Class
---------------------------------
Package = Core:CreateClass(nil, nil, "Package");

function Package:__Construct(data, packageName)
    data.packageName = packageName;
    data.entities = {};
end

function Package:GetName(data)
    return data.packageName;
end

function Package:AddSubPackage(data, subPackage)
    local subPackageName = subPackage:GetName();
    local subPackageData = Core:GetPrivateInstanceData(subPackage);

    Core:Assert(not data.entities[subPackageName],
        "Package.AddSubPackage - bad argument #1 ('%s' package already exists inside this package).", subPackageName);

    data.entities[subPackageName] = subPackage;
    subPackageData.parentPackage = self;
end

function Package:GetParentPackage(data)
    return data.parentPackage;
end

function Package:Get(data, entityName, silent)
    Core:Assert(silent or data.entities[entityName],
        "Entity '%s' does not exist in this package.", entityName);
    return data.entities[entityName];
end

function Package:CreateClass(data, className, parentClass, ...)
    Core:Assert(not data.entities[className],
        "Class '%s' already exists in this package.", className);

    local class = Core:CreateClass(self, data, className, parentClass, ...);
    self[className] = class;
    return class;
end

function Package:CreateInterface(data, interfaceName, interfaceDefinition)
    Core:Assert(not data.entities[interfaceName],
        "Entity '%s' already exists in this package.", interfaceName);

    local interface = Core:CreateInterface(data, interfaceName, interfaceDefinition);
    data.entities[interfaceName] = interface;
    self[interfaceName] = interface;

    return interface;
end

-- temporarily store param definitions to be applied to next new indexed function
function Package:DefineParams(data, ...)
    data.tempParamDefs = Lib:PopWrapper(...);
end

-- temporarily store return definitions to be applied to next new indexed function
function Package:DefineReturns(data, ...)
    data.tempReturnDefs = Lib:PopWrapper(...);
end

-- prevents other functions being added or modified
function Package:ProtectClass(_, class)
    local classController = Core:GetController(class);

    Core:Assert(classController and classController.isClass, "Package.ProtectClass - bad argument #1 (class not found).");
	classController.isProtected = true;
end

function Package:GetObjectType()
    return "Package";
end

function Package:IsObjectType(_, objectName)
    return "package" == string.lower(objectName);
end

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
local Object = SystemPackage:CreateClass("Object");

function Object:GetObjectType()
	return Core:GetController(self).objectName;
end

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

    if (controller.parentClass) then
        -- check if any parent class is of type objectName
        controller = Core:GetController(controller.parentClass);

        while (controller) do
            if (controller.objectName == objectName) then
                return true;
            end

            controller = Core:GetController(controller.parentClass);
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

-- Call parent constructor
function Object:Super(data, ...)
    local controller = Core:GetController(self);

    if (controller.UsingParent) then
        controller = Core:GetController(controller.UsingParent);
    end

    controller.UsingParent = controller.parentClass;
    local parentController = Core:GetController(controller.parentClass);

    if (parentController.class.__Construct) then
        parentController.class.__Construct(self, data, ...);
        controller.UsingParent = nil;
    end
end

function Object:GetParentClass()
	return Core:GetController(self).parentClass;
end

--TODO: Needs to be tested!
-- can be used to call Parent methods (self and data reference origin child object)
function Object:Parent()
    local controller = Core:GetController(self);
	local parentController = Core:GetController(controller.parentClass);
	parentController.UsingChild = controller.UsingChild or self; -- allows you to chain Parent() calls

    return controller.parentClass;
end

function Object:GetPackage()
	return Core:GetController(self).package;
end

function Object:GetClass()
	return getmetatable(self).class;
end

function Object:Clone()
    local instanceController = Core:GetController(self);
    local classController = Core:GetController(instanceController.proxy);
	classController.cloneFrom = self;

    -- Executes Class __call metamethod
	local instance = instanceController.proxy();

	if (not self:Equals(instance)) then
        Core:Error("Clone data corrupted.");
	end

	return instance;
end

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
    Lib:PushWrapper(instanceController.instance);
    instanceController.instance = nil;

    -- destroy instance private data
    Lib:PushWrapper(instanceController.privateData);
    instanceController.privateData = nil;

    -- destroy instance controller
    Lib:PushWrapper(instanceController);

    -- destroy proxy instance
    Lib:EmptyTable(self);
    self.IsDestroyed = true;
end