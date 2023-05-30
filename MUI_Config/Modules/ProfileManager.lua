--luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local ipairs, strformat = _G.ipairs, _G.string.format;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

---@class MayronUI.ConfigMenu
local C_ConfigMenuModule = MayronUI:GetModuleClass("ConfigMenu");
local components = {};

local function UpdateCurrentProfileText(currentProfile)
  currentProfile = tk.Strings:SetTextColorByKey(currentProfile, "GOLD");
  local text = tk.Strings:Join("", L["Current profile"], ": ", currentProfile);
  components.currentProfileFontString:SetText(text);
end

local function ResetProfile()
  db:ResetProfile();
end

local function CopyProfile(_, profileName)
  local currentProfile = db:GetCurrentProfile();
  db:CopyProfile(currentProfile, profileName);

  local copyProfileMessage = L["Profile %s has been copied into current profile %s."];

  copyProfileMessage = copyProfileMessage:format(
  tk.Strings:SetTextColorByKey(profileName, "gold"),
  tk.Strings:SetTextColorByKey(currentProfile, "gold"));

  tk:Print(copyProfileMessage);
end

-- Get all profiles and convert them to a list of options for use with dropdown menus
local function GetProfileOptions()
  local profiles = db:GetProfiles();
  local options = obj:PopTable();

  -- key and value should both be the profile name:
  for _, profileName in ipairs(profiles) do
    options[profileName] = profileName;
  end

  return options;
end

