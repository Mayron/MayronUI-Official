local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");


-----------------------------------------------------------------
-- Local Function GetProfileList
-----------------------------------------------------------------
local function GetProfileList(db, NoCurrent, Defaults)

  local Profiles = {};

  local CurrentProfile = db:GetCurrentProfile();

  for _, Profile in pairs(db:GetProfiles()) do 
    if not (NoCurrent and Profile == CurrentProfile) then 

      Profiles[Profile] = Profile;

    end 
  end
  
  if Defaults then
  
    local DefaultProfiles = {
      Default = "Default",
      [db.keys.char] = db.keys.char,
      [db.keys.realm] = db.keys.realm,
      [db.keys.class] = UnitClass("player"),
    };
  
    for _, Profile in pairs(DefaultProfiles) do 
      if not (NoCurrent and Profile == CurrentProfile) then 

        Profiles[Profile] = Profile;

      end 
    end
  
  end

  return Profiles;

end

-----------------------------------------------------------------
-- Function ContentProfilesRefresh
-----------------------------------------------------------------
function AuraFramesConfig:ContentProfilesRefresh(Content)

  Content:PauseLayout();
  Content:ReleaseChildren();
  
  local db, Values = AuraFrames.db, nil;

  Content:AddText("Profile Settings\n", GameFontNormalLarge);
  
  Content:AddText("You can change the active database profile, so you can have different settings for every character.\n");
  Content:AddText("Reset the current profile back to its default values, in case your configuration is broken, or you simply want to start over.\n");
  
  Content:AddText("\nCurrent Profile: "..NORMAL_FONT_COLOR_CODE..db:GetCurrentProfile()..FONT_COLOR_CODE_CLOSE.."\n");
  local ButtonReset = AceGUI:Create("Button");
  ButtonReset:SetText("Reset Profile");
  ButtonReset:SetCallback("OnClick", function()
    db:ResetProfile();
    AuraFramesConfig:ContentProfilesRefresh(Content);
  end);
  Content:AddChild(ButtonReset);
  
  Content:AddText("\n\nYou can either create a new profile by entering a name in the editbox, or choose one of the already existing profiles.");
  
  local Group = AceGUI:Create("SimpleGroup");
  Group:SetRelativeWidth(1);
  Group:SetLayout("Flow");
  Content:AddChild(Group);
  
  local EditBoxNew = AceGUI:Create("EditBox");
  EditBoxNew:SetLabel("New");
  EditBoxNew:SetText("");
  EditBoxNew:SetCallback("OnEnterPressed", function(_, _, Value)
    if Value and strlen(Value) ~= 0 then
      db:SetProfile(Value);
    end
    AuraFramesConfig:ContentProfilesRefresh(Content);
  end);
  Group:AddChild(EditBoxNew);
  
  local SelectProfile = AceGUI:Create("Dropdown");
  SelectProfile:SetList(GetProfileList(db, false, true));
  SelectProfile:SetLabel("Existing Profiles");
  SelectProfile:SetValue(db:GetCurrentProfile());
  SelectProfile:SetCallback("OnValueChanged", function(_, _, Value)
    db:SetProfile(Value);
    AuraFramesConfig:ContentProfilesRefresh(Content);
  end);
  Group:AddChild(SelectProfile);
  
  Content:AddText("\nCopy the settings from one existing profile into the currently active profile.");

  Values = GetProfileList(db, true, false);
  local CopyProfile = AceGUI:Create("Dropdown");
  CopyProfile:SetList(Values);
  CopyProfile:SetDisabled(next(Values) == nil);
  CopyProfile:SetLabel("Copy Profiles");
  CopyProfile:SetCallback("OnValueChanged", function(_, _, Value)
    db:CopyProfile(Value);
    AuraFramesConfig:ContentProfilesRefresh(Content);
  end);
  Content:AddChild(CopyProfile);
  
  Content:AddText("\nDelete existing and unused profiles from the database to save space, and cleanup the SavedVariables file.");
  
  Values = GetProfileList(db, true, false);
  local DeleteProfile = AceGUI:Create("Dropdown");
  DeleteProfile:SetList(Values);
  DeleteProfile:SetDisabled(next(Values) == nil);
  DeleteProfile:SetLabel("Delete Profiles");
  DeleteProfile:SetCallback("OnValueChanged", function(_, _, Value)
    AuraFrames:Confirm("Are you sure you want to delete the selected profile?", function(Result)
      if Result == true then
        db:DeleteProfile(Value);
        AuraFramesConfig:ContentProfilesRefresh(Content);
      else
        DeleteProfile:SetValue(nil);
      end
    end);
  end);
  Content:AddChild(DeleteProfile);
  
  Content:AddSpace();
  Content:AddHeader("Dual Spec");
  
  if GetNumSpecGroups() == 1 then
  
    Content:AddText("\nNo dual spec found.");
  
  else
  
    Content:AddText("\nWhen enabled, this feature allow you to select a different profile for each talent spec. The dual profile will be swapped with the current profile each time you switch from a talent spec to the other.\n");

    local DualSpecProfile;
    local EnableDualSpec = AceGUI:Create("CheckBox");
    EnableDualSpec:SetValue(db:IsDualSpecEnabled());
    EnableDualSpec:SetLabel("Enable dual profile");
    EnableDualSpec:SetCallback("OnValueChanged", function(_, _, Value)
      db:SetDualSpecEnabled(Value);
      AuraFramesConfig:ContentProfilesRefresh(Content);
    end);
    Content:AddChild(EnableDualSpec);
    
    Content:AddSpace();
    
    DualSpecProfile = AceGUI:Create("Dropdown");
    DualSpecProfile:SetList(GetProfileList(db, false, false));
    DualSpecProfile:SetValue(db:GetDualSpecProfile());
    DualSpecProfile:SetDisabled(not db:IsDualSpecEnabled());
    DualSpecProfile:SetLabel("Dual profile");
    DualSpecProfile:SetCallback("OnValueChanged", function(_, _, Value)
      db:SetDualSpecProfile(Value);
      AuraFramesConfig:ContentProfilesRefresh(Content);
    end);
    Content:AddChild(DualSpecProfile);
  
  end
  
  Content:AddSpace();
  
  Content:ResumeLayout();
  Content:DoLayout();

end

-----------------------------------------------------------------
-- Function ContentProfiles
-----------------------------------------------------------------
function AuraFramesConfig:ContentProfiles()

  self.Content:SetLayout("Fill");
  
  local Content = AceGUI:Create("ScrollFrame");
  Content:SetLayout("List");
  self:EnhanceContainer(Content);
  self.Content:AddChild(Content);
  
  self:ContentProfilesRefresh(Content);
  
end
