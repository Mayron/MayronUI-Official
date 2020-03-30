-- luacheck: ignore self 143 631
local lib = _G.LibStub:GetLibrary("LibMayronObjects");

local function VerifyExpectedErrors(expectedErrors, test)
    lib:SetSilentErrors(true);

    test();

    assert(lib:GetNumErrors() == expectedErrors, string.format(
        "Should throw %s errors but got %d", expectedErrors, lib:GetNumErrors()));

    lib:FlushErrorLog();
    lib:SetSilentErrors(false);
end

local function HelloWorld_Test1() -- luacheck: ignore
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

    function HelloWorld:__Destruct()
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

local function DefineParams_Test1() -- luacheck: ignore
    print("DefineParams_Test1 Started");

    local TestPackage = lib:CreatePackage("DefineParams_Test1", "Test");

    local Player = TestPackage:CreateClass("Player");

    TestPackage:DefineParams("string", "?number");
    function Player:GetSpellCasting(_, str, num)
        print("str: "..tostring(str)..", num: ", num);
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

local function DefineReturns_Test1() -- luacheck: ignore
    print("DefineReturns_Test1 Started");

    local TestPackage = lib:CreatePackage("DefineReturns_Test1", "Test");

    local Player = TestPackage:CreateClass("Player");

    TestPackage:DefineReturns("string", "?number");
    function Player:Func1()
        return "Success!";
    end

    TestPackage:DefineReturns("string", "?number");
    function Player:Func2()
        return "Success!", 123;
    end

    TestPackage:DefineReturns("string", "?number");
    function Player:Func3()
        return 123;
    end

    TestPackage:DefineReturns("string", "?number");
    function Player:Func4()
        return "Fail", "123";
    end

    local p = Player();

    p:Func1();
    p:Func2();

    VerifyExpectedErrors(2, function()
        p:Func3(); -- should fail!
        p:Func4(); -- should fail!
    end);

    print("DefineReturns_Test1 Successful!");
end

local function DefineParams_Test2() -- luacheck: ignore
	print("DefineParams_Test2 Started");

    local TestPackage = lib:CreatePackage("DefineParams_Test2");

    local IHandler = TestPackage:CreateInterface("IHandler", {
        Run = {type = "function"; returns = "string"};
    });

    local OnClickHandler = TestPackage:CreateClass("OnClickHandler", nil, IHandler);

    function OnClickHandler:Run()
        return "Success!";
    end

    local CheckButton = TestPackage:CreateClass("CheckButton");

    TestPackage:DefineParams("IHandler");
    function CheckButton:Execute(_, handler)
        return handler:Run();
    end

    local onclick = OnClickHandler();
    local cb = CheckButton();
    assert(cb:Execute(onclick) == "Success!");

	print("DefineParams_Test2 Successful!");
end

local function ImportPackage_Test1() -- luacheck: ignore
    print("ImportPackage_Test1 Started");

    local TestPackage = lib:CreatePackage("ImportPackage_Test1");
    lib:Export(TestPackage, "Test"); -- same as: lib:CreatePackage("ImportPackage_Test1", "Test");

    local CheckButton   = TestPackage:CreateClass("CheckButton");
    local Button        = TestPackage:CreateClass("Button"); -- luacheck: ignore
    local Slider        = TestPackage:CreateClass("Slider"); -- luacheck: ignore
    local TextArea      = TestPackage:CreateClass("TextArea"); -- luacheck: ignore
    local FontString    = TestPackage:CreateClass("FontString"); -- luacheck: ignore
    local Animator      = TestPackage:CreateClass("Animator"); -- luacheck: ignore

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

local function DuplicateClass_Test1() -- luacheck: ignore
    print("DuplicateClass_Test1 Started");

    local TestPackage = lib:CreatePackage("DuplicateClass_Test1");

    lib:SetSilentErrors(true);

    TestPackage:CreateClass("Player");
    TestPackage:CreateClass("Player");

    assert(lib:GetNumErrors() == 1);
    lib:FlushErrorLog();
    lib:SetSilentErrors(false);

    print("DuplicateClass_Test1 Successful!");
end

