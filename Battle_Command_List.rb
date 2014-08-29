#==============================================================================
# 
# Å• Yanfly Engine Ace - Battle Command List v1.09b
# -- Last Updated: 2012.12.18
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-BattleCommandList"] = true

#==============================================================================
# Å• Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.12.18 - Completely fixed the command hide switch bug.
# 2012.12.17 - Fixed Bug with command hide until switch.
# 2012.01.10 - Compatibility Update: Battle System FTB
# 2011.12.30 - Bug Fixed: Disappearing windows when no confirm window is used.
# 2011.12.26 - Bug Fixed: Actor Command Window disappears without Battle Engine
#              Ace installed.
# 2011.12.19 - Compatibility Update: Class System
#            - New Actor Command: Subclass List
# 2011.12.17 - Bug Fixed: Item command from Actor Command Window fixed.
# 2011.12.15 - Bug Fixed: Prevented multiple actions per battler.
# 2011.12.13 - Compatibility Update: Command Equip
#              Compatibility Update: Add-On: Command Party
# 2011.12.12 - Compatibility Update: Command Autobattle
# 2011.12.10 - Started Script and Finished.
#            - Compatibility Update: Combat Log Display
# 
#==============================================================================
# Å• Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script allows you to change the order to commands that appear in battle
# for the Party Command Window and Actor Command Window. In addition to the
# ability to change the order commands appear, you may also add commands to the
# Actor Command Window that can trigger the usage of skills and/or items. The
# Confirm Command Window is also a new addition that appears at the end of the
# action select phase (after the last actor has made a choice) before entering
# the battle phase.
# 
#==============================================================================
# Å• Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below Å• Materials/ëfçﬁ but above Å• Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Actor Notetags - These notetags go in the actors notebox in the database.
# -----------------------------------------------------------------------------
# <command list>
#  string
#  string
# </command list>
# These lines go inside of an actor's notebox to adjust the battle commands
# that appear in the actor's Actor Command Window. Refer to the module as to
# what to use for the strings. If a custom command list is used for an actor,
# it will take priority over its class's custom command list, which takes place
# over the default command list.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <command list>
#  string
#  string
# </command list>
# These lines go inside of a class's notebox to adjust the battle commands
# that appear in the actor's Actor Command Window. Refer to the module as to
# what to use for the strings. A custom command list for a class does not take
# priority over an actor's custom command list, but it does take priority over
# the default command list.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skill notebox in the database.
# -----------------------------------------------------------------------------
# <command name: string>
# If this skill is being used as a command, it will use "string" to replace the
# skill's name in the command list window.
# 
# <command hide until learn>
# This hides the command until the actor has learned the respective skill for
# the command to appear in the actor's command list.
# 
# <command hide until usable>
# This hides the command until the actor is capable of using the command by
# meeting TP costs or MP costs.
# 
# <command hide until switch: x>
# This switch x is OFF, then the command remains hidden. If the switch is ON,
# then the command becomes enabled and appears in the command list.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the item notebox in the database.
# -----------------------------------------------------------------------------
# <command name: string>
# If this item is being used as a command, it will use "string" to replace the
# item's name in the command list window.
# 
# <command hide until usable>
# This hides the command until the actor is capable of using the command as
# long as that item is usable normally.
# 
# <command hide until switch: x>
# This switch x is OFF, then the command remains hidden. If the switch is ON,
# then the command becomes enabled and appears in the command list.
# 
#==============================================================================
# Å• Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# For maximum compatibility with Yanfly Engine Ace - Ace Battle Engine, place
# this script under Ace Battle Engine.
# 
#==============================================================================

