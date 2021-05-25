-- luacheck: ignore MayronUI self 143
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();
local C_ToolTipsModule = MayronUI:RegisterModule("ToolTips", "Tool Tips");

local tooltipStyle = _G.GAME_TOOLTIP_BACKDROP_STYLE_DEFAULT or _G.TOOLTIP_BACKDROP_STYLE_DEFAULT;
local gameTooltip = _G.GameTooltip;
local healthBar, powerBar = _G.GameTooltipStatusBar, nil;

local select, IsAddOnLoaded, strformat, ipairs, CreateFrame, UnitAura, unpack,
  UnitName, UnitHealthMax, UnitHealth, hooksecurefunc, UnitExists, UnitIsPlayer,
  GetGuildInfo, UnitRace, UnitCreatureFamily, UnitCreatureType, UnitReaction =
  _G.select, _G.IsAddOnLoaded, _G.string.format, _G.ipairs, _G.CreateFrame, _G.UnitAura, _G.unpack,
  _G.UnitName, _G.UnitHealthMax, _G.UnitHealth, _G.hooksecurefunc, _G.UnitExists, _G.UnitIsPlayer,
  _G.GetGuildInfo, _G.UnitRace, _G.UnitCreatureFamily, _G.UnitCreatureType, _G.UnitReaction;
local UnitPowerType, UnitPower, UnitPowerMax, min = _G.UnitPowerType, _G.UnitPower, _G.UnitPowerMax, _G.math.min;
local UnitLevel, CanInspect, UnitGUID, CheckInteractDistance, GetInspectSpecialization,
  C_PaperDollInfo, GetSpecializationInfoByID = _G.UnitLevel, _G.CanInspect, _G.UnitGUID, _G.CheckInteractDistance,
  _G.GetInspectSpecialization, _G.C_PaperDollInfo, _G.GetSpecializationInfoByID;

-- Constants
local MOUSEOVER = "MOUSEOVER";
local HARMFUL = "HARMFUL";
local HELPFUL = "HELPFUL";
local ITEM_LEVEL_LABEL = "Item Level:";
local LOADING = "loading...";
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
  "FriendsTooltip"
};

db:AddToDefaults("profile.tooltips", {
  enabled = not (select(1, IsAddOnLoaded("TipTac")));
  targetShown = true;
  guildRankShown = true;
  itemLevelShown = true;
  specShown = true;
  font = "MUI_Font";
  flag = "None";
  standardFontSize = 14;
  headerFontSize = 16;
  scale = 0.8;
  muiTexture = {
    enabled = true;
    color = "theme"; -- or "custom"
    custom = { 0, 0, 0, 1 }
  }; -- if true, does not use backdrop
  backdrop = {
    borderColor = { 0, 0, 0, 1 };
    bgColor = { 0, 0, 0, 1 };
    bgFile = tk.Constants.BACKDROP_WITH_BACKGROUND.bgFile,
    edgeFile = tk.Constants.BACKDROP_WITH_BACKGROUND.edgeFile,
    edgeSize = tk.Constants.BACKDROP_WITH_BACKGROUND.edgeSize,
    insets = { left = 0, right = 0, top = 0, bottom = 0 };
  };
  anchors = {
    units = {
      type = "mouse"; -- or "screen"
      point = "BOTTOMRIGHT";
    },
    other = {
      type = "screen"; -- or "mouse"
      point = "BOTTOMRIGHT";
    }
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
    format = "%"; -- or "n", "n/n"
    height = 18;
  };
  powerBar = {
    enabled = true;
    fontSize = 14;
    texture = "MUI_StatusBar";
    format = "%"; -- or "n", "n/n"
    height = 18;
  };
  auras = {
    buffs = {
      enabled = true;
      size = 28;
      position = "TOP";
      direction = "ltr";
    };
    debuffs = {
      enabled = true;
      size = 28;
      position = "TOP";
      direction = "ltr";
      aboveBuffs = true;
      colorByDebuffType = true;
    };
  };
});

