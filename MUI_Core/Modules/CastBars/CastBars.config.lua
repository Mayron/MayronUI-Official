-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();
local C_CastBarsModule = namespace.C_CastBarsModule;

local position_TextFields = obj:PopTable();
local sufAnchor_CheckButtons = obj:PopTable();
local width_TextFields = obj:PopTable();
local height_TextFields = obj:PopTable();

local tostring, string, ipairs = _G.tostring, _G.string, _G.ipairs;

local function SetPositionTextFieldsEnabled(enabled, castBarName)
    for _, textfield in ipairs(position_TextFields[castBarName]) do
        textfield:SetEnabled(enabled);
    end

    for _, textfield in ipairs(width_TextFields[castBarName]) do
        textfield:SetEnabled(enabled);
    end

    for _, textfield in ipairs(height_TextFields[castBarName]) do
        textfield:SetEnabled(enabled);
    end
end

local function UnlockCastBar(widget, castBarName)
    local name = castBarName:gsub("^%l", string.upper);
    local castbar = _G[tk.Strings:Concat("MUI_", name, "CastBar")];

    if (not castbar) then -- might be disabled
        return;
    end

    castbar.unlocked = not castbar.unlocked;

    if (not castbar) then
        tk:Print(name..L[" CastBar not enabled."]);
        return
    end

    tk:MakeMovable(castbar, nil, castbar.unlocked);

    if (not castbar.moveIndicator) then
        castbar.moveIndicator = castbar.statusbar:CreateTexture(nil, "OVERLAY");
        castbar.moveIndicator:SetColorTexture(0, 0, 0, 0.6);
        tk:ApplyThemeColor(0.6, castbar.moveIndicator);
        castbar.moveIndicator:SetAllPoints(true);
        castbar.moveLabel = castbar.statusbar:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        castbar.moveLabel:SetText(tk.Strings:Concat("<", name, " CastBar>"));
        castbar.moveLabel:SetPoint("CENTER", castbar.moveIndicator, "CENTER");
    end

    if (castbar.unlocked) then
        widget:SetText(L["Lock"]);
        castbar.moveIndicator:Show();
        castbar.moveLabel:Show();
        castbar:SetAlpha(1);
        castbar.name:SetText(tk.Strings.Empty);
        castbar.duration:SetText(tk.Strings.Empty);
        castbar.statusbar:SetStatusBarColor(0, 0, 0, 0);
    else
        widget:SetText(L["Unlock"]);
        castbar.moveIndicator:Hide();
        castbar.moveLabel:Hide();
        castbar:SetAlpha(0);

        local positions = tk.Tables:GetFramePosition(castbar);

        if (positions) then
            for index, textfield in ipairs(position_TextFields[castBarName]) do
                textfield:SetText(tostring(positions[index]));
            end

            SetPositionTextFieldsEnabled(true, castBarName);

            if (castBarName ~= "Mirror") then
                sufAnchor_CheckButtons[castBarName]:SetChecked(false);
                db:SetPathValue(tk.Strings:Join(".", "profile.castBars", castBarName, "anchorToSUF"), false);
            end

            db:SetPathValue(tk.Strings:Join(".", "profile.castBars", castBarName, "position"), positions);
        end
    end
end

local function CastBarPosition_OnLoad(configTable, container)
    local positionIndex = configTable.dbPath:match("%[(%d)%]$");
    position_TextFields[configTable.castBarName][tonumber(positionIndex)] = container.widget;

    if (db.profile.castBars[configTable.castBarName].anchorToSUF) then
        container.widget:SetEnabled(false);
    end
end

