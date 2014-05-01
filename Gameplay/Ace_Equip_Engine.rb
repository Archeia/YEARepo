#==============================================================================
# 
# ▼ Yanfly Engine Ace - Ace Equip Engine v1.06
# -- Last Updated: 2014.05.01
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-AceEquipEngine"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2014.05.01 - Bug Fixed: Refresh Equip Item List when change slot.
# 2012.02.02 - Bug Fixed: Crash when changing classes to different equip slots.
# 2012.01.22 - Bug Fixed: <equip slot> notetags updated to factor in spaces.
# 2012.01.05 - Compatibility Update: Equip Dynamic Stats
# 2011.12.30 - Bug Fixed: Stats didn't update.
# 2011.12.23 - Script efficiency optimized.
# 2011.12.18 - Script efficiency optimized.
# 2011.12.13 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# The default equipment system in RPG Maker VX is the standard equipment system
# seen in all of the previous iterations, which consists of weapon, shield,
# headgear, bodygear, and accessory. To break free of that norm, this script
# allows users access to giving actors and/or classes dynamic equipment setups
# (including having multiples of the same categories). In addition to having
# different equip slot setups, newer equipment types can be made to allow for
# more diversity in armour types.
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
# <equip slots>
#  string
#  string
# </equip slots>
# This sets the actor's default slots to whatever is listed in between the two
# notetags. An actor's custom equip slots will take priority over a class's
# custom equip slots, which will take priority over the default equip slots.
# Replace "string" with the proper equipment type name or when in doubt, use
# "equip type: x" with x as the equipment type.
# 
# <starting gear: x>
# <starting gear: x, x>
# Adds armour x to the actor's list of starting gear. This is used primarily
# for the newer pieces of gear that can't be added through the starting set of
# equipment through the RPG Maker VX Ace editor by default. Insert multiple of
# these notetags to add more pieces of starting gear if so desired.
# 
# <fixed equip: x>
# <fixed equip: x, x>
# This will fix the equip type x. Fixed equip slots mean that the equipment
# already on it are unable to be exchanged in or out by the player. This tag
# has been made so that equip types can be fixed for equip type 5 and above.
# Use multiple of these notetags to add more fixed equipment restrictions.
# 
# <sealed equip: x>
# <sealed equip: x, x>
# This will seal the equip type x. Sealed equip slots mean that no equipment
# can be equipped onto that equip type slot. This tag has been made so that
# equip types can be sealed for equip type 5 and above. Use multiple of these
# notetags to add more sealed equipment restrictions.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <equip slots>
#  string
#  string
# </equip slots>
# This sets the class's default slots to whatever is listed in between the two
# notetags. An actor's custom equip slots will take priority over a class's
# custom equip slots, which will take priority over the default equip slots.
# Replace "string" with the proper equipment type name or when in doubt, use
# "equip type: x" with x as the equipment type.
# 
# <fixed equip: x>
# <fixed equip: x, x>
# This will fix the equip type x. Fixed equip slots mean that the equipment
# already on it are unable to be exchanged in or out by the player. This tag
# has been made so that equip types can be fixed for equip type 5 and above.
# Use multiple of these notetags to add more fixed equipment restrictions.
# 
# <sealed equip: x>
# <sealed equip: x, x>
# This will seal the equip type x. Sealed equip slots mean that no equipment
# can be equipped onto that equip type slot. This tag has been made so that
# equip types can be sealed for equip type 5 and above. Use multiple of these
# notetags to add more sealed equipment restrictions.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <fixed equip: x>
# <fixed equip: x, x>
# This will fix the equip type x. Fixed equip slots mean that the equipment
# already on it are unable to be exchanged in or out by the player. This tag
# has been made so that equip types can be fixed for equip type 5 and above.
# Use multiple of these notetags to add more fixed equipment restrictions.
# 
# <sealed equip: x>
# <sealed equip: x, x>
# This will seal the equip type x. Sealed equip slots mean that no equipment
# can be equipped onto that equip type slot. This tag has been made so that
# equip types can be sealed for equip type 5 and above. Use multiple of these
# notetags to add more sealed equipment restrictions.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armour notebox in the database.
# -----------------------------------------------------------------------------
# <equip type: x>
# <equip type: string>
# For the newer equip types, replace x or string with the equip type ID or the
# name of the equip type respectively. This will set that armour to that
# particular equip type.
# 
# <fixed equip: x>
# <fixed equip: x, x>
# This will fix the equip type x. Fixed equip slots mean that the equipment
# already on it are unable to be exchanged in or out by the player. This tag
# has been made so that equip types can be fixed for equip type 5 and above.
# Use multiple of these notetags to add more fixed equipment restrictions.
# 
# <sealed equip: x>
# <sealed equip: x, x>
# This will seal the equip type x. Sealed equip slots mean that no equipment
# can be equipped onto that equip type slot. This tag has been made so that
# equip types can be sealed for equip type 5 and above. Use multiple of these
# notetags to add more sealed equipment restrictions.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <fixed equip: x>
# <fixed equip: x, x>
# This will fix the equip type x. Fixed equip slots mean that the equipment
# already on it are unable to be exchanged in or out by the player. This tag
# has been made so that equip types can be fixed for equip type 5 and above.
# Use multiple of these notetags to add more fixed equipment restrictions.
# 
# <sealed equip: x>
# <sealed equip: x, x>
# This will seal the equip type x. Sealed equip slots mean that no equipment
# can be equipped onto that equip type slot. This tag has been made so that
# equip types can be sealed for equip type 5 and above. Use multiple of these
# notetags to add more sealed equipment restrictions.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module EQUIP
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Equip Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This adjusts the default equip configuration. While actors can have their
    # own unique equipment configurations, it's recommended to not change too
    # much as things get really hairy when it comes to proper eventing.
    # 
    # ID   Equip Type
    # ---  ------------
    #  0   Weapon
    #  1   Shield
    #  2   Headgear
    #  3   Bodygear
    #  4   Accessory
    # 
    # Whatever you set the below slots to, the dual wield setup will be exactly
    # identical except that the second slot will be changed to a weapon (0).
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust this array to set the default slots used for all of your actors
    # and classes if they do not have a custom equipment slot setup.
    DEFAULT_BASE_SLOTS = [ 0, 1, 2, 3, 5, 6, 4, 4]
    
    # This hash adjusts the new equip types (past 4+). Adjust them to match
    # their names properly. You can choose to allow certain types of equipment
    # be removable or not, or whether or not optimize will affect them.
    TYPES ={
    # TypeID => ["Type Name", Removable?, Optimize?],
           0 => [   "Weapon",      false,      true],
           1 => [   "Shield",       true,      true],
           2 => [ "Headgear",       true,      true],
           3 => [ "Bodygear",       true,      true],
           4 => ["Accessory",       true,     false],
           5 => [    "Cloak",       true,      true],
           6 => [ "Necklace",       true,      true],
    } # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Equip Command List -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Here, you can adjust the order at which the commands appear (or even
    # remove commands as you see fit). Here's a list of which does what:
    # 
    # -------------------------------------------------------------------------
    # :command         Description
    # -------------------------------------------------------------------------
    # :equip           Activates the manual equip window. Default.
    # :optimize        Optimizes equipment for the actor. Default.
    # :clear           Clears all equipment from the actor. Default
    # 
    # And that's all of the currently available commands. This list will be
    # updated as more scripts become available.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This array arranges the order of which the commands appear in the Equip
    # Command window in the Equip Scene.
    COMMAND_LIST =[
      :equip,
      :optimize,
      :clear,
    # :custom1,
    # :custom2,
    ] # Do not remove this.
    
    #--------------------------------------------------------------------------
    # - Equip Custom Commands -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # For those who use scripts to that may produce unique effects for
    # equipping, use this hash to manage the custom commands for the Equip
    # Command Window. You can disable certain commands or prevent them from
    # appearing by using switches. If you don't wish to bind them to a switch,
    # set the proper switch to 0 for it to have no impact.
    #--------------------------------------------------------------------------
    CUSTOM_EQUIP_COMMANDS ={
    # :command => ["Display Name", EnableSwitch, ShowSwitch, Handler Method],
      :custom1 => [ "Custom Name",            0,          0, :command_name1],
      :custom2 => [ "Custom Text",           13,          0, :command_name2],
    } # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Misc Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This section adjusts the minor visuals that you see inside of the newly
    # organized Equip Scene. Adjust the settings as you see fit.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This sets the font size used for the status window in the lower right
    # corner of the screen (which shows stats and comparisons).
    STATUS_FONT_SIZE = 20
    
    # This sets the remove equip command in the item window.
    REMOVE_EQUIP_ICON = 185
    REMOVE_EQUIP_TEXT = "<Remove Equip>"
    
    # This sets the no-equipment text in the slot window.
    NOTHING_ICON = 185
    NOTHING_TEXT = "<Empty>"
    
  end # EQUIP
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    EQUIP_SLOTS_ON  = /<(?:EQUIP_SLOTS|equip slots)>/i
    EQUIP_SLOTS_OFF = /<\/(?:EQUIP_SLOTS|equip slots)>/i
    
    EQUIP_TYPE_INT = /<(?:EQUIP_TYPE|equip type):[ ]*(\d+)>/i
    EQUIP_TYPE_STR = /<(?:EQUIP_TYPE|equip type):[ ]*(.*)>/i
    
    STARTING_GEAR = /<(?:STARTING_GEAR|starting gear):[ ](\d+(?:\s*,\s*\d+)*)>/i
    
    FIXED_EQUIP = /<(?:FIXED_EQUIP|fixed equip):[ ](\d+(?:\s*,\s*\d+)*)>/i
    SEALED_EQUIP = /<(?:SEALED_EQUIP|sealed equip):[ ](\d+(?:\s*,\s*\d+)*)>/i
    
  end # BASEITEM
  end # REGEXP
