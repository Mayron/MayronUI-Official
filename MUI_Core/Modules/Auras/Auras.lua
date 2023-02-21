-- luacheck: ignore self 143
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents();

local unpack, SecondsToTimeAbbrev = _G.unpack, _G.SecondsToTimeAbbrev;
local GetTime, UnitGUID = _G.GetTime, _G.UnitGUID;
local GetInventoryItemQuality = _G.GetInventoryItemQuality;
local GetItemQualityColor = _G.GetItemQualityColor;
local GetInventoryItemTexture = _G.GetInventoryItemTexture;
local UnitAura, CreateFrame, GetWeaponEnchantInfo = _G.UnitAura, _G.CreateFrame, _G.GetWeaponEnchantInfo;
local select, math, string = _G.select, _G.math, _G.string;
local GetInventoryItemLink, GetItemInfo = _G.GetInventoryItemLink, _G.GetItemInfo;
local GameTooltip, C_Timer = _G.GameTooltip, _G.C_Timer;

local BUFF_FLASH_TIME_ON = 0.75;
local BUFF_MIN_ALPHA = 0.3;
local BUFF_WARNING_TIME = 31;

---@class Stack : Object
local C_Stack = obj:Import("Pkg-Collections.Stack<T>");

local colorSettings = {
  timeRemaining = {1, 1, 1};
  count         = {1, 0.82, 0};
  auraName      = {1, 1, 1};
  helpful        = {0.2, 0.2, 0.2};
  harmful        = {0.76, 0.2, 0.2};
  magic         = {0.2, 0.6, 1};
  disease       = {0.6, 0.4, 0};
  poison        = {0.0, 0.6, 0};
  curse         = {0.6, 0.0, 1};
  background   = { 0, 0, 0, 0.5 };
  foreground   = { 0.15, 0.15, 0.15 };
  owned        = { 0.15, 0.15, 0.15 };
};

local buffSettings = {
  mode = "icons";

  icons = {
    pulse = false;
    nonPlayerAlpha = 0.7;
    vDirection = "DOWN";
    hDirection = "LEFT";
    iconWidth = 40;
    iconHeight = 30;
    iconBorderSize = 1.125;
    masque = true;
    xSpacing = 6;
    ySpacing = 20;
    perRow = 10;
    secondsWarning = 10;
    position = { "TOPRIGHT", "Minimap", "TOPLEFT", -4, -0.5 };
    textSize = {
      timeRemaining = 10;
      timeRemainingLarge = 14;
      count = 14;
    };
    textPosition = {
      timeRemaining = { "TOP", "iconFrame", "BOTTOM", 0, -4 };
      count         = { "BOTTOMRIGHT", "icon", "BOTTOMRIGHT", 0, 2 };
    };
  };

  statusbars = {
    pulse = false;
    nonPlayerAlpha = 0.7;
    vDirection = "DOWN";
    hDirection = "LEFT";
    iconWidth = 40;
    iconHeight = 30;
    iconBorderSize = 1;
    barWidth = 200;
    barHeight = 22;
    xSpacing = 4;
    ySpacing = 1;
    perRow = 1;
    secondsWarning = 10;
    texture = "MUI_StatusBar";
    iconGap = 1;
    showSpark = true;

    position = { "TOPRIGHT", "Minimap", "TOPLEFT", -4, -200 };
    textSize = {
      timeRemaining = 10;
      timeRemainingLarge = 14;
      count = 14;
      auraName = 10;
    };

    textPosition = {
      timeRemaining = { "RIGHT", "bar", -4, 0 };
      count         = { "RIGHT", "icon", "LEFT", -4, 0 };
      auraName      = { "LEFT", "bar", "LEFT", 4, 0 };
    };
  }
};

