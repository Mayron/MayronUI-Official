-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk = MayronUI:GetCoreComponents();

---@class GUIBuilder
local gui = MayronUI:GetComponent("GUIBuilder");

local hooksecurefunc = _G.hooksecurefunc;
local math = _G.math;

-- Local Functions ----------------
local function HideIfAnimating(self)
  if (self:GetParent().animating) then
    self:Hide();
  end
end

local function DynamicScrollBar_OnChange(self)
  if (not self.scrollable or not self.ScrollFrame) then
    self.showScrollBar = nil;

    if (self.ScrollBar) then
      self.ScrollBar:Hide();
    end

    return
  end

  local scrollChild = self.ScrollFrame:GetScrollChild();
  local scrollChildHeight = math.floor(scrollChild:GetHeight() + 0.5);
  local containerHeight = math.floor(self:GetHeight() + 0.5);

  if (scrollChild and scrollChildHeight > containerHeight) then
    if (self.ScrollFrame.animating) then
      self.ScrollBar:Hide();
      self.showScrollBar = self.ScrollBar;
    else
      self.ScrollBar:Show();
    end
  else
    self.showScrollBar = nil;
    self.ScrollBar:Hide();
  end
end

local function ScrollFrame_OnMouseWheel(self, step)
  if (not self.scrollable) then return end
  local newvalue = self:GetVerticalScroll() - (step * 20);

  if (newvalue < 0) then
    newvalue = 0;
    -- max scroll range is scrollchild.height - scrollframe.height!
  elseif (newvalue > self:GetVerticalScrollRange()) then
    newvalue = self:GetVerticalScrollRange();
  end

  self:SetVerticalScroll(newvalue);
end

-- Lib Methods ------------------

-- Creates a scroll frame inside a container frame
function gui:CreateScrollFrame(parent, global, child)
  local style = tk.Constants.AddOnStyle;
  local container = tk:CreateBackdropFrame("Frame", parent, global);
  container.ScrollFrame = tk:CreateFrame("ScrollFrame", container--[[@as Frame]], nil, "UIPanelScrollFrameTemplate");
  container.ScrollFrame:SetAllPoints(true);
  container.ScrollFrame:EnableMouseWheel(true);
  container.ScrollFrame:SetClipsChildren(true);

  child = child or tk:CreateFrame("Frame", container.ScrollFrame);
  container.ScrollFrame:SetScrollChild(child);

  local padding = style:GetPadding(nil, true);
  tk:SetFullWidth(child, padding.right);

  -- ScrollBar ------------------
  container.ScrollBar = container.ScrollFrame.ScrollBar;
  container.ScrollBar:ClearAllPoints();
  container.ScrollBar:SetPoint("TOPLEFT", container.ScrollFrame, "TOPRIGHT", -8, 0);
  container.ScrollBar:SetPoint("BOTTOMRIGHT", container.ScrollFrame, "BOTTOMRIGHT", 0, 0);

  container.ScrollBar.ClearAllPoints = gui.DUMMY_FUNC;
  container.ScrollBar.SetPoint = gui.DUMMY_FUNC;
  hooksecurefunc(container.ScrollBar, "Show", HideIfAnimating);

  container.ScrollBar.thumb = container.ScrollBar:GetThumbTexture();
  container.ScrollBar.thumb:SetColorTexture(1, 1, 1); -- needed to remove old texture and color correctly in ApplyColor (patch 8.1.5)

  style:ApplyColor(nil, 1, container.ScrollBar.thumb);
  container.ScrollBar.thumb:SetSize(6, 50);
  container.ScrollBar:Hide();

  tk:SetBackground(container.ScrollBar, 0, 0, 0, 0.2);
  tk:KillElement(container.ScrollBar.ScrollUpButton);
  tk:KillElement(container.ScrollBar.ScrollDownButton);

  container:SetScript("OnShow", DynamicScrollBar_OnChange);
  container:HookScript("OnSizeChanged", DynamicScrollBar_OnChange);
  container.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);
  container.ScrollFrame:HookScript("OnScrollRangeChanged", DynamicScrollBar_OnChange);

  child.SetScrollable = function(_, scrollable)
    container.scrollable = scrollable;
  end

  return container;
end

function gui:UpdateScrollFrameColor(container, style)
  style:ApplyColor(nil, 0.8, container.ScrollBar.thumb);
end