local _G = _G;
local MayronUI = _G.MayronUI;

-- luacheck: ignore MayronUI self 143 631
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();
if (not (tk:IsRetail() or tk:IsWrathClassic())) then return end

local C_EquipmentSet, GameTooltip = _G.C_EquipmentSet, _G.GameTooltip;
local UnitLevel, string = _G.UnitLevel, _G.string;

-- retail only:
local GetLootSpecialization, SetLootSpecialization = _G.GetLootSpecialization, _G.SetLootSpecialization;
local GetNumSpecializations = _G.GetNumSpecializations;

-- Register and Import Modules -------

local Specialization = obj:CreateClass("Specialization");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.specialization", {
  sets = {};
  layouts = {};
});

-- Local Functions ----------------

local function Button_OnEnter(self)
  local name = tk:GetPlayerSpecialization();

  if (tk.Strings:IsNilOrWhiteSpace(name)) then
    GameTooltip:Hide();
    return
  end

  local r, g, b = tk:GetThemeColor();

  GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);

  if (tk:IsWrathClassic()) then
    GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Left Click:"]), L["Choose Spec"], r, g, b, 1, 1, 1);
  else
    GameTooltip:SetText(L["Commands"]..":");
    GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Left Click:"]), L["Choose Spec"], r, g, b, 1, 1, 1);
    GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Right Click:"]), L["Choose Loot Spec"], r, g, b, 1, 1, 1);
  end

  GameTooltip:Show();
end

local function Button_OnLeave()
  GameTooltip:Hide();
end

local function SetLabelEnabled(label, enabled)
  if (not enabled) then
    label:SetNormalTexture(1);
    label:GetNormalTexture():SetColorTexture(0, 0, 0, 0.4);
    label:SetHighlightTexture("");
  else
    local r, g, b = tk:GetThemeColor();

    label:SetNormalTexture(1);
    label:GetNormalTexture():SetColorTexture(r * 0.5, g * 0.5, b * 0.5, 0.4);
    label:SetHighlightTexture(1);
    label:GetHighlightTexture():SetColorTexture(r * 0.5, g * 0.5, b * 0.5, 0.5);
  end
end

local function SetEquipmentSet(_, settings, specializationName, equipmentSetId)
  settings.sets[specializationName] = equipmentSetId;
  settings:SaveChanges();
end

local function CreateEquipmentSetDropDown(settings, contentFrame, popupWidth, dataTextBar, talentGroup)
  -- create dropdown to list all equipment sets per specialization:
  local dropdown = gui:CreateDropDown(contentFrame, "UP", dataTextBar);
  dropdown:SetWidth(popupWidth - 10);
  dropdown:Show();

  local specName = tk:GetPlayerSpecialization(talentGroup);

  local currentEquipmentSetId = settings.sets[specName];

  if (obj:IsNumber(currentEquipmentSetId) and currentEquipmentSetId >= 0 and currentEquipmentSetId <= 9) then
    local equipmentSetName = C_EquipmentSet.GetEquipmentSetInfo(currentEquipmentSetId);

    if (equipmentSetName) then
      -- if user has an equipment set associated with the specialization
      dropdown:SetLabel(equipmentSetName);
    end
  end

  if (not dropdown:GetLabel()) then
    -- if no associated equipment set, set default label
    dropdown:SetLabel("Select equipment set");
  end

  if (not dropdown.registered) then
    for equipmentSetId = 9, 0, -1 do
      local equipmentSetName = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetId);

      if (equipmentSetName) then
        -- label, click function, value (nil) and a list of args to pass to function (specName passed to C_EquipmentSet.SetEquipmentSet)
        dropdown:AddOption(equipmentSetName, SetEquipmentSet, settings, specName, equipmentSetId);
      end
    end

    -- does not change to anything (the default)
    dropdown:AddOption(L["<none>"], SetEquipmentSet, settings, specName);
    dropdown:SetTooltip("Select the equipment set to use when the " .. specName .. " class specialization is active.");
    dropdown.registered = true;  -- do not repeat this setup
  end

  return dropdown;
end

local function SetLayout(_, settings, specializationName, layoutName)
  settings.layouts[specializationName] = layoutName;
  settings:SaveChanges();
end

local function CreateLayoutDropDown(settings, contentFrame, popupWidth, dataTextBar, talentGroup)
  -- create dropdown to list all equipment sets per specialization:
  local dropdown = gui:CreateDropDown(contentFrame, "UP", dataTextBar);
  dropdown:SetWidth(popupWidth - 10);
  dropdown:Show();

  local specName = tk:GetPlayerSpecialization(talentGroup);
  local layoutName = settings.layouts[specName];

  if (layoutName) then
    -- if user has an equipment set associated with the specialization
    dropdown:SetLabel(layoutName);
  end

  if (not dropdown:GetLabel()) then
    -- if no associated layout, set default label
    dropdown:SetLabel("Select UI layout");
  end

  if (not dropdown.registered) then
    for name, data in db.global.layouts:Iterate() do
      if (data) then
        dropdown:AddOption(name, SetLayout, settings, specName, name);
      end
    end

    -- does not change to anything (the default)
    dropdown:AddOption(L["<none>"], SetLayout, settings, specName);
    dropdown:SetTooltip("Select the UI layout to use when the " .. specName .. " class specialization is active.");

    dropdown.registered = true;  -- do not repeat this setup
  end

  return dropdown;
