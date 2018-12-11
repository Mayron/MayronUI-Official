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

local configTable = {
    name = "MUI Profile Manager",
    id = 1,
    type = "category",
    children =
    {
        {
            type = "frame",
            children =
            {
                {
                    name = "Choose Profile:",
                    type = "dropdown",
                    tooltip = "Choose the currently active profile.",
                    GetOptions = function()
                        return db:GetProfiles();
                    end,
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
            type = "divider"
        },
        {
            name = "Restore a Profile:",
            type = "dropdown",
            tooltip = "Removed profiles can be restored up until the UI is reloaded, then they are lost forever.",
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