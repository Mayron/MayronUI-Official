-- luacheck: ignore self 143
local _G = _G;
local LibStub = _G.LibStub;

local MayronUI = _G.MayronUI;
local tk, _, _, gui, obj, L = MayronUI:GetCoreComponents();
local OrbitusDB = LibStub:GetLibrary("OrbitusDB");

local unpack, SecondsToTimeAbbrev, Mixin = _G.unpack, _G.SecondsToTimeAbbrev, _G.Mixin;
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

local C_Stack = obj:Import("Pkg-Collections.Stack<T>");
---@cast C_Stack Pkg-Collections.Stack

--------------------------
--> Database SetUp:
--------------------------

---@type DatabaseConfig
local databaseConfig = {
  defaults = {
    profile = {
      colors = {
        timeRemaining = {1, 1, 1};
        count         = {1, 0.82, 0};
        auraName      = {1, 1, 1};
        statusbarBorder = {0, 0, 0};
        helpful        = {0.2, 0.2, 0.2};
        harmful        = {0.76, 0.2, 0.2};
        magic         = {0.2, 0.6, 1};
        disease       = {0.6, 0.4, 0};
        poison        = {0.0, 0.6, 0};
        curse         = {0.6, 0.0, 1};
        background   = { 0, 0, 0, 0.6 };
        foreground   = { 0.15, 0.15, 0.15 };
        owned        = { 0.15, 0.15, 0.15 };
      },

      buffs = {
        mode = "icons";

        icons = {
          pulse = false;
          nonPlayerAlpha = 0.7;
          vDirection = "DOWN";
          hDirection = "LEFT";
          iconWidth = 40;
          iconHeight = 30;
          iconBorderSize = 2;
          xSpacing = 6;
          ySpacing = 20;
          perRow = 10;
          iconShadow = true;
          secondsWarning = 10;
          position = { "TOPRIGHT", "UIParent", "TOPRIGHT", -5, -5 };
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
          nonPlayerAlpha = 1;
          vDirection = "DOWN";
          hDirection = "LEFT";
          iconWidth = 22;
          iconHeight = 20;
          iconBorderSize = 1;
          barWidth = 200;
          barHeight = 22;
          xSpacing = 4;
          ySpacing = 1;
          iconSpacing = 2;
          iconShadow = false;
          perRow = 1;
          secondsWarning = 10;
          texture = "MUI_StatusBar";
          showSpark = true;

          position = { "TOPRIGHT", "UIParent", "TOPRIGHT", -3, -3 };
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

      debuffs = {
        mode = "icons";

        icons = {
          pulse = false;
          nonPlayerAlpha = 0.7;
          vDirection = "DOWN";
          hDirection = "LEFT";
          iconWidth = 40;
          iconHeight = 30;
          iconBorderSize = 1;
          xSpacing = 6;
          ySpacing = 20;
          perRow = 10;
          iconShadow = true;
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
          iconSpacing = 1;
          iconShadow = false;
          perRow = 1;
          secondsWarning = 10;
          position = { "TOPRIGHT", "MUI_BuffFrames", "BOTTOMRIGHT", 0, -40 };
          texture = "MUI_StatusBar";
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
      }
    }
  };
};

-- Local Functions -------------
local GetEnchantName;

do
  local scanners = C_Stack:UsingTypes("GameTooltip")();

  scanners:OnNewItem(function()
    local scanner = tk:CreateFrame("GameTooltip", nil, "MUIAurasScanner", "GameTooltipTemplate");
    scanner:SetOwner(_G["MUI_BuffFrames"], "ANCHOR_NONE");
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
local C_AurasModule = MayronUI:RegisterModule("AurasModule", L["Auras (Buffs & Debuffs)"], false);
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
    relativeFrame = self.mask;
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
    local _, _, count = UnitAura("player", self.id or self:GetID(), self.filter);

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
  local auraId = self.id or self:GetID();

  if (self.auraType == "item") then
    GameTooltip:SetInventoryItem("player", auraId);
  else
    GameTooltip:SetUnitAura("player", auraId, self.filter);
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

---@param auraType "buffs"|"debuffs"
---@param mode "icons"|"statusbars"
---@param profile ProfileRepositoryMixin
---@return number width
---@return number height
local function GetAuraButtonSize(auraType, mode, profile)
  local width = profile:Query({auraType, mode, "iconWidth"}, "number");
  local height = profile:Query({auraType, mode, "iconHeight"}, "number");

  if (mode == "statusbars") then
    local iconSpacing = profile:Query({auraType, mode, "iconSpacing"}, "number");
    local barWidth = profile:Query({auraType, mode, "barWidth"}, "number");
    local barHeight = profile:Query({auraType, mode, "barHeight"}, "number");

    width = width + iconSpacing + barWidth;
    height = math.max(height, barHeight);
  end

  return width, height;
end

function AuraButtonMixin:ApplyStyling()
  if (self.iconFrame) then return end
  if (not self.texture) then return end

  local width, height = GetAuraButtonSize(self.settings);
  local borderSize = self.settings.iconBorderSize;
  self:SetSize(width, height);

  -- Set Up Icon:
  self.iconFrame = tk:CreateFrame("Frame", self, nil, _G.BackdropTemplateMixin and "BackdropTemplate");
  self.iconFrame:SetSize(self.settings.iconWidth, self.settings.iconHeight);
  self.iconFrame:SetPoint("TOPLEFT");

  tk:SetBackground(self.iconFrame, 0, 0, 0);

  local borderTexturePath = tk:GetAssetFilePath("Textures\\Widgets\\IconBorder");
  gui:CreateGridTexture(self.iconFrame, borderTexturePath, 4, 2, 64, 64, "OVERLAY");

  local maskTexturePath = tk:GetAssetFilePath("Textures\\black");
  self.mask = self.iconFrame:CreateMaskTexture();
  self.mask:SetTexture(maskTexturePath, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE");
  self.mask:SetPoint("TOPLEFT");
  self.mask:SetPoint("BOTTOMRIGHT", 0, 2);

  local glossTexturePath = tk:GetAssetFilePath("Textures\\Widgets\\Gloss");
  self.gloss = self.iconFrame:CreateTexture(nil, "OVERLAY");
  self.gloss:SetAlpha(0.4);
  self.gloss:SetTexture(glossTexturePath);
  self.gloss:SetPoint("TOPLEFT", borderSize, -borderSize);
  self.gloss:SetPoint("BOTTOMRIGHT", -borderSize, borderSize);

  self.cooldown = tk:CreateFrame("Cooldown", self.iconFrame, nil, "CooldownFrameTemplate");
  self.cooldown:SetReverse(1);
  self.cooldown:SetHideCountdownNumbers(true);
  self.cooldown:SetPoint("TOPLEFT", borderSize, -borderSize);
  self.cooldown:SetPoint("BOTTOMRIGHT", -borderSize, borderSize);
  self.cooldown:SetFrameStrata("TOOLTIP");
  self.cooldown.noCooldownCount = true; -- disable OmniCC

  self.icon = self.iconFrame:CreateTexture(nil, "ARTWORK");
  self.icon:SetTexture(self.texture);
  self.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9);

  local diff = math.abs(self.settings.iconWidth - self.settings.iconHeight);
  local iconWidth, iconHeight = self.settings.iconWidth, self.settings.iconHeight;

  if (diff > 5) then
    diff = diff * 0.25; -- squish the texture by only 25%

    if (iconWidth > iconHeight) then
      iconHeight = math.max(iconWidth - diff, iconHeight);
    else
      iconWidth = math.max(iconHeight - diff, iconWidth);
    end
  end

  self.icon:SetPoint("CENTER");
  self.icon:SetSize(iconWidth, iconHeight);
  self.icon:AddMaskTexture(self.mask);

  -- Status Bar:
  if (self.settings.mode == "statusbars") then
    self.statusbarFrame = tk:CreateFrame("Frame", self, nil, _G.BackdropTemplateMixin and "BackdropTemplate");
    self.statusbarFrame:SetPoint("LEFT", self.iconFrame, "RIGHT", self.settings.iconSpacing, 0);
    self.statusbarFrame:SetPoint("RIGHT");
    self.statusbarFrame:SetHeight(self.settings.barHeight);

    self.statusbarFrame:SetBackdrop({
      edgeFile = "interface\\addons\\MUI_Core\\Assets\\Borders\\Solid",
      edgeSize = borderSize,
    });

    self.statusbarFrame:SetBackdropBorderColor(unpack(self.settings.colors.statusbarBorder));
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
end

function AuraButtonMixin:UpdateDisplayInfo()
  self.icon:SetTexture(self.texture);

  local hasTimeRemainingText = obj:IsNumber(self.timeRemaining) and self.timeRemaining > 0;
  local hasCooldown = obj:IsNumber(self.duration) and self.duration > 0 and obj:IsNumber(self.startTime) and self.startTime > 0;

  if (hasTimeRemainingText and hasCooldown) then
    if (self.auraNameText) then
      local xOffset = select(4, self.auraNameText:GetPoint());
      self.auraNameText:SetWidth(self.settings.barWidth - xOffset - 34);
    end

    self.cooldown:SetCooldown(self.startTime, self.duration);
  else
    if (self.auraNameText) then
      local xOffset = select(4, self.auraNameText:GetPoint());
      self.auraNameText:SetWidth(self.settings.barWidth - xOffset - 4);
    end
    self.cooldown:Clear();
  end

  local auraColor = self.settings.colors[self.filter:lower()];
  local r, g , b = unpack(auraColor);
  self:SetAlpha(1);

  if (self.auraType == "item") then
    local invSlotId = self.id or self:GetID();
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
    self.iconFrame:SetGridColor(0, 0, 0);
    self.statusbar:SetStatusBarColor(r, g, b);
  else
    self.iconFrame:SetGridColor(r, g, b);
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

  -- this is required to fix a blizz bug with Enchant Auras assigning
  -- the ID after instead of before, like all other auras:
  self.id = value;

  if (attribute == "index") then
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
    return
  end

  btn.filter = self.filter;
  btn.settings = self.settings;

  Mixin(btn, AuraButtonMixin);

  if (self.filter == "HELPFUL") then
    btn:RegisterForClicks('RightButtonUp');
  end

  btn:SetScript('OnAttributeChanged', OnAuraButtonAttributeChanged);
end

---@param filter "HELPFUL"|"HARMFUL"
---@param profile ProfileRepositoryMixin
local function CreateAuraHeader(filter, profile)
  local auraType = (filter == "HELPFUL") and "buffs" or "debuffs";
  local mode = profile:Query({auraType, "mode"}, "string");

  local settings = profile:QueryAll({auraType, mode}, {
    "xSpacing",
    "ySpacing",
    "vDirection",
    "hDirection",
    ["position[1]"] = "point",
    ["position[2]"] = "relFrameName",
    ["position[3]"] = "relPoint",
    ["position[4]"] = "frameXOffset",
    ["position[5]"] = "frameYOffset"
  });

  local auraPoint;

  local width, height = GetAuraButtonSize(auraType, mode, profile);
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

  local point = OrbitusDB:VerifyVar("point", settings.point, "string");
  local relFrameName = OrbitusDB:VerifyVar("relFrameName", settings.relFrameName, "string");
  local relPoint = OrbitusDB:VerifyVar("relPoint", settings.relPoint, "string");
  local frameXOffset = OrbitusDB:VerifyVar("frameXOffset", settings.frameXOffset, "number");
  local frameYOffset = OrbitusDB:VerifyVar("frameYOffset", settings.frameYOffset, "number");

  local relativeFrame = _G[relFrameName] or _G.UIParent;
  header:SetPoint(point, relativeFrame, relPoint, frameXOffset, frameYOffset);
  header:SetSize(width, height);
  header:SetAttribute("unit", "player");
  header:SetAttribute("filter", filter);

  if (filter == "HELPFUL") then
    header:SetAttribute("includeWeapons", 1);
    header:SetAttribute("weaponTemplate", "SecureActionButtonTemplate");
    header:SetAttribute('initialConfigFunction', [[
      self:SetAttribute('type2', 'cancelaura');
    ]]);
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
---@param db DatabaseMixin
function C_AurasModule:OnInitialize(db)
  local profile = db.profile;
  CreateAuraHeader("HELPFUL", profile);
  CreateAuraHeader("HARMFUL", profile);

  -- Hide Blizzard frames
  tk:KillElement(_G.BuffFrame);
  tk:KillElement(_G.TemporaryEnchantFrame);
  tk:KillElement(_G.DebuffFrame);
end

OrbitusDB:Register("MUI_AurasDB", databaseConfig, function (db)
  C_AurasModule:Initialize(db);
end);