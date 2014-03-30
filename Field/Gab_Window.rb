#==============================================================================
# 
# ▼ Yanfly Engine Ace - Gab Window v1.00
# -- Last Updated: 2012.01.23
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-GabWindow"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.23 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Sometimes there's random jibber jabber that does not warrant a message box.
# The Gab Window fulfills that jibber jabber by placing such text outside of
# the message window box and at the corner of the screen. The gab text will
# appear briefly and then disappear, not showing up again until the gab text is
# updated with something else.
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
# These script calls can only be used from a map. The Gab Window will not
# appear in battle or anywhere else.
# 
# gab(string)
# This will cause the Gab Window to appear with the string shown. Text codes
# can be used inside the string. When using text codes, remember to use "\\"
# for a single slash.
# 
# gab(string, actor_id)
# This will cause the Gab Window to appear with the string and the actor's
# sprite. Text codes can be used inside the string. When using text codes,
# remember to use "\\" for a single slash. There are special ID's that
# can be used in place of the actor_id:
#      0 - Party Leader
#     -1 - 1st non-leader member.
#     -2 - 2nd non-leader member. So on.
# 
# gab(string, char_name, char_index)
# This will cause the Gab Window to appear with the string shown and a sprite
# using char_name as the filename of the character sprite and char_index as the
# index of the character sprite. Text codes can be used inside the string. When
# using text codes, remember to use "\\" for a single slash.
# 
# clear_gab
# This will cause the gab window to clear itself and immediately go invisible.
# This will also allow a previously used gab prior to the clearing to reappear
# immediately if followed up by another gab.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script is compatible with Yanfly Engine Ace - Ace Message System v1.04+.
# The positioning of these two scripts relative to each other does not matter.
# 
#==============================================================================

module YEA
  module GAB_WINDOW
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Gab Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These are the general settings used involving the Gab Window. Here, you
    # can change the Y location of the window (remember, it's two lines tall),
    # default font size, the position of the character sprites, and the amount
    # of time the Gab Window will remain fully visible before fading.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    Y_LOCATION    = 36   # This sets the Y location of the gab window.
    FONT_SIZE     = 18   # This is the font size used for the gab window.
    
    CHAR_X_POS    = 24   # This sets the X location of the character shown.
    CHAR_Y_POS    = 40   # This sets the Y location of the character shown.
    
    BASE_TIME     = 60   # Minimum frames the window will stay visible for.
    TIME_PER_TEXT =  4   # Frames added per text character.
    
    HIDE_SWITCH   = 25   # If switch is ON, Gab Window will not appear.
    
  end # GAB_WINDOW
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
  # self.hide_gab_window
  #--------------------------------------------------------------------------
  def self.hide_gab_window
    return false if YEA::GAB_WINDOW::HIDE_SWITCH <= 0
    return $game_switches[YEA::GAB_WINDOW::HIDE_SWITCH]
  end
    
end # Switch

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # new method: gab
  #--------------------------------------------------------------------------
  def gab(text, case1 = nil, case2 = nil)
    return unless SceneManager.scene_is?(Scene_Map)
    if case1.is_a?(Integer)
      case1 = $game_party.members[case1.abs].id if case1 <= 0
      actor = $game_actors[case1]
      if !actor.nil?
        case1 = actor.character_name
        case2 = actor.character_index
      end
    elsif case1.is_a?(String)
      case2 = 0 if case2.nil?
    end
    SceneManager.scene.setup_gab_window(text, case1, case2)
  end
  
  #--------------------------------------------------------------------------
  # new method: clear_gab
  #--------------------------------------------------------------------------
  def clear_gab
    return unless SceneManager.scene_is?(Scene_Map)
    SceneManager.scene.clear_gab
  end
  
end # Game_Interpreter

#==============================================================================
# ■ Window_Gab
#==============================================================================

