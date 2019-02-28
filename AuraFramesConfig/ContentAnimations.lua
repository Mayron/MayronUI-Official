local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");

if not AuraFramesConfig.Animations then
  AuraFramesConfig.Animations = {};
end

if not AuraFramesConfig.Animations.AuraNew then
  AuraFramesConfig.Animations.AuraNew = {};
end

if not AuraFramesConfig.Animations.AuraChanging then
  AuraFramesConfig.Animations.AuraChanging = {};
end

if not AuraFramesConfig.Animations.AuraExpiring then
  AuraFramesConfig.Animations.AuraExpiring = {};
end

if not AuraFramesConfig.Animations.ContainerVisibility then
  AuraFramesConfig.Animations.ContainerVisibility = {};
end

AuraFramesConfig.Animations.AuraNew.DisplayName = "New Aura";
AuraFramesConfig.Animations.AuraNew.Description = "An animation can be played when a new aura is added to the container. The animation starts as soon as the new aura is added.";
AuraFramesConfig.Animations.AuraNew.List = AuraFramesConfig.Animations.AuraNew.List or {};

AuraFramesConfig.Animations.AuraChanging.DisplayName = "Changing Aura";
AuraFramesConfig.Animations.AuraChanging.Description = "An animation can be played when an aura is updated or changed. The animation starts as soon as the aura is updated or changed.";
AuraFramesConfig.Animations.AuraChanging.List = AuraFramesConfig.Animations.AuraChanging.List or {};

AuraFramesConfig.Animations.AuraExpiring.DisplayName = "Expiring Aura";
AuraFramesConfig.Animations.AuraExpiring.Description = "An animation can be played when an aura is going to expire. The animation is done on the moment that the aura is expired.";
AuraFramesConfig.Animations.AuraExpiring.List = AuraFramesConfig.Animations.AuraExpiring.List or {};

AuraFramesConfig.Animations.ContainerVisibility.DisplayName = "Container Visibility";
AuraFramesConfig.Animations.ContainerVisibility.Description = "An animation can be played when the container is going invisible or inactive.";
AuraFramesConfig.Animations.ContainerVisibility.List = AuraFramesConfig.Animations.ContainerVisibility.List or {};

-----------------------------------------------------------------
-- Function AuraNew:Flash
-----------------------------------------------------------------
AuraFramesConfig.Animations.AuraNew.List.Flash = {DisplayName = "Flash"};

function AuraFramesConfig.Animations.AuraNew.List.Flash:SetDefaults(Properties)

  Properties.Times = 3;
  Properties.Duration = 1.0;

end

function AuraFramesConfig.Animations.AuraNew.List.Flash:Content(Content, ContainerInstance, Config)

  Content:AddSpace();

  local SliderTimes = AceGUI:Create("Slider");
  SliderTimes:SetLabel("Number of flashes");
  SliderTimes:SetSliderValues(1, 10, 1);
  SliderTimes:SetValue(Config.Times);
  SliderTimes:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Times = Value;
    ContainerInstance:UpdateAnimationConfig("AuraNew");
  end);
  Content:AddChild(SliderTimes);
  
  local SliderDuration = AceGUI:Create("Slider");
  SliderDuration:SetLabel("Speed per flash in seconds");
  SliderDuration:SetSliderValues(0.1, 2.0, 0.1);
  SliderDuration:SetValue(Config.Duration);
  SliderDuration:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Duration = Value;
    ContainerInstance:UpdateAnimationConfig("AuraNew");
  end);
  Content:AddChild(SliderDuration);

end


-----------------------------------------------------------------
-- Function AuraNew:FadeIn
-----------------------------------------------------------------
AuraFramesConfig.Animations.AuraNew.List.FadeIn = {DisplayName = "Fade In"};

function AuraFramesConfig.Animations.AuraNew.List.FadeIn:SetDefaults(Properties)

  Properties.Duration = 0.5;

end

function AuraFramesConfig.Animations.AuraNew.List.FadeIn:Content(Content, ContainerInstance, Config)

  Content:AddSpace();
  
  local SliderDuration = AceGUI:Create("Slider");
  SliderDuration:SetLabel("Fade in duration");
  SliderDuration:SetSliderValues(0.1, 3.0, 0.1);
  SliderDuration:SetValue(Config.Duration);
  SliderDuration:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Duration = Value;
    ContainerInstance:UpdateAnimationConfig("AuraNew");
  end);
  Content:AddChild(SliderDuration);

