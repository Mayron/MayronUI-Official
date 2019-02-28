local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local Module = AuraFramesConfig:GetModule("TimeLineContainer");
local AceGUI = LibStub("AceGUI-3.0");


-----------------------------------------------------------------
-- Function ContentLayoutSizeAndScale
-----------------------------------------------------------------
function Module:ContentLayoutSizeAndScale(Content, ContainerId)

  local LayoutConfig = AuraFrames.db.profile.Containers[ContainerId].Layout;
  local ContainerInstance = AuraFrames.Containers[ContainerId];

  Content:SetLayout("List");

  Content:AddText("Size and Scale\n", GameFontNormalLarge);
  
  Content:AddHeader("Size");
  Content:AddSpace();
  
  local SizeGroup = AceGUI:Create("SimpleGroup");
  SizeGroup:SetLayout("Flow");
  SizeGroup:SetRelativeWidth(1);
  AuraFramesConfig:EnhanceContainer(SizeGroup);
  Content:AddChild(SizeGroup);
 
  local Scale = AceGUI:Create("Slider");
  Scale:SetWidth(250);
  Scale:SetValue(LayoutConfig.Scale);
  Scale:SetLabel("The scale of the container");
  Scale:SetSliderValues(0.5, 3, 0.01);
  Scale:SetIsPercent(true);
  Scale:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.Scale = Value;
    ContainerInstance:Update("LAYOUT");
    Module:Update(ContainerId);
  end);
  SizeGroup:AddChild(Scale);
  
  local ButtonScale = AceGUI:Create("Slider");
  ButtonScale:SetWidth(250);
  ButtonScale:SetValue(LayoutConfig.ButtonScale);
  ButtonScale:SetLabel("The scale of the buttons");
  ButtonScale:SetSliderValues(0.5, 3, 0.01);
  ButtonScale:SetIsPercent(true);
  ButtonScale:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ButtonScale = Value;
    ContainerInstance:Update("LAYOUT");
    Module:Update(ContainerId);
  end);
  SizeGroup:AddChild(ButtonScale);
  
  SizeGroup:AddText("The scale will effect the whole container, including aura's and text.", GameFontHighlightSmall, 250);
  SizeGroup:AddText("The scale will effect only buttons and the button text.", GameFontHighlightSmall, 250);
  
  SizeGroup:AddSpace(2);
  
  local Length = AceGUI:Create("Slider");
  Length:SetWidth(250);
  Length:SetValue(LayoutConfig.Length);
  Length:SetLabel("Length of the timeline");
  Length:SetSliderValues(50, 2000, 1);
  Length:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.Length = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  SizeGroup:AddChild(Length);
  
  local Width = AceGUI:Create("Slider");
  Width:SetWidth(250);
  Width:SetValue(LayoutConfig.Width);
  Width:SetLabel("Width of the timeline");
  Width:SetSliderValues(5, 200, 1);
  Width:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.Width = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  SizeGroup:AddChild(Width);

  SizeGroup:AddText("The lenght of the timeline bar", GameFontHighlightSmall, 250);
  SizeGroup:AddText("The width of the timeline bar", GameFontHighlightSmall, 250);
  
  SizeGroup:AddSpace(2);
  
  local ButtonOffset = AceGUI:Create("Slider");
  ButtonOffset:SetWidth(250);
  ButtonOffset:SetValue(LayoutConfig.ButtonOffset);
  ButtonOffset:SetLabel("Button offset");
  ButtonOffset:SetSliderValues(-100, 100, 1);
  ButtonOffset:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ButtonOffset = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  SizeGroup:AddChild(ButtonOffset);
  
  local ButtonIndent = AceGUI:Create("CheckBox");
  ButtonIndent:SetLabel("Keep buttons inside the timeline");
  ButtonIndent:SetWidth(250);
  ButtonIndent:SetValue(LayoutConfig.ButtonIndent);
  ButtonIndent:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ButtonIndent = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  SizeGroup:AddChild(ButtonIndent);
  
  Content:AddSpace(2);
  Content:AddText("The size of the buttons (default size is 36).");
  Content:AddSpace();
 
  local ButtonSize = AceGUI:Create("Slider");
  ButtonSize:SetWidth(500);
  ButtonSize:SetValue(LayoutConfig.ButtonSizeX);
  ButtonSize:SetLabel("The size of the buttons");
  ButtonSize:SetSliderValues(10, 100, 1);
  ButtonSize:SetIsPercent(false);
  ButtonSize:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ButtonSizeX = Value;
    LayoutConfig.ButtonSizeY = Value;
    ContainerInstance:Update("LAYOUT");
    Module:Update(ContainerId);
  end);
  Content:AddChild(ButtonSize);
  
  Content:AddSpace();

end
