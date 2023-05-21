------------------------
--- STEP 1: Prepare other language
------------------------

-- Find: (.*)\n
-- Replace: "$1";\n

local OtherLanguageValues = {
"外觀設置";
"設置 MUI 框架顏色";
"控制 MUI 框架的背景顏色，包括庫存框架、工具提示、配置菜單、佈局工具等。";
"設置顯示模式";
"這些設置與各個光環圖標/欄相關。";
"這些設置與包含各個光環圖標/欄的框架相關。";
"設置非玩家 Alpha";
"圖標寬度";
"圖標高度";
"如果為 true，當光環接近到期時，光環框架將淡入淡出。";
"您未應用的光環的阿爾法。";
"圖標間距";
"顯示欄火花";
"容器框架設置";
"定位";
"行和列";
"每行顯示的光環圖標的最大數量。";
"要顯示的水平條形列的最大數量。";
"文本設置";
"光環框";
"圖標框";
"圖標";
"正常字號";
"警告字體大小";
"警告閾值";
"剩餘時間文本使用警告字體大小所需的最小剩餘秒數。";
"文字顏色";
"光環類型顏色";
"基本增益";
"玩家擁有的增益";
"您為自己應用的增益效果。";
"基本減益";
"條形顏色";
"邊框";
"啟用庫存框架";
"使用 MayronUI 自定義庫存框架而不是默認的暴雪包 UI。";
"使用類顏色";
"如果選中，其他玩家的工具提示將根據他們的職業著色。";
"切換到詳細視圖";
"查看角色清單";
"切換包袋欄";
"任務物品";
"貿易商品";
"耗材";
"設備";
"所有項目"
};

------------------------
--- STEP 2:
------------------------
local EnglishKeys = {
"Appearance Settings";
"Set MUI Frames Color";
"Controls the background color of MUI frames, including the inventory frame, tooltips, config menu, layout tool and more.";
"Set Display Mode";
"These settings relate to the individual aura icons/bars.";
"These settings relate to the frame containing the individual aura icons/bars.";
"Set Non-Player Alpha";
"Icon Width";
"Icon Height";
"If true, when the aura is close to expiring the aura frame will fade in and out.";
"The alpha of auras not applied by you.";
"Icon Spacing";
"Show Bar Spark";
"Container Frame Settings";
"Positioning";
"Rows and Columns";
"The maximum number of aura icons to display per row.";
"The maximum number of horizontal bar columns to display.";
"Text Settings";
"Aura Frame";
"Icon Frame";
"Icon";
"Normal Font Size";
"Warning Font Size";
"Warning Threshold";
"The minimum number of seconds remaining required for the time remaining text to use the warning font size.";
"Text Colors";
"Aura Type Colors";
"Basic Buff";
"Player Owned Buff";
"Buffs that you applied to yourself.";
"Basic Debuff";
"Bar Colors";
"Borders";
"Enable Inventory Frame";
"Use the MayronUI custom inventory frame instead of the default Blizzard bags UI.";
"Use Class Colors";
"If checked, tooltips for other players will be colored based on their class.";
"Switch to Detailed View";
"View Character Inventory";
"Toggle Bags Bar";
"Quest Items";
"Trade Goods";
"Consumables";
"Equipment";
"All Items";
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