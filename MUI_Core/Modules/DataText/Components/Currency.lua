local _, namespace = ...;
local _G, MayronUI = _G, _G.MayronUI;

-- luacheck: ignore MayronUI self 143 631
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents();
local ComponentsPackage = namespace.ComponentsPackage;
local LABEL_PATTERN = "|cffffffff%s|r";

local tonumber, string, math = _G.tonumber, _G.string, _G.math;
local GetMoney, ipairs, strsplit = _G.GetMoney, _G.ipairs, _G.strsplit;
local GameTooltip = _G.GameTooltip;

-- Objects ---------------------------

local Currency = ComponentsPackage:CreateClass("Currency", nil, "IDataTextComponent");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.currency", {
  showCopper    = true;
  showSilver    = true;
  showGold      = true;
  auto          = true;
  showRealm     = false;
});

-- Local Functions ----------------

---@param enabled boolean
local function SetLabelEnabled(label, enabled)
  if (not enabled) then
    label:SetNormalTexture(1);
    label:GetNormalTexture():SetColorTexture(0, 0, 0, 0.4);
    label:SetHighlightTexture(nil);
  else
    local r, g, b = tk:GetThemeColor();

    label:SetNormalTexture(1);
    label:GetNormalTexture():SetColorTexture(r * 0.5, g * 0.5, b * 0.5, 0.4);
    label:SetHighlightTexture(1);
    label:GetHighlightTexture():SetColorTexture(r * 0.5, g * 0.5, b * 0.5, 0.5);
  end

  label:SetEnabled(enabled);
end

local function Button_OnEnter(self)
  local r, g, b = tk:GetThemeColor();

  GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
  GameTooltip:SetText(L["Commands"]..":")
  GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Left Click:"]), L["Show Overview"], r, g, b, 1, 1, 1);
  GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Right Click:"]), L["Show Reset Options"], r, g, b, 1, 1, 1);
  GameTooltip:Show();
end

local function Button_OnLeave()
  GameTooltip:Hide();
end

-- Currency Module ----------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
  local coloredKey = tk.Strings:SetTextColorByClass(tk:GetPlayerKey());

  -- saves info on the currency that each logged in character has
  if (not db:ParsePathValue(db.global, "datatext.currency.characters")) then
    db:SetPathValue(db.profile, "datatext.currency.todayCurrency", GetMoney());
    db:SetPathValue(db.global, "datatext.currency.characters", obj:PopTable());
  end

  -- store character's money to be seen by other characters
  db.global.datatext.currency.characters[coloredKey] = GetMoney();

  self:RegisterComponentClass("currency", Currency);
end);

function Currency:__Construct(data, settings, dataTextModule, slideController)
  data.settings = settings;
  data.slideController = slideController;

  -- set public instance properties
  self.MenuContent = _G.CreateFrame("Frame");
  self.MenuLabels = obj:PopTable();
  self.TotalLabelsShown = 0;
  self.HasLeftMenu = true;
  self.HasRightMenu = true;
  self.Button = dataTextModule:CreateDataTextButton();
  self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");

  data.goldString = "|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t";
  data.silverString = "|TInterface\\MoneyFrame\\UI-SilverIcon:14:14:2:0|t";
  data.copperString = "|TInterface\\MoneyFrame\\UI-CopperIcon:14:14:2:0|t";
  data.showMenu = true;

  local calendarDate;

  if (_G.C_Calendar.GetDate) then
    calendarDate = _G.C_Calendar:GetDate();

  elseif (_G.C_DateAndTime.GetTodaysDate) then
    calendarDate = _G.C_DateAndTime:GetTodaysDate();

  elseif (_G.C_DateAndTime.GetCurrentCalendarTime) then
    calendarDate = _G.C_DateAndTime:GetCurrentCalendarTime();

  else
    obj:Error("Failed to call calendar API");
  end

  local month = calendarDate["month"];
  local day = calendarDate["day"];

  calendarDate = string.format("%d-%d", day, month);

  if (not (data.settings.date and data.settings.date == calendarDate)) then
    data.settings.todayCurrency = GetMoney();
    data.settings.date = calendarDate;
    data.settings:SaveChanges();
  end

  data.info = obj:PopTable();
  data.info[1] = tk.Strings:SetTextColorByTheme(L["Current Money"]..":");
  data.info[2] = nil; -- value of current money
  data.info[3] = tk.Strings:SetTextColorByTheme(L["Start of the day"]..":");
  data.info[4] = self:GetFormattedCurrency(data.settings.todayCurrency);
  data.info[5] = tk.Strings:SetTextColorByTheme(L["Today's profit"]..":");
  data.info[6] = nil; -- value of today's profile
  data.info[7] = tk.Strings:Concat(_G.NORMAL_FONT_COLOR_CODE..L["Money per character"], ":", "|r");