end


-----------------------------------------------------------------
-- Function AuraNew:JumpIn
-----------------------------------------------------------------
AuraFramesConfig.Animations.AuraNew.List.JumpIn = {DisplayName = "Jump In"};

function AuraFramesConfig.Animations.AuraNew.List.JumpIn:SetDefaults(Properties)

  Properties.Duration = 0.5;
  Properties.StartScale = 3.0;
  Properties.StartAlpha = 0.0;
  Properties.StartX = 0;
  Properties.StartY = 300;

end

function AuraFramesConfig.Animations.AuraNew.List.JumpIn:Content(Content, ContainerInstance, Config)

  Content:AddSpace();
  
  local SliderDuration = AceGUI:Create("Slider");
  SliderDuration:SetLabel("Jump in duration");
  SliderDuration:SetSliderValues(0.1, 3.0, 0.1);
  SliderDuration:SetValue(Config.Duration);
  SliderDuration:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Duration = Value;
    ContainerInstance:UpdateAnimationConfig("AuraNew");
  end);
  Content:AddChild(SliderDuration);

  Content:AddText();

  local SliderStartScale = AceGUI:Create("Slider");
  SliderStartScale:SetLabel("Start scale");
  SliderStartScale:SetSliderValues(0.1, 5.0, 0.1);
  SliderStartScale:SetValue(Config.StartScale);
  SliderStartScale:SetCallback("OnValueChanged", function(_, _, Value)
    Config.StartScale = Value;
    ContainerInstance:UpdateAnimationConfig("AuraNew");
  end);
  Content:AddChild(SliderStartScale);

  local SliderStartAlpha = AceGUI:Create("Slider");
  SliderStartAlpha:SetLabel("Start alpha");
  SliderStartAlpha:SetSliderValues(0.0, 1.0, 0.1);
  SliderStartAlpha:SetValue(Config.StartAlpha);
  SliderStartAlpha:SetCallback("OnValueChanged", function(_, _, Value)
    Config.StartAlpha = Value;
    ContainerInstance:UpdateAnimationConfig("AuraNew");
  end);
  Content:AddChild(SliderStartAlpha);

  local SliderStartX = AceGUI:Create("Slider");
  SliderStartX:SetLabel("Start X offset");
  SliderStartX:SetSliderValues(-1500, 1500, 1);
  SliderStartX:SetValue(Config.StartX);
  SliderStartX:SetCallback("OnValueChanged", function(_, _, Value)
    Config.StartX = Value;
    ContainerInstance:UpdateAnimationConfig();
  end);
  Content:AddChild(SliderStartX);

  local SliderStartY = AceGUI:Create("Slider");
  SliderStartY:SetLabel("Start X offset");
  SliderStartY:SetSliderValues(-1500, 1500, 1);
  SliderStartY:SetValue(Config.StartY);
  SliderStartY:SetCallback("OnValueChanged", function(_, _, Value)
    Config.StartY = Value;
    ContainerInstance:UpdateAnimationConfig("AuraNew");
  end);
  Content:AddChild(SliderStartY);

end


-----------------------------------------------------------------
-- Function AuraChanging:Flash
-----------------------------------------------------------------
AuraFramesConfig.Animations.AuraChanging.List.Flash = {DisplayName = "Flash"};

function AuraFramesConfig.Animations.AuraChanging.List.Flash:SetDefaults(Properties)

  Properties.Times = 3;
  Properties.Duration = 1.0;

end

function AuraFramesConfig.Animations.AuraChanging.List.Flash:Content(Content, ContainerInstance, Config)

  Content:AddSpace();

  local SliderTimes = AceGUI:Create("Slider");
  SliderTimes:SetLabel("Number of flashes");
  SliderTimes:SetSliderValues(1, 10, 1);
  SliderTimes:SetValue(Config.Times);
  SliderTimes:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Times = Value;
    ContainerInstance:UpdateAnimationConfig("AuraChanging");
  end);
  Content:AddChild(SliderTimes);
  
  local SliderDuration = AceGUI:Create("Slider");
  SliderDuration:SetLabel("Speed per flash in seconds");
  SliderDuration:SetSliderValues(0.1, 2.0, 0.1);
  SliderDuration:SetValue(Config.Duration);
  SliderDuration:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Duration = Value;
    ContainerInstance:UpdateAnimationConfig("AuraChanging");
  end);
  Content:AddChild(SliderDuration);

