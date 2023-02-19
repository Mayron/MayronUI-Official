-- luacheck: ignore MayronUI self 143
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();
local C_ToolTipsModule = MayronUI:RegisterModule("Tooltips", L["Tooltips"]);

local tooltipStyle = _G.GAME_TOOLTIP_BACKDROP_STYLE_DEFAULT or _G.TOOLTIP_BACKDROP_STYLE_DEFAULT;
local gameTooltip = _G.GameTooltip;
local healthBar, powerBar = _G.GameTooltipStatusBar, nil;
local IsInGroup, IsInRaid, After = _G.IsInGroup, _G.IsInRaid, _G.C_Timer.After;
local TooltipDataProcessor, UnitIsDeadOrGhost = _G.TooltipDataProcessor, _G.UnitIsDeadOrGhost;

local originalSetBackdropBorderColor = gameTooltip.SetBackdropBorderColor;
gameTooltip.SetBackdropBorderColor = tk.Constants.DUMMY_FUNC;

local originalSetBackdropColor = gameTooltip.SetBackdropColor;
gameTooltip.SetBackdropColor = tk.Constants.DUMMY_FUNC;

local originalSetBackdrop = gameTooltip.SetBackdrop;

if (not obj:IsFunction(originalSetBackdrop)) then
  _G.Mixin(gameTooltip, _G.BackdropTemplateMixin);
  originalSetBackdrop = gameTooltip.SetBackdrop;
  originalSetBackdropColor = gameTooltip.SetBackdropColor;
  originalSetBackdropBorderColor = gameTooltip.SetBackdropBorderColor;
end

local select, IsAddOnLoaded, strformat, ipairs, UnitAura, unpack,
  UnitName, UnitHealthMax, UnitHealth, hooksecurefunc, UnitExists, UnitIsPlayer,
  GetGuildInfo, UnitRace, UnitCreatureFamily, UnitCreatureType, UnitReaction =
  _G.select, _G.IsAddOnLoaded, _G.string.format, _G.ipairs, _G.UnitAura, _G.unpack,
  _G.UnitName, _G.UnitHealthMax, _G.UnitHealth, _G.hooksecurefunc, _G.UnitExists, _G.UnitIsPlayer,
  _G.GetGuildInfo, _G.UnitRace, _G.UnitCreatureFamily, _G.UnitCreatureType, _G.UnitReaction;
local UnitPowerType, UnitPower, UnitPowerMax, min = _G.UnitPowerType, _G.UnitPower, _G.UnitPowerMax, _G.math.min;
local UnitLevel, CanInspect, UnitGUID, CheckInteractDistance =
  _G.UnitLevel, _G.CanInspect, _G.UnitGUID, _G.CheckInteractDistance;
local tostring, InCombatLockdown = _G.tostring, _G.InCombatLockdown;
local pairs = _G.pairs;

-- Constants
local HARMFUL = "HARMFUL";
local HELPFUL = "HELPFUL";
local ITEM_LEVEL_LABEL = "Item Level:";
local SPEC_LABEL = strformat("%s:", _G.SPECIALIZATION);
local AURA_SPACING = 2;

local tooltipsToReskin =  {
	"GameTooltip",
	"ShoppingTooltip1",
	"ShoppingTooltip2",
	"ItemRefTooltip",
	"ItemRefShoppingTooltip1",
	"ItemRefShoppingTooltip2",
	"AtlasLootTooltip",
	"QuestHelperTooltip",
	"QuestGuru_QuestWatchTooltip",
  "WorldMapCompareTooltip1",
  "WorldMapCompareTooltip2",
  "AdventureMap_MissionPinTooltip",
  "FriendsTooltip",
  "LibDBIconTooltip"
};

db:AddToDefaults("profile.tooltips", {
  enabled = not (select(1, IsAddOnLoaded("TipTac")));
  targetShown = true;
  guildRankShown = true;
  realmShown = true;
  itemLevelShown = true;
  specShown = true;
  font = "MUI_Font";
  flag = "None";
  standardFontSize = 14;
  headerFontSize = 16;
  scale = 0.8;
  muiTexture = {
    enabled = true;
    useTheme = true;
    custom = { 0, 0, 0, 1 }
  }; -- if true, does not use backdrop
  backdrop = {
    borderClassColored =  true;
    borderColor = { 0.4, 0.4, 0.4, 1 };
    bgColor = { 0, 0, 0, 0.8 };
    bgFile = "MUI_Solid",
    edgeFile = "Skinner",
    edgeSize = tk.Constants.BACKDROP_WITH_BACKGROUND.edgeSize,
    insets = { left = 0, right = 0, top = 0, bottom = 0 };
  };
  anchors = {
    screen = {
      point = "BOTTOMRIGHT";
      xOffset = -4;
      yOffset = 4;
    };
    mouse = {
      point = "ANCHOR_CURSOR_RIGHT";
      xOffset = 2;
      yOffset = 4;
    };
  },
  unitFrames = {
    show = true;
    hideInCombat = false;
    anchor = "screen";
  },
  worldUnits = {
    show = true;
    hideInCombat = false;
    anchor = "mouse";
  },
  standard = {
    show = true;
    hideInCombat = false;
    anchor = "screen";
  },
  colors = {
    buff    = { 0, 0, 0 };
    debuff  = { 0.76, 0.2, 0.2 };
    magic   = { 0.2, 0.6, 1 };
    disease = { 0.6, 0.4, 0 };
    poison  = { 0.0, 0.6, 0 };
    curse   = { 0.6, 0.0, 1 };
  };
  healthColors = {
    low = { r = 1, g = 77/255, b = 77/255 },
    medium = { r = 1, g = 1, b = 128/255 },
    high = { r = 86/255, g = 199/255, b = 89/255 }
  };
  powerColors = {
    ["MANA"] = { r = 0.22, g = 0.55, b = 1 };
    ["RAGE"] = { r = 0.45, g = 0, b = 0.02 };
    ["FOCUS"] = { r = 0.61, g = 0.43, b = 0.24 };
    ["ENERGY"] = { r = 1, g = 0.87, b = 0.22 };
    ["HAPPINESS"] = { r = 0.5, g = 0.9, b = 0.7 };
    ["RUNES"] = { r = 0.50, g = 0.50, b = 0.50 };
    ["RUNIC_POWER"] = { r = 0.43, g = 0.60, b = 0.87 };
    ["SOUL_SHARDS"] = { r = 0.58, g = 0.51, b = 0.79 };
    ["LUNAR_POWER"] = { r = 0.30, g = 0.52, b = 0.90 };
    ["HOLY_POWER"] = { r = 0.95, g = 0.90, b = 0.60 };
    ["MAELSTROM"] = { r = 0.00, g = 0.50, b = 1.00 };
    ["INSANITY"] = { r = 0.40, g = 0, b = 0.80 };
    ["COMBO_POINTS"] = { r = 1.00, g = 0.96, b = 0.41 };
    ["CHI"] = { r = 0.71, g = 1.0, b = 0.92 };
    ["ARCANE_CHARGES"] = { r = 0.1, g = 0.1, b = 0.98 };
    ["FURY"] = { r = 0.788, g = 0.259, b = 0.992 };
    ["PAIN"] = { r = 1, g = 0.61, b = 0 };
  };
  healthBar = {
    fontSize = 14;
    texture = "MUI_StatusBar";
    flag = "OUTLINE";
    format = "%"; -- or "", "n", "n/n"
    height = 18;
  };
  powerBar = {
    enabled = false;
    fontSize = 14;
    texture = "MUI_StatusBar";
    flag = "OUTLINE";
    format = "%"; -- or "", "n", "n/n"
    height = 18;
  };
  auras = {
    buffs = {
      enabled = true;
      onlyYours = false;
      size = 28;
      position = "TOP";
      direction = "rtl";
    };
    debuffs = {
      enabled = true;
      onlyYours = true;
      size = 28;
      position = "BOTTOM";
      direction = "rtl";
      aboveBuffs = true;
      colorByDebuffType = true;
    };
  };
});

