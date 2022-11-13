local MayronUI = _G.MayronUI;
local tk = MayronUI:GetCoreComponents();
local Components = MayronUI:GetComponent("ConfigMenuComponents");

-- supported title config attributes:
-- name - the container name (a visible fontstring that shows in the GUI)
-- paddingTop - space between top of background and top of name
-- paddingBottom - space between bottom of background and bottom of name
-- width - overrides using a full width (100% width of the container) with a fixed width value
function Components.title(parent, widgetTable)
    local container = tk:CreateFrame("Frame", parent);
    container.text = container:CreateFontString(nil, "OVERLAY", "MUI_FontLarge");
    tk:SetFontSize(container.text, 14);
    container.text:SetText(widgetTable.name);

    local marginTop = widgetTable.marginTop or 10;
    local marginBottom = widgetTable.marginBottom or 0;
    local topPadding = (widgetTable.paddingTop or (marginTop + 10));
    local bottomPadding = (widgetTable.paddingBottom or (marginBottom + 10));
    local textHeight = container.text:GetStringHeight();
    local height = textHeight + topPadding + bottomPadding;

    container:SetHeight(height);

    if (widgetTable.width) then
        container:SetWidth(widgetTable.width);
    else
        tk:SetFullWidth(container, 14);
    end

    local background = tk:SetBackground(container, 0, 0, 0, 0.2);
    background:ClearAllPoints();
    background:SetPoint("TOPLEFT", 0, -marginTop);
    background:SetPoint("BOTTOMRIGHT", 0, marginBottom);
    container.text:SetAllPoints(background);

    return container;
end