local _, core = ...;
core.Toolkit = core.Toolkit or {};

local tk = core.Toolkit;
tk.Strings = {};

tk.Strings.Empty = "";
-----------------------------

do
    local function split(char)
        return " " .. char
    end

    local function trim1(s)
        return (s:gsub("^%s*(.-)%s*$", "%1"))
    end

    function tk.Strings:SplitByCamelCase(str)
        return trim1(str:gsub("[A-Z]", split):gsub("^.", string.upper))
    end
end

function tk.Strings:Contains(fullString, subString)
    if (string.match(fullString, subString)) then
        return true;
    else
        return false;
    end
end

function tk.Strings:SetOverflow(str, maxChars)
    if (#str > maxChars) then
        str = string.sub(str, 1, maxChars);
        str = string.join(self.Empty, str, "...");
    end

    return str;
end

function tk.Strings:RemoveColorCode(str)
    return string.gsub(str, "^|c" .. ('%w'):rep(8) .. "(.-)|r(.*)", "%1%2")
end

-- adds comma's to big numbers for easy readability for the player
function tk.Strings:FormatReadableNumber(number)
    number = tostring(number);
    return tk.string.gsub(number, "^(-?%d+)(%d%d%d)", '%1,%2');
end

--@param text - any text you wish to colour code
function tk.Strings:GetHexColoredText(text, hex)    
    return string.format("|cff%s%s|r", hex, text);
end

function tk.Strings:GetRGBColoredText(text, r, g, b)
    r = r * 255; g = g * 255; b = b * 255;
    local hex = string.format("%02x%02x%02x", r, g, b):upper();
    return self:GetHexColoredText(text, hex);
end

function tk.Strings:GetThemeColoredText(text)
    local r, g, b = tk:GetThemeColor();
    return self:GetRGBColoredText(text, r, g, b);
end

function tk.Strings:GetClassColoredText(className, text)
    className = className or (select(2, UnitClass("player")));
    text = text or className;

    className = className:gsub("%s+", tk.Strings.Empty);
    className = string.upper(className);

    return self:GetHexColoredText(text, tk.Constants.CLASS_RGB_COLORS[className].hex);
end

function tk.Strings:Concat(...) 
    local wrapper = tk.Tables:PopWrapper(...);
    local value = table.concat(wrapper, tk.Strings.Empty);
    tk.Tables:PushWrapper(wrapper);
    return value;
end

function tk.Strings:Join(separator, ...)
    local wrapper = tk.Tables:PopWrapper(...);
    local value = table.concat(wrapper, separator);
    tk.Tables:PushWrapper(wrapper);
    return value;
end