local function SetBackdropStyle(data)
  local scale = data.settings.scale;

  for _, tooltip in ipairs(tooltipsToReskin) do
    tooltip = _G[tooltip];

    if (obj:IsTable(tooltip) and obj:IsFunction(tooltip.GetObjectType)) then

      if (tooltip == _G.FriendsTooltip) then
        scale = scale + 0.2;
      end

      tooltip:SetScale(scale);

      if (data.settings.muiTexture.enabled) then
        tooltip:SetBackdrop(nil);

        if (not obj:IsFunction(tooltip.SetGridTextureShown)) then
          local texture = tk.Constants.AddOnStyle:GetTexture("DialogBoxBackground");
          texture = strformat("%s%s", texture, "Medium");

          gui:CreateGridTexture(tooltip, texture, 10, 6, 512, 512);
        end

        if (data.settings.muiTexture.color == "theme") then
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
        local backdrop = data.backdrop;
        local borderColor = backdrop.borderColor;
        local bgColor = backdrop.bgColor;

        tooltip:SetBackdrop({
          bgFile = backdrop.bgFile,
          edgeFile = backdrop.edgeFile,
          edgeSize = backdrop.edgeSize,
          insets = backdrop.insets;
        });

        tooltip:SetBackdropBorderColor(borderColor);
        tooltip:SetBackdropColor(bgColor);

        if (obj:IsFunction(tooltip.SetGridTextureShown)) then
          tooltip:SetGridTextureShown(false);
        end
      end
    end
  end

  -- remove backdrop:
  tooltipStyle.bgFile = nil;
  tooltipStyle.insets = nil;
  tooltipStyle.edgeFile = nil;
  tooltipStyle.edgeSize = nil;
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

local HandleHealthBarValueChanged, HandlePowerBarValueChanged;

do
  local function SetFormattedColoredText(fontString, format, percentage, current, max, r, g, b)
    if (tk.Strings:IsNilOrWhiteSpace(format) or percentage > 100) then
      fontString:SetText("");
      return
    end

    local text = tk.Strings.Empty;

    -- format can be: "%", "n", "n/n"
    if (format == "%") then
      text = strformat("%d%%", percentage);
    else
      if (current > 1000) then
        current = strformat("%dk", tk.Numbers:ToPrecision(current / 1000, 1));
      end

      if (format == "n") then
        -- current health
        text = current;
      elseif (format == "n/n") then
        -- current and max health
        if (max > 1000) then
          max = strformat("%dk", tk.Numbers:ToPrecision(max / 1000, 1));
        end

        text = strformat("%dk/%dk", current, max);
      end
    end

    fontString:SetText(tk.Strings:SetTextColorByRGB(text, r, g, b));
  end

  function HandleHealthBarValueChanged(format, healthColors)
    local maxHealth = UnitHealthMax(MOUSEOVER);
    local currentHealth = UnitHealth(MOUSEOVER);
    local r, g, b = GetHealthColor(healthColors, currentHealth, maxHealth);
    local percentage = maxHealth > 0 and ((currentHealth / maxHealth) * 100) or 0;

    SetFormattedColoredText(healthBar.HealthText, format, percentage, currentHealth, maxHealth, r, g, b);
  end

  function HandlePowerBarValueChanged(format, powerColors)
      -- verify unit is still using the same power type, if not, update the bar color
    local powerTypeID = UnitPowerType(MOUSEOVER);
    if (powerTypeID < 0) then return end

    local currentPower = UnitPower(MOUSEOVER, powerTypeID);
    local maxPower = UnitPowerMax(MOUSEOVER, powerTypeID);

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

  if (flag == "None") then
    flag = nil;
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
end

local function UpdateUnitTooltipLines(guildRankShown)
  local totalLines = gameTooltip:NumLines();

	for i = 1, totalLines do
		local line = _G["GameTooltipTextLeft"..i];

    if (i == 1) then
      -- HEADER
      local unitNameText = tk.Strings:GetUnitFullNameText(MOUSEOVER);
      _G.GameTooltipTextLeft1:SetText(unitNameText);
    elseif (UnitIsPlayer(MOUSEOVER)) then
      -- guild Name
      local guild, guildRank = GetGuildInfo(MOUSEOVER);
      if (i == 2 and guild) then
        local yourGuild = GetGuildInfo("PLAYER");
        local guildTextColor = guild == yourGuild and "TRANSMOG_VIOLET" or "YELLOW";
        local guildText = tk.Strings:SetTextColorByKey(strformat("<%s>", guild), guildTextColor);

        if (guildRankShown) then
          local guildRankText = tk.Strings:SetTextColorByKey(guildRank, "GRAY");
          line:SetFormattedText("%s %s", guildText, guildRankText);
        else
          line:SetText(guildText);
        end

      elseif ((not guild and i == 2) or (guild and i == 3)) then
        local race = UnitRace(MOUSEOVER);
        local fileName = tk:GetClassFilenameByUnitID(MOUSEOVER);
        local localizedName = tk:GetLocalizedClassNameByFilename(fileName, true);

        line:SetFormattedText("%s %s (%s)", race, localizedName, _G.PLAYER);
      end
    else
      local text = line:GetText();

      if (tk.Strings:Contains(text, _G.LEVEL)) then
        local family = UnitCreatureFamily(MOUSEOVER);

        if (family) then
          line:SetFormattedText("%s %s", UnitCreatureType(MOUSEOVER), tk.Strings:SetTextColorByKey(family, "GRAY"));
        else
          line:SetText(UnitCreatureType(MOUSEOVER));
        end
      end
    end
	end
