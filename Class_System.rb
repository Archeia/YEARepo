#==============================================================================
# 
# ▼ Yanfly Engine Ace - Class System v1.10
# -- Last Updated: 2012.01.29
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ClassSystem"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.08.06 - Leveling issue if class level exceeds actor level.
# 2012.01.29 - Visual Bug: Disabled classes now have faded icons.
# 2012.01.08 - Compatibility Update: Learn Skill Engine
# 2012.01.05 - Bug Fixed: Equipment no longer gets duplicated.
# 2012.01.04 - Update: Autobattle will no longer use skills not available to
#              that class for specific actors.
# 2012.01.02 - Efficiency Update.
# 2011.12.26 - Added custom command functionality.
# 2011.12.23 - Compatibility Update: Class Specifics.
# 2011.12.22 - Compatibility Update: Ace Menu Engine.
# 2011.12.20 - Compatibility Update: Class Unlock Level.
# 2011.12.19 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script adds the ability for your player to freely change the classes of
# actors outside of battle from a menu. When changing classes, this script
# gives the option for the developer to choose whether or not classes have
# their own levels (causing the actor's level to reset back to the class's
# level) or to maintain the current level. In addition to providing the ability
# to change classes, equipping a subclass is also doable, and the mechanics of
# having a subclass can also be defined within this script.
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
# <unlocked classes: x>
# <unlocked classes: x, x>
# This will set the default classes as unlocked for the actor. This does not
# override the default classes unlocked in the module, but instead, adds on
# to the number of unlocked classes.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <icon: x>
# Sets the icon representing the class to x.
# 
# <help description>
#  string
#  string
# </help description>
# Sets the text used for the help window in the class scene. Multiple lines in
# the notebox will be strung together. Use | for a line break.
# 
# -----------------------------------------------------------------------------
# Script Calls - These commands are used with script calls.
# -----------------------------------------------------------------------------
# $game_actors[x].unlock_class(y)
# This allows actor x to unlock class y, making it available for switching in
# and out in the Class scene.
# 
# $game_actors[x].remove_class(y)
# This causes actor x to remove class y from being able to switch to and from.
# If the actor is currently class y, the class will not be removed. If the
# actor's current subclass is y, the subclass will be unequipped.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module CLASS_SYSTEM
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Class Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These are the general settings regarding the whole script. They control
    # various rules and regulations that this script undergoes. These settings
    # will also determine what a subclass can do for a player.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    CLASS_MENU_TEXT = "Class"  # Text that appears in the Main Menu.
    MAINTAIN_LEVELS = false    # Maintain through all classes. Default: false.
    DEFAULT_UNLOCKS = [ 1, 11, 21, 31]   # Classes unlocked by default.
    
    # The display between a primary class and a subclass when written in a
    # window will appear as such.
    SUBCLASS_TEXT = "%s/%s"
    
    # This adjusts the stat rate inheritance for an actor if an actor has a
    # subclass equipped. If you want to disable this, set the rate to 0.0.
    SUBCLASS_STAT_RATE = 0.20
    
    # This adds subclass skill types to the available skill types usable.
    SUBCLASS_SKILL_TYPES = true
    
    # This adds subclass weapons to equippable weapon types.
    SUBCLASS_WEAPON_TYPES = true
    
    # This adds subclass weapons to equippable armour types.
    SUBCLASS_ARMOUR_TYPES = true
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Class Scene Commands -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust how the class scene appears. Here, you can adjust
    # the command list and the order at which items appear. These are mostly
    # visual settings. Adjust them as you see fit.
    # 
    # -------------------------------------------------------------------------
    # :command         Description
    # -------------------------------------------------------------------------
    # :primary         Allows the player to change the primary class.
    # :subclass        Allows the player to change the subclass.
    # 
    # :learn_skill     Requires YEA - Learn Skill Engine
    # 
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMANDS =[ # The order at which the menu items are shown.
    # [ :command,   "Display"],
      [ :primary,   "Primary"],
      [:subclass,  "Subclass"],
      [:learn_skill, "Custom"],
    # [ :custom1,   "Custom1"],
    # [ :custom2,   "Custom2"],
    ] # Do not remove this.
    
    #--------------------------------------------------------------------------
    # - Status Class Commands -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # For those who use scripts to that may produce unique effects for the
    # class menu, use this hash to manage the custom commands for the Class
    # Command Window. You can disable certain commands or prevent them from
    # appearing by using switches. If you don't wish to bind them to a switch,
    # set the proper switch to 0 for it to have no impact.
    #--------------------------------------------------------------------------
    CUSTOM_CLASS_COMMANDS ={
    # :command => [EnableSwitch, ShowSwitch, Handler Method,
      :custom1 => [           0,          0, :command_name1],
      :custom2 => [           0,          0, :command_name2],
    } # Do not remove this.
    
    # These settings adjust the colour displays for classes.
    CURRENT_CLASS_COLOUR = 17     # "Window" colour used for current class.
    SUBCLASS_COLOUR      = 4      # "Window" colour used for subclass.
    
    # This adjusts the display for class levels if MAINTAIN_LEVELS is false.
    CLASS_LEVEL     = "LV%s"      # Text display for level.
    LEVEL_FONT_SIZE = 16          # Font size used for level.
    
    # This array sets the order of how classes are ordered in the class listing
    # window. Any class ID's unlisted will not be shown.
    CLASS_ORDER = [41..999, 1..40]
    
    # This adjusts the font size for the Parameters window.
    PARAM_FONT_SIZE = 20
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Switch Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These are the switches that govern whether or not certain menu items will
    # appear and/or will be enabled. By binding them to a Switch, you can just
    # set the Switch ON/OFF to show/hide or enable/disable a menu command. If
    # you do not wish to use this feature, set these commands to 0.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    SWITCH_SHOW_CLASS      = 0    # Switch that shows Class in Main Menu.
    SWITCH_ENABLE_CLASS    = 0    # Switch that enables Class in Main Menu.
    SWITCH_SHOW_PRIMARY    = 0    # Switch that shows Subclass in Class Menu.
    SWITCH_ENABLE_PRIMARY  = 0    # Switch that enables Subclass in Class Menu.
    SWITCH_SHOW_SUBCLASS   = 0    # Switch that shows Subclass in Class Menu.
    SWITCH_ENABLE_SUBCLASS = 0    # Switch that enables Subclass in Class Menu.
    
  end # CLASS_SYSTEM
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module CLASS_SYSTEM
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
    DEFAULT_UNLOCKS = convert_integer_array(DEFAULT_UNLOCKS)
    CLASS_ORDER = convert_integer_array(CLASS_ORDER)
  end # CLASS_SYSTEM
  module REGEXP
  module ACTOR
    
    UNLOCKED_CLASSES = 
      /<(?:UNLOCKED_CLASSES|unlocked classes):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
  end # ACTOR
  module CLASS
    
    ICON_INDEX = /<(?:ICON_INDEX|icon index|icon):[ ](\d+)>/i
    HELP_DESCRIPTION_ON  = /<(?:HELP_DESCRIPTION|help description)>/i
    HELP_DESCRIPTION_OFF = /<\/(?:HELP_DESCRIPTION|help description)>/i
    
  end # CLASS
  end # REGEXP
