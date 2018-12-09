local _, core = ...;
local tk = core.Toolkit;
local obj = LibStub:GetLibrary("LibMayronObjects");

local ToolkitPackage = obj:CreatePackage("Toolkit");
local ListTable = ToolkitPackage:CreateClass("ListTable");


-- Methods:

GetValueList()
GetKeyList()


Invert() -- swap keys with values and vice versa
OrderByKeys(descending)
OrderByValues(descending)

SortKeys(func)
SortValues(func)

GetTable()

RemoveByKey()
RemoveByValue()

Add() -- will auto sort and order if previously used