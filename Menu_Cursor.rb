#==============================================================================
# 
# ▼ Yanfly Engine Ace - Menu Cursor v1.00
# -- Last Updated: 2012.01.16
# -- Level: Easy
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-MenuCursor"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.16 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script creates visible menu cursors for your game. Whenever a window is
# selectable and active, the menu cursor will appear for it. Menu cursors catch
# the player's attention better and helps the player figure out quickly which
# window became the active window. Also included with this script is the
# ability to disable the highlighted selection bar since the window menu cursor
# can replace it.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Make sure you have a cursor image within your project's Graphics\System\
# folder. By default, the cursor's filename should be MenuCursor.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module MENU_CURSOR
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust the general settings here for the menu cursor, such as the
    # filename used for the menu cursor, the x position buffer and the y
    # position buffer for the cursor.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    FILENAME = "MenuCursor"     # Filename used for cursor in Graphics\System\
    BUFFER_X = -4               # X position buffer for icon.
    BUFFER_Y = 16               # Y position buffer for icon.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Remove Highlighted Selection Bar -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Normally, when an entry is selected, that entry is highlighted. You can
    # opt to turn this effect off.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    REMOVE_HIGHLIGHTED_SELECTION_BAR = false
    
  end # MENU_CURSOR
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Sprite_MenuCursor
#==============================================================================

class Sprite_MenuCursor < Sprite_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(window)
    super(window.viewport)
    @window = window
    create_bitmap
  end
  
  #--------------------------------------------------------------------------
  # create_bitmap
  #--------------------------------------------------------------------------
  def create_bitmap
    self.bitmap = Cache.system(YEA::MENU_CURSOR::FILENAME)
    self.z = @window.z + 100
    self.opacity = 0
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    update_visibility
    update_position
  end
  
  #--------------------------------------------------------------------------
  # update_visibility
  #--------------------------------------------------------------------------
  def update_visibility
    self.visible = visible_case
    self.opacity += opacity_rate
  end
  
  #--------------------------------------------------------------------------
  # visible_case
  #--------------------------------------------------------------------------
  def visible_case
    return @window.visible
  end
  
  #--------------------------------------------------------------------------
  # opacity_rate
  #--------------------------------------------------------------------------
  def opacity_rate
    rate = 16
    return -rate unless @window.active
    return rate
  end
  
  #--------------------------------------------------------------------------
  # update_position
  #--------------------------------------------------------------------------
  def update_position
    rect = @window.cursor_rect
    self.x = @window.x + rect.x - @window.ox + YEA::MENU_CURSOR::BUFFER_X
    self.y = @window.y + rect.y - @window.oy + YEA::MENU_CURSOR::BUFFER_Y
  end
  
end # Sprite_MenuCursor

#==============================================================================
# ■ Window
#==============================================================================

class Window
  
  #--------------------------------------------------------------------------
  # alias method: windowskin=
  #--------------------------------------------------------------------------
  alias window_windowskin_change_cursor windowskin=
  def windowskin=(skin)
    if YEA::MENU_CURSOR::REMOVE_HIGHLIGHTED_SELECTION_BAR
      skin = skin.dup
      skin.clear_rect(64, 64, 32, 32)
    end
    window_windowskin_change_cursor(skin)
  end
  
end # Window

#==============================================================================
# ■ Scene_Base
#==============================================================================

class Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: post_start
  #--------------------------------------------------------------------------
  alias scene_base_post_start_cursor post_start
  def post_start
    create_menu_cursors
    scene_base_post_start_cursor
  end
  
  #--------------------------------------------------------------------------
  # new method: create_menu_cursors
  #--------------------------------------------------------------------------
  def create_menu_cursors
    @menu_cursors = []
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      create_cursor_sprite(ivar) if ivar.is_a?(Window_Selectable)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: create_cursor_sprite
  #--------------------------------------------------------------------------
  def create_cursor_sprite(window)
    @menu_cursors.push(Sprite_MenuCursor.new(window))
  end
  
  #--------------------------------------------------------------------------
  # alias method: pre_terminate
  #--------------------------------------------------------------------------
  alias scene_base_pre_terminate_cursor pre_terminate
  def pre_terminate
    dispose_menu_cursors
    scene_base_pre_terminate_cursor
  end
  
  #--------------------------------------------------------------------------
  # new method: dispose_menu_cursors
  #--------------------------------------------------------------------------
  def dispose_menu_cursors
    @menu_cursors.each { |cursor| cursor.dispose }
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_basic
  #--------------------------------------------------------------------------
  alias scene_base_update_basic_cursor update_basic
  def update_basic
    scene_base_update_basic_cursor
    update_menu_cursors
  end
  
  #--------------------------------------------------------------------------
  # new method: update_menu_cursors
  #--------------------------------------------------------------------------
  def update_menu_cursors
    @menu_cursors.each { |cursor| cursor.update }
  end
  
end # Scene_Base

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================