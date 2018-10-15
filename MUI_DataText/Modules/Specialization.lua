-- Setup Namespaces ------------------

local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local LABEL_PATTERN = "|cffffffff%s|r";

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local DataText = MayronUI:ImportModule("DataText");
local Specialization = Engine:CreateClass("Specialization", nil, "MayronUI.Engine.IDataTextModule");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.specialization", {
    enabled = true,
    sets = {},
    displayOrder = 7
});

-- Local Functions ----------------

local function button_OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
    GameTooltip:SetText(L["Commands"]..":")
    GameTooltip:AddDoubleLine(tk:GetThemeColoredText(L["Left Click:"]), L["Choose Spec"], r, g, b, 1, 1, 1);
    GameTooltip:AddDoubleLine(tk:GetThemeColoredText(L["Right Click:"]), L["Choose Loot Spec"], r, g, b, 1, 1, 1);
    GameTooltip:Show();
end

local function button_OnLeave()
    GameTooltip:Hide();
end

local CreateLabel;
do
    local onLabelClickFunc;

    function CreateLabel(contentFrame, popupWidth, slideController)
        local label = tk:PopFrame("Button", contentFrame);
    
        label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        label.name:SetPoint("LEFT", 6, 0);
        label.name:SetWidth(popupWidth - 10);
        label.name:SetWordWrap(false);
        label.name:SetJustifyH("LEFT");


        if (not onLabelClickFunc) then
            onLabelClickFunc = function(self)
                if (self.specID) then
                    if (GetSpecialization() ~= self.specID) then
                        SetSpecialization(self.specID);
                        slideController:Start();
                    end
            
                elseif (self.lootSpecID) then
                    if (GetLootSpecialization() ~= self.lootSpecID) then
                        SetLootSpecialization(self.lootSpecID);
                        slideController:Start();
            
                        if (self.lootSpecID == 0) then
                            local _, name = GetSpecializationInfo(GetSpecialization());
                            tk.print(YELLOW_FONT_COLOR_CODE..L["Loot Specialization set to: Current Specialization"].." ("..name..")|r");
                        end
                    end            
                end
            end
        end

        label:SetScript("OnClick", onLabelClickFunc);    
        return label;
    end
end

local function SetEquipmentSet(self, setName, specName)
    if (setName == L["<none>"]) then 
        setName = nil; 
    end

    db.profile.datatext.specialization.sets[specName] = setName;
end

-- Specialization Module --------------

DataText:Hook("OnInitialize", function(self, dataTextData)
    local sv = db.profile.datatext.specialization;
    sv:SetParent(dataTextData.sv);

    if (sv.enabled) then
        local specialization = Specialization(sv, dataTextData.bar, dataTextData.slideController);
        self:RegisterDataModule(specialization);
        specialization:Enable();
    end
end);

function Specialization:__Construct(data, sv, dataTextBar, slideController)
    data.sv = sv;
    data.displayOrder = sv.displayOrder;
    data.dataTextBar = dataTextBar;
    data.slideController = slideController;

    -- set public instance properties
    self.MenuContent = CreateFrame("Frame");
    self.MenuLabels = {};
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = true;
    self.HasRightMenu = true;

    self.Button = DataText:CreateDataTextButton(self);
    self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function Specialization:Enable(data) 
    data.sv.enabled = true;

    local r, g, b = tk:GetThemeColor();
    self.Button:SetScript("OnEnter", button_OnEnter);
    self.Button:SetScript("OnLeave", button_OnLeave);

    em:CreateEventHandler("PLAYER_ENTERING_WORLD", function()
        self:Update();
    end):SetKey("spec_1");

    em:CreateEventHandler("PLAYER_SPECIALIZATION_CHANGED", function(_, _, unitID)
        if (unitID == "player") then
            self:Update(); 

            if (not data.sv.sets) then return; end
            local _, name = GetSpecializationInfo(GetSpecialization());

            if (data.sv.sets[name]) then
                local setName = data.sv.sets[name];

                if (setName ~= nil) then                    
                    C_EquipmentSet.UseEquipmentSet(setName);
                end
            end
        end
    end):SetKey("spec_2");
end

function Specialization:IsEnabled(data) 
    return data.sv.enabled;
end

function Specialization:Disable(data)
    data.sv.enabled = false;

    em:FindHandlerByKey("spec_1"):Destroy();
    em:FindHandlerByKey("spec_2"):Destroy();

    self.Button:SetScript("OnEnter", nil);
    self.Button:SetScript("OnLeave", nil);
end

