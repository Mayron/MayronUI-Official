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
    assert(self.profile.myChild:GetSavedVariable().events.MyEvent1 == false, "Should be set!");
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

    assert(self.profile.myChild.events ~= nil);
    assert(self.profile.myChild.events.MyEvent1 == true);

    self.profile.myChild.events.MyEvent1 = false;
    self.profile.myParent.events.MyEvent1 = {message = "hello"}; -- correctly assigns value to parent

    assert(self.profile.myChild.events.MyEvent1 == false, "Should still equal false!");
    assert(self.profile.myParent.events.MyEvent1:GetSavedVariable().message == "hello", "Should only change parent");

    print("UsingParentObserver_Test3 Successful!");
end

local function UsingParentDefaults_Test1(self) -- luacheck: ignore
    print("UsingParentDefaults_Test1 Started");

    self:AddToDefaults("profile.module", {
        __templateModule = {
            value = 123;
        };
    });

    self:AddToDefaults("profile.module.child", {
        anotherValue = true;
    });

    self.profile.module.child:SetParent(self.profile.module.__templateModule);

    assert(self.profile.module.child:HasParent());

    assert(self.profile.module.child.value == 123);
    self.profile.module.child.value = 456;

    assert(self.profile.module.child.value == 456);

    assert(TestDB.profiles.Default.module.child.value == 456);
    assert(TestDB.profiles.Default.module.__templateModule == nil);

    print("UsingParentDefaults_Test1 Successful!");
end