local ManageGetterOverrides;

do
  local original = {};
  local new = {};

  function ManageGetterOverrides(data, tooltip, replace)
    local bgColor = data.settings.backdrop.bgColor;
    local borderColor = data.settings.backdrop.borderColor;
    local key = tostring(tooltip);

    if (replace) then
      new[key] = new[key] or obj:PopTable();
      original[key] = original[key] or obj:PopTable();

      new[key].GetBackdropColor = new[key].GetBackdropColor or function()
        return unpack(bgColor);
      end

      new[key].GetBackdropBorderColor = new[key].GetBackdropBorderColor or function()
        return unpack(borderColor);
      end

      new[key].GetBackdrop = new[key].GetBackdrop or function()
        return data.tooltipBackdrop;
      end

      original[key].GetBackdropColor = tooltip.GetBackdropColor;
      original[key].GetBackdropBorderColor = tooltip.GetBackdropBorderColor;
      original[key].GetBackdrop = tooltip.GetBackdrop;

      tooltip.GetBackdropColor = new[key].GetBackdropColor;
      tooltip.GetBackdropBorderColor = new[key].GetBackdropBorderColor;
      tooltip.GetBackdrop = new[key].GetBackdrop;

    elseif (obj:IsTable(original[key])) then
      tooltip.GetBackdropColor = original[key].GetBackdropColor;
      tooltip.GetBackdropBorderColor = original[key].GetBackdropBorderColor;
      tooltip.GetBackdrop = original[key].GetBackdrop;
    end
  end
end

local function SetBackdropStyle(data)
  local bgFile = tk.Constants.LSM:Fetch(tk.Constants.LSM.MediaType.BACKGROUND, data.settings.backdrop.bgFile);
  local edgeFile = tk.Constants.LSM:Fetch(tk.Constants.LSM.MediaType.BORDER, data.settings.backdrop.edgeFile);

  -- It won't update unless it's a completely new table
  if (obj:IsTable(data.tooltipBackdrop)) then
    obj:PushTable(data.tooltipBackdrop);
  end

  data.tooltipBackdrop = {};
  data.tooltipBackdrop.bgFile = bgFile;
  data.tooltipBackdrop.edgeFile = edgeFile;
  data.tooltipBackdrop.edgeSize = data.settings.backdrop.edgeSize;
  data.tooltipBackdrop.insets = data.settings.backdrop.insets;

  -- replace backdrop:
  if (tooltipStyle) then
    tooltipStyle.bgFile = data.tooltipBackdrop.bgFile;
    tooltipStyle.insets = data.tooltipBackdrop.insets;
    tooltipStyle.edgeFile = data.tooltipBackdrop.edgeFile;
    tooltipStyle.edgeSize = data.tooltipBackdrop.edgeSize;
  end

  for _, tooltipName in ipairs(tooltipsToReskin) do
    local tooltip = _G[tooltipName];

    if (obj:IsTable(tooltip) and obj:IsFunction(tooltip.GetObjectType)) then
      local scale = data.settings.scale;

      if (tooltip == _G.FriendsTooltip) then
        scale = scale + 0.2;
      end

      tooltip:SetScale(scale);

      if (tooltip.NineSlice) then
        tk:KillElement(tooltip.NineSlice);

        if (tooltip ~= gameTooltip) then
          _G.Mixin(tooltip, _G.BackdropTemplateMixin);
        end
      end

      if (data.settings.muiTexture.enabled) then
        tooltip:SetBackdrop(nil);
        tooltip.SetBackdrop = tk.Constants.DUMMY_FUNC;

        ManageGetterOverrides(data, tooltip, true);

        if (not obj:IsFunction(tooltip.SetGridTextureShown)) then
          local texture = tk.Constants.AddOnStyle:GetTexture("DialogBoxBackground");
          texture = strformat("%s%s", texture, "Medium");

          gui:CreateGridTexture(tooltip, texture, 10, 6, 512, 512);
        end

        if (data.settings.muiTexture.useTheme) then
          tk.Constants.AddOnStyle:ApplyColor(
            nil, nil, tooltip.tl, tooltip.tr, tooltip.bl, tooltip.br,
            tooltip.t, tooltip.b, tooltip.l, tooltip.r, tooltip.c);
        else
          -- custom color
          local r, g, b, a = unpack(data.settings.muiTexture.custom);
          tooltip:SetGridColor(r, g, b, a);
        end

        tooltip:SetGridTextureShown(true);
      else
        local borderColor = data.settings.backdrop.borderColor;
        local bgColor = data.settings.backdrop.bgColor;

        tooltip.SetBackdrop = originalSetBackdrop;
        ManageGetterOverrides(data, tooltip);

        tooltip:SetBackdrop(data.tooltipBackdrop);
        tooltip:SetBackdropBorderColor(unpack(borderColor));
        tooltip:SetBackdropColor(unpack(bgColor));

        if (tooltip == gameTooltip) then
          originalSetBackdropColor(tooltip, unpack(bgColor));
          originalSetBackdropBorderColor(tooltip, unpack(borderColor));
        else
          tooltip:SetBackdropBorderColor(unpack(borderColor));
          tooltip:SetBackdropColor(unpack(bgColor));
        end

        if (obj:IsFunction(tooltip.SetGridTextureShown)) then
          tooltip:SetGridTextureShown(false);
        end
      end
    end
  end