end


-----------------------------------------------------------------
-- Function AuraChanging:Popup
-----------------------------------------------------------------
AuraFramesConfig.Animations.AuraChanging.List.Popup = {DisplayName = "Popup"};

function AuraFramesConfig.Animations.AuraChanging.List.Popup:SetDefaults(Properties)

  Properties.Duration = 0.3;
  Properties.Scale = 2.5;

end

function AuraFramesConfig.Animations.AuraChanging.List.Popup:Content(Content, ContainerInstance, Config)

  Content:AddSpace();
  
  local SliderDuration = AceGUI:Create("Slider");
  SliderDuration:SetLabel("Duration of the popup");
  SliderDuration:SetSliderValues(0.1, 3.0, 0.1);
  SliderDuration:SetValue(Config.Duration);
  SliderDuration:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Duration = Value;
    ContainerInstance:UpdateAnimationConfig("AuraChanging");
  end);
  Content:AddChild(SliderDuration);

  local SliderScale = AceGUI:Create("Slider");
  SliderScale:SetLabel("Popup scale");
  SliderScale:SetSliderValues(1, 5, 0.1);
  SliderScale:SetValue(Config.Scale);
  SliderScale:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Scale = Value;
    ContainerInstance:UpdateAnimationConfig("AuraChanging");
  end);
  Content:AddChild(SliderScale);

end


-----------------------------------------------------------------
-- Function AuraExpiring:Flash
-----------------------------------------------------------------
AuraFramesConfig.Animations.AuraExpiring.List.Flash = {DisplayName = "Flash"};

function AuraFramesConfig.Animations.AuraExpiring.List.Flash:SetDefaults(Properties)

  Properties.Times = 3;
  Properties.Duration = 1.0;

end

function AuraFramesConfig.Animations.AuraExpiring.List.Flash:Content(Content, ContainerInstance, Config)

  Content:AddSpace();

  local SliderTimes = AceGUI:Create("Slider");
  SliderTimes:SetLabel("Number of flashes");
  SliderTimes:SetSliderValues(1, 10, 1);
  SliderTimes:SetValue(Config.Times);
  SliderTimes:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Times = Value;
    ContainerInstance:UpdateAnimationConfig("AuraExpiring");
  end);
  Content:AddChild(SliderTimes);
  
  local SliderDuration = AceGUI:Create("Slider");
  SliderDuration:SetLabel("Speed per flash in seconds");
  SliderDuration:SetSliderValues(0.1, 2.0, 0.1);
  SliderDuration:SetValue(Config.Duration);
  SliderDuration:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Duration = Value;
    ContainerInstance:UpdateAnimationConfig("AuraExpiring");
  end);
  Content:AddChild(SliderDuration);

end


-----------------------------------------------------------------
-- Function AuraExpiring:FadeOut
-----------------------------------------------------------------
AuraFramesConfig.Animations.AuraExpiring.List.FadeOut = {DisplayName = "Fade Out"};

function AuraFramesConfig.Animations.AuraExpiring.List.FadeOut:SetDefaults(Properties)

  Properties.Duration = 0.5;

end

function AuraFramesConfig.Animations.AuraExpiring.List.FadeOut:Content(Content, ContainerInstance, Config)

  Content:AddSpace();
  
  local SliderDuration = AceGUI:Create("Slider");
  SliderDuration:SetLabel("Fade out duration");
  SliderDuration:SetSliderValues(0.1, 3.0, 0.1);
  SliderDuration:SetValue(Config.Duration);
  SliderDuration:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Duration = Value;
    ContainerInstance:UpdateAnimationConfig("AuraExpiring");
  end);
  Content:AddChild(SliderDuration);

end


-----------------------------------------------------------------
-- Function AuraExpiring:Explode
-----------------------------------------------------------------
AuraFramesConfig.Animations.AuraExpiring.List.Explode = {DisplayName = "Explode"};

