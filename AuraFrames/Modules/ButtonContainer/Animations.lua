local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

if not AuraFrames.Animations then
  AuraFrames.Animations = {};
end

if not AuraFrames.Animations.ButtonContainerMove then
  AuraFrames.Animations.ButtonContainerMove = {};
end


-- Frame levels used for poping up bar.
local FrameLevelLow = 3;
local FrameLevelNormal = 6;
local FrameLevelHigh = 9;

local function ExternalTranslationDirect(Region, RegionEffect, Properties, Progression)

  local Button = Region:GetParent();

  RegionEffect.XOffset = RegionEffect.XOffset + (Button.MoveX * (1 - Progression));
  RegionEffect.YOffset = RegionEffect.YOffset + (Button.MoveY * (1 - Progression));

end

-----------------------------------------------------------------
-- Function ButtonContainerMove:Direct
-----------------------------------------------------------------
function AuraFrames.Animations.ButtonContainerMove.Direct(Properties, Container, Animation)

  Animation:SetConfig({
    Effects = {
      {Type = "External", Duration = Properties.Duration, External = ExternalTranslationDirect, FromX = 0, ToX = 0, FromY = Distance, ToY = 0},
    },
  });

end
