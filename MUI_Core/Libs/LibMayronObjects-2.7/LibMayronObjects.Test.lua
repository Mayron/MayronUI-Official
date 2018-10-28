local _, Core = ...;

local lib = LibStub:GetLibrary("LibMayronObjects");

local function HelloWorld_Test1()  
    print("HelloWorld_Test1 Started");

    local TestPackage = lib:CreatePackage("HelloWorld_Test1", "Test");

    local HelloWorld = TestPackage:CreateClass("HelloWorld");

    function HelloWorld:Print(private, msg)
        assert(msg == "My 2nd Message");
        assert(private.secret == "This is a secret!");
    end

    function HelloWorld:__Construct(private, msg)
        private.secret = "This is a secret!";
        assert(msg == "My 1st Message");
        assert(self ~= HelloWorld);
    end

    function HelloWorld:__Destruct(private, msg)
        --print("Instance Destroyed"); -- works!
    end

    local instance = HelloWorld("My 1st Message");
    instance:Print("My 2nd Message");

    local HelloWorld2 = lib:Import("Test.HelloWorld_Test1.HelloWorld");
    assert(HelloWorld == HelloWorld2);

    local className = instance:GetObjectType();
    assert(className == "HelloWorld", className);

    instance:Destroy();

    print("HelloWorld_Test1 Successful!");
end

