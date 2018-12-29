-- luacheck: ignore MayronUI self 143 631

local tk, db, em, _, obj, L = MayronUI:GetCoreComponents();

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local Currency = Engine:CreateClass("Currency", nil, "MayronUI.Engine.IDataTextModule");

local LABEL_PATTERN = "|cffffffff%s|r";

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.currency", {
    enabled = false,

    -- todo: this needs to be more intelligent...
    showCopper = false,
    showSilver = false,
    showGold = true,

    showRealm = false,
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

MayronUI:Hook("DataText", "OnInitialize", function(self)
    local sv = db.profile.datatext.currency;
    sv:SetParent(db.profile.datatext);

    local settings = sv:GetTrackedTable();
    local coloredKey = tk.Strings:SetTextColorByClass(tk:GetPlayerKey());

    -- saves info on the currency that each logged in character has
    if (not db:ParsePathValue(db.global, "datatext.currency.characters")) then
        db:SetPathValue(db.global, "datatext.currency.characters", {});
    end

	-- store character's money to be seen by other characters
    db.global.datatext.currency.characters[coloredKey] = _G.GetMoney();

    if (settings.enabled) then
        local currency = Currency(settings, self);
        self:RegisterDataModule(currency);
    end
end);

function Currency:__Construct(data, settings, dataTextModule)
    data.settings = settings;

    -- set public instance properties
    self.MenuContent = _G.CreateFrame("Frame");
    self.MenuLabels = {};
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = true;
    self.HasRightMenu = false;
    self.Button = dataTextModule:CreateDataTextButton();
    self.SavedVariableName = "currency";

    data.goldString = "|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t";
    data.silverString = "|TInterface\\MoneyFrame\\UI-SilverIcon:14:14:2:0|t";
    data.copperString = "|TInterface\\MoneyFrame\\UI-CopperIcon:14:14:2:0|t";
    data.showMenu = true;

    local date = _G.C_Calendar.GetDate();
    local month = date["month"];
    local day = date["monthDay"];

    date = tk.string.format("%d-%d", day, month);

    if (not (data.settings.date and data.settings.date == date)) then
        data.settings.todayCurrency = _G.GetMoney();
        data.settings.date = date;
        data.settings:SaveChanges();
    end

    em:CreateEventHandler("PLAYER_MONEY", function()
        if (not self.Button) then
            return;
        end

        self:Update();
    end):SetKey("money");

    data.info = {};
    data.info[1] = tk.Strings:SetTextColorByTheme(L["Current Money"]..":");
    data.info[2] = nil;
    data.info[3] = tk.Strings:SetTextColorByTheme(L["Start of the day"]..":");
    data.info[4] = nil;
    data.info[6] = self:GetFormattedCurrency(data.settings.todayCurrency);
    data.info[7] = tk.Strings:SetTextColorByTheme(L["Today's profit"]..":");
    data.info[8] = nil;
    data.info[9] = tk.Strings:Concat(_G.NORMAL_FONT_COLOR_CODE..L["Money per character"], ":", "|r");
end

function Currency:IsEnabled(data)
    return data.settings.enabled;
end

function Currency:Enable(data)
    data.settings.enabled = true;
    data.settings:SaveChanges();
end

function Currency:Disable(data)
    data.settings.enabled = false;
    data.settings:SaveChanges();
    em:FindHandlerByKey("PLAYER_MONEY", "money"):Destroy();
    data.showMenu = nil;
end

Engine:DefineParams("number", "?string", "?boolean")
function Currency:GetFormattedCurrency(data, currency, colorCode, hasLabel)
    local text = "";
    local gold = tk.math.floor(tk.math.abs(currency / 10000));
    local silver = tk.math.floor(tk.math.abs((currency / 100) % 100));
    local copper = tk.math.floor(tk.math.abs(currency % 100));

    colorCode = colorCode or "|cffffffff";

    if (gold > 0 and (not hasLabel or data.settings.showGold)) then
        if (tk.tonumber(gold) > 1000) then
            gold = tk.string.gsub(gold, "^(-?%d+)(%d%d%d)", '%1,%2')
        end

        text = tk.string.format("%s %s%s|r%s", text, colorCode, gold, data.goldString);
    end

    if (silver > 0 and (not hasLabel or data.settings.showSilver)) then
        text = tk.string.format("%s %s%s|r%s", text, colorCode, silver, data.silverString);
    end

    if (copper > 0 and (not hasLabel or data.settings.showCopper)) then
        text = tk.string.format("%s %s%s|r%s", text, colorCode, copper, data.copperString);
    end

    if (text == "") then
        if (data.settings.showGold or not hasLabel) then
            text = tk.string.format("%d%s", 0, data.goldString);
        end

        if (data.settings.showSilver or not hasLabel) then
            text = tk.string.format("%s %d%s", text, 0, data.silverString);
        end

        if (data.settings.showCopper or not hasLabel) then
            text = tk.string.format("%s %d%s", text, 0, data.copperString);
        end
    end

    return tk.string.format(LABEL_PATTERN, text:trim());
end

function Currency:GetDifference(data)
    local currency = _G.GetMoney() - data.settings.todayCurrency;

    if (currency >= 0) then
        return self:GetFormattedCurrency(currency, _G.GREEN_FONT_COLOR_CODE);

    elseif (currency < 0) then
        currency = tk.math.abs(currency);
        local result = self:GetFormattedCurrency(currency, _G.RED_FONT_COLOR_CODE);

        return tk.string.format(_G.RED_FONT_COLOR_CODE.."-%s".."|r", result);
    end
end

function Currency:Update()
    local currentCurrency = self:GetFormattedCurrency(_G.GetMoney(), nil, true);

    self.Button:SetText(currentCurrency);
    local colored_key = tk:SetTextColorByClass(nil, tk:GetPlayerKey());
    db.global.datatext.currency.characters[colored_key] = _G.GetMoney();
end

function Currency:Click(data)
    self.MenuLabels = self.MenuLabels or {};
    data.info[2] = self:GetFormattedCurrency(_G.GetMoney());
    data.info[6] = self:GetDifference();

    local r, g, b = tk:GetThemeColor();
    local popupWidth = data.settings.popup.width;
    local totalLabelsShown = 0;

    -- weird logic
    for id, value in tk.ipairs(data.info) do
        self.MenuLabels[id] = self.MenuLabels[id] or CreateLabel(self.MenuContent, popupWidth);
        self.MenuLabels[id].value:SetText(value);

        if (id % 2 == 1) then
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
            local name = tk.strsplit("-", characterName);
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