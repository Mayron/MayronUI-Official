------------------------
-- Setup namespaces
------------------------
local _, core = ...;
local em = core.EventManager;
local tk = core.Toolkit;
local gui = core.GUI_Builder;
local db = core.Database;

local sidebar = {};
local private = {};

------------------------
------------------------
db:AddToDefaults("profile.sidebar", {
    height = 486,
    retract_width = 46,
    expand_width = 83,
    animate_speed = 6,
    yOffset = 40,
    bars_shown = 2, -- non-config GUI

    objective_tracker = {
        enabled = true,
        anchored_to_sidebars = true,
        width = 250,
        height = 600,
        xOffset = -30,
        yOffset = 0
    },

    buttons = {
        show_when = "Always", -- can be mouseover or never
        hide_in_combat = false,
        width = 15,
        height = 100,
    },

    bartender = {
        control = true,
        [1] = "Bar 3", -- first bar
        [2] = "Bar 4", -- second bar
    }
});
MayronUI:RegisterModule("SideBar", sidebar);

function private:ToggleBartenderBar(bar, show)
    if (tk.IsAddOnLoaded("Bartender4") and sidebar.sv.bartender.control) then
        bar:SetConfigAlpha((show and 1) or 0);
        bar:SetVisibilityOption("always", not show);
    end
end

private.OnEnter = function(self)
    self:SetAlpha(1);
end

private.OnLeave = function(self)
    self:SetAlpha(0);
end

private.Regen_Disabled = function()
    sidebar.expand:Hide();
    sidebar.retract:Hide();
end
private.Regen_Enabled = function()
    sidebar.expand:SetShown(sidebar.sv.bars_shown ~= 2);
    sidebar.retract:SetShown(sidebar.sv.bars_shown ~= 0);
end


function private:ExpandFrame(frame, maxWidth)
    local counter = 1;
    local function loop()
        if (counter) then
            counter = counter + 1;
            if (counter > 6) then
                if (tk.IsAddOnLoaded("Bartender4") and sidebar.sv.bartender.control) then
                    tk.UIFrameFadeIn(sidebar.BTBar2, 0.2, sidebar.BTBar2:GetAlpha(), 1);
                end
                counter = false;
            end
        end
        local width = tk.math.floor(frame:GetWidth() + 0.5);
        if (width < maxWidth and frame.expand) then
            if (width + private.step > maxWidth) then
                frame:SetWidth(maxWidth);
            else
                frame:SetWidth(width + private.step);
            end
            tk.C_Timer.After(0.02, loop);
        else
            frame:SetWidth(maxWidth);
            private:ToggleBartenderBar(sidebar.BTBar2, true);
            frame.animating = false;
            sidebar:SetBarsShown(2);
        end
    end
    frame:Show();
    frame.expand = true;
    frame.animating = true;
    tk.C_Timer.After(0.02, loop);
end

function private:RetractFrame(frame, minWidth)
    local function loop()
        local width = tk.math.floor(frame:GetWidth() + 0.5);
        if (width > (private.step + minWidth) and not frame.expand) then
            frame:SetWidth(width - private.step);
            tk.C_Timer.After(0.02, loop);
        else
            frame:SetWidth(minWidth);
            private:ToggleBartenderBar(sidebar.BTBar2, false);
            frame.animating = false;
            sidebar:SetBarsShown(1);
        end
    end
    frame.expand = nil;
    frame.animating = true;
    if (tk.IsAddOnLoaded("Bartender4") and sidebar.sv.bartender.control) then
        tk.UIFrameFadeOut(sidebar.BTBar2, 0.1, sidebar.BTBar2:GetAlpha(), 0);
    end
    tk.C_Timer.After(0.02, loop);
end

function private:MoveFrameOut(frame)
    local function loop()
        local point, anchor, anchorPoint, xOffset, yOffset = frame:GetPoint();
        local width = tk.math.floor(frame:GetWidth() + 0.5);
        if (xOffset < (width - private.step) and not frame.moveIn) then
            frame:SetPoint(point, anchor, anchorPoint, xOffset + private.step, yOffset);
            tk.C_Timer.After(0.02, loop);
        else
            frame:SetPoint(point, anchor, anchorPoint, width, yOffset);
            frame:Hide();
            private:ToggleBartenderBar(sidebar.BTBar1, false);
            frame.animating = false;
            sidebar:SetBarsShown(0);
        end
    end
    frame.moveIn = nil;
    frame.animating = true;
    if (tk.IsAddOnLoaded("Bartender4") and sidebar.sv.bartender.control) then
        tk.UIFrameFadeOut(sidebar.BTBar1, 0.1, sidebar.BTBar1:GetAlpha(), 0);
    end
    tk.C_Timer.After(0.02, loop);
