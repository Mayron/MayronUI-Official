
-- luacheck: ignore MayronUI self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents();

local string, math = _G.string, _G.math;
local GetMoney, ipairs, strsplit = _G.GetMoney, _G.ipairs, _G.strsplit;
local GameTooltip = _G.GameTooltip;
local C_Calendar, C_DateAndTime = _G.C_Calendar, _G.C_DateAndTime;

-- Objects ---------------------------
local Money = obj:CreateClass("Money");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.money", { showRealm = false; });

-- Local Functions ----------------

---@param enabled boolean
local function SetLabelEnabled(label, enabled)
  if (not enabled) then
    label:SetNormalTexture(1);
    label:GetNormalTexture():SetColorTexture(0, 0, 0, 0.4);
    label:SetHighlightTexture("");
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

-- Money Module ----------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
  local coloredKey = tk.Strings:SetTextColorByClassFileName(tk:GetPlayerKey());

  -- TODO: Refactor this to use only a path address
  -- saves info on the money that each logged in character has
  if (not db:ParsePathValue(db.global, "datatext.money.characters")) then
    db:SetPathValue(db.profile, "datatext.money.todayMoney", GetMoney());
    db:SetPathValue(db.global, "datatext.money.characters", obj:PopTable());
  end

  -- store character's money to be seen by other characters
  db.global.datatext.money.characters[coloredKey] = GetMoney();

  self:RegisterComponentClass("money", Money);
end);