end # YEA

#==============================================================================
# ■ Vocab
#==============================================================================

module Vocab
  
  #--------------------------------------------------------------------------
  # overwrite method: self.etype
  #--------------------------------------------------------------------------
  def self.etype(etype)
    return $data_system.terms.etypes[etype] if [0,1,2,3,4].include?(etype)
    return YEA::EQUIP::TYPES[etype][0] if YEA::EQUIP::TYPES.include?(etype)
    return ""
  end
  
end # Vocab

#==============================================================================
# ■ Icon
#==============================================================================

module Icon
  
  #--------------------------------------------------------------------------
  # self.remove_equip
  #--------------------------------------------------------------------------
  def self.remove_equip; return YEA::EQUIP::REMOVE_EQUIP_ICON; end
  
  #--------------------------------------------------------------------------
  # self.nothing_equip
  #--------------------------------------------------------------------------
  def self.nothing_equip; return YEA::EQUIP::NOTHING_ICON; end
    
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
  class <<self; alias load_database_aee load_database; end
  def self.load_database
    load_database_aee
    load_notetags_aee
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_aee
  #--------------------------------------------------------------------------
  def self.load_notetags_aee
    groups = [$data_actors, $data_classes, $data_weapons, $data_armors,
      $data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_aee
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
  attr_accessor :base_equip_slots
  attr_accessor :fixed_equip_type
  attr_accessor :sealed_equip_type
  attr_accessor :extra_starting_equips
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_aee
  #--------------------------------------------------------------------------
  def load_notetags_aee
    @base_equip_slots = []
    @equip_slots_on = false
    @fixed_equip_type = []
    @sealed_equip_type = []
    @extra_starting_equips = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::EQUIP_SLOTS_ON
        next unless self.is_a?(RPG::Actor) ||self.is_a?(RPG::Class)
        @equip_slots_on = true
      when YEA::REGEXP::BASEITEM::EQUIP_SLOTS_OFF
        next unless self.is_a?(RPG::Actor) ||self.is_a?(RPG::Class)
        @equip_slots_on = false
      #---
      when YEA::REGEXP::BASEITEM::STARTING_GEAR
        next unless self.is_a?(RPG::Actor)
        $1.scan(/\d+/).each { |num| 
        @extra_starting_equips.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::BASEITEM::FIXED_EQUIP
        $1.scan(/\d+/).each { |num| 
        @fixed_equip_type.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::BASEITEM::SEALED_EQUIP
        $1.scan(/\d+/).each { |num| 
        @sealed_equip_type.push(num.to_i) if num.to_i > 0 }
      #---
      when YEA::REGEXP::BASEITEM::EQUIP_TYPE_INT
        next unless self.is_a?(RPG::Armor)
        @etype_id = [1, $1.to_i].max
      when YEA::REGEXP::BASEITEM::EQUIP_TYPE_STR
        next unless self.is_a?(RPG::Armor)
        for key in YEA::EQUIP::TYPES
          id = key[0]
          next if YEA::EQUIP::TYPES[id][0].upcase != $1.to_s.upcase
          @etype_id = [1, id].max
          break
        end
      #---
      else
        if @equip_slots_on
          case line.upcase
          when /EQUIP TYPE[ ](\d+)/i, /EQUIP TYPE:[ ](\d+)/i
            id = $1.to_i
            @base_equip_slots.push(id) if [0,1,2,3,4].include?(id)
            @base_equip_slots.push(id) if YEA::EQUIP::TYPES.include?(id)
          when /WEAPON/i
            @base_equip_slots.push(0)
          when /SHIELD/i
            @base_equip_slots.push(1)
          when /HEAD/i
            @base_equip_slots.push(2)
          when /BODY/i, /ARMOR/i, /ARMOUR/i
            @base_equip_slots.push(3)
          when /ETC/i, /OTHER/i, /ACCESSOR/i
            @base_equip_slots.push(4)
          else
            text = line.upcase.delete(" ")
            for key in YEA::EQUIP::TYPES
              id = key[0]
              next if YEA::EQUIP::TYPES[id][0].upcase.delete(" ")!= text
              @base_equip_slots.push(id)
              break
            end
          end
        end
      end
    } # self.note.split
    #---
    return unless self.is_a?(RPG::Class)
    if @base_equip_slots.empty?
      @base_equip_slots = YEA::EQUIP::DEFAULT_BASE_SLOTS.clone
    end
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ Game_Temp
#==============================================================================

class Game_Temp
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :eds_actor
  attr_accessor :scene_equip_index
  attr_accessor :scene_equip_oy
  
end # Game_Temp

#==============================================================================
# ■ Game_BaseItem
#==============================================================================

class Game_BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :item_id
  
end # Game_BaseItem

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: equip_type_fixed?
  #--------------------------------------------------------------------------
  alias game_battlerbase_equip_type_fixed_aee equip_type_fixed?
  def equip_type_fixed?(etype_id)
    return true if fixed_etypes.include?(etype_id) if actor?
    return game_battlerbase_equip_type_fixed_aee(etype_id)
  end
  
  #--------------------------------------------------------------------------
  # alias method: equip_type_sealed?
  #--------------------------------------------------------------------------
  alias game_battlerbase_equip_type_sealed_aee equip_type_sealed?
  def equip_type_sealed?(etype_id)
    return true if sealed_etypes.include?(etype_id) if actor?
    return game_battlerbase_equip_type_sealed_aee(etype_id)
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: init_equips
  #--------------------------------------------------------------------------
  alias game_actor_init_equips_aee init_equips
  def init_equips(equips)
    game_actor_init_equips_aee(equips)
    equip_extra_starting_equips
  end
  
  #--------------------------------------------------------------------------
  # new method: equip_extra_starting_equips
  #--------------------------------------------------------------------------
  def equip_extra_starting_equips
    for equip_id in actor.extra_starting_equips
      armour = $data_armors[equip_id]
      next if armour.nil?
      etype_id = armour.etype_id
      next unless equip_slots.include?(etype_id)
      slot_id = empty_slot(etype_id)
      @equips[slot_id].set_equip(etype_id == 0, armour.id)
    end
    refresh
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: equip_slots
  #--------------------------------------------------------------------------
  def equip_slots
    return equip_slots_dual if dual_wield?
    return equip_slots_normal
  end
  
  #--------------------------------------------------------------------------
  # new method: equip_slots_normal
  #--------------------------------------------------------------------------
  def equip_slots_normal
    return self.actor.base_equip_slots if self.actor.base_equip_slots != []
    return self.class.base_equip_slots
  end
  
  #--------------------------------------------------------------------------
  # new method: equip_slots_dual
  #--------------------------------------------------------------------------
  def equip_slots_dual
    array = equip_slots_normal.clone
    array[1] = 0 if array.size >= 2
    return array
  end
  
  #--------------------------------------------------------------------------
  # new method: fixed_etypes
  #--------------------------------------------------------------------------
  def fixed_etypes
    array = []
    array |= self.actor.fixed_equip_type
    array |= self.class.fixed_equip_type
    for equip in equips
      next if equip.nil?
      array |= equip.fixed_equip_type
    end
    for state in states
      next if state.nil?
      array |= state.fixed_equip_type
    end
    return array
  end
  
  #--------------------------------------------------------------------------
  # new method: sealed_etypes
  #--------------------------------------------------------------------------
  def sealed_etypes
    array = []
    array |= self.actor.sealed_equip_type
    array |= self.class.sealed_equip_type
    for equip in equips
      next if equip.nil?
      array |= equip.sealed_equip_type
    end
    for state in states
      next if state.nil?
      array |= state.sealed_equip_type
    end
    return array
  end
  
  #--------------------------------------------------------------------------
  # alias method: change_equip
  #--------------------------------------------------------------------------
  alias game_actor_change_equip_aee change_equip
  def change_equip(slot_id, item)
    if item.nil? && !@optimize_clear
      etype_id = equip_slots[slot_id]
      return unless YEA::EQUIP::TYPES[etype_id][1]
    elsif item.nil? && @optimize_clear
      etype_id = equip_slots[slot_id]
      return unless YEA::EQUIP::TYPES[etype_id][2]
    end
    @equips[slot_id] = Game_BaseItem.new if @equips[slot_id].nil?
    game_actor_change_equip_aee(slot_id, item)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: optimize_equipments
  #--------------------------------------------------------------------------
  def optimize_equipments
    $game_temp.eds_actor = self
    @optimize_clear = true
    clear_equipments
    @optimize_clear = false
    equip_slots.size.times do |i|
      next if !equip_change_ok?(i)
      next unless can_optimize?(i)
      items = $game_party.equip_items.select do |item|
        item.etype_id == equip_slots[i] &&
        equippable?(item) && item.performance >= 0
      end
      change_equip(i, items.max_by {|item| item.performance })
    end
    $game_temp.eds_actor = nil
  end
  
  #--------------------------------------------------------------------------
  # new method: can_optimize?
  #--------------------------------------------------------------------------
  def can_optimize?(slot_id)
    etype_id = equip_slots[slot_id]
    return YEA::EQUIP::TYPES[etype_id][2]
  end
  
  #--------------------------------------------------------------------------
  # alias method: force_change_equip
  #--------------------------------------------------------------------------
  alias game_actor_force_change_equip_aee force_change_equip
  def force_change_equip(slot_id, item)
    @equips[slot_id] = Game_BaseItem.new if @equips[slot_id].nil?
    game_actor_force_change_equip_aee(slot_id, item)
  end
  
  #--------------------------------------------------------------------------
  # alias method: weapons
  #--------------------------------------------------------------------------
  alias game_actor_weapons_aee weapons
  def weapons
    anti_crash_equips
    return game_actor_weapons_aee
  end
  
  #--------------------------------------------------------------------------
  # alias method: armors
  #--------------------------------------------------------------------------
  alias game_actor_armors_aee armors
  def armors
    anti_crash_equips
    return game_actor_armors_aee
  end
  
  #--------------------------------------------------------------------------
  # alias method: equips
  #--------------------------------------------------------------------------
  alias game_actor_equips_aee equips
  def equips
    anti_crash_equips
    return game_actor_equips_aee
  end
  
  #--------------------------------------------------------------------------
  # new method: equips
  #--------------------------------------------------------------------------
  def anti_crash_equips
    for i in 0...@equips.size
      next unless @equips[i].nil?
      @equips[i] = Game_BaseItem.new
    end
  end
  
end # Game_Actor

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # overwrite method: change equip
  #--------------------------------------------------------------------------
  def command_319
    actor = $game_actors[@params[0]]
    return if actor.nil?
    if @params[1] == 0 && @params[2] != 0
      item = $data_weapons[@params[2]]
      return unless actor.equip_slots.include?(0)
      slot_id = actor.empty_slot(0)
    elsif @params[2] != 0
      item = $data_armors[@params[2]]
      return unless actor.equip_slots.include?(item.etype_id)
      slot_id = actor.empty_slot(item.etype_id)
    else
      slot_id = @params[1]
    end
    actor.change_equip_by_id(slot_id, @params[2])
  end
  
end # Game_Interpreter

#==============================================================================
# ■ Window_EquipStatus
#==============================================================================

class Window_EquipStatus < Window_Base
  
  #--------------------------------------------------------------------------
  # overwrite method: initialize
  #--------------------------------------------------------------------------
  def initialize(dx, dy)
    super(dx, dy, window_width, Graphics.height - dy)
    @actor = nil
    @temp_actor = nil
    refresh
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width * 2 / 5; end
  
  #--------------------------------------------------------------------------
  # overwrite method: refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    8.times {|i| draw_item(0, line_height * i, i) }
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_item
  #--------------------------------------------------------------------------
  def draw_item(dx, dy, param_id)
    draw_background_colour(dx, dy)
    draw_param_name(dx + 4, dy, param_id)
    draw_current_param(dx + 4, dy, param_id) if @actor
    drx = (contents.width + 22) / 2
    draw_right_arrow(drx, dy)
    draw_new_param(drx + 22, dy, param_id) if @temp_actor
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_background_colour
  #--------------------------------------------------------------------------
  def draw_background_colour(dx, dy)
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(dx+1, dy+1, contents.width - 2, line_height - 2)
    contents.fill_rect(rect, colour)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_param_name
  #--------------------------------------------------------------------------
  def draw_param_name(dx, dy, param_id)
    contents.font.size = YEA::EQUIP::STATUS_FONT_SIZE
    change_color(system_color)
    draw_text(dx, dy, contents.width, line_height, Vocab::param(param_id))
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_current_param
  #--------------------------------------------------------------------------
  def draw_current_param(dx, dy, param_id)
    change_color(normal_color)
    dw = (contents.width + 22) / 2
    draw_text(0, dy, dw, line_height, @actor.param(param_id).group, 2)
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_new_param
  #--------------------------------------------------------------------------
  def draw_new_param(dx, dy, param_id)
    contents.font.size = YEA::EQUIP::STATUS_FONT_SIZE
    new_value = @temp_actor.param(param_id)
    change_color(param_change_color(new_value - @actor.param(param_id)))
    draw_text(0, dy, contents.width-4, line_height, new_value.group, 2)
    reset_font_settings
  end
  
end # Window_EquipStatus

#==============================================================================
# ■ Window_EquipCommand
#==============================================================================

class Window_EquipCommand < Window_HorzCommand
  
  #--------------------------------------------------------------------------
  # overwrite method: make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    for command in YEA::EQUIP::COMMAND_LIST
      case command
      when :equip
        add_command(Vocab::equip2, :equip)
      when :optimize
        add_command(Vocab::optimize, :optimize)
      when :clear
        add_command(Vocab::clear, :clear)
      else
        process_custom_command(command)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # process_ok
  #--------------------------------------------------------------------------
  def process_ok
    $game_temp.scene_equip_index = index
    $game_temp.scene_equip_oy = self.oy
    super
  end
  
  #--------------------------------------------------------------------------
  # new method: process_custom_command
  #--------------------------------------------------------------------------
  def process_custom_command(command)
    return unless YEA::EQUIP::CUSTOM_EQUIP_COMMANDS.include?(command)
    show = YEA::EQUIP::CUSTOM_EQUIP_COMMANDS[command][2]
    continue = show <= 0 ? true : $game_switches[show]
    return unless continue
    text = YEA::EQUIP::CUSTOM_EQUIP_COMMANDS[command][0]
    switch = YEA::EQUIP::CUSTOM_EQUIP_COMMANDS[command][1]
    enabled = switch <= 0 ? true : $game_switches[switch]
    add_command(text, command, enabled)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: window_width
  #--------------------------------------------------------------------------
  def window_width; return 160; end
  
  #--------------------------------------------------------------------------
  # overwrite method: contents_width
  #--------------------------------------------------------------------------
  def contents_width; return width - standard_padding * 2; end
  
  #--------------------------------------------------------------------------
  # overwrite method: contents_height
  #--------------------------------------------------------------------------
  def contents_height
    ch = height - standard_padding * 2
    return [ch - ch % item_height, row_max * item_height].max
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: visible_line_number
  #--------------------------------------------------------------------------
  def visible_line_number; return 4; end
  
  #--------------------------------------------------------------------------
  # overwrite method: col_max
  #--------------------------------------------------------------------------
  def col_max; return 1; end
    
  #--------------------------------------------------------------------------
  # overwrite method: item_rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = index % col_max * (item_width + spacing)
    rect.y = index / col_max * item_height
    rect
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: ensure_cursor_visible
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    self.top_row = row if row < top_row
    self.bottom_row = row if row > bottom_row
  end
    
  #--------------------------------------------------------------------------
  # overwrite method: cursor_down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    if index < item_max - col_max || (wrap && col_max == 1)
      select((index + col_max) % item_max)
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: cursor_up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    if index >= col_max || (wrap && col_max == 1)
      select((index - col_max + item_max) % item_max)
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: process_pageup
  #--------------------------------------------------------------------------
  def process_pageup
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:pageup)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: process_pagedown
  #--------------------------------------------------------------------------
  def process_pagedown
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:pagedown)
  end
  
