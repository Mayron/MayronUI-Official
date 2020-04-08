local L = LibStub("AceLocale-3.0"):NewLocale ("MayronUI", "enUS", true);
if not L then return end

--[[
To change the value fill in the translation on the right side of the equal sign.
Example:
	L["Hello!"] = "Hi!";
]]

-- English translations go here
-- MUI Chat
L["Hello!"] = "Hello!"
L["Character"]= "Character"
L["Bags"]= "Bags"
L["Friends"]= "Friends"
L["Guild"]= "Guild"
L["Help Menu"]= "Help Menu"
L["PVP"]= "PVP"
L["Spell Book"]= "Spell Book"
L["Talents"]= "Talents"
L["Achievements"]= "Achievements"
L["Glyphs"]= "Glyphs"
L["Calendar"]= "Calendar"
L["LFD"]= "LFD"
L["Raid"]= "Raid"
L["Encounter Journal"]= "Encounter Journal"
L["Collections Journal"]= "Collections Journal"
L["Macros"]= "Macros"
L["World Map"]    = "World Map"
L["Quest Log"]= "Quest Log"
L["Reputation"]= "Reputation"
L["PVP Score"]= "PVP Score"
L["Currency"]= "Currency"
L["MUI Layout Button"]= "MUI Layout Button"
L["Left Click:"]= "Left Click:"
L["Switch Layout"]= "Switch Layout"
L["Middle Click:"]= "Middle Click:"
L["Toggle Blizzard Speech Menu"]= "Toggle Blizzard Speech Menu"
L["Right Click:"]= "Right Click:"
L["Show Layout Config Tool"]= "Show Layout Config Tool"
L["ALT + Left Click:"]= "ALT + Left Click:"
L["Toggle Tooltip"]= "Toggle Tooltip"
L["Edit Box (Message Input Box)"]= "Edit Box (Message Input Box)"
L["Background Color"]= "Background Color"
L["Backdrop Inset"]= "Backdrop Inset"
L["Chat Frame Options"]= "Chat Frame Options"
L["Enable Chat Frame"]= "Enable Chat Frame"
L["Options"]= "Options"
L["Button Swapping in Combat"]= "Button Swapping in Combat"
L["Standard Chat Buttons"]= "Standard Chat Buttons"
L["Left Button"]= "Left Button"
L["Middle Button"]= "Middle Button"
L["Right Button"]= "Right Button"
L["Shift"]= "Shift"
L["Ctrl"]= "Ctrl"
L["Alt"]= "Alt"

L["Chat Buttons with Modifier Key 1"] = "Chat Buttons with Modifier Key 1";
L["Chat Buttons with Modifier Key 2"] = "Chat Buttons with Modifier Key 2";
L["Set the border size.\n\nDefault is 1."] = "Set the border size.\n\nDefault is 1.";
L["Cannot toggle menu while in combat."]  = "Cannot toggle menu while in combat.";
L["Cannot switch layouts while in combat."] = "Cannot switch layouts while in combat.";

L["Set the spacing between the background and the border.\n\nDefault is 0."]
= "Set the spacing between the background and the border.\n\nDefault is 0.";

L["Allow the use of modifier keys to swap chat buttons while in combat."]
= "Allow the use of modifier keys to swap chat buttons while in combat.";

-- MUI Core
L["Failed to load MUI_Config. Possibly missing?"]= "Failed to load MUI_Config. Possibly missing?";
L["List of slash commands:"]= "List of slash commands:";
L["shows config menu"]= "shows config menu";
L["shows setup menu"]= "shows setup menu";
L["Welcome back"]= "Welcome back";
L["Starter Edition accounts cannot perform this action."]= "Starter Edition accounts cannot perform this action.";
L["Loot Specialization set to: Current Specialization"]= "Loot Specialization set to: Current Specialization";
L["Must be level 10 or higher to use Talents."]= "Must be level 10 or higher to use Talents.";
L["Requires level 10+ to view the PVP window."]= "Requires level 10+ to view the PVP window.";
L["Requires level 10+ to view the Glyphs window."]= "Requires level 10+ to view the Glyphs window.";
L["Requires being inside a Battle Ground."]= "Requires being inside a Battle Ground.";