local function Inheritance_Test1()  
    print("Inheritance_Test1 Started");

    local TestPackage = lib:CreatePackage("Inheritance_Test1", "Test");

    local Parent = TestPackage:CreateClass("Parent"); 

    --local Child = TestPackage:CreateClass("Child", "Parent"); -- invalid namespace (it's not been exported as expected!)
    local Child = TestPackage:CreateClass("Child", Parent); -- this works (as expected) - doesn't need exporting first

    function Parent.Static:Move()
        print("moving");
    end

    function Parent:Talk(data)
        assert(data.Dialog == "I am a child!");
    end

    -- never gets called
    function Child:__Construct(data)
        data.Dialog = "I am a child!";
    end

    function Parent:__Construct(data)
        data.Dialog = "I am a parent.";
    end

    local child = Child();

    assert(child:GetObjectType() == "Child");

    assert(child:IsObjectType("Child"));
    assert(child:IsObjectType("Parent"));

    local child2 = child:Clone();
    assert(child:Equals(child2));

    child:Talk();

    child:Destroy();

    print("Inheritance_Test1 Successful!");
end

function DefineParams_Test1()
    print("DefineParams_Test1 Started");

    local TestPackage = lib:CreatePackage("DefineParams_Test1", "Test");

    local Player = TestPackage:CreateClass("Player");

    TestPackage:DefineParams("string", "?number");
    function Player:GetSpellCasting(private, spellName, spellType)
        spellType = spellType or 0;
    end

    local p = Player();

    p:GetSpellCasting("Bloodlust"); -- should work!    
    p:GetSpellCasting("Flame Shock", 123); -- should work!
    
    lib:SetSilentErrors(true);

    p:GetSpellCasting(123); -- should fail as not a string!
    assert(lib:GetNumErrors() == 1);

    p:GetSpellCasting("Flame Shock", "123"); -- should fail as not a number!  
    assert(lib:GetNumErrors() == 2);     

    lib:FlushErrorLog();
    lib:SetSilentErrors(false);

    print("DefineParams_Test1 Successful!");
end

function DefineReturns_Test1()
    print("DefineReturns_Test1 Started");

    local TestPackage = lib:CreatePackage("DefineReturns_Test1", "Test");

    local Player = TestPackage:CreateClass("Player");

    TestPackage:DefineReturns("string", "?number");
    function Player:Func1(private)        
        return "Success!";
    end

    TestPackage:DefineReturns("string", "?number");
    function Player:Func2(private)        
        return "Success!", 123;
    end

    TestPackage:DefineReturns("string", "?number");
    function Player:Func3(private)        
        return 123;
    end

    TestPackage:DefineReturns("string", "?number");
    function Player:Func4(private)        
        return "Fail", "123";
    end

    local p = Player();

    p:Func1();
    p:Func2();

    lib:SetSilentErrors(true);

    p:Func3(); -- should fail!
    p:Func4(); -- should fail!

    assert(lib:GetNumErrors() == 2);

    lib:FlushErrorLog();
    lib:SetSilentErrors(false);

    print("DefineReturns_Test1 Successful!");
end

function ImportPackage_Test1()
    print("ImportPackage_Test1 Started");

    local TestPackage = lib:CreatePackage("ImportPackage_Test1");
    lib:Export(TestPackage, "Test"); -- same as: lib:CreatePackage("ImportPackage_Test1", "Test");
    
    local CheckButton   = TestPackage:CreateClass("CheckButton");
    local Button        = TestPackage:CreateClass("Button");
    local Slider        = TestPackage:CreateClass("Slider");
    local TextArea      = TestPackage:CreateClass("TextArea");
    local FontString    = TestPackage:CreateClass("FontString");
    local Animator      = TestPackage:CreateClass("Animator");

    assert(TestPackage:Size() == 6);

    local CheckButton2 = lib:Import("Test.ImportPackage_Test1.CheckButton");

    assert(CheckButton == CheckButton2);

    local importedPackage = lib:Import("Test.ImportPackage_Test1");

    assert(importedPackage == TestPackage);
    assert(importedPackage:Size() == 6);

    -- packageMap:ForEach(function(className, _) print(className) end); -- works!

    local CheckButton3 = importedPackage:Get("CheckButton");

    assert(CheckButton == CheckButton3);

    print("ImportPackage_Test1 Successful!");
end

function DuplicateClass_Test1()
    print("DuplicateClass_Test1 Started");

    local TestPackage = lib:CreatePackage("DuplicateClass_Test1");

    lib:SetSilentErrors(true);

    local p = TestPackage:CreateClass("Player");
    local p2 = TestPackage:CreateClass("Player");

    assert(lib:GetNumErrors() == 1);
    lib:FlushErrorLog();
    lib:SetSilentErrors(false);

    print("DuplicateClass_Test1 Successful!");
end

function Interfaces_Test1()
    print("Interfaces_Test1 Started");

    local TestPackage = lib:CreatePackage("Interfaces_Test1");

    local IComparable = TestPackage:CreateInterface("IComparable");

    TestPackage:DefineParams("number", "number");
    TestPackage:DefineReturns("boolean");
    function IComparable:Compare(a, b) end

    local Item = TestPackage:CreateClass("Item", nil, IComparable);

    function Item:Compare(data, a, b)
        return a < b;
    end

    local item1 = Item();
    assert(item1:Compare(19, 20));

    assert(item1:GetObjectType() == "Item");
    assert(item1:IsObjectType("Item")); 
    assert(item1:IsObjectType("IComparable"));

    print("Interfaces_Test1 Successful!");
end

function Interfaces_Test2()
    print("Interfaces_Test2 Started");

    local TestPackage = lib:CreatePackage("Interfaces_Test2");

    local ICell = TestPackage:CreateInterface("ICell");

    TestPackage:DefineParams("number")
    function ICell:Create() end
    function ICell:Update() end
    function ICell:Destroy() end

    local Panel = TestPackage:CreateClass("Panel", nil, ICell);

    function Panel:Create(data, num) end

    function Panel:Destroy(data) end

    function Panel:Update(data) end

    local p = Panel();
    p:Create(12);

    print("Interfaces_Test2 Successful!");
end

function Interfaces_Test3()
    print("Interfaces_Test3 Started");

    local TestPackage = lib:CreatePackage("Interfaces_Test3");

    local IDummyInterface = TestPackage:CreateInterface("IDummyInterface");

    TestPackage:DefineParams("number");
    function IDummyInterface:DoSomething(number) end

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyInterface);

    lib:SetSilentErrors(true);  

    TestPackage:DefineParams("string"); -- attempt to redefine - should not be allowed!
    function DummyClass:DoSomething(data, string) end

    assert(lib:GetNumErrors() == 1);
    lib:FlushErrorLog();
    lib:SetSilentErrors(false);

    local dummyInstance = DummyClass();
    dummyInstance:DoSomething("redefined");

    print("Interfaces_Test3 Successful!");
end

