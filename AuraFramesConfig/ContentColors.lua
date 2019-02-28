local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");

local SelectedRules = {};
local EditRules = {};

-----------------------------------------------------------------
-- Local Function ApplyChanges
-----------------------------------------------------------------
local function ApplyChanges(ContainerId)

  local ContainerInstance = AuraFrames.Containers[ContainerId];

  ContainerInstance.AuraList.Colors:Build();
  
  if ContainerInstance.AuraList.Colors.NotifyFunc then
    ContainerInstance.AuraList.Colors.NotifyFunc();
  end
  
end

-----------------------------------------------------------------
-- Function ColorContents
-----------------------------------------------------------------
function AuraFramesConfig:ContentColors(Content, ContainerId)

  local ColorConfig = AuraFrames.db.profile.Containers[ContainerId].Colors;
  local ContainerInstance = AuraFrames.Containers[ContainerId];
  local ContainerType = AuraFrames.db.profile.Containers[ContainerId].Type;

  Content:PauseLayout();
  Content:ReleaseChildren();
  
  Content:SetLayout("List");
  
  if ColorConfig.Expert ~= true then

    local ColorGroup = AceGUI:Create("SimpleGroup");
    ColorGroup:SetLayout("Flow");
    ColorGroup:SetRelativeWidth(1);
    Content:AddChild(ColorGroup);
    
    for Index, Rule in ipairs(ColorConfig.Rules) do
    
      local ColorPicker = AceGUI:Create("ColorPicker");
      ColorPicker:SetWidth(250);
      ColorPicker:SetHasAlpha(false);
      ColorPicker:SetColor(unpack(Rule.Color));
      ColorPicker:SetLabel(Rule.Name);
      ColorPicker:SetCallback("OnValueChanged", function(_, _, ...)
        Rule.Color = {...};
        ApplyChanges(ContainerId);
      end);
      ColorGroup:AddChild(ColorPicker);
    
    end
    
    local ColorDefault = AceGUI:Create("ColorPicker");
    ColorDefault:SetWidth(250);
    ColorDefault:SetHasAlpha(false);
    ColorDefault:SetColor(unpack(ColorConfig.DefaultColor));
    ColorDefault:SetLabel("Default");
    ColorDefault:SetCallback("OnValueChanged", function(_, _, ...)
      ColorConfig.DefaultColor = {...};
      ApplyChanges(ContainerId);
    end);
    ColorGroup:AddChild(ColorDefault);
    
    Content:AddSpace(2);
    
    local OptionGroup = AceGUI:Create("SimpleGroup");
    OptionGroup:SetLayout("Flow");
    OptionGroup:SetRelativeWidth(1);
    Content:AddChild(OptionGroup);
    
    local ColorReset = AceGUI:Create("Button");
    ColorReset:SetText("Reset Colors");
    ColorReset:SetCallback("OnClick", function()
      AuraFrames.db.profile.Containers[ContainerId].Colors = AuraFrames:GetDatabaseDefaultColors();
      AuraFramesConfig:ContentColors(Content, ContainerId);
      ApplyChanges(ContainerId);
    end);
    OptionGroup:AddChild(ColorReset);
    
    local ExpertMode = AceGUI:Create("CheckBox");
    ExpertMode:SetLabel("Expert mode");
    ExpertMode:SetValue(false);
    ExpertMode:SetCallback("OnValueChanged", function(_, _, Value)
    
      ColorConfig.Expert = true;
      AuraFramesConfig:ContentColors(Content, ContainerId);

    end);
    OptionGroup:AddChild(ExpertMode);
  
  else
  
    if EditRules[ContainerId] == true and SelectedRules[ContainerId] and ColorConfig.Rules[SelectedRules[ContainerId]] then
    
      local Rule = ColorConfig.Rules[SelectedRules[ContainerId]];
    
      local OptionGroup = AceGUI:Create("SimpleGroup");
      OptionGroup:SetLayout("Flow");
      OptionGroup:SetRelativeWidth(1);
      Content:AddChild(OptionGroup);
    
      local NameValue = AceGUI:Create("EditBox");
      NameValue:DisableButton(true);
      NameValue:SetText(Rule.Name);
      NameValue:SetLabel("Name");
      NameValue:SetWidth(150);
      NameValue:SetCallback("OnTextChanged", function(_, _, Text)
        Rule.Name = Text;
      end);
      OptionGroup:AddChild(NameValue);
      
      local Space = AceGUI:Create("Label");
      Space:SetText(" ");
      Space:SetWidth(50);
      OptionGroup:AddChild(Space);
      
      local ColorPicker = AceGUI:Create("ColorPicker");
      ColorPicker:SetWidth(200);
      ColorPicker:SetHasAlpha(false);
      ColorPicker:SetColor(unpack(Rule.Color));
      ColorPicker:SetLabel("Color");
      ColorPicker:SetCallback("OnValueChanged", function(_, _, ...)
        Rule.Color = {...};
        ApplyChanges(ContainerId);
      end);
      OptionGroup:AddChild(ColorPicker);

      local ButtonDone = AceGUI:Create("Button");
      ButtonDone:SetWidth(150);
      ButtonDone:SetText("Done");
      ButtonDone:SetCallback("OnClick", function()
        
        EditRules[ContainerId] = false;
        AuraFramesConfig:ContentColors(Content, ContainerId);
        
      end);
      OptionGroup:AddChild(ButtonDone);
      
      local ContentFilterBuilder = AceGUI:Create("SimpleGroup");
      ContentFilterBuilder:SetRelativeWidth(1);
      AuraFramesConfig:EnhanceContainer(ContentFilterBuilder);
      Content:AddChild(ContentFilterBuilder);
      
      AuraFramesConfig:ContentFilterBuilderRefresh(ContentFilterBuilder, Rule.Groups, function() ApplyChanges(ContainerId); end);
    
    else
  
      local ExpertGroup = AceGUI:Create("SimpleGroup");
      ExpertGroup:SetLayout("Flow");
      ExpertGroup:SetRelativeWidth(1);
      Content:AddChild(ExpertGroup);
      
      local RuleList = AceGUI:Create("MultiSelect");
      RuleList:SetWidth(350);
      RuleList:SetHeight(200);
      RuleList:SetLabel("Rules");
      RuleList:SetMultiSelect(false);
      for _, ColorRule in ipairs(ColorConfig.Rules) do
        RuleList:AddItem(ColorRule.Name);
      end
      if SelectedRules[ContainerId] then
        RuleList:SetSelected(RuleList:GetItemByIndex(SelectedRules[ContainerId]), true);
      end
      ExpertGroup:AddChild(RuleList);
      
      local ExpertOptionGroup = AceGUI:Create("SimpleGroup");
      ExpertOptionGroup:SetLayout("List");
      ExpertOptionGroup:SetWidth(150);
      ExpertOptionGroup:SetHeight(200);
      ExpertGroup:AddChild(ExpertOptionGroup);
      AuraFramesConfig:EnhanceContainer(ExpertOptionGroup);
      ExpertOptionGroup:AddSpace();
      
      local ButtonMoveUp = AceGUI:Create("Button");
      ButtonMoveUp:SetDisabled(true);
      ButtonMoveUp:SetWidth(150);
      ButtonMoveUp:SetText("Move up");
      ButtonMoveUp:SetCallback("OnClick", function()
      
        local Item = RuleList:GetSelected()[1];
        
        if not Item or Item.index == 1 then
          return;
        end
        
        local Index = Item.index;
        
        tinsert(ColorConfig.Rules, Index - 1, tremove(ColorConfig.Rules, Index));
        SelectedRules[ContainerId] = Index - 1;
        
        AuraFramesConfig:ContentColors(Content, ContainerId);
        
        ApplyChanges(ContainerId);
      
      end);
      ExpertOptionGroup:AddChild(ButtonMoveUp);
      
      local ButtonMoveDown = AceGUI:Create("Button");
      ButtonMoveDown:SetDisabled(true);
      ButtonMoveDown:SetWidth(150);
      ButtonMoveDown:SetText("Move down");
      ButtonMoveDown:SetCallback("OnClick", function()
        
        local Item = RuleList:GetSelected()[1];
        
        if not Item or Item.index == #ColorConfig.Rules then
          return;
        end
        
        local Index = Item.index;
        
        tinsert(ColorConfig.Rules, Index, tremove(ColorConfig.Rules, Index + 1));
        SelectedRules[ContainerId] = Index + 1;
        
        AuraFramesConfig:ContentColors(Content, ContainerId);
        
        ApplyChanges(ContainerId);
        
      end);
      ExpertOptionGroup:AddChild(ButtonMoveDown);
    
      local ButtonDelete = AceGUI:Create("Button");
      ButtonDelete:SetDisabled(true);
      ButtonDelete:SetWidth(150);
      ButtonDelete:SetText("Delete");
      ButtonDelete:SetCallback("OnClick", function()
      
        local Item = RuleList:GetSelected()[1];
        
        if not Item then
          return;
        end
        
        local Index = Item.index;
        
        tremove(ColorConfig.Rules, Index);
        SelectedRules[ContainerId] = nil;
        
        AuraFramesConfig:ContentColors(Content, ContainerId);
        
        ApplyChanges(ContainerId);
      
      end);
      ExpertOptionGroup:AddChild(ButtonDelete);
      
      local ButtonEdit = AceGUI:Create("Button");
      ButtonEdit:SetDisabled(true);
      ButtonEdit:SetWidth(150);
      ButtonEdit:SetText("Edit");
      ButtonEdit:SetCallback("OnClick", function()
      
        local Item = RuleList:GetSelected()[1];
        
        if not Item then
          return;
        end
        
        local Index = Item.index;
      
        EditRules[ContainerId] = true;
        SelectedRules[ContainerId] = Index;
        
        AuraFramesConfig:ContentColors(Content, ContainerId);
      
      end);
      ExpertOptionGroup:AddChild(ButtonEdit);
      
      local ButtonNew = AceGUI:Create("Button");
      ButtonNew:SetWidth(150);
      ButtonNew:SetText("New");
      ButtonNew:SetCallback("OnClick", function()
        
        tinsert(ColorConfig.Rules, {
          Name = "New Rule",
          Groups = {{}},
          Color = {1.0, 1.0, 1.0, 1.0},
        });
        
        EditRules[ContainerId] = true;
        SelectedRules[ContainerId] = #ColorConfig.Rules;
        
        AuraFramesConfig:ContentColors(Content, ContainerId);
        
        ApplyChanges(ContainerId);
        
      end);
      ExpertOptionGroup:AddChild(ButtonNew);
      
      ExpertOptionGroup:AddSpace(3);
      
      local DefaultColor = AceGUI:Create("ColorPicker");
      DefaultColor:SetHasAlpha(false);
      DefaultColor:SetColor(unpack(ColorConfig.DefaultColor));
      DefaultColor:SetLabel("Default color");
      DefaultColor:SetCallback("OnValueChanged", function(_, _, ...)
        ColorConfig.DefaultColor = {...};
        ApplyChanges(ContainerId);
      end);
      ExpertOptionGroup:AddChild(DefaultColor);
      
      RuleList:SetCallback("OnLabelClick", function(_, Value)
      
        local Item = RuleList:GetSelected()[1];
        
        if Item == nil then
          SelectedRules[ContainerId] = nil;
        else
          SelectedRules[ContainerId] = Item.index;
        end
        
        ButtonMoveUp:SetDisabled(Item == nil or Item.index == 1);
        ButtonMoveDown:SetDisabled(Item == nil or Item.index == #ColorConfig.Rules);
        ButtonDelete:SetDisabled(Item == nil);
        ButtonEdit:SetDisabled(Item == nil);
      
      end);
      
      local Item = RuleList:GetSelected()[1];
      
      if Item == nil then
        SelectedRules[ContainerId] = nil;
      else
        SelectedRules[ContainerId] = Item.index;
      end
      
      ButtonMoveUp:SetDisabled(Item == nil or Item.index == 1);
      ButtonMoveDown:SetDisabled(Item == nil or Item.index == #ColorConfig.Rules);
      ButtonDelete:SetDisabled(Item == nil);
      ButtonEdit:SetDisabled(Item == nil);
      
      Content:AddSpace();

      local OptionGroup = AceGUI:Create("SimpleGroup");
      OptionGroup:SetLayout("Flow");
      OptionGroup:SetRelativeWidth(1);
      Content:AddChild(OptionGroup);
      
      local ColorReset = AceGUI:Create("Button");
      ColorReset:SetText("Reset Colors Rules");
      ColorReset:SetCallback("OnClick", function()
        AuraFrames.db.profile.Containers[ContainerId].Colors = AuraFrames:GetDatabaseDefaultColors();
        AuraFrames.db.profile.Containers[ContainerId].Colors.Expert = true;
        SelectedRules[ContainerId] = nil;
        AuraFramesConfig:ContentColors(Content, ContainerId);
        ApplyChanges(ContainerId);
      end);
      OptionGroup:AddChild(ColorReset);
      
      local ExpertMode = AceGUI:Create("CheckBox");
      ExpertMode:SetLabel("Expert mode");
      ExpertMode:SetValue(true);
      ExpertMode:SetCallback("OnValueChanged", function(_, _, Value)

        SelectedRules[ContainerId] = nil;
        EditRules[ContainerId] = nil;

        ColorConfig.Expert = false;
        
        AuraFramesConfig:ContentColors(Content, ContainerId);

      end);
      OptionGroup:AddChild(ExpertMode);
      
      Content:AddSpace(2);
    
      local Description = AceGUI:Create("Label");
      Description:SetText("The first rule from the top that match will be used for coloring.");
      Description:SetRelativeWidth(1);
      Content:AddChild(Description);
    
    end
    
    
  end
  
  Content:ResumeLayout();
  Content:DoLayout();
  
  AuraFramesConfig.ScrollFrame:DoLayout();

end
