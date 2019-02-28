local AuraFrames = LibStub("AceAddon-3.0"):GetAddon("AuraFrames");
local LibAura = LibStub("LibAura-1.0");

-- Import used global references into the local namespace.
local ipairs, unpack = ipairs, unpack;


local TextureIds = {"_AFB_TR", "_AFB_TL", "_AFB_BR", "_AFB_BL", "_AFB_T", "_AFB_B", "_AFB_R", "_AFB_L"};

local TexturePoints = {
  {{"TOPRIGHT", nil, "TOPRIGHT", 0, 0}}, -- _AFB_TR
  {{"TOPLEFT", nil, "TOPLEFT", 0, 0}}, -- _AFB_TL
  {{"BOTTOMRIGHT", nil, "BOTTOMRIGHT", 0, 0}}, -- _AFB_BR
  {{"BOTTOMLEFT", nil, "BOTTOMLEFT", 0, 0}}, -- _AFB_BL
  { -- _AFB_T
    {"TOPRIGHT", "_AFB_TR", "TOPLEFT", 0, 0},
    {"BOTTOMLEFT", "_AFB_TL", "BOTTOMRIGHT", 0, 0},
  },
  { -- _AFB_B
    {"TOPRIGHT", "_AFB_BR", "TOPLEFT", 0, 0},
    {"BOTTOMLEFT", "_AFB_BL", "BOTTOMRIGHT", 0, 0},
  },
  { -- _AFB_R
    {"TOPRIGHT", "_AFB_TR", "BOTTOMRIGHT", 0, 0},
    {"BOTTOMLEFT", "_AFB_BR", "TOPLEFT", 0, 0},
  },
  { -- _AFB_L
    {"TOPRIGHT", "_AFB_TL", "BOTTOMRIGHT", 0, 0},
    {"BOTTOMLEFT", "_AFB_BL", "TOPLEFT", 0, 0},
  },
};

local TextureTile = { -- {HorizTile, VertTile}
  {false, false}, -- _AFB_TR
  {false, false}, -- _AFB_TL
  {false, false}, -- _AFB_BR
  {false, false}, -- _AFB_BL
  {true, false}, -- _AFB_T
  {true, false}, -- _AFB_B
  {false, true}, -- _AFB_R
  {false, true}, -- _AFB_L
}

local TextureCoords = {
  {0.125 * 5, 0.125 * 6, 0, 1}, -- _AFB_TR
  {0.125 * 4, 0.125 * 5, 0, 1}, -- _AFB_TL
  {0.125 * 7, 0.125 * 8, 0, 1}, -- _AFB_BR
  {0.125 * 6, 0.125 * 7, 0, 1}, -- _AFB_BL
  {0.125 * 2, 1, 0.125 * 3, 1, 0.125 * 2, 0, 0.125 * 3, 0}, -- _AFB_T
  {0.125 * 3, 1, 0.125 * 4, 1, 0.125 * 3, 0, 0.125 * 4, 0}, -- _AFB_B
  {0.125 * 1, 0.125 * 2, 0, 1}, -- _AFB_R
  {0.125 * 0, 0.125 * 1, 0, 1}, -- _AFB_L
}


