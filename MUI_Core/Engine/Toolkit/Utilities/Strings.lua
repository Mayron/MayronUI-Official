local _, core = ...;
core.Toolkit = core.Toolkit or {};

local tk = core.Toolkit;
-----------------------------

do
    local function split(char)
        return " " .. char
    end

    local function trim1(s)
        return (s:gsub("^%s*(.-)%s*$", "%1"))
    end

    function tk:SplitCamelString(str)
        return trim1(str:gsub("[A-Z]", split):gsub("^.", string.upper))
    end
end

-- removes trailing zeros
function tk:FormatFloat(precision, number)
    return (tk.string.format("%."..precision.."f", number):gsub("%.?0+$", ""));
end

function tk:FormatNumberString(number)
    number = tk.tostring(number);
    return tk.string.gsub(number, "^(-?%d+)(%d%d%d)", '%1,%2');
end

--@param text - any text you wish to colour code
function tk:GetHexColoredText(text, hex)    
    return tk.string.format("|cff%s%s|r", hex:upper(), text);
end

function tk:GetRGBColoredText(text, r, g, b)
    r = r * 255; g = g * 255; b = b * 255;
    local hex = tk.string.format("%02x%02x%02x", r, g, b):upper();
    return self:GetHexColoredText(text, hex);
end

function tk:GetThemeColoredText(text)
    local r, g, b = tk:GetThemeColor();
    return self:GetRGBColoredText(text, r, g, b);
end

function tk:GetClassColoredText(className, text)
    className = className or (tk.select(2, UnitClass("player")));
    text = text or className;

    className = className:gsub("%s+", "");
    className = string.upper(className);

    return self:GetHexColoredText(text, self.Constants.CLASS_RGB_COLORS[className].hex);
end