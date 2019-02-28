local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

if not AuraFrames.Animations then
  AuraFrames.Animations = {};
end

AuraFrames.Animations.EffectConstructors = {};

local EffectConstructors = AuraFrames.Animations.EffectConstructors;


-----------------------------------------------------------------
-- Local Function EffectScale
-----------------------------------------------------------------
local function EffectScale(Region, RegionEffect, Properties, Progression)

  RegionEffect.Scale = RegionEffect.Scale * (Properties.From + ((Properties.To - Properties.From) * Progression));

  if Properties.IgnoreParent == true then

    RegionEffect.Scale = RegionEffect.Scale / Region:GetParent():GetEffectiveScale();

  end

  if RegionEffect.Scale <= 0 then
    RegionEffect.Scale = 0.01;
  end

end


-----------------------------------------------------------------
-- Function Scale
-----------------------------------------------------------------
function EffectConstructors:Scale(Properties)

  local ScaleProperties = {
    Start = Properties.Start or 0,
    From = Properties.From or 1,
    To = Properties.To or 1,
    Duration = Properties.Duration or 1,
    Smoothing = Properties.Smoothing or "None",
    Times = Properties.Times or 1,
    Bounce = Properties.Bounce or false,
    IgnoreParent = Properties.IgnoreParent or false,
  };
  
  return EffectScale, ScaleProperties;

end


-----------------------------------------------------------------
-- Local Function EffectAlpha
-----------------------------------------------------------------
local function EffectAlpha(Region, RegionEffect, Properties, Progression)
  
  RegionEffect.Alpha = RegionEffect.Alpha * (Properties.From + ((Properties.To - Properties.From) * Progression))

end


-----------------------------------------------------------------
-- Function Alpha
-----------------------------------------------------------------
function EffectConstructors:Alpha(Properties)

  local AlphaProperties = {
    Start = Properties.Start or 0,
    From = Properties.From or 1,
    To = Properties.To or 1,
    Duration = Properties.Duration or 1,
    Smoothing = Properties.Smoothing or "None",
    Times = Properties.Times or 1,
    Bounce = Properties.Bounce or false,
  };
  
  return EffectAlpha, AlphaProperties;

end


-----------------------------------------------------------------
-- Local Function EffectTranslation
-----------------------------------------------------------------
local function EffectTranslation(Region, RegionEffect, Properties, Progression)
  
  RegionEffect.XOffset = RegionEffect.XOffset + Properties.FromX + ((Properties.ToX - Properties.FromX) * Progression);
  RegionEffect.YOffset = RegionEffect.YOffset + Properties.FromY + ((Properties.ToY - Properties.FromY) * Progression);

  if Properties.IgnoreParent == true then

    local ParentScale = Region:GetParent():GetEffectiveScale();

    RegionEffect.XOffset = RegionEffect.XOffset / ParentScale;
    RegionEffect.YOffset = RegionEffect.YOffset / ParentScale;

  end

end


-----------------------------------------------------------------
-- Function Translation
-----------------------------------------------------------------
function EffectConstructors:Translation(Properties)

  local TranslationProperties = {
    Start = Properties.Start or 0,
    FromX = Properties.FromX or 0,
    FromY = Properties.FromY or 0,
    ToX = Properties.ToX or 0,
    ToY = Properties.ToY or 0,
    Duration = Properties.Duration or 1,
    Smoothing = Properties.Smoothing or "None",
    Times = Properties.Times or 1,
    Bounce = Properties.Bounce or false,
    IgnoreParent = Properties.IgnoreParent or false,
  };
  
  return EffectTranslation, TranslationProperties;

end


-----------------------------------------------------------------
-- Local Function EffectFrameLevel
-----------------------------------------------------------------
local function EffectFrameLevel(Region, RegionEffect, Properties)

  local Level;

  if Properties.Level ~= 0 then
    Level = Properties.Level;
  else
    Level = Region:GetFrameLevel();
  end

  Level = Level + Properties.Change;

  Region:SetFrameLevel(Level > 0 and Level or 1);

end


-----------------------------------------------------------------
-- Function FrameLevel
-----------------------------------------------------------------
function EffectConstructors:FrameLevel(Properties)

  local FrameLevelProperties = {
    Start = Properties.Start or 0,
    Level = Properties.Level or 0,
    Change = Properties.Change or 0,
  };
  
  return EffectFrameLevel, FrameLevelProperties;

end


-----------------------------------------------------------------
-- Local Function EffectFrameStrata
-----------------------------------------------------------------
local function EffectFrameStrata(Region, RegionEffect, Properties)
  
  Region:SetFrameStrata(Properties.Strata);

end


-----------------------------------------------------------------
-- Function FrameStrata
-----------------------------------------------------------------
function EffectConstructors:FrameStrata(Properties)

  local FrameStrataProperties = {
    Start = Properties.Start or 0,
    Strata = Properties.Strata or "MEDIUM",
  };
  
  return EffectFrameStrata, FrameStrataProperties;

end


-----------------------------------------------------------------
-- Local Function EffectCallBack
-----------------------------------------------------------------
local function EffectCallBack(Region, RegionEffect, Properties, Progression)
  
  if Properties.CallBack then
    Properties.CallBack(Region:GetParent(), Progression);
  end

end


-----------------------------------------------------------------
-- Function CallBack
-----------------------------------------------------------------
function EffectConstructors:CallBack(Properties)

  local CallBackProperties = {
    Start = Properties.Start or 0,
    Times = Properties.Times or 0,
    CallBack = Properties.CallBack or nil,
  };
  
  return EffectCallBack, CallBackProperties;

end


-----------------------------------------------------------------
-- Local Function EffectExternal
-----------------------------------------------------------------
local function EffectExternal(Region, RegionEffect, Properties, Progression)
  
  if Properties.External then
    Properties.External(Region, RegionEffect, Properties, Progression);
  end

end


-----------------------------------------------------------------
-- Function EffectExternal
-----------------------------------------------------------------
function EffectConstructors:External(Properties)
  
  local ExternalProperties = {
    Start = 0,
    Times = 1,
  };

  -- Copy all properties, the external effect may use it for his own.
  for Key, Value in pairs(Properties) do
    
    ExternalProperties[Key] = Value;

  end
  
  return EffectExternal, ExternalProperties;

end
