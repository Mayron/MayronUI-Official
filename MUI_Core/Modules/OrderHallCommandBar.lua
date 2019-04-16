-- luacheck: ignore MayronUI self 143 631
local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local IsAddOnLoaded, hooksecurefunc, table, ipairs = _G.IsAddOnLoaded, _G.hooksecurefunc, _G.table, _G.ipairs;
local commandBar;
local troops = {};

local function EnumerateTroops()
    local width = commandBar.AreaName:GetStringWidth() + 200;
    tk.Tables:Empty(troops);

    for frame in commandBar.categoryPool:EnumerateActive() do
        table.insert(troops, frame);
    end

    for id, frame in ipairs(troops) do
        frame:ClearAllPoints();
        width = width + frame:GetSize() + 4;

        tk:KillElement(frame.TroopPortraitCover);

        if (id == 1) then
            frame:SetPoint("RIGHT", commandBar, "RIGHT", -4, 0);
        else
            frame:SetPoint("RIGHT", troops[id - 1], "LEFT", -4, 0);
        end
    end

    commandBar:SetWidth(width);
end

function namespace:SetUpOrderHallBar()
    if (IsAddOnLoaded("Blizzard_OrderHallUI")) then
        commandBar = _G.OrderHallCommandBar;
        tk:KillElement(commandBar.Background);
        tk:KillElement(commandBar.WorldMapButton);
        gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, "LOW", commandBar);

        commandBar:ClearAllPoints();
        commandBar:SetPoint("TOP");
        commandBar.SetPoint = tk.Constants.DUMMY_FUNC;
        commandBar.ClearAllPoints = tk.Constants.DUMMY_FUNC;
        commandBar.AreaName:ClearAllPoints();
        commandBar.Currency:SetPoint("LEFT", commandBar.ClassIcon, "RIGHT", 10, 0);
        commandBar.AreaName:SetPoint("LEFT", commandBar.CurrencyIcon, "RIGHT", 10, 2);
        commandBar:SetWidth(commandBar.AreaName:GetStringWidth() + 500);

        hooksecurefunc(commandBar, "RefreshCategories", EnumerateTroops);
    else
        em:CreateEventHandler("ADDON_LOADED", function(handler, _, name)
            if (name == "Blizzard_OrderHallUI") then
                self:SetUpOrderHallBar();
                handler:Destroy();
            end
        end);
    end
end
