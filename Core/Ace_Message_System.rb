#==============================================================================
# 
# ▼ Yanfly Engine Ace - Ace Message System v1.05
# -- Last Updated: 2012.01.13
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-MessageSystem"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.07.21 - Fixed REGEXP error at line 824
# 2012.01.13 - Bug Fixed: Negative tags didn't display other party members.
# 2012.01.12 - Compatibility Update: Message Actor Codes
# 2012.01.10 - Added Feature: \pic[x] text code.
# 2012.01.04 - Bug Fixed: \ic tag was \ii. No longer the case.
#            - Added: Scroll Text window now uses message window font.
# 2011.12.31 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# While RPG Maker VX Ace certainly improved the message system a whole lot, it
# wouldn't hurt to add in a few more features, such as name windows, converting
# textcodes to write out the icons and/or names of items, weapons, armours, and
# more in quicker fashion. This script also gives the developer the ability to
# adjust the size of the message window during the game, give it a separate
# font, and to give the player a text fast-forward feature.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Message Window text Codes - These go inside of your message window.
# -----------------------------------------------------------------------------
#  Default:    Effect:
#    \v[x]     - Writes variable x's value.
#    \n[x]     - Writes actor x's name.
#    \p[x]     - Writes party member x's name.
#    \g        - Writes gold currency name.
#    \c[x]     - Changes the colour of the text to x.
#    \i[x]     - Draws icon x at position of the text.
#    \{        - Makes text bigger by 8 points.
#    \}        - Makes text smaller by 8 points.
#    \$        - Opens gold window.
#    \.        - Waits 15 frames (quarter second).
#    \|        - Waits 60 frames (a full second).
#    \!        - Waits until key is pressed.
#    \>        - Following text is instant.
#    \<        - Following text is no longer instant.
#    \^        - Skips to the next message.
#    \\        - Writes a "\" in the window.
# 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 
#  Wait:       Effect:
#    \w[x]     - Waits x frames (60 frames = 1 second). Message window only.
# 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 
#  NameWindow: Effect:
#    \n<x>     - Creates a name box with x string. Left side. *Note
#    \nc<x>    - Creates a name box with x string. Centered. *Note
#    \nr<x>    - Creates a name box with x string. Right side. *Note
# 
#              *Note: Works for message window only.
# 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 
#  Position:   Effect:
#    \px[x]    - Sets x position of text to x.
#    \py[x]    - Sets y position of text to y.
# 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 
#  Picture:    Effect:
#    \pic[x]   - Draws picture x from the Graphics\Pictures folder.
# 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 
#  Outline:    Effect:
#    \oc[x]    - Sets outline colour to x.
#    \oo[x]    - Sets outline opacity to x.
# 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 
#  Font:       Effect:
#    \fr       - Resets all font changes.
#    \fz[x]    - Changes font size to x.
#    \fn[x]    - Changes font name to x.
#    \fb       - Toggles font boldness.
#    \fi       - Toggles font italic.
#    \fo       - Toggles font outline.
#    \fs       - Toggles font shadow.
# 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 
#  Actor:      Effect:
#    \af[x]    - Shows face of actor x. *Note
#    \ac[x]    - Writes out actor's class name. *Note
#    \as[x]    - Writes out actor's subclass name. Req: Class System. *Note
#    \an[x]    - Writes out actor's nickname. *Note
# 
#              *Note: If x is 0 or negative, it will show the respective
#               party member's face instead.
#                   0 - Party Leader
#                  -1 - 1st non-leader member.
#                  -2 - 2nd non-leader member. So on.
# 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 
#  Names:      Effect:
#    \nc[x]    - Writes out class x's name.
#    \ni[x]    - Writes out item x's name.
#    \nw[x]    - Writes out weapon x's name.
#    \na[x]    - Writes out armour x's name.
#    \ns[x]    - Writes out skill x's name.
#    \nt[x]    - Writes out state x's name.
# 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 
#  Icon Names: Effect:
#    \ic[x]    - Writes out class x's name including icon. *
#    \ii[x]    - Writes out item x's name including icon.
#    \iw[x]    - Writes out weapon x's name including icon.
#    \ia[x]    - Writes out armour x's name including icon.
#    \is[x]    - Writes out skill x's name including icon.
#    \it[x]    - Writes out state x's name including icon.
# 
#              *Note: Requires YEA - Class System
# 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 
# And those are the text codes added with this script. Keep in mind that some
# of these text codes only work for the Message Window. Otherwise, they'll work
# for help descriptions, actor biographies, and others.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module MESSAGE
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Message Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # The following below will adjust the basic settings and that will affect
    # the majority of the script. Adjust them as you see fit.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This button is the button used to make message windows instantly skip
    # forward. Hold down for the effect. Note that when held down, this will
    # speed up the messages, but still wait for the pauses. However, it will
    # automatically go to the next page when prompted.
    TEXT_SKIP = :A     # Input::A is the shift button on keyboard.
    
    # This variable adjusts the number of visible rows shown in the message
    # window. If you do not wish to use this feature, set this constant to 0.
    # If the row value is 0 or below, it will automatically default to 4 rows.
    VARIABLE_ROWS  = 21
    
    # This variable adjusts the width of the message window shown. If you do
    # not wish to use this feature, set this constant to 0. If the width value
    # is 0 or below, it will automatically default to the screen width.
    VARIABLE_WIDTH = 22
    
    # This is the amount of space that the message window will indent whenever
    # a face is used. Default: 112
    FACE_INDENT_X = 112
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Name Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # The name window is a window that appears outside of the main message
    # window box to display whatever text is placed inside of it like a name.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    NAME_WINDOW_X_BUFFER = -20     # Buffer x position of the name window.
    NAME_WINDOW_Y_BUFFER = 0       # Buffer y position of the name window.
    NAME_WINDOW_PADDING  = 20      # Padding added to the horizontal position.
    NAME_WINDOW_OPACITY  = 255     # Opacity of the name window.
    NAME_WINDOW_COLOUR   = 6       # Text colour used by default for names.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Message Font Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Ace Message System separates the in-game system font form the message
    # font. Adjust the settings here for your fonts.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This array constant determines the fonts used. If the first font does not
    # exist on the player's computer, the next font in question will be used
    # in place instead and so on.
    MESSAGE_WINDOW_FONT_NAME = ["Verdana", "Arial", "Courier New"]
    
    # These adjust the other settings regarding the way the game font appears
    # including the font size, whether or not the font is bolded by default,
    # italic by default, etc.
    MESSAGE_WINDOW_FONT_SIZE    = 24       # Font size.
    MESSAGE_WINDOW_FONT_BOLD    = false    # Default bold?
    MESSAGE_WINDOW_FONT_ITALIC  = false    # Default italic?
    MESSAGE_WINDOW_FONT_OUTLINE = true     # Default outline?
    MESSAGE_WINDOW_FONT_SHADOW  = false    # Default shadow?
    
  end # MESSAGE
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Variable
#==============================================================================