function AuraFramesConfig.Animations.AuraExpiring.List.Explode:SetDefaults(Properties)

  Properties.Scale = 3.5;
  Properties.Duration = 0.5;

end

function AuraFramesConfig.Animations.AuraExpiring.List.Explode:Content(Content, ContainerInstance, Config)

  Content:AddSpace();

  local SliderScale = AceGUI:Create("Slider");
  SliderScale:SetLabel("Scale of the explosion");
  SliderScale:SetSliderValues(1.5, 5.0, 0.1);
  SliderScale:SetIsPercent(true);
  SliderScale:SetValue(Config.Scale);
  SliderScale:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Scale = Value;
    ContainerInstance:UpdateAnimationConfig("AuraExpiring");
  end);
  Content:AddChild(SliderScale);
  
  local SliderDuration = AceGUI:Create("Slider");
  SliderDuration:SetLabel("Duration of the animation");
  SliderDuration:SetSliderValues(0.1, 2.0, 0.1);
  SliderDuration:SetValue(Config.Duration);
  SliderDuration:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Duration = Value;
    ContainerInstance:UpdateAnimationConfig("AuraExpiring");
  end);
  Content:AddChild(SliderDuration);

end


-----------------------------------------------------------------
-- Function AuraExpiring:JumpOut
-----------------------------------------------------------------
AuraFramesConfig.Animations.AuraExpiring.List.JumpOut = {DisplayName = "Jump Out"};

function AuraFramesConfig.Animations.AuraExpiring.List.JumpOut:SetDefaults(Properties)

  Properties.Duration = 0.5;
  Properties.EndScale = 3.0;
  Properties.EndAlpha = 0.0;
  Properties.EndX = 0;
  Properties.EndY = -300;

end

function AuraFramesConfig.Animations.AuraExpiring.List.JumpOut:Content(Content, ContainerInstance, Config)

  Content:AddSpace();
  
  local SliderDuration = AceGUI:Create("Slider");
  SliderDuration:SetLabel("Jump out duration");
  SliderDuration:SetSliderValues(0.1, 3.0, 0.1);
  SliderDuration:SetValue(Config.Duration);
  SliderDuration:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Duration = Value;
    ContainerInstance:UpdateAnimationConfig("AuraExpiring");
  end);
  Content:AddChild(SliderDuration);

  Content:AddText();

  local SliderEndScale = AceGUI:Create("Slider");
  SliderEndScale:SetLabel("End scale");
  SliderEndScale:SetSliderValues(0.1, 5.0, 0.1);
  SliderEndScale:SetValue(Config.EndScale);
  SliderEndScale:SetCallback("OnValueChanged", function(_, _, Value)
    Config.EndScale = Value;
    ContainerInstance:UpdateAnimationConfig("AuraExpiring");
  end);
  Content:AddChild(SliderEndScale);

  local SliderEndAlpha = AceGUI:Create("Slider");
  SliderEndAlpha:SetLabel("End alpha");
  SliderEndAlpha:SetSliderValues(0.0, 1.0, 0.1);
  SliderEndAlpha:SetValue(Config.EndAlpha);
  SliderEndAlpha:SetCallback("OnValueChanged", function(_, _, Value)
    Config.EndAlpha = Value;
    ContainerInstance:UpdateAnimationConfig("AuraExpiring");
  end);
  Content:AddChild(SliderEndAlpha);

  local SliderEndX = AceGUI:Create("Slider");
  SliderEndX:SetLabel("End X offset");
  SliderEndX:SetSliderValues(-1500, 1500, 1);
  SliderEndX:SetValue(Config.EndX);
  SliderEndX:SetCallback("OnValueChanged", function(_, _, Value)
    Config.EndX = Value;
    ContainerInstance:UpdateAnimationConfig("AuraExpiring");
  end);
  Content:AddChild(SliderEndX);

  local SliderEndY = AceGUI:Create("Slider");
  SliderEndY:SetLabel("End X offset");
  SliderEndY:SetSliderValues(-1500, 1500, 1);
  SliderEndY:SetValue(Config.EndY);
  SliderEndY:SetCallback("OnValueChanged", function(_, _, Value)
    Config.EndY = Value;
    ContainerInstance:UpdateAnimationConfig("AuraExpiring");
  end);
  Content:AddChild(SliderEndY);

