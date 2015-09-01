#==============================================================================
# 
# ▼ Yanfly Engine Ace - Debug Extension v1.01
# -- Last Updated: 2012.01.05
# -- Level: Easy, Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-DebugExtension"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2015.09.01 - Delayed the generation of the windows until they are needed.
# 2012.01.05 - Script no longer conflicts with conditional Key presses.
# 2012.01.04 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# While the RPG Maker VX Ace debug menu gets the basics done, this script will
# add on even more functionality. This script provides an extended debug menu,
# common event shortcuts that can be ran from a few key presses, and even an
# input console to manually insert code and run it.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Debug Shortcuts - Only during $TEST and $BTEST mode
# -----------------------------------------------------------------------------
# Alt   + F5-F9 - Common Event Debug Shortcut
# Ctrl  + F5-F9 - Common Event Debug Shortcut
# Shift + F5-F9 - Common Event Debug Shortcut
# F9 on the map - Open Debug Menu.
# 
# F10 anywhere - Opens up the Debug Entry Window.
#   Here, you may enter in a piece of code and the script itself will run it
#   using the current scene as its host. So long as the code doesn't contain
#   any syntax errors, it'll run right immediately. Idea by OriginalWij.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module DEBUG
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Common Event Shortcut Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Here, you can define common event shortcuts to launch during test play
    # mode and pressing the right shortcut combination. If you do not wish to
    # use a particular shortcut key, set it to 0.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Common event shortcuts when holding down ALT and pressing an F5-F9 key.
    ALT ={ # Only works during test play mode.
      :F5 => 0,
      :F6 => 0,
      :F7 => 0,
      :F8 => 0,
      :F9 => 0,
    } # Do not remove this.
    
    # Common event shortcuts when holding down CTRL and pressing an F5-F9 key.
    CTRL ={ # Only works during test play mode.
      :F5 => 0,
      :F6 => 0,
      :F7 => 0,
      :F8 => 0,
      :F9 => 0,
    } # Do not remove this.
    
    # Common event shortcuts when holding down SHIFT and pressing an F5-F9 key.
    SHIFT ={ # Only works during test play mode.
      :F5 => 0,
      :F6 => 0,
      :F7 => 0,
      :F8 => 0,
      :F9 => 0,
    } # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Debug Menu Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # The following adjusts debug menu data. There's no real need to edit
    # anything here unless you feel like it. Here's what the commands do:
    #   :switches     Adjust switches like default.
    #   :variables    Adjust variables like default.
    #   :teleport     Teleport to different maps.
    #   :battle       Enter the selected battle.
    #   :events       Call common events from menu.
    #   :items        Adjust item quantities.
    #   :weapons      Adjust weapon quantities.
    #   :armours      Adjust armour quantities.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Command window layout for the debug menu. Determines order and which
    # commands will be shown in the command window.
    COMMANDS =[
      [ :switches,  "Switches"],
      [:variables, "Variables"],
      [ :teleport,  "Teleport"],
      [   :battle,    "Battle"],
      [   :events,    "Events"],
      [    :items,     "Items"],
      [  :weapons,   "Weapons"],
      [  :armours,   "Armours"],
    ] # Do not remove this.
    
  end # DEBUG
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

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
# ■ Input
#==============================================================================

