-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local HasArtifactEquipped = _G.HasArtifactEquipped;
local C_ArtifactUI = _G.C_ArtifactUI;
local GetNumPurchasableArtifactTraits = _G.ArtifactBarGetNumArtifactTraitsPurchasableFromXP;

-- Setup Objects -------------------------

local ResourceBarsPackage = obj:Import("MayronUI.ResourceBars");
local C_ArtifactBar = ResourceBarsPackage:Get("ArtifactBar");

-- Local Functions -----------------------

local function OnArtifactXPUpdate(_, _, bar, data)
    if (not bar:CanUse()) then
        bar:SetActive(false);
        return;
    end

    if (not bar:IsActive()) then
        bar:SetActive(true);
    end

    local totalXP, pointsSpent, _, _, _, _, _, _, tier = select(5, C_ArtifactUI.GetEquippedArtifactInfo());
    local _, currentValue, maxValue = GetNumPurchasableArtifactTraits(pointsSpent, totalXP, tier);

    data.statusbar:SetMinMaxValues(0, maxValue);
    data.statusbar:SetValue(currentValue);

    if currentValue > 0 and maxValue == 0 then
        maxValue = currentValue;
    end

    local percent = (currentValue / maxValue) * 100;
    currentValue = tk.Strings:FormatReadableNumber(currentValue);
    maxValue = tk.Strings:FormatReadableNumber(maxValue);

    local text = string.format("%s / %s (%d%%)", currentValue, maxValue, percent);
    data.statusbar.text:SetText(text);
end

-- C_ArtifactBar -------------------------

ResourceBarsPackage:DefineParams("BottomUI_ResourceBars", "table");
function C_ArtifactBar:__Construct(data, barsModule, moduleData)
    self:Super(barsModule, moduleData, "artifact");
    data.blizzardBar = _G.ArtifactWatchBar;
end

ResourceBarsPackage:DefineReturns("boolean");
function C_ArtifactBar:CanUse()
    return HasArtifactEquipped();
end

ResourceBarsPackage:DefineParams("boolean");
function C_ArtifactBar:SetActive(data, active)
    self.Parent:SetActive(active);

    if (active and data.notCreated) then
        data.statusbar.texture = data.statusbar:GetStatusBarTexture();
        data.statusbar.texture:SetVertexColor(_G.ARTIFACT_BAR_COLOR:GetRGB(), 0.8);
        data.notCreated = nil;
    end
end

ResourceBarsPackage:DefineParams("boolean");
function C_ArtifactBar:SetEnabled(data, enabled)
    if (enabled) then
        -- need to check when it's active
        em:CreateEventHandlerWithKey("ARTIFACT_XP_UPDATE", "ArtifactXP_Update", OnArtifactXPUpdate, self, data);
        em:CreateEventHandlerWithKey("UNIT_INVENTORY_CHANGED", "Artifact_OnInventoryChanged", OnArtifactXPUpdate, self, data);

        if (self:CanUse()) then
            if (not self:IsActive()) then
                self:SetActive(true);
            end

            -- must be triggered AFTER it has been created!
            em:TriggerEventHandlerByKey("Artifact_OnInventoryChanged");
        end

    elseif (self:IsActive()) then
        self:SetActive(false);
    end

    local handler = em:FindEventHandlerByKey("ArtifactXP_Update");
    local handler2 = em:FindEventHandlerByKey("Artifact_OnInventoryChanged");

    if (handler) then
        handler:SetEventCallbackEnabled("ARTIFACT_XP_UPDATE", enabled);
    end

    if (handler2) then
        handler2:SetEventCallbackEnabled("UNIT_INVENTORY_CHANGED", enabled);
    end
end