end # Window_EquipCommand

#==============================================================================
# ■ Window_EquipSlot
#==============================================================================

class Window_EquipSlot < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: initialize
  #--------------------------------------------------------------------------
  def initialize(dx, dy, dw)
    super(dx, dy, dw, Graphics.height - dy)
    @actor = nil
    refresh
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: window_height
  #--------------------------------------------------------------------------
  def window_height; return self.height; end
  
  #--------------------------------------------------------------------------
  # overwrite method: visible_line_number
  #--------------------------------------------------------------------------
  def visible_line_number; return item_max; end
  
  #--------------------------------------------------------------------------
  # overwrite method: refresh
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    super
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    return unless @actor
    rect = item_rect_for_text(index)
    change_color(system_color, enable?(index))
    draw_text(rect.x, rect.y, 92, line_height, slot_name(index))
    item = @actor.equips[index]
    dx = rect.x + 92
    dw = contents.width - dx - 24
    if item.nil?
      draw_nothing_equip(dx, rect.y, false, dw)
    else
      draw_item_name(item, dx, rect.y, enable?(index), dw)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_nothing_equip
  #--------------------------------------------------------------------------
  def draw_nothing_equip(dx, dy, enabled, dw)
    change_color(normal_color, enabled)
    draw_icon(Icon.nothing_equip, dx, dy, enabled)
    text = YEA::EQUIP::NOTHING_TEXT
    draw_text(dx + 24, dy, dw - 24, line_height, text)
  end
  
