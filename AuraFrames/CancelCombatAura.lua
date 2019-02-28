local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local MSQ = LibStub("Masque", true);

-- Import used global references into the local namespace.
local SetOverrideBindingClick, CreateFont, GameFontNormal, GameTooltip = SetOverrideBindingClick, CreateFont, GameFontNormal, GameTooltip;
local pairs, tinsert, max, ceil, _G = pairs, tinsert, max, ceil, _G;
local GetTime, GetInventoryItemTexture, GetWeaponEnchantInfo, UnitAura = GetTime, GetInventoryItemTexture, GetWeaponEnchantInfo, UnitAura;


AuraFrames.CancelCombatAura = {};
local CancelCombatAura = AuraFrames.CancelCombatAura;

CancelCombatAura.Buttons = {};
CancelCombatAura.MSQGroup = nil;

local EnchantInfoExpiration = {};
local EnchantInfoCharges = {};

local ButtonSize = 72;
local Filter = "CANCELABLE";

CancelCombatAura.CombatFrame = _G["AuraFramesCancelCombatAura"];
CancelCombatAura.PlayerAuras = _G["AuraFramesCancelCombatAuraPlayer"];
CancelCombatAura.Visibility = _G["AuraFramesCancelCombatAuraVisibility"];

function CancelCombatAura:Update()

  local Config = AuraFrames.db.profile.CancelCombatAura;

  if Config.Enabled ~= true then

    self.Visibility:SetAttribute("_onclick", nil);

    if self.CombatFrame:IsShown() then
      self.CombatFrame:Hide();
    end

    if self.OldKeybinding then
      SetOverrideBindingClick(self.CombatFrame, true, self.OldKeybinding, nil);
      self.OldKeybinding = nil;
    end

    return;

  end

  if self.OldKeybinding ~= Config.Keybinding then

    if self.OldKeybinding then
      SetOverrideBindingClick(self.CombatFrame, true, self.OldKeybinding, nil);
    end

    if Config.Keybinding then
      SetOverrideBindingClick(self.CombatFrame, true, Config.Keybinding, "AuraFramesCancelCombatAuraVisibility");
    end

    self.OldKeybinding = Config.Keybinding;

  end

  local IsShown = self.CombatFrame:IsShown();

  if IsShown then
    self.CombatFrame:Hide();
  end

  local Width = (ButtonSize + Config.SpaceX) * Config.HorizontalSize;
  local Height = (ButtonSize + Config.SpaceY) * Config.VerticalSize;

  local CombatFrame = CancelCombatAura.CombatFrame;
  CombatFrame:SetWidth(Width + 44);
  CombatFrame:SetHeight(Height + 72);

  local PlayerAuras = self.PlayerAuras;

  PlayerAuras:SetAttribute("unit", "player");
  PlayerAuras:SetAttribute("filter", Filter);
  PlayerAuras:SetAttribute("includeWeapons", Config.IncludeWeaponEnchantments == true and 1 or nil);
  PlayerAuras:SetAttribute("template", "AuraFramesSecureButtonTemplate");
  PlayerAuras:SetAttribute("weaponTemplate", "AuraFramesSecureButtonTemplate");
  PlayerAuras:SetAttribute("minWidth", Width);
  PlayerAuras:SetAttribute("minHeight", Height);

  PlayerAuras:SetAttribute("point", "TOPLEFT"); 
  PlayerAuras:SetAttribute("xOffset", ButtonSize + Config.SpaceX);
  PlayerAuras:SetAttribute("yOffset", 0);
  PlayerAuras:SetAttribute("wrapAfter", Config.HorizontalSize);
  PlayerAuras:SetAttribute("wrapXOffset", 0);
  PlayerAuras:SetAttribute("wrapYOffset", -(ButtonSize + Config.SpaceY));
  PlayerAuras:SetAttribute("maxWraps", Config.VerticalSize);

  -- Sorting
  PlayerAuras:SetAttribute("sortMethod", Config.Order); -- INDEX or NAME or TIME

  -- Documentation says sortDir, but the Blizzard code use sortDirection. Use both so
  -- if they fix it that we are not broken.
  PlayerAuras:SetAttribute("sortDir", Config.OrderReverse == true and "-" or "+");
  PlayerAuras:SetAttribute("sortDirection", Config.OrderReverse == true and "-" or "+");

  local Visibility = self.Visibility;

  Visibility:RegisterForClicks("AnyDown");
  Visibility:RegisterForClicks("AnyUp");

  if Config.ToggleMode then

    Visibility:SetAttribute("_onmousedown", [=[
      if self:GetParent():IsShown() then
        self:GetParent():Hide();
      else
        self:GetParent():Show();
      end
    ]=]);

    Visibility:SetAttribute("_onmouseup", nil);

  else

    Visibility:SetAttribute("_onmousedown", [=[
      self:GetParent():Show();
    ]=]);

    Visibility:SetAttribute("_onmouseup", [=[
      self:GetParent():Hide();
    ]=]);

  end

  self.MSQGroup = CancelCombatAura.MSQGroup or (MSQ and MSQ:Group("AuraFrames", "CancelCombatAura")) or nil;

  self.DurationFontObject = self.DurationFontObject or CreateFont("CancelCombatAura_DurationFont");
  self.CountFontObject = self.CountFontObject or CreateFont("CancelCombatAura_CountFont");

  AuraFrames:SetFontObjectProperties(
    self.DurationFontObject,
    Config.DurationFont,
    Config.DurationSize,
    Config.DurationOutline,
    Config.DurationMonochrome,
    Config.DurationColor
  );
  
  AuraFrames:SetFontObjectProperties(
    self.CountFontObject,
    Config.CountFont,
    Config.CountSize,
    Config.CountOutline,
    Config.CountMonochrome,
    Config.CountColor
  );

  for _, Button in pairs(self.Buttons) do
    self:UpdateButtonDisplay(Button);
  end

  if IsShown then
    self.CombatFrame:Show();
  end

  PlayerAuras:SetAttribute("_update", PlayerAuras:GetAttribute("_update"));

