-- luacheck: ignore MayronUI self 143
local _, namespace = ...;

local obj = namespace.components.Objects; ---@type LibMayronObjects
local tk = namespace.components.Toolkit; ---@type Toolkit

tk.Strings = {};

tk.Strings.Empty = "";
tk.Strings.Space = " ";

local _G = _G;
local string, table, tostring, type = _G.string, _G.table, _G.tostring, _G.type;
local select, UnitClass = _G.select, _G.UnitClass;
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

function tk.Strings:SetTextColorByClass(text, className)
    text = text or className;
    className = className or (select(2, UnitClass("player")));

    className = className:gsub("%s+", tk.Strings.Empty);
    className = className:upper();

    local classColor = tk:GetClassColor(className);
    return classColor:WrapTextInColorCode(text);
end

function tk.Strings:SetTextColorByTheme(text)
    local themeColor = tk:GetThemeColor(true);
    return themeColor:WrapTextInColorCode(text);
end

function tk.Strings:SetTextColorByRGB(text, r, g, b)
    local color = _G.CreateColor(r, g, b);
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

function tk.Strings:GetSection(str, seperator, sectionNum)
    return (select(sectionNum, string.split(seperator, str)));
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