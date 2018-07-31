------------------------
-- Setup namespaces
------------------------
local _, core = ...;
local em = core.EventManager;
local tk = core.Toolkit;
local db = core.Database;
local gui = core.GUI_Builder;
local L = core.L;

local dt = {};
MayronUI:RegisterModule("DataText", dt, true);

------------------------
------------------------
db:AddToDefaults("profile.datatext", {
    enable_module = true,
    frame_strata = "MEDIUM",
    frame_level = 20,
    height = 24, -- height of data bar (width is the size of bottomUI container!)
    enabled = {
        "durability",
        "friends",
        "guild",
        "performance",
        "memory", -- change to money
        "bags",
        "spec",
    },
    spacing = 1,
    max_menu_height = 250,
    menu_width = 200,
    font_size = 11,
    combat_block = true,
    hideMenuInCombat = true,
    menu_item_height = 26,
    guild = {
        show_self = true,
        show_tooltips = true,
    },
    money = {
        show_copper = true,
        show_silver = true,
        show_gold = true,
        show_realm = false,
    },
    spec = {
        sets = {},
    },
    performance = {
        show_fps = true,
        show_home_latency = true,
        show_server_latency = false,
    },
    bags = {
        show_total_slots = false,
        slots_to_show = "free",
    },
});

-----------------------
-- DataText Functions:
-----------------------
local items = {};
items.blank = {};

function items.blank:enable()
    self.btn:SetText("");
    self.showMenu = nil;
end

function dt:ChangeMenuScrollChild(scrollChild)
    local oldScrollChild = self.menu:GetScrollChild();
    if (oldScrollChild) then oldScrollChild:Hide(); end
    
    if (not scrollChild) then
        scrollChild = tk:PopFrame("Frame", self.menu);
        scrollChild:SetSize(self.menu:GetWidth(), 10);
    end

    -- attach scroll child to menu frame container
    self.menu:SetScrollChild(scrollChild);
    scrollChild:Show();

    return scrollChild;
end

function dt:GetButton(id)
    return items[id].btn;
end

function dt:ClearLabels(labels)
    if (not labels) then return; end

    for id, label in ipairs(labels) do
        if (label.name) then label.name:SetText(""); end
        if (label.value) then label.value:SetText(""); end

        if (label.dropdown) then
            label.dropdown:Hide();
        end
    end
end

-- returned the total height of all labels
-- total height is used to controll the dynamic scrollbar
function dt:PositionLabels(content, numLabelsShown, labels)
    if (numLabelsShown == 0) then return 0; end

    labels = labels or content.labels;
    local totalHeight = 0;

    for i = 1, #labels do
        local label = labels[i];

        if (label) then
            if (i == 1) then
                label:SetPoint("TOPLEFT", 2, 0);
                label:SetPoint("BOTTOMRIGHT", content, "TOPRIGHT", -2, -self.sv.menu_item_height);
            else
                label:SetPoint("TOPLEFT", labels[i - 1], "BOTTOMLEFT", 0, -2);
                label:SetPoint("BOTTOMRIGHT", labels[i - 1], "BOTTOMRIGHT", 0, -(self.sv.menu_item_height + 2));
            end

            if (numLabelsShown and (i > numLabelsShown)) then
                label:Hide();
            else
                label:Show();
                totalHeight = totalHeight + self.sv.menu_item_height;
                if (i > 1) then
                    totalHeight = totalHeight + 2;
                end
            end
        end
    end

    content:SetHeight(totalHeight);
    return totalHeight;
end

-----------------------------
-- durability:
-----------------------------
items.durability = {};

function items.durability:enable()
    self.showMenu = true;
    self.handler = em:CreateEventHandler("UPDATE_INVENTORY_DURABILITY", function()
        if (not self.btn) then return; end
        self:update();
    end);
    tk:KillElement(DurabilityFrame);
end

function items.durability:disable()
    if (self.handler) then
        self.handler:Destroy();
    end
    self.showMenu = nil;
end

do
    local function OnLabelClick(self)
        ChatFrame_SendSmartTell(self.id);
        dt.slideController:Start();
    end

    local function CreateLabel(c)
        local label = tk:PopFrame("Frame", c);

        label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        label.value = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        label.name:SetPoint("LEFT", 6, 0);
        label.name:SetWidth(dt.sv.menu_width * 0.7);
        label.name:SetWordWrap(false);
        label.name:SetJustifyH("LEFT");
        label.value:SetPoint("RIGHT", -10, 0);
        label.value:SetWidth(dt.sv.menu_width * 0.3);
        label.value:SetWordWrap(false);
        label.value:SetJustifyH("RIGHT");
        tk:SetBackground(label, 0, 0, 0, 0.2);

        return label;
    end

    local DURABILITY_SLOTS = {
        "HeadSlot", "ShoulderSlot", "ChestSlot", "WaistSlot", "LegsSlot", "FeetSlot",
        "WristSlot", "HandsSlot", "MainHandSlot", "SecondaryHandSlot"
    };

    function items.durability:update()
        local durability_total, max_total = 0, 0;
        local itemsEquipped;

        for i, slotName in tk.ipairs(DURABILITY_SLOTS) do
            local id = GetInventorySlotInfo(slotName);
            local durability, max = GetInventoryItemDurability(id);

            if (durability) then
                durability_total = durability_total + durability;
                max_total = max_total + max;
                itemsEquipped = true;
            end
        end

        local value = (durability_total / max_total) * 100;

        if (itemsEquipped) then
            local format_value = tk:FormatFloat(1, value);
            local colored;

            if (value < 25) then
                colored = tk.string.format("%s%s%%|r", RED_FONT_COLOR_CODE, format_value);

            elseif (value < 40) then
                colored = tk.string.format("%s%s%%|r", ORANGE_FONT_COLOR_CODE, format_value);

            elseif (value < 70) then
                colored = tk.string.format("%s%s%%|r", YELLOW_FONT_COLOR_CODE, format_value);

            else
                colored = tk.string.format("%s%s%%|r", HIGHLIGHT_FONT_COLOR_CODE, format_value);

            end
            self.btn:SetText(tk.string.format("Armor: %s", colored));
        else
            self.btn:SetText("Armor: |cffffffffnone|r");
        end
    end

    function items.durability:click()
        self.content.labels = self.content.labels or {};
        local numLabelsShown = 0;
        local index = 0;

        for _, slotName in tk.ipairs(DURABILITY_SLOTS) do
            local id = GetInventorySlotInfo(slotName);
            local durability, max = GetInventoryItemDurability(id);

            if (durability) then
                index = index + 1;
                numLabelsShown = numLabelsShown + 1;

                local value = (durability / max) * 100;
                local alert = GetInventoryAlertStatus(id);
                local label = self.content.labels[numLabelsShown] or CreateLabel(self.content);

                self.content.labels[numLabelsShown] = label;
                slotName = slotName:gsub("Slot", "");
                slotName = tk:SplitCamelString(slotName);
                
                label.name:SetText(L[slotName]);

                if (alert == 0) then
                    label.value:SetTextColor(1, 1, 1);
                else
                    local c = INVENTORY_ALERT_COLORS[alert];
                    label.value:SetTextColor(c.r, c.g, c.b);
                end

                label.value:SetText(tk.string.format("%u%%", value));
            end
        end

        return dt:PositionLabels(self.content, numLabelsShown);
    end