local configTable = {
  id = 1;
  name = L["MUI Profile Manager"];
  children = {
    {
      content = L["MANAGE_PROFILES_HERE"];
      type    = "fontstring";
    },
    {
      type = "fontstring";
      GetContent = function()
        return tk.Strings:Join("",
          L["Current profile"], ": ",
          tk.Strings:SetTextColorByKey(db:GetCurrentProfile(), "GOLD"));
      end,

      OnLoad = function(_, container)
        components.currentProfileFontString = container.content;
      end
    },
    {
      GetOptions = GetProfileOptions;
      name       = L["Choose Profile"]..": ";
      tooltip    = L["Choose the currently active profile."];
      type       = "dropdown";
      width      = 200;

      OnLoad = function(_, container)
        components.chooseProfileDropDown = container.component.dropdown;
      end;

      SetValue = function(_, newValue)
        if (db:GetCurrentProfile() == newValue) then
          return;
        end

        db:SetProfile(newValue);
        UpdateCurrentProfileText(newValue);
        components.deleteProfileButton:SetEnabled(newValue ~= "Default");
      end;

      GetValue = function()
        return db:GetCurrentProfile();
      end;
    },
    { type = "divider"; };
    { name    = L["New Profile"];
      tooltip = L["Create a new profile"] .. ".";
      type    = "button";

      OnClick = function()
        _G.MayronUI:TriggerCommand("profile", "new", nil, function()
          local currentProfile = db:GetCurrentProfile();
          components.chooseProfileDropDown:SetLabel(currentProfile);

          UpdateCurrentProfileText(currentProfile);

          components.chooseProfileDropDown:AddOption(currentProfile, function()
            db:SetProfile(currentProfile);
            components.deleteProfileButton:SetEnabled(currentProfile ~= "Default");
          end);
        end);
      end;
    },
    { name    = L["Export Profile"];
      tooltip = L["Export the current profile into a string that can be imported by other players."];
      type    = "button";
      OnClick = function()
        _G.StaticPopupDialogs["MUI_ExportProfile"] = _G.StaticPopupDialogs["MUI_ExportProfile"] or {
          text = tk.Strings:Join(
            "\n", tk.Strings:SetTextColorByTheme("MayronUI"), L["(CTRL+C to Copy, CTRL+V to Paste)"]
          );
          subText = L["Copy the import string below and give it to other players so they can import your current profile."],
          button1 = L["Close"];
          hasEditBox = true;
          maxLetters = 1024;
          editBoxWidth = 350;
          hideOnEscape = 1;
          timeout = 0;
          whileDead = 1;
          preferredIndex = 3;
        };

        local popup = _G.StaticPopup_Show("MUI_ExportProfile");
        local editbox = _G[ string.format("%sEditBox", popup:GetName()) ];

        local text = db:ExportProfile();
        editbox:SetText(text);
        editbox:SetFocus();
        editbox:HighlightText();
      end;
    },
    { name    = L["Import Profile"];
      tooltip = L["Import a profile from another player from an import string."];
      type    = "button";

      OnClick = function()
        tk:ShowInputPopup(L["Paste an import string into the box below to import a profile."],
        L["Warning: This will completely replace your current profile with the imported profile settings!"], 
        "", nil, "Import", function(_, importStr)
          db:ImportProfile(importStr);
          MayronUI:Print(L["Successfully imported profile settings into your current profile!"]);
          MayronUI:ShowReloadUIPopUp();
        end, nil, nil, true);
      end;
    },
    { type = "title";
      name = L["Dangerous Actions!"];
    };
    { name    = L["Reset Profile"];
      tooltip = L["Reset currently active profile back to default settings."];
      type    = "button";

      OnClick = function()
        local profileName = db:GetCurrentProfile();
        local popupMessage = strformat(
        L["Are you sure you want to reset profile '%s' back to default settings?"], profileName);
        tk:ShowConfirmPopup(popupMessage, nil, nil, ResetProfile, nil, nil, true);
      end
    };
    { name    = L["Delete Profile"];
      tooltip = L["Delete currently active profile (cannot delete the 'Default' profile)."];
      type    = "button";

      OnLoad = function(_, widget)
        local currentProfile = db:GetCurrentProfile();
        if (currentProfile == "Default") then
          widget:SetEnabled(false);
        end

        UpdateCurrentProfileText(currentProfile);
        components.deleteProfileButton = widget;
      end;

      OnClick = function()
        local profileName = db:GetCurrentProfile();
        MayronUI:TriggerCommand("profile", "delete", profileName, function()
          local currentProfile = db:GetCurrentProfile();
          components.chooseProfileDropDown:RemoveOptionByLabel(profileName);
          components.chooseProfileDropDown:SetLabel(currentProfile);
          components.deleteProfileButton:SetEnabled(currentProfile ~= "Default");
        end);
      end
    },
    { type = "divider"; },
    { name    = L["Copy From"]..": ";
      tooltip = L["Copy all settings from one profile to the active profile."];
      type    = "dropdown";
      width = 200;
      GetOptions = GetProfileOptions;

      SetValue = function(self, profileName)
        local dropdown = self.component.dropdown;
        local currentProfile = db:GetCurrentProfile();

        if (currentProfile == profileName) then
          dropdown:SetLabel("Select profile");
          return;
        end

        local popupMessage = strformat(
          L["Are you sure you want to override all profile settings in '%s' for those in profile '%s'?"],
          currentProfile, profileName);

        tk:ShowConfirmPopup(popupMessage, nil, nil, CopyProfile, nil, nil, true, profileName);
        dropdown:SetLabel(L["Select profile"]);
      end;

      GetValue = function()
        return L["Select profile"];
      end;
    },
    { name    = L["Default Profile Behaviour"];
      type    = "title";
      marginBottom = 0;
    },
    { content = L["UNIQUE_CHARACTER_PROFILE"];
      type    = "fontstring";
    },
    { type = "divider" },
    { dbPath      = "global.core.setup.profilePerCharacter";
      name        = L["Profile Per Character"];
      tooltip     = L["If enabled, new characters will be assigned a unique character profile instead of the Default profile."];
      type        = "check";
    }
  }
};

function C_ConfigMenuModule:ShowProfileManager(data)
  if (not data.configPanel or not data.configPanel:IsShown()) then
    self:Show();
  end

  local menuButton = data.configPanel.profilesBtn;

  if (not menuButton.name) then
    menuButton.configTable = configTable;
    menuButton.type = "menu";
    menuButton.name = configTable.name;
  end

  self:OpenMenu(menuButton);
end