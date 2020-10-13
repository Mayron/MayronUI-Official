-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local Private = {};
local InCombatLockdown, IsAddOnLoaded, UIFrameFadeIn, UIFrameFadeOut, math, tostring, CreateFrame,
C_Timer, UIParent, PlaySound = _G.InCombatLockdown, _G.IsAddOnLoaded, _G.UIFrameFadeIn, _G.UIFrameFadeOut, _G.math,
_G.tostring, _G.CreateFrame, _G.C_Timer, _G.UIParent, _G.PlaySound;

-- Register and Import Modules -----------

local C_SideBarModule = MayronUI:RegisterModule("SideBarModule", L["Side Action Bar"]);

-- Add Database Defaults -----------------

db:AddToDefaults("profile.sidebar", {
  enabled = true;
  height = 486;
  retractWidth = 46;
  expandWidth = 83;
  animationSpeed = 6;
  yOffset = 40,
  barsShown = 2; -- non-config GUI

  buttons = {
    showWhen = "Always"; -- can be mouseover or never
    hideInCombat = false;
    width = 15;
    height = 100;
  };

  bartender = {
    control = true;
    [1] = "Bar 3"; -- first bar
    [2] = "Bar 4"; -- second bar
  };
});

-- Private Functions ---------------------

function Private:ToggleBartenderBar(bar, show)
  if (IsAddOnLoaded("Bartender4") and db.profile.sidebar.bartender.control) then
    bar:SetConfigAlpha((show and 1) or 0);
    bar:SetVisibilityOption("always", not show);
  end
end

function Private:ExpandFrame(sidebar, bar2, frame, maxWidth)
  local counter = 1;

  local function loop()
    if (counter) then
      counter = counter + 1;

      if (counter > 6) then
        if (IsAddOnLoaded("Bartender4") and db.profile.sidebar.bartender.control) then
          UIFrameFadeIn(bar2, 0.2, bar2:GetAlpha(), 1);
        end

        counter = false;
      end
    end

    local width = math.floor(frame:GetWidth() + 0.5);

    if (width < maxWidth and frame.expand) then
      if (width + Private.step > maxWidth) then
        frame:SetWidth(maxWidth);
      else
        frame:SetWidth(width + Private.step);
      end

      C_Timer.After(0.02, loop);
    else
      frame:SetWidth(maxWidth);
      Private:ToggleBartenderBar(bar2, true);
      frame.animating = false;
      sidebar:SetBarsShown(2);
    end
  end

  frame:Show();
  frame.expand = true;
  frame.animating = true;
  C_Timer.After(0.02, loop);
end

function Private:RetractFrame(sidebar, bar2, frame, minWidth)
  local function loop()
    local width = math.floor(frame:GetWidth() + 0.5);

    if (width > (Private.step + minWidth) and not frame.expand) then
      frame:SetWidth(width - Private.step);
      C_Timer.After(0.02, loop);

    else
      frame:SetWidth(minWidth);
      Private:ToggleBartenderBar(bar2, false);
      frame.animating = false;
      sidebar:SetBarsShown(1);
    end
  end

  frame.expand = nil;
  frame.animating = true;

  if (IsAddOnLoaded("Bartender4") and db.profile.sidebar.bartender.control) then
    UIFrameFadeOut(bar2, 0.1, bar2:GetAlpha(), 0);
  end

  C_Timer.After(0.02, loop);
end

function Private:MoveFrameOut(sideBarModule, frame, bar1, controlBartender)
  local function loop()
    local point, anchor, anchorPoint, xOffset, yOffset = frame:GetPoint();
    local width = math.floor(frame:GetWidth() + 0.5);

    if (xOffset < (width - Private.step) and not frame.moveIn) then
      frame:SetPoint(point, anchor, anchorPoint, xOffset + Private.step, yOffset);
      C_Timer.After(0.02, loop);

    else
      frame:SetPoint(point, anchor, anchorPoint, width, yOffset);
      frame:Hide();
      Private:ToggleBartenderBar(bar1, false);
      frame.animating = false;
      sideBarModule:SetBarsShown(0);
    end
  end

  frame.moveIn = nil;
  frame.animating = true;

  if (IsAddOnLoaded("Bartender4") and controlBartender) then
    UIFrameFadeOut(bar1, 0.1, bar1:GetAlpha(), 0);
  end

  C_Timer.After(0.02, loop);
