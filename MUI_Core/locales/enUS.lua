local L = LibStub("AceLocale-3.0"):NewLocale ("MayronUI", "enUS", true, true) 
if not L then return end 
--[[
To enable a translation, you need to uncomment the responsible line.
See https://www.lua.org/pil/1.3.html	for information of how to comment in LUA
 
To change the value fill in the translation on the right side of the equal sign.
Example:
	L["Hello!"] 						= "Hi!";
	
The spaces are not needed. They are just for alignment.
]]
-- english translations go here
-- MUI Chat
--[[
L["Hello!"] 						;
L["Character"]						;
L["Bags"]							;
L["Friends"]						;
L["Guild"]							;
L["Help Menu"]						;
L["PVP"]							;
L["Spell Book"]						;
L["Talents"]						;
L["Achievements"]					;
L["Glyphs"]							;
L["Calendar"]						;
L["LFD"]							;
L["Raid"]							;
L["Encounter Journal"]				;
L["Collections Journal"]			;
L["Macros"]							;
L["Map / Quest Log"]				;
L["Reputation"]						;
L["PVP Score"]						;
L["Currency"]						;
L["MUI Layout Button"]				;
L["Left Click:"]					;
L["Switch Layout"]					;
L["Middle Click:"]					;
L["Toggle Blizzard Speech Menu"]	;
L["Right Click:"]					;
L["Show Layout Config Tool"]		;
L["ALT + Left Click:"]				;
L["Toggle Tooltip"]					;
L["Edit Box (Message Input Box)"]	;
L["Background Color"]				;
L["Backdrop Inset"]					;
L["Chat Frame Options"]				;
L["Enable Chat Frame"]				;
L["Options"]						;
L["Button Swapping in Combat"]		;
L["Standard Chat Buttons"]			;
L["Left Button"]					;
L["Middle Button"]					;
L["Right Button"]					;
L["Shift"]							;	-- Mod-Key!
L["Ctrg"]							;	-- Mod-Key!
L["Alt"]							;	-- Mod-Key!
L["Set the border size."]			;
L["The height of the edit box."]	;

L["Chat Buttons with Modifier Key 1"]						;
L["Chat Buttons with Modifier Key 2"]						;
L["Set the vertical positioning of the edit box."]			;
L["Set the spacing between the background and the border."]	;

L["Allow the use of modifier keys to swap chat buttons while in combat."]						;

-- MUI Core
L["Failed to load MUI_Config. Possibly missing?"]			;
L["List of slash commands:"]								;
L["shows config menu"]										;
L["shows setup menu"]										;
L["Welcome back"]											;
L["Starter Edition accounts cannot perform this action."]	;
L["Loot Specialization set to: Current Specialization"]		;
L["Must be level 10 or higher to use Talents."]				;
L["Requires level 10+ to view the PVP window."]				;
L["Requires level 10+ to view the Glyphs window."]			;
L["Requires being inside a Battle Ground."]					;

L["Choose Spec"]					;
L["Choose Loot Spec"]				;
L["Current Spec"]					;
L[" (current)"]						;
L["Toggle Bags"]					;
L["Sort Bags"]						;
L["Commands"]						;
L["Armor"]							;
L["Head"]							;
L["Shoulder"]						;
L["Chest"]							;
L["Waist"]							;
L["Legs"]							;
L["Feet"]							;
L["Wrist"]							;
L["Hands"]							;
L["Main Hand"]						;
L["Secondary Hand"]					;
L["Zone"]							;
L["Rank"]							;
L["<none>"]							;
L["Notes"]							;
L["Achievement Points"]				;
L["No Guild"]						;
L["No Spec"]						;
L["Current Money"]					;
L["Start of the day"]				;
L["Today's profit"]					;
L["Money per character"]			;

-- afk
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
L["AFK Window"]						= "";
L["Enable AFK Window"]				= "";
L["Use the MUI AFK Window"]			= "";
L["Rotate the Camera"]				= "";
L["Show your character"]			= "";

L["Displays a zoomed version of your character."]			= "";
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

L["While AFK the camera will slowly rotate arround your character."]							= "";
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

L["TT_MUI_USE_TARGET_CLASS_COLOR"]	= 
[[If checked, the target portrait gradient will use the target's class\n"..
"color instead of using the 'Start Color' RGB values. It will\n"..
"still use the Alpha and 'End Color' RGB values."]];