local debuffSettings = {
  mode = "icons";

  icons = {
    pulse = false;
    nonPlayerAlpha = 0.7;
    vDirection = "DOWN";
    hDirection = "LEFT";
    iconWidth = 40;
    iconHeight = 30;
    iconBorderSize = 1;
    masque = true;
    xSpacing = 6;
    ySpacing = 20;
    perRow = 10;
    secondsWarning = 10;
    position = { "TOPRIGHT", "MUI_BuffFrames", "BOTTOMRIGHT", 0, -40 };
    textSize = {
      timeRemaining = 10;
      timeRemainingLarge = 14;
      count = 14;
    };
    textPosition = {
      timeRemaining = { "TOP", "iconFrame", "BOTTOM", 0, -4 };
      count         = { "BOTTOMRIGHT", "icon", "BOTTOMRIGHT", 0, 2 };
    };
  };

  statusbars = {
    pulse = false;
    nonPlayerAlpha = 0.7;
    vDirection = "DOWN";
    hDirection = "LEFT";
    iconWidth = 40;
    iconHeight = 30;
    iconBorderSize = 1;
    barWidth = 200;
    barHeight = 22;
    xSpacing = 4;
    ySpacing = 1;
    perRow = 1;
    secondsWarning = 10;
    position = { "TOPRIGHT", "MUI_BuffFrames", "BOTTOMRIGHT", 0, -40 };
    texture = "MUI_StatusBar";
    iconGap = 1;
    showSpark = true;

    textSize = {
      timeRemaining = 10;
      timeRemainingLarge = 14;
      count = 14;
      auraName = 10;
    };

    textPosition = {
      timeRemaining = { "RIGHT", "bar", -4, 0 };
      count         = { "BOTTOMRIGHT", "icon", "BOTTOMRIGHT", 0, 2 };
      auraName      = { "LEFT", "bar", "LEFT", 4, 0 };
    };
  }
};

-- Local Functions -------------
local GetEnchantName;

do
  local scanners = C_Stack:UsingTypes("GameTooltip")(); ---@type Stack

  scanners:OnNewItem(function()
    local scanner = tk:CreateFrame("GameTooltip", nil, "MUIAurasScanner", "GameTooltipTemplate");
    scanner:SetOwner(_G.MUI_BuffFrames, "ANCHOR_NONE");
    return scanner;
  end);

  local function GetEnchantNameBySlotID(slotID)
    local scanner = scanners:Pop();
    scanner:SetInventoryItem("player", slotID);

    local totalLines = scanner:NumLines();

    for i = 1, totalLines  do
      local line1 = _G["MUIAurasScannerTextLeft"..i];
      local text = line1:GetText();

      if (text) then
        local auraName = select(3, string.find(text, "^(.+) %("));

        if (auraName) then
          return auraName;
        end
      end
    end

    scanners:Push(scanner);
    return nil;
  end

  GetEnchantName = function(slotID)
    local itemlink = GetInventoryItemLink("player", slotID);
    local enchantName = GetEnchantNameBySlotID(slotID);

    if (enchantName) then
      return enchantName;
    end

    if (itemlink) then
      local itemName = GetItemInfo(itemlink);

      if (itemName) then
        return itemName;
      end
    end

    -- If item cannot be found (should never happen) then use fallback name:
    return "Weapon "..slotID;
  end
end

-- Objects -----------------------------
---@class AurasModule : BaseModule
local C_AurasModule = MayronUI:RegisterModule("AurasModule", L["Auras (Buffs & Debuffs)"]);

local AuraButtonMixin = {};

local progressColors = {
  low = { r = 1, g = 77/255, b = 77/255 },
  medium = { r = 1, g = 1, b = 128/255 },
  high = { r = 1, g = 1, b = 1 }
};

local function GetProgressColor(current, max)
  local percent = max > 0 and (current / max) or 0;

  if (percent >= 1) then
    return progressColors.high.r, progressColors.high.g, progressColors.high.b;
  end

	if (percent <= 0.125) then
    return progressColors.low.r, progressColors.low.g, progressColors.low.b;
  end

  -- start and end R,B,G values:
  local start, stop;

	if (percent > 0.5) then
    -- greater than half way
		start = progressColors.high;
		stop = progressColors.medium;
	else
    -- less than half way
		start = progressColors.medium;
		stop = progressColors.low;
	end

  return tk:MixColorsByPercentage(start, stop, percent);
end

function AuraButtonMixin:ApplyTextStyle(name)
  local fontString = self[name.."Text"];
  fontString:SetTextColor(unpack(self.settings.colors[name]));

  local point, relativeFrame, relativePoint, xOffset, yOffset = unpack(self.settings.textPosition[name]);

  if (relativeFrame == "icon") then
    relativeFrame = self.maskTexture;
  elseif (relativeFrame == "iconFrame") then
    relativeFrame = self.icnFrame;
  elseif (relativeFrame == "bar") then
    relativeFrame = self.statusbarFrame;
  end

  if (not obj:IsTable(relativeFrame)) then
    relativeFrame = self;
  end

  fontString:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset);
  tk:SetFontSize(fontString, self.settings.textSize[name]);
