local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local Module = AuraFrames:GetModule("TimeLineContainer");
local MSQ = LibStub("Masque", true);
local LSM = LibStub("LibSharedMedia-3.0");

-- Import most used functions into the local namespace.
local tinsert, tremove, tconcat, sort = tinsert, tremove, table.concat, sort;
local fmt, tostring = string.format, tostring;
local select, pairs, ipairs, next, wipe, type, unpack = select, pairs, ipairs, next, wipe, type, unpack;
local loadstring, assert, error = loadstring, assert, error;
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget;
local GetTime, CreateFrame, IsModifierKeyDown = GetTime, CreateFrame, IsModifierKeyDown;
local math_sin, math_cos, math_floor, math_ceil, math_pow = math.sin, math.cos, math.floor, math.ceil, math.pow;
local min, max = min, max;
local _G, PI = _G, PI;

local Prototype = Module.Prototype;

-- Pool that contains all the current unused buttons sorted by type.
local ButtonPool = {};

-- All containers have also there own (smaller) pool.
local ContainerButtonPoolSize = 5;

-- Counters for each button type.
local ButtonCounter = 0;

-- Direction = Style = {Direction = {AnchorPoint, X Direction, Y Direction, Button Offset X, Button Offset Y}}
local DirectionMapping = {
  HORIZONTAL = {
    HIGH  = {"RIGHT" , -1,  0, 0, 1},
    LOW   = {"LEFT"  ,  1,  0, 0, 1},
  },
  VERTICAL = {
    HIGH  = {"TOP"   ,  0, -1, 1, 0},
    LOW   = {"BOTTOM",  0,  1, 1, 0},
  },
};


-- Frame levels used for poping up buttons.
local FrameLevelLow = 3;
local FrameLevelNormal = 6;
local FrameLevelHigh = 9;


-----------------------------------------------------------------
-- Local Function ButtonOnUpdate
-----------------------------------------------------------------
local function ButtonOnUpdate(Container, Button, Elapsed)

  local Config = Container.Config;
  local Scale;

  if Button.Aura.ExpirationTime ~= 0 then

    local TimeLeft = max(Button.Aura.ExpirationTime - GetTime(), 0);
    
    if Config.Layout.ShowDuration == true then
    
      -- We don't have to update the duration every frame. We round up
      -- the seconds and compare if it's different from the last update.
    
      local TimeLeftSeconds = math_ceil((TimeLeft + 0.5) * 10);
      
      if Button.TimeLeftSeconds ~= TimeLeftSeconds then
    
        Button.Duration:SetFormattedText(AuraFrames:FormatTimeLeft(Config.Layout.DurationLayout, TimeLeft, false));
        Button.TimeLeftSeconds = TimeLeftSeconds;
      
      end
    
    end

    if Container.AnimationAuraExpiring.TotalDuration ~= 0 and TimeLeft < Container.AnimationAuraExpiring.TotalDuration and Container.AnimationAuraExpiring:IsPlaying(Button) ~= true then

      Container.AnimationAuraExpiring:Play(Button, function() Button:Hide(); end);
      
    end

    Scale = Button:GetScale();
    
    if Config.Layout.MaxTime < TimeLeft then
      Button.Offset = Container.ButtonIndent / Scale;
    else
      Button.Offset = (((Container.StepPerSecond * (Config.Layout.MaxTime - TimeLeft)) * Container:CalcPos(TimeLeft)) + Container.ButtonIndent) / Scale;
    end

    Button:Show();
    
  else
  
    -- Hide aura's without an ExpirationTime.
    Button:Hide();
    Button.Offset = Container.ButtonIndent;
    return;
  
  end

  -- Set the position.
  Button:SetPoint(
    "CENTER",
    Container.Content,
    Container.Direction[1],
    (Container.Direction[2] * Button.Offset) + (Config.Layout.ButtonOffset * Container.Direction[4] / Scale),
    (Container.Direction[3] * Button.Offset) + (Config.Layout.ButtonOffset * Container.Direction[5] / Scale)
  );

end


