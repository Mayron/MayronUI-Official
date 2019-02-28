local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local LibAura = LibStub("LibAura-1.0");

-- Import used global references into the local namespace.
local pairs, ipairs, wipe, setmetatable = pairs, ipairs, wipe, setmetatable;
local CreateFrame = CreateFrame;

--[[


  Container.AuraList = AuraFrames:NewAuraList(Container, Container.Config.Filter, Container.Config.Order);

  Container functions:

    AuraNew(Aura);
    AuraOld(Aura);
    AuraChanged(Aura);
    AuraAnchor(Aura, Index); -- Only when there is an Order config.

]]--


AuraFrames.AuraListPrototype = {};

local AuraListCheckingThrottle = 0.2;

-----------------------------------------------------------------
-- Function AddSource
-----------------------------------------------------------------
function AuraFrames.AuraListPrototype:AddSource(Unit, Type)

  LibAura:RegisterObjectSource(self, Unit, Type);

end


-----------------------------------------------------------------
-- Function RemoveSource
-----------------------------------------------------------------
function AuraFrames.AuraListPrototype:RemoveSource(Unit, Type)

  LibAura:UnregisterObjectSource(self, Unit, Type);

end


-----------------------------------------------------------------
-- Function ResyncSources
-----------------------------------------------------------------
function AuraFrames.AuraListPrototype:ResyncSources()

  for Aura, Status in pairs(self.Auras) do

    if Status == true then
      self.Container:AuraOld(Aura);
    end

  end
  
  wipe(self.Auras);
  
  if self.Order then
    self.Order:Reset();
  end
  
  if self.Filter.Dynamic == true or self.Colors.Dynamic == true then
    
    self.CheckingFrame:Show();
    
  else
    
    self.CheckingFrame:Hide();
    
  end

  LibAura:ObjectSync(self, nil, nil);

end


-----------------------------------------------------------------
-- Function ResyncColors
-----------------------------------------------------------------
function AuraFrames.AuraListPrototype:ResyncColors()
  
  for Aura, Status in pairs(self.Auras) do
  
    if Status == true then

      Aura.Color = self.Colors.Test(Aura);
      
      self.Container:AuraEvent(Aura, "ColorChanged");
      
    end

  end

  if self.Filter.Dynamic == true or self.Colors.Dynamic == true then
    
    self.CheckingFrame:Show();
    
  else
    
    self.CheckingFrame:Hide();
    
  end

end


-----------------------------------------------------------------
-- Function AnchorAllAuras
-----------------------------------------------------------------
function AuraFrames.AuraListPrototype:AnchorAllAuras()

  if not self.Order then
    return;
  end

  for Index, Aura in ipairs(self.Order) do

    self.Container:AuraAnchor(Aura, Index)  
  
  end

end


-----------------------------------------------------------------
-- Function Delete
-----------------------------------------------------------------
function AuraFrames.AuraListPrototype:Delete()

  -- Remove all aura's.
  self:RemoveSource(nil, nil);

end


-----------------------------------------------------------------
-- Function AuraNew
-----------------------------------------------------------------
function AuraFrames.AuraListPrototype:AuraNew(Aura)

  local Status = self.Auras[Aura];

  if self.Filter.Test(Aura) == false then
  
    if self.Filter.Dynamic == true then
    
      self.Auras[Aura] = false;
      
    else
    
      self.Auras[Aura] = nil;
      
    end
  
    if Status == true then
    
      if self.Order then
        self.Order:Remove(Aura);
      end
    
      self.Container:AuraOld(Aura);
      
    end
  
    return;
    
  end

  self.Auras[Aura] = true;
  
  Aura.Color = self.Colors.Test(Aura);

  if Status ~= true then
  
    self.Container:AuraNew(Aura);
  
    if self.Order then
      self.Order:Add(Aura);
    end
  
  end

end


