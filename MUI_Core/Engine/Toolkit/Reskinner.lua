------------------------
-- Setup namespaces
------------------------
local _, core = ...;
core.Reskinner = {};

local rs = core.Reskinner;
local tk = core.Toolkit;
local gui = core.GUI_Builder;
local private = {};

------------------------
-- Constants
------------------------
rs.BACKGROUND = 2;
rs.BORDER = 4;
rs.ARTWORK = 8;
rs.OVERLAY = 16;
rs.HIGHLIGHT = 32;
rs.CREATE_BACKGROUND = 64;

-- for testing
function MUI_Reskin(frame, value)
    rs:Reskin(frame, value);
end

--rs.background = "" -> use gui:CreateDialogBox(parent, alphaType [, frame [, name]])

function private:HideTextures(frame, layers)
    for layer = 1, (#layers) do
        for r = 1, frame:GetNumRegions() do
            local region = tk.select(r, frame:GetRegions());
            if not (region) then return; end
            if (region:GetObjectType() == "Texture") then
                if (region:GetDrawLayer() == layers[layer]) then
                    region:Hide();
                    region.Show = tk.Constants.DUMMY_FUNC;
                    region:SetTexture("");
                    region.SetTexture = tk.Constants.DUMMY_FUNC;
                end
            end
        end
    end
end

do
    local indexes = {};
    function rs:GetFrameFromPath(path)
        if (tk.string.find(path, "%.")) then
            local frame;
            for _, key in tk:IterateArgs(tk.strsplit(".", path)) do
                tk:EmptyTable(indexes);
                if (key:find("%b[]")) then
                    for index in key:gmatch("(%b[])") do
                        index = index:match("%[(.+)%]");
                        tk.table.insert(indexes, index);
                    end
                end
                key = tk.strsplit("[", key);
                frame = (frame and frame[key]) or tk._G[key];
                if (not frame) then return; end
                for _, key in tk.ipairs(indexes) do
                    key = tk.tonumber(key) or key;
                    frame = (frame and frame[key]) or tk._G[key];
                    if (not frame) then return; end
                end
            end
            return frame;
        else
            return tk._G[path];
        end
    end
end

do
    local layers = {};

    function rs:Reskin(frame, value)
        tk:EmptyTable(layers);
        if (tk.bit.band(value, self.BACKGROUND) ~= 0) then
            tk.table.insert(layers, "BACKGROUND");
        end

        if (tk.bit.band(value, self.BORDER) ~= 0) then
            tk.table.insert(layers, "BORDER");
        end

        if (tk.bit.band(value, self.ARTWORK) ~= 0) then
            tk.table.insert(layers, "ARTWORK");
        end

        if (tk.bit.band(value, self.OVERLAY) ~= 0) then
            tk.table.insert(layers, "OVERLAY");
        end

        if (tk.bit.band(value, self.HIGHLIGHT) ~= 0) then
            tk.table.insert(layers, "HIGHLIGHT");
        end

        private:HideTextures(frame, layers);

        if (tk.bit.band(value, self.CREATE_BACKGROUND) ~= 0) then
            self:CreateBackground(frame);
        end
    end
end

function rs:CreateBackground(frame, insets)
    if (frame.reskinned) then 
        return; 
    end

    local left = (tk.type(insets) == "number" and insets) or (insets and insets[1]) or 0;
    local right = (tk.type(insets) == "number" and insets) or (insets and insets[2]) or 0;
    local top = (tk.type(insets) == "number" and insets) or (insets and insets[3]) or 0;
    local bottom = (tk.type(insets) == "number" and insets) or (insets and insets[4]) or 0;

    gui:CreateGridTexture(frame, tk.Constants.MEDIA.."dialog_box\\Texture-Medium", 10, 6, 512, 512);

    tk:SetThemeColor(frame.tl, frame.tr, frame.bl, frame.br,
                     frame.t, frame.b, frame.l, frame.r, frame.c);

    frame.reskinned = true;

    return frame;
end

function rs:CreateBasicBackground(frame, insets, colours, alpha)
    local bg = frame:CreateTexture(nil, "BACKGROUND", nil, -2);
    local left = (tk.type(insets) == "number" and insets) or (insets and insets[1]) or 0;
    local right = (tk.type(insets) == "number" and insets) or (insets and insets[2]) or 0;
    local top = (tk.type(insets) == "number" and insets) or (insets and insets[3]) or 0;
    local bottom = (tk.type(insets) == "number" and insets) or (insets and insets[4]) or 0;

    local r = (tk.type(colours) == "number" and colours) or (colours and colours[1]) or 0;
    local g = (tk.type(colours) == "number" and colours) or (colours and colours[2]) or 0;
    local b = (tk.type(colours) == "number" and colours) or (colours and colours[3]) or 0;
    local a = alpha or (tk.type(colours) == "number" and (alpha or 0.4)) or (colours and colours[4]) or 0.4;    

    bg:SetColorTexture(r, g, b, a);
    bg:SetPoint("TOPLEFT", left, -top);
    bg:SetPoint("BOTTOMRIGHT", -right, bottom);

    return bg;
end

function rs:AddMovableButton(frame)

end

function rs:SetMovable(frame, movable)

end

function rs:ReskinButton(button)
    gui:CreateButton(nil, nil, nil, nil, nil, nil, button);
end

function rs:ReskinScrollBar(slider)
    local name = slider:GetName();
    local up = tk._G[name.."ScrollUpButton"];
    local down = tk._G[name.."ScrollDownButton"];
    up:SetNormalTexture(tk.Constants.MEDIA.."reskin\\arrow_up");
    up:SetDisabledTexture("");
    down:SetNormalTexture(tk.Constants.MEDIA.."reskin\\arrow_down");
    down:SetDisabledTexture("");

    local r, g, b = tk:GetThemeColor();
    slider.thumb = slider:GetThumbTexture();
    slider.thumb:SetColorTexture(r, g, b, 0.8);
    slider.thumb:SetSize(5, 50);
end

function rs:ReskinIcon(button, texture)
    if (button.border) then return; end
    button:SetHighlightTexture("");
    button:SetPushedTexture("");

    texture = texture or button.icon or button.Icon or
            tk._G[tk.tostring(button:GetName()).."IconTexture"] or button:GetNormalTexture();

    if (not texture) then return; end
    texture:SetTexCoord(0.1, 0.92, 0.08, 0.92);
    button.border = button:CreateTexture(nil, "BACKGROUND");
    button.border:SetTexture(tk.Constants.MEDIA.."reskin\\mui_button");
    button.border:SetAllPoints(true);
    texture:ClearAllPoints();
    texture:SetPoint("TOPLEFT", 1, -1);
    texture:SetPoint("BOTTOMRIGHT", -1, 1);
    return texture;
end

-- /run LFDQueueFrameRandomScrollFrame
-- /run for str, value in pairs(CharacterFinger1Slot) do print(str.." : "..tostring(value)) end






