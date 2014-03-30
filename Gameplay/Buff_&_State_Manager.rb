#==============================================================================
# 
# ▼ Yanfly Engine Ace - Buff & State Manager v1.07
# -- Last Updated: 2012.01.26
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-Buff&StateManager"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.26 - Bug Fixed: Remaining turns aren't drawn in excess.
# 2012.01.23 - Compatibility Update: Doppelganger
# 2012.01.11 - Compatibility Update: Field State Effects
# 2012.01.09 - Bug Fixed: Remaining turns weren't drawn properly again.
# 2012.01.07 - Bug Fixed: Remaining turns weren't drawn properly.
# 2011.12.30 - Bug Fixed: Decimals are no longer shown on states turns.
# 2011.12.28 - Added <state x turn: +y> for actors, classes, weapons, armours,
#              enemies, and states.
# 2011.12.27 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script alters some of the basic mechanics revolving behind states,
# buffs, and debuffs that aren't adjustable within RPG Maker VX Ace by default
# such as being able to affect the turns remaining on a state, buff, or debuff
# without affecting anything else or even adjusting how many times a buff (or
# debuff) can be applied to an actor.
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
# <max buff stat: +x>
# <max buff stat: -x>
# Increases or decreases the maximum times that particular stat can be buffed
# by x. Note that the max increase here is still limited by the module constant
# MAXIMUM_BUFF_LIMIT. Replace "stat" with "MAXHP", "MAXMP", "ATK", "DEF",
# "MAT", "MDF", "AGI", "LUK", or "ALL" for those respective stats.
# 
# <max debuff stat: +x>
# <max debuff stat: -x>
# Increases or decreases the maximum times that particular stat can be debuffed
# by x. Note that the max decrease here is still limited by the module constant
# MAXIMUM_BUFF_LIMIT. Replace "stat" with "MAXHP", "MAXMP", "ATK", "DEF",
# "MAT", "MDF", "AGI", "LUK", or "ALL" for those respective stats.
# 
# <state x turn: +y>
# <state x turn: -y>
# When the battler is affected by state x, additional modifiers are made to the
# number of turns remaining for state x by y amount. The modifiers cannot
# reduce turns to under 0.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <max buff stat: +x>
# <max buff stat: -x>
# Increases or decreases the maximum times that particular stat can be buffed
# by x. Note that the max increase here is still limited by the module constant
# MAXIMUM_BUFF_LIMIT. Replace "stat" with "MAXHP", "MAXMP", "ATK", "DEF",
# "MAT", "MDF", "AGI", "LUK", or "ALL" for those respective stats.
# 
# <max debuff stat: +x>
# <max debuff stat: -x>
# Increases or decreases the maximum times that particular stat can be debuffed
# by x. Note that the max decrease here is still limited by the module constant
# MAXIMUM_BUFF_LIMIT. Replace "stat" with "MAXHP", "MAXMP", "ATK", "DEF",
# "MAT", "MDF", "AGI", "LUK", or "ALL" for those respective stats.
# 
# <state x turn: +y>
# <state x turn: -y>
# When the battler is affected by state x, additional modifiers are made to the
# number of turns remaining for state x by y amount. The modifiers cannot
# reduce turns to under 0.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skill notebox in the database.
# -----------------------------------------------------------------------------
# <state x turn: +y>
# <state x turn: -y>
# If the target is affected by state x, this will alter the turns remaining on
# that state by y turns if the state can be removed by turns. If the state goes
# under 0 turns, the state will be removed.
# 
# <buff stat turn: +x>
# <buff stat turn: -x>
# If the target's stat is buffed, this will alter the turns remaining on that
# buff by x turns. If the buff's remaining turns go under 0, the buff will be
# removed.
# 
# <debuff stat turn: +x>
# <debuff stat turn: -x>
# If the target's stat is debuffed, this will alter the turns remaining on that
# debuff by x turns. If the debuff's remaining turns go under 0, the debuff
# will be removed.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the item notebox in the database.
# -----------------------------------------------------------------------------
# <state x turn: +y>
# <state x turn: -y>
# If the target is affected by state x, this will alter the turns remaining on
# that state by y turns if the state can be removed by turns. If the state goes
# under 0 turns, the state will be removed.
# 
# <buff stat turn: +x>
# <buff stat turn: -x>
# If the target's stat is buffed, this will alter the turns remaining on that
# buff by x turns. If the buff's remaining turns go under 0, the buff will be
# removed.
# 
# <debuff stat turn: +x>
# <debuff stat turn: -x>
# If the target's stat is debuffed, this will alter the turns remaining on that
# debuff by x turns. If the debuff's remaining turns go under 0, the debuff
# will be removed.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <max buff stat: +x>
# <max buff stat: -x>
# Increases or decreases the maximum times that particular stat can be buffed
# by x. Note that the max increase here is still limited by the module constant
# MAXIMUM_BUFF_LIMIT. Replace "stat" with "MAXHP", "MAXMP", "ATK", "DEF",
# "MAT", "MDF", "AGI", "LUK", or "ALL" for those respective stats.
# 
# <max debuff stat: +x>
# <max debuff stat: -x>
# Increases or decreases the maximum times that particular stat can be debuffed
# by x. Note that the max decrease here is still limited by the module constant
# MAXIMUM_BUFF_LIMIT. Replace "stat" with "MAXHP", "MAXMP", "ATK", "DEF",
# "MAT", "MDF", "AGI", "LUK", or "ALL" for those respective stats.
# 
# <state x turn: +y>
# <state x turn: -y>
# When the battler is affected by state x, additional modifiers are made to the
# number of turns remaining for state x by y amount. The modifiers cannot
# reduce turns to under 0.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armour notebox in the database.
# -----------------------------------------------------------------------------
# <max buff stat: +x>
# <max buff stat: -x>
# Increases or decreases the maximum times that particular stat can be buffed
# by x. Note that the max increase here is still limited by the module constant
# MAXIMUM_BUFF_LIMIT. Replace "stat" with "MAXHP", "MAXMP", "ATK", "DEF",
# "MAT", "MDF", "AGI", "LUK", or "ALL" for those respective stats.
# 
# <max debuff stat: +x>
# <max debuff stat: -x>
# Increases or decreases the maximum times that particular stat can be debuffed
# by x. Note that the max decrease here is still limited by the module constant
# MAXIMUM_BUFF_LIMIT. Replace "stat" with "MAXHP", "MAXMP", "ATK", "DEF",
# "MAT", "MDF", "AGI", "LUK", or "ALL" for those respective stats.
# 
# <state x turn: +y>
# <state x turn: -y>
# When the battler is affected by state x, additional modifiers are made to the
# number of turns remaining for state x by y amount. The modifiers cannot
# reduce turns to under 0.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemies notebox in the database.
# -----------------------------------------------------------------------------
# <max buff stat: +x>
# <max buff stat: -x>
# Increases or decreases the maximum times that particular stat can be buffed
# by x. Note that the max increase here is still limited by the module constant
# MAXIMUM_BUFF_LIMIT. Replace "stat" with "MAXHP", "MAXMP", "ATK", "DEF",
# "MAT", "MDF", "AGI", "LUK", or "ALL" for those respective stats.
# 
# <max debuff stat: +x>
# <max debuff stat: -x>
# Increases or decreases the maximum times that particular stat can be debuffed
# by x. Note that the max decrease here is still limited by the module constant
# MAXIMUM_BUFF_LIMIT. Replace "stat" with "MAXHP", "MAXMP", "ATK", "DEF",
# "MAT", "MDF", "AGI", "LUK", or "ALL" for those respective stats.
# 
# <state x turn: +y>
# <state x turn: -y>
# When the battler is affected by state x, additional modifiers are made to the
# number of turns remaining for state x by y amount. The modifiers cannot
# reduce turns to under 0.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <max buff stat: +x>
# <max buff stat: -x>
# Increases or decreases the maximum times that particular stat can be buffed
# by x. Note that the max increase here is still limited by the module constant
# MAXIMUM_BUFF_LIMIT. Replace "stat" with "MAXHP", "MAXMP", "ATK", "DEF",
# "MAT", "MDF", "AGI", "LUK", or "ALL" for those respective stats.
# 
# <max debuff stat: +x>
# <max debuff stat: -x>
# Increases or decreases the maximum times that particular stat can be debuffed
# by x. Note that the max decrease here is still limited by the module constant
# MAXIMUM_BUFF_LIMIT. Replace "stat" with "MAXHP", "MAXMP", "ATK", "DEF",
# "MAT", "MDF", "AGI", "LUK", or "ALL" for those respective stats.
# 
# <reapply ignore>
# If this state is cast on a battler with the state already applied, turns
# remaining will not be reset nor will turns be added on.
# 
# <reapply reset>
# If this state is cast on a battler with the state already applied, the turns
# will be reset to the default amount of turns the state normally starts with.
# 
# <reapply total>
# If this state is cast on a battler with the state already applied, the turns
# will be added on to the current amount of turns remaining giving the battler
# a total of the remaining turns with the default turns for the state.
# 
# <state x turn: +y>
# <state x turn: -y>
# When the battler is affected by state x, additional modifiers are made to the
# number of turns remaining for state x by y amount. The modifiers cannot
# reduce turns to under 0.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module BUFF_STATE_MANAGER
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Draw Remaining Turns -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This setting will cause the game to show the number of turns remaining
    # for a state in battle (if the state will remove itself through turns).
    # Adjust the settings below to change the font size and the y coordinate
    # adjustment to where the turns remaining appear if you so desire.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    SHOW_REMAINING_TURNS = true     # Show the turns remaining?
    TURNS_REMAINING_SIZE = 18       # Font size used for turns remaining.
    TURNS_REMAINING_Y    = -4       # Adjusts location of the text.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Buff Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust how buffs play out in your game and the way they
    # modify a battler's stats such as the maximum times a stat can be buffed
    # and the buff boost formula. Note that these maximums apply to both buffs
    # and debuffs.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_BUFF_LIMIT = 4     # Normal times you can buff a stat. Default: 2
    MAXIMUM_BUFF_LIMIT = 8     # Maximum times you can buff a stat. Default: 2
    
    # This is the formula used to apply the rate used for buffs and debuffs.
    BUFF_BOOST_FORMULA = "buff_level(param_id) * 0.25 + 1.0"
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Reapplying State Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust how the rules apply to states when they are
    # reapplied onto an actor with the state already intact. If you wish to
    # have specific states use different rules, use notetags to have them
    # adjust turns differently.
    #   0 - Ignored. Default VX setting.
    #   1 - Turns reset back to existing turns. Default VX Ace Setting.
    #   2 - Default turns added onto existing turns.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    REAPPLY_STATE_RULES = 1
    
  end # BUFF_STATE_MANAGER
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    MAX_BUFF = /<(?:MAX_BUFF|max buff)[ ](.*):[ ]([\+\-]\d+)>/i
    MAX_DEBUFF = /<(?:MAX_DEBUFF|max debuff)[ ](.*):[ ]([\+\-]\d+)>/i
    CHANGE_STATE_TURN = /<(?:state)[ ](\d+)[ ](?:TURN|turns):[ ]([\+\-]\d+)>/i
    STATE_REAPPLY_IGNORE = /<(?:REAPPLY_IGNORE|reapply ignore)>/i
    STATE_REAPPLY_RESET = /<(?:REAPPLY_RESET|reapply reset)>/i
    STATE_REAPPLY_TOTAL = /<(?:REAPPLY_TOTAL|reapply total)>/i
    
  end # BASEITEM
  module USABLEITEM
    
    CHANGE_STATE_TURN = /<(?:state)[ ](\d+)[ ](?:TURN|turns):[ ]([\+\-]\d+)>/i
    CHANGE_BUFF_TURN = /<(?:buff)[ ](.*)[ ](?:TURN|turns):[ ]([\+\-]\d+)>/i
    CHANGE_DEBUFF_TURN = /<(?:debuff)[ ](.*)[ ](?:TURN|turns):[ ]([\+\-]\d+)>/i
    
  end # USABLEITEM
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_bsm load_database; end
  def self.load_database
    load_database_bsm
    load_notetags_bsm
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_bsm
  #--------------------------------------------------------------------------
  def self.load_notetags_bsm
    groups = [$data_actors, $data_classes, $data_weapons, $data_armors,
      $data_enemies, $data_states, $data_skills, $data_items]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_bsm
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
  attr_accessor :max_buff
  attr_accessor :max_debuff
  attr_accessor :change_state_turns
  attr_accessor :state_reapply_rules
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_bsm
  #--------------------------------------------------------------------------
  def load_notetags_bsm
    @change_state_turns = {}
    @max_buff = {
      0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0 }
    @max_debuff = {
      0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0 }
    if self.is_a?(RPG::State)
      @state_reapply_rules = YEA::BUFF_STATE_MANAGER::REAPPLY_STATE_RULES
    end
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::MAX_BUFF
        case $1.upcase
        when "MAXHP", "MHP", "HP"
          @max_buff[0] = $2.to_i
        when "MAXMP", "MMP", "MP", "MAXSP", "SP", "MSP"
          @max_buff[1] = $2.to_i
        when "ATK"
          @max_buff[2] = $2.to_i
        when "DEF"
          @max_buff[3] = $2.to_i
        when "MAT", "INT", "SPI"
          @max_buff[4] = $2.to_i
        when "MDF", "RES"
          @max_buff[5] = $2.to_i
        when "AGI"
          @max_buff[6] = $2.to_i
        when "LUK"
          @max_buff[7] = $2.to_i
        when "ALL"
          for i in 0...8; @max_buff[i] = $2.to_i; end
        end
      #---
      when YEA::REGEXP::BASEITEM::MAX_DEBUFF
        case $1.upcase
        when "MAXHP", "MHP", "HP"
          @max_debuff[0] = $2.to_i
        when "MAXMP", "MMP", "MP", "MAXSP", "SP", "MSP"
          @max_debuff[1] = $2.to_i
        when "ATK"
          @max_debuff[2] = $2.to_i
        when "DEF"
          @max_debuff[3] = $2.to_i
        when "MAT", "INT", "SPI"
          @max_debuff[4] = $2.to_i
        when "MDF", "RES"
          @max_debuff[5] = $2.to_i
        when "AGI"
          @max_debuff[6] = $2.to_i
        when "LUK"
          @max_debuff[7] = $2.to_i
        when "ALL"
          for i in 0...8; @max_debuff[i] = $2.to_i; end
        end
      #---
      when YEA::REGEXP::BASEITEM::CHANGE_STATE_TURN
        @change_state_turns[$1.to_i] = $2.to_i
      #---
      when YEA::REGEXP::BASEITEM::STATE_REAPPLY_IGNORE
        next unless self.is_a?(RPG::State)
        @state_reapply_rules = 0
      when YEA::REGEXP::BASEITEM::STATE_REAPPLY_RESET
        next unless self.is_a?(RPG::State)
        @state_reapply_rules = 1
      when YEA::REGEXP::BASEITEM::STATE_REAPPLY_TOTAL
        next unless self.is_a?(RPG::State)
        @state_reapply_rules = 2
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :change_state_turns
  attr_accessor :change_buff_turns
  attr_accessor :change_debuff_turns
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_bsm
  #--------------------------------------------------------------------------
  def load_notetags_bsm
    @change_state_turns = {}
    @change_buff_turns = {}
    @change_debuff_turns = {}
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::CHANGE_STATE_TURN
        @change_state_turns[$1.to_i] = $2.to_i
      when YEA::REGEXP::USABLEITEM::CHANGE_BUFF_TURN
        case $1.upcase
        when "MAXHP", "MHP", "HP"
          @change_buff_turns[0] = $2.to_i
        when "MAXMP", "MMP", "MP", "MAXSP", "SP", "MSP"
          @change_buff_turns[1] = $2.to_i
        when "ATK"
          @change_buff_turns[2] = $2.to_i
        when "DEF"
          @change_buff_turns[3] = $2.to_i
        when "MAT", "INT", "SPI"
          @change_buff_turns[4] = $2.to_i
        when "MDF", "RES"
          @change_buff_turns[5] = $2.to_i
        when "AGI"
          @change_buff_turns[6] = $2.to_i
        when "LUK"
          @change_buff_turns[7] = $2.to_i
        when "ALL"
          for i in 0...8; @change_buff_turns[i] = $2.to_i; end
        end
      when YEA::REGEXP::USABLEITEM::CHANGE_DEBUFF_TURN
        case $1.upcase
        when "MAXHP", "MHP", "HP"
          @change_debuff_turns[0] = $2.to_i
        when "MAXMP", "MMP", "MP", "MAXSP", "SP", "MSP"
          @change_debuff_turns[1] = $2.to_i
        when "ATK"
          @change_debuff_turns[2] = $2.to_i
        when "DEF"
          @change_debuff_turns[3] = $2.to_i
        when "MAT", "INT", "SPI"
          @change_debuff_turns[4] = $2.to_i
        when "MDF", "RES"
          @change_debuff_turns[5] = $2.to_i
        when "AGI"
          @change_debuff_turns[6] = $2.to_i
        when "LUK"
          @change_debuff_turns[7] = $2.to_i
        when "ALL"
          for i in 0...8; @change_debuff_turns[i] = $2.to_i; end
        end
      end
    } # self.note.split
    #---
  end
  