local function Interfaces_Test1() -- luacheck: ignore
    print("Interfaces_Test1 Started");

    local TestPackage = lib:CreatePackage("Interfaces_Test1");

    local IComparable = TestPackage:CreateInterface("IComparable", {
        Compare = {
            type = "function";
            params = {"number", "number"};
            returns = {"boolean"};
        }
    });

    local Item = TestPackage:CreateClass("Item", nil, IComparable);

    function Item:Compare(_, a, b)
        return a < b;
    end

    local item1 = Item();
    assert(item1:Compare(19, 20));

    assert(item1:GetObjectType() == "Item");
    assert(item1:IsObjectType("Item"));
    assert(item1:IsObjectType("IComparable"));

    print("Interfaces_Test1 Successful!");
end

local function Interfaces_Test2() -- luacheck: ignore
    print("Interfaces_Test2 Started");

    local TestPackage = lib:CreatePackage("Interfaces_Test2");

    local ICell = TestPackage:CreateInterface("ICell", {
        Create = {
            type = "function";
            params = {"number"};
        };
        Update = "function";
        Destroy = "function";
    });

    local Panel = TestPackage:CreateClass("Panel", nil, ICell);

    function Panel:Create() end

    function Panel:Destroy() end

    function Panel:Update() end

    local p = Panel();
    p:Create(12);

    -- should be able to execute interface functions with no definition!
    p:Update();
    p:Destroy();

    print("Interfaces_Test2 Successful!");
end

local function Interfaces_Test3() -- luacheck: ignore
    print("Interfaces_Test3 Started");

    local TestPackage = lib:CreatePackage("Interfaces_Test3");

    local IDummyInterface = TestPackage:CreateInterface("IDummyInterface", {
        DoSomething = {
            type = "function";
            params = {"number"};
        };
    });

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyInterface);

    VerifyExpectedErrors(1, function()
        TestPackage:DefineParams("string"); -- attempt to redefine - should not be allowed! (Not working!)
        function DummyClass:DoSomething() end
    end);

    local dummyInstance = DummyClass();

    VerifyExpectedErrors(1, function()
        dummyInstance:DoSomething("redefined"); -- still using interface definition
    end);

    print("Interfaces_Test3 Successful!");
end

local function NotImplementedInterfaceFunction_Test1() -- luacheck: ignore
    print("NotImplementedInterfaceFunction_Test1 Started");

    local TestPackage = lib:CreatePackage("NotImplementedInterfaceFunction_Test1");

    local IDummyInterface = TestPackage:CreateInterface("IDummyInterface", {
        DoSomething = "function";
    });

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyInterface);

    VerifyExpectedErrors(1, function()
        DummyClass(); -- has no implementation for "DoSomething" so should fail!
    end);

    print("NotImplementedInterfaceFunction_Test1 Successful!");
end

local function NotImplementedInterfaceProperty_Test1() -- luacheck: ignore
    print("NotImplementedInterfaceProperty_Test1 Started");

    local TestPackage = lib:CreatePackage("NotImplementedInterfaceProperty_Test1");

    local IDummyInterface = TestPackage:CreateInterface("IDummyInterface", {
        MyNumber = "number";
    });

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyInterface);

    VerifyExpectedErrors(1, function()
        DummyClass(); -- has not implemented property "MyNumber", should throw error!
    end);

    print("NotImplementedInterfaceProperty_Test1 Successful!");
end

local function NotImplementedInterfaceProperty_Test2() -- luacheck: ignore
    print("NotImplementedInterfaceProperty_Test2 Started");

    local TestPackage = lib:CreatePackage("NotImplementedInterfaceProperty_Test2");

    local IDummyInterface = TestPackage:CreateInterface("IDummyInterface", {
        MyNumber = "number";
    });

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyInterface);

    function DummyClass:__Construct()
    end

    VerifyExpectedErrors(1, function()
        DummyClass(); -- has not implemented property "MyNumber", should throw error!
    end);

    print("NotImplementedInterfaceProperty_Test2 Successful!");
end

local function NotImplementedInterfaceProperty_Test3() -- luacheck: ignore
    print("NotImplementedInterfaceProperty_Test3 Started");

    local TestPackage = lib:CreatePackage("NotImplementedInterfaceProperty_Test3");

    local IDummyInterface = TestPackage:CreateInterface("IDummyInterface", {
        MyNumber = "number";
    });

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyInterface);

    function DummyClass:__Construct()
        self.MyNumber = 123;
    end

    local instance = DummyClass();
    VerifyExpectedErrors(1, function()
        instance.MyNumber = "abc"; -- this is not a number, should throw error!
    end);

    print("NotImplementedInterfaceProperty_Test3 Successful!");
