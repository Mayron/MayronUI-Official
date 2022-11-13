-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, _, obj = MayronUI:GetCoreComponents();

---@class Cell
local Cell = obj:CreateClass("Cell");
Cell.Static:AddFriendClass("MayronUI.Panel");

---@type Panel
local Panel = obj:Import("MayronUI.Panel");

-- @constructor
function Panel:CreateCell(data, frame)
  frame = frame or tk:CreateFrame("Frame", _G.UIParent, nil, _G.BackdropTemplateMixin and "BackdropTemplate");
  frame:SetParent(data.frame);

  if (data.devMode) then
    tk:SetBackground(frame, 1, 0, 0, 0.4);
    frame:SetBackdrop({
      edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
      edgeSize = 16
    });
  end

  return Cell(frame);
end

function Cell:__Construct(data, frame)
  data.width = 1;
  data.height = 1;
  self:SetFrame(frame);
end

function Cell:SetPanel(data, panel)
  data.panel = panel;
end

function Cell:SetDimensions(data, width, height)
  data.width = width;
  data.height = height;

  if (data.panel) then
    data.panel:AnchorCells();
  end
end

function Cell:SetInsets(data, ...)
  local args = obj:PopTable(...);

  if (#args == 1) then
    data.insets = {
      top = args[1],
      right = args[1],
      bottom = args[1],
      left = args[1]
    };
  elseif (#args == 2) then
    data.insets = {
      top = args[1],
      right = args[2],
      bottom = args[1],
      left = args[2]
    };
  elseif (#args >= 4) then
    data.insets = {
      top = args[1],
      right = args[2],
      bottom = args[3],
      left = args[4]
    };
  end

  obj:PushTable(args);

  if (data.startAnchor and data.endEnchor) then
    data.frame:SetPoint("TOPLEFT", data.startAnchor, "TOPLEFT", data.insets.left, -data.insets.top);
    data.frame:SetPoint("TOPLEFT", data.endEnchor, "TOPLEFT", -data.insets.right, data.insets.bottom);
  end
end

function Cell:GetPanel(data)
  return data.panel;
end