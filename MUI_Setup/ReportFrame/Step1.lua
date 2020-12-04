-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, _, gui, obj, L = MayronUI:GetCoreComponents();

local CreateFrame = _G.CreateFrame;
local ITEM_SPACING = 20;

local C_ReportIssue = _G.MayronUI:RegisterModule("ReportIssue", nil, true);

function C_ReportIssue:OnInitialize(data)
  local frame = gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, "HIGH", nil, "MUI_ReportFrame");

  frame:SetSize(600, 400);
  frame:SetPoint("CENTER");

  gui:AddCloseButton(tk.Constants.AddOnStyle, frame, nil, tk.Constants.CLICK);
  gui:AddTitleBar(tk.Constants.AddOnStyle, frame, "Report Issue");
  gui:AddResizer(tk.Constants.AddOnStyle, frame);
  frame:SetMinResize(400, 400);
  frame:SetMaxResize(900, 800);

  data.content = gui:CreatePanel(nil, nil, frame); ---@type Panel
  data.content:SetAllPoints(true);
  data.content:SetDimensions(1, 3);
  data.content:SetDevMode(false);
  data.content:GetRow(1):SetFixed(140);
  data.content:GetRow(3):SetFixed(80);

  data:Call("SetUpHeader");
  data:Call("SetUpBody");
  data:Call("SetUpFooter");
  -- local body = content:CreateCell(); ---@type Cell
  -- local footer = content:CreateCell(); ---@type Cell

  -- /mui report
end

function C_ReportIssue.Private:SetUpHeader(data)
  local content = data.content; ---@type Panel
  local cell = data.content:CreateCell(); ---@type Cell
  cell:SetInsets(30, ITEM_SPACING, 10, ITEM_SPACING);

  local title = cell:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
  title:SetPoint("TOPLEFT");
  title:SetPoint("TOPRIGHT");
  title:SetText("Step 1 of 3");

  local intro = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  intro:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -ITEM_SPACING);
  intro:SetPoint("BOTTOMRIGHT", cell:GetFrame(), "BOTTOMRIGHT");
  intro:SetText("Found a bug? Use this form to submit an issue to the official MayronUI GitHub page.");
  intro:SetJustifyV("TOP");
  tk:SetFontSize(intro, 16);

  content:AddCells(cell);
end

function C_ReportIssue.Private:SetUpBody(data)
  local content = data.content; ---@type Panel
  local cell = data.content:CreateCell(); ---@type Cell
  cell:SetInsets(15, ITEM_SPACING, 0, ITEM_SPACING);

  local parent = cell:GetFrame();

  local title = cell:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
  title:SetPoint("TOPLEFT");
  title:SetPoint("TOPRIGHT");
  title:SetText("What is the bug? Please describe it in detail:");

  local detailsBox = CreateFrame("EditBox");
  detailsBox:SetMaxLetters(2000);
  detailsBox:SetMultiLine(true);
  detailsBox:EnableMouse(true);
  detailsBox:SetAutoFocus(false);
  detailsBox:SetFontObject("ChatFontNormal");

  detailsBox:SetScript("OnEscapePressed", function()
    detailsBox:ClearFocus();
  end);

  local detailsContainer = gui:CreateScrollFrame(tk.Constants.AddOnStyle, parent, nil, detailsBox);
  detailsContainer:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -ITEM_SPACING);
  detailsContainer:SetPoint("TOPRIGHT", title, "BOTTOMRIGHT", 0, -ITEM_SPACING);
  detailsContainer:SetPoint("BOTTOM");
  detailsContainer:SetBackdrop(tk.Constants.BACKDROP_WITH_BACKGROUND);
  detailsContainer:SetBackdropBorderColor(tk:GetThemeColor());
  detailsContainer:SetBackdropColor(0, 0, 0, 0.5);

  detailsContainer.ScrollFrame:ClearAllPoints();
  detailsContainer.ScrollFrame:SetPoint("TOPLEFT", 10, -10);
  detailsContainer.ScrollFrame:SetPoint("BOTTOMRIGHT", -10, 10);
  detailsBox:SetAllPoints(true);

  content:AddCells(cell);
end

function C_ReportIssue.Private:SetUpFooter(data)
  local content = data.content; ---@type Panel
  local cell = content:CreateCell(); ---@type Cell
  cell:SetInsets(10, ITEM_SPACING);

  local parent = cell:GetFrame();

  local backButton = gui:CreateButton(tk.Constants.AddOnStyle, parent, "Back");
  backButton:SetPoint("RIGHT", parent, "CENTER", -10, 0);
  backButton:Disable();

  local nextButton = gui:CreateButton(tk.Constants.AddOnStyle, parent, "Next");
  nextButton:SetPoint("LEFT", parent, "CENTER", 10, 0);

  content:AddCells(cell);
end