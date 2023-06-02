------------------------
--- STEP 1: Prepare other language
------------------------

-- Find: (.*)\n
-- Replace: "$1";\n

local OtherLanguageValues = {
"填充";
"插槽高度";
"最大槽寬";
"最小槽寬";
"顯示物品等級";
"如果選中，物品等級將顯示在裝備和武器物品圖標的頂部。";
"使用網格視圖調整庫存框架大小時每行可以顯示的最大圖標數。";
"每行最大圖標數";
"顯示任務物品標籤";
"顯示貿易商品標籤";
"顯示耗材選項卡";
"顯示設備選項卡";
"顯示選項卡按鈕";
"選項卡按鈕選項";
"MUI 框架顏色";
"主題色";
"班級顏色";
"配色方案";
"字體選項";
"顯示項目名稱";
"項目名稱字體大小";
"如果選中，物品等級將顯示在設備和武器物品的描述中。";
"顯示項目類型";
"項目 描述 字體大小";
"網格視圖";
"詳細視圖"
};

------------------------
--- STEP 2:
------------------------
local EnglishKeys = {
"Padding";
"Slot Height";
"Max Slot Width";
"Min Slot Width";
"Show Item Levels";
"If checked, item levels will show on top of the icons of equipment and weapon items.";
"The maximum number of icons that can appear per row when resizing the inventory frame using the grid view.";
"Max Icons Per Row";
"Show Quest Items Tab";
"Show Trade Goods Tab";
"Show Consumables Tab";
"Show Equipment Tab";
"Show Tab Buttons";
"Tab Button Options";
"MUI Frames Color";
"Theme Color";
"Class Color";
"Color Scheme";
"Font Options";
"Show Item Name";
"Item Name Font Size";
"If checked, item levels will be shown in description of equipment and weapon items.";
"Show Item Type";
"Item Description Font Size";
"Grid View";
"Detailed View"
};

------------------------
--- STEP 3: Print!
------------------------
local output = "";
for id, key in ipairs(EnglishKeys) do
  local value = OtherLanguageValues[id];
  output = output .. "L[\"" .. key .. "\"] = \"" .. value .. "\";\n";
end

print(output); -- don't view output in terminal! Use `"console": "internalConsole",` and check Debug Console in VS Code
print("Finished!");