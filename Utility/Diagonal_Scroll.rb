#==============================================================================
# 
# ▼ Yanfly Engine Ace - Diagonal Scroll v1.00
# -- Last Updated: 2011.12.30
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-DiagonalScroll"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.30 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Diagonal scrolling was an old feature found in the older RPG Makers, but was
# taken out of RPG Maker VX and remains absent in RPG Maker VX Ace. As such,
# this script will reproduce the same scrolling effect that was found in the
# previous versions of RPG Maker.
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
# scroll_lower_left(x)
# scroll_lower_left(x, y)
# 
# scroll_lower_right(x)
# scroll_lower_right(x, y)
# 
# scroll_upper_left(x)
# scroll_upper_left(x, y)
# 
# scroll_upper_right(x)
# scroll_upper_right(x, y)
# 
# This will scroll the screen x tiles diagonally in the marked direction. By
# default, the scrolling speed will be 4. If you wish to change the scrolling
# speed, use the script call method with y for a different speed value.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # new method: scroll_lower_left
  #--------------------------------------------------------------------------
  def scroll_lower_left(distance, speed = 4)
    $game_map.start_scroll(1, distance, speed)
  end
  
  #--------------------------------------------------------------------------
  # new method: scroll_lower_right
  #--------------------------------------------------------------------------
  def scroll_lower_right(distance, speed = 4)
    $game_map.start_scroll(3, distance, speed)
  end
  
  #--------------------------------------------------------------------------
  # new method: scroll_upper_left
  #--------------------------------------------------------------------------
  def scroll_upper_left(distance, speed = 4)
    $game_map.start_scroll(7, distance, speed)
  end
  
  #--------------------------------------------------------------------------
  # new method: scroll_upper_right
  #--------------------------------------------------------------------------
  def scroll_upper_right(distance, speed = 4)
    $game_map.start_scroll(9, distance, speed)
  end
  
end # Game_Interpreter

#==============================================================================
# ■ Game_Map
#==============================================================================

class Game_Map
  
  #--------------------------------------------------------------------------
  # overwrite method: do_scroll
  #--------------------------------------------------------------------------
  def do_scroll(direction, distance)
    case direction
    when 1
      scroll_down(distance)
      scroll_left(distance)
    when 2
      scroll_down(distance)
    when 3
      scroll_down(distance)
      scroll_right(distance)
    when 4
      scroll_left(distance)
    when 6
      scroll_right(distance)
    when 7
      scroll_up(distance)
      scroll_left(distance)
    when 8
      scroll_up(distance)
    when 9
      scroll_up(distance)
      scroll_right(distance)
    end
  end
  
end # Game_Map

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================