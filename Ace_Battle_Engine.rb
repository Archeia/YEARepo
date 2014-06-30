#==============================================================================
# 
# Å• Yanfly Engine Ace - Ace Battle Engine v1.22
# -- Last Updated: 2012.03.04
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-BattleEngine"] = true

#==============================================================================
# Å• Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.03.04 - Bug fixed: Input crash bug.
# 2012.02.13 - Bug fixed: Odd Victory game crash fixed.
# 2012.02.12 - Bug fixed: Displayed damage in combat log is correct now.
# 2012.01.29 - Visual Changes: Buff stacks now show one popup upon one skill.
# 2012.01.24 - Compatibility Update: Enemy Levels
# 2012.01.18 - Bug Fixed: Help Window clears text upon selecting nil items.
# 2012.01.11 - Added <one animation> tag for multi-hit skills to play an
#              animation only once.
#            - Reduced lag from battle system constantly recreating bitmaps.
# 2012.01.10 - Compatibility Update: Battle System FTB
# 2012.01.09 - Anticrash methods implemented.
#            - Damage Popups are now separate for damage formulas and recovery.
# 2012.01.05 - Bug fixed: Game no longer crashes with escape skills/items.
# 2012.01.02 - Compatibility Update: Target Manager
#            - Added Option: AUTO_FAST
#            - Random hits now show animations individually.
# 2011.12.30 - Compatibility Update: Enemy Levels
#            - Added Option to center the actors in the HUD.
# 2011.12.27 - Bug fixed: TP Damage skills and items no longer crash game.
#            - Default battle system bug fixes are now included from YEA's Ace
#              Core Engine.
#            - Groundwork is also made to support future battle system types.
#            - Multi-hit actions no longer linger when a target dies during the
#              middle of one of the hits.
#            - Compatibility Update: Lunatic Objects v1.02
# 2011.12.26 - Bug fixed: Multi-hit popups occured even after an enemy's dead.
# 2011.12.22 - Bug fixed: Elemental Resistance popup didn't show.
# 2011.12.20 - Bug fixed: Death state popups against immortal states.
#            - Bug fixed: During State popup fix.
#            - Added HIDE_POPUP_SWITCH.
# 2011.12.17 - Compatibiilty Update: Cast Animations
# 2011.12.15 - Compatibility Update: Battle Command List
# 2011.12.14 - Compatibility Update: Lunatic Objects
# 2011.12.13 - Compatibility Update: Command Party
# 2011.12.12 - Bug fixed: Turn stalling if no inputable members.
# 2011.12.10 - Compatibility update for Automatic Party HUD.
#            - Popup graphical bug fixed.
#            - Bug fixed: Didn't wait for boss dead animations.
#            - Bug fixed: Surprise attacks that froze the game.
#            - Bug fixed: Popups didn't show for straight recovery effects.
# 2011.12.08 - Finished Script.
# 2011.12.04 - Started Script.
# 
#==============================================================================
# Å• Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Ace Battle Engine works as a foundation for future battle engine add-ons. It
# allows for easier management of the battle engine without adding too many
# features, allowing users to customize what they want as they see fit. While
# the Ace Battle Engine isn't an entirely new engine, it gives users control
# that RPG Maker VX Ace didn't originally give them.
# 
# Furthermore, this script provides some new features. They are as follows:
# 
# -----------------------------------------------------------------------------
# Animation Fixes
# -----------------------------------------------------------------------------
# Though the Yanfly Engine Ace - Ace Core Engine script contains these fixes,
# these fixes are included in this script as well to ensure it's working for
# the battle script in the event someone chooses not to work with the Ace Core
# Engine script. The animation fixes prevent excessive animation overlaying
# (and making the screen look really ugly) and prevents animation clashing
# between two dual wielding normal attack animations.
# 
# -----------------------------------------------------------------------------
# Enemy Animations
# -----------------------------------------------------------------------------
# Enemies now show battle animations when they deliver attacks and skills
# against the player's party. Before in RPG Maker VX Ace, it was nothing more
# than just sound effects and the screen shaking. Now, animations play where
# the status window is and relative to the position of each party member.
# 
# -----------------------------------------------------------------------------
# Left/Right Command Selection
# -----------------------------------------------------------------------------
# While choosing actions, the player can press Left or Right to move freely
# between (alive) actors to change their skills. Players no longer have to
# cancel all the way back to change one person's skill and reselect everything.
# On that note, there is now the option that when a battle starts or at the
# end of a turn, players will start immediately at command selection rather
# than needing to select "Fight" in the Party Command Window.
# 
# -----------------------------------------------------------------------------
# Popups
# -----------------------------------------------------------------------------
# Dealing damage, inflicting states, adding buffs, landing critical hits,
# striking weaknesses, missing attacks, you name it, there's probably a popup
# for it. Popups deliver information to the player in a quick or orderly
# fashion without requiring the player to read lines of text.
# 
# -----------------------------------------------------------------------------
# Targeting Window
# -----------------------------------------------------------------------------
# When targeting enemies, the window is no longer displayed. Instead, the
# targeted enemies are highlighted and their names are shown at the top of the
# screen in a help window. Another thing that's changed is when skills that
# target multiple targets are selected, there is a confirmation step that the
# player must take before continuing. In this confirmation step, all of the
# multiple targets are selected and in the help window would display the scope
# of the skill (such as "All Foes" or "Random Foes"). RPG Maker VX Ace skipped
# this step by default.
# 
# -----------------------------------------------------------------------------
# Toggling On and Off Special Effects and Text
# -----------------------------------------------------------------------------
# Not everybody likes having the screen shake or the enemies blink when they
# take damage. These effects can now be toggled on and off. Certain text can
# also be toggled on and off from appearing. A lot of the displayed text has
# been rendered redundant through the use of popups.
# 
# -----------------------------------------------------------------------------
# Visual Battle Status Window
# -----------------------------------------------------------------------------
# Rather than just having rows of names with HP and MP bars next to them, the
# Battle Status Window now displays actors' faces and their gauges aligned at
# the bottom. More status effects can be shown in addition to showing more
# members on screen at once. The Battle Status Window is also optimized to
# refresh less (thus, removing potential lag from the system).
# 
# -----------------------------------------------------------------------------
# Window Position Changes
# -----------------------------------------------------------------------------
# Windows such as the Skill Window and Item Window have been rearranged to
# always provide the player a clear view of the battlefield rather than opening
# up and covering everything. As such, the window positions are placed at the
# bottom of the screen and are repositioned.
# 
#==============================================================================
# Å• Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below Å• Materials/ëfçﬁ but above Å• Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <one animation>
# Causes the action to display the action animation only once, even if it's a
# multi-hit action. This is used primarily for non-all scope targeting.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <one animation>
# Causes the action to display the action animation only once, even if it's a
# multi-hit action. This is used primarily for non-all scope targeting.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemy notebox in the database.
# -----------------------------------------------------------------------------
# <atk ani 1: x>
# <atk ani 2: x>
# Changes the normal attack animation of the particular enemy to animation x.
# Attack animation 1 is the first one that plays. If there's a second animation
# then the second one will play after in mirrored form.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the state notebox in the database.
# -----------------------------------------------------------------------------
# <popup add: string>
# <popup rem: string>
# <popup dur: string>
# Status effects now create popups whenever they're inflicted. However, if you
# don't like that a certain status effect uses a particular colour setting,
# change "string" to one of the rulesets below to cause that popup to use a
# different ruleset.
# 
# <popup hide add>
# <popup hide rem>
# <popup hide dur>
# Not everybody wants status effects to show popups when inflicted. When this
# is the case, insert the respective tag to hide popups from appearing when the
# state is added, removed, or during the stand-by phases.
# 
# -----------------------------------------------------------------------------
# Debug Tools - These tools only work during Test Play.
# -----------------------------------------------------------------------------
# - F5 Key -
# Recovers all actors. Restores their HP and MP to max. Does not affect TP.
# All states and buffs are removed whether they are positive or negative.
# 
# - F6 Key -
# Sets all actors to have 1 HP, 0 MP, and 0 TP. States are unaffected.
# 
# - F7 Key -
# Sets all actors to have max TP. Everything else is unaffected.
# 
# - F8 Key -
# Kills all enemies in battle. Ends the battle quickly.
# 
#==============================================================================
# Å• Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module BATTLE
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Battle Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings are adjusted for the overall battle system. These are
    # various miscellaneous options to adjust. Each of the settings below will
    # explain what they do. Change default enemy battle animations here, too.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    BLINK_EFFECTS      = false  # Blink sprite when damaged?
    FLASH_WHITE_EFFECT = true   # Flash enemy white when it starts an attack.
    SCREEN_SHAKE       = false  # Shake screen in battle?
    SKIP_PARTY_COMMAND = true   # Skips the Fight/Escape menu.
    AUTO_FAST          = true   # Causes message windows to not wait.
    ENEMY_ATK_ANI      = 36     # Sets default attack animation for enemies.
    
    # If this switch is ON, popups will be hidden. If OFF, the popups will be
    # shown. If you do not wish to use this switch, set it to 0.
    HIDE_POPUP_SWITCH  = 0
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Battle Status Window -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This sets the default battle system your game will use. If your game
    # doesn't have any other battle systems installed, it will use :dtb.
    # 
    # Battle System        Requirement
    #   :dtb               - Default Turn Battle. Default system.
    #   :ftb               - YEA Battle System Add-On: Free Turn Battle
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_BATTLE_SYSTEM = :dtb     # Default battle system set.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Battle Status Window -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Here, you can adjust the settings for the battle status window. The
    # battle status window, by default, will show the actor's face, HP, MP, TP
    # (if viable), and any inflicted status effects.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    BATTLESTATUS_NAME_FONT_SIZE = 20    # Font size used for name.
    BATTLESTATUS_TEXT_FONT_SIZE = 16    # Font size used for HP, MP, TP.
    BATTLESTATUS_NO_ACTION_ICON = 185   # No action icon.
    BATTLESTATUS_HPGAUGE_Y_PLUS = 11    # Y Location buffer used for HP gauge.
    BATTLESTATUS_CENTER_FACES   = false # Center faces for the Battle Status.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Help Window Text -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # When selecting a target to attack, this is the text that will be shown
    # in place of a target's name for special cases. These special cases are
    # for selections that were originally non-targetable battle scopes.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    HELP_TEXT_ALL_FOES        = "All Foes"
    HELP_TEXT_ONE_RANDOM_FOE  = "One Random Foe"
    HELP_TEXT_MANY_RANDOM_FOE = "%d Random Foes"
    HELP_TEXT_ALL_ALLIES      = "All Allies"
    HELP_TEXT_ALL_DEAD_ALLIES = "All Dead Allies"
    HELP_TEXT_ONE_RANDOM_ALLY = "One Random Ally"
    HELP_TEXT_RANDOM_ALLIES   = "%d Random Allies"
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Popup Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings will adjust the popups that appear in battle. Popups
    # deliver information to your player as battlers deal damage, inflict
    # status effects, and more.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    ENABLE_POPUPS  = true     # Set this to false if you wish to disable them.
    FLASH_CRITICAL = true     # Sets critical hits to flash.
    
    # This hash adjusts the popup settings that will govern how popups appear.
    # Adjust them accordingly.
    POPUP_SETTINGS ={
      :offset     => -24,         # Height offset of a popup.
      :fade       => 12,          # Fade rate for each popup.
      :full       => 60,          # Frames before a popup fades.
      :hp_dmg     => "-%s ",      # SprintF for HP damage.
      :hp_heal    => "+%s ",      # SprintF for HP healing.
      :mp_dmg     => "-%s MP",    # SprintF for MP damage.
      :mp_heal    => "+%s MP",    # SprintF for MP healing.
      :tp_dmg     => "-%s TP",    # SprintF for MP damage.
      :tp_heal    => "+%s TP",    # SprintF for MP healing.
      :drained    => "DRAIN",     # Text display for draining HP/MP.
      :critical   => "CRITICAL!", # Text display for critical hit.
      :missed     => "MISS",      # Text display for missed attack.
      :evaded     => "EVADE!",    # Text display for evaded attack.
      :nulled     => "NULL",      # Text display for nulled attack.
      :failed     => "FAILED",    # Text display for a failed attack.
      :add_state  => "+%s",      # SprintF for added states.
      :rem_state  => "-%s",      # SprintF for removed states.
      :dur_state  => "%s",        # SprintF for during states.
      :ele_rates  => true,        # This will display elemental affinities.
      :ele_wait   => 20,          # This is how many frames will wait.
      :weakpoint  => "WEAKPOINT", # Appears if foe is weak to element.
      :resistant  => "RESIST",    # Appears if foe is resistant to element.
      :immune     => "IMMUNE",    # Appears if foe is immune to element.
      :absorbed   => "ABSORB",    # Appears if foe can absorb the element.
      :add_buff   => "%sÅ{",      # Appears when a positive buff is applied.
      :add_debuff => "%sÅ|",      # Appears when a negative buff is applied.
    } # Do not remove this.
    
    # This is the default font used for the popups. Adjust them accordingly
    # or even add new ones.
    DEFAULT = ["VL Gothic", "Verdana", "Arial", "Courier"]
    
    # The following are the various rules that govern the individual popup
    # types that will appear. Adjust them accordingly. Here is a list of what
    # each category does.
    #   Zoom1    The zoom the popup starts at. Values over 2.0 may cause lag.
    #   Zoom2    The zoom the popup goes to. Values over 2.0 may cause lag.
    #   Sz       The font size used for the popup text.
    #   Bold     Applying bold for the popup text.
    #   Italic   Applying italic for the popup text.
    #   Red      The red value of the popup text.
    #   Grn      The green value of the popup text.
    #   Blu      The blue value of the popup text.
    #   Font     The font used for the popup text.
    POPUP_RULES ={
      # Type     => [ Zoom1, Zoom2, Sz, Bold, Italic, Red, Grn, Blu, Font]
      "DEFAULT"  => [   2.0,   1.0, 24, true,  false, 255, 255, 255, DEFAULT],
      "CRITICAL" => [   2.0,   1.0, 24, true,  false, 255,  80,  80, DEFAULT], 
      "HP_DMG"   => [   2.0,   1.0, 36, true,  false, 255, 255, 255, DEFAULT], 
      "HP_HEAL"  => [   2.0,   1.0, 36, true,  false, 130, 250, 130, DEFAULT], 
      "MP_DMG"   => [   2.0,   1.0, 36, true,  false, 220, 180, 255, DEFAULT], 
      "MP_HEAL"  => [   2.0,   1.0, 36, true,  false, 160, 230, 255, DEFAULT], 
      "TP_DMG"   => [   2.0,   1.0, 36, true,  false, 242, 108,  78, DEFAULT], 
      "TP_HEAL"  => [   2.0,   1.0, 36, true,  false, 251, 175,  92, DEFAULT], 
      "ADDSTATE" => [   2.0,   1.0, 24, true,  false, 240, 100, 100, DEFAULT], 
      "REMSTATE" => [   2.0,   1.0, 24, true,  false, 125, 170, 225, DEFAULT], 
      "DURSTATE" => [   2.0,   1.0, 24, true,  false, 255, 240, 150, DEFAULT], 
      "DRAIN"    => [   2.0,   1.0, 36, true,  false, 250, 190, 255, DEFAULT], 
      "POSITIVE" => [   2.0,   1.0, 24, true,  false, 110, 210, 245, DEFAULT], 
      "NEGATIVE" => [   2.0,   1.0, 24, true,  false, 245, 155, 195, DEFAULT], 
      "WEAK_ELE" => [   0.5,   1.0, 24, true,  false, 240, 110,  80, DEFAULT], 
      "IMMU_ELE" => [   0.5,   1.0, 24, true,  false, 185, 235, 255, DEFAULT], 
      "REST_ELE" => [   0.5,   1.0, 24, true,  false, 145, 230, 180, DEFAULT], 
      "ABSB_ELE" => [   0.5,   1.0, 24, true,  false, 250, 190, 255, DEFAULT], 
      "BUFF"     => [   2.0,   1.0, 24, true,  false, 255, 240, 100, DEFAULT], 
      "DEBUFF"   => [   2.0,   1.0, 24, true,  false, 160, 130, 200, DEFAULT], 
    } # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Streamlined Messages -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Want to remove some of those annoying messages that appear all the time?
    # Now you can! Select which messages you want to enable or disable. Some of
    # these messages will be rendered useless due to popups.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MSG_ENEMY_APPEARS  = false  # Message when enemy appears start of battle.
    MSG_CURRENT_STATE  = false  # Show which states has affected battler.
    MSG_CURRENT_ACTION = true   # Show the current action of the battler.
    MSG_COUNTERATTACK  = true   # Show the message for a counterattack.
    MSG_REFLECT_MAGIC  = true   # Show message for reflecting magic attacks.
    MSG_SUBSTITUTE_HIT = true   # Show message for ally taking another's hit.
    MSG_FAILURE_HIT    = false  # Show effect failed against target.
    MSG_CRITICAL_HIT   = false  # Show attack was a critical hit.
    MSG_HIT_MISSED     = false  # Show attack missed the target.
    MSG_EVASION        = false  # Show attack was evaded by the target.
    MSG_HP_DAMAGE      = false  # Show HP damage to target.
    MSG_MP_DAMAGE      = false  # Show MP damage to target.
    MSG_TP_DAMAGE      = false  # Show TP damage to target.
    MSG_ADDED_STATES   = false  # Show target's added states.
    MSG_REMOVED_STATES = false  # Show target's removed states.
    MSG_CHANGED_BUFFS  = false  # Show target's changed buffs.
    
  end # BATTLE
