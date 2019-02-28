local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");


-----------------------------------------------------------------
-- Function ContentGeneralSettings
-----------------------------------------------------------------
function AuraFramesConfig:ContentGeneralSettings()

  self.Content:SetLayout("Fill");
  
  local Content = AceGUI:Create("ScrollFrame");
  Content:SetLayout("List");
  self:EnhanceContainer(Content);
  self.Content:AddChild(Content);

  Content:PauseLayout();
  Content:ReleaseChildren();
  
  Content:AddText("General Settings\n", GameFontNormalLarge);
  Content:AddSpace(2);


  Content:AddHeader("Blizzard Buff Frames");
  Content:AddText("Disable and hide the default frames that are used by Blizzard to display buff/debuff aura's. When you enable the Blizzard frames again you need to reload/relog to show them!\n");
  local HideBlizzard = AceGUI:Create("CheckBox");
  HideBlizzard:SetLabel("Hide Blizzard aura frames");
  HideBlizzard:SetValue(AuraFrames.db.profile.HideBlizzardAuraFrames);
  HideBlizzard:SetCallback("OnValueChanged", function(_, _, Value)
    AuraFrames.db.profile.HideBlizzardAuraFrames = Value;
    if Value == true then
      AuraFrames:CheckBlizzardAuraFrames();
    end
  end);
  Content:AddChild(HideBlizzard);
  Content:AddSpace(2);
  

  Content:AddHeader("Boss Mods");
  Content:AddText("Aura Frames can use different Boss Mods to display aura's. When using Aura Frames for showing Boss Mods information, then there is not always the need anymore to have the Boss Mods displaying there own bars.\n\nHiding Boss Mods Bars will only work when there is an active container that is using the Boss Mods source! At this moment, Deadly Boss Mods and Deus Vox Encounters are supported\n");
  local HideBossModsBars = AceGUI:Create("CheckBox");
  HideBossModsBars:SetLabel("Hide Boss Mods Bars");
  HideBossModsBars:SetValue(AuraFrames.db.profile.HideBossModsBars);
  HideBossModsBars:SetCallback("OnValueChanged", function(_, _, Value)
    AuraFrames.db.profile.HideBossModsBars = Value;
    LibStub("LibAura-1.0"):GetModule("BossMods-1.0"):SetBossModBarsVisibility(not Value);
  end);
  Content:AddChild(HideBossModsBars);
  Content:AddSpace(2);
  

  Content:AddHeader("Pet Battles");
  Content:AddText("Aura Frames can hide all aura containers automaticly upon entering pet battles. This will overrule the In Pet Battle option of the visibility options for containers. For this to work, the animation \"Container Visibility\" must be enabled on all containers.\n");
  local HideInPetBattle = AceGUI:Create("CheckBox");
  HideInPetBattle:SetLabel("Hide in pet battle");
  HideInPetBattle:SetValue(AuraFrames.db.profile.HideInPetBattle);
  HideInPetBattle:SetCallback("OnValueChanged", function(_, _, Value)
    AuraFrames.db.profile.HideInPetBattle = Value;
    for _, Container in pairs(AuraFrames.Containers) do
      AuraFrames:CheckVisibility(Container);
    end
  end);
  Content:AddChild(HideInPetBattle);
  Content:AddSpace(2);


  Content:AddHeader("Bad Masque skins");
  Content:AddText("Aura Frames try to detect bad Masque skins that can result in black buttons. You can disable those warning messages here.\n");
  local DisableMasqueSkinWarnings = AceGUI:Create("CheckBox");
  DisableMasqueSkinWarnings:SetLabel("Disable warnings");
  DisableMasqueSkinWarnings:SetValue(AuraFrames.db.profile.DisableMasqueSkinWarnings);
  DisableMasqueSkinWarnings:SetCallback("OnValueChanged", function(_, _, Value)
    AuraFrames.db.profile.DisableMasqueSkinWarnings = Value;
  end);
  Content:AddChild(DisableMasqueSkinWarnings);
  Content:AddSpace(2);

  Content:ResumeLayout();
  Content:DoLayout();
  self.Content:DoLayout();

  Content:AddHeader("Timer precision");
  Content:AddText("Aura Frames allow you to use 1/10th of second in different containers. 1/10th of a second is mostly needed when the time left is getting under the 10 seconds. You can override here when you see the 1/10th of a second.\n");

  local TimeExtRequirement;

  local EnableTimeExtOverrule = AceGUI:Create("CheckBox");
  EnableTimeExtOverrule:SetWidth(300);
  EnableTimeExtOverrule:SetLabel("Override 1/10th of a second");
  EnableTimeExtOverrule:SetValue(AuraFrames.db.profile.EnableTimeExtOverrule);
  EnableTimeExtOverrule:SetCallback("OnValueChanged", function(_, _, Value)
    AuraFrames.db.profile.EnableTimeExtOverrule = Value;
    TimeExtRequirement:SetDisabled(not Value);
  end);
  Content:AddChild(EnableTimeExtOverrule);

  Content:AddSpace();

  TimeExtRequirement = AceGUI:Create("Slider");
  TimeExtRequirement:SetDisabled(not AuraFrames.db.profile.EnableTimeExtOverrule);
  TimeExtRequirement:SetLabel("Show 1/10th of a second under");
  TimeExtRequirement:SetSliderValues(1, 60, 1);
  TimeExtRequirement:SetValue(AuraFrames.db.profile.TimeExtRequirement);
  TimeExtRequirement:SetCallback("OnValueChanged", function(_, _, Value)
    AuraFrames.db.profile.TimeExtRequirement = Value;
  end);
  Content:AddChild(TimeExtRequirement);

  Content:AddSpace(2);

  Content:ResumeLayout();
  Content:DoLayout();
  self.Content:DoLayout();

end