end

function Currency:IsEnabled(data)
  return data.enabled;
end

function Currency:SetEnabled(data, enabled)
  data.enabled = enabled;

  if (enabled) then
    self.Button:SetScript("OnEnter", Button_OnEnter);
    self.Button:SetScript("OnLeave", Button_OnLeave);

    em:CreateEventHandlerWithKey("PLAYER_MONEY", "PlayerMoneyHandler", function()
      if (not self.Button) then
        return;
      end

      self:Update();
    end);
  else
    em:DestroyEventHandlerByKey("PlayerMoneyHandler");
    data.showMenu = nil;
  end
end

ComponentsPackage:DefineParams("number", "?string", "?boolean")
function Currency:GetFormattedCurrency(data, currency, colorCode, hasLabel)
  local text = "";
  local gold = math.floor(math.abs(currency / 10000));
  local silver = math.floor(math.abs((currency / 100) % 100));
  local copper = math.floor(math.abs(currency % 100));

  colorCode = colorCode or "|cffffffff";

  if (data.settings.auto) then
    if (gold > 0) then
      if (tonumber(gold) >= 1000) then
        gold = string.gsub(gold, "^(-?%d+)(%d%d%d)", '%1,%2');
        text = string.format("%s %s%s|r%s", text, colorCode, gold, data.goldString);
        return string.format(LABEL_PATTERN, text:trim());
      else
        text = string.format("%s %s%s|r%s", text, colorCode, gold, data.goldString);
      end
    end

    if (silver > 0) then
      text = string.format("%s %s%s|r%s", text, colorCode, silver, data.silverString);
    end

    if (gold < 100 and copper > 0) then
      text = string.format("%s %s%s|r%s", text, colorCode, copper, data.copperString);
    end
  else
    if (gold > 0 and (not hasLabel or data.settings.showGold)) then
      if (tonumber(gold) >= 1000) then
        gold = string.gsub(gold, "^(-?%d+)(%d%d%d)", '%1,%2')
      end

      text = string.format("%s %s%s|r%s", text, colorCode, gold, data.goldString);
    end

    if (silver > 0 and (not hasLabel or data.settings.showSilver)) then
      text = string.format("%s %s%s|r%s", text, colorCode, silver, data.silverString);
    end

    if (copper > 0 and (not hasLabel or data.settings.showCopper)) then
      text = string.format("%s %s%s|r%s", text, colorCode, copper, data.copperString);
    end
  end

  if (text == "") then
    if (data.settings.showGold or not hasLabel) then
      text = string.format("%d%s", 0, data.goldString);
    end

    if (data.settings.showSilver or not hasLabel) then
      text = string.format("%s %d%s", text, 0, data.silverString);
    end

    if (data.settings.showCopper or not hasLabel) then
      text = string.format("%s %d%s", text, 0, data.copperString);
    end
  end

  return string.format(LABEL_PATTERN, text:trim());
end

ComponentsPackage:DefineReturns("string");
function Currency:GetTodaysProfit(data)
  local currency = _G.GetMoney() - data.settings.todayCurrency;

  if (currency >= 0) then
    return self:GetFormattedCurrency(currency, _G.GREEN_FONT_COLOR_CODE);

  elseif (currency < 0) then
    currency = math.abs(currency);
    local result = self:GetFormattedCurrency(currency, _G.RED_FONT_COLOR_CODE);

    return string.format(_G.RED_FONT_COLOR_CODE.."-%s".."|r", result);
  end
end

function Currency:Update(data, refreshSettings)
  local money = GetMoney();
  local currentCurrency = self:GetFormattedCurrency(money, nil, true);
  local coloredKey = tk.Strings:SetTextColorByClass(tk:GetPlayerKey());

  self.Button:SetText(currentCurrency);
  db:SetPathValue(db.global, ("datatext.currency.characters.%s"):format(coloredKey), money);

  if (refreshSettings) then
    data.settings:Refresh();
  end
end