function C_CastBarsModule:GetConfigTable()
    return {
        module = "CastBarsModule",
        dbPath = "profile.castBars",
        children = {
            {   name = L["Enabled"],
                tooltip = "If checked, this module will be enabled.",
                type = "check",
                requiresReload = true, -- TODO: Maybe modules can be global? - move module enable/disable to general menu?
                appendDbPath = "enabled",
            },
            {   name = "Show Food and Drink",
                tooltip = "If checked, the food and drink buff will be displayed as a castbar.",
                type = "check",
                requiresReload = true, -- TODO: Maybe modules can be global? - move module enable/disable to general menu?
                dbPath = "global.castBars.showFoodDrink",
            },
            {
              type = "divider"
            },
            {   name = L["Appearance"],
                type = "title",
                marginTop = 0;
            },
            {   type = "divider"
            },
            {   name = L["Bar Texture"],
                type = "dropdown",
                options = tk.Constants.LSM:List("statusbar"),
                dbPath = "profile.castBars.appearance.texture"
            },
            {   name = L["Border"],
                type = "dropdown",
                options = tk.Constants.LSM:List("border"),
                dbPath = "profile.castBars.appearance.border",
            },
            {   type = "divider"
            },
            {   name = L["Border Size"],
                type = "textfield",
                valueType = "number",
                dbPath = "profile.castBars.appearance.borderSize"
            },
            {   name = L["Frame Inset"],
                type = "textfield",
                valueType = "number",
                tooltip = L["Set the spacing between the status bar and the background."],
                dbPath = "profile.castBars.appearance.inset"
            },
            {   type = "fontstring",
                content = L["Colors"],
                subtype = "header",
            },
            {   name = L["Normal Casting"],
                type = "color",
                width = 160,
                hasOpacity = true;
                dbPath = "profile.castBars.appearance.colors.normal"
            },
            {   name = L["Finished Casting"],
                type = "color",
                hasOpacity = true;
                width = 160,
                dbPath = "profile.castBars.appearance.colors.finished"
            },
            {   name = L["Interrupted"],
                type = "color";
                hasOpacity = true;
                width = 160,
                dbPath = "profile.castBars.appearance.colors.interrupted"
            },
            {   name = L["Latency"],
                type = "color",
                hasOpacity = true;
                width = 160,
                dbPath = "profile.castBars.appearance.colors.latency"
            },
            {   name = L["Border"],
                type = "color",
                hasOpacity = true;
                width = 160,
                dbPath = "profile.castBars.appearance.colors.border"
            },
            {   name = "Background",
                type = "color",
                hasOpacity = true;
                width = 160,
                dbPath = "profile.castBars.appearance.colors.background"
            },
            {   name = L["Individual Cast Bar Options"],
                type = "title",
            },
            {   type = "loop",
                args = { "Player", "Target", "Focus", "Mirror" },
                func = function(_, name)
                  if (tk:IsClassic() and name == "Focus") then return end
                  local config =
                  {
                    name = L[name],
                    type = "submenu",
                    OnLoad = function()
                      position_TextFields[name] = obj:PopTable();
                      width_TextFields[name] = obj:PopTable();
                      height_TextFields[name] = obj:PopTable();
                    end,
                    module = "CastBars",
                    children = {
                      {
                        name = L["Enable Bar"],
                        type = "check",
                        requiresReload = true; -- TODO: Can this be reverted?
                        dbPath = tk.Strings:Concat("profile.castBars.", name, ".enabled");
                      },
                      {
                        name = L["Show Icon"],
                        type = "check",
                        enabled = name ~= "mirror",
                        dbPath = tk.Strings:Concat("profile.castBars.", name, ".showIcon")
                      },
                      {
                        name = L["Show Latency Bar"],
                        type = "check",
                        enabled = name == "Player",
                        dbPath = tk.Strings:Concat("profile.castBars.", name, ".showLatency");

                        GetValue = function(self, value)
                          if (self.enabled) then
                            return value;
                          else
                            return false;
                          end
                        end
                      },
                      {
                        name = L["Anchor to SUF Portrait Bar"],
                        type = "check",
                        OnLoad = function(_, container)
                          sufAnchor_CheckButtons[name] = container.btn;
                        end,
                        enabled = name ~= "mirror",
                        tooltip = string.format(
                          L["If enabled the Cast Bar will be fixed to the %s Unit Frame's Portrait Bar (if it exists)."], name),
                        dbPath = tk.Strings:Concat("profile.castBars.", name, ".anchorToSUF"),

                        SetValue = function(path, newValue, _, container)
                          local unitframe = _G["SUFUnit"..name:lower()];

                          if (newValue and not (unitframe and unitframe.portrait)) then
                            container.btn:SetChecked(false);
                            tk:Print(string.format(L["The %s Unit Frames's Portrait Bar needs to be enabled to use this feature."], name));
                            return;
                          end

                          db:SetPathValue(path, newValue);
                          SetPositionTextFieldsEnabled(not newValue, name);
                        end
                      },
                      {
                        type = "divider",
                        enabled = name ~= "mirror",
                      },
                      {
                        name = L["Unlock"],
                        type = "button",
                        data = { name },
                        OnClick = UnlockCastBar
                      },
                      {
                        type = "divider"
                      },
                      {
                        name = L["Width"],
                        tooltip = L["Only takes effect if the Cast Bar is not anchored to a SUF Portrait Bar."],
                        type = "textfield",
                        valueType = "number",
                        OnLoad = function(_, container)
                          if (db.profile.castBars[name].anchorToSUF) then
                            container.widget:SetEnabled(false);
                          end

                          table.insert(width_TextFields[name], container.widget);
                        end,
                        dbPath = tk.Strings:Concat("profile.castBars.", name, ".width")
                      },
                      {
                        name = L["Height"],
                        tooltip = L["Only takes effect if the Cast Bar is not anchored to a SUF Portrait Bar."],
                        type = "textfield",
                        valueType = "number",
                        OnLoad = function(_, container)
                          if (db.profile.castBars[name].anchorToSUF) then
                            container.widget:SetEnabled(false);
                          end
                          table.insert(height_TextFields[name], container.widget);
                        end,
                        dbPath = tk.Strings:Concat("profile.castBars.", name, ".height")
                      },
                      {
                        type = "divider",
                      },
                      {
                        name = L["Frame Strata"],
                        type = "dropdown",
                        options = tk.Constants.ORDERED_FRAME_STRATAS,
                        dbPath = tk.Strings:Concat("profile.castBars.", name, ".frameStrata")
                      },
                      {
                        name = L["Frame Level"],
                        type = "slider",
                        min = 1,
                        max = 50,
                        step = 1,
                        dbPath = tk.Strings:Concat("profile.castBars.", name, ".frameLevel")
                      },
                      {
                        name = L["Manual Positioning"],
                        type = "title",
                      },
                      {
                        type = "fontstring",
                        content = L["Manual positioning only works if the CastBar is not anchored to a SUF Portrait Bar."],
                      },
                      {
                        type = "loop";
                        args = { L["Point"], L["Relative Frame"], L["Relative Point"], L["X-Offset"], L["Y-Offset"] };
                        func = function(index, arg)
                          return {
                            name = arg;
                            type = "textfield";
                            valueType = "string";
                            dbPath = string.format("profile.castBars.%s.position[%d]", name, index);
                            castBarName = name;
                            pointID = index;
                            OnLoad = CastBarPosition_OnLoad,
                          };
                        end
                      };
                    }
                  };

                  if (name == "Mirror") then
                    config.children[2] = nil;
                    config.children[3] = nil;
                    config.children[4] = nil;
                  end

                  return config;
                end,
            }
        }
    };
end