end

function private:MoveFrameIn(frame)
    local counter = 1;
    local function loop()
        if (counter) then
            counter = counter + 1;
            if (counter > 8) then
                if (tk.IsAddOnLoaded("Bartender4") and sidebar.sv.bartender.control) then
                    tk.UIFrameFadeIn(sidebar.BTBar1, 0.2, sidebar.BTBar1:GetAlpha(), 1);
                end
                counter = false;
            end
        end
        local point, anchor, anchorPoint, xOffset, yOffset = frame:GetPoint();
        local xOffset = tk.math.floor(xOffset + 0.5);
        if (xOffset > (0 + private.step) and frame.moveIn) then
            frame:SetPoint(point, anchor, anchorPoint, xOffset - private.step, yOffset);
            tk.C_Timer.After(0.02, loop);
        else
            frame:SetPoint(point, anchor, anchorPoint, 0, yOffset);
            private:ToggleBartenderBar(sidebar.BTBar1, true);
            frame.animating = false;
            sidebar:SetBarsShown(1);
        end
    end
    frame:Show();
    frame.moveIn = true;
    frame.animating = true;
    tk.C_Timer.After(0.02, loop);
end

private.expand = {
    -- expand once
    function(self)
        if (tk.InCombatLockdown()) then return; end
        tk.PlaySound(tk.Constants.CLICK);
        sidebar.expand:Hide();
        private:MoveFrameIn(sidebar.panel);
    end,
    -- expand twice
    function(self)
        if (tk.InCombatLockdown()) then return; end
        tk.PlaySound(tk.Constants.CLICK);
        sidebar.expand:Hide();
        sidebar.retract:Hide();
        private:ExpandFrame(sidebar.panel, sidebar.sv.expand_width);
    end
};

private.retract = {
    -- retract once
    function(self)
        if (tk.InCombatLockdown()) then return; end
        tk.PlaySound(tk.Constants.CLICK);
        sidebar.retract:Hide();
        private:RetractFrame(sidebar.panel, sidebar.sv.retract_width);
    end,
    -- retract twice
    function(self)
        if (tk.InCombatLockdown()) then return; end
        tk.PlaySound(tk.Constants.CLICK);
        sidebar.expand:Hide();
        sidebar.retract:Hide();
        private:MoveFrameOut(sidebar.panel);
    end
};

function sidebar:SetBarsShown(numBarsShown)
    self.sv.bars_shown = numBarsShown;
    self.expand:ClearAllPoints();
    self.retract:ClearAllPoints();
    if (self.sv.bars_shown == 2) then
        private:ToggleBartenderBar(self.BTBar2, true);
        private:ToggleBartenderBar(self.BTBar1, true);
        self.panel:SetSize(self.sv.expand_width, self.sv.height);
        self.retract:SetPoint("RIGHT", self.panel, "LEFT");
        self.expand:Hide();
        self.retract:Show();
        self.retract:SetScript("OnClick", private.retract[1]);
    elseif (self.sv.bars_shown == 1) then
        private:ToggleBartenderBar(self.BTBar2, false);
        private:ToggleBartenderBar(self.BTBar1, true);
        self.panel:SetSize(self.sv.retract_width, self.sv.height);
        self.expand:SetPoint("RIGHT", self.panel, "LEFT", 0, 90);
        self.retract:SetPoint("RIGHT", self.panel, "LEFT", 0, -90);
        self.expand:Show();
        self.retract:Show();
        self.expand:SetScript("OnClick", private.expand[2]);
        self.retract:SetScript("OnClick", private.retract[2]);
    elseif (self.sv.bars_shown == 0) then
        private:ToggleBartenderBar(self.BTBar1, false);
        private:ToggleBartenderBar(self.BTBar2, false);
        self.panel:ClearAllPoints();
        self.panel:SetSize(self.sv.retract_width, self.sv.height);
        self.panel:SetPoint("RIGHT", tk.UIParent, "RIGHT", self.sv.retract_width,self.sv.yOffset);
        self.panel:Hide();
        self.expand:Show();
        self.retract:Hide();
        self.expand:SetPoint("RIGHT");
        self.expand:SetScript("OnClick", private.expand[1]);
    end
    if (self.sv.buttons.show_when == "Never") then
        self.expand:Hide();
        self.retract:Hide();
    end
