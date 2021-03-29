-- luacheck: ignore MayronUI self 143 631
local tk, db, em, _, obj, L = _G.MayronUI:GetCoreComponents();
local obj = _G.MayronObjects:GetFramework();
local Quest = obj:CreateClass("Quest");

-- CombatTimer Module ----------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
  self:RegisterComponentClass("quest", Quest);
end);

function Quest:__Construct(data, settings, dataTextModule)
  data.settings = settings;

  -- set public instance properties
  self.TotalLabelsShown = 0;
  self.HasLeftMenu = false;
  self.HasRightMenu = false;
  self.Button = dataTextModule:CreateDataTextButton();
end

function Quest:IsEnabled(data)
  return data.enabled;
end

function Quest:SetEnabled(data, enabled)
  data.enabled = enabled;

  local listenerID = "DataText_Quest_OnChange";
  if (enabled) then
    if (not em:GetEventListenerByID(listenerID)) then
      local listener = em:CreateEventListenerWithID(listenerID, function()
        if (not self.Button) then return end
        self:Update(data);
      end);

      listener:RegisterEvent("QUEST_LOG_UPDATE");
    else
      em:EnableEventListeners(listenerID);
    end

    -- self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    -- self.Button:SetScript("OnEnter", button_OnEnter);
    -- self.Button:SetScript("OnLeave", button_OnLeave);
  else
    em:DisableEventListeners(listenerID);
    -- self.Button:RegisterForClicks("LeftButtonUp");
    -- self.Button:SetScript("OnEnter", nil);
    -- self.Button:SetScript("OnLeave", nil);
  end
end

function Quest:Update(data, refreshSettings)
  print("Update");
  if (refreshSettings) then
    data.settings:Refresh();
  end

  local _, numQuests = C_QuestLog.GetNumQuestLogEntries()
  local maxQuestsCanAccept = C_QuestLog.GetMaxNumQuestsCanAccept();

  self.Button:SetText(string.format("|TInterface\\QuestTypeIcons:14:14:0:0:128:64:18:32:2:16|t %u / %u", numQuests, maxQuestsCanAccept));

  -- if (data.settings.showTotalSlots) then
  --   self.Button:SetText(string.format("", numQuests, maxQuestsCanAccept));
  -- else
  --   self.Button:SetText(string.format("", numQuests));
  -- end
end

function Quest:Click() end