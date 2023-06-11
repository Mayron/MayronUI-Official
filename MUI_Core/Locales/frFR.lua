local L = _G.LibStub("AceLocale-3.0"):NewLocale("MayronUI", "frFR");
if not L then
  return
end

---------------------------------
--- SMALL TEXT:
---------------------------------
L["Character"] = "Personnage";
L["Bags"] = "Sacs";
L["Friends"] = "Amis";
L["Guild"] = "Guilde";
L["Help Menu"] = "Menu Aide";
L["PVP"] = "PVP";
L["Spell Book"] = "Livre de sortilèges";
L["Talents"] = "Talent";
L["Achievements"] = "Réalisations";
L["Glyphs"] = "Glyphes";
L["Calendar"] = "Calendrier";
L["LFD"] = "LFD";
L["LFG"] = "LFG";
L["Enable Max Camera Zoom"] = "Activer le zoom maximal de la caméra";
L["Move AddOn Buttons"] = "Déplacer les boutons supplémentaires";
L["MOVE_ADDON_BUTTONS_TOOLTIP"] = "Si cette case est cochée, les boutons d'icône d'extension qui apparaissent en haut de la mini-carte seront déplacés vers le menu contextuel de la mini-carte.";
L["Raid"] = "Raid";
L["Encounter Journal"] = "Journal des Rencontres";
L["Collections Journal"] = "Journal des Collections";
L["Macros"] = "Macro";
L["Skills"] = "Compétences";
L["World Map"] = "Carte du monde";
L["Quest Log"] = "Journal de quête";
L["Show Online Friends"] = "Afficher les amis en ligne";
L["Toggle Friends List"] = "Basculer la liste d'amis";
L["Show Guild Members"] = "Afficher les membres de la guilde";
L["Toggle Guild Pane"] = "Basculer le volet Guilde";
L["Quests"] = "Quêtes";
L["Save Position"] = "Sauvegarder la position";
L["Experience"] = "Vivre";
L["Reputation"] = "Réputation";
L["Artifact"] = "Artefact";
L["Azerite"] = "Azérite";
L["PVP Score"] = "Score PVP";
L["Currency"] = "Devise";
L["MUI Layout Button"] = "Bouton de mise en page MUI";
L["Left Click:"] = "Click gauche:";
L["Switch Layout"] = "Changement de disposition";
L["Right Click:"] = "Clic-droit:";
L["Show Layout Config Tool"] =
  "Afficher l'outil de configuration de la mise en page";
L["Edit Box (Message Input Box)"] =
  "Boîte d'édition (boîte de saisie de message)";
L["Background Color"] = "Couleur de l'arrière plan";
L["Backdrop Inset"] = "Encart de toile de fond";
L["Chat Frame Options"] = "Options de cadre de discussion";
L["Enable Chat Frame"] = "Activer le cadre de discussion";
L["Options"] = "Options";
L["Button Swapping in Combat"] = "Échange de boutons au combat";
L["Standard Chat Buttons"] = "Boutons de chat standard";
L["Left Button"] = "Bouton gauche";
L["Middle Button"] = "Bouton du milieu";
L["Right Button"] = "Bouton de droite";
L["Shift"] = "Changement";
L["Alt"] = "Alt";
L["Set the border size."] = "Définir la taille de la bordure.";
L["Cannot toggle menu while in combat."] =
  "Impossible de basculer le menu pendant le combat.";
L["Cannot switch layouts while in combat."] =
  "Impossible de changer de disposition pendant le combat.";
L["Cannot install while in combat."] =
  "Impossible d'installer pendant le combat.";
L["Set the spacing between the background and the border."] =
  "Définir l'espacement entre l'arrière-plan et la bordure.";
L["Allow the use of modifier keys to swap chat buttons while in combat."] =
  "Autoriser l'utilisation des touches de modification pour échanger les boutons de discussion pendant le combat.";
L["List of slash commands:"] = "Liste des commandes slash :";
L["Welcome back"] = "Content de te revoir";
L["Starter Edition accounts cannot perform this action."] =
  "Les comptes Starter Edition ne peuvent pas effectuer cette action.";
L["Loot Specialization set to: Current Specialization"] =
  "Spécialisation du butin définie sur : spécialisation actuelle";
L["Must be level 10 or higher to use Talents."] =
  "Doit être de niveau 10 ou supérieur pour utiliser les talents.";
L["Requires level 10+ to view the PVP window."] =
  "Nécessite le niveau 10+ pour voir la fenêtre PVP.";
L["Requires being inside a Battle Ground."] =
  "Nécessite d'être à l'intérieur d'un champ de bataille.";
L["Choose Spec"] = "Choisir la spécification";
L["Choose Loot Spec"] = "Choisissez la spécification de butin";
L[" (current)"] = " (actuel)";
L["Toggle Bags"] = "Toggle Sacs";
L["Sort Bags"] = "Trier les sacs";
L["Commands"] = "Commandes";
L["Armor"] = "Armure";
L["Head"] = "Diriger";
L["Shoulder"] = "Épaule";
L["Chest"] = "Coffre";
L["Waist"] = "Taille";
L["Legs"] = "Jambes";
L["Feet"] = "Pieds";
L["Wrist"] = "Poignet";
L["Hands"] = "Mains";
L["Main Hand"] = "Main Principale";
L["Secondary Hand"] = "Main secondaire";
L["Zone"] = "Zone";
L["Rank"] = "Rang";
L["<none>"] = "<aucun>";
L["Notes"] = "Remarques";
L["Achievement Points"] = "Points de réussite";
L["No Guild"] = "Pas de guilde";
L["No Spec"] = "Aucune spécification";
L["Current Money"] = "Argent courant";
L["Start of the day"] = "Début de journée";
L["Today's profit"] = "Le bénéfice d'aujourd'hui";
L["Money per character"] = "Argent par personnage";
L["Guild Chat"] = "Chat de guilde";
L["Whispers"] = "chuchotements";
L[" CastBar not enabled."] = " CastBar non activé.";
L["Lock"] = "Fermer à clé";
L["Unlock"] = "Ouvrir";
L["Appearance"] = "Apparence";
L["Bar Texture"] = "Texture de barre";
L["Border"] = "Frontière";
L["Border Size"] = "Taille de la frontière";
L["Frame Inset"] = "Encadré de cadre";
L["Colors"] = "Couleurs";
L["Normal Casting"] = "Casting normal";
L["Not Interruptible"] = "Non interruptible";
L["Finished Casting"] = "Fonderie finie";
L["Interrupted"] = "Interrompu";
L["Latency"] = "Latence";
L["Individual Cast Bar Options"] = "Options de barre de coulée individuelle";
L["Enable Bar"] = "Activer la barre";
L["Show Icon"] = "Montrer l'icône";
L["Show Latency Bar"] = "Afficher la barre de latence";
L["Anchor to SUF Portrait Bar"] = "Ancre à la barre de portrait SUF";
L["Width"] = "Largeur";
L["Height"] = "Hauteur";
L["Frame Strata"] = "Strate de cadre";
L["Frame Level"] = "Niveau du cadre";
L["Point"] = "Point";
L["Relative Frame"] = "Cadre relatif";
L["Relative Point"] = "Point relatif";
L["X-Offset"] = "Décalage X";
L["Y-Offset"] = "Décalage Y";
L["Player"] = "Joueur";
L["Target"] = "Cible";
L["Focus"] = "Se concentrer";
L["Mirror"] = "Miroir";
L["Pet"] = "Animaux";
L["If enabled the Cast Bar will be fixed to the %s Unit Frame's Portrait Bar (if it exists)."] =
  "Si activé, la barre de diffusion sera fixée à la barre de portrait du cadre d'unité %s (si elle existe).";
L["The %s Unit Frames's Portrait Bar needs to be enabled to use this feature."] =
  "La barre de portrait des cadres d'unités %s doit être activée pour utiliser cette fonctionnalité.";
L["Only takes effect if the Cast Bar is not anchored to a SUF Portrait Bar."] =
  "Ne prend effet que si la Cast Bar n'est pas ancrée à une SUF Portrait Bar.";
L["Manual positioning only works if the CastBar is not anchored to a SUF Portrait Bar."] =
  "Le positionnement manuel ne fonctionne que si la CastBar n'est pas ancrée à une barre de portrait SUF.";
