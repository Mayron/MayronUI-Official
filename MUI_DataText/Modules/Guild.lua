-- Setup Namespaces ------------------

local _, Core = ...;

local em = Core.EventManager;
local tk = Core.Toolkit;
local db = Core.Database;
local gui = Core.GUIBuilder;
local L = Core.Locale;

local LABEL_PATTERN = L["Guild"]..": |cffffffff%u|r";

-- Register and Import Modules -------

local DataText = MayronUI:ImportModule("BottomUI_DataText");
local GuildModule, Guild = MayronUI:RegisterModule("DataText_Guild");
local Engine = Core.Objects:Import("MayronUI.Engine");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.guild", {
    enabled = true,
    show_self = true,
    show_tooltips = true,
    displayOrder = 3
});

-- Local Functions ----------------

local function OnLabelClick(self)
    ChatFrame_SendSmartTell(self.id);
    DataText.slideController:Start();
end

local function CreateLabel(c)
    local label = tk:PopFrame("Button", c);

    label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.name:SetPoint("LEFT", 6, 0);
    label.name:SetWidth(DataText.sv.menu_width - 10);
    label.name:SetWordWrap(false);
    label.name:SetJustifyH("LEFT");

    if (DataText.sv.guild.show_tooltips) then
        label:SetScript("OnEnter", items.guild.OnEnter);
        label:SetScript("OnLeave", items.guild.OnLeave);
    end

    label:SetScript("OnClick", OnLabelClick);
    return label;
end

local function Button_OnEnter(self)    
    local fullName, rank, _, _, _, zone, note, _, _, status, classFileName, achievementPoints = tk.unpack(self.data);
    fullName = tk.strsplit("-", fullName);

    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
    GameTooltip:AddLine(tk:GetClassColoredString(classFileName, fullName));
    GameTooltip:AddDoubleLine(L["Zone"]..":", zone, nil, nil, nil, 1, 1, 1);
    GameTooltip:AddDoubleLine(L["Rank"]..":", rank, nil, nil, nil, 1, 1, 1);

    if (#note > 0) then
        GameTooltip:AddDoubleLine(L["Notes"]..":", note, nil, nil, nil, 1, 1, 1);
    end

    GameTooltip:AddDoubleLine(L["Achievement Points"]..":", achievementPoints, nil, nil, nil, 1, 1, 1);
    GameTooltip:Show();
end

local   function Button_OnLeave(self)
    GameTooltip:Hide();
end

-- Guild Module --------------

GuildModule:OnInitialize(function(self, data) 
    data.sv = db.profile.datatext.guild;

    if (data.sv.enabled) then
        --DataText:RegisterDataItem(self);
    end
end);

GuildModule:OnEnable(function(self, data, btn)
    data.btn = btn;
    data.btn:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    data.showMenu = nil;

    data.handler = em:CreateEventHandler("GUILD_ROSTER_UPDATE", function()
        if (not data.btn) then return; end
        data:update();
    end);   
end);

GuildModule:OnDisable(function(self, data)
    if (data.handler) then
        data.handler:Destroy();
    end

    data.btn:RegisterForClicks("LeftButtonUp");
end);

-- Guild Object --------------

function Guild:Update(data)
    if (not IsInGuild()) then
        data.btn:SetText(L["No Guild"]);
    else
        GuildRoster(); -- Must get data from server first!
        local _, _, numOnlineAndMobile = GetNumGuildMembers();

        local showSelf = DataText.sv.guild.show_self; -- TODO Remove this!
        numOnlineAndMobile = (not showSelf and numOnlineAndMobile - 1) or numOnlineAndMobile;

        data.showMenu = (numOnlineAndMobile ~= 0);
        data.btn:SetText(tk.string.format(LABEL_PATTERN, numOnlineAndMobile));
    end
end

function Guild:Click(data)
    self:Update();

    if (button == "RightButton") then
        if (IsTrialAccount()) then
            tk:Print(L["Starter Edition accounts cannot perform this action."]);
        elseif (IsInGuild()) then
            ToggleGuildFrame();
        end

        DataText.slideController:Start(); -- TODO: Remove!
        return;
    end

    if (not IsInGuild()) then 
        return; 
    end

    data.content.labels = data.content.labels or {};

    local numLabelsShown = 0;
    local playerName = tk:GetPlayerKey();

    for i = 1, (GetNumGuildMembers()) do
        local fullName, _, _, level, class, _, _, _, online, status, classFileName = GetGuildRosterInfo(i);
        local showSelf = DataText.sv.guild.show_self; -- TODO: Remove!
        
        if (online and fullName ~= playerName) then
            numLabelsShown = numLabelsShown + 1;

            local status = (status == 1 and " |cffffe066[AFK]|r") or (status == 2 and " |cffff3333[DND]|r") or "";
            local label = data.content.labels[numLabelsShown] or CreateLabel(data.content);

            data.content.labels[numLabelsShown] = label;

            if (items.guild.update_required) then
                if (DataText.sv.guild.show_tooltips) then
                    label:SetScript("OnEnter", items.guild.OnEnter);
                    label:SetScript("OnLeave", items.guild.OnLeave);
                else
                    label:SetScript("OnEnter", nil);
                    label:SetScript("OnLeave", nil);
                end
            end

            label.id = fullName; -- used for messaging
            fullName = tk.strsplit("-", fullName);
            label:SetNormalTexture(1);
            label:GetNormalTexture():SetColorTexture(0, 0, 0, 0.2);
            label:SetHighlightTexture(1);
            label:GetHighlightTexture():SetColorTexture(0.2, 0.2, 0.2, 0.4);
            label.data = {GetGuildRosterInfo(i)};
            label.name:SetText(tk.string.format("%s%s %s",
                tk:GetClassColoredString(classFileName, fullName), status, level));
        end
    end

    items.guild.update_required = nil; -- Change this!

    return DataText:PositionLabels(data.content, numLabelsShown);
end

function Guild:HasMenu()
    return true;
end

Engine:DefineReturns("Button");
function Guild:GetButton(data)
    return data.btn;
end