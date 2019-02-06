--luacheck: ignore self 143 631
local _G, MayronUI = _G, _G.MayronUI;
local tk, db, em, _, obj = MayronUI:GetCoreComponents();

local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo;
local select, unpack, CreateFrame = _G.select, _G.unpack, _G.CreateFrame;
local string, tonumber, date, pairs, ipairs = _G.string, _G.tonumber, _G.date, _G.pairs, _G.ipairs;
local UnitExists, UnitGUID, UIParent = _G.UnitExists, _G.UnitGUID, _G.UIParent;
local table, tostring, GetTime, UnitAura = _G.table, _G.tostring, _G.GetTime, _G.UnitAura;

local HELPFUL, HARMFUL, DEBUFF, BUFF, REMOVED, UP = "HELPFUL", "HARMFUL", "DEBUFF", "BUFF", "REMOVED", "UP";
local TIMER_FIELD_UPDATE_FREQUENCY = 0.05;
local INVALID_AURA_TYPE = "Invalid aura type '%s'.";
local DEBUFF_MAX_DISPLAY = _G.DEBUFF_MAX_DISPLAY;
local BUFF_MAX_DISPLAY = _G.BUFF_MAX_DISPLAY;
local ICON_GAP = -1;

local SUB_EVENT_NAMES = {
    SPELL_AURA_APPLIED        = "SPELL_AURA_APPLIED";
    SPELL_AURA_APPLIED_DOSE   = "SPELL_AURA_APPLIED_DOSE";
    SPELL_AURA_BROKEN         = "SPELL_AURA_BROKEN";
    SPELL_AURA_BROKEN_SPELL   = "SPELL_AURA_BROKEN_SPELL";
    SPELL_AURA_REFRESH        = "SPELL_AURA_REFRESH";
    SPELL_AURA_REMOVED        = "SPELL_AURA_REMOVED";
    SPELL_AURA_REMOVED_DOSE   = "SPELL_AURA_REMOVED_DOSE";
};

-- Objects -----------------------------

---@type Engine
local Engine = obj:Import("MayronUI.Engine");

---@class ITimerBar : Object
---@field ExpirationTime number @The time when the timer bar expires (in seconds)
---@field IsVisible boolean @Whether the bar is visible and shown in the timer fields frame.
---@field AuraId boolean @The unique aura id used to identify the timer bar.
---@field Positioned boolean @Whether the bar needs to be positioned in the field.

Engine:CreateInterface("ITimerBar", {
    -- fields:
    ExpirationTime = "number";
    IsVisible = "boolean";
    AuraId = "number";
    Positioned = "boolean";
});

---@class TimerBar : ITimerBar
local C_TimerBar = Engine:CreateClass("TimerBar", "Framework.System.FrameWrapper", "ITimerBar");

---@class TimerField : FrameWrapper
local C_TimerField = Engine:CreateClass("TimerField", "Framework.System.FrameWrapper");

---@type Stack
local Stack = obj:Import("Framework.System.Collections.Stack<T>");

---@class TimerBarsModule : BaseModule
local C_TimerBarsModule = MayronUI:RegisterModule("TimerBarsModule", "Timer Bars");
local timerBarsModule = MayronUI:ImportModule("TimerBarsModule");

-- Database Defaults --------------

db:AddToDefaults("profile.timerBars", {
    enabled = true;

    __templateField = {
        enabled               = true;
        direction             = "UP"; -- or "DOWN"
        unitName              = "Player";
        sortByTimeRemaining   = true;
        showTooltips          = true;
        maxBars               = 10;
        barHeight             = 22;
        barWidth              = 213;
        barSpacing            = 2;
        showIcons             = true;
        showSpark             = true;
        statusBarTexture      = "MUI_StatusBar";
        showBorders           = true;
        border                = "Skinner";
        borderSize            = 1;
        colorDebuffsByType    = true;

        auraName = {
            show        = true;
            fontSize    = 11;
            font        = "MUI_Font";
        };

        duration = {
            show        = true;
            fontSize    = 11;
            font        = "MUI_Font";
        };

        filters = {
            onlyPlayerBuffs   = true;
            onlyPlayerDebuffs = true;
            enableWhitelist   = false;
            enableBlacklist   = false;

            whitelist = {

            };
            blacklist = {

            };
        };

        colors = {
            background            = { 0, 0, 0, 0.6 };
            basicBuff             = { 0.1, 0.1, 0.1, 1 };
            basicDebuff           = { 0.76, 0.2, 0.2, 1 };
            border                = { 0.2, 0.2, 0.2, 1 };
            canStealOrPurge       = { 1, 0, 1, 0.4 };
            -- appliedByPlayer    = { 1, 1, 0, 0.4 };
            magic                 = { 0.2, 0.6, 1, 1 };
            disease               = { 0.6, 0.4, 0, 1 };
            poison                = { 0.0, 0.6, 0, 1 };
            curse                 = { 0.6, 0.0, 1, 1 };
        };
    };
});

