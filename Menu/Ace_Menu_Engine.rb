#==============================================================================
# 
# ▼ Yanfly Engine Ace - Ace Menu Engine v1.07
# -- Last Updated: 2012.01.03
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-AceMenuEngine"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.03 - Compatibility Update: Ace Item Menu
# 2012.01.01 - Compatibility Update: Kread-EX's Synthesis
#            - Compatibility Update: Kread-EX's Grathnode Install
#            - Compatibility Update: Yami's Slot Battle
# 2011.12.23 - Script efficiency optimized.
# 2011.12.19 - Compatibility Update: Class System
# 2011.12.15 - Updated for better menu MP/TP gauge management.
# 2011.12.13 - Compatibility Update: Ace Equip Engine
# 2011.12.07 - Update to allow for switches to also hide custom commands.
# 2011.12.06 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# The menu system in RPG Maker VX Ace is great. However, it lacks the user
# customization that RPG Maker 2003 allowed. With this script, you can add,
# remove, and rearrange menu commands as you see fit. In addition to that, you
# can add in menu commands that lead to common events or even custom commands
# provided through other scripts.
# 
# This script also provides window appearance management such as setting almost
# all command windows to be center aligned or changing the position of the
# help window. You can also opt to show the TP Gauge in the main menu as well
# as in the skill menu.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Edit the settings in the module below as you see fit.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module MENU
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Menu Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This changes the way menus appear in your game. You can change their
    # alignment, and the location of the help window, Note that any non-Yanfly
    # Engine Ace scripts may not conform to these menu styles.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    HELP_WINDOW_LOCATION = 0     # 0-Top, 1-Middle, 2-Bottom.
    COMMAND_WINDOW_ALIGN = 1     # 0-Left, 1-Middle, 2-Right.
    
    # These settings below adjust the visual appearance of the main menu.
    # Change the settings as you see fit.
    MAIN_MENU_ALIGN = 0          # 0-Left, 1-Middle, 2-Right.
    MAIN_MENU_RIGHT = false      # false-Left, true-Right.
    MAIN_MENU_ROWS  = 10         # Maximum number of rows for main menu.
    DRAW_TP_GAUGE   = true       # If true, draws TP in the main menu.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Main Menu Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust the main menu, the order at which commands appear,
    # what text is displayed, and what the commands are linked to. Here's a
    # list of which commands do what:
    # 
    # -------------------------------------------------------------------------
    # :command         Description
    # -------------------------------------------------------------------------
    # :item            Opens up the item menu. Default menu item.
    # :skill           Opens up the skill menu. Default menu item.
    # :equip           Opens up the equip menu. Default menu item.
    # :status          Opens up the status menu. Default menu item.
    # :formation       Lets player manage party. Default menu item.
    # :save            Opens up the save menu. Default menu item.
    # :game_end        Opens up the shutdown menu. Default menu item.
    # 
    # :class           Requires YEA - Class System
    # 
    # :gogototori      Requires Kread-EX's Go Go Totori! Synthesis
    # :grathnode       Requires Kread-EX's Grathnote Install
    # :sslots          Requires Yami's YSA - Slot Battle
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMANDS =[
      :item,         # Opens up the item menu. Default menu item.
      :skill,        # Opens up the skill menu. Default menu item.
      :equip,        # Opens up the equip menu. Default menu item.
      :class,        # Requires YEA - Class System.
      :status,       # Opens up the status menu. Default menu item.
      :formation,    # Lets player manage party. Default menu item.
    # :event_1,      # Launches Common Event 1. Common Event Command.
    # :event_2,      # Launches Common Event 2. Common Event Command.
    # :debug,        # Opens up debug menu. Custom Command.
    # :shop,         # Opens up a shop to pawn items. Custom Command.
      :save,         # Opens up the save menu. Default menu item.
      :game_end,     # Opens up the shutdown menu. Default menu item.
    ] # Do not remove this.
    
    #--------------------------------------------------------------------------
    # - Common Event Commands -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If you insert one of the following commands into the COMMANDS array, the
    # player can trigger a common event to launch. You can disable certain
    # commands in the menu by binding them to a switch. If you don't want to
    # disable them, set the switch to 0 and it will always be enabled. The
    # ShowSwitch will prevent a command from appear if that switch is false.
    # Set it to 0 for it to have no impact.
    #--------------------------------------------------------------------------
    COMMON_EVENT_COMMANDS ={
    # :command => ["Display Name", EnableSwitch, ShowSwitch, Event ID],
      :event_1 => [        "Camp",           11,          0,        1],
      :event_2 => [   "Synthesis",            0,          0,        2],
    } # Do not remove this.
    
    #--------------------------------------------------------------------------
    # - Custom Commands -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # For those who use scripts that may lead to other menu scenes, use this
    # hash to manage custom commands that run specific script calls. You can
    # disable certain commands in the menu by binding them to a switch. If you
    # don't want to disable them, set the switch to 0. The ShowSwitch will
    # prevent a command from appear if that switch is false. Set it to 0 for
    # it to have no impact.
    #--------------------------------------------------------------------------
    CUSTOM_COMMANDS ={
    # :command => ["Display Name", EnableSwitch, ShowSwitch, Handler Method],
      :debug   => [       "Debug",            0,          0, :command_debug],
      :shop    => [        "Shop",           12,          0,  :command_shop],
      :gogototori => ["Synthesis",            0,        0,  :command_totori],
      :grathnode => [ "Grathnode",            0,        0, :command_install],
    } # Do not remove this.
    
  end # MENU
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Window_MenuCommand
#------------------------------------------------------------------------------
# This class is kept towards the top of the script to provide easier access.
#==============================================================================

