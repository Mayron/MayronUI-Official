local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local Module = AuraFramesConfig:GetModule("BarContainer");
local AceGUI = LibStub("AceGUI-3.0");
local LSM = LibStub("LibSharedMedia-3.0");


-----------------------------------------------------------------
-- Function ContentLayoutText
-----------------------------------------------------------------
function Module:ContentLayoutText(Content, ContainerId)

  local LayoutConfig = AuraFrames.db.profile.Containers[ContainerId].Layout;
  local ContainerInstance = AuraFrames.Containers[ContainerId];

  Content:ReleaseChildren();

  Content:SetLayout("List");

  Content:AddText("Text and Duration\n", GameFontNormalLarge);

  Content:AddHeader("Options");
  
  local OptionGroup = AceGUI:Create("SimpleGroup");
  OptionGroup:SetLayout("Flow");
  OptionGroup:SetRelativeWidth(1);
  Content:AddChild(OptionGroup);
  
  local ShowDuration = AceGUI:Create("CheckBox");
  ShowDuration:SetWidth(200);
  ShowDuration:SetLabel("Show duration");
  ShowDuration:SetDescription("Show the time left on an aura.");
  ShowDuration:SetValue(LayoutConfig.ShowDuration);
  ShowDuration:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ShowDuration = Value;
    ContainerInstance:Update("LAYOUT");
    Module:ContentLayoutText(Content, ContainerId);
  end);
  OptionGroup:AddChild(ShowDuration);
  
  local DurationPosition = AceGUI:Create("Dropdown");
  DurationPosition:SetWidth(160);
  DurationPosition:SetList({
    RIGHT   = "Right",
    LEFT    = "Left",
    CENTER  = "Center",
  });
  DurationPosition:SetLabel("Duarion position");
  DurationPosition:SetDisabled(not LayoutConfig.ShowDuration);
  DurationPosition:SetValue(LayoutConfig.DurationPosition);
  DurationPosition:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.DurationPosition = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  OptionGroup:AddChild(DurationPosition);

  local DurationLayout = AceGUI:Create("Dropdown");
  DurationLayout:SetWidth(160);
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
  OptionGroup:AddChild(DurationLayout);
  
  local ShowAuraName = AceGUI:Create("CheckBox");
  ShowAuraName:SetWidth(200);
  ShowAuraName:SetLabel("Show aura name");
  ShowAuraName:SetDescription("Show the spell or item name.");
  ShowAuraName:SetValue(LayoutConfig.ShowAuraName);
  ShowAuraName:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ShowAuraName = Value;
    ContainerInstance:Update("LAYOUT");
    Module:ContentLayoutText(Content, ContainerId);
  end);
  OptionGroup:AddChild(ShowAuraName);
  
  local ShowCount = AceGUI:Create("CheckBox");
  ShowCount:SetWidth(160);
  ShowCount:SetLabel("Show count");
  ShowCount:SetDescription("Show the number of stacks of an aura.");
  ShowCount:SetValue(LayoutConfig.ShowCount);
  ShowCount:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ShowCount = Value;
    ContainerInstance:Update("LAYOUT");
    Module:ContentLayoutText(Content, ContainerId);
  end);
  OptionGroup:AddChild(ShowCount);
  
  local TextPosition = AceGUI:Create("Dropdown");
  TextPosition:SetWidth(160);
  TextPosition:SetList({
    RIGHT   = "Right",
    LEFT    = "Left",
    CENTER  = "Center",
  });
  TextPosition:SetLabel("Aura name/Count position");
  TextPosition:SetDisabled(LayoutConfig.ShowAuraName == false and LayoutConfig.ShowCount == false);
  TextPosition:SetValue(LayoutConfig.TextPosition);
  TextPosition:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TextPosition = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  OptionGroup:AddChild(TextPosition);
  
  Content:AddSpace();
  
  Content:AddHeader("Font");
  
  Content:AddText("Change the font and size settings that are used for the aura name, stacks and duration.\n");
  
  local TextGroup = AceGUI:Create("SimpleGroup");
  TextGroup:SetLayout("Flow");
  TextGroup:SetRelativeWidth(1);
  Content:AddChild(TextGroup);
  
  local TextFont = AceGUI:Create("LSM30_Font");
  TextFont:SetWidth(200);
  TextFont:SetList(LSM:HashTable("font"));
  TextFont:SetLabel("Font");
  TextFont:SetValue(LayoutConfig.TextFont);
  TextFont:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TextFont = Value;
    ContainerInstance:Update("LAYOUT");
    TextFont:SetValue(Value);
  end);
  TextGroup:AddChild(TextFont);
  
  local Space1 = AceGUI:Create("Label");
  Space1:SetWidth(50);
  Space1:SetText(" ");
  TextGroup:AddChild(Space1);
  
  local TextSize = AceGUI:Create("Slider");
  TextSize:SetWidth(200);
  TextSize:SetValue(LayoutConfig.TextSize);
  TextSize:SetLabel("Font Size");
  TextSize:SetSliderValues(6, 30, 0.1);
  TextSize:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TextSize = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  TextGroup:AddChild(TextSize);
  
  local TextOutline = AceGUI:Create("Dropdown");
  TextOutline:SetWidth(200);
  TextOutline:SetLabel("Outline");
  TextOutline:SetList({
    NONE = "None",
    OUTLINE = "Outline",
    THICKOUTLINE = "Thick Outline",
  });
  TextOutline:SetValue(LayoutConfig.TextOutline);
  TextOutline:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TextOutline = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  TextGroup:AddChild(TextOutline);
  
  local Space1 = AceGUI:Create("Label");
  Space1:SetWidth(50);
  Space1:SetText(" ");
  TextGroup:AddChild(Space1);
  
  local TextMonochrome = AceGUI:Create("CheckBox");
  TextMonochrome:SetWidth(130);
  TextMonochrome:SetLabel("Monochrome");
  TextMonochrome:SetValue(LayoutConfig.TextMonochrome);
  TextMonochrome:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TextMonochrome = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  TextGroup:AddChild(TextMonochrome);
  
  local TextColor = AceGUI:Create("ColorPicker");
  TextColor:SetWidth(130);
  TextColor:SetLabel("Color");
  TextColor:SetHasAlpha(true);
  TextColor:SetColor(unpack(LayoutConfig.TextColor));
  TextColor:SetCallback("OnValueChanged", function(_, _, ...)
    LayoutConfig.TextColor = {...};
    ContainerInstance:Update("LAYOUT");
  end);
  TextGroup:AddChild(TextColor);
  
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
    Module:ContentLayoutText(Content, ContainerId);
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
    Module:ContentLayoutText(Content, ContainerId);
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
    Module:ContentLayoutText(Content, ContainerId);
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
    Module:ContentLayoutText(Content, ContainerId);
  end);
  CooldownGroup:AddChild(CooldownReverse);
  
  Content:AddSpace(2);
  
end
