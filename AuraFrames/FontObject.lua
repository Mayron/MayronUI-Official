local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local LSM = LibStub("LibSharedMedia-3.0");

-- Import used global references into the local namespace.
local unpack = unpack;

-----------------------------------------------------------------
-- Function SetFontObjectProperties
-----------------------------------------------------------------
function AuraFrames:SetFontObjectProperties(FontObject, Font, Size, Outline, Monochrome, Color)

  local Flags;

  if Outline ~= "NONE" then
    Flags = Outline;
  end

  if Monochrome == true then
    Flags = (Flags ~= nil and (Flags .. ",") or "") .. "MONOCHROME";
  end
  
  local LsmFont = LSM:Fetch("font", Font);
  
  if LsmFont then
    FontObject:SetFont(LSM:Fetch("font", Font), Size, Flags);
  end
  
  if Color then
    FontObject:SetTextColor(unpack(Color));
  end

end


-----------------------------------------------------------------
-- Function SetFontObjectPropertyList
-----------------------------------------------------------------
function AuraFrames:SetFontObjectPropertyList(FontObject, Properties)

  return self:SetFontObjectProperties(FontObject, Properties.Font, Properties.Size, Properties.Outline, Properties.Monochrome, Properties.Color);

end
