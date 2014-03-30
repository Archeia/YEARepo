#==============================================================================
# 
# ▼ Yanfly Engine Ace - TP Manager v1.04
# -- Last Updated: 2012.01.30
# -- Level: Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-TPManager"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.30 - Bug Fixed: Notetags didn't unlock TP Mode 0.
#              Compatibility Update: Ace Battle Engine v1.19.
# 2012.01.02 - Compatibility Update: Ace Skill Menu
# 2011.12.10 - Added <tp cost: x> notetag.
# 2011.12.06 - Fixed an error in one of the formulas.
# 2011.12.05 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# The TP system in RPG Maker VX Ace is actually rather limiting. A lot of the
# system is hardcoded in giving Ace users very little control over how much TP
# gain a battler can receive from particular actions and situations. This
# script gives you the ability to adjust how much TP actors will acquire from
# various actions, different TP modes, and letting players select and pick what
# TP mode they want for each actor (akin to Final Fantasy X).
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Actor Notetags - These notetags go in the actors notebox in the database.
# -----------------------------------------------------------------------------
# <tp mode: x>
# This sets the actor's default TP mode to x. If this tag isn't used, the
# default TP mode will be set to whatever the module uses as default.
# 
# <unlock tp: x>
# <unlock tp: x, x>
# This unlocks what TP modes the actor can use by default. If this tag isn't
# used, the default unlocked TP modes will be whatever the module uses.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the item notebox in the database.
# -----------------------------------------------------------------------------
# <unlock tp: x>
# <unlock tp: x, x>
# When this item is used upon an actor, that actor will learn TP Mode(s) x,
# making it available to change in the TP Menu.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skill notebox in the database.
# -----------------------------------------------------------------------------
# <unlock tp: x>
# <unlock tp: x, x>
# When this skill targets an actor, that actor will learn TP Mode(s) x thus,
# making it available to change in the TP Menu.
# 
# <learn unlock tp: x>
# <learn unlock tp: x, x>
# When an actor learns a skill with this notetag, that actor will learn
# TP Mode(s) x making it available to change in the TP Menu.
# 
# <tp cost: x>
# When this notetag appears in a skill's notebox, the TP cost for that skill
# becomes x. This notetag allows TP costs to surpass 100 TP, which is the max
# TP cost in the RPG Maker VX Ace database editor.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemy notebox in the database.
# -----------------------------------------------------------------------------
# <tp mode: x>
# This sets the enemy's default TP mode to x. If this tag isn't used, the
# default TP mode will be set to whatever the module uses as default.
# 
# -----------------------------------------------------------------------------
# Script Calls - These commands are used with script calls.
# -----------------------------------------------------------------------------
# change_tp_mode(x, y)
# Replace x with the ID of the actor you want to change to the TP Mode y. This
# will also unlock the TP mode for the actor, and make it available under the
# skill menu for changing.
# 
# unlock_tp_mode(x, y)
# Replace x with the ID of the actor you want to learn for the TP Mode y. This
# will cause the actor to learn the TP mode and have it accessible in the skill
# menu for changing.
# 
# remove_tp_mode(x, y)
# Replace x with the ID of the actor you want to remove the TP Mode y. This
# will cause the actor to forget the TP mode and no longer have it accessible
# through the skill menu for changing.
# 
# unlock_all_tp_modes(x)
# Replace x with the ID of the actor you want to unlock all TP modes for. This
# will make all the TP modes available to the actor from the skill menu.
# 
# remove_all_tp_modes(x)
# Removes all TP modes for actor x except for the actor's default TP mode.
# This removes all TP modes from being available in the actor's skill menu.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module TP_MANAGER
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General TP Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Here, you can adjust global settings for TP including the maximum TP,
    # whether or not you want the player to change TP modes, and more.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    TP_LIMIT  = 100         # Sets the maximum TP. Default: 100
    DEFAULT_TP_MODE = 0            # This is the TP mode everybody starts with
                                   # unless changed through notetags.
    DEFAULT_UNLOCKS = [0, 1, 2, 3] # These modes are unlocked for all actors
                                   # unless changed through notetags.
    LOW_HP = 0.25           # Percent for what is considered low HP.
    LOW_MP = 0.25           # Percent for what is considered low MP.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - TP Mode Change Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust the settings here for TP Mode Menu related items. Also, be sure
    # to bind the TP_MODE_SWITCH to a switch ID. If that switch is on, the
    # TP Mode item will appear in the skill menu. If off, it won't appear.
    # If you set it to 0, then TP mode will always be enabled.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MENU_NAME = "TP Mode"   # The displayed name for the TP Menu.
    TP_MODE_SWITCH  = 0     # Switch ID used for enabling TP Mode menu.
    DEFAULT_ENABLE  = true  # Enable switch by default?
    CHANGE_TP_RESET = true  # Reset TP to 0 whenever a mode is changed?
    EQUIPPED_COLOUR = 17    # Window text colour used for equipped TP mode.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - TP Modes -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # TP modes have a number of things that can change the way actors gain TP.
    # Adjust the settings below to change how much gain and loss incurs per
    # each of the different actions.
    # 
    # Setting        Description
    # -------------------------------------------------------------------------
    # - :name        - Name that appears in the TP Mode menu.
    # - :icon        - Icon used for the TP Mode menu.
    # - :description - Help window description. Use \n for line breaks.
    # - :preserve_tp - Carry over TP from last battle to next battle?
    # - :init_tp     - TP at the start of each battle if no TP preservation.
    # - :regen_tp    - TP regenerated each turn. Uses a formula.
    # - :take_hp_dmg - TP charged by receiving HP damage. Uses a formula.
    # - :deal_hp_dmg - TP gained by dealing HP damage. Uses a formula.
    # - :heal_hp_dmg - TP gained through healing HP damage. Uses a formula.
    # - :ally_hp_dmg - TP gained when allies take HP damage. Uses a formula.
    # - :take_mp_dmg - TP charged by receiving MP damage. Uses a formula.
    # - :deal_mp_dmg - TP gained by dealing MP damage. Uses a formula.
    # - :heal_mp_dmg - TP gained through healing MP damage. Uses a formula.
    # - :ally_mp_dmg - TP gained when allies take MP damage. Uses a formula.
    # - :deal_state  - TP gained when user inflicts a state to a foe. Formula.
    # - :gain_state  - TP gained when user gains a state from a foe. Formula.
    # - :kill_ally   - TP gained when an ally is killed. Uses a formula.
    # - :kill_enemy  - TP gained when killing an enemy. Uses a formula.
    # - :win_battle  - TP gained whenever a battle is won. Uses a formula.
    # - :flee_battle - TP gained whenever party escapes. Uses a formula.
    # - :lose_battle - TP gained whenever a battle is lost. Uses a formula.
    # - :low_hp_turn - TP gained at the end of a turn with user at low HP.
    # - :low_mp_turn - TP gained at the end of a turn with user at low MP.
    # - :only_ally   - TP gained when user is only ally alive.
    # - :evasion     - TP gained when user evades an attack.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    TP_MODES ={ 
    # TP Mode => { Settings }
    # -------------------------------------------------------------------------
      0 => { # This is the default mode.
      # :setting     => Adjust settings as you see fit.
        :name        => "Stoic",
        :icon        => 121,
        :description => "Raise TP by waiting in battle or receiving damage " +
                        "from\nattacks.",
        :preserve_tp => false,
        :init_tp     => "rand * 25",
        :regen_tp    => "100 * trg",
        :take_hp_dmg => "50 * damage_rate * tcr",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "0",
        :deal_state  => "0",
        :gain_state  => "0",
        :kill_ally   => "0",
        :kill_enemy  => "0",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "0",
        :low_mp_turn => "0",
        :only_alive  => "0",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      1 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Comrade",
        :icon        => 122,
        :description => "Raise TP whenever allies take damage.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "20 * tcr",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "0",
        :deal_state  => "0",
        :gain_state  => "0",
        :kill_ally   => "0",
        :kill_enemy  => "0",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "0",
        :low_mp_turn => "0",
        :only_alive  => "0",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      2 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Warrior",
        :icon        => 116,
        :description => "Raise TP by attacking and dealing HP damage.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "[@result.hp_damage * 100 / mhp, 16].min * tcr",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "0",
        :deal_state  => "0",
        :gain_state  => "0",
        :kill_ally   => "0",
        :kill_enemy  => "0",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "0",
        :low_mp_turn => "0",
        :only_alive  => "0",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      3 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Healer",
        :icon        => 112,
        :description => "Raise TP by healing HP.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "[@result.hp_damage * -100 / mhp, 16].min * tcr",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "0",
        :deal_state  => "0",
        :gain_state  => "0",
        :kill_ally   => "0",
        :kill_enemy  => "0",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "0",
        :low_mp_turn => "0",
        :only_alive  => "0",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      4 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Breaker",
        :icon        => 215,
        :description => "Raise TP whenever user deals MP damage, receives MP " +
                        "damage,\nor an ally receives MP damage.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "50 * damage_rate * tcr",
        :deal_mp_dmg => "[@result.mp_damage / 4, 16].min * tcr",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "20 * tcr",
        :deal_state  => "0",
        :gain_state  => "0",
        :kill_ally   => "0",
        :kill_enemy  => "0",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "0",
        :low_mp_turn => "0",
        :only_alive  => "0",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      5 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Alchemist",
        :icon        => 193,
        :description => "Raise TP whenever user recovers MP to an ally.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "[@result.mp_damage / -4, 16].min * tcr",
        :ally_mp_dmg => "0",
        :deal_state  => "0",
        :gain_state  => "0",
        :kill_ally   => "0",
        :kill_enemy  => "0",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "0",
        :low_mp_turn => "0",
        :only_alive  => "0",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      6 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Slayer",
        :icon        => 115,
        :description => "Raise TP whenever an enemy is killed.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "0",
        :deal_state  => "0",
        :gain_state  => "0",
        :kill_ally   => "0",
        :kill_enemy  => "25 * tcr",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "0",
        :low_mp_turn => "0",
        :only_alive  => "0",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      7 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Avenger",
        :icon        => 1,
        :description => "Raise TP whenever an ally is killed.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "0",
        :deal_state  => "0",
        :gain_state  => "0",
        :kill_ally   => "50 * tcr",
        :kill_enemy  => "0",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "0",
        :low_mp_turn => "0",
        :only_alive  => "0",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      8 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Victor",
        :icon        => 113,
        :description => "Raise TP whenever your party defeat all enemies.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "0",
        :deal_state  => "0",
        :gain_state  => "0",
        :kill_ally   => "0",
        :kill_enemy  => "0",
        :win_battle  => "20 * tcr",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "0",
        :low_mp_turn => "0",
        :only_alive  => "0",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      9 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Coward",
        :icon        => 114,
        :description => "Raise TP whenever your party escapes from battle.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "0",
        :deal_state  => "0",
        :gain_state  => "0",
        :kill_ally   => "0",
        :kill_enemy  => "0",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "20 * tcr",
        :low_hp_turn => "0",
        :low_mp_turn => "0",
        :only_alive  => "0",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      10 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Daredevil",
        :icon        => 48,
        :description => "Raise TP whenever user ends a turn with low HP.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "0",
        :deal_state  => "0",
        :gain_state  => "0",
        :kill_ally   => "0",
        :kill_enemy  => "0",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "16 * tcr",
        :low_mp_turn => "0",
        :only_alive  => "0",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      11 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Caster",
        :icon        => 49,
        :description => "Raise TP whenever user ends a turn with low MP.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "0",
        :deal_state  => "0",
        :gain_state  => "0",
        :kill_ally   => "0",
        :kill_enemy  => "0",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "0",
        :low_mp_turn => "16 * tcr",
        :only_alive  => "0",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      12 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Tactician",
        :icon        => 10,
        :description => "Raise TP whenever user inflicts an ailment on a foe.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "0",
        :deal_state  => "16 * tcr",
        :gain_state  => "0",
        :kill_ally   => "0",
        :kill_enemy  => "0",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "0",
        :low_mp_turn => "0",
        :only_alive  => "0",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      13 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Sufferer",
        :icon        => 3,
        :description => "Raise TP whenever user receives an ailment from a foe.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "0",
        :deal_state  => "0",
        :gain_state  => "16 * tcr",
        :kill_ally   => "0",
        :kill_enemy  => "0",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "0",
        :low_mp_turn => "0",
        :only_alive  => "0",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      14 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Dancer",
        :icon        => 12,
        :description => "Raise TP whenever user successfully evades an attack.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "0",
        :deal_state  => "0",
        :gain_state  => "0",
        :kill_ally   => "0",
        :kill_enemy  => "0",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "0",
        :low_mp_turn => "0",
        :only_alive  => "0",
        :evasion     => "16 * tcr",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
      15 => { # New TP mode!
      # :setting     => Adjust settings as you see fit.
        :name        => "Loner",
        :icon        => 14,
        :description => "Raise TP whenever user is the last remaining member.",
        :preserve_tp => true,
        :init_tp     => "0",
        :regen_tp    => "0",
        :take_hp_dmg => "0",
        :deal_hp_dmg => "0",
        :heal_hp_dmg => "0",
        :ally_hp_dmg => "0",
        :take_mp_dmg => "0",
        :deal_mp_dmg => "0",
        :heal_mp_dmg => "0",
        :ally_mp_dmg => "0",
        :deal_state  => "0",
        :gain_state  => "0",
        :kill_ally   => "0",
        :kill_enemy  => "0",
        :win_battle  => "0",
        :flee_battle => "0",
        :lose_battle => "0",
        :low_hp_turn => "0",
        :low_mp_turn => "0",
        :only_alive  => "16 * tcr",
        :evasion     => "0",
      }, # Do not remove this.
    # -------------------------------------------------------------------------
    } # Do not remove this.
    
  end # TP_MANAGER
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module ACTOR
    
    TP_MODE   = /<(?:TP_MODE|tp mode):[ ](\d+)>/i
    UNLOCK_TP = /<(?:UNLOCK_TP|unlock tp):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
  end # ACTOR
  module ENEMY
    
    TP_MODE   = /<(?:TP_MODE|tp mode):[ ](\d+)>/i
    
  end # ENEMY
  module BASEITEM
    
    UNLOCK_TP = /<(?:UNLOCK_TP|unlock tp):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    LEARN_TP = /<(?:LEARN_UNLOCK_TP|learn unlock tp):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    TP_COST  = /<(?:TP_COST|tp cost):[ ](\d+)>/i
    
  end # BASEITEM
  end # REGEXP
