-- Setup Namespaces ------------------

local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local LABEL_PATTERN = L["Friends"]..": |cffffffff%u|r";
local convert = {WTCG = "HS", Pro = "OW"};

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local DataText = MayronUI:ImportModule("DataText");
local Friends = Engine:CreateClass("Friends", nil, "MayronUI.Engine.IDataTextModule");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.friends", {
    enabled = true,
    displayOrder = 2
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
                ChatFrame_SendSmartTell(self.id);
                slideController:Start(slideController.Static.FORCE_RETRACT);
            end
        end

        label:SetScript("OnClick", onLabelClickFunc);

        return label;
    end
end

-- Friends Module --------------

DataText:Hook("OnInitialize", function(self, dataTextData)
    local sv = db.profile.datatext.friends;
    sv:SetParent(dataTextData.sv);

    if (sv.enabled) then
        local friends = Friends(sv, dataTextData.slideController);
        self:RegisterDataModule(friends);
    end
end);

function Friends:__Construct(data, sv, slideController)
    data.sv = sv;
    data.displayOrder = sv.displayOrder;
    data.slideController = slideController;

    -- set public instance properties
    self.MenuContent = CreateFrame("Frame");
    self.MenuLabels = {};
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = true;
    self.HasRightMenu = false;

    self.Button = DataText:CreateDataTextButton(self);
    self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");

    data.showMenu = nil;

    data.handler = em:CreateEventHandler("FRIENDLIST_UPDATE", function()
        if (not self.Button) then return; end
        self:Update();
    end);  
end

function Friends:Enable(data) 
    data.sv.enabled = true;
end

function Friends:Disable(data)
    data.sv.enabled = false;
    if (data.handler) then
        data.handler:Destroy();
    end

    self.Button:RegisterForClicks("LeftButtonUp");
end

function Friends:IsEnabled(data) 
    return data.sv.enabled;
end

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
    self.Button:SetText(tk.string.format(LABEL_PATTERN, total_online));
end

function Friends:Click(data, button)
    if (button == "RightButton") then
        ToggleFriendsFrame();
        return;
    end

    if (tk.select(2, GetNumFriends()) == 0 and tk.select(2, BNGetNumFriends()) == 0) then 
        return; 
    end

    local r, g, b = tk:GetThemeColor();
    local totalLabelsShown = 0;

    -- Battle.Net friends
    for i = 1, BNGetNumFriends() do
        local _, realName, _, _, toonName, _, client, online, _, isAFK, isDND = BNGetFriendInfo(i);

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
    for i = 1, GetNumFriends() do
        local name, level, class, _, online, status = GetFriendInfo(i);

        if (online) then
            local classFileName = tk:GetIndex(tk.Constants.LOCALIZED_CLASS_NAMES, class) or class;

            status = (status == " <Away>" and " |cffffe066[AFK]|r") or 
                     (status == " <DND>" and " |cffff3333[DND]|r") or "";

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

function Friends:GetDisplayOrder(data)
    return data.displayOrder;
end

function Friends:SetDisplayOrder(data, displayOrder)
    if (data.displayOrder ~= displayOrder) then
        data.displayOrder = displayOrder;
        data.sv.displayOrder = displayOrder;
    end
end 