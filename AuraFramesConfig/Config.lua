local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local AceGUI = LibStub("AceGUI-3.0");

-- Expose the addon to the global namespace for debugging.
_G["AuraFramesConfig"] = AuraFramesConfig;
_G["afc"] = AuraFramesConfig;


AuraFramesConfig.Tree = {};
AuraFramesConfig.TreeSelectedPath = nil;


-----------------------------------------------------------------
-- Function EnhanceContainer
-----------------------------------------------------------------
function AuraFramesConfig:EnhanceContainer(Container)

  Container.AddHeader = function(Container, Text)
  
    local Header = AceGUI:Create("Heading");
    Header:SetRelativeWidth(1);
    Header:SetText(Text);
    Container:AddChild(Header);
    
    return Header;
  
  end
  
  Container.AddText = function(Container, Text, Font, Width)
  
    local Label = AceGUI:Create("Label");
    Label:SetFontObject(Font or GameFontNormal);
    if Width then
      Label:SetWidth(Width);
    else
      Label:SetRelativeWidth(1);
    end
    Label:SetText(Text);
    Container:AddChild(Label);
    
    return Label;
  
  end
  
  Container.AddSpace = function(Container, Rows)
  
    if not Rows then
      Rows = 1;
    end
  
    return Container:AddText(" "..string.rep("\n", Rows - 1));
    
  end

end

-----------------------------------------------------------------
-- Function GetTreeByPath
-----------------------------------------------------------------
function AuraFramesConfig:GetTreeByPath(...)

  local Tree = AuraFramesConfig.Tree;
  local FoundItem = nil;
  
  for _, Key in ipairs({...}) do

    local Found = false;
  
    for _, Item in ipairs(Tree) do
    
      if Item.value == Key then
      
        Tree = Item.children or {};
        FoundItem = Item;
        Found = true;
        break;
      
      end
    
    end
    
    if Found == false then
      return nil;
    end
  
  end
  
  return FoundItem;

end


-----------------------------------------------------------------
-- Function CreateWindow
-----------------------------------------------------------------
function AuraFramesConfig:CreateWindow()

  if self.Window then
    return;
  end

  self.Window = AceGUI:Create("AuraFramesWindow");
  self.Window:Hide();
  self.Window:SetTitle("Aura Frames - Configuration");
  self.Window:SetWidth(800);
  self.Window:SetHeight(500);
  self.Window:EnableResize(false);
  self.Window:SetLayout("Fill");
  self.Window:SetCallback("OnCollapse", function()
    AuraFramesConfig:UnlockContainers(true);
  end);

  self.Content = AceGUI:Create("TreeGroup");
  self.Content:SetRelativeWidth(1);
  self.Content:SetTreeWidth(180, false);
  self.Content:SetCallback("OnGroupSelected", function(TreeControl, Event, Group)
    
    AuraFramesConfig.TreeSelectedPath = {string.split("\001", Group)};
    
    AuraFramesConfig:RefreshContent();
    
  end);
  
  self.TreeStatus = {};
  self.Content:SetStatusTable(self.TreeStatus);
  
  self:EnhanceContainer(self.Content);
  
  self.Window:AddChild(self.Content);


end


-----------------------------------------------------------------
-- Function RefreshContent
-----------------------------------------------------------------
function AuraFramesConfig:RefreshContent()

  AuraFramesConfig.Content:PauseLayout();
  AuraFramesConfig.Content:ReleaseChildren();
  
  if AuraFramesConfig.TreeSelectedPath then
  
    local Item = AuraFramesConfig:GetTreeByPath(unpack(AuraFramesConfig.TreeSelectedPath));
    
    if Item and Item.execute then
    
      Item.execute();
    
    end
  
  end
  
  AuraFramesConfig.Content:ResumeLayout();
  AuraFramesConfig.Content:DoLayout();

end


