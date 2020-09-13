-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
if (tk:IsClassic()) then return end

local C_AzeriteItem = _G.C_AzeriteItem;

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

        activeXP = tk.Strings:FormatReadableNumber(activeXP);
        totalXP = tk.Strings:FormatReadableNumber(totalXP);

        local text = string.format("%s / %s (%d%%)", activeXP, totalXP, percent);
        data.statusbar.text:SetText(text);
    end
end

-- C_AzeriteBar --------------------------

ResourceBarsPackage:DefineParams("BottomUI_ResourceBars", "table");
function C_AzeriteBar:__Construct(_, barsModule, moduleData)
    self:Super(barsModule, moduleData, "azerite");
end

ResourceBarsPackage:DefineReturns("boolean");
function C_AzeriteBar:CanUse()
    return _G.AzeriteBarMixin:ShouldBeVisible(); -- this is a static mixin method
end

ResourceBarsPackage:DefineParams("boolean");
function C_AzeriteBar:SetActive(data, active)
    self.Parent:SetActive(active);

    if (active and data.notCreated) then
        data.statusbar.texture = data.statusbar:GetStatusBarTexture();
        data.statusbar.texture:SetVertexColor(_G.ARTIFACT_BAR_COLOR:GetRGB(), 0.8);

        data.notCreated = nil;
    end
end

ResourceBarsPackage:DefineParams("boolean");
function C_AzeriteBar:SetEnabled(data, enabled)
    if (enabled) then
        -- need to check when it's active
        em:CreateEventHandlerWithKey("AZERITE_ITEM_EXPERIENCE_CHANGED", "AzeriteXP_Update", OnAzeriteXPUpdate, self, data);
        em:CreateEventHandlerWithKey("UNIT_INVENTORY_CHANGED", "Azerite_OnInventoryChanged", OnAzeriteXPUpdate, self, data);

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

