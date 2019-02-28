local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local Module = AuraFrames:GetModule("BarContainer");
local MSQ = LibStub("Masque", true);
local LSM = LibStub("LibSharedMedia-3.0");

-- Import most used functions into the local namespace.
local tinsert, tremove, tconcat, sort = tinsert, tremove, table.concat, sort;
local fmt, tostring = string.format, tostring;
local select, pairs, next, type, unpack = select, pairs, next, type, unpack;
local loadstring, assert, error = loadstring, assert, error;
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget;
local GetTime, CreateFrame, IsModifierKeyDown = GetTime, CreateFrame, IsModifierKeyDown;
local math_sin, math_cos, math_floor, math_ceil = math.sin, math.cos, math.floor, math.ceil;
local min, max = min, max;
local _G, PI = _G, PI;

local Prototype = Module.Prototype;

-- Pool that contains all the current unused bars sorted by type.
local BarPool = {};

-- All containers have also there own (smaller) pool.
local ContainerBarPoolSize = 5;

-- Counters for each Bar type.
local BarCounter = 0;-- Direction = {AnchorPoint, first X or Y, X Direction, Y Direction}
local DirectionMapping = {
  DOWN  = {"TOPLEFT",    -1},
  UP    = {"BOTTOMLEFT",  1},
};

-- How fast a bar will get updated.
local BarUpdatePeriod = 0.05;

-- Pre calculate pi * 2 (used for flashing bars).
local PI2 = PI + PI;

-- Pre calculate pi / 2 (used for popup bars).
local PI_2 = PI / 2;

-- Frame levels used for poping up bars.
local FrameLevelLow = 3;
local FrameLevelNormal = 6;
local FrameLevelHigh = 9;


-----------------------------------------------------------------
-- Local Function SetBarCoords
-----------------------------------------------------------------
local function SetBarCoords(Texture, FlipX, FlipY, Rotate, TexStart, TexEnd)

  local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = 0, 0, 0, 1, 1, 0, 1, 1;
  
  if FlipX == true then
  
    ULy, LLy = LLy, ULy; -- Flip upper left to lower left.
    URy, LRy = LRy, URy; -- Flip upper right to lower right.
  
  end
  
  if FlipY == true then
  
    ULx, URx = URx, ULx; -- Flip upper left to upper right.
    LLx, LRx = LRx, LLx; -- Flip lower left to lower right.
  
  end
  
  if Rotate == true then
  
    -- We rotate 90 degrees to the right.
    
    ULx, ULy, URx, URy, LRx, LRy, LLx, LLy = LLx, LLy, ULx, ULy, URx, URy, LRx, LRy;
    
  end
  
  if Rotate == true then
  
    Texture:SetTexCoord(
      ULx,
      ULy == 0 and TexStart or 1 - TexStart,
      LLx,
      LLy == 0 and TexStart or 1 - TexStart,
      URx,
      URy == 0 and 1 - TexEnd or TexEnd,
      LRx,
      LRy == 0 and 1 - TexEnd or TexEnd
    );
  
  else
  
    Texture:SetTexCoord(
      ULx == 0 and TexStart or 1 - TexStart,
      ULy,
      LLx == 0 and TexStart or 1 - TexStart,
      LLy,
      URx == 0 and 1 - TexEnd or TexEnd,
      URy,
      LRx == 0 and 1 - TexEnd or TexEnd,
      LRy
    );
  
  end

end