class Window_MenuCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # overwrite method: make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    for command in YEA::MENU::COMMANDS
      case command
      #--- Default Commands ---
      when :item
        add_command(Vocab::item,   :item,   main_commands_enabled)
      when :skill
        add_command(Vocab::skill,  :skill,  main_commands_enabled)
      when :equip
        add_command(Vocab::equip,  :equip,  main_commands_enabled)
      when :status
        add_command(Vocab::status, :status, main_commands_enabled)
      when :formation
        add_formation_command
      when :save
        add_original_commands
        add_save_command
      when :game_end
        add_game_end_command
      #--- Yanfly Engine Ace Commands ---
      when :class
        next unless $imported["YEA-ClassSystem"]
        add_class_command
      #--- Imported Commands ---
      when :sslots
        next unless $imported["YSA-SlotBattle"]
        add_sslots_command
      when :grathnode
        next unless $imported["KRX-GrathnodeInstall"]
        process_custom_command(command)
      when :gogototori
        next unless $imported["KRX-AlchemicSynthesis"]
        process_custom_command(command)
      #--- Imported Commands ---
      else
        process_common_event_command(command)
        process_custom_command(command)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: process_common_event_command
  #--------------------------------------------------------------------------
  def process_common_event_command(command)
    return unless YEA::MENU::COMMON_EVENT_COMMANDS.include?(command)
    show = YEA::MENU::COMMON_EVENT_COMMANDS[command][2]
    continue = show <= 0 ? true : $game_switches[show]
    return unless continue
    text = YEA::MENU::COMMON_EVENT_COMMANDS[command][0]
    switch = YEA::MENU::COMMON_EVENT_COMMANDS[command][1]
    ext = YEA::MENU::COMMON_EVENT_COMMANDS[command][3]
    enabled = switch <= 0 ? true : $game_switches[switch]
    add_command(text, command, enabled, ext)
  end
  
  #--------------------------------------------------------------------------
  # new method: process_custom_command
  #--------------------------------------------------------------------------
  def process_custom_command(command)
    return unless YEA::MENU::CUSTOM_COMMANDS.include?(command)
    show = YEA::MENU::CUSTOM_COMMANDS[command][2]
    continue = show <= 0 ? true : $game_switches[show]
    return unless continue
    text = YEA::MENU::CUSTOM_COMMANDS[command][0]
    switch = YEA::MENU::CUSTOM_COMMANDS[command][1]
    enabled = switch <= 0 ? true : $game_switches[switch]
    add_command(text, command, enabled)
  end
  
