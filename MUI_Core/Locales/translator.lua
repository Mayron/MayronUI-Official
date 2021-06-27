------------------------
--- STEP 1: Prepare other language
------------------------

-- Find: L\["(.*)"\](\s+)?= ".*";
-- Replace: "$1",
-- to remove extra and get only keys
-- Then run this script:

local OtherLanguageValues = {
  "No se puede eliminar el perfil predeterminado.",
  "¿Estás seguro de que deseas eliminar el perfil '%s'?",
  "ELIMINAR",
  "Escriba '%s' para confirmar:",
  "Ingrese un nuevo nombre de perfil único:",
  "Perfil actual:",
  "Mostrar el menú de configuración MUI",
  "Mostrar el instalador de MUI",
  "Mostrar todos los perfiles",
  "Mostrar el administrador de perfiles MUI",
  "Establecer perfil",
  "Mostrar perfil activo actualmente",
  "Mostrar la versión de MUI",
  "Mostrar la herramienta de diseño MUI",
};

------------------------
--- STEP 2:
------------------------
local EnglishKeys = {
  "Cannot delete the Default profile.",
  "Are you sure you want to delete profile '%s'?",
  "DELETE",
  "Please type '%s' to confirm:",
  "Enter a new unique profile name:",
  "Current Profile:",
  "Show the MUI Config Menu",
  "Show the MUI Installer",
  "List All Profiles",
  "Show the MUI Profile Manager",
  "Set Profile",
  "Show Currently Active Profile",
  "Show the Version of MUI",
  "Show the MUI Layout Tool",
};

------------------------
--- STEP 3: Print!
------------------------
for id, key in ipairs(EnglishKeys) do
  local value = OtherLanguageValues[id];
  print("L[\"" .. key .. "\"] = \"" .. value .. "\";");
end

print("END")