end

-- Specialization Module --------------

MayronUI:Hook("DataTextModule", "OnInitialize", function(self)
  local sv = db.profile.datatext.specialization;
  sv:SetParent(db.profile.datatext);

  local settings = sv:GetTrackedTable();
  self:RegisterComponentClass("specialization", Specialization, settings);
end);

function Specialization:__Construct(data, settings, dataTextModule, slideController, dataTextBar)
  data.settings = settings;
  data.dataTextBar = dataTextBar;
  data.slideController = slideController;
  data.dropdowns = obj:PopTable();
  data.dropdowns.equipment = obj:PopTable();
  data.dropdowns.layouts = obj:PopTable();

  -- set public instance properties
  self.MenuContent = tk:CreateFrame("Frame");
  self.MenuContent.minWidth = 230;

  self.MenuLabels = obj:PopTable();
  self.TotalLabelsShown = 0;
  self.HasLeftMenu = true;
  self.Button = dataTextModule:CreateDataTextButton();

  if (tk:IsRetail()) then
    self.HasRightMenu = true;
    self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
  end
end

function Specialization:IsEnabled(data)
  return data.enabled;
end

function Specialization:SetEnabled(data, enabled)
  data.enabled = enabled;

  local listenerID = "DataText_Specialization_OnChange";
  if (enabled) then
    self.Button:SetScript("OnEnter", Button_OnEnter);
    self.Button:SetScript("OnLeave", Button_OnLeave);

    if (not em:GetEventListenerByID(listenerID)) then
      local listener = em:CreateEventListenerWithID(listenerID, function()
        self:Update();

        if (not data.settings.sets) then return end

        local specializationName = tk:GetPlayerSpecialization();

        if (data.settings.sets[specializationName]) then
          local equipmentSetId = data.settings.sets[specializationName];

          if (equipmentSetId ~= nil) then
            C_EquipmentSet.UseEquipmentSet(equipmentSetId);
          end
        end

        if (data.settings.layouts[specializationName]) then
          local layoutName = data.settings.layouts[specializationName];

          if (layoutName ~= nil) then
            ---@type ChatModule
            local chatModule = MayronUI:ImportModule("ChatModule");
            chatModule:SwitchLayouts(layoutName);
          end
        end
      end);

      if (tk:IsWrathClassic()) then
        listener:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
      else
        listener:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player");
      end

      listener = em:CreateEventListenerWithID("DataText_Specialization_EnteringWorld", function()
        self:Update();
      end);

      listener:RegisterEvent("PLAYER_ENTERING_WORLD");
    else
      em:EnableEventListeners(listenerID, "DataText_Specialization_EnteringWorld");
    end
  else
    em:DisableEventListeners(listenerID, "DataText_Specialization_EnteringWorld");

    self.Button:SetScript("OnEnter", nil);
    self.Button:SetScript("OnLeave", nil);
  end
end

obj:DefineParams("table", "number", "number", "function");
function Specialization:CreateDropdown(data, dropdownsTable, index, totalLabelsShown, handleCreation)
  local popupWidth = data.settings.popup.width;
  local dropdown = dropdownsTable[index] or
    handleCreation(data.settings, self.MenuContent, popupWidth, data.dataTextBar, index);

  dropdownsTable[index] = dropdown;

  local label = self:GetLabel(totalLabelsShown);
  label.dropdown = dropdown;

  SetLabelEnabled(label, false);

  dropdown:SetParent(label);
  dropdown:SetAllPoints(true);
  dropdown:Show();
  dropdown:SetHeaderShown(true);
end

function Specialization:Update(data, refreshSettings)
  if (refreshSettings) then
    data.settings:Refresh();
  end

  if (not self.Button) then
    return
  end

  if (UnitLevel("player") < 10) then
    self.Button:SetText(L["No Spec"]);
    return;
  end

  local specName = tk:GetPlayerSpecialization();
  local specText = L["No Spec"];

  if (obj:IsString(specName) and not tk.Strings:IsNilOrWhiteSpace(specName)) then
    specText = specName;
  end

  self.Button:SetText(specText);
end