local function UsingParentDefaults_Test2(self) -- luacheck: ignore
    print("UsingParentDefaults_Test2 Started");


    db:AddToDefaults("profile.chat", {
        chatFrames = {
            -- these tables will contain the templateMuiChatFrame data (using SetParent)
            TOPLEFT = {
                enabled = true;
            };
        };

        __templateChatFrame = {
            buttons = {
                {   "Character";
                    "Spell Book";
                    "Talents";
                };
                {   "Friends";
                    "Guild";
                    "Quest Log";
                };
                {   "Achievements";
                    "Collections Journal";
                    "Encounter Journal";
                };
            };
        };
    });

    self.profile.chat.chatFrames.TOPLEFT:SetParent(self.profile.chat.__templateChatFrame);

    assert(self.profile.chat.chatFrames.TOPLEFT.buttons[1][1] == "Character");

    self.profile.chat.chatFrames.TOPLEFT.buttons[1][1] = "Bag";

    assert(self.profile.chat.chatFrames.TOPLEFT.buttons[1][1] == "Bag");
    assert(self.profile.chat.chatFrames.TOPLEFT.buttons[2][1] == "Friends"); -- buttons is now in SV but [2] is missing

    print("UsingParentDefaults_Test2 Successful!");
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
    local options = self.profile.subtable.options:GetSavedVariable();
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
        popup = {
            width = 200,
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

    -- this is an important test to validate no cyclic function calls (stack overflow)
    subSv:Print(); -- should print all parent defaults

    local width = subSv.popup.width;

    assert(width == 200, "Width must be 200");

    print("UsingBothParentAndDefaults_Test1 Successful!");
end

local function GetTrackedTableAndSavingChanges_Test1(self) -- luacheck: ignore
    print("GetTrackedTableAndSavingChanges_Test1 Started");

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

    local tbl = self.profile.root:GetTrackedTable();

    tbl.key3.option1.new = "test";

    assert(self.profile.root.key3.option1.new == nil);

    tbl:SaveChanges();

    assert(self.profile.root.key3.option1.new == "test");

    print("GetTrackedTableAndSavingChanges_Test1 Successful!");
end

local function GetTrackedTableAndSavingChanges_Test2(self) -- luacheck: ignore
    print("GetTrackedTableAndSavingChanges_Test2 Started");

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

    local tbl = self.profile.root:GetTrackedTable();

    tbl.key3.option1.existingValue = "test";

    assert(self.profile.root.key3.option1.existingValue == "this is my value");

    tbl:SaveChanges();

    assert(self.profile.root.key3.option1.existingValue == "test");

    tbl.key3.option1.existingValue = nil;

    assert(self.profile.root.key3.option1.existingValue == "test");

    tbl:SaveChanges();

    assert(self.profile.root.key3 == nil); -- cleaned empty tables

    print("GetTrackedTableAndSavingChanges_Test2 Successful!");
end

-- Taken from LibMayronDB.lua
local function IsEqual(leftValue, rightValue, shallow)
    local leftType = type(leftValue);

    if (leftType == type(rightValue)) then
        if (leftType == "table") then

            if (shallow and tostring(leftValue) == tostring(rightValue)) then
                return true;
            else
                for key, value in pairs(leftValue) do
                    if (not IsEqual(value, rightValue[key])) then
                        return false;
                    end
                end

                for key, value in pairs(rightValue) do
                    if (not IsEqual(value, leftValue[key])) then
                        return false;
                    end
                end
            end

            return true;
        elseif (leftType == "function") then
            return tostring(leftValue) == tostring(rightValue);
        else
            return leftValue == rightValue;
        end
    end

    return false;
end

local function GetTrackedTableAndSavingChanges_Test3(self) -- luacheck: ignore
    print("GetTrackedTableAndSavingChanges_Test3 Started");

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
            default2 = "abc";
            default3 = {
                value1 = 650;
            };
            default4 = {
                value1 = 10;
                value2 = 900;
                value3 = 30;
            };
        };
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
        default2 = "abc"; -- should be picked over parent default
        default3 = false;
        default4 = {
            value1 = 10;
            value2 = 20;
            value3 = 30;
        }
    });

    self.profile.myParent = {
        defaults = {
            default2 = "def"; -- should be ignored in favour of child default
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
    local tbl = self.profile.root:GetTrackedTable();

    ------------------------------------------------
    -- Act and Assert:

    -- Table should merge child, parent, and default tables together in that priority order
    local untrackedTbl = tbl:GetUntrackedTable();

    obj:PrintTable(untrackedTbl);

    assert(IsEqual(untrackedTbl, expectedTable), "Tables are not equal!");

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

    print("GetTrackedTableAndSavingChanges_Test3 Successful!");
end

local function GetTrackedTableAndSavingChanges_Test4(self) -- luacheck: ignore
    print("GetTrackedTableAndSavingChanges_Test4 Started");

    self.profile.root = {
        options = {
            option1 = true;
            option2 = 123;
            option3 = {
                value1 = "not changed";
            }
        }
    };

    local tbl = self.profile.root:GetTrackedTable();

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

    print("GetTrackedTableAndSavingChanges_Test4 Successful!");
end

local function GetTrackedTableAndSavingChanges_Test5(self) -- luacheck: ignore
    print("GetTrackedTableAndSavingChanges_Test5 Started");

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

    local tbl = self.profile.root:GetTrackedTable();

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

    print("GetTrackedTableAndSavingChanges_Test5 Successful!");
end

local function GetUntrackedTable_Test1(self) -- luacheck: ignore
    print("GetUntrackedTable_Test1 Started");

    self.profile.root = {
        testValue = 12;
    };

    local tbl = self.profile.root:GetUntrackedTable();

    tbl.testValue = 100;

    assert(tbl.testValue == 100);

    local tracker = tbl:GetTrackedTable();

    assert(tracker.testValue == 100);
    assert(tracker:GetTotalPendingChanges() == 0);
    assert(self.profile.root.testValue == 12);

    tracker.testValue = 55;
    assert(tracker:GetTotalPendingChanges() == 1);
    assert(self.profile.root.testValue == 12);

    tracker:SaveChanges();
    assert(tracker:GetTotalPendingChanges() == 0);
    assert(tracker.testValue == 55);
    assert(self.profile.root.testValue == 55);

    local observer = tracker:GetObserver();
    assert(tbl:GetObserver() == observer);

    assert(observer.testValue == 55);
    assert(self.profile.root.testValue == 55);
    assert(tracker.testValue == 55);

    tracker.testValue = 900;
    assert(tracker.testValue == 900);
    assert(tbl.testValue == 55); -- udoes not update basicTable until SaveChanges()

    tracker:Refresh();
    assert(tracker.testValue == 900);
    assert(tbl.testValue == 55);

    observer.testValue = 4;
    assert(self.profile.root.testValue == 4);

    tracker:ResetChanges();
    assert(tracker.testValue == 55);
    assert(tbl.testValue == 55);

    tracker:Refresh();
    assert(tracker.testValue == 4);
    assert(tbl.testValue == 4);

    print("GetUntrackedTable_Test1 Successful!");
end

local function GetUntrackedTable_WithChildObservers_ThatHaveParents_Test1(self) -- luacheck: ignore
    print("GetUntrackedTable_WithChildObservers_ThatHaveParents_Test1 Started");

    self:AddToDefaults("profile.root", {
        __templateFrame = {
            defaultValue = 123;
            defaultTable = {
                "abc";
            };
        }
    });

    self.profile.root = {
        testValue = 12;
        frames = {
            left = {
                enabled = true;
            };
            right = {
                enabled = false;
            };
        }
    };

    -- parent applied to a svTable
    self.profile.root.frames.left:SetParent(self.profile.root.__templateFrame);
    self.profile.root.frames.right:SetParent(self.profile.root.__templateFrame);

    assert(self.profile.root.frames.left.enabled == true);
    assert(self.profile.root.frames.left.defaultValue == 123);
    assert(self.profile.root.frames.left.defaultTable[1] == "abc");

    assert(self.profile.root.frames.right.enabled == false);
    assert(self.profile.root.frames.right.defaultValue == 123);
    assert(self.profile.root.frames.right.defaultTable[1] == "abc");

    local tbl = self.profile.root:GetUntrackedTable();

    obj:PrintTable(tbl);
    assert(tbl.frames.left.enabled == true);
    assert(tbl.frames.left.defaultValue == 123);
    assert(tbl.frames.left.defaultTable[1] == "abc");

    assert(tbl.frames.right.enabled == false);
    assert(tbl.frames.right.defaultValue == 123);
    assert(tbl.frames.right.defaultTable[1] == "abc");

    print("GetUntrackedTable_WithChildObservers_ThatHaveParents_Test1 Successful!");
end

local function CyclicParentToChild_Test1(self) -- luacheck: ignore
    print("CyclicParentToChild_Test1 Started");

    self:AddToDefaults("profile.module", {
        enabled = true;
        width = 20,
        height = 24;
        values = {
            value1 = true;
        };
        general = {
            "component1";
            "component2";
        };
    });

    self:AddToDefaults("profile.module.component", {
        enabled = false,
        value = "test",
    });

    local sv = self.profile.module.component;
    sv:SetParent(self.profile.module);

    local settings = sv:GetTrackedTable();

    obj:PrintTable(settings:GetUntrackedTable());

    -- parent value should be ignored in favour of child (self.profile.module.component)
    assert(settings.enabled == false);

    assert(settings.value == "test");
    assert(settings.width == 20);
    assert(settings.height == 24);
    assert(settings.values.value1 == true);
    assert(settings.general[1] == "component1");
    assert(settings.general[2] == "component2");

    print("CyclicParentToChild_Test1 Successful!");
end

local function CyclicParentToChild_Test2(self) -- luacheck: ignore
    print("CyclicParentToChild_Test2 Started");

    self:AddToDefaults("profile.module", {
        enabled = true;
        width = 20,
        height = 24;
        values = {
            value1 = true;
        };
        general = {
            "component1";
            "component2";
        };
    });

    self:AddToDefaults("profile.module.component1", {
        value = 1,
    });

    self:AddToDefaults("profile.module.component2", {
        value = 2,
    });

    self:AddToDefaults("profile.module.component3", {
        value = 3,
    });

    self:AddToDefaults("profile.module.component4", {
        value = 4,
    });

    -- self.profile.root.frames.left:SetParent(self.profile.root.__templateFrame);
    -- self.profile.root.frames.right:SetParent(self.profile.root.__templateFrame);
    -- local tbl = self.profile.root:GetUntrackedTable();

    self.profile.module.component1:SetParent(self.profile.module);
    self.profile.module.component2:SetParent(self.profile.module);
    self.profile.module.component3:SetParent(self.profile.module);
    self.profile.module.component4:SetParent(self.profile.module);

    -- IMPORTANT: Do not scan children of a parent! But can scan own chilren parents!

    -- should ignore any sibbling or any node higher up that isn't an explicit parent
    local settings = self.profile.module.component4:GetTrackedTable();

    obj:PrintTable(settings:GetUntrackedTable());

    assert(settings.value == 4);
    assert(settings.width == 20);
    assert(settings.height == 24);
    assert(settings.values.value1 == true);
    assert(settings.general[1] == "component1");
    assert(settings.general[2] == "component2");

    print("CyclicParentToChild_Test2 Successful!");
end

db:OnStartUp(function(...) -- luacheck: ignore

    -- /console scriptErrors 1 - to display Lua errors
    -- OnStartUp_Test1(...);
    -- ChangeProfile_Test1(...);
    -- NewProfileIndex_Test1(...);
    -- UsingParentObserver_Test1(...);
    -- UsingParentObserver_Test2(...);
    -- UsingParentObserver_Test3(...);
    -- UsingParentDefaults_Test1(...);
    -- UsingParentDefaults_Test2(...);
    -- UpdatingToDefaultValueShouldRemoveSavedVariableValue_Test1(...);
    -- UpdatingSameValueMultipleTimes_Test1(...);
    -- CleaningUpWithNilValue_Test1(...);
    -- UsingBothParentAndDefaults_Test1(...);
    -- GetTrackedTableAndSavingChanges_Test1(...);
    -- GetTrackedTableAndSavingChanges_Test2(...);
    -- GetTrackedTableAndSavingChanges_Test3(...);
    -- GetTrackedTableAndSavingChanges_Test4(...);
    -- GetTrackedTableAndSavingChanges_Test5(...);
    -- GetUntrackedTable_Test1(...);
    -- GetUntrackedTable_WithChildObservers_ThatHaveParents_Test1(...); -- important
    -- CyclicParentToChild_Test1(...);
    -- CyclicParentToChild_Test2(...);  -- important

    TestDB = {};
end);