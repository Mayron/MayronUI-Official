local Lib = LibStub:GetLibrary("LibMayronObjects");
local SystemPackage = Lib:Import("Framework.System");
local FrameWrapper = SystemPackage:CreateClass("FrameWrapper");
-----------------------------------

function FrameWrapper:GetProxyFunction(data, funcName)
    -- @param ... - parameters passed to the real frame function
    return function(_, ...)
        return data.frame[funcName](data.frame, ...);
    end;
end

function FrameWrapper:SetFrame(data, frame)
    data.frame = frame; 
end

function FrameWrapper:GetFrame(data)
    return data.frame;
end