module YEA
  module BATTLE_COMMANDS
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Party Command Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This section adjusts the commands for the Party Command Window. Rearrange
    # commands as you see fit or add in new ones. Here's a list of which
    # command does what:
    # 
    # -------------------------------------------------------------------------
    # :command         Description
    # -------------------------------------------------------------------------
    # :fight           Enters the command selection phase for actors. Default.
    # :escape          Party attempts to escape from battle. Default.
    # 
    # :combatlog       Requires YEA - Combat Log Display.
    # :autobattle      Requires YEA - Command Autobattle.
    # :party           Requires YEA - Party System Add-On: Command Party.
    # 
    # And that's all of the currently available commands. This list will be
    # updated as more scripts become available.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This array arranges the order of which the commands appear in the Party
    # Command window.
    PARTY_COMMANDS =[
      :fight,
      :autobattle,
      :party,
    # :custom1,
    # :custom2,
      :escape,
    ] # Do not remove this.
    
    #--------------------------------------------------------------------------
    # - Party Command Custom Commands -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # For those who use scripts to that may produce unique effects in battle,
    # use this hash to manage the custom commands for the Party Command Window.
    # You can disable certain commands or prevent them from appearing by using
    # switches. If you don't wish to bind them to a switch, set the proper
    # switch to 0 for it to have no impact.
    #--------------------------------------------------------------------------
    CUSTOM_PARTY_COMMANDS ={
    # :command => ["Display Name", EnableSwitch, ShowSwitch, Handler Method],
      :custom1 => [ "Custom Name",            0,         0, :command_name1],
      :custom2 => [ "Custom Name",           13,         0, :command_name2],
    } # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Actor Command Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This section only adjusts the default commands for actors. If you wish
    # for an actor to have a unique command list, use the notetags listed in
    # the instructions to apply them. The custom command lists for actors will
    # override this command list.
    # 
    # Here's a list of which command does what:
    # 
    # -------------------------------------------------------------------------
    # :command         Description
    # -------------------------------------------------------------------------
    # "ATTACK"         Normal attack for actor. Default.
    # "SKILL LIST"     All of the skill types the actor can use. Default.
    # "DEFEND"         Set defend action for actor. Default.
    # "ITEMS"          Opens up the item menu for the actor. Default.
    # 
    # "SKILL TYPE X"   Specifically puts in skill type X if actor has it.
    # "SKILL X"        Uses Skill X in that slot.
    # "ITEM X"         Uses Item X in that slot.
    # 
    # "AUTOBATTLE"     Requires YEA - Command Autobattle.
    # "EQUIP"          Requires YEA - Command Equip
    # "SUBCLASS LIST"  Requires YEA - Class System. Adds subclass skill types.
    # 
    # And that's all of the currently available commands. This list will be
    # updated as more scripts become available.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This array arranges the order of which the commands appear in the Actor
    # Command window if the actor does not have a custom command list.
    DEFAULT_ACTOR_COMMANDS =[
    # "AUTOBATTLE",
      "ATTACK",
      "SKILL LIST",
      "SUBCLASS LIST",
      "DEFEND",
      "ITEMS",
      "EQUIP",
    ] # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Confirm Command Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # The confirm window is something new that's been added. It shows after the
    # last actor has made a decision as to what actions the player wishes to
    # take for the turn Here's a list of which command does what:
    # 
    # -------------------------------------------------------------------------
    # :command         Description
    # -------------------------------------------------------------------------
    # :execute         Start the battle turn. Comes with this script.
    # 
    # :combatlog       Requires YEA - Combat Log Display.
    # 
    # And that's all of the currently available commands. This list will be
    # updated as more scripts become available.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    USE_CONFIRM_WINDOW = true    # Set to false if you don't wish to use it.
    
    # This array arranges the order of which the commands appear in the Party
    # Command window.
    CONFIRM_COMMANDS =[
      :execute,
      :combatlog,
    # :custom1,
    # :custom2,
    ] # Do not remove this.
    
    # This sets what text appears for the execute command.
    EXECUTE_VOCAB = "Execute"
    
    #--------------------------------------------------------------------------
    # - Confirm Command Custom Commands -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # For those who use scripts to that may produce unique effects in battle,
    # use this hash to manage the custom commands for the Confirm Command
    # Window. You can disable certain commands or prevent them from appearing
    # by using switches. If you don't wish to bind them to a switch, set the
    # proper switch to 0 for it to have no impact.
    #--------------------------------------------------------------------------
    CUSTOM_CONFIRM_COMMANDS ={
    # :command => ["Display Name", EnableSwitch, ShowSwitch, Handler Method],
      :custom1 => [ "Custom Name",            0,          0, :command_name1],
      :custom2 => [ "Custom Text",           13,          0, :command_name2],
    } # Do not remove this.
    
  end # BATTLE_COMMANDS