-----------------------------------------------------------------
-- Local Function BarOnUpdate
-----------------------------------------------------------------
local function BarOnUpdate(Container, Bar, Elapsed)

  local Config = Container.Config;
  
  local TexStart, TexEnd = 0, 1;
  
  if Bar.Aura.ExpirationTime ~= 0 then
    
    local TimeLeft = max(Bar.Aura.ExpirationTime - GetTime(), 0);
    
    if Container.Config.Layout.ShowDuration == true then
    
      local TimeLeftSeconds = math_ceil((TimeLeft + 0.5) * 10);
      
      if Bar.TimeLeftSeconds ~= TimeLeftSeconds then
    
        Bar.Duration:SetFormattedText(AuraFrames:FormatTimeLeft(Config.Layout.DurationLayout, TimeLeft, false));
      
        Bar.TimeLeftSeconds = TimeLeftSeconds;
      
      end
    
    end
    
    if TimeLeft < Bar.BarMaxTime then
    
      local Part = TimeLeft / Bar.BarMaxTime;
    
      if Container.Shrink then
        Bar.Bar:SetWidth((Bar.WidthPerSecond * TimeLeft) + 1.0);
      else
        Bar.Bar:SetWidth(Container.BarWidth - (Bar.WidthPerSecond * TimeLeft));
      end
      
      local Part = TimeLeft / Bar.BarMaxTime;
      local Left, Right;
      
      if Container.Config.Layout.BarDirection == "LEFTGROW" then
        
        TexStart, TexEnd = 0, 1 - Part;

      elseif Container.Config.Layout.BarDirection == "RIGHTGROW" then

        TexStart, TexEnd = 1 - Part, 0;

      elseif Container.Config.Layout.BarDirection == "LEFTSHRINK" then

        TexStart, TexEnd = 0, Part;

      else -- RIGHTSHRINK

        TexStart, TexEnd = Part, 0;

      end
      
      if Container.Config.Layout.BarTextureMove then
        TexStart, TexEnd = 1 - TexEnd, 1 - TexStart;
      end
      
    else
      
      if Container.Config.Layout.BarDirection == "LEFTGROW" or Container.Config.Layout.BarDirection == "RIGHTGROW" then
      
        Bar.Bar:SetWidth(1);
      
      else
      
        Bar.Bar:SetWidth(Container.BarWidth);
      
      end
      
    end

    if Container.AnimationAuraExpiring.TotalDuration ~= 0 and TimeLeft < Container.AnimationAuraExpiring.TotalDuration and Container.AnimationAuraExpiring:IsPlaying(Bar) ~= true then

      Container.AnimationAuraExpiring:Play(Bar, function() Bar:Hide(); end);
      
    end

  else
  
    if Container.Config.Layout.BarDirection == "LEFTGROW" or Container.Config.Layout.BarDirection == "RIGHTGROW" then
    
      Bar.Bar:SetWidth(Container.Config.Layout.InverseOnNoTime == false and Container.BarWidth or 1);
    
    else
    
      Bar.Bar:SetWidth(Container.Config.Layout.InverseOnNoTime == false and 1 or Container.BarWidth);
    
    end
  
  end
  
  SetBarCoords(Bar.Bar.Texture, Container.Config.Layout.BarTextureFlipX, Container.Config.Layout.BarTextureFlipY, Container.Config.Layout.BarTextureRotate, TexStart, TexEnd);
  
end


-----------------------------------------------------------------
-- Local Function BarOnMouseUp
-----------------------------------------------------------------
local function BarOnMouseUp(Bar, Button)

  if Button ~= "RightButton" then
    return;
  end

  if IsModifierKeyDown() == true then
  
    AuraFrames:DumpAura(Bar.Aura);

  else
  
    AuraFrames:CancelAura(Bar.Aura);

  end

end


-----------------------------------------------------------------
-- Function Delete
-----------------------------------------------------------------
function Prototype:Delete()

  self.AuraList:Delete();
  
  Module.Containers[self.Config.Id] = nil;

  AuraFrames:StopAnimations(self.Frame);
  AuraFrames:ClearAnimationEffects(self.Frame);

  self.Frame:Hide();
  self.Frame:UnregisterAllEvents();
  self.Frame = nil;
  
  -- Release the container pool into the general pool.
  self:ReleasePool();

  if self.MSQGroup then
    self.MSQGroup:Delete(true);
  end


end

-----------------------------------------------------------------
-- Function ReleasePool
-----------------------------------------------------------------
function Prototype:ReleasePool()

  -- Cleanup container bar pool
  while #self.BarPool > 0 do
  
    local Bar = tremove(self.BarPool);
  
    if MSQ then
      self.MSQGroup:RemoveButton(Bar.Button, true);
    end
    
    Bar:ClearAllPoints();
    Bar:SetParent(nil);
    
    -- Release the bar in the general pool.
    tinsert(BarPool, Bar);
  
  end

end


-----------------------------------------------------------------
-- Function UpdateBarDisplay
-----------------------------------------------------------------
function Prototype:UpdateBarDisplay(Bar)

  local Aura = Bar.Aura;

  if self.Config.Layout.ShowDuration and Aura.ExpirationTime > 0 then
    
    Bar.Duration:Show();
  
  elseif Bar.Duration then

    Bar.Duration:Hide();
  
  end
  
  local Text = {};
  
  if self.Config.Layout.ShowAuraName then
    tinsert(Text, Aura.Name);
  end

  if self.Config.Layout.ShowCount and (Aura.Count > 1 or Aura.ForceCountShow) then
  
    tinsert(Text, "["..(Aura.Count or 0).."]");
  
  end
  
  Bar.Text:SetText(tconcat(Text, " "));
  
  self:AuraEvent(Aura, "ColorChanged");
  
  if self.Config.Layout.Icon ~= "NONE" then
  
    if self.Config.Layout.ShowCooldown == true and Aura.ExpirationTime > 0 then
      
      local CurrentTime = GetTime();

      if Aura.Duration > 0 then
        Bar.Button.Cooldown:SetCooldown(Aura.ExpirationTime - Aura.Duration, Aura.Duration);
      else
        Bar.Button.Cooldown:SetCooldown(CurrentTime, Aura.ExpirationTime - CurrentTime);
      end
      
      Bar.Button.Cooldown:Show();
    
    else
    
      Bar.Button.Cooldown:Hide();
    
    end
    
  end
  
  Bar.BarMaxTime = self.Config.Layout.BarUseAuraTime and Aura.Duration or self.Config.Layout.BarMaxTime;
  
  -- 1 is the min.
  Bar.WidthPerSecond = (self.BarWidth - 1) / Bar.BarMaxTime;
  
  if self.Config.Layout.ShowSpark == true and not (self.Config.Layout.HideSparkOnNoTime == true and Aura.ExpirationTime == 0) then
    Bar.Bar.Spark:Show();
  else
    Bar.Bar.Spark:Hide();
  end

  if self.Config.Layout.ShowBorder == "DEBUFF" then

    if Aura.Type == "HARMFUL" then
      Bar.Button.Border:Show();
    else
      Bar.Button.Border:Hide();
    end

  end

  
  BarOnUpdate(self, Bar, 0.0);