function DefineParams_Test2()
	print("DefineParams_Test2 Started");

    local TestPackage = lib:CreatePackage("DefineParams_Test2");

    local IHandler = TestPackage:CreateInterface("IHandler");

    TestPackage:DefineReturns("string");
    function IHandler:Run() end

    local OnClickHandler = TestPackage:CreateClass("OnClickHandler", nil, IHandler);

    function OnClickHandler:Run()
        return "Success!";
    end

    local CheckButton = TestPackage:CreateClass("CheckButton");

    TestPackage:DefineParams("IHandler");
    function CheckButton:Execute(data, handler)        
        return handler:Run();
    end

    local onclick = OnClickHandler();
    local cb = CheckButton();
    assert(cb:Execute(onclick) == "Success!");

	print("DefineParams_Test2 Successful!");
end

function Inheritance_Test2()
	print("Inheritance_Test2 Started");
    local TestPackage = lib:CreatePackage("Inheritance_Test2");

    local IInterface = TestPackage:CreateInterface("IInterface");

    TestPackage:DefineParams("string");
    TestPackage:DefineReturns("number");
    function IInterface:Run() end

    local SuperParent = TestPackage:CreateClass("SuperParent", nil, IInterface);

    function SuperParent:Run(data, str)
        return 123;
    end

    local Parent = TestPackage:CreateClass("Parent", SuperParent);
    local Child = TestPackage:CreateClass("Child", Parent);
    local SuperChild = TestPackage:CreateClass("SuperChild", Child);

    local instance = SuperChild();
    instance:Run("hello");

	print("Inheritance_Test2 Successful!");
end

function UsingParent_Test1()
	print("UsingParent_Test1 Started");
    local TestPackage = lib:CreatePackage("UsingParent_Test1");

    local SuperParent = TestPackage:CreateClass("SuperParent");
    local Parent = TestPackage:CreateClass("Parent", SuperParent);
    local Child = TestPackage:CreateClass("Child", Parent);
    local SuperChild = TestPackage:CreateClass("SuperChild", Child);

    function SuperParent:Print(data)
        --assert(data.origin == "SuperChild");
        return "This is SuperParent!";
    end

    function Parent:Print(data)
        return "This is Parent!";
    end

    function Child:Print(data)
        return "This is Child!";
    end

    function SuperChild:Print(data)
        return "This is SuperChild!";
    end

    function SuperChild:__Construct(data)
        data.origin = "SuperChild";
    end

    local instance = SuperChild();
    instance:Parent():Parent():Parent():Print();

    assert(instance:Print() == "This is SuperChild!");
    assert(instance:Parent():Print() == "This is Child!");
    assert(instance:Parent():Parent():Print() == "This is Parent!");
    assert(instance:Parent():Parent():Parent():Print() == "This is SuperParent!");

    -- print(SuperChild:Print()) -- fails as expected

	print("UsingParent_Test1 Successful!");
end

function SubPackages_Test1()
    print("SubPackages_Test1 Started");
    
    local ParentPackage = lib:CreatePackage("ParentPackage");
    local ChildPackage = lib:CreatePackage("ChildPackage");

    ParentPackage:AddSubPackage(ChildPackage);

	print("SubPackages_Test1 Successful!");
end


function List_Test1()
	print("List_Test1 Started");
    local Collections = lib:Import("Framework.Collections");

    local List = Collections:Get("List");

    local list1 = List(1, 2, 3, 4);

    --list1:ForEach(function(_, value) print(value) end);

    list1:Add(200);
    list1:AddAll(100, 300, 300, 500);
    list1:Remove(1);

    list1:RemoveByValue(300);
    assert(list1:Contains(300));

    list1:RemoveByValue(300, true);
    assert(not list1:Contains(300));

    assert(not list1:IsEmpty());
    assert(list1:Size() == 6);

    list1:Empty();

    assert(list1:IsEmpty());
    assert(list1:Size() == 0);

    print("List_Test1 Successful!");
end

function Map_Test1()
	print("Map_Test1 Started");
    local Map = lib:Import("Framework.Collections.Map");

    local map1 = Map({
        ["Warrior"] = 1,
        ["Shaman"] = 2,
        ["Rogue"] = 2,
        ["Warlock"] = 4,
    });

    --map1:ForEach(function(_, value) print(value) end);

    map1:Add("Druid", 5);
    map1:AddAll({
        ["Priest"] = 6,
        ["DeathKnight"] = 7,
        ["Monk"] = 8
    });

    map1:Remove("Warrior");

    map1:RemoveByValue(2);
    assert(not map1:Contains("Rogue"));
    assert(not map1:Contains("Shaman"));

    assert(not map1:IsEmpty());
    assert(map1:Size() == 5);

    local list1 = map1:GetKeyList();

    assert(list1:GetObjectType() == "List");
    assert(list1:Size() == 5);

    --list:ForEach(function(_, key) print(key) end);

    map1:Empty();
    assert(map1:IsEmpty());
    assert(map1:Size() == 0);

    print("Map_Test1 Successful!");
