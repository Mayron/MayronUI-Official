------------------------
--- STEP 1: Prepare other language
------------------------

-- Find: L\["(.*)"\] = ".*";
-- Replace: "$1",
-- to remove extra and get only keys
-- Then run this script:

local OtherLanguageValues = {
  "Spectacle",
  "Cacher",
  "Activer le mode test",
  "Désactiver le mode test",
  "Position de l'icône",
  "Si coché, ce module sera activé.",
  "Le mode test vous permet de personnaliser facilement l'apparence et le positionnement des widgets en forçant tous les widgets à être affichés.",
  "Mini-carte Widgets",
  "L'horloge",
  "Difficulté du donjon",
  "Recherche d'icône de groupe",
  "Nouvelle icône de courrier",
  "Icône des missions",
  "Ce bouton ouvre le menu de missions le plus pertinent pour votre personnage. Le menu affichera soit les missions de votre Sanctum du Pacte, votre salle d'ordre de classe ou votre garnison.",
  "Icône de suivi",
  "Lorsqu'il est masqué, vous pouvez toujours accéder aux options de suivi à partir du menu contextuel de la mini-carte.",
  "Nom de la zone",
};

------------------------
--- STEP 2:
------------------------
local EnglishKeys = {
"Show",
"Hide",
"Enable Test Mode",
"Disable Test Mode",
"Icon Position",
"If checked, this module will be enabled.",
"Test mode allows you to easily customize the looks and positioning of widgets by forcing all widgets to be shown.",
"Mini-Map Widgets",
"Clock",
"Dungeon Difficulty",
"Looking For Group Icon",
"New Mail Icon",
"Missions Icon",
"This button opens the most relevant missions menu for your character. The menu will either show missions for your Covenant Sanctum, Class Order Hall, or your Garrison.",
"Tracking Icon",
"When hidden, you can still access tracking options from the Minimap right-click menu.",
"Zone Name",
};

------------------------
--- STEP 3: Print!
------------------------
for id, key in ipairs(EnglishKeys) do
  local value = OtherLanguageValues[id];
  print("L[\"" .. key .. "\"] = \"" .. value .. "\";");
end