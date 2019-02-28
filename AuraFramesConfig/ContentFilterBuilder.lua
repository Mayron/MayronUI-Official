local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");


local IconEnabled  = "Interface\\RAIDFRAME\\ReadyCheck-Ready";
local IconDisabled = "Interface\\SpellShadow\\Spell-Shadow-Unacceptable";
local IconDelete   = "Interface\\RAIDFRAME\\ReadyCheck-NotReady"


-- List of all the operators with there description. Used by the configuration.
local FilterOperatorDescriptions = {
  Equal           = "Equal",
  NotEqual        = "Not Equal",
  Greater         = "Greater",
  GreaterOrEqual  = "Greater or Equal",
  Lesser          = "Lesser",
  LesserOrEqual   = "Lesser or Equal",
  InList          = "In list",
  NotInList       = "Not in list",
};


-----------------------------------------------------------------
-- Local Function CreateRules
-----------------------------------------------------------------
local function CreateRules(Content, ContentRules, Config, NotifyFunc, Rules)

  local Subjects = {};
  
  for Subject, Definition in pairs(AuraFrames.AuraDefinition) do
    if Definition.Filter == true then
      Subjects[Subject] = AuraFrames.AuraDefinition[Subject].Name;
    end
  end

  for Index, Rule in ipairs(Rules) do
  
    if Index ~= 1 then
    
      local Label = AceGUI:Create("Label");
      Label:SetFontObject(GameFontNormalSmall);
      Label:SetRelativeWidth(1);
      Label:SetText("And");
      ContentRules:AddChild(Label);
    
    end
  
    local Container = AceGUI:Create("SimpleGroup");
    Container:SetRelativeWidth(1);
    Container:SetLayout("Flow");
    ContentRules:AddChild(Container);

    local Enabled = AceGUI:Create("Icon");
    Enabled:SetImage(((Rule.Disabled == true) and IconDisabled) or IconEnabled);
    Enabled:SetImageSize(24, 24);
    Enabled:SetWidth(26);
    Enabled:SetCallback("OnClick", function()
      if Rule.Disabled then
        Rule.Disabled = nil;
      else
        Rule.Disabled = true;
      end
      Enabled:SetImage(((Rule.Disabled == true) and IconDisabled) or IconEnabled);
      NotifyFunc();
    end);
    Container:AddChild(Enabled);
    
    local Subject = AceGUI:Create("Dropdown");
    Subject:SetList(Subjects);
    if Rule.Subject and Subjects[Rule.Subject] then
      Subject:SetValue(Rule.Subject);
    end
    Subject:SetLabel("Subject");
    Subject:SetWidth(150);
    Subject:SetCallback("OnValueChanged", function(_, _, Value)
      Rule.Subject = Value;
      AuraFramesConfig:ContentFilterBuilderRefresh(Content, Config, NotifyFunc);
      NotifyFunc();
    end);
    Container:AddChild(Subject);
    
    if Rule.Subject and Subjects[Rule.Subject] then
    
      if #AuraFrames.FilterTypeOperators[AuraFrames.AuraDefinition[Rule.Subject].Type] == 1 then
        Rule.Operator = AuraFrames.FilterTypeOperators[AuraFrames.AuraDefinition[Rule.Subject].Type][1];
      end
      
      local Operators = {};
    
      for _, Key in pairs(AuraFrames.FilterTypeOperators[AuraFrames.AuraDefinition[Rule.Subject].Type]) do
        Operators[Key] = FilterOperatorDescriptions[Key];
      end
    
      local Operator = AceGUI:Create("Dropdown");
      Operator:SetList(Operators);
      if Rule.Operator then
        Operator:SetValue(Rule.Operator);
      end
      Operator:SetLabel("Operator");
      Operator:SetWidth(150);
      Operator:SetCallback("OnValueChanged", function(_, _, Value)
        Rule.Operator = Value;
        
        if not Rule.Args then
          Rule.Args = {};
        end
        
        if (Value == "InList" or Value == "NotInList") and not Rule.Args.List then
          Rule.Args.List = {};
        end
        
        AuraFramesConfig:ContentFilterBuilderRefresh(Content, Config, NotifyFunc);
        NotifyFunc();
      end);
      Container:AddChild(Operator);
    
    else
    
      local Label = AceGUI:Create("Label");
      Label:SetWidth(150);
      Label:SetText("");
      Container:AddChild(Label);
    
    end
    
    if Rule.Subject and Subjects[Rule.Subject] and Rule.Operator then
      
      if not Rule.Args then
        Rule.Args = {};
      end
      
      local ValueType = AuraFrames.AuraDefinition[Rule.Subject].Type;
      local Operator = Rule.Operator;
      
      if (ValueType == "String" or ValueType == "SpellName" or ValueType == "ItemName") and (Operator == "Equal" or Operator == "NotEqual") then
      
        if AuraFrames.AuraDefinition[Rule.Subject].List then
        
          local Value = AceGUI:Create("Dropdown");
          Value:SetList(AuraFrames.AuraDefinition[Rule.Subject].List);
          if Rule.Args[ValueType] then
            Value:SetValue(Rule.Args[ValueType]);
          end
          Value:SetLabel("Value");
          Value:SetWidth(150);
          Value:SetCallback("OnValueChanged", function(_, _, Value)
            Rule.Args[ValueType] = Value;
            NotifyFunc();
          end);
          Container:AddChild(Value);
          
        else

          if ValueType == "SpellName" then

            local Value = AceGUI:Create("Spell_EditBox");
            Value:SetText(Rule.Args[ValueType] or "");
            Value:SetWidth(150);
            Value:SetLabel("Value");
            Value:SetCallback("OnEnterPressed", function(_, _, Text)
              Rule.Args[ValueType] = Text;
              NotifyFunc();
            end);
            Value:SetCallback("OnTextChanged", function(_, _, Text)
              Rule.Args[ValueType] = Text;
              NotifyFunc();
            end);
            Container:AddChild(Value);

          else
          
            local Value = AceGUI:Create("EditBox");
            Value:DisableButton(true);
            Value:SetText(Rule.Args[ValueType] or "");
            Value:SetLabel("Value");
            Value:SetWidth(150);
            Value:SetCallback("OnTextChanged", function(_, _, Text)
              Rule.Args[ValueType] = Text;
              NotifyFunc();
            end);
            Container:AddChild(Value);
          
          end
          
        end
        
      elseif (ValueType == "Number" or ValueType == "SpellId" or ValueType == "ItemId") and (Operator == "Equal" or Operator == "NotEqual" or Operator == "Greater" or Operator == "GreaterOrEqual" or Operator == "Lesser" or Operator == "LesserOrEqual") then
      
        local Value = AceGUI:Create("EditBox");
        Value:DisableButton(true);
        if Rule.Args[ValueType] then
          Value:SetText(tostring(Rule.Args[ValueType]));
        end
        Value:SetLabel("Value");
        Value:SetWidth(150);
        Value:SetCallback("OnTextChanged", function(_, _, Text)
        
          if Text ~= "" and Text ~= tostring(tonumber(Text)) then
            Value:SetText(tostring(Rule.Args[ValueType]));
          else
            Rule.Args[ValueType] = Text;
          end
          
          NotifyFunc();
          
        end);
        Container:AddChild(Value);
        
      elseif (ValueType == "Float") and (Operator == "Equal" or Operator == "NotEqual" or Operator == "Greater" or Operator == "GreaterOrEqual" or Operator == "Lesser" or Operator == "LesserOrEqual") then
      
        local Value = AceGUI:Create("EditBox");
        Value:DisableButton(true);
        if Rule.Args[ValueType] then
          Value:SetText(tostring(Rule.Args[ValueType]));
        end
        Value:SetLabel("Value");
        Value:SetWidth(150);
        Value:SetCallback("OnTextChanged", function(_, _, Text)
        
          Rule.Args[ValueType] = tonumber(Text);
        
          NotifyFunc();
          
        end);
        Container:AddChild(Value);
        
      elseif ValueType == "Boolean" and (Operator == "Equal" or Operator == "NotEqual") then
      
        if AuraFrames.AuraDefinition[Rule.Subject].List then
        
          local Value = AceGUI:Create("Dropdown");
          Value:SetList(AuraFrames.AuraDefinition[Rule.Subject].List);
          if Rule.Args[ValueType] then
            Value:SetValue(Rule.Args[ValueType]);
          end
          Value:SetLabel("Value");
          Value:SetWidth(150);
          Value:SetCallback("OnValueChanged", function(_, _, Value)
            Rule.Args[ValueType] = Value;
            NotifyFunc();
          end);
          Container:AddChild(Value);
          
        else
      
          local Value = AceGUI:Create("Dropdown");
          Value:SetList({["true"] = "True", ["false"] = "False"});
          if Rule.Args[ValueType] then
            Value:SetValue(Rule.Args[ValueType]);
          end
          Value:SetLabel("Value");
          Value:SetWidth(150);
          Value:SetCallback("OnValueChanged", function(_, _, Value)
            Rule.Args[ValueType] = Value;
            NotifyFunc();
          end);
          Container:AddChild(Value);
        
        end
        
      elseif (Operator == "InList" or Operator == "NotInList") then
      
        local Value = AceGUI:Create("Button");
        Value:SetText("Edit list");
        Value:SetWidth(150);
        Value:SetCallback("OnClick", function()
          if not Rule.Args.List then
            Rule.Args.List = {};
          end
          AuraFramesConfig:ShowListEditor(Rule.Args.List, AuraFrames.AuraDefinition[Rule.Subject].List or ValueType, function() AuraFramesConfig:Show(); NotifyFunc(); end, true, true, false);
          AuraFramesConfig:Close();
        end);
        Container:AddChild(Value);
        
      else
      
        local Label = AceGUI:Create("Label");
        Label:SetWidth(150);
        Label:SetText("");
        Container:AddChild(Label);
      
      end
      
    else
    
      local Label = AceGUI:Create("Label");
      Label:SetWidth(150);
      Label:SetText("");
      Container:AddChild(Label);

    end
    
    local ButtonDelete = AceGUI:Create("Icon");
    ButtonDelete:SetImage(IconDelete);
    ButtonDelete:SetImageSize(24, 24);
    ButtonDelete:SetWidth(26);
    ButtonDelete:SetCallback("OnClick", function()
      table.remove(Rules, Index);
      AuraFramesConfig:ContentFilterBuilderRefresh(Content, Config, NotifyFunc);
      NotifyFunc();
    end);
    Container:AddChild(ButtonDelete);

  end
