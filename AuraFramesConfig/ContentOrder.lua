local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");


local IconEnabled  = "Interface\\RAIDFRAME\\ReadyCheck-Ready";
local IconDisabled = "Interface\\SpellShadow\\Spell-Shadow-Unacceptable";
local IconDelete   = "Interface\\RAIDFRAME\\ReadyCheck-NotReady";
local IconUp       = "Interface\\PaperDollInfoFrame\\UI-Character-SkillsPageUp-Up";
local IconDown     = "Interface\\PaperDollInfoFrame\\UI-Character-SkillsPageDown-Up";


local OrderPredefinedConfig = {
  TimeLeftDesc = {
    Name = "|cff4cd8daDescending|r on time left",
    Order = 1,
  },
  NoTimeTimeLeftDesc = {
    Name = "No expiration time and then |cff4cd8daDescending|r on time left",
    Order = 2,
  },
  TypeNoTimeTimeDesc = {
    Name = "Sort on Type, no expiration time and then |cff4cd8daDescending|r on time left",
    Order = 3,
  },
  TimeLeftAsc = {
    Name = "|cfff1ec66Ascending|r on time left",
    Order = 4,
  },
  TypeTimeAsc = {
    Name = "Sort on Type, |cfff1ec66Ascending|r on time left",
    Order = 5,
  },
};

local OrderPredefinedDefault = "NoTimeTimeLeftDesc";


-----------------------------------------------------------------
-- Local Function ApplyChange
-----------------------------------------------------------------
local function ApplyChange(ContainerId)

  local ContainerInstance = AuraFrames.Containers[ContainerId];

  ContainerInstance.AuraList.Order:Build();
  ContainerInstance.AuraList.Order:UpdateAll();
  
end