end # YEA

#==============================================================================
# Å• Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    COMMAND_LIST_ON  = /<(?:COMMAND_LIST|command list)>/i
    COMMAND_LIST_OFF = /<\/(?:COMMAND_LIST|command list)>/i
    
  end # BASEITEM
  module USABLEITEM
    
    COMMAND_NAME = /<(?:COMMAND NAME|command name):[ ](.*)>/i
    COMMAND_HIDE_LEARN = 
      /<(?:COMMAND_HIDE_UNTIL_LEARN|command hide until learn)>/i
    COMMAND_HIDE_USABLE = 
      /<(?:COMMAND_HIDE_UNTIL_USABLE|command hide until usable)>/i
    COMMAND_HIDE_SWITCH = 
      /<(?:COMMAND_HIDE_UNTIL_SWITCH|command hide until switch):[ ](\d+)>/i
    
  end # USABLEITEM
  end # REGEXP
end # YEA

#==============================================================================
# Å° DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_bcl load_database; end
  def self.load_database
    load_database_bcl
    load_notetags_bcl
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_bcl
  #--------------------------------------------------------------------------
  def self.load_notetags_bcl
    groups = [$data_actors, $data_classes, $data_skills, $data_items]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_bcl
      end
    end
  end
  
end # DataManager

#==============================================================================
# Å° RPG::BaseItem
#==============================================================================

class RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :battle_commands
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_bcl
  #--------------------------------------------------------------------------
  def load_notetags_bcl
    @battle_commands = []
    @command_list = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::COMMAND_LIST_ON
        @command_list = true
      when YEA::REGEXP::BASEITEM::COMMAND_LIST_OFF
        @command_list = false
      else
        next unless @command_list
        @battle_commands.push(line.to_s.upcase)
      #---
      end
    } # self.note.split
    #---
    if @battle_commands == [] and self.is_a?(RPG::Class)
      @battle_commands = YEA::BATTLE_COMMANDS::DEFAULT_ACTOR_COMMANDS
    end
  end
  
end # RPG::BaseItem

#==============================================================================
# Å° RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :command_name
  attr_accessor :command_hide_until_learn
  attr_accessor :command_hide_until_usable
  attr_accessor :command_hide_until_switch
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_bcl
  #--------------------------------------------------------------------------
  def load_notetags_bcl
    @command_name = @name.clone
    @command_hide_until_switch = 0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::COMMAND_NAME
        @command_name = $1.to_s
      when YEA::REGEXP::USABLEITEM::COMMAND_HIDE_LEARN
        @command_hide_until_learn = true
      when YEA::REGEXP::USABLEITEM::COMMAND_HIDE_USABLE
        @command_hide_until_usable = true
      when YEA::REGEXP::USABLEITEM::COMMAND_HIDE_SWITCH
        @command_hide_until_switch = $1.to_i
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::UsableItem

#==============================================================================
# Å° Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: battle_commands
  #--------------------------------------------------------------------------
  def battle_commands
    return self.actor.battle_commands unless actor.battle_commands == []
    return self.class.battle_commands
  end
  
  #--------------------------------------------------------------------------
  # new method: next_command_valid?
  #--------------------------------------------------------------------------
  def next_command_valid?
    if $imported["YEA-BattleSystem-FTB"] && BattleManager.btype?(:ftb)
      return false
    end
    return false if @action_input_index >= @actions.size - 1
    return true
  end
  
end # Game_Actor

#==============================================================================
# Å° Window_PartyCommand
#==============================================================================