end

local function GetHealthColor(healthColors, currentHealth, maxHealth)
  local percent = maxHealth > 0 and (currentHealth / maxHealth) or 0;

  if (percent >= 1) then
    return healthColors.high.r, healthColors.high.g, healthColors.high.b;
  end

	if (percent == 0) then
    return healthColors.low.r, healthColors.low.g, healthColors.low.b;
  end

  -- start and end R,B,G values:
  local start, stop;

	if (percent > 0.5) then
    -- greater than half way
		start = healthColors.high;
		stop = healthColors.medium;
	else
    -- less than half way
		start = healthColors.medium;
		stop = healthColors.low;
	end

  return tk:MixColorsByPercentage(start, stop, percent);
end

local UpdateUnitHealthBar, UpdateUnitPowerBar;

do
  local function SetFormattedColoredText(fontString, format, percentage, current, max, r, g, b)
    if (tk.Strings:IsNilOrWhiteSpace(format) or percentage > 100) then
      fontString:SetText("");
      return
    end

    local text = tk.Strings.Empty;

    -- format can be: "%", "n", "n/n"
    if (format == "%" or max == 100) then
      text = strformat("%d%%", percentage);
    else
      if (current > 1000) then
        current = strformat("%.1fk", tk.Numbers:ToPrecision(current / 1000, 1));
      end

      if (format == "n") then
        -- current health
        text = tostring(current);
      elseif (format == "n/n") then
        -- current and max health
        if (max > 1000) then
          max = strformat("%.1fk", tk.Numbers:ToPrecision(max / 1000, 1));
        end

        text = strformat("%s/%s", tostring(current), tostring(max));
      end
    end

    fontString:SetText(tk.Strings:SetTextColorByRGB(text, r, g, b));
  end

  function UpdateUnitHealthBar(format, healthColors, unitID)
    local maxHealth = UnitHealthMax(unitID);
    local currentHealth = UnitHealth(unitID);
    local r, g, b = GetHealthColor(healthColors, currentHealth, maxHealth);
    local percentage = maxHealth > 0 and ((currentHealth / maxHealth) * 100) or 0;

    SetFormattedColoredText(healthBar.HealthText, format, percentage, currentHealth, maxHealth, r, g, b);
  end

  function UpdateUnitPowerBar(format, powerColors, unitID)
      -- verify unit is still using the same power type, if not, update the bar color
    local powerTypeID = UnitPowerType(unitID);
    if (powerTypeID < 0) then return end

    local currentPower = UnitPower(unitID, powerTypeID);
    local maxPower = UnitPowerMax(unitID, powerTypeID);

    powerBar:SetMinMaxValues(0, maxPower);
    powerBar:SetValue(currentPower);

    local powerType = tk.Constants.POWER_TYPES[powerTypeID];
    local powerColor = (obj:IsString(powerType) and powerColors[powerType])
      or _G.PowerBarColor[powerTypeID] or powerColors["ENERGY"];

    local r, g, b = powerColor.r, powerColor.g, powerColor.b;
    local percentage = maxPower > 0 and ((currentPower / maxPower) * 100) or 0;

    r, g, b = min(1, r*1.4), min(1, g*1.4), min(1, b*1.4);
    SetFormattedColoredText(powerBar.PowerText, format, percentage, currentPower, maxPower, r, g, b);
  end
end

local function SetFonts(data)
  local font = tk.Constants.LSM:Fetch(tk.Constants.LSM.MediaType.FONT, data.settings.font);
  local flag = data.settings.flag;
  local size = data.settings.standardFontSize;
  local headerSize = data.settings.headerFontSize;

  if (size <= 0) then
    size = 14;
  end

  if (headerSize <= 0) then
    headerSize = 16;
  end

  if (flag == "None") then
    flag = "";
  end

	_G.GameTooltipHeaderText:SetFont(font, headerSize, flag);
	_G.GameTooltipText:SetFont(font, size, flag);
	_G.GameTooltipTextSmall:SetFont(font, size, flag);

	if (_G.GameTooltipMoneyFrame1) then
		_G.GameTooltipMoneyFrame1PrefixText:SetFont(font, size, flag);
		_G.GameTooltipMoneyFrame1SuffixText:SetFont(font, size, flag);
		_G.GameTooltipMoneyFrame1CopperButtonText:SetFont(font, size, flag);
		_G.GameTooltipMoneyFrame1SilverButtonText:SetFont(font, size, flag);
		_G.GameTooltipMoneyFrame1GoldButtonText:SetFont(font, size, flag);
	end

  _G.ShoppingTooltip1TextLeft1:SetFont(font, size + 2, flag);
  _G.ShoppingTooltip1TextLeft2:SetFont(font, size, flag);
	_G.ShoppingTooltip1TextLeft3:SetFont(font, size, flag);

	_G.ShoppingTooltip2TextLeft1:SetFont(font, size + 2, flag);
	_G.ShoppingTooltip2TextLeft2:SetFont(font, size, flag);
	_G.ShoppingTooltip2TextLeft3:SetFont(font, size, flag);

	for i = 1, _G.ShoppingTooltip1:NumLines() do
		_G["ShoppingTooltip1TextRight"..i]:SetFont(font, size -2, flag);
	end

	for i = 1, _G.ShoppingTooltip2:NumLines() do
		_G["ShoppingTooltip2TextRight"..i]:SetFont(font, size -2, flag);
	end

  if (healthBar.HealthText) then
    healthBar.HealthText:SetFont(font, data.settings.healthBar.fontSize, data.settings.healthBar.flag);
  end

  if (powerBar and powerBar.PowerText) then
    powerBar.PowerText:SetFont(font, data.settings.powerBar.fontSize, data.settings.powerBar.flag);
  end
end

