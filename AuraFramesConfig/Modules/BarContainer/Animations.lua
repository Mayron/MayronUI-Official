local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");

if not AuraFramesConfig.Animations then
  AuraFramesConfig.Animations = {};
end

if not AuraFramesConfig.Animations.BarContainerMove then
  AuraFramesConfig.Animations.BarContainerMove = {};
end

AuraFramesConfig.Animations.BarContainerMove.DisplayName = "Move Bars";
AuraFramesConfig.Animations.BarContainerMove.Description = "An animation can be played when a bar moves between positions";
AuraFramesConfig.Animations.BarContainerMove.List = AuraFramesConfig.Animations.BarContainerMove.List or {};

-----------------------------------------------------------------
-- Function BarContainerMove:Direct
-----------------------------------------------------------------
AuraFramesConfig.Animations.BarContainerMove.List.Direct = {DisplayName = "Direct"};

function AuraFramesConfig.Animations.BarContainerMove.List.Direct:SetDefaults(Properties)

  Properties.Duration = 0.2;

end

function AuraFramesConfig.Animations.BarContainerMove.List.Direct:Content(Content, ContainerInstance, Config)

  local SliderDuration = AceGUI:Create("Slider");
  SliderDuration:SetLabel("Duration of the animation");
  SliderDuration:SetSliderValues(0.1, 2.0, 0.1);
  SliderDuration:SetValue(Config.Duration);
  SliderDuration:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Duration = Value;
    ContainerInstance:UpdateAnimationConfig("BarContainerMove");
  end);
  Content:AddChild(SliderDuration);

end

