local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

--[[

Sinds 4.0.1 Blizzard made CancelUnitBuff and CancelItemTempEnchantment
protected so normal addons without secure templates cant cancel auras
anymore. This script allows the user to cancel auras without using
secure templates. This is only working outside combat!

This script also handles the normal canceling of auras that are still
working like nothing...

]]--

-- Import used global references into the local namespace.
local pairs, ipairs = pairs, ipairs;


local RestoreHandlers, BackupHandlers, FireHandler;

-- Create the secure button we use for canceling auras.
local CancelAuraButton = CreateFrame("Button", "AuraFramesCancelAuraButton", UIParent, "SecureActionButtonTemplate");
CancelAuraButton:Hide();
CancelAuraButton:SetFrameStrata("HIGH")
CancelAuraButton:RegisterForClicks("RightButtonUp");
CancelAuraButton:SetScript("OnLeave", function(self, ...)
  CancelAuraButton:Hide();
  CancelAuraButton:ClearAllPoints();
  RestoreHandlers();
  FireHandler("OnLeave", ...);
end);
CancelAuraButton:SetAttribute("type2", "cancelaura");

for _, Handler in ipairs({"OnClick", "OnMouseDown", "OnMouseUp", "OnKeyDown", "OnKeyUp"}) do
  CancelAuraButton:HookScript(Handler, function(self, ...) FireHandler(Handler, ...); end);
end

-- The current frame that we are based on.
local CancelAuraFrame = nil;

-- The old handlers of the current frame that we are based on.
local CancelAuraFrameHandlers = {};

-- If we are in combat or not.
local InCombat = false;


-- Frame to track for enter/leaving combat.
local EventFrame = CreateFrame("Frame");
EventFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
EventFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
EventFrame:SetScript("OnEvent", function(self, Event)

  if Event == "PLAYER_REGEN_DISABLED" then
  
    InCombat = true;
    
    if CancelAuraButton:IsShown() then
    
      -- When PLAYER_REGEN_DISABLED fires, we still can change secure buttons!
      -- We disable the secure button so we don't have problems in combat with it.
      CancelAuraButton:Hide();
      CancelAuraButton:ClearAllPoints();
      RestoreHandlers();
    
    end
  
  elseif Event == "PLAYER_REGEN_ENABLED" then
  
    InCombat = false;
  
  end

end);

-----------------------------------------------------------------
-- Local Function FireHandler
-----------------------------------------------------------------
function FireHandler(Handler, ...)

  if not CancelAuraFrame:HasScript(Handler) then
    return;
  end

  local Function = CancelAuraFrame:GetScript(Handler);
  
  if Function then
    Function(CancelAuraFrame, ...);
  end

end


-----------------------------------------------------------------
-- Local Function BackupHandlers
-----------------------------------------------------------------
function BackupHandlers()

  for _, Handler in ipairs({"OnEnter", "OnLeave"}) do
    CancelAuraFrameHandlers[Handler] = CancelAuraFrame:GetScript(Handler);
    CancelAuraFrame:SetScript(Handler, nil);
  end

end


-----------------------------------------------------------------
-- Local Function RestoreHandlers
-----------------------------------------------------------------
function RestoreHandlers()

  for Handler, _ in pairs(CancelAuraFrameHandlers) do
    CancelAuraFrame:SetScript(Handler, CancelAuraFrameHandlers[Handler]);
  end

end


-----------------------------------------------------------------
-- Function SetCancelAuraFrame
-----------------------------------------------------------------
function AuraFrames:SetCancelAuraFrame(Frame, Aura)

  -- We can't change secure buttons in combat.
  if InCombat == true then
    return;
  end

  -- Check if we can cancel the aura.
  if not ((Aura.Type == "HELPFUL" and (Aura.Unit == "player" or Aura.Unit == "pet" or Aura.Unit == "vehicle")) or Aura.Type == "WEAPON") then
    return;
  end

  if Aura.Type == "HELPFUL" then
  
    CancelAuraButton:SetAttribute("unit", Aura.Unit);
    CancelAuraButton:SetAttribute("index", Aura.Index);
    CancelAuraButton:SetAttribute("target-slot", nil);
  
  else -- WEAPON
  
    CancelAuraButton:SetAttribute("unit", nil);
    CancelAuraButton:SetAttribute("index", nil);
    CancelAuraButton:SetAttribute("target-slot", Aura.Index);
    
  end

  -- Check if we are already on the frame.
  if CancelAuraFrame == Frame then
    return;
  end

  CancelAuraFrame = Frame;
  
  BackupHandlers();
  
  CancelAuraButton:SetAllPoints(Frame);
  CancelAuraButton:Show();
  
  if CancelAuraButton:IsShown() == nil then
    -- We are maybe in combat and we couldnt show the button.
    -- We are directly restoring the old handlers and leave it.
    
    RestoreHandlers();
    return;
  
  end

  if Frame._CancelAuraHook ~= true then

    Frame:HookScript("OnHide", function(Frame)
      if Frame == CancelAuraFrame and InCombat == false then
        CancelAuraButton:Hide();
        CancelAuraButton:ClearAllPoints();
        RestoreHandlers();
        CancelAuraFrame = nil;
      end
    end);

    Frame._CancelAuraHook = true;

  end
  
end


-----------------------------------------------------------------
-- Function CancelAura
-----------------------------------------------------------------
function AuraFrames:CancelAura(Aura)

  if Aura.Type == "TOTEM" then

    -- DestroyTotem is a protected function now.
    --DestroyTotem(Aura.Index);
  
 end

end