-- Local Functions -------------------------

local function SortByExpirationTime(a, b)
    return a.ExpirationTime > b.ExpirationTime;
end

local function OnCombatLogEvent()
    local payload = obj:PopTable(CombatLogGetCurrentEventInfo());
    local subEvent = (select(2, unpack(payload)));

    if (SUB_EVENT_NAMES[subEvent]) then
        -- guaranteed to always be the same for all registered events:
        local destGuid = payload[8];
        local auraId = payload[12];
        local auraName = payload[13];
        -- local remainingPoints = (select(16, unpack(payload))); -- test with power shield

        if (subEvent:find(REMOVED)) then
            ---@param field TimerField
            for _, field in pairs(timerBarsModule:GetAllTimerFields()) do
                field:RemoveAuraByID(auraId);
            end
        else
            local currentTime = GetTime();
            local auraType = payload[15];

            if (subEvent == SUB_EVENT_NAMES.SPELL_AURA_BROKEN_SPELL) then
                -- this event has 3 extra args before auraType: extraSpellId, extraSpellName, extraSchool
                auraType = payload[18];
            end

            obj:Assert(auraType == BUFF or auraType == DEBUFF, "Unknown aura type '%s'.", auraType);

            ---@param field TimerField
            for _, field in pairs(timerBarsModule:GetAllTimerFields()) do
                field:UpdateBarsByAura(destGuid, auraId, auraName, auraType, currentTime);
            end
        end
    end
end