module Input
  
  #--------------------------------------------------------------------------
  # constants - Created by OriginalWij and Yanfly
  #--------------------------------------------------------------------------
  DEFAULT = [:DOWN, :LEFT, :RIGHT, :UP, :A, :B, :C, :X, :Y, :Z, :L, :R,
    :SHIFT, :CTRL, :ALT, :F5, :F6, :F7, :F8, :F9]
  
  LETTERS = {}
  LETTERS['A'] = 65; LETTERS['B'] = 66; LETTERS['C'] = 67; LETTERS['D'] = 68
  LETTERS['E'] = 69; LETTERS['F'] = 70; LETTERS['G'] = 71; LETTERS['H'] = 72
  LETTERS['I'] = 73; LETTERS['J'] = 74; LETTERS['K'] = 75; LETTERS['L'] = 76
  LETTERS['M'] = 77; LETTERS['N'] = 78; LETTERS['O'] = 79; LETTERS['P'] = 80
  LETTERS['Q'] = 81; LETTERS['R'] = 82; LETTERS['S'] = 83; LETTERS['T'] = 84
  LETTERS['U'] = 85; LETTERS['V'] = 86; LETTERS['W'] = 87; LETTERS['X'] = 88
  LETTERS['Y'] = 89; LETTERS['Z'] = 90
  
  NUMBERS = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57]
  NUMPAD = [96, 97, 98, 99, 100, 101, 102, 103, 104, 105]
  
  BACK   = 138; ENTER  = 143; SPACE  = 32;  SCOLON = 186; ESC    = 157
  QUOTE  = 222; EQUALS = 187; COMMA  = 188; USCORE = 189; PERIOD = 190
  SLASH  = 191; LBRACE = 219; RBRACE = 221; BSLASH = 220; TILDE  = 192
  F10    = 121; F11    = 122; CAPS   = 20;  NMUL   = 106; NPLUS  = 107
  NSEP   = 108; NMINUS = 109; NDECI  = 110; NDIV   = 111; 
  
  Extras = [USCORE, EQUALS, LBRACE, RBRACE, BSLASH, SCOLON, QUOTE, COMMA,
   PERIOD, SLASH, NMUL, NPLUS, NSEP, NMINUS, NDECI, NDIV]

  #--------------------------------------------------------------------------
  # initial module settings - Created by OriginalWij and Yanfly
  #--------------------------------------------------------------------------
  GetKeyState = Win32API.new("user32", "GetAsyncKeyState", "i", "i") 
  GetCapState = Win32API.new("user32", "GetKeyState", "i", "i") 
  KeyRepeatCounter = {}
  
  module_function
  #--------------------------------------------------------------------------
  # alias method: update - Created by OriginalWij
  #--------------------------------------------------------------------------
  class <<self; alias input_update_debug update; end
  def self.update
    input_update_debug
    for key in KeyRepeatCounter.keys
      if (GetKeyState.call(key).abs & 0x8000 == 0x8000)
        KeyRepeatCounter[key] += 1
      else
        KeyRepeatCounter.delete(key)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: press? - Created by OriginalWij
  #--------------------------------------------------------------------------
  class <<self; alias input_press_debug press?; end
  def self.press?(key)
    return input_press_debug(key) if default_key?(key)
    adjusted_key = adjust_key(key)
    return true unless KeyRepeatCounter[adjusted_key].nil?
    return key_pressed?(adjusted_key)
  end
  
  #--------------------------------------------------------------------------
  # alias method: trigger? - Created by OriginalWij
  #--------------------------------------------------------------------------
  class <<self; alias input_trigger_debug trigger?; end
  def self.trigger?(key)
    return input_trigger_debug(key) if default_key?(key)
    adjusted_key = adjust_key(key)
    count = KeyRepeatCounter[adjusted_key]
    return ((count == 0) || (count.nil? ? key_pressed?(adjusted_key) : false))
  end
  
  #--------------------------------------------------------------------------
  # alias method: repeat? - Created by OriginalWij
  #--------------------------------------------------------------------------
  class <<self; alias input_repeat_debug repeat?; end
  def self.repeat?(key)
    return input_repeat_debug(key) if default_key?(key)
    adjusted_key = adjust_key(key)
    count = KeyRepeatCounter[adjusted_key]
    return true if count == 0
    if count.nil?
      return key_pressed?(adjusted_key)
    else
      return (count >= 23 && (count - 23) % 6 == 0)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: default_key? - Created by Yanfly
  #--------------------------------------------------------------------------
  def self.default_key?(key)
    return true if key.is_a?(Integer) && key < 30
    return DEFAULT.include?(key)
  end
  
  #--------------------------------------------------------------------------
  # new method: adjust_key - Created by OriginalWij
  #--------------------------------------------------------------------------
  def self.adjust_key(key)
    key -= 130 if key.between?(130, 158)
    return key
  end
  
  #--------------------------------------------------------------------------
  # new method: key_pressed? - Created by OriginalWij
  #--------------------------------------------------------------------------
  def self.key_pressed?(key)
    if (GetKeyState.call(key).abs & 0x8000 == 0x8000)
      KeyRepeatCounter[key] = 0
      return true
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: typing? - Created by Yanfly
  #--------------------------------------------------------------------------
  def self.typing?
    return true if repeat?(SPACE)
    for i in 'A'..'Z'
      return true if repeat?(LETTERS[i])
    end
    for i in 0...NUMBERS.size
      return true if repeat?(NUMBERS[i])
      return true if repeat?(NUMPAD[i])
    end
    for key in Extras
      return true if repeat?(key)
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: key_type - Created by Yanfly
  #--------------------------------------------------------------------------
  def self.key_type
    return " " if repeat?(SPACE)
    for i in 'A'..'Z'
      next unless repeat?(LETTERS[i])
      return upcase? ? i.upcase : i.downcase
    end
    for i in 0...NUMBERS.size
      return i.to_s if repeat?(NUMPAD[i])
      if !press?(SHIFT)
        return i.to_s if repeat?(NUMBERS[i])
      elsif repeat?(NUMBERS[i])
        case i
        when 1; return "!"
        when 2; return "@"
        when 3; return "#"
        when 4; return "$"
        when 5; return "%"
        when 6; return "^"
        when 7; return "&"
        when 8; return "*"
        when 9; return "("
        when 0; return ")"
        end
      end
    end
    for key in Extras
      next unless repeat?(key)
      case key
      when USCORE; return press?(SHIFT) ? "_" : "-"
      when EQUALS; return press?(SHIFT) ? "+" : "="
      when LBRACE; return press?(SHIFT) ? "{" : "["
      when RBRACE; return press?(SHIFT) ? "}" : "]"
      when BSLASH; return press?(SHIFT) ? "|" : "\\"
      when SCOLON; return press?(SHIFT) ? ":" : ";"
      when QUOTE;  return press?(SHIFT) ? '"' : "'"
      when COMMA;  return press?(SHIFT) ? "<" : ","
      when PERIOD; return press?(SHIFT) ? ">" : "."
      when SLASH;  return press?(SHIFT) ? "?" : "/"
      when NMUL;   return "*"
      when NPLUS;  return "+"
      when NSEP;   return ","
      when NMINUS; return "-"
      when NDECI;  return "."
      when NDIV;   return "/"
      end
    end
    return ""
  end
  
  #--------------------------------------------------------------------------
  # new method: upcase? - Created by Yanfly
  #--------------------------------------------------------------------------
  def self.upcase?
    return !press?(SHIFT) if GetCapState.call(CAPS) == 1
    return true if press?(SHIFT)
    return false
  end
  
end # Input

#==============================================================================
# ■ SceneManager
#==============================================================================

module SceneManager
  
  #--------------------------------------------------------------------------
  # new method: self.force_recall
  #--------------------------------------------------------------------------
  def self.force_recall(scene_class)
    @scene = scene_class
  end
  
end # SceneManager

#==============================================================================
# ■ Sprite_DebugMap
#==============================================================================

