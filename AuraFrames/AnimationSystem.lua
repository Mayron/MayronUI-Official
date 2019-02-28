local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

--[[

TODO:

  Fix a lot of bugs and speed improvements
  Support :GetLeft(), :GetRight(), GetTop(), GetBottom()
  Support for keeping the changes by an effect and not resetting them
  Support :GetRect(), :GetSize(), :GetHeight(), GetWidth()?
  Support color overlay?
  Support for texture rotation?


Example:

  Container.ClusterAnimationGoVisible = AuraFrames:NewAnimation();
  Container.ClusterAnimationGoVisible.KeepEffects = true;
  Container.ClusterAnimationGoVisible.EndDelay = 1.0;
  Container.ClusterAnimationGoVisible:AddEffect("Alpha", {Start = 0.0, From = 0.3, To = 0.3, Duration = 0.15});
  Container.ClusterAnimationGoVisible:AddEffect("Alpha", {Start = 0.15, From = 0.3, To = 1, Duration = 0.15});
  Container.ClusterAnimationGoVisible:AddEffect("Scale", {Start = 0.0, From = 0.5, To = 0.5, Duration = 0.15});
  Container.ClusterAnimationGoVisible:AddEffect("Scale", {Start = 0.15, From = 0.5, To = 1, Duration = 0.15});
  Container.ClusterAnimationGoVisible:AddEffect("FrameStrata", {Start = 0.15, Strata = "MEDIUM"});
  Container.ClusterAnimationGoVisible:AddEffect("Translation", {Start = 0.0, ToY = 50, Duration = 0.15});
  Container.ClusterAnimationGoVisible:AddEffect("Translation", {Start = 0.15, FromY = 50, ToY = 50, Duration = 0.15});
  Container.ClusterAnimationGoVisible:AddEffect("Translation", {Start = 0.3, FromY = 50, Duration = 0.15});

  Container.ClusterAnimationGoVisible = AuraFrames:NewAnimation({
    KeepEffects = true,
    EndDelay = 1.0,
    Effects = {
      {Type = "Alpha", Start = 0.0, From = 0.3, To = 0.3, Duration = 0.15},
      {Type = "Alpha", Start = 0.15, From = 0.3, To = 1, Duration = 0.15},
      {Type = "Scale", Start = 0.0, From = 0.5, To = 0.5, Duration = 0.15},
      {Type = "Scale", Start = 0.15, From = 0.5, To = 1, Duration = 0.15},
      {Type = "FrameStrata", Start = 0.15, Strata = "MEDIUM"},
      {Type = "Translation", Start = 0.0, ToY = 50, Duration = 0.15},
      {Type = "Translation", Start = 0.15, FromY = 50, ToY = 50, Duration = 0.15},
      {Type = "Translation", Start = 0.3, FromY = 50, Duration = 0.15},
    },
  });


]]--

-- Import most used functions into the local namespace.
local _G, CreateFrame = _G, CreateFrame;
local pairs, ipairs, tinsert, wipe, setmetatable, next, tremove = pairs, ipairs, tinsert, wipe, setmetatable, next, tremove;
local math_cos, PI = math.cos, PI;

-- Pre calculate pi * 2 and pi / 2
local PI2 = PI + PI;
local PI_2 = PI / 2;

local PoolRegionEffectsMaxSize = 50;
local PoolRegionEffects = {};

local PoolRegionDataMaxSize = 50;

local AnimationPrototype = {};

local Animations = {};

-- List of regions that need to be updated.
local UpdateRegions = {};

-- Make the table having weak keys, so that we dont have to clean up references to animation objects.
setmetatable(UpdateRegions, {__mode = "k"});


local UpdateFrame = CreateFrame("Frame");
UpdateFrame:Hide();
UpdateFrame:SetScript("OnUpdate", function(_, Elapsed)
  AuraFrames:AnimationUpdate(Elapsed);
end);

