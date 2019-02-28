local AuraFramesConfig = LibStub("AceAddon-3.0"):GetAddon("AuraFramesConfig");
local Module = AuraFramesConfig:GetModule("TimeLineContainer");
local AceGUI = LibStub("AceGUI-3.0");

local SelectedTabs = {};

-----------------------------------------------------------------
-- Function ContentLayout
-----------------------------------------------------------------
function Module:ContentLayout(ContainerId)

  AuraFramesConfig.Content:SetLayout("Fill");

  local Tab = AceGUI:Create("TabGroup");
  Tab:SetRelativeWidth(1);
  Tab:SetTabs({
    {
      value = "General",
      text = "General",
    },
    {
      value = "SizeAndScale",
      text = "Size and Scale",
    },
    {
      value = "Text",
      text = "Text",
    },
    {
      value = "Skin",
      text = "Skin",
    },
    {
      value = "ColorsAndBorder",
      text = "Colors & Border",
    },
  });
  Tab:SetCallback("OnGroupSelected", function(_, _, Value)

    Module.Layout:PauseLayout();
    Module.Layout:ReleaseChildren();
    
    SelectedTabs[ContainerId] = Value;
    
    if self["ContentLayout"..Value] then
    
      self["ContentLayout"..Value](self, self.Layout, ContainerId);
    
    end

    Module.Layout:ResumeLayout();
    Module.Layout:DoLayout();

  end);
  AuraFramesConfig.Content:AddChild(Tab);
  
  Tab:SetLayout("Fill");
  
  self.Layout = AceGUI:Create("ScrollFrame");
  self.Layout:SetLayout("List");
  AuraFramesConfig:EnhanceContainer(self.Layout);
  Tab:AddChild(self.Layout);
  AuraFramesConfig.ScrollFrame = self.Layout;
  
  -- Select last tab otherwise if first tab.
  Tab:SelectTab(SelectedTabs[ContainerId] or "General");

end