end

local UpdateStatusBarOnMouseOver;

do
  local originalSetStatusBarColor = healthBar.SetStatusBarColor;

  function UpdateStatusBarOnMouseOver(data)
    local color = tk:GetClassColorByUnitID(MOUSEOVER);

    if (UnitIsPlayer(MOUSEOVER) and color) then
      originalSetStatusBarColor(healthBar, color.r, color.g, color.b);
    else
      local reaction = UnitReaction("player", MOUSEOVER);
      local r, g, b;

      if (reaction) then
        r = tk.Constants.FACTION_BAR_COLORS[reaction].r;
        g = tk.Constants.FACTION_BAR_COLORS[reaction].g;
        b = tk.Constants.FACTION_BAR_COLORS[reaction].b;
      else
        local maxHealth = UnitHealthMax(MOUSEOVER);
        local currentHealth = UnitHealth(MOUSEOVER);
        r, g, b = GetHealthColor(data.settings.healthColors, currentHealth, maxHealth);
      end

      originalSetStatusBarColor(healthBar, r, g, b);
    end

    HandleHealthBarValueChanged(data.settings.healthBar.format, data.settings.healthColors);

    local powerTypeID = UnitPowerType(MOUSEOVER);
    if (not powerBar) then return end

    local show = data.settings.powerBar.enabled and powerTypeID >= 0;
    powerBar:SetShown(show);

    if (not show) then return end
    HandlePowerBarValueChanged(data.settings.powerBar.format, data.settings.powerColors);

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

local function AddAuras(data, filter, anchor)
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
    local auraName, iconTexture, _, auraType, duration, endTime, source = UnitAura(MOUSEOVER, index, filter);

    if (auraName and iconTexture and source == "player") then
      local frame = auraFrames[id];

      if (not frame) then
        auraFrames[id] = CreateFrame("Frame", nil, gameTooltip, _G.BackdropTemplateMixin and "BackdropTemplate");
        frame = auraFrames[id];

        frame:SetBackdrop(data.backdrop);

        frame.iconTexture = frame:CreateTexture(nil, "ARTWORK");
        frame.iconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9);
        frame.iconTexture:SetPoint("TOPLEFT", 1, -1);
        frame.iconTexture:SetPoint("BOTTOMRIGHT", -1, 1);

        frame.cooldown = CreateFrame("Cooldown", nil, frame, _G.BackdropTemplateMixin and "CooldownFrameTemplate");
        frame.cooldown:SetReverse(1);
        frame.cooldown:SetPoint("TOPLEFT", 1, -1);
        frame.cooldown:SetPoint("BOTTOMRIGHT", -1, 1);
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

local function UpdateAuras(data)
  if (not data.backdrop) then
    data.backdrop = obj:PopTable();
    data.backdrop.edgeFile = tk.Constants.LSM:Fetch("border", "Skinner");
    data.backdrop.edgeSize = 1;
  end

  HideAllAuras(data);

  local relativeFrame = gameTooltip;
  local buffsEnabled = data.settings.auras.buffs.enabled;
  local debuffsEnabled = data.settings.auras.debuffs.enabled;
  local samePositions = (data.settings.auras.buffs.position == data.settings.auras.debuffs.position);

  data.buffs = buffsEnabled and (data.buffs or obj:PopTable());
  data.debuffs = debuffsEnabled and (data.debuffs or obj:PopTable());

  if (debuffsEnabled and data.settings.auras.debuffs.aboveBuffs) then
    local nextRelativeFrame = AddAuras(data, HARMFUL, relativeFrame);

    if (samePositions) then
      relativeFrame = nextRelativeFrame;
    end

    if (buffsEnabled) then
       AddAuras(data, HELPFUL, relativeFrame);
    end
  else
    if (buffsEnabled) then
      local nextRelativeFrame = AddAuras(data, HELPFUL, relativeFrame);

      if (samePositions) then
        relativeFrame = nextRelativeFrame;
      end
    end

    if (debuffsEnabled) then
      AddAuras(data, HARMFUL, relativeFrame);
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

