local L = _G.LibStub("AceLocale-3.0"):NewLocale("MayronUI", "deDE");
if not L then
  return
end

---------------------------------
--- SMALL TEXT:
---------------------------------
L["Character"] = "Charakter";
L["Bags"] = "Taschen";
L["Friends"] = "Freunde";
L["Guild"] = "Gilde";
L["Help Menu"] = "Hilfe Menü";
L["PVP"] = "PVP";
L["Spell Book"] = "Zauber Buch";
L["Talents"] = "Talente";
L["Achievements"] = "Erfolge";
L["Glyphs"] = "Glyphen";
L["Calendar"] = "Kalender";
L["LFD"] = "LFD";
L["Enable Max Camera Zoom"] = "Aktivieren Sie den maximalen Kamerazoom";
L["Move AddOn Buttons"] = "AddOn-Buttons verschieben";
L["MOVE_ADDON_BUTTONS_TOOLTIP"] = "Wenn diese Option aktiviert ist, werden die Addon-Symbolschaltflächen, die oben auf der Minikarte erscheinen, in das Rechtsklickmenü der Minikarte verschoben.";
L["Raid"] = "Raid";
L["Encounter Journal"] = "Dungeon Kompendium";
L["Collections Journal"] = "Sammlungen";
L["Macros"] = "Makros";
L["Skills"] = "Fähigkeiten";
L["World Map"] = "Karte";
L["Quest Log"] = "Aufgaben";
L["Show Online Friends"] = "Online-Freunde anzeigen";
L["Toggle Friends List"] = "Freundesliste ein-/ausblenden";
L["Show Guild Members"] = "Gildenmitglieder anzeigen";
L["Toggle Guild Pane"] = "Gildenbereich ein-/ausblenden";
L["Quests"] = "Quests";
L["Reputation"] = "Ruf";
L["PVP Score"] = "PVP Wertung";
L["Currency"] = "Währung";
L["MUI Layout Button"] = "MUI Layout Taste";
L["Left Click:"] = "Links Klick:";
L["Switch Layout"] = "Layout wechseln";
L["Middle Click:"] = "Mittel Klick:";
L["Toggle Blizzard Speech Menu"] = "Blizzard Chat Menü";
L["Right Click:"] = "Rechts Klick:";
L["Show Layout Config Tool"] = "Zeige Layout Konfig-Tool";
L["ALT + Left Click:"] = "ALT + Links Klick:";
L["Toggle Tooltip"] = "Tooltip";
L["Edit Box (Message Input Box)"] = "Eingabebox (zum schreiben)";
L["Background Color"] = "Hintergrund Farbe";
L["Backdrop Inset"] = "Hintergrund einlassen";
L["Chat Frame Options"] = "Chat Fenster Einstellungen";
L["Enable Chat Frame"] = "Aktiviere Chat Fenster";
L["Options"] = "Einstellungen";
L["Button Swapping in Combat"] = "Schaltflächenwechsel im Kampf";
L["Standard Chat Buttons"] = "Standard Chat Schaltflächen";
L["Left Button"] = "Linke Schaltfläche";
L["Middle Button"] = "Mittlere Schaltfläche";
L["Right Button"] = "Rechte Schaltfläche";
L["Shift"] = "Umschalt"; -- Mod-Key!
L["Ctrg"] = "Strg"; -- Mod-Key!
L["Alt"] = "Alt"; -- Mod-Key!
L["Chat Buttons with Modifier Key 1"] = "Chat Schaltflächen - 1. Mod-Taste";
L["Chat Buttons with Modifier Key 2"] = "Chat Schaltflächen - 2. Mod-Taste";
L["Set the border size."] = "Setzt die Randbreite.";
L["Cannot toggle menu while in combat."] =
  "Das Menü kann im Kampf nicht umgeschaltet werden.";
L["Cannot switch layouts while in combat."] =
  "Layouts können im Kampf nicht gewechselt werden.";
L["Cannot install while in combat."] =
  "Kann während des Kampfes nicht installiert werden.";
L["Set the spacing between the background and the border."] =
  "Setzt den Abstand zwischen Hintergrund und Rand.";
L["Allow the use of modifier keys to swap chat buttons while in combat."] =
  "Erlaubt die Nutzung der Mod-Tasten zum wechseln der Chat-Schaltflächen, während man sich im Kampf befindet.";
L["Failed to load MUI_Config. Possibly missing?"] =
  "MUI_Config konnte nicht geladen werden! Evtl. fehlt das Addon?";
L["List of slash commands:"] = "Liste der Slash-Befehle:";
L["Welcome back"] = "Willkommen zurück";
L["Starter Edition accounts cannot perform this action."] =
  "Sorry, das geht nicht mit der Starter Edition.";
L["Loot Specialization set to: Current Specialization"] =
  "Die Beute Spezialisierung entspricht der Spezialisierung:";
L["Must be level 10 or higher to use Talents."] =
  "Talente sind erst ab Level 10 verfügbar.";
L["Requires level 10+ to view the PVP window."] =
  "PVP ist erst ab Level 10 verfügbar.";
L["Requires level 10+ to view the Glyphs window."] =
  "Glyphen sind erst ab Level 10 verfügbar";
L["Requires being inside a Battle Ground."] =
  "Sie müssen sich in einem Schlachtfeld befinden.";
L["Choose Spec"] = "Spezialisierung wählen";
L["Choose Loot Spec"] = "Beutespezialisierung wählen";
L["Current Spec"] = "Aktive Spezialisierung";
L[" (current)"] = " (aktuell)";
L["Toggle Bags"] = "Taschen umschalten";
L["Sort Bags"] = "Taschen sortieren";
L["Commands"] = "Befehle";
L["Armor"] = "Rüstung";
L["Head"] = "Kopf";
L["Shoulder"] = "Schulter";
L["Chest"] = "Brust";
L["Waist"] = "Tailie";
L["Legs"] = "Beine";
L["Feet"] = "Füße";
L["Wrist"] = "Arme";
L["Hands"] = "Hände";
L["Main Hand"] = "Haupthand";
L["Secondary Hand"] = "Nebenhand";
L["Zone"] = "Zone";
L["Rank"] = "Rang";
L["<none>"] = "<Keine>";
L["Notes"] = "Anmerkungen";
L["Achievement Points"] = "Erfolgspunkte";
L["No Guild"] = "Keine Gilde";
L["No Spec"] = "Keine Spezialisierung";
L["Current Money"] = "Aktuelles Vermögen";
L["Start of the day"] = "Bei Tagesbeginn";
L["Today's profit"] = "Tagesprofit";
L["Money per character"] = "Vermögen je Charakter";
L["Guild Chat"] = "Gildenchat";
L["Whispers"] = "Private Nachrichten";
L[" CastBar not enabled."] = " Castbar ist nicht aktiviert.";
L["Lock"] = "Sperren";
L["Unlock"] = "Freigeben";
L["Appearance"] = "Aussehen";
L["Bar Texture"] = "Textur";
L["Border"] = "Rand";
L["Border Size"] = "Randbreite";
L["Frame Inset"] = "Rahmen einlassen";
L["Colors"] = "Farben";
L["Normal Casting"] = "Zaubernd";
L["Not Interruptible"] = "Nicht unterbrechen";
L["Finished Casting"] = "Zaubern beendet";
L["Interrupted"] = "Unterbrochen";
L["Latency"] = "Latenz";
L["Backdrop"] = "Hintergrund";
L["Individual Cast Bar Options"] = "Individuelle CastBar Einstellungen";
L["Enable Bar"] = "Aktiviere Leiste";
L["Show Icon"] = "Zeige Icon";
L["Show Latency Bar"] = "Zeige Latenz";
L["Anchor to SUF Portrait Bar"] = "Verankere am SUF Portrait";
L["Width"] = "Breite";
L["Height"] = "Höhe";
L["Frame Strata"] = "Darstellungsschicht";
L["Frame Level"] = "Darstellungsebene";
L["Manual Positioning"] = "Manuelle Positionierung";
L["Point"] = "Punkt";
L["Relative Frame"] = "Relativ zu Rahmen";
L["Relative Point"] = "Relativ zu Punkt";
L["X-Offset"] = "X Offset";
L["Y-Offset"] = "Y Offset";
L["Player"] = "Spieler";
L["Target"] = "Ziel";
L["Focus"] = "Fokus";
L["Mirror"] = "Spiegel";
L["Pet"] = "Begleiter";
L["If enabled the Cast Bar will be fixed to the %s Unit Frame's Portrait Bar (if it exists)."] =
  "Wenn aktiviert, wird die CastBar am %s Einheiten Fenster verankert. (Sofern existent!)";
