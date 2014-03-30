#==============================================================================
# 
# ▼ Yanfly Engine Ace - Element Absorb v1.01
# -- Last Updated: 2012.01.23
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-Element Absorb"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.23 - Compatibility Update: Doppelganger
# 2011.12.14 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Absorbing elements have been taken out of RPG Maker VX Ace despite being a
# possible feature in the past RPG Maker iterations. This script brings back
# the ability to absorb elemental rates by applying them as traits for actors,
# classes, weapons, armours, enemies, and states.
# 
# If a target is inherently strong against the element absorbed, then more
# will be absorbed. If the target is inherently weak to the element absorbed,
# then less will be absorbed. The rate of which absorption takes effect is
# dependent on the target's natural affinity to the element.
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
# <element absorb: x>
# <element absorb: x, x>
# Grants a trait to absorb element x and heal the battler.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <element absorb: x>
# <element absorb: x, x>
# Grants a trait to absorb element x and heal the battler.
# 
# -----------------------------------------------------------------------------
# Weapons Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <element absorb: x>
# <element absorb: x, x>
# Grants a trait to absorb element x and heal the battler.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armours notebox in the database.
# -----------------------------------------------------------------------------
# <element absorb: x>
# <element absorb: x, x>
# Grants a trait to absorb element x and heal the battler.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemies notebox in the database.
# -----------------------------------------------------------------------------
# <element absorb: x>
# <element absorb: x, x>
# Grants a trait to absorb element x and heal the battler.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <element absorb: x>
# <element absorb: x, x>
# Grants a trait to absorb element x and heal the battler.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module ELEMENT_ABSORB
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Absorption Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Here, you can change how the game handles absorption when there are
    # multiple elements being calculated. If the following setting is set to
    # true, then the absorption takes priority. If false, then absorption is
    # ignored and the damage is calculated normally.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MULTI_ELEMENT_ABSORB_PRIORITY = true
    
  end # ELEMENT_ABSORB
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    ELE_ABSORB = /<(?:ELEMENT_ABSORB|element absorb):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
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
  class <<self; alias load_database_eabs load_database; end
  def self.load_database
    load_database_eabs
    load_notetags_eabs
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_eabs
  #--------------------------------------------------------------------------
  def self.load_notetags_eabs
    groups = [$data_actors, $data_classes, $data_weapons, $data_armors,
      $data_enemies, $data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_eabs
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
  attr_accessor :element_absorb
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_eabs
  #--------------------------------------------------------------------------
  def load_notetags_eabs
    @element_absorb = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::ELE_ABSORB
        $1.scan(/\d+/).each { |num| 
        @element_absorb.push(num.to_i) if num.to_i > 0 }
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
  # alias method: element_rate
  #--------------------------------------------------------------------------
  alias game_battler_element_rate_eabs element_rate
  def element_rate(element_id)
    result = game_battler_element_rate_eabs(element_id)
    if element_absorb?(element_id)
      result = [result - 2.0, -0.01].min
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # new method: element_absorb?
  #--------------------------------------------------------------------------
  def element_absorb?(element_id)
    if actor?
      return true if self.actor.element_absorb.include?(element_id)
      return true if self.class.element_absorb.include?(element_id)
      for equip in equips
        next if equip.nil?
        return true if equip.element_absorb.include?(element_id)
      end
    else
      return true if self.enemy.element_absorb.include?(element_id)
      if $imported["YEA-Doppelganger"] && !self.class.nil?
        return true if self.class.element_absorb.include?(element_id)
      end
    end
    for state in states
      next if state.nil?
      return true if state.element_absorb.include?(element_id)
    end
    return false
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: elements_max_rate
  #--------------------------------------------------------------------------
  alias game_battler_elements_max_rate_eabs elements_max_rate
  def elements_max_rate(elements)
    result = game_battler_elements_max_rate_eabs(elements)
    if YEA::ELEMENT_ABSORB::MULTI_ELEMENT_ABSORB_PRIORITY
      for element_id in elements
        next unless element_absorb?(element_id)
        result = [result - 2.0, -0.01].min
        return result
      end
    end
    return result
  end
  
end # Game_Battler

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================