end

local ITERATIONS = 50;

function AuraButtonMixin:SetSliderValue(new)
  self.endValue = new;
  if (self.timer and not self.timer:IsCancelled()) then return end

  local startValue = self.statusbar:GetValue();
  local diff = startValue - new;

  if (diff >= 0) then
    self.statusbar:SetValue(new);
    return
  end

  diff = math.ceil(math.abs(diff));

  if (diff < 2) then
    self.statusbar:SetValue(new);
    return
  end

  local _, max = self.statusbar:GetMinMaxValues();
  local percentDiff = (diff / max) * 100;

  if (percentDiff < 5) then
    self.statusbar:SetValue(new);
    return
  end

  local extra = 0;

  if (diff > ITERATIONS) then
    local remaining = diff - ITERATIONS;
    extra = remaining / ITERATIONS;
  elseif (diff < ITERATIONS) then
    local remaining = diff - ITERATIONS;
    extra = remaining / ITERATIONS;
  end

  diff = diff * 100; -- in milliseconds

  local i = 0;
  self.timer = C_Timer.NewTicker(0.01, function()
    i = i + 1;

    if (i >= ITERATIONS) then
      self.statusbar:SetValue(self.endValue);
      self.timer:Cancel();
    end

    local percent = i/ITERATIONS;
    percent = math.min(1, -(math.cos(math.pi * percent) - 1) / 2);

    local shouldCancel, stepValue;
    local changeAmount = (percent * diff) + extra;
    local changeInSeconds = changeAmount / 100;

    stepValue = math.max(startValue + changeInSeconds, 0);

    if (stepValue >= self.endValue) then
      shouldCancel = true;
      stepValue = self.endValue;
    end

    -- if (fill) then

    -- else
    --   stepValue = math.max(startValue - changeInSeconds, 0);

    --   if (stepValue <= self.endValue) then
    --     shouldCancel = true;
    --     stepValue = self.endValue;
    --   end
    -- end

    self.statusbar:SetValue(stepValue);
    if (shouldCancel) then
      self.timer:Cancel();
    end
  end, ITERATIONS);
end


