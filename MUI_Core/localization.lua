------------------------
-- Setup namespaces
------------------------
local _, core = ...;
local em = core.EventManager;
local tk = core.Toolkit;
local db = core.Database;

local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

core.L = L;
local LOCALE = GetLocale()

if LOCALE == "enUS" then
	-- The EU English game client also
	-- uses the US English locale code.
return end

if LOCALE == "deDE" then
	-- German translations go here
	-- MUI Chat
	L["Hello!"] 						= "Hallo!";
	L["Character"]						= "Charakter";
	L["Bags"]							= "Taschen";
	L["Friends"]						= "Freunde";
	L["Guild"]							= "Gilde";
	L["Help Menu"]						= "Hilfe Menü";
	L["PVP"]							= "PVP";
	L["Spell Book"]						= "Zauber Buch";
	L["Talents"]						= "Talente";
	L["Achievements"]					= "Erfolge";
	L["Glyphs"]							= "Glyphen";
	L["Calendar"]						= "Kalender";
	L["LFD"]							= "LFD";
	L["Raid"]							= "Raid";
	L["Encounter Journal"]				= "Encounter Journal";
	L["Collections Journal"]			= "Sammlungen Journal";
	L["Macros"]							= "Makros";
	L["Map / Quest Log"]				= "Karte / Quests";
	L["Reputation"]						= "Ruf";
	L["PVP Score"]						= "PVP Wertung";
	L["Currency"]						= "Währung";
	L["MUI Layout Button"]				= "MUI Layout Taste";
	L["Left Click:"]					= "Links Klick:";
	L["Switch Layout"]					= "Layout wechseln";
	L["Middle Click:"]					= "Mittel Klick:";
	L["Toggle Blizzard Speech Menu"]	= "Blizzard Chat Menü";
	L["Right Click:"]					= "Rechts Klick:";
	L["Show Layout Config Tool"]		= "Zeige Layout Konfig-Tool";
	L["ALT + Left Click:"]				= "ALT + Links Klick:";
	L["Toggle Tooltip"]					= "Tooltip";
	
	-- MUI Core
	L["Starter Edition accounts cannot perform this action."]	= "Sorry, das geht nicht mit der Starter Edition.";
	L["Loot Specialization set to: Current Specialization"]		= "Die Beute Spezialisierung entspricht der Spezialisierung:";
	L["Must be level 10 or higher to use Talents."]				= "Talente sind erst ab Level 10 verfügbar.";
	L["Choose Spec"]					= "Spezialisierung wählen";
	L["Choose Loot Spec"]				= "Beutespezialisierung wählen";
	L["Current Spec"]					= "Aktive Spezialisierung";
	L[" (current)"]						= " (aktuell)";
	L["Friends"]						= "Freunde";
	L["Guild"]							= "Gilde";
	L["Bags"]							= "Taschen";
	L["Toggle Bags"]					= "Taschen umschalten";
	L["Sort Bags"]						= "Taschen sortieren";
	L["Commands"]						= "Befehle";
	L["Armor"]							= "Rüstung";
	L["Head"]							= "Kopf";
	L["Shoulder"]						= "Schulter";
	L["Chest"]							= "Brust";
	L["Waist"]							= "Tailie";
	L["Legs"]							= "Beine";
	L["Feet"]							= "Füße";
	L["Wrist"]							= "Arme";
	L["Hands"]							= "Hände";
	L["Main Hand"]						= "Haupthand";
	L["Secondary Hand"]					= "Nebenhand";
	L["Zone"]							= "Zone";
	L["Rank"]							= "Rang";
	L["<none>"]							= "<Keine>";
	L["Notes"]							= "Anmerkungen";
	L["Achievement Points"]				= "Erfolgspunkte";
	L["No Guild"]						= "Keine Gilde";
	L["No Spec"]						= "Keine Spezialisierung";
	L["Current Money"]					= "Aktuelles Vermögen";
	L["Start of the day"]				= "Bei Tagesbeginn";
	L["Today's profit"]					= "Tagesprofit";
	L["Money per character"]			= "Vermögen je Charakter";
return end

if LOCALE == "frFR" then
	-- French translations go here
	-- MUI Chat
	L["Hello!"] = "Bonjour!"
	L["Character"]						= "Charakter";
	L["Bags"]							= "Des sacs";
	L["Friends"]						= "Copains";
	L["Guild"]							= "Guilde";
	L["Help Menu"]						= "Menu d'aide";
	L["PVP"]							= "PVP";
	L["Spell Book"]						= "Livre de sortilèges";
	L["Talents"]						= "Talents";
	L["Achievements"]					= "Accomplissement";
	L["Glyphs"]							= "Glyphes";
	L["Calendar"]						= "Calendrier";
	L["LFD"]							= "LFD";
	L["Raid"]							= "Raid";
	L["Encounter Journal"]				= "Journal de rencontre";
	L["Collections Journal"]			= "Journal des collections";
	L["Macros"]							= "Macros";
	L["Map / Quest Log"]				= "Carte / Quêtes";
	L["Reputation"]						= "Réputation";
	L["PVP Score"]						= "Score PVP";
	L["Currency"]						= "Devise";
	L["MUI Layout Button"]				= "MUI bouton de mise en page";
	L["Left Click:"]					= "Click gauche:";
	L["Switch Layout"]					= "Changer la disposition";
	L["Middle Click:"]					= "Click milieu:";
	L["Toggle Blizzard Speech Menu"]	= "Basculer le menu du discours Blizzard";
	L["Right Click:"]					= "Click droite:";
	L["Show Layout Config Tool"]		= "Afficher l'outil de configuration de la mise en page";
	L["ALT + Left Click:"]				= "ALT + Click gauche:";
	L["Toggle Tooltip"]					= "Tooltip";
	
	L["(current)"]						= " (actuel)";
	
return end

if LOCALE == "esES" or LOCALE == "esMX" then
	-- Spanish translations go here
	L["Hello!"] = "¡Hola!"
return end

if LOCALE == "ptBR" then
	-- Brazilian Portuguese translations go here
	L["Hello!"] = "Olá!"
	-- Note that the EU Portuguese WoW client also
	-- uses the Brazilian Portuguese locale code.
return end

if LOCALE == "ruRU" then
	-- Russian translations go here
	L["Hello!"] = "Привет!"
return end

if LOCALE == "koKR" then
	-- Korean translations go here
	L["Hello!"] = "안녕하세요!"
return end

if LOCALE == "zhCN" then
	-- Simplified Chinese translations go here
	L["Hello!"] = "您好!"
return end

if LOCALE == "zhTW" then
	-- Traditional Chinese translations go here
	L["Hello!"] = "您好!"
return end
