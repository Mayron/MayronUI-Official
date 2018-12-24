--luacheck: ignore TestDB LibStub obj
local Lib = LibStub:GetLibrary("LibMayronDB");

if (not Lib) then return; end

local obj = _G.LibStub:GetLibrary("LibMayronObjects");
local db = Lib:CreateDatabase("LibMayronDB", "TestDB");

local function OnStartUp_Test1(self, addOnName) -- luacheck: ignore
    print("OnStartUp_Test1 Started");

    assert(addOnName == "LibMayronDB", "Invalid params!");
    assert(self:IsLoaded(), "Database not loaded!");

    print("OnStartUp_Test1 Successful!");
end

local function ChangeProfile_Test1(self) -- luacheck: ignore
    print("ChangeProfile_Test1 Started");

    db:OnProfileChange(function(_, newProfileName, oldProfileName)
        if (newProfileName == "ChangeProfile_Test1") then
            assert(oldProfileName == "Default");
        elseif (newProfileName == "Default") then
            assert(oldProfileName == "ChangeProfile_Test1");
        end
    end);

    self:SetProfile("ChangeProfile_Test1");

    self:RemoveProfile("ChangeProfile_Test1");

    local currentProfile = self:GetCurrentProfile();
    assert(currentProfile == "Default");

    print("ChangeProfile_Test1 Successful!");
end

local function NewProfileIndex_Test1(self) -- luacheck: ignore
    print("NewProfileIndex_Test1 Started");

    self:SetPathValue(self.profile, "hello[2].pigs", true);
    assert(self.profile.hello[2].pigs == true, "Failed to Index");

    self.profile.hello = nil;
    print("NewProfileIndex_Test1 Successful!");
end

local function UsingParentObserver_Test1(self) -- luacheck: ignore
    print("UsingParentObserver_Test1 Started");

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
end

local function UsingParentObserver_Test2(self) -- luacheck: ignore
    print("UsingParentObserver_Test2 Started");

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
end

local function UsingParentObserver_Test3(self) -- luacheck: ignore
    print("UsingParentObserver_Test3 Started");

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
end

local function UpdatingToDefaultValueShouldRemoveSavedVariableValue_Test1(self) -- luacheck: ignore
    print("UpdatingToDefaultValueShouldRemoveSavedVariableValue_Test1 Started");

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
end

local function UpdatingSameValueMultipleTimes_Test1(self) -- luacheck: ignore
    print("UpdatingSameValueMultipleTimes_Test1 Started");

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
end

local function CleaningUpWithNilValue_Test1(self) -- luacheck: ignore
    print("CleaningUpWithNilValue_Test1 Started");

    self:SetPathValue(self.global, "core.subTable1.subTable2[".."hello".."][4]", {
        value = 100,
    });

    assert(self.global.core.subTable1.subTable2["hello"][4].value == 100, "does not equal 100");

    self.global.core.subTable1.subTable2["hello"][4].value = nil;

    assert(self.global.core == nil, "self.global.core should be removed!")

    print("CleaningUpWithNilValue_Test1 Successful!");
end

local function UsingBothParentAndDefaults_Test1(self) -- luacheck: ignore
    print("UsingBothParentAndDefaults_Test1 Started");

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
end

local function ToTableAndSavingChanges_Test1(self) -- luacheck: ignore
    print("ToTableAndSavingChanges_Test1 Started");

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

    tbl:SaveChanges();

    assert(self.profile.root.key3.option1.new == "test");

    print("ToTableAndSavingChanges_Test1 Successful!");
end

local function ToTableAndSavingChanges_Test2(self) -- luacheck: ignore
    print("ToTableAndSavingChanges_Test2 Started");

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

    tbl:SaveChanges();

    assert(self.profile.root.key3.option1.existingValue == "test");

    tbl.key3.option1.existingValue = nil;

    assert(self.profile.root.key3.option1.existingValue == "test");

    tbl:SaveChanges();

    assert(self.profile.root.key3.option1.existingValue == nil);

    print("ToTableAndSavingChanges_Test2 Successful!");
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
                for key, value in pairs(value1) do
                    if (not Equals(value, value2[key])) then
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

