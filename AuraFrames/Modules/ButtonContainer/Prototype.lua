local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local Module = AuraFrames:GetModule("ButtonContainer");
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

-- Pool that contains all the current unused buttons sorted by type.
local ButtonPool = {};

-- All containers have also there own (smaller) pool.
local ContainerButtonPoolSize = 5;

-- Counters for each butten type.
local ButtonCounter = 0;

-- Direction = {AnchorPoint, first Horizontal or Vertical, X Direction, Y Direction}
local DirectionMapping = {
  LEFTDOWN  = {"TOPRIGHT",    "V", -1, -1},
  LEFTUP    = {"BOTTOMRIGHT", "V", -1,  1},
  RIGHTDOWN = {"TOPLEFT",     "V",  1, -1},
  RIGHTUP   = {"BOTTOMLEFT",  "V",  1,  1},
  DOWNLEFT  = {"TOPRIGHT",    "H", -1, -1},
  DOWNRIGHT = {"TOPLEFT",     "H",  1, -1},
  UPLEFT    = {"BOTTOMRIGHT", "H", -1,  1},
  UPRIGHT   = {"BOTTOMLEFT",  "H",  1,  1},
};

local MiniBarDirectionMapping = {
  HIGHGROW      = 0,
  LOWGROW       = 0,
  MIDDLEGROW    = 0,
  HIGHSHRINK    = 1,
  LOWSHRINK     = 1,
  MIDDLESHRINK  = 1
};

local MiniBarPointMappings = {
  HORIZONTAL = {
    HIGHGROW     = {"LEFT",   -1,  0},
    LOWGROW      = {"RIGHT",   1,  0},
    MIDDLEGROW   = {"CENTER",  0,  0},
    HIGHSHRINK   = {"LEFT",   -1,  0},
    LOWSHRINK    = {"RIGHT",   1,  0},
    MIDDLESHRINK = {"CENTER",  0,  0}
  },
  VERTICAL = {
    HIGHGROW     = {"TOP",    0,  1},
    LOWGROW      = {"BOTTOM", 0, -1},
    MIDDLEGROW   = {"CENTER", 0,  0},
    HIGHSHRINK   = {"TOP",    0,  1},
    LOWSHRINK    = {"BOTTOM", 0, -1},
    MIDDLESHRINK = {"CENTER", 0,  0}
  }
};

-- How fast a button will get updated.
local ButtonUpdatePeriod = 0.05;

-- Pre calculate pi * 2 (used for flashing buttons).
local PI2 = PI + PI;

-- Pre calculate pi / 2 (used for popup buttons).
local PI_2 = PI / 2;

-- Frame levels used for poping up buttons.
local FrameLevelLow = 3;
local FrameLevelNormal = 6;
local FrameLevelHigh = 9;

-----------------------------------------------------------------
-- Cooldown Fix
-----------------------------------------------------------------
--[[
local CooldownFrame = CreateFrame("Frame");
CooldownFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
CooldownFrame:SetScript("OnEvent", function(self, event)

  -- When we are in a loading screen, all cooldown
  -- animations will be created and started but due
  -- a bug in wow the animations will not be showned.
  -- The first 10 seconds after the PLAYER_ENTERING_WORLD
  -- we hide/show the cooldown which will trigger the 
  -- internal animation at some point.

  local TimePast = 0;

  self:SetScript("OnUpdate", function(self, Elapsed)

    TimePast = TimePast + Elapsed;
    
    if TimePast > 10 then
    
      -- Disable our self after the first 10 seconds.
      self:SetScript("OnUpdate", nil);
      
    end
    
    for _, Container in pairs(Module.Containers) do
    
      for _, Button in pairs(Container.Buttons or {}) do
      
        if Button.Cooldown:IsShown() == true then
        
          -- Try trigger animation code.
          Button.Cooldown:Hide();
          Button.Cooldown:Show();
        
        end
      
      end
    
    end
    
  end);

end);
]]--

