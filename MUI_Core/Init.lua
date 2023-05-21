-- luacheck: ignore MayronUI LibStub self 143 631
local addOnName = ...;

local _G = _G;
local pairs, CreateFont = _G.pairs, _G.CreateFont;
local hooksecurefunc = _G.hooksecurefunc;
local obj = _G.MayronObjects:GetFramework(); ---@type MayronObjects

---@class MayronUI
local MayronUI = {};
_G.MayronUI = MayronUI;

---@class Toolkit
local tk = {};

---@class GUIBuilder
local gui = {};

local db = obj:Import("MayronDB").Static:CreateDatabase(addOnName, "MayronUIdb", nil, "MayronUI"); ---@class Database
local em = obj:Import("Pkg-MayronEvents.EventManager")(); ---@class EventManager
local L = _G.LibStub("AceLocale-3.0"):GetLocale("MayronUI"); ---@class Locale

local components = {
  Toolkit = tk;
  Database = db;
  EventManager = em;
  GUIBuilder = gui;
  Objects = obj;
  Locale = L;
};

---Gets the core components of MayronUI
---@return Toolkit, Database, EventManager, GUIBuilder, MayronObjects, Locale
function MayronUI:GetCoreComponents()
  return tk, db, em, gui, obj, L;
end

---@generic T : string
---@param componentName `T`
---@param silent boolean?
---@return T
function MayronUI:GetComponent(componentName, silent)
  tk:Assert(silent or obj:IsString(componentName), "Invalid component '%s'", componentName);

  local component = components[componentName];
  tk:Assert(silent or obj:IsTable(component), "Invalid component '%s'", componentName);

  return component;
end

---@param componentName string
---@param component table
function MayronUI:AddComponent(componentName, component)
  components[componentName] = component;
end

---@param componentName string
---@return table
function MayronUI:NewComponent(componentName)
  local component = {};
  components[componentName] = component;
  return component;
end

--------------------------------
--- On Database StartUp
--------------------------------
db:OnStartUp(function(self, sv)
  -- setup globals:
  MayronUI.db = self;

  local bagnonChanges = MayronUI:GetComponent("BagnonChanges");
  bagnonChanges:Apply();

  -- Migration Code:
  for _, profile in pairs(sv.profiles) do
    profile.actionBarPanel = nil;
    profile.sidebar = nil;
  end

  local r, g, b = tk:GetThemeColor();

  local myFont = CreateFont("MUI_FontNormal");
  myFont:SetFontObject("GameFontNormal");
  myFont:SetTextColor(r, g, b);

  myFont = CreateFont("MUI_FontSmall");
  myFont:SetFontObject("GameFontNormalSmall");
  myFont:SetTextColor(r, g, b);

  myFont = CreateFont("MUI_FontLarge");
  myFont:SetFontObject("GameFontNormalLarge");
  myFont:SetTextColor(r, g, b);

  -- Load Media using LibSharedMedia --------------
  local media = tk.Constants.LSM;
  local types = media.MediaType;
  media:Register(types.FONT, "MUI_Font", tk:GetAssetFilePath("Fonts\\MayronUI.ttf"));
  media:Register(types.FONT, "Imagine", tk:GetAssetFilePath("Fonts\\Imagine.ttf"));
  media:Register(types.FONT, "Prototype", tk:GetAssetFilePath("Fonts\\Prototype.ttf"));
  media:Register(types.STATUSBAR, "MayronUI", tk:GetAssetFilePath("Textures\\Widgets\\Button.tga"));
  media:Register(types.BORDER, "Solid", tk.Constants.BACKDROP.edgeFile);
  media:Register(types.BORDER, "Glow", tk:GetAssetFilePath("Borders\\Glow.tga"));

  hooksecurefunc("MovieFrame_PlayMovie", function(s)
    s:SetFrameStrata("DIALOG");
  end);

  tk:SetGameFont(self.global.core.fonts);
  tk:KillElement(_G.WorldMapFrame.BlackoutFrame);

  if (tk.Constants.DEBUG_WHITELIST[tk:GetPlayerKey()])  then
    MayronUI.DEBUG_MODE = true;
    -- _G.SetCVar("ScriptErrors", "1");
    MayronUI:LogDebug("Debugging Enabled");
  end
end);