-- luacheck: ignore self 143 631
local Lib = _G.LibStub:GetLibrary("LibMayronObjects"); ---@type LibMayronObjects

if (Lib:Import("Framework.System.Attributes.InCombatAttribute", true)) then return end
local Attributes = Lib:CreatePackage("Attributes", "Framework.System");
local InCombatLockdown, select, unpack = _G.InCombatLockdown, _G.select, _G.unpack;

Attributes:CreateInterface("IAttribute", {
    -- params: instance, privateData, functionName, function parameters as vararg
    OnExecute = {type = "function"; params = {"Object", "table", "string"}; returns = "boolean"};
    __Construct = {type = "function", params = {"?boolean", "?boolean"}}
});

local C_Stack = Lib:Import("Framework.System.Collections.Stack<T>");

---@type Stack
local functionCalls = C_Stack:Of("table")();
local frame = _G.CreateFrame("Frame");
frame:RegisterEvent("PLAYER_REGEN_ENABLED");

frame:SetScript("OnEvent", function()
    while (not functionCalls:IsEmpty()) do
        local funcCall = functionCalls:Pop();
        local instance = funcCall[1];
        local funcName = funcCall[2];
        instance[funcName](instance, select(3, unpack(funcCall)));
    end
end);

---@class InCombatAttribute : Object
local InCombatAttribute = Attributes:CreateClass("InCombatAttribute", nil, "IAttribute");

function InCombatAttribute:__Construct(data, executeLater, silent)
    data.executeLater = executeLater;
    data.silent = silent;
end

---@param instance Object
function InCombatAttribute:OnExecute(data, instance, _, funcName, ...)
    if (InCombatLockdown()) then

        if (data.executeLater) then
            functionCalls:Push(Lib:PopTable(instance, funcName, ...));
            return;
        end

        if (data.silent) then
            return false; -- do not call the function
        end

        Lib:Error("Failed to execute %s.%s: Cannot execute while in combat.", instance:GetObjectType(), funcName);
    end

    return true; -- continue executing the function
end