module Variable
  
  #--------------------------------------------------------------------------
  # self.message_rows
  #--------------------------------------------------------------------------
  def self.message_rows
    return 4 if YEA::MESSAGE::VARIABLE_ROWS <= 0
    return 4 if $game_variables[YEA::MESSAGE::VARIABLE_ROWS] <= 0
    return $game_variables[YEA::MESSAGE::VARIABLE_ROWS]
  end
  
  #--------------------------------------------------------------------------
  # self.message_width
  #--------------------------------------------------------------------------
  def self.message_width
    return Graphics.width if YEA::MESSAGE::VARIABLE_WIDTH <= 0
    return Graphics.width if $game_variables[YEA::MESSAGE::VARIABLE_WIDTH] <= 0
    return $game_variables[YEA::MESSAGE::VARIABLE_WIDTH]
  end
  
end # Variable

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # overwrite method: command_101
  #--------------------------------------------------------------------------
  def command_101
    wait_for_message
    $game_message.face_name = @params[0]
    $game_message.face_index = @params[1]
    $game_message.background = @params[2]
    $game_message.position = @params[3]
    while continue_message_string?
      @index += 1
      if @list[@index].code == 401
        $game_message.add(@list[@index].parameters[0])
      end
      break if $game_message.texts.size >= Variable.message_rows
    end
    case next_event_code
    when 102
      @index += 1
      setup_choices(@list[@index].parameters)
    when 103
      @index += 1
      setup_num_input(@list[@index].parameters)
    when 104
      @index += 1
      setup_item_choice(@list[@index].parameters)
    end
    wait_for_message
  end
  
  #--------------------------------------------------------------------------
  # new method: continue_message_string?
  #--------------------------------------------------------------------------
  def continue_message_string?
    return true if next_event_code == 101 && Variable.message_rows > 4
    return next_event_code == 401
  end
  