L["The %s Unit Frames's Portrait Bar needs to be enabled to use this feature."] =
  "Das %s Einheiten Fenster muss für dieses Feature aktiviert sein.";
L["Only takes effect if the Cast Bar is not anchored to a SUF Portrait Bar."] =
  "Nur wirksam wenn nicht an SUF Portrait verankert.";
L["Manual positioning only works if the CastBar is not anchored to a SUF Portrait Bar."] =
  "Die manuelle Positionierung funktioniert nur wenn die CastBar nicht am SUF Portrait verankert ist.";
L["CTRL + Drag:"] = "Strg + ziehen:";
L["SHIFT + Drag:"] = "Umschalt + ziehen:";
L["Mouse Wheel:"] = "Mausrad:";
L["ALT + Left Click:"] = "Alt + Linksklick:";
L["Move Minimap"] = "Minimap verschieben";
L["Resize Minimap"] = "Minimapgröße ändern";
L["Ping Minimap"] = "Auf Minimap pingen";
L["Show Menu"] = "Zeige Menü";
L["Zoom in/out"] = "Zoomen rein/raus";
L["Toggle this Tooltip"] = "Diesen Tooltip ein-/ausblenden";
L["New Event!"] = "Neues Event!";
L["Calendar"] = "Kalender";
L["Customer Support"] = "Kundendienst";
L["Class Order Hall"] = "Klassenhallen Bericht";
L["Garrison Report"] = "Garnisons Bericht";
L["Tracking Menu"] = "Tracking Menü";
L["Music Player"] = "Musikspieler";
L["Cannot access config menu while in combat."] =
  "Das Menü kann nicht im Kampf geöffnet werden.";
L["Choose Theme:"] = "Thema wählen";
L["Custom Colour"] = "Benutzerdefinierte Farbe";
L["Theme"] = "Thema";
L["Choose Profile:"] = "Profile wählen";
L["<new profile>"] = "<Neues Profil>";
L["<remove profile>"] = "<Profil entfernen";
L["Create New Profile:"] = "Neues Profil erstellen:";
L["Remove Profile:"] = "Profil entfernen:";
L["Confirm"] = "Bestätigen";
L["Cancel"] = "Abbrechen";
L["Enabled Chat Frames:"] = "Chat aktivieren";
L["Top Left"] = "Oben Links";
L["Top Right"] = "Oben Rechts";
L["Bottom Left"] = "Unten Links";
L["Bottom Right"] = "Unten Rechts";
L["Adjust the UI Scale:"] = "UI-Skalierung anpassen";
L["Use Localization:"] = "Lokalisierung verwenden:";
L["WoW Client: "] = "Wow Client: ";
L["AddOn Settings to Override:"] = "Einstellungen der Addon´s ändern:";
L["Install"] = "Installieren";
L["INSTALL"] = "Installation";
L["CUSTOM INSTALL"] = "Benutzerdefinierte Installation";
L["INFORMATION"] = "Info´s";
L["Warning:"] = "Warnung:";
L["This will reload the UI!"] = "Dadurch wird das UI neu geladen!";
L["Setup Menu"] = "Installations Menü";
L["VERSION"] = "VERSION";
L["This will ensure that frames are correctly positioned to match the UI scale during installation."] =
  "Hiermit wird sichergestellt, das bei der Installation die Frames passend zur Skalierung positioniert werden.";
L["Only track your %s"] = "Nur eigene %s";
L["Track all %s"] = "Alle %s";
L["General Options"] = "Allgemeine Einstellungen";
L["Sort By Time Remaining"] = "Nach Restlaufzeit sortieren";
L["Show Tooltips On Mouseover"] = "Zeige Tooltips bei Mausover";
L["Create New Field"] = "Neues Feld erstellen";
L["Name of New TimerBar Field:"] = "Name des neuen TimerBar Feldes";
L["Name of TimerBar Field to Remove:"] = "Name des entfernten TimerBar Feldes";
L["TimerBar field '%s' created."] = "Das TimerBar Feld '%s' wurde erzeugt.";
L["TimerBar field '%s' remove."] = "Das TimberBar Feld '%s' wurde entfernt.";
L["TimerBar field '%s' does not exist."] =
  "Das TimerBar Feld '%s' existiert nicht.";
L["Remove Field"] = "Feld entfernen";
L["Existing Timer Bar Fields"] = "Existierende TimerBar Felder";
L["Enable Field"] = "Aktiviere Feld";
L["<%s Field>"] = "<Feld %s>";
L["Unit to Track"] = "Zu überwachende Einheit";
L["Manage Tracking Buffs"] = "Verwalte überwachte Buffs";
L["TargetTarget"] = "Ziel des Ziels";
L["FocusTarget"] = "Fokus Ziel";
L["Manage Tracking Debuffs"] = "Verwalte überwachte Debuffs";
L["Appearance Options"] = "Einstellungen zum Aussehen";
L["Up"] = "Aufwärts";
L["Down"] = "Abwärts";
L["Bar Width"] = "Breite";
L["Bar Height"] = "Höhe";
L["Bar Spacing"] = "Abstand";
L["Show Icons"] = "Zeige Icons";
L["Show Spark"] = "Zeige Funken";
L["Buff Bar Color"] = "Farbe der Buff Leiste";
L["Debuff Bar Color"] = "Farbe der Debuff Leiste";
L["Manual Positioning"] = "Manuelle Positionierung";
L["Text Options"] = "Text Einstellungen";
L["Time Remaining Text"] = "Text: Verbleibende Zeit";
L["Show"] = "Anzeigen";
L["Font Size"] = "Schriftgröße";
L["Font Type"] = "Schriftart";
L["Spell Name Text"] = "Text: Zaubername";
L["Enter the Name of a %s to Track:"] =
  "Gebe den Namen eines %s ein um ihn zu überwachen.";
L["Only %s casted by you will be tracked."] =
  "Nur die %s von dir werden überwacht";
L["Ignore the list of %s to track and track everything."] =
  "Ignoriere die Liste der %s und überwache alles.";
L["Enabling this will dynamically generate the list of %s to track."] =
  "Bei aktivierung werden dynamisch alle %s erfasst und überwacht.";
L["The unit who is affected by the spell."] =
  "Die Einheit die vom Zauber betroffen ist.";
L["The field's vertical growth direction:"] =
  "Die Richtung in der die Leiste wachsen wird.";