end


function CancelCombatAura:UpdateButtonDisplay(Button)

  local Config = AuraFrames.db.profile.CancelCombatAura;

  Button.Duration:SetFontObject(self.DurationFontObject or GameFontNormal);
  Button.Count:SetFontObject(self.CountFontObject or GameFontNormal);

  if Config.OnlyRightButton == true then
    Button:RegisterForClicks("RightButtonUp");
  else
    Button:RegisterForClicks("AnyUp");
  end

  if Config.ShowTooltip == true then
    Button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
      GameTooltip:SetFrameLevel(self:GetFrameLevel() + 2);
      local SlotId = self:GetAttribute("target-slot");
      if SlotId == 16 or SlotId == 17 or SlotId == 18 then
        GameTooltip:SetInventoryItem("player", SlotId);
      else
        GameTooltip:SetUnitAura("player", self:GetID(), Filter);
      end
    end);
    Button:SetScript("OnLeave", function()
      GameTooltip:Hide();
    end);
  else
    Button:SetScript("OnEnter", nil);
    Button:SetScript("OnLeave", nil);
  end

  Button.Duration:ClearAllPoints();
  Button.Duration:SetPoint(Config.DurationAlignment, Button, "CENTER", Config.DurationPosX, Config.DurationPosY);
  Button.Duration:SetJustifyH(Config.DurationAlignment);

  Button.Count:ClearAllPoints();
  Button.Count:SetPoint(Config.CountAlignment, Button, "CENTER", Config.CountPosX, Config.CountPosY);
  Button.Count:SetJustifyH(Config.CountAlignment);

end

function CancelCombatAura:UpdateButton(Button)

  local Config = AuraFrames.db.profile.CancelCombatAura;

  local IsReady = false
  local CurrentTime = GetTime();

  local SlotId = Button:GetAttribute("target-slot");

  if SlotId then

    Button.Icon:SetTexture(GetInventoryItemTexture("player", SlotId));

    local _;
    _, EnchantInfoExpiration[16], EnchantInfoCharges[16], _, EnchantInfoExpiration[17], EnchantInfoCharges[17] = GetWeaponEnchantInfo();

    if EnchantInfoExpiration[SlotId] then
      Button.Duration:SetFormattedText(AuraFrames:FormatTimeLeft(Config.DurationLayout, max(ceil(EnchantInfoExpiration[SlotId] / 1000), 0), false));
      Button.Duration:Show();
    else
      Button.Duration:Hide();
    end

    if EnchantInfoCharges[SlotId] and EnchantInfoCharges[SlotId] ~= 0 then
      Button.Count:SetFormattedText(EnchantInfoCharges[SlotId]);
      Button.Count:Show();
    else
      Button.Count:Hide();
    end

    IsReady = true;

  else
  
    local Id = Button:GetID();

    if Id then

      local Name, Icon, Count, Classification, Duration, ExpirationTime, CasterUnit, IsStealable, _, SpellId = UnitAura("player", Id, Filter);

      if Name then

        Button.Icon:SetTexture(Icon);

        if ExpirationTime ~= 0 then
          Button.Duration:SetFormattedText(AuraFrames:FormatTimeLeft("SEPDOT", max(ExpirationTime - CurrentTime, 0), false));
          Button.Duration:Show();
        else
          Button.Duration:Hide();
        end

        if Count ~= 0 then
          Button.Count:SetFormattedText(Count);
          Button.Count:Show();
        else
          Button.Count:Hide();
        end

        IsReady = true;

      end

    end

  end

end


function CancelCombatAura:RegisterButton(Button)

  tinsert(self.Buttons, Button);

  local ButtonId = Button:GetName();

  Button.Duration = _G[ButtonId.."Duration"];
  Button.Icon = _G[ButtonId.."Icon"];
  Button.Count = _G[ButtonId.."Count"];
  Button.Border = _G[ButtonId.."Border"];

  if MSQ then

    self.MSQGroup:AddButton(Button, {Icon = Button.Icon, Border = Button.Border, Duration = false, Count = false});

    -- Work around for Masque bug. See http://www.wowace.com/addons/masque/tickets/145-bug-with-secure-action-button-template/
    Button.__MSQ_BaseFrame:SetFrameLevel(2);

  end

  self:UpdateButtonDisplay(Button);

  self:UpdateButton(Button);
  Button:HookScript("OnUpdate", function() self:UpdateButton(Button); end);

end