-----------------------------------------------------------------
-- Local Function ButtonOnClick
-----------------------------------------------------------------
local function ButtonOnClick(Button)

  -- When a key modifier is pressed, dump the aura to the
  -- chat window, otherwise just try to cancel the aura.

  if IsModifierKeyDown() == true then
  
    AuraFrames:DumpAura(Button.Aura);

  else
  
    AuraFrames:CancelAura(Button.Aura);

  end

end


local Clusters = {Size = 0};

-----------------------------------------------------------------
-- Function ClusterDetection
-----------------------------------------------------------------
function Prototype:ClusterDetection()

  -- Clusters[Index] = {Start = x, End = y, Buttons = {Button1, Button2}}
  -- Clusters.Size = num of clusters
  -- Clusters[Index].Buttons.Size = num of buttons

  -- Button.ClusterVisible:
  --  nil = Not joined a cluster yet
  --  false = Not visible in the cluster
  --  true = Visible in the cluster

  if self.AnimationClusterGoVisible.IsEmpty == true then
    return;
  end

  Clusters.Size = 0;

  for _, Button in pairs(self.Buttons) do
  
    -- Only detect collisions for buttons that are shown.
    if Button:IsShown() then

      local LastCluster;
      
      for Index = 1, Clusters.Size do

        local Cluster = Clusters[Index];
        Cluster.Used = true;
      
        if Cluster.Start <= Button.Offset and Cluster.End >= Button.Offset then
          -- We got a collision.
        
          if LastCluster then
            -- We had already a collision with an other cluster, so this button is having a collision with the LastCluster and
            -- this cluster. We need to merge the clusters and add the current button to the merged cluster.
          
            for ButtonIndex = 1, Clusters[LastCluster].Buttons.Size do

              Cluster.Buttons.Size = Cluster.Buttons.Size + 1;
              Cluster.Buttons[Cluster.Buttons.Size] = Clusters[LastCluster].Buttons[ButtonIndex];

            end
            
            Cluster.Start = min(Cluster.Start, Clusters[LastCluster].Start);
            Cluster.End = max(Cluster.End, Clusters[LastCluster].End);
            
            Clusters[LastCluster].Used = false;
            
          else

            Cluster.Start = min(Cluster.Start, Button.Offset - self.CollisionMargin);
            Cluster.End = max(Cluster.End, Button.Offset + self.CollisionMargin);

          end

          Cluster.Buttons.Size = Cluster.Buttons.Size + 1;
          Cluster.Buttons[Cluster.Buttons.Size] = Button;
          
          LastCluster = Index;
        
        end
      
      end
      
      if not LastCluster then
        
        Clusters.Size = Clusters.Size + 1;

        if not Clusters[Clusters.Size] then

          Clusters[Clusters.Size] = {Buttons = {}};

          -- Make the table having weak keys, so that we dont have to clean up references to Button objects.
          setmetatable(Clusters[Clusters.Size].Buttons, {__mode = "k"});

        end

        Clusters[Clusters.Size].Start = Button.Offset - self.CollisionMargin;
        Clusters[Clusters.Size].End = Button.Offset + self.CollisionMargin;
        Clusters[Clusters.Size].Buttons.Size = 1;
        Clusters[Clusters.Size].Buttons[1] = Button;

      end
    
    end
  
  end
  
  local CurrentTime = GetTime();

  for Index = 1, Clusters.Size do

    local Cluster = Clusters[Index];
  
    if Cluster.Used == true and Cluster.Buttons.Size > 1 then

      local ActiveIndex = 1;
    
      for ButtonIndex = 1, Cluster.Buttons.Size do

        local Button = Cluster.Buttons[ButtonIndex];
      
        if Button.ClusterVisible == nil then
        
          Button.ClusterVisible = false;
          self.AnimationClusterGoVisible:ClearEffect(Button);
          self.AnimationClusterGoInvisible:Play(Button);
        
        elseif Button.ClusterVisible == true then
        
          if self.AnimationClusterGoVisible:IsPlaying(Button) then
        
            ActiveIndex = nil;
        
          else
          
            Button.ClusterVisible = false;
            self.AnimationClusterGoVisible:ClearEffect(Button);
            self.AnimationClusterGoInvisible:Play(Button);
            
            ActiveIndex = ButtonIndex + 1 > Cluster.Buttons.Size and 1 or ButtonIndex + 1;
            
          end
          
        end

      end
      
      if ActiveIndex then
        
        Cluster.Buttons[ActiveIndex].ClusterVisible = true;
        
        self.AnimationClusterGoInvisible:Stop(Cluster.Buttons[ActiveIndex]);
        self.AnimationClusterGoInvisible:ClearEffect(Cluster.Buttons[ActiveIndex]);
        self.AnimationClusterGoVisible:Play(Cluster.Buttons[ActiveIndex]);
      
      end
    
    elseif Cluster.Used == true then
    
      self.AnimationClusterGoInvisible:Stop(Cluster.Buttons[1]);
      self.AnimationClusterGoInvisible:ClearEffect(Cluster.Buttons[1]);

      if Cluster.Buttons[1].ClusterVisible == false and self.AnimationClusterGoVisible:IsPlaying(Cluster.Buttons[1]) ~= true then
        
        self.AnimationClusterGoVisible:Play(Cluster.Buttons[1]);

      end

      Cluster.Buttons[1].ClusterVisible = nil;

    end
  
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

  -- Cleanup container button pool
  while #self.ButtonPool > 0 do
  
    local Button = tremove(self.ButtonPool);
    
    if MSQ then
      self.MSQGroup:RemoveButton(Button.Content, true);
    end
  
    Button:ClearAllPoints();
    Button:SetParent(nil);
    
    -- Release the button in the general pool.
    tinsert(ButtonPool, Button);
  
  end
  