L["CTRL + Drag:"] = "CTRL + Glisser :";
L["SHIFT + Drag:"] = "MAJ + Glisser :";
L["Mouse Wheel:"] = "Roulette de la souris:";
L["ALT + Left Click:"] = "ALT + clic gauche :";
L["Move Minimap"] = "Déplacer la minicarte";
L["Resize Minimap"] = "Redimensionner la minicarte";
L["Ping Minimap"] = "Ping Minicarte";
L["Show Menu"] = "Afficher le menu";
L["Zoom in/out"] = "Zoom avant/arrière";
L["Toggle this Tooltip"] = "Activer cette info-bulle";
L["New Event!"] = "Nouvel évènement!";
L["Tracking Menu"] = "Menu Suivi";
L["Cannot access config menu while in combat."] =
  "Impossible d'accéder au menu de configuration pendant le combat.";
L["Choose Theme:"] = "Choisir le thème :";
L["Theme"] = "Thème";
L["Choose Profile:"] = "Choisir le profil :";
L["Confirm"] = "Confirmer";
L["Cancel"] = "Annuler";
L["Top Left"] = "En haut à gauche";
L["Top Right"] = "En haut à droite";
L["Bottom Left"] = "En bas à gauche";
L["Bottom Right"] = "En bas à droite";
L["Adjust the UI Scale:"] = "Ajuster l'échelle de l'interface utilisateur :";
L["Install"] = "Installer";
L["INSTALL"] = "INSTALLER";
L["CUSTOM INSTALL"] = "INSTALLATION PERSONNALISÉE";
L["INFORMATION"] = "INFORMATIONS";
L["Warning:"] = "Avertissement:";
L["This will reload the UI!"] = "Cela va recharger l'interface utilisateur !";
L["Setup Menu"] = "Menu des paramètres";
L["VERSION"] = "VERSION";
L["This will ensure that frames are correctly positioned to match the UI scale during installation."] =
  "Cela garantira que les cadres sont correctement positionnés pour correspondre à l'échelle de l'interface utilisateur lors de l'installation.";
L["General Options"] = "Options générales";
L["Sort By Time Remaining"] = "Trier par temps restant";
L["Show Tooltips On Mouseover"] =
  "Afficher les info-bulles au passage de la souris";
L["Create New Field"] = "Créer un nouveau champ";
L["TimerBar field '%s' created."] = "Champ TimerBar '%s' créé.";
L["TimerBar field '%s' does not exist."] =
  "Le champ TimerBar '%s' n'existe pas.";
L["Remove Field"] = "Supprimer le champ";
L["Existing Timer Bar Fields"] = "Champs de barre de minuterie existants";
L["Enable Field"] = "Activer le champ";
L["<%s Field>"] = "<%s Champ>";
L["Unit to Track"] = "Unité à suivre";
L["TargetTarget"] = "CibleCible";
L["FocusTarget"] = "FocusCible";
L["Up"] = "En haut";
L["Down"] = "Vers le bas";
L["Bar Width"] = "Largeur de barre";
L["Bar Height"] = "Hauteur de la barre";
L["Bar Spacing"] = "Espacement des barres";
L["Show Icons"] = "Afficher les icônes";
L["Show Spark"] = "Montrer l'étincelle";
L["Buff Bar Color"] = "Couleur de la barre de chamois";
L["Debuff Bar Color"] = "Couleur de la barre de debuff";
L["Manual Positioning"] = "Positionnement manuel";
L["Text Options"] = "Options de texte";
L["Font Size"] = "Taille de police";
L["Font Type"] = "Type de police";
L["Time Remaining"] = "Temps restant";
L["Spell Count"] = "Nombre de sorts";
L["Spell Name"] = "Épeler le nom";
L["The unit who is affected by the spell."] =
  "L'unité qui est affectée par le sort.";
L["The field's vertical growth direction:"] =
  "Direction de croissance verticale du champ :";
L["Reload UI"] = "Recharger l'interface utilisateur";
L["General"] = "Général";
L["Master Font"] = "Police principale";
L["Display Lua Errors"] = "Afficher les erreurs Lua";
L["Set Theme Color"] = "Définir la couleur du thème";
L["Anchor to Side Bar"] = "Ancre à la barre latérale";
L["Unit Panels"] = "Panneaux d'unité";
L["Enable Unit Panels"] = "Activer les panneaux d'unité";
L["Symmetric Unit Panels"] = "Panneaux d'unités symétriques";
L["Name Panels"] = "Panneaux de noms";
L["Action Bar Panels"] = "Panneau de la barre d'action";
L["Control"] = "Contrôler";
L["SUF Portrait Gradient"] = "Dégradé de portrait SUF";
L["Enable Gradient Effect"] = "Activer l'effet de dégradé";
L["Gradient Colors"] = "Couleurs dégradées";
L["Start Color"] = "Couleur de départ";
L["End Color"] = "Couleur de fin";
L["Target Class Colored"] = "Classe cible colorée";
L["Row"] = "Ligne";
L["Enabled"] = "Activée";
L["Default value is"] = "La valeur par défaut est";
L["Show Text"] = "Afficher le texte";
L["General Data Text Options"] = "Options de texte de données générales";
L["Block in Combat"] = "Bloquer au combat";
L["Auto Hide Menu in Combat"] = "Masquer automatiquement le menu en combat";
L["Spacing"] = "Espacement";
L["Menu Width"] = "Largeur du menu";
L["Max Menu Height"] = "Hauteur maximale du menu";
L["Bar Strata"] = "Bar Strata";
L["Bar Level"] = "Niveau de barre";
L["Data Text Modules"] = "Modules de texte de données";
L["Durability"] = "Durabilité";
L["Performance"] = "Performance";
L["Memory"] = "Mémoire";
L["Money"] = "De l'argent";
L["Disabled"] = "Désactivée";
L["Module Options"] = "Options de modules";
L["Show FPS"] = "Afficher fps";
L["Show Server Latency (ms)"] = "Afficher la latence du serveur (ms)";
L["Show Home Latency (ms)"] = "Afficher la latence d'accueil (ms)";
L["Show Total Slots"] = "Afficher le nombre total de créneaux";
L["Show Used Slots"] = "Afficher les machines à sous utilisées";
L["Show Free Slots"] = "Afficher les machines à sous gratuites";
L["Show Self"] = "Se montrer";
L["Show Tooltips"] = "Afficher les infobulles";
L["Never"] = "Jamais";
L["Always"] = "Toujours";
L["On Mouse-over"] = "Au passage de la souris";
L["Bar"] = "Bar";
L["Uncheck to prevent MUI from changing the game font."] =
  "Décochez pour empêcher MUI de changer la police du jeu.";
L["The UI requires reloading to apply changes."] =
  "L'interface utilisateur nécessite un rechargement pour appliquer les modifications.";
L["Some changes require a client restart to take effect."] =
  "Certaines modifications nécessitent un redémarrage du client pour prendre effet.";
L["Previously called 'Classic Mode'."] = "Auparavant appelé 'Mode Classique'.";
L["Allow MUI to Control Unit Frames"] =
  "Autoriser MUI à contrôler les trames de l'unité";
L["What color the gradient should start as."] =
  "De quelle couleur doit commencer le dégradé.";
L["What color the gradient should change into."] =
  "Dans quelle couleur le dégradé doit-il changer.";
L["Show your character in the guild list."] =
  "Afficher votre personnage dans la liste de guilde.";
L["Adjust the width of the unit frame background panels."] =
  "Ajustez la largeur des panneaux d'arrière-plan du cadre de l'unité.";
L["Adjust the width of the unit name background panels."] =
  "Ajustez la largeur des panneaux d'arrière-plan du nom de l'unité.";
L["Adjust the height of the unit name background panels."] =
  "Ajustez la hauteur des panneaux d'arrière-plan du nom de l'unité.";
L["Adjust the width of the Objective Tracker."] =
  "Ajustez la largeur de l'Object Tracker.";
L["Adjust the height of the Objective Tracker."] =
  "Ajustez la hauteur de l'Object Tracker.";
L["Move the unit name panels further in or out."] =
  "Déplacez les panneaux de nom d'unité plus loin vers l'intérieur ou l'extérieur.";
L["Set the font size of unit names."] =
  "Définir la taille de la police des noms d'unités.";
L["The speed of the Expand and Retract transitions."] =
  "La vitesse des transitions Expand et Retract.";
L["The higher the value, the quicker the speed."] =
  "Plus la valeur est élevée, plus la vitesse est rapide.";
L["The height of the gradient effect."] = "La hauteur de l'effet de dégradé.";
L["Adjust the spacing between data text buttons."] =
  "Ajuster l'espacement entre les boutons de texte de données.";
