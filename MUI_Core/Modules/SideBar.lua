-- luacheck: ignore MayronUI self 143 631
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local Private = {};
local ObjectiveTrackerFrame = _G.ObjectiveTrackerFrame;

-- Register and Import Modules -----------

local SideBar = MayronUI:RegisterModule("SideBar");

-- Add Database Defaults -----------------

db:AddToDefaults("profile.sidebar", {
    enabled = true,
    height = 486,
    retractWidth = 46,
    expandWidth = 83,
    animationSpeed = 6,
    yOffset = 40,
    barsShown = 2, -- non-config GUI

    objectiveTracker = {
        enabled = true,
        anchoredToSideBars = true,
        width = 250,
        height = 600,
        xOffset = -30,
        yOffset = 0
    },

    buttons = {
        showWhen = "Always", -- can be mouseover or never
        hideInCombat = false,
        width = 15,
        height = 100,
    },

    bartender = {
        control = true,
        [1] = "Bar 3", -- first bar
        [2] = "Bar 4", -- second bar
    }
});

-- Local Functions -----------------------

-- TODO: Used in ConfigUpdate
-- local function UpdateObjectiveTracker(objectiveContainer)
--     local sv = db.profile.sidebar.objectiveTracker;
--     objectiveContainer:ClearAllPoints();

--     if (sv.anchoredToSideBars) then
--         objectiveContainer:SetPoint("TOPRIGHT", sidebar.panel, "TOPLEFT", sv.xOffset, sv.yOffset);
--     else
--         objectiveContainer:SetPoint("CENTER", sv.xOffset, sv.yOffset);
--     end
-- end

-- local function Button_OnEnter(self)
--     self:SetAlpha(1);
-- end

-- local Button_OnLeave = function(self)
--     self:SetAlpha(0);
-- end

-- Private Functions ---------------------

function Private:ToggleBartenderBar(bar, show)
    if (tk.IsAddOnLoaded("Bartender4") and db.profile.sidebar.bartender.control) then
        bar:SetConfigAlpha((show and 1) or 0);
        bar:SetVisibilityOption("always", not show);
    end
end

function Private:ExpandFrame(sidebar, bar2, frame, maxWidth)
    local counter = 1;

    local function loop()
        if (counter) then
            counter = counter + 1;

            if (counter > 6) then
                if (tk.IsAddOnLoaded("Bartender4") and db.profile.sidebar.bartender.control) then
                    tk.UIFrameFadeIn(bar2, 0.2, bar2:GetAlpha(), 1);
                end

                counter = false;
            end
        end

        local width = tk.math.floor(frame:GetWidth() + 0.5);

        if (width < maxWidth and frame.expand) then
            if (width + Private.step > maxWidth) then
                frame:SetWidth(maxWidth);
            else
                frame:SetWidth(width + Private.step);
            end

            tk.C_Timer.After(0.02, loop);
        else
            frame:SetWidth(maxWidth);
            Private:ToggleBartenderBar(bar2, true);
            frame.animating = false;
            sidebar:SetBarsShown(2);
        end
    end

    frame:Show();
    frame.expand = true;
    frame.animating = true;
    tk.C_Timer.After(0.02, loop);
end

function Private:RetractFrame(sidebar, bar2, frame, minWidth)
    local function loop()
        local width = tk.math.floor(frame:GetWidth() + 0.5);

        if (width > (Private.step + minWidth) and not frame.expand) then
            frame:SetWidth(width - Private.step);
            tk.C_Timer.After(0.02, loop);

        else
            frame:SetWidth(minWidth);
            Private:ToggleBartenderBar(bar2, false);
            frame.animating = false;
            sidebar:SetBarsShown(1);
        end
    end

    frame.expand = nil;
    frame.animating = true;

    if (tk.IsAddOnLoaded("Bartender4") and db.profile.sidebar.bartender.control) then
        tk.UIFrameFadeOut(bar2, 0.1, bar2:GetAlpha(), 0);
    end

    tk.C_Timer.After(0.02, loop);
end

function Private:MoveFrameOut(sideBarModule, frame, bar1, controlBartender)
    local function loop()
        local point, anchor, anchorPoint, xOffset, yOffset = frame:GetPoint();
        local width = tk.math.floor(frame:GetWidth() + 0.5);

        if (xOffset < (width - Private.step) and not frame.moveIn) then
            frame:SetPoint(point, anchor, anchorPoint, xOffset + Private.step, yOffset);
            tk.C_Timer.After(0.02, loop);

        else
            frame:SetPoint(point, anchor, anchorPoint, width, yOffset);
            frame:Hide();
            Private:ToggleBartenderBar(bar1, false);
            frame.animating = false;
            sideBarModule:SetBarsShown(0);
        end
    end

    frame.moveIn = nil;
    frame.animating = true;

    if (tk.IsAddOnLoaded("Bartender4") and controlBartender) then
        tk.UIFrameFadeOut(bar1, 0.1, bar1:GetAlpha(), 0);
    end

    tk.C_Timer.After(0.02, loop);