local function UpdateTargetText(data)
  local mouseoverTarget = UnitName("MouseoverTarget");

  if (mouseoverTarget) then
    if (UnitName("player") == mouseoverTarget) then
      mouseoverTarget = tk.Strings:SetTextColorByKey("YOU", "YELLOW");
    else
      mouseoverTarget = tk.Strings:GetUnitNameText("MouseoverTarget");
    end
  end

  local totalLines = gameTooltip:NumLines();

	for i = totalLines, 1, -1  do
		local line = _G["GameTooltipTextLeft"..i];
    local text = line:GetText();

    if (text == "Target:") then
      if (mouseoverTarget) then
        -- line:SetText(strformat("Target: %s", mouseoverTarget));
        return
      else
        line:SetText("");
        break
      end
    end
  end

  if (mouseoverTarget) then
    gameTooltip:AddDoubleLine("Target:", mouseoverTarget);
  end

  RefreshPadding(data);
end

local function CreatePowerBar(data)
  powerBar = CreateFrame("StatusBar", "GameTooltipPowerBar", healthBar,
    _G.BackdropTemplateMixin and "BackdropTemplate");
  powerBar:SetHeight(data.settings.powerBar.height);

  local statusBarTexture = tk.Constants.LSM:Fetch("statusbar", data.settings.powerBar.texture);
  powerBar:SetStatusBarTexture(statusBarTexture);
  powerBar:SetFrameLevel(10);

  -- Create backdrop for status bar:
  powerBar.bg = CreateFrame("Frame", nil, powerBar, _G.BackdropTemplateMixin and "BackdropTemplate");
  powerBar.bg:SetAllPoints();
	powerBar.bg:SetFrameLevel(healthBar:GetFrameLevel() - 1);
	powerBar.bg:SetBackdrop({ bgFile = tk.Constants.BACKDROP_WITH_BACKGROUND.bgFile });

  local powerText = powerBar:CreateFontString(nil, "OVERLAY");
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
  healthBar.bg = CreateFrame("Frame", nil, healthBar, _G.BackdropTemplateMixin and "BackdropTemplate");
  healthBar.bg:SetAllPoints();
	healthBar.bg:SetFrameLevel(healthBar:GetFrameLevel() - 1);
	healthBar.bg:SetBackdrop({ bgFile = tk.Constants.BACKDROP_WITH_BACKGROUND.bgFile });
	healthBar.bg:SetBackdropColor(r * 0.4, g * 0.4, b * 0.4);

  local healthText = healthBar:CreateFontString(nil, "OVERLAY");
  healthText:SetPoint("CENTER");
  healthBar.HealthText = healthText;

  gameTooltip:HookScript("OnUpdate", function(_, elapsed)
    data.lastUpdated = (data.lastUpdated or 0)  + elapsed;

    if (data.lastUpdated > 0.2) then
      data.lastUpdated = 0;

      if (UnitExists(MOUSEOVER)) then
        -- apply tooltip real time updates
        HandleHealthBarValueChanged(data.settings.healthBar.format, data.settings.healthColors);

        if (data.settings.powerBar.enabled) then
          HandlePowerBarValueChanged(data.settings.powerBar.format, data.settings.powerColors);
        end

        UpdateAuras(data);

        if (data.settings.targetShown) then
          UpdateTargetText(data);
        end
      end
    end
  end);
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

local function SetDoubleLine(leftText, rightText)
  for i = 1, _G.GameTooltip:NumLines() do
    local left = _G[strformat("GameTooltipTextLeft%d", i)];
    local right = _G[strformat("GameTooltipTextRight%d", i)];

    if (left and right and tk.Strings:Contains(left:GetText(), leftText)) then
      right:SetText(rightText);
      return
    end
  end
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
    standardFontSize = SetFontsWrapper;--14;
    headerFontSize = SetFontsWrapper;--14;
    scale = SetBackdropStyleWrapper;--0.8
    muiTexture = SetBackdropStyleWrapper; -- if true, does not use backdrop
    backdrop = SetBackdropStyleWrapper;
    healthBar = {
      fontSize = function(value)
        if (healthBar.HealthText) then
          local font = tk.Constants.LSM:Fetch(tk.Constants.LSM.MediaType.FONT, data.settings.font);
          healthBar.HealthText:SetFont(font, value, "OUTLINE");
        end
      end;--14;
      texture = function(value)
        local statusBarTexture = tk.Constants.LSM:Fetch("statusbar", value);
        healthBar:SetStatusBarTexture(statusBarTexture);
      end;--"MUI_StatusBar";
      height = function(value)
        healthBar:SetHeight(value);
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
          powerBar.PowerText:SetFont(font, value, "OUTLINE");
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
      end;
    };
  });
