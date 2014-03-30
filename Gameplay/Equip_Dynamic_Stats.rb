#==============================================================================
# 
# ▼ Yanfly Engine Ace - Equip Dynamic Stats v1.00
# -- Last Updated: 2012.01.05
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-EquipDynamicStats"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.05 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script allows for dynamic parameter bonuses acquired through equipment.
# These bonuses can come in the form of percentile bonuses based on the wearing
# actor's base stats or be based off of a variable.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <stat: +x>
# <stat: -x>
# Changes the stat bonus of the piece of equipment to yield +x or -x. Allows
# bonus to go over +500 and under -500. Replace stat with one of the following:
# MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK
# 
# <stat: +x%>
# <stat: -x%>
# Changes the stat bonus of the piece of equipment to yield +x% or -x% of the
# equipped user's base stat. Replace stat with one of the following:
# MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK
# 
# <stat variable: x>
# Changes the stat bonus to be modified by whatever variable x is. Replace stat
# with one of the following: 
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
  module EQUIPITEM
    
    STAT_SET = /<(.*):[ ]([\+\-]\d+)>/i
    STAT_PER = /<(.*):[ ]([\+\-]\d+)([%％])>/i
    STAT_VAR = /<(.*)[ ](?:VARIABLE|var):[ ](\d+)>/i
    
  end # EQUIPITEM
  end # REGEXP
end # YEA

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
  class <<self; alias load_database_eds load_database; end
  def self.load_database
    load_database_eds
    load_notetags_eds
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_eds
  #--------------------------------------------------------------------------
  def self.load_notetags_eds
    groups = [$data_weapons, $data_armors]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_eds
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::EquipItem
#==============================================================================

class RPG::EquipItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :per_params
  attr_accessor :var_params
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_eds
  #--------------------------------------------------------------------------
  def load_notetags_eds
    @per_params = [0] * 8
    @var_params = [0] * 8
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::EQUIPITEM::STAT_SET
        case $1.upcase
        when "HP", "MAXHP", "MHP"
          @params[0] = $2.to_i
        when "MP", "MAXMP", "MMP", "SP", "MAXSP", "MSP"
          @params[1] = $2.to_i
        when "ATK"
          @params[2] = $2.to_i
        when "DEF"
          @params[3] = $2.to_i
        when "MAT", "INT", "SPI"
          @params[4] = $2.to_i
        when "MDF", "RES"
          @params[5] = $2.to_i
        when "AGI", "SPD"
          @params[6] = $2.to_i
        when "LUK", "LUCK"
          @params[7] = $2.to_i
        end
      #---
      when YEA::REGEXP::EQUIPITEM::STAT_PER
        case $1.upcase
        when "HP", "MAXHP", "MHP"
          @per_params[0] = $2.to_i * 0.01
        when "MP", "MAXMP", "MMP", "SP", "MAXSP", "MSP"
          @per_params[1] = $2.to_i * 0.01
        when "ATK"
          @per_params[2] = $2.to_i * 0.01
        when "DEF"
          @per_params[3] = $2.to_i * 0.01
        when "MAT", "INT", "SPI"
          @per_params[4] = $2.to_i * 0.01
        when "MDF", "RES"
          @per_params[5] = $2.to_i * 0.01
        when "AGI", "SPD"
          @per_params[6] = $2.to_i * 0.01
        when "LUK", "LUCK"
          @per_params[7] = $2.to_i * 0.01
        end
      #---
      when YEA::REGEXP::EQUIPITEM::STAT_VAR
        case $1.upcase
        when "HP", "MAXHP", "MHP"
          @var_params[0] = $2.to_i
        when "MP", "MAXMP", "MMP", "SP", "MAXSP", "MSP"
          @var_params[1] = $2.to_i
        when "ATK"
          @var_params[2] = $2.to_i
        when "DEF"
          @var_params[3] = $2.to_i
        when "MAT", "INT", "SPI"
          @var_params[4] = $2.to_i
        when "MDF", "RES"
          @var_params[5] = $2.to_i
        when "AGI", "SPD"
          @var_params[6] = $2.to_i
        when "LUK", "LUCK"
          @var_params[7] = $2.to_i
        end
      end
    } # self.note.split
    #---
  end
  
  #--------------------------------------------------------------------------
  # new method: bonus_performance
  #--------------------------------------------------------------------------
  def bonus_performance
    n = 0
    n += bonus_per_params
    n += bonus_var_params
    return n
  end
  
  #--------------------------------------------------------------------------
  # new method: bonus_per_params
  #--------------------------------------------------------------------------
  def bonus_per_params
    return 0 if $game_temp.nil? || $game_temp.eds_actor.nil?
    n = 0
    actor = $game_temp.eds_actor
    for i in 0...8; n += @per_params[i] * actor.param_base(i); end
    return n
  end
  
  #--------------------------------------------------------------------------
  # new method: bonus_var_params
  #--------------------------------------------------------------------------
  def bonus_var_params
    return 0 if $game_variables.nil?
    n = 0
    for i in 0...8; n += $game_variables[@var_params[i]] rescue 0; end
    return n
  end
  
