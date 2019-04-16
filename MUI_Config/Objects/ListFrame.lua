-- luacheck: ignore self 143 631
local _G, MayronUI = _G, _G.MayronUI;
local tk, _, _, gui, obj, _ = MayronUI:GetCoreComponents();
local unpack, ipairs, CreateFrame = _G.unpack, _G.ipairs, _G.CreateFrame;
local Button_OnClick;

local ConfigToolsPackage = obj:CreatePackage("ConfigTools", "MayronUI.Engine");

---@class ListFrame : Object
local C_ListFrame = ConfigToolsPackage:CreateClass("ListFrame");

---@class Stack : Object
local C_Stack = obj:Import("Framework.System.Collections.Stack<T>");

local function CreateListItem(listFrame, data)
    local item = CreateFrame("Button");
    item:SetSize(30, 30);

    if (obj:IsFunction(data.OnItemEnter)) then
        item:SetScript("OnEnter", data.OnItemEnter);
        item:SetScript("OnLeave",  tk.GeneralTooltip_OnLeave);
    end

    item.normal = tk:SetBackground(item, 0, 0, 0, 0);
    item.highlight = tk:SetBackground(item, 1, 1, 1, 0.1);

    item:SetNormalTexture(item.normal);
    item:SetHighlightTexture(item.highlight);

    item.name = item:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
    item.name:SetJustifyH("LEFT");
    item.name:SetJustifyV("CENTER");
    item.name:SetPoint("TOPLEFT", 6, 0);
    item.name:SetPoint("BOTTOMRIGHT", -34, 0);

    item.btn = CreateFrame("Button", nil, item);
    item.btn:SetSize(28, 24);
    item.btn:SetPoint("RIGHT", -8, 0);

    item.btn:SetNormalTexture(tk:GetAssetFilePath("Textures\\DialogBox\\CloseButton"), "BLEND");
    item.btn:SetHighlightTexture(tk:GetAssetFilePath("Textures\\DialogBox\\CloseButton"), "ADD");

    if (not Button_OnClick) then
        Button_OnClick = function(btn)
            listFrame:RemoveItem(btn:GetParent());
        end
    end

    item.btn:SetScript("OnClick", Button_OnClick);
    tk:ApplyThemeColor(item.btn);

    return item;
end

local function UpdateListFrame(items, scrollChild)
    if (items == 0) then
        return;
    end

    local height = 0;

    for id, item in ipairs(items) do
        item:ClearAllPoints();

        if (id == 1) then
            item:SetPoint("TOPLEFT", 2, -1);
            item:SetPoint("TOPRIGHT", -2, -30);
            height = height + 30;
        else
            item:SetPoint("TOPLEFT", items[id - 1], "BOTTOMLEFT", 0, -2);
            item:SetPoint("TOPRIGHT", items[id - 1], "BOTTOMRIGHT", 0, -2);
            height = height + 32;
        end

        if (id % 2 ~= 0) then
            tk:ApplyThemeColor(0.2, item.normal);
        else
            tk:ApplyThemeColor(0.1, item.normal);
        end

        scrollChild:SetHeight(height);
        item:Show();
    end
end

local function TextField_OnTextChanged(_, textValue, _, listFrame, data, ...)
    if (obj:IsFunction(data.OnTextChanged)) then
        data.OnTextChanged(listFrame, textValue, ...);
    end

    listFrame:AddItem(textValue);
    data.textField:SetText(tk.Strings.Empty);
end

ConfigToolsPackage:DefineParams("string");
function C_ListFrame:__Construct(data, listFrameTitle, ...)
    data.listFrameTitle = listFrameTitle;
    data.args = obj:PopTable(...);
    data.items = obj:PopTable();
    data.itemStack = C_Stack:Of("Frame")();
    data.itemStack:OnNewItem(CreateListItem);
    data.itemNames = obj:PopTable();
end

