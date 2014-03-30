#==============================================================================
# 
# ▼ Yanfly Engine Ace - Enemy Levels Add-On: Doppelganger v1.00
# -- Last Updated: 2012.01.23
# -- Level: Normal
# -- Requires: Yanfly Engine Ace - Enemy Levels v1.00+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-Doppelganger"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.23 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script gives the ability to base an enemy's stats off of a class or, as
# the script title suggests, an actor as a doppelganger. Doppelgangers will
# have the option of copying an actor's name, naming it differently, copying
# their stats, and even going as far as copying their current skills.
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
# <doppelganger battler: string>
# This will set the battler used for the current actor to the battler filename
# of string. If no battler is used, doppelgangers will use their default image.
# Doppelganger battlers will give priority to script called battlers, then
# actor doppelganger battlers, then class doppelganger battlers, then default
# enemy battlers.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <doppelganger battler: string>
# This will set the battler used for the current class to the battler filename
# of string. If no battler is used, doppelgangers will use their default image.
# Doppelganger battlers will give priority to script called battlers, then
# actor doppelganger battlers, then class doppelganger battlers, then default
# enemy battlers.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemies notebox in the database.
# -----------------------------------------------------------------------------
# <class stats: x>
# This notetag will cause the enemy to take on the base stats of class x at
# that particular level. Note that this tag will only cause the enemy to take
# on the class's stats. Any traits or other custom features related to that
# class will not be factored in. This will take priority over the enemy's
# default stats but will not take priority over a doppelganger actor's stats.
# 
# <doppelganger: x>
# This notetag will cause the enemy to take on the base stats and level of
# actor x. Any traits or other custom features related to that actor will not
# be factored in. This will take priority over the enemy's default stats and
# class stats.
# 
# <doppelganger member: x>
# This notetag will cause the enemy to take on the base stats and level of the
# party member with index x. Like the doppelganger, any traits or other custom
# features related to that actor will not be factored in. This will take
# priority over the enemy's default stats and class stats. In the event that
# no such member exists in slot x, then the monster will actually not appear
# and not participate in battle. Remember, the first party member's index is 0.
# 
# -----------------------------------------------------------------------------
# Script Calls - These commands are used with script calls.
# -----------------------------------------------------------------------------
# $game_actors[actor_id].doppelimage = string
# This will set the specified actor's doppelganger battler image to whatever
# string is as the filename. This can be done mid-game and whatever you set the
# new doppelganger battler image to be will override the actor doppelganger
# and class doppelganger battler images. Set this to nil to nullify it.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires Yanfly Engine Ace - Enemy Levels v1.00+. Place this
# script under Yanfly Engine Ace - Enemy Levels in the script listing.
# 
#==============================================================================

module YEA
  module DOPPELGANGER
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Doppelganger Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust the settings here for doppelgangers. Doppelgangers can copy an
    # actor's name, add on a prefix or suffix, and copy the actor's skills.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COPY_NAME  = true       # Uses the actor's name for doppelgangers.
    NAME_TEXT  = "Fake %s"  # Name appearance for doppelgangers.
    COPY_SKILL = true       # Uses the actor's skills for doppelgangers.
    
  end # DOPPELGANGER
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

if $imported["YEA-EnemyLevels"]

module YEA
  module REGEXP
  module BASEITEM
    
    DOPPELIMAGE  = /<(?:DOPPELGANGER_BATTLER|doppelganger battler):[ ](.*)>/i
    
  end # BASEITEM
  module ENEMY
    
    CLASS_STATS  = /<(?:CLASS_STATS|class stats):[ ](\d+)>/i
    DOPPELGANGER = /<(?:DOPPELGANGER|doppelganger):[ ](\d+)>/i
    DOPPELMEMBER = /<(?:DOPPELGANGER_MEMBER|doppelganger member):[ ](\d+)>/i
      
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
  class <<self; alias load_database_doppel load_database; end
  def self.load_database
    load_database_doppel
    load_notetags_doppel
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_doppel
  #--------------------------------------------------------------------------
  def self.load_notetags_doppel
    groups = [$data_actors, $data_classes, $data_enemies]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_doppel
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
  attr_accessor :doppelimage
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_doppel
  #--------------------------------------------------------------------------
  def load_notetags_doppel
    @doppelimage = ""
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::DOPPELIMAGE
        @doppelimage = $1.to_s
      end
    } # self.note.split
    #---
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ RPG::Enemy
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :class_id
  attr_accessor :doppelganger
  attr_accessor :doppelmember
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_doppel
  #--------------------------------------------------------------------------
  def load_notetags_doppel
    @class_id = 0
    @doppelganger = 0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ENEMY::CLASS_STATS
        @class_id = $1.to_i
      when YEA::REGEXP::ENEMY::DOPPELGANGER
        @doppelganger = $1.to_i
      when YEA::REGEXP::ENEMY::DOPPELMEMBER
        @doppelmember = $1.to_i
      end
    } # self.note.split
    #---
  end
  
  #--------------------------------------------------------------------------
  # new method: actions
  #--------------------------------------------------------------------------
  if YEA::DOPPELGANGER::COPY_SKILL
  def actions
    return @actions if doppelganger_actor.nil?
    list = @actions.dup
    action = RPG::Enemy::Action.new
    action.skill_id = doppelganger_actor.attack_skill_id
    list.push(action)
    for skill in doppelganger_actor.skills
      next unless doppelganger_actor.added_skill_types.include?(skill.stype_id)
      action = RPG::Enemy::Action.new
      action.skill_id = skill.id
      list.push(action)
    end
    return list
  end
  end # YEA::DOPPELGANGER::COPY_SKILL
  
  #--------------------------------------------------------------------------
  # new method: doppelganger_actor
  #--------------------------------------------------------------------------
  def doppelganger_actor
    return doppelmember_actor unless doppelmember_actor.nil?
    return $game_actors[@doppelganger] if @doppelganger > 0
  end
  
  #--------------------------------------------------------------------------
  # new method: doppelmember_actor
  #--------------------------------------------------------------------------
  def doppelmember_actor
    return nil if @doppelmember.nil?
    return $game_party.battle_members[@doppelmember]
  end
  
