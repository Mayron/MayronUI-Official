local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");

local SelectedClass = select(2, UnitClass("player"));
local SelectedIndex = nil;

-----------------------------------------------------------------
-- Function ContentSpellCooldowns
-----------------------------------------------------------------
function AuraFramesConfig:ContentSpellCooldowns()

  self.Content:PauseLayout();
  self.Content:ReleaseChildren();

  self.Content:SetLayout("List");
  
  self.Content:AddText("Spell Cooldown Settings\n", GameFontNormalLarge);

  self.Content:AddText("The spell book will be scanned and the found spells will be used for detecting spell cooldowns. But there are some exceptions where this is not working fully. For example holy priests have cooldowns that are not tracked in the spell book correctly. To work around this, add the spell id's manually to the list below to track then.\n\nThe list is grouped by class and is used over all the characters.");

  self.Content:AddSpace(2);

  local DropdownClass = AceGUI:Create("Dropdown");
  DropdownClass:SetWidth(200);
  DropdownClass:SetList({
      WARRIOR     = "Warrior",
      DEATHKNIGHT = "Death Knight",
      PALADIN     = "Paladin",
      PRIEST      = "Priest",
      SHAMAN      = "Shaman",
      DRUID       = "Druid",
      ROGUE       = "Rogue",
      MAGE        = "Mage",
      WARLOCK     = "Warlock",
      HUNTER      = "Hunter"
  });
  DropdownClass:SetLabel("Class");
  DropdownClass:SetValue(SelectedClass);
  DropdownClass:SetCallback("OnValueChanged", function(_, _, Value)
    SelectedClass = Value;
    AuraFramesConfig:ContentSpellCooldowns();
  end);
  self.Content:AddChild(DropdownClass);
  
  self.Content:AddSpace();

  local Group = AceGUI:Create("SimpleGroup");
  Group:SetLayout("Flow");
  Group:SetRelativeWidth(1);
  self.Content:AddChild(Group);
  
  local ButtonDelete;
  
  local SpellList = AceGUI:Create("MultiSelect");
  SpellList:SetWidth(350);
  SpellList:SetHeight(200);
  SpellList:SetLabel("Spells");
  SpellList:SetMultiSelect(false);
  for _, Id in ipairs(AuraFrames.db.global.SpellCooldowns[SelectedClass] or {}) do
  
    local SpellName = GetSpellInfo(Id);
    if SpellName then
      SpellList:AddItem(Id.." ("..SpellName..")");
    else
      SpellList:AddItem(Id);
    end

  end
  SpellList:SetCallback("OnLabelClick", function(_, Value)
  
    SelectedIndex = SpellList:GetSelected()[1] and SpellList:GetSelected()[1].index or nil;
    
    if SelectedIndex == nil then
      ButtonDelete:SetDisabled(true);
    else
      ButtonDelete:SetDisabled(false);
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
  
  local ButtonNew = AceGUI:Create("Button");
  ButtonNew:SetDisabled(false);
  ButtonNew:SetWidth(150);
  ButtonNew:SetText("New spell");
  ButtonNew:SetCallback("OnClick", function()
    AuraFramesConfig:Close();
    AuraFrames:Input("Enter a spell ID", "", function(Result, Value)
      if Result == true then
        if not AuraFrames.db.global.SpellCooldowns[SelectedClass] then
          AuraFrames.db.global.SpellCooldowns[SelectedClass] = {};
        end
        tinsert(AuraFrames.db.global.SpellCooldowns[SelectedClass], tonumber(Value));
        table.sort(AuraFrames.db.global.SpellCooldowns[SelectedClass]);
        AuraFrames:SetSpellCooldownList();
        AuraFramesConfig:ContentSpellCooldowns();
      end
      AuraFramesConfig:Show();
    end, nil, nil, function(EditBox, Text)
      return tonumber(Text) ~= nil;
    end);
  end);
  OptionGroup:AddChild(ButtonNew);
  
  ButtonDelete = AceGUI:Create("Button");
  ButtonDelete:SetDisabled(true);
  ButtonDelete:SetWidth(150);
  ButtonDelete:SetText("Delete spell");
  ButtonDelete:SetCallback("OnClick", function()
    if SelectedIndex == nil then
      return;
    end
    tremove(AuraFrames.db.global.SpellCooldowns[SelectedClass], SelectedIndex);
    AuraFrames:SetSpellCooldownList();
    AuraFramesConfig:ContentSpellCooldowns();
  end);
  OptionGroup:AddChild(ButtonDelete);
  
  
  self.Content:ResumeLayout();
  self.Content:DoLayout();
  
end
