-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local TalkingHeadFrame, C_PetBattles = _G.TalkingHeadFrame, _G.C_PetBattles;
local CreateFrame, UIParent = _G.CreateFrame, _G.UIParent;

-- Register and Import Modules -----------

local C_Container = MayronUI:RegisterModule("BottomUI_Container", "Main Container");

-- Add Database Defaults -----------------

db:AddToDefaults("profile.bottomui", {
    width = 750;
});

-- C_Container ------------------

function C_Container:OnInitialize(data)
    if (not MayronUI:IsInstalled()) then
        return;
    end

    data.container = CreateFrame("Frame", "MUI_BottomContainer", UIParent);
    data.container:SetPoint("BOTTOM", 0, -1);
    data.container:SetFrameStrata("LOW");

    em:CreateEventHandler("PET_BATTLE_OVER", function()
        data.container:Show();
    end);

    em:CreateEventHandler("PET_BATTLE_OPENING_START", function()
        data.container:Hide();
    end);

    em:CreateEventHandler("TALKINGHEAD_REQUESTED", function()
        if (TalkingHeadFrame) then
            TalkingHeadFrame:ClearAllPoints();
            TalkingHeadFrame:SetParent(UIParent);
            TalkingHeadFrame:SetPoint("BOTTOM", 0, 250);
            TalkingHeadFrame.ClearAllPoints = tk.Constants.DUMMY_FUNC;
            TalkingHeadFrame.SetParent = tk.Constants.DUMMY_FUNC;
            TalkingHeadFrame.SetPoint = tk.Constants.DUMMY_FUNC;
        end
    end);

    if (C_PetBattles.IsInBattle()) then
        data.container:Hide();
    end

    -- Initialize Sub Modules -------------

    data.subModules = obj:PopTable();

    data.subModules.ResourceBars = MayronUI:ImportModule("BottomUI_ResourceBars");
    data.subModules.ActionBarPanel = MayronUI:ImportModule("BottomUI_ActionBarPanel");
    data.subModules.UnitPanels = MayronUI:ImportModule("BottomUI_UnitPanels");

    data.subModules.ResourceBars:Initialize(self, data.subModules);
    data.subModules.ActionBarPanel:Initialize(self, data.subModules);
    data.subModules.UnitPanels:Initialize(self, data.subModules);

    self:RegisterUpdateFunctions(db.profile.bottomui, {
        width = function(value)
            data.container:SetSize(value, 1);

            local dataTextModule = MayronUI:ImportModule("DataTextModule");

            if (dataTextModule and dataTextModule:IsEnabled()) then
                dataTextModule:PositionDataTextButtons();
            end
        end;
    });

    self:SetEnabled(true);
end

function C_Container:OnEnable()
    self:RepositionContent();
end

function C_Container:RepositionContent(data)
    local dataTextModule = MayronUI:ImportModule("DataTextModule");
    local actionBarPanel;
    local anchorFrame = data.container;

    if (dataTextModule and dataTextModule:IsEnabled()) then
        anchorFrame = _G["MUI_DataTextBar"];
    end

    if (data.subModules.ResourceBars and data.subModules.ResourceBars:IsEnabled()) then
        local resourceContainer = data:GetFriendData(data.subModules.ResourceBars).barsContainer;

        -- position resourceContainer:
        resourceContainer:ClearAllPoints();
        resourceContainer:SetPoint("BOTTOMLEFT", anchorFrame, "TOPLEFT", 0, -1);
        resourceContainer:SetPoint("BOTTOMRIGHT", anchorFrame, "TOPRIGHT", 0, -1);
        anchorFrame = resourceContainer;
    end

    if (data.subModules.ActionBarPanel and data.subModules.ActionBarPanel:IsEnabled()) then
        actionBarPanel = _G["MUI_ActionBarPanel"];

        -- position actionBarPanel:
        actionBarPanel:ClearAllPoints();
        actionBarPanel:SetPoint("BOTTOMLEFT", anchorFrame, "TOPLEFT", 0, -1);
        actionBarPanel:SetPoint("BOTTOMRIGHT", anchorFrame, "TOPRIGHT", 0, -1);
        anchorFrame = actionBarPanel;
    end

    if (data.subModules.UnitPanels and data.subModules.UnitPanels:IsEnabled()) then
        local unitHeight = db.profile.unitPanels.unitHeight;
        local leftUnitPanel = _G["MUI_UnitPanelLeft"];
        local rightUnitPanel = _G["MUI_UnitPanelRight"];

        -- position unit panels:
        leftUnitPanel:ClearAllPoints();
        rightUnitPanel:ClearAllPoints();
        leftUnitPanel:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", 0, unitHeight);
        rightUnitPanel:SetPoint("TOPRIGHT", anchorFrame, "TOPRIGHT", 0, unitHeight);
    end

    -- Update Bartender Bars
    if (actionBarPanel) then
        data.subModules.ActionBarPanel:SetUpAllBartenderBars();
    end
end