end


-----------------------------------------------------------------
-- Function UpdateBar
-----------------------------------------------------------------
function Prototype:UpdateBar(Bar)

  local Container, Aura = self, Bar.Aura;
  
  Bar:SetWidth(self.Config.Layout.BarWidth);
  Bar:SetHeight(self.Config.Layout.BarHeight);
  
  Bar.Text:ClearAllPoints();
  Bar.Duration:ClearAllPoints();
  
  if self.Config.Layout.Icon == "NONE" then
    
    Bar.Button:Hide();
    
  elseif self.Config.Layout.Icon == "LEFT" then
  
    Bar.Button:ClearAllPoints();
    Bar.Button:SetPoint("TOPLEFT", Bar.Content, "TOPLEFT", 0, 0);
    Bar.Button:Show();
  
  elseif self.Config.Layout.Icon == "RIGHT" then
  
    Bar.Button:ClearAllPoints();
    Bar.Button:SetPoint("TOPRIGHT", Bar.Content, "TOPRIGHT", 0, 0);
    Bar.Button:Show();

  end
  
  local Adjust = self.PositionMappings[self.Config.Layout.Icon][self.Config.Layout.TextPosition];
  Bar.Text:SetPoint(self.Config.Layout.TextPosition, Bar.Content, self.Config.Layout.TextPosition, Adjust[1], Adjust[2]);
  Bar.Text:SetWidth(self.Config.Layout.BarWidth - ((self.Config.Layout.Icon == "NONE" and self.Config.Layout.BarHeight or 0) + (self.Config.Layout.ShowDuration and 60 or 0) + 20));
  Bar.Text:SetJustifyH(self.Config.Layout.TextPosition);
  
  Adjust = self.PositionMappings[self.Config.Layout.Icon][self.Config.Layout.DurationPosition];
  Bar.Duration:SetPoint(self.Config.Layout.DurationPosition, Bar.Content, self.Config.Layout.DurationPosition, Adjust[1], Adjust[2]);
  
  Bar.Bar:ClearAllPoints();
  Bar.Bar:SetHeight(self.Config.Layout.BarHeight);
  Bar.Bar.Background:ClearAllPoints();
  Bar.Bar.Background:SetHeight(self.Config.Layout.BarHeight);
  Bar.Bar.Spark:ClearAllPoints();
  
  if self.Config.Layout.BarDirection == "LEFTGROW" or self.Config.Layout.BarDirection == "LEFTSHRINK" then
  
    Bar.Bar:SetPoint("TOPLEFT", Bar.Content, "TOPLEFT", self.Config.Layout.Icon == "LEFT" and self.Config.Layout.BarHeight or 0, 0);
    Bar.Bar.Background:SetPoint("TOPLEFT", Bar.Content, "TOPLEFT", self.Config.Layout.Icon == "LEFT" and self.Config.Layout.BarHeight or 0, 0);
    Bar.Bar.Background:SetPoint("BOTTOMRIGHT", Bar.Content, "BOTTOMRIGHT", self.Config.Layout.Icon == "RIGHT" and -self.Config.Layout.BarHeight or 0, 0);
    Bar.Bar.Spark:SetPoint("CENTER", Bar.Bar, "RIGHT", 0, -2);
    
  else

    Bar.Bar:SetPoint("TOPRIGHT", Bar.Content, "TOPRIGHT", self.Config.Layout.Icon == "RIGHT" and -self.Config.Layout.BarHeight or 0, 0);
    Bar.Bar.Background:SetPoint("TOPRIGHT", Bar.Content, "TOPRIGHT", self.Config.Layout.Icon == "RIGHT" and -self.Config.Layout.BarHeight or 0, 0);
    Bar.Bar.Background:SetPoint("BOTTOMLEFT", Bar.Content, "BOTTOMLEFT", self.Config.Layout.Icon == "LEFT" and self.Config.Layout.BarHeight or 0, 0);
    Bar.Bar.Spark:SetPoint("CENTER", Bar.Bar, "LEFT", 0, -2);
  
  end
  
  if self.Config.Layout.ShowSpark == true and self.Config.Layout.SparkUseBarColor ~= true then
  
    Bar.Bar.Spark:SetVertexColor(unpack(self.Config.Layout.SparkColor));
  
  end
  
  Bar.Bar.Texture:SetTexture(LSM:Fetch("statusbar", self.Config.Layout.BarTexture));

  AuraFrames:SetBorder(Bar.Bar, LSM:Fetch("border", self.Config.Layout.BarBorder), self.Config.Layout.BarBorderSize);

  Bar.Bar.Texture:SetPoint("TOPLEFT", Bar.Bar, "TOPLEFT", self.Config.Layout.BarTextureInsets, -self.Config.Layout.BarTextureInsets);
  Bar.Bar.Texture:SetPoint("BOTTOMRIGHT", Bar.Bar, "BOTTOMRIGHT", -self.Config.Layout.BarTextureInsets, self.Config.Layout.BarTextureInsets);
  
  if self.Config.Layout.TextureBackgroundUseTexture == true then
    
    Bar.Bar.Background.Texture:SetTexture(LSM:Fetch("statusbar", self.Config.Layout.BarTexture));
    
    Bar.Bar.Background:SetBackdrop({
      edgeFile = LSM:Fetch("border", self.Config.Layout.BarBorder),
      edgeSize = self.Config.Layout.BarBorderSize,
    });
    
    Bar.Bar.Background.Texture:SetPoint("TOPLEFT", Bar.Bar.Background, "TOPLEFT", self.Config.Layout.BarTextureInsets, -self.Config.Layout.BarTextureInsets);
    Bar.Bar.Background.Texture:SetPoint("BOTTOMRIGHT", Bar.Bar.Background, "BOTTOMRIGHT", -self.Config.Layout.BarTextureInsets, self.Config.Layout.BarTextureInsets);
    
    SetBarCoords(Bar.Bar.Background.Texture, self.Config.Layout.BarTextureFlipX, self.Config.Layout.BarTextureFlipY, self.Config.Layout.BarTextureRotate, 0, 1);
    
  else
  
    Bar.Bar.Background.Texture:SetColorTexture(1.0, 1.0, 1.0, 1.0);

  end
  
  if self.RecieveMouseEvents and self.Config.Layout.ShowTooltip then
  
    Bar:SetScript("OnEnter", function() AuraFrames:SetCancelAuraFrame(Bar, Bar.Aura); AuraFrames:ShowTooltip(Bar.Aura, Bar, self.TooltipOptions); self:CheckVisibility(true); end);
    Bar:SetScript("OnLeave", function() AuraFrames:HideTooltip(); self:CheckVisibility(false); end);
  
    Bar.Button:SetScript("OnEnter", function() AuraFrames:SetCancelAuraFrame(Bar, Bar.Aura); AuraFrames:ShowTooltip(Bar.Aura, Bar, self.TooltipOptions); self:CheckVisibility(true); end);
    Bar.Button:SetScript("OnLeave", function() AuraFrames:HideTooltip(); self:CheckVisibility(false); end);

  else
  
    Bar:SetScript("OnEnter", function() AuraFrames:SetCancelAuraFrame(Bar, Bar.Aura); self:CheckVisibility(true); end);
    Bar:SetScript("OnLeave", function() self:CheckVisibility(false); end);

    Bar.Button:SetScript("OnEnter", function() AuraFrames:SetCancelAuraFrame(Bar, Bar.Aura); self:CheckVisibility(true); end);
    Bar.Button:SetScript("OnLeave", function() self:CheckVisibility(false); end);
  
  end
  
  Bar.Bar.Background:SetWidth(self.Config.Layout.BarWidth);
  
  if self.RecieveMouseEvents then
    
    Bar:EnableMouse(true);
    Bar:SetScript("OnMouseUp", BarOnMouseUp);
    Bar.Button:EnableMouse(true);
    Bar.Button:RegisterForClicks("RightButtonUp");

  else
    
    Bar:EnableMouse(false);
    Bar:SetScript("OnMouseUp", nil);
    Bar.Button:EnableMouse(false);
    Bar.Button:SetScript("OnClick", nil);
    
  end
  
  -- Set cooldown options
  if Bar.Button.Cooldown.SetDrawEdge then
    Bar.Button.Cooldown:SetDrawEdge(self.Config.Layout.CooldownDrawEdge);
  end

  Bar.Button.Cooldown:SetReverse(self.Config.Layout.CooldownReverse);
  Bar.Button.Cooldown.noCooldownCount = self.Config.Layout.CooldownDisableOmniCC;

  if self.Config.Layout.ShowBorder == "ALWAYS" then

    Bar.Button.Border:Show();

  elseif self.Config.Layout.ShowBorder == "NEVER" then

    Bar.Button.Border:Hide();

  end
  
  self:UpdateBarDisplay(Bar);

  AuraFrames:UpdateAnimationRegionSize(Bar);

