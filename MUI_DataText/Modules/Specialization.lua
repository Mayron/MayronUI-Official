-- Setup Namespaces ------------------

local _, Core = ...;

local em = Core.EventManager;
local tk = Core.Toolkit;
local db = Core.Database;
local gui = Core.GUIBuilder;
local L = Core.Locale;

local LABEL_PATTERN = "|cffffffff%s|r";

-- Register and Import Modules -------

local DataText = MayronUI:ImportModule("BottomUI_DataText");
local SpecializationModule, Specialization = MayronUI:RegisterModule("DataText_Specialization");
local Engine = Core.Objects:Import("MayronUI.Engine");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.specialization", {
    enabled = true,
    sets = {},
    displayOrder = 7
});

-- Local Functions ----------------

local function OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
    GameTooltip:SetText(L["Commands"]..":")
    GameTooltip:AddDoubleLine(tk:GetThemeColoredText(L["Left Click:"]), L["Choose Spec"], r, g, b, 1, 1, 1);
    GameTooltip:AddDoubleLine(tk:GetThemeColoredText(L["Right Click:"]), L["Choose Loot Spec"], r, g, b, 1, 1, 1);
    GameTooltip:Show();
end

local function OnLeave()
    GameTooltip:Hide();
end

local function OnLabelClick(self)
    if (self.specID) then
        if (GetSpecialization() ~= self.specID) then
            SetSpecialization(self.specID);
            DataText.slideController:Start();
        end

    elseif (self.lootSpecID) then
        if (GetLootSpecialization() ~= self.lootSpecID) then
            SetLootSpecialization(self.lootSpecID);
            DataText.slideController:Start();

            if (self.lootSpecID == 0) then
                local _, name = GetSpecializationInfo(GetSpecialization());
                tk.print(YELLOW_FONT_COLOR_CODE..L["Loot Specialization set to: Current Specialization"].." ("..name..")|r");
            end
        end

    end
end

local function SetEquipmentSet(self, setName, specName)
    if (setName == L["<none>"]) then 
        setName = nil; 
    end
    db.profile.datatext.spec.sets[specName] = setName;
end

local function CreateLabel(c)
    local label = tk:PopFrame("Button", c);

    label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.name:SetPoint("LEFT", 6, 0);
    label.name:SetWidth(DataText.sv.menu_width - 10);
    label.name:SetWordWrap(false);
    label.name:SetJustifyH("LEFT");
    label:SetScript("OnClick", OnLabelClick);

    return label;
end

-- Specialization Module --------------

SpecializationModule:OnInitialize(function(self, data) 
    data.sv = db.profile.datatext.specialization;

    if (data.sv.enabled) then
        --DataText:RegisterDataItem(self);
    end
end);

SpecializationModule:OnEnable(function(self, data, btn)
    data.btn = btn;
    data.showMenu = true;
    data.btn:RegisterForClicks("LeftButtonUp", "RightButtonUp");

    local r, g, b = tk:GetThemeColor();
    data.btn:SetScript("OnEnter", OnEnter);
    data.btn:SetScript("OnLeave", OnLeave);

    em:CreateEventHandler("PLAYER_ENTERING_WORLD", function()
        self:Update();
    end):SetKey("spec_1");

    em:CreateEventHandler("PLAYER_SPECIALIZATION_CHANGED", function(_, _, unitID)
        if (unitID == "player") then
            data:update();  

            if (not DataText.sv.spec.sets) then return; end
            local _, name = GetSpecializationInfo(GetSpecialization());

            if (DataText.sv.spec.sets[name]) then
                local setName = DataText.sv.spec.sets[name];

                if (setName ~= nil) then                    
                    C_EquipmentSet.UseEquipmentSet(setName);
                end
            end
        end
    end):SetKey("spec_2");
end);

SpecializationModule:OnDisable(function(self, data)
    em:FindHandlerByKey("spec_1"):Destroy();
    em:FindHandlerByKey("spec_2"):Destroy();

    data.btn:SetScript("OnEnter", nil);
    data.btn:SetScript("OnLeave", nil);
    data.showMenu = nil;
end);

-- Specialization Object --------------

function Specialization:Update(data)
    if (not data.btn) then 
        return; 
    end

    if (UnitLevel("player") < 10) then
        data.btn:SetText(L["No Spec"]);
        data.showMenu = nil;
        return;
    end

    data.showMenu = true;
    local specID = GetSpecialization();

    if (not specID) then
        data.btn:SetText(L["No Spec"]);
    else
        local _, name = GetSpecializationInfo(specID, nil, nil, "player");
        data.btn:SetText(name);
    end
end

