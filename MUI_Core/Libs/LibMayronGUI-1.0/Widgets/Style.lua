-- luacheck: ignore MayronUI self 143 631
local Lib = _G.LibStub:GetLibrary("LibMayronGUI");

---@type LibMayronGUI
if (not Lib) then return; end

local LibObjectLua = _G.MayronObjects:GetFramework();
local WidgetsPackage = Lib.WidgetsPackage;

---@class Style : Object
local Style = WidgetsPackage:CreateClass("Style");

---@type MayronObjects
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
---@param red number
---@param green boolean
---@param blue boolean
---@param colorName string @(optional) A unique set to assign to the color to be able to retrieve it (defaults to "default").
function Style:SetColor(data, red, green, blue, colorName)
    local color = _G.CreateColor(red, green, blue);
    Setter(data, "color", color, colorName);
end

WidgetsPackage:DefineParams("?string", "?boolean");
WidgetsPackage:DefineReturns("table|number", "?number", "?number");
---@param colorName string @(optional) The name used to identify and get the correct color previously set.
---@param returnTable boolean @(optional) If true, returns the full blizzard color object, else (by default) returns r, g, b, a unpacked values.
---@return Color @A Blizzard Color object  containing the r, g, b color values and a few helper functions, or r, g, b, a unpacked values.
function Style:GetColor(data, colorName, returnTable)
    local color = Getter(data, "color", colorName, _G.HIGHLIGHT_FONT_COLOR);
    if (returnTable) then
        return color;
    else
        return color:GetRGBA();
    end
end

WidgetsPackage:DefineParams("number", "?string");
---@param alpha number @The alpha value (0-1).
---@param name string @(optional) The name used to identify and set the alpha value.
function Style:SetAlpha(data, alpha, name)
    Setter(data, "alpha", alpha, name);
end

WidgetsPackage:DefineParams("?string");
WidgetsPackage:DefineReturns("number");
---@param name string @(optional) The name used to identify and retrieve the alpha value.
---@return number @The found alpha value.
function Style:GetAlpha(data, name)
    return Getter(data, "alpha", name, 1);
end

WidgetsPackage:DefineParams("table", "?string");
---@param backdrop table @The backdrop value.
---@param name string @(optional) The name used to identify and set the backdrop value.
function Style:SetBackdrop(data, backdrop, name)
    Setter(data, "backdrop", backdrop, name);
end

WidgetsPackage:DefineParams("?string");
WidgetsPackage:DefineReturns("?table");
---Does not have a default (nil is returned if missing)
---@param name string @(optional) The name used to identify and retrieve the backdrop value.
---@return table @The backdrop value.
function Style:GetBackdrop(data, name)
    return Getter(data, "backdrop", name);
end

WidgetsPackage:DefineParams("string", "?string");
---@param backdrop string @The texture value.
---@param name string @(optional) The name used to identify and set the texture value.
function Style:SetTexture(data, texture, name)
    Setter(data, "texture", texture, name);
end

WidgetsPackage:DefineParams("?string");
WidgetsPackage:DefineReturns("string");
---@param name string @(optional) The name used to identify and retrieve the texture value.
---@return table @The texture value.
function Style:GetTexture(data, name)
    return Getter(data, "texture", name);
end

WidgetsPackage:DefineParams("number", "number", "number", "number", "?string");
---@param top number @The top padding value.
---@param top number @The right padding value.
---@param top number @The bottom padding value.
---@param top number @The left padding value.
---@param name string @(optional) The name used to identify and set the padding values.
function Style:SetPadding(data, top, right, bottom, left, name)
    Setter(data, "padding", {top, right, bottom, left}, name);
end

WidgetsPackage:DefineParams("?string", "?boolean");
WidgetsPackage:DefineReturns("table");
---@param name string @(optional) The name used to identify and retrieve the padding values.
---@param disableUnpacking boolean @(optional) If true, the table containing padding values will not be unpacked and instead the entire table will be returned.
---@return number, number, number, number @If disableUnpacking is true, a table will be returned instead.
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

---@param colorName string @The name of a color to get (using GetColor) to be applied to all widgets.
---@param alpha number|Frame @(optional) An alpha value to be applied with the color for all widgets.
---@param ... Frame @A variable argument list of widgets (can have alpha value at the start of list)
function Style:ApplyColor(_, colorName, alpha, ...)
    colorName = colorName or "default";

    local r, g, b = self:GetColor(colorName);

    if (obj:IsString(alpha)) then
        alpha = self:GetAlpha(alpha);

    elseif (not (alpha and obj:IsNumber(alpha))) then
        alpha = 1;
    end

    for _, element in obj:IterateArgs(...) do

        LibObjectLua:Assert(obj:IsTable(element) and element.GetObjectType,
            "Style.ApplyColor: Widget expected but received a %s value of %s", type(element), element);

        local objectType = element:GetObjectType();

        if (objectType == "Texture") then
            local id = element:GetTexture();

            if (not id or id == "FileData ID 0") then
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

            if (obj:IsFunction(element.SetBackdropBorderColor)) then
              element:SetBackdropBorderColor(r, g, b, 0.7);
            end

            if (element:GetDisabledTexture()) then
                element:GetDisabledTexture():SetVertexColor(r * 0.3, g * 0.3, b * 0.3, 0.6);
            end

        elseif (objectType == "FontString") then
            element:SetTextColor(r, g, b, alpha);
        end
    end
end