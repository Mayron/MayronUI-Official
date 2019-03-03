-- luacheck: ignore MayronUI self 143 631

---@type LibMayronGUI
local Lib = _G.LibStub:GetLibrary("LibMayronGUI");

if (not Lib) then return; end

local WidgetsPackage = Lib.WidgetsPackage;
local SlideController = WidgetsPackage:CreateClass("SlideController");

SlideController.Static.FORCE_RETRACT = 1;
SlideController.Static.FORCE_EXPAND = 2;
---------------------------------

local function frameOnHide(self)
    self:SetHeight(1);
end

WidgetsPackage:DefineParams("Frame", "?number");
function SlideController:__Construct(data, frame, step)
    data.frame = frame;
    data.step = step or 20;
    data.minHeight = 1;
    data.maxHeight = 200;

    frame:HookScript("OnHide", frameOnHide);
end

function SlideController:Start(data, forceState)
    assert(type(data) == "table" and not data.GetObjectType);
    local step = math.abs(data.step);

    if (forceState) then
        step = (forceState == SlideController.Static.FORCE_RETRACT and -step) or step;
    else
        step = ((self:IsMaxExpanded()) and -step) or step;
    end

    local function loop()
        if (data.step == 0 or data.stop) then
            return
        end

        local newHeight = math.floor(data.frame:GetHeight() + 0.5) + step;
        local endHeight = (step > 0 and data.maxHeight) or data.minHeight;

        if ((step > 0 and newHeight < data.maxHeight) or
                (step < 0 and newHeight > data.minHeight)) then

            data.frame:SetHeight(newHeight);
            _G.C_Timer.After(0.02, loop);
        else
            data.frame:SetHeight(endHeight);
            self:Stop();
        end
    end

    if (data.frame.ScrollFrame) then
        data.frame.ScrollFrame.animating = true;
    end

    data.frame:Show();

    if (self:IsMaxExpanded() and data.onStartRetract) then
        data.onStartRetract(self, data.frame);

    elseif (self:IsMaxRetracted()) then
        if (data.onStartExpand) then
            data.onStartExpand(self, data.frame);
        end
    end

    _G.C_Timer.After(0.04, function()
        data.stop = nil;
        loop();
    end);
end

function SlideController:Stop(data)
    data.stop = true;

    if (data.frame.ScrollFrame and data.frame.showScrollBar) then
        data.frame.showScrollBar:Show();
    end

    if (data.frame.ScrollFrame) then
        data.frame.ScrollFrame.animating = false;
    end

    if (self:IsMaxExpanded() and data.onEndExpand) then
        data.onEndExpand(self, data.frame);

    elseif (self:IsMaxRetracted()) then
        if (data.onEndRetract) then
            data.onEndRetract(self, data.frame);
        else
            data.frame:Hide();
        end
    end
end

function SlideController:SetStepValue(data, step)
    data.step = step;
    data.backedUpStep = step;
end

function SlideController:IsRunning(data)
    return data.stop;
end

function SlideController:IsMaxExpanded(data)
    return ((math.floor(data.frame:GetHeight() + 0.5)) == data.maxHeight);
end

function SlideController:IsMaxRetracted(data)
    return ((math.floor(data.frame:GetHeight() + 0.5)) == data.minHeight);
end

function SlideController:SetMaxHeight(data, maxHeight)
    data.maxHeight = math.floor(maxHeight + 0.5);
end

function SlideController:SetMinHeight(data, minHeight)
    data.minHeight = math.floor(minHeight + 0.5);
end

function SlideController:Hide(data)
    data.frame:Hide();
end

do
    local function AddDelay(func, delay)
        if (type(delay) == "number" and delay > 0) then
            return function()
                _G.C_Timer.After(0.02 * delay, func);
            end
        end

        return func;
    end

    function SlideController:OnStartExpand(data, func, delay)
        data.onStartExpand = AddDelay(func, delay);
    end

    function SlideController:OnEndExpand(data, func, delay)
        data.onEndExpand = AddDelay(func, delay);
    end

    function SlideController:OnStartRetract(data, func, delay)
        data.onStartRetract = AddDelay(func, delay);
    end

    function SlideController:OnEndRetract(data, func, delay)
        data.onEndRetract = AddDelay(func, delay);
    end
end