ConfigToolsPackage:DefineParams("string");
function C_ListFrame:AddRowText(data, text)
    data.rowText = data.rowText or obj:PopTable();
    data.rowText[#data.rowText + 1] = text;
end

ConfigToolsPackage:DefineParams("string");
function C_ListFrame:AddTextFieldTooltip(data, text)
    data.textFieldTooltip = text;
end

ConfigToolsPackage:DefineParams("string", "function");
---Possible scripts: OnTextChanged, OnRemoveItem, OnAddItem, OnItemEnter, OnShow
function C_ListFrame:SetScript(data, scriptName, callback)
    data[scriptName] = callback;
end

ConfigToolsPackage:DefineParams("boolean");
function C_ListFrame:SetShown(data, shown)
    if (not data.listFrame and not shown) then
        return;
    end

    if (data.listFrame) then
        data.listFrame:SetShown(shown);
        return;
    end

    data.listFrame = gui:CreateDialogBox(tk.Constants.AddOnStyle, _G["MUI_Config"], "HIGH");
    data.rows = obj:PopTable();

    gui:AddTitleBar(tk.Constants.AddOnStyle, data.listFrame, data.listFrameTitle);
    gui:AddCloseButton(tk.Constants.AddOnStyle, data.listFrame);
    data.listFrame:SetSize(400, 300);
    data.listFrame:SetPoint("CENTER");
    data.listFrame:SetFrameStrata("DIALOG");
    data.listFrame:SetFrameLevel(20);
    data.listFrame:Hide();

    local panel = gui:CreatePanel(data.listFrame);
    local row;

    if (obj:IsTable(data.rowText)) then
        local label;

        for id, rowText in ipairs(data.rowText) do
            row = panel:CreateCell();
            row:SetDimensions(1, 1);

            if (id == 1) then
                row:SetInsets(22, 10, 0, 10);
            else
                row:SetInsets(5, 10, 0, 10);
            end

            label = row:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
            label:SetText(rowText);
            label:SetPoint("LEFT");

            data.rows[#data.rows + 1] = row;
        end
    end

    data.textField = gui:CreateTextField(tk.Constants.AddOnStyle, data.textFieldTooltip, data.listFrame);
    data.textField:OnTextChanged(TextField_OnTextChanged, self, data, unpack(data.args));

    row = panel:CreateCell(data.textField);
    row:SetDimensions(1, 1);

    if (#data.rows > 0) then
        row:SetInsets(5, 10, 10, 10);
    else
        row:SetInsets(35, 5, 5, 5);
    end

    data.rows[#data.rows + 1] = row;

    local container = gui:CreateScrollFrame(tk.Constants.AddOnStyle, data.listFrame);
    data.scrollChild = container.ScrollFrame:GetScrollChild();

    container.ScrollBar:SetPoint("TOPLEFT", container.ScrollFrame, "TOPRIGHT", -5, 0);
    container.ScrollBar:SetPoint("BOTTOMRIGHT", container.ScrollFrame, "BOTTOMRIGHT", 0, 0);
    tk:SetBackground(container, 0, 0, 0, 0.3);

    row = panel:CreateCell(container);
    row:SetDimensions(1, #data.rows + 3);
    row:SetInsets(0, 5, 5, 5);

    data.rows[#data.rows + 1] = row;

    data.listFrame:SetScript("OnShow", function()
        if (obj:IsFunction(data.OnShow)) then
            data.OnShow(self, unpack(data.args));
        end
    end);

    panel:SetDimensions(1, #data.rows + 3);

    panel:AddCells(unpack(data.rows));
    obj:PushTable(data.rows);
    data.rows = nil;

    data.listFrame:SetShown(true);
end

ConfigToolsPackage:DefineParams("string");
function C_ListFrame:AddItem(data, itemName)
    if (data.itemNames[itemName]) then
        return; -- prevert duplicate items from being added
    end

    local item = data.itemStack:Pop(self, data);
    item:SetParent(data.scrollChild);
    item.name:SetText(itemName);

    table.insert(data.items, item);
    data.itemNames[itemName] = true;

    if (obj:IsFunction(data.OnAddItem)) then
        data.OnAddItem(self, item, unpack(data.args));
    end

    UpdateListFrame(data.items, data.scrollChild);
end

local function RemoveItem(data, item, index)
    table.remove(data.items, index);
    data.itemStack:Push(item);

    item:Hide();
    item:ClearAllPoints();

    data.itemNames[item.name:GetText()] = nil;

    if (obj:IsFunction(data.OnRemoveItem)) then
        data.OnRemoveItem(self, item, unpack(data.args));
    end

    UpdateListFrame(data.items, data.scrollChild);
end

ConfigToolsPackage:DefineParams("Frame");
function C_ListFrame:RemoveItem(data, item)
    local index = tk.Tables:GetIndex(data.items, item);
    RemoveItem(data, item, index);
end

ConfigToolsPackage:DefineParams("number");
function C_ListFrame:RemoveItemByIndex(data, index)
    local item = data.items[index];
    RemoveItem(data, item, index);
end