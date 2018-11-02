-- Setup Namespaces ------------------

local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local LABEL_PATTERN = L["Guild"]..": |cffffffff%u|r";

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local DataText = MayronUI:ImportModule("DataText");
local Guild = Engine:CreateClass("Guild", nil, "MayronUI.Engine.IDataTextModule");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.guild", {
    enabled = true,
    showSelf = true,
    showTooltips = true,
    displayOrder = 3
});

-- Local Functions ----------------

local CreateLabel;
do
    local onLabelClickFunc;

    local function button_OnEnter(self)
        local fullName, rank, _, _, _, zone, note, _, _, status, classFileName, achievementPoints = tk.unpack(self.guildRosterInfo);
        fullName = tk.strsplit("-", fullName);   

        GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
        GameTooltip:AddLine(tk.Strings:GetClassColoredText(classFileName, fullName));
        GameTooltip:AddDoubleLine(L["Zone"]..":", zone, nil, nil, nil, 1, 1, 1);
        GameTooltip:AddDoubleLine(L["Rank"]..":", rank, nil, nil, nil, 1, 1, 1);

        if (#note > 0) then
            GameTooltip:AddDoubleLine(L["Notes"]..":", note, nil, nil, nil, 1, 1, 1);
        end

        GameTooltip:AddDoubleLine(L["Achievement Points"]..":", achievementPoints, nil, nil, nil, 1, 1, 1);
        GameTooltip:Show();
    end

    local function button_OnLeave(self)
        GameTooltip:Hide();
    end

    function CreateLabel(contentFrame, popupWidth, slideController, showTooltips)
        local label = tk:PopFrame("Button", contentFrame);

        label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        label.name:SetPoint("LEFT", 6, 0);
        label.name:SetWidth(popupWidth - 10);
        label.name:SetWordWrap(false);
        label.name:SetJustifyH("LEFT");

        if (showTooltips) then
            label:SetScript("OnEnter", button_OnEnter);
            label:SetScript("OnLeave", button_OnLeave);
        end

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

-- Guild Module --------------

DataText:Hook("OnInitialize", function(self, dataTextData)
    local sv = db.profile.datatext.guild;
    sv:SetParent(dataTextData.sv);

    if (sv.enabled) then
        local guild = Guild(sv, dataTextData.slideController);
        self:RegisterDataModule(guild);
    end
end);

function Guild:__Construct(data, sv, slideController)
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

    data.handler = em:CreateEventHandler("GUILD_ROSTER_UPDATE", function()
        if (not self.Button) then return; end
        self:Update();
    end);
end

function Guild:IsEnabled(data) 
    return data.sv.enabled;
end

function Guild:Enable(data) 
    data.sv.enabled = true;
end

function Guild:Disable(self)
    if (data.handler) then
        data.handler:Destroy();
    end

    self.Button:RegisterForClicks("LeftButtonUp");
end

function Guild:Update(data)
    if (not IsInGuild()) then
        self.Button:SetText(L["No Guild"]);
    else
        GuildRoster(); -- Must get data from server first!

        local _, _, numOnlineAndMobile = GetNumGuildMembers();
        numOnlineAndMobile = (not data.sv.showSelf and numOnlineAndMobile - 1) or numOnlineAndMobile;

        -- data.showMenu = (numOnlineAndMobile ~= 0);
        self.Button:SetText(tk.string.format(LABEL_PATTERN, numOnlineAndMobile));
    end
end

function Guild:Click(data, button)
    if (button == "RightButton") then
        if (IsTrialAccount()) then
            tk:Print(L["Starter Edition accounts cannot perform this action."]);
        elseif (IsInGuild()) then
            ToggleGuildFrame();
        end

        return;
    end

    if (not IsInGuild()) then 
        return; 
    end

    local totalLabelsShown = 0;
    local playerName = tk:GetPlayerKey();

    for i = 1, (GetNumGuildMembers()) do
        local fullName, _, _, level, class, _, _, _, online, status, classFileName = GetGuildRosterInfo(i);
        
        if (online and (data.sv.showSelf or fullName ~= playerName)) then
            totalLabelsShown = totalLabelsShown + 1;

            local status = (status == 1 and " |cffffe066[AFK]|r") or (status == 2 and " |cffff3333[DND]|r") or "";
            local label = self.MenuLabels[totalLabelsShown] or 
                CreateLabel(self.MenuContent, data.sv.popup.width, data.slideController, data.sv.showTooltips);

            self.MenuLabels[totalLabelsShown] = label;

            label.id = fullName; -- used for messaging
            fullName = tk.strsplit("-", fullName);
            
            label:SetNormalTexture(1);
            label:GetNormalTexture():SetColorTexture(0, 0, 0, 0.2);
            label:SetHighlightTexture(1);
            label:GetHighlightTexture():SetColorTexture(0.2, 0.2, 0.2, 0.4);

            -- required for button_OnEnter
            if (tk.type(label.guildRosterInfo) == "table") then
                label.guildRosterInfo = nil;
            end

            label.guildRosterInfo = { GetGuildRosterInfo(i) };

            label.name:SetText(tk.string.format("%s%s %s",
                tk.Strings:GetClassColoredText(classFileName, fullName), status, level));
        end
    end

    self.TotalLabelsShown = totalLabelsShown;
end

function Guild:GetDisplayOrder(data)
    return data.displayOrder;
end

function Guild:SetDisplayOrder(data, displayOrder)
    if (data.displayOrder ~= displayOrder) then
        data.displayOrder = displayOrder;
        data.sv.displayOrder = displayOrder;
    end
end 