end

local function Inheritance_Test1() -- luacheck: ignore
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

    lib:SetDebugMode(true);
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

local function Inheritance_Test2() -- luacheck: ignore
	print("Inheritance_Test2 Started");
    local TestPackage = lib:CreatePackage("Inheritance_Test2");

    local IInterface = TestPackage:CreateInterface("IInterface", {
        Run = {
            type = "function";
            params = {"string"};
            returns = {"number"};
        }
    });

    local SuperParent = TestPackage:CreateClass("SuperParent", nil, IInterface);

    function SuperParent:Run()
        return 123;
    end

    local Parent = TestPackage:CreateClass("Parent", SuperParent);
    local Child = TestPackage:CreateClass("Child", Parent);
    local SuperChild = TestPackage:CreateClass("SuperChild", Child);

    local instance = SuperChild();
    local value = instance:Run("hello");

    assert(value == 123, "Value does not equal 123");

	print("Inheritance_Test2 Successful!");
end

local function Inheritance_Test3() -- luacheck: ignore
	print("Inheritance_Test3 Started");
    local TestPackage = lib:CreatePackage("Inheritance_Test3");

    local Parent = TestPackage:CreateClass("Parent");

    TestPackage:DefineParams("string");
    TestPackage:DefineReturns("number");
    function Parent:Run()
        return "hello";
    end

    local Child = TestPackage:CreateClass("Child", Parent);

    VerifyExpectedErrors(2, function()
        local instance = Child();
        instance:Run(123); -- passing a string instead of a number
    end);

	print("Inheritance_Test3 Successful!");
end

local function Inheritance_Test4() -- luacheck: ignore
	print("Inheritance_Test4 Started");
    local TestPackage = lib:CreatePackage("Inheritance_Test4");

    local IInterface = TestPackage:CreateInterface("IInterface", {
        Run = {
            type = "function";
            params = {"string"};
            returns = {"number"};
        }
    });

    local SuperParent = TestPackage:CreateClass("SuperParent", nil, IInterface);

    function SuperParent:Run()
        return "hello";
    end

    local Parent = TestPackage:CreateClass("Parent", SuperParent);
    local Child = TestPackage:CreateClass("Child", Parent);
    local SuperChild = TestPackage:CreateClass("SuperChild", Child);

    VerifyExpectedErrors(2, function()
        local instance = SuperChild();
        instance:Run(123);
    end);

	print("Inheritance_Test4 Successful!");
end

local function Inheritance_Test5() -- luacheck: ignore
	print("Inheritance_Test5 Started");
    local TestPackage = lib:CreatePackage("Inheritance_Test5");

    local Parent = TestPackage:CreateClass("Parent");

    TestPackage:DefineParams("string");
    TestPackage:DefineReturns("number");
    function Parent:Run()
        return "hello";
    end

    local Child = TestPackage:CreateClass("Child", Parent);
    local SubChild = TestPackage:CreateClass("SubChild", Child);

    VerifyExpectedErrors(2, function()
        local instance = SubChild();
        instance:Run(123);
    end);

	print("Inheritance_Test5 Successful!");
end

local function Inheritance_Test6() -- luacheck: ignore
	print("Inheritance_Test6 Started");
    local TestPackage = lib:CreatePackage("Inheritance_Test6");
    local Parent = TestPackage:CreateClass("Parent");
    local allExecuted = 0;

    TestPackage:DefineParams("string", "table", "number");
    function Parent:__Construct(data, strValue, tblValue, numValue)
        assert(data.subClassMessage == "successful");
        assert(strValue == "test");
        assert(tblValue.value == "test");
        assert(numValue == 123);
        allExecuted = allExecuted + 1;
    end

    local Child = TestPackage:CreateClass("Child", Parent);
    local SubChild = TestPackage:CreateClass("SubChild", Child);

    TestPackage:DefineParams("string", "table");
    function Child:__Construct(_, strValue, tblValue)
        self:Super(strValue, tblValue, 123); -- same reference, so it will call SubClass
        allExecuted = allExecuted + 1;
    end

    TestPackage:DefineParams("string");
    function SubChild:__Construct(data, strValue)
        data.subClassMessage = "successful";
        self:Super(strValue, {value = strValue});
        allExecuted = allExecuted + 1;
    end

    SubChild("test");
    assert(allExecuted == 3);

	print("Inheritance_Test6 Successful!");
