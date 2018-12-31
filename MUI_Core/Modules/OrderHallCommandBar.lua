-- luacheck: ignore MayronUI self 143 631
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local _, namespace = ...;
local OrderHallCommandBar = _G.OrderHallCommandBar;
local IsAddOnLoaded = _G.IsAddOnLoaded;
local troops = {};

local function EnumerateTroops()
    local width = OrderHallCommandBar.AreaName:GetStringWidth() + 200;
    tk:EmptyTable(troops);

    for frame in OrderHallCommandBar.categoryPool:EnumerateActive() do
        tk.table.insert(troops, frame);
    end

    for id, frame in tk.ipairs(troops) do
        frame:ClearAllPoints();
        width = width + frame:GetSize() + 4;

        tk:KillElement(frame.TroopPortraitCover);

        if (id == 1) then
            frame:SetPoint("RIGHT", OrderHallCommandBar, "RIGHT", -4, 0);
        else
            frame:SetPoint("RIGHT", troops[id - 1], "LEFT", -4, 0);
        end
    end

    OrderHallCommandBar:SetWidth(width);
end

function namespace:SetupOrderHallBar()
    if (IsAddOnLoaded("Blizzard_OrderHallUI")) then
        tk:KillElement(OrderHallCommandBar.Background);
        tk:KillElement(OrderHallCommandBar.WorldMapButton);
        gui:CreateDialogBox(nil, "LOW", OrderHallCommandBar);

        OrderHallCommandBar:ClearAllPoints();
        OrderHallCommandBar:SetPoint("TOP");
        OrderHallCommandBar.SetPoint = tk.Constants.DUMMY_FUNC;
        OrderHallCommandBar.ClearAllPoints = tk.Constants.DUMMY_FUNC;
        OrderHallCommandBar.AreaName:ClearAllPoints();
        OrderHallCommandBar.Currency:SetPoint("LEFT", OrderHallCommandBar.ClassIcon, "RIGHT", 10, 0);
        OrderHallCommandBar.AreaName:SetPoint("LEFT", OrderHallCommandBar.CurrencyIcon, "RIGHT", 10, 2);
        OrderHallCommandBar:SetWidth(OrderHallCommandBar.AreaName:GetStringWidth() + 500);

        tk.hooksecurefunc(OrderHallCommandBar, "RefreshCategories", EnumerateTroops);
    else
        em:CreateEventHandler("ADDON_LOADED", function(handler, _, name)
            if (name == "Blizzard_OrderHallUI" and OrderHallCommandBar) then
                self:SetupOrderHallBar();
                handler:Destroy();
            end
        end);
    end
end