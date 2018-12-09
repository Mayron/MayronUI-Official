-- luacheck: ignore MayronUI self 143 631
local tk, db, _, _, _, L = MayronUI:GetCoreComponents();
local castBarsModule = MayronUI:ImportModule("CastBars");

local Map = {};
Map.position_textfields = {};
Map.suf_anchor_checkbuttons = {};
Map.width_textfields = {};
Map.height_textfields = {};

local function UnlockCastBar(button, data)
    local name = data.castbar_name:gsub("^%l", tk.string.upper);
    local castbar = tk._G[tk.Strings:Concat("MUI_", name, "CastBar")];

    castbar.unlocked = not castbar.unlocked;

    if (not castbar) then
        tk:Print(name..L[" CastBar not enabled."]);
        return
    end

    tk:MakeMovable(castbar, nil, castbar.unlocked);

    if (not data.hooked) then
        data.hooked = true;
        castbar:HookScript("OnDragStart", function()
            db:SetPathValue("profile.castbars."..data.castbar_name..".anchor_to_SUF", false);
            Map.suf_anchor_checkbuttons[data.castbar_name]:SetChecked(false);

            for _, textfield in tk.pairs(Map.position_textfields[data.castbar_name]) do
                textfield:SetEnabled(true);
            end

            for _, textfield in tk.ipairs(Map.width_textfields[data.castbar_name]) do
                textfield:SetEnabled(true);
            end

            for _, textfield in tk.ipairs(Map.height_textfields[data.castbar_name]) do
                textfield:SetEnabled(true);
            end
        end);
    end

    if (not castbar.move_indicator) then
        castbar.move_indicator = castbar.statusbar:CreateTexture(nil, "OVERLAY");
        castbar.move_indicator:SetColorTexture(0, 0, 0, 0.6);
        tk:SetThemeColor(0.6, castbar.move_indicator);
        castbar.move_indicator:SetAllPoints(true);
        castbar.move_label = castbar.statusbar:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
        castbar.move_label:SetText(tk.Strings:Concat("<", name, " CastBar>"));
        castbar.move_label:SetPoint("CENTER", castbar.move_indicator, "CENTER");
    end

    if (castbar.unlocked) then
        button:SetText(L["Lock"]);
        castbar.move_indicator:Show();
        castbar.move_label:Show();
        castbar:SetAlpha(1);
        castbar.name:SetText("");
        castbar.duration:SetText("");
        castbar.statusbar:SetStatusBarColor(0, 0, 0, 0);
    else
        button:SetText(L["Unlock"]);
        castbar.move_indicator:Hide();
        castbar.move_label:Hide();
        castbar:SetAlpha(0);

        local positions = tk:SavePosition(castbar, "profile.castbars."..data.castbar_name..".position");

        if (positions) then
            for key, textfield in tk.pairs(Map.position_textfields[data.castbar_name]) do
                textfield:SetText(positions[key]);
            end
        end
    end
end