end # Game_Interpreter

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
  
  #--------------------------------------------------------------------------
  # new method: setup_message_font
  #--------------------------------------------------------------------------
  def setup_message_font
    @message_font = true
    change_color(normal_color)
    contents.font.out_color = Font.default_out_color
    contents.font.name = YEA::MESSAGE::MESSAGE_WINDOW_FONT_NAME
    contents.font.size = YEA::MESSAGE::MESSAGE_WINDOW_FONT_SIZE
    contents.font.bold = YEA::MESSAGE::MESSAGE_WINDOW_FONT_BOLD
    contents.font.italic = YEA::MESSAGE::MESSAGE_WINDOW_FONT_ITALIC
    contents.font.outline = YEA::MESSAGE::MESSAGE_WINDOW_FONT_OUTLINE
    contents.font.shadow = YEA::MESSAGE::MESSAGE_WINDOW_FONT_SHADOW
  end
  
  #--------------------------------------------------------------------------
  # alias method: reset_font_settings
  #--------------------------------------------------------------------------
  alias window_base_reset_font_settings_ams reset_font_settings
  def reset_font_settings
    if @message_font
      setup_message_font
    else
      window_base_reset_font_settings_ams
      contents.font.out_color = Font.default_out_color
      contents.font.outline = Font.default_outline
      contents.font.shadow = Font.default_shadow
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: convert_escape_characters
  #--------------------------------------------------------------------------
  alias window_base_convert_escape_characters_ams convert_escape_characters
  def convert_escape_characters(text)
    result = window_base_convert_escape_characters_ams(text)
    result = convert_ace_message_system_new_escape_characters(result)
    return result
  end
  
  #--------------------------------------------------------------------------
  # new method: convert_ace_message_system_new_escape_characters
  #--------------------------------------------------------------------------
  def convert_ace_message_system_new_escape_characters(result)
    #---
    result.gsub!(/\eFR/i) { "\eAMSF[0]" }
    result.gsub!(/\eFB/i) { "\eAMSF[1]" }
    result.gsub!(/\eFI/i) { "\eAMSF[2]" }
    result.gsub!(/\eFO/i) { "\eAMSF[3]" }
    result.gsub!(/\eFS/i) { "\eAMSF[4]" }
    #---
    result.gsub!(/\eAC\[([-+]?\d+)\]/i) { escape_actor_class_name($1.to_i) }
    result.gsub!(/\eAS\[([-+]?\d+)\]/i) { escape_actor_subclass_name($1.to_i) }
    result.gsub!(/\eAN\[([-+]?\d+)\]/i) { escape_actor_nickname($1.to_i) }
    #---
    result.gsub!(/\eNC\[(\d+)\]/i) { $data_classes[$1.to_i].name }
    result.gsub!(/\eNI\[(\d+)\]/i) { $data_items[$1.to_i].name }
    result.gsub!(/\eNW\[(\d+)\]/i) { $data_weapons[$1.to_i].name }
    result.gsub!(/\eNA\[(\d+)\]/i) { $data_armors[$1.to_i].name }
    result.gsub!(/\eNS\[(\d+)\]/i) { $data_skills[$1.to_i].name }
    result.gsub!(/\eNT\[(\d+)\]/i) { $data_states[$1.to_i].name }
    #---
    result.gsub!(/\eIC\[(\d+)\]/i) { escape_icon_item($1.to_i, :class) }
    result.gsub!(/\eII\[(\d+)\]/i) { escape_icon_item($1.to_i, :item) }
    result.gsub!(/\eIW\[(\d+)\]/i) { escape_icon_item($1.to_i, :weapon) }
    result.gsub!(/\eIA\[(\d+)\]/i) { escape_icon_item($1.to_i, :armour) }
    result.gsub!(/\eIS\[(\d+)\]/i) { escape_icon_item($1.to_i, :skill) }
    result.gsub!(/\eIT\[(\d+)\]/i) { escape_icon_item($1.to_i, :state) }
    #---
    return result
  end
  
  #--------------------------------------------------------------------------
  # new method: escape_actor_class_name
  #--------------------------------------------------------------------------
  def escape_actor_class_name(actor_id)
    actor_id = $game_party.members[actor_id.abs].id if actor_id <= 0
    actor = $game_actors[actor_id]
    return "" if actor.nil?
    return actor.class.name
  end
  
  #--------------------------------------------------------------------------
  # new method: actor_subclass_name
  #--------------------------------------------------------------------------
  def escape_actor_subclass_name(actor_id)
    return "" unless $imported["YEA-ClassSystem"]
    actor_id = $game_party.members[actor_id.abs].id if actor_id <= 0
    actor = $game_actors[actor_id]
    return "" if actor.nil?
    return "" if actor.subclass.nil?
    return actor.subclass.name
  end
  
  #--------------------------------------------------------------------------
  # new method: escape_actor_nickname
  #--------------------------------------------------------------------------
  def escape_actor_nickname(actor_id)
    actor_id = $game_party.members[actor_id.abs].id if actor_id <= 0
    actor = $game_actors[actor_id]
    return "" if actor.nil?
    return actor.nickname
  end
  
  #--------------------------------------------------------------------------
  # new method: escape_icon_item
  #--------------------------------------------------------------------------
  def escape_icon_item(data_id, type)
    case type
    when :class
      return "" unless $imported["YEA-ClassSystem"]
      icon = $data_classes[data_id].icon_index
      name = $data_items[data_id].name
    when :item
      icon = $data_items[data_id].icon_index
      name = $data_items[data_id].name
    when :weapon
      icon = $data_weapons[data_id].icon_index
      name = $data_weapons[data_id].name
    when :armour
      icon = $data_armors[data_id].icon_index
      name = $data_armors[data_id].name
    when :skill
      icon = $data_skills[data_id].icon_index
      name = $data_skills[data_id].name
    when :state
      icon = $data_states[data_id].icon_index
      name = $data_states[data_id].name
    else; return ""
    end
    text = "\eI[#{icon}]" + name
    return text
  end
  
  #--------------------------------------------------------------------------
  # alias method: process_escape_character
  #--------------------------------------------------------------------------
  alias window_base_process_escape_character_ams process_escape_character
  def process_escape_character(code, text, pos)
    case code.upcase
    #---
    when 'FZ'
      contents.font.size = obtain_escape_param(text)
    when 'FN'
      text.sub!(/\[(.*?)\]/, "")
      font_name = $1.to_s
      font_name = Font.default_name if font_name.nil?
      contents.font.name = font_name.to_s
    #---
    when 'OC'
      colour = text_color(obtain_escape_param(text))
      contents.font.out_color = colour
    when 'OO'
      contents.font.out_color.alpha = obtain_escape_param(text)
    #---
    when 'AMSF'
      case obtain_escape_param(text)
      when 0; reset_font_settings
      when 1; contents.font.bold = !contents.font.bold
      when 2; contents.font.italic = !contents.font.italic
      when 3; contents.font.outline = !contents.font.outline
      when 4; contents.font.shadow = !contents.font.shadow
      end
    #---
    when 'PX'
      pos[:x] = obtain_escape_param(text)
    when 'PY'
      pos[:y] = obtain_escape_param(text)
    #---
    when 'PIC'
      text.sub!(/\[(.*?)\]/, "")
      bmp = Cache.picture($1.to_s)
      rect = Rect.new(0, 0, bmp.width, bmp.height)
      contents.blt(pos[:x], pos[:y], bmp, rect)
    #---
    else
      window_base_process_escape_character_ams(code, text, pos)
    end
  end
  
