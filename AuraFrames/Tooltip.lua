local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");

-- Import used global references into the local namespace.
local tinsert, tremove, tconcat, sort = tinsert, tremove, table.concat, sort;
local fmt, tostring = string.format, tostring;
local select, pairs, next, type, unpack = select, pairs, next, type, unpack;
local loadstring, assert, error = loadstring, assert, error;
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget;
local GetSpellBookItemInfo = GetSpellBookItemInfo;
local GetTime = GetTime;
local format = format;
local BOOKTYPE_SPELL, RAID_CLASS_COLORS = BOOKTYPE_SPELL, RAID_CLASS_COLORS;
local UnitClass, UnitName = UnitClass, UnitName;

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: GameTooltip

-----------------------------------------------------------------
-- Function ShowTooltip
-----------------------------------------------------------------
function AuraFrames:ShowTooltip(Aura, Frame, Options)

  GameTooltip:SetOwner(Frame, "ANCHOR_BOTTOMLEFT");
  GameTooltip:SetFrameLevel(Frame:GetFrameLevel() + 2);
  
  if Aura.Unit == "bossmod" and Aura.Type == "ALERT" then
  
    GameTooltip:AddLine("Boss Mod Alert!");
    GameTooltip:AddLine("")
    GameTooltip:AddLine("|cffff0000"..Aura.Name.."|r");

  elseif Aura.Unit == "test" then
  
    GameTooltip:SetHyperlink("spell:"..Aura.SpellId);
  
    GameTooltip:AddLine(" ");
    GameTooltip:AddLine("|cffff0000Test Aura|r");

  elseif Aura.Type == "WEAPON" then
  
    GameTooltip:SetInventoryItem(Aura.RealUnit or Aura.Unit, Aura.Index);
  
  elseif Aura.Type == "SPELLCOOLDOWN" or Aura.Type == "SPELLCOOLDOWNOLD" then
  
    local _, SpellId = GetSpellBookItemInfo(Aura.Index, BOOKTYPE_SPELL);
    
    if SpellId then
      GameTooltip:SetSpellBookItem(Aura.Index, BOOKTYPE_SPELL);
    else
      GameTooltip:SetHyperlink("spell:"..Aura.SpellId);
    end
  
  elseif Aura.Type == "ITEMCOOLDOWN" or Aura.Type == "ITEMCOOLDOWNOLD" then
  
    GameTooltip:SetInventoryItemByID(Aura.ItemId);
  
  elseif Aura.Type == "INTERNALCOOLDOWNITEM" or Aura.Type == "INTERNALCOOLDOWNITEMOLD" then
  
    GameTooltip:SetInventoryItemByID(Aura.ItemId);
    
    if self.db.global.InternalCooldowns[Aura.ItemId] then

      local ProcItem = self.db.global.InternalCooldowns[Aura.ItemId];

      GameTooltip:AddLine(" ");
      GameTooltip:AddLine("|cffff0000Internal Cooldown Information:|r");
      GameTooltip:AddLine("  Shortest cd: "..(ProcItem.ShortestCd and (ProcItem.ShortestCd == 0 and "Unknown" or ProcItem.ShortestCd) or ""));
      GameTooltip:AddLine("  Average cd: "..(ProcItem.AverageCd and (ProcItem.AverageCd == 0 and "Unknown" or ProcItem.AverageCd) or ""));
      GameTooltip:AddLine("  Guessed cd: "..(ProcItem.GuessedCd or ""));
      GameTooltip:AddLine("  Overrule cd: "..(ProcItem.OverruleCd and (ProcItem.OverruleCd == 0 and "Not set" or ProcItem.OverruleCd) or ""));
      GameTooltip:AddLine("  Times Seen: "..(ProcItem.TimesSeen and (ProcItem.TimesSeen == 0 and "Not seen the cooldown time yet" or ProcItem.TimesSeen) or ""));

      local SpellDisplay = "";

      if ProcItem.SpellId then

        local SpellName = GetSpellInfo(ProcItem.SpellId);

        if SpellName then
          SpellDisplay = SpellName.." ("..ProcItem.SpellId..")";
        else
          SpellDisplay = ProcItem.SpellId;
        end

      end

      GameTooltip:AddLine("  Spell: "..SpellDisplay);

    end
  
  elseif Aura.Type == "INTERNALCOOLDOWNTALENT" or Aura.Type == "INTERNALCOOLDOWNTALENTOLD" then
  
    --GameTooltip:SetTalent(Aura.SpellId);
  
  elseif (Aura.Type == "TOTEM" or Aura.Type == "TOTEMOLD") and Aura.SpellId then
  
    GameTooltip:SetHyperlink("spell:"..Aura.SpellId);
  
  elseif (Aura.Type == "STANCE" or Aura.Type == "STANCEOLD") and Aura.SpellId then
  
    GameTooltip:SetHyperlink("spell:"..Aura.SpellId);

  elseif Aura.Type == "HARMFUL" or Aura.Type == "HELPFUL" then
  
    GameTooltip:SetUnitAura(Aura.RealUnit or Aura.Unit, Aura.Index, Aura.Type);
  
  elseif Aura.Type == "HARMFULOLD" or Aura.Type == "HELPFULOLD" then
  
    GameTooltip:SetHyperlink("spell:"..Aura.SpellId);
  
  end
  
  if Options.ShowUnit == true or Options.ShowCaster == true or Options.ShowAuraId == true or Options.ShowClassification then
    GameTooltip:AddLine(" ");
  end

  if Options.ShowUnit == true then

    local Name = ((Aura.RealUnit or Aura.Unit) and UnitName(Aura.RealUnit or Aura.Unit)) or (Aura.Unit == "test" and "Test") or "Unknown";
    local Color = RAID_CLASS_COLORS[(Aura.RealUnit or Aura.Unit) and select(2, UnitClass(Aura.RealUnit or Aura.Unit)) or "NONE"] or {r = 1.0, g = 1.0, b = 1.0};
    GameTooltip:AddLine(format("%s|cff%02x%02x%02x%s|r", Options.ShowPrefix and "Unit: " or "", Color.r * 255, Color.g * 255, Color.b * 255, Name));
    
  end
  
  if Options.ShowCaster == true and Aura.CasterUnit then
    
    if Options.ShowPrefix == true then
    
      if Aura.CasterName then
        local Color = RAID_CLASS_COLORS[Aura.CasterUnit and select(2, UnitClass(Aura.CasterUnit)) or "NONE"];
        if Color then
          GameTooltip:AddLine(format("Caster: |cff%02x%02x%02x%s|r", Color.r * 255, Color.g * 255, Color.b * 255, Aura.CasterName));
        else
          GameTooltip:AddLine("Caster: "..Aura.CasterName);
        end
      else
        GameTooltip:AddLine("Caster: "..Aura.CasterUnit);
      end
    
    else
    
      if Aura.CasterName then
        local Color = RAID_CLASS_COLORS[Aura.CasterUnit and select(2, UnitClass(Aura.CasterUnit)) or "NONE"];
        if Color then
          GameTooltip:AddLine(format("|cff%02x%02x%02x%s|r", Color.r * 255, Color.g * 255, Color.b * 255, Aura.CasterName));
        else
          GameTooltip:AddLine(Aura.CasterName);
        end
      else
        GameTooltip:AddLine(Aura.CasterUnit);
      end
    
    end
    
  end
  
  if Options.ShowAuraId == true then
  
    if Aura.SpellId and Aura.SpellId ~= 0 then
    
      if Options.ShowPrefix == true then
        GameTooltip:AddLine("Spell ID: |cffff0000"..Aura.SpellId.."|r");
      else
        GameTooltip:AddLine("|cffff0000"..Aura.SpellId.."|r");
      end
    
    end
    
    if Aura.ItemId and Aura.ItemId ~= 0 then
    
      if Options.ShowPrefix == true then
        GameTooltip:AddLine("Item ID: |cffff0000"..Aura.ItemId.."|r");
      else
        GameTooltip:AddLine("|cffff0000"..Aura.ItemId.."|r");
      end
    
    end
    
  end
  
  if Options.ShowClassification == true and Aura.Classification then
    
    if Options.ShowPrefix == true then
      GameTooltip:AddLine("Classification: |cffff8040"..Aura.Classification.."|r");
    else
      GameTooltip:AddLine("|cffff8040"..Aura.Classification.."|r");
    end
    
  end

  GameTooltip:Show();

end

-----------------------------------------------------------------
-- Function IsTooltipOwner
-----------------------------------------------------------------
function AuraFrames:IsTooltipOwner(Frame)

  return GameTooltip:GetOwner() == Frame;

end

-----------------------------------------------------------------
-- Function HideTooltip
-----------------------------------------------------------------
function AuraFrames:HideTooltip()

  GameTooltip:Hide();

end

