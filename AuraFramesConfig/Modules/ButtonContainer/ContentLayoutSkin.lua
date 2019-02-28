local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local Module = AuraFramesConfig:GetModule("ButtonContainer");
--local LBF = LibStub("LibButtonFacade", true);
local AceGUI = LibStub("AceGUI-3.0");

-----------------------------------------------------------------
-- Function ContentLayoutSkin
-----------------------------------------------------------------
function Module:ContentLayoutSkin(Content, ContainerId)

  local ContainerInstance = AuraFrames.Containers[ContainerId];

  Content:SetLayout("List");

  Content:AddText("Skin\n", GameFontNormalLarge);
--[[
  Content:AddHeader("ButtonFacade");
  
  if not LBF then
  
    Content:AddText("ButtonFacade is used for skinning the buttons.\n\nThe ButtonFacade addon is not found, please install or enable ButtonFacade addon if you want to use custom button skinning.");
  
  else

    Content:AddText("ButtonFacade is used for skinning the buttons.\n");
    
    local ContentButtonFacade = AceGUI:Create("SimpleGroup");
    ContentButtonFacade:SetRelativeWidth(1);
    Content:AddChild(ContentButtonFacade);
    AuraFramesConfig:EnhanceContainer(ContentButtonFacade);

    AuraFramesConfig:ContentButtonFacade(ContentButtonFacade, ContainerInstance.LBFGroup);
  
  end
 ]]--
end
