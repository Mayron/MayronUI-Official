local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local Module = AuraFramesConfig:GetModule("BarContainer");
local AceGUI = LibStub("AceGUI-3.0");
--local LBF = LibStub("LibButtonFacade", true);
local LSM = LibStub("LibSharedMedia-3.0");


-----------------------------------------------------------------
-- Local Function BackgroundContent
-----------------------------------------------------------------
local function BackgroundContent(Content, ContainerId)

  local LayoutConfig = AuraFrames.db.profile.Containers[ContainerId].Layout;
  local ContainerInstance = AuraFrames.Containers[ContainerId];

  Content:PauseLayout();
  Content:ReleaseChildren();
  
  Content:SetLayout("List");
  
  local BackgroundGroup = AceGUI:Create("SimpleGroup");
  BackgroundGroup:SetLayout("Flow");
  BackgroundGroup:SetRelativeWidth(1);
  Content:AddChild(BackgroundGroup);
  
  local UseTexture = AceGUI:Create("CheckBox");
  UseTexture:SetRelativeWidth(1);
  UseTexture:SetLabel("Use as background the bar texture");
  UseTexture:SetDescription("You can change the color and opacity of an texture when using this.");
  UseTexture:SetValue(LayoutConfig.TextureBackgroundUseTexture);
  UseTexture:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TextureBackgroundUseTexture = Value;
    ContainerInstance:Update("LAYOUT");
    BackgroundContent(Content, ContainerId);
  end);
  BackgroundGroup:AddChild(UseTexture);
  
  local UseBarColor = AceGUI:Create("CheckBox");
  UseBarColor:SetWidth(300);
  UseBarColor:SetLabel("Use the color from the bar");
  UseBarColor:SetDescription("The color of the main bar will also be used as background, you can still change the opacity of the background.");
  UseBarColor:SetValue(LayoutConfig.TextureBackgroundUseBarColor);
  UseBarColor:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TextureBackgroundUseBarColor = Value;
    BackgroundContent(Content, ContainerId);
    ContainerInstance:Update("LAYOUT");
  end);
  BackgroundGroup:AddChild(UseBarColor);
  
  if LayoutConfig.TextureBackgroundUseBarColor == true then
  
    local TextureBackgroundOpacity = AceGUI:Create("Slider");
    TextureBackgroundOpacity:SetValue(LayoutConfig.TextureBackgroundOpacity);
    TextureBackgroundOpacity:SetLabel("The opacity of the texture");
    TextureBackgroundOpacity:SetSliderValues(0, 1, 0.01);
    TextureBackgroundOpacity:SetIsPercent(true);
    TextureBackgroundOpacity:SetCallback("OnValueChanged", function(_, _, Value)
      LayoutConfig.TextureBackgroundOpacity = Value;
      ContainerInstance:Update("LAYOUT");
    end);
    BackgroundGroup:AddChild(TextureBackgroundOpacity);
    
  else
    
    local ColorBarBackground = AceGUI:Create("ColorPicker");
    ColorBarBackground:SetHasAlpha(true);
    ColorBarBackground:SetColor(unpack(LayoutConfig.TextureBackgroundColor));
    ColorBarBackground:SetLabel("Bar Background");
    ColorBarBackground:SetCallback("OnValueChanged", function(_, _, ...)
      LayoutConfig.TextureBackgroundColor = {...};
      ContainerInstance:Update("LAYOUT");
    end);
    BackgroundGroup:AddChild(ColorBarBackground);
  
  end
  
  Content:AddSpace();
  
  Content:ResumeLayout();
  Content:DoLayout();

end


