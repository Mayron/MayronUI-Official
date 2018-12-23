--luacheck: ignore TestDB LibStub
local Lib = LibStub:GetLibrary("LibMayronDB");
if (not Lib) then return; end

local db = Lib:CreateDatabase("LibMayronDB", "TestDB");

local function OnStartUp_Test1() -- luacheck: ignore
    print("OnStartUp_Test1 Started");

    db:OnStartUp(function(self, addOnName)
        assert(addOnName == "LibMayronDB", "Invalid params!");
        assert(self:IsLoaded(), "Database not loaded!");

        print("OnStartUp_Test1 Successful!");
    end);
end

local function ChangeProfile_Test1() -- luacheck: ignore
    print("ChangeProfile_Test1 Started");

    db:OnProfileChanged(function(_, newProfileName, oldProfileName)
        if (newProfileName == "ChangeProfile_Test1") then
            assert(oldProfileName == "Default");
        elseif (newProfileName == "Default") then
            assert(oldProfileName == "ChangeProfile_Test1");
        end
    end);

    db:OnStartUp(function(self)
        self:SetProfile("ChangeProfile_Test1");

        self:RemoveProfile("ChangeProfile_Test1");
        local currentProfileName = self:GetCurrentProfile();
        assert(currentProfileName == "Default");

        print("ChangeProfile_Test1 Successful!");
    end);
end

local function NewProfileIndex_Test1() -- luacheck: ignore
    print("NewProfileIndex_Test1 Started");

    db:OnStartUp(function(self)
       self:SetPathValue(self.profile, "hello[2].pigs", true);
       assert(self.profile.hello[2].pigs == true, "Failed to Index");

        self.profile.hello = nil;
        print("NewProfileIndex_Test1 Successful!");
    end);
end

local function UsingParentObserver_Test1() -- luacheck: ignore
    print("UsingParentObserver_Test1 Started");

    db:OnStartUp(function(self)
        self.profile.myParent = {
            events = {
                Something = {1, 2, 3},
                MyEvent1 = true
            },
            loaded = {
                module1 = true,
                module2 = false
            }
        };

        self.profile.myChild = {};
        self.profile.myChild:SetParent(self.profile.myParent);
        self.profile.myChild.events:Print();

        assert(self.profile.myChild.events.Something[1] == 1, "Child not connected to parent");

        print("UsingParentObserver_Test1 Successful!");
    end);
end

local function UsingParentObserver_Test2() -- luacheck: ignore
    print("UsingParentObserver_Test2 Started");

    db:OnStartUp(function(self)
        -- self.profile.hello[2].pigs = true;

        self.profile.myParent = {
            events = {
                Something = {1, 2, 3},
                MyEvent1 = true
            },
            loaded = {
                module1 = true,
                module2 = false
            }
        };

        self.profile.myChild = {};
        self.profile.myChild:SetParent(self.profile.myParent);

        -- this should use SetPathValue to build path into child table
        self.profile.myChild.events.MyEvent1 = false;
        assert(self.profile.myChild:ToSavedVariable().events.MyEvent1 == false, "Should be set!");
        self.profile.myParent = nil;
        self.profile.myChild = nil;

        print("UsingParentObserver_Test2 Successful!");
    end);
end

local function UsingParentObserver_Test3() -- luacheck: ignore
    print("UsingParentObserver_Test3 Started");

    db:OnStartUp(function(self)
        -- self.profile.hello[2].pigs = true;

        self.profile.myParent = {
            events = {
                Something = {1, 2, 3},
                MyEvent1 = true
            },
            loaded = {
                module1 = true,
                module2 = false
            }
        };

        self.profile.myChild = {};
        self.profile.myChild:SetParent(self.profile.myParent);

        self.profile.myChild.events.MyEvent1 = false;
        self.profile.myParent.events.MyEvent1 = {message = "hello"}; -- correctly assigns value to parent

        assert(self.profile.myChild.events.MyEvent1 == false, "Should still equal false!");
        assert(self.profile.myParent.events.MyEvent1:ToSavedVariable().message == "hello", "Should only change parent");

        print("UsingParentObserver_Test3 Successful!");
    end);
end

local function UpdatingToDefaultValueShouldRemoveSavedVariableValue_Test1() -- luacheck: ignore
    print("UpdatingToDefaultValueShouldRemoveSavedVariableValue_Test1 Started");

    db:OnStartUp(function(self)

        self:AddToDefaults("profile.subtable.options", {
            option1 = true,
            option2 = "abc",
            option3 = false,
            option4 = {
                value1 = 10,
                value2 = 20,
                value3 = 30
            }
        });

        self.profile.subtable.options.option4.value2 = 5000;

        -- does not work first time (must be using internalTree to mess things up)
        local options = self.profile.subtable.options:ToSavedVariable();
        assert(type(options) == "table", "Should be a table but got "..tostring(options));
        assert(options.option4.value2 == 5000, "Should be true.");

        self.profile.subtable.options.option4.value2 = 20;

        assert(self.profile.subtable.options.option4.value2 == 20, "Should be 20.");
        -- setting this back to default should remove it from the saved variable table... and should CLEAN UP!

        print("UpdatingToDefaultValueShouldRemoveSavedVariableValue_Test1 Successful!");
    end);
