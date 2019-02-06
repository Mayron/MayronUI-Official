--luacheck: ignore self 143 631
local _G, MayronUI = _G, _G.MayronUI;
local tk, db, em, _, obj = MayronUI:GetCoreComponents();

local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo;
local unpack, CreateFrame = _G.unpack, _G.CreateFrame;
local string, tonumber, date, pairs, ipairs = _G.string, _G.tonumber, _G.date, _G.pairs, _G.ipairs;
local UnitExists, UnitGUID, UIParent = _G.UnitExists, _G.UnitGUID, _G.UIParent;
local table, GetTime, UnitAura = _G.table, _G.GetTime, _G.UnitAura;

local HELPFUL, HARMFUL, DEBUFF, BUFF, REMOVED, UP = "HELPFUL", "HARMFUL", "DEBUFF", "BUFF", "REMOVED", "UP";
local TIMER_FIELD_UPDATE_FREQUENCY = 0.05;
local UNKNOWN_AURA_TYPE = "Unknown aura type '%s'.";
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
---@field ExpirationTime number @The epoch marking the point in time when the timer bar is set to expire
---@field TimeRemaining number @The actual time remaining in seconds
---@field AuraId boolean @The unique aura id used to identify the timer bar.

Engine:CreateInterface("ITimerBar", {
    -- fields:
    ExpirationTime = "number";
    TimeRemaining = "number";
    AuraId = "number";
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
        colorStealOrPurge     = true;

        auraName = {
            show        = true;
            fontSize    = 11;
            font        = "MUI_Font";
        };

        timeRemaining = {
            show        = true;
            fontSize    = 11;
            font        = "MUI_Font";
        };

        filters = {
            onlyPlayerBuffs   = true;
            onlyPlayerDebuffs = true;
            enableWhiteList   = false;
            enableBlackList   = false;

            whiteList = {

            };
            blackList = {

            };
        };

        colors = {
            background            = { 0, 0, 0, 0.6 };
            basicBuff             = { 0.1, 0.1, 0.1, 1 };
            basicDebuff           = { 0.76, 0.2, 0.2, 1 };
            border                = { 0.2, 0.2, 0.2, 1 };
            canStealOrPurge       = { 1, 0.5, 0.25, 1 };
            magic                 = { 0.2, 0.6, 1, 1 };
            disease               = { 0.6, 0.4, 0, 1 };
            poison                = { 0.0, 0.6, 0, 1 };
            curse                 = { 0.6, 0.0, 1, 1 };
        };
    };
});

-- Combat Log Event Script -------------------

local function OnCombatLogEvent()
    local payload = obj:PopTable(CombatLogGetCurrentEventInfo());
    local subEvent = payload[2];

    if (SUB_EVENT_NAMES[subEvent]) then
        -- guaranteed to always be the same for all registered events:
        local sourceGuid = payload[4];
        local destGuid = payload[8];
        local auraId = payload[12];
        local auraName = payload[13];
        -- local remainingPoints = (select(16, unpack(payload))); -- TODO: test with power shield

        if (subEvent:find(REMOVED)) then
            --@param field TimerField
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

            obj:Assert(auraType == BUFF or auraType == DEBUFF, UNKNOWN_AURA_TYPE, auraType);

            ---@param field TimerField
            for _, field in pairs(timerBarsModule:GetAllTimerFields()) do
                field:UpdateBarsByAura(sourceGuid, destGuid, auraId, auraName, auraType, currentTime);
            end
        end
    end

    obj:PushTable(payload)
end

local function GetAuraInfo(unitName, auraId, auraName, auraType)
    local auraInfo, maxAuras, filterName;

    if (auraType == DEBUFF) then
        maxAuras, filterName = DEBUFF_MAX_DISPLAY, HARMFUL;
    elseif (auraType == BUFF) then
        maxAuras, filterName = BUFF_MAX_DISPLAY, HELPFUL;
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

    -- TODO: Need to add config functions
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
---@return table @A table containing all active TimerField objects.
function C_TimerBarsModule:GetAllTimerFields(data)
    return data.fields;
end

-- C_TimerField ------------------------------