class Sprite_DebugMap < Sprite_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(viewport, map_window)
    super(viewport)
    @map_window = map_window
    self.visible = false
    create_bitmap
  end
  
  #--------------------------------------------------------------------------
  # dispose
  #--------------------------------------------------------------------------
  def dispose
    self.bitmap.dispose unless self.bitmap.nil?
    super
  end
  
  #--------------------------------------------------------------------------
  # create_bitmap
  #--------------------------------------------------------------------------
  def create_bitmap
    bitmap = Bitmap.new(32, 32)
    bitmap.fill_rect(0, 0, 32, 32, Color.new(  0,   0,   0))
    bitmap.fill_rect(1, 1, 30, 30, Color.new(255, 255,   0))
    bitmap.fill_rect(2, 2, 28, 28, Color.new(  0,   0,   0))
    bitmap.clear_rect(Rect.new(3, 3, 26, 26))
    self.bitmap = bitmap
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    self.tone = Tone.new(255, 0, 0, 0) if @map_window.active
    self.tone = Tone.new(0, 0, 0, 0) unless @map_window.active
  end
  
end # Sprite_DebugMap

#==============================================================================
# ■ Scene_Base
#==============================================================================

class Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: update_basic
  #--------------------------------------------------------------------------
  alias scene_base_update_debug update
  def update
    scene_base_update_debug
    trigger_debug_window_entry
  end
  
  #--------------------------------------------------------------------------
  # new method: trigger_debug_window_entry
  #--------------------------------------------------------------------------
  def trigger_debug_window_entry
    return unless $TEST || $BTEST
    if Input.trigger?(Input::F10)
      Sound.play_ok
      process_debug_window_entry
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: process_debug_window_entry
  #--------------------------------------------------------------------------
  def process_debug_window_entry
    Graphics.freeze
    viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    viewport.z = 8000
    @debug_entry_window = Window_DebugEntry.new
    @debug_entry_window.viewport = viewport
    Graphics.transition(4)
    #---
    update_debug_window_entry
    #---
    Graphics.freeze
    @debug_entry_window.dispose
    @debug_entry_window = nil
    viewport.dispose
    Graphics.transition(4)
  end
  
  #--------------------------------------------------------------------------
  # new method: update_debug_window_entry
  #--------------------------------------------------------------------------
  def update_debug_window_entry
    loop do
      Graphics.update
      Input.update
      @debug_entry_window.update
      if Input.trigger?(Input::ESC)
        Sound.play_cancel
        if @debug_entry_window.text.size > 0
          @debug_entry_window.text = ""
        else
          break
        end
      elsif Input.trigger?(Input::F10)
        Sound.play_cancel
        break
      elsif Input.trigger?(Input::ENTER)
        code = @debug_entry_window.text
        begin
          eval(code)
          Sound.play_ok
          break
        rescue Exception => ex
          Sound.play_buzzer
        end
      end
    end
  end
  
end # Scene_Base

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: update_call_debug
  #--------------------------------------------------------------------------
  alias scene_map_update_call_debug_debug update_call_debug
  def update_call_debug
    return unless $TEST
    if Input.press?(:ALT)
      for key in YEA::DEBUG::ALT
        next unless Input.trigger?(key[0])
        next if key[1] <= 0
        $game_temp.reserve_common_event(key[1])
      end
    elsif Input.press?(:CTRL)
      for key in YEA::DEBUG::CTRL
        next unless Input.trigger?(key[0])
        next if key[1] <= 0
        $game_temp.reserve_common_event(key[1])
      end
    elsif Input.press?(:SHIFT)
      for key in YEA::DEBUG::SHIFT
        next unless Input.trigger?(key[0])
        next if key[1] <= 0
        $game_temp.reserve_common_event(key[1])
      end
    else
      scene_map_update_call_debug_debug
    end
  end
  
end # Scene_Map

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: update_basic
  #--------------------------------------------------------------------------
  alias scene_battle_update_basic_debug update_basic
  def update_basic
    scene_battle_update_basic_debug
    update_debug_input if $BTEST || $TEST
  end
  
  #--------------------------------------------------------------------------
  # new method: update_debug_input
  #--------------------------------------------------------------------------
  def update_debug_input
    return unless Input.trigger?(:F9)
    Graphics.freeze
    @info_viewport.visible = false
    SceneManager.snapshot_for_background
    #---
    SceneManager.call(Scene_Debug)
    SceneManager.scene.main
    SceneManager.force_recall(self)
    #---
    @info_viewport.visible = true
    @status_window.refresh
    perform_transition
  end
  
end # Scene_Battle

#==============================================================================
# ■ Window_DebugEntry
#==============================================================================

class Window_DebugEntry < Window_Base
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :text
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    dx = -standard_padding
    dy = Graphics.height - fitting_height(1) + standard_padding
    dw = Graphics.width + standard_padding * 2
    dh = fitting_height(1)
    super(dx, dy, dw, dh)
    contents.font.name = ["VL Gothic", "Courier New"]
    contents.font.bold = false
    contents.font.italic = false
    contents.font.shadow = false
    contents.font.outline = false
    contents.font.size = 20
    contents.font.color = Color.new(192, 192, 192)
    self.opacity = 0
    @text = ""
    @rect = Rect.new(4, 0, 8192, 24)
    refresh
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    cw = contents.width
    contents.fill_rect(0, 0, cw, line_height, Color.new(192, 192, 192))
    contents.fill_rect(1, 1, contents.width-2, line_height-2, Color.new(0, 0, 0))
    if @blink
      contents.draw_text(@rect, @text + "▂", 0)
    else
      contents.draw_text(@rect, @text, 0)
    end
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    @blink = !@blink if (Graphics.frame_count % 30 == 0)
    maximum = 256
    if Input.typing? && @text.size <= maximum
      @text += Input.key_type
    elsif Input.repeat?(Input::BACK) && @text.size > 0
      @text[@text.size - 1] = ""
    end
    refresh
  end
  
end # Window_DebugEntry