end # Window_Base

#==============================================================================
# ■ Window_ChoiceList
#==============================================================================

class Window_ChoiceList < Window_Command
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias window_choicelist_initialize_ams initialize
  def initialize(message_window)
    window_choicelist_initialize_ams(message_window)
    setup_message_font
  end
  
end # Window_ChoiceList

#==============================================================================
# ■ Window_ScrollText
#==============================================================================

class Window_ScrollText < Window_Base
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias window_scrolltext_initialize_ams initialize
  def initialize
    window_scrolltext_initialize_ams
    setup_message_font
  end
  
end # Window_ScrollText

#==============================================================================
# ■ Window_NameMessage
#==============================================================================

class Window_NameMessage < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(message_window)
    @message_window = message_window
    super(0, 0, Graphics.width, fitting_height(1))
    self.opacity = YEA::MESSAGE::NAME_WINDOW_OPACITY
    self.z = @message_window.z + 1
    self.openness = 0
    setup_message_font
    @close_counter = 0
    deactivate
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    return if self.active
    return if self.openness == 0
    return if @closing
    @close_counter -= 1
    return if @close_counter > 0
    close
  end
  
  #--------------------------------------------------------------------------
  # start_close
  #--------------------------------------------------------------------------
  def start_close
    @close_counter = 4
    deactivate
  end
  
  #--------------------------------------------------------------------------
  # force_close
  #--------------------------------------------------------------------------
  def force_close
    @close_counter = 0
    deactivate
    close
  end
  
  #--------------------------------------------------------------------------
  # start
  #--------------------------------------------------------------------------
  def start(text, x_position)
    @text = text.clone
    set_width
    create_contents
    set_x_position(x_position)
    set_y_position
    refresh
    activate
    open
  end
  
  #--------------------------------------------------------------------------
  # set_width
  #--------------------------------------------------------------------------
  def set_width
    text = @text.clone
    dw = standard_padding * 2 + text_size(text).width
    dw += YEA::MESSAGE::NAME_WINDOW_PADDING * 2
    dw += calculate_size(text.slice!(0, 1), text) until text.empty?
    self.width = dw
  end
  
  #--------------------------------------------------------------------------
  # calculate_size
  #--------------------------------------------------------------------------
  def calculate_size(code, text)
    case code
    when "\e"
      return calculate_escape_code_width(obtain_escape_code(text), text)
    else
      return 0
    end
  end
  
  #--------------------------------------------------------------------------
  # calculate_escape_code_width
  #--------------------------------------------------------------------------
  def calculate_escape_code_width(code, text)
    dw = -text_size("\e").width - text_size(code).width
    case code.upcase
    when 'C', 'OC', 'OO'
      dw += -text_size("[" + obtain_escape_param(text).to_s + "]").width
      return dw
    when 'I'
      dw += -text_size("[" + obtain_escape_param(text).to_s + "]").width
      dw += 24
      return dw
    when '{'
      make_font_bigger
    when '}'
      make_font_smaller
    when 'FZ'
      contents.font.size = obtain_escape_param(text)
    when 'FN'
      text.sub!(/\[(.*?)\]/, "")
      font_name = $1.to_s
      font_name = Font.default_name if font_name.nil?
      contents.font.name = font_name.to_s
    when 'AMSF'
      case obtain_escape_param(text)
      when 0; reset_font_settings
      when 1; contents.font.bold = !contents.font.bold
      when 2; contents.font.italic = !contents.font.italic
      when 3; contents.font.outline = !contents.font.outline
      when 4; contents.font.shadow = !contents.font.shadow
      end
    else
      return dw
    end
  end
  
  #--------------------------------------------------------------------------
  # set_y_position
  #--------------------------------------------------------------------------
  def set_x_position(x_position)
    case x_position
    when 1 # Left
      self.x = @message_window.x
      self.x += YEA::MESSAGE::NAME_WINDOW_X_BUFFER
    when 2 # 3/10
      self.x = @message_window.x
      self.x += @message_window.width * 3 / 10
      self.x -= self.width / 2
    when 3 # Center
      self.x = @message_window.x
      self.x += @message_window.width / 2
      self.x -= self.width / 2
    when 4 # 7/10
      self.x = @message_window.x
      self.x += @message_window.width * 7 / 10
      self.x -= self.width / 2
    when 5 # Right
      self.x = @message_window.x + @message_window.width
      self.x -= self.width
      self.x -= YEA::MESSAGE::NAME_WINDOW_X_BUFFER
    end
    self.x = [[self.x, Graphics.width - self.width].min, 0].max
  end
  
  #--------------------------------------------------------------------------
  # set_y_position
  #--------------------------------------------------------------------------
  def set_y_position
    case $game_message.position
    when 0
      self.y = @message_window.height
      self.y -= YEA::MESSAGE::NAME_WINDOW_Y_BUFFER
    else
      self.y = @message_window.y - self.height
      self.y += YEA::MESSAGE::NAME_WINDOW_Y_BUFFER
    end
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    reset_font_settings
    @text = sprintf("\eC[%d]%s", YEA::MESSAGE::NAME_WINDOW_COLOUR, @text)
    draw_text_ex(YEA::MESSAGE::NAME_WINDOW_PADDING, 0, @text)
  end
  
