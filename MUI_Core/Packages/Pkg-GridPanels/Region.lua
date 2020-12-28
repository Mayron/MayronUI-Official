-- luacheck: ignore self
local obj = _G.MayronObjects:GetFramework(); ---@type MayronObjects
if (obj:Import("Pkg-GridPanels.Region", true)) then return end

local C_Region = obj:Get("Pkg-GridPanels.Region"); ---@type Region
local CreateFrame = _G.CreateFrame;
---------------------------------

function C_Region:__Construct(data, frame, globalName, parent)
  data.frame = frame or CreateFrame("Frame", globalName,
    parent or _G.UIParent, _G.BackdropTemplateMixin and "BackdropTemplate");

  data.width = 1;
  data.height = 1;
end

obj:DefineParams("Grid");
function C_Region:SetGrid(data, grid)
  data.grid = grid;

  local gridData = data:GetFriendData(grid);
  if (gridData.devMode) then
    gridData:SetBackground(data.frame, 1, 0, 0, 0.4);

    data.frame:SetBackdrop({
      edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
      edgeSize = 16
    });
  end
end

-- How far the Region should span to other grid squares
obj:DefineParams("number", "number");
function C_Region:SetSpanSize(data, width, height)
  data.width = width;
  data.height = height;

  if (data.grid) then
    local gridData = data:GetFriendData(data.grid);
    gridData:AnchorRegions();
  end
end

obj:DefineParams("number", "?number", "?number", "?number");
function C_Region:SetInsets(data, ...)
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

obj:DefineParams("?Panel");
function C_Region:GetGrid(data)
  return data.grid;
end