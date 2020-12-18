-- luacheck: ignore LibStub self 143 631
local _, namespace = ...;

local string, tostring, select, unpack, type = _G.string, _G.tostring, _G.select, _G.unpack, _G.type;
local tonumber, math, pairs, pcall, error = _G.tonumber, _G.math, _G.pairs, _G.pcall, _G.error;
local hooksecurefunc, UnitLevel, UnitClass = _G.hooksecurefunc, _G.UnitLevel, _G.UnitClass;
local LibStub, IsTrialAccount = _G.LibStub, _G.IsTrialAccount;
local UnitQuestTrivialLevelRange, GetQuestGreenRange = _G.UnitQuestTrivialLevelRange, _G.GetQuestGreenRange;

namespace.components = {};
namespace.components.Objects = _G.MayronObjects:GetFramework(); ---@type MayronObjects
namespace.components.Locale = LibStub("AceLocale-3.0"):GetLocale("MayronUI");
namespace.components.Toolkit = {};

local obj = namespace.components.Objects;
local tk = namespace.components.Toolkit; ---@type Toolkit
local L = namespace.components.Locale;

tk.Numbers = {};

function tk.Numbers:ToPrecision(number, precision)
    number = tonumber(number);
    number = math.floor(number * (math.pow(10, precision)) + 0.5);
    number = number / (math.pow(10, precision));
    return number;
end

function tk:ValueIsEither(value, ...)
  for _, otherValue in obj:IterateArgs(...) do
    if (self:Equals(value, otherValue)) then
      return true;
    end
  end

  return false;
end

function tk:UnpackIfTable(value)
    if (obj:IsTable(value)) then
        return obj:UnpackTable(value);
    else
        return value;
    end
end

function tk:Print(...)
    local prefix = self.Strings:SetTextColorByTheme("MayronUI:");
    _G.DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, _G.tostringall(...)));
end

function tk:GetAssetFilePath(filePath)
    return string.format("%s\\%s", tk.Constants.ASSETS_FOLDER, filePath);
end

do
    local modKeys = {
        S = function() return _G.IsShiftKeyDown(); end,
        C = function() return _G.IsControlKeyDown(); end,
        A = function() return _G.IsAltKeyDown(); end,
    };

    function tk:IsModComboActive(strKey) -- "SC" - is shift and control down but not alt? (example)
        local checked = {S = false, C = false, A = false};
        for i = 1, #strKey do
            local modCode = strKey:sub(i,i)
            modCode = string.upper(modCode);

            checked[modCode] = true;

            if (not modKeys[modCode]()) then
                return false;
            end
        end

        for key, value in pairs(checked) do
            if (not value and modKeys[key]()) then
                return false;
            end
        end

        return strKey ~= "";
    end
end

do
  local function GetPlayerLevelRange()
    if (GetQuestGreenRange) then
      return GetQuestGreenRange();
    end

    if (UnitQuestTrivialLevelRange) then
      return UnitQuestTrivialLevelRange("player");
    end

    return 5;
  end

  function tk:GetDifficultyColor(level)
    local difference = (level - UnitLevel("player"));
    local color;

    if (difference >= 5) then
      color = _G.QuestDifficultyColors["impossible"];

    elseif (difference >= 3) then
      color = _G.QuestDifficultyColors["verydifficult"];

    elseif (difference >= -2 or level < 0) then
      color = _G.QuestDifficultyColors["difficult"];

    elseif (-difference <= GetPlayerLevelRange()) then
      color = _G.QuestDifficultyColors["standard"];

    else
      color = _G.QuestDifficultyColors["trivial"];
    end

    return color;
  end
end

function tk:Equals(value1, value2, deepEquals)
    local type1 = type(value1);

    if (type(value2) == type1) then

        if (type1 == "table") then
            if (not deepEquals) then
                return tostring(value1) == tostring(value2);
            else
                for id, value in pairs(value1) do
                    if (not self:Equals(value, value2[id])) then
                        return false;
                    end
                end
            end

            return true;
        elseif (type1 == "function") then
            return tostring(value1) == tostring(value2);
        else
            return value1 == value2;
        end
    end

    return false;
end

function tk:GetPlayerKey()
    local key, realm = _G.UnitName("player"), _G.GetRealmName():gsub("%s+", "");
    key = realm and string.join("-", key, realm);
    return key;
end

function tk:IsRetail()
  return _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE;
end

function tk:IsClassic()
  return _G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC;
end

function tk:GetMaxPlayerLevel()
  return IsTrialAccount() and 20 or 60;
end

function tk:IsPlayerMaxLevel()
    local playerLevel = UnitLevel("player");
    return (self:GetMaxPlayerLevel() == playerLevel);
