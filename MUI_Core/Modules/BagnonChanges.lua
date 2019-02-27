-- luacheck: ignore MayronUI self 143 631
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local _, namespace = ...;
local IsAddOnLoaded = _G.IsAddOnLoaded;

function namespace:SetUpBagnon()
    if (IsAddOnLoaded("Bagnon")) then
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
        em:CreateEventHandler("ADDON_LOADED", function(handler, _, name)
            if (name == "Bagnon") then
                self:SetUpBagnon();
                handler:Destroy();
            end
        end);
    end
end