end

-----------------------------------------------------------------
-- Function CalcPos
-----------------------------------------------------------------
function Prototype:CalcPos(TimeLeft)

  -- We make here the calculations for nice time lines.
  -- This function will always return between 0 and 1.
  -- So that the caller can do CalcPos() * width.

  if self.Config.Layout.TimeFlow == "POW" then

    -- For more information about this formula (with a time line of 30 secs to 0 with a default compression of 0.3):
    -- http://www.wolframalpha.com/input/?i=%2830+-+x%29+%5E+0.3+%2F+30+%5E+0.3+from+x+%3D+0+to+30

    local Pos = math_pow(self.Config.Layout.MaxTime - TimeLeft, self.Config.Layout.TimeCompression) / self.PowTimeCompressionDivider ;

    return Pos > 1 and 1 or Pos;
  
  end

  -- No compression
  return 1;

end


-----------------------------------------------------------------
-- Function UpdateButtonDisplay
-----------------------------------------------------------------
function Prototype:UpdateButtonDisplay(Button)

  -- Only update settings that can be changed between
  -- different aura's. We can assume we are still having
  -- the same container. If not then the function
  -- UpdateButton will have taken care of that for us.

  local Aura = Button.Aura;

  if Button.Duration ~= nil and self.Config.Layout.ShowDuration == true and Aura.ExpirationTime > 0 then
    
    Button.Duration:Show();
  
  elseif Button.Duration then
  
    Button.Duration:Hide();
  
  end

  if Button.Count ~= nil and self.Config.Layout.ShowCount and (Aura.Count > 1 or Aura.ForceCountShow) then
  
    Button.Count:SetText(Aura.Count or 0);
    Button.Count:Show();
    
  elseif Button.Count then
    
    Button.Count:Hide();
    
  end
  
  self:AuraEvent(Aura, "ColorChanged");

  if self.Config.Layout.ShowBorder == "DEBUFF" then

    if Aura.Type == "HARMFUL" then
      Button.Border:Show();
    else
      Button.Border:Hide();
    end

  end
  
  ButtonOnUpdate(self, Button, 0.0);

end


