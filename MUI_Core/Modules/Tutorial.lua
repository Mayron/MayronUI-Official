-- luacheck: ignore MayronUI self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

-- Register and Import Modules -----------

local C_Tutorial = MayronUI:RegisterModule("TutorialModule", "Tutorial");

function C_Tutorial:OnInitialize()
    if (db.profile.tutorial) then
        self:SetEnabled(true);
    end
end

function C_Tutorial:OnEnable()
    local frame = tk:PopFrame("Frame");

    frame:SetFrameStrata("TOOLTIP");
    frame:SetSize(300, 180);
    frame:SetPoint("CENTER");

    gui:CreateDialogBox(tk.Constants.AddOnStyle, nil, nil, frame);
    gui:AddCloseButton(tk.Constants.AddOnStyle, frame);

    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    tk:SetFontSize(frame.text, 14);
    frame.text:SetWordWrap(true);
    frame.text:SetPoint("TOPLEFT", 10, -30);
    frame.text:SetPoint("BOTTOMRIGHT", -10, 80);
    frame.text:SetText("Thank you for installing MayronUI\n\nYou can fully customise the UI in the MayronUI config menu:");

    local configButton = gui:CreateButton(tk.Constants.AddOnStyle, frame, "Open Config Menu");
    configButton:SetPoint("TOP", frame.text, "BOTTOM", 0, -20);
    configButton:SetScript("OnClick", function()
        MayronUI:TriggerCommand("config");
        frame:Hide();
        db.profile.tutorial = nil;
    end);

    frame.closeBtn:HookScript("OnClick", function()
        db.profile.tutorial = nil;
    end);
end