end

function Private:MoveFrameIn(sideBarModule, frame, bar1, controlBartender)
  local counter = 1;

  local function loop()
    if (counter) then
      counter = counter + 1;

      if (counter > 8) then
        if (IsAddOnLoaded("Bartender4") and controlBartender) then
          UIFrameFadeIn(bar1, 0.2, bar1:GetAlpha(), 1);
        end

        counter = false;
      end
    end

    local point, anchor, anchorPoint, xOffset, yOffset = frame:GetPoint();
    xOffset = math.floor(xOffset + 0.5);

    if (xOffset > (0 + Private.step) and frame.moveIn) then
      frame:SetPoint(point, anchor, anchorPoint, xOffset - Private.step, yOffset);
      C_Timer.After(0.02, loop);

    else
      frame:SetPoint(point, anchor, anchorPoint, 0, yOffset);
      Private:ToggleBartenderBar(bar1, true);
      frame.animating = false;
      sideBarModule:SetBarsShown(1);
    end
  end

  frame:Show();
  frame.moveIn = true;
  frame.animating = true;
  C_Timer.After(0.02, loop);
end

local function UpdateSideButtonVisibility(barsShown, expandBtn, retractBtn)
  if (barsShown == 0) then
    expandBtn:Show();
    retractBtn:Hide();
  elseif (barsShown == 1) then
    expandBtn:Show();
    retractBtn:Show();
  elseif (barsShown == 2) then
    expandBtn:Hide();
    retractBtn:Show();
  end
end

local function SideButton_OnEnter(self)
  self:SetAlpha(1);
end

local function SideButton_OnLeave(self)
  self:SetAlpha(0);
end

-- C_SideBarModule -----------------------
function C_SideBarModule:OnInitialize(data)
  local options = {
    onExecuteAll = {
      ignore = {
        "retractWidth";
        "yOffset";
      };

      dependencies = {
        ["expandWidth"] = "bartender";
      }
    };
  };

  self:RegisterUpdateFunctions(db.profile.sidebar, {
      enabled = function(value)
        self:SetEnabled(value);
      end;

      height = function(value)
          data.panel:SetHeight(value);
      end;

      retractWidth = function()
          self:SetBarsShown(data.settings.barsShown);
      end;

      expandWidth = function()
          self:SetBarsShown(data.settings.barsShown);
      end;

      animationSpeed = function(value)
          Private.step = value;
      end;

      yOffset = function(value)
          local p, rf, rp, x = data.panel:GetPoint();
          data.panel:SetPoint(p, rf, rp, x, value);
      end;

      bartender = function()
          self:SetBartenderBars();
      end;

      buttons = {
          showWhen = function(value)
              if (value == "Never") then
                  data.expand:Hide();
                  data.retract:Hide();
                  return;
              end

              UpdateSideButtonVisibility(data.settings.barsShown, data.expand, data.retract);

              if (value == "On Mouse-over") then
                  data.expand:SetAlpha(0);
                  data.retract:SetAlpha(0);
                  data.expand:SetScript("OnEnter", SideButton_OnEnter);
                  data.expand:SetScript("OnLeave", SideButton_OnLeave);
                  data.retract:SetScript("OnEnter", SideButton_OnEnter);
                  data.retract:SetScript("OnLeave", SideButton_OnLeave);
              else
                  data.expand:SetScript("OnEnter", nil);
                  data.expand:SetScript("OnLeave", nil);
                  data.retract:SetScript("OnEnter", nil);
                  data.retract:SetScript("OnLeave", nil);
                  data.expand:SetAlpha(1);
                  data.retract:SetAlpha(1);
              end
          end;

          hideInCombat = function(value)
              self:SetButtonsHideInCombat(value);
          end;

          width = function(value)
              data.expand:SetSize(value, data.settings.buttons.height);
              data.retract:SetSize(value, data.settings.buttons.height);
          end;

          height = function(value)
              data.expand:SetSize(data.settings.buttons.width, value);
              data.retract:SetSize(data.settings.buttons.width, value);
          end;
      };
  }, options);