-- The lines that already exist (not adding anymore)
local function UpdateExistingUnitTooltipLines(data, unitID)
  local totalLines = gameTooltip:NumLines();

	for i = 1, totalLines do
		local line = _G["GameTooltipTextLeft"..i];

    if (i == 1) then
      -- HEADER
      local realmShown = data.settings.realmShown;
      local unitNameText = tk.Strings:GetUnitFullNameText(unitID, nil, nil, realmShown);
      line:SetText(unitNameText);

    elseif (UnitIsPlayer(unitID)) then
      -- guild Name
      local guild, guildRank = GetGuildInfo(unitID);
      if (i == 2 and guild) then
        local yourGuild = GetGuildInfo("PLAYER");
        local guildTextColor = guild == yourGuild and "TRANSMOG_VIOLET" or "YELLOW";
        local guildText = tk.Strings:SetTextColorByKey(strformat("<%s>", guild), guildTextColor);

        if (data.settings.guildRankShown) then
          local guildRankText = tk.Strings:SetTextColorByKey(guildRank, "GRAY");
          line:SetFormattedText("%s %s", guildText, guildRankText);
        else
          line:SetText(guildText);
        end

      elseif ((not guild and i == 2) or (guild and i == 3)) then
        local race = UnitRace(unitID);
        local fileName = tk:GetClassFileNameByUnitID(unitID);
        local localizedName = tk:GetLocalizedClassNameByFileName(fileName, true);

        line:SetFormattedText("%s %s (%s)", race, localizedName, _G.PLAYER);
      end
    else
      local text = line:GetText();

      if (tk.Strings:Contains(text, _G.LEVEL)) then
        local family = UnitCreatureFamily(unitID);

        if (family) then
          line:SetFormattedText("%s %s", UnitCreatureType(unitID), tk.Strings:SetTextColorByKey(family, "GRAY"));
        else
          line:SetText(UnitCreatureType(unitID));
        end
      end
    end
	end
end

local UpdateUnitStatusBars;

do
  local originalSetStatusBarColor = healthBar.SetStatusBarColor;

  function UpdateUnitStatusBars(data, unitID)
    local color = tk:GetClassColorByUnitID(unitID);

    if (gameTooltip.SetGridColor) then
      if (UnitIsPlayer(unitID)) then
        gameTooltip:SetGridColor(color.r, color.g, color.b);
      else
        local r, g, b = tk:GetThemeColor();
        gameTooltip:SetGridColor(r, g, b);
      end
    end

    if (UnitIsPlayer(unitID) and color) then
      originalSetStatusBarColor(healthBar, color.r, color.g, color.b);

      if (not data.settings.muiTexture.enabled and data.settings.backdrop.borderClassColored) then
        originalSetBackdropBorderColor(gameTooltip, color.r, color.g, color.b, data.settings.backdrop.borderColor[4]);
      end
    else
      local reaction = UnitReaction(unitID, "player");
      local r, g, b;

      if (reaction) then
        r = tk.Constants.FACTION_BAR_COLORS[reaction].r;
        g = tk.Constants.FACTION_BAR_COLORS[reaction].g;
        b = tk.Constants.FACTION_BAR_COLORS[reaction].b;
      else
        local maxHealth = UnitHealthMax(unitID);
        local currentHealth = UnitHealth(unitID);
        r, g, b = GetHealthColor(data.settings.healthColors, currentHealth, maxHealth);
      end

      originalSetStatusBarColor(healthBar, r, g, b);

      if (not data.settings.muiTexture.enabled and data.settings.backdrop.borderClassColored) then
        originalSetBackdropBorderColor(gameTooltip, r, g, b, data.settings.backdrop.borderColor[4]);
      end
    end

    UpdateUnitHealthBar(data.settings.healthBar.format, data.settings.healthColors, unitID);

    if (not (powerBar and powerBar.PowerText)) then return end
    local powerTypeID = UnitPowerType(unitID);

    local show = data.settings.powerBar.enabled and powerTypeID >= 0;
    powerBar:SetShown(show);

    if (not show) then return end
    UpdateUnitPowerBar(data.settings.powerBar.format, data.settings.powerColors, unitID);

    local powerType = tk.Constants.POWER_TYPES[powerTypeID];
    local powerColor = (obj:IsString(powerType) and data.settings.powerColors[powerType])
      or _G.PowerBarColor[powerTypeID] or data.settings.powerColors["ENERGY"];

    local r, g, b = powerColor.r, powerColor.g, powerColor.b;
    powerBar:SetStatusBarColor(r, g, b);
    powerBar.bg:SetBackdropColor(r*0.4, g*0.4, b*0.4);
  end
end

local function HideAllAuras(data)
  if (obj:IsTable(data.buffs)) then
    for _, f in ipairs(data.buffs) do
      f:ClearAllPoints();
      f:Hide();
    end
  end

  if (obj:IsTable(data.debuffs)) then
    for _, f in ipairs(data.debuffs) do
      f:ClearAllPoints();
      f:Hide();
    end
  end
end

local function AddAuras(data, filter, anchor, unitID)
  local id = 1;
  local previousFrame;
  local totalWidth = 0;
  local previousFirstRow = anchor;
  local maxWidth = gameTooltip:GetWidth();
  local maxAuras, auraFrames, settings;

  if (filter == HELPFUL) then
    maxAuras = _G.BUFF_MAX_DISPLAY;
    auraFrames = data.buffs;
    settings = data.settings.auras.buffs;
  else
    maxAuras = _G.DEBUFF_MAX_DISPLAY;
    auraFrames = data.debuffs;
    settings = data.settings.auras.debuffs;
  end

  for index = 1, maxAuras do
    local auraName, iconTexture, _, auraType, duration, endTime, source = UnitAura(unitID, index, filter);
    local show = true;

    if (settings.onlyYours and source ~= "player") then
      show = false;
    end

    if (auraName and iconTexture and show) then
      local frame = auraFrames[id];

      if (not frame) then
        auraFrames[id] = tk:CreateFrame("Frame", gameTooltip, nil, _G.BackdropTemplateMixin and "BackdropTemplate");
        frame = auraFrames[id];

        frame:SetBackdrop(data.auraBackdrop);
        local edge = tk.Constants.BACKDROP.edgeSize;

        frame.iconTexture = frame:CreateTexture(nil, "ARTWORK");
        frame.iconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9);
        frame.iconTexture:SetPoint("TOPLEFT", edge, -edge);
        frame.iconTexture:SetPoint("BOTTOMRIGHT", -edge, edge);

        frame.cooldown = tk:CreateFrame("Cooldown", frame, nil, _G.BackdropTemplateMixin and "CooldownFrameTemplate");
        frame.cooldown:SetReverse(1);
        frame.cooldown:SetPoint("TOPLEFT", edge, -edge);
        frame.cooldown:SetPoint("BOTTOMRIGHT", -edge, edge);
        frame.cooldown:SetFrameLevel(frame:GetFrameLevel() + 1);
      end

      frame:SetSize(settings.size, settings.size);

      if (duration and duration > 0 and endTime and endTime > 0) then
				frame.cooldown:SetCooldown(endTime - duration, duration);
			else
				frame.cooldown:Hide();
			end

      frame:ClearAllPoints();

      if (filter == HARMFUL) then
        local auraColor =  data.settings.colors.debuff;

        if (settings.colorByDebuffType and auraType) then
          auraColor = data.settings.colors[auraType:lower()] or auraColor;
        end

        frame:SetBackdropBorderColor(unpack(auraColor));
      else
        frame:SetBackdropBorderColor(unpack(data.settings.colors.buff));
      end

      local newTotalWidth = totalWidth + frame:GetWidth() + AURA_SPACING;
      if (previousFrame and newTotalWidth <= maxWidth) then
        local point, relativePoint = "LEFT", "RIGHT";
        local xOffset = AURA_SPACING;

        if (settings.direction == "rtl") then
          point, relativePoint = "RIGHT", "LEFT";
          xOffset = -xOffset;
        end

        frame:SetPoint(point, previousFrame, relativePoint, xOffset, 0);
        totalWidth = newTotalWidth;
      else
        -- main anchor!
        local xOffset = previousFirstRow == gameTooltip and -1 or 0;
        local yOffset = id == 1 and 5 or AURA_SPACING;
        local horizontal = "LEFT";
        local verticlePoint, verticleRelativePoint = "BOTTOM", "TOP";

        if (settings.direction == "rtl") then
          horizontal = "RIGHT";
          xOffset = -xOffset;
        end

        if (settings.position == "BOTTOM") then
          verticlePoint, verticleRelativePoint = "TOP", "BOTTOM";
          yOffset = -yOffset;
        end

        local point = verticlePoint..horizontal;
        local relativePoint = verticleRelativePoint..horizontal;

        frame:SetPoint(point, previousFirstRow, relativePoint, xOffset, yOffset);
        previousFirstRow = frame;
        totalWidth = frame:GetWidth();
      end

      frame.iconTexture:SetTexture(iconTexture);
      frame:Show();

      previousFrame = frame;
      id = id + 1;
    end
  end

  return previousFirstRow;
