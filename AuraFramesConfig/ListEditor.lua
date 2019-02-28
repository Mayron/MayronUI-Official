local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");

local IconEnabled  = "Interface\\RAIDFRAME\\ReadyCheck-Ready";
local IconDisabled = "Interface\\SpellShadow\\Spell-Shadow-Unacceptable";
local IconDelete   = "Interface\\RAIDFRAME\\ReadyCheck-NotReady";
local IconUp       = "Interface\\PaperDollInfoFrame\\UI-Character-SkillsPageUp-Up";
local IconDown     = "Interface\\PaperDollInfoFrame\\UI-Character-SkillsPageDown-Up";

local ListWindow = nil;
local ListContainer = nil;
local ListValue = "";


-----------------------------------------------------------------
-- Function CreateListWindow
-----------------------------------------------------------------
local function CreateListWindow()

  ListWindow = AceGUI:Create("Window");
  ListWindow:Hide();
  ListWindow:SetTitle("Aura Frames - List Editor");
  ListWindow:SetWidth(350);
  ListWindow:SetHeight(450);
  ListWindow:EnableResize(false);
  ListWindow:SetLayout("Flow");
  
  ListContainer = AceGUI:Create("SimpleGroup");
  ListContainer:SetRelativeWidth(1);
  ListContainer:SetAutoAdjustHeight(false);
  ListContainer:SetHeight(370);
  ListContainer:SetLayout("Flow");
  ListWindow:AddChild(ListContainer);
  
  local ButtonDone = AceGUI:Create("Button");
  ButtonDone:SetText("Close List Editor");
  ButtonDone:SetRelativeWidth(1);
  ButtonDone:SetCallback("OnClick", function()
    ListWindow:Hide();
  end);
  ListWindow:AddChild(ButtonDone);
    
end


