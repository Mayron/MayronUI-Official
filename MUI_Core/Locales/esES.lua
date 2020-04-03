local L = LibStub("AceLocale-3.0"):NewLocale ("MayronUI", "esES");
if not L then return end

--[[
To change the value fill in the translation on the right side of the equal sign.
Example:
	L["Hello!"] = "Hi!";
]]

-- translations go here
-- MUI Chat
L["Hello!"] 						= "Hola!";
L["Character"]						= "Personaje";
L["Bags"]							= "Bolsa";
L["Friends"]						= "Amigos";
L["Guild"]							= "Hermandad";
L["Help Menu"]						= "Ayuda";
L["PVP"]							= "PVP";
L["Spell Book"]						= "Libro de hechizos";
L["Talents"]						= "Talentos";
L["Achievements"]					= "Logros";
L["Glyphs"]							= "Glifos";
L["Calendar"]						= "Calendario";
L["LFD"]							= "LFD";
L["Raid"]							= "Raid";
L["Encounter Journal"]				= "Diario de encuentro";
L["Collections Journal"]			= "Diario de colecciones";
L["Macros"]							= "Macros";
L["World Map"]						= "Mapa del mundo";
L["Quest Log"]						= "Registro de misiones";
L["Reputation"]						= "Reputación";
L["PVP Score"]						= "Puntuación PVP";
L["Currency"]						= "Moneda";
L["MUI Layout Button"]				= "Botón de diseño de MUI";
L["Left Click:"]					= "Click izquierdo:";
L["Switch Layout"]					= "Cambiar diseño";
L["Middle Click:"]					= "Clic medio:";
L["Toggle Blizzard Speech Menu"]	= "Alternar el menú de voz de Blizzard";
L["Right Click:"]					= "Botón derecho del ratón";
L["Show Layout Config Tool"]		= "Mostrar herramienta de configuración de diseño";
L["ALT + Left Click:"]				= "ALT + clic izquierdo";
L["Toggle Tooltip"]					= "Alternar información sobre herramientas";
L["Edit Box (Message Input Box)"]	= "Cuadro de edición (cuadro de entrada de mensaje)";
L["Background Color"]				= "Color de fondo";
L["Backdrop Inset"]					= "Recuadro de fondo";
L["Chat Frame Options"]				= "Opciones de marco de chat";
L["Enable Chat Frame"]				= "Habilitar marco de chat";
L["Options"]						= "Opciones";
L["Button Swapping in Combat"]		= "Intercambiar botones en combate";
L["Standard Chat Buttons"]			= "Botones de chat estándar";
L["Left Button"]					= "Botón izquierdo";
L["Middle Button"]					= "Botón central";
L["Right Button"]					= "Botón derecho";
L["Shift"]							= "Cambio";	-- Mod-Key!
L["Ctrg"]							= "Ctrg";		-- Mod-Key!
L["Alt"]							= "Alt";		-- Mod-Key!

L["Chat Buttons with Modifier Key 1"]			= "Botones de chat con tecla modificadora 1";
L["Chat Buttons with Modifier Key 2"]			= "Botones de chat con tecla modificadora 2";
L["Set the border size.\n\nDefault is 1."]		= "Establezca el tamaño del borde. \n\n El valor predeterminado es 1.";
L["Cannot toggle menu while in combat."] 		= "No puedes entrar en combate.";
L["Cannot switch layouts while in combat."]		= "No puedes cambiarte en combate.";

L["Set the spacing between the background and the border.\n\nDefault is 0."]
	= "Establezca el espacio entre el fondo y el borde. \n\nEl valor predeterminado es 0.";

L["Allow the use of modifier keys to swap chat buttons while in combat."]
	= "Permite el uso de teclas modificadoras para intercambiar botones de chat mientras estás en combate.";

