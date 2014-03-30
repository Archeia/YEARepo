#==============================================================================
# 
# ▼ Yanfly Engine Ace - Weapon Attack Replace v1.01
# -- Last Updated: 2011.12.19
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-WeaponAttackReplace"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.19 - Added notetags for Actors, and Classes.
# 2011.12.17 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# By default, RPG Maker VX Ace sets all normal attacks to call upon Skill #1
# to do all of the basic attack functions. While this is a great idea, it also
# meant that all weapons would share the same basic attack damage formula and
# effects. With this script, you can set different weapon types to use any
# skill for its basic attack.
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
# <attack skill: x>
# This sets the actor's default attack (if no weapon is equipped) to be x. The
# actor's custom attack skill will take priority over a class's custom attack
# skill, which will take priority over the default attack skill (skill #1).
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <attack skill: x>
# This sets the class's default attack (if no weapon is equipped) to be x. An
# actor's custom attack skill will take priority over the class's custom attack
# skill, which will take priority over the default attack skill (skill #1).
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <attack skill: x>
# This sets the worn weapon's attack skill to x. Note that if an actor is dual
# wielding, the attack skill of the first weapon will take priority over the
# second weapon.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# For maximum compatibility with YEA - Ace Battle Engine, place this script
# below Ace Battle Engine in the script listing.
# 
#==============================================================================

module YEA
  module WEAPON_ATTACK_REPLACE
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Basic Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # If for whatever reason, you wish to change the default attack skill to
    # something other than one, change the constant below.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_ATTACK_SKILL_ID = 1
    
  end # WEAPON_ATTACK_REPLACE
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    ATTACK_SKILL = /<(?:ATTACK_SKILL|attack skill):[ ](\d+)>/i
    
  end # BASEITEM
  module WEAPON
    
    ATTACK_SKILL = /<(?:ATTACK_SKILL|attack skill):[ ](\d+)>/i
    
  end # WEAPON
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_war load_database; end
  def self.load_database
    load_database_war
    load_notetags_war
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_war
  #--------------------------------------------------------------------------
  def self.load_notetags_war
    groups = [$data_actors, $data_classes, $data_weapons]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_war
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
  attr_accessor :attack_skill
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_war
  #--------------------------------------------------------------------------
  def load_notetags_war
    @attack_skill = nil
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::ATTACK_SKILL
        @attack_skill = $1.to_i
      #---
      end
    } # self.note.split
    #---
    return if self.is_a?(RPG::Actor)
    return unless @attack_skill.nil?
    @attack_skill = YEA::WEAPON_ATTACK_REPLACE::DEFAULT_ATTACK_SKILL_ID
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ RPG::Weapon
#==============================================================================

class RPG::Weapon < RPG::EquipItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :attack_skill
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_war
  #--------------------------------------------------------------------------
  def load_notetags_war
    @attack_skill = YEA::WEAPON_ATTACK_REPLACE::DEFAULT_ATTACK_SKILL_ID
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::WEAPON::ATTACK_SKILL
        @attack_skill = $1.to_i
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Weapon

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # overwrite method: attack_skill_id
  #--------------------------------------------------------------------------
  def attack_skill_id
    return weapon_attack_skill_id if actor?
    return YEA::WEAPON_ATTACK_REPLACE::DEFAULT_ATTACK_SKILL_ID
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: weapon_attack_skill_id
  #--------------------------------------------------------------------------
  def weapon_attack_skill_id
    for weapon in weapons
      next if weapon.nil?
      return weapon.attack_skill
    end
    return self.actor.attack_skill unless self.actor.attack_skill.nil?
    return self.class.attack_skill
  end
  
end # Game_Actor

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # new method: command_use_skill
  #--------------------------------------------------------------------------
  def command_attack
    @skill = $data_skills[BattleManager.actor.attack_skill_id]
    BattleManager.actor.input.set_skill(@skill.id)
    if $imported["YEA-BattleEngine"]
      status_redraw_target(BattleManager.actor)
      $game_temp.battle_aid = @skill
      if @skill.for_opponent?
        select_enemy_selection
      elsif @skill.for_friend?
        select_actor_selection
      else
        next_command
        $game_temp.battle_aid = nil
      end
    else
      if !@skill.need_selection?
        next_command
      elsif @skill.for_opponent?
        select_enemy_selection
      else
        select_actor_selection
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_actor_cancel
  #--------------------------------------------------------------------------
  alias scene_battle_on_actor_cancel_war on_actor_cancel
  def on_actor_cancel
    scene_battle_on_actor_cancel_war
    case @actor_command_window.current_symbol
    when :attack
      @help_window.hide
      @status_window.show
      @actor_command_window.activate
      status_redraw_target(BattleManager.actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_enemy_cancel
  #--------------------------------------------------------------------------
  alias scene_battle_on_enemy_cancel_war on_enemy_cancel
  def on_enemy_cancel
    scene_battle_on_enemy_cancel_war
    case @actor_command_window.current_symbol
    when :attack
      @help_window.hide
      @status_window.show
      @actor_command_window.activate
      status_redraw_target(BattleManager.actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: status_redraw_target
  #--------------------------------------------------------------------------
  def status_redraw_target(target)
    return unless target.actor?
    @status_window.draw_item($game_party.battle_members.index(target))
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================