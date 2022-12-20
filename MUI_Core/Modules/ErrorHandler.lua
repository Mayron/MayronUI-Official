-- luacheck: ignore self 143 631
local _, namespace = ...;
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, em, _, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local table, string, select, pairs = _G.table, _G.string, _G.select, _G.pairs;
local hooksecurefunc, GetMinimapZoneText = _G.hooksecurefunc, _G.GetMinimapZoneText;
local GetNumGroupMembers, IsResting = _G.GetNumGroupMembers, _G.IsResting;
local IsInInstance, InCombatLockdown = _G.IsInInstance, _G.InCombatLockdown;
local UnitIsAFK, UnitIsDeadOrGhost, GetZoneText = _G.UnitIsAFK, _G.UnitIsDeadOrGhost, _G.GetZoneText;
local debugstack, debuglocals, HandleLuaError = _G.debugstack, _G.debuglocals, _G.HandleLuaError;

local ERRORS = {};
local seterrorhandler = _G.seterrorhandler;
local ScriptErrorsFrame = _G.ScriptErrorsFrame;

---@class C_ErrorHandler : BaseModule
local C_ErrorHandler = MayronUI:RegisterModule("ErrorHandlerModule");

function C_ErrorHandler:OnInitialize()
  local function addError(errorMessage)
    for _, errorInfo in pairs(ERRORS) do
      if (errorInfo.error == errorMessage) then
        return -- don't add the same error more than once
      end
    end

    local newErrorInfo = {
      zone = string.format("%s (%s)", GetZoneText(), GetMinimapZoneText()),
      groupSize = GetNumGroupMembers(),
      instanceType = (select(2, IsInInstance())),
      inCombat = InCombatLockdown(),
      resting = IsResting(),
      isAFK = UnitIsAFK("player"),
      isDeadOrGhost = UnitIsDeadOrGhost("player"),
      locals = debuglocals(4),
      stacktrace = debugstack(4),
      error = errorMessage,
    };

    table.insert(ERRORS, newErrorInfo);
  end

  local listener = em:CreateEventListener(function(_, event, name, func)
    local errorMessage = ("[%s] AddOn '%s' tried to call the protected function '%s'.")
      :format(event, name or "<name>", func or "<func>");
    addError(errorMessage);
  end);

  listener:RegisterEvents(
    "ADDON_ACTION_BLOCKED",
    "ADDON_ACTION_FORBIDDEN",
    "MACRO_ACTION_BLOCKED");

  if (tk:IsRetail()) then
    hooksecurefunc("DisplayInterfaceActionBlockedMessage", function()
      local stack = debugstack(3) or tk.Strings.Empty;
      addError(string.format("Interface action failed because of an AddOn\n%s", stack));
    end);
  end

  listener = em:CreateEventListener(function(_, _, warningMessage)
    addError(warningMessage);
  end);

  listener:RegisterEvent("LUA_WARNING");

  seterrorhandler(function(errorMessage)
    addError(errorMessage);
    HandleLuaError(errorMessage);
  end);

  local reloadBtn, closeBtn = ScriptErrorsFrame.Reload, ScriptErrorsFrame.Close;

  ScriptErrorsFrame:SetFrameStrata("HIGH");
  ScriptErrorsFrame:SetParent(_G.UIParent);
  ScriptErrorsFrame:SetScale(1.4);

  tk:SetFontSize(closeBtn:GetFontString(), 11);
  local closeText = closeBtn:GetText();
  local closeBtnWidth = closeBtn:GetWidth();

  tk:HookFunc(ScriptErrorsFrame, "Update", function(self)
    local isMayronUIError = false;

    if (obj:IsTable(self.seen)) then
      local index = self.index;

      for errorMessage, errorIndex in pairs(self.seen) do
        if (errorIndex == index) then
          if (tk.Strings:Contains(errorMessage, "MUI_")) then
            isMayronUIError = true;
          end
          break;
        end
      end
    end

    closeBtn.showReportWindow = isMayronUIError;

    if (isMayronUIError) then
      closeBtn:SetText(L["Report MayronUI Bug"]);
      closeBtn:SetWidth(180);
    else
      closeBtn:SetText(closeText);
      closeBtn:SetWidth(closeBtnWidth);
    end
  end);

  ScriptErrorsFrame.IndexLabel:SetPoint("BOTTOMLEFT", _G.ScriptErrorsFrameBottom, "BOTTOMLEFT", 10, 15);

  reloadBtn:SetText("");
  reloadBtn:SetSize(16, 16);
  tk:KillAllElements(reloadBtn.Left, reloadBtn.Middle, reloadBtn.Right);
  reloadBtn:SetNormalTexture("Interface\\Buttons\\UI-RefreshButton");
  reloadBtn:SetHighlightAtlas("chatframe-button-highlight");
  tk:SetBasicTooltip(reloadBtn, "Reload UI");
  reloadBtn:SetPoint("BOTTOMLEFT", ScriptErrorsFrame,  15, 14);

  closeBtn:SetScript("OnClick", function(self)
    if (self.showReportWindow) then
      MayronUI:TriggerCommand("report", true);
    end

    ScriptErrorsFrame:Hide();
  end);

  closeBtn.SetScript = tk.Constants.DUMMY_FUNC;

  local BugSack, BugGrabber = _G.BugSack, _G.BugGrabber;

  if (BugSack) then
    hooksecurefunc(BugSack, "OpenSack", function()
      local sendButton = _G.BugSackSendButton;

      if (sendButton) then
        sendButton:SetText(L["Report MayronUI Bug"]);

        sendButton:SetScript("OnClick", function()
          MayronUI:TriggerCommand("report", true);
          BugSack:CloseSack();
        end);
      end
    end);
  end

  if (BugGrabber) then
    local function BugGrabber_OnBugGrabbed(event, tbl)
      if (event == "BugGrabber_BugGrabbed" and obj:IsTable(tbl)) then
        local errorMessage = string.format("%s\n%s", tbl.message or "<unknown>", tbl.stack or tk.Strings.Empty);
        addError(errorMessage);
      end
    end

    BugGrabber.RegisterCallback(namespace, "BugGrabber_BugGrabbed", BugGrabber_OnBugGrabbed);
  end
end

obj:DefineReturns("table");
function C_ErrorHandler:GetErrors()
  return ERRORS;
end