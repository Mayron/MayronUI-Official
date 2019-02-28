local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local Module = AuraFramesConfig:GetModule("ButtonContainer");
local AceGUI = LibStub("AceGUI-3.0");
local LSM = LibStub("LibSharedMedia-3.0");

-----------------------------------------------------------------
-- Function ContentLayoutMiniBar
-----------------------------------------------------------------
function Module:ContentLayoutMiniBar(Content, ContainerId)

  local LayoutConfig = AuraFrames.db.profile.Containers[ContainerId].Layout;
  local ContainerInstance = AuraFrames.Containers[ContainerId];

  Content:ReleaseChildren();

  Content:SetLayout("List");

  Content:AddText("Mini Bar\n", GameFontNormalLarge);

  local EnableMiniBar = AceGUI:Create("CheckBox");
  EnableMiniBar:SetLabel("Enable mini bar");
  EnableMiniBar:SetDescription("Show a small bar to indicate the time remaining");
  EnableMiniBar:SetRelativeWidth(1);
  EnableMiniBar:SetValue(LayoutConfig.MiniBarEnabled);
  EnableMiniBar:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.MiniBarEnabled = Value;
    ContainerInstance:Update("LAYOUT");
    Module:ContentLayoutMiniBar(Content, ContainerId);
  end);
  Content:AddChild(EnableMiniBar);
  
  Content:AddSpace();

  local OptionGroup = AceGUI:Create("SimpleGroup");
  OptionGroup:SetLayout("Flow");
  OptionGroup:SetRelativeWidth(1);
  AuraFramesConfig:EnhanceContainer(OptionGroup);
  Content:AddChild(OptionGroup);

  local Style = AceGUI:Create("Dropdown");
  Style:SetDisabled(not LayoutConfig.MiniBarEnabled);
  Style:SetWidth(250);
  Style:SetList({
    HORIZONTAL = "Horizontal",
    VERTICAL   = "Vertical",
  });
  Style:SetLabel("Style of the mini bar");
  Style:SetValue(LayoutConfig.MiniBarStyle);
  Style:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.MiniBarStyle = Value;
    ContainerInstance:Update("LAYOUT");
    Module:ContentLayoutMiniBar(Content, ContainerId);
  end);
  OptionGroup:AddChild(Style);
  
  local Direction = AceGUI:Create("Dropdown");
  Direction:SetDisabled(not LayoutConfig.MiniBarEnabled);
  Direction:SetWidth(250);
  if LayoutConfig.MiniBarStyle == "HORIZONTAL" then
    Direction:SetList({
      HIGHGROW = "Left, grow",
      LOWGROW = "Right, grow",
      MIDDLEGROW = "Middle, grow",
      HIGHSHRINK = "Left, shrink",
      LOWSHRINK = "Right, shrink",
      MIDDLESHRINK = "Middle, shrink"
    });
  else
    Direction:SetList({
      HIGHGROW = "Top, grow",
      LOWGROW = "Bottom, grow",
      MIDDLEGROW = "Middle, grow",
      HIGHSHRINK = "Top, shrink",
      LOWSHRINK = "Bottom, shrink",
      MIDDLESHRINK = "Middle, shrink"
    });
  end
  Direction:SetLabel("Grow/Shrink direction of the mini bar");
  Direction:SetValue(LayoutConfig.MiniBarDirection);
  Direction:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.MiniBarDirection = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  OptionGroup:AddChild(Direction);
  
  local BarTexture = AceGUI:Create("LSM30_Statusbar");
  BarTexture:SetDisabled(not LayoutConfig.MiniBarEnabled);
  BarTexture:SetWidth(250);
  BarTexture:SetList(LSM:HashTable("statusbar"));
  BarTexture:SetLabel("Bar Texture");
  BarTexture:SetValue(LayoutConfig.MiniBarTexture);
  BarTexture:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.MiniBarTexture = Value;
    ContainerInstance:Update("LAYOUT");
    BarTexture:SetValue(Value);
  end);
  OptionGroup:AddChild(BarTexture);
  
  local Color = AceGUI:Create("ColorPicker");
  Color:SetDisabled(not LayoutConfig.MiniBarEnabled);
  Color:SetWidth(250);
  Color:SetHasAlpha(true);
  Color:SetColor(unpack(LayoutConfig.MiniBarColor));
  Color:SetLabel("Color");
  Color:SetCallback("OnValueChanged", function(_, _, ...)
    LayoutConfig.MiniBarColor = {...};
    ContainerInstance:Update("LAYOUT");
  end);
  OptionGroup:AddChild(Color);

  local Length = AceGUI:Create("Slider");
  Length:SetDisabled(not LayoutConfig.MiniBarEnabled);
  Length:SetWidth(250);
  Length:SetValue(LayoutConfig.MiniBarLength);
  Length:SetLabel("Lenght of the mini bar");
  Length:SetSliderValues(1, 50, 1);
  Length:SetIsPercent(false);
  Length:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.MiniBarLength = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  OptionGroup:AddChild(Length);
  
  local Width = AceGUI:Create("Slider");
  Width:SetDisabled(not LayoutConfig.MiniBarEnabled);
  Width:SetWidth(250);
  Width:SetValue(LayoutConfig.MiniBarWidth);
  Width:SetLabel("Width of the mini bar");
  Width:SetSliderValues(1, 50, 1);
  Width:SetIsPercent(false);
  Width:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.MiniBarWidth = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  OptionGroup:AddChild(Width);
  
  OptionGroup:AddSpace();
  
  local OffsetX = AceGUI:Create("Slider");
  OffsetX:SetDisabled(not LayoutConfig.MiniBarEnabled);
  OffsetX:SetWidth(250);
  OffsetX:SetValue(LayoutConfig.MiniBarOffsetX);
  OffsetX:SetLabel("Offset X");
  OffsetX:SetSliderValues(-50, 50, 1);
  OffsetX:SetIsPercent(false);
  OffsetX:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.MiniBarOffsetX = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  OptionGroup:AddChild(OffsetX);
  
  local OffsetY = AceGUI:Create("Slider");
  OffsetY:SetDisabled(not LayoutConfig.MiniBarEnabled);
  OffsetY:SetWidth(250);
  OffsetY:SetValue(LayoutConfig.MiniBarOffsetY);
  OffsetY:SetLabel("Offset Y");
  OffsetY:SetSliderValues(-50, 50, 1);
  OffsetY:SetIsPercent(false);
  OffsetY:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.MiniBarOffsetY = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  OptionGroup:AddChild(OffsetY);

end
