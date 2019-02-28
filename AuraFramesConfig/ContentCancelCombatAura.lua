local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AceGUI = LibStub("AceGUI-3.0");
local LSM = LibStub("LibSharedMedia-3.0");

local SelectedTab;

local Tabs = {};

-----------------------------------------------------------------
-- Function Tabs:Status
-----------------------------------------------------------------
function Tabs:Status(Content)
  -- self = AuraFramesConfig

  Content:PauseLayout();
  Content:ReleaseChildren();

  local Config = AuraFrames.db.profile.CancelCombatAura;

  Content:AddText("Cancel Combat Aura\n", GameFontNormalLarge);

  Content:AddText("Blizzard prevents addons to cancel buffs in combat. They provided the addons an interface that is still allowed to cancel buffs in combat. The provided interface is extremely limited in functionality and control. Aura Frames don't use that interface for that reason. To be still able to cancel buffs in combat Aura Frames provide a separate buff window that is using the interface provided by Blizzard.");
  Content:AddSpace();
  Content:AddText("If enabled, the separate buff window can be shown by using a hotkey. Only cancelable will be shown.");
  Content:AddSpace(2);

  local Enabled = AceGUI:Create("CheckBox");
  Enabled:SetWidth(400);
  Enabled:SetLabel("Enable Cancel Combat Aura");
  Enabled:SetValue(Config.Enabled);
  Enabled:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Enabled = Value;
    AuraFrames.CancelCombatAura:Update();
    AuraFramesConfig:ContentCancelCombatAura();
  end);
  Content:AddChild(Enabled);
  Content:AddSpace(2);

  if Config.Enabled then

    Content:AddText("See the other tabs for more configuration.");
    Content:AddSpace();
  end

  Content:AddHeader("Keybinding");
  Content:AddSpace();
  Content:AddText("Set the keybinding that will show the Cancel Combat Aura window. This will override the global keybind if there is any, but it will not overwrite it.");
  Content:AddSpace();
  local Keybinding = AceGUI:Create("Keybinding");
  Keybinding:SetDisabled(not Config.Enabled);
  if Config.Keybinding then
    Keybinding:SetKey(Config.Keybinding);
  end
  Keybinding:SetCallback("OnKeyChanged", function(_, _, Value)
    Config.Keybinding = Value and Value ~= "" and Value or nil;
    AuraFrames.CancelCombatAura:Update();
  end);
  Content:AddChild(Keybinding);

  Content:AddSpace();

  local ToggleMode = AceGUI:Create("CheckBox");
  ToggleMode:SetDisabled(not Config.Enabled);
  ToggleMode:SetWidth(400);
  ToggleMode:SetLabel("Use toggle mode");
  ToggleMode:SetDescription("The Cancel Combat Aura window can be shown if only the key is pressed, or the window can be toggle between key presses.");
  ToggleMode:SetValue(Config.ToggleMode);
  ToggleMode:SetCallback("OnValueChanged", function(_, _, Value)
    Config.ToggleMode = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  Content:AddChild(ToggleMode);

  Content:AddSpace(2);

  Content:ResumeLayout();
  Content:DoLayout();

end

-----------------------------------------------------------------
-- Function Tabs:General
-----------------------------------------------------------------
function Tabs:General(Content)
  -- self = AuraFramesConfig

  Content:PauseLayout();
  Content:ReleaseChildren();

  local Config = AuraFrames.db.profile.CancelCombatAura;

  Content:AddText("Cancel Combat Aura - General\n", GameFontNormalLarge);

  Content:AddHeader("Miscellaneous");

  local IncludeWeaponEnchantments = AceGUI:Create("CheckBox");
  IncludeWeaponEnchantments:SetWidth(400);
  IncludeWeaponEnchantments:SetLabel("Include Weapon Enchantments");
  IncludeWeaponEnchantments:SetDescription("Include weapon enchantments in the buff list. A reload is required for a correct working when changed because of a bug in Blizzard's SecureAuraHeaderTemplate code.");
  IncludeWeaponEnchantments:SetValue(Config.IncludeWeaponEnchantments);
  IncludeWeaponEnchantments:SetCallback("OnValueChanged", function(_, _, Value)
    Config.IncludeWeaponEnchantments = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  Content:AddChild(IncludeWeaponEnchantments);
  Content:AddSpace(1);

  local ShowTooltip = AceGUI:Create("CheckBox");
  ShowTooltip:SetWidth(400);
  ShowTooltip:SetLabel("Show Tooltip on mouse over");
  ShowTooltip:SetDescription("Show a tooltip when you mouse over the buffs");
  ShowTooltip:SetValue(Config.ShowTooltip);
  ShowTooltip:SetCallback("OnValueChanged", function(_, _, Value)
    Config.ShowTooltip = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  Content:AddChild(ShowTooltip);
  Content:AddSpace(1);

  local OnlyRightButton = AceGUI:Create("CheckBox");
  OnlyRightButton:SetWidth(400);
  OnlyRightButton:SetLabel("Only right mouse button");
  OnlyRightButton:SetDescription("Use only the right mouse button to cancel buffs");
  OnlyRightButton:SetValue(Config.ShowTooltip);
  OnlyRightButton:SetCallback("OnValueChanged", function(_, _, Value)
    Config.OnlyRightButton = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  Content:AddChild(OnlyRightButton);
  Content:AddSpace(2);

  Content:AddHeader("Sorting");

  local OrderGroup = AceGUI:Create("SimpleGroup");
  OrderGroup:SetLayout("Flow");
  OrderGroup:SetRelativeWidth(1);
  Content:AddChild(OrderGroup);

  local Order = AceGUI:Create("Dropdown");
  Order:SetList({
    NAME  = "Buff name",
    TIME  = "Time remaining",
    INDEX = "Buff index",
  });
  Order:SetLabel("Sorting buffs on");
  Order:SetValue(Config.Order);
  Order:SetCallback("OnValueChanged", function(_, _, Value)
    Config.Order = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  OrderGroup:AddChild(Order);

  local OrderReverse = AceGUI:Create("CheckBox");
  OrderReverse:SetLabel("Reverse the sorting order");
  OrderReverse:SetValue(Config.OrderReverse);
  OrderReverse:SetCallback("OnValueChanged", function(_, _, Value)
    Config.OrderReverse = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  OrderGroup:AddChild(OrderReverse);
  Content:AddText("Weapon enchantments will be displayed always first.");
  Content:AddSpace(2);

  Content:AddHeader("Size and spacing");

  Content:AddText("The number of aura columns and rows the container will display.");
  local SizeGroup = AceGUI:Create("SimpleGroup");
  SizeGroup:SetLayout("Flow");
  SizeGroup:SetRelativeWidth(1);
  Content:AddChild(SizeGroup);
  
  local HorizontalSize = AceGUI:Create("Slider");
  HorizontalSize:SetWidth(250);
  HorizontalSize:SetValue(Config.HorizontalSize);
  HorizontalSize:SetLabel("Horizontal Size");
  HorizontalSize:SetSliderValues(1, 50, 1);
  HorizontalSize:SetIsPercent(false);
  HorizontalSize:SetCallback("OnValueChanged", function(_, _, Value)
    Config.HorizontalSize = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  SizeGroup:AddChild(HorizontalSize);
  
  local VerticalSize = AceGUI:Create("Slider");
  VerticalSize:SetWidth(250);
  VerticalSize:SetValue(Config.VerticalSize);
  VerticalSize:SetLabel("Vertical Size");
  VerticalSize:SetSliderValues(1, 50, 1);
  VerticalSize:SetIsPercent(false);
  VerticalSize:SetCallback("OnValueChanged", function(_, _, Value)
    Config.VerticalSize = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  SizeGroup:AddChild(VerticalSize);
  Content:AddSpace(2);


  Content:AddText("The space between the aura's horizontal and vertical.");
  local SpacingGroup = AceGUI:Create("SimpleGroup");
  SpacingGroup:SetLayout("Flow");
  SpacingGroup:SetRelativeWidth(1);
  Content:AddChild(SpacingGroup);
  
  local HorizontalSpace = AceGUI:Create("Slider");
  HorizontalSpace:SetWidth(250);
  HorizontalSpace:SetValue(Config.SpaceX);
  HorizontalSpace:SetLabel("Horizontal Space");
  HorizontalSpace:SetSliderValues(-50, 50, 0.1);
  HorizontalSpace:SetIsPercent(false);
  HorizontalSpace:SetCallback("OnValueChanged", function(_, _, Value)
    Config.SpaceX = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  SpacingGroup:AddChild(HorizontalSpace);
  
  local VerticalSpace = AceGUI:Create("Slider");
  VerticalSpace:SetWidth(250);
  VerticalSpace:SetValue(Config.SpaceY);
  VerticalSpace:SetLabel("Vertical Space");
  VerticalSpace:SetSliderValues(-50, 50, 0.1);
  VerticalSpace:SetIsPercent(false);
  VerticalSpace:SetCallback("OnValueChanged", function(_, _, Value)
    Config.SpaceY = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  SpacingGroup:AddChild(VerticalSpace);

  Content:AddSpace(2);


  Content:ResumeLayout();
  Content:DoLayout();

end

-----------------------------------------------------------------
-- Function Tabs:DurationAndCount
-----------------------------------------------------------------
function Tabs:DurationAndCount(Content)
  -- self = AuraFramesConfig

  Content:PauseLayout();
  Content:ReleaseChildren();

  local Config = AuraFrames.db.profile.CancelCombatAura;

  Content:AddText("Cancel Combat Aura - Duration And Count\n", GameFontNormalLarge);

  Content:AddHeader("Duration");
  
  local ShowDuration = AceGUI:Create("CheckBox");
  ShowDuration:SetLabel("Show duration");
  ShowDuration:SetDescription("Show the time left on an aura.");
  ShowDuration:SetRelativeWidth(1);
  ShowDuration:SetValue(Config.ShowDuration);
  ShowDuration:SetCallback("OnValueChanged", function(_, _, Value)
    Config.ShowDuration = Value;
    AuraFrames.CancelCombatAura:Update();
    Tabs:DurationAndCount(Content)
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
  DurationLayout:SetDisabled(not Config.ShowDuration);
  DurationLayout:SetValue(Config.DurationLayout);
  DurationLayout:SetCallback("OnValueChanged", function(_, _, Value)
    Config.DurationLayout = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  DurationGroup:AddChild(DurationLayout);

  local DurationAlignment = AceGUI:Create("Dropdown");
  DurationAlignment:SetList({
    CENTER = "Center",
    RIGHT  = "Right",
    LEFT   = "Left",
  });
  DurationAlignment:SetLabel("Alignment");
  DurationAlignment:SetDisabled(not Config.ShowDuration);
  DurationAlignment:SetValue(Config.DurationAlignment);
  DurationAlignment:SetCallback("OnValueChanged", function(_, _, Value)
    Config.DurationAlignment = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  DurationGroup:AddChild(DurationAlignment);
  
  local DurationFont = AceGUI:Create("LSM30_Font");
  DurationFont:SetList(LSM:HashTable("font"));
  DurationFont:SetLabel("Font");
  DurationFont:SetDisabled(not Config.ShowDuration);
  DurationFont:SetValue(Config.DurationFont);
  DurationFont:SetCallback("OnValueChanged", function(_, _, Value)
    Config.DurationFont = Value;
    AuraFrames.CancelCombatAura:Update();
    DurationFont:SetValue(Value);
  end);
  DurationGroup:AddChild(DurationFont);
  
  local DurationSize = AceGUI:Create("Slider");
  DurationSize:SetValue(Config.DurationSize);
  DurationSize:SetLabel("Font Size");
  DurationSize:SetDisabled(not Config.ShowDuration);
  DurationSize:SetSliderValues(6, 30, 0.1);
  DurationSize:SetCallback("OnValueChanged", function(_, _, Value)
    Config.DurationSize = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  DurationGroup:AddChild(DurationSize);
  
  local DurationPosX = AceGUI:Create("Slider");
  DurationPosX:SetValue(Config.DurationPosX);
  DurationPosX:SetLabel("Position X");
  DurationPosX:SetDisabled(not Config.ShowDuration);
  DurationPosX:SetSliderValues(-50, 50, 0.1);
  DurationPosX:SetCallback("OnValueChanged", function(_, _, Value)
    Config.DurationPosX = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  DurationGroup:AddChild(DurationPosX);
  
  local DurationPosY = AceGUI:Create("Slider");
  DurationPosY:SetValue(Config.DurationPosY);
  DurationPosY:SetLabel("Position Y");
  DurationPosY:SetDisabled(not Config.ShowDuration);
  DurationPosY:SetSliderValues(-50, 50, 0.1);
  DurationPosY:SetCallback("OnValueChanged", function(_, _, Value)
    Config.DurationPosY = Value;
    AuraFrames.CancelCombatAura:Update();
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
  DurationOutline:SetValue(Config.DurationOutline);
  DurationOutline:SetDisabled(not Config.ShowDuration);
  DurationOutline:SetCallback("OnValueChanged", function(_, _, Value)
    Config.DurationOutline = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  DurationGroup:AddChild(DurationOutline);
  
  local DurationMonochrome = AceGUI:Create("CheckBox");
  DurationMonochrome:SetWidth(150);
  DurationMonochrome:SetLabel("Monochrome");
  DurationMonochrome:SetValue(Config.DurationMonochrome);
  DurationMonochrome:SetDisabled(not Config.ShowDuration);
  DurationMonochrome:SetCallback("OnValueChanged", function(_, _, Value)
    Config.DurationMonochrome = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  DurationGroup:AddChild(DurationMonochrome);
  
  local DurationColor = AceGUI:Create("ColorPicker");
  DurationColor:SetWidth(150);
  DurationColor:SetLabel("Color");
  DurationColor:SetDisabled(not Config.ShowDuration);
  DurationColor:SetHasAlpha(true);
  DurationColor:SetColor(unpack(Config.DurationColor));
  DurationColor:SetCallback("OnValueChanged", function(_, _, ...)
    Config.DurationColor = {...};
    AuraFrames.CancelCombatAura:Update();
  end);
  DurationGroup:AddChild(DurationColor);

  Content:AddSpace(2);
  Content:AddHeader("Count");
  
  local ShowCount = AceGUI:Create("CheckBox");
  ShowCount:SetLabel("Show count");
  ShowCount:SetDescription("Show the number of stacks of an aura.");
  ShowCount:SetRelativeWidth(1);
  ShowCount:SetValue(Config.ShowCount);
  ShowCount:SetCallback("OnValueChanged", function(_, _, Value)
    Config.ShowCount = Value;
    AuraFrames.CancelCombatAura:Update();
    Tabs:DurationAndCount(Content)
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
  CountAlignment:SetDisabled(not Config.ShowCount);
  CountAlignment:SetValue(Config.CountAlignment);
  CountAlignment:SetCallback("OnValueChanged", function(_, _, Value)
    Config.CountAlignment = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  Content:AddChild(CountAlignment);

  local CountGroup = AceGUI:Create("SimpleGroup");
  CountGroup:SetLayout("Flow");
  CountGroup:SetRelativeWidth(1);
  Content:AddChild(CountGroup);
  
  local CountFont = AceGUI:Create("LSM30_Font");
  CountFont:SetList(LSM:HashTable("font"));
  CountFont:SetLabel("Font");
  CountFont:SetDisabled(not Config.ShowCount);
  CountFont:SetValue(Config.CountFont);
  CountFont:SetCallback("OnValueChanged", function(_, _, Value)
    Config.CountFont = Value;
    AuraFrames.CancelCombatAura:Update();
    CountFont:SetValue(Value);
  end);
  CountGroup:AddChild(CountFont);
  
  local CountSize = AceGUI:Create("Slider");
  CountSize:SetValue(Config.CountSize);
  CountSize:SetLabel("Font Size");
  CountSize:SetDisabled(not Config.ShowCount);
  CountSize:SetSliderValues(6, 30, 0.1);
  CountSize:SetCallback("OnValueChanged", function(_, _, Value)
    Config.CountSize = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  CountGroup:AddChild(CountSize);
  
  local CountPosX = AceGUI:Create("Slider");
  CountPosX:SetValue(Config.CountPosX);
  CountPosX:SetLabel("Position X");
  CountPosX:SetDisabled(not Config.ShowCount);
  CountPosX:SetSliderValues(-50, 50, 0.1);
  CountPosX:SetCallback("OnValueChanged", function(_, _, Value)
    Config.CountPosX = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  CountGroup:AddChild(CountPosX);
  
  local CountPosY = AceGUI:Create("Slider");
  CountPosY:SetValue(Config.CountPosY);
  CountPosY:SetLabel("Position Y");
  CountPosY:SetDisabled(not Config.ShowCount);
  CountPosY:SetSliderValues(-50, 50, 0.1);
  CountPosY:SetCallback("OnValueChanged", function(_, _, Value)
    Config.CountPosY = Value;
    AuraFrames.CancelCombatAura:Update();
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
  CountOutline:SetValue(Config.CountOutline);
  CountOutline:SetDisabled(not Config.ShowCount);
  CountOutline:SetCallback("OnValueChanged", function(_, _, Value)
    Config.CountOutline = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  CountGroup:AddChild(CountOutline);
  
  local CountMonochrome = AceGUI:Create("CheckBox");
  CountMonochrome:SetWidth(150);
  CountMonochrome:SetLabel("Monochrome");
  CountMonochrome:SetValue(Config.CountMonochrome);
  CountMonochrome:SetDisabled(not Config.ShowCount);
  CountMonochrome:SetCallback("OnValueChanged", function(_, _, Value)
    Config.CountMonochrome = Value;
    AuraFrames.CancelCombatAura:Update();
  end);
  CountGroup:AddChild(CountMonochrome);
  
  local CountColor = AceGUI:Create("ColorPicker");
  CountColor:SetWidth(150);
  CountColor:SetLabel("Color");
  CountColor:SetDisabled(not Config.ShowCount);
  CountColor:SetHasAlpha(true);
  CountColor:SetColor(unpack(Config.CountColor));
  CountColor:SetCallback("OnValueChanged", function(_, _, ...)
    Config.CountColor = {...};
    AuraFrames.CancelCombatAura:Update();
  end);
  CountGroup:AddChild(CountColor);
  
  Content:AddSpace(2);

  Content:ResumeLayout();
  Content:DoLayout();

end


-----------------------------------------------------------------
-- Function ContentCancelCombatAura
-----------------------------------------------------------------
function AuraFramesConfig:ContentCancelCombatAura()

  self.Content:PauseLayout();
  self.Content:ReleaseChildren();

  local Config = AuraFrames.db.profile.CancelCombatAura;

  local ConfigContent;

  self.Content:SetLayout("Fill");

  local Tab = AceGUI:Create("TabGroup");
  Tab:SetRelativeWidth(1);
  if Config.Enabled then
    Tab:SetTabs({
      {
        value = "Status",
        text = "Status",
      },
      {
        value = "General",
        text = "General",
      },
      {
        value = "DurationAndCount",
        text = "Duration And Count",
      },
    });
  else
    Tab:SetTabs({
      {
        value = "Status",
        text = "Status",
      },
    });
    SelectedTab = "Status";
  end
  Tab:SetCallback("OnGroupSelected", function(_, _, Value)
    
    SelectedTab = Value;
    
    if Tabs[Value] then
    
      Tabs[Value](self, ConfigContent);
    
    end

  end);
  self.Content:AddChild(Tab);

  Tab:SetLayout("Fill");
  
  ConfigContent = AceGUI:Create("ScrollFrame");
  ConfigContent:SetLayout("List");
  AuraFramesConfig:EnhanceContainer(ConfigContent);
  Tab:AddChild(ConfigContent);
  AuraFramesConfig.ScrollFrame = ConfigContent;

  -- Select last tab otherwise if first tab.
  Tab:SelectTab(SelectedTab or "Status");

  self.Content:ResumeLayout();
  self.Content:DoLayout();
 
end
