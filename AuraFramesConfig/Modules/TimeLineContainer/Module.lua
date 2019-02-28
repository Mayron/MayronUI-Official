local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local Module = AuraFramesConfig:NewModule("TimeLineContainer");

-----------------------------------------------------------------
-- Local Function round
-----------------------------------------------------------------
local function round(x)
  
  return math.floor(x + 0.5);

end

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
-- Function Update
-----------------------------------------------------------------
function Module:Update(ContainerId)

  local Container = AuraFrames.Containers[ContainerId];
  local Config = AuraFrames.db.profile.Containers[ContainerId];

  if Container.Unlocked == true and Container.UnlockFrame then
  
    Container.UnlockFrame.Text:SetText("Container "..Config.Name);
  
  end

end

-----------------------------------------------------------------
-- Function UnlockContainer
-----------------------------------------------------------------
function Module:UnlockContainer(ContainerId, Unlock)

  local Container = AuraFrames.Containers[ContainerId];
  
  if not Container then
    return;
  end

  Container.Unlocked = Unlock;
  
  if Unlock == true then
    
    if not Container.UnlockFrame then
    
      local Frame = CreateFrame("Frame", nil);
      Frame:SetAllPoints(Container.Frame);
      Frame:EnableMouse(true);
      Frame:SetFrameStrata("TOOLTIP");
      
      Frame:SetScript("OnMouseDown", function(self, Button)

        if Button == "LeftButton" then
          Container.Frame:StartMoving();
        end

      end);
      
      Frame:SetScript("OnMouseUp", function(self, Button)

        if Button == "LeftButton" then
          Container.Frame:StopMovingOrSizing();
        elseif Button == "RightButton" then
          Container.Frame:StopMovingOrSizing();
          AuraFramesConfig:UnlockContainers(false);
          AuraFramesConfig:SelectByPath("Containers", ContainerId);
        end

      end);
      
      Frame:SetScript("OnUpdate", function()
      
        if Container.Config.Layout.Style == "HORIZONTAL" then
        
          Container.Config.Layout.Length = round(Container.Frame:GetWidth());
          Container.Config.Layout.Width = round(Container.Frame:GetHeight());
        
        else
        
          Container.Config.Layout.Length = round(Container.Frame:GetHeight());
          Container.Config.Layout.Width = round(Container.Frame:GetWidth());
        
        end
        
        Container:Update("LAYOUT");
      
      end);
      
      Container.UnlockFrame = Frame;
      
      Frame.Background = Frame:CreateTexture();
      Frame.Background:SetColorTexture(0.5, 0.8, 1.0, 0.8);
      Frame.Background:SetAllPoints(Frame);
      
      Frame.TextFrame = CreateFrame("Frame", nil, Frame);
      Frame.TextFrame:SetAllPoints(Frame);
      
      Frame.Text = Frame.TextFrame:CreateFontString();
      Frame.Text:SetFontObject(ChatFontNormal);
      Frame.Text:SetPoint("CENTER", Frame.TextFrame, "CENTER");
      
      Frame.ResizeFrame = CreateFrame("Frame", nil, Frame);
      Frame.ResizeFrame:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT", 0, 0);
      Frame.ResizeFrame:SetWidth(16);
      Frame.ResizeFrame:SetHeight(16);
      Frame.ResizeFrame:SetScript("OnMouseDown", function(self) Container.Frame:StartSizing(); end);
      Frame.ResizeFrame:SetScript("OnMouseUp", function(self) Container.Frame:StopMovingOrSizing(); end);
      
      Frame.ResizeIcon = Frame.ResizeFrame:CreateTexture(nil, "OVERLAY");
      Frame.ResizeIcon:SetTexture("Interface\\CHATFRAME\\UI-ChatIM-SizeGrabber-Down");
      Frame.ResizeIcon:SetAllPoints(Frame.ResizeFrame);
      
    end
    
    Container:UpdateVisibility(Container);
    
    Container.UnlockFrame:Show();
    
    self:Update(ContainerId);
    
  elseif Container.UnlockFrame then
    
    -- Make sure wow dont try to save the locations of the frame.
    Container.Frame:SetUserPlaced(false);
    
    Container.Config.Location.FramePoint, Container.Config.Location.RelativeTo, Container.Config.Location.RelativePoint, Container.Config.Location.OffsetX, Container.Config.Location.OffsetY = Container.Frame:GetPoint();
    
    if type(Container.Config.Location.RelativeTo) == "table" then
      Container.Config.Location.RelativeTo = Container.Config.Location.RelativeTo:GetID();
    end
    
    if Container.Config.Layout.Style == "HORIZONTAL" then
    
      Container.Config.Layout.Length = round(Container.Frame:GetWidth());
      Container.Config.Layout.Width = round(Container.Frame:GetHeight());
    
    else
    
      Container.Config.Layout.Length = round(Container.Frame:GetHeight());
      Container.Config.Layout.Width = round(Container.Frame:GetWidth());
    
    end
    
    Container:Update("LAYOUT");
    
    Container.UnlockFrame:Hide();
    
    Container:UpdateVisibility(Container);
  
  end
  
end


-----------------------------------------------------------------
-- Function GetTree
-----------------------------------------------------------------
function Module:GetTree(ContainerId)

  if AuraFrames.db.profile.Containers[ContainerId].Enabled ~= true then
    return nil;
  end

  local Tree = {
    {
      value = "Sources",
      text = "Sources",
      execute = function() AuraFramesConfig:ContentSources(ContainerId); end,
    },
    {
      value = "Layout",
      text = "Layout",
      execute = function() Module:ContentLayout(ContainerId); end,
    },
    {
      value = "Animations",
      text = "Animations",
      execute = function() AuraFramesConfig:ContentAnimations(ContainerId); end,
    },
    {
      value = "Visibility",
      text = "Visibility",
      execute = function() AuraFramesConfig:ContentVisibility(ContainerId); end,
    },
    {
      value = "Filter",
      text = "Filter",
      execute = function() AuraFramesConfig:ContentFilter(ContainerId); end,
    },
  };
  
  return Tree;

end