-- MUI Core
L["Failed to load MUI_Config. Possibly missing?"]			= "Error al cargar MUI_Config. ¿Lo tienes activado en Addons?";
L["List of slash commands:"]								= "Barra de comandos";
L["shows config menu"]										= "Mosrar el menú de configuración";
L["shows setup menu"]										= "Mosrar el menú de configuración";
L["Welcome back"]											= "Bienvenido de nuevo";
L["Starter Edition accounts cannot perform this action."]	= "Las cuentas que no disponen de una suscripción, no pueden hacer esta acción.";
L["Loot Specialization set to: Current Specialization"]		= "Botin establecido en: Especialización actual.";
L["Must be level 10 or higher to use Talents."]				= "Necesitas ser nivel 10 para utilizar los talentos.";
L["Requires level 10+ to view the PVP window."]				= "Necesitas ser nivel 10 para poder activar el modo PVP.";
L["Requires level 10+ to view the Glyphs window."]			= "Necesitas ser nivel 10 para poder utilizar glifos.";
L["Requires being inside a Battle Ground."]					= "Solo lo puedes usar en un campo de batalla PVP.";

L["Choose Spec"]					= "Elige especialización.";
L["Choose Loot Spec"]				= "Especialización botin.";
L["Current Spec"]					= "Especialización";
L[" (current)"]						= "Activo: (corriente)";
L["Toggle Bags"]					= "Abrir bolsa";
L["Sort Bags"]						= "Ordenar bolsa";
L["Commands"]						= "Leyenda:";
L["Armor"]							= "Armadura";
L["Head"]							= "Salud";
L["Shoulder"]						= "Hombro";
L["Chest"]							= "Torso";
L["Waist"]							= "Cintura";
L["Legs"]							= "Piernas";
L["Feet"]							= "Pies";
L["Wrist"]							= "Muñecas";
L["Hands"]							= "Manos";
L["Main Hand"]						= "Mano derecha";
L["Secondary Hand"]					= "Mano izquierda";
L["Zone"]							= "Zona";
L["Rank"]							= "Rango";
L["<none>"]							= "<Ninguno>";
L["Notes"]							= "Notas";
L["Achievement Points"]				= "Logros";
L["No Guild"]						= "Sin Hermandad.";
L["No Spec"]						= "Sin especialización.";
L["Current Money"]					= "Dinero actual";
L["Start of the day"]				= "Al empezar el dia";
L["Today's profit"]					= "Ganado hoy";
L["Money per character"]			= "Dinero por personaje";

-- afk
L["Guild Chat"]						= "Chat de Hermandad";
L["Whispers"]						= "Susurros";

-- MUI Castbar
L[" CastBar not enabled."]			= "CastBar deshabilitado";
L["Lock"]							= "Bloquear";
L["Unlock"]							= "debloqueado";
L["Appearance"]						= "Apariencia";
L["Bar Texture"]					= "Apariencia de las barras";
L["Border"]							= "Borde";
L["Border Size"]					= "Tamaño del borde";
L["Frame Inset"]					= "Recuadro";
L["Colors"]							= "Colores";
L["Normal Casting"]					= "Cast normal";
L["Finished Casting"]				= "Finalizando Cast";
L["Interrupted"]					= "Interrumpir";
L["Latency"]						= "Latencia";
L["Backdrop"]						= "Fondo";
L["Individual Cast Bar Options"]	= "Opciones del CastBar Indiviual";
L["Enable Bar"]						= "Habilitar barras";
L["Show Icon"]						= "Mostrar iconos";
L["Show Latency Bar"]				= "Mostrar barra de latencia";
L["Anchor to SUF Portrait Bar"]		= "Bloquear barra SUF ";
L["Width"]							= "Ancho";
L["Height"]							= "Altura";
L["Frame Strata"]					= "";
L["Frame Level"]					= "";
L["Manual Positioning"]				= "Posicionamiento manual";
L["Point"]							= "Punto";
L["Relative Frame"]					= "Marco relativo";
L["Relative Point"]					= "Punto relativo";
L["X-Offset"]						= "X Offset";
L["Y-Offset"]						= "Y Offset";
L["Player"]							= "Jugador";
L["Target"]							= "Objetivo";
L["Focus"]							= "Enfoque";
L["Mirror"]							= "Duplicar";