end

function Private:MoveFrameIn(sideBarModule, frame, bar1, controlBartender)
    local counter = 1;

    local function loop()
        if (counter) then
            counter = counter + 1;

            if (counter > 8) then
                if (tk.IsAddOnLoaded("Bartender4") and controlBartender) then
                    tk.UIFrameFadeIn(bar1, 0.2, bar1:GetAlpha(), 1);
                end

                counter = false;
            end
        end

        local point, anchor, anchorPoint, xOffset, yOffset = frame:GetPoint();
        xOffset = tk.math.floor(xOffset + 0.5);

        if (xOffset > (0 + Private.step) and frame.moveIn) then
            frame:SetPoint(point, anchor, anchorPoint, xOffset - Private.step, yOffset);
            tk.C_Timer.After(0.02, loop);

        else
            frame:SetPoint(point, anchor, anchorPoint, 0, yOffset);
            Private:ToggleBartenderBar(bar1, true);
            frame.animating = false;
            sideBarModule:SetBarsShown(1);
        end
    end

    frame:Show();
    frame.moveIn = true;
    frame.animating = true;
    tk.C_Timer.After(0.02, loop);
end

-- SideBar Module -----------------------

function SideBar:OnInitialize(data)
    data.sv = db.profile.sidebar;

    if (data.sv.enabled) then
        self:SetEnabled(true);
    end
end

function SideBar:OnEnable(data)
    Private.step = data.sv.animationSpeed;

    self:SetBartenderBars();
    self:CreateSideBar();
    self:SetBarsShown(data.sv.barsShown);

    em:CreateEventHandler("PET_BATTLE_OPENING_START", function()
        data.panel:Hide();
    end);

    em:CreateEventHandler("PET_BATTLE_CLOSE", function()
        data.panel:Show();
    end);

    if (data.sv.buttons.hideInCombat) then
        em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
            data.expand:Hide();
            data.retract:Hide();
        end):SetKey("SideBar_Buttons");

        em:CreateEventHandler("PLAYER_REGEN_ENABLED", function()
            data.expand:SetShown(data.sv.barsShown ~= 2);
            data.retract:SetShown(data.sv.barsShown ~= 0);
        end):SetKey("SideBar_Buttons");
    end

    if (data.sv.objectiveTracker.enabled) then
        local sv = data.sv.objectiveTracker;

        -- holds and controls blizzard objectives tracker frame
        data.objectiveContainer = tk.CreateFrame("Frame", nil, tk.UIParent);
        data.objectiveContainer:SetSize(sv.width, sv.height);

        if (sv.anchoredToSideBars) then
            data.objectiveContainer:SetPoint("TOPRIGHT", data.panel, "TOPLEFT", sv.xOffset, sv.yOffset);
        else
            data.objectiveContainer:SetPoint("CENTER", sv.xOffset, sv.yOffset);
        end

        -- blizzard objective tracker frame global variable
        ObjectiveTrackerFrame:SetClampedToScreen(false);
        ObjectiveTrackerFrame:SetParent(data.objectiveContainer);
        ObjectiveTrackerFrame:SetAllPoints(true);

        ObjectiveTrackerFrame.ClearAllPoints = tk.Constants.DUMMY_FUNC;
        ObjectiveTrackerFrame.SetParent = tk.Constants.DUMMY_FUNC;
        ObjectiveTrackerFrame.SetPoint = tk.Constants.DUMMY_FUNC;
        ObjectiveTrackerFrame.SetAllPoints = tk.Constants.DUMMY_FUNC;
    end
end

-- function SideBar:OnConfigUpdate(list, value)
--     local key = list:PopFront();

--     if (key == "profile" and list:PopFront() == "sidebar") then
--         key = list:PopFront();

--         if (key == "objectiveTracker") then
--             key = list:PopFront();

--             if (key == "anchoredToSideBars" or key == "xOffset" or key == "yOffset") then
--                 UpdateObjectiveTracker(data.objectiveContainer);

--             elseif (key == "width") then
--                 data.objectiveContainer:SetWidth(value);

