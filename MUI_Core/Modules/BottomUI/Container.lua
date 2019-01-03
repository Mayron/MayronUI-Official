-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetAllComponents(); -- luacheck: ignore
local _, namespace = ...;

local TalkingHeadFrame, C_PetBattles = _G.TalkingHeadFrame, _G.C_PetBattles;
local IsAddOnLoaded, CreateFrame, UIParent = _G.IsAddOnLoaded, _G.CreateFrame, _G.UIParent;

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

    db = namespace.Database; -- TODO: is this needed now?

    data.updateFunctionsRootPath = "profile.actionBarPanel";
    db:RegisterUpdateFunctions(data.updateFunctionsRegistryKey, {
        width = function(value)
            data.container:SetSize(value, 1);
        end;
    });

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

    data.subModules = {};

    data.subModules.ResourceBars = MayronUI:ImportModule("BottomUI_ResourceBars");
    data.subModules.ActionBarPanel = MayronUI:ImportModule("BottomUI_ActionBarPanel");
    data.subModules.UnitPanels = MayronUI:ImportModule("BottomUI_UnitPanels");

    data.subModules.ResourceBars:Initialize(data.container, data.subModules);
    data.subModules.ActionBarPanel:Initialize(data.container, data.subModules);
    data.subModules.UnitPanels:Initialize(data.container, data.subModules);
end

function C_Container:UpdateContainer(data)
    data.subModules.ActionBarPanel:PositionBartenderBars();
end

function C_Container:OnConfigUpdate(data, dbPath, value)
    if (dbPath == "profile.bottomui.width") then
        data.container:SetWidth(value);

        if (IsAddOnLoaded("MUI_DataText")) then
            local dataTextModule = MayronUI:ImportModule("DataText");

            if (dataTextModule:IsEnabled()) then
                dataTextModule:PositionDataTextButtons();
            end
        end
    end
end