end # Window_NameMessage

#==============================================================================
# ■ Window_Message
#==============================================================================

class Window_Message < Window_Base
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias window_message_initialize_ams initialize
  def initialize
    window_message_initialize_ams
    setup_message_font
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: window_width
  #--------------------------------------------------------------------------
  def window_width
    return Variable.message_width
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: window_height
  #--------------------------------------------------------------------------
  def window_height
    return fitting_height(Variable.message_rows)
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_all_windows
  #--------------------------------------------------------------------------
  alias window_message_create_all_windows_ams create_all_windows
  def create_all_windows
    window_message_create_all_windows_ams
    @name_window = Window_NameMessage.new(self)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: create_back_bitmap
  #--------------------------------------------------------------------------
  def create_back_bitmap
    @back_bitmap = Bitmap.new(width, height)
    rect1 = Rect.new(0, 0, Graphics.width, 12)
    rect2 = Rect.new(0, 12, Graphics.width, fitting_height(4) - 24)
    rect3 = Rect.new(0, fitting_height(4) - 12, Graphics.width, 12)
    @back_bitmap.gradient_fill_rect(rect1, back_color2, back_color1, true)
    @back_bitmap.fill_rect(rect2, back_color1)
    @back_bitmap.gradient_fill_rect(rect3, back_color1, back_color2, true)
  end
  
  #--------------------------------------------------------------------------
  # alias method: dispose_all_windows
  #--------------------------------------------------------------------------
  alias window_message_dispose_all_windows_ams dispose_all_windows
  def dispose_all_windows
    window_message_dispose_all_windows_ams
    @name_window.dispose
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_all_windows
  #--------------------------------------------------------------------------
  alias window_message_update_all_windows_ams update_all_windows
  def update_all_windows
    window_message_update_all_windows_ams
    @name_window.update
    @name_window.back_opacity = self.back_opacity
    @name_window.opacity = self.opacity
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_show_fast
  #--------------------------------------------------------------------------
  alias window_message_update_show_fast_ams update_show_fast
  def update_show_fast
    @show_fast = true if Input.press?(YEA::MESSAGE::TEXT_SKIP)
    window_message_update_show_fast_ams
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: input_pause
  #--------------------------------------------------------------------------
  def input_pause
    self.pause = true
    wait(10)
    Fiber.yield until Input.trigger?(:B) || Input.trigger?(:C) ||
      Input.press?(YEA::MESSAGE::TEXT_SKIP)
    Input.update
    self.pause = false
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: convert_escape_characters
  #--------------------------------------------------------------------------
  def convert_escape_characters(text)
    result = super(text.to_s.clone)
    result = namebox_escape_characters(result)
    result = message_escape_characters(result)
    return result
  end
  
  #--------------------------------------------------------------------------
  # new method: namebox_escape_characters
  #--------------------------------------------------------------------------
  def namebox_escape_characters(result)
    result.gsub!(/\eN\<(.+?)\>/i)  { namewindow($1, 1) }
    result.gsub!(/\eN1\<(.+?)\>/i) { namewindow($1, 1) }
    result.gsub!(/\eN2\<(.+?)\>/i) { namewindow($1, 2) }
    result.gsub!(/\eNC\<(.+?)\>/i) { namewindow($1, 3) }
    result.gsub!(/\eN3\<(.+?)\>/i) { namewindow($1, 3) }
    result.gsub!(/\eN4\<(.+?)\>/i) { namewindow($1, 4) }
    result.gsub!(/\eN5\<(.+?)\>/i) { namewindow($1, 5) }
    result.gsub!(/\eNR\<(.+?)\>/i) { namewindow($1, 5) }
    return result
  end
  
  #--------------------------------------------------------------------------
  # new method: namebox
  #--------------------------------------------------------------------------
  def namewindow(text, position)
    @name_text = text
    @name_position = position
    return ""
  end
  
  #--------------------------------------------------------------------------
  # new method: message_escape_characters
  #--------------------------------------------------------------------------
  def message_escape_characters(result)
    result.gsub!(/\eAF\[(-?\d+)]/i) { change_face($1.to_i) }
    return result
  end
  
  #--------------------------------------------------------------------------
  # new method: change_face
  #--------------------------------------------------------------------------
  def change_face(actor_id)
    actor_id = $game_party.members[actor_id.abs].id if actor_id <= 0
    actor = $game_actors[actor_id]
    return "" if actor.nil?
    $game_message.face_name = actor.face_name
    $game_message.face_index = actor.face_index
    return ""
  end
  
  #--------------------------------------------------------------------------
  # alias method: new_page
  #--------------------------------------------------------------------------
  alias window_message_new_page_ams new_page
  def new_page(text, pos)
    adjust_message_window_size
    window_message_new_page_ams(text, pos)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: new_line_x
  #--------------------------------------------------------------------------
  def new_line_x
    return $game_message.face_name.empty? ? 0 : YEA::MESSAGE::FACE_INDENT_X
  end
  
  #--------------------------------------------------------------------------
  # new method: adjust_message_window_size
  #--------------------------------------------------------------------------
  def adjust_message_window_size
    self.height = window_height
    self.width = window_width
    create_contents
    update_placement
    self.x = (Graphics.width - self.width) / 2
    start_name_window
  end
  
  #--------------------------------------------------------------------------
  # new method: clear_name_window
  #--------------------------------------------------------------------------
  def clear_name_window
    @name_text = ""
    @name_position = 0
  end
  
  #--------------------------------------------------------------------------
  # new method: start_name_window
  #--------------------------------------------------------------------------
  def start_name_window
    return if @name_text == ""
    @name_window.start(@name_text, @name_position)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: fiber_main
  #--------------------------------------------------------------------------
  def fiber_main
    $game_message.visible = true
    update_background
    update_placement
    loop do
      process_all_text if $game_message.has_text?
      process_input
      $game_message.clear
      @gold_window.close
      @name_window.start_close
      Fiber.yield
      break unless text_continue?
    end
    close_and_wait
    $game_message.visible = false
    @fiber = nil
  end
  
  #--------------------------------------------------------------------------
  # alias method: open_and_wait
  #--------------------------------------------------------------------------
  alias window_message_open_and_wait_ams open_and_wait
  def open_and_wait
    clear_name_window
    adjust_message_window_size
    window_message_open_and_wait_ams
  end
  
  #--------------------------------------------------------------------------
  # alias method: close_and_wait
  #--------------------------------------------------------------------------
  alias window_message_close_and_wait_ams close_and_wait
  def close_and_wait
    @name_window.force_close
    window_message_close_and_wait_ams
  end
  
  #--------------------------------------------------------------------------
  # alias method: all_close?
  #--------------------------------------------------------------------------
  alias window_message_all_close_ams all_close?
  def all_close?
    return window_message_all_close_ams && @name_window.close?
  end
  
  #--------------------------------------------------------------------------
  # alias method: process_escape_character
  #--------------------------------------------------------------------------
  alias window_message_process_escape_character_ams process_escape_character
  def process_escape_character(code, text, pos)
    case code.upcase
    when 'W' # Wait
      wait(obtain_escape_param(text))
    else
      window_message_process_escape_character_ams(code, text, pos)
    end
  end
  
end # Window_Message

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================