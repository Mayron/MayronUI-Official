local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");

local ContainerName = "";
local ContainerTypeControls = {};
local ContainerType = "";

-----------------------------------------------------------------
-- Local Function CreateContainerConfig
-----------------------------------------------------------------
local function CreateContainerConfig()

  if strlen(ContainerName) == 0 then
    AuraFramesConfig:Close();
    AuraFrames:Message("Please provide a container name, this is required!", function() AuraFramesConfig:Show(); end);
    return
  end
  
  local Found = false;
  
  for _, Container in pairs(AuraFrames.db.profile.Containers) do
  
    if ContainerName == Container.Name then
      Found = true;
      break;
    end
  
  end
  
  if Found == true then
    AuraFramesConfig:Close();
    AuraFrames:Message("The container name you provided is already used. Please provide an unique name!", function() AuraFramesConfig:Show(); end);
    return
  end

  if strlen(ContainerType) == 0 then
    AuraFramesConfig:Close();
    AuraFrames:Message("Please select a container type, this is required!", function() AuraFramesConfig:Show(); end);
    return
  end
  
  -- Create config.
  local ContainerId = AuraFrames:CreateNewContainerConfig(ContainerName, ContainerType);

  if not ContainerId then
    AuraFramesConfig:Close();
    AuraFrames:Message("Failed to create the container! Please contact the addon author!", function() AuraFramesConfig:Show(); end);
    return;
  end
  
  -- Create instance.
  AuraFrames:CreateContainer(ContainerId);
  
  -- If ContainersUnlocked then unlock the new container also.
  if AuraFramesConfig.ContainersUnlocked then
  
    if not AuraFramesConfig:IsEnabled(ContainerType) then
      AuraFramesConfig:Enable(ContainerType);
    end
  
    AuraFramesConfig:GetModule(ContainerType):UnlockContainer(ContainerId, false);
  
  end
  
  wipe(ContainerTypeControls);
  
  AuraFramesConfig:RefreshTree();
  AuraFramesConfig:SelectByPath("Containers", ContainerId);

end


-----------------------------------------------------------------
-- Function ContentContainersRefresh
-----------------------------------------------------------------
function AuraFramesConfig:ContentContainersRefresh(Content)

  ContainerName = "";
  ContainerTypeControls = {};
  ContainerType = "";

  Content:PauseLayout();
  Content:ReleaseChildren();

  Content:SetLayout("List");
  
  Content:AddText("Containers\n", GameFontNormalLarge);
  Content:AddText("Containers are used for grouping aura's together. There are different kind of containers, every type with there own ways of displaying aura's. You can create multiple containers.\n\n");

  local UnlockInfo = AceGUI:Create("SimpleGroup");
  UnlockInfo:SetRelativeWidth(1);
  UnlockInfo:SetLayout("Flow");
  AuraFramesConfig:EnhanceContainer(UnlockInfo);
  Content:AddChild(UnlockInfo);

  UnlockInfo:AddText("Containers can only be moved when they are unlocked. Unlock all containers by clicking the following button in the titlebar:", nil, 400);
  local UnlockIcon = AceGUI:Create("Label");
  UnlockIcon:SetText("");
  UnlockIcon:SetWidth(50);
  UnlockIcon:SetImage("Interface\\Buttons\\UI-Panel-CollapseButton-Up");
  UnlockIcon:SetImageSize(32, 32);
  UnlockInfo:AddChild(UnlockIcon);
  
  Content:AddSpace(2);

  Content:AddHeader("Create new container");
  
  Content:AddText("Every container must have is own unique name. This name is used to identity the container.\n");

  local LabelIdInfo;
  
  local NameValue = AceGUI:Create("EditBox");
  NameValue:DisableButton(true);
  NameValue:SetText("");
  NameValue:SetLabel("Name");
  NameValue:SetWidth(150);
  NameValue:SetCallback("OnTextChanged", function(_, _, Text)
    ContainerName = Text;
    LabelIdInfo:SetText("Container id: "..AuraFrames:GenerateContainerId(Text));
  end);
  Content:AddChild(NameValue);

  LabelIdInfo = Content:AddText("Container id: ", GameFontNormalSmall);
  
  Content:AddSpace(2);

  Content:AddText("There are different types of containers. Every type have his own way of displaying aura's. You must select an type for this container, this can not be changed after the container is created.\n\nContainer type:\n");

  for Type, Module in pairs(AuraFrames.ContainerModules) do
  
    if not Module:IsEnabled() then
      Module:Enable();
    end
  
    local TypeControl = AceGUI:Create("CheckBox");
    TypeControl.ContainerType = Type;
    TypeControl:SetType("radio");
    TypeControl:SetValue(false);
    TypeControl:SetRelativeWidth(1);
    TypeControl:SetLabel(Module:GetName());
    TypeControl:SetDescription(Module:GetDescription() .. "\n");
    TypeControl:SetCallback("OnValueChanged", function(_, _, Value)
      if Value == false then
        TypeControl:SetValue(true);
        return;
      end
      ContainerType = Type;
      for _, Control in ipairs(ContainerTypeControls) do
        if Type ~= Control.ContainerType then
          Control:SetValue(false);
        end
      end
    end);
    Content:AddChild(TypeControl);
    
    table.insert(ContainerTypeControls, TypeControl);

  end

  Content:AddSpace();

  local ButtonCreate = AceGUI:Create("Button");
  ButtonCreate:SetText("Create new container");
  ButtonCreate:SetCallback("OnClick", function()
    CreateContainerConfig();
  end);
  Content:AddChild(ButtonCreate);
  
  Content:AddSpace();

  Content:ResumeLayout();
  Content:DoLayout();

end

-----------------------------------------------------------------
-- Function ContentContainers
-----------------------------------------------------------------
function AuraFramesConfig:ContentContainers()

  self.Content:SetLayout("Fill");
  
  local Content = AceGUI:Create("ScrollFrame");
  Content:SetLayout("List");
  self:EnhanceContainer(Content);
  self.Content:AddChild(Content);
  
  self:ContentContainersRefresh(Content);
  
end

