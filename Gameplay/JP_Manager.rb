#==============================================================================
# 
# ▼ Yanfly Engine Ace - JP Manager v1.00
# -- Last Updated: 2012.01.07
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-JPManager"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.07 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script provides a base for JP implementation. JP is a currency similar
# to EXP that's gained through performing actions and leveling up in addition
# to killing enemies. This script provides modifiers that adjust the gains for
# JP through rates, individual gains per skill or item, and per enemy. Though
# this script provides no usage of JP by itself, future Yanfly Engine Ace
# scripts may make use of it.
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
# <jp rate: x%>
# Changes the JP earned rate to x%. This affects JP earned and not JP directly
# gained. If this notetag isn't used, the object will default to 100%.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <jp rate: x%>
# Changes the JP earned rate to x%. This affects JP earned and not JP directly
# gained. If this notetag isn't used, the object will default to 100%.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <jp gain: x>
# When the actor successfully hits an target with this action, the actor will
# earn x JP. If this notetag isn't used, the amount of JP earned will equal to
# the ACTION_JP constant in the module.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <jp gain: x>
# When the actor successfully hits an target with this action, the actor will
# earn x JP. If this notetag isn't used, the amount of JP earned will equal to
# the ACTION_JP constant in the module.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapon notebox in the database.
# -----------------------------------------------------------------------------
# <jp rate: x%>
# Changes the JP earned rate to x%. This affects JP earned and not JP directly
# gained. If this notetag isn't used, the object will default to 100%.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armour notebox in the database.
# -----------------------------------------------------------------------------
# <jp rate: x%>
# Changes the JP earned rate to x%. This affects JP earned and not JP directly
# gained. If this notetag isn't used, the object will default to 100%.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemy notebox in the database.
# -----------------------------------------------------------------------------
# <jp gain: x>
# Changes the amount of JP gained for killing the enemy to x. If this notetag
# isn't used, then the default JP gain will be equal to the amount set in the
# module through the constant ENEMY_KILL.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <jp rate: x%>
# Changes the JP earned rate to x%. This affects JP earned and not JP directly
# gained. If this notetag isn't used, the object will default to 100%.
# 
# -----------------------------------------------------------------------------
# Script Calls - These commands are used with script calls.
# -----------------------------------------------------------------------------
# $game_actors[x].earn_jp(y)
# $game_actors[x].earn_jp(y, z)
# This will cause actor x to earn y amount of JP. JP earned will be modified by
# any JP Rate traits provided through notetags. If z is used, z will be the
# class the JP is earned for.
# 
# $game_actors[x].gain_jp(y)
# $game_actors[x].gain_jp(y, z)
# This will cause actor x to gain y amount of JP. JP gained this way will not
# be modified by any JP Rate traits provided through notetags. If z is used,
# z will be the class the JP is gained for.
# 
# $game_actors[x].lose_jp(y)
# $game_actors[x].lose_jp(y, z)
# This will cause actor x to lose y amount of JP. JP lost this way will not be
# modified by any JP Rate traits provided through notetags. If z is used, z
# will be the class the JP is lost from.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script is compatible with Yanfly Engine Ace - Victory Aftermath v1.03+.
# If you wish to have Victory Aftermath display JP gains, make sure the version
# is 1.03+. Script placement of these two scripts don't matter.
# 
#==============================================================================

