#==============================================================================
# 
# ▼ Yanfly Engine Ace - Skill Steal v1.00
# -- Last Updated: 2011.12.10
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-SkillSteal"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.10 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script enables items and skills to have skill stealing properties. When
# an actor uses that said item or skill on an enemy and the enemy has skills
# that can be stolen, that actor will learn all of the skills the enemy has to
# provide. This skill stealing system is madeakin to the Final Fantasy X's
# Lancet skill from Kimahri.
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
# <skill steal>
# If this skill targets an enemy, the actor who uses it will learn all of the
# stealable skills the enemy knows in its action list.
# 
# <stealable skill>
# A skill with this notetag can be stolen from enemies if it is listed within
# the enemy's action list.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <skill steal>
# If this item targets an enemy, the actor who uses it will learn all of the
# stealable skills the enemy knows in its action list.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module SKILL_STEAL
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Battlelog Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These are the various battlelog settings made for skill stealing. Change
    # the text and message duration for a successful skill stealing.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MSG_SKILL_STEAL = "%s learns %s from %s!" # Text for successful steal.
    MSG_DURATION    = 4                       # Lower number = shorter duration.
    
  end # SKILL_STEAL
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module USABLEITEM
    
    SKILL_STEAL     = /<(?:SKILL_STEAL|skill steal)>/i
    STEALABLE_SKILL = /<(?:STEALABLE_SKILL|stealable skill)>/i
    
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
  class <<self; alias load_database_ss load_database; end
  def self.load_database
    load_database_ss
    load_notetags_ss
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_ss
  #--------------------------------------------------------------------------
  def self.load_notetags_ss
    groups = [$data_skills, $data_items]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_ss
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :skill_steal
  attr_accessor :stealable_skill
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_ss
  #--------------------------------------------------------------------------
  def load_notetags_ss
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::SKILL_STEAL
        @skill_steal = true
      when YEA::REGEXP::USABLEITEM::STEALABLE_SKILL
        next unless self.is_a?(RPG::Skill)
        @stealable_skill = true
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::UsableItem

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: item_user_effect
  #--------------------------------------------------------------------------
  alias game_battler_item_user_effect_ss item_user_effect
  def item_user_effect(user, item)
    game_battler_item_user_effect_ss(user, item)
    item_skill_steal_effect(user, item)
  end
  
  #--------------------------------------------------------------------------
  # new method: item_skill_steal_effect
  #--------------------------------------------------------------------------
  def item_skill_steal_effect(user, item)
    return unless item.skill_steal
    return unless user.actor?
    return if self.actor?
    for skill in stealable_skills
      next if user.skill_learn?(skill)
      @result.success = true
      break
    end
  end
  
end # Game_Battler

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # stealable_skills
  #--------------------------------------------------------------------------
  def stealable_skills
    array = []
    for action in enemy.actions
      skill = $data_skills[action.skill_id]
      array.push(skill) if skill.stealable_skill
    end
    return array
  end
  
end # Game_Enemy

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: apply_item_effects
  #--------------------------------------------------------------------------
  alias scene_battle_apply_item_effects_ss apply_item_effects
  def apply_item_effects(target, item)
    scene_battle_apply_item_effects_ss(target, item)
    apply_skill_steal(target, item)
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_skill_steal
  #--------------------------------------------------------------------------
  def apply_skill_steal(target, item)
    return unless item.skill_steal
    return if target.actor?
    return unless @subject.actor?
    for skill in target.stealable_skills
      next if @subject.skill_learn?(skill)
      @subject.learn_skill(skill.id)
      string = YEA::SKILL_STEAL::MSG_SKILL_STEAL
      skill_text = sprintf("\\i[%d]%s", skill.icon_index, skill.name)
      text = sprintf(string, @subject.name, skill_text, target.name)
      @log_window.add_text(text)
      YEA::SKILL_STEAL::MSG_DURATION.times do @log_window.wait end
      @log_window.back_one
    end
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================