end # YEA

#==============================================================================
# Å• Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module ENEMY
    
    ATK_ANI1 = /<(?:ATK_ANI_1|atk ani 1):[ ]*(\d+)>/i
    ATK_ANI2 = /<(?:ATK_ANI_2|atk ani 2):[ ]*(\d+)>/i
    
  end # ENEMY
  module USABLEITEM
    
    ONE_ANIMATION = /<(?:ONE_ANIMATION|one animation)>/i
    
  end # USABLEITEM
  module STATE
    
    POPUP_ADD = /<(?:POPUP_ADD_RULE|popup add rule|popup add):[ ](.*)>/i
    POPUP_REM = /<(?:POPUP_REM_RULE|popup rem rule|popup rem):[ ](.*)>/i
    POPUP_DUR = /<(?:POPUP_DUR_RULE|popup dur rule|popup dur):[ ](.*)>/i
    
    HIDE_ADD  = /<(?:POPUP_HIDE_ADD|popup hide add|hide add)>/i
    HIDE_REM  = /<(?:POPUP_HIDE_REM|popup hide rem|hide rem)>/i
    HIDE_DUR  = /<(?:POPUP_HIDE_DUR|popup hide dur|hide dur)>/i
    
  end # STATE
  end # REGEXP
end # YEA

#==============================================================================
# Å° Switch
#==============================================================================

module Switch
  
  #--------------------------------------------------------------------------
  # self.hide_popups
  #--------------------------------------------------------------------------
  def self.hide_popups
    return false if YEA::BATTLE::HIDE_POPUP_SWITCH <= 0
    return $game_switches[YEA::BATTLE::HIDE_POPUP_SWITCH]
  end
  
end # Switch

#==============================================================================
# Å° Colour
#==============================================================================

module Colour
  
  #--------------------------------------------------------------------------
  # self.text_colour
  #--------------------------------------------------------------------------
  def self.text_colour(index)
    windowskin = Cache.system("Window")
    x = 64 + (index % 8) * 8
    y = 96 + (index / 8) * 8
    return windowskin.get_pixel(x, y)
  end
  
end # Colour

#==============================================================================
# Å° Icon
#==============================================================================

module Icon
  
  #--------------------------------------------------------------------------
  # self.no_action
  #--------------------------------------------------------------------------
  def self.no_action; return YEA::BATTLE::BATTLESTATUS_NO_ACTION_ICON; end
    
end # Icon

#==============================================================================
# Å° Numeric
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
# Å° DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_abe load_database; end
  def self.load_database
    load_database_abe
    load_notetags_abe
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_abe
  #--------------------------------------------------------------------------
  def self.load_notetags_abe
    groups = [$data_enemies, $data_states, $data_skills, $data_items]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_abe
      end
    end
  end
  
end # DataManager

#==============================================================================
# Å° RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :one_animation
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_abe
  #--------------------------------------------------------------------------
  def load_notetags_abe
    @one_animation = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::ONE_ANIMATION
        @one_animation = true
      end
    } # self.note.split
    #---
  end
  
end # RPG::UsableItem

#==============================================================================
# Å° RPG::Enemy
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :atk_animation_id1
  attr_accessor :atk_animation_id2
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_abe
  #--------------------------------------------------------------------------
  def load_notetags_abe
    @atk_animation_id1 = YEA::BATTLE::ENEMY_ATK_ANI
    @atk_animation_id2 = 0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ENEMY::ATK_ANI1
        @atk_animation_id1 = $1.to_i
      when YEA::REGEXP::ENEMY::ATK_ANI2
        @atk_animation_id2 = $1.to_i
      end
    } # self.note.split
    #---
  end
  
end # RPG::Enemy

#==============================================================================
# Å° RPG::Enemy
#==============================================================================

class RPG::State < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :popup_rules
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_abe
  #--------------------------------------------------------------------------
  def load_notetags_abe
    @popup_rules = { 
      :add_state => "ADDSTATE", 
      :rem_state => "REMSTATE", 
      :dur_state => nil
    } # Do not remove this.
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::STATE::POPUP_ADD
        @popup_rules[:add_state] = $1.upcase.to_s
      when YEA::REGEXP::STATE::POPUP_REM
        @popup_rules[:rem_state] = $1.upcase.to_s
      when YEA::REGEXP::STATE::POPUP_DUR
        @popup_rules[:dur_state] = $1.upcase.to_s
      when YEA::REGEXP::STATE::HIDE_ADD
        @popup_rules[:add_state] = nil
      when YEA::REGEXP::STATE::HIDE_REM
        @popup_rules[:rem_state] = nil
      when YEA::REGEXP::STATE::HIDE_DUR
        @popup_rules[:dur_state] = nil
      end
    } # self.note.split
    #---
  end
  
end # RPG::State

#==============================================================================
# Å° BattleManager
#==============================================================================

