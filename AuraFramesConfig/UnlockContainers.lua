local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");

AuraFramesConfig.ContainersUnlocked = false;

local UnlockDialog;

-----------------------------------------------------------------
-- Local Function ShowUnlockDialog
-----------------------------------------------------------------
local function ShowUnlockDialog()

  if not UnlockDialog then
    local f = CreateFrame("Frame", nil, UIParent)
    f:SetFrameStrata("TOOLTIP");
    f:SetFrameLevel(10);
    f:SetToplevel(true)
    f:EnableMouse(true)
    f:SetClampedToScreen(true)
    f:SetWidth(360)
    f:SetHeight(150)
    f:SetBackdrop{
      bgFile="Interface\\DialogFrame\\UI-DialogBox-Background" ,
      edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
      tile = true,
      insets = {left = 11, right = 12, top = 12, bottom = 11},
      tileSize = 32,
      edgeSize = 32,
    }
    f:SetPoint("TOP", 0, -50)
    f:Hide()
    f:SetScript("OnShow", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION) end)	-- 2018-07-23 CB: Fixed ID
    f:SetScript("OnHide", function() PlaySound(SOUNDKIT.GS_TITLE_OPTION_EXIT) end)	-- 2018-07-23 CB: Fixed ID

    local header = f:CreateTexture(nil, "ARTWORK")
    header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
    header:SetWidth(256); header:SetHeight(64)
    header:SetPoint("TOP", 0, 12)

    local title = f:CreateFontString("ARTWORK")
    title:SetFontObject("GameFontNormal")
    title:SetPoint("TOP", header, "TOP", 0, -14)
    title:SetText("Aura Frames")

    local desc = f:CreateFontString("ARTWORK")
    desc:SetFontObject("GameFontHighlight")
    desc:SetJustifyV("TOP")
    desc:SetJustifyH("LEFT")
    desc:SetPoint("TOPLEFT", 18, -32)
    desc:SetPoint("BOTTOMRIGHT", -18, 48)
    desc:SetText("Containers unlocked. Move them now and click Lock when you are done.\n\nYou can right click on a container to directly open the container configuration.")

    local lockBars = CreateFrame("CheckButton", nil, f, "OptionsButtonTemplate")
    lockBars:SetText("Lock");

    lockBars:SetScript("OnClick", function(self)
      AuraFramesConfig:UnlockContainers(false);
    end)

    --position buttons
    lockBars:SetPoint("BOTTOMRIGHT", -14, 14)

    UnlockDialog = f;
  end
  
  UnlockDialog:Show();
  
end


-----------------------------------------------------------------
-- Function SetConfigMode
-----------------------------------------------------------------
function AuraFramesConfig:UnlockContainers(Unlock)
  
  self.ContainersUnlocked = Unlock;
  
  for Id, Config in pairs(AuraFrames.db.profile.Containers) do
  
    self:GetModule(Config.Type):UnlockContainer(Id, Unlock);
  
  end
  
  if Unlock == true then
  
    ShowUnlockDialog();
    self:Close();
  
  else
  
    if UnlockDialog then
      UnlockDialog:Hide();
    end
    
    self:Show();
    
  end

end

