local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");

if not AuraFramesConfig.Animations then
  AuraFramesConfig.Animations = {};
end

if not AuraFramesConfig.Animations.TimeLineCluster then
  AuraFramesConfig.Animations.TimeLineCluster = {};
end

AuraFramesConfig.Animations.TimeLineCluster.DisplayName = "TimeLine Cluster";
AuraFramesConfig.Animations.TimeLineCluster.Description = "An animation can be played when multiple aura's overlap eachother on the time line.";
AuraFramesConfig.Animations.TimeLineCluster.List = AuraFramesConfig.Animations.TimeLineCluster.List or {};

-----------------------------------------------------------------
-- Function TimeLineCluster:Swap
-----------------------------------------------------------------
AuraFramesConfig.Animations.TimeLineCluster.List.Swap = {DisplayName = "Swap"};

function AuraFramesConfig.Animations.TimeLineCluster.List.Swap:SetDefaults(Properties)

  Properties.Speed = 1.0;
  Properties.Delay = 1.0;
  Properties.Radius = 50;
  Properties.Direction = "UP";

end

function AuraFramesConfig.Animations.TimeLineCluster.List.Swap:Content(Content, ContainerInstance, Config)

  Content:AddSpace();

  local SliderSpeed = AceGUI:Create("Slider");
  SliderSpeed:SetLabel("Speed of the animation");
  SliderSpeed:SetSliderValues(0.1, 10, 0.1);
  SliderSpeed:SetValue(Config.Speed);
  SliderSpeed:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Speed = Value;
    ContainerInstance:UpdateAnimationConfig("TimeLineCluster");
  end);
  Content:AddChild(SliderSpeed);
  
  local SliderDelay = AceGUI:Create("Slider");
  SliderDelay:SetLabel("Delay before the next swap");
  SliderDelay:SetSliderValues(0.1, 5.0, 0.1);
  SliderDelay:SetValue(Config.Delay);
  SliderDelay:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Delay = Value;
    ContainerInstance:UpdateAnimationConfig("TimeLineCluster");
  end);
  Content:AddChild(SliderDelay);

  local SliderRadius = AceGUI:Create("Slider");
  SliderRadius:SetLabel("Radius of the swap");
  SliderRadius:SetSliderValues(1, 200, 1);
  SliderRadius:SetValue(Config.Radius);
  SliderRadius:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Radius = Value;
    ContainerInstance:UpdateAnimationConfig("TimeLineCluster");
  end);
  Content:AddChild(SliderRadius);

  local DropdownDirection = AceGUI:Create("Dropdown");
  DropdownDirection:SetList({
    UP    = "Up",
    DOWN  = "Down",
    LEFT  = "Left",
    RIGHT = "Right",
  });
  DropdownDirection:SetLabel("Direction of the swap");
  DropdownDirection:SetValue(Config.Direction);
  DropdownDirection:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Direction = Value;
    ContainerInstance:UpdateAnimationConfig("TimeLineCluster");
  end);
  Content:AddChild(DropdownDirection);

end


-----------------------------------------------------------------
-- Function TimeLineCluster:Fade
-----------------------------------------------------------------
AuraFramesConfig.Animations.TimeLineCluster.List.Fade = {DisplayName = "Fade"};

function AuraFramesConfig.Animations.TimeLineCluster.List.Fade:SetDefaults(Properties)

  Properties.Speed = 1.0;
  Properties.Delay = 1.0;

end

function AuraFramesConfig.Animations.TimeLineCluster.List.Fade:Content(Content, ContainerInstance, Config)

  Content:AddSpace();

  local SliderSpeed = AceGUI:Create("Slider");
  SliderSpeed:SetLabel("Speed of the animation");
  SliderSpeed:SetSliderValues(0.1, 10, 0.1);
  SliderSpeed:SetValue(Config.Speed);
  SliderSpeed:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Speed = Value;
    ContainerInstance:UpdateAnimationConfig("TimeLineCluster");
  end);
  Content:AddChild(SliderSpeed);
  
  local SliderDelay = AceGUI:Create("Slider");
  SliderDelay:SetLabel("Delay before the next swap");
  SliderDelay:SetSliderValues(0.1, 5.0, 0.1);
  SliderDelay:SetValue(Config.Delay);
  SliderDelay:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Delay = Value;
    ContainerInstance:UpdateAnimationConfig("TimeLineCluster");
  end);
  Content:AddChild(SliderDelay);

end