end

function tk:GetLocalizedUnitClassName(unit)
    return select(2, UnitClass(unit));
end

function tk:GetLocalizedClassName(className)
    if (tk.Constants.LOCALIZED_CLASS_NAMES[className] or tk.Constants.LOCALIZED_CLASS_FEMALE_NAMES[className]) then
        -- already localized
        return className;
    end

    local localizedName = tk.Tables:GetIndex(tk.Constants.LOCALIZED_CLASS_NAMES, className);

    if (not localizedName) then
        localizedName = tk.Tables:GetIndex(tk.Constants.LOCALIZED_CLASS_FEMALE_NAMES, className);
    end

    tk:Assert(localizedName, "Unknown class name '%s'.", className);
    return localizedName;
end

function tk:GetClassColor(className)
    return _G.GetClassColorObj(tk:GetLocalizedClassName(className));
end

function tk:GetUnitClassColor(unit)
    return _G.GetClassColorObj(tk:GetLocalizedUnitClassName(unit));
end

local errorInfo = {};
errorInfo.PREFIX = "|cff00ccffMayronUI: |r";

-- @param silent (boolean) - true if errors should be cause in the error log instead of triggering.
function tk:SetSilentErrors(silent)
    errorInfo.silent = silent;
end

-- @return errorLog (table) - contains index/string pairs of errors caught while in silent mode.
function tk:GetErrorLog()
    errorInfo.errorLog = errorInfo.errorLog or {};
    return errorInfo.errorLog;
end

-- empties the error log table.
function tk:FlushErrorLog()
    if (errorInfo.errorLog) then
        tk.Tables:Empty(errorInfo.errorLog);
    end
end