-----------------------------------------------------------------
-- Local Function CreateRules
-----------------------------------------------------------------
local function CreateRules(Content, ContentRules, ContainerId, Rules)

  local Subjects = {};
  
  for Subject, Definition in pairs(AuraFrames.AuraDefinition) do
    if Definition.Order == true then
      Subjects[Subject] = AuraFrames.AuraDefinition[Subject].Name;
    end
  end

  for Index, Rule in ipairs(Rules) do
  
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
      ApplyChange(ContainerId);
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
      
      if Rule.Args and Rule.Args.List then
        Rule.Args.List = nil;
      end
      
      AuraFramesConfig:ContentOrderRefresh(Content, ContainerId);
      ApplyChange(ContainerId);
    end);
    Container:AddChild(Subject);
    
    if Rule.Subject and Subjects[Rule.Subject] then
    
      if #AuraFrames.OrderTypeOperators[AuraFrames.AuraDefinition[Rule.Subject].Type] == 1 then
        Rule.Operator = AuraFrames.OrderTypeOperators[AuraFrames.AuraDefinition[Rule.Subject].Type][1];
      end
      
      local Operators = {};
    
      for _, Key in pairs(AuraFrames.OrderTypeOperators[AuraFrames.AuraDefinition[Rule.Subject].Type]) do
        Operators[Key] = AuraFrames.OrderOperatorDescriptions[Key];
      end
      
      if AuraFrames.AuraDefinition[Rule.Subject].List then
        for _, Key in pairs(AuraFrames.OrderTypeOperators["List"]) do
          Operators[Key] = AuraFrames.OrderOperatorDescriptions[Key];
        end
      end
    
      local Operator = AceGUI:Create("Dropdown");
      Operator:SetList(Operators);
      if Rule.Operator then
        Operator:SetValue(Rule.Operator);
      end
      Operator:SetLabel("Sort");
      Operator:SetWidth(150);
      Operator:SetCallback("OnValueChanged", function(_, _, Value)
        Rule.Operator = Value;
        
        if not Rule.Args then
          Rule.Args = {};
        end
        
        if (Value == "ListAsc" or Value == "ListDesc") and not Rule.Args.List then
          Rule.Args.List = {};
        end
        
        AuraFramesConfig:ContentOrderRefresh(Content, ContainerId);
        ApplyChange(ContainerId);
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
      
      if (ValueType == "String" or ValueType == "SpellName" or ValueType == "ItemName") and (Operator == "First" or Operator == "Last") then
      
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
            ApplyChange(ContainerId);
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
              ApplyChange(ContainerId);
            end);
            Value:SetCallback("OnTextChanged", function(_, _, Text)
              Rule.Args[ValueType] = Text;
              ApplyChange(ContainerId);
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
              ApplyChange(ContainerId);
            end);
            Container:AddChild(Value);
          
          end
          
        end
        
      elseif (ValueType == "Number" or ValueType == "SpellId" or ValueType == "ItemId") and (Operator == "First" or Operator == "Last") then
      
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
          
          ApplyChange(ContainerId);
          
        end);
        Container:AddChild(Value);
        
      elseif (ValueType == "Float") and (Operator == "First" or Operator == "Last") then
      
        local Value = AceGUI:Create("EditBox");
        Value:DisableButton(true);
        if Rule.Args[ValueType] then
          Value:SetText(tostring(Rule.Args[ValueType]));
        end
        Value:SetLabel("Value");
        Value:SetWidth(150);
        Value:SetCallback("OnTextChanged", function(_, _, Text)
        
          Rule.Args[ValueType] = tonumber(Text);
          
          ApplyChange(ContainerId);
          
        end);
        Container:AddChild(Value);
        
      elseif ValueType == "Boolean" and (Operator == "First" or Operator == "Last") then
      
        local Value = AceGUI:Create("Dropdown");
        Value:SetList({["true"] = "True", ["false"] = "False"});
        if Rule.Args[ValueType] then
          Value:SetValue(Rule.Args[ValueType]);
        end
        Value:SetLabel("Value");
        Value:SetWidth(150);
        Value:SetCallback("OnValueChanged", function(_, _, Value)
          Rule.Args[ValueType] = Value;
          ApplyChange(ContainerId);
        end);
        Container:AddChild(Value);
        
      elseif (Operator == "ListAsc" or Operator == "ListDesc") then
      
        local Value = AceGUI:Create("Button");
        Value:SetText("Edit list");
        Value:SetWidth(150);
        Value:SetCallback("OnClick", function()
          if not Rule.Args.List then
            Rule.Args.List = {};
          end
          AuraFramesConfig:Close();
          AuraFramesConfig:ShowListEditor(Rule.Args.List, AuraFrames.AuraDefinition[Rule.Subject].List or AuraFrames.AuraDefinition[Rule.Subject].Type, function() AuraFramesConfig:Show(); ApplyChange(ContainerId); end, AuraFrames.AuraDefinition[Rule.Subject].List == nil, AuraFrames.AuraDefinition[Rule.Subject].List == nil, true);
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
    ButtonDelete:SetDisabled(false);
    ButtonDelete:SetImage(IconDelete);
    ButtonDelete:SetImageSize(24, 24);
    ButtonDelete:SetWidth(26);
    ButtonDelete:SetCallback("OnClick", function()
      table.remove(Rules, Index);
      AuraFramesConfig:ContentOrderRefresh(Content, ContainerId);
      ApplyChange(ContainerId);
    end);
    Container:AddChild(ButtonDelete);
    
    local ButtonUp = AceGUI:Create("Icon");
    ButtonUp:SetDisabled(Index == 1);
    ButtonUp:SetImage(IconUp);
    ButtonUp:SetImageSize(24, 24);
    ButtonUp:SetWidth(26);
    ButtonUp:SetCallback("OnClick", function()
      table.insert(Rules, Index - 1, table.remove(Rules, Index));
      AuraFramesConfig:ContentOrderRefresh(Content, ContainerId);
      ApplyChange(ContainerId);
    end);
    Container:AddChild(ButtonUp);
    
    local ButtonDown = AceGUI:Create("Icon");
    ButtonDown:SetDisabled(Index == #Rules);
    ButtonDown:SetImage(IconDown);
    ButtonDown:SetImageSize(24, 24);
    ButtonDown:SetWidth(26);
    ButtonDown:SetCallback("OnClick", function()
      table.insert(Rules, Index, table.remove(Rules, Index + 1));
      AuraFramesConfig:ContentOrderRefresh(Content, ContainerId);
      ApplyChange(ContainerId);
    end);
    Container:AddChild(ButtonDown);

  end
end


-----------------------------------------------------------------
-- Function ContentOrderRefresh
-----------------------------------------------------------------
function AuraFramesConfig:ContentOrderRefresh(Content, ContainerId)

  local OrderConfig = AuraFrames.db.profile.Containers[ContainerId].Order;
  local ContainerInstance = AuraFrames.Containers[ContainerId];
  
  Content:PauseLayout();
  Content:ReleaseChildren();
  
  Content:SetLayout("List");
  
  Content:AddText("Order", GameFontNormalLarge);
  
  if OrderConfig.Expert == true then
  
    CreateRules(Content, Content, ContainerId, OrderConfig.Rules);
  
    local ButtonNewRule = AceGUI:Create("Button");
    ButtonNewRule:SetText("New Rule");
    ButtonNewRule:SetCallback("OnClick", function()
      if not OrderConfig.Rules then
        OrderConfig.Rules = {};
      end
      table.insert(OrderConfig.Rules, {{}});
      AuraFramesConfig:ContentOrderRefresh(Content, ContainerId);
    end);
    Content:AddChild(ButtonNewRule);
    
    Content:AddHeader("Expert mode");
    Content:AddText("Expert mode is enabled, when you turn off the expert mode you will lose the custom order rules!");
    Content:AddSpace();
      
    local CheckBoxExpert = AceGUI:Create("CheckBox");
    CheckBoxExpert:SetValue(true);
    CheckBoxExpert:SetRelativeWidth(1);
    CheckBoxExpert:SetLabel("Expert Mode");
    CheckBoxExpert:SetCallback("OnValueChanged", function(_, _, Value)

      AuraFramesConfig:Close();
      AuraFrames:Confirm("Are you sure you want to turn off expert mode? You will lose your custom rules!", function(Result)
        if Result == true then
          OrderConfig.Expert = false;
          OrderConfig.Rules = {};
          OrderConfig.Predefined = OrderPredefinedDefault;
          ApplyChange(ContainerId);
        else
          CheckBoxExpert:SetValue(true);
        end
        AuraFramesConfig:ContentOrderRefresh(Content, ContainerId);
        AuraFramesConfig:Show();
      end);

    end);
    Content:AddChild(CheckBoxExpert);

    Content:AddSpace();
    Content:AddText("TIP: Shift right click an aura to dump the properties to the chat window. This will help you to create order rules. (This only works when an container can be clicked).");
    Content:AddSpace();

    local ButtonHelp = AceGUI:Create("Button");
    ButtonHelp:SetText("Open Help");
    ButtonHelp:SetCallback("OnClick", function()
      AuraFramesConfig:AuraDefinitionHelpShow();
    end);
    Content:AddChild(ButtonHelp);
    
  else
  
    Content:AddText("\nOrdering is used for sorting the aura's.\n\nSelect one option that need to be used for ordering the aura's:\n\n");
  
    local List = {};
  
    for Key, Definition in pairs(AuraFrames.OrderPredefined) do

      local CheckBoxPredefined = AceGUI:Create("CheckBox");
      CheckBoxPredefined:SetType("radio");
      CheckBoxPredefined.Order = OrderPredefinedConfig[Key].Order
      CheckBoxPredefined:SetValue(OrderConfig.Predefined == Key);
      CheckBoxPredefined:SetRelativeWidth(1);
      CheckBoxPredefined:SetLabel(OrderPredefinedConfig[Key].Name);
      CheckBoxPredefined:SetDescription(OrderPredefinedConfig[Key].Description or "");
      CheckBoxPredefined:SetCallback("OnValueChanged", function(_, _, Value)
      
        OrderConfig.Predefined = Key;
        ApplyChange(ContainerId);
        AuraFramesConfig:ContentOrderRefresh(Content, ContainerId);

      end);
      
      table.insert(List, CheckBoxPredefined);
      
    end
    
    sort(List, function(v1, v2) return v1.Order < v2.Order; end);
    
    for _, Control in ipairs(List) do
      Content:AddChild(Control);
    end
    
    Content:AddSpace(2);
    Content:AddText("|cff4cd8daDescending|r: Start with most time left and end with lowest time left.\n|cfff1ec66Ascending|r: Start with lowest time left and end with most time left.", GameFontHighlight);
    Content:AddSpace();
    
    Content:AddHeader("Expert mode");
    Content:AddText("The expert mode allow you to even more customizations then the few default options above. But the export mode is also quite complex. The above selected rule will be converted to the complex order rules, but when you turn off the expert mode you will lose the custom expert orders rules!\n");
      
    local CheckBoxExpert = AceGUI:Create("CheckBox");
    CheckBoxExpert:SetValue(false);
    CheckBoxExpert:SetRelativeWidth(1);
    CheckBoxExpert:SetLabel("Expert Mode");
    CheckBoxExpert:SetCallback("OnValueChanged", function(_, _, Value)
      OrderConfig.Expert = true;
      OrderConfig.Predefined = nil;
      AuraFramesConfig:ContentOrderRefresh(Content, ContainerId);
      ApplyChange(ContainerId);
    end);
    Content:AddChild(CheckBoxExpert);
  
  end
  
  Content:ResumeLayout();
  Content:DoLayout();

end


-----------------------------------------------------------------
-- Function ContentOrder
-----------------------------------------------------------------
function AuraFramesConfig:ContentOrder(ContainerId)

  self.Content:SetLayout("Fill");
  
  local Content = AceGUI:Create("ScrollFrame");
  Content:SetLayout("List");
  self:EnhanceContainer(Content);
  self.Content:AddChild(Content);
  
  self:ContentOrderRefresh(Content, ContainerId);

end