end # Window_EquipSlot

#==============================================================================
# ■ Window_EquipItem
#==============================================================================

class Window_EquipItem < Window_ItemList
  
  #--------------------------------------------------------------------------
  # overwrite method: col_max
  #--------------------------------------------------------------------------
  def col_max; return 1; end
  
  #--------------------------------------------------------------------------
  # overwrite method: slot_id=
  #--------------------------------------------------------------------------
  def slot_id=(slot_id)
    return if @slot_id == slot_id
    @slot_id = slot_id
    @last_item = nil
    self.oy = 0
    refresh
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    rect.width -= 4
    if item.nil?
      draw_remove_equip(rect)
      return
    end
    dw = contents.width - rect.x - 24
    draw_item_name(item, rect.x, rect.y, enable?(item), dw)
    draw_item_number(rect, item)
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_remove_equip
  #--------------------------------------------------------------------------
  def draw_remove_equip(rect)
    draw_icon(Icon.remove_equip, rect.x, rect.y)
    text = YEA::EQUIP::REMOVE_EQUIP_TEXT
    rect.x += 24
    rect.width -= 24
    draw_text(rect, text)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: include?
  #--------------------------------------------------------------------------
  def include?(item)
    if item.nil? && !@actor.nil?
      etype_id = @actor.equip_slots[@slot_id]
      return YEA::EQUIP::TYPES[etype_id][1]
    end
    return true if item.nil?
    return false unless item.is_a?(RPG::EquipItem)
    return false if @slot_id < 0
    return false if item.etype_id != @actor.equip_slots[@slot_id]
    return @actor.equippable?(item)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: enable?
  #--------------------------------------------------------------------------
  def enable?(item)
    if item.nil? && !@actor.nil?
      etype_id = @actor.equip_slots[@slot_id]
      return YEA::EQUIP::TYPES[etype_id][1]
    end
    return @actor.equippable?(item)
  end
  
  #--------------------------------------------------------------------------
  # new method: show
  #--------------------------------------------------------------------------
  def show
    @last_item = 0
    update_help
    super
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: update_help
  #--------------------------------------------------------------------------
  def update_help
    super
    return if @actor.nil?
    return if @status_window.nil?
    return if @last_item == item
    @last_item = item
    temp_actor = Marshal.load(Marshal.dump(@actor))
    temp_actor.force_change_equip(@slot_id, item)
    @status_window.set_temp_actor(temp_actor)
  end
  
