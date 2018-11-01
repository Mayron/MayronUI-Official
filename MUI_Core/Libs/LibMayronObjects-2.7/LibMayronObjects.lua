local Lib = LibStub:NewLibrary("LibMayronObjects", 2.7);
if (not Lib) then return; end

local error, assert, rawget, rawset = error, assert, rawget, rawset;
local type, setmetatable, table, string = type, setmetatable, table, string;
local getmetatable, unpack, select = getmetatable, unpack, select;

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
ProxyStack.FuncStrings = {}; 

local Core = {}; -- holds all private Lib core functions for internal use
Core.Lib = Lib;
Core.PREFIX = "|cffffcc00LibMayronObjects: |r"; -- this is used when printing out errors
Core.ExportedPackages = {}; -- contains all exported packages 

--[[ 
-- need a reference for this to hack around the manual exporting process 
-- (exporting the package class but it's already a package...)
--]]
local Package; 

--------------------------------------------
-- LibMayronObjects Functions
--------------------------------------------
-- @param packageName (string) - the name of the package.
-- @param namespace (string) - the parent package namespace. Example: "Framework.System.Package".
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
    local nodes = {strsplit(".", namespace)};

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
    Core:Assert(not Core:IsStringNilOrWhiteSpace(namespace), "Export - bad argument #2 (invalid namespace)");    

    for id, key in ipairs({strsplit(".", namespace)}) do 
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
        Core:EmptyTable(Core.errorLog);
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

-------------------------------------
-- ProxyStack
-------------------------------------
-- intercepts function calls on classes and instance objects and returns a proxy function used for validation. 
-- @param proxyEntity (table) - a table containing all functions assigned to a class or interface.
-- @param key (string) - the function name/key being called.
-- @param entity (table) - the instance or class object originally being called with the function name/key.
-- @param controller (table) - the entities meta-data (stores validation rules and more).
-- @return proxyFunc (function) - the proxy function is returned and called instead of the real function.
function ProxyStack:Pop(proxyEntity, key, entity, controller) 
    local proxyObject;
   
    if (#self == 0) then   
        proxyObject = setmetatable({}, ProxyStack.MT);
    else
        proxyObject = self[#self];
        self[#self] = nil;
    end

    proxyObject.Object = proxyEntity;
    proxyObject.Key = key;
    proxyObject.Controller = controller;
    proxyObject.Self = entity;

    proxyObject.Run = proxyObject.Run or function(_, ...)
        local definition, errorMessage = Core:GetParamsDefinition(proxyObject);
        Core:ValidateFunctionCall(definition, errorMessage, ...);

        if (not proxyObject.PrivateData) then

            if (proxyObject.Controller.IsInterface) then
                Core:Error("%s.%s is an interface function and must be implemented and invoked by an instance object.", 
                    proxyObject.Controller.EntityName, proxyObject.Key);
            else  
                Core:Error("%s.%s is a non static function and must be invoked by an instance object.", 
                    proxyObject.Controller.EntityName, proxyObject.Key);
            end
        end
        
        definition, errorMessage = Core:GetReturnsDefinition(proxyObject);

        Core:Assert(type(proxyObject.PrivateData) == "table" and not proxyObject.PrivateData.GetObjectType, 
            "Invalid instance private data found when calling %s.%s: %s", 
            proxyObject.Controller.EntityName, proxyObject.Key, tostring(proxyObject.PrivateData));

        local returnValues = {
            Core:ValidateFunctionCall(definition, errorMessage, 
                proxyObject.Object[proxyObject.Key](proxyObject.Self, proxyObject.PrivateData, ...)) 
        };

        if (proxyObject.Key ~= "Destroy") then
            local classController = Core:GetController(proxyObject.Self, true);

            if (classController) then
                -- might have been destroyed during the function call
                classController.UsingChild = nil;
            end
        end

        ProxyStack:Push(proxyObject); 

        if (#returnValues == 0) then
            return nil; -- fixes returning nil instead of nothing
        end
        
        return unpack(returnValues);
    end

    ProxyStack.FuncStrings[tostring(proxyObject.Run)] = proxyObject;
    return proxyObject.Run;
end

-- Pushes the proxy function back into the stack object once no longer needed.
-- Also, resets the state of the proxy function for future use.
-- @param proxyFunc (function) - a proxy function returned from ProxyStack:Pop();
function ProxyStack:Push(proxyFunc)
    self[#self + 1] = proxyFunc;

    proxyFunc.Object        = nil;
    proxyFunc.Key           = nil;
    proxyFunc.Self          = nil;
    proxyFunc.PrivateData   = nil;
    proxyFunc.Controller    = nil;

    ProxyStack.FuncStrings[tostring(proxyFunc.Run)] = nil;
end

-- Needed for editing the proxyObject properties because ProxyStack:Pop only returns the runnable function
-- @param func (function) - converts function to string to be used as a key to access the corresponding proxyObject.
-- @return proxyFunc (function) - the proxyObject.
function ProxyStack:GetProxyObject(proxyFunc)
    return ProxyStack.FuncStrings[tostring(proxyFunc)];
end

-------------------------------------
-- Core Functions
-------------------------------------
function Core:CreateClass(package, packageData, className, parentClass, ...)
    local Class                 = {}; -- stores real table indexes (once proxy has completed evaluating data)
    local ProxyClass            = {}; -- enforces __newindex meta-method to always be called (new indexes, if valid, are added to Class instead)
    local ProxyClassMT          = {}; -- acts as a filter to protect invalid keys from being indexed into Class
    local Definitions           = {}; -- function definitions for params and return values
    local Friends               = {}; -- friend classes can access instance private data of this class
    local ClassController       = {}; -- holds special Lib data to control class
    local RawProxyClassString   = tostring(ProxyClass);

    ClassController.IsClass     = true;
    ClassController.EntityName  = className;    
    ClassController.Entity      = ProxyClass;
    ClassController.Definitions = Definitions;
    ClassController.Friends     = Friends;
    ClassController.Class       = Class;

    -- protected table for assigning Static functions
    ProxyClass.Static = {}; 

    if (package and packageData) then
        -- link new class to package
        ClassController.Package = package;
        ClassController.PackageData = packageData;
        packageData.entities[className] = ProxyClass;
    else
        -- creating the Package class (cannot assign it to a package instance as Package class does not exist!)
        ClassController.IsPackage = true;
    end

    if (className:match("<") and className:match(">")) then
        ClassController.IsGenericType = true;
        ClassController.GenericTypes = self:GetGenericTypesFromClassName(className);
    end

    self:SetParentClass(ClassController, parentClass);
    self:SetInterfaces(ClassController, ...);

    -- ProxyClass functions --------------------------

    ProxyClass.Static.AddFriendClass = function(_, friendClassName)
        Friends[friendClassName] = true;
    end

    ProxyClass.Static.IsFriendClass = function(_, friendClassName)
        if (friendClassName == className) then 
            return true;
        end
        
        return Friends[friendClassName];
    end

    ProxyClass.Static.OnIndexChanged = function(_, callback)
        ClassController.indexChangedCallback = callback;
    end

    ProxyClass.Static.OnIndexChanging = function(_, callback)
        ClassController.indexChangingCallback = callback;
    end

    ProxyClass.Static.OnIndexed = function(_, callback)
        ClassController.indexedCallback = callback;
    end

    ProxyClass.Static.OnIndexing = function(_, callback)
        ClassController.indexingCallback = callback;
    end

    ProxyClass.Of = function(_, ...)
        Core:Assert(ClassController.IsGenericType, "%s is not a generic class", className);
        ClassController.TempRealGenericTypes = {...}; -- holds real type names

        for id, realType in ipairs(ClassController.TempRealGenericTypes) do
            -- remove spaces
            ClassController.TempRealGenericTypes[id] = (realType:gsub("%s+", ""));
        end

        return ProxyClass;
    end

    -- ProxyClassMT meta-methods ------------------------
    
    ProxyClassMT.__call = function(_, ...)
        return self:CreateInstance(ClassController, ...);        
    end

    ProxyClassMT.__index = function(_, key)
        self:Assert(not ClassController.Indexing,
            "'%s' attempted to re-index itself during the same index request with key '%s'.", className, key);
            
        -- start indexing process (used to detect if an index loop has occured in error)
        ClassController.Indexing = true;
        
        local value = Class[key]; -- get the real value
        
        if (type(value) == "function") then
            -- get a proxy function object to validate function params and return values            
            value = ProxyStack:Pop(Class, key, ProxyClass, ClassController);

        elseif (value == nil) then
            -- no real value stored in Class
            if (ClassController.ParentClass) then
                -- search parent class instead	
                value = ClassController.ParentClass[key];               

                if (type(value) == "function") then
                    -- need to update the "self" reference to use this class, not the parent!
                    local proxyObject = ProxyStack:GetProxyObject(value);
                    proxyObject.Self = ProxyClass;
                end
            end

            if (value == nil and Class.GetFrame and key ~= "GetFrame") then
                -- note: cannot check if frame has key here...
                -- if value is still not found and object has a GetFrame method (usually
                -- from inheriting FrameWrapper) then index the frame
                value = ProxyStack:Pop(Class, "GetFrame", ProxyClass, ClassController);
            end 
        end

        if (ClassController.UsingChild and type(value) == "function") then
            -- if Object:Parent() was used, call parent function with the child as the reference
            local child = ClassController.UsingChild;
            local childController = Core:GetController(child);                  
            local proxyObject = ProxyStack:GetProxyObject(value);
                
            proxyObject.PrivateData = self:GetPrivateInstanceData(child, childController);
        end     

        -- end indexing process (used to detect if an index loop has occured in error)
        ClassController.Indexing = nil;

        return value;
    end

    ProxyClassMT.__newindex = function(_, key, value)
        if (key == "Static") then
            -- not allowed to override "Static" Class property!
            self:Error("%s.Static property is protected.", className);
            return;
        end

        if (ClassController.IsProtected) then
            self:Error("%s is protected.", className);
        end

        if (type(value) == "function") then
            -- Adds temporary definition info to ClassController.Definitions table
            self:AttachFunctionDefinition(ClassController, key);
        end

        Class[key] = value;
    end

    ProxyClassMT.__tostring = function()
        return RawProxyClassString:gsub("table", string.format("<Class> %s", className));
    end
    
    -----------------------------------------------
    
    setmetatable(ProxyClass, ProxyClassMT);
    AllControllers[tostring(ProxyClass)] = ClassController;
    return ProxyClass;
end

function Core:CreateInstance(classController, ...)
    local Instance                  = {}; -- stores real table indexes (once proxy has completed evaluating data)
    local ProxyInstance             = {}; -- enforces __newindex meta-method to always be called (new indexes, if valid, are added to Instance instead)
    local ProxyInstanceMT           = {}; -- acts as a filter to protect invalid keys from being indexed into Instance
    local PrivateData               = {}; -- private instance data passed to function calls (the 2nd argument)
    local InstanceController        = {};-- holds special Lib data to control instance
    local RawProxyInstanceString    = tostring(ProxyInstance);

    InstanceController.PrivateData = PrivateData;

    -- required for Destroy() cleanup
    InstanceController.Instance = Instance;

    -- interfaceController requires knowledge of many classController settings
    setmetatable(InstanceController, {__index = classController});

    if (classController.IsGenericType) then
        -- renames EntiyName for instance controller, and creates "RealGenericTypes" instance controller property
        self:ApplyGenericTypesToInstance(InstanceController, classController)
    end

    PrivateData.GetFriendData = function(_, friendInstance)
        local friendClassName = friendInstance:GetObjectType();
        local friendClass = classController.PackageData.entities[friendClassName]; -- must be in same package!        

        if (friendClass and friendClass.Static:IsFriendClass(classController.EntityName)) then
            return self:GetPrivateInstanceData(friendInstance);
        end
    end    

    ProxyInstanceMT.__index = function(_, key)
        local value;

        if (classController.indexingCallback) then            
            value = classController.indexingCallback(ProxyInstance, InstanceController.PrivateData, key);
        end        

        -- check if instance property        
        if (value == nil and Instance[key] ~= nil) then
            value = Instance[key];
        end

        if (value == nil) then
            -- check if class property (Static) or class function
            value = classController.Entity[key];

            if (value and type(value) == "function") then                
                local proxyObject = ProxyStack:GetProxyObject(value);               
                proxyObject.Self = ProxyInstance; -- switch ProxyClass reference to ProxyInstance
                proxyObject.PrivateData = PrivateData; -- set PrivateData to be injected into function call
                
                if (proxyObject.Key == "GetFrame" and key ~= "GetFrame") then  
                    -- ProxyClass changed key to GetFrame during __index meta-method call              
                    local frame = value(); -- call the proxyObject.Run function here to get the frame
        
                    if (frame[key]) then
                        -- if the frame has the key we are trying to get...

                        if (type(frame[key]) == "function") then
                            value = function(_, ...)
                                -- call the frame (a blizzard widget) here
                                return frame[key](frame, ...);
                            end
                        else
                            value = frame[key];
                        end
                    else
                        value = nil;
                    end
                end       
            end
        end

        if (classController.indexedCallback) then
            value = classController.indexedCallback(ProxyInstance, InstanceController.PrivateData, key, value);
        end
        
        return value;
    end

    ProxyInstanceMT.__newindex = function(_, key, value)
        self:Assert(not classController.Class[key], 
            "Cannot override class-level property '%s.%s' from an instance.", classController.EntityName, key);

        self:Assert(type(value) ~= "function", "Functions must be added to a class, not an instance.");

        if (classController.indexChangingCallback) then            
            local preventIndexing = classController.indexChangingCallback(ProxyInstance, InstanceController.PrivateData, key, value);

            if (preventIndexing) then 
                -- do not continue indexing
                return;
            end
        end

        Instance[key] = value;

        -- if reassigning an instance property, should check that new value is valid
        if (InstanceController.IsConstructed) then            
            Core:ValidateImplementedProperties(Instance, classController.Interfaces, classController.EntityName);
        end
        
        if (classController.indexChangedCallback) then
            classController.indexChangedCallback(ProxyInstance, InstanceController.PrivateData, key, value);
        end
    end

    ProxyInstanceMT.__gc = function()
        ProxyInstance:Destroy();
    end

    ProxyInstanceMT.__tostring = function()
        return RawProxyInstanceString:gsub("table", string.format("<Instance> %s", classController.EntityName));      
    end

    setmetatable(ProxyInstance, ProxyInstanceMT);
    AllControllers[tostring(ProxyInstance)] = InstanceController;

    -- Clone or Create Instance here:
    if (classController.CloneFrom) then
        local otherInstance = classController.CloneFrom;
        local otherController = self:GetController(otherInstance);
        local otherInstanceData = self:GetPrivateInstanceData(otherInstance, otherController);

        self:Assert(otherInstanceData, "Invalid Clone Object.");
        self:CopyTableValues(otherInstanceData, PrivateData);
        classController.CloneFrom = nil;
    else            
        if (classController.Class.__Construct) then
            -- call custom constructor here!
            ProxyInstance:__Construct(...);            
        end
    
        Core:ValidateImplementedProperties(Instance, classController.Interfaces, classController.EntityName);  
        Core:ValidateImplementedFunctions(classController);
    end

    InstanceController.IsConstructed = true;
    return ProxyInstance;
end

function Core:CreateInterface(packageData, interfaceName)
    local Interface                           = {};
    local InterfaceMT                         = {};
    local InterfaceController                 = {};

    InterfaceController.Entity                = Interface; -- reference to the real interface
    InterfaceController.EntityName            = interfaceName; -- class and interface controllers are grouped together so we use "Entity" name
    InterfaceController.Protected             = false; -- true if functions and properties are to be protected
    InterfaceController.Definitions           = {}; -- holds interface function definitions
    InterfaceController.PropertyDefinitions   = {}; -- property definitions work differently so store in different table
    InterfaceController.IsInterface           = true; -- to distinguish between a class and an interface controller
    InterfaceController.PackageData           = packageData; -- used for when attaching function definitions

    function Interface:DefineProperty(propertyName, propertyType)    
        if (not Core:IsStringNilOrWhiteSpace(propertyName) and not Core:IsStringNilOrWhiteSpace(propertyType)) then    
            propertyType = propertyType:gsub("%s+", "");             
        
            Core:Assert(not InterfaceController.PropertyDefinitions[propertyName], 
                "%s.%s Definition already exists.", interfaceName, propertyName);

            InterfaceController.PropertyDefinitions[propertyName] = propertyType;
        end
    end
    
    InterfaceMT.__newindex = function(interface, key, value)
        if (type(value) == "function") then            
            self:AttachFunctionDefinition(InterfaceController, key);                
        end
        rawset(interface, key, value);
    end

    setmetatable(Interface, InterfaceMT);
    AllControllers[tostring(Interface)] = InterfaceController;
    return Interface;
end

function Core:EmptyTable(tbl)
    for key, _ in pairs(tbl) do
        tbl[key] = nil;
    end
end

-- returns comma-separated string list of generic type placeholders (example: "K,V,V2")
function Core:GetGenericTypesFromClassName(className)
    local sections = {strsplit("<", className)};
    self:Assert(#sections > 1, "%s is a non-generic type.", className);

    local genericTypes = sections[2];

    -- remove ">" from comma-separated string list of generic types
    genericTypes = genericTypes:sub(1, (genericTypes:find(">")) - 1);

    -- turn genericTypes into an array
    genericTypes = {strsplit(',', genericTypes)}; 

    -- string.trim each type
    for id, genericType in ipairs(genericTypes) do
        genericTypes[id] = genericType:gsub("%s+", "");
    end

    return genericTypes;
end

function Core:ApplyGenericTypesToInstance(instanceController, classController)
    -- Move all specified generic type definitions from "Of()" to instance controller
    if (not classController.TempRealGenericTypes) then
        classController.TempRealGenericTypes = {};

        for id, _ in ipairs(classController.GenericTypes) do
            -- assign default type to alias generic type keys ("K" = "number")
            classController.TempRealGenericTypes[id] = "any";
        end

    elseif (#classController.TempRealGenericTypes < #classController.GenericTypes) then
        
        for id = (#classController.TempRealGenericTypes + 1), #classController.GenericTypes do
            classController.TempRealGenericTypes[id] = "any";
        end
    end
    
    instanceController.RealGenericTypes = classController.TempRealGenericTypes;
    classController.TempRealGenericTypes = nil;    

    -- change instance name to use real types
    local className = classController.EntityName;
    local redefinedInstanceName = (select(1, strsplit("<", className))).."<";    

    for id, realType in ipairs(instanceController.RealGenericTypes) do
        
        if (id < #instanceController.RealGenericTypes) then
            redefinedInstanceName = string.format("%s%s, ", redefinedInstanceName, realType);
        else
            redefinedInstanceName = string.format("%s%s>", redefinedInstanceName, realType);
        end
    end

    instanceController.EntityName = redefinedInstanceName;
end

-- Attempt to add definitions for new function Index (params and returns)
--@param controller - an instance or class controller
--@param newFuncKey - the new key being indexed into Class (pointing to a function value)
function Core:AttachFunctionDefinition(controller, newFuncKey)    
    if (not controller.PackageData or controller.EntityName == "Package") then
        return;
    end

    -- temporary definition info (received from DefineParams and DefineReturns function calls)
    local paramDefs = controller.PackageData.tempParamDefs;
    local returnDefs = controller.PackageData.tempReturnDefs; 
    
    if (not paramDefs and not returnDefs) then
        return;
    end

    if (controller.IsClass) then
        local interfaceController;

        -- check if user is trying to redefine interface function (not allowed)
        for _, interface in ipairs(controller.Interfaces) do
            interfaceController = self:GetController(interface);

            self:Assert(not interfaceController.Definitions[newFuncKey],
                "%s cannot redefine interface function '%s'", controller.EntityName, newFuncKey);
        end
    end 

    -- holds definition for the new function
    local funcDefinition;

    if (paramDefs and #paramDefs > 0) then
        funcDefinition = {};
        funcDefinition.paramDefs = Core:CopyTableValues(paramDefs);
    end

    if (returnDefs and #returnDefs > 0) then
        funcDefinition = funcDefinition or {};
        funcDefinition.returnDefs = Core:CopyTableValues(returnDefs);
    end

    -- remove temporary definitions once implemented   
    controller.PackageData.tempParamDefs = nil;
    controller.PackageData.tempReturnDefs = nil;

    self:Assert(not controller.Definitions[newFuncKey], 
        "%s.%s Definition already exists.", controller.EntityName, newFuncKey);

    controller.Definitions[newFuncKey] = funcDefinition;
end

function Core:SetInterfaces(classController, ...) 
	classController.Interfaces = {};    

    for id, interface in ipairs({...}) do
        if (type(interface) == "string") then
            interface = Lib:Import(interface);
        end

        local interfaceController = self:GetController(interface);

        if (interfaceController and interfaceController.IsInterface) then
            table.insert(classController.Interfaces, interface);           
        else
            self:Error("Core.SetInterfaces: bad argument #%d (invalid interface)", id);
        end
    end
end

-- Helper function to copy key/value pairs from copiedTable to receiverTable
function Core:CopyTableValues(copiedTable, receiverTable)
    receiverTable = receiverTable or {};
    
    for key, value in pairs(copiedTable) do
        if (type(value) == "table") then
            receiverTable[key] = self:CopyTableValues(value);
        else
            receiverTable[key] = value;
        end 
    end
    
    return receiverTable;
end

function Core:IsStringNilOrWhiteSpace(strValue)       
    if (strValue) then
        Core:Assert(type(strValue) == "string",
            "Core.IsStringNilOrWhiteSpace - bad argument #1 (string expected, got %s)", type(strValue));

        strValue = strValue:gsub("%s+", "");

        if (#strValue > 0) then
            return false;
        end
    end

    return true;
end

function Core:SetParentClass(classController, parentClass)    
    if (parentClass) then
		if (type(parentClass) == "string" and not self:IsStringNilOrWhiteSpace(parentClass)) then
			classController.ParentClass = Lib:Import(parentClass);
		
		elseif (type(parentClass) == "table" and parentClass.Static) then
			classController.ParentClass = parentClass;
		end

        self:Assert(classController.ParentClass, "Core.SetParentClass - bad argument #2 (invalid parent class).");
	else
        classController.ParentClass = Lib:Import("Framework.System.Object", true);

        if (classController.Entity == classController.ParentClass) then
            -- cannot be parented to itself (i.e. Object class has no parent)
            classController.ParentClass = nil;
        end
    end
end

function Core:PathExists(root, path)
    self:Assert(root, "Core.PathExists - bad argument #1 (invalid root).");

    for _, key in ipairs({strsplit(".", path)}) do
        if (not root[key]) then
            return false;
        end

        root = root[key];
    end

    return true;
end

function Core:GetController(entity, silent)
    if (AllControllers[tostring(entity)]) then       
        return AllControllers[tostring(entity)];
    end

    if (not silent) then
        self:Error("Core.GetController - bad argument #1 (invalid entity).");
    end	
end

function Core:GetPrivateInstanceData(instance, instanceController)
    instanceController = instanceController or self:GetController(instance);
    local data = instanceController.PrivateData;

    self:Assert(type(data) == "table" and not data.GetObjectType,
        "Invalid instance private data for entity %s.", instanceController.EntityName);

    return data;
end

-- Call this after using the constructor to make sure properties have been implemented
function Core:ValidateImplementedProperties(Instance, interfaces, className)
    if (not interfaces) then
        return;
    end

    local errorFound;
    local errorMessage;
    local realValue;

    for id, interface in ipairs(interfaces) do
        local interfaceController = self:GetController(interface);

        if (interfaceController and interfaceController.IsInterface) then    
            local propertyDefinitions, message = Core:GetPropertyDefinitionsForInterface(interfaceController, className);                         
        
            for propertyName, propertyType in pairs(propertyDefinitions) do
                realValue = Instance[propertyName];
        
                if (propertyType:find("^\?")) then
                    -- it's optional:
                    propertyType = propertyType:sub(2, #propertyType);
                    errorFound = (realValue ~= nil) and (propertyType ~= "any" and not self:IsMatchingTypes(propertyType, realValue));
                else
                    errorFound = (realValue == nil) or (propertyType ~= "any" and not self:IsMatchingTypes(propertyType, realValue));
                end      
                
                errorMessage = string.format(message .. " (%s expected, got %s)", propertyType, self:GetValueType(realValue));
                errorMessage = errorMessage:gsub("##", propertyName);

                self:Assert(not errorFound, errorMessage);
            end
        end
    end
end

function Core:ValidateImplementedFunctions(classController)
    for _, interface in ipairs(classController.Interfaces) do
        for key, value in pairs(interface) do

            if (type(value) == "function" and key ~= "DefineProperty") then
                Core:Assert(classController.Class[key],
                    "Class '%s' does not implement interface function '%s'.", classController.EntityName, key);                      
            end
        end
    end
end

function Core:ValidateFunctionCall(definition, errorMessage, ...)
    local errorFound;
    local defValue;

    if (definition) then
        local id = 1;
        local realValue = (select(id, ...));

        repeat
            defValue = definition[id];
            
            if (defValue) then
                if (defValue:find("^\?")) then
                    -- it's optional:
                    defValue = defValue:sub(2, #defValue);
                    errorFound = (realValue ~= nil) and (defValue ~= "any" and not self:IsMatchingTypes(defValue, realValue));
                else
                    errorFound = (realValue == nil) or (defValue ~= "any" and not self:IsMatchingTypes(defValue, realValue));
                end
            else
                errorFound = true; 
                defValue = "nil";
            end

            if (errorFound) then
                errorMessage = string.format("%s (%s expected, got %s)", errorMessage, defValue, self:GetValueType(realValue));
                errorMessage = errorMessage:gsub("##", "#" .. tostring(id));        
                self:Error(errorMessage);
            end

            id = id + 1;
            realValue = (select(id, ...));

        until (not definition[id]);
    end

    return ...;
end

function Core:GetPropertyDefinitionsForInterface(interfaceController, className)
    local message = string.format("bad property value '%s.##'", className);
    local definition = interfaceController.PropertyDefinitions;
    return definition, message;
end

do
    local function GetFunctionDefinitionFromInterface(interfaces, funcKey)
        local interfaceController; 
        
        for _, interface in ipairs(interfaces) do
            interfaceController = Core:GetController(interface);

            for key, interfaceFuncDef in pairs(interfaceController.Definitions) do
                if (key == funcKey) then
                    -- use the first matching function definition (should not be more than 1)
                    return interfaceFuncDef;
                end
            end
        end
    end

    function Core:GetParamsDefinition(proxyObject)
        local errorMessage = string.format("bad argument ## to '%s.%s'", proxyObject.Controller.EntityName, proxyObject.Key);    
        local funcDef = proxyObject.Controller.Definitions[proxyObject.Key];

        if (not funcDef) then
            funcDef = GetFunctionDefinitionFromInterface(proxyObject.Controller.Interfaces, proxyObject.Key);
        end

        local paramDefs = funcDef and funcDef.paramDefs;

        if (paramDefs and proxyObject.Controller.IsGenericType) then
            -- if params contain generic type placeholders (example: DefineParams("T"))
            paramDefs = self:ReplaceGenericTypes(proxyObject.Controller, proxyObject.Self, paramDefs);
        end

        return paramDefs, errorMessage;
    end

    function Core:GetReturnsDefinition(proxyObject)
        local errorMessage = string.format("bad return value ## to '%s.%s'", proxyObject.Controller.EntityName, proxyObject.Key); 
        local funcDef = proxyObject.Controller.Definitions[proxyObject.Key];

        if (not funcDef) then
            funcDef = GetFunctionDefinitionFromInterface(proxyObject.Controller.Interfaces, proxyObject.Key);
        end

        local returnDefs = funcDef and funcDef.returnDefs;

        if (returnDefs and proxyObject.Controller.IsGenericType) then
            -- if params contain generic type placeholders (example: DefineParams("T"))
            returnDefs = self:ReplaceGenericTypes(proxyObject.Controller, proxyObject.Self, returnDefs);
        end

        return returnDefs, errorMessage;
    end
end

function Core:ReplaceGenericTypes(controller, instance, defTable) 
    local instanceController = Core:GetController(instance);
    local realDefTable = {}; -- Replaced all generic types with real types

    self:Assert(controller.GenericTypes and instanceController.RealGenericTypes, 
        "Failed to find generic type info for class %s", controller.EntityName);

    for id, genericType in ipairs(controller.GenericTypes) do        
        -- replace all references to generic type with real type:
        for defId, value in ipairs(defTable) do
            local optional = false;

            if (value:find("^\?")) then
                optional = true;
                value = value:sub(2, #value);                
            end

            if (value == genericType) then
                if (optional) then
                    realDefTable[defId] = string.format("\?%s", instanceController.RealGenericTypes[id]);
                else
                    realDefTable[defId] = instanceController.RealGenericTypes[id];
                end                
            end
        end
    end

    return realDefTable;
end

function Core:Assert(condition, errorMessage, ...)
    if (not condition) then
        if ( (select(1, ...)) ) then
            errorMessage = string.format(errorMessage, ...);
        end       

        if (self.silent) then
            self.errorLog = self.errorLog or {};
            self.errorLog[#self.errorLog + 1] = pcall(function() error(Core.PREFIX .. errorMessage) end);
        else
            error(self.PREFIX .. errorMessage);
        end
    end
end

function Core:Error(errorMessage, ...)
    self:Assert(false, errorMessage, ...);
end

function Core:IsMatchingTypes(expectedTypeName, value)
    if (value == nil) then
        return expected == "nil";
    end

    -- check if basic type
    if (expectedTypeName == "table" or expectedTypeName == "number" or expectedTypeName == "function" 
            or expectedTypeName == "boolean" or expectedTypeName == "string") then

        return (expectedTypeName == type(value));

    elseif (value.GetObjectType) then
        
        if (expectedTypeName == value:GetObjectType()) then
            return true;
        end

        local controller = self:GetController(value, true);

        while (value and controller) do

            if (expectedTypeName == controller.EntityName) then
                return true; -- Object or Widget matches!
            end
               
            -- check all interface types
            for _, interface in ipairs(controller.Interfaces) do
                local interfaceController = self:GetController(interface);

                if (expectedTypeName == interfaceController.EntityName) then
                    return true; -- interface name matches!
                end
            end        

            value = controller.ParentClass;
            controller = self:GetController(value, true); -- fail silently
        end
    end

    return false;
end

function Core:GetValueType(value)
    if (value == nil) then
        return "nil";
    end

    local valueType = type(value);

    if (valueType ~= "table") then
        return valueType;
    elseif (value.GetObjectType) then            
        return value:GetObjectType();
    end

    return "table";  
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
        "Class '%s' already exists in this package.", entityName);

    local class = Core:CreateClass(self, data, className, parentClass, ...);
    self[className] = class;
    return class;
end

function Package:CreateInterface(data, interfaceName)
    Core:Assert(not data.entities[interfaceName], 
        "Entity '%s' already exists in this package.", interfaceName);

    local interface = Core:CreateInterface(data, interfaceName);
    data.entities[interfaceName] = interface;
    self[interfaceName] = class;

    return interface;
end

-- temporarily store param definitions to be applied to next new indexed function
function Package:DefineParams(data, ...)
    data.tempParamDefs = {...};
end

-- temporarily store return definitions to be applied to next new indexed function
function Package:DefineReturns(data, ...)
    data.tempReturnDefs = {...};
end

-- prevents other functions being added or modified
function Package:ProtectClass(data, class)
    local classController = Core:GetController(class);

    Core:Assert(classController and classController.IsClass, "Package.ProtectClass - bad argument #1 (class not found).");
	classController.IsProtected = true;
end

function Package:GetObjectType()
    return "Package";
end

function Package:IsObjectType(data, objectName)
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

function Object:GetObjectType(data)	
	return Core:GetController(self).EntityName;
end

function Object:IsObjectType(data, objectName)
	local controller = Core:GetController(self);

	if (controller.EntityName == objectName) then
		return true;
    end

    -- check if any interfaces being implemented is of type objectName
    for _, interface in ipairs(controller.Interfaces) do
        local interfaceController = Core:GetController(interface);
        
        if (interfaceController.EntityName == objectName) then
            return true;
        end
    end

    -- check if any parent class is of type objectName
    controller = Core:GetController(controller.ParentClass);

    while (controller) do
        if (controller.EntityName == objectName) then
            return true;
        end
        
        controller = Core:GetController(controller.ParentClass);
    end

	return false;
end

function Object:Equals(data, other)
	if (type(other) ~= "table" or not other.GetObjectType) then 
		return false; 
    end
    
    if (other:GetObjectType() == self:GetObjectType()) then        
		local otherData = Core:GetPrivateInstanceData(other);

        for key, value in pairs(data) do    
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
    local parentController = Core:GetController(controller.ParentClass);
    
    if (parentController.Class.__Construct) then
        parentController.Class.__Construct(self, data, ...);
    end
end

function Object:GetParentClass(data)
	return Core:GetController(self).ParentClass;
end

-- can be used to call Parent methods (self and data reference origin child object)
function Object:Parent(data)
    local controller = Core:GetController(self);
	local parentController = Core:GetController(controller.ParentClass);
	parentController.UsingChild = controller.UsingChild or self; -- allows you to chain Parent() calls

    return controller.ParentClass;
end

function Object:GetPackage(data)
	return Core:GetController(self).Package;
end

function Object:GetClass()
	return getmetatable(self).Class;
end

function Object:Clone(data) 
    local instanceController = Core:GetController(self);
    local classController = Core:GetController(instanceController.Entity);
	classController.CloneFrom = self;

    -- Executes Class __call metamethod 
	local instance = instanceController.Entity();

	if (not self:Equals(instance)) then
        Core:Error("Clone data corrupted.");
	end

	return instance;
end

function Object:IsDestroyed()
    return false;
end

do
    local function IsDestroyedDummyFunc()
        return true;
    end

    function Object:Destroy(data)
        local instanceKey = tostring(self);
        
        if (self.__Destruct) then
            self:__Destruct();
        end       

        local instanceController = Core:GetController(self);
        setmetatable(self, nil);

        Core:EmptyTable(instanceController.Instance);
        Core:EmptyTable(instanceController.PrivateData);
        Core:EmptyTable(AllControllers[instanceKey]);

        instanceController.Instance = nil;
        instanceController.PrivateData = nil;
        AllControllers[instanceKey] = nil;       
        
        self.IsDestroyed = IsDestroyedDummyFunc
    end
end