L["Reload UI"] = "UI neu laden";
L["General"] = "Allgemein";
L["Master Font"] = "Haupt-Schriftart";
L["Enable Master Font"] = "Haupt-Schriftart verwenden";
L["Display Lua Errors"] = "Zeige LUA Fehlermeldungen";
L["Set Theme Color"] = "Thema Farbe wählen";
L["Objective (Quest) Tracker"] = "Aufgaben / Quest Tracker";
L["Anchor to Side Bar"] = "An SideBar verankern";
L["Set Width"] = "Breite";
L["Set Height"] = "Höhe";
L["Bottom UI Panels"] = "Untere Benutzeroberfläche";
L["Container Width"] = "Container Breite";
L["Unit Panels"] = "Einheiten Fenster";
L["Enable Unit Panels"] = "Aktivieren";
L["Symmetric Unit Panels"] = "Symetrische Fenster";
L["Name Panels"] = "Fenster Format";
L["Unit Panel Width"] = "Fenster Breite";
L["Target Class Colored"] = "Klassenfarbe des Ziels";
L["Action Bar Panel"] = "Aktionsleiste";
L["Enable Panel"] = "Aktiviere Aktionsleiste";
L["Animation Speed"] = "Animationsgeschwindigkeit";
L["Retract Height"] = "Höhe - Eingeklappt";
L["Expand Height"] = "Höhe - Ausgeklappt";
L["Expand and Retract Buttons"] = "Buttons zum Ein- und Ausklappen";
L["Control"] = "Strg"; -- Mod-Key!
L["SUF Portrait Gradient"] = "SUF Portrait Farbverlauf";
L["Enable Gradient Effect"] = "Aktiviere Farbverlaufseffeckt";
L["Gradient Colors"] = "Farben des Farbverlaufs";
L["Start Color"] = "Anfangsfarbe";
L["End Color"] = "Endfarbe";
L["Target Class Colored"] = "Ziel Klassenfarbe";
L["Bartender Action Bars"] = "Bartender Aktionsleisten";
L["Row"] = "Reihe";
L["First Bartender Bar"] = "Erste Bartender Leiste";
L["Second Bartender Bar"] = "Zweite Bartender Leiste";
L["Artifact"] = "Artefakt";
L["Reputation"] = "Ruf";
L["XP"] = "Erfahrung";
L["Enabled"] = "Aktiviert";
L["Default value is"] = "Standard ist";
L["Minimum value is"] = "Minimalwert ist";
L["Minimum value is"] = "Mindestwert ist";
L["true"] = "Ja";
L["false"] = "Nein";
L["Show Text"] = "Zeige Text";
L["Data Text"] = "Untere\nDatenleiste";
L["General Data Text Options"] = "Allgemeine Data Text Einstellungen";
L["Block in Combat"] = "Im Kampf sperren";
L["Auto Hide Menu in Combat"] = "Verstecke Menü im Kampf automastisch";
L["Spacing"] = "Abstand";
L["Menu Width"] = "Breite des Menüs";
L["Max Menu Height"] = "Max. Höhe des Menüs";
L["Bar Strata"] = "Leisten Darstellungsschicht";
L["Bar Level"] = "Leisten Darstellungsebene";
L["Data Text Modules"] = "Data Text Module";
L["Data Button"] = "Daten Button";
L["Combat_timer"] = "Kampf Timer";
L["Durability"] = "Haltbarkeit";
L["Performance"] = "Performance";
L["Memory"] = "Arbeitsspeicher";
L["Money"] = "Vermögen";
L["Show Copper"] = "Zeige Kupfer";
L["Show Silver"] = "Zeige Silber";
L["Show Gold"] = "Zeige Gold";
L["Spec"] = "Spezialisierung";
L["Disabled"] = "Deaktiviert";
L["Blank"] = "Leer";
L["Module Options"] = "Modul Einstellungen";
L["Show FPS"] = "Zeige FPS";
L["Show Server Latency (ms)"] = "Zeige Server Latenz (ms)";
L["Show Home Latency (ms)"] = "Zeige eigene Latenz (ms)";
L["Show Realm Name"] = "Zeige Realm Name";
L["Show Total Slots"] = "Zeige Gesamte Taschenplätze";
L["Show Used Slots"] = "Zeige belegte Taschenplätze";
L["Show Free Slots"] = "Zeige freie Taschenplätze";
L["Show Self"] = "Zeige dich Selbst";
L["Show Tooltips"] = "Zeige Tooltips";
L["Side Bar"] = "Seitenleiste";
L["Width (With 1 Bar)"] = "Breite mit 1. Leiste";
L["Width (With 2 Bars)"] = "Breite mit 2. Leiste";
L["Hide in Combat"] = "Im Kampf verstecken";
L["Show When"] = "Zeige Wann";
L["Never"] = "Niemals";
L["Always"] = "Immer";
L["On Mouse-over"] = "Bei Mausover";
L["Bar"] = "Leiste";
L["Uncheck to prevent MUI from changing the game font."] =
  "Deaktivieren um MUI daran zu hindern die Hauptschriftart des Spiels zu ändern.";
L["Config type '%s' unsupported!"] =
  "Konfigurationstyp '%s' wird nicht unterstützt!";
L["The UI requires reloading to apply changes."] =
  "Das UI muss neu geladen werden um die Änderungen zu übernehmen.";
L["Some changes require a client restart to take effect."] =
  "Einige Änderungen machen einen Client neustart notwendig.";
L["Warning: This will NOT change the color of CastBars!"] =
  "Warnung: Das wird die Farbe der Zauberleisten verändern!";
L["Previously called 'Classic Mode'."] = "Früher 'Klassischer Modus' genannt.";
L["Allow MUI to Control Unit Frames"] =
  "Erlaube MUI die kontrolle über Shadowed Unit Frames";
L["Allow MUI to Control Grid"] = "Erlaube MUI die kontrolle über Grid";
L["What color the gradient should start as."] =
  "Mit welcher Farbe der Farbverlauf beginnen soll";
L["What color the gradient should change into."] =
  "Mit welcher Farbe der Farbverlauf enden soll";
L["Allow MUI to Control Selected Bartender Bars"] =
  "Erlaube MUI die kontrolle über Bartender";
L["Show your character in the guild list."] =
  "Zeige deinen Charakter in der Gildenliste.";
L["Adjust the width of the Bottom UI container."] =
  "Breite der unteren Benutzeroberfläche anpassen.";
L["Adjust the width of the unit frame background panels."] =
  "Breite der Einheiten Hintergrund Fenster anpassen.";
L["Adjust the width of the unit name background panels."] =
  "Breite der Einheitenname Hintergrund Fenster anpassen.";
L["Adjust the height of the unit name background panels."] =
  "Höhe der Einheitenname Hintergrund Fenster anpassen.";
L["Adjust the width of the Objective Tracker."] =
  "Breite des Aufgaben / Quest Trackers anpassen.";
L["Adjust the height of the Objective Tracker."] =
  "Höhe des Aufgaben / Quest Trackers anpassen.";
L["Move the unit name panels further in or out."] =
  "Verschiebt die Einheitenfenster mehr rein oder raus.";
L["Set the font size of unit names."] =
  "Schriftgröße der Einheitennamen festlegen.";
L["The speed of the Expand and Retract transitions."] =
  "Die Geschwindigkeit der Animation für die Aktionsleistenerweiterung.";
L["The higher the value, the quicker the speed."] =
  "Je größer der Wert, desto schneller die Animation.";
L["The height of the gradient effect."] = "Die Höhe der Farbverlaufeffeckts.";
L["Adjust the spacing between data text buttons."] =
  "Den Abstand zwischen den DataText Elementen anpassen.";
L["The frame strata of the entire DataText bar."] =
  "Die Darstellungsschicht der DataText Leiste.";
L["Anchor the Objective Tracker to the action bar container on the right side of the screen."] =
  "Verankert den Quest Tracker an der SideBar auf der rechten Seite.";
L["Disable this to stop MUI from controlling the Objective Tracker."] =
  "Wenn deaktiviert, wird MUI den Quest Tracker nicht konfigurieren.";
L["Adjust the horizontal positioning of the Objective Tracker."] =
  "Verschiebt den Aufgaben / Quest Tracke horizontal.";
L["Adjust the vertical positioning of the Objective Tracker."] =
  "Verschiebt den Aufgaben / Quest Tracke vertikal.";
L["The font size of text that appears on data text buttons."] =
  "Die Schriftgröße des Textes auf den DataText Elementen.";
L["Show guild info tooltips when the cursor is over guild members in the guild list."] =
  "Zeigt Gildeninformationen, wenn mit der Maus über ein Listeneintrag gefahren wird.";
L["The frame level of the entire DataText bar based on its frame strata value."] =
  "Die Darstellungsebene der DataText Leiste, basierend auf ihrer Darstellungsschicht.";
L["If unchecked, the entire DataText module will be disabled and all"] =
  "Wenn deaktiviert, werden die gesamten DataText Elemente ausgeblendet.";
L["DataText buttons, as well as the background bar, will not be displayed."] =
  "Die Daten Text box, sowie der Hindergrund wird ebenfalls ausgeblendet.";
L["Prevents you from using data text modules while in combat."] =
  "Verhindert die benutzung der DataText Elemente während dem Kampf.";
L["This is useful for 'clickers'."] =
  "Das ist besonders für die Benutzer mit einer Vorliebe für Maussteuerung hilfreich.";
L["If the SUF Player or Target portrait bars are enabled, a class colored gradient will overlay it."] =
  "Wenn die SUF Spieler oder Ziel Portais aktiv sind, wird ein Farbverlauf mit den Klassenfarben darüber gelegt.";
L["Show Overview"] = "Übersicht anzeigen";
L["Show Reset Options"] = "Reset-Optionen anzeigen";
L["Reset All Characters"] = "Alle Chars zurücksetzen";
L["Are you sure you want to reset the money data for all of your characters?"] =
  "Sind Sie sicher, dass Sie die Gelddaten für alle Ihre Charaktere zurücksetzen möchten?";
L["All money data has been reset."] = "Alle Gelddaten wurden zurückgesetzt.";
L["Are you sure you want to reset the money data for %s?"] =
  "Sind Sie sicher, dass Sie die Gelddaten für %s zurücksetzen möchten?";
L["Money data for %s has been reset."] =
  "Gelddaten für %s wurden zurückgesetzt.";
L["Reset Options"] = "Optionen zurücksetzen";
L["All currency data has been reset."] =
  "Alle Währungen wurden zurückgesetzt.";
