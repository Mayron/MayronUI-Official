local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");

if not AuraFramesConfig.Animations then
  AuraFramesConfig.Animations = {};
end

if not AuraFramesConfig.Animations.ButtonContainerMove then
  AuraFramesConfig.Animations.ButtonContainerMove = {};
end

AuraFramesConfig.Animations.ButtonContainerMove.DisplayName = "Move Buttons";
AuraFramesConfig.Animations.ButtonContainerMove.Description = "An animation can be played when a button moves between positions";
AuraFramesConfig.Animations.ButtonContainerMove.List = AuraFramesConfig.Animations.ButtonContainerMove.List or {};

-----------------------------------------------------------------
-- Function ButtonContainerMove:Direct
-----------------------------------------------------------------
AuraFramesConfig.Animations.ButtonContainerMove.List.Direct = {DisplayName = "Direct"};

function AuraFramesConfig.Animations.ButtonContainerMove.List.Direct:SetDefaults(Properties)

  Properties.Duration = 0.2;

end

function AuraFramesConfig.Animations.ButtonContainerMove.List.Direct:Content(Content, ContainerInstance, Config)

  local SliderDuration = AceGUI:Create("Slider");
  SliderDuration:SetLabel("Duration of the animation");
  SliderDuration:SetSliderValues(0.1, 2.0, 0.1);
  SliderDuration:SetValue(Config.Duration);
  SliderDuration:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Duration = Value;
    ContainerInstance:UpdateAnimationConfig("BUttonContainerMove");
  end);
  Content:AddChild(SliderDuration);

end

