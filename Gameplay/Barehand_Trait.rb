#==============================================================================
# 
# ▼ Yanfly Engine Ace - Barehand Trait v1.00
# -- Last Updated: 2012.01.15
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-BarehandTrait"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.15 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Some classes are geared more towards barehanded fighting more than with any
# weapons equipped. This script provides the ability for actors or classes to
# achieve this trait. This trait can also be added to equipment to give them a
# a barehanded trait, too. If a weapon is applied with the barehand trait, it
# will count as a barehanded "weapon".
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
# <barehand>
# Grants the barehand trait to the actor. If the actor has no weapons equipped
# or a weapon with the barehand trait, then the actor acquires the barehanded
# status and the base stat then works with the formula found within the module.
# Optimizing equipment does not factor in barehand.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the classes notebox in the database.
# -----------------------------------------------------------------------------
# <barehand>
# Grants the barehand trait to the actor. If the actor has no weapons equipped
# or a weapon with the barehand trait, then the actor acquires the barehanded
# status and the base stat then works with the formula found within the module.
# Optimizing equipment does not factor in barehand.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <barehand>
# Grants the barehand trait to the actor. If the actor has no weapons equipped
# or a weapon with the barehand trait, then the actor acquires the barehanded
# status and the base stat then works with the formula found within the module.
# Optimizing equipment does not factor in barehand.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armour notebox in the database.
# -----------------------------------------------------------------------------
# <barehand>
# Grants the barehand trait to the actor. If the actor has no weapons equipped
# or a weapon with the barehand trait, then the actor acquires the barehanded
# status and the base stat then works with the formula found within the module.
# Optimizing equipment does not factor in barehand.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <barehand>
# Grants the barehand trait to the actor. If the actor has no weapons equipped
# or a weapon with the barehand trait, then the actor acquires the barehanded
# status and the base stat then works with the formula found within the module.
# Optimizing equipment does not factor in barehand.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# Note that if you are using Ace Equip Engine, this script will be pointless if
# you decide to remove the ability to unequip weapons. This script also ignores
# barehanded options for optimization.
# 
#==============================================================================

module YEA
  module BAREHAND
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Formula Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Here, you can adjust how being barehanded can affect the primary stats.
    # Change the formulas below to as you see fit. If you do not wish to change
    # a formula, leave the formula as "base".
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    STAT_FORMULA ={
      :maxhp => "base",
      :maxmp => "base",
      :atk   => "base + 10 * @level * 1.5",
      :def   => "base",
      :mat   => "base",
      :mdf   => "base",
      :agi   => "base + 5 * @level * 1.1",
      :luk   => "base",
    } # Do not remove this.
    
  end # BAREHAND
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    BAREHAND = /<(?:BAREHAND|bare hand)>/i
    
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
  class <<self; alias load_database_barehand load_database; end
  def self.load_database
    load_database_barehand
    load_notetags_barehand
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_barehand
  #--------------------------------------------------------------------------
  def self.load_notetags_barehand
    groups = [$data_actors, $data_classes, $data_weapons, $data_armors,
      $data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_barehand
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
  attr_accessor :barehand
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_barehand
  #--------------------------------------------------------------------------
  def load_notetags_barehand
    @barehand = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::BAREHAND
        @barehand = true
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
  # new method: barehand?
  #--------------------------------------------------------------------------
  def barehand?
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: barehand_conditions_met?
  #--------------------------------------------------------------------------
  def barehand_conditions_met?
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: barehand_weapon_conditions_met?
  #--------------------------------------------------------------------------
  def barehand_weapon_conditions_met?
    return false
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: barehand?
  #--------------------------------------------------------------------------
  def barehand?
    return true if self.actor.barehand
    return true if self.class.barehand
    for equip in equips
      next if equip.nil?
      return true if equip.barehand
    end
    for state in states
      next if state.nil?
      return true if state.barehand
    end
    return super
  end
  
  #--------------------------------------------------------------------------
  # new method: barehand_conditions_met?
  #--------------------------------------------------------------------------
  def barehand_conditions_met?
    return super unless barehand?
    return super unless barehand_weapon_conditions_met?
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: barehand_weapon_conditions_met?
  #--------------------------------------------------------------------------
  def barehand_weapon_conditions_met?
    for weapon in weapons
      next if weapon.nil?
      return true if weapon.barehand
    end
    return weapons.size <= 0
  end
  
  #--------------------------------------------------------------------------
  # alias method: param_base
  #--------------------------------------------------------------------------
  alias game_actor_param_base_barehand param_base
  def param_base(param_id)
    base = game_actor_param_base_barehand(param_id)
    return base unless barehand_conditions_met?
    return barehand_base_param(param_id, base)
  end
  
  #--------------------------------------------------------------------------
  # new method: barehand_base_param
  #--------------------------------------------------------------------------
  def barehand_base_param(param_id, base)
    case param_id
    when 0; type = :maxhp
    when 1; type = :maxmp
    when 2; type = :atk
    when 3; type = :def
    when 4; type = :mat
    when 5; type = :mdf
    when 6; type = :agi
    else;   type = :luk
    end
    formula = YEA::BAREHAND::STAT_FORMULA[type]
    return eval(formula).to_i
  end
  
end # Game_Actor

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================