#==============================================================================
# ■ Window_DebugCommand
#==============================================================================

class Window_DebugCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize; super(0, 0); end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return 160; end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; return Graphics.height; end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    for command in YEA::DEBUG::COMMANDS
      case command[0]
      when :teleport, :battle
        next if $game_party.in_battle
      end
      add_command(command[1], command[0])
    end
  end
  
end # Window_DebugCommand

#==============================================================================
# ■ Window_DebugSwitch
#==============================================================================

class Window_DebugSwitch < Window_Command
  
  #--------------------------------------------------------------------------
  # initialize
  #-------------------------------------------------------------------------
  def initialize
    super(160, 0)
    deactivate
    hide
    refresh
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width - 160; end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; return Graphics.height - 120; end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    for i in 1...$data_system.switches.size
      name = $data_system.switches[i]
      text = sprintf("S%04d:%s", i, name)
      add_command(text, :switch, true, i)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    contents.clear_rect(item_rect_for_text(index))
    change_switch_colour(index)
    name = command_name(index)
    id = @list[index][:ext]
    if $game_switches[id] && $data_system.switches[id] == ""
      name = sprintf("S%04d:%s", id, "ATTENTION!")
    end
    draw_text(item_rect_for_text(index), name, 0)
    text = $game_switches[id] ? "[ON]" : "[OFF]"
    draw_text(item_rect_for_text(index), text, 2)
  end
  
  #--------------------------------------------------------------------------
  # change_switch_colour
  #--------------------------------------------------------------------------
  def change_switch_colour(index)
    id = @list[index][:ext]
    enabled = $data_system.switches[id] != ""
    colour = $game_switches[id] ? crisis_color : normal_color
    if $game_switches[id] && $data_system.switches[id] == ""
      colour = knockout_color
      enabled = true
    end
    change_color(colour, enabled)
  end
  
end # Window_DebugSwitch

#==============================================================================
# ■ Window_DebugVariable
#==============================================================================

class Window_DebugVariable < Window_Command
  
  #--------------------------------------------------------------------------
  # initialize
  #-------------------------------------------------------------------------
  def initialize
    super(160, 0)
    deactivate
    hide
    refresh
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width - 160; end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; return Graphics.height - 120; end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    for i in 1...$data_system.variables.size
      name = $data_system.variables[i]
      text = sprintf("V%04d:%s", i, name)
      add_command(text, :variable, true, i)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    contents.clear_rect(item_rect_for_text(index))
    change_variable_colour(index)
    name = command_name(index)
    id = @list[index][:ext]
    if $game_variables[id] != 0 && $data_system.variables[id] == ""
      name = sprintf("V%04d:%s", id, "ATTENTION!")
    end
    draw_text(item_rect_for_text(index), name, 0)
    text = $game_variables[id]
    text = text.group if text.is_a?(Integer)
    draw_text(item_rect_for_text(index), text, 2)
  end
  
  #--------------------------------------------------------------------------
  # change_switch_colour
  #--------------------------------------------------------------------------
  def change_variable_colour(index)
    id = @list[index][:ext]
    enabled = $data_system.variables[id] != ""
    colour = $game_variables[id] != 0 ? crisis_color : normal_color
    if $game_variables[id] != 0 && $data_system.variables[id] == ""
      colour = knockout_color
      enabled = true
    end
    change_color(colour, enabled)
  end
  
end # Window_DebugVariable

#==============================================================================
# ■ Window_DebugInput
#==============================================================================

class Window_DebugInput < Window_Selectable
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :value
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    dw = Graphics.width * 3 / 4
    dh = fitting_height(2)
    dx = (Graphics.width - dw) / 2
    dy = (Graphics.height - dh) / 2
    super(dx, dy, dw, dh)
    self.back_opacity = 255
    self.openness = 0
    @max_value =  99999999
    @min_value = -99999999
  end
  
  #--------------------------------------------------------------------------
  # col_max
  #--------------------------------------------------------------------------
  def col_max; return 9; end
  
  #--------------------------------------------------------------------------
  # item_max
  #--------------------------------------------------------------------------
  def item_max; return 9; end
  
  #--------------------------------------------------------------------------
  # horizontal?
  #--------------------------------------------------------------------------
  def horizontal?; return true; end
  
  #--------------------------------------------------------------------------
  # reveal
  #--------------------------------------------------------------------------
  def reveal(variable)
    @variable = variable
    @value = $game_variables[variable]
    @value = 0 unless @value.is_a?(Integer)
    open
    refresh
    activate
    select(8)
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    draw_variable_name
  end
  
  #--------------------------------------------------------------------------
  # draw_variable_name
  #--------------------------------------------------------------------------
  def draw_variable_name
    name = $data_system.variables[@variable]
    name = "ATTENTION" if name == ""
    text = sprintf("V%04d:%s", @variable, name)
    draw_text(4, 0, contents.width-8, line_height, text, 1)
  end
  
  #--------------------------------------------------------------------------
  # item_rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(0, line_height, 24, line_height)
    rect.x = (contents.width-32-24*col_max)/2+index*24+12
    return rect
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    contents.clear_rect(rect)
    if index == 0
      text = @value >= 0 ? "+" : "-"
    else
      text = @value.abs % 10**(col_max-index)/(10**(col_max-1-index))
    end
    contents.draw_text(rect.x, rect.y, rect.width, line_height, text, 1)
  end
  
  #--------------------------------------------------------------------------
  # cursor_down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    Sound.play_cursor
    @value = index == 0 ? @value * -1 : @value - 10**(col_max-1 - index)
    @value = [[@value, @max_value].min, @min_value].max
    draw_all_items
  end
  
  #--------------------------------------------------------------------------
  # cursor_up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    Sound.play_cursor
    @value = index == 0 ? @value * -1 : @value + 10**(col_max-1 - index)
    @value = [[@value, @max_value].min, @min_value].max
    draw_all_items
  end
  