end

local function UsingParent_Test1() -- luacheck: ignore
	print("UsingParent_Test1 Started");
    local TestPackage = lib:CreatePackage("UsingParent_Test1");

    local SuperParent = TestPackage:CreateClass("SuperParent");
    local Parent = TestPackage:CreateClass("Parent", SuperParent);
    local Child = TestPackage:CreateClass("Child", Parent);
    local SuperChild = TestPackage:CreateClass("SuperChild", Child);

    function SuperParent:Print(data)
        -- print("SuperParent");
        assert(data.origin == "SuperChild");
        return "This is SuperParent!";
    end

    -- TestPackage:DefineVirtual();
    function Parent:Print(data)
        -- print("Parent");
        assert(data.origin == "SuperChild");
        return "This is Parent!";
    end

    function Child:Print(data)
        -- print("Child");
        assert(data.origin == "SuperChild");
        return "This is Child!";
    end

    function SuperChild:Print(data)
        -- print("SuperChild");
        assert(data.origin == "SuperChild");
        return "This is SuperChild!";
    end

    function SuperChild:__Construct(data)
        data.origin = "SuperChild";
    end

    local superChild = SuperChild();
    local actualMessage = superChild:Print();

    assert(actualMessage == "This is SuperChild!",
        string.format("'This is SuperChild!' expected but got '%s'", actualMessage));

    actualMessage = superChild.Parent:Print();

    assert(actualMessage == "This is Child!",
        string.format("'This is Child!' expected but got '%s'", actualMessage));

    actualMessage = superChild.Parent.Parent:Print();

    assert(actualMessage == "This is Parent!",
        string.format("'This is Parent!' expected but got '%s'", actualMessage));

    actualMessage = superChild.Parent.Parent.Parent:Print();

    assert(actualMessage == "This is SuperParent!",
        string.format("'This is SuperParent!' expected but got '%s'", actualMessage));

    -- print(SuperChild:Print()) -- fails as expected

	print("UsingParent_Test1 Successful!");
end

local function UsingParent_Test2() -- luacheck: ignore
	print("UsingParent_Test2 Started");
    local TestPackage = lib:CreatePackage("UsingParent_Test2");

    local SuperParent = TestPackage:CreateClass("SuperParent");
    local Parent = TestPackage:CreateClass("Parent", SuperParent);
    local Child = TestPackage:CreateClass("Child", Parent);
    local SuperChild = TestPackage:CreateClass("SuperChild", Child);
    local totalCalled = 0;

    TestPackage:DefineParams("string")
    function SuperParent:Print(data, message, num)
        message = "SuperParent --> "..message;
        assert(message == "SuperParent --> Parent --> Child --> SuperChild --> Success!");
        assert(num == nil);
        assert(data.origin == "SuperChild");
        totalCalled = totalCalled + 1;
    end

    TestPackage:DefineParams("string")
    function Parent:Print(data, message, num)
        assert(num == nil);
        assert(data.origin == "SuperChild");
        totalCalled = totalCalled + 1;
        self.Parent:Print("Parent --> "..message);
    end

    TestPackage:DefineParams("string", "number")
    function Child:Print(data, message, num)
        assert(num == 5);
        assert(data.origin == "SuperChild");
        totalCalled = totalCalled + 1;

        -- should use parent definitions
        self.Parent:Print("Child --> "..message); -- TODO: Should have a default UseParentScope based on current scope
    end

    TestPackage:DefineParams("string", "number")
    function SuperChild:Print(data, message, num)
        assert(data.origin == "SuperChild");
        totalCalled = totalCalled + 1;
        self.Parent:Print("SuperChild --> "..message, num + 3); -- TODO ERROR!!
    end

    function SuperChild:__Construct(data)
        data.origin = "SuperChild";
    end

    local superChild = SuperChild();
    superChild:Print("Success!", 2);
    assert(totalCalled == 4, string.format("Not all methods were called!: %d", totalCalled));

	print("UsingParent_Test2 Successful!");
end

