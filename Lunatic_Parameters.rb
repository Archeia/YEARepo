#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic Parameters v1.01
# -- Last Updated: 2012.01.27
# -- Level: Lunatic
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LunaticParameters"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.27 - Bug Fixed: Wrong target during actions.
# 2012.01.26 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Lunatic mode effects have always been a core part of Yanfly Engine scripts.
# They exist to provide more effects for those who want more power and control
# for their items, skills, status effects, etc., but the users must be able to
# add them in themselves. 
# 
# Lunatic Parameters allows parameters to get custom temporary gains during
# battle. These parameter bonuses are applied through custom lunatic traits
# given to actors, classes, weapons, equips, enemies, and states. Once again,
# keep in mind that these gains are applied only in battle.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # ● Welcome to Lunatic Mode
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Lunatic Parameters are applied similarly through a "traits" system. All
  # of the Lunatic Parameter tags applied from the actors, classes, weapons,
  # armours, enemies, and state notetags are compiled together using the
  # following notetag:
  # 
  #     <custom param: string>
  # 
  # Replace param with one of the following:
  # MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK, or ALL
  # *Note: ALL only applies to ATK, DEF, MAT, MDF, AGI, and LUK
  # 
  # These lunatic parameters are calculated and applied after all other
  # parameter calculations are made. This means, that lunatic parameter effects
  # are added on after the parameter base, parameter bonuses, parameter rates,
  # and parameter buffs are applied.
  # 
  # Should you choose to use multiple lunatic traits for a single stat on one
  # item, you may use these notetags in place of the ones shown above.
  # 
  #     <custom param>
  #      string
  #      string
  #     </custom param>
  # 
  # All of the string information in between those two notetags will be
  # stored the same way as the notetags shown before those. There is no
  # difference between using either.
  #--------------------------------------------------------------------------
  def lunatic_parameter(total, param_id, traits)
    target = current_target
    subject = current_subject
    base = total
    for trait in traits
      case trait
      #----------------------------------------------------------------------
      # Common Effect: Common MaxHP
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This trait is applied to MaxHP calculations regardless of whatever
      # other Lunatic Parameter traits were added. This trait is always
      # calculated last.
      #----------------------------------------------------------------------
      when /COMMON MAXHP/i
        # No common MaxHP calculations made.
        
      #----------------------------------------------------------------------
      # Common Effect: Common MaxMP
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This trait is applied to MaxMP calculations regardless of whatever
      # other Lunatic Parameter traits were added. This trait is always
      # calculated last.
      #----------------------------------------------------------------------
      when /COMMON MAXMP/i
        # No common MaxMP calculations made.
        
      #----------------------------------------------------------------------
      # Common Effect: Common ATK
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This trait is applied to ATK calculations regardless of whatever
      # other Lunatic Parameter traits were added. This trait is always
      # calculated last.
      #----------------------------------------------------------------------
      when /COMMON ATK/i
        # No common ATK calculations made.
        
      #----------------------------------------------------------------------
      # Common Effect: Common DEF
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This trait is applied to DEF calculations regardless of whatever
      # other Lunatic Parameter traits were added. This trait is always
      # calculated last.
      #----------------------------------------------------------------------
      when /COMMON DEF/i
        # No common DEF calculations made.
        
      #----------------------------------------------------------------------
      # Common Effect: Common MAT
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This trait is applied to MAT calculations regardless of whatever
      # other Lunatic Parameter traits were added. This trait is always
      # calculated last.
      #----------------------------------------------------------------------
      when /COMMON MAT/i
        # No common MAT calculations made.
        
      #----------------------------------------------------------------------
      # Common Effect: Common MDF
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This trait is applied to MDF calculations regardless of whatever
      # other Lunatic Parameter traits were added. This trait is always
      # calculated last.
      #----------------------------------------------------------------------
      when /COMMON MDF/i
        # No common MDF calculations made.
        
      #----------------------------------------------------------------------
      # Common Effect: Common AGI
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This trait is applied to AGI calculations regardless of whatever
      # other Lunatic Parameter traits were added. This trait is always
      # calculated last.
      #----------------------------------------------------------------------
      when /COMMON AGI/i
        # No common AGI calculations made.
        
      #----------------------------------------------------------------------
      # Common Effect: Common LUK
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This trait is applied to LUK calculations regardless of whatever
      # other Lunatic Parameter traits were added. This trait is always
      # calculated last.
      #----------------------------------------------------------------------
      when /COMMON LUK/i
        # No common LUK calculations made.
        
      #----------------------------------------------------------------------
      # Stop editting past this point.
      #----------------------------------------------------------------------
      else
        total = lunatic_param_extension(total, base, param_id, trait)
      end
    end
    return total
  end
  