L["Choose Spec"]= "Choose Spec";
L["Choose Loot Spec"]= "Choose Loot Spec";
L["Current Spec"]= "Current Spec";
L[" (current)"]= " (current)";
L["Toggle Bags"]= "Toggle Bags";
L["Sort Bags"]= "Sort Bags";
L["Commands"]= "Commands";
L["Armor"]= "Armor";
L["Head"]= "Head";
L["Shoulder"]= "Shoulder";
L["Chest"]= "Chest";
L["Waist"]= "Waist";
L["Legs"]= "Legs";
L["Feet"]= "Feet";
L["Wrist"]= "Wrist";
L["Hands"]= "Hands";
L["Main Hand"]= "Main Hand";
L["Secondary Hand"]= "Secondary Hand";
L["Zone"]= "Zone";
L["Rank"]= "Rank";
L["<none>"]= "<none>";
L["Notes"]= "Notes";
L["Achievement Points"]= "Achievement Points";
L["No Guild"]= "No Guild";
L["No Spec"]= "No Spec";
L["Current Money"]= "Current Money";
L["Start of the day"]= "Start of the day";
L["Today's profit"]= "Today's profit";
L["Money per character"]= "Money per character";

-- afk= ""
L["Guild Chat"]= "Guild Chat";
L["Whispers"]= "Whispers";

-- MUI Castbar= ""
L[" CastBar not enabled."]= " CastBar not enabled.";
L["Lock"]= "Lock";
L["Unlock"]= "Unlock";
L["Appearance"]= "Appearance";
L["Bar Texture"]= "Bar Texture";
L["Border"]= "Border";
L["Border Size"]= "Border Size";
L["Frame Inset"]= "Frame Inset";
L["Colors"]= "Colors";
L["Normal Casting"]= "Normal Casting";
L["Finished Casting"]= "Finished Casting";
L["Interrupted"]= "Interrupted";
L["Latency"]= "Latency";
L["Backdrop"]= "Backdrop";
L["Individual Cast Bar Options"]= "Individual Cast Bar Options";
L["Enable Bar"]= "Enable Bar";
L["Show Icon"]= "Show Icon";
L["Show Latency Bar"]= "Show Latency Bar";
L["Anchor to SUF Portrait Bar"]= "Anchor to SUF Portrait Bar";
L["Width"]= "Width";
L["Height"]= "Height";
L["Frame Strata"]= "Frame Strata";
L["Frame Level"]= "Frame Level";
L["Manual Positioning"]= "Manual Positioning";
L["Point"]= "Point";
L["Relative Frame"]= "Relative Frame";
L["Relative Point"]= "Relative Point";
L["X-Offset"]= "X-Offset";
L["Y-Offset"]= "Y-Offset";
L["Player"]= "Player";
L["Target"]= "Target";
L["Focus"]= "Focus";
L["Mirror"]= "Mirror";

L["If enabled the Cast Bar will be fixed to the %s Unit Frame's Portrait Bar (if it exists)."]
= "If enabled the Cast Bar will be fixed to the %s Unit Frame's Portrait Bar (if it exists).";
L["The %s Unit Frames's Portrait Bar needs to be enabled to use this feature."]
= "The %s Unit Frames's Portrait Bar needs to be enabled to use this feature.";
L["Only takes effect if the Cast Bar is not anchored to a SUF Portrait Bar."]
= "Only takes effect if the Cast Bar is not anchored to a SUF Portrait Bar.";
L["Manual positioning only works if the CastBar is not anchored to a SUF Portrait Bar."]
= "Manual positioning only works if the CastBar is not anchored to a SUF Portrait Bar.";

