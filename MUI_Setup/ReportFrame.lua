-- luacheck: ignore self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, _, gui, obj, L = MayronUI:GetCoreComponents();

local collectgarbage, PlaySound = _G.collectgarbage, _G.PlaySound;
local string, ipairs, tostring, min, mfloor = _G.string, _G.ipairs, _G.tostring,
  _G.math.min, _G.math.floor;

local C_ReportIssue = MayronUI:RegisterModule("ReportIssue", nil, true) ---@class C_ReportIssue : BaseModule

local TOTAL_STEPS = 3;
local TITLE_TEMPLATE = tk.Strings:JoinWithSpace(
                         L["Step %d of"], tostring(TOTAL_STEPS));
local REPLICATE_BUG_STEP_TEXT = string.format(
                                  "%s 1: \n%s 2: \n%s 3: ", L["Step"],
                                    L["Step"], L["Step"]);
_G.MUI_GITHUB_SUBMIT_NEW_ISSUE_LINK =
  "https://github.com/Mayron/MayronUI-Official/issues/new?template=bug_report.md";

function C_ReportIssue:OnInitialize(data)
  data.steps = obj:PopTable();
  data.ITEM_SPACING = 20;

  data.stepText = {
    [1] = L["Found a bug? Use this form to submit an issue to the official MayronUI GitHub page."];
    [2] = L["Almost done! We just need a bit more information..."];
    [3] = L["Click below to generate your report. Once generated, copy it into a new issue and submit it on GitHub using the link below:"];
  }

  local frame = gui:CreateDialogBox(nil, "HIGH");
  frame:SetSize(600, 400);
  frame:SetPoint("CENTER");
  data.reportFrame = frame;

  gui:AddCloseButton(frame, nil, tk.Constants.CLICK);
  gui:AddTitleBar(frame, L["Report Issue"]);
  gui:AddResizer(frame);

  if (obj:IsFunction(frame.SetMinResize)) then
    frame:SetMinResize(500, 400);
    frame:SetMaxResize(900, 800);
  else
    -- dragonflight:
    frame:SetResizeBounds(500, 400, 900, 800);
  end

  data.panel = gui:CreatePanel(nil, nil, frame); ---@type Panel
  data.panel:SetAllPoints(true);
  data.panel:SetDimensions(1, 3);
  data.panel:SetDevMode(false);
  data.panel:GetRow(1):SetFixed(130);
  data.panel:GetRow(3):SetFixed(80);

  data:Call("SetUpHeader");

  local cell = data.panel:CreateCell();
  cell:SetInsets(15, data.ITEM_SPACING);

  data.panel:AddCells(cell);
  data.stepParentFrame = cell:GetFrame();

  data:Call("SetUpFooter");
  data:Call("ShowStep", 1);
end

function C_ReportIssue:Show(data)
  data:Call("ShowStep", 1);
  data.reportFrame:Show();
end

function C_ReportIssue:Toggle(data)
  if (data.reportFrame:IsShown()) then
    data.reportFrame.closeBtn:Click();
  else
    data:Call("ShowStep", 1);
    data.reportFrame:Show();
  end
end

obj:DefineParams("table");
function C_ReportIssue:SetErrors(data, errors)
  data.errors = errors;
end

function C_ReportIssue.Private:SetUpHeader(data)
  local panel = data.panel; ---@type Panel
  local cell = data.panel:CreateCell(); ---@type Cell
  cell:SetInsets(30, data.ITEM_SPACING, 10, data.ITEM_SPACING);

  local title = cell:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
  title:SetPoint("TOPLEFT");
  title:SetPoint("TOPRIGHT");
  data.stepTitle = title;

  local intro = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  intro:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -data.ITEM_SPACING);
  intro:SetPoint("BOTTOMRIGHT", cell:GetFrame(), "BOTTOMRIGHT");
  intro:SetJustifyV("TOP");
  tk:SetFontSize(intro, 16);
  data.intro = intro;

  panel:AddCells(cell);
end

