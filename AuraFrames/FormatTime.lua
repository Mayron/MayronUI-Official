local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

-- Import used global references into the local namespace.
local math_floor, math_ceil = math.floor, math.ceil;

--[[

  FormatTimeLeft supported formats:
  
    ABBREV
    ABBREVSPACE
    SEPCOL
    SEPDOT
    SEPCOLEXT
    SEPDOTEXT
    NONE
    NONEEXT

]]--

local Lookup = {

  ABBREV = {
    Day    = "%dd",
    Hour   = "%dh",
    Minute = "%dm",
    Second = "%ds",
  },
  ABBREVSPACE = {
    Day    = "%d d",
    Hour   = "%d h",
    Minute = "%d m",
    Second = "%d s",
  },
  
  SEPCOL = {
    Days    = "%d:%.2d:%.2d:%.2d",
    Hours   = "%d:%.2d:%.2d",
    Minutes = "%d:%.2d",
  },
  SEPDOT = {
    Days    = "%d.%.2d.%.2d.%.2d",
    Hours   = "%d.%.2d.%.2d",
    Minutes = "%d.%.2d",
  },
  
  SEPCOLEXT = {
    Days    = "%d:%.2d:%.2d:%.2d.%.1d",
    Hours   = "%d:%.2d:%.2d.%.1d",
    Minutes = "%d:%.2d.%.1d",
  },
  SEPDOTEXT = {
    Days    = "%d.%.2d.%.2d.%.2d.%.1d",
    Hours   = "%d.%.2d.%.2d.%.1d",
    Minutes = "%d.%.2d.%.1d",
  },

  NONE = "%d",
  NONEEXT = "%d.%.1d",

};

local TranslationToNoExt = {

  SEPCOLEXT = "SEPCOL",
  SEPDOTEXT = "SEPDOT",
  NONEEXT = "NONE",

};

-----------------------------------------------------------------
-- Local Function round
-----------------------------------------------------------------
local function round(x)
  
  return math_floor(x + 0.5);

end


-----------------------------------------------------------------
-- Function FormatTimeLeft
-----------------------------------------------------------------
function AuraFrames:FormatTimeLeft(Format, TimeLeft, HideZero)

  if self.db.profile.EnableTimeExtOverrule and TranslationToNoExt[Format] and TimeLeft >= self.db.profile.TimeExtRequirement then
    Format = TranslationToNoExt[Format];
  end

  local String;

  if Format == "ABBREV" or Format == "ABBREVSPACE" then

    if (TimeLeft >= 86400) then
      return Lookup[Format].Day, round(TimeLeft / 86400);
    end

    if (TimeLeft >= 3600) then
      return Lookup[Format].Hour, round(TimeLeft / 3600);
    end

    if (TimeLeft >= 60) then
      return Lookup[Format].Minute, round(TimeLeft / 60);
    end

    if HideZero == true and TimeLeft < 1 then
      return "";
    else
      return Lookup[Format].Second, TimeLeft;
    end
    
  elseif Format == "SEPCOL" or Format == "SEPDOT" then
  
    local Days, Hours, Minutes, Seconds = math_floor(TimeLeft / 86400), math_floor((TimeLeft % 86400) / 3600), math_floor((TimeLeft % 3600) / 60), TimeLeft % 60;
    
    if Days ~= 0 then
      return Lookup[Format].Days, Days, Hours, Minutes, Seconds;
    elseif Hours ~= 0 then
      return Lookup[Format].Hours, Hours, Minutes, Seconds;
    else
      if HideZero == true and Minutes + Seconds < 1 then
        return "";
      else
        return Lookup[Format].Minutes, Minutes, Seconds;
      end
    end
  
  elseif Format == "SEPCOLEXT" or Format == "SEPDOTEXT" then
  
    local Days, Hours, Minutes, Seconds, Ext = math_floor(TimeLeft / 86400), math_floor((TimeLeft % 86400) / 3600), math_floor((TimeLeft % 3600) / 60), TimeLeft % 60, (TimeLeft % 1) * 10;
    
    if Days ~= 0 then
      return Lookup[Format].Days, Days, Hours, Minutes, Seconds, Ext;
    elseif Hours ~= 0 then
      return Lookup[Format].Hours, Hours, Minutes, Seconds, Ext;
    else
      if HideZero == true and Minutes + Seconds + Ext < 1 then
        return "";
      else
        return Lookup[Format].Minutes, Minutes, Seconds, Ext;
      end
    end
  
  elseif Format == "NONEEXT" then

    local Ext = (TimeLeft % 1) * 10;

    if HideZero == true and TimeLeft < 0.1 then
      return "";
    else
      return Lookup[Format], TimeLeft, Ext;
    end

  else -- NONE or invalid format.
  
    if HideZero == true and TimeLeft < 1 then
      return "";
    else
      return Lookup[Format], TimeLeft;
    end
  
  end

end