end

-----------------------------
-- friends:
-----------------------------
items.friends = {};
items.friends.label = "Friends: |cffffffff%u|r";

function items.friends:enable()
    self.handler = em:CreateEventHandler("FRIENDLIST_UPDATE", function()
        if (not self.btn) then return; end
        self:update();
    end);

    self.btn:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    self.showMenu = nil;
end

function items.friends:disable()
    if (self.handler) then
        self.handler:Destroy();
    end
    self.btn:RegisterForClicks("LeftButtonUp");
end

function items.friends:update()
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

    self.showMenu = (total_online ~= 0);
    self.btn:SetText(tk.string.format(self.label, total_online));
end

do
    local function OnLabelClick(self)
        ChatFrame_SendSmartTell(self.id);
        dt.slideController:Start();
    end

    local function CreateLabel(c)
        local label = tk:PopFrame("Button", c);
        label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        label.name:SetPoint("LEFT", 6, 0);
        label.name:SetWidth(dt.sv.menu_width - 10);
        label.name:SetWordWrap(false);
        label.name:SetJustifyH("LEFT");
        label:SetScript("OnClick", OnLabelClick);

        return label;
    end

    local convert = {WTCG = "HS", Pro = "OW"};

    function items.friends:click(button)
        if (button == "RightButton") then
            dt.slideController:Start();
            ToggleFriendsFrame();
            return;
        end

        if (tk.select(2, GetNumFriends()) == 0 and tk.select(2, BNGetNumFriends()) == 0) then return; end
        self.content.labels = self.content.labels or {};
        local r, g, b = tk:GetThemeColor();
        local numLabelsShown = 0;

        for i = 1, BNGetNumFriends() do
            local _, realName, _, _, toonName, _, client, online, _, isAFK, isDND = BNGetFriendInfo(i);
            if (online) then
                numLabelsShown = numLabelsShown + 1;
                local status = (isAFK and "|cffffe066[AFK] |r") or (isDND and "|cffff3333[DND] |r") or "";

                local label = self.content.labels[numLabelsShown] or CreateLabel(self.content);
                self.content.labels[numLabelsShown]= label;
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
                status = (status == " <Away>" and " |cffffe066[AFK]|r") or (status == " <DND>" and " |cffff3333[DND]|r") or "";
                numLabelsShown = numLabelsShown + 1;
                local label = self.content.labels[numLabelsShown] or CreateLabel(self.content);
                self.content.labels[numLabelsShown] = label; -- old: numBNFriends + i
                label.id = name;
                label:SetNormalTexture(1);
                label:GetNormalTexture():SetColorTexture(0, 0, 0, 0.2);
                label:SetHighlightTexture(1);
                label:GetHighlightTexture():SetColorTexture(0.2, 0.2, 0.2, 0.4);
                label.name:SetText(tk.string.format("%s%s %s ", tk:GetClassColoredString(classFileName, name), status, level));
            end
        end
        return dt:PositionLabels(self.content, numLabelsShown);
    end
end
-----------------------------
-- combat_timer:
-----------------------------
items.combat_timer = {};

function items.combat_timer:enable()
    em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
        self.startTime = GetTime();
        self.inCombat = true;
        self.executed = nil;
        self:update();
    end):SetKey("combat_timer");

    em:CreateEventHandler("PLAYER_REGEN_ENABLED", function()
        self.inCombat = nil;
        self.btn.minutes:SetText(self.minutes or "00");
        self.btn.seconds:SetText(self.seconds or ":00:");
        self.btn.milliseconds:SetText(self.milliseconds or "00");
    end):SetKey("combat_timer");

    self.showMenu = nil;    
    local font = tk.Constants.LSM:Fetch("font", db.global.core.font);

    self.btn.seconds = self.btn:CreateFontString(nil, "ARTWORK", "MUI_FontNormal");
    self.btn.seconds:SetFont(font, dt.sv.font_size);
    self.btn.minutes = self.btn:CreateFontString(nil, "ARTWORK", "MUI_FontNormal");
    self.btn.minutes:SetFont(font, dt.sv.font_size);
    self.btn.minutes:SetJustifyH("RIGHT");
    self.btn.milliseconds = self.btn:CreateFontString(nil, "ARTWORK", "MUI_FontNormal");
    self.btn.milliseconds:SetFont(font, dt.sv.font_size);
    self.btn.milliseconds:SetJustifyH("LEFT");
    self.btn.minutes:SetText("00");
    self.btn.seconds:SetText(":00:");
    self.btn.milliseconds:SetText("00");
    self.btn:SetText("");
    self.btn.seconds:SetPoint("CENTER");
    self.btn.minutes:SetPoint("RIGHT", self.btn.seconds, "LEFT");
    self.btn.milliseconds:SetPoint("LEFT", self.btn.seconds, "RIGHT");