class Window_Gab < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    dx = -standard_padding
    dy = YEA::GAB_WINDOW::Y_LOCATION
    super(dx, dy, Graphics.width + standard_padding, fitting_height(2))
    setup_message_font if $imported["YEA-MessageSystem"]
    clear
  end
  
  #--------------------------------------------------------------------------
  # clear
  #--------------------------------------------------------------------------
  def clear
    self.opacity = 0
    self.contents_opacity = 0
    @opacity_timer = 0
    clear_settings
  end
  
  #--------------------------------------------------------------------------
  # clear_settings
  #--------------------------------------------------------------------------
  def clear_settings
    @text = ""
    @graphic = nil
    @index = nil
  end
  
  #--------------------------------------------------------------------------
  # reset_font_settings
  #--------------------------------------------------------------------------
  def reset_font_settings
    super
    contents.font.size = YEA::GAB_WINDOW::FONT_SIZE
  end
  
  #--------------------------------------------------------------------------
  # setup
  #--------------------------------------------------------------------------
  def setup(text, graphic, index)
    return if settings_match?(text, graphic, index)
    @text = text
    @graphic = graphic
    @index = index
    @opacity_timer = YEA::GAB_WINDOW::BASE_TIME
    @opacity_timer += YEA::GAB_WINDOW::TIME_PER_TEXT * @text.size
    refresh
  end
  
  #--------------------------------------------------------------------------
  # settings_match?
  #--------------------------------------------------------------------------
  def settings_match?(text, graphic, index)
    return false if @text != text
    return false if @graphic != graphic
    return false if @index != index
    return true
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    self.visible = show_window?
    update_contents_opacity
  end
  
  #--------------------------------------------------------------------------
  # show_window?
  #--------------------------------------------------------------------------
  def show_window?
    return false if $game_message.visible && $game_message.position == 0
    return !Switch.hide_gab_window
  end
  
  #--------------------------------------------------------------------------
  # update_contents_opacity
  #--------------------------------------------------------------------------
  def update_contents_opacity
    if @opacity_timer > 0 && self.contents_opacity >= 255
      return @opacity_timer -= 1
    end
    self.contents_opacity += @opacity_timer > 0 ? 16 : -4
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_background_colour
    draw_graphic
    draw_text_ex(48, line_height / 2, @text)
  end
  
  #--------------------------------------------------------------------------
  # draw_background_colour
  #--------------------------------------------------------------------------
  def draw_background_colour
    temp_rect = contents.rect.clone
    temp_rect.width *= 0.667
    back_colour1 = Color.new(0, 0, 0, 192)
    back_colour2 = Color.new(0, 0, 0, 0)
    contents.gradient_fill_rect(temp_rect, back_colour1, back_colour2)
  end
  
  #--------------------------------------------------------------------------
  # draw_graphic
  #--------------------------------------------------------------------------
  def draw_graphic
    char_name = @graphic
    char_index = @index
    dx = YEA::GAB_WINDOW::CHAR_X_POS
    dy = YEA::GAB_WINDOW::CHAR_Y_POS
    draw_character(char_name, char_index, dx, dy)
  end
  
end # Window_Gab

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: create_all_windows
  #--------------------------------------------------------------------------
  alias scene_map_create_all_windows_gab create_all_windows
  def create_all_windows
    scene_map_create_all_windows_gab
    create_gab_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_gab_window
  #--------------------------------------------------------------------------
  def create_gab_window
    @gab_window = Window_Gab.new
  end
  
  #--------------------------------------------------------------------------
  # new method: setup_gab_window
  #--------------------------------------------------------------------------
  def setup_gab_window(text, graphic = nil, index = nil)
    @gab_window.setup(text, graphic, index)
  end
  
  #--------------------------------------------------------------------------
  # new method: clear_gab
  #--------------------------------------------------------------------------
  def clear_gab
    @gab_window.clear
  end
  
  #--------------------------------------------------------------------------
  # alias method: pre_transfer
  #--------------------------------------------------------------------------
  alias scene_map_pre_transfer_gab pre_transfer
  def pre_transfer
    scene_map_pre_transfer_gab
    clear_gab
  end
  
end # Scene_Map

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================