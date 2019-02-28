local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");


local FilterPredefinedConfig = {
  CastByMe = {
    Name = "Cast by me",
    Description = "Aura's that you have cast.",
    Groups = {
      {
        {Subject = "CastByMe", Operator = "Equal", Args = {Boolean = "true"}},
      },
    },
    Order = 1,
  },
  NotCastByMe = {
    Name = "Not cast by me",
    Description = "Aura's that you didn't cast",
    Groups = {
      {
        {Subject = "CastByMe", Operator = "Equal", Args = {Boolean = "false"}},
      },
    },
    Order = 2,
  },
  CastBySameClass = {
    Name = "Cast by someone of the same class",
    Description = "Aura's that are cast by the class "..format("|cff%02x%02x%02x%s|r", RAID_CLASS_COLORS[select(2, UnitClass("player")) or "NONE"].r * 255, RAID_CLASS_COLORS[select(2, UnitClass("player")) or "NONE"].g * 255, RAID_CLASS_COLORS[select(2, UnitClass("player")) or "NONE"].b * 255, select(1, UnitClass("player"))),
    Groups = {
      {
        {Subject = "CasterClass", Operator = "Equal", Args = {String = select(2, UnitClass("player"))}},
      },
    },
    Order = 3,
  },
  DebuffOnHelpAndBuffOnHarm = {
    Name = "Buffs on |cfff36a6ahostile|r and debuffs on |cff6af36afriendly|r targets",
    Groups = {
      {
        {Subject = "TargetIsFriendly", Operator = "Equal", Args = {Boolean = "true"}},
        {Subject = "Type", Operator = "Equal", Args = {String = "HARMFUL"}},
      },
      {
        {Subject = "TargetIsHostile", Operator = "Equal", Args = {Boolean = "true"}},
        {Subject = "Type", Operator = "Equal", Args = {String = "HELPFUL"}},
      },
    },
    Order = 4,
  },
};


-----------------------------------------------------------------
-- Local Function ApplyChanges
-----------------------------------------------------------------
local function ApplyChanges(ContainerId)

  local ContainerInstance = AuraFrames.Containers[ContainerId];

  ContainerInstance.AuraList.Filter:Build();
  
  if ContainerInstance.AuraList.Filter.NotifyFunc then
    ContainerInstance.AuraList.Filter.NotifyFunc();
  end
  
end