-- MUI Minimap
L["CTRL + Drag:"]= "CTRL + Drag:";
L["SHIFT + Drag:"]= "SHIFT + Drag:";
L["Mouse Wheel:"]= "Mouse Wheel:";
L["ALT + Left Click:"]= "ALT + Left Click:";
L["Move Minimap"]= "Move Minimap";
L["Resize Minimap"]= "Resize Minimap";
L["Ping Minimap"]= "Ping Minimap";
L["Show Tracking Menu"]= "Show Tracking Menu";
L["Show Menu"]= "Show Menu";
L["Zoom in/out"]= "Zoom in/out";
L["Toggle this Tooltip"]= "Toggle this Tooltip";
L["New Event!"]= "New Event!";
L["Calendar"]= "Calendar";
L["Customer Support"]= "Customer Support";
L["Class Order Hall"]= "Class Order Hall";
L["Garrison Report"]= "Garrison Report";
L["Tracking Menu"]= "Tracking Menu";
L["MUI Config Menu"]= "MUI Config Menu";
L["MUI Installer"]= "MUI Installer";
L["Music Player"]= "Music Player";

L["Cannot access config menu while in combat."]= "Cannot access config menu while in combat.";

-- MUI Setup
L["Choose Theme:"]= "Choose Theme:";
L["Custom Colour"]= "Custom Colour";
L["Theme"]= "Theme";
L["Choose Profile:"]= "Choose Profile:";
L["<new profile>"]= "<new profile>";
L["<remove profile>"]= "<remove profile>";
L["Create New Profile:"]= "Create New Profile:";
L["Remove Profile:"]= "Remove Profile:";
L["Confirm"]= "Confirm";
L["Cancel"]= "Cancel";
L["Enabled Chat Frames:"]= "Enabled Chat Frames:";
L["Top Left"]= "Top Left";
L["Top Right"]= "Top Right";
L["Bottom Left"]= "Bottom Left";
L["Bottom Right"]= "Bottom Right";
L["Adjust the UI Scale:"]= "Adjust the UI Scale:";
L["Use Localization:"]= "Use Localization:";
L["WoW Client: "]= "WoW Client: ";
L["AddOn Settings to Override:"]= "AddOn Settings to Override:";
L["Install"]= "Install";
L["INSTALL"]= "INSTALL";
L["CUSTOM INSTALL"]= "CUSTOM INSTALL";
L["INFORMATION"]= "INFORMATION";
L["Warning:"]= "Warning:";
L["This will reload the UI!"]= "This will reload the UI!";
L["Setup Menu"]= "Setup Menu";
L["VERSION"]= "VERSION";

L["This will ensure that frames are correctly positioned to match the UI scale during installation.\n\nDefault value is 0.7"]
= "This will ensure that frames are correctly positioned to match the UI scale during installation.\n\nDefault value is 0.7";

-- MUI TimerBar
L["Only track your %s"]= "Only track your %s";
L["Track all %s"]= "Track all %s";
L["General Options"]= "General Options";
L["Sort By Time Remaining"]= "Sort By Time Remaining";
L["Show Tooltips On Mouseover"]= "Show Tooltips On Mouseover";
L["Create New Field"]= "Create New Field";
L["Name of New TimerBar Field:"]= "Name of New TimerBar Field:";
L["Name of TimerBar Field to Remove:"]= "Name of TimerBar Field to Remove:";
L["TimerBar field '%s' created."]= "TimerBar field '%s' created.";
L["TimerBar field '%s' remove."]= "TimerBar field '%s' removed.";
L["TimerBar field '%s' does not exist."]= "TimerBar field '%s' does not exist.";
L["Remove Field"]= "Remove Field";
L["Existing Timer Bar Fields"]= "Existing Timer Bar Fields";
L["Enable Field"]= "Enable Field";
L["<%s Field>"]= "<%s Field>";
L["Unit to Track"]= "Unit to Track";
L["Manage Tracking Buffs"]= "Manage Tracking Buffs";
L["TargetTarget"]= "TargetTarget";
L["FocusTarget"]= "FocusTarget";
L["Manage Tracking Debuffs"]= "Manage Tracking Debuffs";
L["Appearance Options"]= "Appearance Options";
L["Up"]= "Up";
L["Down"]= "Down";
L["Bar Width"]= "Bar Width";
L["Bar Height"]= "Bar Height";
L["Bar Spacing"]= "Bar Spacing";
L["Show Icons"]= "Show Icons";
L["Show Spark"]= "Show Spark";
L["Buff Bar Color"]= "Buff Bar Color";
L["Debuff Bar Color"]= "Debuff Bar Color";
L["Manual Positioning"]= "Manual Positioning";
L["Text Options"]= "Text Options";
L["Time Remaining Text"]= "Time Remaining Text";
L["Show"]= "Show";
L["Font Size"]= "Font Size";
L["Default is 11"]= "Default is 11";
L["Font Type"]= "Font Type";
L["Spell Name Text"]= "Spell Name Text";