L["If enabled the Cast Bar will be fixed to the %s Unit Frame's Portrait Bar (if it exists)."]	= "Cuando esta activo, la barra de conversión se fijará a la barra vertical de %s Unit Frame (si existe).";
L["The %s Unit Frames's Portrait Bar needs to be enabled to use this feature."]					= "Debe de estar activa la barra vertical de cuadros de %s para utilizar esta función.";
L["Only takes effect if the Cast Bar is not anchored to a SUF Portrait Bar."]					= "Solo se activara si Cast Bar no está anclado a una barra vertical SUF.";
L["Manual positioning only works if the CastBar is not anchored to a SUF Portrait Bar."]		= "Solo lo puedes usar si no esta anclado en una barra vertial SUF";

-- MUI Minimap
L["CTRL + Drag:"]					= "";
L["SHIFT + Drag:"]					= "";
L["Mouse Wheel:"]					= "";
L["ALT + Left Click:"]				= "";
L["Move Minimap"]					= "Mover Mini mapa";
L["Resize Minimap"]					= "Reajustar el Mini mapa";
L["Ping Minimap"]					= "";
L["Show Tracking Menu"]				= "Mostrar Boton de rastreo";
L["Show Menu"]						= "Mostrar Menú";
L["Zoom in/out"]					= "Zoom +/-";
L["Toggle this Tooltip"]			= "Abrir herramientas";
L["New Event!"]						= "Nuevo evento";
L["Calendar"]						= "Calendario";
L["Customer Support"]				= "Asistencia";
L["Class Order Hall"]				= "Sala de Clase";
L["Garrison Report"]				= "";
L["Tracking Menu"]					= "Menu rastreo";
L["MUI Config Menu"]				= "Configurar MUI";
L["MUI Installer"]					= "Instalador MUI";
L["Music Player"]					= "Musica personaje";

L["Cannot access config menu while in combat."]	= "No puedes acceder en combate.";

-- MUI Setup
L["Choose Theme:"]					= "Elige clase";
L["Custom Colour"]					= "Crea el tema";
L["Theme"]							= "Tema";
L["Choose Profile:"]				= "Elige personaje";
L["<new profile>"]					= "<Nuevo perfil>";
L["<remove profile>"]				= "<Eliminar perfil>";
L["Create New Profile:"]			= "Crear nuevo personaje";
L["Remove Profile:"]				= "Eliminar pesonaje";
L["Confirm"]						= "Aceptar";
L["Cancel"]							= "Cancelar";
L["Enabled Chat Frames:"]			= "Activar marcos del chat";
L["Top Left"]						= "Arriba izquierda";
L["Top Right"]						= "Arriba derecha";
L["Bottom Left"]					= "Abajo izquierda";
L["Bottom Right"]					= "Abajo derecha";
L["Adjust the UI Scale:"]			= "Ajusta el tamaño de la interfaz";
L["Use Localization:"]				= "Localizar";
L["WoW Client: "]					= "Original en WOW";
L["AddOn Settings to Override:"]	= "Addons adicionales:";
L["Install"]						= "Instalar";
L["INSTALL"]						= "Instalar";
L["CUSTOM INSTALL"]					= "Instalación personalizada";
L["INFORMATION"]					= "Información";
L["Warning:"]						= "¡Cuidado:";
L["This will reload the UI!"]		= "Esta acción sobrescribirá la interfaz !.";
L["Setup Menu"]						= "Menu configuración";
L["VERSION"]						= "Versión";

L["This will ensure that frames are correctly positioned to match the UI scale during installation.\n\nDefault value is 0.7"]
	= "Hace que ajusten los marcos con la interfaz del usuario durante la instalacion.\n\nLa configuración por defecto es 0.7";

