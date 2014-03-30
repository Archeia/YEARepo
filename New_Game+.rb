#==============================================================================
# 
# ▼ Yanfly Engine Ace - Save Engine Add-On: New Game+ v1.00
# -- Last Updated: 2011.12.26
# -- Level: Normal
# -- Requires: YEA - Ace Save Engine v1.01+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-NewGame+"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.26 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# New Game+ is a great way to provide replay value for your game. It lets the
# player re-experience the game in a different way with either carried over
# items, to carried over party members, to carried over skills, switches, and
# variables even. There exists many options to change how New Game+ will work
# for your game.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <no carry over>
# This will cause this specific item to not carry over in New Game+ if the item
# can be carried over. This does not affect any items that actors may have
# equipped.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <no carry over>
# This will cause this specific item to not carry over in New Game+ if the item
# can be carried over. This does not affect any items that actors may have
# equipped.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armours notebox in the database.
# -----------------------------------------------------------------------------
# <no carry over>
# This will cause this specific item to not carry over in New Game+ if the item
# can be carried over. This does not affect any items that actors may have
# equipped.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires Yanfly Engine Ace - Ace Save Engine v1.01+ and the
# script must be placed under Ace Save Engine in the script listing.
# 
#==============================================================================

module YEA
  module NEW_GAME_PLUS
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Description
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    NGP_SWITCH = 100           # If Switch ON, the game file has NG+ flag.
    NGP_TEXT   = "New Game+"   # Text used to show New Game+.
    
    # This is the help window text used for New Game+ when the New Game+
    # option is highlighted.
    NGP_HELP   = "Start a new game using this file's settings."
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Carry Over Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust what carries over and what doesn't. These settings
    # are very specific so adjust them carefully.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This array contains all of the switches that you want carried over to
    # be maintained. Any switches that aren't here will be set false.
    CARRY_OVER_SWITCHES = [1, 2, 3]
    
    # This array contains all of the variables that you want carried over to
    # be maintained. Any variables that aren't here will be set to 0.
    CARRY_OVER_VARIABLES = [1..6]
    
    # If this is set to false, then actors will be completely reset back to
    # their original starting states. If it's set to true, then actors will
    # be kept exactly as they are.
    CARRY_OVER_ACTORS = true
    
    # These settings are only used if actors will be carried over. With this,
    # you can limit what specifics will be carried over for actors from levels
    # to equips to skills.
    CARRY_OVER_LEVELS = true
    CARRY_OVER_EQUIPS = true
    CARRY_OVER_SKILLS = true
    
    # If this is set to false, then the party members will revert back to the
    # original starting party members. If it's true, then the party setup will
    # remain exactly the same.
    CARRY_OVER_PARTY_MEMBERS = true
    
    # If any of these are set to false, then no items, weapons, or armours will
    # be carried over. If it's set to true, then the respective items will be
    # carried over to the newer game.
    CARRY_OVER_GOLD    = true
    CARRY_OVER_ITEMS   = true
    CARRY_OVER_WEAPONS = true
    CARRY_OVER_ARMOURS = true
    
  end # NEW_GAME_PLUS
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

if $imported["YEA-SaveEngine"]

module YEA
  module NEW_GAME_PLUS
    module_function
    #--------------------------------------------------------------------------
    # convert_integer_array
    #--------------------------------------------------------------------------
    def convert_integer_array(array)
      result = []
      array.each { |i|
        case i
        when Range; result |= i.to_a
        when Integer; result |= [i]
        end }
      return result
    end
    #--------------------------------------------------------------------------
    # converted_contants
    #--------------------------------------------------------------------------
    CARRY_OVER_SWITCHES = convert_integer_array(CARRY_OVER_SWITCHES)
    CARRY_OVER_VARIABLES = convert_integer_array(CARRY_OVER_VARIABLES)
  end # NEW_GAME_PLUS
  module REGEXP
  module BASEITEM
    
    NO_CARRY_OVER = /<(?:NO_CARRY_OVER|no carry over)>/i
    
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
  class <<self; alias load_database_ngp load_database; end
  def self.load_database
    load_database_ngp
    load_notetags_ngp
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_ngp
  #--------------------------------------------------------------------------
  def self.load_notetags_ngp
    groups = [$data_items, $data_weapons, $data_armors]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_ngp
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
  attr_accessor :no_carry_over
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_ngp
  #--------------------------------------------------------------------------
  def load_notetags_ngp
    @no_carry_over = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::NO_CARRY_OVER
        @no_carry_over = true
      end
    } # self.note.split
    #---
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ Switch
#==============================================================================

module Switch
  
  #--------------------------------------------------------------------------
  # self.new_game_plus
  #--------------------------------------------------------------------------
  def self.new_game_plus
    return $game_switches[YEA::NEW_GAME_PLUS::NGP_SWITCH]
  end
  
