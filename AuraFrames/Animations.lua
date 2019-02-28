local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

if not AuraFrames.Animations then
  AuraFrames.Animations = {};
end

if not AuraFrames.Animations.AuraNew then
  AuraFrames.Animations.AuraNew = {};
end

if not AuraFrames.Animations.AuraChanging then
  AuraFrames.Animations.AuraChanging = {};
end

if not AuraFrames.Animations.AuraExpiring then
  AuraFrames.Animations.AuraExpiring = {};
end

if not AuraFrames.Animations.ContainerVisibility then
  AuraFrames.Animations.ContainerVisibility = {};
end

-- Import most used functions into the local namespace.
local pairs = pairs;

-----------------------------------------------------------------
-- Function AuraNew:Flash
-----------------------------------------------------------------
function AuraFrames.Animations.AuraNew.Flash(Properties, Container, Animation)

  -- Alpha = (0.0 => 1.0) + (1.0 => 0.15 => 1.0) * Properties.Times

  Animation:SetConfig({
    Effects = {
      {Type = "Alpha", Start = 0.0, From = 0.0, To = 1, Duration = Properties.Duration / 2, Smoothing = "SinSNS"},
      {Type = "Alpha", Start = Properties.Duration / 2, From = 1, To = 0.15, Duration = Properties.Duration / 2, Times = (Properties.Times or 1) * 2, Bounce = true, Smoothing = "SinSNS"},
    },
  });

end


-----------------------------------------------------------------
-- Function AuraNew:JumpIn
-----------------------------------------------------------------
function AuraFrames.Animations.AuraNew.JumpIn(Properties, Container, Animation)

  Animation:SetConfig({
    Effects = {
      {Type = "Scale", From = Properties.StartScale, Duration = Properties.Duration, Smoothing = "SinNS"},
      {Type = "Alpha", From = Properties.StartAlpha, Duration = Properties.Duration, Smoothing = "SinNS"},
      {Type = "Translation", FromX = Properties.StartX, FromY = Properties.StartY, Duration = Properties.Duration, Smoothing = "SinNS", IgnoreParent = true},
    },
  });

end


-----------------------------------------------------------------
-- Function AuraNew:FadeIn
-----------------------------------------------------------------
function AuraFrames.Animations.AuraNew.FadeIn(Properties, Container, Animation)

  -- Alpha = (0.0 => 1.0)

  Animation:SetConfig({
    Effects = {
      {Type = "Alpha", From = 0.0, To = 1, Duration = Properties.Duration, Smoothing = "SinSNS"},
    },
  });

end


-----------------------------------------------------------------
-- Function AuraChanging:Flash
-----------------------------------------------------------------
function AuraFrames.Animations.AuraChanging.Flash(Properties, Container, Animation)

  -- Alpha = (1.0 => 0.15 => 1.0) * Properties.Times

  Animation:SetConfig({
    Effects = {
      {Type = "Alpha", From = 1.0, To = 0.15, Duration = Properties.Duration / 2, Times = (Properties.Times or 1) * 2, Bounce = true, Smoothing = "SinSNS"},
    },
  });

end


-----------------------------------------------------------------
-- Function AuraChanging:Popup
-----------------------------------------------------------------
function AuraFrames.Animations.AuraChanging.Popup(Properties, Container, Animation)

  Animation:SetConfig({
    Effects = {
      {Type = "FrameLevel", Start = 0, Change = 3},
      {Type = "Scale", From = 1, To = Properties.Scale, Duration = Properties.Duration / 2, Times = 2, Bounce = true, Smoothing = "SinSNS"},
      {Type = "FrameLevel", Start = Properties.Duration, Change = -3},
    },
  });

end