L["Currency data for %s has been reset."] =
  "Währung für %s wurden zurückgesetzt.";
L["Are you sure you want to reset the currency data for all of your characters?"] =
  "Sind Sie sicher, dass Sie die Währungen für alle Ihre Chars zurücksetzen möchten?";
L["Are you sure you want to reset the currency data for %s?"] =
  "Möchten Sie die Währung für %s wirklich zurücksetzen?";
L["Change Status"] = "Status ändern";
L["Remove from Whitelist"] = "Aus der Whitelist entfernen";
L["Add to Blacklist"] = "Zur Blacklist hinzufügen";
L["Removing %s from the whitelist will hide this timer bar if the whitelist is enabled."] =
  "Durch Entfernen von %s aus der Whitelist wird diese Zeitleiste ausgeblendet, wenn die Whitelist aktiviert ist.";
L["Adding %s to the blacklist will hide this timer bar if the blacklist is enabled."] =
  "Durch Hinzufügen von %s zur Blacklist wird diese Zeitleiste ausgeblendet, wenn die Blacklist aktiviert ist.";
L["Are you sure you want to do this?"] =
  "Sind Sie sicher, dass Sie dies tun möchten?";
L["%s has been removed from the whitelist."] =
  "%s wurde aus der Whitelist entfernt.";
L["%s has been added to the blacklist."] =
  "%s wurde der Blacklist hinzugefügt.";
L["Filters"] = "Filters";
L["Only show buffs applied by me"] = "Nur von mir angewendete Buffs anzeigen";
L["Only show debuffs applied by me"] =
  "Nur von mir angewendete Debuffs anzeigen";
L["Enable Whitelist"] = "Whitelist aktivieren";
L["Configure Whitelist"] = "Whitelist bearbeiten";
L["Enable Blacklist"] = "Blacklist aktivieren";
L["Configure Blacklist"] = "Blacklist bearbeiten";
L["Cast Bars"] = "Gegossene Bars";
L["Auras (Buffs & Debuffs)"] = "Auren (Buffs & Debuffs)";
L["(CTRL+C to Copy, CTRL+V to Paste)"] =
  "(Strg+C zum Kopieren, Strg+V zum Einfügen)";
L["Copy Chat Text"] = "Kopiere Chat Text";
L["Data Text Bar"] = "Daten Leiste";
L["Setup"] = "Setup";
L["Timer Bars"] = "Timer Bars";
L["MUI Profile Manager"] = "MUI Profil Manager";
L["Current profile"] = "Aktuelles Profil";
L["Reset Profile"] = "Profil zurücksetzen";
L["Delete Profile"] = "Profil Löschen";
L["Copy From"] = "Kopieren von";
L["Select profile"] = "Profil wählen";
L["Choose Profile"] = "Profil wählen";
L["Choose the currently active profile."] =
  "Wählen Sie das aktuell aktive Profil.";
L["New Profile"] = "Neues Profil";
L["Create a new profile"] = "Erstelle ein neues Profil";
L["Default Profile Behaviour"] = "Standard Profil";
L["Name of New Layout"] = "Name des neuen Layout´s";
L["Layout"] = "Layout";
L["Rename Layout"] = "Layout umbenenen";
L["Are you sure you want to delete Layout '%s'?"] =
  "Möchtest du das Layout wirklich löschen? '%s'?";
L["MUI Layout Tool"] = "MUI Layout Tool";
L["Layouts"] = "Layout´s";
L["Create New Layout"] = "Neues Layout";
L["Delete Layout"] = "Layout Löschen";
L["Chat Buttons with Modifier Key %d"] =
  "Chat-Schaltflächen mit Modifikatortaste %d";
L["Please install the UI and try again."] =
  "Bitte installieren Sie die Benutzeroberfläche und versuchen Sie es erneut.";
L["Chat Frames"] = "Chat Frames";
L["Mini-Map Options"] = "Karten Option";
L["Mini-Map"] = "Karten";
L["Adjust the size of the minimap."] =
  "Passen Sie die Größe der Minikarte an.";
L["Adjust the scale of the minimap."] =
  "Passen Sie den Maßstab der Minikarte an.";
L["Zone Text"] = "Zonen Text";
L["Scale"] = "Skallierung";
L["Size"] = "Größe";
L["Adjust the font size of the zone text."] =
  "Passen Sie die Schriftgröße des Zonentextes an.";
L["Okay"] = "Okay";
L["Profile %s has been copied into current profile %s."] =
  "Das profil %s wurde in das aktuelle Profil %s kopiert.";
L["Reset currently active profile back to default settings."] =
  "Setzen Sie das aktuell aktive Profil auf die Standardeinstellungen zurück.";
L["Are you sure you want to reset profile '%s' back to default settings?"] =
  "Möchten Sie das Profil '%s' wirklich auf die Standardeinstellungen zurücksetzen?";
L["Delete currently active profile (cannot delete the 'Default' profile)."] =
  "Derzeit aktives Profil löschen (Standardprofil kann nicht gelöscht werden).";
L["Copy all settings from one profile to the active profile."] =
  "Kopieren Sie alle Einstellungen von einem Profil in das aktive Profil.";
L["Are you sure you want to override all profile settings in '%s' for those in profile '%s'?"] =
  "Möchten Sie wirklich alle Profileinstellungen in '%s' für diejenigen im Profil '%s' überschreiben?";
L["Profile Per Character"] = "Profil pro Character";
L["If enabled, new characters will be assigned a unique character profile instead of the Default profile."] =
  "Wenn diese Option aktiviert ist, wird einen neuen Char anstelle des Standardprofils ein eindeutiges Characterprofil zugewiesen.";
L["Customize which addOn/s should change to which profile/s for each layout, as well as manage your existing layouts or create new ones."] =
  "Passen Sie an, welche AddOn/s zu welchem Profil und welches Profil für jedes Layout geändert werden soll, und verwalten Sie Ihre vorhandenen Layouts oder erstellen Sie neue.";
L["Anchor the Objective Tracker to the action bar container on the right side of the screen."] =
  "Verankern Sie den Objective Tracker im Aktionsleistencontainer auf der rechten Seite des Bildschirms.";
L["You can repeat this step at any time (while out of combat) to hide it."] =
  "Sie können diesen Schritt jederzeit (außerhalb des Kampfes) wiederholen, um ihn auszublenden.";
L["If true, the objective tracker will collapse when entering an instance."] =
  "Wenn dies der Fall ist, wird der Ziel-Tracker beim Eingeben einer Instanz reduziert.";
L["If true, MUI will not show copper, or silver, if the amount of gold is over a certain limit."] =
  "Wenn dies zutrifft, zeigt MUI weder Kupfer noch Silber an, wenn die Goldmenge einen bestimmten Grenzwert überschreitet.";
L["Also enable the %s"] = "Aktivieren Sie auch die %s";
L["Current"] = "Aktuell";
L["Equipment Set"] = "Rüstung´s Set";
L["Installer"] = "Installer";
L["Profiles"] = "Profile";
L["AFK Display"] = "AFK Anzeige";
L["Movable Frames"] = "Bewegliche Rahmen";
L["Objective Tracker"] = "Objective Tracker";
L["Side Action Bar"] = "Seitliche Aktionsleiste";
L["(type '/mui' to list all slash commands)"] =
  "(Geben Sie '/mui' ein, um alle Befehle aufzulisten.)";
L["Version"] = "Version";
L["Main Container"] = "Haupt Fenster";
L["Resource Bars"] = "Resource Bars";
L["Movable Blizzard Frames"] = "Bewegliche Blizzard Rahmen";
L["Allows you to move Blizzard Frames outside of combat only."] =
  "Ermöglicht es Ihnen, Blizzard-Fenster nur außerhalb des Kampfes zu bewegen.";
L["Reset Blizzard frames back to their original position."] =
  "Setzen Sie die Blizzard-Fenster wieder in ihre ursprüngliche Position zurück.";
L["Reset Blizzard Frame Positions"] =
  "Setzen Sie die Blizzard-Fenster Positionen zurück";
L["Enable/disable the AFK Display"] =
  "Aktivieren / Deaktivieren der AFK Anzeige";
L["Show AFK Display"] = "Zeige AFK Bildschirm";
L["Adjust the width of the main container."] =
  "Passen Sie die Breite des Hauptfensters an.";
L["Adjust the height of the unit frame background panels."] =
  "Passen Sie die Höhe der Hintergrundfelder des Geräterahmens an.";