end

function DefineProperty_Test1()
    print("DefineProperty_Test1 Started");

    local TestPackage = lib:CreatePackage("DefineProperty_Test1", "Test");

    local IDummyClass = TestPackage:CreateInterface("IDummyClass");
    IDummyClass:DefineProperty("MyBoolean", "boolean");

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyClass);

    function DummyClass:__Construct(data)
        -- must define boolean property:
        self.MyBoolean = true;
    end

    local dummyClassInstance = DummyClass();

    print("DefineProperty_Test1 Successful!");
end

function DefineProperty_Test2()
    print("DefineProperty_Test2 Started");

    local TestPackage = lib:CreatePackage("DefineProperty_Test2", "Test");

    local IDummyClass = TestPackage:CreateInterface("IDummyClass");
    IDummyClass:DefineProperty("MyBoolean", "boolean");

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyClass);

    lib:SetSilentErrors(true);
    local dummyClassInstance = DummyClass();

    assert(lib:GetNumErrors() == 1);
    lib:FlushErrorLog();
    lib:SetSilentErrors(false);    

    print("DefineProperty_Test2 Successful!");
end

function DefineProperty_Test3()
    print("DefineProperty_Test3 Started");

    local TestPackage = lib:CreatePackage("DefineProperty_Test3", "Test");

    local IDummyClass = TestPackage:CreateInterface("IDummyClass");
    IDummyClass:DefineProperty("MyBoolean", "boolean");

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyClass);

    function DummyClass:__Construct(data)
        -- must define boolean property:
        self.MyBoolean = "not a boolean!";
    end

    lib:SetSilentErrors(true);
    local dummyClassInstance = DummyClass();

    assert(lib:GetNumErrors() == 1);
    lib:FlushErrorLog();
    lib:SetSilentErrors(false);    

    print("DefineProperty_Test3 Successful!");
end

function DefineProperty_Test4()
    print("DefineProperty_Test4 Started");

    local TestPackage = lib:CreatePackage("DefineProperty_Test4", "Test");

    local IDummyClass = TestPackage:CreateInterface("IDummyClass");
    IDummyClass:DefineProperty("MyBoolean", "?boolean");

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyClass);

    local dummyClassInstance = DummyClass(); 

    print("DefineProperty_Test4 Successful!");
end

function DefineProperty_Test5()
    print("DefineProperty_Test5 Started");

    local TestPackage = lib:CreatePackage("DefineProperty_Test5", "Test");

    local IDummyClass = TestPackage:CreateInterface("IDummyClass");
    IDummyClass:DefineProperty("MyBoolean", "?boolean");

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyClass);

    function DummyClass:__Construct(data)
        -- must define boolean property:
        self.MyBoolean = "not a boolean!";
    end

    lib:SetSilentErrors(true);
    local dummyClassInstance = DummyClass();

    assert(lib:GetNumErrors() == 1);
    lib:FlushErrorLog();
    lib:SetSilentErrors(false);    

    print("DefineProperty_Test5 Successful!");
end

function DefineProperty_Test6()
    print("DefineProperty_Test6 Started");

    local TestPackage = lib:CreatePackage("DefineProperty_Test6", "Test");

    local IDummyClass = TestPackage:CreateInterface("IDummyClass");
    IDummyClass:DefineProperty("MyBoolean", "boolean");

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyClass);

    function DummyClass:__Construct(data)
        self.MyBoolean = true;
    end

    lib:SetSilentErrors(true);
    local dummyClassInstance = DummyClass();

    dummyClassInstance.MyBoolean = "not a boolean!";

    assert(lib:GetNumErrors() == 1);
    lib:FlushErrorLog();
    lib:SetSilentErrors(false);    

    print("DefineProperty_Test6 Successful!");
end

function GenericClasses_Test1()
    print("GenericClasses_Test1 Started");

    local TestPackage = lib:CreatePackage("GenericClasses_Test1", "Test");

    local KeyValuePair = TestPackage:CreateClass("KeyValuePair<K, V>");

    TestPackage:DefineParams("K", "V");
    function KeyValuePair:Add(data, key, value)
    end

    local dummyClassInstance = KeyValuePair:Of("string", "number")(); 
    dummyClassInstance:Add("testKey", 123);

    print("GenericClasses_Test1 Successful!");