end


-----------------------------------------------------------------
-- Function Update
-----------------------------------------------------------------
function Prototype:Update(...)

  self.PositionMappings = {
    NONE = {
      LEFT = {5, 0},
      RIGHT = {-5, 0},
      CENTER = {0, 0},
    },
    LEFT = {
      LEFT = {5 + self.Config.Layout.BarHeight, 0},
      RIGHT = {-5, 0},
      CENTER = {self.Config.Layout.BarHeight / 2, 0},
    },
    RIGHT = {
      LEFT = {5, 0},
      RIGHT = {-5 - self.Config.Layout.BarHeight, 0},
      CENTER = {-(self.Config.Layout.BarHeight / 2), 0},
    },
  };

  local Changed = select(1, ...) or "ALL";
  
  if Changed == "ALL" or Changed == "LAYOUT" then

    self.Frame:SetWidth(self.Config.Layout.BarWidth);
    self.Frame:SetHeight((self.Config.Layout.NumberOfBars * self.Config.Layout.BarHeight) + ((self.Config.Layout.NumberOfBars - 1) * self.Config.Layout.Space));
    
    self.Frame:SetScale(self.Config.Layout.Scale);
    
    if self.Unlocked ~= true then
    
      self.Frame:ClearAllPoints();
      self.Frame:SetPoint(self.Config.Location.FramePoint, self.Config.Location.RelativeTo, self.Config.Location.RelativePoint, self.Config.Location.OffsetX, self.Config.Location.OffsetY);
      
    end
    
    self.TooltipOptions = {
      ShowPrefix = self.Config.Layout.TooltipShowPrefix,
      ShowUnit = self.Config.Layout.TooltipShowUnitName,
      ShowCaster = self.Config.Layout.TooltipShowCaster,
      ShowAuraId = self.Config.Layout.TooltipShowAuraId,
      ShowClassification = self.Config.Layout.TooltipShowClassification,
    }
    
    if self.Config.Layout.Icon == "NONE" then
    
      self.BarWidth = self.Config.Layout.BarWidth;
      
    else
    
      self.BarWidth = self.Config.Layout.BarWidth - self.Config.Layout.BarHeight;
    
    end
    
    if self.Config.Layout.BarDirection == "LEFTSHRINK" or self.Config.Layout.BarDirection == "RIGHTSHRINK" then
      self.Shrink = true;
    else
      self.Shrink = false;
    end
    
    AuraFrames:SetFontObjectProperties(
      self.FontObject,
      self.Config.Layout.TextFont,
      self.Config.Layout.TextSize,
      self.Config.Layout.TextOutline,
      self.Config.Layout.TextMonochrome,
      self.Config.Layout.TextColor
    );
    
    self.Direction = DirectionMapping[self.Config.Layout.Direction];
    
    for _, Bar in pairs(self.Bars) do
    
      Bar.Button:SetWidth(self.Config.Layout.BarHeight);
      Bar.Button:SetHeight(self.Config.Layout.BarHeight);
      
      Bar.Bar.Spark:SetWidth(self.Config.Layout.BarHeight);
      Bar.Bar.Spark:SetHeight(self.Config.Layout.BarHeight * 2.5);
      
    end
    
    if MSQ then
      self.MSQGroup:ReSkin();
    end
    
    for _, Bar in pairs(self.Bars) do
      self:UpdateBar(Bar);
    end
    
    -- Anchor all bars.
    self.AuraList:AnchorAllAuras();

    -- We have bars in the container pool that doesn't match the settings anymore. Release them into the general pool.
    self:ReleasePool();

    if Changed == "LAYOUT" then

      self:UpdateAnimationConfig("BarContainerMove");

    end

  end

  if Changed == "ALL" or Changed == "ANIMATIONS" then
    
    self:UpdateAnimationConfig();
    
  end