L["Unit Panel Height"] = "Einheit Panel Höhe";
L["Main Container Width:"] = "Hauptfensterbreite:";
L["Enable or disable the background panel"] =
  "Aktivieren oder deaktivieren Sie das Hintergrundfenster";
L["Modifier key/s used to show Expand/Retract button:"] =
  "Modifizierertaste zum Anzeigen der Schaltfläche Erweitern / Zurückziehen:";
L["Side Action Bars"] = "Seitliche Aktionsleisten";
L["Collapse in Instance"] = "Collapse in Instance";
L["CREDITS"] = "Anerkennung";
L["Buffs"] = "Buffs";
L["Debuffs"] = "Debuffs";
L["Layout Type"] = "Layouttyp";
L["Save Position"] = "Sichere Lage";
L["Show Pulse Effect"] = "Pulseffekt anzeigen";
L["Icon Options"] = "Icon Options";
L["Icon options are disabled when using status bars."] =
  "Icon Option sind deaktiviert, wenn Statusleisten verwendet werden.";
L["Icon Size"] = "Icon Größe";
L["Column Spacing"] = "Column Spacing";
L["Row Spacing"] = "Row Spacing";
L["Icons per Row"] = "Icons pro Zeile";
L["Growth Direction"] = "Wachstumsrichtung";
L["Status Bar Options"] = "Statusleistenoptionen";
L["Status bar options are disabled when using icons."] =
  "Die Optionen der Statusleiste sind bei Verwendung von Symbolen deaktiviert.";
L["Icon Gap"] = "Symbollücken.";
L["Text"] = "Text";
L["Time Remaining"] = "Verbleibende Zeit";
L["Count"] = "Anzahl";
L["Aura Name"] = "Aura Name";
L["Border Type"] = "Randtyp";
L["Basic %s"] = "Basic %s";
L["Weapon Enchants"] = "Waffenverzauberungen";
L["Magic Debuff"] = "Magischer - Debuff";
L["Disease Debuff"] = "Krankheit´s - Debuff";
L["Poison Debuff"] = "Gift - Debuff";
L["Curse Debuff"] = "Fluch - Debuff";
L["Bar Background"] = "Bar Hintergrund";
L["Bar Border"] = "Balkenrand";
L["Icons"] = "Icons";
L["Status Bars"] = "Statusleisten";
L["Bottom Action Bars"] = "Untere Aktionsleisten";
L["Can Steal or Purge"] = "Kann stehlen oder reinigen";
L["If an aura can be stolen or purged, show a different color."] =
  "Wenn eine Aura gestohlen oder gelöscht werden kann, zeigen Sie eine andere Farbe.";
L["Show Borders"] = "Grenzen anzeigen";
L["Enter an aura name to add to the whitelist:"] =
  "Geben Sie einen Aura-Namen ein, der der Whitelist hinzugefügt werden soll:";
L["Enter an aura name to add to the blacklist:"] =
  "Geben Sie einen Aura-Namen ein, der der Blacklist hinzugefügt werden soll:";
L["Automatic"] = "Automatisch";
L["Inventory"] = "Inventar";
L["Changes to these settings will take effect after 0-3 seconds."] =
  "Änderungen an diesen Einstellungen werden nach 0-3 Sekunden wirksam.";
L["Adjust the height of the datatext bar."] =
  "Passen Sie die Höhe der Datentextleiste an.";
L["Justify Text"] = "Text ausrichten";
L["Set the spacing between the status bar and the background."] =
  "Stellen Sie den Abstand zwischen der Statusleiste und dem Hintergrund ein.";
L["Select which chat frame the chat icons should be anchored to."] =
  "Wählen Sie aus, in welchem Chat-Frame die Chat-Symbole verankert werden sollen.";
L["The height of the edit box."] = "Die Höhe des Bearbeitungsfelds.";
L["Set the vertical positioning of the edit box."] =
  "Stellen Sie die vertikale Position des Bearbeitungsfelds ein.";
L["Show Player Status Icon"] = "Spielerstatus-Symbol anzeigen";
L["Show Emotes Icon"] = "Emotes-Symbol anzeigen";
L["Show Copy Chat Icon"] = "Kopieren Chat-Symbol anzeigen";
L["This is the background bar that goes behind the tabs."] =
  "Dies ist die Hintergrundleiste hinter den Registerkarten.";
L["Show Tab Bar"] = "Tab-Leiste anzeigen";
L["Tab Bar"] = "Tab-Leiste";
L["Window"] = "Fenster";
L["Layout enabled!"] = "Layout aktiviert!";
L["Show Chat Menu"] = "Chat-Menü anzeigen";
L["Azerite"] = "Azerite";
L["Covenant Sanctum"] = "Packtsanktum";
L["Missions"] = "BfA Missionen";
L["You must be a member of a covenant to view this."] =
  "Du musst einen Packt angehören."
L["Unmuted"] = "Nicht stummgeschaltet";
L["Toggle Questlog"] = "Questlog umschalten";
L["Step %d of"] = "Schritt %d von";
L["Step"] = "Schritt";
L["Found a bug? Use this form to submit an issue to the official MayronUI GitHub page."] =
  "Einen Fehler gefunden? Verwenden Sie dieses Formular, um ein Problem an die offizielle MayronUI GitHub-Seite zu senden.";
L["Almost done! We just need a bit more information..."] =
  "Fast fertig! Wir brauchen nur ein paar mehr Informationen...";
L["Click below to generate your report. Once generated, copy it into a new issue and submit it on GitHub using the link below:"] =
  "Klicken Sie unten, um Ihren Bericht zu erstellen. Nach dem Erstellen kopieren Sie den Bericht und senden Sie ihn uns über den folgenden Link auf GitHub:";
L["characters"] = "Zeichen";
L["minimum"] = "Minimum";
L["Please describe the bug in detail:"] =
  "Bitte beschreiben Sie den Fehler im Detail:";
L["How can we replicate the bug?"] = "Wie können wir den Fehler replizieren?";
L["Report Issue"] = "Fehler melden";
L["Report MayronUI Bug"] = "MayronUI Fehler melden";
L["Open this webpage in your browser"] =
  "Öffnen Sie diese Webseite in Ihrem Browser";
L["Generate Report"] = "Bericht generieren";
L["Copy Report"] = "Bericht kopieren";
L["Chat Frame with Icons"] = "Chat-Rahmen mit Symbolen";
L["Vertical Side Icons"] = "Vertikale Seitensymbole";
L["Only 1 active chat frame can show the chat icons on the sidebar (see icons listed below)."] =
  "Nur 1 aktiver Chatrahmen kann die Chatsymbole in der Seitenleiste anzeigen (siehe unten aufgeführte Symbole).";
L["Horizontal Top Buttons"] = "Horizontale obere Tasten";
L["This option will affect all active chat frames. To configure each individual button per chat frame, see the chat frame sub-menus below."] =
  "Diese Option wirkt sich auf alle aktiven Chat-Frames aus. Um jede einzelne Schaltfläche pro Chat-Frame zu konfigurieren, sehen Sie sich die Chat-Frame-Untermenüs unten an.";
L["Chat Channels"] = "Chat-Kanäle";
L["Professions"] = "Berufe";
L["AddOn Shortcuts"] = "AddOn-Kurzbefehle";
L["Copy Chat"] = "Chat kopieren";
L["Emotes"] = "Emotes";
L["Online Status"] = "Online Status";
L["None"] = "Keiner";
L["Deafen"] = "taub";
L["Mute"] = "Stumm";
L["If checked, this module will be enabled."] =
  "Wenn diese Option aktiviert ist, wird dieses Modul aktiviert.";
L["Unit Tooltip Options"] = "Tooltip-Optionen für Einheiten";
L["These options only affect tooltips that appear when you mouse over a unit, such as an NPC or player."] =
  "Diese Optionen wirken sich nur auf Tooltips aus, die angezeigt werden, wenn Sie mit der Maus über eine Einheit fahren, z. B. einen NPC oder einen Spieler.";
L["If checked, the target of the unit (NPC or player) displayed in the tooltip will be shown."] =
  "Wenn aktiviert, wird das im Tooltip angezeigte Ziel der Einheit (NPC oder Spieler) angezeigt.";
L["If checked and the player is in a guild, the guild rank of the player displayed in the tooltip will be shown."] =
  "Wenn aktiviert und der Spieler in einer Gilde ist, wird der Gildenrang des Spielers im Tooltip angezeigt.";
L["If checked and the player is level 10 or higher, the item level of the player displayed in the tooltip will be shown."] =
  "Wenn diese Option aktiviert ist und der Spieler Level 10 oder höher ist, wird die Gegenstandsstufe des Spielers angezeigt, die im Tooltip angezeigt wird.";