end # YEA

#==============================================================================
# ■ Switch
#==============================================================================

module Switch
  
  #--------------------------------------------------------------------------
  # self.class_show
  #--------------------------------------------------------------------------
  def self.class_show
    return true if YEA::CLASS_SYSTEM::SWITCH_SHOW_CLASS <= 0
    return $game_switches[YEA::CLASS_SYSTEM::SWITCH_SHOW_CLASS]
  end
  
  #--------------------------------------------------------------------------
  # self.class_enable
  #--------------------------------------------------------------------------
  def self.class_enable
    return true if YEA::CLASS_SYSTEM::SWITCH_ENABLE_CLASS <= 0
    return $game_switches[YEA::CLASS_SYSTEM::SWITCH_ENABLE_CLASS]
  end
  
  #--------------------------------------------------------------------------
  # self.primary_show
  #--------------------------------------------------------------------------
  def self.primary_show
    return true if YEA::CLASS_SYSTEM::SWITCH_SHOW_PRIMARY <= 0
    return $game_switches[YEA::CLASS_SYSTEM::SWITCH_SHOW_PRIMARY]
  end
  
  #--------------------------------------------------------------------------
  # self.primary_enable
  #--------------------------------------------------------------------------
  def self.primary_enable
    return true if YEA::CLASS_SYSTEM::SWITCH_ENABLE_PRIMARY <= 0
    return $game_switches[YEA::CLASS_SYSTEM::SWITCH_ENABLE_PRIMARY]
  end
  
  #--------------------------------------------------------------------------
  # self.subclass_show
  #--------------------------------------------------------------------------
  def self.subclass_show
    return true if YEA::CLASS_SYSTEM::SWITCH_SHOW_SUBCLASS <= 0
    return $game_switches[YEA::CLASS_SYSTEM::SWITCH_SHOW_SUBCLASS]
  end
  
  #--------------------------------------------------------------------------
  # self.subclass_enable
  #--------------------------------------------------------------------------
  def self.subclass_enable
    return true if YEA::CLASS_SYSTEM::SWITCH_ENABLE_SUBCLASS <= 0
    return $game_switches[YEA::CLASS_SYSTEM::SWITCH_ENABLE_SUBCLASS]
  end
    
