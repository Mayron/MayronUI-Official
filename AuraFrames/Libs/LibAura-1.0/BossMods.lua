-----------------------------------------------------------------
--
--  File: BossMods.lua
--
--  Author: Alex <Nexiuz> Elderson
--
--  Description:
--
--    Hook into boss mods to receive timer information.
--
--    The following Boss Mods are supported: DBM, DXE and BigWings
--
-----------------------------------------------------------------


local LibAura = LibStub("LibAura-1.0");

local Major, Minor = "BossMods-1.0", 0;
local Module = LibAura:NewModule(Major, Minor);

if not Module then return; end -- No upgrade needed.

-- Make sure that we dont have old unit/types if we upgrade.
LibAura:UnregisterModuleSource(Module, nil, nil);

-- Register the unit/types.
LibAura:RegisterModuleSource(Module, "bossmod", "ALERT");


-- Import used global references into the local namespace.
local tinsert, tremove, tconcat, sort = tinsert, tremove, table.concat, sort;
local fmt, tostring, find = string.format, tostring, string.find;
local select, pairs, ipairs, next, type, unpack = select, pairs, ipairs, next, type, unpack;
local loadstring, assert, error = loadstring, assert, error;
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget;
local UnitName = UnitName;
local abs = abs;
local GetTime, _G = GetTime, _G;

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: DBM, DXE, BigWigs


-- Internal db used for storing auras, spellbooks and spell history.
Module.db = Module.db or {};

-- Pool used for recycling aura's.
Module.Pool = {};
local PoolSize = 5;


-----------------------------------------------------------------
-- Function ActivateSource
-----------------------------------------------------------------
function Module:ActivateSource(Unit, Type)

  if self.BossModBarsVisibility == nil then
    self.BossModBarsVisibility = true;
  end

  if DBM and not self.db.DBM then
    
    self.db.DBM = {};
    self.Pool.DBM = {};
    
    LibAura:RegisterEvent("LIBAURA_UPDATE", self, self.DBM_Scan);
    
  end

  if DXE and not self.db.DXE then

    self.db.DXE = {};
    self.Pool.DXE = {};
  
    -- Hook DXE functions.
    
    self.DXE_Alerts = DXE:GetModule("Alerts");
    
    -- Save old functions.
    self.DXE_Alerts.DropdownHooked       = self.DXE_Alerts.Dropdown;
    self.DXE_Alerts.CenterPopupHooked    = self.DXE_Alerts.CenterPopup;
    self.DXE_Alerts.SimpleHooked         = self.DXE_Alerts.Simple;

    self.DXE_Alerts.QuashAllHooked       = self.DXE_Alerts.QuashAll;
    self.DXE_Alerts.QuashByPatternHooked = self.DXE_Alerts.QuashByPattern;
    self.DXE_Alerts.SetTimeleftHooked    = self.DXE_Alerts.SetTimeleft;
  
    -- Set new functions.
    self.DXE_Alerts.Dropdown        = self.DXE_Dropdown;
    self.DXE_Alerts.CenterPopup     = self.DXE_CenterPopup;
    self.DXE_Alerts.Simple          = self.DXE_Simple;
  
    self.DXE_Alerts.QuashAll        = self.DXE_QuashAll;
    self.DXE_Alerts.QuashByPattern  = self.DXE_QuashByPattern;
    self.DXE_Alerts.SetTimeleft     = self.DXE_SetTimeleft;
    
    LibAura:RegisterEvent("LIBAURA_UPDATE", self, self.DXE_Scan);
  
  end
  
  if BigWigs and not self.db.BigWigs then
  
    self.db.BigWigs = {};
    self.Pool.BigWigs = {};
    
    -- Hook BigWigs functions.
    
    self.BigWigs_Bars = BigWigs:GetPlugin("Bars");
    
    -- Save old functions.
    self.BigWigs_Bars.BigWigs_StartBarHooked  = self.BigWigs_Bars.BigWigs_StartBar;
    self.BigWigs_Bars.BigWigs_StopBarHooked   = self.BigWigs_Bars.BigWigs_StopBar;
    self.BigWigs_Bars.BigWigs_StopBarsHooked  = self.BigWigs_Bars.BigWigs_StopBars;
  
    -- Set new functions.
    self.BigWigs_Bars.BigWigs_StartBar = self.BigWigs_StartBar;
    self.BigWigs_Bars.BigWigs_StopBar  = self.BigWigs_StopBar;
    self.BigWigs_Bars.BigWigs_StopBars = self.BigWigs_StopBars;
  
  end
  
  LibAura:RegisterEvent("ADDON_LOADED", self, self.AddonLoaded);
  
end


