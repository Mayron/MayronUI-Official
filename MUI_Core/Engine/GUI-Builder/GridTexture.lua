-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;

---@class GUIBuilder
local gui = MayronUI:GetComponent("GUIBuilder");

local ipairs, Mixin = _G.ipairs, _G.Mixin;
local regions = {"tl", "tr", "bl", "br", "t", "b", "l", "r", "c"};

---@class MayronUI.GridTextureMixin : table
local GridTextureMixin = {};

function GridTextureMixin:SetGridColor(r, g, b, a)
  for _, key in ipairs(regions) do
    self[key]:SetVertexColor(r, g, b, a);
  end
end

function GridTextureMixin:SetGridTexture(texture)
  for _, key in ipairs(regions) do
    self[key]:SetTexture(texture);
  end
end

function GridTextureMixin:SetGridTextureShown(shown)
  for _, key in ipairs(regions) do
    self[key]:SetShown(shown);
  end
end

function GridTextureMixin:SetGridCornerSize(cornerSize)
  for _, key in ipairs(regions) do
    self[key]:SetSize(cornerSize, cornerSize);
  end
end

-- Places the borders of a texture into their own sections to ensure they do not stretch when the frame is resized.
---@generic T
---@param frame T
---@return T|MayronUI.GridTextureMixin
function gui:CreateGridTexture(frame, texture, cornerSize, inset, originalTextureWidth, originalTextureHeight, layer)
  frame = frame --[[@as table]];
  local smallWidth = cornerSize / originalTextureWidth;
  local largeWidth = 1 - smallWidth;
  local smallHeight = cornerSize / originalTextureHeight;
  local largeHeight = 1 - smallHeight;
  inset = inset or 0;

  for _, key in ipairs(regions) do
    frame[key] = frame:CreateTexture(nil, layer or "BACKGROUND");
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

  return Mixin(frame, GridTextureMixin);
end