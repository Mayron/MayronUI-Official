local _, namespace = ...;
local MayronUI = _G.MayronUI;

-- luacheck: ignore MayronUI self 143 631
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();
if (tk:IsClassic()) then return end

---@type Package
local ComponentsPackage = namespace.ComponentsPackage;

local select, GetSpecializationInfo, C_EquipmentSet = _G.select, _G.GetSpecializationInfo, _G.C_EquipmentSet;
local GetSpecialization, UnitLevel, CreateFrame, string = _G.GetSpecialization, _G.UnitLevel, _G.CreateFrame, _G.string;
local GetLootSpecialization, UnitSex, SetLootSpecialization, print = _G.GetLootSpecialization, _G.UnitSex, _G.SetLootSpecialization, _G.print;
local SetSpecialization, GetNumSpecializations, GameTooltip = _G.SetSpecialization, _G.GetNumSpecializations, _G.GameTooltip;

-- Register and Import Modules -------

local Specialization = ComponentsPackage:CreateClass("Specialization", nil, "IDataTextComponent");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.specialization", {
  sets = {};
  layouts = {};
});

-- Local Functions ----------------

local function Button_OnEnter(self)
  local r, g, b = tk:GetThemeColor();

  GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 2);
  GameTooltip:SetText(L["Commands"]..":")
  GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Left Click:"]), L["Choose Spec"], r, g, b, 1, 1, 1);
  GameTooltip:AddDoubleLine(tk.Strings:SetTextColorByTheme(L["Right Click:"]), L["Choose Loot Spec"], r, g, b, 1, 1, 1);
  GameTooltip:Show();
end

local function Button_OnLeave()
  GameTooltip:Hide();
end

local function SetLabelEnabled(label, enabled)
  if (not enabled) then
    label:SetNormalTexture(1);
    label:GetNormalTexture():SetColorTexture(0, 0, 0, 0.4);
    label:SetHighlightTexture(nil);
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

local function CreateEquipmentSetDropDown(settings, contentFrame, popupWidth, dataTextBar, specializationID)
  -- create dropdown to list all equipment sets per specialization:
  local dropdown = gui:CreateDropDown(tk.Constants.AddOnStyle, contentFrame, "UP", dataTextBar);
  dropdown:SetWidth(popupWidth - 10);
  dropdown:Show();

  local specName = select(2, GetSpecializationInfo(specializationID));
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