local function UsingParent_Test3() -- luacheck: ignore
	print("UsingParent_Test3 Started");
    local TestPackage = lib:CreatePackage("UsingParent_Test3");

    local SuperParent = TestPackage:CreateClass("SuperParent");
    local Parent = TestPackage:CreateClass("Parent", SuperParent);
    local Child = TestPackage:CreateClass("Child", Parent);
    local SuperChild = TestPackage:CreateClass("SuperChild", Child);
    local totalCalled = 0;

    TestPackage:DefineParams("string")
    function SuperParent:Print(data, message, num)
        message = "SuperParent --> "..message;
        assert(message == "SuperParent --> Parent --> Child --> SuperChild --> Success!");
        assert(num == nil);
        assert(data.origin == "SuperChild");
        totalCalled = totalCalled + 1;
    end

    function Parent:Print(data, message, num)
        self.Parent:Print("Parent --> "..message);
        assert(num == nil);
        assert(data.origin == "SuperChild");
        totalCalled = totalCalled + 1;
    end

    function Child:Print(data, message, num)
        assert(num == 5);
        self.Parent:Print("Child --> "..message);
        assert(data.origin == "SuperChild");
        totalCalled = totalCalled + 1;
    end

    function SuperChild:Print(data, message, num)
        self.Parent:Print("SuperChild --> "..message, num + 3);
        assert(data.origin == "SuperChild");
        totalCalled = totalCalled + 1;
    end

    function SuperChild:__Construct(data)
        data.origin = "SuperChild";
    end

    local superChild = SuperChild();
    superChild:Print("Success!", 2);
    assert(totalCalled == 4, string.format("Not all methods were called!: %d", totalCalled));

	print("UsingParent_Test3 Successful!");
end

local function UsingParentWithVirtualFunction_Test4() -- luacheck: ignore
	print("UsingParentWithVirtualFunction_Test4 Started");
    local TestPackage = lib:CreatePackage("UsingParentWithVirtualFunction_Test4");
    local Parent = TestPackage:CreateClass("Parent");
    local Child = TestPackage:CreateClass("Child", Parent);
    local called = false;

    local expectedString;

    TestPackage:DefineVirtual();
    TestPackage:DefineParams("string");
    function Parent:CallMe(_, _)
        error("Parent.CallMe should NOT be called!");
    end

    function Parent:Execute(data)
        local actualString = tostring(self);

        assert(expectedString == actualString,
            string.format("Expected %s but got %s", expectedString, actualString));

        self:CallMe(123); -- should call the child CallMe function with the child definition
        assert(data.value == 123);
    end

    TestPackage:DefineParams("number");
    function Child:CallMe(data, num)
        data.value = num;
        called = true;
    end

    function Child:Execute(data)
        self.Parent:Execute();
        assert(data.value == 123);
    end

    local child = Child();
    expectedString = tostring(child);

    child:Execute();

    assert(called == true, "Child:CallMe was never called!");

	print("UsingParentWithVirtualFunction_Test4 Successful!");
end

local function SubPackages_Test1() -- luacheck: ignore
    print("SubPackages_Test1 Started");

    local ParentPackage = lib:CreatePackage("ParentPackage");
    local ChildPackage = lib:CreatePackage("ChildPackage");

    ParentPackage:AddSubPackage(ChildPackage);

	print("SubPackages_Test1 Successful!");
end


local function List_Test1() -- luacheck: ignore
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

local function Map_Test1() -- luacheck: ignore
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

local function DefineProperty_Test1() -- luacheck: ignore
    print("DefineProperty_Test1 Started");

    local TestPackage = lib:CreatePackage("DefineProperty_Test1", "Test");

    local IDummyClass = TestPackage:CreateInterface("IDummyClass", {
        MyBoolean = "boolean";
    });

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyClass);

    function DummyClass:__Construct()
        -- must define boolean property:
        self.MyBoolean = true;
    end

    local _ = DummyClass();

    print("DefineProperty_Test1 Successful!");
end

local function DefineProperty_Test2() -- luacheck: ignore
    print("DefineProperty_Test2 Started");

    local TestPackage = lib:CreatePackage("DefineProperty_Test2", "Test");

    local IDummyClass = TestPackage:CreateInterface("IDummyClass", {
        MyBoolean = "boolean";
    });

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyClass);

    lib:SetSilentErrors(true);
    local _ = DummyClass();

    assert(lib:GetNumErrors() == 1);
    lib:FlushErrorLog();
    lib:SetSilentErrors(false);

    print("DefineProperty_Test2 Successful!");
end