L["The player must be close enough to be inspected for this information to load."] =
  "Der Player muss nah genug sein, um inspiziert zu werden, damit diese Informationen geladen werden können.";
L["If checked and the player is level 10 or higher and has chosen a class specialization, the specialization of the player displayed in the tooltip will be shown."] =
  "Wenn aktiviert und der Spieler Level 10 oder höher ist und eine Klassenspezialisierung gewählt hat, wird die Spezialisierung des Spielers angezeigt, die im Tooltip angezeigt wird.";
L["Show Specialization"] = "Spezialisierung anzeigen";
L["Show Item Level"] = "Item Level anzeigen";
L["In Combat Options"] = "In Kampfoptionen";
L["Show Unit Tooltips In Combat"] = "Einheiten-Tooltips im Kampf anzeigen";
L["Show Guild Rank"] = "Gildenrang anzeigen";
L["Show Target"] = "Ziel anzeigen";
L["Show Standard Tooltips In Combat"] = "Standard-Tooltips im Kampf anzeigen";
L["Standard tooltips display non-unit related information, such as action-bar abilities, buffs and debuffs, and more."] =
  "Standard-Tooltips zeigen nicht einheitenbezogene Informationen an, z. B. Fähigkeiten der Aktionsleiste, Buffs und Debuffs und mehr.";
L["Unit tooltips display player and NPC information while your mouse cursor is over a unit in the game world."] =
  "Einheiten-Tooltips zeigen Spieler- und NPC-Informationen an, während sich der Mauszeiger über einer Einheit in der Spielwelt befindet.";
L["Appearance Options"] = "Darstellungsoptionen";
L["These options allow you to customize the appearance of the tooltips."] =
  "Mit diesen Optionen können Sie das Erscheinungsbild der QuickInfos anpassen.";
L["Font Flag"] = "Schriftart-Flag";
L["Standard Font Size"] = "Standardschriftgröße";
L["Header Font Size"] = "Schriftgröße der Kopfzeile";
L["Affects the overall size of the tooltips."] =
  "Beeinflusst die Gesamtgröße der QuickInfos.";
L["Reskin using the MUI texture or a custom backdrop"] =
  "Reskin mit der MUI-Textur oder einem benutzerdefinierten Hintergrund";
L["Texture"] = "Textur";
L["Texture Options"] = "Texturoptionen";
L["Custom Backdrop"] = "Benutzerdefinierter Hintergrund";
L["The MUI texture controls both the background and border textures. If you want a more customized style, use the 'Custom Backdrop' style instead (see the previous menu)."] =
  "Die MUI-Textur steuert sowohl die Hintergrund- als auch die Randtexturen. Wenn Sie einen individuelleren Stil wünschen, verwenden Sie stattdessen den Stil „Benutzerdefinierter Hintergrund“ (siehe vorheriges Menü).";
L["Use MUI Theme Color"] = "Verwenden Sie die MUI-Designfarbe";
L["If checked, the MUI texture will use your MUI theme color for both the background and border color (by default, this is class-colored)."] =
  "Wenn diese Option aktiviert ist, verwendet die MUI-Textur Ihre MUI-Designfarbe sowohl für den Hintergrund als auch für die Rahmenfarbe (standardmäßig ist dies klassenfarben).";
L["Custom Color"] = "Freiwählbare Farbe";
L["If not using the MUI theme color, the tooltip will use this custom color for both the background and border color."] =
  "Wenn die MUI-Designfarbe nicht verwendet wird, verwendet die QuickInfo diese benutzerdefinierte Farbe sowohl für die Hintergrund- als auch für die Rahmenfarbe.";
L["Custom Backdrop Options"] = "Benutzerdefinierte Hintergrundoptionen";
L["Color border by class or NPC type"] = "Farbrahmen nach Klasse oder NPC-Typ";
L["If checked, the backdrop border color will be based on the class of the player unit or the type of NPC unit."] =
  "Wenn diese Option aktiviert ist, basiert die Farbe des Hintergrundrahmens auf der Klasse der Spielereinheit oder dem Typ der NPC-Einheit.";
L["Border Color"] = "Randfarbe";
L["If color border by class or NPC type is checked, this color will be used for all non-unit tooltips, else it will be used for every tooltip border."] =
  "Wenn Farbrahmen nach Klasse oder NPC-Typ aktiviert ist, wird diese Farbe für alle Tooltips verwendet, die keine Einheiten sind, andernfalls wird sie für jeden Tooltip-Rahmen verwendet.";
L["Background Texture"] = "Hintergrundtextur";
L["Border Insets"] = "Randeinsätze";
L["Left"] = "Links";
L["Right"] = "Recht";
L["Center"] = "Center";
L["Top"] = "oben";
L["Bottom"] = "Unterseite";
L["Anchor Options"] = "Fixier Optionen";
L["Unit Tooltip Anchor Point"] = "Einheiten-Tooltip-Fixierpunkt";
L["Mouse Cursor"] = "Mauszeiger";
L["Screen Corner"] = "Bildschirmecke";
L["Screen Corner Positioning"] = "Positionierung der Bildschirmecke";
L["Standard Tooltip Anchor Point"] = "Standard-Tooltip-Fixierpunkt";
L["Mouse Cursor Positioning"] = "Positionierung des Mauszeigers";
L["The bottom-[point] corner of the tooltip, where [point] is either 'Left' or 'Right', will be anchored to the position of the mouse cursor."] =
  "Die untere [Punkt]-Ecke des Tooltips, wobei [Punkt] entweder 'Links' oder 'Rechts' ist, wird an der Position des Mauszeigers fixiert.";
L["Health Bar"] = "Gesundheitsleiste";
L["Outline"] = "Gliederung";
L["Thick Outline"] = "Dicker Umriss";
L["Monochrome"] = "Einfarbig";
L["Text Format"] = "Textformat";
L["Set the text format of the value that appears on the status bar. Set this to 'None' to hide the text."] =
  "Legen Sie das Textformat des Werts fest, der in der Statusleiste angezeigt wird. Setzen Sie dies auf 'Keine', um den Text auszublenden.";
L["Current/Maximum"] = "Aktuell/Maximum";
L["Percentage"] = "Prozentsatz";
L["Power Bar"] = "Energieleiste";
L["If checked, unit tooltips will show the unit's power bar."] =
  "Wenn diese Option aktiviert ist, zeigen die Tooltips der Einheit die Energieleiste der Einheit an.";
L["Unit Aura Options"] = "Aura-Optionen für Einheiten";
L["If checked, unit tooltips will show the unit's buffs."] =
  "Wenn diese Option aktiviert ist, zeigen Einheiten-Tooltips die Buffs der Einheit.";
L["Above"] = "Über";
L["Below"] = "Unten";
L["Position"] = "Position";
L["Set whether you want the unit's buffs to appear above or below the tooltip."] =
  "Legen Sie fest, ob die Buffs der Einheit über oder unter dem Tooltip angezeigt werden sollen.";
L["Left to Right"] = "Links nach rechts";
L["Right to Left"] = "Rechts nach links";
L["If checked, unit tooltips will show the unit's debuffs."] =
  "Wenn diese Option aktiviert ist, zeigen Einheiten-Tooltips die Schwächungen der Einheit an.";
L["Set border color by debuff type"] = "Rahmenfarbe nach Debuff-Typ festlegen";
L["If enabled, the border color of debuffs will be based on the type of debuff (e.g., poisons will appear with a green border color)."] =
  "Wenn aktiviert, richtet sich die Randfarbe von Debuffs nach der Art des Debuffs (z. B. werden Gifte mit einer grünen Randfarbe angezeigt).";
L["Set whether you want the unit's debuffs to appear above or below the tooltip."] =
  "Legen Sie fest, ob die Schwächungen der Einheit über oder unter dem Tooltip angezeigt werden sollen.";
L["Buff and Debuff Ordering"] = "Buff- und Debuff-Bestellung";
L["Debuffs Above Buffs"] = "Debuffs über Buffs";
L["Buffs Above Debuffs"] = "Buffs über Debuffs";
L["Non-Player Alpha"] = "Nicht-Spieler-Alpha";
L["Sets the alpha of timer bars for auras not produced by you (i.e., other player or NPC buffs and debuffs)."] =
  "Legt das Alpha von Timer-Balken für Auren fest, die nicht von Ihnen erzeugt wurden (d. h. Buffs und Debuffs anderer Spieler oder NPCs).";