-- MUI TimerBar
L["Only track your %s"]				= "Mostrar solo %s";
L["Track all %s"]					= "Rastrear todo %s";
L["General Options"]				= "Opciones generales";
L["Sort By Time Remaining"]			= "Ordenar por tiempo restante";
L["Show Tooltips On Mouseover"]		= "Mostrar información al pasar el raton encima";
L["Create New Field"]				= "Crear nuevo";
L["Name of New TimerBar Field:"]	= "Nombre del nuevo TimerBar ";
L["Name of TimerBar Field to Remove:"]	= "Eliminar nombre del TimerBar";
L["TimerBar field '%s' created."]	= "TimerBar '%s' Creado";
L["TimerBar field '%s' remove."]	= "TimerBar '%s' Eliminado";
L["TimerBar field '%s' does not exist."]	= "El TimeBar '%s' no existe.";
L["Remove Field"]					= "Eliminar";
L["Existing Timer Bar Fields"]		= "Ya existe el TimerBar";
L["Enable Field"]					= "Mostrar campos";
L["<%s Field>"]						= "<Campo %s>";
L["Unit to Track"]					= "Rastrear";
L["Manage Tracking Buffs"]			= "Opciones Buffs";
L["TargetTarget"]					= "Objetivo";
L["FocusTarget"]					= "Centrar objetivo";
L["Manage Tracking Debuffs"]		= "Opciones Debuffs";
L["Appearance Options"]				= "Configurar apariencia";
L["Up"]								= "Arriba";
L["Down"]							= "Abajo";
L["Bar Width"]						= "Ancho barra";
L["Bar Height"]						= "Alto barra";
L["Bar Spacing"]					= "Espacio entre barras";
L["Show Icons"]						= "Mostrar iconos";
L["Show Spark"]						= "Mostrar destello";
L["Buff Bar Color"]					= "Color barra Buff";
L["Debuff Bar Color"]				= "Color barra Debuff";
L["Manual Positioning"]				= "Posicionamiento manual";
L["Text Options"]					= "Opciones del texto";
L["Time Remaining Text"]			= "Texto tiempo restante";
L["Show"]							= "Mostrar";
L["Font Size"]						= "Tamaño fuente";
L["Default is 11"]					= "Por defecto es 11";
L["Font Type"]						= "Tipografia";
L["Spell Name Text"]				= "Nombre del hechizo ";

L["Enter the Name of a %s to Track:"]									= "Introduce el nombre %s para buscarlo:";
L["Only %s casted by you will be tracked."]								= "Solo expondrá los lanzado por usted.";
L["Ignore the list of %s to track and track everything."]				= "Ignorar de la lista y rastrear todo";
L["Enabling this will dynamically generate the list of %s to track."]	= "Activa lista %s para rastrear";
L["The unit who is affected by the spell."]								= "Afectados por un hechizo.";
L["The field's vertical growth direction:"]								= "Crecimiento vertial:";