end

local function UpdateUnitAuras(data, unitID)
  if (not data.auraBackdrop) then
    data.auraBackdrop = obj:PopTable();
    data.auraBackdrop.edgeFile = tk.Constants.LSM:Fetch("border", "Skinner");
    data.auraBackdrop.edgeSize = tk.Constants.BACKDROP.edgeSize;
  end

  HideAllAuras(data);

  local relativeFrame = gameTooltip;
  local buffsEnabled = data.settings.auras.buffs.enabled;
  local debuffsEnabled = data.settings.auras.debuffs.enabled;
  local samePositions = (data.settings.auras.buffs.position == data.settings.auras.debuffs.position);

  local debuffsFirst = true;

  if (samePositions) then
    if (data.settings.auras.debuffs.aboveBuffs) then
      if (data.settings.auras.buffs.position == "TOP") then
        debuffsFirst = false; -- if top, then debuffs need to go last to appear above buffs
      end
    else
      if (data.settings.auras.buffs.position == "BOTTOM") then
        debuffsFirst = false; -- if bottom, then debuffs need to go last to appear below buffs
      end
    end
  end

  data.buffs = buffsEnabled and (data.buffs or obj:PopTable());
  data.debuffs = debuffsEnabled and (data.debuffs or obj:PopTable());

  if (debuffsEnabled and debuffsFirst) then
    local nextRelativeFrame = AddAuras(data, HARMFUL, relativeFrame, unitID);

    if (samePositions) then
      relativeFrame = nextRelativeFrame;
    end

    if (buffsEnabled) then
      AddAuras(data, HELPFUL, relativeFrame, unitID);
    end
  else
    if (buffsEnabled) then
      local nextRelativeFrame = AddAuras(data, HELPFUL, relativeFrame, unitID);

      if (samePositions) then
        relativeFrame = nextRelativeFrame;
      end
    end

    if (debuffsEnabled) then
      AddAuras(data, HARMFUL, relativeFrame, unitID);
    end
  end
end

local function RefreshPadding(data)
  local space = data.settings.healthBar.height + 4; -- spacing between bar and text

  if (data.settings.powerBar.enabled and powerBar and powerBar:IsShown()) then
    space = space + data.settings.powerBar.height + 4; -- spacing between bars
  end

  if (healthBar:IsShown()) then
    gameTooltip:SetPadding(0, space);
  else
    gameTooltip:SetPadding(0, 0);
  end
end

local function SetDoubleLine(data, leftText, rightText)
  local totalLines = gameTooltip:NumLines();

	for i = totalLines, 1, -1  do
		local line1 = _G["GameTooltipTextLeft"..i];
		local line2 = _G["GameTooltipTextRight"..i];
    local text = line1:GetText();

    if (text == leftText) then
      if (rightText) then
        line2:SetText(rightText);
      else
        line1:SetText("");
        line2:SetText("");
      end

      return
    end
  end

  if (rightText) then
    gameTooltip:AddDoubleLine(leftText, rightText);
  end

  RefreshPadding(data);
end

local function UpdateTargetText(data, unitID)
  local targetUnitId = unitID.."Target";
  local targetName = UnitName(targetUnitId);

  if (targetName) then
    if (UnitName("player") == targetName) then
      targetName = tk.Strings:SetTextColorByKey("YOU", "YELLOW");
    else
      targetName = tk.Strings:GetUnitNameText(targetUnitId);
    end
  end

  SetDoubleLine(data, "Target:", targetName);
end

local function UpdateSpecAndItemLevel(data, unitID, updateTooltip)
  if ((data.settings.specShown or data.settings.itemLevelShown) and UnitExists(unitID)) then
    local unitGuid = UnitGUID(unitID);

    if (unitGuid) then
      local foundSpec = data.specCache[unitGuid];
      local foundItemLevel = data.itemLevelCache[unitGuid];
      local shouldFindSpec = not foundSpec and data.settings.specShown;
      local shouldFindItemLevel = not foundItemLevel and data.settings.itemLevelShown;

      if (updateTooltip and foundSpec and data.settings.specShown) then
        SetDoubleLine(data, SPEC_LABEL, foundSpec);
      end

      if (updateTooltip and foundItemLevel and data.settings.itemLevelShown) then
        SetDoubleLine(data, ITEM_LEVEL_LABEL, foundItemLevel);
      end

      if ((shouldFindSpec or shouldFindItemLevel) and not InCombatLockdown() and not UnitIsDeadOrGhost("player")) then
        if (not data.notifying and
          UnitIsPlayer(unitID) and
          CheckInteractDistance(unitID, 1) and
          UnitLevel(unitID) >= 10) then

          if (CanInspect(unitID, false)) then
            if (not (_G.InspectFrame and _G.InspectFrame:IsVisible())) then
              if (updateTooltip and shouldFindSpec) then
                SetDoubleLine(data, SPEC_LABEL, "loading...");
              end

              if (updateTooltip and shouldFindItemLevel) then
                SetDoubleLine(data, ITEM_LEVEL_LABEL, "loading...");
              end

              After(0.2, function()
                if (UnitGUID(unitID) == unitGuid) then
                  data.notifying = unitGuid;
                  _G.NotifyInspect(unitID);
                end
              end);

              return true;
            end
          end
        end
      end
    end
  end

  return false;
