--luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db = MayronUI:GetCoreComponents();

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
    local options = tk.Tables:PopWrapper();

    -- key and value should both be the profile name:
    for _, profileName in ipairs(profiles) do
        options[profileName] = profileName;
    end

    return options;
end

-- TODO: does not use a module so cannot call OnConfigUpdate (will this cause an error?)
local configTable = {
    name = "MUI Profile Manager",
    id = 1,
    type = "category",
    children =
    {
        {
            type = "fontstring",
            content = "You can manage character profiles here.\n\nBy default, each character has its own unique profile."
        },
        {
            type = "divider"
        },
        {
            type = "fontstring",
            GetContent = function()
                return tk.Strings:JoinWithSpace(
                    "Current profile:",
                    tk.Strings:SetColor(db:GetCurrentProfile(), "gold")
                )
            end,
        },
        {
            type = "divider"
        },
        {
            name = "Reset Profile",
            type = "button",
            tooltip = "Reset currently active profile back to default settings.",
            OnClick = function()
                local profileName = db:GetCurrentProfile();
                local popupMessage = string.format(
                    "Are you sure you want to reset profile '%s' back to default settings?", profileName);

                tk:ShowConfirmPopup(popupMessage, nil, nil, ResetProfile, nil, nil, true);
            end,
        },
        {
            name = "Delete Profile",
            type = "button",
            tooltip = "Delete currently active profile.",
            OnClick = function()
                local profileName = db:GetCurrentProfile();
                local popupMessage = string.format("Are you sure you want to delete profile '%s'?", profileName);
                local subMessage = "Please type 'DELETE' to confirm:";

                tk:ShowInputPopup(popupMessage, subMessage, nil, ValidateRemoveProfile, nil, RemoveProfile, nil, nil, true);
            end,
        },
        {
            type = "frame",
            children =
            {
                {
                    name = "Choose Profile:",
                    type = "dropdown",
                    tooltip = "Choose the currently active profile.",
                    GetOptions = GetProfileOptions,
                    requiresRestart = true, -- TODO: this will eventually be replaced with OnProfileChange
                    SetValue = function()

                    end,
                    GetValue = function()
                        return db:GetCurrentProfile();
                    end
                },
                {
                    type = "fontstring",
                    justify = "CENTER",
                    content = " or "
                },
                {
                    name = "New Profile",
                    type = "button",
                    width = 100,
                    tooltip = "Create a new profile.",
                    OnClick = function()
                        local popupMessage = "Enter a new unique profile name:";
                        tk:ShowInputPopup(popupMessage, nil, nil, ValidateNewProfileName, nil, CreateNewProfile);
                    end,
                },
            }
        },
        {
            type = "divider"
        },
        {
            name = "Restore a Profile:",
            type = "dropdown",
            tooltip = "Profiles that have been removed are stored in the bin until the UI is reloaded.\n\nOnce the UI reloads, the removed profiles are permanently deleted.",
            GetOptions = function()
                return db:GetProfilesInBin();
            end,
            SetValue = function(_, profileName)
                local popupMessage = string.format("Are you sure you want to restore profile '%s'?", profileName);

                tk:ShowConfirmPopup(popupMessage, nil, nil, RestoreProfile, nil, nil, true);
            end,
            GetValue = function()
                return "Select a profile";
            end
        },
        {
            type = "title",
            name = "Default Profile Behaviour"
        },
        {
            type = "frame",
            children =
            {
                {
                    type = "fontstring",
                    content = "By default, each new character will be automatically assigned a unique character profile instead of a single default profile.\n\nPofiles are automatically assigned only after installing the UI on a new character.",
                },
                {
                    type = "checkbox",
                    name = "Profile Per Character",
                    tooltip = "If enabled, new characters will be assigned a unique character profile instead of a single default profile.",
                    dbProfile = "global.core.setup.profilePerCharacter"
                },
                {
                    type = "fontstring",
                    justify = "CENTER",
                    content = " or "
                },
                {
                    name = "Choose Profile:",
                    type = "dropdown",
                    tooltip = "Choose the currently active profile.",
                    GetOptions = GetProfileOptions,
                    GetValue = function()
                        -- return db:GetCurrentProfile();
                    end
                },
            }
        },
    }
}

function C_ConfigModule:ShowProfileManager(data)
    local menuButton = data.window.profilesBtn;

    if (not menuButton.name) then
        menuButton.ConfigTable = configTable;
        menuButton.type = "submenu";
        menuButton.name = configTable.name;
    end

    self:OpenMenu(menuButton);
end