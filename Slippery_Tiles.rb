#==============================================================================
# 
# ▼ Yanfly Engine Ace - Slippery Tiles v1.00
# -- Last Updated: 2011.12.03
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-SlipperyTiles"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.03 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Want slippery tiles without needing to make hundreds of events? Now you can!
# This script binds slippery tile properties to individual tiles through usage
# of notetags and terrain tags.
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
# <slippery: x>
# <slippery: x, x>
# Sets the tiles marked with terrain tag x to be slippery for that particular
# tileset. When the player walks over a slippery terrain, the player will keep
# moving forward until stopped by an object or until the player lands on ground
# without slippery properties.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module SLIPPERY_TILES
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Sliding Animation -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Set what sliding frame you want characters to use when they're on
    # slippery tiles. Standing frame is 1.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    SLIDE_FRAME = 2
    
  end # SLIPPERY_TILES
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module TILESET
    
    SLIPPERY = /<(?:SLIPPERY|slippery tile):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
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
  class <<self; alias load_database_st load_database; end
  def self.load_database
    load_database_st
    load_notetags_st
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_st
  #--------------------------------------------------------------------------
  def self.load_notetags_st
    groups = [$data_tilesets]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_st
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
  attr_accessor :slippery
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_st
  #--------------------------------------------------------------------------
  def load_notetags_st
    @slippery = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::TILESET::SLIPPERY
        $1.scan(/\d+/).each { |num| 
        @slippery.push(num.to_i) if num.to_i > 0 }
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
  # new method: slippery_floor?
  #--------------------------------------------------------------------------
  def slippery_floor?(dx, dy)
    return (valid?(dx, dy) && slippery_tag?(dx, dy))
  end
  
  #--------------------------------------------------------------------------
  # new method: slippery_tag?
  #--------------------------------------------------------------------------
  def slippery_tag?(dx, dy)
    return tileset.slippery.include?(terrain_tag(dx, dy))
  end
  
end # Game_Map

#==============================================================================
# ■ Game_CharacterBase
#==============================================================================

class Game_CharacterBase
  
  #--------------------------------------------------------------------------
  # new method: on_slippery_floor?
  #--------------------------------------------------------------------------
  def on_slippery_floor?; $game_map.slippery_floor?(@x, @y); end
  
  #--------------------------------------------------------------------------
  # new method: slippery_pose?
  #--------------------------------------------------------------------------
  def slippery_pose?
    return false unless on_slippery_floor?
    return false if @step_anime
    return true
  end
  
end # Game_CharacterBase

#==============================================================================
# ■ Game_Player
#==============================================================================

class Game_Player < Game_Character
  
  #--------------------------------------------------------------------------
  # alias method: dash?
  #--------------------------------------------------------------------------
  alias game_player_dash_st dash?
  def dash?
    return false if on_slippery_floor?
    return game_player_dash_st
  end
  
  #--------------------------------------------------------------------------
  # alias method: update
  #--------------------------------------------------------------------------
  alias game_player_update_st update
  def update
    game_player_update_st
    update_slippery
  end
  
  #--------------------------------------------------------------------------
  # new method: update_slippery
  #--------------------------------------------------------------------------
  def update_slippery
    return if $game_map.interpreter.running?
    return unless on_slippery_floor?
    return if moving?
    move_straight(@direction)
  end
  
  #--------------------------------------------------------------------------
  # new method: pattern
  #--------------------------------------------------------------------------
  def pattern 
    return YEA::SLIPPERY_TILES::SLIDE_FRAME if slippery_pose?
    return @pattern
  end
  
end # Game_Player

#==============================================================================
# ■ Game_Follower
#==============================================================================

class Game_Follower < Game_Character
  
  #--------------------------------------------------------------------------
  # new method: pattern
  #--------------------------------------------------------------------------
  def pattern 
    return YEA::SLIPPERY_TILES::SLIDE_FRAME if slippery_pose?
    return @pattern
  end
  
end # Game_Follower

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================