end # Switch

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # new method: setup_new_game_plus
  #--------------------------------------------------------------------------
  def self.setup_new_game_plus(index)
    create_new_game_plus_objects(index)
    $game_map.setup($data_system.start_map_id)
    $game_player.moveto($data_system.start_x, $data_system.start_y)
    $game_player.refresh
    Graphics.frame_count = 0
  end
  
  #--------------------------------------------------------------------------
  # new method: create_new_game_plus_objects
  #--------------------------------------------------------------------------
  def self.create_new_game_plus_objects(index)
    load_game_without_rescue(index)
    ngp_reset_switches
    ngp_reset_variables
    ngp_reset_self_switches
    ngp_reset_actors
    ngp_reset_party
  end
  
  #--------------------------------------------------------------------------
  # new method: ngp_reset_switches
  #--------------------------------------------------------------------------
  def self.ngp_reset_switches
    for i in 0...$data_system.switches.size
      next if i <= 0
      next if YEA::NEW_GAME_PLUS::CARRY_OVER_SWITCHES.include?(i)
      $game_switches[i] = false
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: ngp_reset_variables
  #--------------------------------------------------------------------------
  def self.ngp_reset_variables
    for i in 0...$data_system.variables.size
      next if i <= 0
      next if YEA::NEW_GAME_PLUS::CARRY_OVER_VARIABLES.include?(i)
      $game_variables[i] = 0
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: ngp_reset_self_switches
  #--------------------------------------------------------------------------
  def self.ngp_reset_self_switches
    $game_self_switches = Game_SelfSwitches.new
  end
  
  #--------------------------------------------------------------------------
  # new method: ngp_reset_actors
  #--------------------------------------------------------------------------
  def self.ngp_reset_actors
    unless YEA::NEW_GAME_PLUS::CARRY_OVER_ACTORS
      $game_actors = Game_Actors.new
    else
      #---
      unless YEA::NEW_GAME_PLUS::CARRY_OVER_LEVELS
        for i in 0...$data_actors.size
          actor = $game_actors[i]
          next if actor.nil?
          actor.new_game_plus_levels
        end
      end
      #---
      unless YEA::NEW_GAME_PLUS::CARRY_OVER_EQUIPS
        for i in 0...$data_actors.size
          actor = $game_actors[i]
          next if actor.nil?
          actor.new_game_plus_equips
        end
      end
      #---
      unless YEA::NEW_GAME_PLUS::CARRY_OVER_SKILLS
        for i in 0...$data_actors.size
          actor = $game_actors[i]
          next if actor.nil?
          actor.new_game_plus_skills
        end
      end
      #---
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: ngp_reset_party
  #--------------------------------------------------------------------------
  def self.ngp_reset_party
    gold = 0
    items = {}
    members = []
    #---
    if YEA::NEW_GAME_PLUS::CARRY_OVER_PARTY_MEMBERS
      for member in $game_party.members
        members.push(member.id)
      end
    end
    #---
    gold = $game_party.gold if YEA::NEW_GAME_PLUS::CARRY_OVER_GOLD
    #---
    if YEA::NEW_GAME_PLUS::CARRY_OVER_ITEMS
      for item in $data_items
        next if item.nil?
        next if item.no_carry_over
        items[item] = $game_party.item_number(item)
      end
    end
    #---
    if YEA::NEW_GAME_PLUS::CARRY_OVER_WEAPONS
      for item in $data_weapons
        next if item.nil?
        next if item.no_carry_over
        items[item] = $game_party.item_number(item)
      end
    end
    #---
    if YEA::NEW_GAME_PLUS::CARRY_OVER_ARMOURS
      for item in $data_armors
        next if item.nil?
        next if item.no_carry_over
        items[item] = $game_party.item_number(item)
      end
    end
    #---
    $game_party = Game_Party.new
    unless YEA::NEW_GAME_PLUS::CARRY_OVER_PARTY_MEMBERS
      $game_party.setup_starting_members
    end
    #---
    for member_id in members
      $game_party.add_actor(member_id)
    end
    $game_party.gain_gold(gold)
    for key in items
      item = key[0]
      next if item.nil?
      $game_party.gain_item(item, key[1])
    end
  end
  
end # DataManager

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: new_game_plus_levels
  #--------------------------------------------------------------------------
  def new_game_plus_levels
    @class_id = actor.class_id
    @level = actor.initial_level
    @exp = {}
    if $imported["YEA-ClassSystem"]
      init_unlocked_classes
      init_subclass
    end
    clear_param_plus
    init_exp
    refresh
  end
  
  #--------------------------------------------------------------------------
  # new method: new_game_plus_equips
  #--------------------------------------------------------------------------
  def new_game_plus_equips
    init_equips(actor.equips)
  end
  
  #--------------------------------------------------------------------------
  # new method: new_game_plus_skills
  #--------------------------------------------------------------------------
  def new_game_plus_skills
    init_skills
  end
  
end # Game_Actor

#==============================================================================
# ■ Window_FileAction
#==============================================================================

class Window_FileAction < Window_HorzCommand
  
  #--------------------------------------------------------------------------
  # alias method: add_load_command
  #--------------------------------------------------------------------------
  alias add_load_command_ngp add_load_command
  def add_load_command
    if new_game_plus?
      add_command(YEA::NEW_GAME_PLUS::NGP_TEXT, :new_game_plus)
    else
      add_load_command_ngp
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: new_game_plus?
  #--------------------------------------------------------------------------
  def new_game_plus?
    return false if @header.nil?
    return false if @header[:switches].nil?
    return @header[:switches][YEA::NEW_GAME_PLUS::NGP_SWITCH]
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_help
  #--------------------------------------------------------------------------
  alias update_help_ngp update_help
  def update_help
    case current_symbol
    when :new_game_plus; @help_window.set_text(YEA::NEW_GAME_PLUS::NGP_HELP)
    else; update_help_ngp
    end
  end
  
end # Window_FileAction

#==============================================================================
# ■ Scene_File
#==============================================================================

class Scene_File < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # alias method: create_action_window
  #--------------------------------------------------------------------------
  alias create_action_window_ngp create_action_window
  def create_action_window
    create_action_window_ngp
    @action_window.set_handler(:new_game_plus, method(:on_action_ngp))
  end
  
  #--------------------------------------------------------------------------
  # new method: on_action_ngp
  #--------------------------------------------------------------------------
  def on_action_ngp
    Sound.play_load
    DataManager.setup_new_game_plus(@file_window.index)
    fadeout_all
    $game_system.on_after_load
    SceneManager.goto(Scene_Map)
  end
  
end # Scene_File

end # $imported["YEA-SaveEngine"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================