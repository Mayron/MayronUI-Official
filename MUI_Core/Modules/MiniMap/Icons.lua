-- luacheck: ignore MayronUI self 143
local _, namespace = ...;

local tk, db, _, gui, obj, L = MayronUI:GetCoreComponents();

---@type MiniMapModule
local C_MiniMapModule = namespace.C_MiniMapModule;

---@type List
local List = obj:Import("Pkg-Collections.List<T>");

---@type Panel
local iconsFrame;
local Minimap = _G.Minimap;

---@type List
local icons;

-- local function RepositionIcons()


--   for i, b in icons:Iterate() do
--     if (i == 1) then

--     else

--     end
--   end
-- end

-- function C_MiniMapModule:SetUpIconsFrame(data)
--   iconsFrame = gui:CreatePanel("Frame", nil, _G.Minimap);
--   iconsFrame:SetDimensions(3, 10);

--   icons = List:Of("Button")();

--   iconsFrame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT");
--   iconsFrame:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT");
--   iconsFrame:SetHeight(100);

--   local iconName;
--   for _, icon in obj:IterateArgs(Minimap:GetChildren()) do
--     iconName = icon:GetName();

--     if (iconName and tk.Strings:StartsWith(iconName, "LibDBIcon")) then
--       icons:Add(icon);
--     end
--   end

--   RepositionIcons();
-- end