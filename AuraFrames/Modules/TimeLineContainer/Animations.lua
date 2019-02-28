local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

if not AuraFrames.Animations then
  AuraFrames.Animations = {};
end

if not AuraFrames.Animations.TimeLineCluster then
  AuraFrames.Animations.TimeLineCluster = {};
end


-- Frame levels used for poping up buttons.
local FrameLevelLow = 3;
local FrameLevelNormal = 6;
local FrameLevelHigh = 9;

-----------------------------------------------------------------
-- Function TimeLineCluster:Swap
-----------------------------------------------------------------
function AuraFrames.Animations.TimeLineCluster.Swap(Properties, Container, AnimationGoVisible, AnimationGoInvisible)

  local DirectionTranslations = {
    UP = {0, 1},
    DOWN = {0, -1},
    LEFT = {-1, 0},
    RIGHT = {1, 0},
  };

  local Direction = DirectionTranslations[Properties.Direction or "UP"];

  AnimationGoVisible:SetConfig({
    KeepEffects = true,
    EndDelay = Properties.Delay,
    Speed = Properties.Speed,
    Effects = {
      {Type = "Alpha", Start = 0.0, From = 0.3, To = 0.3, Duration = 0.15},
      {Type = "Alpha", Start = 0.15, From = 0.3, To = 1, Duration = 0.15},
      {Type = "Scale", Start = 0.0, From = 0.5, To = 0.5, Duration = 0.15},
      {Type = "Scale", Start = 0.15, From = 0.5, To = 1, Duration = 0.15},
      {Type = "FrameStrata", Start = 0.15, Strata = "MEDIUM"},
      {Type = "FrameLevel", Start = 0.15, Level = FrameLevelNormal},
      {Type = "Translation", Start = 0.0, Duration = 0.15, Smoothing = "SinSNS",
        ToX = Properties.Radius * Direction[1],
        ToY = Properties.Radius * Direction[2],
      },
      {Type = "Translation", Start = 0.15, Duration = 0.15,
        FromX = Properties.Radius * Direction[1], ToX = Properties.Radius * Direction[1],
        FromY = Properties.Radius * Direction[2], ToY = Properties.Radius * Direction[2],
      },
      {Type = "Translation", Start = 0.3, Duration = 0.15, Smoothing = "SinSNS",
        FromX = Properties.Radius * Direction[1],
        FromY = Properties.Radius * Direction[2],
      },
    },
  });

  AnimationGoInvisible:SetConfig({
    KeepEffects = true,
    Speed = Properties.Speed,
    Effects = {
      {Type = "Alpha", Start = 0.15, From = 1.0, To = 0.3, Duration = 0.15},
      {Type = "Alpha", Start = 0.3, From = 0.3, To = 0.3, Duration = 0.15},
      {Type = "Scale", Start = 0.15, From = 1.0, To = 0.5, Duration = 0.15},
      {Type = "Scale", Start = 0.3, From = 0.5, To = 0.5, Duration = 0.15},
      {Type = "FrameStrata", Start = 0.3, Strata = "LOW"},
      {Type = "FrameLevel", Start = 0.3, Level = FrameLevelLow},
      {Type = "Translation", Start = 0.0, Duration = 0.15, Smoothing = "SinSNS",
        ToX = -Properties.Radius * Direction[1],
        ToY = -Properties.Radius * Direction[2],
      },
      {Type = "Translation", Start = 0.15, Duration = 0.15,
        FromX = -Properties.Radius * Direction[1], ToX = -Properties.Radius * Direction[1],
        FromY = -Properties.Radius * Direction[2], ToY = -Properties.Radius * Direction[2],
      },
      {Type = "Translation", Start = 0.3, Smoothing = "SinSNS", Duration = 0.15,
        FromX = -Properties.Radius * Direction[1],
        FromY = -Properties.Radius * Direction[2],
      },
    },
  });

end


-----------------------------------------------------------------
-- Function TimeLineCluster:Fade
-----------------------------------------------------------------
function AuraFrames.Animations.TimeLineCluster.Fade(Properties, Container, AnimationGoVisible, AnimationGoInvisible)

  AnimationGoVisible:SetConfig({
    KeepEffects = true,
    EndDelay = Properties.Delay,
    Speed = Properties.Speed,
    Effects = {
      {Type = "Alpha", Start = 0.0, From = 0.3, To = 0.3, Duration = 0.15},
      {Type = "Alpha", Start = 0.15, From = 0.3, To = 1, Duration = 0.15},
      {Type = "FrameLevel", Start = 0.15, Level = FrameLevelNormal},
    },
  });

  AnimationGoInvisible:SetConfig({
    KeepEffects = true,
    Speed = Properties.Speed,
    Effects = {
      {Type = "Alpha", Start = 0.15, From = 1.0, To = 0.3, Duration = 0.15},
      {Type = "Alpha", Start = 0.3, From = 0.3, To = 0.3, Duration = 0.15},
      {Type = "FrameLevel", Start = 0.3, Level = FrameLevelLow},
    },
  });

end
