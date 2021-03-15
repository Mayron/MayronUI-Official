-- luacheck: ignore self 143 631
local _G = _G;
local obj = _G.MayronObjects:GetFramework(); ---@type MayronObjects

local Tests = setmetatable({__tests = {}}, {
  __newindex = function(self, key, value)
    -- preserve ordering of tests:
    self.__tests[#self.__tests + 1] = { testName = key, value = value };
    rawset(self, key, value);
  end
});

local Green, Yellow = _G.GREEN_FONT_COLOR, _G.YELLOW_FONT_COLOR;
local ipairs, print, strformat, assert = _G.ipairs, _G.print, _G.string.format, _G.assert;
local tostring, random, type = _G.tostring, _G.math.random, _G.type;
---------------------------------
--- Parent Classes / Mixins
---------------------------------
function Tests:Parent_Class_Mixins()
  local C_ParentClass = obj:CreateClass("ParentClass");
  local executeCount = 0;

  function C_ParentClass:Something(data)
    assert(data.success == "Test successful!");
    executeCount = executeCount + 1;
  end

  local C_TestClass = obj:CreateClass("TestClass", C_ParentClass);

  function C_TestClass:__Construct(data, arg1, arg2)
    data.success = true;
    assert(arg1 == "Hello");
    assert(arg2 == 123);
    executeCount = executeCount + 1;
  end

  obj:DefineParams("number");
  obj:DefineReturns("string");
  function C_TestClass:RunTest(data)
    assert(data.success == true);
    executeCount = executeCount + 1;
    data.success = "Test successful!";
    return "Ok";
  end

  local instance = C_TestClass("Hello", 123);
  local result = instance:RunTest(123);
  assert(result == "Ok");

  instance:Something();
  assert(executeCount == 3);
end

---------------------------------
--- Geneneric Classes
---------------------------------
function Tests:Generic_Classes()
  local C_TestClass = obj:CreateClass("TestClass<K, V>");

  obj:DefineParams("string")
  function C_TestClass:__Construct(_, value)
    assert(value == "this is my value");
  end

  obj:DefineParams("K", "V");
  obj:DefineReturns("V");
  function C_TestClass:RunTest(_, key, value)
    assert(key == "hello");
    assert(value == 123);
    return value;
  end

  local instance = C_TestClass:UsingTypes("string", "number")("this is my value");
  local result = instance:RunTest("hello", 123);
  assert(result == 123);
end

---------------------------------
--- Friend Classes
---------------------------------
function Tests:Friend_Classes()
  local C_SomeClass = obj:CreateClass("SomeClass");
  local C_FriendClass = obj:CreateClass("FriendClass");

  C_SomeClass.Static:AddFriendClass(C_FriendClass);

  function C_SomeClass:__Construct(data)
    data.secret = "hello";
  end

  local someInstance = C_SomeClass();

  function C_FriendClass:__Construct(data)
    local friendData = data:GetFriendData(someInstance);
    assert(friendData.secret == "hello");
  end

  C_FriendClass();
end

-------------------------------------
--- Private and Static Methods
-------------------------------------
function Tests:Private_And_Static_Method_Test()
  local C_TestClass = obj:CreateClass("TestClass");
  local executeCount = 0;

  obj:DefineParams("string", "number=99", "?table", "...number=12");
  function C_TestClass.Static:MyStaticMethod(arg1, arg2, arg3, arg4, arg5, arg6)
    assert(arg1 == "hello");
    assert(arg2 == 99);
    assert(arg3.test == "test");
    assert(arg4 == 12);
    assert(arg5 == 654);
    assert(arg6 == 12);
    executeCount = executeCount + 1;
  end

  obj:DefineParams("number", {type="string", default="hello world. How are we?"}, "...string");
  function C_TestClass.Private:MyPrivateMethod(data, arg1, arg2, arg3)
    assert(data.message == "success!");
    assert(arg1 == 10);
    assert(arg2 == "hello world. How are we?");
    assert(arg3 == "foobar");
    executeCount = executeCount + 1;
  end

  function C_TestClass:RunTest(data)
    data.message = "success!";
    data:Call("MyPrivateMethod", 10, nil, "foobar");

    self.Static:MyStaticMethod("hello", nil, {test="test"}, nil, 654, nil);
  end

  local instance = C_TestClass();
  instance:RunTest();
  assert(executeCount == 2);

  assert(C_TestClass.Private.MyPrivateMethod == nil);
  assert(obj:IsFunction(C_TestClass.Static.MyStaticMethod));
end

-------------------------------------
--- Exporting and Importing
-------------------------------------
function Tests:Exporting_And_Importing()
  local C_TestClass = obj:CreateClass("TestClass");
  assert(C_TestClass.Static:GetNamespace() == "TestClass");

  obj:Export(C_TestClass, "Pkg-TestPackage");
  assert(C_TestClass.Static:GetNamespace() == "Pkg-TestPackage.TestClass");

  local imported = obj:Import("Pkg-TestPackage.TestClass");

  assert(C_TestClass == imported);

  local package = obj:Import("Pkg-TestPackage");
  assert(C_TestClass == package.TestClass);
end

------------------------
--- Memory Leak Tests
------------------------
function Tests:Basic_Memory_Leak_Test()
  local C_TestClass = obj:CreateClass("TestClass");
  local tblValue = {};

  function C_TestClass:__Construct(data)
    data.obj = _G.CreateFrame("Frame");
  end

  obj:DefineParams("Frame");
  function C_TestClass:SetParent(data, parent)
    data.obj:SetParent(parent);
  end

  obj:DefineParams("number", {type="table", default={ message = "hello" }}, "...?number");
  obj:DefineReturns("number", "table", "...?number");
  function C_TestClass.Static:MyStaticMethod(value, tbl, ...)
    return value, tbl, ...;
  end

  obj:DefineParams("number", {type="table", default={ message = "hello" }}, "...?number");
  obj:DefineReturns("number", "table", "...?number");
  function C_TestClass.Private:MyPrivateMethod(_, value, tbl, ...)
    return value, tbl, ...;
  end

  function C_TestClass:ClearAllPoints(data)
    data:Call("MyPrivateMethod", self.Static:MyStaticMethod(12, tblValue, nil, 2, nil, 3));
    data.obj:ClearAllPoints();
  end

  obj:DefineParams("string=CENTER");
  function C_TestClass:SetPoint(data, point)
    data.obj:SetPoint(point);
  end

  obj:DefineParams("boolean=true");
  function C_TestClass:SetShown(data, shown)
    data.obj:SetShown(shown);
  end

  local testInstance = C_TestClass();

  _G.UpdateAddOnMemoryUsage();
  local before = _G.GetAddOnMemoryUsage("MayronObjects");

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
  local after = _G.GetAddOnMemoryUsage("MayronObjects");
  local difference = after - before;

  print("difference: ", difference);
  assert(difference < 0.5, "difference: "..tostring(difference));
end

function Tests:Memory_Leak_Test_With_FrameWrapper()
  local C_TestClass = obj:CreateClass("TestClass");

  local testInstance = C_TestClass();
  testInstance:SetFrame(_G.CreateFrame("Frame"));

  local bg = testInstance:CreateTexture(nil, "BACKGROUND");
  bg:SetAllPoints(true);
  bg:SetColorTexture(random(), random(), random());

  _G.UpdateAddOnMemoryUsage();
  local before = _G.GetAddOnMemoryUsage("MayronObjects");

  for _ = 1, 500 do
    testInstance:SetParent(_G.UIParent);
    testInstance:SetSize(300, 300);
    testInstance:ClearAllPoints();
    testInstance:SetPoint("CENTER");
    testInstance:SetShown(true);
    testInstance:SetShown(false);
    testInstance:SetShown(true);
    testInstance:ClearAllPoints();
  end

  testInstance:SetShown(false);

  _G.UpdateAddOnMemoryUsage();
  local after = _G.GetAddOnMemoryUsage("MayronObjects");
  local difference = after - before;

  print("difference: ", difference);
  assert(difference < 0.5, "difference: "..tostring(difference));
end

function Tests:Memory_Leak_With_Union_Types_And_Optional_Values()
  local C_TestClass = obj:CreateClass("TestClass");

  obj:DefineParams("number|boolean");
  function C_TestClass:RunTest()
  end

  local instance = C_TestClass();
  _G.UpdateAddOnMemoryUsage();
  local before = _G.GetAddOnMemoryUsage("MayronObjects");

  for _ = 1, 2000 do
    instance:RunTest(true);
  end

  _G.UpdateAddOnMemoryUsage();
  local after = _G.GetAddOnMemoryUsage("MayronObjects");
  local difference = after - before;

  print("difference: ", difference);
  assert(difference < 0.5, "difference: "..tostring(difference));
end

------------------------
--- Inheritance Test
------------------------
function Tests:Inheritance_Call_Parent_Method()
  local C_ParentClass = obj:CreateClass("ParentClass");

  local executedChild, executedParent;

  obj:DefineParams("number", "string");
  function C_ParentClass:Execute(data, num, value)
    assert(data.message == "Call_Parent_Method_Test");
    assert(num == 123);
    assert(value == "from child");
    executedParent = true;
  end

  local C_ChildClass = obj:CreateClass("ChildClass", C_ParentClass);

  obj:DefineParams("string");
  function C_ChildClass:Execute(data, value)
    data.message = "Call_Parent_Method_Test";
    assert(value == "directly to child");
    executedChild = true;
  end

  local instance = C_ChildClass();
  instance:Execute("directly to child");
  instance:CallParentMethod("Execute", 123, "from child");

  assert(executedChild)
  assert(executedParent)
end

function Tests:Inheritance_Call_Specific_Parent_Method()
  local executedChild, executedParent, executedSuperParent, executedSomeFunc;
  local C_SuperParentClass = obj:CreateClass("SuperParentClass");

  obj:DefineParams("number", "table");
  function C_SuperParentClass:Execute(data, num, tbl)
    assert(data.message == "Call_Parent_Method_Test");
    assert(num == 500);
    assert(tbl.value == "from child");
    executedSuperParent = true;

    assert(self:SomeFunc("from super parent") == 939);
  end

  local C_ParentClass = obj:CreateClass("ParentClass", C_SuperParentClass);

  obj:DefineParams("number", "string");
  function C_ParentClass:Execute(data, num, value)
    assert(data.message == "Call_Parent_Method_Test");
    assert(num == 123);
    assert(value == "from child");
    executedParent = true;
  end

  local C_ChildClass = obj:CreateClass("ChildClass", C_ParentClass);

  obj:DefineParams("string");
  function C_ChildClass:Execute(data, value)
    data.message = "Call_Parent_Method_Test";
    assert(value == "directly to child");
    executedChild = true;
  end

  obj:DefineParams("string");
  obj:DefineReturns("number");
  function C_ChildClass:SomeFunc(data, value)
    assert(value == "from super parent");
    assert(data.message == "Call_Parent_Method_Test");
    executedSomeFunc = true;
    return 939;
  end

  local instance = C_ChildClass();
  instance:Execute("directly to child");
  assert(executedChild);
  assert(not executedParent);
  assert(not executedSuperParent);
  assert(not executedSomeFunc);

  instance:CallParentMethod("Execute", 123, "from child");
  assert(executedParent);
  assert(not executedSuperParent);
  assert(not executedSomeFunc);

  instance:CallParentMethodByClassName("SuperParentClass", "Execute", 500, {value="from child"});
  assert(executedSuperParent);
  assert(executedSomeFunc);
end

function Tests:Using_ClassName_As_Definition()
  local C_TestClass = obj:CreateClass("TestClass");
  local C_ParentClass = obj:CreateClass("ParentClass");
  local C_OtherClass = obj:CreateClass("OtherClass", C_ParentClass);

  obj:DefineParams("TestClass");
  function C_OtherClass:StartTest(_, testInstance)
    testInstance:CallMe(self);
  end

  function C_OtherClass:FinishTest()
    print("test finished")
  end

  obj:DefineParams("ParentClass");
  function C_TestClass:CallMe(_, otherInstance)
    otherInstance:FinishTest();
  end

  local otherInstance = C_OtherClass();
  local testInstance = C_TestClass();
  otherInstance:StartTest(testInstance);
end

-------------------------------------
--- Default Argument Tests
-------------------------------------|
function Tests:Using_Default_Arguments_For_Private_Methods()
  local executeCount = 0;
  local C_TestClass = obj:CreateClass("TestClass");

  obj:DefineParams("string", "number=0", "number=1000");
  obj:DefineReturns("boolean");
  function C_TestClass.Private:MyPrivateMethod(_, text, minLength, maxLength)
    assert(text == "test", strformat("expected text to be 'test', got %s of type '%s'", tostring(text), type(text)));
    assert(minLength == 50, strformat("expected minLength to be 50 (number), got %s (%s)", tostring(minLength), type(minLength)));
    assert(maxLength == 1000, strformat("expected maxLength to be 1000 (number), got %s (%s)", tostring(maxLength), type(maxLength)));
    executeCount = executeCount + 1;
    return true;
  end

  function C_TestClass:StartTest(data)
    data:Call("MyPrivateMethod", "test", 50);
    executeCount = executeCount + 1;
  end

  local instance = C_TestClass();
  instance:StartTest();
  assert(executeCount == 2);
end

function Tests:Using_Default_Arguments_For_Private_Methods_After_Instance_Created()
  local executeCount = 0;
  local C_TestClass = obj:CreateClass("TestClass");
  local instance = C_TestClass();

  obj:DefineParams("string", "number=0", "number=1000");
  obj:DefineReturns("boolean");
  function C_TestClass.Private:MyPrivateMethod(_, text, minLength, maxLength)
    assert(text == "test");
    assert(minLength == 50);
    assert(maxLength == 1000);
    executeCount = executeCount + 1;
    return true;
  end

  function C_TestClass:StartTest(data)
    data:Call("MyPrivateMethod", "test", 50);
    executeCount = executeCount + 1;
  end

  instance:StartTest();
  assert(executeCount == 2);
end

-------------------------------------
--- Interface Tests
-------------------------------------
Tests.Interface = {};

function Tests.Interface:Interfaces_Test1() -- luacheck: ignore
  local IComparable = obj:CreateInterface("IComparable", {
    Compare = {
      type = "function";
      params = {"number", "number"};
      returns = {"boolean"};
    }
  });

  local C_Item = obj:CreateClass("Item"):Implements(IComparable);

  function C_Item:Compare(_, a, b)
    return a < b;
  end

  local item = C_Item();
  assert(item:Compare(19, 20));
  assert(item:GetObjectType() == "Item");
  assert(item:IsObjectType("Item"));
  assert(item:IsObjectType("IComparable"));
end

function Tests.Interface:Interfaces_Test2() -- luacheck: ignore
  local ICell = obj:CreateInterface("ICell", {
    Create = {
      type = "function";
      params = {"number"};
    };
    Update = "function";
    Destroy = "function";
  });

  local Panel = obj:CreateClass("Panel"):Implements(ICell);

  function Panel:Create() end
  function Panel:Destroy() end
  function Panel:Update() end

  local p = Panel();
  p:Create(12);
  p:Update();
  p:Destroy();
end

function Tests.Interface:RedefiningInterfaceProperties_Test3() -- luacheck: ignore
  local IDummyInterface = obj:CreateInterface("IDummyInterface", {
    DoSomething = {
      type = "function";
      params = {"number"};
    };
  });

  local DummyClass = obj:CreateClass("DummyClass"):Implements(IDummyInterface);

  assert(not pcall(function()
    obj:DefineParams("string"); -- attempt to redefine - should not be allowed! (Not working!)
    function DummyClass:DoSomething() end
  end));

  function DummyClass:DoSomething() end

  local dummyInstance = DummyClass();

  assert(not pcall(function()
    dummyInstance:DoSomething("redefined"); -- still using interface definition
  end));
end

function Tests.Interface:NotImplementedInterfaceFunction_Test1() -- luacheck: ignore
  local IDummyInterface = obj:CreateInterface("IDummyInterface", {
    DoSomething = "function";
  });

  local DummyClass = obj:CreateClass("DummyClass"):Implements(IDummyInterface);

  assert(not pcall(function()
    DummyClass(); -- has no implementation for "DoSomething" so should fail!
  end));
end

function Tests.Interface:NotImplementedInterfaceProperty_Test1() -- luacheck: ignore
  local IDummyInterface = obj:CreateInterface("IDummyInterface", {
    MyNumber = "number";
  });

  local DummyClass = obj:CreateClass("DummyClass"):Implements(IDummyInterface);

  assert(not pcall(function()
    DummyClass(); -- has not implemented property "MyNumber", should throw error!
  end));
end

function Tests.Interface:NotImplementedInterfaceProperty_Test2() -- luacheck: ignore
  local IDummyInterface = obj:CreateInterface("IDummyInterface", {
    MyNumber = "number";
  });

  local DummyClass = obj:CreateClass("DummyClass"):Implements(IDummyInterface);

  function DummyClass:__Construct() end

  assert(not pcall(function()
    DummyClass(); -- has not implemented property "MyNumber", should throw error!
  end));
end

function Tests.Interface:NotImplementedInterfaceProperty_Test3() -- luacheck: ignore
  local IDummyInterface = obj:CreateInterface("IDummyInterface", {
    MyNumber = "number";
  });

  local DummyClass = obj:CreateClass("DummyClass"):Implements(IDummyInterface);

  function DummyClass:__Construct()
    self.MyNumber = 123; -- should finish successfully
  end

  local instance = DummyClass();
  assert(not pcall(function()
    instance.MyNumber = "abc"; -- this is not a number, should throw error!
  end));
end

function Tests.Interface:DefaultInterfaceMethods()

  local function Execute(self, data, value)
    self:Print("Execute:", data.message, value);
    return "success";
  end

  local IDummyInterface = obj:CreateInterface("IDummyInterface", {
    Execute = {
      type = "function";
      params = {"number"};
      returns = {"string"};
      default = Execute;
    };
  });

  local DummyClass = obj:CreateClass("DummyClass"):Implements(IDummyInterface);

  function DummyClass:__Construct(data)
    data.message = "testing";
  end

  function DummyClass:Print(_, arg1, arg2, arg3)
    assert(arg1 == "Execute:");
    assert(arg2 == "testing");
    assert(arg3 == 123);
  end

  local instance = DummyClass();
  local success = instance:Execute(123);
  assert(success == "success"); -- this passes
end

function Tests.Interface:OverrideDefaultInterfaceMethods()
  local function Execute(self, data, value)
    self:Print("Execute:", data.message, value);
    return "success";
  end

  local IDummyInterface = obj:CreateInterface("IDummyInterface", {
    Execute = {
      type = "function";
      params = {"number"};
      returns = {"string"};
      default = Execute;
    };
  });

  local DummyClass = obj:CreateClass("DummyClass"):Implements(IDummyInterface);

  function DummyClass:__Construct(data)
    data.message = "testing";
  end

  function DummyClass:Execute(data, value)
    self:Print("Overridden Execute!", data.message, value);
    return "from class";
  end

  function DummyClass:Print(_, arg1, arg2, arg3)
    assert(arg1 == "Overridden Execute!");
    assert(arg2 == "testing");
    assert(arg3 == 123);
  end

  local instance = DummyClass();
  local success = instance:Execute(123);
  assert(success == "from class"); -- this passes
end

function Tests.Interface:ParentInterfaceMethods()
  local function Execute()
    print("executed")
  end

  local IDummyInterface = obj:CreateInterface("IDummyInterface", {
    MethodOne = {
      type = "function";
      default = Execute;
    };
    MethodTwo = { type = "function" };
  });

  local ParentClass = obj:CreateClass("ParentClass"):Implements(IDummyInterface);
  local ChildClass = obj:CreateClass("ChildClass", ParentClass);

  assert(not pcall(function()
    -- should not be able to create as it's not implemented
    ChildClass();
  end));

  function ParentClass:MethodTwo() end
  ChildClass();
end

----------------------------------------------------------------------
-- Run tests:
----------------------------------------------------------------------
do
  local SUCCESS = Green:WrapTextInColorCode("Successful");
  local IterateTests;
  local whitelist = {"Interface.ParentInterfaceMethods"};

  local function RunTest(testName)
    local continue = true;
    if (#whitelist > 0) then
      continue = false;

      for _, t in ipairs(whitelist) do
        if (t == testName) then
          continue = true;
          break
        end
      end
    end

    if (not continue) then return end

    local coloredTestName = Yellow:WrapTextInColorCode(testName);
    local test = Tests;

    if (testName:match("%.")) then
      for t in testName:gmatch("([^.]*)") do
        test = test[t];
      end
    else
      test = test[testName];
    end

    if (obj:IsFunction(test)) then
      print(strformat("[Test] %s - Started", coloredTestName));
      test();
      print(strformat("[Test] %s - %s", coloredTestName, SUCCESS));
    elseif (obj:IsTable(test)) then
      IterateTests(test, testName);
    end
  end

  function IterateTests(tests, path)
    for _, data in ipairs(tests) do
      local testName = data.testName;
      local value = data.value;

      if (path) then
        testName = strformat("%s.%s", path, testName);
      end

      if (obj:IsFunction(value)) then
        RunTest(testName);
      elseif (obj:IsTable(value)) then
        IterateTests(value, testName);
      end
    end
  end

  IterateTests(Tests.__tests);
end