-----------------------------------------------------------------
-- Function DeactivateSource
-----------------------------------------------------------------
function Module:DeactivateSource(Unit, Type)
  
  if DBM then
  
    LibAura:UnregisterEvent("LIBAURA_UPDATE", self, self.DBM_Scan);
    
    for Bar in DBM.Bars:GetBarIterator() do
      _G[Bar.frame:GetName().."Bar"]:Show();
    end
    
    for _, Aura in pairs(self.db.DBM) do
      LibAura:FireAuraOld(Aura);
    end

  end

  if self.DXE_Alerts then
  
    -- Unhook DXE functions.
    
    -- Restore old functions.
    self.DXE_Alerts.Dropdown       = self.DXE_Alerts.DropdownHooked;
    self.DXE_Alerts.CenterPopup    = self.DXE_Alerts.CenterPopupHooked;
    self.DXE_Alerts.Simple         = self.DXE_Alerts.SimpleHooked;
    
    self.DXE_Alerts.QuashAll       = self.DXE_Alerts.QuashAllHooked;
    self.DXE_Alerts.QuashByPattern = self.DXE_Alerts.QuashByPatternHooked;
    self.DXE_Alerts.SetTimeleft    = self.DXE_Alerts.SetTimeleftHooked;
  
    -- Remove old functions.
    self.DXE_Alerts.DropdownHooked       = nil;
    self.DXE_Alerts.CenterPopupHooked    = nil;
    self.DXE_Alerts.SimpleHooked         = nil;
  
    self.DXE_Alerts.QuashAllHooked       = nil;
    self.DXE_Alerts.QuashByPatternHooked = nil;
    self.DXE_Alerts.SetTimeleftHooked    = nil;
    
    LibAura:UnregisterEvent("LIBAURA_UPDATE", self, self.DXE_Scan);
  
  end
  
  if self.BigWigs_Bars then
  
    -- Unhook BigWigs functions.
  
    -- Restore old functions.
    self.BigWigs_Bars.BigWigs_StartBar = self.BigWigs_Bars.BigWigs_StartBarHooked;
    self.BigWigs_Bars.BigWigs_StopBar  = self.BigWigs_Bars.BigWigs_StopBarHooked;
    self.BigWigs_Bars.BigWigs_StopBars = self.BigWigs_Bars.BigWigs_StopBarsHooked;
  
    -- Remove old functions.
    self.BigWigs_Bars.BigWigs_StartBarHooked  = nil;
    self.BigWigs_Bars.BigWigs_StopBarHooked   = nil;
    self.BigWigs_Bars.BigWigs_StopBarsHooked  = nil;
  
  end
  
  LibAura:UnregisterEvent("ADDON_LOADED", self, self.AddonLoaded);

  self.db = {};
  self.Pool = {};

end


-----------------------------------------------------------------
-- Function GetAuras
-----------------------------------------------------------------
function Module:GetAuras(Unit, Type)

  local Auras = {};
  
  for _, Aura in pairs(self.db.DBM or {}) do
    tinsert(Auras, Aura);
  end
  
  return Auras;

end


-----------------------------------------------------------------
-- Function AddonLoaded
-----------------------------------------------------------------
function Module:AddonLoaded(Name)

  if Name == "DXE" then
    self:ActivateSource(nil, nil);
  end

end


-----------------------------------------------------------------
-- Function SetBossModBarsVisibility
-----------------------------------------------------------------
function Module:SetBossModBarsVisibility(Visible)

  self.BossModBarsVisibility = Visible;

  if DBM then
  
    for Bar in DBM.Bars:GetBarIterator() do
    
      if Visible == true then
        _G[Bar.frame:GetName().."Bar"]:Show();
      else
        _G[Bar.frame:GetName().."Bar"]:Hide();
      end
    
    end
  
  end

  if self.DXE_Alerts then

    local i = 1;
    
    while (_G["DXEAlertBar"..i]) do
    
      if Visible == true then
      
        if _G["DXEAlertBar"..i].ShowHooked then
          
          _G["DXEAlertBar"..i].Show = _G["DXEAlertBar"..i].ShowHooked;
          _G["DXEAlertBar"..i].ShowHooked = nil;

        end
      
      else
      
        if not _G["DXEAlertBar"..i].ShowHooked then
      
          _G["DXEAlertBar"..i]:Hide();
          _G["DXEAlertBar"..i].ShowHooked = _G["DXEAlertBar"..i].Show;
          _G["DXEAlertBar"..i].Show = function() end;
        
        end
        
      end
      
      i = i + 1;
    
    end

  end

end


-----------------------------------------------------------------
-- Function GetBossModBarsVisibility
-----------------------------------------------------------------
function Module:GetBossModBarsVisibility()

  return self.BossModBarsVisibility or true;