local function GetAuraInfo(unitName, auraId, auraName, auraType)
    local auraInfo, maxAuras, filterName;

    if (auraType == DEBUFF) then
        maxAuras, filterName = DEBUFF_MAX_DISPLAY, HARMFUL;
    elseif (auraType == BUFF) then
        maxAuras, filterName = BUFF_MAX_DISPLAY, HELPFUL;
    else
        obj:Error(INVALID_AURA_TYPE, auraType);
    end

    for i = 1, maxAuras do
        auraInfo = obj:PopTable(UnitAura(unitName, i, filterName));

        if (#auraInfo > 0 and auraInfo[1] == auraName and auraInfo[10] == auraId) then
            break;
        end

        obj:PushTable(auraInfo);
        auraInfo = nil;
    end

    return auraInfo;
end

-- C_TimerBarsModule --------------------

function C_TimerBarsModule:OnInitialize(data)
    data.fields = obj:PopTable();

    -- create 2 default (removable from database) TimerFields
	db:AppendOnce(db.profile, "timerBars", {
		fieldNames = {
            "Player";
            "Target";
		};
		Player = {
			position = { "BOTTOMLEFT", "MUI_PlayerName", "TOPLEFT", 10, 2 },
			unitName = "Player";
		};
		Target = {
			position = { "BOTTOMRIGHT", "MUI_TargetName", "TOPRIGHT", -10, 2 };
			unitName = "Target";
		};
    });

    for _, fieldName in db.profile.timerBars.fieldNames:Iterate() do
        local sv = db.profile.timerBars[fieldName];
        sv:SetParent(db.profile.timerBars.__templateField);

        if (sv.enabled) then
            data.fields[fieldName] = true;
        end
    end

    local setupOptions = {


    };

    self:RegisterUpdateFunctions(db.profile.timerBars, {



    }, setupOptions);

end

function C_TimerBarsModule:OnInitialized(data)
    if (data.settings.enabled) then
        self:SetEnabled(true);
    end
end

function C_TimerBarsModule:OnEnable(data)

    -- create all enabled fields
    for fieldName, field in pairs(data.fields) do
        if (obj:IsBoolean(field)) then
            -- create field
            field = C_TimerField(fieldName, data.settings[fieldName]);
            data.fields[fieldName] = field; -- replace "true" with real object
        end

        field:SetEnabled(true);
    end

    -- create event handlers
    em:CreateEventHandlerWithKey("COMBAT_LOG_EVENT_UNFILTERED", "TimerBars_CombatLogHandler", OnCombatLogEvent);
end

Engine:DefineReturns("table");
function C_TimerBarsModule:GetAllTimerFields(data)
    return data.fields;
end

-- C_TimerField ------------------------------

Engine:DefineParams("string", "table");
function C_TimerField:__Construct(data, name, settings)
    data.name = name;
    data.settings = settings;
    data.timeSinceLastUpdate = 0;
    data.activeBars = obj:PopTable();

    ---@type Stack
    data.expiredBarsStack = Stack:Of(C_TimerBar)(); -- this returns a class...

    data.expiredBarsStack:OnNewItem(function(expirationTime, auraId)
        return C_TimerBar(settings, expirationTime, auraId);
    end);

    data.expiredBarsStack:OnPushItem(function(bar)
        bar:Print();
        bar:SetShown(false);
        bar:SetParent(tk.Constants.DUMMY_FRAME);
        bar.IsVisible = false;
    end);

    data.expiredBarsStack:OnPopItem(function(bar)
        bar.Positioned = false;
        table.insert(data.activeBars, bar);
    end);
end

Engine:DefineParams("boolean");
function C_TimerField:SetEnabled(data, enabled)
    data.enabled = enabled;

    if (not enabled and not data.frame) then
        return;
    end

    if (enabled and not data.frame) then
        data.frame = self:CreateField(data.name);
    end

    data.frame:SetShown(enabled);

    if (not enabled) then
        -- disable:
        data.frame:SetAllPoints(tk.Constants.DUMMY_FRAME);
        data.frame:SetParent(tk.Constants.DUMMY_FRAME);
    else
        -- enable:
        self:PositionField();
        self:SetParent(UIParent);
    end
end

Engine:DefineReturns("boolean");
function C_TimerField:IsEnabled(data)
    if (obj:IsNil(data.enabled)) then
        return false;
    end

    return data.enabled;
end

function C_TimerField:PositionField(data)
    data.frame:ClearAllPoints();

    if (obj:IsTable(data.settings.position)) then
        local point, relativeFrame, relativePoint, xOffset, yOffset = unpack(data.settings.position);
        data.frame:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset);
    else
        data.frame:SetPoint("CENTER");
    end
end

Engine:DefineParams("string");
Engine:DefineReturns("Frame");
---@param name string @The name of the field to create (used as a substring in global frame name)
---@return Frame @Returns the created field (a Frame widget)
function C_TimerField:CreateField(data, name)
    local globalName = tk.Strings:Concat("MUI_", name, "TimerField");
    local frame = CreateFrame("Frame", globalName);

    local fieldHeight = (data.settings.maxBars * (data.settings.barHeight + data.settings.barSpacing)) - data.settings.barSpacing;
    frame:SetSize(data.settings.barWidth, fieldHeight);

	frame:SetScript("OnUpdate", function(_, elapsed)
		data.timeSinceLastUpdate = data.timeSinceLastUpdate + elapsed;

        if (data.timeSinceLastUpdate > TIMER_FIELD_UPDATE_FREQUENCY) then
            local currentTime = GetTime();
            local sortedBars = obj:PopTable();

            -- update bars:
            for _, activeBar in ipairs(data.activeBars) do
                if (activeBar.ExpirationTime < currentTime) then
                    data.expiredBarsStack:Push(activeBar);
                else
                    table.insert(sortedBars, activeBar);
                end
            end

            table.sort(data.activeBars, SortByExpirationTime);

            local changed = false;

            for id = 1, data.settings.maxBars do
                if (sortedBars[id]) then
                    if (not (sortedBars[id].Positioned and tostring(sortedBars[id]) == tostring(data.activeBars[id]))) then
                        changed = true;
                        break;
                    end
                end
            end

            obj:PushTable(data.activeBars);
            data.activeBars = sortedBars;

            ---@param activeBar TimerBar
            for i, activeBar in ipairs(data.activeBars) do
                if (i <= data.settings.maxBars and not activeBar.IsVisible) then
                    -- make visible
                    activeBar:SetShown(true);
                    activeBar:SetParent(data.frame);
                    activeBar.IsVisible = true;
                    changed = true;
                elseif (i > data.settings.maxBars and activeBar.IsVisible) then
                    -- make invisible
                    activeBar:SetShown(false);
                    activeBar:SetParent(tk.Constants.DUMMY_FRAME);
                    activeBar.IsVisible = false;
                    changed = true;
                end

                if (i <= data.settings.maxBars) then
                    activeBar:UpdateDuration(activeBar.ExpirationTime - currentTime);
                end
            end

            if (changed) then
                self:RepositionBars();
            end

            data.timeSinceLastUpdate = 0;
        end
	end);

    return frame;