local function HandleAuraButtonOnUpdate(self, elapsed)
  self.timeRemainingLastUpdate = (self.timeRemainingLastUpdate or 0) + elapsed;
  self.countLastUpdate = (self.countLastUpdate or 0) + elapsed;
  self.sliderLastUpdate = (self.sliderLastUpdate or 0) + elapsed;

  self.timeRemaining = self.expiryTime - GetTime();
  local hasTimeRemaining = obj:IsNumber(self.timeRemaining) and self.timeRemaining > 0;

  if (self.settings.pulse) then
    self.pulseLastUpdate = (self.pulseLastUpdate or 0) - elapsed;

    if (hasTimeRemaining and self.timeRemaining < BUFF_WARNING_TIME) then
      local alphaValue;

      if (self.pulseLastUpdate < 0) then
        local overtime = -self.pulseLastUpdate;

        if (self.isPulsing == 0) then
          self.isPulsing = 1;
          self.pulseLastUpdate = 0.75;
        else
          self.isPulsing = 0;
          self.pulseLastUpdate = 0.75;
        end

        if (overtime < self.pulseLastUpdate) then
          self.pulseLastUpdate = self.pulseLastUpdate - overtime;
        end
      end

      if (self.isPulsing == 1) then
        alphaValue = (BUFF_FLASH_TIME_ON - self.pulseLastUpdate) / BUFF_FLASH_TIME_ON;
      else
        alphaValue = self.pulseLastUpdate / BUFF_FLASH_TIME_ON;
      end

      alphaValue = (alphaValue * (1 - BUFF_MIN_ALPHA)) + BUFF_MIN_ALPHA;
      self:SetAlpha(alphaValue);
    else
      self.pulseLastUpdate = 0;
      self:SetAlpha(1);
    end
  end

  if (self.countLastUpdate > 0.1) then
    local _, _, count = UnitAura("player", self:GetID(), self.filter);

    if (not count or count < 1) then
      self.countText:SetText(tk.Strings.Empty);
      self.countLastUpdate = -10;
    else
      self.countText:SetText(count);
      self.countLastUpdate = 0;
    end
  end

  if (self.timeRemainingLastUpdate > 0.1 and self.expiryTime == 0) then
    self.timeRemainingText:SetText(tk.Strings.Empty);

    if (self.statusbar) then
      self.statusbar:SetMinMaxValues(0, 1);
      self.statusbar:SetValue(1);
    end

    if (self.spark) then
      self.spark:Hide();
    end

    self.timeRemainingLastUpdate = -3600;
    self.sliderLastUpdate = -3600;
    return
  end

  if (self.statusbar and self.sliderLastUpdate > 0.1) then
    if (hasTimeRemaining) then
      self.statusbar:SetMinMaxValues(0, self.duration);
      self:SetSliderValue(self.timeRemaining);

      if (self.spark) then
        local offset = self.spark:GetWidth() / 2;
        local barWidth = self.statusbar:GetWidth();
        local sparkOffset = (self.timeRemaining / self.duration) * barWidth - offset;

        if (sparkOffset > barWidth - offset) then
          sparkOffset = barWidth - offset;
        end

        self.spark:SetPoint("LEFT", sparkOffset, 0);
        self.spark:Show();
      end
    else
      self.statusbar:SetValue(0);

      if (self.spark) then
        self.spark:Hide();
      end
    end

    self.sliderLastUpdate = 0;
  end

  if (self.timeRemainingLastUpdate > 0.5) then
    if (hasTimeRemaining) then
      local format, value = SecondsToTimeAbbrev(self.timeRemaining);

      if (format == _G.SECOND_ONELETTER_ABBR) then
        value = math.ceil(value);
        self.timeRemainingText:SetFormattedText("%d", value);
      else
        local text = string.format(format, value);
        text = tk.Strings:RemoveWhiteSpace(text);
        self.timeRemainingText:SetText(text);
      end

      local current = math.min(30, self.timeRemaining);
      local r, g, b = GetProgressColor(current, 30);
      self.timeRemainingText:SetTextColor(r, g, b);

      if (value <= self.settings.secondsWarning and self.timeRemaining < 20) then
        tk:SetFontSize(self.timeRemainingText, self.settings.textSize["timeRemainingLarge"]);
      else
        tk:SetFontSize(self.timeRemainingText, self.settings.textSize["timeRemaining"]);
      end
    else
      self.timeRemainingText:SetText(tk.Strings.Empty);
    end

    if (self.timeRemaining > 80) then
      self.timeRemainingLastUpdate = -10;
    else
      self.timeRemainingLastUpdate = 0;
    end
  end
end

local function HandleAuraButtonOnEnter(self)
  GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
  GameTooltip:SetFrameLevel(self.cooldown:GetFrameLevel() + 2);
  if (self.auraType == "item") then
    GameTooltip:SetInventoryItem("player", self:GetID());
  else
    GameTooltip:SetUnitAura("player", self:GetID(), self.filter);
  end
end

function AuraButtonMixin:SetSparkShown(shown)
  if (not self.spark and not shown) then return end

  if (not self.spark) then
    self.spark = self.statusbar:CreateTexture(nil, "OVERLAY");
    self.spark:SetSize(26, 50);
    self.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark");

    local r, g, b = tk:GetThemeColor();
    self.spark:SetVertexColor(r, g, b);
    self.spark:SetBlendMode("ADD");
  end

  self.spark:SetShown(shown);
end

local function GetAuraButtonSize(settings)
  local width = settings.iconWidth;
  local height = settings.iconHeight;

  if (settings.mode == "statusbars") then
    width = settings.iconGap + settings.barWidth;
    height = math.max(height, settings.barHeight);
  end

  return width, height;
end


local masqueGroup;

