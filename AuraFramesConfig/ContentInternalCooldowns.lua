local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");

local SelectedItemId = nil;

-----------------------------------------------------------------
-- Function ContentInternalCooldowns
-----------------------------------------------------------------
function AuraFramesConfig:ContentInternalCooldowns()

  self.Content:PauseLayout();
  self.Content:ReleaseChildren();

  self.Content:SetLayout("List");
  
  self.Content:AddText("Internal Cooldown Settings\n", GameFontNormalLarge);

  self.Content:AddText("Aura Frames use a predefined list of items that can have an internal cooldown, then it will scan you character for equipped items and your bags and will start monitoring for buffs on you that can be cast by those items. While playing Aura Frames gather information about the internal cooldowns and try to guess the correct values.");
  self.Content:AddSpace();
  self.Content:AddText("Only internal cooldowns with a minimum of 5 seconds are triggered.");

  self.Content:AddSpace();

  local Group = AceGUI:Create("SimpleGroup");
  Group:SetLayout("Flow");
  Group:SetRelativeWidth(1);
  self.Content:AddChild(Group);
  
  local SpellList = AceGUI:Create("MultiSelect");
  SpellList:SetWidth(350);
  SpellList:SetHeight(200);
  SpellList:SetLabel("Spells that are found from items");
  SpellList:SetMultiSelect(false);
  for ItemId, _ in pairs(AuraFrames.db.global.InternalCooldowns or {}) do

    local Item;

    local ItemName = GetItemInfo(ItemId);
    if ItemName then
      Item = SpellList:AddItem(ItemName.." ("..ItemId..")");
    else
      Item = SpellList:AddItem(ItemId);
    end

    if SelectedItemId == ItemId then
    
      SpellList:SetSelected(Item, true);

    end

  end
  SpellList:SetCallback("OnLabelClick", function(_, Value)
  
    local SelectedIndex = SpellList:GetSelected()[1] and SpellList:GetSelected()[1].index or nil;
    SelectedItemId = nil;

    if SelectedIndex then
      local Index = 1;
      for ItemId, _ in pairs(AuraFrames.db.global.InternalCooldowns or {}) do
        if Index == SelectedIndex then
          SelectedItemId = ItemId;
          break;
        end
        Index = Index + 1;
      end

      AuraFramesConfig:ContentInternalCooldowns();

    end
  
  end);
  Group:AddChild(SpellList);

  local OptionGroup = AceGUI:Create("SimpleGroup");
  OptionGroup:SetLayout("List");
  OptionGroup:SetWidth(150);
  OptionGroup:SetHeight(200);
  Group:AddChild(OptionGroup);
  AuraFramesConfig:EnhanceContainer(OptionGroup);
  OptionGroup:AddSpace();
  
  local ButtonDelete = AceGUI:Create("Button");
  ButtonDelete:SetDisabled(not SelectedItemId);
  ButtonDelete:SetWidth(200);
  ButtonDelete:SetText("Delete spell data");
  ButtonDelete:SetCallback("OnClick", function()
    if SelectedItemId == nil then
      return;
    end
    AuraFrames.db.global.InternalCooldowns[SelectedItemId] = nil;
    AuraFramesConfig:ContentInternalCooldowns();
  end);
  OptionGroup:AddChild(ButtonDelete);

  local ButtonOverrule = AceGUI:Create("Button");
  ButtonOverrule:SetDisabled(not SelectedItemId);
  ButtonOverrule:SetWidth(200);
  ButtonOverrule:SetText("Overrule cooldown guess");
  ButtonOverrule:SetCallback("OnClick", function()

    AuraFramesConfig:Close();

    AuraFrames:Input(
      "Enter the cooldown in seconds. Use 0 (zero) to disable the overrule.",
      AuraFrames.db.global.InternalCooldowns[SelectedItemId].OverruleCd,
      function(Status, Overrule)
        if Status == true then
          AuraFrames.db.global.InternalCooldowns[SelectedItemId].OverruleCd = tonumber(Overrule);
          AuraFramesConfig:Show();
          AuraFramesConfig:ContentInternalCooldowns();
        end
      end,
      "Overrule",
      nil,
      function(EditBox, Value)
        return tostring(tonumber(Value)) == Value;
      end);
  
  end);
  OptionGroup:AddChild(ButtonOverrule);


  local ButtonDeleteAll = AceGUI:Create("Button");
  ButtonDeleteAll:SetWidth(200);
  ButtonDeleteAll:SetText("Delete all spell data");
  ButtonDeleteAll:SetCallback("OnClick", function()

    AuraFramesConfig:Close();

    AuraFrames:Confirm(
      "Are you sure that you want to delete all collected spell data?",
      function(Status)
        if Status == true then
          wipe(AuraFrames.db.global.InternalCooldowns)
          AuraFramesConfig:Show();
          AuraFramesConfig:ContentInternalCooldowns();
        end
      end);
  
  end);
  OptionGroup:AddChild(ButtonDeleteAll);
  
  local ProcItem = AuraFrames.db.global.InternalCooldowns and AuraFrames.db.global.InternalCooldowns[SelectedItemId] or {};

  self.Content:AddSpace(2);
  self.Content:AddText("  |cffff0000Internal Cooldown Information:|r");
  self.Content:AddText("    Shortest: "..(ProcItem.ShortestCd and (ProcItem.ShortestCd == 0 and "Unknown" or ProcItem.ShortestCd) or ""));
  self.Content:AddText("    Average: "..(ProcItem.AverageCd and (ProcItem.AverageCd == 0 and "Unknown" or ProcItem.AverageCd) or ""));
  self.Content:AddText("    Guessed: "..(ProcItem.GuessedCd or ""));
  self.Content:AddText("    Overrule: "..(ProcItem.OverruleCd and (ProcItem.OverruleCd == 0 and "Not set" or ProcItem.OverruleCd) or ""));
  self.Content:AddText("    Times Seen: "..(ProcItem.TimesSeen and (ProcItem.TimesSeen == 0 and "Not seen the cooldown time yet" or ProcItem.TimesSeen) or ""));

  local SpellDisplay = "";

  if ProcItem.SpellId then

    local SpellName = GetSpellInfo(ProcItem.SpellId);

    if SpellName then
      SpellDisplay = SpellName.." ("..ProcItem.SpellId..")";
    else
      SpellDisplay = ProcItem.SpellId;
    end

  end

  self.Content:AddText("    Spell: "..SpellDisplay);
  
  self.Content:ResumeLayout();
  self.Content:DoLayout();
  
end
