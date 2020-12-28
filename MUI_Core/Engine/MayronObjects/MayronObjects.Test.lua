-- luacheck: ignore self 143 631
local _G = _G;
local obj = _G.MayronObjects:GetFramework(); ---@type MayronObjects
local Tests = {};

local Green, Yellow = _G.GREEN_FONT_COLOR, _G.YELLOW_FONT_COLOR;
local pairs, print, strformat, assert = _G.pairs, _G.print, _G.string.format, _G.assert;

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

  obj:DefineParams("number", {"string", "hello world. How are we?"}, "...string");
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
    data.frame = _G.CreateFrame("Frame");
  end

  obj:DefineParams("Frame");
  function C_TestClass:SetParent(data, parent)
    data.frame:SetParent(parent);
  end

  obj:DefineParams("number", {"table", { message = "hello" }}, "...?number");
  obj:DefineReturns("number", "table", "...?number");
  function C_TestClass.Static:MyStaticMethod(value, tbl, ...)
    return value, tbl, ...;
  end

  obj:DefineParams("number", {"table", { message = "hello" }}, "...?number");
  obj:DefineReturns("number", "table", "...?number");
  function C_TestClass.Private:MyPrivateMethod(_, value, tbl, ...)
    return value, tbl, ...;
  end

  function C_TestClass:ClearAllPoints(data)
    data:Call("MyPrivateMethod", self.Static:MyStaticMethod(12, tblValue, nil, 2, nil, 3));
    data.frame:ClearAllPoints();
  end

  obj:DefineParams("string=CENTER");
  function C_TestClass:SetPoint(data, point)
    data.frame:SetPoint(point);
  end

  obj:DefineParams("boolean=true");
  function C_TestClass:SetShown(data, shown)
    data.frame:SetShown(shown);
  end

  local testInstance = C_TestClass();

  _G.UpdateAddOnMemoryUsage();
  local before = _G.GetAddOnMemoryUsage("MayronObjects-Lite");

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
  local after = _G.GetAddOnMemoryUsage("MayronObjects-Lite");
  local difference = after - before;

  print("difference: ", difference);
  assert(difference < 0.5, "difference: "..tostring(difference));
end

function Tests:Memory_Leak_Test_With_FrameWrapper()
  local C_TestClass = obj:CreateClass("TestClass");

  local testInstance = C_TestClass();
  testInstance:SetFrame(CreateFrame("Frame"));

  local bg = testInstance:CreateTexture(nil, "BACKGROUND");
  bg:SetAllPoints(true);
  bg:SetColorTexture(math.random(), math.random(), math.random());

  _G.UpdateAddOnMemoryUsage();
  local before = _G.GetAddOnMemoryUsage("MayronObjects-Lite");

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
  local after = _G.GetAddOnMemoryUsage("MayronObjects-Lite");
  local difference = after - before;

  print("difference: ", difference);
  assert(difference < 0.5, "difference: "..tostring(difference));
end

----------------------------------------------------------------------
-- Run tests:
----------------------------------------------------------------------
do
  local SUCCESS = Green:WrapTextInColorCode("Successful");

  for testName, test in pairs(Tests) do
    testName = Yellow:WrapTextInColorCode(testName);

    print(strformat("[Test] %s - Started", testName));
    test();
    print(strformat("[Test] %s - %s", testName, SUCCESS));
  end
end