function AuraButtonMixin:ApplyStyling()
  if (self.iconFrame) then return end
  if (not self.texture) then return end

  local width, height = GetAuraButtonSize(self.settings);
  self:SetSize(width, height);

  -- Set Up Icon:
  self.iconFrame = tk:CreateFrame("Frame", self, nil, _G.BackdropTemplateMixin and "BackdropTemplate");
  self.iconFrame:SetSize(self.settings.iconWidth, self.settings.iconHeight);
  self.iconFrame:SetPoint("TOPLEFT");
  self.iconBorder = tk:SetBackground(self.iconFrame, 0, 0, 0);
  self.iconBorder:SetDrawLayer("BORDER");

  local b = self.settings.iconBorderSize;
  local maskTexturePath = tk:GetAssetFilePath("Textures\\black");
  self.maskTexture = self.iconFrame:CreateMaskTexture();
  self.maskTexture:SetTexture(maskTexturePath, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE");
  self.maskTexture:SetPoint("TOPLEFT", b, -b);
  self.maskTexture:SetPoint("BOTTOMRIGHT", -b, b);

  self.iconTexture = self.iconFrame:CreateTexture(nil, "BACKGROUND");
  self.iconTexture:SetTexture(self.texture);
  self.iconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9);
  self.iconTexture:SetPoint("CENTER");

  local diff = math.abs(self.settings.iconWidth - self.settings.iconHeight);
  local iconWidth, iconHeight = self.settings.iconWidth, self.settings.iconHeight;

  if (diff > 5) then
    diff = diff * 0.1;

    if (self.settings.iconWidth > self.settings.iconHeight) then
      iconHeight = iconHeight - diff;
    else
      iconWidth = iconWidth - diff;
    end
  end

  self.iconTexture:SetSize(iconWidth, iconHeight);
  self.iconTexture:AddMaskTexture(self.maskTexture);

  local fakeIconTexture = self.iconFrame:CreateTexture(nil, "ARTWORK");
  fakeIconTexture:SetTexture("");
  fakeIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9);
  fakeIconTexture:SetPoint("TOPLEFT", b, -b);
  fakeIconTexture:SetPoint("BOTTOMRIGHT", -b, b);

  -- Cooldown
  self.cooldown = tk:CreateFrame("Cooldown", self.iconFrame, nil, "CooldownFrameTemplate");
  self.cooldown:SetReverse(1);
  self.cooldown:SetHideCountdownNumbers(true);
  self.cooldown.noCooldownCount = true; -- disable OmniCC
  self.cooldown:SetPoint("TOPLEFT", b, -b);
  self.cooldown:SetPoint("BOTTOMRIGHT", -b, b);
  self.cooldown:SetFrameStrata("TOOLTIP");

  -- Status Bar:
  if (self.settings.mode == "statusbars") then
    self.statusbarFrame = tk:CreateFrame("Frame", self, nil, _G.BackdropTemplateMixin and "BackdropTemplate");
    self.statusbarFrame:SetPoint("LEFT", self.iconFrame, "RIGHT", self.settings.iconGap, 0);
    self.statusbarFrame:SetPoint("RIGHT");
    tk:SetBackground(self.statusbarFrame, unpack(self.settings.colors.background));

    self.statusbar = tk:CreateFrame("StatusBar", self.statusbarFrame);
    self.statusbar:SetStatusBarTexture(tk.Constants.LSM:Fetch("statusbar", self.settings.texture));
    self.statusbar:SetPoint("TOPLEFT", 1, -1);
    self.statusbar:SetPoint("BOTTOMRIGHT", -1, 1);

    self:SetSparkShown(self.settings.showSpark);
  end

  -- FontStrings
  local countTemplate = (self.settings.mode == "statusbars" and "GameFontNormal") or "NumberFont_Outline_Large";
  self.countText = self.cooldown:CreateFontString(nil, "OVERLAY", countTemplate);
  self:ApplyTextStyle("count");

  if (self.settings.mode == "statusbars") then
    self.auraNameText = self.statusbar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
    self:ApplyTextStyle("auraName");

    self.auraNameText:SetJustifyH("LEFT");
    self.auraNameText:SetWordWrap(false);
  end

  self.timeRemainingText = self.cooldown:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
  self:ApplyTextStyle("timeRemaining");

  -- Scripts:
  self:HookScript("OnUpdate", HandleAuraButtonOnUpdate);
  self:HookScript("OnEnter", HandleAuraButtonOnEnter);
  self:HookScript("OnLeave", tk.GeneralTooltip_OnLeave);

  -- Masque Support:
  if (self.settings.masque) then
    if (not masqueGroup) then
      local masque = _G.LibStub("Masque", true);

      if (masque) then
        masqueGroup = masque:Group("MayronUI", "Auras");
        -- masqueGroup.db.Gloss = true;
        -- masqueGroup.db.Colors.Normal = {};

        masqueGroup:SetCallback(function(GroupID, Group, SkinID, Backdrop, Shadow, Gloss, Colors, Disabled)
          print("Hello from my callback!")
          print(GroupID, Group, SkinID, Backdrop, Shadow, Gloss, Colors, Disabled);
        end)
      end
    end

    local masqueType;

    if (self.filter == "HELPFUL") then
      if (self.auraType == "item") then
        masqueType = "Enchant";
      else
        masqueType = "Buff";
      end
    else
      masqueType = "Debuff";
    end

    masqueGroup:AddButton(self.iconFrame, {
      Mask = self.maskTexture,
      IconBorder = self.iconBorder,
      Icon = self.fakeIconTexture,
      Cooldown = self.cooldown,
    }, masqueType, true);
  end
