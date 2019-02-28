local AuraFramesConfig = LibStub("AceAddon-3.0"):NewAddon("AuraFramesConfig", "AceConsole-3.0");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

-----------------------------------------------------------------
-- Function OnInitialize
-----------------------------------------------------------------
function AuraFramesConfig:OnInitialize()

end

-----------------------------------------------------------------
-- Function OnEnable
-----------------------------------------------------------------
function AuraFramesConfig:OnEnable()

  local CloseSpecialWindowsOld = CloseSpecialWindows;
  
  CloseSpecialWindows = function()
    local Result = CloseSpecialWindowsOld();
    
    if self:IsExportWindowShown() == true then
      self:CloseExportWindow()
      return true;
    end
    
    if self:IsImportWindowShown() == true then
      self:CloseImportWindow()
      return true;
    end
    
    if self:IsListEditorShown() == true then
      self:CloseListEditor()
      return true;
    end
    
    return AuraFramesConfig:Close() or Result;
  end

  -- Register database callbacks
  AuraFrames.db.RegisterCallback(self, "OnProfileChanged", "DatabaseChanged");
  AuraFrames.db.RegisterCallback(self, "OnProfileCopied", "DatabaseChanged");
  AuraFrames.db.RegisterCallback(self, "OnProfileReset", "DatabaseChanged");

end


-----------------------------------------------------------------
-- Function OnDisable
-----------------------------------------------------------------
function AuraFramesConfig:OnDisable()

end


-----------------------------------------------------------------
-- Function DatabaseChanged
-----------------------------------------------------------------
function AuraFramesConfig:DatabaseChanged()

  self:RefreshTree();
  
  self:RefreshContent();

end