end

local function UpdatingSameValueMultipleTimes_Test1() -- luacheck: ignore
    print("UpdatingSameValueMultipleTimes_Test1 Started");

    db:OnStartUp(function(self)

        self:AddToDefaults("global.core", {
            value = 0.7,
        });

        assert(self.global.core.value == 0.7, "does not equal 0.7");
        self.global.core.value = 0.6;
        assert(self.global.core.value == 0.6, "does not equal 0.6");
        self.global.core.value = 0.5;
        assert(self.global.core.value == 0.5, "does not equal 0.5");
        self.global.core.value = 0.4;
        assert(self.global.core.value == 0.4, "does not equal 0.4");
        self.global.core.value = 0.3;
        assert(self.global.core.value == 0.3, "does not equal 0.3");

        self.global.core.value = nil;
        assert(self.global.core.value == 0.7, "does not go back to the default value of 0.7");

        print("UpdatingSameValueMultipleTimes_Test1 Successful!");
    end);
end

local function CleaningUpWithNilValue_Test1() -- luacheck: ignore
    print("CleaningUpWithNilValue_Test1 Started");

    db:OnStartUp(function(self)

        self:SetPathValue(self.global, "core.subTable1.subTable2[".."hello".."][4]", {
            value = 100,
        });

        assert(self.global.core.subTable1.subTable2["hello"][4].value == 100, "does not equal 100");

        self.global.core.subTable1.subTable2["hello"][4].value = nil;

        assert(self.global.core == nil, "self.global.core should be removed!")

        print("CleaningUpWithNilValue_Test1 Successful!");
    end);
end

local function UsingBothParentAndDefaults_Test1() -- luacheck: ignore
    print("UsingBothParentAndDefaults_Test1 Started");

    db:OnStartUp(function(self)
        self:AddToDefaults("profile.myModule", {
            enabled = true,
            frameStrata = "MEDIUM",
            frameLevel = 20,
            height = 24,
            spacing = 1,
            fontSize = 11,
            combatBlock = true,
            popup = {
                hideInCombat = true,
                maxHeight = 250,
                width = 200,
                itemHeight = 26
            }
        });

        db:AddToDefaults("profile.myModule.mySubModule", {
            enabled = true,
            sets = {},
            displayOrder = 8
        });

        local sv = self.profile.myModule;
        local subSv = self.profile.myModule.mySubModule;

        subSv:SetParent(sv);
        subSv:Print() -- should print all parent defaults

        local width = subSv.popup.width;

        assert(width == 200, "Width must be 200");

        print("UsingBothParentAndDefaults_Test1 Successful!");
    end);
end

local function ToTableAndSavingChanges_Test1() -- luacheck: ignore
    print("ToTableAndSavingChanges_Test1 Started");

    db:OnStartUp(function(self)
        local currentProfile = db:GetCurrentProfile();

       self:SetPathValue(self.profile, "root", {
           key1 = {
               1, 2, 3, "string"
           };
           key2 = {
               value1 = true;
               value2 = false;
           };
           key3 = {
                option1 = {
                    5, 10, 15, 20
                };
                option2 = "Testing...";
           };
       });

       local tbl = self.profile.root:ToTable();

       tbl.key3.option1.new = "test";

       assert(self.profile.root.key3.option1.new == nil);
       assert(TestDB.profiles[currentProfile].root.key3.option1.new == nil);

       tbl:SaveChanges();

       assert(self.profile.root.key3.option1.new == "test");
       assert(TestDB.profiles[currentProfile].root.key3.option1.new == "test");

        print("ToTableAndSavingChanges_Test1 Successful!");
    end);
end

local function ToTableAndSavingChanges_Test2() -- luacheck: ignore
    print("ToTableAndSavingChanges_Test2 Started");

    db:OnStartUp(function(self)
        local currentProfile = db:GetCurrentProfile();

       self:SetPathValue(self.profile, "root", {
           key1 = {
               1, 2, 3, "string"
           };
           key2 = {
               value1 = true;
               value2 = false;
           };
           key3 = {
                option1 = {
                    existingValue = "this is my value";
                };
           };
       });

       local tbl = self.profile.root:ToTable();

       tbl.key3.option1.existingValue = "test";

       assert(self.profile.root.key3.option1.existingValue == "this is my value");
       assert(TestDB.profiles[currentProfile].root.key3.option1.existingValue == "this is my value");

       tbl:SaveChanges();

       assert(self.profile.root.key3.option1.existingValue == "test");
       assert(TestDB.profiles[currentProfile].root.key3.option1.existingValue == "test");

       tbl.key3.option1.existingValue = nil;

       assert(self.profile.root.key3.option1.existingValue == "test");
       assert(TestDB.profiles[currentProfile].root.key3.option1.existingValue == "test");

       tbl:SaveChanges();

       assert(self.profile.root.key3.option1.existingValue == nil);
       assert(TestDB.profiles[currentProfile].root.key3 == nil); -- removes parent empty table/s as well!

        print("ToTableAndSavingChanges_Test2 Successful!");
    end);
