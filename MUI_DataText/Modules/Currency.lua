-- Setup Namespaces ------------------

local _, Core = ...;

local em = Core.EventManager;
local tk = Core.Toolkit;
local db = Core.Database;
local gui = Core.GUIBuilder;
local L = Core.Locale;

local LABEL_PATTERN = "|cffffffff%s|r";

-- Register and Import Modules -------

local DataText = MayronUI:ImportModule("BottomUI_DataText");
local CurrencyModule, Currency = MayronUI:RegisterModule("DataText_Currency");
local Engine = Core.Objects:Import("MayronUI.Engine");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.currency", {
    enabled = true,
    show_copper = true,
    show_silver = true,
    show_gold = true,
    show_realm = false,
    displayOrder = 7
});

-- Local Functions ----------------

local function CreateLabel(contentFrame)
    local label = tk:PopFrame("Frame", contentFrame);
    label.value = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.value:SetPoint("LEFT", 6, 0);
    label.value:SetWidth(DataText.sv.menu_width); -- TODO needs to be removed
    label.value:SetWordWrap(false);
    label.value:SetJustifyH("LEFT");
    label.bg = tk:SetBackground(label, 0, 0, 0, 0.2);
    return label;
end

-- Currency Module ----------------

CurrencyModule:OnInitialize(function(self, data) 
    data.sv = db.profile.datatext.currency;

    local coloredKey = tk:GetClassColoredText(nil, tk:GetPlayerKey());
    
    -- saves info on the currency that each logged in character has
    if (not db:ParsePathValue("global.datatext.currency.characters")) then
        db:SetPathValue("global.datatext.currency.characters", {});
    end
    
	-- store character's money to be seen by other characters
    db.global.datatext.money.characters[coloredKey] = GetMoney();

    if (data.sv.enabled) then
        --DataText:RegisterDataItem(self);
    end
end);

CurrencyModule:OnEnable(function(self, data, btn)
    data.btn = btn;    
    data.goldString = "|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t";
    data.silverString = "|TInterface\\MoneyFrame\\UI-SilverIcon:14:14:2:0|t";
    data.copperString = "|TInterface\\MoneyFrame\\UI-CopperIcon:14:14:2:0|t";
    data.showMenu = true;

    local date = C_Calendar.GetDate();
    local month = date["month"];
    local day = date["monthDay"];

    date = tk.string.format("%d-%d", day, month);

    if (not (data.sv.date and data.sv.date == date)) then
        data.sv.todayCurrency = GetMoney();
        data.sv.date = date;
    end

    em:CreateEventHandler("PLAYER_MONEY", function()
        if (not data.btn) then 
            return; 
        end

        self:Update();
    end):SetKey("money");

    data.info = {};
    data.info[1] = tk:GetThemeColoredText(L["Current Money"]..":");
    data.info[2] = nil;
    data.info[3] = tk:GetThemeColoredText(L["Start of the day"]..":");
    data.info[4] = nil;
    data.info[6] = self:GetFormattedCurrency(data.sv.todayCurrency);
    data.info[7] = tk:GetThemeColoredText(L["Today's profit"]..":");
    data.info[8] = nil;
    data.info[9] = NORMAL_FONT_COLOR_CODE..L["Money per character"]..":".."|r";        
end);

CurrencyModule:OnDisable(function(self, data) 
    em:FindHandlerByKey("PLAYER_MONEY", "money"):Destroy();
    data.showMenu = nil;
end);

-- Currency Object -----------------------------