-----------------------------------------------------------------
-- Function BorderUpdate
-----------------------------------------------------------------
local function BorderUpdate(Frame, Width, Height)

  if Frame._AFB_Active ~= true then
    return;
  end

  local x = Width < (Frame._AFB_Size * 2) and Width / (Frame._AFB_Size * 2) or 1
  local y = Height < (Frame._AFB_Size * 2) and Height / (Frame._AFB_Size * 2) or 1
  
  if x ~= 1 or y ~= 1 then
  
    Frame._AFB_TR:SetTexCoord(
      TextureCoords[1][1] + ((1 - x) * 0.125),
      TextureCoords[1][2],
      TextureCoords[1][3],
      TextureCoords[1][4] - (1 - y)
    );
    Frame._AFB_TR:SetSize(x * Frame._AFB_Size, y * Frame._AFB_Size);
    
    Frame._AFB_TL:SetTexCoord(
      TextureCoords[2][1],
      TextureCoords[2][2] - ((1 - x) * 0.125),
      TextureCoords[2][3],
      TextureCoords[2][4] - (1 - y)
    );
    Frame._AFB_TL:SetSize(x * Frame._AFB_Size, y * Frame._AFB_Size);
    
    Frame._AFB_BR:SetTexCoord(
      TextureCoords[3][1] + ((1 - x) * 0.125),
      TextureCoords[3][2],
      TextureCoords[3][3] + (1 - y),
      TextureCoords[3][4] 
    );
    Frame._AFB_BR:SetSize(x * Frame._AFB_Size, y * Frame._AFB_Size);
    
    Frame._AFB_BL:SetTexCoord(
      TextureCoords[4][1],
      TextureCoords[4][2] - ((1 - x) * 0.125),
      TextureCoords[4][3] + (1 - y),
      TextureCoords[4][4] 
    );
    Frame._AFB_BL:SetSize(x * Frame._AFB_Size, y * Frame._AFB_Size);
    

    Frame._AFB_T:SetTexCoord(
      TextureCoords[5][1],
      TextureCoords[5][2],
      TextureCoords[5][3] - ((1 - y) * 0.125),
      TextureCoords[5][4],
      TextureCoords[5][5],
      TextureCoords[5][6],
      TextureCoords[5][7] - ((1 - y) * 0.125),
      TextureCoords[5][8]
    );
    
    Frame._AFB_B:SetTexCoord(
      TextureCoords[6][1] + ((1 - y) * 0.125),
      TextureCoords[6][2],
      TextureCoords[6][3],
      TextureCoords[6][4],
      TextureCoords[6][5] + ((1 - y) * 0.125),
      TextureCoords[6][6],
      TextureCoords[6][7],
      TextureCoords[6][8]
    );
    
    Frame._AFB_R:SetTexCoord(
      TextureCoords[7][1] + ((1 - x) * 0.125),
      TextureCoords[7][2],
      TextureCoords[7][3],
      TextureCoords[7][4]
    );

    Frame._AFB_L:SetTexCoord(
      TextureCoords[8][1],
      TextureCoords[8][2] - ((1 - x) * 0.125),
      TextureCoords[8][3],
      TextureCoords[8][4]
    );
    
    Frame._AFB_Resized = true;
  
  elseif Frame._AFB_Resized == true then
  
    for Index, Id in ipairs(TextureIds) do
      Frame[Id]:SetTexCoord(unpack(TextureCoords[Index]));
      Frame[Id]:SetSize(Frame._AFB_Size, Frame._AFB_Size)
    end
    
    Frame._AFB_Resized = false;
  
  end

end


-----------------------------------------------------------------
-- Function SetBorder
-----------------------------------------------------------------
function AuraFrames:SetBorder(Frame, Texture, Size)

  if Texture == nil then
  
    for _, Id in ipairs(TextureIds) do
    
      if Frame[Id] then
        Frame[Id]:Hide();
      end
    
    end
    
    Frame._AFB_Active = false;
  
    return;
  
  end
  
  Frame._AFB_Active = true;
  Frame._AFB_Size = Size;
  Frame._AFB_Resized = true;

  for Index, Id in ipairs(TextureIds) do
  
    if not Frame[Id] then
      Frame[Id] = Frame:CreateTexture(nil, "OVERLAY");
    end
    
    Frame[Id]:SetTexture(Texture);
    Frame[Id]:Show();
  
  end

  for Index, Id in ipairs(TextureIds) do
    
    Frame[Id]:ClearAllPoints();
    
    for _, Point in ipairs(TexturePoints[Index]) do
      Frame[Id]:SetPoint(Point[1], Point[2] and Frame[Point[2]] or Frame, Point[3], Point[4], Point[5]);
    end
  
  end
  
  BorderUpdate(Frame, Frame:GetWidth(), Frame:GetHeight());
  
  if not Frame._AFB_Hooked then
    Frame:HookScript("OnSizeChanged", BorderUpdate);
    Frame._AFB_Hooked = true;
  end

end


-----------------------------------------------------------------
-- Function SetBorderColor
-----------------------------------------------------------------
function AuraFrames:SetBorderColor(Frame, r, g, b, a)

  for Index, Id in ipairs(TextureIds) do
  
    if not Frame[Id] then
      Frame[Id] = Frame:CreateTexture(nil, "OVERLAY");
      Frame[Id]:Hide();
    end
    
    Frame[Id]:SetVertexColor(r, g, b, a);
  
  end

end

