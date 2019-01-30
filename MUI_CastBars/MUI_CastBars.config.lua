-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db, _, _, obj, L = MayronUI:GetCoreComponents();
local C_CastBarsModule = namespace.C_CastBarsModule;

local Map = obj:PopTable();
Map.positionTextFields = obj:PopTable();
Map.sufAnchorCheckButtons = obj:PopTable();
Map.widthTextFields = obj:PopTable();
Map.heightTextFields = obj:PopTable();

local function UnlockCastBar(button, data)
    local name = data.castbarName:gsub("^%l", tk.string.upper);
    local castbar = _G[tk.Strings:Concat("MUI_", name, "CastBar")];

    castbar.unlocked = not castbar.unlocked;

    if (not castbar) then
        tk:Print(name..L[" CastBar not enabled."]);
        return
    end

    tk:MakeMovable(castbar, nil, castbar.unlocked);

    if (not data.hooked) then
        data.hooked = true;
        castbar:HookScript("OnDragStart", function()
            db:SetPathValue("profile.castbars."..data.castbarName..".anchorToSUF", false);
            Map.sufAnchorCheckButtons[data.castbarName]:SetChecked(false);

            for _, textfield in tk.pairs(Map.positionTextFields[data.castbarName]) do
                textfield:SetEnabled(true);
            end

            for _, textfield in tk.ipairs(Map.widthTextFields[data.castbarName]) do
                textfield:SetEnabled(true);
            end

            for _, textfield in tk.ipairs(Map.heightTextFields[data.castbarName]) do
                textfield:SetEnabled(true);
            end
        end);
    end

    if (not castbar.moveIndicator) then
        castbar.moveIndicator = castbar.statusbar:CreateTexture(nil, "OVERLAY");
        castbar.moveIndicator:SetColorTexture(0, 0, 0, 0.6);
        tk:SetThemeColor(0.6, castbar.moveIndicator);
        castbar.moveIndicator:SetAllPoints(true);
        castbar.moveLabel = castbar.statusbar:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        castbar.moveLabel:SetText(tk.Strings:Concat("<", name, " CastBar>"));
        castbar.moveLabel:SetPoint("CENTER", castbar.moveIndicator, "CENTER");
    end

    if (castbar.unlocked) then
        button:SetText(L["Lock"]);
        castbar.moveIndicator:Show();
        castbar.moveLabel:Show();
        castbar:SetAlpha(1);
        castbar.name:SetText("");
        castbar.duration:SetText("");
        castbar.statusbar:SetStatusBarColor(0, 0, 0, 0);
    else
        button:SetText(L["Unlock"]);
        castbar.moveIndicator:Hide();
        castbar.moveLabel:Hide();
        castbar:SetAlpha(0);

        local positions = tk:SavePosition(castbar, "profile.castbars."..data.castbarName..".position");

        if (positions) then
            for key, textfield in tk.pairs(Map.positionTextFields[data.castbarName]) do
                textfield:SetText(positions[key]);
            end
        end
    end
end