local function ToTableAndSavingChanges_Test3(self) -- luacheck: ignore
    print("ToTableAndSavingChanges_Test3 Started");

    -- It seems that when a new table is assigned to child, it removes all other values
    -- Arrange
    local expectedTable = {
        parentTbl2 = {
            module1 = true;
            module2 = true;
            module3 = false;
        };
        defaults = {
            default1 = true;
            default2 = "def";
            default3 = {
                value1 = 650;
            };
            default4 = {
                value1 = 10;
                value2 = 900;
                value3 = 30;
            };
        };
        -- all ok!
        childTbl = {
            child2 = {
                1, 2, 3
            };
            child1 = true;
        };
        parentTbl1 = {
            value1 = {
                4,
                5,
                3,
            },
            ["auto load"] = false
        };
    };

    self:AddToDefaults("profile.root.defaults", {
        default1 = true;
        default2 = "abc";
        default3 = false;
        default4 = {
            value1 = 10;
            value2 = 20;
            value3 = 30;
        }
    });

    self.profile.myParent = {
        defaults = {
            default2 = "def";
            default3 = {
                value1 = 650;
            };
        };

        parentTbl1 = {
            value1 = {1, 2, 3};
            ["auto load"] = true;
        },

        parentTbl2 = {
            module1 = true;
            module2 = false;
            module3 = false;
        }
    };

    self.profile.root = {
        defaults = {
            default4 = {
                value2 = 900;
            };
        };

        parentTbl1 = {
            value1 = {4, 5};
            ["auto load"] = false;
        };

        parentTbl2 = {
            module1 = true;
            module2 = true;
        };

        childTbl = {
            child1 = true;
            child2 = {
                1, 2, 3
            }
        }
    };

    self.profile.root:SetParent(self.profile.myParent);
    local tbl = self.profile.root:ToTable();

    ------------------------------------------------
    -- Act and Assert:

    -- Table should merge child, parent, and default tables together in that priority order
    assert(Equals(tbl.__tracker.data, expectedTable), "Tables are not equal!");

    -- set value to same value should result in no change required
    tbl.defaults.default4.value3 = 30;
    assert(tbl.defaults.default4.value3 == 30);

    -- assert that database value is still the same (before saving)
    assert(self.profile.root.defaults.default4.value3 == 30);

    -- save changes
    local totalChanges = tbl:SaveChanges();

    -- assert that database value is still the same (after saving)
    assert(totalChanges == 0);
    assert(self.profile.root.defaults.default4.value3 == 30);

    -- set value to a different value
    tbl.defaults.default4.value3 = 789;
    assert(tbl.defaults.default4.value3 == 789);

    -- assert that database value is still the same (before saving)
    assert(self.profile.root.defaults.default4.value3 == 30);

    -- save changes
    totalChanges = tbl:SaveChanges();

    -- assert that database value has changed (after saving)
    assert(totalChanges == 1);
    assert(self.profile.root.defaults.default4.value3 == 789);

    -- set value back to original value
    tbl.defaults.default4.value3 = 30;
    assert(tbl.defaults.default4.value3 == 30);

    -- assert that database value is still the previous value (before saving)
    assert(self.profile.root.defaults.default4.value3 == 789);

    -- save changes
    totalChanges = tbl:SaveChanges();

    -- assert that database value is back to the default value and removed from database (after saving)
    assert(totalChanges == 1);
    assert(self.profile.root.defaults.default4.value3 == 30);

    print("ToTableAndSavingChanges_Test3 Successful!");
end

local function ToTableAndSavingChanges_Test4(self) -- luacheck: ignore
    print("ToTableAndSavingChanges_Test4 Started");

    self.profile.root = {
        options = {
            option1 = true;
            option2 = 123;
            option3 = {
                value1 = "not changed";
            }
        }
    };

    local tbl = self.profile.root:ToTable();

    tbl.options.option3.value1 = "test";
    assert(tbl.options.option3.value1 == "test");
    assert(self.profile.root.options.option3.value1 == "not changed");

    local pendingChanges = tbl:GetTotalPendingChanges();
    assert(pendingChanges == 1);

    tbl:ResetChanges();
    assert(tbl.options.option3.value1 == "not changed");

    pendingChanges = tbl:GetTotalPendingChanges();
    assert(pendingChanges == 0);

    tbl.options.option3.value1 = "different test";

    pendingChanges = tbl:GetTotalPendingChanges();
    assert(pendingChanges == 1);

    tbl:SaveChanges();

    pendingChanges = tbl:GetTotalPendingChanges();
    assert(pendingChanges == 0);
    assert(tbl.options.option3.value1 == "different test");
    assert(self.profile.root.options.option3.value1 == "different test");

    print("ToTableAndSavingChanges_Test4 Successful!");
end

local function ToTableAndSavingChanges_Test5(self) -- luacheck: ignore
    print("ToTableAndSavingChanges_Test5 Started");

    self.profile.root = {
        level1 = {
            val = 1;
            level2 = {
                val = 2;
                level3 = {
                    val = 3;
                    level4 = {
                        val = 4;
                    }
                }
            };
        }
    };

    local tbl = self.profile.root:ToTable();

    tbl.level1.val = 80;
    tbl.level1.level2.val = 70;
    tbl.level1.level2.level3.val = 60;

    local level4 = tbl.level1.level2.level3.level4;
    level4.val = 50;

    local pendingChanges = tbl:GetTotalPendingChanges();
    assert(pendingChanges == 4);

    tbl.level1.val = 1;
    tbl.level1.level2.val = 2;
    tbl.level1.level2.level3.val = 3;
    level4.val = 4;

    pendingChanges = tbl:GetTotalPendingChanges();
    assert(pendingChanges == 0, string.format("0 expected, got %s", pendingChanges));

    tbl:ResetChanges();

    level4.val = 900;

    pendingChanges = tbl:GetTotalPendingChanges();
    assert(pendingChanges == 1, string.format("1 expected, got %s", pendingChanges));

    level4.val = 4;

    pendingChanges = tbl:GetTotalPendingChanges();
    assert(pendingChanges == 0, string.format("0 expected, got %s", pendingChanges));

    print("ToTableAndSavingChanges_Test5 Successful!");
end

db:OnStartUp(function(...) -- luacheck: ignore
    TestDB = {};

    -- OnStartUp_Test1(...);
    -- ChangeProfile_Test1(...);
    -- NewProfileIndex_Test1(...);
    -- UsingParentObserver_Test1(...);
    -- UsingParentObserver_Test2(...);
    -- UsingParentObserver_Test3(...);
    -- UpdatingToDefaultValueShouldRemoveSavedVariableValue_Test1(...);
    -- UpdatingSameValueMultipleTimes_Test1(...);
    -- CleaningUpWithNilValue_Test1(...);
    -- UsingBothParentAndDefaults_Test1(...);
    -- ToTableAndSavingChanges_Test1(...);
    -- ToTableAndSavingChanges_Test2(...);
    -- ToTableAndSavingChanges_Test3(...);
    -- ToTableAndSavingChanges_Test4(...);
    -- ToTableAndSavingChanges_Test5(...);
end);