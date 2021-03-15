-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, _, em, _, obj, L = MayronUI:GetCoreComponents();
local LABEL_PATTERN = L["Currency"]..": |cffffffff%u|r";
local convert = {
  WTCG = "HS",
  Pro = "OW",
  BSAp = "App",
  VIPR = "COD",
  ODIN = "COD",
  LAZR = "COD",
  ZEUS = "COD",
};

local C_FriendList = _G.C_FriendList;
local BNGetNumCurrency, BNGetFriendInfo = _G.BNGetNumCurrency, _G.BNGetFriendInfo;
local string, CreateFrame, ChatFrame1EditBox, ChatMenu_SetChatType, ChatFrame1 =
  _G.string, _G.CreateFrame, _G.ChatFrame1EditBox, _G.ChatMenu_SetChatType, _G.ChatFrame1;
local select = _G.select;
local ToggleCurrencyFrame = _G.ToggleCurrencyFrame;
local Currency = obj:CreateClass("Currency");

-- Local Functions -------------------

local CreateLabel;
do
  local onLabelClickFunc;

  function CreateLabel(contentFrame, slideController)
    local label = tk:PopFrame("Button", contentFrame);

    label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.name:SetPoint("LEFT", 6, 0);
    label.name:SetPoint("RIGHT", -10, 0);
    label.name:SetWordWrap(false);
    label.name:SetJustifyH("LEFT");

    if (not onLabelClickFunc) then
      onLabelClickFunc = function(self)
        ChatFrame1EditBox:SetAttribute("tellTarget", self.id);
        ChatMenu_SetChatType(ChatFrame1, "SMART_WHISPER");
        slideController:Start(slideController.Static.FORCE_RETRACT);
      end
    end

    label:SetScript("OnClick", onLabelClickFunc);

    return label;
  end
end

-- Currency Module --------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
  self:RegisterComponentClass("currency", Currency);
end);

function Currency:__Construct(data, settings, dataTextModule, slideController)
  data.settings = settings;
  data.slideController = slideController;

  -- set public instance properties
  self.MenuContent = CreateFrame("Frame");
  self.MenuLabels = obj:PopTable();
  self.TotalLabelsShown = 0;
  self.HasLeftMenu = true;
  self.HasRightMenu = false;
  self.Button = dataTextModule:CreateDataTextButton();
end

function Currency:SetEnabled(data, enabled)
  data.enabled = enabled;

  local listenerID = "DataText_Currency_OnChange";
  if (enabled) then
    if (not em:GetEventListenerByID(listenerID)) then
      local listener = em:CreateEventListenerWithID(listenerID, function()
        if (not self.Button) then return end
        self:Update();
      end);

      listener:RegisterEvent("FRIENDLIST_UPDATE");
    else
      em:EnableEventListeners(listenerID);
    end

    self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
  else
    em:DisableEventListeners(listenerID);
    self.Button:RegisterForClicks("LeftButtonUp");
  end
end

function Currency:IsEnabled(data)
  return data.enabled;
end

function Currency:Update(data, refreshSettings)
  if (refreshSettings) then
    data.settings:Refresh();
  end

  -- local totalOnline = C_FriendList.GetNumOnlineCurrency() + (select(2, BNGetNumCurrency()));
  -- self.Button:SetText(string.format(LABEL_PATTERN, totalOnline));
end

function Currency:Click(_, button)
  if (select(2, C_FriendList.GetNumCurrency()) == 0 and select(2, BNGetNumCurrency()) == 0) then
    return true;
  end

  self.TotalLabelsShown = 0;
end