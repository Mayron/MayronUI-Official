-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI; ---@type MayronUI
local tk, _, em, _, obj = MayronUI:GetCoreComponents(); -- luacheck: ignore
local IsAddOnLoaded = _G.IsAddOnLoaded;
local BagnonChanges = MayronUI:NewComponent("BagnonChanges");

function BagnonChanges:Apply()
  if (IsAddOnLoaded("Bagnon")) then
    -- support for older versions of Bagnon
    if (obj:IsFunction(_G.Bagnon.CreateFrame)) then
      tk:HookFunc(_G.Bagnon, "CreateFrame", function(_, id)
        local f = _G.Bagnon:GetFrame(id);

        if (f.muiUpdate) then
          return;
        end

        f:SetBackdrop({
          bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
          edgeFile = tk.Constants.BACKDROP.edgeFile,
          edgeSize = tk.Constants.BACKDROP.edgeSize,
        });

        f.muiUpdate = true;
      end);
    else
      -- newer version of Bagnon
      tk:HookFunc(_G.Bagnon.Frame, "UpdateBackdrop", function(self)
        local back = self.profile.color;
        local border = self.profile.borderColor;

        self:SetBackdrop({
          bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
          edgeFile = tk.Constants.BACKDROP.edgeFile,
          edgeSize = tk.Constants.BACKDROP.edgeSize,
        });

        self:SetBackdropColor(back[1], back[2], back[3], back[4]);
        self:SetBackdropBorderColor(border[1], border[2], border[3], border[4]);
      end);
    end
  else
    em:CreateEventListener(function(listener, _, name)
      if (name == "Bagnon") then
        self:SetUpBagnon();
        listener:Destroy();
      end
    end):RegisterEvent("ADDON_LOADED");
  end
end