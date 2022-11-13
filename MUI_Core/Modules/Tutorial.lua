-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, db, _, gui, _, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local GetLocale = _G.GetLocale;

-- Register and Import Modules -----------

local C_Tutorial = MayronUI:RegisterModule("TutorialModule", "Tutorial");
local GetAddOnMetadata = _G.GetAddOnMetadata;

function C_Tutorial:OnInitialize()
  local show = tk:GetTutorialShowState(db.profile.installMessage);

  if (show) then
    self:SetEnabled(true);
  end
end

function C_Tutorial:OnEnable()
  local frame = tk:CreateFrame("Frame");
  frame:SetFrameStrata("TOOLTIP");
  frame:SetSize(350, 230);
  frame:SetPoint("CENTER");

  if (GetLocale() == "ruRU") then
    frame:SetWidth(500);
  end

  gui:CreateDialogBox(nil, nil, frame);
  gui:AddCloseButton(frame);

  local version = GetAddOnMetadata("MUI_Core", "Version");

  local title = tk.Strings:Concat(L["Version"], "[", version, "]");
  gui:AddTitleBar(frame, title);

  frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  tk:SetFontSize(frame.text, 14);
  frame.text:SetWordWrap(true);
  frame.text:SetPoint("TOPLEFT", 10, -40);
  frame.text:SetPoint("TOPRIGHT", -10, -40);

  local tutorialMessage = L["THANK_YOU_FOR_INSTALLING"];
  local subMessage = tk.Strings:SetTextColorByKey(L["(type '/mui' to list all slash commands)"], "GOLD");

  frame.text:SetText(tk.Strings:Join("\n\n", tutorialMessage, subMessage));

  local configButton = gui:CreateButton(frame, L["Open Config Menu"]);
  configButton:SetPoint("TOP", frame.text, "BOTTOM", 0, -20);
  configButton:SetScript("OnClick", function()
    MayronUI:TriggerCommand("config");
    frame:Hide();
    db.profile.installMessage = version;
  end);

  if (GetLocale() == "ruRU") then
    configButton:SetWidth(250);
  end

  local website = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  website:SetPoint("TOP", configButton, "BOTTOM", 0, -15);
  tk:SetFontSize(website, 20);
  website:SetText(tk.Strings:SetTextColorByKey("https://mayronui.com", "LIGHT_YELLOW"));

  frame.closeBtn:HookScript("OnClick", function()
    db.profile.installMessage = version;
  end);
end