module BattleManager
  
  #--------------------------------------------------------------------------
  # overwrite method: self.battle_start
  #--------------------------------------------------------------------------
  def self.battle_start
    $game_system.battle_count += 1
    $game_party.on_battle_start
    $game_troop.on_battle_start
    return unless YEA::BATTLE::MSG_ENEMY_APPEARS
    $game_troop.enemy_names.each do |name|
      $game_message.add(sprintf(Vocab::Emerge, name))
    end
    if @preemptive
      $game_message.add(sprintf(Vocab::Preemptive, $game_party.name))
    elsif @surprise
      $game_message.add(sprintf(Vocab::Surprise, $game_party.name))
    end
    wait_for_message
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: make_action_orders
  #--------------------------------------------------------------------------
  def self.make_action_orders
    make_dtb_action_orders if btype?(:dtb)
  end
  
  #--------------------------------------------------------------------------
  # new method: make_dtb_action_orders
  #--------------------------------------------------------------------------
  def self.make_dtb_action_orders
    @action_battlers = []
    @action_battlers += $game_party.members unless @surprise
    @action_battlers += $game_troop.members unless @preemptive
    @action_battlers.each {|battler| battler.make_speed }
    @action_battlers.sort! {|a,b| b.speed - a.speed }
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: turn_start
  #--------------------------------------------------------------------------
  def self.turn_start
    @phase = :turn
    clear_actor
    $game_troop.increase_turn
    @performed_battlers = []
    make_action_orders
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: next_subject
  #--------------------------------------------------------------------------
  def self.next_subject
    @performed_battlers = [] if @performed_battlers.nil?
    loop do
      @action_battlers -= @performed_battlers
      battler = @action_battlers.shift
      return nil unless battler
      next unless battler.index && battler.alive?
      @performed_battlers.push(battler)
      return battler
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: force_action
  #--------------------------------------------------------------------------
  def self.force_action(battler)
    @action_forced = [] if @action_forced == nil
    @action_forced.push(battler)
    return unless Switch.forced_action_remove
    @action_battlers.delete(battler)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: action_forced?
  #--------------------------------------------------------------------------
  def self.action_forced?
    @action_forced != nil
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: action_forced_battler
  #--------------------------------------------------------------------------
  def self.action_forced_battler
    @action_forced.shift
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: clear_action_force
  #--------------------------------------------------------------------------
  def self.clear_action_force
    return if @action_forced.nil?
    @action_forced = nil if @action_forced.empty?
  end
  
  #--------------------------------------------------------------------------
  # new method: self.init_battle_type
  #--------------------------------------------------------------------------
  def self.init_battle_type
    set_btype($game_system.battle_system)
  end
  
  #--------------------------------------------------------------------------
  # new method: self.set_btype
  #--------------------------------------------------------------------------
  def self.set_btype(btype = :dtb)
    @battle_type = btype
  end
  
  #--------------------------------------------------------------------------
  # new method: self.btype?
  #--------------------------------------------------------------------------
  def self.btype?(btype)
    return @battle_type == btype
  end
  
end # BattleManager

#==============================================================================
# Å° Game_System
#==============================================================================

class Game_System
  
  #--------------------------------------------------------------------------
  # new method: battle_system
  #--------------------------------------------------------------------------
  def battle_system
    if @battle_system.nil?
      return battle_system_corrected(YEA::BATTLE::DEFAULT_BATTLE_SYSTEM)
    else
      return battle_system_corrected(@battle_system)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: set_battle_system
  #--------------------------------------------------------------------------
  def set_battle_system(type)
    case type
    when :dtb; @battle_system = :dtb
    when :ftb; @battle_system = $imported["YEA-BattleSystem-FTB"] ? :ftb : :dtb
    else;      @battle_system = :dtb
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: battle_system_corrected
  #--------------------------------------------------------------------------
  def battle_system_corrected(type)
    case type
    when :dtb; return :dtb
    when :ftb; return $imported["YEA-BattleSystem-FTB"] ? :ftb : :dtb
    else;      return :dtb
    end
  end
  
end # Game_System

#==============================================================================
# Å° Sprite_Base
#==============================================================================

class Sprite_Base < Sprite
  
  #--------------------------------------------------------------------------
  # new method: start_pseudo_animation
  #--------------------------------------------------------------------------
  unless $imported["YEA-CoreEngine"]
  def start_pseudo_animation(animation, mirror = false)
    dispose_animation
    @animation = animation
    return if @animation.nil?
    @ani_mirror = mirror
    set_animation_rate
    @ani_duration = @animation.frame_max * @ani_rate + 1
    @ani_sprites = []
  end
  end # $imported["YEA-CoreEngine"]
  
end # Sprite_Base

#==============================================================================
# Å° Sprite_Battler
#==============================================================================

class Sprite_Battler < Sprite_Base
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :effect_type
  attr_accessor :battler_visible
  attr_accessor :popups
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias sprite_battler_initialize_abe initialize
  def initialize(viewport, battler = nil)
    sprite_battler_initialize_abe(viewport, battler)
    @popups = []
    @popup_flags = []
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_bitmap
  #--------------------------------------------------------------------------
  alias sprite_battler_update_bitmap_abe update_bitmap
  def update_bitmap
    return if @battler.actor? && @battler.battler_name == ""
    sprite_battler_update_bitmap_abe
  end
  
  #--------------------------------------------------------------------------
  # alias method: setup_new_animation
  #--------------------------------------------------------------------------
  unless $imported["YEA-CoreEngine"]
  alias sprite_battler_setup_new_animation_abe setup_new_animation
  def setup_new_animation
    sprite_battler_setup_new_animation_abe
    return if @battler.pseudo_ani_id <= 0
    animation = $data_animations[@battler.pseudo_ani_id]
    mirror = @battler.animation_mirror
    start_pseudo_animation(animation, mirror)
    @battler.pseudo_ani_id = 0
  end
  end # $imported["YEA-CoreEngine"]
  
  #--------------------------------------------------------------------------
  # alias method: setup_new_effect
  #--------------------------------------------------------------------------
  alias sprite_battler_setup_new_effect_abe setup_new_effect
  def setup_new_effect
    sprite_battler_setup_new_effect_abe
    setup_popups
  end
  
  #--------------------------------------------------------------------------
  # new method: setup_popups
  #--------------------------------------------------------------------------
  def setup_popups
    return unless @battler.use_sprite?
    @battler.popups = [] if @battler.popups.nil?
    return if @battler.popups == []
    array = @battler.popups.shift
    create_new_popup(array[0], array[1], array[2])
  end
  
  #--------------------------------------------------------------------------
  # new method: create_new_popup
  #--------------------------------------------------------------------------
  def create_new_popup(value, rules, flags)
    return if @battler == nil
    return if flags & @popup_flags != []
    array = YEA::BATTLE::POPUP_RULES[rules]
    for popup in @popups
      popup.y -= 24
    end
    return unless SceneManager.scene.is_a?(Scene_Battle)
    return if SceneManager.scene.spriteset.nil?
    view = SceneManager.scene.spriteset.viewportPopups
    new_popup = Sprite_Popup.new(view, @battler, value, rules, flags)
    @popups.push(new_popup)
    @popup_flags.push("weakness") if flags.include?("weakness")
    @popup_flags.push("resistant") if flags.include?("resistant")
    @popup_flags.push("immune") if flags.include?("immune")
    @popup_flags.push("absorbed") if flags.include?("absorbed")
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_effect
  #--------------------------------------------------------------------------
  alias sprite_battler_update_effect_abe update_effect
  def update_effect
    sprite_battler_update_effect_abe
    update_popups
  end
  
  #--------------------------------------------------------------------------
  # new method: update_popups
  #--------------------------------------------------------------------------
  def update_popups
    for popup in @popups
      popup.update
      next unless popup.opacity <= 0
      popup.bitmap.dispose
      popup.dispose
      @popups.delete(popup)
      popup = nil
    end
    @popup_flags = [] if @popups == [] && @popup_flags != []
    return unless SceneManager.scene_is?(Scene_Battle)
    if @current_active_battler != SceneManager.scene.subject
      @current_active_battler = SceneManager.scene.subject
      @popup_flags = []
    end
  end
  
end # Sprite_Battler

#==============================================================================
# Å° Sprite_Popup
#==============================================================================

class Sprite_Popup < Sprite_Base
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :flags
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(viewport, battler, value, rules, flags)
    super(viewport)
    @value = value
    @rules = rules
    @rules = "DEFAULT" unless YEA::BATTLE::POPUP_RULES.include?(@rules)
    @fade = YEA::BATTLE::POPUP_SETTINGS[:fade]
    @full = YEA::BATTLE::POPUP_SETTINGS[:full]
    @flags = flags
    @battler = battler
    create_popup_bitmap
  end
  
  #--------------------------------------------------------------------------
  # create_popup_bitmap
  #--------------------------------------------------------------------------
  def create_popup_bitmap
    rules_array = YEA::BATTLE::POPUP_RULES[@rules]
    bw = Graphics.width
    bw += 48 if @flags.include?("state")
    bh = Font.default_size * 3
    bitmap = Bitmap.new(bw, bh)
    bitmap.font.name = rules_array[8]
    size = @flags.include?("critical") ? rules_array[2] * 1.2 : rules_array[2]
    bitmap.font.size = size
    bitmap.font.bold = rules_array[3]
    bitmap.font.italic = rules_array[4]
    if flags.include?("critical")
      crit = YEA::BATTLE::POPUP_RULES["CRITICAL"]
      bitmap.font.out_color.set(crit[5], crit[6], crit[7], 255)
    else
      bitmap.font.out_color.set(0, 0, 0, 255)
    end
    dx = 0; dy = 0; dw = 0
    dx += 24 if @flags.include?("state")
    dw += 24 if @flags.include?("state")
    if @flags.include?("state") || @flags.include?("buff")
      c_width = bitmap.text_size(@value).width
      icon_bitmap = $game_temp.iconset
      icon_index = flag_state_icon
      rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
      bitmap.blt(dx+(bw-c_width)/2-36, (bh - 24)/2, icon_bitmap, rect, 255)
    end
    bitmap.font.color.set(rules_array[5], rules_array[6], rules_array[7])
    bitmap.draw_text(dx, dy, bw-dw, bh, @value, 1)
    self.bitmap = bitmap
    self.x = @battler.screen_x
    self.x += rand(4) - rand(4) if @battler.sprite.popups.size >= 1
    self.x -= SceneManager.scene.spriteset.viewport1.ox
    self.y = @battler.screen_y - @battler.sprite.oy/2
    self.y -= @battler.sprite.oy/2 if @battler.actor?
    self.y -= SceneManager.scene.spriteset.viewport1.oy
    self.ox = bw/2; self.oy = bh/2
    self.zoom_x = self.zoom_y = rules_array[0]
    if @flags.include?("no zoom")
      self.zoom_x = self.zoom_y = rules_array[1]
    end
    @target_zoom = rules_array[1]
    @zoom_direction = (self.zoom_x > @target_zoom) ? "down" : "up"
    self.z = 500
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    #---
    if @flags.include?("critical") && YEA::BATTLE::FLASH_CRITICAL
      @hue_duration = 2 if @hue_duration == nil || @hue_duration == 0
      @hue_duration -= 1
      self.bitmap.hue_change(15) if @hue_duration <= 0
    end
    #---
    if @zoom_direction == "up"
      self.zoom_x = [self.zoom_x + 0.075, @target_zoom].min
      self.zoom_y = [self.zoom_y + 0.075, @target_zoom].min
    else
      self.zoom_x = [self.zoom_x - 0.075, @target_zoom].max
      self.zoom_y = [self.zoom_y - 0.075, @target_zoom].max
    end
    #---
    @full -= 1
    return if @full > 0
    self.y -= 1
    self.opacity -= @fade
  end
  
  #--------------------------------------------------------------------------
  # flag_state_icon
  #--------------------------------------------------------------------------
  def flag_state_icon
    for item in @flags; return item if item.is_a?(Integer); end
    return 0
  end
  
