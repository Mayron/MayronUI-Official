-- luacheck: ignore MayronUI self 143 631
local obj = select(5, MayronUI:GetCoreComponents());

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local IDataTextModule = Engine:CreateInterface("IDataTextModule");
-- local BaseDataTextModule = Engine:CreateClass("BaseDataTextModule", nil, "IDataTextModule");

-- IDataTextModule Properties --------

IDataTextModule:DefineProperty("MenuContent", "Frame");
IDataTextModule:DefineProperty("MenuLabels", "table");
IDataTextModule:DefineProperty("TotalLabelsShown", "number");
IDataTextModule:DefineProperty("HasLeftMenu", "boolean");
IDataTextModule:DefineProperty("HasRightMenu", "boolean");
IDataTextModule:DefineProperty("Button", "Button");
IDataTextModule:DefineProperty("SavedVariableName", "string");

-- IDataTextModule Functions ---------

function IDataTextModule:Update() end
function IDataTextModule:Click() end
function IDataTextModule:IsEnabled() end
function IDataTextModule:Disable() end
function IDataTextModule:Enable() end