-----------------------------------------------------------------
-- Function UpdateButton
-----------------------------------------------------------------
function Prototype:UpdateButton(Button)

  -- Update settings that can be changed between 
  -- different containers. After that call function
  -- UpdateButtonDisplay to update the things that
  -- can be changed between aura's.

  local Container, Aura = self, Button.Aura;

  if Button.Duration ~= nil and self.Config.Layout.ShowDuration == true then
    
    Button.Duration:ClearAllPoints();
    Button.Duration:SetPoint("CENTER", Button.Content, "CENTER", self.Config.Layout.DurationPosX, self.Config.Layout.DurationPosY);
  
  end

  if self.Config.Layout.ShowCount then
  
    Button.Count:ClearAllPoints();
    Button.Count:SetPoint("CENTER", Button.Content, "CENTER", self.Config.Layout.CountPosX, self.Config.Layout.CountPosY);
    
  end
  
  if self.RecieveMouseEvents and self.Config.Layout.ShowTooltip then
  
    Button:SetScript("OnEnter", function() AuraFrames:SetCancelAuraFrame(Button, Button.Aura); AuraFrames:ShowTooltip(Button.Aura, Button, Container.TooltipOptions); self:CheckVisibility(true); end);
    Button:SetScript("OnLeave", function() AuraFrames:HideTooltip(); self:CheckVisibility(false); end);
  
  else
  
    Button:SetScript("OnEnter", function() AuraFrames:SetCancelAuraFrame(Button, Button.Aura); self:CheckVisibility(true); end);
    Button:SetScript("OnLeave", function() self:CheckVisibility(false); end);
  
  end
  
  if self.RecieveMouseEvents then
    
    Button:EnableMouse(true);
    Button.Content:EnableMouse(true);
    Button:RegisterForClicks("RightButtonUp");
    Button:SetScript("OnClick", ButtonOnClick);
    
  else
    
    Button:EnableMouse(false);
    Button.Content:EnableMouse(false);
    Button:SetScript("OnClick", nil);
    
  end
  
  if self.Config.Layout.ShowBorder == "ALWAYS" then

    Button.Border:Show();

  elseif self.Config.Layout.ShowBorder == "NEVER" then

    Button.Border:Hide();

  end
  
  self:UpdateButtonDisplay(Button);

  AuraFrames:UpdateAnimationRegionSize(Button);

end


