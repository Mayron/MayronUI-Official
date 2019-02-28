local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local Module = AuraFramesConfig:GetModule("BarContainer");
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
 
  local Scale = AceGUI:Create("Slider");
  Scale:SetWidth(500);
  Scale:SetValue(LayoutConfig.Scale);
  Scale:SetLabel("The scale of the container");
  Scale:SetSliderValues(0.5, 3, 0.01);
  Scale:SetIsPercent(true);
  Scale:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.Scale = Value;
    ContainerInstance:Update("LAYOUT");
    Module:Update(ContainerId);
  end);
  Content:AddChild(Scale);
  Content:AddText("The scale will effect the whole container, including aura's and text.", GameFontHighlightSmall);
  
  Content:AddSpace(2);
  
  local SizeGroup = AceGUI:Create("SimpleGroup");
  SizeGroup:SetLayout("Flow");
  SizeGroup:SetRelativeWidth(1);
  AuraFramesConfig:EnhanceContainer(SizeGroup);
  Content:AddChild(SizeGroup);
  
  local NumberOfBars = AceGUI:Create("Slider");
  NumberOfBars:SetWidth(250);
  NumberOfBars:SetValue(LayoutConfig.NumberOfBars);
  NumberOfBars:SetLabel("Number of bars");
  NumberOfBars:SetSliderValues(1, 50, 1);
  NumberOfBars:SetIsPercent(false);
  NumberOfBars:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.NumberOfBars = Value;
    ContainerInstance:Update("LAYOUT");
    Module:Update(ContainerId);
  end);
  SizeGroup:AddChild(NumberOfBars);
  
  local BarWidth = AceGUI:Create("Slider");
  BarWidth:SetWidth(250);
  BarWidth:SetValue(LayoutConfig.BarWidth);
  BarWidth:SetLabel("Width of the bars");
  BarWidth:SetSliderValues(50, 1000, 10);
  BarWidth:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BarWidth = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  SizeGroup:AddChild(BarWidth);

  SizeGroup:AddText("The number of bars the container will display.", GameFontHighlightSmall, 250);

  SizeGroup:AddText("The width of the bars including the aura icon.", GameFontHighlightSmall, 250);
  
  Content:AddSpace(2);
 
  local BarHeight = AceGUI:Create("Slider");
  BarHeight:SetWidth(500);
  BarHeight:SetValue(LayoutConfig.BarHeight);
  BarHeight:SetLabel("The height of the bar");
  BarHeight:SetSliderValues(10, 100, 1);
  BarHeight:SetIsPercent(false);
  BarHeight:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.BarHeight = Value;
    ContainerInstance:Update("LAYOUT");
    Module:Update(ContainerId);
  end);
  Content:AddChild(BarHeight);
  
  Content:AddText("The height of the bar (default size is 36).", GameFontHighlightSmall);
  
  Content:AddSpace();
  Content:AddHeader("Spacing");
  
  Content:AddSpace();
  
  local Space = AceGUI:Create("Slider");
  Space:SetWidth(250);
  Space:SetValue(LayoutConfig.Space);
  Space:SetLabel("Space between bar");
  Space:SetSliderValues(0, 50, 0.1);
  Space:SetIsPercent(false);
  Space:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.Space = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  Content:AddChild(Space);
  
  Content:AddText("The space between the bars.", GameFontHighlightSmall, 250);
  
end