-----------------------------------------------------------------
-- Function AuraExpiring:Flash
-----------------------------------------------------------------
function AuraFrames.Animations.AuraExpiring.Flash(Properties, Container, Animation)

  -- Alpha = (1.0 => 0.15 => 1.0) * Properties.Times + (1.0 => 0.0)

  Animation:SetConfig({
    Effects = {
      {Type = "Alpha", Start = 0.0, From = 1.0, To = 0.15, Duration = Properties.Duration / 2, Times = Properties.Times * 2, Bounce = true, Smoothing = "SinSNS"},
      {Type = "Alpha", Start = Properties.Duration * Properties.Times, From = 1.0, To = 0.0, Duration = Properties.Duration / 2, Smoothing = "SinSNS"},
    },
  });

end


-----------------------------------------------------------------
-- Function AuraExpiring:FadeOut
-----------------------------------------------------------------
function AuraFrames.Animations.AuraExpiring.FadeOut(Properties, Container, Animation)

  -- Alpha = (1.0 => 0.0)

  Animation:SetConfig({
    Effects = {
      {Type = "Alpha", From = 1.0, To = 0.0, Duration = Properties.Duration, Smoothing = "SinSNS"},
    },
  });

end


-----------------------------------------------------------------
-- Function AuraExpiring:Explode
-----------------------------------------------------------------
function AuraFrames.Animations.AuraExpiring.Explode(Properties, Container, Animation)

  Animation:SetConfig({
    Effects = {
      {Type = "FrameLevel", Start = 0, Change = 3},
      {Type = "Scale", From = 1, To = Properties.Scale, Duration = Properties.Duration},
      {Type = "Alpha", From = 1, To = 0, Duration = Properties.Duration},
      {Type = "FrameLevel", Start = Properties.Duration, Change = -3},
    },
  });

end


-----------------------------------------------------------------
-- Function AuraExpiring:JumpOut
-----------------------------------------------------------------
function AuraFrames.Animations.AuraExpiring.JumpOut(Properties, Container, Animation)

  Animation:SetConfig({
    Effects = {
      {Type = "Scale", To = Properties.EndScale, Duration = Properties.Duration, Smoothing = "SinSN", IgnoreParent = true},
      {Type = "Alpha", To = Properties.EndAlpha, Duration = Properties.Duration, Smoothing = "SinSN"},
      {Type = "Translation", ToX = Properties.EndX, ToY = Properties.EndY, Duration = Properties.Duration, Smoothing = "SinSN", IgnoreParent = true},
    },
  });

end


-----------------------------------------------------------------
-- Local Function ContainerVisibilityMouseEvents
-----------------------------------------------------------------
local function ContainerVisibilityMouseEvents(Region, RegionEffect, Properties, Progression)
  
  local OldRecieveMouseEvents = Properties.Container.RecieveMouseEvents;

  Properties.Container.VisibilityClickable = Properties.Visible or Properties.MouseEventsWhenInactive;
  Properties.Container.RecieveMouseEvents = Properties.Container.Config.Layout.Clickable and Properties.Container.VisibilityClickable;
  
  if not Properties.Container.RecieveMouseEvents and (OldRecieveMouseEvents ~= Properties.Container.RecieveMouseEvents) then
    -- Make sure we don't have stuck tooltips.
    GameTooltip:Hide();
  end
  
  if OldRecieveMouseEvents ~= Properties.Container.RecieveMouseEvents then
    Properties.Container:Update("LAYOUT");
  end

end