module YEA
  module JP
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General JP Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This adjusts the way JP appears visually in your game. Change the icon
    # used and the vocabulary used here. Furthermore, adjust the maximum amount
    # of JP that an actor can have at a time.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    ICON   = 0           # Icon index used to represent JP.
    VOCAB  = "JP"        # What JP will be called in your game.
    MAX_JP = 99999999    # Maximum JP an actor can have.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Default JP Gain Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # The following constants adjust how much JP is earned by default through
    # enemy kills, leveling up, and performing actions.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    ENEMY_KILL = 20     # JP earned for the whole party.
    LEVEL_UP   = 100    # JP earned when leveling up!
    ACTION_JP  = 5      # JP earned per successful hit.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Victory Message -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This adjusts the victory message shown for the default battle system and
    # the Yanfly Engine Ace - Victory Aftermath script (if used together).
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    VICTORY_MESSAGE   = "%s has earned %s %s!"
    VICTORY_AFTERMATH = "+%s%s"
    
  end # JP
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    JP_RATE = /<(?:JP_RATE|jp rate):[ ](\d+)([%％])>/i
    
  end # BASEITEM
  module USABLEITEM
    
    JP_GAIN = /<(?:JP_GAIN|jp gain):[ ](\d+)>/i
    
  end # USABLEITEM
  module ENEMY
    
    JP_GAIN = /<(?:JP_GAIN|jp gain):[ ](\d+)>/i
    
  end # ENEMY
  end # REGEXP
end # YEA

#==============================================================================
# ■ Vocab
#==============================================================================

module Vocab
  
  #--------------------------------------------------------------------------
  # new method: self.jp
  #--------------------------------------------------------------------------
  def self.jp
    return YEA::JP::VOCAB
  end
  
end # Vocab

#==============================================================================
# ■ Icon
#==============================================================================

module Icon
  
  #--------------------------------------------------------------------------
  # self.jp
  #--------------------------------------------------------------------------
  def self.jp; return YEA::JP::ICON; end
    
end # Icon

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
  class <<self; alias load_database_jp load_database; end
  def self.load_database
    load_database_jp
    load_notetags_jp
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_jp
  #--------------------------------------------------------------------------
  def self.load_notetags_jp
    groups = [$data_actors, $data_classes, $data_weapons, $data_armors,
      $data_states, $data_enemies, $data_items, $data_skills]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_jp
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
  attr_accessor :jp_rate
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_jp
  #--------------------------------------------------------------------------
  def load_notetags_jp
    @jp_rate = 1.0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::JP_RATE
        @jp_rate = $1.to_i * 0.01
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
  attr_accessor :jp_gain
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_jp
  #--------------------------------------------------------------------------
  def load_notetags_jp
    @jp_gain = YEA::JP::ACTION_JP
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::JP_GAIN
        @jp_gain = $1.to_i
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::UsableItem

#==============================================================================
# ■ RPG::Enemy
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :jp_gain
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_jp
  #--------------------------------------------------------------------------
  def load_notetags_jp
    @jp_gain = YEA::JP::ENEMY_KILL
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ENEMY::JP_GAIN
        @jp_gain = $1.to_i
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Enemy

#==============================================================================
# ■ BattleManager
#==============================================================================

module BattleManager
  
  #--------------------------------------------------------------------------
  # alias method: display_exp
  #--------------------------------------------------------------------------
  unless $imported["YEA-VictoryAftermath"]
  class <<self; alias battlemanager_display_exp_jp display_exp; end
  def self.display_exp
    battlemanager_display_exp_jp
    gain_jp
  end
  end # $imported["YEA-VictoryAftermath"]
  
  #--------------------------------------------------------------------------
  # new method: gain_jp
  #--------------------------------------------------------------------------
  def self.gain_jp
    amount = $game_troop.jp_total
    fmt = YEA::JP::VICTORY_MESSAGE
    for member in $game_party.members
      member.earn_jp(amount)
      next if $imported["YEA-VictoryAftermath"]
      value = member.battle_jp_earned.group
      $game_message.add('\.' + sprintf(fmt, member.name, value, Vocab::jp))
    end
    wait_for_message unless $imported["YEA-VictoryAftermath"]
  end
  
end # BattleManager

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # new method: jpr
  #--------------------------------------------------------------------------
  def jpr
    n = 1.0
    if actor?
      n *= self.actor.jp_rate
      n *= self.class.jp_rate
      for equip in equips
        next if equip.nil?
        n *= equip.jp_rate
      end
    end
    for state in states
      next if state.nil?
      n *= state.jp_rate
    end
    return n
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :battle_jp_earned
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_start
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_start_jp on_battle_start
  def on_battle_start
    game_battler_on_battle_start_jp
    @battle_jp_earned = 0
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_end
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_end_jp on_battle_end
  def on_battle_end
    game_battler_on_battle_end_jp
    @battle_jp_earned = 0
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_user_effect
  #--------------------------------------------------------------------------
  alias game_battler_item_user_effect_jp item_user_effect
  def item_user_effect(user, item)
    game_battler_item_user_effect_jp(user, item)
    user.earn_jp(item.jp_gain) if user.actor?
  end
  
