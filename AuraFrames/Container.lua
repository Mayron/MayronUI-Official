local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

-- Import used global references into the local namespace.
local string, type, rawget, error, pairs = string, type, rawget, error, pairs;

AuraFrames.Containers = {};


-----------------------------------------------------------------
-- Function GenerateContainerId
-----------------------------------------------------------------
function AuraFrames:GenerateContainerId(Name)

  -- Will generate a container id based on Name that is unique
  -- inside the current profile.

  local Containers, Id = self.db.profile.Containers, "";
  
  -- Generate Id based on Name.
  for Part in string.gmatch(Name, "%w+") do
    Id = Id..Part;
  end

  -- Verify if Id is unique, otherwise add an increasing number
  -- at the end.
  if type(rawget(Containers, Id)) ~= "nil" then

    Id = Id.."_";
    local i = 2;

    while type(rawget(Containers, Id..i)) ~= "nil" do
      i = i + 1;
    end

    Id = Id..i;

  end
  
  return Id;

end


-----------------------------------------------------------------
-- Function CreateContainer
-----------------------------------------------------------------
function AuraFrames:CreateContainer(Id)

  -- Create a new container instance using the configuration
  -- from the current profile.

  -- If the container already exists, then raise a error.
  if self.Containers[Id] then
  
    error("Container with Id "..Id.." exists already!");
    return false;
  
  end
  
  local ContainerConfig = self.db.profile.Containers[Id];
  
  -- If the container isn't enabled, then return.
  if ContainerConfig.Enabled ~= true then
    return false;
  end
  
  -- If the container module isn't available then return.
  if not self.ContainerModules[ContainerConfig.Type] then
    return false;
  end
  
  local ContainerModule = self.ContainerModules[ContainerConfig.Type];
  
  -- Enable the container module if it isn't already.
  if not ContainerModule:IsEnabled() then
    ContainerModule:Enable();
  end

  -- Create the container instance.
  self.Containers[Id] = ContainerModule:New(ContainerConfig);
  
  -- Set the container Id on the instance.
  self.Containers[Id].Id = Id;
  
  -- Register all object sources on the new container instance.
  for Unit, _ in pairs(ContainerConfig.Sources) do
  
    for Type, _ in pairs(ContainerConfig.Sources[Unit]) do
  
      if ContainerConfig.Sources[Unit][Type] == true then

        self.Containers[Id].AuraList:AddSource(Unit, Type);

      end

    end

  end

  self.Containers[Id]:Update();
  
  return true;

end


-----------------------------------------------------------------
-- Function CreateNewContainerConfig
-----------------------------------------------------------------
function AuraFrames:CreateNewContainerConfig(Name, Type)

  -- Create a new container configuration and create
  -- a new container instance based on that.
  
  -- Generate the new container id.
  local Id = self:GenerateContainerId(Name);
  
  -- If the container module isn't available then return.
  if not self.ContainerModules[Type] then
    return nil;
  end
  
  local ContainerModule = self.ContainerModules[Type];
  
  -- Enable the container module if it isn't already.
  if not ContainerModule:IsEnabled() then
    ContainerModule:Enable();
  end
  
  -- Create the default config.
  self.db.profile.Containers[Id].Id = Id;
  self.db.profile.Containers[Id].Name = Name;
  self.db.profile.Containers[Id].Type = Type;

  -- Copy the container defaults into the new config.
  self:CopyDatabaseDefaults(ContainerModule:GetDatabaseDefaults(), self.db.profile.Containers[Id]);
  
  return Id;

end



-----------------------------------------------------------------
-- Function DeleteContainer
-----------------------------------------------------------------
function AuraFrames:DeleteContainer(Id)

  -- Return if container instance doesn't exists.
  if not self.Containers[Id] then
    return;
  end

  -- Delete instance.
  self.Containers[Id]:Delete();
  self.Containers[Id] = nil;

end


-----------------------------------------------------------------
-- Function CreateAllContainers
-----------------------------------------------------------------
function AuraFrames:CreateAllContainers()

  -- Create all container instances based on the current profile.
  
  for Id, _ in pairs(self.db.profile.Containers) do
  
    self:CreateContainer(Id);
    
  end

end


-----------------------------------------------------------------
-- Function DeleteAllContainers
-----------------------------------------------------------------
function AuraFrames:DeleteAllContainers()

  -- Delete all container instances.

  for Id, _ in pairs(self.Containers) do
  
    self:DeleteContainer(Id);
  
  end

end