end



-----------------------------------------------------------------
-- Function ContainerVisibility:Jump
-----------------------------------------------------------------
AuraFramesConfig.Animations.ContainerVisibility.List.Jump = {DisplayName = "Jump"};

function AuraFramesConfig.Animations.ContainerVisibility.List.Jump:SetDefaults(Properties)

  Properties.Duration = 0.5;
  Properties.InvisibleScale = 0.5;
  Properties.InvisibleAlpha = 0.0;
  Properties.InvisibleX = 0;
  Properties.InvisibleY = -400;
  Properties.MouseEventsWhenInactive = false;

end

function AuraFramesConfig.Animations.ContainerVisibility.List.Jump:Content(Content, ContainerInstance, Config)

  Content:AddSpace();
  
  local SliderDuration = AceGUI:Create("Slider");
  SliderDuration:SetLabel("Animation duration");
  SliderDuration:SetSliderValues(0.1, 3.0, 0.1);
  SliderDuration:SetValue(Config.Duration);
  SliderDuration:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Duration = Value;
    ContainerInstance:UpdateAnimationConfig("ContainerVisibility");
  end);
  Content:AddChild(SliderDuration);

  Content:AddText();

  local SliderInvisibleScale = AceGUI:Create("Slider");
  SliderInvisibleScale:SetLabel("Invisible scale");
  SliderInvisibleScale:SetSliderValues(0.1, 5.0, 0.1);
  SliderInvisibleScale:SetValue(Config.InvisibleScale);
  SliderInvisibleScale:SetCallback("OnValueChanged", function(_, _, Value)
    Config.InvisibleScale = Value;
    ContainerInstance:UpdateAnimationConfig("ContainerVisibility");
  end);
  Content:AddChild(SliderInvisibleScale);

  local SliderInvisibleAlpha = AceGUI:Create("Slider");
  SliderInvisibleAlpha:SetLabel("Invisible alpha");
  SliderInvisibleAlpha:SetSliderValues(0.0, 1.0, 0.1);
  SliderInvisibleAlpha:SetValue(Config.InvisibleAlpha);
  SliderInvisibleAlpha:SetCallback("OnValueChanged", function(_, _, Value)
    Config.InvisibleAlpha = Value;
    ContainerInstance:UpdateAnimationConfig("ContainerVisibility");
  end);
  Content:AddChild(SliderInvisibleAlpha);

  local SliderInvisibleX = AceGUI:Create("Slider");
  SliderInvisibleX:SetLabel("Invisible X offset");
  SliderInvisibleX:SetSliderValues(-1500, 1500, 1);
  SliderInvisibleX:SetValue(Config.InvisibleX);
  SliderInvisibleX:SetCallback("OnValueChanged", function(_, _, Value)
    Config.InvisibleX = Value;
    ContainerInstance:UpdateAnimationConfig("ContainerVisibility");
  end);
  Content:AddChild(SliderInvisibleX);

  local SliderInvisibleY = AceGUI:Create("Slider");
  SliderInvisibleY:SetLabel("Invisible X offset");
  SliderInvisibleY:SetSliderValues(-1500, 1500, 1);
  SliderInvisibleY:SetValue(Config.InvisibleY);
  SliderInvisibleY:SetCallback("OnValueChanged", function(_, _, Value)
    Config.InvisibleY = Value;
    ContainerInstance:UpdateAnimationConfig("ContainerVisibility");
  end);
  Content:AddChild(SliderInvisibleY);
  
  local CheckBoxMouseEventsWhenInactive = AceGUI:Create("CheckBox");
  CheckBoxMouseEventsWhenInactive:SetWidth(400);
  CheckBoxMouseEventsWhenInactive:SetLabel("Receive mouse events when invisible or inactive");
  CheckBoxMouseEventsWhenInactive:SetValue(Config.MouseEventsWhenInactive);
  CheckBoxMouseEventsWhenInactive:SetCallback("OnValueChanged", function(_, _, Value)
    Config.MouseEventsWhenInactive = Value;
    ContainerInstance:UpdateAnimationConfig("ContainerVisibility");
  end);
  Content:AddChild(CheckBoxMouseEventsWhenInactive);