end

function AuraButtonMixin:UpdateDisplayInfo()
  self.iconTexture:SetTexture(self.texture);

  local hasTimeRemainingText = obj:IsNumber(self.timeRemaining) and self.timeRemaining > 0;
  local hasCooldown = obj:IsNumber(self.duration) and self.duration > 0 and obj:IsNumber(self.startTime) and self.startTime > 0;

  if (hasTimeRemainingText and hasCooldown) then
    if (self.auraNameText) then
      self.auraNameText:SetWidth(self.settings.barWidth - 60);
    end
    self.cooldown:SetCooldown(self.startTime, self.duration);
  else
    if (self.auraNameText) then
      self.auraNameText:SetWidth(self.settings.barWidth);
    end
    self.cooldown:Clear();
  end

  local auraColor = self.settings.colors[self.filter:lower()];
  local r, g , b = unpack(auraColor);
  self:SetAlpha(1);

  if (self.auraType == "item") then
    local invSlotId = self:GetID();
    local quality = GetInventoryItemQuality("player", invSlotId);

    if (obj:IsNumber(quality)) then
      r, g, b = GetItemQualityColor(quality);
    end

  elseif (self.filter == "HARMFUL") then
    if (obj:IsString(self.auraType)) then
      local typeColor = self.settings.colors[self.auraType:lower()];

      if (obj:IsTable(typeColor)) then
        r, g, b = unpack(typeColor);
      end
    end

  elseif (self.statusbar) then
    if (self.owned) then
      r, g, b = unpack(self.settings.colors.owned);
    else
      self:SetAlpha(self.settings.nonPlayerAlpha);
      r, g, b = unpack(self.settings.colors.foreground);
    end
  end

  if (self.auraNameText) then
    self.auraNameText:SetText(self.name);
  end

  if (self.statusbar) then
    self.iconFrame:SetBackdropBorderColor(0, 0, 0);
    self.statusbar:SetStatusBarColor(r, g, b);
  else
    self.iconBorder:SetVertexColor(r, g, b);
  end

  self.timeRemainingLastUpdate = 1;
  self.countLastUpdate = 1;
  self.sliderLastUpdate = 1;

  if (self.timer) then
    self.timer:Cancel();
  end
end

local enchantDurations = {};