end

local function CreatePowerBar(data)
  powerBar = tk:CreateFrame("StatusBar", healthBar, "GameTooltipPowerBar",
    _G.BackdropTemplateMixin and "BackdropTemplate");
  powerBar:SetHeight(data.settings.powerBar.height);

  local statusBarTexture = tk.Constants.LSM:Fetch("statusbar", data.settings.powerBar.texture);
  powerBar:SetStatusBarTexture(statusBarTexture);
  powerBar:SetFrameLevel(10);

  -- Create backdrop for status bar:
  powerBar.bg = tk:CreateFrame("Frame", powerBar, nil, _G.BackdropTemplateMixin and "BackdropTemplate");
  powerBar.bg:SetAllPoints();
	powerBar.bg:SetFrameLevel(healthBar:GetFrameLevel() - 1);
	powerBar.bg:SetBackdrop({ bgFile = tk.Constants.BACKDROP_WITH_BACKGROUND.bgFile });

  local powerText = powerBar:CreateFontString(nil, "OVERLAY");
  local font = tk.Constants.LSM:Fetch(tk.Constants.LSM.MediaType.FONT, data.settings.font);

  powerText:SetFont(font, data.settings.powerBar.fontSize, data.settings.powerBar.flag);
  powerText:SetPoint("CENTER");
  powerBar.PowerText = powerText;
end

local function ApplyHealthBarChanges(data)
  local r, g, b = tk:GetThemeColor();

  local statusBarTexture = tk.Constants.LSM:Fetch("statusbar", data.settings.healthBar.texture);
  healthBar:SetStatusBarTexture(statusBarTexture);
  healthBar:SetStatusBarColor(r, g, b);
  healthBar:SetFrameLevel(10);
  healthBar.SetStatusBarColor = tk.Constants.DUMMY_FUNC;

  -- Create backdrop for status bar:
  healthBar.bg = tk:CreateFrame("Frame", healthBar, nil, _G.BackdropTemplateMixin and "BackdropTemplate");
  healthBar.bg:SetAllPoints();
	healthBar.bg:SetFrameLevel(healthBar:GetFrameLevel() - 1);
	healthBar.bg:SetBackdrop({ bgFile = tk.Constants.BACKDROP_WITH_BACKGROUND.bgFile });
	healthBar.bg:SetBackdropColor(r * 0.4, g * 0.4, b * 0.4);

  local healthText = healthBar:CreateFontString(nil, "OVERLAY");
  healthText:SetPoint("CENTER");
  healthBar.HealthText = healthText;
end

local function PositionStatusBars(data)
  if (powerBar and data.settings.powerBar.enabled) then
    powerBar:ClearAllPoints();
    healthBar:ClearAllPoints();

    healthBar:SetPoint("BOTTOMLEFT", 7, 7 + data.settings.powerBar.height + 4);
    healthBar:SetPoint("BOTTOMRIGHT", -7, 7 + data.settings.powerBar.height + 4);

    powerBar:SetPoint("TOPLEFT", healthBar, "BOTTOMLEFT", 0, -4);
    powerBar:SetPoint("TOPRIGHT", healthBar, "BOTTOMRIGHT", 0, -4);
  else
    healthBar:ClearAllPoints();
    healthBar:SetPoint("BOTTOMLEFT", 7, 7);
    healthBar:SetPoint("BOTTOMRIGHT", -7, 7);
  end
end

local function CreateScreenAnchor(data)
  data.screenAnchor = tk:CreateFrame("Frame");
  data.screenAnchor:SetFrameStrata("TOOLTIP");
  tk:MakeMovable(data.screenAnchor);
  data.screenAnchor:SetSize(240, 150);

  data.screenAnchor:SetPoint(data.settings.anchors.screen.point,
    data.settings.anchors.screen.xOffset,
    data.settings.anchors.screen.yOffset);

  data.screenAnchor.bg = tk:SetBackground(data.screenAnchor, unpack(data.settings.backdrop.bgColor));
  data.screenAnchor.bg:SetAllPoints(true);

  data.screenAnchor.bg.text = data.screenAnchor:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
  data.screenAnchor.bg.text:SetText("Tool-tip screen anchor point (Drag me!)");
  data.screenAnchor.bg.text:SetWidth(200);
  data.screenAnchor.bg.text:SetPoint("CENTER");

  function data.screenAnchor:Unlock()
    data.screenAnchor:ClearAllPoints();
    data.screenAnchor:SetPoint(data.settings.anchors.screen.point,
      data.settings.anchors.screen.xOffset,
      data.settings.anchors.screen.yOffset);

    data.screenAnchor.bg:SetAlpha(data.settings.backdrop.bgColor[4]);
    data.screenAnchor.bg.text:SetAlpha(1);
    data.screenAnchor:EnableMouse(true);
    data.screenAnchor:SetMovable(true);
  end

  function data.screenAnchor:Lock(dontSave)
    data.screenAnchor.bg:SetAlpha(0);
    data.screenAnchor.bg.text:SetAlpha(0);
    data.screenAnchor:EnableMouse(false);
    data.screenAnchor:SetMovable(false);

    -- save changes:
    if (not dontSave) then
      local positions = tk.Tables:GetFramePosition(data.screenAnchor);

      if (obj:IsTable(positions)) then
        db:SetPathValue("profile.tooltips.anchors.screen", {
          point = positions[1];
          xOffset = positions[4] or 0;
          yOffset = positions[5] or 0
        });
      end

      return positions;
    end
  end

  data.screenAnchor:Lock(true);
end

local function ShouldBeHidden(data, tooltip)
  local _, unitID = tooltip:GetUnit();
  local inCombat = InCombatLockdown();

  if (unitID) then
    if ((inCombat and data.settings.unitFrames.hideInCombat) or not data.settings.unitFrames.show) then
      if (unitID ~= "mouseover") then
        tooltip:Hide();
        return true;
      end
    end

    if ((inCombat and data.settings.worldUnits.hideInCombat) or not data.settings.worldUnits.show) then
      if (unitID == "mouseover") then
        tooltip:Hide();
        return true;
      end
    end

  elseif ((inCombat and data.settings.standard.hideInCombat) or not data.settings.standard.show) then
    tooltip:Hide();
    return true;
  end

  return false;