L["Enter the Name of a %s to Track:"]
= "Enter the Name of a %s to Track:";
L["Only %s casted by you will be tracked."]
= "Only %s casted by you will be tracked.";
L["Ignore the list of %s to track and track everything."]
= "Ignore the list of %s to track and track everything.";
L["Enabling this will dynamically generate the list of %s to track."]
= "Enabling this will dynamically generate the list of %s to track.";
L["The unit who is affected by the spell."]
= "The unit who is affected by the spell.";
L["The field's vertical growth direction:"]
= "The field's vertical growth direction:";

-- MUI Config
L["Reload UI"]= "Reload UI";
L["General"]= "General";
L["Master Font"]= "Master Font";
L["Enable Master Font"]= "Enable Master Font";
L["Display Lua Errors"]= "Display Lua Errors";
L["Set Theme Color"]= "Set Theme Color";
L["Objective (Quest) Tracker"]= "Objective (Quest) Tracker";
L["Anchor to Side Bar"]= "Anchor to Side Bar";
L["Set Width"]= "Set Width";
L["Set Height"]= "Set Height";
L["Bottom UI Panels"]= "Bottom UI Panels";
L["Container Width"]= "Container Width";
L["Unit Panels"]= "Unit Panels";
L["Enable Unit Panels"]= "Enable Unit Panels";
L["Symmetric Unit Panels"]= "Symmetric Unit Panels";
L["Name Panels"]= "Name Panels";
L["Unit Panel Width"]= "Unit Panel Width";
L["Target Class Colored"]= "Target Class Colored";
L["Action Bar Panel"]= "Action Bar Panel";
L["Enable Action Bar Panel"]= "Enable Action Bar Panel";
L["Animation Speed"]= "Animation Speed";
L["Retract Height"]= "Retract Height";
L["Expand Height"]= "Expand Height";
L["Expand and Retract Buttons"]= "Expand and Retract Buttons";
L["Control"]= "Control";
L["SUF Portrait Gradient"]= "SUF Portrait Gradient";
L["Enable Gradient Effect"]= "Enable Gradient Effect";
L["Gradient Colors"]= "Gradient Colors";
L["Start Color"]= "Start Color";
L["End Color"]= "End Color";
L["Target Class Colored"]= "Target Class Colored";
L["Bartender Action Bars"]= "Bartender Action Bars";
L["Row 1"]= "Row 1";
L["Row 2"]= "Row 2";
L["First Bartender Bar"]= "First Bartender Bar";
L["Second Bartender Bar"]= "Second Bartender Bar";
L["Artifact"]= "Artifact";
L["Reputation"]= "Reputation";
L["Experience"]= "Experience";
L["Enabled"]= "Enabled";
L["Default value is "]= "Default value is ";
L["Minimum value is "]= "Minimum value is ";
L["true"]= "true";
L["false"]= "false";
L["Show Text"]= "Show Text";
L["Data Text"]= "Data Text";
L["General Data Text Options"]= "General Data Text Options";
L["Block in Combat"]= "Block in Combat";
L["Auto Hide Menu in Combat"]= "Auto Hide Menu in Combat";
L["Spacing"]= "Spacing";
L["Menu Width"]= "Menu Width";
L["Max Menu Height"]= "Max Menu Height";
L["Bar Strata"]= "Bar Strata";
L["Bar Level"]= "Bar Level";
L["Data Text Modules"]= "Data Text Modules";
L["Data Button"]= "Data Button";
L["Combat_timer"]= "Combat_timer";
L["Durability"]= "Durability";
L["Performance"]= "Performance";
L["Memory"]= "Memory";
L["Money"]= "Money";
L["Show Copper"]= "Show Copper";
L["Show Silver"]= "Show Silver";
L["Show Gold"]= "Show Gold";
L["Spec"]= "Spec";
L["Disabled"]= "Disabled";
L["Blank"]= "Blank";
L["Module Options"]= "Module Options";
L["Show FPS"]= "Show FPS";
L["Show Server Latency (ms)"]= "Show Server Latency (ms)";
L["Show Home Latency (ms)"]= "Show Home Latency (ms)";
L["Show Realm Name"]= "Show Realm Name";
L["Show Total Slots"]= "Show Total Slots";
L["Show Used Slots"]= "Show Used Slots";
L["Show Free Slots"]= "Show Free Slots";
L["Show Self"]= "Show Self";
L["Show Tooltips"]= "Show Tooltips";
L["Side Bar"]= "Side Bar";
L["Width (With 1 Bar)"]= "Width (With 1 Bar)";
L["Width (With 2 Bars)"]= "Width (With 2 Bars)";
L["Hide in Combat"]= "Hide in Combat";
L["Show When"]= "Show When";
L["Never"]= "Never";
L["Always"]= "Always";
L["On Mouse-over"]= "On Mouse-over";
L["Bar"]= "Bar";