--             elseif (key == "height") then
--                 data.objectiveContainer:SetHeight(value);
--             end

--         elseif (key == "retractWidth") then
--             if (data.sv.barsShown == 1) then
--                 data.panel:SetWidth(value);
--             end

--         elseif (key == "expandWidth") then
--             if (data.sv.barsShown == 2) then
--                 data.panel:SetWidth(value);
--             end

--         elseif (key == "height") then
--             data.panel:SetHeight(value);

--         elseif (key == "yOffset") then
--             data.panel:SetPoint("RIGHT", 0, value);

--         elseif (key == "animationSpeed") then
--             Private.step = value;

--         elseif (key == "bartender") then
--             data:SetBartenderBars();

--         elseif (key == "buttons") then
--             key = list:PopFront();

--             if (key == "width") then
--                 data.expand:SetWidth(value);
--                 data.retract:SetWidth(value);

--             elseif (key == "height") then
--                 data.expand:SetHeight(value);
--                 data.retract:SetHeight(value);

--             elseif (key == "showWhen") then
--                 data.expand:SetShown(value ~= "Never");
--                 data.retract:SetShown(value ~= "Never");

--                 if (value == "On Mouse-over") then
--                     data.expand:SetAlpha(0);
--                     data.retract:SetAlpha(0);
--                     data.expand:SetScript("OnEnter", Private.OnEnter);
--                     data.expand:SetScript("OnLeave", Private.OnLeave);
--                     data.retract:SetScript("OnEnter", Private.OnEnter);
--                     data.retract:SetScript("OnLeave", Private.OnLeave);

--                 else
--                     data.expand:SetScript("OnEnter", nil);
--                     data.expand:SetScript("OnLeave", nil);
--                     data.retract:SetScript("OnEnter", nil);
--                     data.retract:SetScript("OnLeave", nil);
--                     data.expand:SetAlpha(1);
--                     data.retract:SetAlpha(1);
--                 end

--                 if (data.sv.barsShown == 2) then
--                     data.expand:Hide();

--                 elseif (data.sv.barsShown == 0) then
--                     data.retract:Hide();
--                 end

--             elseif (key == "hideInCombat") then
--                 local handler = em:FindHandlerByKey("PLAYER_REGEN_DISABLED", "SideBar_Buttons");

--                 if ((value and not handler) or handler:IsDestroyed()) then
--                     em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
--                         data.expand:Hide();
--                         data.retract:Hide();
--                     end):SetKey("SideBar_Buttons");

--                     em:CreateEventHandler("PLAYER_REGEN_ENABLED", function()
--                         data.expand:SetShown(data.sv.barsShown ~= 2);
--                         data.retract:SetShown(data.sv.barsShown ~= 0);
--                     end):SetKey("SideBar_Buttons");

--                 elseif (not value and handler) then
--                     em:FindHandlerByKey("PLAYER_REGEN_DISABLED", "SideBar_Buttons"):Destroy();
--                     em:FindHandlerByKey("PLAYER_REGEN_ENABLED", "SideBar_Buttons"):Destroy();
--                 end

--                 if (value and tk.InCombatLockdown()) then
--                     data.expand:Hide();
--                     data.retract:Hide();
--                 else
--                     data.expand:SetShown(data.sv.barsShown ~= 2);
--                     data.retract:SetShown(data.sv.barsShown ~= 0);
--                 end
--             end
--         end
--     end
-- end

-- SideBar Object -------------------------

function SideBar:Expand(data, expandAmount)
    if (tk.InCombatLockdown()) then
        return;
    end

    tk.PlaySound(tk.Constants.CLICK);

    if (expandAmount == 1) then
        data.expand:Hide();
        Private:MoveFrameIn(self, data.panel, data.BTBar1, data.sv.bartender.control);

    elseif (expandAmount == 2) then
        data.expand:Hide();
        data.retract:Hide();
        Private:ExpandFrame(self, data.BTBar2, data.panel, data.sv.expandWidth);
    end
end

function SideBar:Retract(data, retractAmount)
    if (tk.InCombatLockdown()) then
        return;
    end

    tk.PlaySound(tk.Constants.CLICK);

    if (retractAmount == 1) then
        data.retract:Hide();
        Private:RetractFrame(self, data.BTBar2, data.panel, data.sv.retractWidth);

    elseif (retractAmount == 2) then
        data.expand:Hide();
        data.retract:Hide();
        Private:MoveFrameOut(self, data.panel, data.BTBar1, data.sv.bartender.control);
    end
end

