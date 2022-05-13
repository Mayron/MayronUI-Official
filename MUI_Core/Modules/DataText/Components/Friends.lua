-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, _, em, _, obj, L = MayronUI:GetCoreComponents();
local LABEL_PATTERN = L["Friends"]..": |cffffffff%u|r";
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
local BNGetNumFriends, BNGetFriendInfo = _G.BNGetNumFriends, _G.BNGetFriendInfo;
local string, CreateFrame, ChatFrame1EditBox, ChatMenu_SetChatType, ChatFrame1 =
  _G.string, _G.CreateFrame, _G.ChatFrame1EditBox, _G.ChatMenu_SetChatType, _G.ChatFrame1;
local select = _G.select;
local Friends = obj:CreateClass("Friends");

local LocalToggleFriendsFrame = _G.ToggleFriendsFrame;

if (not tk:IsRetail()) then
  LocalToggleFriendsFrame = function() _G.ToggleFriendsFrame(1); end
end

-- GLOBALS:
--[[ luacheck: ignore GameTooltip C_QuestLog ]]

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

local function ButtonOnEnter(self)
  local r, g, b = tk:GetThemeColor();
  GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
  GameTooltip:SetText(L["Commands"]..":");

  GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Left Click:"]), L["Show Online Friends"], r, g, b, 1, 1, 1);
  GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Right Click:"]), L["Toggle Friends List"], r, g, b, 1, 1, 1);
  GameTooltip:Show();
end

-- Friends Module --------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
  self:RegisterComponentClass("friends", Friends);
end);

function Friends:__Construct(data, settings, dataTextModule, slideController)
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

function Friends:SetEnabled(data, enabled)
  data.enabled = enabled;

  local listenerID = "DataText_Friends_OnChange";
  if (enabled) then
    if (not em:GetEventListenerByID(listenerID)) then
      local listener = em:CreateEventListenerWithID(listenerID, function()
        if (not self.Button) then return; end
        self:Update();
      end);

      listener:RegisterEvent("FRIENDLIST_UPDATE");
    else
      em:EnableEventListeners(listenerID);
    end

    self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    self.Button:SetScript("OnEnter", ButtonOnEnter);
    self.Button:SetScript("OnLeave", tk.GeneralTooltip_OnLeave);
  else
    em:DisableEventListeners(listenerID);
    self.Button:RegisterForClicks("LeftButtonUp");
    self.Button:SetScript("OnEnter", nil);
    self.Button:SetScript("OnLeave", nil);
  end
end

function Friends:IsEnabled(data)
  return data.enabled;
end

function Friends:Update(data, refreshSettings)
  if (refreshSettings) then
    data.settings:Refresh();
  end

  local totalOnline = C_FriendList.GetNumOnlineFriends() + (select(2, BNGetNumFriends()));
  self.Button:SetText(string.format(LABEL_PATTERN, totalOnline));
end

obj:DefineReturns("number");
function Friends:CheckBattleNetFriendsList(data)
  local r, g, b = tk:GetThemeColor();
  local totalLabelsShown = 0;

  for i = 1, BNGetNumFriends() do
    local isOnline, isDND, isAFK, accountName, client;

    if (BNGetFriendInfo) then
      _, accountName, _, _, _, _, client, isOnline, _, isAFK, isDND = BNGetFriendInfo(i);
    else
      local friendInfo = _G.C_BattleNet.GetFriendAccountInfo(i);
      local gameInfo = friendInfo.gameAccountInfo;

      isDND = friendInfo.isDND;
      isAFK = friendInfo.isAFK;
      accountName = friendInfo.accountName;
      client = "App";

      if (obj:IsTable(gameInfo)) then
        isOnline = gameInfo.isOnline;
        client = gameInfo.clientProgram;
      end
    end

    if (isOnline) then
      totalLabelsShown = totalLabelsShown + 1;

      local status = (isAFK and "|cffffe066[AFK] |r") or (isDND and "|cffff3333[DND] |r") or "";
      local label = self.MenuLabels[totalLabelsShown] or CreateLabel(self.MenuContent, data.slideController);
      self.MenuLabels[totalLabelsShown] = label;

      label.id = accountName;
      label:SetNormalTexture(1);
      label:GetNormalTexture():SetColorTexture(r * 0.4, g * 0.4, b * 0.4, 0.2);
      label:SetHighlightTexture(1);
      label:GetHighlightTexture():SetColorTexture(r * 0.4, g * 0.4, b * 0.4, 0.4);

      client = convert[client] or client;
      client = string.format(" (%s)", client);

      local friendLabel = string.format("%s%s%s", status , label.id, client);
      label.name:SetText(friendLabel);
    end
  end

  return totalLabelsShown;
end

obj:DefineParams("number");
obj:DefineReturns("number");
function Friends:CheckWowFriendsList(data, totalLabelsShown)
  for i = 1, C_FriendList.GetNumFriends() do
    local friendInfo = C_FriendList.GetFriendInfoByIndex(i);

    if (friendInfo.connected and not (friendInfo.className == "Unknown")) then

      local status = tk.Strings.Empty;

      if (friendInfo.afk) then
        status = " |cffffe066[AFK]|r";
      elseif (friendInfo.dnd) then
        status = " |cffff3333[DND]|r";
      end

      totalLabelsShown = totalLabelsShown + 1;

      local label = self.MenuLabels[totalLabelsShown] or CreateLabel(self.MenuContent, data.slideController);
      self.MenuLabels[totalLabelsShown] = label; -- old: numBNFriends + i

      label.id = friendInfo.name;
      label:SetNormalTexture(1);
      label:GetNormalTexture():SetColorTexture(0, 0, 0, 0.2);
      label:SetHighlightTexture(1);
      label:GetHighlightTexture():SetColorTexture(0.2, 0.2, 0.2, 0.4);

      local _, className = tk.Tables:First(
          tk.Constants.LOCALIZED_CLASS_NAMES, function(value)
            return value == friendInfo.className;
          end);

      local classText = tk.Strings:SetTextColorByClassFilename(friendInfo.name, className);
      label.name:SetText(string.format("%s%s %s ", classText, status, friendInfo.level));
    end
  end

  return totalLabelsShown;
end

function Friends:Click(_, button)
  if (button == "RightButton") then
    LocalToggleFriendsFrame();
    return;
  end

  if (select(2, C_FriendList.GetNumFriends()) == 0 and select(2, BNGetNumFriends()) == 0) then
    return true;
  end

  -- Battle.Net friends
  local totalLabelsShown = self:CheckBattleNetFriendsList();

  -- WoW Friends (non-Battle.Net)
  self.TotalLabelsShown = self:CheckWowFriendsList(totalLabelsShown);
end