obj:DefineParams("number");
function C_ReportIssue.Private:ShowStep(data, stepNum)
  if (stepNum < 1) then
    stepNum = 1;
  end

  if (stepNum > TOTAL_STEPS) then
    stepNum = TOTAL_STEPS;
  end

  if (data.currentStepFrame) then
    data.currentStepFrame:Hide();
  end

  if (not data.steps[stepNum]) then
    local stepFrame = tk:CreateFrame("Frame", data.stepParentFrame);
    stepFrame:SetAllPoints(true);
    data:Call(string.format("RenderStep%d", stepNum), stepFrame);
    data.steps[stepNum] = stepFrame;
  end

  data.currentStep = stepNum;
  data.currentStepFrame = data.steps[stepNum];
  data.currentStepFrame:Show();

  data.stepTitle:SetText(string.format(TITLE_TEMPLATE, stepNum));
  data.intro:SetText(data.stepText[stepNum]);

  data.backButton:SetEnabled(stepNum > 1);
  data.nextButton:SetEnabled(stepNum < TOTAL_STEPS);
  data.reportFrame:SetHeight(400);

  if (obj:IsFunction(data.reportFrame.SetMinResize)) then
    data.reportFrame:SetMinResize(500, 400);
  else
    -- dragonflight:
    data.reportFrame:SetResizeBounds(500, 400);
  end

  if (data.closeButton) then
    data.closeButton:Hide();
  end

  if (stepNum == 1) then
    data.backButton:Hide();
    data.nextButton:Show();
    data.nextButton:ClearAllPoints();
    data.nextButton:SetPoint("CENTER");

  elseif (stepNum == 2) then
    data.backButton:Show();
    data.nextButton:Show();

    data.backButton:ClearAllPoints();
    data.backButton:SetPoint("RIGHT", data.footerParent, "CENTER", -10, 0);

    data.nextButton:ClearAllPoints();
    data.nextButton:SetPoint("LEFT", data.footerParent, "CENTER", 10, 0);

  elseif (stepNum == 3) then
    data.backButton:Show();
    data.nextButton:Hide();

    data.backButton:ClearAllPoints();
    data.backButton:SetPoint("CENTER");

    if (data.reportEditBox) then
      data.reportEditBox:SetText("");
      data.reportEditBox.container:Hide();
      data.generateButton:Show();
    end

    collectgarbage();
  end
end

function C_ReportIssue.Private:SetUpFooter(data)
  local panel = data.panel; ---@type Panel
  local cell = panel:CreateCell(); ---@type Cell
  cell:SetInsets(10, data.ITEM_SPACING);

  local parent = cell:GetFrame();
  data.footerParent = parent;

  local backButton = gui:CreateButton(parent, L["Back"]);
  backButton.minWidth = 150;
  backButton:SetWidth(150);
  backButton:Disable();

  backButton:SetScript(
    "OnClick", function()
      PlaySound(tk.Constants.CLICK);
      data:Call("ShowStep", data.currentStep - 1);
    end);

  local nextButton = gui:CreateButton(parent, L["Next"]);
  nextButton.minWidth = 150;
  nextButton:SetWidth(150);
  nextButton:Disable();

  nextButton:SetScript(
    "OnClick", function()
      PlaySound(tk.Constants.CLICK);
      data:Call("ShowStep", data.currentStep + 1);
    end);

  data.backButton = backButton;
  data.nextButton = nextButton;

  panel:AddCells(cell);
end

