local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local LSM = LibStub("LibSharedMedia-3.0");

-- Import used global references into the local namespace.
local pairs = pairs;

-- Default bar texture list
local StatusBarTextures = {
  ["Aluminum"]    = [[Interface\Addons\AuraFrames\Textures\Aluminum.tga]],
  ["Armory"]      = [[Interface\Addons\AuraFrames\Textures\Armory.tga]],
  ["BantoBar"]    = [[Interface\Addons\AuraFrames\Textures\BantoBar.tga]],
  ["DarkBottom"]  = [[Interface\Addons\AuraFrames\Textures\Darkbottom.tga]],
  ["Default"]     = [[Interface\Addons\AuraFrames\Textures\Default.tga]],
  ["Flat"]        = [[Interface\Addons\AuraFrames\Textures\Flat.tga]],
  ["Glaze"]       = [[Interface\Addons\AuraFrames\Textures\Glaze.tga]],
  ["Gloss"]       = [[Interface\Addons\AuraFrames\Textures\Gloss.tga]],
  ["Graphite"]    = [[Interface\Addons\AuraFrames\Textures\Graphite.tga]],
  ["Minimalist"]  = [[Interface\Addons\AuraFrames\Textures\Minimalist.tga]],
  ["Otravi"]      = [[Interface\Addons\AuraFrames\Textures\Otravi.tga]],
  ["Smooth"]      = [[Interface\Addons\AuraFrames\Textures\Smooth.tga]],
  ["Smooth v2"]   = [[Interface\Addons\AuraFrames\Textures\Smoothv2.tga]],
  ["Striped"]     = [[Interface\Addons\AuraFrames\Textures\Striped.tga]],
};

-----------------------------------------------------------------
-- Function SharedMadiaInitialize
-----------------------------------------------------------------
function AuraFrames:SharedMadiaInitialize()

  for Name, Texture in pairs(StatusBarTextures) do
  
    if not LSM:Fetch("statusbar", Name, true) then
      LSM:Register("statusbar", Name, Texture);
    end
  
  end

end