end # Window_DebugInput

#==============================================================================
# ■ Window_DebugTeleport
#==============================================================================

class Window_DebugTeleport < Window_Command
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    @map_info = load_data("Data/MapInfos.rvdata2")
    deactivate
    refresh
    hide
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return 160; end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; return Graphics.height; end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    for i in 1..999
      filename = sprintf("Data/Map%03d.rvdata2", i)
      next unless FileTest.exist?(filename)
      add_command(sprintf("MAP:%03d", i), :map, true, i)
    end
  end
  
end # Window_DebugTeleport

#==============================================================================
# ■ Window_DebugShownMap
#==============================================================================

class Window_DebugShownMap < Window_Selectable
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(teleport_window)
    dy = fitting_height(2)
    @teleport_window = teleport_window
    super(160, dy, Graphics.width-160, Graphics.height-dy)
    self.back_opacity = 0
    hide
    create_tilemap
    create_bitmap
    update_shown_map(@teleport_window.current_ext)
  end
  
  #--------------------------------------------------------------------------
  # dispose
  #--------------------------------------------------------------------------
  def dispose
    dispose_tilemap
    super
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    @cursor_sprite.visible = self.visible
    @viewport.visible = self.visible
    return unless @teleport_window.visible
    update_shown_map(@teleport_window.current_ext)
    update_tilemap
  end
  
  #--------------------------------------------------------------------------
  # create_tilemap
  #--------------------------------------------------------------------------
  def create_tilemap
    @viewport = Viewport.new(self.x, self.y, self.width, self.height)
    @viewport.z = self.z - 1
    @viewport.visible = false
    @tilemap = Tilemap.new(@viewport)
  end
  
  #--------------------------------------------------------------------------
  # create_bitmap
  #--------------------------------------------------------------------------
  def create_bitmap
    @cursor_sprite = Sprite_DebugMap.new(@viewport, self)
    @cursor_sprite.z = @viewport.z + 1000
    @cursor_sprite.x = (self.width - 32) / 2
    @cursor_sprite.y = (self.height - 32) / 2
  end
  
  #--------------------------------------------------------------------------
  # update_shown_map
  #--------------------------------------------------------------------------
  def update_shown_map(map_id)
    return if @map_id == map_id
    @map_id = map_id
    @map = load_data(sprintf("Data/Map%03d.rvdata2", @map_id))
    @tileset = $data_tilesets[@map.tileset_id]
    @tileset.tileset_names.each_with_index do |name, i|
      @tilemap.bitmaps[i] = Cache.tileset(name)
    end
    @tilemap.flags = @tileset.flags
    @tilemap.map_data = @map.data
    recalculate_coordinates
  end
  
  #--------------------------------------------------------------------------
  # recalculate_coordinates
  #--------------------------------------------------------------------------
  def recalculate_coordinates
    @tilemap.ox = (@map.width * 32 - self.width) / 2
    @tilemap.oy = (@map.height * 32 - self.height) / 2
    @tilemap.ox -= 16 if @map.width % 2 == 0
    @tilemap.oy -= 16 if @map.height % 2 == 0
    @map_x = @map.width / 2
    @map_y = @map.height / 2
    @map_x -= 1 if @map.width % 2 == 0
    @map_y -= 1 if @map.height % 2 == 0
  end
  
  #--------------------------------------------------------------------------
  # map_x
  #--------------------------------------------------------------------------
  def map_x
    return @map_x % @map.width
  end
  
  #--------------------------------------------------------------------------
  # map_y
  #--------------------------------------------------------------------------
  def map_y
    return @map_y % @map.height
  end
  
  #--------------------------------------------------------------------------
  # dispose_tilemap
  #--------------------------------------------------------------------------
  def dispose_tilemap
    @tilemap.dispose
    @cursor_sprite.dispose
    @viewport.dispose
  end
  
  #--------------------------------------------------------------------------
  # update_tilemap
  #--------------------------------------------------------------------------
  def update_tilemap
    @tilemap.update
    @cursor_sprite.update
    @viewport.update
  end
  
  #--------------------------------------------------------------------------
  # update_cursor
  #--------------------------------------------------------------------------
  def update_cursor
    return
  end
  
  #--------------------------------------------------------------------------
  # cursor_movable?
  #--------------------------------------------------------------------------
  def cursor_movable?
    return self.active
  end
  
  #--------------------------------------------------------------------------
  # cursor_down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    Sound.play_cursor
    @tilemap.oy += Input.press?(:SHIFT) ? 320 : 32
    @tilemap.oy += Input.press?(:CTRL) ? 1568 : 0
    @map_y += Input.press?(:SHIFT) ? 10 : 1
    @map_y += Input.press?(:CTRL) ? 49 : 0
  end
  
  #--------------------------------------------------------------------------
  # cursor_up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    Sound.play_cursor
    @tilemap.oy -= Input.press?(:SHIFT) ? 320 : 32
    @tilemap.oy -= Input.press?(:CTRL) ? 1568 : 0
    @map_y -= Input.press?(:SHIFT) ? 10 : 1
    @map_y -= Input.press?(:CTRL) ? 49 : 0
  end
  
  #--------------------------------------------------------------------------
  # cursor_right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    Sound.play_cursor
    @tilemap.ox += Input.press?(:SHIFT) ? 320 : 32
    @tilemap.ox += Input.press?(:CTRL) ? 1568 : 0
    @map_x += Input.press?(:SHIFT) ? 10 : 1
    @map_x += Input.press?(:CTRL) ? 49 : 0
  end
  
  #--------------------------------------------------------------------------
  # cursor_left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    Sound.play_cursor
    @tilemap.ox -= Input.press?(:SHIFT) ? 320 : 32
    @tilemap.ox -= Input.press?(:CTRL) ? 1568 : 0
    @map_x -= Input.press?(:SHIFT) ? 10 : 1
    @map_x -= Input.press?(:CTRL) ? 49 : 0
  end
  
