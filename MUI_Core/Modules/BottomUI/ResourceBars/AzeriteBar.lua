-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local C_AzeriteItem, GameTooltip = _G.C_AzeriteItem, _G.GameTooltip;

-- Setup Objects -------------------------

local ResourceBarsPackage = obj:Import("MayronUI.ResourceBars");
local C_AzeriteBar = ResourceBarsPackage:Get("AzeriteBar");

-- Local Functions -----------------------

local function OnAzeriteXPUpdate(_, _, bar, data)
    if (not bar:CanUse()) then
        bar:SetActive(false);
        return;
    end

    if (not bar:IsActive()) then
        bar:SetActive(true);
    end

    local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem();
    local activeXP, totalXP = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation);

    data.statusbar:SetMinMaxValues(0, totalXP);
    data.statusbar:SetValue(activeXP);

    if (data.statusbar.text) then
        if (activeXP > 0 and totalXP == 0) then
            totalXP = activeXP;
        end

        local percent = (activeXP / totalXP) * 100;

        activeXP = tk:FormatNumberString(activeXP);
        totalXP = tk:FormatNumberString(totalXP);

        local text = tk.string.format("%s / %s (%d%%)", activeXP, totalXP, percent);
        data.statusbar.text:SetText(text);
    end
end

local function AzeriteBar_OnEnter(self)
    local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem();
    local activeXP, totalXP = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation);

    if (totalXP > 0) then
        local percent = (activeXP / totalXP) * 100;
        activeXP = tk:FormatNumberString(activeXP);
        totalXP = tk:FormatNumberString(totalXP);
        local text = tk.string.format("%s / %s (%d%%)", activeXP, totalXP, percent);

        GameTooltip:SetOwner(self, "ANCHOR_TOP");
        GameTooltip:AddLine(text, 1, 1, 1);
        GameTooltip:Show();
    end
end


-- C_AzeriteBar --------------------------

ResourceBarsPackage:DefineParams("BottomUI_ResourceBars", "table");
function C_AzeriteBar:__Construct(data, barsModule, moduleData)
    self:Super(barsModule, moduleData, "azerite");
    data.blizzardBar = _G.AzeriteWatchBar;
end

ResourceBarsPackage:DefineReturns("boolean");
function C_AzeriteBar:CanUse()
    return C_AzeriteItem.HasActiveAzeriteItem();
end

ResourceBarsPackage:DefineParams("boolean");
function C_AzeriteBar:SetActive(data, active)
    self.Parent:SetActive(active);

    if (active and data.notCreated) then
        data.statusbar.texture = data.statusbar:GetStatusBarTexture();
        data.statusbar.texture:SetVertexColor(_G.ARTIFACT_BAR_COLOR:GetRGB(), 0.8);

        data.statusbar:HookScript("OnEnter", AzeriteBar_OnEnter);
        data.statusbar:HookScript("OnLeave", tk.GeneralTooltip_OnLeave);
        data.notCreated = nil;
    end
end

ResourceBarsPackage:DefineParams("boolean");
function C_AzeriteBar:SetEnabled(data, enabled)
    if (enabled) then
        -- need to check when it's active
        em:CreateEventHandler("AZERITE_ITEM_EXPERIENCE_CHANGED", "AzeriteXP_Update", OnAzeriteXPUpdate, self, data);
        em:CreateEventHandlerWithKey("UNIT_INVENTORY_CHANGED", "Azerite_OnInventoryChanged", OnAzeriteXPUpdate, self, data)

        if (self:CanUse()) then
            if (not self:IsActive()) then
                self:SetActive(true);
            end

            -- must be triggered AFTER it has been created!
            em:TriggerEventHandlerByKey("AzeriteXP_Update");
        end

    elseif (self:IsActive()) then
        self:SetActive(false);
    end

    local handler = em:FindEventHandlerByKey("AzeriteXP_Update");
    local handler2 = em:FindEventHandlerByKey("Azerite_OnInventoryChanged");

    if (handler) then
        handler:SetEventCallbackEnabled("AZERITE_ITEM_EXPERIENCE_CHANGED", enabled);
    end

    if (handler2) then
        handler2:SetEventCallbackEnabled("UNIT_INVENTORY_CHANGED", enabled);
    end
end