end

function items.combat_timer:disable()
    em:FindHandlerByKey("PLAYER_REGEN_DISABLED", "combat_timer"):Destroy();
    em:FindHandlerByKey("PLAYER_REGEN_ENABLED", "combat_timer"):Destroy();
    self.btn.minutes:SetText("");
    self.btn.seconds:SetText("");
    self.btn.milliseconds:SetText("");
end

function items.combat_timer:update(override)
    if (not override and self.executed) then return; end
    self.executed = true;

    local function loop()
        if (not self.inCombat) then return; end
        local s = (GetTime() - self.startTime);
        self.minutes = tk.string.format("%02d", (s/60)%60);
        self.seconds = tk.string.format(":%02d:", s%60);
        self.milliseconds = tk.string.format("%02d", (s*100)%100);

        self.btn.minutes:SetText(RED_FONT_COLOR_CODE..self.minutes.."|r");
        self.btn.seconds:SetText(RED_FONT_COLOR_CODE..self.seconds.."|r");
        self.btn.milliseconds:SetText(RED_FONT_COLOR_CODE..self.milliseconds.."|r");

        if (not override) then
            tk.C_Timer.After(0.05, loop);
        end
    end

    loop();
end

-----------------------------
-- guild:
-----------------------------
items.guild = {};
items.guild.label = "Guild: |cffffffff%u|r";