end # Window_DebugShownMap

#==============================================================================
# ■ Window_DebugMapHeader
#==============================================================================

class Window_DebugMapHeader < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(teleport_window, map_window)
    @teleport_window = teleport_window
    @map_window = map_window
    super(160, 0, Graphics.width - 160, fitting_height(2))
    @map_info = load_data("Data/MapInfos.rvdata2")
    @map_id = 0
    @map_x = 0
    @map_y = 0
    hide
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    update_header(@teleport_window.current_ext) if @teleport_window.visible
    update_coordinates if @map_window.active
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update_header(map_id)
    return if @map_id == map_id
    update_data
    refresh
  end
  
  #--------------------------------------------------------------------------
  # update_coordinates
  #--------------------------------------------------------------------------
  def update_coordinates
    return if @map_window.map_x == @map_x && @map_window.map_y == @map_y
    update_data
    refresh
  end
  
  #--------------------------------------------------------------------------
  # update_data
  #--------------------------------------------------------------------------
  def update_data
    @map_id = @teleport_window.current_ext
    @map_x = @map_window.map_x
    @map_y = @map_window.map_y
    @map_data = map = load_data(sprintf("Data/Map%03d.rvdata2", @map_id))
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_map_name
    draw_map_coordinates
  end
  
  #--------------------------------------------------------------------------
  # draw_map_name
  #--------------------------------------------------------------------------
  def draw_map_name
    return if @map_info[@map_id].nil?
    draw_text(4, 0, contents.width-8, line_height, @map_info[@map_id].name, 1)
  end
  
  #--------------------------------------------------------------------------
  # draw_map_coordinates
  #--------------------------------------------------------------------------
  def draw_map_coordinates
    dw = contents.width / 4
    dy = line_height
    #---
    dx = contents.width * 0 / 4
    text = sprintf("MAP:%03d", @map_id)
    draw_text(dx, dy, dw, line_height, text, 1)
    #---
    dx = contents.width * 1 / 4
    text = sprintf("X:%03d", @map_x)
    draw_text(dx, dy, dw, line_height, text, 1)
    #---
    dx = contents.width * 2 / 4
    text = sprintf("Y:%03d", @map_y)
    draw_text(dx, dy, dw, line_height, text, 1)
    #---
    dx = contents.width * 3 / 4
    text = sprintf("%d×%d", @map_data.width, @map_data.height)
    draw_text(dx, dy, dw, line_height, text, 1)
    #---
  end
  
end # Window_DebugMapHeader

#==============================================================================
# ■ Window_DebugBattle
#==============================================================================

class Window_DebugBattle < Window_Command
  
  #--------------------------------------------------------------------------
  # initialize
  #-------------------------------------------------------------------------
  def initialize
    super(160, 0)
    deactivate
    hide
    refresh
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width - 160; end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; return Graphics.height - 120; end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    for i in 1...$data_troops.size
      name = $data_troops[i].name
      text = sprintf("B%03d:%s", i, name)
      add_command(text, :battle, true, i)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    contents.clear_rect(item_rect_for_text(index))
    name = command_name(index)
    draw_text(item_rect_for_text(index), name, 0)
  end
  
end # Window_DebugBattle

#==============================================================================
# ■ Window_DebugCommonEvent
#==============================================================================

class Window_DebugCommonEvent < Window_Command
  
  #--------------------------------------------------------------------------
  # initialize
  #-------------------------------------------------------------------------
  def initialize
    super(160, 0)
    deactivate
    hide
    refresh
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width - 160; end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; return Graphics.height - 120; end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    for i in 1...$data_common_events.size
      name = $data_common_events[i].name
      text = sprintf("E%03d:%s", i, name)
      add_command(text, :event, true, i)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    contents.clear_rect(item_rect_for_text(index))
    name = command_name(index)
    draw_text(item_rect_for_text(index), name, 0)
  end
  
end # Window_DebugCommonEvent

#==============================================================================
# ■ Window_DebugItem
#==============================================================================

