-----------------------------------------------------------------
--
--  Author: Alex <Nexiuz> Elderson
--
--
--  Todo:
--
--    Module will not be disabled when there are no active sources left!
--
-----------------------------------------------------------------


local Major, Minor = "LibAura-1.0", 1;
local LibAura, OldMinor = LibStub:NewLibrary(Major, Minor);

if not LibAura then return; end -- No upgrade needed.

-- Import used global references into the local namespace.
local tinsert, tremove, tconcat, sort, tContains = tinsert, tremove, table.concat, sort, tContains;
local fmt, tostring = string.format, tostring;
local select, pairs, ipairs, next, type, unpack = select, pairs, ipairs, next, type, unpack;
local loadstring, assert, error = loadstring, assert, error;
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget;
local GetTime, sub = GetTime, string.sub;

-- Expose the library to the global namespace for debugging.
_G["LibAura"] = LibAura;

-- Contains all registered objects and modules.
LibAura.db = LibAura.db or {};

-- Contains all the registered modules with there names and versions.
LibAura.Modules = LibAura.Modules or {};


-----------------------------------------------------------------
-- Function NewModule
-----------------------------------------------------------------
function LibAura:NewModule(Major, Minor)

  local OldMinor = nil;

  if LibAura.Modules[Major] then
  
    if LibAura.Modules[Major].Minor > Minor then
      return nil, LibAura.Modules[Major].Minor;
    end
    
    OldMinor = LibAura.Modules[Major].Minor;
    LibAura.Modules[Major].Minor = Minor;
  
  else
    
    LibAura.Modules[Major] = {Major = Major, Minor = Minor, Enabled = false, UsedSources = 0};
    
  end
  
  -- Set/Upgrade prototype.
  setmetatable(LibAura.Modules[Major], { __index = self.Prototype});
  
  return LibAura.Modules[Major], OldMinor;

end


-----------------------------------------------------------------
-- Function GetModule
-----------------------------------------------------------------
function LibAura:GetModule(Major)

  if not LibAura.Modules[Major] then
    return nil;
  end

  return LibAura.Modules[Major];

end


-----------------------------------------------------------------
-- Function EnableModule
-----------------------------------------------------------------
function LibAura:EnableModule(Module)

  if Module.Enabled == true then
    return true;
  end

  if type(Module.Enable) == "function" then
  
    Module.Enabled = Module:Enable();
  
  else
  
    Module.Enabled = true;
  
  end

  return Module.Enabled;

end


-----------------------------------------------------------------
-- Function DisableModule
-----------------------------------------------------------------
function LibAura:DisableModule(Module)

  if Module.Enabled ~= true then
    return true;
  end
  
  if type(Module.Disable) == "function" then
  
    Module:Disable();
  
  end
  
  Module.Enabled = false;
  
  return;

end


-----------------------------------------------------------------
-- Function RegisterModuleSource
-----------------------------------------------------------------
function LibAura:RegisterModuleSource(Module, Unit, Type)

  -- An module can only fire events for sources where he is registered for. This
  -- is because on a fire we dont want to do much checking if the source exists.
  if not self.db[Unit] then
    self.db[Unit] = {};
  end
  
  if not self.db[Unit][Type] then
    self.db[Unit][Type] = {Modules = {}, Objects = {}};
    self:FireEvent("LIBAURA_MODULE_SOURCE_CREATED", Unit, Type, Module);
  end

  if not tContains(self.db[Unit][Type].Modules, Module) then
    tinsert(self.db[Unit][Type].Modules, Module);
  end

  if #self.db[Unit][Type].Objects ~= 0 then
  
    Module.UsedSources = Module.UsedSources + 1
  
    if Module.UsedSources == 1 then
      self:EnableModule(Module);
    end
  
    -- We got already objects for this Unit/type, directly activate this source for the module.
    Module:ActivateSource(Unit, Type);
    
  end

end

-----------------------------------------------------------------
-- Function UnregisterModuleSource
-----------------------------------------------------------------
function LibAura:UnregisterModuleSource(Module, Unit, Type)

  -- The module that unregister should have removed first all the auras
  -- he owns for the Unit/type. That is not our responsibility.
  
  -- Unit and Type can be nil, if it's nill then every posible Unit/Type
  -- will be scanned for the module.
  
  if Unit == nil then
    
    for Key, _ in pairs(self.db) do
      self:UnregisterModuleSource(Module, Key, Type);
    end
  
    return;
  
  end
  
  if Type == nil then
    
    for Key, _ in pairs(self.db[Unit]) do
      self:UnregisterModuleSource(Module, Unit, Key);
    end
  
    return;
  
  end

  if not self.db[Unit] or not self.db[Unit][Type] then
    return;
  end
  
  for Key, Value in ipairs(self.db[Unit][Type].Modules) do
  
    if Value == Module then
      tremove(self.db[Unit][Type].Modules, Key);
      
      if #self.db[Unit][Type].Objects ~= 0 then
      
        -- Just for the good order, we trigger an deactivate if we still have objects left for this Unit/type.
        Module:DeactivateSource(Unit, Type);
        
        Module.UsedSources = Module.UsedSources - 1
      
        if Module.UsedSources == 0 then
          self:DisableModule(Module);
        end
            
      end
      
      break;
    end
  
  end

  if #self.db[Unit][Type].Modules == 0 then
    self.db[Unit][Type] = nil;
    self:FireEvent("LIBAURA_MODULE_SOURCE_DESTROYED", Unit, Type);
  end
  
  if next(self.db[Unit]) == nil then
    self.db[Unit] = nil;
  end