local function DefineProperty_Test3() -- luacheck: ignore
    print("DefineProperty_Test3 Started");

    local TestPackage = lib:CreatePackage("DefineProperty_Test3", "Test");

    local IDummyClass = TestPackage:CreateInterface("IDummyClass", {
        MyBoolean = "boolean";
    });

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyClass);

    function DummyClass:__Construct()
        -- must define boolean property:
        self.MyBoolean = "not a boolean!";
    end

    lib:SetSilentErrors(true);
    local _ = DummyClass();

    assert(lib:GetNumErrors() == 1);
    lib:FlushErrorLog();
    lib:SetSilentErrors(false);

    print("DefineProperty_Test3 Successful!");
end

local function DefineProperty_Test4() -- luacheck: ignore
    print("DefineProperty_Test4 Started");

    local TestPackage = lib:CreatePackage("DefineProperty_Test4", "Test");

    local IDummyClass = TestPackage:CreateInterface("IDummyClass", {
        MyBoolean = "?boolean";
    });

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyClass);

    local _ = DummyClass();

    print("DefineProperty_Test4 Successful!");
end

local function DefineProperty_Test5() -- luacheck: ignore
    print("DefineProperty_Test5 Started");

    local TestPackage = lib:CreatePackage("DefineProperty_Test5", "Test");

    local IDummyClass = TestPackage:CreateInterface("IDummyClass", {
        MyBoolean = "?boolean";
    });

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyClass);

    function DummyClass:__Construct()
        -- must define boolean property:
        self.MyBoolean = "not a boolean!";
    end

    lib:SetSilentErrors(true);
    local _ = DummyClass();

    assert(lib:GetNumErrors() == 1);
    lib:FlushErrorLog();
    lib:SetSilentErrors(false);

    print("DefineProperty_Test5 Successful!");
end

local function DefineProperty_Test6() -- luacheck: ignore
    print("DefineProperty_Test6 Started");

    local TestPackage = lib:CreatePackage("DefineProperty_Test6", "Test");

    local IDummyClass = TestPackage:CreateInterface("IDummyClass", {
        MyBoolean = "boolean";
    });

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyClass);

    function DummyClass:__Construct()
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

local function Get_DefinedProperty_After_Setting_Test1() -- luacheck: ignore
    print("Get_DefinedProperty_After_Setting_Test1 Started");

    local TestPackage = lib:CreatePackage("Get_DefinedProperty_After_Setting_Test1", "Test");

    local IDummyClass = TestPackage:CreateInterface("IDummyClass", {
        MyString = "string";
    });

    local DummyClass = TestPackage:CreateClass("DummyClass", nil, IDummyClass);

    function DummyClass:__Construct()
        self.MyString = "test value";

		local value = self.MyString;
		assert(value == "test value");
    end

    local dummyClassInstance = DummyClass();
	assert(dummyClassInstance.MyString == "test value");

    print("Get_DefinedProperty_After_Setting_Test1 Successful!");
end

local function GenericClasses_Test1()  -- luacheck: ignore
    print("GenericClasses_Test1 Started");

    local TestPackage = lib:CreatePackage("GenericClasses_Test1", "Test");

    local KeyValuePair = TestPackage:CreateClass("KeyValuePair<K, V>");

    TestPackage:DefineParams("K", "V");
    function KeyValuePair:Add()
    end

    local dummyClassInstance = KeyValuePair:Of("string", "number")();
    dummyClassInstance:Add("testKey", 123);

    print("GenericClasses_Test1 Successful!");
end

local function GenericClasses_Test2() -- luacheck: ignore
    print("GenericClasses_Test2 Started");

    local TestPackage = lib:CreatePackage("GenericClasses_Test2", "Test");

    local KeyValuePair = TestPackage:CreateClass("KeyValuePair<K, V>");

    TestPackage:DefineParams("K", "V");
    function KeyValuePair:Add() end

    local dummyClassInstance = KeyValuePair:Of("string", "number")();

    lib:SetSilentErrors(true);

    -- passing string but expected a number!
    dummyClassInstance:Add("testKey", "123");

    assert(lib:GetNumErrors() == 1);
    lib:FlushErrorLog();
    lib:SetSilentErrors(false);

    print("GenericClasses_Test2 Successful!");
end

local function GenericClasses_Test3() -- luacheck: ignore
    print("GenericClasses_Test3 Started");

    local TestPackage = lib:CreatePackage("GenericClasses_Test3", "Test");

    local KeyValuePair = TestPackage:CreateClass("KeyValuePair<K, V>");

    TestPackage:DefineParams("K", "V");
    function KeyValuePair:Add() end

    local dummyClassInstance = KeyValuePair();

    -- treats K and V as "any"
    dummyClassInstance:Add("testKey", "123");

    print("GenericClasses_Test3 Successful!");