Engine:DefineParams("number", "?string", "?boolean")
function Currency:GetFormattedCurrency(data, currency, colorCode, hasLabel)
    local text = "";  
    local gold = tk.math.floor(tk.math.abs(currency / 10000));
    local silver = tk.math.floor(tk.math.abs((currency / 100) % 100));
    local copper = tk.math.floor(tk.math.abs(currency % 100));

    colorCode = colorCode or "|cffffffff";

    if (gold > 0 and (not hasLabel or data.sv.show_gold)) then
        if (tk.tonumber(gold) > 1000) then
            gold = tk.string.gsub(gold, "^(-?%d+)(%d%d%d)", '%1,%2')
        end

        text = tk.string.format("%s %s%s|r%s", text, colorCode, gold, data.goldString);
    end

    if (silver > 0 and (not hasLabel or data.sv.show_silver)) then
        text = tk.string.format("%s %s%s|r%s", text, colorCode, silver, data.silverString);
    end

    if (copper > 0 and (not hasLabel or data.sv.show_copper)) then
        text = tk.string.format("%s %s%s|r%s", text, colorCode, copper, data.copperString);
    end

    if (text == "") then
        if (data.sv.show_gold or not hasLabel) then
            text = tk.string.format("%d%s", 0, data.goldString);
        end

        if (data.sv.show_silver or not hasLabel) then
            text = tk.string.format("%s %d%s", text, 0, data.silverString);
        end

        if (data.sv.show_copper or not hasLabel) then
            text = tk.string.format("%s %d%s", text, 0, data.copperString);
        end
    end

    return tk.string.format(LABEL_PATTERN, text:trim());
end

function Currency:GetDifference(data)
    local currency = GetMoney() - data.sv.todayCurrency;

    if (currency >= 0) then
        return self:GetFormattedCurrency(currency, GREEN_FONT_COLOR_CODE);

    elseif (currency < 0) then
        currency = tk.math.abs(currency);
        local result = self:GetFormattedCurrency(currency, RED_FONT_COLOR_CODE);

        return tk.string.format(RED_FONT_COLOR_CODE.."-%s".."|r", result);
    end
end

function Currency:Update(data)
    local currentCurrency = self:GetFormattedCurrency(GetMoney(), nil, true);

    data.btn:SetText();
    local colored_key = tk:GetClassColoredText(nil, tk:GetPlayerKey());
    db.global.datatext.money.characters[colored_key] = GetMoney();
end


function Currency:Click(data)
    data.content.labels = data.content.labels or {};
    data.info[2] = self:GetFormattedCurrency(GetMoney());
    data.info[6] = self:GetDifference();

    local r, g, b = tk:GetThemeColor();
    local id;

    for n, value in tk.ipairs(data.info) do
        data.content.labels[n] = data.content.labels[n] or CreateLabel(data.content);
        data.content.labels[n].value:SetText(value);

        if (n % 2 == 1) then
            self.content.labels[n].bg:SetColorTexture(r * 0.4, g * 0.4, b * 0.4, 0.2);
        end

        id = n + 1;
    end

    local invert = true;
    for character_name, value in db.global.datatext.money.characters:Iterate() do

        data.content.labels[id] = self.content.labels[id] or CreateLabel(data.content);
        local name_label = data.content.labels[id];

        if (data.sv.show_realm) then
            name_label.value:SetText(character_name);
        else
            local name = tk.strsplit("-", character_name);
            name_label.value:SetText(name);
        end

        id = id + 1;

        data.content.labels[id] = data.content.labels[id] or CreateLabel(data.content);
        local money_label = data.content.labels[id];
        money_label.value:SetText(data:GetFormattedCurrency(value));

        id = id + 1;

        if (invert) then
            name_label.bg:SetColorTexture(0.2, 0.2, 0.2, 0.2);
            money_label.bg:SetColorTexture(0.2, 0.2, 0.2, 0.2);
        else
            name_label.bg:SetColorTexture(0, 0, 0, 0.2);
            money_label.bg:SetColorTexture(0, 0, 0, 0.2);
        end

        invert = not invert;
    end

    return DataText:PositionLabels(data.content);
end

function Currency:HasMenu()
    return true;
end

Engine:DefineReturns("Button");
function Currency:GetButton(data)
    return data.btn;
end