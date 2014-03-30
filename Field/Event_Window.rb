#==============================================================================
# 
# ▼ Yanfly Engine Ace - Event Window v1.01
# -- Last Updated: 2011.12.27
# -- Level: Easy, Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-EventWindow"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.27 - Bug Fixed: Used the wrong script to hide event window.
# 2011.12.26 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# The Event Window is a new feature added through this script that appears in
# the lower left corner of the screen. Whenever the player gains or loses gold
# and items, the Event Window is updated to show the changes. In addition to
# showing item gains and losses, you may even add in your own text to update
# through a Script Call.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Script Calls - These commands are used with script calls.
# -----------------------------------------------------------------------------
# event_window_add_text(string)
# This inserts "string" text into the Event Window. Use \n to designate
# linebreaks in the string. If you wish to use text codes, write them in the
# strings as \\n[2] or \\c[3] to make them work properly.
# 
# event_window_clear_text
# This causes the Event Window to clear all of the stored text. You can choose
# whether or not to clear the stored Event Window text every time the player
# enters a new map.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module EVENT_WINDOW
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Event Window Switch -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This is the switch used for hiding the event window. When this switch is
    # ON, the event window will be hidden from view. If it is OFF, the event
    # window will maintain normal visibility.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    HIDE_SWITCH = 24       # If switch is ON, event window will not appear.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Event Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This section adjusts the event window. These settings adjust the overall
    # appearance of the event window from the width to the number of lines
    # shown and the window fade rate.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    NEW_MAP_CLEAR = true    # Clear text when entering a new map?
    WINDOW_WIDTH  = 280     # Event Window width.
    VISIBLE_TIME  = 120     # Frames the window is visible before fading.
    MAX_LINES     = 4       # Maximum number of lines shown.
    WINDOW_FADE   = 8       # Fade rate for the Event Window.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Event Window Text Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This section adjusts the text that appears in the event window. The text
    # that appears when an item is found and the text that appears when an item
    # is lost will always appear before the item found. If there is more than
    # one item found, the amount text will be added on after followed by the
    # closing text. When gold is found, no icons will be used.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    HEADER_TEXT = "\e}⋅ "                # Text that's always used at the head.
    FOUND_TEXT  = "\ec[6]Found\ec[0] "   # Text used when an item is found.
    LOST_TEXT   = "\ec[4]Lost\ec[0] "    # Text used when an item is lost.
    AMOUNT_TEXT = "×%s"                  # Text used to display an amount.
    CLOSER_TEXT = " ⋅"                   # Text that's always used at the end.
    
  end # EVENT_WINDOW
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Switch
#==============================================================================

module Switch
  
  #--------------------------------------------------------------------------
  # self.hide_event_window
  #--------------------------------------------------------------------------
  def self.hide_event_window
    return false if YEA::EVENT_WINDOW::HIDE_SWITCH <= 0
    return $game_switches[YEA::EVENT_WINDOW::HIDE_SWITCH]
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
# ■ Game_Temp
#==============================================================================

class Game_Temp
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :event_window_data
  
  #--------------------------------------------------------------------------
  # new method: add_event_window_data
  #--------------------------------------------------------------------------
  def add_event_window_data(text)
    @event_window_data = [] if @event_window_data.nil?
    return if text == ""
    @event_window_data.push(text)
  end
  
  #--------------------------------------------------------------------------
  # new method: clear_event_window_data
  #--------------------------------------------------------------------------
  def clear_event_window_data
    @event_window_data = []
  end
  
end # Game_Temp

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # alias method: command_126
  #--------------------------------------------------------------------------
  alias game_interpreter_command_125_ew command_125
  def command_125
    game_interpreter_command_125_ew
    value = operate_value(@params[0], @params[1], @params[2])
    event_window_make_gold_text(value)
  end
  
  #--------------------------------------------------------------------------
  # alias method: command_126
  #--------------------------------------------------------------------------
  alias game_interpreter_command_126_ew command_126
  def command_126
    game_interpreter_command_126_ew
    value = operate_value(@params[1], @params[2], @params[3])
    event_window_make_item_text($data_items[@params[0]], value)
  end
  
  #--------------------------------------------------------------------------
  # alias method: command_127
  #--------------------------------------------------------------------------
  alias game_interpreter_command_127_ew command_127
  def command_127
    game_interpreter_command_127_ew
    value = operate_value(@params[1], @params[2], @params[3])
    event_window_make_item_text($data_weapons[@params[0]], value)
  end
  
  #--------------------------------------------------------------------------
  # alias method: command_128
  #--------------------------------------------------------------------------
  alias game_interpreter_command_128_ew command_128
  def command_128
    game_interpreter_command_128_ew
    value = operate_value(@params[1], @params[2], @params[3])
    event_window_make_item_text($data_armors[@params[0]], value)
  end
  
  #--------------------------------------------------------------------------
  # new method: event_window_make_gold_text
  #--------------------------------------------------------------------------
  def event_window_make_gold_text(value)
    return unless SceneManager.scene_is?(Scene_Map)
    return if Switch.hide_event_window
    if value > 0
      text = YEA::EVENT_WINDOW::FOUND_TEXT
    elsif value < 0
      text = YEA::EVENT_WINDOW::LOST_TEXT
    else; return
    end
    text += sprintf("%s%s", value.abs.group, Vocab::currency_unit)
    event_window_add_text(text)
  end
  
  #--------------------------------------------------------------------------
  # new method: event_window_make_item_text
  #--------------------------------------------------------------------------
  def event_window_make_item_text(item, value)
    return unless SceneManager.scene_is?(Scene_Map)
    return if Switch.hide_event_window
    if value > 0
      text = YEA::EVENT_WINDOW::FOUND_TEXT
    elsif value < 0
      text = YEA::EVENT_WINDOW::LOST_TEXT
    else; return
    end
    text += sprintf("\ei[%d]%s", item.icon_index, item.name)
    if value.abs > 1
      fmt = YEA::EVENT_WINDOW::AMOUNT_TEXT
      text += sprintf(fmt, value.abs.group)
    end
    event_window_add_text(text)
  end
  
  #--------------------------------------------------------------------------
  # new method: event_window_add_text
  #--------------------------------------------------------------------------
  def event_window_add_text(text)
    return unless SceneManager.scene_is?(Scene_Map)
    return if Switch.hide_event_window
    text = YEA::EVENT_WINDOW::HEADER_TEXT + text
    text += YEA::EVENT_WINDOW::CLOSER_TEXT
    SceneManager.scene.event_window_add_text(text)
  end
  
  #--------------------------------------------------------------------------
  # new method: event_window_clear_text
  #--------------------------------------------------------------------------
  def event_window_clear_text
    $game_temp.clear_event_window_data
  end
  
