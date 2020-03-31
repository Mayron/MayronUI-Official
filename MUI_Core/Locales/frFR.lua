local L = LibStub("AceLocale-3.0"):NewLocale ("MayronUI", "frFR") 
if not L then return end 
--[[
To enable a translation, you need to uncomment the responsible line.
See https://www.lua.org/pil/1.3.html	for information of how to comment in LUA
 
To change the value fill in the translation on the right side of the equal sign.
Example:
	L["Hello!"] 						= "Hi!";
	
The spaces are not needed. They are just for alignment.
]]
-- French translations go here
-- MUI Chat
L["Hello!"]							= "Bonjour!"
L["Character"]						= "Personnage";
L["Bags"]							= "Sacs";
L["Friends"]						= "Amis";
L["Guild"]							= "Guilde";
L["Help Menu"]						= "Menu d'aide";
L["PVP"]							= "JcJ";
L["Spell Book"]						= "Grimoire / Métiers";
L["Talents"]						= "Talents";
L["Achievements"]					= "Hauts Faits";
L["Glyphs"]							= "Glyphes";
L["Calendar"]						= "Calendrier";
L["LFD"]							= "LFD";
L["Raid"]							= "Raid";
L["Encounter Journal"]				= "Guide aventurier";
L["Collections Journal"]			= "Collection";
L["Macros"]							= "Macros";
L["World Map"]						= "Carte";
L["Quest Log"]						= "Quêtes";
L["Reputation"]						= "Réputation";
L["PVP Score"]						= "Score JcJ";
L["Currency"]						= "Devises";
L["MUI Layout Button"]				= "MUI bouton de mise en page";
L["Left Click:"]					= "Clic gauche:";
L["Switch Layout"]					= "Changer la disposition";
L["Middle Click:"]					= "Clic milieu:";
L["Toggle Blizzard Speech Menu"]	= "Basculer le menu du discours Blizzard";
L["Right Click:"]					= "Clic droit:";
L["Show Layout Config Tool"]		= "Afficher l'outil de la mise en page";
L["ALT + Left Click:"]				= "ALT + Clic gauche:";
L["Toggle Tooltip"]					= "Afficher info-bulle";
--L["Edit Box (Message Input Box)"]	;
--L["Background Color"]				;
--L["Backdrop Inset"]					;
--L["Chat Frame Options"]				;
--L["Enable Chat Frame"]				;
--L["Options"]						;
--L["Button Swapping in Combat"]		;
--L["Standard Chat Buttons"]			;
--L["Left Button"]					;
--L["Middle Button"]					;
--L["Right Button"]					;
--L["Shift"]							;	-- Mod-Key!
--L["Ctrg"]							;	-- Mod-Key!
--L["Alt"]							;	-- Mod-Key!

--L["Chat Buttons with Modifier Key 1"]						;
--L["Chat Buttons with Modifier Key 2"]						;
--L["Set the border size.\n\nDefault is 1."]					;

--L["Set the spacing between the background and the border.\n\nDefault is 0."]					;
--L["Allow the use of modifier keys to swap chat buttons while in combat."]						;