-----------------------------------------------------------------
-- Local Function RegionUpdateSize
-----------------------------------------------------------------
local function RegionUpdateSize(Region)

  local Width, Height = Region:GetWidth(), Region:GetHeight();

  if Width == 0 or Height == 0 then
    return;
  end

  Region._AnimationRegion:SetWidth(Region:GetWidth());
  Region._AnimationRegion:SetHeight(Region:GetHeight());

end


-----------------------------------------------------------------
-- Function AddEffect
-----------------------------------------------------------------
function AnimationPrototype:AddEffect(Type, Properties)

  if not AuraFrames.Animations.EffectConstructors[Type] then
    return;
  end
  
  local EffectFunction, EffectProperties = AuraFrames.Animations.EffectConstructors[Type](AuraFrames.Animations.EffectConstructors, Properties);

  -- Sort the effects on end time, so if we have a gap in time, that we can run the missed effects
  -- in the correct order (this is done by the Update function).

  local EndTime = EffectProperties.Start + (EffectProperties.Duration and EffectProperties.Duration * EffectProperties.Times or 0);

  if self.TotalDuration < EndTime then
    self.TotalDuration = EndTime;
  end

  local EffectIndex;

  for i, Effect in ipairs(self.Effects) do

    if Effect.EndTime > EndTime then
      tinsert(self.Effects, i, {Type = Type, Function = EffectFunction, Properties = EffectProperties, EndTime = EndTime});
      EffectIndex = i;
      break;
    end

  end

  if not EffectIndex then
    tinsert(self.Effects, {Type = Type, Function = EffectFunction, Properties = EffectProperties, EndTime = EndTime});
    EffectIndex = #self.Effects;
  end

  for i = EffectIndex - 1, 1, -1 do
    if self.Effects[i].Type == Type then
      self.Effects[i].NextTypeEffect = EffectIndex;
      break;
    end
  end

  for i = EffectIndex + 1, #self.Effects do
    if self.Effects[i].Type == Type then
      self.Effects[EffectIndex].NextTypeEffect = i;
      break;
    end
  end

  self.IsEmpty = self.StartDelay == 0 and self.EndDelay == 0 and self.TotalDuration == 0;

end


-----------------------------------------------------------------
-- Function RemoveEffects
-----------------------------------------------------------------
function AnimationPrototype:RemoveEffects()

  self.Effects = {};
  self.TotalDuration = 0;

end


-----------------------------------------------------------------
-- Function SetConfig
-----------------------------------------------------------------
function AnimationPrototype:SetConfig(Config)
  
  self.Effects = {};
  
  self.KeepEffects = Config.KeepEffects or false;
  self.StartDelay = Config.StartDelay or 0;
  self.EndDelay = Config.EndDelay or 0;
  self.Speed = Config.Speed or 1;

  self.TotalDuration = 0;

  if Config.Effects then
    for _, Effect in pairs(Config.Effects) do
      self:AddEffect(Effect.Type, Effect);
    end
  end

  self.IsEmpty = self.StartDelay == 0 and self.EndDelay == 0 and self.TotalDuration == 0;

end


-----------------------------------------------------------------
-- Function PreparePlay
-----------------------------------------------------------------
function AnimationPrototype:PreparePlay(Region)

  if self.IsEmpty == true then
    return false;
  end

  -- This will update the size and also create Region._AnimationRegion if it doesn't exists.
  AuraFrames:UpdateAnimationRegionSize(Region);

  if not Region._AnimationRegion then
    return false;
  end

  if not self.Regions[Region] then
    self.Regions[Region] = tremove(self.PoolRegionData) or {State = {}};
  end
  
  self.Regions[Region].Time = -self.StartDelay;

  -- Reset states.
  for Key, _ in pairs(self.Regions[Region].State) do
    self.Regions[Region].State[Key] = false;
  end

  if not Region._Animations then

    Region._AnimationRegion:ClearAllPoints();
    Region._AnimationRegion:SetPoint("CENTER", Region, "CENTER", 0, 0);

    for _, Object in ipairs({Region:GetChildren(), Region:GetRegions()}) do
      if Object ~= Region._AnimationRegion then
        Object:SetParent(Region._AnimationRegion);
      end
    end

    Region._Animations = {};

    -- Make the table having weak keys, so that we dont have to clean up references to animation objects.
    setmetatable(Region._Animations, {__mode = "k"});

  end

  if not Region._Animations[self] then
    Region._Animations[self] = tremove(PoolRegionEffects) or {};
  end

  Region._Animations[self].Scale = 1;
  Region._Animations[self].Alpha = 1;
  Region._Animations[self].XOffset = 0;
  Region._Animations[self].YOffset = 0;
  Region._Animations[self].CallBack = nil;

  return true;

