------------------------
--- STEP 1: Prepare other language
------------------------

-- Find: (.*)
-- Replace: "$1",

local OtherLanguageValues = {
"定位和可見性選項",
"配置每種類型的錨點和工具提示類型",
"將工具提示分配給鼠標錨點會將它們固定到您的鼠標光標，使它們跟隨您的鼠標移動。",
"將工具提示分配給屏幕錨點會將它們固定到該單個點並且不會移動。",
"世界單位是世界中的 3D 播放器模型，不是 UI 的一部分。",
"單位框架工具提示是代表 NPC 或玩家的 UI 框架。",
"標準工具提示是任何其他沒有特殊類別的工具提示（即庫存物品和法術工具提示有自己獨特的類別，不會受到影響）。",
"單位框架工具提示",
"世界單位工具提示",
"標準工具提示",
"選擇錨點：",
"可見性選項：",
"設置顯示",
"如果未選中，則永遠不會顯示此類工具提示",
"如果未選中，則在戰鬥中不會顯示此類工具提示。",
"隱藏在戰鬥中",
"老鼠",
"屏幕",
"鼠標錨點",
"屏幕錨點",
"導出配置文件",
"將當前配置文件導出為其他玩家可以導入的字符串。",
"複製下面的導入字符串並將其提供給其他玩家，以便他們可以導入您當前的個人資料。",
"關閉",
"導入配置文件",
"從導入字符串中導入另一個玩家的配置文件。",
"將導入字符串粘貼到下面的框中以導入配置文件。",
"警告：這將用導入的配置文件設置完全替換您當前的配置文件！",
"已成功將配置文件設置導入您當前的配置文件！",
};

------------------------
--- STEP 2:
------------------------
local EnglishKeys = {
"Positioning and Visibility Options",
"Configure each type of anchor point and tooltip type",
"Assigning tooltips to the mouse anchor point will fix them to your mouse cursor, causing them to follow your mouse movements.",
"Assigning tooltips to the screen anchor point will fix them to that single spot and will not move.",
"World units are 3D player models within the world and are not part of the UI.",
"Unit frame tooltips are the UI frames that represent NPCs or players.",
"Standard tooltips are any other tooltip with no special category (i.e., inventory item and spell tooltips have their own unique category and will not be affected).",
"Unit Frame Tooltips",
"World Unit Tooltips",
"Standard Tooltips",
"Choose an Anchor Point:",
"Visibility Options:",
"Set Shown",
"If unchecked, tooltips of this type will never show",
"If unchecked, tooltips of this type will not show while you are in combat.",
"Hide in Combat",
"Mouse",
"Screen",
"Mouse Anchor Point",
"Screen Anchor Point",
"Export Profile",
"Export the current profile into a string that can be imported by other players.",
"Copy the import string below and give it to other players so they can import your current profile.",
"Close",
"Import Profile",
"Import a profile from another player from an import string.",
"Paste an import string into the box below to import a profile.",
"Warning: This will completely replace your current profile with the imported profile settings!",
"Successfully imported profile settings into your current profile!",
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