end # Sprite_Popup

#==============================================================================
# Å° Spriteset_Battle
#==============================================================================

class Spriteset_Battle
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :actor_sprites
  attr_accessor :enemy_sprites
  attr_accessor :viewport1
  attr_accessor :viewportPopups
  
  #--------------------------------------------------------------------------
  # alias method: create_viewports
  #--------------------------------------------------------------------------
  alias spriteset_battle_create_viewports_abe create_viewports
  def create_viewports
    spriteset_battle_create_viewports_abe
    @viewportPopups = Viewport.new
    @viewportPopups.z = 200
  end
  
  #--------------------------------------------------------------------------
  # alias method: dispose_viewports
  #--------------------------------------------------------------------------
  alias spriteset_battle_dispose_viewports_abe dispose_viewports
  def dispose_viewports
    spriteset_battle_dispose_viewports_abe
    @viewportPopups.dispose
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_viewports
  #--------------------------------------------------------------------------
  alias spriteset_battle_update_viewports_abe update_viewports
  def update_viewports
    spriteset_battle_update_viewports_abe
    @viewportPopups.update
  end
  
end # Spriteset_Battle

#==============================================================================
# Å° Game_Temp
#==============================================================================

class Game_Temp
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :battle_aid
  attr_accessor :evaluating
  attr_accessor :iconset
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias game_temp_initialize_abe initialize
  def initialize
    game_temp_initialize_abe
    @iconset = Cache.system("Iconset")
  end
  
end # Game_Temp

#==============================================================================
# Å° Game_Action
#==============================================================================

class Game_Action
  
  #--------------------------------------------------------------------------
  # overwrite method: speed
  #--------------------------------------------------------------------------
  def speed
    speed = subject.agi
    speed += item.speed if item
    speed += subject.atk_speed if attack?
    return speed
  end
  
  #--------------------------------------------------------------------------
  # alias method: evaluate_item_with_target
  #--------------------------------------------------------------------------
  alias evaluate_item_with_target_abe evaluate_item_with_target
  def evaluate_item_with_target(target)
    $game_temp.evaluating = true
    result = evaluate_item_with_target_abe(target)
    $game_temp.evaluating = false
    return result
  end
  
end # Game_Action

#==============================================================================
# Å° Game_ActionResult
#==============================================================================

class Game_ActionResult
  
  #--------------------------------------------------------------------------
  # alias method: clear
  #--------------------------------------------------------------------------
  alias game_actionresult_clear_abe clear
  def clear
    game_actionresult_clear_abe
    clear_stored_damage
  end
  
  #--------------------------------------------------------------------------
  # new method: clear_stored_damage
  #--------------------------------------------------------------------------
  def clear_stored_damage
    @stored_hp_damage = 0
    @stored_mp_damage = 0
    @stored_tp_damage = 0
    @stored_hp_drain = 0
    @stored_mp_drain = 0
  end
  
  #--------------------------------------------------------------------------
  # new method: store_damage
  #--------------------------------------------------------------------------
  def store_damage
    @stored_hp_damage += @hp_damage
    @stored_mp_damage += @mp_damage
    @stored_tp_damage += @tp_damage
    @stored_hp_drain += @hp_drain
    @stored_mp_drain += @mp_drain
  end
  
  #--------------------------------------------------------------------------
  # new method: restore_damage
  #--------------------------------------------------------------------------
  def restore_damage
    @hp_damage = @stored_hp_damage
    @mp_damage = @stored_mp_damage
    @tp_damage = @stored_tp_damage
    @hp_drain = @stored_hp_drain
    @mp_drain = @stored_mp_drain
    clear_stored_damage
  end
  
end # Game_ActionResult

#==============================================================================
# Å° Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :popups
  
  #--------------------------------------------------------------------------
  # new method: create_popup
  #--------------------------------------------------------------------------
  def create_popup(value, rules = "DEFAULT", flags = [])
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless YEA::BATTLE::ENABLE_POPUPS
    return if Switch.hide_popups
    @popups = [] if @popups.nil?
    @popups.push([value, rules, flags])
  end
  
  #--------------------------------------------------------------------------
  # new method: make_damage_popups
  #--------------------------------------------------------------------------
  def make_damage_popups(user)
    if @result.hp_drain != 0
      text = YEA::BATTLE::POPUP_SETTINGS[:drained]
      rules = "DRAIN"
      user.create_popup(text, rules)
      setting = :hp_dmg  if @result.hp_drain < 0
      setting = :hp_heal if @result.hp_drain > 0
      rules = "HP_DMG"   if @result.hp_drain < 0
      rules = "HP_HEAL"  if @result.hp_drain > 0
      value = @result.hp_drain.abs
      text = sprintf(YEA::BATTLE::POPUP_SETTINGS[setting], value.group)
      user.create_popup(text, rules)
    end
    if @result.mp_drain != 0
      text = YEA::BATTLE::POPUP_SETTINGS[:drained]
      rules = "DRAIN"
      user.create_popup(text, rules)
      setting = :mp_dmg  if @result.mp_drain < 0
      setting = :mp_heal if @result.mp_drain > 0
      rules = "HP_DMG"   if @result.mp_drain < 0
      rules = "HP_HEAL"  if @result.mp_drain > 0
      value = @result.mp_drain.abs
      text = sprintf(YEA::BATTLE::POPUP_SETTINGS[setting], value.group)
      user.create_popup(text, rules)
    end
    #---
    flags = []
    flags.push("critical") if @result.critical
    if @result.hp_damage != 0
      setting = :hp_dmg  if @result.hp_damage > 0
      setting = :hp_heal if @result.hp_damage < 0
      rules = "HP_DMG"   if @result.hp_damage > 0
      rules = "HP_HEAL"  if @result.hp_damage < 0
      value = @result.hp_damage.abs
      text = sprintf(YEA::BATTLE::POPUP_SETTINGS[setting], value.group)
      create_popup(text, rules, flags)
    end
    if @result.mp_damage != 0
      setting = :mp_dmg  if @result.mp_damage > 0
      setting = :mp_heal if @result.mp_damage < 0
      rules = "MP_DMG"   if @result.mp_damage > 0
      rules = "MP_HEAL"  if @result.mp_damage < 0
      value = @result.mp_damage.abs
      text = sprintf(YEA::BATTLE::POPUP_SETTINGS[setting], value.group)
      create_popup(text, rules, flags)
    end
    if @result.tp_damage != 0
      setting = :tp_dmg  if @result.tp_damage > 0
      setting = :tp_heal if @result.tp_damage < 0
      rules = "TP_DMG"   if @result.tp_damage > 0
      rules = "TP_HEAL"  if @result.tp_damage < 0
      value = @result.tp_damage.abs
      text = sprintf(YEA::BATTLE::POPUP_SETTINGS[setting], value.group)
      create_popup(text, rules)
    end
    @result.store_damage
    @result.clear_damage_values
  end
  
  #--------------------------------------------------------------------------
  # alias method: erase_state
  #--------------------------------------------------------------------------
  alias game_battlerbase_erase_state_abe erase_state
  def erase_state(state_id)
    make_state_popup(state_id, :rem_state) if @states.include?(state_id)
    game_battlerbase_erase_state_abe(state_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: make_during_state_popup
  #--------------------------------------------------------------------------
  def make_during_state_popup
    state_id = most_important_state_id
    return if state_id == 0
    make_state_popup(state_id, :dur_state)
  end
  
  #--------------------------------------------------------------------------
  # new method: most_important_state_id
  #--------------------------------------------------------------------------
  def most_important_state_id
    states.each {|state| return state.id unless state.message3.empty? }
    return 0
  end
  
  #--------------------------------------------------------------------------
  # new method: make_state_popup
  #--------------------------------------------------------------------------
  def make_state_popup(state_id, type)
    state = $data_states[state_id]
    return if state.icon_index == 0
    rules = state.popup_rules[type]
    return if rules.nil?
    text = sprintf(YEA::BATTLE::POPUP_SETTINGS[type], state.name)
    flags = ["state", state.icon_index]
    create_popup(text, rules, flags)
  end
  
  #--------------------------------------------------------------------------
  # new method: make_miss_popups
  #--------------------------------------------------------------------------
  def make_miss_popups(user, item)
    return if dead?
    if @result.missed
      text = YEA::BATTLE::POPUP_SETTINGS[:missed]
      rules = "DEFAULT"
      create_popup(text, rules)
    end
    if @result.evaded
      text = YEA::BATTLE::POPUP_SETTINGS[:evaded]
      rules = "DEFAULT"
      create_popup(text, rules)
    end
    if @result.hit? && !@result.success
      text = YEA::BATTLE::POPUP_SETTINGS[:failed]
      rules = "DEFAULT"
      create_popup(text, rules)
    end
    if @result.hit? && item.damage.to_hp?
      if @result.hp_damage == 0 && @result.hp_damage == 0
        text = YEA::BATTLE::POPUP_SETTINGS[:nulled]
        rules = "DEFAULT"
        create_popup(text, rules)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: make_rate_popup
  #--------------------------------------------------------------------------
  def make_rate_popup(rate)
    return if rate == 1.0
    flags = []
    if rate > 1.0
      text = YEA::BATTLE::POPUP_SETTINGS[:weakpoint]
      rules = "WEAK_ELE"
      flags.push("weakness")
    elsif rate == 0.0
      text = YEA::BATTLE::POPUP_SETTINGS[:immune]
      rules = "IMMU_ELE"
      flags.push("immune")
    elsif rate < 0.0
      text = YEA::BATTLE::POPUP_SETTINGS[:absorbed]
      rules = "ABSB_ELE"
      flags.push("absorbed")
    else
      text = YEA::BATTLE::POPUP_SETTINGS[:resistant]
      rules = "REST_ELE"
      flags.push("resistant")
    end
    create_popup(text, rules, flags)
  end
  
  #--------------------------------------------------------------------------
  # new method: make_buff_popup
  #--------------------------------------------------------------------------
  def make_buff_popup(param_id, positive = true)
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless alive?
    name = Vocab::param(param_id)
    if positive
      text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:add_buff], name)
      rules = "BUFF"
      buff_level = 1
    else
      text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:add_debuff], name)
      rules = "DEBUFF"
      buff_level = -1
    end
    icon = buff_icon_index(buff_level, param_id)
    flags = ["buff", icon]
    return if @popups.include?([text, rules, flags])
    create_popup(text, rules, flags)
  end
  
end # Game_BattlerBase