end


-----------------------------------------------------------------
-- Function Apply
-----------------------------------------------------------------
function AnimationPrototype:Apply(Region)

  -- This function will directly set the result of an animation. If the animation was playing, it's stopped.
  
  if not self:PreparePlay(Region) then
    return;
  end
  
  self.Regions[Region].Time = self.TotalDuration;
  
  UpdateFrame:Show();

end


-----------------------------------------------------------------
-- Function Play
-----------------------------------------------------------------
function AnimationPrototype:Play(Region, CallBack, StartTime)

  if not self:PreparePlay(Region) then
    return;
  end

  self.Regions[Region].Time = StartTime or -self.StartDelay;
  Region._Animations[self].CallBack = CallBack;
  
  UpdateFrame:Show();

end


-----------------------------------------------------------------
-- Function IsPlaying
-----------------------------------------------------------------
function AnimationPrototype:IsPlaying(Region)

  return self.Regions[Region] and self.Regions[Region] ~= nil;

end


-----------------------------------------------------------------
-- Function GetProgression
-----------------------------------------------------------------
function AnimationPrototype:GetProgression(Region)

  return self.Regions[Region] and self.Regions[Region].Time or 0;

end


-----------------------------------------------------------------
-- Function GetCurrentEffects
-----------------------------------------------------------------
function AnimationPrototype:GetCurrentEffects(Region)

  return Region and Region._Animations and Region._Animations[self] or nil;

end


-----------------------------------------------------------------
-- Function Stop
-----------------------------------------------------------------
function AnimationPrototype:Stop(Region, Finished)

  if not self.Regions[Region] then
    return;
  end
  
  if #self.PoolRegionData <= PoolRegionDataMaxSize then
    tinsert(self.PoolRegionData, self.Regions[Region]);
  end

  self.Regions[Region] = nil;
  
  if Region._Animations and Region._Animations[self] and Region._Animations[self].CallBack then
    Region._Animations[self].CallBack(Region, Finished == true);
  end

  if self.KeepEffects ~= true then

    if Region._Animations and Region._Animations[self] then
      if #PoolRegionEffects <= PoolRegionEffectsMaxSize then
        tinsert(PoolRegionEffects, Region._Animations[self]);
      end
      Region._Animations[self] = nil;
    end

    AuraFrames:ApplyAnimationEffects(Region);

  end

end


-----------------------------------------------------------------
-- Function StopAll
-----------------------------------------------------------------
function AnimationPrototype:StopAll()

  for Region, RegionData in pairs(self.Regions) do

    if Region._Animations and Region._Animations[self].CallBack then
      Region._Animations[self].CallBack(Region, false);
    end

    if self.KeepEffects ~= true then

      if Region._Animations and Region._Animations[self] then

        if #PoolRegionEffects <= PoolRegionEffectsMaxSize then
          tinsert(PoolRegionEffects, Region._Animations[self]);
        end

        Region._Animations[self] = nil;

      end

      AuraFrames:ApplyAnimationEffects(Region);
    
    end

    if #self.PoolRegionData <= PoolRegionDataMaxSize then
      tinsert(PoolRegionData, RegionData);
    end

  end

  wipe(self.Regions);

end