Engine:DefineParams("string", "table");
---@param name string @The name of the field (to be used in the global variable name). Usually it is the same as the unit name being tracked.
function C_TimerField:__Construct(data, name, settings)
    data.name = name;
    data.settings = settings;
    data.timeSinceLastUpdate = 0;
    data.activeBars = obj:PopTable();

    ---@type Stack
    data.expiredBarsStack = Stack:Of(C_TimerBar)(); -- this returns a class...

    data.expiredBarsStack:OnNewItem(function()
        return C_TimerBar(settings);
    end);

    data.expiredBarsStack:OnPushItem(function(bar)
        bar:SetShown(false);
        bar:SetParent(tk.Constants.DUMMY_FRAME);
    end);

    data.expiredBarsStack:OnPopItem(function(bar, auraId)
        bar.AuraId = auraId;
        table.insert(data.activeBars, bar);
    end);
end

Engine:DefineParams("boolean");
---@param enabled boolean @Set to true to enable TimerField tracking.
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
---@return boolean @The enabled state of the TimerField.
function C_TimerField:IsEnabled(data)
    if (obj:IsNil(data.enabled)) then
        return false;
    end

    return data.enabled;
end

---Uses the position config settings to set the field's position on the UIParent.
function C_TimerField:PositionField(data)
    data.frame:ClearAllPoints();

    if (obj:IsTable(data.settings.position)) then
        local point, relativeFrame, relativePoint, xOffset, yOffset = unpack(data.settings.position);
        data.frame:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset);
    else
        data.frame:SetPoint("CENTER");
    end
end

---Rearranges the TimerField active TimerBars after first being sorted by time remaining + bars being removed or added.
local function RepositionBars(data)
    local p = tk.Constants.POINTS;
    local activeBar, previousBarFrame;

    for id = 1, data.settings.maxBars do
        activeBar = data.activeBars[id];

        if (activeBar) then
            activeBar:ClearAllPoints();

            if (data.settings.direction == UP) then
                if (id > 1) then
                    previousBarFrame = data.activeBars[id - 1]:GetFrame();
                    activeBar:SetPoint(p.BOTTOMLEFT, previousBarFrame, p.TOPLEFT, 0, data.settings.barSpacing);
                    activeBar:SetPoint(p.BOTTOMRIGHT, previousBarFrame, p.TOPRIGHT, 0, data.settings.barSpacing);
                else
                    activeBar:SetPoint(p.BOTTOMRIGHT, data.frame, p.BOTTOMRIGHT, 0, 0);
                end
            else
                if (id > 1) then
                    previousBarFrame = data.activeBars[id - 1]:GetFrame();
                    activeBar:SetPoint(p.TOPLEFT, previousBarFrame, p.BOTTOMLEFT, 0, -data.settings.barSpacing);
                    activeBar:SetPoint(p.TOPRIGHT, previousBarFrame, p.BOTTOMRIGHT, 0, -data.settings.barSpacing);
                else
                    activeBar:SetPoint(p.TOPLEFT, data.frame, p.BOTTOMLEFT, 0, 0);
                    activeBar:SetPoint(p.TOPRIGHT, data.frame, p.BOTTOMRIGHT, 0, 0);
                end
            end
        end
    end
end

do
    local function SortByTimeRemaining(a, b)
        return a.TimeRemaining > b.TimeRemaining;
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
                local barRemoved;

                repeat
                    -- Remove expired bars:
                    barRemoved = false;
                    -- cannot use a new activeBars table (by inserting non-expired bars into it and replacing old table)
                    -- because this would reverse the bar order which causes graphical issues if the time remaining of 2 bars is equal.
                    for id, activeBar in ipairs(data.activeBars) do
                        if (activeBar.ExpirationTime < currentTime) then
                            data.expiredBarsStack:Push(activeBar); -- remove bar here!
                            table.remove(data.activeBars, id);
                            barRemoved = true;
                            break;
                        end
                    end

                until (not barRemoved);

                table.sort(data.activeBars, SortByTimeRemaining);

                ---@param bar TimerBar
                for i, bar in ipairs(data.activeBars) do
                    if (i <= data.settings.maxBars) then
                        -- make visible
                        bar:SetShown(true);
                        bar:SetParent(data.frame);
                    else
                        -- make invisible
                        bar:SetShown(false);
                        bar:SetParent(tk.Constants.DUMMY_FRAME);
                    end

                    bar:UpdateTimeRemaining(currentTime);
                end

                RepositionBars(data);
                data.timeSinceLastUpdate = 0;
            end
        end);

        return frame;
    end