end # Game_BattlerBase

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    LUNATIC_STAT_STR = /<(?:CUSTOM|custom)[ ](.*):[ ](.*)>/i
    LUNATIC_STAT_ON  = /<(?:CUSTOM|custom)[ ](.*)>/i
    LUNATIC_STAT_OFF = /<\/(?:CUSTOM|custom)[ ](.*)>/i
    
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
  class <<self; alias load_database_lpar load_database; end
  def self.load_database
    load_database_lpar
    load_notetags_lpar
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_lpar
  #--------------------------------------------------------------------------
  def self.load_notetags_lpar
    groups = [$data_actors, $data_classes, $data_weapons, $data_armors,
      $data_enemies, $data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_lpar
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
  attr_accessor :custom_parameters
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_lpar
  #--------------------------------------------------------------------------
  def load_notetags_lpar
    @custom_parameters = {
      0 => [], 1 => [], 2 => [], 3 => [], 4 => [], 5 => [], 6 => [], 7 => [] }
    @custom_parameter_on = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::LUNATIC_STAT_STR
        case $1.upcase
        when "HP", "MAXHP", "MHP"
          param_id = 0
        when "MP", "MAXMP", "MMP", "SP", "MAXSP", "MSP"
          param_id = 1
        when "ATK"
          param_id = 2
        when "DEF"
          param_id = 3
        when "MAT", "INT", "SPI"
          param_id = 4
        when "MDF", "RES"
          param_id = 5
        when "AGI", "SPD"
          param_id = 6
        when "LUK", "LUCK"
          param_id = 7
        when "ALL"
          for i in 2...8 do @custom_parameters[i].push($2.to_s) end
          next
        else; next
        end
        @custom_parameters[param_id].push($2.to_s)
      #---
      when YEA::REGEXP::BASEITEM::LUNATIC_STAT_ON
        case $1.upcase
        when "HP", "MAXHP", "MHP"
          param_id = 0
        when "MP", "MAXMP", "MMP", "SP", "MAXSP", "MSP"
          param_id = 1
        when "ATK"
          param_id = 2
        when "DEF"
          param_id = 3
        when "MAT", "INT", "SPI"
          param_id = 4
        when "MDF", "RES"
          param_id = 5
        when "AGI", "SPD"
          param_id = 6
        when "LUK", "LUCK"
          param_id = 7
        when "ALL"
          param_id = 8
        else; next
        end
        @custom_parameter_on = param_id
      #---
      when YEA::REGEXP::BASEITEM::LUNATIC_STAT_OFF
        @custom_parameter_on = false
      #---
      else
        next unless @custom_parameter_on.is_a?(Integer)
        if @custom_parameter_on >= 8
          for i in 2...8 do @custom_parameters[i].push(line.to_s) end
          next
        end
        @custom_parameters[@custom_parameter_on].push(line.to_s)
      end
    } # self.note.split
    #---
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ Game_Temp
#==============================================================================

class Game_Temp
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :param_target
  attr_accessor :param_subject
  
