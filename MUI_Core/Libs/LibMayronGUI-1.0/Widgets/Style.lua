local Lib = LibStub:GetLibrary("LibMayronGUI");
if (not Lib) then return; end

local LibObjectLua = LibStub:GetLibrary("LibMayronObjects");
local WidgetsPackage = Lib.WidgetsPackage;
local Private = Lib.Private;

local Style = WidgetsPackage:CreateClass("Style");

-- Local Functions ---------------

local function Getter(data, tblKey, name, defaultValue)
    if (not data[tblKey]) then
        return defaultValue;
    end

    name = name or "default";
    return data[tblKey][name:lower()] or defaultValue;
end

local function Setter(data, tblKey, value, name)
    data[tblKey] = data[tblKey] or {};
    name = name or "default";
    data[tblKey][name:lower()] = value;
end

-- Style Methods ----------------------

WidgetsPackage:DefineParams("number", "number", "number", "?string");
function Style:SetColor(data, red, green, blue, colorName)
    Setter(data, "color", {red, green, blue}, colorName);
end

WidgetsPackage:DefineParams("?string", "?boolean");
WidgetsPackage:DefineReturns("?any", "?number", "?number");
--@param (optional) name - the name used to identify and get the correct color previously set
--@param (optional) disableUnpacking - whether the returned color table values should be unpacked
--@return - a table containing the r, g, b color values (or all color values unpacked)
function Style:GetColor(data, colorName, disableUnpacking)
    local value = Getter(data, "color", colorName, {1, 1, 1});

    if (disableUnpacking) then
        value.r = value[1];
        value.g = value[2];
        value.b = value[3];
        return value;
    end

    return unpack(value);
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

    return unpack(value);
end

-- @param ... - A variable argument list of widgets (can have alpha value at the start of list)
function Style:ApplyColor(data, colorName, alpha, ...)
    colorName = colorName or "default";

    -- local storeWidgets = data.trackedColors and data.trackedColors[colorName];
    local r, g, b = self:GetColor(colorName);

    if (type(alpha) == "string") then
        alpha = self:GetAlpha(alpha);
        
    elseif (not (alpha and type(alpha) == "number")) then
        alpha = 1;
    end

    for id, element in pairs({...}) do  

        LibObjectLua:Assert(type(element) == "table" and element.GetObjectType,
            "Style.ApplyColor: Widget expected but received a %s value of %s", type(element), element);

        local objectType = element:GetObjectType();
    
        if (objectType == "Texture") then
            local id = element:GetTexture();
    
            if (id and id:match("Color-%a+")) then
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

-- updated widgets previously applied with a color if color changes and updates them
-- function Style:EnableColorUpdates(data, colorName)
--     colorName = colorName or "default";
--     data.trackedColors = data.trackedColors or {};
--     data.trackedColors[colorName] = {};
-- end