end # Switch

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
  class <<self; alias load_database_cs load_database; end
  def self.load_database
    load_database_cs
    load_notetags_cs
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_cs
  #--------------------------------------------------------------------------
  def self.load_notetags_cs
    groups = [$data_actors, $data_classes]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_cs
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Actor
#==============================================================================

class RPG::Actor < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :unlocked_classes
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_cs
  #--------------------------------------------------------------------------
  def load_notetags_cs
    @unlocked_classes = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ACTOR::UNLOCKED_CLASSES
        $1.scan(/\d+/).each { |num| 
        @unlocked_classes.push(num.to_i) if num.to_i > 0 }
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Actor

#==============================================================================
# ■ RPG::Class
#==============================================================================

class RPG::Class < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :icon_index
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_cs
  #--------------------------------------------------------------------------
  def load_notetags_cs
    @icon_index = 0
    @help_description_on = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::CLASS::ICON_INDEX
        @icon_index = $1.to_i
      #---
      when YEA::REGEXP::CLASS::HELP_DESCRIPTION_ON
        @help_description_on = true
      when YEA::REGEXP::CLASS::HELP_DESCRIPTION_OFF
        @help_description_on = false
      #---
      else
        @description += line.to_s if @help_description_on
      end
    } # self.note.split
    #---
    @description.gsub!(/[|]/i) { "\n" }
  end
  
end # RPG::Class

#==============================================================================
# ■ Game_Temp
#==============================================================================

class Game_Temp
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :scene_class_index
  attr_accessor :scene_class_oy
  
end # Game_Temp

#==============================================================================
# ■ Game_Action
#==============================================================================

class Game_Action
  
  #--------------------------------------------------------------------------
  # alias method: valid?
  #--------------------------------------------------------------------------
  alias game_action_valid_cs valid?
  def valid?
    return false if check_auto_battle_class
    return game_action_valid_cs
  end
  
  #--------------------------------------------------------------------------
  # new method: check_auto_battle_class
  #--------------------------------------------------------------------------
  def check_auto_battle_class
    return false unless subject.actor?
    return false unless subject.auto_battle?
    return false if item.nil?
    return false if subject.added_skill_types.include?(item.stype_id)
    return false if item.id == subject.attack_skill_id
    return true
  end
  