function items.guild.OnEnter(self)    
    local fullName, rank, _, _, _, zone, note, _, _, status, classFileName, achievementPoints = tk.unpack(self.data);
    fullName = tk.strsplit("-", fullName);

    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
    GameTooltip:AddLine(tk:GetClassColoredString(classFileName, fullName));
    GameTooltip:AddDoubleLine("Zone:", zone, nil, nil, nil, 1, 1, 1);
    GameTooltip:AddDoubleLine("Rank:", rank, nil, nil, nil, 1, 1, 1);

    if (#note > 0) then
        GameTooltip:AddDoubleLine("Notes:", note, nil, nil, nil, 1, 1, 1);
    end

    GameTooltip:AddDoubleLine("Achievement Points:", achievementPoints, nil, nil, nil, 1, 1, 1);
    GameTooltip:Show();
end

function items.guild.OnLeave(self)
    GameTooltip:Hide();
end

function items.guild:enable()
    self.handler = em:CreateEventHandler("GUILD_ROSTER_UPDATE", function()
        if (not self.btn) then return; end
        self:update();
    end);

    self.btn:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    self.showMenu = nil;
end

function items.guild:disable()
    if (self.handler) then
        self.handler:Destroy();
    end

    self.btn:RegisterForClicks("LeftButtonUp");
end

function items.guild:update()
    if (not IsInGuild()) then
        self.btn:SetText("No Guild");
    else        
        GuildRoster();
        local _, _, numOnlineAndMobile = GetNumGuildMembers();
        numOnlineAndMobile = (not dt.sv.guild.show_self and numOnlineAndMobile - 1) or numOnlineAndMobile;
        self.showMenu = (numOnlineAndMobile ~= 0);
        self.btn:SetText(tk.string.format(self.label, numOnlineAndMobile));
    end
end

do
    local function OnLabelClick(self)
        ChatFrame_SendSmartTell(self.id);
        dt.slideController:Start();
    end

    local function CreateLabel(c)
        local label = tk:PopFrame("Button", c);
        label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        label.name:SetPoint("LEFT", 6, 0);
        label.name:SetWidth(dt.sv.menu_width - 10);
        label.name:SetWordWrap(false);
        label.name:SetJustifyH("LEFT");
        if (dt.sv.guild.show_tooltips) then
            label:SetScript("OnEnter", items.guild.OnEnter);
            label:SetScript("OnLeave", items.guild.OnLeave);
        end
        label:SetScript("OnClick", OnLabelClick);
        return label;
    end

    function items.guild:click(button)
        self:update();
        if (button == "RightButton") then
            if (IsTrialAccount()) then
                tk:Print("Starter Edition accounts cannot perform this action.");
            elseif (IsInGuild()) then
                ToggleGuildFrame();
            end
            dt.slideController:Start();
            return;
        end

        if (not IsInGuild()) then return; end

        self.content.labels = self.content.labels or {};

        local numLabelsShown = 0;
        local playerName = tk:GetPlayerKey();

        for i = 1, (GetNumGuildMembers()) do
            local fullName, _, _, level, class, _, _, _, online, status, classFileName = GetGuildRosterInfo(i);

            if (online and not (not dt.sv.guild.show_self and fullName == playerName)) then
                numLabelsShown = numLabelsShown + 1;

                local status = (status == 1 and " |cffffe066[AFK]|r") or (status == 2 and " |cffff3333[DND]|r") or "";
                local label = self.content.labels[numLabelsShown] or CreateLabel(self.content);

                self.content.labels[numLabelsShown] = label;

                if (items.guild.update_required) then
                    if (dt.sv.guild.show_tooltips) then
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

        items.guild.update_required = nil;

        return dt:PositionLabels(self.content, numLabelsShown);
    end
end

-----------------------------
-- spec:
-----------------------------
items.spec = {};

do
    local function OnEnter(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
        GameTooltip:SetText("Commands:")
        GameTooltip:AddDoubleLine(tk:GetThemeColoredString(L["Left Click:"]), L["Choose Spec"], r, g, b, 1, 1, 1);
        GameTooltip:AddDoubleLine(tk:GetThemeColoredString(L["Right Click:"]), L["Choose Loot Spec"], r, g, b, 1, 1, 1);
        GameTooltip:Show();
    end

    local function OnLeave()
        GameTooltip:Hide();
    end

    function items.spec:enable()
        self.showMenu = true;
        self.btn:RegisterForClicks("LeftButtonUp", "RightButtonUp");

        local r, g, b = tk:GetThemeColor();
        self.btn:SetScript("OnEnter", OnEnter);
        self.btn:SetScript("OnLeave", OnLeave);

        em:CreateEventHandler("PLAYER_ENTERING_WORLD", function()
            self:update();
        end):SetKey("spec_1");

        em:CreateEventHandler("PLAYER_SPECIALIZATION_CHANGED", function(_, _, unitID)
            if (unitID == "player") then
                self:update();  

                if (not dt.sv.spec.sets) then return; end
                local _, name = GetSpecializationInfo(GetSpecialization());

                if (dt.sv.spec.sets[name]) then
                    local setName = dt.sv.spec.sets[name];

                    if (setName ~= nil) then                    
                        C_EquipmentSet.UseEquipmentSet(setName);
                    end
                end
            end
        end):SetKey("spec_2");
    end
end

function items.spec:disable()
    em:FindHandlerByKey("spec_1"):Destroy();
    em:FindHandlerByKey("spec_2"):Destroy();

    self.btn:SetScript("OnEnter", nil);
    self.btn:SetScript("OnLeave", nil);
    self.showMenu = nil;
end

function items.spec:update()
    if (not self.btn) then return; end

    if (UnitLevel("player") < 10) then
        self.btn:SetText("No Spec");
        self.showMenu = nil;
        return;
    end

    self.showMenu = true;
    local specID = GetSpecialization();

    if (not specID) then        
        self.btn:SetText("No Spec");
    else
        local _, name = GetSpecializationInfo(specID, nil, nil, "player");
        self.btn:SetText(name);
    end
end

do
    local function OnLabelClick(self)
        if (self.specID) then
            if (GetSpecialization() ~= self.specID) then
                SetSpecialization(self.specID);
                dt.slideController:Start();
            end

        elseif (self.lootSpecID) then
            if (GetLootSpecialization() ~= self.lootSpecID) then
                SetLootSpecialization(self.lootSpecID);
                dt.slideController:Start();
                if (self.lootSpecID == 0) then
                    local _, name = GetSpecializationInfo(GetSpecialization());
                    tk.print(YELLOW_FONT_COLOR_CODE.."Loot Specialization set to: Current Specialization ("..name..")|r");
                end
            end

        end
    end

    local function SetEquipmentSet(self, setName, specName)
        if (setName == "<none>") then setName = nil; end
        db.profile.datatext.spec.sets[specName] = setName;
    end

    local function CreateLabel(c)
        local label = tk:PopFrame("Button", c);

        label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        label.name:SetPoint("LEFT", 6, 0);
        label.name:SetWidth(dt.sv.menu_width - 10);
        label.name:SetWordWrap(false);
        label.name:SetJustifyH("LEFT");
        label:SetScript("OnClick", OnLabelClick);

        return label;
    end

    function items.spec:click(button)
        if (not self.showMenu) then
            if (UnitLevel("player") < 10) then
                tk:Print("Must be level 10 or higher to use Talents.");
            end
            return;
        end

        local numLabelsShown = 1;
        self.content.labels = self.content.labels or {};
        local r, g, b = tk:GetThemeColor();

        if (button == "LeftButton") then
            local title = self.content.labels[numLabelsShown] or CreateLabel(self.content);

            self.content.labels[numLabelsShown] = title;
            title.name:SetText(tk:GetRGBColoredString("Choose Spec:", r, g, b));
            title:SetNormalTexture(1);
            title:GetNormalTexture():SetColorTexture(0, 0, 0, 0.4);

            local dropdownID = 0;

            for i = 1, GetNumSpecializations() do
                numLabelsShown = numLabelsShown + 1;
                local _, specName = GetSpecializationInfo(i);
                local extra = "";
                local label = self.content.labels[numLabelsShown] or CreateLabel(self.content);
                self.content.labels[numLabelsShown] = label;
                label.specID = i;
                label.lootSpecID = nil;
                if (GetSpecialization() == i) then
                    label:SetNormalTexture(1);
                    label:GetNormalTexture():SetColorTexture(0, 0, 0, 0.2);
                    label:SetHighlightTexture(nil);
                    extra = L[" (current)"];
                else
                    label:SetNormalTexture(1);
                    label:GetNormalTexture():SetColorTexture(r * 0.4, g * 0.4, b * 0.4, 0.2);
                    label:SetHighlightTexture(1);
                    label:GetHighlightTexture():SetColorTexture(r * 0.4, g * 0.4, b * 0.4, 0.4);
                end

                label.name:SetText(specName..extra);
                self.dropdowns = self.dropdowns or {};

                -- create dropdown:
				--[[ 
				-- Temporary deactivated because selecting an option throws an error:
				-- MUI_Core\APIs/gui_builder.lua:1054: attempt to call upvalue 'func' (a nil value)
				-- MUI_Core\APIs/gui_builder.lua:1054: in function <MUI_Core\APIs/gui_builder.lua:1051>
				
                local dropdown = self.dropdowns[i] or gui:CreateDropDown(self.content, "UP", dt.bar);
                self.dropdowns[i] = dropdown;
                label.dropdown = dropdown;

                dropdown:Show();

                if (dt.sv.spec.sets and dt.sv.spec.sets[specName]) then
                    dropdown:SetLabel(dt.sv.spec.sets[specName]);
                else
                    dropdown:SetLabel("Equipment Set");
                end

                -- TODO: Might have added a new equipment set. Should recheck
                -- TODO: using GetOption(label) and seeing if it exists, else add it!
                if (not dropdown.registered) then
					for i = 0, C_EquipmentSet.GetNumEquipmentSets() do
                        local label = C_EquipmentSet.GetEquipmentSetInfo(i);
						if (label == nil) then break end -- failsave
						dropdown:AddOption(label, C_EquipmentSet.SetEquipmentSet, nil, specName);
                    end
					dropdown:AddOption("<none>", C_EquipmentSet.SetEquipmentSet, nil, specName);
                    dropdown.registered = true;
                end
				]]--
            end

            -- position manually:
            local totalHeight = 0;
            for i = 1, #self.content.labels do
                local f = self.content.labels[i];

                if (i == 1) then
                    f:SetPoint("TOPLEFT", 2, 0);
                    f:SetPoint("BOTTOMRIGHT", self.content, "TOPRIGHT", -2, -dt.sv.menu_item_height);
                else
                    local anchor = self.content.labels[i - 1];
                    local xOffset = 0;
                    local dropdownPadding = 0;

                    if (anchor.dropdown) then
                        anchor = anchor.dropdown:GetFrame();
                        xOffset = 8;
                        dropdownPadding = 10;
                    end

                    f:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -(dropdownPadding));
                    f:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", xOffset, -(dt.sv.menu_item_height + dropdownPadding));
                    totalHeight = totalHeight + dropdownPadding;
                end

                if (f.dropdown) then
                    local dropdownPadding = 10;
                    f.dropdown:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -dropdownPadding);
                    f.dropdown:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, -(dt.sv.menu_item_height + dropdownPadding));
                    totalHeight = totalHeight + dt.sv.menu_item_height + dropdownPadding;
                end

                if (i > numLabelsShown) then
                    f:Hide();
                else
                    f:Show();
                    totalHeight = totalHeight + dt.sv.menu_item_height;
                    if (i > 1) then totalHeight = totalHeight + 2; end
                end
                
            end
            self.content:SetHeight(totalHeight); -- manual positioning = manual setting of height
            return totalHeight;

        elseif (button == "RightButton") then
            local title = self.content.labels[numLabelsShown] or CreateLabel(self.content);

            self.content.labels[numLabelsShown] = title;
            title.name:SetText(tk:GetRGBColoredString("Choose Loot Spec:", r, g, b));
            title:SetNormalTexture(1);
            title:GetNormalTexture():SetColorTexture(0, 0, 0, 0.4);

            for i = 0, GetNumSpecializations() do
                numLabelsShown = numLabelsShown + 1;

                local label = self.content.labels[numLabelsShown] or CreateLabel(self.content);
                self.content.labels[numLabelsShown] = label;

                local name;

                if (i == 0) then
                    name = tk.select(2, GetSpecializationInfo(GetSpecialization()));
                    label.lootSpecID = 0;
                    name = tk.string.format("Current Spec (%s)", name);
                else
                    label.lootSpecID, name = GetSpecializationInfo(i);
                end

                label.specID = nil;
                label.name:SetText(name);

                if (GetLootSpecialization() == label.lootSpecID) then
                    label:SetNormalTexture(1);
                    label:GetNormalTexture():SetColorTexture(0, 0, 0, 0.2);
                    label:SetHighlightTexture(nil);
                else
                    label:SetNormalTexture(1);
                    label:GetNormalTexture():SetColorTexture(r * 0.4, g * 0.4, b * 0.4, 0.2);
                    label:SetHighlightTexture(1);
                    label:GetHighlightTexture():SetColorTexture(r * 0.4, g * 0.4, b * 0.4, 0.4);
                end                
            end

            return dt:PositionLabels(self.content, numLabelsShown);
        end
    end