end


-----------------------------------------------------------------
-- Function DBM_Scan
-----------------------------------------------------------------
function Module:DBM_Scan()
  
  local db, CurrentTime = self.db.DBM, GetTime();
  
  for _, Aura in pairs(db) do
  
    Aura.Old = true;
  
  end

  for Bar in DBM.Bars:GetBarIterator() do
  
    if self.BossModBarsVisibility == true then
      _G[Bar.frame:GetName().."Bar"]:Show();
    else
      _G[Bar.frame:GetName().."Bar"]:Hide();
    end
  
    local Name = _G[Bar.frame:GetName().."BarName"]:GetText();
    local r, g, b = _G[Bar.frame:GetName().."Bar"]:GetStatusBarColor();
    local Icon = _G[Bar.frame:GetName().."BarIcon1"]:IsShown() == true and _G[Bar.frame:GetName().."BarIcon1"]:GetTexture() or nil;
    
    if not Bar.dummy and Name then
    
      Icon = Icon or "INTERFACE\\ICONS\\TEMP";
    
      local Id = Name..Icon;
    
      if not db[Id] then
        
        db[Id] = tremove(self.Pool.DBM) or {
          Type = "ALERT",
          Count = 0,
          Classification = "None",
          Unit = "bossmod",
          CasterUnit = "player",
          CasterName = UnitName("player"),
          IsStealable = false,
          IsCancelable = false,
          IsDispellable = false,
          Index = 0,
          SpellId = 0,
          ItemId = 0,
        };
        
        db[Id].Name = Name;
        db[Id].Icon = Icon;
        db[Id].Duration = Bar.totalTime;
        db[Id].ExpirationTime = CurrentTime + Bar.timer;
        db[Id].Id = "bossmodALERT_DBM"..Id;
        db[Id].ColorOverride = Bar.colorType and Bar.colorType >= 1 and {r, g, b} or nil;
        
        if Bar.totalTime and Bar.timer then
          db[Id].CreationTime = CurrentTime + Bar.timer - Bar.totalTime;
        end
        
        LibAura:FireAuraNew(db[Id]);
      
      else
      
        local OldExpirationTime = db[Id].ExpirationTime;
      
        db[Id].Duration = Bar.totalTime;
        db[Id].ExpirationTime = CurrentTime + Bar.timer;
        
        if abs(OldExpirationTime - db[Id].ExpirationTime) > 0.1 then
        
          LibAura:FireAuraChanged(db[Id]);
        
        end
      
      end
      
      db[Id].Old = false;
      
    end

  end
  
  for Key, Aura in pairs(db) do
  
    if Aura.Old == true then
    
      LibAura:FireAuraOld(Aura);
      
      if PoolSize > #self.Pool.DBM then
        tinsert(self.Pool.DBM, Aura);
      end
      
      db[Key] = nil;
    
    end
  
  end

end


-----------------------------------------------------------------
-- Function DXE_Scan
-----------------------------------------------------------------
function Module:DXE_Scan()

  local CurrentTime = GetTime();

  local i = 1;
  while (self.db.DXE[i]) do
  
    if self.db.DXE[i].ExpirationTime <= CurrentTime then
    
      local Aura = tremove(self.db.DXE, i);

      LibAura:FireAuraOld(Aura);
      
      if PoolSize > #self.Pool.DXE then
        tinsert(self.Pool.DXE, Aura);
      end

    else
    
      i = i + 1;
    
    end
  
  end

end

-----------------------------------------------------------------
-- Function DXE_NewBar
-----------------------------------------------------------------
function Module:DXE_NewBar(Id, Text, TotalTime, Icon)

  local Aura = tremove(self.Pool.DXE) or {
    Type = "ALERT",
    Count = 0,
    Classification = "None",
    Unit = "bossmod",
    CasterUnit = "player",
    CasterName = UnitName("player"),
    IsStealable = false,
    IsCancelable = false,
    IsDispellable = false,
    Index = 0,
    SpellId = 0,
    ItemId = 0,
    DXE_Id = Id or "",
  };
  
  Aura.Name = Text;
  Aura.Icon = Icon or "INTERFACE\\ICONS\\TEMP";
  Aura.Duration = TotalTime;
  Aura.ExpirationTime = GetTime() + TotalTime;
  Aura.Id = "bossmodALERT_DXE"..tostring(Aura);

  if TotalTime then
    Aura.CreationTime = GetTime() - TotalTime;
  end
  
  tinsert(self.db.DXE, Aura);
  
  LibAura:FireAuraNew(Aura);

end