#==============================================================================
# Å° Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :pseudo_ani_id
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_end
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_end_abe on_battle_end
  def on_battle_end
    game_battler_on_battle_end_abe
    @popups = []
  end
  
  #--------------------------------------------------------------------------
  # alias method: clear_sprite_effects
  #--------------------------------------------------------------------------
  alias game_battler_clear_sprite_effects_abe clear_sprite_effects
  def clear_sprite_effects
    game_battler_clear_sprite_effects_abe
    @pseudo_ani_id = 0
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_apply
  #--------------------------------------------------------------------------
  alias game_battler_item_apply_abe item_apply
  def item_apply(user, item)
    game_battler_item_apply_abe(user, item)
    make_miss_popups(user, item)
  end
  
  #--------------------------------------------------------------------------
  # alias method: make_damage_value
  #--------------------------------------------------------------------------
  alias game_battler_make_damage_value_abe make_damage_value
  def make_damage_value(user, item)
    game_battler_make_damage_value_abe(user, item)
    rate = item_element_rate(user, item)
    make_rate_popup(rate) unless $game_temp.evaluating
  end
  
  #--------------------------------------------------------------------------
  # alias method: execute_damage
  #--------------------------------------------------------------------------
  alias game_battler_execute_damage_abe execute_damage
  def execute_damage(user)
    game_battler_execute_damage_abe(user)
    make_damage_popups(user)
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_effect_recover_hp
  #--------------------------------------------------------------------------
  alias game_battler_item_effect_recover_hp_abe item_effect_recover_hp
  def item_effect_recover_hp(user, item, effect)
    game_battler_item_effect_recover_hp_abe(user, item, effect)
    make_damage_popups(user)
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_effect_recover_mp
  #--------------------------------------------------------------------------
  alias game_battler_item_effect_recover_mp_abe item_effect_recover_mp
  def item_effect_recover_mp(user, item, effect)
    game_battler_item_effect_recover_mp_abe(user, item, effect)
    make_damage_popups(user)
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_effect_gain_tp
  #--------------------------------------------------------------------------
  alias game_battler_item_effect_gain_tp_abe item_effect_gain_tp
  def item_effect_gain_tp(user, item, effect)
    game_battler_item_effect_gain_tp_abe(user, item, effect)
    make_damage_popups(user)
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_user_effect
  #--------------------------------------------------------------------------
  alias game_battler_item_user_effect_abe item_user_effect
  def item_user_effect(user, item)
    game_battler_item_user_effect_abe(user, item)
    @result.restore_damage
  end
  
  #--------------------------------------------------------------------------
  # alias method: add_new_state
  #--------------------------------------------------------------------------
  alias game_battler_add_new_state_abe add_new_state
  def add_new_state(state_id)
    game_battler_add_new_state_abe(state_id)
    make_state_popup(state_id, :add_state) if @states.include?(state_id)
  end
  
  #--------------------------------------------------------------------------
  # alias method: add_buff
  #--------------------------------------------------------------------------
  alias game_battler_add_buff_abe add_buff
  def add_buff(param_id, turns)
    make_buff_popup(param_id, true)
    game_battler_add_buff_abe(param_id, turns)
  end
  
  #--------------------------------------------------------------------------
  # alias method: add_debuff
  #--------------------------------------------------------------------------
  alias game_battler_add_debuff_abe add_debuff
  def add_debuff(param_id, turns)
    make_buff_popup(param_id, false)
    game_battler_add_debuff_abe(param_id, turns)
  end
  
  #--------------------------------------------------------------------------
  # alias method: regenerate_all
  #--------------------------------------------------------------------------
  alias game_battler_regenerate_all_abe regenerate_all
  def regenerate_all
    game_battler_regenerate_all_abe
    return unless alive?
    make_damage_popups(self)
  end
  
  #--------------------------------------------------------------------------
  # new method: can_collapse?
  #--------------------------------------------------------------------------
  def can_collapse?
    return false unless dead?
    unless actor?
      return false unless sprite.battler_visible
      array = [:collapse, :boss_collapse, :instant_collapse]
      return false if array.include?(sprite.effect_type)
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_mp?
  #--------------------------------------------------------------------------
  def draw_mp?; return true; end
  
  #--------------------------------------------------------------------------
  # new method: draw_tp?
  #--------------------------------------------------------------------------
  def draw_tp?
    return $data_system.opt_display_tp
  end
  
end # Game_Battler

#==============================================================================
# Å° Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # overwrite method: perform_damage_effect
  #--------------------------------------------------------------------------
  def perform_damage_effect
    $game_troop.screen.start_shake(5, 5, 10) if YEA::BATTLE::SCREEN_SHAKE
    @sprite_effect_type = :blink if YEA::BATTLE::BLINK_EFFECTS
    Sound.play_actor_damage
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: use_sprite?
  #--------------------------------------------------------------------------
  def use_sprite?; return true; end
    
  #--------------------------------------------------------------------------
  # new method: screen_x
  #--------------------------------------------------------------------------
  def screen_x
    return 0 unless SceneManager.scene_is?(Scene_Battle)
    status_window = SceneManager.scene.status_window
    return 0 if status_window.nil?
    item_rect_width = (status_window.width-24) / $game_party.max_battle_members
    ext = SceneManager.scene.info_viewport.ox
    rect = SceneManager.scene.status_window.item_rect(self.index)
    constant = 128 + 12
    return constant + rect.x + item_rect_width / 2 - ext
  end
  
  #--------------------------------------------------------------------------
  # new method: screen_y
  #--------------------------------------------------------------------------
  def screen_y
    return Graphics.height - 120 unless SceneManager.scene_is?(Scene_Battle)
    return Graphics.height - 120 if SceneManager.scene.status_window.nil?
    return Graphics.height - (SceneManager.scene.status_window.height * 7/8)
  end
  
  #--------------------------------------------------------------------------
  # new method: screen_z
  #--------------------------------------------------------------------------
  def screen_z; return 100; end
  
  #--------------------------------------------------------------------------
  # new method: sprite
  #--------------------------------------------------------------------------
  def sprite
    index = $game_party.battle_members.index(self)
    return SceneManager.scene.spriteset.actor_sprites[index]
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_mp?
  #--------------------------------------------------------------------------
  def draw_mp?
    return true unless draw_tp?
    for skill in skills
      next unless added_skill_types.include?(skill.stype_id)
      return true if skill.mp_cost > 0
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_tp?
  #--------------------------------------------------------------------------
  def draw_tp?
    return false unless $data_system.opt_display_tp
    for skill in skills
      next unless added_skill_types.include?(skill.stype_id)
      return true if skill.tp_cost > 0
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # alias method: input
  #--------------------------------------------------------------------------
  alias game_actor_input_abe input
  def input
    if @actions.nil?
      make_actions
      @action_input_index = 0
    end
    if @actions[@action_input_index].nil?
      @actions[@action_input_index] = Game_Action.new(self)
    end
    return game_actor_input_abe
  end
  
end # Game_Actor

#==============================================================================
# Å° Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # overwrite method: perform_damage_effect
  #--------------------------------------------------------------------------
  def perform_damage_effect
    @sprite_effect_type = :blink if YEA::BATTLE::BLINK_EFFECTS
    Sound.play_enemy_damage
  end
  
  #--------------------------------------------------------------------------
  # new methods: attack_animation_id
  #--------------------------------------------------------------------------
  def atk_animation_id1; return enemy.atk_animation_id1; end
  def atk_animation_id2; return enemy.atk_animation_id2; end
  
  #--------------------------------------------------------------------------
  # new method: sprite
  #--------------------------------------------------------------------------
  def sprite
    return SceneManager.scene.spriteset.enemy_sprites.reverse[self.index]
  end
  
end # Game_Enemy

#==============================================================================
# Å° Game_Unit
#==============================================================================

class Game_Unit
  
  #--------------------------------------------------------------------------
  # alias method: make_actions
  #--------------------------------------------------------------------------
  alias game_unit_make_actions_abe make_actions
  def make_actions
    game_unit_make_actions_abe
    refresh_autobattler_status_window
  end
  
  #--------------------------------------------------------------------------
  # new method: refresh_autobattler_status_window
  #--------------------------------------------------------------------------
  def refresh_autobattler_status_window
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless self.is_a?(Game_Party)
    SceneManager.scene.refresh_autobattler_status_window
  end
  
end # Game_Unit

#==============================================================================
# Å° Window_PartyCommand
#==============================================================================

class Window_PartyCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # overwrite method: process_handling
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    return process_dir6 if Input.repeat?(:RIGHT)
    return super
  end
  
  #--------------------------------------------------------------------------
  # new method: process_dir6
  #--------------------------------------------------------------------------
  def process_dir6
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:dir6)
  end
  
end # Window_PartyCommand

#==============================================================================
# Å° Window_ActorCommand
#==============================================================================

class Window_ActorCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # overwrite method: process_handling
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    return process_dir4 if Input.repeat?(:LEFT)
    return process_dir6 if Input.repeat?(:RIGHT)
    return super
  end
  
  #--------------------------------------------------------------------------
  # new method: process_dir4
  #--------------------------------------------------------------------------
  def process_dir4
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:cancel)
  end
  
  #--------------------------------------------------------------------------
  # new method: process_dir6
  #--------------------------------------------------------------------------
  def process_dir6
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:dir6)
  end
  
end # Window_ActorCommand

#==============================================================================
# Å° Window_BattleStatus
#==============================================================================

class Window_BattleStatus < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: initialize
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, window_width, window_height)
    self.openness = 0
    @party = $game_party.battle_members.clone
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: col_max
  #--------------------------------------------------------------------------
  def col_max; return $game_party.max_battle_members; end
  
  #--------------------------------------------------------------------------
  # new method: battle_members
  #--------------------------------------------------------------------------
  def battle_members; return $game_party.battle_members; end
  
  #--------------------------------------------------------------------------
  # new method: actor
  #--------------------------------------------------------------------------
  def actor; return battle_members[@index]; end
  
  #--------------------------------------------------------------------------
  # overwrite method: update
  #--------------------------------------------------------------------------
  def update
    super
    return if @party == $game_party.battle_members
    @party = $game_party.battle_members.clone
    refresh
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    return if index.nil?
    clear_item(index)
    actor = battle_members[index]
    rect = item_rect(index)
    return if actor.nil?
    draw_actor_face(actor, rect.x+2, rect.y+2, actor.alive?)
    draw_actor_name(actor, rect.x, rect.y, rect.width-8)
    draw_actor_action(actor, rect.x, rect.y)
    draw_actor_icons(actor, rect.x, line_height*1, rect.width)
    gx = YEA::BATTLE::BATTLESTATUS_HPGAUGE_Y_PLUS
    contents.font.size = YEA::BATTLE::BATTLESTATUS_TEXT_FONT_SIZE
    draw_actor_hp(actor, rect.x+2, line_height*2+gx, rect.width-4)
    if draw_tp?(actor) && draw_mp?(actor)
      dw = rect.width/2-2
      dw += 1 if $imported["YEA-CoreEngine"] && YEA::CORE::GAUGE_OUTLINE
      draw_actor_tp(actor, rect.x+2, line_height*3, dw)
      dw = rect.width - rect.width/2 - 2
      draw_actor_mp(actor, rect.x+rect.width/2, line_height*3, dw)
    elsif draw_tp?(actor) && !draw_mp?(actor)
      draw_actor_tp(actor, rect.x+2, line_height*3, rect.width-4)
    else
      draw_actor_mp(actor, rect.x+2, line_height*3, rect.width-4)
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: item_rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = contents.width / $game_party.max_battle_members
    rect.height = contents.height
    rect.x = index * rect.width
    if YEA::BATTLE::BATTLESTATUS_CENTER_FACES
      rect.x += (contents.width - $game_party.members.size * rect.width) / 2
    end
    rect.y = 0
    return rect
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_face
  #--------------------------------------------------------------------------
  def draw_face(face_name, face_index, dx, dy, enabled = true)
    bitmap = Cache.face(face_name)
    fx = [(96 - item_rect(0).width + 1) / 2, 0].max
    fy = face_index / 4 * 96 + 2
    fw = [item_rect(0).width - 4, 92].min
    rect = Rect.new(fx, fy, fw, 92)
    rect = Rect.new(face_index % 4 * 96 + fx, fy, fw, 92)
    contents.blt(dx, dy, bitmap, rect, enabled ? 255 : translucent_alpha)
    bitmap.dispose
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_name
  #--------------------------------------------------------------------------
  def draw_actor_name(actor, dx, dy, dw = 112)
    reset_font_settings
    contents.font.size = YEA::BATTLE::BATTLESTATUS_NAME_FONT_SIZE
    change_color(hp_color(actor))
    draw_text(dx+24, dy, dw-24, line_height, actor.name)
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_actor_action
  #--------------------------------------------------------------------------
  def draw_actor_action(actor, dx, dy)
    draw_icon(action_icon(actor), dx, dy)
  end
  
  #--------------------------------------------------------------------------
  # new method: action_icon
  #--------------------------------------------------------------------------
  def action_icon(actor)
    return Icon.no_action if actor.current_action.nil?
    return Icon.no_action if actor.current_action.item.nil?
    return actor.current_action.item.icon_index
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_tp?
  #--------------------------------------------------------------------------
  def draw_tp?(actor)
    return actor.draw_tp?
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_mp?
  #--------------------------------------------------------------------------
  def draw_mp?(actor)
    return actor.draw_mp?
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_current_and_max_values
  #--------------------------------------------------------------------------
  def draw_current_and_max_values(dx, dy, dw, current, max, color1, color2)
    change_color(color1)
    draw_text(dx, dy, dw, line_height, current.group, 2)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_hp
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, dx, dy, width = 124)
    draw_gauge(dx, dy, width, actor.hp_rate, hp_gauge_color1, hp_gauge_color2)
    change_color(system_color)
    cy = (Font.default_size - contents.font.size) / 2 + 1
    draw_text(dx+2, dy+cy, 30, line_height, Vocab::hp_a)
    draw_current_and_max_values(dx, dy+cy, width, actor.hp, actor.mhp,
      hp_color(actor), normal_color)
    end
    
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_mp
  #--------------------------------------------------------------------------
  def draw_actor_mp(actor, dx, dy, width = 124)
    draw_gauge(dx, dy, width, actor.mp_rate, mp_gauge_color1, mp_gauge_color2)
    change_color(system_color)
    cy = (Font.default_size - contents.font.size) / 2 + 1
    draw_text(dx+2, dy+cy, 30, line_height, Vocab::mp_a)
    draw_current_and_max_values(dx, dy+cy, width, actor.mp, actor.mmp,
      mp_color(actor), normal_color)
    end
    
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_tp
  #--------------------------------------------------------------------------
  def draw_actor_tp(actor, dx, dy, width = 124)
    draw_gauge(dx, dy, width, actor.tp_rate, tp_gauge_color1, tp_gauge_color2)
    change_color(system_color)
    cy = (Font.default_size - contents.font.size) / 2 + 1
    draw_text(dx+2, dy+cy, 30, line_height, Vocab::tp_a)
    change_color(tp_color(actor))
    draw_text(dx + width - 42, dy+cy, 42, line_height, actor.tp.to_i, 2)
  end
  
