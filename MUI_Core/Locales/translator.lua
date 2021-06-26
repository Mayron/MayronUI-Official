------------------------
--- STEP 1: Prepare other language
------------------------

-- Find: L\["(.*)"\](\s+)?= ".*";
-- Replace: "$1",
-- to remove extra and get only keys
-- Then run this script:

local OtherLanguageValues = {
};

------------------------
--- STEP 2:
------------------------
local EnglishKeys = {
};

------------------------
--- STEP 3: Print!
------------------------
for id, key in ipairs(EnglishKeys) do
  local value = OtherLanguageValues[id];
  print("L[\"" .. key .. "\"] = \"" .. value .. "\";");
end

print("END")