end # RPG::Enemy

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :doppelimage
  
  #--------------------------------------------------------------------------
  # new method: doppelimage
  #--------------------------------------------------------------------------
  def doppelimage
    return @doppelimage unless @doppelimage.nil?
    return self.actor.doppelimage unless self.actor.doppelimage.nil?
    return self.class.doppelimage unless self.class.doppelimage.nil?
    return nil
  end
  
end # Game_Actor

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: level=
  #--------------------------------------------------------------------------
  alias game_enemy_level_equal_doppel level=
  def level=(value)
    return unless doppelganger.nil?
    game_enemy_level_equal_doppel(value)
  end
  
  #--------------------------------------------------------------------------
  # alias method: set_level_type
  #--------------------------------------------------------------------------
  alias game_enemy_set_level_type_doppel set_level_type
  def set_level_type
    return @level = doppelganger.level unless doppelganger.nil?
    game_enemy_set_level_type_doppel
  end
  
  #--------------------------------------------------------------------------
  # new method: class
  #--------------------------------------------------------------------------
  def class
    return doppelganger.class unless doppelganger.nil?
    return $data_classes[enemy.class_id]
  end
  
  #--------------------------------------------------------------------------
  # new method: doppelganger
  #--------------------------------------------------------------------------
  def doppelganger
    return doppelmember unless doppelmember.nil?
    return $game_actors[enemy.doppelganger]
  end
  
  #--------------------------------------------------------------------------
  # new method: doppelmember
  #--------------------------------------------------------------------------
  def doppelmember
    return nil if enemy.doppelmember.nil?
    return $game_party.battle_members[enemy.doppelmember]
  end
  
  #--------------------------------------------------------------------------
  # alias method: param_base
  #--------------------------------------------------------------------------
  alias game_enemy_param_base_doppel param_base
  def param_base(param_id)
    return actor_base_stats(param_id) unless doppelganger.nil?
    return class_base_stats(param_id) unless self.class.nil?
    return game_enemy_param_base_doppel(param_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: actor_base_stats
  #--------------------------------------------------------------------------
  def actor_base_stats(param_id)
    return game_enemy_param_base_doppel(param_id) if @level.nil?
    return doppelganger.param_base(param_id) + doppelganger.param_plus(param_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: class_base_stats
  #--------------------------------------------------------------------------
  def class_base_stats(param_id)
    return game_enemy_param_base_doppel(param_id) if @level.nil?
    return self.class.params[param_id, @level] if @level <= 99
    if $imported["YEA-AdjustLimits"]
      return self.class.above_lv99_params(param_id, @level)
    end
    return game_enemy_param_base_doppel(param_id)
  end
  
  #--------------------------------------------------------------------------
  # alias method: feature_objects
  #--------------------------------------------------------------------------
  alias game_enemy_feature_objects_doppel feature_objects
  def feature_objects
    result = game_enemy_feature_objects_doppel
    result += [self.class] unless self.class.nil?
    result += [doppelganger.actor] unless doppelganger.nil?
    return result
  end
  
  #--------------------------------------------------------------------------
  # alias method: name
  #--------------------------------------------------------------------------
  alias game_enemy_name_doppel name
  def name
    return doppelganger_name if copy_doppel_name?
    return game_enemy_name_doppel
  end
  
  def doppelganger_name
    fmt = YEA::DOPPELGANGER::NAME_TEXT
    return sprintf(fmt, doppelganger.name)
  end
  
  #--------------------------------------------------------------------------
  # new method: copy_doppel_name?
  #--------------------------------------------------------------------------
  def copy_doppel_name?
    return false if doppelganger.nil?
    return YEA::DOPPELGANGER::COPY_NAME
  end
  
  #--------------------------------------------------------------------------
  # new method: change_doppelganger_battler
  #--------------------------------------------------------------------------
  def change_doppelganger_battler
    return if doppelganger.nil?
    return if doppelganger.doppelimage == ""
    @battler_name = doppelganger.doppelimage
    @battler_hue = 0
  end
  
end # Game_Enemy

#==============================================================================
# ■ Game_Troop
#==============================================================================

class Game_Troop < Game_Unit
  
  #--------------------------------------------------------------------------
  # alias method: init_screen_tone
  #--------------------------------------------------------------------------
  alias game_troop_init_screen_tone_doppel init_screen_tone
  def init_screen_tone
    game_troop_init_screen_tone_doppel
    check_doppelmember
    change_doppelimage
  end
  
  #--------------------------------------------------------------------------
  # new method: check_doppelmember
  #--------------------------------------------------------------------------
  def check_doppelmember
    for member in @enemies
      next if member.enemy.doppelmember.nil?
      @enemies.delete(member) if member.doppelmember.nil?
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: change_doppelimage
  #--------------------------------------------------------------------------
  def change_doppelimage
    for member in @enemies
      next if member.doppelganger.nil?
      member.change_doppelganger_battler
    end
  end
  
end # Game_Troop

end # $imported["YEA-EnemyLevels"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================