end

local function GenericClasses_Test4() -- luacheck: ignore
    print("GenericClasses_Test4 Started");

    local TestPackage = lib:CreatePackage("GenericClasses_Test4", "Test");

    local KeyValuePair = TestPackage:CreateClass("KeyValuePair<K, V>");

    TestPackage:DefineParams("K", "?V");
    function KeyValuePair:Add() end

    local dummyClassInstance = KeyValuePair();

    -- treats K and V as "any"
    dummyClassInstance:Add("testKey");

    print("GenericClasses_Test4 Successful!");
end

local function GetObjectType_In_Constructor_Test1() -- luacheck: ignore
    print("GetObjectType_In_Constructor_Test1 Started");

    local TestPackage = lib:CreatePackage("GetObjectType_In_Constructor_Test1", "Test");
    local DummyClass = TestPackage:CreateClass("DummyClass");

    function DummyClass:__Construct()
        self.MyString = "test value";
		local objType = self:GetObjectType();
		assert(objType == "DummyClass");
    end

    local _ = DummyClass();

    print("GetObjectType_In_Constructor_Test1 Successful!");
end

local function UsingMultipleDefinitionsForOneArgument_Test1() -- luacheck: ignore
    print("UsingMultipleDefinitionsForOneArgument_Test1 Started");

    local TestPackage = lib:CreatePackage("UsingMultipleDefinitionsForOneArgument_Test1");

    local TestClass = TestPackage:CreateClass("TestClass");

    TestPackage:DefineParams("string|number", "number");
    function TestClass:Run(_, value1, testNumber)
        if (testNumber == 1) then
            assert(type(value1) == "string");
        else
            assert(type(value1) == "number");
        end
    end

    local test = TestClass();

    test:Run("myString", 1);
    test:Run(123, 2);

    print("UsingMultipleDefinitionsForOneArgument_Test1 Successful!");
end

local function MemoryLeak_Test1() -- luacheck: ignore
    print("MemoryLeak_Test1 Started");

    local TestPackage = lib:CreatePackage("MemoryLeak_Test1");

    local TestClass = TestPackage:CreateClass("TestClass", "Framework.System.FrameWrapper");

    local frame = _G.CreateFrame("Frame");
    local testInstance = TestClass();
    testInstance:SetFrame(frame);

    _G.UpdateAddOnMemoryUsage();
    local before = _G.GetAddOnMemoryUsage("LibMayronObjects");

    -- local _ = testInstance.SetParent;

    for _ = 1, 500 do
        testInstance:SetParent(_G.UIParent);
        testInstance:ClearAllPoints();
        testInstance:SetPoint("TOPLEFT");
        testInstance:SetPoint("BOTTOMRIGHT");
        testInstance:SetShown(true);
        testInstance:SetShown(false);
        testInstance:ClearAllPoints();
    end

    _G.UpdateAddOnMemoryUsage();
    local after = _G.GetAddOnMemoryUsage("LibMayronObjects");
    local difference = after - before; -- there will always be some difference due to popping a table to collect return values

    assert(difference < 0.5, "difference: "..tostring(difference));

    print("MemoryLeak_Test1 Successful!");
end

local function MemoryLeak_Test2() -- luacheck: ignore
    print("MemoryLeak_Test2 Started");

    local TestPackage = lib:CreatePackage("MemoryLeak_Test2");

    local TestInterface = TestPackage:CreateInterface("TestInterface", {
        TestProperty = "number";
    })

    local TestClass = TestPackage:CreateClass("TestClass", nil, TestInterface);

    function TestClass:__Construct()
        self.TestProperty = 123;
    end

    local testInstance = TestClass();

    _G.UpdateAddOnMemoryUsage();
    local before = _G.GetAddOnMemoryUsage("LibMayronObjects");

    lib:SetDebugMode(true);

    for _ = 1, 500 do
        testInstance.TestProperty = testInstance.TestProperty + 1;
    end

    lib:SetDebugMode(false);

    _G.UpdateAddOnMemoryUsage();

    local after = _G.GetAddOnMemoryUsage("LibMayronObjects");
    local difference = after - before; -- there will always be some difference due to popping a table to collect return values

    print(difference);

    assert(difference == 0, "difference: "..tostring(difference));

    print("MemoryLeak_Test2 Successful!");
