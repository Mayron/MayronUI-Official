------------------------
--- STEP 1: Prepare other language
------------------------

-- Find: ;
-- Replace: "$1",
-- to remove extra and get only keys
-- Then run this script:

local OtherLanguageValues = {
  "온라인 친구 표시";
  "친구 목록 토글";
  "길드 회원 표시";
  "길드 창 토글";
  "퀘스트";
};

------------------------
--- STEP 2:
------------------------
local EnglishKeys = {
  "Show Online Friends";
  "Toggle Friends List";
  "Show Guild Members";
  "Toggle Guild Pane";
  "Quests";
};



------------------------
--- STEP 3: Print!
------------------------
for id, key in ipairs(EnglishKeys) do
  local value = OtherLanguageValues[id];
  print("L[\"" .. key .. "\"] = \"" .. value .. "\";");
end