end # Window_MenuCommand

#==============================================================================
# ■ Menu
#==============================================================================

module Menu
  
  #--------------------------------------------------------------------------
  # self.help_window_location
  #--------------------------------------------------------------------------
  def self.help_window_location
    return YEA::MENU::HELP_WINDOW_LOCATION
  end
  
  #--------------------------------------------------------------------------
  # self.command_window_align
  #--------------------------------------------------------------------------
  def self.command_window_align
    return YEA::MENU::COMMAND_WINDOW_ALIGN
  end
  
  #--------------------------------------------------------------------------
  # self.main_menu_align
  #--------------------------------------------------------------------------
  def self.main_menu_align
    return YEA::MENU::MAIN_MENU_ALIGN
  end
  
  #--------------------------------------------------------------------------
  # self.main_menu_right
  #--------------------------------------------------------------------------
  def self.main_menu_right
    return YEA::MENU::MAIN_MENU_RIGHT
  end
  
end # Menu

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: draw_mp?
  #--------------------------------------------------------------------------
  def draw_mp?
    return true unless draw_tp?
    for skill in skills
      next unless added_skill_types.include?(skill.stype_id)
      return true if skill.mp_cost > 0
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_tp?
  #--------------------------------------------------------------------------
  def draw_tp?
    return false unless $data_system.opt_display_tp
    for skill in skills
      next unless added_skill_types.include?(skill.stype_id)
      return true if skill.tp_cost > 0
    end
    return false
  end
  
end # Game_Actor

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_simple_status
  #--------------------------------------------------------------------------
  def draw_actor_simple_status(actor, dx, dy)
    dy -= line_height / 2
    draw_actor_name(actor, dx, dy)
    draw_actor_level(actor, dx, dy + line_height * 1)
    draw_actor_icons(actor, dx, dy + line_height * 2)
    dw = contents.width - dx - 124
    draw_actor_class(actor, dx + 120, dy, dw)
    draw_actor_hp(actor, dx + 120, dy + line_height * 1, dw)
    if YEA::MENU::DRAW_TP_GAUGE && actor.draw_tp? && !actor.draw_mp?
      draw_actor_tp(actor, dx + 120, dy + line_height * 2, dw)
    elsif YEA::MENU::DRAW_TP_GAUGE && actor.draw_tp? && actor.draw_mp?
      if $imported["YEA-BattleEngine"]
        draw_actor_tp(actor, dx + 120, dy + line_height * 2, dw/2 + 1)
        draw_actor_mp(actor, dx + 120 + dw/2, dy + line_height * 2, dw/2)
      else
        draw_actor_mp(actor, dx + 120, dy + line_height * 2, dw/2 + 1)
        draw_actor_tp(actor, dx + 120 + dw/2, dy + line_height * 2, dw/2)
      end
    else
      draw_actor_mp(actor, dx + 120, dy + line_height * 2, dw)
    end
  end
  
end # Window_Base

#==============================================================================
# ■ Window_Command
#==============================================================================

class Window_Command < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: alignment
  #--------------------------------------------------------------------------
  def alignment
    return Menu.command_window_align
  end
  
end # Window_Command

#==============================================================================
# ■ Window_MenuCommand
#==============================================================================

