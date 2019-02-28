local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local Module = AuraFramesConfig:GetModule("ButtonContainer");
local AceGUI = LibStub("AceGUI-3.0");
local LSM = LibStub("LibSharedMedia-3.0");


-----------------------------------------------------------------
-- Function ContentLayoutDurationAndCount
-----------------------------------------------------------------
function Module:ContentLayoutDurationAndCount(Content, ContainerId)

  local LayoutConfig = AuraFrames.db.profile.Containers[ContainerId].Layout;
  local ContainerInstance = AuraFrames.Containers[ContainerId];

  Content:ReleaseChildren();

  Content:SetLayout("List");

  Content:AddText("Duration and Count\n", GameFontNormalLarge);

  Content:AddHeader("Duration");
  
  local ShowDuration = AceGUI:Create("CheckBox");
  ShowDuration:SetLabel("Show duration");
  ShowDuration:SetDescription("Show the time left on an aura.");
  ShowDuration:SetRelativeWidth(1);
  ShowDuration:SetValue(LayoutConfig.ShowDuration);
  ShowDuration:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ShowDuration = Value;
    ContainerInstance:Update("LAYOUT");
    Module:ContentLayoutDurationAndCount(Content, ContainerId);
  end);
  Content:AddChild(ShowDuration);
  
  Content:AddSpace();

  local DurationGroup = AceGUI:Create("SimpleGroup");
  DurationGroup:SetLayout("Flow");
  DurationGroup:SetRelativeWidth(1);
  Content:AddChild(DurationGroup);
  
  local DurationLayout = AceGUI:Create("Dropdown");
  DurationLayout:SetList({
    ABBREVSPACE   = "10 m",
    ABBREV        = "10m",
    SEPCOL        = "10:15",
    SEPDOT        = "10.15",
    SEPCOLEXT     = "10:15.9",
    SEPDOTEXT     = "10.15.9",
    NONE          = "615",
    NONEEXT       = "615.9",
  });
  DurationLayout:SetLabel("Time layout");
  DurationLayout:SetDisabled(not LayoutConfig.ShowDuration);
  DurationLayout:SetValue(LayoutConfig.DurationLayout);
  DurationLayout:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.DurationLayout = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  DurationGroup:AddChild(DurationLayout);

  local DurationAlignment = AceGUI:Create("Dropdown");
  DurationAlignment:SetList({
    CENTER = "Center",
    RIGHT  = "Right",
    LEFT   = "Left",
  });
  DurationAlignment:SetLabel("Alignment");
  DurationAlignment:SetDisabled(not LayoutConfig.ShowDuration);
  DurationAlignment:SetValue(LayoutConfig.DurationAlignment);
  DurationAlignment:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.DurationAlignment = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  DurationGroup:AddChild(DurationAlignment);
  
  local DurationFont = AceGUI:Create("LSM30_Font");
  DurationFont:SetList(LSM:HashTable("font"));
  DurationFont:SetLabel("Font");
  DurationFont:SetDisabled(not LayoutConfig.ShowDuration);
  DurationFont:SetValue(LayoutConfig.DurationFont);
  DurationFont:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.DurationFont = Value;
    ContainerInstance:Update("LAYOUT");
    DurationFont:SetValue(Value);
  end);
  DurationGroup:AddChild(DurationFont);
  
  local DurationSize = AceGUI:Create("Slider");
  DurationSize:SetValue(LayoutConfig.DurationSize);
  DurationSize:SetLabel("Font Size");
  DurationSize:SetDisabled(not LayoutConfig.ShowDuration);
  DurationSize:SetSliderValues(6, 30, 0.1);
  DurationSize:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.DurationSize = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  DurationGroup:AddChild(DurationSize);
  
  local DurationPosX = AceGUI:Create("Slider");
  DurationPosX:SetValue(LayoutConfig.DurationPosX);
  DurationPosX:SetLabel("Position X");
  DurationPosX:SetDisabled(not LayoutConfig.ShowDuration);
  DurationPosX:SetSliderValues(-50, 50, 0.1);
  DurationPosX:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.DurationPosX = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  DurationGroup:AddChild(DurationPosX);
  
  local DurationPosY = AceGUI:Create("Slider");
  DurationPosY:SetValue(LayoutConfig.DurationPosY);
  DurationPosY:SetLabel("Position Y");
  DurationPosY:SetDisabled(not LayoutConfig.ShowDuration);
  DurationPosY:SetSliderValues(-50, 50, 0.1);
  DurationPosY:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.DurationPosY = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  DurationGroup:AddChild(DurationPosY);
  
  local DurationOutline = AceGUI:Create("Dropdown");
  DurationOutline:SetWidth(150);
  DurationOutline:SetLabel("Outline");
  DurationOutline:SetList({
    NONE = "None",
    OUTLINE = "Outline",
    THICKOUTLINE = "Thick Outline",
  });
  DurationOutline:SetValue(LayoutConfig.DurationOutline);
  DurationOutline:SetDisabled(not LayoutConfig.ShowDuration);
  DurationOutline:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.DurationOutline = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  DurationGroup:AddChild(DurationOutline);
  
  local DurationMonochrome = AceGUI:Create("CheckBox");
  DurationMonochrome:SetWidth(150);
  DurationMonochrome:SetLabel("Monochrome");
  DurationMonochrome:SetValue(LayoutConfig.DurationMonochrome);
  DurationMonochrome:SetDisabled(not LayoutConfig.ShowDuration);
  DurationMonochrome:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.DurationMonochrome = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  DurationGroup:AddChild(DurationMonochrome);
  
  local DurationColor = AceGUI:Create("ColorPicker");
  DurationColor:SetWidth(150);
  DurationColor:SetLabel("Color");
  DurationColor:SetDisabled(not LayoutConfig.ShowDuration);
  DurationColor:SetHasAlpha(true);
  DurationColor:SetColor(unpack(LayoutConfig.DurationColor));
  DurationColor:SetCallback("OnValueChanged", function(_, _, ...)
    LayoutConfig.DurationColor = {...};
    ContainerInstance:Update("LAYOUT");
  end);
  DurationGroup:AddChild(DurationColor);
  
  Content:AddSpace(2);
  Content:AddHeader("Cooldown Animation");
  
  local CooldownGroup = AceGUI:Create("SimpleGroup");
  CooldownGroup:SetLayout("Flow");
  CooldownGroup:SetRelativeWidth(1);
  Content:AddChild(CooldownGroup);
  
  local ShowCooldown = AceGUI:Create("CheckBox");
  ShowCooldown:SetLabel("Show a cooldown");
  ShowCooldown:SetDescription("Show a cooldown animation on top of the button");
  ShowCooldown:SetWidth(260);
  ShowCooldown:SetValue(LayoutConfig.ShowCooldown);
  ShowCooldown:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ShowCooldown = Value;
    ContainerInstance:Update("LAYOUT");
    Module:ContentLayoutDurationAndCount(Content, ContainerId);
  end);
  CooldownGroup:AddChild(ShowCooldown);
  
  local CooldownDisableOmniCC = AceGUI:Create("CheckBox");
  CooldownDisableOmniCC:SetLabel("Disable OmniCC support");
  CooldownDisableOmniCC:SetDescription("This will prevent OmniCC to manage the animation. Changing this setting will only effect new animations!");
  CooldownDisableOmniCC:SetWidth(260);
  CooldownDisableOmniCC:SetDisabled(not LayoutConfig.ShowCooldown);
  CooldownDisableOmniCC:SetValue(LayoutConfig.CooldownDisableOmniCC);
  CooldownDisableOmniCC:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.CooldownDisableOmniCC = Value;
    ContainerInstance:Update("LAYOUT");
    Module:ContentLayoutDurationAndCount(Content, ContainerId);
  end);
  CooldownGroup:AddChild(CooldownDisableOmniCC);
  
  local CooldownDrawEdge = AceGUI:Create("CheckBox");
  CooldownDrawEdge:SetLabel("Draw Edge");
  CooldownDrawEdge:SetDescription("Sets whether a bright line should be drawn on the moving edge of the cooldown animation.");
  CooldownDrawEdge:SetWidth(260);
  CooldownDrawEdge:SetDisabled(not LayoutConfig.ShowCooldown);
  CooldownDrawEdge:SetValue(LayoutConfig.CooldownDrawEdge);
  CooldownDrawEdge:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.CooldownDrawEdge = Value;
    ContainerInstance:Update("ALL");
    Module:ContentLayoutDurationAndCount(Content, ContainerId);
  end);
  CooldownGroup:AddChild(CooldownDrawEdge);
  
  local CooldownReverse = AceGUI:Create("CheckBox");
  CooldownReverse:SetLabel("Reverse");
  CooldownReverse:SetDescription("Sets whether to invert the bright and dark portions of the cooldown animation.");
  CooldownReverse:SetWidth(260);
  CooldownReverse:SetDisabled(not LayoutConfig.ShowCooldown);
  CooldownReverse:SetValue(LayoutConfig.CooldownReverse);
  CooldownReverse:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.CooldownReverse = Value;
    ContainerInstance:Update("LAYOUT");
    Module:ContentLayoutDurationAndCount(Content, ContainerId);
  end);
  CooldownGroup:AddChild(CooldownReverse);
  
  Content:AddSpace(2);
  Content:AddHeader("Count");
  
  local ShowCount = AceGUI:Create("CheckBox");
  ShowCount:SetLabel("Show count");
  ShowCount:SetDescription("Show the number of stacks of an aura.");
  ShowCount:SetRelativeWidth(1);
  ShowCount:SetValue(LayoutConfig.ShowCount);
  ShowCount:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ShowCount = Value;
    ContainerInstance:Update("LAYOUT");
    Module:ContentLayoutDurationAndCount(Content, ContainerId);
  end);
  Content:AddChild(ShowCount);
  
  Content:AddSpace();
  
  local CountAlignment = AceGUI:Create("Dropdown");
  CountAlignment:SetList({
    CENTER = "Center",
    RIGHT  = "Right",
    LEFT   = "Left",
  });
  CountAlignment:SetLabel("Alignment");
  CountAlignment:SetDisabled(not LayoutConfig.ShowCount);
  CountAlignment:SetValue(LayoutConfig.CountAlignment);
  CountAlignment:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.CountAlignment = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  Content:AddChild(CountAlignment);

  local CountGroup = AceGUI:Create("SimpleGroup");
  CountGroup:SetLayout("Flow");
  CountGroup:SetRelativeWidth(1);
  Content:AddChild(CountGroup);
  
  local CountFont = AceGUI:Create("LSM30_Font");
  CountFont:SetList(LSM:HashTable("font"));
  CountFont:SetLabel("Font");
  CountFont:SetDisabled(not LayoutConfig.ShowCount);
  CountFont:SetValue(LayoutConfig.CountFont);
  CountFont:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.CountFont = Value;
    ContainerInstance:Update("LAYOUT");
    CountFont:SetValue(Value);
  end);
  CountGroup:AddChild(CountFont);
  
  local CountSize = AceGUI:Create("Slider");
  CountSize:SetValue(LayoutConfig.CountSize);
  CountSize:SetLabel("Font Size");
  CountSize:SetDisabled(not LayoutConfig.ShowCount);
  CountSize:SetSliderValues(6, 30, 0.1);
  CountSize:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.CountSize = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  CountGroup:AddChild(CountSize);
  
  local CountPosX = AceGUI:Create("Slider");
  CountPosX:SetValue(LayoutConfig.CountPosX);
  CountPosX:SetLabel("Position X");
  CountPosX:SetDisabled(not LayoutConfig.ShowCount);
  CountPosX:SetSliderValues(-50, 50, 0.1);
  CountPosX:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.CountPosX = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  CountGroup:AddChild(CountPosX);
  
  local CountPosY = AceGUI:Create("Slider");
  CountPosY:SetValue(LayoutConfig.CountPosY);
  CountPosY:SetLabel("Position Y");
  CountPosY:SetDisabled(not LayoutConfig.ShowCount);
  CountPosY:SetSliderValues(-50, 50, 0.1);
  CountPosY:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.CountPosY = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  CountGroup:AddChild(CountPosY);
  
  local CountOutline = AceGUI:Create("Dropdown");
  CountOutline:SetWidth(150);
  CountOutline:SetLabel("Outline");
  CountOutline:SetList({
    NONE = "None",
    OUTLINE = "Outline",
    THICKOUTLINE = "Thick Outline",
  });
  CountOutline:SetValue(LayoutConfig.CountOutline);
  CountOutline:SetDisabled(not LayoutConfig.ShowCount);
  CountOutline:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.CountOutline = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  CountGroup:AddChild(CountOutline);
  
  local CountMonochrome = AceGUI:Create("CheckBox");
  CountMonochrome:SetWidth(150);
  CountMonochrome:SetLabel("Monochrome");
  CountMonochrome:SetValue(LayoutConfig.CountMonochrome);
  CountMonochrome:SetDisabled(not LayoutConfig.ShowCount);
  CountMonochrome:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.CountMonochrome = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  CountGroup:AddChild(CountMonochrome);
  
  local CountColor = AceGUI:Create("ColorPicker");
  CountColor:SetWidth(150);
  CountColor:SetLabel("Color");
  CountColor:SetDisabled(not LayoutConfig.ShowCount);
  CountColor:SetHasAlpha(true);
  CountColor:SetColor(unpack(LayoutConfig.CountColor));
  CountColor:SetCallback("OnValueChanged", function(_, _, ...)
    LayoutConfig.CountColor = {...};
    ContainerInstance:Update("LAYOUT");
  end);
  CountGroup:AddChild(CountColor);
  
  Content:AddSpace(2);
  
end