end


-----------------------------------------------------------------
-- Function AuraEvent
-----------------------------------------------------------------
function Prototype:AuraEvent(Aura, Event, ...)

  local Bar = self.Bars[Aura];

  if Event == "ColorChanged" then
  
    Bar.Button.Border:SetVertexColor(unpack(Aura.Color));
    Bar.Bar.Texture:SetVertexColor(unpack(Aura.Color));
    AuraFrames:SetBorderColor(Bar.Bar, min(Aura.Color[1] * self.Config.Layout.BarBorderColorAdjust, 1), min(Aura.Color[2] * self.Config.Layout.BarBorderColorAdjust, 1), min(Aura.Color[3] * self.Config.Layout.BarBorderColorAdjust, 1), Aura.Color[4]);
    
    if self.Config.Layout.ShowSpark and self.Config.Layout.SparkUseBarColor then
    
      Bar.Bar.Spark:SetVertexColor(unpack(Aura.Color));
    
    end
    
    if self.Config.Layout.TextureBackgroundUseBarColor then
    
      Bar.Bar.Background.Texture:SetVertexColor(Aura.Color[1], Aura.Color[2], Aura.Color[3], self.Config.Layout.TextureBackgroundOpacity);
      Bar.Bar.Background:SetBackdropBorderColor(min(Aura.Color[1] * self.Config.Layout.BarBorderColorAdjust, 1), min(Aura.Color[2] * self.Config.Layout.BarBorderColorAdjust, 1), min(Aura.Color[3] * self.Config.Layout.BarBorderColorAdjust, 1), self.Config.Layout.TextureBackgroundOpacity);
    
    else
    
      Bar.Bar.Background.Texture:SetVertexColor(unpack(self.Config.Layout.TextureBackgroundColor));
      Bar.Bar.Background:SetBackdropBorderColor(min(self.Config.Layout.TextureBackgroundColor[1] * self.Config.Layout.BarBorderColorAdjust, 1), min(self.Config.Layout.TextureBackgroundColor[2] * self.Config.Layout.BarBorderColorAdjust, 1), min(self.Config.Layout.TextureBackgroundColor[3] * self.Config.Layout.BarBorderColorAdjust, 1), self.Config.Layout.TextureBackgroundColor[4]);
    
    end
  
  end