-- MUI Core
--L["Failed to load MUI_Config. Possibly missing?"]			;
--L["List of slash commands:"]								;
--L["shows config menu"]										;
--L["shows setup menu"]										;
--L["Welcome back"]											;
L["Starter Edition accounts cannot perform this action."]	= "L'édition découverte ne peut pas effectuer cette action.";
L["Loot Specialization set to: Current Specialization"]		= "Choix butin de la spécialisation: Spécialisation actuelle";
L["Must be level 10 or higher to use Talents."]				= "Vous devez être niveau 10 ou plus pour utiliser les Talents.";
--L["Requires level 10+ to view the PVP window."]				;
--L["Requires level 10+ to view the Glyphs window."]			;
--L["Requires being inside a Battle Ground."]					;
--L["Choose Spec"]					= "Choix de la spécialisation";
--L["Choose Loot Spec"]				= "Choix du butin de la spécialisation";
--L["Current Spec"]					= "Spécialisation actuelle";
--L[" (current)"]						= " (actuel)";
--L["Toggle Bags"]					= "Afficher les sacs";
--L["Sort Bags"]						= "Ranger les sacs";
--L["Commands"]						= "Commandes";
--L["Armor"]							= "Armure";
--L["Head"]							= "Tête";
--L["Shoulder"]						= "Épaule";
--L["Chest"]							= "Torse";
--L["Waist"]							= "Taille";
--L["Legs"]							= "Jambes";
--L["Feet"]							= "Pieds";
--L["Wrist"]							= "Poignets";
--L["Hands"]							= "Mains";
--L["Main Hand"]						= "Arme principale";
--L["Secondary Hand"]					= "Arme secondaire";
--L["Zone"]							= "Zone";
--L["Rank"]							= "Rang";
--L["<none>"]							= "<rien>";
--L["Notes"]							= "Notes";
--L["Achievement Points"]				= "Points de Hauts Faits";
--L["No Guild"]						= "Pas de guilde";
--L["No Spec"]						= "Pas de spécialisation";
--L["Current Money"]					= "Argent actuel";
--L["Start of the day"]				= "Début de la journée";
--L["Today's profit"]					= "Profit du jour";
--L["Money per character"]			= "Argent par personnage";

