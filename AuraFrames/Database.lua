local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

-- Import used global references into the local namespace.
local tinsert, tremove, tconcat, sort, tContains = tinsert, tremove, table.concat, sort, tContains;
local fmt, tostring = string.format, tostring;
local select, ipairs, pairs, next, type, unpack = select, ipairs, pairs, next, type, unpack;
local loadstring, assert, error = loadstring, assert, error;
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget;
local GetTime = GetTime;

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: LibStub

-- This version will be used to trigger database upgrades
AuraFrames.DatabaseVersion = 235;


--[[

  Database version history list:

  Version 200:
    First release. Any older database will be reseted (alpha and beta versions).
  
  Version 201:
    Added warning changing.
    Added warnings to bar containers.
  
  Version 202:
    Add BarUseAuraTime for bar containers
   
  Version 203:
    Added BackgroundBorderSize to timeline container
  
  Version 204:
    Added time labels to timeline container
  
  Version 205:
    Added InactiveAlpha to timeline container
  
  Version 206:
    BarContainer now have borders
    BarContainer now also support configuration of the spark
  
  Version 207:
    ButtonFacade skin "Aura Frames Default" renamed to "Aura Frames"
  
  Version 208:
    AuraDefinition: Name changed to SpellName, ItemName added
  
  Version 209:
    ShowSpellId renamed to ShowAuraId
   
  Version 210:
    Added to TimeLine: Length/Width, ButtonOffset, ButtonIndent, ButtonScale, TextOffset and BackgroundTextureFlipX/BackgroundTextureFlipY/BackgroundTextureRotate
  
  Version 211:
    Removed from the BarContainer the button background options, added BarTextureFlipX/BarTextureFlipY/BarTextureRotate
  
  Version 212:
    Added TimeFlow to the timeline container
    
  Version 213:
    Fixed a typo (casted => cast)
  
  Version 214:
    Implemented auto text labels for TimeLine
    
  Version 215:
    Implemented dynamic colors
  
  Version 216:
    Added MiniBar to button container
    
  Version 217:
    Variable type Float is now used for time for filtering
    
  Version 218:
    Buttons and bars have a seperate heights/width now that can be configured
    
  Version 219:
    Added customer spell cooldown ids
  
  Version 220:
    Remove ButtonFacade config
  
  Version 221:
    Added Visibility options
    
  Version 222:
    Added inverse bar option
  
  Version 223:
    Added VisibleWhenNot

  Version 223:
    Added global setting HideInPetBattle

  Version 224:
    Added show border to containers

  Version 226:
    Added TooltipShowUnitName

  Version 227:
    Renamed unit boss to bossmod

  Version 228:
    Added DisableMasqueSkinWarnings

  Version 229:
    Removed Layout.InactiveAlpha for TimeLine
    Removed unused Visibility settings
    Migrate Warnings to Animations
    Add to all timeline containers the animation Cluster:Fade

  Version 230:
    Added DurationAlignment and CountAlignment to button container

  Version 231:
    Added EnableTimeExtOverrule and TimeExtRequirement

  Version 232:
    Fixed a bug with database upgrade 230. CountAlignment didnt get upgraded

  Version 233:
    Added CancelCombatAura

  Version 234:
    Added 129249 & 129250 to the Priest SpellCooldowns
  
  Version 235:
    Added MouseEventsWhenInactive to ContainerVisibility animation.

]]--


-----------------------------------------------------------------
-- Database defaults
-----------------------------------------------------------------
local DatabaseDefaults = {
  profile = {
    DbVersion = 0;
    Containers = {
      ["*"] = {
        Name = "",
        Type = "",
        Enabled = true,
        Sources = {},
      },
    },
    HideBlizzardAuraFrames = true,
    HideBossModsBars = false,
    HideInPetBattle = true,
    EnableTimeExtOverrule = false,
    TimeExtRequirement = 10,
    CancelCombatAura = {

      Enabled = false,
      IncludeWeaponEnchantments = true,
      ShowTooltip = true,
      Order = "NAME",
      OrderReverse = false,
      HorizontalSize = 8,
      VerticalSize = 4,
      SpaceX = 10,
      SpaceY = 30,
      OnlyRightButton = false,
      Keybinding = nil,
      ToggleMode = false,

      ShowDuration = true,
      DurationFont = "Friz Quadrata TT",
      DurationOutline = "OUTLINE",
      DurationMonochrome = false,
      DurationLayout = "ABBREVSPACE",
      DurationSize = 16,
      DurationPosX = 0,
      DurationPosY = -47,
      DurationColor = {1, 1, 1, 1},
      DurationAlignment = "CENTER",

      ShowCount = true,
      CountFont = "Friz Quadrata TT",
      CountOutline = "OUTLINE",
      CountMonochrome = false,
      CountSize = 16,
      CountPosX = 20,
      CountPosY = -20,
      CountColor = {1, 1, 1, 1},
      CountAlignment = "CENTER",

    },
  },
  global = {
    SpellCooldowns = {
      PRIEST = {
        88625,
        88684,
        88685,
        129249,
        129250,
      },
    },
  },
};


