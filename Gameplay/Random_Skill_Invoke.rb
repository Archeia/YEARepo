#==============================================================================
# 
# ▼ Yanfly Engine Ace - Random Skill Invoke v1.00
# -- Last Updated: 2011.12.17
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-RandomSkillInvoke"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.17 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script grants the option, that when designated skills with random
# invokes are used, they have the ability to result in other skills (within the
# skill's designated random pool). Only valid skills are capable of being used
# (meaning that they must meet the conditions to be used).
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
# <random invoke: x>
# <random invoke: x, x>
# This adds skill x to the random invoke pool (which includes the base skill
# itself, too). When the base skill is used, it will random select from all of
# the skills within the random invoke pool and use one. Only skills that meet
# the requirements of being used can be selected (meaning the battler must have
# sufficient MP costs, TP costs, no states that seal it, etc.). Multiples of
# this tag may be used to add more skills, and multiples of the same skill may
# be added to the random invoke pool.
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
    
    RANDOM_INVOKE = 
      /<(?:RANDOM_INVOKE|random invoke):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
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
  class <<self; alias load_database_rsi load_database; end
  def self.load_database
    load_database_rsi
    load_notetags_rsi
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_rsi
  #--------------------------------------------------------------------------
  def self.load_notetags_rsi
    for skill in $data_skills
      next if skill.nil?
      skill.load_notetags_rsi
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
  attr_accessor :random_invoke
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_rsi
  #--------------------------------------------------------------------------
  def load_notetags_rsi
    @random_invoke = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::SKILL::RANDOM_INVOKE
        $1.scan(/\d+/).each { |num| 
        @random_invoke.push(num.to_i) if num.to_i > 0 }
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Weapon

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # new method: invoke_random_skill
  #--------------------------------------------------------------------------
  def invoke_random_skill
    return unless current_action.item.is_a?(RPG::Skill)
    valid_skills = [current_action.item]
    for random_skill_id in current_action.item.random_invoke
      next unless usable?($data_skills[random_skill_id])
      valid_skills.push($data_skills[random_skill_id])
    end
    skill_id = valid_skills.sample.id
    current_action.set_skill(skill_id)
  end
  
end # Game_Battler

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: use_item
  #--------------------------------------------------------------------------
  alias scene_battle_use_item_rsi use_item
  def use_item
    @subject.invoke_random_skill
    scene_battle_use_item_rsi
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================