-----------------------------------------------------------------
-- Function Update
-----------------------------------------------------------------
function Prototype:Update(...)

  -- Update the whole container. This function is called
  -- on login and when settings are changed for the
  -- container. To optimize it a little bit, the caller
  -- can indicate what changed. The following is supported:
  -- ALL, LAYOUT or WARNINGS.

  local Changed = select(1, ...) or "ALL";
  
  if Changed == "ALL" or Changed == "LAYOUT" then

    self.Frame:SetScale(self.Config.Layout.Scale);
    
    if self.Unlocked ~= true then
    
      if self.Config.Layout.Style == "HORIZONTAL" then
      
        self.Frame:SetWidth(self.Config.Layout.Length);
        self.Frame:SetHeight(self.Config.Layout.Width);

      else
      
        self.Frame:SetWidth(self.Config.Layout.Width);
        self.Frame:SetHeight(self.Config.Layout.Length);

      end
    
      self.Frame:ClearAllPoints();
      self.Frame:SetPoint(self.Config.Location.FramePoint, self.Config.Location.RelativeTo, self.Config.Location.RelativePoint, self.Config.Location.OffsetX, self.Config.Location.OffsetY);
    
    end
    
    self.FrameTexture:SetTexture(LSM:Fetch("statusbar", self.Config.Layout.BackgroundTexture));
    self.FrameTexture:SetPoint("TOPLEFT", self.Content, "TOPLEFT", self.Config.Layout.BackgroundTextureInsets, -self.Config.Layout.BackgroundTextureInsets);
    self.FrameTexture:SetPoint("BOTTOMRIGHT", self.Content, "BOTTOMRIGHT", -self.Config.Layout.BackgroundTextureInsets, self.Config.Layout.BackgroundTextureInsets);
    self.FrameTexture:SetVertexColor(unpack(self.Config.Layout.BackgroundTextureColor));
    
    local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = 0, 0, 0, 1, 1, 0, 1, 1;
    
    if self.Config.Layout.BackgroundTextureFlipX == true then
    
      ULy, LLy = LLy, ULy; -- Flip upper left to lower left.
      URy, LRy = LRy, URy; -- Flip upper right to lower right.
    
    end
    
    if self.Config.Layout.BackgroundTextureFlipY == true then
    
      ULx, URx = URx, ULx; -- Flip upper left to upper right.
      LLx, LRx = LRx, LLx; -- Flip lower left to lower right.
    
    end
    
    if self.Config.Layout.BackgroundTextureRotate == true then
    
      -- We rotate 90 degrees to the right.
      
      ULx, ULy, URx, URy, LRx, LRy, LLx, LLy = LLx, LLy, ULx, ULy, URx, URy, LRx, LRy;
      
    end
    
    if self.Config.Layout.Style ~= "HORIZONTAL" then
    
      -- We rotate 90 degrees to the right if we are vertical.
      
      ULx, ULy, URx, URy, LRx, LRy, LLx, LLy = LLx, LLy, ULx, ULy, URx, URy, LRx, LRy;
      
    end
    
    self.FrameTexture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy);
    
    self.Content:SetBackdrop({
      edgeFile = LSM:Fetch("border", self.Config.Layout.BackgroundBorder), 
      edgeSize = self.Config.Layout.BackgroundBorderSize, 
    });
    self.Content:SetBackdropBorderColor(unpack(self.Config.Layout.BackgroundBorderColor));
    
    self.TooltipOptions = {
      ShowPrefix = self.Config.Layout.TooltipShowPrefix,
      ShowUnit = self.Config.Layout.TooltipShowUnitName,
      ShowCaster = self.Config.Layout.TooltipShowCaster,
      ShowAuraId = self.Config.Layout.TooltipShowAuraId,
      ShowClassification = self.Config.Layout.TooltipShowClassification,
    };
    
    AuraFrames:SetFontObjectProperties(
      self.DurationFontObject,
      self.Config.Layout.DurationFont,
      self.Config.Layout.DurationSize,
      self.Config.Layout.DurationOutline,
      self.Config.Layout.DurationMonochrome,
      self.Config.Layout.DurationColor
    );
    
    AuraFrames:SetFontObjectProperties(
      self.CountFontObject,
      self.Config.Layout.CountFont,
      self.Config.Layout.CountSize,
      self.Config.Layout.CountOutline,
      self.Config.Layout.CountMonochrome,
      self.Config.Layout.CountColor
    );
    
    AuraFrames:SetFontObjectProperties(
      self.TextFontObject,
      self.Config.Layout.TextFont,
      self.Config.Layout.TextSize,
      self.Config.Layout.TextOutline,
      self.Config.Layout.TextMonochrome,
      self.Config.Layout.TextColor
    );
    
    self.Direction = DirectionMapping[self.Config.Layout.Style][self.Config.Layout.Direction];
    self.ButtonIndent = self.Config.Layout.ButtonIndent == true and ((self.Config.Layout.Style == "HORIZONTAL" and self.Config.Layout.ButtonSizeX or self.Config.Layout.ButtonSizeY) * self.Config.Layout.ButtonScale) / 2 or 0;
    self.StepPerSecond = ((self.Config.Layout.Length - (self.ButtonIndent * 2)) / self.Config.Layout.MaxTime);
    self.CollisionMargin = (self.Config.Layout.Style == "HORIZONTAL" and self.Config.Layout.ButtonSizeX or self.Config.Layout.ButtonSizeY) * self.Config.Layout.ButtonScale;
    
    self.ButtonScale = self.Config.Layout.ButtonScale;

    for _, Button in pairs(self.Buttons) do
    
      Button:SetWidth(self.Config.Layout.ButtonSizeX);
      Button:SetHeight(self.Config.Layout.ButtonSizeY);
      
    end
    
    if MSQ then
      self.MSQGroup:ReSkin();
    end

    for _, Button in pairs(self.Buttons) do
      self:UpdateButton(Button);
    end

    -- We have buttons in the container pool that doesn't match the settings anymore. Release them into the general pool.
    self:ReleasePool();
    
    for _, Label in ipairs(self.TextLabels) do
      Label:Hide();
    end
    
    wipe(self.TextLabels);
    
    if self.Config.Layout.ShowText == true then
    
      local FrameId = self.Content:GetName();
      
      if self.Config.Layout.TextLabelsAuto == true then
        
        wipe(self.Config.Layout.TextLabels);
        
        local Time, Index = 1, 1;
        local Offset, Width;
      
        while Time <= self.Config.Layout.MaxTime do
          
          local NewOffset = self.ButtonIndent + (((self.Config.Layout.MaxTime - Time) * self.StepPerSecond) * self:CalcPos(Time));
          
          if not Offset or Offset - Width - self.Config.Layout.TextLabelAutoSpace > NewOffset then
          
            local Label = _G[FrameId.."_Label"..Index] or self.Frame:CreateFontString(FrameId.."_Label"..Index, "ARTWORK");
            
            Label:ClearAllPoints();
            
            Offset = NewOffset;
            
            Label:SetPoint("CENTER", self.Content, self.Direction[1], (Offset * self.Direction[2]) + (self.Config.Layout.TextOffset * self.Direction[4]), (Offset * self.Direction[3]) + (self.Config.Layout.TextOffset * self.Direction[5]));
            
            Label:SetFontObject(self.TextFontObject);
            Label:SetFormattedText(AuraFrames:FormatTimeLeft(self.Config.Layout.TextLayout, Time, false));
            Label:Show();
          
            Width = self.Config.Layout.Style == "HORIZONTAL" and Label:GetStringWidth() or Label:GetStringHeight() ;
            tinsert(self.TextLabels, Label);

            tinsert(self.Config.Layout.TextLabels, Time);

            Index = Index + 1;
          
          end
          
          if Time == 1 then
            Time = 5;
          elseif Time < 30 then
            Time = Time + 5;
          elseif Time < 120 then
            Time = Time + 10;
          elseif Time < 300 then
            Time = Time + 30;
          elseif Time < 600 then -- 10 min
            Time = Time + 60;
          elseif Time < 1200 then -- 20 min
            Time = Time + 120;
          else
            Time = Time + 300;
          end
          
        end
      
      else
      
        for Index, Time in ipairs(self.Config.Layout.TextLabels) do

          if self.Config.Layout.MaxTime >= Time and Time >= 0 then

            local Label = _G[FrameId.."_Label"..Index] or self.Content:CreateFontString(FrameId.."_Label"..Index, "ARTWORK");
            
            Label:ClearAllPoints();
            
            local Offset = self.ButtonIndent + (((self.Config.Layout.MaxTime - Time) * self.StepPerSecond) * self:CalcPos(Time));
            
            Label:SetPoint("CENTER", self.Content, self.Direction[1], (Offset * self.Direction[2]) + (self.Config.Layout.TextOffset * self.Direction[4]), (Offset * self.Direction[3]) + (self.Config.Layout.TextOffset * self.Direction[5]));
            
            Label:SetFontObject(self.TextFontObject);
            Label:SetFormattedText(AuraFrames:FormatTimeLeft(self.Config.Layout.TextLayout, Time, false));
            Label:Show();
            
            tinsert(self.TextLabels, Label);
          
          end
          
        end
      
      end
    
    end
    
    self:UpdateVisibility();
    
  end

  if Changed == "ALL" or Changed == "ANIMATIONS" then
    
    self:UpdateAnimationConfig();
    
  end

  if self.RecieveMouseEvents then
    
    self.Frame:EnableMouse(true);
    
  else
    
    self.Frame:EnableMouse(false);
    
  end

  self.PowTimeCompressionDivider = math_pow(self.Config.Layout.MaxTime, self.Config.Layout.TimeCompression);