end # YEA

#==============================================================================
# ■ Switch
#==============================================================================

module Switch
  
  #--------------------------------------------------------------------------
  # self.tp_mode
  #--------------------------------------------------------------------------
  def self.tp_mode
    return true if YEA::TP_MANAGER::TP_MODE_SWITCH <= 0
    return $game_switches[YEA::TP_MANAGER::TP_MODE_SWITCH]
  end
  
  #--------------------------------------------------------------------------
  # self.tp_mode_set
  #--------------------------------------------------------------------------
  def self.tp_mode_set(item)
    return if YEA::TP_MANAGER::TP_MODE_SWITCH <= 0
    $game_switches[YEA::TP_MANAGER::TP_MODE_SWITCH] = item
  end
    
end # Switch

#==============================================================================
# ■ Numeric
#==============================================================================

class Numeric
  
  #--------------------------------------------------------------------------
  # new method: group_digits
  #--------------------------------------------------------------------------
  unless $imported["YEA-CoreEngine"]
  def group; return self.to_s; end
  end # $imported["YEA-CoreEngine"]
    
end # Numeric

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_tpm load_database; end
  def self.load_database
    load_database_tpm
    load_notetags_tpm
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_tpm
  #--------------------------------------------------------------------------
  def self.load_notetags_tpm
    groups = [$data_actors, $data_enemies, $data_items, $data_skills]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_tpm
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: setup_new_game
  #--------------------------------------------------------------------------
  class <<self; alias setup_new_game_tpm setup_new_game; end
  def self.setup_new_game
    setup_new_game_tpm
    Switch.tp_mode_set(YEA::TP_MANAGER::DEFAULT_ENABLE)
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Actor
#==============================================================================

