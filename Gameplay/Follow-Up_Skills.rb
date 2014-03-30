#==============================================================================
# 
# ▼ Yanfly Engine Ace - Follow-Up Skill v1.01
# -- Last Updated: 2012.02.12
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-FollowUpSkill"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.02.12 - Bug Fixed: Follow Up skills do not stack with multi-hits.
# 2012.02.05 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script allows for follow-up skills when the skill lands a successful hit
# (ie. no misses or evades). The script provides a chance to proceed with a
# follow-up skill or a guaranteed follow-up skill provided that the prior skill
# has successfully connected.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skill notebox in the database.
# -----------------------------------------------------------------------------
# <follow up x>
# This causes the skill x to have a 100% chance of a follow-up upon usage of
# the current skill and the current skill landing a successful hit.
# 
# <follow up x: y%>
# This causes the skill x to have y% chance of a follow-up upon usage of the
# current skill and the current skill landing a successful hit.
# 
# <follow up state: x>
# <follow up all states: x, x>
# This causes the follow-up skill to require all of the states x to follow-up.
# If one state is missing, the follow-up skill will not occur. To add in more
# states required, insert multiples of this notetag.
# 
# <follow up any states: x, x>
# This causes the follow-up skill to require at least one of the listed states
# x to follow-up. If all states are missing, the follow-up skill will not
# occur. To add in more states required, insert multiples of this notetag.
# 
# <follow up switch: x>
# <follow up all switch: x, x>
# This causes the follow-up skill to require all switches x to be ON before the
# skill will follow-up. If one switch is OFF, the follow-up skill will not
# occur. To add in more switches required, insert multiples of this notetag.
# 
# <follow up any switch: x, x>
# This causes the follow-up skill to require at least one of the listed
# switches to be ON before the the follow-up skill will occur. If all switches
# are off, the follow-up skill will not occur. To add in more switches required
# insert multiples of this notetag.
# 
# <follow up eval>
#  string
#  string
# </follow up eval>
# For the more advanced users, replace string with code to determine whether
# or not the skill will follow-up. If multiple lines are used, they are all
# considered part of the same line.
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
  module SKILL
    
    FOLLOWUP = /<(?:FOLLOW_UP|follow up)[ ](\d+)>/i
    FOLLOWUP_CHANCE = /<(?:FOLLOW_UP|follow up)[ ](\d+):[ ](\d+)([%％])>/i
    FOLLOWUP_STATES = 
      /<(?:FOLLOW_UP_STATE|follow up state):[ ](\d+(?:\s*,\s*\d+)*)>/i
    FOLLOWUP_ALL_STATES = 
      /<(?:FOLLOW_UP_ALL_STATES|follow up all states):[ ](\d+(?:\s*,\s*\d+)*)>/i
    FOLLOWUP_ANY_STATES = 
      /<(?:FOLLOW_UP_ANY_STATES|follow up any states):[ ](\d+(?:\s*,\s*\d+)*)>/i
    FOLLOWUP_SWITCH = 
      /<(?:FOLLOW_UP_SWITCH|follow up switch):[ ](\d+(?:\s*,\s*\d+)*)>/i
    FOLLOWUP_ALL_SWITCH = 
      /<(?:FOLLOW_UP_ALL_SWITCH|follow up all switch):[ ](\d+(?:\s*,\s*\d+)*)>/i
    FOLLOWUP_ANY_SWITCH = 
      /<(?:FOLLOW_UP_ANY_SWITCH|follow up any switch):[ ](\d+(?:\s*,\s*\d+)*)>/i
    FOLLOWUP_EVAL_ON = /<(?:FOLLOW_UP_EVAL|follow up eval)>/i
    FOLLOWUP_EVAL_OFF = /<\/(?:FOLLOW_UP_EVAL|follow up eval)>/i
    
  end # SKILL
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_fus load_database; end
  def self.load_database
    load_database_fus
    load_notetags_fus
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_fus
  #--------------------------------------------------------------------------
  def self.load_notetags_fus
    for obj in $data_skills
      next if obj.nil?
      obj.load_notetags_fus
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::BaseItem
#==============================================================================