L["The frame strata of the entire DataText bar."] =
  "Les strates d'images de toute la barre DataText.";
L["Disable this to stop MUI from controlling the Objective Tracker."] =
  "Désactivez ceci pour empêcher MUI de contrôler l'Object Tracker.";
L["Adjust the horizontal positioning of the Objective Tracker."] =
  "Ajustez le positionnement horizontal de l'Object Tracker.";
L["Adjust the vertical positioning of the Objective Tracker."] =
  "Ajustez le positionnement vertical de l'Object Tracker.";
L["The font size of text that appears on data text buttons."] =
  "La taille de la police du texte qui apparaît sur les boutons de texte de données.";
L["Show guild info tooltips when the cursor is over guild members in the guild list."] =
  "Afficher les info-bulles d'informations sur la guilde lorsque le curseur est sur les membres de la guilde dans la liste de guilde.";
L["The frame level of the entire DataText bar based on its frame strata value."] =
  "Le niveau de trame de l'ensemble de la barre DataText en fonction de sa valeur de strate de trame.";
L["If unchecked, the entire DataText module will be disabled and all"] =
  "Si décoché, tout le module DataText sera désactivé et tout";
L["DataText buttons, as well as the background bar, will not be displayed."] =
  "Les boutons DataText, ainsi que la barre d'arrière-plan, ne seront pas affichés.";
L["Prevents you from using data text modules while in combat."] =
  "Vous empêche d'utiliser des modules de texte de données pendant le combat.";
L["If the SUF Player or Target portrait bars are enabled, a class colored gradient will overlay it."] =
  "Si les barres de portrait SUF Player ou Target sont activées, un dégradé de couleur de classe le superposera.";
L["Show Overview"] = "Afficher la vue d'ensemble";
L["Show Reset Options"] = "Afficher les options de réinitialisation";
L["Reset All Characters"] = "Réinitialiser tous les caractères";
L["Are you sure you want to reset the money data for all of your characters?"] =
  "Êtes-vous sûr de vouloir réinitialiser les données d'argent pour tous vos personnages ?";
L["All money data has been reset."] =
  "Toutes les données d'argent ont été réinitialisées.";
L["Are you sure you want to reset the money data for %s?"] =
  "Êtes-vous sûr de vouloir réinitialiser les données d'argent pour %s ?";
L["Money data for %s has been reset."] =
  "Les données d'argent pour %s ont été réinitialisées.";
L["Reset Options"] = "Réinitialiser les options";
L["Change Status"] = "Changer de statut";
L["Remove from Whitelist"] = "Supprimer de la liste blanche";
L["Add to Blacklist"] = "Ajouter à la liste noire";
L["Are you sure you want to do this?"] = "Es-tu sûr de vouloir faire ça?";
L["%s has been removed from the whitelist."] =
  "%s a été supprimé de la liste blanche.";
L["%s has been added to the blacklist."] =
  "%s a été ajouté à la liste noire.";
L["Filters"] = "Filtres";
L["Only show buffs applied by me"] =
  "Afficher uniquement les buffs appliqués par moi";
L["Only show debuffs applied by me"] =
  "Afficher uniquement les debuffs appliqués par moi";
L["Enable Whitelist"] = "Activer la liste blanche";
L["Configure Whitelist"] = "Configurer la liste blanche";
L["Enable Blacklist"] = "Activer la liste noire";
L["Configure Blacklist"] = "Configurer la liste noire";
L["Removing %s from the whitelist will hide this timer bar if the whitelist is enabled."] =
  "La suppression de %s de la liste blanche masquera cette barre de minuterie si la liste blanche est activée.";
L["Adding %s to the blacklist will hide this timer bar if the blacklist is enabled."] =
  "L'ajout de %s à la liste noire masquera cette barre de minuterie si la liste noire est activée.";
L["Cast Bars"] = "Barres de fonte";
L["(CTRL+C to Copy, CTRL+V to Paste)"] =
  "(CTRL+C pour copier, CTRL+V pour coller)";
L["Copy Chat Text"] = "Copier le texte du chat";
L["Data Text Bar"] = "Barre de texte de données";
L["Setup"] = "Installer";
L["Timer Bars"] = "Barres de minuterie";
L["MUI Profile Manager"] = "Gestionnaire de profils MUI";
L["Current profile"] = "Profil actuel";
L["Reset Profile"] = "Réinitialiser le profil";
L["Delete Profile"] = "Supprimer le profil";
L["Copy From"] = "Copier depuis";
L["Select profile"] = "Choisissez un profil";
L["Choose Profile"] = "Choisir le profil";
L["Choose the currently active profile."] =
  "Choisissez le profil actuellement actif.";
L["New Profile"] = "Nouveau profile";
L["Create a new profile"] = "Créer un nouveau profil";
L["Default Profile Behaviour"] = "Comportement du profil par défaut";
L["Name of New Layout"] = "Nom de la nouvelle mise en page";
L["Layout"] = "Mise en page";
L["Rename Layout"] = "Renommer la mise en page";
L["Are you sure you want to delete Layout '%s'?"] =
  "Voulez-vous vraiment supprimer la mise en page '%s' ?";
L["MUI Layout Tool"] = "Outil de mise en page MUI";
L["Layouts"] = "Mise en page";
L["Create New Layout"] = "Créer une nouvelle mise en page";
L["Delete Layout"] = "Supprimer la mise en page";
L["Chat Buttons with Modifier Key %d"] =
  "Boutons de discussion avec touche de modification %d";
L["Please install the UI and try again."] =
  "Veuillez installer l'interface utilisateur et réessayer.";
L["Chat Frames"] = "Cadres de discussion";
L["Mini-Map Options"] = "Options de mini-carte";
L["Mini-Map"] = "Mini-Carte";
L["Adjust the size of the minimap."] = "Ajustez la taille de la minicarte.";
L["Adjust the scale of the minimap."] = "Ajustez l'échelle de la minicarte.";
L["Scale"] = "Escalader";
L["Size"] = "Taille";
L["Okay"] = "D'accord";
L["Profile %s has been copied into current profile %s."] =
  "Le profil %s a été copié dans le profil actuel %s.";
L["Reset currently active profile back to default settings."] =
  "Réinitialiser le profil actuellement actif aux paramètres par défaut.";
L["Are you sure you want to reset profile '%s' back to default settings?"] =
  "Voulez-vous vraiment réinitialiser le profil '%s' aux paramètres par défaut ?";
L["Delete currently active profile (cannot delete the 'Default' profile)."] =
  "Supprimer le profil actuellement actif (impossible de supprimer le profil 'Par défaut').";
L["Copy all settings from one profile to the active profile."] =
  "Copier tous les paramètres d'un profil vers le profil actif.";
L["Are you sure you want to override all profile settings in '%s' for those in profile '%s'?"] =
  "Êtes-vous sûr de vouloir remplacer tous les paramètres de profil dans '%s' pour ceux dans le profil '%s' ?";
L["Profile Per Character"] = "Profil par caractère";
L["If enabled, new characters will be assigned a unique character profile instead of the Default profile."] =
  "Si activé, les nouveaux personnages se verront attribuer un profil de personnage unique au lieu du profil par défaut.";
L["Anchor the Objective Tracker to the action bar container on the right side of the screen."] =
  "Ancrez l'Object Tracker au conteneur de la barre d'action sur le côté droit de l'écran.";
L["If true, the objective tracker will collapse when entering an instance."] =
  "Si vrai, le traqueur d'objectifs s'effondrera lors de l'entrée dans une instance.";
L["Also enable the %s"] = "Activer également le %s";
L["Current"] = "Actuel";
L["Profiles"] = "Profils";
L["AFK Display"] = "Affichage AFK";
L["Movable Frames"] = "Cadres mobiles";
L["Objective Tracker"] = "Traqueur d'objectifs";
L["(type '/mui' to list all slash commands)"] =
  "(tapez '/mui' pour lister toutes les commandes slash)";
L["Version"] = "Version";
L["Resource Bars"] = "Barres de ressources";
L["Allows you to move Blizzard Frames outside of combat only."] =
  "Vous permet de déplacer les cadres Blizzard en dehors du combat uniquement.";
L["Reset Blizzard frames back to their original position."] =
  "Réinitialiser les images Blizzard à leur position d'origine.";
L["Enable/disable the AFK Display"] = "Activer/désactiver l'affichage AFK";
L["Show AFK Display"] = "Afficher l'affichage AFK";
L["Adjust the width of the main container."] =
  "Ajustez la largeur du conteneur principal.";