class Window_PartyCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # overwrite method: make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    for command in YEA::BATTLE_COMMANDS::PARTY_COMMANDS
      case command
      when :fight
        add_command(Vocab::fight, :fight)
      when :escape
        add_command(Vocab::escape, :escape, BattleManager.can_escape?)
      when :combatlog
        next unless $imported["YEA-CombatLogDisplay"]
        add_command(YEA::COMBAT_LOG::COMMAND_NAME, :combatlog)
      when :autobattle
        next unless $imported["YEA-CommandAutobattle"]
        add_autobattle_command
      when :party
        next unless $imported["YEA-PartySystem"]
        next unless $imported["YEA-CommandParty"]
        add_party_command
      else
        process_custom_command(command)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: process_custom_command
  #--------------------------------------------------------------------------
  def process_custom_command(command)
    return unless YEA::BATTLE_COMMANDS::CUSTOM_PARTY_COMMANDS.include?(command)
    show = YEA::BATTLE_COMMANDS::CUSTOM_PARTY_COMMANDS[command][2]
    continue = show <= 0 ? true : $game_switches[show]
    return unless continue
    text = YEA::BATTLE_COMMANDS::CUSTOM_PARTY_COMMANDS[command][0]
    switch = YEA::BATTLE_COMMANDS::CUSTOM_PARTY_COMMANDS[command][1]
    enabled = switch <= 0 ? true : $game_switches[switch]
    add_command(text, command, enabled)
  end
  
end # Window_PartyCommand

#==============================================================================
# Å° Window_ConfirmCommand
#==============================================================================

class Window_ConfirmCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    deactivate
    hide
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return 128; end
  
  #--------------------------------------------------------------------------
  # visible_line_number
  #--------------------------------------------------------------------------
  def visible_line_number; return 4; end
  
  #--------------------------------------------------------------------------
  # overwrite method: make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    for command in YEA::BATTLE_COMMANDS::CONFIRM_COMMANDS
      case command
      when :execute
        text = YEA::BATTLE_COMMANDS::EXECUTE_VOCAB
        add_command(text, :execute)
      when :combatlog
        next unless $imported["YEA-CombatLogDisplay"]
        add_command(YEA::COMBAT_LOG::COMMAND_NAME, :combatlog)
      else
        process_custom_command(command)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: process_custom_command
  #--------------------------------------------------------------------------
  def process_custom_command(command)
    return unless YEA::BATTLE_COMMANDS::CUSTOM_CONFIRM_COMMANDS.include?(command)
    show = YEA::BATTLE_COMMANDS::CUSTOM_CONFIRM_COMMANDS[command][2]
    continue = show <= 0 ? true : $game_switches[show]
    return unless continue
    text = YEA::BATTLE_COMMANDS::CUSTOM_CONFIRM_COMMANDS[command][0]
    switch = YEA::BATTLE_COMMANDS::CUSTOM_CONFIRM_COMMANDS[command][1]
    enabled = switch <= 0 ? true : $game_switches[switch]
    add_command(text, command, enabled)
  end
  
  #--------------------------------------------------------------------------
  # setup
  #--------------------------------------------------------------------------
  def setup
    clear_command_list
    make_command_list
    refresh
    select(0)
    activate
    self.openness = 255
    show
  end
  
  #--------------------------------------------------------------------------
  # process_handling
  #--------------------------------------------------------------------------
  if $imported["YEA-BattleEngine"]
  def process_handling
    return unless open? && active
    return process_dir4 if Input.repeat?(:LEFT)
    return super
  end
  
  #--------------------------------------------------------------------------
  # process_dir4
  #--------------------------------------------------------------------------
  def process_dir4
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:dir4)
  end
  end # $imported["YEA-BattleEngine"]
  
end # Window_ConfirmCommand

#==============================================================================
# Å° Window_ActorCommand
#==============================================================================

