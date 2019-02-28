local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local Module = AuraFramesConfig:GetModule("TimeLineContainer");
local AceGUI = LibStub("AceGUI-3.0");


-----------------------------------------------------------------
-- Function ContentLayoutGeneral
-----------------------------------------------------------------
function Module:ContentLayoutGeneral(Content, ContainerId)

  local LayoutConfig = AuraFrames.db.profile.Containers[ContainerId].Layout;
  local VisibilityConfig = AuraFrames.db.profile.Containers[ContainerId].Visibility;
  local ContainerInstance = AuraFrames.Containers[ContainerId];

  Content:ReleaseChildren();
  
  Content:SetLayout("List");

  Content:AddText("General\n", GameFontNormalLarge);

  Content:AddHeader("Mouse");

  local VisibilityDependency = VisibilityConfig.AlwaysVisible == false and (VisibilityConfig.VisibleWhen.OnMouseOver or VisibilityConfig.VisibleWhenNot.OnMouseOver or false);
  
  local Clickable = AceGUI:Create("CheckBox");
  Clickable:SetLabel("Container receive mouse events");
  Clickable:SetDescription("When the container receive mouse events, you can not click thru it. Receiving mouse events is needed for tooltip, canceling aura's when right clicking them and changing visibility on mouse over.");
  Clickable:SetRelativeWidth(1);
  Clickable:SetDisabled(VisibilityDependency);
  Clickable:SetValue(LayoutConfig.Clickable);
  Clickable:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.Clickable = Value;
    ContainerInstance.RecieveMouseEvents = LayoutConfig.Clickable and ContainerInstance.VisibilityClickable;
    VisibilityConfig.VisibleWhen.OnMouseOver = nil;
    VisibilityConfig.VisibleWhenNot.OnMouseOver = nil;
    ContainerInstance:Update("LAYOUT");
    Content:PauseLayout();
    Content:ReleaseChildren();
    Module:ContentLayoutGeneral(Content, ContainerId);
    Content:ResumeLayout();
    Content:DoLayout();
  end);
  Content:AddChild(Clickable);

  if VisibilityDependency then

    Content:AddText("Receive mouse events can not be disabled because the container visibility is depending on the mouse over events. Remove the container visibility dependency before disabling the mouse events.");

  end

  Content:AddSpace();

  Content:AddHeader("Tooltip");
  
  if LayoutConfig.Clickable ~= true then
  
    Content:AddText("The container must receive mouse events for this functionality.");
  
  else
  
    local ShowTooltip = AceGUI:Create("CheckBox");
    ShowTooltip:SetLabel("Enable Tooltip");
    ShowTooltip:SetDescription("Show aura information in a tooltip when mouse over the aura.");
    ShowTooltip:SetRelativeWidth(1);
    ShowTooltip:SetValue(LayoutConfig.ShowTooltip);
    ShowTooltip:SetCallback("OnValueChanged", function(_, _, Value)
      LayoutConfig.ShowTooltip = Value;
      ContainerInstance:Update("LAYOUT");
      Module:ContentLayoutGeneral(Content, ContainerId);
    end);
    Content:AddChild(ShowTooltip);
    
    Content:AddSpace();
    
    local ContentTooltip = AceGUI:Create("SimpleGroup");
    ContentTooltip:SetRelativeWidth(1);
    ContentTooltip:SetLayout("Flow");
    Content:AddChild(ContentTooltip);
    
    local TooltipShowPrefix = AceGUI:Create("CheckBox");
    TooltipShowPrefix:SetDisabled(not LayoutConfig.ShowTooltip);
    TooltipShowPrefix:SetWidth(260);
    TooltipShowPrefix:SetLabel("Show Prefix");
    TooltipShowPrefix:SetDescription("Put before the extra information the type of information.");
    TooltipShowPrefix:SetValue(LayoutConfig.TooltipShowPrefix);
    TooltipShowPrefix:SetCallback("OnValueChanged", function(_, _, Value)
      LayoutConfig.TooltipShowPrefix = Value;
      ContainerInstance:Update("LAYOUT");
    end);
    ContentTooltip:AddChild(TooltipShowPrefix);
    
    local TooltipShowCaster = AceGUI:Create("CheckBox");
    TooltipShowCaster:SetDisabled(not LayoutConfig.ShowTooltip);
    TooltipShowCaster:SetWidth(260);
    TooltipShowCaster:SetLabel("Show Caster");
    TooltipShowCaster:SetDescription("Show who have casted the aura.");
    TooltipShowCaster:SetValue(LayoutConfig.TooltipShowCaster);
    TooltipShowCaster:SetCallback("OnValueChanged", function(_, _, Value)
      LayoutConfig.TooltipShowCaster = Value;
      ContainerInstance:Update("LAYOUT");
    end);
    ContentTooltip:AddChild(TooltipShowCaster);
    
    local TooltipShowAuraId = AceGUI:Create("CheckBox");
    TooltipShowAuraId:SetDisabled(not LayoutConfig.ShowTooltip);
    TooltipShowAuraId:SetWidth(260);
    TooltipShowAuraId:SetLabel("Show Aura Id");
    TooltipShowAuraId:SetDescription("Show the internal ID of the casted spell or item.");
    TooltipShowAuraId:SetValue(LayoutConfig.TooltipShowAuraId);
    TooltipShowAuraId:SetCallback("OnValueChanged", function(_, _, Value)
      LayoutConfig.TooltipShowAuraId = Value;
      ContainerInstance:Update("LAYOUT");
    end);
    ContentTooltip:AddChild(TooltipShowAuraId);
    
    local TooltipShowClassification = AceGUI:Create("CheckBox");
    TooltipShowClassification:SetDisabled(not LayoutConfig.ShowTooltip);
    TooltipShowClassification:SetWidth(260);
    TooltipShowClassification:SetLabel("Show Classification");
    TooltipShowClassification:SetDescription("Show the aura classification the tooltip (magic, curse, poison or none).");
    TooltipShowClassification:SetValue(LayoutConfig.TooltipShowClassification);
    TooltipShowClassification:SetCallback("OnValueChanged", function(_, _, Value)
      LayoutConfig.TooltipShowClassification = Value;
      ContainerInstance:Update("LAYOUT");
    end);
    ContentTooltip:AddChild(TooltipShowClassification);
  
    local TooltipShowUnitName = AceGUI:Create("CheckBox");
    TooltipShowUnitName:SetDisabled(not LayoutConfig.ShowTooltip);
    TooltipShowUnitName:SetWidth(260);
    TooltipShowUnitName:SetLabel("Show Unit Name");
    TooltipShowUnitName:SetDescription("Show the name of the unit who got the aura.");
    TooltipShowUnitName:SetValue(LayoutConfig.TooltipShowUnitName);
    TooltipShowUnitName:SetCallback("OnValueChanged", function(_, _, Value)
      LayoutConfig.TooltipShowUnitName = Value;
      ContainerInstance:Update("LAYOUT");
    end);
    ContentTooltip:AddChild(TooltipShowUnitName);

  end
  
  Content:AddSpace();

  Content:AddHeader("General Settings");
  
  local SettingsGroup = AceGUI:Create("SimpleGroup");
  SettingsGroup:SetLayout("Flow");
  SettingsGroup:SetRelativeWidth(1);
  AuraFramesConfig:EnhanceContainer(SettingsGroup);
  Content:AddChild(SettingsGroup);
  
  local MaxTime = AceGUI:Create("Slider");
  MaxTime:SetDisabled(LayoutConfig.BarUseAuraTime);
  MaxTime:SetWidth(200);
  MaxTime:SetValue(LayoutConfig.MaxTime);
  MaxTime:SetLabel("Maximune time");
  MaxTime:SetSliderValues(5, 3600, 1);
  MaxTime:SetIsPercent(false);
  MaxTime:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.MaxTime = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  SettingsGroup:AddChild(MaxTime);
  
  SettingsGroup:AddText(" ", nil, 200);
  
  SettingsGroup:AddText("The number of seconds the timeline will contain.", GameFontHighlightSmall, 200);
  SettingsGroup:AddText(" ", nil, 200);
  
  SettingsGroup:AddSpace();

  local DropdownTimeFlow = AceGUI:Create("Dropdown");
  DropdownTimeFlow:SetWidth(200);
  DropdownTimeFlow:SetList({
    NONE = "No compression",
    POW  = "Compression using pow",
  });
  DropdownTimeFlow:SetLabel("Time flow");
  DropdownTimeFlow:SetValue(LayoutConfig.TimeFlow);
  DropdownTimeFlow:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TimeFlow = Value;
    ContainerInstance:Update("ALL");
    Module:ContentLayoutGeneral(Content, ContainerId);
  end);
  SettingsGroup:AddChild(DropdownTimeFlow);
  
  if LayoutConfig.TimeFlow ~= "NONE" then
  
    local TimeCompression = AceGUI:Create("Slider");
    TimeCompression:SetDisabled(false);
    TimeCompression:SetWidth(200);
    TimeCompression:SetValue(LayoutConfig.TimeCompression);
    TimeCompression:SetLabel("Time Compression");
    TimeCompression:SetSliderValues(0.01, 1, 0.01);
    TimeCompression:SetIsPercent(false);
    TimeCompression:SetCallback("OnValueChanged", function(_, _, Value)
      LayoutConfig.TimeCompression = Value;
      ContainerInstance:Update("ALL");
    end);
    SettingsGroup:AddChild(TimeCompression);
    
  end
  
  SettingsGroup:AddSpace();
  
  local DropdownStyle = AceGUI:Create("Dropdown");
  DropdownStyle:SetWidth(200);
  DropdownStyle:SetList({
    HORIZONTAL = "Horizontal",
    VERTICAL   = "Vertical",
  });
  DropdownStyle:SetLabel("The style of the time line");
  DropdownStyle:SetValue(LayoutConfig.Style);
  DropdownStyle:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.Style = Value;
    ContainerInstance:Update("ALL");
    Module:ContentLayoutGeneral(Content, ContainerId);
  end);
  SettingsGroup:AddChild(DropdownStyle);
  
  local DropdownDirection = AceGUI:Create("Dropdown");
  DropdownDirection:SetWidth(200);
  DropdownDirection:SetList({
    HIGH  = LayoutConfig.Style == "HORIZONTAL" and "From right to left" or "From top to bottom",
    LOW   = LayoutConfig.Style == "HORIZONTAL" and "From left to right" or "From bottom to top",
  });
  DropdownDirection:SetLabel("Time line direction");
  DropdownDirection:SetValue(LayoutConfig.Direction);
  DropdownDirection:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.Direction = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  SettingsGroup:AddChild(DropdownDirection);

  Content:AddSpace();


end