L["Adjust the height of the unit frame background panels."] =
  "Ajustez la hauteur des panneaux d'arrière-plan du cadre de l'unité.";
L["Side Action Bars"] = "Barres d'action latérales";
L["Collapse in Instance"] = "Effondrement dans l'instance";
L["CREDITS"] = "CRÉDITS";
L["Buffs"] = "Les buffs";
L["Debuffs"] = "Débuffs";
L["Show Pulse Effect"] = "Afficher l'effet d'impulsion";
L["Icon Options"] = "Options d'icônes";
L["Column Spacing"] = "Espacement des colonnes";
L["Row Spacing"] = "Écartement des rangs";
L["Icons per Row"] = "Icônes par ligne";
L["Bar Columns"] = "Colonnes de barre";
L["Growth Direction"] = "Orientation de croissance";
L["Status Bar Options"] = "Options de la barre d'état";
L["Count"] = "Compter";
L["Aura Name"] = "Nom de l'aura";
L["Border Type"] = "Type de bordure";
L["Magic Debuff"] = "Débuff magique";
L["Disease Debuff"] = "Débuff de maladie";
L["Poison Debuff"] = "Débuff de Poison";
L["Curse Debuff"] = "Débuff Malédiction";
L["Icons"] = "Icônes";
L["Status Bars"] = "Barres d'état";
L["Can Steal or Purge"] = "Peut voler ou purger";
L["If an aura can be stolen or purged, show a different color."] =
  "Si une aura peut être volée ou purgée, montrez une couleur différente.";
L["Show Borders"] = "Afficher les frontières";
L["Enter an aura name to add to the whitelist:"] =
  "Entrez un nom d'aura à ajouter à la liste blanche :";
L["Enter an aura name to add to the blacklist:"] =
  "Entrez un nom d'aura à ajouter à la liste noire :";
L["Inventory"] = "Inventaire";
L["Changes to these settings will take effect after 0-3 seconds."] =
  "Les modifications apportées à ces paramètres prendront effet au bout de 0 à 3 secondes.";
L["Adjust the height of the datatext bar."] =
  "Ajustez la hauteur de la barre de texte de données.";
L["Set the spacing between the status bar and the background."] =
  "Définir l'espacement entre la barre d'état et l'arrière-plan.";
L["Select which chat frame the chat icons should be anchored to."] =
  "Sélectionnez le cadre de discussion auquel les icônes de discussion doivent être ancrées.";
L["The height of the edit box."] = "La hauteur de la zone d'édition.";
L["Set the vertical positioning of the edit box."] =
  "Définir le positionnement vertical de la zone d'édition.";
L["This is the background bar that goes behind the tabs."] =
  "C'est la barre d'arrière-plan qui va derrière les onglets.";
L["Show Tab Bar"] = "Afficher la barre d'onglets";
L["Tab Bar"] = "Barre d'onglets";
L["Window"] = "La fenêtre";
L["Layout enabled!"] = "Mise en page activée !";
L["Show Chat Menu"] = "Afficher le menu de discussion";
L["Covenant Sanctum"] = "Sanctuaire de l'Alliance";
L["You must be a member of a covenant to view this."] =
  "Vous devez être membre d'une alliance pour voir cela.";
L["Unmuted"] = "Sans son";
L["Toggle Questlog"] = "Basculer le journal des quêtes";
L["Step %d of"] = "Étape %d de";
L["Step"] = "Marcher";
L["Found a bug? Use this form to submit an issue to the official MayronUI GitHub page."] =
  "Vous avez trouvé un bogue ? Utilisez ce formulaire pour soumettre un problème à la page officielle MayronUI GitHub.";
L["Almost done! We just need a bit more information..."] =
  "Presque terminé ! Nous avons juste besoin d'un peu plus d'informations...";
L["Click below to generate your report. Once generated, copy it into a new issue and submit it on GitHub using the link below:"] =
  "Cliquez ci-dessous pour générer votre rapport. Une fois généré, copiez-le dans un nouveau numéro et soumettez-le sur GitHub en utilisant le lien ci-dessous :";
L["characters"] = "caractères";
L["minimum"] = "le minimum";
L["Please describe the bug in detail:"] =
  "Veuillez décrire le bogue en détail :";
L["How can we replicate the bug?"] =
  "Comment pouvons-nous reproduire le bogue ?";
L["Report Issue"] = "Signaler un problème";
L["Report MayronUI Bug"] = "Signaler un bogue MayronUI";
L["Open this webpage in your browser"] =
  "Ouvrez cette page Web dans votre navigateur";
L["Generate Report"] = "Générer un rapport";
L["Copy Report"] = "Copier le rapport";
L["Chat Frame with Icons"] = "Cadre de discussion avec des icônes";
L["Vertical Side Icons"] = "Icônes latérales verticales";
L["Only 1 active chat frame can show the chat icons on the sidebar (see icons listed below)."] =
  "Un seul cadre de discussion actif peut afficher les icônes de discussion dans la barre latérale (voir les icônes répertoriées ci-dessous).";
L["Horizontal Top Buttons"] = "Boutons supérieurs horizontaux";
L["This option will affect all active chat frames. To configure each individual button per chat frame, see the chat frame sub-menus below."] =
  "Cette option affectera tous les cadres de discussion actifs. Pour configurer chaque bouton individuel par cadre de discussion, consultez les sous-menus des cadres de discussion ci-dessous.";
L["Chat Channels"] = "Chaînes de discussion";
L["Professions"] = "Les professions";
L["AddOn Shortcuts"] = "Raccourcis complémentaires";
L["Copy Chat"] = "Copier le chat";
L["Emotes"] = "Emotes";
L["Online Status"] = "Statut en ligne";
L["None"] = "Rien";
L["Deafen"] = "Assourdir";
L["Mute"] = "Muet";
L["Unit Tooltip Options"] = "Options de l'info-bulle des unités";
L["These options only affect tooltips that appear when you mouse over a unit, such as an NPC or player."] =
  "Ces options n'affectent que les infobulles qui apparaissent lorsque vous passez la souris sur une unité, comme un PNJ ou un joueur.";
L["If checked, the target of the unit (NPC or player) displayed in the tooltip will be shown."] =
  "Si coché, la cible de l'unité (PNJ ou joueur) affichée dans l'info-bulle sera affichée.";
L["If checked and the player is in a guild, the guild rank of the player displayed in the tooltip will be shown."] =
  "Si coché et que le joueur est dans une guilde, le rang de guilde du joueur affiché dans l'info-bulle sera affiché.";
L["If checked and the player is level 10 or higher, the item level of the player displayed in the tooltip will be shown."] =
  "Si coché et que le joueur est de niveau 10 ou supérieur, le niveau d'élément du joueur affiché dans l'info-bulle sera affiché.";
L["The player must be close enough to be inspected for this information to load."] =
  "Le lecteur doit être suffisamment proche pour être inspecté pour que ces informations se chargent.";
L["If checked and the player is level 10 or higher and has chosen a class specialization, the specialization of the player displayed in the tooltip will be shown."] =
  "Si coché et que le joueur est de niveau 10 ou supérieur et a choisi une spécialisation de classe, la spécialisation du joueur affichée dans l'info-bulle sera affichée.";
L["Show Specialization"] = "Afficher la spécialisation";
L["Show Item Level"] = "Afficher le niveau de l'objet";
L["Show Guild Rank"] = "Afficher le rang de guilde";
L["Show Realm Name"] = "Afficher le nom du domaine";
L["Show Target"] = "Afficher la cible";
L["Appearance Options"] = "Options d'apparence";
L["These options allow you to customize the appearance of the tooltips."] =
  "Ces options vous permettent de personnaliser l'apparence des info-bulles.";
L["Font Flag"] = "Font Flag";
L["Standard Font Size"] = "Taille de police standard";
L["Header Font Size"] = "Taille de la police d'en-tête";
L["Affects the overall size of the tooltips."] =
  "Affecte la taille globale des infobulles.";
L["Reskin using the MUI texture or a custom backdrop"] =
  "Reskin en utilisant la texture MUI ou une toile de fond personnalisée";
L["Texture"] = "Texture";
L["Customize which addOn/s should change to which profile/s for each layout, as well as manage your existing layouts or create new ones."] =
  "Personnalisez quels addOn/s doivent changer en quel(s) profil(s) pour chaque mise en page, ainsi que gérer vos mises en page existantes ou en créer de nouvelles.";