end


-----------------------------------------------------------------
-- Function AuraNew
-----------------------------------------------------------------
function Prototype:AuraNew(Aura)
  
  -- Pop the last bar out the container pool.
  local Bar = tremove(self.BarPool);
  local FromContainerPool = Bar and true or false;
  
  if not Bar then
  
    -- Try the general pool.
    Bar = tremove(BarPool);
    
    if not Bar then
      -- No bars in any pool. Let's make a new bar.
  
      BarCounter = BarCounter + 1;
    
      local BarId = "AuraFramesBar"..BarCounter;
      Bar = CreateFrame("Frame", BarId, self.Content, "AuraFramesBarTemplate");
      
      Bar.Content = _G[BarId.."Content"];
      Bar.Text = _G[BarId.."ContentText"];
      Bar.Duration = _G[BarId.."ContentDuration"];
      
      Bar.Bar = _G[BarId.."ContentBar"];
      Bar.Bar.Texture = _G[BarId.."ContentBarTexture"];
      Bar.Bar.Spark = _G[BarId.."ContentBarSpark"];
      Bar.Bar.Background = _G[BarId.."ContentBarBackground"];
      Bar.Bar.Background.Texture = _G[BarId.."ContentBarBackgroundTexture"];
      
      Bar.Button = _G[BarId.."ContentButton"];
      Bar.Button.Icon = _G[BarId.."ContentButtonIcon"];
      Bar.Button.Border = _G[BarId.."ContentButtonBorder"];
      Bar.Button.Cooldown = _G[BarId.."ContentButtonCooldown"];
		Bar:Show(); -- 2018-07-24 CB
      -- TODO: set Bar._AlphaRegion??

    else
    
      Bar:SetParent(self.Content);
    
    end
  
    -- We got a general pool bar or a new bar.
    -- Prepare it so it match a container pool bar.

    local Container = self;  
    Bar:SetScript("OnUpdate", function(Bar, Elapsed)
      
       Bar.TimeSinceLastUpdate = Bar.TimeSinceLastUpdate + Elapsed;
       if Bar.TimeSinceLastUpdate > BarUpdatePeriod then
          BarOnUpdate(Container, Bar, Bar.TimeSinceLastUpdate);
          Bar.TimeSinceLastUpdate = 0.0;
       end
      
    end);
    
    Bar.Button:SetWidth(self.Config.Layout.BarHeight);
    Bar.Button:SetHeight(self.Config.Layout.BarHeight);
    
    Bar.Bar.Spark:SetWidth(self.Config.Layout.BarHeight);
    Bar.Bar.Spark:SetHeight(self.Config.Layout.BarHeight * 2.5);
  
    -- We need to update the animation region, otherwise Masque will generate wrong buttons.
    AuraFrames:UpdateAnimationRegionSize(Bar);

    -- Set the font from this container.
    Bar.Text:SetFontObject(self.FontObject);
    Bar.Duration:SetFontObject(self.FontObject);
    
    if MSQ then
    
      -- We Don't have count text.
      self.MSQGroup:AddButton(Bar.Button, {Icon = Bar.Button.Icon, Border = Bar.Button.Border, Count = false, Duration = false, Cooldown = Bar.Button.Cooldown});
    
      if not AuraFrames.db.profile.DisableMasqueSkinWarnings then

        -- Warn the player for bad skins.
        local BlendMode = Bar.Button.Border:GetBlendMode();
        if BlendMode ~= "ADD" and BlendMode ~= "BLEND" then

          if not Container.ComplainedAboutBlendMode then
            AuraFrames:Print("The Masque skin used for container \""..Container.Config.Name.."\" is using a wrong type of blendmode (\""..BlendMode.."\") for the border. Please contact the skin author and request him to use \"ADD\" or \"BLEND\" as blendmode for the border. Because of this, buttons can show up black.");
            Container.ComplainedAboutBlendMode = true;
          end

        end

      end

    else
    
      Bar.Button.Border:SetAllPoints(Bar.Button);
      Bar.Button.Cooldown:SetAllPoints(Bar.Button);
    
    end
    
    Bar.Button.Cooldown.currentCooldownType = COOLDOWN_TYPE_NORMAL;
    Bar.Button.Cooldown:SetSwipeColor(0, 0, 0, 0.5);
    Bar.Button.Cooldown:SetHideCountdownNumbers(false);
    Bar.Button.Cooldown:SetEdgeTexture("Interface\\Cooldown\\edge");
  
  end
  
  Bar.TimeSinceLastUpdate = 0.0;
  Bar.TimeLeftSeconds = 0;
  
  if Aura.Icon ~= nil then
    Bar.Button.Cooldown:SetSwipeTexture(Aura.Icon);
  end
  Bar.Button.Icon:SetTexture(Aura.Icon);
    
  Bar.Aura = Aura;
  
  self.Bars[Aura] = Bar;
  
  if self.Config.Layout.ShowCooldown == true and Aura.ExpirationTime > 0 then
    
    local CurrentTime = GetTime();
    
    if Aura.Duration then
      Bar.Button.Cooldown:SetCooldown(Aura.ExpirationTime - Aura.Duration, Aura.ExpirationTime - CurrentTime);
    else
      Bar.Button.Cooldown:SetCooldown(CurrentTime, Aura.ExpirationTime - CurrentTime);
    end
    
    Bar.Button.Cooldown:Show();
  
  else
  
    Bar.Button.Cooldown:Hide();
  
  end
  
  if FromContainerPool == true then
  
    -- We need only a display update.
    self:UpdateBarDisplay(Bar);
  
  else
  
    -- We need a full update.
    self:UpdateBar(Bar);
  
  end

  Bar:SetFrameStrata("MEDIUM");
  Bar:SetFrameLevel(FrameLevelNormal);
  Bar.Content:SetFrameLevel(FrameLevelNormal);

  if not Aura.IsRefired then
    self.AnimationAuraNew:Play(Bar);
  end

  if self.AnimationGoingVisible:IsPlaying(self.Frame) then
    self.AnimationGoingVisibleChild:Play(Bar, nil, self.AnimationGoingVisible:GetProgression(self.Frame));
  end