end
-----------------------------
-- money:
-----------------------------
items.money = {};
items.money.label = "|cffffffff%s|r";

function items.money:GetCurrency(value, color, btn_label)
    local text = "";  
    local gold = tk.math.floor(tk.math.abs(value / 10000));
    local silver = tk.math.floor(tk.math.abs((value / 100) % 100));
    local copper = tk.math.floor(tk.math.abs(value % 100));

    color = color or "|cffffffff";

    if (gold > 0 and (not btn_label or dt.sv.money.show_gold)) then
        if (tk.tonumber(gold) > 1000) then
            gold = tk.string.gsub(gold, "^(-?%d+)(%d%d%d)", '%1,%2')
        end

        text = tk.string.format("%s %s%s|r%s", text, color, gold, self.gold_string);
    end

    if (silver > 0 and (not btn_label or dt.sv.money.show_silver)) then
        text = tk.string.format("%s %s%s|r%s", text, color, silver, self.silver_string);
    end

    if (copper > 0 and (not btn_label or dt.sv.money.show_copper)) then
        text = tk.string.format("%s %s%s|r%s", text, color, copper, self.copper_string);
    end

    if (text == "") then
        if (dt.sv.money.show_gold or not btn_label) then
            text = tk.string.format("%d%s", 0, self.gold_string);
        end

        if (dt.sv.money.show_silver or not btn_label) then
            text = tk.string.format("%s %d%s", text, 0, self.silver_string);
        end

        if (dt.sv.money.show_copper or not btn_label) then
            text = tk.string.format("%s %d%s", text, 0, self.copper_string);
        end
    end

    return tk.string.format(self.label, text:trim());
end

function items.money:GetDifference()
    local value = GetMoney() - dt.sv.money.today_currency;

    if (value >= 0) then
        return self:GetCurrency(value, GREEN_FONT_COLOR_CODE);

    elseif (value < 0) then
        local result = self:GetCurrency(tk.math.abs(value), RED_FONT_COLOR_CODE);
        return tk.string.format(RED_FONT_COLOR_CODE.."-%s".."|r", result);

    end
end

