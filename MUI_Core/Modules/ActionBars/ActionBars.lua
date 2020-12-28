-- luacheck: ignore self 143
local MayronUI = _G.MayronUI;
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents();

local LibAB = _G.LibStub("LibActionButton-1.0");

-- Objects -----------------------------

---@type Engine
local Engine = obj:Import("MayronUI.Engine");

---@class ActionBarsModule : BaseModule
local C_ActionBarsModule = MayronUI:RegisterModule("ActionBarsModule", "Action Bars");

-- Load Database Defaults --------------

db:AddToDefaults("profile.actionBars", { });


function C_ActionBarsModule:OnInitialize()
  -- self:SetEnabled(true);
end

function C_ActionBarsModule:OnEnable(data)
  data.buttons = obj:PopTable();
  self:CreateBar();

  LibAB:RegisterCallback("OnButtonContentsChanged", function(...)
    print("OnButtonContentsChanged: ", ...)
  end);
end

local customExitButton = {
  func = function()
    if (UnitExists('vehicle')) then
      VehicleExit();
    else
      PetDismiss();
    end
  end;
  texture = [[Interface\Icons\Spell_Shadow_SacrificialShield]];
  tooltip = _G.LEAVE_VEHICLE;
};

local function ShowBackground(bar)
  local texture = bar:CreateTexture(nil, "BACKGROUND");

  -- make room for the border!
  texture:SetPoint("TOPLEFT", bar, "TOPLEFT", 1, -1);
  texture:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -1, 1);
  texture:SetColorTexture(math.random(), math.random(), math.random(), 0.2);
end

function C_ActionBarsModule:CreateBar(data)
  local barId = 1;
  local bar = CreateFrame("Frame", string.format("MUI_ActionBar%d", barId), _G.UIParent, "SecureHandlerStateTemplate");
  bar:SetSize(400, 60);
  bar:SetPoint("CENTER");
  -- ShowBackground(bar); -- uncomment to show a random background color on the bar to see it easier (devmode)
  tk:MakeMovable(bar); -- for development only



  local btnSize = 32;
  local btnSpacing = 4;
  local totalButtonsOnBar = 20; -- try 300 with empty state!
  local buttonsPerRow = 20;

  for buttonID = 1, totalButtonsOnBar do
    local btn = LibAB:CreateButton(buttonID, string.format("MUI_ActionButton%d", buttonID), bar, nil);
    btn:SetParent(bar);
    btn:SetState(0, "action", buttonID);
    btn:SetSize(btnSize, btnSize);
    btn.icon:SetTexCoord(0.1, 0.92, 0.08, 0.92);

    for k = 1, 14 do
      -- Is this for paging? Not sure what this is honestly, but it's found in bartender and ElvUI code:
      btn:SetState(k, "action", (k - 1) * 12 + buttonID);
    end

    if (buttonID == 12) then
      -- vehicle button or pet dismiss button
      btn:SetState(12, "custom", customExitButton);
    end

    -- TODO: This lets you define CUSTOM buttons:
    btn:ClearStates();
    btn:SetState(0, "empty");

    -- TODO: Add Masque support:
    -- local Masque = LibStub("Masque", true)
    -- local MasqueGroup;
    -- if (Masque) then
    --   MasqueGroup = Masque:Group("MayronUI", tostring(id));
    -- end
    -- if (MasqueGroup) then
    --   btn:AddToMasque(MasqueGroup);
    -- end

    -- Some generic positioning:
    if (buttonID == 1) then
      btn:SetPoint("TOPLEFT");
    elseif (buttonID % buttonsPerRow == 1) then
      -- make new row
      local previous = buttonID - buttonsPerRow;
      btn:SetPoint("TOP", data.buttons[previous], "BOTTOM", 0, -btnSpacing);
    else
      btn:SetPoint("LEFT", data.buttons[buttonID - 1], "RIGHT", btnSpacing, 0);
    end

    btn:Show();
    btn:UpdateAction(); -- from LibActionButton to set up the action
    SecureHandler_OnLoad(btn)

    data.buttons[buttonID] = btn;
  end

end