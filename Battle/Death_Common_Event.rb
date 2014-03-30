#==============================================================================
# 
# ▼ Yanfly Engine Ace - Death Common Events v1.01
# -- Last Updated: 2012.02.03
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-DeathCommonEvents"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.02.03 - New Feature: Wipe Out Event constant added.
# 2012.01.24 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script causes the battle to run a common event upon a specific actor,
# class, or enemy dying and running the collapsing effect. The common event
# will run immediately upon death rather than waiting for the remainder of the
# action to finish.
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
# <death event: x>
# This causes the actor to run common event x upon death. The death event made
# for the actor will take priority over the death event made for the class.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <death event: x>
# This causes the class to run common event x upon death. The death event made
# for the actor will take priority over the death event made for the class.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemies notebox in the database.
# -----------------------------------------------------------------------------
# <death event: x>
# This causes the enemy to run common event x upon death.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module DEATH_EVENTS
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Party Death Events -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # For those who would like a common event to run during battle when the
    # party wipes out, change the following constant below to the common event
    # ID to be used. If you do not wish to use an event for party wipes, set
    # the following constant to 0.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    WIPE_OUT_EVENT = 0
    
  end # DEATH_EVENTS
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    DEATH_EVENT = /<(?:DEATH_EVENT|death event):[ ](\d+)>/i
    
  end # BASEITEM
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_dce load_database; end
  def self.load_database
    load_database_dce
    load_notetags_dce
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_dce
  #--------------------------------------------------------------------------
  def self.load_notetags_dce
    groups = [$data_actors, $data_classes, $data_enemies]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_dce
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ BattleManager
#==============================================================================

module BattleManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias process_defeat_dce process_defeat; end
  def self.process_defeat
    if SceneManager.scene_is?(Scene_Battle)
      SceneManager.scene.process_party_wipe_event
    end
    return unless $game_party.all_dead?
    process_defeat_dce
  end
  
end # BattleManager

#==============================================================================
# ■ RPG::BaseItem
#==============================================================================

class RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :death_event_id
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_dce
  #--------------------------------------------------------------------------
  def load_notetags_dce
    @death_event_id = 0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::DEATH_EVENT
        @death_event_id = $1.to_i
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # new method: death_event_id
  #--------------------------------------------------------------------------
  def death_event_id
    return 0
  end
  
end # Game_Battler

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: death_event_id
  #--------------------------------------------------------------------------
  def death_event_id
    return self.actor.death_event_id unless self.actor.death_event_id == 0
    return self.class.death_event_id
  end
  
  #--------------------------------------------------------------------------
  # alias method: perform_collapse_effect
  #--------------------------------------------------------------------------
  alias game_actor_perform_collapse_effect_dce perform_collapse_effect
  def perform_collapse_effect
    game_actor_perform_collapse_effect_dce
    return unless SceneManager.scene_is?(Scene_Battle)
    SceneManager.scene.process_death_event(self)
  end
  
end # Game_Actor

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: death_event_id
  #--------------------------------------------------------------------------
  def death_event_id
    if $imported["YEA-Doppelganger"] && !self.class.nil?
      return self.class.death_event_id unless self.class.death_event_id == 0
    end
    return self.enemy.death_event_id
  end
  
  #--------------------------------------------------------------------------
  # alias method: perform_collapse_effect
  #--------------------------------------------------------------------------
  alias game_enemy_perform_collapse_effect_dce perform_collapse_effect
  def perform_collapse_effect
    game_enemy_perform_collapse_effect_dce
    return unless SceneManager.scene_is?(Scene_Battle)
    SceneManager.scene.process_death_event(self)
  end
  
end # Game_Enemy

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # new method: process_death_event
  #--------------------------------------------------------------------------
  def process_death_event(target)
    return unless target.dead?
    return if target.death_event_id == 0
    $game_temp.reserve_common_event(target.death_event_id)
    process_death_common_event
  end
  
  #--------------------------------------------------------------------------
  # new method: process_party_wipe_event
  #--------------------------------------------------------------------------
  def process_party_wipe_event
    return unless $game_party.all_dead?
    return if YEA::DEATH_EVENTS::WIPE_OUT_EVENT <= 0
    $game_temp.reserve_common_event(YEA::DEATH_EVENTS::WIPE_OUT_EVENT)
    process_death_common_event
  end
  
  #--------------------------------------------------------------------------
  # new method: process_death_common_event
  #--------------------------------------------------------------------------
  def process_death_common_event
    while !scene_changing?
      $game_troop.interpreter.update
      $game_troop.setup_battle_event
      wait_for_message
      wait_for_effect if $game_troop.all_dead?
      process_forced_action
      break unless $game_troop.interpreter.running?
      update_for_wait
    end
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================