-- luacheck: ignore MayronUI self 143
-- Setup namespaces ------------------
local _, namespace = ...;
local C_ChatModule = namespace.C_ChatModule;
local tk = MayronUI:GetAllComponents();

local CompactRaidFrameManager = _G.CompactRaidFrameManager;
--------------------------------------

local function ToggleButton_OnEvent(self)
    if (not tk.IsAddOnLoaded("Blizzard_CompactRaidFrames")) then
        return
    end

    if (_G.GetNumGroupMembers() > 0 and _G.IsInGroup()) then
        self:Show();
    else
        self:Hide();
    end
end

local function ToggleButton_OnClick(self)
    local compactFrame = CompactRaidFrameManager.displayFrame;

    -- toggle compact raid frame manager
    if (compactFrame:IsVisible()) then
        compactFrame:Hide();
        self:SetText(">");
    else
        compactFrame:Show();
        self:SetText("<");
    end

    compactFrame:SetWidth(CompactRaidFrameManager:GetWidth());
    compactFrame:SetHeight(CompactRaidFrameManager:GetHeight());
end

local function CreateToggleButton()
    local btn = tk.CreateFrame("Button", nil, tk.UIParent);
    btn:SetSize(14, 120);
    btn:SetNormalTexture(tk:GetAssetFilePath("Textures\\SideBar\\SideButton"));
    btn:SetNormalFontObject("MUI_FontSmall");
    btn:SetHighlightFontObject("GameFontHighlightSmall");
    btn:SetText(">");
    btn:GetNormalTexture():SetTexCoord(1, 0, 0, 1);
    btn:SetWidth(16);

    btn:RegisterEvent("ADDON_LOADED");
    btn:RegisterEvent("GROUP_ROSTER_UPDATE");
    btn:RegisterEvent("PLAYER_ENTERING_WORLD");

    btn:SetScript("OnClick", ToggleButton_OnClick);
    btn:SetScript("OnEvent", ToggleButton_OnEvent);

    return btn;
end

function C_ChatModule:SetUpRaidFrameManager(data)
    -- Hide Blizzard Compact Manager:
    CompactRaidFrameManager:DisableDrawLayer("ARTWORK");
    CompactRaidFrameManager:EnableMouse(false);
    tk:KillElement(CompactRaidFrameManager.toggleButton);

    -- button to toggle compact raid frame manager
    local btn = CreateToggleButton();

    if (data.chatFrames.TopLeft) then
        -- position below the top left chat frame if needed
        btn:SetPoint("TOPLEFT", data.chatFrames.TopLeft, "BOTTOMLEFT", -2, -40);
    else
        btn:SetPoint("LEFT", tk.UIParent, "LEFT", -2, 64);
    end

    local compactFrame = CompactRaidFrameManager.displayFrame;
    compactFrame:SetParent(btn);
    compactFrame:ClearAllPoints();
    compactFrame:SetPoint("TOPLEFT", btn, "TOPRIGHT", 5, 0);
    tk:MakeMovable(compactFrame);

    -- Create background frame to go behind blizzard's compact frame
    local backgroundFrame = tk.CreateFrame("Frame", nil, compactFrame);
    backgroundFrame:SetAllPoints(true);
    tk:SetBackground(backgroundFrame, 0, 0, 0);

    local newFrameLevel = compactFrame:GetFrameLevel() - 1;

    if (newFrameLevel < 0) then
        -- cannot be less than 0
        backgroundFrame:SetFrameLevel(0);
    else
        backgroundFrame:SetFrameLevel(newFrameLevel);
    end

    btn:Hide(); -- hide by default
end