end

-------------------------------
--- C_ToolTipsModule
-------------------------------
function C_ToolTipsModule:OnInitialize(data)
  local function SetFontsWrapper()
    SetFonts(data);
  end

  local function SetBackdropStyleWrapper()
    SetBackdropStyle(data);
  end

	self:RegisterUpdateFunctions(db.profile.tooltips, {
    font = SetFontsWrapper;--"MUI_Font";
    flag = SetFontsWrapper;
    standardFontSize = SetFontsWrapper; --14;
    headerFontSize = SetFontsWrapper; --16;
    scale = SetBackdropStyleWrapper; --0.8
    muiTexture = SetBackdropStyleWrapper; -- if true, does not use backdrop
    backdrop = SetBackdropStyleWrapper;
    healthBar = {
      fontSize = function(value)
        if (healthBar.HealthText) then
          local font = tk.Constants.LSM:Fetch(tk.Constants.LSM.MediaType.FONT, data.settings.font);
          healthBar.HealthText:SetFont(font, value, data.settings.healthBar.flag);
        end
      end;
      flag = function(value)
        if (healthBar.HealthText) then
          local font = tk.Constants.LSM:Fetch(tk.Constants.LSM.MediaType.FONT, data.settings.font);
          healthBar.HealthText:SetFont(font, data.settings.healthBar.fontSize, value);
        end
      end;
      texture = function(value)
        local statusBarTexture = tk.Constants.LSM:Fetch("statusbar", value);
        healthBar:SetStatusBarTexture(statusBarTexture);
      end;--"MUI_StatusBar";
      height = function(value)
        healthBar:SetHeight(value);
        PositionStatusBars(data);
      end;
    };
    anchors = {
      screen = function()
        data.screenAnchor:ClearAllPoints();
        data.screenAnchor:SetPoint(
          data.settings.anchors.screen.point,
          data.settings.anchors.screen.xOffset,
          data.settings.anchors.screen.yOffset);
      end;
    };
    powerBar = {
      enabled = function(value)
        if (value and not powerBar) then
          CreatePowerBar(data);
        end

        PositionStatusBars(data);
      end;
      fontSize = function(value)
        if (powerBar and powerBar.PowerText) then
          local font = tk.Constants.LSM:Fetch(tk.Constants.LSM.MediaType.FONT, data.settings.font);
          powerBar.PowerText:SetFont(font, value, data.settings.powerBar.flag);
        end
      end;
      flag = function(value)
        if (powerBar and powerBar.PowerText) then
          local font = tk.Constants.LSM:Fetch(tk.Constants.LSM.MediaType.FONT, data.settings.font);
          powerBar.PowerText:SetFont(font, data.settings.powerBar.fontSize, value);
        end
      end;
      texture = function(value)
        if (not powerBar) then return end
        local statusBarTexture = tk.Constants.LSM:Fetch("statusbar", value);
        powerBar:SetStatusBarTexture(statusBarTexture);
      end;
      height = function(value)
        if (not powerBar) then return end
        powerBar:SetHeight(value);
        PositionStatusBars(data);
      end;
    };
  });
end

