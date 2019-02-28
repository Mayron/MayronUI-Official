local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");
local AceSerializer = LibStub("AceSerializer-3.0");

local ImportWindow = nil;
local ImportEditBox = nil;
local GroupCopyWhat = nil;
local CopySettingsSelection = {};
local LabelInfo;
local ContainerConfig = nil;
local ContainerConfigId = nil;
local ButtonImport;
local ImportConfig = nil;

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
-- Function CreateImportWindow
-----------------------------------------------------------------
local function CreateImportWindow()

  ImportWindow = AceGUI:Create("Window");
  ImportWindow:Hide();
  ImportWindow:SetTitle("Aura Frames - Import");
  ImportWindow:SetWidth(500);
  ImportWindow:SetHeight(390);
  ImportWindow:EnableResize(false);
  ImportWindow:SetLayout("Flow");
  ImportWindow:SetCallback("OnClose", function()
    AuraFramesConfig:Show();
  end);
  
  ImportEditBox = AceGUI:Create("MultiLineEditBox");
  ImportEditBox:SetRelativeWidth(1.0);
  ImportEditBox:DisableButton(true);
  ImportEditBox:SetLabel("Settings");
  ImportEditBox:SetNumLines(6);
  ImportEditBox:SetCallback("OnTextChanged", function(_, _, Text)
  
    ImportConfig = nil;
  
    local Result, Config = AceSerializer:Deserialize(Text);
    
    if Result == true then
    
      if not Config.Type or not Config.Version then
      
        LabelInfo:SetText("Status: |cfff36a6aInvalid (unknown data)|r\nVersion: |cfff36a6aUnknown|r\n");
        ButtonImport:SetDisabled(true);
      
      elseif Config.Type ~= ContainerConfig.Type then
      
        LabelInfo:SetText("Status: |cfff36a6aInvalid (wrong container type)|r\nVersion: |cfff36a6aUnknown|r\n");
        ButtonImport:SetDisabled(true);
        
      elseif Config.Version > AuraFrames.DatabaseVersion then
      
        LabelInfo:SetText("Status: |cfff36a6aInvalid (higher version then you have installed)|r\nVersion: |cfff36a6a"..Config.Version.."|r\n");
        ButtonImport:SetDisabled(true);

      else
      
        LabelInfo:SetText("Status: |cff6af36aValid|r\nVersion: "..Config.Version.."\n");
        ButtonImport:SetDisabled(false);
        
        ImportConfig = Config;
      
      end
    
    else
    
      LabelInfo:SetText("Status: |cfff36a6aInvalid|r\nVersion: |cfff36a6aUnknown|r\n");
      ButtonImport:SetDisabled(true);
    
    end

  end);
  ImportWindow:AddChild(ImportEditBox);
  
  local Label = AceGUI:Create("Label");
  Label:SetRelativeWidth(1);
  Label:SetText("Press CTRL+V to paste the text from the clipboard.\n");
  ImportWindow:AddChild(Label);
  
  LabelInfo = AceGUI:Create("Label");
  LabelInfo:SetRelativeWidth(1);
  ImportWindow:AddChild(LabelInfo);
  
  GroupCopyWhat = AceGUI:Create("InlineGroup");
  GroupCopyWhat:SetTitle("Copy the following settings");
  GroupCopyWhat:SetRelativeWidth(1);
  GroupCopyWhat:SetLayout("Flow");
  ImportWindow:AddChild(GroupCopyWhat);

  local SpaceLine = AceGUI:Create("Label");
  SpaceLine:SetRelativeWidth(1);
  SpaceLine:SetText(" ");
  ImportWindow:AddChild(SpaceLine);

  local Space = AceGUI:Create("Label");
  Space:SetWidth(30);
  Space:SetText(" ");
  ImportWindow:AddChild(Space);

  ButtonImport = AceGUI:Create("Button");
  ButtonImport:SetText("Import");
  ButtonImport:SetCallback("OnClick", function()
    AuraFramesConfig:CloseImportWindow();
    
    AuraFrames:DatabaseContainerUpgrade(ImportConfig);
    
    for Key, Value in pairs(ImportConfig) do
      if type(Value) == "table" and CopySettingsSelection[Key] and CopySettingsSelection[Key] == true then
        ContainerConfig[Key] = DeepCopy(Value);
      end
    end
      
    AuraFrames:DeleteContainer(ContainerConfigId);
    AuraFrames:CreateContainer(ContainerConfigId);
    
  end);
  ImportWindow:AddChild(ButtonImport);

  local ButtonCancel = AceGUI:Create("Button");
  ButtonCancel:SetText("Cancel");
  ButtonCancel:SetCallback("OnClick", function()
    AuraFramesConfig:CloseImportWindow();
  end);
  ImportWindow:AddChild(ButtonCancel);

end

-----------------------------------------------------------------
-- Function ShowImportWindow
-----------------------------------------------------------------
function AuraFramesConfig:ShowImportWindow(ContainerId)
  
  if not ImportWindow then
    CreateImportWindow();
  end
  
  ImportEditBox:SetText("");
  LabelInfo:SetText("Status: |cfff36a6aInvalid|r\nVersion: |cfff36a6aUnknown|r\n");
  ButtonImport:SetDisabled(true);
  
  CopySettingsSelection = {};
  
  ContainerConfig = AuraFrames.db.profile.Containers[ContainerId];
  ContainerConfigId = ContainerId;
  
  local SettingsToCopy = {};
  
  for Key, Value in pairs(ContainerConfig) do
    if type(Value) == "table" then
      SettingsToCopy[Key] = Key;
    end
  end
  
  GroupCopyWhat:ReleaseChildren();
  
  for Key, Value in pairs(SettingsToCopy) do
  
    local CheckBoxWhat = AceGUI:Create("CheckBox");
    CheckBoxWhat:SetLabel(Value);
    CheckBoxWhat:SetValue(true);
    CheckBoxWhat:SetWidth(130);
    CheckBoxWhat:SetCallback("OnValueChanged", function(_, _, Value)
      CopySettingsSelection[Key] = Value
    end);
    GroupCopyWhat:AddChild(CheckBoxWhat);
    
    CopySettingsSelection[Key] = true;
  
  end
  
  ImportWindow:DoLayout();
  
  ImportWindow:Show();
  
  ImportEditBox:SetFocus();
  
end


-----------------------------------------------------------------
-- Function IsImportWindowShown
-----------------------------------------------------------------
function AuraFramesConfig:IsImportWindowShown()
  
  if ImportWindow then
    return ImportWindow:IsShown() and true or false;
  else
    return false;
  end
  
end

-----------------------------------------------------------------
-- Function CloseImportWindow
-----------------------------------------------------------------
function AuraFramesConfig:CloseImportWindow()
  
  if ImportWindow then
    ImportWindow:Hide();
  end
  
end