end


-----------------------------------------------------------------
-- Function AuraEvent
-----------------------------------------------------------------
function Prototype:AuraEvent(Aura, Event, ...)

  local Button = self.Buttons[Aura];

  if Event == "ColorChanged" and Button.Border ~= nil then

    Button.Border:SetVertexColor(unpack(Aura.Color));
  
  end

end


-----------------------------------------------------------------
-- Function AuraNew
-----------------------------------------------------------------
function Prototype:AuraNew(Aura)

  -- Pop the last button out the container pool.
  local Button = tremove(self.ButtonPool);
  local FromContainerPool = Button and true or false;
  
  if not Button then
  
    -- We didn't had a button in the container pool.
    -- Trying the general pool.
    Button = tremove(ButtonPool);
    
    if not Button then
      -- No buttons in any pool. Let's make a new button.
    
      ButtonCounter = ButtonCounter + 1;
    
      local ButtonId = "AuraFramesTimeLineButton"..ButtonCounter;

      Button = CreateFrame("Button", ButtonId, self.Content, "AuraFramesTimeLineTemplate");
      
      Button.Content = _G[ButtonId.."Content"];
      Button.Duration = _G[ButtonId.."ContentDuration"];
      Button.Icon = _G[ButtonId.."ContentIcon"];
      Button.Count = _G[ButtonId.."ContentCount"];
      Button.Border = _G[ButtonId.."ContentBorder"];
      
      Button._AlphaRegion = Button.Icon;
		Button:Show();
    else
    
      Button:SetParent(self.Content);
    
    end
  
    -- We got a general pool button or a new button.
    -- Prepare it so it match a container pool button.
    
    local Container = self;  
    Button:SetScript("OnUpdate", function(Button, Elapsed)
      ButtonOnUpdate(Container, Button, Elapsed);
    end);
    
    Button:SetWidth(self.Config.Layout.ButtonSizeX);
    Button:SetHeight(self.Config.Layout.ButtonSizeY);
    
    Button.Content:SetWidth(self.Config.Layout.ButtonSizeX);
    Button.Content:SetHeight(self.Config.Layout.ButtonSizeY);

    -- We need to update the animation region, otherwise Masque will generate wrong buttons.
    AuraFrames:UpdateAnimationRegionSize(Button);

    -- Set the font from this container.
    Button.Duration:SetFontObject(self.DurationFontObject);
    Button.Count:SetFontObject(self.CountFontObject);
    
    if MSQ then
    
      -- Don't skin the count text, we will take care of that.
      self.MSQGroup:AddButton(Button.Content, {Icon = Button.Icon, Border = Button.Border, Count = false, Duration = false});
      
      if not AuraFrames.db.profile.DisableMasqueSkinWarnings then

        -- Warn the player for bad skins.
        local BlendMode = Button.Border:GetBlendMode();
        if BlendMode ~= "ADD" and BlendMode ~= "BLEND" then

          if not Container.ComplainedAboutBlendMode then
            AuraFrames:Print("The Masque skin used for container \""..Container.Config.Name.."\" is using a wrong type of blendmode (\""..BlendMode.."\") for the border. Please contact the skin author and request him to use \"ADD\" or \"BLEND\" as blendmode for the border. Because of this, buttons can show up black.");
            Container.ComplainedAboutBlendMode = true;
          end

        end

      end

    else
    
      Button.Border:SetAllPoints(Button);
      
    end
    
  end

  -- Make sure we dont have cluster info from an old aura.
  Button.ClusterVisible = nil;
  
  Button.TimeLeftSeconds = 0;
  
  Button.Aura = Aura;
  Button.Icon:SetTexture(Aura.Icon);
  
  self.Buttons[Aura] = Button;
  
  if FromContainerPool == true then

    -- We need only a display update.
    self:UpdateButtonDisplay(Button);

  else

    -- We need a full update.
    self:UpdateButton(Button);

  end

  self:UpdateVisibility();

  Button:SetFrameStrata("MEDIUM");
  Button:SetFrameLevel(FrameLevelNormal);
  Button.Content:SetFrameLevel(FrameLevelNormal);

  if not Aura.IsRefired then
    self.AnimationAuraNew:Play(Button);
  end

  self:ClusterDetection();

  if self.AnimationGoingVisible:IsPlaying(self.Frame) then
    self.AnimationGoingVisibleChild:Play(Button, nil, self.AnimationGoingVisible:GetProgression(self.Frame));
  end
  
