-- luacheck: ignore self
local _G = _G;
local MayronUI = _G.MayronUI;

---@class Toolkit
local tk, _, _, _, obj = MayronUI:GetCoreComponents(); ---@type Toolkit

tk.Strings = {};
tk.Strings.Empty = "";
tk.Strings.Space = " ";

local CreateColor, ipairs = _G.CreateColor, _G.ipairs;
local string, table, tostring, type = _G.string, _G.table, _G.tostring, _G.type;
local select, UnitClass, UnitIsTapDenied = _G.select, _G.UnitClass, _G.UnitIsTapDenied;

function tk.Strings:Trim(str)
  return str:match("^%s*(.-)%s*$");
end

do
  local function split(char)
    return tk.Strings.Space .. char;
  end

  function tk.Strings:SplitByCamelCase(str)
    return self:Trim(str:gsub("[A-Z]", split):gsub("^.", string.upper));
  end
end

function tk.Strings:RemoveWhiteSpace(str)
  return str:gsub("%s+", tk.Strings.Empty);
end

function tk.Strings:Contains(fullString, subString)
  if (not (obj:IsString(fullString) and obj:IsString(subString))) then
    return false;
  end

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

function tk.Strings:SetTextColorByClassFileName(text, classFileName)
  text = text or classFileName;
  classFileName = classFileName or tk:GetClassFileNameByUnitID("player");
  classFileName = classFileName:gsub("%s+", tk.Strings.Empty):upper();

  local classColor = _G.GetClassColorObj(classFileName);
  return classColor:WrapTextInColorCode(text);
end

function tk.Strings:SetTextColorByTheme(text)
  local themeColor = tk:GetThemeColorMixin();
  return themeColor:WrapTextInColorCode(text);
end

function tk.Strings:SetTextColorByRGB(text, r, g, b)
  if (not (r and g and b)) then return text; end
  local color = CreateColor(r, g, b);
  return color:WrapTextInColorCode(text);
end

