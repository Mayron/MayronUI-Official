local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

-- Import used global references into the local namespace.
local tinsert, tremove, tconcat, sort, tContains = tinsert, tremove, table.concat, sort, tContains;
local fmt, tostring = string.format, tostring;
local select, pairs, ipairs, next, type, unpack = select, pairs, ipairs, next, type, unpack;
local loadstring, assert, error = loadstring, assert, error;
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget;
local GetTime = GetTime;

AuraFrames.OrderPrototype = {};


-- List of all the predefined filters. Used by the expresion builder and the configuration.
AuraFrames.OrderPredefined = {
  TimeLeftDesc = {
    Rules = {
      {Subject = "ExpirationTime", Operator = "NumberDesc", Args = {}},
    },
  },
  NoTimeTimeLeftDesc = {
    Rules = {
      {Subject = "ExpirationTime", Operator = "First", Args = {Float = 0}},
      {Subject = "ExpirationTime", Operator = "NumberDesc", Args = {}},
    },
  },
  TypeNoTimeTimeDesc = {
    Rules = {
      {Subject = "Type", Operator = "ListAsc", Args = {List = {"HELPFUL", "WEAPON", "HARMFUL"}}},
      {Subject = "ExpirationTime", Operator = "First", Args = {Float = 0}},
      {Subject = "ExpirationTime", Operator = "NumberDesc", Args = {}},
    },
  },
  TimeLeftAsc = {
    Rules = {
      {Subject = "ExpirationTime", Operator = "NumberAsc", Args = {}},
    },
  },
  TypeTimeAsc = {
    Rules = {
      {Subject = "Type", Operator = "ListAsc", Args = {List = {"HELPFUL", "WEAPON", "HARMFUL"}}},
      {Subject = "ExpirationTime", Operator = "NumberAsc", Args = {}},
    },
  },
};

-- Internal list for converting operator keys to lua code.
local OrderOperatorMappings = {
  First           = "==",
  Last            = "~=",
  NumberAsc       = "<",
  NumberDesc      = ">",
  ListAsc         = "<",
  ListDesc        = ">",
};

-- List of all the operators with their description. Used by the configuration.
AuraFrames.OrderOperatorDescriptions = {
  First = "First",
  Last = "Last",
  NumberAsc = "Ascending",
  NumberDesc = "Descending",
  ListAsc = "Ascending using list",
  ListDesc = "Descending using list",
};


-- List of all the operators per value type. Used by the expresion builder and the configuration.
AuraFrames.OrderTypeOperators = {
  String = {
    "First",
    "Last",
  },
  Number = {
    "First",
    "Last",
    "NumberAsc",
    "NumberDesc",
  },
  Float = {
    "First",
    "Last",
    "NumberAsc",
    "NumberDesc",
  },
  Boolean = {
    "First",
    "Last",
  },
  List = {
    "ListAsc",
    "ListDesc",
  },
  SpellName = {
    "First",
    "Last",
    "ListAsc",
    "ListDesc",
  },
  SpellId = {
    "First",
    "Last",
    "ListAsc",
    "ListDesc",
  },
  ItemName = {
    "First",
    "Last",
    "ListAsc",
    "ListDesc",
  },
  ItemId = {
    "First",
    "Last",
    "ListAsc",
    "ListDesc",
  },
};


-----------------------------------------------------------------
-- Function NewOrder
-----------------------------------------------------------------
function AuraFrames:NewOrder(Config, NotifyFunc)

  local Order = {};
  setmetatable(Order, { __index = AuraFrames.OrderPrototype});
  
  Order.Compare = nil;
  
  Order.Config = Config;
  
  Order:Build();
  
  Order.NotifyFunc = NotifyFunc;
  
  return Order;

end


-----------------------------------------------------------------
-- Function GetDatabaseDefaultOrder
-----------------------------------------------------------------
function AuraFrames:GetDatabaseDefaultOrder()

  return {
    Expert = false,
    Predefined = "NoTimeTimeLeftDesc",
    Rules = {},
  };