-----------------------------------------------------------------
-- Function ContainerVisibility:Jump
-----------------------------------------------------------------
function AuraFrames.Animations.ContainerVisibility.Jump(Properties, Container, AnimationGoingVisible, AnimationGoingVisibleChild, AnimationGoingInvisible)

  AnimationGoingVisible:SetConfig({
    KeepEffects = true,
    Effects = {
      {Type = "External", External = ContainerVisibilityMouseEvents, Container = Container, Visible = true, MouseEventsWhenInactive = Properties.MouseEventsWhenInactive},
      {Type = "FrameStrata", Start = 0, Strata = "BACKGROUND"},
      {Type = "Alpha", From = Properties.InvisibleAlpha, To = 1, Duration = Properties.Duration, Smoothing = "SinSNS"},
      {Type = "Scale", From = Properties.InvisibleScale, To = 1, Duration = Properties.Duration, Smoothing = "SinSNS"},
      {Type = "Translation", FromY = Properties.InvisibleY, FromX = Properties.InvisibleX,  Duration = Properties.Duration, Smoothing = "SinSNS", IgnoreParent = true},
      {Type = "FrameStrata", Start = Properties.Duration, Strata = "MEDIUM"},
    },
  });

  AnimationGoingVisibleChild:SetConfig({
    Effects = {
      {Type = "Alpha", From = 0, To = 0, Duration = Properties.Duration},
      {Type = "Alpha", Start = Properties.Duration, From = 0, To = 1, Duration = 0.2, Smoothing = "SinSNS"},
    },
  });

  AnimationGoingInvisible:SetConfig({
    KeepEffects = true,
    StartDelay = 1.0,
    Effects = {
      {Type = "External", External = ContainerVisibilityMouseEvents, Container = Container, Visible = true, MouseEventsWhenInactive = Properties.MouseEventsWhenInactive},
      {Type = "FrameStrata", Start = 0, Strata = "BACKGROUND"},
      {Type = "Alpha", From = 1, To = Properties.InvisibleAlpha, Duration = Properties.Duration, Smoothing = "SinSNS"},
      {Type = "Scale", From = 1, To = Properties.InvisibleScale, Duration = Properties.Duration, Smoothing = "SinSNS"},
      {Type = "Translation", ToY = Properties.InvisibleY, ToX = Properties.InvisibleX, Duration = Properties.Duration, Smoothing = "SinSNS", IgnoreParent = true},
      {Type = "FrameStrata", Start = Properties.Duration, Strata = "BACKGROUND"},
      {Type = "External", Start = Properties.Duration, External = ContainerVisibilityMouseEvents, Container = Container, Visible = false, MouseEventsWhenInactive = Properties.MouseEventsWhenInactive},
    },
  });

end


-----------------------------------------------------------------
-- Function ContainerVisibility:Fade
-----------------------------------------------------------------
function AuraFrames.Animations.ContainerVisibility.Fade(Properties, Container, AnimationGoingVisible, AnimationGoingVisibleChild, AnimationGoingInvisible)

  AnimationGoingVisible:SetConfig({
    KeepEffects = true,
    Effects = {
      {Type = "External", External = ContainerVisibilityMouseEvents, Container = Container, Visible = true, MouseEventsWhenInactive = Properties.MouseEventsWhenInactive},
      {Type = "Alpha", From = Properties.InvisibleAlpha, To = 1, Duration = Properties.Duration, Smoothing = "SinSNS"},
    },
  });

  AnimationGoingVisibleChild:SetConfig({});

  AnimationGoingInvisible:SetConfig({
    KeepEffects = true,
    StartDelay = 1.0,
    Effects = {
      {Type = "External", External = ContainerVisibilityMouseEvents, Container = Container, Visible = true, MouseEventsWhenInactive = Properties.MouseEventsWhenInactive},
      {Type = "Alpha", From = 1, To = Properties.InvisibleAlpha, Duration = Properties.Duration, Smoothing = "SinSNS"},
      {Type = "External", Start = Properties.Duration, External = ContainerVisibilityMouseEvents, Container = Container, Visible = false, MouseEventsWhenInactive = Properties.MouseEventsWhenInactive},
    },
  });

end


-----------------------------------------------------------------
-- Function UpdateAnimationConfig
-----------------------------------------------------------------
function AuraFrames:UpdateAnimationConfig(AnimationConfig, AnimationType, Container, ...)

  if AnimationConfig[AnimationType] and AnimationConfig[AnimationType].Enabled == true and self.Animations[AnimationType][AnimationConfig[AnimationType].Animation] then

    self.Animations[AnimationType][AnimationConfig[AnimationType].Animation](AnimationConfig[AnimationType], Container, ...);

  else

    for _, Animation in pairs({...}) do

      Animation:SetConfig({});

    end

  end

end
