#==============================================================================
# 
# ▼ Yanfly Engine Ace - Parameter Bonus Growth v1.00
# -- Last Updated: 2012.01.25
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ParameterBonusGrowth"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.25 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script provides a new custom trait for actors, classes, equipment, and
# even states. When an actor levels up with a parameter growth trait, they will
# permanently gain a bonus to that particular parameter. These bonuses are
# maintained even upon switching classes.
# 
# Note: Starting a new game with characters above level 1 does not trigger any
# stat growth bonuses.
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
# <stat growth: +x>
# <stat growth: -x>
# This causes the stat to grow by +x or -x upon the actor leveling up. All stat
# growth bonuses are cumulative across anything that provides this trait. x can
# be either an integer or a decimal. Replace stat with one of the following:
# MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the classes notebox in the database.
# -----------------------------------------------------------------------------
# <stat growth: +x>
# <stat growth: -x>
# This causes the stat to grow by +x or -x upon the actor leveling up. All stat
# growth bonuses are cumulative across anything that provides this trait. x can
# be either an integer or a decimal. Replace stat with one of the following:
# MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <stat growth: +x>
# <stat growth: -x>
# This causes the stat to grow by +x or -x upon the actor leveling up. All stat
# growth bonuses are cumulative across anything that provides this trait. x can
# be either an integer or a decimal. Replace stat with one of the following:
# MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armours notebox in the database.
# -----------------------------------------------------------------------------
# <stat growth: +x>
# <stat growth: -x>
# This causes the stat to grow by +x or -x upon the actor leveling up. All stat
# growth bonuses are cumulative across anything that provides this trait. x can
# be either an integer or a decimal. Replace stat with one of the following:
# MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <stat growth: +x>
# <stat growth: -x>
# This causes the stat to grow by +x or -x upon the actor leveling up. All stat
# growth bonuses are cumulative across anything that provides this trait. x can
# be either an integer or a decimal. Replace stat with one of the following:
# MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK
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
    
    PARAM_GROWTH = /<(.*)[ ](?:GROWTH|growth):[ ]\s*([-+]?\d+\.?\d*)>/i
    
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
  class <<self; alias load_database_pbg load_database; end
  def self.load_database
    load_database_pbg
    load_notetags_pbg
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_pbg
  #--------------------------------------------------------------------------
  def self.load_notetags_pbg
    groups = [$data_actors, $data_classes, $data_weapons, $data_armors,
      $data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_pbg
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
  attr_accessor :param_bonus_growth
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_pbg
  #--------------------------------------------------------------------------
  def load_notetags_pbg
    @param_bonus_growth = [0.0] * 8
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::PARAM_GROWTH
        case $1.upcase
        when "HP", "MAXHP", "MHP"
          @param_bonus_growth[0] = $2.to_f
        when "MP", "MAXMP", "MMP", "SP", "MAXSP", "MSP"
          @param_bonus_growth[1] = $2.to_f
        when "ATK"
          @param_bonus_growth[2] = $2.to_f
        when "DEF"
          @param_bonus_growth[3] = $2.to_f
        when "MAT", "INT", "SPI"
          @param_bonus_growth[4] = $2.to_f
        when "MDF", "RES"
          @param_bonus_growth[5] = $2.to_f
        when "AGI", "SPD"
          @param_bonus_growth[6] = $2.to_f
        when "LUK", "LUCK"
          @param_bonus_growth[7] = $2.to_f
        end
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
  # new method: param_bonus_growth
  #--------------------------------------------------------------------------
  def param_bonus_growth(param_id)
    n = 0.0
    if actor?
      n += self.actor.param_bonus_growth[param_id]
      n += self.class.param_bonus_growth[param_id]
      for equip in equips
        next if equip.nil?
        n += equip.param_bonus_growth[param_id]
      end
    end
    for state in states
      next if state.nil?
      n += state.param_bonus_growth[param_id]
    end
    return n
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: level_up
  #--------------------------------------------------------------------------
  alias game_actor_level_up_pbg level_up
  def level_up
    last_level = @level
    game_actor_level_up_pbg
    apply_param_bonus_growth if last_level != @level
  end
  
  #--------------------------------------------------------------------------
  # alias method: level_down
  #--------------------------------------------------------------------------
  alias game_actor_level_down_pbg level_down
  def level_down
    last_level = @level
    game_actor_level_down_pbg
    apply_param_bonus_growth(-1) if last_level != @level
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_param_bonus_growth
  #--------------------------------------------------------------------------
  def apply_param_bonus_growth(rate = 1)
    for i in 0...8 do @param_plus[i] += param_bonus_growth(i) * rate end
  end
  
end # Game_Actor

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================