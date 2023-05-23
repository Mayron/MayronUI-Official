-- luacheck: ignore self 143
local addOnName = ...;
local _G = _G;
local LibStub = _G.LibStub;

local MayronUI = _G.MayronUI;
local tk, _, _, gui, obj, L = MayronUI:GetCoreComponents();
local OrbitusDB = LibStub:GetLibrary("OrbitusDB");

local unpack, Mixin = _G.unpack, _G.Mixin;
local GetTime, UnitGUID = _G.GetTime, _G.UnitGUID;
local GetInventoryItemQuality = _G.GetInventoryItemQuality;
local GetItemQualityColor = _G.GetItemQualityColor;
local GetInventoryItemTexture = _G.GetInventoryItemTexture;
local UnitAura, CreateFrame, GetWeaponEnchantInfo = _G.UnitAura, _G.CreateFrame, _G.GetWeaponEnchantInfo;
local select, math, string = _G.select, _G.math, _G.string;
local GetInventoryItemLink, GetItemInfo = _G.GetInventoryItemLink, _G.GetItemInfo;

local BUFF_FLASH_TIME_ON = 0.75;
local BUFF_MIN_ALPHA = 0.3;
local BUFF_WARNING_TIME = 31;

---@class MUI_AurasDB : OrbitusDB.DatabaseMixin

--------------------------
--> Database SetUp:
--------------------------
---@enum AuraColorTypes
local AuraColorTypes = {
  timeRemaining = "timeRemaining";
  count = "count";
  auraName = "auraName";
  barBorders = "barBorders";
  helpful = "helpful";
  harmful = "harmful";
  magic = "magic";
  disease = "disease";
  poison = "poison";
  curse = "curse";
  background = "background";
  owned = "owned";
};

---@alias AuraTextName "auraName"|"timeRemaining"|"count"

