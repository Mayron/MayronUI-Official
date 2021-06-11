------------------------
--- STEP 1: Prepare other language
------------------------

-- Find: L\["(.*)"\] = ".*";
-- Replace: "$1",
-- to remove extra and get only keys
-- Then run this script:

local OtherLanguageValues = {
  "应用缩放",
  "显示 MUI 键绑定",
  "教程：第 2 步",
  "教程：第 1 步",
  "打开配置菜单",
  "配置",
  "单元框架面板",
  "工具提示",
  "显示食物和饮料",
  "如果选中,食物和饮料buff将显示为一个castbar。",
  "混合模式",
  "更改混合模式将影响 Alpha 通道与背景混合的方式。",
  "背景",
  "按钮",
  "战斗计时器",
  "寻求",
  "音量选项",
  "专业化",
  "显示剩余时间未知的光环",
  "显示爱好者",
  "显示减益",
  "刷新聊天文本",
};

------------------------
--- STEP 2:
------------------------
local EnglishKeys = {
  "Apply Scaling",
  "Show MUI Key Bindings",
  "Tutorial: Step 2",
  "Tutorial: Step 1",
  "Open Config Menu",
  "Config",
  "Unit Frame Panels",
  "Tooltips",
  "Show Food and Drink",
  "If checked, the food and drink buff will be displayed as a castbar.",
  "Blend Mode",
  "Changing the blend mode will affect how alpha channels blend with the background.",
  "Background",
  "Button",
  "Combat Timer",
  "Quest",
  "Volume Options",
  "Specialization",
  "Show Auras With Unknown Time Remaining",
  "Show Buffs",
  "Show Debuffs",
  "Refresh Chat Text",
};

------------------------
--- STEP 3: Print!
------------------------
for id, key in ipairs(EnglishKeys) do
  local value = OtherLanguageValues[id];
  print("L[\"" .. key .. "\"] = \"" .. value .. "\";");
end