L["Uncheck to prevent MUI from changing the game font."]= "Uncheck to prevent MUI from changing the game font.";
L["Config type '%s' unsupported!"]= "Config type '%s' unsupported!";
L["The UI requires reloading to apply changes."]= "The UI requires reloading to apply changes.";
L["Some changes require a client restart to take effect."]= "Some changes require a client restart to take effect.";
L["Warning: This will NOT change the color of CastBars!"]= "Warning: This will NOT change the color of CastBars!";
L["Previously called 'Classic Mode'."]= "Previously called 'Classic Mode'.";
L["Allow MUI to Control Unit Frames"]= "Allow MUI to Control Unit Frames";
L["Allow MUI to Control Grid"]= "Allow MUI to Control Grid";
L["What color the gradient should start as."]= "What color the gradient should start as.";
L["What color the gradient should change into."]= "What color the gradient should change into.";
L["Allow MUI to Control Selected Bartender Bars"]= "Allow MUI to Control Selected Bartender Bars";
L["Show your character in the guild list."]= "Show your character in the guild list.";
L["Adjust the width of the Bottom UI container."]= "Adjust the width of the Bottom UI container.";
L["Adjust the width of the unit frame background panels."]= "Adjust the width of the unit frame background panels.";
L["Adjust the width of the unit name background panels."]= "Adjust the width of the unit name background panels.";
L["Adjust the height of the unit name background panels."]= "Adjust the height of the unit name background panels.";
L["Adjust the width of the Objective Tracker."]= "Adjust the width of the Objective Tracker.";
L["Adjust the height of the Objective Tracker."]= "Adjust the height of the Objective Tracker.";
L["Move the unit name panels further in or out."]= "Move the unit name panels further in or out.";
L["Set the font size of unit names."]= "Set the font size of unit names.";
L["The speed of the Expand and Retract transitions."]= "The speed of the Expand and Retract transitions.";
L["The higher the value, the quicker the speed."]= "The higher the value, the quicker the speed.";
L["The height of the gradient effect."]= "The height of the gradient effect.";
L["Adjust the spacing between data text buttons."]= "Adjust the spacing between data text buttons.";
L["The frame strata of the entire DataText bar."]= "The frame strata of the entire DataText bar.";

