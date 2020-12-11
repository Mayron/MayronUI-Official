-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, _, gui, obj, L = MayronUI:GetCoreComponents();

local CreateFrame = _G.CreateFrame;
local string = _G.string;

local Engine = obj:Import("MayronUI.Engine");
local C_ReportIssue = MayronUI:RegisterModule("ReportIssue", nil, true);

local TOTAL_STEPS = 3;
local TITLE_TEMPLATE = "Step %d of " .. tostring(TOTAL_STEPS);
_G.MUI_GITHUB_SUBMIT_NEW_ISSUE_LINK = "https://github.com/Mayron/MayronUI-Official/issues/new?template=bug_report.md";

function C_ReportIssue:OnInitialize(data)
  data.steps = obj:PopTable();
  data.ITEM_SPACING = 20;

  data.stepText = {
    [1] = "Found a bug? Use this form to submit an issue to the official MayronUI GitHub page.",
    [2] = "Almost done! We just need a bit more info...",
    [3] = "Click below to generate your report. Once generated, copy it into a new issue and submit it on GitHub using the link below:"
  }

  local frame = gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, "HIGH", nil, "MUI_ReportFrame");
  frame:SetSize(600, 400);
  frame:SetPoint("CENTER");

  gui:AddCloseButton(tk.Constants.AddOnStyle, frame, nil, tk.Constants.CLICK);
  gui:AddTitleBar(tk.Constants.AddOnStyle, frame, "Report Issue");
  gui:AddResizer(tk.Constants.AddOnStyle, frame);
  frame:SetMinResize(400, 400);
  frame:SetMaxResize(900, 800);

  data.panel = gui:CreatePanel(nil, nil, frame); ---@type Panel
  data.panel:SetAllPoints(true);
  data.panel:SetDimensions(1, 3);
  data.panel:SetDevMode(false);
  data.panel:GetRow(1):SetFixed(110);
  data.panel:GetRow(3):SetFixed(80);

  data:Call("SetUpHeader");
  data:Call("ShowStep", 1);
  data:Call("SetUpFooter");
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