---@param text string
---@param colorKey MayronUI.ColorKey
---@return string
function tk.Strings:SetTextColorByKey(text, colorKey)
  local color = tk.Constants.COLORS[colorKey:upper()];
  return color:WrapTextInColorCode(text);
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
  local wrapper;

  if (obj:IsTable((select(1, ...)))) then
    wrapper = (select(1, ...));
  else
    wrapper = obj:PopTable(...);
  end

  tk:Assert(#wrapper > 0, "List of values to join cannot be empty.");

  local value = table.concat(wrapper, separator);
  obj:PushTable(wrapper);

  return value;
end

function tk.Strings:JoinWithSpace(...)
  return tk.Strings:Join(tk.Strings.Space, ...);
end

-- also includes level at the end
local UnitFullName, UnitLevel, UnitClassification, tonumber, UnitIsPlayer, UnitAffectingCombat, IsResting,
UnitIsConnected, UnitIsAFK, UnitIsDND, UnitReaction = _G.UnitFullName, _G.UnitLevel,
_G.UnitClassification, _G.tonumber, _G.UnitIsPlayer, _G.UnitAffectingCombat, _G.IsResting,
_G.UnitIsConnected, _G.UnitIsAFK,   _G.UnitIsDND, _G.UnitReaction;

function tk.Strings:GetUnitNameText(unitID, overflow, includeRealmName)
  local unitName, realm = UnitFullName(unitID);
  unitID = (unitID or ""):lower();

  if (unitID ~= "player" and includeRealmName and obj:IsString(realm) and not tk.Strings:IsNilOrWhiteSpace(realm)) then
    unitName = unitName.."-"..realm;
  end

  if (overflow) then
    unitName = tk.Strings:SetOverflow(unitName, overflow);
  end

  if (unitID == "player") then
    if (UnitAffectingCombat("player")) then
      unitName = tk.Strings:SetTextColorByRGB(unitName, 1, 0, 0);

    elseif (IsResting()) then
      unitName = tk.Strings:SetTextColorByRGB(unitName, 0, 1, 1);
    else
      local _, class = UnitClass(unitID);
      unitName = tk.Strings:SetTextColorByClassFileName(unitName, class);
    end
  elseif (UnitIsPlayer(unitID)) then
    local _, class = UnitClass(unitID);
    unitName = tk.Strings:SetTextColorByClassFileName(unitName, class);
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

do
  local goldIcon = "|TInterface\\MoneyFrame\\UI-GoldIcon:12:12:0:0|t";
  local silverIcon = "|TInterface\\MoneyFrame\\UI-SilverIcon:12:12:0:0|t";
  local copperIcon = "|TInterface\\MoneyFrame\\UI-CopperIcon:12:12:0:0|t";

  ---@param money number
  ---@param colorKey MayronUI.ColorKey?
  function tk.Strings:GetFormattedMoney(money, colorKey)
    local text = "";
    local gold = math.floor(math.abs(money / 10000));
    local silver = math.floor(math.abs((money / 100) % 100));
    local copper = math.floor(math.abs(money % 100));

    colorKey = colorKey or "WHITE";

    if (gold > 0) then
      if (tonumber(gold) >= 1000) then
        local goldFormatted = string.gsub(gold, "^(-?%d+)(%d%d%d)", '%1,%2');
        return self:SetTextColorByKey(goldFormatted .. goldIcon, colorKey);
      else
        text = gold .. goldIcon;
      end
    end

    if (silver > 0) then
      text = string.format("%s %s%s", text, silver, silverIcon);
    end

    if (gold < 100 and copper > 0) then
      text = string.format("%s %s%s", text, copper, copperIcon);
    end

    if (text == "") then
      text = string.format("%d%s", 0, goldIcon);
      text = string.format("%s %d%s", text, 0, silverIcon);
      text = string.format("%s %d%s", text, 0, copperIcon);
    end

    return self:SetTextColorByKey(text, colorKey);
  end
end

function tk.Strings:GetUnitStatusText(unitID)
  if (UnitIsPlayer(unitID)) then
    local status = (not UnitIsConnected(unitID) and " <DC>")
    or (UnitIsAFK(unitID) and " <AFK>")
    or (UnitIsDND(unitID) and " <DND>");

    return status;
  end
end

function tk.Strings:GetUnitFullNameText(unitID, unitLevel, nameOverflow, includeRealName)
  local unitName = self:GetUnitNameText(unitID, nameOverflow, includeRealName);
  unitLevel = self:GetUnitLevelText(unitID, unitLevel);
  local unitStatus = self:GetUnitStatusText(unitID);

  return string.format("%s %s%s", unitName, unitLevel, unitStatus or "");
end

function tk.Strings:Replace(msg, word, replacement)
  local query = msg:lower();
  word = word:lower();
  local offset = 0;
  local found = 0;

  while (query:find(word)) do
    local startId, endId = query:find(word);

    local pre = msg:sub(0, startId - 1 + offset) -- everything before
    local post = msg:sub(endId + 1 + offset, #msg); -- everything after

    query = post:lower();
    offset = (#(pre .. replacement));

    msg = pre .. replacement .. post;
    found = found + 1;
  end

  return msg, found;
end

local function GetStartAndEnd(query, word)
  if (obj:IsTable(word)) then
    local startId, endId;
    local smallestStartId, smallestEndId;

    for _, w in ipairs(word) do
      startId, endId = query:find(w:lower());

      if (startId and endId) then
        if (not smallestStartId or startId < smallestStartId) then
          smallestStartId = startId;
          smallestEndId = endId;
        elseif (smallestStartId and smallestStartId == startId and smallestEndId < endId) then
          smallestEndId = endId;
        end
      end
    end

    return smallestStartId, smallestEndId;
  end

  return query:find(word:lower());
end

function tk.Strings:HighlightSubStringsByRGB(msg, word, upperCase, r, g, b)
  local query = msg:lower();
  local offset = 0;

  while (true) do
    local startId, endId = GetStartAndEnd(query, word);
    if (not (startId and endId)) then break end

    local pre = msg:sub(0, startId - 1 + offset) -- everything before
    local found = msg:sub(startId + offset, endId + offset);
    found = tk.Strings:SetTextColorByRGB(upperCase and found:upper() or found, r, g, b);
    local post = msg:sub(endId + 1 + offset, #msg); -- everything after

    query = post:lower();
    offset = (#(pre .. found));

    msg = pre .. found .. post;
  end

  return msg, offset > 0;
end