class Window_MenuCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # alias method: init_command_position
  #--------------------------------------------------------------------------
  class <<self; alias init_command_position_ame init_command_position; end
  def self.init_command_position
    init_command_position_ame
    @@last_command_oy = nil
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: visible_line_number
  #--------------------------------------------------------------------------
  def visible_line_number
    return [[item_max, YEA::MENU::MAIN_MENU_ROWS].min, 1].max
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: alignment
  #--------------------------------------------------------------------------
  def alignment
    return Menu.main_menu_align
  end
  
  #--------------------------------------------------------------------------
  # alias method: process_ok
  #--------------------------------------------------------------------------
  alias window_menucommand_process_ok_ame process_ok
  def process_ok
    @@last_command_oy = self.oy
    window_menucommand_process_ok_ame
  end
  
  #--------------------------------------------------------------------------
  # alias method: select_last
  #--------------------------------------------------------------------------
  alias window_menucommand_select_last_ame select_last
  def select_last
    window_menucommand_select_last_ame
    self.oy = @@last_command_oy unless @@last_command_oy.nil?
    @@last_command_oy = nil
  end
  
end # Window_MenuCommand

#==============================================================================
# ■ Scene_Menu
#==============================================================================

class Scene_Menu < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # alias method: start
  #--------------------------------------------------------------------------
  alias scene_menu_start_ame start
  def start
    scene_menu_start_ame
    relocate_windows
  end
  
  #--------------------------------------------------------------------------
  # new method: relocate_windows
  #--------------------------------------------------------------------------
  def relocate_windows
    return unless Menu.main_menu_right
    @command_window.x = Graphics.width - @command_window.width
    @gold_window.x = Graphics.width - @gold_window.width
    @status_window.x = 0
  end
  
end # Scene_Menu

#==============================================================================
# ■ Scene_Item
#==============================================================================

class Scene_Item < Scene_ItemBase
  
  #--------------------------------------------------------------------------
  # alias method: start
  #--------------------------------------------------------------------------
  alias scene_item_start_ame start
  def start
    scene_item_start_ame
    return if $imported["YEA-ItemMenu"]
    relocate_windows
  end
  
  #--------------------------------------------------------------------------
  # new method: relocate_windows
  #--------------------------------------------------------------------------
  def relocate_windows
    case Menu.help_window_location
    when 0 # Top
      @help_window.y = 0
      @category_window.y = @help_window.height
      @item_window.y = @category_window.y + @category_window.height
    when 1 # Middle
      @category_window.y = 0
      @help_window.y = @category_window.height
      @item_window.y = @help_window.y + @help_window.height
    else # Bottom
      @category_window.y = 0
      @item_window.y = @category_window.height
      @help_window.y = @item_window.y + @item_window.height
    end
    if $imported["YEA-ItemMenu"]
      @types_window.y = @category_window.y
      @status_window.y = @category_window.y
    end
  end
  
end # Scene_Item

#==============================================================================
# ■ Scene_Skill
#==============================================================================

class Scene_Skill < Scene_ItemBase
  
  #--------------------------------------------------------------------------
  # alias method: start
  #--------------------------------------------------------------------------
  alias scene_skill_start_ame start
  def start
    scene_skill_start_ame
    relocate_windows
  end
  
  #--------------------------------------------------------------------------
  # new method: relocate_windows
  #--------------------------------------------------------------------------
  def relocate_windows
    case Menu.help_window_location
    when 0 # Top
      @help_window.y = 0
      @command_window.y = @help_window.height
      @status_window.y = @help_window.height
      @item_window.y = @status_window.y + @status_window.height
    when 1 # Middle
      @command_window.y = 0
      @status_window.y = 0
      @help_window.y = @status_window.y + @status_window.height
      @item_window.y = @help_window.y + @help_window.height
    else # Bottom
      @command_window.y = 0
      @status_window.y = 0
      @item_window.y = @status_window.y + @status_window.height
      @help_window.y = @item_window.y + @item_window.height
    end
  end
  
end # Scene_Skill

#==============================================================================
# ■ Scene_Equip
#==============================================================================