Engine:DefineParams("number");
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

  if (not data.stepParentFrame) then
    local cell = data.panel:CreateCell();
    cell:SetInsets(15, data.ITEM_SPACING);
    data.panel:AddCells(cell);
    data.stepParentFrame = cell:GetFrame();
  end

  if (not data.steps[stepNum]) then
    local stepFrame = CreateFrame("Frame", nil, data.stepParentFrame);
    stepFrame:SetAllPoints(true);
    data:Call(string.format("RenderStep%d", stepNum), stepFrame);
    data.steps[stepNum] = stepFrame;
  end

  data.currentStep = stepNum;
  data.currentStepFrame = data.steps[stepNum];
  data.currentStepFrame:Show();
  data.stepTitle:SetText(string.format(TITLE_TEMPLATE, stepNum));
  data.intro:SetText(data.stepText[stepNum]);

  if (data.backButton and data.nextButton) then
    data.backButton:SetEnabled(stepNum > 1);
    data.nextButton:SetEnabled(stepNum < #data.steps);
  end

  if (stepNum == 3) then
    collectgarbage();
  end
end

function C_ReportIssue.Private:SetUpFooter(data)
  local panel = data.panel; ---@type Panel
  local cell = panel:CreateCell(); ---@type Cell
  cell:SetInsets(10, data.ITEM_SPACING);

  local parent = cell:GetFrame();

  local backButton = gui:CreateButton(tk.Constants.AddOnStyle, parent, "Back");
  backButton:SetPoint("RIGHT", parent, "CENTER", -10, 0);
  backButton:Disable();

  backButton:SetScript("OnClick", function()
    PlaySound(tk.Constants.CLICK);
    data:Call("ShowStep", data.currentStep - 1);
  end);

  local nextButton = gui:CreateButton(tk.Constants.AddOnStyle, parent, "Next");
  nextButton:SetPoint("LEFT", parent, "CENTER", 10, 0);
  nextButton:Disable();

  nextButton:SetScript("OnClick", function()
    PlaySound(tk.Constants.CLICK);
    data:Call("ShowStep", data.currentStep + 1);
  end);

  data.backButton = backButton;
  data.nextButton = nextButton;

  panel:AddCells(cell);
end

Engine:DefineParams("Frame", "string", "number=0", "number=1000");
Engine:DefineReturns("EditBox");
function C_ReportIssue.Private:CreateEditBox(data, parent, titleText, minLength, maxLength)
  local title = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
  title:SetPoint("TOPLEFT");
  title:SetPoint("TOPRIGHT");
  title:SetText(titleText);

  local editBox = CreateFrame("EditBox", nil, parent);
  editBox:SetMaxLetters(maxLength > 0 and maxLength or 9999);
  editBox:SetMultiLine(true);
  editBox:EnableMouse(true);
  editBox:SetAutoFocus(false);
  editBox:SetFontObject("ChatFontNormal");
  editBox:SetAllPoints(true);

  local container = gui:CreateScrollFrame(tk.Constants.AddOnStyle, parent, nil, editBox);
  container:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -data.ITEM_SPACING);
  container:SetPoint("TOPRIGHT", title, "BOTTOMRIGHT", 0, -data.ITEM_SPACING);
  container:SetPoint("BOTTOM");
  container:SetBackdrop(tk.Constants.BACKDROP_WITH_BACKGROUND);
  container:SetBackdropBorderColor(tk:GetThemeColor());
  container:SetBackdropColor(0, 0, 0, 0.5);
  container:SetScript("OnMouseUp", function() editBox:SetFocus(true) end);

  if (maxLength > 0) then
    local characters = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    characters:SetPoint("TOP", container, "BOTTOM", 0, -10);

    local charactersTemplate = "%d/1000 characters%s";
    editBox:SetScript("OnTextChanged", function()
      local size = #(editBox:GetText());
      local minText = tk.Strings.Empty;

      if (minLength > 0) then
        minText = string.format("(minimum: %d)", minLength);
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

  editBox:SetScript("OnEscapePressed", function()
    editBox:ClearFocus();
  end);

  container.ScrollFrame:ClearAllPoints();
  container.ScrollFrame:SetPoint("TOPLEFT", 10, -10);
  container.ScrollFrame:SetPoint("BOTTOMRIGHT", -10, 10);

  return editBox;
end

---------------------------------
--- Step 1:
---------------------------------
Engine:DefineParams("Frame");
function C_ReportIssue.Private:RenderStep1(data, parent)
  data.detailsEditBox = data:Call("CreateEditBox", parent, "Please describe the bug in detail:", 50);
end

Engine:DefineParams("Frame");
function C_ReportIssue.Private:RenderStep2(data, parent)
  data.replicateBugEditBox = data:Call("CreateEditBox", parent, "How can we replicate the bug?");
  data.replicateBugEditBox:SetText("Step 1: \nStep 2: \nStep 3: ");
end

Engine:DefineParams("Frame");
function C_ReportIssue.Private:RenderStep3(data, parent)
  local linkButton = CreateFrame("Button", nil, parent);
  linkButton:SetPoint("TOPLEFT");
  linkButton:SetPoint("TOPRIGHT");
  linkButton:SetHeight(50);
  linkButton:SetNormalFontObject("GameFontNormalLarge");
  linkButton:SetText(string.format("[%s]", _G.MUI_GITHUB_SUBMIT_NEW_ISSUE_LINK));

  local fontString = linkButton:GetFontString();
  fontString:SetTextColor(tk.Constants.COLORS.LIGHT_YELLOW:GetRGB());
  fontString:SetWidth(400);

  linkButton:SetScript("OnEnter", function()
    fontString:SetTextColor(tk.Constants.COLORS.WHITE:GetRGB());
  end);

  linkButton:SetScript("OnLeave", function()
    fontString:SetTextColor(tk.Constants.COLORS.LIGHT_YELLOW:GetRGB());
  end);

  linkButton:SetScript("OnClick", function()
    tk:ShowInputPopupWithOneButton("Open this webpage in your browser",
      L["(CTRL+C to Copy, CTRL+V to Paste)"],
      _G.MUI_GITHUB_SUBMIT_NEW_ISSUE_LINK)
  end);

  local container = CreateFrame("Frame", nil, linkButton);
  container:SetPoint("TOPLEFT", linkButton, "BOTTOMLEFT", 0, -data.ITEM_SPACING);
  container:SetPoint("TOPRIGHT", linkButton, "BOTTOMRIGHT", 0, -data.ITEM_SPACING);
  container:SetPoint("BOTTOM", parent, "BOTTOM");

  local generateButton = gui:CreateButton(tk.Constants.AddOnStyle, container, "Back");
  generateButton:SetPoint("CENTER");
  generateButton:SetText("Generate Issue");

  -- TODO: Move this!
  -- if (data.reportEditBox) then
  --   data.reportEditBox:SetText("");
  --   data.reportEditBox:Hide();
  -- end

  generateButton:SetScript("OnClick", function()
    PlaySound(tk.Constants.CLICK);

    local report = data:Call("GenerateReport");

    local copyText = string.format("Copy Report %s:", L["(CTRL+C to Copy, CTRL+V to Paste)"]);
    copyText = tk.Strings:SetTextColorByClass(copyText);
    data.reportEditBox = data:Call("CreateEditBox", container, copyText, nil, 0);

    _G.MUI_ReportFrame:SetHeight(600);
    _G.MUI_ReportFrame:SetMinResize(400, 600);

    data.reportEditBox:SetText(report);
    generateButton:Hide();
    data.reportEditBox:Show();
  end);
end

local GetAddOnMetadata = _G.GetAddOnMetadata;

do
  local report;

  local function AppendLine(line, header)
    if (not report or #report == 0) then
      report = line;
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

  Engine:DefineReturns("string");
  function C_ReportIssue.Private:GenerateReport(data)
    local f = AppendFormattedLine;

    -- Get MUI Version Info:
    AppendLine("MUI Version Info", true);
    f("- MUI_Core: %s", GetAddOnMetadata("MUI_Core", "Version"));
    f("- MUI_Config: %s", GetAddOnMetadata("MUI_Config", "Version"));
    f("- MUI_Setup: %s", GetAddOnMetadata("MUI_Setup", "Version"));

    -- Get WoW Client Info:
    AppendLine("WoW Client Info", true);
    local patch, build = GetBuildInfo();
    f("- WoW Version: %s (%s)", patch, build);
    f("- Locale: %s", GetLocale());

    local resolution = GetCurrentScaledResolution();

    f("- Resolution: %s (UI scale: %s)", resolution, UIParent:GetScale());
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
    -- f("- Zone: %s");
    -- f("- Group Size: %s");
    -- f("- In Combat Size: %s");

    -- Append Bug Details:
    AppendLine("Bug Details", true);
    AppendLine(data.detailsEditBox:GetText());

    -- Append Steps to Replicate:
    AppendLine("Steps to Replicate", true);
    AppendLine(data.replicateBugEditBox:GetText());

    -- Get Lua Errors (for the current session):

    -- Append MUI_Core Global Settings:
    AppendLine("MUI_Core Global Settings", true);
    local global = db.global:ToLongString();
    AppendLine(global);

    -- Append MUI_Core Current Profile Settings:
    AppendLine("MUI_Core Current Profile Settings", true);
    local profile = db.profile:ToLongString();
    AppendLine(profile);

    -- Get Loaded AddOns:
    _G.UpdateAddOnMemoryUsage();
    AppendLine("Loaded AddOns", true);

    for i = 1, GetNumAddOns() do
      local _, addonName = GetAddOnInfo(i);
      local usage = GetAddOnMemoryUsage(i);

      if (IsAddOnLoaded(i)) then
        local value;
        if (usage > 1000) then
          value = usage / 1000;
          value = tk.Numbers:ToPrecision(value, 1);
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

    return generatedReport;
  end
end