-----------------------------------------------------------------
-- Function ClearEffect
-----------------------------------------------------------------
function AnimationPrototype:ClearEffect(Region)

  if Region._Animations and Region._Animations[self] then
  
    if #PoolRegionEffects <= PoolRegionEffectsMaxSize then
      tinsert(PoolRegionEffects, Region._Animations[self]);
    end
    Region._Animations[self] = nil;
  
  end

  if Region._AnimationRegion then
    AuraFrames:ApplyAnimationEffects(Region);
  end
  
end

local EffectResult = {};


-----------------------------------------------------------------
-- Function ApplyAnimationEffects
-----------------------------------------------------------------
function AuraFrames:ApplyAnimationEffects(Region)

  local Scale, Alpha, XOffset, YOffset = 1, 1, 0, 0;
  
  for _, EffectProperties in pairs(Region._Animations or {}) do
  
    Scale = Scale * EffectProperties.Scale;
    Alpha = Alpha * EffectProperties.Alpha;
    XOffset = XOffset + EffectProperties.XOffset;
    YOffset = YOffset + EffectProperties.YOffset;
  
  end

  if Region._ScaleRegion then
    Region._ScaleRegion:SetScale(Scale);
  else
    Region._AnimationRegion:SetScale(Scale);
  end

  if Region._AlphaRegion then
    Region._AlphaRegion:SetAlpha(Alpha);
  else
    Region._AnimationRegion:SetAlpha(Alpha);
  end

  Region._AnimationRegion:SetPoint("CENTER", Region, "CENTER", XOffset, YOffset);

end


-----------------------------------------------------------------
-- Function UpdateAnimationRegionSize
-----------------------------------------------------------------
function AuraFrames:UpdateAnimationRegionSize(Region)

  if not Region._AnimationRegion then

    Region._AnimationRegion = _G[Region:GetName().."Content"]

    if not Region._AnimationRegion then
      return;
    end

    Region:HookScript("OnSizeChanged", function() RegionUpdateSize(Region); end);
    Region:HookScript("OnShow", function() RegionUpdateSize(Region); end);

    RegionUpdateSize(Region);

    Region._AnimationRegion:SetPoint("CENTER", Region, "CENTER", 0, 0);
    Region._AnimationRegion:SetFrameStrata(Region:GetFrameStrata());
    Region._AnimationRegion:SetFrameLevel(Region:GetFrameLevel());

  end

end

-----------------------------------------------------------------
-- Function NewAnimation
-----------------------------------------------------------------
function AuraFrames:NewAnimation(Config)

  Config = Config or {};

  local Animation = {};
  
  setmetatable(Animation, {__index = AnimationPrototype});
  
  Animation.Regions = {};

  Animation.PoolRegionData = {};

  Animation:SetConfig(Config or {});

  tinsert(Animations, Animation);
  
  return Animation;

end



