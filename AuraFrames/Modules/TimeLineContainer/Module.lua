local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local Module = AuraFrames:NewContainerModule("TimeLineContainer");
local MSQ = LibStub("Masque", true);

-- Import most used functions into the local namespace.
local tinsert, tremove, tconcat, sort = tinsert, tremove, table.concat, sort;
local fmt, tostring = string.format, tostring;
local select, pairs, next, type, unpack = select, pairs, next, type, unpack;
local loadstring, assert, error = loadstring, assert, error;
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget;
local GetTime, CreateFrame, CreateFont = GetTime, CreateFrame, CreateFont;
local _G = _G;

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: UIParent

-- List that contains the function prototypes for container objects.
Module.Prototype = {};

-- List of all active containers that are based on this module.
Module.Containers = {};

-----------------------------------------------------------------
-- Function OnInitialize
-----------------------------------------------------------------
function Module:OnInitialize()


end


-----------------------------------------------------------------
-- Function OnEnable
-----------------------------------------------------------------
function Module:OnEnable()

end


-----------------------------------------------------------------
-- Function OnDisable
-----------------------------------------------------------------
function Module:OnDisable()

end


-----------------------------------------------------------------
-- Function GetName
-----------------------------------------------------------------
function Module:GetName()

  return "TimeLine";

end


-----------------------------------------------------------------
-- Function GetDescription
-----------------------------------------------------------------
function Module:GetDescription()

  return "A container that use a time line to display aura's";

end


-----------------------------------------------------------------
-- Function GetSupportedAnimationTypes
-----------------------------------------------------------------
function Module:GetSupportedAnimationTypes()

  return {
    "AuraNew",
    "AuraChanging",
    "AuraExpiring",
    "TimeLineCluster",
    "ContainerVisibility",
  };

end

-----------------------------------------------------------------
-- Function GetDatabaseDefaults
-----------------------------------------------------------------
function Module:GetDatabaseDefaults()

  local DatabaseDefaults = {
    Location= {
      OffsetX = 0,
      OffsetY = -300,
      FramePoint = "CENTER",
      RelativePoint = "CENTER",
    },
    Layout = {
    
      Scale = 1.0,
      Length = 400,
      Width = 36,
      Style = "HORIZONTAL",
      Direction = "HIGH",
      MaxTime = 30,
      TimeFlow = "POW",
      TimeCompression = 0.3,
      ShowBorder = "ALWAYS",
      
      ButtonOffset = 0,
      ButtonScale = 1.0,
      ButtonIndent = true,
      ButtonSizeX = 36,
      ButtonSizeY = 36,
      
      ShowDuration = true,
      DurationFont = "Friz Quadrata TT",
      DurationOutline = "OUTLINE",
      DurationMonochrome = false,
      DurationLayout = "ABBREVSPACE",
      DurationSize = 12,
      DurationPosX = 0,
      DurationPosY = -8.5,
      DurationColor = {1, 1, 1, 1},

      ShowCount = false,
      CountFont = "Friz Quadrata TT",
      CountOutline = "OUTLINE",
      CountMonochrome = false,
      CountSize = 10,
      CountPosX = 8,
      CountPosY = 4,
      CountColor = {1, 1, 1, 1},

      ShowText = true,
      TextFont = "Friz Quadrata TT",
      TextOutline = "OUTLINE",
      TextMonochrome = false,
      TextLayout = "ABBREVSPACE",
      TextSize = 10,
      TextPos = 0,
      TextColor = {1, 1, 1, 1},
      TextLabels = {},
      TextLabelsAuto = true,
      TextLabelAutoSpace = 10,
      TextOffset = 0,
      
      Clickable = false,
      ShowTooltip = true,
      TooltipShowPrefix = false,
      TooltipShowCaster = true,
      TooltipShowAuraId = false,
      TooltipShowClassification = false,
      TooltipShowUnitName = false,

      BackgroundTexture = "Blizzard",
      BackgroundTextureColor = {0, 0.32, 0.82, 0.8},
      BackgroundTextureInsets = 2,
      BackgroundTextureFlipX = false,
      BackgroundTextureFlipY = false,
      BackgroundTextureRotate = false,
      
      BackgroundBorder = "Blizzard Tooltip",
      BackgroundBorderColor = {0.05, 0.3, 0.8, 0.8},
      BackgroundBorderSize = 8,
      
    },
    Animations = {
      AuraNew = {
        Enabled = true,
        Animation = "FadeIn",
        Duration = 0.5,
      },
      AuraChanging = {
        Enabled = true,
        Animation = "Popup",
        Duration = 0.3,
        Scale = 2.5,
      },
      AuraExpiring = {
        Enabled = true,
        Animation = "Explode",
        Duration = 0.5,
        Scale = 3.5,
      },
      TimeLineCluster = {
        Enabled = true,
        Animation = "Fade",
        Speed = 1.0,
        Delay = 1.0,
      },
      ContainerVisibility = {
        Enabled = true,
        Animation = "Fade",
        Duration = 0.5,
        InvisibleAlpha = 0.6,
        MouseEventsWhenInactive = false,
      },
    },
    Colors = AuraFrames:GetDatabaseDefaultColors(),
    Visibility = {
      AlwaysVisible = true,
      VisibleWhen = {},
      VisibleWhenNot = {},
    },
    Filter = AuraFrames:GetDatabaseDefaultFilter(),
  };
  
  return DatabaseDefaults;