end


-----------------------------------------------------------------
-- Function AuraOld
-----------------------------------------------------------------
function Prototype:AuraOld(Aura)

  if not self.Bars[Aura] then
    return
  end
  
  local Bar = self.Bars[Aura];
  
  -- Remove the bar from the container list.
  self.Bars[Aura] = nil;
  
  Bar:Hide();
  
  -- Sometimes the cooldown frame will be stuck showing.
  Bar.Button.Cooldown:Hide();
  
  if AuraFrames:IsTooltipOwner(Bar) == true then
    AuraFrames:HideTooltip();
  end

  -- Reset animation settings.
  AuraFrames:StopAnimations(Bar);
  AuraFrames:ClearAnimationEffects(Bar);

  -- Reset order pos.
  Bar.OrderPos = nil;
  
  -- See in what pool we need to drop.
  if #self.BarPool >= ContainerBarPoolSize then
  
    -- General pool.
  
    if MSQ then
      self.MSQGroup:RemoveButton(Bar.Button, true);
    end
  
    Bar:ClearAllPoints();
    Bar:SetParent(nil);
    
    Bar:SetScript("OnUpdate", nil);

    -- Release the bar back in the general pool for later use.
    tinsert(BarPool, Bar);
  
  else
  
    -- Release the bar back in the container pool for later use.
    tinsert(self.BarPool, Bar);
    
  end

end


-----------------------------------------------------------------
-- Function AuraChanged
-----------------------------------------------------------------
function Prototype:AuraChanged(Aura)

  if not self.Bars[Aura] then
    return
  end
  
  local Bar = self.Bars[Aura];
  
  local Text = {};
  
  if self.Config.Layout.ShowAuraName then
    tinsert(Text, Aura.Name);
  end

  if self.Config.Layout.ShowCount and (Aura.Count > 1 or Aura.ForceCountShow) then
  
    tinsert(Text, "["..(Aura.Count or 0).."]");
  
  end
  
  Bar.Text:SetText(tconcat(Text, " "));
  
  if not self.AnimationAuraChanging:IsPlaying(Bar) then
    self.AnimationAuraChanging:Play(Bar);
  end
  
  BarOnUpdate(self, Bar, 0.0);

end


-----------------------------------------------------------------
-- Function AuraAnchor
-----------------------------------------------------------------
function Prototype:AuraAnchor(Aura, Index)

  local Bar = self.Bars[Aura];

  if not Bar then
    return;
  end

  Bar.FromX = Bar.ToX;
  Bar.FromY = Bar.ToY;

  local OldPos = Bar.OrderPos;

  -- Save the order position.
  Bar.OrderPos = Index;

  -- Hide bar if the index is greater then the maximum number of bars to anchor
  if Index > self.Config.Layout.NumberOfBars then
  
    Bar:Hide();
    return;
    
  end
  
  local x = (Bar:GetWidth() / 2);
  local y = ((self.Direction[2] * ((Index - 1) * (self.Config.Layout.BarHeight + self.Config.Layout.Space))) + ((self.Config.Layout.BarHeight / 2) * self.Direction[2]));
  
  Bar:SetPoint(
    "CENTER",
    self.Content,
    self.Direction[1],
    x,
    y
  );

  Bar.ToX = x;
  Bar.ToY = y;

  Bar:Show();

  if OldPos and OldPos ~= Index and Bar.FromX and Bar.FromY then

    local CurrentEffects = self.AnimationMoveBar:GetCurrentEffects(Button);

    Bar.MoveX = Bar.FromX + (CurrentEffects and CurrentEffects.XOffset or 0) - Bar.ToX;
    Bar.MoveY = Bar.FromY + (CurrentEffects and CurrentEffects.YOffset or 0) - Bar.ToY;

    -- If not moving then stop the animation (no need to check if it is playing).
    if Bar.MoveX == 0 and Bar.MoveY == 0 then

      self.AnimationMoveBar:Stop(Bar);

    else

      self.AnimationMoveBar:Play(Bar);

    end

  end

