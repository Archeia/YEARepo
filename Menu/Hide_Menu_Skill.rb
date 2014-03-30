#==============================================================================
# 
# ▼ Yanfly Engine Ace - Hide Menu Skills v1.01
# -- Last Updated: 2011.12.11
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-HideMenuSkills"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.11 - Started Script and Finished.
#            - Added <hide eval> notetags.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Have some skills you want hidden until certain conditions are met? Well, now
# you can! This script will only hide the skills from the default skill list
# menus. Anything that displays otherwise may or may not hide them depending on
# the script and what it bases off of.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <hide always>
# This skill will always be hidden from the default skill list windows.
# 
# <hide in battle>
# This skill will always be hidden from the default skill window in battle.
# 
# <hide until usable>
# This will require the skill to be usable before it appears in the window.
# 
# <hide if switch: x>
# This skill will be hidden if switch x is on. The skill will be shown if
# switch x is off. This switch is considered part of the "any" category.
# 
# <hide any switch: x>
# <hide any switch: x, x>
# This skill will be hidden if any of the switches x is on. Use multiple tags
# or separate the switch ID's with commas.
# 
# <hide all switch: x>
# <hide all switch: x, x>
# This skill will be hidden until all of the switches x are on. Use multiple
# tags or separate the switch ID's with commas.
# 
# <hide eval>
#  string
#  string
# </hide eval>
# For the more advanced users, replace string with lines of code to check for
# whether or not to hide the skill. If multiple lines are used, they are all
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
    
    HIDE_ALWAYS     = /<(?:HIDE_ALWAYS|hide always)>/i
    HIDE_IN_BATTLE  = /<(?:HIDE_IN_BATTLE|hide in battle)>/i
    HIDE_IF_SWITCH  = /<(?:HIDE_IF_SWITCH|hide if switch):[ ](\d+)>/i
    HIDE_UNTIL_USABLE = /<(?:HIDE_UNTIL_USABLE|hide until usable)>/i
    
    HIDE_ANY_SWITCH = 
      /<(?:HIDE_ANY_SWITCH|hide any switch):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    HIDE_ALL_SWITCH = 
      /<(?:HIDE_ALL_SWITCH|hide all switch):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
    HIDE_EVAL_ON  = /<(?:HIDE_EVAL|hide eval)>/i
    HIDE_EVAL_OFF = /<\/(?:HIDE_EVAL|hide eval)>/i
    
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
  class <<self; alias load_database_hms load_database; end
  def self.load_database
    load_database_hms
    load_notetags_hms
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_hms
  #--------------------------------------------------------------------------
  def self.load_notetags_hms
    groups = [$data_skills]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_hms
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Skill
#==============================================================================

class RPG::Skill < RPG::UsableItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :hide_always
  attr_accessor :hide_in_battle
  attr_accessor :hide_any_switch
  attr_accessor :hide_all_switch
  attr_accessor :hide_until_usable
  attr_accessor :hide_eval
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_hms
  #--------------------------------------------------------------------------
  def load_notetags_hms
    @hide_eval = nil
    @hide_any_switch = []
    @hide_all_switch = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::SKILL::HIDE_ALWAYS
        @hide_always = true
      when YEA::REGEXP::SKILL::HIDE_IN_BATTLE
        @hide_in_battle = true
      when YEA::REGEXP::SKILL::HIDE_UNTIL_USABLE
        @hide_until_usable = true
      when YEA::REGEXP::SKILL::HIDE_IF_SWITCH
        @hide_any_switch.push($1.to_i)
      when YEA::REGEXP::SKILL::HIDE_ANY_SWITCH
        $1.scan(/\d+/).each { |num| 
        @hide_any_switch.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::SKILL::HIDE_ALL_SWITCH
        $1.scan(/\d+/).each { |num| 
        @hide_all_switch.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::SKILL::HIDE_EVAL_ON
        @hide_eval_on = true
      when YEA::REGEXP::SKILL::HIDE_EVAL_OFF
        @hide_eval_on = false
      else
        next unless @hide_eval_on
        @hide_eval = "" if @hide_eval.nil?
        @hide_eval += line.to_s
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Skill

#==============================================================================
# ■ Window_SkillList
#==============================================================================

class Window_SkillList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: include?
  #--------------------------------------------------------------------------
  def include?(item)
    return false if hide_eval?(item)
    return false if item.hide_always
    return false if item.hide_in_battle && $game_party.in_battle
    return false if hide_any_switch?(item)
    return false if hide_all_switch?(item)
    unless @actor.nil?
      return false if item.hide_until_usable && !@actor.usable?(item)
    end
    return item && item.stype_id == @stype_id
  end
  
  #--------------------------------------------------------------------------
  # new method: hide_eval?
  #--------------------------------------------------------------------------
  def hide_eval?(item)
    return false if item.hide_eval.nil?
    return eval(item.hide_eval)
  end
  
  #--------------------------------------------------------------------------
  # new method: hide_any_switch?
  #--------------------------------------------------------------------------
  def hide_any_switch?(item)
    for switch_id in item.hide_any_switch
      return true if $game_switches[switch_id]
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: hide_all_switch?
  #--------------------------------------------------------------------------
  def hide_all_switch?(item)
    return false if item.hide_all_switch == []
    for switch_id in item.hide_all_switch
      return false unless $game_switches[switch_id]
    end
    return true
  end
  
end # Window_SkillList

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================