castBarsModule.ConfigData =
{
    name = "Cast Bars",
    type = "category",
    module = "CastBars",
    children = {
        {   name = L["Appearance"],
            type = "title",
            padding_top = 0,
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
            dbPath = "profile.castbars.appearance.border_size"
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
                local castBar = tk._G[string.format("MUI_%sCastBar", castBarName)];

                return
                {
                    name = castBarName,
                    type = "submenu",
                    OnLoad = function()
                        Map.position_textfields[name] = {};
                        Map.width_textfields[name] = {};
                        Map.height_textfields[name] = {};
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
                            dbPath = tk.Strings:Concat("profile.castbars.", name, ".show_icon")
                        },
                        {   name = L["Show Latency Bar"],
                            type = "check",
                            enabled = name == "player",
                            dbPath = tk.Strings:Concat("profile.castbars.", name, ".show_latency")
                        },
                        {   name = L["Anchor to SUF Portrait Bar"],
                            type = "check",
                            OnLoad = function(_, container)
                                Map.suf_anchor_checkbuttons[name] = container.btn;
                            end,
                            enabled = name ~= "mirror",
                            tooltip = tk.string.format(
                                L["If enabled the Cast Bar will be fixed to the %s Unit Frame's Portrait Bar (if it exists)."], castBarName),
                            dbPath = tk.Strings:Concat("profile.castbars.", name, ".anchor_to_SUF"),
                            SetValue = function(path, _, new, button)
                                local unitframe = tk._G["SUFUnit"..name];
                                if (new and not (unitframe and unitframe.portrait)) then
                                    button:SetChecked(false);
                                    tk:Print(tk.string.format(L["The %s Unit Frames's Portrait Bar needs to be enabled to use this feature."], castBarName));
                                    return;
                                end
                                db:SetPathValue(path, new);
                                for _, textfield in tk.pairs(Map.position_textfields[name]) do
                                    textfield:SetEnabled(not new);
                                end
                                for _, textfield in tk.ipairs(Map.width_textfields[name]) do
                                    textfield:SetEnabled(not new);
                                end
                                for _, textfield in tk.ipairs(Map.height_textfields[name]) do
                                    textfield:SetEnabled(not new);
                                end
                            end
                        },
                        {   type = "divider",
                            enabled = name ~= "mirror",
                        },
                        {   name = L["Unlock"],
                            type = "button",
                            castbar_name = name,
                            OnClick = UnlockCastBar
                        },
                        {   type = "divider"
                        },
                        {   name = L["Width"],
                            tooltip = L["Only takes effect if the Cast Bar is not anchored to a SUF Portrait Bar."],
                            type = "textfield",
                            valueType = "number",
                            OnLoad = function(_, container)
                                if (db.profile.castbars[name].anchor_to_SUF) then
                                    container.widget.field:SetEnabled(false);
                                end
                                tk.table.insert(Map.width_textfields[name], container.widget.field);
                            end,
                            dbPath = tk.Strings:Concat("profile.castbars.", name, ".width")
                        },
                        {   name = L["Height"],
                            tooltip = L["Only takes effect if the Cast Bar is not anchored to a SUF Portrait Bar."],
                            type = "textfield",
                            valueType = "number",
                            OnLoad = function(_, container)
                                if (db.profile.castbars[name].anchor_to_SUF) then
                                    container.widget.field:SetEnabled(false);
                                end
                                tk.table.insert(Map.height_textfields[name], container.widget.field);
                            end,
                            dbPath = tk.Strings:Concat("profile.castbars.", name, ".height")
                        },
                        {   type = "divider",
                        },
                        {   name = L["Frame Strata"],
                            type = "dropdown",
                            options = tk.Constants.FRAME_STRATA_VALUES,
                            dbPath = tk.Strings:Concat("profile.castbars.", name, ".frame_strata")
                        },
                        {   name = L["Frame Level"],
                            type = "slider",
                            min = 1,
                            max = 50,
                            step = 1,
                            dbPath = tk.Strings:Concat("profile.castbars.", name, ".frame_level")
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
                                if (db.profile.castbars[name].anchor_to_SUF) then
                                    container.widget.field:SetEnabled(false);
                                end
                                Map.position_textfields[name].point = container.widget.field;
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
                                if (db.profile.castbars[name].anchor_to_SUF) then
                                    container.widget.field:SetEnabled(false);
                                end

                                Map.position_textfields[name].relativeFrame = container.widget.field;
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
                                if (db.profile.castbars[name].anchor_to_SUF) then
                                    container.widget.field:SetEnabled(false);
                                end
                                Map.position_textfields[name].relativePoint = container.widget.field;
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
                                if (db.profile.castbars[name].anchor_to_SUF) then
                                    container.widget.field:SetEnabled(false);
                                end

                                Map.position_textfields[name].x = container.widget.field;
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
                                if (db.profile.castbars[name].anchor_to_SUF) then
                                    container.widget.field:SetEnabled(false);
                                end
                                Map.position_textfields[name].y = container.widget.field;
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