end

local function DefaultParams_Test1()
    print("DefaultParams_Test1 Started");
    local TestPackage = lib:CreatePackage("DefaultParams_Test1");
    local TestClass = TestPackage:CreateClass("TestClass");

    local defaultTable = {msg = "foobar"}

    TestPackage:DefineParams("string=foo bar", "number=14", {"string", "foo bar 2"}, {"number", 20}, {"table", defaultTable})
    function TestClass:AssertDefaults(_, arg1, arg2, arg3, arg4, arg5)
        assert(arg1 == "foo bar", string.format("arg1 expected to be 'foo bar', got %s", arg1));
        assert(arg2 == 14, string.format("arg2 expected to be 14, got %s", arg2));
        assert(arg3 == "foo bar 2", string.format("arg3 expected to be 'foo bar 2', got %s", arg3));
        assert(arg4 == 20, string.format("arg4 expected to be 20, got %s", arg4));
        assert(type(arg5) == "table", string.format("arg5 expected to be of type table, got %s", type(arg5)));
        assert(arg5.msg == "foobar", string.format("arg5.msg expected to be 'foobar', got %s", arg5.msg));
    end

    local testInstance = TestClass();
    testInstance:AssertDefaults();

    print("DefaultParams_Test1 Started");
end

local function DefaultParams_Test2()
    print("DefaultParams_Test2 Started");
    local TestPackage = lib:CreatePackage("DefaultParams_Test1");
    local TestClass = TestPackage:CreateClass("TestClass");

    local defaultTable = {msg = "foobar"}

    TestPackage:DefineParams("string=foo bar", {"string", "foo bar 2"}, {"number", 20}, "string", {"table", defaultTable})
    function TestClass:AssertDefaults(_, arg1, arg2, arg3, arg4, arg5)
        assert(arg1 == "new message", string.format("arg1 expected to be 'new message', got %s", arg1));
        assert(arg2 == "foo bar 2", string.format("arg2 expected to be 'foo bar 2', got %s", arg2));
        assert(arg3 == 45, string.format("arg3 expected to be 45, got %s", arg3));
        assert(arg4 == "hello", string.format("arg4 expected to be 'hello', got %s", arg4));
        assert(type(arg5) == "table", string.format("arg5 expected to be of type table, got %s", type(arg5)));
        assert(arg5.msg == "new message 2", string.format("arg5.msg expected to be 'new message 2', got %s", arg5.msg));
    end

    local testInstance = TestClass();

    testInstance:AssertDefaults("new message", nil, 45, "hello", {msg = "new message 2"});

    print("DefaultParams_Test2 Started");
end

---------------------------------
-- Run Tests:
---------------------------------

-- HelloWorld_Test1();
-- DefineParams_Test1();
-- DefineReturns_Test1();
-- DefineParams_Test2();
-- ImportPackage_Test1();
-- DuplicateClass_Test1();
-- UsingParent_Test1();
-- UsingParent_Test2();
-- UsingParent_Test3();
-- UsingParentWithVirtualFunction_Test4();
-- SubPackages_Test1();
-- Inheritance_Test1();
-- Inheritance_Test2();
-- Inheritance_Test3();
-- Inheritance_Test4();
-- Inheritance_Test5();
-- Inheritance_Test6();
-- Interfaces_Test1();
-- Interfaces_Test2();
-- Interfaces_Test3();
-- NotImplementedInterfaceFunction_Test1();
-- NotImplementedInterfaceProperty_Test1();
-- NotImplementedInterfaceProperty_Test2();
-- NotImplementedInterfaceProperty_Test3();
-- DefineProperty_Test1();
-- DefineProperty_Test2();
-- DefineProperty_Test3();
-- DefineProperty_Test4();
-- DefineProperty_Test5();
-- DefineProperty_Test6();
-- Get_DefinedProperty_After_Setting_Test1();
-- GenericClasses_Test1();
-- GenericClasses_Test2();
-- GenericClasses_Test3();
-- GenericClasses_Test4();
-- GetObjectType_In_Constructor_Test1();
-- UsingMultipleDefinitionsForOneArgument_Test1();
-- MemoryLeak_Test1();
-- MemoryLeak_Test2();
-- DefaultParams_Test1();
-- DefaultParams_Test2();