end # Window_BattleStatus

#==============================================================================
# Å° Window_BattleActor
#==============================================================================

class Window_BattleActor < Window_BattleStatus
  
  #--------------------------------------------------------------------------
  # overwrite method: show
  #--------------------------------------------------------------------------
  def show
    create_flags
    super
  end
  
  #--------------------------------------------------------------------------
  # new method: create_flags
  #--------------------------------------------------------------------------
  def create_flags
    set_select_flag(:any)
    select(0)
    return if $game_temp.battle_aid.nil?
    if $game_temp.battle_aid.need_selection?
      select(0)
      set_select_flag(:dead) if $game_temp.battle_aid.for_dead_friend?
    elsif $game_temp.battle_aid.for_user?
      battler = BattleManager.actor
      id = battler.nil? ? 0 : $game_party.battle_members.index(battler)
      select(id)
      set_select_flag(:user)
    elsif $game_temp.battle_aid.for_all?
      select(0)
      set_select_flag(:all)
      set_select_flag(:all_dead) if $game_temp.battle_aid.for_dead_friend?
    elsif $game_temp.battle_aid.for_random?
      select(0)
      set_select_flag(:random) if $game_temp.battle_aid.for_random?
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: set_flag
  #--------------------------------------------------------------------------
  def set_select_flag(flag)
    @select_flag = flag
    case @select_flag
    when :all, :all_dead, :random
      @cursor_all = true
    else
      @cursor_all = false
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: update_cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @cursor_all
      cursor_rect.set(0, 0, contents.width, contents.height)
      self.top_row = 0
    elsif @index < 0
      cursor_rect.empty
    else
      ensure_cursor_visible
      cursor_rect.set(item_rect(@index))
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: cursor_movable?
  #--------------------------------------------------------------------------
  def cursor_movable?
    return false if @select_flag == :user
    return super
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: current_item_enabled?
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return true if $game_temp.battle_aid.nil?
    if $game_temp.battle_aid.need_selection?
      member = $game_party.battle_members[@index]
      return member.dead? if $game_temp.battle_aid.for_dead_friend?
    elsif $game_temp.battle_aid.for_dead_friend?
      for member in $game_party.battle_members
        return true if member.dead?
      end
      return false
    end
    return true
  end
  
end # Window_BattleActor

#==============================================================================
# Å° Window_BattleStatusAid
#==============================================================================

class Window_BattleStatusAid < Window_BattleStatus
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :status_window
  
  #--------------------------------------------------------------------------
  # overwrite method: initialize
  #--------------------------------------------------------------------------
  def initialize
    super
    self.visible = false
    self.openness = 255
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: window_width
  #--------------------------------------------------------------------------
  def window_width; return 128; end
  
  #--------------------------------------------------------------------------
  # overwrite method: show
  #--------------------------------------------------------------------------
  def show
    super
    refresh
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if @status_window.nil?
    draw_item(@status_window.index)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: item_rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    return Rect.new(0, 0, contents.width, contents.height)
  end
  
end # Window_BattleStatusAid

#==============================================================================
# Å° Window_BattleEnemy
#==============================================================================

class Window_BattleEnemy < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: initialize
  #--------------------------------------------------------------------------
  def initialize(info_viewport)
    super(0, Graphics.height, window_width, fitting_height(1))
    refresh
    self.visible = false
    @info_viewport = info_viewport
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: col_max
  #--------------------------------------------------------------------------
  def col_max; return item_max; end
  
  #--------------------------------------------------------------------------
  # overwrite method: show
  #--------------------------------------------------------------------------
  def show
    create_flags
    super
  end
  
  #--------------------------------------------------------------------------
  # new method: create_flags
  #--------------------------------------------------------------------------
  def create_flags
    set_select_flag(:any)
    select(0)
    return if $game_temp.battle_aid.nil?
    if $game_temp.battle_aid.need_selection?
      select(0)
    elsif $game_temp.battle_aid.for_all?
      select(0)
      set_select_flag(:all)
    elsif $game_temp.battle_aid.for_random?
      select(0)
      set_select_flag(:random)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: set_flag
  #--------------------------------------------------------------------------
  def set_select_flag(flag)
    @select_flag = flag
    case @select_flag
    when :all, :random
      @cursor_all = true
    else
      @cursor_all = false
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: select_all?
  #--------------------------------------------------------------------------
  def select_all?
    return true if @select_flag == :all
    return true if @select_flag == :random
    return false
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: update_cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @cursor_all
      cursor_rect.set(0, 0, contents.width, contents.height)
      self.top_row = 0
    elsif @index < 0
      cursor_rect.empty
    else
      ensure_cursor_visible
      cursor_rect.set(item_rect(@index))
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: cursor_movable?
  #--------------------------------------------------------------------------
  def cursor_movable?
    return false if @select_flag == :user
    return super
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: current_item_enabled?
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return true if $game_temp.battle_aid.nil?
    if $game_temp.battle_aid.need_selection?
      member = $game_party.battle_members[@index]
      return member.dead? if $game_temp.battle_aid.for_dead_friend?
    elsif $game_temp.battle_aid.for_dead_friend?
      for member in $game_party.battle_members
        return true if member.dead?
      end
      return false
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: enemy
  #--------------------------------------------------------------------------
  def enemy; @data[index]; end
  
  #--------------------------------------------------------------------------
  # overwrite method: refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: make_item_list
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_troop.alive_members
    @data.sort! { |a,b| a.screen_x <=> b.screen_x }
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_item
  #--------------------------------------------------------------------------
  def draw_item(index); return; end
  
  #--------------------------------------------------------------------------
  # overwrite method: update
  #--------------------------------------------------------------------------
  def update
    super
    return unless active
    enemy.sprite_effect_type = :whiten
    return unless select_all?
    for enemy in $game_troop.alive_members
      enemy.sprite_effect_type = :whiten
    end
  end
  
end # Window_BattleEnemy

#==============================================================================
# Å° Window_BattleHelp
#==============================================================================

class Window_BattleHelp < Window_Help
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :actor_window
  attr_accessor :enemy_window
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    if !self.visible and @text != ""
      @text = ""
      return refresh
    end
    update_battler_name
  end
  
  #--------------------------------------------------------------------------
  # update_battler_name
  #--------------------------------------------------------------------------
  def update_battler_name
    return unless @actor_window.active || @enemy_window.active
    if @actor_window.active
      battler = $game_party.battle_members[@actor_window.index]
    elsif @enemy_window.active
      battler = @enemy_window.enemy
    end
    if special_display?
      refresh_special_case(battler)
    else
      refresh_battler_name(battler) if battler_name(battler) != @text
    end
  end
  
  #--------------------------------------------------------------------------
  # battler_name
  #--------------------------------------------------------------------------
  def battler_name(battler)
    text = battler.name.clone
    return text
  end
  
  #--------------------------------------------------------------------------
  # refresh_battler_name
  #--------------------------------------------------------------------------
  def refresh_battler_name(battler)
    contents.clear
    reset_font_settings
    change_color(normal_color)
    @text = battler_name(battler)
    icons = battler.state_icons + battler.buff_icons
    dy = icons.size <= 0 ? line_height / 2 : 0
    draw_text(0, dy, contents.width, line_height, @text, 1)
    dx = (contents.width - (icons.size * 24)) / 2
    draw_actor_icons(battler, dx, line_height, contents.width)
  end
  
  #--------------------------------------------------------------------------
  # special_display?
  #--------------------------------------------------------------------------
  def special_display?
    return false if $game_temp.battle_aid.nil?
    return false if $game_temp.battle_aid.for_user?
    return !$game_temp.battle_aid.need_selection?
  end
  
  #--------------------------------------------------------------------------
  # refresh_special_case
  #--------------------------------------------------------------------------
  def refresh_special_case(battler)
    if $game_temp.battle_aid.for_opponent?
      if $game_temp.battle_aid.for_all?
        text = YEA::BATTLE::HELP_TEXT_ALL_FOES
      else
        case $game_temp.battle_aid.number_of_targets
        when 1
          text = YEA::BATTLE::HELP_TEXT_ONE_RANDOM_FOE
        else
          number = $game_temp.battle_aid.number_of_targets
          text = sprintf(YEA::BATTLE::HELP_TEXT_MANY_RANDOM_FOE, number)
        end
      end
    else # $game_temp.battle_aid.for_friend?
      if $game_temp.battle_aid.for_dead_friend?
        text = YEA::BATTLE::HELP_TEXT_ALL_DEAD_ALLIES
      elsif $game_temp.battle_aid.for_random?
        case $game_temp.battle_aid.number_of_targets
        when 1
          text = YEA::BATTLE::HELP_TEXT_ONE_RANDOM_ALLY
        else
          number = $game_temp.battle_aid.number_of_targets
          text = sprintf(YEA::BATTLE::HELP_TEXT_RANDOM_ALLIES, number)
        end
      else
        text = YEA::BATTLE::HELP_TEXT_ALL_ALLIES
      end
    end
    return if text == @text
    @text = text
    contents.clear
    reset_font_settings
    draw_text(0, 0, contents.width, line_height*2, @text, 1)
  end
  