-- @return numErrors (number) - the total number of errors caught while in silent mode.
function tk:GetNumErrors()
    return (errorInfo.errorLog and #errorInfo.errorLog) or 0;
end

function tk:Assert(condition, errorMessage, ...)
    if (condition) then return end

    if ((select("#", ...)) >= 1) then
        errorMessage = string.format(errorMessage, _G.tostringall(...));

    elseif (tk.Strings:Contains(errorMessage, "%s")) then
        errorMessage = string.format(errorMessage, "nil");
    end

    local fullError = tk.Strings:Join(tk.Strings.Empty, errorInfo.PREFIX, errorMessage);

    if (errorInfo.silent) then
        errorInfo.errorLog = errorInfo.errorLog or {};
        errorInfo.errorLog[#errorInfo.errorLog + 1] = pcall(function() error(fullError) end);
    else
        error(fullError);
    end
end

function tk:Error(errorMessage, ...)
    self:Assert(false, errorMessage, ...);
end

do
    local POPUP_GLOBAL_NAME = "MUI_TOOLKIT_POPUP";

    local function EditBox_OnEscapePressed(self)
        local popup = self.popup or self;
        local editBox = popup.editBox;
        local onCancel = popup.data.OnCancel;

        if (onCancel) then
            onCancel(editBox, editBox:GetText());
        end

        _G.StaticPopup_Hide(POPUP_GLOBAL_NAME);
    end

    local function EditBox_OnEnterPressed(self)
        local popup = self.popup or self;
        local editBox = popup.editBox;
        local validator = popup.data.OnValidate;
        local onAccept = popup.data.OnAccept;

        if (validator and not validator(editBox, editBox:GetText())) then
            return;
        end

        if (onAccept) then
            onAccept(editBox, editBox:GetText(), obj:UnpackTable(popup.data.args));
        end

        _G.StaticPopup_Hide(POPUP_GLOBAL_NAME);
    end

    local function EditBox_OnTextChanged(self, userInput)
        local validator = self.popup.data.OnValidate;

        if (not userInput or not validator) then
            return;
        end

        local isValid = validator(self, self:GetText());
        self.popup.button1:SetEnabled(isValid);
    end

    local function PopUp_OnShow(self)
      if (self.button1) then
        self.button1:Enable();
      end

      if (self.button2) then
        self.button2:Enable();
      end

      if (not self.editBox) then
        return;
      end

      self.editBox.popup = self; -- refer back to popup in scripts below

      if (self.data and self.data.editBoxText) then
        self.editBox:SetText(self.data.editBoxText);
        self.editBox:HighlightText();
        self.editBox:SetWidth(300);
      end

      self.editBox:SetFocus();

      self.editBox:SetScript("OnEscapePressed", EditBox_OnEscapePressed);
      self.editBox:SetScript("OnEnterPressed", EditBox_OnEnterPressed);
      self.editBox:SetScript("OnTextChanged", EditBox_OnTextChanged);

      EditBox_OnTextChanged(self.editBox, true); -- call it OnShow to enable/disable confirm button
    end

    local function PopUp_OnAccept(self)
      if (self.data.OnAccept) then
        if (self.hasEditBox) then
          EditBox_OnEnterPressed(self);
        else
          self.data.OnAccept(self, obj:UnpackTable(self.data.args));
        end
      end
    end

    local function GetPopup(message, subMessage)
        local popup = _G.StaticPopupDialogs[POPUP_GLOBAL_NAME];

        if (not popup) then
            popup = {
                preferredIndex = 3;
                timeout = 0;
                whileDead = 1;
                hideOnEscape = 1;
                maxLetters = 1024;
                OnShow = PopUp_OnShow;
                closeButton = true;
                data = obj:PopTable();
            };

            _G.StaticPopupDialogs[POPUP_GLOBAL_NAME] = popup;
        end

        popup.text = message;
        popup.subText = subMessage;

        return popup;
    end

    local function StoreArgs(popup, ...)
        if (obj:IsTable(popup.data.args)) then
            obj:PushTable(popup.data.args);
        end

        if (select("#", ...) > 0) then
            popup.data.args = obj:PopTable(...);
        end
    end

    local function ShowConfirmPopup(message, subMessage, onConfirm, confirmText, onCancel, cancelText, isWarning, ...)
      local popup = GetPopup(message, subMessage);

      popup.hasEditBox = false;
      popup.button1 = confirmText or L["Confirm"];
      popup.button2 = cancelText or L["Cancel"];
      popup.OnAccept = PopUp_OnAccept;
      popup.OnCancel = onCancel;

      if (isWarning) then
          popup.showAlert = true;
      end

      popup.data.OnAccept = onConfirm;
      popup.data.OnValidate = nil;
      StoreArgs(popup, ...);

      return popup;
    end

    function tk:ShowConfirmPopup(...)
      local popup = ShowConfirmPopup(...);
      _G.StaticPopup_Show(POPUP_GLOBAL_NAME, nil, nil, popup.data);
    end

    function tk:ShowConfirmPopupWithInsertedFrame(insertedFrame, ...)
        local popup = ShowConfirmPopup(...);
        _G.StaticPopup_Show(POPUP_GLOBAL_NAME, nil, nil, popup.data, insertedFrame);
    end

    function tk:ShowMessagePopup(message, subMessage, okayText, onOkay, isWarning, ...)
        local popup = GetPopup(message, subMessage);

        popup.button1 = okayText or L["Okay"];
        popup.button2 = nil;
        popup.hasEditBox = false;
        popup.OnAccept = onOkay;
        popup.OnCancel = nil;
        StoreArgs(popup, ...);

        if (isWarning) then
            popup.showAlert = true;
        end

        _G.StaticPopup_Show(POPUP_GLOBAL_NAME, nil, nil, popup.data);
    end

    function tk:ShowInputPopupWithOneButton(message, subMessage, editBoxText, okayText, ...)
      local popup = GetPopup(message, subMessage);

      popup.button1 = okayText or L["Okay"];
      popup.button2 = nil;
      popup.hasEditBox = true;
      popup.OnAccept = EditBox_OnEnterPressed;
      popup.OnCancel = nil;

      popup.data.editBoxText = editBoxText;
      popup.data.OnAccept = nil;
      popup.data.OnCancel = nil;
      popup.data.OnValidate = nil;
      StoreArgs(popup, ...);

      _G.StaticPopup_Show(POPUP_GLOBAL_NAME, nil, nil, popup.data);
  end

    function tk:ShowInputPopup(message, subMessage, editBoxText, onValidate, confirmText, onConfirm, cancelText, onCancel, isWarning, ...)
        local popup = GetPopup(message, subMessage);

        popup.button1 = confirmText or L["Confirm"];
        popup.button2 = cancelText or L["Cancel"];
        popup.hasEditBox = true;
        popup.OnAccept = EditBox_OnEnterPressed;
        popup.OnCancel = EditBox_OnEscapePressed;

        if (isWarning) then
            popup.showAlert = true;
        end

        popup.data.editBoxText = editBoxText;
        popup.data.OnAccept = onConfirm;
        popup.data.OnCancel = onCancel;
        popup.data.OnValidate = onValidate;
        StoreArgs(popup, ...);

        _G.StaticPopup_Show(POPUP_GLOBAL_NAME, nil, nil, popup.data);
    end
end

do
    local callbacks = {};

    local function CreateCallbackWrapper(key, tbl, methodName)
        return function(...)
            local callbackData = callbacks[key];

            if (not callbackData) then
                return; -- it has been unhooked
            end

            local args = obj:PopTable();
            tk.Tables:AddAll(args, select(2, unpack(callbackData)));
            tk.Tables:AddAll(args, ...);

            if (obj:IsTable(callbackData)) then
                -- pass to callback function all custom args and then the real hooksecurefunc args
                local callback = callbackData[1];

                if (obj:IsFunction(callback)) then
                  local unhook = callbackData[1](unpack(args));

                  if (unhook) then
                      if (tbl) then
                          tk:UnhookFunc(tbl, methodName, callbackData[1]);
                      else
                          tk:UnhookFunc(methodName, callbackData[1]);
                      end
                  end
                end
            end

            obj:PushTable(args);
        end
    end

    function tk:HookFunc(tbl, methodName, callback, ...)
      if (obj:IsString(tbl)) then
        local realGlobalMethodName = tbl;
        local realCallback = methodName;
        local firstArg = callback;

        local key = string.format("%s|%s", realGlobalMethodName, tostring(realCallback));
        local callbackWrapper = CreateCallbackWrapper(key, tbl, methodName);

        callbacks[key] = obj:PopTable(realCallback, firstArg, ...);
        hooksecurefunc(realGlobalMethodName, callbackWrapper);
        return realCallback;
      else
        local key = string.format("%s|%s|%s", tostring(tbl), methodName, tostring(callback));
        local callbackWrapper = CreateCallbackWrapper(key, tbl, methodName);

        callbacks[key] = obj:PopTable(callback, ...);
        hooksecurefunc(tbl, methodName, callbackWrapper);
        return callback;
      end
    end

    function tk:UnhookFunc(tbl, methodName, callback)
        local key;

        if (obj:IsString(tbl)) then
            local realGlobalMethodName = tbl;
            local realCallback = methodName;
            key = string.format("%s|%s", realGlobalMethodName, tostring(realCallback));
        else
            key = string.format("%s|%s|%s", tostring(tbl), methodName, tostring(callback));
        end

        if (obj:IsTable(callbacks[key])) then
            obj:PushTable(callbacks[key]);
        end

        callbacks[key] = nil;
    end
end

function tk:CreateTableProtector(tbl)
    local protector = setmetatable({}, {
        __index = tbl;
        __newindex = function(self, key, value)
            error(string.format("Failed to transform protected table with key '%s' and value '%s'", tostring(key), tostring(value)));
        end;
    });

    return protector;
end

do
  local BNGetFriendInfoByID, C_BattleNet = _G.BNGetFriendInfoByID, _G.C_BattleNet;
  local strsplit = _G.strsplit;

  function tk.ReplaceAccountNameCodeWithBattleTag(accountNameCode)
    for i = 1, 200 do
      if (BNGetFriendInfoByID) then
        -- otherAccountNameCode will be a code such as |Km24|k
        local _, otherAccountNameCode, battleTag = BNGetFriendInfoByID(i);

        if (i > 50 and not otherAccountNameCode) then
          return "";
        end

        if (accountNameCode == otherAccountNameCode) then
          return (select(1, strsplit("#", battleTag)));
        end

      elseif (C_BattleNet and C_BattleNet.GetAccountInfoByID) then
        local friendInfo = C_BattleNet.GetAccountInfoByID(i);

        if (obj:IsTable(friendInfo)) then
          if (i > 50 and not friendInfo.accountName) then
            return "";
          end

          if (accountNameCode == friendInfo.accountName) then
            return (select(1, strsplit("#", friendInfo.battleTag)));
          end
        end
      end
    end
  end
end

local GetAddOnMetadata = _G.GetAddOnMetadata;

function tk:GetTutorialShowState(oldVersion, afterInstall)
  local currentVersion = GetAddOnMetadata("MUI_Core", "Version");
  local major, minor, patch = tk.Strings:Split(currentVersion, ".");
  major = tonumber(major);
  minor = tonumber(minor);
  patch = tonumber(patch);

  local shouldShow = false;

  if (not oldVersion or not (obj:IsString(oldVersion))) then
    shouldShow = true;
  else
    local oldMajor, oldMinor, oldPatch = tk.Strings:Split(oldVersion, ".");
    oldMajor = tonumber(oldMajor);
    oldMinor = tonumber(oldMinor);
    oldPatch = tonumber(oldPatch);

    if (major > oldMajor or minor > oldMinor or patch > (oldPatch + 5)) then
      shouldShow = true;
    end
  end

  if (shouldShow and afterInstall) then
    local freshInstall = _G.MayronUI.db.profile.freshInstall;
    if (not freshInstall) then
      shouldShow = false;
    end
  end

  return shouldShow;
end

function tk:GetInterfaceName()
  if (self:IsClassic()) then
    return "MayronUI Classic";
  else
    return "MayronUI Gen6";
  end
end