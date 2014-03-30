#==============================================================================
# 
# ▼ Yanfly Engine Ace - Parallax Lock v1.00
# -- Last Updated: 2012.02.19
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ParallaxLock"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.02.19 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script gives developers the ability to lock a map's parallax and cause
# it to not scroll by either vertically, horizontally, or both. Furthermore,
# this script also enables tile locking the map parallax, allowing the parallax
# to only move in conjunction with the player.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Map Notetags - These notetags go in the map notebox in a map's properties.
# -----------------------------------------------------------------------------
# <lock parallax x>
# This prevents the map's parallax from scrolling horizontally.
# 
# <lock parallax y>
# This prevents the map's parallax from scrolling vertically.
# 
# <full lock parallax>
# This prevents the map's parallax from scrolling at all.
# 
# <tile lock parallax>
# This causes the map's parallax to be locked to tiles and scrolls with them.
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

module YEA
  module REGEXP
  module MAP
    
    LOCK_PARALLAX_X = /<(?:LOCK_PARALLAX_X|lock parallax x)>/i
    LOCK_PARALLAX_Y = /<(?:LOCK_PARALLAX_Y|lock parallax y)>/i
    FULL_LOCK_PARALLAX = /<(?:FULL_LOCK_PARALLAX|full lock parallax)>/i
    TILE_LOCK_PARALLAX = /<(?:TILE_LOCK_PARALLAX|tile lock parallax)>/i
    
  end # MAP
  end # REGEXP
end # YEA

#==============================================================================
# ■ RPG::Map
#==============================================================================

class RPG::Map
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :parallax_lock_x
  attr_accessor :parallax_lock_y
  attr_accessor :parallax_tile_lock
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_paralock
  #--------------------------------------------------------------------------
  def load_notetags_paralock
    @parallax_lock_x = false
    @parallax_lock_y = false
    @parallax_tile_lock = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::MAP::LOCK_PARALLAX_X
        @parallax_lock_x = true
        @parallax_tile_lock = false
      when YEA::REGEXP::MAP::LOCK_PARALLAX_Y
        @parallax_lock_y = true
        @parallax_tile_lock = false
      when YEA::REGEXP::MAP::FULL_LOCK_PARALLAX
        @parallax_lock_x = true
        @parallax_lock_y = true
        @parallax_tile_lock = false
      when YEA::REGEXP::MAP::TILE_LOCK_PARALLAX
        @parallax_lock_x = false
        @parallax_lock_y = false
        @parallax_tile_lock = true
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Map

#==============================================================================
# ■ Game_Map
#==============================================================================

class Game_Map
  
  #--------------------------------------------------------------------------
  # alias method: setup
  #--------------------------------------------------------------------------
  alias game_map_setup_parallax_paralock setup_parallax
  def setup_parallax
    @map.load_notetags_paralock
    game_map_setup_parallax_paralock
  end
  
  #--------------------------------------------------------------------------
  # new method: parallax_lock_x?
  #--------------------------------------------------------------------------
  def parallax_lock_x?
    return @map.parallax_lock_x
  end
  
  #--------------------------------------------------------------------------
  # new method: parallax_lock_y?
  #--------------------------------------------------------------------------
  def parallax_lock_y?
    return @map.parallax_lock_y
  end
  
  #--------------------------------------------------------------------------
  # new method: parallax_tile_lock?
  #--------------------------------------------------------------------------
  def parallax_tile_lock?
    return @map.parallax_tile_lock
  end
  
  #--------------------------------------------------------------------------
  # alias method: parallax_ox
  #--------------------------------------------------------------------------
  alias game_map_parallax_ox_paralock parallax_ox
  def parallax_ox(bitmap)
    return 0 if parallax_lock_x?
    return @display_x * 32 if parallax_tile_lock?
    return game_map_parallax_ox_paralock(bitmap)
  end
  
  #--------------------------------------------------------------------------
  # alias method: parallax_oy
  #--------------------------------------------------------------------------
  alias game_map_parallax_oy_paralock parallax_oy
  def parallax_oy(bitmap)
    return 0 if parallax_lock_y?
    return @display_y * 32 if parallax_tile_lock?
    return game_map_parallax_oy_paralock(bitmap)
  end
  
end # Game_Map

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================