class Scene_Equip < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # alias method: start
  #--------------------------------------------------------------------------
  alias scene_equip_start_ame start
  def start
    scene_equip_start_ame
    relocate_windows
    relocate_aee_windows
  end
  
  #--------------------------------------------------------------------------
  # new method: relocate_windows
  #--------------------------------------------------------------------------
  def relocate_windows
    return if $imported["YEA-AceEquipEngine"]
    case Menu.help_window_location
    when 0 # Top
      @help_window.y = 0
      @status_window.y = @help_window.height
      @command_window.y = @help_window.height
      @slot_window.y = @command_window.y + @command_window.height
      @item_window.y = @slot_window.y + @slot_window.height
    when 1 # Middle
      @status_window.y = 0
      @command_window.y = 0
      @slot_window.y = @command_window.y + @command_window.height
      @help_window.y = @slot_window.y + @slot_window.height
      @item_window.y = @help_window.y + @help_window.height
    else # Bottom
      @status_window.y = 0
      @command_window.y = 0
      @slot_window.y = @command_window.y + @command_window.height
      @item_window.y = @slot_window.y + @slot_window.height
      @help_window.y = @item_window.y + @item_window.height
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: relocate_aee_windows
  #--------------------------------------------------------------------------
  def relocate_aee_windows
    return unless $imported["YEA-AceEquipEngine"]
    case Menu.help_window_location
    when 0 # Top
      @help_window.y = 0
      @command_window.y = @help_window.height
      @slot_window.y = @command_window.y + @command_window.height
    when 1 # Middle
      @command_window.y = 0
      @help_window.y = @command_window.height
      @slot_window.y = @help_window.y + @help_window.height
    else # Bottom
      @command_window.y = 0
      @slot_window.y = @command_window.height
      @help_window.y = @slot_window.y + @slot_window.height
    end
    @actor_window.y = @command_window.y
    @item_window.y = @slot_window.y
    @status_window.y = @slot_window.y
  end
  
end # Scene_Equip

#==============================================================================
# ■ Scene_Menu
#==============================================================================

class Scene_Menu < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # alias method: create_command_window
  #--------------------------------------------------------------------------
  alias scene_menu_create_command_window_ame create_command_window
  def create_command_window
    scene_menu_create_command_window_ame
    process_common_event_commands
    process_custom_commands
  end
  
  #--------------------------------------------------------------------------
  # new method: process_common_event_commands
  #--------------------------------------------------------------------------
  def process_common_event_commands
    for command in YEA::MENU::COMMANDS
      next unless YEA::MENU::COMMON_EVENT_COMMANDS.include?(command)
      @command_window.set_handler(command, method(:command_common_event))
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: command_common_event
  #--------------------------------------------------------------------------
  def command_common_event
    event_id = @command_window.current_ext
    return return_scene if event_id.nil?
    return return_scene if $data_common_events[event_id].nil?
    $game_temp.reserve_common_event(event_id)
    return_scene
  end
  
  #--------------------------------------------------------------------------
  # new method: process_custom_commands
  #--------------------------------------------------------------------------
  def process_custom_commands
    for command in YEA::MENU::COMMANDS
      next unless YEA::MENU::CUSTOM_COMMANDS.include?(command)
      called_method = YEA::MENU::CUSTOM_COMMANDS[command][3]
      @command_window.set_handler(command, method(called_method))
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: command_debug
  #--------------------------------------------------------------------------
  def command_debug
    SceneManager.call(Scene_Debug)
  end
  
  #--------------------------------------------------------------------------
  # new method: command_shop
  #--------------------------------------------------------------------------
  def command_shop
    goods = []
    SceneManager.call(Scene_Shop)
    SceneManager.scene.prepare(goods, false)
  end
  
  #--------------------------------------------------------------------------
  # new method: command_totori
  #--------------------------------------------------------------------------
  def command_totori
    return unless $imported['KRX-AlchemicSynthesis']
    SceneManager.call(Scene_Alchemy)
  end
  
end # Scene_Menu

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================