class RPG::Skill < RPG::UsableItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :follow_up
  attr_accessor :follow_chance
  attr_accessor :follow_states_all
  attr_accessor :follow_states_any
  attr_accessor :follow_switch_all
  attr_accessor :follow_switch_any
  attr_accessor :follow_eval
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_fus
  #--------------------------------------------------------------------------
  def load_notetags_fus
    @follow_up = 0
    @follow_chance = 1.0
    @follow_states_all = []
    @follow_states_any = []
    @follow_switch_all = []
    @follow_switch_any = []
    @follow_eval = ""
    @follow_eval_on = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::SKILL::FOLLOWUP
        @follow_up = $1.to_i
        @follow_chance = 1.0
      when YEA::REGEXP::SKILL::FOLLOWUP_CHANCE
        @follow_up = $1.to_i
        @follow_chance = $2.to_i * 0.01
      #---
      when YEA::REGEXP::SKILL::FOLLOWUP_STATES
        $1.scan(/\d+/).each { |num| 
        @follow_states_all.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::SKILL::FOLLOWUP_ALL_STATES
        $1.scan(/\d+/).each { |num| 
        @follow_states_all.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::SKILL::FOLLOWUP_ANY_STATES
        $1.scan(/\d+/).each { |num| 
        @follow_states_any.push(num.to_i) if num.to_i > 0 }
      #---
      when YEA::REGEXP::SKILL::FOLLOWUP_SWITCH
        $1.scan(/\d+/).each { |num| 
        @follow_switch_all.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::SKILL::FOLLOWUP_ALL_SWITCH
        $1.scan(/\d+/).each { |num| 
        @follow_switch_all.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::SKILL::FOLLOWUP_ANY_SWITCH
        $1.scan(/\d+/).each { |num| 
        @follow_switch_any.push(num.to_i) if num.to_i > 0 }
      #---
      when YEA::REGEXP::SKILL::FOLLOWUP_EVAL_ON
        @follow_eval_on = true
      when YEA::REGEXP::SKILL::FOLLOWUP_EVAL_OFF
        @follow_eval_off = false
      #---
      else
        @follow_eval += line.to_s if @follow_eval_on
      end
    } # self.note.split
    #---
  end
  
end # RPG::Skill

#==============================================================================
# ■ Game_Action
#==============================================================================

class Game_Action
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :follow_up
  
end # Game_Action

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: item_user_effect
  #--------------------------------------------------------------------------
  alias game_battler_item_user_effect_fus item_user_effect
  def item_user_effect(user, item)
    game_battler_item_user_effect_fus(user, item)
    user.process_follow_up_skill(item)
  end
  
  #--------------------------------------------------------------------------
  # new method: process_follow_up_skill
  #--------------------------------------------------------------------------
  def process_follow_up_skill(item)
    return unless meet_follow_up_requirements?(item)
    action = Game_Action.new(self)
    action.set_skill(item.follow_up)
    if current_action.nil?
      action.decide_random_target
    else
      action.target_index = current_action.target_index
    end
    @actions.insert(1, action)
    @actions[1].follow_up = true
  end
  
  #--------------------------------------------------------------------------
  # new method: meet_follow_up_requirements?
  #--------------------------------------------------------------------------
  def meet_follow_up_requirements?(item)
    return false if item.nil?
    return false unless item.is_a?(RPG::Skill)
    return false if @actions[1] != nil && @actions[1].follow_up
    return false if $data_skills[item.follow_up].nil?
    return false unless follow_up_all_states?(item)
    return false unless follow_up_any_states?(item)
    return false unless follow_up_all_switch?(item)
    return false unless follow_up_any_switch?(item)
    return false unless follow_up_eval?(item)
    return rand < item.follow_chance
  end
  
  #--------------------------------------------------------------------------
  # new method: follow_up_all_states?
  #--------------------------------------------------------------------------
  def follow_up_all_states?(item)
    for state_id in item.follow_states_all
      next if $data_states[state_id].nil?
      return false unless state?(state_id)
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: follow_up_any_states?
  #--------------------------------------------------------------------------
  def follow_up_any_states?(item)
    return true if item.follow_states_any == []
    for state_id in item.follow_states_any
      next if $data_states[state_id].nil?
      return true if state?(state_id)
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: follow_up_all_switch?
  #--------------------------------------------------------------------------
  def follow_up_all_switch?(item)
    for switch_id in item.follow_switch_all
      return false unless $game_switches[switch_id]
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: follow_up_any_switch?
  #--------------------------------------------------------------------------
  def follow_up_any_switch?(item)
    return true if item.follow_switch_all == []
    for switch_id in item.follow_switch_all
      return true if $game_switches[switch_id]
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: follow_up_eval?
  #--------------------------------------------------------------------------
  def follow_up_eval?(item)
    return true if item.follow_eval == ""
    return eval(item.follow_eval)
  end
  
end # Game_Battler

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================