class Window_DebugItem < Window_Command
  
  #--------------------------------------------------------------------------
  # initialize
  #-------------------------------------------------------------------------
  def initialize
    super(160, 0)
    deactivate
    hide
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width - 160; end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; return Graphics.height - 120; end
  
  #--------------------------------------------------------------------------
  # set_type
  #--------------------------------------------------------------------------
  def set_type(type)
    @type = type
    refresh
    select(0)
  end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    case @type
    when :items
      group = $data_items
      fmt = "I%03d:"
    when :weapons
      group = $data_weapons
      fmt = "W%03d:"
    else
      group = $data_armors
      fmt = "A%03d:"
    end
    for i in 1...group.size
      text = sprintf(fmt, i)
      add_command(text, :item, true, group[i])
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    contents.clear_rect(item_rect_for_text(index))
    rect = item_rect_for_text(index)
    item = @list[index][:ext]
    name = item.name
    change_color(normal_color, $game_party.item_number(item) > 0)
    if $game_party.item_number(item) > 0 && item.name == ""
      change_color(knockout_color) 
      name = "ATTENTION!"
    end
    draw_text(rect, command_name(index))
    rect.x += text_size(command_name(index)).width
    rect.width -= text_size(command_name(index)).width
    draw_icon(item.icon_index, rect.x, rect.y, $game_party.item_number(item) > 0)
    rect.x += 24
    rect.width -= 24
    draw_text(rect, name)
    text = sprintf("×%s", $game_party.item_number(item).group)
    draw_text(rect, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # cursor_right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    Sound.play_cursor
    $game_party.gain_item(current_ext, Input.press?(:SHIFT) ? 10 : 1)
    $game_party.gain_item(current_ext, Input.press?(:CTRL) ? 99 : 0)
    draw_item(index)
  end
  
  #--------------------------------------------------------------------------
  # cursor_left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    Sound.play_cursor
    $game_party.lose_item(current_ext, Input.press?(:SHIFT) ? 10 : 1)
    $game_party.lose_item(current_ext, Input.press?(:CTRL) ? 99 : 0)
    draw_item(index)
  end
  
end # Window_DebugItem

#==============================================================================
# ■ Scene_Debug
#==============================================================================

class Scene_Debug < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # overwrite method: start
  #--------------------------------------------------------------------------
  def start
    super
    create_all_windows
  end
  
  #--------------------------------------------------------------------------
  # new method: update
  #--------------------------------------------------------------------------
  def update
    super
    return_scene if Input.trigger?(:F9)
  end
  
  #--------------------------------------------------------------------------
  # new method: create_all_windows
  #--------------------------------------------------------------------------
  def create_all_windows
    create_command_window
    create_help_window
    create_dummy_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_command_window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_DebugCommand.new
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.set_handler(:switches, method(:command_switches))
    @command_window.set_handler(:variables, method(:command_variables))
    @command_window.set_handler(:teleport, method(:command_teleport))
    @command_window.set_handler(:battle, method(:command_battle))
    @command_window.set_handler(:events, method(:command_common_event))
    @command_window.set_handler(:items, method(:command_items))
    @command_window.set_handler(:weapons, method(:command_items))
    @command_window.set_handler(:armours, method(:command_items))
  end
  
  #--------------------------------------------------------------------------
  # new method: create_help_window
  #--------------------------------------------------------------------------
  def create_help_window
    wx = @command_window.width
    wy = Graphics.height - 120
    ww = Graphics.width - wx
    wh = 120
    @help_window = Window_Base.new(wx, wy, ww, wh)
  end
  
  #--------------------------------------------------------------------------
  # new method: create_dummy_window
  #--------------------------------------------------------------------------
  def create_dummy_window
    wx = @command_window.width
    ww = Graphics.width - wx
    wh = Graphics.height - @help_window.height
    @dummy_window = Window_Base.new(wx, 0, ww, wh)
  end
  
  #--------------------------------------------------------------------------
  # new method: create_switch_window
  #--------------------------------------------------------------------------
  def create_switch_window
    @switch_window = Window_DebugSwitch.new
    @switch_window.set_handler(:ok, method(:on_switch_ok))
    @switch_window.set_handler(:cancel, method(:on_switch_cancel))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_switches
  #--------------------------------------------------------------------------
  def command_switches
    create_switch_window if @switch_window == nil
    @dummy_window.hide
    @switch_window.show
    @switch_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: on_switch_ok
  #--------------------------------------------------------------------------
  def on_switch_ok
    @switch_window.activate
    switch_id = @switch_window.current_ext
    $game_switches[switch_id] = !$game_switches[switch_id]
    @switch_window.draw_item(@switch_window.index)
  end
  
  #--------------------------------------------------------------------------
  # new method: on_switch_cancel
  #--------------------------------------------------------------------------
  def on_switch_cancel
    @dummy_window.show
    @switch_window.hide
    @command_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_variable_window
  #--------------------------------------------------------------------------
  def create_variable_window
    @variable_window = Window_DebugVariable.new
    @variable_window.set_handler(:ok, method(:on_variable_ok))
    @variable_window.set_handler(:cancel, method(:on_variable_cancel))
    @input_window = Window_DebugInput.new
    @input_window.set_handler(:ok, method(:on_input_ok))
    @input_window.set_handler(:cancel, method(:on_input_cancel))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_variables
  #--------------------------------------------------------------------------
  def command_variables
    create_variable_window if @variable_window == nil
    @dummy_window.hide
    @variable_window.show
    @variable_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: on_variable_ok
  #--------------------------------------------------------------------------
  def on_variable_ok
    @input_window.reveal(@variable_window.current_ext)
  end
  
  #--------------------------------------------------------------------------
  # new method: on_variable_cancel
  #--------------------------------------------------------------------------
  def on_variable_cancel
    @dummy_window.show
    @variable_window.hide
    @command_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: on_input_ok
  #--------------------------------------------------------------------------
  def on_input_ok
    $game_variables[@variable_window.current_ext] = @input_window.value
    @input_window.close
    @input_window.deactivate
    @variable_window.activate
    @variable_window.draw_item(@variable_window.index)
  end
  
  #--------------------------------------------------------------------------
  # new method: on_input_cancel
  #--------------------------------------------------------------------------
  def on_input_cancel
    @input_window.close
    @input_window.deactivate
    @variable_window.activate
  end
  
  #--------------------------------------------------------------------------
  # new method: create_teleport_windows
  #--------------------------------------------------------------------------
  def create_teleport_windows
    @teleport_window = Window_DebugTeleport.new
    @teleport_window.set_handler(:ok, method(:on_teleport_ok))
    @teleport_window.set_handler(:cancel, method(:on_teleport_cancel))
    @map_window = Window_DebugShownMap.new(@teleport_window)
    wx = @map_window.x
    wy = @map_window.y
    ww = @map_window.width
    wh = @map_window.height
    @map_dummy = Window_Base.new(wx, wy, ww, wh)
    @map_dummy.z = @map_window.z - 2
    @map_dummy.hide
    @teleport_header = Window_DebugMapHeader.new(@teleport_window, @map_window)
    @map_window.set_handler(:ok, method(:on_map_ok))
    @map_window.set_handler(:cancel, method(:on_map_cancel))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_teleport
  #--------------------------------------------------------------------------
  def command_teleport
    create_teleport_windows if @teleport_window == nil
    @command_window.hide
    @dummy_window.hide
    @help_window.hide
    @teleport_header.show
    @map_window.show
    @map_dummy.show
    @teleport_window.show
    @teleport_window.activate
  end
  
  #--------------------------------------------------------------------------
  # new method: on_teleport_ok
  #--------------------------------------------------------------------------
  def on_teleport_ok
    @map_window.activate
  end
  
  #--------------------------------------------------------------------------
  # new method: on_teleport_cancel
  #--------------------------------------------------------------------------
  def on_teleport_cancel
    @teleport_window.hide
    @teleport_header.hide
    @map_window.hide
    @map_dummy.hide
    @dummy_window.show
    @help_window.show
    @command_window.show
    @command_window.activate
  end
  
  #--------------------------------------------------------------------------
  # new method: on_map_ok
  #--------------------------------------------------------------------------
  def on_map_ok
    map_id = @teleport_window.current_ext
    map_x = @map_window.map_x
    map_y = @map_window.map_y
    direction = $game_player.direction
    $game_player.reserve_transfer(map_id, map_x, map_y, direction)
    return_scene
  end
  
  #--------------------------------------------------------------------------
  # new method: on_map_cancel
  #--------------------------------------------------------------------------
  def on_map_cancel
    @teleport_window.activate
  end
  
  #--------------------------------------------------------------------------
  # new method: create_battle_windows
  #--------------------------------------------------------------------------
  def create_battle_windows
    @battle_window = Window_DebugBattle.new
    @battle_window.set_handler(:ok, method(:on_battle_ok))
    @battle_window.set_handler(:cancel, method(:on_battle_cancel))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_battle
  #--------------------------------------------------------------------------
  def command_battle
    create_battle_windows if @battle_window == nil
    @dummy_window.hide
    @battle_window.show
    @battle_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: on_battle_ok
  #--------------------------------------------------------------------------
  def on_battle_ok
    troop_id = @battle_window.current_ext
    BattleManager.setup(troop_id)
    BattleManager.on_encounter
    SceneManager.call(Scene_Battle)
    BattleManager.save_bgm_and_bgs
    BattleManager.play_battle_bgm
    Sound.play_battle_start
  end
  
  #--------------------------------------------------------------------------
  # new method: on_battle_cancel
  #--------------------------------------------------------------------------
  def on_battle_cancel
    @dummy_window.show
    @battle_window.hide
    @command_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_common_event_windows
  #--------------------------------------------------------------------------
  def create_common_event_windows
    @event_window = Window_DebugCommonEvent.new
    @event_window.set_handler(:ok, method(:on_event_ok))
    @event_window.set_handler(:cancel, method(:on_event_cancel))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_common_event
  #--------------------------------------------------------------------------
  def command_common_event
    create_common_event_windows if @event_window == nil
    @dummy_window.hide
    @event_window.show
    @event_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: on_event_ok
  #--------------------------------------------------------------------------
  def on_event_ok
    event_id = @event_window.current_ext
    $game_temp.reserve_common_event(event_id)
    return_scene
  end
  
  #--------------------------------------------------------------------------
  # new method: on_event_cancel
  #--------------------------------------------------------------------------
  def on_event_cancel
    @dummy_window.show
    @event_window.hide
    @command_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_item_windows
  #--------------------------------------------------------------------------
  def create_item_windows
    @item_window = Window_DebugItem.new
    @item_window.set_handler(:cancel, method(:on_item_cancel))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_items
  #--------------------------------------------------------------------------
  def command_items
    create_item_windows if @item_window == nil
    @dummy_window.hide
    @item_window.show
    @item_window.activate
    @item_window.set_type(@command_window.current_symbol)
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: on_item_cancel
  #--------------------------------------------------------------------------
  def on_item_cancel
    @dummy_window.show
    @item_window.hide
    @command_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: refresh_help_window
  #--------------------------------------------------------------------------
  def refresh_help_window
    if @command_window.active
      text  = ""
    else
      case @command_window.current_symbol
      when :switches
        text  = "Adjust switches.\n"
        text += "Press Z to toggle switch.\n"
        text += "Yellow switches are on and named.\n"
        text += "Red switches are on but are unnamed."
      when :variables
        text  = "Adjust variables.\n"
        text += "Press Z to modify variable.\n"
        text += "Yellow aren't 0 and named.\n"
        text += "Red aren't 0 and are unnamed."
      when :battle
        text  = "Test Battles.\n"
        text += "Select a battle and press Z.\n"
        text += "These battles are all found\n"
        text += "within the database."
      when :events
        text  = "Test Common Events.\n"
        text += "Select an event and press Z.\n"
        text += "You will automatically be taken\n"
        text += "to previous scene to run event."
      when :items
        text  = "Adjust items.\n"
        text += "Press Left/Right to lose/gain.\n"
        text += "Hold SHIFT for increments of 10.\n"
        text += "Hold CTRL for increments of 100."
      when :weapons
        text  = "Adjust weapons.\n"
        text += "Press Left/Right to lose/gain.\n"
        text += "Hold SHIFT for increments of 10.\n"
        text += "Hold CTRL for increments of 100."
      when :armours
        text  = "Adjust armours.\n"
        text += "Press Left/Right to lose/gain.\n"
        text += "Hold SHIFT for increments of 10.\n"
        text += "Hold CTRL for increments of 100."
      else
        text  = ""
      end
    end
    @help_window.contents.clear
    @help_window.draw_text_ex(4, 0, text)
  end
  
end # Scene_Debug

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================