end

Engine:DefineParams("number");
---@param auraId number @The aura's unique id used to find and remove the aura.
function C_TimerField:RemoveAuraByID(data, auraId)
    for _, activeBar in ipairs(data.activeBars) do
        if (auraId == activeBar.AuraId) then
            activeBar.ExpirationTime = -1; -- let OnUpdate remove it
        end
    end
end

-- TODO: Is auraName safe (localization issues if always in english?)
local function IsFilteredOut(filters, sourceGuid, destGuid, auraName, auraType)
    local filteredOut = false;

    if (auraType == BUFF and filters.onlyPlayerBuffs and UnitGUID("player") ~= destGuid) then
        filteredOut = true;
    end

    if (auraType == DEBUFF and filters.onlyPlayerDebuffs and UnitGUID("player") ~= sourceGuid) then
        filteredOut = true;
    end

    if (filters.enableWhiteList and not filters.whiteList[auraName]) then
        filteredOut = true;
    end

    if (filters.enableBlackList and filters.blackList[auraName]) then
        filteredOut = true;
    end

    return filteredOut;
end

Engine:DefineParams("string", "string", "number", "string", "string", "number");
---@param sourceGuid string @The globally unique identify (GUID) representing the source of the aura (the creature or player who casted the aura).
---@param sourceGuid string @The globally unique identify (GUID) representing the destination of the aura (the creature or player who gained the aura).
---@param auraId number @The unique id of the aura used to find and update the aura.
---@param auraName number @The name of the aura used for filtering and updating the TimerBar name.
---@param auraType string @The type of aura (must be either "BUFF" or "DEBUFF").
---@param currentTime number @The result of GetTime shared by all timer bars being updated in the same field.
function C_TimerField:UpdateBarsByAura(data, sourceGuid, destGuid, auraId, auraName, auraType, currentTime)
    if (not (UnitExists(data.settings.unitName) and UnitGUID(data.settings.unitName) == destGuid)) then
        return; -- field cannot handle this aura
    end

    if (IsFilteredOut(data.settings.filters, sourceGuid, destGuid, auraName, auraType)) then
        return;
    end

    ---@type TimerBar
    local foundBar;
    local auraInfo = GetAuraInfo(data.settings.unitName, auraId, auraName, auraType);

    if (not obj:IsTable(auraInfo)) then
        -- some aura's do not return aura info from UnitAura (such as Windfury)
        return;
    elseif (not (auraInfo[6] and auraInfo[6] > 0)) then
        -- some aura's do not have an expiration time so cannot be added to a timer bar (aura's that are fixed).
        obj:PushTable(auraInfo);
        return;
    end

    -- first try to search for an existing one:
    for _, activeBar in ipairs(data.activeBars) do
        if (auraId == activeBar.AuraId) then
            foundBar = activeBar;
            break;
        end
    end

    local expirationTime = auraInfo[6];

    if (not foundBar) then
        -- create a new timer bar
        foundBar = data.expiredBarsStack:Pop(auraId);
    end

    -- update expiration time outside of UpdateAura!
    foundBar.ExpirationTime = expirationTime;

    foundBar:UpdateAura(auraInfo, currentTime, auraType);
end

-- C_TimerBar ---------------------------

Engine:DefineParams("table");
---@param settings table @The config settings table.
---@param auraId number @The unique id of the aura used to find and update the aura.
function C_TimerBar:__Construct(data, settings)

    -- fields
    self.AuraId = -1;
    self.ExpirationTime = -1;
    self.TimeRemaining = -1;
    self.IsVisible = false;

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
    self:SetTimeRemainingShown(settings.timeRemaining.show);
    self:SetTooltipsEnabled(data.settings.showTooltips);
end

Engine:DefineParams("boolean");
---@param shown boolean @Set to true to show the timer bar icon.
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

    Engine:DefineParams("boolean");
    ---@param shown boolean @Set to true to show borders.
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

Engine:DefineParams("boolean");
---@param shown boolean @Set to true to show the timer bar spark effect.
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

