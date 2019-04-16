-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local GetWatchedFactionInfo = _G.GetWatchedFactionInfo;

-- Setup Objects -------------------------

local ResourceBarsPackage = obj:Import("MayronUI.ResourceBars");
local C_ReputationBar = ResourceBarsPackage:Get("ReputationBar");

-- Local Functions -----------------------

local function OnReputationBarUpdate(_, _, bar, data)
    if (not bar:CanUse()) then
        bar:SetActive(false);
        return;
    end

    if (not bar:IsActive()) then
        bar:SetActive(true);
    end

    local factionName, _, minValue, maxValue, currentValue = GetWatchedFactionInfo();

    maxValue = maxValue - minValue;
    currentValue = currentValue - minValue;

    data.statusbar:SetMinMaxValues(0, maxValue);
    data.statusbar:SetValue(currentValue);

    if (data.statusbar.text) then
        local percent = (currentValue / maxValue) * 100;
        currentValue = tk.Strings:FormatReadableNumber(currentValue);
        maxValue = tk.Strings:FormatReadableNumber(maxValue);

        local text = string.format("%s: %s / %s (%d%%)", factionName, currentValue, maxValue, percent);
        data.statusbar.text:SetText(text);
    end
end

-- C_ReputationBar -----------------------

ResourceBarsPackage:DefineParams("BottomUI_ResourceBars", "table");
function C_ReputationBar:__Construct(_, barsModule, moduleData)
    self:Super(barsModule, moduleData, "reputation");
end

ResourceBarsPackage:DefineReturns("boolean");
function C_ReputationBar:CanUse()
    -- standingID 8 == exalted
    local factionName, standingID = GetWatchedFactionInfo();
    local canUse = (factionName ~= nil and standingID < 8);
    return canUse;
end

ResourceBarsPackage:DefineParams("boolean");
function C_ReputationBar:SetActive(data, active)
    self.Parent:SetActive(active);

    if (active and data.notCreated) then
        data.statusbar.texture = data.statusbar:GetStatusBarTexture();
        data.statusbar.texture:SetVertexColor(0.16, 0.6, 0.16, 1);
        data.notCreated = nil;
    end
end

ResourceBarsPackage:DefineParams("boolean");
function C_ReputationBar:SetEnabled(data, enabled)
    if (enabled) then
        em:CreateEventHandlerWithKey("UPDATE_FACTION, PLAYER_REGEN_ENABLED",
            "OnReputationBarUpdate", OnReputationBarUpdate, self, data);

        if (self:CanUse()) then
            if (not self:IsActive()) then
                self:SetActive(true);
            end

            -- must be triggered AFTER it has been created!
            em:TriggerEventHandlerByKey("OnReputationBarUpdate");
        end

    elseif (self:IsActive()) then
        self:SetActive(false);
    end

    local handler = em:FindEventHandlerByKey("OnReputationBarUpdate");

    if (handler) then
        handler:SetEventCallbackEnabled("UPDATE_FACTION", enabled);
        handler:SetEventCallbackEnabled("PLAYER_REGEN_ENABLED", enabled);
    end
end
