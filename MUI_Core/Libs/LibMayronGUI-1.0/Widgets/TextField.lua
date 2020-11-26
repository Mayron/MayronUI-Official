-- luacheck: ignore MayronUI self 143 631

---@type LibMayronGUI
local Lib = _G.LibStub:GetLibrary("LibMayronGUI");

if (not Lib) then return; end

local WidgetsPackage = Lib.WidgetsPackage;
local Private = Lib.Private;
local obj = Lib.Objects;
local TextField = WidgetsPackage:CreateClass("TextField", Private.FrameWrapper);
local unpack, CreateFrame = _G.unpack, _G.CreateFrame;

------------------------------------
function Lib:CreateTextField(style, tooltip, parent)
    return TextField(style, tooltip, parent);
end

local function OnEnable(self)
    local frame = self:GetParent();
    frame.bg:SetVertexColor(self.themeColor[1], self.themeColor[2], self.themeColor[3]);
    self:SetAlpha(1);
end

local function OnDisable(self)
    local frame = self:GetParent();
    local r, g, b = _G.DISABLED_FONT_COLOR:GetRGB();
    frame.bg:SetVertexColor(r, g, b);
    self:SetAlpha(0.7);
end

function TextField:__Construct(data, style, tooltip, parent)
    local r, g, b = style:GetColor();
    data.frame = Private:PopFrame("Frame", parent);
    data.frame:SetSize(150, 28);

    local background = style:GetTexture("TextField");
    data.frame.bg = Private:SetBackground(data.frame, background);
    data.frame.bg:SetVertexColor(r, g, b);

    data.editBox = CreateFrame("EditBox", nil, data.frame, "InputBoxTemplate");
    data.editBox:SetPoint("TOPLEFT", data.frame, "TOPLEFT", 8, 0);
    data.editBox:SetPoint("BOTTOMRIGHT", data.frame, "BOTTOMRIGHT", -8, 0);
    data.editBox:SetAutoFocus(false);

    data.editBox:SetScript("OnEscapePressed", function()
        data.editBox:ClearFocus();
        self:ApplyPreviousText();
    end);

    data.editBox:SetScript("OnEnable", OnEnable);
    data.editBox:SetScript("OnDisable", OnDisable);

    Private:HideLayers(data.editBox, Private.LayerTypes.BACKGROUND);

    data.editBox.themeColor = obj:PopTable(r, g, b);

    if (tooltip) then
        data.editBox.tooltip = tooltip;
        data.editBox:SetScript("OnEnter", Private.ToolTip_OnEnter);
        data.editBox:SetScript("OnLeave", Private.ToolTip_OnLeave);
    end
end

function TextField:SetEnabled(data, enabled)
    data.editBox:SetEnabled(enabled);
end

function TextField:SetText(data, text)
    data.previousText = text;
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

  if (data.previousText) then
    data.editBox:SetText(data.previousText);
  else
    data.editBox:SetText("");
  end
  data.previousText = currentText;
end

function TextField:GetEditBox(data)
    return data.editBox;
end

function TextField:OnTextChanged(data, callback, ...)
    local args = obj:PopTable(...);

    data.editBox:SetScript("OnEnterPressed", function()
        data.editBox:ClearFocus();
        callback(self, data.editBox:GetText(), data.previousText, unpack(args));
    end);
end