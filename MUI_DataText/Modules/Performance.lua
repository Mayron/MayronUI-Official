-- luacheck: ignore MayronUI self 143 631
local tk, db, em, _, obj = MayronUI:GetCoreComponents();

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local Performance = Engine:CreateClass("Performance", nil, "MayronUI.Engine.IDataTextModule");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.performance", {
    showFps = true,
    showHomeLatency = true,
    showServerLatency = false
});

-- Performance Module --------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
    local sv = db.profile.datatext.performance;
    sv:SetParent(db.profile.datatext);

    local settings = sv:GetTrackedTable();
    self:RegisterDataModule("performance", Performance, settings);
end);

function Performance:__Construct(data, settings, dataTextModule)
    data.settings = settings;

    -- set public instance properties
    self.MenuContent = _G.CreateFrame("Frame");
    self.MenuLabels = {};
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = false;
    self.HasRightMenu = false;
    self.SavedVariableName = "performance";
    self.Button = dataTextModule:CreateDataTextButton();
end

function Performance:SetEnabled(data, enabled)
    data.enabled = enabled;

    if (enabled) then
        data.handler = em:CreateEventHandler("FRIENDLIST_UPDATE", function()
            if (not self.Button) then return; end
            self:Update();
        end);

    elseif (data.handler) then
        data.handler:Destroy();
        data.handler = nil;
    end
end

function Performance:IsEnabled(data)
    return data.enabled;
end

function Performance:Update(data)
    if (data.executed) then
        return
    end

    data.executed = true;

    local function loop()
        local _, _, latencyHome, latencyServer = _G.GetNetStats();

        local label = "";

        if (data.settings.showFps) then
            label = tk.string.format("|cffffffff%u|r fps", _G.GetFramerate());
        end

        if (data.settings.showHomeLatency) then
            label = tk.string.format("%s |cffffffff%u|r ms", label, latencyHome);
        end

        if (data.settings.showServerLatency) then
            label = tk.string.format("%s |cffffffff%u|r ms", label, latencyServer);
        end

        self.Button:SetText(label:trim());

        tk.C_Timer.After(3, loop);
    end

    loop();
end

function Performance:Click() end