function items.money:enable()
    self.gold_string = "|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t";
    self.silver_string = "|TInterface\\MoneyFrame\\UI-SilverIcon:14:14:2:0|t";
    self.copper_string = "|TInterface\\MoneyFrame\\UI-CopperIcon:14:14:2:0|t";
    self.showMenu = true;

    local _, month, day = CalendarGetDate();
    local date = tk.string.format("%d-%d", day, month);
    if (dt.sv.money.date ~= date) then
        dt.sv.money.today_currency = GetMoney();
        dt.sv.money.date = date;
    end

    em:CreateEventHandler("PLAYER_MONEY", function()
        if (not self.btn) then return; end
        self:update();
    end):SetKey("money");

    self.info = {
        tk:GetThemeColoredString("Current Money:"),
        nil,
        tk:GetThemeColoredString("Start of the day:"),
        self:GetCurrency(dt.sv.money.today_currency),
        tk:GetThemeColoredString("Today's profit:"),
        nil,
        NORMAL_FONT_COLOR_CODE.."Money per character:".."|r"
    };
end

function items.money:disable()
    em:FindHandlerByKey("PLAYER_MONEY", "money"):Destroy();
    self.showMenu = nil;
end

function items.money:update()
    self.btn:SetText(self:GetCurrency(GetMoney(), nil, true));
    local colored_key = tk:GetClassColoredString(nil, tk:GetPlayerKey());
    db.global.datatext.money.characters[colored_key] = GetMoney();
end

do
    local function CreateLabel(c)
        local label = tk:PopFrame("Frame", c);
        label.value = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        label.value:SetPoint("LEFT", 6, 0);
        label.value:SetWidth(dt.sv.menu_width);
        label.value:SetWordWrap(false);
        label.value:SetJustifyH("LEFT");
        label.bg = tk:SetBackground(label, 0, 0, 0, 0.2);
        return label;
    end

    function items.money:click()
        self.content.labels = self.content.labels or {};
        self.info[2] = self:GetCurrency(GetMoney());
        self.info[6] = self:GetDifference();

        local r, g, b = tk:GetThemeColor();
        local id;

        for n, value in tk.ipairs(self.info) do
            self.content.labels[n] = self.content.labels[n] or CreateLabel(self.content);
            self.content.labels[n].value:SetText(value);
            if (n % 2 == 1) then
                self.content.labels[n].bg:SetColorTexture(r * 0.4, g * 0.4, b * 0.4, 0.2);
            end
            id = n + 1;
        end

        local invert = true;
        for character_name, value in db.global.datatext.money.characters:Iterate() do
            self.content.labels[id] = self.content.labels[id] or CreateLabel(self.content);
            local name_label = self.content.labels[id];

            if (dt.sv.money.show_realm) then
                name_label.value:SetText(character_name);
            else
                local name = tk.strsplit("-", character_name);
                name_label.value:SetText(name);
            end

            id = id + 1;

            self.content.labels[id] = self.content.labels[id] or CreateLabel(self.content);
            local money_label = self.content.labels[id];
            money_label.value:SetText(self:GetCurrency(value));

            id = id + 1;

            if (invert) then
                name_label.bg:SetColorTexture(0.2, 0.2, 0.2, 0.2);
                money_label.bg:SetColorTexture(0.2, 0.2, 0.2, 0.2);
            else
                name_label.bg:SetColorTexture(0, 0, 0, 0.2);
                money_label.bg:SetColorTexture(0, 0, 0, 0.2);
            end

            invert = not invert;
        end

        return dt:PositionLabels(self.content);
    end
end

-----------------------------
-- performance:
-----------------------------
items.performance = {};

function items.performance:update(override)
    if (not override and self.executed) then return; end
    self.executed = true;

    local function loop()
        if (self.disabled) then return; end -- probably won't work because of how closures work
        local _, _, latencyHome, latencyServer = GetNetStats();

        local label = "";
        if (dt.sv.performance.show_fps) then
            label = tk.string.format("|cffffffff%u|r fps", GetFramerate());
        end

        if (dt.sv.performance.show_home_latency) then
            label = tk.string.format("%s |cffffffff%u|r ms", label, latencyHome);
        end

        if (dt.sv.performance.show_server_latency) then
            label = tk.string.format("%s |cffffffff%u|r ms", label, latencyServer);
        end

        self.btn:SetText(label:trim());
        if (not override) then
            tk.C_Timer.After(3, loop);
        end
    end
    loop();
end

function items.performance:disable()
    self.disabled = true;
end

-----------------------------
-- memory:
-----------------------------
items.memory = {};
items.memory.label = "|cffffffff%s|r mb";

function items.memory:enable()
    self.showMenu = true;
end

function items.memory:disable()
    self.showMenu = nil;
    self.disabled = true;
end

function items.memory:update(override)
    if (not override and self.executed) then return; end
    self.executed = true;

    local function loop()
        if (self.disabled) then return; end
        UpdateAddOnMemoryUsage();

        local total = 0;

        for i = 1, GetNumAddOns() do
            total = total + GetAddOnMemoryUsage(i);
        end

        total = (total / 1000);
        total = tk:FormatFloat(1, total);

        self.btn:SetText(tk.string.format(items.memory.label, total));
        if (not override) then
            tk.C_Timer.After(10, loop);
        end
    end

    loop();
end

do
    local function CreateLabel(c)
        local label = tk:PopFrame("Frame", c);

        label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        label.value = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        label.name:SetPoint("LEFT", 6, 0);
        label.name:SetWidth(dt.sv.menu_width * 0.6);
        label.name:SetWordWrap(false);
        label.name:SetJustifyH("LEFT");
        label.value:SetPoint("RIGHT", -10, 0);
        label.value:SetWidth(dt.sv.menu_width * 0.4);
        label.value:SetWordWrap(false);
        label.value:SetJustifyH("RIGHT");
        tk:SetBackground(label, 0, 0, 0, 0.2);

        return label;
    end

    local function compare(a, b)
        return a.usage > b.usage;
    end

    function items.memory:click()
        tk.collectgarbage("collect");
        self.content.labels = self.content.labels or {};
        self.content.sorted = {};

        for i = 1, GetNumAddOns() do
            local _, name = GetAddOnInfo(i);
            local usage = GetAddOnMemoryUsage(i);
            local value;

            if (usage > 1000) then
                value = usage / 1000;
                value = tk:FormatFloat(1, value).." mb";
            else
                value = tk:FormatFloat(0, usage).." kb";
            end

            self.content.labels[i] = self.content.labels[i] or CreateLabel(self.content);

            local label = self.content.labels[i];
            label.name:SetText(name);
            label.value:SetText(value);
            label.usage = usage;

            if (usage > 1) then
                tk.table.insert(self.content.sorted, label);
            end
        end

        tk.table.sort(self.content.sorted, compare);
        return dt:PositionLabels(self.content, nil, self.content.sorted);
    end