end


-----------------------------------------------------------------
-- Function RegisterObjectSource
-----------------------------------------------------------------
function LibAura:RegisterObjectSource(Object, Unit, Type)
  if not self.db[Unit] then
    self.db[Unit] = {};
  end
  
  if not self.db[Unit][Type] then
    self.db[Unit][Type] = {Modules = {}, Objects = {}};
  end
  
  if #self.db[Unit][Type].Objects == 0 then
    -- This is the first object for this Unit/type, activate all registered modules for this Unit/type.
    for _, Module in ipairs(self.db[Unit][Type].Modules) do
      Module.UsedSources = Module.UsedSources + 1
      
      if Module.UsedSources == 1 then
        self:EnableModule(Module);
      end
      
      Module:ActivateSource(Unit, Type);
    end
  
  end
  if not tContains(self.db[Unit][Type].Objects, Object) then
    tinsert(self.db[Unit][Type].Objects, Object);
  end
  
  -- Trigger auras for the current object.
  for _, Module in ipairs(self.db[Unit][Type].Modules) do
    local Auras = Module:GetAuras(Unit, Type);
    
    for _, Aura in ipairs(Auras) do
    
      Object:AuraNew(Aura);
    
    end
  
  end

end

-----------------------------------------------------------------
-- Function UnregisterObjectSource
-----------------------------------------------------------------
function LibAura:UnregisterObjectSource(Object, Unit, Type)

  -- Unit and Type can be nil, if it's nill then every posible Unit/Type
  -- will be scanned for the object.
  
  if Unit == nil then
    
    for Key, _ in pairs(self.db) do
      self:UnregisterObjectSource(Object, Key, Type);
    end
  
    return;
  
  end
  
  if Type == nil then
    
    for Key, _ in pairs(self.db[Unit]) do
      self:UnregisterObjectSource(Object, Unit, Key);
    end
  
    return;
  
  end

  if not self.db[Unit] or not self.db[Unit][Type] or #self.db[Unit][Type].Objects == 0 then
    return;
  end
  
  for Key, Value in ipairs(self.db[Unit][Type].Objects) do
  
    if Value == Object then
      tremove(self.db[Unit][Type].Objects, Key);
      
      -- Trigger auras for the old object.
      for _, Module in ipairs(self.db[Unit][Type].Modules) do
      
        local Auras = Module:GetAuras(Unit, Type);
        
        for _, Aura in ipairs(Auras) do
        
          Object:AuraOld(Aura);
        
        end
      
      end
      
      
      break;
    end
  
  end

  if #self.db[Unit][Type].Objects == 0 then

    -- We don't have any objects left for this Unit/type. Deactivate all Unit/type modules.
    for _, Module in ipairs(self.db[Unit][Type].Modules) do

      Module.UsedSources = Module.UsedSources - 1
    
      if Module.UsedSources == 0 then
        self:DisableModule(Module);
      end

      Module:DeactivateSource(Unit, Type);
    end

  end

  if #self.db[Unit][Type].Modules == 0 and #self.db[Unit][Type].Objects then
    self.db[Unit][Type] = nil;
  end
  
  if next(self.db[Unit]) == nil then
    self.db[Unit] = nil;
  end

end


-----------------------------------------------------------------
-- Function ObjectSync
-----------------------------------------------------------------
function LibAura:ObjectSync(Object, Unit, Type)

  -- Unit and Type can be nil, if it's nill then every posible Unit/Type
  -- will be scanned for the object.
  
  if Unit == nil then
    
    for Key, _ in pairs(self.db) do
      self:ObjectSync(Object, Key, Type);
    end
  
    return;
  
  end
  
  if Type == nil then
    
    for Key, _ in pairs(self.db[Unit]) do
      self:ObjectSync(Object, Unit, Key);
    end
  
    return;
  
  end
  
  if tContains(self.db[Unit][Type].Objects, Object) then
  
    -- Trigger auras for all the current object.
    for _, Module in ipairs(self.db[Unit][Type].Modules) do
    
      local Auras = Module:GetAuras(Unit, Type);
      
      for _, Aura in ipairs(Auras) do
      
        Object:AuraNew(Aura);
      
      end
    
    end
  
  end
  