end


-----------------------------------------------------------------
-- Function BuildExpresion
-----------------------------------------------------------------
local function BuildExpresion(Type, Operator, Subject, Args)

  local SubjectCode;
  
  if AuraFrames.AuraDefinition[Subject].Code then
    SubjectCode = "do local Object = Object1; Value1 = "..AuraFrames.AuraDefinition[Subject].Code.."; end; do local Object = Object2; Value2 = "..AuraFrames.AuraDefinition[Subject].Code.."; end;";
  else
    SubjectCode = "Value1 = Object1."..Subject.."; Value2 = Object2."..Subject..";";
  end

  if Args.List and (Operator == "ListAsc" or Operator == "ListDesc") then

    local List = "";

    for Index, Value in ipairs(Args.List) do

      if List ~= "" then
        List = List..", ";
      end
      
      List = List.."["..AuraFrames:BuildValue(Type, Value).."] = "..Index;

    end

      return SubjectCode.."if Value1 ~= Value2 then local List = {"..List.."}; return (List[Value1] or "..(#Args.List + 1)..") "..OrderOperatorMappings[Operator].." (List[Value2] or "..(#Args.List + 1).."); end;";

  elseif Type == "String" or Type == "SpellName" or Type == "ItemName" then
  
    if (Operator == "First" or Operator == "Last") and Args[Type] then
    
      return SubjectCode.." if (Value1 "..OrderOperatorMappings[Operator].." "..AuraFrames:BuildValue(Type, Args[Type])..") ~= (Value2 "..OrderOperatorMappings[Operator].." "..AuraFrames:BuildValue(Type, Args[Type])..") then return Value1 "..OrderOperatorMappings[Operator].." "..AuraFrames:BuildValue(Type, Args[Type]).."; end;";
    
    else
    
      return nil;
    
    end
    
  elseif Type == "Number" or Type == "Float" or Type == "SpellId" or Type == "ItemId" then
    
    if (Operator == "First" or Operator == "Last") and Args[Type] then
    
      return SubjectCode.." if (Value1 "..OrderOperatorMappings[Operator].." "..AuraFrames:BuildValue(Type, Args[Type])..") ~= (Value2 "..OrderOperatorMappings[Operator].." "..AuraFrames:BuildValue(Type, Args[Type])..") then return Value1 "..OrderOperatorMappings[Operator].." "..AuraFrames:BuildValue(Type, Args[Type]).."; end;";
    
    elseif (Operator == "NumberAsc" or Operator == "NumberDesc") then
    
      return SubjectCode.." if Value1 ~= Value2 then return Value1 "..OrderOperatorMappings[Operator].." Value2; end;";
    
    else
    
      return nil;
    
    end
  
  elseif Type == "Boolean" then
  
    if (Operator == "First" or Operator == "Last") and Args[Type] then
    
      return SubjectCode.." if Value1 ~= Value2 then return Value1 "..OrderOperatorMappings[Operator].." "..AuraFrames:BuildValue(Type, Args[Type]).."; end;";
      
    else
    
      return nil;
    
    end
    
  else
  
    return nil;
  
  end

end


-----------------------------------------------------------------
-- Function Build
-----------------------------------------------------------------
function AuraFrames.OrderPrototype:Build()

  if not self.Config.Expert or self.Config.Expert == false then
    
    if self.Config.Predefined and AuraFrames.OrderPredefined[self.Config.Predefined] then
    
      self.Config.Rules = AuraFrames.OrderPredefined[self.Config.Predefined].Rules;
    
    else
    
      self.Config.Rules = {};
    
    end
  
  end

  local Rules = {};
  
  for _, Value in ipairs(self.Config.Rules or {}) do
  
    if AuraFrames.AuraDefinition[Value.Subject] ~= nil and not (Value.Disabled and Value.Disabled == true) and Value.Operator then
    
      tinsert(Rules, BuildExpresion(AuraFrames.AuraDefinition[Value.Subject].Type, Value.Operator, Value.Subject, Value.Args or {}));
    
    end
  
  end

  local Code = "return function(Object1, Object2) local Value1, Value2; "..tconcat(Rules, " ").." return Object1.Name > Object2.Name; end;";

  local Function, ErrorMessage = loadstring(Code);
  
  if Function then
  
    self.Compare = Function();
    self:UpdateAll();
    return true;
    
  else
    
    self.Compare = nil;
    
    AuraFrames:Print("An error occurred while building the order function, please contact the addon author with the following information:");
    AuraFrames:Print("Generated Code: "..Code);
    AuraFrames:Print("Error Message: "..ErrorMessage);
    return false;
  
  end

end


-----------------------------------------------------------------
-- Function Find
-----------------------------------------------------------------
function AuraFrames.OrderPrototype:Find(Item)

  for Index, Value in ipairs(self) do
  
    if Value == Item then
      return Index;
    end
  
  end

  return nil;

end

-----------------------------------------------------------------
-- Function UpdateAll
-----------------------------------------------------------------
function AuraFrames.OrderPrototype:UpdateAll()

  -- Sort the list using the default sort function.
  if self.Compare then
    
    sort(self, self.Compare);
    
    for Index, Item in ipairs(self) do
      self.NotifyFunc(Item, Index);
    end
    
  end

end


-----------------------------------------------------------------
-- Function Reset
-----------------------------------------------------------------
function AuraFrames.OrderPrototype:Reset()

  -- Remove all items

  while self[1] do
    tremove(self, 1);
  end

end


-----------------------------------------------------------------
-- Function Add
-----------------------------------------------------------------
function AuraFrames.OrderPrototype:Add(Item)

  if tContains(self, Item) then
    self:Update(Item, true);
    return;
  end

  if self.Compare then
    for i = 1, #self do
    
      if self.Compare(Item, self[i]) == true then
        tinsert(self, i, Item);
        
        for j = i, #self do
          self.NotifyFunc(self[j], j);
        end
        
        return;
      end
    
    end
  end
  
  tinsert(self, Item);
  self.NotifyFunc(Item, #self);

end


-----------------------------------------------------------------
-- Function Remove
-----------------------------------------------------------------
function AuraFrames.OrderPrototype:Remove(Item)

  local Index = self:Find(Item);
  
  if Index ~= nil then
  
    tremove(self, Index);
    
    for i = Index, #self do
      self.NotifyFunc(self[i], i);
    end
    
  end

end


-----------------------------------------------------------------
-- Function Update
-----------------------------------------------------------------
function AuraFrames.OrderPrototype:Update(Item, Force)

  if not self.Compare then
    return;
  end

  local Index = self:Find(Item);
  
  if Index == nil then
    return;
  end
  

  -- The item need to be moved up in the list.
  if Index ~= 1 and self.Compare(Item, self[Index - 1]) == true then
  
    tremove(self, Index);
    
    for i = 1, Index - 1 do
    
      if self.Compare(Item, self[i]) == true then
      
        tinsert(self, i, Item);
        
        for j = i, Index do
          self.NotifyFunc(self[j], j);
        end
        
        return;
        
      end
    
    end
    
    return;

  end
  
  -- The item need to be moved down in the list.
  if Index ~= #self and self.Compare(Item, self[Index + 1]) == false then

    tremove(self, Index);
    
    for i = Index + 1, #self do
    
      if self.Compare(Item, self[i]) == true then
      
        tinsert(self, i, Item);
        
        for j = Index, #self do
          self.NotifyFunc(self[j], j);
        end
        
        return;
        
      end
    
    end
    
    tinsert(self, Item);
    
    for j = Index, #self do
      self.NotifyFunc(self[j], j);
    end
    
    return;
    
  end

  if Force == true then
    self.NotifyFunc(Item, Index);
  end
  
  return;

end
