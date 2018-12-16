--luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local C_ConfigModule = namespace.C_ConfigModule;
-- local configModule = MayronUI:ImportModule("Config");

local function ValidateNewProfileName()
    return false;
end

local function ValidateRemoveProfile(_, text)
    return text == "DELETE";
end

local function CreateNewProfile(_, profileName)
    db:SetProfile(profileName);
end

local function ResetProfile(_, profileName)
    db:ResetProfile();
    tk:Print("Profile ", profileName, "has been reset.");
end

local function RemoveProfile(_, profileName)
    db:RemoveProfile(profileName);
    tk:Print("Profile ", profileName, "has been deleted.");
end

local function RestoreProfile(_, profileName)
    db:RestoreProfile(profileName);
    tk:Print("Profile ", profileName, "has been deleted.");
end

-- Get all profiles and convert them to a list of options for use with dropdown menus
local function GetProfileOptions()
    local profiles = db:GetProfiles();
    local options = obj:PopWrapper();

    -- key and value should both be the profile name:
    for _, profileName in ipairs(profiles) do
        options[profileName] = profileName;
    end

    return options;
end

-- TODO: does not use a module so cannot call OnConfigUpdate (will this cause an error?)
local configTable = {
    id      = 1;
    name    = "MUI Profile Manager";
    type    = "category";
    children =
    {
        {
            content = "You can manage character profiles here.\n\nBy default, each character has its own unique profile.";
            type    = "fontstring";
        },
        {
            type = "fontstring";

            GetContent = function()
                return tk.Strings:JoinWithSpace(
                    "Current profile:",
                    tk.Strings:SetTextColor(db:GetCurrentProfile(), "GOLD"));
            end,
        },
        {
            name    = "Reset Profile";
            tooltip = "Reset currently active profile back to default settings.";
            type    = "button";

            OnClick = function()
                local profileName = db:GetCurrentProfile();
                local popupMessage = string.format(
                    "Are you sure you want to reset profile '%s' back to default settings?", profileName);

                tk:ShowConfirmPopup(popupMessage, nil, nil, ResetProfile, nil, nil, true);
            end,
        };
        {
            name    = "Delete Profile";
            tooltip = "Delete currently active profile.";
            type    = "button";

            OnClick = function()
                local profileName = db:GetCurrentProfile();
                local popupMessage = string.format("Are you sure you want to delete profile '%s'?", profileName);
                local subMessage = "Please type 'DELETE' to confirm:";

                tk:ShowInputPopup(popupMessage, subMessage, nil, ValidateRemoveProfile, nil, RemoveProfile, nil, nil, true);
            end,
        },
        {
            type = "frame",
            height = 65;
            children =
            {
                {
                    GetOptions        = GetProfileOptions;
                    name              = "Choose Profile:";
                    requiresRestart   = true; -- TODO: this will eventually be replaced with OnProfileChange
                    tooltip           = "Choose the currently active profile.";
                    type              = "dropdown";

                    SetValue = function()

                    end;

                    GetValue = function()
                        return db:GetCurrentProfile();
                    end;
                },
                {
                    content       = " or ";
                    fixedWidth    = true;
                    height        = 34;
                    justify       = "CENTER";
                    type          = "fontstring";
                },
                {
                    name    = "New Profile";
                    tooltip = "Create a new profile.";
                    type    = "button";
                    width   = 100;

                    OnClick = function()
                        local popupMessage = "Enter a new unique profile name:";
                        tk:ShowInputPopup(popupMessage, nil, nil, ValidateNewProfileName, nil, CreateNewProfile);
                    end;
                },
            }
        },
        {
            type = "divider"
        },
        {
            type              = "dropdown";
            name              = "Restore a Profile:";
            tooltip           = tk.Strings:Join("\n\n", "Profiles that have been removed are stored in the bin until the UI is reloaded.",
                                    "Once the UI reloads, the removed profiles are permanently deleted.");
            disabledTooltip   = "No profiles found in the profile bin (not able to restore any profiles).";

            GetOptions = function()
                return db:GetProfilesInBin();
            end;

            GetValue = function()
                return "Select a profile";
            end;

            SetValue = function(_, profileName)
                local popupMessage = string.format("Are you sure you want to restore profile '%s'?", profileName);

                tk:ShowConfirmPopup(popupMessage, nil, nil, RestoreProfile, nil, nil, true);
            end;
        },
        {
            name    = "Default Profile Behaviour";
            type    = "title";
        },
        {
            content = tk.Strings:JoinWithSpace("By default, each new character will be automatically assigned a unique character",
                                        "profile instead of a single default profile.\n\nProfiles are automatically assigned",
                                        "only after installing the UI on a new character.");
            type    = "fontstring";
        },
        {
            type = "divider"
        },
        {
            dbProfile   = "global.core.setup.profilePerCharacter";
            name        = "Profile Per Character";
            tooltip     = "If enabled, new characters will be assigned a unique character profile instead of a single default profile.";
            type        = "check";
        },
        {
            GetOptions    = GetProfileOptions;
            name          = "Default Profile:";
            tooltip       = "Choose the default profile to assign to new character's during installation.";
            type          = "dropdown";

            GetValue = function()
                -- return db:GetCurrentProfile();
            end;
        },
    }
}

function C_ConfigModule:ShowProfileManager(data)
    if (not data.window or not data.window:IsShown()) then
        self:Show();
    end

    local menuButton = data.window.profilesBtn;

    if (not menuButton.name) then
        menuButton.ConfigTable = configTable;
        menuButton.type = "submenu";
        menuButton.name = configTable.name;
    end

    self:OpenMenu(menuButton);
end