-----------------------------------------------------------------
-- Local Function ListEditorRefresh
-----------------------------------------------------------------
local function ListEditorRefresh(List, Input, Add, Delete, Order)

  ListContainer:PauseLayout();
  ListContainer:ReleaseChildren();

  -- Sort the list before displaying it if we can't order it.
  if Order == false then
    sort(List);
  end
  
  -- Reset old list value.
  ListValue = "";
  
  
  if type(Input) == "table" and Add == false then
  
    -- We got a list as input but we can not add items.
    -- This is only useful for ordering static lists.
    -- We are merging the List with Input so that List
    -- contains all the input elements but also not more.
  
    -- Add missing items in List.
    for Index, _ in pairs(Input) do
    
      if tContains(List, Index) ~= 1 then
        tinsert(List, Index);
      end
    
    end
    
    -- Remove invalid items from List.
    for i = #List, 1, -1 do
    
      if not Input[List[i]] then
        tremove(List, i);
      end
    
    end
    
  end
  
  local Value;
  
  if Add == false then
  
   -- Do nothing :)

  elseif Input == "Number" or Input == "ItemId" then
  
    Value = AceGUI:Create("EditBox");
    Value:DisableButton(true);
    Value:SetText("");
    Value:SetWidth(210);
    Value:SetLabel("Value");
    Value:SetCallback("OnTextChanged", function(_, _, Text)
      if Text ~= "" and Text ~= tostring(tonumber(Text)) then
        Value:SetText(tostring(ListValue));
      else
        ListValue = Text;
      end
    end);
    Value:SetCallback("OnEnterPressed", function(_, _, Text)
      if ListValue ~= "" then
        tinsert(List, ListValue);
        ListEditorRefresh(List, Input, Add, Delete, Order);
      end
    end);
    ListContainer:AddChild(Value);
    
  elseif Input == "Float" then
  
    Value = AceGUI:Create("EditBox");
    Value:DisableButton(true);
    Value:SetText("");
    Value:SetWidth(210);
    Value:SetLabel("Value");
    Value:SetCallback("OnTextChanged", function(_, _, Text)
      ListValue = tonumber(Text);
    end);
    Value:SetCallback("OnEnterPressed", function(_, _, Text)
      if ListValue ~= "" then
        tinsert(List, ListValue);
        ListEditorRefresh(List, Input, Add, Delete, Order);
      end
    end);
    ListContainer:AddChild(Value);
  
  elseif Input == "SpellId" then
  
    Value = AceGUI:Create("EditBox");
    Value:DisableButton(true);
    Value:SetText("");
    Value:SetWidth(210);
    Value:SetLabel("Value");
    Value:SetCallback("OnTextChanged", function(_, _, Text)
      if Text ~= "" and Text ~= tostring(tonumber(Text)) then
        Value:SetText(tostring(ListValue));
      else
        ListValue = Text;
      end
    end);
    Value:SetCallback("OnEnterPressed", function(_, _, Text)
      if ListValue ~= "" then
        tinsert(List, ListValue);
        ListEditorRefresh(List, Input, Add, Delete, Order);
      end
    end);
    ListContainer:AddChild(Value);
  
  elseif Input == "String" or Input == "ItemName" then
  
    Value = AceGUI:Create("EditBox");
    Value:DisableButton(true);
    Value:SetText("");
    Value:SetWidth(210);
    Value:SetLabel("Value");
    Value:SetCallback("OnTextChanged", function(_, _, Text)
      ListValue = Text;
    end);
    Value:SetCallback("OnEnterPressed", function(_, _, Text)
      if ListValue ~= "" then
        tinsert(List, ListValue);
        ListEditorRefresh(List, Input, Add, Delete, Order);
      end
    end);
    ListContainer:AddChild(Value);
    
  elseif Input == "SpellName" then
  
    Value = AceGUI:Create("Spell_EditBox");
    Value:SetText("");
    Value:SetWidth(210);
    Value:SetLabel("Value");
    Value:SetCallback("OnEnterPressed", function(_, _, Text)
      ListValue = Text;
    end);
    Value:SetCallback("OnTextChanged", function(_, _, Text)
      ListValue = Text;
    end);
    ListContainer:AddChild(Value);
    
  elseif type(Input) == "table" then
  
    local Values = {};
    for Index, Value in pairs(Input) do
    
      if tContains(List, Index) ~= 1 then
        Values[Index] = Value;
      end
    
    end
    
    Value = AceGUI:Create("Dropdown");
    Value:SetList(Values);
    Value:SetWidth(210);
    Value:SetLabel("Value");
    Value:SetCallback("OnValueChanged", function(_, _, Value)
      ListValue = Value;
    end);
    ListContainer:AddChild(Value);
  
  end

  if Value then
  
    local ButtonAdd = AceGUI:Create("Button");
    ButtonAdd:SetText("Add");
    ButtonAdd:SetWidth(100);
    ButtonAdd:SetCallback("OnClick", function()
      if ListValue ~= "" then
        tinsert(List, ListValue);
        ListEditorRefresh(List, Input, Add, Delete, Order);
      end
    end);
    ListContainer:AddChild(ButtonAdd);
    
    if Value.SetFocus then
      Value:SetFocus();
    end
  
  end
  
  local ItemContainer = AceGUI:Create("ScrollFrame");
  ItemContainer:SetRelativeWidth(1);
  ItemContainer:SetAutoAdjustHeight(false);
  ItemContainer:SetHeight((Value and 300) or 340);
  ListContainer:AddChild(ItemContainer);
  
  for Id, Value in ipairs(List) do
  
    local Container = AceGUI:Create("SimpleGroup");
    Container:SetRelativeWidth(1);
    Container:SetLayout("Flow");
    ItemContainer:AddChild(Container);
    
    local Label = AceGUI:Create("Label");
    Label:SetFontObject(GameFontNormalSmall);
    Label:SetWidth(210);
    
    if type(Input) == "table" and Input[Value] then
    
      Label:SetText(Input[Value]);
    
    elseif Input == "SpellId" then
    
      local SpellName = GetSpellInfo(Value);
      if SpellName then
        Label:SetText(Value.." ("..SpellName..")");
      else
        Label:SetText(Value);
      end
      
    elseif Input == "ItemId" then
    
      local ItemName = GetItemInfo(Value);
      if ItemName then
        Label:SetText(Value.." ("..ItemName..")");
      else
        Label:SetText(Value);
      end
    
    else
    
      Label:SetText(Value);
    
    end
    
    Container:AddChild(Label);
    
    if Delete == true then
    
      local ButtonDelete = AceGUI:Create("Icon");
      ButtonDelete:SetImage(IconDelete);
      ButtonDelete:SetImageSize(24, 24);
      ButtonDelete:SetWidth(26);
      ButtonDelete:SetCallback("OnClick", function()
        table.remove(List, Id);
        ListEditorRefresh(List, Input, Add, Delete, Order);
      end);
      Container:AddChild(ButtonDelete);
    
    else
    
      local SpaceDelete = AceGUI:Create("Label");
      SpaceDelete:SetWidth(26);
      SpaceDelete:SetText(" ");
      Container:AddChild(SpaceDelete);
    
    end
    
    if Order == true then
    
      local ButtonUp = AceGUI:Create("Icon");
      ButtonUp:SetDisabled(Id == 1);
      ButtonUp:SetImage(IconUp);
      ButtonUp:SetImageSize(24, 24);
      ButtonUp:SetWidth(26);
      ButtonUp:SetCallback("OnClick", function()
        table.insert(List, Id - 1, table.remove(List, Id));
        ListEditorRefresh(List, Input, Add, Delete, Order);
      end);
      Container:AddChild(ButtonUp);
      
      local ButtonDown = AceGUI:Create("Icon");
      ButtonDown:SetDisabled(Id == #List);
      ButtonDown:SetImage(IconDown);
      ButtonDown:SetImageSize(24, 24);
      ButtonDown:SetWidth(26);
      ButtonDown:SetCallback("OnClick", function()
        table.insert(List, Id, table.remove(List, Id + 1));
        ListEditorRefresh(List, Input, Add, Delete, Order);
      end);
      Container:AddChild(ButtonDown);
    
    end
  
  end
  
  ListContainer:ResumeLayout();
  ListContainer:DoLayout();

end


-----------------------------------------------------------------
-- Function ShowListEditor
-----------------------------------------------------------------
function AuraFramesConfig:ShowListEditor(List, Input, NotifyFunc, Add, Delete, Order)
  
  if not ListWindow then
    CreateListWindow();
  end

  ListWindow:SetCallback("OnClose", NotifyFunc);

  ListEditorRefresh(List, Input, Add, Delete, Order);
  ListWindow:Show();
  
end


-----------------------------------------------------------------
-- Function IsListEditorShown
-----------------------------------------------------------------
function AuraFramesConfig:IsListEditorShown()
  
  if ListWindow then
    return ListWindow:IsShown() and true or false;
  else
    return false;
  end
  
end

-----------------------------------------------------------------
-- Function CloseListEditor
-----------------------------------------------------------------
function AuraFramesConfig:CloseListEditor()
  
  if ListWindow then
    ListWindow:Hide();
  end
  
end