end

function sidebar:CreateSideBar()
    if (self.panel) then return; end
    self.panel = tk.CreateFrame("Frame", "MUI_SideBar", tk.UIParent);
    self.panel:SetPoint("RIGHT", 0, self.sv.yOffset);
    gui:CreateGridTexture(self.panel, tk.Constants.MEDIA.."bottom_ui\\sidebar_panel", 20, nil, 45, 749);
    self.expand = tk.CreateFrame("Button", nil, tk.UIParent);
    self.expand:SetNormalFontObject("MUI_FontSmall");
    self.expand:SetHighlightFontObject("GameFontHighlightSmall");
    self.expand:SetNormalTexture(tk.Constants.MEDIA.."other\\SideButton");
    self.expand:SetSize(self.sv.buttons.width, self.sv.buttons.height);
    self.expand:SetText("<");
    self.retract = tk.CreateFrame("Button", nil, tk.UIParent);
    self.retract:SetNormalFontObject("MUI_FontSmall");
    self.retract:SetHighlightFontObject("GameFontHighlightSmall");
    self.retract:SetNormalTexture(tk.Constants.MEDIA.."other\\SideButton");
    self.retract:SetSize(self.sv.buttons.width, self.sv.buttons.height);
    self.retract:SetText(">");

    if (self.sv.buttons.show_when == "On Mouse-over") then
        self.expand:SetAlpha(0);
        self.retract:SetAlpha(0);
        self.expand:SetScript("OnEnter", private.OnEnter);
        self.expand:SetScript("OnLeave", private.OnLeave);
        self.retract:SetScript("OnEnter", private.OnEnter);
        self.retract:SetScript("OnLeave", private.OnLeave);
    end
end

local function UpdateObjectiveTracker()
    local sv = sidebar.sv.objective_tracker;
    sidebar.objective_container:ClearAllPoints();
    if (sv.anchored_to_sidebars) then
        sidebar.objective_container:SetPoint("TOPRIGHT", sidebar.panel, "TOPLEFT", sv.xOffset, sv.yOffset);
    else
        sidebar.objective_container:SetPoint("CENTER", sv.xOffset, sv.yOffset);
    end
end

function sidebar:SetBartenderBars()
    if (tk.IsAddOnLoaded("Bartender4") and self.sv.bartender.control) then
        local bar1 = self.sv.bartender[1]:match("%d+");
        local bar2 = self.sv.bartender[2]:match("%d+");
        Bartender4:GetModule("ActionBars"):EnableBar(bar1);
        Bartender4:GetModule("ActionBars"):EnableBar(bar2);
        self.BTBar1 = tk._G["BT4Bar"..tk.tostring(bar1)];
        self.BTBar2 = tk._G["BT4Bar"..tk.tostring(bar2)];
    end
end

function sidebar:init()
    if (not MayronUI:IsInstalled()) then return; end
    self.sv = db.profile.sidebar;
    self:SetBartenderBars();
    private.step = self.sv.animate_speed;
    self:CreateSideBar();
    self:SetBarsShown(self.sv.bars_shown);

    em:CreateEventHandler("PET_BATTLE_OPENING_START", function()
        self.panel:Hide();
    end);
    em:CreateEventHandler("PET_BATTLE_CLOSE", function()
        self.panel:Show();
    end);
    if (self.sv.buttons.hide_in_combat) then
        em:CreateEventHandler("PLAYER_REGEN_DISABLED", private.Regen_Disabled):SetKey("SideBar_Buttons");
        em:CreateEventHandler("PLAYER_REGEN_ENABLED", private.Regen_Enabled):SetKey("SideBar_Buttons");
    end

    if (self.sv.objective_tracker.enabled) then
        local sv = sidebar.sv.objective_tracker;

        self.objective_container = tk.CreateFrame("Frame", nil, tk.UIParent);
        self.objective_container:SetSize(self.sv.objective_tracker.width, self.sv.objective_tracker.height);

        if (sv.anchored_to_sidebars) then
            self.objective_container:SetPoint("TOPRIGHT", sidebar.panel, "TOPLEFT", sv.xOffset, sv.yOffset);
        else
            self.objective_container:SetPoint("CENTER", sv.xOffset, sv.yOffset);
        end

        ObjectiveTrackerFrame:SetClampedToScreen(false);
        ObjectiveTrackerFrame:SetParent(self.objective_container);
        ObjectiveTrackerFrame:SetAllPoints(true);

        ObjectiveTrackerFrame.ClearAllPoints = tk.Constants.DUMMY_FUNC;
        ObjectiveTrackerFrame.SetParent = tk.Constants.DUMMY_FUNC;
        ObjectiveTrackerFrame.SetPoint = tk.Constants.DUMMY_FUNC;
        ObjectiveTrackerFrame.SetAllPoints = tk.Constants.DUMMY_FUNC;
    end