end

function C_TimerField:RepositionBars(data)
    local p = tk.Constants.POINTS;
    local activeBar;

    for id = 1, data.settings.maxBars do
        activeBar = data.activeBars[id];

        if (activeBar) then
            activeBar:ClearAllPoints();

            if (data.settings.direction == UP) then
                if (id > 1) then
                    activeBar:SetPoint(p.BOTTOMLEFT, data.activeBars[id - 1], p.TOPLEFT, 0, data.settings.barSpacing);
                    activeBar:SetPoint(p.BOTTOMRIGHT, data.activeBars[id - 1], p.TOPRIGHT, 0, data.settings.barSpacing);
                else
                    activeBar:SetPoint(p.BOTTOMRIGHT, data.frame, p.BOTTOMRIGHT, 0, 0);
                end
            else
                if (id > 1) then
                    activeBar:SetPoint(p.TOPLEFT, data.activeBars[id - 1], p.BOTTOMLEFT, 0, -data.settings.barSpacing);
                    activeBar:SetPoint(p.TOPRIGHT, data.activeBars[id - 1], p.BOTTOMRIGHT, 0, -data.settings.barSpacing);
                else
                    activeBar:SetPoint(p.TOPLEFT, data.frame, p.BOTTOMLEFT, 0, 0);
                    activeBar:SetPoint(p.TOPRIGHT, data.frame, p.BOTTOMRIGHT, 0, 0);
                end
            end

            activeBar.Positioned = true;
        end
    end
end

Engine:DefineParams("number");
function C_TimerField:RemoveAuraByID(data, auraId)
    for _, activeBar in ipairs(data.activeBars) do
        if (auraId == activeBar.AuraId) then
            activeBar.ExpirationTime = -1; -- let OnUpdate remove it
        end
    end
end

Engine:DefineParams("string", "number", "string", "string", "number");
function C_TimerField:UpdateBarsByAura(data, unitGuid, auraId, auraName, auraType, currentTime)
    if (not (UnitExists(data.settings.unitName) and UnitGUID(data.settings.unitName) == unitGuid)) then
        return; -- field cannot handle this aura
    end

    -- TODO: Need to apply filters here
    ---@type TimerBar
    local foundBar;
    local auraInfo;

    auraInfo = GetAuraInfo(data.settings.unitName, auraId, auraName, auraType);

    -- first try to search for an existing one:
    for _, activeBar in ipairs(data.activeBars) do
        if (auraId == activeBar.AuraId) then
            foundBar = activeBar;
            break;
        end
    end

    if (not obj:IsTable(auraInfo) and foundBar) then
        obj:Error("Found a bar but no auraInfo???");
    end

    if (not obj:IsTable(auraInfo)) then
        return; -- no aura found on unit and no bar tracking it
    end

    if (not foundBar) then
        -- create a new timer bar
        local expirationTime = auraInfo[6];
        foundBar = data.expiredBarsStack:Pop(expirationTime, auraId);
    end

    -- TODO: Should I check if bar is expired here as well?
    foundBar:UpdateAura(auraInfo, currentTime, auraType);