end

function GenericClasses_Test2()
    print("GenericClasses_Test2 Started");

    local TestPackage = lib:CreatePackage("GenericClasses_Test2", "Test");

    local KeyValuePair = TestPackage:CreateClass("KeyValuePair<K, V>");

    TestPackage:DefineParams("K", "V");
    function KeyValuePair:Add(data, key, value)
    end

    local dummyClassInstance = KeyValuePair:Of("string", "number")(); 

    lib:SetSilentErrors(true);

    -- passing string but expected a number!
    dummyClassInstance:Add("testKey", "123");

    assert(lib:GetNumErrors() == 1);
    lib:FlushErrorLog();
    lib:SetSilentErrors(false);

    print("GenericClasses_Test2 Successful!");
end

function GenericClasses_Test3()
    print("GenericClasses_Test3 Started");

    local TestPackage = lib:CreatePackage("GenericClasses_Test3", "Test");

    local KeyValuePair = TestPackage:CreateClass("KeyValuePair<K, V>");

    TestPackage:DefineParams("K", "V");
    function KeyValuePair:Add(data, key, value)
    end

    local dummyClassInstance = KeyValuePair(); 

    -- treats K and V as "any"
    dummyClassInstance:Add("testKey", "123");

    print("GenericClasses_Test3 Successful!");
end

function GenericClasses_Test4()
    print("GenericClasses_Test4 Started");

    local TestPackage = lib:CreatePackage("GenericClasses_Test4", "Test");

    local KeyValuePair = TestPackage:CreateClass("KeyValuePair<K, V>");

    TestPackage:DefineParams("K", "?V");
    function KeyValuePair:Add(data, key, value)
    end

    local dummyClassInstance = KeyValuePair(); 

    -- treats K and V as "any"
    dummyClassInstance:Add("testKey");

    print("GenericClasses_Test4 Successful!");
end

function Get_DefinedProperty_After_Setting_Test1() 
    print("Get_DefinedProperty_After_Setting_Test1 Started");

    local TestPackage = lib:CreatePackage("Get_DefinedProperty_After_Setting_Test1", "Test");
	
    local IDummyClass = TestPackage:CreateInterface("IDummyClass");
    IDummyClass:DefineProperty("MyString", "string");
	
    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyClass);

    function DummyClass:__Construct(data)
        self.MyString = "test value";
		
		local value = self.MyString;		
		assert(value == "test value");
    end

    local dummyClassInstance = DummyClass();  
	assert(dummyClassInstance.MyString == "test value");

    print("Get_DefinedProperty_After_Setting_Test1 Successful!");
end

function GetObjectType_In_Constructor_Test1() 
    print("GetObjectType_In_Constructor_Test1 Started");

    local TestPackage = lib:CreatePackage("GetObjectType_In_Constructor_Test1", "Test");	
    local DummyClass = TestPackage:CreateClass("DummyClass");

    function DummyClass:__Construct(data)
        self.MyString = "test value";
		local objType = self:GetObjectType();		
		assert(objType == "DummyClass");
    end

    local dummyClassInstance = DummyClass();  

    print("GetObjectType_In_Constructor_Test1 Successful!");
end

---------------------------------
-- Run Tests:
---------------------------------
-- HelloWorld_Test1();
-- Inheritance_Test1();
-- DefineParams_Test1();
-- DefineReturns_Test1();
-- ImportPackage_Test1();
-- DuplicateClass_Test1();
-- Interfaces_Test1();
-- Interfaces_Test2();
-- Interfaces_Test3();
-- DefineParams_Test2();
-- Inheritance_Test2();
-- UsingParent_Test1();
-- SubPackages_Test1();
-- DefineProperty_Test1();
-- DefineProperty_Test2();
-- DefineProperty_Test3();
-- DefineProperty_Test4();
-- DefineProperty_Test5();
-- DefineProperty_Test6();
-- GenericClasses_Test1();
-- GenericClasses_Test2();
-- GenericClasses_Test3();
-- GenericClasses_Test4();
-- Get_DefinedProperty_After_Setting_Test1();
-- GetObjectType_In_Constructor_Test1();