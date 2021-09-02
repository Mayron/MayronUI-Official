------------------------
--- STEP 1: Prepare other language
------------------------

-- Find: ;
-- Replace: "$1",
-- to remove extra and get only keys
-- Then run this script:

local OtherLanguageValues = {
  "Вы уверены, что хотите сбросить данные о деньгах для всех ваших персонажей?";
  "Все денежные данные сброшены.";
  "Вы уверены, что хотите сбросить данные о деньгах для %s?";
  "Данные о деньгах для %s сброшены.";
};

------------------------
--- STEP 2:
------------------------
local EnglishKeys = {
  "Are you sure you want to reset the money data for all of your characters?";
  "All money data has been reset.";
  "Are you sure you want to reset the money data for %s?";
  "Money data for %s has been reset.";
};

------------------------
--- STEP 3: Print!
------------------------
for id, key in ipairs(EnglishKeys) do
  local value = OtherLanguageValues[id];
  print("L[\"" .. key .. "\"] = \"" .. value .. "\";");
end