obj:DefineParams("Frame", "string", "number=0", "number=1000");
obj:DefineReturns("EditBox");
function C_ReportIssue.Private:CreateEditBox(
  data, parent, titleText, minLength, maxLength)
  local title = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
  title:SetPoint("TOPLEFT");
  title:SetPoint("TOPRIGHT");
  title:SetText(titleText);

  local editBox = tk:CreateFrame("EditBox", parent);
  editBox:SetMaxLetters(maxLength > 0 and maxLength or 100000);
  editBox:SetMultiLine(true);
  editBox:EnableMouse(true);
  editBox:SetAutoFocus(false);
  editBox:SetFontObject("ChatFontNormal");
  editBox:SetAllPoints(true);

  local container = gui:CreateScrollFrame(parent, nil, editBox);
  container:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -data.ITEM_SPACING);
  container:SetPoint("TOPRIGHT", title, "BOTTOMRIGHT", 0, -data.ITEM_SPACING);
  container:SetPoint("BOTTOM");
  container:SetBackdrop(tk.Constants.BACKDROP_WITH_BACKGROUND);
  container:SetBackdropBorderColor(tk:GetThemeColor());
  container:SetBackdropColor(0, 0, 0, 0.5);
  container:SetScript(
    "OnMouseUp", function()
      editBox:SetFocus(true)
    end);
  editBox.container = container;

  if (maxLength > 0) then
    local characters = parent:CreateFontString(
                         nil, "OVERLAY", "GameFontHighlight");
    characters:SetPoint("TOP", container, "BOTTOM", 0, -10);

    local charactersTemplate = tk.Strings:Join(
                                 "", "%d/1000 ", L["characters"], " %s");
    editBox:SetScript(
      "OnTextChanged", function()
        local size = #(editBox:GetText());
        local minText = tk.Strings.Empty;

        if (minLength > 0) then
          minText = string.format("(%s: %d)", L["minimum"], minLength);
        end

        local newText = string.format(charactersTemplate, size, minText);

        if (minLength > 0) then
          if (size < minLength) then
            data.nextButton:Disable();
            newText = tk.Strings:SetTextColorByKey(newText, "RED");
          else
            data.nextButton:Enable();
            newText = tk.Strings:SetTextColorByKey(newText, "GREEN");
          end
        else
          data.nextButton:Enable();
        end

        characters:SetText(newText);
      end);
  end

  editBox:SetScript(
    "OnEscapePressed", function()
      editBox:ClearFocus();
    end);

  container.ScrollFrame:ClearAllPoints();
  container.ScrollFrame:SetPoint("TOPLEFT", 10, -10);
  container.ScrollFrame:SetPoint("BOTTOMRIGHT", -10, 10);

  return editBox;
end

---------------------------------
--- Steps:
---------------------------------
obj:DefineParams("Frame");
function C_ReportIssue.Private:RenderStep1(data, parent)
  data.detailsEditBox = data:Call(
                          "CreateEditBox", parent,
                            L["Please describe the bug in detail:"], 50);
end

obj:DefineParams("Frame");
function C_ReportIssue.Private:RenderStep2(data, parent)
  data.replicateBugEditBox = data:Call(
                               "CreateEditBox", parent,
                                 L["How can we replicate the bug?"]);
  data.replicateBugEditBox:SetText(REPLICATE_BUG_STEP_TEXT);
end

obj:DefineParams("Frame");
function C_ReportIssue.Private:RenderStep3(data, parent)
  local linkButton = tk:CreateFrame("Button", parent);
  linkButton:SetPoint("TOPLEFT");
  linkButton:SetPoint("TOPRIGHT");
  linkButton:SetHeight(50);
  linkButton:SetNormalFontObject("GameFontNormalLarge");
  linkButton:SetText(string.format("[%s]", _G.MUI_GITHUB_SUBMIT_NEW_ISSUE_LINK));

  local fontString = linkButton:GetFontString();
  fontString:SetTextColor(tk.Constants.COLORS.LIGHT_YELLOW:GetRGB());
  fontString:SetWidth(400);

  linkButton:SetScript(
    "OnEnter", function()
      fontString:SetTextColor(tk.Constants.COLORS.WHITE:GetRGB());
    end);

  linkButton:SetScript(
    "OnLeave", function()
      fontString:SetTextColor(tk.Constants.COLORS.LIGHT_YELLOW:GetRGB());
    end);

  linkButton:SetScript(
    "OnClick", function()
      tk:ShowInputPopupWithOneButton(
        L["Open this webpage in your browser"],
          L["(CTRL+C to Copy, CTRL+V to Paste)"],
          _G.MUI_GITHUB_SUBMIT_NEW_ISSUE_LINK)
    end);

  local container = tk:CreateFrame("Frame", linkButton);
  container:SetPoint("TOPLEFT", linkButton, "BOTTOMLEFT", 0, -data.ITEM_SPACING);
  container:SetPoint(
    "TOPRIGHT", linkButton, "BOTTOMRIGHT", 0, -data.ITEM_SPACING);
  container:SetPoint("BOTTOM", parent, "BOTTOM");

  data.generateButton = gui:CreateButton(container, L["Generate Report"]);
  data.generateButton:SetPoint("CENTER");

  data.generateButton:SetScript("OnClick", function()
    PlaySound(tk.Constants.CLICK);
    local report = data:Call("GenerateReport");
    local copyText = string.format(
      "%s %s:", L["Copy Report"],
        L["(CTRL+C to Copy, CTRL+V to Paste)"]);

    copyText = tk.Strings:SetTextColorByClassFileName(copyText);

    if (not data.reportEditBox) then
      data.reportEditBox = data:Call("CreateEditBox", container, copyText, nil, 0);
    end

    data.reportFrame:SetHeight(600);

    if (obj:IsFunction(data.reportFrame.SetMinResize)) then
      data.reportFrame:SetMinResize(500, 600);
    else
      -- dragonflight:
      data.reportFrame:SetResizeBounds(500, 600);
    end

    data.generateButton:Hide();
    data.backButton:Hide();
    data.reportEditBox:SetText(report);
    data.reportEditBox.container:Show();
    data.reportEditBox:SetFocus();
    data.reportEditBox:HighlightText();

    if (not data.closeButton) then
      data.closeButton = gui:CreateButton(data.footerParent, "Close");
      data.closeButton:SetPoint("CENTER");

      data.closeButton:SetScript("OnClick", function()
        data.reportFrame.closeBtn:Click();
      end);
    end

    data.closeButton:Show();
  end);
