local _, core = ...;
core.Toolkit = core.Toolkit or {};

local tk = core.Toolkit;
-----------------------------

function tk:SetFullWidth(frame, rightPadding)
    rightPadding = rightPadding or 0;

    if (not frame:GetParent()) then
        tk.hooksecurefunc(frame, "SetParent", function()
            frame:GetParent():HookScript("OnSizeChanged", function(_, width)
                frame:SetWidth(width - rightPadding);
            end);

            frame:SetWidth(frame:GetParent():GetWidth() - rightPadding);
        end);

    else
        frame:GetParent():HookScript("OnSizeChanged", function(_, width)
            frame:SetWidth(width - rightPadding);
        end);

        frame:SetWidth(frame:GetParent():GetWidth() - rightPadding);
    end
end

function tk:MakeMovable(frame, dragger, movable)
    if (movable == nil) then
        movable = true;
    end

    dragger = dragger or frame;
    dragger:EnableMouse(movable);
    dragger:RegisterForDrag("LeftButton");

    frame:SetMovable(movable);
    frame:SetClampedToScreen(true);

    dragger:HookScript("OnDragStart", function()
        if (frame:IsMovable()) then
            local x, y = frame:GetCenter();

            frame:SetPoint("CENTER", tk.UIParent, "BOTTOMLEFT", x, y);
            frame:StartMoving();            
        end
    end);

    dragger:HookScript("OnDragStop", function()
        if (frame:IsMovable()) then
            frame:StopMovingOrSizing();
        end
    end);
end

function tk:SavePosition(frame, db_path, override)
    local point, relativeFrame, relativePoint, x, y = frame:GetPoint();

    if (not relativeFrame) then
        relativeFrame = frame:GetParent():GetName();
    else
        relativeFrame = relativeFrame:GetName();

        if (not relativeFrame or relativeFrame and relativeFrame ~= "UIParent") then
            if (not override) then 
                return; 
            end

            x, y = frame:GetCenter();
            point = "CENTER";
            relativeFrame = "UIParent"; -- Do not want this to be UIParent in some cases
            relativePoint = "BOTTOMLEFT";
        end
    end

    local positions = {
        point = point,
        relativeFrame = relativeFrame,
        relativePoint = relativePoint,
        x = x, y = y
    };

    core.Database:SetPathValue(db_path, positions);
    return positions;
end

function tk:MakeResizable(frame, dragger)
    dragger = dragger or frame;
    frame:SetResizable(true);
    dragger:RegisterForDrag("LeftButton");

    dragger:HookScript("OnDragStart", function()
        frame:StartSizing();
    end);

    dragger:HookScript("OnDragStop", function()
        frame:StopMovingOrSizing();
    end);
end

function tk:KillElement(element)
    element:Hide();    
    element:SetParent(tk.Constants.DUMMY_FRAME);
    element:SetAllPoints(true);
    element.Show = tk.Constants.DUMMY_FUNC;
end

function tk:HideFrameElements(frame, kill)
    for _, child in pairs({frame:GetChildren()}) do
        if (kill) then
            self:KillElement(child);
        else
            child:Hide();
        end
    end

    for _, region in pairs({frame:GetRegions()}) do
        if (kill) then
            self:KillElement(region);
        else
            region:Hide();
        end
    end
end

function tk:HookOnce(func)
    local execute = true;

    local function wrapper(...)
        if (execute) then
            func(...);
            execute = nil;
        end
    end

    return wrapper;
end

-- weird
function tk:SetClassColoredTexture(className, texture)
    className = className or (tk.select(2, UnitClass("player")));
    className = tk.string.upper(className);
    className = className:gsub("%s+", "");
    local c = self.Constants.CLASS_RGB_COLORS[className];
    texture:SetVertexColor(c.r, c.g, c.b, texture:GetAlpha());
end