function Specialization:Click(data, content)
    if (not data.showMenu) then
        if (UnitLevel("player") < 10) then
            tk:Print(L["Must be level 10 or higher to use Talents."]);
        end
        return;
    end

    local numLabelsShown = 1;
    local r, g, b = tk:GetThemeColor();

    data.content.labels = data.content.labels or {};    

    if (button == "LeftButton") then
        local title = data.content.labels[numLabelsShown] or CreateLabel(data.content);

        data.content.labels[numLabelsShown] = title;
        title.name:SetText(tk:GetRGBColoredString(L["Choose Spec"]..":", r, g, b));
        title:SetNormalTexture(1);
        title:GetNormalTexture():SetColorTexture(0, 0, 0, 0.4);

        local dropdownID = 0;

        for i = 1, GetNumSpecializations() do
            numLabelsShown = numLabelsShown + 1;
            local _, specName = GetSpecializationInfo(i);
            local extra = "";
            local label = data.content.labels[numLabelsShown] or CreateLabel(data.content);

            data.content.labels[numLabelsShown] = label;
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
            data.dropdowns = data.dropdowns or {};

            -- create dropdown:
            local dropdown = data.dropdowns[i] or gui:CreateDropDown(
                tk.Constants.AddOnStyle, data.content, "UP", DataText.bar);

                data.dropdowns[i] = dropdown;
            label.dropdown = dropdown;

            dropdown:Show();

            if (DataText.sv.spec.sets and DataText.sv.spec.sets[specName]) then
                dropdown:SetLabel(DataText.sv.spec.sets[specName]);
            else
                dropdown:SetLabel("Equipment Set");
            end

            if (not dropdown.registered) then
                for i = 0, C_EquipmentSet.GetNumEquipmentSets() do
                    local label = C_EquipmentSet.GetEquipmentSetInfo(i);

                    if (label == nil) then 
                        break; 
                    end 

                    dropdown:AddOption(label, C_EquipmentSet.SetEquipmentSet, nil, specName);
                end

                dropdown.registered = true;
                dropdown:AddOption(L["<none>"], C_EquipmentSet.SetEquipmentSet, nil, specName);
            end
        end

        -- position manually:
        local totalHeight = 0;

        for i = 1, #data.content.labels do
            local f = data.content.labels[i];

            if (i == 1) then
                f:SetPoint("TOPLEFT", 2, 0);
                f:SetPoint("BOTTOMRIGHT", data.content, "TOPRIGHT", -2, - DataText.sv.menu_item_height);

            else
                local anchor = data.content.labels[i - 1];
                local xOffset = 0;
                local dropdownPadding = 0;

                if (anchor.dropdown) then
                    anchor = anchor.dropdown:GetFrame();
                    xOffset = 8;
                    dropdownPadding = 10;
                end

                f:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -(dropdownPadding));
                f:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", xOffset, -(DataText.sv.menu_item_height + dropdownPadding));
                totalHeight = totalHeight + dropdownPadding;
            end

            if (f.dropdown) then
                local dropdownPadding = 10;

                f.dropdown:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -dropdownPadding);
                f.dropdown:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, -(DataText.sv.menu_item_height + dropdownPadding));
                totalHeight = totalHeight + DataText.sv.menu_item_height + dropdownPadding;
            end

            if (i > numLabelsShown) then
                f:Hide();
            else
                f:Show();
                totalHeight = totalHeight + DataText.sv.menu_item_height;

                if (i > 1) then 
                    totalHeight = totalHeight + 2; 
                end
            end            
        end

        data.content:SetHeight(totalHeight); -- manual positioning = manual setting of height
        return totalHeight;

    elseif (button == "RightButton") then
        local title = data.content.labels[numLabelsShown] or CreateLabel(data.content);

        data.content.labels[numLabelsShown] = title;
        title.name:SetText(tk:GetRGBColoredString(L["Choose Loot Spec"]..":", r, g, b));
        title:SetNormalTexture(1);
        title:GetNormalTexture():SetColorTexture(0, 0, 0, 0.4);

        for i = 0, GetNumSpecializations() do
            numLabelsShown = numLabelsShown + 1;

            local label = data.content.labels[numLabelsShown] or CreateLabel(data.content);
            data.content.labels[numLabelsShown] = label;

            local name;

            if (i == 0) then
                name = tk.select(2, GetSpecializationInfo(GetSpecialization()));
                label.lootSpecID = 0;
                name = tk.string.format(L["Current Spec"].." (%s)", name);
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

        return DataText:PositionLabels(data.content, numLabelsShown);
    end
end

function Specialization:HasMenu()
    return true;
end

Engine:DefineReturns("Button");
function Specialization:GetButton(data)
    return data.btn;
end