end

-----------------------------
-- bags:
-----------------------------
items.bags = {};

do
    local function OnEnter(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
        GameTooltip:SetText("Commands:")
        GameTooltip:AddDoubleLine(tk:GetThemeColoredString("Left Click:"), "Toggle Bags", r, g, b, 1, 1, 1);
        GameTooltip:AddDoubleLine(tk:GetThemeColoredString("Right Click:"), "Sort Bags", r, g, b, 1, 1, 1);
        GameTooltip:Show();
    end

    local function OnLeave()
        GameTooltip:Hide();
    end
		
	function items.bags:enable()
		self.btn:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		self.btn:SetScript("OnEnter", OnEnter);
        self.btn:SetScript("OnLeave", OnLeave);
		self.handler = em:CreateEventHandler("BAG_UPDATE", function()
			if (not self.btn) then return; end
			self:update();
		end);
	end
end

function items.bags:disable()
    if (self.handler) then
        self.handler:Destroy();
    end
end

function items.bags:update()
    local slots = 0;
    local totalSlots = 0;
    for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        totalSlots = totalSlots + (GetContainerNumSlots(i) or 0);
        slots = slots + (GetContainerNumFreeSlots(i) or 0);
    end

    if (dt.sv.bags.slots_to_show == "used") then
        slots = totalSlots - slots;
    end

    if (dt.sv.bags.show_total_slots) then
        self.btn:SetText(tk.string.format("Bags: |cffffffff%u / %u|r", slots, totalSlots));
    else
        self.btn:SetText(tk.string.format("Bags: |cffffffff%u|r", slots));
    end
end

function items.bags:click(button)
	if (button == "LeftButton") then
	   ToggleAllBags();
	elseif (button == "RightButton") then
		SortBags();		
	end
end

-------------------------------
-- Initialize DataText:
-------------------------------
function dt:ClickButton(btn, buttonClicked, ...)
    local item = items[btn:GetID()];

    GameTooltip:Hide();
    item:update();

    item.content = self:ChangeMenuScrollChild(item.content);
    self.slideController:Stop();

    if (self.menu:IsShown() and self.lastID == btn:GetID() and self.lastButtonClicked == buttonClicked) then
        if (items[btn:GetID()].name == "spec") then
            gui:FoldAllDropDownMenus();
        end

        self.slideController:Start();
        tk.UIFrameFadeOut(self.menu, 0.3, self.menu:GetAlpha(), 0);
		tk.PlaySound(tk.Constants.CLICK);
        return;
    end

    self.menu:Hide();
    self.menu:ClearAllPoints();

    if (not item.showMenu) then
        if (item.click) then
            item:click(buttonClicked, ...)
        end;
        return;
    end

    self:ClearLabels(item.content.labels);

    local totalHeight = item:click(buttonClicked, ...) or self.sv.max_menu_height;
    totalHeight = (totalHeight < self.sv.max_menu_height) and totalHeight or self.sv.max_menu_height;  

    local offset = self.bui.Resources.container:GetHeight();

    if (btn:GetID() == self.num_items) then
        self.menu:SetPoint("BOTTOMRIGHT", item.btn, "TOPRIGHT", -1, offset + 2);

    elseif (btn:GetID() == 1) then
        self.menu:SetPoint("BOTTOMLEFT", item.btn, "TOPLEFT", 1, offset + 2);

    else
        self.menu:SetPoint("BOTTOM", item.btn, "TOP", 0, offset + 2);
    end

    self.lastID = btn:GetID();
    self.lastButtonClicked = buttonClicked;

    self.slideController:SetMaxHeight(totalHeight);
    self.slideController:Start();

    tk.UIFrameFadeIn(self.menu, 0.3, 0, 1);
    tk.PlaySound(tk.Constants.CLICK);
end

do
    local function CreateDataButton(name)
        local btn = tk:PopFrame("Button", dt.bar);
        local font = tk.Constants.LSM:Fetch("font", db.global.core.font);
        btn:SetNormalTexture(tk.Constants.MEDIA.."mui_bar");
        btn:GetNormalTexture():SetVertexColor(0.08, 0.08, 0.08);
        btn:SetHighlightTexture(tk.Constants.MEDIA.."mui_bar");
        btn:GetHighlightTexture():SetVertexColor(0.08, 0.08, 0.08);
        btn:SetNormalFontObject("MUI_FontNormal");
        btn:SetText((name == "blank" and " ") or name);
        btn:GetFontString():SetFont(font, dt.sv.font_size);
        return btn;
    end

    local function OnClick(...)
        dt:ClickButton(...);
    end

    function dt:GetDataButton(name, position)
        -- create button (reuse or new button)
        local btn = self.btns[position] or CreateDataButton(name);
        btn:SetID(position);
        local item = items[position];
        if (not item or (item and item.name ~= name)) then
            if (item) then
                if (item.disable) then item:disable() end;
                item.enabled = nil;
            end
            items[position] = tk.setmetatable({btn = btn, name = name}, {__index = items[name]});
            item = items[position];
        end
        if (not item.enabled and item.enable) then
            item:enable();
            item.enabled = true;
        end
        if (item.update) then item:update(); end

        if (name ~= "blank") then
            btn:SetScript("OnClick", OnClick);
        else
            btn:SetScript("OnClick", nil);
        end
        return btn;
    end
end

function dt:ForceUpdate(name)
    for id, item in tk.ipairs(items) do
        if (((not name) or item.name == name) and item.update) then
            item:update(true);
        end
    end
end

function dt:SetupButtons()
    self.btns = self.btns or {};
    self.num_items = 0;
    for id, value in self.sv.enabled:Iterate() do
        if (value ~= "disabled") then
            self.num_items = self.num_items + 1;
            local btn = self:GetDataButton(value, self.num_items);
            self.btns[self.num_items] = btn;
        end
    end

    local item_width = self.bui.container:GetWidth() / self.num_items;

    for i = 1, 10 do
        local btn = self.btns[i];

        if (i <= self.num_items) then
            btn:ClearAllPoints();
            btn:Show();

            if (i == 1) then
                btn:SetPoint("BOTTOMLEFT", self.sv.spacing, 0);
                btn:SetPoint("TOPRIGHT", self.bar, "TOPLEFT", item_width - self.sv.spacing, -self.sv.spacing);
            else
                btn:SetPoint("TOPLEFT", self:GetButton(i - 1), "TOPRIGHT", self.sv.spacing, 0);
                btn:SetPoint("BOTTOMRIGHT", self:GetButton(i - 1), "BOTTOMRIGHT", item_width, 0);
            end

        elseif (btn) then
            btn:Hide();

        end
    end

    self.menu:Hide();
end

function dt:init()
    if (not MayronUI:IsInstalled()) then return; end
    if (self.menu) then return; end
    self.sv = db.profile.datatext;

    if (not self.sv.enable_module) then return; end
    self.bui = MayronUI:ImportModule("BottomUI");
    self.bar = tk:PopFrame("Frame", self.bui.container);
    self.bar:SetHeight(self.sv.height);
    self.bar:SetPoint("BOTTOMLEFT");
    self.bar:SetPoint("BOTTOMRIGHT");
    tk:SetBackground(self.bar, 0, 0, 0);
    self.bar:SetFrameStrata(self.sv.frame_strata);
    self.bar:SetFrameLevel(self.sv.frame_level);

    if (not db:ParsePathValue("global.datatext.money.characters")) then
        db:SetPathValue("global.datatext.money.characters", {});
    end

    local colored_key = tk:GetClassColoredString(nil, tk:GetPlayerKey());
    db.global.datatext.money.characters[colored_key] = GetMoney();

    -- create the menu container
    self.menu = gui:CreateScrollFrame(self.bui.container, "MUI_DataTextMenu");
    self.menu.ScrollBar:SetPoint("TOPLEFT", self.menu, "TOPRIGHT", -6, 1);
    self.menu.ScrollBar:SetPoint("BOTTOMRIGHT", self.menu, "BOTTOMRIGHT", -1, 1);

    self.menu.bg = gui:CreateDialogBox(self.menu, "High");
    self.menu.bg:SetPoint("TOPLEFT", 0, 2);
    self.menu.bg:SetPoint("BOTTOMRIGHT", 0, -2);

    self.menu.bg:SetGridColor(0.4, 0.4, 0.4, 1);
    self.menu.bg:SetFrameLevel(1);
    self.menu:SetWidth(self.sv.menu_width);
    self.menu:SetFrameStrata("DIALOG");
    self.menu:EnableMouse(true);
    self.menu.anchor = "";
    self.menu.lastButton = "";
    self.menu:Hide();

    self.menu:SetScript("OnHide", function()
        if (dt.dropdowns) then
            for _, dropdown in tk.ipairs(dt.dropdowns) do
                dropdown:GetFrame().menu:Hide();
            end
        end
    end);

    self.slideController = tk:CreateSlideController(self.menu);
    tk.table.insert(UISpecialFrames, "MUI_DataTextMenu");

    if (self.sv.hideMenuInCombat) then
        em:CreateEventHandler("PLAYER_REGEN_DISABLED", function()
            if (self.sv.hideMenuInCombat) then
                tk._G["MUI_DataTextMenu"]:Hide();
            end
        end);
    end

    dt:SetupButtons();
end

function dt:OnConfigUpdate(list, value)
    if (not self.sv.enable_module) then return; end
    local key = list:PopFront();

    if (key == "profile" and list:PopFront() == "datatext") then
        key = list:PopFront();
        if (key == "enabled") then
            self:SetupButtons();

        elseif (key == "performance") then
            self:ForceUpdate("performance");

        elseif (key == "money") then
            self:ForceUpdate("money");

        elseif (key == "bags") then
            self:ForceUpdate("bags");

        elseif (key == "guild") then
            if (list:PopFront() == "show_tooltips") then
                items.guild.update_required = true;
            end

        elseif (key == "menu_width") then
            self.menu:SetWidth(value);

        elseif (key == "max_menu_height") then
            self.slideController:Start();
            
        elseif (key == "font_size") then
            local font = tk.Constants.LSM:Fetch("font", db.global.core.font);

            for id, btn in tk.ipairs(self.btns) do
                btn:GetFontString():SetFont(font, value);

                if (btn.seconds) then
                    btn.seconds:SetFont(font, value);
                end

                if (btn.minutes) then
                    btn.minutes:SetFont(font, value);
                end

                if (btn.milliseconds) then
                    btn.milliseconds:SetFont(font, value);
                end
            end

        elseif (key == "spacing") then
            self:SetupButtons();

        elseif (key == "combat_block") then
            if (self.blocker and not value) then
                self.blocker:Hide();

            elseif (value) then
                self:CreateBlocker();

            end
        elseif (key == "hideMenuInCombat") then
            if (tk.InCombatLockdown() and value and self.menu:IsVisible()) then
                self.slideController:Start();
            end

        elseif (key == "frame_strata") then
            self.bar:SetFrameStrata(value);

        elseif (key == "frame_level") then
            self.bar:SetFrameLevel(value);

        end
    end
end