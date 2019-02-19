local _, namespace = ...;
local _G, MayronUI = _G, _G.MayronUI;

-- luacheck: ignore MayronUI self 143 631
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents();
local ComponentsPackage = namespace.ComponentsPackage;
local LABEL_PATTERN = "|cffffffff%s|r";

local tonumber, string, math = _G.tonumber, _G.string, _G.math;
local GetMoney, ipairs, strsplit = _G.GetMoney, _G.ipairs, _G.strsplit;

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

local function CreateLabel(content, popupWidth)
    local label = tk:PopFrame("Frame", content);

    label.value = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.value:SetPoint("LEFT", 6, 0);
    label.value:SetWidth(popupWidth);
    label.value:SetWordWrap(false);
    label.value:SetJustifyH("LEFT");

    label.bg = tk:SetBackground(label, 0, 0, 0, 0.2);
    return label;
end

-- Currency Module ----------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
    local coloredKey = tk.Strings:SetTextColorByClass(tk:GetPlayerKey());

    -- saves info on the currency that each logged in character has
    if (not db:ParsePathValue(db.global, "datatext.currency.characters")) then
        db:SetPathValue(db.global, "datatext.currency.characters", obj:PopTable());
    end

    -- store character's money to be seen by other characters
    db.global.datatext.currency.characters[coloredKey] = _G.GetMoney();

    self:RegisterDataModule("currency", Currency);
end);

function Currency:__Construct(data, settings, dataTextModule)
    data.settings = settings;

    -- set public instance properties
    self.MenuContent = _G.CreateFrame("Frame");
    self.MenuLabels = obj:PopTable();
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = true;
    self.HasRightMenu = false;
    self.Button = dataTextModule:CreateDataTextButton();

    data.goldString = "|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t";
    data.silverString = "|TInterface\\MoneyFrame\\UI-SilverIcon:14:14:2:0|t";
    data.copperString = "|TInterface\\MoneyFrame\\UI-CopperIcon:14:14:2:0|t";
    data.showMenu = true;

    local calendarDate = _G.C_Calendar.GetDate();
    local month = calendarDate["month"];
    local day = calendarDate["monthDay"];

    calendarDate = string.format("%d-%d", day, month);

    if (not (data.settings.date and data.settings.date == calendarDate)) then
        data.settings.todayCurrency = _G.GetMoney();
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
    if (refreshSettings) then
        data.settings:Refresh();
    end

    local currentCurrency = self:GetFormattedCurrency(GetMoney(), nil, true);

    self.Button:SetText(currentCurrency);
    local coloredKey = tk.Strings:SetTextColorByClass(tk:GetPlayerKey());
    db.global.datatext.currency.characters[coloredKey] = GetMoney();
end

function Currency:Click(data)
    self.MenuLabels = self.MenuLabels or obj:PopTable();
    data.info[2] = self:GetFormattedCurrency(_G.GetMoney());
    data.info[6] = self:GetTodaysProfit();

    local r, g, b = tk:GetThemeColor();
    local popupWidth = data.settings.popup.width;
    local totalLabelsShown = 0;

    for id, value in ipairs(data.info) do
        self.MenuLabels[id] = self.MenuLabels[id] or CreateLabel(self.MenuContent, popupWidth);
        self.MenuLabels[id].value:SetText(value);

        if (id % 2 == 1) then
            -- alternating colors for rows
            self.MenuLabels[id].bg:SetColorTexture(r * 0.4, g * 0.4, b * 0.4, 0.2);
        end

        totalLabelsShown = id;
    end

    for characterName, value in db.global.datatext.currency.characters:Iterate() do
        totalLabelsShown = totalLabelsShown + 1;
        local nameLabel = self.MenuLabels[totalLabelsShown] or CreateLabel(self.MenuContent, popupWidth);
        self.MenuLabels[totalLabelsShown] = nameLabel;

        if (data.settings.showRealm) then
            nameLabel.value:SetText(characterName);
        else
            local name = strsplit("-", characterName);
            nameLabel.value:SetText(name);
        end

        totalLabelsShown = totalLabelsShown + 1;

        local moneyLabel = self.MenuLabels[totalLabelsShown] or CreateLabel(self.MenuContent, popupWidth);
        self.MenuLabels[totalLabelsShown] = moneyLabel;

        moneyLabel.value:SetText(self:GetFormattedCurrency(value));
        nameLabel.bg:SetColorTexture(0.2, 0.2, 0.2, 0.2);
        moneyLabel.bg:SetColorTexture(0, 0, 0, 0.2);
    end

    self.TotalLabelsShown = totalLabelsShown;
end