function Specialization:Update(data)
    if (not self.Button) then 
        return; 
    end

    if (UnitLevel("player") < 10) then
        self.Button:SetText(L["No Spec"]);
        -- data.showMenu = nil;
        return;
    end

    -- data.showMenu = true;
    local specID = GetSpecialization();

    if (not specID) then
        self.Button:SetText(L["No Spec"]);
    else
        local _, name = GetSpecializationInfo(specID, nil, nil, "player");
        self.Button:SetText(name);
    end
end

function Specialization:Click(data, button)
    -- if (not data.showMenu) then
        if (UnitLevel("player") < 10) then
            tk:Print(L["Must be level 10 or higher to use Talents."]);
            return;
        end        
    -- end

    local totalLabelsShown = 1;
    local r, g, b = tk:GetThemeColor(); 
    local itemHeight = data.sv.popup.itemHeight;

    if (button == "LeftButton") then
        local title = self.MenuLabels[totalLabelsShown] or CreateLabel(self.MenuContent, data.sv.popup.width, data.slideController);

        self.MenuLabels[totalLabelsShown] = title;
        title.name:SetText(tk:GetRGBColoredText(L["Choose Spec"]..":", r, g, b));
        title:SetNormalTexture(1);
        title:GetNormalTexture():SetColorTexture(0, 0, 0, 0.4);

        local dropdownID = 0;

        for i = 1, GetNumSpecializations() do
            totalLabelsShown = totalLabelsShown + 1;
            local _, specName = GetSpecializationInfo(i);
            local extra = "";
            local label = self.MenuLabels[totalLabelsShown] or CreateLabel(self.MenuContent, data.sv.popup.width, data.slideController);

            self.MenuLabels[totalLabelsShown] = label;
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
                tk.Constants.AddOnStyle, self.MenuContent, "UP", data.dataTextBar);

            data.dropdowns[i] = dropdown;
            label.dropdown = dropdown;
            dropdown:Show();

            if (data.sv.sets and data.sv.sets[specName]) then
                dropdown:SetLabel(data.sv.sets[specName]);
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

        for i = 1, #self.MenuLabels do
            local f = self.MenuLabels[i];

            if (i == 1) then
                f:SetPoint("TOPLEFT", 2, 0);
                f:SetPoint("BOTTOMRIGHT", self.MenuContent, "TOPRIGHT", -2, - itemHeight);

            else
                local anchor = self.MenuLabels[i - 1];
                local xOffset = 0;
                local dropdownPadding = 0;

                if (anchor.dropdown) then
                    anchor = anchor.dropdown:GetFrame();
                    xOffset = 8;
                    dropdownPadding = 10;
                end

                f:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -(dropdownPadding));
                f:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", xOffset, -(itemHeight + dropdownPadding));
                totalHeight = totalHeight + dropdownPadding;
            end

            if (f.dropdown) then
                local dropdownPadding = 10;

                f.dropdown:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -dropdownPadding);
                f.dropdown:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, -(itemHeight + dropdownPadding));
                totalHeight = totalHeight + itemHeight + dropdownPadding;
            end

            if (i > totalLabelsShown) then
                f:Hide();
            else
                f:Show();
                totalHeight = totalHeight + itemHeight;

                if (i > 1) then 
                    totalHeight = totalHeight + 2; 
                end
            end            
        end

        self.MenuContent:SetHeight(totalHeight); -- manual positioning = manual setting of height

    elseif (button == "RightButton") then
        local title = self.MenuLabels[totalLabelsShown] or CreateLabel(self.MenuContent, data.sv.popup.width, data.slideController);

        self.MenuLabels[totalLabelsShown] = title;
        title.name:SetText(tk:GetRGBColoredText(L["Choose Loot Spec"]..":", r, g, b));
        title:SetNormalTexture(1);
        title:GetNormalTexture():SetColorTexture(0, 0, 0, 0.4);

        for i = 0, GetNumSpecializations() do
            totalLabelsShown = totalLabelsShown + 1;

            local label = self.MenuLabels[totalLabelsShown] or CreateLabel(self.MenuContent, data.sv.popup.width, data.slideController);
            self.MenuLabels[totalLabelsShown] = label;

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
    end

    self.TotalLabelsShown = totalLabelsShown;
end

function Specialization:GetDisplayOrder(data)
    return data.displayOrder;
end

function Specialization:SetDisplayOrder(data, displayOrder)
    if (data.displayOrder ~= displayOrder) then
        data.displayOrder = displayOrder;
        data.sv.displayOrder = displayOrder;
    end
end 