-- MUI Config
L["Reload UI"]						= "Recargar interfaz";
L["General"]						= "General";
L["Master Font"]					= "Fuente principal";
L["Enable Master Font"]				= "Activar fuentes principales";
L["Display Lua Errors"]				= "Mostrar fallos de Lua";
L["Set Theme Color"]				= "Colores del tema";
L["Objective (Quest) Tracker"]		= "Seguimiento de misiones";
L["Anchor to Side Bar"]				= "Anclar a barra lateral";
L["Set Width"]						= "Ancho";
L["Set Height"]						= "Alto";
L["Bottom UI Panels"]				= "Paneles inferiores de la IU";
L["Container Width"]				= "Ancho del recuadro.";
L["Unit Panels"]					= "Panel";
L["Enable Unit Panels"]				= "Activar paneles";
L["Symmetric Unit Panels"]			= "Igualar paneles";
L["Name Panels"]					= "Nombre paneles";
L["Unit Panel Width"]				= "Anchura del panel";
L["Target Class Colored"]			= "Color de la clase del objetivo";
L["Action Bar Panel"]				= "Panel barra de acción";
L["Enable Action Bar Panel"]		= "Habilitar panel de acción";
L["Animation Speed"]				= "Velocidad en la animación";
L["Retract Height"]					= "Replegar Ancho";
L["Expand Height"]					= "Expandir Alto";
L["Expand and Retract Buttons"]		= "Expandir o replegar botones";
L["Control"]						= "Strg";		-- Mod-Key!
L["SUF Portrait Gradient"]			= "Degrado de color en SUF";
L["Enable Gradient Effect"]			= "Activar efecto degragado";
L["Gradient Colors"]				= "Colores degradados";
L["Start Color"]					= "Color de inicio";
L["End Color"]						= "Color terminado";
L["Target Class Colored"]			= "Clase del objetivo coloreado";
L["Bartender Action Bars"]			= "Barras del Bartender";
L["Row 1"]							= "Fila 1";
L["Row 2"]							= "Fila 2";
L["First Bartender Bar"]			= "Barra principal";
L["Second Bartender Bar"]			= "Barra segundaria";
L["Artifact"]						= "Artefacto";
L["Reputation"]						= "Reputación";
L["XP"]								= "Experiencia";
L["Enabled"]						= "Activado";
L["Default value is "]				= "Valor por defecto es ";
L["Minimum value is "]				= "Valor minimo por defecto es ";
L["true"]							= "Si";
L["false"]							= "No";
L["Show Text"]						= "Mostrar texto";
L["Data Text"]						= "Datos";
L["General Data Text Options"]		= "Opciones de texto";
L["Block in Combat"]				= "Bloqueado en combate";
L["Auto Hide Menu in Combat"]		= "Ocultar automaticamente en combate";
L["Spacing"]						= "Espaciado";
L["Menu Width"]						= "Menú anchura";
L["Max Menu Height"]				= "Maxima altura menú";
L["Bar Strata"]						= "Capas barras";
L["Bar Level"]						= "Nivel barras";
L["Data Text Modules"]				= "Modulos de texto";
L["Data Button"]					= "Boton de datos";
L["Combat_timer"]					= "Tiempo en combate";
L["Durability"]						= "Durabilidad";
L["Performance"]					= "Rendimiento";
L["Memory"]							= "Memoria";
L["Money"]							= "Dinero";
L["Show Copper"]					= "Mostrar Cobre";
L["Show Silver"]					= "Mostrar Plata";
L["Show Gold"]						= "Mostrar Oro";
L["Spec"]							= "Especialización";
L["Disabled"]						= "Dehabilitado";
L["Blank"]							= "Blanco";
L["Module Options"]					= "Opciones del modulo";
L["Show FPS"]						= "Mostrar FPS";
L["Show Server Latency (ms)"]		= "Mostrar latencia dle servidor (ms)";
L["Show Home Latency (ms)"]			= "Mostrar tu latencia (ms)";
L["Show Realm Name"]				= "Mostrar nombre del reino";
L["Show Total Slots"]				= "Mostrar espacio total";
L["Show Used Slots"]				= "Mostrar espacios usados";
L["Show Free Slots"]				= "Mostrar espacios libres";
L["Show Self"]						= "Mostrarme";
L["Show Tooltips"]					= "Mostrar configuracion";
L["Side Bar"]						= "Tamaño barras";
L["Width (With 1 Bar)"]				= "Ancho (con 1 barra)";
L["Width (With 2 Bars)"]			= "Ancho (con 2 barras)";
L["Hide in Combat"]					= "Ocultar en combate";
L["Show When"]						= "Mostrar cuando";
L["Never"]							= "Nunca";
L["Always"]							= "Siempre";
L["On Mouse-over"]					= "Mostrar al pasar el raton";
L["Bar"]							= "Barra";