end # RPG::EquipItem

#==============================================================================
# ■ RPG::Weapon
#==============================================================================

class RPG::Weapon < RPG::EquipItem
  
  #--------------------------------------------------------------------------
  # alias method: performance
  #--------------------------------------------------------------------------
  alias rpg_weapon_performance_eds performance
  def performance
    n = rpg_weapon_performance_eds
    n += bonus_performance
    return n
  end
  
end # RPG::Weapon

#==============================================================================
# ■ Game_Temp
#==============================================================================

class Game_Temp
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :eds_actor
  
end # Game_Temp

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: param_plus
  #--------------------------------------------------------------------------
  alias game_actor_param_plus_eds param_plus
  def param_plus(param_id)
    n = game_actor_param_plus_eds(param_id)
    n += (percent_parameter_rate(param_id) * param_base(param_id)).to_i
    n += variable_parameter_bonus(param_id)
    return n
  end
  
  #--------------------------------------------------------------------------
  # new method: percent_parameter_rate
  #--------------------------------------------------------------------------
  def percent_parameter_rate(param_id)
    rate = 0.0
    rate += equips.compact.inject(0) {|r, i| 
      r += i.per_params[param_id] rescue 0 }
    return rate
  end
  
  #--------------------------------------------------------------------------
  # new method: variable_parameter_bonus
  #--------------------------------------------------------------------------
  def variable_parameter_bonus(param_id)
    n = 0
    n += equips.compact.inject(0) {|r, i| 
      r += $game_variables[i.var_params[param_id]] rescue 0 }
    return n
  end
  
  #--------------------------------------------------------------------------
  # alias method: optimize_equipments
  #--------------------------------------------------------------------------
  alias game_actor_optimize_equipments_eds optimize_equipments
  def optimize_equipments
    $game_temp.eds_actor = self
    game_actor_optimize_equipments_eds
    $game_temp.eds_actor = nil
  end
  
end # Game_Actor

#==============================================================================
# ■ Window_ShopStatus
#==============================================================================

class Window_ShopStatus < Window_Base
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_param_change
  #--------------------------------------------------------------------------
  def draw_actor_param_change(x, y, actor, item1)
    rect = Rect.new(x, y, contents.width - 4 - x, line_height)
    change = actor_param_change_value(actor, item1)
    change_color(param_change_color(change))
    text = change.group
    text = "+" + text if change >= 0
    draw_text(rect, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # new method: actor_param_change_value
  #--------------------------------------------------------------------------
  def actor_param_change_value(actor, item1)
    n = @item.params[param_id] - (item1 ? item1.params[param_id] : 0)
    n += @item.per_params[param_id] * actor.param_base(param_id) rescue 0
    n += $game_variables[@item.var_params[param_id]] rescue 0
    n -= item1.per_params[param_id] * actor.param_base(param_id) rescue 0
    n -= $game_variables[item1.var_params[param_id]] rescue 0
    return n
  end
  
end # Window_ShopStatus

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================