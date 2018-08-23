local Lib = LibStub:GetLibrary("LibMayronGUI");
if (not Lib) then return; end

local WidgetsPackage = Lib.WidgetsPackage;
local Private = Lib.Private;

local TextField = WidgetsPackage:CreateClass("TextField", Private.FrameWrapper);
------------------------------------

local OnEscapePressed = function(self)
    self:ClearFocus();
end

local function OnEnable(self)
    local container = self:GetParent();
    container:SetBackdropBorderColor(self.r, self.g, self.b, 0.8);
    self:SetAlpha(1);
end

local function OnDisable(self)
    local container = self:GetParent();
    container:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.8);
    self:SetAlpha(0.4);
end

function TextField:__Construct(data, tooltip, style)
    local r, g, b = style:GetThemeColor();
    local backdrop = style:GetBackdrop();
    local container = CreateFrame("Frame");

    container:SetBackdrop(backdrop);
    container:SetBackdropBorderColor(r, g, b, 0.8);

    Private:SetBackground(container, 0, 0, 0, 0.2);
    Private:HideLayers(container.field, Private.LayerTypes.BACKGROUND);

    container.field = CreateFrame("EditBox", nil, container, "InputBoxTemplate");
    container.field:SetPoint("TOPLEFT", container, "TOPLEFT", 5, 0);
    container.field:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -5, 0);
    container.field:SetAutoFocus(false);      
    container.field:SetScript("OnEscapePressed", OnEscapePressed);
    container.field:SetScript("OnEnable", OnEnable);
    container.field:SetScript("OnDisable", OnDisable);

    container.field.ThemeColor = {r, g, b}

    if (tooltip) then
        container.field.tooltip = tooltip;
        container.field:SetScript("OnEnter", Private.ToolTip_OnEnter);
        container.field:SetScript("OnLeave", Private.ToolTip_OnLeave);
    end

    return container;
end