L["Show Professions"] = "Berufe anzeigen";
L["Show AddOn Shortcuts"] = "AddOn-Kurzbefehle anzeigen";
L["Profile Manager"] = "Profilmanager";
L["Config Menu"] = "Konfigurationsmenü";
L["Show Profiles"] = "Profile anzeigen";
L["Report"] = "Bericht";
L["Toggle Alignment Grid"] = "Ausrichtungsraster umschalten";
L["Guild Bank"] = "Gildenbank";
L["Bank"] = "Bank";
L["Void Storage"] = "Leerenlager";
L["You have no professions."] = "Sie haben keine Berufe.";
L["remaining"] = "verbleibend"; -- for XP bar (e.g., "50/100 (50% remaining)")
L["Fixed Color"] = "Feste Farbe";
L["Main Container"] = "Haupt Fenstert";
L["Talking Head Frame"] = "Sprechender Kopfrahmen";
L["This is the animated character portrait frame that shows when an NPC is talking to you."] =
  "Dies ist der animierte Charakterporträtrahmen, der zeigt, wenn ein NPC mit Ihnen spricht.";
L["Top of Screen"] = "Oben auf dem Bildschirm";
L["Bottom of Screen"] = "Unterseite des Bildschirms";
L["Pulse While Resting"] = "Puls während der Ruhe";
L["If enabled, the unit panels will fade in and out while resting."] =
  "Wenn diese Option aktiviert ist, werden die Bedienfelder der Einheit im Ruhezustand ein- und ausgeblendet.";
L["Target Class Color Gradient"] = "Farbverlauf der Zielklasse";
L["If enabled, the unit panel color will transition to the target's class color using a horizontal gradient effect."] =
  "Wenn diese Option aktiviert ist, geht die Farbe des Einheitenbedienfelds mit einem horizontalen Verlaufseffekt in die Klassenfarbe des Ziels über.";
L["Set Pulse Strength"] = "Pulsstärke einstellen";
L["Expanding and Retracting Action Bar Rows"] =
  "Erweitern und Zurückziehen von Aktionsleistenzeilen";
L["Enable Expand and Retract Feature"] =
  "Aktivieren Sie die Funktion zum Erweitern und Zurückziehen";
L["If disabled, you will not be able to toggle between 1 and 2 rows of action bars."] =
  "Wenn deaktiviert, können Sie nicht zwischen 1 und 2 Reihen von Aktionsleisten umschalten.";
L["This is the fixed default height to use when the expand and retract feature is disabled."] =
  "Dies ist die feste Standardhöhe, die verwendet wird, wenn die Funktion zum Erweitern und Zurückziehen deaktiviert ist.";
L["Set Alpha"] = "Alpha einstellen";
L["If checked, the reputation bar will use a fixed color instead of dynamically changing based on your reputation with the selected faction."] =
  "Wenn diese Option aktiviert ist, verwendet die Ansehensleiste eine feste Farbe, anstatt sich dynamisch basierend auf Ihrem Ansehen bei der ausgewählten Fraktion zu ändern.";
L["Use Fixed Color"] = "Feste Farbe verwenden";
L["Reputation Colors"] = "Ruffarben";
L["Show"] = "Show";
L["Hide"] = "Ausblenden";
L["Enable Test Mode"] = "Testmodus aktivieren";
L["Disable Test Mode"] = "Testmodus deaktivieren";
L["Icon Position"] = "Symbolposition";
L["If checked, this module will be enabled."] =
  "Wenn aktiviert, wird dieses Modul aktiviert.";
L["Test mode allows you to easily customize the looks and positioning of widgets by forcing all widgets to be shown."] =
  "Der Testmodus ermöglicht es Ihnen, das Aussehen und die Positionierung von Widgets einfach anzupassen, indem Sie erzwingen, dass alle Widgets angezeigt werden.";
L["Mini-Map Widgets"] = "Minikarten-Widgets";
L["Clock"] = "Uhr";
L["Dungeon Difficulty"] = "Dungeon-Schwierigkeit";
L["Looking For Group Icon"] = "Suche nach Gruppensymbol";
L["New Mail Icon"] = "Neue Mail-Symbol";
L["Missions Icon"] = "Missionen-Symbol";
L["This button opens the most relevant missions menu for your character. The menu will either show missions for your Covenant Sanctum, Class Order Hall, or your Garrison."] =
  "Diese Schaltfläche öffnet das relevanteste Missionsmenü für deinen Charakter. Das Menü zeigt entweder Missionen für dein Bündnissanktum, die Klassenordenshalle oder deine Garnison an.";
L["Tracking Icon"] = "Tracking-Symbol";
L["When hidden, you can still access tracking options from the Minimap right-click menu."] =
  "Wenn es ausgeblendet ist, können Sie weiterhin auf die Tracking-Optionen über das Kontextmenü der Minikarte zugreifen.";
L["Zone Name"] = "Zonenname";
L["Apply Scaling"] = "Skalierung anwenden";
L["Show MUI Key Bindings"] = "MUI-Tastenbelegung anzeigen";
L["Tutorial: Step 2"] = "Anleitung: Schritt 2";
L["Tutorial: Step 1"] = "Anleitung: Schritt 1";
L["Open Config Menu"] = "Konfigurationsmenü öffnen";
L["Config"] = "Konfig";
L["Unit Frame Panels"] = "Einheitsrahmenplatten";
L["Tooltips"] = "Tooltips";
L["Show Food and Drink"] = "Speisen und Trinken anzeigen";
L["If checked, the food and drink buff will be displayed as a castbar."] =
  "Wenn aktiviert, wird der Essens- und Getränkebuff als Castbar angezeigt.";
L["Blend Mode"] = "Mischmodus";
L["Changing the blend mode will affect how alpha channels blend with the background."] =
  "Das Ändern des Mischmodus wirkt sich darauf aus, wie Alphakanäle mit dem Hintergrund verschmelzen.";
L["Background"] = "Hintergrund";
L["Button"] = "Taste";
L["Combat Timer"] = "Kampftimer";
L["Volume Options"] = "Lautstärkeoptionen";
L["Specialization"] = "Spezialisierung";
L["Show Auras With Unknown Time Remaining"] =
  "Zeige Auren mit unbekannter verbleibender Zeit";
L["Show Buffs"] = "Buffs anzeigen";
L["Show Debuffs"] = "Debuffs anzeigen";
L["Refresh Chat Text"] = "Chat-Text aktualisieren";
L["Back"] = "Zurück";
L["Next"] = "Nächster";
L["Set short, custom aliases for chat channel names."] =
  [[Legen Sie kurze, benutzerdefinierte Aliase für Chatkanalnamen fest.]]
L["The main container holds the unit frame panels, action bar panels, data-text bar, and all resource bars at the bottom of the screen."] =
  "Der Hauptcontainer enthält die Einheitenrahmenfelder, Aktionsleistenfelder, die Datentextleiste und alle Ressourcenleisten am unteren Bildschirmrand.";
L["Add Text Highlighting"] = "Texthervorhebung hinzufügen";
L["Channel Name Aliases"] = "Kanalnamen-Aliasse";
L["Text Highlighting"] = "Texthervorhebung";
L["Alias Brightness"] = "Alias Helligkeit";
L["Auction House Open"] = "Auktionshaus geöffnet";
L["Auction House Close"] = "Auktionshaus schließen";
L["Alarm Clock Warning 1"] = "Weckerwarnung 1";
L["Alarm Clock Warning 2"] = "Weckerwarnung 2";
L["Alarm Clock Warning 3"] = "Weckerwarnung 3";
L["Enter Queue"] = "Warteschlange betreten";
L["Jewel Crafting Socket"] = "Juwelenherstellungssockel";
L["Loot Money"] = "Beutegeld";
L["Map Ping"] = "Kartierung";
L["Queue Ready"] = "Warteschlange bereit";
L["Raid Warning"] = "Raid-Warnung";
L["Raid Boss Warning"] = "Raid-Boss-Warnung";
L["Ready Check"] = "Bereit-Check";
L["Repair Item"] = "Reparaturartikel";
L["Whisper Received"] = "Flüstern empfangen";
L["Server Channels"] = "Serverkanäle";
L["Text to Highlight (case insensitive):"] =
  "Text zum Hervorheben (Groß-/Kleinschreibung nicht beachten):";
L["Enter text to highlight:"] = "Text zum Hervorheben eingeben:";
L["Show in Upper Case"] = "In Großbuchstaben anzeigen";
L["Set Color"] = "Farbe einstellen";
L["Edit Text"] = "Text bearbeiten";
L["Play a sound effect when any of the selected text appears in chat."] =
  "Spielen Sie einen Soundeffekt ab, wenn einer der ausgewählten Texte im Chat erscheint.";
