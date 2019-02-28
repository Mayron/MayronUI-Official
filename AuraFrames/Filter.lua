local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

-- Import used global references into the local namespace.
local tinsert, tremove, tconcat, sort = tinsert, tremove, table.concat, sort;
local fmt, tostring = string.format, tostring;
local select, pairs, ipairs, next, type, unpack = select, pairs, ipairs, next, type, unpack;
local loadstring, assert, error = loadstring, assert, error;
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget;
local GetTime = GetTime;
local tolower, toupper = string.lower, string.upper;

AuraFrames.FilterPrototype = {};


-- Internal list for converting operator keys to lua code.
local FilterOperatorMappings = {
  Equal           = "==",
  NotEqual        = "~=",
  Greater         = ">",
  GreaterOrEqual  = ">=",
  Lesser          = "<",
  LesserOrEqual   = "<=",
  InList          = "==",
  NotInList       = "~=",
};


-- List of all the operators per value type. Used by the expresion builder and the configuration.
AuraFrames.FilterTypeOperators = {
  String = {
    "Equal",
    "NotEqual",
    "InList",
    "NotInList"
  },
  Number = {
    "Equal",
    "NotEqual",
    "Greater",
    "GreaterOrEqual",
    "Lesser",
    "LesserOrEqual",
    "InList",
    "NotInList"
  },
  Float = {
    "Equal",
    "NotEqual",
    "Greater",
    "GreaterOrEqual",
    "Lesser",
    "LesserOrEqual",
    "InList",
    "NotInList"
  },
  Boolean = {
    "Equal",
  },
  SpellName = {
    "Equal",
    "NotEqual",
    "InList",
    "NotInList"
  },
  SpellId = {
    "Equal",
    "NotEqual",
    "InList",
    "NotInList"
  },
  ItemName = {
    "Equal",
    "NotEqual",
    "InList",
    "NotInList"
  },
  ItemId = {
    "Equal",
    "NotEqual",
    "InList",
    "NotInList"
  },
};


-----------------------------------------------------------------
-- Function BuildExpresion
-----------------------------------------------------------------
local function BuildExpresion(Type, Operator, Subject, Args)

  local SubjectCode;
  
  if AuraFrames.AuraDefinition[Subject].Code then
    SubjectCode = AuraFrames.AuraDefinition[Subject].Code;
  else
    SubjectCode = "Object."..Subject;
  end

  if Type == "String" or Type == "SpellName" or Type == "ItemName" then
  
    if (Operator == "Equal" or Operator == "NotEqual") and Args[Type] then
      
      return "string.lower("..SubjectCode.." or \"\") "..FilterOperatorMappings[Operator].." "..tolower(AuraFrames:BuildValue("String", Args[Type]));
      
    elseif (Operator == "InList" or Operator == "NotInList") and Args.List then
    
      local List = "";

      for Index, Value in ipairs(Args.List) do

        if List ~= "" then
          List = List..", ";
        end
        
        List = List..tolower(AuraFrames:BuildValue("String", Value));

      end
    
      return "tContains({"..List.."}, string.lower("..SubjectCode.." or \"\")) "..FilterOperatorMappings[Operator].." true";
    
    else
    
      return nil;
    
    end
    
  elseif Type == "Number" or Type == "Float" or Type == "SpellId" or Type == "ItemId" then
  
    if (Operator == "Equal" or Operator == "NotEqual" or Operator == "Greater" or Operator == "GreaterOrEqual" or Operator == "Lesser" or Operator == "LesserOrEqual") and Args[Type] then
      
      return SubjectCode.." "..FilterOperatorMappings[Operator].." "..AuraFrames:BuildValue("Number", Args[Type]);
    
    elseif (Operator == "InList" or Operator == "NotInList") and Args.List then
    
      local List = "";

      for Index, Value in ipairs(Args.List) do

        if List ~= "" then
          List = List..", ";
        end
        
        List = List..AuraFrames:BuildValue("Number", Value);

      end
    
      return "tContains({"..List.."}, "..SubjectCode..") "..FilterOperatorMappings[Operator].." true";

    else
    
      return nil;
    
    end
  
  elseif Type == "Boolean" then
  
    if (Operator == "Equal" or Operator == "NotEqual") and Args[Type] then
      
      return SubjectCode.." "..FilterOperatorMappings[Operator].." "..AuraFrames:BuildValue("Boolean", Args[Type]);
      
    else
    
      return nil;
    
    end
  
  else
  
    return nil;
  
  end

end


-----------------------------------------------------------------
-- Function BuildStatement
-----------------------------------------------------------------
function AuraFrames:BuildFilterStatement(Config, Default)

  local Dynamic = false;
  local Groups = {};

  for _, Group in ipairs(Config) do
  
    if not (Group.Disabled and Group.Disabled == true) then
  
      local Rules = {};
      
      for _, Value in ipairs(Group) do
      
        if AuraFrames.AuraDefinition[Value.Subject] ~= nil and not (Value.Disabled and Value.Disabled == true) and Value.Operator then
        
          -- Update static flag.
          Dynamic = Dynamic or AuraFrames.AuraDefinition[Value.Subject].Dynamic or false;
        
          -- Build and insert rule.
          tinsert(Rules, BuildExpresion(AuraFrames.AuraDefinition[Value.Subject].Type, Value.Operator, Value.Subject, Value.Args or {}));
        
        end
      
      end
    
      if #Rules ~= 0 then
        tinsert(Groups, "("..tconcat(Rules, " and ")..")");
      end
      
    end
  
  end
  
  local Code;
  
  if #Groups == 0 then
    Code = Default and "(true)" or "(false)";
  else
    Code = "("..tconcat(Groups, " or ")..")";
  end
  
  return Code, Dynamic;

end


-----------------------------------------------------------------
-- Function NewFilter
-----------------------------------------------------------------
function AuraFrames:NewFilter(Config, NotifyFunc)

  local Filter = {};
  setmetatable(Filter, { __index = AuraFrames.FilterPrototype});
  
  Filter.Config = Config;
  
  Filter:Build();
  
  Filter.NotifyFunc = NotifyFunc;
  
  return Filter;

end


-----------------------------------------------------------------
-- Function GetDatabaseDefaultFilter
-----------------------------------------------------------------
function AuraFrames:GetDatabaseDefaultFilter()

  return {
    Expert = false,
    Groups = {},
  };

end


-----------------------------------------------------------------
-- Function Build
-----------------------------------------------------------------
function AuraFrames.FilterPrototype:Build()

  local Code;
  
  Code, self.Dynamic = AuraFrames:BuildFilterStatement(self.Config, true);
  
  Code = "return function(Object) return "..Code.."; end;";
  
  local Function, ErrorMessage = loadstring(Code);
  
  if Function then
  
    self.Test = Function();
    return true;
    
  else
    
    self.Test = function(_) return true; end;
    AuraFrames:Print("An error occurred while building the filter function, please contact the addon author with the following information:");
    AuraFrames:Print("Generated Code: "..Code);
    AuraFrames:Print("Error Message: "..ErrorMessage);
    return false;
  
  end

end
