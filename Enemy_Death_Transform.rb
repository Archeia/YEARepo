#==============================================================================
# 
# ▼ Yanfly Engine Ace - Enemy Death Transform v1.01
# -- Last Updated: 2012.04.10
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-EnemyDeathTransform"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.04.10 - Randomizer bugfix thanks to Modern Algebra.
# 2012.02.09 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script allows enemies to transform into another monster when they die.
# Although this is easily evented, this script is made to save the tediousness
# of applying that to every enemy and to allow the transforming sequence to be
# a lot smoother.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemy notebox in the database.
# -----------------------------------------------------------------------------
# <death transform: x>
# Sets the current enemy type to transform into enemy x upon death.
# 
# <death transform rate: x%>
# Sets the transform rate for the current enemy to be x%. If the previous tag
# is not used, then this notetag has no effect. If this notetag isn't present,
# the transform rate will be 100% by default.
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
  module ENEMY
    
    DEATH_TRANSFORM = /<(?:DEATH_TRANSFORM|death transform):[ ](\d+)>/i
    DEATH_TRANSFORM_RATE = 
      /<(?:DEATH_TRANSFORM_RATE|death transform rate):[ ](\d+)([%％])>/i
      
  end # ENEMY
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_edt load_database; end
  def self.load_database
    load_database_edt
    load_notetags_edt
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_edt
  #--------------------------------------------------------------------------
  def self.load_notetags_edt
    for obj in $data_enemies
      next if obj.nil?
      obj.load_notetags_edt
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Enemy
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :death_transform
  attr_accessor :death_transform_rate
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_edt
  #--------------------------------------------------------------------------
  def load_notetags_edt
    @death_transform = 0
    @death_transform_rate = 1.0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ENEMY::DEATH_TRANSFORM
        @death_transform = $1.to_i
      when YEA::REGEXP::ENEMY::DEATH_TRANSFORM_RATE
        @death_transform_rate = $1.to_i * 0.01
      end
    } # self.note.split
    #---
  end
  
end # RPG::Enemy

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: die
  #--------------------------------------------------------------------------
  alias game_battler_die_edt die
  def die
    return death_transform if meet_death_transform_requirements?
    game_battler_die_edt
  end
  
  #--------------------------------------------------------------------------
  # new method: meet_death_transform_requirements?
  #--------------------------------------------------------------------------
  def meet_death_transform_requirements?
    return false unless enemy?
    return false unless enemy.death_transform > 0
    return false if $data_enemies[enemy.death_transform].nil?
    return rand < enemy.death_transform_rate
  end
  
  #--------------------------------------------------------------------------
  # new method: death_transform
  #--------------------------------------------------------------------------
  def death_transform
    transform(enemy.death_transform)
    self.hp = mhp
    self.mp = mmp
    @sprite_effect_type = :whiten
  end
  
end # Game_Battler

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================