end

function C_ToolTipsModule:OnInitialized(data)
  if (data.settings.enabled and not IsAddOnLoaded("TipTac")) then
    self:SetEnabled(true);
  end
end

function C_ToolTipsModule:OnEnable(data)
  -- Create new anchor:
  data.anchor = CreateFrame("Frame", nil, _G.UIParent);
  data.anchor:SetPoint("BOTTOMRIGHT", -4, 4); -- TODO: Make configurable - make movable
  data.anchor:SetSize(100, 30);

	-- Fixes inconsistency with Blizzard code to support backdrop alphas:
	tooltipStyle.backdropColor.GetRGB = _G.ColorMixin.GetRGBA;
	tooltipStyle.backdropBorderColor.GetRGB = _G.ColorMixin.GetRGBA

  SetBackdropStyle(data);
  ApplyHealthBarChanges(data);
  SetFonts(data);

  -- set positioning of tooltip:
  hooksecurefunc("GameTooltip_SetDefaultAnchor", function (tooltip, parent)
    local anchors;
    if (UnitExists(MOUSEOVER)) then
      anchors = data.settings.anchors.units;
    else
      anchors = data.settings.anchors.other;
    end

    local anchorType = anchors.type:lower();
    local point = anchors.point:upper();

    if (anchorType == "mouse") then
      -- TODO: TEST THIS!
      tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT");
    else
      tooltip:SetOwner(parent, "ANCHOR_NONE");
      tooltip:ClearAllPoints();
      tooltip:SetPoint(point, data.anchor, point); -- the new anchor point
    end
  end);

  gameTooltip:HookScript("OnShow", function()
    HideAllAuras(data);
  end);

  local specListener = em:CreateEventListener(function(handler, _, guid)
    if (UnitGUID(MOUSEOVER) ~= guid) then return end

    local specID = GetInspectSpecialization(MOUSEOVER);
    local specializationName = select(2, GetSpecializationInfoByID(specID));
    local itemLevel = C_PaperDollInfo.GetInspectItemLevel(MOUSEOVER);

    if (not tk.Strings:IsNilOrWhiteSpace(specializationName)) then
      handler:SetEnabled(false);

      if (obj:IsTable(data.specCache) and data.settings.specShown) then
        data.specCache[guid] = specializationName;
        SetDoubleLine(SPEC_LABEL, specializationName);
      end

      if (obj:IsTable(data.itemLevelCache) and data.settings.itemLevelShown) then
        data.itemLevelCache[guid] = itemLevel;
        SetDoubleLine(ITEM_LEVEL_LABEL, itemLevel);
      end

      RefreshPadding(data);
    end
  end);

  specListener:RegisterEvent("INSPECT_READY");
  specListener:SetEnabled(false);

  local listener = em:CreateEventListener(function()
    local unitExists = UnitExists(MOUSEOVER);

    if (not unitExists) then
      gameTooltip:Hide();
    else
      UpdateUnitTooltipLines(data.settings.guildRankShown); -- must be BEFORE padding
      UpdateStatusBarOnMouseOver(data);
      UpdateAuras(data);

      if (data.settings.targetShown) then
        UpdateTargetText(data);
      end

      if (tk:IsRetail() and UnitIsPlayer(MOUSEOVER) and UnitLevel(MOUSEOVER) >= 10 
          and CanInspect(MOUSEOVER) and CheckInteractDistance(MOUSEOVER, 1)) then

        local guid = UnitGUID(MOUSEOVER) or "";

        if (data.settings.specShown) then
          data.specCache = data.specCache or obj:PopTable();
          local specializationName = data.specCache[guid];

          if (specializationName) then
            gameTooltip:AddDoubleLine(SPEC_LABEL, specializationName);
          else
            gameTooltip:AddDoubleLine(SPEC_LABEL, LOADING);
          end
        end

        if (data.settings.itemLevelShown) then
          data.itemLevelCache = data.itemLevelCache or obj:PopTable();
          local itemLevel = data.itemLevelCache[guid];

          if (itemLevel) then
            gameTooltip:AddDoubleLine(ITEM_LEVEL_LABEL, itemLevel);
          else
            gameTooltip:AddDoubleLine(ITEM_LEVEL_LABEL, LOADING);
          end
        end

        if (data.settings.specShown or data.settings.itemLevelShown) then
          specListener:SetEnabled(true);
          _G.NotifyInspect(MOUSEOVER);
        end
      end
    end

    RefreshPadding(data);
  end);

  listener:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
end