-----------------------------------------------------------------
-- Function RefreshTree
-----------------------------------------------------------------
function AuraFramesConfig:RefreshTree()

  if not self.Content then
    return;
  end
  
  local Containers = {};
  
  for Id, Container in pairs(AuraFrames.db.profile.Containers) do
    
    local ContainerModule = AuraFrames:GetModule(Container.Type, true);
    local ConfigModule = self:GetModule(Container.Type, true);
    
    if not ContainerModule or not ConfigModule then
    
      table.insert(Containers, {
        value = Id,
        text = Container.Name,
        execute = function() AuraFramesConfig:ContentContainerNoModule(Id); end,
      });
      
    else
    
      if not ContainerModule:IsEnabled() then
        ContainerModule:Enable();
      end
      
      if not ConfigModule:IsEnabled() then
        ConfigModule:Enable();
      end
      
      table.insert(Containers, {
        value = Id,
        text = Container.Name.." ("..ContainerModule:GetName()..")",
        execute = function() AuraFramesConfig:ContentContainer(Id); end,
        children = ConfigModule:GetTree(Id),
      });
    
    end
  
  end
  
  sort(Containers, function(Container1, Container2) return Container1.text < Container2.text; end);
  
  if #Containers == 0 then
    Containers = nil;
  end

  self.Tree = {
    { 
      value = "General",
      text = "General",
      execute = function() AuraFramesConfig:ContentGeneral(); end,
      children = {
        {
          value = "Settings",
          text = "Settings",
          execute = function() AuraFramesConfig:ContentGeneralSettings(); end,
        },
        {
          value = "SpellCooldowns",
          text = "Spell Cooldowns",
          execute = function() AuraFramesConfig:ContentSpellCooldowns(); end,
        },
        {
          value = "InternalCooldowns",
          text = "Internal Cooldowns",
          execute = function() AuraFramesConfig:ContentInternalCooldowns(); end,
        },
        {
          value = "CancelCombatAura",
          text = "Cancel Combat Aura",
          execute = function() AuraFramesConfig:ContentCancelCombatAura(); end,
        },
      },
    },
    {
      value = "Containers",
      text = "Containers",
      execute = function() AuraFramesConfig:ContentContainers(); end,
      children = Containers,
    },
    { 
      value = "Profiles",
      text = "Profiles",
      execute = function() AuraFramesConfig:ContentProfiles(); end,
    },
  };

  self.Content:SetTree(self.Tree);
  self.Content:SetTreeWidth(180, false);

end


-----------------------------------------------------------------
-- Function SelectByPath
-----------------------------------------------------------------
function AuraFramesConfig:SelectByPath(...)

  if not self.Content then
    return;
  end
  
  self.Content:SelectByPath(...);
  
  -- Make sure that the selected path is visible.
  
  for i = 1, select("#", ...) do
  
    local Path = select(1, ...);
    
    for j = 2, i do
    
      Path = Path.."\001"..select(j, ...);
    
    end
    
    self.TreeStatus.groups[Path] = true;
  
  end
  
  self.Content:RefreshTree();
  self.Content:SetTreeWidth(180, false);
  
end


-----------------------------------------------------------------
-- Function ClearContent
-----------------------------------------------------------------
function AuraFramesConfig:ClearContent()

  if not self.Content then
    return;
  end
  
  self.Content:ReleaseChildren();

end


-----------------------------------------------------------------
-- Function Close
-----------------------------------------------------------------
function AuraFramesConfig:Close()

  if self.Window and self.Window:IsShown() then
  
    self.Window:Hide();
    return true;
  
  else
  
    return false;
  
  end

end


-----------------------------------------------------------------
-- Function Show
-----------------------------------------------------------------
function AuraFramesConfig:Show()

  if not self.Window then

    self:CreateWindow();
    self:RefreshTree();
    
    -- Expand by default the containers level.
    self.TreeStatus.groups["Containers"] = true;
    
    self:SelectByPath("General");
    
  else
  
    self:RefreshTree();
  
  end
  
  self:CloseListEditor();
  
  self.Window:Show();

end
