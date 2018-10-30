local Lib = LibStub:GetLibrary("LibMayronGUI");
if (not Lib) then return; end

local WidgetsPackage = Lib.WidgetsPackage;
local Private = Lib.Private;
---------------------------------

do
    local regions = {"tl", "tr", "bl", "br", "t", "b", "l", "r", "c"};

    local function SetGridColor(self, r, g, b)        
        for _, key in ipairs(regions) do
            self[key]:SetVertexColor(r, g, b);
        end
    end

    -- Changed from gui: to Lib:
    function Lib:CreateGridTexture(frame, texture, cornerSize, inset, 
                                   originalTextureWidth, originalTextureHeight)

        local smallWidth = cornerSize / originalTextureWidth;
        local largeWidth = 1 - smallWidth;
        local smallHeight = cornerSize / originalTextureHeight;
        local largeHeight = 1 - smallHeight;
        inset = inset or 0;

        for _, key in ipairs(regions) do
            frame[key] = frame:CreateTexture(nil, "BACKGROUND");
            frame[key]:SetTexture(texture);
            frame[key]:SetSize(cornerSize, cornerSize);
        end

        frame.tl:SetPoint("TOPLEFT", -inset, inset);
        frame.tl:SetTexCoord(0, smallWidth, 0, smallHeight);
        frame.tr:SetPoint("TOPRIGHT", inset, inset);
        frame.tr:SetTexCoord(largeWidth, 1, 0, smallHeight);
        frame.bl:SetPoint("BOTTOMLEFT", -inset, -inset);
        frame.bl:SetTexCoord(0, smallWidth, largeHeight, 1);
        frame.br:SetPoint("BOTTOMRIGHT", inset, -inset);
        frame.br:SetTexCoord(largeWidth, 1, largeHeight, 1);
        frame.t:SetPoint("TOPLEFT", frame.tl, "TOPRIGHT");
        frame.t:SetPoint("BOTTOMRIGHT", frame.tr, "BOTTOMLEFT");
        frame.t:SetTexCoord(smallWidth, largeWidth, 0, smallHeight);
        frame.b:SetPoint("TOPLEFT", frame.bl, "TOPRIGHT");
        frame.b:SetPoint("BOTTOMRIGHT", frame.br, "BOTTOMLEFT");
        frame.b:SetTexCoord(smallWidth, largeWidth, largeHeight, 1);
        frame.l:SetPoint("TOPLEFT", frame.tl, "BOTTOMLEFT");
        frame.l:SetPoint("BOTTOMRIGHT", frame.bl, "TOPRIGHT");
        frame.l:SetTexCoord(0, smallWidth, smallHeight, largeHeight);
        frame.r:SetPoint("TOPLEFT", frame.tr, "BOTTOMLEFT");
        frame.r:SetPoint("BOTTOMRIGHT", frame.br, "TOPRIGHT");
        frame.r:SetTexCoord(largeWidth, 1, smallHeight, largeHeight);
        frame.c:SetPoint("TOPLEFT", frame.tl, "BOTTOMRIGHT");
        frame.c:SetPoint("BOTTOMRIGHT", frame.br, "TOPLEFT");
        frame.c:SetTexCoord(smallWidth, largeWidth, smallHeight, largeHeight);
        
        frame.SetGridColor = SetGridColor;
    end
end