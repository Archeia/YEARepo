#==============================================================================
# 
# ▼ Yanfly Engine Ace - Common Event Tiles v1.01
# -- Last Updated: 2011.12.06
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-CommonEventTiles"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.06 - Bugfix that prevented on touch events from triggering.
# 2011.12.04 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Rather than flooding the entire map with events just to run a single common
# event, bind common events to terrain tags that trigger upon stepping on them.
# This will cause all of the tiles marked by those terrain tags to spring up
# the common event when the player steps over them.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Tileset Notetags - These notetags go in the tileset notebox in the database.
# -----------------------------------------------------------------------------
# <event x: y>
# <event x: y, y>
# Sets the tiles marked with terrain tag y to trigger common event x. The
# common event will run each time the player steps over a tile with the
# respective terrain tags.
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
  module TILESET
    
    COMMON_EVENT = /<(?:EVENT|event)[ ]*(\d+):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
  end # TILESET
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_cet load_database; end
  def self.load_database
    load_database_cet
    load_notetags_cet
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_cet
  #--------------------------------------------------------------------------
  def self.load_notetags_cet
    groups = [$data_tilesets]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_cet
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Tileset
#==============================================================================

class RPG::Tileset
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :cevents
  attr_accessor :cevent_tiles
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_st
  #--------------------------------------------------------------------------
  def load_notetags_cet
    @cevents = {}
    @cevent_tiles = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::TILESET::COMMON_EVENT
        @cevents[$1.to_i] = []
        array = @cevents[$1.to_i]
        $2.scan(/\d+/).each { |num| 
        array.push(num.to_i) if num.to_i > 0
        @cevent_tiles.push(num.to_i) if num.to_i > 0 }
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Tileset

#==============================================================================
# ■ Game_Map
#==============================================================================

class Game_Map
  
  #--------------------------------------------------------------------------
  # new method: common_event_floor?
  #--------------------------------------------------------------------------
  def common_event_floor?(dx, dy)
    return (valid?(dx, dy) and common_event_tag?(dx, dy))
  end
  
  #--------------------------------------------------------------------------
  # new method: common_event_tag?
  #--------------------------------------------------------------------------
  def common_event_tag?(dx, dy)
    return tileset.cevent_tiles.include?(terrain_tag(dx, dy))
  end
  
  #--------------------------------------------------------------------------
  # new method: tile_common_event
  #--------------------------------------------------------------------------
  def tile_common_event(dx, dy)
    for key in tileset.cevents
      return key[0] if key[1].include?(terrain_tag(dx, dy))
    end
  end
  
end # Game_Map

#==============================================================================
# ■ Game_Player
#==============================================================================

class Game_Player < Game_Character
  
  #--------------------------------------------------------------------------
  # alias method: check_touch_event
  #--------------------------------------------------------------------------
  alias check_touch_event_cet check_touch_event
  def check_touch_event
    return false if in_airship?
    check_tile_common_event
    check_touch_event_cet
  end
  
  #--------------------------------------------------------------------------
  # new method: check_tile_common_event
  #--------------------------------------------------------------------------
  def check_tile_common_event
    return unless $game_map.common_event_floor?(@x, @y)
    $game_temp.reserve_common_event($game_map.tile_common_event(@x, @y))
  end
  
end # Game_Player

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================