-----------------------------------------------------------------
-- Function ContentLayoutSkin
-----------------------------------------------------------------
function Module:ContentLayoutSkin(Content, ContainerId)

  local LayoutConfig = AuraFrames.db.profile.Containers[ContainerId].Layout;
  local ContainerInstance = AuraFrames.Containers[ContainerId];

  Content:SetLayout("List");

  Content:AddText("Skin\n", GameFontNormalLarge);
  
  Content:AddHeader("Bar texture");
  
  local BarGroup = AceGUI:Create("SimpleGroup");
  BarGroup:SetRelativeWidth(1);
  AuraFramesConfig:EnhanceContainer(BarGroup);
  BarGroup:SetLayout("Flow");
  Content:AddChild(BarGroup);
  
  local BarTexture = AceGUI:Create("LSM30_Statusbar");
  BarTexture:SetList(LSM:HashTable("statusbar"));
  BarTexture:SetLabel("Bar Texture");
  BarTexture:SetValue(LayoutConfig.BarTexture);
  BarTexture:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BarTexture = Value;
    ContainerInstance:Update("LAYOUT");
    BarTexture:SetValue(Value);
  end);
  BarGroup:AddChild(BarTexture);
  
  local BarTextureInsets = AceGUI:Create("Slider");
  BarTextureInsets:SetWidth(150);
  BarTextureInsets:SetValue(LayoutConfig.BarTextureInsets);
  BarTextureInsets:SetLabel("Background insets");
  BarTextureInsets:SetSliderValues(0, 16, 1);
  BarTextureInsets:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BarTextureInsets = Value;
    ContainerInstance:Update("LAYOUT");
    Module:Update(ContainerId);
  end);
  BarGroup:AddChild(BarTextureInsets);
  
  local BarTextureMove = AceGUI:Create("CheckBox");
  BarTextureMove:SetWidth(150);
  BarTextureMove:SetLabel("Bar texture moving");
  BarTextureMove:SetDescription("Is the bar texture moving or standing still.");
  BarTextureMove:SetValue(LayoutConfig.BarTextureMove);
  BarTextureMove:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BarTextureMove = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  BarGroup:AddChild(BarTextureMove);
  
  local BarTextureRotate = AceGUI:Create("CheckBox");
  BarTextureRotate:SetLabel("Rotate bar texture");
  --BarTextureRotate:SetDescription("");
  BarTextureRotate:SetValue(LayoutConfig.BarTextureRotate);
  BarTextureRotate:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BarTextureRotate = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  BarGroup:AddChild(BarTextureRotate);
  
  local BarTextureFlipX = AceGUI:Create("CheckBox");
  BarTextureFlipX:SetLabel("Flip horizontal");
  --BarTextureFlipX:SetDescription("");
  BarTextureFlipX:SetWidth(150);
  BarTextureFlipX:SetValue(LayoutConfig.BarTextureFlipX);
  BarTextureFlipX:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BarTextureFlipX = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  BarGroup:AddChild(BarTextureFlipX);
  
  local BarTextureFlipY = AceGUI:Create("CheckBox");
  BarTextureFlipY:SetLabel("Flip vertical");
  --BarTextureFlipY:SetDescription("");
  BarTextureFlipY:SetWidth(150);
  BarTextureFlipY:SetValue(LayoutConfig.BarTextureFlipY);
  BarTextureFlipY:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BarTextureFlipY = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  BarGroup:AddChild(BarTextureFlipY);
  
  BarGroup:AddSpace();
  
  local BarBorder = AceGUI:Create("LSM30_Border");
  BarBorder:SetList(LSM:HashTable("border"));
  BarBorder:SetLabel("Border");
  BarBorder:SetValue(LayoutConfig.BarBorder);
  BarBorder:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BarBorder = Value;
    ContainerInstance:Update("LAYOUT");
    BarBorder:SetValue(Value);
  end);
  BarGroup:AddChild(BarBorder);
  
  local BarBorderSize = AceGUI:Create("Slider");
  BarBorderSize:SetWidth(150);
  BarBorderSize:SetValue(LayoutConfig.BarBorderSize);
  BarBorderSize:SetLabel("Border size");
  BarBorderSize:SetSliderValues(2, 24, 1);
  BarBorderSize:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BarBorderSize = Value;
    ContainerInstance:Update("LAYOUT");
    Module:Update(ContainerId);
  end);
  BarGroup:AddChild(BarBorderSize);
  
  local BarBorderColorAdjust = AceGUI:Create("Slider");
  BarBorderColorAdjust:SetWidth(150);
  BarBorderColorAdjust:SetIsPercent(true);
  BarBorderColorAdjust:SetValue(LayoutConfig.BarBorderColorAdjust);
  BarBorderColorAdjust:SetLabel("Border dark adjust");
  BarBorderColorAdjust:SetSliderValues(0, 2, 0.01);
  BarBorderColorAdjust:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BarBorderColorAdjust = Value;
    ContainerInstance:Update("LAYOUT");
    Module:Update(ContainerId);
  end);
  BarGroup:AddChild(BarBorderColorAdjust);
  
  Content:AddSpace();

  Content:AddHeader("Spark");
  
  local SparkUseBarColor, SparkColor, HideSparkOnNoTime;
  
  local SparkGroup = AceGUI:Create("SimpleGroup");
  SparkGroup:SetRelativeWidth(1);
  SparkGroup:SetLayout("Flow");
  Content:AddChild(SparkGroup);

  local ShowSpark = AceGUI:Create("CheckBox");
  ShowSpark:SetWidth(250);
  ShowSpark:SetLabel("Enable Spark");
  ShowSpark:SetDescription("Show a spark at the moving side of the bar.");
  ShowSpark:SetValue(LayoutConfig.ShowSpark);
  ShowSpark:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ShowSpark = Value;
    ContainerInstance:Update("LAYOUT");
    
    HideSparkOnNoTime:SetDisabled(not LayoutConfig.ShowSpark);
    SparkUseBarColor:SetDisabled(not LayoutConfig.ShowSpark);
    SparkColor:SetDisabled(not LayoutConfig.ShowSpark or LayoutConfig.SparkUseBarColor);
    
  end);
  SparkGroup:AddChild(ShowSpark);
  
  HideSparkOnNoTime = AceGUI:Create("CheckBox");
  HideSparkOnNoTime:SetWidth(270);
  HideSparkOnNoTime:SetLabel("Hide Spark on no time");
  HideSparkOnNoTime:SetDescription("Hide the spark when the aura don't have an expiration time.");
  HideSparkOnNoTime:SetValue(LayoutConfig.HideSparkOnNoTime);
  HideSparkOnNoTime:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.HideSparkOnNoTime = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  SparkGroup:AddChild(HideSparkOnNoTime);
  
  SparkUseBarColor = AceGUI:Create("CheckBox");
  SparkUseBarColor:SetWidth(250);
  SparkUseBarColor:SetLabel("Use bar color");
  SparkUseBarColor:SetDisabled(not LayoutConfig.ShowSpark);
  SparkUseBarColor:SetDescription("Use the bar color for the spark.");
  SparkUseBarColor:SetValue(LayoutConfig.SparkUseBarColor);
  SparkUseBarColor:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.SparkUseBarColor = Value;
    ContainerInstance:Update("LAYOUT");
    
    SparkColor:SetDisabled(not LayoutConfig.ShowSpark or LayoutConfig.SparkUseBarColor);
    
  end);
  SparkGroup:AddChild(SparkUseBarColor);

  SparkColor = AceGUI:Create("ColorPicker");
  SparkColor:SetWidth(250);
  SparkColor:SetHasAlpha(true);
  SparkColor:SetDisabled(not LayoutConfig.ShowSpark or LayoutConfig.SparkUseBarColor);
  SparkColor:SetColor(unpack(LayoutConfig.SparkColor));
  SparkColor:SetLabel("Spark color");
  SparkColor:SetCallback("OnValueChanged", function(_, _, ...)
    LayoutConfig.SparkColor = {...};
    ContainerInstance:Update("LAYOUT");
  end);
  SparkGroup:AddChild(SparkColor);

  Content:AddSpace();

--[[

  Content:AddHeader("ButtonFacade");
  
  if not LBF then
  
    Content:AddText("ButtonFacade is used for skinning the buttons.\n\nThe ButtonFacade addon is not found, please install or enable ButtonFacade addon if you want to use custom button skinning.");
  
  else

    Content:AddText("ButtonFacade is used for skinning the buttons.\n");
    
    local ContentButtonFacade = AceGUI:Create("SimpleGroup");
    ContentButtonFacade:SetRelativeWidth(1);
    Content:AddChild(ContentButtonFacade);
    AuraFramesConfig:EnhanceContainer(ContentButtonFacade);

    AuraFramesConfig:ContentButtonFacade(ContentButtonFacade, ContainerInstance.LBFGroup);
  
  end
  
  Content:AddSpace();
  
]]--
  
  Content:AddHeader("Background Texture and Colors");
  
  local ContentBackground = AceGUI:Create("SimpleGroup");
  ContentBackground:SetRelativeWidth(1);
  Content:AddChild(ContentBackground);
  AuraFramesConfig:EnhanceContainer(ContentBackground);
  
  BackgroundContent(ContentBackground, ContainerId);

end