L["Custom Backdrop"] = "Toile de fond personnalisée";
L["Custom Color"] = "Couleur personnalisée";
L["Custom Backdrop Options"] = "Options de toile de fond personnalisées";
L["Background Texture"] = "Texture d'arrière-plan";
L["Border Insets"] = "Encarts de bordure";
L["Left"] = "La gauche";
L["Right"] = "Droite";
L["Center"] = "Centre";
L["Top"] = "Haut";
L["Bottom"] = "Bas";
L["The bottom-[point] corner of the tooltip, where [point] is either 'Left' or 'Right', will be anchored to the position of the mouse cursor."] =
  "Le coin inférieur [point] de l'info-bulle, où [point] est soit 'Gauche' ou 'Droite', sera ancré à la position du curseur de la souris.";
L["Health Bar"] = "Barre de vie";
L["Outline"] = "Contour";
L["Thick Outline"] = "Contour épais";
L["Monochrome"] = "Monochrome";
L["Text Format"] = "Format texte";
L["Set the text format of the value that appears on the status bar. Set this to 'None' to hide the text."] =
  "Définir le format de texte de la valeur qui apparaît dans la barre d'état. Définissez-le sur 'Aucun' pour masquer le texte.";
L["Current/Maximum"] = "Courant/Maximum";
L["Percentage"] = "Pourcentage";
L["Power Bar"] = "Barre de puissance";
L["If checked, unit tooltips will show the unit's power bar."] =
  "Si coché, les infobulles de l'unité afficheront la barre d'alimentation de l'unité.";
L["Unit Aura Options"] = "Options d'aura d'unité";
L["If checked, unit tooltips will show the unit's buffs."] =
  "Si coché, les infobulles des unités afficheront les buffs de l'unité.";
L["Above"] = "Dessus";
L["Below"] = "Au dessous de";
L["Position"] = "Positionner";
L["Set whether you want the unit's buffs to appear above or below the tooltip."] =
  "Définir si vous voulez que les buffs de l'unité apparaissent au-dessus ou en dessous de l'info-bulle.";
L["Left to Right"] = "De gauche à droite";
L["Right to Left"] = "De droite à gauche";
L["If checked, unit tooltips will show the unit's debuffs."] =
  "Si coché, les infobulles des unités afficheront les affaiblissements de l'unité.";
L["Set border color by debuff type"] =
  "Définir la couleur de la bordure par type de debuff";
L["If enabled, the border color of debuffs will be based on the type of debuff (e.g., poisons will appear with a green border color)."] =
  "Si activé, la couleur de la bordure des debuffs sera basée sur le type de debuff (par exemple, les poisons apparaîtront avec une couleur de bordure verte).";
L["Set whether you want the unit's debuffs to appear above or below the tooltip."] =
  "Définir si vous voulez que les débuffs de l'unité apparaissent au-dessus ou en dessous de l'info-bulle.";
L["Buff and Debuff Ordering"] = "Ordre de buff et de debuff";
L["Debuffs Above Buffs"] = "Débuffs au-dessus des buffs";
L["Buffs Above Debuffs"] = "Buffs au-dessus des debuffs";
L["Non-Player Alpha"] = "Alpha non-joueur";
L["Sets the alpha of timer bars for auras not produced by you (i.e., other player or NPC buffs and debuffs)."] =
  "Définit l'alpha des barres de minuterie pour les auras que vous n'avez pas produites (c'est-à-dire les buffs et debuffs d'autres joueurs ou PNJ).";
L["Show Professions"] = "Afficher les Métiers";
L["Show AddOn Shortcuts"] =
  "Afficher les raccourcis des modules complémentaires";
L["Profile Manager"] = "Gestionnaire de profil";
L["Config Menu"] = "Menu de configuration";
L["Show Profiles"] = "Afficher les profils";
L["Report"] = "Signaler";
L["Toggle Alignment Grid"] = "Basculer la grille d'alignement";
L["Guild Bank"] = "Banque de guilde";
L["Bank"] = "Banque";
L["Void Storage"] = "Stockage nul";
L["You have no professions."] = "Vous n'avez pas de professions.";
L["remaining"] = "restant";
L["Fixed Color"] = "Couleur fixe";
L["Main Container"] = "Conteneur principal";
L["Talking Head Frame"] = "Cadre de la tête parlante";
L["This is the animated character portrait frame that shows when an NPC is talking to you."] =
  "Il s'agit du cadre de portrait de personnage animé qui montre quand un PNJ vous parle.";
L["Top of Screen"] = "Haut de l'écran";
L["Bottom of Screen"] = "Bas de l'écran";
L["Pulse While Resting"] = "Pulse au repos";
L["If enabled, the unit panels will fade in and out while resting."] =
  "Si activé, les panneaux de l'unité s'allumeront et s'éteindront pendant le repos.";
L["Target Class Color Gradient"] = "Dégradé de couleur de la classe cible";
L["If enabled, the unit panel color will transition to the target's class color using a horizontal gradient effect."] =
  "Si activé, la couleur du panneau de l'unité passera à la couleur de la classe de la cible en utilisant un effet de dégradé horizontal.";
L["Set Pulse Strength"] = "Définir la force d'impulsion";
L["Set Alpha"] = "Définir Alpha";
L["If checked, the reputation bar will use a fixed color instead of dynamically changing based on your reputation with the selected faction."] =
  "Si coché, la barre de réputation utilisera une couleur fixe au lieu de changer dynamiquement en fonction de votre réputation auprès de la faction sélectionnée.";
L["Use Fixed Color"] = "Utiliser une couleur fixe";
L["Reputation Colors"] = "Couleurs de réputation";
L["Show"] = "Spectacle";
L["Hide"] = "Cacher";
L["Enable Test Mode"] = "Activer le mode test";
L["Disable Test Mode"] = "Désactiver le mode test";
L["Icon Position"] = "Position de l'icône";
L["If checked, this module will be enabled."] =
  "Si coché, ce module sera activé.";
L["Test mode allows you to easily customize the looks and positioning of widgets by forcing all widgets to be shown."] =
  "Le mode test vous permet de personnaliser facilement l'apparence et le positionnement des widgets en forçant tous les widgets à être affichés.";
L["Mini-Map Widgets"] = "Mini-carte Widgets";
L["Clock"] = "L'horloge";
L["Dungeon Difficulty"] = "Difficulté du donjon";
L["Looking For Group Icon"] = "Recherche d'icône de groupe";
L["New Mail Icon"] = "Nouvelle icône de courrier";
L["Missions Icon"] = "Icône des missions";
L["This button opens the most relevant missions menu for your character. The menu will either show missions for your Covenant Sanctum, Class Order Hall, or your Garrison."] =
  "Ce bouton ouvre le menu de missions le plus pertinent pour votre personnage. Le menu affichera soit les missions de votre Sanctum du Pacte, votre salle d'ordre de classe ou votre garnison.";
L["Tracking Icon"] = "Icône de suivi";
L["When hidden, you can still access tracking options from the Minimap right-click menu."] =
  "Lorsqu'il est masqué, vous pouvez toujours accéder aux options de suivi à partir du menu contextuel de la mini-carte.";
L["Zone Name"] = "Nom de la zone";
L["Apply Scaling"] = "Appliquer la mise à l'échelle";
L["Show MUI Key Bindings"] = "Afficher les liaisons de touches MUI";
L["Tutorial: Step 2"] = "Tutoriel : Étape 2";
L["Tutorial: Step 1"] = "Tutoriel : Étape 1";
L["Open Config Menu"] = "Ouvrir le menu de configuration";
L["Config"] = "Configuration";
L["Unit Frame Panels"] = "Panneaux de cadre unitaire";
L["Tooltips"] = "Info-bulles";
L["Show Food and Drink"] = "Montrer la nourriture et les boissons";
L["If checked, the food and drink buff will be displayed as a castbar."] =
  "Si coché, le buff de nourriture et de boisson sera affiché comme une barre de coulée.";
L["Blend Mode"] = "Mode de fusion";
L["Changing the blend mode will affect how alpha channels blend with the background."] =
  "La modification du mode de fusion affectera la façon dont les canaux alpha se fondent avec l'arrière-plan.";
L["Background"] = "Arrière-plan";
L["Button"] = "Bouton";
L["Combat Timer"] = "Minuteur de combat";
L["Volume Options"] = "Options de volume";
L["Specialization"] = "Spécialisation";
L["Show Auras With Unknown Time Remaining"] =
  "Afficher les auras avec un temps restant inconnu";
