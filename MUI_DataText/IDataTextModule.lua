-- Setup Namespaces ------------------

local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

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

-- IDataTextModule Functions ---------

function IDataTextModule:Update() end
function IDataTextModule:Click() end
function IDataTextModule:IsEnabled() end
function IDataTextModule:Disable() end
function IDataTextModule:Enable() end

Engine:DefineReturns("number");
function IDataTextModule:GetDisplayOrder() end

Engine:DefineParams("number");
function IDataTextModule:SetDisplayOrder(displayOrder) end

-- TODO: BaseDataTextModule Functions ---------

-- function BaseDataTextModule:GetDisplayOrder(data)
--     return data.displayOrder;
-- end

-- function BaseDataTextModule:SetDisplayOrder(data, displayOrder)
--     if (data.displayOrder ~= displayOrder) then
--         data.displayOrder = displayOrder;
--         data.sv.displayOrder = displayOrder;
--         self:Update();
--     end
-- end 