do
    local color;

    function tk:SetThemeColor(...)
        local alpha = (tk.select(1, ...));

        if (not (tk.type(alpha) == "number" and alpha)) then
            tk.Constants.AddOnStyle:ApplyColor(nil, 1, ...);
        else
            tk.Constants.AddOnStyle:ApplyColor(nil, ...);
        end
    end

    function tk:GetThemeColor()
        color = color or core.Database.profile.theme.color;
        return color.r, color.g, color.b, color.hex;
    end

    function tk:UpdateThemeColor(value)
        color = tk.Constants.CLASS_RGB_COLORS[value] or value;
        core.Database.profile.theme.color = color;
        tk.Constants.AddOnStyle:SetColor(color.r, color.g, color.b);
    end
end

function tk:SetBackground(frame, ...)
    local texture = frame:CreateTexture(nil, "BACKGROUND");
    texture:SetAllPoints(frame);
    
    if (#{...} > 1) then
        texture:SetColorTexture(...);
    else
        texture:SetTexture(...);
    end

    return texture;
end

function tk:GroupCheckButtons(...)
    local btns = {};

    for id, btn in ipairs({...}) do
        btn:SetID(id);
        tk.table.insert(btns, btn);

        btn:HookScript("OnClick", function(self)
            if (self:GetChecked()) then
                local id = self:GetID();

                for i, btn in tk.ipairs(btns) do
                    if (id ~= i) then
                        btn:SetChecked(false);
                    end
                end
            end
        end);
    end
end

function tk:SetFontSize(fontstring, size)
    local filename, fontHeight, flags = fontstring:GetFont();
    fontstring:SetFont(filename, size, flags);
end

function tk:SetGameFont(font)
    tk._G["UNIT_NAME_FONT"] = font;
    tk._G["NAMEPLATE_FONT"] = font;
    tk._G["DAMAGE_TEXT_FONT"] = font;
    tk._G["STANDARD_TEXT_FONT"] = font;

    local fonts = {
        "SystemFont_Tiny", "SystemFont_Shadow_Small", "SystemFont_Small",
        "SystemFont_Small2", "SystemFont_Shadow_Small2", "SystemFont_Shadow_Med1_Outline",
        "SystemFont_Shadow_Med1", "QuestFont_Large", "SystemFont_Large",
        "SystemFont_Shadow_Large_Outline", "SystemFont_Shadow_Med2", "SystemFont_Shadow_Large",
        "SystemFont_Shadow_Large2", "SystemFont_Shadow_Huge1", "SystemFont_Huge2",
        "SystemFont_Shadow_Huge2", "SystemFont_Shadow_Huge3", "SystemFont_World",
        "SystemFont_World_ThickOutline", "SystemFont_Shadow_Outline_Huge2", "SystemFont_Med1",
        "SystemFont_WTF2", "SystemFont_Outline_WTF2", "GameTooltipHeader", "System_IME",

        -- other:
        "NumberFont_OutlineThick_Mono_Small", "NumberFont_Outline_Huge",
        "NumberFont_Outline_Large", "NumberFont_Outline_Med", "NumberFont_Shadow_Med",
        "NumberFont_Shadow_Small", "QuestFont", "QuestTitleFont", "QuestTitleFontBlackShadow",
        "GameFontNormalMed3", "SystemFont_Med3", "SystemFont_OutlineThick_Huge2",
        "SystemFont_Outline_Small", "SystemFont_Shadow_Med3", "Tooltip_Med", "Tooltip_Small",
        "ZoneTextString", "SubZoneTextString", "PVPInfoTextString", "PVPArenaTextString",
        "CombatTextFont", "FriendsFont_Normal", "FriendsFont_Small", "FriendsFont_Large",
        "FriendsFont_UserText",
    };

    -- prevent weird font size bug
    SystemFont_NamePlate:SetFont(font, 9); 

    for _, f in tk.ipairs(fonts) do        
        local _, size, outline = tk._G[f]:GetFont();        
        tk._G[f]:SetFont(font, size, outline);
    end
end