class RPG::Actor < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :tp_mode
  attr_accessor :unlocked_tp_modes
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_tpm
  #--------------------------------------------------------------------------
  def load_notetags_tpm
    @tp_mode = nil
    @unlocked_tp_modes = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ACTOR::TP_MODE
        @tp_mode = $1.to_i
      when YEA::REGEXP::ACTOR::UNLOCK_TP
        $1.scan(/\d+/).each { |num| 
        @unlocked_tp_modes.push(num.to_i) if num.to_i >= 0 }
      #---
      end
    } # self.note.split
    #---
    @tp_mode = YEA::TP_MANAGER::DEFAULT_TP_MODE if @tp_mode.nil?
    if @unlocked_tp_modes.empty?
      @unlocked_tp_modes = YEA::TP_MANAGER::DEFAULT_UNLOCKS.clone
    end
    @unlocked_tp_modes.push(@tp_mode) if !@unlocked_tp_modes.include?(@tp_mode)
    @unlocked_tp_modes.uniq!
    @unlocked_tp_modes.sort!
  end
  
end # RPG::Actor

#==============================================================================
# ■ RPG::Enemy
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :tp_mode
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_tpm
  #--------------------------------------------------------------------------
  def load_notetags_tpm
    @tp_mode = YEA::TP_MANAGER::DEFAULT_TP_MODE
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ENEMY::TP_MODE
        @tp_mode = $1.to_i
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Enemy