L["Show Buffs"] = "Afficher les amateurs";
L["Show Debuffs"] = "Afficher les debuffs";
L["Refresh Chat Text"] = "Actualiser le texte du chat";
L["Back"] = "Dos";
L["Next"] = "Suivant";
L["Set short, custom aliases for chat channel names."] =
  [[Définissez des alias courts et personnalisés pour les noms de canaux de discussion.]]
L["The main container holds the unit frame panels, action bar panels, data-text bar, and all resource bars at the bottom of the screen."] =
  "Le conteneur principal contient les panneaux du cadre de l'unité, les panneaux de la barre d'action, la barre de texte de données et toutes les barres de ressources en bas de l'écran.";
L["Add Text Highlighting"] = "Ajouter une surbrillance de texte";
L["Channel Name Aliases"] = "Alias de nom de chaîne";
L["Text Highlighting"] = "Surlignement du texte";
L["Alias Brightness"] = "Alias Luminosité";
L["Auction House Open"] = "Ouverture de l'hôtel des ventes";
L["Auction House Close"] = "Fermeture de l'hôtel des ventes";
L["Alarm Clock Warning 1"] = "Avertissement réveil 1";
L["Alarm Clock Warning 2"] = "Alarme réveil 2";
L["Alarm Clock Warning 3"] = "Alarme réveil 3";
L["Enter Queue"] = "Entrer dans la file d'attente";
L["Jewel Crafting Socket"] = "Douille de fabrication de bijoux";
L["Loot Money"] = "Loot argent";
L["Map Ping"] = "Carte Ping";
L["Queue Ready"] = "File d'attente prête";
L["Raid Warning"] = "Avertissement de raid";
L["Raid Boss Warning"] = "Avertissement du boss de raid";
L["Ready Check"] = "Contrôle prêt";
L["Repair Item"] = "Réparer l'article";
L["Whisper Received"] = "Murmure reçu";
L["Server Channels"] = "Canaux de serveur";
L["Text to Highlight (case insensitive):"] =
  "Texte à mettre en surbrillance (insensible à la casse):";
L["Enter text to highlight:"] = "Entrez le texte à mettre en surbrillance :";
L["Show in Upper Case"] = "Afficher en majuscule";
L["Set Color"] = "Définir la couleur";
L["Edit Text"] = "Éditer le texte";
L["Play a sound effect when any of the selected text appears in chat."] =
  "Jouer un effet sonore lorsque l'un des textes sélectionnés apparaît dans le chat.";
L["Play Sound"] = "Jouer son";
L["Set Timestamp Color"] = "Définir la couleur de l'horodatage";
L["Use Fixed Timestamp Color"] = "Utiliser une couleur d'horodatage fixe";
L["Timestamps"] = "Horodatage";
L["Enable Custom Aliases"] = "Activer les alias personnalisés";
L["Dangerous Actions!"] = "Actions dangereuses !";
L["Cannot delete the Default profile."] =
  "Impossible de supprimer le profil par défaut.";
L["Are you sure you want to delete profile '%s'?"] =
  "Êtes-vous sûr de vouloir supprimer le profil '%s' ?";
L["DELETE"] = "EFFACER";
L["Please type '%s' to confirm:"] = "Veuillez saisir '%s' pour confirmer :";
L["Enter a new unique profile name:"] =
  "Entrez un nouveau nom de profil unique :";
L["Current Profile:"] = "Profil actuel :";
L["Show the MUI Config Menu"] = "Afficher le menu de configuration MUI";
L["Show the MUI Installer"] = "Afficher le programme d'installation MUI";
L["List All Profiles"] = "Liste tous les profils";
L["Show the MUI Profile Manager"] = "Afficher le gestionnaire de profil MUI";
L["Set Profile"] = "Définir le profil";
L["Show Currently Active Profile"] = "Afficher le profil actuellement actif";
L["Show the Version of MUI"] = "Afficher la version de MUI";
L["Show the MUI Layout Tool"] = "Afficher l'outil de mise en page MUI";
L["Some settings will not be changed until the UI has been reloaded."] =
  "Certains paramètres ne seront pas modifiés tant que l'interface utilisateur n'aura pas été rechargée.";
L["Would you like to reload the UI now?"] =
  "Voulez-vous recharger l'interface utilisateur maintenant ?";
L["No"] = "Non";
L["Profile changed to %s."] = "Profil changé en %s.";
L["Profile %s has been reset."] = "Le profil %s a été réinitialisé.";

