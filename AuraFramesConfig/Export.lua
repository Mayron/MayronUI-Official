local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");
local AceSerializer = LibStub("AceSerializer-3.0");

local ExportWindow = nil;
local ExportEditBox = nil;
local ExportString = "";

-----------------------------------------------------------------
-- Function DeepCopy
-----------------------------------------------------------------
local function DeepCopy(object)

  local lookup_table = {}

  local function _copy(object)
    if type(object) ~= "table" then
      return object
    elseif lookup_table[object] then
      return lookup_table[object]
    end
    local new_table = {}
    lookup_table[object] = new_table
    for index, value in pairs(object) do
      new_table[_copy(index)] = _copy(value)
    end
    return setmetatable(new_table, getmetatable(object))
  end

  return _copy(object)

end


-----------------------------------------------------------------
-- Function CreateExportWindow
-----------------------------------------------------------------
local function CreateExportWindow()

  ExportWindow = AceGUI:Create("Window");
  ExportWindow:Hide();
  ExportWindow:SetTitle("Aura Frames - Export");
  ExportWindow:SetWidth(500);
  ExportWindow:SetHeight(300);
  ExportWindow:EnableResize(false);
  ExportWindow:SetLayout("Flow");
  ExportWindow:SetCallback("OnClose", function()
    AuraFramesConfig:Show();
  end);
  
  ExportEditBox = AceGUI:Create("MultiLineEditBox");
  ExportEditBox:SetRelativeWidth(1.0);
  ExportEditBox:DisableButton(true);
  ExportEditBox:SetLabel("Settings");
  ExportEditBox:SetNumLines(12);
  ExportEditBox:SetCallback("OnTextChanged", function()
    ExportEditBox:SetText(ExportString);
    ExportEditBox.editBox:HighlightText(0, ExportEditBox.editBox:GetNumLetters());
  end);
  ExportEditBox:SetCallback("OnEnter", function()
    ExportEditBox.editBox:HighlightText(0, ExportEditBox.editBox:GetNumLetters());
  end);
  ExportWindow:AddChild(ExportEditBox);
  
  local Label = AceGUI:Create("Label");
  Label:SetRelativeWidth(1);
  Label:SetText("Press CTRL+C to copy the text to the clipboard.\n");
  ExportWindow:AddChild(Label);

  local Space = AceGUI:Create("Label");
  Space:SetWidth(150);
  Space:SetText(" ");
  ExportWindow:AddChild(Space);

  local ButtonClose = AceGUI:Create("Button");
  ButtonClose:SetText("Close");
  ButtonClose:SetCallback("OnClick", function()
    AuraFramesConfig:CloseExportWindow();
  end);
  ExportWindow:AddChild(ButtonClose);

end

-----------------------------------------------------------------
-- Function ShowExportWindow
-----------------------------------------------------------------
function AuraFramesConfig:ShowExportWindow(ContainerId)
  
  if not ExportWindow then
    CreateExportWindow();
  end
  
  local ContainerConfig = AuraFrames.db.profile.Containers[ContainerId];
  
  local ExportConfig = {};
  
  for Key, Value in pairs(ContainerConfig) do
    if type(Value) == "table" then
      ExportConfig[Key] = ContainerConfig[Key];
    end
  end
  
  ExportConfig.Version = AuraFrames.DatabaseVersion;
  ExportConfig.Type = ContainerConfig.Type;
  
  ExportString = AceSerializer:Serialize(ExportConfig);

  ExportEditBox:SetText(ExportString);

  ExportWindow:Show();
  
  ExportEditBox:SetFocus();
  
end


-----------------------------------------------------------------
-- Function IsExportWindowShown
-----------------------------------------------------------------
function AuraFramesConfig:IsExportWindowShown()
  
  if ExportWindow then
    return ExportWindow:IsShown() and true or false;
  else
    return false;
  end
  
end

-----------------------------------------------------------------
-- Function CloseExportWindow
-----------------------------------------------------------------
function AuraFramesConfig:CloseExportWindow()
  
  if ExportWindow then
    ExportWindow:Hide();
  end
  
end