-----------------------------------------------------------------
-- Function ContentFilterRefresh
-----------------------------------------------------------------
function AuraFramesConfig:ContentFilterRefresh(Content, ContainerId)

  local FilterConfig = AuraFrames.db.profile.Containers[ContainerId].Filter;
  local ContainerInstance = AuraFrames.Containers[ContainerId];
  
  Content:PauseLayout();
  Content:ReleaseChildren();
  
  Content:SetLayout("List");
  
  Content:AddText("Filter", GameFontNormalLarge);
  
  if FilterConfig.Expert == true then
  
    local ContentFilterBuilder = AceGUI:Create("SimpleGroup");
    ContentFilterBuilder:SetRelativeWidth(1);
    Content:AddChild(ContentFilterBuilder);
    AuraFramesConfig:EnhanceContainer(ContentFilterBuilder);
    
    AuraFramesConfig:ContentFilterBuilderRefresh(ContentFilterBuilder, FilterConfig.Groups, function() ApplyChanges(ContainerId); end);
    
    Content:AddSpace();
    
    Content:AddHeader("Expert mode");
    Content:AddText("Expert mode is enabled, when you turn off the expert mode you will lose the custom expert filters!");
    Content:AddSpace();
      
    local CheckBoxExpert = AceGUI:Create("CheckBox");
    CheckBoxExpert:SetValue(true);
    CheckBoxExpert:SetRelativeWidth(1);
    CheckBoxExpert:SetLabel("Expert Mode");
    CheckBoxExpert:SetCallback("OnValueChanged", function(_, _, Value)

      local Ops = false;
      
      for _, Rules in ipairs(FilterConfig.Groups) do
        for _, Rule in ipairs(Rules) do
          if Rule.Operator then
            Ops = true;
            break;
          end
        end
        if Ops == true then
          break;
        end
      end
    
      if Ops == true then
        AuraFramesConfig:Close();
        AuraFrames:Confirm("Are you sure you want to turn off expert mode? You will lose your custom filters!", function(Result)
          if Result == true then
            FilterConfig.Expert = false;
            wipe(FilterConfig.Groups);
            ApplyChanges(ContainerId);
          else
            CheckBoxExpert:SetValue(true);
          end
          AuraFramesConfig:ContentFilterRefresh(Content, ContainerId);
          AuraFramesConfig:Show();
        end);
      else
        FilterConfig.Expert = false;
        wipe(FilterConfig.Groups);
        ApplyChanges(ContainerId);
        AuraFramesConfig:ContentFilterRefresh(Content, ContainerId);
        AuraFramesConfig:Show();
      end

    end);
    Content:AddChild(CheckBoxExpert);

    Content:AddSpace();
    Content:AddText("TIP: Shift right click an aura to dump the properties to the chat window. This will help you to create filters. (This only works when an container can be clicked).");
    Content:AddSpace();

    local ButtonHelp = AceGUI:Create("Button");
    ButtonHelp:SetText("Open Help");
    ButtonHelp:SetCallback("OnClick", function()
      AuraFramesConfig:AuraDefinitionHelpShow();
    end);
    Content:AddChild(ButtonHelp);
  
  else
  
    Content:AddText("\nFilters are used for fine tuning what kind of aura's are displayed inside a container.\n\nOnly show aura's that are matching at least one of the following selected criteria, if nothing is selected then there will be no filtering:\n\n");
  
    local List = {};
  
    for Key, Definition in pairs(FilterPredefinedConfig) do

      local CheckBoxPredefined = AceGUI:Create("CheckBox");
      CheckBoxPredefined.Order = FilterPredefinedConfig[Key].Order
      CheckBoxPredefined:SetValue(FilterConfig.Predefined and FilterConfig.Predefined[Key] or false);
      CheckBoxPredefined:SetRelativeWidth(1);
      CheckBoxPredefined:SetLabel(FilterPredefinedConfig[Key].Name);
      CheckBoxPredefined:SetDescription(FilterPredefinedConfig[Key].Description or "");
      CheckBoxPredefined:SetCallback("OnValueChanged", function(_, _, Value)

        if Value == true then
          if not FilterConfig.Predefined then
            FilterConfig.Predefined = {};
          end
          FilterConfig.Predefined[Key] = true;
        else
          if FilterConfig.Predefined then
            FilterConfig.Predefined[Key] = nil;
          end
        end
        
        wipe(FilterConfig.Groups);
        
        for Key, Value in pairs(FilterConfig.Predefined or {}) do
        
          if Value == true and FilterPredefinedConfig[Key] then
          
            for _, Group in pairs(FilterPredefinedConfig[Key].Groups) do
            
              tinsert(FilterConfig.Groups, Group);
            
            end
          
          end
          
        end
        
        ApplyChanges(ContainerId);

      end);
      
      table.insert(List, CheckBoxPredefined);
      
    end
    
    sort(List, function(v1, v2) return v1.Order < v2.Order; end);
    
    for _, Control in ipairs(List) do
      Content:AddChild(Control);
    end
    
    Content:AddSpace();
    
    Content:AddHeader("Expert mode");
    Content:AddText("The expert mode allow you to even more customizations then the few default rules above. But the export mode is also quite complex. The above rules will be converted to the complex filter rules, but when you turn off the expert mode you will lose the custom expert filters!\n");
      
    local CheckBoxExpert = AceGUI:Create("CheckBox");
    CheckBoxExpert:SetValue(false);
    CheckBoxExpert:SetRelativeWidth(1);
    CheckBoxExpert:SetLabel("Expert Mode");
    CheckBoxExpert:SetCallback("OnValueChanged", function(_, _, Value)
      FilterConfig.Expert = true;
      FilterConfig.Predefined = nil;
      if not FilterConfig.Groups or #FilterConfig.Groups == 0 then
        wipe(FilterConfig.Groups);
        tinsert(FilterConfig.Groups, {{}});
      end
      AuraFramesConfig:ContentFilterRefresh(Content, ContainerId);
      ApplyChanges(ContainerId);
    end);
    Content:AddChild(CheckBoxExpert);
  
  end
  
  
  Content:ResumeLayout();
  Content:DoLayout();

end

-----------------------------------------------------------------
-- Function ContentFilter
-----------------------------------------------------------------
function AuraFramesConfig:ContentFilter(ContainerId)

  self.Content:SetLayout("Fill");
  
  local Content = AceGUI:Create("ScrollFrame");
  Content:SetLayout("List");
  self:EnhanceContainer(Content);
  self.Content:AddChild(Content);
  
  self.ScrollFrame = Content;
  
  self:ContentFilterRefresh(Content, ContainerId);

end
