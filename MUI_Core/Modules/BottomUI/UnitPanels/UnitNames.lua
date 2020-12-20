-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local C_UnitPanels = _G.MayronUI:ImportModule("BottomUI_UnitPanels");

local string, tonumber, tostring = _G.string, _G.tonumber, _G.tostring;
local UnitGUID, UnitLevel, UnitAffectingCombat = _G.UnitGUID, _G.UnitLevel, _G.UnitAffectingCombat;
local CreateFrame, UnitName, UnitClassification = _G.CreateFrame, _G.UnitName, _G.UnitClassification;
local UnitExists, UnitIsPlayer, UnitClass, IsResting, GetRestState =
  _G.UnitExists, _G.UnitIsPlayer, _G.UnitClass, _G.IsResting, _G.GetRestState;

local function UpdateUnitNameText(data, unitType, unitLevel)
  unitLevel = unitLevel or UnitLevel(unitType);

  local name = UnitName(unitType);
  name = tk.Strings:SetOverflow(name, 22);

  local _, class = UnitClass(unitType); -- not sure if this works..
  local classification = UnitClassification(unitType);

  if (tonumber(unitLevel) < 1) then
    unitLevel = "boss";
  elseif (classification == "elite" or classification == "rareelite") then
    unitLevel = tostring(unitLevel).."+";
  end

  if (classification == "rareelite" or classification == "rare") then
    unitLevel = tk.Strings:Concat("|cffff66ff", unitLevel, "|r");
  end

  if (unitType ~= "player") then
    if (classification == "worldboss") then
      unitLevel = tk.Strings:SetTextColorByRGB(unitLevel, 0.25, 0.75, 0.25); -- yellow
    else
      local color = tk:GetDifficultyColor(UnitLevel(unitType));

      unitLevel = tk.Strings:SetTextColorByRGB(unitLevel, color.r, color.g, color.b);
      name = (UnitIsPlayer(unitType) and tk.Strings:SetTextColorByClass(name, class)) or name;
    end
  else
    unitLevel = tk.Strings:SetTextColorByRGB(unitLevel, 1, 0.8, 0);

    if (UnitAffectingCombat("player")) then
      name = tk.Strings:SetTextColorByRGB(name, 1, 0, 0);
      tk:SetBasicTooltip(data[unitType], _G.COMBAT, "ANCHOR_CURSOR");

    elseif (IsResting()) then
      name = tk.Strings:SetTextColorByRGB(name, 0, 1, 1);
      local _, exhaustionStateName = GetRestState();
      tk:SetBasicTooltip(data[unitType], exhaustionStateName, "ANCHOR_CURSOR");

    else
      name = tk.Strings:SetTextColorByClass(name, class);
      tk:SetBasicTooltip(data[unitType], nil, "ANCHOR_CURSOR");
    end
  end

  data[unitType].text:SetText(string.format("%s %s", name, unitLevel));
end

function C_UnitPanels:SetUnitNamesEnabled(data, enabled)
  if (enabled) then
    if (not (data.player and data.target)) then
      self:SetUpUnitNames(data);
    else
      em:EnableEventHandlers(
        "MuiUnitNames_LevelUp",
        "MuiUnitNames_UpdatePlayerName",
        "MuiUnitNames_TargetChanged");
    end

    data.player:Show();
    data.target:Show();

  elseif (data.player and data.target) then
    data.player:Hide();
    data.target:Hide();

    em:DisableEventHandlers(
      "MuiUnitNames_LevelUp",
      "MuiUnitNames_UpdatePlayerName",
      "MuiUnitNames_TargetChanged");
  end
end

function C_UnitPanels:SetUpUnitNames(data)
  local nameTextureFilePath = tk:GetAssetFilePath("Textures\\BottomUI\\NamePanel");

  data.player = CreateFrame("Frame", "MUI_PlayerName", data.left);
  data.player.bg = tk:SetBackground(data.player, nameTextureFilePath);
  data.player.text = data.player:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  data.player.text:SetJustifyH("LEFT");
  data.player.text:SetWordWrap(false);
  data.player.text:SetPoint("LEFT", 15, 0);

  data.target = CreateFrame("Frame", "MUI_TargetName", data.right);
  data.target.bg = tk:SetBackground(data.target, nameTextureFilePath);
  data.target.text = data.target:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  data.target.text:SetJustifyH("RIGHT");
  data.target.text:SetWordWrap(false);
  data.target.text:SetPoint("RIGHT", data.target, "RIGHT", -15, 0);

  tk:ApplyThemeColor(data.settings.alpha, data.player.bg, data.target.bg);

  tk:FlipTexture(data.target.bg, "HORIZONTAL");
  UpdateUnitNameText(data, "player");

  -- Setup event handlers:
  if (not tk:IsPlayerMaxLevel()) then
    local listener = em:CreateEventListenerWithID("MuiUnitNames_LevelUp", function(listener, _, newLevel)
      UpdateUnitNameText(data, "player", newLevel);

      if (UnitGUID("player") == UnitGUID("target")) then
        UpdateUnitNameText(data, "target", newLevel);
      end

      if (tk:IsPlayerMaxLevel()) then
        listener:Destroy();
      end
    end);

    listener:RegisterEvent("PLAYER_LEVEL_UP");
  end

  local listener = em:CreateEventListenerWithID("MuiUnitNames_UpdatePlayerName", function()
    UpdateUnitNameText(data, "player");
  end);

  listener:RegisterEvents(
    "PLAYER_REGEN_ENABLED", "PLAYER_REGEN_DISABLED",
    "PLAYER_ENTERING_WORLD", "PLAYER_UPDATE_RESTING");

  listener = em:CreateEventListenerWithID("MuiUnitNames_TargetChanged", function()
    if (UnitExists("target")) then
      UpdateUnitNameText(data, "target");
    else
      data.target.text:SetText(tk.Strings.Empty);
    end

    data:Call("UpdateVisuals", data.target, data.settings.alpha);
  end);

  listener:RegisterEvents("PLAYER_TARGET_CHANGED", "PLAYER_ENTERING_WORLD");
end