end

function sidebar:OnConfigUpdate(list, value)
    local key = list:PopFront();
    if (key == "profile" and list:PopFront() == "sidebar") then
        key = list:PopFront();
        if (key == "objective_tracker") then
            key = list:PopFront();
            if (key == "anchored_to_sidebars" or key == "xOffset" or key == "yOffset") then
                UpdateObjectiveTracker();
            elseif (key == "width") then
                sidebar.objective_container:SetWidth(value);
            elseif (key == "height") then
                sidebar.objective_container:SetHeight(value);
            end
        elseif (key == "retract_width") then
            if (self.sv.bars_shown == 1) then
                self.panel:SetWidth(value);
            end
        elseif (key == "expand_width") then
            if (self.sv.bars_shown == 2) then
                self.panel:SetWidth(value);
            end
        elseif (key == "height") then
            self.panel:SetHeight(value);
        elseif (key == "yOffset") then
            self.panel:SetPoint("RIGHT", 0, value);
        elseif (key == "animate_speed") then
            private.step = value;
        elseif (key == "bartender") then
            self:SetBartenderBars();
        elseif (key == "buttons") then
            key = list:PopFront();
            if (key == "width") then
                self.expand:SetWidth(value);
                self.retract:SetWidth(value);
            elseif (key == "height") then
                self.expand:SetHeight(value);
                self.retract:SetHeight(value);
            elseif (key == "show_when") then
                self.expand:SetShown(value ~= "Never");
                self.retract:SetShown(value ~= "Never");
                if (value == "On Mouse-over") then
                    self.expand:SetAlpha(0);
                    self.retract:SetAlpha(0);
                    self.expand:SetScript("OnEnter", private.OnEnter);
                    self.expand:SetScript("OnLeave", private.OnLeave);
                    self.retract:SetScript("OnEnter", private.OnEnter);
                    self.retract:SetScript("OnLeave", private.OnLeave);
                else
                    self.expand:SetScript("OnEnter", nil);
                    self.expand:SetScript("OnLeave", nil);
                    self.retract:SetScript("OnEnter", nil);
                    self.retract:SetScript("OnLeave", nil);
                    self.expand:SetAlpha(1);
                    self.retract:SetAlpha(1);
                end
                if (self.sv.bars_shown == 2) then
                    self.expand:Hide();
                elseif (self.sv.bars_shown == 0) then
                    self.retract:Hide();
                end
            elseif (key == "hide_in_combat") then
                local handler = em:FindHandlerByKey("PLAYER_REGEN_DISABLED", "SideBar_Buttons");
                if ((value and not handler) or handler:IsDestroyed()) then
                    em:CreateEventHandler("PLAYER_REGEN_DISABLED", private.Regen_Disabled):SetKey("SideBar_Buttons");
                    em:CreateEventHandler("PLAYER_REGEN_ENABLED", private.Regen_Enabled):SetKey("SideBar_Buttons");
                elseif (not value and handler) then
                    em:FindHandlerByKey("PLAYER_REGEN_DISABLED", "SideBar_Buttons"):Destroy()
                    em:FindHandlerByKey("PLAYER_REGEN_ENABLED", "SideBar_Buttons"):Destroy()
                end
                if (value and tk.InCombatLockdown()) then
                    private.Regen_Disabled();
                else
                    private.Regen_Enabled();
                end
            end
        end
    end
end