L["Anchor the Objective Tracker to the action bar container on the right side of the screen."]
= "Anchor the Objective Tracker to the action bar container on the right side of the screen.";
L["Disable this to stop MUI from controlling the Objective Tracker."]
= "Disable this to stop MUI from controlling the Objective Tracker.";
L["Adjust the horizontal positioning of the Objective Tracker."]
= "Adjust the horizontal positioning of the Objective Tracker.";
L["Adjust the vertical positioning of the Objective Tracker."]
= "Adjust the vertical positioning of the Objective Tracker.";
L["The font size of text that appears on data text buttons."]
= "The font size of text that appears on data text buttons.";
L["Show guild info tooltips when the cursor is over guild members in the guild list."]
= "Show guild info tooltips when the cursor is over guild members in the guild list.";
L["Set the height of the action bar panel when it\nis 'Retracted' to show 1 action bar row."]
= "Set the height of the action bar panel when it\nis 'Retracted' to show 1 action bar row.";
L["Set the height of the action bar panel when it\nis 'Expanded' to show 2 action bar rows."]
= "Set the height of the action bar panel when it\nis 'Expanded' to show 2 action bar rows.";
L["The frame level of the entire DataText bar based on it's frame strata value."]
= "The frame level of the entire DataText bar based on it's frame strata value.";
L["If unchecked, the entire DataText module will be disabled and all"]
= "If unchecked, the entire DataText module will be disabled and all";
L["DataText buttons, as well as the background bar, will not be displayed."]
= "DataText buttons, as well as the background bar, will not be displayed.";
L["Prevents you from using data text modules while in combat."]
= "Prevents you from using data text modules while in combat.";
L["This is useful for 'clickers'."]
= "This is useful for 'clickers'.";

L["If the SUF Player or Target portrait bars are enabled, a class colored gradient will overlay it."]
	= "If the SUF Player or Target portrait bars are enabled, a class colored gradient will overlay it.";

L["TT_MUI_CONTROL_SUF"]=
[[If enabled, MUI will reposition the Shadowed Unit
Frames to fit over the top of the MUI Unit Panels.

It will also automatically move the Unit Frames when
expanding and retracting the MUI Action Bar Panel.]];

L["TT_MUI_CONTROL_GRID"]=
[[|cff00ccffImportant:|r Only for the |cff00ccff'MayronUIH' Grid Profile|r (used in the Healing Layout)!

If enabled, MUI will reposition the Grid Frame to fit on top of the MUI Unit Panels.

It will also automatically move the Grid Frame when expanding and retracting the
MUI Action Bar Panel.]];

L["TT_MUI_CONTROL_BARTENDER"]=
[[If enabled, MUI will reposition the selected Bartender
bars to fit over the top of the action bar panel.

It will also control the fading in and out transitions
of selected row 2 Bartender bars when expanding and
retracting the MUI Action Bar Panel.]];

L["TT_MUI_USE_TARGET_CLASS_COLOR"] =
[[If checked, the target portrait gradient will use the target's class
color instead of using the 'Start Color' RGB values. It will
still use the Alpha and 'End Color' RGB values.]];

L["Show Overview"] = "Show Overview";
L["Show Reset Options"] = "Show Reset Options";
L["Reset All Characters"] = "Reset All Characters";
L["Reset Options"] = "Reset Options";
L["All currency data has been reset."] = "All currency data has been reset.";
L["Currency data for %s has been reset."] = "Currency data for %s has been reset.";
L["Are you sure you want to reset the currency data for all of your characters?"] =
"Are you sure you want to reset the currency data for all of your characters?";
L["Are you sure you want to reset the currency data for %s?"] =
"Are you sure you want to reset the currency data for %s?";

L["Change Status"] = "Change Status";

L["Remove from Whitelist"] = "Remove from Whitelist";
L["Add to Blacklist"] = "Add to Blacklist";

L["Removing %s from the whitelist will hide this timer bar if the whitelist is enabled."] =
"Removing %s from the whitelist will hide this timer bar if the whitelist is enabled.";

L["Adding %s to the blacklist will hide this timer bar if the blacklist is enabled."] =
"Adding %s to the blacklist will hide this timer bar if the blacklist is enabled.";

L["Are you sure you want to do this?"] = "Are you sure you want to do this?";

L["%s has been removed from the whitelist."] = "%s has been removed from the whitelist.";
L["%s has been added to the blacklist."] = "%s has been added to the blacklist.";

L["Filters"] = "Filters";
L["Only show buffs applied by me"] = "Only show buffs applied by me";
L["Only show debuffs applied by me"] = "Only show debuffs applied by me";
L["Enable Whitelist"] = "Enable Whitelist";
L["Configure Whitelist"] = "Configure Whitelist";
L["Enable Blacklist"] = "Enable Blacklist";
L["Configure Blacklist"] = "Configure Blacklist";

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