end # Window_BattleHelp

#==============================================================================
# Å° Window_BattleLog
#==============================================================================

class Window_BattleLog < Window_Selectable
  
  #--------------------------------------------------------------------------
  # alias method: display_current_state
  #--------------------------------------------------------------------------
  alias window_battlelog_display_current_state_abe display_current_state
  def display_current_state(subject)
    subject.make_during_state_popup
    return unless YEA::BATTLE::MSG_CURRENT_STATE
    window_battlelog_display_current_state_abe(subject)
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_use_item
  #--------------------------------------------------------------------------
  alias window_battlelog_display_use_item_abe display_use_item
  def display_use_item(subject, item)
    return unless YEA::BATTLE::MSG_CURRENT_ACTION
    window_battlelog_display_use_item_abe(subject, item)
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_counter
  #--------------------------------------------------------------------------
  alias window_battlelog_display_counter_abe display_counter
  def display_counter(target, item)
    if YEA::BATTLE::MSG_COUNTERATTACK
      window_battlelog_display_counter_abe(target, item)
    else
      Sound.play_evasion
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_reflection
  #--------------------------------------------------------------------------
  alias window_battlelog_display_reflection_abe display_reflection
  def display_reflection(target, item)
    if YEA::BATTLE::MSG_REFLECT_MAGIC
      window_battlelog_display_reflection_abe(target, item)
    else
      Sound.play_reflection
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_substitute
  #--------------------------------------------------------------------------
  alias window_battlelog_display_substitute_abe display_substitute
  def display_substitute(substitute, target)
    return unless YEA::BATTLE::MSG_SUBSTITUTE_HIT
    window_battlelog_display_substitute_abe(substitute, target)
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_failure
  #--------------------------------------------------------------------------
  alias window_battlelog_display_failure_abe display_failure
  def display_failure(target, item)
    return unless YEA::BATTLE::MSG_FAILURE_HIT
    window_battlelog_display_failure_abe(target, item)
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_critical
  #--------------------------------------------------------------------------
  alias window_battlelog_display_critical_abe display_critical
  def display_critical(target, item)
    return unless YEA::BATTLE::MSG_CRITICAL_HIT
    window_battlelog_display_critical_abe(target, item)
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_miss
  #--------------------------------------------------------------------------
  alias window_battlelog_display_miss_abe display_miss
  def display_miss(target, item)
    return unless YEA::BATTLE::MSG_HIT_MISSED
    window_battlelog_display_miss_abe(target, item)
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_evasion
  #--------------------------------------------------------------------------
  alias window_battlelog_display_evasion_abe display_evasion
  def display_evasion(target, item)
    if YEA::BATTLE::MSG_EVASION
      window_battlelog_display_evasion_abe(target, item)
    else
      if !item || item.physical?
        Sound.play_evasion
      else
        Sound.play_magic_evasion
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: display_hp_damage
  #--------------------------------------------------------------------------
  def display_hp_damage(target, item)
    return if target.result.hp_damage == 0 && item && !item.damage.to_hp?
    if target.result.hp_damage > 0 && target.result.hp_drain == 0
      target.perform_damage_effect
    end
    Sound.play_recovery if target.result.hp_damage < 0
    return unless YEA::BATTLE::MSG_HP_DAMAGE
    add_text(target.result.hp_damage_text)
    wait
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: display_mp_damage
  #--------------------------------------------------------------------------
  def display_mp_damage(target, item)
    return if target.dead? || target.result.mp_damage == 0
    Sound.play_recovery if target.result.mp_damage < 0
    return unless YEA::BATTLE::MSG_MP_DAMAGE
    add_text(target.result.mp_damage_text)
    wait
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: display_tp_damage
  #--------------------------------------------------------------------------
  def display_tp_damage(target, item)
    return if target.dead? || target.result.tp_damage == 0
    Sound.play_recovery if target.result.tp_damage < 0
    return unless YEA::BATTLE::MSG_TP_DAMAGE
    add_text(target.result.tp_damage_text)
    wait
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_added_states
  #--------------------------------------------------------------------------
  alias window_battlelog_display_added_states_abe display_added_states
  def display_added_states(target)
    return unless YEA::BATTLE::MSG_ADDED_STATES
    window_battlelog_display_added_states_abe(target)
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_removed_states
  #--------------------------------------------------------------------------
  alias window_battlelog_display_removed_states_abe display_removed_states
  def display_removed_states(target)
    return unless YEA::BATTLE::MSG_REMOVED_STATES
    window_battlelog_display_removed_states_abe(target)
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_changed_buffs
  #--------------------------------------------------------------------------
  alias window_battlelog_display_changed_buffs_abe display_changed_buffs
  def display_changed_buffs(target)
    return unless YEA::BATTLE::MSG_CHANGED_BUFFS
    window_battlelog_display_changed_buffs_abe(target)
  end
  
end # Window_BattleLog

#==============================================================================
# Å° Window_SkillList
#==============================================================================

class Window_SkillList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: spacing
  #--------------------------------------------------------------------------
  def spacing
    return 8 if $game_party.in_battle
    return super
  end
  
end # Window_SkillList

#==============================================================================
# Å° Window_ItemList
#==============================================================================

class Window_ItemList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: spacing
  #--------------------------------------------------------------------------
  def spacing
    return 8 if $game_party.in_battle
    return super
  end
  
end # Window_ItemList

