-- Setup Namespaces ------------------

local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local LABEL_PATTERN = "|cffffffff%s|r";

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local DataText = MayronUI:ImportModule("DataText");
local Performance = Engine:CreateClass("Performance", nil, "MayronUI.Engine.IDataTextModule");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.performance", {
    enabled = true,
    showFps = true,
    showHomeLatency = true,
    showServerLatency = false,
    displayOrder = 4
});

-- Performance Module --------------

DataText:Hook("OnInitialize", function(self, dataTextData)
    local sv = db.profile.datatext.performance;
    sv:SetParent(dataTextData.sv);

    if (sv.enabled) then
        local performance = Performance(sv);
        self:RegisterDataModule(performance);
        performance:Enable();
    end
end);

function Performance:__Construct(data, sv)
    data.sv = sv;
    data.displayOrder = sv.displayOrder;

    -- set public instance properties
    self.MenuContent = CreateFrame("Frame");
    self.MenuLabels = {};
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = false;
    self.HasRightMenu = false;
    self.Button = DataText:CreateDataTextButton(self);
end

function Performance:Enable(data) 
    data.sv.enabled = true;

    data.handler = em:CreateEventHandler("FRIENDLIST_UPDATE", function()
        if (not self.Button) then return; end
        self:Update();
    end);  
end

function Performance:Disable(data)
    data.sv.enabled = false;

    if (data.handler) then
        data.handler:Destroy();
    end
end

function Performance:IsEnabled(data) 
    return data.sv.enabled;
end

function Performance:Update(data)
    if (data.executed) then 
        return; 
    end

    data.executed = true;

    local function loop()
        local _, _, latencyHome, latencyServer = GetNetStats();

        local label = "";

        if (data.sv.showFps) then
            label = tk.string.format("|cffffffff%u|r fps", GetFramerate());
        end

        if (data.sv.showHomeLatency) then
            label = tk.string.format("%s |cffffffff%u|r ms", label, latencyHome);
        end

        if (data.sv.showServerLatency) then
            label = tk.string.format("%s |cffffffff%u|r ms", label, latencyServer);
        end

        self.Button:SetText(label:trim());

        if (not override) then
            tk.C_Timer.After(3, loop);
        end
    end

    loop();
end

function Performance:Click(data) end

function Performance:GetDisplayOrder(data)
    return data.displayOrder;
end

function Performance:SetDisplayOrder(data, displayOrder)
    if (data.displayOrder ~= displayOrder) then
        data.displayOrder = displayOrder;
        data.sv.displayOrder = displayOrder;
    end
end 