end

-- C_TimerBar ---------------------------

Engine:DefineParams("table", "number");
function C_TimerBar:__Construct(data, settings, expirationTime, auraId)

    -- fields
    self.ExpirationTime = expirationTime;
    self.IsVisible = false; -- let OnUpdate parent and position it
    self.AuraId = auraId;
    self.Positioned = false;

    data.settings = settings;

    data.frame = CreateFrame("Frame");
    data.frame:SetSize(settings.barWidth, settings.barHeight);

    data.slider = CreateFrame("StatusBar", nil, data.frame);
    data.slider:SetStatusBarTexture(tk.Constants.LSM:Fetch("statusbar", settings.statusBarTexture));
    data.slider.bg = tk:SetBackground(data.slider, unpack(settings.colors.background));

    self:SetIconShown(settings.showIcons);
    self:SetBorderShown(settings.showBorders);
    self:SetSparkShown(settings.showSpark);
    self:SetAuraNameShown(settings.auraName.show);
    self:SetDurationShown(settings.duration.show);
    self:SetTooltipsEnabled(data.settings.showTooltips);
end

function C_TimerBar:SetIconShown(data, shown)
    if (not data.iconFrame and shown) then
        data.iconFrame = CreateFrame("Frame", nil, data.frame);
        data.iconFrame:SetWidth(data.settings.barHeight);

        data.icon = data.iconFrame:CreateTexture(nil, "ARTWORK");
        data.icon:SetTexCoord(0.1, 0.92, 0.08, 0.92);
    end

    if (data.iconFrame) then
        data.iconFrame:SetShown(shown);

        if (shown) then
            local barWidthWithIcon = data.settings.barWidth - data.settings.barHeight - ICON_GAP;
            data.frame:SetWidth(barWidthWithIcon);
        else
            data.frame:SetSize(data.settings.barWidth);
        end
    end
end

do
    local function SetWidgetBorderSize(widget, borderSize)
        widget:ClearAllPoints();
        widget:SetPoint("TOPLEFT", borderSize, -borderSize);
        widget:SetPoint("TOPRIGHT", -borderSize, -borderSize);
        widget:SetPoint("BOTTOMLEFT", borderSize, borderSize);
        widget:SetPoint("BOTTOMRIGHT", -borderSize, borderSize);
    end

    function C_TimerBar:SetBorderShown(data, shown)
        if (not data.backdrop and shown) then
            data.backdrop = obj:PopTable();
            data.backdrop.edgeFile = tk.Constants.LSM:Fetch("border", data.settings.border);
            data.backdrop.edgeSize = data.settings.borderSize;
        end

        local borderSize = 0;

        if (shown) then
            borderSize = data.settings.borderSize;
            data.frame:SetBackdrop(data.backdrop);
            data.frame:SetBackdropBorderColor(unpack(data.settings.colors.border));

            if (data.iconFrame) then
                data.iconFrame:SetBackdrop(data.backdrop);
                data.iconFrame:SetBackdropBorderColor(unpack(data.settings.colors.border));
            end
        else
            data.frame:SetBackdrop(nil);
            data.iconFrame:SetBackdrop(nil);
        end

        SetWidgetBorderSize(data.slider, borderSize);

        if (data.iconFrame and data.settings.showIcons) then
            data.iconFrame:SetPoint("TOPRIGHT", data.frame, "TOPLEFT", -(borderSize * 2) - ICON_GAP, 0);
            data.iconFrame:SetPoint("BOTTOMRIGHT", data.frame, "BOTTOMLEFT", -(borderSize * 2) - ICON_GAP, 0);
            SetWidgetBorderSize(data.icon, borderSize);

            local barWidthWithIconAndBorder = data.frame:GetWidth() - (borderSize * 2);
            data.frame:SetWidth(barWidthWithIconAndBorder);
        end
    end
end