---------------------------------
--- LARGE TEXT:
---------------------------------
L["TT_MUI_CONTROL_SUF"] = [[Si activé, MUI repositionnera l'unité masquée
Cadres pour s'adapter sur le dessus des panneaux d'unité MUI.

Il déplacera également automatiquement les cadres d'unité lorsque
étendre et rétracter le panneau de la barre d'action MUI.]];

L["TT_MUI_USE_TARGET_CLASS_COLOR"] =
  [[Si coché, le dégradé portrait cible utilisera la classe de la cible
couleur au lieu d'utiliser les valeurs RVB 'Start Color'. Ce sera
utilisez toujours les valeurs RVB Alpha et 'End Color'.]];

L["MUI_Setup_InfoTab"] = [[Communauté Discord :
%s

Visitez le site officiel de MayronUI pour plus d'informations :
%s

Le dépôt officiel GitHub :
%s

Devenez mécène et gagnez des avantages exclusifs au sein de la communauté :
%s

Visitez la chaîne YouTube officielle de Mayron :
%s]]

L["MUI_Setup_CreditsTab"] =
  [[Des remerciements particuliers vont aux membres suivants de la communauté MayronUI pour leurs contributions au projet (voir l'onglet d'informations pour le lien pour rejoindre notre communauté Discord) :

|cff00ccff> Mécènes|r
%s

|cff00ccff> Développement et corrections de bogues|r
%s

|cff00ccff> Assistance à la traduction|r
%s

|cff00ccff> Équipe d'assistance communautaire|r
%s

Et bien sûr, merci aux auteurs des modules complémentaires non MayronUI inclus dans ce pack d'interface utilisateur.]]

L["PRESS_HOLD_TOGGLE_BUTTONS"] =
[[Appuyez et maintenez %s hors combat pour afficher les boutons à bascule.

En cliquant dessus, vous afficherez ou masquerez des lignes supplémentaires de la barre d'action.]]

L["CHANGE_KEYBINDINGS"] =
[[Vous pouvez modifier cette combinaison de touches dans le menu de configuration MUI (%s).

Il y a 3 raccourcis clavier pour basculer rapidement entre 1 à 3 rangées,
trouvé dans le menu des raccourcis clavier de Blizzard :]]

L["THANK_YOU_FOR_INSTALLING"] = [[Merci d'avoir installé MayronUI !

Vous pouvez entièrement personnaliser l'interface utilisateur
à l'aide du menu de configuration :]]

L["SHOW_AURAS_WITH_UNKNOWN_TIME_TOOLTIP"] =
  [[Si activé, les auras avec un temps restant inconnu, ainsi que les auras qui ne
expirera à moins d'être annulé, sera affiché dans le champ de la barre de minuterie et
ne s'épuise jamais. La barre disparaîtra toujours si l'aura est supprimée.

En classique, le temps restant de certaines auras (selon la situation)
peut ne pas être connu du joueur et sera masqué à moins que cela ne soit activé.]]

L["MANAGE_PROFILES_HERE"] = [[Vous pouvez gérer les profils de personnages ici.

Par défaut, chaque personnage a son propre profil unique.]]

L["UNIQUE_CHARACTER_PROFILE"] =
  [[Par défaut, chaque nouveau personnage se verra automatiquement attribuer un profil de personnage unique au lieu d'un seul profil par défaut.

Les profils ne sont automatiquement attribués qu'après l'installation de l'interface utilisateur sur un nouveau personnage.]]

L["AURAS_ORDERING_ON_TOOLTIP"] =
  [[Le paramètre ci-dessous contrôle l'ordre des auras sur l'info-bulle
lorsque les buffs et les debuffs sont positionnés ensemble
(au-dessus ou au-dessous de l'info-bulle) et sont tous deux activés.]]

L["MANAGE_TEXT_HIGHLIGHTING"] =
  [[Gérer le texte à surligner et éventuellement
jouer un effet sonore lorsqu'ils apparaissent dans le chat.]]

L["NO_HIGHLIGHT_TEXT_ADDED"] = [[Vous n'avez pas encore ajouté de texte !
Appuyez sur le bouton « Modifier le texte » ci-dessous pour ajouter du texte à mettre en surbrillance:]];

L["Reset Chat Settings"] = "Réinitialiser les paramètres de chat";
L["RESET_CHAT_SETTINGS_TOOLTIP"] = "Si vous décochez cette case, vos onglets de chat et les paramètres de chat Blizzard associés à chaque fenêtre de chat seront préservés.";

L["MayronUI AddOn Presets"] = "Préréglages du module complémentaire MayronUI";
L["No Supported AddOns Loaded"] = "Aucun add-on pris en charge n'a été chargé";
L["The following selected addons will have their settings reset to the MayronUI preset settings:"] = "Les addons sélectionnés suivants verront leurs paramètres réinitialisés aux paramètres prédéfinis de MayronUI :";
L["There is a newer MayronUI preset available for %s."] = "Un nouveau préréglage MayronUI est disponible pour %s.";
L["Would you like to install it?"] = "Souhaitez-vous l'installer ?";
L["Warning! This will wipe all customizations you have made to %s."] = "Avertissement! Cela effacera toutes les personnalisations que vous avez apportées à %s.";
L["Install Preset"] = "Installer le préréglage";
L["Skip this Version"] = "Passez cette version";
L["You can always install presets at anytime from the custom install tab located on the MayronUI installer."] = "Vous pouvez toujours installer des préréglages à tout moment à partir de l'onglet d'installation personnalisée situé sur le programme d'installation de MayronUI.";
L["Hint: Type %s to access the installer."] = "Conseil : saisissez %s pour accéder au programme d'installation.";
L["Set Arrow Button Visibility"] = "Définir la visibilité des boutons fléchés";
L["Hide Arrow Buttons In Combat"] = "Masquer les boutons fléchés en combat";
L["Set Width Mode"] = "Définir le mode de largeur";
L["If set to dynamic, MayronUI will calculate the optimal width for the selected Bartender4 action bars to fit inside the panel."] = "S'il est défini sur dynamique, MayronUI calculera la largeur optimale pour que les barres d'action Bartender4 sélectionnées tiennent dans le panneau.";
L["Set Panel Padding"] = "Définir le rembourrage du panneau";
L["Set Height Mode"] = "Définir le mode de hauteur";
L["If set to dynamic, MayronUI will calculate the optimal height for the selected Bartender4 action bars to fit inside the panel."] = "S'il est défini sur dynamique, MayronUI calculera la hauteur optimale pour que les barres d'action Bartender4 sélectionnées tiennent dans le panneau.";
L["Set the modifier key/s that should be pressed to show the arrow buttons."] = "Définissez la ou les touches de modification sur lesquelles appuyer pour afficher les boutons fléchés.";
L["Set Animation Speed"] = "Définir la vitesse d'animation";
L["These settings control the MayronUI artwork behind the Bartender4 action bars."] = "Ces paramètres contrôlent l'illustration MayronUI derrière les barres d'action Bartender4.";
L["Background Panel Settings"] = "Paramètres du panneau d'arrière-plan";
L["Bottom Panel"] = "Panneau du bas";
L["Action Bars"] = "Barres d'action";
L["Popular Settings"] = "Paramètres populaires";
L["Global Settings"] = "Paramètres globaux";
L["These settings are applied account-wide"] = "Ces paramètres sont appliqués à l'ensemble du compte";
L["Override Master Font"] = "Remplacer la police principale";
L["Override Combat Font"] = "Remplacer la police de combat";
L["Combat Font"] = "Police de combat";
L["This font is used to display the damage and healing combat numbers."] = "Cette police est utilisée pour afficher les numéros de combat de dégâts et de soins.";
L["Blizzard Frames"] = "Cadres Blizzard";
L["Clamped to Screen"] = "Fixé à l'écran";
L["If checked, Blizzard frames cannot be dragged outside of the screen."] = "Si cette case est cochée, les cadres Blizzard ne peuvent pas être déplacés en dehors de l'écran.";
L["Reset Positions"] = "Réinitialiser les positions";
L["Blizzard frame positions have been reset."] = "Les positions des cadres de Blizzard ont été réinitialisées.";
L["Set the alpha change while pulsing/flashing."] = "Réglez le changement alpha tout en pulsant/clignotant.";
L["Dynamic"] = "Dynamique";
L["Manual"] = "Manuel";
L["Manual Height Mode Settings"] = "Paramètres du mode de hauteur manuelle";
L["Set Row 1 Height"] = "Définir la hauteur de la ligne 1";
L["Set Row 2 Height"] = "Définir la hauteur de la ligne 2";
L["Set Row 3 Height"] = "Définir la hauteur de la ligne 3";
L["Side Panel"] = "Panneau latéral";
L["Set Y-Offset"] = "Définir le décalage Y";
L["Manual Side Panel Widths"] = "Largeurs des panneaux latéraux manuels";
L["Set Column 1 Width"] = "Définir la largeur de la colonne 1";
L["Set Column 2 Width"] = "Définir la largeur de la colonne 2";
L["Bartender4 Override Settings"] = "Paramètres de remplacement de Bartender4";
L["These settings control what MayronUI is allowed to do with the Bartender4 action bars. By default, MayronUI:"] = "Ces paramètres contrôlent ce que MayronUI est autorisé à faire avec les barres d'action Bartender4. Par défaut, MayronUI :";
L["Fades action bars in and out when you press the provided arrow buttons."] = "Fait apparaître et disparaître les barres d'action lorsque vous appuyez sur les boutons fléchés fournis.";
L["Maintains the visibility of action bars between sessions of gameplay."] = "Maintient la visibilité des barres d'action entre les sessions de gameplay.";
L["Sets the scale and padding of action bar buttons to best fit inside the background panels."] = "Définit l'échelle et le rembourrage des boutons de la barre d'action pour s'adapter au mieux aux panneaux d'arrière-plan.";
L["Sets and updates the position the action bars so they remain in place ontop of the background panels."] = "Définit et met à jour la position des barres d'action afin qu'elles restent en place sur les panneaux d'arrière-plan.";
L["Bottom Bartender4 Action Bars"] = "Barres d'action Bottom Bartender4";
L["If enabled, MayronUI will move the selected Bartender4 action bars into the correct position for you."] = "Si activé, MayronUI déplacera les barres d'action Bartender4 sélectionnées dans la position correcte pour vous.";
L["Control Bar Positioning"] = "Positionnement de la barre de contrôle";
L["Override Bar Padding"] = "Remplacer le rembourrage de la barre";
L["If enabled, MayronUI will set the padding of the selected Bartender4 action bar to best fit the background panel."] = "S'il est activé, MayronUI définira le rembourrage de la barre d'action Bartender4 sélectionnée pour s'adapter au mieux au panneau d'arrière-plan.";
L["Override Bar Scale"] = "Remplacer l'échelle de la barre";
L["If enabled, MayronUI will set the scale of the selected Bartender4 action bar to best fit the background panel."] = "Si elle est activée, MayronUI définira l'échelle de la barre d'action Bartender4 sélectionnée pour s'adapter au mieux au panneau d'arrière-plan.";
L["Set Row Spacing"] = "Définir l'espacement des lignes";
L["Set Bar Padding"] = "Définir le rembourrage de la barre";
L["Set Bar Scale"] = "Définir l'échelle de la barre";
L["The bottom panel can display and control up to two Bartender4 action bars per row."] = "Le panneau inférieur peut afficher et contrôler jusqu'à deux barres d'action Bartender4 par ligne.";
L["Side Bartender4 Action Bars"] = "Barres d'action Side Bartender4";
L["Set Column Spacing"] = "Définir l'espacement des colonnes";
L["Column"] = "Colonne";
L["Power"] = "Puissance du joueur";
L["Positioning and Visibility Options"] = "Options de positionnement et de visibilité";
L["Configure each type of anchor point and tooltip type"] = "Configurez chaque type de point d'ancrage et le type d'info-bulle";
L["Assigning tooltips to the mouse anchor point will fix them to your mouse cursor, causing them to follow your mouse movements."] = "L'attribution d'info-bulles au point d'ancrage de la souris les fixera au curseur de votre souris, les obligeant à suivre les mouvements de votre souris.";
L["Assigning tooltips to the screen anchor point will fix them to that single spot and will not move."] = "L'attribution d'info-bulles au point d'ancrage de l'écran les fixera à cet endroit unique et ne bougera pas.";
L["World units are 3D player models within the world and are not part of the UI."] = "Les unités mondiales sont des modèles de joueur 3D dans le monde et ne font pas partie de l'interface utilisateur.";
L["Unit frame tooltips are the UI frames that represent NPCs or players."] = "Les infobulles des cadres d'unité sont les cadres de l'interface utilisateur qui représentent les PNJ ou les joueurs.";
L["Standard tooltips are any other tooltip with no special category (i.e., inventory item and spell tooltips have their own unique category and will not be affected)."] = "Les infobulles standard sont toutes les autres infobulles sans catégorie spéciale (c'est-à-dire que les infobulles d'objets d'inventaire et de sorts ont leur propre catégorie unique et ne seront pas affectées).";
L["Unit Frame Tooltips"] = "Info-bulles du cadre d'unité";
L["World Unit Tooltips"] = "Infobulles des unités mondiales";
L["Standard Tooltips"] = "Info-bulles standards";
L["Choose an Anchor Point:"] = "Choisissez un point d'ancrage :";
L["Visibility Options:"] = "Options de visibilité :";
L["Set Shown"] = "Ensemble affiché";
L["If unchecked, tooltips of this type will never show"] = "Si décochée, les info-bulles de ce type ne s'afficheront jamais";
L["If unchecked, tooltips of this type will not show while you are in combat."] = "Si elle n'est pas cochée, les infobulles de ce type ne s'afficheront pas pendant que vous êtes en combat.";
L["Hide in Combat"] = "Cachez-vous au combat";
L["Mouse"] = "Souris";
L["Screen"] = "Écran";
L["Mouse Anchor Point"] = "Point d'ancrage de la souris";
L["Screen Anchor Point"] = "Point d'ancrage de l'écran";
L["Export Profile"] = "Profil d'exportation";
L["Export the current profile into a string that can be imported by other players."] = "Exportez le profil actuel dans une chaîne qui peut être importée par d'autres joueurs.";
L["Copy the import string below and give it to other players so they can import your current profile."] = "Copiez la chaîne d'importation ci-dessous et donnez-la aux autres joueurs afin qu'ils puissent importer votre profil actuel.";
L["Close"] = "Fermer";
L["Import Profile"] = "Profil d'importation";
L["Import a profile from another player from an import string."] = "Importez un profil d'un autre joueur à partir d'une chaîne d'importation.";
L["Paste an import string into the box below to import a profile."] = "Collez une chaîne d'importation dans la zone ci-dessous pour importer un profil.";
L["Warning: This will completely replace your current profile with the imported profile settings!"] = "Attention : Cela remplacera complètement votre profil actuel par les paramètres de profil importés !";
L["Successfully imported profile settings into your current profile!"] = "Les paramètres de profil ont été importés avec succès dans votre profil actuel !";
L["Reset to default"] = "Rétablir les paramètres par défaut";
L["Appearance Settings"] = "Paramètres d'apparence";
L["MUI_FRAMES_COLOR_TOOLTIP"] = "Contrôle la couleur d'arrière-plan des cadres MUI, y compris le cadre d'inventaire, les info-bulles, le menu de configuration, l'outil de mise en page, etc.";
L["Set Display Mode"] = "Définir le mode d'affichage";
L["These settings relate to the individual aura icons/bars."] = "Ces paramètres concernent les icônes/barres d'aura individuelles.";
L["These settings relate to the frame containing the individual aura icons/bars."] = "Ces paramètres se rapportent au cadre contenant les icônes/barres d'aura individuelles.";
L["Set Non-Player Alpha"] = "Définir l'alpha non-joueur";
L["Icon Width"] = "Largeur de l'icône";
L["Icon Height"] = "Hauteur de l'icône";
L["If true, when the aura is close to expiring the aura frame will fade in and out."] = "Si c'est vrai, lorsque l'aura est sur le point d'expirer, le cadre de l'aura s'estompera.";
L["The alpha of auras not applied by you."] = "L'alpha des auras non appliqué par vous.";
L["Icon Spacing"] = "Espacement des icônes";
L["Show Bar Spark"] = "Afficher la barre Étincelle";
L["Container Frame Settings"] = "Paramètres du cadre du conteneur";
L["Positioning"] = "Positionnement";
L["Rows and Columns"] = "Lignes et colonnes";
L["The maximum number of aura icons to display per row."] = "Le nombre maximum d'icônes d'aura à afficher par ligne.";
L["The maximum number of horizontal bar columns to display."] = "Le nombre maximum de colonnes de barres horizontales à afficher.";
L["Text Settings"] = "Paramètres de texte";
L["Aura Frame"] = "Cadre d'aura";
L["Icon Frame"] = "Cadre d'icône";
L["Icon"] = "Icône";
L["Normal Font Size"] = "Taille de police normale";
L["Warning Font Size"] = "Taille de la police d'avertissement";
L["Warning Threshold"] = "Seuil d'avertissement";
L["The minimum number of seconds remaining required for the time remaining text to use the warning font size."] = "Le nombre minimum de secondes restantes requises pour que le texte de temps restant utilise la taille de police d'avertissement.";
L["Text Colors"] = "Couleurs du texte";
L["Aura Type Colors"] = "Couleurs des types d'aura";
L["Basic Buff"] = "Bonus de base";
L["Player Owned Buff"] = "Bonus appartenant au joueur";
L["Buffs that you applied to yourself."] = "Les buffs que vous vous êtes appliqués.";
L["Basic Debuff"] = "Debuff de base";
L["Bar Colors"] = "Couleurs des barres";
L["Borders"] = "Les frontières";
L["Enable Inventory Frame"] = "Activer le cadre d'inventaire";
L["Use the MayronUI custom inventory frame instead of the default Blizzard bags UI."] = "Utilisez le cadre d'inventaire personnalisé MayronUI au lieu de l'interface utilisateur par défaut des sacs Blizzard.";
L["Use Class Colors"] = "Utiliser les couleurs de classe";
L["If checked, tooltips for other players will be colored based on their class."] = "Si cette case est cochée, les infobulles des autres joueurs seront colorées en fonction de leur classe.";
L["Switch to Detailed View"] = "Passer à la vue détaillée";
L["Switch to Grid View"] = "Basculer vers la vue Grille";
L["View Character Inventory"] = "Afficher l'inventaire des personnages";
L["Toggle Bags Bar"] = "Basculer la barre des sacs";
L["Quest Items"] = "Objets de quête";
L["Trade Goods"] = "Marchandises";
L["Consumables"] = "Consommables";
L["Equipment"] = "Équipement";
L["All Items"] = "Tous les articles";
L["Padding"] = "Rembourrage";
L["Slot Height"] = "Hauteur de fente";
L["Max Slot Width"] = "Largeur maximale de la fente";
L["Min Slot Width"] = "Largeur minimale de la fente";
L["If checked, item levels will show on top of the icons of equipment and weapon items."] = "Si cette case est cochée, les niveaux d'objets s'afficheront au-dessus des icônes d'équipement et d'armes.";
L["The maximum number of icons that can appear per row when resizing the inventory frame using the grid view."] = "Le nombre maximal d'icônes pouvant apparaître par ligne lors du redimensionnement du cadre d'inventaire à l'aide de la vue en grille.";
L["Max Icons Per Row"] = "Icônes max par ligne";
L["Show Quest Items Tab"] = "Afficher l'onglet Objets de quête";
L["Show Trade Goods Tab"] = "Afficher l'onglet Marchandises";
L["Show Consumables Tab"] = "Afficher l'onglet Consommables";
L["Show Equipment Tab"] = "Afficher l'onglet Équipement";
L["Show Tab Buttons"] = "Afficher les boutons d'onglet";
L["Tab Button Options"] = "Options du bouton d'onglet";
L["MUI Frames Color"] = "Couleur des cadres MUI";
L["Theme Color"] = "Couleur du thème";
L["Class Color"] = "Couleur de classe";
L["Color Scheme"] = "Schéma de couleur";
L["Font Options"] = "Options de police";
L["Show Item Name"] = "Afficher le nom de l'élément";
L["Item Name Font Size"] = "Taille de la police du nom de l'élément";
L["If checked, item levels will be shown in description of equipment and weapon items."] = "Si cette case est cochée, les niveaux d'objets seront affichés dans la description des équipements et des armes.";
L["Show Item Type"] = "Afficher le type d'élément";
L["Item Description Font Size"] = "Élément Description Taille de la police";
L["Grid View"] = "Vue Grille";
L["Detailed View"] = "Vue détaillée";
L["Settings"] = "Paramètres";
L["Points of Interest"] = "Points d'interêts";
L["If checked, the points of interest arrows will be shown."] = "Si cette case est cochée, les flèches des points d'intérêt seront affichées.";