function Specialization:GetLabel(data, index)
  local label = self.MenuLabels[index];

  if (label) then
    return label;
  end

  label = tk:CreateFrame("Button", self.MenuContent);
  label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  label.name:SetPoint("LEFT", 6, 0);
  label.name:SetWidth(data.settings.popup.width - 10);
  label.name:SetWordWrap(false);
  label.name:SetJustifyH("LEFT");

  label:SetScript("OnClick", function(self)
    -- must use "self" as label properties are set after GetLabel is called
    -- (so should be dynamically bound, not static using a closure)
    if (label.dropdown) then
      return;
    end

    local specName = tk:GetPlayerSpecialization();

    if (obj:IsNumber(self.lootSpecID) and obj:IsFunction(GetLootSpecialization)) then
      -- handle changing loot specs
      local currentLootSpec = GetLootSpecialization();

      if (currentLootSpec ~= self.lootSpecID) then
        -- change loot specialization
        SetLootSpecialization(self.lootSpecID);

        if (self.lootSpecID == 0) then
          -- no chat message is printed when set to current spec, so print our own
          MayronUI:Print(tk.Strings:Concat(_G.YELLOW_FONT_COLOR_CODE,
            L["Loot Specialization set to: Current Specialization"], " (", specName, ")|r"));
        end
      end
    elseif (obj:IsNumber(self.specializationID)) then
      -- change specialization
      tk:SetSpecialization(self.specializationID);
    end

    data.slideController:Start();
  end);

  self.MenuLabels[index] = label;
  return label;
end

-- show specialization selection with dropdown menus
function Specialization:HandleLeftClick(data)
  local totalLabelsShown = 1; -- including title
  local talentGroups, currentActiveSection;

  if (GetNumSpecializations) then
    talentGroups = GetNumSpecializations();
    currentActiveSection = _G.GetSpecialization();
  else
    talentGroups = _G.GetNumTalentGroups();
    currentActiveSection = _G.GetActiveTalentGroup();
  end

  for i = 1, talentGroups do
    -- create label
    totalLabelsShown = totalLabelsShown + 1;

    local label = self:GetLabel(totalLabelsShown);
    label.specializationID = i;
    label.lootSpecID = nil;

    -- update labels based on specialization

    local isCurrentSpec = i == currentActiveSection;
    SetLabelEnabled(label, not isCurrentSpec);

    local specName = tk:GetPlayerSpecialization(i);

    if (isCurrentSpec) then
      specName = string.format(L["Current"] .. " (%s)", specName);
    end

    label.name:SetText(specName);

    -- create Equipment Set dropdown
    totalLabelsShown = totalLabelsShown + 1;
    self:CreateDropdown(data.dropdowns.equipment, i, totalLabelsShown, CreateEquipmentSetDropDown);

    -- create UI Layout dropdown
    totalLabelsShown = totalLabelsShown + 1;
    self:CreateDropdown(data.dropdowns.layouts, i, totalLabelsShown, CreateLayoutDropDown);
  end

  return totalLabelsShown;
end


function Specialization:HandleRightClick()
  local totalLabelsShown = 1; -- including title

  -- start at index 0 as 0 = setting loot specialization to the "auto" current spec option
  for i = 0, GetNumSpecializations() do
    totalLabelsShown = totalLabelsShown + 1;

    local label = self:GetLabel(totalLabelsShown);

    if (label.dropdown) then
      local frame = label.dropdown:GetFrame();
      frame:SetParent(tk.Constants.DUMMY_FRAME);
      frame:SetAllPoints(true);
      frame:Hide();
      label.dropdown:SetHeaderShown(false);
      label.dropdown = nil;
    end

    label.specializationID = nil;

    if (i == 0) then
      local name = tk:GetPlayerSpecialization();
      label.name:SetText(string.format(L["Current"] .. " (%s)", name));
      label.lootSpecID = 0;
    else
      local name, specID = tk:GetPlayerSpecialization(i);
      label.name:SetText(name);
      label.lootSpecID = specID;
    end

    -- update labels based on loot spec
    local enabled = (label.lootSpecID ~= GetLootSpecialization());
    SetLabelEnabled(label, enabled);
  end

  return totalLabelsShown;
end


function Specialization:Click(_, button)
  if (UnitLevel("player") < 10) then
    tk:Print(L["Must be level 10 or higher to use Talents."]);
    return true;
  end

  local name = tk:GetPlayerSpecialization();

  if (tk.Strings:IsNilOrWhiteSpace(name)) then
    return true;
  end

  local r, g, b = tk:GetThemeColor();
  local title = self:GetLabel(1);

  title:SetNormalTexture(1);
  title:GetNormalTexture():SetColorTexture(0, 0, 0, 0.4);

  if (tk:IsWrathClassic() or button == "LeftButton") then
    title.name:SetText(tk.Strings:SetTextColorByRGB(L["Choose Spec"]..":", r, g, b));
    self.TotalLabelsShown = self:HandleLeftClick();

  elseif (tk:IsRetail() and button == "RightButton") then
    title.name:SetText(tk.Strings:SetTextColorByRGB(L["Choose Loot Spec"]..":", r, g, b));
    self.TotalLabelsShown = self:HandleRightClick();
  end
end