local function CreateLayoutDropDown(settings, contentFrame, popupWidth, dataTextBar, specializationID)
  -- create dropdown to list all equipment sets per specialization:
  local dropdown = gui:CreateDropDown(tk.Constants.AddOnStyle, contentFrame, "UP", dataTextBar);
  dropdown:SetWidth(popupWidth - 10);
  dropdown:Show();

  local specName = select(2, GetSpecializationInfo(specializationID));
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
  self.MenuContent = CreateFrame("Frame");
  self.MenuContent.minWidth = 230;

  self.MenuLabels = obj:PopTable();
  self.TotalLabelsShown = 0;
  self.HasLeftMenu = true;
  self.HasRightMenu = true;
  self.Button = dataTextModule:CreateDataTextButton();

  self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
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
      local listener = em:CreateEventListenerWithID(listenerID, function(_, _, unitID)
        if (unitID ~= "player") then return end -- should always be player but just in case
        self:Update();

        if (not data.settings.sets) then return end

        local _, specializationName = GetSpecializationInfo(GetSpecialization());

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

      listener:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player");

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

ComponentsPackage:DefineParams("table", "number", "number", "function");
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

  local specializationID = GetSpecialization();

  if (not specializationID) then
    self.Button:SetText(L["No Spec"]);
  else
    local _, name = GetSpecializationInfo(specializationID, nil, nil, "player");
    self.Button:SetText(name);
  end
end

function Specialization:GetLabel(data, index)
  local label = self.MenuLabels[index];

  if (label) then
    return label;
  end

  label = tk:PopFrame("Button", self.MenuContent);
  label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  label.name:SetPoint("LEFT", 6, 0);
  label.name:SetWidth(data.settings.popup.width - 10);
  label.name:SetWordWrap(false);
  label.name:SetJustifyH("LEFT");

  label:SetScript("OnClick", function(self)
    -- must use "self" as label properties are set after GetLabel is called
    -- (so should be dynamically bound, not static using a closure)
    if (label.dropdown or not self.specializationID) then
      return;
    end

    local currentSpecializationID = GetSpecialization();

    if (self.lootSpecID ~= nil) then
      -- handle changing loot specs

      if (GetLootSpecialization() ~= self.lootSpecID) then
        -- update loot spec ID:
        local sex = UnitSex("player");
        self.lootSpecID = GetSpecializationInfo(self.specializationID, nil, nil, nil, sex) or 0;

        -- change loot specialization
        SetLootSpecialization(self.lootSpecID);

        if (self.lootSpecID == 0) then
          -- no chat message is printed when set to current spec, so print our own
          local _, name = GetSpecializationInfo(currentSpecializationID);
          print(tk.Strings:Concat(_G.YELLOW_FONT_COLOR_CODE,
          L["Loot Specialization set to: Current Specialization"], " (", name, ")|r"));
        end
      end
    else
      -- handle changing spec
      if (currentSpecializationID ~= self.specializationID) then
        -- change specialization
        SetSpecialization(self.specializationID);
      end
    end

    data.slideController:Start();
  end);

  self.MenuLabels[index] = label;
  return label;
end

-- show specialization selection with dropdown menus
function Specialization:HandleLeftClick(data)
  local totalLabelsShown = 1; -- including title

  for i = 1, GetNumSpecializations() do
    -- create label
    totalLabelsShown = totalLabelsShown + 1;

    local label = self:GetLabel(totalLabelsShown);
    label.specializationID = i;
    label.lootSpecID = nil;

    -- update labels based on specialization
    local specializationName = select(2, GetSpecializationInfo(label.specializationID));
    local enabled = (label.specializationID ~= GetSpecialization());

    SetLabelEnabled(label, enabled);

    if (not enabled) then
      specializationName = string.format(L["Current"] .. " (%s)", specializationName);
    end

    label.name:SetText(specializationName);

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
    label.specializationID = i;

    if (label.dropdown) then
      local frame = label.dropdown:GetFrame();
      frame:SetParent(tk.Constants.DUMMY_FRAME);
      frame:SetAllPoints(true);
      frame:Hide();
      label.dropdown:SetHeaderShown(false);
      label.dropdown = nil;
    end

    local sex = UnitSex("player");
    label.lootSpecID = GetSpecializationInfo(label.specializationID, nil, nil, nil, sex) or 0;

    -- update labels based on loot spec
    local enabled = (label.lootSpecID ~= GetLootSpecialization());
    SetLabelEnabled(label, enabled);

    if (label.specializationID == 0) then
      local specializationName = select(2, GetSpecializationInfo(GetSpecialization()));
      label.name:SetText(string.format(L["Current"] .. " (%s)", specializationName));
    else
      local specializationName = select(2, GetSpecializationInfo(label.specializationID));
      label.name:SetText(specializationName);
    end
  end

  return totalLabelsShown;
end

function Specialization:Click(_, button)
  if (UnitLevel("player") < 10) then
    tk:Print(L["Must be level 10 or higher to use Talents."]);
    return true;
  end

  local r, g, b = tk:GetThemeColor();
  local title = self:GetLabel(1);

  title:SetNormalTexture(1);
  title:GetNormalTexture():SetColorTexture(0, 0, 0, 0.4);

  if (button == "LeftButton") then
    title.name:SetText(tk.Strings:SetTextColorByRGB(L["Choose Spec"]..":", r, g, b));
    self.TotalLabelsShown = self:HandleLeftClick();

  elseif (button == "RightButton") then
    title.name:SetText(tk.Strings:SetTextColorByRGB(L["Choose Loot Spec"]..":", r, g, b));
    self.TotalLabelsShown = self:HandleRightClick();
  end
end