function C_CastBarsModule:GetConfigTable()
    return {
        name = "Cast Bars",
        module = "CastBars",
        children = {
            {   name = L["Appearance"],
                type = "title",
                marginTop = 0;
            },
            {   type = "divider"
            },
            {   name = L["Bar Texture"],
                type = "dropdown",
                options = tk.Constants.LSM:List("statusbar"),
                dbPath = "profile.castbars.appearance.texture"
            },
            {   name = L["Border"],
                type = "dropdown",
                options = tk.Constants.LSM:List("border"),
                dbPath = "profile.castbars.appearance.border",
            },
            {   type = "divider"
            },
            {   name = L["Border Size"],
                type = "textfield",
                valueType = "number",
                dbPath = "profile.castbars.appearance.borderSize"
            },
            {   name = L["Frame Inset"],
                type = "textfield",
                valueType = "number",
                tooltip = "Set the spacing between the status bar and the backdrop.",
                dbPath = "profile.castbars.appearance.inset"
            },
            {   type = "fontstring",
                content = L["Colors"],
                subtype = "header",
            },
            {   name = L["Normal Casting"],
                type = "color",
                width = 160,
                dbPath = "profile.castbars.appearance.colors.normal"
            },
            {   name = L["Finished Casting"],
                type = "color",
                width = 160,
                dbPath = "profile.castbars.appearance.colors.finished"
            },
            {   name = L["Interrupted"],
                type = "color",
                width = 160,
                dbPath = "profile.castbars.appearance.colors.interrupted"
            },
            {   name = L["Latency"],
                type = "color",
                width = 160,
                dbPath = "profile.castbars.appearance.colors.latency"
            },
            {   name = L["Border"],
                type = "color",
                width = 160,
                dbPath = "profile.castbars.appearance.colors.border"
            },
            {   name = L["Backdrop"],
                type = "color",
                width = 160,
                dbPath = "profile.castbars.appearance.colors.backdrop"
            },
            {   name = L["Individual Cast Bar Options"],
                type = "title",
            },
            {   type = "loop",
                args = {
                    "player", "target", "focus", "mirror"
                },
                func = function(_, name)
                    local castBarName = L[name:gsub("^%l", tk.string.upper)];
                    local castBar = _G[string.format("MUI_%sCastBar", castBarName)];

                    return
                    {
                        name = castBarName,
                        type = "submenu",
                        OnLoad = function()
                            Map.positionTextFields[name] = obj:PopTable();
                            Map.widthTextFields[name] = obj:PopTable();
                            Map.heightTextFields[name] = obj:PopTable();
                        end,
                        module = "CastBars",
                        children = {
                            {   name = L["Enable Bar"],
                                type = "check",
                                dbPath = tk.Strings:Concat("profile.castbars.", name, ".enabled"),
                            },
                            {   name = L["Show Icon"],
                                type = "check",
                                enabled = name ~= "mirror",
                                dbPath = tk.Strings:Concat("profile.castbars.", name, ".showIcon")
                            },
                            {   name = L["Show Latency Bar"],
                                type = "check",
                                enabled = name == "player",
                                dbPath = tk.Strings:Concat("profile.castbars.", name, ".showLatency");

                                GetValue = function(self, value)
                                    if (self.enabled) then
                                        return value;
                                    else
                                        return false;
                                    end
                                end
                            },
                            {   name = L["Anchor to SUF Portrait Bar"],
                                type = "check",
                                OnLoad = function(_, container)
                                    Map.sufAnchorCheckButtons[name] = container.btn;
                                end,
                                enabled = name ~= "mirror",
                                tooltip = tk.string.format(
                                    L["If enabled the Cast Bar will be fixed to the %s Unit Frame's Portrait Bar (if it exists)."], castBarName),
                                dbPath = tk.Strings:Concat("profile.castbars.", name, ".anchorToSUF"),
                                SetValue = function(path, _, new, button)
                                    local unitframe = _G["SUFUnit"..name];
                                    if (new and not (unitframe and unitframe.portrait)) then
                                        button:SetChecked(false);
                                        tk:Print(tk.string.format(L["The %s Unit Frames's Portrait Bar needs to be enabled to use this feature."], castBarName));
                                        return;
                                    end
                                    db:SetPathValue(path, new);
                                    for _, textfield in tk.pairs(Map.positionTextFields[name]) do
                                        textfield:SetEnabled(not new);
                                    end
                                    for _, textfield in tk.ipairs(Map.widthTextFields[name]) do
                                        textfield:SetEnabled(not new);
                                    end
                                    for _, textfield in tk.ipairs(Map.heightTextFields[name]) do
                                        textfield:SetEnabled(not new);
                                    end
                                end
                            },
                            {   type = "divider",
                                enabled = name ~= "mirror",
                            },
                            {   name = L["Unlock"],
                                type = "button",
                                castbarName = name,
                                OnClick = UnlockCastBar
                            },
                            {   type = "divider"
                            },
                            {   name = L["Width"],
                                tooltip = L["Only takes effect if the Cast Bar is not anchored to a SUF Portrait Bar."],
                                type = "textfield",
                                valueType = "number",
                                OnLoad = function(_, container)
                                    if (db.profile.castbars[name].anchorToSUF) then
                                        container.widget.field:SetEnabled(false);
                                    end
                                    table.insert(Map.widthTextFields[name], container.widget.field);
                                end,
                                dbPath = tk.Strings:Concat("profile.castbars.", name, ".width")
                            },
                            {   name = L["Height"],
                                tooltip = L["Only takes effect if the Cast Bar is not anchored to a SUF Portrait Bar."],
                                type = "textfield",
                                valueType = "number",
                                OnLoad = function(_, container)
                                    if (db.profile.castbars[name].anchorToSUF) then
                                        container.widget.field:SetEnabled(false);
                                    end
                                    table.insert(Map.heightTextFields[name], container.widget.field);
                                end,
                                dbPath = tk.Strings:Concat("profile.castbars.", name, ".height")
                            },
                            {   type = "divider",
                            },
                            {   name = L["Frame Strata"],
                                type = "dropdown",
                                options = tk.Constants.ORDERED_FRAME_STRATAS,
                                dbPath = tk.Strings:Concat("profile.castbars.", name, ".frameStrata")
                            },
                            {   name = L["Frame Level"],
                                type = "slider",
                                min = 1,
                                max = 50,
                                step = 1,
                                dbPath = tk.Strings:Concat("profile.castbars.", name, ".frameLevel")
                            },
                            {   name = L["Manual Positioning"],
                                type = "title",
                            },
                            {   type = "fontstring",
                                content = L["Manual positioning only works if the CastBar is not anchored to a SUF Portrait Bar."],
                            },
                            {   name = L["Point"],
                                type = "textfield",
                                valueType = "string",
                                dbPath = tk.Strings:Concat("profile.castbars.", name, ".position.point"),
                                OnLoad = function(_, container)
                                    if (db.profile.castbars[name].anchorToSUF) then
                                        container.widget.field:SetEnabled(false);
                                    end
                                    Map.positionTextFields[name].point = container.widget.field;
                                end,
                                GetValue = function()
                                    local value = db:ParsePathValue(tk.Strings:Concat("profile.castbars.", name, ".position"));

                                    if (value) then
                                        return value.point;
                                    else
                                        local castbar = tk._G[string.format("MUI_%sCastBar", castBarName)];

                                        if (not castbar) then
                                            return "disabled";
                                        end

                                        return (tk.select(1, castbar:GetPoint()));
                                    end
                                end
                            },
                            {   name = L["Relative Frame"],
                                type = "textfield",
                                valueType = "string",
                                dbPath = tk.Strings:Concat("profile.castbars.", name, ".position.relativeFrame"),
                                OnLoad = function(_, container)
                                    if (db.profile.castbars[name].anchorToSUF) then
                                        container.widget.field:SetEnabled(false);
                                    end

                                    Map.positionTextFields[name].relativeFrame = container.widget.field;
                                end,
                                GetValue = function()
                                    local value = db:ParsePathValue(tk.Strings:Concat("profile.castbars.", name, ".position"));

                                    if (value) then
                                        return value.relativeFrame;

                                    else
                                        if (not castBar) then
                                            return "disabled";
                                        end

                                        return (tk.select(2, castBar:GetPoint())):GetName();
                                    end
                                end
                            },
                            {   name = L["Relative Point"],
                                type = "textfield",
                                valueType = "string",
                                dbPath = tk.Strings:Concat("profile.castbars.", name, ".position.relativePoint"),
                                OnLoad = function(_, container)
                                    if (db.profile.castbars[name].anchorToSUF) then
                                        container.widget.field:SetEnabled(false);
                                    end
                                    Map.positionTextFields[name].relativePoint = container.widget.field;
                                end,
                                GetValue = function()
                                    local value = db:ParsePathValue(tk.Strings:Concat("profile.castbars.", name, ".position"));

                                    if (value) then
                                        return value.relativePoint;
                                    else

                                        if (not castBar) then
                                            return "disabled";
                                        end

                                        return (tk.select(3, castBar:GetPoint()));
                                    end
                                end
                            },
                            {   type = "divider"
                            },
                            {   name = L["X-Offset"],
                                type = "textfield",
                                valueType = "number",
                                dbPath = tk.Strings:Concat("profile.castbars.", name, ".position.x"),
                                OnLoad = function(_, container)
                                    if (db.profile.castbars[name].anchorToSUF) then
                                        container.widget.field:SetEnabled(false);
                                    end

                                    Map.positionTextFields[name].x = container.widget.field;
                                end,
                                GetValue = function()
                                    local value = db:ParsePathValue(tk.Strings:Concat("profile.castbars.", name, ".position"));

                                    if (value) then
                                        return value.x;
                                    else
                                        if (not castBar) then
                                            return "disabled";
                                        end

                                        return (tk.select(4, castBar:GetPoint()));
                                    end
                                end
                            },
                            {   name = L["Y-Offset"],
                                type = "textfield",
                                valueType = "number",
                                dbPath = tk.Strings:Concat("profile.castbars.", name, ".position.y"),
                                OnLoad = function(_, container)
                                    if (db.profile.castbars[name].anchorToSUF) then
                                        container.widget.field:SetEnabled(false);
                                    end
                                    Map.positionTextFields[name].y = container.widget.field;
                                end,
                                GetValue = function()
                                    local value = db:ParsePathValue(tk.Strings:Concat("profile.castbars.", name, ".position"));

                                    if (value) then
                                        return value.y;
                                    else
                                        if (not castBar) then
                                            return "disabled"; end
                                        return (tk.select(5, castBar:GetPoint()));
                                    end
                                end
                            },
                        }
                    }
                end,
            }
        }
    };
end