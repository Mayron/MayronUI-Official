local AuraFrames = LibStub("AceAddon-3.0"):NewAddon("AuraFrames", "AceConsole-3.0");

-- Import used global references into the local namespace.
local tinsert, tremove, tconcat, sort = tinsert, tremove, table.concat, sort;
local fmt, tostring = string.format, tostring;
local select, pairs, next, type, unpack = select, pairs, next, type, unpack;
local loadstring, assert, error = loadstring, assert, error;
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget;
local GetTime, StaticPopupDialogs, StaticPopup_Show = GetTime, StaticPopupDialogs, StaticPopup_Show;

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: BuffFrame, TemporaryEnchantFrame, LibStub, StaticPopup_Hide

local BuffFrame, TemporaryEnchantFrame = BuffFrame, TemporaryEnchantFrame;

-- Expose the addon to the global namespace for debugging.
_G["AuraFrames"] = AuraFrames;
_G["af"] = AuraFrames;


-----------------------------------------------------------------
-- Function OnInitialize
-----------------------------------------------------------------
function AuraFrames:OnInitialize()

end


-----------------------------------------------------------------
-- Function OnEnable
-----------------------------------------------------------------
function AuraFrames:OnEnable()

  self:SharedMadiaInitialize();

  self:DatabaseInitialize();

  self:CheckBlizzardAuraFrames();
  
  if self.db.profile.HideBossModsBars == true then
    LibStub("LibAura-1.0"):GetModule("BossMods-1.0"):SetBossModBarsVisibility(false);
  end
  
  self:RegisterChatCommand("af", "OpenConfigDialog");
  self:RegisterChatCommand("afver", "DumpVersion");
  
  self:RegisterBlizzardOptions();
  
  self:SetSpellCooldownList();
  self:SetInternalCooldownList();

  self.CancelCombatAura:Update();

  self:CreateAllContainers();

end


-----------------------------------------------------------------
-- Function OnDisable
-----------------------------------------------------------------
function AuraFrames:OnDisable()

  self:DeleteAllContainers();

end


-----------------------------------------------------------------
-- Function DumpVersion
-----------------------------------------------------------------
function AuraFrames:DumpVersion()

  self:Print("Aura Frames Version Information");
  self:Print("  Version: |cffff0000"..self.Version.String.."|r");
  self:Print("  Revision: "..self.Version.Revision);
  self:Print("  Date: "..self.Version.Date);

end


-----------------------------------------------------------------
-- Function HideBlizzardAuraFrames
-----------------------------------------------------------------
function AuraFrames:CheckBlizzardAuraFrames()

  if self.db.profile.HideBlizzardAuraFrames ~= true then
    return;
  end

  -- Hide the default Blizz buff frame
  BuffFrame:Hide();
  TemporaryEnchantFrame:Hide();
  
  -- Hook the onShow script so we can hide it again.
  BuffFrame:HookScript("OnShow", AuraFrames.BlizzardFrameOnShow);
  TemporaryEnchantFrame:HookScript("OnShow", AuraFrames.BlizzardFrameOnShow);
  
end


-----------------------------------------------------------------
-- Function BlizzardFrameOnShow
-----------------------------------------------------------------
function AuraFrames.BlizzardFrameOnShow(Frame)
  -- No self!
  
  if AuraFrames.db.profile.HideBlizzardAuraFrames ~= true then
    return;
  end
  
  Frame:Hide();

end


-----------------------------------------------------------------
-- Function Confirm
-----------------------------------------------------------------
function AuraFrames:Confirm(Message, Func, ButtonText1, ButtonText2)
  
  if not StaticPopupDialogs["AURAFRAMESCONFIG_CONFIRM_DIALOG"] then

    StaticPopupDialogs["AURAFRAMESCONFIG_CONFIRM_DIALOG"] = {
      preferredIndex = 3,
      timeout = 0,
      whileDead = 1,
      hideOnEscape = 1,
    };
    
  end
  
  local Popup = StaticPopupDialogs["AURAFRAMESCONFIG_CONFIRM_DIALOG"];
  Popup.text = Message;

  Popup.button1 = ButtonText1 or "Yes";
  Popup.button2 = ButtonText2 or "No";

  if Func then
    Popup.OnAccept = function()
      Func(true);
    end
  else
    Popup.OnAccept = nil;
  end
  
  if Func then
    Popup.OnCancel = function()
      Func(false);
    end
  else
    Popup.OnCancel = nil;
  end

  StaticPopup_Show("AURAFRAMESCONFIG_CONFIRM_DIALOG");

