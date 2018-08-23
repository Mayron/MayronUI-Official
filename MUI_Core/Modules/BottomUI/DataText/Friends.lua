-- Setup Namespaces ------------------

local _, Core = ...;

local em = Core.EventManager;
local tk = Core.Toolkit;
local db = Core.Database;
local gui = Core.GUIBuilder;
local L = Core.Locale;

local LABEL_PATTERN = L["Friends"]..": |cffffffff%u|r";
local convert = {WTCG = "HS", Pro = "OW"};

-- Register and Import Modules -------

local DataText = MayronUI:ImportModule("BottomUI_DataText");
local FriendsModule, Friends = MayronUI:RegisterModule("DataText_Friends");
local Engine = Core.Objects:Import("MayronUI.Engine");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.friends", {
    enabled = true,
    displayOrder = 2
});

-- Local Functions ----------------

local function CreateLabel(c)
    local label = tk:PopFrame("Button", c);
    label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.name:SetPoint("LEFT", 6, 0);
    label.name:SetPoint("RIGHT", -10, 0);
    label.name:SetWordWrap(false);
    label.name:SetJustifyH("LEFT");
    label:SetScript("OnClick", OnLabelClick);

    return label;
end

local function OnLabelClick(self)
    ChatFrame_SendSmartTell(self.id);
    DataText.slideController:Start(); -- remove
end

-- Friends Module --------------

FriendsModule:OnInitialize(function(self, data) 
    data.sv = db.profile.datatext.friends;

    if (data.sv.enabled) then
        DataText:RegisterDataItem(self, data.sv.displayOrder);
    end
end);

FriendsModule:OnEnable(function(self, data, btn)
    data.btn = btn;  
    data.btn:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    data.showMenu = nil;

    data.handler = em:CreateEventHandler("FRIENDLIST_UPDATE", function()
        if (not data.btn) then 
            return; 
        end

        self:Update();
    end);  
end);

FriendsModule:OnDisable(function(self, data)
    if (data.handler) then
        data.handler:Destroy();
    end

    data.btn:RegisterForClicks("LeftButtonUp");
end);

-- Friends Object --------------

function Friends:Update(data)
    local total_online = 0;

    for i = 1, BNGetNumFriends() do
        if ((tk.select(8, BNGetFriendInfo(i)))) then
            total_online = total_online + 1;
        end
    end

    for i = 1, GetNumFriends() do
        if ((tk.select(5, GetFriendInfo(i)))) then
            total_online = total_online + 1;
        end
    end

    data.showMenu = (total_online ~= 0);
    data.btn:SetText(tk.string.format(LABEL_PATTERN, total_online));
end

function Friends:Click(data, content)
    if (button == "RightButton") then
        DataText.slideController:Start(); -- remove
        ToggleFriendsFrame();
        return;
    end

    if (tk.select(2, GetNumFriends()) == 0 and tk.select(2, BNGetNumFriends()) == 0) then 
        return; 
    end

    content.labels = content.labels or {};

    local r, g, b = tk:GetThemeColor();
    local numLabelsShown = 0;

    for i = 1, BNGetNumFriends() do
        local _, realName, _, _, toonName, _, client, online, _, isAFK, isDND = BNGetFriendInfo(i);

        if (online) then
            numLabelsShown = numLabelsShown + 1;
            local status = (isAFK and "|cffffe066[AFK] |r") or (isDND and "|cffff3333[DND] |r") or "";

            local label = content.labels[numLabelsShown] or CreateLabel(content);
            content.labels[numLabelsShown]= label;

            label.id = realName;
            label:SetNormalTexture(1);
            label:GetNormalTexture():SetColorTexture(r * 0.4, g * 0.4, b * 0.4, 0.2);
            label:SetHighlightTexture(1);
            label:GetHighlightTexture():SetColorTexture(r * 0.4, g * 0.4, b * 0.4, 0.4);

            if (not client or client == "App") then
                client = "";
            else
                client = convert[client] or client;
                client = tk.string.format(" (%s)", client);
            end

            label.name:SetText(tk.string.format("%s%s%s", status , realName, client));
        end
    end

    for i = 1, GetNumFriends() do
        local name, level, class, _, online, status = GetFriendInfo(i);
        if (online) then
            local classFileName = tk:GetIndex(tk.Constants.LOCALIZED_CLASS_NAMES, class) or class;

            status = (status == " <Away>" and " |cffffe066[AFK]|r") or 
                     (status == " <DND>" and " |cffff3333[DND]|r") or "";

            numLabelsShown = numLabelsShown + 1;

            local label = content.labels[numLabelsShown] or CreateLabel(content);
            content.labels[numLabelsShown] = label; -- old: numBNFriends + i

            label.id = name;
            label:SetNormalTexture(1);
            label:GetNormalTexture():SetColorTexture(0, 0, 0, 0.2);
            label:SetHighlightTexture(1);
            label:GetHighlightTexture():SetColorTexture(0.2, 0.2, 0.2, 0.4);
            label.name:SetText(tk.string.format("%s%s %s ", tk:GetClassColoredString(classFileName, name), status, level));
        end
    end

    return numLabelsShown;
end

function Friends:HasMenu()
    return true;
end

Engine:DefineReturns("Button");
function Friends:GetButton(data)
    return data.btn;
end