end


-----------------------------------------------------------------
-- Function ContentFilterBuilder
-----------------------------------------------------------------
function AuraFramesConfig:ContentFilterBuilderRefresh(Content, Config, NotifyFunc)

  Content:PauseLayout();
  Content:ReleaseChildren();
  
  Content:SetLayout("List");
  
  for Index, Group in ipairs(Config or {}) do

    local ContentGroup = AceGUI:Create("InlineGroup");
    ContentGroup:SetRelativeWidth(1);
    if Index ~= 1 then
      ContentGroup:SetTitle("Or");
    else
      ContentGroup:SetTitle("");
    end
    ContentGroup:SetLayout("List")
    Content:AddChild(ContentGroup);
    
    local ContentRules = AceGUI:Create("SimpleGroup");
    ContentRules:SetRelativeWidth(1);
    ContentRules:SetLayout("Flow");
    ContentGroup:AddChild(ContentRules);
    
    CreateRules(Content, ContentRules, Config, NotifyFunc, Group);
    
    local ContentButtons = AceGUI:Create("SimpleGroup");
    ContentButtons:SetRelativeWidth(1);
    ContentButtons:SetLayout("Flow");
    ContentGroup:AddChild(ContentButtons);
    
    local ButtonNewRule = AceGUI:Create("Button");
    ButtonNewRule:SetText("New Rule");
    ButtonNewRule:SetWidth(150);
    ButtonNewRule:SetCallback("OnClick", function()
      table.insert(Group, {});
      AuraFramesConfig:ContentFilterBuilderRefresh(Content, Config, NotifyFunc);
    end);
    ContentButtons:AddChild(ButtonNewRule);
    
    local ButtonDeleteGroup = AceGUI:Create("Button");
    ButtonDeleteGroup:SetText("Delete Group");
    ButtonDeleteGroup:SetWidth(150);
    ButtonDeleteGroup:SetCallback("OnClick", function()
      table.remove(Config, Index);
      AuraFramesConfig:ContentFilterBuilderRefresh(Content, Config, NotifyFunc);
      NotifyFunc();
    end);
    ContentButtons:AddChild(ButtonDeleteGroup);
    
  end
  
  Content:AddSpace();
  
  local ButtonNewGroup = AceGUI:Create("Button");
  ButtonNewGroup:SetText("New Group");
  ButtonNewGroup:SetCallback("OnClick", function()
    if not Config then
      Config = {};
    end
    table.insert(Config, {{}});
    AuraFramesConfig:ContentFilterBuilderRefresh(Content, Config, NotifyFunc);
  end);
  Content:AddChild(ButtonNewGroup);
  
  Content:ResumeLayout();
  Content:DoLayout();
  
  AuraFramesConfig.ScrollFrame:DoLayout();

end