end

function C_SideBarModule:OnInitialized(data)
  if (data.settings.enabled) then
    self:SetEnabled(true);
  end
end

function C_SideBarModule:OnEnable(data)
  Private.step = data.settings.animationSpeed;
  self:CreateSideBar();
  data.panel:Show();
  UpdateSideButtonVisibility(data.settings.barsShown, data.expand, data.retract);

  if (tk:IsRetail()) then
    em:CreateEventHandlerWithKey("PET_BATTLE_OPENING_START", "SideBarPetBattleStart", function()
      data.panel:Hide();
    end);

    em:CreateEventHandlerWithKey("PET_BATTLE_CLOSE", "SideBarPetBattleStop", function()
      data.panel:Show();
    end);
  end
end

function C_SideBarModule:OnDisable(data)
  if (not data.panel) then
    return;
  end

  data.panel:Hide();
  data.expand:Hide();
  data.retract:Hide();

  if (tk:IsRetail()) then
    em:DestroyEventHandlerByKey("SideBarPetBattleStart");
    em:DestroyEventHandlerByKey("SideBarPetBattleStop");
  end
end

function C_SideBarModule:SetButtonsHideInCombat(data, hide)
  if (hide) then
    em:CreateEventHandlerWithKey("PLAYER_REGEN_ENABLED", "SideBar_HideInCombat_RegenEnabled", function()
      data.expand:SetShown(data.settings.barsShown ~= 2);
      data.retract:SetShown(data.settings.barsShown ~= 0);
    end);

    em:CreateEventHandlerWithKey("PLAYER_REGEN_DISABLED", "SideBar_HideInCombat_RegenDisabled", function()
      data.expand:Hide();
      data.retract:Hide();
    end);
  end

  local handler = em:FindEventHandlerByKey("SideBar_HideInCombat_RegenEnabled");

  if (handler) then
    handler:SetEventCallbackEnabled("PLAYER_REGEN_ENABLED", hide);
  end

  handler = em:FindEventHandlerByKey("SideBar_HideInCombat_RegenDisabled");

  if (handler) then
    handler:SetEventCallbackEnabled("PLAYER_REGEN_DISABLED", hide);
  end

  if (InCombatLockdown() and hide) then
    data.expand:Hide();
    data.retract:Hide();
  else
    data.expand:SetShown(data.settings.barsShown ~= 2);
    data.retract:SetShown(data.settings.barsShown ~= 0);
  end
end

-- SideBar Object -------------------------
function C_SideBarModule:Expand(data, expandAmount)
  if (InCombatLockdown()) then
    return;
  end

  PlaySound(tk.Constants.CLICK);
  data.expand:Hide();
  data.retract:Hide();

  if (expandAmount == 1) then
    Private:MoveFrameIn(self, data.panel, data.BTBar1, data.settings.bartender.control);
  elseif (expandAmount == 2) then
    Private:ExpandFrame(self, data.BTBar2, data.panel, data.settings.expandWidth);
  end
end

function C_SideBarModule:Retract(data, retractAmount)
  if (InCombatLockdown()) then
    return;
  end

  PlaySound(tk.Constants.CLICK);
  data.expand:Hide();
  data.retract:Hide();

  if (retractAmount == 1) then
    Private:RetractFrame(self, data.BTBar2, data.panel, data.settings.retractWidth);
  elseif (retractAmount == 2) then
    Private:MoveFrameOut(self, data.panel, data.BTBar1, data.settings.bartender.control);
  end
end