end # class RPG::UsableItem

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # overwrite method: param_buff_rate
  #--------------------------------------------------------------------------
  def param_buff_rate(param_id)
    return eval(YEA::BUFF_STATE_MANAGER::BUFF_BOOST_FORMULA)
  end
  
  #--------------------------------------------------------------------------
  # new method: max_buff_limit
  #--------------------------------------------------------------------------
  def max_buff_limit(param_id)
    n = YEA::BUFF_STATE_MANAGER::DEFAULT_BUFF_LIMIT
    if actor?
      n += self.actor.max_buff[param_id]
      n += self.class.max_buff[param_id]
      for equip in equips
        next if equip.nil?
        n += equip.max_buff[param_id]
      end
    else
      n += self.enemy.max_buff[param_id]
      if $imported["YEA-Doppelganger"] && !self.class.nil?
        n += self.class.max_buff[param_id]
      end
    end
    for state in states
      next if state.nil?
      n += state.max_buff[param_id]
    end
    return [[n.to_i, 0].max, YEA::BUFF_STATE_MANAGER::MAXIMUM_BUFF_LIMIT].min
  end
  
  #--------------------------------------------------------------------------
  # new method: max_debuff_limit
  #--------------------------------------------------------------------------
  def max_debuff_limit(param_id)
    n = YEA::BUFF_STATE_MANAGER::DEFAULT_BUFF_LIMIT
    if actor?
      n += self.actor.max_debuff[param_id]
      n += self.class.max_debuff[param_id]
      for equip in equips
        next if equip.nil?
        n += equip.max_debuff[param_id]
      end
    else
      n += self.enemy.max_debuff[param_id]
      if $imported["YEA-Doppelganger"] && !self.class.nil?
        n += self.class.max_debuff[param_id]
      end
    end
    for state in states
      next if state.nil?
      n += state.max_debuff[param_id]
    end
    return [[n.to_i, 0].max, YEA::BUFF_STATE_MANAGER::MAXIMUM_BUFF_LIMIT].min
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: buff_icon_index
  #--------------------------------------------------------------------------
  def buff_icon_index(buff_level, param_id)
    if buff_level > 0
      return ICON_BUFF_START + ([buff_level - 1, 1].min) * 8 + param_id
    elsif buff_level < 0
      return ICON_DEBUFF_START + ([-buff_level - 1, -1].max) * 8 + param_id 
    else
      return 0
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: buff_turns
  #--------------------------------------------------------------------------
  def buff_turns(param_id)
    return @buff_turns.include?(param_id) ? @buff_turns[param_id] : 0
  end
  
  #--------------------------------------------------------------------------
  # new method: buff_level
  #--------------------------------------------------------------------------
  def buff_level(param_id)
    return 0 if @buffs[param_id].nil?
    buff_maximum = max_buff_limit(param_id)
    debuff_maximum = max_debuff_limit(param_id)
    return [[@buffs[param_id], buff_maximum].min, -debuff_maximum].max
  end
  
  #--------------------------------------------------------------------------
  # new method: buff_change_turns
  #--------------------------------------------------------------------------
  def buff_change_turns(param_id, value)
    @buff_turns[param_id] = 0 if @buff_turns[param_id].nil?
    @buff_turns[param_id] = [value, 0].max
  end
  
  #--------------------------------------------------------------------------
  # new method: state_turns
  #--------------------------------------------------------------------------
  def state_turns(state_id)
    state_id = state_id.id if state_id.is_a?(RPG::State)
    return @state_turns.include?(state_id) ? @state_turns[state_id] : 0
  end
  
  #--------------------------------------------------------------------------
  # new method: state_steps
  #--------------------------------------------------------------------------
  def state_steps(state_id)
    state_id = state_id.id if state_id.is_a?(RPG::State)
    return @state_steps.include?(state_id) ? @state_steps[state_id] : 0
  end
  
  #--------------------------------------------------------------------------
  # new method: state_change_turns
  #--------------------------------------------------------------------------
  def state_change_turns(state_id, value)
    state_id = state_id.id if state_id.is_a?(RPG::State)
    @state_turns[state_id] = 0 if @state_turns[state_id].nil?
    @state_turns[state_id] = [value, 0].max
  end
  
  #--------------------------------------------------------------------------
  # new method: state_turn_mod
  #--------------------------------------------------------------------------
  def state_turn_mod(state_id)
    return 0 if $data_states[state_id].nil?
    state = $data_states[state_id]
    n = state.min_turns + rand(1 + [state.max_turns - state.min_turns, 0].max)
    if actor?
      if self.actor.change_state_turns.include?(state_id)
        n += self.actor.change_state_turns[state_id]
      end
      if self.class.change_state_turns.include?(state_id)
        n += self.class.change_state_turns[state_id]
      end
      for equip in equips
        next if equip.nil?
        next unless equip.change_state_turns.include?(state_id)
        n += equip.change_state_turns[state_id]
      end
    else
      if self.enemy.change_state_turns.include?(state_id)
        n += self.enemy.change_state_turns[state_id]
      end
      if $imported["YEA-Doppelganger"] && !self.class.nil?
        if self.class.change_state_turns.include?(state_id)
          n += self.class.change_state_turns[state_id]
        end
      end
    end
    for state in states
      next if state.nil?
      next unless state.change_state_turns.include?(state_id)
      n += state.change_state_turns[state_id]
    end
    return [n, 0].max
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # overwrite method: buff_max?
  #--------------------------------------------------------------------------
  def buff_max?(param_id)
    return @buffs[param_id] == max_buff_limit(param_id)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: debuff_max?
  #--------------------------------------------------------------------------
  def debuff_max?(param_id)
    return @buffs[param_id] == -max_debuff_limit(param_id)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: add_state
  #--------------------------------------------------------------------------
  def add_state(state_id)
    return if $data_states[state_id].nil?
    state_rules = $data_states[state_id].state_reapply_rules
    return if state_rules == 0 && state?(state_id)
    if state_addable?(state_id)
      add_new_state(state_id) unless state?(state_id)
      reset_state_counts(state_id) if state_rules == 1
      total_state_counts(state_id) if state_rules == 2
      @result.added_states.push(state_id).uniq!
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: state_removed?
  #--------------------------------------------------------------------------
  def state_removed?(state_id)
    return false
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: reset_state_counts
  #--------------------------------------------------------------------------
  def reset_state_counts(state_id)
    state = $data_states[state_id]
    @state_turns[state_id] = state_turn_mod(state_id)
    @state_steps[state_id] = state.steps_to_remove
  end
  
  #--------------------------------------------------------------------------
  # new method: total_state_counts
  #--------------------------------------------------------------------------
  def total_state_counts(state_id)
    state = $data_states[state_id]
    value = state_turn_mod(state_id)
    state_change_turns(state_id, value + state_turns(state_id))
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_user_effect
  #--------------------------------------------------------------------------
  alias game_battler_item_user_effect_bsm item_user_effect
  def item_user_effect(user, item)
    game_battler_item_user_effect_bsm(user, item)
    apply_state_turn_changes(user, item)
    apply_buff_turn_changes(user, item)
    apply_debuff_turn_changes(user, item)
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_state_turn_changes
  #--------------------------------------------------------------------------
  def apply_state_turn_changes(user, item)
    return if item.nil?
    return unless $game_party.in_battle
    for key in item.change_state_turns
      state_id = key[0]
      next if field_state?(state_id)
      next unless state?(state_id)
      next unless $data_states[state_id].auto_removal_timing > 0
      state_change_turns(state_id, key[1] + state_turns(state_id))
      remove_state(state_id) if state_turns(state_id) <= 0
      @result.success = true
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: field_state?
  #--------------------------------------------------------------------------
  def field_state?(state_id)
    return false unless $imported["YEA-FieldStateEffects"]
    return false unless $game_party.in_battle
    return false unless SceneManager.scene_is?(Scene_Battle)
    return BattleManager.field_state?(state_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_buff_turn_changes
  #--------------------------------------------------------------------------
  def apply_buff_turn_changes(user, item)
    return if item.nil?
    return unless $game_party.in_battle
    for key in item.change_buff_turns
      param_id = key[0]
      next unless buff?(param_id)
      buff_change_turns(param_id, key[1] + buff_turns(param_id))
      remove_buff(param_id) if buff_turns(param_id) < 0
      @result.success = true
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_debuff_turn_changes
  #--------------------------------------------------------------------------
  def apply_debuff_turn_changes(user, item)
    return if item.nil?
    return unless $game_party.in_battle
    for key in item.change_debuff_turns
      param_id = key[0]
      next unless debuff?(param_id)
      buff_change_turns(param_id, key[1] + buff_turns(param_id))
      remove_buff(param_id) if buff_turns(param_id) < 0
      @result.success = true
    end
  end
  
end # Game_Battler

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
  
  #--------------------------------------------------------------------------
  # alias method: draw_actor_icons
  #--------------------------------------------------------------------------
  alias window_base_draw_actor_icons_bsm draw_actor_icons
  def draw_actor_icons(actor, dx, dy, dw = 96)
    window_base_draw_actor_icons_bsm(actor, dx, dy, dw)
    draw_actor_icon_turns(actor, dx, dy, dw)
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_actor_icon_turns
  #--------------------------------------------------------------------------
  def draw_actor_icon_turns(actor, dx, dy, dw)
    return unless YEA::BUFF_STATE_MANAGER::SHOW_REMAINING_TURNS
    return unless SceneManager.scene_is?(Scene_Battle)
    reset_font_settings
    contents.font.out_color.alpha = 255
    contents.font.bold = true
    contents.font.size = YEA::BUFF_STATE_MANAGER::TURNS_REMAINING_SIZE
    bx = dx
    dy += YEA::BUFF_STATE_MANAGER::TURNS_REMAINING_Y
    #---
    for state in actor.states
      break if dx + 24 >= dw + bx
      next if state.icon_index <= 0
      turns = actor.state_turns(state.id).to_i
      if $imported["YEA-FieldStateEffects"] &&
      BattleManager.field_state?(state.id)
        turns = BattleManager.field_state_turns(state.id)
      end
      if state.auto_removal_timing > 0 && turns < 100
        draw_text(dx, dy, 24, line_height, turns, 2)
      end
      dx += 24
    end
    #---
    for i in 0...8
      break if dx + 24 >= dw + bx
      next if actor.buff_icon_index(actor.buff_level(i), i) == 0
      turns = actor.buff_turns(i).to_i
      draw_text(dx, dy, 24, line_height, turns, 2) if turns < 100
      dx += 24
    end
    #---
    contents.font.out_color = Font.default_out_color
    reset_font_settings
  end
  
end # Window_Base

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================