Engine:DefineParams("boolean");
---@param shown boolean @Set to true to show the timer bar aura name.
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

Engine:DefineParams("boolean");
---@param shown boolean @Set to true to show the timer bar's time remaining text.
function C_TimerBar:SetTimeRemainingShown(data, shown)
    if (not data.timeRemaining and shown) then
        data.timeRemaining = data.slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
        data.timeRemaining:SetPoint("RIGHT", -4, 0);

        local font = tk.Constants.LSM:Fetch("font", data.settings.timeRemaining.font);
        data.timeRemaining:SetFont(font, data.settings.timeRemaining.fontSize);
    end

    if (data.timeRemaining) then
        data.timeRemaining:SetShown(shown);
    end
end

Engine:DefineParams("boolean");
---@param shown boolean @Set to true to show the aura tooltip on mouse over.
function C_TimerBar:SetTooltipsEnabled(data, enabled)
    if (enabled) then
        tk:SetAuraTooltip(data.frame);
    else
        data.frame:SetScript("OnEnter", tk.Constants.DUMMY_FUNC);
        data.frame:SetScript("OnLeave", tk.Constants.DUMMY_FUNC);
    end
end

Engine:DefineParams("number", "?number");
---@param currentTime number @The current time using GetTime.
---@param totalDuration number @(optional) The total duration of the timer bar (used when the timer bar is first created to set the max value of the slider)
function C_TimerBar:UpdateTimeRemaining(data, currentTime, totalDuration)
    self.TimeRemaining = self.ExpirationTime - currentTime;
    obj:Assert(self.TimeRemaining >= 0); -- duration should have been checked in the frame OnUpdate script

    if (totalDuration) then
        -- Called from UpdateAura
        data.slider:SetMinMaxValues(0, totalDuration);
    end

    data.slider:SetValue(self.TimeRemaining);

    if (data.spark and data.spark:IsShown()) then
        local _, max = data.slider:GetMinMaxValues();
        local offset = data.spark:GetWidth() / 2;
        local barWidth = data.slider:GetWidth();
        local value = (self.TimeRemaining / max) * barWidth - offset;

        if (value > barWidth - offset) then
            value = barWidth - offset;
        end

        data.spark:SetPoint("LEFT", value, 0);
    end

    local timeRemainingText = string.format("%.1f", self.TimeRemaining);

    if (tonumber(timeRemainingText) > 3600) then
        timeRemainingText = date("%H:%M:%S", timeRemainingText);

    elseif (tonumber(timeRemainingText) > 60) then
        timeRemainingText = date("%M:%S", timeRemainingText);
    end

    data.timeRemaining:SetText(timeRemainingText);
end

Engine:DefineParams("table", "number", "string");
---@param auraInfo table @A table containing a subset of the results from UnitAura.
---@param currentTime number @The result of GetTime shared by all timer bars being updated in the same field.
---@param auraType string @The type of aura (must be either "BUFF" or "DEBUFF").
function C_TimerBar:UpdateAura(data, auraInfo, currentTime, auraType)
    local auraName        = auraInfo[1];
    local iconPath        = auraInfo[2];
    local debuffType      = auraInfo[4];
    local totalDuration   = auraInfo[5];
    local canStealOrPurge = auraInfo[8];

    obj:PushTable(auraInfo);
    data.frame.auraId = self.AuraId; -- this is needed for the tooltip mouse over
    self:UpdateTimeRemaining(currentTime, totalDuration);

    if (data.icon) then
        data.icon:SetTexture(iconPath);
    end

    data.auraName:SetText(auraName);

    if (data.settings.colorStealOrPurge and canStealOrPurge) then
        data.slider:SetStatusBarColor(unpack(data.settings.colors.canStealOrPurge));
    else
        if (auraType == BUFF) then
            data.slider:SetStatusBarColor(unpack(data.settings.colors.basicBuff));
        elseif (auraType == DEBUFF) then
            if (data.settings.colorDebuffsByType and obj:IsString(debuffType)) then
                data.slider:SetStatusBarColor(unpack(data.settings.colors[string.lower(debuffType)]));
            else
                data.slider:SetStatusBarColor(unpack(data.settings.colors.basicDebuff));
            end
        end
    end
end