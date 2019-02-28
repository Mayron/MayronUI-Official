local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local Module = AuraFramesConfig:GetModule("TimeLineContainer");
local AceGUI = LibStub("AceGUI-3.0");
--local LBF = LibStub("LibButtonFacade", true);
local LSM = LibStub("LibSharedMedia-3.0");


-----------------------------------------------------------------
-- Function ContentLayoutSkin
-----------------------------------------------------------------
function Module:ContentLayoutSkin(Content, ContainerId)

  local LayoutConfig = AuraFrames.db.profile.Containers[ContainerId].Layout;
  local ContainerInstance = AuraFrames.Containers[ContainerId];

  Content:SetLayout("List");

  Content:AddText("Skin\n", GameFontNormalLarge);
  
  Content:AddHeader("Background");
  
  local BackgroundGroup = AceGUI:Create("SimpleGroup");
  BackgroundGroup:SetRelativeWidth(1);
  AuraFramesConfig:EnhanceContainer(BackgroundGroup);
  BackgroundGroup:SetLayout("Flow");
  Content:AddChild(BackgroundGroup);
  
  local BackgroundTexture = AceGUI:Create("LSM30_Statusbar");
  BackgroundTexture:SetList(LSM:HashTable("statusbar"));
  BackgroundTexture:SetLabel("Texture");
  BackgroundTexture:SetValue(LayoutConfig.BackgroundTexture);
  BackgroundTexture:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BackgroundTexture = Value;
    ContainerInstance:Update("LAYOUT");
    BackgroundTexture:SetValue(Value);
  end);
  BackgroundGroup:AddChild(BackgroundTexture);
  
  local BackgroundTextureInsets = AceGUI:Create("Slider");
  BackgroundTextureInsets:SetWidth(150);
  BackgroundTextureInsets:SetValue(LayoutConfig.BackgroundTextureInsets);
  BackgroundTextureInsets:SetLabel("Background insets");
  BackgroundTextureInsets:SetSliderValues(0, 16, 1);
  BackgroundTextureInsets:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BackgroundTextureInsets = Value;
    ContainerInstance:Update("LAYOUT");
    Module:Update(ContainerId);
  end);
  BackgroundGroup:AddChild(BackgroundTextureInsets);
  
  local BackgroundTextureColor = AceGUI:Create("ColorPicker");
  BackgroundTextureColor:SetWidth(150);
  BackgroundTextureColor:SetHasAlpha(true);
  BackgroundTextureColor:SetColor(unpack(LayoutConfig.BackgroundTextureColor));
  BackgroundTextureColor:SetLabel("Texture color");
  BackgroundTextureColor:SetCallback("OnValueChanged", function(_, _, ...)
    LayoutConfig.BackgroundTextureColor = {...};
    ContainerInstance:Update("LAYOUT");
  end);
  BackgroundGroup:AddChild(BackgroundTextureColor);
  
  local BackgroundTextureRotate = AceGUI:Create("CheckBox");
  BackgroundTextureRotate:SetLabel("Rotate background texture");
  --BackgroundTextureRotate:SetDescription("");
  BackgroundTextureRotate:SetValue(LayoutConfig.BackgroundTextureRotate);
  BackgroundTextureRotate:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BackgroundTextureRotate = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  BackgroundGroup:AddChild(BackgroundTextureRotate);
  
  local BackgroundTextureFlipX = AceGUI:Create("CheckBox");
  BackgroundTextureFlipX:SetLabel("Flip horizontal");
  --BackgroundTextureFlipX:SetDescription("");
  BackgroundTextureFlipX:SetWidth(150);
  BackgroundTextureFlipX:SetValue(LayoutConfig.BackgroundTextureFlipX);
  BackgroundTextureFlipX:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BackgroundTextureFlipX = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  BackgroundGroup:AddChild(BackgroundTextureFlipX);
  
  local BackgroundTextureFlipY = AceGUI:Create("CheckBox");
  BackgroundTextureFlipY:SetLabel("Flip vertical");
  --BackgroundTextureFlipY:SetDescription("");
  BackgroundTextureFlipY:SetWidth(150);
  BackgroundTextureFlipY:SetValue(LayoutConfig.BackgroundTextureFlipY);
  BackgroundTextureFlipY:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BackgroundTextureFlipY = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  BackgroundGroup:AddChild(BackgroundTextureFlipY);
  
  BackgroundGroup:AddSpace();
  
  local BackgroundBorder = AceGUI:Create("LSM30_Border");
  BackgroundBorder:SetList(LSM:HashTable("border"));
  BackgroundBorder:SetLabel("Border");
  BackgroundBorder:SetValue(LayoutConfig.BackgroundBorder);
  BackgroundBorder:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BackgroundBorder = Value;
    ContainerInstance:Update("LAYOUT");
    BackgroundBorder:SetValue(Value);
  end);
  BackgroundGroup:AddChild(BackgroundBorder);
  
  local BackgroundBorderSize = AceGUI:Create("Slider");
  BackgroundBorderSize:SetWidth(150);
  BackgroundBorderSize:SetValue(LayoutConfig.BackgroundBorderSize);
  BackgroundBorderSize:SetLabel("Border size");
  BackgroundBorderSize:SetSliderValues(2, 24, 1);
  BackgroundBorderSize:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BackgroundBorderSize = Value;
    ContainerInstance:Update("LAYOUT");
    Module:Update(ContainerId);
  end);
  BackgroundGroup:AddChild(BackgroundBorderSize);
  
  local BackgroundBorderColor = AceGUI:Create("ColorPicker");
  BackgroundBorderColor:SetWidth(150);
  BackgroundBorderColor:SetHasAlpha(true);
  BackgroundBorderColor:SetColor(unpack(LayoutConfig.BackgroundBorderColor));
  BackgroundBorderColor:SetLabel("Border color");
  BackgroundBorderColor:SetCallback("OnValueChanged", function(_, _, ...)
    LayoutConfig.BackgroundBorderColor = {...};
    ContainerInstance:Update("LAYOUT");
  end);
  BackgroundGroup:AddChild(BackgroundBorderColor);

end