end


-----------------------------------------------------------------
-- Function ContainerVisibility:Fade
-----------------------------------------------------------------
AuraFramesConfig.Animations.ContainerVisibility.List.Fade = {DisplayName = "Fade"};

function AuraFramesConfig.Animations.ContainerVisibility.List.Fade:SetDefaults(Properties)

  Properties.Duration = 0.5;
  Properties.InvisibleAlpha = 0.0;
  Properties.MouseEventsWhenInactive = false;

end

function AuraFramesConfig.Animations.ContainerVisibility.List.Fade:Content(Content, ContainerInstance, Config)

  Content:AddSpace();
  
  local SliderDuration = AceGUI:Create("Slider");
  SliderDuration:SetLabel("Animation duration");
  SliderDuration:SetSliderValues(0.1, 3.0, 0.1);
  SliderDuration:SetValue(Config.Duration);
  SliderDuration:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Duration = Value;
    ContainerInstance:UpdateAnimationConfig("ContainerVisibility");
  end);
  Content:AddChild(SliderDuration);

  local SliderInvisibleAlpha = AceGUI:Create("Slider");
  SliderInvisibleAlpha:SetLabel("Invisible alpha");
  SliderInvisibleAlpha:SetSliderValues(0.0, 1.0, 0.1);
  SliderInvisibleAlpha:SetValue(Config.InvisibleAlpha);
  SliderInvisibleAlpha:SetCallback("OnValueChanged", function(_, _, Value)
    Config.InvisibleAlpha = Value;
    ContainerInstance:UpdateAnimationConfig("ContainerVisibility");
  end);
  Content:AddChild(SliderInvisibleAlpha);
  
  local CheckBoxMouseEventsWhenInactive = AceGUI:Create("CheckBox");
  CheckBoxMouseEventsWhenInactive:SetWidth(400);
  CheckBoxMouseEventsWhenInactive:SetLabel("Receive mouse events when invisible or inactive");
  CheckBoxMouseEventsWhenInactive:SetValue(Config.MouseEventsWhenInactive);
  CheckBoxMouseEventsWhenInactive:SetCallback("OnValueChanged", function(_, _, Value)
    Config.MouseEventsWhenInactive = Value;
    ContainerInstance:UpdateAnimationConfig("ContainerVisibility");
  end);
  Content:AddChild(CheckBoxMouseEventsWhenInactive);

end