function Money:__Construct(data, settings, dataTextModule, slideController)
  data.settings = settings;
  data.slideController = slideController;

  -- set public instance properties
  self.MenuContent = tk:CreateFrame("Frame");
  self.MenuLabels = obj:PopTable();
  self.TotalLabelsShown = 0;
  self.HasLeftMenu = true;
  self.HasRightMenu = true;
  self.Button = dataTextModule:CreateDataTextButton();
  self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");

  data.showMenu = true;

  local calendarDate;

  if (C_DateAndTime and C_DateAndTime.GetTodaysDate) then
    -- classic uses this
    calendarDate = C_DateAndTime:GetTodaysDate();

  elseif (C_DateAndTime and C_DateAndTime.GetCurrentCalendarTime) then
    -- retail uses this
    calendarDate = C_DateAndTime:GetCurrentCalendarTime();

  elseif (C_Calendar and C_Calendar.GetDate) then
    -- old version (shouldn't work)
    calendarDate = C_Calendar:GetDate();
  else
    obj:Error("Failed to call calendar API");
  end

  local month = calendarDate["month"];
  local day = calendarDate["monthDay"] or calendarDate["day"];
  local date = string.format("%d-%d", day, month);

  if (not (data.settings.date and data.settings.date == date)) then
    data.settings.todayMoney = GetMoney();
    data.settings.date = date;
    data.settings:SaveChanges();
  end

  data.info = obj:PopTable();
  data.info[1] = tk.Strings:SetTextColorByTheme(L["Current Money"]..":");
  data.info[2] = nil; -- value of current money
  data.info[3] = tk.Strings:SetTextColorByTheme(L["Start of the day"]..":");
  data.info[4] = tk.Strings:GetFormattedCurrency(data.settings.todayMoney);
  data.info[5] = tk.Strings:SetTextColorByTheme(L["Today's profit"]..":");
  data.info[6] = nil; -- value of today's profile

  local moneyPerCharacterText = tk.Strings:SetTextColorByKey(L["Money per character"]..":", "GOLD");
  data.info[7] = moneyPerCharacterText;
end

function Money:IsEnabled(data)
  return data.enabled;
end

function Money:SetEnabled(data, enabled)
  data.enabled = enabled;

  local listenerID = "DataText_Money_Changed";
  if (enabled) then
    self.Button:SetScript("OnEnter", Button_OnEnter);
    self.Button:SetScript("OnLeave", Button_OnLeave);

    if (not em:GetEventListenerByID(listenerID)) then
      local listener = em:CreateEventListenerWithID(listenerID, function()
        if (not self.Button) then return end
        self:Update();
      end);

      listener:RegisterEvent("PLAYER_MONEY");
    else
      em:EnableEventListeners(listenerID);
    end
  else
    em:DisableEventListeners(listenerID);
    data.showMenu = nil;
  end
end

local function GetTodaysProfit(todayMoney)
  local money = GetMoney() - todayMoney;

  if (money >= 0) then
    return tk.Strings:GetFormattedCurrency(money,  "GREEN");

  elseif (money < 0) then
    money = "-"..tostring(math.abs(money));
    return tk.Strings:GetFormattedCurrency(money, "RED");
  end
end

function Money:Update(data, refreshSettings)
  if (refreshSettings) then
    data.settings:Refresh();
  end

  local money = GetMoney();
  local currentMoney = tk.Strings:GetFormattedCurrency(money);
  local coloredKey = tk.Strings:SetTextColorByClassFileName(tk:GetPlayerKey());

  self.Button:SetText(currentMoney);
  db:SetPathValue(db.global, ("datatext.money.characters.%s"):format(coloredKey), money);
end

function Money:GetLabel(data, index, btnEnabled)
  local label = self.MenuLabels[index];

  if (label) then
    SetLabelEnabled(label, btnEnabled);
    return label;
  end

  label = tk:CreateFrame("Button", self.MenuContent);
  label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  label.name:SetPoint("LEFT", 6, 0);
  label.name:SetWidth(data.settings.popup.width - 10);
  label.name:SetWordWrap(false);
  label.name:SetJustifyH("LEFT");

  label:SetScript("OnClick", function()
    data.slideController:Start(data.slideController.Static.FORCE_RETRACT);
    if (label.isResetAll) then
      local message = L["Reset All Characters"];
      local subMessage = L["Are you sure you want to reset the money data for all of your characters?"];

      local function onConfirm()
        db.global.datatext.money.characters = {};
        self:Update(true);
        tk:Print(L["All money data has been reset."]);
      end;

      tk:ShowConfirmPopup(message, subMessage, nil, onConfirm);
      return
    end

    local characterName = (label.dbKey);
    local currentCharacterName = tk.Strings:SetTextColorByClassFileName(tk:GetPlayerKey());
    local message = L["Are you sure you want to reset the money data for %s?"]:format(characterName);
    local confirmMessage = L["Money data for %s has been reset."]:format(characterName);

    if (characterName == currentCharacterName) then
      tk:ShowConfirmPopup(message, nil, nil, function()
        db:SetPathValue(db.profile, "datatext.money.todayMoney", GetMoney());
        self:Update(true);
        tk:Print(confirmMessage);
      end);

      return
    end

    tk:ShowConfirmPopup(message, nil, nil, function()
      db.global.datatext.money.characters[characterName] = nil;
      self:Update(true);
      tk:Print(confirmMessage);
    end);
  end);

  self.MenuLabels[index] = label;
  SetLabelEnabled(label, btnEnabled);
  return label;
end

function Money:HandleLeftClick(data)
  self.MenuLabels = self.MenuLabels or obj:PopTable();

  -- Update these 2 info values (check __Construct for a better understanding of what these are!)
  data.info[2] = tk.Strings:GetFormattedCurrency(GetMoney());
  data.info[6] = GetTodaysProfit(data.settings.todayMoney);

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

  for characterName, money in db.global.datatext.money.characters:Iterate() do
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

    -- The character's money
    totalLabelsShown = totalLabelsShown + 1;
    local moneyLabel = self:GetLabel(totalLabelsShown, false);
    moneyLabel:SetNormalTexture(1);
    moneyLabel:GetNormalTexture():SetColorTexture(0, 0, 0, 0.2);
    moneyLabel.name:SetText(tk.Strings:GetFormattedCurrency(money));
  end

  return totalLabelsShown;
end

function Money:HandleRightClick(data)
  self.MenuLabels = self.MenuLabels or obj:PopTable();

  local r, g, b = tk:GetThemeColor();
  local title = self:GetLabel(1, false);

  title:SetNormalTexture(1);
  title:GetNormalTexture():SetColorTexture(0, 0, 0, 0.4);
  title.name:SetText(tk.Strings:SetTextColorByRGB(L["Reset Options"], r, g, b));

  local totalLabelsShown = 1; -- start at 1 because the title label was added

  for characterName, _ in db.global.datatext.money.characters:Iterate() do
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

function Money:Click(_, button)
  if (button == "LeftButton") then
    self.TotalLabelsShown = self:HandleLeftClick();

  elseif (button == "RightButton") then
    self.TotalLabelsShown = self:HandleRightClick();
  end
end