#==============================================================================
# Å° Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :enemy_window
  attr_accessor :info_viewport
  attr_accessor :spriteset
  attr_accessor :status_window
  attr_accessor :status_aid_window
  attr_accessor :subject
  
  #--------------------------------------------------------------------------
  # alias method: create_spriteset
  #--------------------------------------------------------------------------
  alias scene_battle_create_spriteset_abe create_spriteset
  def create_spriteset
    BattleManager.init_battle_type
    scene_battle_create_spriteset_abe
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_basic
  #--------------------------------------------------------------------------
  alias scene_battle_update_basic_abe update_basic
  def update_basic
    scene_battle_update_basic_abe
    update_debug
  end
  
  #--------------------------------------------------------------------------
  # new method: update_debug
  #--------------------------------------------------------------------------
  def update_debug
    return unless $TEST || $BTEST
    debug_heal_party if Input.trigger?(:F5)
    debug_damage_party if Input.trigger?(:F6)
    debug_fill_tp if Input.trigger?(:F7)
    debug_kill_all if Input.trigger?(:F8)
  end
  
  #--------------------------------------------------------------------------
  # new method: debug_heal_party
  #--------------------------------------------------------------------------
  def debug_heal_party
    Sound.play_recovery
    for member in $game_party.battle_members
      member.recover_all
    end
    @status_window.refresh
  end
  
  #--------------------------------------------------------------------------
  # new method: debug_damage_party
  #--------------------------------------------------------------------------
  def debug_damage_party
    Sound.play_actor_damage
    for member in $game_party.alive_members
      member.hp = 1
      member.mp = 0
      member.tp = 0
    end
    @status_window.refresh
  end
  
  #--------------------------------------------------------------------------
  # new method: debug_fill_tp
  #--------------------------------------------------------------------------
  def debug_fill_tp
    Sound.play_recovery
    for member in $game_party.alive_members
      member.tp = member.max_tp
    end
    @status_window.refresh
  end
  
  #--------------------------------------------------------------------------
  # new method: debug_kill_all
  #--------------------------------------------------------------------------
  def debug_kill_all
    for enemy in $game_troop.alive_members
      enemy.hp = 0
      enemy.perform_collapse_effect
    end
    BattleManager.judge_win_loss
    @log_window.wait
    @log_window.wait_for_effect
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_all_windows
  #--------------------------------------------------------------------------
  alias scene_battle_create_all_windows_abe create_all_windows
  def create_all_windows
    scene_battle_create_all_windows_abe
    create_battle_status_aid_window
    set_help_window
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_info_viewport
  #--------------------------------------------------------------------------
  alias scene_battle_create_info_viewport_abe create_info_viewport
  def create_info_viewport
    scene_battle_create_info_viewport_abe
    @status_window.refresh
  end
  
  #--------------------------------------------------------------------------
  # new method: create_battle_status_aid_window
  #--------------------------------------------------------------------------
  def create_battle_status_aid_window
    @status_aid_window = Window_BattleStatusAid.new
    @status_aid_window.status_window = @status_window
    @status_aid_window.x = Graphics.width - @status_aid_window.width
    @status_aid_window.y = Graphics.height - @status_aid_window.height
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: create_help_window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_BattleHelp.new
    @help_window.hide
  end
  
  #--------------------------------------------------------------------------
  # new method: set_help_window
  #--------------------------------------------------------------------------
  def set_help_window
    @help_window.actor_window = @actor_window
    @help_window.enemy_window = @enemy_window
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_party_command_window
  #--------------------------------------------------------------------------
  alias scene_battle_create_party_command_window_abe create_party_command_window
  def create_party_command_window
    scene_battle_create_party_command_window_abe
    @party_command_window.set_handler(:dir6, method(:command_fight))
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_actor_command_window
  #--------------------------------------------------------------------------
  alias scene_battle_create_actor_command_window_abe create_actor_command_window
  def create_actor_command_window
    scene_battle_create_actor_command_window_abe
    @actor_command_window.set_handler(:dir4, method(:prior_command))
    @actor_command_window.set_handler(:dir6, method(:next_command))
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_skill_window
  #--------------------------------------------------------------------------
  alias scene_battle_create_skill_window_abe create_skill_window
  def create_skill_window
    scene_battle_create_skill_window_abe
    @skill_window.height = @info_viewport.rect.height
    @skill_window.width = Graphics.width - @actor_command_window.width
    @skill_window.y = Graphics.height - @skill_window.height
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_item_window
  #--------------------------------------------------------------------------
  alias scene_battle_create_item_window_abe create_item_window
  def create_item_window
    scene_battle_create_item_window_abe
    @item_window.height = @skill_window.height
    @item_window.width = @skill_window.width
    @item_window.y = Graphics.height - @item_window.height
  end
  
  #--------------------------------------------------------------------------
  # alias method: show_fast?
  #--------------------------------------------------------------------------
  alias scene_battle_show_fast_abe show_fast?
  def show_fast?
    return true if YEA::BATTLE::AUTO_FAST
    return scene_battle_show_fast_abe
  end
  
  #--------------------------------------------------------------------------
  # alias method: next_command
  #--------------------------------------------------------------------------
  alias scene_battle_next_command_abe next_command
  def next_command
    @status_window.show
    redraw_current_status
    @actor_command_window.show
    @status_aid_window.hide
    scene_battle_next_command_abe
  end
  
  #--------------------------------------------------------------------------
  # alias method: prior_command
  #--------------------------------------------------------------------------
  alias scene_battle_prior_command_abe prior_command
  def prior_command
    redraw_current_status
    scene_battle_prior_command_abe
  end
  
  #--------------------------------------------------------------------------
  # new method: redraw_current_status
  #--------------------------------------------------------------------------
  def redraw_current_status
    return if @status_window.index < 0
    @status_window.draw_item(@status_window.index)
  end
  
  #--------------------------------------------------------------------------
  # alias method: command_attack
  #--------------------------------------------------------------------------
  alias scene_battle_command_attack_abe command_attack
  def command_attack
    $game_temp.battle_aid = $data_skills[BattleManager.actor.attack_skill_id]
    scene_battle_command_attack_abe
  end
  
  #--------------------------------------------------------------------------
  # alias method: command_skill
  #--------------------------------------------------------------------------
  alias scene_battle_command_skill_abe command_skill
  def command_skill
    scene_battle_command_skill_abe
    @status_window.hide
    @actor_command_window.hide
    @status_aid_window.show
  end
  
  #--------------------------------------------------------------------------
  # alias method: command_item
  #--------------------------------------------------------------------------
  alias scene_battle_command_item_abe command_item
  def command_item
    scene_battle_command_item_abe
    @status_window.hide
    @actor_command_window.hide
    @status_aid_window.show
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: on_skill_ok
  #--------------------------------------------------------------------------
  def on_skill_ok
    @skill = @skill_window.item
    $game_temp.battle_aid = @skill
    BattleManager.actor.input.set_skill(@skill.id)
    BattleManager.actor.last_skill.object = @skill
    if @skill.for_opponent?
      select_enemy_selection
    elsif @skill.for_friend?
      select_actor_selection
    else
      @skill_window.hide
      next_command
      $game_temp.battle_aid = nil
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_skill_cancel
  #--------------------------------------------------------------------------
  alias scene_battle_on_skill_cancel_abe on_skill_cancel
  def on_skill_cancel
    scene_battle_on_skill_cancel_abe
    @status_window.show
    @actor_command_window.show
    @status_aid_window.hide
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: on_item_ok
  #--------------------------------------------------------------------------
  def on_item_ok
    @item = @item_window.item
    $game_temp.battle_aid = @item
    BattleManager.actor.input.set_item(@item.id)
    if @item.for_opponent?
      select_enemy_selection
    elsif @item.for_friend?
      select_actor_selection
    else
      @item_window.hide
      next_command
      $game_temp.battle_aid = nil
    end
    $game_party.last_item.object = @item
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_item_cancel
  #--------------------------------------------------------------------------
  alias scene_battle_on_item_cancel_abe on_item_cancel
  def on_item_cancel
    scene_battle_on_item_cancel_abe
    @status_window.show
    @actor_command_window.show
    @status_aid_window.hide
  end
  
  #--------------------------------------------------------------------------
  # alias method: select_actor_selection
  #--------------------------------------------------------------------------
  alias scene_battle_select_actor_selection_abe select_actor_selection
  def select_actor_selection
    @status_aid_window.refresh
    scene_battle_select_actor_selection_abe
    @status_window.hide
    @skill_window.hide
    @item_window.hide
    @help_window.show
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_actor_ok
  #--------------------------------------------------------------------------
  alias scene_battle_on_actor_ok_abe on_actor_ok
  def on_actor_ok
    $game_temp.battle_aid = nil
    scene_battle_on_actor_ok_abe
    @status_window.show
    if $imported["YEA-BattleCommandList"] && !@confirm_command_window.nil?
      @actor_command_window.visible = !@confirm_command_window.visible
    else
      @actor_command_window.show
    end
    @status_aid_window.hide
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_actor_cancel
  #--------------------------------------------------------------------------
  alias scene_battle_on_actor_cancel_abe on_actor_cancel
  def on_actor_cancel
    BattleManager.actor.input.clear
    @status_aid_window.refresh
    $game_temp.battle_aid = nil
    scene_battle_on_actor_cancel_abe
    case @actor_command_window.current_symbol
    when :skill
      @skill_window.show
    when :item
      @item_window.show
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: select_enemy_selection
  #--------------------------------------------------------------------------
  alias scene_battle_select_enemy_selection_abe select_enemy_selection
  def select_enemy_selection
    @status_aid_window.refresh
    scene_battle_select_enemy_selection_abe
    @help_window.show
  end
  #--------------------------------------------------------------------------
  # alias method: on_enemy_ok
  #--------------------------------------------------------------------------
  alias scene_battle_on_enemy_ok_abe on_enemy_ok
  def on_enemy_ok
    $game_temp.battle_aid = nil
    scene_battle_on_enemy_ok_abe
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_enemy_cancel
  #--------------------------------------------------------------------------
  alias scene_battle_on_enemy_cancel_abe on_enemy_cancel
  def on_enemy_cancel
    BattleManager.actor.input.clear
    @status_aid_window.refresh
    $game_temp.battle_aid = nil
    scene_battle_on_enemy_cancel_abe
    if @skill_window.visible || @item_window.visible
      @help_window.show
    else
      @help_window.hide
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: battle_start
  #--------------------------------------------------------------------------
  alias scene_battle_battle_start_abe battle_start
  def battle_start
    scene_battle_battle_start_abe
    return unless YEA::BATTLE::SKIP_PARTY_COMMAND
    @party_command_window.deactivate
    if BattleManager.input_start
      command_fight 
    else
      turn_start
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: turn_end
  #--------------------------------------------------------------------------
  def turn_end
    all_battle_members.each do |battler|
      battler.on_turn_end
      status_redraw_target(battler)
      @log_window.display_auto_affected_status(battler)
      @log_window.wait_and_clear
    end
    update_party_cooldowns if $imported["YEA-CommandParty"]
    BattleManager.turn_end
    process_event
    start_party_command_selection
    return if end_battle_conditions?
    return unless YEA::BATTLE::SKIP_PARTY_COMMAND
    if BattleManager.input_start
      @party_command_window.deactivate
      command_fight
    else
      @party_command_window.deactivate
      turn_start
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: end_battle_conditions?
  #--------------------------------------------------------------------------
  def end_battle_conditions?
    return true if $game_party.members.empty?
    return true if $game_party.all_dead?
    return true if $game_troop.all_dead?
    return true if BattleManager.aborting?
    return false
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: execute_action
  #--------------------------------------------------------------------------
  def execute_action
    @subject.sprite_effect_type = :whiten if YEA::BATTLE::FLASH_WHITE_EFFECT
    use_item
    @log_window.wait_and_clear
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: apply_item_effects
  #--------------------------------------------------------------------------
  def apply_item_effects(target, item)
    if $imported["YEA-LunaticObjects"]
      lunatic_object_effect(:prepare, item, @subject, target)
    end
    target.item_apply(@subject, item)
    status_redraw_target(@subject)
    status_redraw_target(target) unless target == @subject
    @log_window.display_action_results(target, item)
    if $imported["YEA-LunaticObjects"]
      lunatic_object_effect(:during, item, @subject, target)
    end
    perform_collapse_check(target)
  end
  
  #--------------------------------------------------------------------------
  # overwite method: invoke_counter_attack
  #--------------------------------------------------------------------------
  def invoke_counter_attack(target, item)
    @log_window.display_counter(target, item)
    attack_skill = $data_skills[target.attack_skill_id]
    @subject.item_apply(target, attack_skill)
    status_redraw_target(@subject)
    status_redraw_target(target) unless target == @subject
    @log_window.display_action_results(@subject, attack_skill)
    perform_collapse_check(target)
    perform_collapse_check(@subject)
  end
  
  #--------------------------------------------------------------------------
  # new method: perform_collapse_check
  #--------------------------------------------------------------------------
  def perform_collapse_check(target)
    return if YEA::BATTLE::MSG_ADDED_STATES
    target.perform_collapse_effect if target.can_collapse?
    @log_window.wait
    @log_window.wait_for_effect
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: show_attack_animation
  #--------------------------------------------------------------------------
  def show_attack_animation(targets)
    show_normal_animation(targets, @subject.atk_animation_id1, false)
    wait_for_animation
    show_normal_animation(targets, @subject.atk_animation_id2, true)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: show_normal_animation
  #--------------------------------------------------------------------------
  def show_normal_animation(targets, animation_id, mirror = false)
    animation = $data_animations[animation_id]
    return if animation.nil?
    ani_check = false
    targets.each do |target|
      if ani_check && target.animation_id <= 0
        target.pseudo_ani_id = animation_id
      else
        target.animation_id = animation_id
      end
      target.animation_mirror = mirror
      ani_check = true if animation.to_screen?
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: process_action_end
  #--------------------------------------------------------------------------
  def process_action_end
    @subject.on_action_end
    status_redraw_target(@subject)
    @log_window.display_auto_affected_status(@subject)
    @log_window.wait_and_clear
    @log_window.display_current_state(@subject)
    @log_window.wait_and_clear
    BattleManager.judge_win_loss
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: use_item
  #--------------------------------------------------------------------------
  def use_item
    item = @subject.current_action.item
    @log_window.display_use_item(@subject, item)
    @subject.use_item(item)
    status_redraw_target(@subject)
    if $imported["YEA-LunaticObjects"]
      lunatic_object_effect(:before, item, @subject, @subject)
    end
    process_casting_animation if $imported["YEA-CastAnimations"]
    targets = @subject.current_action.make_targets.compact rescue []
    show_animation(targets, item.animation_id) if show_all_animation?(item)
    targets.each {|target| 
      if $imported["YEA-TargetManager"]
        target = alive_random_target(target, item) if item.for_random?
      end
      item.repeats.times { invoke_item(target, item) } }
    if $imported["YEA-LunaticObjects"]
      lunatic_object_effect(:after, item, @subject, @subject)
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: invoke_item
  #--------------------------------------------------------------------------
  alias scene_battle_invoke_item_abe invoke_item
  def invoke_item(target, item)
    show_animation([target], item.animation_id) if separate_ani?(target, item)
    if target.dead? != item.for_dead_friend?
      @subject.last_target_index = target.index
      return
    end
    scene_battle_invoke_item_abe(target, item)
  end
  
  #--------------------------------------------------------------------------
  # new method: show_all_animation?
  #--------------------------------------------------------------------------
  def show_all_animation?(item)
    return true if item.one_animation
    return false if $data_animations[item.animation_id].nil?
    return false unless $data_animations[item.animation_id].to_screen?
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: separate_ani?
  #--------------------------------------------------------------------------
  def separate_ani?(target, item)
    return false if item.one_animation
    return false if $data_animations[item.animation_id].nil?
    return false if $data_animations[item.animation_id].to_screen?
    return target.dead? == item.for_dead_friend?
  end
  
  #--------------------------------------------------------------------------
  # new method: status_redraw_target
  #--------------------------------------------------------------------------
  def status_redraw_target(target)
    return unless target.actor?
    @status_window.draw_item($game_party.battle_members.index(target))
  end
  
  #--------------------------------------------------------------------------
  # alias method: start_party_command_selection
  #--------------------------------------------------------------------------
  alias start_party_command_selection_abe start_party_command_selection
  def start_party_command_selection
    @status_window.refresh unless scene_changing?
    start_party_command_selection_abe
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: refresh_status
  #--------------------------------------------------------------------------
  def refresh_status; return; end
  
  #--------------------------------------------------------------------------
  # new method: refresh_autobattler_status_window
  #--------------------------------------------------------------------------
  def refresh_autobattler_status_window
    for member in $game_party.battle_members
      next unless member.auto_battle?
      @status_window.draw_item(member.index)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: hide_extra_gauges
  #--------------------------------------------------------------------------
  def hide_extra_gauges
    # Made for compatibility
  end
  
  #--------------------------------------------------------------------------
  # new method: show_extra_gauges
  #--------------------------------------------------------------------------
  def show_extra_gauges
    # Made for compatibility
  end
  
end # Scene_Battle

#==============================================================================
# 
# Å• End of File
# 
#==============================================================================