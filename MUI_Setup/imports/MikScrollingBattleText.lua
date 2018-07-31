local _, setup = ...;

setup.import["MikScrollingBattleText"] = function()
    local settings = {
        ["Default"] = {
            ["normalFontSize"] = 13,
            ["critOutlineIndex"] = 2,
            ["critFontName"] = "Friz Quadrata TT",
            ["normalOutlineIndex"] = 2,
            ["animationSpeed"] = 50,
            ["normalFontName"] = "Friz Quadrata TT",
            ["cooldownThreshold"] = 32,
            ["creationVersion"] = "5.7.138",
            ["critFontSize"] = 14,
            ["events"] = {
                ["PET_INCOMING_HOT_CRIT"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_SPELL_DAMAGE"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_BUFF_FADE"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_SPELL_PARRY"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_HOT"] = {
                    ["scrollArea"] = "Outgoing",
                },
                ["OUTGOING_MISS"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_PARRY"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_IMMUNE"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_SPELL_MISS"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_HEAL_CRIT"] = {
                    ["scrollArea"] = "Incoming",
                    ["fontSize"] = false,
                },
                ["INCOMING_HEAL"] = {
                    ["scrollArea"] = "Outgoing",
                },
                ["PET_OUTGOING_SPELL_ABSORB"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_DEFLECT"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_SPELL_MISS"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_EVADE"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_SPELL_DODGE"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_HOT_CRIT"] = {
                    ["scrollArea"] = "Outgoing",
                },
                ["PET_OUTGOING_HEAL"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_HEAL_CRIT"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_HEAL_CRIT"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_DOT_CRIT"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_SPELL_IMMUNE"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_EVADE"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_ABSORB"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_SPELL_BLOCK"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_ENEMY_BUFF"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_PARRY"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_BLOCK"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_CP_GAIN"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_DEBUFF_FADE"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_SPELL_DAMAGE"] = {
                    ["scrollArea"] = "Outgoing",
                },
                ["NOTIFICATION_SKILL_GAIN"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_EVADE"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_SPELL_MISS"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_DODGE"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_IMMUNE"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_DAMAGE_CRIT"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_DEFLECT"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_ABSORB"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_DISPEL"] = {
                    ["scrollArea"] = "Static",
                },
                ["PET_OUTGOING_DISPEL"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_PC_KILLING_BLOW"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_REP_LOSS"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_RESIST"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_SPELL_INTERRUPT"] = {
                    ["scrollArea"] = "Static",
                },
                ["OUTGOING_IMMUNE"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_HOLY_POWER_CHANGE"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_REFLECT"] = {
                    ["scrollArea"] = "Static",
                },
                ["INCOMING_SPELL_DAMAGE_SHIELD"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_ENVIRONMENTAL"] = {
                    ["scrollArea"] = "Outgoing",
                },
                ["INCOMING_SPELL_RESIST"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_HOT"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_ABSORB"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_DOT"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_ITEM_BUFF"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_SPELL_DAMAGE"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_IMMUNE"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_SPELL_DEFLECT"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_ALT_POWER_GAIN"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_DAMAGE_SHIELD_CRIT"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_HEAL"] = {
                    ["scrollArea"] = "Incoming",
                },
                ["PET_OUTGOING_HOT_CRIT"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_CHI_FULL"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_BLOCK"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_HONOR_GAIN"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_SPELL_ABSORB"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_HEAL"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_SPELL_DAMAGE_SHIELD_CRIT"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_SPELL_RESIST"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_PARRY"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_DODGE"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_POWER_LOSS"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_PARRY"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_MONEY"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_SPELL_IMMUNE"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_SPELL_DEFLECT"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_DAMAGE"] = {
                    ["scrollArea"] = "Outgoing",
                },
                ["PET_INCOMING_SPELL_DOT_CRIT"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_SPELL_PARRY"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_SPELL_ABSORB"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_ALT_POWER_LOSS"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_DAMAGE_CRIT"] = {
                    ["scrollArea"] = "Outgoing",
                },
                ["PET_OUTGOING_MISS"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_DAMAGE_CRIT"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_DODGE"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_SPELL_DAMAGE_CRIT"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_CP_FULL"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_SPELL_IMMUNE"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_COMBAT_LEAVE"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_BLOCK"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_REP_GAIN"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_PARRY"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_HOT_CRIT"] = {
                    ["scrollArea"] = "Incoming",
                },
                ["INCOMING_SPELL_DAMAGE_SHIELD_CRIT"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_SPELL_REFLECT"] = {
                    ["scrollArea"] = "Static",
                },
                ["PET_INCOMING_SPELL_DAMAGE_SHIELD"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_ABSORB"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_DEFLECT"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_SPELL_PARRY"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_INTERRUPT"] = {
                    ["scrollArea"] = "Static",
                },
                ["INCOMING_SPELL_DEFLECT"] = {
                    ["scrollArea"] = "Static",
                },
                ["INCOMING_BLOCK"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_DODGE"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_ABSORB"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_HOT"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_SPELL_DOT_CRIT"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_SPELL_DAMAGE_SHIELD"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_SHADOW_ORBS_FULL"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_DAMAGE"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_SPELL_DAMAGE_SHIELD_CRIT"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_SPELL_DODGE"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_SPELL_DAMAGE_CRIT"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_MISS"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_SPELL_DODGE"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_SPELL_RESIST"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_SPELL_DAMAGE_CRIT"] = {
                    ["scrollArea"] = "Outgoing",
                },
                ["PET_INCOMING_SPELL_DOT"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_SPELL_DOT"] = {
                    ["scrollArea"] = "Outgoing",
                },
                ["PET_OUTGOING_SPELL_BLOCK"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_COOLDOWN"] = {
                    ["fontSize"] = false,
                    ["soundFile"] = "",
                    ["scrollArea"] = "Custom1",
                },
                ["PET_INCOMING_DAMAGE"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_IMMUNE"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_NPC_KILLING_BLOW"] = {
                    ["scrollArea"] = "Static",
                },
                ["NOTIFICATION_COMBAT_ENTER"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_SHADOW_ORBS_CHANGE"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_SPELL_EVADE"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_SPELL_BLOCK"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_SPELL_DOT"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_DAMAGE"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_MISS"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_MISS"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_BUFF"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_DAMAGE_CRIT"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_DAMAGE"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_ITEM_BUFF_FADE"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_ITEM_COOLDOWN"] = {
                    ["fontSize"] = false,
                    ["soundFile"] = "",
                    ["scrollArea"] = "Custom1",
                },
                ["NOTIFICATION_CHI_CHANGE"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_DEBUFF_STACK"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_DEFLECT"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_SPELL_DOT_CRIT"] = {
                    ["scrollArea"] = "Outgoing",
                },
                ["NOTIFICATION_HOLY_POWER_FULL"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_HOT"] = {
                    ["scrollArea"] = "Incoming",
                },
                ["OUTGOING_BLOCK"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_POWER_GAIN"] = {
                    ["disabled"] = true,
                },
                ["PET_OUTGOING_DODGE"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_SPELL_DAMAGE_SHIELD"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_BUFF_STACK"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_EXTRA_ATTACK"] = {
                    ["disabled"] = true,
                },
                ["OUTGOING_DEFLECT"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_MONSTER_EMOTE"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_LOOT"] = {
                    ["disabled"] = true,
                },
                ["PET_INCOMING_DAMAGE_CRIT"] = {
                    ["disabled"] = true,
                },
                ["INCOMING_HEAL_CRIT"] = {
                    ["scrollArea"] = "Outgoing",
                    ["fontSize"] = false,
                },
                ["NOTIFICATION_PET_COOLDOWN"] = {
                    ["disabled"] = true,
                },
                ["NOTIFICATION_DEBUFF"] = {
                    ["disabled"] = true,
                },
            },
            ["hideFullOverheals"] = true,
            ["soundsDisabled"] = true,
            ["scrollAreas"] = {
                ["Outgoing"] = {
                    ["direction"] = "Up",
                    ["stickyBehavior"] = "MSBT_NORMAL",
                    ["stickyDirection"] = "Up",
                    ["scrollHeight"] = 242.329345703125,
                    ["name"] = "Incomming",
                    ["offsetX"] = 423,
                    ["behavior"] = "MSBT_NORMAL",
                    ["offsetY"] = -121,
                    ["animationStyle"] = "Straight",
                    ["stickyAnimationStyle"] = "Static",
                },
                ["Notification"] = {
                    ["direction"] = "Up",
                    ["animationSpeed"] = 202.486953735352,
                    ["normalFontSize"] = 13.8168544769287,
                    ["critFontSize"] = 13.9358806610107,
                    ["scrollHeight"] = 90,
                    ["offsetX"] = -176,
                    ["name"] = "ErrorFrame",
                    ["stickyDirection"] = "Up",
                    ["offsetY"] = 350,
                    ["animationStyle"] = "Static",
                    ["stickyAnimationStyle"] = "Static",
                },
                ["Static"] = {
                    ["offsetX"] = -19,
                    ["scrollHeight"] = 73.3682250976563,
                    ["name"] = "Notifications",
                    ["offsetY"] = 238,
                },
                ["Custom1"] = {
                    ["direction"] = "Up",
                    ["stickyAnimationStyle"] = "Static",
                    ["critFontSize"] = 16.2856693267822,
                    ["scrollHeight"] = 117.174598693848,
                    ["offsetX"] = -20,
                    ["stickyDirection"] = "Up",
                    ["name"] = "Triggers",
                    ["offsetY"] = -125,
                    ["animationStyle"] = "Static",
                    ["normalFontSize"] = 16,
                },
                ["Incoming"] = {
                    ["direction"] = "Up",
                    ["stickyBehavior"] = "MSBT_NORMAL",
                    ["stickyDirection"] = "Up",
                    ["scrollHeight"] = 240,
                    ["name"] = "PlayerEvents",
                    ["offsetX"] = -420,
                    ["behavior"] = "MSBT_NORMAL",
                    ["offsetY"] = -121,
                    ["animationStyle"] = "Straight",
                    ["stickyAnimationStyle"] = "Static",
                },
            },
            ["shortenNumbers"] = true,
            ["stickyCritsDisabled"] = true,
            ["triggers"] = {
                ["MSBT_TRIGGER_KILL_SHOT"] = {
                    ["iconSkill"] = "53351",
                    ["fontSize"] = false,
                    ["scrollArea"] = "Custom1",
                },
                ["MSBT_TRIGGER_DECIMATION"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_ELUSIVE_BREW"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_BERSERK"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_SWORD_AND_BOARD"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_RIME"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_THE_ART_OF_WAR"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_VITAL_MISTS"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_FINGERS_OF_FROST"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_MANA_TEA"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_BLINDSIDE"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_EXECUTE"] = {
                    ["iconSkill"] = "5308",
                    ["fontSize"] = false,
                    ["scrollArea"] = "Custom1",
                },
                ["MSBT_TRIGGER_LOW_HEALTH"] = {
                    ["iconSkill"] = "3273",
                    ["fontSize"] = false,
                    ["scrollArea"] = "Custom1",
                },
                ["MSBT_TRIGGER_LOCK_AND_LOAD"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_TIDAL_WAVES"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_ULTIMATUM"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_PVP_TRINKET"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_LAVA_SURGE"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_SUDDEN_DEATH"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_LOW_PET_HEALTH"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_SHOOTING_STARS"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_BLOODSURGE"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_KILLING_MACHINE"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_BRAIN_FREEZE"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_MISSILE_BARRAGE"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_VICTORY_RUSH"] = {
                    ["fontSize"] = false,
                    ["iconSkill"] = "34428",
                    ["scrollArea"] = "Custom1",
                },
                ["MSBT_TRIGGER_SHADOW_INFUSION"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_CLEARCASTING"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_MAELSTROM_WEAPON"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_MOLTEN_CORE"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_NIGHTFALL"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_HAMMER_OF_WRATH"] = {
                    ["iconSkill"] = "24275",
                    ["fontSize"] = false,
                    ["scrollArea"] = "Custom1",
                },
                ["MSBT_TRIGGER_REVENGE"] = {
                    ["iconSkill"] = "6572",
                    ["fontSize"] = false,
                    ["scrollArea"] = "Custom1",
                },
                ["MSBT_TRIGGER_PREDATORS_SWIFTNESS"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_LOW_MANA"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
                ["MSBT_TRIGGER_TASTE_FOR_BLOOD"] = {
                    ["scrollArea"] = "Custom1",
                    ["fontSize"] = false,
                },
            },
        },
    };
    for k, v in pairs(settings) do
        MSBTProfiles_SavedVars.profiles[k] = v;
    end
end