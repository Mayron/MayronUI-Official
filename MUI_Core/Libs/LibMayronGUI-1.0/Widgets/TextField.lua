local Lib = LibStub:GetLibrary("LibMayronGUI");
if (not Lib) then return; end

local WidgetsPackage = Lib.WidgetsPackage;
local Private = Lib.Private;

local TextField = WidgetsPackage:CreateClass("TextField", Private.FrameWrapper);
------------------------------------

function Lib:CreateTextField(style, tooltip)
    return TextField(style, tooltip);
end

local function OnEnable(self)
    local frame = self:GetParent();
    frame:SetBackdropBorderColor(self.themeColor.r, self.themeColor.g, self.themeColor.b, 0.8);
    self:SetAlpha(1);
end

local function OnDisable(self)
    local frame = self:GetParent();
    frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.8);
    self:SetAlpha(0.4);
end

function TextField:__Construct(data, style, tooltip)
    local r, g, b = style:GetColor();
    local backdrop = style:GetBackdrop("ButtonBackdrop");
    data.frame = CreateFrame("Frame");

    data.frame:SetBackdrop(backdrop);
    data.frame:SetBackdropBorderColor(r, g, b, 0.8);

    Private:SetBackground(data.frame, 0, 0, 0, 0.2);
    
    data.editBox = CreateFrame("EditBox", nil, data.frame, "InputBoxTemplate");
    data.editBox:SetPoint("TOPLEFT", data.frame, "TOPLEFT", 5, 0);
    data.editBox:SetPoint("BOTTOMRIGHT", data.frame, "BOTTOMRIGHT", -5, 0);
    data.editBox:SetAutoFocus(false); 

    data.editBox:SetScript("OnEscapePressed", function()
        data.editBox:ClearFocus();        
        self:ApplyPreviousText();    
    end);

    data.editBox:SetScript("OnEnable", OnEnable);
    data.editBox:SetScript("OnDisable", OnDisable);    
    
    Private:HideLayers(data.editBox, Private.LayerTypes.BACKGROUND);

    data.editBox.themeColor = {r, g, b};

    if (tooltip) then
        data.editBox.tooltip = tooltip;
        data.editBox:SetScript("OnEnter", Private.ToolTip_OnEnter);
        data.editBox:SetScript("OnLeave", Private.ToolTip_OnLeave);
    end
end

function TextField:SetText(data, text)
    data.previousText = data.editBox:GetText();
    data.editBox:SetText(text);
end

function TextField:GetText(data)
    return data.editBox:GetText();
end

function TextField:GetPreviousText(data)
    return data.previousText;
end

function TextField:ApplyPreviousText(data)
    local currentText = data.editBox:GetText();
    data.editBox:SetText(data.previousText);
    data.previousText = currentText;
end

function TextField:GetEditBox(data)
    return data.editBox;
end

function TextField:OnTextChanged(data, callback)
    data.editBox:SetScript("OnEnterPressed", function()
        data.editBox:ClearFocus();
        callback(self, data.editBox:GetText(), data.previousText);
    end);
end