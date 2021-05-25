-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore
local _, C_UnitPanels = _G.MayronUI:ImportModule("UnitPanels");

local CreateFrame, pairs = _G.CreateFrame, _G.pairs;
local IsAddOnLoaded, UnitExists, UnitIsPlayer = _G.IsAddOnLoaded, _G.UnitExists, _G.UnitIsPlayer;

local function CreateGradientFrame(sufGradients, parent)
  local frame = CreateFrame("Frame", nil, parent);
  frame:SetPoint("TOPLEFT", 1, -1);
  frame:SetPoint("TOPRIGHT", -1, -1);
  frame:SetFrameLevel(5);
  frame.texture = frame:CreateTexture(nil, "OVERLAY");
  frame.texture:SetAllPoints(frame);
  frame.texture:SetColorTexture(1, 1, 1, 1);
  frame:SetSize(100, sufGradients.height);
  frame:Show();

  local from = sufGradients.from;
  local to = sufGradients.to;

  frame.texture:SetGradientAlpha("VERTICAL",
    to.r, to.g, to.b, to.a, from.r, from.g, from.b, from.a);

  return frame;
end

function C_UnitPanels:SetPortraitGradientsEnabled(data, enabled)
  if (not IsAddOnLoaded("ShadowedUnitFrames")) then return end

  if (enabled) then
    data.gradients = data.gradients or obj:PopTable();

    for i = 1, 2 do
      local unitID = i == 1 and "player" or "target";
      local parent = _G["SUFUnit"..unitID];

      if (parent and parent.portrait) then
        data.gradients[unitID] = data.gradients[unitID] or
        CreateGradientFrame(data.settings.sufGradients, parent);

        if (unitID == "target") then
          local frame = data.gradients[unitID];
          local handler = em:GetEventListenerByID("MuiUnitPanels_TargetGradient");

          if (not handler) then
            handler = em:CreateEventListenerWithID("MuiUnitPanels_TargetGradient", function()
              if (not UnitExists("target")) then return end

              local from = data.settings.sufGradients.from;
              local to = data.settings.sufGradients.to;

              if (UnitIsPlayer("target") and data.settings.sufGradients.targetClassColored) then
                local classColor = tk:GetClassColorByUnitID("target");

                frame.texture:SetGradientAlpha("VERTICAL",
                to.r, to.g, to.b, to.a,
                classColor.r, classColor.g, classColor.b, from.a);
              else
                frame.texture:SetGradientAlpha("VERTICAL",
                to.r, to.g, to.b, to.a,
                from.r, from.g, from.b, from.a);
              end
            end);

            handler:RegisterEvent("PLAYER_TARGET_CHANGED");
          else
            handler:SetEnabled(true);
          end

          em:TriggerEventListenerByID("MuiUnitPanels_TargetGradient");
        end

        data.gradients[unitID]:Show();

      elseif (data.gradients[unitID]) then
        data.gradients[unitID]:Hide();
      end
    end
  else
    if (data.gradients) then
      for _, frame in pairs(data.gradients) do
        frame:Hide();
      end
    end

    local handler = em:GetEventListenerByID("MuiUnitPanels_TargetGradient");

    if (handler) then
      handler:SetEnabled(false);
    end
  end
end