end # Game_Action

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :temp_flag
  
  #--------------------------------------------------------------------------
  # alias method: added_skill_types
  #--------------------------------------------------------------------------
  alias game_battlerbase_added_skill_types_cs added_skill_types
  def added_skill_types
    result = game_battlerbase_added_skill_types_cs
    result |= subclass_skill_types
    return result
  end
  
  #--------------------------------------------------------------------------
  # new method: subclass_skill_types
  #--------------------------------------------------------------------------
  def subclass_skill_types; return []; end
  
  #--------------------------------------------------------------------------
  # alias method: equip_wtype_ok?
  #--------------------------------------------------------------------------
  alias game_battlerbase_equip_wtype_ok_cs equip_wtype_ok?
  def equip_wtype_ok?(wtype_id)
    return true if subclass_equip_wtype?(wtype_id)
    return game_battlerbase_equip_wtype_ok_cs(wtype_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: subclass_equip_wtype?
  #--------------------------------------------------------------------------
  def subclass_equip_wtype?(wtype_id); return false; end
  
  #--------------------------------------------------------------------------
  # alias method: equip_atype_ok?
  #--------------------------------------------------------------------------
  alias game_battlerbase_equip_atype_ok_cs equip_atype_ok?
  def equip_atype_ok?(atype_id)
    return true if subclass_equip_atype?(atype_id)
    return game_battlerbase_equip_atype_ok_cs(atype_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: subclass_equip_atype?
  #--------------------------------------------------------------------------
  def subclass_equip_atype?(atype_id); return false; end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: setup
  #--------------------------------------------------------------------------
  alias game_actor_setup_cs setup
  def setup(actor_id)
    game_actor_setup_cs(actor_id)
    init_unlocked_classes
    init_subclass
  end
  
  #--------------------------------------------------------------------------
  # new method: init_unlocked_classes
  #--------------------------------------------------------------------------
  def init_unlocked_classes
    @unlocked_classes = actor.unlocked_classes.clone
    @unlocked_classes.push(@class_id) if !@unlocked_classes.include?(@class_id)
    @unlocked_classes.sort!
  end
  
  #--------------------------------------------------------------------------
  # new method: init_subclass
  #--------------------------------------------------------------------------
  def init_subclass
    @subclass_id = 0
  end
  
  #--------------------------------------------------------------------------
  # new method: unlocked_classes
  #--------------------------------------------------------------------------
  def unlocked_classes
    init_unlocked_classes if @unlocked_classes.nil?
    return @unlocked_classes
  end
  
  #--------------------------------------------------------------------------
  # new method: unlock_class
  #--------------------------------------------------------------------------
  def unlock_class(class_id)
    init_unlocked_classes if @unlocked_classes.nil?
    return if @unlocked_classes.include?(class_id)
    @unlocked_classes.push(class_id)
    learn_class_skills(class_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: remove_class
  #--------------------------------------------------------------------------
  def remove_class(class_id)
    init_unlocked_classes if @unlocked_classes.nil?
    return if class_id == @class_id
    @unlocked_classes.delete(class_id)
    @subclass_id = 0 if class_id == @subclass_id
    refresh
  end
  
  #--------------------------------------------------------------------------
  # new method: subclass
  #--------------------------------------------------------------------------
  def subclass
    init_subclass if @subclass_id.nil?
    return $data_classes[@subclass_id]
  end
  
  #--------------------------------------------------------------------------
  # alias method: change_class
  #--------------------------------------------------------------------------
  alias game_actor_change_class_cs change_class
  def change_class(class_id, keep_exp = false)
    @subclass_id = 0 if @subclass_id == class_id
    game_actor_change_class_cs(class_id, keep_exp)
    learn_class_skills(class_id)
    unlock_class(class_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: learn_class_skills
  #--------------------------------------------------------------------------
  def learn_class_skills(class_id)
    return if class_id <= 0
    return if $data_classes[class_id].nil?
    $data_classes[class_id].learnings.each do |learning|
      learn_skill(learning.skill_id) if learning.level == class_level(class_id)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: change_subclass
  #--------------------------------------------------------------------------
  def change_subclass(class_id)
    return if class_id == @class_id
    unlock_class(class_id)
    @subclass_id = @subclass_id == class_id ? 0 : class_id
    learn_class_skills(@subclass_id)
    refresh
  end
	#————————————————————————–
	# new method: class_level Edited by DisturbedInside
	#————————————————————————–
	def class_level(class_id)
		return @level if YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
			temp_class = $data_classes[class_id]
			@exp[class_id] = 0 if @exp[class_id].nil?
			#declare a max level (using EXP)
			#If you can’t find it, go to the class database and select exp curve
			#then switch view to total at the top
			@exp[max_level] = 2547133 #This is the value to change. It declares a max level
			#You need to calculate how much exp for max level
			#Do it manually if using Yanfly-Adjusting Limits
			#To calculate max level exp if using Yanfly-adjusting limits is all math!!

			# Level 99 = 2547133
			# to calculate past there…. have to add on multiples of 50744
			# Level 110 = 3156061
			# To go from 99 -> 110 have to add on 12 multiples of 50744.
			n = 1			
			loop do
				break if temp_class.exp_for_level(n+1) > @exp[class_id]
				n += 1
				#add a restriction to “kick out” of loop if exp exceeds max level exp
				break if temp_class.exp_for_level(n+1) > @exp[max_level]
			end
		return n
	end
  
  #--------------------------------------------------------------------------
  # new method: subclass_level
  #--------------------------------------------------------------------------
  def subclass_level
    return 0 if @subclass_id == 0
    return @level if YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
    return class_level(@subclass_id)
  end
  
  #--------------------------------------------------------------------------
  # alias method: param_base
  #--------------------------------------------------------------------------
  alias game_actor_param_base_cs param_base
  def param_base(param_id)
    result = game_actor_param_base_cs(param_id)
    unless subclass.nil?
      subclass_rate = YEA::CLASS_SYSTEM::SUBCLASS_STAT_RATE
      slevel = subclass_level
      result += subclass.params[param_id, slevel] * subclass_rate
    end
    return result.to_i
  end
  
  #--------------------------------------------------------------------------
  # new method: subclass_skill_types
  #--------------------------------------------------------------------------
  def subclass_skill_types
    return [] unless YEA::CLASS_SYSTEM::SUBCLASS_SKILL_TYPES
    return [] if subclass.nil?
    array = []
    for feature in subclass.features
      next unless feature.code == FEATURE_STYPE_ADD
      next if features_set(FEATURE_STYPE_ADD).include?(feature.data_id)
      array.push(feature.data_id)
    end
    return array
  end
  
  #--------------------------------------------------------------------------
  # new method: subclass_equip_wtype?
  #--------------------------------------------------------------------------
  def subclass_equip_wtype?(wtype_id)
    return false unless YEA::CLASS_SYSTEM::SUBCLASS_WEAPON_TYPES
    return false if subclass.nil?
    for feature in subclass.features
      next unless feature.code == FEATURE_EQUIP_WTYPE
      return true if wtype_id == feature.data_id
    end
    return super
  end
  
  #--------------------------------------------------------------------------
  # new method: subclass_equip_atype?
  #--------------------------------------------------------------------------
  def subclass_equip_atype?(atype_id)
    return false unless YEA::CLASS_SYSTEM::SUBCLASS_ARMOUR_TYPES
    return false if subclass.nil?
    for feature in subclass.features
      next unless feature.code == FEATURE_EQUIP_ATYPE
      return true if atype_id == feature.data_id
    end
    return super
  end
  
  #--------------------------------------------------------------------------
  # alias method: release_unequippable_items
  #--------------------------------------------------------------------------
  alias game_actor_release_unequippable_items_cs release_unequippable_items
  def release_unequippable_items(item_gain = true)
    item_gain = false if @temp_flag
    game_actor_release_unequippable_items_cs(item_gain)
  end
  
end # Game_Actor

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # overwrite method: command_321
  #--------------------------------------------------------------------------
  def command_321
    actor = $game_actors[@params[0]]
    if actor && $data_classes[@params[1]]
      maintain = YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
      actor.change_class(@params[1], maintain)
    end
  end
  
end # Game_Interpreter

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_class
  #--------------------------------------------------------------------------
  def draw_actor_class(actor, x, y, width = 112)
    change_color(normal_color)
    if actor.subclass.nil?
      text = actor.class.name
    else
      fmt = YEA::CLASS_SYSTEM::SUBCLASS_TEXT
      text = sprintf(fmt, actor.class.name, actor.subclass.name)
    end
    draw_text(x, y, width, line_height, text)
  end
  
end # Window_Base

#==============================================================================
# ■ Window_MenuCommand
#==============================================================================

class Window_MenuCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # alias method: add_formation_command
  #--------------------------------------------------------------------------
  alias window_menucommand_add_formation_command_cs add_formation_command
  def add_formation_command
    add_class_command unless $imported["YEA-AceMenuEngine"]
    window_menucommand_add_formation_command_cs
  end
  
  #--------------------------------------------------------------------------
  # new method: add_class_command
  #--------------------------------------------------------------------------
  def add_class_command
    return unless Switch.class_show
    text = YEA::CLASS_SYSTEM::CLASS_MENU_TEXT
    add_command(text, :class, Switch.class_enable)
  end
  
end # Window_MenuCommand

#==============================================================================
# ■ Window_ClassCommand
#==============================================================================

class Window_ClassCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    @actor = nil
  end
  
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width; return 160; end
  
  #--------------------------------------------------------------------------
  # actor=
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  
  #--------------------------------------------------------------------------
  # item_window=
  #--------------------------------------------------------------------------
  def item_window=(window)
    @item_window = window
  end
  
  #--------------------------------------------------------------------------
  # visible_line_number
  #--------------------------------------------------------------------------
  def visible_line_number; return 4; end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    return if @actor.nil?
    for command in YEA::CLASS_SYSTEM::COMMANDS
      case command[0]
      when :primary
        next unless Switch.primary_show
        add_command(command[1], command[0], Switch.primary_enable)
      when :subclass
        next unless Switch.subclass_show
        add_command(command[1], command[0], Switch.subclass_enable)
      when :learn_skill
        next unless $imported["YEA-LearnSkillEngine"]
        add_learn_skill_command
      else
        process_custom_command(command)
      end
    end
    if !$game_temp.scene_class_index.nil?
      select($game_temp.scene_class_index)
      self.oy = $game_temp.scene_class_oy
    end
    $game_temp.scene_class_index = nil
    $game_temp.scene_class_oy = nil
  end
  
  #--------------------------------------------------------------------------
  # process_ok
  #--------------------------------------------------------------------------
  def process_ok
    $game_temp.scene_class_index = index
    $game_temp.scene_class_oy = self.oy
    super
  end
  
  #--------------------------------------------------------------------------
  # process_custom_command
  #--------------------------------------------------------------------------
  def process_custom_command(command)
    return unless YEA::CLASS_SYSTEM::CUSTOM_CLASS_COMMANDS.include?(command[0])
    show = YEA::CLASS_SYSTEM::CUSTOM_CLASS_COMMANDS[command[0]][1]
    continue = show <= 0 ? true : $game_switches[show]
    return unless continue
    text = command[1]
    switch = YEA::CLASS_SYSTEM::CUSTOM_CLASS_COMMANDS[command[0]][0]
    enabled = switch <= 0 ? true : $game_switches[switch]
    add_command(text, command[0], enabled)
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    update_visible_windows
  end
  
  #--------------------------------------------------------------------------
  # update_visible_windows
  #--------------------------------------------------------------------------
  def update_visible_windows
    return if @current_index == current_symbol
    @current_index = current_symbol
    @item_window.refresh unless @item_window.nil?
  end
  
  #--------------------------------------------------------------------------
  # add_learn_skill_command
  #--------------------------------------------------------------------------
  def add_learn_skill_command
    return unless Switch.show_learn_skill
    name = YEA::LEARN_SKILL::COMMAND_NAME
    add_command(name, :learn_skill, true)
  end
  
end # Window_ClassCommand

#==============================================================================
# ■ Window_ClassStatus
#==============================================================================

class Window_ClassStatus < Window_Base
  
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
  def window_width; Graphics.width - 160; end
  
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
    return if @actor.nil?
    draw_actor_face(@actor, 0, 0)
    draw_actor_simple_status(@actor, 108, line_height / 2)
  end
  
end # Window_ClassStatus

#==============================================================================
# ■ Window_ClassParam
#==============================================================================

class Window_ClassParam < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(dx, dy)
    super(dx, dy, window_width, Graphics.height - dy)
    @actor = nil
    @temp_actor = nil
    refresh
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width * 2 / 5; end
  
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
    8.times {|i| draw_item(0, line_height * i, i) }
  end
  
  #--------------------------------------------------------------------------
  # set_temp_actor
  #--------------------------------------------------------------------------
  def set_temp_actor(temp_actor)
    return if @temp_actor == temp_actor
    @temp_actor = temp_actor
    refresh
  end
  
  #--------------------------------------------------------------------------
  # draw_item
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
  # draw_background_colour
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
    contents.font.size = YEA::CLASS_SYSTEM::PARAM_FONT_SIZE
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
  # draw_right_arrow
  #--------------------------------------------------------------------------
  def draw_right_arrow(x, y)
    change_color(system_color)
    draw_text(x, y, 22, line_height, "→", 1)
  end
  
  #--------------------------------------------------------------------------
  # draw_new_param
  #--------------------------------------------------------------------------
  def draw_new_param(dx, dy, param_id)
    contents.font.size = YEA::CLASS_SYSTEM::PARAM_FONT_SIZE
    new_value = @temp_actor.param(param_id)
    change_color(param_change_color(new_value - @actor.param(param_id)))
    draw_text(0, dy, contents.width-4, line_height, new_value.group, 2)
    reset_font_settings
  end
  
end # Window_ClassParam

#==============================================================================
# ■ Window_ClassList
#==============================================================================

class Window_ClassList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(dx, dy)
    dw = Graphics.width - (Graphics.width * 2 / 5)
    dh = Graphics.height - dy
    super(dx, dy, dw, dh)
    @actor = nil
    @command_window = nil
    @status_window
    @data = []
  end
  
  #--------------------------------------------------------------------------
  # actor=
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    @last_item = nil
    refresh
    self.oy = 0
  end
  
  #--------------------------------------------------------------------------
  # command_window=
  #--------------------------------------------------------------------------
  def command_window=(command_window)
    @command_window = command_window
  end
  
  #--------------------------------------------------------------------------
  # status_window=
  #--------------------------------------------------------------------------
  def status_window=(status_window)
    @status_window = status_window
  end
  
  #--------------------------------------------------------------------------
  # item_max
  #--------------------------------------------------------------------------
  def item_max; return @data ? @data.size : 1; end
  
  #--------------------------------------------------------------------------
  # item
  #--------------------------------------------------------------------------
  def item; return @data && index >= 0 ? @data[index] : nil; end
  
  #--------------------------------------------------------------------------
  # current_item_enabled?
  #--------------------------------------------------------------------------
  def current_item_enabled?; return enable?(@data[index]); end
  
  #--------------------------------------------------------------------------
  # include?
  #--------------------------------------------------------------------------
  def include?(item)
    return true if YEA::CLASS_SYSTEM::DEFAULT_UNLOCKS.include?(item.id)
    return @actor.unlocked_classes.include?(item.id)
  end
  
  #--------------------------------------------------------------------------
  # enable?
  #--------------------------------------------------------------------------
  def enable?(item)
    return false if item == @actor.class
    return true
  end
  
  #--------------------------------------------------------------------------
  # make_item_list
  #--------------------------------------------------------------------------
  def make_item_list
    @data = []
    for class_id in YEA::CLASS_SYSTEM::CLASS_ORDER
      next if $data_classes[class_id].nil?
      item = $data_classes[class_id]
      @data.push(item) if include?(item)
    end
  end
  
  #--------------------------------------------------------------------------
  # select_last
  #--------------------------------------------------------------------------
  def select_last
    case @command_window.current_symbol
    when :primary
      select(@data.index(@actor.class))
    when :subclass
      select(0) if @actor.subclass.nil?
      select(@data.index(@actor.subclass)) unless @actor.subclass.nil?
    else
      select(0)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    return if item.nil?
    rect = item_rect(index)
    rect.width -= 4
    reset_font_settings
    set_item_colour(item)
    draw_class_icon(item, rect)
    draw_class_name(item, rect)
    draw_class_level(item, rect)
  end
  
  #--------------------------------------------------------------------------
  # set_item_colour
  #--------------------------------------------------------------------------
  def set_item_colour(item)
    if item == @actor.class
      change_color(text_color(YEA::CLASS_SYSTEM::CURRENT_CLASS_COLOUR))
    elsif item == @actor.subclass
      change_color(text_color(YEA::CLASS_SYSTEM::SUBCLASS_COLOUR))
    else
      change_color(normal_color, enable?(item))
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_class_icon
  #--------------------------------------------------------------------------
  def draw_class_icon(item, rect)
    icon = item.icon_index
    draw_icon(icon, rect.x, rect.y, enable?(item))
  end
  
  #--------------------------------------------------------------------------
  # draw_class_name
  #--------------------------------------------------------------------------
  def draw_class_name(item, rect)
    text = item.name
    draw_text(24, rect.y, rect.width-24, line_height, text)
  end
  
  #--------------------------------------------------------------------------
  # draw_class_level
  #--------------------------------------------------------------------------
  def draw_class_level(item, rect)
    return if YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
    return if @actor.nil?
    level = @actor.class_level(item.id)
    contents.font.size = YEA::CLASS_SYSTEM::LEVEL_FONT_SIZE
    text = sprintf(YEA::CLASS_SYSTEM::CLASS_LEVEL, level.group)
    draw_text(rect, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # update_help
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
    return if @actor.nil?
    return if @status_window.nil?
    update_param_window
  end
  
  #--------------------------------------------------------------------------
  # update_param_window
  #--------------------------------------------------------------------------
  def update_param_window
    return if @last_item == item
    @last_item = item
    class_id = item.nil? ? @actor.class_id : item.id
    temp_actor = Marshal.load(Marshal.dump(@actor))
    temp_actor.temp_flag = true
    case @command_window.current_symbol
    when :primary
      temp_actor.change_class(class_id, YEA::CLASS_SYSTEM::MAINTAIN_LEVELS)
    when :subclass
      temp_actor.change_subclass(class_id)
    end
    @status_window.set_temp_actor(temp_actor)
  end
  
  #--------------------------------------------------------------------------
  # update_class
  #--------------------------------------------------------------------------
  def update_class
    @last_item = nil
    update_help
    refresh
    activate
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  
end # Window_ClassList

#==============================================================================
# ■ Scene_Menu
#==============================================================================

class Scene_Menu < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # alias method: create_command_window
  #--------------------------------------------------------------------------
  alias scene_menu_create_command_window_cs create_command_window
  def create_command_window
    scene_menu_create_command_window_cs
    @command_window.set_handler(:class, method(:command_personal))
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_personal_ok
  #--------------------------------------------------------------------------
  alias scene_menu_on_personal_ok_cs on_personal_ok
  def on_personal_ok
    case @command_window.current_symbol
    when :class
      SceneManager.call(Scene_Class)
    else
      scene_menu_on_personal_ok_cs
    end
  end
  
end # Scene_Menu

#==============================================================================
# ■ Scene_Class
#==============================================================================

class Scene_Class < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # start
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_command_window
    create_status_window
    create_param_window
    create_item_window
    relocate_windows
  end
  
  #--------------------------------------------------------------------------
  # create_command_window
  #--------------------------------------------------------------------------
  def create_command_window
    wy = @help_window.height
    @command_window = Window_ClassCommand.new(0, wy)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.actor = @actor
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:primary,  method(:command_class_change))
    @command_window.set_handler(:subclass, method(:command_class_change))
    process_custom_class_commands
    return if $game_party.in_battle
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
    @command_window.set_handler(:learn_skill, method(:command_learn_skill))
  end
  
  #--------------------------------------------------------------------------
  # process_custom_class_commands
  #--------------------------------------------------------------------------
  def process_custom_class_commands
    for command in YEA::CLASS_SYSTEM::COMMANDS
      next unless YEA::CLASS_SYSTEM::CUSTOM_CLASS_COMMANDS.include?(command[0])
      called_method = YEA::CLASS_SYSTEM::CUSTOM_CLASS_COMMANDS[command[0]][2]
      @command_window.set_handler(command[0], method(called_method))
    end
  end
  
  #--------------------------------------------------------------------------
  # create_status_window
  #--------------------------------------------------------------------------
  def create_status_window
    wy = @help_window.height
    @status_window = Window_ClassStatus.new(@command_window.width, wy)
    @status_window.viewport = @viewport
    @status_window.actor = @actor
  end
  
  #--------------------------------------------------------------------------
  # create_param_window
  #--------------------------------------------------------------------------
  def create_param_window
    dx = Graphics.width - (Graphics.width * 2 / 5)
    dy = @status_window.y + @status_window.height
    @param_window = Window_ClassParam.new(dx, dy)
    @param_window.viewport = @viewport
    @param_window.actor = @actor
  end
  
  #--------------------------------------------------------------------------
  # create_item_window
  #--------------------------------------------------------------------------
  def create_item_window
    dy = @status_window.y + @status_window.height
    @item_window = Window_ClassList.new(0, dy)
    @item_window.help_window = @help_window
    @item_window.command_window = @command_window
    @item_window.status_window = @param_window
    @item_window.viewport = @viewport
    @item_window.actor = @actor
    @command_window.item_window = @item_window
    @item_window.set_handler(:ok,     method(:on_class_ok))
    @item_window.set_handler(:cancel, method(:on_class_cancel))
  end
  
  #--------------------------------------------------------------------------
  # relocate_windows
  #--------------------------------------------------------------------------
  def relocate_windows
    return unless $imported["YEA-AceMenuEngine"]
    case Menu.help_window_location
    when 0 # Top
      @help_window.y = 0
      @command_window.y = @help_window.height
      @param_window.y = @command_window.y + @command_window.height
    when 1 # Middle
      @command_window.y = 0
      @help_window.y = @command_window.height
      @param_window.y = @help_window.y + @help_window.height
    else # Bottom
      @command_window.y = 0
      @param_window.y = @command_window.height
      @help_window.y = @param_window.y + @param_window.height
    end
    @status_window.y = @command_window.y
    @item_window.y = @param_window.y
  end
  
  #--------------------------------------------------------------------------
  # on_actor_change
  #--------------------------------------------------------------------------
  def on_actor_change
    @command_window.actor = @actor
    @status_window.actor = @actor
    @param_window.actor = @actor
    @item_window.actor = @actor
    @command_window.activate
  end
  
  #--------------------------------------------------------------------------
  # command_class_change
  #--------------------------------------------------------------------------
  def command_class_change
    @item_window.activate
    @item_window.select_last
  end
  
  #--------------------------------------------------------------------------
  # on_class_cancel
  #--------------------------------------------------------------------------
  def on_class_cancel
    @item_window.unselect
    @command_window.activate
    @param_window.set_temp_actor(nil)
  end
  
  #--------------------------------------------------------------------------
  # on_class_ok
  #--------------------------------------------------------------------------
  def on_class_ok
    Sound.play_equip
    class_id = @item_window.item.id
    maintain = YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
    hp = @actor.hp * 1.0 / @actor.mhp
    mp = @actor.mp * 1.0 / [@actor.mmp, 1].max
    case @command_window.current_symbol
    when :primary
      @actor.change_class(class_id, maintain)
    when :subclass
      @actor.change_subclass(class_id)
    else
      @item_window.activate
      return
    end
    @actor.hp = (@actor.mhp * hp).to_i
    @actor.mp = (@actor.mmp * mp).to_i
    @status_window.refresh
    @item_window.update_class
  end
  
  #--------------------------------------------------------------------------
  # new method: command_learn_skill
  #--------------------------------------------------------------------------
  def command_learn_skill
    return unless $imported["YEA-LearnSkillEngine"]
    SceneManager.call(Scene_LearnSkill)
  end
  
  #--------------------------------------------------------------------------
  # command_name1
  #--------------------------------------------------------------------------
  def command_name1
    # Do nothing.
  end
  
  #--------------------------------------------------------------------------
  # command_name2
  #--------------------------------------------------------------------------
  def command_name2
    # Do nothing.
  end
  
end # Scene_Class

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================