---@type OrbitusDB.DatabaseConfig
local databaseConfig = {
  svName = "MUI_AurasDB";
  defaults = {
    profile = {
      enabled = true;
      colors = {
        timeRemaining = {1, 1, 1};
        count         = {1, 0.82, 0};
        auraName      = {1, 1, 1};
        barBorders = {0, 0, 0};
        helpful        = {0.15, 0.15, 0.15};
        harmful        = {0.76, 0.2, 0.2};
        magic         = {0.2, 0.6, 1};
        disease       = {0.6, 0.4, 0};
        poison        = {0.0, 0.6, 0};
        curse         = {0.6, 0.0, 1};
        background   = { 0, 0, 0, 0.6 };
        owned        = { 0.15, 0.15, 0.15 };
      },
      buffs = {
        mode = "icons";

        icons = {
          pulse = false;
          nonPlayerAlpha = 1;
          vDirection = "DOWN";
          hDirection = "LEFT";
          iconWidth = 40;
          iconHeight = 30;
          iconBorderSize = 2;
          xSpacing = 6;
          ySpacing = 20;
          perRow = 10;
          secondsWarning = 10;
          relFrame = "Minimap";
          relPoint = "TOPLEFT";
          xOffset = -6;
          yOffset = -1;
          fonts = {
            timeRemaining = "Prototype";
            count = "Prototype";
          },
          textSize = {
            timeRemaining = 11;
            timeRemainingLarge = 14;
            count = 14;
          };
          textPosition = {
            timeRemaining = { "TOP", "iconFrame", "BOTTOM", 0, -4 };
            count         = { "BOTTOMRIGHT", "icon", "BOTTOMRIGHT", -2, 0 };
          };
        };

        statusbars = {
          pulse = false;
          nonPlayerAlpha = 0.7;
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
          perRow = 1;
          secondsWarning = 10;
          texture = "MayronUI";
          border = "Solid";
          barBorderSize = 1;
          showSpark = true;
          relFrame = "UIParent";
          relPoint = "TOPRIGHT";
          xOffset = -3;
          yOffset = -3;

          fonts = {
            timeRemaining = "Prototype";
            count = "Prototype";
            auraName = "MUI_Font";
          },

          textSize = {
            timeRemaining = 11;
            timeRemainingLarge = 14;
            count = 14;
            auraName = 10;
          };

          textPosition = {
            timeRemaining = { "RIGHT", "bar", "RIGHT", -4, 0 };
            count         = { "RIGHT", "icon", "LEFT", -4, 0 };
            auraName      = { "LEFT", "bar", "LEFT", 4, 0 };
          };
        }
      };

      debuffs = {
        mode = "icons";

        icons = {
          pulse = false;
          nonPlayerAlpha = 1;
          vDirection = "DOWN";
          hDirection = "LEFT";
          iconWidth = 40;
          iconHeight = 30;
          iconBorderSize = 1;
          xSpacing = 6;
          ySpacing = 20;
          perRow = 10;
          secondsWarning = 10;
          relFrame = "MUI_BuffFrames";
          relPoint = "BOTTOMRIGHT";
          xOffset = 0;
          yOffset = -40;

          fonts = {
            timeRemaining = "Prototype";
            count = "Prototype";
          },

          textSize = {
            timeRemaining = 11;
            timeRemainingLarge = 14;
            count = 14;
          };
          textPosition = {
            timeRemaining = { "TOP", "iconFrame", "BOTTOM", 0, -4 };
            count         = { "BOTTOMRIGHT", "icon", "BOTTOMRIGHT", -2, 0 };
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
          perRow = 1;
          secondsWarning = 10;
          relFrame = "MUI_BuffFrames";
          relPoint = "TOPLEFT";
          xOffset = -20;
          yOffset = 0;
          texture = "MayronUI";
          border = "Solid";
          barBorderSize = 1;
          showSpark = true;

          fonts = {
            timeRemaining = "Prototype";
            count = "Prototype";
            auraName = "MUI_Font";
          },

          textSize = {
            timeRemaining = 11;
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
  local scanner = nil;

  local function GetEnchantNameBySlotID(slotID)
    if (not scanner) then
      scanner = tk:CreateFrame("GameTooltip", nil, "MUIAurasScanner", "GameTooltipTemplate");
      scanner:SetOwner(_G["MUI_BuffFrames"] or _G["UIParent"], "ANCHOR_NONE");
    end

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
local C_AurasModule = MayronUI:RegisterModule("AurasModule", _G["AURAS"] or "Auras");

---@class AuraButtonMixin : Button
---@field filter "HELPFUL"|"HARMFUL"
---@field auraSubType string? # The type of buff or debuff, e.g., "curse", "poison", etc... or "item"
---@field mode "icons"|"statusbars"
---@field texture string?
---@field name string
---@field statusbarFrame BackdropTemplate|Frame
---@field expiryTime number
---@field duration number
---@field itemID number?
---@field startTime number?
---@field timeRemaining number?
---@field owned boolean
local AuraButtonMixin = {};

---@param name AuraTextName
function AuraButtonMixin:UpdateTextStyle(name)
  local fontString = self[name.."Text"]--[[@as FontString]];
  if (not fontString) then return end

  fontString:SetTextColor(self:GetColorSetting(name));

  local point, relativeFrameName, relativePoint, xOffset, yOffset = self:GetTextPositionSettings(name);
  local relativeFrame;

  if (relativeFrameName == "icon") then
    relativeFrame = self.iconFrame.mask;
  elseif (relativeFrameName == "iconFrame") then
    relativeFrame = self.iconFrame;
  elseif (relativeFrameName == "bar") then
    relativeFrame = self.statusbarFrame;
  elseif (relativeFrameName == "aura") then
    relativeFrame = self;
  end

  if (not obj:IsTable(relativeFrame)) then
    relativeFrame = self;
  end

  if (point:find("LEFT")) then
    fontString:SetJustifyH("LEFT");
  elseif (point:find("RIGHT")) then
    fontString:SetJustifyH("RIGHT");
  else
    fontString:SetJustifyH("CENTER");
  end

  fontString:ClearAllPoints();
  fontString:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset);

  local textSize = self:GetSetting("number", "textSize", name);
  tk:SetFontSize(fontString, textSize);

  local font = self:GetSetting("string", "fonts", name);
  tk:SetFont(fontString, font);
end

function AuraButtonMixin:SetSliderValue(newValue)
  tk:AnimateSliderChange(self.statusbar, newValue);
end

---@param self AuraButtonMixin
local function HandleAuraButtonOnUpdate(self, elapsed)
  local usingStatusbars = self.mode == "statusbars";

  self.timeRemainingLastUpdate = (self.timeRemainingLastUpdate or 0) + elapsed;
  self.countLastUpdate = (self.countLastUpdate or 0) + elapsed;

  if (usingStatusbars) then
    self.sliderLastUpdate = (self.sliderLastUpdate or 0) + elapsed;
  end

  self.timeRemaining = self.expiryTime - GetTime();
  local hasTimeRemaining = obj:IsNumber(self.timeRemaining) and self.timeRemaining > 0;
  local pulse = self:GetSetting("boolean", "pulse");

  if (pulse) then
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
  else
    self:SetAlpha(1);
  end

  if (self.countText and self.countLastUpdate > 0.1) then
    local id = self.itemID or self:GetID() or 0;
    ---@diagnostic disable-next-line: param-type-mismatch
    local _, _, count = UnitAura("player", id, self.filter);

    if (not count or count < 1) then
      self.countText:SetText(tk.Strings.Empty);
      self.countLastUpdate = -10;
    else
      if (count == 1) then
        self.countText:SetText(tk.Strings.Empty);
      else
        self.countText:SetText(count);
      end

      self.countLastUpdate = 0;
    end
  end

  if (self.timeRemainingLastUpdate > 0.1 and self.expiryTime == 0) then
    self.timeRemainingText:SetText(tk.Strings.Empty);

    if (usingStatusbars and self.statusbar) then
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

  if (usingStatusbars and self.statusbar and self.sliderLastUpdate > 0.1) then
    if (hasTimeRemaining) then
      self.statusbar:SetMinMaxValues(0, self.duration);
      self:SetSliderValue(self.timeRemaining);

      if (self.spark and self.spark.enabled) then
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
      local fontSize = self:GetSetting("number", "textSize", "timeRemaining");
      local secondsWarning = self:GetSetting("number", "secondsWarning");
      local largeFontSize = self:GetSetting("number", "textSize", "timeRemainingLarge");
      local r, g, b = self:GetColorSetting(AuraColorTypes.timeRemaining);
      tk:SetTimeRemaining(self.timeRemainingText, self.timeRemaining, fontSize, secondsWarning, largeFontSize, r, g, b);
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
  self.spark.enabled = shown;
end

---@param auraType "buffs"|"debuffs"
---@param db OrbitusDB.DatabaseMixin?
---@return number width
---@return number height
local function GetAuraButtonSize(auraType, db)
  if (not db) then
    db = MayronUI:GetComponent("MUI_AurasDB");
  end

  local mode = db.profile:QueryType("string", auraType, "mode");
  local width = db.profile:QueryType("number", auraType, mode, "iconWidth");
  local height = db.profile:QueryType("number", auraType, mode, "iconHeight");

  if (mode == "statusbars") then
    local iconSpacing = db.profile:QueryType("number", auraType, mode, "iconSpacing");
    local barWidth = db.profile:QueryType("number", auraType, mode, "barWidth");
    local barHeight = db.profile:QueryType("number", auraType, mode, "barHeight");

    width = width + iconSpacing + barWidth;
    height = math.max(height, barHeight);
  end

  return width, height;
end

---@generic T
---@param settingType `T`
---@param settingName string
---@param ... (string|number)
---@return T
---@nodiscard
function AuraButtonMixin:GetSetting(settingType, settingName, ...)
  local db = MayronUI:GetComponent("MUI_AurasDB");
  local auraType = (self.filter == "HELPFUL") and "buffs" or "debuffs";
  return db.profile:QueryType(settingType, auraType, self.mode, settingName, ...);
end

---@param colorSettingName AuraColorTypes
---@return number, number, number, number
---@nodiscard
function AuraButtonMixin:GetColorSetting(colorSettingName)
  local db = MayronUI:GetComponent("MUI_AurasDB");
  local r = db.profile:QueryType("number", "colors", colorSettingName, 1);
  local g = db.profile:QueryType("number", "colors", colorSettingName, 2);
  local b = db.profile:QueryType("number", "colors", colorSettingName, 3);
  local a = db.profile:QueryType("number?", "colors", colorSettingName, 4);

  local alpha = (a or 1)--[[@as number]];
  return r, g, b, alpha;
end

---@param textName AuraTextName
---@return string, string, string, number, number
function AuraButtonMixin:GetTextPositionSettings(textName)
  local db = MayronUI:GetComponent("MUI_AurasDB");
  local auraType = (self.filter == "HELPFUL") and "buffs" or "debuffs";
  local position = db.profile:QueryType("table", auraType, self.mode, "textPosition", textName);
  return unpack(position);
end

function AuraButtonMixin:UpdateStyling()
  local db = MayronUI:GetComponent("MUI_AurasDB");
  local auraType = (self.filter == "HELPFUL") and "buffs" or "debuffs";
  local width, height = GetAuraButtonSize(auraType, db);
  self:SetSize(width, height);

  local borderSize = self:GetSetting("number", "iconBorderSize");
  local iconWidth = self:GetSetting("number", "iconWidth");
  local iconHeight = self:GetSetting("number", "iconHeight");

  -- Set Up Icon:
  self.iconFrame:SetSize(iconWidth, iconHeight);
  local diff = math.abs(iconWidth - iconHeight);

  if (diff > 5) then
    diff = diff * 0.25; -- squish the texture by only 25%

    if (iconWidth > iconHeight) then
      iconHeight = math.max(iconWidth - diff, iconHeight);
    else
      iconWidth = math.max(iconHeight - diff, iconWidth);
    end
  end

  self.icon:SetSize(iconWidth, iconHeight);
  self.iconFrame.gloss:SetPoint("TOPLEFT", borderSize, -borderSize);
  self.iconFrame.gloss:SetPoint("BOTTOMRIGHT", -borderSize, borderSize);

  local usingStatusbars = self.mode == "statusbars";

  local countTemplate = (usingStatusbars and "GameFontNormal") or "NumberFont_Outline_Large";
  self.countText:SetFontObject(countTemplate);

  self.cooldown:SetPoint("TOPLEFT", borderSize, -borderSize);
  self.cooldown:SetPoint("BOTTOMRIGHT", -borderSize, borderSize);

  self:UpdateTextStyle("count");
  self:UpdateTextStyle("timeRemaining");

  if (not usingStatusbars) then
    if (self.statusbarFrame) then
      self.statusbarFrame:Hide();
    end

    if (self.auraNameText) then
      self.auraNameText:Hide();
    end

    return
  end

  self.auraNameText:Show();
  self:UpdateTextStyle("auraName");

  local barBorderSize = self:GetSetting("number", "barBorderSize");
  local borderName = self:GetSetting("string", "border");
  local border = tk.Constants.LSM:Fetch("border", borderName)--[[@as string]];

  if (barBorderSize > 0) then
    self.statusbarFrame:SetBackdrop({
      edgeFile = border;
      edgeSize = barBorderSize;
    });
  else
    self.statusbarFrame:SetBackdrop(nil);
  end

  self.statusbar:SetPoint("TOPLEFT", barBorderSize, -barBorderSize);
  self.statusbar:SetPoint("BOTTOMRIGHT", -barBorderSize, barBorderSize);

  local borderR, borderG, borderB = self:GetColorSetting(AuraColorTypes.barBorders);
  self.iconFrame:SetGridColor(borderR, borderG, borderB);
  self.statusbarFrame:SetBackdropBorderColor(borderR, borderG, borderB, 1);

  local r, g, b, a = self:GetColorSetting(AuraColorTypes.background);
  self.statusbar.background:SetVertexColor(r, g, b, a);

  local iconSpacing = self:GetSetting("number", "iconSpacing");
  self.statusbarFrame:SetPoint("LEFT", self.iconFrame, "RIGHT", iconSpacing, 0);
  self.statusbarFrame:SetPoint("RIGHT");

  local barHeight = self:GetSetting("number", "barHeight");
  self.statusbarFrame:SetHeight(barHeight);
  self.statusbarFrame:Show();
end

function AuraButtonMixin:CreateStatusBar()
  if (self.statusbarFrame) then return end

  local parentName = self:GetName();
  self.statusbarFrame = tk:CreateBackdropFrame("Frame", self, parentName.."StatusBarFrame");
  self.statusbarFrame:SetFrameLevel(self:GetFrameLevel());

  self.statusbar = tk:CreateFrame("StatusBar", self.statusbarFrame, parentName.."StatusBar");
  self.statusbar:SetPoint("TOPLEFT", 1, -1);
  self.statusbar:SetPoint("BOTTOMRIGHT", -1, 1);

  local r, g, b, a = self:GetColorSetting(AuraColorTypes.background);
  self.statusbar.background = tk:SetBackground(self.statusbar, r, g, b, a);

  local texture = self:GetSetting("string", "texture");
  local statusBarTexture = tk.Constants.LSM:Fetch("statusbar", texture);
  self.statusbar:SetStatusBarTexture(statusBarTexture);

  self.auraNameText = self.textFrame:CreateFontString(parentName.."AuraName", "OVERLAY", "GameFontNormalSmall");
  self.auraNameText:SetWordWrap(false);

  local showSpark = self:GetSetting("boolean", "showSpark");
  self:SetSparkShown(showSpark);
end

function AuraButtonMixin:CreateIconFrame()
  if (self.iconFrame) then return end
  if (not self.texture) then return end

  local borderSize = self:GetSetting("number", "iconBorderSize");
  local iconWidth = self:GetSetting("number", "iconWidth");
  local iconHeight = self:GetSetting("number", "iconHeight");

  -- Set Up Icon:
  self.iconFrame = gui:CreateIcon(borderSize, iconWidth, iconHeight, self, "aura", self.texture, true);
  self.textFrame = tk:CreateFrame("Frame", self);
  self.textFrame:SetAllPoints(true);
  self.textFrame:SetFrameStrata("HIGH");
  self.textFrame:SetFrameLevel(20);
  self.icon = self.iconFrame.icon;
  self.cooldown = self.iconFrame.cooldown;

  local parentName = self:GetName();

  self.countText = self.textFrame:CreateFontString(parentName.."Count", "OVERLAY");
  self.timeRemainingText = self.textFrame:CreateFontString(parentName.."TimeRemaining", "OVERLAY", "GameFontNormalSmall");

  -- Status Bar:
  if (self.mode == "statusbars") then
    self:CreateStatusBar();
  end

  self:UpdateStyling();
  self:HookScript("OnUpdate", HandleAuraButtonOnUpdate);
end

function AuraButtonMixin:UpdateDisplayInfo()
  local usingStatusbars = self.mode == "statusbars";
  self.iconFrame.icon:SetTexture(self.texture);
  self.iconFrame.itemID = self.itemID;

  local hasTimeRemainingText = obj:IsNumber(self.timeRemaining) and self.timeRemaining > 0;

  local hasCooldown =
    obj:IsNumber(self.duration) and
    self.duration > 0 and
    obj:IsNumber(self.startTime) and
    self.startTime > 0;

  if (hasTimeRemainingText and hasCooldown) then
    if (usingStatusbars and self.auraNameText) then
      local xOffset = select(4, self.auraNameText:GetPoint());
      local barWidth = self:GetSetting("number", "barWidth");
      self.auraNameText:SetWidth(barWidth - xOffset - 34);
    end

    self.iconFrame.cooldown:SetCooldown(self.startTime, self.duration);
  else
    if (usingStatusbars and self.auraNameText) then
      local xOffset = select(4, self.auraNameText:GetPoint());
      local barWidth = self:GetSetting("number", "barWidth");

      self.auraNameText:SetWidth(barWidth - xOffset - 4);
    end
    self.iconFrame.cooldown:Clear();
  end

  local r, g, b = self:GetColorSetting(self.filter:lower());
  self:SetAlpha(1);

  if (self.auraSubType == "item") then
    local invSlotId = self.itemID or self:GetID() or 0;
    local quality = GetInventoryItemQuality("player", invSlotId);

    if (obj:IsNumber(quality)) then
      r, g, b = GetItemQualityColor(quality);
    end

  elseif (self.filter == "HARMFUL") then
    if (obj:IsString(self.auraSubType)) then
      r, g, b = self:GetColorSetting(self.auraSubType:lower());
    end

    if (self.owned) then
      self:SetAlpha(1);
    else
      local alpha = self:GetSetting("number", "nonPlayerAlpha");
      self:SetAlpha(alpha);
    end
  else
    if (self.owned) then
      r, g, b = self:GetColorSetting("owned");
    else
      local alpha = self:GetSetting("number", "nonPlayerAlpha");
      self:SetAlpha(alpha);
    end
  end

  if (usingStatusbars and self.auraNameText) then
    self.auraNameText:SetText(self.name);
  end

  if (usingStatusbars and self.statusbar) then
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

---@param self AuraButtonMixin
local function OnAuraButtonAttributeChanged(self, attribute, value)
  if (not (attribute == "index" or attribute == "target-slot")) then
    return
  end

  -- this is required to fix a blizz bug with Enchant Auras assigning
  -- the ID after instead of before, like all other auras:
  self.itemID = value;

  if (attribute == "index") then
    local name, texture, count, auraSubType, duration, expiryTime, source = UnitAura("player", value, self.filter);

    self.expiryTime = expiryTime;
    self.startTime = expiryTime - duration;
    self.duration = duration; -- can use cooldown
    self.timeRemaining = expiryTime - GetTime();
    self.auraSubType = auraSubType;
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
      self.auraSubType = "item";
      self.count = count;
      self.name = name;

      local texture = GetInventoryItemTexture("player", value);
      self.texture = texture;
    end
  end

  self.timeRemainingLastUpdate = 0;
  self.countLastUpdate = 0;
  self.sliderLastUpdate = 0;

  self:CreateIconFrame();
  self:UpdateDisplayInfo();
end

local function OnHeaderAttributeChanged(self, name, btn)
  if (not (name:match("^child") or name:match("^tempenchant"))) then
    return
  end

  btn.filter = self.filter;
  btn.mode = self.mode;

  Mixin(btn, AuraButtonMixin);

  if (self.filter == "HELPFUL") then
    btn:RegisterForClicks("RightButtonUp");
  end

  btn:SetScript("OnAttributeChanged", OnAuraButtonAttributeChanged);
end

local function SetUpAuraHeader(db, header, auraType, mode)
  local hDirection = db.profile:QueryType("string", auraType, mode, "hDirection");
  local vDirection = db.profile:QueryType("string", auraType, mode, "vDirection");
  local xSpacing = db.profile:QueryType("number", auraType, mode, "xSpacing");
  local ySpacing = db.profile:QueryType("number", auraType, mode, "ySpacing");

  local width, height = GetAuraButtonSize(auraType, db);
  local headerXOffset = math.abs(width + xSpacing);
  local headerWrapYOffset = math.abs(height + ySpacing);

  local headerPoint;
  if (vDirection == "DOWN") then
    headerPoint = "TOP";
    headerWrapYOffset = -headerWrapYOffset;
  else
    headerPoint = "BOTTOM";
  end

  if (hDirection == "LEFT") then
    headerPoint = headerPoint .. "RIGHT";
    headerXOffset = -headerXOffset;
  else
    headerPoint = headerPoint .. "LEFT";
  end

  header:SetAttribute("point", headerPoint);
  header:SetAttribute("xOffset", headerXOffset);
  header:SetAttribute("wrapYOffset", headerWrapYOffset);

  local relFrameName = db.profile:QueryType("string", auraType, mode, "relFrame");
  local relPoint = db.profile:QueryType("string", auraType, mode, "relPoint");
  local xOffset = db.profile:QueryType("number", auraType, mode, "xOffset");
  local yOffset = db.profile:QueryType("number", auraType, mode, "yOffset");

  local relativeFrame = _G[relFrameName] or _G.UIParent;
  header:ClearAllPoints();
  header:SetPoint(headerPoint, relativeFrame, relPoint, xOffset, yOffset);
end

---@param filter "HELPFUL"|"HARMFUL"
---@param db OrbitusDB.DatabaseMixin
---@param header (Frame|table)?
local function CreateOrUpdateAuraHeader(filter, db, header)
  local auraType = (filter == "HELPFUL") and "buffs" or "debuffs";

  local mode = db.profile:QueryType("string", auraType, "mode");
  local perRow = db.profile:QueryType("number", auraType, mode, "perRow");
  local width, height = GetAuraButtonSize(auraType, db);

  if (not header) then
    local globalName = filter == "HELPFUL" and "MUI_BuffFrames" or "MUI_DebuffFrames";
    header = CreateFrame("Frame", globalName, _G.UIParent, "SecureAuraHeaderTemplate");
  end

  header.filter = filter;
  header.mode = mode;

  MayronUI:LogInfo("Creating/Updating aura header with filter %s and mode %s", filter, mode);

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
  header:SetAttribute("yOffset", 0);
  header:SetAttribute("wrapAfter", perRow);
  header:SetAttribute("wrapXOffset", 0);
  header:SetAttribute("sortMethod", "TIME");
  header:SetAttribute("sortDirection", "-");

  SetUpAuraHeader(db, header, auraType, mode);
  header:HookScript("OnAttributeChanged", OnHeaderAttributeChanged);

  header:Show();
  return header;
end

-- C_AurasModule -----------------------
function C_AurasModule:OnInitialize()
  OrbitusDB:Register(addOnName, databaseConfig, function (db)
    MayronUI:AddComponent("MUI_AurasDB", db);

    db.profile:OnProfileChanged(function(_, old, new)
      MayronUI:LogDebug("Changed profile %s to %s", old, new);
    end);

    db.profile:OnProfileListChanged(function(self)
      MayronUI:LogDebug("Changed profile list: ", unpack(self:GetAllProfiles()));
    end);

    local isEnabled = db.profile:QueryType("boolean", "enabled");

    if (isEnabled) then
      self:SetEnabled(true);
    end
  end);
end

function C_AurasModule:OnEnabled(data)
  local db = MayronUI:GetComponent("MUI_AurasDB");

  if (not data.buffsHeader) then
    data.buffsHeader = CreateOrUpdateAuraHeader("HELPFUL", db);
  end

  if (not data.debuffsHeader) then
    data.debuffsHeader = CreateOrUpdateAuraHeader("HARMFUL", db);
  end

  db.profile:Subscribe("colors", function(_, changes)
    local query = next(changes);
    local list = db.utilities:ToQueryList(query);
    local settingName = list[2];
    db.utilities:PushTable(list);

    local changeType;

    if (settingName == AuraColorTypes.auraName or
        settingName == AuraColorTypes.count or
        settingName == AuraColorTypes.timeRemaining) then
      changeType = "text";
    elseif (settingName == "barBorders" or settingName == "background") then
      changeType = "styling";
    else
      changeType = "info";
    end

    for h = 1, 2 do
      local header = (h == 1 and data.buffsHeader) or data.debuffsHeader;

      for c = 1, 40 do
        local child = header:GetAttribute("child" .. c)--[[@as AuraButtonMixin]];
        if (child and child:IsShown()) then

          if (changeType == "text") then
            child:UpdateTextStyle(settingName--[[@as string]]);
          elseif (changeType == "info") then
            child:UpdateDisplayInfo();
          elseif (changeType == "styling") then
            child:UpdateStyling();
          end
        end
      end
    end
  end);

  for i = 1, 2 do
    local auraType = i == 1 and "buffs" or "debuffs";
    local header = i == 1 and data.buffsHeader or data.debuffsHeader;

    local function updateStylingObserver()
      for c = 1, 40 do
        local child = header:GetAttribute("child" .. c)--[[@as AuraButtonMixin]];
        if (not child) then return end
        child:UpdateStyling();
      end
    end

    ---@type OrbitusDB.Observer
    local function updateTextStylingObserver(_, changes)
      for c = 1, 40 do
        local child = header:GetAttribute("child" .. c)--[[@as AuraButtonMixin]];
        if (not child or not child:IsShown()) then return end

        if (child.UpdateTextStyle) then
          for query in pairs(changes) do
            local keys = db.utilities:ToQueryList(query);
            local name = keys[#keys];

            if (type(name) == "number") then
              name = keys[#keys - 1];
            end

            child:UpdateTextStyle(tostring(name));
          end
        end
      end
    end

    db.profile:Subscribe(auraType..".mode", function(value)
      CreateOrUpdateAuraHeader(header.filter, db, header);
      local enabled = value == "statusbars";

      for c = 1, 40 do
        local child = header:GetAttribute("child" .. c)--[[@as AuraButtonMixin]];
        if (not child) then return end

        child.mode = value;

        if (enabled) then
          child:CreateStatusBar();
        end

        child:UpdateStyling();
        child:UpdateDisplayInfo(); -- apply colors to the correct components
      end
    end);

    for m = 1, 2 do
      local mode = m == 1 and "icons" or "statusbars";

      local auraHeaderObserver = function()
        SetUpAuraHeader(db, header, auraType, mode);
      end

      local widthHeightObserver = function()
        SetUpAuraHeader(db, header, auraType, mode);
        updateStylingObserver();
      end

      local barWidthHeightObserver = function()
        widthHeightObserver();

        -- run UpdateDisplayInfo if barWidth or barHeight to update auraNameText
        for c = 1, 40 do
          local child = header:GetAttribute("child" .. c)--[[@as AuraButtonMixin]];
          if (not child or not child:IsShown()) then return end
          child:UpdateDisplayInfo();
        end
      end

      db.profile:Subscribe(auraType.."."..mode..".hDirection", auraHeaderObserver);
      db.profile:Subscribe(auraType.."."..mode..".vDirection", auraHeaderObserver);
      db.profile:Subscribe(auraType.."."..mode..".xSpacing", auraHeaderObserver);
      db.profile:Subscribe(auraType.."."..mode..".ySpacing", auraHeaderObserver);
      db.profile:Subscribe(auraType.."."..mode..".relFrame", auraHeaderObserver);
      db.profile:Subscribe(auraType.."."..mode..".relPoint", auraHeaderObserver);
      db.profile:Subscribe(auraType.."."..mode..".xOffset", auraHeaderObserver);
      db.profile:Subscribe(auraType.."."..mode..".yOffset", auraHeaderObserver);
      db.profile:Subscribe(auraType.."."..mode..".iconWidth", widthHeightObserver);
      db.profile:Subscribe(auraType.."."..mode..".iconHeight", widthHeightObserver);
      db.profile:Subscribe(auraType.."."..mode..".textSize", updateTextStylingObserver);
      db.profile:Subscribe(auraType.."."..mode..".textPosition", updateTextStylingObserver);
      db.profile:Subscribe(auraType.."."..mode..".fonts", updateTextStylingObserver);
      db.profile:Subscribe(auraType.."."..mode..".iconSpacing", widthHeightObserver);

      if (mode == "statusbars") then
        db.profile:Subscribe(auraType.."."..mode..".barWidth", barWidthHeightObserver);
        db.profile:Subscribe(auraType.."."..mode..".barHeight", barWidthHeightObserver);
        db.profile:Subscribe(auraType.."."..mode..".barBorderSize", updateStylingObserver);
        db.profile:Subscribe(auraType.."."..mode..".border", updateStylingObserver);

        db.profile:Subscribe(auraType.."."..mode..".showSpark", function(value)
          for c = 1, 40 do
            local child = header:GetAttribute("child" .. c)--[[@as AuraButtonMixin]];
            if (not child) then return end
            child:SetSparkShown(value);
          end
        end);

        db.profile:Subscribe(auraType.."."..mode..".texture", function(value)
          local statusBarTexture = tk.Constants.LSM:Fetch("statusbar", value);

          for c = 1, 40 do
            local child = header:GetAttribute("child" .. c)--[[@as AuraButtonMixin]];
            if (not child) then return end

            if (child.statusbar) then
              child.statusbar:SetStatusBarTexture(statusBarTexture);
            end
          end
        end);
      end

      db.profile:Subscribe(auraType.."."..mode..".perRow", function(perRow)
        header:SetAttribute("wrapAfter", perRow);
      end);
    end
  end

  data.buffsHeader:Show();
  data.debuffsHeader:Show();

  -- Hide Blizzard frames
  tk:KillElement(_G.BuffFrame);
  tk:KillElement(_G.TemporaryEnchantFrame);
  tk:KillElement(_G.DebuffFrame);
end

function C_AurasModule:OnDisabled(data)
  if (data.buffsHeader) then
    data.buffsHeader:Hide();
  end

  if (data.debuffsHeader) then
    data.debuffsHeader:Hide();
  end
end