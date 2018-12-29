-- luacheck: ignore MayronUI self 143 631
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents();

local LABEL_PATTERN = L["Friends"]..": |cffffffff%u|r";
local convert = {WTCG = "HS", Pro = "OW"};

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local Friends = Engine:CreateClass("Friends", nil, "MayronUI.Engine.IDataTextModule");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.friends", {
    enabled = true
});

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
                _G.ChatFrame1EditBox:SetAttribute("tellTarget", self.id);
                _G.ChatMenu_SetChatType(_G.ChatFrame1, "SMART_WHISPER");
                slideController:Start(slideController.Static.FORCE_RETRACT);
            end
        end

        label:SetScript("OnClick", onLabelClickFunc);

        return label;
    end
end

-- Friends Module --------------

MayronUI:Hook("DataText", "OnInitialize", function(self, dataTextData)
    local sv = db.profile.datatext.friends;
    sv:SetParent(db.profile.datatext);

    local settings = sv:GetTrackedTable();

    if (settings.enabled) then
        local friends = Friends(settings, dataTextData.slideController, self);
        self:RegisterDataModule(friends);
    end
end);

function Friends:__Construct(data, settings, slideController, dataTextModule)
    data.settings = settings;
    data.slideController = slideController;

    -- set public instance properties
    self.MenuContent = _G.CreateFrame("Frame");
    self.MenuLabels = {};
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = true;
    self.HasRightMenu = false;
    self.SavedVariableName = "friends";

    self.Button = dataTextModule:CreateDataTextButton();
    self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");

    data.showMenu = nil;

    data.handler = em:CreateEventHandler("FRIENDLIST_UPDATE", function()
        if (not self.Button) then return; end
        self:Update();
    end);
end

function Friends:Enable(data)
    data.settings.enabled = true;
    data.settings:SaveChanges();
end

function Friends:Disable(data)
    data.settings.enabled = false;
    data.settings:SaveChanges();

    if (data.handler) then
        data.handler:Destroy();
    end

    self.Button:RegisterForClicks("LeftButtonUp");
end

function Friends:IsEnabled(data)
    return data.settings.enabled;
end

function Friends:Update(data)
    local total_online = 0;

    for i = 1, _G.BNGetNumFriends() do
        if ((select(8, _G.BNGetFriendInfo(i)))) then
            total_online = total_online + 1;
        end
    end

    for i = 1, _G.GetNumFriends() do
        if ((tk.select(5, _G.GetFriendInfo(i)))) then
            total_online = total_online + 1;
        end
    end

    data.showMenu = (total_online ~= 0);
    self.Button:SetText(tk.string.format(LABEL_PATTERN, total_online));
end

function Friends:Click(data, button)
    if (button == "RightButton") then
        _G.ToggleFriendsFrame();
        return
    end

    if (tk.select(2, _G.GetNumFriends()) == 0 and tk.select(2, _G.BNGetNumFriends()) == 0) then
        return;
    end

    local r, g, b = tk:GetThemeColor();
    local totalLabelsShown = 0;

    -- Battle.Net friends
    for i = 1, _G.BNGetNumFriends() do
        local _, realName, _, _, _, _, client, online, _, isAFK, isDND = _G.BNGetFriendInfo(i);

        if (online) then
            totalLabelsShown = totalLabelsShown + 1;

            local status = (isAFK and "|cffffe066[AFK] |r") or (isDND and "|cffff3333[DND] |r") or "";
            local label = self.MenuLabels[totalLabelsShown] or CreateLabel(self.MenuContent, data.slideController);
            self.MenuLabels[totalLabelsShown] = label;

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

    -- WoW Friends (non-Battle.Net)
    for i = 1, _G.GetNumFriends() do
        local name, level, class, _, online, status = _G.GetFriendInfo(i);

        if (online) then
            local classFileName = tk:GetIndex(tk.Constants.LOCALIZED_CLASS_NAMES, class) or class;

            if (status:trim() == "<Away") then
                status = " |cffffe066[AFK]|r";
            elseif (status:trim() == "<DND>") then
                status = " |cffff3333[DND]|r";
            else
                status = tk.Strings.Empty;
            end

            totalLabelsShown = totalLabelsShown + 1;

            local label = self.MenuLabels[totalLabelsShown] or CreateLabel(self.MenuContent, data.slideController);
            self.MenuLabels[totalLabelsShown] = label; -- old: numBNFriends + i

            label.id = name;
            label:SetNormalTexture(1);
            label:GetNormalTexture():SetColorTexture(0, 0, 0, 0.2);
            label:SetHighlightTexture(1);
            label:GetHighlightTexture():SetColorTexture(0.2, 0.2, 0.2, 0.4);
            label.name:SetText(tk.string.format("%s%s %s ",
                tk:GetClassColoredString(classFileName, name), status, level));
        end
    end

    self.TotalLabelsShown = totalLabelsShown;
end