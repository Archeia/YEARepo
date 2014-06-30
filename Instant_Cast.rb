#==============================================================================
# 
# ▼ Yanfly Engine Ace - Instant Cast v1.03
# -- Last Updated: 2012.07.17
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-InstantCast"] = true

#==============================================================================
# ▼  Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.07.17 - Instant doesn't take up a turn if a characterh as additional 
#              actions/can attack twice.
# 2012.01.12 - Anti-crash methods implemented.
# 2011.12.26 - Bug Fixed: If actor gets stunned while doing an instant cast,
#              the actor will not be reselected.
# 2011.12.21 - Started Script and Finished.
# 
#==============================================================================
# ▼  Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# From the VX Yanfly Engines, instant cast properties have been a staple skill
# and item property. Instant cast makes a return in RPG Maker VX Ace. There's
# a few changes made with instant casts.
# 
# 1) For actors with multiple actions, instants will only occur if the first
#    action is an instant. If the first action is not an instant the follow-up
#    actions contain an instant, the instant will be treated as normal.
# 
# 2) Any actions added on by instants will automatically trigger immediately
#    after the instant finishes and will be treated as instants. This includes
#    Active Chain Skills triggering from an instant.
# 
# 3) If an enemy uses an instant, the enemy will gain an additional skill to
#    use after using the said instant. This will apply whenever an enemy uses
#    an instant skill, even if it was after the enemy's first action.
# 
#==============================================================================
# ▼  Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼  Materials/‘fÞ but above ▼  Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <instant>
# Causes the action to be an instant action. If an instant action is selected
# first, then the action will be performed before the battle phase starts. If
# placed behind a non-instant action, the would-be instant action will be
# considered a normal action. If an enemy uses an instant action, no matter if
# it was used first or after, the enemy gains an additional action.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <instant>
# Causes the action to be an instant action. If an instant action is selected
# first, then the action will be performed before the battle phase starts. If
# placed behind a non-instant action, the would-be instant action will be
# considered a normal action. If an enemy uses an instant action, no matter if
# it was used first or after, the enemy gains an additional action.
# 
#==============================================================================
# ▼  Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script is compatible with Yanfly Engine Ace - Ace Battle Engine v1.00+.
# Place this script under Ace Battle Engine in the script listing
# 
#==============================================================================
# ▼  Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module USABLEITEM
    
    INSTANT = /<(?:INSTANT|instant)>/i
    
  end # USABLEITEM
  end # REGEXP
end # YEA

#==============================================================================
# ¡ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_instant load_database; end
  def self.load_database
    load_database_instant
    load_notetags_instant
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_instant
  #--------------------------------------------------------------------------
  def self.load_notetags_instant
    groups = [$data_skills, $data_items]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_instant
      end
    end
  end
  
end # DataManager

#==============================================================================
# ¡ RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :instant
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_instant
  #--------------------------------------------------------------------------
  def load_notetags_instant
    @instant = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::INSTANT
        @instant = true
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::UsableItem

#==============================================================================
# ¡ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: check_instant_action
  #--------------------------------------------------------------------------
  def check_instant_action
    @backup_actions_instant = []
    @actions.each { |action|
      next unless action
      if action.item.nil?
        @backup_actions_instant.push(action.dup)
        next
      end
      unless action.item.instant
        @backup_actions_instant.push(action.dup)
        action.clear
      end
    }
  end
  
  #--------------------------------------------------------------------------
  # new method: restore_instant_action
  #--------------------------------------------------------------------------
  def restore_instant_action
    @backup_actions_instant.each_index { |i|
      @actions[i] = @backup_actions_instant[i]
    }
    @backup_actions_instant.clear
    i = 0
    @actions.each { |action| if action.item.nil?; break; end; i += 1 } 
    @action_input_index = i
  end
  
end # Game_Actor

#==============================================================================
# ¡ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: add_extra_action
  #--------------------------------------------------------------------------
  def add_extra_action
    action_list = enemy.actions.select {|a| action_valid?(a) }
    return if action_list.empty?
    rating_max = action_list.collect {|a| a.rating }.max
    rating_zero = rating_max - 3
    action_list.reject! {|a| a.rating <= rating_zero }
    action = Game_Action.new(self)
    action.set_enemy_action(select_enemy_action(action_list, rating_zero))
    @actions.push(action)
  end
  
end # Game_Enemy

#==============================================================================
# ¡ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: next_command
  #--------------------------------------------------------------------------
  alias scene_battle_next_command_instant next_command
  def next_command
    if instant_action?
      perform_instant_action
    else
      scene_battle_next_command_instant
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: instant_action?
  #--------------------------------------------------------------------------
  def instant_action?
    return false if BattleManager.actor.nil?
    return false if BattleManager.actor.input.nil?
    action = BattleManager.actor.input.item
    return false if action.nil?
    return action.instant
  end
  
  #--------------------------------------------------------------------------
  # new method: perform_instant_action
  #--------------------------------------------------------------------------
  def perform_instant_action
    hide_instant_action_windows
    @subject = BattleManager.actor
    @subject.check_instant_action
    execute_action if @subject.current_action.valid?
    process_event
    loop do
      @subject.remove_current_action
      break if $game_troop.all_dead?
      break unless @subject.current_action
      @subject.current_action.prepare
      execute_action if @subject.current_action.valid?
    end
    process_action_end
    @subject.make_actions
    @subject.restore_instant_action
    @subject = nil
    show_instant_action_windows
  end
  
  #--------------------------------------------------------------------------
  # new method: hide_instant_action_windows
  #--------------------------------------------------------------------------
  def hide_instant_action_windows
    if $imported["YEA-BattleEngine"]
      @info_viewport.visible = true
      @status_aid_window.hide
      @status_window.show
      @actor_command_window.show
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: show_instant_action_windows
  #--------------------------------------------------------------------------
  def show_instant_action_windows
    if $imported["YEA-BattleEngine"]
      @info_viewport.visible = true
    end
    start_actor_command_selection
    status_redraw_target(BattleManager.actor)
    next_command unless BattleManager.actor.inputable?
  end
  
  #--------------------------------------------------------------------------
  # new method: status_redraw_target
  #--------------------------------------------------------------------------
  def status_redraw_target(target)
    return unless target.actor?
    @status_window.draw_item($game_party.battle_members.index(target))
  end
  
  #--------------------------------------------------------------------------
  # alias method: execute_action
  #--------------------------------------------------------------------------
  alias scene_battle_execute_action_instant execute_action
  def execute_action
    scene_battle_execute_action_instant
    enemy_add_actions
  end
  
  #--------------------------------------------------------------------------
  # new method: enemy_add_actions
  #--------------------------------------------------------------------------
  def enemy_add_actions
    return if @subject.actor?
    return if @subject.current_action.nil?
    return if @subject.current_action.item.nil?
    return unless @subject.current_action.item.instant
    @subject.add_extra_action
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼  End of File
# 
#==============================================================================