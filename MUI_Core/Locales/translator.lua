------------------------
--- STEP 1: Prepare other language
------------------------

-- Find: L\["(.*)"\](\s+)?= ".*";
-- Replace: "$1",
-- to remove extra and get only keys
-- Then run this script:

local OtherLanguageValues = {
  "在重新加載 UI 之前，某些設置不會更改。",
  "您現在要重新加載用戶界面嗎？",
  "重新加載用戶界面",
  "不",
  "配置文件已更改為 %s。",
  "配置文件 %s 已被重置。",
};

------------------------
--- STEP 2:
------------------------
local EnglishKeys = {
  "Some settings will not be changed until the UI has been reloaded.",
  "Would you like to reload the UI now?",
  "Reload UI",
  "No",
  "Profile changed to %s.",
  "Profile %s has been reset.",
};

------------------------
--- STEP 3: Print!
------------------------
for id, key in ipairs(EnglishKeys) do
  local value = OtherLanguageValues[id];
  print("L[\"" .. key .. "\"] = \"" .. value .. "\";");
end

print("END")