#==============================================================================
# ■ RPG::BaseItem
#==============================================================================

class RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :unlocked_tp_modes
  attr_accessor :learn_tp_modes
  attr_accessor :tp_cost
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_tpm
  #--------------------------------------------------------------------------
  def load_notetags_tpm
    @unlocked_tp_modes = []
    @learn_tp_modes = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::UNLOCK_TP
        $1.scan(/\d+/).each { |num| 
        @unlocked_tp_modes.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::BASEITEM::LEARN_TP
        $1.scan(/\d+/).each { |num| 
        @learn_tp_modes.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::BASEITEM::TP_COST
        next unless self.is_a?(RPG::Skill)
        @tp_cost = $1.to_i
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ BattleManager
#==============================================================================

module BattleManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias battle_end_tpm battle_end; end
  def self.battle_end(result)
    battle_end_tpm(result)
    case result
    when 0
      for member in $game_party.alive_members
        member.tp += eval(member.tp_setting(:win_battle))
      end
    when 1
      for member in $game_party.alive_members
        member.tp += eval(member.tp_setting(:flee_battle))
      end
    end
  end
  
end # BattleManager

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :tp_mode
  attr_accessor :unlocked_tp_modes
  
  #--------------------------------------------------------------------------
  # overwrite method: max_tp
  #--------------------------------------------------------------------------
  def max_tp; return YEA::TP_MANAGER::TP_LIMIT; end
  
  #--------------------------------------------------------------------------
  # anti-crash methods: max_tp, unlocked_tp_modes
  #--------------------------------------------------------------------------
  def tp_mode; return 0; end
  def unlocked_tp_modes; return [0]; end
  
  #--------------------------------------------------------------------------
  # new method: tp_setting
  #--------------------------------------------------------------------------
  def tp_setting(setting)
    return YEA::TP_MANAGER::TP_MODES[tp_mode][setting]
  end
  
  #--------------------------------------------------------------------------
  # alias method: preserve_tp?
  #--------------------------------------------------------------------------
  alias game_battlerbase_preserve_tp_tpm preserve_tp?
  def preserve_tp?
    return true if tp_setting(:preserve_tp)
    return game_battlerbase_preserve_tp_tpm
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # overwrite method: init_tp
  #--------------------------------------------------------------------------
  def init_tp
    self.tp = eval(tp_setting(:init_tp))
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: charge_tp_by_damage
  #--------------------------------------------------------------------------
  def charge_tp_by_damage(damage_rate)
    self.tp += eval(tp_setting(:take_hp_dmg))
  end
  
  #--------------------------------------------------------------------------
  # new method: charge_tp_by_mp_damage
  #--------------------------------------------------------------------------
  def charge_tp_by_mp_damage(damage_rate)
    self.tp += eval(tp_setting(:take_mp_dmg))
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: 
  #--------------------------------------------------------------------------
  def regenerate_tp
    self.tp += eval(tp_setting(:regen_tp))
    self.tp += eval(tp_setting(:low_hp_turn)) if self.hp < tp_low_hp
    self.tp += eval(tp_setting(:low_mp_turn)) if self.mp < tp_low_mp
    if friends_unit.alive_members.size == 1
      self.tp += eval(tp_setting(:only_alive))
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: tp_low_hp
  #--------------------------------------------------------------------------
  def tp_low_hp
    return self.mhp * YEA::TP_MANAGER::LOW_HP
  end
  
  #--------------------------------------------------------------------------
  # new method: tp_low_mp
  #--------------------------------------------------------------------------
  def tp_low_mp
    return self.mmp * YEA::TP_MANAGER::LOW_MP
  end
  
  #--------------------------------------------------------------------------
  # alias method: execute_damage
  #--------------------------------------------------------------------------
  alias game_battler_execute_damage_tpm execute_damage
  def execute_damage(user)
    game_battler_execute_damage_tpm(user)
    return unless $game_party.in_battle
    @result.restore_damage if $imported["YEA-BattleEngine"]
    if @result.hp_damage > 0
      user.tp += eval(user.tp_setting(:deal_hp_dmg))
      gain_tp_ally_hp_damage
    elsif @result.hp_damage < 0
      user.tp += eval(user.tp_setting(:heal_hp_dmg))
    end
    if @result.mp_damage > 0
      user.tp += eval(user.tp_setting(:deal_mp_dmg))
      gain_tp_ally_mp_damage
      charge_tp_by_mp_damage(@result.mp_damage)
    elsif @result.mp_damage < 0
      user.tp += eval(user.tp_setting(:heal_mp_dmg))
    end
    user.tp += eval(user.tp_setting(:kill_enemy)) if self.hp == 0
    gain_tp_kill_ally if self.hp == 0
    return unless $imported["YEA-BattleEngine"]
    @result.store_damage
    @result.clear_damage_values
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_effect_recover_hp
  #--------------------------------------------------------------------------
  alias game_battler_item_effect_recover_hp_tpm item_effect_recover_hp
  def item_effect_recover_hp(user, item, effect)
    game_battler_item_effect_recover_hp_tpm(user, item, effect)
    return unless $game_party.in_battle
    @result.restore_damage if $imported["YEA-BattleEngine"]
    if @result.hp_damage > 0
      user.tp += eval(user.tp_setting(:deal_hp_dmg))
      gain_tp_ally_hp_damage
    elsif @result.hp_damage < 0
      user.tp += eval(user.tp_setting(:heal_hp_dmg))
    end
    return unless $imported["YEA-BattleEngine"]
    @result.store_damage
    @result.clear_damage_values
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_effect_recover_mp
  #--------------------------------------------------------------------------
  alias game_battler_item_effect_recover_mp_tpm item_effect_recover_mp
  def item_effect_recover_mp(user, item, effect)
    game_battler_item_effect_recover_mp_tpm(user, item, effect)
    return unless $game_party.in_battle
    @result.restore_damage if $imported["YEA-BattleEngine"]
    if @result.mp_damage > 0
      user.tp += eval(user.tp_setting(:deal_mp_dmg))
      gain_tp_ally_mp_damage
      charge_tp_by_mp_damage(@result.mp_damage)
    elsif @result.mp_damage < 0
      user.tp += eval(user.tp_setting(:heal_mp_dmg))
    end
    return unless $imported["YEA-BattleEngine"]
    @result.store_damage
    @result.clear_damage_values
  end
  
  #--------------------------------------------------------------------------
  # new method: gain_tp_ally_hp_damage
  #--------------------------------------------------------------------------
  def gain_tp_ally_hp_damage
    for member in friends_unit.alive_members
      next if member == self
      member.tp += eval(member.tp_setting(:ally_hp_dmg))
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: gain_tp_ally_mp_damage
  #--------------------------------------------------------------------------
  def gain_tp_ally_mp_damage
    for member in friends_unit.alive_members
      next if member == self
      member.tp += eval(member.tp_setting(:ally_mp_dmg))
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: gain_tp_kill_ally
  #--------------------------------------------------------------------------
  def gain_tp_kill_ally
    for member in friends_unit.alive_members
      next if member == self
      member.tp += eval(member.tp_setting(:kill_ally))
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_effect_add_state
  #--------------------------------------------------------------------------
  alias game_battler_item_effect_add_state_tpm item_effect_add_state
  def item_effect_add_state(user, item, effect)
    original_states = states.clone
    game_battler_item_effect_add_state_tpm(user, item, effect)
    return unless $game_party.in_battle
    if original_states != states && opponents_unit.members.include?(user)
      user.tp += eval(user.tp_setting(:deal_state))
      self.tp += eval(tp_setting(:gain_state))
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_apply
  #--------------------------------------------------------------------------
  alias game_battler_item_apply_tpm item_apply
  def item_apply(user, item)
    game_battler_item_apply_tpm(user, item)
    return unless $game_party.in_battle
    return if @result.hit?
    self.tp += eval(tp_setting(:evasion))
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_test
  #--------------------------------------------------------------------------
  alias game_battler_item_test_tpm item_test
  def item_test(user, item)
    return false if item.for_dead_friend? != dead?
    return true if item.unlocked_tp_modes.size > 0
    return game_battler_item_test_tpm(user, item)
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_user_effect
  #--------------------------------------------------------------------------
  alias game_battler_item_user_effect_tpm item_user_effect
  def item_user_effect(user, item)
    game_battler_item_user_effect_tpm(user, item)
    return unless actor?
    for mode in item.unlocked_tp_modes
      unlock_tp_mode(mode)
    end
  end
  
end # Game_Battler

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: setup
  #--------------------------------------------------------------------------
  alias game_actor_setup_tpm setup
  def setup(actor_id)
    game_actor_setup_tpm(actor_id)
    @tp_mode = actor.tp_mode
    @unlocked_tp_modes = actor.unlocked_tp_modes.clone
  end
  
  #--------------------------------------------------------------------------
  # new method: tp_mode
  #--------------------------------------------------------------------------
  def tp_mode
    @tp_mode = actor.tp_mode if @tp_mode.nil?
    return @tp_mode
  end
  
  #--------------------------------------------------------------------------
  # new method: unlocked_tp_modes
  #--------------------------------------------------------------------------
  def unlocked_tp_modes
    if @unlocked_tp_modes.empty?
      @unlocked_tp_modes = actor.unlocked_tp_modes.clone
    end
    return @unlocked_tp_modes.uniq
  end
  
  #--------------------------------------------------------------------------
  # new method: change_tp_mode
  #--------------------------------------------------------------------------
  def change_tp_mode(mode)
    @tp_mode = mode
    unlock_tp_mode(mode)
    self.tp = 0 if YEA::TP_MANAGER::CHANGE_TP_RESET
  end
  
  #--------------------------------------------------------------------------
  # new method: unlock_tp_mode
  #--------------------------------------------------------------------------
  def unlock_tp_mode(mode)
    if @unlocked_tp_modes.empty?
      @unlocked_tp_modes = actor.unlocked_tp_modes.clone
    end
    @unlocked_tp_modes.push(mode)
    @unlocked_tp_modes.uniq!
    @unlocked_tp_modes.sort!
  end
  
  #--------------------------------------------------------------------------
  # new method: remove_tp_mode
  #--------------------------------------------------------------------------
  def remove_tp_mode(mode)
    if @unlocked_tp_modes.empty?
      @unlocked_tp_modes = actor.unlocked_tp_modes.clone
    end
    @unlocked_tp_modes.delete(mode)
    @tp_mode = @unlocked_tp_modes[0] if @tp_mode == mode
  end
  
  #--------------------------------------------------------------------------
  # alias method: learn_skill
  #--------------------------------------------------------------------------
  alias game_actor_learn_skill_tpm learn_skill
  def learn_skill(skill_id)
    game_actor_learn_skill_tpm(skill_id)
    for mode in $data_skills[skill_id].learn_tp_modes
      unlock_tp_mode(mode)
    end
  end
  
end # Game_Actor

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: tp_mode
  #--------------------------------------------------------------------------
  def tp_mode; return enemy.tp_mode; end
  
end # Game_Enemy
  
#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # new method: change_tp_mode
  #--------------------------------------------------------------------------
  def change_tp_mode(actor_id, mode)
    $game_actors[actor_id].change_tp_mode(mode)
  end
  
  #--------------------------------------------------------------------------
  # new method: unlock_tp_mode
  #--------------------------------------------------------------------------
  def unlock_tp_mode(actor_id, mode)
    $game_actors[actor_id].unlock_tp_mode(mode)
  end
  
  #--------------------------------------------------------------------------
  # new method: remove_tp_mode
  #--------------------------------------------------------------------------
  def remove_tp_mode(actor_id, mode)
    $game_actors[actor_id].remove_tp_mode(mode)
  end
  
  #--------------------------------------------------------------------------
  # new method: unlock_all_tp_modes
  #--------------------------------------------------------------------------
  def unlock_all_tp_modes(actor_id)
    for key in YEA::TP_MANAGER::TP_MODES
      $game_actors[actor_id].unlock_tp_mode(key[0])
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: remove_all_tp_modes
  #--------------------------------------------------------------------------
  def remove_all_tp_modes(actor_id)
    for key in YEA::TP_MANAGER::TP_MODES
      next if key[0] == $data_actors[actor_id].tp_mode
      $game_actors[actor_id].remove_tp_mode(key[0])
    end
  end
  
end # Game_Interpreter

#==============================================================================
# ■ Window_SkillCommand
#==============================================================================

class Window_SkillCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # alias method: make_command_list
  #--------------------------------------------------------------------------
  alias window_skillcommand_make_command_list_tpm make_command_list
  def make_command_list
    return unless @actor
    window_skillcommand_make_command_list_tpm
    return if $imported["YEA-SkillMenu"]
    add_tp_modes
  end
  
  #--------------------------------------------------------------------------
  # new method: add_tp_modes
  #--------------------------------------------------------------------------
  def add_tp_modes
    return unless Switch.tp_mode
    return unless SceneManager.scene_is?(Scene_Skill)
    add_command(YEA::TP_MANAGER::MENU_NAME, :tp_mode, true, :tp_mode)
  end
  
end # Window_SkillCommand

#==============================================================================
# ■ Window_SkillList
#==============================================================================

class Window_SkillList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # new method: tp_mode?
  #--------------------------------------------------------------------------
  def tp_mode?; return @stype_id == :tp_mode; end
  
  #--------------------------------------------------------------------------
  # new method: tp_mode
  #--------------------------------------------------------------------------
  def tp_mode
    return nil unless tp_mode?
    return @data[index]
  end
  
  #--------------------------------------------------------------------------
  # alias method: make_item_list
  #--------------------------------------------------------------------------
  alias window_skilllist_make_item_list_tpm make_item_list
  def make_item_list
    if tp_mode?
      @data = @actor.unlocked_tp_modes
      @data.sort!
    else
      window_skilllist_make_item_list_tpm
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: draw_item
  #--------------------------------------------------------------------------
  alias window_skilllist_draw_item_tpm draw_item
  def draw_item(index)
    if tp_mode?
      draw_tp_mode_item(index)
    else
      window_skilllist_draw_item_tpm(index)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_tp_mode_item
  #--------------------------------------------------------------------------
  def draw_tp_mode_item(index)
    tp_mode = @data[index]
    return unless YEA::TP_MANAGER::TP_MODES.include?(tp_mode)
    rect = item_rect(index)
    rect.width -= 4
    icon = YEA::TP_MANAGER::TP_MODES[tp_mode][:icon]
    draw_icon(icon, rect.x, rect.y)
    change_color(tp_mode_colour(tp_mode))
    name = YEA::TP_MANAGER::TP_MODES[tp_mode][:name]
    draw_text(rect.x+24, rect.y, rect.width-24, line_height, name)
  end
  
  #--------------------------------------------------------------------------
  # new method: tp_mode_colour
  #--------------------------------------------------------------------------
  def tp_mode_colour(mode)
    if @actor.tp_mode == mode
      return text_color(YEA::TP_MANAGER::EQUIPPED_COLOUR)
    else
      return normal_color
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: current_item_enabled?
  #--------------------------------------------------------------------------
  alias window_skilllist_current_item_enabled current_item_enabled?
  def current_item_enabled?
    if tp_mode?
      return @actor.tp_mode != @data[index]
    else
      return window_skilllist_current_item_enabled
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_help
  #--------------------------------------------------------------------------
  alias window_skilllist_update_help_tpm update_help
  def update_help
    if tp_mode?
      tp_mode = @data[index]
      if YEA::TP_MANAGER::TP_MODES.include?(tp_mode)
        text = YEA::TP_MANAGER::TP_MODES[tp_mode][:description]
      else
        text = ""
      end
      @help_window.set_text(text)
    else
      window_skilllist_update_help_tpm
    end
  end
  
end # Window_SkillList

#==============================================================================
# ■ Scene_Skill
#==============================================================================

class Scene_Skill < Scene_ItemBase
  
  #--------------------------------------------------------------------------
  # alias method: create_command_window
  #--------------------------------------------------------------------------
  alias scene_skill_create_command_window_tpm create_command_window
  def create_command_window
    scene_skill_create_command_window_tpm
    @command_window.set_handler(:tp_mode,    method(:command_skill))
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_item_ok
  #--------------------------------------------------------------------------
  alias scene_skill_on_item_ok_tpm on_item_ok
  def on_item_ok
    if @item_window.tp_mode?
      Sound.play_equip
      user.change_tp_mode(@item_window.tp_mode)
      @status_window.refresh
      @item_window.refresh
      @item_window.activate
    else
      scene_skill_on_item_ok_tpm
    end
  end
  
end # Scene_Skill

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================