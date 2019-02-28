local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

-----------------------------------------------------------------
-- Version information
-----------------------------------------------------------------
AuraFrames.Version = {
  
  String   = "1.5.10-Release",
  Revision = "494",
  Date     = date("%m/%d/%y %H:%M:%S", tonumber("2017-04-20 19:00:31 -0500 (Thu, 20 Apr 2017)")),
  
};

if AuraFrames.Version.String == "@".."project-version".."@" then

  AuraFrames.Version.String = "SVN Repository";
  AuraFrames.Version.Revision = "SVN Repository";

end