end


-----------------------------------------------------------------
-- Function New
-----------------------------------------------------------------
function Module:New(Config)

  local Container = {};
  setmetatable(Container, { __index = self.Prototype});
  
  self.Containers[Config.Id] = Container;
  
  local FrameId = "AuraFramesTimeLineContainer_"..Config.Id;
  
  -- Reuse old containers if we can.
  if _G[FrameId] then
    Container.Frame = _G[FrameId];
  else
    Container.Frame = CreateFrame("Frame", FrameId, UIParent, "AuraFramesTimeLineContainerTemplate");
    Container.Frame:SetClampedToScreen(true);
  end

  Container.Module = self;
  
  Container.Content = _G[FrameId.."Content"];
  Container.FrameTexture = _G[FrameId.."ContentTexture"];

  Container.AnimationClusterGoVisible = AuraFrames:NewAnimation();
  Container.AnimationClusterGoInvisible = AuraFrames:NewAnimation();
  Container.AnimationAuraChanging = AuraFrames:NewAnimation();
  Container.AnimationAuraExpiring = AuraFrames:NewAnimation();
  Container.AnimationAuraNew = AuraFrames:NewAnimation();
  Container.AnimationGoingVisible = AuraFrames:NewAnimation();
  Container.AnimationGoingVisibleChild = AuraFrames:NewAnimation();
  Container.AnimationGoingInvisible = AuraFrames:NewAnimation();

  Container.Frame:Show();

  Container.Id = Config.Id;
  Container.Config = Config;

  -- PowTimeCompressionDivider is used as soon as the AuraList gets active.
  -- We can not do an container update (is use AuraList) before there is an AuraList object.
  -- Just set an working value, it will get update before it get visible.
  Container.PowTimeCompressionDivider = 1;
  
  Container.AuraList = AuraFrames:NewAuraList(Container, Config.Filter.Groups, nil, Config.Colors);
  
  Container.TooltipOptions = {};
  
  Container.Buttons = {};
  
  Container.ButtonPool = {};
  
  Container.MSQGroup = MSQ and MSQ:Group("AuraFrames", Config.Id) or nil;
  
  Container.DurationFontObject = _G[FrameId.."Content_DurationFont"] or CreateFont(FrameId.."Content_DurationFont");
  Container.CountFontObject = _G[FrameId.."Content_CountFont"] or CreateFont(FrameId.."Content_CountFont");
  Container.TextFontObject = _G[FrameId.."Content_TextFont"] or CreateFont(FrameId.."Content_TextFont");

  Container.TextLabels = {};

  Container.IsVisible = false;
  Container.ContainerVisibility = true;
  Container.VisibilityClickable = true;
  Container.RecieveMouseEvents = Config.Layout.Clickable;

  AuraFrames:UpdateAnimationRegionSize(Container.Frame);

  Container:Update();

  Container.Frame:SetScript("OnEvent", function() Container:Update(); end);
  Container.Frame:SetScript("OnEnter", function() Container:CheckVisibility(true); end);
  Container.Frame:SetScript("OnLeave", function() Container:CheckVisibility(false); end);
  Container.Frame:RegisterEvent("PLAYER_ENTERING_WORLD");
  Container.Frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");

  Container.TimeSinceLastUpdate = 0;
  Container.Frame:SetScript("OnUpdate", function(Button, Elapsed)
    
     Container.TimeSinceLastUpdate = Container.TimeSinceLastUpdate + Elapsed;
     if Container.TimeSinceLastUpdate > 0.2 then
        Container:ClusterDetection();
        Container.TimeSinceLastUpdate = 0.0;
     end
    
  end);
  
  AuraFrames:CheckVisibility(Container);

  return Container;

end