class Window_ActorCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # alias method: setup
  #--------------------------------------------------------------------------
  alias window_actorcommand_setup_bcl setup
  def setup(actor)
    window_actorcommand_setup_bcl(actor)
    show
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    return if @actor.nil?
    @stype_list = []
    for command in @actor.battle_commands
      case command.upcase
      #---
      when /ATTACK/i
        add_attack_command
      when /SKILL LIST/i
        add_skill_commands
      when /DEFEND/i
        add_guard_command
      when /ITEMS/i
        add_item_command
      #---
      when /SKILL TYPE[ ](\d+)/i
        add_skill_type_command($1.to_i)
      when /SKILL[ ](\d+)/i
        add_skill_id_command($1.to_i)
      when /ITEM[ ](\d+)/i
        add_item_id_command($1.to_i)
      #---
      when /AUTOBATTLE/i
        next unless $imported["YEA-CommandAutobattle"]
        add_autobattle_command
      when /EQUIP/i
        next unless $imported["YEA-CommandEquip"]
        add_equip_command
      when /SUBCLASS LIST/i
        add_subclass_skill_types
      #---
      else; next        
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: add_skill_commands
  #--------------------------------------------------------------------------
  def add_skill_commands
    @actor.added_skill_types.each do |stype_id|
      next if @stype_list.include?(stype_id)
      next if include_subclass_type?(stype_id)
      add_skill_type_command(stype_id)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: include_subclass_type?
  #--------------------------------------------------------------------------
  def include_subclass_type?(stype_id)
    return false unless $imported["YEA-ClassSystem"]
    return @actor.subclass_skill_types.include?(stype_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: add_subclass_skill_types
  #--------------------------------------------------------------------------
  def add_subclass_skill_types
    return unless $imported["YEA-ClassSystem"]
    return if @actor.subclass.nil?
    @actor.subclass_skill_types.sort.each do |stype_id|
      next if @stype_list.include?(stype_id)
      add_skill_type_command(stype_id)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: add_skill_type_command
  #--------------------------------------------------------------------------
  def add_skill_type_command(stype_id)
    return unless @actor.added_skill_types.include?(stype_id)
    return if @stype_list.include?(stype_id)
    @stype_list.push(stype_id)
    name = $data_system.skill_types[stype_id]
    add_command(name, :skill, true, stype_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: add_skill_id_command
  #--------------------------------------------------------------------------
  def add_skill_id_command(skill_id)
    return if $data_skills[skill_id].nil?
    return unless add_use_skill?(skill_id)
    name = $data_skills[skill_id].command_name
    add_command(name, :use_skill, use_skill_valid?(skill_id), skill_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: add_use_skill?
  #--------------------------------------------------------------------------
  def add_use_skill?(skill_id)
    skill = $data_skills[skill_id]
    return false if hide_until_learn?(skill)
    return false if hide_until_usable?(skill)
    return false if hide_until_switch?(skill)
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: hide_until_learn?
  #--------------------------------------------------------------------------
  def hide_until_learn?(skill)
    return false unless skill.command_hide_until_learn
    return false if @actor.skill_learn?(skill)
    return false if @actor.added_skills.include?(skill.id)
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: hide_until_usable?
  #--------------------------------------------------------------------------
  def hide_until_usable?(skill)
    return false unless skill.command_hide_until_usable
    return false if @actor.usable?(skill)
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: hide_until_switch?
  #--------------------------------------------------------------------------
  def hide_until_switch?(skill)
    return false unless skill.command_hide_until_switch > 0
    return false if $game_switches[skill.command_hide_until_switch]
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: use_skill_valid?
  #--------------------------------------------------------------------------
  def use_skill_valid?(skill_id)
    skill = $data_skills[skill_id]
    return false unless @actor.skill_conditions_met?(skill)
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: add_item_id_command
  #--------------------------------------------------------------------------
  def add_item_id_command(item_id)
    return if $data_items[item_id].nil?
    return unless add_use_item?(item_id)
    name = $data_items[item_id].command_name
    add_command(name, :use_item, use_item_valid?(item_id), item_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: add_use_item?
  #--------------------------------------------------------------------------
  def add_use_item?(item_id)
    item = $data_items[item_id]
    return false if hide_until_usable?(item)
    return false if hide_until_switch?(item)
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: use_item_valid?
  #--------------------------------------------------------------------------
  def use_item_valid?(item_id)
    item = $data_items[item_id]
    return false unless @actor.item_conditions_met?(item)
    return true
  end
  
end # Window_ActorCommand

#==============================================================================
# Å° Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: create_all_windows
  #--------------------------------------------------------------------------
  alias scene_battle_create_all_windows_bcl create_all_windows
  def create_all_windows
    scene_battle_create_all_windows_bcl
    create_confirm_command_window
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_party_command_window
  #--------------------------------------------------------------------------
  alias create_party_command_window_bcl create_party_command_window
  def create_party_command_window
    create_party_command_window_bcl
    process_custom_party_commands
  end
  
  #--------------------------------------------------------------------------
  # new method: process_custom_party_commands
  #--------------------------------------------------------------------------
  def process_custom_party_commands
    for command in YEA::BATTLE_COMMANDS::PARTY_COMMANDS
      next unless YEA::BATTLE_COMMANDS::CUSTOM_PARTY_COMMANDS.include?(command)
      called_method = YEA::BATTLE_COMMANDS::CUSTOM_PARTY_COMMANDS[command][3]
      @party_command_window.set_handler(command, method(called_method))
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_actor_command_window
  #--------------------------------------------------------------------------
  alias create_actor_command_window_bcl create_actor_command_window
  def create_actor_command_window
    create_actor_command_window_bcl
    @actor_command_window.set_handler(:use_skill, method(:command_use_skill))
    @actor_command_window.set_handler(:use_item, method(:command_use_item))
  end
  
  #--------------------------------------------------------------------------
  # alias method: start_actor_command_selection
  #--------------------------------------------------------------------------
  alias start_actor_command_selection_bcl start_actor_command_selection
  def start_actor_command_selection
    @confirm_command_window.hide unless @confirm_command_window.nil?
    start_actor_command_selection_bcl
    @actor_command_window.show
  end
  
  #--------------------------------------------------------------------------
  # new method: command_use_skill
  #--------------------------------------------------------------------------
  def command_use_skill
    @skill = $data_skills[@actor_command_window.current_ext]
    BattleManager.actor.input.set_skill(@skill.id)
    BattleManager.actor.last_skill.object = @skill
    status_redraw_target(BattleManager.actor)
    if $imported["YEA-BattleEngine"]
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
  # new method: command_use_item
  #--------------------------------------------------------------------------
  def command_use_item
    @item = $data_items[@actor_command_window.current_ext]
    BattleManager.actor.input.set_item(@item.id)
    status_redraw_target(BattleManager.actor)
    if $imported["YEA-BattleEngine"]
      $game_temp.battle_aid = @item
      if @item.for_opponent?
        select_enemy_selection
      elsif @item.for_friend?
        select_actor_selection
      else
        next_command
        $game_temp.battle_aid = nil
      end
    else
      if !@item.need_selection?
        next_command
      elsif @item.for_opponent?
        select_enemy_selection
      else
        select_actor_selection
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_actor_ok
  #--------------------------------------------------------------------------
  alias scene_battle_on_actor_ok_bcl on_actor_ok
  def on_actor_ok
    scene_battle_on_actor_ok_bcl
    return if !@confirm_command_window.nil? && @confirm_command_window.visible
    @actor_command_window.show
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_actor_cancel
  #--------------------------------------------------------------------------
  alias scene_battle_on_actor_cancel_bcl on_actor_cancel
  def on_actor_cancel
    scene_battle_on_actor_cancel_bcl
    case @actor_command_window.current_symbol
    when :use_skill, :use_item
      @help_window.hide
      @status_window.show
      @actor_command_window.activate
      status_redraw_target(BattleManager.actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_enemy_ok
  #--------------------------------------------------------------------------
  alias scene_battle_on_enemy_ok_bcl on_enemy_ok
  def on_enemy_ok
    scene_battle_on_enemy_ok_bcl
    return if !@confirm_command_window.nil? && @confirm_command_window.visible
    @actor_command_window.show
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_enemy_cancel
  #--------------------------------------------------------------------------
  alias scene_battle_on_enemy_cancel_bcl on_enemy_cancel
  def on_enemy_cancel
    scene_battle_on_enemy_cancel_bcl
    case @actor_command_window.current_symbol
    when :use_skill, :use_item
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
  
  #--------------------------------------------------------------------------
  # new method: create_confirm_command_window
  #--------------------------------------------------------------------------
  def create_confirm_command_window
    return unless YEA::BATTLE_COMMANDS::USE_CONFIRM_WINDOW
    @confirm_command_window = Window_ConfirmCommand.new
    @confirm_command_window.viewport = @info_viewport
    @confirm_command_window.set_handler(:execute, method(:command_execute))
    @confirm_command_window.set_handler(:cancel, method(:on_confirm_cancel))
    @confirm_command_window.set_handler(:dir4, method(:on_confirm_cancel))
    @confirm_command_window.unselect
    @confirm_command_window.x = Graphics.width
    process_custom_confirm_commands
    process_confirm_compatibility_commands
  end
  
  #--------------------------------------------------------------------------
  # new method: process_custom_confirm_commands
  #--------------------------------------------------------------------------
  def process_custom_confirm_commands
    for command in YEA::BATTLE_COMMANDS::CONFIRM_COMMANDS
      next unless YEA::BATTLE_COMMANDS::CUSTOM_CONFIRM_COMMANDS.include?(command)
      called_method = YEA::BATTLE_COMMANDS::CUSTOM_CONFIRM_COMMANDS[command][3]
      @party_command_window.set_handler(command, method(called_method))
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: process_confirm_compatibility_commands
  #--------------------------------------------------------------------------
  def process_confirm_compatibility_commands
    #---
    if $imported["YEA-CombatLogDisplay"]
      @confirm_command_window.set_handler(:combatlog, method(:open_combatlog))
    end
    #---
  end
  
  #--------------------------------------------------------------------------
  # new method: start_confirm_command_selection
  #--------------------------------------------------------------------------
  def start_confirm_command_selection
    if $imported["YEA-BattleEngine"]
      @status_window.show
      redraw_current_status
      @status_aid_window.hide
    end
    @status_window.unselect
    @actor_command_window.hide
    @confirm_command_window.setup
  end
  
  #--------------------------------------------------------------------------
  # new method: on_confirm_cancel
  #--------------------------------------------------------------------------
  def on_confirm_cancel
    @confirm_command_window.hide unless @confirm_command_window.nil?
    @actor_command_window.show
    @actor_command_window.setup(BattleManager.actor)
    @status_window.select(BattleManager.actor.index)
    prior_command unless BattleManager.actor.inputable?
  end
  
  #--------------------------------------------------------------------------
  # alias method: next_command
  #--------------------------------------------------------------------------
  alias scene_battle_next_command_bcl next_command
  def next_command
    if prompt_next_actor?
      scene_battle_next_command_bcl
    elsif YEA::BATTLE_COMMANDS::USE_CONFIRM_WINDOW
      start_confirm_command_selection
    else
      turn_start
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: prompt_next_actor?
  #--------------------------------------------------------------------------
  def prompt_next_actor?
    index = @status_window.index
    last_index = $game_party.battle_members.size - 1
    for member in $game_party.battle_members.reverse
      break if member.inputable?
      last_index -= 1
    end
    if index >= last_index
      actor = $game_party.battle_members[index]
      return true if prompt_ftb_action?(actor)
      return true if actor.next_command_valid?
      return false if YEA::BATTLE_COMMANDS::USE_CONFIRM_WINDOW
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: prompt_ftb_action?
  #--------------------------------------------------------------------------
  def prompt_ftb_action?(actor)
    return false unless $imported["YEA-BattleEngine"]
    return false unless $imported["YEA-BattleSystem-FTB"]
    return false unless BattleManager.btype?(:ftb)
    return actor.current_action.valid?
  end
  
  #--------------------------------------------------------------------------
  # new method: command_execute
  #--------------------------------------------------------------------------
  def command_execute
    @confirm_command_window.close
    turn_start
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
  
end # Scene_Battle

#==============================================================================
# 
# Å• End of File
# 
#==============================================================================
