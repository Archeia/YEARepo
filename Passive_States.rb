#==============================================================================
# 
# ▼ Yanfly Engine Ace - Passive States v1.02
# -- Last Updated: 2012.01.23
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-PassiveStates"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.23 - Compatibility Update: Doppelganger
# 2012.01.08 - Added passive state checks for adding/removing states.
# 2011.12.14 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script allows for actors, classes, weapons, armours, and enemies to have
# passives that are based off of states. Passive states will be active at all
# times and are immune to restrictions and will only disappear if the battler
# dies. Once the battler revives, the passives will return.
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
# <passive state: x>
# <passive state: x, x>
# This will cause state x to be always on (unless the battler is dead). To have
# multiple passives, insert multiples of this notetag.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <passive state: x>
# <passive state: x, x>
# This will cause state x to be always on (unless the battler is dead). To have
# multiple passives, insert multiples of this notetag.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <passive state: x>
# <passive state: x, x>
# This will cause state x to be always on (unless the battler is dead). To have
# multiple passives, insert multiples of this notetag.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armours notebox in the database.
# -----------------------------------------------------------------------------
# <passive state: x>
# <passive state: x, x>
# This will cause state x to be always on (unless the battler is dead). To have
# multiple passives, insert multiples of this notetag.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemies notebox in the database.
# -----------------------------------------------------------------------------
# <passive state: x>
# <passive state: x, x>
# This will cause state x to be always on (unless the battler is dead). To have
# multiple passives, insert multiples of this notetag.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    PASSIVE_STATE = 
      /<(?:PASSIVE_STATE|passive state):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
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
  class <<self; alias load_database_pst load_database; end
  def self.load_database
    load_database_pst
    load_notetags_pst
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_pst
  #--------------------------------------------------------------------------
  def self.load_notetags_pst
    groups = [$data_actors, $data_classes, $data_weapons, $data_armors,
      $data_enemies]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_pst
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::BaseItem
#==============================================================================

class RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :passive_states
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_pst
  #--------------------------------------------------------------------------
  def load_notetags_pst
    @passive_states = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::PASSIVE_STATE
        $1.scan(/\d+/).each { |num| 
        @passive_states.push(num.to_i) if num.to_i > 0 }
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: state?
  #--------------------------------------------------------------------------
  alias game_battlerbase_state_check_pst state?
  def state?(state_id)
    return true if passive_state?(state_id)
    return game_battlerbase_state_check_pst(state_id)
  end
  
  #--------------------------------------------------------------------------
  # alias method: states
  #--------------------------------------------------------------------------
  alias game_battlerbase_states_pst states
  def states
    array = game_battlerbase_states_pst
    array |= passive_states
    return array
  end
  
  #--------------------------------------------------------------------------
  # new method: passive_state?
  #--------------------------------------------------------------------------
  def passive_state?(state_id)
    @passive_states = [] if @passive_states.nil?
    return @passive_states.include?(state_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: passive_states
  #--------------------------------------------------------------------------
  def passive_states
    array = []
    if actor?
      for state_id in self.actor.passive_states
        array.push($data_states[state_id]) if passive_state_addable?(state_id)
      end
      for state_id in self.class.passive_states
        array.push($data_states[state_id]) if passive_state_addable?(state_id)
      end
      for equip in equips
        next if equip.nil?
        for state_id in equip.passive_states
          array.push($data_states[state_id]) if passive_state_addable?(state_id)
        end
      end
    else # enemy
      for state_id in self.enemy.passive_states
        array.push($data_states[state_id]) if passive_state_addable?(state_id)
      end
      if $imported["YEA-Doppelganger"] && !self.class.nil?
        for state_id in self.class.passive_states
          array.push($data_states[state_id]) if passive_state_addable?(state_id)
        end
      end
    end
    create_passive_state_array(array)
    sort_passive_states(array)
    set_passive_state_turns(array)
    return array
  end
  
  #--------------------------------------------------------------------------
  # new method: create_passive_state_array
  #--------------------------------------------------------------------------
  def create_passive_state_array(array)
    @passive_states = []
    for state in array
      @passive_states.push(state.id)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: passive_state_addable?
  #--------------------------------------------------------------------------
  def passive_state_addable?(state_id)
    return false if $data_states[state_id].nil?
    return alive?
  end
  
  #--------------------------------------------------------------------------
  # new method: set_passive_state_turns
  #--------------------------------------------------------------------------
  def sort_passive_states(array)
    array.sort! do |state_a, state_b|
      if state_a.priority != state_b.priority
        state_b.priority <=> state_a.priority
      else
        state_a.id <=> state_b.id
      end
    end
    return array
  end
  
  #--------------------------------------------------------------------------
  # new method: set_passive_state_turns
  #--------------------------------------------------------------------------
  def set_passive_state_turns(array)
    for state in array
      @state_turns[state.id] = 0 unless @states.include?(state.id)
      @state_steps[state.id] = 0 unless @states.include?(state.id)
    end
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: state_addable?
  #--------------------------------------------------------------------------
  alias game_battler_state_addable_ps state_addable?
  def state_addable?(state_id)
    return false if passive_state?(state_id)
    return game_battler_state_addable_ps(state_id)
  end
  
  #--------------------------------------------------------------------------
  # alias method: remove_state
  #--------------------------------------------------------------------------
  alias game_battler_remove_state_ps remove_state
  def remove_state(state_id)
    return if passive_state?(state_id)
    game_battler_remove_state_ps(state_id)
  end
  
end # Game_Battler

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================