end

-----------------------------------------------------------------
-- Function AuraOld
-----------------------------------------------------------------
function Prototype:AuraOld(Aura)

  if not self.Buttons[Aura] then
    return
  end
  
  local Button = self.Buttons[Aura];
  
  -- Remove the button from the container list.
  self.Buttons[Aura] = nil;
  
  Button:Hide();
  
  if AuraFrames:IsTooltipOwner(Button) == true then
    AuraFrames:HideTooltip();
  end
  
  -- Reset animation settings.
  AuraFrames:StopAnimations(Button);
  AuraFrames:ClearAnimationEffects(Button);
  
  -- See in what pool we need to drop.
  if #self.ButtonPool >= ContainerButtonPoolSize then
  
    -- General pool.
  
    if MSQ then
      self.MSQGroup:RemoveButton(Button.Content, true);
    end

    Button:ClearAllPoints();
    Button:SetParent(nil);
    
    Button:SetScript("OnUpdate", nil);
    
    -- Release the button back in the general pool for later use.
    tinsert(ButtonPool, Button);
  
  else
  
    -- Release the button back in the container pool for later use.
    tinsert(self.ButtonPool, Button);
  
  end
  
  self:UpdateVisibility();

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
-- Function AuraChanged
-----------------------------------------------------------------
function Prototype:AuraChanged(Aura)

  if not self.Buttons[Aura] then
    return
  end
  
  local Button = self.Buttons[Aura];
  
  if Button.Count and self.Config.Layout.ShowCount and (Aura.Count > 1 or Aura.ForceCountShow) then
  
    Button.Count:SetText(Aura.Count or 0);
    Button.Count:Show();
    
  elseif Button.Count then
    
    Button.Count:Hide();
    
  end
  
  if not self.AnimationAuraChanging:IsPlaying(Button) then
    self.AnimationAuraChanging:Play(Button);
  end
  
