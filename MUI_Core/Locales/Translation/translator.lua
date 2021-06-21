------------------------
--- STEP 1: Prepare other language
------------------------

-- Find: L\["(.*)"\] = ".*";
-- Replace: "$1",
-- to remove extra and get only keys
-- Then run this script:

local OtherLanguageValues = {
  "主容器包含单元框架面板、操作栏面板、数据文本栏和屏幕底部的所有资源栏。",
   "添加文本突出显示",
   "频道名称别名",
   "文本突出显示",
   "别名亮度",
   "拍卖行开放",
   "拍卖行关闭",
   "闹钟警告1",
   "闹钟警告2",
   "闹钟警告3",
   "进入队列",
   "珠宝制作插座",
   "抢钱",
   "地图平",
   "队列准备就绪",
   "突袭警告",
   "突袭boss警告",
   "准备检查",
   "维修项目",
   "耳语收到",
};

------------------------
--- STEP 2:
------------------------
local EnglishKeys = {
  "The main container holds the unit frame panels, action bar panels, data-text bar, and all resource bars at the bottom of the screen.",
  "Add Text Highlighting",
  "Channel Name Aliases",
  "Text Highlighting",
  "Alias Brightness",
  "Auction House Open",
  "Auction House Close",
  "Alarm Clock Warning 1",
  "Alarm Clock Warning 2",
  "Alarm Clock Warning 3",
  "Enter Queue",
  "Jewel Crafting Socket",
  "Loot Money",
  "Map Ping",
  "Queue Ready",
  "Raid Warning",
  "Raid Boss Warning",
  "Ready Check",
  "Repair Item",
  "Whisper Received",
};

------------------------
--- STEP 3: Print!
------------------------
for id, key in ipairs(EnglishKeys) do
  local value = OtherLanguageValues[id];
  print("L[\"" .. key .. "\"] = \"" .. value .. "\";");
end