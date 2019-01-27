-- luacheck: ignore MayronUI self 143 631
local Lib = _G.LibStub:GetLibrary("LibMayronGUI");

if (not Lib) then return end

local LibObjectLua = _G.LibStub:GetLibrary("LibMayronObjects");
local WidgetsPackage = Lib.WidgetsPackage;
local Style = WidgetsPackage:CreateClass("Style");
local obj = Lib.Objects;

-- Local Functions ---------------

local function Getter(data, tblKey, name, defaultValue)
    if (not data[tblKey]) then
        return defaultValue;
    end

    name = name or "default";
    return data[tblKey][name:lower()] or defaultValue;
end

local function Setter(data, tblKey, value, name)
    data[tblKey] = data[tblKey] or obj:PopTable();
    name = name or "default";
    data[tblKey][name:lower()] = value;
end

-- Style Methods ----------------------

WidgetsPackage:DefineParams("number", "number", "number", "?string");
function Style:SetColor(data, red, green, blue, colorName)
    local color = _G.CreateColor(red, green, blue);
    Setter(data, "color", color, colorName);
end

WidgetsPackage:DefineParams("?string", "?boolean");
WidgetsPackage:DefineReturns("table|number", "?number", "?number");
--@param (optional) colorName - the name used to identify and get the correct color previously set
--@param (boolean) returnTable - if true, returns the full blizzard color object, else (by default) returns r, g, b, a unpacked values
--@return - a Blizzard Color object  containing the r, g, b color values and a few helper functions, or r, g, b, a unpacked values
function Style:GetColor(data, colorName, returnTable)
    local color = Getter(data, "color", colorName, _G.HIGHLIGHT_FONT_COLOR);
    if (returnTable) then
        return color;
    else
        return color:GetRGBA();
    end
end

WidgetsPackage:DefineParams("number", "?string");
--@param alpha - the alpha value (0-1)
--@param (optional) name - the name used to identify and set the alpha value
function Style:SetAlpha(data, alpha, name)
    Setter(data, "alpha", alpha, name);
end

WidgetsPackage:DefineParams("?string");
WidgetsPackage:DefineReturns("number");
function Style:GetAlpha(data, name)
    return Getter(data, "alpha", name, 1);
end

WidgetsPackage:DefineParams("table", "?string");
function Style:SetBackdrop(data, backdrop, name)
    Setter(data, "backdrop", backdrop, name);
end

WidgetsPackage:DefineParams("?string");
WidgetsPackage:DefineReturns("?table");
function Style:GetBackdrop(data, name)
    -- does not have a default (nil is returned if missing)
    return Getter(data, "backdrop", name);
end

WidgetsPackage:DefineParams("string", "?string");
function Style:SetTexture(data, texture, name)
    Setter(data, "texture", texture, name);
end

WidgetsPackage:DefineParams("?string");
WidgetsPackage:DefineReturns("string");
function Style:GetTexture(data, name)
    return Getter(data, "texture", name);
end

WidgetsPackage:DefineParams("number", "number", "number", "number", "?string");
function Style:SetPadding(data, top, right, bottom, left, name)
    Setter(data, "padding", {top, right, bottom, left}, name);
end

WidgetsPackage:DefineParams("?string", "?boolean");
WidgetsPackage:DefineReturns("table");
function Style:GetPadding(data, name, disableUnpacking)
    local value = Getter(data, "padding", name, {0, 0, 0, 0});

    if (disableUnpacking) then
        value.top = value[1];
        value.right = value[2];
        value.bottom = value[3];
        value.left = value[4];
        return value;
    end

    return _G.unpack(value);
end

-- @param ... - A variable argument list of widgets (can have alpha value at the start of list)
function Style:ApplyColor(_, colorName, alpha, ...)
    colorName = colorName or "default";

    local r, g, b = self:GetColor(colorName);

    if (type(alpha) == "string") then
        alpha = self:GetAlpha(alpha);

    elseif (not (alpha and type(alpha) == "number")) then
        alpha = 1;
    end

    for _, element in obj:IterateArgs(...) do

        LibObjectLua:Assert(type(element) == "table" and element.GetObjectType,
            "Style.ApplyColor: Widget expected but received a %s value of %s", type(element), element);

        local objectType = element:GetObjectType();

        if (objectType == "Texture") then
            local id = element:GetTexture();

            if (id and (id:match("Color-%a+") or id:match("Interface\\Buttons"))) then
                element:SetColorTexture(r, g, b, alpha);
            else
                element:SetVertexColor(r, g, b, alpha);
            end

        elseif (objectType == "CheckButton") then
            element:GetCheckedTexture():SetColorTexture(r, g, b, alpha);
            element:GetHighlightTexture():SetColorTexture(r, g, b, alpha);

        elseif (objectType == "Button") then
            element:GetNormalTexture():SetVertexColor(r, g, b, alpha);
            element:GetHighlightTexture():SetVertexColor(r, g, b, alpha);

            if (element:GetDisabledTexture()) then
                element:GetDisabledTexture():SetVertexColor(r * 0.3, g * 0.3, b * 0.3, 0.6);
            end

        elseif (objectType == "FontString") then
            element:SetTextColor(r, g, b, alpha);
        end
    end
end