-----------------------------------------------------------------
-- Function DXE_CheckBarVisibility
-----------------------------------------------------------------
function Module:DXE_CheckBarVisibility()

  if self.BossModBarsVisibility == true then
    return;
  end
  
  local i = 1;
  
  while (_G["DXEAlertBar"..i]) do
  
    if not _G["DXEAlertBar"..i].ShowHooked then
  
      _G["DXEAlertBar"..i]:Hide();
      _G["DXEAlertBar"..i].ShowHooked = _G["DXEAlertBar"..i].Show;
      _G["DXEAlertBar"..i].Show = function() end;
    
    end
    
    i = i + 1;
  
  end

end


-----------------------------------------------------------------
-- Function DXE_Dropdown
-----------------------------------------------------------------
function Module.DXE_Dropdown(...)

  -- Hooked function, no self.

  local _, Id, Text, TotalTime, _, _, _, _, _, Icon = ...;
  
  Module:DXE_NewBar(Id, Text, TotalTime, Icon);

  Module.DXE_Alerts.DropdownHooked(...);
  
  Module:DXE_CheckBarVisibility();

end


-----------------------------------------------------------------
-- Function DXE_CenterPopup
-----------------------------------------------------------------
function Module.DXE_CenterPopup(...)

  -- Hooked function, no self.

  local _, Id, Text, TotalTime, _, _, _, _, _, Icon = ...;
  
  Module:DXE_NewBar(Id, Text, TotalTime, Icon);

  Module.DXE_Alerts.CenterPopupHooked(...);

  Module:DXE_CheckBarVisibility();

end


-----------------------------------------------------------------
-- Function DXE_Simple
-----------------------------------------------------------------
function Module.DXE_Simple(...)

  -- Hooked function, no self.

  local _, Text, TotalTime, _, _, _, Icon = ...;
  
  Module:DXE_NewBar(nil, Text, TotalTime, Icon);

  Module.DXE_Alerts.SimpleHooked(...);
  
  Module:DXE_CheckBarVisibility();

end


-----------------------------------------------------------------
-- Function DXE_QuashAll
-----------------------------------------------------------------
function Module.DXE_QuashAll(...)

  -- Hooked function, no self.

  while (#Module.db.DXE > 0) do
  
    local Aura = tremove(Module.db.DXE);
    
    LibAura:FireAuraOld(Aura);
    
    if PoolSize > #Module.Pool.DXE then
      tinsert(Module.Pool.DXE, Aura);
    end
    
  end

  return Module.DXE_Alerts.QuashAllHooked(...);
  
end


-----------------------------------------------------------------
-- Function DXE_QuashByPattern
-----------------------------------------------------------------
function Module.DXE_QuashByPattern(...)

  -- Hooked function, no self.

  local Pattern = ...;
  
  local i = 1;
  while (Module.db.DXE[i]) do
  
    if Module.db.DXE[i].DXE_Id and find(Module.db.DXE[i].DXE_Id, Pattern) then
    
      local Aura = tremove(Module.db.DXE, i);

      LibAura:FireAuraOld(Aura);
      
      if PoolSize > #Module.Pool.DXE then
        tinsert(Module.Pool.DXE, Aura);
      end
    
    else
    
      i = i + 1;
    
    end
  
  end

  return Module.DXE_Alerts.QuashByPatternHooked(...);
  
end


-----------------------------------------------------------------
-- Function DXE_SetTimeleft
-----------------------------------------------------------------
function Module.DXE_SetTimeleft(...)

  -- Hooked function, no self.

  local Id, TimeLeft = ...;
  
  for _, Aura in ipairs(Module.db.DXE) do
  
    if Aura.DXE_Id == Id then
    
      Aura.ExpirationTime = GetTime() + TimeLeft;
    
      if Aura.Duration < TimeLeft then
        Aura.Duration = TimeLeft;
      end
    
    end
  
  end

  return Module.DXE_Alerts.SetTimeleftHooked(...);
  
end


-----------------------------------------------------------------
-- Function BigWigs_StartBar
-----------------------------------------------------------------
function Module.BigWigs_StartBar(...)

  local _, _, _, Key, Text, Time, Icon = ...;
  
  return Module.BigWigs_Bars.BigWigs_StartBarHooked(...);

end


-----------------------------------------------------------------
-- Function BigWigs_StopBar
-----------------------------------------------------------------
function Module.BigWigs_StopBar(...)

  local _, _, _, Text = ...;
  
  return Module.BigWigs_Bars.BigWigs_StopBarHooked(...);

end


-----------------------------------------------------------------
-- Function BigWigs_StopBars
-----------------------------------------------------------------
function Module.BigWigs_StopBars(...)

  return Module.BigWigs_Bars.BigWigs_StopBarsHooked(...);

end
