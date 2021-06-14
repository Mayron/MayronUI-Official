-- luacheck: ignore MayronUI self 143
local _, namespace = ...;

local obj = namespace.components.Objects; ---@type MayronObjects
local tk = namespace.components.Toolkit; ---@type Toolkit

tk.Strings = {};

tk.Strings.Empty = "";
tk.Strings.Space = " ";

local CreateColor = _G.CreateColor;
local string, table, tostring, type = _G.string, _G.table, _G.tostring, _G.type;
local select, UnitClass, UnitIsTapDenied = _G.select, _G.UnitClass, _G.UnitIsTapDenied;
-----------------------------

do
    local function split(char)
        return tk.Strings.Space .. char;
    end

    local function trim1(s)
        return (s:gsub("^%s*(.-)%s*$", "%1"));
    end

    function tk.Strings:SplitByCamelCase(str)
        return trim1(str:gsub("[A-Z]", split):gsub("^.", string.upper));
    end
end

function tk.Strings:Contains(fullString, subString)
    if (string.match(fullString, subString)) then
        return true;
    else
        return false;
    end
end

function tk.Strings:StartsWith(strValue, start)
    return strValue:sub(1, #start) == start;
end

function tk.Strings:GeneratePathLengthPattern(totalKeys)
    local pattern = "^";

    for i = 1, totalKeys do
        if (i < totalKeys) then
            pattern = pattern .. "[^.]+%.";
        else
            pattern = pattern .. "[^.]+";
        end
    end

    pattern = pattern .. "$";
    return pattern;
end

function tk.Strings:EndsWith(strValue, ending)
    return strValue:sub(-#ending) == ending;
end

function tk.Strings:GetStringBetween(strValue, firstPart, secondPart)
    local pattern = string.format("%s%s%s", firstPart, "(.-)", secondPart);
    return string.match(strValue, pattern);
end

function tk.Strings:IsNilOrWhiteSpace(strValue)
  if (strValue == nil) then
    return true;
  end

  tk:Assert(obj:IsString(strValue),
    "tk.Strings.IsNilOrWhiteSpace - bad argument #1 (string expected, got %s)", type(strValue));

  strValue = strValue:gsub("%s+", "");

  if (#strValue > 0) then
    return false;
  end

  return true;
end

function tk.Strings:SetOverflow(str, maxChars)
  if (#str > maxChars) then
    str = string.sub(str, 1, maxChars);
    str = string.join(self.Empty, str:trim(), "...");
  end

  return str;
end

function tk.Strings:RemoveColorCode(str)
    return string.gsub(str, "^|c" .. ('%w'):rep(8) .. "(.-)|r(.*)", "%1%2")
end

-- adds comma's to big numbers for easy readability for the player
function tk.Strings:FormatReadableNumber(number)
    number = tostring(number);
    return string.gsub(number, "^(-?%d+)(%d%d%d)", '%1,%2');
end

--@param text - any text you wish to colour code
function tk.Strings:SetTextColorByHex(text, hex)
    return string.format("|cff%s%s|r", hex, text);
end

function tk.Strings:SetTextColorByClassFilename(text, classFilename)
  text = text or classFilename;
  classFilename = classFilename or tk:GetClassFilenameByUnitID("player");

  classFilename = classFilename:gsub("%s+", tk.Strings.Empty);
  classFilename = classFilename:upper();

  local classColor = _G.GetClassColorObj(classFilename);
  return classColor:WrapTextInColorCode(text);
end
function tk.Strings:SetTextColorByTheme(text)
  local themeColor = tk:GetThemeColor(true);
  return themeColor:WrapTextInColorCode(text);
end

function tk.Strings:SetTextColorByRGB(text, r, g, b)
    if (not (r and g and b)) then return text; end
    local color = CreateColor(r, g, b);
    return color:WrapTextInColorCode(text);
end

function tk.Strings:SetTextColorByKey(text, colorKey)
  return tk.Constants.COLORS[colorKey:upper()]:WrapTextInColorCode(text);
end

function tk.Strings:Concat(...)
  local wrapper = obj:PopTable(...);
  local value = table.concat(wrapper, tk.Strings.Empty);
  obj:PushTable(wrapper);
  return value;
end

function tk.Strings:Split(str, seperator, sectionNum)
  if (sectionNum) then
    return (select(sectionNum, string.split(seperator, str)));
  else
    return string.split(seperator, str);
  end
end

function tk.Strings:Join(separator, ...)
  local wrapper = obj:PopTable(...);

  tk:Assert(#wrapper > 0, "List of values to join cannot be empty.");

  local value = table.concat(wrapper, separator);
  obj:PushTable(wrapper);

  return value;
end

function tk.Strings:JoinWithSpace(...)
  return tk.Strings:Join(tk.Strings.Space, ...);
end

-- also includes level at the end
local UnitName, UnitLevel, UnitClassification, tonumber, UnitIsPlayer, UnitAffectingCombat, IsResting,
UnitIsConnected, UnitIsAFK, UnitIsDND, UnitReaction = _G.UnitName, _G.UnitLevel, _G.UnitClassification, _G.tonumber,
  _G.UnitIsPlayer, _G.UnitAffectingCombat, _G.IsResting, _G.UnitIsConnected, _G.UnitIsAFK, _G.UnitIsDND, _G.UnitReaction;

function tk.Strings:GetUnitNameText(unitID)
  local unitName = tk.Strings:SetOverflow(UnitName(unitID), 22);

  if (unitID:lower() == "player") then
    if (UnitAffectingCombat("player")) then
      unitName = tk.Strings:SetTextColorByRGB(unitName, 1, 0, 0);

    elseif (IsResting()) then
      unitName = tk.Strings:SetTextColorByRGB(unitName, 0, 1, 1);
    else
      local _, class = UnitClass(unitID);
      unitName = tk.Strings:SetTextColorByClassFilename(unitName, class);
    end
  elseif (UnitIsPlayer(unitID)) then
    local _, class = UnitClass(unitID);
    unitName = tk.Strings:SetTextColorByClassFilename(unitName, class);
  else
    local r, g, b = 1, 1, 1;

    if (UnitIsTapDenied(unitID)) then
      r, g, b = 0.5, 0.5, 0.5;
    else
      local reaction = UnitReaction(unitID, "player");

      if (reaction) then
        r = tk.Constants.FACTION_BAR_COLORS[reaction].r;
        g = tk.Constants.FACTION_BAR_COLORS[reaction].g;
        b = tk.Constants.FACTION_BAR_COLORS[reaction].b;
      end
    end

    unitName = tk.Strings:SetTextColorByRGB(unitName, r, g, b);
  end

  return unitName;
end

function tk.Strings:GetUnitLevelText(unitID, unitLevel)
  unitLevel = unitLevel or UnitLevel(unitID);

  if (unitID:lower() == "player") then
    unitLevel = tk.Strings:SetTextColorByRGB(unitLevel, 1, 0.8, 0);
  else
    local classification = UnitClassification(unitID);

    if (tonumber(unitLevel) < 1) then
      unitLevel = "boss";
    elseif (classification == "elite" or classification == "rareelite") then
      unitLevel = tostring(unitLevel).."+";
    end

    if (classification == "rareelite" or classification == "rare") then
      unitLevel = tk.Strings:Concat("|cffff66ff", unitLevel, "|r");
    end

    if (classification == "worldboss" or unitLevel == "boss") then
      unitLevel = tk.Strings:SetTextColorByKey(unitLevel, "yellow");
    else
      local color = tk:GetDifficultyColor(UnitLevel(unitID));
      unitLevel = tk.Strings:SetTextColorByRGB(unitLevel, color.r, color.g, color.b);
    end
  end

  return unitLevel;
end

function tk.Strings:GetUnitStatusText(unitID)
  if (UnitIsPlayer(unitID)) then
    local status = (not UnitIsConnected(unitID) and " <DC>")
      or (UnitIsAFK(unitID) and " <AFK>")
      or (UnitIsDND(unitID) and " <DND>");

      return status;
  end
end

function tk.Strings:GetUnitFullNameText(unitID, unitLevel)
  local unitName = self:GetUnitNameText(unitID);
  unitLevel = self:GetUnitLevelText(unitID, unitLevel);
  local unitStatus = self:GetUnitStatusText(unitID);

  return string.format("%s %s%s", unitName, unitLevel, unitStatus or "");
end