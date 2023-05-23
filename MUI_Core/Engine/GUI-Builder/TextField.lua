-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, _, obj = MayronUI:GetCoreComponents();

---@class MayronUI.GUIBuilder
local gui = MayronUI:GetComponent("GUIBuilder");

local TextField = obj:CreateClass("TextField");
obj:Export(TextField, "MayronUI");

local unpack = _G.unpack;

------------------------------------
function gui:CreateTextField(parent)
  return TextField(parent);
end

local function OnEnable(self)
  local frame = self:GetParent();
  tk:ApplyThemeColor(frame.bg);
  self:SetAlpha(1);
end

local function OnDisable(self)
  local frame = self:GetParent();
  local r, g, b = _G.DISABLED_FONT_COLOR:GetRGB();
  frame.bg:SetVertexColor(r, g, b);
  self:SetAlpha(0.7);
end

function TextField:__Construct(data, parent)
  data.frame = tk:CreateFrame("Frame", parent);
  data.frame:SetSize(120, 28);

  local background = tk:GetAssetFilePath("Textures\\Widgets\\TextField");
  data.frame.bg = tk:SetBackground(data.frame, background);
  tk:ApplyThemeColor(data.frame.bg);

  data.editBox = tk:CreateFrame("EditBox", data.frame, nil, "InputBoxTemplate");
  data.editBox:SetPoint("TOPLEFT", data.frame, "TOPLEFT", 8, 0);
  data.editBox:SetPoint("BOTTOMRIGHT", data.frame, "BOTTOMRIGHT", -8, 0);
  data.editBox:SetAutoFocus(false);

  data.editBox:SetScript("OnEscapePressed", function()
    data.editBox:ClearFocus();
    self:ApplyPreviousText();
  end);

  data.editBox:SetScript("OnEnable", OnEnable);
  data.editBox:SetScript("OnDisable", OnDisable);

  tk:KillAllElements(data.editBox.Middle, data.editBox.Left, data.editBox.Right);
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