end # Window_EquipItem

#==============================================================================
# ■ Window_EquipActor
#==============================================================================

class Window_EquipActor < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(dx, dy)
    super(dx, dy, window_width, fitting_height(4))
    @actor = nil
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width - 160; end
  
  #--------------------------------------------------------------------------
  # actor=
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return unless @actor
    draw_actor_face(@actor, 0, 0)
    draw_actor_simple_status(@actor, 108, line_height / 2)
  end
  
end # Window_EquipActor

#==============================================================================
# ■ Scene_Equip
#==============================================================================

class Scene_Equip < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # overwrite method: create_status_window
  #--------------------------------------------------------------------------
  def create_status_window
    wx = Graphics.width - (Graphics.width * 2 / 5)
    wy = @help_window.height + 120
    @status_window = Window_EquipStatus.new(wx, wy)
    @status_window.viewport = @viewport
    @status_window.actor = @actor
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: create_command_window
  #--------------------------------------------------------------------------
  def create_command_window
    wx = 0
    wy = @help_window.height
    ww = 160
    @command_window = Window_EquipCommand.new(wx, wy, ww)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    if !$game_temp.scene_equip_index.nil?
      @command_window.select($game_temp.scene_equip_index)
      @command_window.oy = $game_temp.scene_equip_oy
    end
    $game_temp.scene_equip_index = nil
    $game_temp.scene_equip_oy = nil
    @command_window.set_handler(:equip,    method(:command_equip))
    @command_window.set_handler(:optimize, method(:command_optimize))
    @command_window.set_handler(:clear,    method(:command_clear))
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
    process_custom_equip_commands
    create_actor_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_actor_window
  #--------------------------------------------------------------------------
  def create_actor_window
    wy = @help_window.height
    @actor_window = Window_EquipActor.new(@command_window.width, wy)
    @actor_window.viewport = @viewport
    @actor_window.actor = @actor
  end
  
  #--------------------------------------------------------------------------
  # new method: process_custom_equip_commands
  #--------------------------------------------------------------------------
  def process_custom_equip_commands
    for command in YEA::EQUIP::COMMAND_LIST
      next unless YEA::EQUIP::CUSTOM_EQUIP_COMMANDS.include?(command)
      called_method = YEA::EQUIP::CUSTOM_EQUIP_COMMANDS[command][3]
      @command_window.set_handler(command, method(called_method))
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: create_slot_window
  #--------------------------------------------------------------------------
  def create_slot_window
    wx = 0
    wy = @command_window.y + @command_window.height
    ww = Graphics.width - @status_window.width
    @slot_window = Window_EquipSlot.new(wx, wy, ww)
    @slot_window.viewport = @viewport
    @slot_window.help_window = @help_window
    @slot_window.status_window = @status_window
    @slot_window.actor = @actor
    @slot_window.set_handler(:ok,       method(:on_slot_ok))
    @slot_window.set_handler(:cancel,   method(:on_slot_cancel))
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: create_item_window
  #--------------------------------------------------------------------------
  def create_item_window
    wx = @slot_window.x
    wy = @slot_window.y
    ww = @slot_window.width
    wh = @slot_window.height
    @item_window = Window_EquipItem.new(wx, wy, ww, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.status_window = @status_window
    @item_window.actor = @actor
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @slot_window.item_window = @item_window
    @item_window.hide
  end
  
  #--------------------------------------------------------------------------
  # alias method: command_optimize
  #--------------------------------------------------------------------------
  alias scene_equip_command_optimize_aee command_optimize
  def command_optimize
    scene_equip_command_optimize_aee
    @actor_window.refresh
  end
  
  #--------------------------------------------------------------------------
  # alias method: command_clear
  #--------------------------------------------------------------------------
  alias scene_equip_command_clear_aee command_clear
  def command_clear
    scene_equip_command_clear_aee
    @actor_window.refresh
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_slot_ok
  #--------------------------------------------------------------------------
  alias scene_equip_on_slot_ok_aee on_slot_ok
  def on_slot_ok
    scene_equip_on_slot_ok_aee
    @slot_window.hide
    @item_window.refresh
    @item_window.show
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_item_ok
  #--------------------------------------------------------------------------
  alias scene_equip_on_item_ok_aee on_item_ok
  def on_item_ok
    scene_equip_on_item_ok_aee
    @actor_window.refresh
    @slot_window.show
    @item_window.hide
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_item_cancel
  #--------------------------------------------------------------------------
  alias scene_equip_on_item_cancel_aee on_item_cancel
  def on_item_cancel
    scene_equip_on_item_cancel_aee
    @slot_window.show
    @item_window.hide
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_actor_change
  #--------------------------------------------------------------------------
  alias scene_equip_on_actor_change_aee on_actor_change
  def on_actor_change
    scene_equip_on_actor_change_aee
    @actor_window.actor = @actor
  end
  
  #--------------------------------------------------------------------------
  # new method: command_name1
  #--------------------------------------------------------------------------
  def command_name1
    # Do nothing.
  end
  
  #--------------------------------------------------------------------------
  # new method: command_name2
  #--------------------------------------------------------------------------
  def command_name2
    # Do nothing.
  end
  
end # Scene_Equip

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================