local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");

local SupportedVisibilityOptions = {
  {"InCombat", "In Combat"},
  {"OutOfCombat", "Out Of Combat"},
  {"PrimaryTalents", "Primary Talents"},
  {"SecondaryTalents", "Secondary Talents"},
  {"Mounted", "Mounted"},
  {"Vehicle", "Vehicle"},
  {"Solo", "Solo"},
  {"InInstance", "In Instance"},
  {"NotInInstance", "Not in Instance"},
  {"InParty", "In Party"},
  {"InRaid", "In Raid"},
  {"InBattleground", "In Battleground"},
  {"InArena", "In Arena"},
  {"FocusEqualsTarget", "Focus equals Target"},
  {"InPetBattle", "In Pet Battle"},
  {"OnMouseOver", "On Mouse Over"},
};

local IconNotSet = "Interface\\Addons\\AuraFramesConfig\\Icons\\Checkbox";
local IconEnabled  = "Interface\\Addons\\AuraFramesConfig\\Icons\\Checkbox-Enabled";
local IconDisabled = "Interface\\Addons\\AuraFramesConfig\\Icons\\Checkbox-Disabled";

-----------------------------------------------------------------
-- Function ContentVisibilityRefresh
-----------------------------------------------------------------
function AuraFramesConfig:ContentVisibilityRefresh(Content, ContainerId)

  local VisibilityConfig = AuraFrames.db.profile.Containers[ContainerId].Visibility;
  local LayoutConfig = AuraFrames.db.profile.Containers[ContainerId].Layout;
  local ContainerInstance = AuraFrames.Containers[ContainerId];


  Content:PauseLayout();
  Content:ReleaseChildren();
  
  Content:SetLayout("List");

  Content:AddText("Visibility\n", GameFontNormalLarge);

  local CheckBoxAlwaysVisible = AceGUI:Create("CheckBox");
  CheckBoxAlwaysVisible:SetWidth(300);
  CheckBoxAlwaysVisible:SetLabel("Container is always visible");
  CheckBoxAlwaysVisible:SetValue(VisibilityConfig.AlwaysVisible);
  CheckBoxAlwaysVisible:SetCallback("OnValueChanged", function(_, _, Value)
    VisibilityConfig.AlwaysVisible = Value;
    AuraFrames:CheckVisibility(ContainerInstance, false);
    AuraFramesConfig:ContentVisibilityRefresh(Content, ContainerId);
  end);
  Content:AddChild(CheckBoxAlwaysVisible);
  
  Content:AddSpace();
  
  local GroupVisibility = AceGUI:Create("InlineGroup");
  GroupVisibility:SetTitle("Visibility conditions");
  GroupVisibility:SetRelativeWidth(1);
  GroupVisibility:SetLayout("Flow");
  Content:AddChild(GroupVisibility);
  
  for _, Option in ipairs(SupportedVisibilityOptions) do
  
    local Status = AceGUI:Create("InteractiveLabel");

    if VisibilityConfig.AlwaysVisible then
      Status:SetDisabled(true);
    elseif Option[1] == "InPetBattle" and AuraFrames.db.profile.HideInPetBattle == true then
      Status:SetDisabled(true);
    elseif Option[1] == "OnMouseOver" and LayoutConfig.Clickable ~= true then
      Status:SetDisabled(true);
    end

    if VisibilityConfig.VisibleWhen[Option[1]] == true then
      Status:SetImage(IconEnabled);
    elseif VisibilityConfig.VisibleWhenNot[Option[1]] == true then
      Status:SetImage(IconDisabled);
    else
      Status:SetImage(IconNotSet);
    end
    Status:SetImageSize(24, 24);
    Status:SetWidth(230);
    Status:SetText(Option[2]);
    Status:SetHighlight("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight");
    Status:SetHighlightTexCoord(0, 1, 0.23, 0.77);
    Status:SetCallback("OnClick", function()
      if VisibilityConfig.VisibleWhen[Option[1]] == true then
        VisibilityConfig.VisibleWhen[Option[1]] = nil;
        VisibilityConfig.VisibleWhenNot[Option[1]] = true
        Status:SetImage(IconDisabled);
      elseif VisibilityConfig.VisibleWhenNot[Option[1]] == true then
        VisibilityConfig.VisibleWhen[Option[1]] = nil;
        VisibilityConfig.VisibleWhenNot[Option[1]] = nil
        Status:SetImage(IconNotSet);
      else
        VisibilityConfig.VisibleWhen[Option[1]] = true;
        VisibilityConfig.VisibleWhenNot[Option[1]] = nil
        Status:SetImage(IconEnabled);
      end
      AuraFrames:CheckVisibility(ContainerInstance, false);
    end);
    GroupVisibility:AddChild(Status);

  end
  
  Content:AddSpace();

  local ExplainNotSet = AceGUI:Create("InteractiveLabel");
  ExplainNotSet:SetImage(IconNotSet);
  ExplainNotSet:SetImageSize(24, 24);
  ExplainNotSet:SetWidth(400);
  ExplainNotSet:SetText("Ignore the condition");
  Content:AddChild(ExplainNotSet);

  local ExplainEnabled = AceGUI:Create("InteractiveLabel");
  ExplainEnabled:SetImage(IconEnabled);
  ExplainEnabled:SetImageSize(24, 24);
  ExplainEnabled:SetWidth(400);
  ExplainEnabled:SetText("One or more of these conditions must be met");
  Content:AddChild(ExplainEnabled);

  local ExplainDisabled = AceGUI:Create("InteractiveLabel");
  ExplainDisabled:SetImage(IconDisabled);
  ExplainDisabled:SetImageSize(24, 24);
  ExplainDisabled:SetWidth(400);
  ExplainDisabled:SetText("None of these conditions must be met");
  Content:AddChild(ExplainDisabled);

  Content:AddSpace(2);

  if AuraFrames.db.profile.HideInPetBattle == true then

    Content:AddText("Note: The condition \"In Pet Battle\" is disabled because of the global setting that containers are always hiden in pet battles.\n");

  end

  if LayoutConfig.Clickable ~= true then

    Content:AddText("Note: The condition \"On Mouse Over\" is disabled because receive mouse events is disabled for this container. Enable receive mouse events before using the condition \"On Mouse Over\".\n");

  end

  if not AuraFrames.db.profile.Containers[ContainerId].Animations or not AuraFrames.db.profile.Containers[ContainerId].Animations.ContainerVisibility or AuraFrames.db.profile.Containers[ContainerId].Animations.ContainerVisibility.Enabled ~= true or not AuraFrames.db.profile.Containers[ContainerId].Animations.ContainerVisibility.Animation then

    Content:AddText("Note: Visibility is performed by an animation, make sure that the visibility animation is enabled for this container.\n");

  end
  
  Content:AddSpace();
  
  local ButtonGoToAnimation = AceGUI:Create("Button");
  ButtonGoToAnimation:SetWidth(350);
  ButtonGoToAnimation:SetText("Go to the animation that is used for visibility");
  ButtonGoToAnimation:SetCallback("OnClick", function()
    
    AuraFramesConfig.SelectedAnimationTab = "ContainerVisibility";
    AuraFramesConfig:SelectByPath("Containers", ContainerId, "Animations");
    
  end);
  Content:AddChild(ButtonGoToAnimation);
  
  Content:AddSpace();

  
  Content:ResumeLayout();
  Content:DoLayout();
  
end


-----------------------------------------------------------------
-- Function ContentVisibility
-----------------------------------------------------------------
function AuraFramesConfig:ContentVisibility(ContainerId)

  self.Content:SetLayout("Fill");
  
  local Content = AceGUI:Create("ScrollFrame");
  Content:SetLayout("List");
  self:EnhanceContainer(Content);
  self.Content:AddChild(Content);
  
  self:ContentVisibilityRefresh(Content, ContainerId);

end