end # Game_Temp

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: param
  #--------------------------------------------------------------------------
  alias game_battlerbase_param_lpar param
  def param(param_id)
    value = game_battlerbase_param_lpar(param_id)
    traits = lunatic_param_traits(param_id)
    value = lunatic_parameter(value, param_id, traits)
    return [[value, param_max(param_id)].min, param_min(param_id)].max.to_i
  end
  
  #--------------------------------------------------------------------------
  # new method: lunatic_param_traits
  #--------------------------------------------------------------------------
  def lunatic_param_traits(param_id)
    return [] unless $game_party.in_battle
    return [] if SceneManager.scene.is_a?(Scene_MenuBase)
    n = []
    if actor?
      n += self.actor.custom_parameters[param_id]
      n += self.class.custom_parameters[param_id]
      for equip in equips
        next if equip.nil?
        n += equip.custom_parameters[param_id]
      end
    else
      n += self.enemy.custom_parameters[param_id]
      if $imported["YEA-Doppelganger"] && !self.class.nil?
        n += self.class.custom_parameters[param_id]
      end
    end
    for state in states
      next if state.nil?
      n += state.custom_parameters[param_id]
    end
    n.sort!
    case n
    when 0; n += ["COMMON MAXHP"]
    when 1; n += ["COMMON MAXMP"]
    when 2; n += ["COMMON ATK"]
    when 3; n += ["COMMON DEF"]
    when 4; n += ["COMMON MAT"]
    when 5; n += ["COMMON MDF"]
    when 6; n += ["COMMON AGI"]
    when 7; n += ["COMMON LUK"]
    end
    return n
  end
  
  #--------------------------------------------------------------------------
  # new method: current_target
  #--------------------------------------------------------------------------
  def current_target
    return nil unless $game_party.in_battle
    return nil if SceneManager.scene.is_a?(Scene_MenuBase)
    return nil unless $game_temp.param_subject == self
    return $game_temp.param_target
  end
  
  #--------------------------------------------------------------------------
  # new method: current_subject
  #--------------------------------------------------------------------------
  def current_subject
    return nil unless $game_party.in_battle
    return nil if SceneManager.scene.is_a?(Scene_MenuBase)
    return nil unless $game_temp.param_target == self
    return $game_temp.param_subject
  end
  
  #--------------------------------------------------------------------------
  # new method: lunatic_param_extension
  #--------------------------------------------------------------------------
  def lunatic_param_extension(total, base, param_id, trait)
    # Reserved for future Add-ons.
    return total
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: invoke_item
  #--------------------------------------------------------------------------
  alias scene_battle_invoke_item_lpar invoke_item
  def invoke_item(target, item)
    scene_battle_invoke_item_lpar(target, item)
    $game_temp.param_target = nil
    $game_temp.param_subject = nil
  end
  
  #--------------------------------------------------------------------------
  # alias method: invoke_counter_attack
  #--------------------------------------------------------------------------
  alias scene_battle_invoke_counter_attack_lpar invoke_counter_attack
  def invoke_counter_attack(target, item)
    $game_temp.param_target = @subject
    $game_temp.param_subject = target
    scene_battle_invoke_counter_attack_lpar(target, item)
  end
  
  #--------------------------------------------------------------------------
  # alias method: invoke_magic_reflection
  #--------------------------------------------------------------------------
  alias scene_battle_invoke_magic_reflection_lpar invoke_magic_reflection
  def invoke_magic_reflection(target, item)
    $game_temp.param_target = @subject
    $game_temp.param_subject = @subject
    scene_battle_invoke_magic_reflection_lpar(target, item)
  end
  
  #--------------------------------------------------------------------------
  # alias method: apply_substitute
  #--------------------------------------------------------------------------
  alias scene_battle_apply_substitute_lpar apply_substitute
  def apply_substitute(target, item)
    target = scene_battle_apply_substitute_lpar(target, item)
    $game_temp.param_target = target
    $game_temp.param_subject = @subject
    return target
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================