-----------------------------------------------------------------
-- Local Function ButtonOnUpdate
-----------------------------------------------------------------
local function ButtonOnUpdate(Container, Button, Elapsed)

  local Config = Container.Config;

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
    
    if Config.Layout.MiniBarEnabled == true and Button.Aura.Duration ~= 0 then
    
      if not Button.MiniBar:IsShown() then
        Button.MiniBar:Show();
      end
      
      local Length = Config.Layout.MiniBarLength * max(min(TimeLeft / Button.Aura.Duration, 1), 0);
      
      if MiniBarDirectionMapping[Config.Layout.MiniBarDirection] ~= 1 then
        Length = Config.Layout.MiniBarLength - Length;
      end
    
      if Length < 1 then
      
        Button.MiniBar:Hide();
      
      elseif Config.Layout.MiniBarStyle == "HORIZONTAL" then
      
        Button.MiniBar:SetWidth(Length);
      
      else
      
        Button.MiniBar:SetHeight(Length);
      
      end
      
    else
    
      if Button.MiniBar:IsShown() then
        Button.MiniBar:Hide();
      end
    
    end
    
  
  else
  
    if Config.Layout.MiniBarEnabled == true and Button.MiniBar:IsShown() then
      Button.MiniBar:Hide();
    end
  
  end

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
      self.MSQGroup:RemoveButton(Button, true);
    end
  
    Button:ClearAllPoints();
    Button:SetParent(nil);
    
    -- Release the button in the general pool.
    tinsert(ButtonPool, Button);
  
  end
  
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
  
  if self.Config.Layout.ShowCooldown == true and Aura.ExpirationTime > 0 then
    
    local CurrentTime = GetTime();

    if Aura.Duration > 0 then
      Button.Cooldown:SetCooldown(Aura.ExpirationTime - Aura.Duration, Aura.Duration);
    else
      Button.Cooldown:SetCooldown(CurrentTime, Aura.ExpirationTime - CurrentTime);
    end
    
    Button.Cooldown:Show();
  
  else
  
    Button.Cooldown:Hide();
  
  end

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
    Button.Duration:SetPoint(self.Config.Layout.DurationAlignment, Button.Content, "CENTER", self.Config.Layout.DurationPosX, self.Config.Layout.DurationPosY);
    Button.Duration:SetJustifyH(self.Config.Layout.DurationAlignment);
  
  end

  if self.Config.Layout.ShowCount == true then
  
    Button.Count:ClearAllPoints();
    Button.Count:SetPoint(self.Config.Layout.CountAlignment, Button.Content, "CENTER", self.Config.Layout.CountPosX, self.Config.Layout.CountPosY);
    Button.Count:SetJustifyH(self.Config.Layout.CountAlignment);
    
  end
  
  if self.RecieveMouseEvents == true and self.Config.Layout.ShowTooltip == true then
  
    Button:SetScript("OnEnter", function() AuraFrames:SetCancelAuraFrame(Button, Button.Aura); AuraFrames:ShowTooltip(Button.Aura, Button, Container.TooltipOptions); self:CheckVisibility(true); end);
    Button:SetScript("OnLeave", function() AuraFrames:HideTooltip(); self:CheckVisibility(false); end);
  
  else
  
    Button:SetScript("OnEnter", function() AuraFrames:SetCancelAuraFrame(Button, Button.Aura); self:CheckVisibility(true); end);
    Button:SetScript("OnLeave", function() self:CheckVisibility(false); end);
  
  end
  
  if self.RecieveMouseEvents == true then
    
    Button:EnableMouse(true);
    Button.Content:EnableMouse(true);
    Button:RegisterForClicks("RightButtonUp");
    Button:SetScript("OnClick", ButtonOnClick);
    
  else
    
    Button:EnableMouse(false);
    Button.Content:EnableMouse(false);
    Button:SetScript("OnClick", nil);
    
  end
  
  -- Set cooldown options
  if Button.Cooldown.SetDrawEdge then
    Button.Cooldown:SetDrawEdge(self.Config.Layout.CooldownDrawEdge);
  end
  Button.Cooldown:SetReverse(self.Config.Layout.CooldownReverse);
  Button.Cooldown.noCooldownCount = self.Config.Layout.CooldownDisableOmniCC;
  
  if self.Config.Layout.MiniBarEnabled == true then
  
    local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = 0, 0, 0, 1, 1, 0, 1, 1;

    Button.MiniBar:SetTexture(LSM:Fetch("statusbar", self.Config.Layout.MiniBarTexture));
    
    if self.Config.Layout.MiniBarStyle == "HORIZONTAL" then
    
      Button.MiniBar:SetWidth(self.Config.Layout.MiniBarLength);
      Button.MiniBar:SetHeight(self.Config.Layout.MiniBarWidth);
    
    else -- VERTICAL
    
      ULx, ULy, URx, URy, LRx, LRy, LLx, LLy = LLx, LLy, ULx, ULy, URx, URy, LRx, LRy;
    
      Button.MiniBar:SetWidth(self.Config.Layout.MiniBarWidth);
      Button.MiniBar:SetHeight(self.Config.Layout.MiniBarLength);
    
    end
    
    Button.MiniBar:ClearAllPoints();
    
    local Point = MiniBarPointMappings[self.Config.Layout.MiniBarStyle][self.Config.Layout.MiniBarDirection];
    
    Button.MiniBar:SetPoint(Point[1], Button.Content, "CENTER", self.Config.Layout.MiniBarOffsetX + (Point[2] * (self.Config.Layout.MiniBarLength / 2)), self.Config.Layout.MiniBarOffsetY + (Point[3] * (self.Config.Layout.MiniBarLength / 2)));
    
    Button.MiniBar:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy);
    
    Button.MiniBar:SetVertexColor(unpack(self.Config.Layout.MiniBarColor));
    
    Button.MiniBar:Show();

  else

    Button.MiniBar:Hide();

  end

  if self.Config.Layout.ShowBorder == "ALWAYS" then

    Button.Border:Show();

  elseif self.Config.Layout.ShowBorder == "NEVER" then

    Button.Border:Hide();

  end
  
  self:UpdateButtonDisplay(Button);

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

    self.Frame:SetWidth((self.Config.Layout.HorizontalSize * self.Config.Layout.ButtonSizeX) + ((self.Config.Layout.HorizontalSize - 1) * self.Config.Layout.SpaceX));
    self.Frame:SetHeight((self.Config.Layout.VerticalSize * self.Config.Layout.ButtonSizeY) + ((self.Config.Layout.VerticalSize - 1) * self.Config.Layout.SpaceY));
    
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
    
    self.MaxButtons = self.Config.Layout.HorizontalSize * self.Config.Layout.VerticalSize;
    self.Direction = DirectionMapping[self.Config.Layout.Direction];
    
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
    
    -- Anchor all buttons.
    self.AuraList:AnchorAllAuras();
    
    -- We have buttons in the container pool that doesn't match the settings anymore. Release them into the general pool.
    self:ReleasePool();

    if Changed == "LAYOUT" then

      self:UpdateAnimationConfig("ButtonContainerMove");

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
    
      local ButtonId = "AuraFramesButton"..ButtonCounter;

      Button = CreateFrame("Button", ButtonId, self.Content, "AuraFramesButtonTemplate");
      
      Button.Content = _G[ButtonId.."Content"];
      Button.Duration = _G[ButtonId.."ContentDuration"];
      Button.Icon = _G[ButtonId.."ContentIcon"];
      Button.Count = _G[ButtonId.."ContentCount"];
      Button.Border = _G[ButtonId.."ContentBorder"];
      Button.Cooldown = _G[ButtonId.."ContentCooldown"];
      Button.MiniBar = _G[ButtonId.."ContentMiniBar"];
      Button:Show(); -- 2018-07-24 CB
    
    else
    
      Button:SetParent(self.Content);
    
    end
  
    -- We got a general pool button or a new button.
    -- Prepare it so it match a container pool button.
    
    local Container = self;  
    Button:SetScript("OnUpdate", function(Button, Elapsed)
      
       Button.TimeSinceLastUpdate = Button.TimeSinceLastUpdate + Elapsed;
       if Button.TimeSinceLastUpdate > ButtonUpdatePeriod then
          ButtonOnUpdate(Container, Button, Button.TimeSinceLastUpdate);
          Button.TimeSinceLastUpdate = 0.0;
       end
      
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
      self.MSQGroup:AddButton(Button.Content, {Icon = Button.Icon, Border = Button.Border, Count = false, Duration = false, Cooldown = Button.Cooldown});
      
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
      Button.Cooldown:SetAllPoints(Button);
    
    end
    
    Button.Cooldown.currentCooldownType = COOLDOWN_TYPE_NORMAL;
    Button.Cooldown:SetSwipeColor(0, 0, 0, 0.5);
    Button.Cooldown:SetHideCountdownNumbers(false);
    Button.Cooldown:SetEdgeTexture("Interface\\Cooldown\\edge");
    
  end
  
  Button.TimeSinceLastUpdate = 0.0;
  Button.TimeLeftSeconds = 0;
  
  Button.Aura = Aura;
  if Aura.Icon ~= nil then
    Button.Cooldown:SetSwipeTexture(Aura.Icon);
  end
  Button.Icon:SetTexture(Aura.Icon);

  
  self.Buttons[Aura] = Button;
  
  if FromContainerPool == true then

    -- We need only a display update.
    self:UpdateButtonDisplay(Button);

  else

    -- We need a full update.
    self:UpdateButton(Button);

  end

  Button:SetFrameStrata("MEDIUM");
  Button:SetFrameLevel(FrameLevelNormal);
  Button.Content:SetFrameLevel(FrameLevelNormal);

  if not Aura.IsRefired then
    self.AnimationAuraNew:Play(Button);
  end

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
  
  -- Sometimes the cooldown frame will be stuck showing.
  Button.Cooldown:Hide();
  
  if AuraFrames:IsTooltipOwner(Button) == true then
    AuraFrames:HideTooltip();
  end
  
  -- Reset animation settings.
  AuraFrames:StopAnimations(Button);
  AuraFrames:ClearAnimationEffects(Button);

  -- Reset order pos.
  Button.OrderPos = nil;
  
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
-- Function AuraAnchor
-----------------------------------------------------------------
function Prototype:AuraAnchor(Aura, Index)

  local Button = self.Buttons[Aura];

  if not Button then
    return;
  end

  Button.FromX = Button.ToX;
  Button.FromY = Button.ToY;

  local OldPos = Button.OrderPos;

  -- Save the order position.
  Button.OrderPos = Index;

  -- Hide button if the index is greater then the maximum number of buttons to anchor
  if Index > self.MaxButtons then
  
    Button:Hide();
    return;
    
  end
  
  local x, y;
  
  -- Calculate the x and y of the button.
  if self.Direction[2] == "V" then
    x, y = ((Index - 1) % self.Config.Layout.HorizontalSize), math_floor((Index - 1) / self.Config.Layout.HorizontalSize);
  else
    x, y = math_floor((Index - 1) / self.Config.Layout.VerticalSize), ((Index - 1) % self.Config.Layout.VerticalSize);
  end

  x = self.Direction[3] * ((x * (self.Config.Layout.ButtonSizeX + (x and self.Config.Layout.SpaceX))) + (self.Config.Layout.ButtonSizeX / 2));
  y = self.Direction[4] * ((y * (self.Config.Layout.ButtonSizeY + (y and self.Config.Layout.SpaceY))) + (self.Config.Layout.ButtonSizeY / 2));
  
  -- Set the position.
  Button:SetPoint(
    "CENTER",
    self.Content,
    self.Direction[1],
    x,
    y
  );

  Button.ToX = x;
  Button.ToY = y;

  -- Make sure the button is showned.
  Button:Show();

  if OldPos and OldPos ~= Index and Button.FromX and Button.FromY then

    Button.MoveX = Button.FromX + (CurrentEffects and CurrentEffects.XOffset or 0) - Button.ToX;
    Button.MoveY = Button.FromY + (CurrentEffects and CurrentEffects.YOffset or 0) - Button.ToY;

    -- If not moving then stop the animation (no need to check if it is playing).
    if Button.MoveX == 0 and Button.MoveY == 0 then

      self.AnimationMoveButton:Stop(Button);

    else

      self.AnimationMoveButton:Play(Button);

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

    -- Remove any animation effect on the TimeLine.
    AuraFrames:StopAnimations(self.Frame);
    AuraFrames:ClearAnimationEffects(self.Frame);
    self.Frame:SetFrameStrata("MEDIUM");

  end

  if AnimationType == "ALL" or AnimationType == "AuraNew" or AnimationType == "AuraChanging" or AnimationType == "AuraExpiring" then

    for _, Button in pairs(self.Buttons) do

      -- Remove any animation effect on the Button.
      AuraFrames:StopAnimations(Button);
      AuraFrames:ClearAnimationEffects(Button);
      Button:SetFrameStrata("MEDIUM");
      Button:SetFrameLevel(FrameLevelNormal);

    end

  end

  -- Update animation effects.
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "AuraNew", self, self.AnimationAuraNew);
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "AuraChanging", self, self.AnimationAuraChanging);
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "AuraExpiring", self, self.AnimationAuraExpiring);
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "ContainerVisibility", self, self.AnimationGoingVisible, self.AnimationGoingVisibleChild, self.AnimationGoingInvisible);
  AuraFrames:UpdateAnimationConfig(AnimationConfig, "ButtonContainerMove", self, self.AnimationMoveButton);

  -- Reset own status if needed.
  if self.IsVisible == false and (AnimationType == "ALL" or AnimationType == "ContainerVisibility") then
    self.IsVisible = true;
    self:UpdateVisibility();
  end

end