-----------------------------------------------------------------
-- Function DatabaseInitialize
-----------------------------------------------------------------
function AuraFrames:DatabaseInitialize()

  -- Init db.
  self.db = LibStub("AceDB-3.0"):New("AuraFramesDB", DatabaseDefaults);
  
  -- Enable dual spec.
  LibStub("LibDualSpec-1.0"):EnhanceDatabase(self.db, "AuraFrames");
  
  -- Initialize profile.
  self:DatabaseProfileInitialize();

  -- Register db chat commands.
  self:RegisterChatCommand("afreset", "DatabaseReset");
  self:RegisterChatCommand("affixdb", "DatabaseFix");

  -- Register database callbacks
  self.db.RegisterCallback(self, "OnProfileChanged", "DatabaseChanged");
  self.db.RegisterCallback(self, "OnProfileCopied", "DatabaseChanged");
  self.db.RegisterCallback(self, "OnProfileReset", "DatabaseChanged");

end


-----------------------------------------------------------------
-- Function DatabaseProfileInitialize
-----------------------------------------------------------------
function AuraFrames:DatabaseProfileInitialize()

  if self.db.profile.DbVersion == 0 then
  
    self.db.profile.DbVersion = AuraFrames.DatabaseVersion;
  
    -- Make sure we are having an empty profile.
    
    if next(self.db.profile.Containers) == nil then

      local Id, Container;
      
      Id = self:CreateNewContainerConfig("Player Buffs", "ButtonContainer");
      
      Container = self.db.profile.Containers[Id];
      Container.Location.FramePoint = "TOPRIGHT";
      Container.Location.RelativePoint = "TOPRIGHT";
      Container.Location.OffsetY = -7.5;
      Container.Location.OffsetX = -183.5;
      Container.Sources.player = {
        HELPFUL = true,
        WEAPON = true,
      };
      
      
      Id = self:CreateNewContainerConfig("Player Debuffs", "ButtonContainer");

      Container = self.db.profile.Containers[Id];
      Container.Location.FramePoint = "TOPRIGHT";
      Container.Location.RelativePoint = "TOPRIGHT";
      Container.Location.OffsetY = -106.5;
      Container.Location.OffsetX = -183.5;
      Container.Sources.player = {
        HARMFUL = true,
      };
    
    end

  end


  -- Check if we need a db upgrade.
  if self.db.profile.DbVersion < AuraFrames.DatabaseVersion then
    
     self:Print("Old database version found, upgrading it automatically.");
     self:DatabaseUpgrade();
  
  end

end


-----------------------------------------------------------------
-- Function DatabaseFix
-----------------------------------------------------------------
function AuraFrames:DatabaseFix()

  self:Print("Trying to fix the database");

  -- Force run the upgrade code.
  self:DatabaseUpgrade();
  
  -- Notify of the db changes.
  self:DatabaseChanged();

end


-----------------------------------------------------------------
-- Function DatabaseChanged
-----------------------------------------------------------------
function AuraFrames:DatabaseChanged()

  -- The database changed, destroy all current container
  -- instances and create the containers based on the
  -- new database.
  
  self:DeleteAllContainers();
  
  -- Check new profile.
  self:DatabaseProfileInitialize();
  
  self:CreateAllContainers();
  
  self:CheckBlizzardAuraFrames();

end


-----------------------------------------------------------------
-- Function DatabaseReset
-----------------------------------------------------------------
function AuraFrames:DatabaseReset()

  self.db:ResetDB();
  
  -- With a db reset we lose LibDualSpec. But LibDualSpec don't
  -- let us register the db again. So lets do some hacking.
  
  -- Reset the registry state for our db.
  LibStub("LibDualSpec-1.0").registry[self.db] = nil;
  
  -- Register our self with LibDualSpec.
  LibStub("LibDualSpec-1.0"):EnhanceDatabase(self.db, "AuraFrames");
  
  self:Print("Database is reseted to the default settings");

