-- Setup Namespaces ------------------

local _, Core = ...;

-- Register and Import Modules -------
local IDataTextModule = Core.Objects:CreateInterface("IDataTextModule");

Core.Objects:DefineProperty("Frame");
IDataTextModule.MenuScrollChild = nil;

Core.Objects:DefineProperty("LinkedList<IDataItem>");
IDataTextModule.MenuItemList = nil;

function IDataTextModule:Click() end

function IDataTextModule:Update() end

function IDataTextModule:SetText() end

function IDataTextModule:Setup() end

LinkedList.Of("IDataItem")();

MyPackage:DefineReturns("<T>");
function LinkedList:Get() end

Lib:CreateClass("LinkedList<T>", parent, interfaces)

Properties of data (should be enforced really...)

Interfaces should also support public properties (not in data)

Interface properties:

	- MenuScrollChild (content)
	- MenuItemList (labels / buttons)
		- Text / Value
		- OnClick
		- OnEnter
		- OnLeave
		
- Needs to have a way of using the same buttons/labels (should be able to use 1 method to reset text/values per button or add a dropdown menu)\


local MenuItem = MyPackage:CreateClass("DataTextMenuItem");

function MenuItem:SetText() end
function MenuItem:SetVa() end

local IDataTextModule = MyPackage:CreateInterface("IDataTextModule");

MyPackage:DefineParams("string", "function");
MyPackage:DefineReturns("boolean");
function IDataTextModule:Click(eventName, func) end

function IDataTextModule:Update() end
function IDataTextModule:SetText() end
function IDataTextModule:Setup() end



-- Example of a Class implementing an interface
local Frame = MyPackage:CreateClass("Frame", nil, IEventHandler);

MyPackage:Implements("Register");
function Frame:Register(private, eventName, func)
    -- do stuff
    return true;
end

-- Experimental idea:

MyPackage:DefineProperty("boolean");
IDataTextModule.PropertyName = true; -- default

function DataItem:__Construct(data, messageType)

	MyPackage:Implements("PropertyName");
	self.PropertyName = false;	
	
	MyPackage:Implements("MessageType");
	self.MessageType = messageType;
end



