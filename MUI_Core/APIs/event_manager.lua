------------------------
-- Setup namespaces
------------------------
local _, core = ...;
core.EventManager = {};
local em = core.EventManager;
local tk = core.Toolkit;
local private = {};

------------------------
-- Handler Prototype
------------------------
local Handler = tk:CreateProtectedPrototype("Handler");

-- runs before data is destroyed
-- remove handler from events table
function Handler:__Hook__Destroy(data)
    if (data.event) then
        tk.table.remove(private.events[data.event], self:GetPriority());
        private:CleanEventTable(data.event);
    end
end

function Handler:SetPriority(data, priority)
    local handlers = private.events[data.event];
    local old_priority = self:GetPriority();
    tk.table.remove(handlers, old_priority);
    tk.table.insert(handlers, priority, self);
end

function Handler:GetPriority(data)
    for priority, handler in tk.pairs(private.events[data.event]) do
        if (Handler.Static:GetData(handler).key == data.key) then
            return priority;
        end
    end
end

function Handler:GetEventName(data)
    return data.event;
end

function Handler:SetAutoDestroy(data, autoDestroy)
    data.autoDestroy = autoDestroy;
end

function Handler:SetKey(data, key)
    if (not key) then
        data.key = tk.tostring(self);
    else
        data.key = key;
    end
end

function Handler:GetKey(data)
    return data.key;
end

function Handler:IsDestroyed(data)
    return data == nil;
end

-- returns whether it was/is destroyed
function Handler:Run(data, event, ...)
    if (not data) then return true; end
    event = event or data.event;

    if (data.func) then
        data.func(event, ...);
    end

    if (data.autoDestroy) then
        self:Destroy();
        return true;
    end
    return false;
end

------------------------
-- EventManager API
------------------------
function em:CreateEventHandler(event, func, unit)
    local properties = {}
    properties.event = event;
    properties.func = func;
    local handler = Handler(properties);
    handler:SetKey(false);
    private.events[event] = private.events[event] or {};
    tk.table.insert(private.events[event], handler);
    if (unit) then
        private.frame:RegisterUnitEvent(event, unit);
    else
        private.frame:RegisterEvent(event);
    end
    return handler;
end

function em:CreateEventHandlers(events, func, unit)
    local handlers = {};
	
    for id, event in tk.ipairs({strsplit(",",events)}) do	
        --event = event:gsub("^%s*(.-)%s*$", "%1"));
        event = strtrim(event);
		
		if (#event > 0) then
			handlers[id] = em:CreateEventHandler(event, func, unit);
		end		
    end
	
    return tk.unpack(handlers);
end

function em:TriggerEvent(event, ...)
    if (private:EventTableExists(event)) then
        for _, handler in tk.pairs(private.events[event]) do
            handler:Run(event, ...);
        end
    end
end

function em:FindHandlerByKey(event, key)
    if (private:EventTableExists(event)) then
        for _, handler in tk.pairs(private.events[event]) do
            if (Handler.Static:GetData(handler).key == key) then
                return handler;
            end
        end
    end
end

function em:FindHandlerByPriority(event, priority)
    if (private:EventTableExists(event)) then
        return private.events[event][priority];
    end
end

function em:GetNumEventHandlers(event)
    if (private:EventTableExists(event)) then
        return #private.events[event];
    end
end

------------------------
-- Private API
------------------------
private.events = {};
private.frame = tk.CreateFrame("Frame");
private.frame:SetScript("OnEvent", function(_, ...)
    private:CallHandlers(...)
end);

function private:CallHandlers(event, ...)
    if (not self:IsEventTableEmpty(event)) then
        for id, _ in tk.pairs(self.events[event]) do
            while (#self.events[event] > 0) do
                local handler = self.events[event][id];
                local destroyed = handler:Run(event, ...);
                if (not destroyed) then break;
                elseif (not self.events[event]) then return; -- might have been removed by CleanEventTable
                end
            end
        end
    end
    self:CleanEventTable(event);
end

function private:CleanEventTable(event)
    if (self:EventTableExists(event) and self:IsEventTableEmpty(event)) then
        self.events[event] = nil;
        self.frame:UnregisterEvent(event);
    end
end

function private:IsEventTableEmpty(event)
    return self.events and #self.events[event] == 0;
end

function private:EventTableExists(event)
    return (self.events and self.events[event] and
            tk.type(self.events[event]) == "table");
end