end


-----------------------------------------------------------------
-- Function CheckVisibility
-----------------------------------------------------------------
function Prototype:CheckVisibility(IsMouseOver)

  if self.Config.Visibility.VisibleWhen.OnMouseOver or self.Config.Visibility.VisibleWhenNot.OnMouseOver then
    AuraFrames:CheckVisibility(self, IsMouseOver);
  end

end


-----------------------------------------------------------------
-- Function UpdateVisibility
-----------------------------------------------------------------
function Prototype:UpdateVisibility()

  if self.Unlocked ~= true and self.ContainerVisibility == false then
    self:GoInvisible();
  else
    self:GoVisible();
  end

end

-----------------------------------------------------------------
-- Function GoVisible
-----------------------------------------------------------------
function Prototype:GoVisible()

  if self.IsVisible == true then
  
    self.AnimationGoingInvisible:Stop(self.Frame);
  
    if not self.AnimationGoingVisible:IsPlaying(self.Frame) then
      self.AnimationGoingVisible:Apply(self.Frame);
    end
  
    return;
    
  end

  local Start = nil;

  if self.AnimationGoingInvisible:IsPlaying(self.Frame) then
    Start = self.AnimationGoingVisible.TotalDuration - self.AnimationGoingInvisible:GetProgression(self.Frame);
    self.AnimationGoingInvisible:Stop(self.Frame);
  end

  self.AnimationGoingInvisible:ClearEffect(self.Frame);
  self.AnimationGoingVisible:Play(self.Frame, nil, Start);

  self.IsVisible = true;

end


-----------------------------------------------------------------
-- Function GoInvisible
-----------------------------------------------------------------
function Prototype:GoInvisible()

  if self.IsVisible == false then
  
    self.AnimationGoingVisible:Stop(self.Frame);
  
    if not self.AnimationGoingInvisible:IsPlaying(self.Frame) then
      self.AnimationGoingInvisible:Apply(self.Frame);
    end
    
    return;
    
  end

  local Start = nil;

  if self.AnimationGoingVisible:IsPlaying(self.Frame) then
    Start = self.AnimationGoingInvisible.TotalDuration - self.AnimationGoingVisible:GetProgression(self.Frame);
    self.AnimationGoingVisible:Stop(self.Frame);
  end
  
  self.AnimationGoingVisible:ClearEffect(self.Frame);
  self.AnimationGoingInvisible:Play(self.Frame, nil, Start);

  self.IsVisible = false;

end


-----------------------------------------------------------------
-- Function UpdateAnimationConfig
-----------------------------------------------------------------
function Prototype:UpdateAnimationConfig(AnimationType)

  local AnimationConfig = self.Config.Animations;

  AnimationType = AnimationType or "ALL";

  if AnimationType == "ALL" or AnimationType == "ContainerVisibility" then

    -- Remove any animation effect on the container.
    AuraFrames:StopAnimations(self.Frame);
    AuraFrames:ClearAnimationEffects(self.Frame);
    self.Frame:SetFrameStrata("MEDIUM");

  end

  if AnimationType == "ALL" or AnimationType == "AuraNew" or AnimationType == "AuraChanging" or AnimationType == "AuraExpiring" then

    for _, Bar in pairs(self.Bars) do

      -- Remove any animation effect on the bars.
      AuraFrames:StopAnimations(Bar);
      AuraFrames:ClearAnimationEffects(Bar);
      Bar:SetFrameStrata("MEDIUM");
      Bar:SetFrameLevel(FrameLevelNormal);

    end

  end

  -- Update animation effects.
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "AuraNew", self, self.AnimationAuraNew);
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "AuraChanging", self, self.AnimationAuraChanging);
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "AuraExpiring", self, self.AnimationAuraExpiring);
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "ContainerVisibility", self, self.AnimationGoingVisible, self.AnimationGoingVisibleChild, self.AnimationGoingInvisible);
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "BarContainerMove", self, self.AnimationMoveBar);

  -- Reset own status if needed.
  if self.IsVisible == false and (AnimationType == "ALL" or AnimationType == "ContainerVisibility") then
    self.IsVisible = true;
    self:UpdateVisibility();
  end

end
