local AceGUI = LibStub and LibStub("AceGUI-3.0", true);

local Type, Version = "AuraFramesWindow", 1;
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local select, pairs = select, pairs;

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent;

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: GameFontHighlightSmall


-----------------------------------------------------------------
-- Local Function AuraFramesWindow_OnAcquire
-----------------------------------------------------------------
local function AuraFramesWindow_OnAcquire(self)

  local Window = self;

  self:WindowOnAcquire();
  
  if not self._AuraFramesFrame then
  
    self._AuraFramesFrame = CreateFrame("Frame", nil, self.frame);
    
    self._AuraFramesFrame:SetPoint("TOPRIGHT", -21, 0);
    self._AuraFramesFrame:SetWidth(30);
    self._AuraFramesFrame:SetHeight(26);
    
    local Background = self._AuraFramesFrame:CreateTexture(nil, "BORDER")
    Background:SetAllPoints(self._AuraFramesFrame);
    Background:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border");
    Background:SetTexCoord(0.69, 0.75, 0, 0.395);
    
    local Button = CreateFrame("Button", nil, self._AuraFramesFrame);
    Button:SetWidth(32);
    Button:SetHeight(32);
    Button:SetNormalTexture("Interface\\Buttons\\UI-Panel-CollapseButton-Up");
    Button:SetPushedTexture("Interface\\Buttons\\UI-Panel-CollapseButton-Down");
    Button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight");
    Button:SetPoint("CENTER", self._AuraFramesFrame, "CENTER", 1, -2);
    
    Button:SetScript("OnClick", function() Window:Fire("OnCollapse"); end);
    
  end
  
  
end


-----------------------------------------------------------------
-- Local Function AuraFramesWindow_OnRelease
-----------------------------------------------------------------
local function AuraFramesWindow_OnRelease(self)

  self:WindowOnRelease();

end


-----------------------------------------------------------------
-- Function Constructor
-----------------------------------------------------------------
local function Constructor()

  local Window = AceGUI:Create("Window");
  
  Window.WindowOnAcquire = Window.OnAcquire;
  Window.WindowOnRelease = Window.OnRelease;
  
  Window.OnAcquire = AuraFramesWindow_OnAcquire;
  Window.OnRelease = AuraFramesWindow_OnRelease;
  Window.type = Type;
  
  AceGUI:RegisterAsContainer(Window);
  
  return Window;

end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