-----------------------------------------------------------------
-- Function AuraChanged
-----------------------------------------------------------------
function AuraFrames.AuraListPrototype:AuraChanged(Aura)

  local Status = self.Auras[Aura] or false;

  if Status ~= self.Filter.Test(Aura) then
  
    self.Auras[Aura] = not Status;
    
    if self.Auras[Aura] == true then
    
      Aura.Color = self.Colors.Test(Aura);
      self.Container:AuraNew(Aura);
      
      if self.Order then
        self.Order:Add(Aura);
      end
      
    else
    
      if self.Order then
        self.Order:Remove(Aura);
      end
    
      self.Container:AuraOld(Aura);
      
      if self.Filter.Dynamic ~= true then
        self.Auras[Aura] = nil;
      end
      
    end
    
    return;
    
  end
  
  if Status == true then
  
    Aura.Color = self.Colors.Test(Aura);
    self.Container:AuraChanged(Aura);
    
    if self.Order then
      self.Order:Update(Aura);
    end
  
  end

end


-----------------------------------------------------------------
-- Function AuraOld
-----------------------------------------------------------------
function AuraFrames.AuraListPrototype:AuraOld(Aura)

  if self.Auras[Aura] == true then

    self.Container:AuraOld(Aura);

    if self.Order then
      self.Order:Remove(Aura);
    end
  
  end

  self.Auras[Aura] = nil;

end


-----------------------------------------------------------------
-- Function AuraCheck
-----------------------------------------------------------------
function AuraFrames.AuraListPrototype:AuraCheck(Aura)

  local Status = self.Auras[Aura] or false;

  if self.Filter.Dynamic == true and Status ~= self.Filter.Test(Aura) then

    self.Auras[Aura] = not Status;
    
    if self.Auras[Aura] == false then
      
      if self.Order then
        self.Order:Remove(Aura);
      end

      self.Container:AuraOld(Aura);
      
      return;
    
    else
    
      Aura.Color = self.Colors.Test(Aura);
    
      self.Container:AuraNew(Aura);
      
      if self.Order then
        self.Order:Add(Aura);
      end
      
      return;
    
    end
  
  end
  
  if Status == true and self.Colors.Dynamic == true then
  
    local Color = self.Colors.Test(Aura);
    
    if Aura.Color[1] ~= Color[1] or Aura.Color[2] ~= Color[2] or Aura.Color[3] ~= Color[3] or Aura.Color[4] ~= Color[4] then
      
      Aura.Color = Color;
      self.Container:AuraEvent(Aura, "ColorChanged");
      
    end
  
  end
  
end


-----------------------------------------------------------------
-- Function NewAuraList
-----------------------------------------------------------------
function AuraFrames:NewAuraList(Container, FilterConfig, OrderConfig, ColorsConfig)

  local AuraList = {};
  setmetatable(AuraList, { __index = self.AuraListPrototype});
  
  AuraList.Auras = {};
  
  AuraList.Container = Container;
  
  AuraList.CheckingFrame = CreateFrame("Frame");
  AuraList.CheckingFrame.LastScan = 0;
  AuraList.CheckingFrame:Hide();
  AuraList.CheckingFrame:SetScript("OnUpdate", function(CheckingFrame, Elapsed)
  
    CheckingFrame.LastScan = CheckingFrame.LastScan + Elapsed;
    
    if CheckingFrame.LastScan > AuraListCheckingThrottle then
    
      CheckingFrame.LastScan = 0;

      for Aura, _ in pairs(AuraList.Auras) do
        AuraList:AuraCheck(Aura);
      end
    
    end
  
  end);

  AuraList.Filter = self:NewFilter(FilterConfig, function() AuraList:ResyncSources(); end);
  
  if OrderConfig then
    AuraList.Order = self:NewOrder(OrderConfig, function(Aura, Index) Container:AuraAnchor(Aura, Index); end);
  end
  
  AuraList.Colors = self:NewColors(ColorsConfig, function() AuraList:ResyncColors() end);
  
  if AuraList.Filter.Dynamic == true or AuraList.Colors.Dynamic == true then
    
    AuraList.CheckingFrame:Show();
    
  end

  return AuraList;

end

