local L = LibStub("AceLocale-3.0"):NewLocale ("MayronUI", "frFR");
if not L then return end

--[[
To change the value fill in the translation on the right side of the equal sign.
Example:
	L["Hello!"] = "Hi!";
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
L["Spell Book"]						= "Grimoire";
L["Talents"]						= "Talents";
L["Achievements"]					= "Hauts Faits";
L["Glyphs"]							= "Glyphes";
L["Calendar"]						= "Calendrier";
L["LFD"]							= "LFD";
L["Raid"]							= "Raid";
L["Encounter Journal"]				= "Journal de rencontre";
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
L["Edit Box (Message Input Box)"]	= "Zone d'édition (zone de saisie de message)";
L["Background Color"]				= "Couleur du fond";
L["Backdrop Inset"]					= "Encart de fond";
L["Chat Frame Options"]				= "Options de la fenêtre de chat";
L["Enable Chat Frame"]				= "Activer la fenêtre de chat";
L["Options"]						= "Options";
L["Button Swapping in Combat"]		= "Échange de boutons en combat";
L["Standard Chat Buttons"]			= "Boutons du chat par défaut";
L["Left Button"]					= "Bouton gauche";
L["Middle Button"]					= "Bouton du milieu";
L["Right Button"]					= "Bouton droit";
L["Shift"]							= "Maj";	-- Mod-Key!
L["Ctrg"]							= "Ctrg";		-- Mod-Key!
L["Alt"]							= "Alt";		-- Mod-Key!

L["Chat Buttons with Modifier Key 1"]			= "Boutons du chat avec la touche de modification 1";
L["Chat Buttons with Modifier Key 2"]			= "Boutons du chat avec la touche de modification 2";
L["Set the border size.\n\nDefault is 1."]		= "Définissez la taille de la bordure.\n\nLa valeur par défaut est 1.";
L["Cannot toggle menu while in combat."] 		= "Impossible de basculer de menu lorsque vous êtes en combat.";
L["Cannot switch layouts while in combat."]		= "Impossible de changer de disposotion lorsque vous êtes en combat.";

L["Set the spacing between the background and the border.\n\nDefault is 0."]
	= "Définissez l'espacement entre l'arrière-plan et la bordure.\n\nLa valeur par défaut est 0.";

L["Allow the use of modifier keys to swap chat buttons while in combat."]
	= "Autorisez l'utilisation des touches de modification pour échanger les boutons du chat pendant le combat.";

-- MUI Core
L["Failed to load MUI_Config. Possibly missing?"]			= "Impossible de lancer MUI_Config. Fichier manquant?";
L["List of slash commands:"]								= "Liste des commandes slash:";
L["shows config menu"]										= "Montrer le menu de configuration";
L["shows setup menu"]										= "Montrer le menu d'installation";
L["Welcome back"]											= "Bon retour";
L["Starter Edition accounts cannot perform this action."]	= "L'édition découverte ne peut pas effectuer cette action.";
L["Loot Specialization set to: Current Specialization"]		= "Choix butin de la spécialisation: Spécialisation actuelle";
L["Must be level 10 or higher to use Talents."]				= "Vous devez être niveau 10 ou plus pour utiliser les Talents.";
L["Requires level 10+ to view the PVP window."]				= "Vous devez être niveau 10 ou plus pour voir la fenêtre JcJ.";
L["Requires level 10+ to view the Glyphs window."]			= "Vous devez être niveau 10 ou plus pour voir la fenêtre des Glyphes.";
L["Requires being inside a Battle Ground."]					= "Vous devez être dans une instance JcJ.";

L["Choose Spec"]					= "Choix de la spécialisation";
L["Choose Loot Spec"]				= "Choix du butin de la spécialisation";
L["Current Spec"]					= "Spécialisation actuelle";
L[" (current)"]						= " (actuel)";
L["Toggle Bags"]					= "Afficher les sacs";
L["Sort Bags"]						= "Ranger les sacs";
L["Commands"]						= "Commandes";
L["Armor"]							= "Armure";
L["Head"]							= "Tête";
L["Shoulder"]						= "Épaule";
L["Chest"]							= "Torse";
L["Waist"]							= "Taille";
L["Legs"]							= "Jambes";
L["Feet"]							= "Pieds";
L["Wrist"]							= "Poignets";
L["Hands"]							= "Mains";
L["Main Hand"]						= "Arme principale";
L["Secondary Hand"]					= "Arme secondaire";
L["Zone"]							= "Zone";
L["Rank"]							= "Rang";
L["<none>"]							= "<rien>";
L["Notes"]							= "Notes";
L["Achievement Points"]				= "Points de Hauts Faits";
L["No Guild"]						= "Pas de guilde";
L["No Spec"]						= "Pas de spécialisation";
L["Current Money"]					= "Argent actuel";
L["Start of the day"]				= "Début de la journée";
L["Today's profit"]					= "Profit du jour";
L["Money per character"]			= "Argent par personnage";

-- afk
L["Guild Chat"]						= "Discussion de guilde";
L["Whispers"]						= "Chuchotement";

-- MUI Castbar
L[" CastBar not enabled."]			= "Barre de sorts désactivé";
L["Lock"]							= "Verrouillé";
L["Unlock"]							= "Déverrouillé";
L["Appearance"]						= "Apparence";
L["Bar Texture"]					= "Texture de la barre";
L["Border"]							= "Bordure";
L["Border Size"]					= "Taille de la bordure";
L["Frame Inset"]					= "Encart du cadre";
L["Colors"]							= "Couleurs";
L["Normal Casting"]					= "Incantation normale";
L["Not Interruptible"]					= "Non interruptible";
L["Finished Casting"]				= "Incantation finie";
L["Interrupted"]					= "Interrompu";
L["Latency"]						= "Latence";
L["Backdrop"]						= "Toile de fond";
L["Individual Cast Bar Options"]	= "Options individuelles de la barre de sorts";
L["Enable Bar"]						= "Activer la barre";
L["Show Icon"]						= "Montrer l'icone";
L["Show Latency Bar"]				= "Montrer la latence";
L["Anchor to SUF Portrait Bar"]		= "Ancrage à la barre de portrait SUF";
L["Width"]							= "Largeur";
L["Height"]							= "Hauteur";
L["Frame Strata"]					= "Couches du cadre";
L["Frame Level"]					= "Niveau du cadre";
L["Manual Positioning"]				= "Positionnement manuel";
L["Point"]							= "Point d'ancrage";
L["Relative Frame"]					= "Cadre relatif";
L["Relative Point"]					= "Point relatif";
L["X-Offset"]						= "X Offset";
L["Y-Offset"]						= "Y Offset";
L["Player"]							= "Joueur";
L["Target"]							= "Cible";
L["Focus"]							= "Focus";
L["Mirror"]							= "Miroir";
L["Pet"] = "Familier";

L["If enabled the Cast Bar will be fixed to the %s Unit Frame's Portrait Bar (if it exists)."]
	= "Si activé la barre de sort sera fixée à la barre de portrait de %s (si elle existe)";

L["The %s Unit Frames's Portrait Bar needs to be enabled to use this feature."]
	= "La barre de portrait de %s a besoin d'être activé pour utiliser cette fonctionnalité";

L["Only takes effect if the Cast Bar is not anchored to a SUF Portrait Bar."]
	= "Prend seulement effet si la barre de sort n'est pas ancrée à une barre de portrait de SUF";

L["Manual positioning only works if the CastBar is not anchored to a SUF Portrait Bar."]
	= "Le positionnement manuel ne fonctionne uniquement que si la barre de sort n'est pas ancrée à une barre de portrait de SUF";

-- MUI Minimap
L["CTRL + Drag:"]					= "CTRL + Déplacer:";
L["SHIFT + Drag:"]					= "MAJ + Déplacer:";
L["Mouse Wheel:"]					= "Molette de la souris:";
L["ALT + Left Click:"]				= "ALT + Clic gauche";
L["Move Minimap"]					= "Bouger la Minicarte";
L["Resize Minimap"]					= "Redimensionner la Minicarte";
L["Ping Minimap"]					= "Ping la Minicarte";
L["Show Tracking Menu"]				= "Montrer le menu de traque";
L["Show Menu"]						= "Montrer le menu";
L["Zoom in/out"]					= "Zoom avant/arrière";
L["Toggle this Tooltip"]			= "Afficher cette info-bulle";
L["New Event!"]						= "Nouvel événement!";
L["Calendar"]						= "Calendrier";
L["Customer Support"]				= "Assistance clientèle";
L["Class Order Hall"]				= "Rapport du domaine";
L["Garrison Report"]				= "Rapport de garnison";
L["Tracking Menu"]					= "Menu de traque";
L["MUI Config Menu"]				= "Menu de configuration MUI";
L["MUI Installer"]					= "Installateur MUI";
L["Music Player"]					= "Lecteur de musique";

L["Cannot access config menu while in combat."]
	= "Vous ne pouvez pas accéder au menu de configuration lorsque vous êtes en combat.";

-- MUI Setup
L["Choose Theme:"]					= "Choix du thème:";
L["Custom Colour"]					= "Couleur personalisée";
L["Theme"]							= "Thème";
L["Choose Profile:"]				= "Choix du profil:";
L["<new profile>"]					= "<Nouveau profil>";
L["<remove profile>"]				= "<Supprimer le profil>";
L["Create New Profile:"]			= "Créer un nouveau profil";
L["Remove Profile:"]				= "Supprimer le profil:";
L["Confirm"]						= "Confirmer";
L["Cancel"]							= "Annuler";
L["Enabled Chat Frames:"]			= "Activer les fenêtres de chat:";
L["Top Left"]						= "En haut à gauche";
L["Top Right"]						= "En haut à droite";
L["Bottom Left"]					= "En bas à gauche";
L["Bottom Right"]					= "En bas à droite";
L["Adjust the UI Scale:"]			= "Ajuster l'échelle de l'interface";
L["Use Localization:"]				= "Utiliser la localisation:";
L["WoW Client: "]					= "Client WoW: ";
L["AddOn Settings to Override:"]	= "Options des addons à passer outre:";
L["Install"]						= "Installation";
L["INSTALL"]						= "INSTALLATION";
L["CUSTOM INSTALL"]					= "Installation personalisée";
L["INFORMATION"]					= "INFORMATION";
L["Warning:"]						= "Attention:";
L["This will reload the UI!"]		= "Ceci rechargera votre interface!";
L["Setup Menu"]						= "Menu d'installation";
L["VERSION"]						= "VERSION";


L["This will ensure that frames are correctly positioned to match the UI scale during installation.\n\nDefault value is 0.7"]
	= "Cela garantira que les cadres sont correctement positionnés pour correspondre à l'échelle de l'interface utilisateur lors de l'installation.\n\nLa valeur par défaut est 0.7";

-- MUI TimerBar
L["Only track your %s"]				= "Traquer uniquement vos %s";
L["Track all %s"]					= "Traquer tous les %s";
L["General Options"]				= "Options générales";
L["Sort By Time Remaining"]			= "Trier par temps restant";
L["Show Tooltips On Mouseover"]		= "Afficher info-bulle sur le curseur";
L["Create New Field"]				= "Créer une nouvelle zone";
L["Name of New TimerBar Field:"]	= "Nom de la nouvelle barre d'aura:";
L["Name of TimerBar Field to Remove:"]	= "Nom de la barre d'aura à supprimer:";
L["TimerBar field '%s' created."]	= "Zone de la barre d'aura '%s' créée.";
L["TimerBar field '%s' remove."]	= "Zone de la barre d'aura '%s' supprimée.";
L["TimerBar field '%s' does not exist."]	= "Zone de la barre d'aura '%s' inexistante.";
L["Remove Field"]					= "Supprimer la zone";
L["Existing Timer Bar Fields"]		= "Zones de barres d'aura existantes";
L["Enable Field"]					= "Activer la zone";
L["<%s Field>"]						= "<Zone %s>";
L["Unit to Track"]					= "Unité à suivre";
L["Manage Tracking Buffs"]			= "Gérer les Buffs à traquer";
L["TargetTarget"]					= "Cible de la cible";
L["FocusTarget"]					= "Cible du focus";
L["Manage Tracking Debuffs"]		= "Gérer les Debuff à traquer";
L["Appearance Options"]				= "Options de l'apparence";
L["Up"]								= "Vers le haut";
L["Down"]							= "Vers le bas";
L["Bar Width"]						= "Largeur de la barre";
L["Bar Height"]						= "Longeur de la barre";
L["Bar Spacing"]					= "Espacement des barres";
L["Show Icons"]						= "Afficher les icônes";
L["Show Spark"]						= "Afficher la lueur";
L["Buff Bar Color"]					= "Couleur des barres de buff";
L["Debuff Bar Color"]				= "Couleur des barres de debuff";
L["Manual Positioning"]				= "Positionnement manuel";
L["Text Options"]					= "Options du texte";
L["Time Remaining Text"]			= "Temps restant";
L["Show"]							= "Afficher";
L["Font Size"]						= "Taille de police";
L["Default is 11"]					= "La valeur par défaut est 11";
L["Font Type"]						= "Police";
L["Spell Name Text"]				= "Nom du sort";

L["Enter the Name of a %s to Track:"]									= "Entrer le nom du %s à traquer:";
L["Only %s casted by you will be tracked."]								= "Uniquement l'incantation %s effectuée par vous sera traquée";
L["Ignore the list of %s to track and track everything."]				= "Ignorer la liste des %s à traquer et tout traquer ";
L["Enabling this will dynamically generate the list of %s to track."]	= "Activer ceci générera dynamiquement la liste des %s à traquer";
L["The unit who is affected by the spell."]								= "L'unité affectée par le sort.";
L["The field's vertical growth direction:"]								= "La direction de croissance verticale du champ:";

-- MUI Config
L["Reload UI"]						= "Recharger l'interface utilisateur";
L["General"]						= "Général";
L["Master Font"]					= "Police principale";
L["Enable Master Font"]				= "Activer la police principale";
L["Display Lua Errors"]				= "Afficher les erreurs LUA";
L["Set Theme Color"]				= "Définir la couleur du thème";
L["Objective (Quest) Tracker"]		= "Traqueur d'objectifs (quête)";
L["Anchor to Side Bar"]				= "Ancrage à la barre du côté";
L["Set Width"]						= "Définir la largeur";
L["Set Height"]						= "Définir la hauteur";
L["Bottom UI Panels"]				= "Panneaux d'interface utilisateur inférieurs";
L["Container Width"]				= "Largeur du conteneur";
L["Unit Panels"]					= "Panneaux d'unité";
L["Enable Unit Panels"]				= "Activer les panneaux d'unité";
L["Symmetric Unit Panels"]			= "Panneaux d'unités symétriques";
L["Name Panels"]					= "Panneaux des noms";
L["Unit Panel Width"]				= "Largeur du panneau de l'unité";
L["Target Class Colored"]			= "Classe de la cible colorée";
L["Action Bar Panel"]				= "Panneau de barre d'actions";
L["Enable Panel"]		= "Activer le panneau de la barre d'actions";
L["Animation Speed"]				= "Vitesse d'animation";
L["Retract Height"]					= "Rétracter la hauteur";
L["Expand Height"]					= "Développer la hauteur";
L["Expand and Retract Buttons"]		= "Développer et rétracter les boutons";
L["Control"]						= "Ctrl";		-- Mod-Key!
L["SUF Portrait Gradient"]			= "Dégradé du portrait SUF";
L["Enable Gradient Effect"]			= "Activer l'effet de dégradé";
L["Gradient Colors"]				= "Couleurs dégradées";
L["Start Color"]					= "Couleur de départ";
L["End Color"]						= "Couleur de fin";
L["Target Class Colored"]			= "Classe de la cible colorée";
L["Bartender Action Bars"]			= "Barres d'action de Bartender";
L["Row"]							= "Rangée";
L["First Bartender Bar"]			= "Première barre d'action de Bartender";
L["Second Bartender Bar"]			= "Seconde barre d'action de Bartender";
L["Artifact"]						= "Artéfact";
L["Reputation"]						= "Réputation";
L["XP"]								= "XP";
L["Enabled"]						= "Activé";
L["Default value is "]				= "La valeur par défaut est ";
L["Minimum value is "]				= "La valeur minimale est ";
L["true"]							= "Vrai";
L["false"]							= "Faux";
L["Show Text"]						= "Afficher le texte";
L["Data Text"]						= "Texte des données";
L["General Data Text Options"]		= "Options générales des données";
L["Block in Combat"]				= "Bloquer en combat";
L["Auto Hide Menu in Combat"]		= "Masquer automatiquement le menu en combat";
L["Spacing"]						= "Espacement";
L["Menu Width"]						= "Largeur du menu";
L["Max Menu Height"]				= "Hauteur maximale du menu";
L["Bar Strata"]						= "Couches des barres";
L["Bar Level"]						= "Niveaux des barres";
L["Data Text Modules"]				= "Modules de texte de données";
L["Data Button"]					= "Bouton de données";
L["Combat_timer"]					= "Temps de combat";
L["Durability"]						= "Durabilité";
L["Performance"]					= "Performance";
L["Memory"]							= "Mémoire";
L["Money"]							= "Devises";
L["Show Copper"]					= "Afficher les pièces de cuivre";
L["Show Silver"]					= "Afficher les pièces d'argent";
L["Show Gold"]						= "Afficher les pièces d'or";
L["Spec"]							= "Spécialisation";
L["Disabled"]						= "Désactivé";
L["Blank"]							= "Vide";
L["Module Options"]					= "Options des modules";
L["Show FPS"]						= "Afficher IPS";
L["Show Server Latency (ms)"]		= "Afficher la latence serveur (ms)";
L["Show Home Latency (ms)"]			= "Afficher la latence client (ms)";
L["Show Realm Name"]				= "Afficher le nom du royaume";
L["Show Total Slots"]				= "Afficher le total des emplacements";
L["Show Used Slots"]				= "Afficher les emplacements utilisés";
L["Show Free Slots"]				= "Afficher les emplacements libres";
L["Show Self"]						= "Afficher soi-même";
L["Show Tooltips"]					= "Afficher les info-bulles";
L["Side Bar"]						= "Barre de côté";
L["Width (With 1 Bar)"]				= "Largeur (avec 1 barre)";
L["Width (With 2 Bars)"]			= "Largeur (avec 2 barres)";
L["Hide in Combat"]					= "Masquer en combat";
L["Show When"]						= "Afficher quand";
L["Never"]							= "Jamais";
L["Always"]							= "Toujours";
L["On Mouse-over"]					= "Au survol de la souris";
L["Bar"]							= "Barre";

L["Uncheck to prevent MUI from changing the game font."]	= "Décochez pour empêcher MUI de changer la police du jeu.";
L["Config type '%s' unsupported!"]							= "Type de configuration '%s' non pris en charge!";
L["The UI requires reloading to apply changes."]			= "L'interface utilisateur nécessite un rechargement pour appliquer les modifications.";
L["Some changes require a client restart to take effect."]	= "Certaines modifications nécessitent un redémarrage du client pour prendre effet.";
L["Warning: This will NOT change the color of CastBars!"]	= "Attention: cela ne changera PAS la couleur des barres de sorts!";
L["Previously called 'Classic Mode'."]						= "Anciennement appelé 'Mode Classique'.";
L["Allow MUI to Control Unit Frames"]						= "Autoriser MUI à contrôler les cadres d'unité";
L["Allow MUI to Control Grid"]								= "Autoriser MUI à contrôler la grille";
L["What color the gradient should start as."]				= "Par quelle couleur le dégradé doit commencer.";
L["What color the gradient should change into."]			= "Par quelle couleur le dégradé doit-elle changer.";
L["Allow MUI to Control Selected Bartender Bars"]			= "Autoriser MUI à contrôler les barres de Bartender sélectionnées";
L["Show your character in the guild list."]					= "Montrez votre personnage dans la liste de guilde.";
L["Adjust the width of the Bottom UI container."]			= "Ajustez la largeur du conteneur de l'interface utilisateur inférieure.";
L["Adjust the width of the unit frame background panels."]	= "Réglez la largeur des panneaux d'arrière-plan du cadre de l'unité.";
L["Adjust the width of the unit name background panels."]	= "Ajustez la largeur des panneaux d'arrière-plan du nom de l'unité.";
L["Adjust the height of the unit name background panels."]	= "Ajustez la hauteur des panneaux d'arrière-plan du nom de l'unité.";
L["Adjust the width of the Objective Tracker."]				= "Ajustez la largeur du traqueur d'objectifs.";
L["Adjust the height of the Objective Tracker."]			= "Ajustez la Hauteur du traqueur d'objectifs.";
L["Move the unit name panels further in or out."]			= "Déplacez les panneaux de nom d'unité vers l'intérieur ou l'extérieur.";
L["Set the font size of unit names."]						= "Définissez la taille de police des noms d'unité.";
L["The speed of the Expand and Retract transitions."]		= "La vitesse des transitions des développements et rétractations";
L["The higher the value, the quicker the speed."]			= "Plus la valeur est élevée, plus la vitesse est rapide.";
L["The height of the gradient effect."]						= "La hauteur de l'effet de dégradé.";
L["Adjust the spacing between data text buttons."]			= "Ajustez l'espacement entre les boutons de texte de données.";
L["The frame strata of the entire DataText bar."]			= "Les couches de cadre de toute la barre de texte de données.";

L["Anchor the Objective Tracker to the action bar container on the right side of the screen."]	= "Ancrez le traqueur d'objectifs au conteneur de la barre d'actions sur le côté droit de l'écran.";
L["Disable this to stop MUI from controlling the Objective Tracker."]							= "Désactivez cette option pour empêcher MUI de contrôler le traqueur d'objectifs.";
L["Adjust the horizontal positioning of the Objective Tracker."]								= "Ajustez le positionnement horizontal du traqueur d'objectif.";
L["Adjust the vertical positioning of the Objective Tracker."]									= "Ajustez le positionnement vertical du traqueur d'objectif.";
L["The font size of text that appears on data text buttons."]									= "La taille de police du texte qui apparaît sur les boutons de texte de données.";
L["Show guild info tooltips when the cursor is over guild members in the guild list."]			= "Afficher les info-bulles d'informations sur la guilde lorsque le curseur se trouve sur les membres de la guilde dans la liste de guilde.";
L["Set the height of the action bar panel when it\nis 'Retracted' to show 1 action bar row."]	= "Définissez la hauteur du panneau de la barre d'actions lorsqu'il est 'rétracté' pour afficher 1 ligne de barre d'actions.";
L["Set the height of the action bar panel when it\nis 'Expanded' to show 2 action bar rows."]	= "Définissez la hauteur du panneau de la barre d'actions lorsqu'il est 'développé pour afficher 2 lignes de barre d'actions.";
L["The frame level of the entire DataText bar based on it's frame strata value."]				= "Le niveau de cadre de toute le texte de données sont basés sur la valeur des couches de cadre.";
L["If unchecked, the entire DataText module will be disabled and all"]							= "Si décoché, tout le module de texte de données sera désactivé et tout";
L["DataText buttons, as well as the background bar, will not be displayed."]					= "Les boutons des textes de données, ainsi que la barre d'arrière-plan, ne seront pas affichés.";
L["Prevents you from using data text modules while in combat."]									= "Vous empêche d'utiliser des modules de texte de données pendant le combat.";
L["This is useful for 'clickers'."]																= "Ceci est utile pour les 'clickers'.";

L["If the SUF Player or Target portrait bars are enabled, a class colored gradient will overlay it."]
	= "Si les barres de portraits SUF du joueur ou de la cible sont activées, une classe Le dégradé coloré le superposera.";

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
L["Reset All Characters"] = "Réinitialiser tous les personnages";
L["Reset Options"] = "Options de réinitialisation";
L["All currency data has been reset."] = "Toutes les données sur les devises ont été réinitialisées.";
L["Currency data for %s has been reset."] = "Les données des devises pour %s ont été réinitialisées.";
L["Are you sure you want to reset the currency data for all of your characters?"] = "Voulez-vous vraiment réinitialiser les données des devises pour tous vos personnages?";
L["Are you sure you want to reset the currency data for %s?"] = "Voulez-vous vraiment réinitialiser les données des devises pour %s?";

L["Change Status"] = "Changer le statut";
L["Remove from Whitelist"] = "Supprimer de la liste blanche";
L["Add to Blacklist"] = "Ajouter à la liste noire";

L["Removing %s from the whitelist will hide this timer bar if the whitelist is enabled."] = "La suppression de %s de la liste blanche masquera cette barre de temps si la liste blanche est activée.";

L["Adding %s to the blacklist will hide this timer bar if the blacklist is enabled."] = "L'ajout de %s à la liste noire masquera cette barre de temps si la liste noire est activée.";

L["Are you sure you want to do this?"] = "Êtes-vous-vous sûr de vouloir faire ça?";

L["%s has been removed from the whitelist."] = "%s a été enlevé de la liste blanche.";
L["%s has been added to the blacklist."] = "%s a été ajouté à la liste noire.";

L["Filters"] = "Filtres";
L["Only show buffs applied by me"] = "Afficher uniquement les buffs appliqués par moi";
L["Only show debuffs applied by me"] = "Afficher uniquement les debuffs appliqués par moi";
L["Enable Whitelist"] = "Activer la liste blanche";
L["Configure Whitelist"] = "Configurer la liste blanche";
L["Enable Blacklist"] = "Activer la liste noire";
L["Configure Blacklist"] = "Configurer la liste noire";

--------------------------------
-- TODO: This needs translating:
--------------------------------

L["MUI_Setup_InfoTab"] = [[
Visit our Discord community:
%s

Visitez le site officiel de MayronUI pour plus d'informations:
%s

The official GitHub repo:
%s

Become a Patron and earn exclusive benefits within the community:
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

|cff00ccff> Patrons|r
%s

|cff00ccff> Development and Bug Fixes|r
%s

|cff00ccff> Translation Support|r
%s

|cff00ccff> Community Support Team|r
%s

And of course, thank you to the authors of the non-MayronUI AddOns included in this UI pack.
]]

-- TODO: These are all newly added since 6.0.11:
--------------------------------------------------------------------------------------------
----- Do not touch the placeholders: %s, %d
----- Do not touch the line break syntax: \n

L["Cast Bars"]                                      = "Cast Bars";
L["Auras (Buffs & Debuffs)"]                        = "Auras (Buffs & Debuffs)";
L["(CTRL+C to Copy, CTRL+V to Paste)"]              = "(CTRL+C to Copy, CTRL+V to Paste)";
L["Copy Chat Text"]                                 = "Copy Chat Text";
L["Data Text Bar"]                                  = "Data Text Bar";
L["Setup"]                                          = "Setup";
L["Timer Bars"]                                     = "Timer Bars";
L["MUI Profile Manager"]                            = "MUI Profile Manager";
L["Current profile"]                                = "Current profile";
L["Reset Profile"]                                  = "Reset Profile";
L["Delete Profile"]                                 = "Delete Profile";
L["Copy From"]                                      = "Copy From";
L["Select profile"]                                 = "Select profile";
L["Choose Profile"]                                 = "Choose Profile";
L["Choose the currently active profile."]           = "Choose the currently active profile.";
L["New Profile"]                                    = "New Profile";
L["Create a new profile."]                          = "Create a new profile.";
L["Default Profile Behaviour"]                      = "Default Profile Behaviour";
L["Name of New Layout"]                             = "Name of New Layout";
L["Layout"]                                         = "Layout";
L["Rename Layout"]                                  = "Rename Layout";
L["Are you sure you want to delete Layout '%s'?"]   = "Are you sure you want to delete Layout '%s'?";
L["MUI Layout Tool"]                                = "MUI Layout Tool";
L["Layouts"]                                        = "Layouts";
L["Create New Layout"]                              = "Create New Layout";
L["Delete Layout"]                                  = "Delete Layout";
L["Chat Buttons with Modifier Key %d"]              = "Chat Buttons with Modifier Key %d";
L["Please install the UI and try again."]           = "Please install the UI and try again.";
L["Chat Frames"]                                    = "Chat Frames";
L["Mini-Map Options"]                               = "Mini-Map Options";
L["Adjust the size of the minimap."]                = "Adjust the size of the minimap.";
L["Adjust the scale of the minimap."]               = "Adjust the scale of the minimap.";
L["Zone Text"]                                      = "Zone Text";
L["Scale"]                                          = "Scale";
L["Size"]                                           = "Size";
L["Adjust the font size of the zone text."]         = "Adjust the font size of the zone text.";
L["Okay"]                        					= "Okay";

L["Profile %s has been copied into current profile %s."] 
	= "Profile %s has been copied into current profile %s.";

L["You can manage character profiles here.\n\nBy default, each character has its own unique profile."]
	= "You can manage character profiles here.\n\nBy default, each character has its own unique profile.";

L["Reset currently active profile back to default settings."] 
	= "Reset currently active profile back to default settings.";

L["Are you sure you want to reset profile '%s' back to default settings?"] 
	= "Are you sure you want to reset profile '%s' back to default settings?";

L["Delete currently active profile (cannot delete the 'Default' profile)."] 
	= "Delete currently active profile (cannot delete the 'Default' profile).";

L["Copy all settings from one profile to the active profile."] 
	= "Copy all settings from one profile to the active profile.";

L["Are you sure you want to overide all profile settings in '%s' for those in profile '%s'?"] 
	= "Are you sure you want to overide all profile settings in '%s' for those in profile '%s'?";

L["By default, each new character will be automatically assigned a unique character profile instead of a single default profile.\n\nProfiles are automatically assigned only after installing the UI on a new character."] 
	= "By default, each new character will be automatically assigned a unique character profile instead of a single default profile.\n\nProfiles are automatically assigned only after installing the UI on a new character.";

L["Profile Per Character"] = "Profile Per Character";

L["If enabled, new characters will be assigned a unique character profile instead of the Default profile."] 
	= "If enabled, new characters will be assigned a unique character profile instead of the Default profile.";

L["Customize which addOn/s should change to which profile/s for each layout, as well as manage your existing layouts or create new ones."] 
	= "Customize which addOn/s should change to which profile/s for each layout, as well as manage your existing layouts or create new ones.";

	L["Press and hold the %s key while out of combat to show an arrow button.\n\n Clicking this will show a second row of action buttons."] 
	= "Press and hold the %s key while out of combat to show an arrow button.\n\n Clicking this will show a second row of action buttons.";

L["Thank you for installing %s!\n\nYou can fully customise the UI using the config menu:"]
	= "Thank you for installing %s!\n\nYou can fully customise the UI using the config menu:";

L["Anchor the Objective Tracker to the action bar container on the right side of the screen."]
	= "Anchor the Objective Tracker to the action bar container on the right side of the screen.";

L["You can repeat this step at any time (while out of combat) to hide it."]
		= "You can repeat this step at any time (while out of combat) to hide it.";

L["If true, the objective tracker will collapse when entering an instance."] 
	= "If true, the objective tracker will collapse when entering an instance.";

L["If true, MUI will not show copper, or silver, if the amount of gold is over a certain limit."]
	= "If true, MUI will not show copper, or silver, if the amount of gold is over a certain limit.";

L["Also enable the %s"]                                               = "Also enable the %s";
L["Current"]                                                          = "Current";
L["Equipment Set"]                                                    = "Equipment Set";
L["Installer"]                                                        = "Installer";
L["Profiles"]                                                         = "Profiles";
L["AFK Display"]                                                      = "AFK Display";
L["Movable Frames"]                                                   = "Movable Frames";
L["Objective Tracker"]                                                = "Objective Tracker";
L["Side Action Bar"]                                                  = "Side Action Bar";
L["(type '/mui' to list all slash commands)"] 						  = "(type '/mui' to list all slash commands)";
L["Version"]                                                          = "Version";
L["Main Container"]                                                   = "Main Container";
L["Resource Bars"]                                                    = "Resource Bars";
L["Mini Map"]                                                         = "Mini Map";
L["Movable Blizzard Frames"]                                          = "Movable Blizzard Frames";
L["Allows you to move Blizzard Frames outside of combat only."]       = "Allows you to move Blizzard Frames outside of combat only.";
L["Reset Blizzard frames back to their original position."]           = "Reset Blizzard frames back to their original position.";
L["Reset Blizzard Frame Positions"]                                   = "Reset Blizzard Frame Positions";
L["Enable/disable the AFK Display"] 								  = "Enable/disable the AFK Display";
L["Show AFK Display"]                                                 = "Show AFK Display";
L["Adjust the width of the main container."]                          = "Adjust the width of the main container.";
L["Adjust the height of the unit frame background panels."]           = "Adjust the height of the unit frame background panels.";
L["Unit Panel Height"]                                                = "Unit Panel Height";
L["Main Container Width:"]                                            = "Main Container Width:";
L["Enable or disable the background panel"]                           = "Enable or disable the background panel";
L["Modifier key/s used to show Expand/Retract button:"] 			  = "Modifier key/s used to show Expand/Retract button:";
L["Side Action Bars"]                                                 = "Side Action Bars";
L["Minimum value is"]                                                 = "Minimum value is";
L["Maximum value is"]                                                 = "Maximum value is";
L["Enable Changes"]                                                   = "Enable Changes";
L["Collapse in Instance"]                                             = "Collapse in Instance";
L["CREDITS"]                                                          = "CREDITS";
L["Buffs"]                                                            = "Buffs";
L["Debuffs"]                                                          = "Debuffs";
L["Layout Type"]                                                      = "Layout Type";
L["Save Position"]                                                    = "Save Position";
L["Show Pulse Effect"]                                                = "Show Pulse Effect";
L["Icon Options"]                                                     = "Icon Options";
L["Icon options are disabled when using status bars."]                = "Icon options are disabled when using status bars.";
L["Icon Size"]                                                        = "Icon Size";
L["Column Spacing"]                                                   = "Column Spacing";
L["Row Spacing"]                                                      = "Row Spacing";
L["Icons per Row"]                                                    = "Icons per Row";
L["Growth Direction"]                                                 = "Growth Direction";
L["Status Bar Options"]                                               = "Status Bar Options";
L["Status bar options are disabled when using icons."]                = "Status bar options are disabled when using icons.";
L["Icon Gap"]                                                         = "Icon Gap";
L["Text"]                                                             = "Text";
L["Time Remaining"]                                                   = "Time Remaining";
L["Count"]                                                            = "Count";
L["Aura Name"]                                                        = "Aura Name";
L["Border Type"]                                                      = "Border Type";
L["Basic %s"]                                                         = "Basic %s";
L["Weapon Enchants"]                                                  = "Weapon Enchants";
L["Magic Debuff"]                                                     = "Magic Debuff";
L["Disease Debuff"]                                                   = "Disease Debuff";
L["Poison Debuff"]                                                    = "Poison Debuff";
L["Curse Debuff"]                                                     = "Curse Debuff";
L["Bar Background"]                                                   = "Bar Background";
L["Bar Border"]                                                       = "Bar Border";
L["Icons"]                                                            = "Icons";
L["Status Bars"]                                                      = "Status Bars";
L["Bottom Action Bars"]                                               = "Bottom Action Bars";
L["Can Steal or Purge"]                                               = "Can Steal or Purge";
L["If an aura can be stolen or purged, show a different color."]      = "If an aura can be stolen or purged, show a different color.";
L["Show Borders"]                                                     = "Show Borders";
L["Enter an aura name to add to the whitelist:"]                      = "Enter an aura name to add to the whitelist:";
L["Enter an aura name to add to the blacklist:"]                      = "Enter an aura name to add to the blacklist:";
L["Automatic"]                                                        = "Automatic";
L["Inventory"]                                                        = "Inventory";
L["Changes to these settings will take effect after 0-3 seconds."]    = "Changes to these settings will take effect after 0-3 seconds.";
L["Adjust the height of the datatext bar."]                           = "Adjust the height of the datatext bar.";
L["Justify Text"]                                                     = "Justify Text";
L["Set the spacing between the status bar and the background."]       = "Set the spacing between the status bar and the background.";
L["Anchor Chat Icons"]                                                = "Anchor Chat Icons";
L["Select which chat frame the chat icons should be anchored to."]    = "Select which chat frame the chat icons should be anchored to.";
L["The height of the edit box."]                                      = "The height of the edit box.";
L["Set the vertical positioning of the edit box."]                    = "Set the vertical positioning of the edit box.";
L["Show Player Status Icon"]                                          = "Show Player Status Icon";
L["Show Emotes Icon"]                                                 = "Show Emotes Icon";
L["Show Copy Chat Icon"]                                              = "Show Copy Chat Icon";
L["This is the background bar that goes behind the tabs."]            = "This is the background bar that goes behind the tabs.";
L["Show Tab Bar"]                                                     = "Show Tab Bar";
L["Tab Bar"]                                                          = "Tab Bar";
L["Window"]                                                           = "Window";
L["Layout enabled!"]                                                  = "Layout enabled!";
L["Show Chat Menu"]                                                   = "Show Chat Menu";
L["Azerite"] 							      = "Azerite";
L["Covenant Sanctum"]						      = "Covenant Sanctum";
L["Missions"]							      = "BfA Missions";
L["You must be a member of a covenant to view this."]		      = "You must be a member of a covenant to view this."
L["Unmuted"] = "Non muet";

---------------------------------------
--- NEW SINCE 12/12/2020 (update 6.3.8)
---------------------------------------
L["Step %d of"] = "Étape %d de";
L["Step"] = "Étape";

L["Found a bug? Use this form to submit an issue to the official MayronUI GitHub page."] =
  "Vous avez trouvé un bug? Utilisez ce formulaire pour soumettre un problème à la page officielle MayronUI GitHub.";

L["Almost done! We just need a bit more information..."] = "Presque fini! Nous avons juste besoin d'un peu plus d'informations ...";

L["Click below to generate your report. Once generated, copy it into a new issue and submit it on GitHub using the link below:"] =
  "Cliquez ci-dessous pour générer votre rapport. Une fois généré, copiez-le dans un nouveau numéro et soumettez-le sur GitHub en utilisant le lien ci-dessous:";

L["characters"] = "personnages"; -- text characters (e.g. A, B, C, etc...), NOT WoW characters!

L["minimum"] = "le minimum";
L["Please describe the bug in detail:"] = "Veuillez décrire le bogue en détail:";
L["How can we replicate the bug?"] = "Comment pouvons-nous reproduire le bogue?";
L["Report Issue"] = "Signaler un problème";

L["Open this webpage in your browser"] = "Ouvrez cette page Web dans votre navigateur";
L["Generate Report"] = "Générer un rapport";
L["Copy Report"] = "Copier le rapport";