end # Game_Interpreter

#==============================================================================
# ■ Window_EventWindow
#==============================================================================

class Window_EventWindow < Window_Selectable
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    dw = YEA::EVENT_WINDOW::WINDOW_WIDTH
    super(0, 0, dw, fitting_height(YEA::EVENT_WINDOW::MAX_LINES))
    self.x -= 12
    self.opacity = 0
    self.contents_opacity = 0
    @visible_counter = 0
    modify_skin
    deactivate
  end
  
  #--------------------------------------------------------------------------
  # modify_skin
  #--------------------------------------------------------------------------
  def modify_skin
    dup_skin = self.windowskin.dup
    dup_skin.clear_rect(64,  0, 64, 64)
    dup_skin.clear_rect(64, 64, 32, 32)
    self.windowskin = dup_skin
  end
  
  #--------------------------------------------------------------------------
  # item_max
  #--------------------------------------------------------------------------
  def item_max
    return $game_temp.event_window_data ? $game_temp.event_window_data.size : 1
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    self.visible = show_window?
    update_visible_counter
    update_contents_opacity
  end
  
  #--------------------------------------------------------------------------
  # show_window?
  #--------------------------------------------------------------------------
  def show_window?
    return false if $game_message.visible
    return true
  end
  
  #--------------------------------------------------------------------------
  # update_visible_counter
  #--------------------------------------------------------------------------
  def update_visible_counter
    return if @visible_counter <= 0
    @visible_counter -= 1
  end
  
  #--------------------------------------------------------------------------
  # update_contents_opacity
  #--------------------------------------------------------------------------
  def update_contents_opacity
    return if @visible_counter > 0
    return if self.contents_opacity <= 0
    self.contents_opacity -= YEA::EVENT_WINDOW::WINDOW_FADE
  end
  
  #--------------------------------------------------------------------------
  # instant_hide
  #--------------------------------------------------------------------------
  def instant_hide
    @visible_counter = 0
    self.contents_opacity = 0
  end
  
  #--------------------------------------------------------------------------
  # add_text
  #--------------------------------------------------------------------------
  def add_text(text)
    $game_temp.add_event_window_data(text)
    refresh
    self.contents_opacity = 255
    @visible_counter = YEA::EVENT_WINDOW::VISIBLE_TIME
    change_y_position
    select(item_max - 1)
  end
  
  #--------------------------------------------------------------------------
  # change_y_position
  #--------------------------------------------------------------------------
  def change_y_position
    maximum = [item_max, YEA::EVENT_WINDOW::MAX_LINES].min
    self.y = Graphics.height - fitting_height(maximum) - 12
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    draw_all_items
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    $game_temp.clear_event_window_data if $game_temp.event_window_data.nil?
    item = $game_temp.event_window_data[index]
    return if item.nil?
    rect = item_rect(index)
    draw_background(rect)
    rect.x += 4
    rect.width -= 8
    draw_text_ex(rect.x, rect.y, item)
  end
  
  #--------------------------------------------------------------------------
  # draw_background
  #--------------------------------------------------------------------------
  def draw_background(rect)
    back_colour1 = Color.new(0, 0, 0, 96)
    back_colour2 = Color.new(0, 0, 0, 0)
    contents.gradient_fill_rect(rect, back_colour1, back_colour2)
  end
  
end # Window_EventWindow

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: create_all_windows
  #--------------------------------------------------------------------------
  alias scene_map_create_all_windows_event_window create_all_windows
  def create_all_windows
    scene_map_create_all_windows_event_window
    create_event_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_event_window
  #--------------------------------------------------------------------------
  def create_event_window
    @event_window = Window_EventWindow.new
  end
  
  #--------------------------------------------------------------------------
  # new method: event_window_add_text
  #--------------------------------------------------------------------------
  def event_window_add_text(text)
    @event_window.add_text(text)
  end
  
  #--------------------------------------------------------------------------
  # alias method: post_transfer
  #--------------------------------------------------------------------------
  alias scene_map_post_transfer_ew post_transfer
  def post_transfer
    $game_temp.clear_event_window_data if YEA::EVENT_WINDOW::NEW_MAP_CLEAR
    @event_window.instant_hide
    scene_map_post_transfer_ew
  end
  
end # Scene_Map

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================