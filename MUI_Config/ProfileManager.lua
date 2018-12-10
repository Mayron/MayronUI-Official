--luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, _, _, gui = MayronUI:GetCoreComponents();

local configModule = MayronUI:ImportModule("Config");
local C_ConfigModule = namespace.C_ConfigModule;


function C_ConfigModule:ShowProfileManager(data)

    --TODO!
    -- C_ConfigModule:SetSelectedButton(data, menuButton)

    -- self:RenderSelectedMenu(menuButton.configTable);


end