-----------------------------------------------------------------
-- Function AnimationUpdate
-----------------------------------------------------------------
function AuraFrames:AnimationUpdate(Elapsed)

  local HaveRunningAnimations = false;

  for _, Animation in pairs(Animations) do

    for Region, _ in pairs(Animation.Regions) do
    
      local RegionData = Animation.Regions[Region];
      
      EffectResult.Scale = 1;
      EffectResult.Alpha = 1;
      EffectResult.XOffset = 0;
      EffectResult.YOffset = 0;
    
      RegionData.Time = RegionData.Time + (Elapsed * Animation.Speed);

      local IsRunning = RegionData.Time <= Animation.TotalDuration + Animation.EndDelay;
      local InProgress = RegionData.Time <= Animation.TotalDuration;
      local HaveEffects = false;
      
      for i, Effect in ipairs(Animation.Effects) do

        local Properties = Effect.Properties;
      
        if Properties.Duration then
      
          local Progression = (RegionData.Time - Properties.Start) / (Properties.Duration * Properties.Times);
          if Progression > 1 and RegionData.State[Effect] ~= true then

            RegionData.State[Effect] = true;

            if not InProgress and Effect.NextTypeEffect == nil then
              Progression = 1;
            end

          end

          if Progression <= 1 and Progression >= 0 then
          
            Progression = Progression * Properties.Times;
            
            if Progression > 1 then
            
              local Fraction = Progression % 1;
              
              Progression = Properties.Bounce == true and (Progression % 2 > 1 and 1 - Fraction or Fraction) or Fraction;
              
            end

            if Properties.Smoothing == "SinSNS" then
            
              -- Sinus: Slow - Normal - Slow
              -- plot x=-1..1, p=(cos(PI + (PI * x)) + 1) / 2
              Progression = (math_cos(PI + (PI * Progression)) + 1) / 2;
            
            elseif Properties.Smoothing == "SinSN" then
            
              -- Sinus: Slow - Normal
              -- plot x=-1..1, p=(cos(PI + (PI * x)/2) + 1)
              Progression = math_cos(PI + (PI * Progression) / 2) + 1;
            
            elseif Properties.Smoothing == "SinNS" then
            
              -- Sinus: Normal - Slow
              -- plot x=-1..1, p=cos(PI + (PI/2) + (PI * (x/2)))
              Progression = math_cos(PI + PI_2 + (PI * (Progression / 2)));
            
            end

            Effect.Function(Region._AnimationRegion, EffectResult, Properties, Progression);
            HaveEffects = true;
              
          end
          
        elseif RegionData.Time > Properties.Start and RegionData.State[Effect] ~= true then
          
          RegionData.State[Effect] = true;
          Effect.Function(Region._AnimationRegion, EffectResult, Properties);
          HaveEffects = true;

        end
      
      end

      if HaveEffects == true and Region._Animations and Region._Animations[Animation] then

        Region._Animations[Animation].Scale = EffectResult.Scale;
        Region._Animations[Animation].Alpha = EffectResult.Alpha;
        Region._Animations[Animation].XOffset = EffectResult.XOffset;
        Region._Animations[Animation].YOffset = EffectResult.YOffset;
      
        UpdateRegions[Region] = true;

      end

      if IsRunning ~= true then
      
        Animation:Stop(Region, true);

      end
      
    end

    if next(Animation.Regions) ~= nil then
      HaveRunningAnimations = true
    end

  end
  
  if HaveRunningAnimations == false then
    UpdateFrame:Hide();
  end

  for Region, Value in pairs(UpdateRegions) do
    if Value == true then
      AuraFrames:ApplyAnimationEffects(Region);
      UpdateRegions[Region] = false;
    end
  end

end


-----------------------------------------------------------------
-- Function StopAnimations
-----------------------------------------------------------------
function AuraFrames:StopAnimations(Region)

  if not Region._Animations then
    return;
  end
  
  for Animation, _ in pairs(Region._Animations) do
  
    Animation:Stop(Region);
  
  end

end


-----------------------------------------------------------------
-- Function ClearAnimationEffects
-----------------------------------------------------------------
function AuraFrames:ClearAnimationEffects(Region)

  if Region._Animations then

    for _, Effects in pairs(Region._Animations) do
      if #PoolRegionEffects <= PoolRegionEffectsMaxSize then
        tinsert(PoolRegionEffects, Effects);
      else
        break;
      end
    end

    Region._Animations = nil;

  end

  AuraFrames:ApplyAnimationEffects(Region);

  Region._AnimationRegion:SetFrameStrata(Region:GetFrameStrata());
  Region._AnimationRegion:SetFrameLevel(Region:GetFrameLevel());

end


-----------------------------------------------------------------
-- Function GetSupportedAnimationSmoothing
-----------------------------------------------------------------
function AuraFrames:GetSupportedAnimationSmoothing()

  return {
    None = "No smoothing",
    SinSNS = "Sinus: Slow > Normal > Slow",
    SinSN = "Sinus: Slow > Normal",
    SinNS = "Sinus: Normal > Slow",
  };

end