local function OnAuraButtonAttributeChanged(self, attribute, value)
  if (not (attribute == "index" or attribute == "target-slot")) then
    return
  end

  self:SetID(value);

  if (attribute == 'index') then
    local name, texture, count, auraType, duration, expiryTime, source = UnitAura("player", value, self.filter);

    self.expiryTime = expiryTime;
    self.startTime = expiryTime - duration;
    self.duration = duration; -- can use cooldown
    self.timeRemaining = expiryTime - GetTime();
    self.auraType = auraType;
    self.count = count;
    self.name = name;
    self.owned = source and (UnitGUID("player") == UnitGUID(source));

    if (name) then
      self.texture = texture;
    end

  elseif (attribute == "target-slot") then
    local hasEnchant, timeRemainingInThousands, count;

    if (value == 16) then -- main hand
      hasEnchant, timeRemainingInThousands, count = GetWeaponEnchantInfo();

    elseif (value == 17) then -- off hand
      hasEnchant, timeRemainingInThousands, count = select(5, GetWeaponEnchantInfo());
    end

    if (hasEnchant) then
      local name = GetEnchantName(value);
      self.duration = enchantDurations[name] or timeRemainingInThousands / 1000;

      if (not enchantDurations[name] or enchantDurations[name] < self.duration) then
        enchantDurations[name] = self.duration;
      end

      self.timeRemaining = timeRemainingInThousands / 1000;
      self.expiryTime = self.timeRemaining + GetTime();
      self.startTime = self.expiryTime - self.duration; -- we can't know the beginning of every possible enchant
      self.auraType = "item";
      self.count = count;
      self.name = name;

      local texture = GetInventoryItemTexture("player", value);
      self.texture = texture;
    end
  end

  self:ApplyStyling();
  self:UpdateDisplayInfo();
end

local function OnHeaderAttributeChanged(self, name, btn)
  if (not (name:match("^child") or name:match("^tempenchant"))) then
    return;
  end

  btn.filter = self.filter;
  btn.settings = self.settings;

  _G.Mixin(btn, AuraButtonMixin);

  if (self.filter == "HELPFUL") then
    btn:RegisterForClicks('RightButtonUp');
    btn:SetAttribute('type2', 'cancelaura');
  end

  btn:SetScript('OnAttributeChanged', OnAuraButtonAttributeChanged);
  btn:Show();
end

local function CreateAuraHeader(filter, settings)
  local mode = settings.mode;
  settings = settings[mode];

  if (not obj:IsTable(settings)) then
    MayronUI:LogError("Failed to load settings for %s auras with mode %s", filter, mode);
  end

  settings.colors = colorSettings;
  settings.mode = mode;

  local auraPoint;

  local width, height = GetAuraButtonSize(settings);
  local xOffset = math.abs(width + settings.xSpacing);
  local yOffset = math.abs(height + settings.ySpacing);

  if (settings.vDirection == "DOWN") then
    auraPoint = "TOP";
    yOffset = -yOffset;
  else
    auraPoint = "BOTTOM";
  end

  if (settings.hDirection == "LEFT") then
    auraPoint = auraPoint .. "RIGHT";
    xOffset = -xOffset;
  else
    auraPoint = auraPoint .. "LEFT";
  end

  local globalName = filter == "HELPFUL" and "MUI_BuffFrames" or "MUI_DebuffFrames";
  local header = CreateFrame("Frame", globalName, _G.UIParent, "SecureAuraHeaderTemplate");
  header.filter = filter;
  header.settings = settings;

  local pos = settings.position;
  local relativeFrame = _G[pos[2]] or _G.UIParent;
  header:SetPoint(pos[1], relativeFrame, pos[3], pos[4], pos[5]);
  header:SetSize(width, height);

  header:SetAttribute("unit", "player");
  header:SetAttribute("filter", filter)

  if (filter == "HELPFUL") then
    header:SetAttribute("includeWeapons", 1);
    header:SetAttribute("weaponTemplate", "SecureActionButtonTemplate");
  end

  header:SetAttribute("template", "SecureActionButtonTemplate"); -- ActionButtonTemplate
  header:SetAttribute("minWidth", width);
  header:SetAttribute("minHeight", height);
  header:SetAttribute("point", auraPoint);
  header:SetAttribute("xOffset", xOffset);
  header:SetAttribute("yOffset", 0);
  header:SetAttribute("wrapAfter", settings.perRow);
  header:SetAttribute("wrapXOffset", 0);
  header:SetAttribute("wrapYOffset", yOffset);
  header:SetAttribute("sortMethod", "TIME");
  header:SetAttribute("sortDirection", "-");
  header:HookScript('OnAttributeChanged', OnHeaderAttributeChanged);
  header:Show();
end

-- C_AurasModule -----------------------
function C_AurasModule:OnInitialize()
  CreateAuraHeader("HELPFUL", buffSettings);
  CreateAuraHeader("HARMFUL", debuffSettings);

  -- Hide Blizzard frames
  tk:KillElement(_G.BuffFrame);
  tk:KillElement(_G.TemporaryEnchantFrame);
  tk:KillElement(_G.DebuffFrame);
end