function C_TimerBar:SetSparkShown(data, shown)
    if (not data.spark and shown) then
        data.spark = data.slider:CreateTexture(nil, "OVERLAY");
        data.spark:SetWidth(26);
        data.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark");
        data.spark:SetVertexColor(1, 1, 1);
        data.spark:SetBlendMode("ADD");
    end

    data.showSpark = shown;
end

function C_TimerBar:SetAuraNameShown(data, shown)
    if (not data.auraName and shown) then
        data.auraName = data.slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
        data.auraName:SetPoint("LEFT", 4, 0);
        data.auraName:SetJustifyH("LEFT");
        data.auraName:SetWordWrap(false);
        data.auraName:SetWidth(data.settings.barWidth - data.settings.barHeight - 50);

        local font = tk.Constants.LSM:Fetch("font", data.settings.auraName.font);
        data.auraName:SetFont(font, data.settings.auraName.fontSize);
    end

    if (data.auraName) then
        data.auraName:SetShown(shown);
    end
end

function C_TimerBar:SetDurationShown(data, shown)
    if (not data.duration and shown) then
        data.duration = data.slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
        data.duration:SetPoint("RIGHT", -4, 0);

        local font = tk.Constants.LSM:Fetch("font", data.settings.duration.font);
        data.duration:SetFont(font, data.settings.duration.fontSize);
    end

    if (data.duration) then
        data.duration:SetShown(shown);
    end
end

function C_TimerBar:SetTooltipsEnabled(data, enabled)
    if (enabled) then
        tk:SetAuraTooltip(data.frame);
    else
        data.frame:SetScript("OnEnter", tk.Constants.DUMMY_FUNC);
        data.frame:SetScript("OnLeave", tk.Constants.DUMMY_FUNC);
    end
end

Engine:DefineParams("number", "?number");
function C_TimerBar:UpdateDuration(data, timeRemaining, totalDuration)
    obj:Assert(timeRemaining >= 0); -- duration should have been checked in the frame OnUpdate script

    if (totalDuration) then
        -- Called from UpdateAura
        data.slider:SetMinMaxValues(0, totalDuration);
    end

    data.slider:SetValue(timeRemaining);

    if (data.spark and data.spark:IsShown()) then
        local _, max = data.slider:GetMinMaxValues();
        local offset = data.spark:GetWidth() / 2;
        local barWidth = data.slider:GetWidth();
        local value = (timeRemaining / max) * barWidth - offset;

        if (value > barWidth - offset) then
            value = barWidth - offset;
        end

        data.spark:SetPoint("LEFT", value, 0);
    end

    timeRemaining = string.format("%.1f", timeRemaining);

    if (tonumber(timeRemaining) > 3600) then
        timeRemaining = date("%H:%M:%S", timeRemaining);

    elseif (tonumber(timeRemaining) > 60) then
        timeRemaining = date("%M:%S", timeRemaining);
    end

    data.duration:SetText(timeRemaining);
end

Engine:DefineParams("table", "number", "string");
function C_TimerBar:UpdateAura(data, auraInfo, currentTime, auraType)
    local auraName = auraInfo[1];
    local iconPath = auraInfo[2];
    local totalDuration = auraInfo[5];
    local expirationTime = auraInfo[6];

    if (not totalDuration or expirationTime == 0) then
        for i, value in ipairs(auraInfo) do
            MayronUI:Print(i, ": ", value);
        end

        error("Weird bug");
    end

    self.ExpirationTime = expirationTime;
    self:UpdateDuration(expirationTime - currentTime, totalDuration);

    if (data.icon) then
        data.icon:SetTexture(iconPath);
    end

    data.auraName:SetText(auraName);

    if (auraType == BUFF) then
        data.slider:SetStatusBarColor(unpack(data.settings.colors.basicBuff));
    elseif (auraType == DEBUFF) then
        if (data.settings.colorDebuffsByType) then
            local debuffType = string.lower(auraInfo[4]);
            data.slider:SetStatusBarColor(unpack(data.settings.colors[debuffType]));
        else
            data.slider:SetStatusBarColor(unpack(data.settings.colors.basicDebuff));
        end
    end
end

function C_TimerBar:Print(data)
    MayronUI:Print(tostring(data.auraName), tostring(self.ExpirationTime), tostring(GetTime()));
end