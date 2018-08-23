-- Setup Namespaces ------------------

local _, Core = ...;

local em = Core.EventManager;
local tk = Core.Toolkit;
local db = Core.Database;
local gui = Core.GUIBuilder;
local L = Core.Locale;

local LABEL_PATTERN = "|cffffffff%s|r";

-- Register and Import Modules -------

local DataText = MayronUI:ImportModule("BottomUI_DataText");
local PerformanceModule, Performance = MayronUI:RegisterModule("DataText_Performance");
local Engine = Core.Objects:Import("MayronUI.Engine");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.performance", {
    enabled = true,
    show_fps = true,
    show_home_latency = true,
    show_server_latency = false,
    displayOrder = 4
});

-- Performance Module --------------

PerformanceModule:OnInitialize(function(self, data) 
    data.sv = db.profile.datatext.performance;

    if (data.sv.enabled) then
        DataText:RegisterDataItem(self, data.sv.displayOrder);
    end
end);

PerformanceModule:OnEnable(function(self, data, btn)
    data.btn = btn; 
end);

PerformanceModule:OnDisable(function(self, data)
    data.disabled = true;
end);

-- Performance Object --------------

function Performance:Update(data, override)
    if (not override and data.executed) then 
        return; 
    end

    data.executed = true;

    local function loop()
        if (data.disabled) then 
            return; 
        end

        local _, _, latencyHome, latencyServer = GetNetStats();

        local label = "";

        if (data.sv.show_fps) then
            label = tk.string.format("|cffffffff%u|r fps", GetFramerate());
        end

        if (data.sv.show_home_latency) then
            label = tk.string.format("%s |cffffffff%u|r ms", label, latencyHome);
        end

        if (data.sv.show_server_latency) then
            label = tk.string.format("%s |cffffffff%u|r ms", label, latencyServer);
        end

        data.btn:SetText(label:trim());
        if (not override) then
            tk.C_Timer.After(3, loop);
        end
    end

    loop();
end

function Performance:Click(data)
end

function Performance:HasMenu()
    return false;
end

Engine:DefineReturns("Button");
function Performance:GetButton(data)
    return data.btn;
end