end

-- Taken from LibMayronDB.lua
local function Equals(value1, value2, shallowEquals)
    local type1 = type(value1);

    if (type(value2) == type1) then

        if (type1 == "table") then

            if (tostring(value1) == tostring(value2)) then
                return true;
            elseif (shallowEquals) then
                return false;
            else
                for id, value in pairs(value1) do
                    if (not Equals(value, value2[id])) then
                        return false;
                    end
                end
            end

            return true;
        elseif (type1 == "function") then
            return tostring(value1) == tostring(value2);
        else
            return value1 == value2;
        end
    end

    return false;
end

local function ToTableAndSavingChanges_Test3() -- luacheck: ignore
    print("ToTableAndSavingChanges_Test3 Started");

    -- Arrange
    local expectedTable = {
        option1 = true;
        option2 = "def";
        option3 = false;
        option4 = {
            value1 = 650;
            value2 = 900;
            value3 = 30;
        };
        events = {
            eventIds = {1, 2, 3, 4, 5},
            ["auto load"] = false
        },
        modules = {
            module1 = true;
            module2 = true;
            module3 = false;
        };
        childOptions = {
            subModule1 = true;
            subModule2 = {
                1, 2, 3
            }
        }
    };

    db:OnStartUp(function(self)
        -- Arrange
        local currentProfile = db:GetCurrentProfile();

        self:AddToDefaults("profile.root.options", {
            option1 = true;
            option2 = "abc";
            option3 = false;
            option4 = {
                value1 = 10;
                value2 = 20;
                value3 = 30;
            }
        });

        self.profile.root = {
            option2 = "def";
            option4 = {
                value1 = 650;
            };
            events = {
                eventIds = {1, 2, 3};
                ["auto load"] = true;
            },
            modules = {
                module1 = true;
                module2 = false;
                module3 = false;
            }
        };

        self.profile.myChild = {
            option4 = {
                value2 = 900;
            };
            events = {
                eventIds = {4, 5};
                ["auto load"] = false;
            },
            modules = {
                module1 = true;
                module2 = true;
            };
            childOptions = {
                subModule1 = true;
                subModule2 = {
                    1, 2, 3
                }
            }
        };

        self.profile.myChild:SetParent(self.profile.root);
        local tbl = self.profile.myChild:ToTable();

        ------------------------------------------------
        -- Act and Assert:

        -- Table should merge child, parent, and default tables together in that priority order
        assert(Equals(tbl, expectedTable), "Tables are not equal!");

        -- set value to same value should result in no change required
        tbl.option4.value3 = 30;
        -- assert that database value is still the same (before saving)
        assert(self.profile.myChild.option4.value3 == 30);
        assert(TestDB.profiles[currentProfile].myChild.option4 == nil);

        -- save changes
        local totalChanges = tbl:SaveChanges();

        -- assert that database value is still the same (after saving)
        assert(totalChanges == 0);
        assert(self.profile.myChild.option4.value3 == 30);
        assert(TestDB.profiles[currentProfile].myChild.option4 == nil);

       -- set value to a different value
       tbl.option4.value3 = 789;
        -- assert that database value is still the same (before saving)
       assert(self.profile.myChild.option4.value3 == 30);
       assert(TestDB.profiles[currentProfile].myChild.option4 == nil);

       -- save changes
       totalChanges = tbl:SaveChanges();

       -- assert that database value has changed (after saving)
       assert(totalChanges == 1);
       assert(self.profile.myChild.option4.value3 == 789);
       assert(TestDB.profiles[currentProfile].myChild.option4.value3 == 789);

       -- set value back to original value
       tbl.option4.value3 = 30;
       -- assert that database value is still the previous value (before saving)
       assert(self.profile.myChild.option4.value3 == 789);
       assert(TestDB.profiles[currentProfile].myChild.option4.value3 == 789);

       -- save changes
       totalChanges = tbl:SaveChanges();

       -- assert that database value is back to the default value and removed from database (after saving)
       assert(totalChanges == 1);
       assert(self.profile.myChild.option4.value3 == 30);
       assert(TestDB.profiles[currentProfile].myChild.option4 == nil);

        print("ToTableAndSavingChanges_Test3 Successful!");
    end);
end

-- Uncomment to delete test database
-- db:OnStartUp(function(self, addOnName)
--     TestDB = {};
-- end);

--db:OnStartUp(function(self)
-- OnStartUp_Test1();
-- ChangeProfile_Test1();
-- NewProfileIndex_Test1();
-- UsingParentObserver_Test1()
-- UsingParentObserver_Test2();
-- UsingParentObserver_Test3();
-- UpdatingToDefaultValueShouldRemoveSavedVariableValue_Test1()
-- UpdatingSameValueMultipleTimes_Test1()
-- CleaningUpWithNilValue_Test1();
-- UsingBothParentAndDefaults_Test1();
--end);