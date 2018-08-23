local _, core = ...;
core.Toolkit = core.Toolkit or {};

local tk = core.Toolkit;

function tk:Select(startIndex, endIndex, ...)
    local values = {select(startIndex, ...)};
    local maxSize = endIndex - startIndex;

    if (#values <= maxSize) then
        return unpack(values);
    end

    for i = endIndex, #values do
        values[i] = nil;
    end

    return unpack(values);
end

function tk:Print(...)
    local hex = tk.select(4, self:GetThemeColor());
    local prefix = self:GetHexColoredText("MayronUI:", hex);
    DEFAULT_CHAT_FRAME:AddMessage(tk.string.join(" ", prefix, tk.tostringall(...)));
end

do
    local modKeys = {
        S = function() return IsShiftKeyDown(); end,
        C = function() return IsControlKeyDown(); end,
        A = function() return IsAltKeyDown(); end,
    };

    function tk:IsModComboActive(strKey) -- "SC" - is shift and control down but not alt? (example)
        local checked = {S = false, C = false, A = false};
        for i = 1, #strKey do
            local modCode = strKey:sub(i,i)
            modCode = tk.string.upper(modCode);

            checked[modCode] = true;

            if (not modKeys[modCode]()) then
                return false;
            end
        end

        for key, value in tk.pairs(checked) do
            if (not value and modKeys[key]()) then
                return false;
            end
        end

        return strKey ~= "";
    end
end

function tk:GetDifficultyColor(level)
    local difference = (level - UnitLevel("player"));
    local color;

    if (difference >= 5) then
        color = QuestDifficultyColors["impossible"];

    elseif (difference >= 3) then
        color = QuestDifficultyColors["verydifficult"];

    elseif (difference >= -2 or level < 0) then
        color = QuestDifficultyColors["difficult"];

    elseif (-difference <= GetQuestGreenRange()) then
        color = QuestDifficultyColors["standard"];

    else
        color = QuestDifficultyColors["trivial"];

    end

    return color;
end

function tk:Equals(value1, value2)
    local type1 = tk.type(value1);

    if (tk.type(value2) == type1) then

        if (type1 == "table") then
            for id, value in pairs(value1) do
                if (not self:Equals(value, value2[id])) then
                    return false;
                end
            end

            return true;
        elseif (type1 == "function") then
            return true; -- ignore functions
        else
            return value1 == value2;
        end        
    end

    return false;
end

function tk:GetPlayerKey()
    local key, realm = UnitName("player"), GetRealmName():gsub("%s+", "");
    key = realm and tk.string.join("-", key, realm);
    return key;
end

function tk:IsPlayerMaxLevel()
    local lvl = UnitLevel("player");

    if (IsTrialAccount()) then
        return (lvl == 20);
    else
        local id = GetAccountExpansionLevel();

        if (id == 0) then
            return (lvl == 60);

        elseif (id == 1) then
            return (lvl == 70);

        elseif (id == 2) then
            return (lvl == 80);

        elseif (id == 3) then
            return (lvl == 85);

        elseif (id == 4) then
            return (lvl == 90);

        elseif (id == 5) then
            return (lvl == 100);

        elseif (id == 6) then
            return (lvl == 110);

        elseif (id == 7) then
            return (lvl == 120);
        end
    end
end

