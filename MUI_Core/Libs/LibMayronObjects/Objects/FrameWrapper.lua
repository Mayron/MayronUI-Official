-- luacheck: ignore self 143 631
local Lib = _G.LibStub:GetLibrary("LibMayronObjects"); ---@type LibMayronObjects

if (Lib:Import("Framework.System.FrameWrapper", true)) then return end
local SystemPackage = Lib:Import("Framework.System");

---@class FrameWrapper : Object
local FrameWrapper = SystemPackage:CreateClass("FrameWrapper");

---This method is used within the LibMayronObjects code to call Frame methods on the underlining frame instead of on the object.
function FrameWrapper:GetProxyFunction(data, funcName)
    -- @param ... - parameters passed to the real frame function
    return function(_, ...)
        return data.frame[funcName](data.frame, ...);
    end;
end

---@param frame Frame @Set the underlining Frame widget
function FrameWrapper:SetFrame(data, frame)
    data.frame = frame;
end

---@return Frame @Get underlining Frame widget
function FrameWrapper:GetFrame(data)
    return data.frame;
end