end

do
  local report;
  local GetAddOnMetadata, GetBuildInfo, GetLocale = _G.GetAddOnMetadata,
    _G.GetBuildInfo, _G.GetLocale;
  local GetCurrentScaledResolution, UIParent = _G.GetCurrentScaledResolution,
    _G.UIParent;
  local IsMacClient, UnitFactionGroup, UnitClass = _G.IsMacClient,
    _G.UnitFactionGroup, _G.UnitClass;
  local GetSpecializationInfo, GetSpecialization = _G.GetSpecializationInfo,
    _G.GetSpecialization;
  local UnitLevel, UnitRace, GetAddOnMemoryUsage, IsAddOnLoaded = _G.UnitLevel,
    _G.UnitRace, _G.GetAddOnMemoryUsage, _G.IsAddOnLoaded;
  local UpdateAddOnMemoryUsage, GetNumAddOns, GetAddOnInfo =
    _G.UpdateAddOnMemoryUsage, _G.GetNumAddOns, _G.GetAddOnInfo;

  local function AppendLine(line, header)
    line = line:trim();

    if (not report or #report == 0) then
      if (header) then
        report = string.format("### %s", line);
      else
        report = line;
      end
    elseif (header) then
      report = string.format("%s\n\n### %s", report, line);
    else
      report = string.format("%s\n%s", report, line);
    end
  end

  local function AppendFormattedLine(line, ...)
    line = string.format(line, ...);
    AppendLine(line)
  end

  local function GetCopyOfSavedVariableTable(observer)
    local svTable = observer:GetSavedVariable();
    local copyTbl = obj:PopTable();

    tk.Tables:Fill(copyTbl, svTable);
    return copyTbl;
  end

  -- IMPORTANT: DO NOT LOCALIZE TEXT FOUND BELOW:
  obj:DefineReturns("string");
  function C_ReportIssue.Private:GenerateReport(data)
    local f = AppendFormattedLine;

    -- Append Bug Details:
    AppendLine("Bug Details", true);
    AppendLine(data.detailsEditBox:GetText());

    -- Append Steps to Replicate:
    AppendLine("Steps to Replicate", true);
    AppendLine(data.replicateBugEditBox:GetText());

    -- Get MUI Version Info:
    AppendLine("MUI Version Info", true);
    f("- MUI_Core: %s", GetAddOnMetadata("MUI_Core", "Version"));
    f("- MUI_Config: %s", GetAddOnMetadata("MUI_Config", "Version"));
    f("- MUI_Setup: %s", GetAddOnMetadata("MUI_Setup", "Version"));

    -- Get WoW Client Info:
    AppendLine("WoW Client Info", true);
    local patch, build = GetBuildInfo();
    f("- WoW version: %s (%s)", patch, build);
    f("- Locale: %s", GetLocale());

    local resolution = GetCurrentScaledResolution();

    f(
      "- Resolution: %s (UI scale: %s)", resolution,
        tk.Numbers:ToPrecision(UIParent:GetScale(), 3));
    f("- Using Mac: %s", IsMacClient() and "Yes" or "No");

    -- Basic Character Info:
    AppendLine("Basic Character Info", true);
    f("- Faction: %s", (UnitFactionGroup("Player")));

    local localizedClassName, classFileName = UnitClass("player");
    f("- Class: %s (%s)", localizedClassName, classFileName:lower());

    if (tk:IsRetail()) then
      local _, specName = GetSpecializationInfo(GetSpecialization());
      f("- Specialization: %s", specName);
    end

    f("- Level: %s", UnitLevel("player"));
    f("- Race: %s", UnitRace("player"));

    -- Captured Error Info (player details when error occurred):
    AppendLine(string.format("Captured Errors (%d)", #data.errors), true);
    for id, errorInfo in ipairs(data.errors) do
      if (id > 3) then
        break
      end -- only get the first 3
      f("- Zone: %s", errorInfo.zone);
      f("- Group size: %s", errorInfo.groupSize);
      f("- Instance type: %s", errorInfo.instanceType);
      f("- In combat: %s", errorInfo.inCombat and "Yes" or "No");
      f("- Resting: %s", errorInfo.resting and "Yes" or "No");
      f("- AFK: %s", errorInfo.isAFK and "Yes" or "No");
      f("- Dead or ghost: %s", errorInfo.isDeadOrGhost and "Yes" or "No");

      if (_G.MUI_DEBUG_MODE) then
        f("- Locals: %s", errorInfo.locals or "None");
      end

      f("- Stack Trace: %s", errorInfo.stacktrace or "None");
      AppendLine("");

      AppendLine("```lua");
      local maxLength = 3000 - (min(3, #data.errors) * 500);
      local errorMessage = string.sub(errorInfo.error, 1, min(#errorInfo.error, maxLength));
      AppendLine(errorMessage);
      AppendLine("```");

      if (id < #data.errors) then
        AppendLine("---");
      end
    end

    -- Get Lua Errors (for the current session):

    -- Append MUI_Core Global Settings:
    AppendLine("MUI_Core global settings", true);

    local globalSettings = GetCopyOfSavedVariableTable(db.global);

    -- these tables get incredibly large so ignore them
    globalSettings.installed = nil;
    globalSettings.movable = nil;

    globalSettings = obj:ToLongString(globalSettings);

    AppendLine("```lua");
    AppendLine(globalSettings);
    AppendLine("```");

    -- Append MUI_Core Current Profile Settings:
    AppendLine("MUI_Core Current Profile Settings", true);

    local profile = GetCopyOfSavedVariableTable(db.profile);
    profile = obj:ToLongString(profile);

    AppendLine("```lua");
    AppendLine(profile);
    AppendLine("```");

    -- Append TimerBars Current Profile Settings:
    local timerBarsDb = MayronUI:GetComponent("TimerBarsDatabase");
    AppendLine("TimerBars Current Profile Settings", true);

    profile = GetCopyOfSavedVariableTable(timerBarsDb.profile);
    profile = obj:ToLongString(profile);

    AppendLine("```lua");
    AppendLine(profile);
    AppendLine("```");

    -- Get Loaded AddOns:
    UpdateAddOnMemoryUsage();
    AppendLine("Loaded AddOns", true);

    for i = 1, GetNumAddOns() do
      local _, addonName = GetAddOnInfo(i);
      local usage = GetAddOnMemoryUsage(i);

      if (IsAddOnLoaded(i)) then
        local value;
        if (usage > 1000) then
          value = mfloor(usage / 10) / 100;
          value = string.format("%smb", value);
        else
          value = tk.Numbers:ToPrecision(usage, 0);
          value = string.format("%skb", value);
        end

        f("- %s (%s)", addonName, value);
      end
    end

    local generatedReport = report;
    report = nil;

    data.detailsEditBox:SetText("");
    data.replicateBugEditBox:SetText(REPLICATE_BUG_STEP_TEXT);

    return generatedReport;
  end
end
