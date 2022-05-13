-- luacheck: ignore MayronUI self 143 631
local tk, _, em, _, obj, L = _G.MayronUI:GetCoreComponents();
local Quest = obj:CreateClass("Quest");
local GetNumQuestLogEntries = _G.C_QuestLog.GetNumQuestLogEntries or _G.GetNumQuestLogEntries;
local string = _G.string;

-- GLOBALS:
--[[ luacheck: ignore GameTooltip C_QuestLog ]]

local function ButtonOnEnter(self)
  local r, g, b = tk:GetThemeColor();
  GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
  GameTooltip:SetText(L["Commands"]..":");

  GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Left Click:"]), L["Toggle Questlog"], r, g, b, 1, 1, 1);

  GameTooltip:Show();
end

-- Quest Module ----------------

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
        self:Update(data);
      end);

      listener:RegisterEvent("QUEST_LOG_UPDATE");
    else
      em:EnableEventListeners(listenerID);
    end

    self.Button:RegisterForClicks("LeftButtonUp");
    self.Button:SetScript("OnEnter", ButtonOnEnter);
    self.Button:SetScript("OnLeave", tk.GeneralTooltip_OnLeave);
  else
    em:DisableEventListeners(listenerID);
    self.Button:SetScript("OnEnter", nil);
    self.Button:SetScript("OnLeave", nil);
  end
end

function Quest:Update(data, refreshSettings)
  if (refreshSettings) then
    data.settings:Refresh();
  end

  local _, numQuests = GetNumQuestLogEntries()
  local maxQuestsCanAccept = C_QuestLog.GetMaxNumQuestsCanAccept();

  self.Button:SetText(string.format(L["Quests"]..": |cffffffff%u/%u|r", numQuests, maxQuestsCanAccept));
end

function Quest:Click()
  _G.ToggleQuestLog();
end