function SideBar:SetBarsShown(data, numBarsShown)
    data.sv.barsShown = numBarsShown;
    data.expand:ClearAllPoints();
    data.retract:ClearAllPoints();

    if (data.sv.barsShown == 2) then
        Private:ToggleBartenderBar(data.BTBar2, true);
        Private:ToggleBartenderBar(data.BTBar1, true);

        data.panel:SetSize(data.sv.expandWidth, data.sv.height);
        data.retract:SetPoint("RIGHT", data.panel, "LEFT");
        data.expand:Hide();
        data.retract:Show();

        data.retract:SetScript("OnClick", function()
            self:Retract(1);
        end);

    elseif (data.sv.barsShown == 1) then
        Private:ToggleBartenderBar(data.BTBar2, false);
        Private:ToggleBartenderBar(data.BTBar1, true);
        data.panel:SetSize(data.sv.retractWidth, data.sv.height);
        data.expand:SetPoint("RIGHT", data.panel, "LEFT", 0, 90);
        data.retract:SetPoint("RIGHT", data.panel, "LEFT", 0, -90);
        data.expand:Show();
        data.retract:Show();

        data.expand:SetScript("OnClick", function()
            self:Expand(2);
        end);

        data.retract:SetScript("OnClick", function()
            self:Retract(2);
        end);

    elseif (data.sv.barsShown == 0) then
        Private:ToggleBartenderBar(data.BTBar1, false);
        Private:ToggleBartenderBar(data.BTBar2, false);
        data.panel:ClearAllPoints();
        data.panel:SetSize(data.sv.retractWidth, data.sv.height);
        data.panel:SetPoint("RIGHT", tk.UIParent, "RIGHT", data.sv.retractWidth,data.sv.yOffset);
        data.panel:Hide();
        data.expand:Show();
        data.retract:Hide();
        data.expand:SetPoint("RIGHT");

        data.expand:SetScript("OnClick", function()
            self:Expand(1);
        end);
    end

    if (data.sv.buttons.showWhen == "Never") then
        data.expand:Hide();
        data.retract:Hide();
    end
end

function SideBar:CreateSideBar(data)
    if (data.panel) then
        return;
    end

    local sideButtonTexturePath = tk:GetAssetFilePath("Textures\\SideBar\\SideButton");
    local sideBarTexturePath = tk:GetAssetFilePath("Textures\\SideBar\\SideBarPanel");

    data.panel = tk.CreateFrame("Frame", "MUI_SideBar", tk.UIParent);
    data.panel:SetPoint("RIGHT", 0, data.sv.yOffset);

    --TODO: Is this needed?
    gui:CreateGridTexture(data.panel, sideBarTexturePath, 20, nil, 45, 749);

    data.expand = tk.CreateFrame("Button", nil, tk.UIParent);
    data.expand:SetNormalFontObject("MUI_FontSmall");
    data.expand:SetHighlightFontObject("GameFontHighlightSmall");
    data.expand:SetNormalTexture(sideButtonTexturePath);
    data.expand:SetSize(data.sv.buttons.width, data.sv.buttons.height);
    data.expand:SetText("<");

    data.retract = tk.CreateFrame("Button", nil, tk.UIParent);
    data.retract:SetNormalFontObject("MUI_FontSmall");
    data.retract:SetHighlightFontObject("GameFontHighlightSmall");
    data.retract:SetNormalTexture(sideButtonTexturePath);
    data.retract:SetSize(data.sv.buttons.width, data.sv.buttons.height);
    data.retract:SetText(">");

    if (data.sv.buttons.showWhen == "On Mouse-over") then
        data.expand:SetAlpha(0);
        data.retract:SetAlpha(0);
        data.expand:SetScript("OnEnter", Private.OnEnter);
        data.expand:SetScript("OnLeave", Private.OnLeave);
        data.retract:SetScript("OnEnter", Private.OnEnter);
        data.retract:SetScript("OnLeave", Private.OnLeave);
    end
end

function SideBar:SetBartenderBars(data)
    if (tk.IsAddOnLoaded("Bartender4") and data.sv.bartender.control) then
        local bar1 = data.sv.bartender[1]:match("%d+");
        local bar2 = data.sv.bartender[2]:match("%d+");

        _G.Bartender4:GetModule("ActionBars"):EnableBar(bar1);
        _G.Bartender4:GetModule("ActionBars"):EnableBar(bar2);
        data.BTBar1 = tk._G["BT4Bar"..tk.tostring(bar1)];
        data.BTBar2 = tk._G["BT4Bar"..tk.tostring(bar2)];
    end
end