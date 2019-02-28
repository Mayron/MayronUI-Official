local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local Module = AuraFramesConfig:GetModule("TimeLineContainer");
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

  Content:AddText("Text\n", GameFontNormalLarge);

  Content:AddHeader("Time");
  
  local ShowText = AceGUI:Create("CheckBox");
  ShowText:SetLabel("Show Time Labels");
  ShowText:SetDescription("Show time labels on the timeline bar");
  ShowText:SetRelativeWidth(1);
  ShowText:SetValue(LayoutConfig.ShowText);
  ShowText:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ShowText = Value;
    ContainerInstance:Update("LAYOUT");
    Module:ContentLayoutText(Content, ContainerId);
  end);
  Content:AddChild(ShowText);
  
  Content:AddSpace();
  
  local TextLayout = AceGUI:Create("Dropdown");
  TextLayout:SetWidth(150);
  TextLayout:SetList({
    ABBREVSPACE   = "10 m",
    ABBREV        = "10m",
    SEPCOL        = "10:15",
    SEPDOT        = "10.15",
    SEPCOLEXT     = "10:15.9",
    SEPDOTEXT     = "10.15.9",
    NONE          = "615",
    NONEEXT       = "615.9",
  });
  TextLayout:SetLabel("Time layout");
  TextLayout:SetDisabled(not LayoutConfig.ShowText);
  TextLayout:SetValue(LayoutConfig.TextLayout);
  TextLayout:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TextLayout = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  Content:AddChild(TextLayout);
  
  local TextGroup = AceGUI:Create("SimpleGroup");
  TextGroup:SetLayout("Flow");
  TextGroup:SetRelativeWidth(1);
  AuraFramesConfig:EnhanceContainer(TextGroup);
  Content:AddChild(TextGroup);
  
  local TextFont = AceGUI:Create("LSM30_Font");
  TextFont:SetList(LSM:HashTable("font"));
  TextFont:SetLabel("Font");
  TextFont:SetDisabled(not LayoutConfig.ShowText);
  TextFont:SetValue(LayoutConfig.TextFont);
  TextFont:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TextFont = Value;
    ContainerInstance:Update("LAYOUT");
    TextFont:SetValue(Value);
  end);
  TextGroup:AddChild(TextFont);
  
  local TextSize = AceGUI:Create("Slider");
  TextSize:SetValue(LayoutConfig.TextSize);
  TextSize:SetLabel("Font Size");
  TextSize:SetDisabled(not LayoutConfig.ShowText);
  TextSize:SetSliderValues(6, 30, 0.1);
  TextSize:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TextSize = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  TextGroup:AddChild(TextSize);
  
  local TextOutline = AceGUI:Create("Dropdown");
  TextOutline:SetWidth(150);
  TextOutline:SetLabel("Outline");
  TextOutline:SetList({
    NONE = "None",
    OUTLINE = "Outline",
    THICKOUTLINE = "Thick Outline",
  });
  TextOutline:SetValue(LayoutConfig.TextOutline);
  TextOutline:SetDisabled(not LayoutConfig.ShowText);
  TextOutline:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TextOutline = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  TextGroup:AddChild(TextOutline);
  
  local TextMonochrome = AceGUI:Create("CheckBox");
  TextMonochrome:SetWidth(150);
  TextMonochrome:SetLabel("Monochrome");
  TextMonochrome:SetValue(LayoutConfig.TextMonochrome);
  TextMonochrome:SetDisabled(not LayoutConfig.ShowText);
  TextMonochrome:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TextMonochrome = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  TextGroup:AddChild(TextMonochrome);
  
  local TextColor = AceGUI:Create("ColorPicker");
  TextColor:SetWidth(150);
  TextColor:SetLabel("Color");
  TextColor:SetDisabled(not LayoutConfig.ShowText);
  TextColor:SetHasAlpha(true);
  TextColor:SetColor(unpack(LayoutConfig.TextColor));
  TextColor:SetCallback("OnValueChanged", function(_, _, ...)
    LayoutConfig.TextColor = {...};
    ContainerInstance:Update("LAYOUT");
  end);
  TextGroup:AddChild(TextColor);
  
  TextGroup:AddSpace();
  
  local TextOffset = AceGUI:Create("Slider");
  TextOffset:SetValue(LayoutConfig.TextOffset);
  TextOffset:SetLabel("Text offset");
  TextOffset:SetDisabled(not LayoutConfig.ShowText);
  TextOffset:SetSliderValues(-100, 100, 1);
  TextOffset:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TextOffset = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  TextGroup:AddChild(TextOffset);

  TextGroup:AddSpace();
  
  local AutoLabels = AceGUI:Create("CheckBox");
  AutoLabels:SetLabel("Auto Labels");
  AutoLabels:SetDisabled(not LayoutConfig.ShowText);
  AutoLabels:SetDescription("Create dynamic labels");
  AutoLabels:SetValue(LayoutConfig.TextLabelsAuto);
  AutoLabels:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.TextLabelsAuto = Value;
    ContainerInstance:Update("LAYOUT");
    Module:ContentLayoutText(Content, ContainerId);
  end);
  TextGroup:AddChild(AutoLabels);

  if LayoutConfig.TextLabelsAuto == false then

    local TextLabels = AceGUI:Create("EditBox");
    TextLabels:SetLabel("Time labels to show");
    TextLabels:SetDisabled(not LayoutConfig.ShowText);
    TextLabels:SetText(table.concat(LayoutConfig.TextLabels, ", "));
    TextLabels:SetCallback("OnEnterPressed", function(_, _, Text)

      wipe(LayoutConfig.TextLabels);
      
      for _, Value in ipairs({string.split(",", Text)}) do
        
        local Time = tonumber(string.trim(Value));
        
        if Value ~= nil then
          table.insert(LayoutConfig.TextLabels, Time);
        end
        
      end
      
      sort(LayoutConfig.TextLabels);
      
      TextLabels:SetText(table.concat(LayoutConfig.TextLabels, ", "));
      
      ContainerInstance:Update("LAYOUT");
    end);
    TextGroup:AddChild(TextLabels);
  
  else
  
    local TextLabelAutoSpace = AceGUI:Create("Slider");
    TextLabelAutoSpace:SetValue(LayoutConfig.TextLabelAutoSpace);
    TextLabelAutoSpace:SetLabel("Minimum space between labels");
    TextLabelAutoSpace:SetDisabled(not LayoutConfig.ShowText);
    TextLabelAutoSpace:SetSliderValues(0, 200, 5);
    TextLabelAutoSpace:SetCallback("OnValueChanged", function(_, _, Value)
      LayoutConfig.TextLabelAutoSpace = Value;
      ContainerInstance:Update("LAYOUT");
    end);
    TextGroup:AddChild(TextLabelAutoSpace);

  end

  
  Content:AddSpace(2);
  Content:AddHeader("Duration");
  
  local ShowDuration = AceGUI:Create("CheckBox");
  ShowDuration:SetLabel("Show duration");
  ShowDuration:SetDescription("Show the time left on an aura.");
  ShowDuration:SetRelativeWidth(1);
  ShowDuration:SetValue(LayoutConfig.ShowDuration);
  ShowDuration:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ShowDuration = Value;
    ContainerInstance:Update("LAYOUT");
    Module:ContentLayoutText(Content, ContainerId);
  end);
  Content:AddChild(ShowDuration);
  
  Content:AddSpace();
  
  local DurationLayout = AceGUI:Create("Dropdown");
  DurationLayout:SetWidth(150);
  DurationLayout:SetList({
    ABBREVSPACE   = "10 m",
    ABBREV        = "10m",
    SEPCOL        = "10:15",
    SEPDOT        = "10.15",
    NONE          = "615",
  });
  DurationLayout:SetLabel("Time layout");
  DurationLayout:SetDisabled(not LayoutConfig.ShowDuration);
  DurationLayout:SetValue(LayoutConfig.DurationLayout);
  DurationLayout:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.DurationLayout = Value;
    ContainerInstance:Update("LAYOUT");
  end);
  Content:AddChild(DurationLayout);
  
  local DurationGroup = AceGUI:Create("SimpleGroup");
  DurationGroup:SetLayout("Flow");
  DurationGroup:SetRelativeWidth(1);
  Content:AddChild(DurationGroup);
  
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
  Content:AddHeader("Count");
  
  local ShowCount = AceGUI:Create("CheckBox");
  ShowCount:SetLabel("Show count");
  ShowCount:SetDescription("Show the number of stacks of an aura.");
  ShowCount:SetRelativeWidth(1);
  ShowCount:SetValue(LayoutConfig.ShowCount);
  ShowCount:SetCallback("OnValueChanged", function(_, _, Value)
    LayoutConfig.ShowCount = Value;
    ContainerInstance:Update("LAYOUT");
    Module:ContentLayoutText(Content, ContainerId);
  end);
  Content:AddChild(ShowCount);
  
  Content:AddSpace();
  
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