L["Uncheck to prevent MUI from changing the game font."]	= "Desmarcarlo para que MUI no cambie la fuente del juego.";
L["Config type '%s' unsupported!"]							= "¡La configuración '%s' no es compatible !";
L["The UI requires reloading to apply changes."]			= "Requiere reiniciar la interfaz para aplicar cambios";
-- L["Some changes require a client restart to take effect."]	= "";
-- L["Warning: This will NOT change the color of CastBars!"]	= "";
-- L["Previously called 'Classic Mode'."]						= "";
-- L["Allow MUI to Control Unit Frames"]						= "";
-- L["Allow MUI to Control Grid"]								= "";
-- L["What color the gradient should start as."]				= "";
-- L["What color the gradient should change into."]			= "";
-- L["Allow MUI to Control Selected Bartender Bars"]			= "";
-- L["Show your character in the guild list."]					= "";
-- L["Adjust the width of the Bottom UI container."]			= "";
-- L["Adjust the width of the unit frame background panels."]	= "";
-- L["Adjust the width of the unit name background panels."]	= "";
-- L["Adjust the height of the unit name background panels."]	= "";
-- L["Adjust the width of the Objective Tracker."]				= "";
-- L["Adjust the height of the Objective Tracker."]			= "";
-- L["Move the unit name panels further in or out."]			= "";
-- L["Set the font size of unit names."]						= "";
-- L["The speed of the Expand and Retract transitions."]		= "";
-- L["The higher the value, the quicker the speed."]			= "";
-- L["The height of the gradient effect."]						= "";
-- L["Adjust the spacing between data text buttons."]			= "";
-- L["The frame strata of the entire DataText bar."]			= "";

-- L["Anchor the Objective Tracker to the action bar container on the right side of the screen."]	= "";
-- L["Disable this to stop MUI from controlling the Objective Tracker."]							= "";
-- L["Adjust the horizontal positioning of the Objective Tracker."]								= "";
-- L["Adjust the vertical positioning of the Objective Tracker."]									= "";
-- L["The font size of text that appears on data text buttons."]									= "";
-- L["Show guild info tooltips when the cursor is over guild members in the guild list."]			= "";
-- L["Set the height of the action bar panel when it\nis 'Retracted' to show 1 action bar row."]	= "";
-- L["Set the height of the action bar panel when it\nis 'Expanded' to show 2 action bar rows."]	= "";
-- L["The frame level of the entire DataText bar based on it's frame strata value."]				= "";
-- L["If unchecked, the entire DataText module will be disabled and all"]							= "";
-- L["DataText buttons, as well as the background bar, will not be displayed."]					= "";
-- L["Prevents you from using data text modules while in combat."]									= "";
-- L["This is useful for 'clickers'."]																= "";
-- L["If the SUF Player or Target portrait bars are enabled, a class"]								= "";
-- L["colored gradient will overlay it."]															= "";

L["TT_MUI_CONTROL_SUF"] =
[[Si está activado, MUI moverá los fotogramas de la unidad sombreada adecuadamente a su IU.

Se ajustará automáticamente las posiciones cuando la interfaz del usuario sea inferior 
expandido sobre se reduce.]];

L["TT_MUI_CONTROL_GRID"]			=
[[|cff00ccffWichtig:|r Gild nur für das |cff00ccff'MayronUIH' Grid Profil |r (wird im Heiler-Layout benutzt)!

Cuando MUI esta activado, colocará la ventana de la cuadrícula sobre la ventana de destino.
Se ajustará automáticamente las posiciones cuando la interfaz del usuario sea inferior
expandido sobre se reduce.]];

L["TT_MUI_CONTROL_BARTENDER"]		=
[[Cuando MUI esta activado, moverá las barras del Bartender seleccionadas para que
que encajan en la interfaz de usuario.

En las animaciones de transición, también se tendrán en cuenta el posicionamiento de las barras de acción.]];

L["TT_MUI_USE_TARGET_CLASS_COLOR"] =
[[Si el gradiente se activa, utilizará los colores de clase del objetivo en lugar de los predefinidos.
Sin embargo, los valores alfa y el color final todavía estaran en uso]];

