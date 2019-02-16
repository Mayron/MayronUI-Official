-- luacheck: ignore MayronUI self 143 631
local tk, db, em, _, obj, L = MayronUI:GetCoreComponents();

local LABEL_PATTERN = L["Guild"]..": |cffffffff%u|r";

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local Guild = Engine:CreateClass("Guild", nil, "MayronUI.Engine.IDataTextModule");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.guild", {
    showSelf = true,
    showTooltips = true
});

-- Local Functions ----------------

local CreateLabel;
do
    local onLabelClickFunc;

    local function button_OnEnter(self)
        local fullName, rank, _, _, _, zone, note, _, _, _, classFileName, achievementPoints = tk.unpack(self.guildRosterInfo);
        fullName = tk.strsplit("-", fullName);

        _G.GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
        _G.GameTooltip:AddLine(tk.Strings:SetTextColorByClass(classFileName, fullName));
        _G.GameTooltip:AddDoubleLine(L["Zone"]..":", zone, nil, nil, nil, 1, 1, 1);
        _G.GameTooltip:AddDoubleLine(L["Rank"]..":", rank, nil, nil, nil, 1, 1, 1);

        if (#note > 0) then
            _G.GameTooltip:AddDoubleLine(L["Notes"]..":", note, nil, nil, nil, 1, 1, 1);
        end

        _G.GameTooltip:AddDoubleLine(L["Achievement Points"]..":", achievementPoints, nil, nil, nil, 1, 1, 1);
        _G.GameTooltip:Show();
    end

    local function button_OnLeave(self)
        _G.GameTooltip:Hide();
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
                _G.ChatFrame1EditBox:SetAttribute("tellTarget", self.id);
                _G.ChatMenu_SetChatType(_G.ChatFrame1, "SMART_WHISPER");
                slideController:Start(slideController.Static.FORCE_RETRACT);
            end
        end

        label:SetScript("OnClick", onLabelClickFunc);
        return label;
    end
end

-- Guild Module --------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
    self:RegisterDataModule("guild", Guild);
end);

function Guild:__Construct(data, settings, dataTextModule, slideController)
    data.settings = settings;
    data.slideController = slideController;

    -- set public instance properties
    self.MenuContent = _G.CreateFrame("Frame");
    self.MenuLabels = obj:PopTable();
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = true;
    self.HasRightMenu = false;
    self.SavedVariableName = "guild";

    self.Button = dataTextModule:CreateDataTextButton();
end

function Guild:IsEnabled(data)
    return data.enabled;
end

function Guild:SetEnabled(data, enabled)
    data.enabled = enabled;

    if (enabled) then
        data.handler = em:CreateEventHandler("GUILD_ROSTER_UPDATE", function()
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

function Guild:Update(data)
    if (not _G.IsInGuild()) then
        self.Button:SetText(L["No Guild"]);
    else
        _G.GuildRoster(); -- Must get data from server first!

        local _, _, numOnlineAndMobile = _G.GetNumGuildMembers();
        numOnlineAndMobile = (not data.settings.showSelf and numOnlineAndMobile - 1) or numOnlineAndMobile;

        -- data.showMenu = (numOnlineAndMobile ~= 0);
        self.Button:SetText(tk.string.format(LABEL_PATTERN, numOnlineAndMobile));
    end
end

function Guild:Click(data, button)
    if (button == "RightButton") then
        if (_G.IsTrialAccount()) then
            tk:Print(L["Starter Edition accounts cannot perform this action."]);
        elseif (_G.IsInGuild()) then
            _G.ToggleGuildFrame();
        end

        return;
    end

    if (not _G.IsInGuild()) then
        return true;
    end

    local totalLabelsShown = 0;
    local playerName = tk:GetPlayerKey();

    for i = 1, (_G.GetNumGuildMembers()) do
        local fullName, _, _, level, _, _, _, _, online, status, classFileName = _G.GetGuildRosterInfo(i);

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
            fullName = _G.strsplit("-", fullName);

            label:SetNormalTexture(1);
            label:GetNormalTexture():SetColorTexture(0, 0, 0, 0.2);
            label:SetHighlightTexture(1);
            label:GetHighlightTexture():SetColorTexture(0.2, 0.2, 0.2, 0.4);

            -- required for button_OnEnter
            if (tk.type(label.guildRosterInfo) == "table") then
                label.guildRosterInfo = nil;
            end

            label.guildRosterInfo = { _G.GetGuildRosterInfo(i) };

            label.name:SetText(tk.string.format("%s%s %s",
                tk.Strings:SetTextColorByClass(classFileName, fullName), status, level));
        end
    end

    self.TotalLabelsShown = totalLabelsShown;
end