end


-----------------------------------------------------------------
-- Function CopyDatabaseDefaults
-----------------------------------------------------------------
function AuraFrames:CopyDatabaseDefaults(Source, Destination)

  -- Shameless copied from AceDB and modified for our needs and style :)

  if type(Destination) ~= "table" then
    Destination = {};
  end

  if type(Source) == "table" then

    for Key, Value in pairs(Source) do

      if type(Destination[Key]) == "nil" then
      
        if type(Value) == "table" then
        
          Value = self:CopyDatabaseDefaults(Value, Destination[Key]);
          
        end
      
        Destination[Key] = Value;
      
      elseif type(Destination[Key]) == "table" then
      
        self:CopyDatabaseDefaults(Value, Destination[Key]);
      
      end

    end

  end

  return Destination;

end


-----------------------------------------------------------------
-- Function DatabaseUpgrade
-----------------------------------------------------------------
function AuraFrames:DatabaseUpgrade()

  -- See the "Database version history list" in the top of
  -- this file for more information.

  local OldVersion = self.db.profile.DbVersion;
  
  -- General upgrade code.
  if self.db.global.SpellCooldowns == nil then
  
    self.db.global.SpellCooldowns = {
      PRIEST = {
        88625,
        88684,
        88685,
      },
    };
  
  end

  if OldVersion < 234 and self.db.global.SpellCooldowns.PRIEST then

    if not tContains(self.db.global.SpellCooldowns.PRIEST, 129249) then
      tinsert(self.db.global.SpellCooldowns.PRIEST, 129249);
    end

    if not tContains(self.db.global.SpellCooldowns.PRIEST, 129250) then
      tinsert(self.db.global.SpellCooldowns.PRIEST, 129250);
    end

  end

  if self.db.profile.HideInPetBattle == nil then
    self.db.profile.HideInPetBattle = false;
  end

  if self.db.profile.DisableMasqueSkinWarnings == nil then
    self.db.profile.DisableMasqueSkinWarnings = false;
  end
  
  if self.db.profile.EnableTimeExtOverrule == nil then
    self.db.profile.EnableTimeExtOverrule = false;
  end

  if self.db.profile.TimeExtRequirement == nil then
    self.db.profile.TimeExtRequirement = 10;
  end

  if self.db.profile.CancelCombatAura == nil then
    self.db.profile.CancelCombatAura = DatabaseDefaults.profile.CancelCombatAura;
  end

  -- Loop thru the containers and update the defaults.
  for _, Container in pairs(self.db.profile.Containers) do
    self:DatabaseContainerUpgrade(Container);
  end

  self.db.profile.DbVersion = AuraFrames.DatabaseVersion;
  
end


