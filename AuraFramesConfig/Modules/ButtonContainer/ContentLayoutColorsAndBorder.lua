local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local Module = AuraFramesConfig:GetModule("ButtonContainer");
local AceGUI = LibStub("AceGUI-3.0");

-----------------------------------------------------------------
-- Function ContentLayoutColors
-----------------------------------------------------------------
function Module:ContentLayoutColorsAndBorder(Content, ContainerId)

  local ContainerInstance = AuraFrames.Containers[ContainerId];
  local LayoutConfig = AuraFrames.db.profile.Containers[ContainerId].Layout;

  Content:SetLayout("List");

  Content:AddText("Colors\n", GameFontNormalLarge);

  local ContentColors = AceGUI:Create("SimpleGroup");
  ContentColors:SetRelativeWidth(1);
  Content:AddChild(ContentColors);
  AuraFramesConfig:EnhanceContainer(ContentColors);
  
  AuraFramesConfig:ContentColors(ContentColors, ContainerId);

  Content:AddSpace(3);

  Content:AddText("Border\n", GameFontNormalLarge);
  Content:AddText("The skin border is used for giving colors to auras.\n");

  local ShowBorder = AceGUI:Create("Dropdown");
  ShowBorder:SetList({
    ALWAYS = "Always",
    NEVER = "Never",
    DEBUFF = "Only when it is a debuff",
  });
  ShowBorder:SetLabel("Show border");
  ShowBorder:SetValue(LayoutConfig.ShowBorder);
  ShowBorder:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ShowBorder = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  Content:AddChild(ShowBorder);

end
