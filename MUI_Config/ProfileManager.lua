--luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local C_ConfigModule = namespace.C_ConfigModule;
local widgets = {};

local function ResetProfile(_, profileName)
    db:ResetProfile();
    tk:Print("Profile", tk.Strings:SetTextColorByKey(profileName, "gold"), "has been reset.");
end

local function CopyProfile(self, profileName)
    local currentProfile = db:GetCurrentProfile();
    db:CopyProfile(currentProfile, profileName);

    local copyProfileMessage = L["Profile %s has been copied into current profile %s."];

    copyProfileMessage = copyProfileMessage:format(
        tk.Strings:SetTextColorByKey(profileName, "gold"),
        tk.Strings:SetTextColorByKey(currentProfile, "gold"));

    tk:Print(copyProfileMessage);

    tk:HookFunc(self, "Hide", function()
        MayronUI:ShowReloadUIPopUp();
        return true; -- unhook
    end);
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
    id      = 1;
    name    = L["MUI Profile Manager"];
    type    = "category";
    children =
    {
        {
            content = L["You can manage character profiles here.\n\nBy default, each character has its own unique profile."];
            type    = "fontstring";
        },
        {
            type = "fontstring";

            GetContent = function()
                return tk.Strings:Join("",
                    L["Current profile"], ": ",
                    tk.Strings:SetTextColorByKey(db:GetCurrentProfile(), "GOLD"));
            end,
        },
        {
            name    = L["Reset Profile"];
            tooltip = L["Reset currently active profile back to default settings."];
            type    = "button";

            OnClick = function()
                local profileName = db:GetCurrentProfile();
                local popupMessage = string.format(
                    L["Are you sure you want to reset profile '%s' back to default settings?"], profileName);
                tk:ShowConfirmPopup(popupMessage, nil, ResetProfile, nil, nil, nil, true, profileName);
            end,
        };
        {
            name    = L["Delete Profile"];
            tooltip = L["Delete currently active profile (cannot delete the 'Default' profile)."];
            type    = "button";

            OnLoad = function(_, widget)
                if (db:GetCurrentProfile() == "Default") then
                    widget:SetEnabled(false);
                end

                widgets.deleteProfileButton = widget;
            end;

            OnClick = function()
                local profileName = db:GetCurrentProfile();
                MayronUI:TriggerCommand("profile", "delete", profileName, function()
                    local currentProfile = db:GetCurrentProfile();
                    widgets.chooseProfileDropDown:RemoveOptionByLabel(profileName);
                    widgets.chooseProfileDropDown:SetLabel(currentProfile);
                    widgets.deleteProfileButton:SetEnabled(currentProfile ~= "Default");
                end);
            end,
        },
        {
            type = "divider";
        },
        {
            name    = L["Copy From"]..": ";
            tooltip = L["Copy all settings from one profile to the active profile."];
            type    = "dropdown";
            width = 200;
            GetOptions = GetProfileOptions;

            SetValue = function(_, profileName, _, container)
                if (db:GetCurrentProfile() == profileName) then
                    container.widget.dropdown:SetLabel("Select profile");
                    return;
                end

                local popupMessage = string.format(
                    L["Are you sure you want to overide all profile settings in '%s' for those in profile '%s'?"],
                    db:GetCurrentProfile(), profileName);

                tk:ShowConfirmPopup(popupMessage, nil, CopyProfile, nil, nil, nil, true, profileName);
                container.widget.dropdown:SetLabel(L["Select profile"]);
            end;

            GetValue = function()
                return L["Select profile"];
            end;
        },
        {
            type = "frame",
            height = 65;
            children =
            {
                {
                    GetOptions        = GetProfileOptions;
                    name              = L["Choose Profile"]..": ";
                    tooltip           = L["Choose the currently active profile."];
                    type              = "dropdown";
                    width             = 200;

                    OnLoad = function(_, container)
                        widgets.chooseProfileDropDown = container.widget.dropdown;
                    end;

                    SetValue = function(_, newValue)
                        if (db:GetCurrentProfile() == newValue) then
                            return;
                        end

                        db:SetProfile(newValue);
                        widgets.deleteProfileButton:SetEnabled(newValue ~= "Default");
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
                    name    = L["New Profile"];
                    tooltip = L["Create a new profile."];
                    type    = "button";
                    width   = 100;

                    OnClick = function()
                        MayronUI:TriggerCommand("profile", "new", nil, function()
                            local currentProfile = db:GetCurrentProfile();
                            widgets.chooseProfileDropDown:SetLabel(currentProfile);
                            widgets.chooseProfileDropDown:AddOption(currentProfile, function()
                                db:SetProfile(currentProfile);
                                widgets.deleteProfileButton:SetEnabled(currentProfile ~= "Default");
                            end);
                        end);
                    end;
                },
            }
        },
        {
            name    = L["Default Profile Behaviour"];
            type    = "title";
            marginBottom = 0;
        },
        {
            content = L["By default, each new character will be automatically assigned a unique character profile instead of a single default profile.\n\nProfiles are automatically assigned only after installing the UI on a new character."];
            type    = "fontstring";
        },
        {
            type = "divider"
        },
        {
            dbPath      = "global.core.setup.profilePerCharacter";
            name        = L["Profile Per Character"];
            tooltip     = L["If enabled, new characters will be assigned a unique character profile instead of the Default profile."];
            type        = "check";
        }
    }
}

function C_ConfigModule:ShowProfileManager(data)
    if (not data.window or not data.window:IsShown()) then
        self:Show();
    end

    local menuButton = data.window.profilesBtn;

    if (not menuButton.name) then
        menuButton.configTable = configTable;
        menuButton.type = "submenu";
        menuButton.name = configTable.name;
    end

    self:OpenMenu(menuButton);
end