-- afk
--[[
L["Guild Chat"]						;
L["Whispers"]						;

-- MUI Castbar
L[" CastBar not enabled."]			;
L["Lock"]							;
L["Unlock"]							;
L["Appearance"]						;
L["Bar Texture"]					;
L["Border"]							;
L["Border Size"]					;
L["Frame Inset"]					;
L["Colors"]							;
L["Normal Casting"]					;
L["Finished Casting"]				;
L["Interrupted"]					;
L["Latency"]						;
L["Backdrop"]						;
L["Individual Cast Bar Options"]	;
L["Enable Bar"]						;
L["Show Icon"]						;
L["Show Latency Bar"]				;
L["Anchor to SUF Portrait Bar"]		;
L["Width"]							;
L["Height"]							;
L["Frame Strata"]					;
L["Frame Level"]					;
L["Manual Positioning"]				;
L["Point"]							;
L["Relative Frame"]					;
L["Relative Point"]					;
L["X-Offset"]						;
L["Y-Offset"]						;
L["Player"]							;
L["Target"]							;
L["Focus"]							;
L["Mirror"]							;

L["If enabled the Cast Bar will be fixed to the %s Unit Frame's Portrait Bar (if it exists)."]	;
L["The %s Unit Frames's Portrait Bar needs to be enabled to use this feature."]					;
L["Only takes effect if the Cast Bar is not anchored to a SUF Portrait Bar."]					;
L["Manual positioning only works if the CastBar is not anchored to a SUF Portrait Bar."]		;

-- MUI Minimap
L["CTRL + Drag:"]					;
L["SHIFT + Drag:"]					;
L["Mouse Wheel:"]					;
L["ALT + Left Click:"]				;
L["Move Minimap"]					;
L["Resize Minimap"]					;
L["Ping Minimap"]					;
L["Show Tracking Menu"]				;
L["Show Menu"]						;
L["Zoom in/out"]					;
L["Toggle this Tooltip"]			;
L["New Event!"]						;
L["Calendar"]						;
L["Customer Support"]				;
L["Class Order Hall"]				;
L["Garrison Report"]				;
L["Tracking Menu"]					;
L["MUI Config Menu"]				;
L["MUI Installer"]					;
L["Music Player"]					;

L["Cannot access config menu while in combat."]				;

-- MUI Setup
L["Choose Theme:"]					;
L["Custom Colour"]					;
L["Theme"]							;
L["Choose Profile:"]				;
L["<new profile>"]					;
L["<remove profile>"]				;
L["Create New Profile:"]			;
L["Remove Profile:"]				;
L["Confirm"]						;
L["Cancel"]							;
L["Enabled Chat Frames:"]			;
L["Top Left"]						;
L["Top Right"]						;
L["Bottom Left"]					;
L["Bottom Right"]					;
L["Adjust the UI Scale:"]			;
L["Use Localization:"]				;
L["WoW Client: "]					;
L["AddOn Settings to Override:"]	;
L["Install"]						;
L["INSTALL"]						;
L["CUSTOM INSTALL"]					;
L["INFORMATION"]					;
L["Warning:"]						;
L["This will reload the UI!"]		;
L["Setup Menu"]						;
L["VERSION"]						;


L["This will ensure that frames are correctly positioned to match the UI scale during installation.\n\nDefault value is 0.7"]	;

-- MUI TimerBar
L["Only track your %s"]				;
L["Track all %s"]					;
L["General Options"]				;
L["Sort By Time Remaining"]			;
L["Show Tooltips On Mouseover"]		;
L["Create New Field"]				;
L["Name of New TimerBar Field:"]	;
L["Name of TimerBar Field to Remove:"]	;
L["TimerBar field '%s' created."]	;
L["TimerBar field '%s' remove."]	;
L["TimerBar field '%s' does not exist."]	;
L["Remove Field"]					;
L["Existing Timer Bar Fields"]		;
L["Enable Field"]					;
L["<%s Field>"]						;
L["Unit to Track"]					;
L["Manage Tracking Buffs"]			;
L["TargetTarget"]					;
L["FocusTarget"]					;
L["Manage Tracking Debuffs"]		;
L["Appearance Options"]				;
L["Up"]								;
L["Down"]							;
L["Bar Width"]						;
L["Bar Height"]						;
L["Bar Spacing"]					;
L["Show Icons"]						;
L["Show Spark"]						;
L["Buff Bar Color"]					;
L["Debuff Bar Color"]				;
L["Manual Positioning"]				;
L["Text Options"]					;
L["Time Remaining Text"]			;
L["Show"]							;
L["Font Size"]						;
L["Default is 11"]					;
L["Font Type"]						;
L["Spell Name Text"]				;


L["Enter the Name of a %s to Track:"]															;
L["Only %s casted by you will be tracked."]														;
L["Ignore the list of %s to track and track everything."]										;
L["Enabling this will dynamically generate the list of %s to track."]							;
L["The unit who is affected by the spell."]														;
L["The field's vertical growth direction:"]														;

-- MUI Config
L["Reload UI"]						= "";
L["General"]						= "";
L["Master Font"]					= "";
L["Enable Master Font"]				= "";
L["Display Lua Errors"]				= "";
L["Set Theme Color"]				= "";
L["Objective (Quest) Tracker"]		= "";
L["Anchor to Side Bar"]				= "";
L["Set Width"]						= "";
L["Set Height"]						= "";
L["Bottom UI Panels"]				= "";
L["Container Width"]				= "";
L["Unit Panels"]					= "";
L["Enable Unit Panels"]				= "";
L["Symmetric Unit Panels"]			= "";
L["Name Panels"]					= "";
L["Unit Panel Width"]				= "";
L["Target Class Colored"]			= "";
L["Action Bar Panel"]				= "";
L["Enable Action Bar Panel"]		= "";
L["Animation Speed"]				= "";
L["Retract Height"]					= "";
L["Expand Height"]					= "";
L["Expand and Retract Buttons"]		= "";
L["Control"]						= "Ctrl";		-- Mod-Key!
L["SUF Portrait Gradient"]			= "";
L["Enable Gradient Effect"]			= "";
L["Gradient Colors"]				= "";
L["Start Color"]					= "";
L["End Color"]						= "";
L["Target Class Colored"]			= "";
L["Bartender Action Bars"]			= "";
L["Row 1"]							= "";
L["Row 2"]							= "";
L["First Bartender Bar"]			= "";
L["Second Bartender Bar"]			= "";
L["Artifact"]						= "";
L["Reputation"]						= "";
L["XP"]								= "";
L["Enabled"]						= "";
L["Default value is "]				= "";
L["Minimum value is "]				= "";
L["true"]							= "true";
L["false"]							= "false";
L["Show Text"]						= "";
L["Data Text"]						= "";
L["General Data Text Options"]		= "";
L["Block in Combat"]				= "";
L["Auto Hide Menu in Combat"]		= "";
L["Spacing"]						= "";
L["Menu Width"]						= "";
L["Max Menu Height"]				= "";
L["Bar Strata"]						= "";
L["Bar Level"]						= "";
L["Data Text Modules"]				= "";
L["Data Button"]					= "";
L["Combat_timer"]					= "";
L["Durability"]						= "";
L["Performance"]					= "";
L["Memory"]							= "";
L["Money"]							= "";
L["Show Copper"]					= "";
L["Show Silver"]					= "";
L["Show Gold"]						= "";
L["Spec"]							= "";
L["Disabled"]						= "";
L["Blank"]							= "";
L["Module Options"]					= "";
L["Show FPS"]						= "";
L["Show Server Latency (ms)"]		= "";
L["Show Home Latency (ms)"]			= "";
L["Show Realm Name"]				= "";
L["Show Total Slots"]				= "";
L["Show Used Slots"]				= "";
L["Show Free Slots"]				= "";
L["Show Self"]						= "";
L["Show Tooltips"]					= "";
L["Side Bar"]						= "";
L["Width (With 1 Bar)"]				= "";
L["Width (With 2 Bars)"]			= "";
L["Hide in Combat"]					= "";
L["Show When"]						= "";
L["Never"]							= "";
L["Always"]							= "";
L["On Mouse-over"]					= "";
L["Bar"]							= "";

L["Uncheck to prevent MUI from changing the game font."]	= "";
L["Config type '%s' unsupported!"]							= "";
L["The UI requires reloading to apply changes."]			= "";
L["Some changes require a client restart to take effect."]	= "";
L["Warning: This will NOT change the color of CastBars!"]	= "";
L["Previously called 'Classic Mode'."]						= "";
L["Allow MUI to Control Unit Frames"]						= "";
L["Allow MUI to Control Grid"]								= "";
L["What color the gradient should start as."]				= "";
L["What color the gradient should change into."]			= "";
L["Allow MUI to Control Selected Bartender Bars"]			= "";
L["Show your character in the guild list."]					= "";
L["Adjust the width of the Bottom UI container."]			= "";
L["Adjust the width of the unit frame background panels."]	= "";
L["Adjust the width of the unit name background panels."]	= "";
L["Adjust the height of the unit name background panels."]	= "";
L["Adjust the width of the Objective Tracker."]				= "";
L["Adjust the height of the Objective Tracker."]			= "";
L["Move the unit name panels further in or out."]			= "";
L["Set the font size of unit names."]						= "";
L["The speed of the Expand and Retract transitions."]		= "";
L["The higher the value, the quicker the speed."]			= "";
L["The height of the gradient effect."]						= "";
L["Adjust the spacing between data text buttons."]			= "";
L["The frame strata of the entire DataText bar."]			= "";

L["Anchor the Objective Tracker to the action bar container on the right side of the screen."]	= "";
L["Disable this to stop MUI from controlling the Objective Tracker."]							= "";
L["Adjust the horizontal positioning of the Objective Tracker."]								= "";
L["Adjust the vertical positioning of the Objective Tracker."]									= "";
L["The font size of text that appears on data text buttons."]									= "";
L["Show guild info tooltips when the cursor is over guild members in the guild list."]			= "";
L["Set the height of the action bar panel when it\nis 'Retracted' to show 1 action bar row."]	= "";
L["Set the height of the action bar panel when it\nis 'Expanded' to show 2 action bar rows."]	= "";
L["The frame level of the entire DataText bar based on it's frame strata value."]				= "";
L["If unchecked, the entire DataText module will be disabled and all"]							= "";
L["DataText buttons, as well as the background bar, will not be displayed."]					= "";
L["Prevents you from using data text modules while in combat."]									= "";
L["This is useful for 'clickers'."]																= "";
L["If the SUF Player or Target portrait bars are enabled, a class"]								= "";
L["colored gradient will overlay it."]															= "";
]]

