-- luacheck: ignore MayronUI self 143 631
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents();

local strsplit, unpack, CreateFrame, ChatFrame1EditBox, ChatMenu_SetChatType, ChatFrame1,
IsInGuild, GetNumGuildMembers, GetGuildRosterInfo, IsTrialAccount =
_G.strsplit, _G.unpack, _G.CreateFrame, _G.ChatFrame1EditBox, _G.ChatMenu_SetChatType, _G.ChatFrame1,
_G.IsInGuild, _G.GetNumGuildMembers, _G.GetGuildRosterInfo, _G.IsTrialAccount;

local LocalToggleGuildFrame = _G.ToggleGuildFrame;

-- GLOBALS:
--[[ luacheck: ignore GameTooltip C_QuestLog ]]

if (tk:IsBCClassic()) then
  LocalToggleGuildFrame = function() _G.ToggleFriendsFrame(3); end
elseif (tk:IsClassic()) then
  LocalToggleGuildFrame = function() _G.ToggleFriendsFrame(1); end
end

local GuildRoster = _G.GuildRoster or (_G.C_GuildInfo and _G.C_GuildInfo.GuildRoster);

-- Register and Import Modules -------

local Guild = obj:CreateClass("Guild");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.guild", {
  showSelf = true,
  showTooltips = true
});

local function ButtonOnEnter(self)
  local r, g, b = tk:GetThemeColor();
  GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
  GameTooltip:SetText(L["Commands"]..":");

  GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Left Click:"]), L["Show Guild Members"], r, g, b, 1, 1, 1);
  GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Right Click:"]), L["Toggle Guild Pane"], r, g, b, 1, 1, 1);
  GameTooltip:Show();
end

-- Local Functions ----------------

local CreateLabel;
do
  local onLabelClickFunc;

  local function LabelOnEnter(self)
    local fullName, rank, _, _, _, zone, note, _, _, _, classFileName, achievementPoints = unpack(self.guildRosterInfo);
    fullName = strsplit("-", fullName);

    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
    GameTooltip:AddLine(tk.Strings:SetTextColorByClassFilename(fullName, classFileName));
    GameTooltip:AddDoubleLine(L["Zone"]..":", zone, nil, nil, nil, 1, 1, 1);
    GameTooltip:AddDoubleLine(L["Rank"]..":", rank, nil, nil, nil, 1, 1, 1);

    if (#note > 0) then
      GameTooltip:AddDoubleLine(L["Notes"]..":", note, nil, nil, nil, 1, 1, 1);
    end

    if (tk:IsRetail()) then
      GameTooltip:AddDoubleLine(L["Achievement Points"]..":", achievementPoints, nil, nil, nil, 1, 1, 1);
    end
    GameTooltip:Show();
  end

  function CreateLabel(contentFrame, popupWidth, slideController, showTooltips)
    local label = tk:PopFrame("Button", contentFrame);

    label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.name:SetPoint("LEFT", 6, 0);
    label.name:SetWidth(popupWidth - 10);
    label.name:SetWordWrap(false);
    label.name:SetJustifyH("LEFT");

    if (showTooltips) then
      label:SetScript("OnEnter", LabelOnEnter);
      label:SetScript("OnLeave", tk.GeneralTooltip_OnLeave);
    end

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

-- Guild Module --------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
  self:RegisterComponentClass("guild", Guild);
end);

function Guild:__Construct(data, settings, dataTextModule, slideController)
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

function Guild:IsEnabled(data)
  return data.enabled;
end

function Guild:SetEnabled(data, enabled)
  data.enabled = enabled;

  local listenerID = "DataText_GuildMembers_OnChange";
  if (enabled) then
    if (not em:GetEventListenerByID(listenerID)) then
      local listener = em:CreateEventListenerWithID(listenerID, function()
        if (not self.Button) then return end
        self:Update();
      end);

      listener:RegisterEvent("GUILD_ROSTER_UPDATE");
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

function Guild:Update(data, refreshSettings)
  if (refreshSettings) then
    data.settings:Refresh();
  end

  if (not IsInGuild()) then
    self.Button:SetText(L["No Guild"]);
  else
    GuildRoster(); -- Must get data from server first!

    local _, _, numOnlineAndMobile = GetNumGuildMembers();
    numOnlineAndMobile = (not data.settings.showSelf and numOnlineAndMobile - 1) or numOnlineAndMobile;

    local label = tk.Strings.Empty;
    local hideLabel = obj:IsTable(data.settings.labels.hidden) and data.settings.labels.hidden.guild;

    if (not hideLabel) then
      label = data.settings.labels.guild .. ": ";
    end

    self.Button:SetText(string.format("%s|cffffffff%u|r", label, numOnlineAndMobile));
  end
end

function Guild:Click(data, button)
  if (button == "RightButton") then
    if (IsTrialAccount()) then
      tk:Print(L["Starter Edition accounts cannot perform this action."]);
    elseif (IsInGuild()) then
      LocalToggleGuildFrame();
    else
      tk:Print("You need to be in a guild to perform this action.");
    end

    return;
  end

  if (not IsInGuild()) then
    return true;
  end

  local totalLabelsShown = 0;
  local playerName = tk:GetPlayerKey();

  for i = 1, (GetNumGuildMembers()) do
    local fullName, _, _, level, _, _, _, _, online, status, classFileName = GetGuildRosterInfo(i);

    if (online and (data.settings.showSelf or fullName ~= playerName)) then
      totalLabelsShown = totalLabelsShown + 1;

      if (status == 1) then
        status = " |cffffe066[AFK]|r";
      elseif (status == 2) then
        status = " |cffff3333[DND]|r";
      else
        status = tk.Strings.Empty;
      end

      local label = self.MenuLabels[totalLabelsShown] or
      CreateLabel(self.MenuContent, data.settings.popup.width, data.slideController, data.settings.showTooltips);

      self.MenuLabels[totalLabelsShown] = label;

      label.id = fullName; -- used for messaging
      fullName = strsplit("-", fullName);

      label:SetNormalTexture(1);
      label:GetNormalTexture():SetColorTexture(0, 0, 0, 0.2);
      label:SetHighlightTexture(1);
      label:GetHighlightTexture():SetColorTexture(0.2, 0.2, 0.2, 0.4);

      -- required for button_OnEnter
      if (obj:IsTable(label.guildRosterInfo)) then
        label.guildRosterInfo = nil;
      end

      label.guildRosterInfo = { _G.GetGuildRosterInfo(i) };

      label.name:SetText(string.format("%s%s %s",
      tk.Strings:SetTextColorByClassFilename(fullName, classFileName), status, level));
    end
  end

  self.TotalLabelsShown = totalLabelsShown;
end