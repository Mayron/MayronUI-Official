local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

-- Import used global references into the local namespace.
local setmetatable, ipairs, loadstring = setmetatable, ipairs, loadstring;

AuraFrames.ColorsPrototype = {};

-----------------------------------------------------------------
-- Function GetDatabaseDefaultColors
-----------------------------------------------------------------
function AuraFrames:GetDatabaseDefaultColors()

  return {
    Expert = false,
    DefaultColor = {1, 1, 1, 1},
    Rules = {
      {
        Name = "Unknown Debuff Type",
        Color = {0.8, 0.0, 0.0, 1.0},
        Groups = {
          {
            {Args = {String = "HARMFUL"}, Subject = "Type", Operator = "Equal"},
            {Args = {String = "None"}, Subject = "Classification", Operator = "Equal"},
          },
        },
      },
      {
        Name = "Debuff Type Magic",
        Color = {0.2, 0.6, 1.0, 1.0},
        Groups = {
          {
            {Args = {String = "HARMFUL"}, Subject = "Type", Operator = "Equal"},
            {Args = {String = "Magic"}, Subject = "Classification", Operator = "Equal"},
          },
        },
      },
      {
        Name = "Debuff Type Curse",
        Color = {0.6, 0.0, 1.0, 1.0},
        Groups = {
          {
            {Args = {String = "HARMFUL"}, Subject = "Type", Operator = "Equal"},
            {Args = {String = "Curse"}, Subject = "Classification", Operator = "Equal"},
          },
        },
      },
      {
        Name = "Debuff Type Disease",
        Color = {0.6, 0.4, 0.0, 1.0},
        Groups = {
          {
            {Args = {String = "HARMFUL"}, Subject = "Type", Operator = "Equal"},
            {Args = {String = "Disease"}, Subject = "Classification", Operator = "Equal"},
          },
        },
      },
      {
        Name = "Debuff Type Poison",
        Color = {0.0, 0.6, 0.0, 1.0},
        Groups = {
          {
            {Args = {String = "HARMFUL"}, Subject = "Type", Operator = "Equal"},
            {Args = {String = "Poison"}, Subject = "Classification", Operator = "Equal"},
          },
        },
      },
      {
        Name = "Buff",
        Color = {1.0, 1.0, 1.0, 1.0},
        Groups = {
          {
            {Args = {String = "HELPFUL"}, Subject = "Type", Operator = "Equal"},
          },
        },
      },
      {
        Name = "Weapon",
        Color = {1.0, 1.0, 1.0, 1.0},
        Groups = {
          {
            {Args = {String = "WEAPON"}, Subject = "Type", Operator = "Equal"},
          },
        },
      },
    },
  };

end

-----------------------------------------------------------------
-- Function NewColors
-----------------------------------------------------------------
function AuraFrames:NewColors(Config, NotifyFunc)

  local Colors = {};
  setmetatable(Colors, { __index = AuraFrames.ColorsPrototype});
  
  Colors.Config = Config or {};
  
  Colors:Build();
  
  Colors.NotifyFunc = NotifyFunc;
  
  return Colors;

end

-----------------------------------------------------------------
-- Function Build
-----------------------------------------------------------------
function AuraFrames.ColorsPrototype:Build()

  local Code = "\nif Object.ColorOverride then return Object.ColorOverride; end;";
  
  self.Dynamic = false;
  
  for _, ColorRule in ipairs(self.Config.Rules or {}) do
  
    local StatementCode, StatementDynamic = AuraFrames:BuildFilterStatement(ColorRule.Groups, true);
  
    self.Dynamic = self.Dynamic or StatementDynamic;
    
    Code = Code.."\nif "..StatementCode.." then return {"..ColorRule.Color[1]..","..ColorRule.Color[2]..","..ColorRule.Color[3]..","..ColorRule.Color[4].."}; end;";
  
  end
  
  Code = "return function(Object) "..Code.."\nreturn {"..self.Config.DefaultColor[1]..","..self.Config.DefaultColor[2]..","..self.Config.DefaultColor[3]..","..self.Config.DefaultColor[4].."}; end;";
  
  local Function, ErrorMessage = loadstring(Code);
  
  if Function then
  
    self.Test = Function();
    return true;
    
  else
    
    self.Test = function(_) return {1.0, 1.0, 1.0, 1.0}; end;
    AuraFrames:Print("An error occurred while building the color filter function, please contact the addon author with the following information:");
    AuraFrames:Print("Generated Code: "..Code);
    AuraFrames:Print("Error Message: "..ErrorMessage);
    return false;
  
  end

end