end


-----------------------------------------------------------------
-- Function UpdateVisibility
-----------------------------------------------------------------
function Prototype:UpdateVisibility()

  if self.Unlocked ~= true and (next(self.Buttons) == nil or self.ContainerVisibility == false) then
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

    -- Remove any animation effect on the TimeLine.
    AuraFrames:StopAnimations(self.Frame);
    AuraFrames:ClearAnimationEffects(self.Frame);
    self.Frame:SetFrameStrata("MEDIUM");

  end

  if AnimationType == "ALL" or AnimationType == "AuraNew" or AnimationType == "AuraChanging" or AnimationType == "AuraExpiring" or AnimationType == "TimeLineCluster" then

    for _, Button in pairs(self.Buttons) do

      -- Remove any animation effect on the Button.
      AuraFrames:StopAnimations(Button);
      AuraFrames:ClearAnimationEffects(Button);
      Button:SetFrameStrata("MEDIUM");
      Button:SetFrameLevel(FrameLevelNormal);
      Button.ClusterVisible = nil;

    end

  end

  -- Update animation effects.
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "AuraNew", self, self.AnimationAuraNew);
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "AuraChanging", self, self.AnimationAuraChanging);
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "AuraExpiring", self, self.AnimationAuraExpiring);
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "TimeLineCluster", self, self.AnimationClusterGoVisible, self.AnimationClusterGoInvisible);
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "ContainerVisibility", self, self.AnimationGoingVisible, self.AnimationGoingVisibleChild, self.AnimationGoingInvisible);

  if AnimationType == "ALL" or AnimationType == "TimeLineCluster" then
  
    -- Detect clusters.
    self:ClusterDetection();

  end

  if AnimationType == "ALL" or AnimationType == "ContainerVisibility" then
    self:UpdateVisibility();
  end

end