L["TT_MUI_CONTROL_SUF"]				=
[[If enabled, MUI will reposition the Shadowed Unit
Frames to fit over the top of the MUI Unit Panels.

It will also automatically move the Unit Frames when
expanding and retracting the MUI Action Bar Panel.]];

L["TT_MUI_CONTROL_GRID"]			=
[[|cff00ccffImportant:|r Only for the |cff00ccff'MayronUIH' Grid Profile|r (used in the Healing Layout)!

If enabled, MUI will reposition the Grid Frame to fit on top of the MUI Unit Panels.

It will also automatically move the Grid Frame when expanding and retracting the
MUI Action Bar Panel.]];

L["TT_MUI_CONTROL_BARTENDER"]		=
[[If enabled, MUI will reposition the selected Bartender
bars to fit over the top of the action bar panel.

It will also control the fading in and out transitions
of selected row 2 Bartender bars when expanding and
retracting the MUI Action Bar Panel.]];

L["TT_MUI_USE_TARGET_CLASS_COLOR"] =
[[If checked, the target portrait gradient will use the target's class
color instead of using the 'Start Color' RGB values. It will
still use the Alpha and 'End Color' RGB values.]];

L["Show Overview"] = "Afficher l'aperçu";
L["Show Reset Options"] = "Afficher les options de réinitialisation";
L["Reset All Characters"] = "Réinitialiser tous les caractères";
L["Reset Options"] = "Options de réinitialisation";
L["All currency data has been reset."] = "Toutes les données sur les devises ont été réinitialisées.";
L["Currency data for %s has been reset."] = "Les données de devise pour %s ont été réinitialisées.";
L["Are you sure you want to reset the currency data for all of your characters?"] =
"Voulez-vous vraiment réinitialiser les données de devise pour tous vos personnages?";
L["Are you sure you want to reset the currency data for %s?"] =
"Voulez-vous vraiment réinitialiser les données de devise pour %s?";