L["Play Sound"] = "Ton abspielen";
L["Set Timestamp Color"] = "Zeitstempelfarbe einstellen";
L["Use Fixed Timestamp Color"] = "Feste Zeitstempelfarbe verwenden";
L["Timestamps"] = "Zeitstempel";
L["Enable Custom Aliases"] = "Benutzerdefinierte Aliasse aktivieren";
L["Dangerous Actions!"] = "Gefährliche Aktionen!";
L["Cannot delete the Default profile."] =
  "Das Standardprofil kann nicht gelöscht werden.";
L["Are you sure you want to delete profile '%s'?"] =
  "Sind Sie sicher, dass Sie das Profil '%s' löschen möchten?";
L["DELETE"] = "LÖSCHEN";
L["Please type '%s' to confirm:"] =
  "Bitte geben Sie '%s' ein, um zu bestätigen:";
L["Enter a new unique profile name:"] =
  "Geben Sie einen neuen eindeutigen Profilnamen ein:";
L["Current Profile:"] = "Aktuelles Profil:";
L["Show the MUI Config Menu"] = "MUI Konfigurationsmenü anzeigen";
L["Show the MUI Installer"] = "MUI Installationsprogramm anzeigen";
L["List All Profiles"] = "Alle Profile auflisten";
L["Show the MUI Profile Manager"] = "MUI Profil-Manager anzeigen";
L["Set Profile"] = "Profil festlegen";
L["Show Currently Active Profile"] = "Aktuell aktives Profil anzeigen";
L["Show the Version of MUI"] = "Zeige die Version von MUI";
L["Show the MUI Layout Tool"] = "MUI Layout-Tool anzeigen";
L["Some settings will not be changed until the UI has been reloaded."] =
  "Einige Einstellungen werden erst geändert, wenn die Benutzeroberfläche neu geladen wurde.";
L["Would you like to reload the UI now?"] =
  "Möchten Sie die Benutzeroberfläche jetzt neu laden?";
L["Reload UI"] = "Benutzeroberfläche neu laden";
L["No"] = "Nein";
L["Profile changed to %s."] = "Profil geändert zu %s.";
L["Profile %s has been reset."] = "Profil %s wurde zurückgesetzt.";

---------------------------------
--- LARGE TEXT:
---------------------------------
L["TT_MUI_CONTROL_SUF"] =
  [[Wenn aktiviert, wird MUI die Shadowed Unit Frames passend in sein UI verschieben.

Es wird automatisch die Positionen anpassen, wenn die untere Benutzeroberfläche
erweitert over verkleinert wird.]];

L["TT_MUI_CONTROL_BARTENDER"] =
  [[Wenn aktiviert, wird MUI die ausgewählten Bartender Leisten so verschieben,
das sie in die untere Benutzeroberfläche passen.

Auch die ein-ausblende Animationen werden die repositionierung der Aktionsleisten berücksichtigen.]];

L["TT_MUI_USE_TARGET_CLASS_COLOR"] =
  [[Wenn aktiviert, wird der Farbverlauf die Klassenfarben des Ziels statt die vordefinierten verwenden.
Es werden aber weiterhin die Alphawerte und Endfarbe verwendet]];

L["MUI_Setup_InfoTab"] = [[Community Discord:
%s

Besuchen Sie die offizielle MayronUI Webseite für weitere Informationen:
%s

Offizelle GitHub Seite:
%s

Werde Patron und bekomme exklusive Vorteile inerhalb der Community:
%s

Mayron's offizeller YouTube Kanal:
%s]]

L["MUI_Setup_CreditsTab"] =
  [[Ein besonderer Dank geht an die folgenden Mitglieder der MayronUI-Community für ihre Beiträge zum Projekt (auf der Registerkarte "Informationen" finden Sie den Link, über den Sie unserer Discord-Community beitreten können):

|cff00ccff> Patrons|r
%s

|cff00ccff> Entwicklung & Fehlerbehebung|r
%s

|cff00ccff> Übersetzungsunterstützung|r
%s

|cff00ccff> Community Support Team|r
%s

Und natürlich vielen Dank an die Autoren der Nicht-MayronUI-AddOns, die in diesem UI-Paket enthalten sind.]]

L["MANAGE_PROFILES_HERE"] = [[Hier können Sie Charakterprofile verwalten.

Standardmäßig hat jeder Char ein eigenes Profil.]]

L["PRESS_HOLD_TOGGLE_BUTTONS"] =
  [[Halten Sie %s außerhalb des Kampfes gedrückt, um die Umschalttasten anzuzeigen.
Wenn Sie auf diese klicken, werden zusätzliche Aktionsleistenzeilen ein- oder ausgeblendet.]]

L["CHANGE_KEYBINDINGS"] =
  [[Sie können diese Tastenkombination im MUI-Konfigurationsmenü (%s) ändern.
Es gibt 3 Tastenkombinationen, um schnell zwischen 1 bis 3 Reihen zu wechseln,
finden Sie im Blizzard-Tastenbelegungsmenü:]]

L["THANK_YOU_FOR_INSTALLING"] =
  [[Vielen Dank für die Installation von MayronUI!

Sie können die Benutzeroberfläche mithilfe des Konfigurationsmenüs vollständig anpassen:]]

L["SHOW_AURAS_WITH_UNKNOWN_TIME_TOOLTIP"] =
  [[Wenn aktiviert, Auren mit unbekannter verbleibender Zeit sowie Auren, die nie
ablaufen, wenn nicht storniert, wird im Timerleistenfeld angezeigt und wird
nie erschöpfen. Der Balken wird weiterhin verschwinden, wenn die Aura entfernt wird.

Im Klassiker die verbleibende Zeit einiger Auren (je nach Situation)
ist dem Spieler möglicherweise nicht bekannt und wird ausgeblendet, wenn dies nicht aktiviert ist.]]

L["AURAS_ORDERING_ON_TOOLTIP"] =
  [[Die folgende Einstellung steuert die Reihenfolge der Auren im Tooltip
wenn Buffs und Debuffs zusammen positioniert sind
(entweder über oder unter dem Tooltip) und sind beide aktiviert.]]

L["MANAGE_TEXT_HIGHLIGHTING"] = [[Text zum Hervorheben und optional verwalten
einen Soundeffekt abspielen, wenn sie im Chat erscheinen.]]

L["NO_HIGHLIGHT_TEXT_ADDED"] = [[Sie haben noch keinen Text hinzugefügt!
Klicken Sie unten auf die Schaltfläche "Text bearbeiten", um Text zum Hervorheben hinzuzufügen:]];

L["UNIQUE_CHARACTER_PROFILE"] =
  [[Standardmäßig wird jedem neuen Char automatisch ein eindeutiges Pofil erstellt, anstelle eines einzelnen Standardprofils zugewiesen.
Profile werden automatisch erst zugewiesen, nachdem die Benutzeroberfläche auf einem neuen Char installiert wurde.]]

L["Reset Chat Settings"] = "Chat-Einstellungen zurücksetzen";
L["RESET_CHAT_SETTINGS_TOOLTIP"] = "Wenn Sie dies deaktivieren, bleiben Ihre Chat-Registerkarten und die mit jedem Chat-Fenster verknüpften Blizzard-Chat-Einstellungen erhalten.";

L["DRAGONFLIGHT_BAR_POPUP_EXPLAIN_PROBLEM"] = "Das neue Dragonflight-Aktionsleistensystem ist mit Ihren aktuellen Bartender4-Einstellungen nicht kompatibel.";
L["DRAGONFLIGHT_BAR_POPUP_SOLUTION"] = "Sie können dies beheben, indem Sie sie durch die neuesten |cff00ccffMayronUI|r-Voreinstellungen für Bartender4 ersetzen.";
L["DRAGONFLIGHT_BAR_POPUP_APPROVAL"] = "Willst du das jetzt tun?";
L["DRAGONFLIGHT_BAR_POPUP_RELOAD_UI"] = "Dadurch wird die Benutzeroberfläche neu geladen";
L["DRAGONFLIGHT_BAR_POPUP_WARNING"] = "Warnung! Dadurch werden alle Anpassungen gelöscht, die Sie an Ihren Bartender4-Aktionsleisten vorgenommen haben.";
L["Yes, I want to update my action bar layout"] = "Ja, ich möchte mein Aktionsleisten-Layout aktualisieren";