-- L["Show Overview"] = "";
-- L["Show Reset Options"] = "";
-- L["Reset All Characters"] = "";
-- L["Reset Options"] = "";

-- L["All currency data has been reset."] = ""
-- L["Currency data for %s has been reset."] = "";
-- L["Are you sure you want to reset the currency data for all of your characters?"] = "";
-- L["Are you sure you want to reset the currency data for %s?"] = "";

-- L["Change Status"] = "";
-- L["Remove from Whitelist"] = "";
-- L["Add to Blacklist"] = "";

-- L["Removing %s from the whitelist will hide this timer bar if the whitelist is enabled."] = "";

-- L["Adding %s to the blacklist will hide this timer bar if the blacklist is enabled."] = "";

-- L["Are you sure you want to do this?"] = "";

-- L["%s has been removed from the whitelist."] = "%s ";
-- L["%s has been added to the blacklist."] = "%s ";

-- L["Filters"] = "";
-- L["Only show buffs applied by me"] = "";
-- L["Only show debuffs applied by me"] = "";
-- L["Enable Whitelist"] = "";
-- L["Configure Whitelist"] = "";
-- L["Enable Blacklist"] = "";
-- L["Configure Blacklist"] = "";

L["MUI_Setup_InfoTab"] = [[
Visit our Discord community:
%s

The official homepage for MayronUI Gen6 is:
%s

The official GitHub repo:
%s

Become a Patreon and earn exclusive benefits within the community:
%s

Visit Mayron's official YouTube channel:
%s


|cff00ccff> SLASH COMMANDS|r

|cff00ccff/mui|r - List all MayronUI slash commands (including "install", "config" and "profile" commands)
|cff00ccff/rl|r - Reloads the UI
|cff00ccff/tiptac|r - Show TipTac (Tooltips) AddOn settings
|cff00ccff/ltp|r - Leatrix Plus settings (I recommend looking through them!)
|cff00ccff/suf|r - Settings for the Unit Frames (Shadowed Unit Frames)
|cff00ccff/bt|r - Bartender Settings (Action Bars)

|cff00ccff> F.A.Q's|r

|cff00ccffQ: How do I open up the Calendar? / How do I toggle the Tracker?|r

|cff90ee90A:|r Right click the Mini-Map and select the option to do this in the drop down menu.

|cff00ccffQ: How can I see more action bars on the bottom of the UI like in the screen shots?|r

|cff90ee90A:|r You need to press and hold the Control key while out of combat to show the Expand and Retract button.

|cff00ccffQ: How do I enable the Timestamps on the Chat Box?|r

|cff90ee90A:|r I removed this feature when Blizzard added this themselves in the Blizzard Interface Options. Go to the Interface in-game menu and go to "Social" then there is a drop down menu with the title "Chat Timestamps". Change this from "None" to a format that suits you.

|cff00ccffQ: How do I turn off/on Auto Quest? Or how do I turn on auto repair?|r

|cff90ee90A:|r That is controlled by Leatrix Plus (Leatrix Plus also offers many other useful features and is worth checking out!). You can open the Leatrix Plus menu to view these by right clicking the Minimap and selecting Leatrix Plus or by typing "/ltp".

|cff00ccffQ: The tooltip shows over my spells when I hover my mouse cursor over them, how can I move it to the Bottom Right corner like the other tooltips do?|r

|cff90ee90A:|r Type "/tiptac" and go to the Anchors page from the list on the left. Where it says "Frame Tip Type" you will see a drop down menu on the right. Change it from "Mouse Anchor" to "Normal Anchor".
]]

L["MUI_Setup_CreditsTab"] = [[
Special thanks goes to the following MayronUI community members for their contributions towards the project (see the information tab for the link to join our Discord community):

|cff00ccff> Patreons|r
%s

|cff00ccff> Development and Bug Fixes|r
%s

|cff00ccff> Translation Support|r
%s

|cff00ccff> Community Support Team|r
%s

And of course, thank you to the authors of the non-MayronUI AddOns included in this UI pack.
]]