function Currency:GetLabel(data, index, btnEnabled)
  local label = self.MenuLabels[index];

  if (label) then
    SetLabelEnabled(label, btnEnabled);
    return label;
  end

  label = tk:PopFrame("Button", self.MenuContent);
  label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  label.name:SetPoint("LEFT", 6, 0);
  label.name:SetWidth(data.settings.popup.width - 10);
  label.name:SetWordWrap(false);
  label.name:SetJustifyH("LEFT");

  label:SetScript("OnClick", function()
    data.slideController:Start(data.slideController.Static.FORCE_RETRACT);
    if (label.isResetAll) then
      tk:ShowConfirmPopup(L["Reset All Characters"], L["Are you sure you want to reset the currency data for all of your characters?"], function()
        db.global.datatext.currency.characters = {};
        self:Update(true);
        tk:Print(L["All currency data has been reset."]);
      end);

      return;
    end

    local characterName = (label.dbKey);
    local currentCharacterName = tk.Strings:SetTextColorByClass(tk:GetPlayerKey());
    local message = L["Are you sure you want to reset the currency data for %s?"]:format(characterName);
    local confirmMessage = L["Currency data for %s has been reset."]:format(characterName);

    if (characterName == currentCharacterName) then
      tk:ShowConfirmPopup(message, nil, function()
        db:SetPathValue(db.profile, "datatext.currency.todayCurrency", GetMoney());
        self:Update(true);
        tk:Print(confirmMessage);
      end);

      return;
    end

    tk:ShowConfirmPopup(message, nil, function()
      db.global.datatext.currency.characters[characterName] = nil;
      self:Update(true);
      tk:Print(confirmMessage);
    end);
  end);

  self.MenuLabels[index] = label;
  SetLabelEnabled(label, btnEnabled);
  return label;
end

function Currency:HandleLeftClick(data)
  self.MenuLabels = self.MenuLabels or obj:PopTable();

  -- Update these 2 info values (check __Construct for a better understanding of what these are!)
  data.info[2] = self:GetFormattedCurrency(_G.GetMoney());
  data.info[6] = self:GetTodaysProfit();

  local r, g, b = tk:GetThemeColor();
  local totalLabelsShown;

  for id, infoName in ipairs(data.info) do
    local label = self:GetLabel(id, false);
    label.name:SetText(infoName); -- defined in __Construct

    if (id % 2 == 1) then
      -- alternating colors for rows
      label:SetNormalTexture(1);
      label:GetNormalTexture():SetColorTexture(r * 0.4, g * 0.4, b * 0.4, 0.2);
    end

    totalLabelsShown = id;
  end

  for characterName, value in db.global.datatext.currency.characters:Iterate() do
    -- The character's name
    totalLabelsShown = totalLabelsShown + 1;
    local nameLabel = self:GetLabel(totalLabelsShown, false);
    nameLabel:SetNormalTexture(1);
    nameLabel:GetNormalTexture():SetColorTexture(0.2, 0.2, 0.2, 0.2);

    if (data.settings.showRealm) then
      nameLabel.name:SetText(characterName);
    else
      local name = strsplit("-", characterName);
      nameLabel.name:SetText(name);
    end

    -- The character's currency
    totalLabelsShown = totalLabelsShown + 1;
    local moneyLabel = self:GetLabel(totalLabelsShown, false);
    moneyLabel:SetNormalTexture(1);
    moneyLabel:GetNormalTexture():SetColorTexture(0, 0, 0, 0.2);
    moneyLabel.name:SetText(self:GetFormattedCurrency(value));
  end

  return totalLabelsShown;
end

function Currency:HandleRightClick(data)
  self.MenuLabels = self.MenuLabels or obj:PopTable();

  local r, g, b = tk:GetThemeColor();
  local title = self:GetLabel(1, false);

  title:SetNormalTexture(1);
  title:GetNormalTexture():SetColorTexture(0, 0, 0, 0.4);
  title.name:SetText(tk.Strings:SetTextColorByRGB(L["Reset Options"], r, g, b));

  local totalLabelsShown = 1; -- start at 1 because the title label was added

  for characterName, _ in db.global.datatext.currency.characters:Iterate() do
    totalLabelsShown = totalLabelsShown + 1;
    local label = self:GetLabel(totalLabelsShown, true);
    label.dbKey = characterName;
    label.isResetAll = nil;

    if (data.settings.showRealm) then
      label.name:SetText(characterName);
    else
      local name = strsplit("-", characterName);
      label.name:SetText(name);
    end
  end

  totalLabelsShown = totalLabelsShown + 1;

  local resetAll = self:GetLabel(totalLabelsShown, true);
  resetAll.name:SetText(tk.Strings:SetTextColorByKey(L["Reset All Characters"], "GOLD"));
  resetAll.dbKey = nil;
  resetAll.isResetAll = true;

  return totalLabelsShown;
end

function Currency:Click(_, button)
  if (button == "LeftButton") then
    self.TotalLabelsShown = self:HandleLeftClick();

  elseif (button == "RightButton") then
    self.TotalLabelsShown = self:HandleRightClick();
  end
end