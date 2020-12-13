-- luacheck: ignore self 143 631
local _, namespace = ...;
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local GetCVarBool, table, string, select = _G.GetCVarBool, _G.table, _G.string, _G.select;
local hooksecurefunc, GetMinimapZoneText = _G.hooksecurefunc, _G.GetMinimapZoneText;
local GetNumGroupMembers, IsResting = _G.GetNumGroupMembers, _G.IsResting;
local IsInInstance, InCombatLockdown = _G.IsInInstance, _G.InCombatLockdown;
local UnitIsAFK, UnitIsDeadOrGhost, GetZoneText = _G.UnitIsAFK, _G.UnitIsDeadOrGhost, _G.GetZoneText;
local HandleLuaError = _G.HandleLuaError;
local debugstack, debuglocals = _G.debugstack, _G.debuglocals;

local ERRORS = {};
local seterrorhandler = _G.seterrorhandler;
local ScriptErrorsFrame = _G.ScriptErrorsFrame;

---@class C_ErrorHandler : BaseModule
local C_ErrorHandler = MayronUI:RegisterModule("ErrorHandlerModule");
local Engine = obj:Import("MayronUI.Engine");

function C_ErrorHandler:OnInitialize()
  local function addError(errorMessage)
    table.insert(ERRORS, {
      zone = string.format("%s (%s)", GetZoneText(), GetMinimapZoneText()),
      groupSize = GetNumGroupMembers(),
      instanceType = (select(2, IsInInstance())),
      inCombat = InCombatLockdown(),
      resting = IsResting(),
      isAFK = UnitIsAFK("player"),
      isDeadOrGhost = UnitIsDeadOrGhost("player"),
      error = errorMessage
    });
  end

  em:CreateEventHandler("ADDON_ACTION_BLOCKED, ADDON_ACTION_FORBIDDEN", function(event, name, func)
    local errorMessage = ("[%s] AddOn '%s' tried to call the protected function '%s'."):format(event, name or "<name>", func or "<func>");
    addError(errorMessage);
  end);

  hooksecurefunc("DisplayInterfaceActionBlockedMessage", function()
    local stack = debugstack(3) or tk.Strings.Empty;
    local locals = debuglocals(3) or tk.Strings.Empty;
    addError(string.format("%s\n%s\n%s", _G.INTERFACE_ACTION_BLOCKED, stack, locals));
    ScriptErrorsFrame:DisplayMessageInternal(_G.INTERFACE_ACTION_BLOCKED, nil, true, locals, stack);
  end);

  em:CreateEventHandler("LUA_WARNING", function(_, _, warningMessage)
    addError(warningMessage);
  end);

  seterrorhandler(function(errorMessage)
    addError(errorMessage);
    HandleLuaError(errorMessage);
  end);

  local reloadBtn, closeBtn = ScriptErrorsFrame.Reload, ScriptErrorsFrame.Close;

  ScriptErrorsFrame:SetFrameStrata("HIGH");
  ScriptErrorsFrame:SetParent(_G.UIParent);
  ScriptErrorsFrame:SetScale(1.4);

  tk:SetFontSize(closeBtn:GetFontString(), 11);
  closeBtn:SetText("Report MayronUI Bug");
  closeBtn:SetWidth(180);
  ScriptErrorsFrame.IndexLabel:SetPoint("BOTTOMLEFT", _G.ScriptErrorsFrameBottom, "BOTTOMLEFT", 10, 15);

  reloadBtn:SetText("");
  reloadBtn:SetSize(16, 16);
  tk:KillAllElements(reloadBtn.Left, reloadBtn.Middle, reloadBtn.Right);
  reloadBtn:SetNormalTexture("Interface\\Buttons\\UI-RefreshButton");
  reloadBtn:SetHighlightAtlas("chatframe-button-highlight");
  tk:SetBasicTooltip(reloadBtn, "Reload UI");
  reloadBtn:SetPoint("BOTTOMLEFT", ScriptErrorsFrame,  15, 14);

  closeBtn:SetScript("OnClick", function()
    MayronUI:TriggerCommand("report", true);
    ScriptErrorsFrame:Hide();
  end);

  closeBtn.SetScript = tk.Constants.DUMMY_FUNC;

  local BugSack, BugGrabber = _G.BugSack, _G.BugGrabber;

  if (BugSack) then
    hooksecurefunc(BugSack, "OpenSack", function()
      local sendButton = _G.BugSackSendButton;

      if (sendButton) then
        sendButton:SetText("Report MayronUI Bug");

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
        local errorMessage = string.format("%s\n%s\n%s", tbl.message, tbl.stack, tbl.locals);
        addError(errorMessage);
      end
    end

    BugGrabber.RegisterCallback(namespace, "BugGrabber_BugGrabbed", BugGrabber_OnBugGrabbed);
  end

  obj:SetErrorHandler(function(errorMessage, stack, locals)
    local hideErrorFrame = not GetCVarBool("scriptErrors");
    ScriptErrorsFrame.Title:SetText("MayronUI Error");
    ScriptErrorsFrame.Title:SetFontObject("MUI_FontNormal");

    addError(string.format("%s\n%s\n%s", errorMessage, stack or "", locals or ""));
    ScriptErrorsFrame:DisplayMessageInternal(errorMessage, nil, hideErrorFrame, locals, stack);
  end);
end

Engine:DefineReturns("table");
function C_ErrorHandler:GetErrors()
  return ERRORS;
end