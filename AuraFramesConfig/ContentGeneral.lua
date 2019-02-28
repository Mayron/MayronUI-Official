local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");


-----------------------------------------------------------------
-- Function ContentGeneral
-----------------------------------------------------------------
function AuraFramesConfig:ContentGeneral()

  self.Content:SetLayout("List");
  
  self.Content:AddText("General\n", GameFontNormalLarge);

  self.Content:AddHeader("Version Information");
  
  local VersionGroup = AceGUI:Create("SimpleGroup");
  VersionGroup:SetRelativeWidth(1);
  VersionGroup:SetLayout("Flow");
  self:EnhanceContainer(VersionGroup)
  self.Content:AddChild(VersionGroup);

  VersionGroup:AddText("You are running the following version of Aura Frames:");
  VersionGroup:AddSpace();
  
  VersionGroup:AddText("Version", nil, 120);
  VersionGroup:AddText(": |cffff0000"..AuraFrames.Version.String.."|r", nil, 430);
  
  VersionGroup:AddText("Revision", nil, 120);
  VersionGroup:AddText(": "..AuraFrames.Version.Revision, nil, 430);
  
  VersionGroup:AddText("Date", nil, 120);
  VersionGroup:AddText(": "..AuraFrames.Version.Date, nil, 430);

  self.Content:AddSpace(1);

  VersionGroup:AddText("Database version", nil, 120);
  VersionGroup:AddText(": "..AuraFrames.DatabaseVersion, nil, 430);
  
  self.Content:AddSpace(1);
  
  self.Content:AddHeader("Support");

  self.Content:AddText("When reporting a problem, please include the version information found on top of this page. Support can be found on the following places:\n\n")
  
  local SupportGroup = AceGUI:Create("SimpleGroup");
  SupportGroup:SetRelativeWidth(1);
  SupportGroup:SetLayout("Flow");
  self:EnhanceContainer(SupportGroup)
  self.Content:AddChild(SupportGroup);
  
  SupportGroup:AddText("Tickets:", nil, 60);
  
  local TicketsTextBox = AceGUI:Create("EditBox");
  TicketsTextBox:SetWidth(450);
  TicketsTextBox:SetText("http://wow.curseforge.com/addons/aura-frames/tickets/");
  TicketsTextBox:DisableButton(true);
  TicketsTextBox:SetCallback("OnTextChanged", function()
    TicketsTextBox:SetText("http://wow.curseforge.com/addons/aura-frames/tickets/");
    TicketsTextBox.editbox:HighlightText(0, TicketsTextBox.editbox:GetNumLetters());
  end);
  TicketsTextBox:SetCallback("OnEnter", function()
    TicketsTextBox.editbox:HighlightText(0, TicketsTextBox.editbox:GetNumLetters());
    TicketsTextBox:SetFocus();
  end);
  SupportGroup:AddChild(TicketsTextBox);
  
  SupportGroup:AddText(" ", nil, 65);
  SupportGroup:AddText("Mouse over an URL to select it and press then CTRL+C to copy the text to the clipboard.", GameFontHighlightSmall, 450);

  self.Content:AddSpace(1);
  
  self.Content:AddHeader("Credits");

  self.Content:AddText("This addon is developed and mainted by |cff0070DDBeautiuz|r (|cff9382C9Nexiuz|r) @ Bloodhoof EU.\n\nThe two most important addons that helped me and inspired me are SatrinaBuffFrame and LibBuffet.\n\nSpecial thanks goes to |cff9382C9Ripsomeone|r @ Bloodhoof EU for testing and helping me giving the addon his current form.");

  self.Content:AddSpace();

  self.Content:AddText("Also thanks goes to Chaud from Curse for helping me out with compiling internal data from WoWDB.com that is used for internal cooldowns.");

  self.Content:AddSpace();

end
