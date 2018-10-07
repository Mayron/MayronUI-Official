-- Setup Namespaces ------------------

local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local IDataTextModule = Engine:CreateInterface("IDataTextModule");

-- IDataTextModule Properties --------

IDataTextModule:DefineProperty("MenuContent", "Frame");
IDataTextModule:DefineProperty("MenuLabels", "table");
IDataTextModule:DefineProperty("TotalLabelsShown", "number");
IDataTextModule:DefineProperty("HasMenu", "boolean");
IDataTextModule:DefineProperty("Button", "Button");
IDataTextModule:DefineProperty("ButtonID", "number");
IDataTextModule:DefineProperty("ModuleName", "string");

-- IDataTextModule Functions ---------

function IDataTextModule:Update() end
function IDataTextModule:Click() end
function IDataTextModule:IsEnabled() end
function IDataTextModule:Disable() end
function IDataTextModule:Enable() end

-- function IDataTextModule:SetItem() end