end


-----------------------------------------------------------------
-- Function Message
-----------------------------------------------------------------
function AuraFrames:Message(Message, Func, ButtonText)

  if not StaticPopupDialogs["AURAFRAMESCONFIG_MESSAGE_DIALOG"] then

    StaticPopupDialogs["AURAFRAMESCONFIG_MESSAGE_DIALOG"] = {
      preferredIndex = 3,
      button1 = "Okay",
      timeout = 0,
      whileDead = 1,
      hideOnEscape = 1,
    };

  end

  local Popup = StaticPopupDialogs["AURAFRAMESCONFIG_MESSAGE_DIALOG"];
  Popup.text = Message;
  
  Popup.button1 = ButtonText or "Okay";

  if Func then
    Popup.OnAccept = function()
      Func(true);
    end
  else
    Popup.OnAccept = nil;
  end

  StaticPopup_Show("AURAFRAMESCONFIG_MESSAGE_DIALOG");

end


-----------------------------------------------------------------
-- Function Input
-----------------------------------------------------------------
function AuraFrames:Input(Message, EditBoxText, Func, ButtonText1, ButtonText2, FuncInputValidation)
  
  if not StaticPopupDialogs["AURAFRAMESCONFIG_INPUT_DIALOG"] then

    StaticPopupDialogs["AURAFRAMESCONFIG_INPUT_DIALOG"] = {
      preferredIndex = 3,
      timeout = 0,
      whileDead = 1,
      hideOnEscape = 1,
      hasEditBox = 1,
    };
    
  end
  
  local Popup = StaticPopupDialogs["AURAFRAMESCONFIG_INPUT_DIALOG"];
  Popup.text = Message;

  Popup.button1 = ButtonText1 or "Okay";
  Popup.button2 = ButtonText2 or "Cancel";

  if Func then
    Popup.OnAccept = function(self)
      Func(true, self.editBox:GetText());
    end
  else
    Popup.OnAccept = nil;
  end
  
  if Func then
    Popup.OnCancel = function(self)
      Func(false, self.editBox:GetText());
    end
  else
    Popup.OnCancel = nil;
  end
  
  Popup.OnShow = function(self)
  
    self.editBox:SetText(EditBoxText);

    self.editBox:SetScript("OnEscapePressed", function()
      StaticPopup_Hide("AURAFRAMESCONFIG_INPUT_DIALOG");
      if Popup.OnCancel then
        Popup.OnCancel(self);
      end
    end);
    
    self.editBox:SetScript("OnEnterPressed", function()
      if FuncInputValidation and not FuncInputValidation(self.editBox, self.editBox:GetText()) then
        return;
      end
      StaticPopup_Hide("AURAFRAMESCONFIG_INPUT_DIALOG");
      if Popup.OnAccept then
        Popup.OnAccept(self);
      end
    end);

    if FuncInputValidation then
      self.editBox:SetScript("OnTextChanged", function(self, UserInput)
        if UserInput == false then
          return;
        end
        if FuncInputValidation(self, self:GetText()) then
          self:GetParent().button1:Enable();
        else
          self:GetParent().button1:Disable();
        end
      end);
      if FuncInputValidation(self.editBox, self.editBox:GetText()) then
        self.button1:Enable();
      else
        self.button1:Disable();
      end
    else
      self.editBox:SetScript("OnTextChanged", nil);
      self.button1:Enable();
    end

  end

  StaticPopup_Show("AURAFRAMESCONFIG_INPUT_DIALOG");

end