end


-----------------------------------------------------------------
-- Function FireAuraNew
-----------------------------------------------------------------
function LibAura:FireAuraNew(Aura)

  Aura.DetectionTime = GetTime();
  
  if not Aura.CreationTime or Aura.CreationTime == 0 then
    Aura.CreationTime = Aura.DetectionTime;
  end

  Aura.ChangingTime = Aura.CreationTime;

  for _, Object in ipairs(self.db[Aura.Unit][Aura.Type].Objects) do
    Object:AuraNew(Aura);
  end

end


-----------------------------------------------------------------
-- Function FireAuraOld
-----------------------------------------------------------------
function LibAura:FireAuraOld(Aura)

  for _, Object in ipairs(self.db[Aura.Unit][Aura.Type].Objects) do
    Object:AuraOld(Aura);
  end
  
  Aura.CreationTime = nil;

end


-----------------------------------------------------------------
-- Function FireAuraChanged
-----------------------------------------------------------------
function LibAura:FireAuraChanged(Aura)

  Aura.ChangingTime = GetTime();

  for _, Object in ipairs(self.db[Aura.Unit][Aura.Type].Objects) do
    Object:AuraChanged(Aura);
  end

end


-----------------------------------------------------------------
-- Function FireEvent
-----------------------------------------------------------------
function LibAura:FireEvent(Aura, Event, ...)

  for _, Object in ipairs(self.db[Aura.Unit][Aura.Type].Objects) do
    Object:Event(Aura, Event, ...);
  end

end


-----------------------------------------------------------------
-- EventFrame
-----------------------------------------------------------------
LibAura.EventFrame = LibAura.EventFrame or CreateFrame("Frame");
LibAura.EventFrame.TimeSinceLastUpdate = LibAura.EventFrame.TimeSinceLastUpdate or 0.0;
LibAura.EventFrame.Events = LibAura.EventFrame.Events or {};


-----------------------------------------------------------------
-- Function RegisterEvent
-----------------------------------------------------------------
function LibAura:RegisterEvent(Event, Object, Function)

  if not self.EventFrame.Events[Event] then
  
    self.EventFrame.Events[Event] = {};
    
    if sub(Event, 1, 8) ~= "LIBAURA_" then
      self.EventFrame:RegisterEvent(Event);
    end
  
  end
  
  for Index, Item in ipairs(self.EventFrame.Events[Event]) do
  
    if Item[1] == Function and Item[2] == Object then
    
      Item[3] = Item[3] + 1;
      return;
    
    end
  
  end
  
  tinsert(self.EventFrame.Events[Event], {Function, Object, 1});

end


-----------------------------------------------------------------
-- Function UnregisterEvent
-----------------------------------------------------------------
function LibAura:UnregisterEvent(Event, Object, Function)

  if not self.EventFrame.Events[Event] then
    return;
  end
  
  for Index, Item in ipairs(self.EventFrame.Events[Event]) do
  
    if Item[1] == Function and Item[2] == Object then
    
      Item[3] = Item[3] - 1;
      
      if Item[3] > 0 then
        return;
      end
    
      tremove(self.EventFrame.Events[Event], Index);
      
      if #self.EventFrame.Events[Event] == 0 then
      
        self.EventFrame.Events[Event] = nil;
        
        if sub(Event, 1, 8) ~= "LIBAURA_" then
          self.EventFrame:UnregisterEvent(Event);
        end
      
      end
      
      return;
    
    end
  
  end

end


-----------------------------------------------------------------
-- Function FireEvent
-----------------------------------------------------------------
function LibAura:FireEvent(Event, ...)

  if not LibAura.EventFrame.Events[Event] then
    return;
  end

  for _, Value in ipairs(LibAura.EventFrame.Events[Event]) do
  
    Value[1](Value[2], ...);
  
  end

end


-----------------------------------------------------------------
-- Script OnEvent
-----------------------------------------------------------------
LibAura.EventFrame:SetScript("OnEvent", function(Frame, Event, ...)
  for _, Value in ipairs(Frame.Events[Event]) do
  
    Value[1](Value[2], ...);
  
  end
  
end);


-----------------------------------------------------------------
-- Script OnUpdate
-----------------------------------------------------------------
LibAura.EventFrame:SetScript("OnUpdate", function(Frame, Elapsed)
  
  if not Frame.Events.LIBAURA_UPDATE then
    return;
  end
  
  Frame.TimeSinceLastUpdate = Frame.TimeSinceLastUpdate + Elapsed
  
  if Frame.TimeSinceLastUpdate > 0.05 then
    
    for _, Value in ipairs(Frame.Events.LIBAURA_UPDATE) do
    
      Value[1](Value[2], Frame.TimeSinceLastUpdate);
    
    end
    
    Frame.TimeSinceLastUpdate = 0.0;
    
  end
  
end);