-----------------------------------------------------------------
-- Function ContentAnimationsRefresh
-----------------------------------------------------------------
function AuraFramesConfig:ContentAnimationsRefresh(Content, ContainerId, AnimationType)

  local AnimationConfig = AuraFrames.db.profile.Containers[ContainerId].Animations;
  local ContainerInstance = AuraFrames.Containers[ContainerId];

  Content:PauseLayout();
  Content:ReleaseChildren();

  Content:SetLayout("List");
  
  Content:AddText(AuraFramesConfig.Animations[AnimationType].DisplayName, GameFontNormalLarge);
  Content:AddSpace(2);
  Content:AddText(AuraFramesConfig.Animations[AnimationType].Description);
  Content:AddSpace(2);

  local Enabled = AnimationConfig[AnimationType] and AnimationConfig[AnimationType].Enabled;

  if next(AuraFrames.Animations[AnimationType]) == nil then

    Enabled = false;

    Content:AddText("No supported animation found for this type.");

  else

    local CheckBoxEnabled = AceGUI:Create("CheckBox");
    CheckBoxEnabled:SetWidth(400);
    CheckBoxEnabled:SetLabel("Use Animation for: "..AuraFramesConfig.Animations[AnimationType].DisplayName);
    CheckBoxEnabled:SetValue(Enabled);
    CheckBoxEnabled:SetCallback("OnValueChanged", function(_, _, Value)
      
      if Value == true then

        if not AnimationConfig[AnimationType] then
          AnimationConfig[AnimationType] = {Enabled = true};
        else
          AnimationConfig[AnimationType].Enabled = true;
        end

      elseif AnimationConfig[AnimationType] then

        AnimationConfig[AnimationType].Enabled = false;

      end

      ContainerInstance:UpdateAnimationConfig(AnimationType);

      self:ContentAnimationsRefresh(Content, ContainerId, AnimationType);
    
    end);
    Content:AddChild(CheckBoxEnabled);
    Content:AddSpace();

  end

  if Enabled then

    local AnimationList = {};

    for Key, _ in pairs(AuraFrames.Animations[AnimationType]) do
      AnimationList[Key] = AuraFramesConfig.Animations[AnimationType].List[Key].DisplayName;
    end

    local SelectedAnimation = AnimationConfig[AnimationType] and AnimationConfig[AnimationType].Animation or nil;

    local DropdownAnimation = AceGUI:Create("Dropdown");
    DropdownAnimation:SetWidth(200);
    DropdownAnimation:SetList(AnimationList);
    DropdownAnimation:SetLabel("Animation Type");
    DropdownAnimation:SetValue(SelectedAnimation);
    DropdownAnimation:SetCallback("OnValueChanged", function(_, _, Value)

      AnimationConfig[AnimationType] = {Enabled = true, Animation = Value};

      if AuraFramesConfig.Animations[AnimationType].List[Value].SetDefaults then
        AuraFramesConfig.Animations[AnimationType].List[Value]:SetDefaults(AnimationConfig[AnimationType]);
      end

      ContainerInstance:UpdateAnimationConfig(AnimationType);

      self:ContentAnimationsRefresh(Content, ContainerId, AnimationType);

    end);
    Content:AddChild(DropdownAnimation);

    Content:AddSpace(2);

    if SelectedAnimation and AuraFramesConfig.Animations[AnimationType].List[SelectedAnimation] and AuraFramesConfig.Animations[AnimationType].List[SelectedAnimation].Content then
      
      local Group = AceGUI:Create("InlineGroup");
      Group:SetTitle("Animation configuration");
      Group:SetRelativeWidth(1);
      Group:SetLayout("Flow");
      self:EnhanceContainer(Group);
      Content:AddChild(Group);

      AuraFramesConfig.Animations[AnimationType].List[SelectedAnimation]:Content(Group, ContainerInstance, AnimationConfig[AnimationType]);

    elseif SelectedAnimation then

      Content:AddText("No configuration options available for this animation.");

    end

    Content:AddSpace(2);

  end

  Content:ResumeLayout();
  Content:DoLayout();

end


-----------------------------------------------------------------
-- Function ContentAnimations
-----------------------------------------------------------------
function AuraFramesConfig:ContentAnimations(ContainerId)

  local ContainerInstance = AuraFrames.Containers[ContainerId];
  local SupportedAnimationTypes = ContainerInstance.Module:GetSupportedAnimationTypes();

  local Tabs = {};
  
  local SelectedAnimationTabFound = false;

  for _, Type in pairs(SupportedAnimationTypes) do

    if AuraFramesConfig.Animations[Type] and AuraFramesConfig.Animations[Type] then

      tinsert(Tabs, {value = Type, text = AuraFramesConfig.Animations[Type].DisplayName});
      
      if AuraFramesConfig.SelectedAnimationTab == Type then
        SelectedAnimationTabFound = true;
      end

    end

  end
  
  if not SelectedAnimationTabFound then
    AuraFramesConfig.SelectedAnimationTab = nil;
  end

  self.Content:SetLayout("Fill");

  local Tab = AceGUI:Create("TabGroup");
  Tab:SetRelativeWidth(1);
  Tab:SetTabs(Tabs);
  Tab:SetLayout("Fill");
  AuraFramesConfig.Content:AddChild(Tab);

  local Content = AceGUI:Create("ScrollFrame");
  Content:SetLayout("List");
  self:EnhanceContainer(Content);
  Tab:AddChild(Content);
  self.ScrollFrame = Content;


  Tab:SetCallback("OnGroupSelected", function(_, _, Value)

    AuraFramesConfig:ContentAnimationsRefresh(Content, ContainerId, Value);
    AuraFramesConfig.SelectedAnimationTab = Value;

  end);

  AuraFramesConfig.SelectedAnimationTab = AuraFramesConfig.SelectedAnimationTab or (Tabs[1] and Tabs[1].value or nil);
  Tab:SelectTab(AuraFramesConfig.SelectedAnimationTab);

end