end # Game_Battler

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: setup
  #--------------------------------------------------------------------------
  alias game_actor_setup_jp setup
  def setup(actor_id)
    game_actor_setup_jp(actor_id)
    init_jp
  end
  
  #--------------------------------------------------------------------------
  # new method: init_jp
  #--------------------------------------------------------------------------
  def init_jp
    @jp = {}
    @jp[@class_id] = 0
  end
  
  #--------------------------------------------------------------------------
  # new method: earn_jp
  #--------------------------------------------------------------------------
  def earn_jp(jp, class_id = nil)
    gain_jp(jp * jpr, class_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: gain_jp
  #--------------------------------------------------------------------------
  def gain_jp(jp, class_id = nil)
    init_jp if @jp.nil?
    class_id = @class_id if class_id.nil?
    @jp[class_id] = 0 if @jp[class_id].nil?
    @jp[class_id] += jp.to_i
    @jp[class_id] = [[@jp[class_id], YEA::JP::MAX_JP].min, 0].max
    @battle_jp_earned = 0 if @battle_jp_earned.nil? && $game_party.in_battle
    @battle_jp_earned += jp.to_i if $game_party.in_battle
  end
  
  #--------------------------------------------------------------------------
  # new method: lose_jp
  #--------------------------------------------------------------------------
  def lose_jp(jp, class_id = nil)
    gain_jp(-jp, class_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: jp
  #--------------------------------------------------------------------------
  def jp(class_id = nil)
    class_id = @class_id if class_id.nil?
    @jp[class_id] = 0 if @jp[class_id].nil?
    return @jp[class_id]
  end
  
  #--------------------------------------------------------------------------
  # alias method: level_up
  #--------------------------------------------------------------------------
  alias game_actor_level_up_jp level_up
  def level_up
    game_actor_level_up_jp
    earn_jp(YEA::JP::LEVEL_UP)
  end
  
end # Game_Actor

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: jp
  #--------------------------------------------------------------------------
  def jp
    return enemy.jp_gain
  end
  
end # Game_Enemy

#==============================================================================
# ■ Game_Troop
#==============================================================================

class Game_Troop < Game_Unit
  
  #--------------------------------------------------------------------------
  # new method: jp_total
  #--------------------------------------------------------------------------
  def jp_total
    dead_members.inject(0) {|r, enemy| r += enemy.jp }
  end
  
end # Game_Troop

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
  
  #--------------------------------------------------------------------------
  # new method: draw_actor_jp
  #--------------------------------------------------------------------------
  def draw_actor_jp(actor, dx, dy, dw = 112)
    draw_icon(Icon.jp, dx + dw - 24, dy) if Icon.jp > 0
    dw -= 24 if Icon.jp > 0
    change_color(system_color)
    draw_text(dx, dy, dw, line_height, Vocab::jp, 2)
    dw -= text_size(Vocab::jp).width
    change_color(normal_color)
    draw_text(dx, dy, dw, line_height, actor.jp.group, 2)
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_actor_jp_class
  #--------------------------------------------------------------------------
  def draw_actor_jp_class(actor, class_id, dx, dy, dw = 112)
    draw_icon(Icon.jp, dx + dw - 24, dy) if Icon.jp > 0
    dw -= 24 if Icon.jp > 0
    change_color(system_color)
    draw_text(dx, dy, dw, line_height, Vocab::jp, 2)
    dw -= text_size(Vocab::jp).width
    change_color(normal_color)
    draw_text(dx, dy, dw, line_height, actor.jp(class_id).group, 2)
  end
  
end # Window_Base

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================