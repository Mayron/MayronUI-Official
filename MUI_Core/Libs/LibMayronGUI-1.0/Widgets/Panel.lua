-- luacheck: ignore MayronUI self 143 631

---@type LibMayronGUI
local Lib = _G.LibStub:GetLibrary("LibMayronGUI");

if (not Lib) then return; end

local Private = Lib.Private;
local obj = _G.MayronObjects:GetFramework();
local math = _G.math;

---@class Panel
local Panel = obj:CreateClass("Panel");
obj:Export(Panel, "MayronUI");

Panel.Static:AddFriendClass("Group");
Private.Panel = Panel;
---------------------------------

-- helper constructor
function Lib:CreatePanel(frame, globalName, parent)
  return Panel(frame, globalName, parent);
end

function Panel:__Construct(data, frame, globalName, parent)
  self:SetFrame(frame or _G.CreateFrame("Frame", globalName, parent or _G.UIParent));
  data.grid = Private.LinkedList();
  data.rowscale = obj:PopTable();
  data.columnscale = obj:PopTable();
  data.width = 1;
  data.height = 1;

  data.frame:HookScript("OnSizeChanged", function()
    Private:OnSizeChanged(data);
  end);
end

function Panel:GetDimensions(data)
  return data.width, data.height;
end

function Panel:SetDimensions(data, width, height)
  local squares = obj:PopTable(data.grid:Unpack());
  local i = 1;

  data.width = width;
  data.height = height;

  while (true) do
    if (i <= height * width) then
      if (not squares[i]) then
        local f = Private:PopFrame("Frame", data.frame);

        if (data.devMode) then
          Private:SetBackground(f, math.random(), math.random(), math.random(), 0.2);
          f.t = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
          f.t:SetPoint("CENTER");
          f.t:SetText(i);
        end

        data.grid:AddToBack(f);
      end

    elseif (squares[i]) then
      data.grid:Remove(squares[i]);
    else
      break;
    end

    i = i + 1;
  end

  obj:PushTable(squares);
  Private:SetupGrid(data);
end

function Panel:SetDevMode(data, devMode)  -- shows or hides the red frame info overlays
  data.devMode = devMode;
end

function Panel:AddCells(data, ...)
  data.cells = data.cells or Private.LinkedList(); --- @type LinkedList

  for _, cell in obj:IterateArgs(...) do
    data.cells:AddToBack(cell);
    cell:SetPanel(self);
  end

  -- if cell.content is not fixed! then SetScript("OnSizeChanged")
  Private:AnchorCells(data);
end

function Panel:GetCells(data, n)
  if (not data.cells) then
    return false;
  end
  return data.cells:Unpack(n);
end