local function TransferGuid(newCache, cache, guid)
  if (obj:IsString(guid) and cache[guid] and not newCache[guid]) then
    newCache[#newCache + 1] = guid;
    newCache[guid] = cache[guid];
  end
end

local function CleanCache(cache)
  if (cache and #cache > 0) then
    local newCache = obj:PopTable();

    if (IsInGroup()) then
      if (IsInRaid()) then
        for userIndex = 1, 40 do
          local unitID = ("raid%d"):format(userIndex);

          if (UnitExists(unitID)) then
            local guid = UnitGUID(unitID);
            TransferGuid(newCache, cache, guid);
          end
        end
      else
        for userIndex = 1, 5 do
          local unitID = ("party%d"):format(userIndex);

          if (UnitExists(unitID)) then
            local guid = UnitGUID(unitID);
            TransferGuid(newCache, cache, guid);
          end
        end
      end
    end

    local totalItems = #cache;
    local itemsToRemove = math.ceil(#cache * 0.3);

    local newTotal = math.min(totalItems - itemsToRemove, 50);

    if (#newCache < newTotal) then
      for index, guid in pairs(cache) do
        if (obj:IsNumber(index)) then
          TransferGuid(newCache, cache, guid);
          if (#newCache >= newTotal) then
            break
          end
        end
      end
    end

    obj:EmptyTable(cache);
    tk.Tables:Fill(cache, newCache);
    obj:PushTable(newCache);
  end
end

local function RunCacheMaintenanceTask(data)
  if (not InCombatLockdown()) then
    data.notifying = "BLOCKED";
    CleanCache(data.specCache);
    CleanCache(data.itemLevelCache);
    data.notifying = nil;
  end
end

function C_ToolTipsModule:OnInitialized(data)
  if (data.settings.enabled and not IsAddOnLoaded("TipTac")) then
    self:SetEnabled(true);
  end
end

function C_ToolTipsModule:OnEnable(data)
  if (not data.screenAnchor) then
    CreateScreenAnchor(data);
  end

  data.specCache = {};
  data.itemLevelCache = {};

	-- Fixes inconsistency with Blizzard code to support backdrop alphas:
  if (tooltipStyle) then
    tooltipStyle.backdropColor.GetRGB = _G.ColorMixin.GetRGBA;
    tooltipStyle.backdropBorderColor.GetRGB = _G.ColorMixin.GetRGBA;
  end

  ApplyHealthBarChanges(data);

  gameTooltip:HookScript("OnShow", function(self)
    if (ShouldBeHidden(data, self)) then return end

    if (not self:GetUnit()) then
      HideAllAuras(data);
      if (self.SetGridColor) then
        local r, g, b = tk:GetThemeColor();
        self:SetGridColor(r, g, b);
      end
    end

    RefreshPadding(data); -- Needed for DF
  end);

  gameTooltip:HookScript("OnUpdate", function(self, elapsed)
    data.lastUpdated = (data.lastUpdated or 0) + elapsed;

    if (data.lastUpdated > 0.2) then
      data.lastUpdated = 0;

      local _, unitID = self:GetUnit();

      if (unitID) then
        local unitGuid = UnitGUID(unitID);

        local previouslyInspected = data.itemLevelCache[unitGuid] or data.specCache[unitGuid];
        if (data.settings.itemLevelShown and previouslyInspected) then
          local itemLevel = tk:GetInspectItemLevel(unitID);

          if (itemLevel > 0) then
            if (data.itemLevelCache[unitGuid] == nil and data.notifying ~= unitGuid) then
              data.itemLevelCache[#data.itemLevelCache + 1] = unitGuid;
            end

            -- Update existing entry:
            data.itemLevelCache[unitGuid] = itemLevel;

            SetDoubleLine(data, ITEM_LEVEL_LABEL, itemLevel);
          end
        end

        if (data.settings.specShown and data.specCache[unitGuid]) then
          SetDoubleLine(data, SPEC_LABEL, data.specCache[unitGuid]);
        end

        -- apply tooltip real time updates
        UpdateUnitHealthBar(data.settings.healthBar.format, data.settings.healthColors, unitID);

        if (data.settings.powerBar.enabled) then
          UpdateUnitPowerBar(data.settings.powerBar.format, data.settings.powerColors, unitID);
        end

        UpdateUnitAuras(data, unitID);

        if (data.settings.targetShown) then
          UpdateTargetText(data, unitID);
        end
      end
    end
  end);

  hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
    if (parent) then
      local anchorType = data.settings.standard.anchor:lower();
      local isWorldUnit = UnitExists("mouseover") and not parent.unit;
      local isUnitFrame = parent.unit ~= nil;

      if (isWorldUnit) then
        anchorType = data.settings.worldUnits.anchor:lower();
      elseif (isUnitFrame) then
        anchorType = data.settings.unitFrames.anchor:lower();
      end

      local anchor = data.settings.anchors[anchorType];
      self:ClearAllPoints();

      if (anchorType == "mouse") then
        self:SetOwner(parent, anchor.point, anchor.xOffset, anchor.yOffset);
      else
        self:SetOwner(parent, "ANCHOR_NONE");
        self:SetPoint(anchor.point, data.screenAnchor, anchor.point); -- the new anchor point
      end
    end
  end);

  local function OnTooltipSetUnit(self)
    local _, unitID = self:GetUnit();

    if (unitID) then
      UpdateExistingUnitTooltipLines(data, unitID); -- must be BEFORE padding
      UpdateUnitStatusBars(data, unitID); -- power bar + colours and styling
      UpdateTargetText(data, unitID);
      UpdateSpecAndItemLevel(data, unitID, true);
    end

    RefreshPadding(data);
  end

  if (tk:IsRetail() and TooltipDataProcessor) then
    TooltipDataProcessor.AddTooltipPostCall(_G.Enum.TooltipDataType.Unit, function(self, ...)
      if (self == gameTooltip) then
        OnTooltipSetUnit(self, ...);
      end
    end);
  else
    gameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit);
  end

  local inspectListener = em:CreateEventListener(function(_, _, unitGuid)
    local foundUnitID = nil;

    if (data.notifying == unitGuid) then
      data.notifying = nil;
    end

    if (UnitGUID("mouseover") == unitGuid) then
      foundUnitID = "mouseover";

    elseif (UnitGUID("player") == unitGuid) then
      foundUnitID = "player";

    elseif (IsInGroup()) then
      if (IsInRaid()) then
        for userIndex = 1, 40 do
          local unitID = ("raid%d"):format(userIndex);

          if (UnitExists(unitID) and UnitGUID(unitID) == unitGuid) then
            foundUnitID = unitID;
            break
          end
        end
      else
        for userIndex = 1, 5 do
          local unitID = ("party%d"):format(userIndex);

          if (UnitExists(unitID) and UnitGUID(unitID) == unitGuid) then
            foundUnitID = unitID;
            break
          end
        end
      end
    end

    if (not foundUnitID) then
      return
    end

    local specName = tk:GetPlayerSpecialization(nil, foundUnitID);

    if (tk.Strings:IsNilOrWhiteSpace(specName)) then
      specName = L["No Spec"];
    end

    local _, tooltipUnitID = gameTooltip:GetUnit();
    local tooltipGuid;

    if (tooltipUnitID) then
      tooltipGuid = UnitGUID(tooltipUnitID);
    end

    if (data.settings.specShown) then
      data.specCache[unitGuid] = specName;
      data.specCache[#data.specCache + 1] = unitGuid;

      if (tooltipGuid == unitGuid) then
        SetDoubleLine(data, SPEC_LABEL, specName);
      end
    end

    if (data.settings.itemLevelShown) then
      local itemLevel = tk:GetInspectItemLevel(foundUnitID);

      if (itemLevel > 0)  then
        data.itemLevelCache[unitGuid] = itemLevel;
        data.itemLevelCache[#data.itemLevelCache + 1] = unitGuid;

        if (tooltipGuid == unitGuid) then
          SetDoubleLine(data, ITEM_LEVEL_LABEL, itemLevel);
        end
      end
    end
  end);

  inspectListener:RegisterEvent("INSPECT_READY");

  local f = _G.CreateFrame("Frame");
  f:RegisterEvent("PLAYER_REGEN_ENABLED");
  f:SetScript("OnEvent", function(self)
    self.lastUpdated = 0;
    self.cacheUpdate = 0;
  end);

  f:SetScript("OnUpdate", function(self, elapsed)
    self.lastUpdated = (self.lastUpdated or 0) + elapsed;
    self.cacheUpdate = (self.cacheUpdate or 0) + elapsed;

    local tooManySpecs = data.specCache and #data.specCache > 100;
    local tooManyItemLevels = data.itemLevelCache and #data.itemLevelCache > 100;

    if (self.cacheUpdate > 300 or tooManySpecs or tooManyItemLevels) then
      self.cacheUpdate = 0;
      RunCacheMaintenanceTask(data);
    end

    if (self.lastUpdated > 5) then
      self.lastUpdated = 0;
      data.notifying = nil;

      local _, tooltipUnit = gameTooltip:GetUnit();
      if (tooltipUnit) then return end

      if (IsInGroup()) then
        if (IsInRaid()) then
          for userIndex = 1, 40 do
            local unitID = ("raid%d"):format(userIndex);
            local notifyRequestSent = UpdateSpecAndItemLevel(data, unitID, false);

            if (notifyRequestSent) then
              break
            end
          end
        else
          for userIndex = 1, 5 do
            local unitID = ("party%d"):format(userIndex);
            local notifyRequestSent = UpdateSpecAndItemLevel(data, unitID, false);

            if (notifyRequestSent) then
              break
            end
          end
        end
      end
    end
  end);
end