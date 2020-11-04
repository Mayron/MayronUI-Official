local _, namespace = ...;

-- luacheck: ignore MayronUI self 143 631
local tk, _, em, _, obj, L = MayronUI:GetCoreComponents();
local ComponentsPackage = namespace.ComponentsPackage;

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

local _G = _G;
local ToggleFriendsFrame, C_FriendList = _G.ToggleFriendsFrame, _G.C_FriendList;
local BNGetNumFriends = _G.BNGetNumFriends;
local string, CreateFrame, ChatFrame1EditBox, ChatMenu_SetChatType, ChatFrame1 =
_G.string, _G.CreateFrame, _G.ChatFrame1EditBox, _G.ChatMenu_SetChatType, _G.ChatFrame1;
local select = _G.select;

-- Register and Import Modules -------

local Friends = ComponentsPackage:CreateClass("Friends", nil, "IDataTextComponent");

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

    if (enabled) then
        data.handler = em:CreateEventHandler("FRIENDLIST_UPDATE", function()
            if (not self.Button) then return; end
            self:Update();
        end);

        self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    else
        if (data.handler) then
            data.handler:Destroy();
            data.handler = nil;
        end

        self.Button:RegisterForClicks("LeftButtonUp");
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

function Friends:Click(data, button)
    if (button == "RightButton") then
        ToggleFriendsFrame();
        return;
    end

    if (select(2, C_FriendList.GetNumFriends()) == 0 and select(2, BNGetNumFriends()) == 0) then
        return true;
    end

    local r, g, b = tk:GetThemeColor();
    local totalLabelsShown = 0;

    -- Battle.Net friends
    for i = 1, BNGetNumFriends() do
        -- local _, realName, _, _, _, _, client, online, _, isAFK, isDND = BNGetFriendInfo(i);
        local friendInfo = _G.C_BattleNet.GetFriendAccountInfo(i);
        local gameInfo = friendInfo.gameAccountInfo;

        if (gameInfo and gameInfo.isOnline) then
            totalLabelsShown = totalLabelsShown + 1;

            local status = (friendInfo.isAFK and "|cffffe066[AFK] |r") or (friendInfo.isDND and "|cffff3333[DND] |r") or "";
            local label = self.MenuLabels[totalLabelsShown] or CreateLabel(self.MenuContent, data.slideController);
            self.MenuLabels[totalLabelsShown] = label;

            label.id = friendInfo.accountName;
            label:SetNormalTexture(1);
            label:GetNormalTexture():SetColorTexture(r * 0.4, g * 0.4, b * 0.4, 0.2);
            label:SetHighlightTexture(1);
            label:GetHighlightTexture():SetColorTexture(r * 0.4, g * 0.4, b * 0.4, 0.4);

            local client;

            if (friendInfo.gameAccountInfo) then
              client = friendInfo.gameAccountInfo.clientProgram or "App";
            end

            client = convert[client] or client;
            client = string.format(" (%s)", client);

            label.name:SetText(string.format("%s%s%s", status , label.id, client));
        end
    end

    -- WoW Friends (non-Battle.Net)
    for i = 1, C_FriendList.GetNumFriends() do
        local friendInfo = C_FriendList.GetFriendInfoByIndex(i);

        if (friendInfo.connected and not (friendInfo.className == "Unknown")) then
            local classFileName = tk:GetLocalizedClassName(friendInfo.className);

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

            local classText = tk.Strings:SetTextColorByClass(friendInfo.name, classFileName);
            label.name:SetText(string.format("%s%s %s ", classText, status, friendInfo.level));
        end
    end

    self.TotalLabelsShown = totalLabelsShown;
end