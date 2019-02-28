local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

AuraFrames.ContainerModules = {};

-----------------------------------------------------------------
-- Function NewContainerModule
-----------------------------------------------------------------
function AuraFrames:NewContainerModule(ModuleId, ...)

  local Module = self:NewModule(ModuleId, ...);
  
  self.ContainerModules[ModuleId] = Module;
  
  return Module;

end