L["Change Status"] = "Changer le statut";
L["Remove from Whitelist"] = "Supprimer de la liste blanche";
L["Add to Blacklist"] = "Ajouter à la liste noire";

L["Removing %s from the whitelist will hide this timer bar if the whitelist is enabled."] =
"La suppression de %s de la liste blanche masquera cette barre de temporisation si la liste blanche est activée.";

L["Adding %s to the blacklist will hide this timer bar if the blacklist is enabled."] =
"L'ajout de %s à la liste noire masquera cette barre de temporisation si la liste noire est activée.";

L["Are you sure you want to do this?"] = "Es-tu sûr de vouloir faire ça?";

L["%s has been removed from the whitelist."] = "%s has been removed from the whitelist.";
L["%s has been added to the blacklist."] = "%s a été ajouté à la liste noire.";

L["Filters"] = "Filtres";
L["Only show buffs applied by me"] = "Afficher uniquement les buffs appliqués par moi";
L["Only show debuffs applied by me"] = "Afficher uniquement les debuffs appliqués par moi";
L["Enable Whitelist"] = "Activer la liste blanche";
L["Configure Whitelist"] = "Configurer la liste blanche";
L["Enable Blacklist"] = "Activer la liste noire";
L["Configure Blacklist"] = "Configurer la liste noire";