function C_SideBarModule:SetBarsShown(data, numBarsShown)
  data.settings.barsShown = numBarsShown;
  db.profile.sidebar.barsShown = numBarsShown;

  data.expand:ClearAllPoints();
  data.retract:ClearAllPoints();

  UpdateSideButtonVisibility(data.settings.barsShown, data.expand, data.retract);

  if (data.settings.barsShown == 2) then
    Private:ToggleBartenderBar(data.BTBar2, true);
    Private:ToggleBartenderBar(data.BTBar1, true);

    data.panel:SetSize(data.settings.expandWidth, data.settings.height);
    data.retract:SetPoint("RIGHT", data.panel, "LEFT");

    data.retract:SetScript("OnClick", function()
      self:Retract(1);
    end);

  elseif (data.settings.barsShown == 1) then
    Private:ToggleBartenderBar(data.BTBar2, false);
    Private:ToggleBartenderBar(data.BTBar1, true);
    data.panel:SetSize(data.settings.retractWidth, data.settings.height);
    data.expand:SetPoint("RIGHT", data.panel, "LEFT", 0, 90);
    data.retract:SetPoint("RIGHT", data.panel, "LEFT", 0, -90);

    data.expand:SetScript("OnClick", function()
      self:Expand(2);
    end);

    data.retract:SetScript("OnClick", function()
      self:Retract(2);
    end);

  elseif (data.settings.barsShown == 0) then
    Private:ToggleBartenderBar(data.BTBar1, false);
    Private:ToggleBartenderBar(data.BTBar2, false);
    data.panel:SetSize(data.settings.retractWidth, data.settings.height);
    data.panel:ClearAllPoints();
    data.panel:SetPoint("RIGHT", UIParent, "RIGHT", data.settings.retractWidth ,data.settings.yOffset);
    data.panel:Hide();
    data.expand:SetPoint("RIGHT");

    data.expand:SetScript("OnClick", function()
      self:Expand(1);
    end);
  end

  if (data.settings.buttons.showWhen == "Never") then
    data.expand:Hide();
    data.retract:Hide();
  end
end

function C_SideBarModule:CreateSideBar(data)
  if (data.panel) then
    return;
  end

  local sideButtonTexturePath = tk:GetAssetFilePath("Textures\\SideBar\\SideButton");
  local sideBarTexturePath = tk:GetAssetFilePath("Textures\\SideBar\\SideBarPanel");

  data.panel = CreateFrame("Frame", "MUI_SideBar", UIParent);
  data.panel:SetPoint("RIGHT", 0, data.settings.yOffset);

  gui:CreateGridTexture(data.panel, sideBarTexturePath, 20, nil, 45, 749);

  data.expand = CreateFrame("Button", nil, UIParent);
  data.expand:SetNormalFontObject("MUI_FontSmall");
  data.expand:SetHighlightFontObject("GameFontHighlightSmall");
  data.expand:SetNormalTexture(sideButtonTexturePath);
  data.expand:SetSize(data.settings.buttons.width, data.settings.buttons.height);
  data.expand:SetText("<");

  data.retract = CreateFrame("Button", nil, UIParent);
  data.retract:SetNormalFontObject("MUI_FontSmall");
  data.retract:SetHighlightFontObject("GameFontHighlightSmall");
  data.retract:SetNormalTexture(sideButtonTexturePath);
  data.retract:SetSize(data.settings.buttons.width, data.settings.buttons.height);
  data.retract:SetText(">");
end

function C_SideBarModule:GetPanel(data)
  return data.panel;
end

function C_SideBarModule:SetBartenderBars(data)
  if (not (IsAddOnLoaded("Bartender4") and data.settings.bartender.control)) then
    return;
  end

  local bar1 = data.settings.bartender[1]:match("%d+");
  local bar2 = data.settings.bartender[2]:match("%d+");

  _G.Bartender4:GetModule("ActionBars"):EnableBar(bar1);
  _G.Bartender4:GetModule("ActionBars"):EnableBar(bar2);
  data.BTBar1 = _G["BT4Bar"..tostring(bar1)];
  data.BTBar2 = _G["BT4Bar"..tostring(bar2)];
end