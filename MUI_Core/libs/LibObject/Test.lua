local lib = LibStub:GetLibrary("LibObject");

local HelloWorld = lib:CreateClass("HelloWorld");
lib:Export(HelloWorld, "Test.Something");

--------------------------
-- HellWorld Class
--------------------------
function HelloWorld:_Constructor(private, msg)
    private.secret = "This is a secret!";
    print(msg);
    print("Assert False: " .. tostring((self == HelloWorld)));
end

lib:DefineArgs("string", "?number");
function HelloWorld:Print(private, msg, optionalNum)
    print(msg);
    print(private.secret);
end

-- Create a new instance of HelloWorld:
local instance = HelloWorld("My 1st Message");

instance:Print("My 2nd Message");

-- Import the same Class:
local HelloWorld2 = lib:Import("Test.Something.HelloWorld");
print("Assert True: " .. tostring((HelloWorld == HelloWorld2)));