-----------------------------------------------------------------
-- Function DatabaseContainerUpgrade
-----------------------------------------------------------------
function AuraFrames:DatabaseContainerUpgrade(Container)

  local OldVersion = Container.Version or self.db.profile.DbVersion;

  if OldVersion < 201 then
  
    if Container.Type == "ButtonContainer" then
  
      Container.Warnings.Changing = {
        Popup = false,
        PopupTime = 0.5,
        PopupScale = 3.0,
      };
    
    elseif Container.Type == "BarContainer" then
    
      Container.Warnings = {
        New = {
          Flash = false,
          FlashNumber = 3.0,
          FlashSpeed = 1.0,
        },
        Expire = {
          Flash = false,
          FlashNumber = 5.0,
          FlashSpeed = 1.0,
        },
        Changing = {
          Popup = false,
          PopupTime = 0.5,
          PopupScale = 3.0,
        },
      };
    
    end
  
  end

  if OldVersion < 202 then
  
    if Container.Type == "BarContainer" then
    
      Container.Layout.BarUseAuraTime = false;
    
    end
  
  end
  
  if OldVersion < 203 then
  
    if Container.Type == "TimeLineContainer" then
    
      Container.Layout.BackgroundTextureInsets = 2;
      Container.Layout.BackgroundBorderSize = 8;
    
    end
  
  end
  
  if OldVersion < 204 then
  
    if Container.Type == "TimeLineContainer" then
    
      Container.Layout.TextLabels = {1, 10, 20, 30};
    
    end
  
  end
  
  if OldVersion < 205 then
  
    if Container.Type == "TimeLineContainer" then
    
      Container.Layout.InactiveAlpha = 1.0;
    
    end
  
  end
  
  if OldVersion < 206 then
  
    if Container.Type == "BarContainer" then
    
      Container.Layout.BarTextureInsets = 2;
      Container.Layout.BarBorder = "Blizzard Tooltip";
      Container.Layout.BarBorderSize = 8;
      Container.Layout.BarBorderColorAdjust = 0.4;

      Container.Layout.ShowSpark = true;
      Container.Layout.SparkUseBarColor = false;
      Container.Layout.SparkColor = {1.0, 1.0, 1.0, 1.0};
      
    end
  
  end
  
  if OldVersion < 207 then
  
    if Container.ButtonFacade and Container.ButtonFacade.SkinId == "Aura Frames Default" then
    
      Container.ButtonFacade.SkinId = "Aura Frames";
    
    end
  
  end
  
  if OldVersion < 208 then
  
    if Container.Filter and Container.Filter.Groups then
    
      for _, Group in pairs(Container.Filter.Groups) do
      
        for _, Rule in pairs(Group) do
        
          if Rule.Subject == "Name" then
            Rule.Subject = "SpellName";
          end
        
        end
      
      end
    
    end

    if Container.Order and Container.Order.Rules then
    
      for _, Rule in pairs(Container.Order.Rules) do
      
        if Rule.Subject == "Name" then
          Rule.Subject = "SpellName";
        end
      
      end
      
    end
  
  end
  
  if OldVersion < 209 then
  
    if Container.Layout and Container.Layout.TooltipShowSpellId then
    
       Container.Layout.TooltipShowAuraId = Container.Layout.TooltipShowSpellId;
       Container.Layout.TooltipShowSpellId = nil;
    
    end
  
  end
  
  if OldVersion < 210 then
  
    if Container.Type == "TimeLineContainer" then
    
      Container.Layout.ButtonOffset = 0;
      Container.Layout.ButtonScale = 1.0;
      Container.Layout.ButtonIndent = true;
      
      Container.Layout.TextOffset = 0;
      
      Container.Layout.BackgroundTextureFlipX = false;
      Container.Layout.BackgroundTextureFlipY = false;
      Container.Layout.BackgroundTextureRotate = false;
      
      Container.Layout.Length = Container.Layout.Size;
      Container.Layout.Width = 36;
      Container.Layout.Size = nil;
    
    end
  
  end

  if OldVersion < 211 then
  
    if Container.Type == "BarContainer" then
    
      Container.Layout.ButtonBackgroundColor = nil;
      Container.Layout.ButtonBackgroundUseBar = nil;
      Container.Layout.ButtonBackgroundOpacity = nil;
      
      Container.Layout.BarTextureFlipX = false;
      Container.Layout.BarTextureFlipY = false;
      Container.Layout.BarTextureRotate = false;
      
    end
  
  end
  
  if OldVersion < 212 then
  
    if Container.Type == "TimeLineContainer" then
    
      Container.Layout.TimeFlow = "POW";
      
    end
  
  end
  
  if OldVersion < 213 then
  
    local PredefinedList = {
      CastedByMe = "CastByMe",
      NotCastedByMe = "NotCastByMe",
      CastedBySameClass = "CastBySameClass",
      HarmfulOnFriendlyAndHelpfulOnHostile = "DebuffOnHelpAndBuffOnHarm",
    };
  
    for Name, Value in pairs(Container.Filter.Predefined or {}) do
    
      if PredefinedList[Name] then
      
        if Value == true then
          Container.Filter.Predefined[PredefinedList[Name]] = true;
        end
        
        Container.Filter.Predefined[Name] = nil;
      
      end
    
    end
    
    local SubjectList = {
      CastedByMe = "CastByMe",
      CastedByParty = "CastByParty",
      CastedByRaid = "CastByRaid",
      CastedByBgRaid = "CastByBgRaid",
      CastedByPlayer = "CastByPlayer",
      CastedByHostile = "CastByHostile",
      CastedByFriendly = "CastByFriendly",
    };
  
    for _, Group in ipairs(Container.Filter.Groups or {}) do
    
      for _, Rule in ipairs(Group) do
      
        if SubjectList[Rule.Subject] then
          Rule.Subject = SubjectList[Rule.Subject];
        end
      
      end
    
    end

  end
  
  if OldVersion < 214 then
  
    if Container.Type == "TimeLineContainer" then
    
      Container.Layout.TextLabelsAuto = false;
      Container.Layout.TextLabelAutoSpace = 10;
      
    end
  
  end

  if OldVersion < 215 then
    
    local OldColors = Container.Colors;
    
    Container.Colors = {
      Expert = false,
      DefaultColor = OldColors.Other,
      Rules = {
        {
          Name = "Unknown Debuff Type",
          Color = OldColors.Debuff.None,
          Groups = {
            {
              {Args = {String = "HARMFUL"}, Subject = "Type", Operator = "Equal"},
              {Args = {String = "None"}, Subject = "Classification", Operator = "Equal"},
            },
          },
        },
        {
          Name = "Debuff Type Magic",
          Color = OldColors.Debuff.Magic,
          Groups = {
            {
              {Args = {String = "HARMFUL"}, Subject = "Type", Operator = "Equal"},
              {Args = {String = "Magic"}, Subject = "Classification", Operator = "Equal"},
            },
          },
        },
        {
          Name = "Debuff Type Curse",
          Color = OldColors.Debuff.Curse,
          Groups = {
            {
              {Args = {String = "HARMFUL"}, Subject = "Type", Operator = "Equal"},
              {Args = {String = "Curse"}, Subject = "Classification", Operator = "Equal"},
            },
          },
        },
        {
          Name = "Debuff Type Disease",
          Color = OldColors.Debuff.Disease,
          Groups = {
            {
              {Args = {String = "HARMFUL"}, Subject = "Type", Operator = "Equal"},
              {Args = {String = "Disease"}, Subject = "Classification", Operator = "Equal"},
            },
          },
        },
        {
          Name = "Debuff Type Poison",
          Color = OldColors.Debuff.Poison,
          Groups = {
            {
              {Args = {String = "HARMFUL"}, Subject = "Type", Operator = "Equal"},
              {Args = {String = "Poison"}, Subject = "Classification", Operator = "Equal"},
            },
          },
        },
        {
          Name = "Buff",
          Color = OldColors.Buff,
          Groups = {
            {
              {Args = {String = "HELPFUL"}, Subject = "Type", Operator = "Equal"},
            },
          },
        },
        {
          Name = "Weapon",
          Color = OldColors.Weapon,
          Groups = {
            {
              {Args = {String = "WEAPON"}, Subject = "Type", Operator = "Equal"},
            },
          },
        },
      },
    };
  
  end
  
  if OldVersion < 216 then
  
    if Container.Type == "ButtonContainer" then
    
      Container.Layout.MiniBarEnabled = false;
      Container.Layout.MiniBarStyle = "HORIZONTAL";
      Container.Layout.MiniBarDirection = "HIGHSHRINK";
      Container.Layout.MiniBarTexture = "Blizzard";
      Container.Layout.MiniBarColor = {1.0, 1.0, 1.0, 1.0};
      Container.Layout.MiniBarLength = 36;
      Container.Layout.MiniBarWidth = 8;
      Container.Layout.MiniBarOffsetX = 0;
      Container.Layout.MiniBarOffsetY = -25;
      
    end
  
  end
  
  if OldVersion < 217 then
  
    local TimeDefinitions = {
      Duration = true,
      Remaining = true,
      ExpirationTime = true,
    };
  
    if Container.Filter then
      for _, Group in ipairs(Container.Filter.Groups or {}) do
      
        for _, Rule in ipairs(Group) do
        
          if TimeDefinitions[Rule.Subject] and Rule.Args.Number then
            Rule.Args.Float = Rule.Args.Number;
            Rule.Args.Number = nil;
          end
        
        end
      
      end
    end
    
    if Container.Order then
      for _, Group in ipairs(Container.Order.Groups or {}) do
      
        for _, Rule in ipairs(Group) do
        
          if TimeDefinitions[Rule.Subject] and Rule.Args.Number then
            Rule.Args.Float = Rule.Args.Number;
            Rule.Args.Number = nil;
          end
        
        end
      
      end
    end
    
    if Container.Colors then
      for _, ColorRule in ipairs(Container.Colors.Rules or {}) do
      
        for _, Group in ipairs(ColorRule.Groups or {}) do
      
          for _, Rule in ipairs(Group) do
          
            if TimeDefinitions[Rule.Subject] and Rule.Args.Number then
              Rule.Args.Float = Rule.Args.Number;
              Rule.Args.Number = nil;
            end
          
          end
          
        end
      
      end
    end

  end
  
  if OldVersion < 218 then
  
    if Container.Type == "ButtonContainer" then
    
      Container.Layout.ButtonSizeX = 36;
      Container.Layout.ButtonSizeY = 36;
      
    end
    
    if Container.Type == "TimeLineContainer" then
    
      Container.Layout.ButtonSizeX = 36;
      Container.Layout.ButtonSizeY = 36;
      
    end
    
    if Container.Type == "BarContainer" then
    
      Container.Layout.BarHeight = 36;
      
    end
  
  end
  
  if OldVersion < 220 then
  
    if Container.ButtonFacade then
      Container.ButtonFacade = nil;
    end
  
  end
  
  if OldVersion < 221 then
  
    if not Container.Visibility then
      Container.Visibility = {
        AlwaysVisible = true,
        FadeIn = true,
        FadeInTime = 0.5,
        FadeOut = true,
        FadeOutTime = 0.5,
        OpacityVisible = 1,
        OpacityNotVisible = 0,
        VisibleWhen = {},
      };
    end
  
  end
  
  if OldVersion < 222 then
  
    if Container.Type == "BarContainer" then
    
      Container.Layout.InverseOnNoTime = false;
      Container.Layout.HideSparkOnNoTime = true;
      
    end
  
  end

  if OldVersion < 223 then

    if Container.Visibility then

      Container.Visibility.VisibleWhenNot = {};

    end
  
  end

  if OldVersion < 225 then

    if Container.Layout then

      Container.Layout.ShowBorder = "ALWAYS";

    end
  
  end

  if OldVersion < 226 then

    if Container.Layout then

      Container.Layout.TooltipShowUnitName = false;

    end
  
  end
  
  if OldVersion < 227 then

    if Container.Sources then

      Container.Sources.bossmod = Container.Sources.boss;
      Container.Sources.boss = nil;

    end
  
  end

  if OldVersion < 229 then

    if not Container.Animations then
      Container.Animations = {};
    end

    if Container.Warnings then

      local Warnings = Container.Warnings;

      if Warnings.New and Warnings.New.Flash == true then

        Container.Animations["AuraNew"] = {
          Enabled = true,
          Animation = "Flash",
          Times = Warnings.New.FlashNumber,
          Duration = Warnings.New.FlashSpeed,
        };

      end

      if Warnings.Changing and Warnings.Changing.Popup == true then

        Container.Animations["AuraChanging"] = {
          Enabled = true,
          Animation = "Popup",
          Duration = Warnings.Changing.PopupTime,
          Scale = Warnings.Changing.PopupScale,
        };

      end

      if Warnings.Expire and Warnings.Expire.Flash == true then

        Container.Animations["AuraExpiring"] = {
          Enabled = true,
          Animation = "Flash",
          Times = Warnings.Expire.FlashNumber,
          Duration = Warnings.Expire.FlashSpeed,
        };

      end

    end

    Container.Warnings = nil;

    if Container.Type == "TimeLineContainer" then

      Container.Animations["TimeLineCluster"] = {
        Enabled = true,
        Animation = "Fade",
        Speed = 1.0,
        Delay = 1.0,
      };

    end

    if Container.Layout.InactiveAlpha and Container.Layout.InactiveAlpha ~= 1 then

      Container.Animations["ContainerVisibility"] = {
        Enabled = true,
        Animation = "Fade",
        Duration = 0.5,
        InvisibleAlpha = Container.Layout.InactiveAlpha,
      };

    end

    Container.Layout.InactiveAlpha = nil;

    if Container.Visibility then

      local Visibility = Container.Visibility;

      Visibility.FadeIn = nil;
      Visibility.FadeInTime = nil;
      Visibility.FadeOut = nil;
      Visibility.FadeOutTime = nil;
      Visibility.OpacityVisible = nil;
      Visibility.OpacityNotVisible = nil;

    end
  
  end

  if OldVersion < 230 then

    if Container.Type == "ButtonContainer" then

      Container.Layout.DurationAlignment = "CENTER";
      Container.Layout.CountAlignment = "CENTER";

    end
  
  end

  if OldVersion < 232 then

    if Container.Type == "ButtonContainer" then

      if not Container.Layout.CountAlignment then
        Container.Layout.CountAlignment = "CENTER";
      end

    end
  
  end
  
  if OldVersion < 235 then
  
    if Container.Animations and Container.Animations["ContainerVisibility"] then
      Container.Animations["ContainerVisibility"].MouseEventsWhenInactive = true;
    end

  end

end
